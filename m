Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62387 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab1DMFxR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 01:53:17 -0400
Received: by iyb14 with SMTP id 14so275754iyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 22:53:16 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19877.15069.155157.530796@gargle.gargle.HOWL>
Date: Wed, 13 Apr 2011 11:25:41 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 27/40] ath9k_htc: Move endpoint header parsing to TX tasklet
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

There is no need to do endpoint header removal in the ISR.
Also, this is needed when TX slot management is added later on.
Use a helper function to strip the driver header.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |   68 ++++++++++++++++--------
 2 files changed, 46 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 356f49c..0831ca3 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -277,6 +277,7 @@ struct ath9k_htc_tx {
 struct ath9k_htc_tx_ctl {
 	u8 type; /* ATH9K_HTC_* */
 	u8 epid;
+	u8 txok;
 };
 
 static inline struct ath9k_htc_tx_ctl *HTC_SKB_CB(struct sk_buff *skb)
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index d17662f..7b218da 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -104,6 +104,30 @@ static enum htc_endpoint_id get_htc_epid(struct ath9k_htc_priv *priv,
 	return epid;
 }
 
+static inline int strip_drv_header(struct ath9k_htc_priv *priv,
+				   struct sk_buff *skb)
+{
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+	struct ath9k_htc_tx_ctl *tx_ctl;
+
+	tx_ctl = HTC_SKB_CB(skb);
+
+	if (tx_ctl->epid == priv->mgmt_ep) {
+		skb_pull(skb, sizeof(struct tx_mgmt_hdr));
+	} else if ((tx_ctl->epid == priv->data_bk_ep) ||
+		   (tx_ctl->epid == priv->data_be_ep) ||
+		   (tx_ctl->epid == priv->data_vi_ep) ||
+		   (tx_ctl->epid == priv->data_vo_ep) ||
+		   (tx_ctl->epid == priv->cab_ep)) {
+		skb_pull(skb, sizeof(struct tx_frame_hdr));
+	} else {
+		ath_err(common, "Unsupported EPID: %d\n", tx_ctl->epid);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 int ath_htc_txq_update(struct ath9k_htc_priv *priv, int qnum,
 		       struct ath9k_tx_queue_info *qinfo)
 {
@@ -281,22 +305,40 @@ static bool ath9k_htc_check_tx_aggr(struct ath9k_htc_priv *priv,
 void ath9k_tx_tasklet(unsigned long data)
 {
 	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *)data;
+	struct ath9k_htc_tx_ctl *tx_ctl;
 	struct ieee80211_vif *vif;
 	struct ieee80211_sta *sta;
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_tx_info *tx_info;
 	struct sk_buff *skb = NULL;
 	__le16 fc;
+	bool txok;
 
 	while ((skb = skb_dequeue(&priv->tx.tx_queue)) != NULL) {
 
+		if (strip_drv_header(priv, skb) < 0) {
+			dev_kfree_skb_any(skb);
+			continue;
+		}
+
+		tx_ctl = HTC_SKB_CB(skb);
 		hdr = (struct ieee80211_hdr *) skb->data;
 		fc = hdr->frame_control;
 		tx_info = IEEE80211_SKB_CB(skb);
 		vif = tx_info->control.vif;
+		txok = tx_ctl->txok;
 
 		memset(&tx_info->status, 0, sizeof(tx_info->status));
 
+		/*
+		 * URB submission failed for this frame, it never reached
+		 * the target.
+		 */
+		if (!txok)
+			goto send_mac80211;
+
+		tx_info->flags |= IEEE80211_TX_STAT_ACK;
+
 		if (!vif)
 			goto send_mac80211;
 
@@ -350,30 +392,10 @@ void ath9k_htc_txep(void *drv_priv, struct sk_buff *skb,
 		    enum htc_endpoint_id ep_id, bool txok)
 {
 	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *) drv_priv;
-	struct ath_common *common = ath9k_hw_common(priv->ah);
-	struct ieee80211_tx_info *tx_info;
-
-	if (!skb)
-		return;
-
-	if (ep_id == priv->mgmt_ep) {
-		skb_pull(skb, sizeof(struct tx_mgmt_hdr));
-	} else if ((ep_id == priv->data_bk_ep) ||
-		   (ep_id == priv->data_be_ep) ||
-		   (ep_id == priv->data_vi_ep) ||
-		   (ep_id == priv->data_vo_ep) ||
-		   (ep_id == priv->cab_ep)) {
-		skb_pull(skb, sizeof(struct tx_frame_hdr));
-	} else {
-		ath_err(common, "Unsupported TX EPID: %d\n", ep_id);
-		dev_kfree_skb_any(skb);
-		return;
-	}
-
-	tx_info = IEEE80211_SKB_CB(skb);
+	struct ath9k_htc_tx_ctl *tx_ctl;
 
-	if (txok)
-		tx_info->flags |= IEEE80211_TX_STAT_ACK;
+	tx_ctl = HTC_SKB_CB(skb);
+	tx_ctl->txok = txok;
 
 	skb_queue_tail(&priv->tx.tx_queue, skb);
 	tasklet_schedule(&priv->tx_tasklet);
-- 
1.7.4.4

