Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30ED6C282D9
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:55:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CD6320855
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 11:55:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730748AbfA3Lzu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 06:55:50 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:52736 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728480AbfA3Lzt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 06:55:49 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gooT5-0003x8-0I; Wed, 30 Jan 2019 13:55:47 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed, 30 Jan 2019 13:55:15 +0200
Message-Id: <20190130115528.19922-5-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190130115528.19922-1-luca@coelho.fi>
References: <20190130115528.19922-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 04/17] iwlwifi: dbg_ini: give better naming to region struct fields
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Some of the region struct fields have misleading naming
change those fields to have an informative naming

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/fw/api/dbg-tlv.h   | 12 ++++++-----
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 21 ++++++++++---------
 2 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h b/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
index a2c4a28c46a3..2b4b902cffc4 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
@@ -138,11 +138,13 @@ struct iwl_fw_ini_debug_flow_tlv {
  * @region_id: ID of this dump configuration
  * @region_type: &enum iwl_fw_ini_region_type
  * @num_regions: amount of regions in the address array.
- * @allocation_id: For DRAM type field substitutes for allocation_id.
  * @name_len: name length
  * @name: file name to use for this region
- * @size: size of the data, in bytes.(unused for IWL_FW_INI_REGION_DRAM_BUFFER)
- * @start_addr: array of addresses. (unused for IWL_FW_INI_REGION_DRAM_BUFFER)
+ * @num_of_range: the amount of ranges in the region.
+ * @allocation_id: For DRAM type field substitutes for allocation_id
+ * @range_data_size: size of the data to read per range, in bytes.
+ * @start_addr: array of addresses. for type IWL_FW_INI_REGION_DRAM_BUFFER,
+ *	1 entry. For any other case, num_of_ranges entries.
  */
 struct iwl_fw_ini_region_cfg {
 	__le32 region_id;
@@ -150,10 +152,10 @@ struct iwl_fw_ini_region_cfg {
 	__le32 name_len;
 	u8 name[IWL_FW_INI_MAX_NAME];
 	union {
-		__le32 num_regions;
+		__le32 num_of_ranges;
 		__le32 allocation_id;
 	};
-	__le32 size;
+	__le32 range_data_size;
 	__le32 start_addr[];
 } __packed; /* FW_DEBUG_TLV_REGION_CONFIG_S */
 
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 22efd94da6d3..35c2b1a23d10 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1065,7 +1065,7 @@ static void iwl_dump_prph_ini(struct iwl_trans *trans,
 {
 	struct iwl_fw_error_dump_prph *prph;
 	unsigned long flags;
-	u32 i, size = le32_to_cpu(reg->num_regions);
+	u32 i, size = le32_to_cpu(reg->num_of_ranges);
 
 	IWL_DEBUG_INFO(trans, "WRT PRPH dump\n");
 
@@ -1074,7 +1074,7 @@ static void iwl_dump_prph_ini(struct iwl_trans *trans,
 
 	for (i = 0; i < size; i++) {
 		(*data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_PRPH);
-		(*data)->len = cpu_to_le32(le32_to_cpu(reg->size) +
+		(*data)->len = cpu_to_le32(le32_to_cpu(reg->range_data_size) +
 					   sizeof(*prph));
 		prph = (void *)(*data)->data;
 		prph->prph_start = reg->start_addr[i];
@@ -1089,8 +1089,8 @@ static void iwl_dump_csr_ini(struct iwl_trans *trans,
 			     struct iwl_fw_error_dump_data **data,
 			     struct iwl_fw_ini_region_cfg *reg)
 {
-	int i, num = le32_to_cpu(reg->num_regions);
-	u32 size = le32_to_cpu(reg->size);
+	int i, num = le32_to_cpu(reg->num_of_ranges);
+	u32 size = le32_to_cpu(reg->range_data_size);
 
 	IWL_DEBUG_INFO(trans, "WRT CSR dump\n");
 
@@ -1133,13 +1133,13 @@ static int iwl_fw_ini_get_trigger_len(struct iwl_fw_runtime *fwrt,
 			continue;
 
 		type = le32_to_cpu(reg->region_type);
-		num_entries = le32_to_cpu(reg->num_regions);
+		num_entries = le32_to_cpu(reg->num_of_ranges);
 
 		switch (type) {
 		case IWL_FW_INI_REGION_DEVICE_MEMORY:
 			size += hdr_len +
 				sizeof(struct iwl_fw_error_dump_named_mem) +
-				le32_to_cpu(reg->size);
+				le32_to_cpu(reg->range_data_size);
 			break;
 		case IWL_FW_INI_REGION_PERIPHERY_MAC:
 		case IWL_FW_INI_REGION_PERIPHERY_PHY:
@@ -1165,7 +1165,7 @@ static int iwl_fw_ini_get_trigger_len(struct iwl_fw_runtime *fwrt,
 			break;
 		case IWL_FW_INI_REGION_CSR:
 			size += num_entries *
-				(hdr_len + le32_to_cpu(reg->size));
+				(hdr_len + le32_to_cpu(reg->range_data_size));
 			break;
 		case IWL_FW_INI_REGION_DRAM_BUFFER:
 			/* Transport takes care of DRAM dumping */
@@ -1202,10 +1202,10 @@ static void iwl_fw_ini_dump_trigger(struct iwl_fw_runtime *fwrt,
 		type = le32_to_cpu(reg->region_type);
 		switch (type) {
 		case IWL_FW_INI_REGION_DEVICE_MEMORY:
-			if (WARN_ON(le32_to_cpu(reg->num_regions) > 1))
+			if (WARN_ON(le32_to_cpu(reg->num_of_ranges) > 1))
 				continue;
 			iwl_fw_dump_named_mem(fwrt, data,
-					      le32_to_cpu(reg->size),
+					      le32_to_cpu(reg->range_data_size),
 					      le32_to_cpu(reg->start_addr[0]),
 					      reg->name,
 					      le32_to_cpu(reg->name_len));
@@ -1773,7 +1773,8 @@ static void iwl_fw_dbg_update_regions(struct iwl_fw_runtime *fwrt,
 
 		if (le32_to_cpu(reg->region_type) !=
 		    IWL_FW_INI_REGION_DRAM_BUFFER)
-			iter += le32_to_cpu(reg->num_regions) * sizeof(__le32);
+			iter += le32_to_cpu(reg->num_of_ranges) *
+				sizeof(__le32);
 
 		iter += sizeof(*reg);
 	}
-- 
2.20.1

