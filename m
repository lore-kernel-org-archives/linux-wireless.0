Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51664 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306Ab1JZHWh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Oct 2011 03:22:37 -0400
Message-ID: <4EA7B536.70107@qca.qualcomm.com> (sfid-20111026_092242_667403_457F4168)
Date: Wed, 26 Oct 2011 10:22:30 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2 00/31] ath6kl Add multiple vif support
References: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/25/2011 05:03 PM, Vasanthakumar Thiagarajan wrote:
> This patch set adds basic infrastructure for multiple
> virtual interface. As configuring the firmware with more than one
> vif causes random target assert, the number of supported vifs is
> restricted to 1 for now. I would like to thank Vivek Natarajan
> (nataraja@qca.qualcomm.com) for his inital work in this area and
> Arthi Thiruvengadam (athiruve@qca.qualcomm.com) for finding some
> critical bugs.

I saw the lockdep warning below after I loaded the module and connected
to an AP. But the driver still functioned normally.

Kalle

[   73.439849] ath6kl: hw 2.1.1 fw 3.1.1.609
[   75.408050]
[   75.408081] =========================================================
[   75.416320] [ INFO: possible irq lock inversion dependency detected ]
[   75.423004] 3.1.0-rc9-wl+ #44
[   75.426086] ---------------------------------------------------------
[   75.432800] swapper/0 just changed the state of lock:
[   75.438049]  (&(&ar->lock)->rlock){+.-...}, at: [<bf011b94>]
ath6kl_indicate_tx_activity+0x38/0xb8 [ath6kl]
[   75.448303] but this lock took another, SOFTIRQ-unsafe lock in the past:
[   75.455261]  (&(&ar->list_lock)->rlock){+.+...}
[   75.459808]
[   75.459808] and interrupts could create inverse lock ordering between
them.
[   75.459808]
[   75.470306]
[   75.470306] other info that might help us debug this:
[   75.477081]  Possible interrupt unsafe locking scenario:
[   75.477081]
[   75.484130]        CPU0                    CPU1
[   75.488861]        ----                    ----
[   75.493560]   lock(&(&ar->list_lock)->rlock);
[   75.498107]                                local_irq_disable();
[   75.504241]                                lock(&(&ar->lock)->rlock);
[   75.510955]
lock(&(&ar->list_lock)->rlock);
[   75.518096]   <Interrupt>
[   75.520812]     lock(&(&ar->lock)->rlock);
[   75.525085]
[   75.525085]  *** DEADLOCK ***
[   75.525085]
[   75.531249] 3 locks held by swapper/0:
[   75.535156]  #0:  (&n->timer){+.-...}, at: [<c004ebe0>]
run_timer_softirq+0x244/0x564
[   75.543334]  #1:  (rcu_read_lock_bh){.+....}, at: [<c03175e4>]
dev_queue_xmit+0x0/0x714
[   75.551696]  #2:  (_xmit_ETHER#2){+.-...}, at: [<c032bfc4>]
sch_direct_xmit+0x38/0x2dc
[   75.559936]
[   75.559967] the shortest dependencies between 2nd lock and 1st lock:
[   75.568115]  -> (&(&ar->list_lock)->rlock){+.+...} ops: 60 {
[   75.574035]     HARDIRQ-ON-W at:
[   75.577392]                                          [<c0078004>]
__lock_acquire+0x7b0/0x1a8c
[   75.586273]                                          [<c00799d4>]
lock_acquire+0x158/0x1a8
[   75.594879]                                          [<c03e272c>]
_raw_spin_lock+0x4c/0x84
[   75.603485]                                          [<bf00898c>]
ath6kl_interface_add+0x184/0x1e0 [ath6kl]
[   75.613677]                                          [<bf00d204>]
ath6kl_core_init+0xe9c/0x1760 [ath6kl]
[   75.623565]                                          [<bf01859c>]
ath6kl_sdio_probe+0x324/0x3bc [ath6kl]
[   75.633483]                                          [<c02ed524>]
sdio_bus_probe+0x100/0x164
[   75.642272]                                          [<c0274de0>]
driver_probe_device+0x14c/0x290
[   75.651519]                                          [<c0274f8c>]
__driver_attach+0x68/0x8c
[   75.660217]                                          [<c0274458>]
bus_for_each_dev+0x4c/0x8c
[   75.669006]                                          [<c0273c9c>]
bus_add_driver+0xc4/0x250
[   75.677703]                                          [<c02755f0>]
driver_register+0xc0/0x150
[   75.686462]                                          [<bf02700c>]
0xbf02700c
[   75.693817]                                          [<c00086c0>]
do_one_initcall+0x94/0x160
[   75.702606]                                          [<c0084670>]
sys_init_module+0x1220/0x13e0
[   75.711669]                                          [<c00139e0>]
ret_fast_syscall+0x0/0x3c
[   75.720367]     SOFTIRQ-ON-W at:
[   75.723724]                                          [<c0078028>]
__lock_acquire+0x7d4/0x1a8c
[   75.732604]                                          [<c00799d4>]
lock_acquire+0x158/0x1a8
[   75.741180]                                          [<c03e272c>]
_raw_spin_lock+0x4c/0x84
[   75.749786]                                          [<bf00898c>]
ath6kl_interface_add+0x184/0x1e0 [ath6kl]
[   75.759979]                                          [<bf00d204>]
ath6kl_core_init+0xe9c/0x1760 [ath6kl]
[   75.769897]                                          [<bf01859c>]
ath6kl_sdio_probe+0x324/0x3bc [ath6kl]
[   75.779785]                                          [<c02ed524>]
sdio_bus_probe+0x100/0x164
[   75.788574]                                          [<c0274de0>]
driver_probe_device+0x14c/0x290
[   75.797821]                                          [<c0274f8c>]
__driver_attach+0x68/0x8c
[   75.806518]                                          [<c0274458>]
bus_for_each_dev+0x4c/0x8c
[   75.815307]                                          [<c0273c9c>]
bus_add_driver+0xc4/0x250
[   75.824005]                                          [<c02755f0>]
driver_register+0xc0/0x150
[   75.832794]                                          [<bf02700c>]
0xbf02700c
[   75.840118]                                          [<c00086c0>]
do_one_initcall+0x94/0x160
[   75.848907]                                          [<c0084670>]
sys_init_module+0x1220/0x13e0
[   75.857940]                                          [<c00139e0>]
ret_fast_syscall+0x0/0x3c
[   75.866638]     INITIAL USE at:
[   75.869903]                                         [<c007808c>]
__lock_acquire+0x838/0x1a8c
[   75.878692]                                         [<c00799d4>]
lock_acquire+0x158/0x1a8
[   75.887207]                                         [<c03e272c>]
_raw_spin_lock+0x4c/0x84
[   75.895721]                                         [<bf00898c>]
ath6kl_interface_add+0x184/0x1e0 [ath6kl]
[   75.905792]                                         [<bf00d204>]
ath6kl_core_init+0xe9c/0x1760 [ath6kl]
[   75.915618]                                         [<bf01859c>]
ath6kl_sdio_probe+0x324/0x3bc [ath6kl]
[   75.925445]                                         [<c02ed524>]
sdio_bus_probe+0x100/0x164
[   75.934143]                                         [<c0274de0>]
driver_probe_device+0x14c/0x290
[   75.943298]                                         [<c0274f8c>]
__driver_attach+0x68/0x8c
[   75.951904]                                         [<c0274458>]
bus_for_each_dev+0x4c/0x8c
[   75.960571]                                         [<c0273c9c>]
bus_add_driver+0xc4/0x250
[   75.969177]                                         [<c02755f0>]
driver_register+0xc0/0x150
[   75.977874]                                         [<bf02700c>]
0xbf02700c
[   75.985107]                                         [<c00086c0>]
do_one_initcall+0x94/0x160
[   75.993804]                                         [<c0084670>]
sys_init_module+0x1220/0x13e0
[   76.002777]                                         [<c00139e0>]
ret_fast_syscall+0x0/0x3c
[   76.011383]   }
[   76.013183]   ... key      at: [<bf020544>]
__key.38763+0x0/0xffff848c [ath6kl]
[   76.020843]   ... acquired at:
[   76.024017]    [<c00799d4>] lock_acquire+0x158/0x1a8
[   76.029174]    [<c03e272c>] _raw_spin_lock+0x4c/0x84
[   76.034362]    [<bf015410>] ath6kl_get_vif_by_index+0x68/0x78 [ath6kl]
[   76.041198]    [<bf0116b0>] ath6kl_tx_complete+0x178/0x4c0 [ath6kl]
[   76.047760]    [<bf0046ec>] htc_tx_comp_handler+0x4c/0x54 [ath6kl]
[   76.054229]    [<bf0030a8>] ath6kl_hif_rw_comp_handler+0x48/0x60 [ath6kl]
[   76.061340]    [<bf0186c4>] ath6kl_sdio_write_async_work+0x90/0xbc
[ath6kl]
[   76.068634]    [<c005a8c4>] process_one_work+0x354/0x628
[   76.074157]    [<c005cb74>] worker_thread+0x1f4/0x3c0
[   76.079437]    [<c006147c>] kthread+0x80/0x88
[   76.083953]    [<c001496c>] kernel_thread_exit+0x0/0x8
[   76.089324]
[   76.090850] -> (&(&ar->lock)->rlock){+.-...} ops: 23 {
[   76.096221]    HARDIRQ-ON-W at:
[   76.099487]                                        [<c0078004>]
__lock_acquire+0x7b0/0x1a8c
[   76.108184]                                        [<c00799d4>]
lock_acquire+0x158/0x1a8
[   76.116607]                                        [<c03e2aa0>]
_raw_spin_lock_bh+0x54/0x8c
[   76.125305]                                        [<bf0112d8>]
ath6kl_refill_amsdu_rxbufs+0x68/0x94 [ath6kl]
[   76.135681]                                        [<bf00da98>]
ath6kl_core_init+0x1730/0x1760 [ath6kl]
[   76.145477]                                        [<bf01859c>]
ath6kl_sdio_probe+0x324/0x3bc [ath6kl]
[   76.155212]                                        [<c02ed524>]
sdio_bus_probe+0x100/0x164
[   76.163818]                                        [<c0274de0>]
driver_probe_device+0x14c/0x290
[   76.172882]                                        [<c0274f8c>]
__driver_attach+0x68/0x8c
[   76.181396]                                        [<c0274458>]
bus_for_each_dev+0x4c/0x8c
[   76.190002]                                        [<c0273c9c>]
bus_add_driver+0xc4/0x250
[   76.198516]                                        [<c02755f0>]
driver_register+0xc0/0x150
[   76.207122]                                        [<bf02700c>]
0xbf02700c
[   76.214263]                                        [<c00086c0>]
do_one_initcall+0x94/0x160
[   76.222869]                                        [<c0084670>]
sys_init_module+0x1220/0x13e0
[   76.231750]                                        [<c00139e0>]
ret_fast_syscall+0x0/0x3c
[   76.240264]    IN-SOFTIRQ-W at:
[   76.243530]                                        [<c0077f9c>]
__lock_acquire+0x748/0x1a8c
[   76.252227]                                        [<c00799d4>]
lock_acquire+0x158/0x1a8
[   76.260650]                                        [<c03e2aa0>]
_raw_spin_lock_bh+0x54/0x8c
[   76.269348]                                        [<bf011b94>]
ath6kl_indicate_tx_activity+0x38/0xb8 [ath6kl]
[   76.279785]                                        [<bf014460>]
ath6kl_wmi_create_pstream_cmd+0x1e0/0x224 [ath6kl]
[   76.290618]                                        [<bf0145a4>]
ath6kl_wmi_implicit_create_pstream+0x100/0x138 [ath6kl]
[   76.301910]                                        [<bf012020>]
ath6kl_data_tx+0x2d0/0x5fc [ath6kl]
[   76.311370]                                        [<c03172a8>]
dev_hard_start_xmit+0x504/0x840
[   76.320404]                                        [<c032bfe8>]
sch_direct_xmit+0x5c/0x2dc
[   76.329010]                                        [<c0317a08>]
dev_queue_xmit+0x424/0x714
[   76.337615]                                        [<c0363864>]
arp_solicit+0x214/0x254
[   76.345977]                                        [<c0323c30>]
neigh_timer_handler+0x22c/0x2a8
[   76.355010]                                        [<c004ed08>]
run_timer_softirq+0x36c/0x564
[   76.363891]                                        [<c0047e48>]
__do_softirq+0x138/0x314
[   76.372314]                                        [<c00481d4>]
irq_exit+0x54/0xb4
[   76.380187]                                        [<c00148f8>]
handle_IRQ+0x68/0x8c
[   76.388244]                                        [<c03e34b8>]
__irq_svc+0x38/0xa0
[   76.396240]                                        [<c007673c>]
trace_hardirqs_on_caller+0x1c/0x19c
[   76.405639]                                        [<c0015018>]
cpu_idle+0x7c/0xcc
[   76.413513]                                        [<c05687f8>]
start_kernel+0x2ac/0x30c
[   76.421936]    INITIAL USE at:
[   76.425109]                                       [<c007808c>]
__lock_acquire+0x838/0x1a8c
[   76.433715]                                       [<c00799d4>]
lock_acquire+0x158/0x1a8
[   76.442047]                                       [<c03e2aa0>]
_raw_spin_lock_bh+0x54/0x8c
[   76.450653]                                       [<bf0112d8>]
ath6kl_refill_amsdu_rxbufs+0x68/0x94 [ath6kl]
[   76.460937]                                       [<bf00da98>]
ath6kl_core_init+0x1730/0x1760 [ath6kl]
[   76.470672]                                       [<bf01859c>]
ath6kl_sdio_probe+0x324/0x3bc [ath6kl]
[   76.480316]                                       [<c02ed524>]
sdio_bus_probe+0x100/0x164
[   76.488830]                                       [<c0274de0>]
driver_probe_device+0x14c/0x290
[   76.497802]                                       [<c0274f8c>]
__driver_attach+0x68/0x8c
[   76.506225]                                       [<c0274458>]
bus_for_each_dev+0x4c/0x8c
[   76.514739]                                       [<c0273c9c>]
bus_add_driver+0xc4/0x250
[   76.523162]                                       [<c02755f0>]
driver_register+0xc0/0x150
[   76.531677]                                       [<bf02700c>] 0xbf02700c
[   76.538757]                                       [<c00086c0>]
do_one_initcall+0x94/0x160
[   76.547241]                                       [<c0084670>]
sys_init_module+0x1220/0x13e0
[   76.556030]                                       [<c00139e0>]
ret_fast_syscall+0x0/0x3c
[   76.564453]  }
[   76.566192]  ... key      at: [<bf020554>] __key.38761+0x0/0xffff847c
[ath6kl]
[   76.573730]  ... acquired at:
[   76.576812]    [<c0076ea4>] check_usage_forwards+0xd8/0xfc
[   76.582519]    [<c007618c>] mark_lock+0x388/0x618
[   76.587432]    [<c0077f9c>] __lock_acquire+0x748/0x1a8c
[   76.592864]    [<c00799d4>] lock_acquire+0x158/0x1a8
[   76.598022]    [<c03e2aa0>] _raw_spin_lock_bh+0x54/0x8c
[   76.603485]    [<bf011b94>] ath6kl_indicate_tx_activity+0x38/0xb8
[ath6kl]
[   76.610687]    [<bf014460>] ath6kl_wmi_create_pstream_cmd+0x1e0/0x224
[ath6kl]
[   76.618255]    [<bf0145a4>]
ath6kl_wmi_implicit_create_pstream+0x100/0x138 [ath6kl]
[   76.626251]    [<bf012020>] ath6kl_data_tx+0x2d0/0x5fc [ath6kl]
[   76.632476]    [<c03172a8>] dev_hard_start_xmit+0x504/0x840
[   76.638275]    [<c032bfe8>] sch_direct_xmit+0x5c/0x2dc
[   76.643615]    [<c0317a08>] dev_queue_xmit+0x424/0x714
[   76.648956]    [<c0363864>] arp_solicit+0x214/0x254
[   76.654052]    [<c0323c30>] neigh_timer_handler+0x22c/0x2a8
[   76.659851]    [<c004ed08>] run_timer_softirq+0x36c/0x564
[   76.665466]    [<c0047e48>] __do_softirq+0x138/0x314
[   76.670654]    [<c00481d4>] irq_exit+0x54/0xb4
[   76.675262]    [<c00148f8>] handle_IRQ+0x68/0x8c
[   76.680084]    [<c03e34b8>] __irq_svc+0x38/0xa0
[   76.684814]    [<c007673c>] trace_hardirqs_on_caller+0x1c/0x19c
[   76.690979]    [<c0015018>] cpu_idle+0x7c/0xcc
[   76.695587]    [<c05687f8>] start_kernel+0x2ac/0x30c
[   76.700775]
[   76.702301]
[   76.702301] stack backtrace:
[   76.706878] [<c0019998>] (unwind_backtrace+0x0/0x128) from
[<c0076d88>] (print_irq_inversion_bug+0x194/0x1d8)
[   76.717193] [<c0076d88>] (print_irq_inversion_bug+0x194/0x1d8) from
[<c0076ea4>] (check_usage_forwards+0xd8/0xfc)
[   76.727874] [<c0076ea4>] (check_usage_forwards+0xd8/0xfc) from
[<c007618c>] (mark_lock+0x388/0x618)
[   76.737274] [<c007618c>] (mark_lock+0x388/0x618) from [<c0077f9c>]
(__lock_acquire+0x748/0x1a8c)
[   76.746429] [<c0077f9c>] (__lock_acquire+0x748/0x1a8c) from
[<c00799d4>] (lock_acquire+0x158/0x1a8)
[   76.755859] [<c00799d4>] (lock_acquire+0x158/0x1a8) from [<c03e2aa0>]
(_raw_spin_lock_bh+0x54/0x8c)
[   76.765319] [<c03e2aa0>] (_raw_spin_lock_bh+0x54/0x8c) from
[<bf011b94>] (ath6kl_indicate_tx_activity+0x38/0xb8 [ath6kl])
[   76.776824] [<bf011b94>] (ath6kl_indicate_tx_activity+0x38/0xb8
[ath6kl]) from [<bf014460>] (ath6kl_wmi_create_pstream_cmd+0x1e0/0x224
[ath6kl])
[   76.790405] [<bf014460>] (ath6kl_wmi_create_pstream_cmd+0x1e0/0x224
[ath6kl]) from [<bf0145a4>]
(ath6kl_wmi_implicit_create_pstream+0x100/0x138 [ath6kl])
[   76.804809] [<bf0145a4>]
(ath6kl_wmi_implicit_create_pstream+0x100/0x138 [ath6kl]) from
[<bf012020>] (ath6kl_data_tx+0x2d0/0x5fc [ath6kl])
[   76.817779] [<bf012020>] (ath6kl_data_tx+0x2d0/0x5fc [ath6kl]) from
[<c03172a8>] (dev_hard_start_xmit+0x504/0x840)
[   76.828552] [<c03172a8>] (dev_hard_start_xmit+0x504/0x840) from
[<c032bfe8>] (sch_direct_xmit+0x5c/0x2dc)
[   76.838531] [<c032bfe8>] (sch_direct_xmit+0x5c/0x2dc) from
[<c0317a08>] (dev_queue_xmit+0x424/0x714)
[   76.848022] [<c0317a08>] (dev_queue_xmit+0x424/0x714) from
[<c0363864>] (arp_solicit+0x214/0x254)
[   76.857269] [<c0363864>] (arp_solicit+0x214/0x254) from [<c0323c30>]
(neigh_timer_handler+0x22c/0x2a8)
[   76.866973] [<c0323c30>] (neigh_timer_handler+0x22c/0x2a8) from
[<c004ed08>] (run_timer_softirq+0x36c/0x564)
[   76.877197] [<c004ed08>] (run_timer_softirq+0x36c/0x564) from
[<c0047e48>] (__do_softirq+0x138/0x314)
[   76.886779] [<c0047e48>] (__do_softirq+0x138/0x314) from [<c00481d4>]
(irq_exit+0x54/0xb4)
[   76.895385] [<c00481d4>] (irq_exit+0x54/0xb4) from [<c00148f8>]
(handle_IRQ+0x68/0x8c)
[   76.903625] [<c00148f8>] (handle_IRQ+0x68/0x8c) from [<c03e34b8>]
(__irq_svc+0x38/0xa0)
[   76.911987] [<c03e34b8>] (__irq_svc+0x38/0xa0) from [<c007673c>]
(trace_hardirqs_on_caller+0x1c/0x19c)
[   76.921661] [<c007673c>] (trace_hardirqs_on_caller+0x1c/0x19c) from
[<c0015018>] (cpu_idle+0x7c/0xcc)
[   76.931243] [<c0015018>] (cpu_idle+0x7c/0xcc) from [<c05687f8>]
(start_kernel+0x2ac/0x30c)
