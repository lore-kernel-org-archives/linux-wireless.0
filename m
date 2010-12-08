Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm7-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.66]:48026 "HELO
	nm7-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755128Ab0LHS6Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 13:58:16 -0500
Message-ID: <368544.4876.qm@web120203.mail.ne1.yahoo.com>
Date: Wed, 8 Dec 2010 10:58:15 -0800 (PST)
From: Chris Pechard <chrispechard@yahoo.com>
Subject: carl9170fw: custom build incompatibility issue
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I tried to build an unmodified carl9170fw firmware based on 1.9.0  
tag.Unfortunately when dropping it in my /lib/firmware directory, I get  
unsupported firmware when connecting my usb wifi device. If I used the  
precompiled version based on the same tag, everything is working fine.  Below is 

the config I used to build the firmware. Any help to get this  working would be 
appreciated.

Best regards,
Chris

Running under Ubuntu 10.10, 32 bits:  kernel 2.6.35-22-generic #35-Ubuntu SMP 
Sat Oct 16 20:36:48 UTC 2010 i686 GNU/Linux

Installing the custom build firmware
-----------------------------------
$ sudo cp carlfw/carl9170.fw /lib/firmware/carl9170-1.fw 
$  dmesg
[ 4414.555514] usb 2-1.2: new high speed USB device using ehci_hcd and address 
23
[ 4414.771448] usb 2-1.2: reset high speed USB device using ehci_hcd and address 
23
[ 4414.902898] usb 2-1.2: unsupported firmware.

Installing the prebuilt version
-----------------------------
$ sudo cp ../carl9170fw-cur/carl9170-1.fw /lib/firmware/carl9170-1.fw 
# dmesg -c
[ 3645.489335] usb 2-1.2: new high speed USB device using ehci_hcd and address 
18
[ 3645.706236] usb 2-1.2: reset high speed USB device using ehci_hcd and address 
18
[ 3645.836634] usb 2-1.2: driver   API: 1.8.8.3 2010-09-28 [1-1]
[ 3645.836643] usb 2-1.2: firmware API: 1.9.0 2010-10-12


