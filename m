Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22727 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176Ab0CYUo5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 16:44:57 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 12/22] iwlwifi: move agn only tx functions from iwlcore to iwlagn
Date: Thu, 25 Mar 2010 13:44:40 -0700
Message-Id: <1269549890-19195-13-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
References: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Identify the tx functions only used by agn driver and move those from
iwlcore to iwlagn.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    7 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |  136 ++++-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c   | 1022 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   14 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h      |   17 +
 drivers/net/wireless/iwlwifi/iwl-core.c     |   51 --
 drivers/net/wireless/iwlwifi/iwl-core.h     |   12 -
 drivers/net/wireless/iwlwifi/iwl-devtrace.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-rx.c       |   80 --
 drivers/net/wireless/iwlwifi/iwl-sta.c      |    1 +
 drivers/net/wireless/iwlwifi/iwl-tx.c       | 1029 ---------------------------
 11 files changed, 1185 insertions(+), 1185 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 3949133..cee31cd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -46,6 +46,7 @@
 #include "iwl-calib.h"
 #include "iwl-sta.h"
 #include "iwl-agn-led.h"
+#include "iwl-agn.h"
 
 static int iwl4965_send_tx_power(struct iwl_priv *priv);
 static int iwl4965_hw_get_temperature(struct iwl_priv *priv);
@@ -2020,7 +2021,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 			index = iwl_queue_dec_wrap(scd_ssn & 0xff, txq->q.n_bd);
 			IWL_DEBUG_TX_REPLY(priv, "Retry scheduler reclaim scd_ssn "
 					   "%d index %d\n", scd_ssn , index);
-			freed = iwl_tx_queue_reclaim(priv, txq_id, index);
+			freed = iwlagn_tx_queue_reclaim(priv, txq_id, index);
 			iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
 
 			if (priv->mac80211_registered &&
@@ -2046,7 +2047,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 				   le32_to_cpu(tx_resp->rate_n_flags),
 				   tx_resp->failure_frame);
 
-		freed = iwl_tx_queue_reclaim(priv, txq_id, index);
+		freed = iwlagn_tx_queue_reclaim(priv, txq_id, index);
 		if (qc && likely(sta_id != IWL_INVALID_STATION))
 			priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
 
@@ -2056,7 +2057,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 	}
 
 	if (qc && likely(sta_id != IWL_INVALID_STATION))
-		iwl_txq_check_empty(priv, sta_id, tid, txq_id);
+		iwlagn_txq_check_empty(priv, sta_id, tid, txq_id);
 
 	if (iwl_check_bits(status, TX_ABORT_REQUIRED_MSK))
 		IWL_ERR(priv, "TODO:  Implement Tx ABORT REQUIRED!!!\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index c826b7f..6f9d52d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -208,7 +208,7 @@ static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
 					"scd_ssn=%d idx=%d txq=%d swq=%d\n",
 					scd_ssn , index, txq_id, txq->swq_id);
 
-			freed = iwl_tx_queue_reclaim(priv, txq_id, index);
+			freed = iwlagn_tx_queue_reclaim(priv, txq_id, index);
 			iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
 
 			if (priv->mac80211_registered &&
@@ -236,7 +236,7 @@ static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
 				   le32_to_cpu(tx_resp->rate_n_flags),
 				   tx_resp->failure_frame);
 
-		freed = iwl_tx_queue_reclaim(priv, txq_id, index);
+		freed = iwlagn_tx_queue_reclaim(priv, txq_id, index);
 		iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
 
 		if (priv->mac80211_registered &&
@@ -244,7 +244,7 @@ static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
 			iwl_wake_queue(priv, txq_id);
 	}
 
-	iwl_txq_check_empty(priv, sta_id, tid, txq_id);
+	iwlagn_txq_check_empty(priv, sta_id, tid, txq_id);
 
 	if (iwl_check_bits(status, TX_ABORT_REQUIRED_MSK))
 		IWL_ERR(priv, "TODO:  Implement Tx ABORT REQUIRED!!!\n");
@@ -381,3 +381,133 @@ struct iwl_mod_params iwlagn_mod_params = {
 	.restart_fw = 1,
 	/* the rest are 0 by default */
 };
