Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from asmtpout030.mac.com ([17.148.16.105]:36376 "EHLO
	asmtpout030.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab0LVTfE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 14:35:04 -0500
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Received: from [192.168.1.30] ([87.201.169.175])
 by asmtp030.mac.com (Sun Java(tm) System Messaging Server 6.3-8.01 (built Dec
 16 2008; 32bit)) with ESMTPSA id <0LDU00F48H1SZKA0@asmtp030.mac.com> for
 linux-wireless@vger.kernel.org; Wed, 22 Dec 2010 11:34:46 -0800 (PST)
Subject: Re: Backporting wl1271 driver to kernel-2.6.32 using compat-wireless
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <4D123FBB.1050801@hauke-m.de>
Date: Wed, 22 Dec 2010 23:34:27 +0400
Cc: Oz Krakowski <ozk@ti.com>,
	Linux Wireless Mailing List <linux-wireless@vger.kernel.org>
Message-id: <C7700580-CCBB-498D-9EA5-73E2BF748C68@mac.com>
References: <1CA1EE34-CB3D-404D-ADEE-612C8783BFCF@mac.com>
 <AANLkTin8RZwVrWAdNn_Q+_bX8BAHgKreyHiVjznZtMxU@mail.gmail.com>
 <1A56906E-D786-45E6-9C77-C9D600B508B0@mac.com>
 <AANLkTikhLKuw56BhDkBUMU-nf8ZYF1v5Berj-+qupAtO@mail.gmail.com>
 <E90F18E9-6332-4A7C-97DA-01169E5BB5E1@mac.com>
 <AANLkTik6m0rabY3ZCseoch7fwxhMksMD83A-ygtN4cVu@mail.gmail.com>
 <F4DFEC94-D5AC-4C12-890D-8F242E757071@mac.com>
 <AANLkTi=owvDyO3qfahUwRv4MxJrvMK9hjh5NOwRHQuO+@mail.gmail.com>
 <7F14B85B-566C-45A9-BF8B-FE9DED7944D0@mac.com>
 <AANLkTik7jvW9pA3deanBRXxJh6tLeO7WQgqrkN3xa9LG@mail.gmail.com>
 <4D122B8F.5090302@hauke-m.de> <1813D0B1-5391-48DB-9882-A6586DAB180C@mac.com>
 <AANLkTimMWH63yG2tdu7OHemHs=6OOy_i5fpeEDhhh6O9@mail.gmail.com>
 <4D123FBB.1050801@hauke-m.de>
To: Hauke Mehrtens <hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Dec 22, 2010, at 10:13 PM, Hauke Mehrtens wrote:

> In your kernel config CONFIG_LEDS_TRIGGERS is probably unset and then
> net/mac80211/led.c should not be build at all. In the kernel
> CONFIG_MAC80211_LEDS will select CONFIG_LEDS_TRIGGERS, but in
> compat-wireless this should just be disabled.
> I provided a patch for this problem, please apply it and try again.

Thanks for sending the patch across so quickly. I applied it and it built correctly.

However, I don't see a wl1271.ko module in the list of built files. The TI android
rowboard 2.6.32 kernel doesn't have an option for wl12xx or wl1271 at the moment
so, what do I do next? :-) 

Sorry, its my first time trying to use compat-wireless.

$ ./scripts/driver-select wl12xx
Processing new driver-select request...
Backup exists: Makefile.bk
Backup exists: drivers/net/wireless/Makefile.bk
Backup exists: Makefile.bk
Backup exists: net/wireless/Makefile.bk
Backup exists: drivers/net/Makefile.bk
Backup exists: drivers/ssb/Makefile.bk
Backup exists: drivers/misc/eeprom/Makefile.bk
Backup exists: Makefile.bk
elvis@hercules:/tool/patches/compat-wireless-2.6.37-rc6-3-patchwork$ make
./scripts/gen-compat-autoconf.sh config.mk > include/linux/compat_autoconf.h
make -C /tool/patches/android-rowboat-2.6.32-kernel-patchwork M=/tool/patches/compat-wireless-2.6.37-rc6-3-patchwork modules
make[1]: Entering directory `/tool/patches/android-rowboat-2.6.32-kernel-patchwork'
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/compat/main.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/compat/compat-2.6.33.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/compat/compat-2.6.35.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/compat/compat-2.6.36.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/compat/compat-2.6.37.o
  LD [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/compat/compat.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/compat/compat_firmware_class.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/main.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/status.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/sta_info.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/wep.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/wpa.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/scan.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/offchannel.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/ht.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/agg-tx.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/agg-rx.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/ibss.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/mlme.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/work.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/iface.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/rate.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/michael.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/tkip.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/aes_ccm.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/aes_cmac.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/cfg.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/rx.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/spectmgmt.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/tx.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/key.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/util.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/wme.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/event.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/chan.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/mesh.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/mesh_pathtbl.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/mesh_plink.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/mesh_hwmp.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/pm.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/rc80211_pid_algo.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/rc80211_minstrel.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/rc80211_minstrel_ht.o
  LD [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/mac80211.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/wireless/core.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/wireless/sysfs.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/wireless/radiotap.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/wireless/util.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/wireless/reg.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/wireless/scan.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/wireless/nl80211.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/wireless/mlme.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/wireless/ibss.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/wireless/sme.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/wireless/chan.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/wireless/ethtool.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/wireless/wext-compat.o
  CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/wireless/wext-sme.o
  LD [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/wireless/cfg80211.o
  Building modules, stage 2.
  MODPOST 4 modules
  CC      /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/compat/compat.mod.o
  LD [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/compat/compat.ko
  CC      /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/compat/compat_firmware_class.mod.o
  LD [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/compat/compat_firmware_class.ko
  CC      /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/mac80211.mod.o
  LD [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/mac80211.ko
  CC      /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/wireless/cfg80211.mod.o
  LD [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/wireless/cfg80211.ko
make[1]: Leaving directory `/tool/patches/android-rowboat-2.6.32-kernel-patchwork'



Elvis Dowson
