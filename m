Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B97D8C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 13:59:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92825218A5
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 13:59:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbfCVN7u (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 09:59:50 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:46202 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727693AbfCVN7u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 09:59:50 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h7Khg-0000bK-IZ; Fri, 22 Mar 2019 15:59:25 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 22 Mar 2019 15:58:54 +0200
Message-Id: <20190322135903.10631-16-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190322135903.10631-1-luca@coelho.fi>
References: <20190322135903.10631-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 15/24] iwlwifi: dbg_ini: remove redundant type argument from iwl_dump_ini_mem
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Since iwl_dump_ini_mem receive struct iwl_fw_ini_region_cfg which holds
the region type, there is no point to pass the type separately.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 28 +++++++++------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 3709e90b55f1..95804feaeb75 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1664,17 +1664,17 @@ struct iwl_dump_ini_mem_ops {
  * @fwrt: fw runtime struct.
  * @data: dump memory data.
  * @reg: region to copy to the dump.
+ * @ops: memory dump operations.
  */
 static void
 iwl_dump_ini_mem(struct iwl_fw_runtime *fwrt,
-		 enum iwl_fw_ini_region_type type,
 		 struct iwl_fw_error_dump_data **data,
 		 struct iwl_fw_ini_region_cfg *reg,
 		 struct iwl_dump_ini_mem_ops *ops)
 {
 	struct iwl_fw_ini_error_dump_header *header = (void *)(*data)->data;
+	u32 num_of_ranges, i, type = le32_to_cpu(reg->region_type);
 	void *range;
-	u32 num_of_ranges, i;
 
 	if (WARN_ON(!ops || !ops->get_num_of_ranges || !ops->get_size ||
 		    !ops->fill_mem_hdr || !ops->fill_range))
@@ -1722,7 +1722,6 @@ static int iwl_fw_ini_get_trigger_len(struct iwl_fw_runtime *fwrt,
 	for (i = 0; i < le32_to_cpu(trigger->num_regions); i++) {
 		u32 reg_id = le32_to_cpu(trigger->data[i]);
 		struct iwl_fw_ini_region_cfg *reg;
-		enum iwl_fw_ini_region_type type;
 
 		if (WARN_ON(reg_id >= ARRAY_SIZE(fwrt->dump.active_regs)))
 			continue;
@@ -1731,8 +1730,7 @@ static int iwl_fw_ini_get_trigger_len(struct iwl_fw_runtime *fwrt,
 		if (WARN(!reg, "Unassigned region %d\n", reg_id))
 			continue;
 
-		type = le32_to_cpu(reg->region_type);
-		switch (type) {
+		switch (le32_to_cpu(reg->region_type)) {
 		case IWL_FW_INI_REGION_DEVICE_MEMORY:
 		case IWL_FW_INI_REGION_PERIPHERY_MAC:
 		case IWL_FW_INI_REGION_PERIPHERY_PHY:
@@ -1782,7 +1780,6 @@ static void iwl_fw_ini_dump_trigger(struct iwl_fw_runtime *fwrt,
 
 	for (i = 0; i < num; i++) {
 		u32 reg_id = le32_to_cpu(trigger->data[i]);
-		enum iwl_fw_ini_region_type type;
 		struct iwl_fw_ini_region_cfg *reg;
 		struct iwl_dump_ini_mem_ops ops;
 
@@ -1798,14 +1795,13 @@ static void iwl_fw_ini_dump_trigger(struct iwl_fw_runtime *fwrt,
 		if (le32_to_cpu(reg->domain) != IWL_FW_INI_DBG_DOMAIN_ALWAYS_ON)
 			continue;
 
-		type = le32_to_cpu(reg->region_type);
-		switch (type) {
+		switch (le32_to_cpu(reg->region_type)) {
 		case IWL_FW_INI_REGION_DEVICE_MEMORY:
 			ops.get_num_of_ranges = iwl_dump_ini_mem_ranges;
 			ops.get_size = iwl_dump_ini_mem_get_size;
 			ops.fill_mem_hdr = iwl_dump_ini_mem_fill_header;
 			ops.fill_range = iwl_dump_ini_dev_mem_iter;
-			iwl_dump_ini_mem(fwrt, type, data, reg, &ops);
+			iwl_dump_ini_mem(fwrt, data, reg, &ops);
 			break;
 		case IWL_FW_INI_REGION_PERIPHERY_MAC:
 		case IWL_FW_INI_REGION_PERIPHERY_PHY:
@@ -1814,21 +1810,21 @@ static void iwl_fw_ini_dump_trigger(struct iwl_fw_runtime *fwrt,
 			ops.get_size = iwl_dump_ini_mem_get_size;
 			ops.fill_mem_hdr = iwl_dump_ini_mem_fill_header;
 			ops.fill_range = iwl_dump_ini_prph_iter;
-			iwl_dump_ini_mem(fwrt, type, data, reg, &ops);
+			iwl_dump_ini_mem(fwrt, data, reg, &ops);
 			break;
 		case IWL_FW_INI_REGION_DRAM_BUFFER:
 			ops.get_num_of_ranges = iwl_dump_ini_mon_dram_ranges;
 			ops.get_size = iwl_dump_ini_mon_dram_get_size;
 			ops.fill_mem_hdr = iwl_dump_ini_mon_dram_fill_header;
 			ops.fill_range = iwl_dump_ini_mon_dram_iter;
-			iwl_dump_ini_mem(fwrt, type, data, reg, &ops);
+			iwl_dump_ini_mem(fwrt, data, reg, &ops);
 			break;
 		case IWL_FW_INI_REGION_INTERNAL_BUFFER:
 			ops.get_num_of_ranges = iwl_dump_ini_mem_ranges;
 			ops.get_size = iwl_dump_ini_mon_smem_get_size;
 			ops.fill_mem_hdr = iwl_dump_ini_mon_smem_fill_header;
 			ops.fill_range = iwl_dump_ini_dev_mem_iter;
-			iwl_dump_ini_mem(fwrt, type, data, reg, &ops);
+			iwl_dump_ini_mem(fwrt, data, reg, &ops);
 			break;
 		case IWL_FW_INI_REGION_PAGING:
 			ops.fill_mem_hdr = iwl_dump_ini_mem_fill_header;
@@ -1845,7 +1841,7 @@ static void iwl_fw_ini_dump_trigger(struct iwl_fw_runtime *fwrt,
 				ops.fill_range = iwl_dump_ini_paging_gen2_iter;
 			}
 
-			iwl_dump_ini_mem(fwrt, type, data, reg, &ops);
+			iwl_dump_ini_mem(fwrt, data, reg, &ops);
 			break;
 		case IWL_FW_INI_REGION_TXF: {
 			struct iwl_ini_txf_iter_data iter = { .init = true };
@@ -1856,7 +1852,7 @@ static void iwl_fw_ini_dump_trigger(struct iwl_fw_runtime *fwrt,
 			ops.get_size = iwl_dump_ini_txf_get_size;
 			ops.fill_mem_hdr = iwl_dump_ini_fifo_fill_header;
 			ops.fill_range = iwl_dump_ini_txf_iter;
-			iwl_dump_ini_mem(fwrt, type, data, reg, &ops);
+			iwl_dump_ini_mem(fwrt, data, reg, &ops);
 			fwrt->dump.fifo_iter = fifo_iter;
 			break;
 		}
@@ -1865,14 +1861,14 @@ static void iwl_fw_ini_dump_trigger(struct iwl_fw_runtime *fwrt,
 			ops.get_size = iwl_dump_ini_rxf_get_size;
 			ops.fill_mem_hdr = iwl_dump_ini_fifo_fill_header;
 			ops.fill_range = iwl_dump_ini_rxf_iter;
-			iwl_dump_ini_mem(fwrt, type, data, reg, &ops);
+			iwl_dump_ini_mem(fwrt, data, reg, &ops);
 			break;
 		case IWL_FW_INI_REGION_CSR:
 			ops.get_num_of_ranges =	iwl_dump_ini_mem_ranges;
 			ops.get_size = iwl_dump_ini_mem_get_size;
 			ops.fill_mem_hdr = iwl_dump_ini_mem_fill_header;
 			ops.fill_range = iwl_dump_ini_csr_iter;
-			iwl_dump_ini_mem(fwrt, type, data, reg, &ops);
+			iwl_dump_ini_mem(fwrt, data, reg, &ops);
 			break;
 		case IWL_FW_INI_REGION_DRAM_IMR:
 			/* This is undefined yet */
-- 
2.20.1

