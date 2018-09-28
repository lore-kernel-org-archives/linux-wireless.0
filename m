Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5B9DC43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 08:22:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9174C2172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 08:22:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9174C2172C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbeI1OpE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 10:45:04 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:53394 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728972AbeI1Oo4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 10:44:56 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g5o2V-0004tY-Mi; Fri, 28 Sep 2018 11:22:20 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 28 Sep 2018 11:21:56 +0300
Message-Id: <20180928082210.20762-5-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180928082210.20762-1-luca@coelho.fi>
References: <20180928082210.20762-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 04/18] iwlwifi: dbg: split iwl_fw_error_dump to two functions
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Split iwl_fw_error_dump to two parts.  The first part will dump the
actual data, and second will do the file allocations, trans calls and
actual file operations.  This is done in order to enable reuse of the
code for the new debug ini infrastructure.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 63 +++++++++++++--------
 1 file changed, 40 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index c2a6c4ffd356..d3d0a197942f 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -683,15 +683,15 @@ static int iwl_fw_fifo_len(struct iwl_fw_runtime *fwrt,
 	return fifo_len;
 }
 
-void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
+static struct iwl_fw_error_dump_file *
+_iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
+		   struct iwl_fw_dump_ptrs *fw_error_dump)
 {
 	struct iwl_fw_error_dump_file *dump_file;
 	struct iwl_fw_error_dump_data *dump_data;
 	struct iwl_fw_error_dump_info *dump_info;
 	struct iwl_fw_error_dump_smem_cfg *dump_smem_cfg;
 	struct iwl_fw_error_dump_trigger_desc *dump_trig;
-	struct iwl_fw_dump_ptrs *fw_error_dump;
-	struct scatterlist *sg_dump_data;
 	u32 sram_len, sram_ofs;
 	const struct iwl_fw_dbg_mem_seg_tlv *fw_mem = fwrt->fw->dbg.mem_tlv;
 	struct iwl_fwrt_shared_mem_cfg *mem_cfg = &fwrt->smem_cfg;
@@ -702,22 +702,10 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 	bool monitor_dump_only = false;
 	int i;
 
-	IWL_DEBUG_INFO(fwrt, "WRT dump start\n");
-
-	/* there's no point in fw dump if the bus is dead */
-	if (test_bit(STATUS_TRANS_DEAD, &fwrt->trans->status)) {
-		IWL_ERR(fwrt, "Skip fw error dump since bus is dead\n");
-		goto out;
-	}
-
 	if (fwrt->dump.trig &&
 	    fwrt->dump.trig->mode & IWL_FW_DBG_TRIGGER_MONITOR_ONLY)
 		monitor_dump_only = true;
 
-	fw_error_dump = kzalloc(sizeof(*fw_error_dump), GFP_KERNEL);
-	if (!fw_error_dump)
-		goto out;
-
 	/* SRAM - include stack CCM if driver knows the values for it */
 	if (!fwrt->trans->cfg->dccm_offset || !fwrt->trans->cfg->dccm_len) {
 		const struct fw_img *img;
@@ -794,10 +782,8 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 			    fwrt->dump.desc->len;
 
 	dump_file = vzalloc(file_len);
-	if (!dump_file) {
-		kfree(fw_error_dump);
-		goto out;
-	}
+	if (!dump_file)
+		return NULL;
 
 	fw_error_dump->fwrt_ptr = dump_file;
 
@@ -876,7 +862,7 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 
 	/* In case we only want monitor dump, skip to dump trasport data */
 	if (monitor_dump_only)
-		goto dump_trans_data;
+		goto out;
 
 	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_MEM))
 		iwl_fw_dump_mem(fwrt, &dump_data, sram_len, sram_ofs, smem_len,
@@ -939,13 +925,44 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 				      ARRAY_SIZE(iwl_prph_dump_addr_9000));
 	}
 
-dump_trans_data:
+out:
+	dump_file->file_len = cpu_to_le32(file_len);
+	return dump_file;
+}
+
+void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
+{
+	struct iwl_fw_dump_ptrs *fw_error_dump;
+	struct iwl_fw_error_dump_file *dump_file;
+	struct scatterlist *sg_dump_data;
+	u32 file_len;
+
+	IWL_DEBUG_INFO(fwrt, "WRT dump start\n");
+
+	/* there's no point in fw dump if the bus is dead */
+	if (test_bit(STATUS_TRANS_DEAD, &fwrt->trans->status)) {
+		IWL_ERR(fwrt, "Skip fw error dump since bus is dead\n");
+		goto out;
+	}
+
+	fw_error_dump = kzalloc(sizeof(*fw_error_dump), GFP_KERNEL);
+	if (!fw_error_dump)
+		goto out;
+
+	dump_file = _iwl_fw_error_dump(fwrt, fw_error_dump);
+	if (!dump_file) {
+		kfree(fw_error_dump);
+		goto out;
+	}
+
 	fw_error_dump->trans_ptr = iwl_trans_dump_data(fwrt->trans,
 						       fwrt->dump.trig);
+	file_len = le32_to_cpu(dump_file->file_len);
 	fw_error_dump->fwrt_len = file_len;
-	if (fw_error_dump->trans_ptr)
+	if (fw_error_dump->trans_ptr) {
 		file_len += fw_error_dump->trans_ptr->len;
-	dump_file->file_len = cpu_to_le32(file_len);
+		dump_file->file_len = cpu_to_le32(file_len);
+	}
 
 	sg_dump_data = alloc_sgtable(file_len);
 	if (sg_dump_data) {
-- 
2.19.0

