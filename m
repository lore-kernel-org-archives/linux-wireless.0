Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37335 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbZHXJqi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 05:46:38 -0400
Subject: [PATCH] mac80211: fix RX skb leaks
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 24 Aug 2009 11:46:30 +0200
Message-Id: <1251107190.12007.9.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In mac80211's RX path some of the warnings that
warn about drivers passing invalid status values
leak the skb, fix that by refactoring the code.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/rx.c |   34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

--- wireless-testing.orig/net/mac80211/rx.c	2009-08-24 11:42:11.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2009-08-24 11:43:32.000000000 +0200
@@ -2447,17 +2447,13 @@ void ieee80211_rx(struct ieee80211_hw *h
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 
-	if (status->band < 0 ||
-	    status->band >= IEEE80211_NUM_BANDS) {
-		WARN_ON(1);
-		return;
-	}
+	if (WARN_ON(status->band < 0 ||
+		    status->band >= IEEE80211_NUM_BANDS))
+		goto drop;
 
 	sband = local->hw.wiphy->bands[status->band];
-	if (!sband) {
-		WARN_ON(1);
-		return;
-	}
+	if (WARN_ON(!sband))
+		goto drop;
 
 	/*
 	 * If we're suspending, it is possible although not too likely
@@ -2466,25 +2462,21 @@ void ieee80211_rx(struct ieee80211_hw *h
 	 * that might, for example, cause stations to be added or other
 	 * driver callbacks be invoked.
 	 */
-	if (unlikely(local->quiescing || local->suspended)) {
-		kfree_skb(skb);
-		return;
-	}
+	if (unlikely(local->quiescing || local->suspended))
+		goto drop;
 
 	/*
 	 * The same happens when we're not even started,
 	 * but that's worth a warning.
 	 */
-	if (WARN_ON(!local->started)) {
-		kfree_skb(skb);
-		return;
-	}
+	if (WARN_ON(!local->started))
+		goto drop;
 
 	if (status->flag & RX_FLAG_HT) {
 		/* rate_idx is MCS index */
 		if (WARN_ON(status->rate_idx < 0 ||
 			    status->rate_idx >= 76))
-			return;
+			goto drop;
 		/* HT rates are not in the table - use the highest legacy rate
 		 * for now since other parts of mac80211 may not yet be fully
 		 * MCS aware. */
@@ -2492,7 +2484,7 @@ void ieee80211_rx(struct ieee80211_hw *h
 	} else {
 		if (WARN_ON(status->rate_idx < 0 ||
 			    status->rate_idx >= sband->n_bitrates))
-			return;
+			goto drop;
 		rate = &sband->bitrates[status->rate_idx];
 	}
 
@@ -2531,6 +2523,10 @@ void ieee80211_rx(struct ieee80211_hw *h
 		__ieee80211_rx_handle_packet(hw, skb, rate);
 
 	rcu_read_unlock();
+
+	return;
+ drop:
+	kfree_skb(skb);
 }
 EXPORT_SYMBOL(ieee80211_rx);
 


