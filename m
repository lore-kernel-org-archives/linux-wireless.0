Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45789 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756832Ab0HaHyt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Aug 2010 03:54:49 -0400
Received: by pzk9 with SMTP id 9so2343456pzk.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Aug 2010 00:54:48 -0700 (PDT)
Message-ID: <4C7CB546.9070800@gmail.com>
Date: Tue, 31 Aug 2010 02:54:46 -0500
From: =?windows-1252?Q?Carlos_Salvador_P=E9rez_Salgado?=
	<carlosalvatore@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: compat-wireless-2.6.35-rc6 won't build
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greetings

I hope you can point me into the right direction.

I've already tried this patch 
http://trac.pentoo.ch/browser/portage/trunk/net-wireless/compat-wireless/files/WEXT-EXT-nuts.patch


#make clean && ./scripts/driver-select atheros && make

make[1]: Entering directory `/media/disk/temp/linux-2.6.35.4'
CLEAN /media/disk/temp/compat-wireless-2.6.35-rc6
CLEAN /media/disk/temp/compat-wireless-2.6.35-rc6/.tmp_versions
make[1]: Leaving directory `/media/disk/temp/linux-2.6.35.4'
Processing new driver-select request...
Backing up makefile: Makefile.bk
Backup exists: drivers/net/wireless/Makefile.bk
Backup exists: net/wireless/Makefile.bk
Backup exists: drivers/net/Makefile.bk
Backup exists: drivers/ssb/Makefile.bk
Backup exists: drivers/misc/eeprom/Makefile.bk
./scripts/gen-compat-autoconf.sh config.mk > include/linux/compat_autoconf.h
make -C /lib/modules/2.6.35.4-k8/build 
M=/media/disk/temp/compat-wireless-2.6.35-rc6 modules
make[1]: Entering directory `/media/disk/temp/linux-2.6.35.4'
LD /media/disk/temp/compat-wireless-2.6.35-rc6/compat/built-in.o
CC [M] /media/disk/temp/compat-wireless-2.6.35-rc6/compat/main.o

...

CC [M] /media/disk/temp/compat-wireless-2.6.35-rc6/net/wireless/core.o
/media/disk/temp/compat-wireless-2.6.35-rc6/net/wireless/core.c: In 
function ‘cfg80211_netdev_notifier_call’:
/media/disk/temp/compat-wireless-2.6.35-rc6/net/wireless/core.c:703: 
error: ‘struct net_device’ has no member named ‘wireless_handlers’
/media/disk/temp/compat-wireless-2.6.35-rc6/net/wireless/core.c:704: 
error: ‘struct net_device’ has no member named ‘wireless_handlers’
make[3]: *** 
[/media/disk/temp/compat-wireless-2.6.35-rc6/net/wireless/core.o] Error 1
make[2]: *** [/media/disk/temp/compat-wireless-2.6.35-rc6/net/wireless] 
Error 2
make[1]: *** [_module_/media/disk/temp/compat-wireless-2.6.35-rc6] Error 2
make[1]: Leaving directory `/media/disk/temp/linux-2.6.35.4'
make: *** [modules] Error 2

Thanks.

I'm using ubuntu lucid, custom kernel 2.6.35.4 in an AMD Turion X2 64 bits.
Using CFLAGS="-march=k8 -msse3 -O3"

