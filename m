Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56972 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519AbYE2Ihl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 04:37:41 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 23/43] iwlwifi: move tx response common handlers to iwlcore
Date: Thu, 29 May 2008 16:35:08 +0800
Message-Id: <1212050128-17132-24-git-send-email-yi.zhu@intel.com> (sfid-20080529_110547_147501_4800B915)
In-Reply-To: <1212050128-17132-23-git-send-email-yi.zhu@intel.com>
References: <1212050128-17132-1-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-2-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-3-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-4-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-5-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-6-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-7-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-8-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-9-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-10-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-11-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-12-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-13-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-14-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-15-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-16-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-17-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-18-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-19-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-20-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-21-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-22-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-23-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This pach moves common tx response handlers to the header files
and iwl-tx.c.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    9 ++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    3 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   30 ++++++++++++
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   30 ++++++++++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   69 +++------------------------
 5 files changed, 79 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index bad0e94..2652e37 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1365,6 +1365,15 @@ enum {
 	TX_ABORT_REQUIRED_MSK = 0x80000000,	/* bits 31:31 */
 };
 
+static inline int iwl_is_tx_success(u32 status)
+{
+	status &= TX_STATUS_MSK;
+	return (status == TX_STATUS_SUCCESS)
+	    || (status == TX_STATUS_DIRECT_DONE);
+}
+
+
+
 /* *******************************
  * TX aggregation status
  ******************************* */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 9d43085..9449b61 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -209,6 +209,8 @@ void iwl_rx_allocate(struct iwl_priv *priv);
 void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
 			       struct iwl_rx_mem_buffer *rxb);
 
+/* TX helpers */
+
 /*****************************************************
 * TX
 ******************************************************/
@@ -220,6 +222,7 @@ void iwl_hw_txq_ctx_free(struct iwl_priv *priv);
 int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *tfd,
 					dma_addr_t addr, u16 len);
 int iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq);
+
 /*****************************************************
  *   S e n d i n g     H o s t     C o m m a n d s   *
  *****************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 291c1ec..9343313 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1242,6 +1242,36 @@ static inline void iwl_txq_ctx_deactivate(struct iwl_priv *priv, int txq_id)
 	clear_bit(txq_id, &priv->txq_ctx_active_msk);
 }
 
+#ifdef CONFIG_IWLWIF_DEBUG
+const char *iwl_get_tx_fail_reason(u32 status);
+#else
+static inline const char *iwl_get_tx_fail_reason(u32 status) { return ""; }
+#endif
+
+
+#ifdef CONFIG_IWL4965_HT
+static inline int iwl_get_ra_sta_id(struct iwl_priv *priv,
+				    struct ieee80211_hdr *hdr)
+{
+	if (priv->iw_mode == IEEE80211_IF_TYPE_STA) {
+		return IWL_AP_ID;
+	} else {
+		u8 *da = ieee80211_get_DA(hdr);
+		return iwl_find_station(priv, da);
+	}
+}
+
+static inline struct ieee80211_hdr *iwl_tx_queue_get_hdr(struct iwl_priv *priv,
+							 int txq_id, int idx)
+{
+	if (priv->txq[txq_id].txb[idx].skb[0])
+		return (struct ieee80211_hdr *)priv->txq[txq_id].
+				txb[idx].skb[0]->data;
+	return NULL;
+}
+#endif
+
+
 static inline int iwl_is_associated(struct iwl_priv *priv)
 {
 	return (priv->active_rxon.filter_flags & RXON_FILTER_ASSOC_MSK) ? 1 : 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 0b822b5..885a4c1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1060,3 +1060,33 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	return ret ? ret : idx;
 }
 
+#ifdef CONFIG_IWLWIF_DEBUG
+#define TX_STATUS_ENTRY(x) case TX_STATUS_FAIL_ ## x: return #x
+
+const char *iwl_get_tx_fail_reason(u32 status)
+{
+	switch (status & TX_STATUS_MSK) {
+	case TX_STATUS_SUCCESS:
+		return "SUCCESS";
+		TX_STATUS_ENTRY(SHORT_LIMIT);
+		TX_STATUS_ENTRY(LONG_LIMIT);
+		TX_STATUS_ENTRY(FIFO_UNDERRUN);
+		TX_STATUS_ENTRY(MGMNT_ABORT);
+		TX_STATUS_ENTRY(NEXT_FRAG);
+		TX_STATUS_ENTRY(LIFE_EXPIRE);
+		TX_STATUS_ENTRY(DEST_PS);
+		TX_STATUS_ENTRY(ABORTED);
+		TX_STATUS_ENTRY(BT_RETRY);
+		TX_STATUS_ENTRY(STA_INVALID);
+		TX_STATUS_ENTRY(FRAG_DROPPED);
+		TX_STATUS_ENTRY(TID_DISABLE);
+		TX_STATUS_ENTRY(FRAME_FLUSHED);
+		TX_STATUS_ENTRY(INSUFFICIENT_CF_POLL);
+		TX_STATUS_ENTRY(TX_LOCKED);
+		TX_STATUS_ENTRY(NO_BEACON_ON_RADAR);
+	}
+
+	return "UNKNOWN";
+}
+EXPORT_SYMBOL(iwl_get_tx_fail_reason);
+#endif /* CONFIG_IWLWIFI_DEBUG */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index af8394c..411fad3 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -915,33 +915,7 @@ int iwl4965_is_network_packet(struct iwl_priv *priv, struct ieee80211_hdr *heade
 	return 1;
 }
 
