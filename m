Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:33255 "EHLO
	mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbcESIgE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2016 04:36:04 -0400
Received: by mail-lf0-f43.google.com with SMTP id y84so31747513lfc.0
        for <linux-wireless@vger.kernel.org>; Thu, 19 May 2016 01:36:02 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, dave.taht@gmail.com,
	make-wifi-fast@lists.bufferbloat.net, apenwarr@gmail.com,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv5 1/5] mac80211: skip netdev queue control with software queuing
Date: Thu, 19 May 2016 10:37:48 +0200
Message-Id: <1463647072-16201-2-git-send-email-michal.kazior@tieto.com> (sfid-20160519_103610_925666_86766CBD)
In-Reply-To: <1463647072-16201-1-git-send-email-michal.kazior@tieto.com>
References: <1462446039-1070-1-git-send-email-michal.kazior@tieto.com>
 <1463647072-16201-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Qdiscs are designed with no regard to 802.11
aggregation requirements and hand out
packet-by-packet with no guarantee they are
destined to the same tid. This does more bad than
good no matter how fairly a given qdisc may behave
on an ethernet interface.

Software queuing used per-AC netdev subqueue
congestion control whenever a global AC limit was
hit. This meant in practice a single station or
tid queue could starve others rather easily. This
could resonate with qdiscs in a bad way or could
just end up with poor aggregation performance.
Increasing the AC limit would increase induced
latency which is also bad.

Disabling qdiscs by default and performing
taildrop instead of netdev subqueue congestion
control on the other hand makes it possible for
tid queues to fill up "in the meantime" while
preventing stations starving each other.

