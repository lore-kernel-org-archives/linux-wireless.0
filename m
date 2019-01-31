Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FEEDC282D9
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:22:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51B08218AF
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:22:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbfAaUWq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 15:22:46 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:53662 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727435AbfAaUWq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 15:22:46 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gpIqy-0004pL-F3; Thu, 31 Jan 2019 22:22:29 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Thu, 31 Jan 2019 22:22:02 +0200
Message-Id: <20190131202206.15903-18-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190131202206.15903-1-luca@coelho.fi>
References: <20190131202206.15903-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 17/21] iwlwifi: dbg_ini: implement paging memory dump
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Implement paging memory dump in the new dump mechanism.
To support this change, moved iwl_self_init_dram strcut from trans_pcie
to trans so that it will accessible via fw_runtime.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 114 ++++++++++++++++--
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |  15 +++
 .../wireless/intel/iwlwifi/pcie/ctxt-info.c   |   6 +-
 .../wireless/intel/iwlwifi/pcie/internal.h    |  18 +--
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |  10 +-
 5 files changed, 125 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index edad8175c2a3..390401300fcf 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1095,6 +1095,43 @@ static int iwl_dump_ini_dev_mem_iter(struct iwl_fw_runtime *fwrt,
 	return le32_to_cpu(range->range_data_size);
 }
 
