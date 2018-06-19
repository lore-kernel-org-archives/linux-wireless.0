Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:56060 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755452AbeFSUuf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Jun 2018 16:50:35 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id EEB5C40A5C4
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2018 13:50:32 -0700 (PDT)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: lockdep circular lock related to ath10k fw crash
Message-ID: <5f9f50de-994d-20c5-e6ed-bc1ca4721eec@candelatech.com> (sfid-20180619_225040_313713_27E3A8CE)
Date: Tue, 19 Jun 2018 13:50:32 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is from my hacked 4.16.15+ kernel, with modified ath10k FW
that likes to crash a lot.

In this case, FW crashed near an ath10k module reload.  I am not sure
if this is a bug in ath10k in particular, or mac80211 locking, or
a combination of both.


ath10k_pci 0000:04:00.0: firmware crashed! (guid 9e93f19e-db9c-4c4b-98af-826eeb959e98)
ath10k_pci 0000:04:00.0: failed to read firmware dump area: -16
ath10k_pci 0000:04:00.0: Copy Engine register dump:
ath10k_pci 0000:04:00.0: [00]: 0x0004a000   0   0   0   0
ath10k_pci 0000:04:00.0: [01]: 0x0004a400   0   0   0   0
ath10k_pci 0000:04:00.0: [02]: 0x0004a800   0   0   0   0
ath10k_pci 0000:04:00.0: [03]: 0x0004ac00   0   0   0   0
ath10k_pci 0000:04:00.0: [04]: 0x0004b000   0   0   0   0
ath10k_pci 0000:04:00.0: [05]: 0x0004b400   0   0   0   0
ath10k_pci 0000:04:00.0: [06]: 0x0004b800   0   0   0   0
ath10k_pci 0000:04:00.0: [07]: 0x0004bc00   0   0   0   0
ath10k_pci 0000:04:00.0: [08]: 0x0004c000   0   0   0   0
ath10k_pci 0000:04:00.0: [09]: 0x0004c400   0   0   0   0
ath10k_pci 0000:04:00.0: [10]: 0x0004c800   0   0   0   0
ath10k_pci 0000:04:00.0: [11]: 0x0004cc00   0   0   0   0
ath10k_pci 0000:04:00.0: failed to dump debug log area: -28

======================================================
WARNING: possible circular locking dependency detected
4.16.15+ #19 Not tainted
------------------------------------------------------
ip/17578 is trying to acquire lock:
  ((wq_completion)"%s""ath10k_wq"){+.+.}, at: [<0000000014225455>] flush_work+0x2b7/0x5d0

but task is already holding lock:
  (rtnl_mutex){+.+.}, at: [<00000000d6287784>] rtnetlink_rcv_msg+0x29e/0x840

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (rtnl_mutex){+.+.}:
        wiphy_register+0x1120/0x1f90 [cfg80211]
        ieee80211_register_hw+0x114e/0x2d20 [mac80211]
        ath10k_mac_register+0x1b2f/0x2f20 [ath10k_core]
        ath10k_core_register_work+0x22b7/0x3020 [ath10k_core]
        process_one_work+0x5f7/0x14d0
        worker_thread+0xdc/0x12d0
        kthread+0x2cf/0x3c0
        ret_from_fork+0x24/0x30

-> #1 ((work_completion)(&ar->register_work)){+.+.}:
        worker_thread+0xdc/0x12d0
        kthread+0x2cf/0x3c0
        ret_from_fork+0x24/0x30

-> #0 ((wq_completion)"%s""ath10k_wq"){+.+.}:
        flush_work+0x2d7/0x5d0
        __cancel_work_timer+0x21a/0x2e0
        drv_stop+0xc8/0x5a0 [mac80211]
        ieee80211_do_stop+0xc11/0x1910 [mac80211]
        ieee80211_stop+0x11/0x20 [mac80211]
        __dev_close_many+0x178/0x280
        __dev_change_flags+0x1cc/0x4c0
        dev_change_flags+0x75/0x150
        do_setlink+0x929/0x2be0
        rtnl_newlink+0xc33/0x12e0
        rtnetlink_rcv_msg+0x2e6/0x840
        netlink_rcv_skb+0x263/0x3b0
        netlink_unicast+0x3d4/0x560
        netlink_sendmsg+0x73f/0xae0
        sock_sendmsg+0xac/0xe0
        ___sys_sendmsg+0x744/0x8f0
        __sys_sendmsg+0xab/0x120
        do_syscall_64+0x193/0x5e0
        entry_SYSCALL_64_after_hwframe+0x42/0xb7

other info that might help us debug this:

Chain exists of:
   (wq_completion)"%s""ath10k_wq" --> (work_completion)(&ar->register_work) --> rtnl_mutex

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(rtnl_mutex);
                                lock((work_completion)(&ar->register_work));
                                lock(rtnl_mutex);
   lock((wq_completion)"%s""ath10k_wq");

  *** DEADLOCK ***

1 lock held by ip/17578:
  #0:  (rtnl_mutex){+.+.}, at: [<00000000d6287784>] rtnetlink_rcv_msg+0x29e/0x840

