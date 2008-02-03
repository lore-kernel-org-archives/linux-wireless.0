Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:48308 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbYBCV5x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 16:57:53 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 1/1] mac80211: fix mis-match in {test,set}_bit qdisc_pool
Date: Sun,  3 Feb 2008 23:54:38 +0200
Message-Id: <12020756782190-git-send-email-tomas.winkler@intel.com> (sfid-20080203_215800_218330_0DDEF6F7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch fixes a mis-match in {test,set}_bit for qdisc_pool created by
the move to an array of bits.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/wme.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index f12e044..4ecfb5e 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -158,7 +158,7 @@ static int wme_qdiscop_enqueue(struct sk_buff *skb, struct Qdisc* qd)
 		if (sta) {
 			int ampdu_queue = sta->tid_to_tx_q[tid];
 			if ((ampdu_queue < local->hw.queues) &&
-			    test_bit(ampdu_queue, &q->qdisc_pool)) {
+			    test_bit(ampdu_queue, q->qdisc_pool)) {
 				queue = ampdu_queue;
 				pkt_data->flags |= IEEE80211_TXPD_AMPDU;
 			} else {
@@ -191,7 +191,7 @@ static int wme_qdiscop_enqueue(struct sk_buff *skb, struct Qdisc* qd)
 		if (sta) {
 			int ampdu_queue = sta->tid_to_tx_q[tid];
 			if ((ampdu_queue < local->hw.queues) &&
-				test_bit(ampdu_queue, &q->qdisc_pool)) {
+				test_bit(ampdu_queue, q->qdisc_pool)) {
 				queue = ampdu_queue;
 				pkt_data->flags |= IEEE80211_TXPD_AMPDU;
 			} else {
@@ -272,7 +272,7 @@ static struct sk_buff *wme_qdiscop_dequeue(struct Qdisc* qd)
 				&local->state[queue])) ||
 		    (test_bit(IEEE80211_LINK_STATE_PENDING,
 				&local->state[queue])) ||
-			 (!test_bit(queue, &q->qdisc_pool)))
+			 (!test_bit(queue, q->qdisc_pool)))
 			continue;
 
 		/* there is space - try and get a frame */
@@ -396,7 +396,7 @@ static int wme_qdiscop_init(struct Qdisc *qd, struct rtattr *opt)
 
 	/* reserve all legacy QoS queues */
 	for (i = 0; i < min(IEEE80211_TX_QUEUE_DATA4, queues); i++)
-		set_bit(i, &q->qdisc_pool);
+		set_bit(i, q->qdisc_pool);
 
 	return err;
 }
@@ -657,7 +657,7 @@ int ieee80211_ht_agg_queue_add(struct ieee80211_local *local,
 
 	/* try to get a Qdisc from the pool */
 	for (i = IEEE80211_TX_QUEUE_BEACON; i < local->hw.queues; i++)
-		if (!test_and_set_bit(i, &q->qdisc_pool)) {
+		if (!test_and_set_bit(i, q->qdisc_pool)) {
 			ieee80211_stop_queue(local_to_hw(local), i);
 			sta->tid_to_tx_q[tid] = i;
 
@@ -668,9 +668,9 @@ int ieee80211_ht_agg_queue_add(struct ieee80211_local *local,
 #ifdef CONFIG_MAC80211_HT_DEBUG
 			if (net_ratelimit())
 				printk(KERN_DEBUG "allocated aggregation queue"
-					" %d tid %d addr %s pool=0x%lX\n",
+					" %d tid %d addr %s pool=0x%lX",
 					i, tid, print_mac(mac, sta->addr),
-					q->qdisc_pool);
+					q->qdisc_pool[0]);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 			return 0;
 		}
@@ -690,7 +690,7 @@ void ieee80211_ht_agg_queue_remove(struct ieee80211_local *local,
 	int agg_queue = sta->tid_to_tx_q[tid];
 
 	/* return the qdisc to the pool */
-	clear_bit(agg_queue, &q->qdisc_pool);
+	clear_bit(agg_queue, q->qdisc_pool);
 	sta->tid_to_tx_q[tid] = local->hw.queues;
 
 	if (requeue)
-- 
1.5.2.2

