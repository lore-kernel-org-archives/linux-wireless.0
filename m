Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17365 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757724Ab2EaCaX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 22:30:23 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20422.55186.242020.334594@gargle.gargle.HOWL> (sfid-20120531_043054_904984_059BF78E)
Date: Thu, 31 May 2012 07:59:38 +0530
To: Ben Greear <greearb@candelatech.com>
CC: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Anyone doing WiFi throughput tests?
In-Reply-To: <4FC51418.5000104@candelatech.com>
References: <4FC04B5A.1070900@candelatech.com>
	<20416.19680.571601.549629@gargle.gargle.HOWL>
	<4FC0F8CE.1030303@candelatech.com>
	<20417.972.888113.821079@gargle.gargle.HOWL>
	<20417.1857.115550.807746@gargle.gargle.HOWL>
	<4FC2437C.9090106@candelatech.com>
	<4FC51418.5000104@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> We started testing with two AR9380 NICs today (one AP, the other STA).
> I applied Felix's skb optimization patch, and the ath9k memleak fix patch
> on top of 3.3.7+.
> 
> When we generate traffic using a modified version of pktgen,
> the STA interface transmits at around 310Mbps for a minute or
> two, but then the system dies of OOM (and maybe worse..having
> trouble getting useful serial console log).  It died much faster
> before Felix's two patches were applied.
> 
> I disabled all of our network related buffer adjustments
> (ie, no longer increasing tcp_wmem, etc), and it still
> crashes.
> 
> The system has 2GB RAM, but it is 32-bit kernel, so not all
> is available to the networking code...  That said, the OOM
> killer kills VNC and such.
> 
> Anyway, I'll try some memleak debugging to see if
> I can find any leaks.  It seems to me that we should
> not actually OOM just by trying to transmit too fast
> on a station interface :P

In my setup, UDP RX (AP->STA) locks up the station hard and eventually I get this:

