Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:52660 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374AbaBVBu6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 20:50:58 -0500
Received: by mail-pa0-f44.google.com with SMTP id kq14so4193668pab.3
        for <linux-wireless@vger.kernel.org>; Fri, 21 Feb 2014 17:50:58 -0800 (PST)
From: Greg Ketell <greg@ketell.com>
Content-Type: text/plain; charset=windows-1252
Subject: Help with Intel 7260 on Debian Stable (wheezy)
Date: Fri, 21 Feb 2014 17:50:09 -0800
Message-Id: <3815E3D1-0BFD-480D-B2C4-3405B08D5C0D@ketell.com> (sfid-20140222_025102_103697_D82449E3)
Cc: Greg Ketell <greg@ketell.com>
To: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi folks,

I’m trying to get the Intel 7260 working on Debian 7.4 (Kernel 3.2) running on a Giga-Byte GB-BXi5-4200.   The standard iwlwifi for wheezy doesn’t have support for the 7260 so I’ve installed the iwlwifi from debian-backports which lists that card as supported.  Unfortunately the card will not be recognized.

# uname -a
Linux Brix1 3.2.0-4-amd64 #1 SMP Debian 3.2.54-2 x86_64 GNU/Linux

# lspci -nnk
00:00.0 Host bridge [0600]: Intel Corporation Haswell-ULT DRAM Controller [8086:0a04] (rev 09)
	Subsystem: Gigabyte Technology Co., Ltd Device [1458:5000]
00:02.0 VGA compatible controller [0300]: Intel Corporation Haswell-ULT Integrated Graphics Controller [8086:0a16] (rev 09)
	Subsystem: Gigabyte Technology Co., Ltd Device [1458:d000]
00:03.0 Audio device [0403]: Intel Corporation Haswell-ULT HD Audio Controller [8086:0a0c] (rev 09)
	Subsystem: Gigabyte Technology Co., Ltd Device [1458:5000]
	Kernel driver in use: snd_hda_intel
00:14.0 USB controller [0c03]: Intel Corporation Lynx Point-LP USB xHCI HC [8086:9c31] (rev 04)
	Subsystem: Gigabyte Technology Co., Ltd Device [1458:5004]
	Kernel driver in use: xhci_hcd
00:16.0 Communication controller [0780]: Intel Corporation Lynx Point-LP HECI #0 [8086:9c3a] (rev 04)
	Subsystem: Gigabyte Technology Co., Ltd Device [1458:5001]
00:1b.0 Audio device [0403]: Intel Corporation Lynx Point-LP HD Audio Controller [8086:9c20] (rev 04)
	Subsystem: Gigabyte Technology Co., Ltd Device [1458:fa50]
	Kernel driver in use: snd_hda_intel
00:1c.0 PCI bridge [0604]: Intel Corporation Lynx Point-LP PCI Express Root Port 1 [8086:9c10] (rev e4)
	Kernel driver in use: pcieport
00:1c.2 PCI bridge [0604]: Intel Corporation Lynx Point-LP PCI Express Root Port 3 [8086:9c14] (rev e4)
	Kernel driver in use: pcieport
00:1c.3 PCI bridge [0604]: Intel Corporation Lynx Point-LP PCI Express Root Port 4 [8086:9c16] (rev e4)
	Kernel driver in use: pcieport
00:1d.0 USB controller [0c03]: Intel Corporation Lynx Point-LP USB EHCI #1 [8086:9c26] (rev 04)
	Subsystem: Gigabyte Technology Co., Ltd Device [1458:5004]
	Kernel driver in use: ehci_hcd
00:1f.0 ISA bridge [0601]: Intel Corporation Lynx Point-LP LPC Controller [8086:9c43] (rev 04)
	Subsystem: Gigabyte Technology Co., Ltd Device [1458:5001]
00:1f.2 SATA controller [0106]: Intel Corporation Lynx Point-LP SATA Controller 1 [AHCI mode] [8086:9c03] (rev 04)
	Subsystem: Gigabyte Technology Co., Ltd Device [1458:b002]
	Kernel driver in use: ahci
00:1f.3 SMBus [0c05]: Intel Corporation Lynx Point-LP SMBus Controller [8086:9c22] (rev 04)
	Subsystem: Gigabyte Technology Co., Ltd Device [1458:5001]
