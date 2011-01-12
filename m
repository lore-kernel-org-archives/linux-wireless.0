Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50302 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab1ALFLU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 00:11:20 -0500
Date: Tue, 11 Jan 2011 23:11:44 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC/RFT] mac80211: Fix mixed usage of spin_lock and
 spin_lock_irqsave on same lock
Message-ID: <4d2d3810.F6Slpvbu6tV67Lp2%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My system has logged the following locking problem:

==================================================================
 [ INFO: inconsistent lock state ]
 2.6.37-Linus-03737-g0c21e3a-dirty #251
 ---------------------------------
 inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
 takes:
  (&(&list->lock)->rlock#5){?.-...}, at: skb_queue_tail+0x26/0x60
 {HARDIRQ-ON-W} state was registered at:
 __lock_acquire+0xb25/0x1cc0
 lock_acquire+0x93/0x130
 _raw_spin_lock+0x2c/0x40
 ieee80211_rx_handlers+0x27/0x1c80 [mac80211]
 ieee80211_prepare_and_rx_handle+0x238/0x900 [mac80211]
 ieee80211_rx+0x31a/0x940 [mac80211]
 ieee80211_tasklet_handler+0xc1/0xd0 [mac80211]
 tasklet_action+0x73/0x120
 __do_softirq+0xce/0x200

==================================================================

The reason is that ieee80211_rx_handlers() locks rx->local->rx_skb_queue.lock
using spin_lock(), but skb_queue_tail() locks the same entity with
spin_lock_irqsave().

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Johannes,

I think this is correct. At least the lockdep warning goes away on my
machine.

Larry
---

Index: linux-2.6/net/mac80211/rx.c
===================================================================
--- linux-2.6.orig/net/mac80211/rx.c
+++ linux-2.6/net/mac80211/rx.c
@@ -2465,6 +2465,7 @@ static void ieee80211_rx_handlers(struct
 {
 	ieee80211_rx_result res = RX_DROP_MONITOR;
 	struct sk_buff *skb;
+	unsigned long flags;
 
 #define CALL_RXH(rxh)			\
 	do {				\
@@ -2473,14 +2474,14 @@ static void ieee80211_rx_handlers(struct
 			goto rxh_next;  \
 	} while (0);
 
-	spin_lock(&rx->local->rx_skb_queue.lock);
+	spin_lock_irqsave(&rx->local->rx_skb_queue.lock, flags);
 	if (rx->local->running_rx_handler)
 		goto unlock;
 
 	rx->local->running_rx_handler = true;
 
 	while ((skb = __skb_dequeue(&rx->local->rx_skb_queue))) {
-		spin_unlock(&rx->local->rx_skb_queue.lock);
+		spin_unlock_irqrestore(&rx->local->rx_skb_queue.lock, flags);
 
 		/*
 		 * all the other fields are valid across frames
@@ -2513,14 +2514,14 @@ static void ieee80211_rx_handlers(struct
 
  rxh_next:
 		ieee80211_rx_handlers_result(rx, res);
-		spin_lock(&rx->local->rx_skb_queue.lock);
+		spin_lock_irqsave(&rx->local->rx_skb_queue.lock, flags);
 #undef CALL_RXH
 	}
 
 	rx->local->running_rx_handler = false;
 
  unlock:
-	spin_unlock(&rx->local->rx_skb_queue.lock);
+	spin_unlock_irqrestore(&rx->local->rx_skb_queue.lock, flags);
 }
 
 static void ieee80211_invoke_rx_handlers(struct ieee80211_rx_data *rx)
