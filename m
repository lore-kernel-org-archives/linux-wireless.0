Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:56594 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754653Ab2B2XkF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 18:40:05 -0500
Received: by lahj13 with SMTP id j13so4169369lah.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Feb 2012 15:40:03 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 1 Mar 2012 00:40:03 +0100
Message-ID: <CAPf1iqE5uHycdE+vk+-CTczVLKUccZfttm_OHeFp2Su3zoKOcw@mail.gmail.com> (sfid-20120301_004009_977935_84ABC94B)
Subject: getting syntax error while performing "make install"
From: Michal Simovic <misosim81@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

I'm having issues installing network drivers for my Acer netbook
(Aspire One 722). Both my wired and wireless networking is not
functional.
Listing from "lspci" looks like this:
miso@northbrook:~/drivers/drv/compat-wireless-2012-02-25$ lspci|grep -i net
06:00.0 Ethernet controller: Atheros Communications AR8152 v2.0 Fast
Ethernet (rev c1)
07:00.0 Network controller: Atheros Communications Inc. Device 0032 (rev 01)

I have tried to install the
linux-backports-modules-wireless-lucid-generic package and the wired
network seemed to work with it (wired network detected, IP address
assigned) but failed to function after a while. That's why I decided
to to download the latest compat-wireless-2.6.tar.bz2 package and
compile it.
I made sure that I've got the kernel headers corresponding to my running kernel:

miso@northbrook:~/drivers/drv/compat-wireless-2012-02-25$ uname -a
Linux northbrook 2.6.32-38-generic #83-Ubuntu SMP Wed Jan 4 11:12:07
UTC 2012 x86_64 GNU/Linux
miso@northbrook:~/drivers/drv/compat-wireless-2012-02-25$ dpkg -l|grep
linux-headers
ii  linux-headers-2.6.32-21
2.6.32-21.32                                    Header files related
to Linux kernel version
ii  linux-headers-2.6.32-21-generic
2.6.32-21.32                                    Linux kernel headers
for version 2.6.32 on x
ii  linux-headers-2.6.32-38
2.6.32-38.85                                    Header files related
to Linux kernel version
ii  linux-headers-2.6.32-38-generic
2.6.32-38.83                                    Linux kernel headers
for version 2.6.32 on x
ii  linux-headers-generic
2.6.32.21.22                                    Generic Linux kernel
headers
miso@northbrook:~/drivers/drv/compat-wireless-2012-02-25$ ls -l
/lib/modules/`uname -r`/build
lrwxrwxrwx 1 root root 40 2012-02-29 23:24
/lib/modules/2.6.32-38-generic/build ->
/usr/src/linux-headers-2.6.32-38-generic

Follows the process of compilation along with the errors I get:
miso@northbrook:~/drivers/drv/compat-wireless-2012-02-25$ make clean
make[1]: Entering directory `/usr/src/linux-headers-2.6.32-38-generic'
  CLEAN   /home/miso/drivers/drv/compat-wireless-2012-02-25
  CLEAN   /home/miso/drivers/drv/compat-wireless-2012-02-25/.tmp_versions
make[1]: Leaving directory `/usr/src/linux-headers-2.6.32-38-generic'
miso@northbrook:~/drivers/drv/compat-wireless-2012-02-25$ make
./scripts/gen-compat-autoconf.sh .config config.mk >
include/linux/compat_autoconf.h
make -C /home/miso/drivers/drv/compat-wireless-2012-02-25 modules
make[1]: Entering directory `/home/miso/drivers/drv/compat-wireless-2012-02-25'
make -C /lib/modules/2.6.32-38-generic/build
M=/home/miso/drivers/drv/compat-wireless-2012-02-25 modules
make[2]: Entering directory `/usr/src/linux-headers-2.6.32-38-generic'
  LD      /home/miso/drivers/drv/compat-wireless-2012-02-25/compat/built-in.o
  CC [M]  /home/miso/drivers/drv/compat-wireless-2012-02-25/compat/main.o
  CC [M]  /home/miso/drivers/drv/compat-wireless-2012-02-25/compat/compat-2.6.33.o
  CC [M]  /home/miso/drivers/drv/compat-wireless-2012-02-25/compat/compat-2.6.35.o
  CC [M]  /home/miso/drivers/drv/compat-wireless-2012-02-25/compat/compat-2.6.36.o
  CC [M]  /home/miso/drivers/drv/compat-wireless-2012-02-25/compat/compat-2.6.37.o
  CC [M]  /home/miso/drivers/drv/compat-wireless-2012-02-25/compat/compat-2.6.38.o
  CC [M]  /home/miso/drivers/drv/compat-wireless-2012-02-25/compat/compat-2.6.39.o
  CC [M]  /home/miso/drivers/drv/compat-wireless-2012-02-25/compat/kstrtox.o
  CC [M]  /home/miso/drivers/drv/compat-wireless-2012-02-25/compat/compat-3.0.o
  CC [M]  /home/miso/drivers/drv/compat-wireless-2012-02-25/compat/compat-3.2.o
  CC [M]  /home/miso/drivers/drv/compat-wireless-2012-02-25/compat/cordic.o
  CC [M]  /home/miso/drivers/drv/compat-wireless-2012-02-25/compat/crc8.o
