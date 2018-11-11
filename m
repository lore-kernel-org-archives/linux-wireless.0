Return-Path: <SRS0=Soq1=NW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CEA3C0044C
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 20:09:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51E082080D
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 20:09:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 51E082080D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731521AbeKLF5J (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 00:57:09 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:35908 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730965AbeKLF5I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 00:57:08 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gLw1C-0000JG-2P; Sun, 11 Nov 2018 22:07:38 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 11 Nov 2018 22:07:17 +0200
Message-Id: <20181111200732.8159-2-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181111200732.8159-1-luca@coelho.fi>
References: <20181111200732.8159-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 01/16] iwlwifi: dbg: don't limit dump decisions to all or monitor
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Currently opmode is limited to asking transport to either
dump all the dumps configured at startup, or monitor only.
Instead, pass to transport a bitmask, to allow flexibility.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   |  7 +++--
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |  7 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  1 -
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 31 +++++++++----------
 4 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 58a980070445..67e6a35f14c4 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -908,6 +908,7 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 	struct iwl_fw_error_dump_file *dump_file;
 	struct scatterlist *sg_dump_data;
 	u32 file_len;
+	u32 dump_mask = fwrt->fw->dbg.dump_mask;
 
 	IWL_DEBUG_INFO(fwrt, "WRT dump start\n");
 
@@ -927,8 +928,10 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 		goto out;
 	}
 
-	fw_error_dump->trans_ptr = iwl_trans_dump_data(fwrt->trans,
-						       fwrt->dump.monitor_only);
+	if (fwrt->dump.monitor_only)
+		dump_mask &= IWL_FW_ERROR_DUMP_FW_MONITOR;
+
+	fw_error_dump->trans_ptr = iwl_trans_dump_data(fwrt->trans, dump_mask);
 	file_len = le32_to_cpu(dump_file->file_len);
 	fw_error_dump->fwrt_len = file_len;
 	if (fw_error_dump->trans_ptr) {
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index f384a98a021c..b0300e824815 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -602,7 +602,7 @@ struct iwl_trans_ops {
 	void (*resume)(struct iwl_trans *trans);
 
 	struct iwl_trans_dump_data *(*dump_data)(struct iwl_trans *trans,
-						 bool monitor_only);
+						 u32 dump_mask);
 };
 
 /**
@@ -776,7 +776,6 @@ struct iwl_trans {
 	const struct iwl_fw_dbg_dest_tlv_v1 *dbg_dest_tlv;
 	const struct iwl_fw_dbg_conf_tlv *dbg_conf_tlv[FW_DBG_CONF_MAX];
 	struct iwl_fw_dbg_trigger_tlv * const *dbg_trigger_tlv;
-	u32 dbg_dump_mask;
 	u8 dbg_n_dest_reg;
 	int num_blocks;
 	struct iwl_dram_data fw_mon[IWL_MAX_DEBUG_ALLOCATIONS];
@@ -896,11 +895,11 @@ static inline void iwl_trans_resume(struct iwl_trans *trans)
 }
 
 static inline struct iwl_trans_dump_data *
-iwl_trans_dump_data(struct iwl_trans *trans, bool monitor_only)
+iwl_trans_dump_data(struct iwl_trans *trans, u32 dump_mask)
 {
 	if (!trans->ops->dump_data)
 		return NULL;
-	return trans->ops->dump_data(trans, monitor_only);
+	return trans->ops->dump_data(trans, dump_mask);
 }
 
 static inline struct iwl_device_cmd *
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 2291661dd72d..0a5b35312b59 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -769,7 +769,6 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	memcpy(trans->dbg_conf_tlv, mvm->fw->dbg.conf_tlv,
 	       sizeof(trans->dbg_conf_tlv));
 	trans->dbg_trigger_tlv = mvm->fw->dbg.trigger_tlv;
-	trans->dbg_dump_mask = mvm->fw->dbg.dump_mask;
 
 	trans->iml = mvm->fw->iml;
 	trans->iml_len = mvm->fw->iml_len;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 551ce439647b..16eed9b0f301 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2990,7 +2990,7 @@ static int iwl_trans_get_fw_monitor_len(struct iwl_trans *trans, int *len)
 
 static struct iwl_trans_dump_data
 *iwl_trans_pcie_dump_data(struct iwl_trans *trans,
-			  bool monitor_only)
+			  u32 dump_mask)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_fw_error_dump_data *data;
@@ -3002,7 +3002,10 @@ static struct iwl_trans_dump_data
 	int i, ptr;
 	bool dump_rbs = test_bit(STATUS_FW_ERROR, &trans->status) &&
 			!trans->cfg->mq_rx_supported &&
-			trans->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_RB);
+			dump_mask & BIT(IWL_FW_ERROR_DUMP_RB);
+
+	if (!dump_mask)
+		return NULL;
 
 	/* transport dump header */
 	len = sizeof(*dump_data);
