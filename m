Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80071C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 13:59:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DD2C218A5
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 13:59:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbfCVN7j (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 09:59:39 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:46178 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727693AbfCVN7j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 09:59:39 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h7Khe-0000bK-75; Fri, 22 Mar 2019 15:59:22 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 22 Mar 2019 15:58:51 +0200
Message-Id: <20190322135903.10631-13-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190322135903.10631-1-luca@coelho.fi>
References: <20190322135903.10631-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 12/24] iwlwifi: dbg_ini: add monitor header to smem monitor
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Add write pointer and cycle count registers to smem monitor header.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/cfg/22000.c    |   6 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c |  10 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 101 +++++++++++++++---
 .../wireless/intel/iwlwifi/fw/error-dump.h    |   6 +-
 .../net/wireless/intel/iwlwifi/iwl-config.h   |   4 +
 5 files changed, 104 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index 32c989eda3c4..33c95663914d 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -180,7 +180,11 @@ static const struct iwl_ht_params iwl_22000_ht_params = {
 	.dbgc_supported = true,						\
 	.min_umac_error_event_table = 0x400000,				\
 	.d3_debug_data_base_addr = 0x401000,				\
-	.d3_debug_data_length = 60 * 1024
+	.d3_debug_data_length = 60 * 1024,				\
+	.fw_mon_smem_write_ptr_addr = 0xa0c16c,				\
+	.fw_mon_smem_write_ptr_msk = 0xfffff,				\
+	.fw_mon_smem_cycle_cnt_ptr_addr = 0xa0c174,			\
+	.fw_mon_smem_cycle_cnt_ptr_msk = 0xfffff
 
 #define IWL_DEVICE_AX200_COMMON						\
 	IWL_DEVICE_22000_COMMON,					\
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
index 3225b64eb845..41bdd0eaf62c 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2015-2017 Intel Deutschland GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -20,7 +20,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2015-2017 Intel Deutschland GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -148,7 +148,11 @@ static const struct iwl_tt_params iwl9000_tt_params = {
 	.d3_debug_data_length = 92 * 1024,				\
 	.ht_params = &iwl9000_ht_params,				\
 	.nvm_ver = IWL9000_NVM_VERSION,					\
-	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,		\
+	.fw_mon_smem_write_ptr_addr = 0xa0476c,				\
+	.fw_mon_smem_write_ptr_msk = 0xfffff,				\
+	.fw_mon_smem_cycle_cnt_ptr_addr = 0xa04774,			\
+	.fw_mon_smem_cycle_cnt_ptr_msk = 0xfffff
 
 
 const struct iwl_cfg iwl9160_2ac_cfg = {
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 6f681060245e..87da6125683a 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1404,29 +1404,80 @@ static void *iwl_dump_ini_mem_fill_header(struct iwl_fw_runtime *fwrt,
 }
 
 static void
-*iwl_dump_ini_mon_dram_fill_header(struct iwl_fw_runtime *fwrt,
-				   struct iwl_fw_ini_region_cfg *reg,
-				   void *data)
+*iwl_dump_ini_mon_fill_header(struct iwl_fw_runtime *fwrt,
+			      struct iwl_fw_ini_region_cfg *reg,
+			      struct iwl_fw_ini_monitor_dump *data,
+			      u32 write_ptr_addr, u32 write_ptr_msk,
+			      u32 cycle_cnt_addr, u32 cycle_cnt_msk)
 {
-	struct iwl_fw_ini_monitor_dram_dump *mon_dump = (void *)data;
 	u32 write_ptr, cycle_cnt;
 	unsigned long flags;
 
 	if (!iwl_trans_grab_nic_access(fwrt->trans, &flags)) {
-		IWL_ERR(fwrt, "Failed to get DRAM monitor header\n");
+		IWL_ERR(fwrt, "Failed to get monitor header\n");
 		return NULL;
 	}
-	write_ptr = iwl_read_umac_prph_no_grab(fwrt->trans,
-					       MON_BUFF_WRPTR_VER2);
-	cycle_cnt = iwl_read_umac_prph_no_grab(fwrt->trans,
-					       MON_BUFF_CYCLE_CNT_VER2);
+
+	write_ptr = iwl_read_prph_no_grab(fwrt->trans, write_ptr_addr);
+	cycle_cnt = iwl_read_prph_no_grab(fwrt->trans, cycle_cnt_addr);
+
 	iwl_trans_release_nic_access(fwrt->trans, &flags);
 
-	mon_dump->header.version = cpu_to_le32(IWL_INI_DUMP_MONITOR_VER);
-	mon_dump->write_ptr = cpu_to_le32(write_ptr);
-	mon_dump->cycle_cnt = cpu_to_le32(cycle_cnt);
+	data->header.version = cpu_to_le32(IWL_INI_DUMP_MONITOR_VER);
+	data->write_ptr = cpu_to_le32(write_ptr & write_ptr_msk);
+	data->cycle_cnt = cpu_to_le32(cycle_cnt & cycle_cnt_msk);
+
+	return data->ranges;
+}
+
+static void
+*iwl_dump_ini_mon_dram_fill_header(struct iwl_fw_runtime *fwrt,
+				   struct iwl_fw_ini_region_cfg *reg,
+				   void *data)
+{
+	struct iwl_fw_ini_monitor_dump *mon_dump = (void *)data;
+	u32 write_ptr_addr, write_ptr_msk, cycle_cnt_addr, cycle_cnt_msk;
+
+	switch (fwrt->trans->cfg->device_family) {
+	case IWL_DEVICE_FAMILY_9000:
+	case IWL_DEVICE_FAMILY_22000:
+		write_ptr_addr = MON_BUFF_WRPTR_VER2;
+		write_ptr_msk = -1;
+		cycle_cnt_addr = MON_BUFF_CYCLE_CNT_VER2;
+		cycle_cnt_msk = -1;
+		break;
+	default:
+		IWL_ERR(fwrt, "Unsupported device family %d\n",
+			fwrt->trans->cfg->device_family);
+		return NULL;
+	}
+
+	return iwl_dump_ini_mon_fill_header(fwrt, reg, mon_dump, write_ptr_addr,
+					    write_ptr_msk, cycle_cnt_addr,
+					    cycle_cnt_msk);
+}
+
+static void
+*iwl_dump_ini_mon_smem_fill_header(struct iwl_fw_runtime *fwrt,
+				   struct iwl_fw_ini_region_cfg *reg,
+				   void *data)
+{
+	struct iwl_fw_ini_monitor_dump *mon_dump = (void *)data;
+	const struct iwl_cfg *cfg = fwrt->trans->cfg;
+
+	if (fwrt->trans->cfg->device_family != IWL_DEVICE_FAMILY_9000 &&
+	    fwrt->trans->cfg->device_family != IWL_DEVICE_FAMILY_22000) {
+		IWL_ERR(fwrt, "Unsupported device family %d\n",
+			fwrt->trans->cfg->device_family);
+		return NULL;
+	}
+
+	return iwl_dump_ini_mon_fill_header(fwrt, reg, mon_dump,
+					    cfg->fw_mon_smem_write_ptr_addr,
+					    cfg->fw_mon_smem_write_ptr_msk,
+					    cfg->fw_mon_smem_cycle_cnt_ptr_addr,
+					    cfg->fw_mon_smem_cycle_cnt_ptr_msk);
 
-	return mon_dump->ranges;
 }
 
 static void *iwl_dump_ini_fifo_fill_header(struct iwl_fw_runtime *fwrt,
@@ -1528,7 +1579,7 @@ static u32 iwl_dump_ini_paging_get_size(struct iwl_fw_runtime *fwrt,
 static u32 iwl_dump_ini_mon_dram_get_size(struct iwl_fw_runtime *fwrt,
 					  struct iwl_fw_ini_region_cfg *reg)
 {
-	u32 size = sizeof(struct iwl_fw_ini_monitor_dram_dump) +
+	u32 size = sizeof(struct iwl_fw_ini_monitor_dump) +
 		sizeof(struct iwl_fw_ini_error_dump_range);
 
 	if (fwrt->trans->num_blocks)
@@ -1537,6 +1588,15 @@ static u32 iwl_dump_ini_mon_dram_get_size(struct iwl_fw_runtime *fwrt,
 	return size;
 }
 
+static u32 iwl_dump_ini_mon_smem_get_size(struct iwl_fw_runtime *fwrt,
+					  struct iwl_fw_ini_region_cfg *reg)
+{
+	return sizeof(struct iwl_fw_ini_monitor_dump) +
+		iwl_dump_ini_mem_ranges(fwrt, reg) *
+		(sizeof(struct iwl_fw_ini_error_dump_range) +
+		 le32_to_cpu(reg->internal.range_data_size));
+}
+
 static u32 iwl_dump_ini_txf_get_size(struct iwl_fw_runtime *fwrt,
 				     struct iwl_fw_ini_region_cfg *reg)
 {
@@ -1677,7 +1737,6 @@ static int iwl_fw_ini_get_trigger_len(struct iwl_fw_runtime *fwrt,
 		case IWL_FW_INI_REGION_PERIPHERY_MAC:
 		case IWL_FW_INI_REGION_PERIPHERY_PHY:
 		case IWL_FW_INI_REGION_PERIPHERY_AUX:
-		case IWL_FW_INI_REGION_INTERNAL_BUFFER:
 		case IWL_FW_INI_REGION_CSR:
 			size += hdr_len + iwl_dump_ini_mem_get_size(fwrt, reg);
 			break;
@@ -1703,6 +1762,10 @@ static int iwl_fw_ini_get_trigger_len(struct iwl_fw_runtime *fwrt,
 			size += hdr_len +
 				iwl_dump_ini_mon_dram_get_size(fwrt, reg);
 			break;
+		case IWL_FW_INI_REGION_INTERNAL_BUFFER:
+			size += hdr_len +
+				iwl_dump_ini_mon_smem_get_size(fwrt, reg);
+			break;
 		case IWL_FW_INI_REGION_DRAM_IMR:
 			/* Undefined yet */
 		default:
@@ -1739,7 +1802,6 @@ static void iwl_fw_ini_dump_trigger(struct iwl_fw_runtime *fwrt,
 		type = le32_to_cpu(reg->region_type);
 		switch (type) {
 		case IWL_FW_INI_REGION_DEVICE_MEMORY:
-		case IWL_FW_INI_REGION_INTERNAL_BUFFER:
 			ops.get_num_of_ranges = iwl_dump_ini_mem_ranges;
 			ops.get_size = iwl_dump_ini_mem_get_size;
 			ops.fill_mem_hdr = iwl_dump_ini_mem_fill_header;
@@ -1762,6 +1824,13 @@ static void iwl_fw_ini_dump_trigger(struct iwl_fw_runtime *fwrt,
 			ops.fill_range = iwl_dump_ini_mon_dram_iter;
 			iwl_dump_ini_mem(fwrt, type, data, reg, &ops);
 			break;
+		case IWL_FW_INI_REGION_INTERNAL_BUFFER:
+			ops.get_num_of_ranges = iwl_dump_ini_mem_ranges;
+			ops.get_size = iwl_dump_ini_mon_smem_get_size;
+			ops.fill_mem_hdr = iwl_dump_ini_mon_smem_fill_header;
+			ops.fill_range = iwl_dump_ini_dev_mem_iter;
+			iwl_dump_ini_mem(fwrt, type, data, reg, &ops);
+			break;
 		case IWL_FW_INI_REGION_PAGING: {
 			ops.fill_mem_hdr = iwl_dump_ini_mem_fill_header;
 			if (iwl_fw_dbg_is_paging_enabled(fwrt)) {
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
index 0df72a99bf05..260097c75427 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
@@ -374,13 +374,13 @@ struct iwl_fw_error_dump_rb {
 };
 
 /**
- * struct iwl_fw_ini_monitor_dram_dump - ini dram monitor dump
+ * struct iwl_fw_ini_monitor_dump - ini monitor dump
  * @header - header of the region
- * @write_ptr - write pointer position in the dram
+ * @write_ptr - write pointer position in the buffer
  * @cycle_cnt - cycles count
  * @ranges - the memory ranges of this this region
  */
-struct iwl_fw_ini_monitor_dram_dump {
+struct iwl_fw_ini_monitor_dump {
 	struct iwl_fw_ini_error_dump_header header;
 	__le32 write_ptr;
 	__le32 cycle_cnt;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 877d53355a58..76c1e44b7bdc 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -452,6 +452,10 @@ struct iwl_cfg {
 	u32 d3_debug_data_length;
 	u32 min_txq_size;
 	u32 umac_prph_offset;
+	u32 fw_mon_smem_write_ptr_addr;
+	u32 fw_mon_smem_write_ptr_msk;
+	u32 fw_mon_smem_cycle_cnt_ptr_addr;
+	u32 fw_mon_smem_cycle_cnt_ptr_msk;
 };
 
 extern const struct iwl_csr_params iwl_csr_v1;
-- 
2.20.1

