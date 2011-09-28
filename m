Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39196 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab1I1MNB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 08:13:01 -0400
Message-Id: <20110928121129.222176759@sipsolutions.net> (sfid-20110928_141305_344220_9364C3E0)
Date: Wed, 28 Sep 2011 14:08:52 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 03/15] mac80211: also expire filtered frames
References: <20110928120849.882884360@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

mac80211 will expire normal PS-buffered frames, but
if the device rejected some frames for a sleeping
station, these won't be on the ps_tx_buf queue but
on the tx_filtered queue instead; this is done to
avoid reordering.

However, mac80211 will not expire frames from the
filtered queue, let's fix that.

Also add a more comments to what all this expiry is
doing and how it works.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c |   57 +++++++++++++++++++++++++++++++++++++++++++-----
 net/mac80211/status.c   |    5 ++++
 2 files changed, 57 insertions(+), 5 deletions(-)

--- a/net/mac80211/sta_info.c	2011-09-28 13:18:29.000000000 +0200
+++ b/net/mac80211/sta_info.c	2011-09-28 13:18:30.000000000 +0200
@@ -698,6 +698,39 @@ static bool sta_info_cleanup_expire_buff
 	unsigned long flags;
 	struct sk_buff *skb;
 
+	/*
+	 * First check for frames that should expire on the filtered
+	 * queue. Frames here were rejected by the driver and are on
+	 * a separate queue to avoid reordering with normal PS-buffered
+	 * frames. They also aren't accounted for right now in the
+	 * total_ps_buffered counter.
+	 */
+	for (;;) {
+		spin_lock_irqsave(&sta->tx_filtered.lock, flags);
+		skb = skb_peek(&sta->tx_filtered);
+		if (sta_info_buffer_expired(sta, skb))
+			skb = __skb_dequeue(&sta->tx_filtered);
+		else
+			skb = NULL;
+		spin_unlock_irqrestore(&sta->tx_filtered.lock, flags);
+
+		/*
+		 * Frames are queued in order, so if this one
+		 * hasn't expired yet we can stop testing. If
+		 * we actually reached the end of the queue we
+		 * also need to stop, of course.
+		 */
+		if (!skb)
+			break;
+		dev_kfree_skb(skb);
+	}
+
+	/*
+	 * Now also check the normal PS-buffered queue, this will
+	 * only find something if the filtered queue was emptied
+	 * since the filtered frames are all before the normal PS
+	 * buffered frames.
+	 */
 	for (;;) {
 		spin_lock_irqsave(&sta->ps_tx_buf.lock, flags);
 		skb = skb_peek(&sta->ps_tx_buf);
@@ -707,6 +740,11 @@ static bool sta_info_cleanup_expire_buff
 			skb = NULL;
 		spin_unlock_irqrestore(&sta->ps_tx_buf.lock, flags);
 
+		/*
+		 * frames are queued in order, so if this one
+		 * hasn't expired yet (or we reached the end of
+		 * the queue) we can stop testing
+		 */
 		if (!skb)
 			break;
 
@@ -716,13 +754,22 @@ static bool sta_info_cleanup_expire_buff
 		       sta->sta.addr);
 #endif
 		dev_kfree_skb(skb);
-
-		/* if the queue is now empty recalc TIM bit */
-		if (skb_queue_empty(&sta->ps_tx_buf))
-			sta_info_recalc_tim(sta);
 	}
 
-	return !skb_queue_empty(&sta->ps_tx_buf);
+	/*
+	 * Finally, recalculate the TIM bit for this station -- it might
+	 * now be clear because the station was too slow to retrieve its
+	 * frames.
+	 */
+	sta_info_recalc_tim(sta);
+
+	/*
+	 * Return whether there are any frames still buffered, this is
+	 * used to check whether the cleanup timer still needs to run,
+	 * if there are no frames we don't need to rearm the timer.
+	 */
+	return !(skb_queue_empty(&sta->ps_tx_buf) &&
+		 skb_queue_empty(&sta->tx_filtered));
 }
 
 static int __must_check __sta_info_destroy(struct sta_info *sta)
--- a/net/mac80211/status.c	2011-09-28 13:18:29.000000000 +0200
+++ b/net/mac80211/status.c	2011-09-28 13:18:30.000000000 +0200
@@ -107,6 +107,11 @@ static void ieee80211_handle_filtered_fr
 	    skb_queue_len(&sta->tx_filtered) < STA_MAX_TX_BUFFER) {
 		skb_queue_tail(&sta->tx_filtered, skb);
 		sta_info_recalc_tim(sta);
+
+		if (!timer_pending(&local->sta_cleanup))
+			mod_timer(&local->sta_cleanup,
+				  round_jiffies(jiffies +
+						STA_INFO_CLEANUP_INTERVAL));
 		return;
 	}
 


