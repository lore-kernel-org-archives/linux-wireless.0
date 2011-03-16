Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:60506 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483Ab1CPSoW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 14:44:22 -0400
Received: from [192.168.0.11] (unknown [78.226.224.23])
	by smtp4-g21.free.fr (Postfix) with ESMTP id 9ED184C8235
	for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2011 19:44:15 +0100 (CET)
Message-ID: <4D8104FE.4030700@free.fr>
Date: Wed, 16 Mar 2011 19:44:14 +0100
From: Le Gluon du Net <legluondunet@free.fr>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: can not compile ath9k driver for ubuntu 2.6.38-6-generic kernel
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

my config:
Ubuntu Natty
Kernel 2.6.38-X
Wifi pci card: Atheros Communications Inc. AR5008 Wireless Network
Adapter (rev 01)

Hello,

I'm using Ubuntu Natty and the ath9k driver of the different kernel of
this distribution do not make my AR5008 pci express wifi card run well:
the connection is too slow or halted.


I tried to compile Compat-wireless but it does not compile:

#./scripts/driver-select ath9k
Processing new driver-select request...
Backing up makefile: Makefile.bk
Backup exists: Makefile.bk
Backup exists: Makefile.bk
Backup exists: Makefile.bk
Backing up makefile: drivers/net/wireless/Makefile.bk
Backing up makefile: drivers/net/wireless/ath/Makefile.bk
Backing up makefile: net/wireless/Makefile.bk
Backing up makefile: drivers/net/Makefile.bk
Backing up makefile: drivers/ssb/Makefile.bk
Backing up makefile: drivers/misc/eeprom/Makefile.bk
Backup exists: Makefile.bk

#make
./scripts/gen-compat-autoconf.sh config.mk > include/linux/compat_autoconf.h
make -C /lib/modules/2.6.38-6-generic/build
M=/home/legluondunet/Bureau/compat-wireless-2011-03-15 modules
make[1]: entrant dans le répertoire «
/usr/src/linux-headers-2.6.38-6-generic »
LD /home/legluondunet/Bureau/compat-wireless-2011-03-15/compat/built-in.o
CC [M] /home/legluondunet/Bureau/compat-wireless-2011-03-15/compat/main.o
CC [M]
/home/legluondunet/Bureau/compat-wireless-2011-03-15/compat/compat-2.6.39.o
/home/legluondunet/Bureau/compat-wireless-2011-03-15/compat/compat-2.6.39.c:
In function ‘tty_set_termios’:
/home/legluondunet/Bureau/compat-wireless-2011-03-15/compat/compat-2.6.39.c:93:4:
error: ‘TASK_INTERRUPTIBLE’ undeclared (first use in this function)
/home/legluondunet/Bureau/compat-wireless-2011-03-15/compat/compat-2.6.39.c:93:4:
note: each undeclared identifier is reported only once for each function
it appears in
make[3]: ***
[/home/legluondunet/Bureau/compat-wireless-2011-03-15/compat/compat-2.6.39.o]
Erreur 1
make[2]: ***
[/home/legluondunet/Bureau/compat-wireless-2011-03-15/compat] Erreur 2
make[1]: ***
[_module_/home/legluondunet/Bureau/compat-wireless-2011-03-15] Erreur 2
make[1]: quittant le répertoire « /usr/src/linux-headers-2.6.38-6-generic »
make: *** [modules] Erreur 2

I tried different version of compat wireless and only the
compat-wireless-2011-02-13 compiles good on natty.
But it is not stable, I lost the connection several times per day.
In dmesg, I can see:

[125508.616378] ath: Failed to stop TX DMA in 100 msec after killing
last frame
[125508.616429] ath: Failed to stop TX DMA!
[125987.139552] ath: DMA failed to stop in 10 ms AR_CR=0x00000024
AR_DIAG_SW=0x42000020
[125987.139558] ath: Could not stop RX, we could be confusing the DMA
engine when we start RX up
[125987.150888] ath: DMA failed to stop in 10 ms AR_CR=0x00000024
AR_DIAG_SW=0x42000020
[126109.744252] ath: Failed to stop TX DMA in 100 msec after killing
last frame
[126109.744303] ath: Failed to stop TX DMA!
[126227.548359] ath: Failed to stop TX DMA in 100 msec after killing
last frame
[126227.548412] ath: Failed to stop TX DMA!
[126347.548348] ath: Failed to stop TX DMA in 100 msec after killing
last frame
[126347.548403] ath: Failed to stop TX DMA!
[126467.192362] ath: Failed to stop TX DMA in 100 msec after killing
last frame
[126467.192413] ath: Failed to stop TX DMA!
[126827.143471] ath: DMA failed to stop in 10 ms AR_CR=0x00000024
AR_DIAG_SW=0x42000020
[126827.143478] ath: Could not stop RX, we could be confusing the DMA
engine when we start RX up
[126827.154889] ath: DMA failed to stop in 10 ms AR_CR=0x00000024
AR_DIAG_SW=0x42000020


The connection is fast but the driver is totally unstable but it is the
only version I can compile.
Someone know why I can only compile this version? not the last?

Thanks for your help.

LGDN

