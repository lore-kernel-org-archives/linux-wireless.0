Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2613 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbZHQPMy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 11:12:54 -0400
Date: Mon, 17 Aug 2009 11:12:23 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: 2.6.31-rc6 lockdep report
Message-ID: <20090817151223.GA13125@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Haven't looked at it yet, I just hit this one while riding the
train this morning and connecting to someone's adhoc station.

[43559.227490] wlan0: Selected IBSS BSSID 2a:51:0a:35:5c:a1 based on configured SSID
[43559.258660] ath5k phy0: bf=efb0b680 bf_skb=(null)
[43559.291501] phy0: Adding new IBSS station 00:21:e9:94:5e:93 (dev=wlan0)
[43559.291518] phy0: Allocated STA 00:21:e9:94:5e:93
[43559.292327] phy0: Inserted STA 00:21:e9:94:5e:93
[43633.646820] phy0: Adding new IBSS station 00:1e:c2:3b:f4:e3 (dev=wlan0)
[43633.646838] phy0: Allocated STA 00:1e:c2:3b:f4:e3
[43633.646859] 
[43633.646860] =========================================================
[43633.646864] [ INFO: possible irq lock inversion dependency detected ]
[43633.646867] 2.6.31-rc6 #179
[43633.646870] ---------------------------------------------------------
[43633.646873] cc1/18756 just changed the state of lock:
[43633.646876]  (&local->sta_lock){..-...}, at: [<fa244acd>] sta_info_insert+0x91/0x174 [mac80211]
[43633.646900] but this lock took another, SOFTIRQ-unsafe lock in the past:
[43633.646903]  (todo_lock){+.+...}
[43633.646906] 
[43633.646907] and interrupts could create inverse lock ordering between them.
[43633.646908] 
[43633.646911] 
[43633.646912] other info that might help us debug this:
[43633.646915] 2 locks held by cc1/18756:
[43633.646918]  #0:  (&sc->rxbuflock){+.-.-.}, at: [<fa4eca30>] ath5k_tasklet_rx+0x34/0x56c [ath5k]
[43633.646936]  #1:  (rcu_read_lock){.+.+..}, at: [<fa252cbe>] __ieee80211_rx+0x9f/0x581 [mac80211]
[43633.646959] 
[43633.646960] the first lock's dependencies:
[43633.646963] -> (&local->sta_lock){..-...} ops: 0 {
[43633.646969]    IN-SOFTIRQ-W at:
[43633.646973]                                        [<c104c87d>] __lock_acquire+0x558/0x12d3
[43633.646981]                                        [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.646986]                                        [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.646993]                                        [<fa244acd>] sta_info_insert+0x91/0x174 [mac80211]
[43633.647009]                                        [<fa248b2a>] ieee80211_ibss_add_sta+0x119/0x12a [mac80211]
[43633.647009]                                        [<fa25268f>] __ieee80211_rx_handle_packet+0x349/0x552 [mac80211]
[43633.647009]                                        [<fa25311f>] __ieee80211_rx+0x500/0x581 [mac80211]
[43633.647009]                                        [<fa4ecf17>] ath5k_tasklet_rx+0x51b/0x56c [ath5k]
[43633.647009]                                        [<c102e209>] tasklet_action+0x93/0xe6
[43633.647009]                                        [<c102e8d6>] __do_softirq+0xdb/0x1ac
[43633.647009]                                        [<c102e9d7>] do_softirq+0x30/0x48
[43633.647009]                                        [<c102eb53>] irq_exit+0x3d/0x74
[43633.647009]                                        [<c100405b>] do_IRQ+0x88/0x9c
[43633.647009]                                        [<c100302e>] common_interrupt+0x2e/0x34
[43633.647009]                                        [<ffffffff>] 0xffffffff
[43633.647009]    INITIAL USE at:
[43633.647009]                                       [<c104c943>] __lock_acquire+0x61e/0x12d3
[43633.647009]                                       [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                       [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]                                       [<fa244acd>] sta_info_insert+0x91/0x174 [mac80211]
[43633.647009]                                       [<fa24b5c7>] ieee80211_rx_mgmt_assoc_resp+0x5fd/0xa13 [mac80211]
[43633.647009]                                       [<fa24c38b>] ieee80211_sta_work+0x776/0xd3b [mac80211]
[43633.647009]                                       [<c1038a94>] worker_thread+0x1aa/0x287
[43633.647009]                                       [<c103c78b>] kthread+0x70/0x75
[43633.647009]                                       [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]                                       [<ffffffff>] 0xffffffff
[43633.647009]  }
[43633.647009]  ... key      at: [<fa26a9d0>] __key.38684+0x0/0xffff0e77 [mac80211]
[43633.647009]  -> (&local->key_lock){......} ops: 0 {
[43633.647009]     INITIAL USE at:
[43633.647009]                                         [<c104c943>] __lock_acquire+0x61e/0x12d3
[43633.647009]                                         [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                         [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]                                         [<fa255f72>] ieee80211_todo_for_each_key+0x2e/0x79 [mac80211]
[43633.647009]                                         [<fa256054>] ieee80211_enable_keys+0x56/0x5b [mac80211]
[43633.647009]                                         [<fa24d7f4>] ieee80211_open+0x47a/0x5f4 [mac80211]
[43633.647009]                                         [<c123430c>] dev_open+0x8b/0xc0
[43633.647009]                                         [<c1233a5c>] dev_change_flags+0x9b/0x14c
[43633.647009]                                         [<c123b01d>] do_setlink+0x2a2/0x348
[43633.647009]                                         [<c123b1a8>] rtnl_setlink+0xe5/0xe9
[43633.647009]                                         [<c123bf67>] rtnetlink_rcv_msg+0x18a/0x1a0
[43633.647009]                                         [<c12442cc>] netlink_rcv_skb+0x35/0x7d
[43633.647009]                                         [<c123bdd6>] rtnetlink_rcv+0x20/0x27
[43633.647009]                                         [<c1243e4c>] netlink_unicast+0x1b1/0x212
[43633.647009]                                         [<c12440d0>] netlink_sendmsg+0x223/0x230
[43633.647009]                                         [<c1226655>] sock_sendmsg+0xcc/0xe2
[43633.647009]                                         [<c12267b9>] sys_sendmsg+0x14e/0x19b
[43633.647009]                                         [<c122770c>] sys_socketcall+0x147/0x170
[43633.647009]                                         [<c1002988>] sysenter_do_call+0x12/0x36
[43633.647009]                                         [<ffffffff>] 0xffffffff
[43633.647009]   }
[43633.647009]   ... key      at: [<fa26a9a0>] __key.38909+0x0/0xffff0ea7 [mac80211]
[43633.647009]   -> (todo_lock){+.+...} ops: 0 {
[43633.647009]      HARDIRQ-ON-W at:
[43633.647009]                                            [<c104c8d3>] __lock_acquire+0x5ae/0x12d3
[43633.647009]                                            [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                            [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                            [<fa255e06>] __ieee80211_key_todo+0x1cb/0x1ef [mac80211]
[43633.647009]                                            [<fa255f29>] ieee80211_key_todo+0x19/0x25 [mac80211]
[43633.647009]                                            [<fa255fb6>] ieee80211_todo_for_each_key+0x72/0x79 [mac80211]
[43633.647009]                                            [<fa256054>] ieee80211_enable_keys+0x56/0x5b [mac80211]
[43633.647009]                                            [<fa24d7f4>] ieee80211_open+0x47a/0x5f4 [mac80211]
[43633.647009]                                            [<c123430c>] dev_open+0x8b/0xc0
[43633.647009]                                            [<c1233a5c>] dev_change_flags+0x9b/0x14c
[43633.647009]                                            [<c123b01d>] do_setlink+0x2a2/0x348
[43633.647009]                                            [<c123b1a8>] rtnl_setlink+0xe5/0xe9
[43633.647009]                                            [<c123bf67>] rtnetlink_rcv_msg+0x18a/0x1a0
[43633.647009]                                            [<c12442cc>] netlink_rcv_skb+0x35/0x7d
[43633.647009]                                            [<c123bdd6>] rtnetlink_rcv+0x20/0x27
[43633.647009]                                            [<c1243e4c>] netlink_unicast+0x1b1/0x212
[43633.647009]                                            [<c12440d0>] netlink_sendmsg+0x223/0x230
[43633.647009]                                            [<c1226655>] sock_sendmsg+0xcc/0xe2
[43633.647009]                                            [<c12267b9>] sys_sendmsg+0x14e/0x19b
[43633.647009]                                            [<c122770c>] sys_socketcall+0x147/0x170
[43633.647009]                                            [<c1002988>] sysenter_do_call+0x12/0x36
[43633.647009]                                            [<ffffffff>] 0xffffffff
[43633.647009]      SOFTIRQ-ON-W at:
[43633.647009]                                            [<c104c8f2>] __lock_acquire+0x5cd/0x12d3
[43633.647009]                                            [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                            [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                            [<fa255e06>] __ieee80211_key_todo+0x1cb/0x1ef [mac80211]
[43633.647009]                                            [<fa255f29>] ieee80211_key_todo+0x19/0x25 [mac80211]
[43633.647009]                                            [<fa255fb6>] ieee80211_todo_for_each_key+0x72/0x79 [mac80211]
[43633.647009]                                            [<fa256054>] ieee80211_enable_keys+0x56/0x5b [mac80211]
[43633.647009]                                            [<fa24d7f4>] ieee80211_open+0x47a/0x5f4 [mac80211]
[43633.647009]                                            [<c123430c>] dev_open+0x8b/0xc0
[43633.647009]                                            [<c1233a5c>] dev_change_flags+0x9b/0x14c
[43633.647009]                                            [<c123b01d>] do_setlink+0x2a2/0x348
[43633.647009]                                            [<c123b1a8>] rtnl_setlink+0xe5/0xe9
[43633.647009]                                            [<c123bf67>] rtnetlink_rcv_msg+0x18a/0x1a0
[43633.647009]                                            [<c12442cc>] netlink_rcv_skb+0x35/0x7d
[43633.647009]                                            [<c123bdd6>] rtnetlink_rcv+0x20/0x27
[43633.647009]                                            [<c1243e4c>] netlink_unicast+0x1b1/0x212
[43633.647009]                                            [<c12440d0>] netlink_sendmsg+0x223/0x230
[43633.647009]                                            [<c1226655>] sock_sendmsg+0xcc/0xe2
[43633.647009]                                            [<c12267b9>] sys_sendmsg+0x14e/0x19b
[43633.647009]                                            [<c122770c>] sys_socketcall+0x147/0x170
[43633.647009]                                            [<c1002988>] sysenter_do_call+0x12/0x36
[43633.647009]                                            [<ffffffff>] 0xffffffff
[43633.647009]      INITIAL USE at:
[43633.647009]                                           [<c104c943>] __lock_acquire+0x61e/0x12d3
[43633.647009]                                           [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                           [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                           [<fa255e06>] __ieee80211_key_todo+0x1cb/0x1ef [mac80211]
[43633.647009]                                           [<fa255f29>] ieee80211_key_todo+0x19/0x25 [mac80211]
[43633.647009]                                           [<fa255fb6>] ieee80211_todo_for_each_key+0x72/0x79 [mac80211]
[43633.647009]                                           [<fa256054>] ieee80211_enable_keys+0x56/0x5b [mac80211]
[43633.647009]                                           [<fa24d7f4>] ieee80211_open+0x47a/0x5f4 [mac80211]
[43633.647009]                                           [<c123430c>] dev_open+0x8b/0xc0
[43633.647009]                                           [<c1233a5c>] dev_change_flags+0x9b/0x14c
[43633.647009]                                           [<c123b01d>] do_setlink+0x2a2/0x348
[43633.647009]                                           [<c123b1a8>] rtnl_setlink+0xe5/0xe9
[43633.647009]                                           [<c123bf67>] rtnetlink_rcv_msg+0x18a/0x1a0
[43633.647009]                                           [<c12442cc>] netlink_rcv_skb+0x35/0x7d
[43633.647009]                                           [<c123bdd6>] rtnetlink_rcv+0x20/0x27
[43633.647009]                                           [<c1243e4c>] netlink_unicast+0x1b1/0x212
[43633.647009]                                           [<c12440d0>] netlink_sendmsg+0x223/0x230
[43633.647009]                                           [<c1226655>] sock_sendmsg+0xcc/0xe2
[43633.647009]                                           [<c12267b9>] sys_sendmsg+0x14e/0x19b
[43633.647009]                                           [<c122770c>] sys_socketcall+0x147/0x170
[43633.647009]                                           [<c1002988>] sysenter_do_call+0x12/0x36
[43633.647009]                                           [<ffffffff>] 0xffffffff
[43633.647009]    }
[43633.647009]    ... key      at: [<fa26a70c>] todo_lock+0x10/0xffff114b [mac80211]
[43633.647009]    -> (&cwq->lock){-.-.-.} ops: 0 {
[43633.647009]       IN-HARDIRQ-W at:
[43633.647009]                                              [<c104c85e>] __lock_acquire+0x539/0x12d3
[43633.647009]                                              [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                              [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]                                              [<c10394e5>] __queue_work+0x17/0x34
[43633.647009]                                              [<c103957c>] queue_work_on+0x40/0x49
[43633.647009]                                              [<c10396a2>] queue_work+0x26/0x4a
[43633.647009]                                              [<c1175b27>] __acpi_os_execute+0xf1/0x119
[43633.647009]                                              [<c1175b75>] acpi_os_execute+0xf/0x11
[43633.647009]                                              [<c1179697>] acpi_ec_gpe_handler+0x6f/0xa3
[43633.647009]                                              [<c1184640>] acpi_ev_gpe_dispatch+0x51/0x10f
[43633.647009]                                              [<c118478a>] acpi_ev_gpe_detect+0x8c/0xce
[43633.647009]                                              [<c1182ae9>] acpi_ev_sci_xrupt_handler+0x1a/0x20
[43633.647009]                                              [<c1175373>] acpi_irq+0x13/0x2e
[43633.647009]                                              [<c105fcef>] handle_IRQ_event+0x6a/0x12f
[43633.647009]                                              [<c1061426>] handle_fasteoi_irq+0x7e/0xb5
[43633.647009]                                              [<c100489d>] handle_irq+0x40/0x4b
[43633.647009]                                              [<c100401c>] do_IRQ+0x49/0x9c
[43633.647009]                                              [<c100302e>] common_interrupt+0x2e/0x34
[43633.647009]                                              [<c1021bbc>] finish_task_switch+0x6c/0xe8
[43633.647009]                                              [<c129580d>] schedule+0x7af/0x81f
[43633.647009]                                              [<c1001c11>] cpu_idle+0x79/0x88
[43633.647009]                                              [<c12880c4>] rest_init+0x6c/0x6e
[43633.647009]                                              [<c1448753>] start_kernel+0x28b/0x290
[43633.647009]                                              [<c1448038>] __init_begin+0x38/0x40
[43633.647009]                                              [<ffffffff>] 0xffffffff
[43633.647009]       IN-SOFTIRQ-W at:
[43633.647009]                                              [<c104c87d>] __lock_acquire+0x558/0x12d3
[43633.647009]                                              [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                              [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]                                              [<c10394e5>] __queue_work+0x17/0x34
[43633.647009]                                              [<c103957c>] queue_work_on+0x40/0x49
[43633.647009]                                              [<c10396a2>] queue_work+0x26/0x4a
[43633.647009]                                              [<c113dd5e>] kblockd_schedule_work+0x12/0x14
[43633.647009]                                              [<c11496ac>] as_antic_timeout+0x58/0xa4
[43633.647009]                                              [<c10325ca>] run_timer_softirq+0x17b/0x1f0
[43633.647009]                                              [<c102e8d6>] __do_softirq+0xdb/0x1ac
[43633.647009]                                              [<c102e9d7>] do_softirq+0x30/0x48
[43633.647009]                                              [<c102eb53>] irq_exit+0x3d/0x74
[43633.647009]                                              [<c10121a6>] smp_apic_timer_interrupt+0x73/0x81
[43633.647009]                                              [<c100333b>] apic_timer_interrupt+0x2f/0x34
[43633.647009]                                              [<c1001beb>] cpu_idle+0x53/0x88
[43633.647009]                                              [<c12880c4>] rest_init+0x6c/0x6e
[43633.647009]                                              [<c1448753>] start_kernel+0x28b/0x290
[43633.647009]                                              [<c1448038>] __init_begin+0x38/0x40
[43633.647009]                                              [<ffffffff>] 0xffffffff
[43633.647009]       IN-RECLAIM_FS-W at:
[43633.647009]                                                 [<c104c92d>] __lock_acquire+0x608/0x12d3
[43633.647009]                                                 [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                 [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]                                                 [<c10394e5>] __queue_work+0x17/0x34
[43633.647009]                                                 [<c103957c>] queue_work_on+0x40/0x49
[43633.647009]                                                 [<c10396a2>] queue_work+0x26/0x4a
[43633.647009]                                                 [<c113dd5e>] kblockd_schedule_work+0x12/0x14
[43633.647009]                                                 [<c113e21f>] blk_unplug_timeout+0x57/0x5b
[43633.647009]                                                 [<c10325ca>] run_timer_softirq+0x17b/0x1f0
[43633.647009]                                                 [<c102e8d6>] __do_softirq+0xdb/0x1ac
[43633.647009]                                                 [<c102e9d7>] do_softirq+0x30/0x48
[43633.647009]                                                 [<c102eb53>] irq_exit+0x3d/0x74
[43633.647009]                                                 [<c10121a6>] smp_apic_timer_interrupt+0x73/0x81
[43633.647009]                                                 [<c100333b>] apic_timer_interrupt+0x2f/0x34
[43633.647009]                                                 [<c10adf79>] destroy_inode+0x32/0x35
[43633.647009]                                                 [<c10ae3fa>] generic_delete_inode+0xe4/0xe8
[43633.647009]                                                 [<c10ad740>] iput+0x50/0x53
[43633.647009]                                                 [<c10dbd0d>] sysfs_d_iput+0x28/0x2b
[43633.647009]                                                 [<c10ab44e>] dentry_iput+0x96/0xb8
[43633.647009]                                                 [<c10ab50d>] d_kill+0x21/0x3b
[43633.647009]                                                 [<c10ab6fa>] __shrink_dcache_sb+0x1d3/0x255
[43633.647009]                                                 [<c10ab855>] shrink_dcache_memory+0xd9/0x15e
[43633.647009]                                                 [<c108321b>] shrink_slab+0xda/0x15f
[43633.647009]                                                 [<c10836a1>] kswapd+0x401/0x587
[43633.647009]                                                 [<c103c78b>] kthread+0x70/0x75
[43633.647009]                                                 [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]                                                 [<ffffffff>] 0xffffffff
[43633.647009]       INITIAL USE at:
[43633.647009]                                             [<c104c943>] __lock_acquire+0x61e/0x12d3
[43633.647009]                                             [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                             [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]                                             [<c10394e5>] __queue_work+0x17/0x34
[43633.647009]                                             [<c103957c>] queue_work_on+0x40/0x49
[43633.647009]                                             [<c10396a2>] queue_work+0x26/0x4a
[43633.647009]                                             [<c1037fe7>] call_usermodehelper_exec+0x8f/0xe1
[43633.647009]                                             [<c114f357>] kobject_uevent_env+0x333/0x368
[43633.647009]                                             [<c114f396>] kobject_uevent+0xa/0xc
[43633.647009]                                             [<c114eb0c>] kset_register+0x2e/0x34
[43633.647009]                                             [<c11b74fe>] bus_register+0xe4/0x232
[43633.647009]                                             [<c146315e>] platform_bus_init+0x23/0x38
[43633.647009]                                             [<c14631f6>] driver_init+0x1c/0x28
[43633.647009]                                             [<c144828c>] kernel_init+0xf2/0x16a
[43633.647009]                                             [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]                                             [<ffffffff>] 0xffffffff
[43633.647009]     }
[43633.647009]     ... key      at: [<c16231b4>] __key.25893+0x0/0x8
[43633.647009]     -> (key#3){-.-.-.} ops: 0 {
[43633.647009]        IN-HARDIRQ-W at:
[43633.647009]                                                [<c104c85e>] __lock_acquire+0x539/0x12d3
[43633.647009]                                                [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]                                                [<c101d543>] __wake_up+0x1a/0x40
[43633.647009]                                                [<c1038ccd>] insert_work+0x9a/0xa3
[43633.647009]                                                [<c10394f4>] __queue_work+0x26/0x34
[43633.647009]                                                [<c103957c>] queue_work_on+0x40/0x49
[43633.647009]                                                [<c10396a2>] queue_work+0x26/0x4a
[43633.647009]                                                [<c1175b27>] __acpi_os_execute+0xf1/0x119
[43633.647009]                                                [<c1175b75>] acpi_os_execute+0xf/0x11
[43633.647009]                                                [<c1179697>] acpi_ec_gpe_handler+0x6f/0xa3
[43633.647009]                                                [<c1184640>] acpi_ev_gpe_dispatch+0x51/0x10f
[43633.647009]                                                [<c118478a>] acpi_ev_gpe_detect+0x8c/0xce
[43633.647009]                                                [<c1182ae9>] acpi_ev_sci_xrupt_handler+0x1a/0x20
[43633.647009]                                                [<c1175373>] acpi_irq+0x13/0x2e
[43633.647009]                                                [<c105fcef>] handle_IRQ_event+0x6a/0x12f
[43633.647009]                                                [<c1061426>] handle_fasteoi_irq+0x7e/0xb5
[43633.647009]                                                [<c100489d>] handle_irq+0x40/0x4b
[43633.647009]                                                [<c100401c>] do_IRQ+0x49/0x9c
[43633.647009]                                                [<c100302e>] common_interrupt+0x2e/0x34
[43633.647009]                                                [<c1021bbc>] finish_task_switch+0x6c/0xe8
[43633.647009]                                                [<c129580d>] schedule+0x7af/0x81f
[43633.647009]                                                [<c1001c11>] cpu_idle+0x79/0x88
[43633.647009]                                                [<c12880c4>] rest_init+0x6c/0x6e
[43633.647009]                                                [<c1448753>] start_kernel+0x28b/0x290
[43633.647009]                                                [<c1448038>] __init_begin+0x38/0x40
[43633.647009]                                                [<ffffffff>] 0xffffffff
[43633.647009]        IN-SOFTIRQ-W at:
[43633.647009]                                                [<c104c87d>] __lock_acquire+0x558/0x12d3
[43633.647009]                                                [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]                                                [<c101d543>] __wake_up+0x1a/0x40
[43633.647009]                                                [<c1038ccd>] insert_work+0x9a/0xa3
[43633.647009]                                                [<c10394f4>] __queue_work+0x26/0x34
[43633.647009]                                                [<c103957c>] queue_work_on+0x40/0x49
[43633.647009]                                                [<c10396a2>] queue_work+0x26/0x4a
[43633.647009]                                                [<c113dd5e>] kblockd_schedule_work+0x12/0x14
[43633.647009]                                                [<c11496ac>] as_antic_timeout+0x58/0xa4
[43633.647009]                                                [<c10325ca>] run_timer_softirq+0x17b/0x1f0
[43633.647009]                                                [<c102e8d6>] __do_softirq+0xdb/0x1ac
[43633.647009]                                                [<c102e9d7>] do_softirq+0x30/0x48
[43633.647009]                                                [<c102eb53>] irq_exit+0x3d/0x74
[43633.647009]                                                [<c10121a6>] smp_apic_timer_interrupt+0x73/0x81
[43633.647009]                                                [<c100333b>] apic_timer_interrupt+0x2f/0x34
[43633.647009]                                                [<c1001beb>] cpu_idle+0x53/0x88
[43633.647009]                                                [<c12880c4>] rest_init+0x6c/0x6e
[43633.647009]                                                [<c1448753>] start_kernel+0x28b/0x290
[43633.647009]                                                [<c1448038>] __init_begin+0x38/0x40
[43633.647009]                                                [<ffffffff>] 0xffffffff
[43633.647009]        IN-RECLAIM_FS-W at:
[43633.647009]                                                   [<c104c92d>] __lock_acquire+0x608/0x12d3
[43633.647009]                                                   [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                   [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]                                                   [<c101d543>] __wake_up+0x1a/0x40
[43633.647009]                                                   [<c1038ccd>] insert_work+0x9a/0xa3
[43633.647009]                                                   [<c10394f4>] __queue_work+0x26/0x34
[43633.647009]                                                   [<c103957c>] queue_work_on+0x40/0x49
[43633.647009]                                                   [<c10396a2>] queue_work+0x26/0x4a
[43633.647009]                                                   [<c113dd5e>] kblockd_schedule_work+0x12/0x14
[43633.647009]                                                   [<c113e21f>] blk_unplug_timeout+0x57/0x5b
[43633.647009]                                                   [<c10325ca>] run_timer_softirq+0x17b/0x1f0
[43633.647009]                                                   [<c102e8d6>] __do_softirq+0xdb/0x1ac
[43633.647009]                                                   [<c102e9d7>] do_softirq+0x30/0x48
[43633.647009]                                                   [<c102eb53>] irq_exit+0x3d/0x74
[43633.647009]                                                   [<c10121a6>] smp_apic_timer_interrupt+0x73/0x81
[43633.647009]                                                   [<c100333b>] apic_timer_interrupt+0x2f/0x34
[43633.647009]                                                   [<c10adf79>] destroy_inode+0x32/0x35
[43633.647009]                                                   [<c10ae3fa>] generic_delete_inode+0xe4/0xe8
[43633.647009]                                                   [<c10ad740>] iput+0x50/0x53
[43633.647009]                                                   [<c10dbd0d>] sysfs_d_iput+0x28/0x2b
[43633.647009]                                                   [<c10ab44e>] dentry_iput+0x96/0xb8
[43633.647009]                                                   [<c10ab50d>] d_kill+0x21/0x3b
[43633.647009]                                                   [<c10ab6fa>] __shrink_dcache_sb+0x1d3/0x255
[43633.647009]                                                   [<c10ab855>] shrink_dcache_memory+0xd9/0x15e
[43633.647009]                                                   [<c108321b>] shrink_slab+0xda/0x15f
[43633.647009]                                                   [<c10836a1>] kswapd+0x401/0x587
[43633.647009]                                                   [<c103c78b>] kthread+0x70/0x75
[43633.647009]                                                   [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]                                                   [<ffffffff>] 0xffffffff
[43633.647009]        INITIAL USE at:
[43633.647009]                                               [<c104c943>] __lock_acquire+0x61e/0x12d3
[43633.647009]                                               [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                               [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]                                               [<c103cc23>] prepare_to_wait+0x1c/0x4c
[43633.647009]                                               [<c1038962>] worker_thread+0x78/0x287
[43633.647009]                                               [<c103c78b>] kthread+0x70/0x75
[43633.647009]                                               [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]                                               [<ffffffff>] 0xffffffff
[43633.647009]      }
[43633.647009]      ... key      at: [<c16231ac>] __key.25894+0x0/0x8
[43633.647009]      -> (&rq->lock){-.-.-.} ops: 0 {
[43633.647009]         IN-HARDIRQ-W at:
[43633.647009]                                                  [<c104c85e>] __lock_acquire+0x539/0x12d3
[43633.647009]                                                  [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                  [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                                  [<c1026192>] scheduler_tick+0x36/0x1dc
[43633.647009]                                                  [<c1032ca6>] update_process_times+0x47/0x53
[43633.647009]                                                  [<c1046e81>] tick_periodic+0x6c/0x79
[43633.647009]                                                  [<c1046eab>] tick_handle_periodic+0x1d/0x76
[43633.647009]                                                  [<c1004c76>] timer_interrupt+0x3e/0x45
[43633.647009]                                                  [<c105fcef>] handle_IRQ_event+0x6a/0x12f
[43633.647009]                                                  [<c10614e4>] handle_level_irq+0x87/0xcd
[43633.647009]                                                  [<c100489d>] handle_irq+0x40/0x4b
[43633.647009]                                                  [<c100401c>] do_IRQ+0x49/0x9c
[43633.647009]                                                  [<c100302e>] common_interrupt+0x2e/0x34
[43633.647009]                                                  [<c114dc68>] get_from_free_list+0x32/0x39
[43633.647009]                                                  [<c114dda8>] idr_get_empty_slot+0x26/0x1e7
[43633.647009]                                                  [<c114df99>] ida_get_new_above+0x30/0x166
[43633.647009]                                                  [<c10b18f0>] alloc_vfsmnt+0x57/0x11d
[43633.647009]                                                  [<c109f585>] vfs_kern_mount+0x2b/0x7b
[43633.647009]                                                  [<c109f5ea>] kern_mount_data+0x15/0x17
[43633.647009]                                                  [<c145d44f>] sysfs_init+0x50/0xa0
[43633.647009]                                                  [<c145c95b>] mnt_init+0x87/0x147
[43633.647009]                                                  [<c145c634>] vfs_caches_init+0xd9/0xeb
[43633.647009]                                                  [<c144872b>] start_kernel+0x263/0x290
[43633.647009]                                                  [<c1448038>] __init_begin+0x38/0x40
[43633.647009]                                                  [<ffffffff>] 0xffffffff
[43633.647009]         IN-SOFTIRQ-W at:
[43633.647009]                                                  [<c104c87d>] __lock_acquire+0x558/0x12d3
[43633.647009]                                                  [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                  [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                                  [<c101d62c>] task_rq_lock+0x3b/0x65
[43633.647009]                                                  [<c10228b1>] try_to_wake_up+0x31/0x20b
[43633.647009]                                                  [<c1022ac2>] wake_up_process+0x14/0x16
[43633.647009]                                                  [<c1032b63>] process_timeout+0xd/0xf
[43633.647009]                                                  [<c10325ca>] run_timer_softirq+0x17b/0x1f0
[43633.647009]                                                  [<c102e8d6>] __do_softirq+0xdb/0x1ac
[43633.647009]                                                  [<c102e9d7>] do_softirq+0x30/0x48
[43633.647009]                                                  [<c102eb53>] irq_exit+0x3d/0x74
[43633.647009]                                                  [<c10121a6>] smp_apic_timer_interrupt+0x73/0x81
[43633.647009]                                                  [<c100333b>] apic_timer_interrupt+0x2f/0x34
[43633.647009]                                                  [<c1001beb>] cpu_idle+0x53/0x88
[43633.647009]                                                  [<c12880c4>] rest_init+0x6c/0x6e
[43633.647009]                                                  [<c1448753>] start_kernel+0x28b/0x290
[43633.647009]                                                  [<c1448038>] __init_begin+0x38/0x40
[43633.647009]                                                  [<ffffffff>] 0xffffffff
[43633.647009]         IN-RECLAIM_FS-W at:
[43633.647009]                                                     [<c104c92d>] __lock_acquire+0x608/0x12d3
[43633.647009]                                                     [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                     [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                                     [<c101d62c>] task_rq_lock+0x3b/0x65
[43633.647009]                                                     [<c1025e97>] set_cpus_allowed_ptr+0x1a/0xdc
[43633.647009]                                                     [<c10832fe>] kswapd+0x5e/0x587
[43633.647009]                                                     [<c103c78b>] kthread+0x70/0x75
[43633.647009]                                                     [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]                                                     [<ffffffff>] 0xffffffff
[43633.647009]         INITIAL USE at:
[43633.647009]                                                 [<c104c943>] __lock_acquire+0x61e/0x12d3
[43633.647009]                                                 [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                 [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]                                                 [<c1020b4d>] rq_attach_root+0x17/0xa9
[43633.647009]                                                 [<c1456efd>] sched_init+0x290/0x3a1
[43633.647009]                                                 [<c1448625>] start_kernel+0x15d/0x290
[43633.647009]                                                 [<c1448038>] __init_begin+0x38/0x40
[43633.647009]                                                 [<ffffffff>] 0xffffffff
[43633.647009]       }
[43633.647009]       ... key      at: [<c15e035c>] __key.51718+0x0/0x8
[43633.647009]       -> (&vec->lock){..-...} ops: 0 {
[43633.647009]          IN-SOFTIRQ-W at:
[43633.647009]                                                    [<c104c87d>] __lock_acquire+0x558/0x12d3
[43633.647009]                                                    [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                    [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]                                                    [<c1078184>] cpupri_set+0x66/0xf0
[43633.647009]                                                    [<c1027584>] enqueue_task_rt+0xd3/0x232
[43633.647009]                                                    [<c101ad56>] enqueue_task+0x2f/0x3b
[43633.647009]                                                    [<c101ae2c>] activate_task+0x24/0x2a
[43633.647009]                                                    [<c102294b>] try_to_wake_up+0xcb/0x20b
[43633.647009]                                                    [<c1022ac2>] wake_up_process+0x14/0x16
[43633.647009]                                                    [<c1025cf7>] rebalance_domains+0x2d7/0x3b6
[43633.647009]                                                    [<c1025e0a>] run_rebalance_domains+0x34/0xa7
[43633.647009]                                                    [<c102e8d6>] __do_softirq+0xdb/0x1ac
[43633.647009]                                                    [<c102e9d7>] do_softirq+0x30/0x48
[43633.647009]                                                    [<c102eb53>] irq_exit+0x3d/0x74
[43633.647009]                                                    [<c10121a6>] smp_apic_timer_interrupt+0x73/0x81
[43633.647009]                                                    [<c100333b>] apic_timer_interrupt+0x2f/0x34
[43633.647009]                                                    [<c1214ab7>] cpuidle_idle_call+0x6a/0xa3
[43633.647009]                                                    [<c1001beb>] cpu_idle+0x53/0x88
[43633.647009]                                                    [<c12927c1>] start_secondary+0x1ad/0x1b4
[43633.647009]                                                    [<ffffffff>] 0xffffffff
[43633.647009]          INITIAL USE at:
[43633.647009]                                                   [<c104c943>] __lock_acquire+0x61e/0x12d3
[43633.647009]                                                   [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                   [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]                                                   [<c10781c7>] cpupri_set+0xa9/0xf0
[43633.647009]                                                   [<c101f880>] rq_online_rt+0x5e/0x61
[43633.647009]                                                   [<c101cdc8>] set_rq_online+0x40/0x4a
[43633.647009]                                                   [<c1020bbc>] rq_attach_root+0x86/0xa9
[43633.647009]                                                   [<c1456efd>] sched_init+0x290/0x3a1
[43633.647009]                                                   [<c1448625>] start_kernel+0x15d/0x290
[43633.647009]                                                   [<c1448038>] __init_begin+0x38/0x40
[43633.647009]                                                   [<ffffffff>] 0xffffffff
[43633.647009]        }
[43633.647009]        ... key      at: [<c1b5e218>] __key.14809+0x0/0x28
[43633.647009]       ... acquired at:
[43633.647009]    [<c104d315>] __lock_acquire+0xff0/0x12d3
[43633.647009]    [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]    [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]    [<c10781c7>] cpupri_set+0xa9/0xf0
[43633.647009]    [<c101f880>] rq_online_rt+0x5e/0x61
[43633.647009]    [<c101cdc8>] set_rq_online+0x40/0x4a
[43633.647009]    [<c1020bbc>] rq_attach_root+0x86/0xa9
[43633.647009]    [<c1456efd>] sched_init+0x290/0x3a1
[43633.647009]    [<c1448625>] start_kernel+0x15d/0x290
[43633.647009]    [<c1448038>] __init_begin+0x38/0x40
[43633.647009]    [<ffffffff>] 0xffffffff
[43633.647009] 
[43633.647009]       -> (&rt_b->rt_runtime_lock){..-...} ops: 0 {
[43633.647009]          IN-SOFTIRQ-W at:
[43633.647009]                                                    [<c104c87d>] __lock_acquire+0x558/0x12d3
[43633.647009]                                                    [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                    [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                                    [<c1027611>] enqueue_task_rt+0x160/0x232
[43633.647009]                                                    [<c101ad56>] enqueue_task+0x2f/0x3b
[43633.647009]                                                    [<c101ae2c>] activate_task+0x24/0x2a
[43633.647009]                                                    [<c102294b>] try_to_wake_up+0xcb/0x20b
[43633.647009]                                                    [<c1022ac2>] wake_up_process+0x14/0x16
[43633.647009]                                                    [<c1025cf7>] rebalance_domains+0x2d7/0x3b6
[43633.647009]                                                    [<c1025e0a>] run_rebalance_domains+0x34/0xa7
[43633.647009]                                                    [<c102e8d6>] __do_softirq+0xdb/0x1ac
[43633.647009]                                                    [<c102e9d7>] do_softirq+0x30/0x48
[43633.647009]                                                    [<c102eb53>] irq_exit+0x3d/0x74
[43633.647009]                                                    [<c10121a6>] smp_apic_timer_interrupt+0x73/0x81
[43633.647009]                                                    [<c100333b>] apic_timer_interrupt+0x2f/0x34
[43633.647009]                                                    [<c1214ab7>] cpuidle_idle_call+0x6a/0xa3
[43633.647009]                                                    [<c1001beb>] cpu_idle+0x53/0x88
[43633.647009]                                                    [<c12927c1>] start_secondary+0x1ad/0x1b4
[43633.647009]                                                    [<ffffffff>] 0xffffffff
[43633.647009]          INITIAL USE at:
[43633.647009]                                                   [<c104c943>] __lock_acquire+0x61e/0x12d3
[43633.647009]                                                   [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                   [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                                   [<c1027611>] enqueue_task_rt+0x160/0x232
[43633.647009]                                                   [<c101ad56>] enqueue_task+0x2f/0x3b
[43633.647009]                                                   [<c101ae2c>] activate_task+0x24/0x2a
[43633.647009]                                                   [<c102294b>] try_to_wake_up+0xcb/0x20b
[43633.647009]                                                   [<c1022ac2>] wake_up_process+0x14/0x16
[43633.647009]                                                   [<c1293248>] migration_call+0xbc/0x470
[43633.647009]                                                   [<c1457218>] migration_init+0x3b/0x4b
[43633.647009]                                                   [<c1001141>] do_one_initcall+0x4f/0x116
[43633.647009]                                                   [<c14481e7>] kernel_init+0x4d/0x16a
[43633.647009]                                                   [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]                                                   [<ffffffff>] 0xffffffff
[43633.647009]        }
[43633.647009]        ... key      at: [<c15e0364>] __key.41387+0x0/0x8
[43633.647009]        -> (&cpu_base->lock){-.-.-.} ops: 0 {
[43633.647009]           IN-HARDIRQ-W at:
[43633.647009]                                                      [<c104c85e>] __lock_acquire+0x539/0x12d3
[43633.647009]                                                      [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                      [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                                      [<c103f3a0>] hrtimer_run_queues+0xde/0x11c
[43633.647009]                                                      [<c1032c4e>] run_local_timers+0xd/0x1e
[43633.647009]                                                      [<c1032c88>] update_process_times+0x29/0x53
[43633.647009]                                                      [<c1046e81>] tick_periodic+0x6c/0x79
[43633.647009]                                                      [<c1046eab>] tick_handle_periodic+0x1d/0x76
[43633.647009]                                                      [<c10121a1>] smp_apic_timer_interrupt+0x6e/0x81
[43633.647009]                                                      [<c100333b>] apic_timer_interrupt+0x2f/0x34
[43633.647009]                                                      [<c10991d4>] cache_alloc_debugcheck_after+0x5d/0x194
[43633.647009]                                                      [<c109aa5f>] kmem_cache_alloc+0xd4/0x16e
[43633.647009]                                                      [<c109a3f6>] cache_alloc_refill+0x371/0x5c3
[43633.647009]                                                      [<c109a8d2>] __kmalloc+0xea/0x1a3
[43633.647009]                                                      [<c109adc3>] alloc_arraycache+0x1e/0x50
[43633.647009]                                                      [<c129484a>] cpuup_callback+0x14d/0x261
[43633.647009]                                                      [<c1299ed1>] notifier_call_chain+0x51/0x7e
[43633.647009]                                                      [<c104082e>] __raw_notifier_call_chain+0x13/0x15
[43633.647009]                                                      [<c12936d4>] _cpu_up+0x62/0x105
[43633.647009]                                                      [<c12937c3>] cpu_up+0x4c/0x5c
[43633.647009]                                                      [<c1448233>] kernel_init+0x99/0x16a
[43633.647009]                                                      [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]                                                      [<ffffffff>] 0xffffffff
[43633.647009]           IN-SOFTIRQ-W at:
[43633.647009]                                                      [<c104c87d>] __lock_acquire+0x558/0x12d3
[43633.647009]                                                      [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                      [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]                                                      [<c103f695>] lock_hrtimer_base+0x1d/0x38
[43633.647009]                                                      [<c103f7b8>] __hrtimer_start_range_ns+0x34/0x326
[43633.647009]                                                      [<c103fade>] hrtimer_start_range_ns+0x18/0x1d
[43633.647009]                                                      [<c1047f3e>] tick_setup_sched_timer+0x10b/0x133
[43633.647009]                                                      [<c103f536>] hrtimer_run_pending+0xb7/0xed
[43633.647009]                                                      [<c1032476>] run_timer_softirq+0x27/0x1f0
[43633.647009]                                                      [<c102e8d6>] __do_softirq+0xdb/0x1ac
[43633.647009]                                                      [<c102e9d7>] do_softirq+0x30/0x48
[43633.647009]                                                      [<c102eb53>] irq_exit+0x3d/0x74
[43633.647009]                                                      [<c10121a6>] smp_apic_timer_interrupt+0x73/0x81
[43633.647009]                                                      [<c100333b>] apic_timer_interrupt+0x2f/0x34
[43633.647009]                                                      [<c1001beb>] cpu_idle+0x53/0x88
[43633.647009]                                                      [<c12927c1>] start_secondary+0x1ad/0x1b4
[43633.647009]                                                      [<ffffffff>] 0xffffffff
[43633.647009]           IN-RECLAIM_FS-W at:
[43633.647009]                                                         [<c104c92d>] __lock_acquire+0x608/0x12d3
[43633.647009]                                                         [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                         [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                                         [<c103fdf4>] hrtimer_interrupt+0xad/0x16c
[43633.647009]                                                         [<c10121a1>] smp_apic_timer_interrupt+0x6e/0x81
[43633.647009]                                                         [<c100333b>] apic_timer_interrupt+0x2f/0x34
[43633.647009]                                                         [<c103c78b>] kthread+0x70/0x75
[43633.647009]                                                         [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]                                                         [<ffffffff>] 0xffffffff
[43633.647009]           INITIAL USE at:
[43633.647009]                                                     [<c104c943>] __lock_acquire+0x61e/0x12d3
[43633.647009]                                                     [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                     [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]                                                     [<c103f695>] lock_hrtimer_base+0x1d/0x38
[43633.647009]                                                     [<c103f7b8>] __hrtimer_start_range_ns+0x34/0x326
[43633.647009]                                                     [<c1027662>] enqueue_task_rt+0x1b1/0x232
[43633.647009]                                                     [<c101ad56>] enqueue_task+0x2f/0x3b
[43633.647009]                                                     [<c101ae2c>] activate_task+0x24/0x2a
[43633.647009]                                                     [<c102294b>] try_to_wake_up+0xcb/0x20b
[43633.647009]                                                     [<c1022ac2>] wake_up_process+0x14/0x16
[43633.647009]                                                     [<c1293248>] migration_call+0xbc/0x470
[43633.647009]                                                     [<c1457218>] migration_init+0x3b/0x4b
[43633.647009]                                                     [<c1001141>] do_one_initcall+0x4f/0x116
[43633.647009]                                                     [<c14481e7>] kernel_init+0x4d/0x16a
[43633.647009]                                                     [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]                                                     [<ffffffff>] 0xffffffff
[43633.647009]         }
[43633.647009]         ... key      at: [<c1623538>] __key.20989+0x0/0x8
[43633.647009]         -> (&cpu_base->lock/1){......} ops: 0 {
[43633.647009]            INITIAL USE at:
[43633.647009]                                                       [<c104c943>] __lock_acquire+0x61e/0x12d3
[43633.647009]                                                       [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                       [<c12979f0>] _spin_lock_nested+0x34/0x64
[43633.647009]                                                       [<c1293ed9>] hrtimer_cpu_notify+0xf5/0x17d
[43633.647009]                                                       [<c1299ed1>] notifier_call_chain+0x51/0x7e
[43633.647009]                                                       [<c1040841>] raw_notifier_call_chain+0x11/0x13
[43633.647009]                                                       [<c128883f>] _cpu_down+0x16f/0x23a
[43633.647009]                                                       [<c102ad11>] disable_nonboot_cpus+0x5d/0xf4
[43633.647009]                                                       [<c1057a92>] suspend_devices_and_enter+0xbe/0x178
[43633.647009]                                                       [<c1057c19>] enter_state+0xcd/0x119
[43633.647009]                                                       [<c10573d5>] state_store+0x98/0xac
[43633.647009]                                                       [<c114e6b5>] kobj_attr_store+0x16/0x22
[43633.647009]                                                       [<c10daed5>] sysfs_write_file+0xcd/0xf8
[43633.647009]                                                       [<c109e7af>] vfs_write+0x8f/0x117
[43633.647009]                                                       [<c109e8f3>] sys_write+0x48/0x75
[43633.647009]                                                       [<c1002988>] sysenter_do_call+0x12/0x36
[43633.647009]                                                       [<ffffffff>] 0xffffffff
[43633.647009]          }
[43633.647009]          ... key      at: [<c1623539>] __key.20989+0x1/0x8
[43633.647009]         ... acquired at:
[43633.647009]    [<c104d315>] __lock_acquire+0xff0/0x12d3
[43633.647009]    [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]    [<c12979f0>] _spin_lock_nested+0x34/0x64
[43633.647009]    [<c1293ed9>] hrtimer_cpu_notify+0xf5/0x17d
[43633.647009]    [<c1299ed1>] notifier_call_chain+0x51/0x7e
[43633.647009]    [<c1040841>] raw_notifier_call_chain+0x11/0x13
[43633.647009]    [<c128883f>] _cpu_down+0x16f/0x23a
[43633.647009]    [<c102ad11>] disable_nonboot_cpus+0x5d/0xf4
[43633.647009]    [<c1057a92>] suspend_devices_and_enter+0xbe/0x178
[43633.647009]    [<c1057c19>] enter_state+0xcd/0x119
[43633.647009]    [<c10573d5>] state_store+0x98/0xac
[43633.647009]    [<c114e6b5>] kobj_attr_store+0x16/0x22
[43633.647009]    [<c10daed5>] sysfs_write_file+0xcd/0xf8
[43633.647009]    [<c109e7af>] vfs_write+0x8f/0x117
[43633.647009]    [<c109e8f3>] sys_write+0x48/0x75
[43633.647009]    [<c1002988>] sysenter_do_call+0x12/0x36
[43633.647009]    [<ffffffff>] 0xffffffff
[43633.647009] 
[43633.647009]        ... acquired at:
[43633.647009]    [<c104d315>] __lock_acquire+0xff0/0x12d3
[43633.647009]    [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]    [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]    [<c103f695>] lock_hrtimer_base+0x1d/0x38
[43633.647009]    [<c103f7b8>] __hrtimer_start_range_ns+0x34/0x326
[43633.647009]    [<c1027662>] enqueue_task_rt+0x1b1/0x232
[43633.647009]    [<c101ad56>] enqueue_task+0x2f/0x3b
[43633.647009]    [<c101ae2c>] activate_task+0x24/0x2a
[43633.647009]    [<c102294b>] try_to_wake_up+0xcb/0x20b
[43633.647009]    [<c1022ac2>] wake_up_process+0x14/0x16
[43633.647009]    [<c1293248>] migration_call+0xbc/0x470
[43633.647009]    [<c1457218>] migration_init+0x3b/0x4b
[43633.647009]    [<c1001141>] do_one_initcall+0x4f/0x116
[43633.647009]    [<c14481e7>] kernel_init+0x4d/0x16a
[43633.647009]    [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]    [<ffffffff>] 0xffffffff
[43633.647009] 
[43633.647009]        -> (&rt_rq->rt_runtime_lock){-.-...} ops: 0 {
[43633.647009]           IN-HARDIRQ-W at:
[43633.647009]                                                      [<c104c85e>] __lock_acquire+0x539/0x12d3
[43633.647009]                                                      [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                      [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                                      [<c101f3eb>] update_curr_rt+0x123/0x1b0
[43633.647009]                                                      [<c101f48c>] task_tick_rt+0x14/0xb1
[43633.647009]                                                      [<c1026234>] scheduler_tick+0xd8/0x1dc
[43633.647009]                                                      [<c1032ca6>] update_process_times+0x47/0x53
[43633.647009]                                                      [<c1047d9b>] tick_sched_timer+0x71/0x9f
[43633.647009]                                                      [<c103f290>] __run_hrtimer+0x6b/0x9d
[43633.647009]                                                      [<c103fe59>] hrtimer_interrupt+0x112/0x16c
[43633.647009]                                                      [<c10121a1>] smp_apic_timer_interrupt+0x6e/0x81
[43633.647009]                                                      [<c100333b>] apic_timer_interrupt+0x2f/0x34
[43633.647009]                                                      [<c1038a94>] worker_thread+0x1aa/0x287
[43633.647009]                                                      [<c103c78b>] kthread+0x70/0x75
[43633.647009]                                                      [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]                                                      [<ffffffff>] 0xffffffff
[43633.647009]           IN-SOFTIRQ-W at:
[43633.647009]                                                      [<c104c87d>] __lock_acquire+0x558/0x12d3
[43633.647009]                                                      [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                      [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                                      [<c101fc8f>] sched_rt_period_timer+0xbc/0x201
[43633.647009]                                                      [<c103f290>] __run_hrtimer+0x6b/0x9d
[43633.647009]                                                      [<c103fe59>] hrtimer_interrupt+0x112/0x16c
[43633.647009]                                                      [<c1047138>] tick_do_broadcast+0x32/0x5b
[43633.647009]                                                      [<c1047210>] tick_handle_oneshot_broadcast+0xaf/0xe7
[43633.647009]                                                      [<c1004c76>] timer_interrupt+0x3e/0x45
[43633.647009]                                                      [<c105fcef>] handle_IRQ_event+0x6a/0x12f
[43633.647009]                                                      [<c1061365>] handle_edge_irq+0xcf/0x112
[43633.647009]                                                      [<c100489d>] handle_irq+0x40/0x4b
[43633.647009]                                                      [<c100401c>] do_IRQ+0x49/0x9c
[43633.647009]                                                      [<c100302e>] common_interrupt+0x2e/0x34
[43633.647009]                                                      [<c102e9d7>] do_softirq+0x30/0x48
[43633.647009]                                                      [<c102eb53>] irq_exit+0x3d/0x74
[43633.647009]                                                      [<c100405b>] do_IRQ+0x88/0x9c
[43633.647009]                                                      [<c100302e>] common_interrupt+0x2e/0x34
[43633.647009]                                                      [<c1214ab7>] cpuidle_idle_call+0x6a/0xa3
[43633.647009]                                                      [<c1001beb>] cpu_idle+0x53/0x88
[43633.647009]                                                      [<c12880c4>] rest_init+0x6c/0x6e
[43633.647009]                                                      [<c1448753>] start_kernel+0x28b/0x290
[43633.647009]                                                      [<c1448038>] __init_begin+0x38/0x40
[43633.647009]                                                      [<ffffffff>] 0xffffffff
[43633.647009]           INITIAL USE at:
[43633.647009]                                                     [<c104c943>] __lock_acquire+0x61e/0x12d3
[43633.647009]                                                     [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                     [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                                     [<c101f3eb>] update_curr_rt+0x123/0x1b0
[43633.647009]                                                     [<c101fa28>] dequeue_task_rt+0x22/0x62
[43633.647009]                                                     [<c101adfa>] dequeue_task+0x98/0xa6
[43633.647009]                                                     [<c101ae56>] deactivate_task+0x24/0x2a
[43633.647009]                                                     [<c129519c>] schedule+0x13e/0x81f
[43633.647009]                                                     [<c10259bb>] migration_thread+0x179/0x1de
[43633.647009]                                                     [<c103c78b>] kthread+0x70/0x75
[43633.647009]                                                     [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]                                                     [<ffffffff>] 0xffffffff
[43633.647009]         }
[43633.647009]         ... key      at: [<c15e036c>] __key.51698+0x0/0x8
[43633.647009]        ... acquired at:
[43633.647009]    [<c104d315>] __lock_acquire+0xff0/0x12d3
[43633.647009]    [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]    [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]    [<c101dc40>] __enable_runtime+0x34/0x7f
[43633.647009]    [<c101f866>] rq_online_rt+0x44/0x61
[43633.647009]    [<c101cdc8>] set_rq_online+0x40/0x4a
[43633.647009]    [<c129327c>] migration_call+0xf0/0x470
[43633.647009]    [<c1299ed1>] notifier_call_chain+0x51/0x7e
[43633.647009]    [<c1040841>] raw_notifier_call_chain+0x11/0x13
[43633.647009]    [<c1293738>] _cpu_up+0xc6/0x105
[43633.647009]    [<c12937c3>] cpu_up+0x4c/0x5c
[43633.647009]    [<c1448233>] kernel_init+0x99/0x16a
[43633.647009]    [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]    [<ffffffff>] 0xffffffff
[43633.647009] 
[43633.647009]       ... acquired at:
[43633.647009]    [<c104d315>] __lock_acquire+0xff0/0x12d3
[43633.647009]    [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]    [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]    [<c1027611>] enqueue_task_rt+0x160/0x232
[43633.647009]    [<c101ad56>] enqueue_task+0x2f/0x3b
[43633.647009]    [<c101ae2c>] activate_task+0x24/0x2a
[43633.647009]    [<c102294b>] try_to_wake_up+0xcb/0x20b
[43633.647009]    [<c1022ac2>] wake_up_process+0x14/0x16
[43633.647009]    [<c1293248>] migration_call+0xbc/0x470
[43633.647009]    [<c1457218>] migration_init+0x3b/0x4b
[43633.647009]    [<c1001141>] do_one_initcall+0x4f/0x116
[43633.647009]    [<c14481e7>] kernel_init+0x4d/0x16a
[43633.647009]    [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]    [<ffffffff>] 0xffffffff
[43633.647009] 
[43633.647009]       ... acquired at:
[43633.647009]    [<c104d315>] __lock_acquire+0xff0/0x12d3
[43633.647009]    [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]    [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]    [<c101f3eb>] update_curr_rt+0x123/0x1b0
[43633.647009]    [<c101fa28>] dequeue_task_rt+0x22/0x62
[43633.647009]    [<c101adfa>] dequeue_task+0x98/0xa6
[43633.647009]    [<c101ae56>] deactivate_task+0x24/0x2a
[43633.647009]    [<c129519c>] schedule+0x13e/0x81f
[43633.647009]    [<c10259bb>] migration_thread+0x179/0x1de
[43633.647009]    [<c103c78b>] kthread+0x70/0x75
[43633.647009]    [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]    [<ffffffff>] 0xffffffff
[43633.647009] 
[43633.647009]       -> (&rq->lock/1){..-...} ops: 0 {
[43633.647009]          IN-SOFTIRQ-W at:
[43633.647009]                                                    [<c104c87d>] __lock_acquire+0x558/0x12d3
[43633.647009]                                                    [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                    [<c12979f0>] _spin_lock_nested+0x34/0x64
[43633.647009]                                                    [<c102232a>] double_rq_lock+0x4c/0x7f
[43633.647009]                                                    [<c1025ba9>] rebalance_domains+0x189/0x3b6
[43633.647009]                                                    [<c1025e0a>] run_rebalance_domains+0x34/0xa7
[43633.647009]                                                    [<c102e8d6>] __do_softirq+0xdb/0x1ac
[43633.647009]                                                    [<c102e9d7>] do_softirq+0x30/0x48
[43633.647009]                                                    [<c102eb53>] irq_exit+0x3d/0x74
[43633.647009]                                                    [<c10121a6>] smp_apic_timer_interrupt+0x73/0x81
[43633.647009]                                                    [<c100333b>] apic_timer_interrupt+0x2f/0x34
[43633.647009]                                                    [<c1001beb>] cpu_idle+0x53/0x88
[43633.647009]                                                    [<c12927c1>] start_secondary+0x1ad/0x1b4
[43633.647009]                                                    [<ffffffff>] 0xffffffff
[43633.647009]          INITIAL USE at:
[43633.647009]                                                   [<c104c943>] __lock_acquire+0x61e/0x12d3
[43633.647009]                                                   [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                   [<c12979f0>] _spin_lock_nested+0x34/0x64
[43633.647009]                                                   [<c102232a>] double_rq_lock+0x4c/0x7f
[43633.647009]                                                   [<c1024c11>] __migrate_task+0x4d/0xc1
[43633.647009]                                                   [<c10259ef>] migration_thread+0x1ad/0x1de
[43633.647009]                                                   [<c103c78b>] kthread+0x70/0x75
[43633.647009]                                                   [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]                                                   [<ffffffff>] 0xffffffff
[43633.647009]        }
[43633.647009]        ... key      at: [<c15e035d>] __key.51718+0x1/0x8
[43633.647009]        -> (&sig->cputimer.lock){-.-...} ops: 0 {
[43633.647009]           IN-HARDIRQ-W at:
[43633.647009]                                                      [<c104c85e>] __lock_acquire+0x539/0x12d3
[43633.647009]                                                      [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                      [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                                      [<c101debd>] account_system_time+0x105/0x157
[43633.647009]                                                      [<c101df78>] account_process_tick+0x69/0x7e
[43633.647009]                                                      [<c1032c83>] update_process_times+0x24/0x53
[43633.647009]                                                      [<c1047d9b>] tick_sched_timer+0x71/0x9f
[43633.647009]                                                      [<c103f290>] __run_hrtimer+0x6b/0x9d
[43633.647009]                                                      [<c103fe59>] hrtimer_interrupt+0x112/0x16c
[43633.647009]                                                      [<c10121a1>] smp_apic_timer_interrupt+0x6e/0x81
[43633.647009]                                                      [<c100333b>] apic_timer_interrupt+0x2f/0x34
[43633.647009]                                                      [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                                      [<c10ac78c>] __d_lookup+0x96/0x140
[43633.647009]                                                      [<c10a50c6>] do_lookup+0x23/0x158
[43633.647009]                                                      [<c10a6584>] __link_path_walk+0x30d/0xae6
[43633.647009]                                                      [<c10a6eb2>] path_walk+0x3e/0x77
[43633.647009]                                                      [<c10a6f78>] do_path_lookup+0x26/0x47
[43633.647009]                                                      [<c10a79fe>] do_filp_open+0xcc/0x6e1
[43633.647009]                                                      [<c109c965>] do_sys_open+0x4d/0xe9
[43633.647009]                                                      [<c109ca4d>] sys_open+0x23/0x2b
[43633.647009]                                                      [<c1002988>] sysenter_do_call+0x12/0x36
[43633.647009]                                                      [<ffffffff>] 0xffffffff
[43633.647009]           IN-SOFTIRQ-W at:
[43633.647009]                                                      [<c104c87d>] __lock_acquire+0x558/0x12d3
[43633.647009]                                                      [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                      [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                                      [<c101d7df>] update_curr+0x128/0x149
[43633.647009]                                                      [<c101ed63>] enqueue_task_fair+0x40/0xdc
[43633.647009]                                                      [<c101ad56>] enqueue_task+0x2f/0x3b
[43633.647009]                                                      [<c101ae2c>] activate_task+0x24/0x2a
[43633.647009]                                                      [<c102294b>] try_to_wake_up+0xcb/0x20b
[43633.647009]                                                      [<c1022a9b>] default_wake_function+0x10/0x12
[43633.647009]                                                      [<c103ca74>] autoremove_wake_function+0x14/0x34
[43633.647009]                                                      [<c103cac3>] wake_bit_function+0x2f/0x3c
[43633.647009]                                                      [<c101b00a>] __wake_up_common+0x39/0x61
[43633.647009]                                                      [<c101d557>] __wake_up+0x2e/0x40
[43633.647009]                                                      [<c103c9fd>] __wake_up_bit+0x2c/0x2f
[43633.647009]                                                      [<c107921f>] end_page_writeback+0x65/0x68
[43633.647009]                                                      [<c10ba9e5>] end_buffer_async_write+0x139/0x189
[43633.647009]                                                      [<c10b9449>] end_bio_bh_io_sync+0x33/0x3d
[43633.647009]                                                      [<c10bc824>] bio_endio+0x28/0x2a
[43633.647009]                                                      [<c113e468>] req_bio_endio+0x89/0xa6
[43633.647009]                                                      [<c113e66b>] blk_update_request+0x1e6/0x379
[43633.647009]                                                      [<c113e811>] blk_update_bidi_request+0x13/0x41
[43633.647009]                                                      [<c1140320>] blk_end_bidi_request+0x1d/0x55
[43633.647009]                                                      [<c1140396>] blk_end_request+0xf/0x11
[43633.647009]                                                      [<c11cb225>] scsi_io_completion+0x196/0x3c4
[43633.647009]                                                      [<c11c5785>] scsi_finish_command+0xd3/0xdb
[43633.647009]                                                      [<c11cb554>] scsi_softirq_done+0xed/0xf5
[43633.647009]                                                      [<c1145c63>] blk_done_softirq+0x63/0x70
[43633.647009]                                                      [<c102e8d6>] __do_softirq+0xdb/0x1ac
[43633.647009]                                                      [<c102e9d7>] do_softirq+0x30/0x48
[43633.647009]                                                      [<c102eb53>] irq_exit+0x3d/0x74
[43633.647009]                                                      [<c100405b>] do_IRQ+0x88/0x9c
[43633.647009]                                                      [<c100302e>] common_interrupt+0x2e/0x34
[43633.647009]                                                      [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                                      [<f8043d41>] unix_stream_recvmsg+0xf7/0x416 [unix]
[43633.647009]                                                      [<c12259bd>] sock_aio_read+0xd7/0xe1
[43633.647009]                                                      [<c109df9b>] do_sync_read+0xb0/0xeb
[43633.647009]                                                      [<c109e9bd>] vfs_read+0x9d/0x115
[43633.647009]                                                      [<c109eaf1>] sys_read+0x48/0x75
[43633.647009]                                                      [<c1002988>] sysenter_do_call+0x12/0x36
[43633.647009]                                                      [<ffffffff>] 0xffffffff
[43633.647009]           INITIAL USE at:
[43633.647009]                                                     [<c104c943>] __lock_acquire+0x61e/0x12d3
[43633.647009]                                                     [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                     [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]                                                     [<c103d893>] thread_group_cputimer+0x26/0xae
[43633.647009]                                                     [<c103d93e>] cpu_timer_sample_group+0x23/0x66
[43633.647009]                                                     [<c103d9af>] set_process_cpu_timer+0x2e/0xb4
[43633.647009]                                                     [<c103da8f>] update_rlimit_cpu+0x5a/0x73
[43633.647009]                                                     [<c1036739>] sys_setrlimit+0xdf/0xf6
[43633.647009]                                                     [<c1002988>] sysenter_do_call+0x12/0x36
[43633.647009]                                                     [<ffffffff>] 0xffffffff
[43633.647009]         }
[43633.647009]         ... key      at: [<c15e1668>] __key.21973+0x0/0x8
[43633.647009]        ... acquired at:
[43633.647009]    [<c104d315>] __lock_acquire+0xff0/0x12d3
[43633.647009]    [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]    [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]    [<c101d7df>] update_curr+0x128/0x149
[43633.647009]    [<c101ed63>] enqueue_task_fair+0x40/0xdc
[43633.647009]    [<c101ad56>] enqueue_task+0x2f/0x3b
[43633.647009]    [<c101ae2c>] activate_task+0x24/0x2a
[43633.647009]    [<c1024c55>] __migrate_task+0x91/0xc1
[43633.647009]    [<c10259ef>] migration_thread+0x1ad/0x1de
[43633.647009]    [<c103c78b>] kthread+0x70/0x75
[43633.647009]    [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]    [<ffffffff>] 0xffffffff
[43633.647009] 
[43633.647009]       ... acquired at:
[43633.647009]    [<c104d315>] __lock_acquire+0xff0/0x12d3
[43633.647009]    [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]    [<c12979f0>] _spin_lock_nested+0x34/0x64
[43633.647009]    [<c102232a>] double_rq_lock+0x4c/0x7f
[43633.647009]    [<c1024c11>] __migrate_task+0x4d/0xc1
[43633.647009]    [<c10259ef>] migration_thread+0x1ad/0x1de
[43633.647009]    [<c103c78b>] kthread+0x70/0x75
[43633.647009]    [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]    [<ffffffff>] 0xffffffff
[43633.647009] 
[43633.647009]       ... acquired at:
[43633.647009]    [<c104d315>] __lock_acquire+0xff0/0x12d3
[43633.647009]    [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]    [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]    [<c101d7df>] update_curr+0x128/0x149
[43633.647009]    [<c101e7b5>] dequeue_task_fair+0x40/0x188
[43633.647009]    [<c101adfa>] dequeue_task+0x98/0xa6
[43633.647009]    [<c101ae56>] deactivate_task+0x24/0x2a
[43633.647009]    [<c129519c>] schedule+0x13e/0x81f
[43633.647009]    [<c12958a0>] io_schedule+0x23/0x2d
[43633.647009]    [<c1079186>] sync_page+0x47/0x4b
[43633.647009]    [<c1079197>] sync_page_killable+0xd/0x30
[43633.647009]    [<c1295bf3>] __wait_on_bit_lock+0x39/0x75
[43633.647009]    [<c10790ae>] __lock_page_killable+0x74/0x7b
[43633.647009]    [<c107adb5>] generic_file_aio_read+0x383/0x532
[43633.647009]    [<c109df9b>] do_sync_read+0xb0/0xeb
[43633.647009]    [<c109e9ad>] vfs_read+0x8d/0x115
[43633.647009]    [<c109eaf1>] sys_read+0x48/0x75
[43633.647009]    [<c1002988>] sysenter_do_call+0x12/0x36
[43633.647009]    [<ffffffff>] 0xffffffff
[43633.647009] 
[43633.647009]      ... acquired at:
[43633.647009]    [<c104d315>] __lock_acquire+0xff0/0x12d3
[43633.647009]    [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]    [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]    [<c101d62c>] task_rq_lock+0x3b/0x65
[43633.647009]    [<c10228b1>] try_to_wake_up+0x31/0x20b
[43633.647009]    [<c1022a9b>] default_wake_function+0x10/0x12
[43633.647009]    [<c103ca74>] autoremove_wake_function+0x14/0x34
[43633.647009]    [<c101b00a>] __wake_up_common+0x39/0x61
[43633.647009]    [<c101d557>] __wake_up+0x2e/0x40
[43633.647009]    [<c1038ccd>] insert_work+0x9a/0xa3
[43633.647009]    [<c10394f4>] __queue_work+0x26/0x34
[43633.647009]    [<c103957c>] queue_work_on+0x40/0x49
[43633.647009]    [<c10396a2>] queue_work+0x26/0x4a
[43633.647009]    [<c1037fe7>] call_usermodehelper_exec+0x8f/0xe1
[43633.647009]    [<c114f357>] kobject_uevent_env+0x333/0x368
[43633.647009]    [<c114f396>] kobject_uevent+0xa/0xc
[43633.647009]    [<c114eb0c>] kset_register+0x2e/0x34
[43633.647009]    [<c11b74fe>] bus_register+0xe4/0x232
[43633.647009]    [<c146315e>] platform_bus_init+0x23/0x38
[43633.647009]    [<c14631f6>] driver_init+0x1c/0x28
[43633.647009]    [<c144828c>] kernel_init+0xf2/0x16a
[43633.647009]    [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]    [<ffffffff>] 0xffffffff
[43633.647009] 
[43633.647009]     ... acquired at:
[43633.647009]    [<c104d315>] __lock_acquire+0xff0/0x12d3
[43633.647009]    [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]    [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]    [<c101d543>] __wake_up+0x1a/0x40
[43633.647009]    [<c1038ccd>] insert_work+0x9a/0xa3
[43633.647009]    [<c10394f4>] __queue_work+0x26/0x34
[43633.647009]    [<c103957c>] queue_work_on+0x40/0x49
[43633.647009]    [<c10396a2>] queue_work+0x26/0x4a
[43633.647009]    [<c1037fe7>] call_usermodehelper_exec+0x8f/0xe1
[43633.647009]    [<c114f357>] kobject_uevent_env+0x333/0x368
[43633.647009]    [<c114f396>] kobject_uevent+0xa/0xc
[43633.647009]    [<c114eb0c>] kset_register+0x2e/0x34
[43633.647009]    [<c11b74fe>] bus_register+0xe4/0x232
[43633.647009]    [<c146315e>] platform_bus_init+0x23/0x38
[43633.647009]    [<c14631f6>] driver_init+0x1c/0x28
[43633.647009]    [<c144828c>] kernel_init+0xf2/0x16a
[43633.647009]    [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]    [<ffffffff>] 0xffffffff
[43633.647009] 
[43633.647009]    ... acquired at:
[43633.647009]    [<c104d315>] __lock_acquire+0xff0/0x12d3
[43633.647009]    [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]    [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]    [<c10394e5>] __queue_work+0x17/0x34
[43633.647009]    [<c103957c>] queue_work_on+0x40/0x49
[43633.647009]    [<c10396a2>] queue_work+0x26/0x4a
[43633.647009]    [<c10396da>] schedule_work+0x14/0x16
[43633.647009]    [<fa2558ff>] add_todo+0x4a/0x58 [mac80211]
[43633.647009]    [<fa256173>] ieee80211_key_link+0x11a/0x138 [mac80211]
[43633.647009]    [<fa2505ff>] ieee80211_add_key+0xee/0x128 [mac80211]
[43633.647009]    [<f8f34451>] cfg80211_set_encryption+0xf2/0x163 [cfg80211]
[43633.647009]    [<f8f34618>] cfg80211_wext_siwencodeext+0x156/0x16f [cfg80211]
[43633.647009]    [<c128779c>] ioctl_standard_call+0x1cc/0x27f
[43633.647009]    [<c1287922>] wext_handle_ioctl+0xd3/0x15d
[43633.647009]    [<c12353e5>] dev_ioctl+0x564/0x584
[43633.647009]    [<c1225eb5>] sock_ioctl+0x1e6/0x1f2
[43633.647009]    [<c10a8d82>] vfs_ioctl+0x1d/0x76
[43633.647009]    [<c10a9321>] do_vfs_ioctl+0x4a0/0x4de
[43633.647009]    [<c10a9392>] sys_ioctl+0x33/0x4d
[43633.647009]    [<c1002988>] sysenter_do_call+0x12/0x36
[43633.647009]    [<ffffffff>] 0xffffffff
[43633.647009] 
[43633.647009]   ... acquired at:
[43633.647009]    [<c104d315>] __lock_acquire+0xff0/0x12d3
[43633.647009]    [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]    [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]    [<fa2558d1>] add_todo+0x1c/0x58 [mac80211]
[43633.647009]    [<fa25594d>] ieee80211_set_default_key+0x40/0x54 [mac80211]
[43633.647009]    [<fa2503dc>] ieee80211_config_default_key+0x6a/0xa1 [mac80211]
[43633.647009]    [<f8f34477>] cfg80211_set_encryption+0x118/0x163 [cfg80211]
[43633.647009]    [<f8f34618>] cfg80211_wext_siwencodeext+0x156/0x16f [cfg80211]
[43633.647009]    [<c128779c>] ioctl_standard_call+0x1cc/0x27f
[43633.647009]    [<c1287922>] wext_handle_ioctl+0xd3/0x15d
[43633.647009]    [<c12353e5>] dev_ioctl+0x564/0x584
[43633.647009]    [<c1225eb5>] sock_ioctl+0x1e6/0x1f2
[43633.647009]    [<c10a8d82>] vfs_ioctl+0x1d/0x76
[43633.647009]    [<c10a9321>] do_vfs_ioctl+0x4a0/0x4de
[43633.647009]    [<c10a9392>] sys_ioctl+0x33/0x4d
[43633.647009]    [<c1002988>] sysenter_do_call+0x12/0x36
[43633.647009]    [<ffffffff>] 0xffffffff
[43633.647009] 
[43633.647009]  ... acquired at:
[43633.647009]    [<c104d315>] __lock_acquire+0xff0/0x12d3
[43633.647009]    [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]    [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]    [<fa255e6b>] ieee80211_key_free+0x41/0x60 [mac80211]
[43633.647009]    [<fa2440e0>] __sta_info_unlink+0x69/0x162 [mac80211]
[43633.647009]    [<fa244201>] sta_info_unlink+0x28/0x36 [mac80211]
[43633.647009]    [<fa249908>] ieee80211_set_disassoc+0x27b/0x2bb [mac80211]
[43633.647009]    [<fa249985>] ieee80211_sta_disassociate+0x3d/0x47 [mac80211]
[43633.647009]    [<fa24f085>] ieee80211_disassoc+0x3d/0x3f [mac80211]
[43633.647009]    [<f8f34265>] cfg80211_wext_siwmlme+0xc2/0xd8 [cfg80211]
[43633.647009]    [<c128779c>] ioctl_standard_call+0x1cc/0x27f
[43633.647009]    [<c1287922>] wext_handle_ioctl+0xd3/0x15d
[43633.647009]    [<c12353e5>] dev_ioctl+0x564/0x584
[43633.647009]    [<c1225eb5>] sock_ioctl+0x1e6/0x1f2
[43633.647009]    [<c10a8d82>] vfs_ioctl+0x1d/0x76
[43633.647009]    [<c10a9321>] do_vfs_ioctl+0x4a0/0x4de
[43633.647009]    [<c10a9392>] sys_ioctl+0x33/0x4d
[43633.647009]    [<c1002988>] sysenter_do_call+0x12/0x36
[43633.647009]    [<ffffffff>] 0xffffffff
[43633.647009] 
[43633.647009]  -> (&sta->flaglock){..-.-.} ops: 0 {
[43633.647009]     IN-SOFTIRQ-W at:
[43633.647009]                                          [<c104c87d>] __lock_acquire+0x558/0x12d3
[43633.647009]                                          [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                          [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]                                          [<fa2511ff>] ieee80211_invoke_rx_handlers+0x117/0x125e [mac80211]
[43633.647009]                                          [<fa25286b>] __ieee80211_rx_handle_packet+0x525/0x552 [mac80211]
[43633.647009]                                          [<fa25311f>] __ieee80211_rx+0x500/0x581 [mac80211]
[43633.647009]                                          [<fa4ecf17>] ath5k_tasklet_rx+0x51b/0x56c [ath5k]
[43633.647009]                                          [<c102e209>] tasklet_action+0x93/0xe6
[43633.647009]                                          [<c102e8d6>] __do_softirq+0xdb/0x1ac
[43633.647009]                                          [<c102e9d7>] do_softirq+0x30/0x48
[43633.647009]                                          [<c102eb53>] irq_exit+0x3d/0x74
[43633.647009]                                          [<c100405b>] do_IRQ+0x88/0x9c
[43633.647009]                                          [<c100302e>] common_interrupt+0x2e/0x34
[43633.647009]                                          [<c1278acf>] fib_netdev_event+0x6c/0x75
[43633.647009]                                          [<c1299ed1>] notifier_call_chain+0x51/0x7e
[43633.647009]                                          [<c1040841>] raw_notifier_call_chain+0x11/0x13
[43633.647009]                                          [<c123377f>] call_netdevice_notifiers+0x16/0x18
[43633.647009]                                          [<c1233dd9>] netdev_state_change+0x20/0x31
[43633.647009]                                          [<c123cb3d>] __linkwatch_run_queue+0x146/0x16e
[43633.647009]                                          [<c123cb85>] linkwatch_event+0x20/0x27
[43633.647009]                                          [<c1038a94>] worker_thread+0x1aa/0x287
[43633.647009]                                          [<c103c78b>] kthread+0x70/0x75
[43633.647009]                                          [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]                                          [<ffffffff>] 0xffffffff
[43633.647009]     IN-RECLAIM_FS-W at:
[43633.647009]                                             [<c104c92d>] __lock_acquire+0x608/0x12d3
[43633.647009]                                             [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                             [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]                                             [<fa250965>] ieee80211_drop_unencrypted+0x6d/0x19a [mac80211]
[43633.647009]                                             [<fa2510ad>] ieee80211_rx_h_mgmt+0x4b/0x86 [mac80211]
[43633.647009]                                             [<fa252115>] ieee80211_invoke_rx_handlers+0x102d/0x125e [mac80211]
[43633.647009]                                             [<fa25286b>] __ieee80211_rx_handle_packet+0x525/0x552 [mac80211]
[43633.647009]                                             [<fa25311f>] __ieee80211_rx+0x500/0x581 [mac80211]
[43633.647009]                                             [<fa4ecf17>] ath5k_tasklet_rx+0x51b/0x56c [ath5k]
[43633.647009]                                             [<c102e209>] tasklet_action+0x93/0xe6
[43633.647009]                                             [<c102e8d6>] __do_softirq+0xdb/0x1ac
[43633.647009]                                             [<c102e9d7>] do_softirq+0x30/0x48
[43633.647009]                                             [<c102eb53>] irq_exit+0x3d/0x74
[43633.647009]                                             [<c100405b>] do_IRQ+0x88/0x9c
[43633.647009]                                             [<c100302e>] common_interrupt+0x2e/0x34
[43633.647009]                                             [<c107d7e6>] free_hot_cold_page+0x8e/0x1fb
[43633.647009]                                             [<c107d975>] __pagevec_free+0x22/0x2a
[43633.647009]                                             [<c108079a>] release_pages+0x12b/0x165
[43633.647009]                                             [<c1080cea>] __pagevec_release+0x1d/0x26
[43633.647009]                                             [<c10811c5>] invalidate_mapping_pages+0xc3/0xf0
[43633.647009]                                             [<c10ae121>] shrink_icache_memory+0xdf/0x1de
[43633.647009]                                             [<c108321b>] shrink_slab+0xda/0x15f
[43633.647009]                                             [<c10836a1>] kswapd+0x401/0x587
[43633.647009]                                             [<c103c78b>] kthread+0x70/0x75
[43633.647009]                                             [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]                                             [<ffffffff>] 0xffffffff
[43633.647009]     INITIAL USE at:
[43633.647009]                                         [<c104c943>] __lock_acquire+0x61e/0x12d3
[43633.647009]                                         [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                         [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]                                         [<fa24b30e>] ieee80211_rx_mgmt_assoc_resp+0x344/0xa13 [mac80211]
[43633.647009]                                         [<fa24c38b>] ieee80211_sta_work+0x776/0xd3b [mac80211]
[43633.647009]                                         [<c1038a94>] worker_thread+0x1aa/0x287
[43633.647009]                                         [<c103c78b>] kthread+0x70/0x75
[43633.647009]                                         [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]                                         [<ffffffff>] 0xffffffff
[43633.647009]   }
[43633.647009]   ... key      at: [<fa26a9d8>] __key.38223+0x0/0xffff0e6f [mac80211]
[43633.647009]  ... acquired at:
[43633.647009]    [<c104d315>] __lock_acquire+0xff0/0x12d3
[43633.647009]    [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]    [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]    [<fa24410e>] __sta_info_unlink+0x97/0x162 [mac80211]
[43633.647009]    [<fa244201>] sta_info_unlink+0x28/0x36 [mac80211]
[43633.647009]    [<fa249908>] ieee80211_set_disassoc+0x27b/0x2bb [mac80211]
[43633.647009]    [<fa249985>] ieee80211_sta_disassociate+0x3d/0x47 [mac80211]
[43633.647009]    [<fa24f085>] ieee80211_disassoc+0x3d/0x3f [mac80211]
[43633.647009]    [<f8f34265>] cfg80211_wext_siwmlme+0xc2/0xd8 [cfg80211]
[43633.647009]    [<c128779c>] ioctl_standard_call+0x1cc/0x27f
[43633.647009]    [<c1287922>] wext_handle_ioctl+0xd3/0x15d
[43633.647009]    [<c12353e5>] dev_ioctl+0x564/0x584
[43633.647009]    [<c1225eb5>] sock_ioctl+0x1e6/0x1f2
[43633.647009]    [<c10a8d82>] vfs_ioctl+0x1d/0x76
[43633.647009]    [<c10a9321>] do_vfs_ioctl+0x4a0/0x4de
[43633.647009]    [<c10a9392>] sys_ioctl+0x33/0x4d
[43633.647009]    [<c1002988>] sysenter_do_call+0x12/0x36
[43633.647009]    [<ffffffff>] 0xffffffff
[43633.647009] 
[43633.647009] 
[43633.647009] the second lock's dependencies:
[43633.647009] -> (todo_lock){+.+...} ops: 0 {
[43633.647009]    HARDIRQ-ON-W at:
[43633.647009]                                        [<c104c8d3>] __lock_acquire+0x5ae/0x12d3
[43633.647009]                                        [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                        [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                        [<fa255e06>] __ieee80211_key_todo+0x1cb/0x1ef [mac80211]
[43633.647009]                                        [<fa255f29>] ieee80211_key_todo+0x19/0x25 [mac80211]
[43633.647009]                                        [<fa255fb6>] ieee80211_todo_for_each_key+0x72/0x79 [mac80211]
[43633.647009]                                        [<fa256054>] ieee80211_enable_keys+0x56/0x5b [mac80211]
[43633.647009]                                        [<fa24d7f4>] ieee80211_open+0x47a/0x5f4 [mac80211]
[43633.647009]                                        [<c123430c>] dev_open+0x8b/0xc0
[43633.647009]                                        [<c1233a5c>] dev_change_flags+0x9b/0x14c
[43633.647009]                                        [<c123b01d>] do_setlink+0x2a2/0x348
[43633.647009]                                        [<c123b1a8>] rtnl_setlink+0xe5/0xe9
[43633.647009]                                        [<c123bf67>] rtnetlink_rcv_msg+0x18a/0x1a0
[43633.647009]                                        [<c12442cc>] netlink_rcv_skb+0x35/0x7d
[43633.647009]                                        [<c123bdd6>] rtnetlink_rcv+0x20/0x27
[43633.647009]                                        [<c1243e4c>] netlink_unicast+0x1b1/0x212
[43633.647009]                                        [<c12440d0>] netlink_sendmsg+0x223/0x230
[43633.647009]                                        [<c1226655>] sock_sendmsg+0xcc/0xe2
[43633.647009]                                        [<c12267b9>] sys_sendmsg+0x14e/0x19b
[43633.647009]                                        [<c122770c>] sys_socketcall+0x147/0x170
[43633.647009]                                        [<c1002988>] sysenter_do_call+0x12/0x36
[43633.647009]                                        [<ffffffff>] 0xffffffff
[43633.647009]    SOFTIRQ-ON-W at:
[43633.647009]                                        [<c104c8f2>] __lock_acquire+0x5cd/0x12d3
[43633.647009]                                        [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                        [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                        [<fa255e06>] __ieee80211_key_todo+0x1cb/0x1ef [mac80211]
[43633.647009]                                        [<fa255f29>] ieee80211_key_todo+0x19/0x25 [mac80211]
[43633.647009]                                        [<fa255fb6>] ieee80211_todo_for_each_key+0x72/0x79 [mac80211]
[43633.647009]                                        [<fa256054>] ieee80211_enable_keys+0x56/0x5b [mac80211]
[43633.647009]                                        [<fa24d7f4>] ieee80211_open+0x47a/0x5f4 [mac80211]
[43633.647009]                                        [<c123430c>] dev_open+0x8b/0xc0
[43633.647009]                                        [<c1233a5c>] dev_change_flags+0x9b/0x14c
[43633.647009]                                        [<c123b01d>] do_setlink+0x2a2/0x348
[43633.647009]                                        [<c123b1a8>] rtnl_setlink+0xe5/0xe9
[43633.647009]                                        [<c123bf67>] rtnetlink_rcv_msg+0x18a/0x1a0
[43633.647009]                                        [<c12442cc>] netlink_rcv_skb+0x35/0x7d
[43633.647009]                                        [<c123bdd6>] rtnetlink_rcv+0x20/0x27
[43633.647009]                                        [<c1243e4c>] netlink_unicast+0x1b1/0x212
[43633.647009]                                        [<c12440d0>] netlink_sendmsg+0x223/0x230
[43633.647009]                                        [<c1226655>] sock_sendmsg+0xcc/0xe2
[43633.647009]                                        [<c12267b9>] sys_sendmsg+0x14e/0x19b
[43633.647009]                                        [<c122770c>] sys_socketcall+0x147/0x170
[43633.647009]                                        [<c1002988>] sysenter_do_call+0x12/0x36
[43633.647009]                                        [<ffffffff>] 0xffffffff
[43633.647009]    INITIAL USE at:
[43633.647009]                                       [<c104c943>] __lock_acquire+0x61e/0x12d3
[43633.647009]                                       [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                       [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                       [<fa255e06>] __ieee80211_key_todo+0x1cb/0x1ef [mac80211]
[43633.647009]                                       [<fa255f29>] ieee80211_key_todo+0x19/0x25 [mac80211]
[43633.647009]                                       [<fa255fb6>] ieee80211_todo_for_each_key+0x72/0x79 [mac80211]
[43633.647009]                                       [<fa256054>] ieee80211_enable_keys+0x56/0x5b [mac80211]
[43633.647009]                                       [<fa24d7f4>] ieee80211_open+0x47a/0x5f4 [mac80211]
[43633.647009]                                       [<c123430c>] dev_open+0x8b/0xc0
[43633.647009]                                       [<c1233a5c>] dev_change_flags+0x9b/0x14c
[43633.647009]                                       [<c123b01d>] do_setlink+0x2a2/0x348
[43633.647009]                                       [<c123b1a8>] rtnl_setlink+0xe5/0xe9
[43633.647009]                                       [<c123bf67>] rtnetlink_rcv_msg+0x18a/0x1a0
[43633.647009]                                       [<c12442cc>] netlink_rcv_skb+0x35/0x7d
[43633.647009]                                       [<c123bdd6>] rtnetlink_rcv+0x20/0x27
[43633.647009]                                       [<c1243e4c>] netlink_unicast+0x1b1/0x212
[43633.647009]                                       [<c12440d0>] netlink_sendmsg+0x223/0x230
[43633.647009]                                       [<c1226655>] sock_sendmsg+0xcc/0xe2
[43633.647009]                                       [<c12267b9>] sys_sendmsg+0x14e/0x19b
[43633.647009]                                       [<c122770c>] sys_socketcall+0x147/0x170
[43633.647009]                                       [<c1002988>] sysenter_do_call+0x12/0x36
[43633.647009]                                       [<ffffffff>] 0xffffffff
[43633.647009]  }
[43633.647009]  ... key      at: [<fa26a70c>] todo_lock+0x10/0xffff114b [mac80211]
[43633.647009]  -> (&cwq->lock){-.-.-.} ops: 0 {
[43633.647009]     IN-HARDIRQ-W at:
[43633.647009]                                          [<c104c85e>] __lock_acquire+0x539/0x12d3
[43633.647009]                                          [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                          [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]                                          [<c10394e5>] __queue_work+0x17/0x34
[43633.647009]                                          [<c103957c>] queue_work_on+0x40/0x49
[43633.647009]                                          [<c10396a2>] queue_work+0x26/0x4a
[43633.647009]                                          [<c1175b27>] __acpi_os_execute+0xf1/0x119
[43633.647009]                                          [<c1175b75>] acpi_os_execute+0xf/0x11
[43633.647009]                                          [<c1179697>] acpi_ec_gpe_handler+0x6f/0xa3
[43633.647009]                                          [<c1184640>] acpi_ev_gpe_dispatch+0x51/0x10f
[43633.647009]                                          [<c118478a>] acpi_ev_gpe_detect+0x8c/0xce
[43633.647009]                                          [<c1182ae9>] acpi_ev_sci_xrupt_handler+0x1a/0x20
[43633.647009]                                          [<c1175373>] acpi_irq+0x13/0x2e
[43633.647009]                                          [<c105fcef>] handle_IRQ_event+0x6a/0x12f
[43633.647009]                                          [<c1061426>] handle_fasteoi_irq+0x7e/0xb5
[43633.647009]                                          [<c100489d>] handle_irq+0x40/0x4b
[43633.647009]                                          [<c100401c>] do_IRQ+0x49/0x9c
[43633.647009]                                          [<c100302e>] common_interrupt+0x2e/0x34
[43633.647009]                                          [<c1021bbc>] finish_task_switch+0x6c/0xe8
[43633.647009]                                          [<c129580d>] schedule+0x7af/0x81f
[43633.647009]                                          [<c1001c11>] cpu_idle+0x79/0x88
[43633.647009]                                          [<c12880c4>] rest_init+0x6c/0x6e
[43633.647009]                                          [<c1448753>] start_kernel+0x28b/0x290
[43633.647009]                                          [<c1448038>] __init_begin+0x38/0x40
[43633.647009]                                          [<ffffffff>] 0xffffffff
[43633.647009]     IN-SOFTIRQ-W at:
[43633.647009]                                          [<c104c87d>] __lock_acquire+0x558/0x12d3
[43633.647009]                                          [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                          [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]                                          [<c10394e5>] __queue_work+0x17/0x34
[43633.647009]                                          [<c103957c>] queue_work_on+0x40/0x49
[43633.647009]                                          [<c10396a2>] queue_work+0x26/0x4a
[43633.647009]                                          [<c113dd5e>] kblockd_schedule_work+0x12/0x14
[43633.647009]                                          [<c11496ac>] as_antic_timeout+0x58/0xa4
[43633.647009]                                          [<c10325ca>] run_timer_softirq+0x17b/0x1f0
[43633.647009]                                          [<c102e8d6>] __do_softirq+0xdb/0x1ac
[43633.647009]                                          [<c102e9d7>] do_softirq+0x30/0x48
[43633.647009]                                          [<c102eb53>] irq_exit+0x3d/0x74
[43633.647009]                                          [<c10121a6>] smp_apic_timer_interrupt+0x73/0x81
[43633.647009]                                          [<c100333b>] apic_timer_interrupt+0x2f/0x34
[43633.647009]                                          [<c1001beb>] cpu_idle+0x53/0x88
[43633.647009]                                          [<c12880c4>] rest_init+0x6c/0x6e
[43633.647009]                                          [<c1448753>] start_kernel+0x28b/0x290
[43633.647009]                                          [<c1448038>] __init_begin+0x38/0x40
[43633.647009]                                          [<ffffffff>] 0xffffffff
[43633.647009]     IN-RECLAIM_FS-W at:
[43633.647009]                                             [<c104c92d>] __lock_acquire+0x608/0x12d3
[43633.647009]                                             [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                             [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]                                             [<c10394e5>] __queue_work+0x17/0x34
[43633.647009]                                             [<c103957c>] queue_work_on+0x40/0x49
[43633.647009]                                             [<c10396a2>] queue_work+0x26/0x4a
[43633.647009]                                             [<c113dd5e>] kblockd_schedule_work+0x12/0x14
[43633.647009]                                             [<c113e21f>] blk_unplug_timeout+0x57/0x5b
[43633.647009]                                             [<c10325ca>] run_timer_softirq+0x17b/0x1f0
[43633.647009]                                             [<c102e8d6>] __do_softirq+0xdb/0x1ac
[43633.647009]                                             [<c102e9d7>] do_softirq+0x30/0x48
[43633.647009]                                             [<c102eb53>] irq_exit+0x3d/0x74
[43633.647009]                                             [<c10121a6>] smp_apic_timer_interrupt+0x73/0x81
[43633.647009]                                             [<c100333b>] apic_timer_interrupt+0x2f/0x34
[43633.647009]                                             [<c10adf79>] destroy_inode+0x32/0x35
[43633.647009]                                             [<c10ae3fa>] generic_delete_inode+0xe4/0xe8
[43633.647009]                                             [<c10ad740>] iput+0x50/0x53
[43633.647009]                                             [<c10dbd0d>] sysfs_d_iput+0x28/0x2b
[43633.647009]                                             [<c10ab44e>] dentry_iput+0x96/0xb8
[43633.647009]                                             [<c10ab50d>] d_kill+0x21/0x3b
[43633.647009]                                             [<c10ab6fa>] __shrink_dcache_sb+0x1d3/0x255
[43633.647009]                                             [<c10ab855>] shrink_dcache_memory+0xd9/0x15e
[43633.647009]                                             [<c108321b>] shrink_slab+0xda/0x15f
[43633.647009]                                             [<c10836a1>] kswapd+0x401/0x587
[43633.647009]                                             [<c103c78b>] kthread+0x70/0x75
[43633.647009]                                             [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]                                             [<ffffffff>] 0xffffffff
[43633.647009]     INITIAL USE at:
[43633.647009]                                         [<c104c943>] __lock_acquire+0x61e/0x12d3
[43633.647009]                                         [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                         [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]                                         [<c10394e5>] __queue_work+0x17/0x34
[43633.647009]                                         [<c103957c>] queue_work_on+0x40/0x49
[43633.647009]                                         [<c10396a2>] queue_work+0x26/0x4a
[43633.647009]                                         [<c1037fe7>] call_usermodehelper_exec+0x8f/0xe1
[43633.647009]                                         [<c114f357>] kobject_uevent_env+0x333/0x368
[43633.647009]                                         [<c114f396>] kobject_uevent+0xa/0xc
[43633.647009]                                         [<c114eb0c>] kset_register+0x2e/0x34
[43633.647009]                                         [<c11b74fe>] bus_register+0xe4/0x232
[43633.647009]                                         [<c146315e>] platform_bus_init+0x23/0x38
[43633.647009]                                         [<c14631f6>] driver_init+0x1c/0x28
[43633.647009]                                         [<c144828c>] kernel_init+0xf2/0x16a
[43633.647009]                                         [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]                                         [<ffffffff>] 0xffffffff
[43633.647009]   }
[43633.647009]   ... key      at: [<c16231b4>] __key.25893+0x0/0x8
[43633.647009]   -> (key#3){-.-.-.} ops: 0 {
[43633.647009]      IN-HARDIRQ-W at:
[43633.647009]                                            [<c104c85e>] __lock_acquire+0x539/0x12d3
[43633.647009]                                            [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                            [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]                                            [<c101d543>] __wake_up+0x1a/0x40
[43633.647009]                                            [<c1038ccd>] insert_work+0x9a/0xa3
[43633.647009]                                            [<c10394f4>] __queue_work+0x26/0x34
[43633.647009]                                            [<c103957c>] queue_work_on+0x40/0x49
[43633.647009]                                            [<c10396a2>] queue_work+0x26/0x4a
[43633.647009]                                            [<c1175b27>] __acpi_os_execute+0xf1/0x119
[43633.647009]                                            [<c1175b75>] acpi_os_execute+0xf/0x11
[43633.647009]                                            [<c1179697>] acpi_ec_gpe_handler+0x6f/0xa3
[43633.647009]                                            [<c1184640>] acpi_ev_gpe_dispatch+0x51/0x10f
[43633.647009]                                            [<c118478a>] acpi_ev_gpe_detect+0x8c/0xce
[43633.647009]                                            [<c1182ae9>] acpi_ev_sci_xrupt_handler+0x1a/0x20
[43633.647009]                                            [<c1175373>] acpi_irq+0x13/0x2e
[43633.647009]                                            [<c105fcef>] handle_IRQ_event+0x6a/0x12f
[43633.647009]                                            [<c1061426>] handle_fasteoi_irq+0x7e/0xb5
[43633.647009]                                            [<c100489d>] handle_irq+0x40/0x4b
[43633.647009]                                            [<c100401c>] do_IRQ+0x49/0x9c
[43633.647009]                                            [<c100302e>] common_interrupt+0x2e/0x34
[43633.647009]                                            [<c1021bbc>] finish_task_switch+0x6c/0xe8
[43633.647009]                                            [<c129580d>] schedule+0x7af/0x81f
[43633.647009]                                            [<c1001c11>] cpu_idle+0x79/0x88
[43633.647009]                                            [<c12880c4>] rest_init+0x6c/0x6e
[43633.647009]                                            [<c1448753>] start_kernel+0x28b/0x290
[43633.647009]                                            [<c1448038>] __init_begin+0x38/0x40
[43633.647009]                                            [<ffffffff>] 0xffffffff
[43633.647009]      IN-SOFTIRQ-W at:
[43633.647009]                                            [<c104c87d>] __lock_acquire+0x558/0x12d3
[43633.647009]                                            [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                            [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]                                            [<c101d543>] __wake_up+0x1a/0x40
[43633.647009]                                            [<c1038ccd>] insert_work+0x9a/0xa3
[43633.647009]                                            [<c10394f4>] __queue_work+0x26/0x34
[43633.647009]                                            [<c103957c>] queue_work_on+0x40/0x49
[43633.647009]                                            [<c10396a2>] queue_work+0x26/0x4a
[43633.647009]                                            [<c113dd5e>] kblockd_schedule_work+0x12/0x14
[43633.647009]                                            [<c11496ac>] as_antic_timeout+0x58/0xa4
[43633.647009]                                            [<c10325ca>] run_timer_softirq+0x17b/0x1f0
[43633.647009]                                            [<c102e8d6>] __do_softirq+0xdb/0x1ac
[43633.647009]                                            [<c102e9d7>] do_softirq+0x30/0x48
[43633.647009]                                            [<c102eb53>] irq_exit+0x3d/0x74
[43633.647009]                                            [<c10121a6>] smp_apic_timer_interrupt+0x73/0x81
[43633.647009]                                            [<c100333b>] apic_timer_interrupt+0x2f/0x34
[43633.647009]                                            [<c1001beb>] cpu_idle+0x53/0x88
[43633.647009]                                            [<c12880c4>] rest_init+0x6c/0x6e
[43633.647009]                                            [<c1448753>] start_kernel+0x28b/0x290
[43633.647009]                                            [<c1448038>] __init_begin+0x38/0x40
[43633.647009]                                            [<ffffffff>] 0xffffffff
[43633.647009]      IN-RECLAIM_FS-W at:
[43633.647009]                                               [<c104c92d>] __lock_acquire+0x608/0x12d3
[43633.647009]                                               [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                               [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]                                               [<c101d543>] __wake_up+0x1a/0x40
[43633.647009]                                               [<c1038ccd>] insert_work+0x9a/0xa3
[43633.647009]                                               [<c10394f4>] __queue_work+0x26/0x34
[43633.647009]                                               [<c103957c>] queue_work_on+0x40/0x49
[43633.647009]                                               [<c10396a2>] queue_work+0x26/0x4a
[43633.647009]                                               [<c113dd5e>] kblockd_schedule_work+0x12/0x14
[43633.647009]                                               [<c113e21f>] blk_unplug_timeout+0x57/0x5b
[43633.647009]                                               [<c10325ca>] run_timer_softirq+0x17b/0x1f0
[43633.647009]                                               [<c102e8d6>] __do_softirq+0xdb/0x1ac
[43633.647009]                                               [<c102e9d7>] do_softirq+0x30/0x48
[43633.647009]                                               [<c102eb53>] irq_exit+0x3d/0x74
[43633.647009]                                               [<c10121a6>] smp_apic_timer_interrupt+0x73/0x81
[43633.647009]                                               [<c100333b>] apic_timer_interrupt+0x2f/0x34
[43633.647009]                                               [<c10adf79>] destroy_inode+0x32/0x35
[43633.647009]                                               [<c10ae3fa>] generic_delete_inode+0xe4/0xe8
[43633.647009]                                               [<c10ad740>] iput+0x50/0x53
[43633.647009]                                               [<c10dbd0d>] sysfs_d_iput+0x28/0x2b
[43633.647009]                                               [<c10ab44e>] dentry_iput+0x96/0xb8
[43633.647009]                                               [<c10ab50d>] d_kill+0x21/0x3b
[43633.647009]                                               [<c10ab6fa>] __shrink_dcache_sb+0x1d3/0x255
[43633.647009]                                               [<c10ab855>] shrink_dcache_memory+0xd9/0x15e
[43633.647009]                                               [<c108321b>] shrink_slab+0xda/0x15f
[43633.647009]                                               [<c10836a1>] kswapd+0x401/0x587
[43633.647009]                                               [<c103c78b>] kthread+0x70/0x75
[43633.647009]                                               [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]                                               [<ffffffff>] 0xffffffff
[43633.647009]      INITIAL USE at:
[43633.647009]                                           [<c104c943>] __lock_acquire+0x61e/0x12d3
[43633.647009]                                           [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                           [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]                                           [<c103cc23>] prepare_to_wait+0x1c/0x4c
[43633.647009]                                           [<c1038962>] worker_thread+0x78/0x287
[43633.647009]                                           [<c103c78b>] kthread+0x70/0x75
[43633.647009]                                           [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]                                           [<ffffffff>] 0xffffffff
[43633.647009]    }
[43633.647009]    ... key      at: [<c16231ac>] __key.25894+0x0/0x8
[43633.647009]    -> (&rq->lock){-.-.-.} ops: 0 {
[43633.647009]       IN-HARDIRQ-W at:
[43633.647009]                                              [<c104c85e>] __lock_acquire+0x539/0x12d3
[43633.647009]                                              [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                              [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                              [<c1026192>] scheduler_tick+0x36/0x1dc
[43633.647009]                                              [<c1032ca6>] update_process_times+0x47/0x53
[43633.647009]                                              [<c1046e81>] tick_periodic+0x6c/0x79
[43633.647009]                                              [<c1046eab>] tick_handle_periodic+0x1d/0x76
[43633.647009]                                              [<c1004c76>] timer_interrupt+0x3e/0x45
[43633.647009]                                              [<c105fcef>] handle_IRQ_event+0x6a/0x12f
[43633.647009]                                              [<c10614e4>] handle_level_irq+0x87/0xcd
[43633.647009]                                              [<c100489d>] handle_irq+0x40/0x4b
[43633.647009]                                              [<c100401c>] do_IRQ+0x49/0x9c
[43633.647009]                                              [<c100302e>] common_interrupt+0x2e/0x34
[43633.647009]                                              [<c114dc68>] get_from_free_list+0x32/0x39
[43633.647009]                                              [<c114dda8>] idr_get_empty_slot+0x26/0x1e7
[43633.647009]                                              [<c114df99>] ida_get_new_above+0x30/0x166
[43633.647009]                                              [<c10b18f0>] alloc_vfsmnt+0x57/0x11d
[43633.647009]                                              [<c109f585>] vfs_kern_mount+0x2b/0x7b
[43633.647009]                                              [<c109f5ea>] kern_mount_data+0x15/0x17
[43633.647009]                                              [<c145d44f>] sysfs_init+0x50/0xa0
[43633.647009]                                              [<c145c95b>] mnt_init+0x87/0x147
[43633.647009]                                              [<c145c634>] vfs_caches_init+0xd9/0xeb
[43633.647009]                                              [<c144872b>] start_kernel+0x263/0x290
[43633.647009]                                              [<c1448038>] __init_begin+0x38/0x40
[43633.647009]                                              [<ffffffff>] 0xffffffff
[43633.647009]       IN-SOFTIRQ-W at:
[43633.647009]                                              [<c104c87d>] __lock_acquire+0x558/0x12d3
[43633.647009]                                              [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                              [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                              [<c101d62c>] task_rq_lock+0x3b/0x65
[43633.647009]                                              [<c10228b1>] try_to_wake_up+0x31/0x20b
[43633.647009]                                              [<c1022ac2>] wake_up_process+0x14/0x16
[43633.647009]                                              [<c1032b63>] process_timeout+0xd/0xf
[43633.647009]                                              [<c10325ca>] run_timer_softirq+0x17b/0x1f0
[43633.647009]                                              [<c102e8d6>] __do_softirq+0xdb/0x1ac
[43633.647009]                                              [<c102e9d7>] do_softirq+0x30/0x48
[43633.647009]                                              [<c102eb53>] irq_exit+0x3d/0x74
[43633.647009]                                              [<c10121a6>] smp_apic_timer_interrupt+0x73/0x81
[43633.647009]                                              [<c100333b>] apic_timer_interrupt+0x2f/0x34
[43633.647009]                                              [<c1001beb>] cpu_idle+0x53/0x88
[43633.647009]                                              [<c12880c4>] rest_init+0x6c/0x6e
[43633.647009]                                              [<c1448753>] start_kernel+0x28b/0x290
[43633.647009]                                              [<c1448038>] __init_begin+0x38/0x40
[43633.647009]                                              [<ffffffff>] 0xffffffff
[43633.647009]       IN-RECLAIM_FS-W at:
[43633.647009]                                                 [<c104c92d>] __lock_acquire+0x608/0x12d3
[43633.647009]                                                 [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                 [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                                 [<c101d62c>] task_rq_lock+0x3b/0x65
[43633.647009]                                                 [<c1025e97>] set_cpus_allowed_ptr+0x1a/0xdc
[43633.647009]                                                 [<c10832fe>] kswapd+0x5e/0x587
[43633.647009]                                                 [<c103c78b>] kthread+0x70/0x75
[43633.647009]                                                 [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]                                                 [<ffffffff>] 0xffffffff
[43633.647009]       INITIAL USE at:
[43633.647009]                                             [<c104c943>] __lock_acquire+0x61e/0x12d3
[43633.647009]                                             [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                             [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]                                             [<c1020b4d>] rq_attach_root+0x17/0xa9
[43633.647009]                                             [<c1456efd>] sched_init+0x290/0x3a1
[43633.647009]                                             [<c1448625>] start_kernel+0x15d/0x290
[43633.647009]                                             [<c1448038>] __init_begin+0x38/0x40
[43633.647009]                                             [<ffffffff>] 0xffffffff
[43633.647009]     }
[43633.647009]     ... key      at: [<c15e035c>] __key.51718+0x0/0x8
[43633.647009]     -> (&vec->lock){..-...} ops: 0 {
[43633.647009]        IN-SOFTIRQ-W at:
[43633.647009]                                                [<c104c87d>] __lock_acquire+0x558/0x12d3
[43633.647009]                                                [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]                                                [<c1078184>] cpupri_set+0x66/0xf0
[43633.647009]                                                [<c1027584>] enqueue_task_rt+0xd3/0x232
[43633.647009]                                                [<c101ad56>] enqueue_task+0x2f/0x3b
[43633.647009]                                                [<c101ae2c>] activate_task+0x24/0x2a
[43633.647009]                                                [<c102294b>] try_to_wake_up+0xcb/0x20b
[43633.647009]                                                [<c1022ac2>] wake_up_process+0x14/0x16
[43633.647009]                                                [<c1025cf7>] rebalance_domains+0x2d7/0x3b6
[43633.647009]                                                [<c1025e0a>] run_rebalance_domains+0x34/0xa7
[43633.647009]                                                [<c102e8d6>] __do_softirq+0xdb/0x1ac
[43633.647009]                                                [<c102e9d7>] do_softirq+0x30/0x48
[43633.647009]                                                [<c102eb53>] irq_exit+0x3d/0x74
[43633.647009]                                                [<c10121a6>] smp_apic_timer_interrupt+0x73/0x81
[43633.647009]                                                [<c100333b>] apic_timer_interrupt+0x2f/0x34
[43633.647009]                                                [<c1214ab7>] cpuidle_idle_call+0x6a/0xa3
[43633.647009]                                                [<c1001beb>] cpu_idle+0x53/0x88
[43633.647009]                                                [<c12927c1>] start_secondary+0x1ad/0x1b4
[43633.647009]                                                [<ffffffff>] 0xffffffff
[43633.647009]        INITIAL USE at:
[43633.647009]                                               [<c104c943>] __lock_acquire+0x61e/0x12d3
[43633.647009]                                               [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                               [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]                                               [<c10781c7>] cpupri_set+0xa9/0xf0
[43633.647009]                                               [<c101f880>] rq_online_rt+0x5e/0x61
[43633.647009]                                               [<c101cdc8>] set_rq_online+0x40/0x4a
[43633.647009]                                               [<c1020bbc>] rq_attach_root+0x86/0xa9
[43633.647009]                                               [<c1456efd>] sched_init+0x290/0x3a1
[43633.647009]                                               [<c1448625>] start_kernel+0x15d/0x290
[43633.647009]                                               [<c1448038>] __init_begin+0x38/0x40
[43633.647009]                                               [<ffffffff>] 0xffffffff
[43633.647009]      }
[43633.647009]      ... key      at: [<c1b5e218>] __key.14809+0x0/0x28
[43633.647009]     ... acquired at:
[43633.647009]    [<c104d315>] __lock_acquire+0xff0/0x12d3
[43633.647009]    [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]    [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]    [<c10781c7>] cpupri_set+0xa9/0xf0
[43633.647009]    [<c101f880>] rq_online_rt+0x5e/0x61
[43633.647009]    [<c101cdc8>] set_rq_online+0x40/0x4a
[43633.647009]    [<c1020bbc>] rq_attach_root+0x86/0xa9
[43633.647009]    [<c1456efd>] sched_init+0x290/0x3a1
[43633.647009]    [<c1448625>] start_kernel+0x15d/0x290
[43633.647009]    [<c1448038>] __init_begin+0x38/0x40
[43633.647009]    [<ffffffff>] 0xffffffff
[43633.647009] 
[43633.647009]     -> (&rt_b->rt_runtime_lock){..-...} ops: 0 {
[43633.647009]        IN-SOFTIRQ-W at:
[43633.647009]                                                [<c104c87d>] __lock_acquire+0x558/0x12d3
[43633.647009]                                                [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                                [<c1027611>] enqueue_task_rt+0x160/0x232
[43633.647009]                                                [<c101ad56>] enqueue_task+0x2f/0x3b
[43633.647009]                                                [<c101ae2c>] activate_task+0x24/0x2a
[43633.647009]                                                [<c102294b>] try_to_wake_up+0xcb/0x20b
[43633.647009]                                                [<c1022ac2>] wake_up_process+0x14/0x16
[43633.647009]                                                [<c1025cf7>] rebalance_domains+0x2d7/0x3b6
[43633.647009]                                                [<c1025e0a>] run_rebalance_domains+0x34/0xa7
[43633.647009]                                                [<c102e8d6>] __do_softirq+0xdb/0x1ac
[43633.647009]                                                [<c102e9d7>] do_softirq+0x30/0x48
[43633.647009]                                                [<c102eb53>] irq_exit+0x3d/0x74
[43633.647009]                                                [<c10121a6>] smp_apic_timer_interrupt+0x73/0x81
[43633.647009]                                                [<c100333b>] apic_timer_interrupt+0x2f/0x34
[43633.647009]                                                [<c1214ab7>] cpuidle_idle_call+0x6a/0xa3
[43633.647009]                                                [<c1001beb>] cpu_idle+0x53/0x88
[43633.647009]                                                [<c12927c1>] start_secondary+0x1ad/0x1b4
[43633.647009]                                                [<ffffffff>] 0xffffffff
[43633.647009]        INITIAL USE at:
[43633.647009]                                               [<c104c943>] __lock_acquire+0x61e/0x12d3
[43633.647009]                                               [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                               [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                               [<c1027611>] enqueue_task_rt+0x160/0x232
[43633.647009]                                               [<c101ad56>] enqueue_task+0x2f/0x3b
[43633.647009]                                               [<c101ae2c>] activate_task+0x24/0x2a
[43633.647009]                                               [<c102294b>] try_to_wake_up+0xcb/0x20b
[43633.647009]                                               [<c1022ac2>] wake_up_process+0x14/0x16
[43633.647009]                                               [<c1293248>] migration_call+0xbc/0x470
[43633.647009]                                               [<c1457218>] migration_init+0x3b/0x4b
[43633.647009]                                               [<c1001141>] do_one_initcall+0x4f/0x116
[43633.647009]                                               [<c14481e7>] kernel_init+0x4d/0x16a
[43633.647009]                                               [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]                                               [<ffffffff>] 0xffffffff
[43633.647009]      }
[43633.647009]      ... key      at: [<c15e0364>] __key.41387+0x0/0x8
[43633.647009]      -> (&cpu_base->lock){-.-.-.} ops: 0 {
[43633.647009]         IN-HARDIRQ-W at:
[43633.647009]                                                  [<c104c85e>] __lock_acquire+0x539/0x12d3
[43633.647009]                                                  [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                  [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                                  [<c103f3a0>] hrtimer_run_queues+0xde/0x11c
[43633.647009]                                                  [<c1032c4e>] run_local_timers+0xd/0x1e
[43633.647009]                                                  [<c1032c88>] update_process_times+0x29/0x53
[43633.647009]                                                  [<c1046e81>] tick_periodic+0x6c/0x79
[43633.647009]                                                  [<c1046eab>] tick_handle_periodic+0x1d/0x76
[43633.647009]                                                  [<c10121a1>] smp_apic_timer_interrupt+0x6e/0x81
[43633.647009]                                                  [<c100333b>] apic_timer_interrupt+0x2f/0x34
[43633.647009]                                                  [<c10991d4>] cache_alloc_debugcheck_after+0x5d/0x194
[43633.647009]                                                  [<c109aa5f>] kmem_cache_alloc+0xd4/0x16e
[43633.647009]                                                  [<c109a3f6>] cache_alloc_refill+0x371/0x5c3
[43633.647009]                                                  [<c109a8d2>] __kmalloc+0xea/0x1a3
[43633.647009]                                                  [<c109adc3>] alloc_arraycache+0x1e/0x50
[43633.647009]                                                  [<c129484a>] cpuup_callback+0x14d/0x261
[43633.647009]                                                  [<c1299ed1>] notifier_call_chain+0x51/0x7e
[43633.647009]                                                  [<c104082e>] __raw_notifier_call_chain+0x13/0x15
[43633.647009]                                                  [<c12936d4>] _cpu_up+0x62/0x105
[43633.647009]                                                  [<c12937c3>] cpu_up+0x4c/0x5c
[43633.647009]                                                  [<c1448233>] kernel_init+0x99/0x16a
[43633.647009]                                                  [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]                                                  [<ffffffff>] 0xffffffff
[43633.647009]         IN-SOFTIRQ-W at:
[43633.647009]                                                  [<c104c87d>] __lock_acquire+0x558/0x12d3
[43633.647009]                                                  [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                  [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]                                                  [<c103f695>] lock_hrtimer_base+0x1d/0x38
[43633.647009]                                                  [<c103f7b8>] __hrtimer_start_range_ns+0x34/0x326
[43633.647009]                                                  [<c103fade>] hrtimer_start_range_ns+0x18/0x1d
[43633.647009]                                                  [<c1047f3e>] tick_setup_sched_timer+0x10b/0x133
[43633.647009]                                                  [<c103f536>] hrtimer_run_pending+0xb7/0xed
[43633.647009]                                                  [<c1032476>] run_timer_softirq+0x27/0x1f0
[43633.647009]                                                  [<c102e8d6>] __do_softirq+0xdb/0x1ac
[43633.647009]                                                  [<c102e9d7>] do_softirq+0x30/0x48
[43633.647009]                                                  [<c102eb53>] irq_exit+0x3d/0x74
[43633.647009]                                                  [<c10121a6>] smp_apic_timer_interrupt+0x73/0x81
[43633.647009]                                                  [<c100333b>] apic_timer_interrupt+0x2f/0x34
[43633.647009]                                                  [<c1001beb>] cpu_idle+0x53/0x88
[43633.647009]                                                  [<c12927c1>] start_secondary+0x1ad/0x1b4
[43633.647009]                                                  [<ffffffff>] 0xffffffff
[43633.647009]         IN-RECLAIM_FS-W at:
[43633.647009]                                                     [<c104c92d>] __lock_acquire+0x608/0x12d3
[43633.647009]                                                     [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                     [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                                     [<c103fdf4>] hrtimer_interrupt+0xad/0x16c
[43633.647009]                                                     [<c10121a1>] smp_apic_timer_interrupt+0x6e/0x81
[43633.647009]                                                     [<c100333b>] apic_timer_interrupt+0x2f/0x34
[43633.647009]                                                     [<c103c78b>] kthread+0x70/0x75
[43633.647009]                                                     [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]                                                     [<ffffffff>] 0xffffffff
[43633.647009]         INITIAL USE at:
[43633.647009]                                                 [<c104c943>] __lock_acquire+0x61e/0x12d3
[43633.647009]                                                 [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                 [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]                                                 [<c103f695>] lock_hrtimer_base+0x1d/0x38
[43633.647009]                                                 [<c103f7b8>] __hrtimer_start_range_ns+0x34/0x326
[43633.647009]                                                 [<c1027662>] enqueue_task_rt+0x1b1/0x232
[43633.647009]                                                 [<c101ad56>] enqueue_task+0x2f/0x3b
[43633.647009]                                                 [<c101ae2c>] activate_task+0x24/0x2a
[43633.647009]                                                 [<c102294b>] try_to_wake_up+0xcb/0x20b
[43633.647009]                                                 [<c1022ac2>] wake_up_process+0x14/0x16
[43633.647009]                                                 [<c1293248>] migration_call+0xbc/0x470
[43633.647009]                                                 [<c1457218>] migration_init+0x3b/0x4b
[43633.647009]                                                 [<c1001141>] do_one_initcall+0x4f/0x116
[43633.647009]                                                 [<c14481e7>] kernel_init+0x4d/0x16a
[43633.647009]                                                 [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]                                                 [<ffffffff>] 0xffffffff
[43633.647009]       }
[43633.647009]       ... key      at: [<c1623538>] __key.20989+0x0/0x8
[43633.647009]       -> (&cpu_base->lock/1){......} ops: 0 {
[43633.647009]          INITIAL USE at:
[43633.647009]                                                   [<c104c943>] __lock_acquire+0x61e/0x12d3
[43633.647009]                                                   [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                   [<c12979f0>] _spin_lock_nested+0x34/0x64
[43633.647009]                                                   [<c1293ed9>] hrtimer_cpu_notify+0xf5/0x17d
[43633.647009]                                                   [<c1299ed1>] notifier_call_chain+0x51/0x7e
[43633.647009]                                                   [<c1040841>] raw_notifier_call_chain+0x11/0x13
[43633.647009]                                                   [<c128883f>] _cpu_down+0x16f/0x23a
[43633.647009]                                                   [<c102ad11>] disable_nonboot_cpus+0x5d/0xf4
[43633.647009]                                                   [<c1057a92>] suspend_devices_and_enter+0xbe/0x178
[43633.647009]                                                   [<c1057c19>] enter_state+0xcd/0x119
[43633.647009]                                                   [<c10573d5>] state_store+0x98/0xac
[43633.647009]                                                   [<c114e6b5>] kobj_attr_store+0x16/0x22
[43633.647009]                                                   [<c10daed5>] sysfs_write_file+0xcd/0xf8
[43633.647009]                                                   [<c109e7af>] vfs_write+0x8f/0x117
[43633.647009]                                                   [<c109e8f3>] sys_write+0x48/0x75
[43633.647009]                                                   [<c1002988>] sysenter_do_call+0x12/0x36
[43633.647009]                                                   [<ffffffff>] 0xffffffff
[43633.647009]        }
[43633.647009]        ... key      at: [<c1623539>] __key.20989+0x1/0x8
[43633.647009]       ... acquired at:
[43633.647009]    [<c104d315>] __lock_acquire+0xff0/0x12d3
[43633.647009]    [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]    [<c12979f0>] _spin_lock_nested+0x34/0x64
[43633.647009]    [<c1293ed9>] hrtimer_cpu_notify+0xf5/0x17d
[43633.647009]    [<c1299ed1>] notifier_call_chain+0x51/0x7e
[43633.647009]    [<c1040841>] raw_notifier_call_chain+0x11/0x13
[43633.647009]    [<c128883f>] _cpu_down+0x16f/0x23a
[43633.647009]    [<c102ad11>] disable_nonboot_cpus+0x5d/0xf4
[43633.647009]    [<c1057a92>] suspend_devices_and_enter+0xbe/0x178
[43633.647009]    [<c1057c19>] enter_state+0xcd/0x119
[43633.647009]    [<c10573d5>] state_store+0x98/0xac
[43633.647009]    [<c114e6b5>] kobj_attr_store+0x16/0x22
[43633.647009]    [<c10daed5>] sysfs_write_file+0xcd/0xf8
[43633.647009]    [<c109e7af>] vfs_write+0x8f/0x117
[43633.647009]    [<c109e8f3>] sys_write+0x48/0x75
[43633.647009]    [<c1002988>] sysenter_do_call+0x12/0x36
[43633.647009]    [<ffffffff>] 0xffffffff
[43633.647009] 
[43633.647009]      ... acquired at:
[43633.647009]    [<c104d315>] __lock_acquire+0xff0/0x12d3
[43633.647009]    [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]    [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]    [<c103f695>] lock_hrtimer_base+0x1d/0x38
[43633.647009]    [<c103f7b8>] __hrtimer_start_range_ns+0x34/0x326
[43633.647009]    [<c1027662>] enqueue_task_rt+0x1b1/0x232
[43633.647009]    [<c101ad56>] enqueue_task+0x2f/0x3b
[43633.647009]    [<c101ae2c>] activate_task+0x24/0x2a
[43633.647009]    [<c102294b>] try_to_wake_up+0xcb/0x20b
[43633.647009]    [<c1022ac2>] wake_up_process+0x14/0x16
[43633.647009]    [<c1293248>] migration_call+0xbc/0x470
[43633.647009]    [<c1457218>] migration_init+0x3b/0x4b
[43633.647009]    [<c1001141>] do_one_initcall+0x4f/0x116
[43633.647009]    [<c14481e7>] kernel_init+0x4d/0x16a
[43633.647009]    [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]    [<ffffffff>] 0xffffffff
[43633.647009] 
[43633.647009]      -> (&rt_rq->rt_runtime_lock){-.-...} ops: 0 {
[43633.647009]         IN-HARDIRQ-W at:
[43633.647009]                                                  [<c104c85e>] __lock_acquire+0x539/0x12d3
[43633.647009]                                                  [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                  [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                                  [<c101f3eb>] update_curr_rt+0x123/0x1b0
[43633.647009]                                                  [<c101f48c>] task_tick_rt+0x14/0xb1
[43633.647009]                                                  [<c1026234>] scheduler_tick+0xd8/0x1dc
[43633.647009]                                                  [<c1032ca6>] update_process_times+0x47/0x53
[43633.647009]                                                  [<c1047d9b>] tick_sched_timer+0x71/0x9f
[43633.647009]                                                  [<c103f290>] __run_hrtimer+0x6b/0x9d
[43633.647009]                                                  [<c103fe59>] hrtimer_interrupt+0x112/0x16c
[43633.647009]                                                  [<c10121a1>] smp_apic_timer_interrupt+0x6e/0x81
[43633.647009]                                                  [<c100333b>] apic_timer_interrupt+0x2f/0x34
[43633.647009]                                                  [<c1038a94>] worker_thread+0x1aa/0x287
[43633.647009]                                                  [<c103c78b>] kthread+0x70/0x75
[43633.647009]                                                  [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]                                                  [<ffffffff>] 0xffffffff
[43633.647009]         IN-SOFTIRQ-W at:
[43633.647009]                                                  [<c104c87d>] __lock_acquire+0x558/0x12d3
[43633.647009]                                                  [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                  [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                                  [<c101fc8f>] sched_rt_period_timer+0xbc/0x201
[43633.647009]                                                  [<c103f290>] __run_hrtimer+0x6b/0x9d
[43633.647009]                                                  [<c103fe59>] hrtimer_interrupt+0x112/0x16c
[43633.647009]                                                  [<c1047138>] tick_do_broadcast+0x32/0x5b
[43633.647009]                                                  [<c1047210>] tick_handle_oneshot_broadcast+0xaf/0xe7
[43633.647009]                                                  [<c1004c76>] timer_interrupt+0x3e/0x45
[43633.647009]                                                  [<c105fcef>] handle_IRQ_event+0x6a/0x12f
[43633.647009]                                                  [<c1061365>] handle_edge_irq+0xcf/0x112
[43633.647009]                                                  [<c100489d>] handle_irq+0x40/0x4b
[43633.647009]                                                  [<c100401c>] do_IRQ+0x49/0x9c
[43633.647009]                                                  [<c100302e>] common_interrupt+0x2e/0x34
[43633.647009]                                                  [<c102e9d7>] do_softirq+0x30/0x48
[43633.647009]                                                  [<c102eb53>] irq_exit+0x3d/0x74
[43633.647009]                                                  [<c100405b>] do_IRQ+0x88/0x9c
[43633.647009]                                                  [<c100302e>] common_interrupt+0x2e/0x34
[43633.647009]                                                  [<c1214ab7>] cpuidle_idle_call+0x6a/0xa3
[43633.647009]                                                  [<c1001beb>] cpu_idle+0x53/0x88
[43633.647009]                                                  [<c12880c4>] rest_init+0x6c/0x6e
[43633.647009]                                                  [<c1448753>] start_kernel+0x28b/0x290
[43633.647009]                                                  [<c1448038>] __init_begin+0x38/0x40
[43633.647009]                                                  [<ffffffff>] 0xffffffff
[43633.647009]         INITIAL USE at:
[43633.647009]                                                 [<c104c943>] __lock_acquire+0x61e/0x12d3
[43633.647009]                                                 [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                 [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                                 [<c101f3eb>] update_curr_rt+0x123/0x1b0
[43633.647009]                                                 [<c101fa28>] dequeue_task_rt+0x22/0x62
[43633.647009]                                                 [<c101adfa>] dequeue_task+0x98/0xa6
[43633.647009]                                                 [<c101ae56>] deactivate_task+0x24/0x2a
[43633.647009]                                                 [<c129519c>] schedule+0x13e/0x81f
[43633.647009]                                                 [<c10259bb>] migration_thread+0x179/0x1de
[43633.647009]                                                 [<c103c78b>] kthread+0x70/0x75
[43633.647009]                                                 [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]                                                 [<ffffffff>] 0xffffffff
[43633.647009]       }
[43633.647009]       ... key      at: [<c15e036c>] __key.51698+0x0/0x8
[43633.647009]      ... acquired at:
[43633.647009]    [<c104d315>] __lock_acquire+0xff0/0x12d3
[43633.647009]    [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]    [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]    [<c101dc40>] __enable_runtime+0x34/0x7f
[43633.647009]    [<c101f866>] rq_online_rt+0x44/0x61
[43633.647009]    [<c101cdc8>] set_rq_online+0x40/0x4a
[43633.647009]    [<c129327c>] migration_call+0xf0/0x470
[43633.647009]    [<c1299ed1>] notifier_call_chain+0x51/0x7e
[43633.647009]    [<c1040841>] raw_notifier_call_chain+0x11/0x13
[43633.647009]    [<c1293738>] _cpu_up+0xc6/0x105
[43633.647009]    [<c12937c3>] cpu_up+0x4c/0x5c
[43633.647009]    [<c1448233>] kernel_init+0x99/0x16a
[43633.647009]    [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]    [<ffffffff>] 0xffffffff
[43633.647009] 
[43633.647009]     ... acquired at:
[43633.647009]    [<c104d315>] __lock_acquire+0xff0/0x12d3
[43633.647009]    [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]    [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]    [<c1027611>] enqueue_task_rt+0x160/0x232
[43633.647009]    [<c101ad56>] enqueue_task+0x2f/0x3b
[43633.647009]    [<c101ae2c>] activate_task+0x24/0x2a
[43633.647009]    [<c102294b>] try_to_wake_up+0xcb/0x20b
[43633.647009]    [<c1022ac2>] wake_up_process+0x14/0x16
[43633.647009]    [<c1293248>] migration_call+0xbc/0x470
[43633.647009]    [<c1457218>] migration_init+0x3b/0x4b
[43633.647009]    [<c1001141>] do_one_initcall+0x4f/0x116
[43633.647009]    [<c14481e7>] kernel_init+0x4d/0x16a
[43633.647009]    [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]    [<ffffffff>] 0xffffffff
[43633.647009] 
[43633.647009]     ... acquired at:
[43633.647009]    [<c104d315>] __lock_acquire+0xff0/0x12d3
[43633.647009]    [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]    [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]    [<c101f3eb>] update_curr_rt+0x123/0x1b0
[43633.647009]    [<c101fa28>] dequeue_task_rt+0x22/0x62
[43633.647009]    [<c101adfa>] dequeue_task+0x98/0xa6
[43633.647009]    [<c101ae56>] deactivate_task+0x24/0x2a
[43633.647009]    [<c129519c>] schedule+0x13e/0x81f
[43633.647009]    [<c10259bb>] migration_thread+0x179/0x1de
[43633.647009]    [<c103c78b>] kthread+0x70/0x75
[43633.647009]    [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]    [<ffffffff>] 0xffffffff
[43633.647009] 
[43633.647009]     -> (&rq->lock/1){..-...} ops: 0 {
[43633.647009]        IN-SOFTIRQ-W at:
[43633.647009]                                                [<c104c87d>] __lock_acquire+0x558/0x12d3
[43633.647009]                                                [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                [<c12979f0>] _spin_lock_nested+0x34/0x64
[43633.647009]                                                [<c102232a>] double_rq_lock+0x4c/0x7f
[43633.647009]                                                [<c1025ba9>] rebalance_domains+0x189/0x3b6
[43633.647009]                                                [<c1025e0a>] run_rebalance_domains+0x34/0xa7
[43633.647009]                                                [<c102e8d6>] __do_softirq+0xdb/0x1ac
[43633.647009]                                                [<c102e9d7>] do_softirq+0x30/0x48
[43633.647009]                                                [<c102eb53>] irq_exit+0x3d/0x74
[43633.647009]                                                [<c10121a6>] smp_apic_timer_interrupt+0x73/0x81
[43633.647009]                                                [<c100333b>] apic_timer_interrupt+0x2f/0x34
[43633.647009]                                                [<c1001beb>] cpu_idle+0x53/0x88
[43633.647009]                                                [<c12927c1>] start_secondary+0x1ad/0x1b4
[43633.647009]                                                [<ffffffff>] 0xffffffff
[43633.647009]        INITIAL USE at:
[43633.647009]                                               [<c104c943>] __lock_acquire+0x61e/0x12d3
[43633.647009]                                               [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                               [<c12979f0>] _spin_lock_nested+0x34/0x64
[43633.647009]                                               [<c102232a>] double_rq_lock+0x4c/0x7f
[43633.647009]                                               [<c1024c11>] __migrate_task+0x4d/0xc1
[43633.647009]                                               [<c10259ef>] migration_thread+0x1ad/0x1de
[43633.647009]                                               [<c103c78b>] kthread+0x70/0x75
[43633.647009]                                               [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]                                               [<ffffffff>] 0xffffffff
[43633.647009]      }
[43633.647009]      ... key      at: [<c15e035d>] __key.51718+0x1/0x8
[43633.647009]      -> (&sig->cputimer.lock){-.-...} ops: 0 {
[43633.647009]         IN-HARDIRQ-W at:
[43633.647009]                                                  [<c104c85e>] __lock_acquire+0x539/0x12d3
[43633.647009]                                                  [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                  [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                                  [<c101debd>] account_system_time+0x105/0x157
[43633.647009]                                                  [<c101df78>] account_process_tick+0x69/0x7e
[43633.647009]                                                  [<c1032c83>] update_process_times+0x24/0x53
[43633.647009]                                                  [<c1047d9b>] tick_sched_timer+0x71/0x9f
[43633.647009]                                                  [<c103f290>] __run_hrtimer+0x6b/0x9d
[43633.647009]                                                  [<c103fe59>] hrtimer_interrupt+0x112/0x16c
[43633.647009]                                                  [<c10121a1>] smp_apic_timer_interrupt+0x6e/0x81
[43633.647009]                                                  [<c100333b>] apic_timer_interrupt+0x2f/0x34
[43633.647009]                                                  [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                                  [<c10ac78c>] __d_lookup+0x96/0x140
[43633.647009]                                                  [<c10a50c6>] do_lookup+0x23/0x158
[43633.647009]                                                  [<c10a6584>] __link_path_walk+0x30d/0xae6
[43633.647009]                                                  [<c10a6eb2>] path_walk+0x3e/0x77
[43633.647009]                                                  [<c10a6f78>] do_path_lookup+0x26/0x47
[43633.647009]                                                  [<c10a79fe>] do_filp_open+0xcc/0x6e1
[43633.647009]                                                  [<c109c965>] do_sys_open+0x4d/0xe9
[43633.647009]                                                  [<c109ca4d>] sys_open+0x23/0x2b
[43633.647009]                                                  [<c1002988>] sysenter_do_call+0x12/0x36
[43633.647009]                                                  [<ffffffff>] 0xffffffff
[43633.647009]         IN-SOFTIRQ-W at:
[43633.647009]                                                  [<c104c87d>] __lock_acquire+0x558/0x12d3
[43633.647009]                                                  [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                  [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                                  [<c101d7df>] update_curr+0x128/0x149
[43633.647009]                                                  [<c101ed63>] enqueue_task_fair+0x40/0xdc
[43633.647009]                                                  [<c101ad56>] enqueue_task+0x2f/0x3b
[43633.647009]                                                  [<c101ae2c>] activate_task+0x24/0x2a
[43633.647009]                                                  [<c102294b>] try_to_wake_up+0xcb/0x20b
[43633.647009]                                                  [<c1022a9b>] default_wake_function+0x10/0x12
[43633.647009]                                                  [<c103ca74>] autoremove_wake_function+0x14/0x34
[43633.647009]                                                  [<c103cac3>] wake_bit_function+0x2f/0x3c
[43633.647009]                                                  [<c101b00a>] __wake_up_common+0x39/0x61
[43633.647009]                                                  [<c101d557>] __wake_up+0x2e/0x40
[43633.647009]                                                  [<c103c9fd>] __wake_up_bit+0x2c/0x2f
[43633.647009]                                                  [<c107921f>] end_page_writeback+0x65/0x68
[43633.647009]                                                  [<c10ba9e5>] end_buffer_async_write+0x139/0x189
[43633.647009]                                                  [<c10b9449>] end_bio_bh_io_sync+0x33/0x3d
[43633.647009]                                                  [<c10bc824>] bio_endio+0x28/0x2a
[43633.647009]                                                  [<c113e468>] req_bio_endio+0x89/0xa6
[43633.647009]                                                  [<c113e66b>] blk_update_request+0x1e6/0x379
[43633.647009]                                                  [<c113e811>] blk_update_bidi_request+0x13/0x41
[43633.647009]                                                  [<c1140320>] blk_end_bidi_request+0x1d/0x55
[43633.647009]                                                  [<c1140396>] blk_end_request+0xf/0x11
[43633.647009]                                                  [<c11cb225>] scsi_io_completion+0x196/0x3c4
[43633.647009]                                                  [<c11c5785>] scsi_finish_command+0xd3/0xdb
[43633.647009]                                                  [<c11cb554>] scsi_softirq_done+0xed/0xf5
[43633.647009]                                                  [<c1145c63>] blk_done_softirq+0x63/0x70
[43633.647009]                                                  [<c102e8d6>] __do_softirq+0xdb/0x1ac
[43633.647009]                                                  [<c102e9d7>] do_softirq+0x30/0x48
[43633.647009]                                                  [<c102eb53>] irq_exit+0x3d/0x74
[43633.647009]                                                  [<c100405b>] do_IRQ+0x88/0x9c
[43633.647009]                                                  [<c100302e>] common_interrupt+0x2e/0x34
[43633.647009]                                                  [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]                                                  [<f8043d41>] unix_stream_recvmsg+0xf7/0x416 [unix]
[43633.647009]                                                  [<c12259bd>] sock_aio_read+0xd7/0xe1
[43633.647009]                                                  [<c109df9b>] do_sync_read+0xb0/0xeb
[43633.647009]                                                  [<c109e9bd>] vfs_read+0x9d/0x115
[43633.647009]                                                  [<c109eaf1>] sys_read+0x48/0x75
[43633.647009]                                                  [<c1002988>] sysenter_do_call+0x12/0x36
[43633.647009]                                                  [<ffffffff>] 0xffffffff
[43633.647009]         INITIAL USE at:
[43633.647009]                                                 [<c104c943>] __lock_acquire+0x61e/0x12d3
[43633.647009]                                                 [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]                                                 [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]                                                 [<c103d893>] thread_group_cputimer+0x26/0xae
[43633.647009]                                                 [<c103d93e>] cpu_timer_sample_group+0x23/0x66
[43633.647009]                                                 [<c103d9af>] set_process_cpu_timer+0x2e/0xb4
[43633.647009]                                                 [<c103da8f>] update_rlimit_cpu+0x5a/0x73
[43633.647009]                                                 [<c1036739>] sys_setrlimit+0xdf/0xf6
[43633.647009]                                                 [<c1002988>] sysenter_do_call+0x12/0x36
[43633.647009]                                                 [<ffffffff>] 0xffffffff
[43633.647009]       }
[43633.647009]       ... key      at: [<c15e1668>] __key.21973+0x0/0x8
[43633.647009]      ... acquired at:
[43633.647009]    [<c104d315>] __lock_acquire+0xff0/0x12d3
[43633.647009]    [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]    [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]    [<c101d7df>] update_curr+0x128/0x149
[43633.647009]    [<c101ed63>] enqueue_task_fair+0x40/0xdc
[43633.647009]    [<c101ad56>] enqueue_task+0x2f/0x3b
[43633.647009]    [<c101ae2c>] activate_task+0x24/0x2a
[43633.647009]    [<c1024c55>] __migrate_task+0x91/0xc1
[43633.647009]    [<c10259ef>] migration_thread+0x1ad/0x1de
[43633.647009]    [<c103c78b>] kthread+0x70/0x75
[43633.647009]    [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]    [<ffffffff>] 0xffffffff
[43633.647009] 
[43633.647009]     ... acquired at:
[43633.647009]    [<c104d315>] __lock_acquire+0xff0/0x12d3
[43633.647009]    [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]    [<c12979f0>] _spin_lock_nested+0x34/0x64
[43633.647009]    [<c102232a>] double_rq_lock+0x4c/0x7f
[43633.647009]    [<c1024c11>] __migrate_task+0x4d/0xc1
[43633.647009]    [<c10259ef>] migration_thread+0x1ad/0x1de
[43633.647009]    [<c103c78b>] kthread+0x70/0x75
[43633.647009]    [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]    [<ffffffff>] 0xffffffff
[43633.647009] 
[43633.647009]     ... acquired at:
[43633.647009]    [<c104d315>] __lock_acquire+0xff0/0x12d3
[43633.647009]    [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]    [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]    [<c101d7df>] update_curr+0x128/0x149
[43633.647009]    [<c101e7b5>] dequeue_task_fair+0x40/0x188
[43633.647009]    [<c101adfa>] dequeue_task+0x98/0xa6
[43633.647009]    [<c101ae56>] deactivate_task+0x24/0x2a
[43633.647009]    [<c129519c>] schedule+0x13e/0x81f
[43633.647009]    [<c12958a0>] io_schedule+0x23/0x2d
[43633.647009]    [<c1079186>] sync_page+0x47/0x4b
[43633.647009]    [<c1079197>] sync_page_killable+0xd/0x30
[43633.647009]    [<c1295bf3>] __wait_on_bit_lock+0x39/0x75
[43633.647009]    [<c10790ae>] __lock_page_killable+0x74/0x7b
[43633.647009]    [<c107adb5>] generic_file_aio_read+0x383/0x532
[43633.647009]    [<c109df9b>] do_sync_read+0xb0/0xeb
[43633.647009]    [<c109e9ad>] vfs_read+0x8d/0x115
[43633.647009]    [<c109eaf1>] sys_read+0x48/0x75
[43633.647009]    [<c1002988>] sysenter_do_call+0x12/0x36
[43633.647009]    [<ffffffff>] 0xffffffff
[43633.647009] 
[43633.647009]    ... acquired at:
[43633.647009]    [<c104d315>] __lock_acquire+0xff0/0x12d3
[43633.647009]    [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]    [<c1297a4d>] _spin_lock+0x2d/0x5d
[43633.647009]    [<c101d62c>] task_rq_lock+0x3b/0x65
[43633.647009]    [<c10228b1>] try_to_wake_up+0x31/0x20b
[43633.647009]    [<c1022a9b>] default_wake_function+0x10/0x12
[43633.647009]    [<c103ca74>] autoremove_wake_function+0x14/0x34
[43633.647009]    [<c101b00a>] __wake_up_common+0x39/0x61
[43633.647009]    [<c101d557>] __wake_up+0x2e/0x40
[43633.647009]    [<c1038ccd>] insert_work+0x9a/0xa3
[43633.647009]    [<c10394f4>] __queue_work+0x26/0x34
[43633.647009]    [<c103957c>] queue_work_on+0x40/0x49
[43633.647009]    [<c10396a2>] queue_work+0x26/0x4a
[43633.647009]    [<c1037fe7>] call_usermodehelper_exec+0x8f/0xe1
[43633.647009]    [<c114f357>] kobject_uevent_env+0x333/0x368
[43633.647009]    [<c114f396>] kobject_uevent+0xa/0xc
[43633.647009]    [<c114eb0c>] kset_register+0x2e/0x34
[43633.647009]    [<c11b74fe>] bus_register+0xe4/0x232
[43633.647009]    [<c146315e>] platform_bus_init+0x23/0x38
[43633.647009]    [<c14631f6>] driver_init+0x1c/0x28
[43633.647009]    [<c144828c>] kernel_init+0xf2/0x16a
[43633.647009]    [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]    [<ffffffff>] 0xffffffff
[43633.647009] 
[43633.647009]   ... acquired at:
[43633.647009]    [<c104d315>] __lock_acquire+0xff0/0x12d3
[43633.647009]    [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]    [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]    [<c101d543>] __wake_up+0x1a/0x40
[43633.647009]    [<c1038ccd>] insert_work+0x9a/0xa3
[43633.647009]    [<c10394f4>] __queue_work+0x26/0x34
[43633.647009]    [<c103957c>] queue_work_on+0x40/0x49
[43633.647009]    [<c10396a2>] queue_work+0x26/0x4a
[43633.647009]    [<c1037fe7>] call_usermodehelper_exec+0x8f/0xe1
[43633.647009]    [<c114f357>] kobject_uevent_env+0x333/0x368
[43633.647009]    [<c114f396>] kobject_uevent+0xa/0xc
[43633.647009]    [<c114eb0c>] kset_register+0x2e/0x34
[43633.647009]    [<c11b74fe>] bus_register+0xe4/0x232
[43633.647009]    [<c146315e>] platform_bus_init+0x23/0x38
[43633.647009]    [<c14631f6>] driver_init+0x1c/0x28
[43633.647009]    [<c144828c>] kernel_init+0xf2/0x16a
[43633.647009]    [<c10034f7>] kernel_thread_helper+0x7/0x10
[43633.647009]    [<ffffffff>] 0xffffffff
[43633.647009] 
[43633.647009]  ... acquired at:
[43633.647009]    [<c104d315>] __lock_acquire+0xff0/0x12d3
[43633.647009]    [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]    [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]    [<c10394e5>] __queue_work+0x17/0x34
[43633.647009]    [<c103957c>] queue_work_on+0x40/0x49
[43633.647009]    [<c10396a2>] queue_work+0x26/0x4a
[43633.647009]    [<c10396da>] schedule_work+0x14/0x16
[43633.647009]    [<fa2558ff>] add_todo+0x4a/0x58 [mac80211]
[43633.647009]    [<fa256173>] ieee80211_key_link+0x11a/0x138 [mac80211]
[43633.647009]    [<fa2505ff>] ieee80211_add_key+0xee/0x128 [mac80211]
[43633.647009]    [<f8f34451>] cfg80211_set_encryption+0xf2/0x163 [cfg80211]
[43633.647009]    [<f8f34618>] cfg80211_wext_siwencodeext+0x156/0x16f [cfg80211]
[43633.647009]    [<c128779c>] ioctl_standard_call+0x1cc/0x27f
[43633.647009]    [<c1287922>] wext_handle_ioctl+0xd3/0x15d
[43633.647009]    [<c12353e5>] dev_ioctl+0x564/0x584
[43633.647009]    [<c1225eb5>] sock_ioctl+0x1e6/0x1f2
[43633.647009]    [<c10a8d82>] vfs_ioctl+0x1d/0x76
[43633.647009]    [<c10a9321>] do_vfs_ioctl+0x4a0/0x4de
[43633.647009]    [<c10a9392>] sys_ioctl+0x33/0x4d
[43633.647009]    [<c1002988>] sysenter_do_call+0x12/0x36
[43633.647009]    [<ffffffff>] 0xffffffff
[43633.647009] 
[43633.647009] 
[43633.647009] stack backtrace:
[43633.647009] Pid: 18756, comm: cc1 Not tainted 2.6.31-rc6 #179
[43633.647009] Call Trace:
[43633.647009]  [<c1294dcf>] ? printk+0x14/0x1d
[43633.647009]  [<c104bbdb>] print_irq_inversion_bug+0x12d/0x139
[43633.647009]  [<c104bc5c>] check_usage_forwards+0x75/0x7e
[43633.647009]  [<c104bbe7>] ? check_usage_forwards+0x0/0x7e
[43633.647009]  [<c104b447>] mark_lock+0x2bc/0x49f
[43633.647009]  [<c104c87d>] __lock_acquire+0x558/0x12d3
[43633.647009]  [<fa244acd>] ? sta_info_insert+0x91/0x174 [mac80211]
[43633.647009]  [<fa244acd>] ? sta_info_insert+0x91/0x174 [mac80211]
[43633.647009]  [<c104d6a4>] lock_acquire+0xac/0xc9
[43633.647009]  [<fa244acd>] ? sta_info_insert+0x91/0x174 [mac80211]
[43633.647009]  [<c1297b78>] _spin_lock_irqsave+0x36/0x69
[43633.647009]  [<fa244acd>] ? sta_info_insert+0x91/0x174 [mac80211]
[43633.647009]  [<fa244acd>] sta_info_insert+0x91/0x174 [mac80211]
[43633.647009]  [<fa248b2a>] ieee80211_ibss_add_sta+0x119/0x12a [mac80211]
[43633.647009]  [<c104b66d>] ? mark_held_locks+0x43/0x5b
[43633.647009]  [<fa25268f>] __ieee80211_rx_handle_packet+0x349/0x552 [mac80211]
[43633.647009]  [<c104c943>] ? __lock_acquire+0x61e/0x12d3
[43633.647009]  [<fa252cbe>] ? __ieee80211_rx+0x9f/0x581 [mac80211]
[43633.647009]  [<c104b8a6>] ? trace_hardirqs_on_caller+0xf7/0x131
[43633.647009]  [<fa252cbe>] ? __ieee80211_rx+0x9f/0x581 [mac80211]
[43633.647009]  [<fa25311f>] __ieee80211_rx+0x500/0x581 [mac80211]
[43633.647009]  [<fa4ecf17>] ath5k_tasklet_rx+0x51b/0x56c [ath5k]
[43633.647009]  [<c102e209>] tasklet_action+0x93/0xe6
[43633.647009]  [<c102e8d6>] __do_softirq+0xdb/0x1ac
[43633.647009]  [<c102e9d7>] do_softirq+0x30/0x48
[43633.647009]  [<c102eb53>] irq_exit+0x3d/0x74
[43633.647009]  [<c100405b>] do_IRQ+0x88/0x9c
[43633.647009]  [<c100302e>] common_interrupt+0x2e/0x34
[43633.647009] phy0: Inserted STA 00:1e:c2:3b:f4:e3
[43646.000209] phy0: Removed STA 00:21:e9:94:5e:93
[43646.003063] phy0: Destroyed STA 00:21:e9:94:5e:93
[43713.997314] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)

-- 
Bob Copeland %% www.bobcopeland.com