+
+void iwlagn_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
+{
+	unsigned long flags;
+	int i;
+	spin_lock_irqsave(&rxq->lock, flags);
+	INIT_LIST_HEAD(&rxq->rx_free);
+	INIT_LIST_HEAD(&rxq->rx_used);
+	/* Fill the rx_used queue with _all_ of the Rx buffers */
+	for (i = 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++) {
+		/* In the reset function, these buffers may have been allocated
+		 * to an SKB, so we need to unmap and free potential storage */
+		if (rxq->pool[i].page != NULL) {
+			pci_unmap_page(priv->pci_dev, rxq->pool[i].page_dma,
+				PAGE_SIZE << priv->hw_params.rx_page_order,
+				PCI_DMA_FROMDEVICE);
+			__iwl_free_pages(priv, rxq->pool[i].page);
+			rxq->pool[i].page = NULL;
+		}
+		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
+	}
+
+	/* Set us so that we have processed and used all buffers, but have
+	 * not restocked the Rx queue with fresh buffers */
+	rxq->read = rxq->write = 0;
+	rxq->write_actual = 0;
+	rxq->free_count = 0;
+	spin_unlock_irqrestore(&rxq->lock, flags);
+}
+
+int iwlagn_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
+{
+	u32 rb_size;
+	const u32 rfdnlog = RX_QUEUE_SIZE_LOG; /* 256 RBDs */
+	u32 rb_timeout = 0; /* FIXME: RX_RB_TIMEOUT for all devices? */
+
+	if (!priv->cfg->use_isr_legacy)
+		rb_timeout = RX_RB_TIMEOUT;
+
+	if (priv->cfg->mod_params->amsdu_size_8K)
+		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_8K;
+	else
+		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_4K;
+
+	/* Stop Rx DMA */
+	iwl_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
+
+	/* Reset driver's Rx queue write index */
+	iwl_write_direct32(priv, FH_RSCSR_CHNL0_RBDCB_WPTR_REG, 0);
+
+	/* Tell device where to find RBD circular buffer in DRAM */
+	iwl_write_direct32(priv, FH_RSCSR_CHNL0_RBDCB_BASE_REG,
+			   (u32)(rxq->dma_addr >> 8));
+
+	/* Tell device where in DRAM to update its Rx status */
+	iwl_write_direct32(priv, FH_RSCSR_CHNL0_STTS_WPTR_REG,
+			   rxq->rb_stts_dma >> 4);
+
+	/* Enable Rx DMA
+	 * FH_RCSR_CHNL0_RX_IGNORE_RXF_EMPTY is set because of HW bug in
+	 *      the credit mechanism in 5000 HW RX FIFO
+	 * Direct rx interrupts to hosts
+	 * Rx buffer size 4 or 8k
+	 * RB timeout 0x10
+	 * 256 RBDs
+	 */
+	iwl_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG,
+			   FH_RCSR_RX_CONFIG_CHNL_EN_ENABLE_VAL |
+			   FH_RCSR_CHNL0_RX_IGNORE_RXF_EMPTY |
+			   FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL |
+			   FH_RCSR_CHNL0_RX_CONFIG_SINGLE_FRAME_MSK |
+			   rb_size|
+			   (rb_timeout << FH_RCSR_RX_CONFIG_REG_IRQ_RBTH_POS)|
+			   (rfdnlog << FH_RCSR_RX_CONFIG_RBDCB_SIZE_POS));
+
+	/* Set interrupt coalescing timer to default (2048 usecs) */
+	iwl_write8(priv, CSR_INT_COALESCING, IWL_HOST_INT_TIMEOUT_DEF);
+
+	return 0;
+}
+
+int iwlagn_hw_nic_init(struct iwl_priv *priv)
+{
+	unsigned long flags;
+	struct iwl_rx_queue *rxq = &priv->rxq;
+	int ret;
+
+	/* nic_init */
+	spin_lock_irqsave(&priv->lock, flags);
+	priv->cfg->ops->lib->apm_ops.init(priv);
+
+	/* Set interrupt coalescing calibration timer to default (512 usecs) */
+	iwl_write8(priv, CSR_INT_COALESCING, IWL_HOST_INT_CALIB_TIMEOUT_DEF);
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	ret = priv->cfg->ops->lib->apm_ops.set_pwr_src(priv, IWL_PWR_SRC_VMAIN);
+
+	priv->cfg->ops->lib->apm_ops.config(priv);
+
+	/* Allocate the RX queue, or reset if it is already allocated */
+	if (!rxq->bd) {
+		ret = iwl_rx_queue_alloc(priv);
+		if (ret) {
+			IWL_ERR(priv, "Unable to initialize Rx queue\n");
+			return -ENOMEM;
+		}
+	} else
+		iwlagn_rx_queue_reset(priv, rxq);
+
+	iwl_rx_replenish(priv);
+
+	iwlagn_rx_init(priv, rxq);
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	rxq->need_update = 1;
+	iwl_rx_queue_update_write_ptr(priv, rxq);
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	/* Allocate and init all Tx and Command queues */
+	ret = iwlagn_txq_ctx_reset(priv);
+	if (ret)
+		return ret;
+
+	set_bit(STATUS_INIT, &priv->status);
+
+	return 0;
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 43bdd9d..4e4b70d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -36,8 +36,61 @@
 #include "iwl-core.h"
 #include "iwl-sta.h"
 #include "iwl-io.h"
+#include "iwl-helpers.h"
 #include "iwl-agn-hw.h"
 
+/*
+ * mac80211 queues, ACs, hardware queues, FIFOs.
+ *
+ * Cf. http://wireless.kernel.org/en/developers/Documentation/mac80211/queues
+ *
+ * Mac80211 uses the following numbers, which we get as from it
+ * by way of skb_get_queue_mapping(skb):
+ *
+ *	VO	0
+ *	VI	1
+ *	BE	2
+ *	BK	3
+ *
+ *
+ * Regular (not A-MPDU) frames are put into hardware queues corresponding
+ * to the FIFOs, see comments in iwl-prph.h. Aggregated frames get their
+ * own queue per aggregation session (RA/TID combination), such queues are
+ * set up to map into FIFOs too, for which we need an AC->FIFO mapping. In
+ * order to map frames to the right queue, we also need an AC->hw queue
+ * mapping. This is implemented here.
+ *
+ * Due to the way hw queues are set up (by the hw specific modules like
+ * iwl-4965.c, iwl-5000.c etc.), the AC->hw queue mapping is the identity
+ * mapping.
+ */
+
+static const u8 tid_to_ac[] = {
+	/* this matches the mac80211 numbers */
+	2, 3, 3, 2, 1, 1, 0, 0
+};
+
+static const u8 ac_to_fifo[] = {
+	IWL_TX_FIFO_VO,
+	IWL_TX_FIFO_VI,
+	IWL_TX_FIFO_BE,
+	IWL_TX_FIFO_BK,
+};
+
+static inline int get_fifo_from_ac(u8 ac)
+{
+	return ac_to_fifo[ac];
+}
+
+static inline int get_fifo_from_tid(u16 tid)
+{
+	if (likely(tid < ARRAY_SIZE(tid_to_ac)))
+		return get_fifo_from_ac(tid_to_ac[tid]);
+
+	/* no support for TIDs 8-15 yet */
+	return -EINVAL;
+}
+
 /**
  * iwlagn_txq_update_byte_cnt_tbl - Set up entry in Tx byte-count array
  */
@@ -266,3 +319,972 @@ void iwlagn_txq_set_sched(struct iwl_priv *priv, u32 mask)
 {
 	iwl_write_prph(priv, IWL50_SCD_TXFACT, mask);
 }
+
+static inline int get_queue_from_ac(u16 ac)
+{
+	return ac;
+}
+
+/*
+ * handle build REPLY_TX command notification.
+ */
+static void iwlagn_tx_cmd_build_basic(struct iwl_priv *priv,
+				  struct iwl_tx_cmd *tx_cmd,
+				  struct ieee80211_tx_info *info,
+				  struct ieee80211_hdr *hdr,
+				  u8 std_id)
+{
+	__le16 fc = hdr->frame_control;
+	__le32 tx_flags = tx_cmd->tx_flags;
+
+	tx_cmd->stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
+	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
+		tx_flags |= TX_CMD_FLG_ACK_MSK;
+		if (ieee80211_is_mgmt(fc))
+			tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
+		if (ieee80211_is_probe_resp(fc) &&
+		    !(le16_to_cpu(hdr->seq_ctrl) & 0xf))
+			tx_flags |= TX_CMD_FLG_TSF_MSK;
+	} else {
+		tx_flags &= (~TX_CMD_FLG_ACK_MSK);
+		tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
+	}
+
+	if (ieee80211_is_back_req(fc))
+		tx_flags |= TX_CMD_FLG_ACK_MSK | TX_CMD_FLG_IMM_BA_RSP_MASK;
+
+
+	tx_cmd->sta_id = std_id;
+	if (ieee80211_has_morefrags(fc))
+		tx_flags |= TX_CMD_FLG_MORE_FRAG_MSK;
+
+	if (ieee80211_is_data_qos(fc)) {
+		u8 *qc = ieee80211_get_qos_ctl(hdr);
+		tx_cmd->tid_tspec = qc[0] & 0xf;
+		tx_flags &= ~TX_CMD_FLG_SEQ_CTL_MSK;
+	} else {
+		tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
+	}
+
+	priv->cfg->ops->utils->rts_tx_cmd_flag(info, &tx_flags);
+
+	if ((tx_flags & TX_CMD_FLG_RTS_MSK) || (tx_flags & TX_CMD_FLG_CTS_MSK))
+		tx_flags |= TX_CMD_FLG_FULL_TXOP_PROT_MSK;
+
+	tx_flags &= ~(TX_CMD_FLG_ANT_SEL_MSK);
+	if (ieee80211_is_mgmt(fc)) {
+		if (ieee80211_is_assoc_req(fc) || ieee80211_is_reassoc_req(fc))
+			tx_cmd->timeout.pm_frame_timeout = cpu_to_le16(3);
+		else
+			tx_cmd->timeout.pm_frame_timeout = cpu_to_le16(2);
+	} else {
+		tx_cmd->timeout.pm_frame_timeout = 0;
+	}
+
+	tx_cmd->driver_txop = 0;
+	tx_cmd->tx_flags = tx_flags;
+	tx_cmd->next_frame_len = 0;
+}
+
+#define RTS_DFAULT_RETRY_LIMIT		60
+
+static void iwlagn_tx_cmd_build_rate(struct iwl_priv *priv,
+			      struct iwl_tx_cmd *tx_cmd,
+			      struct ieee80211_tx_info *info,
+			      __le16 fc)
+{
+	u32 rate_flags;
+	int rate_idx;
+	u8 rts_retry_limit;
+	u8 data_retry_limit;
+	u8 rate_plcp;
+
+	/* Set retry limit on DATA packets and Probe Responses*/
+	if (ieee80211_is_probe_resp(fc))
+		data_retry_limit = 3;
+	else
+		data_retry_limit = IWL_DEFAULT_TX_RETRY;
+	tx_cmd->data_retry_limit = data_retry_limit;
+
+	/* Set retry limit on RTS packets */
+	rts_retry_limit = RTS_DFAULT_RETRY_LIMIT;
+	if (data_retry_limit < rts_retry_limit)
+		rts_retry_limit = data_retry_limit;
+	tx_cmd->rts_retry_limit = rts_retry_limit;
+
+	/* DATA packets will use the uCode station table for rate/antenna
+	 * selection */
+	if (ieee80211_is_data(fc)) {
+		tx_cmd->initial_rate_index = 0;
+		tx_cmd->tx_flags |= TX_CMD_FLG_STA_RATE_MSK;
+		return;
+	}
+
+	/**
+	 * If the current TX rate stored in mac80211 has the MCS bit set, it's
+	 * not really a TX rate.  Thus, we use the lowest supported rate for
+	 * this band.  Also use the lowest supported rate if the stored rate
+	 * index is invalid.
+	 */
+	rate_idx = info->control.rates[0].idx;
+	if (info->control.rates[0].flags & IEEE80211_TX_RC_MCS ||
+			(rate_idx < 0) || (rate_idx > IWL_RATE_COUNT_LEGACY))
+		rate_idx = rate_lowest_index(&priv->bands[info->band],
+				info->control.sta);
+	/* For 5 GHZ band, remap mac80211 rate indices into driver indices */
+	if (info->band == IEEE80211_BAND_5GHZ)
+		rate_idx += IWL_FIRST_OFDM_RATE;
+	/* Get PLCP rate for tx_cmd->rate_n_flags */
+	rate_plcp = iwl_rates[rate_idx].plcp;
+	/* Zero out flags for this packet */
+	rate_flags = 0;
+
+	/* Set CCK flag as needed */
+	if ((rate_idx >= IWL_FIRST_CCK_RATE) && (rate_idx <= IWL_LAST_CCK_RATE))
+		rate_flags |= RATE_MCS_CCK_MSK;
+
+	/* Set up RTS and CTS flags for certain packets */
+	switch (fc & cpu_to_le16(IEEE80211_FCTL_STYPE)) {
+	case cpu_to_le16(IEEE80211_STYPE_AUTH):
+	case cpu_to_le16(IEEE80211_STYPE_DEAUTH):
+	case cpu_to_le16(IEEE80211_STYPE_ASSOC_REQ):
+	case cpu_to_le16(IEEE80211_STYPE_REASSOC_REQ):
+		if (tx_cmd->tx_flags & TX_CMD_FLG_RTS_MSK) {
+			tx_cmd->tx_flags &= ~TX_CMD_FLG_RTS_MSK;
+			tx_cmd->tx_flags |= TX_CMD_FLG_CTS_MSK;
+		}
+		break;
+	default:
+		break;
+	}
+
+	/* Set up antennas */
+	priv->mgmt_tx_ant = iwl_toggle_tx_ant(priv, priv->mgmt_tx_ant);
+	rate_flags |= iwl_ant_idx_to_flags(priv->mgmt_tx_ant);
+
+	/* Set the rate in the TX cmd */
+	tx_cmd->rate_n_flags = iwl_hw_set_rate_n_flags(rate_plcp, rate_flags);
+}
+
+static void iwlagn_tx_cmd_build_hwcrypto(struct iwl_priv *priv,
+				      struct ieee80211_tx_info *info,
+				      struct iwl_tx_cmd *tx_cmd,
+				      struct sk_buff *skb_frag,
+				      int sta_id)
+{
+	struct ieee80211_key_conf *keyconf = info->control.hw_key;
+
+	switch (keyconf->alg) {
+	case ALG_CCMP:
+		tx_cmd->sec_ctl = TX_CMD_SEC_CCM;
+		memcpy(tx_cmd->key, keyconf->key, keyconf->keylen);
+		if (info->flags & IEEE80211_TX_CTL_AMPDU)
+			tx_cmd->tx_flags |= TX_CMD_FLG_AGG_CCMP_MSK;
+		IWL_DEBUG_TX(priv, "tx_cmd with AES hwcrypto\n");
+		break;
+
+	case ALG_TKIP:
+		tx_cmd->sec_ctl = TX_CMD_SEC_TKIP;
+		ieee80211_get_tkip_key(keyconf, skb_frag,
+			IEEE80211_TKIP_P2_KEY, tx_cmd->key);
+		IWL_DEBUG_TX(priv, "tx_cmd with tkip hwcrypto\n");
+		break;
+
+	case ALG_WEP:
+		tx_cmd->sec_ctl |= (TX_CMD_SEC_WEP |
+			(keyconf->keyidx & TX_CMD_SEC_MSK) << TX_CMD_SEC_SHIFT);
+
+		if (keyconf->keylen == WEP_KEY_LEN_128)
+			tx_cmd->sec_ctl |= TX_CMD_SEC_KEY128;
+
+		memcpy(&tx_cmd->key[3], keyconf->key, keyconf->keylen);
+
+		IWL_DEBUG_TX(priv, "Configuring packet for WEP encryption "
+			     "with key %d\n", keyconf->keyidx);
+		break;
+
+	default:
+		IWL_ERR(priv, "Unknown encode alg %d\n", keyconf->alg);
+		break;
+	}
+}
+
+/*
+ * start REPLY_TX command process
+ */
+int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_sta *sta = info->control.sta;
+	struct iwl_station_priv *sta_priv = NULL;
+	struct iwl_tx_queue *txq;
+	struct iwl_queue *q;
+	struct iwl_device_cmd *out_cmd;
+	struct iwl_cmd_meta *out_meta;
+	struct iwl_tx_cmd *tx_cmd;
+	int swq_id, txq_id;
+	dma_addr_t phys_addr;
+	dma_addr_t txcmd_phys;
+	dma_addr_t scratch_phys;
+	u16 len, len_org, firstlen, secondlen;
+	u16 seq_number = 0;
+	__le16 fc;
+	u8 hdr_len;
+	u8 sta_id;
+	u8 wait_write_ptr = 0;
+	u8 tid = 0;
+	u8 *qc = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	if (iwl_is_rfkill(priv)) {
+		IWL_DEBUG_DROP(priv, "Dropping - RF KILL\n");
+		goto drop_unlock;
+	}
+
+	fc = hdr->frame_control;
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (ieee80211_is_auth(fc))
+		IWL_DEBUG_TX(priv, "Sending AUTH frame\n");
+	else if (ieee80211_is_assoc_req(fc))
+		IWL_DEBUG_TX(priv, "Sending ASSOC frame\n");
+	else if (ieee80211_is_reassoc_req(fc))
+		IWL_DEBUG_TX(priv, "Sending REASSOC frame\n");
+#endif
+
+	hdr_len = ieee80211_hdrlen(fc);
+
+	/* Find (or create) index into station table for destination station */
+	if (info->flags & IEEE80211_TX_CTL_INJECTED)
+		sta_id = priv->hw_params.bcast_sta_id;
+	else
+		sta_id = iwl_get_sta_id(priv, hdr);
+	if (sta_id == IWL_INVALID_STATION) {
+		IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
+			       hdr->addr1);
+		goto drop_unlock;
+	}
+
+	IWL_DEBUG_TX(priv, "station Id %d\n", sta_id);
+
+	if (sta)
+		sta_priv = (void *)sta->drv_priv;
+
+	if (sta_priv && sta_id != priv->hw_params.bcast_sta_id &&
+	    sta_priv->asleep) {
+		WARN_ON(!(info->flags & IEEE80211_TX_CTL_PSPOLL_RESPONSE));
+		/*
+		 * This sends an asynchronous command to the device,
+		 * but we can rely on it being processed before the
+		 * next frame is processed -- and the next frame to
+		 * this station is the one that will consume this
+		 * counter.
+		 * For now set the counter to just 1 since we do not
+		 * support uAPSD yet.
+		 */
+		iwl_sta_modify_sleep_tx_count(priv, sta_id, 1);
+	}
+
+	txq_id = get_queue_from_ac(skb_get_queue_mapping(skb));
+	if (ieee80211_is_data_qos(fc)) {
+		qc = ieee80211_get_qos_ctl(hdr);
+		tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
+		if (unlikely(tid >= MAX_TID_COUNT))
+			goto drop_unlock;
+		seq_number = priv->stations[sta_id].tid[tid].seq_number;
+		seq_number &= IEEE80211_SCTL_SEQ;
+		hdr->seq_ctrl = hdr->seq_ctrl &
+				cpu_to_le16(IEEE80211_SCTL_FRAG);
+		hdr->seq_ctrl |= cpu_to_le16(seq_number);
+		seq_number += 0x10;
+		/* aggregation is on for this <sta,tid> */
+		if (info->flags & IEEE80211_TX_CTL_AMPDU &&
+		    priv->stations[sta_id].tid[tid].agg.state == IWL_AGG_ON) {
+			txq_id = priv->stations[sta_id].tid[tid].agg.txq_id;
+		}
+	}
+
+	txq = &priv->txq[txq_id];
+	swq_id = txq->swq_id;
+	q = &txq->q;
+
+	if (unlikely(iwl_queue_space(q) < q->high_mark))
+		goto drop_unlock;
+
+	if (ieee80211_is_data_qos(fc))
+		priv->stations[sta_id].tid[tid].tfds_in_queue++;
+
+	/* Set up driver data for this TFD */
+	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct iwl_tx_info));
+	txq->txb[q->write_ptr].skb[0] = skb;
+
+	/* Set up first empty entry in queue's array of Tx/cmd buffers */
+	out_cmd = txq->cmd[q->write_ptr];
+	out_meta = &txq->meta[q->write_ptr];
+	tx_cmd = &out_cmd->cmd.tx;
+	memset(&out_cmd->hdr, 0, sizeof(out_cmd->hdr));
+	memset(tx_cmd, 0, sizeof(struct iwl_tx_cmd));
+
+	/*
+	 * Set up the Tx-command (not MAC!) header.
+	 * Store the chosen Tx queue and TFD index within the sequence field;
+	 * after Tx, uCode's Tx response will return this value so driver can
+	 * locate the frame within the tx queue and do post-tx processing.
+	 */
+	out_cmd->hdr.cmd = REPLY_TX;
+	out_cmd->hdr.sequence = cpu_to_le16((u16)(QUEUE_TO_SEQ(txq_id) |
+				INDEX_TO_SEQ(q->write_ptr)));
+
+	/* Copy MAC header from skb into command buffer */
+	memcpy(tx_cmd->hdr, hdr, hdr_len);
+
+
+	/* Total # bytes to be transmitted */
+	len = (u16)skb->len;
+	tx_cmd->len = cpu_to_le16(len);
+
+	if (info->control.hw_key)
+		iwlagn_tx_cmd_build_hwcrypto(priv, info, tx_cmd, skb, sta_id);
+
+	/* TODO need this for burst mode later on */
+	iwlagn_tx_cmd_build_basic(priv, tx_cmd, info, hdr, sta_id);
+	iwl_dbg_log_tx_data_frame(priv, len, hdr);
+
+	iwlagn_tx_cmd_build_rate(priv, tx_cmd, info, fc);
+
+	iwl_update_stats(priv, true, fc, len);
+	/*
+	 * Use the first empty entry in this queue's command buffer array
+	 * to contain the Tx command and MAC header concatenated together
+	 * (payload data will be in another buffer).
+	 * Size of this varies, due to varying MAC header length.
+	 * If end is not dword aligned, we'll have 2 extra bytes at the end
+	 * of the MAC header (device reads on dword boundaries).
+	 * We'll tell device about this padding later.
+	 */
+	len = sizeof(struct iwl_tx_cmd) +
+		sizeof(struct iwl_cmd_header) + hdr_len;
+
+	len_org = len;
+	firstlen = len = (len + 3) & ~3;
+
+	if (len_org != len)
+		len_org = 1;
+	else
+		len_org = 0;
+
+	/* Tell NIC about any 2-byte padding after MAC header */
+	if (len_org)
+		tx_cmd->tx_flags |= TX_CMD_FLG_MH_PAD_MSK;
+
+	/* Physical address of this Tx command's header (not MAC header!),
+	 * within command buffer array. */
+	txcmd_phys = pci_map_single(priv->pci_dev,
+				    &out_cmd->hdr, len,
+				    PCI_DMA_BIDIRECTIONAL);
+	pci_unmap_addr_set(out_meta, mapping, txcmd_phys);
+	pci_unmap_len_set(out_meta, len, len);
+	/* Add buffer containing Tx command and MAC(!) header to TFD's
+	 * first entry */
+	priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
+						   txcmd_phys, len, 1, 0);
+
+	if (!ieee80211_has_morefrags(hdr->frame_control)) {
+		txq->need_update = 1;
+		if (qc)
+			priv->stations[sta_id].tid[tid].seq_number = seq_number;
+	} else {
+		wait_write_ptr = 1;
+		txq->need_update = 0;
+	}
+
+	/* Set up TFD's 2nd entry to point directly to remainder of skb,
+	 * if any (802.11 null frames have no payload). */
+	secondlen = len = skb->len - hdr_len;
+	if (len) {
+		phys_addr = pci_map_single(priv->pci_dev, skb->data + hdr_len,
+					   len, PCI_DMA_TODEVICE);
+		priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
+							   phys_addr, len,
+							   0, 0);
+	}
+
+	scratch_phys = txcmd_phys + sizeof(struct iwl_cmd_header) +
+				offsetof(struct iwl_tx_cmd, scratch);
+
+	len = sizeof(struct iwl_tx_cmd) +
+		sizeof(struct iwl_cmd_header) + hdr_len;
+	/* take back ownership of DMA buffer to enable update */
+	pci_dma_sync_single_for_cpu(priv->pci_dev, txcmd_phys,
+				    len, PCI_DMA_BIDIRECTIONAL);
+	tx_cmd->dram_lsb_ptr = cpu_to_le32(scratch_phys);
+	tx_cmd->dram_msb_ptr = iwl_get_dma_hi_addr(scratch_phys);
+
+	IWL_DEBUG_TX(priv, "sequence nr = 0X%x \n",
+		     le16_to_cpu(out_cmd->hdr.sequence));
+	IWL_DEBUG_TX(priv, "tx_flags = 0X%x \n", le32_to_cpu(tx_cmd->tx_flags));
+	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx_cmd, sizeof(*tx_cmd));
+	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx_cmd->hdr, hdr_len);
+
+	/* Set up entry for this TFD in Tx byte-count array */
+	if (info->flags & IEEE80211_TX_CTL_AMPDU)
+		priv->cfg->ops->lib->txq_update_byte_cnt_tbl(priv, txq,
+						     le16_to_cpu(tx_cmd->len));
+
+	pci_dma_sync_single_for_device(priv->pci_dev, txcmd_phys,
+				       len, PCI_DMA_BIDIRECTIONAL);
+
+	trace_iwlwifi_dev_tx(priv,
+			     &((struct iwl_tfd *)txq->tfds)[txq->q.write_ptr],
+			     sizeof(struct iwl_tfd),
+			     &out_cmd->hdr, firstlen,
+			     skb->data + hdr_len, secondlen);
+
+	/* Tell device the write index *just past* this latest filled TFD */
+	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
+	iwl_txq_update_write_ptr(priv, txq);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	/*
+	 * At this point the frame is "transmitted" successfully
+	 * and we will get a TX status notification eventually,
+	 * regardless of the value of ret. "ret" only indicates
+	 * whether or not we should update the write pointer.
+	 */
+
+	/* avoid atomic ops if it isn't an associated client */
+	if (sta_priv && sta_priv->client)
+		atomic_inc(&sta_priv->pending_frames);
+
+	if ((iwl_queue_space(q) < q->high_mark) && priv->mac80211_registered) {
+		if (wait_write_ptr) {
+			spin_lock_irqsave(&priv->lock, flags);
+			txq->need_update = 1;
+			iwl_txq_update_write_ptr(priv, txq);
+			spin_unlock_irqrestore(&priv->lock, flags);
+		} else {
+			iwl_stop_queue(priv, txq->swq_id);
+		}
+	}
+
+	return 0;
+
+drop_unlock:
+	spin_unlock_irqrestore(&priv->lock, flags);
+	return -1;
+}
+
+static inline int iwlagn_alloc_dma_ptr(struct iwl_priv *priv,
+				    struct iwl_dma_ptr *ptr, size_t size)
+{
+	ptr->addr = dma_alloc_coherent(&priv->pci_dev->dev, size, &ptr->dma,
+				       GFP_KERNEL);
+	if (!ptr->addr)
+		return -ENOMEM;
+	ptr->size = size;
+	return 0;
+}
+
+static inline void iwlagn_free_dma_ptr(struct iwl_priv *priv,
+				    struct iwl_dma_ptr *ptr)
+{
+	if (unlikely(!ptr->addr))
+		return;
+
+	dma_free_coherent(&priv->pci_dev->dev, ptr->size, ptr->addr, ptr->dma);
+	memset(ptr, 0, sizeof(*ptr));
+}
+
+/**
+ * iwlagn_hw_txq_ctx_free - Free TXQ Context
+ *
+ * Destroy all TX DMA queues and structures
+ */
+void iwlagn_hw_txq_ctx_free(struct iwl_priv *priv)
+{
+	int txq_id;
+
+	/* Tx queues */
+	if (priv->txq) {
+		for (txq_id = 0; txq_id < priv->hw_params.max_txq_num;
+		     txq_id++)
+			if (txq_id == IWL_CMD_QUEUE_NUM)
+				iwl_cmd_queue_free(priv);
+			else
+				iwl_tx_queue_free(priv, txq_id);
+	}
+	iwlagn_free_dma_ptr(priv, &priv->kw);
+
+	iwlagn_free_dma_ptr(priv, &priv->scd_bc_tbls);
+
+	/* free tx queue structure */
+	iwl_free_txq_mem(priv);
+}
+
+/**
+ * iwlagn_txq_ctx_reset - Reset TX queue context
+ * Destroys all DMA structures and initialize them again
+ *
+ * @param priv
+ * @return error code
+ */
+int iwlagn_txq_ctx_reset(struct iwl_priv *priv)
+{
+	int ret = 0;
+	int txq_id, slots_num;
+	unsigned long flags;
+
+	/* Free all tx/cmd queues and keep-warm buffer */
+	iwlagn_hw_txq_ctx_free(priv);
+
+	ret = iwlagn_alloc_dma_ptr(priv, &priv->scd_bc_tbls,
+				priv->hw_params.scd_bc_tbls_size);
+	if (ret) {
+		IWL_ERR(priv, "Scheduler BC Table allocation failed\n");
+		goto error_bc_tbls;
+	}
+	/* Alloc keep-warm buffer */
+	ret = iwlagn_alloc_dma_ptr(priv, &priv->kw, IWL_KW_SIZE);
+	if (ret) {
+		IWL_ERR(priv, "Keep Warm allocation failed\n");
+		goto error_kw;
+	}
+
+	/* allocate tx queue structure */
+	ret = iwl_alloc_txq_mem(priv);
+	if (ret)
+		goto error;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	/* Turn off all Tx DMA fifos */
+	priv->cfg->ops->lib->txq_set_sched(priv, 0);
+
+	/* Tell NIC where to find the "keep warm" buffer */
+	iwl_write_direct32(priv, FH_KW_MEM_ADDR_REG, priv->kw.dma >> 4);
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	/* Alloc and init all Tx queues, including the command queue (#4) */
+	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++) {
+		slots_num = (txq_id == IWL_CMD_QUEUE_NUM) ?
+					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
+		ret = iwl_tx_queue_init(priv, &priv->txq[txq_id], slots_num,
+				       txq_id);
+		if (ret) {
+			IWL_ERR(priv, "Tx %d queue init failed\n", txq_id);
+			goto error;
+		}
+	}
+
+	return ret;
+
+ error:
+	iwlagn_hw_txq_ctx_free(priv);
+	iwlagn_free_dma_ptr(priv, &priv->kw);
+ error_kw:
+	iwlagn_free_dma_ptr(priv, &priv->scd_bc_tbls);
+ error_bc_tbls:
+	return ret;
+}
+
+/**
+ * iwlagn_txq_ctx_stop - Stop all Tx DMA channels, free Tx queue memory
+ */
+void iwlagn_txq_ctx_stop(struct iwl_priv *priv)
+{
+	int ch;
+	unsigned long flags;
+
+	/* Turn off all Tx DMA fifos */
+	spin_lock_irqsave(&priv->lock, flags);
+
+	priv->cfg->ops->lib->txq_set_sched(priv, 0);
+
+	/* Stop each Tx DMA channel, and wait for it to be idle */
+	for (ch = 0; ch < priv->hw_params.dma_chnl_num; ch++) {
+		iwl_write_direct32(priv, FH_TCSR_CHNL_TX_CONFIG_REG(ch), 0x0);
+		iwl_poll_direct_bit(priv, FH_TSSR_TX_STATUS_REG,
+				    FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(ch),
+				    1000);
+	}
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	/* Deallocate memory for all Tx queues */
+	iwlagn_hw_txq_ctx_free(priv);
+}
+
+/*
+ * Find first available (lowest unused) Tx Queue, mark it "active".
+ * Called only when finding queue for aggregation.
+ * Should never return anything < 7, because they should already
+ * be in use as EDCA AC (0-3), Command (4), reserved (5, 6)
+ */
+static int iwlagn_txq_ctx_activate_free(struct iwl_priv *priv)
+{
+	int txq_id;
+
+	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++)
+		if (!test_and_set_bit(txq_id, &priv->txq_ctx_active_msk))
+			return txq_id;
+	return -1;
+}
+
+int iwlagn_tx_agg_start(struct iwl_priv *priv, const u8 *ra, u16 tid, u16 *ssn)
+{
+	int sta_id;
+	int tx_fifo;
+	int txq_id;
+	int ret;
+	unsigned long flags;
+	struct iwl_tid_data *tid_data;
+
+	tx_fifo = get_fifo_from_tid(tid);
+	if (unlikely(tx_fifo < 0))
+		return tx_fifo;
+
+	IWL_WARN(priv, "%s on ra = %pM tid = %d\n",
+			__func__, ra, tid);
+
+	sta_id = iwl_find_station(priv, ra);
+	if (sta_id == IWL_INVALID_STATION) {
+		IWL_ERR(priv, "Start AGG on invalid station\n");
+		return -ENXIO;
+	}
+	if (unlikely(tid >= MAX_TID_COUNT))
+		return -EINVAL;
+
+	if (priv->stations[sta_id].tid[tid].agg.state != IWL_AGG_OFF) {
+		IWL_ERR(priv, "Start AGG when state is not IWL_AGG_OFF !\n");
+		return -ENXIO;
+	}
+
+	txq_id = iwlagn_txq_ctx_activate_free(priv);
+	if (txq_id == -1) {
+		IWL_ERR(priv, "No free aggregation queue available\n");
+		return -ENXIO;
+	}
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	tid_data = &priv->stations[sta_id].tid[tid];
+	*ssn = SEQ_TO_SN(tid_data->seq_number);
+	tid_data->agg.txq_id = txq_id;
+	priv->txq[txq_id].swq_id = iwl_virtual_agg_queue_num(tx_fifo, txq_id);
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	ret = priv->cfg->ops->lib->txq_agg_enable(priv, txq_id, tx_fifo,
+						  sta_id, tid, *ssn);
+	if (ret)
+		return ret;
+
+	if (tid_data->tfds_in_queue == 0) {
+		IWL_DEBUG_HT(priv, "HW queue is empty\n");
+		tid_data->agg.state = IWL_AGG_ON;
+		ieee80211_start_tx_ba_cb_irqsafe(priv->vif, ra, tid);
+	} else {
+		IWL_DEBUG_HT(priv, "HW queue is NOT empty: %d packets in HW queue\n",
+			     tid_data->tfds_in_queue);
+		tid_data->agg.state = IWL_EMPTYING_HW_QUEUE_ADDBA;
+	}
+	return ret;
+}
+
+int iwlagn_tx_agg_stop(struct iwl_priv *priv , const u8 *ra, u16 tid)
+{
+	int tx_fifo_id, txq_id, sta_id, ssn = -1;
+	struct iwl_tid_data *tid_data;
+	int write_ptr, read_ptr;
+	unsigned long flags;
+
+	if (!ra) {
+		IWL_ERR(priv, "ra = NULL\n");
+		return -EINVAL;
+	}
+
+	tx_fifo_id = get_fifo_from_tid(tid);
+	if (unlikely(tx_fifo_id < 0))
+		return tx_fifo_id;
+
+	sta_id = iwl_find_station(priv, ra);
+
+	if (sta_id == IWL_INVALID_STATION) {
+		IWL_ERR(priv, "Invalid station for AGG tid %d\n", tid);
+		return -ENXIO;
+	}
+
+	if (priv->stations[sta_id].tid[tid].agg.state ==
+				IWL_EMPTYING_HW_QUEUE_ADDBA) {
+		IWL_DEBUG_HT(priv, "AGG stop before setup done\n");
+		ieee80211_stop_tx_ba_cb_irqsafe(priv->vif, ra, tid);
+		priv->stations[sta_id].tid[tid].agg.state = IWL_AGG_OFF;
+		return 0;
+	}
+
+	if (priv->stations[sta_id].tid[tid].agg.state != IWL_AGG_ON)
+		IWL_WARN(priv, "Stopping AGG while state not ON or starting\n");
+
+	tid_data = &priv->stations[sta_id].tid[tid];
+	ssn = (tid_data->seq_number & IEEE80211_SCTL_SEQ) >> 4;
+	txq_id = tid_data->agg.txq_id;
+	write_ptr = priv->txq[txq_id].q.write_ptr;
+	read_ptr = priv->txq[txq_id].q.read_ptr;
+
+	/* The queue is not empty */
+	if (write_ptr != read_ptr) {
+		IWL_DEBUG_HT(priv, "Stopping a non empty AGG HW QUEUE\n");
+		priv->stations[sta_id].tid[tid].agg.state =
+				IWL_EMPTYING_HW_QUEUE_DELBA;
+		return 0;
+	}
+
+	IWL_DEBUG_HT(priv, "HW queue is empty\n");
+	priv->stations[sta_id].tid[tid].agg.state = IWL_AGG_OFF;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	/*
+	 * the only reason this call can fail is queue number out of range,
+	 * which can happen if uCode is reloaded and all the station
+	 * information are lost. if it is outside the range, there is no need
+	 * to deactivate the uCode queue, just return "success" to allow
+	 *  mac80211 to clean up it own data.
+	 */
+	priv->cfg->ops->lib->txq_agg_disable(priv, txq_id, ssn,
+						   tx_fifo_id);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	ieee80211_stop_tx_ba_cb_irqsafe(priv->vif, ra, tid);
+
+	return 0;
+}
+
+int iwlagn_txq_check_empty(struct iwl_priv *priv,
+			   int sta_id, u8 tid, int txq_id)
+{
+	struct iwl_queue *q = &priv->txq[txq_id].q;
+	u8 *addr = priv->stations[sta_id].sta.sta.addr;
+	struct iwl_tid_data *tid_data = &priv->stations[sta_id].tid[tid];
+
+	switch (priv->stations[sta_id].tid[tid].agg.state) {
+	case IWL_EMPTYING_HW_QUEUE_DELBA:
+		/* We are reclaiming the last packet of the */
+		/* aggregated HW queue */
+		if ((txq_id  == tid_data->agg.txq_id) &&
+		    (q->read_ptr == q->write_ptr)) {
+			u16 ssn = SEQ_TO_SN(tid_data->seq_number);
+			int tx_fifo = get_fifo_from_tid(tid);
+			IWL_DEBUG_HT(priv, "HW queue empty: continue DELBA flow\n");
+			priv->cfg->ops->lib->txq_agg_disable(priv, txq_id,
+							     ssn, tx_fifo);
+			tid_data->agg.state = IWL_AGG_OFF;
+			ieee80211_stop_tx_ba_cb_irqsafe(priv->vif, addr, tid);
+		}
+		break;
+	case IWL_EMPTYING_HW_QUEUE_ADDBA:
+		/* We are reclaiming the last packet of the queue */
+		if (tid_data->tfds_in_queue == 0) {
+			IWL_DEBUG_HT(priv, "HW queue empty: continue ADDBA flow\n");
+			tid_data->agg.state = IWL_AGG_ON;
+			ieee80211_start_tx_ba_cb_irqsafe(priv->vif, addr, tid);
+		}
+		break;
+	}
+	return 0;
+}
+
+static void iwlagn_tx_status(struct iwl_priv *priv, struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_sta *sta;
+	struct iwl_station_priv *sta_priv;
+
+	sta = ieee80211_find_sta(priv->vif, hdr->addr1);
+	if (sta) {
+		sta_priv = (void *)sta->drv_priv;
+		/* avoid atomic ops if this isn't a client */
+		if (sta_priv->client &&
+		    atomic_dec_return(&sta_priv->pending_frames) == 0)
+			ieee80211_sta_block_awake(priv->hw, sta, false);
+	}
+
+	ieee80211_tx_status_irqsafe(priv->hw, skb);
+}
+
+int iwlagn_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
+{
+	struct iwl_tx_queue *txq = &priv->txq[txq_id];
+	struct iwl_queue *q = &txq->q;
+	struct iwl_tx_info *tx_info;
+	int nfreed = 0;
+	struct ieee80211_hdr *hdr;
+
+	if ((index >= q->n_bd) || (iwl_queue_used(q, index) == 0)) {
+		IWL_ERR(priv, "Read index for DMA queue txq id (%d), index %d, "
+			  "is out of range [0-%d] %d %d.\n", txq_id,
+			  index, q->n_bd, q->write_ptr, q->read_ptr);
+		return 0;
+	}
+
+	for (index = iwl_queue_inc_wrap(index, q->n_bd);
+	     q->read_ptr != index;
+	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
+
+		tx_info = &txq->txb[txq->q.read_ptr];
+		iwlagn_tx_status(priv, tx_info->skb[0]);
+
+		hdr = (struct ieee80211_hdr *)tx_info->skb[0]->data;
+		if (hdr && ieee80211_is_data_qos(hdr->frame_control))
+			nfreed++;
+		tx_info->skb[0] = NULL;
+
+		if (priv->cfg->ops->lib->txq_inval_byte_cnt_tbl)
+			priv->cfg->ops->lib->txq_inval_byte_cnt_tbl(priv, txq);
+
+		priv->cfg->ops->lib->txq_free_tfd(priv, txq);
+	}
+	return nfreed;
+}
+
+/**
+ * iwlagn_tx_status_reply_compressed_ba - Update tx status from block-ack
+ *
+ * Go through block-ack's bitmap of ACK'd frames, update driver's record of
+ * ACK vs. not.  This gets sent to mac80211, then to rate scaling algo.
+ */
+static int iwlagn_tx_status_reply_compressed_ba(struct iwl_priv *priv,
+				 struct iwl_ht_agg *agg,
+				 struct iwl_compressed_ba_resp *ba_resp)
+
+{
+	int i, sh, ack;
+	u16 seq_ctl = le16_to_cpu(ba_resp->seq_ctl);
+	u16 scd_flow = le16_to_cpu(ba_resp->scd_flow);
+	u64 bitmap;
+	int successes = 0;
+	struct ieee80211_tx_info *info;
+
+	if (unlikely(!agg->wait_for_ba))  {
+		IWL_ERR(priv, "Received BA when not expected\n");
+		return -EINVAL;
+	}
+
+	/* Mark that the expected block-ack response arrived */
+	agg->wait_for_ba = 0;
+	IWL_DEBUG_TX_REPLY(priv, "BA %d %d\n", agg->start_idx, ba_resp->seq_ctl);
+
+	/* Calculate shift to align block-ack bits with our Tx window bits */
+	sh = agg->start_idx - SEQ_TO_INDEX(seq_ctl >> 4);
+	if (sh < 0) /* tbw something is wrong with indices */
+		sh += 0x100;
+
+	/* don't use 64-bit values for now */
+	bitmap = le64_to_cpu(ba_resp->bitmap) >> sh;
+
+	if (agg->frame_count > (64 - sh)) {
+		IWL_DEBUG_TX_REPLY(priv, "more frames than bitmap size");
+		return -1;
+	}
+
+	/* check for success or failure according to the
+	 * transmitted bitmap and block-ack bitmap */
+	bitmap &= agg->bitmap;
+
+	/* For each frame attempted in aggregation,
+	 * update driver's record of tx frame's status. */
+	for (i = 0; i < agg->frame_count ; i++) {
+		ack = bitmap & (1ULL << i);
+		successes += !!ack;
+		IWL_DEBUG_TX_REPLY(priv, "%s ON i=%d idx=%d raw=%d\n",
+			ack ? "ACK" : "NACK", i, (agg->start_idx + i) & 0xff,
+			agg->start_idx + i);
+	}
+
+	info = IEEE80211_SKB_CB(priv->txq[scd_flow].txb[agg->start_idx].skb[0]);
+	memset(&info->status, 0, sizeof(info->status));
+	info->flags |= IEEE80211_TX_STAT_ACK;
+	info->flags |= IEEE80211_TX_STAT_AMPDU;
+	info->status.ampdu_ack_map = successes;
+	info->status.ampdu_ack_len = agg->frame_count;
+	iwl_hwrate_to_tx_control(priv, agg->rate_n_flags, info);
+
+	IWL_DEBUG_TX_REPLY(priv, "Bitmap %llx\n", (unsigned long long)bitmap);
+
+	return 0;
+}
+
+/**
+ * iwlagn_rx_reply_compressed_ba - Handler for REPLY_COMPRESSED_BA
+ *
+ * Handles block-acknowledge notification from device, which reports success
+ * of frames sent via aggregation.
+ */
+void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
+					   struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_compressed_ba_resp *ba_resp = &pkt->u.compressed_ba;
+	struct iwl_tx_queue *txq = NULL;
+	struct iwl_ht_agg *agg;
+	int index;
+	int sta_id;
+	int tid;
+
+	/* "flow" corresponds to Tx queue */
+	u16 scd_flow = le16_to_cpu(ba_resp->scd_flow);
+
+	/* "ssn" is start of block-ack Tx window, corresponds to index
+	 * (in Tx queue's circular buffer) of first TFD/frame in window */
+	u16 ba_resp_scd_ssn = le16_to_cpu(ba_resp->scd_ssn);
+
+	if (scd_flow >= priv->hw_params.max_txq_num) {
+		IWL_ERR(priv,
+			"BUG_ON scd_flow is bigger than number of queues\n");
+		return;
+	}
+
+	txq = &priv->txq[scd_flow];
+	sta_id = ba_resp->sta_id;
+	tid = ba_resp->tid;
+	agg = &priv->stations[sta_id].tid[tid].agg;
+
+	/* Find index just before block-ack window */
+	index = iwl_queue_dec_wrap(ba_resp_scd_ssn & 0xff, txq->q.n_bd);
+
+	/* TODO: Need to get this copy more safely - now good for debug */
+
+	IWL_DEBUG_TX_REPLY(priv, "REPLY_COMPRESSED_BA [%d] Received from %pM, "
+			   "sta_id = %d\n",
+			   agg->wait_for_ba,
+			   (u8 *) &ba_resp->sta_addr_lo32,
+			   ba_resp->sta_id);
+	IWL_DEBUG_TX_REPLY(priv, "TID = %d, SeqCtl = %d, bitmap = 0x%llx, scd_flow = "
+			   "%d, scd_ssn = %d\n",
+			   ba_resp->tid,
+			   ba_resp->seq_ctl,
+			   (unsigned long long)le64_to_cpu(ba_resp->bitmap),
+			   ba_resp->scd_flow,
+			   ba_resp->scd_ssn);
+	IWL_DEBUG_TX_REPLY(priv, "DAT start_idx = %d, bitmap = 0x%llx \n",
+			   agg->start_idx,
+			   (unsigned long long)agg->bitmap);
+
+	/* Update driver's record of ACK vs. not for each frame in window */
+	iwlagn_tx_status_reply_compressed_ba(priv, agg, ba_resp);
+
+	/* Release all TFDs before the SSN, i.e. all TFDs in front of
+	 * block-ack window (we assume that they've been successfully
+	 * transmitted ... if not, it's too late anyway). */
+	if (txq->q.read_ptr != (ba_resp_scd_ssn & 0xff)) {
+		/* calculate mac80211 ampdu sw queue to wake */
+		int freed = iwlagn_tx_queue_reclaim(priv, scd_flow, index);
+		iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
+
+		if ((iwl_queue_space(&txq->q) > txq->q.low_mark) &&
+		    priv->mac80211_registered &&
+		    (agg->state != IWL_EMPTYING_HW_QUEUE_DELBA))
+			iwl_wake_queue(priv, txq->swq_id);
+
+		iwlagn_txq_check_empty(priv, sta_id, tid, scd_flow);
+	}
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 680e897..a57933b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -887,7 +887,7 @@ static void iwl_setup_rx_handlers(struct iwl_priv *priv)
 	priv->rx_handlers[REPLY_RX_PHY_CMD] = iwl_rx_reply_rx_phy;
 	priv->rx_handlers[REPLY_RX_MPDU_CMD] = iwl_rx_reply_rx;
 	/* block ack */
