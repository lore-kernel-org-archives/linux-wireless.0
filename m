Return-Path: <SRS0=iPli=OC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AED6C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:26:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB8E7206B2
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:26:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB8E7206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394374AbeKWWKd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 23 Nov 2018 17:10:33 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:38240 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388128AbeKWWKd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Nov 2018 17:10:33 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gQ9bZ-0008GU-Lu; Fri, 23 Nov 2018 13:26:38 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 23 Nov 2018 13:26:18 +0200
Message-Id: <20181123112631.29360-3-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181123112631.29360-1-luca@coelho.fi>
References: <20181123112631.29360-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 02/15] iwlwifi: dbg: dump data according to the new ini TLVs
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

When ini TLVs are loaded, dump data according to the
stored configuration.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 263 +++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   |   2 +-
 .../wireless/intel/iwlwifi/fw/error-dump.h    |  17 ++
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h |   6 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   |  12 +-
 .../intel/iwlwifi/pcie/ctxt-info-gen3.c       |  13 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info.c   |   2 +-
 .../wireless/intel/iwlwifi/pcie/internal.h    |   5 +
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |  71 +++--
 9 files changed, 355 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 76050cc3532a..58771e253396 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -605,6 +605,28 @@ static void iwl_fw_dump_mem(struct iwl_fw_runtime *fwrt,
 	IWL_DEBUG_INFO(fwrt, "WRT memory dump. Type=%u\n", dump_mem->type);
 }
 
+static void iwl_fw_dump_named_mem(struct iwl_fw_runtime *fwrt,
+				  struct iwl_fw_error_dump_data **dump_data,
+				  u32 len, u32 ofs, u8 *name, u8 name_len)
+{
+	struct iwl_fw_error_dump_named_mem *dump_mem;
+
+	if (!len)
+		return;
+
+	(*dump_data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
+	(*dump_data)->len = cpu_to_le32(len + sizeof(*dump_mem));
+	dump_mem = (void *)(*dump_data)->data;
+	dump_mem->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM_NAMED_MEM);
+	dump_mem->offset = cpu_to_le32(ofs);
+	dump_mem->name_len = name_len;
+	memcpy(dump_mem->name, name, name_len);
+	iwl_trans_read_mem_bytes(fwrt->trans, ofs, dump_mem->data, len);
+	*dump_data = iwl_fw_error_next_data(*dump_data);
+
+	IWL_DEBUG_INFO(fwrt, "WRT memory dump. Type=%u\n", dump_mem->type);
+}
+
 #define ADD_LEN(len, item_len, const_len) \
 	do {size_t item = item_len; len += (!!item) * const_len + item; } \
 	while (0)
@@ -928,6 +950,238 @@ _iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
 	return dump_file;
 }
 
