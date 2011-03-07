Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f51.google.com ([74.125.83.51]:61037 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab1CGCPb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 21:15:31 -0500
Received: by gwb15 with SMTP id 15so2263475gwb.10
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 18:15:31 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19828.16314.329053.102549@gargle.gargle.HOWL>
Date: Mon, 7 Mar 2011 07:45:22 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC 25/34] ath9k_htc: Add TX slots
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Maintain a bitmap of slots for transmission and update
the cookie field for every packet with the slot value.
This value would be used for matching packets when TX
completion processing is added.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h            |    5 ++-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |   17 ++++++--
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   |   14 +++++-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c   |   51 ++++++++++++++++++++---
 4 files changed, 73 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 5425483..332175e 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -268,6 +268,7 @@ struct ath9k_htc_tx {
 	u8 flags;
 	int queued_cnt;
 	struct sk_buff_head tx_queue;
+	DECLARE_BITMAP(tx_slot, MAX_TX_BUF_NUM);
 	spinlock_t tx_lock;
 };
 
@@ -526,7 +527,7 @@ void ath9k_htc_stop_ani(struct ath9k_htc_priv *priv);
 int ath9k_tx_init(struct ath9k_htc_priv *priv);
 void ath9k_tx_tasklet(unsigned long data);
 int ath9k_htc_tx_start(struct ath9k_htc_priv *priv,
-		       struct sk_buff *skb, bool is_cab);
+		       struct sk_buff *skb, u8 slot, bool is_cab);
 void ath9k_tx_cleanup(struct ath9k_htc_priv *priv);
 bool ath9k_htc_txq_setup(struct ath9k_htc_priv *priv, int subtype);
 int ath9k_htc_cabq_setup(struct ath9k_htc_priv *priv);
@@ -535,6 +536,8 @@ int ath_htc_txq_update(struct ath9k_htc_priv *priv, int qnum,
 		       struct ath9k_tx_queue_info *qinfo);
 void ath9k_htc_check_stop_queues(struct ath9k_htc_priv *priv);
 void ath9k_htc_check_wake_queues(struct ath9k_htc_priv *priv);
+int ath9k_htc_tx_get_slot(struct ath9k_htc_priv *priv);
+void ath9k_htc_tx_clear_slot(struct ath9k_htc_priv *priv, int slot);
 
 int ath9k_rx_init(struct ath9k_htc_priv *priv);
 void ath9k_rx_cleanup(struct ath9k_htc_priv *priv);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index a048720..4d071b0 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -303,7 +303,7 @@ static void ath9k_htc_send_buffered(struct ath9k_htc_priv *priv,
 	struct ieee80211_vif *vif;
 	struct sk_buff *skb;
 	struct ieee80211_hdr *hdr;
-	int padpos, padsize, ret;
+	int padpos, padsize, ret, tx_slot;
 
 	spin_lock_bh(&priv->beacon_lock);
 
@@ -325,11 +325,20 @@ static void ath9k_htc_send_buffered(struct ath9k_htc_priv *priv,
 			memmove(skb->data, skb->data + padsize, padpos);
 		}
 
-		ret = ath9k_htc_tx_start(priv, skb, true);
+		tx_slot = ath9k_htc_tx_get_slot(priv);
+		if (tx_slot != 0) {
+			ath_dbg(common, ATH_DBG_XMIT, "No free CAB slot\n");
+			dev_kfree_skb_any(skb);
+			goto next;
+		}
+
+		ret = ath9k_htc_tx_start(priv, skb, tx_slot, true);
 		if (ret != 0) {
-			ath_dbg(common, ATH_DBG_FATAL,
-				"Failed to send CAB frame\n");
+			ath9k_htc_tx_clear_slot(priv, tx_slot);
 			dev_kfree_skb_any(skb);
+
+			ath_dbg(common, ATH_DBG_XMIT,
+				"Failed to send CAB frame\n");
 		}
 	next:
 		skb = ieee80211_get_buffered_bc(priv->hw, vif);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 6901136..c7e056b 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -834,7 +834,7 @@ static void ath9k_htc_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	struct ieee80211_hdr *hdr;
 	struct ath9k_htc_priv *priv = hw->priv;
 	struct ath_common *common = ath9k_hw_common(priv->ah);
-	int padpos, padsize, ret;
+	int padpos, padsize, ret, slot;
 
 	hdr = (struct ieee80211_hdr *) skb->data;
 
@@ -850,16 +850,24 @@ static void ath9k_htc_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		memmove(skb->data, skb->data + padsize, padpos);
 	}
 
-	ret = ath9k_htc_tx_start(priv, skb, false);
+	slot = ath9k_htc_tx_get_slot(priv);
+	if (slot < 0) {
+		ath_dbg(common, ATH_DBG_XMIT, "No free TX slot\n");
+		goto fail_tx;
+	}
+
+	ret = ath9k_htc_tx_start(priv, skb, slot, false);
 	if (ret != 0) {
 		ath_dbg(common, ATH_DBG_XMIT, "Tx failed\n");
-		goto fail_tx;
+		goto clear_slot;
 	}
 
 	ath9k_htc_check_stop_queues(priv);
 
 	return;
 
+clear_slot:
+	ath9k_htc_tx_clear_slot(priv, slot);
 fail_tx:
 	dev_kfree_skb_any(skb);
 }
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 7b218da..ee5b3e2 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -76,6 +76,29 @@ void ath9k_htc_check_wake_queues(struct ath9k_htc_priv *priv)
 	spin_unlock_bh(&priv->tx.tx_lock);
 }
 