-	priv->rx_handlers[REPLY_COMPRESSED_BA] = iwl_rx_reply_compressed_ba;
+	priv->rx_handlers[REPLY_COMPRESSED_BA] = iwlagn_rx_reply_compressed_ba;
 	/* Set up hardware specific Rx handlers */
 	priv->cfg->ops->lib->rx_handler_setup(priv);
 }
@@ -2249,7 +2249,7 @@ static void __iwl_down(struct iwl_priv *priv)
 	/* device going down, Stop using ICT table */
 	iwl_disable_ict(priv);
 
-	iwl_txq_ctx_stop(priv);
+	iwlagn_txq_ctx_stop(priv);
 	iwl_rxq_stop(priv);
 
 	/* Power-down device's busmaster DMA clocks */
@@ -2371,7 +2371,7 @@ static int __iwl_up(struct iwl_priv *priv)
 
 	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
 
-	ret = iwl_hw_nic_init(priv);
+	ret = iwlagn_hw_nic_init(priv);
 	if (ret) {
 		IWL_ERR(priv, "Unable to init nic\n");
 		return ret;
@@ -2782,7 +2782,7 @@ static int iwl_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	IWL_DEBUG_TX(priv, "dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
 		     ieee80211_get_tx_rate(hw, IEEE80211_SKB_CB(skb))->bitrate);
 
-	if (iwl_tx_skb(priv, skb))
+	if (iwlagn_tx_skb(priv, skb))
 		dev_kfree_skb_any(skb);
 
 	IWL_DEBUG_MACDUMP(priv, "leave\n");
@@ -2970,7 +2970,7 @@ static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
 			return ret;
 	case IEEE80211_AMPDU_TX_START:
 		IWL_DEBUG_HT(priv, "start Tx\n");
-		ret = iwl_tx_agg_start(priv, sta->addr, tid, ssn);
+		ret = iwlagn_tx_agg_start(priv, sta->addr, tid, ssn);
 		if (ret == 0) {
 			priv->_agn.agg_tids_count++;
 			IWL_DEBUG_HT(priv, "priv->_agn.agg_tids_count = %u\n",
@@ -2979,7 +2979,7 @@ static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
 		return ret;
 	case IEEE80211_AMPDU_TX_STOP:
 		IWL_DEBUG_HT(priv, "stop Tx\n");
-		ret = iwl_tx_agg_stop(priv, sta->addr, tid);
+		ret = iwlagn_tx_agg_stop(priv, sta->addr, tid);
 		if ((ret == 0) && (priv->_agn.agg_tids_count > 0)) {
 			priv->_agn.agg_tids_count--;
 			IWL_DEBUG_HT(priv, "priv->_agn.agg_tids_count = %u\n",
@@ -3738,7 +3738,7 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 
 	if (priv->rxq.bd)
 		iwl_rx_queue_free(priv, &priv->rxq);
-	iwl_hw_txq_ctx_free(priv);
+	iwlagn_hw_txq_ctx_free(priv);
 
 	iwl_eeprom_free(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index ad9b47e..c75a767 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -113,5 +113,22 @@ void iwlagn_temperature(struct iwl_priv *priv);
 u16 iwlagn_eeprom_calib_version(struct iwl_priv *priv);
 const u8 *iwlagn_eeprom_query_addr(const struct iwl_priv *priv,
 				   size_t offset);
+void iwlagn_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
+int iwlagn_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
+int iwlagn_hw_nic_init(struct iwl_priv *priv);
+
+/* tx */
+int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb);
+int iwlagn_tx_agg_start(struct iwl_priv *priv,
+			const u8 *ra, u16 tid, u16 *ssn);
+int iwlagn_tx_agg_stop(struct iwl_priv *priv , const u8 *ra, u16 tid);
+int iwlagn_txq_check_empty(struct iwl_priv *priv,
+			   int sta_id, u8 tid, int txq_id);
+void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
+				struct iwl_rx_mem_buffer *rxb);
+int iwlagn_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index);
+void iwlagn_hw_txq_ctx_free(struct iwl_priv *priv);
+int iwlagn_txq_ctx_reset(struct iwl_priv *priv);
+void iwlagn_txq_ctx_stop(struct iwl_priv *priv);
 
 #endif /* __iwl_agn_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 5180fb2..0dc41d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -265,57 +265,6 @@ void iwl_hw_detect(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_hw_detect);
 
-int iwl_hw_nic_init(struct iwl_priv *priv)
-{
-	unsigned long flags;
-	struct iwl_rx_queue *rxq = &priv->rxq;
-	int ret;
-
-	/* nic_init */
-	spin_lock_irqsave(&priv->lock, flags);
-	priv->cfg->ops->lib->apm_ops.init(priv);
-
-	/* Set interrupt coalescing calibration timer to default (512 usecs) */
-	iwl_write8(priv, CSR_INT_COALESCING, IWL_HOST_INT_CALIB_TIMEOUT_DEF);
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	ret = priv->cfg->ops->lib->apm_ops.set_pwr_src(priv, IWL_PWR_SRC_VMAIN);
-
-	priv->cfg->ops->lib->apm_ops.config(priv);
-
-	/* Allocate the RX queue, or reset if it is already allocated */
-	if (!rxq->bd) {
-		ret = iwl_rx_queue_alloc(priv);
-		if (ret) {
-			IWL_ERR(priv, "Unable to initialize Rx queue\n");
-			return -ENOMEM;
-		}
-	} else
-		iwl_rx_queue_reset(priv, rxq);
-
-	iwl_rx_replenish(priv);
-
-	iwl_rx_init(priv, rxq);
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	rxq->need_update = 1;
-	iwl_rx_queue_update_write_ptr(priv, rxq);
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	/* Allocate and init all Tx and Command queues */
-	ret = iwl_txq_ctx_reset(priv);
-	if (ret)
-		return ret;
-
-	set_bit(STATUS_INIT, &priv->status);
-
-	return 0;
-}
-EXPORT_SYMBOL(iwl_hw_nic_init);
-
 /*
  * QoS  support
 */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index b3e698b..446d27b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -336,7 +336,6 @@ void iwl_irq_handle_error(struct iwl_priv *priv);
 void iwl_configure_filter(struct ieee80211_hw *hw,
 			  unsigned int changed_flags,
 			  unsigned int *total_flags, u64 multicast);
-int iwl_hw_nic_init(struct iwl_priv *priv);
 int iwl_set_hw_params(struct iwl_priv *priv);
 bool iwl_is_monitor_mode(struct iwl_priv *priv);
 void iwl_post_associate(struct iwl_priv *priv);
@@ -426,15 +425,12 @@ int iwl_rx_queue_alloc(struct iwl_priv *priv);
 void iwl_rx_handle(struct iwl_priv *priv);
 void iwl_rx_queue_update_write_ptr(struct iwl_priv *priv,
 				  struct iwl_rx_queue *q);
-void iwl_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
 void iwl_rx_replenish(struct iwl_priv *priv);
 void iwl_rx_replenish_now(struct iwl_priv *priv);
-int iwl_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
 void iwl_rx_queue_restock(struct iwl_priv *priv);
 int iwl_rx_queue_space(const struct iwl_rx_queue *q);
 void iwl_rx_allocate(struct iwl_priv *priv, gfp_t priority);
 void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
-int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index);
 /* Handlers */
 void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
 			       struct iwl_rx_mem_buffer *rxb);
@@ -455,13 +451,10 @@ void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
 /*****************************************************
 * TX
 ******************************************************/
-int iwl_txq_ctx_reset(struct iwl_priv *priv);
 void iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq);
 int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv,
 				 struct iwl_tx_queue *txq,
 				 dma_addr_t addr, u16 len, u8 reset, u8 pad);
