Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45643 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab0L3TX5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Dec 2010 14:23:57 -0500
Received: by mail-pw0-f46.google.com with SMTP id 3so1343698pwj.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Dec 2010 11:23:56 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org, mwl8k-devel@cozybit.com,
	Nishant Sarmukadam <nishants@marvell.com>,
	yogesh powar <yogeshp@marvell.com>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 3/4 V2] mwl8k: Set mac80211 rx status flags appropriately when hw crypto is enabled
Date: Thu, 30 Dec 2010 11:23:33 -0800
Message-Id: <1293737014-11718-3-git-send-email-thomas@cozybit.com>
In-Reply-To: <1293737014-11718-1-git-send-email-thomas@cozybit.com>
References: <1293737014-11718-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nishant Sarmukadam <nishants@marvell.com>

When hw crypto is enabled, set rx status flags appropriately depending on
whether hw crypto is enabled for a particular bss.
Also report MIC errors to mac80211, so that counter measures can be
initiated

V2:
- formatting and make patch cleanly apply

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: yogesh powar <yogeshp@marvell.com>
Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 drivers/net/wireless/mwl8k.c |  101 ++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 98 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 95bbdca..2b76bbc 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -251,6 +251,12 @@ struct mwl8k_vif {
 		u8 enabled;
 		u8 key[sizeof(struct ieee80211_key_conf) + MAX_WEP_KEY_LEN];
 	} wep_key_conf[NUM_WEP_KEYS];
+
+	/* BSSID */
+	u8 bssid[ETH_ALEN];
+
+	/* A flag to indicate is HW crypto is enabled for this bssid */
+	bool is_hw_crypto_enabled;
 };
 #define MWL8K_VIF(_vif) ((struct mwl8k_vif *)&((_vif)->drv_priv))
 
