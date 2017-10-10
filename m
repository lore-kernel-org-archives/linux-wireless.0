Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:57168 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932087AbdJJTHw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Oct 2017 15:07:52 -0400
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>
From: Ben Greear <greearb@candelatech.com>
Subject: ath10k hang on rmmod after fw crash in 4.13.3+ hacks
Message-ID: <d18529ba-1d91-e9c6-4719-4586e6b5b287@candelatech.com> (sfid-20171010_210826_713851_577055F2)
Date: Tue, 10 Oct 2017 12:07:50 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I loaded a crashing firmware (it crashes early since it ran OOM), and
then tried to rmmod it.  rmmod hangs, with this stack:

[root@ben-ota-2 ~]# cat /proc/32491/stack
[<ffffffff8113c51d>] flush_work+0x1fd/0x2d0
[<ffffffff8113f031>] __cancel_work_timer+0x111/0x190
[<ffffffff8113f0bb>] cancel_work_sync+0xb/0x10
[<ffffffffa0b0a054>] ath10k_core_unregister+0x14/0xa0 [ath10k_core]
[<ffffffffa07c7dcd>] ath10k_pci_remove+0x2d/0x70 [ath10k_pci]
[<ffffffff81528834>] pci_device_remove+0x34/0xb0
[<ffffffff81656b18>] device_release_driver_internal+0x158/0x210
[<ffffffff81656c1b>] driver_detach+0x3b/0x80
[<ffffffff81655ad3>] bus_remove_driver+0x53/0xd0
[<ffffffff81657737>] driver_unregister+0x27/0x40
[<ffffffff81526ff4>] pci_unregister_driver+0x24/0x90
[<ffffffffa07ca922>] ath10k_pci_exit+0x10/0x6ee [ath10k_pci]
[<ffffffff811c64c1>] SyS_delete_module+0x1e1/0x2a0
[<ffffffff81003d34>] do_syscall_64+0x64/0x140
[<ffffffff819b77c9>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

This is a lockdep enabled kernel, and no lockdep warnings were issued.

This running a lot of my own patches, so could be a problem
I introduced...

https://github.com/greearb/linux-ct-4.13


After the timeout, I see this splat.  Further debug info is below,
including full sysrq stack dump.  Looks like ath10k work-queue issue.

Anyone seen similar?


[ 1983.524302] INFO: task rmmod:32491 blocked for more than 180 seconds.
[ 1983.530419]       Tainted: G           O    4.13.3+ #1
[ 1983.534955] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1983.542184] rmmod           D    0 32491   2341 0x00000080
[ 1983.542192] Call Trace:
[ 1983.542204]  __schedule+0x407/0xb70
[ 1983.542214]  schedule+0x38/0x90
[ 1983.542219]  schedule_timeout+0x263/0x580
[ 1983.542226]  ? lock_acquire+0xac/0x200
[ 1983.542231]  ? wait_for_completion+0xa7/0x120
[ 1983.542236]  ? _raw_spin_unlock_irq+0x27/0x50
[ 1983.542240]  ? trace_hardirqs_on_caller+0x11f/0x190
[ 1983.542243]  wait_for_completion+0xaf/0x120
[ 1983.542245]  ? wait_for_completion+0xaf/0x120
[ 1983.542249]  ? wake_up_q+0x70/0x70
[ 1983.542254]  flush_work+0x1fd/0x2d0
[ 1983.542257]  ? flush_workqueue_prep_pwqs+0x1c0/0x1c0
[ 1983.542265]  __cancel_work_timer+0x111/0x190
[ 1983.542273]  cancel_work_sync+0xb/0x10
[ 1983.542291]  ath10k_core_unregister+0x14/0xa0 [ath10k_core]
[ 1983.542296]  ath10k_pci_remove+0x2d/0x70 [ath10k_pci]
[ 1983.542300]  pci_device_remove+0x34/0xb0
[ 1983.542304]  device_release_driver_internal+0x158/0x210
[ 1983.542307]  driver_detach+0x3b/0x80
[ 1983.542312]  bus_remove_driver+0x53/0xd0
[ 1983.542314]  driver_unregister+0x27/0x40
[ 1983.542317]  pci_unregister_driver+0x24/0x90
[ 1983.542321]  ath10k_pci_exit+0x10/0x6ee [ath10k_pci]
[ 1983.542324]  SyS_delete_module+0x1e1/0x2a0
[ 1983.542331]  do_syscall_64+0x64/0x140
[ 1983.542334]  entry_SYSCALL64_slow_path+0x25/0x25
[ 1983.542337] RIP: 0033:0x7ff4cd9855e7
[ 1983.542338] RSP: 002b:00007ffdf7ef41d8 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
[ 1983.542341] RAX: ffffffffffffffda RBX: 00007ffdf7ef4228 RCX: 00007ff4cd9855e7
[ 1983.542343] RDX: 000000000000000a RSI: 0000000000000800 RDI: 000056280c84d298
[ 1983.542345] RBP: 000056280c84d230 R08: 000000000000000a R09: 1999999999999999
[ 1983.542346] R10: 00007ff4cd9f51a0 R11: 0000000000000206 R12: 00007ffdf7ef43f0
[ 1983.542347] R13: 00007ffdf7ef5599 R14: 0000000000000000 R15: 000056280c84d230
[ 1983.542356]
                Showing all locks held in the system:
[ 1983.542360] 2 locks held by kworker/u8:0/5:
[ 1983.542367]  #0:  ("%s""ath10k_wq"){++++.+}, at: [<ffffffff8113df8f>] process_one_work+0x14f/0x6a0
[ 1983.542376]  #1:  ((&ar->register_work)){+.+.+.}, at: [<ffffffff8113df8f>] process_one_work+0x14f/0x6a0
[ 1983.542386] 1 lock held by khungtaskd/38:
[ 1983.542387]  #0:  (tasklist_lock){.+.+..}, at: [<ffffffff8117b88d>] debug_show_all_locks+0x3d/0x1a0
[ 1983.542415] 2 locks held by bash/1762:
[ 1983.542417]  #0:  (&tty->ldisc_sem){++++.+}, at: [<ffffffff819b634d>] ldsem_down_read+0x2d/0x40
[ 1983.542424]  #1:  (&ldata->atomic_read_lock){+.+...}, at: [<ffffffff815f57e9>] n_tty_read+0xa9/0x8d0
[ 1983.542438] 2 locks held by kworker/u8:3/13363:
[ 1983.542439]  #0:  ("%s""ath10k_wq"){++++.+}, at: [<ffffffff8113df8f>] process_one_work+0x14f/0x6a0
[ 1983.542446]  #1:  ((&ar->register_work)){+.+.+.}, at: [<ffffffff8113df8f>] process_one_work+0x14f/0x6a0
[ 1983.542454] 2 locks held by rmmod/32491:
[ 1983.542455]  #0:  (&dev->mutex){......}, at: [<ffffffff816569e6>] device_release_driver_internal+0x26/0x210
[ 1983.542462]  #1:  (&dev->mutex){......}, at: [<ffffffff816569f4>] device_release_driver_internal+0x34/0x210
[ 1983.542469] 2 locks held by bash/988:
[ 1983.542470]  #0:  (&tty->ldisc_sem){++++.+}, at: [<ffffffff819b634d>] ldsem_down_read+0x2d/0x40
[ 1983.542477]  #1:  (&ldata->atomic_read_lock){+.+...}, at: [<ffffffff815f57e9>] n_tty_read+0xa9/0x8d0

[ 1983.542485] =============================================

[ 2163.768306] INFO: task rmmod:32491 blocked for more than 180 seconds.
[ 2163.774145]       Tainted: G           O    4.13.3+ #1
[ 2163.778661] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2163.785865] rmmod           D    0 32491   2341 0x00000080
[ 2163.785870] Call Trace:
[ 2163.785879]  __schedule+0x407/0xb70
[ 2163.785885]  schedule+0x38/0x90
[ 2163.785889]  schedule_timeout+0x263/0x580
[ 2163.785895]  ? lock_acquire+0xac/0x200
[ 2163.785898]  ? wait_for_completion+0xa7/0x120
[ 2163.785901]  ? _raw_spin_unlock_irq+0x27/0x50
[ 2163.785905]  ? trace_hardirqs_on_caller+0x11f/0x190
[ 2163.785908]  wait_for_completion+0xaf/0x120
[ 2163.785910]  ? wait_for_completion+0xaf/0x120
[ 2163.785913]  ? wake_up_q+0x70/0x70
[ 2163.785918]  flush_work+0x1fd/0x2d0
[ 2163.785921]  ? flush_workqueue_prep_pwqs+0x1c0/0x1c0
[ 2163.785930]  __cancel_work_timer+0x111/0x190
[ 2163.785937]  cancel_work_sync+0xb/0x10
[ 2163.785956]  ath10k_core_unregister+0x14/0xa0 [ath10k_core]
[ 2163.785960]  ath10k_pci_remove+0x2d/0x70 [ath10k_pci]
[ 2163.785965]  pci_device_remove+0x34/0xb0
[ 2163.785968]  device_release_driver_internal+0x158/0x210
[ 2163.785972]  driver_detach+0x3b/0x80
[ 2163.785977]  bus_remove_driver+0x53/0xd0
[ 2163.785979]  driver_unregister+0x27/0x40
[ 2163.785981]  pci_unregister_driver+0x24/0x90
[ 2163.785986]  ath10k_pci_exit+0x10/0x6ee [ath10k_pci]
[ 2163.785988]  SyS_delete_module+0x1e1/0x2a0
[ 2163.785995]  do_syscall_64+0x64/0x140
[ 2163.785998]  entry_SYSCALL64_slow_path+0x25/0x25
[ 2163.786001] RIP: 0033:0x7ff4cd9855e7
[ 2163.786002] RSP: 002b:00007ffdf7ef41d8 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
[ 2163.786006] RAX: ffffffffffffffda RBX: 00007ffdf7ef4228 RCX: 00007ff4cd9855e7
[ 2163.786007] RDX: 000000000000000a RSI: 0000000000000800 RDI: 000056280c84d298
[ 2163.786009] RBP: 000056280c84d230 R08: 000000000000000a R09: 1999999999999999
[ 2163.786010] R10: 00007ff4cd9f51a0 R11: 0000000000000206 R12: 00007ffdf7ef43f0
[ 2163.786012] R13: 00007ffdf7ef5599 R14: 0000000000000000 R15: 000056280c84d230
[ 2163.786020]
                Showing all locks held in the system:
[ 2163.786023] 2 locks held by kworker/u8:0/5:
[ 2163.786024]  #0:  ("%s""ath10k_wq"){++++.+}, at: [<ffffffff8113df8f>] process_one_work+0x14f/0x6a0
[ 2163.786033]  #1:  ((&ar->register_work)){+.+.+.}, at: [<ffffffff8113df8f>] process_one_work+0x14f/0x6a0
[ 2163.786042] 1 lock held by khungtaskd/38:
[ 2163.786044]  #0:  (tasklist_lock){.+.+..}, at: [<ffffffff8117b88d>] debug_show_all_locks+0x3d/0x1a0
[ 2163.786066] 2 locks held by bash/1762:
[ 2163.786067]  #0:  (&tty->ldisc_sem){++++.+}, at: [<ffffffff819b634d>] ldsem_down_read+0x2d/0x40
[ 2163.786074]  #1:  (&ldata->atomic_read_lock){+.+...}, at: [<ffffffff815f57e9>] n_tty_read+0xa9/0x8d0
[ 2163.786087] 2 locks held by kworker/u8:3/13363:
[ 2163.786088]  #0:  ("%s""ath10k_wq"){++++.+}, at: [<ffffffff8113df8f>] process_one_work+0x14f/0x6a0
[ 2163.786095]  #1:  ((&ar->register_work)){+.+.+.}, at: [<ffffffff8113df8f>] process_one_work+0x14f/0x6a0
[ 2163.786102] 2 locks held by rmmod/32491:
[ 2163.786103]  #0:  (&dev->mutex){......}, at: [<ffffffff816569e6>] device_release_driver_internal+0x26/0x210
[ 2163.786111]  #1:  (&dev->mutex){......}, at: [<ffffffff816569f4>] device_release_driver_internal+0x34/0x210
[ 2163.786118] 2 locks held by bash/988:
[ 2163.786119]  #0:  (&tty->ldisc_sem){++++.+}, at: [<ffffffff819b634d>] ldsem_down_read+0x2d/0x40
[ 2163.786126]  #1:  (&ldata->atomic_read_lock){+.+...}, at: [<ffffffff815f57e9>] n_tty_read+0xa9/0x8d0

[ 2163.786134] =============================================


sysrq-l:

[ 2347.733826] sysrq: SysRq : Show backtrace of all active CPUs
[ 2347.739213] NMI backtrace for cpu 1
[ 2347.739217] CPU: 1 PID: 988 Comm: bash Tainted: G           O    4.13.3+ #1
[ 2347.739218] Hardware name: To be filled by O.E.M. To be filled by O.E.M./ChiefRiver, BIOS 4.6.5 06/07/2013
[ 2347.739220] Call Trace:
[ 2347.739226]  dump_stack+0x85/0xc7
[ 2347.739230]  nmi_cpu_backtrace+0xbf/0xd0
[ 2347.739234]  ? irq_force_complete_move+0xf0/0xf0
[ 2347.739238]  nmi_trigger_cpumask_backtrace+0xaf/0xf0
[ 2347.739241]  arch_trigger_cpumask_backtrace+0x14/0x20
[ 2347.739245]  sysrq_handle_showallcpus+0x12/0x20
[ 2347.739248]  __handle_sysrq+0x121/0x200
[ 2347.739251]  write_sysrq_trigger+0x4c/0x50
[ 2347.739254]  proc_reg_write+0x3d/0x60
[ 2347.739258]  __vfs_write+0x23/0x140
[ 2347.739262]  ? rcu_read_lock_sched_held+0x6d/0x80
[ 2347.739265]  ? rcu_sync_lockdep_assert+0x2a/0x50
[ 2347.739267]  ? __sb_start_write+0xd2/0x1f0
[ 2347.739270]  ? vfs_write+0x1a2/0x1c0
[ 2347.739274]  vfs_write+0xc5/0x1c0
[ 2347.739277]  ? syscall_trace_enter+0x1bc/0x3b0
[ 2347.739281]  SyS_write+0x44/0xa0
[ 2347.739285]  do_syscall_64+0x64/0x140
[ 2347.739290]  entry_SYSCALL64_slow_path+0x25/0x25
[ 2347.739292] RIP: 0033:0x7fa0768321f0
[ 2347.739294] RSP: 002b:00007ffdc8c0f7a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[ 2347.739297] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fa0768321f0
[ 2347.739298] RDX: 0000000000000002 RSI: 000055a7738f1fc0 RDI: 0000000000000001
[ 2347.739300] RBP: 000055a7738f1fc0 R08: 00007fa076afd760 R09: 00007fa077137700
[ 2347.739301] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000002
[ 2347.739302] R13: 0000000000000001 R14: 00007fa076afc600 R15: 0000000000000000
[ 2347.739310] Sending NMI from CPU 1 to CPUs 0,2-3:
[ 2347.739318] NMI backtrace for cpu 3 skipped: idling at pc 0xffffffff819b6b47
[ 2347.739340] NMI backtrace for cpu 0 skipped: idling at pc 0xffffffff819b6b47
[ 2347.739342] NMI backtrace for cpu 2 skipped: idling at pc 0xffffffff819b6b47


