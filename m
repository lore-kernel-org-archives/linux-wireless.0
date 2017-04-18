Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52894 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1757908AbdDRWWh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 18:22:37 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Apr 2017 01:17:17 +0300
Message-Id: <20170418221729.28372-14-luca@coelho.fi> (sfid-20170419_002242_633758_1641E291)
In-Reply-To: <20170418221729.28372-1-luca@coelho.fi>
References: <20170418221729.28372-1-luca@coelho.fi>
Subject: [PATCH 13/25] iwlwifi: mvm: support change to a000 smem API
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

API was changed once more to support 2 LMACs.
Adapt to change while preserving current functionality.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h   |   2 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h |  41 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c | 287 ++++++++++++++----------
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c     |  53 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h    |  11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c     |   2 +-
 6 files changed, 241 insertions(+), 155 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
index 4bceaccee62f..f832e58e0ef9 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
@@ -314,6 +314,8 @@
 #define LMPM_SECURE_CPU1_HDR_MEM_SPACE		(0x420000)
 #define LMPM_SECURE_CPU2_HDR_MEM_SPACE		(0x420400)
 
+#define LMAC2_PRPH_OFFSET		(0x100000)
+
 /* Rx FIFO */
 #define RXF_SIZE_ADDR			(0xa00c88)
 #define RXF_RD_D_SPACE			(0xa00c40)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index dd2bd7c3587c..56f50d8a7b69 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -2026,19 +2026,48 @@ struct iwl_shared_mem_cfg_v1 {
 	__le32 internal_txfifo_size[TX_FIFO_INTERNAL_MAX_NUM];
 } __packed; /* SHARED_MEM_ALLOC_API_S_VER_2 */
 
+/**
+ * struct iwl_shared_mem_lmac_cfg - LMAC shared memory configuration
+ *
+ * @txfifo_addr: start addr of TXF0 (excluding the context table 0.5KB)
+ * @txfifo_size: size of TX FIFOs
+ * @rxfifo1_addr: RXF1 addr
+ * @rxfifo1_size: RXF1 size
+ */
+struct iwl_shared_mem_lmac_cfg {
+	__le32 txfifo_addr;
+	__le32 txfifo_size[TX_FIFO_MAX_NUM];
+	__le32 rxfifo1_addr;
+	__le32 rxfifo1_size;
+
+} __packed; /* SHARED_MEM_ALLOC_LMAC_API_S_VER_1 */
+
+/**
+ * Shared memory configuration information from the FW
+ *
+ * @shared_mem_addr: shared memory address
+ * @shared_mem_size: shared memory size
+ * @sample_buff_addr: internal sample (mon/adc) buff addr
+ * @sample_buff_size: internal sample buff size
+ * @rxfifo2_addr: start addr of RXF2
+ * @rxfifo2_size: size of RXF2
+ * @page_buff_addr: used by UMAC and performance debug (page miss analysis),
+ *	when paging is not supported this should be 0
+ * @page_buff_size: size of %page_buff_addr
+ * @lmac_num: number of LMACs (1 or 2)
+ * @lmac_smem: per - LMAC smem data
+ */
 struct iwl_shared_mem_cfg {
 	__le32 shared_mem_addr;
 	__le32 shared_mem_size;
 	__le32 sample_buff_addr;
 	__le32 sample_buff_size;
-	__le32 txfifo_addr;
-	__le32 txfifo_size[TX_FIFO_MAX_NUM];
-	__le32 rxfifo_size[RX_FIFO_MAX_NUM];
+	__le32 rxfifo2_addr;
+	__le32 rxfifo2_size;
 	__le32 page_buff_addr;
 	__le32 page_buff_size;
-	__le32 rxfifo_addr;
-	__le32 internal_txfifo_addr;
-	__le32 internal_txfifo_size[TX_FIFO_INTERNAL_MAX_NUM];
+	__le32 lmac_num;
+	struct iwl_shared_mem_lmac_cfg lmac_smem[2];
 } __packed; /* SHARED_MEM_ALLOC_API_S_VER_3 */
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
index a027b11bbdb3..7b86a4f1b574 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
+ * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -32,7 +32,7 @@
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
+ * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -99,10 +99,120 @@ static void iwl_mvm_read_radio_reg(struct iwl_mvm *mvm,
 	iwl_trans_release_nic_access(mvm->trans, &flags);
 }
 