[  292.093359] BUG: soft lockup - CPU#0 stuck for 23s! [syslog-ng:403]
[  292.093555] irq event stamp: 12065793
[  292.093560] hardirqs last  enabled at (12065792): [<ffffffff81490855>] _raw_spin_unlock_irqrestore+0x65/0x80
[  292.093579] hardirqs last disabled at (12065793): [<ffffffff814922ea>] apic_timer_interrupt+0x6a/0x80
[  292.093591] softirqs last  enabled at (4271834): [<ffffffff81059507>] __do_softirq+0x137/0x240
[  292.093605] softirqs last disabled at (4273355): [<ffffffff81492cec>] call_softirq+0x1c/0x30
[  292.093617] CPU 0 
[  292.093826] Pid: 403, comm: syslog-ng Tainted: G           O 3.4.0-wl #21 LENOVO 7661GN4/7661GN4
[  292.093841] RIP: 0010:[<ffffffff8149085a>]  [<ffffffff8149085a>] _raw_spin_unlock_irqrestore+0x6a/0x80
[  292.093855] RSP: 0018:ffff88007d403c90  EFLAGS: 00000282
[  292.093862] RAX: ffff880037526dd0 RBX: 0000000000000000 RCX: 0000000000000002
[  292.093869] RDX: 0000000000000002 RSI: ffff880037527428 RDI: 0000000000000282
[  292.093876] RBP: ffff88007d403ca0 R08: ffff8800755f5048 R09: 0000000000000005
[  292.093883] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88007d403c08
[  292.093889] R13: ffffffff814922ef R14: ffff88007d403ca0 R15: ffffffff81a65c80
[  292.093897] FS:  00007f6c0dc5db00(0000) GS:ffff88007d400000(0000) knlGS:0000000000000000
[  292.093905] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  292.093911] CR2: 00007f35a1fbe1c3 CR3: 0000000075490000 CR4: 00000000000007f0
[  292.093918] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  292.093925] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  292.093933] Process syslog-ng (pid: 403, threadinfo ffff8800789de000, task ffff880037526dd0)
[  292.093939] Stack:
[  292.093943]  ffff8800755f5000 0000000000000282 ffff88007d403cc0 ffffffff81270aa2
[  292.093960]  00000000000007b6 0000000000000040 ffff88007d403d10 ffffffff812720fe
[  292.093975]  0000000000000000 0000000001000000 ffff88007d403d10 ffff880075155700
[  292.093990] Call Trace:
[  292.093995]  <IRQ> 
[  292.094006]  [<ffffffff81270aa2>] dma_entry_alloc+0x62/0x90
[  292.094017]  [<ffffffff812720fe>] debug_dma_map_page+0x7e/0x140
[  292.094037]  [<ffffffffa06b3669>] ath_rx_tasklet+0x969/0x1f10 [ath9k]
[  292.094056]  [<ffffffffa06b0054>] ath9k_tasklet+0x104/0x180 [ath9k]
[  292.094068]  [<ffffffff8105a073>] tasklet_action+0x83/0x110
[  292.094079]  [<ffffffff81059498>] __do_softirq+0xc8/0x240
[  292.094091]  [<ffffffff81492cec>] call_softirq+0x1c/0x30
[  292.094102]  [<ffffffff81016855>] do_softirq+0xa5/0xe0
[  292.094113]  [<ffffffff81059986>] irq_exit+0xa6/0xe0
[  292.094124]  [<ffffffff81493583>] do_IRQ+0x63/0xe0
[  292.094134]  [<ffffffff81490cef>] common_interrupt+0x6f/0x6f
[  292.094140]  <EOI> 
[  292.094150]  [<ffffffff810aeafc>] ? mark_held_locks+0x8c/0x110
[  292.094162]  [<ffffffff8149085a>] ? _raw_spin_unlock_irqrestore+0x6a/0x80
[  292.094173]  [<ffffffff8107fd23>] __wake_up+0x53/0x70
[  292.094196]  [<ffffffffa022af3c>] jbd2_journal_stop+0x24c/0x2c0 [jbd2]
[  292.094246]  [<ffffffffa0275788>] __ext4_journal_stop+0x78/0xa0 [ext4]
[  292.094278]  [<ffffffffa025a5ad>] ext4_da_write_end+0xad/0x390 [ext4]
[  292.094293]  [<ffffffff81116d03>] generic_file_buffered_write+0x1a3/0x2c0
[  292.094309]  [<ffffffff8148dba7>] ? mutex_lock_nested+0x2f7/0x3d0
[  292.094321]  [<ffffffff81118c4a>] __generic_file_aio_write+0x22a/0x440
[  292.094334]  [<ffffffff81118ed3>] generic_file_aio_write+0x73/0xe0
[  292.094363]  [<ffffffffa025136f>] ext4_file_write+0xaf/0x270 [ext4]
[  292.094374]  [<ffffffff810adcf0>] ? lock_release_non_nested+0xa0/0x2e0
[  292.094403]  [<ffffffffa02512c0>] ? ext4_file_mmap+0x60/0x60 [ext4]
[  292.094415]  [<ffffffff8117c472>] do_sync_readv_writev+0xd2/0x110
[  292.094427]  [<ffffffff8113bd23>] ? might_fault+0x53/0xb0
[  292.094438]  [<ffffffff8120aa0c>] ? security_file_permission+0x2c/0xb0
[  292.094449]  [<ffffffff8117bb91>] ? rw_verify_area+0x61/0xf0
[  292.094460]  [<ffffffff8117c75b>] do_readv_writev+0xdb/0x1f0
[  292.094470]  [<ffffffff810adcf0>] ? lock_release_non_nested+0xa0/0x2e0
[  292.094481]  [<ffffffff8113bd23>] ? might_fault+0x53/0xb0
[  292.094491]  [<ffffffff814917d5>] ? sysret_check+0x22/0x5d
[  292.094502]  [<ffffffff8117c8a5>] vfs_writev+0x35/0x60
[  292.094511]  [<ffffffff8117ca3a>] sys_writev+0x4a/0xc0
[  292.094523]  [<ffffffff814917a9>] system_call_fastpath+0x16/0x1b
[  292.094530] Code: ff 65 48 8b 04 25 70 c8 00 00 83 a8 44 e0 ff ff 01 48 8b 80 38 e0 ff ff a8 08 75 17 5b 41 5c 5d c3 e8 bb e4 c1 ff 48 89 df 57 9d <66> 66 90 66 90 90 eb ce e8 79 e9 ff ff eb e2 0f 1f 80 00 00 00 