-int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb);
-void iwl_hw_txq_ctx_free(struct iwl_priv *priv);
 int iwl_hw_tx_queue_init(struct iwl_priv *priv,
 			 struct iwl_tx_queue *txq);
 void iwl_free_tfds_in_queue(struct iwl_priv *priv,
@@ -470,9 +463,6 @@ void iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq);
 int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 		      int slots_num, u32 txq_id);
 void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id);
-int iwl_tx_agg_start(struct iwl_priv *priv, const u8 *ra, u16 tid, u16 *ssn);
-int iwl_tx_agg_stop(struct iwl_priv *priv , const u8 *ra, u16 tid);
-int iwl_txq_check_empty(struct iwl_priv *priv, int sta_id, u8 tid, int txq_id);
 /*****************************************************
  * TX power
  ****************************************************/
@@ -689,8 +679,6 @@ extern void iwl_rx_reply_rx(struct iwl_priv *priv,
 		struct iwl_rx_mem_buffer *rxb);
 extern void iwl_rx_reply_rx_phy(struct iwl_priv *priv,
 				    struct iwl_rx_mem_buffer *rxb);
-void iwl_rx_reply_compressed_ba(struct iwl_priv *priv,
-					   struct iwl_rx_mem_buffer *rxb);
 void iwl_apm_stop(struct iwl_priv *priv);
 int iwl_apm_init(struct iwl_priv *priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.c b/drivers/net/wireless/iwlwifi/iwl-devtrace.c
index 36580d8..f469aa9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.c
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.c
@@ -35,6 +35,7 @@ EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_iowrite8);
 EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ioread32);
 EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_iowrite32);
 EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_rx);
+EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_tx);
 EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ucode_event);
 EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ucode_error);
 EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ucode_cont_event);
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index de453f2..b75c3cc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -395,86 +395,6 @@ err_bd:
 }
 EXPORT_SYMBOL(iwl_rx_queue_alloc);
 
-void iwl_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
-{
-	unsigned long flags;
-	int i;
-	spin_lock_irqsave(&rxq->lock, flags);
-	INIT_LIST_HEAD(&rxq->rx_free);
-	INIT_LIST_HEAD(&rxq->rx_used);
-	/* Fill the rx_used queue with _all_ of the Rx buffers */
-	for (i = 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++) {
-		/* In the reset function, these buffers may have been allocated
-		 * to an SKB, so we need to unmap and free potential storage */
-		if (rxq->pool[i].page != NULL) {
-			pci_unmap_page(priv->pci_dev, rxq->pool[i].page_dma,
-				PAGE_SIZE << priv->hw_params.rx_page_order,
-				PCI_DMA_FROMDEVICE);
-			__iwl_free_pages(priv, rxq->pool[i].page);
-			rxq->pool[i].page = NULL;
-		}
-		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
-	}
-
-	/* Set us so that we have processed and used all buffers, but have
-	 * not restocked the Rx queue with fresh buffers */
-	rxq->read = rxq->write = 0;
-	rxq->write_actual = 0;
-	rxq->free_count = 0;
-	spin_unlock_irqrestore(&rxq->lock, flags);
-}
-
-int iwl_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
-{
-	u32 rb_size;
-	const u32 rfdnlog = RX_QUEUE_SIZE_LOG; /* 256 RBDs */
-	u32 rb_timeout = 0; /* FIXME: RX_RB_TIMEOUT for all devices? */
-
-	if (!priv->cfg->use_isr_legacy)
-		rb_timeout = RX_RB_TIMEOUT;
-
-	if (priv->cfg->mod_params->amsdu_size_8K)
-		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_8K;
-	else
-		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_4K;
-
-	/* Stop Rx DMA */
-	iwl_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
-
-	/* Reset driver's Rx queue write index */
-	iwl_write_direct32(priv, FH_RSCSR_CHNL0_RBDCB_WPTR_REG, 0);
-
-	/* Tell device where to find RBD circular buffer in DRAM */
-	iwl_write_direct32(priv, FH_RSCSR_CHNL0_RBDCB_BASE_REG,
-			   (u32)(rxq->dma_addr >> 8));
-
-	/* Tell device where in DRAM to update its Rx status */
-	iwl_write_direct32(priv, FH_RSCSR_CHNL0_STTS_WPTR_REG,
-			   rxq->rb_stts_dma >> 4);
-
-	/* Enable Rx DMA
-	 * FH_RCSR_CHNL0_RX_IGNORE_RXF_EMPTY is set because of HW bug in
-	 *      the credit mechanism in 5000 HW RX FIFO
-	 * Direct rx interrupts to hosts
-	 * Rx buffer size 4 or 8k
-	 * RB timeout 0x10
-	 * 256 RBDs
-	 */
-	iwl_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG,
-			   FH_RCSR_RX_CONFIG_CHNL_EN_ENABLE_VAL |
-			   FH_RCSR_CHNL0_RX_IGNORE_RXF_EMPTY |
-			   FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL |
-			   FH_RCSR_CHNL0_RX_CONFIG_SINGLE_FRAME_MSK |
-			   rb_size|
-			   (rb_timeout << FH_RCSR_RX_CONFIG_REG_IRQ_RBTH_POS)|
-			   (rfdnlog << FH_RCSR_RX_CONFIG_RBDCB_SIZE_POS));
-
-	/* Set interrupt coalescing timer to default (2048 usecs) */
-	iwl_write8(priv, CSR_INT_COALESCING, IWL_HOST_INT_TIMEOUT_DEF);
-
-	return 0;
-}
-
 int iwl_rxq_stop(struct iwl_priv *priv)
 {
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index d401b6f..9c28ad7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -1395,6 +1395,7 @@ void iwl_sta_modify_sleep_tx_count(struct iwl_priv *priv, int sta_id, int cnt)
 
 	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
 }
+EXPORT_SYMBOL(iwl_sta_modify_sleep_tx_count);
 
 int iwl_mac_sta_remove(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 34c9838..91f9c89 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -37,84 +37,6 @@
 #include "iwl-io.h"
 #include "iwl-helpers.h"
 
-/*
- * mac80211 queues, ACs, hardware queues, FIFOs.
- *
- * Cf. http://wireless.kernel.org/en/developers/Documentation/mac80211/queues
- *
- * Mac80211 uses the following numbers, which we get as from it
- * by way of skb_get_queue_mapping(skb):
- *
- *	VO	0
- *	VI	1
- *	BE	2
- *	BK	3
- *
- *
- * Regular (not A-MPDU) frames are put into hardware queues corresponding
- * to the FIFOs, see comments in iwl-prph.h. Aggregated frames get their
- * own queue per aggregation session (RA/TID combination), such queues are
- * set up to map into FIFOs too, for which we need an AC->FIFO mapping. In
- * order to map frames to the right queue, we also need an AC->hw queue
- * mapping. This is implemented here.
- *
- * Due to the way hw queues are set up (by the hw specific modules like
- * iwl-4965.c, iwl-5000.c etc.), the AC->hw queue mapping is the identity
- * mapping.
- */
-
-static const u8 tid_to_ac[] = {
-	/* this matches the mac80211 numbers */
-	2, 3, 3, 2, 1, 1, 0, 0
-};
-
-static const u8 ac_to_fifo[] = {
-	IWL_TX_FIFO_VO,
-	IWL_TX_FIFO_VI,
-	IWL_TX_FIFO_BE,
-	IWL_TX_FIFO_BK,
-};
-
-static inline int get_fifo_from_ac(u8 ac)
-{
-	return ac_to_fifo[ac];
-}
-
-static inline int get_queue_from_ac(u16 ac)
-{
-	return ac;
-}
-
-static inline int get_fifo_from_tid(u16 tid)
-{
-	if (likely(tid < ARRAY_SIZE(tid_to_ac)))
-		return get_fifo_from_ac(tid_to_ac[tid]);
-
-	/* no support for TIDs 8-15 yet */
-	return -EINVAL;
-}
-
-static inline int iwl_alloc_dma_ptr(struct iwl_priv *priv,
-				    struct iwl_dma_ptr *ptr, size_t size)
-{
-	ptr->addr = dma_alloc_coherent(&priv->pci_dev->dev, size, &ptr->dma,
-				       GFP_KERNEL);
-	if (!ptr->addr)
-		return -ENOMEM;
-	ptr->size = size;
-	return 0;
-}
-
-static inline void iwl_free_dma_ptr(struct iwl_priv *priv,
-				    struct iwl_dma_ptr *ptr)
-{
-	if (unlikely(!ptr->addr))
-		return;
-
-	dma_free_coherent(&priv->pci_dev->dev, ptr->size, ptr->addr, ptr->dma);
-	memset(ptr, 0, sizeof(*ptr));
-}
-
 /**
  * iwl_txq_update_write_ptr - Send new write index to hardware
  */
@@ -448,579 +370,6 @@ out_free_arrays:
 }
 EXPORT_SYMBOL(iwl_tx_queue_init);
 