02:00.0 Network controller [0280]: Intel Corporation Wireless 7260 [8086:08b1] (rev 73)
	Subsystem: Intel Corporation Dual Band Wireless-AC 7260 [8086:4070]
03:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller [10ec:8168] (rev 0c)
	Subsystem: Gigabyte Technology Co., Ltd Motherboard [1458:e000]
	Kernel driver in use: r8169

root@Brix1:/home/gketell# modprobe -r iwlwifi
root@Brix1:/home/gketell# modprobe -vvv !$
modprobe -vvv iwlwifi
libkmod: DEBUG ../libkmod/libkmod-module.c:519 kmod_module_new_from_lookup: input alias=iwlwifi, normalized=iwlwifi
libkmod: DEBUG ../libkmod/libkmod-module.c:525 kmod_module_new_from_lookup: lookup modules.dep iwlwifi
libkmod: DEBUG ../libkmod/libkmod.c:542 kmod_search_moddep: use mmaped index 'modules.dep' modname=iwlwifi
libkmod: DEBUG ../libkmod/libkmod.c:390 kmod_pool_get_module: get module name='iwlwifi' found=(nil)
libkmod: DEBUG ../libkmod/libkmod.c:398 kmod_pool_add_module: add 0x7f40de8d8680 key='iwlwifi'
libkmod: DEBUG ../libkmod/libkmod.c:390 kmod_pool_get_module: get module name='mac80211' found=(nil)
libkmod: DEBUG ../libkmod/libkmod.c:390 kmod_pool_get_module: get module name='mac80211' found=(nil)
libkmod: DEBUG ../libkmod/libkmod.c:398 kmod_pool_add_module: add 0x7f40de8dc3c0 key='mac80211'
libkmod: DEBUG ../libkmod/libkmod-module.c:178 kmod_module_parse_depline: add dep: /lib/modules/3.2.0-4-amd64/kernel/net/mac80211/mac80211.ko
libkmod: DEBUG ../libkmod/libkmod.c:390 kmod_pool_get_module: get module name='cfg80211' found=(nil)
libkmod: DEBUG ../libkmod/libkmod.c:390 kmod_pool_get_module: get module name='cfg80211' found=(nil)
libkmod: DEBUG ../libkmod/libkmod.c:398 kmod_pool_add_module: add 0x7f40de8dc530 key='cfg80211'
libkmod: DEBUG ../libkmod/libkmod-module.c:178 kmod_module_parse_depline: add dep: /lib/modules/3.2.0-4-amd64/kernel/net/wireless/cfg80211.ko
libkmod: DEBUG ../libkmod/libkmod.c:390 kmod_pool_get_module: get module name='rfkill' found=(nil)
libkmod: DEBUG ../libkmod/libkmod.c:390 kmod_pool_get_module: get module name='rfkill' found=(nil)
libkmod: DEBUG ../libkmod/libkmod.c:398 kmod_pool_add_module: add 0x7f40de8dc650 key='rfkill'
libkmod: DEBUG ../libkmod/libkmod-module.c:178 kmod_module_parse_depline: add dep: /lib/modules/3.2.0-4-amd64/kernel/net/rfkill/rfkill.ko
libkmod: DEBUG ../libkmod/libkmod-module.c:184 kmod_module_parse_depline: 3 dependencies for iwlwifi
libkmod: DEBUG ../libkmod/libkmod-module.c:546 kmod_module_new_from_lookup: lookup iwlwifi=0, list=0x7f40de8d84e0
libkmod: DEBUG ../libkmod/libkmod-module.c:1651 kmod_module_get_initstate: could not open '/sys/module/iwlwifi/initstate': No such file or directory
libkmod: DEBUG ../libkmod/libkmod-module.c:1661 kmod_module_get_initstate: could not open '/sys/module/iwlwifi': No such file or directory
libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options: modname=snd_pcsp mod->name=rfkill mod->alias=(null)
libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options: modname=snd_usb_audio mod->name=rfkill mod->alias=(null)
libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options: modname=bt87x mod->name=rfkill mod->alias=(null)
libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options: modname=cx88_alsa mod->name=rfkill mod->alias=(null)
libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options: modname=snd_atiixp_modem mod->name=rfkill mod->alias=(null)
libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options: modname=snd_intel8x0m mod->name=rfkill mod->alias=(null)
libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options: modname=snd_via82xx_modem mod->name=rfkill mod->alias=(null)
libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options: modname=radeon mod->name=rfkill mod->alias=(null)
libkmod: DEBUG ../libkmod/libkmod-module.c:1220 kmod_module_probe_insert_module: Ignoring module 'rfkill': already loaded
libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options: modname=snd_pcsp mod->name=cfg80211 mod->alias=(null)
libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options: modname=snd_usb_audio mod->name=cfg80211 mod->alias=(null)
libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options: modname=bt87x mod->name=cfg80211 mod->alias=(null)
libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options: modname=cx88_alsa mod->name=cfg80211 mod->alias=(null)
libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options: modname=snd_atiixp_modem mod->name=cfg80211 mod->alias=(null)
libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options: modname=snd_intel8x0m mod->name=cfg80211 mod->alias=(null)
libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options: modname=snd_via82xx_modem mod->name=cfg80211 mod->alias=(null)
libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options: modname=radeon mod->name=cfg80211 mod->alias=(null)
libkmod: DEBUG ../libkmod/libkmod-module.c:1651 kmod_module_get_initstate: could not open '/sys/module/cfg80211/initstate': No such file or directory
libkmod: DEBUG ../libkmod/libkmod-module.c:1661 kmod_module_get_initstate: could not open '/sys/module/cfg80211': No such file or directory
libkmod: DEBUG ../libkmod/libkmod-module.c:709 kmod_module_get_path: name='cfg80211' path='/lib/modules/3.2.0-4-amd64/kernel/net/wireless/cfg80211.ko'
libkmod: DEBUG ../libkmod/libkmod-module.c:709 kmod_module_get_path: name='cfg80211' path='/lib/modules/3.2.0-4-amd64/kernel/net/wireless/cfg80211.ko'
insmod /lib/modules/3.2.0-4-amd64/kernel/net/wireless/cfg80211.ko 
libkmod: DEBUG ../libkmod/libkmod-module.c:709 kmod_module_get_path: name='cfg80211' path='/lib/modules/3.2.0-4-amd64/kernel/net/wireless/cfg80211.ko'
libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options: modname=snd_pcsp mod->name=mac80211 mod->alias=(null)
libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options: modname=snd_usb_audio mod->name=mac80211 mod->alias=(null)
libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options: modname=bt87x mod->name=mac80211 mod->alias=(null)
libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options: modname=cx88_alsa mod->name=mac80211 mod->alias=(null)
libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options: modname=snd_atiixp_modem mod->name=mac80211 mod->alias=(null)
libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options: modname=snd_intel8x0m mod->name=mac80211 mod->alias=(null)
libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options: modname=snd_via82xx_modem mod->name=mac80211 mod->alias=(null)
libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options: modname=radeon mod->name=mac80211 mod->alias=(null)
libkmod: DEBUG ../libkmod/libkmod-module.c:1651 kmod_module_get_initstate: could not open '/sys/module/mac80211/initstate': No such file or directory
libkmod: DEBUG ../libkmod/libkmod-module.c:1661 kmod_module_get_initstate: could not open '/sys/module/mac80211': No such file or directory
libkmod: DEBUG ../libkmod/libkmod-module.c:709 kmod_module_get_path: name='mac80211' path='/lib/modules/3.2.0-4-amd64/kernel/net/mac80211/mac80211.ko'
libkmod: DEBUG ../libkmod/libkmod-module.c:709 kmod_module_get_path: name='mac80211' path='/lib/modules/3.2.0-4-amd64/kernel/net/mac80211/mac80211.ko'
insmod /lib/modules/3.2.0-4-amd64/kernel/net/mac80211/mac80211.ko 
libkmod: DEBUG ../libkmod/libkmod-module.c:709 kmod_module_get_path: name='mac80211' path='/lib/modules/3.2.0-4-amd64/kernel/net/mac80211/mac80211.ko'
libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options: modname=snd_pcsp mod->name=iwlwifi mod->alias=(null)
libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options: modname=snd_usb_audio mod->name=iwlwifi mod->alias=(null)
libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options: modname=bt87x mod->name=iwlwifi mod->alias=(null)
libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options: modname=cx88_alsa mod->name=iwlwifi mod->alias=(null)
libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options: modname=snd_atiixp_modem mod->name=iwlwifi mod->alias=(null)
libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options: modname=snd_intel8x0m mod->name=iwlwifi mod->alias=(null)
libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options: modname=snd_via82xx_modem mod->name=iwlwifi mod->alias=(null)
libkmod: DEBUG ../libkmod/libkmod-module.c:1303 kmod_module_get_options: modname=radeon mod->name=iwlwifi mod->alias=(null)
libkmod: DEBUG ../libkmod/libkmod-module.c:1651 kmod_module_get_initstate: could not open '/sys/module/iwlwifi/initstate': No such file or directory
libkmod: DEBUG ../libkmod/libkmod-module.c:1661 kmod_module_get_initstate: could not open '/sys/module/iwlwifi': No such file or directory
libkmod: DEBUG ../libkmod/libkmod-module.c:709 kmod_module_get_path: name='iwlwifi' path='/lib/modules/3.2.0-4-amd64/kernel/drivers/net/wireless/iwlwifi/iwlwifi.ko'
libkmod: DEBUG ../libkmod/libkmod-module.c:709 kmod_module_get_path: name='iwlwifi' path='/lib/modules/3.2.0-4-amd64/kernel/drivers/net/wireless/iwlwifi/iwlwifi.ko'
insmod /lib/modules/3.2.0-4-amd64/kernel/drivers/net/wireless/iwlwifi/iwlwifi.ko 
libkmod: DEBUG ../libkmod/libkmod-module.c:709 kmod_module_get_path: name='iwlwifi' path='/lib/modules/3.2.0-4-amd64/kernel/drivers/net/wireless/iwlwifi/iwlwifi.ko'
libkmod: DEBUG ../libkmod/libkmod-module.c:435 kmod_module_unref: kmod_module 0x7f40de8d8680 released
libkmod: DEBUG ../libkmod/libkmod.c:406 kmod_pool_del_module: del 0x7f40de8d8680 key='iwlwifi'
libkmod: DEBUG ../libkmod/libkmod-module.c:435 kmod_module_unref: kmod_module 0x7f40de8dc650 released
libkmod: DEBUG ../libkmod/libkmod.c:406 kmod_pool_del_module: del 0x7f40de8dc650 key='rfkill'
libkmod: DEBUG ../libkmod/libkmod-module.c:435 kmod_module_unref: kmod_module 0x7f40de8dc530 released
libkmod: DEBUG ../libkmod/libkmod.c:406 kmod_pool_del_module: del 0x7f40de8dc530 key='cfg80211'
libkmod: DEBUG ../libkmod/libkmod-module.c:435 kmod_module_unref: kmod_module 0x7f40de8dc3c0 released
libkmod: DEBUG ../libkmod/libkmod.c:406 kmod_pool_del_module: del 0x7f40de8dc3c0 key='mac80211'
libkmod: INFO ../libkmod/libkmod.c:319 kmod_unref: context 0x7f40de8d8250 released

