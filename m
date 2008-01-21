Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:10984 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758015AbYAULwZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2008 06:52:25 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 06/12] mac80211: A-MPDU Tx adding qdisc support
Date: Mon, 21 Jan 2008 13:52:06 +0200
Message-Id: <12009163392546-git-send-email-ron.rindjunsky@intel.com> (sfid-20080121_115405_055765_4D9B78E8)
In-Reply-To: <12009163321727-git-send-email-ron.rindjunsky@intel.com>
References: <12009163321727-git-send-email-ron.rindjunsky@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch allows qdisc support in A-MPDU Tx. a method to
handle QoS <-> TID switches is present in this patch.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 include/net/mac80211.h     |    8 ++-
 net/mac80211/ieee80211.c   |    8 +-
 net/mac80211/ieee80211_i.h |    5 +-
 net/mac80211/tx.c          |    2 +
 net/mac80211/wme.c         |  135 ++++++++++++++++++++++++++++++++++++++++---
 net/mac80211/wme.h         |   23 +++++++-
 6 files changed, 161 insertions(+), 20 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2ba6e73..e9d6425 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -246,6 +246,7 @@ struct ieee80211_tx_queue_stats_data {
  * @IEEE80211_TX_QUEUE_AFTER_BEACON: transmit queue for frames to be
  *	sent after a beacon
  * @IEEE80211_TX_QUEUE_BEACON: transmit queue for beacon frames
+ * @NUM_TX_DATA_QUEUES_AMPDU: adding more queues for A-MPDU
  */
 enum ieee80211_tx_queue {
 	IEEE80211_TX_QUEUE_DATA0,
@@ -261,11 +262,12 @@ enum ieee80211_tx_queue {
  * this struct need to have fixed values. As soon as it is removed, we can
  * fix these entries. */
 	IEEE80211_TX_QUEUE_AFTER_BEACON = 6,
-	IEEE80211_TX_QUEUE_BEACON = 7
+	IEEE80211_TX_QUEUE_BEACON = 7,
+	NUM_TX_DATA_QUEUES_AMPDU = 16
 };
 
 struct ieee80211_tx_queue_stats {
-	struct ieee80211_tx_queue_stats_data data[NUM_TX_DATA_QUEUES];
+	struct ieee80211_tx_queue_stats_data data[NUM_TX_DATA_QUEUES_AMPDU];
 };
 
 struct ieee80211_low_level_stats {
@@ -348,6 +350,8 @@ struct ieee80211_tx_control {
 #define IEEE80211_TXCTL_EAPOL_FRAME	(1<<11) /* internal to mac80211 */
 #define IEEE80211_TXCTL_SEND_AFTER_DTIM	(1<<12) /* send this frame after DTIM
 						 * beacon */
+#define IEEE80211_TXCTL_AMPDU		(1<<13) /* this frame should be sent
+						 * as part of an A-MPDU */
 	u32 flags;			       /* tx control flags defined
 						* above */
 	u8 key_idx;		/* keyidx from hw->set_key(), undefined if
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index fdb845b..7815b96 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -459,7 +459,7 @@ int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 	spin_lock_bh(&local->mdev->queue_lock);
 
 	/* create a new queue for this aggregation */
-	/* ret = ieee80211_ht_agg_queue_add(local, sta, tid); */
+	ret = ieee80211_ht_agg_queue_add(local, sta, tid);
 
 	/* case no queue is available to aggregation */
 	/* don't switch to aggregation */
@@ -485,7 +485,7 @@ int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 		/* No need to requeue the packets in the agg queue, since we
 		 * held the tx lock: no packet could be enqueued to the newly
 		 * allocated queue */
-		/* ieee80211_ht_agg_queue_remove(local, sta, tid, 0); */
+		 ieee80211_ht_agg_queue_remove(local, sta, tid, 0);
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "BA request denied - HW or queue unavailable"
 				" for tid %d\n", tid);
@@ -496,7 +496,7 @@ int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid)
 	}
 
 	/* Will put all the packets in the new SW queue */
-	/* ieee80211_requeue(local, ieee802_1d_to_ac[tid]); */
+	ieee80211_requeue(local, ieee802_1d_to_ac[tid]);
 	spin_unlock_bh(&local->mdev->queue_lock);
 
 	/* We have most probably almost emptied the legacy queue */
@@ -672,7 +672,7 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u8 tid)
 	 * the content of the qdiscs */
 	spin_lock_bh(&local->mdev->queue_lock);
 	/* remove the queue for this aggregation */
