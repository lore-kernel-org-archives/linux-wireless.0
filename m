Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nexicom.net ([216.168.96.13]:47622 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab1A0UwH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 15:52:07 -0500
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-118-36.nexicom.net [216.168.118.36])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p0RKq2fh027671
	for <linux-wireless@vger.kernel.org>; Thu, 27 Jan 2011 15:52:03 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id D3D2098479
	for <linux-wireless@vger.kernel.org>; Thu, 27 Jan 2011 15:52:01 -0500 (EST)
Message-ID: <4D41DAF1.6080204@lockie.ca>
Date: Thu, 27 Jan 2011 15:52:01 -0500
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: did compat-wireless-2011-01-27 crash dhcpcd?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211: Calling CRDA to update world regulatory domain
Compat-wireless backport release: compat-wireless-2011-01-06-3-g8db1608
Backport based on linux-next.git next-20110121
ath9k 0000:02:09.0: PCI INT A -> Link[LNKB] -> GSI 17 (level, low) -> IRQ 17
ath: EEPROM regdomain: 0x10
ath: EEPROM indicates we should expect a direct regpair map
ath: Country alpha2 being used: CO
ath: Regpair used: 0x10
ieee80211 phy0: Selected rate control algorithm 'ath9k_rate_control'
cfg80211: wext will not work because kernel was compiled with
CONFIG_WIRELESS_EXT=n. Tools using wext interface, like iwconfig will
not work.
BUG: unable to handle kernel NULL pointer dereference at 00000000000001dc
IP: [<ffffffff8130fb9d>] wext_handle_ioctl+0xae/0x165
PGD 2262a9067 PUD 2262c7067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file:
/sys/devices/pci0000:00/0000:00:08.0/0000:02:09.0/net/wlan0/type
CPU 0
Modules linked in: ath9k(+) mac80211 compat ath9k_common ath9k_hw ath
cfg80211 nvidia(P) [last unloaded: cfg80211]

Pid: 1795, comm: dhcpcd Tainted: P            2.6.37 #14
ALiveNF5-eSATA2+ /To Be Filled By O.E.M.
RIP: 0010:[<ffffffff8130fb9d>]  [<ffffffff8130fb9d>]
wext_handle_ioctl+0xae/0x165
RSP: 0018:ffff88022632fd68  EFLAGS: 00010283
RAX: 0000000000000104 RBX: ffff88022632fdf8 RCX: 000000000000001b
RDX: 0000000000008b1b RSI: 000000000000e050 RDI: ffff8801d2431000
RBP: 0000000000000001 R08: ffffffff8130f43d R09: 000000000000000a
R10: 0000000000000000 R11: 0000000001e683bc R12: 00007fff01d6fa40
R13: ffffffff815d7f10 R14: 0000000000000000 R15: 00007fff01d6fb60
FS:  00007fcad00c1700(0000) GS:ffff8800cec00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000001dc CR3: 000000022760c000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process dhcpcd (pid: 1795, threadinfo ffff88022632e000, task
ffff8802285f7380)
Stack:
 0000000000000008 0000000000008b1b 00007fca00008b1b ffffffff812c3834
 0000000000008b1b ffffffff815d7f10 00007fff01d6fa40 0000000000000000
 0000000000000000 ffffffff812c48b8 ffff8801d24315c8 ffff8801d24315b8
Call Trace:
 [<ffffffff812c3834>] ? dev_get_by_name_rcu+0x89/0x95
 [<ffffffff812c48b8>] ? dev_ioctl+0x5f9/0x63b
 [<ffffffff812b687a>] ? sk_prot_alloc+0x8b/0xe3
 [<ffffffff812b2a4d>] ? sock_ioctl+0x225/0x232
 [<ffffffff81093845>] ? get_empty_filp+0x9d/0x155
 [<ffffffff8109ee1b>] ? do_vfs_ioctl+0x479/0x4c6
 [<ffffffff812b3e20>] ? sock_alloc_file+0xc9/0x127
 [<ffffffff81090bd0>] ? fd_install+0x27/0x4d
 [<ffffffff8109eeb3>] ? sys_ioctl+0x4b/0x6f
 [<ffffffff81001e3b>] ? system_call_fastpath+0x16/0x1b
Code: 85 c0 74 4a 48 8b 00 48 85 c0 74 42 48 8b 80 f8 01 00 00 48 85 c0
74 36 0f b7 70 08 8d 8a 00 75 ff ff 39 f1 73 28 48 8b 00 89 c9 <4c> 8b
04 c8 4d 85 c0 74 1a 81 fa df 8b 00 00 77 12 48 8d 4c 24
RIP  [<ffffffff8130fb9d>] wext_handle_ioctl+0xae/0x165
 RSP <ffff88022632fd68>
CR2: 00000000000001dc
---[ end trace 31d89d579b4bd813 ]---
Registered led device: ath9k-phy0::radio
Registered led device: ath9k-phy0::assoc
Registered led device: ath9k-phy0::tx
Registered led device: ath9k-phy0::rx
ieee80211 phy0: Atheros AR5416 MAC/BB Rev:2 AR2133 RF Rev:81
mem=0xffffc90003a00000, irq=17
