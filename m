Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f66.google.com ([209.85.161.66]:55127 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab1AJSNg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 13:13:36 -0500
Received: by fxm14 with SMTP id 14so5822402fxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jan 2011 10:13:35 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Locking problem reported for mainline
Date: Mon, 10 Jan 2011 19:13:17 +0100
Cc: wireless <linux-wireless@vger.kernel.org>
References: <4D2A9309.7000500@lwfinger.net>
In-Reply-To: <4D2A9309.7000500@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101101913.17311.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 10 January 2011 06:03:05 Larry Finger wrote:
> I have updated my "Linus" tree to the latest state as of Jan. 9, 2011.
> Uname -r reports
> 
> 2.6.37-Linus-03737-g0c21e3a-dirty
> 
> The logged messages are listed below.
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
Does this patch help?

---
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index a6701ed..8f13a83 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -549,7 +549,9 @@ static void ieee80211_release_reorder_frame(struct ieee80211_hw *hw,
 	tid_agg_rx->reorder_buf[index] = NULL;
 	status = IEEE80211_SKB_RXCB(skb);
 	status->rx_flags |= IEEE80211_RX_DEFERRED_RELEASE;
-	skb_queue_tail(&local->rx_skb_queue, skb);
+	spin_lock(&rx->local->rx_skb_queue.lock);
+	__skb_queue_tail(&local->rx_skb_queue, skb);
+	spin_unlock(&rx->local->rx_skb_queue.lock);
 
 no_frame:
 	tid_agg_rx->head_seq_num = seq_inc(tid_agg_rx->head_seq_num);
@@ -780,7 +782,9 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
 		return;
 
  dont_reorder:
-	skb_queue_tail(&local->rx_skb_queue, skb);
+	spin_lock(&rx->local->rx_skb_queue.lock);
+	__skb_queue_tail(&local->rx_skb_queue, skb);
+	spin_unlock(&rx->local->rx_skb_queue.lock);
 }
 
 static ieee80211_rx_result debug_noinline