@@ -834,6 +840,13 @@ struct mwl8k_rxd_8366_ap {
 
 #define MWL8K_8366_AP_RX_CTRL_OWNED_BY_HOST	0x80
 
+/* 8366 AP rx_status bits */
+#define MWL8K_8366_AP_RXSTAT_DECRYPT_ERR_MASK		0x80
+#define MWL8K_8366_AP_RXSTAT_GENERAL_DECRYPT_ERR	0xFF
+#define MWL8K_8366_AP_RXSTAT_TKIP_DECRYPT_MIC_ERR	0x02
+#define MWL8K_8366_AP_RXSTAT_WEP_DECRYPT_ICV_ERR	0x04
+#define MWL8K_8366_AP_RXSTAT_TKIP_DECRYPT_ICV_ERR	0x08
+
 static void mwl8k_rxd_8366_ap_init(void *_rxd, dma_addr_t next_dma_addr)
 {
 	struct mwl8k_rxd_8366_ap *rxd = _rxd;
@@ -894,6 +907,11 @@ mwl8k_rxd_8366_ap_process(void *_rxd, struct ieee80211_rx_status *status,
 
 	*qos = rxd->qos_control;
 
+	if ((rxd->rx_status != MWL8K_8366_AP_RXSTAT_GENERAL_DECRYPT_ERR) &&
+	    (rxd->rx_status & MWL8K_8366_AP_RXSTAT_DECRYPT_ERR_MASK) &&
+	    (rxd->rx_status & MWL8K_8366_AP_RXSTAT_TKIP_DECRYPT_MIC_ERR))
+		status->flag |= RX_FLAG_MMIC_ERROR;
+
 	return le16_to_cpu(rxd->pkt_len);
 }
 
@@ -932,6 +950,11 @@ struct mwl8k_rxd_sta {
 #define MWL8K_STA_RATE_INFO_MCS_FORMAT		0x0001
 
 #define MWL8K_STA_RX_CTRL_OWNED_BY_HOST		0x02
+#define MWL8K_STA_RX_CTRL_DECRYPT_ERROR		0x04
+/* ICV=0 or MIC=1 */
+#define MWL8K_STA_RX_CTRL_DEC_ERR_TYPE		0x08
+/* Key is uploaded only in failure case */
+#define MWL8K_STA_RX_CTRL_KEY_INDEX			0x30
 
 static void mwl8k_rxd_sta_init(void *_rxd, dma_addr_t next_dma_addr)
 {
@@ -990,6 +1013,9 @@ mwl8k_rxd_sta_process(void *_rxd, struct ieee80211_rx_status *status,
 	status->freq = ieee80211_channel_to_frequency(rxd->channel);
 
 	*qos = rxd->qos_control;
+	if ((rxd->rx_ctrl & MWL8K_STA_RX_CTRL_DECRYPT_ERROR) &&
+	    (rxd->rx_ctrl & MWL8K_STA_RX_CTRL_DEC_ERR_TYPE))
+		status->flag |= RX_FLAG_MMIC_ERROR;
 
 	return le16_to_cpu(rxd->pkt_len);
 }
@@ -1148,9 +1174,25 @@ static inline void mwl8k_save_beacon(struct ieee80211_hw *hw,
 		ieee80211_queue_work(hw, &priv->finalize_join_worker);
 }
 
+static inline struct mwl8k_vif *mwl8k_find_vif_bss(struct list_head *vif_list,
+						   u8 *bssid)
+{
+	struct mwl8k_vif *mwl8k_vif;
+
+	list_for_each_entry(mwl8k_vif,
+			    vif_list, list) {
+		if (memcmp(bssid, mwl8k_vif->bssid,
+			   ETH_ALEN) == 0)
+			return mwl8k_vif;
+	}
+
+	return NULL;
+}
+
 static int rxq_process(struct ieee80211_hw *hw, int index, int limit)
 {
 	struct mwl8k_priv *priv = hw->priv;
+	struct mwl8k_vif *mwl8k_vif = NULL;
 	struct mwl8k_rx_queue *rxq = priv->rxq + index;
 	int processed;
 
@@ -1160,6 +1202,7 @@ static int rxq_process(struct ieee80211_hw *hw, int index, int limit)
 		void *rxd;
 		int pkt_len;
 		struct ieee80211_rx_status status;
+		struct ieee80211_hdr *wh;
 		__le16 qos;
 
 		skb = rxq->buf[rxq->head].skb;
@@ -1186,8 +1229,7 @@ static int rxq_process(struct ieee80211_hw *hw, int index, int limit)
 
 		rxq->rxd_count--;
 
-		skb_put(skb, pkt_len);
-		mwl8k_remove_dma_header(skb, qos);
+		wh = &((struct mwl8k_dma_data *)skb->data)->wh;
 
 		/*
 		 * Check for a pending join operation.  Save a
@@ -1197,6 +1239,46 @@ static int rxq_process(struct ieee80211_hw *hw, int index, int limit)
 		if (mwl8k_capture_bssid(priv, (void *)skb->data))
 			mwl8k_save_beacon(hw, skb);
 
+		if (ieee80211_has_protected(wh->frame_control)) {
+
+			/* Check if hw crypto has been enabled for
+			 * this bss. If yes, set the status flags
+			 * accordingly
+			 */
+			mwl8k_vif = mwl8k_find_vif_bss(&priv->vif_list,
+								wh->addr1);
+
+			if (mwl8k_vif != NULL &&
+			    mwl8k_vif->is_hw_crypto_enabled == true) {
+				/*
+				 * When MMIC ERROR is encountered
+				 * by the firmware, payload is
+				 * dropped and only 32 bytes of
+				 * mwl8k Firmware header is sent
+				 * to the host.
+				 *
+				 * We need to add four bytes of
+				 * key information.  In it
+				 * MAC80211 expects keyidx set to
+				 * 0 for triggering Counter
+				 * Measure of MMIC failure.
+				 */
+				if (status.flag & RX_FLAG_MMIC_ERROR) {
+					struct mwl8k_dma_data *tr;
+					tr = (struct mwl8k_dma_data *)skb->data;
+					memset((void *)&(tr->data), 0, 4);
+					pkt_len += 4;
+				}
+
+				if (!ieee80211_is_auth(wh->frame_control))
+					status.flag |= RX_FLAG_IV_STRIPPED |
+						       RX_FLAG_DECRYPTED |
+						       RX_FLAG_MMIC_STRIPPED;
+			}
+		}
+
+		skb_put(skb, pkt_len);
+		mwl8k_remove_dma_header(skb, qos);
 		memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));
 		ieee80211_rx_irqsafe(hw, skb);
 
@@ -1499,7 +1581,11 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 	else
 		qos = 0;
 
-	mwl8k_encapsulate_tx_frame(skb);
+	if (priv->ap_fw)
+		mwl8k_encapsulate_tx_frame(skb);
+	else
+		mwl8k_add_dma_header(skb, 0);
+
 	wh = &((struct mwl8k_dma_data *)skb->data)->wh;
 
 	tx_info = IEEE80211_SKB_CB(skb);
@@ -3525,6 +3611,8 @@ static int mwl8k_add_interface(struct ieee80211_hw *hw,
 	mwl8k_vif->vif = vif;
 	mwl8k_vif->macid = macid;
 	mwl8k_vif->seqno = 0;
+	memcpy(mwl8k_vif->bssid, vif->addr, ETH_ALEN);
+	mwl8k_vif->is_hw_crypto_enabled = false;
 
 	/* Set the mac address.  */
 	mwl8k_cmd_set_mac_addr(hw, vif, vif->addr);
@@ -3930,9 +4018,16 @@ static int mwl8k_sta_add(struct ieee80211_hw *hw,
 			return 0;
 		}
 
+	} else {
+		ret = mwl8k_cmd_set_new_stn_add(hw, vif, sta);
 		return ret;
 	}
 
+	for (i = 0; i < NUM_WEP_KEYS; i++) {
+		key = IEEE80211_KEY_CONF(mwl8k_vif->wep_key_conf[i].key);
+		if (mwl8k_vif->wep_key_conf[i].enabled)
+			mwl8k_set_key(hw, SET_KEY, vif, sta, key);
+	}
 	return mwl8k_cmd_set_new_stn_add(hw, vif, sta);
 }
 
-- 
1.7.0.4

