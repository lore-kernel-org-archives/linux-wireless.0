Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:59098 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451AbcC3OFl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:05:41 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Golan Ben-Ami <golan.ben.ami@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/43] iwlwifi: mvm: support dumping UMAC internal txfifos
Date: Wed, 30 Mar 2016 17:04:36 +0300
Message-Id: <1459346715-7954-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160815_764255_6EDA2773)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben-Ami <golan.ben.ami@intel.com>

In case of FW error, support dumping the UMAC internal txfifos.
To do so, support version 2 of shared memory cfg command, which
contains the sizes of the internal txfifos, and move the command
to the system group.

Signed-off-by: Golan Ben-Ami <golan.ben.ami@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 .../net/wireless/intel/iwlwifi/iwl-fw-error-dump.h |  1 +
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h   |  3 +
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      | 12 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h    | 17 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c    | 79 +++++++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        | 28 +++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  3 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  8 +++
 8 files changed, 146 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-error-dump.h
index 8425e1a..09b7ea2 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-error-dump.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-error-dump.h
@@ -105,6 +105,7 @@ enum iwl_fw_error_dump_type {
 	IWL_FW_ERROR_DUMP_RB = 11,
 	IWL_FW_ERROR_DUMP_PAGING = 12,
 	IWL_FW_ERROR_DUMP_RADIO_REG = 13,
+	IWL_FW_ERROR_DUMP_INTERNAL_TXF = 14,
 
 	IWL_FW_ERROR_DUMP_MAX,
 };
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
index 15ec4e2..3a72b97 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
@@ -324,6 +324,8 @@ typedef unsigned int __bitwise__ iwl_ucode_tlv_capa_t;
  * @IWL_UCODE_TLV_CAPA_CTDP_SUPPORT: supports cTDP command
  * @IWL_UCODE_TLV_CAPA_USNIFFER_UNIFIED: supports usniffer enabled in
  *	regular image.
+ * @IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG: support getting more shared
+ *	memory addresses from the firmware.
  *
  * @NUM_IWL_UCODE_TLV_CAPA: number of bits used
  */
@@ -361,6 +363,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_TEMP_THS_REPORT_SUPPORT	= (__force iwl_ucode_tlv_capa_t)75,
 	IWL_UCODE_TLV_CAPA_CTDP_SUPPORT			= (__force iwl_ucode_tlv_capa_t)76,
 	IWL_UCODE_TLV_CAPA_USNIFFER_UNIFIED		= (__force iwl_ucode_tlv_capa_t)77,
+	IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG	= (__force iwl_ucode_tlv_capa_t)80,
 
 	NUM_IWL_UCODE_TLV_CAPA
 #ifdef __CHECKER__
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
index c46e596..6c1d20d 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
@@ -7,6 +7,7 @@
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2016        Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -33,6 +34,7 @@
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2016        Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -345,6 +347,16 @@ enum secure_load_status_reg {
 #define TXF_READ_MODIFY_DATA		(0xa00448)
 #define TXF_READ_MODIFY_ADDR		(0xa0044c)
 
+/* UMAC Internal Tx Fifo */
+#define TXF_CPU2_FIFO_ITEM_CNT		(0xA00538)
+#define TXF_CPU2_WR_PTR		(0xA00514)
+#define TXF_CPU2_RD_PTR		(0xA00510)
+#define TXF_CPU2_FENCE_PTR		(0xA00518)
+#define TXF_CPU2_LOCK_FENCE		(0xA00524)
+#define TXF_CPU2_NUM			(0xA0053C)
+#define TXF_CPU2_READ_MODIFY_DATA	(0xA00548)
+#define TXF_CPU2_READ_MODIFY_ADDR	(0xA0054C)
+
 /* Radio registers access */
 #define RSP_RADIO_CMD			(0xa02804)
 #define RSP_RADIO_RDDAT			(0xa02814)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index 4a0fc47..61711b1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -287,6 +287,10 @@ enum iwl_phy_ops_subcmd_ids {
 	DTS_MEASUREMENT_NOTIF_WIDE = 0xFF,
 };
 
