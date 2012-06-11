Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48530 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab2FKJxe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 05:53:34 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/13] iwlwifi: don't configure a txq that is being disabled
Date: Mon, 11 Jun 2012 11:53:06 +0200
Message-Id: <1339408392-19425-8-git-send-email-johannes@sipsolutions.net> (sfid-20120611_115350_587929_CDA85F88)
In-Reply-To: <1339408392-19425-1-git-send-email-johannes@sipsolutions.net>
References: <1339408392-19425-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This is not needed, we just need to tell the SCD not to use
that queue. We will reconfigure that queue when we will use
it again.

Clean up a bit the code on the way.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/internal.h |    4 --
 drivers/net/wireless/iwlwifi/pcie/tx.c       |   73 +++++++++++---------------
 2 files changed, 30 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index 94201c4..6c7b355 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -340,10 +340,6 @@ void iwl_trans_txq_update_byte_cnt_tbl(struct iwl_trans *trans,
 				       struct iwl_tx_queue *txq,
 				       u16 byte_cnt);
 void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int queue);
-void iwl_trans_set_wr_ptrs(struct iwl_trans *trans, int txq_id, u32 index);
-void iwl_trans_tx_queue_set_status(struct iwl_trans *trans,
-				   struct iwl_tx_queue *txq,
-				   int tx_fifo_id, bool active);
 void __iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id,
 					int fifo, int sta_id, int tid,
 					int frame_limit, u16 ssn);
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 35e8216..18e6c81 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -380,8 +380,8 @@ static void iwlagn_txq_inval_byte_cnt_tbl(struct iwl_trans *trans,
 			tfd_offset[TFD_QUEUE_SIZE_MAX + read_ptr] = bc_ent;
 }
 
-static int iwlagn_tx_queue_set_q2ratid(struct iwl_trans *trans, u16 ra_tid,
-				       u16 txq_id)
+static int iwl_txq_set_ratid_map(struct iwl_trans *trans, u16 ra_tid,
+				 u16 txq_id)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 tbl_dw_addr;
@@ -405,7 +405,7 @@ static int iwlagn_tx_queue_set_q2ratid(struct iwl_trans *trans, u16 ra_tid,
 	return 0;
 }
 
-static void iwlagn_tx_queue_stop_scheduler(struct iwl_trans *trans, u16 txq_id)
+static inline void iwl_txq_set_inactive(struct iwl_trans *trans, u16 txq_id)
 {
 	/* Simply stop the queue, but don't change any configuration;
 	 * the SCD_ACT_EN bit is the write-enable mask for the ACTIVE bit. */
@@ -415,33 +415,6 @@ static void iwlagn_tx_queue_stop_scheduler(struct iwl_trans *trans, u16 txq_id)
 		(1 << SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
 }
 
-void iwl_trans_set_wr_ptrs(struct iwl_trans *trans, int txq_id, u32 index)
-{
-	IWL_DEBUG_TX_QUEUES(trans, "Q %d  WrPtr: %d\n", txq_id, index & 0xff);
-	iwl_write_direct32(trans, HBUS_TARG_WRPTR,
-			   (index & 0xff) | (txq_id << 8));
-	iwl_write_prph(trans, SCD_QUEUE_RDPTR(txq_id), index);
-}
-
-void iwl_trans_tx_queue_set_status(struct iwl_trans *trans,
-				   struct iwl_tx_queue *txq,
-				   int tx_fifo_id, bool active)
-{
-	int txq_id = txq->q.id;
-
-	iwl_write_prph(trans, SCD_QUEUE_STATUS_BITS(txq_id),
-			(active << SCD_QUEUE_STTS_REG_POS_ACTIVE) |
-			(tx_fifo_id << SCD_QUEUE_STTS_REG_POS_TXF) |
-			(1 << SCD_QUEUE_STTS_REG_POS_WSL) |
-			SCD_QUEUE_STTS_REG_MSK);
-
-	if (active)
-		IWL_DEBUG_TX_QUEUES(trans, "Activate queue %d on FIFO %d\n",
-				    txq_id, tx_fifo_id);
-	else
-		IWL_DEBUG_TX_QUEUES(trans, "Deactivate queue %d\n", txq_id);
-}
-
 void __iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id,
 					int fifo, int sta_id, int tid,
 					int frame_limit, u16 ssn)
@@ -454,7 +427,7 @@ void __iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id,
 		WARN_ONCE(1, "queue %d already used - expect issues", txq_id);
 
 	/* Stop this Tx queue before configuring it */