Or, this is spewed in the log:


[ 1934.719823] INFO: rcu_preempt self-detected stall on CPU { 1}  (t=18000 jiffies)
[ 1934.719830] sending NMI to all CPUs:
[ 1934.719830] NMI backtrace for cpu 1
[ 1934.719830] CPU 1 
[ 1934.719830] Pid: 0, comm: swapper/1 Tainted: G           O 3.4.0-wl #21 LENOVO 7661GN4/7661GN4
[ 1934.719830] RIP: 0010:[<ffffffff8125e302>]  [<ffffffff8125e302>] __const_udelay+0x12/0x40
[ 1934.719830] RSP: 0018:ffff88007d503600  EFLAGS: 00000006
[ 1934.719830] RAX: 0000000000000046 RBX: 0000000000002710 RCX: 000000000000f7f6
[ 1934.719830] RDX: 00000000005b54ce RSI: 0000000000000002 RDI: 0000000000418958
[ 1934.719830] RBP: ffff88007d503600 R08: 0000000000000002 R09: 0000000000000000
[ 1934.719830] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81a397c0
[ 1934.719830] R13: ffffffff81a39880 R14: ffff88007d50e7c0 R15: 000001c27649776b
[ 1934.719830] FS:  0000000000000000(0000) GS:ffff88007d500000(0000) knlGS:0000000000000000
[ 1934.719830] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1934.719830] CR2: 00007ffbf709408a CR3: 0000000001a0b000 CR4: 00000000000007e0
[ 1934.719830] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1934.719830] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1934.719830] Process swapper/1 (pid: 0, threadinfo ffff880079840000, task ffff880079832f10)
[ 1934.719830] Stack:
[ 1934.719830]  ffff88007d503620 ffffffff8103698a 0000000000000002 ffff88007d50ec80
[ 1934.719830]  ffff88007d503670 ffffffff810e0bf3 0000000000000001 ffff880079832f10
[ 1934.719830]  ffff88007d503690 0000000000000001 0000000000000001 0000000000000000
[ 1934.719830] Call Trace:
[ 1934.719830]  <IRQ> 
[ 1934.719830]  [<ffffffff8103698a>] arch_trigger_all_cpu_backtrace+0x6a/0x90
[ 1934.719830]  [<ffffffff810e0bf3>] __rcu_pending+0x193/0x4e0
[ 1934.719830]  [<ffffffff810e0fba>] rcu_pending+0x7a/0x90
[ 1934.719830]  [<ffffffff810e20c9>] rcu_check_callbacks+0xd9/0x220
[ 1934.719830]  [<ffffffff81062ad8>] update_process_times+0x48/0x90
[ 1934.719830]  [<ffffffff810a79e4>] tick_sched_timer+0x64/0xc0
[ 1934.719830]  [<ffffffff810799d7>] __run_hrtimer+0x77/0x270
[ 1934.719830]  [<ffffffff810a7980>] ? tick_nohz_handler+0x110/0x110
[ 1934.719830]  [<ffffffff8107a6f7>] hrtimer_interrupt+0xd7/0x1f0
[ 1934.719830]  [<ffffffff81493669>] smp_apic_timer_interrupt+0x69/0x99
[ 1934.719830]  [<ffffffff814922ef>] apic_timer_interrupt+0x6f/0x80
[ 1934.719830]  [<ffffffff810a9eaa>] ? lock_is_held+0xaa/0xd0
[ 1934.719830]  [<ffffffff8138e00c>] skb_dst_set_noref+0x4c/0x80
[ 1934.719830]  [<ffffffff813b826e>] ip_route_input_common+0xbce/0xf20
[ 1934.719830]  [<ffffffff813b76a0>] ? ip_route_output_flow+0x70/0x70
[ 1934.719830]  [<ffffffff813ba922>] ip_rcv_finish+0x3d2/0x570
[ 1934.719830]  [<ffffffff813bb254>] ip_rcv+0x214/0x2e0
[ 1934.719830]  [<ffffffff81384836>] __netif_receive_skb+0x5d6/0x690
[ 1934.719830]  [<ffffffff81384351>] ? __netif_receive_skb+0xf1/0x690
[ 1934.719830]  [<ffffffff8135aa07>] ? led_trigger_event+0x27/0x90
[ 1934.719830]  [<ffffffff81384f53>] netif_receive_skb+0x33/0x110
[ 1934.719830]  [<ffffffffa0405d92>] ? ieee80211_data_to_8023+0x182/0x440 [cfg80211]
[ 1934.719830]  [<ffffffffa05b5c53>] ieee80211_deliver_skb.isra.23+0xa3/0x200 [mac80211]
[ 1934.719830]  [<ffffffffa05b6b2b>] ieee80211_rx_handlers+0xd7b/0x2430 [mac80211]
[ 1934.719830]  [<ffffffff810aec2c>] ? trace_hardirqs_on_caller+0xac/0x190
[ 1934.719830]  [<ffffffff810aed1d>] ? trace_hardirqs_on+0xd/0x10
[ 1934.719830]  [<ffffffff81490867>] ? _raw_spin_unlock_irqrestore+0x77/0x80
[ 1934.719830]  [<ffffffffa05b8331>] ieee80211_prepare_and_rx_handle+0x151/0xa70 [mac80211]
[ 1934.719830]  [<ffffffffa05b8f8d>] ieee80211_rx+0x33d/0x8d0 [mac80211]
[ 1934.719830]  [<ffffffffa05b8cf6>] ? ieee80211_rx+0xa6/0x8d0 [mac80211]
[ 1934.719830]  [<ffffffff810aeafc>] ? mark_held_locks+0x8c/0x110
[ 1934.719830]  [<ffffffffa073e994>] ath_rx_tasklet+0xd24/0x1f10 [ath9k]
[ 1934.719830]  [<ffffffffa073b014>] ath9k_tasklet+0xe4/0x160 [ath9k]
[ 1934.719830]  [<ffffffff8105a073>] tasklet_action+0x83/0x110
[ 1934.719830]  [<ffffffff81059498>] __do_softirq+0xc8/0x240
[ 1934.719830]  [<ffffffff81492cec>] call_softirq+0x1c/0x30
[ 1934.719830]  [<ffffffff81016855>] do_softirq+0xa5/0xe0
[ 1934.719830]  [<ffffffff81059986>] irq_exit+0xa6/0xe0
[ 1934.719830]  [<ffffffff81493583>] do_IRQ+0x63/0xe0
[ 1934.719830]  [<ffffffff81490cef>] common_interrupt+0x6f/0x6f
[ 1934.719830]  <EOI> 
[ 1934.719830]  [<ffffffff8101ce63>] ? native_sched_clock+0x13/0x80
[ 1934.719830]  [<ffffffffa032d332>] ? acpi_idle_enter_bm+0x26b/0x2b2 [processor]
[ 1934.719830]  [<ffffffffa032d32e>] ? acpi_idle_enter_bm+0x267/0x2b2 [processor]
[ 1934.719830]  [<ffffffff8135848e>] cpuidle_enter+0x1e/0x20
[ 1934.719830]  [<ffffffff81358ad6>] cpuidle_idle_call+0xa6/0x340
[ 1934.719830]  [<ffffffff8101eee5>] cpu_idle+0xc5/0x140
[ 1934.719830]  [<ffffffff8147d376>] start_secondary+0x208/0x20f
[ 1934.719830] Code: 66 90 ff 15 39 6f 80 00 5d c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 66 66 66 66 90 65 48 8b 14 25 98 3c 01 00 <48> 8d 0c 92 48 8d 04 bd 00 00 00 00 48 89 ca 48 c1 e2 04 48 29 


I am trying to see which option in the 'kernel hacking' section causes this,
because using my distro's stock kernel doesn't have any trouble in
transmitting/receiving large amounts of data. (Probably CONFIG_DEBUG_ATOMIC_SLEEP).

> PS.  If anyone knows how to make minicom ignore page
> refreshes so that it doesn't obscure the last bit of
> the crash log when BIOS starts up again, please let me know!

There's a capture option in minicom.

Sujith
