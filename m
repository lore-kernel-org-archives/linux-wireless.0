Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.passe0815.de ([188.40.49.9]:59931 "EHLO mail.passe0815.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366AbbHWNto (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Aug 2015 09:49:44 -0400
Received: from mail.passe0815.de (localhost [127.0.0.1])
	by mail.passe0815.de (Postfix) with ESMTP id A8972586956
	for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2015 15:41:42 +0200 (CEST)
Received: from localhost (unknown [IPv6:2001:67c:2d50:0:fd32:a7a:49af:a203])
 (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
 (No client certificate requested)
 by mail.passe0815.de (Postfix) with ESMTPSA id 9ABF2586941
 for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2015 15:41:39 +0200 (CEST)
Date: Sun, 23 Aug 2015 15:41:32 +0200
From: Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
To: linux-wireless@vger.kernel.org
Subject: Wifi hang+trace with TP-Link TL-WDN4200 USB stick (rt2800usb)
Message-ID: <20150823134132.GB11019@odroid> (sfid-20150823_154956_848509_8BC3F167)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

During the Chaos Communication Camp a week ago - probably a
very stressful environment for wifi drivers - I experienced a couple
of wifi hangups a day. Trying to simply reconnect with iw or a
network manager did not help. Rebooting solved the issue.

During hangup the following trace appeared in dmesg:

-----
[  822.795889] wlan0: authentication with ac:a3:1e:d9:5d:d0 timed out
[  836.219094] wlan0: authenticate with 6c:f3:7f:ec:e9:d0
[  836.386110] wlan0: direct probe to 6c:f3:7f:ec:e9:d0 (try 1/3)
[  836.595199] wlan0: direct probe to 6c:f3:7f:ec:e9:d0 (try 2/3)
[  836.805168] wlan0: direct probe to 6c:f3:7f:ec:e9:d0 (try 3/3)
[  837.015145] wlan0: authentication with 6c:f3:7f:ec:e9:d0 timed out
[  850.406952] wlan0: authenticate with ac:a3:1e:d9:5e:d0
[  850.575102] wlan0: direct probe to ac:a3:1e:d9:5e:d0 (try 1/3)
[  850.784470] wlan0: direct probe to ac:a3:1e:d9:5e:d0 (try 2/3)
[  850.994453] wlan0: direct probe to ac:a3:1e:d9:5e:d0 (try 3/3)
[  851.204576] wlan0: authentication with ac:a3:1e:d9:5e:d0 timed out
[  864.824543] wlan0: authenticate with 94:b4:0f:30:02:30
[  864.953566] wlan0: direct probe to 94:b4:0f:30:02:30 (try 1/3)
[  865.163937] wlan0: direct probe to 94:b4:0f:30:02:30 (try 2/3)
[  865.285268] ------------[ cut here ]------------
[  865.285899] WARNING: CPU: 0 PID: 3254 at net/wireless/sme.c:929 cfg80211_connect+0x3f0/0x448 [cfg80211]()
[  865.285984] Modules linked in: ctr ccm rfcomm bnep binfmt_misc ipv6 snd_bcm2835 snd_pcm snd_seq snd_seq_device snd_timer snd arc4 rt2800usb rt2800lib rt2x00usb rt2x00lib btusb mac80211 joydev evdev cfg80211 crc_ccitt bluetooth rfkill uio_pdrv_genirq uio
[  865.286123] CPU: 0 PID: 3254 Comm: iw Tainted: G        W       4.0.8+ #805
[  865.286138] Hardware name: BCM2708
[  865.286253] [<c0015f08>] (unwind_backtrace) from [<c0012ce0>] (show_stack+0x20/0x24)
[  865.286302] [<c0012ce0>] (show_stack) from [<c0576208>] (dump_stack+0x20/0x28)
[  865.286388] [<c0576208>] (dump_stack) from [<c0023288>] (warn_slowpath_common+0x8c/0xc4)
[  865.286471] [<c0023288>] (warn_slowpath_common) from [<c002337c>] (warn_slowpath_null+0x2c/0x34)
[  865.286909] [<c002337c>] (warn_slowpath_null) from [<bf122104>] (cfg80211_connect+0x3f0/0x448 [cfg80211])
[  865.287663] [<bf122104>] (cfg80211_connect [cfg80211]) from [<bf1188f4>] (nl80211_connect+0x2d0/0x390 [cfg80211])
[  865.288125] [<bf1188f4>] (nl80211_connect [cfg80211]) from [<c04c7fcc>] (genl_rcv_msg+0x25c/0x3dc)
[  865.288251] [<c04c7fcc>] (genl_rcv_msg) from [<c04c7234>] (netlink_rcv_skb+0xbc/0xd0)
[  865.288290] [<c04c7234>] (netlink_rcv_skb) from [<c04c7d5c>] (genl_rcv+0x30/0x44)
[  865.288323] [<c04c7d5c>] (genl_rcv) from [<c04c6b94>] (netlink_unicast+0x164/0x220)
[  865.288353] [<c04c6b94>] (netlink_unicast) from [<c04c7000>] (netlink_sendmsg+0x2fc/0x370)
[  865.288396] [<c04c7000>] (netlink_sendmsg) from [<c047e530>] (do_sock_sendmsg+0x84/0xa8)
[  865.288442] [<c047e530>] (do_sock_sendmsg) from [<c047fb58>] (___sys_sendmsg+0x21c/0x230)
[  865.288480] [<c047fb58>] (___sys_sendmsg) from [<c0480910>] (__sys_sendmsg+0x4c/0x7c)
[  865.288512] [<c0480910>] (__sys_sendmsg) from [<c0480958>] (SyS_sendmsg+0x18/0x1c)
[  865.288558] [<c0480958>] (SyS_sendmsg) from [<c000e860>] (ret_fast_syscall+0x0/0x54)
[  865.288618] ---[ end trace 2a0b1d980b2ed673 ]---
[  865.288645] ------------[ cut here ]------------
[  865.289065] WARNING: CPU: 0 PID: 3254 at net/wireless/sme.c:444 cfg80211_connect+0x420/0x448 [cfg80211]()
[  865.289083] Modules linked in: ctr ccm rfcomm bnep binfmt_misc ipv6 snd_bcm2835 snd_pcm snd_seq snd_seq_device snd_timer snd arc4 rt2800usb rt2800lib rt2x00usb rt2x00lib btusb mac80211 joydev evdev cfg80211 crc_ccitt bluetooth rfkill uio_pdrv_genirq uio
[  865.289270] CPU: 0 PID: 3254 Comm: iw Tainted: G        W       4.0.8+ #805
[  865.289318] Hardware name: BCM2708
[  865.289388] [<c0015f08>] (unwind_backtrace) from [<c0012ce0>] (show_stack+0x20/0x24)
[  865.289442] [<c0012ce0>] (show_stack) from [<c0576208>] (dump_stack+0x20/0x28)
[  865.289533] [<c0576208>] (dump_stack) from [<c0023288>] (warn_slowpath_common+0x8c/0xc4)
[  865.289605] [<c0023288>] (warn_slowpath_common) from [<c002337c>] (warn_slowpath_null+0x2c/0x34)
[  865.290025] [<c002337c>] (warn_slowpath_null) from [<bf122134>] (cfg80211_connect+0x420/0x448 [cfg80211])
[  865.290705] [<bf122134>] (cfg80211_connect [cfg80211]) from [<bf1188f4>] (nl80211_connect+0x2d0/0x390 [cfg80211])
[  865.291253] [<bf1188f4>] (nl80211_connect [cfg80211]) from [<c04c7fcc>] (genl_rcv_msg+0x25c/0x3dc)
[  865.291366] [<c04c7fcc>] (genl_rcv_msg) from [<c04c7234>] (netlink_rcv_skb+0xbc/0xd0)
[  865.291401] [<c04c7234>] (netlink_rcv_skb) from [<c04c7d5c>] (genl_rcv+0x30/0x44)
[  865.291435] [<c04c7d5c>] (genl_rcv) from [<c04c6b94>] (netlink_unicast+0x164/0x220)
[  865.291465] [<c04c6b94>] (netlink_unicast) from [<c04c7000>] (netlink_sendmsg+0x2fc/0x370)
[  865.291507] [<c04c7000>] (netlink_sendmsg) from [<c047e530>] (do_sock_sendmsg+0x84/0xa8)
[  865.291543] [<c047e530>] (do_sock_sendmsg) from [<c047fb58>] (___sys_sendmsg+0x21c/0x230)
[  865.291578] [<c047fb58>] (___sys_sendmsg) from [<c0480910>] (__sys_sendmsg+0x4c/0x7c)
[  865.291610] [<c0480910>] (__sys_sendmsg) from [<c0480958>] (SyS_sendmsg+0x18/0x1c)
[  865.291650] [<c0480958>] (SyS_sendmsg) from [<c000e860>] (ret_fast_syscall+0x0/0x54)
[  865.291670] ---[ end trace 2a0b1d980b2ed674 ]---
[  865.373895] wlan0: direct probe to 94:b4:0f:30:02:30 (try 3/3)
[  865.583754] wlan0: authentication with 94:b4:0f:30:02:30 timed out
-----

Board: Odroid-W
Kernel version: 4.0.8 (from Raspbian)
Device: TP-Link TL-WDN4200
Chipset: Ralink RT3573
lsusb: Bus 001 Device 006: ID 148f:3573 Ralink Technology, Corp. TEW-684UB
Driver: rt2800usb

Cheers, Linus

PS: At home and at various other locations I haven't had this
issue so far. Since the Chaos Communication Camp event is over, it
might be difficult for me to reproduce the issue.
