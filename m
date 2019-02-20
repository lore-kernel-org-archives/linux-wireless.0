Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66609C10F01
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 12:04:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 405C3206DD
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 12:04:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbfBTMEQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 07:04:16 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:34530 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727064AbfBTMEO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 07:04:14 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gwQbi-000411-Ib; Wed, 20 Feb 2019 14:04:11 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed, 20 Feb 2019 14:03:57 +0200
Message-Id: <20190220120400.8814-6-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190220120400.8814-1-luca@coelho.fi>
References: <20190220120400.8814-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 5/8] iwlwifi: dbg_ini: implement Tx fifos dump
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Implement Tx fifos dump in the new dump mechanism.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/fw/api/dbg-tlv.h   |  13 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 189 +++++++++++++++++-
 .../wireless/intel/iwlwifi/fw/error-dump.h    |  29 ++-
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |   1 +
 4 files changed, 218 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h b/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
index 70cc0820e068..33858787817b 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
@@ -5,7 +5,7 @@
  *
  * GPL LICENSE SUMMARY
  *
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -25,7 +25,7 @@
  *
  * BSD LICENSE
  *
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -146,16 +146,17 @@ struct iwl_fw_ini_region_cfg_internal {
 
 /**
  * struct iwl_fw_ini_region_cfg_fifos - meta data of fifos region
- * @lmac1_id: bit map of lmac1 fifos to include in the region.
- * @lmac2_id: bit map of lmac2 fifos to include in the region.
+ * @fid1: fifo id 1 - bitmap of lmac tx/rx fifos to include in the region
+ * @fid2: fifo id 2 - bitmap of umac rx fifos to include in the region.
+ *	It is unused for tx.
  * @num_of_registers: number of prph registers in the region, each register is
  *	4 bytes size.
  * @header_only: none zero value indicates that this region does not include
  *	fifo data and includes only the given registers.
  */
 struct iwl_fw_ini_region_cfg_fifos {
-	__le32 lmac1_id;
-	__le32 lmac2_id;
+	__le32 fid1;
+	__le32 fid2;
 	__le32 num_of_registers;
 	__le32 header_only;
 } __packed; /* FW_DEBUG_TLV_REGION_FIFOS_S */
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index c9a63b2c6c9b..744d831b4dbb 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1058,7 +1058,7 @@ static int iwl_dump_ini_prph_iter(struct iwl_fw_runtime *fwrt,
 		addr = le32_to_cpu(range->start_addr) + i;
 		prph_val = iwl_read_prph(fwrt->trans, addr + offset);
 		if (prph_val == 0x5a5a5a5a)
-			return -1;
+			return -EBUSY;
 		*val++ = cpu_to_le32(prph_val);
 	}
 
@@ -1150,7 +1150,7 @@ iwl_dump_ini_mon_dram_iter(struct iwl_fw_runtime *fwrt,
 					    MON_BUFF_BASE_ADDR_VER2);
 
 	if (start_addr == 0x5a5a5a5a)
-		return -1;
+		return -EBUSY;
 
 	range->start_addr = cpu_to_le32(start_addr);
 	range->range_data_size = cpu_to_le32(fwrt->trans->fw_mon[idx].size);
@@ -1161,6 +1161,124 @@ iwl_dump_ini_mon_dram_iter(struct iwl_fw_runtime *fwrt,
 	return sizeof(*range) + le32_to_cpu(range->range_data_size);
 }
 
+struct iwl_ini_txf_iter_data {
+	int fifo;
+	int lmac;
+	u32 fifo_size;
+	bool internal_txf;
+	bool init;
+};
+
+static bool iwl_ini_txf_iter(struct iwl_fw_runtime *fwrt,
+			     struct iwl_fw_ini_region_cfg *reg)
+{
+	struct iwl_ini_txf_iter_data *iter = fwrt->dump.fifo_iter;
+	struct iwl_fwrt_shared_mem_cfg *cfg = &fwrt->smem_cfg;
+	int txf_num = cfg->num_txfifo_entries;
+	int int_txf_num = ARRAY_SIZE(cfg->internal_txfifo_size);
+	u32 lmac_bitmap = le32_to_cpu(reg->fifos.fid1);
+
+	if (!iter)
+		return false;
+
+	if (iter->init) {
+		if (le32_to_cpu(reg->offset) &&
+		    WARN_ONCE(cfg->num_lmacs == 1,
+			      "Invalid lmac offset: 0x%x\n",
+			      le32_to_cpu(reg->offset)))
+			return false;
+
+		iter->init = false;
+		iter->internal_txf = false;
+		iter->fifo_size = 0;
+		iter->fifo = -1;
+		if (le32_to_cpu(reg->offset))
+			iter->lmac = 1;
+		else
+			iter->lmac = 0;
+	}
+
+	if (!iter->internal_txf)
+		for (iter->fifo++; iter->fifo < txf_num; iter->fifo++) {
+			iter->fifo_size =
+				cfg->lmac[iter->lmac].txfifo_size[iter->fifo];
+			if (iter->fifo_size && (lmac_bitmap & BIT(iter->fifo)))
+				return true;
+		}
+
+	iter->internal_txf = true;
+
+	if (!fw_has_capa(&fwrt->fw->ucode_capa,
+			 IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG))
+		return false;
+
+	for (iter->fifo++; iter->fifo < int_txf_num + txf_num; iter->fifo++) {
+		iter->fifo_size =
+			cfg->internal_txfifo_size[iter->fifo - txf_num];
+		if (iter->fifo_size && (lmac_bitmap & BIT(iter->fifo)))
+			return true;
+	}
+
+	return false;
+}
+
+static int iwl_dump_ini_txf_iter(struct iwl_fw_runtime *fwrt,
+				 struct iwl_fw_ini_region_cfg *reg,
+				 void *range_ptr, int idx)
+{
+	struct iwl_fw_ini_fifo_error_dump_range *range = range_ptr;
+	struct iwl_ini_txf_iter_data *iter;
+	u32 offs = le32_to_cpu(reg->offset), addr;
+	u32 registers_size =
+		le32_to_cpu(reg->fifos.num_of_registers) * sizeof(__le32);
+	__le32 *val = range->data;
+	unsigned long flags;
+	int i;
+
+	if (!iwl_ini_txf_iter(fwrt, reg))
+		return -EIO;
+
+	if (!iwl_trans_grab_nic_access(fwrt->trans, &flags))
+		return -EBUSY;
+
+	iter = fwrt->dump.fifo_iter;
+
+	range->fifo_num = cpu_to_le32(iter->fifo);
+	range->num_of_registers = reg->fifos.num_of_registers;
+	range->range_data_size = cpu_to_le32(iter->fifo_size + registers_size);
+
+	iwl_write_prph_no_grab(fwrt->trans, TXF_LARC_NUM + offs, iter->fifo);
+
+	/* read txf registers */
+	for (i = 0; i < le32_to_cpu(reg->fifos.num_of_registers); i++) {
+		addr = le32_to_cpu(reg->start_addr[i]) + offs;
+
+		*val++ = cpu_to_le32(iwl_read_prph_no_grab(fwrt->trans, addr));
+	}
+
+	if (reg->fifos.header_only) {
+		range->range_data_size = cpu_to_le32(registers_size);
+		goto out;
+	}
+
+	/* Set the TXF_READ_MODIFY_ADDR to TXF_WR_PTR */
+	iwl_write_prph_no_grab(fwrt->trans, TXF_READ_MODIFY_ADDR + offs,
+			       TXF_WR_PTR + offs);
+
+	/* Dummy-read to advance the read pointer to the head */
+	iwl_read_prph_no_grab(fwrt->trans, TXF_READ_MODIFY_DATA + offs);
+
+	/* Read FIFO */
+	addr = TXF_READ_MODIFY_DATA + offs;
+	for (i = 0; i < iter->fifo_size; i += sizeof(__le32))
+		*val++ = cpu_to_le32(iwl_read_prph_no_grab(fwrt->trans, addr));
+
+out:
+	iwl_trans_release_nic_access(fwrt->trans, &flags);
+
+	return sizeof(*range) + le32_to_cpu(range->range_data_size);
+}
+
 static void *iwl_dump_ini_mem_fill_header(struct iwl_fw_runtime *fwrt,
 					  struct iwl_fw_ini_region_cfg *reg,
 					  void *data)
@@ -1195,6 +1313,15 @@ static void
 	return mon_dump->ranges;
 }
 
