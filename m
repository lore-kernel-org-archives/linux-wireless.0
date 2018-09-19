Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:59910 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732164AbeISVcE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 17:32:04 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id 0A9D940A7E2
        for <linux-wireless@vger.kernel.org>; Wed, 19 Sep 2018 08:53:30 -0700 (PDT)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: Help with ath10k related circular locking
Message-ID: <923b8022-0e92-0ce3-4c11-baa0d6d6918b@candelatech.com> (sfid-20180919_175338_578962_EAD8E691)
Date: Wed, 19 Sep 2018 08:53:29 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I see this lockdep splat on a modified 4.16.18+ kernel when the ath10k
firmware crashes early.

I am having a hard time figuring out how to go about fixing this, and would welcome
some suggestions.

Sep 19 08:38:50 lf0313-6477 kernel:
Sep 19 08:38:50 lf0313-6477 kernel: ======================================================
Sep 19 08:38:51 lf0313-6477 kernel: WARNING: possible circular locking dependency detected
Sep 19 08:38:51 lf0313-6477 kernel: 4.16.18+ #24 Tainted: G        W  O
Sep 19 08:38:51 lf0313-6477 kernel: ------------------------------------------------------
Sep 19 08:38:51 lf0313-6477 kernel: ip/28805 is trying to acquire lock:
Sep 19 08:38:51 lf0313-6477 kernel:  ((wq_completion)"%s""ath10k_wq"){+.+.}, at: [<0000000019608b52>] flush_work+0x2b7/0x5d0
Sep 19 08:38:51 lf0313-6477 kernel:
                                     but task is already holding lock:
Sep 19 08:38:51 lf0313-6477 kernel:  (rtnl_mutex){+.+.}, at: [<00000000b6ff1870>] rtnetlink_rcv_msg+0x29e/0x840
Sep 19 08:38:51 lf0313-6477 kernel:
                                     which lock already depends on the new lock.
Sep 19 08:38:51 lf0313-6477 kernel:
                                     the existing dependency chain (in reverse order) is:
Sep 19 08:38:51 lf0313-6477 kernel:
                                     -> #2 (rtnl_mutex){+.+.}:
Sep 19 08:38:51 lf0313-6477 kernel:        wiphy_register+0x1120/0x1f90 [cfg80211]
Sep 19 08:38:51 lf0313-6477 kernel:        ieee80211_register_hw+0x114e/0x2d20 [mac80211]
Sep 19 08:38:51 lf0313-6477 kernel:        ath10k_mac_register+0x1b2f/0x2ff0 [ath10k_core]
Sep 19 08:38:51 lf0313-6477 kernel:        ath10k_core_register_work+0x2365/0x30e0 [ath10k_core]
Sep 19 08:38:51 lf0313-6477 kernel:        process_one_work+0x5f7/0x14d0
Sep 19 08:38:51 lf0313-6477 kernel:        worker_thread+0xdc/0x12d0
Sep 19 08:38:51 lf0313-6477 kernel:        kthread+0x2cf/0x3c0
Sep 19 08:38:51 lf0313-6477 kernel:        ret_from_fork+0x24/0x30
Sep 19 08:38:51 lf0313-6477 kernel:
                                     -> #1 ((work_completion)(&ar->register_work)){+.+.}:
Sep 19 08:38:51 lf0313-6477 kernel:        worker_thread+0xdc/0x12d0
Sep 19 08:38:51 lf0313-6477 kernel:        kthread+0x2cf/0x3c0
Sep 19 08:38:51 lf0313-6477 kernel:        ret_from_fork+0x24/0x30
Sep 19 08:38:51 lf0313-6477 kernel:
                                     -> #0 ((wq_completion)"%s""ath10k_wq"){+.+.}:
Sep 19 08:38:51 lf0313-6477 kernel:        flush_work+0x2d7/0x5d0
Sep 19 08:38:51 lf0313-6477 kernel:        __cancel_work_timer+0x21a/0x2e0
Sep 19 08:38:51 lf0313-6477 kernel:        drv_stop+0xc8/0x5a0 [mac80211]
Sep 19 08:38:51 lf0313-6477 kernel:        ieee80211_do_stop+0xc11/0x1910 [mac80211]
Sep 19 08:38:51 lf0313-6477 kernel:        ieee80211_stop+0x11/0x20 [mac80211]
Sep 19 08:38:51 lf0313-6477 kernel:        __dev_close_many+0x178/0x280
Sep 19 08:38:51 lf0313-6477 kernel:        __dev_change_flags+0x1cc/0x4c0
Sep 19 08:38:51 lf0313-6477 kernel:        dev_change_flags+0x75/0x150
Sep 19 08:38:51 lf0313-6477 kernel:        do_setlink+0x929/0x2be0
Sep 19 08:38:51 lf0313-6477 kernel:        rtnl_newlink+0xc33/0x12e0
Sep 19 08:38:51 lf0313-6477 kernel:        rtnetlink_rcv_msg+0x2e6/0x840
Sep 19 08:38:51 lf0313-6477 kernel:        netlink_rcv_skb+0x263/0x3b0
Sep 19 08:38:51 lf0313-6477 kernel:        netlink_unicast+0x3d4/0x560
Sep 19 08:38:51 lf0313-6477 kernel:        netlink_sendmsg+0x73f/0xae0
Sep 19 08:38:51 lf0313-6477 kernel:        sock_sendmsg+0xac/0xe0
Sep 19 08:38:51 lf0313-6477 kernel:        ___sys_sendmsg+0x744/0x8f0
Sep 19 08:38:51 lf0313-6477 kernel:        __sys_sendmsg+0xab/0x120
Sep 19 08:38:51 lf0313-6477 kernel:        do_syscall_64+0x193/0x5e0
Sep 19 08:38:51 lf0313-6477 kernel:        entry_SYSCALL_64_after_hwframe+0x42/0xb7
Sep 19 08:38:51 lf0313-6477 kernel:
                                     other info that might help us debug this:
Sep 19 08:38:51 lf0313-6477 kernel: Chain exists of:
                                       (wq_completion)"%s""ath10k_wq" --> (work_completion)(&ar->register_work) --> rtnl_mutex
Sep 19 08:38:51 lf0313-6477 kernel:  Possible unsafe locking scenario:
Sep 19 08:38:51 lf0313-6477 kernel:        CPU0                    CPU1
Sep 19 08:38:51 lf0313-6477 kernel:        ----                    ----
Sep 19 08:38:51 lf0313-6477 kernel:   lock(rtnl_mutex);
Sep 19 08:38:51 lf0313-6477 kernel:                                lock((work_completion)(&ar->register_work));
Sep 19 08:38:51 lf0313-6477 kernel:                                lock(rtnl_mutex);
Sep 19 08:38:51 lf0313-6477 kernel:   lock((wq_completion)"%s""ath10k_wq");
Sep 19 08:38:51 lf0313-6477 kernel:
                                      *** DEADLOCK ***
Sep 19 08:38:51 lf0313-6477 kernel: 1 lock held by ip/28805:
Sep 19 08:38:51 lf0313-6477 kernel:  #0:  (rtnl_mutex){+.+.}, at: [<00000000b6ff1870>] rtnetlink_rcv_msg+0x29e/0x840
Sep 19 08:38:51 lf0313-6477 kernel:
                                     stack backtrace:
