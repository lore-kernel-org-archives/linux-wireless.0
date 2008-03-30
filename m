Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:33621 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139AbYC3U1A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Mar 2008 16:27:00 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Jg47D-0000Fe-AP
	for linux-wireless@vger.kernel.org; Sun, 30 Mar 2008 20:26:55 +0000
Received: from pro75-5-88-162-203-35.fbx.proxad.net ([88.162.203.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 30 Mar 2008 20:26:55 +0000
Received: from tobutaz+kernel by pro75-5-88-162-203-35.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 30 Mar 2008 20:26:55 +0000
To: linux-wireless@vger.kernel.org
From: TK <tobutaz+kernel@gmail.com>
Subject: Re: 2.6.24 panic in rt2x00lib_txdone / ieee80211_tx_status_irqsafe
Date: Sun, 30 Mar 2008 20:26:44 +0000 (UTC)
Message-ID: <fsot23$biu$1@ger.gmane.org> (sfid-20080330_212706_510241_2C4E4441)
References: <fsjfq1$vl8$1@ger.gmane.org>
	<200803282034.56042.IvDoorn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 28 Mar 2008 20:34:55 +0100, Ivo van Doorn said:

> Hi,
> 
> Could you try rt2x00 2.0.14 (2.6.25-rc*) or a wireless-testing kernel to
> see if the problems persist?
> The wireless-testing would be the most interesting since several race
> conditions in the queues where fixed in there.

I've had no luck with either:
rt2x00 2.0.14 - 93d2334f3773c0d4e8dfafdb394f73bb1bdf0cc9
or a recent wireless-testing - 78f8e644105878c3e13ca281529c3c9e661bf59f

The first one does not manage to associate,
[ 1335.437438] wlan0: authenticate with AP ea:2c:38:1b:3b:6c
[ 1335.439767] wlan0: RX authentication from ea:2c:38:1b:3b:6c (alg=0 transaction=2 status=0)
[ 1335.439879] wlan0: authenticated
[ 1335.439947] wlan0: associate with AP ea:2c:38:1b:3b:6c
[ 1335.631087] wlan0: associate with AP ea:2c:38:1b:3b:6c
[ 1335.830689] wlan0: associate with AP ea:2c:38:1b:3b:6c
[ 1336.030006] wlan0: association with AP ea:2c:38:1b:3b:6c timed out

And the second deadlocks,
[  557.872813] ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LNKD] -> GSI 10 (level, low) -> IRQ 10
[  557.893592] phy0: Selected rate control algorithm 'pid'
[  622.770360] BUG: soft lockup - CPU#0 stuck for 61s! [rt61pci:6275]
[  622.770360] 
[  622.770360] Pid: 6275, comm: rt61pci Not tainted (2.6.25-rc7-wl #2)
[  622.770360] EIP: 0060:[<c013c623>] EFLAGS: 00000283 CPU: 0
[  622.770360] EIP is at run_workqueue+0xa3/0x150
[  622.770360] EAX: c99fde04 EBX: c6ecd220 ECX: c6ecd224 EDX: c99fde04
[  622.770360] ESI: c99fde00 EDI: d0d3f040 EBP: c99fde00 ESP: c6f55f88
[  622.770360]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  622.770360] CR0: 8005003b CR2: bfa98e5e CR3: 098ef000 CR4: 000002b0
[  622.770360] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  622.770360] DR6: ffff0ff0 DR7: 00000400
[  622.770360]  [<c013cee0>] ? worker_thread+0x0/0xe0
[  622.770360]  [<c013cf60>] ? worker_thread+0x80/0xe0
[  622.770360]  [<c013fa70>] ? autoremove_wake_function+0x0/0x40
[  622.770360]  [<c013cee0>] ? worker_thread+0x0/0xe0
[  622.770360]  [<c013f782>] ? kthread+0x42/0x70
[  622.770360]  [<c013f740>] ? kthread+0x0/0x70
[  622.770360]  [<c0109a93>] ? kernel_thread_helper+0x7/0x10
[  622.770360]  =======================
[  688.270361] BUG: soft lockup - CPU#0 stuck for 61s! [rt61pci:6275]
[  688.270361] 
[  688.270361] Pid: 6275, comm: rt61pci Not tainted (2.6.25-rc7-wl #2)
[  688.270361] EIP: 0060:[<c032c637>] EFLAGS: 00000296 CPU: 0
[  688.270361] EIP is at _spin_unlock_irqrestore+0x7/0x10
[  688.270361] EAX: 00000296 EBX: c6ecd220 ECX: 00000001 EDX: 00000296
[  688.270361] ESI: c99fde00 EDI: d0d3f040 EBP: c99fde00 ESP: c6f55f68
[  688.270361]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  688.270361] CR0: 8005003b CR2: bfa98e5e CR3: 098ef000 CR4: 000002b0
[  688.270361] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  688.270361] DR6: ffff0ff0 DR7: 00000400
[  688.270361]  [<c013cb83>] ? queue_work+0x33/0x40
[  688.270361]  [<d0d3f07c>] ? rt2x00lib_packetfilter_scheduled+0x3c/0x50 [rt2x00lib]
[  688.270361]  [<c013c638>] ? run_workqueue+0xb8/0x150
[  688.270361]  [<c013cee0>] ? worker_thread+0x0/0xe0
[  688.270361]  [<c013cf60>] ? worker_thread+0x80/0xe0
[  688.270361]  [<c013fa70>] ? autoremove_wake_function+0x0/0x40
[  688.270361]  [<c013cee0>] ? worker_thread+0x0/0xe0
[  688.270361]  [<c013f782>] ? kthread+0x42/0x70
[  688.270361]  [<c013f740>] ? kthread+0x0/0x70
[  688.270361]  [<c0109a93>] ? kernel_thread_helper+0x7/0x10
[  688.270361]  =======================
[  709.331164] rt61pci: page allocation failure. order:0, mode:0x20
[  709.331214] rt61pci: page allocation failure. order:0, mode:0x20
[  709.331225] Pid: 6275, comm: rt61pci Not tainted 2.6.25-rc7-wl #2
[  709.331288]  [<c01729cd>] __alloc_pages+0x31d/0x370
[  709.331344]  [<c02c6416>] __ip_route_output_key+0x466/0x930
[  709.331381]  [<c0191e68>] __slab_alloc+0x138/0x4f0
[  709.331425]  [<c01924fd>] kmem_cache_alloc+0xad/0xc0
[  709.331434]  [<c02a3066>] __alloc_skb+0x36/0x120
[  709.331472]  [<c02a3066>] __alloc_skb+0x36/0x120
[  709.331497]  [<c02b597c>] find_skb+0x3c/0x80
[  709.331529]  [<c02b636d>] netpoll_send_udp+0x2d/0x260
[  709.331537]  [<c032ed47>] atomic_notifier_call_chain+0x17/0x20
[  709.331593]  [<d0a6e15f>] write_msg+0x8f/0xd0 [netconsole]
[  709.331632]  [<d0a6e0d0>] write_msg+0x0/0xd0 [netconsole]
[  709.331650]  [<c012c643>] __call_console_drivers+0x53/0x60
[  709.331685]  [<c012cae8>] release_console_sem+0xd8/0x1e0
[  709.331714]  [<c012cf77>] vprintk+0x1e7/0x370
[  709.331813]  [<c012d11b>] printk+0x1b/0x20
[  709.331831]  [<c01729c8>] __alloc_pages+0x318/0x370
[  709.331888]  [<c0191e68>] __slab_alloc+0x138/0x4f0
[  709.331929]  [<c01924fd>] kmem_cache_alloc+0xad/0xc0
[  709.331937]  [<c02a3066>] __alloc_skb+0x36/0x120
[  709.331966]  [<c02a3066>] __alloc_skb+0x36/0x120
[  709.331991]  [<c02a3dc2>] __netdev_alloc_skb+0x22/0x50
[  709.332014]  [<d092159e>] rtl8169_rx_interrupt+0x1ce/0x580 [r8169]
[  709.332091]  [<d0922097>] rtl8169_interrupt+0x317/0x3f0 [r8169]
[  709.332115]  [<d09f69b5>] ata_interrupt+0xc5/0x1d0 [libata]
[  709.332267]  [<c01675d0>] handle_IRQ_event+0x30/0x60
[  709.332291]  [<c0168e78>] handle_level_irq+0x78/0xf0
[  709.332315]  [<c010b4ab>] do_IRQ+0x3b/0x70
[  709.332344]  [<d0d3f040>] rt2x00lib_packetfilter_scheduled+0x0/0x50 [rt2x00lib]
[  709.332375]  [<c0109887>] common_interrupt+0x23/0x28

Which does not help with the problem I wanted to solve in the first place;
sorry.


