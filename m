Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52030 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab0JGNQD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 09:16:03 -0400
Subject: Re: [PATCH 2/2] mac80211: use netif_receive_skb in
 ieee80211_tx_status callpath
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1277405253-23735-1-git-send-email-linville@tuxdriver.com>
References: <1277405253-23735-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 15:16:00 +0200
Message-ID: <1286457360.20974.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-06-24 at 14:47 -0400, John W. Linville wrote:
> This avoids the extra queueing from calling netif_rx.

John, can you please revert this? It's causing issues because we don't
necessarily have BHs disabled here with all drivers (see below).
Depending on the RCU implementation, it might disable BHs, but not all
of them do or need to.

Alternatively, we can require drivers to call ieee80211_tx_status() with
BHs disabled, but somebody would have to go through them...

johannes

[ 2503.163494] =================================
[ 2503.163523] [ INFO: inconsistent lock state ]
[ 2503.163539] 2.6.36-rc6-wl-47885-gfc72647-dirty #201
[ 2503.163555] ---------------------------------
[ 2503.163570] inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
[ 2503.163590] kworker/u:1/21 [HC0[0]:SC0[0]:HE1:SE1] takes:
[ 2503.163607]  (&(&list->lock)->rlock){+.?...}, at: [<c00000000058873c>] .packet_rcv+0x36c/0x46c
[ 2503.163650] {IN-SOFTIRQ-W} state was registered at:
[ 2503.163665]   [<c0000000000b005c>] .mark_irqflags+0xa8/0x1cc
[ 2503.163691]   [<c0000000000b458c>] .__lock_acquire+0x69c/0x8b8
[ 2503.163714]   [<c0000000000b48cc>] .lock_acquire+0x124/0x174
[ 2503.163736]   [<c00000000059765c>] ._raw_spin_lock+0x54/0xb8
[ 2503.163758]   [<c00000000058873c>] .packet_rcv+0x36c/0x46c
[ 2503.163780]   [<c0000000004e2cd0>] .__netif_receive_skb+0x47c/0x548
[ 2503.163805]   [<c0000000004e46b4>] .netif_receive_skb+0x10c/0x138
[ 2503.163827]   [<c0000000004e4cc8>] .napi_skb_finish+0x4c/0x80
[ 2503.163851]   [<c0000000004e5744>] .napi_gro_receive+0x48/0x64
[ 2503.163873]   [<c000000000488f50>] .tg3_rx+0x588/0x7e8
[ 2503.163895]   [<c000000000489248>] .tg3_poll_work+0x98/0x1cc
[ 2503.163917]   [<c000000000489458>] .tg3_poll+0xdc/0x294
[ 2503.163938]   [<c0000000004e4ab4>] .net_rx_action+0x114/0x2dc
[ 2503.163960]   [<c000000000073720>] .__do_softirq+0x16c/0x2c0
[ 2503.163982]   [<c000000000025dbc>] .call_do_softirq+0x14/0x24
[ 2503.164006]   [<c00000000000d780>] .do_softirq+0xa0/0x104
[ 2503.164028]   [<c000000000073048>] .irq_exit+0x70/0xd0
[ 2503.164048]   [<c00000000000dd6c>] .do_IRQ+0x214/0x2a8
[ 2503.164069]   [<c000000000004714>] hardware_interrupt_entry+0x1c/0x20
[ 2503.164092]   [<c0000000000147f8>] .cpu_idle+0xe0/0x1fc
[ 2503.164112]   [<c00000000059dfd4>] .start_secondary+0x360/0x39c
[ 2503.164135]   [<c0000000000072dc>] .start_secondary_prolog+0x10/0x14
[ 2503.164159] irq event stamp: 312367
[ 2503.164173] hardirqs last  enabled at (312367): [<c0000000000734b4>] .local_bh_enable+0xe8/0x110
[ 2503.164203] hardirqs last disabled at (312365): [<c000000000073448>] .local_bh_enable+0x7c/0x110
[ 2503.164233] softirqs last  enabled at (312366): [<c000000000588534>] .packet_rcv+0x164/0x46c
[ 2503.164262] softirqs last disabled at (312364): [<c0000000005884cc>] .packet_rcv+0xfc/0x46c
[ 2503.164291] 
[ 2503.164293] other info that might help us debug this:
[ 2503.164314] 4 locks held by kworker/u:1/21:
[ 2503.164327]  #0:  ((wiphy_name(local->hw.wiphy))){+.+.+.}, at: [<c00000000008f6ac>] .process_one_work+0x2d0/0x5dc
[ 2503.164371]  #1:  ((&(&sc->tx_complete_work)->work)){+.+...}, at: [<c00000000008f6ac>] .process_one_work+0x2d0/0x5dc
[ 2503.164412]  #2:  (rcu_read_lock){.+.+..}, at: [<d00000000190e5d0>] .ieee80211_tx_status+0x7a0/0x930 [mac80211]
[ 2503.164505]  #3:  (rcu_read_lock){.+.+..}, at: [<c0000000004e2a54>] .__netif_receive_skb+0x200/0x548
[ 2503.164543] 
[ 2503.164545] stack backtrace:
[ 2503.164561] Call Trace:
[ 2503.164574] [c000000216282df0] [c000000000011ef4] .show_stack+0xc0/0x200 (unreliable)
[ 2503.164606] [c000000216282ec0] [c000000000598c08] .dump_stack+0x28/0x3c
[ 2503.164633] [c000000216282f40] [c0000000000af7c8] .print_usage_bug+0x1c8/0x200
[ 2503.164660] [c000000216283000] [c0000000000af900] .mark_lock_irq+0x100/0x330
[ 2503.164688] [c0000002162830c0] [c0000000000afe00] .mark_lock+0x2d0/0x484
[ 2503.164714] [c000000216283160] [c0000000000b00e4] .mark_irqflags+0x130/0x1cc
[ 2503.164740] [c0000002162831f0] [c0000000000b458c] .__lock_acquire+0x69c/0x8b8
[ 2503.164767] [c0000002162832f0] [c0000000000b48cc] .lock_acquire+0x124/0x174
[ 2503.164793] [c0000002162833d0] [c00000000059765c] ._raw_spin_lock+0x54/0xb8
[ 2503.164818] [c000000216283470] [c00000000058873c] .packet_rcv+0x36c/0x46c
[ 2503.164844] [c000000216283540] [c0000000004e2d2c] .__netif_receive_skb+0x4d8/0x548
[ 2503.164873] [c000000216283620] [c0000000004e46b4] .netif_receive_skb+0x10c/0x138
[ 2503.164925] [c0000002162836e0] [d00000000190e6dc] .ieee80211_tx_status+0x8ac/0x930 [mac80211]
[ 2503.164970] [c000000216283800] [d000000001af9f38] .ath_tx_complete+0x154/0x184 [ath9k]
[ 2503.165010] [c0000002162838b0] [d000000001afa0ac] .ath_tx_complete_buf+0x144/0x1e0 [ath9k]
[ 2503.165051] [c000000216283970] [d000000001afbf6c] .ath_draintxq+0x2f4/0x50c [ath9k]
[ 2503.165092] [c000000216283a90] [d000000001afdc10] .ath_drain_all_txq+0x138/0x17c [ath9k]
[ 2503.165131] [c000000216283b50] [d000000001af566c] .ath_reset+0x88/0x1f0 [ath9k]
[ 2503.165171] [c000000216283c20] [d000000001afaa20] .ath_tx_complete_poll_work+0xbc/0x144 [ath9k]
[ 2503.165201] [c000000216283ce0] [c00000000008f784] .process_one_work+0x3a8/0x5dc
[ 2503.165229] [c000000216283dd0] [c00000000008fe74] .worker_thread+0x228/0x444


