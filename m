Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:33897 "EHLO
	mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966314AbcCPKP4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2016 06:15:56 -0400
Received: by mail-lf0-f41.google.com with SMTP id e138so14825389lfe.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2016 03:15:54 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, johannes@sipsolutions.net,
	netdev@vger.kernel.org, dave.taht@gmail.com,
	emmanuel.grumbach@intel.com, nbd@openwrt.org,
	Tim Shepard <shep@alum.mit.edu>,
	make-wifi-fast@lists.bufferbloat.net, codel@lists.bufferbloat.net,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFCv2 3/3] ath10k: use ieee80211_tx_schedule()
Date: Wed, 16 Mar 2016 11:17:58 +0100
Message-Id: <1458123478-1795-4-git-send-email-michal.kazior@tieto.com> (sfid-20160316_111619_946156_ED0621E2)
In-Reply-To: <1458123478-1795-1-git-send-email-michal.kazior@tieto.com>
References: <1458123478-1795-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wake_tx_queue() scheduling for non-pull-push
(or threshold based pull-push) wasn't really smart
nor fair.

Instead use the new mac80211 Tx scheduling helper
which is part of the fq-codel-in-mac80211 proof of
concept.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c |   2 -
 drivers/net/wireless/ath/ath10k/core.h |   3 -
 drivers/net/wireless/ath/ath10k/mac.c  | 100 ++++++++++++++++-----------------
 3 files changed, 50 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 2389c0713c13..1848e0b6206a 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2049,9 +2049,7 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 
 	mutex_init(&ar->conf_mutex);
 	spin_lock_init(&ar->data_lock);
-	spin_lock_init(&ar->txqs_lock);
 