Firmware build config
----------------------
$ ./autogen.sh 
Configuring...
make: Entering directory `/data/data/dev/carl9170fw-1.9.0/config'
make: Nothing to be done for `config'.
make: Leaving directory `/data/data/dev/carl9170fw-1.9.0/config'
*
* CARL9170 Firmware Configuration
*
*
* General
*
Update/Generate new release/revision files (CARL9170FW_MAKE_RELEASE) [Y/n] 
  Major CARL9170 Firmware Revision (CARL9170FW_RELEASE_VERSION) [1] 
*
* Selectable Hardware Options
*
Receiver Max. Frame Length
  1. 4096 (CARL9170FW_RX_FRAME_LEN_4096)
> 2. 8192 (CARL9170FW_RX_FRAME_LEN_8192)
  3. 16384 (CARL9170FW_RX_FRAME_LEN_16384)
  4. 32768 (CARL9170FW_RX_FRAME_LEN_32768)
choice[1-4]: 
Activate HW Watchdog (CARL9170FW_WATCHDOG) [Y/n/?] 
GPIO Software Interrupt (CARL9170FW_GPIO_INTERRUPT) [Y/n/?] 
Support Hardware Crypto Engine (CARL9170FW_SECURITY_ENGINE) [Y/n/?] 
Enable Firmware-supported Radio/RF functions (CARL9170FW_RADIO_FUNCTIONS) 
[Y/n/?] 

*
* 802.11 Firmware Features
*
Handle BlockACK Requests in Firmware (CARL9170FW_HANDLE_BACK_REQ) [Y/n/?] 
  Number of max. active BlockACK Request (CARL9170FW_BACK_REQS_NUM) [4] 
Support software-based Content after Beacon Queue (CARL9170FW_CAB_QUEUE) [Y/n/?] 


*
* USB Firmware Configuration Settings
*
Basic USB Interface (CARL9170FW_USB_STANDARD_CMDS) [Y/n/?] 
USB Interface Setup (CARL9170FW_USB_INIT_FIRMWARE) [Y/n/?] 
USB Upload Stream (CARL9170FW_USB_UP_STREAM) [Y/n/?] 
USB Download Stream (CARL9170FW_USB_DN_STREAM) [N/y] 
Pass debug messages through USB transport (CARL9170FW_DEBUG_USB) [Y/n/?] 
*
* Experimental, Unstable & Testing Extensions
*
Advanced printf (CARL9170FW_PRINTF) [Y/n/?] 
Experimental Features (CARL9170FW_EXPERIMENTAL) [Y/n] 
  Firmware Supported Power-saving Management  (CARL9170FW_PSM) [Y/n/?] 
  Delay and reorder TX (CARL9170FW_DELAYED_TX) [N/y/?] 
  Number of additional pseudo virtual interfaces (CARL9170FW_VIFS_NUM) [1] 
  Firmware MAC Chip recovery (CARL9170FW_FW_MAC_RESET) [Y/n] 
Broken Featurs (CARL9170FW_BROKEN_FEATURES) [N/y] 
TX / RX Path
> 1. Normal WLAN TX/RX routines (CARL9170FW_NORMAL_TX_RX)
choice[1]: 1
*
* Build Options
*
Enable aggressive size optimization (CARL9170FW_AGGRESSIVE_CFLAGS) [Y/n/?] 
Build MiniBoot Firmware Header (CARL9170FW_BUILD_MINIBOOT) [Y/n] 
*
* Firmware Tools
*
Build Firmware Tools (CARL9170FW_BUILD_TOOLS) [Y/n] 
  Build CARLU testbench (CARL9170FW_BUILD_TOOLS_CARLU) [N/y] 
-- Configuring done
-- Generating done
-- Build files have been written to: /home/data/dev/carl9170fw-1.9.0
Compile time...
Scanning dependencies of target carl9170.elf
[  4%] Building C object  carlfw/CMakeFiles/carl9170.elf.dir/src/main.c.o
[  8%] Building C object carlfw/CMakeFiles/carl9170.elf.dir/src/wlan.c.o
[ 12%] Building C object carlfw/CMakeFiles/carl9170.elf.dir/src/fw.c.o
[ 16%] Building C object carlfw/CMakeFiles/carl9170.elf.dir/src/gpio.c.o
[ 20%] Building C object carlfw/CMakeFiles/carl9170.elf.dir/src/cmd.c.o
[ 25%] Building C object carlfw/CMakeFiles/carl9170.elf.dir/src/uart.c.o
[ 29%] Building C object carlfw/CMakeFiles/carl9170.elf.dir/src/dma.c.o
[ 33%] Building C object carlfw/CMakeFiles/carl9170.elf.dir/src/hostif.c.o
[ 37%] Building C object carlfw/CMakeFiles/carl9170.elf.dir/src/printf.c.o
[ 41%] Building C object carlfw/CMakeFiles/carl9170.elf.dir/src/rf.c.o
[ 45%] Building C object carlfw/CMakeFiles/carl9170.elf.dir/src/cam.c.o
[ 50%] Building C object carlfw/CMakeFiles/carl9170.elf.dir/usb/main.c.o
[ 54%] Building C object carlfw/CMakeFiles/carl9170.elf.dir/usb/usb.c.o
[  58%] Building C object carlfw/CMakeFiles/carl9170.elf.dir/usb/fifo.c.o
Linking C executable carl9170.elf
[ 75%] Built target carl9170.elf
[ 75%] Built target carl9170.dsc
[ 75%] Built target carl9170.fw
[ 79%] Built target miniboot.elf
[ 79%] Built target miniboot.fw
[ 83%] Built target carlfw
[ 87%] Built target checksum
[ 91%] Built target eeprom_fix
[ 95%] Built target fwinfo
[100%] Built target miniboot

$ gcc -v
Using built-in specs.
Target: i686-linux-gnu
Configured  with: ../src/configure -v --with-pkgversion='Ubuntu/Linaro  
4.4.4-14ubuntu5' --with-bugurl=file:///usr/share/doc/gcc-4.4/README.Bugs  
--enable-languages=c,c++,fortran,objc,obj-c++ --prefix=/usr  
--program-suffix=-4.4 --enable-shared --enable-multiarch  
--enable-linker-build-id --with-system-zlib --libexecdir=/usr/lib  
--without-included-gettext --enable-threads=posix  
--with-gxx-include-dir=/usr/include/c++/4.4 --libdir=/usr/lib  --enable-nls  
--with-sysroot=/ --enable-clocale=gnu --enable-libstdcxx-debug  --enable-objc-gc 

--enable-targets=all --disable-werror  --with-arch-32=i686 --with-tune=generic 
--enable-checking=release  --build=i686-linux-gnu --host=i686-linux-gnu 
--target=i686-linux-gnu
Thread model: posix
gcc version 4.4.5 (Ubuntu/Linaro 4.4.4-14ubuntu5) 

$ cmake --version
cmake version 2.8.2

$ dpkg -l | grep libusb
ii  libusb-0.1-4                         2:0.1.12-15ubuntu2             
userspace USB programming library
ii   libusb-1.0-0                        2:1.0.8-2                            
userspace USB programming library
ii  libusbmuxd1                       1.0.4-1                               USB 
multiplexor daemon for iPhone and iPod Touch devices - library

$ ls  /usr/local/lib
libSDL-1.2.so.0  libSDL-1.2.so.0.11.3  libSDL.a  libSDL.la  libSDLmain.a  
libSDL.so  pkgconfig  python2.6  python2.7
(SDL 1.2.14 installed)

$ flex -V
flex 2.5.35

$ bison --version
bison (GNU Bison) 2.4.1
Written by Robert Corbett and Richard Stallman.

Copyright (C) 2008 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

$ gperf -v
GNU gperf 3.0.3
Copyright (C) 1989-1998, 2000-2004, 2006-2007 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
Written by Douglas C. Schmidt and Bruno Haible.


      
