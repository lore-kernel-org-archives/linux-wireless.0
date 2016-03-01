Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:32830 "EHLO
	mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbcCAKcW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 05:32:22 -0500
Received: by mail-lf0-f46.google.com with SMTP id v124so17124231lff.0
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2016 02:32:21 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 09/11] ath10k: store txq in skb_cb
Date: Tue,  1 Mar 2016 11:32:54 +0100
Message-Id: <1456828376-2795-10-git-send-email-michal.kazior@tieto.com> (sfid-20160301_115949_763253_98EEBA50)
In-Reply-To: <1456828376-2795-1-git-send-email-michal.kazior@tieto.com>
References: <1453384006-31907-1-git-send-email-michal.kazior@tieto.com>
 <1456828376-2795-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will be necessary for later.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h |  1 +
 drivers/net/wireless/ath/ath10k/mac.c  | 19 +++++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 7df35628ca35..89f789f3e5b4 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -98,6 +98,7 @@ struct ath10k_skb_cb {
 	u8 eid;
 	u16 msdu_id;
 	struct ieee80211_vif *vif;
+	struct ieee80211_txq *txq;
 } __packed;
 
 struct ath10k_skb_rxcb {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 900c64b65b43..8d02d53fdc2c 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3307,6 +3307,7 @@ static void ath10k_tx_h_add_p2p_noa_ie(struct ath10k *ar,
 
 static void ath10k_mac_tx_h_fill_cb(struct ath10k *ar,
 				    struct ieee80211_vif *vif,
+				    struct ieee80211_txq *txq,
 				    struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (void *)skb->data;
@@ -3323,6 +3324,7 @@ static void ath10k_mac_tx_h_fill_cb(struct ath10k *ar,
 		cb->flags |= ATH10K_SKB_F_QOS;
 
 	cb->vif = vif;
+	cb->txq = txq;
 }
 
 bool ath10k_mac_tx_frm_has_freq(struct ath10k *ar)
@@ -3633,6 +3635,9 @@ static void ath10k_mac_txq_init(struct ieee80211_txq *txq)
 static void ath10k_mac_txq_unref(struct ath10k *ar, struct ieee80211_txq *txq)
 {
 	struct ath10k_txq *artxq = (void *)txq->drv_priv;
+	struct ath10k_skb_cb *cb;
+	struct sk_buff *msdu;
+	int msdu_id;
 
 	if (!txq)
 		return;
@@ -3641,6 +3646,14 @@ static void ath10k_mac_txq_unref(struct ath10k *ar, struct ieee80211_txq *txq)
 	if (!list_empty(&artxq->list))
 		list_del_init(&artxq->list);
 	spin_unlock_bh(&ar->txqs_lock);
+
+	spin_lock_bh(&ar->htt.tx_lock);
+	idr_for_each_entry(&ar->htt.pending_tx, msdu, msdu_id) {
+		cb = ATH10K_SKB_CB(msdu);
+		if (cb->txq == txq)
+			cb->txq = NULL;
+	}
+	spin_unlock_bh(&ar->htt.tx_lock);
 }
 
 static bool ath10k_mac_tx_can_push(struct ieee80211_hw *hw,
@@ -3679,7 +3692,7 @@ static int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
 		return -ENOENT;
 	}
 
-	ath10k_mac_tx_h_fill_cb(ar, vif, skb);
+	ath10k_mac_tx_h_fill_cb(ar, vif, txq, skb);
 
 	txmode = ath10k_mac_tx_h_get_txmode(ar, vif, sta, skb);
 	txpath = ath10k_mac_tx_h_get_txpath(ar, skb, txmode);
@@ -3909,6 +3922,7 @@ static void ath10k_mac_op_tx(struct ieee80211_hw *hw,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_vif *vif = info->control.vif;
 	struct ieee80211_sta *sta = control->sta;
+	struct ieee80211_txq *txq = NULL;
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	enum ath10k_hw_txrx_mode txmode;
 	enum ath10k_mac_tx_path txpath;
@@ -3917,7 +3931,7 @@ static void ath10k_mac_op_tx(struct ieee80211_hw *hw,
 	bool is_presp;
 	int ret;
 
-	ath10k_mac_tx_h_fill_cb(ar, vif, skb);
+	ath10k_mac_tx_h_fill_cb(ar, vif, txq, skb);
 
 	txmode = ath10k_mac_tx_h_get_txmode(ar, vif, sta, skb);
 	txpath = ath10k_mac_tx_h_get_txpath(ar, skb, txmode);
@@ -4985,6 +4999,7 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 	spin_unlock_bh(&ar->data_lock);
 
 	ath10k_peer_cleanup(ar, arvif->vdev_id);
+	ath10k_mac_txq_unref(ar, vif->txq);
 
 	if (vif->type == NL80211_IFTYPE_MONITOR) {
 		ar->monitor_arvif = NULL;
-- 
2.1.4

