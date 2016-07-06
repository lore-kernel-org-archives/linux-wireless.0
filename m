Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33354 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751832AbcGFKoJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:44:09 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:50 +0300
Message-Id: <1467801651-1816-55-git-send-email-luca@coelho.fi> (sfid-20160706_124417_560546_5E19FE65)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 55/56] iwlwifi: pcie: centralize SCD status logging
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Centralize the logging of SCD status. The motivation is
that for a000 devices we will have new SCD HW, but this
code was duplicate anyway, so it is a proper cleanup.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  2 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 82 ++++++++++++----------
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       | 36 +---------
 3 files changed, 47 insertions(+), 73 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index c3d8974..e3047f2 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -476,6 +476,8 @@ void iwl_trans_pcie_txq_disable(struct iwl_trans *trans, int queue,
 				bool configure_scd);
 void iwl_trans_pcie_txq_set_shared_mode(struct iwl_trans *trans, u32 txq_id,
 					bool shared_mode);
+void iwl_trans_pcie_log_scd_error(struct iwl_trans *trans,
+				  struct iwl_txq *txq);
 int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		      struct iwl_device_cmd *dev_cmd, int txq_id);
 void iwl_pcie_txq_check_wrptrs(struct iwl_trans *trans);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index af04dad..74f2f03 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1950,6 +1950,48 @@ static void iwl_trans_pcie_block_txq_ptrs(struct iwl_trans *trans, bool block)
 
 #define IWL_FLUSH_WAIT_MS	2000
 
+void iwl_trans_pcie_log_scd_error(struct iwl_trans *trans, struct iwl_txq *txq)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	u32 scd_sram_addr;
+	u8 buf[16];
+	int cnt;
+
+	IWL_ERR(trans, "Current SW read_ptr %d write_ptr %d\n",
+		txq->q.read_ptr, txq->q.write_ptr);
+
+	scd_sram_addr = trans_pcie->scd_base_addr +
+			SCD_TX_STTS_QUEUE_OFFSET(txq->q.id);
+	iwl_trans_read_mem_bytes(trans, scd_sram_addr, buf, sizeof(buf));
+
+	iwl_print_hex_error(trans, buf, sizeof(buf));
+
+	for (cnt = 0; cnt < FH_TCSR_CHNL_NUM; cnt++)
+		IWL_ERR(trans, "FH TRBs(%d) = 0x%08x\n", cnt,
+			iwl_read_direct32(trans, FH_TX_TRB_REG(cnt)));
+
+	for (cnt = 0; cnt < trans->cfg->base_params->num_of_queues; cnt++) {
+		u32 status = iwl_read_prph(trans, SCD_QUEUE_STATUS_BITS(cnt));
+		u8 fifo = (status >> SCD_QUEUE_STTS_REG_POS_TXF) & 0x7;
+		bool active = !!(status & BIT(SCD_QUEUE_STTS_REG_POS_ACTIVE));
+		u32 tbl_dw =
+			iwl_trans_read_mem32(trans, trans_pcie->scd_base_addr +
+					     SCD_TRANS_TBL_OFFSET_QUEUE(cnt));
+
+		if (cnt & 0x1)
+			tbl_dw = (tbl_dw & 0xFFFF0000) >> 16;
+		else
+			tbl_dw = tbl_dw & 0x0000FFFF;
+
+		IWL_ERR(trans,
+			"Q %d is %sactive and mapped to fifo %d ra_tid 0x%04x [%d,%d]\n",
+			cnt, active ? "" : "in", fifo, tbl_dw,
+			iwl_read_prph(trans, SCD_QUEUE_RDPTR(cnt)) &
+				(TFD_QUEUE_SIZE_MAX - 1),
+			iwl_read_prph(trans, SCD_QUEUE_WRPTR(cnt)));
+	}
+}
+
 static int iwl_trans_pcie_wait_txq_empty(struct iwl_trans *trans, u32 txq_bm)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
@@ -1957,8 +1999,6 @@ static int iwl_trans_pcie_wait_txq_empty(struct iwl_trans *trans, u32 txq_bm)
 	struct iwl_queue *q;
 	int cnt;
 	unsigned long now = jiffies;
-	u32 scd_sram_addr;
-	u8 buf[16];
 	int ret = 0;
 
 	/* waiting for all the tx frames complete might take a while */
@@ -1998,42 +2038,8 @@ static int iwl_trans_pcie_wait_txq_empty(struct iwl_trans *trans, u32 txq_bm)
 		IWL_DEBUG_TX_QUEUES(trans, "Queue %d is now empty.\n", cnt);
 	}
 
