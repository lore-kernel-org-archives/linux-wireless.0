Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0011BC04E87
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 08:22:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB7992173D
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 08:22:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AB7992173D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbeI1Oo5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 10:44:57 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:53378 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728275AbeI1Oo4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 10:44:56 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g5o2T-0004tY-MH; Fri, 28 Sep 2018 11:22:18 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 28 Sep 2018 11:21:54 +0300
Message-Id: <20180928082210.20762-3-luca@coelho.fi>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20180928082210.20762-1-luca@coelho.fi>
References: <20180928082210.20762-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 02/18] iwlwifi: dbg: move debug data to a struct
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

The debug variables are bloating the iwl_fw struct.  And the fields
are out of order, missing docs and some are redundant.

Clean this up.  This serves as preparation for unionizing it for the
new ini infra.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 68 ++++++++---------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   |  6 +-
 drivers/net/wireless/intel/iwlwifi/fw/img.h   | 41 ++++++----
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  | 76 +++++++++----------
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |  4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  | 10 +--
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |  2 +-
 8 files changed, 108 insertions(+), 101 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 0dcf1a673478..15419b41aaac 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -240,7 +240,7 @@ static void iwl_fw_dump_fifos(struct iwl_fw_runtime *fwrt,
 	if (!iwl_trans_grab_nic_access(fwrt->trans, &flags))
 		return;
 
-	if (fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_RXF)) {
+	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_RXF)) {
 		/* Pull RXF1 */
 		iwl_fwrt_dump_rxf(fwrt, dump_data,
 				  cfg->lmac[0].rxfifo1_size, 0, 0);
@@ -254,7 +254,7 @@ static void iwl_fw_dump_fifos(struct iwl_fw_runtime *fwrt,
 					  LMAC2_PRPH_OFFSET, 2);
 	}
 
