Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50578 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753226AbdDKMiE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 08:38:04 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 11 Apr 2017 15:37:25 +0300
Message-Id: <20170411123742.12214-9-luca@coelho.fi> (sfid-20170411_144103_988254_6A64DF3E)
In-Reply-To: <20170411123742.12214-1-luca@coelho.fi>
References: <20170411123742.12214-1-luca@coelho.fi>
Subject: [PATCH 08/25] iwlwifi: pcie: print less data upon firmware crash
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

We don't need to print so much data in the kernel log.
Limit the data to be printed to the queue that actually
got stuck in case of a TFD queue hang, and stop dumping
all the CSR and FH registers. Over the course of time, the
CSR and FH values haven't proven themselves to be really
useful for debugging, and they are now in the firmware dump
anyway.

This comes as a preparation to the addition of more data
required to be printed by the firwmare team.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c    |  3 --
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 64 ++++++++++---------------
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c    |  3 --
 3 files changed, 24 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index de94dfdf2ec9..17806d82f3a3 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1393,9 +1393,6 @@ static void iwl_pcie_irq_handle_error(struct iwl_trans *trans)
 		return;
 	}
 
-	iwl_pcie_dump_csr(trans);
-	iwl_dump_fh(trans, NULL);
-
 	local_bh_disable();
 	/* The STATUS_FW_ERROR bit is set in this function. This must happen
 	 * before we wake up the command caller, to ensure a proper cleanup. */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 7f05fc56587a..fbb0afa9de14 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2007 - 2015 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2016 Intel Deutschland GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -34,7 +34,7 @@
  *
  * Copyright(c) 2005 - 2015 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2016 Intel Deutschland GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -2075,48 +2075,32 @@ static void iwl_trans_pcie_block_txq_ptrs(struct iwl_trans *trans, bool block)
 
 void iwl_trans_pcie_log_scd_error(struct iwl_trans *trans, struct iwl_txq *txq)
 {
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	u32 scd_sram_addr;
-	u8 buf[16];
-	int cnt;
+	u32 txq_id = txq->id;
+	u32 status;
+	bool active;
+	u8 fifo;
 
-	IWL_ERR(trans, "Current SW read_ptr %d write_ptr %d\n",
-		txq->read_ptr, txq->write_ptr);
-
-	if (trans->cfg->use_tfh)
+	if (trans->cfg->use_tfh) {
+		IWL_ERR(trans, "Queue %d is stuck %d %d\n", txq_id,
+			txq->read_ptr, txq->write_ptr);
 		/* TODO: access new SCD registers and dump them */
 		return;
-
-	scd_sram_addr = trans_pcie->scd_base_addr +
-			SCD_TX_STTS_QUEUE_OFFSET(txq->id);
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
 	}
+
+	status = iwl_read_prph(trans, SCD_QUEUE_STATUS_BITS(txq_id));
+	fifo = (status >> SCD_QUEUE_STTS_REG_POS_TXF) & 0x7;
+	active = !!(status & BIT(SCD_QUEUE_STTS_REG_POS_ACTIVE));
+
+	IWL_ERR(trans,
+		"Queue %d is %sactive on fifo %d and stuck for %u ms. SW [%d, %d] HW [%d, %d] FH TRB=0x0%x\n",
+		txq_id, active ? "" : "in", fifo,
+		jiffies_to_msecs(txq->wd_timeout),
+		txq->read_ptr, txq->write_ptr,
+		iwl_read_prph(trans, SCD_QUEUE_RDPTR(txq_id)) &
+			(TFD_QUEUE_SIZE_MAX - 1),
+		iwl_read_prph(trans, SCD_QUEUE_WRPTR(txq_id)) &
+			(TFD_QUEUE_SIZE_MAX - 1),
+		iwl_read_direct32(trans, FH_TX_TRB_REG(fifo)));
 }
 
 static int iwl_trans_pcie_wait_txq_empty(struct iwl_trans *trans, u32 txq_bm)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 911cf9868107..03df578bed00 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -164,9 +164,6 @@ static void iwl_pcie_txq_stuck_timer(unsigned long data)
 	}
 	spin_unlock(&txq->lock);
 
-	IWL_ERR(trans, "Queue %d stuck for %u ms.\n", txq->id,
-		jiffies_to_msecs(txq->wd_timeout));
-
 	iwl_trans_pcie_log_scd_error(trans, txq);
 
 	iwl_force_nmi(trans);
-- 
2.11.0