And, full backtrace of all tasks:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: sysrq: SysRq : Show State
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   task                        PC stack   pid father
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: systemd         S    0     1      0 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? ep_poll+0x2e1/0x3c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ep_poll+0x2f3/0x3c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? wake_up_q+0x70/0x70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_epoll_wait+0xcb/0xe0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL_64_fastpath+0x23/0xc2
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f5b060196d3
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007ffc252adf60 EFLAGS: 00000293 ORIG_RAX: 00000000000000e8
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 00005585e785bce0 RCX: 00007f5b060196d3
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 000000000000006e RSI: 00007ffc252adf70 RDI: 0000000000000004
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 0000000000000000 R08: ad20fc209f41fad0 R09: 00000000000013e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00000000ffffffff R11: 0000000000000293 R12: 0000000000000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00007ffc252abff8 R14: 00005585e60eb620 R15: 00005585e60eaf4c
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kthreadd        S    0     2      0 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthreadd+0x28d/0x2b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_cpu+0x90/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kworker/0:0H    S    0     4      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  worker_thread+0xc6/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? process_one_work+0x6a0/0x6a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kworker/u8:0    D    0     5      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Workqueue: ath10k_wq ath10k_core_register_work [ath10k_core]
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? _raw_spin_unlock_irqrestore+0x4e/0x70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_timeout+0x224/0x580
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? call_timer_fn+0x370/0x370
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  msleep+0x34/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? msleep+0x34/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  napi_disable+0x55/0x70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ath10k_core_register_work+0x98/0xb00 [ath10k_core]
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  process_one_work+0x1ce/0x6a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  worker_thread+0x46/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? process_one_work+0x6a0/0x6a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: mm_percpu_wq    S    0     6      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: ksoftirqd/0     S    0     7      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  smpboot_thread_fn+0x1a6/0x210
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? sort_range+0x20/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: rcu_preempt     S    0     8      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rcu_gp_kthread+0x74/0x910
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? force_qs_rnp+0x1d0/0x1d0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: rcu_sched       S    0     9      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rcu_gp_kthread+0x74/0x910
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? force_qs_rnp+0x1d0/0x1d0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: rcu_bh          S    0    10      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rcu_gp_kthread+0x74/0x910
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? force_qs_rnp+0x1d0/0x1d0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: migration/0     S    0    11      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  smpboot_thread_fn+0x1a6/0x210
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? sort_range+0x20/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: watchdog/0      S    0    12      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? sched_clock+0x9/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  smpboot_thread_fn+0x1a6/0x210
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? sort_range+0x20/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_sched_getscheduler+0xa0/0x160
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: cpuhp/0         S    0    13      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  smpboot_thread_fn+0x1a6/0x210
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? sort_range+0x20/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: cpuhp/1         S    0    14      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  smpboot_thread_fn+0x1a6/0x210
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? sort_range+0x20/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: watchdog/1      S    0    15      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? sched_clock+0x9/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  smpboot_thread_fn+0x1a6/0x210
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? sort_range+0x20/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: migration/1     S    0    16      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  smpboot_thread_fn+0x1a6/0x210
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? sort_range+0x20/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: ksoftirqd/1     S    0    17      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  smpboot_thread_fn+0x1a6/0x210
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? sort_range+0x20/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kworker/1:0H    S    0    19      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  worker_thread+0xc6/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? process_one_work+0x6a0/0x6a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: cpuhp/2         S    0    20      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  smpboot_thread_fn+0x1a6/0x210
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? sort_range+0x20/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: watchdog/2      S    0    21      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? sched_clock+0x9/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  smpboot_thread_fn+0x1a6/0x210
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? sort_range+0x20/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: migration/2     S    0    22      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  smpboot_thread_fn+0x1a6/0x210
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? sort_range+0x20/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: ksoftirqd/2     S    0    23      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  smpboot_thread_fn+0x1a6/0x210
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? sort_range+0x20/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kworker/2:0H    S    0    25      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  worker_thread+0xc6/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? process_one_work+0x6a0/0x6a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: cpuhp/3         S    0    26      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  smpboot_thread_fn+0x1a6/0x210
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? sort_range+0x20/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: watchdog/3      S    0    27      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? sched_clock+0x9/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  smpboot_thread_fn+0x1a6/0x210
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? sort_range+0x20/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: migration/3     S    0    28      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  smpboot_thread_fn+0x1a6/0x210
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? sort_range+0x20/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: ksoftirqd/3     S    0    29      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  smpboot_thread_fn+0x1a6/0x210
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? sort_range+0x20/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kworker/3:0H    S    0    31      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  worker_thread+0xc6/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? process_one_work+0x6a0/0x6a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kdevtmpfs       S    0    32      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  devtmpfsd+0x158/0x170
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? handle_create+0x1d0/0x1d0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? C_SYSC_rt_tgsigqueueinfo+0x40/0x70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: netns           S    0    33      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: khungtaskd      S    0    38      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_timeout+0x224/0x580
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? call_timer_fn+0x370/0x370
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_timeout_interruptible+0x25/0x30
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? schedule_timeout_interruptible+0x25/0x30
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  watchdog+0x7b/0x630
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? reset_hung_task_detector+0x10/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: oom_reaper      S    0    39      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  oom_reaper+0x135/0x1a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? wait_woken+0x90/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __oom_reap_task_mm+0x660/0x660
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: writeback       S    0    40      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kcompactd0      S    0    41      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kcompactd+0x1f0/0x2b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? wait_woken+0x90/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kcompactd_do_work+0x4c0/0x4c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: ksmd            S    0    42      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ksm_scan_thread+0x115/0x1660
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? finish_task_switch+0x9c/0x220
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? finish_task_switch+0x60/0x220
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __schedule+0x40f/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? wait_woken+0x90/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __stable_node_chain+0x50/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: khugepaged      S    0    43      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_timeout+0x224/0x580
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? prepare_to_wait_event+0x75/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? call_timer_fn+0x370/0x370
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  khugepaged+0x398/0x2530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? khugepaged+0x398/0x2530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? wait_woken+0x90/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __collapse_huge_page_swapin+0x6d0/0x6d0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: crypto          S    0    44      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kintegrityd     S    0    45      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kblockd         S    0    46      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: ata_sff         S    0    47      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: md              S    0    48      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: edac-poller     S    0    49      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: devfreq_wq      S    0    50      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: watchdogd       S    0    51      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kauditd         S    0   147      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kauditd_thread+0x28c/0x4f0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? wait_woken+0x90/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? auditd_reset+0xf0/0xf0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kswapd0         S    0   148      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kswapd+0x73c/0x8c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? _raw_spin_unlock_irq+0x27/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? wait_woken+0x90/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? node_reclaim+0x250/0x250
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: pencrypt        S    0   176      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: pdecrypt        S    0   177      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kthrotld        S    0   240      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: acpi_thermal_pm S    0   241      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: scsi_eh_0       S    0   243      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  scsi_error_handler+0x89/0x5d0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? scsi_eh_get_sense+0x230/0x230
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: scsi_tmf_0      S    0   244      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: scsi_eh_1       S    0   245      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  scsi_error_handler+0x89/0x5d0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? scsi_eh_get_sense+0x230/0x230
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: scsi_tmf_1      S    0   246      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: scsi_eh_2       S    0   247      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  scsi_error_handler+0x89/0x5d0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? scsi_eh_get_sense+0x230/0x230
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: scsi_tmf_2      S    0   248      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: scsi_eh_3       S    0   249      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  scsi_error_handler+0x89/0x5d0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? scsi_eh_get_sense+0x230/0x230
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: scsi_tmf_3      S    0   250      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: scsi_eh_4       S    0   251      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  scsi_error_handler+0x89/0x5d0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? scsi_eh_get_sense+0x230/0x230
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: scsi_tmf_4      S    0   252      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: scsi_eh_5       S    0   253      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  scsi_error_handler+0x89/0x5d0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? scsi_eh_get_sense+0x230/0x230
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: scsi_tmf_5      S    0   254      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kworker/u8:5    S    0   258      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  worker_thread+0xc6/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? process_one_work+0x6a0/0x6a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? C_SYSC_rt_tgsigqueueinfo+0x40/0x70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: dm_bufio_cache  S    0   260      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: qat_device_rese S    0   261      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: qat_pf2vf_resp_ S    0   262      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: adf_vf_stop_wq  S    0   263      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: charger_manager S    0   310      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kworker/3:3     R  running task        0   311      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  worker_thread+0xc6/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? process_one_work+0x6a0/0x6a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: ipv6_addrconf   S    0   312      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kworker/1:2     S    0   349      2 0x00000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  worker_thread+0xc6/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? process_one_work+0x6a0/0x6a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: i915/signal:0   S    0   525      2 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  intel_breadcrumbs_signaler+0x41a/0x450 [i915]
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __schedule+0x40f/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? wait_woken+0x90/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __intel_engine_remove_wait+0x210/0x210 [i915]
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: i915/signal:1   S    0   526      2 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  intel_breadcrumbs_signaler+0x41a/0x450 [i915]
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __schedule+0x40f/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? wait_woken+0x90/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __intel_engine_remove_wait+0x210/0x210 [i915]
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: i915/signal:2   S    0   527      2 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  intel_breadcrumbs_signaler+0x41a/0x450 [i915]
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __schedule+0x40f/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? wait_woken+0x90/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __intel_engine_remove_wait+0x210/0x210 [i915]
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kworker/0:1H    S    0   528      2 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  worker_thread+0xc6/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? process_one_work+0x6a0/0x6a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kworker/1:1H    S    0   529      2 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  worker_thread+0xc6/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? process_one_work+0x6a0/0x6a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kworker/2:1H    S    0   530      2 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  worker_thread+0xc6/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? process_one_work+0x6a0/0x6a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kdmflush        S    0   607      2 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: bioset          S    0   610      2 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kworker/3:1H    S    0   613      2 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  worker_thread+0xc6/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? process_one_work+0x6a0/0x6a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kdmflush        S    0   618      2 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: bioset          S    0   620      2 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: jbd2/dm-0-8     S    0   639      2 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kjournald2+0x2ca/0x370
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? wait_woken+0x90/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? commit_timeout+0x10/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: ext4-rsv-conver S    0   640      2 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: systemd-journal R  running task        0   736      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? mark_held_locks+0x6f/0xa0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __might_fault+0x39/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? fault_dirty_shared_page.isra.63+0x44/0xb0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? finish_mkwrite_fault+0x114/0x130
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? do_wp_page+0x2ec/0x4e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __handle_mm_fault+0x752/0xfb0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x41/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? rcu_read_lock_sched_held+0x6d/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kfree+0x24d/0x2b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_exit+0x22b/0x2d0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_thunk+0x1a/0x1c
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? do_syscall_64+0xa2/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? page_fault+0x28/0x30
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: rpciod          S    0   754      2 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: xprtiod         S    0   755      2 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: lvmetad         S    0   758      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0xee/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __hrtimer_init+0x90/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_select+0x7f9/0x950
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? mark_held_locks+0x6f/0xa0
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 14 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 80 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? ep_poll+0x2e1/0x3c0
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 54 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 70 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 49 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 50 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 41 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 0000000000000000 R08: 000056481399bb00 R09: 0000000000000000
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 57 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 47 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __lock_acquire+0x28d/0x1520
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 58 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 58 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 50 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 49 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00007f280964fbb0 R11: 0000000000000246 R12: 00007ffe200d1f48
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 62 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 67 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00005609e00fa720 R14: 00005609e00fac78 R15: 00005609e00fbe40
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 47 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 46 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 0000000000000000 RSI: 00007ffdca252de0 RDI: 000000000000000e
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 51 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: radiusd         S    0  1413      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 66 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 0000000000000189 RCX: 00007f784696e0b6
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 53 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 0000000000002710 R11: 0000000000000293 R12: 00007ffe70dcaea4
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 44 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 55 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 0000000000000001 RSI: 0000000000000080 RDI: 000055decf8927a4
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 53 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  futex_wait_queue_me+0xd5/0x160
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 61 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 000055decf511500 R08: 000055decf4aa300 R09: 0000000000000000
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 48 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd S    0  1435   1392 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 53 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 57 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 000055decf511500 R08: 000055decf4aa300 R09: 0000000000000000
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 43 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007efd0d4b3bc0
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 51 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 44 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007efd0d8f62ac R08: 0000000000000000 R09: 00007ffe70dcadd0
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 52 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 53 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd S    0  1449   1392 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 57 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __lock_acquire+0x28d/0x1520
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 61 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 000055decf88e6a8 RCX: 00007efd0d4b3bc0
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 44 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007efcec8e4d40 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 54 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 45 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 53 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 000055decf88e370 R14: 000055decf88e3c0 R15: 00007efcec8e59c0
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 47 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? ktime_get_ts64+0xa8/0x170
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 55 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 000055decf88e370 R14: 000055decf88e3c0 R15: 00007efced8e79c0
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 73 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? pktgen_thread_worker+0x186a/0x2860 [pktgen]
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 72 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 46 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 51 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 0000000000000000 R11: 0000000000000246 R12: 000055885d269468
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 56 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: gdbus           S    0  1573   1553 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 46 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? _raw_spin_unlock_irq+0x27/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 55 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00007ffe82abb1d0 R11: 0000000000000246 R12: 0000000000000004
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 42 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? _raw_spin_unlock_irq+0x27/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 46 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007fac800010e0
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 56 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 49 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 51 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 0000559efa3d6400 R11: 0000000000000293 R12: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 50 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __schedule+0x40f/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 52 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 000055ce13a82b10 RCX: 00007fa179eee54d
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 63 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 47 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: gdbus           S    0  1596      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 50 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f75a1848219
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 51 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? try_to_wake_up+0x45/0x530
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 50 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 00007ff09c0008c0
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 55 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? reacquire_held_locks+0x67/0x170
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 56 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007f4a5bfa62f0 R15: 0000000000000004
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 58 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 40 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007f4a5bfa62f0 R15: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 44 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 53 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 00007f48fc0010c0
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 60 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 46 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: gdbus           S    0  1620      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 43 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_futex+0x2c6/0xaf0
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 36 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: gvfsd-fuse      S    0  1641      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 41 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 36 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 57 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 50 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007f57780010e0 R08: 0000000000000001 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 271 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007f91440010c0 R08: 0000000000000002 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 363 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 258 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007f848002e2f0 R15: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 137 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 000055b4122162e0 R11: 0000000000000293 R12: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 140 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007f7da80010c0 R08: 0000000000000001 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 312 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: gvfs-mtp-volume S    0  1711      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 301 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007f353c0008c0 R08: 0000000000000002 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 427 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: gdbus           S    0  1783      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 256 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0x5d/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 48 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com systemd-journald[736]: Missed 11 kernel messages
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7fac6abed54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007fac57ffec20 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 00007fac5000c2a0 RCX: 00007fac6abed54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 00007fac4c0010c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007fac4c0010c0 R08: 0000000000000002 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00007fac5000a060 R11: 0000000000000293 R12: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007fac6b2192f0 R15: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: dconf worker    S    0  2059      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? _raw_spin_unlock_irq+0x27/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? finish_task_switch+0x9c/0x220
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? finish_task_switch+0x60/0x220
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __schedule+0x40f/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? resched_curr+0x7c/0xa0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? update_load_avg+0x45f/0x5c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7fac6abed54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007fac575f0c30 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 00005568f7b2ba40 RCX: 00007fac6abed54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007fac440010c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007fac440010c0 R08: 0000000000000001 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00005568f7ab5e60 R11: 0000000000000293 R12: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007fac6b2192f0 R15: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: clock-applet    S    0  1868      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0xee/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __hrtimer_init+0x90/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? mutex_unlock+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? unix_stream_read_generic+0x231/0x920
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __might_fault+0x80/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? poll_select_set_timeout+0x50/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? ktime_get_ts64+0xa8/0x170
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0x5d/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0x5d/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f6c7fda654d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007fff30f15170 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 00005583d16adfb0 RCX: 00007f6c7fda654d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000000003e6 RSI: 0000000000000003 RDI: 00005583d1689940
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00005583d1689940 R08: 0000000000000003 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00005583d1726c00 R11: 0000000000000293 R12: 0000000000000003
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000000003e6 R14: 00007f6c803d22f0 R15: 0000000000000003
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: gmain           S    0  2027      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? inotify_poll+0x4c/0x60
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? eventfd_ctx_read+0xa4/0x1b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __might_fault+0x39/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f6c7fda654d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007f6c6fcdbb70 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 00005583d16b0880 RCX: 00007f6c7fda654d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 00007f6c600008c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007f6c600008c0 R08: 0000000000000002 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00005583d1756200 R11: 0000000000000293 R12: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007f6c803d22f0 R15: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: gdbus           S    0  2029      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? mutex_unlock+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? unix_stream_read_generic+0x231/0x920
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? eventfd_ctx_read+0xa4/0x1b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __might_fault+0x39/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f6c7fda654d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007f6c6ecd9b60 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 00007f6c6800c2a0 RCX: 00007f6c7fda654d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 00007f6c640010c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007f6c640010c0 R08: 0000000000000002 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00007f6c6800a060 R11: 0000000000000293 R12: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007f6c803d22f0 R15: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: dconf worker    S    0  2063      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? _raw_spin_unlock_irq+0x27/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? finish_task_switch+0x9c/0x220
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? finish_task_switch+0x60/0x220
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __schedule+0x40f/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? resched_curr+0x7c/0xa0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? eventfd_ctx_read+0xa4/0x1b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __might_fault+0x39/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f6c7fda654d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007f6c6de8eb70 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 00005583d1722920 RCX: 00007f6c7fda654d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007f6c580010c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007f6c580010c0 R08: 0000000000000001 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00005583d170d680 R11: 0000000000000293 R12: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007f6c803d22f0 R15: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: notification-ar S    0  1875      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? mutex_unlock+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? unix_stream_read_generic+0x231/0x920
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __might_fault+0x80/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? rcu_read_lock_sched_held+0x6d/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f29f31a054d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007fff10b3ba20 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 00005654150e3fb0 RCX: 00007f29f31a054d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 00005654150bf8e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00005654150bf8e0 R08: 0000000000000002 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00005654150ada20 R11: 0000000000000293 R12: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007f29f34c32f0 R15: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: gmain           S    0  1956      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? eventfd_ctx_read+0xa4/0x1b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __might_fault+0x39/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f29f31a054d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007f29e5947c30 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 00005654150e6980 RCX: 00007f29f31a054d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007f29e00008c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007f29e00008c0 R08: 0000000000000001 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00005654150adca0 R11: 0000000000000293 R12: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007f29f34c32f0 R15: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: gdbus           S    0  1958      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? _raw_spin_unlock_irqrestore+0x4e/0x70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? sock_def_readable+0xb2/0x2a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? sock_def_readable+0xcf/0x2a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? eventfd_ctx_read+0xa4/0x1b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? _raw_spin_unlock_irq+0x27/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f29f31a054d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007f29e4945c20 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 00007f29d800c2a0 RCX: 00007f29f31a054d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 00007f29dc0010c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007f29dc0010c0 R08: 0000000000000002 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00007f29d800a060 R11: 0000000000000293 R12: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007f29f34c32f0 R15: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: evolution-sourc S    0  1999      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0xee/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __hrtimer_init+0x90/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? update_curr+0xfc/0x2e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? try_to_wake_up+0x45/0x530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? try_to_wake_up+0x45/0x530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? poll_select_set_timeout+0x50/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? ktime_get_ts64+0xa8/0x170
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0x5d/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0x5d/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7fc0d015f54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007ffcc5af2910 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 000055c316185550 RCX: 00007fc0d015f54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 000000000036eb78 RSI: 0000000000000001 RDI: 000055c3161b6b10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 000055c3161b6b10 R08: 0000000000000001 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 000055c316188820 R11: 0000000000000293 R12: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 000000000036eb78 R14: 00007fc0ca6ad2f0 R15: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: dconf worker    S    0  2035      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? _raw_spin_unlock_irq+0x27/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? finish_task_switch+0x9c/0x220
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? finish_task_switch+0x60/0x220
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? eventfd_ctx_read+0xa4/0x1b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? _raw_spin_unlock_irq+0x27/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7fc0d015f54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007fc0b8777af0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 000055c31618c6b0 RCX: 00007fc0d015f54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007fc0a80010c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007fc0a80010c0 R08: 0000000000000001 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 000055c31618c860 R11: 0000000000000293 R12: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007fc0ca6ad2f0 R15: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: gmain           S    0  2036      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? inotify_poll+0x4c/0x60
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? eventfd_ctx_read+0xa4/0x1b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __might_fault+0x39/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7fc0d015f54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007fc0b7f76af0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 000055c316192070 RCX: 00007fc0d015f54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 00007fc0b00008c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007fc0b00008c0 R08: 0000000000000002 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 000055c3161ae8a0 R11: 0000000000000293 R12: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007fc0ca6ad2f0 R15: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: gdbus           S    0  2037      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? _raw_spin_unlock_irqrestore+0x4e/0x70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? sock_def_readable+0xb2/0x2a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? sock_def_readable+0xcf/0x2a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? unix_stream_sendmsg+0x385/0x3b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? _raw_spin_unlock_irq+0x27/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7fc0d015f54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007fc0b7104ae0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 000055c3161a5510 RCX: 00007fc0d015f54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 00007fc0ac0010c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007fc0ac0010c0 R08: 0000000000000002 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 000055c31618d280 R11: 0000000000000293 R12: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007fc0ca6ad2f0 R15: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: gvfsd-metadata  S    0  2042      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kmem_cache_free+0x259/0x2c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? alloc_set_pte+0x463/0x530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? reacquire_held_locks+0x67/0x170
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? reacquire_held_locks+0x67/0x170
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? alloc_set_pte+0x463/0x530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? filemap_map_pages+0x238/0x440
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __handle_mm_fault+0xb07/0xfb0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f77b11d054d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007ffc7fbbe190 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 0000555953b8d250 RCX: 00007f77b11d054d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 0000555953b9dea0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 0000555953b9dea0 R08: 0000000000000001 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 0000555953b8d420 R11: 0000000000000293 R12: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007f77b19122f0 R15: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: gmain           S    0  2046      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? eventfd_ctx_read+0xa4/0x1b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __might_fault+0x39/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f77b11d054d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007f77a8f5cdb0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 0000555953b96d30 RCX: 00007f77b11d054d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007f77a40008e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007f77a40008e0 R08: 0000000000000001 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 0000555953b8d600 R11: 0000000000000293 R12: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007f77b19122f0 R15: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: gdbus           S    0  2047      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? _raw_spin_unlock_irqrestore+0x4e/0x70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? sock_def_readable+0xb2/0x2a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? sock_def_readable+0xcf/0x2a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? eventfd_ctx_read+0xa4/0x1b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __might_fault+0x39/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f77b11d054d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007f77a3ffeda0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 0000555953b974f0 RCX: 00007f77b11d054d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 00007f779c0010c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007f779c0010c0 R08: 0000000000000002 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 0000555953b8d680 R11: 0000000000000293 R12: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007f77b19122f0 R15: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: evolution-calen S    0  2062      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __lock_acquire+0x28d/0x1520
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __lock_acquire+0x28d/0x1520
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? eventfd_ctx_read+0xa4/0x1b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __might_fault+0x39/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f31efa9a54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007ffcb07e1150 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 0000556ff50968e0 RCX: 00007f31efa9a54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 0000556ff50aa6a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 0000556ff50aa6a0 R08: 0000000000000001 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 0000556ff5096c20 R11: 0000000000000293 R12: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007f31eddb32f0 R15: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: gmain           S    0  2070      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? inotify_poll+0x4c/0x60
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? _raw_spin_unlock_irq+0x27/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? finish_task_switch+0x9c/0x220
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? finish_task_switch+0x60/0x220
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? futex_wake+0x7c/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f31efa9a54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007f31dc08aaf0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 0000556ff5096ab0 RCX: 00007f31efa9a54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 00007f31d40008c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007f31d40008c0 R08: 0000000000000002 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 0000556ff50a0e00 R11: 0000000000000293 R12: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007f31eddb32f0 R15: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: gdbus           S    0  2071      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? update_curr+0xfc/0x2e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? eventfd_ctx_read+0xa4/0x1b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __might_fault+0x39/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f31efa9a54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007f31db218ae0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 0000556ff50b09b0 RCX: 00007f31efa9a54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 00007f31cc0010c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007f31cc0010c0 R08: 0000000000000002 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 0000556ff50a0ba0 R11: 0000000000000293 R12: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007f31eddb32f0 R15: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: dconf worker    S    0  2072      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? _raw_spin_unlock_irq+0x27/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? finish_task_switch+0x9c/0x220
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? finish_task_switch+0x60/0x220
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? alloc_set_pte+0x463/0x530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? reacquire_held_locks+0x67/0x170
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? reacquire_held_locks+0x67/0x170
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? alloc_set_pte+0x463/0x530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? filemap_map_pages+0x238/0x440
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __handle_mm_fault+0xb07/0xfb0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f31efa9a54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007f31cb7c3af0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 0000556ff50c38b0 RCX: 00007f31efa9a54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007f31c40010c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007f31c40010c0 R08: 0000000000000001 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 0000556ff50bfd80 R11: 0000000000000293 R12: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007f31eddb32f0 R15: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: evolution-calen S    0  2073      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? update_load_avg+0x45f/0x5c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? try_to_wake_up+0x45/0x530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? try_to_wake_up+0x45/0x530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __wake_up_common+0x6e/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f31efa9a54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007f31cafc2ab0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 0000556ff50e1170 RCX: 00007f31efa9a54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007f31bc069e30
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007f31bc069e30 R08: 0000000000000001 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 0000556ff50bfe40 R11: 0000000000000293 R12: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007f31eddb32f0 R15: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: evolution-calen S    0  2076   2062 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __pollwait+0x79/0xe0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? eventfd_ctx_read+0xa4/0x1b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? _raw_spin_unlock_irq+0x27/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f666e0eb54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007ffde08182c0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 0000562aa31e16c0 RCX: 00007f666e0eb54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 0000562aa3440730
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 0000562aa3440730 R08: 0000000000000002 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 0000562aa3472240 R11: 0000000000000293 R12: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007f6667cb52f0 R15: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: dconf worker    S    0  2077   2062 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? update_curr+0xfc/0x2e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? try_to_wake_up+0x45/0x530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? eventfd_ctx_read+0xa4/0x1b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __might_fault+0x39/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f666e0eb54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007f6655d7faf0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 0000562aa343e240 RCX: 00007f666e0eb54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007f66500010e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007f66500010e0 R08: 0000000000000001 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 0000562aa343e860 R11: 0000000000000293 R12: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007f6667cb52f0 R15: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: evolution-calen S    0  2078   2062 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? update_load_avg+0x45f/0x5c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? try_to_wake_up+0x45/0x530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? try_to_wake_up+0x45/0x530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __wake_up_common+0x6e/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f666e0eb54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007f665557eab0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 0000562aa343f800 RCX: 00007f666e0eb54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007f664806f8b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007f664806f8b0 R08: 0000000000000001 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 0000562aa343e8e0 R11: 0000000000000293 R12: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007f6667cb52f0 R15: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: gmain           S    0  2079   2062 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? find_busiest_group+0x35/0x4a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? eventfd_ctx_read+0xa4/0x1b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __might_fault+0x39/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f666e0eb54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007f6654d7daf0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 00007f6650012c00 RCX: 00007f666e0eb54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007f664c0008c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007f664c0008c0 R08: 0000000000000001 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00007f6650001280 R11: 0000000000000293 R12: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007f6667cb52f0 R15: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: gdbus           S    0  2080   2062 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? update_load_avg+0x45f/0x5c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? eventfd_ctx_read+0xa4/0x1b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __might_fault+0x39/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f666e0eb54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007f6647ffeae0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 00007f6650013410 RCX: 00007f666e0eb54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 00007f66400010c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007f66400010c0 R08: 0000000000000003 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00007f6650001300 R11: 0000000000000293 R12: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007f6667cb52f0 R15: 0000000000000003
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: pool            S    0  2083   2062 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  futex_wait_queue_me+0xd5/0x160
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  futex_wait+0x10d/0x240
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_futex+0x2c6/0xaf0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_futex+0x6b/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f666e0f1219
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007f663d02caf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f666e0f1219
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 0000000000000001 RSI: 0000000000000080 RDI: 0000562aa3451a50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 0000562aa3451a40 R08: 0000000000000000 R09: 0000562aa3451a58
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 0000000000000000 R11: 0000000000000246 R12: 0000562aa3451a50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 0000000000000001 R14: 0000562aa3451a48 R15: 00007f663d02d9c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: evolution-calen S    0  2084   2062 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __update_load_avg_se.isra.31+0x127/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? update_load_avg+0x45f/0x5c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? try_to_wake_up+0x45/0x530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? try_to_wake_up+0x45/0x530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __wake_up_common+0x6e/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f666e0eb54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007f6637ffead0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 0000562aa346bb70 RCX: 00007f666e0eb54d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007f662c0010e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007f662c0010e0 R08: 0000000000000001 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 0000562aa343f480 R11: 0000000000000293 R12: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007f6667cb52f0 R15: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: evolution-addre S    0  2086      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? update_load_avg+0x45f/0x5c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? try_to_wake_up+0x45/0x530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? eventfd_ctx_read+0xa4/0x1b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7fc167c7854d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007ffd95bfbc20 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 00005642921eb2d0 RCX: 00007fc167c7854d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 0000564292216ef0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 0000564292216ef0 R08: 0000000000000001 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00005642921eb620 R11: 0000000000000293 R12: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007fc161f7d2f0 R15: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: gmain           S    0  2090      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? inotify_poll+0x4c/0x60
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? _raw_spin_unlock_irq+0x27/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? finish_task_switch+0x9c/0x220
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? finish_task_switch+0x60/0x220
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? futex_wake+0x7c/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7fc167c7854d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007fc150254af0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 00005642921eb480 RCX: 00007fc167c7854d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 00007fc1480008c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007fc1480008c0 R08: 0000000000000002 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00005642921f5200 R11: 0000000000000293 R12: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007fc161f7d2f0 R15: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: gdbus           S    0  2091      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? update_curr+0xfc/0x2e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? eventfd_ctx_read+0xa4/0x1b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __might_fault+0x39/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7fc167c7854d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007fc14f3e2ae0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 0000564292204ff0 RCX: 00007fc167c7854d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 00007fc1400010c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007fc1400010c0 R08: 0000000000000002 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00005642921f4fa0 R11: 0000000000000293 R12: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007fc161f7d2f0 R15: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: dconf worker    S    0  2098      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? alloc_set_pte+0x463/0x530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? reacquire_held_locks+0x67/0x170
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? reacquire_held_locks+0x67/0x170
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? alloc_set_pte+0x463/0x530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? filemap_map_pages+0x238/0x440
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __handle_mm_fault+0xb07/0xfb0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7fc167c7854d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007fc14660faf0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 0000564292214970 RCX: 00007fc167c7854d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007fc1340010c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007fc1340010c0 R08: 0000000000000001 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 0000564292215200 R11: 0000000000000293 R12: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007fc161f7d2f0 R15: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: evolution-addre S    0  2099      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? update_curr+0xfc/0x2e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? try_to_wake_up+0x45/0x530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? try_to_wake_up+0x45/0x530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __wake_up_common+0x6e/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7fc167c7854d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007fc145e0eab0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 0000564292214150 RCX: 00007fc167c7854d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007fc13c072b10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007fc13c072b10 R08: 0000000000000001 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 0000564292215280 R11: 0000000000000293 R12: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007fc161f7d2f0 R15: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: evolution-calen S    0  2089   2062 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __pollwait+0x79/0xe0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? eventfd_ctx_read+0xa4/0x1b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? _raw_spin_unlock_irq+0x27/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7faf278f654d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007ffe8d804540 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 000056529dfcf6c0 RCX: 00007faf278f654d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 000056529e229fb0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 000056529e229fb0 R08: 0000000000000002 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00007faeec002a40 R11: 0000000000000293 R12: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007faf214c02f0 R15: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: dconf worker    S    0  2093   2062 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? _raw_spin_unlock_irq+0x27/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? finish_task_switch+0x9c/0x220
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? finish_task_switch+0x60/0x220
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? alloc_set_pte+0x463/0x530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? reacquire_held_locks+0x67/0x170
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? eventfd_ctx_read+0xa4/0x1b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? _raw_spin_unlock_irq+0x27/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7faf278f654d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007faf0f58aaf0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 000056529e22c240 RCX: 00007faf278f654d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007faf000010c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007faf000010c0 R08: 0000000000000001 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 000056529e22c860 R11: 0000000000000293 R12: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007faf214c02f0 R15: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: evolution-calen S    0  2094   2062 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? update_load_avg+0x45f/0x5c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? try_to_wake_up+0x45/0x530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? try_to_wake_up+0x45/0x530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __wake_up_common+0x6e/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7faf278f654d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007faf0ed89ab0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 000056529e22d800 RCX: 00007faf278f654d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007faf08085f10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007faf08085f10 R08: 0000000000000001 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 000056529e22c8e0 R11: 0000000000000293 R12: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007faf214c02f0 R15: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: gmain           S    0  2095   2062 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? eventfd_ctx_read+0xa4/0x1b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __might_fault+0x39/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7faf278f654d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007faf0e588af0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 00007faf08015070 RCX: 00007faf278f654d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007faf040008c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007faf040008c0 R08: 0000000000000001 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00007faf08001280 R11: 0000000000000293 R12: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007faf214c02f0 R15: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: gdbus           S    0  2096   2062 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? update_curr+0xfc/0x2e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? eventfd_ctx_read+0xa4/0x1b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __might_fault+0x39/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7faf278f654d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007faf0dd87ae0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 00007faf080158a0 RCX: 00007faf278f654d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 00007faef80010c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007faef80010c0 R08: 0000000000000003 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00007faf08001300 R11: 0000000000000293 R12: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007faf214c02f0 R15: 0000000000000003
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: btserver        S    0  2111   1804 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0xee/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __hrtimer_init+0x90/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? release_sock+0x19/0xb0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? reacquire_held_locks+0x67/0x170
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? reacquire_held_locks+0x67/0x170
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? release_sock+0x19/0xb0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0x5d/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0x5d/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7fd785b56530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007ffcbce4b118 EFLAGS: 00000246 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fd785b56530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000000000c8 RSI: 0000000000000010 RDI: 0000000001bf9f00
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007ffcbce4f940 R08: 00007ffcbce4b33f R09: 00007ffcbce4b100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00007ffcbce4b100 R11: 0000000000000246 R12: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 0000000000847205 R14: 000000000084720d R15: 000000000084766d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: evolution-addre S    0  2112   2086 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __pollwait+0x79/0xe0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? eventfd_ctx_read+0xa4/0x1b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? _raw_spin_unlock_irq+0x27/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f9f41fa154d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007fffa50af6e0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 00005584f149c6d0 RCX: 00007f9f41fa154d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 00005584f14b0e00
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00005584f14b0e00 R08: 0000000000000002 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00007f9f180017a0 R11: 0000000000000293 R12: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007f9f3b7ad2f0 R15: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: gmain           S    0  2127   2086 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? eventfd_ctx_read+0xa4/0x1b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __might_fault+0x39/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f9f41fa154d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007f9f29a84af0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 00005584f14a0f50 RCX: 00007f9f41fa154d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007f9f240008e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007f9f240008e0 R08: 0000000000000001 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00005584f149bfa0 R11: 0000000000000293 R12: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007f9f3b7ad2f0 R15: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: gdbus           S    0  2129   2086 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __pollwait+0x79/0xe0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? sock_def_readable+0xb2/0x2a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? sock_def_readable+0xcf/0x2a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? _raw_spin_unlock_irq+0x27/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f9f41fa154d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007f9f23ffeae0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 00007f9f1c00f1e0 RCX: 00007f9f41fa154d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000003 RDI: 00007f9f180010c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007f9f180010c0 R08: 0000000000000003 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00005584f14bad40 R11: 0000000000000293 R12: 0000000000000003
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007f9f3b7ad2f0 R15: 0000000000000003
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: dconf worker    S    0  2130   2086 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? update_load_avg+0x45f/0x5c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? alloc_set_pte+0x463/0x530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? reacquire_held_locks+0x67/0x170
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? reacquire_held_locks+0x67/0x170
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? alloc_set_pte+0x463/0x530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? filemap_map_pages+0x238/0x440
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __handle_mm_fault+0xb07/0xfb0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f9f41fa154d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007f9f28875af0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 00005584f14a55b0 RCX: 00007f9f41fa154d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007f9f100010c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007f9f100010c0 R08: 0000000000000001 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00005584f14ace00 R11: 0000000000000293 R12: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007f9f3b7ad2f0 R15: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: evolution-addre S    0  2131   2086 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __update_load_avg_se.isra.31+0x127/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __update_load_avg_se.isra.31+0x127/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? update_load_avg+0x45f/0x5c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? futex_wake+0x7c/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f9f41fa154d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007f9f237fdab0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 00005584f14adf40 RCX: 00007f9f41fa154d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007f9f140746b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007f9f140746b0 R08: 0000000000000001 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00005584f14ace80 R11: 0000000000000293 R12: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007f9f3b7ad2f0 R15: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: pipe_helper     S    0  2133   2111 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0xee/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __hrtimer_init+0x90/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_select+0x7f9/0x950
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __lock_acquire+0x28d/0x1520
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __might_fault+0x39/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  core_sys_select+0x263/0x430
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? core_sys_select+0x263/0x430
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? poll_select_set_timeout+0x50/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? ktime_get_ts64+0xa8/0x170
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_select+0xa6/0xe0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f2c818cc303
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007ffd9476ab78 EFLAGS: 00000246 ORIG_RAX: 0000000000000017
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 00000000033719d0 RCX: 00007f2c818cc303
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00007ffd9476ac30 RSI: 00007ffd9476acb0 RDI: 0000000000000006
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007ffd9476afa0 R08: 00007ffd9476ab90 R09: 0000000000000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00007ffd9476abb0 R11: 0000000000000246 R12: 0000000000403b70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00007ffd9476b080 R14: 0000000000000000 R15: 0000000000000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: gnuserver       S    0  2168   2111 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0xee/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __hrtimer_init+0x90/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kfree_skbmem+0x54/0x60
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? rcu_read_lock_sched_held+0x6d/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kmem_cache_free+0x259/0x2c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __release_sock+0xc9/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? reacquire_held_locks+0x67/0x170
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? reacquire_held_locks+0x67/0x170
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __release_sock+0xc9/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? poll_select_set_timeout+0x50/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? ktime_get_ts64+0xa8/0x170
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0x5d/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0x5d/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f26887e6530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007ffdf0def628 EFLAGS: 00000246 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 00000000006cc120 RCX: 00007f26887e6530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 000000000000e43d RSI: 0000000000000003 RDI: 00000000006a4ac0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007ffdf0def760 R08: 0000000000000000 R09: 00007ffdf0def610
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00007ffdf0def610 R11: 0000000000000246 R12: 0000000000000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 0000015f07aa647d R14: 00007ffdf0def6f0 R15: 000000000000e43d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: parse-iw-event. S    0  2315      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  pipe_wait+0x62/0xa0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? wait_woken+0x90/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  pipe_read+0x248/0x340
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __vfs_read+0xc9/0x130
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  vfs_read+0xa0/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_read+0x44/0xa0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7fed8203ed80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007ffe8ad6c6f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fed8203ed80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 0000000000002000 RSI: 000000000162b860 RDI: 0000000000000004
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 0000000000002000 R08: 000000000160ba40 R09: fffffffffffe22c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 0000000000000000 R11: 0000000000000246 R12: 000000000162b860
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000015e7010 R14: 0000000000000004 R15: 000000000162b6a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: iw              S    0  2316   2315 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_timeout+0x263/0x580
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __skb_wait_for_more_packets+0xe1/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __skb_wait_for_more_packets+0xe1/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __sk_queue_drop_skb+0xb0/0xb0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __skb_recv_datagram+0x5a/0xb0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  skb_recv_datagram+0x2d/0x30
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  netlink_recvmsg+0x49/0x3f0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? import_iovec+0x2b/0xc0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? copy_msghdr_from_user+0xc1/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  sock_recvmsg+0x38/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ___sys_recvmsg+0xe9/0x230
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __sys_recvmsg+0x3d/0x70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __sys_recvmsg+0x3d/0x70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_recvmsg+0xd/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f28677e6030
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007ffe8eeeac28 EFLAGS: 00000246 ORIG_RAX: 000000000000002f
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f28677e6030
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 0000000000000000 RSI: 00007ffe8eeeac50 RDI: 0000000000000004
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00000000025ff100 R08: 00000000025ff150 R09: 0000000000000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00000000025ff310 R11: 0000000000000246 R12: 00007ffe8eeeac50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00007ffe8eeead68 R14: 00007ffe8eeead60 R15: 00007f2867aba430
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: obexd           S    0  2324      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __pollwait+0x79/0xe0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? sock_def_readable+0xb2/0x2a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? sock_def_readable+0xcf/0x2a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __might_fault+0x39/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f2b96fd7530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007ffd94f0cba8 EFLAGS: 00000246 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 000056194139b410 RCX: 00007f2b96fd7530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000004 RDI: 00005619413a02a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00005619413a02a0 R08: 0000000000000004 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 000056194139bd80 R11: 0000000000000246 R12: 0000000000000004
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00000000ffffffff R14: 00007f2b974fe2f0 R15: 0000000000000004
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: sshd            S    0  2332   1343 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? add_wait_queue+0x3e/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __pollwait+0x79/0xe0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __lock_acquire+0x28d/0x1520
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? dentry_free+0x44/0x70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0xc5/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f2f8aa47530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007ffe2ac6e718 EFLAGS: 00000246 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 00007ffe2ac6e770 RCX: 00007f2f8aa47530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007ffe2ac6e770
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 000055b64c395120 R08: 000055b64d077360 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 0000000000000040 R11: 0000000000000246 R12: 000055b64d0576c8
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 000055b64d0576f0 R14: 0000000000000000 R15: 000055b64d0576c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: systemd         S    0  2334      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? ep_poll+0x2e1/0x3c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ep_poll+0x2f3/0x3c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? wake_up_q+0x70/0x70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_epoll_wait+0xcb/0xe0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7fc3cf1e16b3
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007fff4231bcf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e8
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 000056102ac71740 RCX: 00007fc3cf1e16b3
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 0000000000000009 RSI: 00007fff4231bd00 RDI: 0000000000000004
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007fff4231be80 R08: 63baf20d6aa80a4d R09: 0000000000000025
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00000000ffffffff R11: 0000000000000246 R12: 00007fff4231bd00
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 0000000000000001 R14: ffffffffffffffff R15: 0000000000000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: (sd-pam)        S    0  2335   2334 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? do_sigtimedwait+0x143/0x260
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? recalc_sigpending+0x15/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sigtimedwait+0x172/0x260
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SYSC_rt_sigtimedwait+0x7a/0xd0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? syscall_trace_enter+0x1bc/0x3b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __do_page_fault+0x2b9/0x510
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_rt_sigtimedwait+0x9/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f5b062e89e6
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007ffc252adb20 EFLAGS: 00000246 ORIG_RAX: 0000000000000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 0000000000000080 RCX: 00007f5b062e89e6
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00007ffc252adca0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007ffc252adbf8 R08: 00007ffc252adca0 R09: 0000000000000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000008000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00007ffc252adc00 R14: 000000000000091e R15: 00007ffc252adbf8
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: sshd            S    0  2340   2332 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_select+0x7f9/0x950
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __might_fault+0x39/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  core_sys_select+0x263/0x430
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? core_sys_select+0x263/0x430
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_select+0xa6/0xe0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f2f8aa49303
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007ffe2ac6e678 EFLAGS: 00000246 ORIG_RAX: 0000000000000017
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2f8aa49303
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 000055b64d0776c0 RSI: 000055b64d0584e0 RDI: 0000000000000011
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007ffe2ac6e718 R08: 0000000000000000 R09: 000000000000a100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00007ffe2ac6e720 R14: 000055b64c39e140 R15: 00007ffe2ac6e710
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: bash            S    0  2341   2340 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_wait+0x26e/0x340
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kernel_wait4+0x75/0x130
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? task_stopped_code+0x50/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SYSC_wait4+0x74/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? syscall_trace_enter+0x1bc/0x3b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_exit+0x22b/0x2d0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_wait4+0x9/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_wait4+0x9/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f945e5f573a
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007ffdd50a77c8 EFLAGS: 00000246 ORIG_RAX: 000000000000003d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 000000000000000a RCX: 00007f945e5f573a
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 000000000000000a RSI: 00007ffdd50a77f0 RDI: ffffffffffffffff
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00005607f4c3b300 R08: 00005607f4c3b320 R09: 0000000000000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 0000000000000001 R14: 0000000000000000 R15: 00005607f4d24080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: ath9k-hwrng     S    0  2642      2 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  add_hwgenerator_randomness+0xa9/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? wait_woken+0x90/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ath9k_rng_kthread+0x17c/0x280 [ath9k]
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? ath9k_deinit_wow+0x30/0x30 [ath9k]
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: hostapd         S    0  2805      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0xee/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __hrtimer_init+0x90/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_select+0x7f9/0x950
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  core_sys_select+0x263/0x430
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? core_sys_select+0x263/0x430
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? poll_select_set_timeout+0x50/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? ktime_get_ts64+0xa8/0x170
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_select+0xa6/0xe0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f70736ad303
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007ffc3b90ab68 EFLAGS: 00000246 ORIG_RAX: 0000000000000017
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 00000000009c82b0 RCX: 00007f70736ad303
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000009cd9d0 RSI: 00000000009cd600 RDI: 0000000000000010
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007ffc3b90abe0 R08: 00007ffc3b90ab90 R09: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00000000009cda60 R11: 0000000000000246 R12: 0000000000408350
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00007ffc3b90ae70 R14: 0000000000000000 R15: 0000000000000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: dhclient        S    0  3065      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0xee/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __hrtimer_init+0x90/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_select+0x7f9/0x950
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? free_one_page+0x14a/0x330
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? _raw_spin_unlock+0x22/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __lock_acquire+0x28d/0x1520
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __might_fault+0x39/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  core_sys_select+0x263/0x430
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? core_sys_select+0x263/0x430
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? poll_select_set_timeout+0x50/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? ktime_get_ts64+0xa8/0x170
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_select+0xa6/0xe0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7fb1cd080303
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007fffc420b898 EFLAGS: 00000246 ORIG_RAX: 0000000000000017
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 00007fb1cdd87010 RCX: 00007fb1cd080303
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00007fb1cdd89190 RSI: 00007fb1cdd89090 RDI: 0000000000000016
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007fffc420b8e8 R08: 00007fffc420b8f0 R09: 00007fffc420b820
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 0000000000000000 R11: 0000000000000246 R12: 00007fffc420b8f0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00007fffc420bce0 R14: 0000000000000000 R15: 0000000000000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: dhcpd           S    0  3350      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0xee/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __hrtimer_init+0x90/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_select+0x7f9/0x950
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __lock_acquire+0x28d/0x1520
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __might_fault+0x39/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  core_sys_select+0x263/0x430
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? core_sys_select+0x263/0x430
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? poll_select_set_timeout+0x50/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? ktime_get_ts64+0xa8/0x170
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_select+0xa6/0xe0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7faf92ab9303
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007ffddd898348 EFLAGS: 00000246 ORIG_RAX: 0000000000000017
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 00007faf937c0010 RCX: 00007faf92ab9303
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00007faf937c2190 RSI: 00007faf937c2090 RDI: 0000000000000016
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007ffddd898398 R08: 00007ffddd8983a0 R09: 00007ffddd8982d0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffddd8983a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00007ffddd8985d0 R14: 0000000000000000 R15: 0000000000000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: hostapd         S    0  3375      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0xee/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __hrtimer_init+0x90/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_select+0x7f9/0x950
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  core_sys_select+0x263/0x430
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? core_sys_select+0x263/0x430
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? poll_select_set_timeout+0x50/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? ktime_get_ts64+0xa8/0x170
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_select+0xa6/0xe0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f656f3f0303
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007ffd48616e48 EFLAGS: 00000246 ORIG_RAX: 0000000000000017
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 00000000017092b0 RCX: 00007f656f3f0303
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 000000000170f980 RSI: 0000000001715030 RDI: 0000000000000010
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007ffd48616ec0 R08: 00007ffd48616e70 R09: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 0000000001714b80 R11: 0000000000000246 R12: 0000000000408350
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00007ffd48617150 R14: 0000000000000000 R15: 0000000000000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: btserver        S    0  3442   2111 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0xee/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __hrtimer_init+0x90/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? import_iovec+0x2b/0xc0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? ___sys_sendmsg+0x11e/0x300
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? rcu_read_lock_sched_held+0x6d/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kfree+0x24d/0x2b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? ___sys_sendmsg+0x11e/0x300
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? poll_select_set_timeout+0x50/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? ktime_get_ts64+0xa8/0x170
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0x5d/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0x5d/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f42f6fa7530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007ffdf783d8e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 000000000045fda0 RCX: 00007f42f6fa7530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00000000000001e3 RSI: 0000000000000005 RDI: 0000000001bf9f00
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007ffdf7842110 R08: 00007ffdf783db0f R09: 00007ffdf783d8d0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00007ffdf783d8d0 R11: 0000000000000246 R12: 000000000297cfc0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 0000000000000036 R14: 00000000029d2b80 R15: 000000000084766d
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: wpa_supplicant  S    0  3472      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0xee/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __hrtimer_init+0x90/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? try_to_wake_up+0x45/0x530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_off+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? _raw_spin_unlock_irqrestore+0x3b/0x70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? try_to_wake_up+0x45/0x530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? poll_select_set_timeout+0x50/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? ktime_get_ts64+0xa8/0x170
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0x5d/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0x5d/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f22d1e1e530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007ffc4f555158 EFLAGS: 00000246 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f22d1e1e530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 0000000000001065 RSI: 0000000000000001 RDI: 0000000001c15460
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007ffc4f5551b0 R08: 0000000001c152a0 R09: 0000000000000037
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00007ffc4f555100 R11: 0000000000000246 R12: 0000000000409850
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00007ffc4f555380 R14: 0000000000000000 R15: 0000000000000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: parse-wpacli-ev S    0  3475      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  pipe_wait+0x62/0xa0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? wait_woken+0x90/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  pipe_read+0x248/0x340
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __vfs_read+0xc9/0x130
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  vfs_read+0xa0/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_read+0x44/0xa0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f86d73e5d80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007ffd2622c4e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f86d73e5d80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 0000000000002000 RSI: 0000000001b13f70 RDI: 0000000000000005
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 0000000000002000 R08: 0000000001a56c00 R09: 00007f86d6657b68
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 0000000000000000 R11: 0000000000000246 R12: 0000000001b13f70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 0000000001a17010 R14: 0000000000000005 R15: 0000000001a4b020
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: wpa_cli         S    0  3478   3475 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0xee/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __hrtimer_init+0x90/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_sys_poll+0x4e3/0x5e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __slab_free+0x99/0x310
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __slab_free+0x99/0x310
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __slab_free+0x99/0x310
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? poll_select_set_timeout+0x50/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? ktime_get_ts64+0xa8/0x170
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_poll+0x5d/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? SyS_poll+0x5d/0x110
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7f90f9c76530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007ffc2f1ab7b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000007
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f90f9c76530
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 0000000000001387 RSI: 0000000000000002 RDI: 00000000008af3e0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007ffc2f1ab810 R08: 00000000008af220 R09: 0000000000000037
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00007ffc2f1ab760 R11: 0000000000000246 R12: 0000000000402650
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00007ffc2f1ab950 R14: 0000000000000000 R15: 0000000000000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: dhcpd           S    0  3493      1 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range_clock+0x26c/0x280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? datagram_poll+0x24/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_hrtimeout_range+0xe/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  poll_schedule_timeout+0x4b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_select+0x7f9/0x950
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? compat_poll_select_copy_remaining+0x100/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __lock_acquire+0x28d/0x1520
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __might_fault+0x39/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  core_sys_select+0x263/0x430
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? core_sys_select+0x263/0x430
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on+0xd/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __getnstimeofday64+0x9a/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? getnstimeofday64+0x9/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __audit_syscall_entry+0xb2/0x100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_select+0xa6/0xe0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7ff9c57c9303
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007ffd49a04428 EFLAGS: 00000246 ORIG_RAX: 0000000000000017
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 00007ff9c64d0010 RCX: 00007ff9c57c9303
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 00007ff9c64d2190 RSI: 00007ff9c64d2090 RDI: 0000000000000016
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 00007ffd49a04478 R08: 0000000000000000 R09: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00007ffd49a046b0 R14: 0000000000000000 R15: 0000000000000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kworker/u8:6    S    0  8000      2 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  worker_thread+0xc6/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? process_one_work+0x6a0/0x6a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kworker/1:0     S    0 10919      2 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  worker_thread+0xc6/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? process_one_work+0x6a0/0x6a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kworker/0:0     S    0 10921      2 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  worker_thread+0xc6/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? process_one_work+0x6a0/0x6a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kworker/u8:3    D    0 13363      2 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Workqueue: ath10k_wq ath10k_core_register_work [ath10k_core]
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? _raw_spin_unlock_irqrestore+0x4e/0x70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_timeout+0x224/0x580
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? call_timer_fn+0x370/0x370
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  msleep+0x34/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? msleep+0x34/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  napi_disable+0x55/0x70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ath10k_core_register_work+0x98/0xb00 [ath10k_core]
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  process_one_work+0x1ce/0x6a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  worker_thread+0x46/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? process_one_work+0x6a0/0x6a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kworker/2:0     S    0 21131      2 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  worker_thread+0xc6/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? process_one_work+0x6a0/0x6a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kworker/u8:2    S    0 21468      2 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  worker_thread+0xc6/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? process_one_work+0x6a0/0x6a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kworker/u8:1    S    0 28047      2 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  worker_thread+0xc6/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? process_one_work+0x6a0/0x6a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kworker/2:1     S    0 31442      2 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  worker_thread+0xc6/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? process_one_work+0x6a0/0x6a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kworker/0:2     S    0 31719      2 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  worker_thread+0xc6/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? process_one_work+0x6a0/0x6a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kworker/3:1     S    0 31720      2 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  worker_thread+0xc6/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? process_one_work+0x6a0/0x6a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: ath10k_wq       S    0 31797      2 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: ath10k_aux_wq   S    0 31798      2 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: ath10k_wq       S    0 31807      2 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: ath10k_aux_wq   S    0 31808      2 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  rescuer_thread+0x340/0x390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? worker_thread+0x400/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kworker/u8:4    S    0 31901      2 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  worker_thread+0xc6/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? process_one_work+0x6a0/0x6a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: rmmod           D    0 32491   2341 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule_timeout+0x263/0x580
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? lock_acquire+0xac/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? wait_for_completion+0xa7/0x120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? _raw_spin_unlock_irq+0x27/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? trace_hardirqs_on_caller+0x11f/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  wait_for_completion+0xaf/0x120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? wait_for_completion+0xaf/0x120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? wake_up_q+0x70/0x70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  flush_work+0x1fd/0x2d0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? flush_workqueue_prep_pwqs+0x1c0/0x1c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __cancel_work_timer+0x111/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  cancel_work_sync+0xb/0x10
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ath10k_core_unregister+0x14/0xa0 [ath10k_core]
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ath10k_pci_remove+0x2d/0x70 [ath10k_pci]
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  pci_device_remove+0x34/0xb0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  device_release_driver_internal+0x158/0x210
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  driver_detach+0x3b/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  bus_remove_driver+0x53/0xd0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  driver_unregister+0x27/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  pci_unregister_driver+0x24/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ath10k_pci_exit+0x10/0x6ee [ath10k_pci]
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_delete_module+0x1e1/0x2a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7ff4cd9855e7
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007ffdf7ef41d8 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 00007ffdf7ef4228 RCX: 00007ff4cd9855e7
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 000000000000000a RSI: 0000000000000800 RDI: 000056280c84d298
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 000056280c84d230 R08: 000000000000000a R09: 1999999999999999
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 00007ff4cd9f51a0 R11: 0000000000000206 R12: 00007ffdf7ef43f0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 00007ffdf7ef5599 R14: 0000000000000000 R15: 000056280c84d230
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: bash            R  running task        0   988   1404 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  sched_show_task+0xf8/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  show_state_filter+0xb4/0x190
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  sysrq_handle_showstate+0xb/0x20
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __handle_sysrq+0x121/0x200
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  write_sysrq_trigger+0x4c/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  proc_reg_write+0x3d/0x60
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __vfs_write+0x23/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? rcu_read_lock_sched_held+0x6d/0x80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? rcu_sync_lockdep_assert+0x2a/0x50
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? __sb_start_write+0xd2/0x1f0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? vfs_write+0x1a2/0x1c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  vfs_write+0xc5/0x1c0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? syscall_trace_enter+0x1bc/0x3b0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  SyS_write+0x44/0xa0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  entry_SYSCALL64_slow_path+0x25/0x25
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RIP: 0033:0x7fa0768321f0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RSP: 002b:00007ffdc8c0f7a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fa0768321f0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RDX: 0000000000000002 RSI: 000055a7738f1fc0 RDI: 0000000000000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: RBP: 000055a7738f1fc0 R08: 00007fa076afd760 R09: 00007fa077137700
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000002
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R13: 0000000000000001 R14: 00007fa076afc600 R15: 0000000000000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kworker/1:1     S    0  7390      2 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  worker_thread+0xc6/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? process_one_work+0x6a0/0x6a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: kworker/0:1     S    0  7391      2 0x00000080
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Call Trace:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  __schedule+0x407/0xb70
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  schedule+0x38/0x90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  worker_thread+0xc6/0x400
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  kthread+0x10f/0x150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? process_one_work+0x6a0/0x6a0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? kthread_create_on_node+0x40/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ? do_syscall_64+0x64/0x140
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  ret_from_fork+0x2a/0x40
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: Sched Debug Version: v0.11, 4.13.3+ #1
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: ktime                                   : 2439201.439542
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: sched_clk                               : 2439466.507396
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: cpu_clk                                 : 2439321.238085
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: jiffies                                 : 4297106498
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: sched_clock_stable()                    : 1
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: sysctl_sched
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .sysctl_sched_latency                    : 18.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .sysctl_sched_min_granularity            : 2.250000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .sysctl_sched_wakeup_granularity         : 3.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .sysctl_sched_child_runs_first           : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .sysctl_sched_features                   : 186171
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: cpu#0, 2494.544 MHz
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_running                    : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load                          : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_switches                   : 984434
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_load_updates               : 467583
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_uninterruptible            : -1074
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .next_balance                  : 4297.106501
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .curr->pid                     : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .clock                         : 2439320.831516
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .clock_task                    : 2439320.831516
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .cpu_load[0]                   : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .cpu_load[1]                   : 1
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .cpu_load[2]                   : 3
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .cpu_load[3]                   : 4
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .cpu_load[4]                   : 3
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .avg_idle                      : 1000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .max_idle_balance_cost         : 500000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   cfs_rq[0]:/autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .exec_clock                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .MIN_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .min_vruntime                  : 1087.364498
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .max_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread                        : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread0                       : -179315.562967
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_spread_over                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_running                    : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load                          : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load_avg                      : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .runnable_load_avg             : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .util_avg                      : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg_contrib           : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg                   : 1
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttled                     : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttle_count                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->exec_start                : 2439237.903109
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->vruntime                  : 180393.743476
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->sum_exec_runtime          : 1367.289807
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->load.weight               : 2
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   cfs_rq[0]:/autogroup-83
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .exec_clock                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .MIN_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .min_vruntime                  : 1844.526666
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .max_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread                        : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread0                       : -178558.400799
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_spread_over                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_running                    : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load                          : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load_avg                      : 29
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .runnable_load_avg             : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .util_avg                      : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg_contrib           : 29
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg                   : 84
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttled                     : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttle_count                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->exec_start                : 2439250.041141
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->vruntime                  : 180399.758590
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->sum_exec_runtime          : 29607.194142
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->load.weight               : 2
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   cfs_rq[0]:/autogroup-124
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .exec_clock                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .MIN_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .min_vruntime                  : 6.482776
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .max_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread                        : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread0                       : -180396.444689
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_spread_over                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_running                    : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load                          : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load_avg                      : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .runnable_load_avg             : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .util_avg                      : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg_contrib           : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg                   : 326
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttled                     : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttle_count                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->exec_start                : 2439046.949669
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->vruntime                  : 180393.664166
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->sum_exec_runtime          : 415.798157
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->load.weight               : 2
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   cfs_rq[0]:/autogroup-116
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .exec_clock                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .MIN_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .min_vruntime                  : 40.127890
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .max_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread                        : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread0                       : -180362.799575
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_spread_over                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_running                    : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load                          : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load_avg                      : 302
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .runnable_load_avg             : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .util_avg                      : 4
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg_contrib           : 302
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg                   : 302
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttled                     : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttle_count                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->exec_start                : 2439315.286925
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->vruntime                  : 180394.116533
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->sum_exec_runtime          : 2272.641673
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->load.weight               : 2
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.load_avg              : 83
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.util_avg              : 3
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   cfs_rq[0]:/autogroup-26
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .exec_clock                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .MIN_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .min_vruntime                  : 159.467393
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .max_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread                        : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread0                       : -180243.460072
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_spread_over                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_running                    : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load                          : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load_avg                      : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .runnable_load_avg             : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .util_avg                      : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg_contrib           : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg                   : 692
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttled                     : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttle_count                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->exec_start                : 2439270.643316
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->vruntime                  : 180399.678040
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->sum_exec_runtime          : 160.618313
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->load.weight               : 2
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   cfs_rq[0]:/
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .exec_clock                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .MIN_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .min_vruntime                  : 180402.927465
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .max_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread                        : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread0                       : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_spread_over                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_running                    : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load                          : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load_avg                      : 87
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .runnable_load_avg             : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .util_avg                      : 8
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg_contrib           : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg                   : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttled                     : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttle_count                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   rt_rq[0]:/user.slice/user-0.slice/session-3.scope
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_throttled                  : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_time                       : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_runtime                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   rt_rq[0]:/user.slice/user-0.slice/session-1.scope
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_throttled                  : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_time                       : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_runtime                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   rt_rq[0]:/init.scope
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_throttled                  : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_time                       : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_runtime                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   rt_rq[0]:/system.slice
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_throttled                  : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_time                       : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_runtime                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   rt_rq[0]:/user.slice/user-0.slice/user@0.service
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_throttled                  : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_time                       : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_runtime                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   rt_rq[0]:/user.slice/user-0.slice
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_throttled                  : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_time                       : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_runtime                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   rt_rq[0]:/user.slice
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_throttled                  : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_time                       : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_runtime                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   rt_rq[0]:/
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_throttled                  : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_time                       : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_runtime                    : 950.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   dl_rq[0]:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .dl_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .dl_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .dl_bw->bw                     : 996147
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .dl_bw->total_bw               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   runnable tasks:
                                                               task   PID         tree-key  switches  prio     wait-time             sum-exec        sum-sleep
                                                   ----------------------------------------------------------------------------------------------------------
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         systemd     1        37.083473      3007   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000      2882.050111         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /init.scope
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:    kworker/0:0H     4      1530.576679        11   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.116435         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:    mm_percpu_wq     6        24.876590         4   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.010729         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:     ksoftirqd/0     7    180393.934917     58929   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000      1212.639162         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:     rcu_preempt     8    180393.952629     67171   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000      1472.500775         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:     migration/0    11         0.000000      4755     0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        85.715433         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:      watchdog/0    12         0.000000       614     0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        10.745711         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         cpuhp/0    13      4485.191926        23   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         2.209986         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           netns    33       291.439463         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.000000         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:       writeback    40       311.436516         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.000000         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:            ksmd    42       311.440688         2   125
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.004172         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:      khugepaged    43    179988.203843       244   139
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        50.473706         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         kblockd    46       320.440683         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.000000         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         ata_sff    47       320.446527         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.005844         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:      devfreq_wq    50       329.446522         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.000000         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:      scsi_tmf_0   244       601.957517         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.020864         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:      scsi_tmf_1   246       617.006840         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.034795         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:       scsi_eh_2   247       626.057406         3   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.041224         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:       scsi_eh_5   253       635.662501         3   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.033596         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  dm_bufio_cache   260       658.205782         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.049267         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: qat_device_rese   261       664.229515         3   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.026820         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: qat_pf2vf_resp_   262       670.248873         3   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.022597         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   i915/signal:1   526         0.000000         2    98
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.020625         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:    kworker/0:1H   528    180004.379212      3063   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        44.391254         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:        kdmflush   618      2176.244097         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.015425         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         lvmetad   758        37.385512      2435   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       105.075262         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-31
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:          smartd   909        31.117390        53   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        39.993492         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-57
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  systemd-logind   910        19.432346       604   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        60.876097         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-58
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gmain   935         9.448698         4   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.119362         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-61
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         alsactl   923         4.331450        19   139
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         6.590380         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-68
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:        gssproxy   956        14.885867         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.004775         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-73
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:        gssproxy   957        11.924267         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.005382         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-73
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:        gssproxy   958        10.467697         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.009242         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-73
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:            xrdp  1333         4.153908        21   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        10.829842         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-85
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:             atd  1395         1.120174         8   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         5.206816         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-91
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:            Xvnc  1400      3163.742235     47859   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000      9338.924759         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:      llvmpipe-2  1418        47.006544         3   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.116931         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:          agetty  1405        -1.186609         8   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        12.805712         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-102
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1421       870.530784        68   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         8.424137         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1425        93.191616         3   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.037740         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1426       102.140496         2   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.019684         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1427       120.079693         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.010571         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1435       132.772214         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.006028         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1436       132.772174         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.005988         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1439       131.745859         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.008242         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1440       131.744173         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.006556         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1441       131.743628         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.006011         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1447       138.784951         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.012780         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1448       144.794665         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.009717         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1449       150.806923         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.012261         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1451      1087.364498     24197   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       954.729220         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1452       168.852753         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.011678         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1453       177.861827         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.009080         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1454       186.870821         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.009000         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1455       195.879130         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.008315         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1456       206.644412         2   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         1.765288         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1462       217.216571         2   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         1.572165         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:      kpktgend_0  1511    180393.948100     23291   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       597.158071         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:      llvmpipe-1  1560        88.276886         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.019140         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:     dbus-launch  1557        75.629414         8   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.632091         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gmain  1577        41.599786         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.059489         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gdbus  1578       165.583767        33   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         3.904843         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gmain  1595       110.010398         2   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.105727         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:    dconf worker  1609       160.153837        17   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         2.343812         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gmain  1613      3148.464623      2268   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       120.208406         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gmain  1642       129.206752         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.081314         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:            caja  1657      3145.436768      1867   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       453.402683         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: gvfs-udisks2-vo  1659      2484.850327        60   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        36.928638         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         polkitd  1666       115.298320       315   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       113.861504         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-99
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gdbus  1671       112.057579       170   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        19.144105         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-99
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gdbus  1681       290.213470       207   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         9.929290         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gmain  1725       634.689901         7   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.342451         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:    dconf worker  1745       586.262152        30   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         1.544943         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   mate-terminal  1699       731.898069       362   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       257.545796         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gmain  1718       634.704781         5   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.276671         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:    dconf worker  1772       538.962519        10   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         1.587753         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: gvfs-afc-volume  1721       218.102381        42   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        14.757880         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gdbus  1730       218.244315        38   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         3.328861         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gmain  1738       177.694081         2   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.077422         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:      goa-daemon  1764       234.578155         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.044942         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:            bash  1762        45.354586        93   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        60.683460         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gdbus  1783       256.470014        17   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         1.936781         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gdbus  2020       381.002355        43   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         3.293872         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:    dconf worker  2059       388.329091        16   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.588673         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gdbus  2029       472.973056        53   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         4.862846         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gdbus  1958       361.243835        25   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         2.693874         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  gvfsd-metadata  2042       977.229710        42   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        10.405060         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gdbus  2071       896.544688       101   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        10.716356         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: evolution-calen  2073       896.454053        14   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        24.794399         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: evolution-addre  2086       897.361311        80   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       177.463856         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gdbus  2091       896.528732        59   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         6.516990         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: evolution-addre  2099       896.461406        21   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        43.033031         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:            sshd  2332         2.696909        70   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        32.831364         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /user.slice/user-0.slice/session-1.scope
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:     ath9k-hwrng  2642     31630.271576         6   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         5.022097         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         hostapd  2805        40.127890    140407   102
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000      8330.272232         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-116
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:        dhclient  3065        -1.155720        84   103
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         7.624084         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:        btserver  3442      1835.586997      7333   105
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000      2186.884773         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-83
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  wpa_supplicant  3472         0.913641       709   102
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        38.475327         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-126
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           dhcpd  3493         0.998461        53   103
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        12.444908         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-128
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:    kworker/u8:6  8000    167367.055461     35059   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       623.214079         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:     kworker/0:0 10921    174950.855924     13318   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       360.640179         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:     kworker/0:2 31719    174950.825955        12   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.212584         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:       ath10k_wq 31797    144148.263307         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.016501         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:     kworker/0:1  7391    180393.687316       924   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        26.435769         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: cpu#1, 2494.544 MHz
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_running                    : 1
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load                          : 1048576
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_switches                   : 885062
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_load_updates               : 438770
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_uninterruptible            : 207
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .next_balance                  : 4297.106576
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .curr->pid                     : 736
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .clock                         : 2439322.803043
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .clock_task                    : 2439322.803043
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .cpu_load[0]                   : 714
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .cpu_load[1]                   : 708
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .cpu_load[2]                   : 694
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .cpu_load[3]                   : 664
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .cpu_load[4]                   : 590
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .avg_idle                      : 792998
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .max_idle_balance_cost         : 500000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   cfs_rq[1]:/autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .exec_clock                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .MIN_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .min_vruntime                  : 870.610141
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .max_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread                        : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread0                       : -179532.317324
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_spread_over                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_running                    : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load                          : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load_avg                      : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .runnable_load_avg             : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .util_avg                      : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg_contrib           : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg                   : 1
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttled                     : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttle_count                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->exec_start                : 2439188.816413
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->vruntime                  : 242162.331977
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->sum_exec_runtime          : 1209.411891
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->load.weight               : 2
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   cfs_rq[1]:/autogroup-116
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .exec_clock                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .MIN_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .min_vruntime                  : 38.730817
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .max_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread                        : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread0                       : -180364.196648
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_spread_over                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_running                    : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load                          : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load_avg                      : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .runnable_load_avg             : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .util_avg                      : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg_contrib           : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg                   : 280
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttled                     : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttle_count                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->exec_start                : 2439253.879565
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->vruntime                  : 242163.505150
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->sum_exec_runtime          : 2196.241678
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->load.weight               : 2
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   cfs_rq[1]:/autogroup-59
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .exec_clock                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .MIN_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .min_vruntime                  : 45.425966
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .max_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread                        : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread0                       : -180357.501499
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_spread_over                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_running                    : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load                          : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load_avg                      : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .runnable_load_avg             : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .util_avg                      : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg_contrib           : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg                   : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttled                     : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttle_count                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->exec_start                : 2439089.871688
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->vruntime                  : 242162.242087
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->sum_exec_runtime          : 47.021804
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->load.weight               : 2
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   cfs_rq[1]:/autogroup-26
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .exec_clock                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .MIN_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .min_vruntime                  : 429.031056
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .max_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread                        : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread0                       : -179973.896409
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_spread_over                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_running                    : 1
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load                          : 1048576
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load_avg                      : 712
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .runnable_load_avg             : 712
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .util_avg                      : 707
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg_contrib           : 705
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg                   : 705
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttled                     : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttle_count                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->exec_start                : 2439322.803043
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->vruntime                  : 242213.818396
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->sum_exec_runtime          : 430.237252
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->load.weight               : 1048576
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.load_avg              : 711
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.util_avg              : 707
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   cfs_rq[1]:/
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .exec_clock                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .MIN_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .min_vruntime                  : 242213.818396
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .max_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread                        : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread0                       : 61810.890931
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_spread_over                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_running                    : 1
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load                          : 1048576
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load_avg                      : 1281
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .runnable_load_avg             : 714
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .util_avg                      : 713
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg_contrib           : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg                   : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttled                     : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttle_count                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   rt_rq[1]:/user.slice/user-0.slice/session-3.scope
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_throttled                  : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_time                       : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_runtime                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   rt_rq[1]:/user.slice/user-0.slice/session-1.scope
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_throttled                  : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_time                       : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_runtime                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   rt_rq[1]:/init.scope
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_throttled                  : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_time                       : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_runtime                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   rt_rq[1]:/system.slice
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_throttled                  : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_time                       : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_runtime                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   rt_rq[1]:/user.slice/user-0.slice/user@0.service
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_throttled                  : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_time                       : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_runtime                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   rt_rq[1]:/user.slice/user-0.slice
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_throttled                  : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_time                       : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_runtime                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   rt_rq[1]:/user.slice
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_throttled                  : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_time                       : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_runtime                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   rt_rq[1]:/
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_throttled                  : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_time                       : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_runtime                    : 950.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   dl_rq[1]:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .dl_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .dl_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .dl_bw->bw                     : 996147
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .dl_bw->total_bw               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   runnable tasks:
                                                               task   PID         tree-key  switches  prio     wait-time             sum-exec        sum-sleep
                                                   ----------------------------------------------------------------------------------------------------------
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:        kthreadd     2    237247.830600       367   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        10.252458         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         cpuhp/1    14      5051.718022        24   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.591200         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:      watchdog/1    15        -2.962423       614     0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        12.573087         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:     migration/1    16         0.000000      4907     0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        83.306301         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:     ksoftirqd/1    17    242162.355817      6592   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       196.489617         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:    kworker/1:0H    19      1838.217683        12   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.096925         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:      kcompactd0    41        30.785576         2   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.003794         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:     edac-poller    49        39.791044         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.005473         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:       watchdogd    51        48.794868         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.003829         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         kauditd   147    237247.778501       221   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       625.934349         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:        pencrypt   176       392.689589         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.013666         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:        pdecrypt   177       401.697929         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.010655         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:     kworker/1:2   349    242170.581291     28472   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000      6039.571320         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   i915/signal:0   525         0.000000         2    98
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.104063         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:    kworker/1:1H   529    242169.400521      1117   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        16.157095         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:        kdmflush   607      2600.021790         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.054457         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: R
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: systemd-journal   736       430.031418      1553   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       827.248075         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-26
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:            rngd   911        45.425966     22144   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       297.890811         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-59
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gdbus   949         3.628598        30   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         2.100769         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-61
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           crond  1397         3.828187        54   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         9.457066         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-93
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:      llvmpipe-1  1417        72.779255         3   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.112672         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         radiusd  1410        15.661132        25   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        16.809713         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-96
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         radiusd  1413         6.501457        12   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.296692         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-96
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1422       860.820570       254   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         9.896928         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1465        90.228636         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.016068         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:      kpktgend_1  1512    242162.333908     23291   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       570.759691         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:    mate-session  1554      3033.070310       626   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       265.094464         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:      llvmpipe-0  1559       105.202774         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.032002         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:      llvmpipe-3  1562       114.220550         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.017782         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:     dbus-daemon  1558       787.103848      1375   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       221.699405         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: at-spi-bus-laun  1564        11.344757        67   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        11.319204         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: at-spi2-registr  1571       653.926980       139   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        18.325190         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   dconf-service  1586       330.003476        50   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        20.613269         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gdbus  1588       325.354331        31   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         2.606836         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: mate-settings-d  1600      3439.036842      3606   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000      1917.848445         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gmain  1606      3427.461702      1646   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        70.567597         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:    dconf worker  1616       227.728945         5   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.242274         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gmain  1610       193.878406         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.040133         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:      mate-panel  1612      1302.499969      1617   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       372.316374         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:    dconf worker  1615       980.603886       213   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        11.386298         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gvfsd  1618       526.921100       118   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        23.717478         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gmain  1619        61.481220         2   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.074560         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:      gvfsd-fuse  1629        65.899860        13   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         5.312610         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:      gvfsd-fuse  1639      1768.243302      1244   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        78.842446         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:      gvfsd-fuse  1641      1767.754270      1208   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        75.655830         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gdbus  1644       207.617074        46   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         2.952100         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gdbus  1717       837.301192       237   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        21.784760         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:     wnck-applet  1670       654.467335       839   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       133.457917         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gmain  1679       120.766619         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.075414         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:     abrt-applet  1672      2910.251432       391   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       143.595221         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gmain  1702       457.754779         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.086983         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gmain  1759       683.770383         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.070172         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gdbus  1760      1299.746512        37   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         3.148037         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:    dconf worker  1778      1300.137355        25   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         1.585942         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gdbus  1722       716.125230        68   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         4.949457         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:    dconf worker  1723       715.937136        36   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         3.078816         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: gvfs-gphoto2-vo  1705       213.010559        38   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        17.005085         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gmain  1707       147.330853         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.068330         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gdbus  1709       213.245674        44   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         3.270241         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: gvfs-mtp-volume  1711       213.428847        34   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        15.322442         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: gvfs-afc-volume  1726       657.323985        14   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.485890         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gmain  1735       212.232407         2   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         1.326866         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:      goa-daemon  1741      1344.299683       334   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       134.753948         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gmain  1766       215.262020         5   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.167368         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gmain  1781       236.016700         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.058008         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gmain  1965       287.520288         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.082616         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:    clock-applet  1868      1777.692575      2643   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000      1419.714994         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:    dconf worker  2063       325.213760        16   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.535073         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: notification-ar  1875       658.958191       191   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        59.748269         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gmain  1956       281.086095         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.083497         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: evolution-calen  2076      1344.289777       202   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       164.688568         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gmain  2079       474.146619         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.063798         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: evolution-calen  2084       643.985816        18   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         2.956334         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gmain  2090       595.416203         8   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.182879         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:    dconf worker  2098       576.263162         2   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.189336         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: evolution-addre  2112      1344.395627       224   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       117.875456         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gdbus  2129       647.579078        75   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         6.803068         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:       gnuserver  2168      2577.948182      3392   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000      1154.809836         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-83
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         systemd  2334        34.539478        44   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        69.143053         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /user.slice/user-0.slice/user@0.service
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:        (sd-pam)  2335         8.084184         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.132770         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /user.slice/user-0.slice/user@0.service
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: parse-wpacli-ev  3475      1128.028489         4   103
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         1.109885         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-83
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:     kworker/1:0 10919    237247.790252         5   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.082890         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           rmmod 32491       193.649339         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         1.334397         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /user.slice/user-0.slice/session-1.scope
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:     kworker/1:1  7390    237256.739534         2   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.014302         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: cpu#2, 2494.544 MHz
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_running                    : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load                          : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_switches                   : 1029205
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_load_updates               : 487517
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_uninterruptible            : 360
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .next_balance                  : 4297.106504
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .curr->pid                     : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .clock                         : 2439324.828457
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .clock_task                    : 2439324.828457
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .cpu_load[0]                   : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .cpu_load[1]                   : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .cpu_load[2]                   : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .cpu_load[3]                   : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .cpu_load[4]                   : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .avg_idle                      : 999120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .max_idle_balance_cost         : 500000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   cfs_rq[2]:/autogroup-124
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .exec_clock                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .MIN_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .min_vruntime                  : 105.598288
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .max_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread                        : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread0                       : -180297.329177
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_spread_over                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_running                    : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load                          : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load_avg                      : 282
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .runnable_load_avg             : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .util_avg                      : 4
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg_contrib           : 282
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg                   : 282
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttled                     : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttle_count                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->exec_start                : 2439315.286928
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->vruntime                  : 191528.966877
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->sum_exec_runtime          : 5891.210695
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->load.weight               : 2
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.load_avg              : 6
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.util_avg              : 4
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   cfs_rq[2]:/autogroup-59
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .exec_clock                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .MIN_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .min_vruntime                  : 109.442075
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .max_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread                        : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread0                       : -180293.485390
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_spread_over                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_running                    : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load                          : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load_avg                      : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .runnable_load_avg             : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .util_avg                      : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg_contrib           : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg                   : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttled                     : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttle_count                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->exec_start                : 2439031.583770
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->vruntime                  : 191525.721835
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->sum_exec_runtime          : 110.803895
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->load.weight               : 2
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   cfs_rq[2]:/autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .exec_clock                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .MIN_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .min_vruntime                  : 1008.467900
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .max_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread                        : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread0                       : -179394.459565
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_spread_over                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_running                    : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load                          : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load_avg                      : 1
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .runnable_load_avg             : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .util_avg                      : 1
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg_contrib           : 1
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg                   : 1
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttled                     : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttle_count                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->exec_start                : 2439294.842898
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->vruntime                  : 191526.976331
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->sum_exec_runtime          : 1297.350964
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->load.weight               : 2
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.load_avg              : 1
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.util_avg              : 1
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   cfs_rq[2]:/autogroup-116
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .exec_clock                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .MIN_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .min_vruntime                  : 15.084451
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .max_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread                        : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread0                       : -180387.843014
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_spread_over                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_running                    : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load                          : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load_avg                      : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .runnable_load_avg             : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .util_avg                      : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg_contrib           : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg                   : 272
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttled                     : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttle_count                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->exec_start                : 2438951.045323
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->vruntime                  : 191526.021578
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->sum_exec_runtime          : 891.986915
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->load.weight               : 2
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   cfs_rq[2]:/
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .exec_clock                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .MIN_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .min_vruntime                  : 191536.045798
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .max_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread                        : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread0                       : 11133.118333
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_spread_over                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_running                    : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load                          : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load_avg                      : 22
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .runnable_load_avg             : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .util_avg                      : 17
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg_contrib           : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg                   : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttled                     : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttle_count                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   rt_rq[2]:/user.slice/user-0.slice/session-3.scope
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_throttled                  : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_time                       : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_runtime                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   rt_rq[2]:/user.slice/user-0.slice/session-1.scope
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_throttled                  : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_time                       : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_runtime                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   rt_rq[2]:/init.scope
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_throttled                  : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_time                       : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_runtime                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   rt_rq[2]:/system.slice
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_throttled                  : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_time                       : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_runtime                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   rt_rq[2]:/user.slice/user-0.slice/user@0.service
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_throttled                  : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_time                       : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_runtime                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   rt_rq[2]:/user.slice/user-0.slice
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_throttled                  : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_time                       : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_runtime                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   rt_rq[2]:/user.slice
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_throttled                  : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_time                       : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_runtime                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   rt_rq[2]:/
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_throttled                  : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_time                       : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_runtime                    : 950.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   dl_rq[2]:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .dl_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .dl_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .dl_bw->bw                     : 996147
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .dl_bw->total_bw               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   runnable tasks:
                                                               task   PID         tree-key  switches  prio     wait-time             sum-exec        sum-sleep
                                                   ----------------------------------------------------------------------------------------------------------
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:    kworker/u8:0     5    191536.033910    276950   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000      8089.709735         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:          rcu_bh    10     49244.458368        13   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.235465         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         cpuhp/2    20      5240.692504        24   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.527236         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:      watchdog/2    21        -5.965429       614     0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        13.370926         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:     migration/2    22         0.000000      5109     0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        85.506101         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:     ksoftirqd/2    23    191524.357370     63242   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000      1227.719774         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:    kworker/2:0H    25      1643.813975        12   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.103466         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:          crypto    44        79.690453         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.000000         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:     kintegrityd    45        79.690453         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.000000         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:              md    48        79.696314         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.005861         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:        kthrotld   240       519.180060         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.018795         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:       scsi_eh_0   243       629.628937         3   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.092476         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:      scsi_tmf_2   248       596.511648         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.015273         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:       scsi_eh_3   249       629.615796         3   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.023534         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:      scsi_tmf_3   250       614.532555         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.012742         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:       scsi_eh_4   251       629.653598         3   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.025644         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:      scsi_tmf_4   252       632.553458         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.012433         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:      scsi_tmf_5   254       638.570454         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.019327         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:    kworker/u8:5   258    178236.142774     23558   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000      1367.864049         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  adf_vf_stop_wq   263       653.710291         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.024959         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: charger_manager   310       877.500781         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.018975         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   i915/signal:2   527         0.000000         2    98
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.011982         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:    kworker/2:1H   530    191522.946144      2604   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        36.687512         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:     jbd2/dm-0-8   639    191523.308202      1653   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       221.824339         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: ext4-rsv-conver   640      2569.458833         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.025116         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         xprtiod   755      2893.876906         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.017936         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:        cfg80211   819      4431.339343         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.022376         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:    ModemManager   914         3.743289       188   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        78.292016         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-61
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         chronyd   917        10.559661       201   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        21.516595         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-64
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:        gssproxy   959         2.565652         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.014233         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-73
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:            sshd  1343         0.387487         3   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         1.597419         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-87
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  NFSv4 callback  1380    172005.217595         9   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.678305         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1392       999.173654      2815   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       361.453102         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:      llvmpipe-0  1416        70.077930         3   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.077991         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         radiusd  1412        34.704012        12   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.178855         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-96
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         radiusd  1414        26.444014        12   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.284632         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-96
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1428        92.536175         5   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.048736         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1429       101.486406         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.006906         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1430       101.528473         4   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.034818         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1431        97.033355         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.009792         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1432       101.528539         2   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.013807         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1433       107.507759         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.008483         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1434       107.523255         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.023979         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1437       105.105754         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.006480         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1438       104.505271         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.005996         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1442       104.076785         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.006080         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1443       103.755645         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.006372         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1444       103.755380         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.006106         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1445      1008.416692     24202   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       985.198579         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1446       113.534237         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.010985         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1450       124.765277         2   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         2.231046         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1457      1008.238488     24200   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       978.065985         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1458       142.811222         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.011957         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1459       151.820362         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.009146         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1460       160.829391         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.009035         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1461       169.838001         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.008616         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1463      1008.467900     24198   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       984.350367         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:      kpktgend_2  1514    191526.851040     23292   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       600.149464         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:        xstartup  1553        54.854848         2   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         2.051041         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gmain  1572       526.401002        13   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         2.263119         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gdbus  1573       225.567628        87   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        10.912570         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:    dconf worker  1565         7.822464        10   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         1.357491         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gdbus  1568         8.335563        24   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         1.968095         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gdbus  1596      1521.335715        89   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        15.009183         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           marco  1608      3994.835038     20531   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000      1560.322421         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gdbus  1611       157.463053        10   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         1.081853         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   gvfs-fuse-sub  1646       153.838106         3   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.460864         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gmain  1713      3983.728434      1839   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        88.396841         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gdbus  1661      2101.108770        60   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        10.056970         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         udisksd  1662        85.450067        78   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        68.898393         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-98
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gmain  1663        14.488870         2   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.078577         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-98
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gdbus  1665        85.006063        44   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         4.000034         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-98
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         cleanup  1695        24.225912         5   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.489691         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-98
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gmain  1667        29.591339         8   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.944224         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-99
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:    dconf worker  1893       305.834761         9   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.367844         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gdbus  1703      1644.387200        56   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         5.177657         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  blueman-applet  1674      2991.658281       670   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       582.468226         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: evolution-alarm  1701      3941.657971       575   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       327.834027         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gmain  1773       789.795872         2   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.071625         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gdbus  1774      1459.111414       212   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        20.649494         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gmain  1714       153.874817         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.070846         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gmain  1728       158.878188         3   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.065776         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gdbus  1769       371.097798        72   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         6.176226         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: goa-identity-se  1777      2101.284646       503   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        59.489135         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:              sh  1801       203.592993         3   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         3.441954         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-83
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:      logchopper  1805      1810.698496      4180   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       169.554938         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-83
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: mate-sensors-ap  1861      2110.617325      1410   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       797.662779         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gmain  2017       358.033481         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.070815         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: evolution-sourc  1999       805.838821       225   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       255.656404         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gdbus  2037       805.853862        81   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         8.255134         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gmain  2046       366.513591         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.067181         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gdbus  2047       372.368055        15   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         2.059636         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:    dconf worker  2077       505.961750        14   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         2.239355         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:            pool  2083       515.605998         2   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.292454         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: evolution-calen  2089      1862.726967       238   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       196.896561         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:    dconf worker  2093       805.753608         6   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.309857         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: evolution-calen  2094       805.729186        28   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        50.170319         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gmain  2095       702.199280         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.048830         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           gdbus  2096       805.828814       126   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        11.152397         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:     pipe_helper  2133      1812.102457      7928   103
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       333.802617         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-83
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:            bash  2341       229.136785       132   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        61.507162         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /user.slice/user-0.slice/session-1.scope
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         hostapd  3375       105.598288    140317   102
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000      7533.966343         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-124
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         wpa_cli  3478      1812.103346       947   103
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        58.209860         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-83
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:    kworker/u8:3 13363    191536.045798    271515   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000      7953.467942         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:     kworker/2:0 21131    191525.707314      4843   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        86.823001         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:    kworker/u8:1 28047    191526.833148      2736   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        92.067204         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:     kworker/2:1 31442    156569.025638       105   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         3.034072         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   ath10k_aux_wq 31798    154865.506542         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.020258         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:       ath10k_wq 31807    154871.877266         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.019693         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   ath10k_aux_wq 31808    154878.231571         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.015346         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: cpu#3, 2494.544 MHz
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_running                    : 1
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load                          : 1048576
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_switches                   : 1023583
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_load_updates               : 507051
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_uninterruptible            : 510
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .next_balance                  : 4297.106566
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .curr->pid                     : 988
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .clock                         : 2439327.133269
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .clock_task                    : 2439327.133269
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .cpu_load[0]                   : 764
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .cpu_load[1]                   : 754
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .cpu_load[2]                   : 737
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .cpu_load[3]                   : 706
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .cpu_load[4]                   : 637
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .avg_idle                      : 1000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .max_idle_balance_cost         : 500000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   cfs_rq[3]:/user.slice/user-0.slice/session-3.scope
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .exec_clock                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .MIN_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .min_vruntime                  : 233.932311
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .max_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread                        : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread0                       : -180168.995154
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_spread_over                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_running                    : 1
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load                          : 1048576
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load_avg                      : 764
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .runnable_load_avg             : 764
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .util_avg                      : 764
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg_contrib           : 764
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg                   : 764
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttled                     : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttle_count                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->exec_start                : 2439327.133269
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->vruntime                  : 369.174014
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->sum_exec_runtime          : 105.333906
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->load.weight               : 1048576
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.load_avg              : 764
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.util_avg              : 764
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   cfs_rq[3]:/user.slice/user-0.slice
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .exec_clock                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .MIN_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .min_vruntime                  : 369.174014
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .max_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread                        : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread0                       : -180033.753451
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_spread_over                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_running                    : 1
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load                          : 1048576
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load_avg                      : 764
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .runnable_load_avg             : 764
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .util_avg                      : 764
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg_contrib           : 764
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg                   : 764
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttled                     : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttle_count                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->exec_start                : 2439327.133269
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->vruntime                  : 502.055838
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->sum_exec_runtime          : 226.228142
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->load.weight               : 1048576
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.load_avg              : 764
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.util_avg              : 764
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   cfs_rq[3]:/autogroup-90
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .exec_clock                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .MIN_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .min_vruntime                  : 936.641794
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .max_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread                        : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread0                       : -179466.285671
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_spread_over                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_running                    : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load                          : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load_avg                      : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .runnable_load_avg             : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .util_avg                      : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg_contrib           : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg                   : 1
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttled                     : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttle_count                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->exec_start                : 2439243.882544
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->vruntime                  : 214731.418192
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->sum_exec_runtime          : 1348.554550
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->load.weight               : 2
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   cfs_rq[3]:/autogroup-116
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .exec_clock                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .MIN_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .min_vruntime                  : 52.809178
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .max_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread                        : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread0                       : -180350.118287
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_spread_over                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_running                    : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load                          : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load_avg                      : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .runnable_load_avg             : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .util_avg                      : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg_contrib           : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg                   : 259
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttled                     : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttle_count                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->exec_start                : 2438987.486310
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->vruntime                  : 214729.160498
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->sum_exec_runtime          : 2973.841380
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->load.weight               : 2
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   cfs_rq[3]:/autogroup-83
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .exec_clock                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .MIN_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .min_vruntime                  : 2556.950889
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .max_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread                        : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread0                       : -177845.976576
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_spread_over                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_running                    : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load                          : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load_avg                      : 55
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .runnable_load_avg             : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .util_avg                      : 1
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg_contrib           : 55
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg                   : 80
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttled                     : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttle_count                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->exec_start                : 2439175.373795
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->vruntime                  : 214734.786547
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->sum_exec_runtime          : 30816.525585
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->load.weight               : 2
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.load_avg              : 1
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.util_avg              : 1
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   cfs_rq[3]:/autogroup-124
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .exec_clock                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .MIN_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .min_vruntime                  : 13.414694
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .max_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread                        : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread0                       : -180389.512771
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_spread_over                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_running                    : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load                          : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load_avg                      : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .runnable_load_avg             : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .util_avg                      : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg_contrib           : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg                   : 269
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttled                     : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttle_count                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->exec_start                : 2439030.945348
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->vruntime                  : 214729.589935
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->sum_exec_runtime          : 798.851640
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->load.weight               : 2
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   cfs_rq[3]:/user.slice
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .exec_clock                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .MIN_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .min_vruntime                  : 502.055838
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .max_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread                        : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread0                       : -179900.871627
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_spread_over                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_running                    : 1
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load                          : 1048576
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load_avg                      : 764
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .runnable_load_avg             : 764
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .util_avg                      : 764
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg_contrib           : 764
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg                   : 764
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttled                     : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttle_count                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->exec_start                : 2439327.133269
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->vruntime                  : 214797.738432
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->sum_exec_runtime          : 226.277777
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->load.weight               : 1048576
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.load_avg              : 764
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .se->avg.util_avg              : 764
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   cfs_rq[3]:/
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .exec_clock                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .MIN_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .min_vruntime                  : 214797.738432
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .max_vruntime                  : 0.000001
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread                        : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .spread0                       : 34394.810967
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_spread_over                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .nr_running                    : 1
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load                          : 1048576
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .load_avg                      : 804
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .runnable_load_avg             : 764
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .util_avg                      : 764
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_load_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .removed_util_avg              : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg_contrib           : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .tg_load_avg                   : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttled                     : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .throttle_count                : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   rt_rq[3]:/user.slice/user-0.slice/session-3.scope
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_throttled                  : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_time                       : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_runtime                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   rt_rq[3]:/user.slice/user-0.slice/session-1.scope
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_throttled                  : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_time                       : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_runtime                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   rt_rq[3]:/init.scope
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_throttled                  : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_time                       : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_runtime                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   rt_rq[3]:/system.slice
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_throttled                  : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_time                       : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_runtime                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   rt_rq[3]:/user.slice/user-0.slice/user@0.service
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_throttled                  : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_time                       : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_runtime                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   rt_rq[3]:/user.slice/user-0.slice
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_throttled                  : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_time                       : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_runtime                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   rt_rq[3]:/user.slice
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_throttled                  : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_time                       : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_runtime                    : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   rt_rq[3]:/
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_throttled                  : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_time                       : 0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .rt_runtime                    : 950.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   dl_rq[3]:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .dl_nr_running                 : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .dl_nr_migratory               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .dl_bw->bw                     : 996147
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   .dl_bw->total_bw               : 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
                                                   runnable tasks:
                                                               task   PID         tree-key  switches  prio     wait-time             sum-exec        sum-sleep
                                                   ----------------------------------------------------------------------------------------------------------
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:       rcu_sched     9    209558.454400       585   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         9.227846         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         cpuhp/3    26      6478.060085        24   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.548815         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:      watchdog/3    27        -5.965738       614     0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        14.341585         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:     migration/3    28         0.000000      5084     0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        88.201268         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:     ksoftirqd/3    29    214712.223768      5903   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       156.155679         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:    kworker/3:0H    31      3190.358658        12   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.093104         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:       kdevtmpfs    32      9056.866873       191   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         4.914882         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:      khungtaskd    38    210712.244290        25   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        54.466988         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:      oom_reaper    39        35.870811         2   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.000000         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         kswapd0   148      1698.440580         3   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.050670         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: acpi_thermal_pm   241      1707.425550         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.033126         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:       scsi_eh_1   245      1777.434338        34   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         1.342342         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:     kworker/3:3   311    214731.416179      6657   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       502.551864         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   ipv6_addrconf   312      1791.175204         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.021818         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:          bioset   610      3199.358081         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.028331         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:    kworker/3:1H   613    214332.293745      1463   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        21.177245         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:          bioset   620      3215.693330         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.026786         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:          rpciod   754      3602.236561         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.018042         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:   systemd-udevd   774       872.212675      1116   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       472.197739         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-38
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:     jbd2/sda1-8   887      7039.829111         2   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.020009         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel: ext4-rsv-conver   888      7045.839702         2   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.015947         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:     dbus-daemon   912       124.444204      1184   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000       258.811502         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-60
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:        gssproxy   941        -5.728862        50   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        10.127911         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-73
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:        gssproxy   960         1.945283         1   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.010823         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-73
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:        dhclient  1224         2.008186       109   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         8.808598         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-75
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:     xrdp-sesman  1325         0.274563        24   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        12.100561         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-84
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:          nfsiod  1346      8200.838566         4   100
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.019947         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:      llvmpipe-3  1419        75.015485         3   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.098689         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:           login  1404         1.169294        64   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000        34.585008         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  /user.slice/user-0.slice/session-3.scope
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         radiusd  1411        -9.816927        12   120
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:         0.000000         0.261982         0.000000
Oct 10 12:02:11 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-96
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         radiusd  1415         0.835733        12   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         0.343950         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-96
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1424       936.641794     24210   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000       928.775880         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1423        26.319793         2   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         2.759672         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1464        52.957457         1   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         0.037878         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1466        61.966818         1   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         0.009367         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel: /usr/sbin/httpd  1467        71.001408         1   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         0.034596         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-90
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:      kpktgend_3  1515    214731.301684     23292   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000       569.278666         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:      llvmpipe-2  1561       107.446046         1   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         0.020404         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:    dconf worker  1576       141.613395        41   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         3.413775         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:           gmain  1566        18.854872         2   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         0.061108         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:     dbus-daemon  1569       975.844817        85   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000        15.273756         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:           gmain  1587        94.434402         3   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         0.072894         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel: gnome-keyring-d  1594      1063.318283       104   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000        10.593915         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:           timer  1598       149.039921         1   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         0.018715         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:    dconf worker  1605       728.681229        86   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         6.071279         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:           gdbus  1607       730.582456       223   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000        24.044105         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:           gdbus  1614       988.159296       596   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000        43.985250         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:           gdbus  1620       669.436708       101   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000        11.149366         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:    dconf worker  1712       733.338903        19   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         2.933658         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:           gmain  1660       154.143441        18   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         3.182137         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  probing-thread  1684        13.688829         1   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         0.026142         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-98
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:    JS GC Helper  1673        17.287606         1   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         0.077985         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-99
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel: JS Sour~ Thread  1675        51.676134        20   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         0.389110         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-99
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         polkitd  1678        61.723766        15   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         0.384917         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-99
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:        nautilus  1697      1073.460614       710   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000       378.717782         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:           gdbus  1727      1073.570038       369   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000        21.299824         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel: evolution-alarm  1997      1046.940638        29   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000        43.226278         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel: evolution-alarm  2060      1053.674731        65   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000        10.479189         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-88
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:           gdbus  1716       241.331538        46   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         3.222918         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:     gvfsd-trash  1732       774.579101        86   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000        20.779399         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:           gdbus  1736       404.044686        71   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         6.350193         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel: gvfs-goa-volume  1734       258.725813        39   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000        10.507260         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:           gdbus  1739       260.099250        30   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         3.753479         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:    dconf worker  1771       254.824933         4   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         0.361865         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:            pool  1782      2634.453078       497   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000        53.700453         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:    run_client_2  1804       987.367827        74   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000        32.149402         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-83
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:           gdbus  1967       453.854759        48   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         4.737906         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:    dconf worker  2058       453.517495        16   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         1.048163         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel: mate-multiload-  1866      2650.922369      6498   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000      5150.281719         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:           gmain  2027       803.561292        18   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         0.771866         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:    dconf worker  2035       771.557449         8   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         0.402579         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:           gmain  2036       379.994332         3   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         0.112542         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel: evolution-calen  2062       759.679664       449   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000       280.449559         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:           gmain  2070       650.269248         7   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         0.241360         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:    dconf worker  2072       590.627514        10   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         0.329271         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel: evolution-calen  2078       759.707804        17   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000        44.827668         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:           gdbus  2080       771.640143       137   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000        11.583662         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:        btserver  2111      2548.123920     48662   103
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000     17980.414726         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-83
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:           gmain  2127       767.742548         2   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         0.125143         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:    dconf worker  2130       768.337183         9   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         0.626163         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel: evolution-addre  2131       766.378039         7   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000        30.220077         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel: parse-iw-event.  2315      2199.563467        56   103
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         5.227086         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-83
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:              iw  2316      2199.558630        55   103
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         5.299563         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-83
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:           obexd  2324       781.988599        19   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         7.351608         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-97
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:            sshd  2340       283.057301       508   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000        54.852198         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /user.slice/user-0.slice/session-1.scope
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:           dhcpd  3350        -1.014150        59   103
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000        12.476189         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /autogroup-123
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:    kworker/u8:2 21468    205829.425213     12416   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000       259.026566         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:     kworker/3:1 31720    188978.415742        16   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000         0.216040         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:    kworker/u8:4 31901    214612.617827      2200   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000        97.838975         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel: R
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:            bash   988       233.932311       345   120
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:         0.000000       138.462461         0.000000
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  0 0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  /user.slice/user-0.slice/session-3.scope
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
                                                   Showing all locks held in the system:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel: 2 locks held by kworker/u8:0/5:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  #0:  ("%s""ath10k_wq"){++++.+}, at: [<ffffffff8113df8f>] process_one_work+0x14f/0x6a0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  #1:  ((&ar->register_work)){+.+.+.}, at: [<ffffffff8113df8f>] process_one_work+0x14f/0x6a0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel: 2 locks held by bash/1762:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  #0:  (&tty->ldisc_sem){++++.+}, at: [<ffffffff819b634d>] ldsem_down_read+0x2d/0x40
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  #1:  (&ldata->atomic_read_lock){+.+...}, at: [<ffffffff815f57e9>] n_tty_read+0xa9/0x8d0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel: 2 locks held by kworker/u8:3/13363:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  #0:  ("%s""ath10k_wq"){++++.+}, at: [<ffffffff8113df8f>] process_one_work+0x14f/0x6a0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  #1:  ((&ar->register_work)){+.+.+.}, at: [<ffffffff8113df8f>] process_one_work+0x14f/0x6a0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel: 2 locks held by rmmod/32491:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  #0:  (&dev->mutex){......}, at: [<ffffffff816569e6>] device_release_driver_internal+0x26/0x210
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  #1:  (&dev->mutex){......}, at: [<ffffffff816569f4>] device_release_driver_internal+0x34/0x210
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel: 3 locks held by bash/988:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  #0:  (sb_writers#3){.+.+.+}, at: [<ffffffff812dd412>] vfs_write+0x1a2/0x1c0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  #1:  (rcu_read_lock){......}, at: [<ffffffff815fca50>] __handle_sysrq+0x0/0x200
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:  #2:  (tasklist_lock){.+.+..}, at: [<ffffffff8117b88d>] debug_show_all_locks+0x3d/0x1a0
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel: =============================================
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel: Showing busy workqueues and worker pools:
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel: workqueue ath10k_wq: flags=0xe000a
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:   pwq 8: cpus=0-3 flags=0x4 nice=0 active=1/1
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:     in-flight: 5:ath10k_core_register_work [ath10k_core]
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:     delayed: ath10k_core_restart [ath10k_core]
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel: workqueue ath10k_wq: flags=0xe000a
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:   pwq 8: cpus=0-3 flags=0x4 nice=0 active=1/1
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:     in-flight: 13363:ath10k_core_register_work [ath10k_core] BAR(32491)
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel:     delayed: ath10k_core_restart [ath10k_core]
Oct 10 12:02:12 ben-ota-2.candelatech.com kernel: pool 8: cpus=0-3 flags=0x4 nice=0 hung=0s workers=7 idle: 28047 31901 21468 258 8000





Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
