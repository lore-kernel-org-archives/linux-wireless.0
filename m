Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EAFFC4360F
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 12:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 120C6206DD
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 12:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfBTMEK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 07:04:10 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:34502 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726354AbfBTMEJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 07:04:09 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gwQbf-000411-RT; Wed, 20 Feb 2019 14:04:08 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed, 20 Feb 2019 14:03:54 +0200
Message-Id: <20190220120400.8814-3-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190220120400.8814-1-luca@coelho.fi>
References: <20190220120400.8814-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 2/8] iwlwifi: dbg_ini: make memory dump get_size handler include headers
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Make the get size handler of iwl_dump_ini_mem_ops include the total
size of the region. It is needed for fifos dumping.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 98 ++++++++++-----------
 1 file changed, 49 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index e4e50d598377..5a98eb0d5c00 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1187,21 +1187,50 @@ static struct iwl_fw_ini_error_dump_range
 	return mon_dump->ranges;
 }
 
+static u32 iwl_dump_ini_mem_ranges(struct iwl_fw_runtime *fwrt,
+				   struct iwl_fw_ini_region_cfg *reg)
+{
+	return le32_to_cpu(reg->internal.num_of_ranges);
+}
+
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
+static u32 iwl_dump_ini_mon_dram_ranges(struct iwl_fw_runtime *fwrt,
+					struct iwl_fw_ini_region_cfg *reg)
+{
+	return 1;
+}
+
 static u32 iwl_dump_ini_mem_get_size(struct iwl_fw_runtime *fwrt,
 				     struct iwl_fw_ini_region_cfg *reg)
 {
-	return le32_to_cpu(reg->internal.num_of_ranges) *
-		le32_to_cpu(reg->internal.range_data_size);
+	return sizeof(struct iwl_fw_ini_error_dump) +
+		iwl_dump_ini_mem_ranges(fwrt, reg) *
+		(sizeof(struct iwl_fw_ini_error_dump_range) +
+		 le32_to_cpu(reg->internal.range_data_size));
 }
 
 static u32 iwl_dump_ini_paging_gen2_get_size(struct iwl_fw_runtime *fwrt,
 					     struct iwl_fw_ini_region_cfg *reg)
 {
 	int i;
-	u32 size = 0;
+	u32 range_header_len = sizeof(struct iwl_fw_ini_error_dump_range);
+	u32 size = sizeof(struct iwl_fw_ini_error_dump);
+
+	for (i = 0; i < iwl_dump_ini_paging_gen2_ranges(fwrt, reg); i++)
+		size += range_header_len +
+			fwrt->trans->init_dram.paging[i].size;
 
-	for (i = 0; i < fwrt->trans->init_dram.paging_cnt; i++)
-		size += fwrt->trans->init_dram.paging[i].size;
 	return size;
 }
 
@@ -1209,47 +1238,30 @@ static u32 iwl_dump_ini_paging_get_size(struct iwl_fw_runtime *fwrt,
 					struct iwl_fw_ini_region_cfg *reg)
 {
 	int i;
-	u32 size = 0;
+	u32 range_header_len = sizeof(struct iwl_fw_ini_error_dump_range);
+	u32 size = sizeof(struct iwl_fw_ini_error_dump);
+
+	for (i = 1; i <= iwl_dump_ini_paging_ranges(fwrt, reg); i++)
+		size += range_header_len + fwrt->fw_paging_db[i].fw_paging_size;
 
-	for (i = 1; i <= fwrt->num_of_paging_blk; i++)
-		size += fwrt->fw_paging_db[i].fw_paging_size;
 	return size;
 }
 
 static u32 iwl_dump_ini_mon_dram_get_size(struct iwl_fw_runtime *fwrt,
 					  struct iwl_fw_ini_region_cfg *reg)
 {
-	return fwrt->trans->num_blocks ? fwrt->trans->fw_mon[0].size : 0;
-}
-
-static u32 iwl_dump_ini_mem_ranges(struct iwl_fw_runtime *fwrt,
-				   struct iwl_fw_ini_region_cfg *reg)
-{
-	return le32_to_cpu(reg->internal.num_of_ranges);
-}
-
-static u32 iwl_dump_ini_paging_gen2_ranges(struct iwl_fw_runtime *fwrt,
-					   struct iwl_fw_ini_region_cfg *reg)
-{
-	return fwrt->trans->init_dram.paging_cnt;
-}
+	u32 size = sizeof(struct iwl_fw_ini_monitor_dram_dump);
 
