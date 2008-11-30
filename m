Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:17159 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbYK3IsM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Nov 2008 03:48:12 -0500
Received: by wf-out-1314.google.com with SMTP id 27so2135008wfd.4
        for <linux-wireless@vger.kernel.org>; Sun, 30 Nov 2008 00:48:11 -0800 (PST)
Message-ID: <d5b9d7c80811300048l22b99fe3v27b65e5e4962a54b@mail.gmail.com> (sfid-20081130_094818_466075_F345C87B)
Date: Sun, 30 Nov 2008 18:48:11 +1000
From: "Vince Barwinski" <vince.barwinski@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Build problem with "compat-wireless-2.6-old"
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi there

I just downloaded compat-wireless-old.tar.bz2 and then after
extracting it I tried to build it by executing the 'make' command. I
made sure that I had the kernel headers and kernel source installed
before running 'make'. I downloaded and installed them with 'apt-get'.
My machine is an ACER Travelmate 230 Laptop with the Operating System
being 'Simply Mepis Linux version 7.0' with kernel version
'2.6.22-1-mepis-smp'. My USB wireless adapter is a 'Lemel LM-WLG600U
802.11g'. The old story: I am able to get it to work in Microsloth
Windows XP with the driver CD, but the real problem of course is
getting it to run in Linux.

At first the build seemed to be running OK, but after a minute or so
it failed with the following output:

root@laptop:/home/vince/downloads/compat-wireless-2.6-old# make
./scripts/gen-compat-autoconf.sh config.mk > include/linux/compat_autoconf.h
make -C /lib/modules/2.6.22-1-mepis-smp/build
M=/home/vince/downloads/compat-wireless-2.6-old modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.22-1-mepis-smp'
  CC [M]  /home/vince/downloads/compat-wireless-2.6-old/drivers/misc/eeprom_93cx6.o
  CC [M]  /home/vince/downloads/compat-wireless-2.6-old/drivers/net/b44.o
In file included from
/home/vince/downloads/compat-wireless-2.6-old/drivers/net/b44.c:34:
/home/vince/downloads/compat-wireless-2.6-old/drivers/net/b44.h:361:
error: field 'napi' has incomplete type
/home/vince/downloads/compat-wireless-2.6-old/drivers/net/b44.c: In
function 'b44_poll':
/home/vince/downloads/compat-wireless-2.6-old/drivers/net/b44.c:849:
warning: type defaults to 'int' in declaration of '__mptr'
/home/vince/downloads/compat-wireless-2.6-old/drivers/net/b44.c:849:
warning: initialization from incompatible pointer type
/home/vince/downloads/compat-wireless-2.6-old/drivers/net/b44.c:879:
error: too many arguments to function 'netif_rx_complete'
/home/vince/downloads/compat-wireless-2.6-old/drivers/net/b44.c: In
function 'b44_interrupt':
/home/vince/downloads/compat-wireless-2.6-old/drivers/net/b44.c:911:
error: too many arguments to function 'netif_rx_schedule_prep'
/home/vince/downloads/compat-wireless-2.6-old/drivers/net/b44.c:917:
error: too many arguments to function '__netif_rx_schedule'
/home/vince/downloads/compat-wireless-2.6-old/drivers/net/b44.c: In
function 'b44_open':
/home/vince/downloads/compat-wireless-2.6-old/drivers/net/b44.c:1433:
warning: implicit declaration of function 'napi_enable'
/home/vince/downloads/compat-wireless-2.6-old/drivers/net/b44.c:1442:
warning: implicit declaration of function 'napi_disable'
/home/vince/downloads/compat-wireless-2.6-old/drivers/net/b44.c: At top level:
/home/vince/downloads/compat-wireless-2.6-old/drivers/net/b44.c:2051:
error: unknown field 'get_sset_count' specified in initializer
/home/vince/downloads/compat-wireless-2.6-old/drivers/net/b44.c:2051:
warning: initialization from incompatible pointer type
/home/vince/downloads/compat-wireless-2.6-old/drivers/net/b44.c: In
function 'b44_init_one':
/home/vince/downloads/compat-wireless-2.6-old/drivers/net/b44.c:2159:
warning: implicit declaration of function 'netif_napi_add'
make[3]: *** [/home/vince/downloads/compat-wireless-2.6-old/drivers/net/b44.o]
Error 1
make[2]: *** [/home/vince/downloads/compat-wireless-2.6-old/drivers/net] Error 2
make[1]: *** [_module_/home/vince/downloads/compat-wireless-2.6-old] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.22-1-mepis-smp'
make: *** [modules] Error 2

Any help would be greatly appreciated.

All the best

Vince Barwinski
