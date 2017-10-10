Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:43657 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932193AbdJJOCt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Oct 2017 10:02:49 -0400
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [RFC 3/3] ath10k: Move to mac80211 TXQ scheduling API
Date: Tue, 10 Oct 2017 16:02:08 +0200
Message-Id: <20171010140208.1515-3-toke@toke.dk> (sfid-20171010_160341_868397_D37D8513)
In-Reply-To: <20171010140208.1515-1-toke@toke.dk>
References: <20171010140208.1515-1-toke@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes TXQ scheduling from ath10k and changes it to use the mac80211 TXQ
scheduling API introduced in the previous patch.

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 drivers/net/wireless/ath/ath10k/core.c |  2 --
 drivers/net/wireless/ath/ath10k/core.h |  3 ---
 drivers/net/wireless/ath/ath10k/mac.c  | 46 +++++++---------------------------
 3 files changed, 9 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index a4f635820f35..759df3297d48 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2561,9 +2561,7 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 
 	mutex_init(&ar->conf_mutex);
 	spin_lock_init(&ar->data_lock);
-	spin_lock_init(&ar->txqs_lock);
 
-	INIT_LIST_HEAD(&ar->txqs);
 	INIT_LIST_HEAD(&ar->peers);
 	init_waitqueue_head(&ar->peer_mapping_wq);
 	init_waitqueue_head(&ar->htt.empty_tx_wq);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 949ebb3e967b..e7fc241addf6 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -892,10 +892,7 @@ struct ath10k {
 
 	/* protects shared structure data */
 	spinlock_t data_lock;
-	/* protects: ar->txqs, artxq->list */
-	spinlock_t txqs_lock;
 
-	struct list_head txqs;
 	struct list_head arvifs;
 	struct list_head peers;
 	struct ath10k_peer *peer_map[ATH10K_MAX_NUM_PEER_IDS];
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 5683f1a5330e..086d7602fc4a 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3825,7 +3825,6 @@ static void ath10k_mac_txq_init(struct ieee80211_txq *txq)
 
 static void ath10k_mac_txq_unref(struct ath10k *ar, struct ieee80211_txq *txq)
 {
-	struct ath10k_txq *artxq;
 	struct ath10k_skb_cb *cb;
 	struct sk_buff *msdu;
 	int msdu_id;
@@ -3833,12 +3832,6 @@ static void ath10k_mac_txq_unref(struct ath10k *ar, struct ieee80211_txq *txq)
 	if (!txq)
 		return;
 
-	artxq = (void *)txq->drv_priv;
-	spin_lock_bh(&ar->txqs_lock);
-	if (!list_empty(&artxq->list))
-		list_del_init(&artxq->list);
-	spin_unlock_bh(&ar->txqs_lock);
-
 	spin_lock_bh(&ar->htt.tx_lock);
 	idr_for_each_entry(&ar->htt.pending_tx, msdu, msdu_id) {
 		cb = ATH10K_SKB_CB(msdu);
@@ -3969,22 +3962,15 @@ void ath10k_mac_tx_push_pending(struct ath10k *ar)
 {
 	struct ieee80211_hw *hw = ar->hw;
 	struct ieee80211_txq *txq;
-	struct ath10k_txq *artxq;
-	struct ath10k_txq *last;
 	int ret;
 	int max;
 
 	if (ar->htt.num_pending_tx >= (ar->htt.max_num_pending_tx / 2))
 		return;
 
-	spin_lock_bh(&ar->txqs_lock);
 	rcu_read_lock();
 
-	last = list_last_entry(&ar->txqs, struct ath10k_txq, list);
-	while (!list_empty(&ar->txqs)) {
-		artxq = list_first_entry(&ar->txqs, struct ath10k_txq, list);
-		txq = container_of((void *)artxq, struct ieee80211_txq,
-				   drv_priv);
+	while ((txq = ieee80211_next_txq(hw))) {
 
 		/* Prevent aggressive sta/tid taking over tx queue */
 		max = 16;
@@ -3995,18 +3981,16 @@ void ath10k_mac_tx_push_pending(struct ath10k *ar)
 				break;
 		}
 
-		list_del_init(&artxq->list);
 		if (ret != -ENOENT)
-			list_add_tail(&artxq->list, &ar->txqs);
+			ieee80211_schedule_txq(hw, txq);
 
 		ath10k_htt_tx_txq_update(hw, txq);
 
-		if (artxq == last || (ret < 0 && ret != -ENOENT))
+		if (ret < 0 && ret != -ENOENT)
 			break;
 	}
 
 	rcu_read_unlock();
-	spin_unlock_bh(&ar->txqs_lock);
 }
 
 /************/
@@ -4240,34 +4224,22 @@ static void ath10k_mac_op_tx(struct ieee80211_hw *hw,
 	}
 }
 
-static void ath10k_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
-					struct ieee80211_txq *txq)
+static void ath10k_mac_op_wake_tx_queue(struct ieee80211_hw *hw)
 {
-	struct ath10k *ar = hw->priv;
-	struct ath10k_txq *artxq = (void *)txq->drv_priv;
-	struct ieee80211_txq *f_txq;
-	struct ath10k_txq *f_artxq;
+	struct ieee80211_txq *txq;
 	int ret = 0;
 	int max = 16;
 
-	spin_lock_bh(&ar->txqs_lock);
-	if (list_empty(&artxq->list))
-		list_add_tail(&artxq->list, &ar->txqs);
-
-	f_artxq = list_first_entry(&ar->txqs, struct ath10k_txq, list);
-	f_txq = container_of((void *)f_artxq, struct ieee80211_txq, drv_priv);
-	list_del_init(&f_artxq->list);
+	txq = ieee80211_next_txq(hw);
 
-	while (ath10k_mac_tx_can_push(hw, f_txq) && max--) {
-		ret = ath10k_mac_tx_push_txq(hw, f_txq);
+	while (ath10k_mac_tx_can_push(hw, txq) && max--) {
+		ret = ath10k_mac_tx_push_txq(hw, txq);
 		if (ret)
 			break;
 	}
 	if (ret != -ENOENT)
-		list_add_tail(&f_artxq->list, &ar->txqs);
-	spin_unlock_bh(&ar->txqs_lock);
+		ieee80211_schedule_txq(hw, txq);
 
-	ath10k_htt_tx_txq_update(hw, f_txq);
 	ath10k_htt_tx_txq_update(hw, txq);
 }
 
-- 
2.14.2
