Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62387 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab1DMFy2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 01:54:28 -0400
Received: by mail-iy0-f174.google.com with SMTP id 14so275754iyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 22:54:27 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19877.15140.534832.976863@gargle.gargle.HOWL>
Date: Wed, 13 Apr 2011 11:26:52 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 38/40] ath9k_htc: Use helper routines for transmission
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |  227 ++++++++++++++-----------
 1 files changed, 127 insertions(+), 100 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 86f5ce9..723a3a9 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -211,28 +211,140 @@ int ath_htc_txq_update(struct ath9k_htc_priv *priv, int qnum,
 	return error;
 }
 
+static void ath9k_htc_tx_mgmt(struct ath9k_htc_priv *priv,
+			      struct ath9k_htc_vif *avp,
+			      struct sk_buff *skb,
+			      u8 sta_idx, u8 vif_idx, u8 slot)
+{
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_mgmt *mgmt;
+	struct ieee80211_hdr *hdr;
+	struct tx_mgmt_hdr mgmt_hdr;
+	struct ath9k_htc_tx_ctl *tx_ctl;
+	u8 *tx_fhdr;
+
+	tx_ctl = HTC_SKB_CB(skb);
+	hdr = (struct ieee80211_hdr *) skb->data;
+
+	memset(tx_ctl, 0, sizeof(*tx_ctl));
+	memset(&mgmt_hdr, 0, sizeof(struct tx_mgmt_hdr));
+
+	/*
+	 * Set the TSF adjust value for probe response
+	 * frame also.
+	 */
+	if (avp && unlikely(ieee80211_is_probe_resp(hdr->frame_control))) {
+		mgmt = (struct ieee80211_mgmt *)skb->data;
+		mgmt->u.probe_resp.timestamp = avp->tsfadjust;
+	}
+
+	tx_ctl->type = ATH9K_HTC_MGMT;
+
+	mgmt_hdr.node_idx = sta_idx;
+	mgmt_hdr.vif_idx = vif_idx;
+	mgmt_hdr.tidno = 0;
+	mgmt_hdr.flags = 0;
+	mgmt_hdr.cookie = slot;
+
+	mgmt_hdr.key_type = ath9k_cmn_get_hw_crypto_keytype(skb);
+	if (mgmt_hdr.key_type == ATH9K_KEY_TYPE_CLEAR)
+		mgmt_hdr.keyix = (u8) ATH9K_TXKEYIX_INVALID;
+	else
+		mgmt_hdr.keyix = tx_info->control.hw_key->hw_key_idx;
+
+	tx_fhdr = skb_push(skb, sizeof(mgmt_hdr));
+	memcpy(tx_fhdr, (u8 *) &mgmt_hdr, sizeof(mgmt_hdr));
+	tx_ctl->epid = priv->mgmt_ep;
+}
+
+static void ath9k_htc_tx_data(struct ath9k_htc_priv *priv,
+			      struct ieee80211_vif *vif,
+			      struct sk_buff *skb,
+			      u8 sta_idx, u8 vif_idx, u8 slot,
+			      bool is_cab)
+{
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr;
+	struct ath9k_htc_tx_ctl *tx_ctl;
+	struct tx_frame_hdr tx_hdr;
+	u32 flags = 0;
+	u8 *qc, *tx_fhdr;
+	u16 qnum;
+
+	tx_ctl = HTC_SKB_CB(skb);
+	hdr = (struct ieee80211_hdr *) skb->data;
+
+	memset(tx_ctl, 0, sizeof(*tx_ctl));
+	memset(&tx_hdr, 0, sizeof(struct tx_frame_hdr));
+
+	tx_hdr.node_idx = sta_idx;
+	tx_hdr.vif_idx = vif_idx;
+	tx_hdr.cookie = slot;
+
+	/*
+	 * This is a bit redundant but it helps to get
+	 * the per-packet index quickly when draining the
+	 * TX queue in the HIF layer. Otherwise we would
+	 * have to parse the packet contents ...
+	 */
+	tx_ctl->sta_idx = sta_idx;
+
+	if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
+		tx_ctl->type = ATH9K_HTC_AMPDU;
+		tx_hdr.data_type = ATH9K_HTC_AMPDU;
+	} else {
+		tx_ctl->type = ATH9K_HTC_NORMAL;
+		tx_hdr.data_type = ATH9K_HTC_NORMAL;
+	}
+
+	if (ieee80211_is_data_qos(hdr->frame_control)) {
+		qc = ieee80211_get_qos_ctl(hdr);
+		tx_hdr.tidno = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
+	}
+
+	/* Check for RTS protection */
+	if (priv->hw->wiphy->rts_threshold != (u32) -1)
+		if (skb->len > priv->hw->wiphy->rts_threshold)
+			flags |= ATH9K_HTC_TX_RTSCTS;
+
+	/* CTS-to-self */
+	if (!(flags & ATH9K_HTC_TX_RTSCTS) &&
+	    (vif && vif->bss_conf.use_cts_prot))
+		flags |= ATH9K_HTC_TX_CTSONLY;
+
+	tx_hdr.flags = cpu_to_be32(flags);
+	tx_hdr.key_type = ath9k_cmn_get_hw_crypto_keytype(skb);
+	if (tx_hdr.key_type == ATH9K_KEY_TYPE_CLEAR)
+		tx_hdr.keyix = (u8) ATH9K_TXKEYIX_INVALID;
+	else
+		tx_hdr.keyix = tx_info->control.hw_key->hw_key_idx;
+
+	tx_fhdr = skb_push(skb, sizeof(tx_hdr));
+	memcpy(tx_fhdr, (u8 *) &tx_hdr, sizeof(tx_hdr));
+
+	if (is_cab) {
+		CAB_STAT_INC;
+		tx_ctl->epid = priv->cab_ep;
+		return;
+	}
+
+	qnum = skb_get_queue_mapping(skb);
+	tx_ctl->epid = get_htc_epid(priv, qnum);
+}
+
 int ath9k_htc_tx_start(struct ath9k_htc_priv *priv,
 		       struct sk_buff *skb,
 		       u8 slot, bool is_cab)
 {
 	struct ieee80211_hdr *hdr;
-	struct ieee80211_mgmt *mgmt;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_sta *sta = tx_info->control.sta;
 	struct ieee80211_vif *vif = tx_info->control.vif;
 	struct ath9k_htc_sta *ista;
 	struct ath9k_htc_vif *avp = NULL;
-	struct ath9k_htc_tx_ctl *tx_ctl;
-	u16 qnum;
-	__le16 fc;
-	u8 *tx_fhdr;
 	u8 sta_idx, vif_idx;
 
-	tx_ctl = HTC_SKB_CB(skb);
-	memset(tx_ctl, 0, sizeof(*tx_ctl));
-
 	hdr = (struct ieee80211_hdr *) skb->data;
-	fc = hdr->frame_control;
 
 	/*
 	 * Find out on which interface this packet has to be
@@ -261,99 +373,14 @@ int ath9k_htc_tx_start(struct ath9k_htc_priv *priv,
 		sta_idx = priv->vif_sta_pos[vif_idx];
 	}
 
-	if (ieee80211_is_data(fc)) {
-		struct tx_frame_hdr tx_hdr;
-		u32 flags = 0;
-		u8 *qc;
-
-		memset(&tx_hdr, 0, sizeof(struct tx_frame_hdr));
-
-		tx_hdr.node_idx = sta_idx;
-		tx_hdr.vif_idx = vif_idx;
-		tx_hdr.cookie = slot;
-
-		/*
-		 * This is a bit redundant but it helps to get
-		 * the per-packet index quickly when draining the
-		 * TX queue in the HIF layer. Otherwise we would
-		 * have to parse the packet contents ...
-		 */
-		tx_ctl->sta_idx = sta_idx;
-
-		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
-			tx_ctl->type = ATH9K_HTC_AMPDU;
-			tx_hdr.data_type = ATH9K_HTC_AMPDU;
-		} else {
-			tx_ctl->type = ATH9K_HTC_NORMAL;
-			tx_hdr.data_type = ATH9K_HTC_NORMAL;
-		}
-
-		if (ieee80211_is_data_qos(fc)) {
-			qc = ieee80211_get_qos_ctl(hdr);
-			tx_hdr.tidno = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
-		}
-
-		/* Check for RTS protection */
-		if (priv->hw->wiphy->rts_threshold != (u32) -1)
-			if (skb->len > priv->hw->wiphy->rts_threshold)
-				flags |= ATH9K_HTC_TX_RTSCTS;
-
-		/* CTS-to-self */
-		if (!(flags & ATH9K_HTC_TX_RTSCTS) &&
-		    (vif && vif->bss_conf.use_cts_prot))
-			flags |= ATH9K_HTC_TX_CTSONLY;
-
-		tx_hdr.flags = cpu_to_be32(flags);
-		tx_hdr.key_type = ath9k_cmn_get_hw_crypto_keytype(skb);
-		if (tx_hdr.key_type == ATH9K_KEY_TYPE_CLEAR)
-			tx_hdr.keyix = (u8) ATH9K_TXKEYIX_INVALID;
-		else
-			tx_hdr.keyix = tx_info->control.hw_key->hw_key_idx;
-
-		tx_fhdr = skb_push(skb, sizeof(tx_hdr));
-		memcpy(tx_fhdr, (u8 *) &tx_hdr, sizeof(tx_hdr));
-
-		if (is_cab) {
-			CAB_STAT_INC;
-			tx_ctl->epid = priv->cab_ep;
-			goto send;
-		}
-
-		qnum = skb_get_queue_mapping(skb);
-		tx_ctl->epid = get_htc_epid(priv, qnum);
-	} else {
-		struct tx_mgmt_hdr mgmt_hdr;
-
-		memset(&mgmt_hdr, 0, sizeof(struct tx_mgmt_hdr));
-
-		/*
-		 * Set the TSF adjust value for probe response
-		 * frame also.
-		 */
-		if (avp && unlikely(ieee80211_is_probe_resp(fc))) {
-			mgmt = (struct ieee80211_mgmt *)skb->data;
-			mgmt->u.probe_resp.timestamp = avp->tsfadjust;
-		}
-
-		tx_ctl->type = ATH9K_HTC_MGMT;
-
-		mgmt_hdr.node_idx = sta_idx;
-		mgmt_hdr.vif_idx = vif_idx;
-		mgmt_hdr.tidno = 0;
-		mgmt_hdr.flags = 0;
-		mgmt_hdr.cookie = slot;
+	if (ieee80211_is_data(hdr->frame_control))
+		ath9k_htc_tx_data(priv, vif, skb,
+				  sta_idx, vif_idx, slot, is_cab);
+	else
+		ath9k_htc_tx_mgmt(priv, avp, skb,
+				  sta_idx, vif_idx, slot);
 
-		mgmt_hdr.key_type = ath9k_cmn_get_hw_crypto_keytype(skb);
-		if (mgmt_hdr.key_type == ATH9K_KEY_TYPE_CLEAR)
-			mgmt_hdr.keyix = (u8) ATH9K_TXKEYIX_INVALID;
-		else
-			mgmt_hdr.keyix = tx_info->control.hw_key->hw_key_idx;
 
-		tx_fhdr = skb_push(skb, sizeof(mgmt_hdr));
-		memcpy(tx_fhdr, (u8 *) &mgmt_hdr, sizeof(mgmt_hdr));
-		tx_ctl->epid = priv->mgmt_ep;
-	}
-send:
 	return htc_send(priv->htc, skb);
 }
 
-- 
1.7.4.4

