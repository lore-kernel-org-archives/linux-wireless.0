Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C176C169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:22:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D65C218AF
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:22:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbfAaUWu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 15:22:50 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:53670 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727435AbfAaUWu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 15:22:50 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gpIqv-0004pL-VD; Thu, 31 Jan 2019 22:22:26 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Thu, 31 Jan 2019 22:21:59 +0200
Message-Id: <20190131202206.15903-15-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190131202206.15903-1-luca@coelho.fi>
References: <20190131202206.15903-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 14/21] iwlwifi: dbg_ini: create new dump flow and implement prph dump
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Create a skeleton to unite all memory dumps in ini mode.
Implement prph dump with the new skeleton.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 164 +++++++++++++-----
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   |   4 +
 .../wireless/intel/iwlwifi/fw/error-dump.h    |  34 ++++
 3 files changed, 163 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 9bcce27c6bcf..7fd7604751ef 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1062,33 +1062,6 @@ _iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
 	return dump_file;
 }
 
-static void iwl_dump_prph_ini(struct iwl_trans *trans,
-			      struct iwl_fw_error_dump_data **data,
-			      struct iwl_fw_ini_region_cfg *reg)
-{
-	struct iwl_fw_error_dump_prph *prph;
-	unsigned long flags;
-	u32 i, size = le32_to_cpu(reg->internal.num_of_ranges);
-
-	IWL_DEBUG_INFO(trans, "WRT PRPH dump\n");
-
-	if (!iwl_trans_grab_nic_access(trans, &flags))
-		return;
-
-	for (i = 0; i < size; i++) {
-		(*data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_PRPH);
-		(*data)->len =
-			cpu_to_le32(le32_to_cpu(reg->internal.range_data_size) +
-				    sizeof(*prph));
-		prph = (void *)(*data)->data;
-		prph->prph_start = reg->start_addr[i];
-		prph->data[0] = cpu_to_le32(iwl_read_prph_no_grab(trans,
-								  le32_to_cpu(prph->prph_start)));
-		*data = iwl_fw_error_next_data(*data);
-	}
-	iwl_trans_release_nic_access(trans, &flags);
-}
-
 static void iwl_dump_csr_ini(struct iwl_trans *trans,
 			     struct iwl_fw_error_dump_data **data,
 			     struct iwl_fw_ini_region_cfg *reg)
@@ -1114,20 +1087,131 @@ static void iwl_dump_csr_ini(struct iwl_trans *trans,
 	}
 }
 
