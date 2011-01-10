Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193Ab1AJQHN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 11:07:13 -0500
Date: Mon, 10 Jan 2011 17:06:14 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Locking problem reported for mainline
Message-ID: <20110110160613.GB2346@redhat.com>
References: <4D2A9309.7000500@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4D2A9309.7000500@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 09, 2011 at 11:03:05PM -0600, Larry Finger wrote:
> I have updated my "Linus" tree to the latest state as of Jan. 9, 2011. Uname -r
> reports
> 
> 2.6.37-Linus-03737-g0c21e3a-dirty
> 
> The logged messages are listed below.

I think this is a false positive, because for lockdep
local->rx_skb_queue->lock and local->skb_queue->lock
is the same lock (struct sk_buff_head->lock). Hence warn when we do
not spin_lock_irq in ieee80211_rx_handlers(), but take lock
from interrupt handler in ieee80211_tx_status_irqsafe()-> skb_queue_tail()

Stanislaw

> =======================================================================
> 
> [   25.660371] =================================
> [   25.660376] [ INFO: inconsistent lock state ]
> [   25.660379] 2.6.37-Linus-03737-g0c21e3a-dirty #251
> [   25.660382] ---------------------------------
> [   25.660384] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
> [   25.660388] kworker/0:0/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
> [   25.660390]  (&(&list->lock)->rlock#5){?.-...}, at: [<ffffffff812a2746>]
> skb_queue_tail+0x26/0x60
> [   25.660401] {HARDIRQ-ON-W} state was registered at:
> [   25.660403]   [<ffffffff8107f305>] __lock_acquire+0xb25/0x1cc0
> [   25.660409]   [<ffffffff81080a73>] lock_acquire+0x93/0x130
> [   25.660413]   [<ffffffff813446cc>] _raw_spin_lock+0x2c/0x40
> [   25.660418]   [<ffffffffa02b3777>] ieee80211_rx_handlers+0x27/0x1c80 [mac80211]
> [   25.660444]   [<ffffffffa02b5608>]
> ieee80211_prepare_and_rx_handle+0x238/0x900 [mac80211]
> [   25.660455]   [<ffffffffa02b5fea>] ieee80211_rx+0x31a/0x940 [mac80211]
> [   25.660465]   [<ffffffffa029cd51>] ieee80211_tasklet_handler+0xc1/0xd0 [mac80211]
> [   25.660474]   [<ffffffff8104f993>] tasklet_action+0x73/0x120
> [   25.660479]   [<ffffffff8105048e>] __do_softirq+0xce/0x200
> [   25.660483]   [<ffffffff81003ccc>] call_softirq+0x1c/0x30
> [   25.660488]   [<ffffffff81005e25>] do_softirq+0x85/0xc0
> [   25.660492]   [<ffffffff810506cd>] irq_exit+0x8d/0xa0
> [   25.660496]   [<ffffffff81005971>] do_IRQ+0x61/0xe0
> [   25.660500]   [<ffffffff813452d3>] ret_from_intr+0x0/0xf
> [   25.660504]   [<ffffffff81179cd7>] sysfs_permission+0x47/0x80
> [   25.660510]   [<ffffffff81126bfa>] link_path_walk+0x1ea/0xdb0
> [   25.660515]   [<ffffffff81127568>] link_path_walk+0xb58/0xdb0
> [   25.660519]   [<ffffffff81127ab6>] do_path_lookup+0x56/0x130
> [   25.660523]   [<ffffffff81127f92>] user_path_at+0x52/0xa0
> [   25.660526]   [<ffffffff8111e634>] vfs_fstatat+0x34/0x70
> [   25.660532]   [<ffffffff8111e6a6>] vfs_stat+0x16/0x20
> [   25.660536]   [<ffffffff8111ea4f>] sys_newstat+0x1f/0x40
> [   25.660540]   [<ffffffff81002d7b>] system_call_fastpath+0x16/0x1b
> [   25.660546] irq event stamp: 393974
> [   25.660548] hardirqs last  enabled at (393971): [<ffffffff8100c03a>]
> default_idle+0x5a/0xf0
> [   25.660553] hardirqs last disabled at (393972): [<ffffffff81345227>]
> save_args+0x67/0x70
> [   25.660557] softirqs last  enabled at (393974): [<ffffffff810501de>]
> _local_bh_enable+0xe/0x10
> [   25.660562] softirqs last disabled at (393973): [<ffffffff8105062d>]
> irq_enter+0x6d/0x80
> [   25.660566]
> [   25.660567] other info that might help us debug this:
> [   25.660570] 1 lock held by kworker/0:0/0:
> [   25.660572]  #0:  (&(&rtlpriv->locks.irq_th_lock)->rlock){-.-...}, at:
> [<ffffffffa02f0daf>] _rtl_pci_interrupt+0x5f/0x890 [rtlwifi]
> [   25.660585]
> [   25.660586] stack backtrace:
> [   25.660589] Pid: 0, comm: kworker/0:0 Tainted: G        W
> 2.6.37-Linus-03737-g0c21e3a-dirty #251
> [   25.660592] Call Trace:
> [   25.660594]  <IRQ>  [<ffffffff8107e152>] ? print_usage_bug+0x182/0x1d0
> [   25.660601]  [<ffffffff8107e571>] ? mark_lock+0x3d1/0x640
> [   25.660605]  [<ffffffff8107f3bd>] ? __lock_acquire+0xbdd/0x1cc0
> [   25.660610]  [<ffffffff811d2aae>] ? check_unmap+0x3be/0x7e0
> [   25.660615]  [<ffffffff8107bc2d>] ? trace_hardirqs_off+0xd/0x10
> [   25.660619]  [<ffffffff81080a73>] ? lock_acquire+0x93/0x130
> [   25.660622]  [<ffffffff812a2746>] ? skb_queue_tail+0x26/0x60
> [   25.660627]  [<ffffffff810af978>] ? rcu_start_gp+0x258/0x350
> [   25.660630]  [<ffffffff813447cc>] ? _raw_spin_lock_irqsave+0x3c/0x60
> [   25.660634]  [<ffffffff812a2746>] ? skb_queue_tail+0x26/0x60
> [   25.660637]  [<ffffffff812a2746>] ? skb_queue_tail+0x26/0x60
> [   25.660647]  [<ffffffffa029e166>] ? ieee80211_tx_status_irqsafe+0x36/0xb0
> [mac80211]
> [   25.660653]  [<ffffffffa02f0b90>] ? _rtl_pci_tx_isr+0x180/0x340 [rtlwifi]
> [   25.660659]  [<ffffffffa02f0e75>] ? _rtl_pci_interrupt+0x125/0x890 [rtlwifi]
> [   25.660665]  [<ffffffff810ab299>] ? handle_IRQ_event+0x49/0x170
> [   25.660670]  [<ffffffff810ada52>] ? handle_fasteoi_irq+0x92/0x110
> [   25.660674]  [<ffffffff81005d44>] ? handle_irq+0x44/0xa0
> [   25.660677]  [<ffffffff81005968>] ? do_IRQ+0x58/0xe0
> [   25.660681]  [<ffffffff813452d3>] ? ret_from_intr+0x0/0xf
> [   25.660683]  <EOI>  [<ffffffff8100c03c>] ? default_idle+0x5c/0xf0
> [   25.660690]  [<ffffffff8100c03a>] ? default_idle+0x5a/0xf0
> [   25.660694]  [<ffffffff8100c124>] ? c1e_idle+0x54/0x100
> [   25.660698]  [<ffffffff810011eb>] ? cpu_idle+0x5b/0x120
> [   25.660703]  [<ffffffff8133dd72>] ? start_secondary+0x190/0x194
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
