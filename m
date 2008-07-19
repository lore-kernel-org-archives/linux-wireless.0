Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53554 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbYGSApu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 20:45:50 -0400
Message-Id: <20080719004518.325321000@sipsolutions.net> (sfid-20080719_024553_977154_67D501D8)
References: <20080719004147.795661000@sipsolutions.net>
Date: Sat, 19 Jul 2008 02:41:49 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: David Miller <davem@davemloft.net>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [RFC 2/3] mac80211: fix race during adding HT queues
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |    6 ++++++
 net/mac80211/main.c        |   21 ++++++++++++---------
 net/mac80211/wme.c         |   13 ++++++++-----
 3 files changed, 26 insertions(+), 14 deletions(-)

--- everything.orig/net/mac80211/main.c	2008-07-19 00:19:28.000000000 +0200
+++ everything/net/mac80211/main.c	2008-07-19 00:27:35.000000000 +0200
@@ -558,7 +558,7 @@ int ieee80211_start_tx_ba_session(struct
 	struct ieee80211_sub_if_data *sdata;
 	u16 start_seq_num = 0;
 	u8 *state;
-	int ret;
+	int ret = 0, reserved_queue;
 	DECLARE_MAC_BUF(mac);
 
 	if (tid >= STA_TID_NUM)
@@ -619,16 +619,16 @@ int ieee80211_start_tx_ba_session(struct
 	init_timer(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer);
 
 	/* create a new queue for this aggregation */
-	ret = ieee80211_ht_agg_queue_add(local, sta, tid);
+	reserved_queue = ieee80211_ht_agg_queue_add(local, sta, tid);
 
 	/* case no queue is available to aggregation
 	 * don't switch to aggregation */
-	if (ret) {
+	if (reserved_queue < 0) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "BA request denied - queue unavailable for"
 					" tid %d\n", tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
-		goto err_unlock_queue;
+		goto err_free_state;
 	}
 	sdata = sta->sdata;
 
@@ -642,8 +642,8 @@ int ieee80211_start_tx_ba_session(struct
 
 	if (ret) {
 		/* No need to requeue the packets in the agg queue, since we
-		 * held the tx lock: no packet could be enqueued to the newly
-		 * allocated queue */
+		 * haven't yet marked the queue in the queue_pool no packet
+		 * can have been enqueued to the newly allocated queue */
 		ieee80211_ht_agg_queue_remove(local, sta->tid_to_tx_q[tid], false);
 		sta->tid_to_tx_q[tid] = ieee80211_num_queues(hw);
 #ifdef CONFIG_MAC80211_HT_DEBUG
@@ -651,10 +651,13 @@ int ieee80211_start_tx_ba_session(struct
 					" tid %d\n", tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 		*state = HT_AGG_STATE_IDLE;
-		goto err_unlock_queue;
+		goto err_free_state;
 	}
 
-	/* Will put all the packets in the new SW queue */
+	/* mark the queue as used now */
+	set_bit(reserved_queue, local->queue_pool);
+
+	/* Put all the packets onto the new aggregation queue */
 	ieee80211_requeue(local, ieee802_1d_to_ac[tid]);
 	spin_unlock_bh(&sta->lock);
 
@@ -678,7 +681,7 @@ int ieee80211_start_tx_ba_session(struct
 #endif
 	goto exit;
 
-err_unlock_queue:
+err_free_state:
 	kfree(sta->ampdu_mlme.tid_tx[tid]);
 	sta->ampdu_mlme.tid_tx[tid] = NULL;
 	ret = -EBUSY;
--- everything.orig/net/mac80211/wme.c	2008-07-19 00:16:51.000000000 +0200
+++ everything/net/mac80211/wme.c	2008-07-19 00:34:29.000000000 +0200
@@ -183,6 +183,10 @@ u16 ieee80211_select_queue(struct net_de
 	return queue;
 }
 
+/*
+ * Must be called under local->sta_lock, will return a negative
+ * error code or the number of the reserved queue.
+ */
 int ieee80211_ht_agg_queue_add(struct ieee80211_local *local,
 			       struct sta_info *sta, u16 tid)
 {
@@ -196,7 +200,7 @@ int ieee80211_ht_agg_queue_add(struct ie
 
 	/* try to get a Qdisc from the pool */
 	for (i = local->hw.queues; i < ieee80211_num_queues(&local->hw); i++)
-		if (!test_and_set_bit(i, local->queue_pool)) {
+		if (!test_bit(i, local->queue_pool)) {
 			ieee80211_stop_queue(local_to_hw(local), i);
 			sta->tid_to_tx_q[tid] = i;
 
@@ -208,12 +212,11 @@ int ieee80211_ht_agg_queue_add(struct ie
 			if (net_ratelimit()) {
 				DECLARE_MAC_BUF(mac);
 				printk(KERN_DEBUG "allocated aggregation queue"
-					" %d tid %d addr %s pool=0x%lX\n",
-					i, tid, print_mac(mac, sta->addr),
-					local->queue_pool[0]);
+					" %d tid %d addr %s\n",
+					i, tid, print_mac(mac, sta->addr));
 			}
 #endif /* CONFIG_MAC80211_HT_DEBUG */
-			return 0;
+			return i;
 		}
 
 	return -EAGAIN;
--- everything.orig/net/mac80211/ieee80211_i.h	2008-07-19 00:28:06.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-07-19 00:30:31.000000000 +0200
@@ -549,6 +549,12 @@ struct ieee80211_local {
 
 	const struct ieee80211_ops *ops;
 
+	/*
+	 * Pool of reserved ampdu queues. Note that setting a bit
+	 * here to reserve the queue must only be done under sta_lock
+	 * to protect the setting process, we can unfortunately not
+	 * do it with atomic operations at this time.
+	 */
 	unsigned long queue_pool[BITS_TO_LONGS(QD_MAX_QUEUES)];
 
 	struct net_device *mdev; /* wmaster# - "master" 802.11 device */

-- 

