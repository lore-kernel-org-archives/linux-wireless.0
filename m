Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CF61C004D1
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 08:22:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CFAC2172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 08:22:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3CFAC2172C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729142AbeI1Oo6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 10:44:58 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:53412 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728976AbeI1Oo5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 10:44:57 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g5o2X-0004tY-86; Fri, 28 Sep 2018 11:22:21 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 28 Sep 2018 11:21:58 +0300
Message-Id: <20180928082210.20762-7-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180928082210.20762-1-luca@coelho.fi>
References: <20180928082210.20762-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 06/18] iwlwifi: dbg: dump memory in a helper function
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

The code that dumps various memory types repeats itself.  Move it to a
function to avoid duplication.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 92 ++++++++-------------
 1 file changed, 34 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index d3d0a197942f..146ec5065825 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -573,66 +573,22 @@ static int iwl_fw_get_prph_len(struct iwl_fw_runtime *fwrt)
 
 static void iwl_fw_dump_mem(struct iwl_fw_runtime *fwrt,
 			    struct iwl_fw_error_dump_data **dump_data,
-			    u32 sram_len, u32 sram_ofs, u32 smem_len,
-			    u32 sram2_len)
+			    u32 len, u32 ofs, u32 type)
 {
-	const struct iwl_fw_dbg_mem_seg_tlv *fw_dbg_mem = fwrt->fw->dbg.mem_tlv;
 	struct iwl_fw_error_dump_mem *dump_mem;
-	int i;
-
-	if (!fwrt->fw->dbg.n_mem_tlv) {
-		(*dump_data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
-		(*dump_data)->len = cpu_to_le32(sram_len + sizeof(*dump_mem));
-		dump_mem = (void *)(*dump_data)->data;
-		dump_mem->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM_SRAM);
-		dump_mem->offset = cpu_to_le32(sram_ofs);
-		iwl_trans_read_mem_bytes(fwrt->trans, sram_ofs, dump_mem->data,
-					 sram_len);
-		*dump_data = iwl_fw_error_next_data(*dump_data);
-	}
-
-	for (i = 0; i < fwrt->fw->dbg.n_mem_tlv; i++) {
-		u32 len = le32_to_cpu(fw_dbg_mem[i].len);
-		u32 ofs = le32_to_cpu(fw_dbg_mem[i].ofs);
-
-		(*dump_data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
-		(*dump_data)->len = cpu_to_le32(len + sizeof(*dump_mem));
-		dump_mem = (void *)(*dump_data)->data;
-		dump_mem->type = fw_dbg_mem[i].data_type;
-		dump_mem->offset = cpu_to_le32(ofs);
 
-		IWL_DEBUG_INFO(fwrt, "WRT memory dump. Type=%u\n",
-			       dump_mem->type);
-
-		iwl_trans_read_mem_bytes(fwrt->trans, ofs, dump_mem->data, len);
-		*dump_data = iwl_fw_error_next_data(*dump_data);
-	}
+	if (!len)
+		return;
 
-	if (smem_len) {
-		IWL_DEBUG_INFO(fwrt, "WRT SMEM dump\n");
-		(*dump_data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
-		(*dump_data)->len = cpu_to_le32(smem_len + sizeof(*dump_mem));
-		dump_mem = (void *)(*dump_data)->data;
-		dump_mem->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM_SMEM);
-		dump_mem->offset = cpu_to_le32(fwrt->trans->cfg->smem_offset);
-		iwl_trans_read_mem_bytes(fwrt->trans,
-					 fwrt->trans->cfg->smem_offset,
-					 dump_mem->data, smem_len);
-		*dump_data = iwl_fw_error_next_data(*dump_data);
-	}
+	(*dump_data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
+	(*dump_data)->len = cpu_to_le32(len + sizeof(*dump_mem));
+	dump_mem = (void *)(*dump_data)->data;
+	dump_mem->type = cpu_to_le32(type);
+	dump_mem->offset = cpu_to_le32(ofs);
+	iwl_trans_read_mem_bytes(fwrt->trans, ofs, dump_mem->data, len);
+	*dump_data = iwl_fw_error_next_data(*dump_data);
 
-	if (sram2_len) {
-		IWL_DEBUG_INFO(fwrt, "WRT SRAM dump\n");
-		(*dump_data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
-		(*dump_data)->len = cpu_to_le32(sram2_len + sizeof(*dump_mem));
-		dump_mem = (void *)(*dump_data)->data;
-		dump_mem->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM_SRAM);
-		dump_mem->offset = cpu_to_le32(fwrt->trans->cfg->dccm2_offset);
-		iwl_trans_read_mem_bytes(fwrt->trans,
-					 fwrt->trans->cfg->dccm2_offset,
-					 dump_mem->data, sram2_len);
-		*dump_data = iwl_fw_error_next_data(*dump_data);
-	}
+	IWL_DEBUG_INFO(fwrt, "WRT memory dump. Type=%u\n", dump_mem->type);
 }
 
 #define ADD_LEN(len, item_len, const_len) \
@@ -864,10 +820,30 @@ _iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
 	if (monitor_dump_only)
 		goto out;
 
-	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_MEM))
-		iwl_fw_dump_mem(fwrt, &dump_data, sram_len, sram_ofs, smem_len,
-				sram2_len);
+	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_MEM)) {
+		const struct iwl_fw_dbg_mem_seg_tlv *fw_dbg_mem =
+			fwrt->fw->dbg.mem_tlv;
+
+		if (!fwrt->fw->dbg.n_mem_tlv)
+			iwl_fw_dump_mem(fwrt, &dump_data, sram_len, sram_ofs,
+					IWL_FW_ERROR_DUMP_MEM_SRAM);
+
+		for (i = 0; i < fwrt->fw->dbg.n_mem_tlv; i++) {
+			u32 len = le32_to_cpu(fw_dbg_mem[i].len);
+			u32 ofs = le32_to_cpu(fw_dbg_mem[i].ofs);
 
+			iwl_fw_dump_mem(fwrt, &dump_data, len, ofs,
+					le32_to_cpu(fw_dbg_mem[i].data_type));
+		}
+
+		iwl_fw_dump_mem(fwrt, &dump_data, smem_len,
+				fwrt->trans->cfg->smem_offset,
+				IWL_FW_ERROR_DUMP_MEM_SMEM);
+
+		iwl_fw_dump_mem(fwrt, &dump_data, sram2_len,
+				fwrt->trans->cfg->dccm2_offset,
+				IWL_FW_ERROR_DUMP_MEM_SRAM);
+	}
 
 	if (iwl_fw_dbg_is_d3_debug_enabled(fwrt) && fwrt->dump.d3_debug_data) {
 		u32 addr = fwrt->trans->cfg->d3_debug_data_base_addr;
-- 
2.19.0