+static void iwl_dump_prph_ini(struct iwl_trans *trans,
+			      struct iwl_fw_error_dump_data **data,
+			      struct iwl_fw_ini_region_cfg *reg)
+{
+	struct iwl_fw_error_dump_prph *prph;
+	unsigned long flags;
+	u32 i, size = le32_to_cpu(reg->num_regions);
+
+	IWL_DEBUG_INFO(trans, "WRT PRPH dump\n");
+
+	if (!iwl_trans_grab_nic_access(trans, &flags))
+		return;
+
+	for (i = 0; i < size; i++) {
+		(*data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_PRPH);
+		(*data)->len = cpu_to_le32(le32_to_cpu(reg->size) +
+					   sizeof(*prph));
+		prph = (void *)(*data)->data;
+		prph->prph_start = reg->start_addr[i];
+		prph->data[0] = cpu_to_le32(iwl_read_prph_no_grab(trans,
+								  le32_to_cpu(prph->prph_start)));
+		*data = iwl_fw_error_next_data(*data);
+	}
+	iwl_trans_release_nic_access(trans, &flags);
+}
+
+static void iwl_dump_csr_ini(struct iwl_trans *trans,
+			     struct iwl_fw_error_dump_data **data,
+			     struct iwl_fw_ini_region_cfg *reg)
+{
+	int i, num = le32_to_cpu(reg->num_regions);
+	u32 size = le32_to_cpu(reg->size);
+
+	IWL_DEBUG_INFO(trans, "WRT CSR dump\n");
+
+	for (i = 0; i < num; i++) {
+		u32 add = le32_to_cpu(reg->start_addr[i]);
+		__le32 *val;
+		int j;
+
+		(*data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_CSR);
+		(*data)->len = cpu_to_le32(size);
+		val = (void *)(*data)->data;
+
+		for (j = 0; j < size; j += 4)
+			*val++ = cpu_to_le32(iwl_trans_read32(trans, j + add));
+
+		*data = iwl_fw_error_next_data(*data);
+	}
+}
+
+static int iwl_fw_ini_get_trigger_len(struct iwl_fw_runtime *fwrt,
+				      struct iwl_fw_ini_trigger *trigger)
+{
+	int i, num, size = 0, hdr_len = sizeof(struct iwl_fw_error_dump_data);
+
+	if (!trigger || !trigger->num_regions)
+		return 0;
+
+	num = le32_to_cpu(trigger->num_regions);
+	for (i = 0; i < num; i++) {
+		u32 reg_id = le32_to_cpu(trigger->data[i]);
+		struct iwl_fw_ini_region_cfg *reg;
+		enum iwl_fw_ini_region_type type;
+		u32 num_entries;
+
+		if (WARN_ON(reg_id >= ARRAY_SIZE(fwrt->dump.active_regs)))
+			continue;
+
+		reg = fwrt->dump.active_regs[reg_id].reg;
+		if (WARN(!reg, "Unassigned region %d\n", reg_id))
+			continue;
+
+		type = le32_to_cpu(reg->region_type);
+		num_entries = le32_to_cpu(reg->num_regions);
+
+		switch (type) {
+		case IWL_FW_INI_REGION_DEVICE_MEMORY:
+			size += hdr_len +
+				sizeof(struct iwl_fw_error_dump_named_mem) +
+				le32_to_cpu(reg->size);
+			break;
+		case IWL_FW_INI_REGION_PERIPHERY_MAC:
+		case IWL_FW_INI_REGION_PERIPHERY_PHY:
+		case IWL_FW_INI_REGION_PERIPHERY_AUX:
+			size += num_entries *
+				(hdr_len +
+				 sizeof(struct iwl_fw_error_dump_prph) +
+				 sizeof(u32));
+			break;
+		case IWL_FW_INI_REGION_TXF:
+			size += iwl_fw_txf_len(fwrt, &fwrt->smem_cfg);
+			break;
+		case IWL_FW_INI_REGION_RXF:
+			size += iwl_fw_rxf_len(fwrt, &fwrt->smem_cfg);
+			break;
+		case IWL_FW_INI_REGION_PAGING:
+			if (!iwl_fw_dbg_is_paging_enabled(fwrt))
+				break;
+			size += fwrt->num_of_paging_blk *
+				(hdr_len +
+				 sizeof(struct iwl_fw_error_dump_paging) +
+				 PAGING_BLOCK_SIZE);
+			break;
+		case IWL_FW_INI_REGION_CSR:
+			size += num_entries *
+				(hdr_len + le32_to_cpu(reg->size));
+			break;
+		case IWL_FW_INI_REGION_DRAM_BUFFER:
+			/* Transport takes care of DRAM dumping */
+		case IWL_FW_INI_REGION_INTERNAL_BUFFER:
+		case IWL_FW_INI_REGION_DRAM_IMR:
+			/* Undefined yet */
+		default:
+			break;
+		}
+	}
+	return size;
+}
+
+static void iwl_fw_ini_dump_trigger(struct iwl_fw_runtime *fwrt,
+				    struct iwl_fw_ini_trigger *trigger,
+				    struct iwl_fw_error_dump_data **data,
+				    u32 *dump_mask)
+{
+	int i, num = le32_to_cpu(trigger->num_regions);
+
+	for (i = 0; i < num; i++) {
+		u32 reg_id = le32_to_cpu(trigger->data[i]);
+		enum iwl_fw_ini_region_type type;
+		struct iwl_fw_ini_region_cfg *reg;
+
+		if (reg_id >= ARRAY_SIZE(fwrt->dump.active_regs))
+			continue;
+
+		reg = fwrt->dump.active_regs[reg_id].reg;
+		/* Don't warn, get_trigger_len already warned */
+		if (!reg)
+			continue;
+
+		type = le32_to_cpu(reg->region_type);
+		switch (type) {
+		case IWL_FW_INI_REGION_DEVICE_MEMORY:
+			if (WARN_ON(le32_to_cpu(reg->num_regions) > 1))
+				continue;
+			iwl_fw_dump_named_mem(fwrt, data,
+					      le32_to_cpu(reg->size),
+					      le32_to_cpu(reg->start_addr[0]),
+					      reg->name,
+					      le32_to_cpu(reg->name_len));
+			break;
+		case IWL_FW_INI_REGION_PERIPHERY_MAC:
+		case IWL_FW_INI_REGION_PERIPHERY_PHY:
+		case IWL_FW_INI_REGION_PERIPHERY_AUX:
+			iwl_dump_prph_ini(fwrt->trans, data, reg);
+			break;
+		case IWL_FW_INI_REGION_DRAM_BUFFER:
+			*dump_mask |= IWL_FW_ERROR_DUMP_FW_MONITOR;
+			break;
+		case IWL_FW_INI_REGION_PAGING:
+			if (iwl_fw_dbg_is_paging_enabled(fwrt))
+				iwl_dump_paging(fwrt, data);
+			else
+				*dump_mask |= IWL_FW_ERROR_DUMP_PAGING;
+			break;
+		case IWL_FW_INI_REGION_TXF:
+			iwl_fw_dump_txf(fwrt, data);
+			break;
+		case IWL_FW_INI_REGION_RXF:
+			iwl_fw_dump_rxf(fwrt, data);
+			break;
+		case IWL_FW_INI_REGION_CSR:
+			iwl_dump_csr_ini(fwrt->trans, data, reg);
+			break;
+		case IWL_FW_INI_REGION_DRAM_IMR:
+		case IWL_FW_INI_REGION_INTERNAL_BUFFER:
+			/* This is undefined yet */
+		default:
+			break;
+		}
+	}
+}
+
+static struct iwl_fw_error_dump_file *
+_iwl_fw_error_ini_dump(struct iwl_fw_runtime *fwrt,
+		       struct iwl_fw_dump_ptrs *fw_error_dump,
+		       u32 *dump_mask)
+{
+	int size, id = le32_to_cpu(fwrt->dump.desc->trig_desc.type);
+	struct iwl_fw_error_dump_data *dump_data;
+	struct iwl_fw_error_dump_file *dump_file;
+	struct iwl_fw_ini_trigger *trigger, *ext;
+
+	if (id == FW_DBG_TRIGGER_FW_ASSERT)
+		id = IWL_FW_TRIGGER_ID_FW_ASSERT;
+	else if (id == FW_DBG_TRIGGER_USER)
+		id = IWL_FW_TRIGGER_ID_USER_TRIGGER;
+	else if (id < FW_DBG_TRIGGER_MAX)
+		return NULL;
+
+	if (WARN_ON(id >= ARRAY_SIZE(fwrt->dump.active_trigs)))
+		return NULL;
+
+	trigger = fwrt->dump.active_trigs[id].conf;
+	ext = fwrt->dump.active_trigs[id].conf_ext;
+
+	size = sizeof(*dump_file);
+	size += iwl_fw_ini_get_trigger_len(fwrt, trigger);
+	size += iwl_fw_ini_get_trigger_len(fwrt, ext);
+
+	if (!size)
+		return NULL;
+
+	dump_file = vzalloc(size);
+	if (!dump_file)
+		return NULL;
+
+	fw_error_dump->fwrt_ptr = dump_file;
+
+	dump_file->barker = cpu_to_le32(IWL_FW_ERROR_DUMP_BARKER);
+	dump_data = (void *)dump_file->data;
+	dump_file->file_len = cpu_to_le32(size);
+
+	*dump_mask = 0;
+	if (trigger)
+		iwl_fw_ini_dump_trigger(fwrt, trigger, &dump_data, dump_mask);
+	if (ext)
+		iwl_fw_ini_dump_trigger(fwrt, ext, &dump_data, dump_mask);
+
+	return dump_file;
+}
+
 void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 {
 	struct iwl_fw_dump_ptrs *fw_error_dump;
@@ -948,13 +1202,18 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 	if (!fw_error_dump)
 		goto out;
 
-	dump_file = _iwl_fw_error_dump(fwrt, fw_error_dump);
+	if (fwrt->trans->ini_valid)
+		dump_file = _iwl_fw_error_ini_dump(fwrt, fw_error_dump,
+						   &dump_mask);
+	else
+		dump_file = _iwl_fw_error_dump(fwrt, fw_error_dump);
+
 	if (!dump_file) {
 		kfree(fw_error_dump);
 		goto out;
 	}
 
-	if (fwrt->dump.monitor_only)
+	if (!fwrt->trans->ini_valid && fwrt->dump.monitor_only)
 		dump_mask &= IWL_FW_ERROR_DUMP_FW_MONITOR;
 
 	fw_error_dump->trans_ptr = iwl_trans_dump_data(fwrt->trans, dump_mask);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index ab81ea8b636f..324ee063224d 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -329,7 +329,7 @@ void iwl_fw_error_dump_wk(struct work_struct *work);
 
 static inline bool iwl_fw_dbg_type_on(struct iwl_fw_runtime *fwrt, u32 type)
 {
-	return (fwrt->fw->dbg.dump_mask & BIT(type));
+	return (fwrt->fw->dbg.dump_mask & BIT(type) || fwrt->trans->ini_valid);
 }
 
 static inline bool iwl_fw_dbg_is_d3_debug_enabled(struct iwl_fw_runtime *fwrt)
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
index 6fede174c664..cefafc9a082f 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
@@ -249,6 +249,7 @@ struct iwl_fw_error_dump_prph {
 enum iwl_fw_error_dump_mem_type {
 	IWL_FW_ERROR_DUMP_MEM_SRAM,
 	IWL_FW_ERROR_DUMP_MEM_SMEM,
+	IWL_FW_ERROR_DUMP_MEM_NAMED_MEM = 10,
 };
 
 /**
@@ -263,6 +264,22 @@ struct iwl_fw_error_dump_mem {
 	u8 data[];
 };
 
+/**
+ * struct iwl_fw_error_dump_named_mem - chunk of memory
+ * @type: &enum iwl_fw_error_dump_mem_type
+ * @offset: the offset from which the memory was read
+ * @name_len: name length
+ * @name: file name
+ * @data: the content of the memory
+ */
+struct iwl_fw_error_dump_named_mem {
+	__le32 type;
+	__le32 offset;
+	u8 name_len;
+	u8 name[32];
+	u8 data[];
+};
+
 /**
  * struct iwl_fw_error_dump_rb - content of an Receive Buffer
  * @index: the index of the Receive Buffer in the Rx queue
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
index 2084c63dc670..9d89b7d7f9fa 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
@@ -362,6 +362,12 @@
 #define MON_BUFF_END_ADDR		(0xa03c40)
 #define MON_BUFF_WRPTR			(0xa03c44)
 #define MON_BUFF_CYCLE_CNT		(0xa03c48)
+/* FW monitor family 8000 and on */
+#define MON_BUFF_BASE_ADDR_VER2		(0xa03c3c)
+#define MON_BUFF_END_ADDR_VER2		(0xa03c20)
+#define MON_BUFF_WRPTR_VER2		(0xa03c24)
+#define MON_BUFF_CYCLE_CNT_VER2		(0xa03c28)
+#define MON_BUFF_SHIFT_VER2		(0x8)
 
 #define MON_DMARB_RD_CTL_ADDR		(0xa03c60)
 #define MON_DMARB_RD_DATA_ADDR		(0xa03c5c)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 263b03b3ea66..c55abc186a2e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1038,11 +1038,13 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	if (ret)
 		IWL_ERR(mvm, "Failed to initialize Smart Fifo\n");
 
-	mvm->fwrt.dump.conf = FW_DBG_INVALID;
-	/* if we have a destination, assume EARLY START */
-	if (mvm->fw->dbg.dest_tlv)
-		mvm->fwrt.dump.conf = FW_DBG_START_FROM_ALIVE;
-	iwl_fw_start_dbg_conf(&mvm->fwrt, FW_DBG_START_FROM_ALIVE);
+	if (!mvm->trans->ini_valid) {
+		mvm->fwrt.dump.conf = FW_DBG_INVALID;
+		/* if we have a destination, assume EARLY START */
+		if (mvm->fw->dbg.dest_tlv)
+			mvm->fwrt.dump.conf = FW_DBG_START_FROM_ALIVE;
+		iwl_fw_start_dbg_conf(&mvm->fwrt, FW_DBG_START_FROM_ALIVE);
+	}
 
 	ret = iwl_send_tx_ant_cfg(mvm, iwl_mvm_get_valid_tx_ant(mvm));
 	if (ret)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
index 05ed4fb88e0c..ceb3aa03d561 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
@@ -94,11 +94,14 @@ int iwl_pcie_ctxt_info_gen3_init(struct iwl_trans *trans,
 		cpu_to_le64(trans_pcie->rxq->bd_dma);
 
 	/* Configure debug, for integration */
-	iwl_pcie_alloc_fw_monitor(trans, 0);
-	prph_sc_ctrl->hwm_cfg.hwm_base_addr =
-		cpu_to_le64(trans->fw_mon[0].physical);
-	prph_sc_ctrl->hwm_cfg.hwm_size =
-		cpu_to_le32(trans->fw_mon[0].size);
+	if (!trans->ini_valid)
+		iwl_pcie_alloc_fw_monitor(trans, 0);
+	if (trans->num_blocks) {
+		prph_sc_ctrl->hwm_cfg.hwm_base_addr =
+			cpu_to_le64(trans->fw_mon[0].physical);
+		prph_sc_ctrl->hwm_cfg.hwm_size =
+			cpu_to_le32(trans->fw_mon[0].size);
+	}
 
 	/* allocate ucode sections in dram and set addresses */
 	ret = iwl_pcie_init_fw_sec(trans, fw, &prph_scratch->dram);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
index 6f45a0303ddd..7f4aaa810ea1 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
@@ -227,7 +227,7 @@ int iwl_pcie_ctxt_info_init(struct iwl_trans *trans,
 	iwl_enable_interrupts(trans);
 
 	/* Configure debug, if exists */
-	if (trans->dbg_dest_tlv)
+	if (iwl_pcie_dbg_on(trans))
 		iwl_pcie_apply_destination(trans);
 
 	/* kick FW self load */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 0f816761ca45..d6fc6ce73e0a 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -1009,6 +1009,11 @@ static inline void __iwl_trans_pcie_set_bit(struct iwl_trans *trans,
 	__iwl_trans_pcie_set_bits_mask(trans, reg, mask, mask);
 }
 
+static inline bool iwl_pcie_dbg_on(struct iwl_trans *trans)
+{
+	return (trans->dbg_dest_tlv || trans->ini_valid);
+}
+
 void iwl_trans_pcie_rf_kill(struct iwl_trans *trans, bool state);
 void iwl_trans_pcie_dump_regs(struct iwl_trans *trans);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 166bacc5ea54..f97aea5ffc44 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -924,6 +924,20 @@ void iwl_pcie_apply_destination(struct iwl_trans *trans)
 	const struct iwl_fw_dbg_dest_tlv_v1 *dest = trans->dbg_dest_tlv;
 	int i;
 
+	if (trans->ini_valid) {
+		if (!trans->num_blocks)
+			return;
+
+		iwl_write_prph(trans, MON_BUFF_BASE_ADDR_VER2,
+			       trans->fw_mon[0].physical >>
+			       MON_BUFF_SHIFT_VER2);
+		iwl_write_prph(trans, MON_BUFF_END_ADDR_VER2,
+			       (trans->fw_mon[0].physical +
+				trans->fw_mon[0].size - 256) >>
+			       MON_BUFF_SHIFT_VER2);
+		return;
+	}
+
 	IWL_INFO(trans, "Applying debug destination %s\n",
 		 get_fw_dbg_mode_string(dest->monitor_mode));
 
@@ -1026,7 +1040,7 @@ static int iwl_pcie_load_given_ucode(struct iwl_trans *trans,
 				       (trans->fw_mon[0].physical +
 					trans->fw_mon[0].size) >> 4);
 		}
-	} else if (trans->dbg_dest_tlv) {
+	} else if (iwl_pcie_dbg_on(trans)) {
 		iwl_pcie_apply_destination(trans);
 	}
 
@@ -1047,7 +1061,7 @@ static int iwl_pcie_load_given_ucode_8000(struct iwl_trans *trans,
 	IWL_DEBUG_FW(trans, "working with %s CPU\n",
 		     image->is_dual_cpus ? "Dual" : "Single");
 
-	if (trans->dbg_dest_tlv)
+	if (iwl_pcie_dbg_on(trans))
 		iwl_pcie_apply_destination(trans);
 
 	IWL_DEBUG_POWER(trans, "Original WFPM value = 0x%08X\n",
@@ -3015,6 +3029,34 @@ iwl_trans_pci_dump_marbh_monitor(struct iwl_trans *trans,
 	return monitor_len;
 }
 
+static void
+iwl_trans_pcie_dump_pointers(struct iwl_trans *trans,
+			     struct iwl_fw_error_dump_fw_mon *fw_mon_data)
+{
+	u32 base, write_ptr, wrap_cnt;
+
+	/* If there was a dest TLV - use the values from there */
+	if (trans->ini_valid) {
+		base = MON_BUFF_BASE_ADDR_VER2;
+		write_ptr = MON_BUFF_WRPTR_VER2;
+		wrap_cnt = MON_BUFF_CYCLE_CNT_VER2;
+	} else if (trans->dbg_dest_tlv) {
+		write_ptr = le32_to_cpu(trans->dbg_dest_tlv->write_ptr_reg);
+		wrap_cnt = le32_to_cpu(trans->dbg_dest_tlv->wrap_count);
+		base = le32_to_cpu(trans->dbg_dest_tlv->base_reg);
+	} else {
+		base = MON_BUFF_BASE_ADDR;
+		write_ptr = MON_BUFF_WRPTR;
+		wrap_cnt = MON_BUFF_CYCLE_CNT;
+	}
+	fw_mon_data->fw_mon_wr_ptr =
+		cpu_to_le32(iwl_read_prph(trans, write_ptr));
+	fw_mon_data->fw_mon_cycle_cnt =
+		cpu_to_le32(iwl_read_prph(trans, wrap_cnt));
+	fw_mon_data->fw_mon_base_ptr =
+		cpu_to_le32(iwl_read_prph(trans, base));
+}
+
 static u32
 iwl_trans_pcie_dump_monitor(struct iwl_trans *trans,
 			    struct iwl_fw_error_dump_data **data,
@@ -3024,30 +3066,14 @@ iwl_trans_pcie_dump_monitor(struct iwl_trans *trans,
 
 	if ((trans->num_blocks &&
 	     trans->cfg->device_family == IWL_DEVICE_FAMILY_7000) ||
-	    trans->dbg_dest_tlv) {
+	     (trans->dbg_dest_tlv && !trans->ini_valid) ||
+	     (trans->ini_valid && trans->num_blocks)) {
 		struct iwl_fw_error_dump_fw_mon *fw_mon_data;
-		u32 base, write_ptr, wrap_cnt;
-
-		/* If there was a dest TLV - use the values from there */
-		if (trans->dbg_dest_tlv) {
-			write_ptr =
-				le32_to_cpu(trans->dbg_dest_tlv->write_ptr_reg);
-			wrap_cnt = le32_to_cpu(trans->dbg_dest_tlv->wrap_count);
-			base = le32_to_cpu(trans->dbg_dest_tlv->base_reg);
-		} else {
-			base = MON_BUFF_BASE_ADDR;
-			write_ptr = MON_BUFF_WRPTR;
-			wrap_cnt = MON_BUFF_CYCLE_CNT;
-		}
 
 		(*data)->type = cpu_to_le32(IWL_FW_ERROR_DUMP_FW_MONITOR);
 		fw_mon_data = (void *)(*data)->data;
-		fw_mon_data->fw_mon_wr_ptr =
-			cpu_to_le32(iwl_read_prph(trans, write_ptr));
-		fw_mon_data->fw_mon_cycle_cnt =
-			cpu_to_le32(iwl_read_prph(trans, wrap_cnt));
-		fw_mon_data->fw_mon_base_ptr =
-			cpu_to_le32(iwl_read_prph(trans, base));
+
+		iwl_trans_pcie_dump_pointers(trans, fw_mon_data);
 
 		len += sizeof(**data) + sizeof(*fw_mon_data);
 		if (trans->num_blocks) {
@@ -3057,6 +3083,7 @@ iwl_trans_pcie_dump_monitor(struct iwl_trans *trans,
 
 			monitor_len = trans->fw_mon[0].size;
 		} else if (trans->dbg_dest_tlv->monitor_mode == SMEM_MODE) {
+			u32 base = le32_to_cpu(fw_mon_data->fw_mon_base_ptr);
 			/*
 			 * Update pointers to reflect actual values after
 			 * shifting
-- 
2.19.1