Sep 19 08:38:51 lf0313-6477 kernel: CPU: 3 PID: 28805 Comm: ip Tainted: G        W  O     4.16.18+ #24
Sep 19 08:38:51 lf0313-6477 kernel: Hardware name: _ _/, BIOS 5.11 08/26/2016
Sep 19 08:38:51 lf0313-6477 kernel: Call Trace:
Sep 19 08:38:51 lf0313-6477 kernel:  dump_stack+0x7c/0xbf
Sep 19 08:38:51 lf0313-6477 kernel:  print_circular_bug.isra.37+0x36f/0x37d
Sep 19 08:38:51 lf0313-6477 kernel:  __lock_acquire_lockdep+0x3486/0x3de0
Sep 19 08:38:51 lf0313-6477 kernel:  ? rcu_read_lock_sched_held+0x9e/0x120
Sep 19 08:38:51 lf0313-6477 kernel:  ? debug_check_no_locks_freed+0x290/0x290
Sep 19 08:38:51 lf0313-6477 kernel:  ? lock_downgrade+0x580/0x580
Sep 19 08:38:51 lf0313-6477 kernel:  ? lock_downgrade+0x580/0x580
Sep 19 08:38:51 lf0313-6477 kernel:  ? flush_work+0x22e/0x5d0
Sep 19 08:38:51 lf0313-6477 kernel:  ? lock_acquire+0x114/0x330
Sep 19 08:38:51 lf0313-6477 kernel:  lock_acquire+0x114/0x330
Sep 19 08:38:51 lf0313-6477 kernel:  ? flush_work+0x2b7/0x5d0
Sep 19 08:38:51 lf0313-6477 kernel:  flush_work+0x2d7/0x5d0
Sep 19 08:38:51 lf0313-6477 kernel:  ? flush_work+0x2b7/0x5d0
Sep 19 08:38:51 lf0313-6477 kernel:  ? drain_workqueue+0x370/0x370
Sep 19 08:38:51 lf0313-6477 kernel:  ? flush_workqueue_prep_pwqs+0x380/0x380
Sep 19 08:38:51 lf0313-6477 kernel:  ? mark_held_locks+0xc0/0x110
Sep 19 08:38:51 lf0313-6477 kernel:  ? __cancel_work_timer+0x1f9/0x2e0
Sep 19 08:38:51 lf0313-6477 kernel:  __cancel_work_timer+0x21a/0x2e0
Sep 19 08:38:51 lf0313-6477 kernel:  ? mod_delayed_work_on+0xf0/0xf0
Sep 19 08:38:51 lf0313-6477 kernel:  ? __mutex_unlock_slowpath+0x341/0x690
Sep 19 08:38:51 lf0313-6477 kernel:  ? wait_for_completion+0x300/0x300
Sep 19 08:38:51 lf0313-6477 kernel:  ? mark_held_locks+0xc0/0x110
Sep 19 08:38:51 lf0313-6477 kernel:  ? __local_bh_enable_ip+0xea/0x1d0
Sep 19 08:38:51 lf0313-6477 kernel:  ? trace_hardirqs_on_caller+0x3ea/0x560
Sep 19 08:38:51 lf0313-6477 kernel:  drv_stop+0xc8/0x5a0 [mac80211]
Sep 19 08:38:51 lf0313-6477 kernel:  ieee80211_do_stop+0xc11/0x1910 [mac80211]
Sep 19 08:38:51 lf0313-6477 kernel:  ? mark_held_locks+0xc0/0x110
Sep 19 08:38:51 lf0313-6477 kernel:  ? ieee80211_add_virtual_monitor+0x8b0/0x8b0 [mac80211]
Sep 19 08:38:51 lf0313-6477 kernel:  ? lockdep_rtnl_is_held+0x11/0x20
Sep 19 08:38:51 lf0313-6477 kernel:  ? dev_deactivate_many+0x707/0x970
Sep 19 08:38:51 lf0313-6477 kernel:  ieee80211_stop+0x11/0x20 [mac80211]
Sep 19 08:38:51 lf0313-6477 kernel:  __dev_close_many+0x178/0x280
Sep 19 08:38:51 lf0313-6477 kernel:  ? netdev_notify_peers+0xb0/0xb0
Sep 19 08:38:51 lf0313-6477 kernel:  ? trace_hardirqs_on_caller+0x3ea/0x560
Sep 19 08:38:51 lf0313-6477 kernel:  __dev_change_flags+0x1cc/0x4c0
Sep 19 08:38:51 lf0313-6477 kernel:  ? dev_set_allmulti+0x10/0x10
Sep 19 08:38:51 lf0313-6477 kernel:  dev_change_flags+0x75/0x150
Sep 19 08:38:51 lf0313-6477 kernel:  do_setlink+0x929/0x2be0
Sep 19 08:38:51 lf0313-6477 kernel:  ? validate_linkmsg+0x670/0x670
Sep 19 08:38:51 lf0313-6477 kernel:  ? unwind_next_frame+0xfe9/0x19e0
Sep 19 08:38:51 lf0313-6477 kernel:  ? __lock_acquire_lockdep+0xb4d/0x3de0
Sep 19 08:38:51 lf0313-6477 kernel:  ? is_bpf_text_address+0x5c/0xe0
Sep 19 08:38:51 lf0313-6477 kernel:  ? debug_check_no_locks_freed+0x290/0x290
Sep 19 08:38:51 lf0313-6477 kernel:  ? __read_once_size_nocheck.constprop.8+0x10/0x10
Sep 19 08:38:51 lf0313-6477 kernel:  ? is_bpf_text_address+0x79/0xe0
Sep 19 08:38:51 lf0313-6477 kernel:  ? memset+0x1f/0x40
Sep 19 08:38:51 lf0313-6477 kernel:  ? nla_parse+0x35/0x270
Sep 19 08:38:51 lf0313-6477 kernel:  rtnl_newlink+0xc33/0x12e0
Sep 19 08:38:51 lf0313-6477 kernel:  ? rtnl_link_unregister+0x200/0x200
Sep 19 08:38:51 lf0313-6477 kernel:  ? unwind_next_frame+0xfe9/0x19e0
Sep 19 08:38:51 lf0313-6477 kernel:  ? is_bpf_text_address+0x5c/0xe0
Sep 19 08:38:51 lf0313-6477 kernel:  ? debug_check_no_locks_freed+0x290/0x290
Sep 19 08:38:51 lf0313-6477 kernel:  ? rtnetlink_rcv_msg+0x273/0x840
Sep 19 08:38:51 lf0313-6477 kernel:  ? lock_downgrade+0x580/0x580
Sep 19 08:38:51 lf0313-6477 kernel:  rtnetlink_rcv_msg+0x2e6/0x840
Sep 19 08:38:51 lf0313-6477 kernel:  ? rtnl_fdb_del+0x7c0/0x7c0
Sep 19 08:38:51 lf0313-6477 kernel:  ? lock_downgrade+0x580/0x580
Sep 19 08:38:51 lf0313-6477 kernel:  netlink_rcv_skb+0x263/0x3b0
Sep 19 08:38:51 lf0313-6477 kernel:  ? rtnl_fdb_del+0x7c0/0x7c0
Sep 19 08:38:51 lf0313-6477 kernel:  ? netlink_ack+0x7f0/0x7f0
Sep 19 08:38:51 lf0313-6477 kernel:  netlink_unicast+0x3d4/0x560
Sep 19 08:38:51 lf0313-6477 kernel:  ? netlink_attachskb+0x630/0x630
Sep 19 08:38:51 lf0313-6477 kernel:  ? dup_iter+0x2a0/0x2a0
Sep 19 08:38:51 lf0313-6477 kernel:  ? __check_object_size+0xfd/0x2b0
Sep 19 08:38:51 lf0313-6477 kernel:  netlink_sendmsg+0x73f/0xae0
Sep 19 08:38:51 lf0313-6477 kernel:  ? copy_msghdr_from_user+0x1f8/0x2f0
Sep 19 08:38:51 lf0313-6477 kernel:  ? netlink_unicast+0x560/0x560
Sep 19 08:38:51 lf0313-6477 kernel:  ? SYSC_sendto+0x2c0/0x2c0
Sep 19 08:38:51 lf0313-6477 kernel:  ? netlink_unicast+0x560/0x560
Sep 19 08:38:51 lf0313-6477 kernel:  sock_sendmsg+0xac/0xe0
Sep 19 08:38:51 lf0313-6477 kernel:  ___sys_sendmsg+0x744/0x8f0
Sep 19 08:38:51 lf0313-6477 kernel:  ? copy_msghdr_from_user+0x2f0/0x2f0
Sep 19 08:38:51 lf0313-6477 kernel:  ? debug_check_no_locks_freed+0x290/0x290
Sep 19 08:38:51 lf0313-6477 kernel:  ? debug_check_no_locks_freed+0x290/0x290
Sep 19 08:38:51 lf0313-6477 kernel:  ? rcu_read_lock_sched_held+0x9e/0x120
Sep 19 08:38:51 lf0313-6477 kernel:  ? __alloc_pages_nodemask+0x4b1/0x590
Sep 19 08:38:51 lf0313-6477 kernel:  ? __handle_mm_fault+0xd7e/0x2bc0
Sep 19 08:38:51 lf0313-6477 kernel:  ? __audit_syscall_entry+0x2f5/0x5f0
Sep 19 08:38:51 lf0313-6477 kernel:  ? lock_downgrade+0x580/0x580
Sep 19 08:38:51 lf0313-6477 kernel:  ? lock_acquire+0x114/0x330
Sep 19 08:38:51 lf0313-6477 kernel:  ? __audit_syscall_entry+0x2f5/0x5f0
Sep 19 08:38:51 lf0313-6477 kernel:  ? __sys_sendmsg+0xab/0x120
Sep 19 08:38:51 lf0313-6477 kernel:  __sys_sendmsg+0xab/0x120
Sep 19 08:38:51 lf0313-6477 kernel:  ? SyS_shutdown+0x150/0x150
Sep 19 08:38:51 lf0313-6477 kernel:  ? __audit_syscall_entry+0x2f5/0x5f0
Sep 19 08:38:51 lf0313-6477 kernel:  ? lock_downgrade+0x580/0x580
Sep 19 08:38:51 lf0313-6477 kernel:  ? syscall_trace_enter+0x51a/0xbf0
Sep 19 08:38:51 lf0313-6477 kernel:  ? do_syscall_64+0x3e/0x5e0
Sep 19 08:38:51 lf0313-6477 kernel:  ? __sys_sendmsg+0x120/0x120
Sep 19 08:38:51 lf0313-6477 kernel:  do_syscall_64+0x193/0x5e0
Sep 19 08:38:51 lf0313-6477 kernel:  entry_SYSCALL_64_after_hwframe+0x42/0xb7

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