-	/* ieee80211_ht_agg_queue_remove(local, sta, tid, 1); */
+	ieee80211_ht_agg_queue_remove(local, sta, tid, 1);
 	spin_unlock_bh(&local->mdev->queue_lock);
 
 	/* we just requeued the all the frames that were in the removed
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 8a24c2c..cfd0717 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -165,6 +165,7 @@ struct ieee80211_txrx_data {
 #define IEEE80211_TXPD_DO_NOT_ENCRYPT	BIT(1)
 #define IEEE80211_TXPD_REQUEUE		BIT(2)
 #define IEEE80211_TXPD_EAPOL_FRAME	BIT(3)
+#define IEEE80211_TXPD_AMPDU		BIT(4)
 /* Stored in sk_buff->cb */
 struct ieee80211_tx_packet_data {
 	int ifindex;
@@ -452,8 +453,8 @@ struct ieee80211_local {
 	struct sta_info *sta_hash[STA_HASH_SIZE];
 	struct timer_list sta_cleanup;
 
-	unsigned long state[NUM_TX_DATA_QUEUES];
-	struct ieee80211_tx_stored_packet pending_packet[NUM_TX_DATA_QUEUES];
+	unsigned long state[NUM_TX_DATA_QUEUES_AMPDU];
+	struct ieee80211_tx_stored_packet pending_packet[NUM_TX_DATA_QUEUES_AMPDU];
 	struct tasklet_struct tx_pending_tasklet;
 
 	/* number of interfaces with corresponding IFF_ flags */
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 67b509e..4a7c447 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1260,6 +1260,8 @@ int ieee80211_master_start_xmit(struct sk_buff *skb,
 		control.flags |= IEEE80211_TXCTL_REQUEUE;
 	if (pkt_data->flags & IEEE80211_TXPD_EAPOL_FRAME)
 		control.flags |= IEEE80211_TXCTL_EAPOL_FRAME;
+	if (pkt_data->flags & IEEE80211_TXPD_AMPDU)
+		control.flags |= IEEE80211_TXCTL_AMPDU;
 	control.queue = pkt_data->queue;
 
 	ret = ieee80211_tx(odev, skb, &control);
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 5b8a157..ccb6608 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -19,10 +19,13 @@
 #include "wme.h"
 
 /* maximum number of hardware queues we support. */
-#define TC_80211_MAX_QUEUES 8
+#define TC_80211_MAX_QUEUES 16
+
+const int ieee802_1d_to_ac[8] = { 2, 3, 3, 2, 1, 1, 0, 0 };
 
 struct ieee80211_sched_data
 {
+	unsigned long qdisc_pool;
 	struct tcf_proto *filter_list;
 	struct Qdisc *queues[TC_80211_MAX_QUEUES];
 	struct sk_buff_head requeued[TC_80211_MAX_QUEUES];
@@ -97,7 +100,6 @@ static inline int classify80211(struct sk_buff *skb, struct Qdisc *qd)
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	unsigned short fc = le16_to_cpu(hdr->frame_control);
 	int qos;
-	const int ieee802_1d_to_ac[8] = { 2, 3, 3, 2, 1, 1, 0, 0 };
 
 	/* see if frame is data or non data frame */
 	if (unlikely((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA)) {
@@ -145,9 +147,25 @@ static int wme_qdiscop_enqueue(struct sk_buff *skb, struct Qdisc* qd)
 	unsigned short fc = le16_to_cpu(hdr->frame_control);
 	struct Qdisc *qdisc;
 	int err, queue;
+	struct sta_info *sta;
+	u8 tid;
 
 	if (pkt_data->flags & IEEE80211_TXPD_REQUEUE) {
-		skb_queue_tail(&q->requeued[pkt_data->queue], skb);
+		queue = pkt_data->queue;
+		sta = sta_info_get(local, hdr->addr1);
+		tid = skb->priority & QOS_CONTROL_TAG1D_MASK;
+		if (sta) {
+			int ampdu_queue = sta->tid_to_tx_q[tid];
+			if ((ampdu_queue < local->hw.queues) &&
+			    test_bit(ampdu_queue, &q->qdisc_pool)) {
+				queue = ampdu_queue;
+				pkt_data->flags |= IEEE80211_TXPD_AMPDU;
+			} else {
+				pkt_data->flags &= ~IEEE80211_TXPD_AMPDU;
+			}
+			sta_info_put(sta);
+		}
+		skb_queue_tail(&q->requeued[queue], skb);
 		qd->q.qlen++;
 		return 0;
 	}
@@ -158,14 +176,28 @@ static int wme_qdiscop_enqueue(struct sk_buff *skb, struct Qdisc* qd)
 	 */
 	if (WLAN_FC_IS_QOS_DATA(fc)) {
 		u8 *p = skb->data + ieee80211_get_hdrlen(fc) - 2;
-		u8 qos_hdr = skb->priority & QOS_CONTROL_TAG1D_MASK;
+		u8 ack_policy = 0;
+		tid = skb->priority & QOS_CONTROL_TAG1D_MASK;
 		if (local->wifi_wme_noack_test)
-			qos_hdr |= QOS_CONTROL_ACK_POLICY_NOACK <<
+			ack_policy |= QOS_CONTROL_ACK_POLICY_NOACK <<
 					QOS_CONTROL_ACK_POLICY_SHIFT;
 		/* qos header is 2 bytes, second reserved */
-		*p = qos_hdr;
+		*p = ack_policy | tid;
 		p++;
 		*p = 0;
+
+		sta = sta_info_get(local, hdr->addr1);
+		if (sta) {
+			int ampdu_queue = sta->tid_to_tx_q[tid];
+			if ((ampdu_queue < local->hw.queues) &&
+				test_bit(ampdu_queue, &q->qdisc_pool)) {
+				queue = ampdu_queue;
+				pkt_data->flags |= IEEE80211_TXPD_AMPDU;
+			} else {
+				pkt_data->flags &= ~IEEE80211_TXPD_AMPDU;
+			}
+			sta_info_put(sta);
+		}
 	}
 
 	if (unlikely(queue >= local->hw.queues)) {
@@ -183,6 +215,7 @@ static int wme_qdiscop_enqueue(struct sk_buff *skb, struct Qdisc* qd)
 			kfree_skb(skb);
 			err = NET_XMIT_DROP;
 	} else {
+		tid = skb->priority & QOS_CONTROL_TAG1D_MASK;
 		pkt_data->queue = (unsigned int) queue;
 		qdisc = q->queues[queue];
 		err = qdisc->enqueue(skb, qdisc);
@@ -234,10 +267,11 @@ static struct sk_buff *wme_qdiscop_dequeue(struct Qdisc* qd)
 	/* check all the h/w queues in numeric/priority order */
 	for (queue = 0; queue < hw->queues; queue++) {
 		/* see if there is room in this hardware queue */
-		if (test_bit(IEEE80211_LINK_STATE_XOFF,
-			     &local->state[queue]) ||
-		    test_bit(IEEE80211_LINK_STATE_PENDING,
-			     &local->state[queue]))
+		if ((test_bit(IEEE80211_LINK_STATE_XOFF,
+				&local->state[queue])) ||
+		    (test_bit(IEEE80211_LINK_STATE_PENDING,
+				&local->state[queue])) ||
+			 (!test_bit(queue, &q->qdisc_pool)))
 			continue;
 
 		/* there is space - try and get a frame */
@@ -359,6 +393,10 @@ static int wme_qdiscop_init(struct Qdisc *qd, struct rtattr *opt)
 		}
 	}
 
+	/* reserve all legacy QoS queues */
+	for (i = 0; i < min(IEEE80211_TX_QUEUE_DATA4, queues); i++)
+		set_bit(i, &q->qdisc_pool);
+
 	return err;
 }
 
@@ -604,3 +642,80 @@ void ieee80211_wme_unregister(void)
 {
 	unregister_qdisc(&wme_qdisc_ops);
 }
+
+int ieee80211_ht_agg_queue_add(struct ieee80211_local *local,
+			struct sta_info *sta, u16 tid)
+{
+	int i;
+	struct ieee80211_sched_data *q =
+			qdisc_priv(local->mdev->qdisc_sleeping);
+	DECLARE_MAC_BUF(mac);
+
+	/* prepare the filter and save it for the SW queue
+	 * matching the recieved HW queue */
+
+	/* try to get a Qdisc from the pool */
+	for (i = IEEE80211_TX_QUEUE_BEACON; i < local->hw.queues; i++)
+		if (!test_and_set_bit(i, &q->qdisc_pool)) {
+			ieee80211_stop_queue(local_to_hw(local), i);
+			sta->tid_to_tx_q[tid] = i;
+
+			/* IF there are already pending packets
+			 * on this tid first we need to drain them
+			 * on the previous queue
+			 * since HT is strict in order */
+#ifdef CONFIG_MAC80211_HT_DEBUG
+			if (net_ratelimit())
+				printk(KERN_DEBUG "allocated aggregation queue"
+					" %d tid %d addr %s pool=0x%lX\n",
+					i, tid, print_mac(mac, sta->addr),
+					q->qdisc_pool);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+			return 0;
+		}
+
+	return -EAGAIN;
+}
+
+/**
+ * the caller needs to hold local->mdev->queue_lock
+ */
+void ieee80211_ht_agg_queue_remove(struct ieee80211_local *local,
+				   struct sta_info *sta, u16 tid,
+				   u8 requeue)
+{
+	struct ieee80211_sched_data *q =
+		qdisc_priv(local->mdev->qdisc_sleeping);
+	int agg_queue = sta->tid_to_tx_q[tid];
+
+	/* return the qdisc to the pool */
+	clear_bit(agg_queue, &q->qdisc_pool);
+	sta->tid_to_tx_q[tid] = local->hw.queues;
+
+	if (requeue)
+		ieee80211_requeue(local, agg_queue);
+	else
+		q->queues[agg_queue]->ops->reset(q->queues[agg_queue]);
+}
+
+void ieee80211_requeue(struct ieee80211_local *local, int queue)
+{
+	struct Qdisc *root_qd = local->mdev->qdisc_sleeping;
+	struct ieee80211_sched_data *q = qdisc_priv(root_qd);
+	struct Qdisc *qdisc = q->queues[queue];
+	struct sk_buff *skb = NULL;
+	u32 len = qdisc->q.qlen;
+
+	if (!qdisc || !qdisc->dequeue)
+		return;
+
+	printk(KERN_DEBUG "requeue: qlen = %d\n", qdisc->q.qlen);
+	for (len = qdisc->q.qlen; len > 0; len--) {
+		skb = qdisc->dequeue(qdisc);
+		root_qd->q.qlen--;
+		/* packet will be classified again and */
+		/* skb->packet_data->queue will be overridden if needed */
+		if (skb)
+			wme_qdiscop_enqueue(skb, root_qd);
+	}
+}
diff --git a/net/mac80211/wme.h b/net/mac80211/wme.h
index 76c713a..fcc6b05 100644
--- a/net/mac80211/wme.h
+++ b/net/mac80211/wme.h
@@ -24,6 +24,8 @@
 
 #define QOS_CONTROL_TAG1D_MASK 0x07
 
+extern const int ieee802_1d_to_ac[8];
+
 static inline int WLAN_FC_IS_QOS_DATA(u16 fc)
 {
 	return (fc & 0x8C) == 0x88;
@@ -32,7 +34,12 @@ static inline int WLAN_FC_IS_QOS_DATA(u16 fc)
 #ifdef CONFIG_NET_SCHED
 void ieee80211_install_qdisc(struct net_device *dev);
 int ieee80211_qdisc_installed(struct net_device *dev);
-
+int ieee80211_ht_agg_queue_add(struct ieee80211_local *local,
+			       struct sta_info *sta, u16 tid);
+void ieee80211_ht_agg_queue_remove(struct ieee80211_local *local,
+				   struct sta_info *sta, u16 tid,
+				   u8 requeue);
+void ieee80211_requeue(struct ieee80211_local *local, int queue);
 int ieee80211_wme_register(void);
 void ieee80211_wme_unregister(void);
 #else
@@ -43,7 +50,19 @@ static inline int ieee80211_qdisc_installed(struct net_device *dev)
 {
 	return 0;
 }
-
+static inline int ieee80211_ht_agg_queue_add(struct ieee80211_local *local,
+					     struct sta_info *sta, u16 tid)
+{
+	return -EAGAIN;
+}
+static inline void ieee80211_ht_agg_queue_remove(struct ieee80211_local *local,
+						 struct sta_info *sta, u16 tid,
+						 u8 requeue)
+{
+}
+static inline void ieee80211_requeue(struct ieee80211_local *local, int queue)
+{
+}
 static inline int ieee80211_wme_register(void)
 {
 	return 0;
-- 
1.5.3.7