+static void *iwl_dump_ini_fifo_fill_header(struct iwl_fw_runtime *fwrt,
+					   struct iwl_fw_ini_region_cfg *reg,
+					   void *data)
+{
+	struct iwl_fw_ini_fifo_error_dump *dump = data;
+
+	return dump->ranges;
+}
+
 static u32 iwl_dump_ini_mem_ranges(struct iwl_fw_runtime *fwrt,
 				   struct iwl_fw_ini_region_cfg *reg)
 {
@@ -1219,6 +1346,22 @@ static u32 iwl_dump_ini_mon_dram_ranges(struct iwl_fw_runtime *fwrt,
 	return 1;
 }
 
+static u32 iwl_dump_ini_txf_ranges(struct iwl_fw_runtime *fwrt,
+				   struct iwl_fw_ini_region_cfg *reg)
+{
+	struct iwl_ini_txf_iter_data iter = { .init = true };
+	void *fifo_iter = fwrt->dump.fifo_iter;
+	u32 num_of_fifos = 0;
+
+	fwrt->dump.fifo_iter = &iter;
+	while (iwl_ini_txf_iter(fwrt, reg))
+		num_of_fifos++;
+
+	fwrt->dump.fifo_iter = fifo_iter;
+
+	return num_of_fifos;
+}
+
 static u32 iwl_dump_ini_mem_get_size(struct iwl_fw_runtime *fwrt,
 				     struct iwl_fw_ini_region_cfg *reg)
 {
@@ -1266,6 +1409,30 @@ static u32 iwl_dump_ini_mon_dram_get_size(struct iwl_fw_runtime *fwrt,
 	return size;
 }
 
+static u32 iwl_dump_ini_txf_get_size(struct iwl_fw_runtime *fwrt,
+				     struct iwl_fw_ini_region_cfg *reg)
+{
+	struct iwl_ini_txf_iter_data iter = { .init = true };
+	void *fifo_iter = fwrt->dump.fifo_iter;
+	u32 size = 0;
+	u32 fifo_hdr = sizeof(struct iwl_fw_ini_fifo_error_dump_range) +
+		le32_to_cpu(reg->fifos.num_of_registers) * sizeof(__le32);
+
+	fwrt->dump.fifo_iter = &iter;
+	while (iwl_ini_txf_iter(fwrt, reg)) {
+		size += fifo_hdr;
+		if (!reg->fifos.header_only)
+			size += iter.fifo_size;
+	}
+
+	if (size)
+		size += sizeof(struct iwl_fw_ini_fifo_error_dump);
+
+	fwrt->dump.fifo_iter = fifo_iter;
+
+	return size;
+}
+
 /**
  * struct iwl_dump_ini_mem_ops - ini memory dump operations
  * @get_num_of_ranges: returns the number of memory ranges in the region.
@@ -1273,7 +1440,7 @@ static u32 iwl_dump_ini_mon_dram_get_size(struct iwl_fw_runtime *fwrt,
  * @fill_mem_hdr: fills region type specific headers and returns pointer to
  *	the first range or NULL if failed to fill headers.
  * @fill_range: copies a given memory range into the dump.
- *	Returns the size of the range or -1 otherwise.
+ *	Returns the size of the range or negative error value otherwise.
  */
 struct iwl_dump_ini_mem_ops {
 	u32 (*get_num_of_ranges)(struct iwl_fw_runtime *fwrt,
@@ -1369,7 +1536,7 @@ static int iwl_fw_ini_get_trigger_len(struct iwl_fw_runtime *fwrt,
 			size += hdr_len + iwl_dump_ini_mem_get_size(fwrt, reg);
 			break;
 		case IWL_FW_INI_REGION_TXF:
-			size += iwl_fw_txf_len(fwrt, &fwrt->smem_cfg);
+			size += hdr_len + iwl_dump_ini_txf_get_size(fwrt, reg);
 			break;
 		case IWL_FW_INI_REGION_RXF:
 			size += iwl_fw_rxf_len(fwrt, &fwrt->smem_cfg);
@@ -1463,9 +1630,19 @@ static void iwl_fw_ini_dump_trigger(struct iwl_fw_runtime *fwrt,
 			iwl_dump_ini_mem(fwrt, type, data, reg, &ops);
 			break;
 		}
-		case IWL_FW_INI_REGION_TXF:
-			iwl_fw_dump_txf(fwrt, data);
+		case IWL_FW_INI_REGION_TXF: {
+			struct iwl_ini_txf_iter_data iter = { .init = true };
+			void *fifo_iter = fwrt->dump.fifo_iter;
+
+			fwrt->dump.fifo_iter = &iter;
+			ops.get_num_of_ranges = iwl_dump_ini_txf_ranges;
+			ops.get_size = iwl_dump_ini_txf_get_size;
+			ops.fill_mem_hdr = iwl_dump_ini_fifo_fill_header;
+			ops.fill_range = iwl_dump_ini_txf_iter;
+			iwl_dump_ini_mem(fwrt, type, data, reg, &ops);
+			fwrt->dump.fifo_iter = fifo_iter;
 			break;
+		}
 		case IWL_FW_INI_REGION_RXF:
 			iwl_fw_dump_rxf(fwrt, data);
 			break;
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
index 063f2b925808..2cc4f13d0abb 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
@@ -8,7 +8,7 @@
  * Copyright(c) 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2014 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2014 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -308,6 +308,31 @@ struct iwl_fw_ini_error_dump {
 	struct iwl_fw_ini_error_dump_range ranges[];
 } __packed;
 
+/**
+ * struct iwl_fw_ini_fifo_error_dump_range - ini fifo range dump
+ * @fifo_num: the fifo num. In case of rxf and umac rxf, set BIT(31) to
+ *	distinguish between lmac and umac
+ * @num_of_registers: num of registers to dump, dword size each
+ * @range_data_size: the size of the registers and fifo data
+ * @data: fifo data
+ */
+struct iwl_fw_ini_fifo_error_dump_range {
+	__le32 fifo_num;
+	__le32 num_of_registers;
+	__le32 range_data_size;
+	__le32 data[];
+} __packed;
+
+/**
+ * struct iwl_fw_ini_fifo_error_dump - ini fifo region dump
+ * @header: the header of this region
+ * @ranges: the memory ranges of this region
+ */
+struct iwl_fw_ini_fifo_error_dump {
+	struct iwl_fw_ini_error_dump_header header;
+	struct iwl_fw_ini_fifo_error_dump_range ranges[];
+} __packed;
+
 /**
  * struct iwl_fw_error_dump_rb - content of an Receive Buffer
  * @index: the index of the Receive Buffer in the Rx queue
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
index 6e843998d1c8..a5fe1a8ca426 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
@@ -144,6 +144,7 @@ struct iwl_fw_runtime {
 		struct iwl_fw_ini_active_triggers active_trigs[IWL_FW_TRIGGER_ID_NUM];
 		u32 lmac_err_id[MAX_NUM_LMAC];
 		u32 umac_err_id;
+		void *fifo_iter;
 	} dump;
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	struct {
-- 
2.20.1