# dpkg -l |grep -i iwlwifi
ii  firmware-iwlwifi                            0.40~bpo70+1                       all          Binary firmware for Intel Wireless cards

https://packages.debian.org/wheezy-backports/firmware-iwlwifi shows that the 7260 card is part of the 0.40 iwlwifi driver package.

And here is a listing of /dev/firmware showing that the ucode files are actually installed…
# ls /lib/firmware/ |grep iwlwifi
iwlwifi-1000-5.ucode
iwlwifi-100-5.ucode
iwlwifi-105-6.ucode
iwlwifi-135-6.ucode
iwlwifi-2000-6.ucode
iwlwifi-2030-6.ucode
iwlwifi-3160-7.ucode
iwlwifi-3945-2.ucode
iwlwifi-4965-2.ucode
iwlwifi-5000-2.ucode
iwlwifi-5000-5.ucode
iwlwifi-5150-2.ucode
iwlwifi-6000-4.ucode
iwlwifi-6000g2a-5.ucode
iwlwifi-6000g2a-6.ucode
iwlwifi-6000g2b-6.ucode
iwlwifi-6050-4.ucode
iwlwifi-6050-5.ucode
iwlwifi-7260-7.ucode
iwlwifi-7260-8.ucode

Does anyone have any ideas what might be going wrong and how I can fix it?

Thanks in advance!!
--
Greg Ketell



