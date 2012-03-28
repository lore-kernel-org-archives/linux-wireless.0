Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52826 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757655Ab2C1JHN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 05:07:13 -0400
Message-Id: <20120328090432.965911820@sipsolutions.net> (sfid-20120328_110724_729222_A5799F39)
Date: Wed, 28 Mar 2012 11:04:28 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 6/7] mac80211: lazily stop queues in add_pending
References: <20120328090422.367469100@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When adding pending SKBs there's no need to
stop all queues, we only need to stop those
that we're adding frames to. Implement that
by lazily stopping a queue as we add an SKB.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/util.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/mac80211/util.c	2012-03-28 09:34:49.000000000 +0200
+++ b/net/mac80211/util.c	2012-03-28 09:36:48.000000000 +0200
@@ -385,10 +385,6 @@ void ieee80211_add_pending_skbs_fn(struc
 	int queue, i;
 
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
-	for (i = 0; i < hw->queues; i++)
-		__ieee80211_stop_queue(hw, i,
-			IEEE80211_QUEUE_STOP_REASON_SKB_ADD);
-
 	while ((skb = skb_dequeue(skbs))) {
 		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
@@ -398,6 +394,10 @@ void ieee80211_add_pending_skbs_fn(struc
 		}
 
 		queue = skb_get_queue_mapping(skb);
+
+		__ieee80211_stop_queue(hw, queue,
+				IEEE80211_QUEUE_STOP_REASON_SKB_ADD);
+
 		__skb_queue_tail(&local->pending[queue], skb);
 	}
 