-	if (fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_TXF)) {
+	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_TXF)) {
 		/* Pull TXF data from LMAC1 */
 		for (i = 0; i < fwrt->smem_cfg.num_txfifo_entries; i++) {
 			/* Mark the number of TXF we're pulling now */
@@ -279,7 +279,7 @@ static void iwl_fw_dump_fifos(struct iwl_fw_runtime *fwrt,
 		}
 	}
 
-	if (fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_INTERNAL_TXF) &&
+	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_INTERNAL_TXF) &&
 	    fw_has_capa(&fwrt->fw->ucode_capa,
 			IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG)) {
 		/* Pull UMAC internal TXF data from all TXFs */
@@ -576,11 +576,11 @@ static void iwl_fw_dump_mem(struct iwl_fw_runtime *fwrt,
 			    u32 sram_len, u32 sram_ofs, u32 smem_len,
 			    u32 sram2_len)
 {
-	const struct iwl_fw_dbg_mem_seg_tlv *fw_dbg_mem = fwrt->fw->dbg_mem_tlv;
+	const struct iwl_fw_dbg_mem_seg_tlv *fw_dbg_mem = fwrt->fw->dbg.mem_tlv;
 	struct iwl_fw_error_dump_mem *dump_mem;
 	int i;
 
-	if (!fwrt->fw->n_dbg_mem_tlv) {
+	if (!fwrt->fw->dbg.n_mem_tlv) {
 		(*dump_data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
 		(*dump_data)->len = cpu_to_le32(sram_len + sizeof(*dump_mem));
 		dump_mem = (void *)(*dump_data)->data;
@@ -591,7 +591,7 @@ static void iwl_fw_dump_mem(struct iwl_fw_runtime *fwrt,
 		*dump_data = iwl_fw_error_next_data(*dump_data);
 	}
 
-	for (i = 0; i < fwrt->fw->n_dbg_mem_tlv; i++) {
+	for (i = 0; i < fwrt->fw->dbg.n_mem_tlv; i++) {
 		u32 len = le32_to_cpu(fw_dbg_mem[i].len);
 		u32 ofs = le32_to_cpu(fw_dbg_mem[i].ofs);
 
@@ -645,11 +645,11 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 	struct iwl_fw_dump_ptrs *fw_error_dump;
 	struct scatterlist *sg_dump_data;
 	u32 sram_len, sram_ofs;
-	const struct iwl_fw_dbg_mem_seg_tlv *fw_dbg_mem = fwrt->fw->dbg_mem_tlv;
+	const struct iwl_fw_dbg_mem_seg_tlv *fw_dbg_mem = fwrt->fw->dbg.mem_tlv;
 	struct iwl_fwrt_shared_mem_cfg *mem_cfg = &fwrt->smem_cfg;
 	u32 file_len, fifo_data_len = 0, prph_len = 0, radio_len = 0;
-	u32 smem_len = fwrt->fw->n_dbg_mem_tlv ? 0 : fwrt->trans->cfg->smem_len;
-	u32 sram2_len = fwrt->fw->n_dbg_mem_tlv ?
+	u32 smem_len = fwrt->fw->dbg.n_mem_tlv ? 0 : fwrt->trans->cfg->smem_len;
+	u32 sram2_len = fwrt->fw->dbg.n_mem_tlv ?
 				0 : fwrt->trans->cfg->dccm2_len;
 	bool monitor_dump_only = false;
 	int i;
@@ -686,7 +686,7 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 	if (test_bit(STATUS_FW_ERROR, &fwrt->trans->status)) {
 		fifo_data_len = 0;
 
-		if (fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_RXF)) {
+		if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_RXF)) {
 
 			/* Count RXF2 size */
 			if (mem_cfg->rxfifo2_size) {
@@ -710,7 +710,7 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 			}
 		}
 
-		if (fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_TXF)) {
+		if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_TXF)) {
 			size_t fifo_const_len = sizeof(*dump_data) +
 				sizeof(struct iwl_fw_error_dump_fifo);
 
@@ -731,7 +731,7 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 			}
 		}
 
-		if ((fwrt->fw->dbg_dump_mask &
+		if ((fwrt->fw->dbg.dump_mask &
 		    BIT(IWL_FW_ERROR_DUMP_INTERNAL_TXF)) &&
 		    fw_has_capa(&fwrt->fw->ucode_capa,
 				IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG)) {
@@ -751,11 +751,11 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 
 		/* Make room for PRPH registers */
 		if (!fwrt->trans->cfg->gen2 &&
-		    fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_PRPH))
+		    fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_PRPH))
 			prph_len += iwl_fw_get_prph_len(fwrt);
 
 		if (fwrt->trans->cfg->device_family == IWL_DEVICE_FAMILY_7000 &&
-		    fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_RADIO_REG))
+		    fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_RADIO_REG))
 			radio_len = sizeof(*dump_data) + RADIO_REG_MAX_READ;
 	}
 
@@ -764,12 +764,12 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 		   prph_len +
 		   radio_len;
 
-	if (fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_DEV_FW_INFO))
+	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_DEV_FW_INFO))
 		file_len += sizeof(*dump_data) + sizeof(*dump_info);
-	if (fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_MEM_CFG))
+	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_MEM_CFG))
 		file_len += sizeof(*dump_data) + sizeof(*dump_smem_cfg);
 
-	if (fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_MEM)) {
+	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_MEM)) {
 		/* Make room for the SMEM, if it exists */
 		if (smem_len)
 			file_len += sizeof(*dump_data) + smem_len +
@@ -781,7 +781,7 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 				sizeof(struct iwl_fw_error_dump_mem);
 
 		/* Make room for MEM segments */
-		for (i = 0; i < fwrt->fw->n_dbg_mem_tlv; i++) {
+		for (i = 0; i < fwrt->fw->dbg.n_mem_tlv; i++) {
 			file_len += sizeof(*dump_data) +
 				le32_to_cpu(fw_dbg_mem[i].len) +
 				sizeof(struct iwl_fw_error_dump_mem);
@@ -789,7 +789,7 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 	}
 
 	/* Make room for fw's virtual image pages, if it exists */
-	if (fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_PAGING) &&
+	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_PAGING) &&
 	    !fwrt->trans->cfg->gen2 &&
 	    fwrt->fw->img[fwrt->cur_fw_img].paging_mem_size &&
 	    fwrt->fw_paging_db[0].fw_paging_block)
@@ -809,13 +809,13 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 			   sizeof(*dump_info) + sizeof(*dump_smem_cfg);
 	}
 
