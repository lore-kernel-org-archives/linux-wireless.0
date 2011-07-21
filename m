Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47950 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174Ab1GUP0u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 11:26:50 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/25] iwlagn: SCD configuration for AMPDU moves to transport layer
Date: Thu, 21 Jul 2011 07:50:11 -0700
Message-Id: <1311259828-8415-9-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110721_172714_788482_8B414B8C)
In-Reply-To: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

All the configurations of the HW for AMPDU are now in the transport layer.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |  225 +--------------------
 drivers/net/wireless/iwlwifi/iwl-agn.c            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h            |   13 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h            |    8 +
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |   14 +-
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c  |  224 ++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans.c          |   10 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h          |   17 ++
 8 files changed, 274 insertions(+), 239 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index ece3202..932425d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -96,132 +96,8 @@ static inline int get_fifo_from_tid(struct iwl_rxon_context *ctx, u16 tid)
 	return -EINVAL;
 }
 
-/**
- * iwlagn_txq_update_byte_cnt_tbl - Set up entry in Tx byte-count array
- */
-void iwlagn_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
-					   struct iwl_tx_queue *txq,
-					   u16 byte_cnt)
-{
-	struct iwlagn_scd_bc_tbl *scd_bc_tbl = priv->scd_bc_tbls.addr;
-	int write_ptr = txq->q.write_ptr;
-	int txq_id = txq->q.id;
-	u8 sec_ctl = 0;
-	u8 sta_id = 0;
-	u16 len = byte_cnt + IWL_TX_CRC_SIZE + IWL_TX_DELIMITER_SIZE;
-	__le16 bc_ent;
-
-	WARN_ON(len > 0xFFF || write_ptr >= TFD_QUEUE_SIZE_MAX);
-
-	sta_id = txq->cmd[txq->q.write_ptr]->cmd.tx.sta_id;
-	sec_ctl = txq->cmd[txq->q.write_ptr]->cmd.tx.sec_ctl;
-
-	switch (sec_ctl & TX_CMD_SEC_MSK) {
-	case TX_CMD_SEC_CCM:
-		len += CCMP_MIC_LEN;
-		break;
-	case TX_CMD_SEC_TKIP:
-		len += TKIP_ICV_LEN;
-		break;
-	case TX_CMD_SEC_WEP:
-		len += WEP_IV_LEN + WEP_ICV_LEN;
-		break;
-	}
-
-	bc_ent = cpu_to_le16((len & 0xFFF) | (sta_id << 12));
-
-	scd_bc_tbl[txq_id].tfd_offset[write_ptr] = bc_ent;
-
-	if (write_ptr < TFD_QUEUE_SIZE_BC_DUP)
-		scd_bc_tbl[txq_id].
-			tfd_offset[TFD_QUEUE_SIZE_MAX + write_ptr] = bc_ent;
-}
-
-static void iwlagn_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
-					  struct iwl_tx_queue *txq)
-{
-	struct iwlagn_scd_bc_tbl *scd_bc_tbl = priv->scd_bc_tbls.addr;
-	int txq_id = txq->q.id;
-	int read_ptr = txq->q.read_ptr;
-	u8 sta_id = 0;
-	__le16 bc_ent;
-
-	WARN_ON(read_ptr >= TFD_QUEUE_SIZE_MAX);
-
-	if (txq_id != priv->cmd_queue)
-		sta_id = txq->cmd[read_ptr]->cmd.tx.sta_id;
-
-	bc_ent = cpu_to_le16(1 | (sta_id << 12));
-	scd_bc_tbl[txq_id].tfd_offset[read_ptr] = bc_ent;
-
-	if (read_ptr < TFD_QUEUE_SIZE_BC_DUP)
-		scd_bc_tbl[txq_id].
-			tfd_offset[TFD_QUEUE_SIZE_MAX + read_ptr] = bc_ent;
-}
-
-static int iwlagn_tx_queue_set_q2ratid(struct iwl_priv *priv, u16 ra_tid,
-					u16 txq_id)
-{
-	u32 tbl_dw_addr;
-	u32 tbl_dw;
-	u16 scd_q2ratid;
-
-	scd_q2ratid = ra_tid & SCD_QUEUE_RA_TID_MAP_RATID_MSK;
-
-	tbl_dw_addr = priv->scd_base_addr +
-			SCD_TRANS_TBL_OFFSET_QUEUE(txq_id);
-
-	tbl_dw = iwl_read_targ_mem(priv, tbl_dw_addr);
-
-	if (txq_id & 0x1)
-		tbl_dw = (scd_q2ratid << 16) | (tbl_dw & 0x0000FFFF);
-	else
-		tbl_dw = scd_q2ratid | (tbl_dw & 0xFFFF0000);
-
-	iwl_write_targ_mem(priv, tbl_dw_addr, tbl_dw);
-
-	return 0;
-}
-
-static void iwlagn_tx_queue_stop_scheduler(struct iwl_priv *priv, u16 txq_id)
-{
-	/* Simply stop the queue, but don't change any configuration;
-	 * the SCD_ACT_EN bit is the write-enable mask for the ACTIVE bit. */
-	iwl_write_prph(priv,
-		SCD_QUEUE_STATUS_BITS(txq_id),
-		(0 << SCD_QUEUE_STTS_REG_POS_ACTIVE)|
-		(1 << SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
-}
-
-void iwlagn_set_wr_ptrs(struct iwl_priv *priv,
-				int txq_id, u32 index)
-{
-	iwl_write_direct32(priv, HBUS_TARG_WRPTR,
-			(index & 0xff) | (txq_id << 8));
-	iwl_write_prph(priv, SCD_QUEUE_RDPTR(txq_id), index);
-}
-
-void iwlagn_tx_queue_set_status(struct iwl_priv *priv,
-					struct iwl_tx_queue *txq,
-					int tx_fifo_id, int scd_retry)
-{
-	int txq_id = txq->q.id;
-	int active = test_bit(txq_id, &priv->txq_ctx_active_msk) ? 1 : 0;
-
-	iwl_write_prph(priv, SCD_QUEUE_STATUS_BITS(txq_id),
-			(active << SCD_QUEUE_STTS_REG_POS_ACTIVE) |
-			(tx_fifo_id << SCD_QUEUE_STTS_REG_POS_TXF) |
-			(1 << SCD_QUEUE_STTS_REG_POS_WSL) |
-			SCD_QUEUE_STTS_REG_MSK);
-
-	txq->sched_retry = scd_retry;
-
-	IWL_DEBUG_INFO(priv, "%s %s Queue %d on FIFO %d\n",
-		       active ? "Activate" : "Deactivate",
-		       scd_retry ? "BA" : "AC/CMD", txq_id, tx_fifo_id);
-}
-
-static int iwlagn_txq_agg_enable(struct iwl_priv *priv, int txq_id, int sta_id, int tid)
+static int iwlagn_txq_agg_enable(struct iwl_priv *priv, int txq_id, int sta_id,
+				int tid)
 {
 	if ((IWLAGN_FIRST_AMPDU_QUEUE > txq_id) ||
 	    (IWLAGN_FIRST_AMPDU_QUEUE +
@@ -238,99 +114,6 @@ static int iwlagn_txq_agg_enable(struct iwl_priv *priv, int txq_id, int sta_id,
 	return iwl_sta_tx_modify_enable_tid(priv, sta_id, tid);
 }
 
-void iwlagn_txq_agg_queue_setup(struct iwl_priv *priv,
-				struct ieee80211_sta *sta,
-				int tid, int frame_limit)
-{
-	int sta_id, tx_fifo, txq_id, ssn_idx;
-	u16 ra_tid;
-	unsigned long flags;
-	struct iwl_tid_data *tid_data;
-
-	sta_id = iwl_sta_id(sta);
-	if (WARN_ON(sta_id == IWL_INVALID_STATION))
-		return;
-	if (WARN_ON(tid >= MAX_TID_COUNT))
-		return;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-	tid_data = &priv->stations[sta_id].tid[tid];
-	ssn_idx = SEQ_TO_SN(tid_data->seq_number);
-	txq_id = tid_data->agg.txq_id;
-	tx_fifo = tid_data->agg.tx_fifo;
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-
-	ra_tid = BUILD_RAxTID(sta_id, tid);
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	/* Stop this Tx queue before configuring it */
-	iwlagn_tx_queue_stop_scheduler(priv, txq_id);
-
-	/* Map receiver-address / traffic-ID to this queue */
-	iwlagn_tx_queue_set_q2ratid(priv, ra_tid, txq_id);
-
-	/* Set this queue as a chain-building queue */
-	iwl_set_bits_prph(priv, SCD_QUEUECHAIN_SEL, (1<<txq_id));
-
-	/* enable aggregations for the queue */
-	iwl_set_bits_prph(priv, SCD_AGGR_SEL, (1<<txq_id));
-
-	/* Place first TFD at index corresponding to start sequence number.
-	 * Assumes that ssn_idx is valid (!= 0xFFF) */
-	priv->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
-	priv->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
-	iwlagn_set_wr_ptrs(priv, txq_id, ssn_idx);
-
-	/* Set up Tx window size and frame limit for this queue */
-	iwl_write_targ_mem(priv, priv->scd_base_addr +
-			SCD_CONTEXT_QUEUE_OFFSET(txq_id) +
-			sizeof(u32),
-			((frame_limit <<
-			SCD_QUEUE_CTX_REG2_WIN_SIZE_POS) &
-			SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK) |
-			((frame_limit <<
-			SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
-			SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
-
-	iwl_set_bits_prph(priv, SCD_INTERRUPT_MASK, (1 << txq_id));
-
-	/* Set up Status area in SRAM, map to Tx DMA/FIFO, activate the queue */
-	iwlagn_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 1);
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-}
-
-static int iwlagn_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
-				  u16 ssn_idx, u8 tx_fifo)
-{
-	if ((IWLAGN_FIRST_AMPDU_QUEUE > txq_id) ||
-	    (IWLAGN_FIRST_AMPDU_QUEUE +
-		priv->cfg->base_params->num_of_ampdu_queues <= txq_id)) {
-		IWL_ERR(priv,
-			"queue number out of range: %d, must be %d to %d\n",
-			txq_id, IWLAGN_FIRST_AMPDU_QUEUE,
-			IWLAGN_FIRST_AMPDU_QUEUE +
-			priv->cfg->base_params->num_of_ampdu_queues - 1);
-		return -EINVAL;
-	}
-
-	iwlagn_tx_queue_stop_scheduler(priv, txq_id);
-
-	iwl_clear_bits_prph(priv, SCD_AGGR_SEL, (1 << txq_id));
-
-	priv->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
-	priv->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
-	/* supposes that ssn_idx is valid (!= 0xFFF) */
-	iwlagn_set_wr_ptrs(priv, txq_id, ssn_idx);
-
-	iwl_clear_bits_prph(priv, SCD_INTERRUPT_MASK, (1 << txq_id));
-	iwl_txq_ctx_deactivate(priv, txq_id);
-	iwlagn_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 0);
-
-	return 0;
-}
-
 static void iwlagn_tx_cmd_protection(struct iwl_priv *priv,
 				     struct ieee80211_tx_info *info,
 				     __le16 fc, __le32 *tx_flags)
@@ -850,7 +633,7 @@ int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	 * to deactivate the uCode queue, just return "success" to allow
 	 *  mac80211 to clean up it own data.
 	 */
-	iwlagn_txq_agg_disable(priv, txq_id, ssn, tx_fifo_id);
+	trans_txq_agg_disable(priv, txq_id, ssn, tx_fifo_id);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
@@ -879,7 +662,7 @@ int iwlagn_txq_check_empty(struct iwl_priv *priv,
 			u16 ssn = SEQ_TO_SN(tid_data->seq_number);
 			int tx_fifo = get_fifo_from_tid(ctx, tid);
 			IWL_DEBUG_HT(priv, "HW queue empty: continue DELBA flow\n");
-			iwlagn_txq_agg_disable(priv, txq_id, ssn, tx_fifo);
+			trans_txq_agg_disable(priv, txq_id, ssn, tx_fifo);
 			tid_data->agg.state = IWL_AGG_OFF;
 			ieee80211_stop_tx_ba_cb_irqsafe(ctx->vif, addr, tid);
 		}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 503c786..9ba5fcd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2461,7 +2461,7 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
 		buf_size = min_t(int, buf_size, LINK_QUAL_AGG_FRAME_LIMIT_DEF);
 
-		iwlagn_txq_agg_queue_setup(priv, sta, tid, buf_size);
+		trans_txq_agg_setup(priv, iwl_sta_id(sta), tid, buf_size);
 
 		/*
 		 * If the limit is 0, then it wasn't initialised yet,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 57c70b8..0a8417a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -127,15 +127,7 @@ int iwl_prepare_card_hw(struct iwl_priv *priv);
 int iwlagn_start_device(struct iwl_priv *priv);
 
 /* tx queue */
-void iwlagn_set_wr_ptrs(struct iwl_priv *priv,
-		     int txq_id, u32 index);
-void iwlagn_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
-					   struct iwl_tx_queue *txq,
-					   u16 byte_cnt);
-
-void iwlagn_tx_queue_set_status(struct iwl_priv *priv,
-			     struct iwl_tx_queue *txq,
-			     int tx_fifo_id, int scd_retry);
+/*TODO: this one should go to transport layer */
 void iwl_free_tfds_in_queue(struct iwl_priv *priv,
 			    int sta_id, int tid, int freed);
 
@@ -188,9 +180,6 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 			struct ieee80211_sta *sta, u16 tid, u16 *ssn);
 int iwlagn_tx_agg_stop(struct iwl_priv *priv, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta, u16 tid);
-void iwlagn_txq_agg_queue_setup(struct iwl_priv *priv,
-				struct ieee80211_sta *sta,
-				int tid, int frame_limit);
 int iwlagn_txq_check_empty(struct iwl_priv *priv,
 			   int sta_id, u8 tid, int txq_id);
 void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index d6d6fe9..b18a9a8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1245,6 +1245,9 @@ struct iwl_trans;
  * @send_cmd_pdu:send a host command: flags can be CMD_*
  * @get_tx_cmd: returns a pointer to a new Tx cmd for the upper layer use
  * @tx: send an skb
+ * @txq_agg_setup: setup a tx queue for AMPDU - will be called once the HW is
+ *                 ready and a successful ADDBA response has been received.
+ * @txq_agg_disable: de-configure a Tx queue to send AMPDUs
  * @kick_nic: remove the RESET from the embedded CPU and let it run
  * @sync_irq: the upper layer will typically disable interrupt and call this
  *            handler. After this handler returns, it is guaranteed that all
@@ -1272,6 +1275,11 @@ struct iwl_trans_ops {
 		struct iwl_tx_cmd *tx_cmd, int txq_id, __le16 fc, bool ampdu,
 		struct iwl_rxon_context *ctx);
 
+	int (*txq_agg_disable)(struct iwl_priv *priv, u16 txq_id,
+				  u16 ssn_idx, u8 tx_fifo);
+	void (*txq_agg_setup)(struct iwl_priv *priv, int sta_id, int tid,
+						int frame_limit);
+
 	void (*kick_nic)(struct iwl_priv *priv);
 
 	void (*sync_irq)(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
index 3015fac..b79330d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
@@ -66,7 +66,17 @@ int iwl_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
 int __must_check iwl_send_cmd_pdu(struct iwl_priv *priv, u8 id, u32 flags,
 			u16 len, const void *data);
 void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
-
+void iwl_trans_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
+					   struct iwl_tx_queue *txq,
+					   u16 byte_cnt);
+int iwl_trans_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
+				  u16 ssn_idx, u8 tx_fifo);
+void iwl_trans_set_wr_ptrs(struct iwl_priv *priv,
+		     int txq_id, u32 index);
+void iwl_trans_tx_queue_set_status(struct iwl_priv *priv,
+			     struct iwl_tx_queue *txq,
+			     int tx_fifo_id, int scd_retry);
+void iwl_trans_txq_agg_setup(struct iwl_priv *priv, int sta_id, int tid,
+						int frame_limit);
 
 #endif /* __iwl_trans_int_pcie_h__ */
-
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
index f3b531b..9cecb10 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@ -35,9 +35,56 @@
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-io.h"
+#include "iwl-sta.h"
 #include "iwl-helpers.h"
 #include "iwl-trans-int-pcie.h"
 
+/* TODO:this file should _not_ include the external API header file
+ * (iwl-trans.h). This is needed as a W/A until reclaim functions will move to
+ * the transport layer */
+#include "iwl-trans.h"
+
+/**
+ * iwl_trans_txq_update_byte_cnt_tbl - Set up entry in Tx byte-count array
+ */
+void iwl_trans_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
+					   struct iwl_tx_queue *txq,
+					   u16 byte_cnt)
+{
+	struct iwlagn_scd_bc_tbl *scd_bc_tbl = priv->scd_bc_tbls.addr;
+	int write_ptr = txq->q.write_ptr;
+	int txq_id = txq->q.id;
+	u8 sec_ctl = 0;
+	u8 sta_id = 0;
+	u16 len = byte_cnt + IWL_TX_CRC_SIZE + IWL_TX_DELIMITER_SIZE;
+	__le16 bc_ent;
+
+	WARN_ON(len > 0xFFF || write_ptr >= TFD_QUEUE_SIZE_MAX);
+
+	sta_id = txq->cmd[txq->q.write_ptr]->cmd.tx.sta_id;
+	sec_ctl = txq->cmd[txq->q.write_ptr]->cmd.tx.sec_ctl;
+
+	switch (sec_ctl & TX_CMD_SEC_MSK) {
+	case TX_CMD_SEC_CCM:
+		len += CCMP_MIC_LEN;
+		break;
+	case TX_CMD_SEC_TKIP:
+		len += TKIP_ICV_LEN;
+		break;
+	case TX_CMD_SEC_WEP:
+		len += WEP_IV_LEN + WEP_ICV_LEN;
+		break;
+	}
+
+	bc_ent = cpu_to_le16((len & 0xFFF) | (sta_id << 12));
+
+	scd_bc_tbl[txq_id].tfd_offset[write_ptr] = bc_ent;
+
+	if (write_ptr < TFD_QUEUE_SIZE_BC_DUP)
+		scd_bc_tbl[txq_id].
+			tfd_offset[TFD_QUEUE_SIZE_MAX + write_ptr] = bc_ent;
+}
+
 /**
  * iwl_txq_update_write_ptr - Send new write index to hardware
  */
@@ -291,6 +338,183 @@ int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
 	return 0;
 }
 
