Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out10.libero.it ([212.52.84.110]:40016 "EHLO
	cp-out10.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab1EBXEe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2011 19:04:34 -0400
Received: from pcfabio2.localnet (151.48.40.158) by cp-out10.libero.it (8.5.133) (authenticated as rossi.f@inwind.it)
        id 4DB12EF701B00585 for linux-wireless@vger.kernel.org; Tue, 3 May 2011 00:59:12 +0200
From: Fabio Rossi <rossi.f@inwind.it>
To: linux-wireless@vger.kernel.org
Subject: WARNING: at net/mac80211/wep.c:101 ieee80211_wep_add_iv+0x52/0x150 [mac80211]()
Date: Mon, 2 May 2011 22:57:11 +0200
MIME-Version: 1.0
Message-Id: <201105022257.11767.rossi.f@inwind.it> (sfid-20110503_010442_651315_E03E0ED0)
Content-Type: Text/Plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I get the following WARNING:

WARNING: at net/mac80211/wep.c:101 ieee80211_wep_add_iv+0x52/0x150 [mac80211]
()
Hardware name: System Product Name
Modules linked in: ath5k ath mac80211 cfg80211 vboxnetadp vboxnetflt vboxdrv 
fglrx(P) gspca_zc3xx gspca_main [last unloaded: cfg80211]
Pid: 0, comm: kworker/0:1 Tainted: P        W   2.6.39-rc5-wl #9
Call Trace:
 <IRQ>  [<ffffffff8103af1a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff8103af65>] warn_slowpath_null+0x15/0x20
 [<ffffffffa0566b52>] ieee80211_wep_add_iv+0x52/0x150 [mac80211]
 [<ffffffffa0567090>] ieee80211_crypto_wep_encrypt+0x60/0xc0 [mac80211]
 [<ffffffffa057fce5>] ieee80211_tx_h_encrypt+0x85/0x90 [mac80211]
 [<ffffffffa057fdc6>] invoke_tx_handlers+0xd6/0x150 [mac80211]
 [<ffffffffa05800db>] ieee80211_tx+0x5b/0xb0 [mac80211]
 [<ffffffffa05801cd>] ieee80211_xmit+0x9d/0x1c0 [mac80211]
 [<ffffffffa057def9>] ? ieee80211_skb_resize+0xa9/0x130 [mac80211]
 [<ffffffffa058112e>] ieee80211_subif_start_xmit+0x32e/0x700 [mac80211]
 [<ffffffff81473d0e>] dev_hard_start_xmit+0x31e/0x630
 [<ffffffff814e04fc>] ? iptable_mangle_hook+0x11c/0x140
 [<ffffffff8148b407>] sch_direct_xmit+0xe7/0x1b0
 [<ffffffff81474183>] dev_queue_xmit+0x163/0x5b0
 [<ffffffff814a6570>] ? ip_finish_output2+0x280/0x280
 [<ffffffff814a66a0>] ip_finish_output+0x130/0x310
 [<ffffffff814a6920>] ip_output+0xa0/0xb0
 [<ffffffff814a5a4e>] ? __ip_local_out+0x9e/0xa0
 [<ffffffff814a5a74>] ip_local_out+0x24/0x30
 [<ffffffff814a5eab>] ip_queue_xmit+0x15b/0x3b0
 [<ffffffff814bf059>] ? __tcp_v4_send_check+0x59/0xf0
 [<ffffffff814ba7f2>] tcp_transmit_skb+0x3c2/0x870
 [<ffffffff814bc8fa>] tcp_retransmit_skb+0x1ba/0x5d0
 [<ffffffff814be146>] tcp_retransmit_timer+0x276/0x620
 [<ffffffff814beb08>] tcp_write_timer+0x188/0x200
 [<ffffffff8104707b>] run_timer_softirq+0x11b/0x230
 [<ffffffff810478b1>] ? update_process_times+0x71/0x80
 [<ffffffff814be980>] ? tcp_delack_timer+0x210/0x210
 [<ffffffff810640e8>] ? tick_dev_program_event+0x48/0x110
 [<ffffffff81040d81>] __do_softirq+0x91/0x120
 [<ffffffff810599c5>] ? hrtimer_interrupt+0x155/0x240
 [<ffffffff815716cc>] call_softirq+0x1c/0x30
 [<ffffffff81003f3d>] do_softirq+0x4d/0x80
 [<ffffffff81040c26>] irq_exit+0x86/0xa0
 [<ffffffff8101bc3b>] smp_apic_timer_interrupt+0x6b/0xa0
 [<ffffffff81571193>] apic_timer_interrupt+0x13/0x20
 <EOI>  [<ffffffff8105af91>] ? notifier_call_chain+0x51/0x80
 [<ffffffff81283765>] ? intel_idle+0xb5/0x110
 [<ffffffff81283748>] ? intel_idle+0x98/0x110
 [<ffffffff813f74a2>] cpuidle_idle_call+0x82/0xf0
 [<ffffffff81001579>] cpu_idle+0x59/0xb0
 [<ffffffff81569f25>] start_secondary+0x181/0x185
---[ end trace be478a136930e9e5 ]---



Fabio