-#define TX_STATUS_ENTRY(x) case TX_STATUS_FAIL_ ## x: return #x
 
-static const char *iwl4965_get_tx_fail_reason(u32 status)
-{
-	switch (status & TX_STATUS_MSK) {
-	case TX_STATUS_SUCCESS:
-		return "SUCCESS";
-		TX_STATUS_ENTRY(SHORT_LIMIT);
-		TX_STATUS_ENTRY(LONG_LIMIT);
-		TX_STATUS_ENTRY(FIFO_UNDERRUN);
-		TX_STATUS_ENTRY(MGMNT_ABORT);
-		TX_STATUS_ENTRY(NEXT_FRAG);
-		TX_STATUS_ENTRY(LIFE_EXPIRE);
-		TX_STATUS_ENTRY(DEST_PS);
-		TX_STATUS_ENTRY(ABORTED);
-		TX_STATUS_ENTRY(BT_RETRY);
-		TX_STATUS_ENTRY(STA_INVALID);
-		TX_STATUS_ENTRY(FRAG_DROPPED);
-		TX_STATUS_ENTRY(TID_DISABLE);
-		TX_STATUS_ENTRY(FRAME_FLUSHED);
-		TX_STATUS_ENTRY(INSUFFICIENT_CF_POLL);
-		TX_STATUS_ENTRY(TX_LOCKED);
-		TX_STATUS_ENTRY(NO_BEACON_ON_RADAR);
-	}
-
-	return "UNKNOWN";
-}
 
 /**
  * iwl4965_scan_cancel - Cancel any currently executing HW scan
@@ -1606,40 +1580,12 @@ int iwl4965_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 	return nfreed;
 }
 
-static int iwl4965_is_tx_success(u32 status)
-{
-	status &= TX_STATUS_MSK;
-	return (status == TX_STATUS_SUCCESS)
-	    || (status == TX_STATUS_DIRECT_DONE);
-}
-
 /******************************************************************************
  *
  * Generic RX handler implementations
  *
  ******************************************************************************/
 #ifdef CONFIG_IWL4965_HT