-	if (!ret)
-		return 0;
-
-	IWL_ERR(trans, "Current SW read_ptr %d write_ptr %d\n",
-		txq->q.read_ptr, txq->q.write_ptr);
-
-	scd_sram_addr = trans_pcie->scd_base_addr +
-			SCD_TX_STTS_QUEUE_OFFSET(txq->q.id);
-	iwl_trans_read_mem_bytes(trans, scd_sram_addr, buf, sizeof(buf));
-
-	iwl_print_hex_error(trans, buf, sizeof(buf));
-
-	for (cnt = 0; cnt < FH_TCSR_CHNL_NUM; cnt++)
-		IWL_ERR(trans, "FH TRBs(%d) = 0x%08x\n", cnt,
-			iwl_read_direct32(trans, FH_TX_TRB_REG(cnt)));
-
-	for (cnt = 0; cnt < trans->cfg->base_params->num_of_queues; cnt++) {
-		u32 status = iwl_read_prph(trans, SCD_QUEUE_STATUS_BITS(cnt));
-		u8 fifo = (status >> SCD_QUEUE_STTS_REG_POS_TXF) & 0x7;
-		bool active = !!(status & BIT(SCD_QUEUE_STTS_REG_POS_ACTIVE));
-		u32 tbl_dw =
-			iwl_trans_read_mem32(trans, trans_pcie->scd_base_addr +
-					     SCD_TRANS_TBL_OFFSET_QUEUE(cnt));
-
-		if (cnt & 0x1)
-			tbl_dw = (tbl_dw & 0xFFFF0000) >> 16;
-		else
-			tbl_dw = tbl_dw & 0x0000FFFF;
-
-		IWL_ERR(trans,
-			"Q %d is %sactive and mapped to fifo %d ra_tid 0x%04x [%d,%d]\n",
-			cnt, active ? "" : "in", fifo, tbl_dw,
-			iwl_read_prph(trans, SCD_QUEUE_RDPTR(cnt)) &
-				(TFD_QUEUE_SIZE_MAX - 1),
-			iwl_read_prph(trans, SCD_QUEUE_WRPTR(cnt)));
-	}
+	if (ret)
+		iwl_trans_pcie_log_scd_error(trans, txq);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index d88d64c..18650dc 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -155,10 +155,6 @@ static void iwl_pcie_txq_stuck_timer(unsigned long data)
 	struct iwl_txq *txq = (void *)data;
 	struct iwl_trans_pcie *trans_pcie = txq->trans_pcie;
 	struct iwl_trans *trans = iwl_trans_pcie_get_trans(trans_pcie);
-	u32 scd_sram_addr = trans_pcie->scd_base_addr +
-				SCD_TX_STTS_QUEUE_OFFSET(txq->q.id);
-	u8 buf[16];
-	int i;
 
 	spin_lock(&txq->lock);
 	/* check if triggered erroneously */
@@ -170,38 +166,8 @@ static void iwl_pcie_txq_stuck_timer(unsigned long data)
 
 	IWL_ERR(trans, "Queue %d stuck for %u ms.\n", txq->q.id,
 		jiffies_to_msecs(txq->wd_timeout));
-	IWL_ERR(trans, "Current SW read_ptr %d write_ptr %d\n",
-		txq->q.read_ptr, txq->q.write_ptr);
-
-	iwl_trans_read_mem_bytes(trans, scd_sram_addr, buf, sizeof(buf));
-
-	iwl_print_hex_error(trans, buf, sizeof(buf));
 
-	for (i = 0; i < FH_TCSR_CHNL_NUM; i++)
-		IWL_ERR(trans, "FH TRBs(%d) = 0x%08x\n", i,
-			iwl_read_direct32(trans, FH_TX_TRB_REG(i)));
-
-	for (i = 0; i < trans->cfg->base_params->num_of_queues; i++) {
-		u32 status = iwl_read_prph(trans, SCD_QUEUE_STATUS_BITS(i));
-		u8 fifo = (status >> SCD_QUEUE_STTS_REG_POS_TXF) & 0x7;
-		bool active = !!(status & BIT(SCD_QUEUE_STTS_REG_POS_ACTIVE));
-		u32 tbl_dw =
-			iwl_trans_read_mem32(trans,
-					     trans_pcie->scd_base_addr +
-					     SCD_TRANS_TBL_OFFSET_QUEUE(i));
-
-		if (i & 0x1)
-			tbl_dw = (tbl_dw & 0xFFFF0000) >> 16;
-		else
-			tbl_dw = tbl_dw & 0x0000FFFF;
-
-		IWL_ERR(trans,
-			"Q %d is %sactive and mapped to fifo %d ra_tid 0x%04x [%d,%d]\n",
-			i, active ? "" : "in", fifo, tbl_dw,
-			iwl_read_prph(trans, SCD_QUEUE_RDPTR(i)) &
-				(TFD_QUEUE_SIZE_MAX - 1),
-			iwl_read_prph(trans, SCD_QUEUE_WRPTR(i)));
-	}
+	iwl_trans_pcie_log_scd_error(trans, txq);
 
 	iwl_force_nmi(trans);
 }
-- 
2.8.1

