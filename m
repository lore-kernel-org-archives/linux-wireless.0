Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:35558 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602Ab1FCQJb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 12:09:31 -0400
From: duaneg@dghda.com
Date: Fri, 3 Jun 2011 17:00:49 +0100
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: rfkill deadlock
Message-ID: <20110603160049.GA8767@kereru> (sfid-20110603_180934_793277_98172B15)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi there,

I'm getting a deadlock with 3.0.0-rc1:

Jun  3 12:06:20 kereru kernel: =======================================================
Jun  3 12:06:20 kereru kernel: [ INFO: possible circular locking dependency detected ]
Jun  3 12:06:20 kereru kernel: 3.0.0-rc1-00049-g1fa7b6a #57
Jun  3 12:06:20 kereru kernel: -------------------------------------------------------
Jun  3 12:06:20 kereru kernel: kworker/0:1/4525 is trying to acquire lock:
Jun  3 12:06:20 kereru kernel: (&rdev->mtx){+.+.+.}, at: [<ffffffff8164c831>] cfg80211_netdev_notifier_call+0x131/0x5b0
Jun  3 12:06:20 kereru kernel: 
Jun  3 12:06:20 kereru kernel: but task is already holding lock:
Jun  3 12:06:20 kereru kernel: (&rdev->devlist_mtx){+.+.+.}, at: [<ffffffff8164dcef>] cfg80211_rfkill_set_block+0x4f/0xa0
Jun  3 12:06:20 kereru kernel: 
Jun  3 12:06:20 kereru kernel: which lock already depends on the new lock.
Jun  3 12:06:20 kereru kernel: 
Jun  3 12:06:20 kereru kernel: 
Jun  3 12:06:20 kereru kernel: the existing dependency chain (in reverse order) is:
Jun  3 12:06:20 kereru kernel: 
Jun  3 12:06:20 kereru kernel: -> #1 (&rdev->devlist_mtx){+.+.+.}:
Jun  3 12:06:20 kereru kernel: [<ffffffff81096473>] lock_acquire+0x103/0x140
Jun  3 12:06:20 kereru kernel: [<ffffffff816b0872>] mutex_lock_nested+0x72/0x3f0
Jun  3 12:06:20 kereru kernel: [<ffffffff8164cbcd>] cfg80211_netdev_notifier_call+0x4cd/0x5b0
Jun  3 12:06:20 kereru kernel: [<ffffffff816b615d>] notifier_call_chain+0x6d/0xb0
Jun  3 12:06:20 kereru kernel: [<ffffffff810814a6>] raw_notifier_call_chain+0x16/0x20
Jun  3 12:06:20 kereru kernel: [<ffffffff81597047>] call_netdevice_notifiers+0x37/0x70
Jun  3 12:06:20 kereru kernel: [<ffffffff81597c09>] __dev_notify_flags+0x39/0x90
Jun  3 12:06:20 kereru kernel: [<ffffffff81597ca5>] dev_change_flags+0x45/0x70
Jun  3 12:06:20 kereru kernel: [<ffffffff815a5745>] do_setlink+0x225/0x9e0
Jun  3 12:06:20 kereru kernel: [<ffffffff815a6c6c>] rtnl_newlink+0x3dc/0x5d0
Jun  3 12:06:20 kereru kernel: [<ffffffff815a683f>] rtnetlink_rcv_msg+0x21f/0x270
Jun  3 12:06:20 kereru kernel: [<ffffffff815b4979>] netlink_rcv_skb+0x89/0xb0
Jun  3 12:06:20 kereru kernel: [<ffffffff815a660e>] rtnetlink_rcv+0x2e/0x40
Jun  3 12:06:20 kereru kernel: [<ffffffff815b462f>] netlink_unicast+0x2af/0x2c0
Jun  3 12:06:20 kereru kernel: [<ffffffff815b5026>] netlink_sendmsg+0x316/0x350
Jun  3 12:06:20 kereru kernel: [<ffffffff81580938>] sock_sendmsg+0xe8/0x120
Jun  3 12:06:20 kereru kernel: [<ffffffff815817a1>] __sys_sendmsg+0x191/0x340
Jun  3 12:06:20 kereru kernel: [<ffffffff81581b29>] sys_sendmsg+0x49/0x80
Jun  3 12:06:20 kereru kernel: [<ffffffff816b9beb>] system_call_fastpath+0x16/0x1b
Jun  3 12:06:20 kereru kernel: 
Jun  3 12:06:20 kereru kernel: -> #0 (&rdev->mtx){+.+.+.}:
Jun  3 12:06:20 kereru kernel: [<ffffffff81095d13>] __lock_acquire+0x1e13/0x1ef0
Jun  3 12:06:20 kereru kernel: [<ffffffff81096473>] lock_acquire+0x103/0x140
Jun  3 12:06:20 kereru kernel: [<ffffffff816b0872>] mutex_lock_nested+0x72/0x3f0
Jun  3 12:06:20 kereru kernel: [<ffffffff8164c831>] cfg80211_netdev_notifier_call+0x131/0x5b0
Jun  3 12:06:20 kereru kernel: [<ffffffff816b615d>] notifier_call_chain+0x6d/0xb0
Jun  3 12:06:20 kereru kernel: [<ffffffff810814a6>] raw_notifier_call_chain+0x16/0x20
Jun  3 12:06:20 kereru kernel: [<ffffffff81597047>] call_netdevice_notifiers+0x37/0x70
Jun  3 12:06:20 kereru kernel: [<ffffffff815970cd>] __dev_close_many+0x4d/0xf0
Jun  3 12:06:20 kereru kernel: [<ffffffff81597265>] dev_close_many+0xa5/0x120
Jun  3 12:06:20 kereru kernel: [<ffffffff8159731f>] dev_close+0x3f/0x60
Jun  3 12:06:20 kereru kernel: [<ffffffff8164dd19>] cfg80211_rfkill_set_block+0x79/0xa0
Jun  3 12:06:20 kereru kernel: [<ffffffff81693022>] rfkill_set_block+0x82/0x110
Jun  3 12:06:20 kereru kernel: [<ffffffff81693377>] rfkill_switch_all+0xa7/0xd0
Jun  3 12:06:20 kereru kernel: [<ffffffff8169453d>] rfkill_op_handler+0xdd/0x1a0
Jun  3 12:06:20 kereru kernel: [<ffffffff8107348f>] process_one_work+0x20f/0x590
Jun  3 12:06:20 kereru kernel: [<ffffffff81073bbb>] worker_thread+0x19b/0x420
Jun  3 12:06:20 kereru kernel: [<ffffffff8107aed6>] kthread+0xa6/0xb0
Jun  3 12:06:20 kereru kernel: [<ffffffff816baa14>] kernel_thread_helper+0x4/0x10
Jun  3 12:06:20 kereru kernel: 
Jun  3 12:06:20 kereru kernel: other info that might help us debug this:
Jun  3 12:06:20 kereru kernel: 
Jun  3 12:06:20 kereru kernel: Possible unsafe locking scenario:
Jun  3 12:06:20 kereru kernel: 
Jun  3 12:06:20 kereru kernel: CPU0                    CPU1
Jun  3 12:06:20 kereru kernel: ----                    ----
Jun  3 12:06:20 kereru kernel: lock(&rdev->devlist_mtx);
Jun  3 12:06:20 kereru kernel: lock(&rdev->mtx);
Jun  3 12:06:20 kereru kernel: lock(&rdev->devlist_mtx);
Jun  3 12:06:20 kereru kernel: lock(&rdev->mtx);
Jun  3 12:06:20 kereru kernel: 
Jun  3 12:06:20 kereru kernel: *** DEADLOCK ***
Jun  3 12:06:20 kereru kernel: 
Jun  3 12:06:20 kereru kernel: 5 locks held by kworker/0:1/4525:
Jun  3 12:06:20 kereru kernel: #0:  (events){.+.+.+}, at: [<ffffffff810733d1>] process_one_work+0x151/0x590
Jun  3 12:06:20 kereru kernel: #1:  ((rfkill_op_work).work){+.+.+.}, at: [<ffffffff810733d1>] process_one_work+0x151/0x590
Jun  3 12:06:20 kereru kernel: #2:  (rfkill_global_mutex){+.+.+.}, at: [<ffffffff8169331e>] rfkill_switch_all+0x4e/0xd0
Jun  3 12:06:20 kereru kernel: #3:  (rtnl_mutex){+.+.+.}, at: [<ffffffff815a65d7>] rtnl_lock+0x17/0x20
Jun  3 12:06:20 kereru kernel: #4:  (&rdev->devlist_mtx){+.+.+.}, at: [<ffffffff8164dcef>] cfg80211_rfkill_set_block+0x4f/0xa0
Jun  3 12:06:20 kereru kernel: 
Jun  3 12:06:20 kereru kernel: stack backtrace:
Jun  3 12:06:20 kereru kernel: Pid: 4525, comm: kworker/0:1 Not tainted 3.0.0-rc1-00049-g1fa7b6a #57
Jun  3 12:06:20 kereru kernel: Call Trace:
Jun  3 12:06:20 kereru kernel: [<ffffffff81093df8>] print_circular_bug+0x218/0x320
Jun  3 12:06:20 kereru kernel: [<ffffffff81095d13>] __lock_acquire+0x1e13/0x1ef0
Jun  3 12:06:20 kereru kernel: [<ffffffff81093533>] ? check_usage+0x93/0x640
Jun  3 12:06:20 kereru kernel: [<ffffffff81096473>] lock_acquire+0x103/0x140
Jun  3 12:06:20 kereru kernel: [<ffffffff8164c831>] ? cfg80211_netdev_notifier_call+0x131/0x5b0
Jun  3 12:06:20 kereru kernel: [<ffffffff816b0872>] mutex_lock_nested+0x72/0x3f0
Jun  3 12:06:20 kereru kernel: [<ffffffff8164c831>] ? cfg80211_netdev_notifier_call+0x131/0x5b0
Jun  3 12:06:20 kereru kernel: [<ffffffff8164c831>] ? cfg80211_netdev_notifier_call+0x131/0x5b0
Jun  3 12:06:20 kereru kernel: [<ffffffff816b2f44>] ? retint_restore_args+0xe/0xe
Jun  3 12:06:20 kereru kernel: [<ffffffff8164c831>] cfg80211_netdev_notifier_call+0x131/0x5b0
Jun  3 12:06:20 kereru logger: ACPI event unhandled: button/wlan WLAN 00000080 00000000
Jun  3 12:06:20 kereru kernel: [<ffffffff816b615d>] notifier_call_chain+0x6d/0xb0
Jun  3 12:06:20 kereru kernel: [<ffffffff810814a6>] raw_notifier_call_chain+0x16/0x20
Jun  3 12:06:20 kereru kernel: [<ffffffff81597047>] call_netdevice_notifiers+0x37/0x70
Jun  3 12:06:20 kereru kernel: [<ffffffff815970cd>] __dev_close_many+0x4d/0xf0
Jun  3 12:06:20 kereru kernel: [<ffffffff81597265>] dev_close_many+0xa5/0x120
Jun  3 12:06:20 kereru kernel: [<ffffffff8159731f>] dev_close+0x3f/0x60
Jun  3 12:06:20 kereru kernel: [<ffffffff8164dd19>] cfg80211_rfkill_set_block+0x79/0xa0
Jun  3 12:06:20 kereru kernel: [<ffffffff81693022>] rfkill_set_block+0x82/0x110
Jun  3 12:06:20 kereru kernel: [<ffffffff81693377>] rfkill_switch_all+0xa7/0xd0
Jun  3 12:06:20 kereru kernel: [<ffffffff8169453d>] rfkill_op_handler+0xdd/0x1a0
Jun  3 12:06:20 kereru kernel: [<ffffffff8107348f>] process_one_work+0x20f/0x590
Jun  3 12:06:20 kereru kernel: [<ffffffff810733d1>] ? process_one_work+0x151/0x590
Jun  3 12:06:20 kereru kernel: [<ffffffff8109035e>] ? put_lock_stats+0xe/0x40
Jun  3 12:06:20 kereru kernel: [<ffffffff81694460>] ? rfkill_alloc+0x150/0x150
Jun  3 12:06:20 kereru kernel: [<ffffffff81073bbb>] worker_thread+0x19b/0x420
Jun  3 12:06:20 kereru kernel: [<ffffffff81073a20>] ? manage_workers+0x210/0x210
Jun  3 12:06:20 kereru kernel: [<ffffffff8107aed6>] kthread+0xa6/0xb0
Jun  3 12:06:20 kereru kernel: [<ffffffff816baa14>] kernel_thread_helper+0x4/0x10
Jun  3 12:06:20 kereru kernel: [<ffffffff8104ad08>] ? finish_task_switch+0x88/0x110
Jun  3 12:06:20 kereru kernel: [<ffffffff816b2f44>] ? retint_restore_args+0xe/0xe
Jun  3 12:06:20 kereru kernel: [<ffffffff8107ae30>] ? __init_kthread_worker+0x70/0x70
Jun  3 12:06:20 kereru kernel: [<ffffffff816baa10>] ? gs_change+0xb/0xb
Jun  3 12:06:20 kereru kernel: wlan%d: deauthenticating from 54:e6:fc:ae:e8:3d by local choice (reason=3)
Jun  3 12:06:20 kereru kernel: cfg80211: Calling CRDA to update world regulatory domain
Jun  3 12:06:20 kereru dhcpcd[3290]: wlan0: carrier lost

This is a new machine, so I've not tried earlier kernels on it. Let me
know if you'd like further information or other testing.

BTW, I assume that the "wlan%d" is also a (minor) bug :)

Cheers,
Duane Griffin.
