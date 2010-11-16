Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:59504 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758051Ab0KPOTn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 09:19:43 -0500
Message-ID: <4CE292F7.4090200@kernel.org>
Date: Tue, 16 Nov 2010 15:19:35 +0100
From: Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  Fix deadlock in ieee80211_do_stop.
References: <1289592426-5367-1-git-send-email-greearb@candelatech.com>	 <1289594998.3736.11.camel@jlt3.sipsolutions.net>	 <4CDDAA3B.9090007@candelatech.com> <1289596096.3736.13.camel@jlt3.sipsolutions.net> <4CDE699B.70401@kernel.org> <4CE1A344.7040201@candelatech.com>
In-Reply-To: <4CE1A344.7040201@candelatech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On 11/15/2010 10:16 PM, Ben Greear wrote:
> Here's the full trace of sysrq-t output:

Hmmm... for some reason, the dump is not complete.  Only two kworkers
are printed out.

> Nov 15 13:12:10 localhost kernel: kworker/0:3   D 7845a0d5     0  5972      2 0x00000080
> Nov 15 13:12:10 localhost kernel: e47d5ebc 00000046 00000001 7845a0d5 17e5144b 00000019 78a02380 e54bc910
> Nov 15 13:12:10 localhost kernel: 78a02380 e54bcb8c e54bcb88 e54bcb88 78a02380 78a02380 00000714 00000000
> Nov 15 13:12:10 localhost kernel: 00000000 00000019 e54bc910 789826b4 789826b4 e54bc910 789826b8 e47d5f08
> Nov 15 13:12:10 localhost kernel: Call Trace:
> Nov 15 13:12:10 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
> Nov 15 13:12:10 localhost kernel: [<7878d133>] __mutex_lock_common+0x1de/0x2eb
> Nov 15 13:12:10 localhost kernel: [<786ffe97>] ? rtnl_lock+0xf/0x11
> Nov 15 13:12:10 localhost kernel: [<7878d2ec>] mutex_lock_nested+0x36/0x3b
> Nov 15 13:12:10 localhost kernel: [<786ffe97>] ? rtnl_lock+0xf/0x11
> Nov 15 13:12:10 localhost kernel: [<786ffe97>] rtnl_lock+0xf/0x11
> Nov 15 13:12:10 localhost kernel: [<787014c8>] linkwatch_event+0x8/0x22
> Nov 15 13:12:10 localhost kernel: [<78446ee0>] process_one_work+0x1af/0x2bf
> Nov 15 13:12:10 localhost kernel: [<78446e6f>] ? process_one_work+0x13e/0x2bf
> Nov 15 13:12:10 localhost kernel: [<787014c0>] ? linkwatch_event+0x0/0x22
> Nov 15 13:12:10 localhost kernel: [<7844862e>] worker_thread+0xf9/0x1bf
> Nov 15 13:12:10 localhost kernel: [<78448535>] ? worker_thread+0x0/0x1bf
> Nov 15 13:12:10 localhost kernel: [<7844b15e>] kthread+0x62/0x67
> Nov 15 13:12:10 localhost kernel: [<7844b0fc>] ? kthread+0x0/0x67
> Nov 15 13:12:10 localhost kernel: [<784036c6>] kernel_thread_helper+0x6/0x1a
...
> Nov 15 13:12:11 localhost kernel: ip            D 00428314     0  6369   6314 0x00000080
> Nov 15 13:12:11 localhost kernel: e3acf9d0 00000046 e46d3403 00428314 17a061ee 00000019 78a02380 e46d3430
> Nov 15 13:12:11 localhost kernel: 78a02380 e46d36ac e46d36a8 e46d36a8 78a02380 78a02380 00173949 00000000
> Nov 15 13:12:11 localhost kernel: 00000000 00000019 e46d3430 e3acfa94 e3acfa80 7fffffff e46d3430 e3acfa14
> Nov 15 13:12:11 localhost kernel: Call Trace:
> Nov 15 13:12:11 localhost kernel: [<7878ca33>] schedule_timeout+0x16/0x9f
> Nov 15 13:12:11 localhost kernel: [<7845a2e9>] ? mark_held_locks+0x47/0x5f
> Nov 15 13:12:11 localhost kernel: [<7878e236>] ? _raw_spin_unlock_irq+0x22/0x2b
> Nov 15 13:12:11 localhost kernel: [<7845a545>] ? trace_hardirqs_on_caller+0x104/0x125
> Nov 15 13:12:11 localhost kernel: [<7845a571>] ? trace_hardirqs_on+0xb/0xd
> Nov 15 13:12:11 localhost kernel: [<7878c908>] wait_for_common+0xbb/0x101
> Nov 15 13:12:11 localhost kernel: [<784320db>] ? default_wake_function+0x0/0xd
> Nov 15 13:12:11 localhost kernel: [<7878c9d1>] wait_for_completion+0x12/0x14
> Nov 15 13:12:11 localhost kernel: [<78447bed>] flush_work+0x23/0x27
> Nov 15 13:12:11 localhost kernel: [<78446adf>] ? wq_barrier_func+0x0/0xd
> Nov 15 13:12:11 localhost kernel: [<f8b9d1d1>] ieee80211_do_stop+0x252/0x3b7 [mac80211]
> Nov 15 13:12:11 localhost kernel: [<7843c200>] ? local_bh_enable_ip+0x8/0xa
> Nov 15 13:12:11 localhost kernel: [<7878e211>] ? _raw_spin_unlock_bh+0x25/0x28
> Nov 15 13:12:11 localhost kernel: [<78707001>] ? dev_deactivate+0x0/0xd1
> Nov 15 13:12:11 localhost kernel: [<f8b9d348>] ieee80211_stop+0x12/0x16 [mac80211]
> Nov 15 13:12:11 localhost kernel: [<786f5e55>] __dev_close+0x73/0x88
> Nov 15 13:12:11 localhost kernel: [<786f39b8>] ? dev_set_rx_mode+0x22/0x26
> Nov 15 13:12:11 localhost kernel: [<786f3b5a>] __dev_change_flags+0xa5/0x11a
> Nov 15 13:12:11 localhost kernel: [<786f5d00>] dev_change_flags+0x13/0x3f
> Nov 15 13:12:11 localhost kernel: [<787004dd>] do_setlink+0x23a/0x525
> Nov 15 13:12:11 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
> Nov 15 13:12:11 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
> Nov 15 13:12:11 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
> Nov 15 13:12:11 localhost kernel: [<78700b0b>] rtnl_newlink+0x283/0x45c
> Nov 15 13:12:11 localhost kernel: [<78700906>] ? rtnl_newlink+0x7e/0x45c
> Nov 15 13:12:11 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
> Nov 15 13:12:11 localhost kernel: [<784b5200>] ? on_freelist+0x151/0x17a
> Nov 15 13:12:11 localhost kernel: [<7845a2e9>] ? mark_held_locks+0x47/0x5f
> Nov 15 13:12:11 localhost kernel: [<7878d225>] ? __mutex_lock_common+0x2d0/0x2eb
> Nov 15 13:12:11 localhost kernel: [<7845a545>] ? trace_hardirqs_on_caller+0x104/0x125
> Nov 15 13:12:11 localhost kernel: [<786ffe97>] ? rtnl_lock+0xf/0x11
> Nov 15 13:12:11 localhost kernel: [<78700888>] ? rtnl_newlink+0x0/0x45c
> Nov 15 13:12:11 localhost kernel: [<78700043>] rtnetlink_rcv_msg+0x188/0x19e
> Nov 15 13:12:11 localhost kernel: [<786ffebb>] ? rtnetlink_rcv_msg+0x0/0x19e
> Nov 15 13:12:11 localhost kernel: [<7870e2d8>] netlink_rcv_skb+0x30/0x77
> Nov 15 13:12:11 localhost kernel: [<786ffeb4>] rtnetlink_rcv+0x1b/0x22
> Nov 15 13:12:11 localhost kernel: [<7870e0f7>] netlink_unicast+0xbe/0x11a
> Nov 15 13:12:11 localhost kernel: [<786ee5ec>] ? copy_from_user+0x8/0xa
> Nov 15 13:12:11 localhost kernel: [<7870ecc8>] netlink_sendmsg+0x23e/0x255
> Nov 15 13:12:11 localhost kernel: [<786e8b28>] ? rcu_read_lock+0x0/0x35
> Nov 15 13:12:11 localhost kernel: [<786e5fe4>] __sock_sendmsg+0x54/0x5b
> Nov 15 13:12:11 localhost kernel: [<786e64ae>] sock_sendmsg+0x95/0xac
> Nov 15 13:12:11 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
> Nov 15 13:12:11 localhost kernel: [<784a0104>] ? might_fault+0x90/0x96
> Nov 15 13:12:11 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
> Nov 15 13:12:11 localhost kernel: [<785976a8>] ? _copy_from_user+0x31/0x115
> Nov 15 13:12:11 localhost kernel: [<786ee5ec>] ? copy_from_user+0x8/0xa
> Nov 15 13:12:11 localhost kernel: [<786ee937>] ? verify_iovec+0x3e/0x77
> Nov 15 13:12:11 localhost kernel: [<786e68d7>] sys_sendmsg+0x14d/0x19a
> Nov 15 13:12:11 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
> Nov 15 13:12:11 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
> Nov 15 13:12:11 localhost kernel: [<784c130d>] ? fcheck_files+0x9b/0xca
> Nov 15 13:12:11 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
> Nov 15 13:12:11 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
> Nov 15 13:12:11 localhost kernel: [<784a0104>] ? might_fault+0x90/0x96
> Nov 15 13:12:11 localhost kernel: [<786e7c56>] sys_socketcall+0x227/0x289
> Nov 15 13:12:11 localhost kernel: [<78403111>] ? sysenter_exit+0xf/0x1a
> Nov 15 13:12:11 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
...
> Nov 15 13:12:13 localhost kernel: kworker/0:4   S e468df5c     0  6385      2 0x00000080
> Nov 15 13:12:13 localhost kernel: e468df78 00000046 f438b260 e468df5c 03741e31 0000001c 78a02380 f4ab1f50
> Nov 15 13:12:13 localhost kernel: 78a02380 f4ab21cc f4ab21c8 f4ab21c8 78a02380 78a02380 005bd19b 00000000
> Nov 15 13:12:13 localhost kernel: e38c2780 0000001c f4ab1f50 7845a571 e4606b40 e4606b50 f6003180 e468df9c
> Nov 15 13:12:13 localhost kernel: Call Trace:
> Nov 15 13:12:13 localhost kernel: [<7845a571>] ? trace_hardirqs_on+0xb/0xd
> Nov 15 13:12:13 localhost kernel: [<784486ef>] worker_thread+0x1ba/0x1bf
> Nov 15 13:12:13 localhost kernel: [<78448535>] ? worker_thread+0x0/0x1bf
> Nov 15 13:12:13 localhost kernel: [<7844b15e>] kthread+0x62/0x67
> Nov 15 13:12:13 localhost kernel: [<7844b0fc>] ? kthread+0x0/0x67
> Nov 15 13:12:13 localhost kernel: [<784036c6>] kernel_thread_helper+0x6/0x1a
...
> Nov 15 13:12:13 localhost kernel: runnable tasks:
> Nov 15 13:12:13 localhost kernel:            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
> Nov 15 13:12:13 localhost kernel: ----------------------------------------------------------------------------------------------------------
> Nov 15 13:12:13 localhost kernel:     kworker/u:5    41     14057.509652       913   120     14057.509652       608.324338     91123.303537 /
...
> Nov 15 13:12:13 localhost kernel: Showing all locks held in the system:
> Nov 15 13:12:13 localhost kernel: 3 locks held by kworker/0:1/19:
> Nov 15 13:12:13 localhost kernel: #0:  (events){+.+.+.}, at: [<78446e6f>] process_one_work+0x13e/0x2bf
> Nov 15 13:12:13 localhost kernel: #1:  (wireless_nlevent_work){+.+.+.}, at: [<78446e6f>] process_one_work+0x13e/0x2bf
> Nov 15 13:12:13 localhost kernel: #2:  (rtnl_mutex){+.+.+.}, at: [<786ffe97>] rtnl_lock+0xf/0x11
> Nov 15 13:12:13 localhost kernel: 3 locks held by kworker/0:2/1054:
> Nov 15 13:12:13 localhost kernel: #0:  (events){+.+.+.}, at: [<78446e6f>] process_one_work+0x13e/0x2bf
> Nov 15 13:12:13 localhost kernel: #1:  ((&rdev->conn_work)){+.+.+.}, at: [<78446e6f>] process_one_work+0x13e/0x2bf
> Nov 15 13:12:13 localhost kernel: #2:  (rtnl_mutex){+.+.+.}, at: [<786ffe97>] rtnl_lock+0xf/0x11