/home/miso/drivers/drv/compat-wireless-2012-02-25/compat/crc8.c:17:1:
warning: "pr_fmt" redefined
In file included from include/linux/skbuff.h:17,
                 from include/linux/if_ether.h:124,
                 from include/linux/netdevice.h:29,
                 from
/home/miso/drivers/drv/compat-wireless-2012-02-25/include/linux/compat-2.6.29.h:5,
                 from
/home/miso/drivers/drv/compat-wireless-2012-02-25/include/linux/compat-2.6.h:26,
                 from <command-line>:0:
include/linux/kernel.h:366:1: warning: this is the location of the
previous definition
/home/miso/drivers/drv/compat-wireless-2012-02-25/compat/crc8.c:17:1:
warning: "pr_fmt" redefined
In file included from include/linux/skbuff.h:17,
                 from include/linux/if_ether.h:124,
                 from include/linux/netdevice.h:29,
                 from
/home/miso/drivers/drv/compat-wireless-2012-02-25/include/linux/compat-2.6.29.h:5,
                 from
/home/miso/drivers/drv/compat-wireless-2012-02-25/include/linux/compat-2.6.h:26,
                 from <command-line>:0:
include/linux/kernel.h:366:1: warning: this is the location of the
previous definition
  LD [M]  /home/miso/drivers/drv/compat-wireless-2012-02-25/compat/compat.o
  CC [M]  /home/miso/drivers/drv/compat-wireless-2012-02-25/compat/compat_firmware_class.o
  LD      /home/miso/drivers/drv/compat-wireless-2012-02-25/built-in.o
  Building modules, stage 2.
  MODPOST 2 modules
  CC      /home/miso/drivers/drv/compat-wireless-2012-02-25/compat/compat.mod.o
  LD [M]  /home/miso/drivers/drv/compat-wireless-2012-02-25/compat/compat.ko
  CC      /home/miso/drivers/drv/compat-wireless-2012-02-25/compat/compat_firmware_class.mod.o
  LD [M]  /home/miso/drivers/drv/compat-wireless-2012-02-25/compat/compat_firmware_class.ko
make[2]: Leaving directory `/usr/src/linux-headers-2.6.32-38-generic'
make[1]: Leaving directory `/home/miso/drivers/drv/compat-wireless-2012-02-25'

miso@northbrook:~/drivers/drv/compat-wireless-2012-02-25$ sudo make install

make -C /lib/modules/2.6.32-38-generic/build
M=/home/miso/drivers/drv/compat-wireless-2012-02-25 modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.32-38-generic'
  Building modules, stage 2.
  MODPOST 2 modules
make[1]: Leaving directory `/usr/src/linux-headers-2.6.32-38-generic'
make -C /lib/modules/2.6.32-38-generic/build
M=/home/miso/drivers/drv/compat-wireless-2012-02-25
"INSTALL_MOD_DIR=updates"  \
		modules_install
make[1]: Entering directory `/usr/src/linux-headers-2.6.32-38-generic'
  INSTALL /home/miso/drivers/drv/compat-wireless-2012-02-25/compat/compat.ko
  INSTALL /home/miso/drivers/drv/compat-wireless-2012-02-25/compat/compat_firmware_class.ko
  DEPMOD  2.6.32-38-generic
make[1]: Leaving directory `/usr/src/linux-headers-2.6.32-38-generic'
/bin/sh: Syntax error: ";" unexpected
make: *** [install-scripts] Error 2

Any ideas how I could make it work?
Thanks.

-- 
Michal
