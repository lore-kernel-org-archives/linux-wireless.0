Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43965 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab1ALJBh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 04:01:37 -0500
Subject: Re: [RFC/RFT] mac80211: Fix mixed usage of spin_lock and
 spin_lock_irqsave on same lock
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4d2d3810.F6Slpvbu6tV67Lp2%Larry.Finger@lwfinger.net>
References: <4d2d3810.F6Slpvbu6tV67Lp2%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 10:02:13 +0100
Message-ID: <1294822933.3639.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-11 at 23:11 -0600, Larry Finger wrote:
> My system has logged the following locking problem:
> 
> ==================================================================
>  [ INFO: inconsistent lock state ]
>  2.6.37-Linus-03737-g0c21e3a-dirty #251
>  ---------------------------------
>  inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
>  takes:
>   (&(&list->lock)->rlock#5){?.-...}, at: skb_queue_tail+0x26/0x60
>  {HARDIRQ-ON-W} state was registered at:
>  __lock_acquire+0xb25/0x1cc0
>  lock_acquire+0x93/0x130
>  _raw_spin_lock+0x2c/0x40
>  ieee80211_rx_handlers+0x27/0x1c80 [mac80211]
>  ieee80211_prepare_and_rx_handle+0x238/0x900 [mac80211]
>  ieee80211_rx+0x31a/0x940 [mac80211]
>  ieee80211_tasklet_handler+0xc1/0xd0 [mac80211]
>  tasklet_action+0x73/0x120
>  __do_softirq+0xce/0x200
> 
> ==================================================================
> 
> The reason is that ieee80211_rx_handlers() locks rx->local->rx_skb_queue.lock
> using spin_lock(), but skb_queue_tail() locks the same entity with
> spin_lock_irqsave().
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> Johannes,
> 
> I think this is correct. At least the lockdep warning goes away on my
> machine.

I have to apologize -- I've sorta pushed off looking at this (my excuse
is some important iwlwifi bugs, but ...).

If I look at your original trace again, I see:

[   25.660384] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.

This is a tad confusing, because it then goes to print out something
about ieee80211_rx_handlers(), which only acquires the
local->rx_skb_queue.lock; looking further, however, the current stack
trace is ieee80211_tx_status_irqsafe() which uses only
local->skb_queue[_unreliable]. I think Stanislaw was right on (but why
didn't he offer a fix? :-) ).

While your fix certainly isn't incorrect, I believe it to be unnecessary
to disable IRQs here. The lock can only be taken with BHs disabled, but
this is in a BH or running with BHs disabled. Of course, the invocations
of skb_queue_tail() will still do IRQ locking, but I'm willing to pay
that price, for now, until somebody invents skb_queue_tail_bh() :-)

I believe the patch below should address the lockdep warning without the
IRQ disabling.

johannes

--- wireless-testing.orig/net/mac80211/main.c	2011-01-12 09:58:07.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2011-01-12 10:02:03.000000000 +0100
@@ -39,6 +39,8 @@ module_param(ieee80211_disable_40mhz_24g
 MODULE_PARM_DESC(ieee80211_disable_40mhz_24ghz,
 		 "Disable 40MHz support in the 2.4GHz band");
 
+static struct lock_class_key ieee80211_rx_skb_queue_class;
+
 void ieee80211_configure_filter(struct ieee80211_local *local)
 {
 	u64 mc;
@@ -569,7 +571,15 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	spin_lock_init(&local->filter_lock);
 	spin_lock_init(&local->queue_stop_reason_lock);
 
-	skb_queue_head_init(&local->rx_skb_queue);
+	/*
+	 * The rx_skb_queue is only accessed from tasklets,
+	 * but other SKB queues are used from within IRQ
+	 * context. Therefore, this one needs a different
+	 * locking class so our direct, non-irq-safe use of
+	 * the queue's lock doesn't throw lockdep warnings.
+	 */
+	skb_queue_head_init_class(&local->rx_skb_queue,
+				  &ieee80211_rx_skb_queue_class);
 
 	INIT_DELAYED_WORK(&local->scan_work, ieee80211_scan_work);
 