-static u32 iwl_dump_ini_paging_ranges(struct iwl_fw_runtime *fwrt,
-				      struct iwl_fw_ini_region_cfg *reg)
-{
-	return fwrt->num_of_paging_blk;
-}
+	if (fwrt->trans->num_blocks)
+		size += fwrt->trans->fw_mon[0].size;
 
-static u32 iwl_dump_ini_mon_dram_ranges(struct iwl_fw_runtime *fwrt,
-					struct iwl_fw_ini_region_cfg *reg)
-{
-	return 1;
+	return size;
 }
 
 /**
  * struct iwl_dump_ini_mem_ops - ini memory dump operations
  * @get_num_of_ranges: returns the number of memory ranges in the region.
- * @get_size: returns the size of the region data without headers.
+ * @get_size: returns the total size of the region.
  * @fill_mem_hdr: fills region type specific headers and returns the first
  *	range or NULL if failed to fill headers.
  * @fill_range: copies a given memory range into the dump.
@@ -1291,8 +1303,7 @@ iwl_dump_ini_mem(struct iwl_fw_runtime *fwrt,
 	num_of_ranges = ops->get_num_of_ranges(fwrt, reg);
 
 	(*data)->type = cpu_to_le32(type | INI_DUMP_BIT);
-	(*data)->len = cpu_to_le32(sizeof(*header) + num_of_ranges *
-				   sizeof(*range) + ops->get_size(fwrt, reg));
+	(*data)->len = cpu_to_le32(ops->get_size(fwrt, reg));
 
 	header->num_of_ranges = cpu_to_le32(num_of_ranges);
 	header->name_len = cpu_to_le32(min_t(int, IWL_FW_INI_MAX_NAME,
@@ -1323,8 +1334,6 @@ static int iwl_fw_ini_get_trigger_len(struct iwl_fw_runtime *fwrt,
 				      struct iwl_fw_ini_trigger *trigger)
 {
 	int i, size = 0, hdr_len = sizeof(struct iwl_fw_error_dump_data);
-	u32 dump_header_len = sizeof(struct iwl_fw_ini_error_dump);
-	u32 range_header_len = sizeof(struct iwl_fw_ini_error_dump_range);
 
 	if (!trigger || !trigger->num_regions)
 		return 0;
@@ -1349,9 +1358,7 @@ static int iwl_fw_ini_get_trigger_len(struct iwl_fw_runtime *fwrt,
 		case IWL_FW_INI_REGION_PERIPHERY_AUX:
 		case IWL_FW_INI_REGION_INTERNAL_BUFFER:
 		case IWL_FW_INI_REGION_CSR:
-			size += hdr_len + dump_header_len + range_header_len *
-				iwl_dump_ini_mem_ranges(fwrt, reg) +
-				iwl_dump_ini_mem_get_size(fwrt, reg);
+			size += hdr_len + iwl_dump_ini_mem_get_size(fwrt, reg);
 			break;
 		case IWL_FW_INI_REGION_TXF:
 			size += iwl_fw_txf_len(fwrt, &fwrt->smem_cfg);
@@ -1360,16 +1367,11 @@ static int iwl_fw_ini_get_trigger_len(struct iwl_fw_runtime *fwrt,
 			size += iwl_fw_rxf_len(fwrt, &fwrt->smem_cfg);
 			break;
 		case IWL_FW_INI_REGION_PAGING: {
-			size += hdr_len + dump_header_len;
+			size += hdr_len;
 			if (iwl_fw_dbg_is_paging_enabled(fwrt)) {
-				size += range_header_len *
-					iwl_dump_ini_paging_ranges(fwrt, reg) +
-					iwl_dump_ini_paging_get_size(fwrt, reg);
+				size += iwl_dump_ini_paging_get_size(fwrt, reg);
 			} else {
-				size += range_header_len *
-					iwl_dump_ini_paging_gen2_ranges(fwrt,
-									reg) +
-					iwl_dump_ini_paging_gen2_get_size(fwrt,
+				size += iwl_dump_ini_paging_gen2_get_size(fwrt,
 									  reg);
 			}
 			break;
@@ -1378,8 +1380,6 @@ static int iwl_fw_ini_get_trigger_len(struct iwl_fw_runtime *fwrt,
 			if (!fwrt->trans->num_blocks)
 				break;
 			size += hdr_len +
-				sizeof(struct iwl_fw_ini_monitor_dram_dump) *
-				iwl_dump_ini_mon_dram_ranges(fwrt, reg) +
 				iwl_dump_ini_mon_dram_get_size(fwrt, reg);
 			break;
 		case IWL_FW_INI_REGION_DRAM_IMR:
-- 
2.20.1

