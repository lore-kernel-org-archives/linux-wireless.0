Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59162 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757947AbYD3Qvc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 12:51:32 -0400
Subject: [PATCH v2 3/3] mac80211: QoS related cleanups
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080429152042.544902000@sipsolutions.net> (sfid-20080430_160643_852084_DF912406)
References: <20080429151858.253229000@sipsolutions.net>
	 <20080429152042.544902000@sipsolutions.net>
	 (sfid-20080430_160643_852084_DF912406)
Content-Type: text/plain
Date: Wed, 30 Apr 2008 18:51:21 +0200
Message-Id: <1209574281.18659.86.camel@johannes.berg> (sfid-20080430_185126_304278_03D519C0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This
 * makes the queue number passed to drivers a u16
   (as it will be with skb_get_queue_mapping)
 * removes the useless queue number defines
 * splits hw->queues into hw->queues/ampdu_queues
 * removes the debugfs files for per-queue counters
 * removes some dead QoS code
 * removes the beacon queue configuration for IBSS
   so that the drivers now never get a queue number
   bigger than (hw->queues + hw->ampdu_queues - 1)
   for tx and only in the range 0..hw->queues-1 for
   conf_tx.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
v2: have iwlwifi set ampdu_queues

 drivers/net/wireless/b43/main.c             |    3 
 drivers/net/wireless/b43legacy/main.c       |    3 
 drivers/net/wireless/iwlwifi/iwl-core.c     |    2 
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 
 drivers/net/wireless/p54/p54common.c        |    2 
 drivers/net/wireless/rt2x00/rt2400pci.c     |    5 -
 drivers/net/wireless/rt2x00/rt2x00.h        |    2 
 drivers/net/wireless/rt2x00/rt2x00mac.c     |    2 
 drivers/net/wireless/rt2x00/rt2x00queue.h   |    7 -
 include/net/mac80211.h                      |   66 +++++----------
 net/mac80211/debugfs.c                      |   43 ----------
 net/mac80211/debugfs_sta.c                  |   38 --------
 net/mac80211/ieee80211_i.h                  |    8 -
 net/mac80211/main.c                         |    5 +
 net/mac80211/mlme.c                         |   23 +----
 net/mac80211/rx.c                           |    5 -
 net/mac80211/sta_info.c                     |    2 
 net/mac80211/wme.c                          |  120 +++++++++++-----------------
 19 files changed, 100 insertions(+), 240 deletions(-)

--- everything.orig/include/net/mac80211.h	2008-04-30 16:55:34.000000000 +0200
+++ everything/include/net/mac80211.h	2008-04-30 18:48:32.000000000 +0200
@@ -98,6 +98,18 @@ struct ieee80211_ht_bss_info {
 };
 
 /**
+ * enum ieee80211_max_queues - maximum number of queues
+ *
+ * @IEEE80211_MAX_QUEUES: Maximum number of regular device queues.
+ * @IEEE80211_MAX_AMPDU_QUEUES: Maximum number of queues usable
+ *	for A-MPDU operation.
+ */
+enum ieee80211_max_queues {
+	IEEE80211_MAX_QUEUES =		16,
+	IEEE80211_MAX_AMPDU_QUEUES =	16,
+};
+
+/**
  * struct ieee80211_tx_queue_params - transmit queue configuration
  *
  * The information provided in this structure is required for QoS
@@ -129,42 +141,6 @@ struct ieee80211_tx_queue_stats {
 	unsigned int count;
 };
 
-/**
- * enum ieee80211_tx_queue - transmit queue number
- *
- * These constants are used with some callbacks that take a
- * queue number to set parameters for a queue.
- *
- * @IEEE80211_TX_QUEUE_DATA0: data queue 0
- * @IEEE80211_TX_QUEUE_DATA1: data queue 1
- * @IEEE80211_TX_QUEUE_DATA2: data queue 2
- * @IEEE80211_TX_QUEUE_DATA3: data queue 3
- * @IEEE80211_TX_QUEUE_DATA4: data queue 4
- * @IEEE80211_TX_QUEUE_SVP: ??
- * @NUM_TX_DATA_QUEUES: number of data queues
- * @IEEE80211_TX_QUEUE_AFTER_BEACON: transmit queue for frames to be
- *	sent after a beacon
- * @IEEE80211_TX_QUEUE_BEACON: transmit queue for beacon frames
- * @NUM_TX_DATA_QUEUES_AMPDU: adding more queues for A-MPDU
- */
-enum ieee80211_tx_queue {
-	IEEE80211_TX_QUEUE_DATA0,
-	IEEE80211_TX_QUEUE_DATA1,
-	IEEE80211_TX_QUEUE_DATA2,
-	IEEE80211_TX_QUEUE_DATA3,
-	IEEE80211_TX_QUEUE_DATA4,
-	IEEE80211_TX_QUEUE_SVP,
-
-	NUM_TX_DATA_QUEUES,
-
-/* due to stupidity in the sub-ioctl userspace interface, the items in
- * this struct need to have fixed values. As soon as it is removed, we can
- * fix these entries. */
-	IEEE80211_TX_QUEUE_AFTER_BEACON = 6,
-	IEEE80211_TX_QUEUE_BEACON = 7,
-	NUM_TX_DATA_QUEUES_AMPDU = 16
-};
-
 struct ieee80211_low_level_stats {
 	unsigned int dot11ACKFailureCount;
 	unsigned int dot11RTSFailureCount;
@@ -304,7 +280,7 @@ struct ieee80211_tx_control {
 				 * position represents antenna number used */
 	u8 icv_len;		/* length of the ICV/MIC field in octets */
 	u8 iv_len;		/* length of the IV field in octets */
-	u8 queue;		/* hardware queue to use for this frame;
+	u16 queue;		/* hardware queue to use for this frame;
 				 * 0 = highest, hw->queues-1 = lowest */
 	u16 aid;		/* Station AID */
 	int type;	/* internal */
@@ -758,7 +734,14 @@ enum ieee80211_hw_flags {
  * @max_noise: like @max_rssi, but for the noise value.
  *
  * @queues: number of available hardware transmit queues for
- *	data packets. WMM/QoS requires at least four.
+ *	data packets. WMM/QoS requires at least four, these
+ *	queues need to have configurable access parameters.
+ *
+ * @ampdu_queues: number of available hardware transmit queues
+ *	for A-MPDU packets, these have no access parameters
+ *	because they're used only for A-MPDU frames. Note that
+ *	mac80211 will not currently use any of the regular queues
+ *	for aggregation.
  *
  * @rate_control_algorithm: rate control algorithm for this hardware.
  *	If unset (NULL), the default algorithm will be used. Must be
@@ -777,7 +760,7 @@ struct ieee80211_hw {
 	unsigned int extra_tx_headroom;
 	int channel_change_time;
 	int vif_data_size;
-	u8 queues;
+	u16 queues, ampdu_queues;
 	s8 max_rssi;
 	s8 max_signal;
 	s8 max_noise;
@@ -1055,8 +1038,7 @@ enum ieee80211_ampdu_mlme_action {
  *	of assocaited station or AP.
  *
  * @conf_tx: Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
- *	bursting) for a hardware TX queue. The @queue parameter uses the
- *	%IEEE80211_TX_QUEUE_* constants. Must be atomic.
+ *	bursting) for a hardware TX queue. Must be atomic.
  *
  * @get_tx_stats: Get statistics of the current TX queue status. This is used
  *	to get number of currently queued packets (queue length), maximum queue
@@ -1136,7 +1118,7 @@ struct ieee80211_ops {
 			       u32 short_retry, u32 long_retr);
 	void (*sta_notify)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			enum sta_notify_cmd, const u8 *addr);
-	int (*conf_tx)(struct ieee80211_hw *hw, int queue,
+	int (*conf_tx)(struct ieee80211_hw *hw, u16 queue,
 		       const struct ieee80211_tx_queue_params *params);
 	int (*get_tx_stats)(struct ieee80211_hw *hw,
 			    struct ieee80211_tx_queue_stats *stats);
--- everything.orig/net/mac80211/main.c	2008-04-30 16:55:32.000000000 +0200
+++ everything/net/mac80211/main.c	2008-04-30 18:48:27.000000000 +0200
@@ -1806,6 +1806,11 @@ int ieee80211_register_hw(struct ieee802
 		goto fail_wep;
 	}
 
+	if (hw->queues > IEEE80211_MAX_QUEUES)
+		hw->queues = IEEE80211_MAX_QUEUES;
+	if (hw->ampdu_queues > IEEE80211_MAX_AMPDU_QUEUES)
+		hw->ampdu_queues = IEEE80211_MAX_AMPDU_QUEUES;
+
 	ieee80211_install_qdisc(local->mdev);
 
 	/* add one default STA interface */
--- everything.orig/net/mac80211/mlme.c	2008-04-30 16:55:32.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-04-30 18:48:30.000000000 +0200
@@ -256,19 +256,8 @@ static void ieee80211_sta_def_wmm_params
 		qparam.cw_max = 1023;
 		qparam.txop = 0;
 
-		for (i = IEEE80211_TX_QUEUE_DATA0; i < NUM_TX_DATA_QUEUES; i++)
-			local->ops->conf_tx(local_to_hw(local),
-					   i + IEEE80211_TX_QUEUE_DATA0,
-					   &qparam);
-
-		if (ibss) {
-			/* IBSS uses different parameters for Beacon sending */
-			qparam.cw_min++;
-			qparam.cw_min *= 2;
-			qparam.cw_min--;
-			local->ops->conf_tx(local_to_hw(local),
-					   IEEE80211_TX_QUEUE_BEACON, &qparam);
-		}
+		for (i = 0; i < local_to_hw(local)->queues; i++)
+			local->ops->conf_tx(local_to_hw(local), i, &qparam);
 	}
 }
 
@@ -311,23 +300,23 @@ static void ieee80211_sta_wmm_params(str
 
 		switch (aci) {
 		case 1:
-			queue = IEEE80211_TX_QUEUE_DATA3;
+			queue = 3;
 			if (acm)
 				local->wmm_acm |= BIT(0) | BIT(3);
 			break;
 		case 2:
-			queue = IEEE80211_TX_QUEUE_DATA1;
+			queue = 1;
 			if (acm)
 				local->wmm_acm |= BIT(4) | BIT(5);
 			break;
 		case 3:
-			queue = IEEE80211_TX_QUEUE_DATA0;
+			queue = 0;
 			if (acm)
 				local->wmm_acm |= BIT(6) | BIT(7);
 			break;
 		case 0:
 		default:
-			queue = IEEE80211_TX_QUEUE_DATA2;
+			queue = 2;
 			if (acm)
 				local->wmm_acm |= BIT(1) | BIT(2);
 			break;
--- everything.orig/net/mac80211/sta_info.c	2008-04-30 16:55:32.000000000 +0200
+++ everything/net/mac80211/sta_info.c	2008-04-30 16:55:35.000000000 +0200
@@ -255,7 +255,7 @@ struct sta_info *sta_info_alloc(struct i
 		 * sta_rx_agg_session_timer_expired for useage */
 		sta->timer_to_tid[i] = i;
 		/* tid to tx queue: initialize according to HW (0 is valid) */
-		sta->tid_to_tx_q[i] = local->hw.queues;
+		sta->tid_to_tx_q[i] = local->hw.queues + local->hw.ampdu_queues;
 		/* rx */
 		sta->ampdu_mlme.tid_state_rx[i] = HT_AGG_STATE_IDLE;
 		sta->ampdu_mlme.tid_rx[i] = NULL;
--- everything.orig/net/mac80211/wme.c	2008-04-30 16:53:59.000000000 +0200
+++ everything/net/mac80211/wme.c	2008-04-30 18:48:27.000000000 +0200
@@ -19,16 +19,22 @@
 #include "wme.h"
 
 /* maximum number of hardware queues we support. */
-#define TC_80211_MAX_QUEUES 16
+#define QD_MAX_QUEUES (IEEE80211_MAX_AMPDU_QUEUES + IEEE80211_MAX_QUEUES)
+/* current number of hardware queues we support. */
+#define QD_NUM(hw) ((hw)->queues + (hw)->ampdu_queues)
 
+/*
+ * Default mapping in classifier to work with default
+ * queue setup.
+ */
 const int ieee802_1d_to_ac[8] = { 2, 3, 3, 2, 1, 1, 0, 0 };
 
 struct ieee80211_sched_data
 {
-	unsigned long qdisc_pool[BITS_TO_LONGS(TC_80211_MAX_QUEUES)];
+	unsigned long qdisc_pool[BITS_TO_LONGS(QD_MAX_QUEUES)];
 	struct tcf_proto *filter_list;
-	struct Qdisc *queues[TC_80211_MAX_QUEUES];
-	struct sk_buff_head requeued[TC_80211_MAX_QUEUES];
+	struct Qdisc *queues[QD_MAX_QUEUES];
+	struct sk_buff_head requeued[QD_MAX_QUEUES];
 };
 
 static const char llc_ip_hdr[8] = {0xAA, 0xAA, 0x3, 0, 0, 0, 0x08, 0};
@@ -95,7 +101,7 @@ static inline int wme_downgrade_ac(struc
 
 /* positive return value indicates which queue to use
  * negative return value indicates to drop the frame */
-static inline int classify80211(struct sk_buff *skb, struct Qdisc *qd)
+static int classify80211(struct sk_buff *skb, struct Qdisc *qd)
 {
 	struct ieee80211_local *local = wdev_priv(qd->dev->ieee80211_ptr);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
@@ -106,7 +112,7 @@ static inline int classify80211(struct s
 	if (unlikely((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA)) {
 		/* management frames go on AC_VO queue, but are sent
 		* without QoS control fields */
-		return IEEE80211_TX_QUEUE_DATA0;
+		return 0;
 	}
 
 	if (0 /* injected */) {
@@ -141,14 +147,16 @@ static inline int classify80211(struct s
 static int wme_qdiscop_enqueue(struct sk_buff *skb, struct Qdisc* qd)
 {
 	struct ieee80211_local *local = wdev_priv(qd->dev->ieee80211_ptr);
+	struct ieee80211_hw *hw = &local->hw;
 	struct ieee80211_sched_data *q = qdisc_priv(qd);
 	struct ieee80211_tx_packet_data *pkt_data =
 		(struct ieee80211_tx_packet_data *) skb->cb;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	unsigned short fc = le16_to_cpu(hdr->frame_control);
 	struct Qdisc *qdisc;
-	int err, queue;
 	struct sta_info *sta;
+	int err;
+	u16 queue;
 	u8 tid;
 
 	if (pkt_data->flags & IEEE80211_TXPD_REQUEUE) {
@@ -158,7 +166,7 @@ static int wme_qdiscop_enqueue(struct sk
 		tid = skb->priority & QOS_CONTROL_TAG1D_MASK;
 		if (sta) {
 			int ampdu_queue = sta->tid_to_tx_q[tid];
-			if ((ampdu_queue < local->hw.queues) &&
+			if ((ampdu_queue < QD_NUM(hw)) &&
 			    test_bit(ampdu_queue, q->qdisc_pool)) {
 				queue = ampdu_queue;
 				pkt_data->flags |= IEEE80211_TXPD_AMPDU;
@@ -174,6 +182,9 @@ static int wme_qdiscop_enqueue(struct sk
 
 	queue = classify80211(skb, qd);
 
+	if (unlikely(queue >= local->hw.queues))
+		queue = local->hw.queues - 1;
+
 	/* now we know the 1d priority, fill in the QoS header if there is one
 	 */
 	if (WLAN_FC_IS_QOS_DATA(fc)) {
@@ -193,8 +204,8 @@ static int wme_qdiscop_enqueue(struct sk
 		sta = sta_info_get(local, hdr->addr1);
 		if (sta) {
 			int ampdu_queue = sta->tid_to_tx_q[tid];
-			if ((ampdu_queue < local->hw.queues) &&
-				test_bit(ampdu_queue, q->qdisc_pool)) {
+			if ((ampdu_queue < QD_NUM(hw)) &&
+			    test_bit(ampdu_queue, q->qdisc_pool)) {
 				queue = ampdu_queue;
 				pkt_data->flags |= IEEE80211_TXPD_AMPDU;
 			} else {
@@ -205,17 +216,6 @@ static int wme_qdiscop_enqueue(struct sk
 		rcu_read_unlock();
 	}
 
-	if (unlikely(queue >= local->hw.queues)) {
-#if 0
-		if (net_ratelimit()) {
-			printk(KERN_DEBUG "%s - queue=%d (hw does not "
-			       "support) -> %d\n",
-			       __func__, queue, local->hw.queues - 1);
-		}
-#endif
-		queue = local->hw.queues - 1;
-	}
-
 	if (unlikely(queue < 0)) {
 			kfree_skb(skb);
 			err = NET_XMIT_DROP;
@@ -270,7 +270,7 @@ static struct sk_buff *wme_qdiscop_deque
 	int queue;
 
 	/* check all the h/w queues in numeric/priority order */
-	for (queue = 0; queue < hw->queues; queue++) {
+	for (queue = 0; queue < QD_NUM(hw); queue++) {
 		/* see if there is room in this hardware queue */
 		if ((test_bit(IEEE80211_LINK_STATE_XOFF,
 				&local->state[queue])) ||
@@ -308,7 +308,7 @@ static void wme_qdiscop_reset(struct Qdi
 
 	/* QUESTION: should we have some hardware flush functionality here? */
 
-	for (queue = 0; queue < hw->queues; queue++) {
+	for (queue = 0; queue < QD_NUM(hw); queue++) {
 		skb_queue_purge(&q->requeued[queue]);
 		qdisc_reset(q->queues[queue]);
 	}
@@ -326,7 +326,7 @@ static void wme_qdiscop_destroy(struct Q
 	tcf_destroy_chain(q->filter_list);
 	q->filter_list = NULL;
 
-	for (queue=0; queue < hw->queues; queue++) {
+	for (queue = 0; queue < QD_NUM(hw); queue++) {
 		skb_queue_purge(&q->requeued[queue]);
 		qdisc_destroy(q->queues[queue]);
 		q->queues[queue] = &noop_qdisc;
@@ -337,17 +337,6 @@ static void wme_qdiscop_destroy(struct Q
 /* called whenever parameters are updated on existing qdisc */
 static int wme_qdiscop_tune(struct Qdisc *qd, struct nlattr *opt)
 {
-/*	struct ieee80211_sched_data *q = qdisc_priv(qd);
-*/
-	/* check our options block is the right size */
-	/* copy any options to our local structure */
-/*	Ignore options block for now - always use static mapping
-	struct tc_ieee80211_qopt *qopt = nla_data(opt);
-
-	if (opt->nla_len < nla_attr_size(sizeof(*qopt)))
-		return -EINVAL;
-	memcpy(q->tag2queue, qopt->tag2queue, sizeof(qopt->tag2queue));
-*/
 	return 0;
 }
 
@@ -358,7 +347,7 @@ static int wme_qdiscop_init(struct Qdisc
 	struct ieee80211_sched_data *q = qdisc_priv(qd);
 	struct net_device *dev = qd->dev;
 	struct ieee80211_local *local;
-	int queues;
+	struct ieee80211_hw *hw;
 	int err = 0, i;
 
 	/* check that device is a mac80211 device */
@@ -366,29 +355,26 @@ static int wme_qdiscop_init(struct Qdisc
 	    dev->ieee80211_ptr->wiphy->privid != mac80211_wiphy_privid)
 		return -EINVAL;
 
-	/* check this device is an ieee80211 master type device */
-	if (dev->type != ARPHRD_IEEE80211)
+	local = wdev_priv(dev->ieee80211_ptr);
+	hw = &local->hw;
+
+	/* only allow on master dev */
+	if (dev != local->mdev)
 		return -EINVAL;
 
-	/* check that there is no qdisc currently attached to device
-	 * this ensures that we will be the root qdisc. (I can't find a better
-	 * way to test this explicitly) */
-	if (dev->qdisc_sleeping != &noop_qdisc)
+	/* ensure that we are root qdisc */
+	if (qd->parent != TC_H_ROOT)
 		return -EINVAL;
 
 	if (qd->flags & TCQ_F_INGRESS)
 		return -EINVAL;
 
-	local = wdev_priv(dev->ieee80211_ptr);
-	queues = local->hw.queues;
-
 	/* if options were passed in, set them */
-	if (opt) {
+	if (opt)
 		err = wme_qdiscop_tune(qd, opt);
-	}
 
 	/* create child queues */
-	for (i = 0; i < queues; i++) {
+	for (i = 0; i < QD_NUM(hw); i++) {
 		skb_queue_head_init(&q->requeued[i]);
 		q->queues[i] = qdisc_create_dflt(qd->dev, &pfifo_qdisc_ops,
 						 qd->handle);
@@ -398,8 +384,8 @@ static int wme_qdiscop_init(struct Qdisc
 		}
 	}
 
-	/* reserve all legacy QoS queues */
-	for (i = 0; i < min(IEEE80211_TX_QUEUE_DATA4, queues); i++)
+	/* non-aggregation queues: reserve/mark as used */
+	for (i = 0; i < local->hw.queues; i++)
 		set_bit(i, q->qdisc_pool);
 
 	return err;
@@ -407,16 +393,6 @@ static int wme_qdiscop_init(struct Qdisc
 
 static int wme_qdiscop_dump(struct Qdisc *qd, struct sk_buff *skb)
 {
-/*	struct ieee80211_sched_data *q = qdisc_priv(qd);
-	unsigned char *p = skb->tail;
-	struct tc_ieee80211_qopt opt;
-
-	memcpy(&opt.tag2queue, q->tag2queue, TC_80211_MAX_TAG + 1);
-	NLA_PUT(skb, TCA_OPTIONS, sizeof(opt), &opt);
-*/	return skb->len;
-/*
-nla_put_failure:
-	skb_trim(skb, p - skb->data);*/
 	return -1;
 }
 
@@ -429,7 +405,7 @@ static int wme_classop_graft(struct Qdis
 	struct ieee80211_hw *hw = &local->hw;
 	unsigned long queue = arg - 1;
 
-	if (queue >= hw->queues)
+	if (queue >= QD_NUM(hw))
 		return -EINVAL;
 
 	if (!new)
@@ -453,7 +429,7 @@ wme_classop_leaf(struct Qdisc *qd, unsig
 	struct ieee80211_hw *hw = &local->hw;
 	unsigned long queue = arg - 1;
 
-	if (queue >= hw->queues)
+	if (queue >= QD_NUM(hw))
 		return NULL;
 
 	return q->queues[queue];
@@ -466,7 +442,7 @@ static unsigned long wme_classop_get(str
 	struct ieee80211_hw *hw = &local->hw;
 	unsigned long queue = TC_H_MIN(classid);
 
-	if (queue - 1 >= hw->queues)
+	if (queue - 1 >= QD_NUM(hw))
 		return 0;
 
 	return queue;
@@ -492,7 +468,7 @@ static int wme_classop_change(struct Qdi
 	struct ieee80211_local *local = wdev_priv(qd->dev->ieee80211_ptr);
 	struct ieee80211_hw *hw = &local->hw;
 
-	if (cl - 1 > hw->queues)
+	if (cl - 1 > QD_NUM(hw))
 		return -ENOENT;
 
 	/* TODO: put code to program hardware queue parameters here,
@@ -509,7 +485,7 @@ static int wme_classop_delete(struct Qdi
 	struct ieee80211_local *local = wdev_priv(qd->dev->ieee80211_ptr);
 	struct ieee80211_hw *hw = &local->hw;
 
-	if (cl - 1 > hw->queues)
+	if (cl - 1 > QD_NUM(hw))
 		return -ENOENT;
 	return 0;
 }
@@ -522,7 +498,7 @@ static int wme_classop_dump_class(struct
 	struct ieee80211_local *local = wdev_priv(qd->dev->ieee80211_ptr);
 	struct ieee80211_hw *hw = &local->hw;
 
-	if (cl - 1 > hw->queues)
+	if (cl - 1 > QD_NUM(hw))
 		return -ENOENT;
 	tcm->tcm_handle = TC_H_MIN(cl);
 	tcm->tcm_parent = qd->handle;
@@ -540,7 +516,7 @@ static void wme_classop_walk(struct Qdis
 	if (arg->stop)
 		return;
 
-	for (queue = 0; queue < hw->queues; queue++) {
+	for (queue = 0; queue < QD_NUM(hw); queue++) {
 		if (arg->count < arg->skip) {
 			arg->count++;
 			continue;
@@ -657,10 +633,13 @@ int ieee80211_ht_agg_queue_add(struct ie
 	DECLARE_MAC_BUF(mac);
 
 	/* prepare the filter and save it for the SW queue
-	 * matching the recieved HW queue */
+	 * matching the received HW queue */
+
+	if (!local->hw.ampdu_queues)
+		return -EPERM;
 
 	/* try to get a Qdisc from the pool */
-	for (i = IEEE80211_TX_QUEUE_BEACON; i < local->hw.queues; i++)
+	for (i = local->hw.queues; i < QD_NUM(&local->hw); i++)
 		if (!test_and_set_bit(i, q->qdisc_pool)) {
 			ieee80211_stop_queue(local_to_hw(local), i);
 			sta->tid_to_tx_q[tid] = i;
@@ -689,13 +668,14 @@ void ieee80211_ht_agg_queue_remove(struc
 				   struct sta_info *sta, u16 tid,
 				   u8 requeue)
 {
+	struct ieee80211_hw *hw = &local->hw;
 	struct ieee80211_sched_data *q =
 		qdisc_priv(local->mdev->qdisc_sleeping);
 	int agg_queue = sta->tid_to_tx_q[tid];
 
 	/* return the qdisc to the pool */
 	clear_bit(agg_queue, q->qdisc_pool);
-	sta->tid_to_tx_q[tid] = local->hw.queues;
+	sta->tid_to_tx_q[tid] = QD_NUM(hw);
 
 	if (requeue)
 		ieee80211_requeue(local, agg_queue);
--- everything.orig/drivers/net/wireless/rt2x00/rt2400pci.c	2008-04-30 16:55:33.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2400pci.c	2008-04-30 16:55:35.000000000 +0200
@@ -1442,8 +1442,7 @@ static int rt2400pci_set_retry_limit(str
 	return 0;
 }
 
-static int rt2400pci_conf_tx(struct ieee80211_hw *hw,
-			     int queue,
+static int rt2400pci_conf_tx(struct ieee80211_hw *hw, u16 queue,
 			     const struct ieee80211_tx_queue_params *params)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
@@ -1453,7 +1452,7 @@ static int rt2400pci_conf_tx(struct ieee
 	 * per queue. So by default we only configure the TX queue,
 	 * and ignore all other configurations.
 	 */
-	if (queue != IEEE80211_TX_QUEUE_DATA0)
+	if (queue != 0)
 		return -EINVAL;
 
 	if (rt2x00mac_conf_tx(hw, queue, params))
--- everything.orig/net/mac80211/debugfs.c	2008-04-30 16:53:59.000000000 +0200
+++ everything/net/mac80211/debugfs.c	2008-04-30 16:55:35.000000000 +0200
@@ -197,45 +197,6 @@ DEBUGFS_STATS_FILE(rx_handlers_fragments
 DEBUGFS_STATS_FILE(tx_status_drop, 20, "%u",
 		   local->tx_status_drop);
 
-static ssize_t stats_wme_rx_queue_read(struct file *file,
-				       char __user *userbuf,
-				       size_t count, loff_t *ppos)
-{
-	struct ieee80211_local *local = file->private_data;
-	char buf[NUM_RX_DATA_QUEUES*15], *p = buf;
-	int i;
-
-	for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
-		p += scnprintf(p, sizeof(buf)+buf-p,
-			       "%u\n", local->wme_rx_queue[i]);
-
-	return simple_read_from_buffer(userbuf, count, ppos, buf, p-buf);
-}
-
-static const struct file_operations stats_wme_rx_queue_ops = {
-	.read = stats_wme_rx_queue_read,
-	.open = mac80211_open_file_generic,
-};
-
-static ssize_t stats_wme_tx_queue_read(struct file *file,
-				       char __user *userbuf,
-				       size_t count, loff_t *ppos)
-{
-	struct ieee80211_local *local = file->private_data;
-	char buf[NUM_TX_DATA_QUEUES*15], *p = buf;
-	int i;
-
-	for (i = 0; i < NUM_TX_DATA_QUEUES; i++)
-		p += scnprintf(p, sizeof(buf)+buf-p,
-			       "%u\n", local->wme_tx_queue[i]);
-
-	return simple_read_from_buffer(userbuf, count, ppos, buf, p-buf);
-}
-
-static const struct file_operations stats_wme_tx_queue_ops = {
-	.read = stats_wme_tx_queue_read,
-	.open = mac80211_open_file_generic,
-};
 #endif
 
 DEBUGFS_DEVSTATS_FILE(dot11ACKFailureCount);
@@ -303,8 +264,6 @@ void debugfs_hw_add(struct ieee80211_loc
 	DEBUGFS_STATS_ADD(rx_expand_skb_head2);
 	DEBUGFS_STATS_ADD(rx_handlers_fragments);
 	DEBUGFS_STATS_ADD(tx_status_drop);
-	DEBUGFS_STATS_ADD(wme_tx_queue);
-	DEBUGFS_STATS_ADD(wme_rx_queue);
 #endif
 	DEBUGFS_STATS_ADD(dot11ACKFailureCount);
 	DEBUGFS_STATS_ADD(dot11RTSFailureCount);
@@ -356,8 +315,6 @@ void debugfs_hw_del(struct ieee80211_loc
 	DEBUGFS_STATS_DEL(rx_expand_skb_head2);
 	DEBUGFS_STATS_DEL(rx_handlers_fragments);
 	DEBUGFS_STATS_DEL(tx_status_drop);
-	DEBUGFS_STATS_DEL(wme_tx_queue);
-	DEBUGFS_STATS_DEL(wme_rx_queue);
 #endif
 	DEBUGFS_STATS_DEL(dot11ACKFailureCount);
 	DEBUGFS_STATS_DEL(dot11RTSFailureCount);
--- everything.orig/net/mac80211/debugfs_sta.c	2008-04-30 16:55:32.000000000 +0200
+++ everything/net/mac80211/debugfs_sta.c	2008-04-30 16:55:35.000000000 +0200
@@ -124,36 +124,6 @@ static ssize_t sta_last_seq_ctrl_read(st
 }
 STA_OPS(last_seq_ctrl);
 
-#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
-static ssize_t sta_wme_rx_queue_read(struct file *file, char __user *userbuf,
-				     size_t count, loff_t *ppos)
-{
-	char buf[15*NUM_RX_DATA_QUEUES], *p = buf;
-	int i;
-	struct sta_info *sta = file->private_data;
-	for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
-		p += scnprintf(p, sizeof(buf)+buf-p, "%u ",
-			       sta->wme_rx_queue[i]);
-	p += scnprintf(p, sizeof(buf)+buf-p, "\n");
-	return simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
-}
-STA_OPS(wme_rx_queue);
-
-static ssize_t sta_wme_tx_queue_read(struct file *file, char __user *userbuf,
-				     size_t count, loff_t *ppos)
-{
-	char buf[15*NUM_TX_DATA_QUEUES], *p = buf;
-	int i;
-	struct sta_info *sta = file->private_data;
-	for (i = 0; i < NUM_TX_DATA_QUEUES; i++)
-		p += scnprintf(p, sizeof(buf)+buf-p, "%u ",
-			       sta->wme_tx_queue[i]);
-	p += scnprintf(p, sizeof(buf)+buf-p, "\n");
-	return simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
-}
-STA_OPS(wme_tx_queue);
-#endif
-
 static ssize_t sta_agg_status_read(struct file *file, char __user *userbuf,
 					size_t count, loff_t *ppos)
 {
@@ -294,10 +264,6 @@ void ieee80211_sta_debugfs_add(struct st
 	DEBUGFS_ADD(num_ps_buf_frames);
 	DEBUGFS_ADD(inactive_ms);
 	DEBUGFS_ADD(last_seq_ctrl);
-#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
-	DEBUGFS_ADD(wme_rx_queue);
-	DEBUGFS_ADD(wme_tx_queue);
-#endif
 	DEBUGFS_ADD(agg_status);
 }
 
@@ -307,10 +273,6 @@ void ieee80211_sta_debugfs_remove(struct
 	DEBUGFS_DEL(num_ps_buf_frames);
 	DEBUGFS_DEL(inactive_ms);
 	DEBUGFS_DEL(last_seq_ctrl);
-#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
-	DEBUGFS_DEL(wme_rx_queue);
-	DEBUGFS_DEL(wme_tx_queue);
-#endif
 	DEBUGFS_DEL(agg_status);
 
 	debugfs_remove(sta->debugfs.dir);
--- everything.orig/net/mac80211/ieee80211_i.h	2008-04-30 16:55:32.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-04-30 18:48:30.000000000 +0200
@@ -611,8 +611,8 @@ struct ieee80211_local {
 	struct sta_info *sta_hash[STA_HASH_SIZE];
 	struct timer_list sta_cleanup;
 
-	unsigned long state[NUM_TX_DATA_QUEUES_AMPDU];
-	struct ieee80211_tx_stored_packet pending_packet[NUM_TX_DATA_QUEUES_AMPDU];
+	unsigned long state[IEEE80211_MAX_AMPDU_QUEUES + IEEE80211_MAX_AMPDU_QUEUES];
+	struct ieee80211_tx_stored_packet pending_packet[IEEE80211_MAX_AMPDU_QUEUES + IEEE80211_MAX_AMPDU_QUEUES];
 	struct tasklet_struct tx_pending_tasklet;
 
 	/* number of interfaces with corresponding IFF_ flags */
@@ -706,8 +706,6 @@ struct ieee80211_local {
 	unsigned int rx_expand_skb_head2;
 	unsigned int rx_handlers_fragments;
 	unsigned int tx_status_drop;
-	unsigned int wme_rx_queue[NUM_RX_DATA_QUEUES];
-	unsigned int wme_tx_queue[NUM_RX_DATA_QUEUES];
 #define I802_DEBUG_INC(c) (c)++
 #else /* CONFIG_MAC80211_DEBUG_COUNTERS */
 #define I802_DEBUG_INC(c) do { } while (0)
@@ -765,8 +763,6 @@ struct ieee80211_local {
 			struct dentry *rx_expand_skb_head2;
 			struct dentry *rx_handlers_fragments;
 			struct dentry *tx_status_drop;
-			struct dentry *wme_tx_queue;
-			struct dentry *wme_rx_queue;
 #endif
 			struct dentry *dot11ACKFailureCount;
 			struct dentry *dot11RTSFailureCount;
--- everything.orig/net/mac80211/rx.c	2008-04-30 16:55:32.000000000 +0200
+++ everything/net/mac80211/rx.c	2008-04-30 16:55:35.000000000 +0200
@@ -275,11 +275,6 @@ static void ieee80211_parse_qos(struct i
 		}
 	}
 
-	I802_DEBUG_INC(rx->local->wme_rx_queue[tid]);
-	/* only a debug counter, sta might not be assigned properly yet */
-	if (rx->sta)
-		I802_DEBUG_INC(rx->sta->wme_rx_queue[tid]);
-
 	rx->queue = tid;
 	/* Set skb->priority to 1d tag if highest order bit of TID is not set.
 	 * For now, set skb->priority to 0 for other cases. */
--- everything.orig/drivers/net/wireless/b43/main.c	2008-04-30 16:55:29.000000000 +0200
+++ everything/drivers/net/wireless/b43/main.c	2008-04-30 18:48:31.000000000 +0200
@@ -2995,8 +2995,7 @@ static void b43_qos_update_work(struct w
 	mutex_unlock(&wl->mutex);
 }
 
-static int b43_op_conf_tx(struct ieee80211_hw *hw,
-			  int _queue,
+static int b43_op_conf_tx(struct ieee80211_hw *hw, u16 _queue,
 			  const struct ieee80211_tx_queue_params *params)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
--- everything.orig/drivers/net/wireless/b43legacy/main.c	2008-04-30 16:54:00.000000000 +0200
+++ everything/drivers/net/wireless/b43legacy/main.c	2008-04-30 16:55:35.000000000 +0200
@@ -2383,8 +2383,7 @@ out:
 	return NETDEV_TX_OK;
 }
 
-static int b43legacy_op_conf_tx(struct ieee80211_hw *hw,
-				int queue,
+static int b43legacy_op_conf_tx(struct ieee80211_hw *hw, u16 queue,
 				const struct ieee80211_tx_queue_params *params)
 {
 	return 0;
--- everything.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-04-30 16:55:34.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-04-30 18:48:32.000000000 +0200
@@ -7157,7 +7157,7 @@ static int iwl3945_mac_set_key(struct ie
 	return rc;
 }
 
-static int iwl3945_mac_conf_tx(struct ieee80211_hw *hw, int queue,
+static int iwl3945_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 			   const struct ieee80211_tx_queue_params *params)
 {
 	struct iwl3945_priv *priv = hw->priv;
--- everything.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-04-30 16:55:34.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl4965-base.c	2008-04-30 18:48:32.000000000 +0200
@@ -6891,7 +6891,7 @@ static int iwl4965_mac_set_key(struct ie
 	return ret;
 }
 
-static int iwl4965_mac_conf_tx(struct ieee80211_hw *hw, int queue,
+static int iwl4965_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 			   const struct ieee80211_tx_queue_params *params)
 {
 	struct iwl_priv *priv = hw->priv;
--- everything.orig/drivers/net/wireless/p54/p54common.c	2008-04-30 16:55:34.000000000 +0200
+++ everything/drivers/net/wireless/p54/p54common.c	2008-04-30 18:48:31.000000000 +0200
@@ -935,7 +935,7 @@ static void p54_configure_filter(struct 
 	}
 }
 
-static int p54_conf_tx(struct ieee80211_hw *dev, int queue,
+static int p54_conf_tx(struct ieee80211_hw *dev, u16 queue,
 		       const struct ieee80211_tx_queue_params *params)
 {
 	struct p54_common *priv = dev->priv;
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00.h	2008-04-30 16:55:34.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2x00.h	2008-04-30 16:55:35.000000000 +0200
@@ -997,7 +997,7 @@ void rt2x00mac_bss_info_changed(struct i
 				struct ieee80211_vif *vif,
 				struct ieee80211_bss_conf *bss_conf,
 				u32 changes);
-int rt2x00mac_conf_tx(struct ieee80211_hw *hw, int queue,
+int rt2x00mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 		      const struct ieee80211_tx_queue_params *params);
 
 /*
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00mac.c	2008-04-30 16:55:34.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2x00mac.c	2008-04-30 18:48:26.000000000 +0200
@@ -517,7 +517,7 @@ void rt2x00mac_bss_info_changed(struct i
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_bss_info_changed);
 
-int rt2x00mac_conf_tx(struct ieee80211_hw *hw, int queue_idx,
+int rt2x00mac_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
 		      const struct ieee80211_tx_queue_params *params)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00queue.h	2008-04-30 16:55:33.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2x00queue.h	2008-04-30 18:48:26.000000000 +0200
@@ -86,12 +86,9 @@ enum data_queue_qid {
 static inline enum data_queue_qid mac80211_queue_to_qid(unsigned int queue)
 {
 	/* Regular TX queues are mapped directly */
-	if (queue < NUM_TX_DATA_QUEUES)
+	if (queue < 4)
 		return queue;
-	else if (queue == IEEE80211_TX_QUEUE_BEACON)
-		return QID_BEACON;
-	else if (queue == IEEE80211_TX_QUEUE_AFTER_BEACON)
-		return QID_ATIM;
+	WARN_ON(1);
 	return QID_OTHER;
 }
 
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-core.c	2008-04-30 18:49:09.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-core.c	2008-04-30 18:49:24.000000000 +0200
@@ -237,7 +237,7 @@ static void iwlcore_init_hw(struct iwl_p
 	hw->queues = 4;
 #ifdef CONFIG_IWL4965_HT
 	/* Enhanced value; more queues, to support 11n aggregation */
-	hw->queues = 16;
+	hw->ampdu_queues = 12;
 #endif /* CONFIG_IWL4965_HT */
 }
 


