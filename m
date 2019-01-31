Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AF6FC169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:22:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8E27218AF
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:22:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbfAaUWy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 15:22:54 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:53678 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727435AbfAaUWy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 15:22:54 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gpIqw-0004pL-TV; Thu, 31 Jan 2019 22:22:27 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Thu, 31 Jan 2019 22:22:00 +0200
Message-Id: <20190131202206.15903-16-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190131202206.15903-1-luca@coelho.fi>
References: <20190131202206.15903-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 15/21] iwlwifi: dbg_ini: implement csr memory dump
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Implement csr memory dump in the new dump mechanism.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 56 +++++++++------------
 1 file changed, 25 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 7fd7604751ef..e34b287a5405 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1062,31 +1062,6 @@ _iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
 	return dump_file;
 }
 
-static void iwl_dump_csr_ini(struct iwl_trans *trans,
-			     struct iwl_fw_error_dump_data **data,
-			     struct iwl_fw_ini_region_cfg *reg)
-{
-	int i, num = le32_to_cpu(reg->internal.num_of_ranges);
-	u32 size = le32_to_cpu(reg->internal.range_data_size);
-
-	IWL_DEBUG_INFO(trans, "WRT CSR dump\n");
-
-	for (i = 0; i < num; i++) {
-		u32 add = le32_to_cpu(reg->start_addr[i]);
-		__le32 *val;
-		int j;
-
-		(*data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_CSR);
-		(*data)->len = cpu_to_le32(size);
-		val = (void *)(*data)->data;
-
-		for (j = 0; j < size; j += 4)
-			*val++ = cpu_to_le32(iwl_trans_read32(trans, j + add));
-
-		*data = iwl_fw_error_next_data(*data);
-	}
-}
-
 static int iwl_dump_ini_prph_iter(struct iwl_fw_runtime *fwrt,
 				  struct iwl_fw_ini_error_dump_range *range,
 				  struct iwl_fw_ini_region_cfg *reg,
@@ -1108,6 +1083,25 @@ static int iwl_dump_ini_prph_iter(struct iwl_fw_runtime *fwrt,
 	return le32_to_cpu(range->range_data_size);
 }
 
+static int iwl_dump_ini_csr_iter(struct iwl_fw_runtime *fwrt,
+				 struct iwl_fw_ini_error_dump_range *range,
+				 struct iwl_fw_ini_region_cfg *reg,
+				 int idx)
+{
+	__le32 *val = range->data;
+	u32 addr, offset = le32_to_cpu(reg->offset);
+	int i;
+
+	range->start_addr = reg->start_addr[idx];
+	range->range_data_size = reg->internal.range_data_size;
+	for (i = 0; i < le32_to_cpu(reg->internal.range_data_size); i += 4) {
+		addr = le32_to_cpu(range->start_addr) + i;
+		*val++ = cpu_to_le32(iwl_trans_read32(fwrt->trans,
+						      addr + offset));
+	}
+	return le32_to_cpu(range->range_data_size);
+}
+
 static struct iwl_fw_ini_error_dump_range
 *iwl_dump_ini_mem_fill_header(struct iwl_fw_runtime *fwrt, void *data)
 {
@@ -1230,6 +1224,7 @@ static int iwl_fw_ini_get_trigger_len(struct iwl_fw_runtime *fwrt,
 		case IWL_FW_INI_REGION_PERIPHERY_MAC:
 		case IWL_FW_INI_REGION_PERIPHERY_PHY:
 		case IWL_FW_INI_REGION_PERIPHERY_AUX:
+		case IWL_FW_INI_REGION_CSR:
 			size += hdr_len + dump_header_len + range_header_len *
 				iwl_dump_ini_mem_ranges(fwrt, reg) +
 				iwl_dump_ini_mem_get_size(fwrt, reg);
@@ -1248,11 +1243,6 @@ static int iwl_fw_ini_get_trigger_len(struct iwl_fw_runtime *fwrt,
 				 sizeof(struct iwl_fw_error_dump_paging) +
 				 PAGING_BLOCK_SIZE);
 			break;
-		case IWL_FW_INI_REGION_CSR:
-			size += le32_to_cpu(reg->internal.num_of_ranges) *
-				(hdr_len +
-				 le32_to_cpu(reg->internal.range_data_size));
-			break;
 		case IWL_FW_INI_REGION_DRAM_BUFFER:
 			/* Transport takes care of DRAM dumping */
 		case IWL_FW_INI_REGION_INTERNAL_BUFFER:
@@ -1327,7 +1317,11 @@ static void iwl_fw_ini_dump_trigger(struct iwl_fw_runtime *fwrt,
 			iwl_fw_dump_rxf(fwrt, data);
 			break;
 		case IWL_FW_INI_REGION_CSR:
-			iwl_dump_csr_ini(fwrt->trans, data, reg);
+			ops.get_num_of_ranges =	iwl_dump_ini_mem_ranges;
+			ops.get_size = iwl_dump_ini_mem_get_size;
+			ops.fill_mem_hdr = iwl_dump_ini_mem_fill_header;
+			ops.fill_range = iwl_dump_ini_csr_iter;
+			iwl_dump_ini_mem(fwrt, type, data, reg, &ops);
 			break;
 		case IWL_FW_INI_REGION_DRAM_IMR:
 		case IWL_FW_INI_REGION_INTERNAL_BUFFER:
-- 
2.20.1

