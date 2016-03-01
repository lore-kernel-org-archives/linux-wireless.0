Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:32842 "EHLO
	mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbcCAKcX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 05:32:23 -0500
Received: by mail-lf0-f43.google.com with SMTP id v124so17124580lff.0
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2016 02:32:22 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 10/11] ath10k: keep track of queue depth per txq
Date: Tue,  1 Mar 2016 11:32:55 +0100
Message-Id: <1456828376-2795-11-git-send-email-michal.kazior@tieto.com> (sfid-20160301_115949_899013_EAA0024E)
In-Reply-To: <1456828376-2795-1-git-send-email-michal.kazior@tieto.com>
References: <1453384006-31907-1-git-send-email-michal.kazior@tieto.com>
 <1456828376-2795-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will be necessary for later.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h | 1 +
 drivers/net/wireless/ath/ath10k/mac.c  | 5 +++++
 drivers/net/wireless/ath/ath10k/txrx.c | 7 +++++++
 3 files changed, 13 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 89f789f3e5b4..926ecb2244a5 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -311,6 +311,7 @@ struct ath10k_peer {
 
 struct ath10k_txq {
 	struct list_head list;
+	unsigned long num_fw_queued;
 };
 
 struct ath10k_sta {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 8d02d53fdc2c..5bf614f1f75a 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3669,6 +3669,7 @@ static int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
 	const bool is_presp = false;
 	struct ath10k *ar = hw->priv;
 	struct ath10k_htt *htt = &ar->htt;
+	struct ath10k_txq *artxq = (void *)txq->drv_priv;
 	struct ieee80211_vif *vif = txq->vif;
 	struct ieee80211_sta *sta = txq->sta;
 	enum ath10k_hw_txrx_mode txmode;
@@ -3708,6 +3709,10 @@ static int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
 		return ret;
 	}
 
+	spin_lock_bh(&ar->htt.tx_lock);
+	artxq->num_fw_queued++;
+	spin_unlock_bh(&ar->htt.tx_lock);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 202e5192235b..ea4d3000c8c3 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -55,7 +55,9 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 	struct ath10k *ar = htt->ar;
 	struct device *dev = ar->dev;
 	struct ieee80211_tx_info *info;
+	struct ieee80211_txq *txq;
 	struct ath10k_skb_cb *skb_cb;
+	struct ath10k_txq *artxq;
 	struct sk_buff *msdu;
 	bool limit_mgmt_desc = false;
 
@@ -80,11 +82,16 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 	}
 
 	skb_cb = ATH10K_SKB_CB(msdu);
+	txq = skb_cb->txq;
+	artxq = (void *)txq->drv_priv;
 
 	if (unlikely(skb_cb->flags & ATH10K_SKB_F_MGMT) &&
 	    ar->hw_params.max_probe_resp_desc_thres)
 		limit_mgmt_desc = true;
 
+	if (txq)
+		artxq->num_fw_queued--;
+
 	ath10k_htt_tx_free_msdu_id(htt, tx_done->msdu_id);
 	ath10k_htt_tx_dec_pending(htt, limit_mgmt_desc);
 	if (htt->num_pending_tx == 0)
-- 
2.1.4