+int ath9k_htc_tx_get_slot(struct ath9k_htc_priv *priv)
+{
+	int slot;
+
+	spin_lock_bh(&priv->tx.tx_lock);
+	slot = find_first_zero_bit(priv->tx.tx_slot, MAX_TX_BUF_NUM);
+	if (slot >= MAX_TX_BUF_NUM) {
+		spin_unlock_bh(&priv->tx.tx_lock);
+		return -ENOBUFS;
+	}
+	__set_bit(slot, priv->tx.tx_slot);
+	spin_unlock_bh(&priv->tx.tx_lock);
+
+	return slot;
+}
+
+void ath9k_htc_tx_clear_slot(struct ath9k_htc_priv *priv, int slot)
+{
+	spin_lock_bh(&priv->tx.tx_lock);
+	__clear_bit(slot, priv->tx.tx_slot);
+	spin_unlock_bh(&priv->tx.tx_lock);
+}
+
 static enum htc_endpoint_id get_htc_epid(struct ath9k_htc_priv *priv,
 					 u16 qnum)
 {
@@ -104,28 +127,38 @@ static enum htc_endpoint_id get_htc_epid(struct ath9k_htc_priv *priv,
 	return epid;
 }
 
+/*
+ * Removes the driver header and returns the TX slot number
+ */
 static inline int strip_drv_header(struct ath9k_htc_priv *priv,
 				   struct sk_buff *skb)
 {
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	struct ath9k_htc_tx_ctl *tx_ctl;
+	int slot;
 
 	tx_ctl = HTC_SKB_CB(skb);
 
 	if (tx_ctl->epid == priv->mgmt_ep) {
+		struct tx_mgmt_hdr *tx_mhdr =
+			(struct tx_mgmt_hdr *)skb->data;
+		slot = tx_mhdr->cookie;
 		skb_pull(skb, sizeof(struct tx_mgmt_hdr));
 	} else if ((tx_ctl->epid == priv->data_bk_ep) ||
 		   (tx_ctl->epid == priv->data_be_ep) ||
 		   (tx_ctl->epid == priv->data_vi_ep) ||
 		   (tx_ctl->epid == priv->data_vo_ep) ||
 		   (tx_ctl->epid == priv->cab_ep)) {
+		struct tx_frame_hdr *tx_fhdr =
+			(struct tx_frame_hdr *)skb->data;
+		slot = tx_fhdr->cookie;
 		skb_pull(skb, sizeof(struct tx_frame_hdr));
 	} else {
 		ath_err(common, "Unsupported EPID: %d\n", tx_ctl->epid);
-		return -EINVAL;
+		slot = -EINVAL;
 	}
 
-	return 0;
+	return slot;
 }
 
 int ath_htc_txq_update(struct ath9k_htc_priv *priv, int qnum,
@@ -155,7 +188,8 @@ int ath_htc_txq_update(struct ath9k_htc_priv *priv, int qnum,
 }
 
 int ath9k_htc_tx_start(struct ath9k_htc_priv *priv,
-		       struct sk_buff *skb, bool is_cab)
+		       struct sk_buff *skb,
+		       u8 slot, bool is_cab)
 {
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_mgmt *mgmt;
@@ -212,6 +246,7 @@ int ath9k_htc_tx_start(struct ath9k_htc_priv *priv,
 
 		tx_hdr.node_idx = sta_idx;
 		tx_hdr.vif_idx = vif_idx;
+		tx_hdr.cookie = slot;
 
 		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
 			tx_ctl->type = ATH9K_HTC_AMPDU;
@@ -274,6 +309,7 @@ int ath9k_htc_tx_start(struct ath9k_htc_priv *priv,
 		mgmt_hdr.vif_idx = vif_idx;
 		mgmt_hdr.tidno = 0;
 		mgmt_hdr.flags = 0;
+		mgmt_hdr.cookie = slot;
 
 		mgmt_hdr.key_type = ath9k_cmn_get_hw_crypto_keytype(skb);
 		if (mgmt_hdr.key_type == ATH9K_KEY_TYPE_CLEAR)
@@ -313,10 +349,12 @@ void ath9k_tx_tasklet(unsigned long data)
 	struct sk_buff *skb = NULL;
 	__le16 fc;
 	bool txok;
+	int slot;
 
 	while ((skb = skb_dequeue(&priv->tx.tx_queue)) != NULL) {
 
-		if (strip_drv_header(priv, skb) < 0) {
+		slot = strip_drv_header(priv, skb);
+		if (slot < 0) {
 			dev_kfree_skb_any(skb);
 			continue;
 		}
@@ -347,8 +385,7 @@ void ath9k_tx_tasklet(unsigned long data)
 		sta = ieee80211_find_sta(vif, hdr->addr1);
 		if (!sta) {
 			rcu_read_unlock();
-			ieee80211_tx_status(priv->hw, skb);
-			continue;
+			goto send_mac80211;
 		}
 
 		/* Check if we need to start aggregation */
@@ -380,6 +417,8 @@ void ath9k_tx_tasklet(unsigned long data)
 			priv->tx.queued_cnt = 0;
 		spin_unlock_bh(&priv->tx.tx_lock);
 
+		ath9k_htc_tx_clear_slot(priv, slot);
+
 		/* Send status to mac80211 */
 		ieee80211_tx_status(priv->hw, skb);
 	}
-- 
1.7.4.1

