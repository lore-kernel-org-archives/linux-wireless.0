Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C4F8C169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CF5D218AF
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbfAaUXP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 15:23:15 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:53726 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727435AbfAaUXP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 15:23:15 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gpIqu-0004pL-Ve; Thu, 31 Jan 2019 22:22:25 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Thu, 31 Jan 2019 22:21:58 +0200
Message-Id: <20190131202206.15903-14-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190131202206.15903-1-luca@coelho.fi>
References: <20190131202206.15903-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 13/21] iwlwifi: dbg_ini: align struct iwl_fw_ini_region_cfg to the FW
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

New fields were added to struct iwl_fw_ini_region_cfg.
add those field and apply the changes the result from this change

offset field is used to differentiate between the different LMACs
and any memory access to the region addresses should be
base_addr + offset.

A fifo struct is to hold the meta data needed for fifo regions

Also move range_data_size and num_of_ranges into a struct under the
union to be aligned to the struct in the FW.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/fw/api/dbg-tlv.h   | 40 +++++++++++++++---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 41 ++++++++++++-------
 2 files changed, 60 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h b/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
index 4926950d432a..75e23c426be8 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
@@ -133,6 +133,33 @@ struct iwl_fw_ini_debug_flow_tlv {
 
 #define IWL_FW_INI_MAX_REGION_ID	64
 #define IWL_FW_INI_MAX_NAME		32
+
+/**
+ * struct iwl_fw_ini_region_cfg_internal - meta data of internal memory region
+ * @num_of_range: the amount of ranges in the region
+ * @range_data_size: size of the data to read per range, in bytes.
+ */
+struct iwl_fw_ini_region_cfg_internal {
+	__le32 num_of_ranges;
+	__le32 range_data_size;
+} __packed; /* FW_DEBUG_TLV_REGION_NIC_INTERNAL_RANGES_S */
+
+/**
+ * struct iwl_fw_ini_region_cfg_fifos - meta data of fifos region
+ * @lmac1_id: bit map of lmac1 fifos to include in the region.
+ * @lmac2_id: bit map of lmac2 fifos to include in the region.
+ * @num_of_registers: number of prph registers in the region, each register is
+ *	4 bytes size.
+ * @header_only: none zero value indicates that this region does not include
+ *	fifo data and includes only the given registers.
+ */
+struct iwl_fw_ini_region_cfg_fifos {
+	__le32 lmac1_id;
+	__le32 lmac2_id;
+	__le32 num_of_registers;
+	__le32 header_only;
+} __packed; /* FW_DEBUG_TLV_REGION_FIFOS_S */
+
 /**
  * struct iwl_fw_ini_region_cfg
  * @region_id: ID of this dump configuration
@@ -140,11 +167,11 @@ struct iwl_fw_ini_debug_flow_tlv {
  * @num_regions: amount of regions in the address array.
  * @name_len: name length
  * @name: file name to use for this region
- * @num_of_range: the amount of ranges in the region.
+ * @internal: used in case the region uses internal memory.
  * @allocation_id: For DRAM type field substitutes for allocation_id
- * @range_data_size: size of the data to read per range, in bytes.
- * @start_addr: array of addresses. for type IWL_FW_INI_REGION_DRAM_BUFFER,
- *	1 entry. For any other case, num_of_ranges entries.
+ * @fifos: used in case of fifos region.
+ * @offset: offset to use for each memory base address
+ * @start_addr: array of addresses.
  */
 struct iwl_fw_ini_region_cfg {
 	__le32 region_id;
@@ -152,10 +179,11 @@ struct iwl_fw_ini_region_cfg {
 	__le32 name_len;
 	u8 name[IWL_FW_INI_MAX_NAME];
 	union {
-		__le32 num_of_ranges;
+		struct iwl_fw_ini_region_cfg_internal internal;
 		__le32 allocation_id;
+		struct iwl_fw_ini_region_cfg_fifos fifos;
 	};
-	__le32 range_data_size;
+	__le32 offset;
 	__le32 start_addr[];
 } __packed; /* FW_DEBUG_TLV_REGION_CONFIG_S */
 
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 5feae549d316..9bcce27c6bcf 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1068,7 +1068,7 @@ static void iwl_dump_prph_ini(struct iwl_trans *trans,
 {
 	struct iwl_fw_error_dump_prph *prph;
 	unsigned long flags;
-	u32 i, size = le32_to_cpu(reg->num_of_ranges);
+	u32 i, size = le32_to_cpu(reg->internal.num_of_ranges);
 
 	IWL_DEBUG_INFO(trans, "WRT PRPH dump\n");
 
@@ -1077,8 +1077,9 @@ static void iwl_dump_prph_ini(struct iwl_trans *trans,
 
 	for (i = 0; i < size; i++) {
 		(*data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_PRPH);
-		(*data)->len = cpu_to_le32(le32_to_cpu(reg->range_data_size) +
-					   sizeof(*prph));
+		(*data)->len =
+			cpu_to_le32(le32_to_cpu(reg->internal.range_data_size) +
+				    sizeof(*prph));
 		prph = (void *)(*data)->data;
 		prph->prph_start = reg->start_addr[i];
 		prph->data[0] = cpu_to_le32(iwl_read_prph_no_grab(trans,
@@ -1092,8 +1093,8 @@ static void iwl_dump_csr_ini(struct iwl_trans *trans,
 			     struct iwl_fw_error_dump_data **data,
 			     struct iwl_fw_ini_region_cfg *reg)
 {
-	int i, num = le32_to_cpu(reg->num_of_ranges);
-	u32 size = le32_to_cpu(reg->range_data_size);
+	int i, num = le32_to_cpu(reg->internal.num_of_ranges);
+	u32 size = le32_to_cpu(reg->internal.range_data_size);
 
 	IWL_DEBUG_INFO(trans, "WRT CSR dump\n");
 
@@ -1136,13 +1137,13 @@ static int iwl_fw_ini_get_trigger_len(struct iwl_fw_runtime *fwrt,
 			continue;
 
 		type = le32_to_cpu(reg->region_type);
-		num_entries = le32_to_cpu(reg->num_of_ranges);
+		num_entries = le32_to_cpu(reg->internal.num_of_ranges);
 
 		switch (type) {
 		case IWL_FW_INI_REGION_DEVICE_MEMORY:
 			size += hdr_len +
 				sizeof(struct iwl_fw_error_dump_named_mem) +
-				le32_to_cpu(reg->range_data_size);
+				le32_to_cpu(reg->internal.range_data_size);
 			break;
 		case IWL_FW_INI_REGION_PERIPHERY_MAC:
 		case IWL_FW_INI_REGION_PERIPHERY_PHY:
@@ -1168,7 +1169,8 @@ static int iwl_fw_ini_get_trigger_len(struct iwl_fw_runtime *fwrt,
 			break;
 		case IWL_FW_INI_REGION_CSR:
 			size += num_entries *
-				(hdr_len + le32_to_cpu(reg->range_data_size));
+				(hdr_len +
+				 le32_to_cpu(reg->internal.range_data_size));
 			break;
 		case IWL_FW_INI_REGION_DRAM_BUFFER:
 			/* Transport takes care of DRAM dumping */
@@ -1204,15 +1206,20 @@ static void iwl_fw_ini_dump_trigger(struct iwl_fw_runtime *fwrt,
 
 		type = le32_to_cpu(reg->region_type);
 		switch (type) {
-		case IWL_FW_INI_REGION_DEVICE_MEMORY:
-			if (WARN_ON(le32_to_cpu(reg->num_of_ranges) > 1))
+		case IWL_FW_INI_REGION_DEVICE_MEMORY: {
+			u32 num_of_ranges =
+				le32_to_cpu(reg->internal.num_of_ranges);
+			u32 range_data_size =
+				le32_to_cpu(reg->internal.range_data_size);
+
+			if (WARN_ON(num_of_ranges) > 1)
 				continue;
-			iwl_fw_dump_named_mem(fwrt, data,
-					      le32_to_cpu(reg->range_data_size),
+			iwl_fw_dump_named_mem(fwrt, data, range_data_size,
 					      le32_to_cpu(reg->start_addr[0]),
 					      reg->name,
 					      le32_to_cpu(reg->name_len));
 			break;
+		}
 		case IWL_FW_INI_REGION_PERIPHERY_MAC:
 		case IWL_FW_INI_REGION_PERIPHERY_PHY:
 		case IWL_FW_INI_REGION_PERIPHERY_AUX:
@@ -1761,6 +1768,7 @@ static void iwl_fw_dbg_update_regions(struct iwl_fw_runtime *fwrt,
 	for (i = 0; i < size; i++) {
 		struct iwl_fw_ini_region_cfg *reg = iter, **active;
 		int id = le32_to_cpu(reg->region_id);
+		u32 type = le32_to_cpu(reg->region_type);
 
 		if (WARN(id >= ARRAY_SIZE(fwrt->dump.active_regs),
 			 "Invalid region id %d for apply point %d\n", id, pnt))
@@ -1777,9 +1785,12 @@ static void iwl_fw_dbg_update_regions(struct iwl_fw_runtime *fwrt,
 
 		*active = reg;
 
-		if (le32_to_cpu(reg->region_type) !=
-		    IWL_FW_INI_REGION_DRAM_BUFFER)
-			iter += le32_to_cpu(reg->num_of_ranges) *
+		if (type == IWL_FW_INI_REGION_TXF ||
+		    type == IWL_FW_INI_REGION_RXF)
+			iter += le32_to_cpu(reg->fifos.num_of_registers) *
+				sizeof(__le32);
+		else if (type != IWL_FW_INI_REGION_DRAM_BUFFER)
+			iter += le32_to_cpu(reg->internal.num_of_ranges) *
 				sizeof(__le32);
 
 		iter += sizeof(*reg);
-- 
2.20.1

