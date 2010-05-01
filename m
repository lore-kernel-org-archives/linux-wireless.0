Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:45187 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757614Ab0EAAPm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Apr 2010 20:15:42 -0400
Received: from [72.25.58.52] (helo=[206.223.20.50])
	by host200.hostmonster.com with esmtpa (Exim 4.69)
	(envelope-from <dhlii@dlasys.net>)
	id 1O80Mt-0004fi-KL
	for linux-wireless@vger.kernel.org; Fri, 30 Apr 2010 18:15:40 -0600
Message-ID: <4BDB72AA.7000203@dlasys.net>
Date: Fri, 30 Apr 2010 20:15:38 -0400
From: "David H. Lynch Jr." <dhlii@dlasys.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ar9170-fw
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

     I tried to build the toolchain from an uptodate pull of the git 
repository,

     I am getting a sequence of errors when the build reach libssp.

     My guess would be that libssp is not needed for the ar9170 firmware.

     Is this correct and I would appreciate an easy suguestion to 
disable it if so.

make[3]: Entering directory `/usr/src/ar9170-fw/toolchain/build/gcc/sh-elf/libssp'
if/bin/bash ./libtool --tag=CC --mode=compile
/usr/src/ar9170-fw/toolchain/build/gcc/./gcc/xgcc
-B/usr/src/ar9170-fw/toolchain/build/gcc/./gcc/
-B/usr/src/ar9170-fw/toolchain/inst/sh-elf/bin/
-B/usr/src/ar9170-fw/toolchain/inst/sh-elf/lib/  -isystem
/usr/src/ar9170-fw/toolchain/inst/sh-elf/include -isystem
/usr/src/ar9170-fw/toolchain/inst/sh-elf/sys-include -DHAVE_CONFIG_H -I.
-I/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp -I. -Wall -O2 -g -g -O2 -MT
ssp.lo -MD -MP -MF ".deps/ssp.Tpo" -c -o ssp.lo
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c; \
then mv -f ".deps/ssp.Tpo" ".deps/ssp.Plo"; else rm -f ".deps/ssp.Tpo"; exit 1; fi
libtool: compile:/usr/src/ar9170-fw/toolchain/build/gcc/./gcc/xgcc
-B/usr/src/ar9170-fw/toolchain/build/gcc/./gcc/
-B/usr/src/ar9170-fw/toolchain/inst/sh-elf/bin/
-B/usr/src/ar9170-fw/toolchain/inst/sh-elf/lib/  -isystem
/usr/src/ar9170-fw/toolchain/inst/sh-elf/include -isystem
/usr/src/ar9170-fw/toolchain/inst/sh-elf/sys-include -DHAVE_CONFIG_H -I.
-I/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp -I. -Wall -O2 -g -g -O2 -MT
ssp.lo -MD -MP -MF .deps/ssp.Tpo -c
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c -o ssp.o
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c: In function
'__guard_setup':
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:70: warning: implicit
declaration of function 'open'
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:70: error: 'O_RDONLY'
undeclared (first use in this function)
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:70: error: (Each
undeclared identifier is reported only once
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:70: error: for each
function it appears in.)
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:73: error: 'ssize_t'
undeclared (first use in this function)
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:73: error: expected ';'
before 'size'
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:75: warning: implicit
declaration of function 'close'
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:76: error: 'size'
undeclared (first use in this function)
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c: At top level:
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:89: error: expected
declaration specifiers or '...' before 'size_t'
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c: In function 'fail':
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:100: error: 'O_WRONLY'
undeclared (first use in this function)
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:104: error: 'size_t'
undeclared (first use in this function)
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:104: error: expected ';'
before 'progname_len'
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:107: error:
'progname_len' undeclared (first use in this function)
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:107: warning: implicit
declaration of function 'strlen'
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:107: warning:
incompatible implicit declaration of built-in function 'strlen'
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:108: error: 'len'
undeclared (first use in this function)
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:108: error: 'msg1len'
undeclared (first use in this function)
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:109: warning: implicit
declaration of function 'alloca'
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:109: warning:
incompatible implicit declaration of built-in function 'alloca'
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:111: warning: implicit
declaration of function 'memcpy'
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:111: warning:
incompatible implicit declaration of built-in function 'memcpy'
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:119: error: 'ssize_t'
undeclared (first use in this function)
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:119: error: expected ';'
before 'wrote'
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:120: error: 'wrote'
undeclared (first use in this function)
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:151: warning: implicit
declaration of function '_exit'
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:151: warning:
incompatible implicit declaration of built-in function '_exit'
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c: In function
'__stack_chk_fail':
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:161: warning:
incompatible implicit declaration of built-in function 'strlen'
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:161: warning: passing
argument 2 of 'fail' makes pointer from integer without a cast
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:161: error: too many
arguments to function 'fail'
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c: In function '__chk_fail':
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:168: warning:
incompatible implicit declaration of built-in function 'strlen'
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:168: warning: passing
argument 2 of 'fail' makes pointer from integer without a cast
/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:168: error: too many
arguments to function 'fail'
make[3]: *** [ssp.lo] Error 1
make[3]: Leaving directory `/usr/src/ar9170-fw/toolchain/build/gcc/sh-elf/libssp'
make[2]: *** [install-target-libssp] Error 2
make[2]: Leaving directory `/usr/src/ar9170-fw/toolchain/build/gcc'
make[1]: *** [install] Error 2
make[1]: Leaving directory `/usr/src/ar9170-fw/toolchain/build/gcc'
make: *** [gcc] Error 2





-- 
Dave Lynch 					  	    DLA Systems
Software Development:  				         Embedded Linux
717.587.7774 	       dhlii@dlasys.net 	  http://www.dlasys.net
Over 25 years' experience in platforms, languages, and technologies too numerous to list.

"Any intelligent fool can make things bigger and more complex... It takes a touch of genius - and a lot of courage to move in the opposite direction."
Albert Einstein