+static void iwl_mvm_dump_rxf(struct iwl_mvm *mvm,
+			     struct iwl_fw_error_dump_data **dump_data,
+			     int size, u32 offset, int fifo_num)
+{
+	struct iwl_fw_error_dump_fifo *fifo_hdr;
+	u32 *fifo_data;
+	u32 fifo_len;
+	int i;
+
+	fifo_hdr = (void *)(*dump_data)->data;
+	fifo_data = (void *)fifo_hdr->data;
+	fifo_len = size;
+
+	/* No need to try to read the data if the length is 0 */
+	if (fifo_len == 0)
+		return;
+
+	/* Add a TLV for the RXF */
+	(*dump_data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_RXF);
+	(*dump_data)->len = cpu_to_le32(fifo_len + sizeof(*fifo_hdr));
+
+	fifo_hdr->fifo_num = cpu_to_le32(fifo_num);
+	fifo_hdr->available_bytes =
+		cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+						RXF_RD_D_SPACE + offset));
+	fifo_hdr->wr_ptr =
+		cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+						RXF_RD_WR_PTR + offset));
+	fifo_hdr->rd_ptr =
+		cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+						RXF_RD_RD_PTR + offset));
+	fifo_hdr->fence_ptr =
+		cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+						RXF_RD_FENCE_PTR + offset));
+	fifo_hdr->fence_mode =
+		cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+						RXF_SET_FENCE_MODE + offset));
+
+	/* Lock fence */
+	iwl_trans_write_prph(mvm->trans, RXF_SET_FENCE_MODE + offset, 0x1);
+	/* Set fence pointer to the same place like WR pointer */
+	iwl_trans_write_prph(mvm->trans, RXF_LD_WR2FENCE + offset, 0x1);
+	/* Set fence offset */
+	iwl_trans_write_prph(mvm->trans,
+			     RXF_LD_FENCE_OFFSET_ADDR + offset, 0x0);
+
+	/* Read FIFO */
+	fifo_len /= sizeof(u32); /* Size in DWORDS */
+	for (i = 0; i < fifo_len; i++)
+		fifo_data[i] = iwl_trans_read_prph(mvm->trans,
+						 RXF_FIFO_RD_FENCE_INC +
+						 offset);
+	*dump_data = iwl_fw_error_next_data(*dump_data);
+}
+
+static void iwl_mvm_dump_txf(struct iwl_mvm *mvm,
+			     struct iwl_fw_error_dump_data **dump_data,
+			     int size, u32 offset, int fifo_num)
+{
+	struct iwl_fw_error_dump_fifo *fifo_hdr;
+	u32 *fifo_data;
+	u32 fifo_len;
+	int i;
+
+	fifo_hdr = (void *)(*dump_data)->data;
+	fifo_data = (void *)fifo_hdr->data;
+	fifo_len = size;
+
+	/* No need to try to read the data if the length is 0 */
+	if (fifo_len == 0)
+		return;
+
+	/* Add a TLV for the FIFO */
+	(*dump_data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_TXF);
+	(*dump_data)->len = cpu_to_le32(fifo_len + sizeof(*fifo_hdr));
+
+	fifo_hdr->fifo_num = cpu_to_le32(fifo_num);
+	fifo_hdr->available_bytes =
+		cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+						TXF_FIFO_ITEM_CNT + offset));
+	fifo_hdr->wr_ptr =
+		cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+						TXF_WR_PTR + offset));
+	fifo_hdr->rd_ptr =
+		cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+						TXF_RD_PTR + offset));
+	fifo_hdr->fence_ptr =
+		cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+						TXF_FENCE_PTR + offset));
+	fifo_hdr->fence_mode =
+		cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+						TXF_LOCK_FENCE + offset));
+
+	/* Set the TXF_READ_MODIFY_ADDR to TXF_WR_PTR */
+	iwl_trans_write_prph(mvm->trans, TXF_READ_MODIFY_ADDR + offset,
+			     TXF_WR_PTR + offset);
+
+	/* Dummy-read to advance the read pointer to the head */
+	iwl_trans_read_prph(mvm->trans, TXF_READ_MODIFY_DATA + offset);
+
+	/* Read FIFO */
+	fifo_len /= sizeof(u32); /* Size in DWORDS */
+	for (i = 0; i < fifo_len; i++)
+		fifo_data[i] = iwl_trans_read_prph(mvm->trans,
+						  TXF_READ_MODIFY_DATA +
+						  offset);
+	*dump_data = iwl_fw_error_next_data(*dump_data);
+}
+
 static void iwl_mvm_dump_fifos(struct iwl_mvm *mvm,
 			       struct iwl_fw_error_dump_data **dump_data)
 {
 	struct iwl_fw_error_dump_fifo *fifo_hdr;
+	struct iwl_mvm_shared_mem_cfg *cfg = &mvm->smem_cfg;
 	u32 *fifo_data;
 	u32 fifo_len;
 	unsigned long flags;
@@ -111,126 +221,47 @@ static void iwl_mvm_dump_fifos(struct iwl_mvm *mvm,
 	if (!iwl_trans_grab_nic_access(mvm->trans, &flags))
 		return;
 
-	/* Pull RXF data from all RXFs */
-	for (i = 0; i < ARRAY_SIZE(mvm->shared_mem_cfg.rxfifo_size); i++) {
-		/*
-		 * Keep aside the additional offset that might be needed for
-		 * next RXF
-		 */
-		u32 offset_diff = RXF_DIFF_FROM_PREV * i;
-
-		fifo_hdr = (void *)(*dump_data)->data;
-		fifo_data = (void *)fifo_hdr->data;
-		fifo_len = mvm->shared_mem_cfg.rxfifo_size[i];
-
-		/* No need to try to read the data if the length is 0 */
-		if (fifo_len == 0)
-			continue;
-
-		/* Add a TLV for the RXF */
-		(*dump_data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_RXF);
-		(*dump_data)->len = cpu_to_le32(fifo_len + sizeof(*fifo_hdr));
-
-		fifo_hdr->fifo_num = cpu_to_le32(i);
-		fifo_hdr->available_bytes =
-			cpu_to_le32(iwl_trans_read_prph(mvm->trans,
-							RXF_RD_D_SPACE +
-							offset_diff));
-		fifo_hdr->wr_ptr =
-			cpu_to_le32(iwl_trans_read_prph(mvm->trans,
-							RXF_RD_WR_PTR +
-							offset_diff));
-		fifo_hdr->rd_ptr =
-			cpu_to_le32(iwl_trans_read_prph(mvm->trans,
-							RXF_RD_RD_PTR +
-							offset_diff));
-		fifo_hdr->fence_ptr =
-			cpu_to_le32(iwl_trans_read_prph(mvm->trans,
-							RXF_RD_FENCE_PTR +
-							offset_diff));
-		fifo_hdr->fence_mode =
-			cpu_to_le32(iwl_trans_read_prph(mvm->trans,
-							RXF_SET_FENCE_MODE +
-							offset_diff));
-
-		/* Lock fence */
-		iwl_trans_write_prph(mvm->trans,
-				     RXF_SET_FENCE_MODE + offset_diff, 0x1);
-		/* Set fence pointer to the same place like WR pointer */
-		iwl_trans_write_prph(mvm->trans,
-				     RXF_LD_WR2FENCE + offset_diff, 0x1);
-		/* Set fence offset */
-		iwl_trans_write_prph(mvm->trans,
-				     RXF_LD_FENCE_OFFSET_ADDR + offset_diff,
-				     0x0);
-
-		/* Read FIFO */
-		fifo_len /= sizeof(u32); /* Size in DWORDS */
-		for (j = 0; j < fifo_len; j++)
-			fifo_data[j] = iwl_trans_read_prph(mvm->trans,
-							 RXF_FIFO_RD_FENCE_INC +
-							 offset_diff);
-		*dump_data = iwl_fw_error_next_data(*dump_data);
-	}
-
-	/* Pull TXF data from all TXFs */
-	for (i = 0; i < ARRAY_SIZE(mvm->shared_mem_cfg.txfifo_size); i++) {
+	/* Pull RXF1 */
+	iwl_mvm_dump_rxf(mvm, dump_data, cfg->lmac[0].rxfifo1_size, 0, 0);
+	/* Pull RXF2 */
+	iwl_mvm_dump_rxf(mvm, dump_data, cfg->rxfifo2_size,
+			 RXF_DIFF_FROM_PREV, 1);
+	/* Pull LMAC2 RXF1 */
+	if (mvm->smem_cfg.num_lmacs > 1)
+		iwl_mvm_dump_rxf(mvm, dump_data, cfg->lmac[1].rxfifo1_size,
+				 LMAC2_PRPH_OFFSET, 2);
+
+	/* Pull TXF data from LMAC1 */
+	for (i = 0; i < mvm->smem_cfg.num_txfifo_entries; i++) {
 		/* Mark the number of TXF we're pulling now */
 		iwl_trans_write_prph(mvm->trans, TXF_LARC_NUM, i);
+		iwl_mvm_dump_txf(mvm, dump_data, cfg->lmac[0].txfifo_size[i],
+				 0, i);
+	}
 
-		fifo_hdr = (void *)(*dump_data)->data;
-		fifo_data = (void *)fifo_hdr->data;
-		fifo_len = mvm->shared_mem_cfg.txfifo_size[i];
-
-		/* No need to try to read the data if the length is 0 */
-		if (fifo_len == 0)
-			continue;
-
-		/* Add a TLV for the FIFO */
-		(*dump_data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_TXF);
-		(*dump_data)->len = cpu_to_le32(fifo_len + sizeof(*fifo_hdr));
-
-		fifo_hdr->fifo_num = cpu_to_le32(i);
-		fifo_hdr->available_bytes =
-			cpu_to_le32(iwl_trans_read_prph(mvm->trans,
-							TXF_FIFO_ITEM_CNT));
-		fifo_hdr->wr_ptr =
-			cpu_to_le32(iwl_trans_read_prph(mvm->trans,
-							TXF_WR_PTR));
-		fifo_hdr->rd_ptr =
-			cpu_to_le32(iwl_trans_read_prph(mvm->trans,
-							TXF_RD_PTR));
-		fifo_hdr->fence_ptr =
-			cpu_to_le32(iwl_trans_read_prph(mvm->trans,
-							TXF_FENCE_PTR));
-		fifo_hdr->fence_mode =
-			cpu_to_le32(iwl_trans_read_prph(mvm->trans,
-							TXF_LOCK_FENCE));
-
-		/* Set the TXF_READ_MODIFY_ADDR to TXF_WR_PTR */
-		iwl_trans_write_prph(mvm->trans, TXF_READ_MODIFY_ADDR,
-				     TXF_WR_PTR);
-
-		/* Dummy-read to advance the read pointer to the head */
-		iwl_trans_read_prph(mvm->trans, TXF_READ_MODIFY_DATA);
-
-		/* Read FIFO */
-		fifo_len /= sizeof(u32); /* Size in DWORDS */
-		for (j = 0; j < fifo_len; j++)
-			fifo_data[j] = iwl_trans_read_prph(mvm->trans,
-							  TXF_READ_MODIFY_DATA);
-		*dump_data = iwl_fw_error_next_data(*dump_data);
+	/* Pull TXF data from LMAC2 */
+	if (mvm->smem_cfg.num_lmacs > 1) {
+		for (i = 0; i < mvm->smem_cfg.num_txfifo_entries; i++) {
+			/* Mark the number of TXF we're pulling now */
+			iwl_trans_write_prph(mvm->trans,
+					     TXF_LARC_NUM + LMAC2_PRPH_OFFSET,
+					     i);
+			iwl_mvm_dump_txf(mvm, dump_data,
+					 cfg->lmac[1].txfifo_size[i],
+					 LMAC2_PRPH_OFFSET,
+					 i + cfg->num_txfifo_entries);
+		}
 	}
 
 	if (fw_has_capa(&mvm->fw->ucode_capa,
 			IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG)) {
 		/* Pull UMAC internal TXF data from all TXFs */
 		for (i = 0;
-		     i < ARRAY_SIZE(mvm->shared_mem_cfg.internal_txfifo_size);
+		     i < ARRAY_SIZE(mvm->smem_cfg.internal_txfifo_size);
 		     i++) {
 			fifo_hdr = (void *)(*dump_data)->data;
 			fifo_data = (void *)fifo_hdr->data;
-			fifo_len = mvm->shared_mem_cfg.internal_txfifo_size[i];
+			fifo_len = mvm->smem_cfg.internal_txfifo_size[i];
 
 			/* No need to try to read the data if the length is 0 */
 			if (fifo_len == 0)
@@ -246,7 +277,7 @@ static void iwl_mvm_dump_fifos(struct iwl_mvm *mvm,
 
 			/* Mark the number of TXF we're pulling now */
 			iwl_trans_write_prph(mvm->trans, TXF_CPU2_NUM, i +
-				ARRAY_SIZE(mvm->shared_mem_cfg.txfifo_size));
+				mvm->smem_cfg.num_txfifo_entries);
 
 			fifo_hdr->available_bytes =
 				cpu_to_le32(iwl_trans_read_prph(mvm->trans,
@@ -553,31 +584,45 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 
 	/* reading RXF/TXF sizes */
 	if (test_bit(STATUS_FW_ERROR, &mvm->trans->status)) {
-		struct iwl_mvm_shared_mem_cfg *mem_cfg = &mvm->shared_mem_cfg;
+		struct iwl_mvm_shared_mem_cfg *mem_cfg = &mvm->smem_cfg;
 
 		fifo_data_len = 0;
 
-		/* Count RXF size */
-		for (i = 0; i < ARRAY_SIZE(mem_cfg->rxfifo_size); i++) {
-			if (!mem_cfg->rxfifo_size[i])
-				continue;
-
+		/* Count RXF2 size */
+		if (mem_cfg->rxfifo2_size) {
 			/* Add header info */
-			fifo_data_len += mem_cfg->rxfifo_size[i] +
+			fifo_data_len += mem_cfg->rxfifo2_size +
 					 sizeof(*dump_data) +
 					 sizeof(struct iwl_fw_error_dump_fifo);
 		}
 
-		for (i = 0; i < mem_cfg->num_txfifo_entries; i++) {
-			if (!mem_cfg->txfifo_size[i])
+		/* Count RXF1 sizes */
+		for (i = 0; i < mem_cfg->num_lmacs; i++) {
+			if (!mem_cfg->lmac[i].rxfifo1_size)
 				continue;
 
 			/* Add header info */
-			fifo_data_len += mem_cfg->txfifo_size[i] +
+			fifo_data_len += mem_cfg->lmac[i].rxfifo1_size +
 					 sizeof(*dump_data) +
 					 sizeof(struct iwl_fw_error_dump_fifo);
 		}
 
+		/* Count TXF sizes */
+		for (i = 0; i < mem_cfg->num_lmacs; i++) {
+			int j;
+
+			for (j = 0; j < mem_cfg->num_txfifo_entries; j++) {
+				if (!mem_cfg->lmac[i].txfifo_size[j])
+					continue;
+
+				/* Add header info */
+				fifo_data_len +=
+					mem_cfg->lmac[i].txfifo_size[j] +
+					sizeof(*dump_data) +
+					sizeof(struct iwl_fw_error_dump_fifo);
+			}
+		}
+
 		if (fw_has_capa(&mvm->fw->ucode_capa,
 				IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG)) {
 			for (i = 0;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index bfccbadd1a6e..a845233d14a3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -897,24 +897,27 @@ static void iwl_mvm_parse_shared_mem_a000(struct iwl_mvm *mvm,
 					  struct iwl_rx_packet *pkt)
 {
 	struct iwl_shared_mem_cfg *mem_cfg = (void *)pkt->data;
-	int i;
+	int i, lmac;
+	int lmac_num = le32_to_cpu(mem_cfg->lmac_num);
 
-	mvm->shared_mem_cfg.num_txfifo_entries =
-		ARRAY_SIZE(mvm->shared_mem_cfg.txfifo_size);
-	for (i = 0; i < ARRAY_SIZE(mem_cfg->txfifo_size); i++)
-		mvm->shared_mem_cfg.txfifo_size[i] =
-			le32_to_cpu(mem_cfg->txfifo_size[i]);
-	for (i = 0; i < ARRAY_SIZE(mvm->shared_mem_cfg.rxfifo_size); i++)
-		mvm->shared_mem_cfg.rxfifo_size[i] =
-			le32_to_cpu(mem_cfg->rxfifo_size[i]);
+	if (WARN_ON(lmac_num > ARRAY_SIZE(mem_cfg->lmac_smem)))
+		return;
 
-	BUILD_BUG_ON(sizeof(mvm->shared_mem_cfg.internal_txfifo_size) !=
-		     sizeof(mem_cfg->internal_txfifo_size));
+	mvm->smem_cfg.num_lmacs = lmac_num;
+	mvm->smem_cfg.num_txfifo_entries =
+		ARRAY_SIZE(mem_cfg->lmac_smem[0].txfifo_size);
+	mvm->smem_cfg.rxfifo2_size = le32_to_cpu(mem_cfg->rxfifo2_size);
 
-	for (i = 0; i < ARRAY_SIZE(mvm->shared_mem_cfg.internal_txfifo_size);
-	     i++)
-		mvm->shared_mem_cfg.internal_txfifo_size[i] =
-			le32_to_cpu(mem_cfg->internal_txfifo_size[i]);
+	for (lmac = 0; lmac < lmac_num; lmac++) {
+		struct iwl_shared_mem_lmac_cfg *lmac_cfg =
+			&mem_cfg->lmac_smem[lmac];
+
+		for (i = 0; i < ARRAY_SIZE(lmac_cfg->txfifo_size); i++)
+			mvm->smem_cfg.lmac[lmac].txfifo_size[i] =
+				le32_to_cpu(lmac_cfg->txfifo_size[i]);
+		mvm->smem_cfg.lmac[lmac].rxfifo1_size =
+			le32_to_cpu(lmac_cfg->rxfifo1_size);
+	}
 }
 
 static void iwl_mvm_parse_shared_mem(struct iwl_mvm *mvm,
@@ -923,25 +926,27 @@ static void iwl_mvm_parse_shared_mem(struct iwl_mvm *mvm,
 	struct iwl_shared_mem_cfg_v1 *mem_cfg = (void *)pkt->data;
 	int i;
 
-	mvm->shared_mem_cfg.num_txfifo_entries =
-		ARRAY_SIZE(mvm->shared_mem_cfg.txfifo_size);
+	mvm->smem_cfg.num_lmacs = 1;
+
+	mvm->smem_cfg.num_txfifo_entries = ARRAY_SIZE(mem_cfg->txfifo_size);
 	for (i = 0; i < ARRAY_SIZE(mem_cfg->txfifo_size); i++)
-		mvm->shared_mem_cfg.txfifo_size[i] =
+		mvm->smem_cfg.lmac[0].txfifo_size[i] =
 			le32_to_cpu(mem_cfg->txfifo_size[i]);
-	for (i = 0; i < ARRAY_SIZE(mvm->shared_mem_cfg.rxfifo_size); i++)
-		mvm->shared_mem_cfg.rxfifo_size[i] =
-			le32_to_cpu(mem_cfg->rxfifo_size[i]);
+
+	mvm->smem_cfg.lmac[0].rxfifo1_size =
+		le32_to_cpu(mem_cfg->rxfifo_size[0]);
+	mvm->smem_cfg.rxfifo2_size = le32_to_cpu(mem_cfg->rxfifo_size[1]);
 
 	/* new API has more data, from rxfifo_addr field and on */
 	if (fw_has_capa(&mvm->fw->ucode_capa,
 			IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG)) {
-		BUILD_BUG_ON(sizeof(mvm->shared_mem_cfg.internal_txfifo_size) !=
+		BUILD_BUG_ON(sizeof(mvm->smem_cfg.internal_txfifo_size) !=
 			     sizeof(mem_cfg->internal_txfifo_size));
 
 		for (i = 0;
-		     i < ARRAY_SIZE(mvm->shared_mem_cfg.internal_txfifo_size);
+		     i < ARRAY_SIZE(mvm->smem_cfg.internal_txfifo_size);
 		     i++)
-			mvm->shared_mem_cfg.internal_txfifo_size[i] =
+			mvm->smem_cfg.internal_txfifo_size[i] =
 				le32_to_cpu(mem_cfg->internal_txfifo_size[i]);
 	}
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 32e62175cbd5..14b8c2eba7fc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -604,10 +604,15 @@ enum iwl_mvm_tdls_cs_state {
 	IWL_MVM_TDLS_SW_ACTIVE,
 };
 
+#define MAX_NUM_LMAC 2
 struct iwl_mvm_shared_mem_cfg {
+	int num_lmacs;
 	int num_txfifo_entries;
-	u32 txfifo_size[TX_FIFO_MAX_NUM];
-	u32 rxfifo_size[RX_FIFO_MAX_NUM];
+	struct {
+		u32 txfifo_size[TX_FIFO_MAX_NUM];
+		u32 rxfifo1_size;
+	} lmac[MAX_NUM_LMAC];
+	u32 rxfifo2_size;
 	u32 internal_txfifo_addr;
 	u32 internal_txfifo_size[TX_FIFO_INTERNAL_MAX_NUM];
 };
@@ -1034,7 +1039,7 @@ struct iwl_mvm {
 		} peer;
 	} tdls_cs;
 
-	struct iwl_mvm_shared_mem_cfg shared_mem_cfg;
+	struct iwl_mvm_shared_mem_cfg smem_cfg;
 
 	u32 ciphers[IWL_MVM_NUM_CIPHERS];
 	struct ieee80211_cipher_scheme cs[IWL_UCODE_MAX_CS];
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 8d86a450ec3c..65308c4ad8b8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -741,7 +741,7 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	 * fifo to be able to send bursts.
 	 */
 	max_amsdu_len = min_t(unsigned int, max_amsdu_len,
-			      mvm->shared_mem_cfg.txfifo_size[txf] - 256);
+			      mvm->smem_cfg.lmac[0].txfifo_size[txf] - 256);
 
 	if (unlikely(dbg_max_amsdu_len))
 		max_amsdu_len = min_t(unsigned int, max_amsdu_len,
-- 
2.11.0
