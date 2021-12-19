@ECHO off

:start
ECHO    ________    _______   _________        ________  _________   ___       __      
ECHO   ^|\   ___  \ ^|\  ___ \ ^|\___   ___\     ^|\  _____\^|\___   ___\^|\  \     ^|\  \    
ECHO   \ \  \\ \  \\ \   __/^|\^|___ \  \_^|     \ \  \__/ \^|___ \  \_^|\ \  \    \ \  \   
ECHO    \ \  \\ \  \\ \  \_^|/__   \ \  \       \ \   __\     \ \  \  \ \  \  __\ \  \  
ECHO  ___\ \  \\ \  \\ \  \_^|\ \   \ \  \       \ \  \_^|      \ \  \  \ \  \^|\__\_\  \ 
ECHO ^|\__\\ \__\\ \__\\ \_______\   \ \__\       \ \__\        \ \__\  \ \____________\
ECHO \^|__^| \^|__^| \^|__^| \^|_______^|    \^|__^|        \^|__^|         \^|__^|   \^|____________^|
ECHO.

:typestep
ECHO What kind of project do you want to make?
ECHO 1. Console Application
ECHO 2. WPF Application
ECHO 3. WinForms Application
ECHO 4. ASP.NET Core Web App
ECHO.

set choice=
set /p choice=Enter the number of your choice: 

if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto consoleapp
if '%choice%'=='2' goto wpfapp
if '%choice%'=='3' goto winformsapp
if '%choice%'=='4' goto aspnetcorewebapp
ECHO "%choice%" is not valid, try again.
ECHO.
goto typestep

:consoleapp
set projectType=console
goto namingstep

:wpfapp
set projectType=wpf
goto namingstep

:winformsapp
set projectType=winforms
goto namingstep

:aspnetcorewebapp
set projectType=webapp
goto namingstep

:namingstep
ECHO.
set projectName=
set /p projectName=Enter the name of your project: 

:testingstep
ECHO.
ECHO Do you want unit testing?
ECHO 1. Yes
ECHO 2. No
ECHO.
set choice=
set /p choice=Enter the number of your choice: 

if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto yestesting
if '%choice%'=='2' goto notesting
ECHO "%choice%" is not valid, try again.
ECHO.
goto testingstep

:yestesting
set projectTesting=true
goto moqstep

:notesting
set projectTesting=false
goto initialize

:moqstep
ECHO.
ECHO Do you want to add moq?
ECHO 1. Yes
ECHO 2. No
ECHO.
set choice=
set /p choice=Enter the number of your choice: 

if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto yesmoq
if '%choice%'=='2' goto nomoq
ECHO "%choice%" is not valid, try again.
ECHO.
goto moqstep

:yesmoq
set projectMoq=true
goto initialize

:nomoq
set projectMoq=false
goto initialize

:initialize
ECHO.
dotnet new sln
dotnet new "%projectType%" -n "%projectName%"
dotnet sln add "%projectName%"/"%projectName%".csproj

if '%projectTesting%' == '2' goto end

dotnet new nunit -n "%projectName%"Tests
dotnet add "%projectName%"Tests/"%projectName%"Tests.csproj reference "%projectName%"/"%projectName%".csproj
dotnet sln add "%projectName%"Tests/"%projectName%"Tests.csproj

if '%projectMoq%' == '2' goto end

cd "%projectName%"Tests
dotnet add package moq
cd ..

:end