-/**
- * iwl_hw_txq_ctx_free - Free TXQ Context
- *
- * Destroy all TX DMA queues and structures
- */
-void iwl_hw_txq_ctx_free(struct iwl_priv *priv)
-{
-	int txq_id;
-
-	/* Tx queues */
-	if (priv->txq) {
-		for (txq_id = 0; txq_id < priv->hw_params.max_txq_num;
-		     txq_id++)
-			if (txq_id == IWL_CMD_QUEUE_NUM)
-				iwl_cmd_queue_free(priv);
-			else
-				iwl_tx_queue_free(priv, txq_id);
-	}
-	iwl_free_dma_ptr(priv, &priv->kw);
-
-	iwl_free_dma_ptr(priv, &priv->scd_bc_tbls);
-
-	/* free tx queue structure */
-	iwl_free_txq_mem(priv);
-}
-EXPORT_SYMBOL(iwl_hw_txq_ctx_free);
-
-/**
- * iwl_txq_ctx_reset - Reset TX queue context
- * Destroys all DMA structures and initialize them again
- *
- * @param priv
- * @return error code
- */
-int iwl_txq_ctx_reset(struct iwl_priv *priv)
-{
-	int ret = 0;
-	int txq_id, slots_num;
-	unsigned long flags;
-
-	/* Free all tx/cmd queues and keep-warm buffer */
-	iwl_hw_txq_ctx_free(priv);
-
-	ret = iwl_alloc_dma_ptr(priv, &priv->scd_bc_tbls,
-				priv->hw_params.scd_bc_tbls_size);
-	if (ret) {
-		IWL_ERR(priv, "Scheduler BC Table allocation failed\n");
-		goto error_bc_tbls;
-	}
-	/* Alloc keep-warm buffer */
-	ret = iwl_alloc_dma_ptr(priv, &priv->kw, IWL_KW_SIZE);
-	if (ret) {
-		IWL_ERR(priv, "Keep Warm allocation failed\n");
-		goto error_kw;
-	}
-
-	/* allocate tx queue structure */
-	ret = iwl_alloc_txq_mem(priv);
-	if (ret)
-		goto error;
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	/* Turn off all Tx DMA fifos */
-	priv->cfg->ops->lib->txq_set_sched(priv, 0);
-
-	/* Tell NIC where to find the "keep warm" buffer */
-	iwl_write_direct32(priv, FH_KW_MEM_ADDR_REG, priv->kw.dma >> 4);
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	/* Alloc and init all Tx queues, including the command queue (#4) */
-	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++) {
-		slots_num = (txq_id == IWL_CMD_QUEUE_NUM) ?
-					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
-		ret = iwl_tx_queue_init(priv, &priv->txq[txq_id], slots_num,
-				       txq_id);
-		if (ret) {
-			IWL_ERR(priv, "Tx %d queue init failed\n", txq_id);
-			goto error;
-		}
-	}
-
-	return ret;
-
- error:
-	iwl_hw_txq_ctx_free(priv);
-	iwl_free_dma_ptr(priv, &priv->kw);
- error_kw:
-	iwl_free_dma_ptr(priv, &priv->scd_bc_tbls);
- error_bc_tbls:
-	return ret;
-}
-
-/**
- * iwl_txq_ctx_stop - Stop all Tx DMA channels, free Tx queue memory
- */
-void iwl_txq_ctx_stop(struct iwl_priv *priv)
-{
-	int ch;
-	unsigned long flags;
-
-	/* Turn off all Tx DMA fifos */
-	spin_lock_irqsave(&priv->lock, flags);
-
-	priv->cfg->ops->lib->txq_set_sched(priv, 0);
-
-	/* Stop each Tx DMA channel, and wait for it to be idle */
-	for (ch = 0; ch < priv->hw_params.dma_chnl_num; ch++) {
-		iwl_write_direct32(priv, FH_TCSR_CHNL_TX_CONFIG_REG(ch), 0x0);
-		iwl_poll_direct_bit(priv, FH_TSSR_TX_STATUS_REG,
-				    FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(ch),
-				    1000);
-	}
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	/* Deallocate memory for all Tx queues */
-	iwl_hw_txq_ctx_free(priv);
-}
-EXPORT_SYMBOL(iwl_txq_ctx_stop);
-
-/*
- * handle build REPLY_TX command notification.
- */
-static void iwl_tx_cmd_build_basic(struct iwl_priv *priv,
-				  struct iwl_tx_cmd *tx_cmd,
-				  struct ieee80211_tx_info *info,
-				  struct ieee80211_hdr *hdr,
-				  u8 std_id)
-{
-	__le16 fc = hdr->frame_control;
-	__le32 tx_flags = tx_cmd->tx_flags;
-
-	tx_cmd->stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
-	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
-		tx_flags |= TX_CMD_FLG_ACK_MSK;
-		if (ieee80211_is_mgmt(fc))
-			tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
-		if (ieee80211_is_probe_resp(fc) &&
-		    !(le16_to_cpu(hdr->seq_ctrl) & 0xf))
-			tx_flags |= TX_CMD_FLG_TSF_MSK;
-	} else {
-		tx_flags &= (~TX_CMD_FLG_ACK_MSK);
-		tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
-	}
-
-	if (ieee80211_is_back_req(fc))
-		tx_flags |= TX_CMD_FLG_ACK_MSK | TX_CMD_FLG_IMM_BA_RSP_MASK;
-
-
-	tx_cmd->sta_id = std_id;
-	if (ieee80211_has_morefrags(fc))
-		tx_flags |= TX_CMD_FLG_MORE_FRAG_MSK;
-
-	if (ieee80211_is_data_qos(fc)) {
-		u8 *qc = ieee80211_get_qos_ctl(hdr);
-		tx_cmd->tid_tspec = qc[0] & 0xf;
-		tx_flags &= ~TX_CMD_FLG_SEQ_CTL_MSK;
-	} else {
-		tx_flags |= TX_CMD_FLG_SEQ_CTL_MSK;
-	}
-
-	priv->cfg->ops->utils->rts_tx_cmd_flag(info, &tx_flags);
-
-	if ((tx_flags & TX_CMD_FLG_RTS_MSK) || (tx_flags & TX_CMD_FLG_CTS_MSK))
-		tx_flags |= TX_CMD_FLG_FULL_TXOP_PROT_MSK;
-
-	tx_flags &= ~(TX_CMD_FLG_ANT_SEL_MSK);
-	if (ieee80211_is_mgmt(fc)) {
-		if (ieee80211_is_assoc_req(fc) || ieee80211_is_reassoc_req(fc))
-			tx_cmd->timeout.pm_frame_timeout = cpu_to_le16(3);
-		else
-			tx_cmd->timeout.pm_frame_timeout = cpu_to_le16(2);
-	} else {
-		tx_cmd->timeout.pm_frame_timeout = 0;
-	}
-
-	tx_cmd->driver_txop = 0;
-	tx_cmd->tx_flags = tx_flags;
-	tx_cmd->next_frame_len = 0;
-}
-
-#define RTS_DFAULT_RETRY_LIMIT		60
-
-static void iwl_tx_cmd_build_rate(struct iwl_priv *priv,
-			      struct iwl_tx_cmd *tx_cmd,
-			      struct ieee80211_tx_info *info,
-			      __le16 fc)
-{
-	u32 rate_flags;
-	int rate_idx;
-	u8 rts_retry_limit;
-	u8 data_retry_limit;
-	u8 rate_plcp;
-
-	/* Set retry limit on DATA packets and Probe Responses*/
-	if (ieee80211_is_probe_resp(fc))
-		data_retry_limit = 3;
-	else
-		data_retry_limit = IWL_DEFAULT_TX_RETRY;
-	tx_cmd->data_retry_limit = data_retry_limit;
-
-	/* Set retry limit on RTS packets */
-	rts_retry_limit = RTS_DFAULT_RETRY_LIMIT;
-	if (data_retry_limit < rts_retry_limit)
-		rts_retry_limit = data_retry_limit;
-	tx_cmd->rts_retry_limit = rts_retry_limit;
-
-	/* DATA packets will use the uCode station table for rate/antenna
-	 * selection */
-	if (ieee80211_is_data(fc)) {
-		tx_cmd->initial_rate_index = 0;
-		tx_cmd->tx_flags |= TX_CMD_FLG_STA_RATE_MSK;
-		return;
-	}
-
-	/**
-	 * If the current TX rate stored in mac80211 has the MCS bit set, it's
-	 * not really a TX rate.  Thus, we use the lowest supported rate for
-	 * this band.  Also use the lowest supported rate if the stored rate
-	 * index is invalid.
-	 */
-	rate_idx = info->control.rates[0].idx;
-	if (info->control.rates[0].flags & IEEE80211_TX_RC_MCS ||
-			(rate_idx < 0) || (rate_idx > IWL_RATE_COUNT_LEGACY))
-		rate_idx = rate_lowest_index(&priv->bands[info->band],
-				info->control.sta);
-	/* For 5 GHZ band, remap mac80211 rate indices into driver indices */
-	if (info->band == IEEE80211_BAND_5GHZ)
-		rate_idx += IWL_FIRST_OFDM_RATE;
-	/* Get PLCP rate for tx_cmd->rate_n_flags */
-	rate_plcp = iwl_rates[rate_idx].plcp;
-	/* Zero out flags for this packet */
-	rate_flags = 0;
-
-	/* Set CCK flag as needed */
-	if ((rate_idx >= IWL_FIRST_CCK_RATE) && (rate_idx <= IWL_LAST_CCK_RATE))
-		rate_flags |= RATE_MCS_CCK_MSK;
-
-	/* Set up RTS and CTS flags for certain packets */
-	switch (fc & cpu_to_le16(IEEE80211_FCTL_STYPE)) {
-	case cpu_to_le16(IEEE80211_STYPE_AUTH):
-	case cpu_to_le16(IEEE80211_STYPE_DEAUTH):
-	case cpu_to_le16(IEEE80211_STYPE_ASSOC_REQ):
-	case cpu_to_le16(IEEE80211_STYPE_REASSOC_REQ):
-		if (tx_cmd->tx_flags & TX_CMD_FLG_RTS_MSK) {
-			tx_cmd->tx_flags &= ~TX_CMD_FLG_RTS_MSK;
-			tx_cmd->tx_flags |= TX_CMD_FLG_CTS_MSK;
-		}
-		break;
-	default:
-		break;
-	}
-
-	/* Set up antennas */
-	priv->mgmt_tx_ant = iwl_toggle_tx_ant(priv, priv->mgmt_tx_ant);
-	rate_flags |= iwl_ant_idx_to_flags(priv->mgmt_tx_ant);
-
-	/* Set the rate in the TX cmd */
-	tx_cmd->rate_n_flags = iwl_hw_set_rate_n_flags(rate_plcp, rate_flags);
-}
-
-static void iwl_tx_cmd_build_hwcrypto(struct iwl_priv *priv,
-				      struct ieee80211_tx_info *info,
-				      struct iwl_tx_cmd *tx_cmd,
-				      struct sk_buff *skb_frag,
-				      int sta_id)
-{
-	struct ieee80211_key_conf *keyconf = info->control.hw_key;
-
-	switch (keyconf->alg) {
-	case ALG_CCMP:
-		tx_cmd->sec_ctl = TX_CMD_SEC_CCM;
-		memcpy(tx_cmd->key, keyconf->key, keyconf->keylen);
-		if (info->flags & IEEE80211_TX_CTL_AMPDU)
-			tx_cmd->tx_flags |= TX_CMD_FLG_AGG_CCMP_MSK;
-		IWL_DEBUG_TX(priv, "tx_cmd with AES hwcrypto\n");
-		break;
-
-	case ALG_TKIP:
-		tx_cmd->sec_ctl = TX_CMD_SEC_TKIP;
-		ieee80211_get_tkip_key(keyconf, skb_frag,
-			IEEE80211_TKIP_P2_KEY, tx_cmd->key);
-		IWL_DEBUG_TX(priv, "tx_cmd with tkip hwcrypto\n");
-		break;
-
-	case ALG_WEP:
-		tx_cmd->sec_ctl |= (TX_CMD_SEC_WEP |
-			(keyconf->keyidx & TX_CMD_SEC_MSK) << TX_CMD_SEC_SHIFT);
-
-		if (keyconf->keylen == WEP_KEY_LEN_128)
-			tx_cmd->sec_ctl |= TX_CMD_SEC_KEY128;
-
-		memcpy(&tx_cmd->key[3], keyconf->key, keyconf->keylen);
-
-		IWL_DEBUG_TX(priv, "Configuring packet for WEP encryption "
-			     "with key %d\n", keyconf->keyidx);
-		break;
-
-	default:
-		IWL_ERR(priv, "Unknown encode alg %d\n", keyconf->alg);
-		break;
-	}
-}
-
-/*
- * start REPLY_TX command process
- */
-int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
-{
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_sta *sta = info->control.sta;
-	struct iwl_station_priv *sta_priv = NULL;
-	struct iwl_tx_queue *txq;
-	struct iwl_queue *q;
-	struct iwl_device_cmd *out_cmd;
-	struct iwl_cmd_meta *out_meta;
-	struct iwl_tx_cmd *tx_cmd;
-	int swq_id, txq_id;
-	dma_addr_t phys_addr;
-	dma_addr_t txcmd_phys;
-	dma_addr_t scratch_phys;
-	u16 len, len_org, firstlen, secondlen;
-	u16 seq_number = 0;
-	__le16 fc;
-	u8 hdr_len;
-	u8 sta_id;
-	u8 wait_write_ptr = 0;
-	u8 tid = 0;
-	u8 *qc = NULL;
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->lock, flags);
-	if (iwl_is_rfkill(priv)) {
-		IWL_DEBUG_DROP(priv, "Dropping - RF KILL\n");
-		goto drop_unlock;
-	}
-
-	fc = hdr->frame_control;
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if (ieee80211_is_auth(fc))
-		IWL_DEBUG_TX(priv, "Sending AUTH frame\n");
-	else if (ieee80211_is_assoc_req(fc))
-		IWL_DEBUG_TX(priv, "Sending ASSOC frame\n");
-	else if (ieee80211_is_reassoc_req(fc))
-		IWL_DEBUG_TX(priv, "Sending REASSOC frame\n");
-#endif
-
-	hdr_len = ieee80211_hdrlen(fc);
-
-	/* Find (or create) index into station table for destination station */
-	if (info->flags & IEEE80211_TX_CTL_INJECTED)
-		sta_id = priv->hw_params.bcast_sta_id;
-	else
-		sta_id = iwl_get_sta_id(priv, hdr);
-	if (sta_id == IWL_INVALID_STATION) {
-		IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
-			       hdr->addr1);
-		goto drop_unlock;
-	}
-
-	IWL_DEBUG_TX(priv, "station Id %d\n", sta_id);
-
-	if (sta)
-		sta_priv = (void *)sta->drv_priv;
-
-	if (sta_priv && sta_id != priv->hw_params.bcast_sta_id &&
-	    sta_priv->asleep) {
-		WARN_ON(!(info->flags & IEEE80211_TX_CTL_PSPOLL_RESPONSE));
-		/*
-		 * This sends an asynchronous command to the device,
-		 * but we can rely on it being processed before the
-		 * next frame is processed -- and the next frame to
-		 * this station is the one that will consume this
-		 * counter.
-		 * For now set the counter to just 1 since we do not
-		 * support uAPSD yet.
-		 */
-		iwl_sta_modify_sleep_tx_count(priv, sta_id, 1);
-	}
-
-	txq_id = get_queue_from_ac(skb_get_queue_mapping(skb));
-	if (ieee80211_is_data_qos(fc)) {
-		qc = ieee80211_get_qos_ctl(hdr);
-		tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
-		if (unlikely(tid >= MAX_TID_COUNT))
-			goto drop_unlock;
-		seq_number = priv->stations[sta_id].tid[tid].seq_number;
-		seq_number &= IEEE80211_SCTL_SEQ;
-		hdr->seq_ctrl = hdr->seq_ctrl &
-				cpu_to_le16(IEEE80211_SCTL_FRAG);
-		hdr->seq_ctrl |= cpu_to_le16(seq_number);
-		seq_number += 0x10;
-		/* aggregation is on for this <sta,tid> */
-		if (info->flags & IEEE80211_TX_CTL_AMPDU &&
-		    priv->stations[sta_id].tid[tid].agg.state == IWL_AGG_ON) {
-			txq_id = priv->stations[sta_id].tid[tid].agg.txq_id;
-		}
-	}
-
-	txq = &priv->txq[txq_id];
-	swq_id = txq->swq_id;
-	q = &txq->q;
-
-	if (unlikely(iwl_queue_space(q) < q->high_mark))
-		goto drop_unlock;
-
-	if (ieee80211_is_data_qos(fc))
-		priv->stations[sta_id].tid[tid].tfds_in_queue++;
-
-	/* Set up driver data for this TFD */
-	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct iwl_tx_info));
-	txq->txb[q->write_ptr].skb[0] = skb;
-
-	/* Set up first empty entry in queue's array of Tx/cmd buffers */
-	out_cmd = txq->cmd[q->write_ptr];
-	out_meta = &txq->meta[q->write_ptr];
-	tx_cmd = &out_cmd->cmd.tx;
-	memset(&out_cmd->hdr, 0, sizeof(out_cmd->hdr));
-	memset(tx_cmd, 0, sizeof(struct iwl_tx_cmd));
-
-	/*
-	 * Set up the Tx-command (not MAC!) header.
-	 * Store the chosen Tx queue and TFD index within the sequence field;
-	 * after Tx, uCode's Tx response will return this value so driver can
-	 * locate the frame within the tx queue and do post-tx processing.
-	 */
-	out_cmd->hdr.cmd = REPLY_TX;
-	out_cmd->hdr.sequence = cpu_to_le16((u16)(QUEUE_TO_SEQ(txq_id) |
-				INDEX_TO_SEQ(q->write_ptr)));
-
-	/* Copy MAC header from skb into command buffer */
-	memcpy(tx_cmd->hdr, hdr, hdr_len);
-
-
-	/* Total # bytes to be transmitted */
-	len = (u16)skb->len;
-	tx_cmd->len = cpu_to_le16(len);
-
-	if (info->control.hw_key)
-		iwl_tx_cmd_build_hwcrypto(priv, info, tx_cmd, skb, sta_id);
-
-	/* TODO need this for burst mode later on */
-	iwl_tx_cmd_build_basic(priv, tx_cmd, info, hdr, sta_id);
-	iwl_dbg_log_tx_data_frame(priv, len, hdr);
-
-	iwl_tx_cmd_build_rate(priv, tx_cmd, info, fc);
-
-	iwl_update_stats(priv, true, fc, len);
-	/*
-	 * Use the first empty entry in this queue's command buffer array
-	 * to contain the Tx command and MAC header concatenated together
-	 * (payload data will be in another buffer).
-	 * Size of this varies, due to varying MAC header length.
-	 * If end is not dword aligned, we'll have 2 extra bytes at the end
-	 * of the MAC header (device reads on dword boundaries).
-	 * We'll tell device about this padding later.
-	 */
-	len = sizeof(struct iwl_tx_cmd) +
-		sizeof(struct iwl_cmd_header) + hdr_len;
-
-	len_org = len;
-	firstlen = len = (len + 3) & ~3;
-
-	if (len_org != len)
-		len_org = 1;
-	else
-		len_org = 0;
-
-	/* Tell NIC about any 2-byte padding after MAC header */
-	if (len_org)
-		tx_cmd->tx_flags |= TX_CMD_FLG_MH_PAD_MSK;
-
-	/* Physical address of this Tx command's header (not MAC header!),
-	 * within command buffer array. */
-	txcmd_phys = pci_map_single(priv->pci_dev,
-				    &out_cmd->hdr, len,
-				    PCI_DMA_BIDIRECTIONAL);
-	pci_unmap_addr_set(out_meta, mapping, txcmd_phys);
-	pci_unmap_len_set(out_meta, len, len);
-	/* Add buffer containing Tx command and MAC(!) header to TFD's
-	 * first entry */
-	priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
-						   txcmd_phys, len, 1, 0);
-
-	if (!ieee80211_has_morefrags(hdr->frame_control)) {
-		txq->need_update = 1;
-		if (qc)
-			priv->stations[sta_id].tid[tid].seq_number = seq_number;
-	} else {
-		wait_write_ptr = 1;
-		txq->need_update = 0;
-	}
-
-	/* Set up TFD's 2nd entry to point directly to remainder of skb,
-	 * if any (802.11 null frames have no payload). */
-	secondlen = len = skb->len - hdr_len;
-	if (len) {
-		phys_addr = pci_map_single(priv->pci_dev, skb->data + hdr_len,
-					   len, PCI_DMA_TODEVICE);
-		priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
-							   phys_addr, len,
-							   0, 0);
-	}
-
-	scratch_phys = txcmd_phys + sizeof(struct iwl_cmd_header) +
-				offsetof(struct iwl_tx_cmd, scratch);
-
-	len = sizeof(struct iwl_tx_cmd) +
-		sizeof(struct iwl_cmd_header) + hdr_len;
-	/* take back ownership of DMA buffer to enable update */
-	pci_dma_sync_single_for_cpu(priv->pci_dev, txcmd_phys,
-				    len, PCI_DMA_BIDIRECTIONAL);
-	tx_cmd->dram_lsb_ptr = cpu_to_le32(scratch_phys);
-	tx_cmd->dram_msb_ptr = iwl_get_dma_hi_addr(scratch_phys);
-
-	IWL_DEBUG_TX(priv, "sequence nr = 0X%x \n",
-		     le16_to_cpu(out_cmd->hdr.sequence));
-	IWL_DEBUG_TX(priv, "tx_flags = 0X%x \n", le32_to_cpu(tx_cmd->tx_flags));
-	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx_cmd, sizeof(*tx_cmd));
-	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx_cmd->hdr, hdr_len);
-
-	/* Set up entry for this TFD in Tx byte-count array */
-	if (info->flags & IEEE80211_TX_CTL_AMPDU)
-		priv->cfg->ops->lib->txq_update_byte_cnt_tbl(priv, txq,
-						     le16_to_cpu(tx_cmd->len));
-
-	pci_dma_sync_single_for_device(priv->pci_dev, txcmd_phys,
-				       len, PCI_DMA_BIDIRECTIONAL);
-
-	trace_iwlwifi_dev_tx(priv,
-			     &((struct iwl_tfd *)txq->tfds)[txq->q.write_ptr],
-			     sizeof(struct iwl_tfd),
-			     &out_cmd->hdr, firstlen,
-			     skb->data + hdr_len, secondlen);
-
-	/* Tell device the write index *just past* this latest filled TFD */
-	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
-	iwl_txq_update_write_ptr(priv, txq);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	/*
-	 * At this point the frame is "transmitted" successfully
-	 * and we will get a TX status notification eventually,
-	 * regardless of the value of ret. "ret" only indicates
-	 * whether or not we should update the write pointer.
-	 */
-
-	/* avoid atomic ops if it isn't an associated client */
-	if (sta_priv && sta_priv->client)
-		atomic_inc(&sta_priv->pending_frames);
-
-	if ((iwl_queue_space(q) < q->high_mark) && priv->mac80211_registered) {
-		if (wait_write_ptr) {
-			spin_lock_irqsave(&priv->lock, flags);
-			txq->need_update = 1;
-			iwl_txq_update_write_ptr(priv, txq);
-			spin_unlock_irqrestore(&priv->lock, flags);
-		} else {
-			iwl_stop_queue(priv, txq->swq_id);
-		}
-	}
-
-	return 0;
-
-drop_unlock:
-	spin_unlock_irqrestore(&priv->lock, flags);
-	return -1;
-}
-EXPORT_SYMBOL(iwl_tx_skb);
-
 /*************** HOST COMMAND QUEUE FUNCTIONS   *****/
 
 /**
@@ -1146,61 +495,6 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	return idx;
 }
 
-static void iwl_tx_status(struct iwl_priv *priv, struct sk_buff *skb)
-{
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	struct ieee80211_sta *sta;
-	struct iwl_station_priv *sta_priv;
-
-	sta = ieee80211_find_sta(priv->vif, hdr->addr1);
-	if (sta) {
-		sta_priv = (void *)sta->drv_priv;
-		/* avoid atomic ops if this isn't a client */
-		if (sta_priv->client &&
-		    atomic_dec_return(&sta_priv->pending_frames) == 0)
-			ieee80211_sta_block_awake(priv->hw, sta, false);
-	}
-
-	ieee80211_tx_status_irqsafe(priv->hw, skb);
-}
-
-int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
-{
-	struct iwl_tx_queue *txq = &priv->txq[txq_id];
-	struct iwl_queue *q = &txq->q;
-	struct iwl_tx_info *tx_info;
-	int nfreed = 0;
-	struct ieee80211_hdr *hdr;
-
-	if ((index >= q->n_bd) || (iwl_queue_used(q, index) == 0)) {
-		IWL_ERR(priv, "Read index for DMA queue txq id (%d), index %d, "
-			  "is out of range [0-%d] %d %d.\n", txq_id,
-			  index, q->n_bd, q->write_ptr, q->read_ptr);
-		return 0;
-	}
-
-	for (index = iwl_queue_inc_wrap(index, q->n_bd);
-	     q->read_ptr != index;
-	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
-
-		tx_info = &txq->txb[txq->q.read_ptr];
-		iwl_tx_status(priv, tx_info->skb[0]);
-
-		hdr = (struct ieee80211_hdr *)tx_info->skb[0]->data;
-		if (hdr && ieee80211_is_data_qos(hdr->frame_control))
-			nfreed++;
-		tx_info->skb[0] = NULL;
-
-		if (priv->cfg->ops->lib->txq_inval_byte_cnt_tbl)
-			priv->cfg->ops->lib->txq_inval_byte_cnt_tbl(priv, txq);
-
-		priv->cfg->ops->lib->txq_free_tfd(priv, txq);
-	}
-	return nfreed;
-}
-EXPORT_SYMBOL(iwl_tx_queue_reclaim);
-
-
 /**
  * iwl_hcmd_queue_reclaim - Reclaim TX command queue entries already Tx'd
  *
@@ -1292,329 +586,6 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 }
 EXPORT_SYMBOL(iwl_tx_cmd_complete);
 
-/*
- * Find first available (lowest unused) Tx Queue, mark it "active".
- * Called only when finding queue for aggregation.
- * Should never return anything < 7, because they should already
- * be in use as EDCA AC (0-3), Command (4), reserved (5, 6)
- */
-static int iwl_txq_ctx_activate_free(struct iwl_priv *priv)
-{
-	int txq_id;
-
-	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++)
-		if (!test_and_set_bit(txq_id, &priv->txq_ctx_active_msk))
-			return txq_id;
-	return -1;
-}
-
-int iwl_tx_agg_start(struct iwl_priv *priv, const u8 *ra, u16 tid, u16 *ssn)
-{
-	int sta_id;
-	int tx_fifo;
-	int txq_id;
-	int ret;
-	unsigned long flags;
-	struct iwl_tid_data *tid_data;
-
-	tx_fifo = get_fifo_from_tid(tid);
-	if (unlikely(tx_fifo < 0))
-		return tx_fifo;
-
-	IWL_WARN(priv, "%s on ra = %pM tid = %d\n",
-			__func__, ra, tid);
-
-	sta_id = iwl_find_station(priv, ra);
-	if (sta_id == IWL_INVALID_STATION) {
-		IWL_ERR(priv, "Start AGG on invalid station\n");
-		return -ENXIO;
-	}
-	if (unlikely(tid >= MAX_TID_COUNT))
-		return -EINVAL;
-
-	if (priv->stations[sta_id].tid[tid].agg.state != IWL_AGG_OFF) {
-		IWL_ERR(priv, "Start AGG when state is not IWL_AGG_OFF !\n");
-		return -ENXIO;
-	}
-
-	txq_id = iwl_txq_ctx_activate_free(priv);
-	if (txq_id == -1) {
-		IWL_ERR(priv, "No free aggregation queue available\n");
-		return -ENXIO;
-	}
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-	tid_data = &priv->stations[sta_id].tid[tid];
-	*ssn = SEQ_TO_SN(tid_data->seq_number);
-	tid_data->agg.txq_id = txq_id;
-	priv->txq[txq_id].swq_id = iwl_virtual_agg_queue_num(tx_fifo, txq_id);
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-
-	ret = priv->cfg->ops->lib->txq_agg_enable(priv, txq_id, tx_fifo,
-						  sta_id, tid, *ssn);
-	if (ret)
-		return ret;
-
-	if (tid_data->tfds_in_queue == 0) {
-		IWL_DEBUG_HT(priv, "HW queue is empty\n");
-		tid_data->agg.state = IWL_AGG_ON;
-		ieee80211_start_tx_ba_cb_irqsafe(priv->vif, ra, tid);
-	} else {
-		IWL_DEBUG_HT(priv, "HW queue is NOT empty: %d packets in HW queue\n",
-			     tid_data->tfds_in_queue);
-		tid_data->agg.state = IWL_EMPTYING_HW_QUEUE_ADDBA;
-	}
-	return ret;
-}
-EXPORT_SYMBOL(iwl_tx_agg_start);
-
-int iwl_tx_agg_stop(struct iwl_priv *priv , const u8 *ra, u16 tid)
-{
-	int tx_fifo_id, txq_id, sta_id, ssn = -1;
-	struct iwl_tid_data *tid_data;
-	int write_ptr, read_ptr;
-	unsigned long flags;
-
-	if (!ra) {
-		IWL_ERR(priv, "ra = NULL\n");
-		return -EINVAL;
-	}
-
-	tx_fifo_id = get_fifo_from_tid(tid);
-	if (unlikely(tx_fifo_id < 0))
-		return tx_fifo_id;
-
-	sta_id = iwl_find_station(priv, ra);
-
-	if (sta_id == IWL_INVALID_STATION) {
-		IWL_ERR(priv, "Invalid station for AGG tid %d\n", tid);
-		return -ENXIO;
-	}
-
-	if (priv->stations[sta_id].tid[tid].agg.state ==
-				IWL_EMPTYING_HW_QUEUE_ADDBA) {
-		IWL_DEBUG_HT(priv, "AGG stop before setup done\n");
-		ieee80211_stop_tx_ba_cb_irqsafe(priv->vif, ra, tid);
-		priv->stations[sta_id].tid[tid].agg.state = IWL_AGG_OFF;
-		return 0;
-	}
-
-	if (priv->stations[sta_id].tid[tid].agg.state != IWL_AGG_ON)
-		IWL_WARN(priv, "Stopping AGG while state not ON or starting\n");
-
-	tid_data = &priv->stations[sta_id].tid[tid];
-	ssn = (tid_data->seq_number & IEEE80211_SCTL_SEQ) >> 4;
-	txq_id = tid_data->agg.txq_id;
-	write_ptr = priv->txq[txq_id].q.write_ptr;
-	read_ptr = priv->txq[txq_id].q.read_ptr;
-
-	/* The queue is not empty */
-	if (write_ptr != read_ptr) {
-		IWL_DEBUG_HT(priv, "Stopping a non empty AGG HW QUEUE\n");
-		priv->stations[sta_id].tid[tid].agg.state =
-				IWL_EMPTYING_HW_QUEUE_DELBA;
-		return 0;
-	}
-
-	IWL_DEBUG_HT(priv, "HW queue is empty\n");
-	priv->stations[sta_id].tid[tid].agg.state = IWL_AGG_OFF;
-
-	spin_lock_irqsave(&priv->lock, flags);
-	/*
-	 * the only reason this call can fail is queue number out of range,
-	 * which can happen if uCode is reloaded and all the station
-	 * information are lost. if it is outside the range, there is no need
-	 * to deactivate the uCode queue, just return "success" to allow
-	 *  mac80211 to clean up it own data.
-	 */
-	priv->cfg->ops->lib->txq_agg_disable(priv, txq_id, ssn,
-						   tx_fifo_id);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	ieee80211_stop_tx_ba_cb_irqsafe(priv->vif, ra, tid);
-
-	return 0;
-}
-EXPORT_SYMBOL(iwl_tx_agg_stop);
-
-int iwl_txq_check_empty(struct iwl_priv *priv, int sta_id, u8 tid, int txq_id)
-{
-	struct iwl_queue *q = &priv->txq[txq_id].q;
-	u8 *addr = priv->stations[sta_id].sta.sta.addr;
-	struct iwl_tid_data *tid_data = &priv->stations[sta_id].tid[tid];
-
-	switch (priv->stations[sta_id].tid[tid].agg.state) {
-	case IWL_EMPTYING_HW_QUEUE_DELBA:
-		/* We are reclaiming the last packet of the */
-		/* aggregated HW queue */
-		if ((txq_id  == tid_data->agg.txq_id) &&
-		    (q->read_ptr == q->write_ptr)) {
-			u16 ssn = SEQ_TO_SN(tid_data->seq_number);
-			int tx_fifo = get_fifo_from_tid(tid);
-			IWL_DEBUG_HT(priv, "HW queue empty: continue DELBA flow\n");
-			priv->cfg->ops->lib->txq_agg_disable(priv, txq_id,
-							     ssn, tx_fifo);
-			tid_data->agg.state = IWL_AGG_OFF;
-			ieee80211_stop_tx_ba_cb_irqsafe(priv->vif, addr, tid);
-		}
-		break;
-	case IWL_EMPTYING_HW_QUEUE_ADDBA:
-		/* We are reclaiming the last packet of the queue */
-		if (tid_data->tfds_in_queue == 0) {
-			IWL_DEBUG_HT(priv, "HW queue empty: continue ADDBA flow\n");
-			tid_data->agg.state = IWL_AGG_ON;
-			ieee80211_start_tx_ba_cb_irqsafe(priv->vif, addr, tid);
-		}
-		break;
-	}
-	return 0;
-}
-EXPORT_SYMBOL(iwl_txq_check_empty);
-
-/**
- * iwl_tx_status_reply_compressed_ba - Update tx status from block-ack
- *
- * Go through block-ack's bitmap of ACK'd frames, update driver's record of
- * ACK vs. not.  This gets sent to mac80211, then to rate scaling algo.
- */
-static int iwl_tx_status_reply_compressed_ba(struct iwl_priv *priv,
-				 struct iwl_ht_agg *agg,
-				 struct iwl_compressed_ba_resp *ba_resp)
-
-{
-	int i, sh, ack;
-	u16 seq_ctl = le16_to_cpu(ba_resp->seq_ctl);
-	u16 scd_flow = le16_to_cpu(ba_resp->scd_flow);
-	u64 bitmap;
-	int successes = 0;
-	struct ieee80211_tx_info *info;
-
-	if (unlikely(!agg->wait_for_ba))  {
-		IWL_ERR(priv, "Received BA when not expected\n");
-		return -EINVAL;
-	}
-
-	/* Mark that the expected block-ack response arrived */
-	agg->wait_for_ba = 0;
-	IWL_DEBUG_TX_REPLY(priv, "BA %d %d\n", agg->start_idx, ba_resp->seq_ctl);
-
-	/* Calculate shift to align block-ack bits with our Tx window bits */
-	sh = agg->start_idx - SEQ_TO_INDEX(seq_ctl >> 4);
-	if (sh < 0) /* tbw something is wrong with indices */
-		sh += 0x100;
-
-	/* don't use 64-bit values for now */
-	bitmap = le64_to_cpu(ba_resp->bitmap) >> sh;
-
-	if (agg->frame_count > (64 - sh)) {
-		IWL_DEBUG_TX_REPLY(priv, "more frames than bitmap size");
-		return -1;
-	}
-
-	/* check for success or failure according to the
-	 * transmitted bitmap and block-ack bitmap */
-	bitmap &= agg->bitmap;
-
-	/* For each frame attempted in aggregation,
-	 * update driver's record of tx frame's status. */
-	for (i = 0; i < agg->frame_count ; i++) {
-		ack = bitmap & (1ULL << i);
-		successes += !!ack;
-		IWL_DEBUG_TX_REPLY(priv, "%s ON i=%d idx=%d raw=%d\n",
-			ack ? "ACK" : "NACK", i, (agg->start_idx + i) & 0xff,
-			agg->start_idx + i);
-	}
-
-	info = IEEE80211_SKB_CB(priv->txq[scd_flow].txb[agg->start_idx].skb[0]);
-	memset(&info->status, 0, sizeof(info->status));
-	info->flags |= IEEE80211_TX_STAT_ACK;
-	info->flags |= IEEE80211_TX_STAT_AMPDU;
-	info->status.ampdu_ack_map = successes;
-	info->status.ampdu_ack_len = agg->frame_count;
-	iwl_hwrate_to_tx_control(priv, agg->rate_n_flags, info);
-
-	IWL_DEBUG_TX_REPLY(priv, "Bitmap %llx\n", (unsigned long long)bitmap);
-
-	return 0;
-}
-
-/**
- * iwl_rx_reply_compressed_ba - Handler for REPLY_COMPRESSED_BA
- *
- * Handles block-acknowledge notification from device, which reports success
- * of frames sent via aggregation.
- */
-void iwl_rx_reply_compressed_ba(struct iwl_priv *priv,
-					   struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_compressed_ba_resp *ba_resp = &pkt->u.compressed_ba;
-	struct iwl_tx_queue *txq = NULL;
-	struct iwl_ht_agg *agg;
-	int index;
-	int sta_id;
-	int tid;
-
-	/* "flow" corresponds to Tx queue */
-	u16 scd_flow = le16_to_cpu(ba_resp->scd_flow);
-
-	/* "ssn" is start of block-ack Tx window, corresponds to index
-	 * (in Tx queue's circular buffer) of first TFD/frame in window */
-	u16 ba_resp_scd_ssn = le16_to_cpu(ba_resp->scd_ssn);
-
-	if (scd_flow >= priv->hw_params.max_txq_num) {
-		IWL_ERR(priv,
-			"BUG_ON scd_flow is bigger than number of queues\n");
-		return;
-	}
-
-	txq = &priv->txq[scd_flow];
-	sta_id = ba_resp->sta_id;
-	tid = ba_resp->tid;
-	agg = &priv->stations[sta_id].tid[tid].agg;
-
-	/* Find index just before block-ack window */
-	index = iwl_queue_dec_wrap(ba_resp_scd_ssn & 0xff, txq->q.n_bd);
-
-	/* TODO: Need to get this copy more safely - now good for debug */
-
-	IWL_DEBUG_TX_REPLY(priv, "REPLY_COMPRESSED_BA [%d] Received from %pM, "
-			   "sta_id = %d\n",
-			   agg->wait_for_ba,
-			   (u8 *) &ba_resp->sta_addr_lo32,
-			   ba_resp->sta_id);
-	IWL_DEBUG_TX_REPLY(priv, "TID = %d, SeqCtl = %d, bitmap = 0x%llx, scd_flow = "
-			   "%d, scd_ssn = %d\n",
-			   ba_resp->tid,
-			   ba_resp->seq_ctl,
-			   (unsigned long long)le64_to_cpu(ba_resp->bitmap),
-			   ba_resp->scd_flow,
-			   ba_resp->scd_ssn);
-	IWL_DEBUG_TX_REPLY(priv, "DAT start_idx = %d, bitmap = 0x%llx \n",
-			   agg->start_idx,
-			   (unsigned long long)agg->bitmap);
-
-	/* Update driver's record of ACK vs. not for each frame in window */
-	iwl_tx_status_reply_compressed_ba(priv, agg, ba_resp);
-
-	/* Release all TFDs before the SSN, i.e. all TFDs in front of
-	 * block-ack window (we assume that they've been successfully
-	 * transmitted ... if not, it's too late anyway). */
-	if (txq->q.read_ptr != (ba_resp_scd_ssn & 0xff)) {
-		/* calculate mac80211 ampdu sw queue to wake */
-		int freed = iwl_tx_queue_reclaim(priv, scd_flow, index);
-		iwl_free_tfds_in_queue(priv, sta_id, tid, freed);
-
-		if ((iwl_queue_space(&txq->q) > txq->q.low_mark) &&
-		    priv->mac80211_registered &&
-		    (agg->state != IWL_EMPTYING_HW_QUEUE_DELBA))
-			iwl_wake_queue(priv, txq->swq_id);
-
-		iwl_txq_check_empty(priv, sta_id, tid, scd_flow);
-	}
-}
-EXPORT_SYMBOL(iwl_rx_reply_compressed_ba);
-
 #ifdef CONFIG_IWLWIFI_DEBUG
 #define TX_STATUS_ENTRY(x) case TX_STATUS_FAIL_ ## x: return #x
 
-- 
1.6.3.3