stack backtrace:
CPU: 1 PID: 17578 Comm: ip Not tainted 4.16.15+ #19
Hardware name: _ _/, BIOS 5.11 08/26/2016
Call Trace:
  dump_stack+0x7c/0xbf
  print_circular_bug.isra.37+0x36f/0x37d
  __lock_acquire_lockdep+0x3486/0x3de0
  ? rcu_read_lock_sched_held+0x9e/0x120
  ? debug_check_no_locks_freed+0x290/0x290
  ? mark_held_locks+0xc0/0x110
  ? trace_hardirqs_on_caller+0x3ea/0x560
  ? trace_hardirqs_on_thunk+0x1a/0x1c
  ? lock_acquire+0x114/0x330
  lock_acquire+0x114/0x330
  ? flush_work+0x2b7/0x5d0
  flush_work+0x2d7/0x5d0
  ? flush_work+0x2b7/0x5d0
  ? drain_workqueue+0x370/0x370
  ? flush_workqueue_prep_pwqs+0x380/0x380
  ? mark_held_locks+0xc0/0x110
  ? __cancel_work_timer+0x1f9/0x2e0
  __cancel_work_timer+0x21a/0x2e0
  ? mod_delayed_work_on+0xf0/0xf0
  ? __mutex_unlock_slowpath+0x341/0x690
  ? wait_for_completion+0x300/0x300
  ? mark_held_locks+0xc0/0x110
  ? __local_bh_enable_ip+0xea/0x1d0
  ? trace_hardirqs_on_caller+0x3ea/0x560
  drv_stop+0xc8/0x5a0 [mac80211]
  ieee80211_do_stop+0xc11/0x1910 [mac80211]
  ? mark_held_locks+0xc0/0x110
  ? ieee80211_add_virtual_monitor+0x8b0/0x8b0 [mac80211]
  ? lockdep_rtnl_is_held+0x11/0x20
  ? dev_deactivate_many+0x707/0x970
  ieee80211_stop+0x11/0x20 [mac80211]
  __dev_close_many+0x178/0x280
  ? netdev_notify_peers+0xb0/0xb0
  ? trace_hardirqs_on_caller+0x3ea/0x560
  __dev_change_flags+0x1cc/0x4c0
  ? dev_set_allmulti+0x10/0x10
  dev_change_flags+0x75/0x150
  do_setlink+0x929/0x2be0
  ? validate_linkmsg+0x670/0x670
  ? debug_check_no_locks_freed+0x290/0x290
  ? __read_once_size_nocheck.constprop.8+0x10/0x10
  ? unwind_next_frame+0xfe9/0x19e0
  ? __lock_acquire_lockdep+0xb4d/0x3de0
  ? is_bpf_text_address+0x5c/0xe0
  ? debug_check_no_locks_freed+0x290/0x290
  ? __read_once_size_nocheck.constprop.8+0x10/0x10
  ? is_bpf_text_address+0x79/0xe0
  ? memset+0x1f/0x40
  rtnl_newlink+0xc33/0x12e0
  ? rtnl_newlink+0x715/0x12e0
  ? rtnl_link_unregister+0x200/0x200
  ? unwind_next_frame+0xfe9/0x19e0
  ? is_bpf_text_address+0x5c/0xe0
  ? debug_check_no_locks_freed+0x290/0x290
  ? rtnetlink_rcv_msg+0x273/0x840
  ? lock_downgrade+0x580/0x580
  rtnetlink_rcv_msg+0x2e6/0x840
  ? rtnl_fdb_del+0x7c0/0x7c0
  ? lock_downgrade+0x580/0x580
  netlink_rcv_skb+0x263/0x3b0
  ? rtnl_fdb_del+0x7c0/0x7c0
  ? netlink_ack+0x7f0/0x7f0
  netlink_unicast+0x3d4/0x560
  ? netlink_attachskb+0x630/0x630
  ? dup_iter+0x2a0/0x2a0
  ? __check_object_size+0xfd/0x2b0
  netlink_sendmsg+0x73f/0xae0
  ? copy_msghdr_from_user+0x1f8/0x2f0
  ? netlink_unicast+0x560/0x560
  ? SYSC_sendto+0x2c0/0x2c0
  ? netlink_unicast+0x560/0x560
  sock_sendmsg+0xac/0xe0
  ___sys_sendmsg+0x744/0x8f0
  ? copy_msghdr_from_user+0x2f0/0x2f0
  ? debug_check_no_locks_freed+0x290/0x290
  ? debug_check_no_locks_freed+0x290/0x290
  ? rcu_read_lock_sched_held+0x9e/0x120
  ? __alloc_pages_nodemask+0x4b1/0x590
  ? __handle_mm_fault+0xd7e/0x2bc0
  ? __audit_syscall_entry+0x2f5/0x5f0
  ? lock_downgrade+0x580/0x580
  ? lock_acquire+0x114/0x330
  ? __audit_syscall_entry+0x2f5/0x5f0
  ? __sys_sendmsg+0xab/0x120
  __sys_sendmsg+0xab/0x120
  ? SyS_shutdown+0x150/0x150
  ? __audit_syscall_entry+0x2f5/0x5f0
  ? lock_downgrade+0x580/0x580
  ? syscall_trace_enter+0x51a/0xbf0
  ? do_syscall_64+0x3e/0x5e0
  ? __sys_sendmsg+0x120/0x120
  do_syscall_64+0x193/0x5e0
  entry_SYSCALL_64_after_hwframe+0x42/0xb7
RIP: 0033:0x7fcd271d0150
RSP: 002b:00007ffe8d317258 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000005b296a2f RCX: 00007fcd271d0150
RDX: 0000000000000000 RSI: 00007ffe8d3172d0 RDI: 0000000000000004
RBP: 00007ffe8d3172d0 R08: 0000000000000001 R09: 0000000000000000
R10: 00000000000005e7 R11: 0000000000000246 R12: 00007ffe8d317310
R13: 000000000066b460 R14: 00007ffe8d31f380 R15: 0000000000000000
ath10k_pci 0000:04:00.0: boot hif power up

Suggestions are welcome.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
