Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:5039 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669AbZGXSpc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 14:45:32 -0400
Subject: new lockdep warning in 2.6.31-rc3-wl
From: reinette chatre <reinette.chatre@intel.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain
Date: Fri, 24 Jul 2009 11:45:32 -0700
Message-Id: <1248461132.1216.53.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I saw this right after association. This is with the latest
wireless-testing.

[   65.053475] =======================================================
[   65.053562] [ INFO: possible circular locking dependency detected ]
[   65.053608] 2.6.31-rc3-wl #13
[   65.053649] -------------------------------------------------------
[   65.053694] phy0/3223 is trying to acquire lock:
[   65.053738]  (cfg80211_mutex){+.+.+.}, at: [<ffffffffa01c9a72>] regulatory_hint_11d+0x32/0x430 [cfg80211]
[   65.053887] 
[   65.053888] but task is already holding lock:
[   65.053968]  (&ifmgd->mtx){+.+.+.}, at: [<ffffffffa0220f78>] ieee80211_sta_work+0x118/0x11c0 [mac80211]
[   65.054120] 
[   65.054120] which lock already depends on the new lock.
[   65.054121] 
[   65.054239] 
[   65.054240] the existing dependency chain (in reverse order) is:
[   65.054322] 
[   65.054323] -> #3 (&ifmgd->mtx){+.+.+.}:
[   65.054483]        [<ffffffff8106f994>] __lock_acquire+0x1164/0x1b50
[   65.054558]        [<ffffffff81070453>] lock_acquire+0xd3/0x100
[   65.054630]        [<ffffffff81323e65>] mutex_lock_nested+0x45/0x320
[   65.054705]        [<ffffffffa021ed35>] ieee80211_mgd_auth+0xf5/0x1f0 [mac80211]
[   65.054798]        [<ffffffffa0225623>] ieee80211_auth+0x13/0x20 [mac80211]
[   65.054880]        [<ffffffffa01d5ac1>] __cfg80211_mlme_auth+0x1b1/0x290 [cfg80211]
[   65.054971]        [<ffffffffa01d7d6b>] cfg80211_conn_do_work+0xdb/0x1b0 [cfg80211]
[   65.055061]        [<ffffffffa01d8217>] __cfg80211_connect+0x3d7/0x4c0 [cfg80211]
[   65.055150]        [<ffffffffa01db9ed>] cfg80211_mgd_wext_connect+0xcd/0x180 [cfg80211]
[   65.055240]        [<ffffffffa01dbc2f>] cfg80211_mgd_wext_siwap+0x18f/0x210 [cfg80211]
[   65.055329]        [<ffffffffa021698c>] ieee80211_ioctl_siwap+0x1c/0x70 [mac80211]
[   65.055421]        [<ffffffff8130ebc3>] ioctl_standard_call+0x63/0x460
[   65.055495]        [<ffffffff8130e7bb>] wext_handle_ioctl+0x16b/0x240
[   65.055568]        [<ffffffff8128cd02>] dev_ioctl+0x3f2/0x5f0
[   65.055642]        [<ffffffff81277059>] sock_ioctl+0x89/0x290
[   65.055715]        [<ffffffff810fe201>] vfs_ioctl+0x31/0xa0
[   65.055787]        [<ffffffff810fe38a>] do_vfs_ioctl+0x8a/0x5c0
[   65.055859]        [<ffffffff810fe959>] sys_ioctl+0x99/0xa0
[   65.055931]        [<ffffffff8100bd6b>] system_call_fastpath+0x16/0x1b
[   65.056006]        [<ffffffffffffffff>] 0xffffffffffffffff
[   65.056080] 
[   65.056080] -> #2 (&wdev->mtx){+.+.+.}:
[   65.056240]        [<ffffffff8106f994>] __lock_acquire+0x1164/0x1b50
[   65.056314]        [<ffffffff81070453>] lock_acquire+0xd3/0x100
[   65.056386]        [<ffffffff81323e65>] mutex_lock_nested+0x45/0x320
[   65.056459]        [<ffffffffa01c5224>] cfg80211_netdev_notifier_call+0x1a4/0x380 [cfg80211]
[   65.056550]        [<ffffffff81328855>] notifier_call_chain+0x65/0xa0
[   65.056623]        [<ffffffff810605f1>] raw_notifier_call_chain+0x11/0x20
[   65.056697]        [<ffffffff8128bbea>] dev_open+0x10a/0x120
[   65.056769]        [<ffffffff8128af4d>] dev_change_flags+0x9d/0x1e0
[   65.056842]        [<ffffffff81294bb3>] do_setlink+0x2b3/0x450
[   65.056844]        [<ffffffff81294f25>] rtnl_setlink+0x115/0x160
[   65.056844]        [<ffffffff8129605e>] rtnetlink_rcv_msg+0x18e/0x240
[   65.056844]        [<ffffffff812a8379>] netlink_rcv_skb+0x89/0xb0
[   65.056844]        [<ffffffff81295eb9>] rtnetlink_rcv+0x29/0x40
[   65.056844]        [<ffffffff812a7d12>] netlink_unicast+0x2e2/0x2f0
[   65.056844]        [<ffffffff812a7f41>] netlink_sendmsg+0x221/0x330
[   65.056844]        [<ffffffff81277f07>] sock_sendmsg+0x127/0x140
[   65.056844]        [<ffffffff81278065>] sys_sendmsg+0x145/0x280
[   65.056844]        [<ffffffff8100bd6b>] system_call_fastpath+0x16/0x1b
[   65.056844]        [<ffffffffffffffff>] 0xffffffffffffffff
[   65.056844] 
[   65.056844] -> #1 (&rdev->mtx){+.+.+.}:
[   65.056844]        [<ffffffff8106f994>] __lock_acquire+0x1164/0x1b50
[   65.056844]        [<ffffffff81070453>] lock_acquire+0xd3/0x100
[   65.056844]        [<ffffffff81323e65>] mutex_lock_nested+0x45/0x320
[   65.056844]        [<ffffffffa01c6421>] cfg80211_get_dev_from_ifindex+0x61/0xa0 [cfg80211]
[   65.056844]        [<ffffffffa01ca3c0>] cfg80211_wext_giwscan+0x50/0x1210 [cfg80211]
[   65.056844]        [<ffffffff8130ed54>] ioctl_standard_call+0x1f4/0x460
[   65.056844]        [<ffffffff8130e7bb>] wext_handle_ioctl+0x16b/0x240
[   65.056844]        [<ffffffff8128cd02>] dev_ioctl+0x3f2/0x5f0
[   65.056844]        [<ffffffff81277059>] sock_ioctl+0x89/0x290
[   65.056844]        [<ffffffff810fe201>] vfs_ioctl+0x31/0xa0
[   65.056844]        [<ffffffff810fe38a>] do_vfs_ioctl+0x8a/0x5c0
[   65.056844]        [<ffffffff810fe959>] sys_ioctl+0x99/0xa0
[   65.056844]        [<ffffffff8100bd6b>] system_call_fastpath+0x16/0x1b
[   65.056844]        [<ffffffffffffffff>] 0xffffffffffffffff
[   65.056844] 
[   65.056844] -> #0 (cfg80211_mutex){+.+.+.}:
[   65.056844]        [<ffffffff8106fae3>] __lock_acquire+0x12b3/0x1b50
[   65.056844]        [<ffffffff81070453>] lock_acquire+0xd3/0x100
[   65.056844]        [<ffffffff81323e65>] mutex_lock_nested+0x45/0x320
[   65.056844]        [<ffffffffa01c9a72>] regulatory_hint_11d+0x32/0x430 [cfg80211]
[   65.056844]        [<ffffffffa0220a8d>] ieee80211_rx_mgmt_beacon+0x2cd/0x4d0 [mac80211]
[   65.056844]        [<ffffffffa0221049>] ieee80211_sta_work+0x1e9/0x11c0 [mac80211]
[   65.056844]        [<ffffffff81055f80>] worker_thread+0x1f0/0x340
[   65.056844]        [<ffffffff8105b28e>] kthread+0x9e/0xb0
[   65.056844]        [<ffffffff8100ce7a>] child_rip+0xa/0x20
[   65.056844]        [<ffffffffffffffff>] 0xffffffffffffffff
[   65.056844] 
[   65.056844] other info that might help us debug this:
[   65.056844] 
[   65.056844] 3 locks held by phy0/3223:
[   65.056844]  #0:  ((wiphy_name(local->hw.wiphy))){+.+.+.}, at: [<ffffffff81055f2d>] worker_thread+0x19d/0x340
[   65.056844]  #1:  (&ifmgd->work){+.+.+.}, at: [<ffffffff81055f2d>] worker_thread+0x19d/0x340
[   65.056844]  #2:  (&ifmgd->mtx){+.+.+.}, at: [<ffffffffa0220f78>] ieee80211_sta_work+0x118/0x11c0 [mac80211]
[   65.056844] 
[   65.056844] stack backtrace:
[   65.056844] Pid: 3223, comm: phy0 Not tainted 2.6.31-rc3-wl #13
[   65.056844] Call Trace:
[   65.056844]  [<ffffffff8106e28c>] print_circular_bug_tail+0xdc/0xe0
[   65.056844]  [<ffffffff8106fae3>] __lock_acquire+0x12b3/0x1b50
[   65.056844]  [<ffffffff8106d5ed>] ? mark_held_locks+0x6d/0x90
[   65.056844]  [<ffffffff81070453>] lock_acquire+0xd3/0x100
[   65.056844]  [<ffffffffa01c9a72>] ? regulatory_hint_11d+0x32/0x430 [cfg80211]
[   65.056844]  [<ffffffff81323e65>] mutex_lock_nested+0x45/0x320
[   65.056844]  [<ffffffffa01c9a72>] ? regulatory_hint_11d+0x32/0x430 [cfg80211]
[   65.056844]  [<ffffffffa01cc03c>] ? cfg80211_inform_bss_frame+0x19c/0x1a0 [cfg80211]
[   65.056844]  [<ffffffffa01c9a72>] regulatory_hint_11d+0x32/0x430 [cfg80211]
[   65.056844]  [<ffffffffa021a35c>] ? ieee80211_rx_bss_put+0xc/0x10 [mac80211]
[   65.056844]  [<ffffffffa0220753>] ? ieee80211_rx_bss_info+0xb3/0x120 [mac80211]
[   65.056844]  [<ffffffffa0220a8d>] ieee80211_rx_mgmt_beacon+0x2cd/0x4d0 [mac80211]
[   65.056844]  [<ffffffffa0221049>] ieee80211_sta_work+0x1e9/0x11c0 [mac80211]
[   65.056844]  [<ffffffff810adb60>] ? probe_workqueue_execution+0x40/0xa0
[   65.056844]  [<ffffffffa0220e60>] ? ieee80211_sta_work+0x0/0x11c0 [mac80211]
[   65.056844]  [<ffffffff81055f80>] worker_thread+0x1f0/0x340
[   65.056844]  [<ffffffff81055f2d>] ? worker_thread+0x19d/0x340
[   65.056844]  [<ffffffff8105b680>] ? autoremove_wake_function+0x0/0x40
[   65.056844]  [<ffffffff8106d94d>] ? trace_hardirqs_on+0xd/0x10
[   65.056844]  [<ffffffff81055d90>] ? worker_thread+0x0/0x340
[   65.056844]  [<ffffffff8105b28e>] kthread+0x9e/0xb0
[   65.056844]  [<ffffffff8100ce7a>] child_rip+0xa/0x20
[   65.056844]  [<ffffffff8100c83c>] ? restore_args+0x0/0x30
[   65.056844]  [<ffffffff8105b1f0>] ? kthread+0x0/0xb0
[   65.056844]  [<ffffffff8100ce70>] ? child_rip+0x0/0x20



