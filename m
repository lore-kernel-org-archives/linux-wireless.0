Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8906C169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82DC7218AF
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:22:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbfAaUWi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 15:22:38 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:53646 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727435AbfAaUWi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 15:22:38 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gpIqx-0004pL-Mb; Thu, 31 Jan 2019 22:22:28 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Thu, 31 Jan 2019 22:22:01 +0200
Message-Id: <20190131202206.15903-17-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190131202206.15903-1-luca@coelho.fi>
References: <20190131202206.15903-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 16/21] iwlwifi: dbg_ini: implement device internal memory dump
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Implement device internal memory dump in the new dump mechanism.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 60 +++++++------------
 .../wireless/intel/iwlwifi/fw/error-dump.h    | 16 -----
 2 files changed, 21 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index e34b287a5405..edad8175c2a3 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -707,28 +707,6 @@ static void iwl_fw_dump_mem(struct iwl_fw_runtime *fwrt,
 	IWL_DEBUG_INFO(fwrt, "WRT memory dump. Type=%u\n", dump_mem->type);
 }
 
-static void iwl_fw_dump_named_mem(struct iwl_fw_runtime *fwrt,
-				  struct iwl_fw_error_dump_data **dump_data,
-				  u32 len, u32 ofs, u8 *name, u8 name_len)
-{
-	struct iwl_fw_error_dump_named_mem *dump_mem;
-
-	if (!len)
-		return;
-
-	(*dump_data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
-	(*dump_data)->len = cpu_to_le32(len + sizeof(*dump_mem));
-	dump_mem = (void *)(*dump_data)->data;
-	dump_mem->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM_NAMED_MEM);
-	dump_mem->offset = cpu_to_le32(ofs);
-	dump_mem->name_len = name_len;
-	memcpy(dump_mem->name, name, name_len);
-	iwl_trans_read_mem_bytes(fwrt->trans, ofs, dump_mem->data, len);
-	*dump_data = iwl_fw_error_next_data(*dump_data);
-
-	IWL_DEBUG_INFO(fwrt, "WRT memory dump. Type=%u\n", dump_mem->type);
-}
-
 #define ADD_LEN(len, item_len, const_len) \
 	do {size_t item = item_len; len += (!!item) * const_len + item; } \
 	while (0)
@@ -1102,6 +1080,21 @@ static int iwl_dump_ini_csr_iter(struct iwl_fw_runtime *fwrt,
 	return le32_to_cpu(range->range_data_size);
 }
 
+static int iwl_dump_ini_dev_mem_iter(struct iwl_fw_runtime *fwrt,
+				     struct iwl_fw_ini_error_dump_range *range,
+				     struct iwl_fw_ini_region_cfg *reg,
+				     int idx)
+{
+	u32 addr = le32_to_cpu(range->start_addr);
+	u32 offset = le32_to_cpu(reg->offset);
+
+	range->start_addr = reg->start_addr[idx];
+	range->range_data_size = reg->internal.range_data_size;
+	iwl_trans_read_mem_bytes(fwrt->trans, addr + offset, range->data,
+				 le32_to_cpu(reg->internal.range_data_size));
+	return le32_to_cpu(range->range_data_size);
+}
+
 static struct iwl_fw_ini_error_dump_range
 *iwl_dump_ini_mem_fill_header(struct iwl_fw_runtime *fwrt, void *data)
 {
@@ -1217,10 +1210,6 @@ static int iwl_fw_ini_get_trigger_len(struct iwl_fw_runtime *fwrt,
 		type = le32_to_cpu(reg->region_type);
 		switch (type) {
 		case IWL_FW_INI_REGION_DEVICE_MEMORY:
-			size += hdr_len +
-				sizeof(struct iwl_fw_error_dump_named_mem) +
-				le32_to_cpu(reg->internal.range_data_size);
-			break;
 		case IWL_FW_INI_REGION_PERIPHERY_MAC:
 		case IWL_FW_INI_REGION_PERIPHERY_PHY:
 		case IWL_FW_INI_REGION_PERIPHERY_AUX:
@@ -1278,20 +1267,13 @@ static void iwl_fw_ini_dump_trigger(struct iwl_fw_runtime *fwrt,
 
 		type = le32_to_cpu(reg->region_type);
 		switch (type) {
-		case IWL_FW_INI_REGION_DEVICE_MEMORY: {
-			u32 num_of_ranges =
-				le32_to_cpu(reg->internal.num_of_ranges);
-			u32 range_data_size =
-				le32_to_cpu(reg->internal.range_data_size);
-
-			if (WARN_ON(num_of_ranges) > 1)
-				continue;
-			iwl_fw_dump_named_mem(fwrt, data, range_data_size,
-					      le32_to_cpu(reg->start_addr[0]),
-					      reg->name,
-					      le32_to_cpu(reg->name_len));
+		case IWL_FW_INI_REGION_DEVICE_MEMORY:
+			ops.get_num_of_ranges = iwl_dump_ini_mem_ranges;
+			ops.get_size = iwl_dump_ini_mem_get_size;
+			ops.fill_mem_hdr = iwl_dump_ini_mem_fill_header;
+			ops.fill_range = iwl_dump_ini_dev_mem_iter;
+			iwl_dump_ini_mem(fwrt, type, data, reg, &ops);
 			break;
-		}
 		case IWL_FW_INI_REGION_PERIPHERY_MAC:
 		case IWL_FW_INI_REGION_PERIPHERY_PHY:
 		case IWL_FW_INI_REGION_PERIPHERY_AUX:
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
index fb2ff29762e2..42e0c4c93c82 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
@@ -274,22 +274,6 @@ struct iwl_fw_error_dump_mem {
 	u8 data[];
 };
 
-/**
- * struct iwl_fw_error_dump_named_mem - chunk of memory
- * @type: &enum iwl_fw_error_dump_mem_type
- * @offset: the offset from which the memory was read
- * @name_len: name length
- * @name: file name
- * @data: the content of the memory
- */
-struct iwl_fw_error_dump_named_mem {
-	__le32 type;
-	__le32 offset;
-	u8 name_len;
-	u8 name[32];
-	u8 data[];
-};
-
 /**
  * struct iwl_fw_ini_error_dump_range - range of memory
  * @start_addr: the start address of this range
-- 
2.20.1

