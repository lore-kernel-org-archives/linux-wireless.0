Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3B36C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 08:22:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 727C92172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 08:22:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 727C92172C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729119AbeI1Oo4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 10:44:56 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:53386 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728976AbeI1Ooz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 10:44:55 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g5o2U-0004tY-U0; Fri, 28 Sep 2018 11:22:19 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 28 Sep 2018 11:21:55 +0300
Message-Id: <20180928082210.20762-4-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180928082210.20762-1-luca@coelho.fi>
References: <20180928082210.20762-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 03/18] iwlwifi: dbg: refactor dump code to improve readability
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Add a macro to replace all the conditions checking for valid dump
length.  In addition, move the fifo len calculation to a helper
function.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 158 ++++++++------------
 1 file changed, 66 insertions(+), 92 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 15419b41aaac..c2a6c4ffd356 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -635,6 +635,54 @@ static void iwl_fw_dump_mem(struct iwl_fw_runtime *fwrt,
 	}
 }
 
+#define ADD_LEN(len, item_len, const_len) \
+	do {size_t item = item_len; len += (!!item) * const_len + item; } \
+	while (0)
+
+static int iwl_fw_fifo_len(struct iwl_fw_runtime *fwrt,
+			   struct iwl_fwrt_shared_mem_cfg *mem_cfg)
+{
+	size_t hdr_len = sizeof(struct iwl_fw_error_dump_data) +
+			 sizeof(struct iwl_fw_error_dump_fifo);
+	u32 fifo_len = 0;
+	int i;
+
+	if (!(fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_RXF)))
+		goto dump_txf;
+
+	/* Count RXF2 size */
+	ADD_LEN(fifo_len, mem_cfg->rxfifo2_size, hdr_len);
+
+	/* Count RXF1 sizes */
+	for (i = 0; i < mem_cfg->num_lmacs; i++)
+		ADD_LEN(fifo_len, mem_cfg->lmac[i].rxfifo1_size, hdr_len);
+
+dump_txf:
+	if (!(fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_TXF)))
+		goto dump_internal_txf;
+
+	/* Count TXF sizes */
+	for (i = 0; i < mem_cfg->num_lmacs; i++) {
+		int j;
+
+		for (j = 0; j < mem_cfg->num_txfifo_entries; j++)
+			ADD_LEN(fifo_len, mem_cfg->lmac[i].txfifo_size[j],
+				hdr_len);
+	}
+
+dump_internal_txf:
+	if (!((fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_INTERNAL_TXF)) &&
+	      fw_has_capa(&fwrt->fw->ucode_capa,
+			  IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG)))
+		goto out;
+
+	for (i = 0; i < ARRAY_SIZE(mem_cfg->internal_txfifo_size); i++)
+		ADD_LEN(fifo_len, mem_cfg->internal_txfifo_size[i], hdr_len);
+
+out:
+	return fifo_len;
+}
+
 void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 {
 	struct iwl_fw_error_dump_file *dump_file;
@@ -645,9 +693,9 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 	struct iwl_fw_dump_ptrs *fw_error_dump;
 	struct scatterlist *sg_dump_data;
 	u32 sram_len, sram_ofs;
-	const struct iwl_fw_dbg_mem_seg_tlv *fw_dbg_mem = fwrt->fw->dbg.mem_tlv;
+	const struct iwl_fw_dbg_mem_seg_tlv *fw_mem = fwrt->fw->dbg.mem_tlv;
 	struct iwl_fwrt_shared_mem_cfg *mem_cfg = &fwrt->smem_cfg;
-	u32 file_len, fifo_data_len = 0, prph_len = 0, radio_len = 0;
+	u32 file_len, fifo_len = 0, prph_len = 0, radio_len = 0;
 	u32 smem_len = fwrt->fw->dbg.n_mem_tlv ? 0 : fwrt->trans->cfg->smem_len;
 	u32 sram2_len = fwrt->fw->dbg.n_mem_tlv ?
 				0 : fwrt->trans->cfg->dccm2_len;
@@ -684,70 +732,7 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 
 	/* reading RXF/TXF sizes */
 	if (test_bit(STATUS_FW_ERROR, &fwrt->trans->status)) {
-		fifo_data_len = 0;
-
-		if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_RXF)) {
-
-			/* Count RXF2 size */
-			if (mem_cfg->rxfifo2_size) {
-				/* Add header info */
-				fifo_data_len +=
-					mem_cfg->rxfifo2_size +
-					sizeof(*dump_data) +
-					sizeof(struct iwl_fw_error_dump_fifo);
-			}
-
-			/* Count RXF1 sizes */
-			for (i = 0; i < mem_cfg->num_lmacs; i++) {
-				if (!mem_cfg->lmac[i].rxfifo1_size)
-					continue;
-
-				/* Add header info */
-				fifo_data_len +=
-					mem_cfg->lmac[i].rxfifo1_size +
-					sizeof(*dump_data) +
-					sizeof(struct iwl_fw_error_dump_fifo);
-			}
-		}
-
-		if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_TXF)) {
-			size_t fifo_const_len = sizeof(*dump_data) +
-				sizeof(struct iwl_fw_error_dump_fifo);
-
-			/* Count TXF sizes */
-			for (i = 0; i < mem_cfg->num_lmacs; i++) {
-				int j;
-
-				for (j = 0; j < mem_cfg->num_txfifo_entries;
-				     j++) {
-					if (!mem_cfg->lmac[i].txfifo_size[j])
-						continue;
-
-					/* Add header info */
-					fifo_data_len +=
-						fifo_const_len +
-						mem_cfg->lmac[i].txfifo_size[j];
-				}
-			}
-		}
-
-		if ((fwrt->fw->dbg.dump_mask &
-		    BIT(IWL_FW_ERROR_DUMP_INTERNAL_TXF)) &&
-		    fw_has_capa(&fwrt->fw->ucode_capa,
-				IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG)) {
-			for (i = 0;
-			     i < ARRAY_SIZE(mem_cfg->internal_txfifo_size);
-			     i++) {
-				if (!mem_cfg->internal_txfifo_size[i])
-					continue;
-
-				/* Add header info */
-				fifo_data_len +=
-					mem_cfg->internal_txfifo_size[i] +
-					sizeof(*dump_data) +
-					sizeof(struct iwl_fw_error_dump_fifo);
-			}
-		}
+		fifo_len = iwl_fw_fifo_len(fwrt, mem_cfg);
 
 		/* Make room for PRPH registers */
 		if (!fwrt->trans->cfg->gen2 &&
@@ -759,10 +744,7 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 			radio_len = sizeof(*dump_data) + RADIO_REG_MAX_READ;
 	}
 