-	if (fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_ERROR_INFO) &&
+	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_ERROR_INFO) &&
 	    fwrt->dump.desc)
 		file_len += sizeof(*dump_data) + sizeof(*dump_trig) +
 			    fwrt->dump.desc->len;
 
-	if (fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_MEM) &&
-	    !fwrt->fw->n_dbg_mem_tlv)
+	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_MEM) &&
+	    !fwrt->fw->dbg.n_mem_tlv)
 		file_len += sizeof(*dump_data) + sram_len +
 			sizeof(struct iwl_fw_error_dump_mem);
 
@@ -830,7 +830,7 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 	dump_file->barker = cpu_to_le32(IWL_FW_ERROR_DUMP_BARKER);
 	dump_data = (void *)dump_file->data;
 
-	if (fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_DEV_FW_INFO)) {
+	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_DEV_FW_INFO)) {
 		dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_DEV_FW_INFO);
 		dump_data->len = cpu_to_le32(sizeof(*dump_info));
 		dump_info = (void *)dump_data->data;
@@ -851,7 +851,7 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 		dump_data = iwl_fw_error_next_data(dump_data);
 	}
 
-	if (fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_MEM_CFG)) {
+	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_MEM_CFG)) {
 		/* Dump shared memory configuration */
 		dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM_CFG);
 		dump_data->len = cpu_to_le32(sizeof(*dump_smem_cfg));
@@ -888,7 +888,7 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 			iwl_read_radio_regs(fwrt, &dump_data);
 	}
 
-	if (fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_ERROR_INFO) &&
+	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_ERROR_INFO) &&
 	    fwrt->dump.desc) {
 		dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_ERROR_INFO);
 		dump_data->len = cpu_to_le32(sizeof(*dump_trig) +
@@ -904,7 +904,7 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 	if (monitor_dump_only)
 		goto dump_trans_data;
 
-	if (fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_MEM))
+	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_MEM))
 		iwl_fw_dump_mem(fwrt, &dump_data, sram_len, sram_ofs, smem_len,
 				sram2_len);
 
@@ -929,7 +929,7 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 	}
 
 	/* Dump fw's virtual image */
