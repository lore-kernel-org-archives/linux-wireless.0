Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:39448
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757874AbXG0M3k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 08:29:40 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
Subject: mac80211: BUG sleeping function called from invalid context
Date: Fri, 27 Jul 2007 14:27:26 +0200
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200707271427.27261.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[  182.608472] bcm43xx-phy0 debug: Wireless interface started
[  182.619150] HW CONFIG: channel=1 freq=2412 phymode=3
[  182.703230] ADDRCONF(NETDEV_UP): sta0: link is not ready
[  183.070139] HW CONFIG: channel=1 freq=2412 phymode=3
[  183.130011] HW CONFIG: channel=2 freq=2417 phymode=3
[  183.210009] HW CONFIG: channel=3 freq=2422 phymode=3
[  183.290014] HW CONFIG: channel=4 freq=2427 phymode=3
[  183.370009] HW CONFIG: channel=5 freq=2432 phymode=3
[  183.450007] HW CONFIG: channel=6 freq=2437 phymode=3
[  183.530007] HW CONFIG: channel=7 freq=2442 phymode=3
[  183.610007] HW CONFIG: channel=8 freq=2447 phymode=3
[  183.690008] HW CONFIG: channel=9 freq=2452 phymode=3
[  183.770010] HW CONFIG: channel=10 freq=2457 phymode=3
[  183.850007] HW CONFIG: channel=11 freq=2462 phymode=3
[  183.930011] HW CONFIG: channel=1 freq=2412 phymode=3
[  183.950972] BUG: sleeping function called from invalid context at mm/slab.c:3024
[  183.951305] in_atomic():1, irqs_disabled():0
[  183.952456] Call Trace:
[  183.953521] [db633cc0] [c0008978] show_stack+0x50/0x184 (unreliable)
[  183.954780] [db633ce0] [c002a164] __might_sleep+0xc0/0xd4
[  183.955982] [db633cf0] [c007862c] kmem_cache_alloc+0x34/0x118
[  183.957198] [db633d10] [e25fa20c] ieee80211_sta_scan_results+0x548/0x750 [mac80211]
[  183.958564] [db633d60] [e25efea0] ieee80211_ioctl_giwscan+0x50/0x80 [mac80211]
[  183.959840] [db633d70] [c04200f8] ioctl_standard_call+0x2ac/0x420
[  183.961062] [db633de0] [c0420320] wext_handle_ioctl+0xb4/0x4b4
[  183.962236] [db633e20] [c0341970] dev_ioctl+0x644/0x6cc
[  183.963393] [db633ea0] [c0331ef0] sock_ioctl+0x258/0x27c
[  183.964559] [db633ec0] [c0089494] do_ioctl+0x44/0xa8
[  183.965715] [db633ee0] [c00898fc] vfs_ioctl+0x404/0x440
[  183.966863] [db633f10] [c0089978] sys_ioctl+0x40/0x70
[  183.967993] [db633f40] [c0012fac] ret_from_syscall+0x0/0x38
[  183.969177] --- Exception: c01 at 0xfd56240
[  183.970270]     LR = 0xfdddd34
[  183.985762] HW CONFIG: channel=11 freq=2462 phymode=3

-- 
Greetings Michael.
