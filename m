Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:60887 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab1FUNKu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 09:10:50 -0400
Received: by qyk9 with SMTP id 9so1662666qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jun 2011 06:10:49 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 21 Jun 2011 21:10:48 +0800
Message-ID: <BANLkTimPMypvBWp-xv4WH_mD+WAOQQgRdA@mail.gmail.com> (sfid-20110621_151052_659498_9526F31F)
Subject: [3.0-rc4] lockdep: netdev notifier vs rfkill
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When hitting the hard rfkill in 3.0-rc4, lockdep spots some likely lock misuse:

=======================================================
[ INFO: possible circular locking dependency detected ]
3.0.0-rc4-340c #1
-------------------------------------------------------
kworker/0:0/4 is trying to acquire lock:
 (&rdev->mtx){+.+.+.}, at: [<ffffffff816cefce>]
cfg80211_netdev_notifier_call+0x11e/0x650

but task is already holding lock:
 (&rdev->devlist_mtx){+.+.+.}, at: [<ffffffff816cff16>]
cfg80211_rfkill_set_block+0x46/0xa0

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&rdev->devlist_mtx){+.+.+.}:
       [<ffffffff81096feb>] validate_chain.clone.23+0x54b/0x630
       [<ffffffff81098084>] __lock_acquire+0x474/0x960
       [<ffffffff81098af5>] lock_acquire+0x55/0x70
       [<ffffffff81716a5e>] mutex_lock_nested+0x5e/0x390
       [<ffffffff816cf307>] cfg80211_netdev_notifier_call+0x457/0x650
       [<ffffffff81084f3b>] notifier_call_chain+0x8b/0x100
       [<ffffffff81084fd1>] raw_notifier_call_chain+0x11/0x20
       [<ffffffff815a73b2>] call_netdevice_notifiers+0x32/0x60
       [<ffffffff815ab844>] __dev_notify_flags+0x34/0x90
       [<ffffffff815ab8e0>] dev_change_flags+0x40/0x70
       [<ffffffff815b9e8e>] do_setlink+0x17e/0x890
       [<ffffffff815ba687>] rtnl_setlink+0xe7/0x130
       [<ffffffff815badbf>] rtnetlink_rcv_msg+0x22f/0x260
       [<ffffffff815d35a9>] netlink_rcv_skb+0xa9/0xd0
       [<ffffffff815baaa0>] rtnetlink_rcv+0x20/0x30
       [<ffffffff815d2e3e>] netlink_unicast+0x1ee/0x240
       [<ffffffff815d30d1>] netlink_sendmsg+0x241/0x3b0
       [<ffffffff8159184c>] sock_sendmsg+0xdc/0x120
       [<ffffffff81591b48>] __sys_sendmsg+0x1d8/0x340
       [<ffffffff815937b4>] sys_sendmsg+0x44/0x80
       [<ffffffff817195bb>] system_call_fastpath+0x16/0x1b

-> #0 (&rdev->mtx){+.+.+.}:
       [<ffffffff81096a8b>] check_prev_add+0x70b/0x720
       [<ffffffff81096feb>] validate_chain.clone.23+0x54b/0x630
       [<ffffffff81098084>] __lock_acquire+0x474/0x960
       [<ffffffff81098af5>] lock_acquire+0x55/0x70
       [<ffffffff81716a5e>] mutex_lock_nested+0x5e/0x390
       [<ffffffff816cefce>] cfg80211_netdev_notifier_call+0x11e/0x650
       [<ffffffff81084f3b>] notifier_call_chain+0x8b/0x100
       [<ffffffff81084fd1>] raw_notifier_call_chain+0x11/0x20
       [<ffffffff815a73b2>] call_netdevice_notifiers+0x32/0x60
       [<ffffffff815a742d>] __dev_close_many+0x4d/0xf0
       [<ffffffff815a75a8>] dev_close_many+0x88/0x110
       [<ffffffff815a7668>] dev_close+0x38/0x50
       [<ffffffff816cff3a>] cfg80211_rfkill_set_block+0x6a/0xa0
       [<ffffffff816cff94>] cfg80211_rfkill_sync_work+0x24/0x30
       [<ffffffff81076aa7>] process_one_work+0x1b7/0x450
       [<ffffffff81079f51>] worker_thread+0x161/0x350
       [<ffffffff8107ec06>] kthread+0xb6/0xc0
       [<ffffffff8171a714>] kernel_thread_helper+0x4/0x10

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&rdev->devlist_mtx);
                               lock(&rdev->mtx);
                               lock(&rdev->devlist_mtx);
  lock(&rdev->mtx);

 *** DEADLOCK ***

