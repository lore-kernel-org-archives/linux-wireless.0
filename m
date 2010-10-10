Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48850 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab0JJIJf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Oct 2010 04:09:35 -0400
Subject: Re: phyX enumeration conflict
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ben Greear <greearb@candelatech.com>,
	rainbow lum <rainbowlum@gmail.com>
In-Reply-To: <201010082159.59262.chunkeey@googlemail.com>
References: <201010082159.59262.chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Oct 2010 10:09:12 +0200
Message-ID: <1286698152.3547.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John, please revert 5a254ffe3ffdfa84fe076009bd8e88da412180d2 with the
following commit log.

Revert "wireless: Use first phyX name available when registering phy devices."

This reverts 5a254ffe3ffdfa84fe076009bd8e88da412180d2.

The commit failed to take into account that allocated wireless devices
(wiphys) are not added into the device list upon allocation, but only
when they are registered. Therefore, it opened up a race between
allocating and registering a name, so that if two processes allocate and
register concurrently ("alloc, alloc, register, register" rather than
"alloc, register, alloc, register") the code will attempt to use the
same name twice.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>

I apologise for not catching this during review and will try to do
better in the future.

johannes

On Fri, 2010-10-08 at 21:59 +0200, Christian Lamparter wrote:
> This is a report from a user(added to CC): 
> 
> He has two different mac80211-powered USB devices:
> one which has an ISL3887 (supported by p54usb),
> the other is an AR9170 (carl9170). 
> 
> "I found another problem---the driver use the phy index from 0, which
> will conflict with p54usb driver(i have two wifi card,another one use
> p54usb). this will cause boot-period wireless init fail.
> bellow are some details.
> 
> [    5.049234] usbcore: registered new interface driver usbfs
> [    5.069937] usbcore: registered new interface driver hub
> [    5.093766] usbcore: registered new device driver usb
> [    5.163736] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    5.170118] ohci_hcd 0000:00:0a.0: OHCI Host Controller
> [    5.190581] ohci_hcd 0000:00:0a.0: new USB bus registered, assigned bus
> number 1
> [    5.202619] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    5.233765] ohci_hcd 0000:00:0a.0: irq 7, io mem 0xfeffd000
> [    5.248441] Warning! ehci_hcd should always be loaded before uhci_hcd and
> ohci_hcd, not after
> [    5.328444] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
> [    5.335301] usb usb1: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    5.342550] usb usb1: Product: OHCI Host Controller
> [    5.349599] usb usb1: Manufacturer: Linux 2.6.36-rc6-wl-wlplug20101006
> ohci_hcd
> [    5.362825] usb usb1: SerialNumber: 0000:00:0a.0
> [    5.369904] hub 1-0:1.0: USB hub found
> [    5.373812] hub 1-0:1.0: 2 ports detected
> [    5.379112] ehci_hcd 0000:00:0a.1: EHCI Host Controller
> [    5.384472] ehci_hcd 0000:00:0a.1: new USB bus registered, assigned bus
> number 2
> [    5.415841] ehci_hcd 0000:00:0a.1: irq 9, io mem 0xfefff800
> [    5.433679] ehci_hcd 0000:00:0a.1: USB 2.0 started, EHCI 1.00
> [    5.439605] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [    5.446451] usb usb2: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    5.453717] usb usb2: Product: EHCI Host Controller
> [    5.458621] usb usb2: Manufacturer: Linux 2.6.36-rc6-wl-wlplug20101006
> ehci_hcd
> [    5.465974] usb usb2: SerialNumber: 0000:00:0a.1
> [    5.472880] hub 2-0:1.0: USB hub found
> [    5.476790] hub 2-0:1.0: 2 ports detected
> [    5.482134] ohci_hcd 0000:00:0b.0: OHCI Host Controller
> [    5.487507] ohci_hcd 0000:00:0b.0: new USB bus registered, assigned bus
> number 3
> [    5.495105] ohci_hcd 0000:00:0b.0: irq 10, io mem 0xfeffe000
> [    5.583815] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
> [    5.590635] usb usb3: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    5.597906] usb usb3: Product: OHCI Host Controller
> [    5.602810] usb usb3: Manufacturer: Linux 2.6.36-rc6-wl-wlplug20101006
> ohci_hcd
> [    5.610216] usb usb3: SerialNumber: 0000:00:0b.0
> [    5.617114] hub 3-0:1.0: USB hub found
> [    5.620920] hub 3-0:1.0: 2 ports detected
> [    5.626326] ehci_hcd 0000:00:0b.1: EHCI Host Controller
> [    5.631628] ehci_hcd 0000:00:0b.1: new USB bus registered, assigned bus
> number 4
> [    5.723840] ehci_hcd 0000:00:0b.1: irq 11, io mem 0xfefffc00
> [    5.793740] usb 2-2: new high speed USB device using ehci_hcd and address
> 2
> [    5.813661] ehci_hcd 0000:00:0b.1: USB 2.0 started, EHCI 1.00
> [    5.819624] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
> [    5.826550] usb usb4: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    5.833845] usb usb4: Product: EHCI Host Controller
> [    5.838765] usb usb4: Manufacturer: Linux 2.6.36-rc6-wl-wlplug20101006
> ehci_hcd
> [    5.846122] usb usb4: SerialNumber: 0000:00:0b.1
> [    5.853073] hub 4-0:1.0: USB hub found
> [    5.856972] hub 4-0:1.0: 2 ports detected
> [    6.012773] usb 2-2: New USB device found, idVendor=0cf3, idProduct=1002
> [    6.019545] usb 2-2: New USB device strings: Mfr=16, Product=32,
> SerialNumber=48
> [    6.026993] usb 2-2: Product: USB2.0 WLAN
> [    6.031041] usb 2-2: Manufacturer: ATHER
> [    6.037793] usb 2-2: SerialNumber: 12345
> [    6.264804] REISERFS (device hda1): found reiserfs format "3.6" with
> standard journal
> [    6.272704] REISERFS (device hda1): using ordered data mode
> [    6.285441] REISERFS (device hda1): journal params: device hda1, size
> 8192, journal first block 18, max trans len 1024, max batch 900, max commit
> age 30, max trans age 30
> [    6.311500] REISERFS (device hda1): checking transaction log (hda1)
> [    6.343736] usb 4-2: new high speed USB device using ehci_hcd and address
> 2
> [    6.498133] usb 4-2: New USB device found, idVendor=1435, idProduct=0427
> [    6.505010] usb 4-2: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0
> [    6.512273] usb 4-2: Product: Cohiba 3887 rev0
> [    6.516876] usb 4-2: Manufacturer: GlobespanVirata
> [    6.604230] REISERFS (device hda1): replayed 22 transactions in 0 seconds
> [    6.611613] REISERFS (device hda1): Using r5 hash to sort names
> [   14.180410] udevd version 125 started
> [   17.303283] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
> [   17.394543] rtc0: alarms up to one day, 114 bytes nvram
> [   18.090664] cfg80211: Calling CRDA to update world regulatory domain
> [   18.944222] usb 2-2: reset high speed USB device using ehci_hcd and
> address 2
> [   19.141331] usbcore: registered new interface driver carl9170
> [   19.244279] usb 4-2: reset high speed USB device using ehci_hcd and
> address 2
> [   19.286717] usb 2-2: driver   API: 1.8.8.3 2010-09-28 [1-1]
> [   19.292335] usb 2-2: firmware API: 1.8.8.3 2010-09-28
> [   19.482896] ieee80211 phy0: p54 detected a LM87 firmware ----------phy0
> used by p54usb
> [   19.492278] p54: rx_mtu reduced from 3240 to 2384
> [   19.500711] ieee80211 phy0: FW rev 2.13.24.0 - Softmac protocol 5.9
> [   19.507146] ieee80211 phy0: cryptographic accelerator WEP:YES, TKIP:YES,
> CCMP:YES
> [   20.511550] ieee80211 phy0: hwaddr 00:0b:6b:9d:9e:12, MAC:isl3887
> RF:Frisbee
> [   20.596019] ath: EEPROM regdomain: 0x809c
> [   20.596047] ath: EEPROM indicates we should expect a country code
> [   20.596070] ath: doing EEPROM country->regdmn map search
> [   20.596091] ath: country maps to regdmn code: 0x52
> [   20.596112] ath: Country alpha2 being used: CN
> [   20.596130] ath: Regpair used: 0x52
> [   20.596317] ------------[ cut here ]------------
> [   20.600994] WARNING: at fs/sysfs/dir.c:451 sysfs_add_one+0x82/0xa0()
> [   20.624263] sysfs: cannot create duplicate filename
> '/class/ieee80211/phy0' --seems carl9170 want to use the same phy id which
> was taken by p54usb
> [   20.631249] Modules linked in: p54usb(+) carl9170 p54common led_class
> crc_ccitt mac80211 ath cfg80211 rtc_cmos ehci_hcd ohci_hcd usbcore
> ide_gd_mod
> [   20.664483] Pid: 1141, comm: firmware/carl91 Not tainted
> 2.6.36-rc6-wl-wlplug20101006 #1
> [   20.672595] Call Trace:
> [   20.684320]  [<c10d0d52>] ? sysfs_add_one+0x82/0xa0
> [   20.689235]  [<c10d0d52>] ? sysfs_add_one+0x82/0xa0
> [   20.694159]  [<c101e37c>] warn_slowpath_common+0x6c/0xa0
> [   20.714291]  [<c10d0d52>] ? sysfs_add_one+0x82/0xa0
> [   20.719210]  [<c101e42e>] warn_slowpath_fmt+0x2e/0x30
> [   20.734351]  [<c10d0d52>] sysfs_add_one+0x82/0xa0
> [   20.739098]  [<c10d1c71>] sysfs_do_create_link+0xf1/0x1d0
> [   20.754405]  [<c10d0565>] ? sysfs_add_file_mode+0x55/0x90
> [   20.759855]  [<c10d1d82>] sysfs_create_link+0x12/0x20
> [   20.774302]  [<c1190d74>] device_add+0x124/0x580
> [   20.779007]  [<e099091b>] wiphy_register+0x19b/0x280 [cfg80211]
> [   20.794752]  [<c1083cb0>] ? __kmalloc+0x70/0xc0
> [   20.799374]  [<e0a5442e>] ieee80211_register_hw+0x17e/0x530 [mac80211]
> [   20.824361]  [<e0b265f0>] ? carl9170_reg_notifier+0x0/0x40 [carl9170]
> [   20.830849]  [<e0b2639e>] carl9170_register+0x1ee/0x440 [carl9170]
> [   20.844310]  [<c1197920>] ? request_firmware_work_func+0x0/0x80
> [   20.850280]  [<e0b29ed1>] carl9170_usb_firmware_step2+0x81/0xe0
> [carl9170]
> [   20.874296]  [<c1197920>] ? request_firmware_work_func+0x0/0x80
> [   20.880253]  [<c119795b>] request_firmware_work_func+0x3b/0x80
> [   20.894782]  [<c1035c24>] kthread+0x74/0x80
> [   20.899003]  [<c1035bb0>] ? kthread+0x0/0x80
> [   20.903307]  [<c1002fb6>] kernel_thread_helper+0x6/0x10
> [   20.924282] ---[ end trace 9fa154a9ec88252b ]---
> [   21.238237] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
> [   21.240677] Registered led device: p54-phy0::assoc
> [   21.240874] Registered led device: p54-phy0::tx
> [   21.241065] Registered led device: p54-phy0::rx
> [   21.241259] Registered led device: p54-phy0::radio
> [   21.241331] usb 4-2: is registered as 'phy0'
> [   21.251183] usbcore: registered new interface driver p54usb
> [   21.287635] udev: renamed network interface wlan0 to wlan2
> [   23.197295] Adding 1004024k swap on /dev/hda5.  Priority:-1 extents:1
> across:1004024k
> 
> and when I replug the usb device it shows:
> 
> [  381.379902] usb 2-2: USB disconnect, address 2
> [  384.589713] usb 2-2: new high speed USB device using ehci_hcd and address
> 3
> [  384.797802] usb 2-2: New USB device found, idVendor=0cf3, idProduct=1002
> [  384.805225] usb 2-2: New USB device strings: Mfr=16, Product=32,
> SerialNumber=48
> [  384.813306] usb 2-2: Product: USB2.0 WLAN
> [  384.817350] usb 2-2: Manufacturer: ATHER
> [  384.822311] usb 2-2: SerialNumber: 12345
> [  385.229748] usb 2-2: reset high speed USB device using ehci_hcd and
> address 3
> [  385.428787] usbcore: registered new interface driver carl9170
> [  385.501003] usb 2-2: driver   API: 1.8.8.3 2010-09-28 [1-1]
> [  385.506622] usb 2-2: firmware API: 1.8.8.3 2010-09-28
> [  386.805068] ath: EEPROM regdomain: 0x809c
> [  386.805095] ath: EEPROM indicates we should expect a country code
> [  386.805119] ath: doing EEPROM country->regdmn map search
> [  386.805139] ath: country maps to regdmn code: 0x52
> [  386.805161] ath: Country alpha2 being used: CN
> [  386.805178] ath: Regpair used: 0x52
> [  386.812918] ieee80211 phy1: Selected rate control algorithm 'minstrel_ht'
> [  386.816154] cfg80211: Calling CRDA for country: CN
> [  386.833303] input: phy1 WPS Button as
> /devices/pci0000:00/0000:00:0a.1/usb2/2-2/2-2:1.0/ieee80211/phy1/input0
> [  386.846922] udev: renamed network interface wlan0 to wlan6
> [  386.879907] usb 2-2: Atheros AR9170 is registered as 'phy1'  --------
> 
> then all goes fine."
> 
> In a roundup he said that the bug might originate from:
> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commitdiff;h=5a254ffe3ffdfa84fe076009bd8e88da412180d2
> 
> and that a previous version of net/wireless/core.c
> solved the problem.
> 