-	INIT_LIST_HEAD(&ar->txqs);
 	INIT_LIST_HEAD(&ar->peers);
 	init_waitqueue_head(&ar->peer_mapping_wq);
 	init_waitqueue_head(&ar->htt.empty_tx_wq);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 3f76669d44cf..1f94af046f79 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -801,10 +801,7 @@ struct ath10k {
 
 	/* protects shared structure data */
 	spinlock_t data_lock;
-	/* protects: ar->txqs, artxq->list */
-	spinlock_t txqs_lock;
 
-	struct list_head txqs;
 	struct list_head arvifs;
 	struct list_head peers;
 	struct ath10k_peer *peer_map[ATH10K_MAX_NUM_PEER_IDS];
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index addef9179dbe..5b8becb30b62 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3624,17 +3624,14 @@ void ath10k_mgmt_over_wmi_tx_work(struct work_struct *work)
 
 static void ath10k_mac_txq_init(struct ieee80211_txq *txq)
 {
-	struct ath10k_txq *artxq = (void *)txq->drv_priv;
-
 	if (!txq)
 		return;
 
-	INIT_LIST_HEAD(&artxq->list);
+	/* It's useful to keep this even though it doesn't do anything now */
 }
 
 static void ath10k_mac_txq_unref(struct ath10k *ar, struct ieee80211_txq *txq)
 {
-	struct ath10k_txq *artxq = (void *)txq->drv_priv;
 	struct ath10k_skb_cb *cb;
 	struct sk_buff *msdu;
 	int msdu_id;
@@ -3642,11 +3639,6 @@ static void ath10k_mac_txq_unref(struct ath10k *ar, struct ieee80211_txq *txq)
 	if (!txq)
 		return;
 
-	spin_lock_bh(&ar->txqs_lock);
-	if (!list_empty(&artxq->list))
-		list_del_init(&artxq->list);
-	spin_unlock_bh(&ar->txqs_lock);
-
 	spin_lock_bh(&ar->htt.tx_lock);
 	idr_for_each_entry(&ar->htt.pending_tx, msdu, msdu_id) {
 		cb = ATH10K_SKB_CB(msdu);
@@ -3725,7 +3717,7 @@ int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
 		ath10k_htt_tx_dec_pending(htt, is_mgmt);
 		spin_unlock_bh(&ar->htt.tx_lock);
 
-		return -ENOENT;
+		return 0;
 	}
 
 	ath10k_mac_tx_h_fill_cb(ar, vif, txq, skb);
@@ -3752,44 +3744,59 @@ int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
 	return skb_len;
 }
 
+#define MIN_TX_SLOTS 42
+
+static int ath10k_mac_tx_wake(struct ieee80211_hw *hw,
+			      struct ieee80211_txq *txq,
+			      int budget)
+{
+	struct ath10k *ar = hw->priv;
+	int sent = 0;
+	int ret;
+	int slots;
+
+	if (!ath10k_mac_tx_can_push(hw, txq))
+		return 0;
+
+	/* This gives more opportunity to form longer bursts when there's a lot
+	 * of stations active
+	 */
+	slots = ar->htt.max_num_pending_tx - ar->htt.num_pending_tx;
+	if (slots < MIN_TX_SLOTS)
+		return -1;
+
+	while (budget > 0) {
+		ret = ath10k_mac_tx_push_txq(hw, txq);
+		if (ret <= 0)
+			break;
+
+		sent++;
+		budget -= ret;
+	}
+
+	if (ret >= 0)
+		return sent;
+	else
+		return -1;
+}
+
 void ath10k_mac_tx_push_pending(struct ath10k *ar)
 {
 	struct ieee80211_hw *hw = ar->hw;
-	struct ieee80211_txq *txq;
-	struct ath10k_txq *artxq;
-	struct ath10k_txq *last;
 	int ret;
-	int max;
 
-	spin_lock_bh(&ar->txqs_lock);
-	rcu_read_lock();
-
-	last = list_last_entry(&ar->txqs, struct ath10k_txq, list);
-	while (!list_empty(&ar->txqs)) {
-		artxq = list_first_entry(&ar->txqs, struct ath10k_txq, list);
-		txq = container_of((void *)artxq, struct ieee80211_txq,
-				   drv_priv);
-
-		/* Prevent aggressive sta/tid taking over tx queue */
-		max = 16;
-		while (max--) {
-			ret = ath10k_mac_tx_push_txq(hw, txq);
-			if (ret < 0)
-				break;
-		}
-
-		list_del_init(&artxq->list);
-		ath10k_htt_tx_txq_update(hw, txq);
-
-		if (artxq == last || (ret < 0 && ret != -ENOENT)) {
-			if (ret != -ENOENT)
-				list_add_tail(&artxq->list, &ar->txqs);
-			break;
-		}
+	ieee80211_recalc_fq_period(hw);
+
+	ret = ieee80211_tx_schedule(hw, ath10k_mac_tx_wake);
+	switch (ret) {
+	default:
+		ath10k_warn(ar, "unexpected tx schedul retval: %d\n",
+			    ret);
+		/* pass through */
+	case -EBUSY:
+	case -ENOENT:
+		break;
 	}
-
-	rcu_read_unlock();
-	spin_unlock_bh(&ar->txqs_lock);
 }
 
 /************/
@@ -4013,16 +4020,9 @@ static void ath10k_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
 					struct ieee80211_txq *txq)
 {
 	struct ath10k *ar = hw->priv;
-	struct ath10k_txq *artxq = (void *)txq->drv_priv;
-
-	if (ath10k_mac_tx_can_push(hw, txq)) {
-		spin_lock_bh(&ar->txqs_lock);
-		if (list_empty(&artxq->list))
-			list_add_tail(&artxq->list, &ar->txqs);
-		spin_unlock_bh(&ar->txqs_lock);
 
+	if (ath10k_mac_tx_can_push(hw, txq))
 		tasklet_schedule(&ar->htt.txrx_compl_task);
-	}
 
 	ath10k_htt_tx_txq_update(hw, txq);
 }
-- 
2.1.4