This increases aggregation opportunities and
should allow software queuing based drivers
achieve better performance by utilizing airtime
more efficiently with big aggregates.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v5:
     * fix null-deref for non-txq drivers
     * fix compilation after rebase
     * fix powersave on ath9k w/ wake_tx_queue
       [reported by Tim]
    
    v4:
     * make queue depth limit per interface instead of
       per radio [Johannes]

 include/net/mac80211.h     |  4 ---
 net/mac80211/ieee80211_i.h |  2 +-
 net/mac80211/iface.c       | 18 +++++++++--
 net/mac80211/main.c        |  3 --
 net/mac80211/sta_info.c    |  2 +-
 net/mac80211/tx.c          | 77 ++++++++++++++++++++++++++--------------------
 net/mac80211/util.c        | 11 ++++---
 7 files changed, 67 insertions(+), 50 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index be30b0549b88..a8683aec6dbe 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2147,9 +2147,6 @@ enum ieee80211_hw_flags {
  * @n_cipher_schemes: a size of an array of cipher schemes definitions.
  * @cipher_schemes: a pointer to an array of cipher scheme definitions
  *	supported by HW.
- *
- * @txq_ac_max_pending: maximum number of frames per AC pending in all txq
- *	entries for a vif.
  */
 struct ieee80211_hw {
 	struct ieee80211_conf conf;
@@ -2180,7 +2177,6 @@ struct ieee80211_hw {
 	u8 uapsd_max_sp_len;
 	u8 n_cipher_schemes;
 	const struct ieee80211_cipher_scheme *cipher_schemes;
-	int txq_ac_max_pending;
 };
 
 static inline bool _ieee80211_hw_check(struct ieee80211_hw *hw,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9438c9406687..634603320374 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -856,7 +856,7 @@ struct ieee80211_sub_if_data {
 	bool control_port_no_encrypt;
 	int encrypt_headroom;
 
-	atomic_t txqs_len[IEEE80211_NUM_ACS];
+	atomic_t num_tx_queued;
 	struct ieee80211_tx_queue_params tx_conf[IEEE80211_NUM_ACS];
 	struct mac80211_qos_map __rcu *qos_map;
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index c59af3eb9fa4..609c5174d798 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -976,13 +976,13 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 
 	if (sdata->vif.txq) {
 		struct txq_info *txqi = to_txq_info(sdata->vif.txq);
+		int n = skb_queue_len(&txqi->queue);
 
 		spin_lock_bh(&txqi->queue.lock);
 		ieee80211_purge_tx_queue(&local->hw, &txqi->queue);
+		atomic_sub(n, &sdata->num_tx_queued);
 		txqi->byte_cnt = 0;
 		spin_unlock_bh(&txqi->queue.lock);
-
-		atomic_set(&sdata->txqs_len[txqi->txq.ac], 0);
 	}
 
 	if (local->open_count == 0)
@@ -1198,6 +1198,12 @@ static void ieee80211_if_setup(struct net_device *dev)
 	dev->destructor = ieee80211_if_free;
 }
 
+static void ieee80211_if_setup_no_queue(struct net_device *dev)
+{
+	ieee80211_if_setup(dev);
+	dev->priv_flags |= IFF_NO_QUEUE;
+}
+
 static void ieee80211_iface_work(struct work_struct *work)
 {
 	struct ieee80211_sub_if_data *sdata =
@@ -1707,6 +1713,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 	struct net_device *ndev = NULL;
 	struct ieee80211_sub_if_data *sdata = NULL;
 	struct txq_info *txqi;
+	void (*if_setup)(struct net_device *dev);
 	int ret, i;
 	int txqs = 1;
 
@@ -1734,12 +1741,17 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 			txq_size += sizeof(struct txq_info) +
 				    local->hw.txq_data_size;
 
+		if (local->ops->wake_tx_queue)
+			if_setup = ieee80211_if_setup_no_queue;
+		else
+			if_setup = ieee80211_if_setup;
+
 		if (local->hw.queues >= IEEE80211_NUM_ACS)
 			txqs = IEEE80211_NUM_ACS;
 
 		ndev = alloc_netdev_mqs(size + txq_size,
 					name, name_assign_type,
-					ieee80211_if_setup, txqs, 1);
+					if_setup, txqs, 1);
 		if (!ndev)
 			return -ENOMEM;
 		dev_net_set(ndev, wiphy_net(local->hw.wiphy));
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 7ee91d6151d1..160ac6b8b9a1 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1055,9 +1055,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 	local->dynamic_ps_forced_timeout = -1;
 
-	if (!local->hw.txq_ac_max_pending)
-		local->hw.txq_ac_max_pending = 64;
-
 	result = ieee80211_wep_init(local);
 	if (result < 0)
 		wiphy_debug(local->hw.wiphy, "Failed to initialize wep: %d\n",
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 5ccfdbd406bd..177cc6cd6416 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -116,7 +116,7 @@ static void __cleanup_single_sta(struct sta_info *sta)
 			int n = skb_queue_len(&txqi->queue);
 
 			ieee80211_purge_tx_queue(&local->hw, &txqi->queue);
-			atomic_sub(n, &sdata->txqs_len[txqi->txq.ac]);
+			atomic_sub(n, &sdata->num_tx_queued);
 			txqi->byte_cnt = 0;
 		}
 	}
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 203044379ce0..3e77da195ce8 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1236,27 +1236,21 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 	return TX_CONTINUE;
 }
 
-static void ieee80211_drv_tx(struct ieee80211_local *local,
-			     struct ieee80211_vif *vif,
-			     struct ieee80211_sta *pubsta,
-			     struct sk_buff *skb)
+static struct txq_info *ieee80211_get_txq(struct ieee80211_local *local,
+					  struct ieee80211_vif *vif,
+					  struct ieee80211_sta *pubsta,
+					  struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_tx_control control = {
-		.sta = pubsta,
-	};
 	struct ieee80211_txq *txq = NULL;
-	struct txq_info *txqi;
-	u8 ac;
 
 	if ((info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) ||
 	    (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE))
-		goto tx_normal;
+		return NULL;
 
 	if (!ieee80211_is_data(hdr->frame_control))
-		goto tx_normal;
+		return NULL;
 
 	if (pubsta) {
 		u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
@@ -1267,25 +1261,28 @@ static void ieee80211_drv_tx(struct ieee80211_local *local,
 	}
 
 	if (!txq)
-		goto tx_normal;
+		return NULL;
 
-	ac = txq->ac;
-	txqi = to_txq_info(txq);
-	atomic_inc(&sdata->txqs_len[ac]);
-	if (atomic_read(&sdata->txqs_len[ac]) >= local->hw.txq_ac_max_pending)
-		netif_stop_subqueue(sdata->dev, ac);
+	return to_txq_info(txq);
+}
 
-	spin_lock_bh(&txqi->queue.lock);
+static void ieee80211_txq_enqueue(struct ieee80211_local *local,
+				  struct txq_info *txqi,
+				  struct sk_buff *skb)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(txqi->txq.vif);
+
+	lockdep_assert_held(&txqi->queue.lock);
+
+	if (atomic_read(&sdata->num_tx_queued) >= TOTAL_MAX_TX_BUFFER ||
+	    txqi->queue.qlen >= STA_MAX_TX_BUFFER) {
+		ieee80211_free_txskb(&local->hw, skb);
+		return;
+	}
+
+	atomic_inc(&sdata->num_tx_queued);
 	txqi->byte_cnt += skb->len;
 	__skb_queue_tail(&txqi->queue, skb);
-	spin_unlock_bh(&txqi->queue.lock);
-
-	drv_wake_tx_queue(local, txqi);
-
-	return;
-
-tx_normal:
-	drv_tx(local, &control, skb);
 }
 
 struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
@@ -1296,7 +1293,6 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	struct txq_info *txqi = container_of(txq, struct txq_info, txq);
 	struct ieee80211_hdr *hdr;
 	struct sk_buff *skb = NULL;
-	u8 ac = txq->ac;
 
 	spin_lock_bh(&txqi->queue.lock);
 
@@ -1307,12 +1303,9 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	if (!skb)
 		goto out;
 
+	atomic_dec(&sdata->num_tx_queued);
 	txqi->byte_cnt -= skb->len;
 
-	atomic_dec(&sdata->txqs_len[ac]);
-	if (__netif_subqueue_stopped(sdata->dev, ac))
-		ieee80211_propagate_queue_wake(local, sdata->vif.hw_queue[ac]);
-
 	hdr = (struct ieee80211_hdr *)skb->data;
 	if (txq->sta && ieee80211_is_data_qos(hdr->frame_control)) {
 		struct sta_info *sta = container_of(txq->sta, struct sta_info,
@@ -1343,7 +1336,9 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
 			       struct sk_buff_head *skbs,
 			       bool txpending)
 {
+	struct ieee80211_tx_control control = {};
 	struct sk_buff *skb, *tmp;
+	struct txq_info *txqi;
 	unsigned long flags;
 
 	skb_queue_walk_safe(skbs, skb, tmp) {
@@ -1358,6 +1353,21 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
 		}
 #endif
 
+		txqi = ieee80211_get_txq(local, vif, sta, skb);
+		if (txqi) {
+			info->control.vif = vif;
+
+			__skb_unlink(skb, skbs);
+
+			spin_lock_bh(&txqi->queue.lock);
+			ieee80211_txq_enqueue(local, txqi, skb);
+			spin_unlock_bh(&txqi->queue.lock);
+
+			drv_wake_tx_queue(local, txqi);
+
+			continue;
+		}
+
 		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 		if (local->queue_stop_reasons[q] ||
 		    (!txpending && !skb_queue_empty(&local->pending[q]))) {
@@ -1400,9 +1410,10 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
 		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 
 		info->control.vif = vif;
+		control.sta = sta;
 
 		__skb_unlink(skb, skbs);
-		ieee80211_drv_tx(local, vif, sta, skb);
+		drv_tx(local, &control, skb);
 	}
 
 	return true;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 905003f75c4d..0db46442bdcf 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -244,6 +244,9 @@ void ieee80211_propagate_queue_wake(struct ieee80211_local *local, int queue)
 	struct ieee80211_sub_if_data *sdata;
 	int n_acs = IEEE80211_NUM_ACS;
 
+	if (local->ops->wake_tx_queue)
+		return;
+
 	if (local->hw.queues < IEEE80211_NUM_ACS)
 		n_acs = 1;
 
@@ -260,11 +263,6 @@ void ieee80211_propagate_queue_wake(struct ieee80211_local *local, int queue)
 		for (ac = 0; ac < n_acs; ac++) {
 			int ac_queue = sdata->vif.hw_queue[ac];
 
-			if (local->ops->wake_tx_queue &&
-			    (atomic_read(&sdata->txqs_len[ac]) >
-			     local->hw.txq_ac_max_pending))
-				continue;
-
 			if (ac_queue == queue ||
 			    (sdata->vif.cab_queue == queue &&
 			     local->queue_stop_reasons[ac_queue] == 0 &&
@@ -352,6 +350,9 @@ static void __ieee80211_stop_queue(struct ieee80211_hw *hw, int queue,
 	if (__test_and_set_bit(reason, &local->queue_stop_reasons[queue]))
 		return;
 
+	if (local->ops->wake_tx_queue)
+		return;
+
 	if (local->hw.queues < IEEE80211_NUM_ACS)
 		n_acs = 1;
 
-- 
2.1.4