-	if (fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_PAGING) &&
+	if (fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_PAGING) &&
 	    !fwrt->trans->cfg->gen2 &&
 	    fwrt->fw->img[fwrt->cur_fw_img].paging_mem_size &&
 	    fwrt->fw_paging_db[0].fw_paging_block) {
@@ -1118,17 +1118,17 @@ int iwl_fw_start_dbg_conf(struct iwl_fw_runtime *fwrt, u8 conf_id)
 	int ret;
 	int i;
 
-	if (WARN_ONCE(conf_id >= ARRAY_SIZE(fwrt->fw->dbg_conf_tlv),
+	if (WARN_ONCE(conf_id >= ARRAY_SIZE(fwrt->fw->dbg.conf_tlv),
 		      "Invalid configuration %d\n", conf_id))
 		return -EINVAL;
 
 	/* EARLY START - firmware's configuration is hard coded */
-	if ((!fwrt->fw->dbg_conf_tlv[conf_id] ||
-	     !fwrt->fw->dbg_conf_tlv[conf_id]->num_of_hcmds) &&
+	if ((!fwrt->fw->dbg.conf_tlv[conf_id] ||
+	     !fwrt->fw->dbg.conf_tlv[conf_id]->num_of_hcmds) &&
 	    conf_id == FW_DBG_START_FROM_ALIVE)
 		return 0;
 
-	if (!fwrt->fw->dbg_conf_tlv[conf_id])
+	if (!fwrt->fw->dbg.conf_tlv[conf_id])
 		return -EINVAL;
 
 	if (fwrt->dump.conf != FW_DBG_INVALID)
@@ -1136,8 +1136,8 @@ int iwl_fw_start_dbg_conf(struct iwl_fw_runtime *fwrt, u8 conf_id)
 			 fwrt->dump.conf);
 
 	/* Send all HCMDs for configuring the FW debug */
-	ptr = (void *)&fwrt->fw->dbg_conf_tlv[conf_id]->hcmd;
-	for (i = 0; i < fwrt->fw->dbg_conf_tlv[conf_id]->num_of_hcmds; i++) {
+	ptr = (void *)&fwrt->fw->dbg.conf_tlv[conf_id]->hcmd;
+	for (i = 0; i < fwrt->fw->dbg.conf_tlv[conf_id]->num_of_hcmds; i++) {
 		struct iwl_fw_dbg_conf_hcmd *cmd = (void *)ptr;
 		struct iwl_host_cmd hcmd = {
 			.id = cmd->id,
@@ -1183,7 +1183,7 @@ void iwl_fw_error_dump_wk(struct work_struct *work)
 
 	/* start recording again if the firmware is not crashed */
 	if (!test_bit(STATUS_FW_ERROR, &fwrt->trans->status) &&
-	    fwrt->fw->dbg_dest_tlv) {
+	    fwrt->fw->dbg.dest_tlv) {
 		/* wait before we collect the data till the DBGC stop */
 		udelay(500);
 		iwl_fw_dbg_restart_recording(fwrt, &params);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index 3c89230fae6a..e1e8a1a03c68 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -118,14 +118,14 @@ int iwl_fw_dbg_collect_trig(struct iwl_fw_runtime *fwrt,
 int iwl_fw_start_dbg_conf(struct iwl_fw_runtime *fwrt, u8 id);
 
 #define iwl_fw_dbg_trigger_enabled(fw, id) ({			\
-	void *__dbg_trigger = (fw)->dbg_trigger_tlv[(id)];	\
+	void *__dbg_trigger = (fw)->dbg.trigger_tlv[(id)];	\
 	unlikely(__dbg_trigger);				\
 })
 
 static inline struct iwl_fw_dbg_trigger_tlv*
 _iwl_fw_dbg_get_trigger(const struct iwl_fw *fw, enum iwl_fw_dbg_trigger id)
 {
-	return fw->dbg_trigger_tlv[id];
+	return fw->dbg.trigger_tlv[id];
 }
 
 #define iwl_fw_dbg_get_trigger(fw, id) ({			\
@@ -293,7 +293,7 @@ static inline bool iwl_fw_dbg_is_d3_debug_enabled(struct iwl_fw_runtime *fwrt)
 	return fw_has_capa(&fwrt->fw->ucode_capa,
 			   IWL_UCODE_TLV_CAPA_D3_DEBUG) &&
 		fwrt->trans->cfg->d3_debug_data_length &&
-		fwrt->fw->dbg_dump_mask & BIT(IWL_FW_ERROR_DUMP_D3_DEBUG_DATA);
+		fwrt->fw->dbg.dump_mask & BIT(IWL_FW_ERROR_DUMP_D3_DEBUG_DATA);
 }
 
 void iwl_fw_dbg_read_d3_debug_data(struct iwl_fw_runtime *fwrt);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/img.h b/drivers/net/wireless/intel/iwlwifi/fw/img.h
index 9cc8fe8908ac..54dbbd998abf 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/img.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/img.h
@@ -197,6 +197,29 @@ enum iwl_fw_type {
 	IWL_FW_MVM,
 };
 
+/**
+ * struct iwl_fw_dbg - debug data
+ *
+ * @dest_tlv: points to debug destination TLV (typically SRAM or DRAM)
+ * @n_dest_reg: num of reg_ops in dest_tlv
+ * @conf_tlv: array of pointers to configuration HCMDs
+ * @trigger_tlv: array of pointers to triggers TLVs
+ * @trigger_tlv_len: lengths of the @dbg_trigger_tlv entries
+ * @mem_tlv: Runtime addresses to dump
+ * @n_mem_tlv: number of runtime addresses
+ * @dump_mask: bitmask of dump regions
+*/
+struct iwl_fw_dbg {
+	struct iwl_fw_dbg_dest_tlv_v1 *dest_tlv;
+	u8 n_dest_reg;
+	struct iwl_fw_dbg_conf_tlv *conf_tlv[FW_DBG_CONF_MAX];
+	struct iwl_fw_dbg_trigger_tlv *trigger_tlv[FW_DBG_TRIGGER_MAX];
+	size_t trigger_tlv_len[FW_DBG_TRIGGER_MAX];
+	struct iwl_fw_dbg_mem_seg_tlv *mem_tlv;
+	size_t n_mem_tlv;
+	u32 dump_mask;
+};
+
 /**
  * struct iwl_fw - variables associated with the firmware
  *
@@ -217,12 +240,6 @@ enum iwl_fw_type {
  * @cipher_scheme: optional external cipher scheme.
  * @human_readable: human readable version
  *	we get the ALIVE from the uCode
- * @dbg_dest_tlv: points to the destination TLV for debug
- * @dbg_conf_tlv: array of pointers to configuration TLVs for debug
- * @dbg_conf_tlv_len: lengths of the @dbg_conf_tlv entries
- * @dbg_trigger_tlv: array of pointers to triggers TLVs
- * @dbg_trigger_tlv_len: lengths of the @dbg_trigger_tlv entries
- * @dbg_dest_reg_num: num of reg_ops in %dbg_dest_tlv
  */
 struct iwl_fw {
 	u32 ucode_ver;
@@ -250,15 +267,7 @@ struct iwl_fw {
 	struct iwl_fw_cipher_scheme cs[IWL_UCODE_MAX_CS];
 	u8 human_readable[FW_VER_HUMAN_READABLE_SZ];
 
-	struct iwl_fw_dbg_dest_tlv_v1 *dbg_dest_tlv;
-	struct iwl_fw_dbg_conf_tlv *dbg_conf_tlv[FW_DBG_CONF_MAX];
-	size_t dbg_conf_tlv_len[FW_DBG_CONF_MAX];
-	struct iwl_fw_dbg_trigger_tlv *dbg_trigger_tlv[FW_DBG_TRIGGER_MAX];
-	struct iwl_fw_dbg_mem_seg_tlv *dbg_mem_tlv;
-	size_t n_dbg_mem_tlv;
-	size_t dbg_trigger_tlv_len[FW_DBG_TRIGGER_MAX];
-	u8 dbg_dest_reg_num;
-	u32 dbg_dump_mask;
+	struct iwl_fw_dbg dbg;
 };
 
 static inline const char *get_fw_dbg_mode_string(int mode)
@@ -280,7 +289,7 @@ static inline const char *get_fw_dbg_mode_string(int mode)
 static inline bool
 iwl_fw_dbg_conf_usniffer(const struct iwl_fw *fw, u8 id)
 {
-	const struct iwl_fw_dbg_conf_tlv *conf_tlv = fw->dbg_conf_tlv[id];
+	const struct iwl_fw_dbg_conf_tlv *conf_tlv = fw->dbg.conf_tlv[id];
 
 	if (!conf_tlv)
 		return false;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index d3a60d1aacb5..809f8daa5c10 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -168,12 +168,12 @@ static void iwl_dealloc_ucode(struct iwl_drv *drv)
 {
 	int i;
 
-	kfree(drv->fw.dbg_dest_tlv);
-	for (i = 0; i < ARRAY_SIZE(drv->fw.dbg_conf_tlv); i++)
-		kfree(drv->fw.dbg_conf_tlv[i]);
-	for (i = 0; i < ARRAY_SIZE(drv->fw.dbg_trigger_tlv); i++)
-		kfree(drv->fw.dbg_trigger_tlv[i]);
-	kfree(drv->fw.dbg_mem_tlv);
+	kfree(drv->fw.dbg.dest_tlv);
+	for (i = 0; i < ARRAY_SIZE(drv->fw.dbg.conf_tlv); i++)
+		kfree(drv->fw.dbg.conf_tlv[i]);
+	for (i = 0; i < ARRAY_SIZE(drv->fw.dbg.trigger_tlv); i++)
+		kfree(drv->fw.dbg.trigger_tlv[i]);
+	kfree(drv->fw.dbg.mem_tlv);
 	kfree(drv->fw.iml);
 
 	for (i = 0; i < IWL_UCODE_TYPE_MAX; i++)
@@ -303,7 +303,7 @@ struct iwl_firmware_pieces {
 	struct iwl_fw_dbg_trigger_tlv *dbg_trigger_tlv[FW_DBG_TRIGGER_MAX];
 	size_t dbg_trigger_tlv_len[FW_DBG_TRIGGER_MAX];
 	struct iwl_fw_dbg_mem_seg_tlv *dbg_mem_tlv;
-	size_t n_dbg_mem_tlv;
+	size_t n_mem_tlv;
 };
 
 /*
@@ -936,7 +936,7 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 			IWL_INFO(drv, "Found debug destination: %s\n",
 				 get_fw_dbg_mode_string(mon_mode));
 
-			drv->fw.dbg_dest_reg_num = (dest_v1) ?
+			drv->fw.dbg.n_dest_reg = (dest_v1) ?
 				tlv_len -
 				offsetof(struct iwl_fw_dbg_dest_tlv_v1,
 					 reg_ops) :
@@ -944,8 +944,8 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 				offsetof(struct iwl_fw_dbg_dest_tlv,
 					 reg_ops);
 
-			drv->fw.dbg_dest_reg_num /=
-				sizeof(drv->fw.dbg_dest_tlv->reg_ops[0]);
+			drv->fw.dbg.n_dest_reg /=
+				sizeof(drv->fw.dbg.dest_tlv->reg_ops[0]);
 
 			break;
 			}
@@ -959,7 +959,7 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 				break;
 			}
 
-			if (conf->id >= ARRAY_SIZE(drv->fw.dbg_conf_tlv)) {
+			if (conf->id >= ARRAY_SIZE(drv->fw.dbg.conf_tlv)) {
 				IWL_ERR(drv,
 					"Skip unknown configuration: %d\n",
 					conf->id);
@@ -988,7 +988,7 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 				(void *)tlv_data;
 			u32 trigger_id = le32_to_cpu(trigger->id);
 
-			if (trigger_id >= ARRAY_SIZE(drv->fw.dbg_trigger_tlv)) {
+			if (trigger_id >= ARRAY_SIZE(drv->fw.dbg.trigger_tlv)) {
 				IWL_ERR(drv,
 					"Skip unknown trigger: %u\n",
 					trigger->id);
@@ -1015,7 +1015,7 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 				break;
 			}
 
-			drv->fw.dbg_dump_mask =
+			drv->fw.dbg.dump_mask =
 				le32_to_cpup((__le32 *)tlv_data);
 			break;
 			}
@@ -1070,13 +1070,13 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 				       dbg_mem->data_type);
 
 			size = sizeof(*pieces->dbg_mem_tlv) *
-			       (pieces->n_dbg_mem_tlv + 1);
+			       (pieces->n_mem_tlv + 1);
 			n = krealloc(pieces->dbg_mem_tlv, size, GFP_KERNEL);
 			if (!n)
 				return -ENOMEM;
 			pieces->dbg_mem_tlv = n;
-			pieces->dbg_mem_tlv[pieces->n_dbg_mem_tlv] = *dbg_mem;
-			pieces->n_dbg_mem_tlv++;
+			pieces->dbg_mem_tlv[pieces->n_mem_tlv] = *dbg_mem;
+			pieces->n_mem_tlv++;
 			break;
 			}
 		case IWL_UCODE_TLV_IML: {
@@ -1256,7 +1256,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 			IWL_DEFAULT_STANDARD_PHY_CALIBRATE_TBL_SIZE;
 	fw->ucode_capa.n_scan_channels = IWL_DEFAULT_SCAN_CHANNELS;
 	/* dump all fw memory areas by default except d3 debug data */
-	fw->dbg_dump_mask = 0xfffdffff;
+	fw->dbg.dump_mask = 0xfffdffff;
 
 	pieces = kzalloc(sizeof(*pieces), GFP_KERNEL);
 	if (!pieces)
@@ -1323,21 +1323,21 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 			goto out_free_fw;
 
 	if (pieces->dbg_dest_tlv_init) {
-		size_t dbg_dest_size = sizeof(*drv->fw.dbg_dest_tlv) +
-			sizeof(drv->fw.dbg_dest_tlv->reg_ops[0]) *
-			drv->fw.dbg_dest_reg_num;
+		size_t dbg_dest_size = sizeof(*drv->fw.dbg.dest_tlv) +
+			sizeof(drv->fw.dbg.dest_tlv->reg_ops[0]) *
+			drv->fw.dbg.n_dest_reg;
 
-		drv->fw.dbg_dest_tlv = kmalloc(dbg_dest_size, GFP_KERNEL);
+		drv->fw.dbg.dest_tlv = kmalloc(dbg_dest_size, GFP_KERNEL);
 
-		if (!drv->fw.dbg_dest_tlv)
+		if (!drv->fw.dbg.dest_tlv)
 			goto out_free_fw;
 
 		if (*pieces->dbg_dest_ver == 0) {
-			memcpy(drv->fw.dbg_dest_tlv, pieces->dbg_dest_tlv_v1,
+			memcpy(drv->fw.dbg.dest_tlv, pieces->dbg_dest_tlv_v1,
 			       dbg_dest_size);
 		} else {
 			struct iwl_fw_dbg_dest_tlv_v1 *dest_tlv =
-				drv->fw.dbg_dest_tlv;
+				drv->fw.dbg.dest_tlv;
 
 			dest_tlv->version = pieces->dbg_dest_tlv->version;
 			dest_tlv->monitor_mode =
@@ -1352,8 +1352,8 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 				pieces->dbg_dest_tlv->base_shift;
 			memcpy(dest_tlv->reg_ops,
 			       pieces->dbg_dest_tlv->reg_ops,
-			       sizeof(drv->fw.dbg_dest_tlv->reg_ops[0]) *
-			       drv->fw.dbg_dest_reg_num);
+			       sizeof(drv->fw.dbg.dest_tlv->reg_ops[0]) *
+			       drv->fw.dbg.n_dest_reg);
 
 			/* In version 1 of the destination tlv, which is
 			 * relevant for internal buffer exclusively,
@@ -1369,15 +1369,13 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 		}
 	}
 
-	for (i = 0; i < ARRAY_SIZE(drv->fw.dbg_conf_tlv); i++) {
+	for (i = 0; i < ARRAY_SIZE(drv->fw.dbg.conf_tlv); i++) {
 		if (pieces->dbg_conf_tlv[i]) {
-			drv->fw.dbg_conf_tlv_len[i] =
-				pieces->dbg_conf_tlv_len[i];
-			drv->fw.dbg_conf_tlv[i] =
+			drv->fw.dbg.conf_tlv[i] =
 				kmemdup(pieces->dbg_conf_tlv[i],
-					drv->fw.dbg_conf_tlv_len[i],
+					pieces->dbg_conf_tlv_len[i],
 					GFP_KERNEL);
-			if (!drv->fw.dbg_conf_tlv[i])
+			if (!pieces->dbg_conf_tlv_len[i])
 				goto out_free_fw;
 		}
 	}
@@ -1404,7 +1402,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	trigger_tlv_sz[FW_DBG_TRIGGER_TDLS] =
 		sizeof(struct iwl_fw_dbg_trigger_tdls);
 
-	for (i = 0; i < ARRAY_SIZE(drv->fw.dbg_trigger_tlv); i++) {
+	for (i = 0; i < ARRAY_SIZE(drv->fw.dbg.trigger_tlv); i++) {
 		if (pieces->dbg_trigger_tlv[i]) {
 			/*
 			 * If the trigger isn't long enough, WARN and exit.
@@ -1417,22 +1415,22 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 				    (trigger_tlv_sz[i] +
 				     sizeof(struct iwl_fw_dbg_trigger_tlv))))
 				goto out_free_fw;
-			drv->fw.dbg_trigger_tlv_len[i] =
+			drv->fw.dbg.trigger_tlv_len[i] =
 				pieces->dbg_trigger_tlv_len[i];
-			drv->fw.dbg_trigger_tlv[i] =
+			drv->fw.dbg.trigger_tlv[i] =
 				kmemdup(pieces->dbg_trigger_tlv[i],
-					drv->fw.dbg_trigger_tlv_len[i],
+					drv->fw.dbg.trigger_tlv_len[i],
 					GFP_KERNEL);
-			if (!drv->fw.dbg_trigger_tlv[i])
+			if (!drv->fw.dbg.trigger_tlv[i])
 				goto out_free_fw;
 		}
 	}
 
 	/* Now that we can no longer fail, copy information */
 
-	drv->fw.dbg_mem_tlv = pieces->dbg_mem_tlv;
+	drv->fw.dbg.mem_tlv = pieces->dbg_mem_tlv;
 	pieces->dbg_mem_tlv = NULL;
-	drv->fw.n_dbg_mem_tlv = pieces->n_dbg_mem_tlv;
+	drv->fw.dbg.n_mem_tlv = pieces->n_mem_tlv;
 
 	/*
 	 * The (size - 16) / 12 formula is based on the information recorded
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 6c636b2a6b43..26b3c73051ca 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -725,7 +725,7 @@ struct iwl_dram_data {
  * @dbg_dest_tlv: points to the destination TLV for debug
  * @dbg_conf_tlv: array of pointers to configuration TLVs for debug
  * @dbg_trigger_tlv: array of pointers to triggers TLVs for debug
- * @dbg_dest_reg_num: num of reg_ops in %dbg_dest_tlv
+ * @dbg_n_dest_reg: num of reg_ops in %dbg_dest_tlv
  * @num_blocks: number of blocks in fw_mon
  * @fw_mon: address of the buffers for firmware monitor
  * @system_pm_mode: the system-wide power management mode in use.
@@ -778,7 +778,7 @@ struct iwl_trans {
 	const struct iwl_fw_dbg_conf_tlv *dbg_conf_tlv[FW_DBG_CONF_MAX];
 	struct iwl_fw_dbg_trigger_tlv * const *dbg_trigger_tlv;
 	u32 dbg_dump_mask;
-	u8 dbg_dest_reg_num;
+	u8 dbg_n_dest_reg;
 	int num_blocks;
 	struct iwl_dram_data fw_mon[IWL_MAX_DEBUG_ALLOCATIONS];
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 5020cc707142..3fee304cddbb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1026,7 +1026,7 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 
 	mvm->fwrt.dump.conf = FW_DBG_INVALID;
 	/* if we have a destination, assume EARLY START */
-	if (mvm->fw->dbg_dest_tlv)
+	if (mvm->fw->dbg.dest_tlv)
 		mvm->fwrt.dump.conf = FW_DBG_START_FROM_ALIVE;
 	iwl_fw_start_dbg_conf(&mvm->fwrt, FW_DBG_START_FROM_ALIVE);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 0599d323cbeb..5f2f599a7ccd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -748,12 +748,12 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	iwl_trans_configure(mvm->trans, &trans_cfg);
 
 	trans->rx_mpdu_cmd = REPLY_RX_MPDU_CMD;
-	trans->dbg_dest_tlv = mvm->fw->dbg_dest_tlv;
-	trans->dbg_dest_reg_num = mvm->fw->dbg_dest_reg_num;
-	memcpy(trans->dbg_conf_tlv, mvm->fw->dbg_conf_tlv,
+	trans->dbg_dest_tlv = mvm->fw->dbg.dest_tlv;
+	trans->dbg_n_dest_reg = mvm->fw->dbg.n_dest_reg;
+	memcpy(trans->dbg_conf_tlv, mvm->fw->dbg.conf_tlv,
 	       sizeof(trans->dbg_conf_tlv));
-	trans->dbg_trigger_tlv = mvm->fw->dbg_trigger_tlv;
-	trans->dbg_dump_mask = mvm->fw->dbg_dump_mask;
+	trans->dbg_trigger_tlv = mvm->fw->dbg.trigger_tlv;
+	trans->dbg_dump_mask = mvm->fw->dbg.dump_mask;
 
 	trans->iml = mvm->fw->iml;
 	trans->iml_len = mvm->fw->iml_len;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index bc6682a11fa4..5bafb3f46eb8 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -931,7 +931,7 @@ void iwl_pcie_apply_destination(struct iwl_trans *trans)
 	else
 		IWL_WARN(trans, "PCI should have external buffer debug\n");
 
-	for (i = 0; i < trans->dbg_dest_reg_num; i++) {
+	for (i = 0; i < trans->dbg_n_dest_reg; i++) {
 		u32 addr = le32_to_cpu(dest->reg_ops[i].addr);
 		u32 val = le32_to_cpu(dest->reg_ops[i].val);
 
-- 
2.19.0