+enum iwl_system_subcmd_ids {
+	SHARED_MEM_CFG_CMD = 0x0,
+};
+
 enum iwl_data_path_subcmd_ids {
 	UPDATE_MU_GROUPS_CMD = 0x1,
 	TRIGGER_RX_QUEUES_NOTIF_CMD = 0x2,
@@ -302,6 +306,7 @@ enum iwl_prot_offload_subcmd_ids {
 enum {
 	LEGACY_GROUP = 0x0,
 	LONG_GROUP = 0x1,
+	SYSTEM_GROUP = 0x2,
 	PHY_OPS_GROUP = 0x4,
 	DATA_PATH_GROUP = 0x5,
 	PROT_OFFLOAD_GROUP = 0xb,
@@ -1923,6 +1928,7 @@ struct iwl_tdls_config_res {
 
 #define TX_FIFO_MAX_NUM		8
 #define RX_FIFO_MAX_NUM		2
+#define TX_FIFO_INTERNAL_MAX_NUM	6
 
 /**
  * Shared memory configuration information from the FW
@@ -1940,6 +1946,12 @@ struct iwl_tdls_config_res {
  * @page_buff_addr: used by UMAC and performance debug (page miss analysis),
  *	when paging is not supported this should be 0
  * @page_buff_size: size of %page_buff_addr
+ * @rxfifo_addr: Start address of rxFifo
+ * @internal_txfifo_addr: start address of internalFifo
+ * @internal_txfifo_size: internal fifos' size
+ *
+ * NOTE: on firmware that don't have IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG
+ *	 set, the last 3 members don't exist.
  */
 struct iwl_shared_mem_cfg {
 	__le32 shared_mem_addr;
@@ -1951,7 +1963,10 @@ struct iwl_shared_mem_cfg {
 	__le32 rxfifo_size[RX_FIFO_MAX_NUM];
 	__le32 page_buff_addr;
 	__le32 page_buff_size;
-} __packed; /* SHARED_MEM_ALLOC_API_S_VER_1 */
+	__le32 rxfifo_addr;
+	__le32 internal_txfifo_addr;
+	__le32 internal_txfifo_size[TX_FIFO_INTERNAL_MAX_NUM];
+} __packed; /* SHARED_MEM_ALLOC_API_S_VER_2 */
 
 /**
  * VHT MU-MIMO group configuration
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
index 4856eac..6ef706c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2015        Intel Deutschland GmbH
+ * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -32,7 +32,7 @@
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2015        Intel Deutschland GmbH
+ * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -265,6 +265,65 @@ static void iwl_mvm_dump_fifos(struct iwl_mvm *mvm,
 		*dump_data = iwl_fw_error_next_data(*dump_data);
 	}
 
+	if (fw_has_capa(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG)) {
+		/* Pull UMAC internal TXF data from all TXFs */
+		for (i = 0;
+		     i < ARRAY_SIZE(mvm->shared_mem_cfg.internal_txfifo_size);
+		     i++) {
+			/* Mark the number of TXF we're pulling now */
+			iwl_trans_write_prph(mvm->trans, TXF_CPU2_NUM, i);
+
+			fifo_hdr = (void *)(*dump_data)->data;
+			fifo_data = (void *)fifo_hdr->data;
+			fifo_len = mvm->shared_mem_cfg.internal_txfifo_size[i];
+
+			/* No need to try to read the data if the length is 0 */
+			if (fifo_len == 0)
+				continue;
+
+			/* Add a TLV for the internal FIFOs */
+			(*dump_data)->type =
+				cpu_to_le32(IWL_FW_ERROR_DUMP_INTERNAL_TXF);
+			(*dump_data)->len =
+				cpu_to_le32(fifo_len + sizeof(*fifo_hdr));
+
+			fifo_hdr->fifo_num = cpu_to_le32(i);
+			fifo_hdr->available_bytes =
+				cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+								TXF_CPU2_FIFO_ITEM_CNT));
+			fifo_hdr->wr_ptr =
+				cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+								TXF_CPU2_WR_PTR));
+			fifo_hdr->rd_ptr =
+				cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+								TXF_CPU2_RD_PTR));
+			fifo_hdr->fence_ptr =
+				cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+								TXF_CPU2_FENCE_PTR));
+			fifo_hdr->fence_mode =
+				cpu_to_le32(iwl_trans_read_prph(mvm->trans,
+								TXF_CPU2_LOCK_FENCE));
+
+			/* Set TXF_CPU2_READ_MODIFY_ADDR to TXF_CPU2_WR_PTR */
+			iwl_trans_write_prph(mvm->trans,
+					     TXF_CPU2_READ_MODIFY_ADDR,
+					     TXF_CPU2_WR_PTR);
+
+			/* Dummy-read to advance the read pointer to head */
+			iwl_trans_read_prph(mvm->trans,
+					    TXF_CPU2_READ_MODIFY_DATA);
+
+			/* Read FIFO */
+			fifo_len /= sizeof(u32); /* Size in DWORDS */
+			for (j = 0; j < fifo_len; j++)
+				fifo_data[j] =
+					iwl_trans_read_prph(mvm->trans,
+							    TXF_CPU2_READ_MODIFY_DATA);
+			*dump_data = iwl_fw_error_next_data(*dump_data);
+		}
+	}
+
 	iwl_trans_release_nic_access(mvm->trans, &flags);
 }
 
@@ -494,6 +553,22 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 					 sizeof(struct iwl_fw_error_dump_fifo);
 		}
 
