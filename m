Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58789 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934176Ab1JELDf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 07:03:35 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1RBPG9-0006Fy-Pe
	for linux-wireless@vger.kernel.org; Wed, 05 Oct 2011 13:03:34 +0200
Subject: b43 lockdep splat
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Oct 2011 13:03:32 +0200
Message-ID: <1317812612.4839.4.camel@jlt3.sipsolutions.net> (sfid-20111005_130339_064173_61B07A27)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[16922.681811] =======================================================
[16922.681817] [ INFO: possible circular locking dependency detected ]
[16922.681821] 3.1.0-rc7-wl-65981-g1564861-dirty #244
[16922.681824] -------------------------------------------------------
[16922.681828] NetworkManager/11520 is trying to acquire lock:
[16922.681832]  (rtnl_mutex){+.+.+.}, at: [<ffffffff813ddb17>] rtnl_lock+0x17/0x20
[16922.681845] 
[16922.681846] but task is already holding lock:
[16922.681849]  (rfkill_global_mutex){+.+.+.}, at: [<ffffffffa02a406d>] rfkill_fop_write+0x7d/0x170 [rfkill]
[16922.681862] 
[16922.681863] which lock already depends on the new lock.
[16922.681864] 
[16922.681867] 
[16922.681868] the existing dependency chain (in reverse order) is:
[16922.681871] 
[16922.681872] -> #4 (rfkill_global_mutex){+.+.+.}:
[16922.681880]        [<ffffffff810897f8>] check_prevs_add+0xf8/0x180
[16922.681888]        [<ffffffff81089d24>] validate_chain.isra.33+0x4a4/0x5d0
[16922.681895]        [<ffffffff8108cb9c>] __lock_acquire+0x40c/0xa50
[16922.681901]        [<ffffffff8108d94e>] lock_acquire+0x9e/0x1f0
[16922.681907]        [<ffffffff814c56b3>] mutex_lock_nested+0x73/0x3b0
[16922.681913]        [<ffffffffa02a36d5>] rfkill_fop_open+0x95/0x220 [rfkill]
[16922.681921]        [<ffffffff81332f09>] misc_open+0x1e9/0x630
[16922.681928]        [<ffffffff81129c37>] chrdev_open+0x127/0x330
[16922.681935]        [<ffffffff81122ed1>] __dentry_open.isra.14+0x151/0x470
[16922.681942]        [<ffffffff81124051>] nameidata_to_filp+0x61/0x70
[16922.681948]        [<ffffffff811350bb>] do_last.isra.46+0x32b/0x650
[16922.681954]        [<ffffffff8113560e>] path_openat+0xce/0x3a0
[16922.681959]        [<ffffffff81135942>] do_filp_open+0x42/0xa0
[16922.681965]        [<ffffffff81124157>] do_sys_open+0xf7/0x1d0
[16922.681970]        [<ffffffff81124250>] sys_open+0x20/0x30
[16922.681976]        [<ffffffff814cf30b>] system_call_fastpath+0x16/0x1b
[16922.681983] 
[16922.681984] -> #3 (misc_mtx){+.+.+.}:
[16922.681990]        [<ffffffff810897f8>] check_prevs_add+0xf8/0x180
[16922.681996]        [<ffffffff81089d24>] validate_chain.isra.33+0x4a4/0x5d0
[16922.682003]        [<ffffffff8108cb9c>] __lock_acquire+0x40c/0xa50
[16922.682008]        [<ffffffff8108d94e>] lock_acquire+0x9e/0x1f0
[16922.682014]        [<ffffffff814c56b3>] mutex_lock_nested+0x73/0x3b0
[16922.682020]        [<ffffffff8133360b>] misc_register+0x2b/0x90
[16922.682026]        [<ffffffff81335201>] hwrng_register+0x101/0x190
[16922.682031]        [<ffffffffa04b2318>] b43_wireless_core_init+0x468/0x5e0 [b43]
[16922.682045]        [<ffffffffa04b2aa8>] b43_op_start+0x1d8/0x1f0 [b43]
[16922.682056]        [<ffffffffa041d68d>] ieee80211_do_open+0x27d/0x1160 [mac80211]
[16922.682082]        [<ffffffffa041e5dd>] ieee80211_open+0x6d/0x80 [mac80211]
[16922.682102]        [<ffffffff813d037f>] __dev_open+0x8f/0xe0
[16922.682108]        [<ffffffff813d0621>] __dev_change_flags+0xa1/0x180
[16922.682114]        [<ffffffff813d07b8>] dev_change_flags+0x28/0x70
[16922.682119]        [<ffffffff813dded7>] do_setlink+0x267/0x7d0
[16922.682125]        [<ffffffff813de509>] rtnl_setlink+0xc9/0x120
[16922.682130]        [<ffffffff813de6a4>] rtnetlink_rcv_msg+0x124/0x2e0
[16922.682135]        [<ffffffff813f74f9>] netlink_rcv_skb+0xa9/0xd0
[16922.682142]        [<ffffffff813ddb45>] rtnetlink_rcv+0x25/0x40
[16922.682148]        [<ffffffff813f6dde>] netlink_unicast+0x1ee/0x240
[16922.682153]        [<ffffffff813f71ba>] netlink_sendmsg+0x2ca/0x360
[16922.682159]        [<ffffffff813b3b4e>] sock_sendmsg+0xde/0x120
[16922.682166]        [<ffffffff813b4035>] __sys_sendmsg+0x3b5/0x3d0
[16922.682171]        [<ffffffff813b65e9>] sys_sendmsg+0x49/0x90
[16922.682177]        [<ffffffff814cf30b>] system_call_fastpath+0x16/0x1b
[16922.682183] 
[16922.682184] -> #2 (rng_mutex){+.+.+.}:
[16922.682191]        [<ffffffff810897f8>] check_prevs_add+0xf8/0x180
[16922.682197]        [<ffffffff81089d24>] validate_chain.isra.33+0x4a4/0x5d0
[16922.682203]        [<ffffffff8108cb9c>] __lock_acquire+0x40c/0xa50
[16922.682209]        [<ffffffff8108d94e>] lock_acquire+0x9e/0x1f0
[16922.682215]        [<ffffffff814c56b3>] mutex_lock_nested+0x73/0x3b0
[16922.682220]        [<ffffffff81335138>] hwrng_register+0x38/0x190
[16922.682226]        [<ffffffffa04b2318>] b43_wireless_core_init+0x468/0x5e0 [b43]
[16922.682237]        [<ffffffffa04b2aa8>] b43_op_start+0x1d8/0x1f0 [b43]
[16922.682248]        [<ffffffffa041d68d>] ieee80211_do_open+0x27d/0x1160 [mac80211]
[16922.682268]        [<ffffffffa041e5dd>] ieee80211_open+0x6d/0x80 [mac80211]
[16922.682287]        [<ffffffff813d037f>] __dev_open+0x8f/0xe0
[16922.682293]        [<ffffffff813d0621>] __dev_change_flags+0xa1/0x180
[16922.682298]        [<ffffffff813d07b8>] dev_change_flags+0x28/0x70
[16922.682304]        [<ffffffff813dded7>] do_setlink+0x267/0x7d0
[16922.682309]        [<ffffffff813de509>] rtnl_setlink+0xc9/0x120
[16922.682315]        [<ffffffff813de6a4>] rtnetlink_rcv_msg+0x124/0x2e0
[16922.682320]        [<ffffffff813f74f9>] netlink_rcv_skb+0xa9/0xd0
[16922.682326]        [<ffffffff813ddb45>] rtnetlink_rcv+0x25/0x40
[16922.682331]        [<ffffffff813f6dde>] netlink_unicast+0x1ee/0x240
[16922.682337]        [<ffffffff813f71ba>] netlink_sendmsg+0x2ca/0x360
[16922.682343]        [<ffffffff813b3b4e>] sock_sendmsg+0xde/0x120
[16922.682349]        [<ffffffff813b4035>] __sys_sendmsg+0x3b5/0x3d0
[16922.682354]        [<ffffffff813b65e9>] sys_sendmsg+0x49/0x90
[16922.682360]        [<ffffffff814cf30b>] system_call_fastpath+0x16/0x1b
[16922.682366] 
[16922.682367] -> #1 (&wl->mutex){+.+.+.}:
[16922.682373]        [<ffffffff810897f8>] check_prevs_add+0xf8/0x180
[16922.682380]        [<ffffffff81089d24>] validate_chain.isra.33+0x4a4/0x5d0
[16922.682386]        [<ffffffff8108cb9c>] __lock_acquire+0x40c/0xa50
[16922.682392]        [<ffffffff8108d94e>] lock_acquire+0x9e/0x1f0
[16922.682398]        [<ffffffff814c56b3>] mutex_lock_nested+0x73/0x3b0
[16922.682403]        [<ffffffffa04b29ae>] b43_op_start+0xde/0x1f0 [b43]
[16922.682414]        [<ffffffffa041d68d>] ieee80211_do_open+0x27d/0x1160 [mac80211]
[16922.682434]        [<ffffffffa041e5dd>] ieee80211_open+0x6d/0x80 [mac80211]
[16922.682453]        [<ffffffff813d037f>] __dev_open+0x8f/0xe0
[16922.682459]        [<ffffffff813d0621>] __dev_change_flags+0xa1/0x180
[16922.682464]        [<ffffffff813d07b8>] dev_change_flags+0x28/0x70
[16922.682470]        [<ffffffff813dded7>] do_setlink+0x267/0x7d0
[16922.682475]        [<ffffffff813de509>] rtnl_setlink+0xc9/0x120
[16922.682480]        [<ffffffff813de6a4>] rtnetlink_rcv_msg+0x124/0x2e0
[16922.682486]        [<ffffffff813f74f9>] netlink_rcv_skb+0xa9/0xd0
[16922.682492]        [<ffffffff813ddb45>] rtnetlink_rcv+0x25/0x40
[16922.682497]        [<ffffffff813f6dde>] netlink_unicast+0x1ee/0x240
[16922.682503]        [<ffffffff813f71ba>] netlink_sendmsg+0x2ca/0x360
[16922.682509]        [<ffffffff813b3b4e>] sock_sendmsg+0xde/0x120
[16922.682515]        [<ffffffff813b4035>] __sys_sendmsg+0x3b5/0x3d0
[16922.682520]        [<ffffffff813b65e9>] sys_sendmsg+0x49/0x90
[16922.682526]        [<ffffffff814cf30b>] system_call_fastpath+0x16/0x1b
[16922.682532] 
[16922.682533] -> #0 (rtnl_mutex){+.+.+.}:
[16922.682539]        [<ffffffff810896e9>] check_prev_add+0x759/0x770
[16922.682545]        [<ffffffff810897f8>] check_prevs_add+0xf8/0x180
[16922.682551]        [<ffffffff81089d24>] validate_chain.isra.33+0x4a4/0x5d0
[16922.682557]        [<ffffffff8108cb9c>] __lock_acquire+0x40c/0xa50
[16922.682563]        [<ffffffff8108d94e>] lock_acquire+0x9e/0x1f0
[16922.682569]        [<ffffffff814c56b3>] mutex_lock_nested+0x73/0x3b0
[16922.682574]        [<ffffffff813ddb17>] rtnl_lock+0x17/0x20
[16922.682580]        [<ffffffffa02ae6fd>] cfg80211_rfkill_set_block+0x3d/0xa0 [cfg80211]
[16922.682592]        [<ffffffffa02a3e17>] rfkill_set_block+0x87/0x120 [rfkill]
[16922.682600]        [<ffffffffa02a40db>] rfkill_fop_write+0xeb/0x170 [rfkill]
[16922.682607]        [<ffffffff81124d92>] vfs_write+0xb2/0x180
[16922.682613]        [<ffffffff811250bd>] sys_write+0x4d/0x90
[16922.682618]        [<ffffffff814cf30b>] system_call_fastpath+0x16/0x1b
[16922.682624] 
[16922.682625] other info that might help us debug this:
[16922.682626] 
[16922.682629] Chain exists of:
[16922.682630]   rtnl_mutex --> misc_mtx --> rfkill_global_mutex
[16922.682640] 
[16922.682642]  Possible unsafe locking scenario:
[16922.682644] 
[16922.682646]        CPU0                    CPU1
[16922.682649]        ----                    ----
[16922.682652]   lock(rfkill_global_mutex);
[16922.682657]                                lock(misc_mtx);
[16922.682662]                                lock(rfkill_global_mutex);
[16922.682667]   lock(rtnl_mutex);
[16922.682672] 
[16922.682673]  *** DEADLOCK ***
[16922.682674] 
[16922.682678] 1 lock held by NetworkManager/11520:
[16922.682681]  #0:  (rfkill_global_mutex){+.+.+.}, at: [<ffffffffa02a406d>] rfkill_fop_write+0x7d/0x170 [rfkill]
[16922.682693] 
[16922.682694] stack backtrace:
[16922.682698] Pid: 11520, comm: NetworkManager Not tainted 3.1.0-rc7-wl-65981-g1564861-dirty #244
[16922.682702] Call Trace:
[16922.682709]  [<ffffffff814b6d7f>] print_circular_bug+0xd9/0xea
[16922.682716]  [<ffffffff810896e9>] check_prev_add+0x759/0x770
[16922.682723]  [<ffffffff81079ed8>] ? sched_clock_cpu+0xa8/0x120
[16922.682729]  [<ffffffff810897f8>] check_prevs_add+0xf8/0x180
[16922.682735]  [<ffffffff81089d24>] validate_chain.isra.33+0x4a4/0x5d0
[16922.682742]  [<ffffffff8108cb9c>] __lock_acquire+0x40c/0xa50
[16922.682748]  [<ffffffff81079d45>] ? sched_clock_local+0x25/0x90
[16922.682755]  [<ffffffff81009056>] ? native_sched_clock+0x26/0x70
[16922.682761]  [<ffffffff8108d94e>] lock_acquire+0x9e/0x1f0
[16922.682766]  [<ffffffff813ddb17>] ? rtnl_lock+0x17/0x20
[16922.682772]  [<ffffffff814cad8e>] ? sub_preempt_count.part.150+0xe/0xa0
[16922.682779]  [<ffffffff814c56b3>] mutex_lock_nested+0x73/0x3b0
[16922.682784]  [<ffffffff813ddb17>] ? rtnl_lock+0x17/0x20
[16922.682789]  [<ffffffff8108a775>] ? mark_held_locks+0x65/0x160
[16922.682797]  [<ffffffffa02a3e08>] ? rfkill_set_block+0x78/0x120 [rfkill]
[16922.682802]  [<ffffffff813ddb17>] ? rtnl_lock+0x17/0x20
[16922.682808]  [<ffffffff814c7765>] ? _raw_spin_unlock_irqrestore+0x65/0x80
[16922.682814]  [<ffffffff813ddb17>] rtnl_lock+0x17/0x20
[16922.682823]  [<ffffffffa02ae6fd>] cfg80211_rfkill_set_block+0x3d/0xa0 [cfg80211]
[16922.682832]  [<ffffffffa02a3e17>] rfkill_set_block+0x87/0x120 [rfkill]
[16922.682840]  [<ffffffffa02a40db>] rfkill_fop_write+0xeb/0x170 [rfkill]
[16922.682846]  [<ffffffff81124d92>] vfs_write+0xb2/0x180
[16922.682851]  [<ffffffff811250bd>] sys_write+0x4d/0x90
[16922.682856]  [<ffffffff814cf30b>] system_call_fastpath+0x16/0x1b


