Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:32805 "EHLO
	mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbcCAKcT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 05:32:19 -0500
Received: by mail-lf0-f42.google.com with SMTP id v124so17123463lff.0
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2016 02:32:18 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 07/11] ath10k: implement wake_tx_queue
Date: Tue,  1 Mar 2016 11:32:52 +0100
Message-Id: <1456828376-2795-8-git-send-email-michal.kazior@tieto.com> (sfid-20160301_113226_294458_74BA94B5)
In-Reply-To: <1456828376-2795-1-git-send-email-michal.kazior@tieto.com>
References: <1453384006-31907-1-git-send-email-michal.kazior@tieto.com>
 <1456828376-2795-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This implements very basic support for software
queueing. It also contains some knobs that will be
patched later.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v2:
     - squashed with `ath10k: add txq placeholder`
     - squashed with `ath10k: implement flushing of pending frames in txqs`
     - reworked pending logic

 drivers/net/wireless/ath/ath10k/core.c   |   2 +
 drivers/net/wireless/ath/ath10k/core.h   |   7 ++
 drivers/net/wireless/ath/ath10k/htt_rx.c |   3 +
 drivers/net/wireless/ath/ath10k/mac.c    | 144 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/mac.h    |   1 +
 5 files changed, 157 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 4d3176492ae7..6d02266ca615 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2043,7 +2043,9 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 
 	mutex_init(&ar->conf_mutex);
 	spin_lock_init(&ar->data_lock);
+	spin_lock_init(&ar->txqs_lock);
 
+	INIT_LIST_HEAD(&ar->txqs);
 	INIT_LIST_HEAD(&ar->peers);
 	init_waitqueue_head(&ar->peer_mapping_wq);
 	init_waitqueue_head(&ar->htt.empty_tx_wq);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 5f447444fe97..7df35628ca35 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -308,6 +308,10 @@ struct ath10k_peer {
 	struct ieee80211_key_conf *keys[WMI_MAX_KEY_INDEX + 1];
 };
 
+struct ath10k_txq {
+	struct list_head list;
+};
+
 struct ath10k_sta {
 	struct ath10k_vif *arvif;
 
@@ -791,7 +795,10 @@ struct ath10k {
 
 	/* protects shared structure data */
 	spinlock_t data_lock;
+	/* protects: ar->txqs, artxq->list */
+	spinlock_t txqs_lock;
 
+	struct list_head txqs;
 	struct list_head arvifs;
 	struct list_head peers;
 	struct ath10k_peer *peer_map[ATH10K_MAX_NUM_PEER_IDS];
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index be7dc88b3316..6e3d95c95568 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2244,6 +2244,7 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		}
 
 		ath10k_txrx_tx_unref(htt, &tx_done);
+		ath10k_mac_tx_push_pending(ar);
 		break;
 	}
 	case HTT_T2H_MSG_TYPE_TX_COMPL_IND:
@@ -2370,6 +2371,8 @@ static void ath10k_htt_txrx_compl_task(unsigned long ptr)
 		dev_kfree_skb_any(skb);
 	}
 
+	ath10k_mac_tx_push_pending(ar);
+
 	spin_lock_bh(&htt->rx_ring.lock);
 	while ((skb = __skb_dequeue(&htt->rx_compl_q))) {
 		resp = (struct htt_resp *)skb->data;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 4b69a373382b..74a42e3465e4 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3620,6 +3620,123 @@ void ath10k_mgmt_over_wmi_tx_work(struct work_struct *work)
 	}
 }
 
+static void ath10k_mac_txq_init(struct ieee80211_txq *txq)
+{
+	struct ath10k_txq *artxq = (void *)txq->drv_priv;
+
+	if (!txq)
+		return;
+
+	INIT_LIST_HEAD(&artxq->list);
+}
+
+static void ath10k_mac_txq_unref(struct ath10k *ar, struct ieee80211_txq *txq)
+{
+	struct ath10k_txq *artxq = (void *)txq->drv_priv;
+
+	if (!txq)
+		return;
+
+	spin_lock_bh(&ar->txqs_lock);
+	if (!list_empty(&artxq->list))
+		list_del_init(&artxq->list);
+	spin_unlock_bh(&ar->txqs_lock);
+}
+
+static bool ath10k_mac_tx_can_push(struct ieee80211_hw *hw,
+				   struct ieee80211_txq *txq)
+{
+	return 1; /* TBD */
+}
+
+static int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
+				  struct ieee80211_txq *txq)
+{
+	const bool is_mgmt = false;
+	const bool is_presp = false;
+	struct ath10k *ar = hw->priv;
+	struct ath10k_htt *htt = &ar->htt;
+	struct ieee80211_vif *vif = txq->vif;
+	struct ieee80211_sta *sta = txq->sta;
+	enum ath10k_hw_txrx_mode txmode;
+	enum ath10k_mac_tx_path txpath;
+	struct sk_buff *skb;
+	int ret;
+
+	spin_lock_bh(&ar->htt.tx_lock);
+	ret = ath10k_htt_tx_inc_pending(htt, is_mgmt, is_presp);
+	spin_unlock_bh(&ar->htt.tx_lock);
+
+	if (ret)
+		return ret;
+
+	skb = ieee80211_tx_dequeue(hw, txq);
+	if (!skb) {
+		spin_lock_bh(&ar->htt.tx_lock);
+		ath10k_htt_tx_dec_pending(htt, is_mgmt);
+		spin_unlock_bh(&ar->htt.tx_lock);
+
+		return -ENOENT;
+	}
+
+	ath10k_mac_tx_h_fill_cb(ar, vif, skb);
+
+	txmode = ath10k_mac_tx_h_get_txmode(ar, vif, sta, skb);
+	txpath = ath10k_mac_tx_h_get_txpath(ar, skb, txmode);
+
+	ret = ath10k_mac_tx(ar, vif, sta, txmode, txpath, skb);
+	if (unlikely(ret)) {
+		ath10k_warn(ar, "failed to push frame: %d\n", ret);
+
+		spin_lock_bh(&ar->htt.tx_lock);
+		ath10k_htt_tx_dec_pending(htt, is_mgmt);
+		spin_unlock_bh(&ar->htt.tx_lock);
+
+		return ret;
+	}
+
+	return 0;
+}
+
+void ath10k_mac_tx_push_pending(struct ath10k *ar)
+{
+	struct ieee80211_hw *hw = ar->hw;
+	struct ieee80211_txq *txq;
+	struct ath10k_txq *artxq;
+	struct ath10k_txq *last;
+	int ret;
+	int max;
+
+	spin_lock_bh(&ar->txqs_lock);
+	rcu_read_lock();
+
+	last = list_last_entry(&ar->txqs, struct ath10k_txq, list);
+	while (!list_empty(&ar->txqs)) {
+		artxq = list_first_entry(&ar->txqs, struct ath10k_txq, list);
+		txq = container_of((void *)artxq, struct ieee80211_txq,
+				   drv_priv);
+
+		/* Prevent aggressive sta/tid taking over tx queue */
+		max = 16;
+		while (max--) {
+			ret = ath10k_mac_tx_push_txq(hw, txq);
+			if (ret < 0)
+				break;
+		}
+
+		list_del_init(&artxq->list);
+
+		if (artxq == last || (ret < 0 && ret != -ENOENT)) {
+			if (ret != -ENOENT)
+				list_add_tail(&artxq->list, &ar->txqs);
+			break;
+		}
+	}
+
+	rcu_read_unlock();
+	spin_unlock_bh(&ar->txqs_lock);
+}
+
 /************/
 /* Scanning */
 /************/