4 locks held by kworker/0:0/4:
 #0:  (events){.+.+.+}, at: [<ffffffff81076a49>] process_one_work+0x159/0x450
 #1:  ((&rdev->rfkill_sync)){+.+...}, at: [<ffffffff81076a49>]
process_one_work+0x159/0x450
 #2:  (rtnl_mutex){+.+.+.}, at: [<ffffffff815baa72>] rtnl_lock+0x12/0x20
 #3:  (&rdev->devlist_mtx){+.+.+.}, at: [<ffffffff816cff16>]
cfg80211_rfkill_set_block+0x46/0xa0

stack backtrace:
Pid: 4, comm: kworker/0:0 Tainted: G         C  3.0.0-rc4-340c #1
Call Trace:
 [<ffffffff81095579>] print_circular_bug+0x109/0x110
 [<ffffffff81096a8b>] check_prev_add+0x70b/0x720
 [<ffffffff81096feb>] validate_chain.clone.23+0x54b/0x630
 [<ffffffff81098084>] __lock_acquire+0x474/0x960
 [<ffffffff810936ce>] ? __bfs+0x11e/0x260
 [<ffffffff8109632f>] ? check_irq_usage+0x9f/0xf0
 [<ffffffff816cefce>] ? cfg80211_netdev_notifier_call+0x11e/0x650
 [<ffffffff81098af5>] lock_acquire+0x55/0x70
 [<ffffffff816cefce>] ? cfg80211_netdev_notifier_call+0x11e/0x650
 [<ffffffff81056fed>] ? add_preempt_count+0x9d/0xd0
 [<ffffffff81716a5e>] mutex_lock_nested+0x5e/0x390
 [<ffffffff816cefce>] ? cfg80211_netdev_notifier_call+0x11e/0x650
 [<ffffffff81096feb>] ? validate_chain.clone.23+0x54b/0x630
 [<ffffffff816cefce>] cfg80211_netdev_notifier_call+0x11e/0x650
 [<ffffffff81098084>] ? __lock_acquire+0x474/0x960
 [<ffffffff81096feb>] ? validate_chain.clone.23+0x54b/0x630
 [<ffffffff81084f3b>] notifier_call_chain+0x8b/0x100
 [<ffffffff81084fd1>] raw_notifier_call_chain+0x11/0x20
 [<ffffffff815a73b2>] call_netdevice_notifiers+0x32/0x60
 [<ffffffff815a742d>] __dev_close_many+0x4d/0xf0
 [<ffffffff815a75a8>] dev_close_many+0x88/0x110
 [<ffffffff815a7668>] dev_close+0x38/0x50
 [<ffffffff816cff3a>] cfg80211_rfkill_set_block+0x6a/0xa0
 [<ffffffff816cff94>] cfg80211_rfkill_sync_work+0x24/0x30
 [<ffffffff81076aa7>] process_one_work+0x1b7/0x450
 [<ffffffff81076a49>] ? process_one_work+0x159/0x450
 [<ffffffff816cff70>] ? cfg80211_rfkill_set_block+0xa0/0xa0
 [<ffffffff81079f51>] worker_thread+0x161/0x350
 [<ffffffff81079df0>] ? manage_workers.clone.23+0x120/0x120
 [<ffffffff8107ec06>] kthread+0xb6/0xc0
 [<ffffffff810994ad>] ? trace_hardirqs_on_caller+0x13d/0x180
 [<ffffffff8171a714>] kernel_thread_helper+0x4/0x10
 [<ffffffff810498a7>] ? finish_task_switch+0x77/0x100
 [<ffffffff81718e44>] ? retint_restore_args+0xe/0xe
 [<ffffffff8107eb50>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff8171a710>] ? gs_change+0xb/0xb
-- 
Daniel J Blueman
