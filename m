Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:62870 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932935Ab1IBJuu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 05:50:50 -0400
Subject: Oops while loading firmware of ath9k_htc device.
From: Christian Kapeller <christian.kapeller@cmotion.eu>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Sep 2011 11:33:25 +0200
Message-ID: <1314956005.12761.10.camel@christian-kapeller> (sfid-20110902_115055_868805_71B77464)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, 

I already posted this message on ath9k-devel, but retrospectively
it was wrong there. I just tried another another some other module 
(ID 148f:3572 Ralink Technology, Corp. RT3572 Wireless Adapter)
The issue stays basically the same, and appears, when the module is
trying to load it's firmware. I'll provide this oops if it is wanted.
I'm sorry for the hassle.




when loading the ath9k_htc module for my TL-WN722N device, I get an
oops. 

I use the openwrt backfire distribution on an arm device, with kernel
2.6.31.12 and compat-wireless-2011-06-22. The firmware file is at
/lib/firmware/ar9271.fw

The device identifies as: 

ID 0cf3:9271 Atheros Communications, Inc. AR9271 802.11n


The backtrace looks as follows:


Unable to handle kernel NULL pointer dereference at virtual address
00000048
pgd = c0004000
[00000048] *pgd=00000000
Internal error: Oops: 17 [#1] PREEMPT
Modules linked in: xt_owner ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE
iptable_nat nf_nat xt_CONNMARK xt_recent xt_helper xt_conntrack
xt_connmark xt_connbytes xt_NOTRACK iptable_raw xt_state
nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack ehci_hcd sd_mod ipt_REJECT
xt_TCPMSS ipt_LOG xt_comment xt_multiport xt_mac xt_limit iptable_mangle
iptable_filter ext3 jbd vfat fat ntfs ath9k_htc ath9k_common ath9k_hw
ath nls_utf8 nls_iso8859_15 nls_iso8859_1 nls_cp437 mac80211 usbcore
scsi_mod mbcache cfg80211 compat lib80211_crypt_tkip lib80211_crypt_ccmp
lib80211_crypt_wep lib80211 arc4 aes_generic deflate ecb
CPU: 0    Not tainted  (2.6.31.12 #1)
PC is at get_device_parent+0x78/0x14c
LR is at get_device_parent+0x70/0x14c
pc : [<c01afc88>]    lr : [<c01afc80>]    psr: 80000013
sp : c6447b88  ip : c6447b88  fp : c6447ba4
r10: 00000001  r9 : c65ffd0c  r8 : c661cc60
r7 : c6172af0  r6 : c65992b8  r5 : c65992c0  r4 : c6172af0
r3 : 00000000  r2 : 00000000  r1 : 00000000  r0 : 00000001
Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 10c5387d  Table: 9640c019  DAC: 00000017
Process khubd (pid: 728, stack limit = 0xc64462e8)
Stack: (0xc6447b88 to 0xc6448000)
7b80:                   c65992b8 c65992c0 00000000 c6599280 c6447bec
c6447ba8 
7ba0: c01b0cb4 c01afc1c c6172ae8 c6172ae8 00000000 c6599280 c6447be0
c6447bc8 
7bc0: c01b0128 c6172ae8 c65992b8 00000000 c6599280 c661cc60 c65ffd0c
00000001 
7be0: c6447c1c c6447bf0 bf03b92c c01b0c18 00000001 c6172a80 c65ffd00
c6599140 
7c00: bf17b4a8 c65ed388 bf17b41c 00000000 c6447c34 c6447c20 bf03bbcc
bf03b7c8 
7c20: 00000000 bf17b41c c6447c64 c6447c38 bf16948c bf03bbb8 c6599160
c6599140 
7c40: c6599160 c6599140 00000000 c6172a80 bf17b44c bf17b4a8 c6447c94
c6447c68 
7c60: bf09ad4c bf1692c4 bf09ac58 c6599160 bf17b44c c01b3528 00000000
00000000 
7c80: c65eed80 bf0ab8d4 c6447cbc c6447c98 c01b33c4 bf09ac64 c661ca20
c6447ca8 
7ca0: bf17b44c c6599160 c01b3528 00000000 c6447cd4 c6447cc0 c01b356c
c01b32e8 
7cc0: c6599160 c6447cd8 c6447cfc c6447cd8 c01b2860 c01b3534 c63f4588
c63fbf34 
7ce0: c6599194 c6599160 00000000 c6599140 c6447d14 c6447d00 c01b35f4
c01b2818 
7d00: c6599160 c6599168 c6447d24 c6447d18 c01b268c c01b35a8 c6447d6c
c6447d28 
7d20: c01b0f60 c01b266c c661c9c0 c6172ae8 c6447d6c c6447d40 c00a24fc
c00a090c 
7d40: 00000009 c6172a80 00000000 c65eed80 c6599140 00000000 c65eed80
00000001 
7d60: c6447ddc c6447d70 bf099698 c01b0c18 00000001 00000000 00000000
00000000 
7d80: 00001388 c6447d90 c0287f44 c6599140 00000000 c6172a84 c65eed80
00000000 
7da0: c6172ae8 c65eed84 c661c9c0 00000001 c64882a0 c6172a80 bf0abf3c
00000001 
7dc0: 00000000 00000000 c618d8c0 bf0ab750 c6447e04 c6447de0 bf0a148c
bf099174 
7de0: c00ec428 c00ec27c c6447e14 c6172ae8 bf0abf3c c01b3528 c6447e14
c6447e08 
7e00: bf099958 bf0a1444 c6447e3c c6447e18 c01b33c4 bf099934 c64882a0
00000000 
7e20: bf0abf3c c6172ae8 c01b3528 00000000 c6447e54 c6447e40 c01b356c
c01b32e8 
7e40: c6172ae8 c6447e58 c6447e7c c6447e58 c01b2860 c01b3534 c63f4588
c63fbdf4 
7e60: c6172b1c c6172ae8 00000000 c600a300 c6447e94 c6447e80 c01b35f4
c01b2818 
7e80: c6172ae8 c6172af0 c6447ea4 c6447e98 c01b268c c01b35a8 c6447eec
c6447ea8 
7ea0: c01b0f60 c01b266c c6447ed4 c6173be8 3a393831 c00a0031 00000000
c6172a80 
7ec0: 00000000 c6172a80 00000000 c6172ae8 c6173b80 00000001 c618d8c0
00000002 
7ee0: c6447f0c c6447ef0 bf093098 c01b0c18 c6256280 c6172a80 00000000
c6173b80 
7f00: c6447fc4 c6447f10 bf094358 bf093040 c6447f44 c6447f20 c0063728
c003beb0 
7f20: c035df0c ffffffff c6032000 c618d8d4 c6447f84 c62562b8 c62562c0
00000000 
7f40: c6173c1c c6256288 c6256310 00000101 c6446000 c6256640 c62562bc
c6256280 
7f60: c6173b80 c6173d5c c6173b80 c6256660 c6256660 00000000 00000000
c643a700 
7f80: c005eb5c c6447f84 c6447f84 00000101 01010001 00000000 c6447fc4
c645deb8 
7fa0: c6447fcc bf093a30 00000000 00000000 00000000 00000000 c6447ff4
c6447fc8 
7fc0: c005e8f8 bf093a3c 00000000 00000000 c6447fd0 c6447fd0 00000000
00000000 
7fe0: 00000000 00000000 00000000 c6447ff8 c004c50c c005e880 e59f40c8
e5912004 
Backtrace: 
[<c01afc10>] (get_device_parent+0x0/0x14c) from [<c01b0cb4>] (device_add
+0xa8/0x4e0)
 r7:c6599280 r6:00000000 r5:c65992c0 r4:c65992b8
[<c01b0c0c>] (device_add+0x0/0x4e0) from [<bf03b92c>]
(firmware_data_write+0x34c/0x548 [compat])
[<bf03b7bc>] (firmware_data_write+0x1dc/0x548 [compat]) from
[<bf03bbcc>] (compat_request_firmware+0x20/0xa0 [compat])
[<bf03bbac>] (compat_request_firmware+0x0/0xa0 [compat]) from
[<bf16948c>] (ath9k_hif_usb_probe+0x1d4/0x370 [ath9k_htc])
[<bf1692b8>] (ath9k_hif_usb_probe+0x0/0x370 [ath9k_htc]) from
[<bf09ad4c>] (usb_probe_interface+0xf4/0x144 [usbcore])
[<bf09ac58>] (usb_probe_interface+0x0/0x144 [usbcore]) from [<c01b33c4>]
(driver_probe_device+0xe8/0x1c0)
[<c01b32dc>] (driver_probe_device+0x0/0x1c0) from [<c01b356c>]
(__device_attach+0x44/0x48)
 r7:00000000 r6:c01b3528 r5:c6599160 r4:bf17b44c
[<c01b3528>] (__device_attach+0x0/0x48) from [<c01b2860>]
(bus_for_each_drv+0x54/0x94)
 r5:c6447cd8 r4:c6599160
[<c01b280c>] (bus_for_each_drv+0x0/0x94) from [<c01b35f4>]
(device_attach+0x58/0x70)
 r7:c6599140 r6:00000000 r5:c6599160 r4:c6599194
[<c01b359c>] (device_attach+0x0/0x70) from [<c01b268c>]
(bus_probe_device+0x2c/0x48)
 r5:c6599168 r4:c6599160
[<c01b2660>] (bus_probe_device+0x0/0x48) from [<c01b0f60>] (device_add
+0x354/0x4e0)
[<c01b0c0c>] (device_add+0x0/0x4e0) from [<bf099698>]
(usb_set_configuration+0x530/0x5c0 [usbcore])
[<bf099168>] (usb_set_configuration+0x0/0x5c0 [usbcore]) from
[<bf0a148c>] (generic_probe+0x54/0x98 [usbcore])
[<bf0a1438>] (generic_probe+0x0/0x98 [usbcore]) from [<bf099958>]
(usb_probe_device+0x30/0x34 [usbcore])
 r6:c01b3528 r5:bf0abf3c r4:c6172ae8
[<bf099928>] (usb_probe_device+0x0/0x34 [usbcore]) from [<c01b33c4>]
(driver_probe_device+0xe8/0x1c0)
[<c01b32dc>] (driver_probe_device+0x0/0x1c0) from [<c01b356c>]
(__device_attach+0x44/0x48)
 r7:00000000 r6:c01b3528 r5:c6172ae8 r4:bf0abf3c
[<c01b3528>] (__device_attach+0x0/0x48) from [<c01b2860>]
(bus_for_each_drv+0x54/0x94)
 r5:c6447e58 r4:c6172ae8
[<c01b280c>] (bus_for_each_drv+0x0/0x94) from [<c01b35f4>]
(device_attach+0x58/0x70)
 r7:c600a300 r6:00000000 r5:c6172ae8 r4:c6172b1c
[<c01b359c>] (device_attach+0x0/0x70) from [<c01b268c>]
(bus_probe_device+0x2c/0x48)
 r5:c6172af0 r4:c6172ae8
[<c01b2660>] (bus_probe_device+0x0/0x48) from [<c01b0f60>] (device_add
+0x354/0x4e0)
[<c01b0c0c>] (device_add+0x0/0x4e0) from [<bf093098>] (usb_new_device
+0x64/0xc0 [usbcore])
[<bf093034>] (usb_new_device+0x0/0xc0 [usbcore]) from [<bf094358>]
(hub_thread+0x928/0xe40 [usbcore])
 r7:c6173b80 r6:00000000 r5:c6172a80 r4:c6256280
[<bf093a30>] (hub_thread+0x0/0xe40 [usbcore]) from [<c005e8f8>] (kthread
+0x84/0x8c)
[<c005e874>] (kthread+0x0/0x8c) from [<c004c50c>] (do_exit+0x0/0x600)
 r7:00000000 r6:00000000 r5:00000000 r4:00000000
Code: e3a00001 ebfa490e e596309c e5933030 (e5b30048) 
---[ end trace 18e995399c79b314 ]---
note: khubd[728] exited with preempt_count 1


Something goes wrong, starting in compat_firmware_class.c. I wasn't able
to nail it down yet.

Is this problem known?

best regards,
christian

