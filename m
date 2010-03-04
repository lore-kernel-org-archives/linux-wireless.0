Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f175.google.com ([209.85.223.175]:55363 "EHLO
	mail-iw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab0CDFFG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Mar 2010 00:05:06 -0500
Received: by iwn5 with SMTP id 5so1835084iwn.1
        for <linux-wireless@vger.kernel.org>; Wed, 03 Mar 2010 21:05:05 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 4 Mar 2010 15:58:58 +1100
Message-ID: <e44ae5e1003032058g2cf1b5a1lcf62e8919dddea58@mail.gmail.com>
Subject: KEY_RFKILL not found on kernel 2.6.30
From: Keith Bannister <k.bannister@ieee.org>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I All,

I'm trying to compile compat-wireless on EasyPeasy (an Ubuntu 9.04
derivative for the eeepc)

The kernel headers are installed for my current kernel:

with

$ sudo apt-get install linux-headers-2.6.30.5-ep0

$ ls -l /lib/modules/`uname -r`/build
lrwxrwxrwx 1 root root 36 2010-03-04 12:02
/lib/modules/2.6.30.5-ep0/build ->
/usr/src/linux-headers-2.6.30.5-ep0/

I got the following compile error, after running

$ ./scripts/driver-select ath5k

$ make clean; make
make[1]: Entering directory `/usr/src/linux-headers-2.6.30.5-ep0'
  CLEAN   /home/keith/wireless/compat-wireless-2010-03-03
  CLEAN   /home/keith/wireless/compat-wireless-2010-03-03/.tmp_versions
make[1]: Leaving directory `/usr/src/linux-headers-2.6.30.5-ep0'
./scripts/gen-compat-autoconf.sh config.mk > include/linux/compat_autoconf.h
make -C /lib/modules/2.6.30.5-ep0/build
M=/home/keith/wireless/compat-wireless-2010-03-03 modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.30.5-ep0'
  LD      /home/keith/wireless/compat-wireless-2010-03-03/compat/built-in.o

.....


CC [M]  /home/keith/wireless/compat-wireless-2010-03-03/net/rfkill/input.o
/home/keith/wireless/compat-wireless-2010-03-03/net/rfkill/input.c: In
function ‘rfkill_event’:
/home/keith/wireless/compat-wireless-2010-03-03/net/rfkill/input.c:219:
error: ‘KEY_RFKILL’ undeclared (first use in this function)
/home/keith/wireless/compat-wireless-2010-03-03/net/rfkill/input.c:219:
error: (Each undeclared identifier is reported only once
/home/keith/wireless/compat-wireless-2010-03-03/net/rfkill/input.c:219:
error: for each function it appears in.)
/home/keith/wireless/compat-wireless-2010-03-03/net/rfkill/input.c: At
top level:
/home/keith/wireless/compat-wireless-2010-03-03/net/rfkill/input.c:307:
error: ‘KEY_RFKILL’ undeclared here (not in a function)
/home/keith/wireless/compat-wireless-2010-03-03/net/rfkill/input.c:307:
error: array index in initialiser not of integer type
/home/keith/wireless/compat-wireless-2010-03-03/net/rfkill/input.c:307:
error: (near initialisation for ‘rfkill_ids[4].keybit’)
make[3]: *** [/home/keith/wireless/compat-wireless-2010-03-03/net/rfkill/input.o]
Error 1
make[2]: *** [/home/keith/wireless/compat-wireless-2010-03-03/net/rfkill]
Error 2
make[1]: *** [_module_/home/keith/wireless/compat-wireless-2010-03-03] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.30.5-ep0'
make: *** [modules] Error 2
keith@keith-laptop:~/wireless/compat-wireless-2010-03-03$ uname -a
Linux keith-laptop 2.6.30.5-ep0 #10 SMP PREEMPT Thu Aug 27 19:45:06
CEST 2009 i686 GNU/Linux

Any Ideas?

-- 
Keith Bannister
