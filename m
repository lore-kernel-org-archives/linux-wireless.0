Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91207C32789
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 11:08:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5884520657
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 11:08:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5884520657
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbeKBUPh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Nov 2018 16:15:37 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:34118 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726026AbeKBUPh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Nov 2018 16:15:37 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gIXJH-0007MW-VW; Fri, 02 Nov 2018 13:08:16 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  2 Nov 2018 13:07:57 +0200
Message-Id: <20181102110800.29817-13-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181102110800.29817-1-luca@coelho.fi>
References: <20181102110800.29817-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 12/15] iwlwifi: dbg: use helper to check if debug type is set
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

This enables to incorporate more logic in one place.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 36 ++++++++++-----------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h |  7 +++-
 2 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 310af0d60101..aebdf433b409 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -240,7 +240,7 @@ static void iwl_fw_dump_fifos(struct iwl_fw_runtime *fwrt,
 	if (!iwl_trans_grab_nic_access(fwrt->trans, &flags))
 		return;
 
-	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_RXF)) {
+	if (iwl_fw_dbg_type_on(fwrt, IWL_FW_ERROR_DUMP_RXF)) {
 		/* Pull RXF1 */
 		iwl_fwrt_dump_rxf(fwrt, dump_data,
 				  cfg->lmac[0].rxfifo1_size, 0, 0);
@@ -254,7 +254,7 @@ static void iwl_fw_dump_fifos(struct iwl_fw_runtime *fwrt,
 					  LMAC2_PRPH_OFFSET, 2);
 	}
 
-	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_TXF)) {
+	if (iwl_fw_dbg_type_on(fwrt, IWL_FW_ERROR_DUMP_TXF)) {
 		/* Pull TXF data from LMAC1 */
 		for (i = 0; i < fwrt->smem_cfg.num_txfifo_entries; i++) {
 			/* Mark the number of TXF we're pulling now */
@@ -279,7 +279,7 @@ static void iwl_fw_dump_fifos(struct iwl_fw_runtime *fwrt,
 		}
 	}
 
-	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_INTERNAL_TXF) &&
+	if (iwl_fw_dbg_type_on(fwrt, IWL_FW_ERROR_DUMP_INTERNAL_TXF) &&
 	    fw_has_capa(&fwrt->fw->ucode_capa,
 			IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG)) {
 		/* Pull UMAC internal TXF data from all TXFs */
@@ -603,7 +603,7 @@ static int iwl_fw_fifo_len(struct iwl_fw_runtime *fwrt,
 	u32 fifo_len = 0;
 	int i;
 
-	if (!(fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_RXF)))
+	if (!iwl_fw_dbg_type_on(fwrt, IWL_FW_ERROR_DUMP_RXF))
 		goto dump_txf;
 
 	/* Count RXF2 size */
@@ -614,7 +614,7 @@ static int iwl_fw_fifo_len(struct iwl_fw_runtime *fwrt,
 		ADD_LEN(fifo_len, mem_cfg->lmac[i].rxfifo1_size, hdr_len);
 
 dump_txf:
-	if (!(fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_TXF)))
+	if (!iwl_fw_dbg_type_on(fwrt, IWL_FW_ERROR_DUMP_TXF))
 		goto dump_internal_txf;
 
 	/* Count TXF sizes */
@@ -627,7 +627,7 @@ static int iwl_fw_fifo_len(struct iwl_fw_runtime *fwrt,
 	}
 
 dump_internal_txf:
-	if (!((fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_INTERNAL_TXF)) &&
+	if (!(iwl_fw_dbg_type_on(fwrt, IWL_FW_ERROR_DUMP_INTERNAL_TXF) &&
 	      fw_has_capa(&fwrt->fw->ucode_capa,
 			  IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG)))
 		goto out;
@@ -675,22 +675,22 @@ _iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
 
 		/* Make room for PRPH registers */
 		if (!fwrt->trans->cfg->gen2 &&
-		    fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_PRPH))
+		   iwl_fw_dbg_type_on(fwrt, IWL_FW_ERROR_DUMP_PRPH))
 			prph_len += iwl_fw_get_prph_len(fwrt);
 
 		if (fwrt->trans->cfg->device_family == IWL_DEVICE_FAMILY_7000 &&
-		    fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_RADIO_REG))
+		    iwl_fw_dbg_type_on(fwrt, IWL_FW_ERROR_DUMP_RADIO_REG))
 			radio_len = sizeof(*dump_data) + RADIO_REG_MAX_READ;
 	}
 
 	file_len = sizeof(*dump_file) + fifo_len + prph_len + radio_len;
 
-	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_DEV_FW_INFO))
+	if (iwl_fw_dbg_type_on(fwrt, IWL_FW_ERROR_DUMP_DEV_FW_INFO))
 		file_len += sizeof(*dump_data) + sizeof(*dump_info);
