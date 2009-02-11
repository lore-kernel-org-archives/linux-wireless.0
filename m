Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.185]:29436 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbZBKPMV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 10:12:21 -0500
Received: by rn-out-0910.google.com with SMTP id k40so228198rnd.17
        for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2009 07:12:20 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18834.60020.961395.8177@gargle.gargle.HOWL> (sfid-20090211_161232_736081_93808C02)
Date: Wed, 11 Feb 2009 20:40:44 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: lock inversion with regulatory code
In-Reply-To: <1234282434.4229.9.camel@johannes.local>
References: <1234282434.4229.9.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> I'm getting this lockdep report -- the problem is that zd1211 calls
> regulatory_hint within the rtnl (because it's within ieee80211_open),
> but all cfg80211 locking so far has been the other way around.
> 
> Not sure how to fix it, here are a couple of possibilities:
>  (1) invert all cfg80211 locking, i.e. do rtnl_lock() around everything
>      in each nl80211 handler
>  (2) defer regulatory hints and treat them outside of the context of
>      regulatory_hint() (use schedule_work or so)
>  (3) disallow doing regulatory hints from _open()
> 

Saw this today when I stopped wpa_supplicant.


[  513.426737] =======================================================
[  513.430019] [ INFO: possible circular locking dependency detected ]
[  513.430019] 2.6.29-rc4-wl #7
[  513.430019] -------------------------------------------------------
[  513.430019] wpa_supplicant/3333 is trying to acquire lock:
[  513.430019]  (&ifsta->work){--..}, at: [<ffffffff8025555d>] __cancel_work_timer+0x5d/0x1f0
[  513.430019]
[  513.430019] but task is already holding lock:
[  513.430019]  (rtnl_mutex){--..}, at: [<ffffffff804997a6>] devinet_ioctl+0x136/0x7a0
[  513.430019]
[  513.430019] which lock already depends on the new lock.
[  513.430019]
[  513.430019]
[  513.430019] the existing dependency chain (in reverse order) is:
[  513.488268]
[  513.488268] -> #3 (rtnl_mutex){--..}:
[  513.488268]        [<ffffffff80269967>] add_lock_to_list+0x67/0xf0
[  513.488268]        [<ffffffffa00d6f39>] nl80211_dump_station+0x139/0x1f0 [cfg80211]
[  513.488268]        [<ffffffff8026d790>] __lock_acquire+0x1520/0x1c40
[  513.488268]        [<ffffffffa00d6f39>] nl80211_dump_station+0x139/0x1f0 [cfg80211]
[  513.488268]        [<ffffffff8026df05>] lock_acquire+0x55/0x70
[  513.488268]        [<ffffffffa00d6f39>] nl80211_dump_station+0x139/0x1f0 [cfg80211]
[  513.488268]        [<ffffffff804dbdda>] mutex_lock_nested+0xca/0x370
[  513.488268]        [<ffffffffa00d6f39>] nl80211_dump_station+0x139/0x1f0 [cfg80211]
[  513.488268]        [<ffffffff804db655>] __mutex_unlock_slowpath+0x125/0x1c0
[  513.488268]        [<ffffffff8026b78a>] trace_hardirqs_on_caller+0x15a/0x1a0
[  513.488268]        [<ffffffffa00d6f39>] nl80211_dump_station+0x139/0x1f0 [cfg80211]
[  513.488268]        [<ffffffff804dbfe1>] mutex_lock_nested+0x2d1/0x370
[  513.488268]        [<ffffffff8045f3fd>] netlink_dump+0x4d/0x1f0
[  513.488268]        [<ffffffff8045f417>] netlink_dump+0x67/0x1f0
[  513.488268]        [<ffffffff8046035d>] netlink_dump_start+0x16d/0x190
[  513.488268]        [<ffffffff80462db8>] genl_rcv_msg+0x118/0x1f0
[  513.488268]        [<ffffffff80462c82>] genl_rcv+0x12/0x30
[  513.488268]        [<ffffffff80462ca0>] genl_rcv_msg+0x0/0x1f0
[  513.488268]        [<ffffffff80461dd9>] netlink_rcv_skb+0x79/0xa0
[  513.488268]        [<ffffffff80462c91>] genl_rcv+0x21/0x30
[  513.488268]        [<ffffffff8046176a>] netlink_unicast+0x2ca/0x2e0
[  513.488268]        [<ffffffff8043c252>] __alloc_skb+0x72/0x150
[  513.488268]        [<ffffffff8046198a>] netlink_sendmsg+0x20a/0x320
[  513.488268]        [<ffffffff8043336e>] sock_sendmsg+0x12e/0x150
[  513.488268]        [<ffffffff802599c0>] autoremove_wake_function+0x0/0x30
[  513.488268]        [<ffffffff80431f2e>] move_addr_to_kernel+0x2e/0x40
[  513.488268]        [<ffffffff80433577>] sys_sendmsg+0x1e7/0x370
[  513.488268]        [<ffffffff8022ccf1>] do_page_fault+0x361/0x9a0
[  513.488268]        [<ffffffff802c3c4f>] kmem_cache_free+0xaf/0x130
[  513.488268]        [<ffffffff8026b78a>] trace_hardirqs_on_caller+0x15a/0x1a0
[  513.488268]        [<ffffffff802d8c30>] d_kill+0x60/0x80
[  513.488268]        [<ffffffff802daebb>] dput+0xbb/0x1a0
[  513.488268]        [<ffffffff8026b78a>] trace_hardirqs_on_caller+0x15a/0x1a0
[  513.488268]        [<ffffffff804dd61d>] trace_hardirqs_on_thunk+0x3a/0x3f
[  513.488268]        [<ffffffff8020c5db>] system_call_fastpath+0x16/0x1b
[  513.488268]        [<ffffffffffffffff>] 0xffffffffffffffff
[  513.488268]
[  513.488268] -> #2 (&drv->mtx){--..}:
[  513.488268]        [<ffffffff80269967>] add_lock_to_list+0x67/0xf0
[  513.488268]        [<ffffffffa00d28f0>] cfg80211_get_dev_from_ifindex+0x60/0x90 [cfg80211]
[  513.488268]        [<ffffffff8026d790>] __lock_acquire+0x1520/0x1c40
[  513.488268]        [<ffffffffa00d28f0>] cfg80211_get_dev_from_ifindex+0x60/0x90 [cfg80211]
[  513.488268]        [<ffffffff8026df05>] lock_acquire+0x55/0x70
[  513.488268]        [<ffffffffa00d28f0>] cfg80211_get_dev_from_ifindex+0x60/0x90 [cfg80211]
[  513.488268]        [<ffffffff804dbdda>] mutex_lock_nested+0xca/0x370
[  513.488268]        [<ffffffffa00d28f0>] cfg80211_get_dev_from_ifindex+0x60/0x90 [cfg80211]
[  513.488268]        [<ffffffffa00d28f0>] cfg80211_get_dev_from_ifindex+0x60/0x90 [cfg80211]
[  513.488268]        [<ffffffffa00d4bf8>] get_drv_dev_by_info_ifindex+0x68/0x90 [cfg80211]
[  513.488268]        [<ffffffffa00d86c7>] nl80211_get_interface+0x27/0xf0 [cfg80211]
[  513.488268]        [<ffffffff80462e57>] genl_rcv_msg+0x1b7/0x1f0
[  513.488268]        [<ffffffff80462ca0>] genl_rcv_msg+0x0/0x1f0
[  513.488268]        [<ffffffff80461dd9>] netlink_rcv_skb+0x79/0xa0
[  513.488268]        [<ffffffff80462c91>] genl_rcv+0x21/0x30
[  513.488268]        [<ffffffff8046176a>] netlink_unicast+0x2ca/0x2e0
[  513.488268]        [<ffffffff8043c252>] __alloc_skb+0x72/0x150
[  513.488268]        [<ffffffff8046198a>] netlink_sendmsg+0x20a/0x320
[  513.488268]        [<ffffffff8043336e>] sock_sendmsg+0x12e/0x150
[  513.488268]        [<ffffffff802599c0>] autoremove_wake_function+0x0/0x30
[  513.488268]        [<ffffffff80431f2e>] move_addr_to_kernel+0x2e/0x40
[  513.488268]        [<ffffffff80433577>] sys_sendmsg+0x1e7/0x370
[  513.488268]        [<ffffffff8022ccf1>] do_page_fault+0x361/0x9a0
[  513.488268]        [<ffffffff802c3c4f>] kmem_cache_free+0xaf/0x130
[  513.488268]        [<ffffffff8026b78a>] trace_hardirqs_on_caller+0x15a/0x1a0
[  513.488268]        [<ffffffff802d8c30>] d_kill+0x60/0x80
[  513.488268]        [<ffffffff802daebb>] dput+0xbb/0x1a0
[  513.488268]        [<ffffffff8026b78a>] trace_hardirqs_on_caller+0x15a/0x1a0
[  513.488268]        [<ffffffff804dd61d>] trace_hardirqs_on_thunk+0x3a/0x3f
[  513.488268]        [<ffffffff8020c5db>] system_call_fastpath+0x16/0x1b
[  513.488268]        [<ffffffffffffffff>] 0xffffffffffffffff
[  513.488268]
[  513.488268] -> #1 (cfg80211_drv_mutex){--..}:
[  513.488268]        [<ffffffff80269967>] add_lock_to_list+0x67/0xf0
[  513.488268]        [<ffffffffa00d4494>] regulatory_hint_11d+0x44/0x370 [cfg80211]
[  513.488268]        [<ffffffff8026d790>] __lock_acquire+0x1520/0x1c40
[  513.488268]        [<ffffffff8026c3fc>] __lock_acquire+0x18c/0x1c40
[  513.488268]        [<ffffffff8026b52d>] mark_held_locks+0x4d/0x90
[  513.488268]        [<ffffffff8024751c>] local_bh_enable_ip+0x9c/0x130
[  513.488268]        [<ffffffffa00d4494>] regulatory_hint_11d+0x44/0x370 [cfg80211]
[  513.488268]        [<ffffffff8026df05>] lock_acquire+0x55/0x70
[  513.488268]        [<ffffffffa00d4494>] regulatory_hint_11d+0x44/0x370 [cfg80211]
[  513.488268]        [<ffffffff804dbdda>] mutex_lock_nested+0xca/0x370
[  513.488268]        [<ffffffffa00d4494>] regulatory_hint_11d+0x44/0x370 [cfg80211]
[  513.488268]        [<ffffffff8026c3fc>] __lock_acquire+0x18c/0x1c40
[  513.488268]        [<ffffffffa00d4494>] regulatory_hint_11d+0x44/0x370 [cfg80211]
[  513.488268]        [<ffffffffa00eda9b>] ieee80211_rx_mgmt_beacon+0x33b/0x400 [mac80211]
[  513.488268]        [<ffffffffa00ed9b3>] ieee80211_rx_mgmt_beacon+0x253/0x400 [mac80211]
[  513.488268]        [<ffffffff8043a6b1>] skb_dequeue+0x21/0x80
[  513.488268]        [<ffffffffa00ee980>] ieee80211_sta_work+0x180/0xe60 [mac80211]
[  513.488268]        [<ffffffff804ddb94>] _spin_unlock_irq+0x24/0x50
[  513.488268]        [<ffffffffa00ee800>] ieee80211_sta_work+0x0/0xe60 [mac80211]
[  513.488268]        [<ffffffffa00ee800>] ieee80211_sta_work+0x0/0xe60 [mac80211]
[  513.488268]        [<ffffffff80254dbb>] run_workqueue+0xfb/0x250
[  513.488268]        [<ffffffff80254d69>] run_workqueue+0xa9/0x250
[  513.488268]        [<ffffffff8026b78a>] trace_hardirqs_on_caller+0x15a/0x1a0
[  513.488268]        [<ffffffff80254fb7>] worker_thread+0xa7/0x110
[  513.488268]        [<ffffffff802599c0>] autoremove_wake_function+0x0/0x30
[  513.488268]        [<ffffffff80254f10>] worker_thread+0x0/0x110
[  513.488268]        [<ffffffff80254f10>] worker_thread+0x0/0x110
[  513.488268]        [<ffffffff80259507>] kthread+0x47/0x90
[  513.488268]        [<ffffffff804dd61d>] trace_hardirqs_on_thunk+0x3a/0x3f
[  513.488268]        [<ffffffff8020d67a>] child_rip+0xa/0x20
[  513.488268]        [<ffffffff8020d040>] restore_args+0x0/0x30
[  513.488268]        [<ffffffff802594c0>] kthread+0x0/0x90
[  513.488268]        [<ffffffff8020d670>] child_rip+0x0/0x20
[  513.488268]        [<ffffffffffffffff>] 0xffffffffffffffff
[  513.488268]
[  513.488268] -> #0 (&ifsta->work){--..}:
[  513.488268]        [<ffffffff8026d93d>] __lock_acquire+0x16cd/0x1c40
[  513.488268]        [<ffffffff8026df05>] lock_acquire+0x55/0x70
[  513.488268]        [<ffffffff8025555d>] __cancel_work_timer+0x5d/0x1f0
[  513.488268]        [<ffffffff8025558f>] __cancel_work_timer+0x8f/0x1f0
[  513.488268]        [<ffffffff8025555d>] __cancel_work_timer+0x5d/0x1f0
[  513.488268]        [<ffffffff8026b52d>] mark_held_locks+0x4d/0x90
[  513.488268]        [<ffffffff804ddc25>] _spin_unlock_irqrestore+0x65/0x80
[  513.488268]        [<ffffffff8026b78a>] trace_hardirqs_on_caller+0x15a/0x1a0
[  513.488268]        [<ffffffff8024cd74>] try_to_del_timer_sync+0x54/0x60
[  513.488268]        [<ffffffffa00effa2>] ieee80211_stop+0x212/0x600 [mac80211]
[  513.488268]        [<ffffffffa00efe02>] ieee80211_stop+0x72/0x600 [mac80211]
[  513.488268]        [<ffffffff8024751c>] local_bh_enable_ip+0x9c/0x130
[  513.488268]        [<ffffffff8045813b>] dev_deactivate+0x1ab/0x1d0
[  513.488268]        [<ffffffff80445313>] dev_close+0x83/0xd0
[  513.488268]        [<ffffffff80444edb>] dev_change_flags+0x9b/0x1e0
[  513.488268]        [<ffffffff80499dfe>] devinet_ioctl+0x78e/0x7a0
[  513.488268]        [<ffffffff804321da>] sock_ioctl+0x6a/0x290
[  513.488268]        [<ffffffff802d58ff>] vfs_ioctl+0x2f/0xb0
[  513.488268]        [<ffffffff802d5a18>] do_vfs_ioctl+0x98/0x5c0
[  513.488268]        [<ffffffff8020c60c>] sysret_check+0x27/0x62
[  513.488268]        [<ffffffff802d5fe1>] sys_ioctl+0xa1/0xb0
[  513.488268]        [<ffffffff8020c5db>] system_call_fastpath+0x16/0x1b
[  513.488268]        [<ffffffffffffffff>] 0xffffffffffffffff
[  513.488268]
[  513.488268] other info that might help us debug this:
[  513.488268]
[  513.488268] 1 lock held by wpa_supplicant/3333:
[  513.488268]  #0:  (rtnl_mutex){--..}, at: [<ffffffff804997a6>] devinet_ioctl+0x136/0x7a0
[  513.488268]
[  513.488268] stack backtrace:
[  513.488268] Pid: 3333, comm: wpa_supplicant Not tainted 2.6.29-rc4-wl #7
[  513.488268] Call Trace:
[  513.488268]  [<ffffffff8026bda0>] print_circular_bug_tail+0xf0/0x100
[  513.488268]  [<ffffffff8026d93d>] __lock_acquire+0x16cd/0x1c40
[  513.488268]  [<ffffffff8026df05>] lock_acquire+0x55/0x70
[  513.488268]  [<ffffffff8025555d>] __cancel_work_timer+0x5d/0x1f0
[  513.488268]  [<ffffffff8025558f>] __cancel_work_timer+0x8f/0x1f0
[  513.488268]  [<ffffffff8025555d>] __cancel_work_timer+0x5d/0x1f0
[  513.488268]  [<ffffffff8026b52d>] mark_held_locks+0x4d/0x90
[  513.488268]  [<ffffffff804ddc25>] _spin_unlock_irqrestore+0x65/0x80
[  513.488268]  [<ffffffff8026b78a>] trace_hardirqs_on_caller+0x15a/0x1a0
[  513.488268]  [<ffffffff8024cd74>] try_to_del_timer_sync+0x54/0x60
[  513.488268]  [<ffffffffa00effa2>] ieee80211_stop+0x212/0x600 [mac80211]
[  513.488268]  [<ffffffffa00efe02>] ieee80211_stop+0x72/0x600 [mac80211]
[  513.488268]  [<ffffffff8024751c>] local_bh_enable_ip+0x9c/0x130
[  513.488268]  [<ffffffff8045813b>] dev_deactivate+0x1ab/0x1d0
[  513.488268]  [<ffffffff80445313>] dev_close+0x83/0xd0
[  513.488268]  [<ffffffff80444edb>] dev_change_flags+0x9b/0x1e0
[  513.488268]  [<ffffffff80499dfe>] devinet_ioctl+0x78e/0x7a0
[  513.488268]  [<ffffffff804321da>] sock_ioctl+0x6a/0x290
[  513.488268]  [<ffffffff802d58ff>] vfs_ioctl+0x2f/0xb0
[  513.488268]  [<ffffffff802d5a18>] do_vfs_ioctl+0x98/0x5c0
[  513.488268]  [<ffffffff8020c60c>] sysret_check+0x27/0x62
[  513.488268]  [<ffffffff802d5fe1>] sys_ioctl+0xa1/0xb0
[  513.488268]  [<ffffffff8020c5db>] system_call_fastpath+0x16/0x1b