-	iwlagn_tx_queue_stop_scheduler(trans, txq_id);
+	iwl_txq_set_inactive(trans, txq_id);
 
 	/* Set this queue as a chain-building queue unless it is CMD queue */
 	if (txq_id != trans_pcie->cmd_queue)
@@ -465,17 +438,27 @@ void __iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id,
 		u16 ra_tid = BUILD_RAxTID(sta_id, tid);
 
 		/* Map receiver-address / traffic-ID to this queue */
-		iwlagn_tx_queue_set_q2ratid(trans, ra_tid, txq_id);
+		iwl_txq_set_ratid_map(trans, ra_tid, txq_id);
 
 		/* enable aggregations for the queue */
 		iwl_set_bits_prph(trans, SCD_AGGR_SEL, BIT(txq_id));
+	} else {
+		/*
+		 * disable aggregations for the queue, this will also make the
+		 * ra_tid mapping configuration irrelevant since it is now a
+		 * non-AGG queue.
+		 */
+		iwl_clear_bits_prph(trans, SCD_AGGR_SEL, BIT(txq_id));
 	}
 
 	/* Place first TFD at index corresponding to start sequence number.
 	 * Assumes that ssn_idx is valid (!= 0xFFF) */
 	trans_pcie->txq[txq_id].q.read_ptr = (ssn & 0xff);
 	trans_pcie->txq[txq_id].q.write_ptr = (ssn & 0xff);
-	iwl_trans_set_wr_ptrs(trans, txq_id, ssn);
+
+	iwl_write_direct32(trans, HBUS_TARG_WRPTR,
+			   (ssn & 0xff) | (txq_id << 8));
+	iwl_write_prph(trans, SCD_QUEUE_RDPTR(txq_id), ssn);
 
 	/* Set up Tx window size and frame limit for this queue */
 	iwl_write_targ_mem(trans, trans_pcie->scd_base_addr +
@@ -488,8 +471,13 @@ void __iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id,
 				SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
 
 	/* Set up Status area in SRAM, map to Tx DMA/FIFO, activate the queue */
-	iwl_trans_tx_queue_set_status(trans, &trans_pcie->txq[txq_id],
-				      fifo, true);
+	iwl_write_prph(trans, SCD_QUEUE_STATUS_BITS(txq_id),
+		       (1 << SCD_QUEUE_STTS_REG_POS_ACTIVE) |
+		       (fifo << SCD_QUEUE_STTS_REG_POS_TXF) |
+		       (1 << SCD_QUEUE_STTS_REG_POS_WSL) |
+		       SCD_QUEUE_STTS_REG_MSK);
+	IWL_DEBUG_TX_QUEUES(trans, "Activate queue %d on FIFO %d WrPtr: %d\n",
+			    txq_id, fifo, ssn & 0xff);
 }
 
 void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, int fifo,
@@ -509,22 +497,21 @@ void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, int fifo,
 void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int txq_id)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	u16 rd_ptr, wr_ptr;
 
 	if (!test_and_clear_bit(txq_id, trans_pcie->queue_used)) {
 		WARN_ONCE(1, "queue %d not used", txq_id);
 		return;
 	}
 
-	iwlagn_tx_queue_stop_scheduler(trans, txq_id);
-
-	iwl_clear_bits_prph(trans, SCD_AGGR_SEL, BIT(txq_id));
+	rd_ptr = iwl_read_prph(trans, SCD_QUEUE_RDPTR(txq_id));
+	wr_ptr = iwl_read_prph(trans, SCD_QUEUE_RDPTR(txq_id));
 
-	trans_pcie->txq[txq_id].q.read_ptr = 0;
-	trans_pcie->txq[txq_id].q.write_ptr = 0;
-	iwl_trans_set_wr_ptrs(trans, txq_id, 0);
+	WARN_ONCE(rd_ptr != wr_ptr, "queue %d isn't empty: [%d,%d]",
+		  txq_id, rd_ptr, wr_ptr);
 
-	iwl_trans_tx_queue_set_status(trans, &trans_pcie->txq[txq_id],
-				      0, false);
+	iwl_txq_set_inactive(trans, txq_id);
+	IWL_DEBUG_TX_QUEUES(trans, "Deactivate queue %d\n", txq_id);
 }
 
 /*************** HOST COMMAND QUEUE FUNCTIONS   *****/
-- 
1.7.10

