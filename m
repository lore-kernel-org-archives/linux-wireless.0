Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39981 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab0IXJXv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 05:23:51 -0400
Message-Id: <20100924092306.033777419@sipsolutions.net>
Date: Fri, 24 Sep 2010 11:21:08 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/5] mac80211: fix release_reorder_timeout in scan
References: <20100924092104.384954781@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Even if the reorder timeout timer fires while
scanning, the frames weren't received during
scanning and therefore shouldn't be dropped.
To implement this, changes to the passive scan
RX handler simplify understanding it, because
it currently checks HW_SCANNING independently
of a packet's in-scan receive status (which
doesn't make a big difference, since scan_rx()
will only pick up probe responses and beacons,
which can't be aggregated.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

--- wireless-testing.orig/net/mac80211/rx.c	2010-09-24 10:57:11.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2010-09-24 10:57:14.000000000 +0200
@@ -389,24 +389,22 @@ ieee80211_rx_h_passive_scan(struct ieee8
 	struct ieee80211_local *local = rx->local;
 	struct sk_buff *skb = rx->skb;
 
-	if (unlikely(test_bit(SCAN_HW_SCANNING, &local->scanning)))
+	if (likely(!(rx->flags & IEEE80211_RX_IN_SCAN)))
+		return RX_CONTINUE;
+
+	if (test_bit(SCAN_HW_SCANNING, &local->scanning))
 		return ieee80211_scan_rx(rx->sdata, skb);
 
-	if (unlikely(test_bit(SCAN_SW_SCANNING, &local->scanning) &&
-		     (rx->flags & IEEE80211_RX_IN_SCAN))) {
+	if (test_bit(SCAN_SW_SCANNING, &local->scanning)) {
 		/* drop all the other packets during a software scan anyway */
 		if (ieee80211_scan_rx(rx->sdata, skb) != RX_QUEUED)
 			dev_kfree_skb(skb);
 		return RX_QUEUED;
 	}
 
-	if (unlikely(rx->flags & IEEE80211_RX_IN_SCAN)) {
-		/* scanning finished during invoking of handlers */
-		I802_DEBUG_INC(local->rx_handlers_drop_passive_scan);
-		return RX_DROP_UNUSABLE;
-	}
-
-	return RX_CONTINUE;
+	/* scanning finished during invoking of handlers */
+	I802_DEBUG_INC(local->rx_handlers_drop_passive_scan);
+	return RX_DROP_UNUSABLE;
 }
 
 
@@ -2495,10 +2493,6 @@ void ieee80211_release_reorder_timeout(s
 	rx.queue = tid;
 	rx.flags |= IEEE80211_RX_RA_MATCH;
 
-	if (unlikely(test_bit(SCAN_HW_SCANNING, &sta->local->scanning) ||
-		     test_bit(SCAN_OFF_CHANNEL, &sta->local->scanning)))
-		rx.flags |= IEEE80211_RX_IN_SCAN;
-
 	spin_lock(&tid_agg_rx->reorder_lock);
 	ieee80211_sta_reorder_release(&sta->local->hw, tid_agg_rx, &frames);
 	spin_unlock(&tid_agg_rx->reorder_lock);