@@ -3836,6 +3953,22 @@ static void ath10k_mac_op_tx(struct ieee80211_hw *hw,
 	}
 }
 
+static void ath10k_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
+					struct ieee80211_txq *txq)
+{
+	struct ath10k *ar = hw->priv;
+	struct ath10k_txq *artxq = (void *)txq->drv_priv;
+
+	if (ath10k_mac_tx_can_push(hw, txq)) {
+		spin_lock_bh(&ar->txqs_lock);
+		if (list_empty(&artxq->list))
+			list_add_tail(&artxq->list, &ar->txqs);
+		spin_unlock_bh(&ar->txqs_lock);
+
+		tasklet_schedule(&ar->htt.txrx_compl_task);
+	}
+}
+
 /* Must not be called with conf_mutex held as workers can use that also. */
 void ath10k_drain_tx(struct ath10k *ar)
 {
@@ -4462,6 +4595,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	mutex_lock(&ar->conf_mutex);
 
 	memset(arvif, 0, sizeof(*arvif));
+	ath10k_mac_txq_init(vif->txq);
 
 	arvif->ar = ar;
 	arvif->vif = vif;
@@ -4860,6 +4994,8 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 	ath10k_mac_vif_tx_unlock_all(arvif);
 	spin_unlock_bh(&ar->htt.tx_lock);
 
+	ath10k_mac_txq_unref(ar, vif->txq);
+
 	mutex_unlock(&ar->conf_mutex);
 }
 
@@ -5573,6 +5709,9 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 		memset(arsta, 0, sizeof(*arsta));
 		arsta->arvif = arvif;
 		INIT_WORK(&arsta->update_wk, ath10k_sta_rc_update_wk);
+
+		for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
+			ath10k_mac_txq_init(sta->txq[i]);
 	}
 
 	/* cancel must be done outside the mutex to avoid deadlock */
@@ -5710,6 +5849,9 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 		}
 		spin_unlock_bh(&ar->data_lock);
 
+		for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
+			ath10k_mac_txq_unref(ar, sta->txq[i]);
+
 		if (!sta->tdls)
 			goto exit;
 
@@ -7013,6 +7155,7 @@ ath10k_mac_op_switch_vif_chanctx(struct ieee80211_hw *hw,
 
 static const struct ieee80211_ops ath10k_ops = {
 	.tx				= ath10k_mac_op_tx,
+	.wake_tx_queue			= ath10k_mac_op_wake_tx_queue,
 	.start				= ath10k_start,
 	.stop				= ath10k_stop,
 	.config				= ath10k_config,
@@ -7467,6 +7610,7 @@ int ath10k_mac_register(struct ath10k *ar)
 
 	ar->hw->vif_data_size = sizeof(struct ath10k_vif);
 	ar->hw->sta_data_size = sizeof(struct ath10k_sta);
+	ar->hw->txq_data_size = sizeof(struct ath10k_txq);
 
 	ar->hw->max_listen_interval = ATH10K_MAX_HW_LISTEN_INTERVAL;
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.h b/drivers/net/wireless/ath/ath10k/mac.h
index 53091588090d..453f606a250e 100644
--- a/drivers/net/wireless/ath/ath10k/mac.h
+++ b/drivers/net/wireless/ath/ath10k/mac.h
@@ -75,6 +75,7 @@ void ath10k_mac_tx_unlock(struct ath10k *ar, int reason);
 void ath10k_mac_vif_tx_lock(struct ath10k_vif *arvif, int reason);
 void ath10k_mac_vif_tx_unlock(struct ath10k_vif *arvif, int reason);
 bool ath10k_mac_tx_frm_has_freq(struct ath10k *ar);
+void ath10k_mac_tx_push_pending(struct ath10k *ar);
 
 static inline struct ath10k_vif *ath10k_vif_to_arvif(struct ieee80211_vif *vif)
 {
-- 
2.1.4

