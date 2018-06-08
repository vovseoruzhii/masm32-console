.386
.model flat,stdcall
includelib \masm32\lib\kernel32.lib
extern ExitProcess@4:near
extern GetStdHandle@4:near
extern WriteConsoleA@20:near
extern ReadConsoleA@20:near

_DATA SEGMENT

szStr  db "Write <q> to quit or <c> to call caller",0Dh,0Ah,0
szCaller db 07h,"Hello there I'm caller",0Dh,0Ah,0
szError  db "Wrong characcter try again!",0Dh,0Ah,0
Buffer db 255 dup(0)

_DATA ENDS

_TEXT SEGMENT
START:

call main


push 0
call ExitProcess@4
;--------
main proc

push offset szStr
call cout

_wwhile:
push offset Buffer
call cin
mov eax,offset Buffer
cmp byte ptr[eax],'q'
jz _wwhile_end

cmp byte ptr[eax],'c'
jz _caller
jnz _error

_caller:
push offset szCaller
call cout
jmp _wwhile

_error:
push offset szError
call cout
jmp _wwhile

_wwhile_end:

ret
main endp
;--------

;--------
cout proc;param = pString,locals = handle_out,cnt
push ebp
mov ebp,esp
add esp,-8
push -0Bh
call GetStdHandle@4
mov dword ptr[ebp-4],eax
push dword ptr[ebp+8]
call strlen
mov ebx,ebp
add ebx,-8

push 0
push ebx
push eax
push dword ptr[ebp+8]
push dword ptr[ebp-4]
call WriteConsoleA@20

mov esp,ebp
pop ebp
ret 4 
cout endp
;--------
;--------
cin proc;param = pBuffer,locals= handle_in,cnt
push ebp
mov ebp,esp
add esp,-8
push -0Ah
call GetStdHandle@4
mov dword ptr[ebp-4],eax
mov ebx,ebp
add ebx,-8

push 0
push ebx
push 255
push dword ptr[ebp+8]
push dword ptr[ebp-4]
call ReadConsoleA@20

mov eax,dword ptr[ebx]
add eax,-2;factical lenght
mov ebx,dword ptr[ebp+8]
mov dword ptr[ebx+eax],0

mov esp,ebp
pop ebp
ret 4
cin endp
;--------
strlen proc;param = pString
push ebp
mov ebp,esp

mov eax,dword ptr[ebp+8]
mov ebx,0

_while:

cmp byte ptr[eax],0
jz _while_end

inc ebx
inc eax
jmp _while
_while_end:

mov eax,ebx

mov esp,ebp
pop ebp
ret 4
strlen endp
_TEXT ENDS
END START