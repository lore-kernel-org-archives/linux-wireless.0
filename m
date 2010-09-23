Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36754 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046Ab0IWS1y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 14:27:54 -0400
Subject: [RFC] mac80211: fix release_reorder_timeout in scan
From: Johannes Berg <johannes@sipsolutions.net>
To: wireless <linux-wireless@vger.kernel.org>
Cc: Jouni Malinen <j@w1.fi>,
	Christian Lamparter <chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Sep 2010 20:27:51 +0200
Message-ID: <1285266471.3770.384.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Even if the reorder timeout timer fires while
scanning, the frames weren't received during
scanning and therefore shouldn't be dropped.
To implement this, changes to the passive scan
RX handler are necessary.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Should we go for the frequency checks? Or just accept potential
off-channel RX like we used to for hw scan (we have to for hw scan since
hw scan might go back to operating channel on its own, and we don't even
stop queues)

 net/mac80211/rx.c |   28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

--- wireless-testing.orig/net/mac80211/rx.c	2010-09-23 16:13:40.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2010-09-23 16:58:02.000000000 +0200
@@ -388,20 +388,20 @@ ieee80211_rx_h_passive_scan(struct ieee8
 {
 	struct ieee80211_local *local = rx->local;
 	struct sk_buff *skb = rx->skb;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
+	ieee80211_rx_result ret;
 
-	if (unlikely(test_bit(SCAN_HW_SCANNING, &local->scanning)))
-		return ieee80211_scan_rx(rx->sdata, skb);
-
-	if (unlikely(test_bit(SCAN_SW_SCANNING, &local->scanning) &&
-		     (rx->flags & IEEE80211_RX_IN_SCAN))) {
-		/* drop all the other packets during a software scan anyway */
-		if (ieee80211_scan_rx(rx->sdata, skb) != RX_QUEUED)
-			dev_kfree_skb(skb);
-		return RX_QUEUED;
-	}
+	if (likely(!(rx->flags & IEEE80211_RX_IN_SCAN)))
+		return RX_CONTINUE;
 
-	if (unlikely(rx->flags & IEEE80211_RX_IN_SCAN)) {
-		/* scanning finished during invoking of handlers */
+	ret = ieee80211_scan_rx(rx->sdata, skb);
+	if (ret != RX_CONTINUE)
+		return ret;
+
+	if (status->freq != local->oper_channel->center_freq &&
+	    (!local->tmp_channel ||
+	     status->freq != local->tmp_channel->center_freq)) {
+		/* ignore scan channel RX */
 		I802_DEBUG_INC(local->rx_handlers_drop_passive_scan);
 		return RX_DROP_UNUSABLE;
 	}
@@ -2500,10 +2500,6 @@ void ieee80211_release_reorder_timeout(s
 	rx.queue = tid;
 	rx.flags |= IEEE80211_RX_RA_MATCH;
 
-	if (unlikely(test_bit(SCAN_HW_SCANNING, &sta->local->scanning) ||
-		     test_bit(SCAN_OFF_CHANNEL, &sta->local->scanning)))
-		rx.flags |= IEEE80211_RX_IN_SCAN;
-
 	spin_lock(&tid_agg_rx->reorder_lock);
 	ieee80211_sta_reorder_release(&sta->local->hw, tid_agg_rx, &frames);
 	spin_unlock(&tid_agg_rx->reorder_lock);