-	file_len = sizeof(*dump_file) +
-		   fifo_data_len +
-		   prph_len +
-		   radio_len;
+	file_len = sizeof(*dump_file) + fifo_len + prph_len + radio_len;
 
 	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_DEV_FW_INFO))
 		file_len += sizeof(*dump_data) + sizeof(*dump_info);
@@ -770,22 +752,19 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 		file_len += sizeof(*dump_data) + sizeof(*dump_smem_cfg);
 
 	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_MEM)) {
-		/* Make room for the SMEM, if it exists */
-		if (smem_len)
-			file_len += sizeof(*dump_data) + smem_len +
-				sizeof(struct iwl_fw_error_dump_mem);
-
-		/* Make room for the secondary SRAM, if it exists */
-		if (sram2_len)
-			file_len += sizeof(*dump_data) + sram2_len +
-				sizeof(struct iwl_fw_error_dump_mem);
-
-		/* Make room for MEM segments */
-		for (i = 0; i < fwrt->fw->dbg.n_mem_tlv; i++) {
-			file_len += sizeof(*dump_data) +
-				le32_to_cpu(fw_dbg_mem[i].len) +
-				sizeof(struct iwl_fw_error_dump_mem);
-		}
+		size_t hdr_len = sizeof(*dump_data) +
+				 sizeof(struct iwl_fw_error_dump_mem);
+
+		/* Dump SRAM only if no mem_tlvs */
+		if (!fwrt->fw->dbg.n_mem_tlv)
+			ADD_LEN(file_len, sram_len, hdr_len);
+
+		/* Make room for all mem types that exist */
+		ADD_LEN(file_len, smem_len, hdr_len);
+		ADD_LEN(file_len, sram2_len, hdr_len);
+
+		for (i = 0; i < fwrt->fw->dbg.n_mem_tlv; i++)
+			ADD_LEN(file_len, le32_to_cpu(fw_mem[i].len), hdr_len);
 	}
 
 	/* Make room for fw's virtual image pages, if it exists */
@@ -814,11 +793,6 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 		file_len += sizeof(*dump_data) + sizeof(*dump_trig) +
 			    fwrt->dump.desc->len;
 
-	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_MEM) &&
-	    !fwrt->fw->dbg.n_mem_tlv)
-		file_len += sizeof(*dump_data) + sram_len +
-			sizeof(struct iwl_fw_error_dump_mem);
-
 	dump_file = vzalloc(file_len);
 	if (!dump_file) {
 		kfree(fw_error_dump);
@@ -882,7 +856,7 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 	}
 
 	/* We only dump the FIFOs if the FW is in error state */
-	if (fifo_data_len) {
+	if (fifo_len) {
 		iwl_fw_dump_fifos(fwrt, &dump_data);
 		if (radio_len)
 			iwl_read_radio_regs(fwrt, &dump_data);
-- 
2.19.0