-	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_MEM_CFG))
+	if (iwl_fw_dbg_type_on(fwrt, IWL_FW_ERROR_DUMP_MEM_CFG))
 		file_len += sizeof(*dump_data) + sizeof(*dump_smem_cfg);
 
-	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_MEM)) {
+	if (iwl_fw_dbg_type_on(fwrt, IWL_FW_ERROR_DUMP_MEM)) {
 		size_t hdr_len = sizeof(*dump_data) +
 				 sizeof(struct iwl_fw_error_dump_mem);
 
@@ -707,7 +707,7 @@ _iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
 	}
 
 	/* Make room for fw's virtual image pages, if it exists */
-	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_PAGING) &&
+	if (iwl_fw_dbg_type_on(fwrt, IWL_FW_ERROR_DUMP_PAGING) &&
 	    !fwrt->trans->cfg->gen2 &&
 	    fwrt->fw->img[fwrt->cur_fw_img].paging_mem_size &&
 	    fwrt->fw_paging_db[0].fw_paging_block)
@@ -727,7 +727,7 @@ _iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
 			   sizeof(*dump_info) + sizeof(*dump_smem_cfg);
 	}
 
-	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_ERROR_INFO) &&
+	if (iwl_fw_dbg_type_on(fwrt, IWL_FW_ERROR_DUMP_ERROR_INFO) &&
 	    fwrt->dump.desc)
 		file_len += sizeof(*dump_data) + sizeof(*dump_trig) +
 			    fwrt->dump.desc->len;
@@ -741,7 +741,7 @@ _iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
 	dump_file->barker = cpu_to_le32(IWL_FW_ERROR_DUMP_BARKER);
 	dump_data = (void *)dump_file->data;
 
-	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_DEV_FW_INFO)) {
+	if (iwl_fw_dbg_type_on(fwrt, IWL_FW_ERROR_DUMP_DEV_FW_INFO)) {
 		dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_DEV_FW_INFO);
 		dump_data->len = cpu_to_le32(sizeof(*dump_info));
 		dump_info = (void *)dump_data->data;
@@ -762,7 +762,7 @@ _iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
 		dump_data = iwl_fw_error_next_data(dump_data);
 	}
 
-	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_MEM_CFG)) {
+	if (iwl_fw_dbg_type_on(fwrt, IWL_FW_ERROR_DUMP_MEM_CFG)) {
 		/* Dump shared memory configuration */
 		dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM_CFG);
 		dump_data->len = cpu_to_le32(sizeof(*dump_smem_cfg));
@@ -799,7 +799,7 @@ _iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
 			iwl_read_radio_regs(fwrt, &dump_data);
 	}
 
-	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_ERROR_INFO) &&
+	if (iwl_fw_dbg_type_on(fwrt, IWL_FW_ERROR_DUMP_ERROR_INFO) &&
 	    fwrt->dump.desc) {
 		dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_ERROR_INFO);
 		dump_data->len = cpu_to_le32(sizeof(*dump_trig) +
@@ -815,7 +815,7 @@ _iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
 	if (fwrt->dump.monitor_only)
 		goto out;
 
-	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_MEM)) {
+	if (iwl_fw_dbg_type_on(fwrt, IWL_FW_ERROR_DUMP_MEM)) {
 		const struct iwl_fw_dbg_mem_seg_tlv *fw_dbg_mem =
 			fwrt->fw->dbg.mem_tlv;
 
@@ -860,7 +860,7 @@ _iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
 	}
 
 	/* Dump fw's virtual image */
-	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_PAGING) &&
+	if (iwl_fw_dbg_type_on(fwrt, IWL_FW_ERROR_DUMP_PAGING) &&
 	    !fwrt->trans->cfg->gen2 &&
 	    fwrt->fw->img[fwrt->cur_fw_img].paging_mem_size &&
 	    fwrt->fw_paging_db[0].fw_paging_block) {
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index b56d787ffc1e..0d5169c4cf51 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -309,12 +309,17 @@ static inline void iwl_fw_dump_conf_clear(struct iwl_fw_runtime *fwrt)
 
 void iwl_fw_error_dump_wk(struct work_struct *work);
 
+static inline bool iwl_fw_dbg_type_on(struct iwl_fw_runtime *fwrt, u32 type)
+{
+	return (fwrt->fw->dbg.dump_mask & BIT(type));
+}
+
 static inline bool iwl_fw_dbg_is_d3_debug_enabled(struct iwl_fw_runtime *fwrt)
 {
 	return fw_has_capa(&fwrt->fw->ucode_capa,
 			   IWL_UCODE_TLV_CAPA_D3_DEBUG) &&
 		fwrt->trans->cfg->d3_debug_data_length &&
-		fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_D3_DEBUG_DATA);
+		iwl_fw_dbg_type_on(fwrt, IWL_FW_ERROR_DUMP_D3_DEBUG_DATA);
 }
 
 void iwl_fw_dbg_read_d3_debug_data(struct iwl_fw_runtime *fwrt);
-- 
2.19.1