Where are the backtraces for kworker/u:5, 0:1 and 0:2?

> Nov 15 13:12:13 localhost kernel: 1 lock held by ntpd/1592:
> Nov 15 13:12:13 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<786ffe97>] rtnl_lock+0xf/0x11
> Nov 15 13:12:13 localhost kernel: 1 lock held by mingetty/1939:
> Nov 15 13:12:13 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<7860f455>] n_tty_read+0x1d2/0x5ee
> Nov 15 13:12:13 localhost kernel: 1 lock held by mingetty/1940:
> Nov 15 13:12:13 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<7860f455>] n_tty_read+0x1d2/0x5ee
> Nov 15 13:12:13 localhost kernel: 1 lock held by mingetty/1941:
> Nov 15 13:12:13 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<7860f455>] n_tty_read+0x1d2/0x5ee
> Nov 15 13:12:13 localhost kernel: 1 lock held by mingetty/1942:
> Nov 15 13:12:13 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<7860f455>] n_tty_read+0x1d2/0x5ee
> Nov 15 13:12:13 localhost kernel: 1 lock held by mingetty/1943:
> Nov 15 13:12:13 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<7860f455>] n_tty_read+0x1d2/0x5ee
> Nov 15 13:12:13 localhost kernel: 1 lock held by mingetty/1944:
> Nov 15 13:12:13 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<7860f455>] n_tty_read+0x1d2/0x5ee
> Nov 15 13:12:13 localhost kernel: 1 lock held by bash/2043:
> Nov 15 13:12:13 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<7860f455>] n_tty_read+0x1d2/0x5ee
> Nov 15 13:12:13 localhost kernel: 1 lock held by bash/2057:
> Nov 15 13:12:13 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<7860f455>] n_tty_read+0x1d2/0x5ee
> Nov 15 13:12:13 localhost kernel: 1 lock held by bash/2113:
> Nov 15 13:12:13 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<7860f455>] n_tty_read+0x1d2/0x5ee
> Nov 15 13:12:13 localhost kernel: 1 lock held by btserver/2375:
> Nov 15 13:12:13 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<786ffe97>] rtnl_lock+0xf/0x11
> Nov 15 13:12:13 localhost kernel: 3 locks held by kworker/0:3/5972:
> Nov 15 13:12:13 localhost kernel: #0:  (events){+.+.+.}, at: [<78446e6f>] process_one_work+0x13e/0x2bf
> Nov 15 13:12:13 localhost kernel: #1:  ((linkwatch_work).work){+.+.+.}, at: [<78446e6f>] process_one_work+0x13e/0x2bf
> Nov 15 13:12:13 localhost kernel: #2:  (rtnl_mutex){+.+.+.}, at: [<786ffe97>] rtnl_lock+0xf/0x11
> Nov 15 13:12:13 localhost kernel: 1 lock held by ip/6367:
> Nov 15 13:12:13 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<786ffe97>] rtnl_lock+0xf/0x11
> Nov 15 13:12:13 localhost kernel: 1 lock held by ip/6369:
> Nov 15 13:12:13 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<786ffe97>] rtnl_lock+0xf/0x11
> Nov 15 13:12:14 localhost kernel: 1 lock held by ip/6373:
> Nov 15 13:12:14 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<7870d35c>] netlink_dump+0x3a/0x16a
> Nov 15 13:12:14 localhost kernel: 1 lock held by ip/6376:
> Nov 15 13:12:14 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<786ffe97>] rtnl_lock+0xf/0x11
> Nov 15 13:12:14 localhost kernel: 1 lock held by ip/6378:
> Nov 15 13:12:14 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<786ffe97>] rtnl_lock+0xf/0x11
> Nov 15 13:12:14 localhost kernel: 1 lock held by ip/6379:
> Nov 15 13:12:14 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<786ffe97>] rtnl_lock+0xf/0x11
> Nov 15 13:12:14 localhost kernel: 4 locks held by sh/6381:
> Nov 15 13:12:14 localhost kernel: #0:  (&(&i->lock)->rlock){-.-...}, at: [<78631710>] serial8250_interrupt+0x1e/0xe2
> Nov 15 13:12:14 localhost kernel: #1:  (&port_lock_key){-.-...}, at: [<78631496>] serial8250_handle_port+0x10/0x26c
> Nov 15 13:12:14 localhost kernel: #2:  (sysrq_key_table_lock){-.....}, at: [<7861e8c2>] __handle_sysrq+0x18/0x11d
> Nov 15 13:12:14 localhost kernel: #3:  (tasklist_lock){.?.+..}, at: [<78459d8b>] debug_show_all_locks+0x43/0x179
> Nov 15 13:12:14 localhost kernel: 1 lock held by ip/6383:
> Nov 15 13:12:14 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<786ffe97>] rtnl_lock+0xf/0x11

Can you please do the followings?

1. Try to capture the full dump.  Usually serial console works best.

2. Does adding WQ_MEM_RECLAIM to alloc_ordered_workqueue() call in
   ieee80211_register_hw() make any difference?

3. What if you replace it with the following?

   alloc_workqueue(wiphy_name(local->hw.wiphy), WQ_NON_REENTRANT, 0)

Thanks.

-- 
tejun
