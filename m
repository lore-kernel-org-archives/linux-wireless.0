Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:38930 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751633AbeB0Vme (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 16:42:34 -0500
Subject: Re: Deadlock debugging help.
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>
References: <4720ead5-f465-57e0-b203-49e4cb6ae51d@candelatech.com>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <2f31c1c8-683a-7be3-693d-617939f042d6@candelatech.com> (sfid-20180227_224238_627458_82272BD7)
Date: Tue, 27 Feb 2018 13:42:31 -0800
MIME-Version: 1.0
In-Reply-To: <4720ead5-f465-57e0-b203-49e4cb6ae51d@candelatech.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/27/2018 12:49 PM, Ben Greear wrote:
> I notice I can reliably lock up the kernel if I rmmod ath10k while it is under
> heavy tx/rx traffic.  First, this causes the firmware to crash, and then right
> after (or possibly during?) the related kernel threads deadlock.
>
> This is with my hacked driver and hacked firmware.  In particular, the
> ath10k_debug_nop_dwork is something I added, though it is pretty trivial,
> it does take the ar->conf_mutex.  It appears blocked trying to get it.
>
> It appears something is holding the ar->conf_mutex, but it is not clear to
> me from the lockdep output what process actually holds it.
> Anyone see a clue they could share?

Changing how I start/stop the nop_dwork stuff seems to have made the
problem go away, so I guess maybe that was the issue.

Thanks,
Ben

>
> Thanks,
> Ben
>
>
> [ 1618.914057] sysrq: SysRq : Show Regs
> [ 1618.916617] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G        W  O    4.13.16+ #2
> [ 1618.916618] Hardware name: _ _/ , BIOS 5.11 08/26/2016
> [ 1618.916620] task: ffff88016d3ea740 task.stack: ffffc900006c8000
> [ 1618.916624] RIP: 0010:cpuidle_enter_state+0x130/0x3b0
> [ 1618.916625] RSP: 0018:ffffc900006cbe78 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff3e
> [ 1618.916628] RAX: ffff88016d3ea740 RBX: 0000000000000008 RCX: 000000000000001f
> [ 1618.916629] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff88016d3ea740
> [ 1618.916630] RBP: ffffc900006cbeb0 R08: 00000000000052ca R09: 0000000000000000
> [ 1618.916631] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000008
> [ 1618.916633] R13: ffff880172d26c00 R14: ffffffff81ec66b8 R15: 00000178ee494b98
> [ 1618.916634] FS:  0000000000000000(0000) GS:ffff880172d00000(0000) knlGS:0000000000000000
> [ 1618.916636] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1618.916637] CR2: 00007ffdda2194b8 CR3: 0000000001e0f000 CR4: 00000000003406e0
> [ 1618.916638] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1618.916639] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 1618.916640] Call Trace:
> [ 1618.916645]  cpuidle_enter+0x12/0x20
> [ 1618.916647]  call_cpuidle+0x1e/0x40
> [ 1618.916649]  do_idle+0x184/0x1e0
> [ 1618.916651]  cpu_startup_entry+0x5f/0x70
> [ 1618.916654]  start_secondary+0x150/0x180
> [ 1618.916657]  secondary_startup_64+0x9f/0x9f
> [ 1618.916662] Code: b7 df 95 ff 48 89 45 d0 0f 1f 44 00 00 31 ff e8 97 6c 97 ff 8b 45 c8 85 c0 0f 85 83 01 00 00 e8 57 5b 98 ff fb 66 0f 1f 44 00 00 <48> 8b 5d
> d0 48 ba cf f7 53 e3 a5 9b c4 20 4c 29 fb 48 89 d8 48
>
> [ 1618.916724] CPU#2: ctrl:       000000070000000f
> [ 1618.916726] CPU#2: status:     0000000000000000
> [ 1618.916727] CPU#2: overflow:   0000000000000000
> [ 1618.916728] CPU#2: fixed:      00000000000000b0
> [ 1618.916729] CPU#2: pebs:       0000000000000000
> [ 1618.916730] CPU#2: debugctl:   0000000000000000
> [ 1618.916731] CPU#2: active:     0000000200000000
> [ 1618.916732] CPU#2:   gen-PMC0 ctrl:  0000000000000000
> [ 1618.916733] CPU#2:   gen-PMC0 count: 0000000000000000
> [ 1618.916734] CPU#2:   gen-PMC0 left:  0000000000000000
> [ 1618.916735] CPU#2:   gen-PMC1 ctrl:  0000000000000000
> [ 1618.916736] CPU#2:   gen-PMC1 count: 0000000000000000
> [ 1618.916737] CPU#2:   gen-PMC1 left:  0000000000000000
> [ 1618.916738] CPU#2:   gen-PMC2 ctrl:  0000000000000000
> [ 1618.916739] CPU#2:   gen-PMC2 count: 0000000000000000
> [ 1618.916740] CPU#2:   gen-PMC2 left:  0000000000000000
> [ 1618.916742] CPU#2:   gen-PMC3 ctrl:  0000000000000000
> [ 1618.916743] CPU#2:   gen-PMC3 count: 0000000000000000
> [ 1618.916744] CPU#2:   gen-PMC3 left:  0000000000000000
> [ 1618.916745] CPU#2: fixed-PMC0 count: 0000000000000000
> [ 1618.916746] CPU#2: fixed-PMC1 count: 0000fffed3945191
> [ 1618.916747] CPU#2: fixed-PMC2 count: 0000000000000000
> [ 1623.035449] INFO: task kworker/u8:1:273 blocked for more than 180 seconds.
> [ 1623.041155]       Tainted: G        W  O    4.13.16+ #2
> [ 1623.045173] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1623.051966] kworker/u8:1    D    0   273      2 0x00000000
> [ 1623.052010] Workqueue: cfg80211 cfg80211_dfs_channels_update_work [cfg80211]
> [ 1623.052026] Call Trace:
> [ 1623.052032]  __schedule+0x407/0xb70
> [ 1623.052037]  schedule+0x38/0x90
> [ 1623.052039]  schedule_preempt_disabled+0x10/0x20
> [ 1623.052041]  __mutex_lock+0x3d3/0x930
> [ 1623.052044]  ? rtnl_lock+0x12/0x20
> [ 1623.052050]  mutex_lock_nested+0x16/0x20
> [ 1623.052052]  ? mutex_lock_nested+0x16/0x20
> [ 1623.052054]  rtnl_lock+0x12/0x20
> [ 1623.052066]  cfg80211_dfs_channels_update_work+0x3c/0x1c0 [cfg80211]
> [ 1623.052069]  ? process_one_work+0x14f/0x6a0
> [ 1623.052074]  process_one_work+0x1ce/0x6a0
> [ 1623.052078]  worker_thread+0x46/0x440
> [ 1623.052083]  kthread+0x10f/0x150
> [ 1623.052084]  ? process_one_work+0x6a0/0x6a0
> [ 1623.052086]  ? kthread_create_on_node+0x40/0x40
> [ 1623.052088]  ? kthread_create_on_node+0x40/0x40
> [ 1623.052091]  ret_from_fork+0x2a/0x40
> [ 1623.052098] INFO: task kworker/u8:2:281 blocked for more than 180 seconds.
> [ 1623.057700]       Tainted: G        W  O    4.13.16+ #2
> [ 1623.061659] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1623.068270] kworker/u8:2    D    0   281      2 0x00000000
> [ 1623.068282] Workqueue: ath10k_wq ath10k_debug_nop_dwork [ath10k_core]
> [ 1623.068284] Call Trace:
> [ 1623.068288]  __schedule+0x407/0xb70
> [ 1623.068292]  schedule+0x38/0x90
> [ 1623.068308]  schedule_preempt_disabled+0x10/0x20
> [ 1623.068310]  __mutex_lock+0x3d3/0x930
> [ 1623.068315]  ? ath10k_debug_nop_dwork+0x24/0x80 [ath10k_core]
> [ 1623.068322]  ? lock_acquire+0xac/0x200
> [ 1623.068325]  mutex_lock_nested+0x16/0x20
> [ 1623.068326]  ? mutex_lock_nested+0x16/0x20
> [ 1623.068331]  ath10k_debug_nop_dwork+0x24/0x80 [ath10k_core]
> [ 1623.068340]  process_one_work+0x1ce/0x6a0
> [ 1623.068345]  worker_thread+0x46/0x440
> [ 1623.068349]  kthread+0x10f/0x150
> [ 1623.068350]  ? process_one_work+0x6a0/0x6a0
> [ 1623.068352]  ? kthread_create_on_node+0x40/0x40
> [ 1623.068354]  ? kthread_create_on_node+0x40/0x40
> [ 1623.068356]  ret_from_fork+0x2a/0x40
> [ 1623.068363] INFO: task kworker/0:3:462 blocked for more than 180 seconds.
> [ 1623.073888]       Tainted: G        W  O    4.13.16+ #2
> [ 1623.077882] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1623.084475] kworker/0:3     D    0   462      2 0x00000080
> [ 1623.084480] Workqueue: events linkwatch_event
> [ 1623.084482] Call Trace:
> [ 1623.084485]  __schedule+0x407/0xb70
> [ 1623.084489]  schedule+0x38/0x90
> [ 1623.084491]  schedule_preempt_disabled+0x10/0x20
> [ 1623.084493]  __mutex_lock+0x3d3/0x930
> [ 1623.084495]  ? rtnl_lock+0x12/0x20
> [ 1623.084501]  ? lock_acquire+0xac/0x200
> [ 1623.084504]  mutex_lock_nested+0x16/0x20
> [ 1623.084507]  ? mutex_lock_nested+0x16/0x20
> [ 1623.084509]  rtnl_lock+0x12/0x20
> [ 1623.084511]  linkwatch_event+0x9/0x30
> [ 1623.084513]  process_one_work+0x1ce/0x6a0
> [ 1623.084517]  worker_thread+0x46/0x440
> [ 1623.084521]  kthread+0x10f/0x150
> [ 1623.084523]  ? process_one_work+0x6a0/0x6a0
> [ 1623.084525]  ? kthread_create_on_node+0x40/0x40
> [ 1623.084528]  ? do_syscall_64+0x64/0x140
> [ 1623.084531]  ret_from_fork+0x2a/0x40
> [ 1623.084537] INFO: task kworker/1:2:562 blocked for more than 180 seconds.
> [ 1623.090051]       Tainted: G        W  O    4.13.16+ #2
> [ 1623.094000] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1623.100574] kworker/1:2     D    0   562      2 0x00000080
> [ 1623.100615] Workqueue: events_freezable ieee80211_restart_work [mac80211]
> [ 1623.100617] Call Trace:
> [ 1623.100620]  __schedule+0x407/0xb70
> [ 1623.100625]  schedule+0x38/0x90
> [ 1623.100627]  schedule_preempt_disabled+0x10/0x20
> [ 1623.100629]  __mutex_lock+0x3d3/0x930
> [ 1623.100631]  ? rtnl_lock+0x12/0x20
> [ 1623.100648]  ? flush_work+0x298/0x2d0
> [ 1623.100654]  mutex_lock_nested+0x16/0x20
> [ 1623.100655]  ? mutex_lock_nested+0x16/0x20
> [ 1623.100658]  rtnl_lock+0x12/0x20
> [ 1623.100667]  ieee80211_restart_work+0x50/0xc0 [mac80211]
> [ 1623.100671]  process_one_work+0x1ce/0x6a0
> [ 1623.100675]  worker_thread+0x46/0x440
> [ 1623.100679]  kthread+0x10f/0x150
> [ 1623.100681]  ? process_one_work+0x6a0/0x6a0
> [ 1623.100683]  ? kthread_create_on_node+0x40/0x40
> [ 1623.100685]  ? do_syscall_64+0x64/0x140
> [ 1623.100688]  ret_from_fork+0x2a/0x40
> [ 1623.100714] INFO: task btserver:3871 blocked for more than 180 seconds.
> [ 1623.106094]       Tainted: G        W  O    4.13.16+ #2
> [ 1623.110042] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1623.116600] btserver        D    0  3871   1958 0x00000080
> [ 1623.116604] Call Trace:
> [ 1623.116627]  __schedule+0x407/0xb70
> [ 1623.116633]  schedule+0x38/0x90
> [ 1623.116636]  schedule_preempt_disabled+0x10/0x20
> [ 1623.116638]  __mutex_lock+0x3d3/0x930
> [ 1623.116641]  ? rtnetlink_rcv+0x16/0x30
> [ 1623.116648]  mutex_lock_nested+0x16/0x20
> [ 1623.116649]  ? mutex_lock_nested+0x16/0x20
> [ 1623.116651]  rtnetlink_rcv+0x16/0x30
> [ 1623.116653]  netlink_unicast+0x1cb/0x2e0
> [ 1623.116656]  netlink_sendmsg+0x2c6/0x3a0
> [ 1623.116661]  sock_sendmsg+0x33/0x40
> [ 1623.116664]  SYSC_sendto+0x101/0x190
> [ 1623.116670]  ? __getnstimeofday64+0x9a/0x150
> [ 1623.116673]  ? getnstimeofday64+0x9/0x20
> [ 1623.116675]  ? __audit_syscall_entry+0xb2/0x100
> [ 1623.116678]  ? syscall_trace_enter+0x1bc/0x3b0
> [ 1623.116681]  ? __do_page_fault+0x28b/0x520
> [ 1623.116684]  ? trace_hardirqs_on_caller+0x11f/0x190
> [ 1623.116688]  SyS_sendto+0x9/0x10
> [ 1623.116690]  do_syscall_64+0x64/0x140
> [ 1623.116693]  entry_SYSCALL64_slow_path+0x25/0x25
> [ 1623.116695] RIP: 0033:0x7f7951ec71b3
> [ 1623.116696] RSP: 002b:00007fffcf807788 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
> [ 1623.116699] RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 00007f7951ec71b3
> [ 1623.116700] RDX: 0000000000000020 RSI: 00007fffcf8077c0 RDI: 000000000000000d
> [ 1623.116716] RBP: 00007fffcf807a20 R08: 00007fffcf8077b0 R09: 000000000000000c
> [ 1623.116717] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> [ 1623.116718] R13: 000000000084b5a5 R14: 000000000084b5ad R15: 000000000084ba53
> [ 1623.116728]
>                Showing all locks held in the system:
> [ 1623.116733] 1 lock held by khungtaskd/38:
> [ 1623.116738]  #0:  (tasklist_lock){.+.+..}, at: [<ffffffff8117ba8d>] debug_show_all_locks+0x3d/0x1a0
> [ 1623.116747] 3 locks held by kworker/u8:1/273:
> [ 1623.116749]  #0:  ("cfg80211"){.+.+.+}, at: [<ffffffff8113e14f>] process_one_work+0x14f/0x6a0
> [ 1623.116755]  #1:  ((&(&rdev->dfs_update_channels_wk)->work)){+.+...}, at: [<ffffffff8113e14f>] process_one_work+0x14f/0x6a0
> [ 1623.116761]  #2:  (rtnl_mutex){+.+.+.}, at: [<ffffffff818a2b72>] rtnl_lock+0x12/0x20
> [ 1623.116768] 3 locks held by kworker/u8:2/281:
> [ 1623.116769]  #0:  ("%s""ath10k_wq"){.+.+.+}, at: [<ffffffff8113e14f>] process_one_work+0x14f/0x6a0
> [ 1623.116775]  #1:  ((&(&ar->debug.nop_dwork)->work)){+.+...}, at: [<ffffffff8113e14f>] process_one_work+0x14f/0x6a0
> [ 1623.116781]  #2:  (&ar->conf_mutex){+.+.+.}, at: [<ffffffffa066d554>] ath10k_debug_nop_dwork+0x24/0x80 [ath10k_core]
> [ 1623.116792] 3 locks held by kworker/0:3/462:
> [ 1623.116793]  #0:  ("events"){.+.+.+}, at: [<ffffffff8113e14f>] process_one_work+0x14f/0x6a0
> [ 1623.116799]  #1:  ((linkwatch_work).work){+.+.+.}, at: [<ffffffff8113e14f>] process_one_work+0x14f/0x6a0
> [ 1623.116805]  #2:  (rtnl_mutex){+.+.+.}, at: [<ffffffff818a2b72>] rtnl_lock+0x12/0x20
> [ 1623.116812] 3 locks held by kworker/1:2/562:
> [ 1623.116813]  #0:  ("events_freezable"){.+.+..}, at: [<ffffffff8113e14f>] process_one_work+0x14f/0x6a0
> [ 1623.116819]  #1:  ((&local->restart_work)){+.+...}, at: [<ffffffff8113e14f>] process_one_work+0x14f/0x6a0
> [ 1623.116825]  #2:  (rtnl_mutex){+.+.+.}, at: [<ffffffff818a2b72>] rtnl_lock+0x12/0x20
> [ 1623.116845] 2 locks held by bash/1896:
> [ 1623.116846]  #0:  (&tty->ldisc_sem){++++.+}, at: [<ffffffff819b67ad>] ldsem_down_read+0x2d/0x40
> [ 1623.116852]  #1:  (&ldata->atomic_read_lock){+.+...}, at: [<ffffffff815f5ed9>] n_tty_read+0xa9/0x8d0
> [ 1623.116860] 1 lock held by btserver/3871:
> [ 1623.116861]  #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff818a40f6>] rtnetlink_rcv+0x16/0x30
> [ 1623.116867] 3 locks held by kworker/2:0/4308:
> [ 1623.116868]  #0:  ("%s"("ipv6_addrconf")){.+.+..}, at: [<ffffffff8113e14f>] process_one_work+0x14f/0x6a0
> [ 1623.116874]  #1:  ((addr_chk_work).work){+.+...}, at: [<ffffffff8113e14f>] process_one_work+0x14f/0x6a0
> [ 1623.116880]  #2:  (rtnl_mutex){+.+.+.}, at: [<ffffffff818a2b72>] rtnl_lock+0x12/0x20
> [ 1623.116887] 4 locks held by rmmod/7551:
> [ 1623.116888]  #0:  (&dev->mutex){......}, at: [<ffffffff81656b76>] device_release_driver_internal+0x26/0x210
> [ 1623.116894]  #1:  (&dev->mutex){......}, at: [<ffffffff81656b84>] device_release_driver_internal+0x34/0x210
> [ 1623.116899]  #2:  (rtnl_mutex){+.+.+.}, at: [<ffffffff818a2b72>] rtnl_lock+0x12/0x20
> [ 1623.116905]  #3:  (&ar->conf_mutex){+.+.+.}, at: [<ffffffffa0668eb4>] ath10k_stop+0x24/0x80 [ath10k_core]
> [ 1623.116915] 2 locks held by bash/7559:
> [ 1623.116916]  #0:  (&tty->ldisc_sem){++++.+}, at: [<ffffffff819b67ad>] ldsem_down_read+0x2d/0x40
> [ 1623.116922]  #1:  (&ldata->atomic_read_lock){+.+...}, at: [<ffffffff815f5ed9>] n_tty_read+0xa9/0x8d0
>
> [ 1623.116929] =============================================
>
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