-
-static inline int iwl4965_get_ra_sta_id(struct iwl_priv *priv,
-				    struct ieee80211_hdr *hdr)
-{
-	if (priv->iw_mode == IEEE80211_IF_TYPE_STA)
-		return IWL_AP_ID;
-	else {
-		u8 *da = ieee80211_get_DA(hdr);
-		return iwl_find_station(priv, da);
-	}
-}
-
-static struct ieee80211_hdr *iwl4965_tx_queue_get_hdr(
-	struct iwl_priv *priv, int txq_id, int idx)
-{
-	if (priv->txq[txq_id].txb[idx].skb[0])
-		return (struct ieee80211_hdr *)priv->txq[txq_id].
-				txb[idx].skb[0]->data;
-	return NULL;
-}
-
 static inline u32 iwl4965_get_scd_ssn(struct iwl4965_tx_resp *tx_resp)
 {
 	__le32 *scd_ssn = (__le32 *)((u32 *)&tx_resp->status +
@@ -1687,7 +1633,7 @@ static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 		info = IEEE80211_SKB_CB(priv->txq[txq_id].txb[idx].skb[0]);
 		info->status.retry_count = tx_resp->failure_frame;
 		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
-		info->flags |= iwl4965_is_tx_success(status)?
+		info->flags |= iwl_is_tx_success(status)?
 			IEEE80211_TX_STAT_ACK : 0;
 		iwl4965_hwrate_to_tx_control(priv,
 					     le32_to_cpu(tx_resp->rate_n_flags),
@@ -1720,7 +1666,7 @@ static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 			IWL_DEBUG_TX_REPLY("FrameCnt = %d, txq_id=%d idx=%d\n",
 					   agg->frame_count, txq_id, idx);
 
-			hdr = iwl4965_tx_queue_get_hdr(priv, txq_id, idx);
+			hdr = iwl_tx_queue_get_hdr(priv, txq_id, idx);
 
 			sc = le16_to_cpu(hdr->seq_ctrl);
 			if (idx != (SEQ_TO_SN(sc) & 0xff)) {
@@ -1800,14 +1746,14 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 	memset(&info->status, 0, sizeof(info->status));
 
 #ifdef CONFIG_IWL4965_HT
-	hdr = iwl4965_tx_queue_get_hdr(priv, txq_id, index);
+	hdr = iwl_tx_queue_get_hdr(priv, txq_id, index);
 	fc = le16_to_cpu(hdr->frame_control);
 	if (ieee80211_is_qos_data(fc)) {
 		qc = ieee80211_get_qos_ctrl(hdr, ieee80211_get_hdrlen(fc));
 		tid = qc[0] & 0xf;
 	}
 
-	sta_id = iwl4965_get_ra_sta_id(priv, hdr);
+	sta_id = iwl_get_ra_sta_id(priv, hdr);
 	if (txq->sched_retry && unlikely(sta_id == IWL_INVALID_STATION)) {
 		IWL_ERROR("Station not known\n");
 		return;
@@ -1825,8 +1771,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 		iwl4965_tx_status_reply_tx(priv, agg,
 				(struct iwl4965_tx_resp_agg *)tx_resp, index);
 
-		if ((tx_resp->frame_count == 1) &&
-		    !iwl4965_is_tx_success(status)) {
+		if ((tx_resp->frame_count == 1) && !iwl_is_tx_success(status)) {
 			/* TODO: send BAR */
 		}
 
@@ -1856,12 +1801,12 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 
 	info->status.retry_count = tx_resp->failure_frame;
 	info->flags |=
-	    iwl4965_is_tx_success(status) ? IEEE80211_TX_STAT_ACK : 0;
+	    iwl_is_tx_success(status) ? IEEE80211_TX_STAT_ACK : 0;
 	iwl4965_hwrate_to_tx_control(priv, le32_to_cpu(tx_resp->rate_n_flags),
 				     info);
 
 	IWL_DEBUG_TX("Tx queue %d Status %s (0x%08x) rate_n_flags 0x%x "
-		     "retries %d\n", txq_id, iwl4965_get_tx_fail_reason(status),
+		     "retries %d\n", txq_id, iwl_get_tx_fail_reason(status),
 		     status, le32_to_cpu(tx_resp->rate_n_flags),
 		     tx_resp->failure_frame);
 
-- 
1.5.3.6