+static int iwl_dump_ini_prph_iter(struct iwl_fw_runtime *fwrt,
+				  struct iwl_fw_ini_error_dump_range *range,
+				  struct iwl_fw_ini_region_cfg *reg,
+				  int idx)
+{
+	__le32 *val = range->data;
+	u32 addr, prph_val, offset = le32_to_cpu(reg->offset);
+	int i;
+
+	range->start_addr = reg->start_addr[idx];
+	range->range_data_size = reg->internal.range_data_size;
+	for (i = 0; i < le32_to_cpu(reg->internal.range_data_size); i += 4) {
+		addr = le32_to_cpu(range->start_addr) + i;
+		prph_val = iwl_read_prph(fwrt->trans, addr + offset);
+		if (prph_val == 0x5a5a5a5a)
+			return -1;
+		*val++ = cpu_to_le32(prph_val);
+	}
+	return le32_to_cpu(range->range_data_size);
+}
+
+static struct iwl_fw_ini_error_dump_range
+*iwl_dump_ini_mem_fill_header(struct iwl_fw_runtime *fwrt, void *data)
+{
+	struct iwl_fw_ini_error_dump *dump = data;
+
+	return dump->ranges;
+}
+
+static u32 iwl_dump_ini_mem_get_size(struct iwl_fw_runtime *fwrt,
+				     struct iwl_fw_ini_region_cfg *reg)
+{
+	return le32_to_cpu(reg->internal.num_of_ranges) *
+		le32_to_cpu(reg->internal.range_data_size);
+}
+
+static u32 iwl_dump_ini_mem_ranges(struct iwl_fw_runtime *fwrt,
+				   struct iwl_fw_ini_region_cfg *reg)
+{
+	return le32_to_cpu(reg->internal.num_of_ranges);
+}
+
+/**
+ * struct iwl_dump_ini_mem_ops - ini memory dump operations
+ * @get_num_of_ranges: returns the number of memory ranges in the region.
+ * @get_size: returns the size of the region data without headers.
+ * @fill_mem_hdr: fills region type specific headers and returns the first
+ *	range or NULL if failed to fill headers.
+ * @fill_range: copies a given memory range into the dump.
+ *	Returns the size of the range or -1 otherwise.
+ */
+struct iwl_dump_ini_mem_ops {
+	u32 (*get_num_of_ranges)(struct iwl_fw_runtime *fwrt,
+				 struct iwl_fw_ini_region_cfg *reg);
+	u32 (*get_size)(struct iwl_fw_runtime *fwrt,
+			struct iwl_fw_ini_region_cfg *reg);
+	struct iwl_fw_ini_error_dump_range *
+		(*fill_mem_hdr)(struct iwl_fw_runtime *fwrt, void *data);
+	int (*fill_range)(struct iwl_fw_runtime *fwrt,
+			  struct iwl_fw_ini_error_dump_range *range,
+			  struct iwl_fw_ini_region_cfg *reg, int idx);
+};
+
+/**
+ * iwl_dump_ini_mem - copy a memory region into the dump
+ * @fwrt: fw runtime struct.
+ * @data: dump memory data.
+ * @reg: region to copy to the dump.
+ */
+static void
+iwl_dump_ini_mem(struct iwl_fw_runtime *fwrt,
+		 enum iwl_fw_ini_region_type type,
+		 struct iwl_fw_error_dump_data **data,
+		 struct iwl_fw_ini_region_cfg *reg,
+		 struct iwl_dump_ini_mem_ops *ops)
+{
+	struct iwl_fw_ini_error_dump_header *header = (void *)(*data)->data;
+	struct iwl_fw_ini_error_dump_range *range;
+	u32 num_of_ranges, i;
+
+	if (WARN_ON(!ops || !ops->get_num_of_ranges || !ops->get_size ||
+		    !ops->fill_mem_hdr || !ops->fill_range))
+		return;
+
+	num_of_ranges = ops->get_num_of_ranges(fwrt, reg);
+
+	(*data)->type = cpu_to_le32(type | INI_DUMP_BIT);
+	(*data)->len = cpu_to_le32(sizeof(*header) + num_of_ranges *
+				   sizeof(*range) + ops->get_size(fwrt, reg));
+
+	header->num_of_ranges = cpu_to_le32(num_of_ranges);
+	header->name_len = cpu_to_le32(min_t(int, IWL_FW_INI_MAX_NAME,
+					     le32_to_cpu(reg->name_len)));
+	memcpy(header->name, reg->name, le32_to_cpu(header->name_len));
+
+	range = ops->fill_mem_hdr(fwrt, header);
+	if (!range)
+		return;
+
+	for (i = 0; i < num_of_ranges; i++) {
+		int range_data_size = ops->fill_range(fwrt, range, reg, i);
+
+		if (range_data_size < 0) {
+			IWL_ERR(fwrt, "Failed to dump region type %d\n", type);
+			return;
+		}
+		range = ((void *)range) + sizeof(*range) + range_data_size;
+	}
+	*data = iwl_fw_error_next_data(*data);
+}
+
 static int iwl_fw_ini_get_trigger_len(struct iwl_fw_runtime *fwrt,
 				      struct iwl_fw_ini_trigger *trigger)
 {
-	int i, num, size = 0, hdr_len = sizeof(struct iwl_fw_error_dump_data);
+	int i, size = 0, hdr_len = sizeof(struct iwl_fw_error_dump_data);
+	u32 dump_header_len = sizeof(struct iwl_fw_ini_error_dump);
+	u32 range_header_len = sizeof(struct iwl_fw_ini_error_dump_range);
 
 	if (!trigger || !trigger->num_regions)
 		return 0;
 
-	num = le32_to_cpu(trigger->num_regions);
-	for (i = 0; i < num; i++) {
+	for (i = 0; i < le32_to_cpu(trigger->num_regions); i++) {
 		u32 reg_id = le32_to_cpu(trigger->data[i]);
 		struct iwl_fw_ini_region_cfg *reg;
 		enum iwl_fw_ini_region_type type;
-		u32 num_entries;
 
 		if (WARN_ON(reg_id >= ARRAY_SIZE(fwrt->dump.active_regs)))
 			continue;
@@ -1137,8 +1221,6 @@ static int iwl_fw_ini_get_trigger_len(struct iwl_fw_runtime *fwrt,
 			continue;
 
 		type = le32_to_cpu(reg->region_type);
-		num_entries = le32_to_cpu(reg->internal.num_of_ranges);
-
 		switch (type) {
 		case IWL_FW_INI_REGION_DEVICE_MEMORY:
 			size += hdr_len +
@@ -1148,10 +1230,9 @@ static int iwl_fw_ini_get_trigger_len(struct iwl_fw_runtime *fwrt,
 		case IWL_FW_INI_REGION_PERIPHERY_MAC:
 		case IWL_FW_INI_REGION_PERIPHERY_PHY:
 		case IWL_FW_INI_REGION_PERIPHERY_AUX:
-			size += num_entries *
-				(hdr_len +
-				 sizeof(struct iwl_fw_error_dump_prph) +
-				 sizeof(u32));
+			size += hdr_len + dump_header_len + range_header_len *
+				iwl_dump_ini_mem_ranges(fwrt, reg) +
+				iwl_dump_ini_mem_get_size(fwrt, reg);
 			break;
 		case IWL_FW_INI_REGION_TXF:
 			size += iwl_fw_txf_len(fwrt, &fwrt->smem_cfg);
@@ -1168,7 +1249,7 @@ static int iwl_fw_ini_get_trigger_len(struct iwl_fw_runtime *fwrt,
 				 PAGING_BLOCK_SIZE);
 			break;
 		case IWL_FW_INI_REGION_CSR:
-			size += num_entries *
+			size += le32_to_cpu(reg->internal.num_of_ranges) *
 				(hdr_len +
 				 le32_to_cpu(reg->internal.range_data_size));
 			break;
@@ -1195,6 +1276,7 @@ static void iwl_fw_ini_dump_trigger(struct iwl_fw_runtime *fwrt,
 		u32 reg_id = le32_to_cpu(trigger->data[i]);
 		enum iwl_fw_ini_region_type type;
 		struct iwl_fw_ini_region_cfg *reg;
+		struct iwl_dump_ini_mem_ops ops;
 
 		if (reg_id >= ARRAY_SIZE(fwrt->dump.active_regs))
 			continue;
@@ -1223,7 +1305,11 @@ static void iwl_fw_ini_dump_trigger(struct iwl_fw_runtime *fwrt,
 		case IWL_FW_INI_REGION_PERIPHERY_MAC:
 		case IWL_FW_INI_REGION_PERIPHERY_PHY:
 		case IWL_FW_INI_REGION_PERIPHERY_AUX:
-			iwl_dump_prph_ini(fwrt->trans, data, reg);
+			ops.get_num_of_ranges =	iwl_dump_ini_mem_ranges;
+			ops.get_size = iwl_dump_ini_mem_get_size;
+			ops.fill_mem_hdr = iwl_dump_ini_mem_fill_header;
+			ops.fill_range = iwl_dump_ini_prph_iter;
+			iwl_dump_ini_mem(fwrt, type, data, reg, &ops);
 			break;
 		case IWL_FW_INI_REGION_DRAM_BUFFER:
 			*dump_mask |= BIT(IWL_FW_ERROR_DUMP_FW_MONITOR);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index 2fa7a19e02b6..a6133b5f9e83 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -441,4 +441,8 @@ void iwl_fw_dbg_apply_point(struct iwl_fw_runtime *fwrt,
 			    enum iwl_fw_ini_apply_point apply_point);
 
 void iwl_fwrt_stop_device(struct iwl_fw_runtime *fwrt);
+
+/* This bit is used to differentiate the legacy dump from the ini dump */
+#define INI_DUMP_BIT BIT(31)
+
 #endif  /* __iwl_fw_dbg_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
index e1c6aa61ab90..fb2ff29762e2 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
@@ -290,6 +290,40 @@ struct iwl_fw_error_dump_named_mem {
 	u8 data[];
 };
 
+/**
+ * struct iwl_fw_ini_error_dump_range - range of memory
+ * @start_addr: the start address of this range
+ * @range_data_size: the size of this range, in bytes
+ * @data: the actual memory
+ */
+struct iwl_fw_ini_error_dump_range {
+	__le32 start_addr;
+	__le32 range_data_size;
+	__le32 data[];
+} __packed;
+
+/**
+ * struct iwl_fw_ini_error_dump_header - ini region dump header
+ * @num_of_ranges: number of ranges in this region
+ * @name_len: number of bytes allocated to the name string of this region
+ * @name: name of the region
+ */
+struct iwl_fw_ini_error_dump_header {
+	__le32 num_of_ranges;
+	__le32 name_len;
+	u8 name[IWL_FW_INI_MAX_NAME];
+};
+
+/**
+ * struct iwl_fw_ini_error_dump - ini region dump
+ * @header: the header of this region
+ * @ranges: the memory ranges of this this region
+ */
+struct iwl_fw_ini_error_dump {
+	struct iwl_fw_ini_error_dump_header header;
+	struct iwl_fw_ini_error_dump_range ranges[];
+} __packed;
+
 /**
  * struct iwl_fw_error_dump_rb - content of an Receive Buffer
  * @index: the index of the Receive Buffer in the Rx queue
-- 
2.20.1