+static int
+iwl_dump_ini_paging_gen2_iter(struct iwl_fw_runtime *fwrt,
+			      struct iwl_fw_ini_error_dump_range *range,
+			      struct iwl_fw_ini_region_cfg *reg,
+			      int idx)
+{
+	u32 page_size = fwrt->trans->init_dram.paging[idx].size;
+
+	range->start_addr = cpu_to_le32(idx);
+	range->range_data_size = cpu_to_le32(page_size);
+	memcpy(range->data, fwrt->trans->init_dram.paging[idx].block,
+	       page_size);
+	return le32_to_cpu(range->range_data_size);
+}
+
+static int iwl_dump_ini_paging_iter(struct iwl_fw_runtime *fwrt,
+				    struct iwl_fw_ini_error_dump_range *range,
+				    struct iwl_fw_ini_region_cfg *reg,
+				    int idx)
+{
+	/* increase idx by 1 since the pages are from 1 to
+	 * fwrt->num_of_paging_blk + 1
+	 */
+	struct page *page = fwrt->fw_paging_db[++idx].fw_paging_block;
+	dma_addr_t addr = fwrt->fw_paging_db[idx].fw_paging_phys;
+	u32 page_size = fwrt->fw_paging_db[idx].fw_paging_size;
+
+	range->start_addr = cpu_to_le32(idx);
+	range->range_data_size = cpu_to_le32(page_size);
+	dma_sync_single_for_cpu(fwrt->trans->dev, addr,	page_size,
+				DMA_BIDIRECTIONAL);
+	memcpy(range->data, page_address(page), page_size);
+	dma_sync_single_for_device(fwrt->trans->dev, addr, page_size,
+				   DMA_BIDIRECTIONAL);
+	return le32_to_cpu(range->range_data_size);
+}
+
 static struct iwl_fw_ini_error_dump_range
 *iwl_dump_ini_mem_fill_header(struct iwl_fw_runtime *fwrt, void *data)
 {
@@ -1110,12 +1147,46 @@ static u32 iwl_dump_ini_mem_get_size(struct iwl_fw_runtime *fwrt,
 		le32_to_cpu(reg->internal.range_data_size);
 }
 
+static u32 iwl_dump_ini_paging_gen2_get_size(struct iwl_fw_runtime *fwrt,
+					     struct iwl_fw_ini_region_cfg *reg)
+{
+	int i;
+	u32 size = 0;
+
+	for (i = 0; i < fwrt->trans->init_dram.paging_cnt; i++)
+		size += fwrt->trans->init_dram.paging[i].size;
+	return size;
+}
+
+static u32 iwl_dump_ini_paging_get_size(struct iwl_fw_runtime *fwrt,
+					struct iwl_fw_ini_region_cfg *reg)
+{
+	int i;
+	u32 size = 0;
+
+	for (i = 1; i <= fwrt->num_of_paging_blk; i++)
+		size += fwrt->fw_paging_db[i].fw_paging_size;
+	return size;
+}
+
 static u32 iwl_dump_ini_mem_ranges(struct iwl_fw_runtime *fwrt,
 				   struct iwl_fw_ini_region_cfg *reg)
 {
 	return le32_to_cpu(reg->internal.num_of_ranges);
 }
 
+static u32 iwl_dump_ini_paging_gen2_ranges(struct iwl_fw_runtime *fwrt,
+					   struct iwl_fw_ini_region_cfg *reg)
+{
+	return fwrt->trans->init_dram.paging_cnt;
+}
+
+static u32 iwl_dump_ini_paging_ranges(struct iwl_fw_runtime *fwrt,
+				      struct iwl_fw_ini_region_cfg *reg)
+{
+	return fwrt->num_of_paging_blk;
+}
+
 /**
  * struct iwl_dump_ini_mem_ops - ini memory dump operations
  * @get_num_of_ranges: returns the number of memory ranges in the region.
@@ -1224,14 +1295,21 @@ static int iwl_fw_ini_get_trigger_len(struct iwl_fw_runtime *fwrt,
 		case IWL_FW_INI_REGION_RXF:
 			size += iwl_fw_rxf_len(fwrt, &fwrt->smem_cfg);
 			break;
-		case IWL_FW_INI_REGION_PAGING:
-			if (!iwl_fw_dbg_is_paging_enabled(fwrt))
-				break;
-			size += fwrt->num_of_paging_blk *
-				(hdr_len +
-				 sizeof(struct iwl_fw_error_dump_paging) +
-				 PAGING_BLOCK_SIZE);
+		case IWL_FW_INI_REGION_PAGING: {
+			size += hdr_len + dump_header_len;
+			if (iwl_fw_dbg_is_paging_enabled(fwrt)) {
+				size += range_header_len *
+					iwl_dump_ini_paging_ranges(fwrt, reg) +
+					iwl_dump_ini_paging_get_size(fwrt, reg);
+			} else {
+				size += range_header_len *
+					iwl_dump_ini_paging_gen2_ranges(fwrt,
+									reg) +
+					iwl_dump_ini_paging_gen2_get_size(fwrt,
+									  reg);
+			}
 			break;
+		}
 		case IWL_FW_INI_REGION_DRAM_BUFFER:
 			/* Transport takes care of DRAM dumping */
 		case IWL_FW_INI_REGION_INTERNAL_BUFFER:
@@ -1286,12 +1364,24 @@ static void iwl_fw_ini_dump_trigger(struct iwl_fw_runtime *fwrt,
 		case IWL_FW_INI_REGION_DRAM_BUFFER:
 			*dump_mask |= BIT(IWL_FW_ERROR_DUMP_FW_MONITOR);
 			break;
-		case IWL_FW_INI_REGION_PAGING:
-			if (iwl_fw_dbg_is_paging_enabled(fwrt))
-				iwl_dump_paging(fwrt, data);
-			else
-				*dump_mask |= BIT(IWL_FW_ERROR_DUMP_PAGING);
+		case IWL_FW_INI_REGION_PAGING: {
+			ops.fill_mem_hdr = iwl_dump_ini_mem_fill_header;
+			if (iwl_fw_dbg_is_paging_enabled(fwrt)) {
+				ops.get_num_of_ranges =
+					iwl_dump_ini_paging_ranges;
+				ops.get_size = iwl_dump_ini_paging_get_size;
+				ops.fill_range = iwl_dump_ini_paging_iter;
+			} else {
+				ops.get_num_of_ranges =
+					iwl_dump_ini_paging_gen2_ranges;
+				ops.get_size =
+					iwl_dump_ini_paging_gen2_get_size;
+				ops.fill_range = iwl_dump_ini_paging_gen2_iter;
+			}
+
+			iwl_dump_ini_mem(fwrt, type, data, reg, &ops);
 			break;
+		}
 		case IWL_FW_INI_REGION_TXF:
 			iwl_fw_dump_txf(fwrt, data);
 			break;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index d79025d663df..36d0addb79e8 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -700,6 +700,20 @@ struct iwl_dram_data {
 	int size;
 };
 
+/**
+ * struct iwl_self_init_dram - dram data used by self init process
+ * @fw: lmac and umac dram data
+ * @fw_cnt: total number of items in array
+ * @paging: paging dram data
+ * @paging_cnt: total number of items in array
+ */
+struct iwl_self_init_dram {
+	struct iwl_dram_data *fw;
+	int fw_cnt;
+	struct iwl_dram_data *paging;
+	int paging_cnt;
+};
+
 /**
  * struct iwl_trans - transport common data
  *
@@ -794,6 +808,7 @@ struct iwl_trans {
 	u8 dbg_n_dest_reg;
 	int num_blocks;
 	struct iwl_dram_data fw_mon[IWL_FW_INI_APPLY_NUM];
+	struct iwl_self_init_dram init_dram;
 
 	enum iwl_plat_pm_mode system_pm_mode;
 	enum iwl_plat_pm_mode runtime_pm_mode;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
index 7f4aaa810ea1..9274e317cc77 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
@@ -59,8 +59,7 @@
 
 void iwl_pcie_ctxt_info_free_paging(struct iwl_trans *trans)
 {
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_self_init_dram *dram = &trans_pcie->init_dram;
+	struct iwl_self_init_dram *dram = &trans->init_dram;
 	int i;
 
 	if (!dram->paging) {
@@ -83,8 +82,7 @@ int iwl_pcie_init_fw_sec(struct iwl_trans *trans,
 			 const struct fw_img *fw,
 			 struct iwl_context_info_dram *ctxt_dram)
 {
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_self_init_dram *dram = &trans_pcie->init_dram;
+	struct iwl_self_init_dram *dram = &trans->init_dram;
 	int i, ret, lmac_cnt, umac_cnt, paging_cnt;
 
 	if (WARN(dram->paging,
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 0d16bcc3141f..ee38ae3b0d30 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -453,20 +453,6 @@ enum iwl_image_response_code {
 	IWL_IMAGE_RESP_FAIL		= 2,
 };
 
-/**
- * struct iwl_self_init_dram - dram data used by self init process
- * @fw: lmac and umac dram data
- * @fw_cnt: total number of items in array
- * @paging: paging dram data
- * @paging_cnt: total number of items in array
- */
-struct iwl_self_init_dram {
-	struct iwl_dram_data *fw;
-	int fw_cnt;
-	struct iwl_dram_data *paging;
-	int paging_cnt;
-};
-
 /**
  * struct cont_rec: continuous recording data structure
  * @prev_wr_ptr: the last address that was read in monitor_data
@@ -554,7 +540,6 @@ struct iwl_trans_pcie {
 	dma_addr_t prph_info_dma_addr;
 	dma_addr_t prph_scratch_dma_addr;
 	dma_addr_t iml_dma_addr;
-	struct iwl_self_init_dram init_dram;
 	struct iwl_trans *trans;
 
 	struct net_device napi_dev;
@@ -813,8 +798,7 @@ static inline int iwl_pcie_ctxt_info_alloc_dma(struct iwl_trans *trans,
 
 static inline void iwl_pcie_ctxt_info_free_fw_img(struct iwl_trans *trans)
 {
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_self_init_dram *dram = &trans_pcie->init_dram;
+	struct iwl_self_init_dram *dram = &trans->init_dram;
 	int i;
 
 	if (!dram->fw) {
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index f26664b0f0f8..ac82c891595c 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3220,10 +3220,10 @@ static struct iwl_trans_dump_data
 
 	/* Paged memory for gen2 HW */
 	if (trans->cfg->gen2 && dump_mask & BIT(IWL_FW_ERROR_DUMP_PAGING))
-		for (i = 0; i < trans_pcie->init_dram.paging_cnt; i++)
+		for (i = 0; i < trans->init_dram.paging_cnt; i++)
 			len += sizeof(*data) +
 			       sizeof(struct iwl_fw_error_dump_paging) +
-			       trans_pcie->init_dram.paging[i].size;
+			       trans->init_dram.paging[i].size;
 
 	dump_data = vzalloc(len);
 	if (!dump_data)
@@ -3275,16 +3275,16 @@ static struct iwl_trans_dump_data
 
 	/* Paged memory for gen2 HW */
 	if (trans->cfg->gen2 && dump_mask & BIT(IWL_FW_ERROR_DUMP_PAGING)) {
-		for (i = 0; i < trans_pcie->init_dram.paging_cnt; i++) {
+		for (i = 0; i < trans->init_dram.paging_cnt; i++) {
 			struct iwl_fw_error_dump_paging *paging;
-			u32 page_len = trans_pcie->init_dram.paging[i].size;
+			u32 page_len = trans->init_dram.paging[i].size;
 
 			data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_PAGING);
 			data->len = cpu_to_le32(sizeof(*paging) + page_len);
 			paging = (void *)data->data;
 			paging->index = cpu_to_le32(i);
 			memcpy(paging->data,
-			       trans_pcie->init_dram.paging[i].block, page_len);
+			       trans->init_dram.paging[i].block, page_len);
 			data = iwl_fw_error_next_data(data);
 
 			len += sizeof(*data) + sizeof(*paging) + page_len;
-- 
2.20.1

