Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B748C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 12:04:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E145D206DD
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 12:04:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbfBTMEM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 07:04:12 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:34512 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726414AbfBTMEK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 07:04:10 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gwQbg-000411-NQ; Wed, 20 Feb 2019 14:04:09 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed, 20 Feb 2019 14:03:55 +0200
Message-Id: <20190220120400.8814-4-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190220120400.8814-1-luca@coelho.fi>
References: <20190220120400.8814-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 3/8] iwlwifi: dbg_ini: make fill_range handler accept generic range pointer
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Make fill_range handler of iwl_dump_ini_mem_ops accept a generic range
pointer. It is needed for future support in fifos dumping.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 53 +++++++++++----------
 1 file changed, 29 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 5a98eb0d5c00..b86691fdacb3 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1044,10 +1044,10 @@ _iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
 }
 
 static int iwl_dump_ini_prph_iter(struct iwl_fw_runtime *fwrt,
-				  struct iwl_fw_ini_error_dump_range *range,
 				  struct iwl_fw_ini_region_cfg *reg,
-				  int idx)
+				  void *range_ptr, int idx)
 {
+	struct iwl_fw_ini_error_dump_range *range = range_ptr;
 	__le32 *val = range->data;
 	u32 addr, prph_val, offset = le32_to_cpu(reg->offset);
 	int i;
@@ -1061,14 +1061,15 @@ static int iwl_dump_ini_prph_iter(struct iwl_fw_runtime *fwrt,
 			return -1;
 		*val++ = cpu_to_le32(prph_val);
 	}
-	return le32_to_cpu(range->range_data_size);
+
+	return sizeof(*range) + le32_to_cpu(range->range_data_size);
 }
 
 static int iwl_dump_ini_csr_iter(struct iwl_fw_runtime *fwrt,
-				 struct iwl_fw_ini_error_dump_range *range,
 				 struct iwl_fw_ini_region_cfg *reg,
-				 int idx)
+				 void *range_ptr, int idx)
 {
+	struct iwl_fw_ini_error_dump_range *range = range_ptr;
 	__le32 *val = range->data;
 	u32 addr, offset = le32_to_cpu(reg->offset);
 	int i;
@@ -1080,14 +1081,15 @@ static int iwl_dump_ini_csr_iter(struct iwl_fw_runtime *fwrt,
 		*val++ = cpu_to_le32(iwl_trans_read32(fwrt->trans,
 						      addr + offset));
 	}
-	return le32_to_cpu(range->range_data_size);
+
+	return sizeof(*range) + le32_to_cpu(range->range_data_size);
 }
 
 static int iwl_dump_ini_dev_mem_iter(struct iwl_fw_runtime *fwrt,
-				     struct iwl_fw_ini_error_dump_range *range,
 				     struct iwl_fw_ini_region_cfg *reg,
-				     int idx)
+				     void *range_ptr, int idx)
 {
+	struct iwl_fw_ini_error_dump_range *range = range_ptr;
 	u32 addr = le32_to_cpu(range->start_addr);
 	u32 offset = le32_to_cpu(reg->offset);
 
@@ -1095,33 +1097,35 @@ static int iwl_dump_ini_dev_mem_iter(struct iwl_fw_runtime *fwrt,
 	range->range_data_size = reg->internal.range_data_size;
 	iwl_trans_read_mem_bytes(fwrt->trans, addr + offset, range->data,
 				 le32_to_cpu(reg->internal.range_data_size));
-	return le32_to_cpu(range->range_data_size);
+
+	return sizeof(*range) + le32_to_cpu(range->range_data_size);
 }
 
 static int
 iwl_dump_ini_paging_gen2_iter(struct iwl_fw_runtime *fwrt,
-			      struct iwl_fw_ini_error_dump_range *range,
 			      struct iwl_fw_ini_region_cfg *reg,
-			      int idx)
+			      void *range_ptr, int idx)
 {
+	struct iwl_fw_ini_error_dump_range *range = range_ptr;
 	u32 page_size = fwrt->trans->init_dram.paging[idx].size;
 
 	range->start_addr = cpu_to_le32(idx);
 	range->range_data_size = cpu_to_le32(page_size);
 	memcpy(range->data, fwrt->trans->init_dram.paging[idx].block,
 	       page_size);
-	return le32_to_cpu(range->range_data_size);
+
+	return sizeof(*range) + le32_to_cpu(range->range_data_size);
 }
 
 static int iwl_dump_ini_paging_iter(struct iwl_fw_runtime *fwrt,
-				    struct iwl_fw_ini_error_dump_range *range,
 				    struct iwl_fw_ini_region_cfg *reg,
-				    int idx)
+				    void *range_ptr, int idx)
 {
 	/* increase idx by 1 since the pages are from 1 to
 	 * fwrt->num_of_paging_blk + 1
 	 */
 	struct page *page = fwrt->fw_paging_db[++idx].fw_paging_block;
+	struct iwl_fw_ini_error_dump_range *range = range_ptr;
 	dma_addr_t addr = fwrt->fw_paging_db[idx].fw_paging_phys;
 	u32 page_size = fwrt->fw_paging_db[idx].fw_paging_size;
 
@@ -1132,15 +1136,16 @@ static int iwl_dump_ini_paging_iter(struct iwl_fw_runtime *fwrt,
 	memcpy(range->data, page_address(page), page_size);
 	dma_sync_single_for_device(fwrt->trans->dev, addr, page_size,
 				   DMA_BIDIRECTIONAL);
-	return le32_to_cpu(range->range_data_size);
+
+	return sizeof(*range) + le32_to_cpu(range->range_data_size);
 }
 
 static int
 iwl_dump_ini_mon_dram_iter(struct iwl_fw_runtime *fwrt,
-			   struct iwl_fw_ini_error_dump_range *range,
-			   struct iwl_fw_ini_region_cfg *reg,
+			   struct iwl_fw_ini_region_cfg *reg, void *range_ptr,
 			   int idx)
 {
+	struct iwl_fw_ini_error_dump_range *range = range_ptr;
 	u32 start_addr = iwl_read_umac_prph(fwrt->trans,
 					    MON_BUFF_BASE_ADDR_VER2);
 
@@ -1153,7 +1158,7 @@ iwl_dump_ini_mon_dram_iter(struct iwl_fw_runtime *fwrt,
 	memcpy(range->data, fwrt->trans->fw_mon[idx].block,
 	       fwrt->trans->fw_mon[idx].size);
 
-	return le32_to_cpu(range->range_data_size);
+	return sizeof(*range) + le32_to_cpu(range->range_data_size);
 }
 
 static struct iwl_fw_ini_error_dump_range
@@ -1275,8 +1280,8 @@ struct iwl_dump_ini_mem_ops {
 	struct iwl_fw_ini_error_dump_range *
 		(*fill_mem_hdr)(struct iwl_fw_runtime *fwrt, void *data);
 	int (*fill_range)(struct iwl_fw_runtime *fwrt,
-			  struct iwl_fw_ini_error_dump_range *range,
-			  struct iwl_fw_ini_region_cfg *reg, int idx);
+			  struct iwl_fw_ini_region_cfg *reg, void *range,
+			  int idx);
 };
 
 /**
@@ -1293,7 +1298,7 @@ iwl_dump_ini_mem(struct iwl_fw_runtime *fwrt,
 		 struct iwl_dump_ini_mem_ops *ops)
 {
 	struct iwl_fw_ini_error_dump_header *header = (void *)(*data)->data;
-	struct iwl_fw_ini_error_dump_range *range;
+	void *range;
 	u32 num_of_ranges, i;
 
 	if (WARN_ON(!ops || !ops->get_num_of_ranges || !ops->get_size ||
@@ -1318,14 +1323,14 @@ iwl_dump_ini_mem(struct iwl_fw_runtime *fwrt,
 	}
 
 	for (i = 0; i < num_of_ranges; i++) {
-		int range_data_size = ops->fill_range(fwrt, range, reg, i);
+		int range_size = ops->fill_range(fwrt, reg, range, i);
 
-		if (range_data_size < 0) {
+		if (range_size < 0) {
 			IWL_ERR(fwrt, "Failed to dump region: id=%d, type=%d\n",
 				le32_to_cpu(reg->region_id), type);
 			return;
 		}
-		range = ((void *)range) + sizeof(*range) + range_data_size;
+		range = range + range_size;
 	}
 	*data = iwl_fw_error_next_data(*data);
 }
-- 
2.20.1