+/*TODO: this functions should NOT be exported from trans module - export it
+ * until the reclaim flow will be brought to the transport module too */
+void iwlagn_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
+					  struct iwl_tx_queue *txq)
+{
+	struct iwlagn_scd_bc_tbl *scd_bc_tbl = priv->scd_bc_tbls.addr;
+	int txq_id = txq->q.id;
+	int read_ptr = txq->q.read_ptr;
+	u8 sta_id = 0;
+	__le16 bc_ent;
+
+	WARN_ON(read_ptr >= TFD_QUEUE_SIZE_MAX);
+
+	if (txq_id != priv->cmd_queue)
+		sta_id = txq->cmd[read_ptr]->cmd.tx.sta_id;
+
+	bc_ent = cpu_to_le16(1 | (sta_id << 12));
+	scd_bc_tbl[txq_id].tfd_offset[read_ptr] = bc_ent;
+
+	if (read_ptr < TFD_QUEUE_SIZE_BC_DUP)
+		scd_bc_tbl[txq_id].
+			tfd_offset[TFD_QUEUE_SIZE_MAX + read_ptr] = bc_ent;
+}
+
+static int iwlagn_tx_queue_set_q2ratid(struct iwl_priv *priv, u16 ra_tid,
+					u16 txq_id)
+{
+	u32 tbl_dw_addr;
+	u32 tbl_dw;
+	u16 scd_q2ratid;
+
+	scd_q2ratid = ra_tid & SCD_QUEUE_RA_TID_MAP_RATID_MSK;
+
+	tbl_dw_addr = priv->scd_base_addr +
+			SCD_TRANS_TBL_OFFSET_QUEUE(txq_id);
+
+	tbl_dw = iwl_read_targ_mem(priv, tbl_dw_addr);
+
+	if (txq_id & 0x1)
+		tbl_dw = (scd_q2ratid << 16) | (tbl_dw & 0x0000FFFF);
+	else
+		tbl_dw = scd_q2ratid | (tbl_dw & 0xFFFF0000);
+
+	iwl_write_targ_mem(priv, tbl_dw_addr, tbl_dw);
+
+	return 0;
+}
+
+static void iwlagn_tx_queue_stop_scheduler(struct iwl_priv *priv, u16 txq_id)
+{
+	/* Simply stop the queue, but don't change any configuration;
+	 * the SCD_ACT_EN bit is the write-enable mask for the ACTIVE bit. */
+	iwl_write_prph(priv,
+		SCD_QUEUE_STATUS_BITS(txq_id),
+		(0 << SCD_QUEUE_STTS_REG_POS_ACTIVE)|
+		(1 << SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
+}
+
+void iwl_trans_set_wr_ptrs(struct iwl_priv *priv,
+				int txq_id, u32 index)
+{
+	iwl_write_direct32(priv, HBUS_TARG_WRPTR,
+			(index & 0xff) | (txq_id << 8));
+	iwl_write_prph(priv, SCD_QUEUE_RDPTR(txq_id), index);
+}
+
+void iwl_trans_tx_queue_set_status(struct iwl_priv *priv,
+					struct iwl_tx_queue *txq,
+					int tx_fifo_id, int scd_retry)
+{
+	int txq_id = txq->q.id;
+	int active = test_bit(txq_id, &priv->txq_ctx_active_msk) ? 1 : 0;
+
+	iwl_write_prph(priv, SCD_QUEUE_STATUS_BITS(txq_id),
+			(active << SCD_QUEUE_STTS_REG_POS_ACTIVE) |
+			(tx_fifo_id << SCD_QUEUE_STTS_REG_POS_TXF) |
+			(1 << SCD_QUEUE_STTS_REG_POS_WSL) |
+			SCD_QUEUE_STTS_REG_MSK);
+
+	txq->sched_retry = scd_retry;
+
+	IWL_DEBUG_INFO(priv, "%s %s Queue %d on FIFO %d\n",
+		       active ? "Activate" : "Deactivate",
+		       scd_retry ? "BA" : "AC/CMD", txq_id, tx_fifo_id);
+}
+
+void iwl_trans_txq_agg_setup(struct iwl_priv *priv, int sta_id, int tid,
+						int frame_limit)
+{
+	int tx_fifo, txq_id, ssn_idx;
+	u16 ra_tid;
+	unsigned long flags;
+	struct iwl_tid_data *tid_data;
+
+	if (WARN_ON(sta_id == IWL_INVALID_STATION))
+		return;
+	if (WARN_ON(tid >= MAX_TID_COUNT))
+		return;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	tid_data = &priv->stations[sta_id].tid[tid];
+	ssn_idx = SEQ_TO_SN(tid_data->seq_number);
+	txq_id = tid_data->agg.txq_id;
+	tx_fifo = tid_data->agg.tx_fifo;
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	ra_tid = BUILD_RAxTID(sta_id, tid);
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	/* Stop this Tx queue before configuring it */
+	iwlagn_tx_queue_stop_scheduler(priv, txq_id);
+
+	/* Map receiver-address / traffic-ID to this queue */
+	iwlagn_tx_queue_set_q2ratid(priv, ra_tid, txq_id);
+
+	/* Set this queue as a chain-building queue */
+	iwl_set_bits_prph(priv, SCD_QUEUECHAIN_SEL, (1<<txq_id));
+
+	/* enable aggregations for the queue */
+	iwl_set_bits_prph(priv, SCD_AGGR_SEL, (1<<txq_id));
+
+	/* Place first TFD at index corresponding to start sequence number.
+	 * Assumes that ssn_idx is valid (!= 0xFFF) */
+	priv->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
+	priv->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
+	iwl_trans_set_wr_ptrs(priv, txq_id, ssn_idx);
+
+	/* Set up Tx window size and frame limit for this queue */
+	iwl_write_targ_mem(priv, priv->scd_base_addr +
+			SCD_CONTEXT_QUEUE_OFFSET(txq_id) +
+			sizeof(u32),
+			((frame_limit <<
+			SCD_QUEUE_CTX_REG2_WIN_SIZE_POS) &
+			SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK) |
+			((frame_limit <<
+			SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
+			SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
+
+	iwl_set_bits_prph(priv, SCD_INTERRUPT_MASK, (1 << txq_id));
+
+	/* Set up Status area in SRAM, map to Tx DMA/FIFO, activate the queue */
+	iwl_trans_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 1);
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
+
+int iwl_trans_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
+				  u16 ssn_idx, u8 tx_fifo)
+{
+	if ((IWLAGN_FIRST_AMPDU_QUEUE > txq_id) ||
+	    (IWLAGN_FIRST_AMPDU_QUEUE +
+		priv->cfg->base_params->num_of_ampdu_queues <= txq_id)) {
+		IWL_ERR(priv,
+			"queue number out of range: %d, must be %d to %d\n",
+			txq_id, IWLAGN_FIRST_AMPDU_QUEUE,
+			IWLAGN_FIRST_AMPDU_QUEUE +
+			priv->cfg->base_params->num_of_ampdu_queues - 1);
+		return -EINVAL;
+	}
+
+	iwlagn_tx_queue_stop_scheduler(priv, txq_id);
+
+	iwl_clear_bits_prph(priv, SCD_AGGR_SEL, (1 << txq_id));
+
+	priv->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
+	priv->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
+	/* supposes that ssn_idx is valid (!= 0xFFF) */
+	iwl_trans_set_wr_ptrs(priv, txq_id, ssn_idx);
+
+	iwl_clear_bits_prph(priv, SCD_INTERRUPT_MASK, (1 << txq_id));
+	iwl_txq_ctx_deactivate(priv, txq_id);
+	iwl_trans_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 0);
+
+	return 0;
+}
+
 /*************** HOST COMMAND QUEUE FUNCTIONS   *****/
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 639b469..bddc12d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -686,7 +686,7 @@ static void iwl_trans_tx_start(struct iwl_priv *priv)
 	else
 		queue_to_fifo = iwlagn_default_queue_to_tx_fifo;
 
-	iwlagn_set_wr_ptrs(priv, priv->cmd_queue, 0);
+	iwl_trans_set_wr_ptrs(priv, priv->cmd_queue, 0);
 
 	/* make sure all queue are not stopped */
 	memset(&priv->queue_stopped[0], 0, sizeof(priv->queue_stopped));
@@ -712,7 +712,7 @@ static void iwl_trans_tx_start(struct iwl_priv *priv)
 
 		if (ac != IWL_AC_UNSET)
 			iwl_set_swq_id(&priv->txq[i], ac, i);
-		iwlagn_tx_queue_set_status(priv, &priv->txq[i], fifo, 0);
+		iwl_trans_tx_queue_set_status(priv, &priv->txq[i], fifo, 0);
 	}
 
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -919,7 +919,7 @@ static int iwl_trans_tx(struct iwl_priv *priv, struct sk_buff *skb,
 
 	/* Set up entry for this TFD in Tx byte-count array */
 	if (ampdu)
-		iwlagn_txq_update_byte_cnt_tbl(priv, txq,
+		iwl_trans_txq_update_byte_cnt_tbl(priv, txq,
 					       le16_to_cpu(tx_cmd->len));
 
 	dma_sync_single_for_device(priv->bus.dev, txcmd_phys, firstlen,
@@ -986,6 +986,10 @@ static const struct iwl_trans_ops trans_ops = {
 
 	.get_tx_cmd = iwl_trans_get_tx_cmd,
 	.tx = iwl_trans_tx,
+
+	.txq_agg_disable = iwl_trans_txq_agg_disable,
+	.txq_agg_setup = iwl_trans_txq_agg_setup,
+
 	.kick_nic = iwl_trans_kick_nic,
 
 	.sync_irq = iwl_trans_sync_irq,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 9a95049..215f4d5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -119,6 +119,18 @@ static inline int trans_tx(struct iwl_priv *priv, struct sk_buff *skb,
 	return priv->trans.ops->tx(priv, skb, tx_cmd, txq_id, fc, ampdu, ctx);
 }
 
+static inline int trans_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
+			  u16 ssn_idx, u8 tx_fifo)
+{
+	return priv->trans.ops->txq_agg_disable(priv, txq_id, ssn_idx, tx_fifo);
+}
+
+static inline void trans_txq_agg_setup(struct iwl_priv *priv, int sta_id,
+						int tid, int frame_limit)
+{
+	priv->trans.ops->txq_agg_setup(priv, sta_id, tid, frame_limit);
+}
+
 static inline void trans_kick_nic(struct iwl_priv *priv)
 {
 	priv->trans.ops->kick_nic(priv);
@@ -135,3 +147,8 @@ static inline void trans_free(struct iwl_priv *priv)
 }
 
 int iwl_trans_register(struct iwl_priv *priv);
+
+/*TODO: this functions should NOT be exported from trans module - export it
+ * until the reclaim flow will be brought to the transport module too */
+void iwlagn_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
+					  struct iwl_tx_queue *txq);
-- 
1.7.0.4