@@ -3014,11 +3017,7 @@ static struct iwl_trans_dump_data
 	/* FW monitor */
 	monitor_len = iwl_trans_get_fw_monitor_len(trans, &len);
 
-	if (monitor_only) {
-		if (!(trans->dbg_dump_mask &
-		      BIT(IWL_FW_ERROR_DUMP_FW_MONITOR)))
-			return NULL;
-
+	if (dump_mask == BIT(IWL_FW_ERROR_DUMP_FW_MONITOR)) {
 		dump_data = vzalloc(len);
 		if (!dump_data)
 			return NULL;
@@ -3031,11 +3030,11 @@ static struct iwl_trans_dump_data
 	}
 
 	/* CSR registers */
-	if (trans->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_CSR))
+	if (dump_mask & BIT(IWL_FW_ERROR_DUMP_CSR))
 		len += sizeof(*data) + IWL_CSR_TO_DUMP;
 
 	/* FH registers */
-	if (trans->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_FH_REGS)) {
+	if (dump_mask & BIT(IWL_FW_ERROR_DUMP_FH_REGS)) {
 		if (trans->cfg->gen2)
 			len += sizeof(*data) +
 			       (FH_MEM_UPPER_BOUND_GEN2 -
@@ -3060,8 +3059,7 @@ static struct iwl_trans_dump_data
 	}
 
 	/* Paged memory for gen2 HW */
-	if (trans->cfg->gen2 &&
-	    trans->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_PAGING))
+	if (trans->cfg->gen2 && dump_mask & BIT(IWL_FW_ERROR_DUMP_PAGING))
 		for (i = 0; i < trans_pcie->init_dram.paging_cnt; i++)
 			len += sizeof(*data) +
 			       sizeof(struct iwl_fw_error_dump_paging) +
@@ -3074,7 +3072,7 @@ static struct iwl_trans_dump_data
 	len = 0;
 	data = (void *)dump_data->data;
 
-	if (trans->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_TXCMD)) {
+	if (dump_mask & BIT(IWL_FW_ERROR_DUMP_TXCMD)) {
 		u16 tfd_size = trans_pcie->tfd_size;
 
 		data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_TXCMD);
@@ -3108,16 +3106,15 @@ static struct iwl_trans_dump_data
 		data = iwl_fw_error_next_data(data);
 	}
 
-	if (trans->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_CSR))
+	if (dump_mask & BIT(IWL_FW_ERROR_DUMP_CSR))
 		len += iwl_trans_pcie_dump_csr(trans, &data);
-	if (trans->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_FH_REGS))
+	if (dump_mask & BIT(IWL_FW_ERROR_DUMP_FH_REGS))
 		len += iwl_trans_pcie_fh_regs_dump(trans, &data);
 	if (dump_rbs)
 		len += iwl_trans_pcie_dump_rbs(trans, &data, num_rbs);
 
 	/* Paged memory for gen2 HW */
-	if (trans->cfg->gen2 &&
-	    trans->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_PAGING)) {
+	if (trans->cfg->gen2 && dump_mask & BIT(IWL_FW_ERROR_DUMP_PAGING)) {
 		for (i = 0; i < trans_pcie->init_dram.paging_cnt; i++) {
 			struct iwl_fw_error_dump_paging *paging;
 			dma_addr_t addr =
@@ -3137,7 +3134,7 @@ static struct iwl_trans_dump_data
 			len += sizeof(*data) + sizeof(*paging) + page_len;
 		}
 	}
-	if (trans->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_FW_MONITOR))
+	if (dump_mask & BIT(IWL_FW_ERROR_DUMP_FW_MONITOR))
 		len += iwl_trans_pcie_dump_monitor(trans, &data, monitor_len);
 
 	dump_data->len = len;
-- 
2.19.1