+		if (fw_has_capa(&mvm->fw->ucode_capa,
+				IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG)) {
+			for (i = 0;
+			     i < ARRAY_SIZE(mem_cfg->internal_txfifo_size);
+			     i++) {
+				if (!mem_cfg->internal_txfifo_size[i])
+					continue;
+
+				/* Add header info */
+				fifo_data_len +=
+					mem_cfg->internal_txfifo_size[i] +
+					sizeof(*dump_data) +
+					sizeof(struct iwl_fw_error_dump_fifo);
+			}
+		}
+
 		/* Make room for PRPH registers */
 		for (i = 0; i < ARRAY_SIZE(iwl_prph_dump_addr); i++) {
 			/* The range includes both boundaries */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 766c262..f375275 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -794,17 +794,22 @@ out:
 static void iwl_mvm_get_shared_mem_conf(struct iwl_mvm *mvm)
 {
 	struct iwl_host_cmd cmd = {
-		.id = SHARED_MEM_CFG,
 		.flags = CMD_WANT_SKB,
 		.data = { NULL, },
 		.len = { 0, },
 	};
-	struct iwl_rx_packet *pkt;
 	struct iwl_shared_mem_cfg *mem_cfg;
+	struct iwl_rx_packet *pkt;
 	u32 i;
 
 	lockdep_assert_held(&mvm->mutex);
 
+	if (fw_has_capa(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG))
+		cmd.id = iwl_cmd_id(SHARED_MEM_CFG_CMD, SYSTEM_GROUP, 0);
+	else
+		cmd.id = SHARED_MEM_CFG;
+
 	if (WARN_ON(iwl_mvm_send_cmd(mvm, &cmd)))
 		return;
 
@@ -830,6 +835,25 @@ static void iwl_mvm_get_shared_mem_conf(struct iwl_mvm *mvm)
 		le32_to_cpu(mem_cfg->page_buff_addr);
 	mvm->shared_mem_cfg.page_buff_size =
 		le32_to_cpu(mem_cfg->page_buff_size);
+
+	/* new API has more data */
+	if (fw_has_capa(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG)) {
+		mvm->shared_mem_cfg.rxfifo_addr =
+			le32_to_cpu(mem_cfg->rxfifo_addr);
+		mvm->shared_mem_cfg.internal_txfifo_addr =
+			le32_to_cpu(mem_cfg->internal_txfifo_addr);
+
+		BUILD_BUG_ON(sizeof(mvm->shared_mem_cfg.internal_txfifo_size) !=
+			     sizeof(mem_cfg->internal_txfifo_size));
+
+		for (i = 0;
+		     i < ARRAY_SIZE(mvm->shared_mem_cfg.internal_txfifo_size);
+		     i++)
+			mvm->shared_mem_cfg.internal_txfifo_size[i] =
+				le32_to_cpu(mem_cfg->internal_txfifo_size[i]);
+	}
+
 	IWL_DEBUG_INFO(mvm, "SHARED MEM CFG: got memory offsets/sizes\n");
 
 	iwl_free_resp(&cmd);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 9abbc93..6c67c0f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -602,6 +602,9 @@ struct iwl_mvm_shared_mem_cfg {
 	u32 rxfifo_size[RX_FIFO_MAX_NUM];
 	u32 page_buff_addr;
 	u32 page_buff_size;
+	u32 rxfifo_addr;
+	u32 internal_txfifo_addr;
+	u32 internal_txfifo_size[TX_FIFO_INTERNAL_MAX_NUM];
 };
 
 struct iwl_mvm {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 5e8ab79..ccf6ecd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -421,6 +421,13 @@ static const struct iwl_hcmd_names iwl_mvm_legacy_names[] = {
 /* Please keep this array *SORTED* by hex value.
  * Access is done through binary search
  */
+static const struct iwl_hcmd_names iwl_mvm_system_names[] = {
+	HCMD_NAME(SHARED_MEM_CFG_CMD),
+};
+
+/* Please keep this array *SORTED* by hex value.
+ * Access is done through binary search
+ */
 static const struct iwl_hcmd_names iwl_mvm_phy_names[] = {
 	HCMD_NAME(CMD_DTS_MEASUREMENT_TRIGGER_WIDE),
 	HCMD_NAME(CTDP_CONFIG_CMD),
@@ -449,6 +456,7 @@ static const struct iwl_hcmd_names iwl_mvm_prot_offload_names[] = {
 static const struct iwl_hcmd_arr iwl_mvm_groups[] = {
 	[LEGACY_GROUP] = HCMD_ARR(iwl_mvm_legacy_names),
 	[LONG_GROUP] = HCMD_ARR(iwl_mvm_legacy_names),
+	[SYSTEM_GROUP] = HCMD_ARR(iwl_mvm_system_names),
 	[PHY_OPS_GROUP] = HCMD_ARR(iwl_mvm_phy_names),
 	[DATA_PATH_GROUP] = HCMD_ARR(iwl_mvm_data_path_names),
 	[PROT_OFFLOAD_GROUP] = HCMD_ARR(iwl_mvm_prot_offload_names),
-- 
2.5.0

