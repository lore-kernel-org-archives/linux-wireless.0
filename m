Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73336C169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:22:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AB13218AF
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:22:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbfAaUWX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 15:22:23 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:53574 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727991AbfAaUWW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 15:22:22 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gpIqp-0004pL-6M; Thu, 31 Jan 2019 22:22:19 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Thu, 31 Jan 2019 22:21:51 +0200
Message-Id: <20190131202206.15903-7-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190131202206.15903-1-luca@coelho.fi>
References: <20190131202206.15903-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 06/21] iwlwifi: dbg_ini: remove redundant dram buffer allocation
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

There are several flows in that can cause redundant allocation.

In case the driver reaches the maximum amount of blocks allowed, it
allocates the buffer and only then checks if it reached the maximum
amount of blocks and return without freeing the buffer,
causing a memory leak.

Solve this by moving the check of the amount of buffers being used
before the allocation.

In case there was an assert, the apply points are being reused,
causing that for each assert, the driver allocates a new redundant
buffer.

Solve this by adding a new is_alloc field to indicate if the driver
already allocated memory for the requested buffer.

Also, split iwl_fw_dbg_buffer_allocation function into
iwl_fw_dbg_buffer_allocation and iwl_fw_dbg_buffer_apply
to increase the clearity of the flow.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Fixes: d47902f9f71d ("iwlwifi: dbg: add apply point logic")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 89 +++++++++++--------
 drivers/net/wireless/intel/iwlwifi/fw/img.h   | 19 ++--
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |  2 +-
 .../net/wireless/intel/iwlwifi/iwl-dbg-tlv.c  | 23 ++++-
 4 files changed, 85 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index f8cf12804aee..5feae549d316 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1131,7 +1131,7 @@ static int iwl_fw_ini_get_trigger_len(struct iwl_fw_runtime *fwrt,
 		if (WARN_ON(reg_id >= ARRAY_SIZE(fwrt->dump.active_regs)))
 			continue;
 
-		reg = fwrt->dump.active_regs[reg_id].reg;
+		reg = fwrt->dump.active_regs[reg_id];
 		if (WARN(!reg, "Unassigned region %d\n", reg_id))
 			continue;
 
@@ -1197,7 +1197,7 @@ static void iwl_fw_ini_dump_trigger(struct iwl_fw_runtime *fwrt,
 		if (reg_id >= ARRAY_SIZE(fwrt->dump.active_regs))
 			continue;
 
-		reg = fwrt->dump.active_regs[reg_id].reg;
+		reg = fwrt->dump.active_regs[reg_id];
 		/* Don't warn, get_trigger_len already warned */
 		if (!reg)
 			continue;
@@ -1667,27 +1667,13 @@ void iwl_fw_dbg_read_d3_debug_data(struct iwl_fw_runtime *fwrt)
 IWL_EXPORT_SYMBOL(iwl_fw_dbg_read_d3_debug_data);
 
 static void
-iwl_fw_dbg_buffer_allocation(struct iwl_fw_runtime *fwrt,
-			     struct iwl_fw_ini_allocation_tlv *alloc)
+iwl_fw_dbg_buffer_allocation(struct iwl_fw_runtime *fwrt, u32 size)
 {
 	struct iwl_trans *trans = fwrt->trans;
-	struct iwl_ldbg_config_cmd ldbg_cmd = {
-		.type = cpu_to_le32(BUFFER_ALLOCATION),
-	};
-	struct iwl_buffer_allocation_cmd *cmd = &ldbg_cmd.buffer_allocation;
-	struct iwl_host_cmd hcmd = {
-		.id = LDBG_CONFIG_CMD,
-		.flags = CMD_ASYNC,
-		.data[0] = &ldbg_cmd,
-		.len[0] = sizeof(ldbg_cmd),
-	};
 	void *virtual_addr = NULL;
-	u32 size = le32_to_cpu(alloc->size);
 	dma_addr_t phys_addr;
 
-	if (!trans->num_blocks &&
-	    le32_to_cpu(alloc->buffer_location) !=
-	    IWL_FW_INI_LOCATION_DRAM_PATH)
+	if (WARN_ON_ONCE(trans->num_blocks == ARRAY_SIZE(trans->fw_mon)))
 		return;
 
 	virtual_addr =
@@ -1699,25 +1685,52 @@ iwl_fw_dbg_buffer_allocation(struct iwl_fw_runtime *fwrt,
 	if (!virtual_addr)
 		IWL_ERR(fwrt, "Failed to allocate debug memory\n");
 
-	if (WARN_ON_ONCE(trans->num_blocks == ARRAY_SIZE(trans->fw_mon)))
-		return;
-
 	trans->fw_mon[trans->num_blocks].block = virtual_addr;
 	trans->fw_mon[trans->num_blocks].physical = phys_addr;
 	trans->fw_mon[trans->num_blocks].size = size;
 	trans->num_blocks++;
 
 	IWL_DEBUG_FW(trans, "Allocated debug block of size %d\n", size);
+}
+
+static void iwl_fw_dbg_buffer_apply(struct iwl_fw_runtime *fwrt,
+				    struct iwl_fw_ini_allocation_data *alloc)
+{
+	struct iwl_trans *trans = fwrt->trans;
+	struct iwl_ldbg_config_cmd ldbg_cmd = {
+		.type = cpu_to_le32(BUFFER_ALLOCATION),
+	};
+	struct iwl_buffer_allocation_cmd *cmd = &ldbg_cmd.buffer_allocation;
+	struct iwl_host_cmd hcmd = {
+		.id = LDBG_CONFIG_CMD,
+		.flags = CMD_ASYNC,
+		.data[0] = &ldbg_cmd,
+		.len[0] = sizeof(ldbg_cmd),
+	};
+	int block_idx = trans->num_blocks;
+
+	if (le32_to_cpu(alloc->tlv.buffer_location) !=
+	    IWL_FW_INI_LOCATION_DRAM_PATH)
+		return;
+
+	if (!alloc->is_alloc) {
+		iwl_fw_dbg_buffer_allocation(fwrt,
+					     le32_to_cpu(alloc->tlv.size));
+		if (block_idx == trans->num_blocks)
+			return;
+		alloc->is_alloc = 1;
+	}
 
 	/* First block is assigned via registers / context info */
 	if (trans->num_blocks == 1)
 		return;
 
 	cmd->num_frags = cpu_to_le32(1);
-	cmd->fragments[0].address = cpu_to_le64(phys_addr);
-	cmd->fragments[0].size = alloc->size;
-	cmd->allocation_id = alloc->allocation_id;
-	cmd->buffer_location = alloc->buffer_location;
+	cmd->fragments[0].address =
+		cpu_to_le64(trans->fw_mon[block_idx].physical);
+	cmd->fragments[0].size = alloc->tlv.size;
+	cmd->allocation_id = alloc->tlv.allocation_id;
+	cmd->buffer_location = alloc->tlv.buffer_location;
 
 	iwl_trans_send_cmd(trans, &hcmd);
 }
@@ -1746,9 +1759,8 @@ static void iwl_fw_dbg_update_regions(struct iwl_fw_runtime *fwrt,
 	int i, size = le32_to_cpu(tlv->num_regions);
 
 	for (i = 0; i < size; i++) {
-		struct iwl_fw_ini_region_cfg *reg = iter;
+		struct iwl_fw_ini_region_cfg *reg = iter, **active;
 		int id = le32_to_cpu(reg->region_id);
-		struct iwl_fw_ini_active_regs *active;
 
 		if (WARN(id >= ARRAY_SIZE(fwrt->dump.active_regs),
 			 "Invalid region id %d for apply point %d\n", id, pnt))
@@ -1756,17 +1768,14 @@ static void iwl_fw_dbg_update_regions(struct iwl_fw_runtime *fwrt,
 
 		active = &fwrt->dump.active_regs[id];
 
-		if (ext && active->apply_point == pnt)
-			IWL_WARN(fwrt->trans,
-				 "External region TLV overrides FW default %x\n",
-				 id);
+		if (*active)
+			IWL_WARN(fwrt->trans, "region TLV %d override\n", id);
 
 		IWL_DEBUG_FW(fwrt,
 			     "%s: apply point %d, activating region ID %d\n",
 			     __func__, pnt, id);
 
-		active->reg = reg;
-		active->apply_point = pnt;
+		*active = reg;
 
 		if (le32_to_cpu(reg->region_type) !=
 		    IWL_FW_INI_REGION_DRAM_BUFFER)
@@ -1842,9 +1851,13 @@ static void _iwl_fw_dbg_apply_point(struct iwl_fw_runtime *fwrt,
 		u32 type = le32_to_cpu(tlv->type);
 
 		switch (type) {
-		case IWL_UCODE_TLV_TYPE_BUFFER_ALLOCATION:
-			iwl_fw_dbg_buffer_allocation(fwrt, ini_tlv);
+		case IWL_UCODE_TLV_TYPE_BUFFER_ALLOCATION: {
+			struct iwl_fw_ini_allocation_data *buf_alloc = ini_tlv;
+
+			iwl_fw_dbg_buffer_apply(fwrt, ini_tlv);
+			iter += sizeof(buf_alloc->is_alloc);
 			break;
+		}
 		case IWL_UCODE_TLV_TYPE_HCMD:
 			if (pnt < IWL_FW_INI_APPLY_AFTER_ALIVE) {
 				IWL_ERR(fwrt,
@@ -1875,6 +1888,12 @@ void iwl_fw_dbg_apply_point(struct iwl_fw_runtime *fwrt,
 			    enum iwl_fw_ini_apply_point apply_point)
 {
 	void *data = &fwrt->trans->apply_points[apply_point];
+	int i;
+
+	if (apply_point == IWL_FW_INI_APPLY_EARLY) {
+		for (i = 0; i < IWL_FW_INI_MAX_REGION_ID; i++)
+			fwrt->dump.active_regs[i] = NULL;
+	}
 
 	_iwl_fw_dbg_apply_point(fwrt, data, apply_point, false);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/img.h b/drivers/net/wireless/intel/iwlwifi/fw/img.h
index 12333167ea23..23f982be800f 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/img.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/img.h
@@ -222,6 +222,15 @@ struct iwl_fw_dbg {
 	u32 dump_mask;
 };
 
+/**
+ * @tlv: the buffer allocation tlv
+ * @is_alloc: indicates if the buffer was already allocated
+ */
+struct iwl_fw_ini_allocation_data {
+	struct iwl_fw_ini_allocation_tlv tlv;
+	u32 is_alloc;
+} __packed;
+
 /**
  * struct iwl_fw_ini_active_triggers
  * @active: is this trigger active
@@ -236,16 +245,6 @@ struct iwl_fw_ini_active_triggers {
 	struct iwl_fw_ini_trigger *conf_ext;
 };
 
-/**
- * struct iwl_fw_ini_active_regs
- * @reg: active region from TLV
- * @apply_point: apply point where it became active
- */
-struct iwl_fw_ini_active_regs {
-	struct iwl_fw_ini_region_cfg *reg;
-	enum iwl_fw_ini_apply_point apply_point;
-};
-
 /**
  * struct iwl_fw - variables associated with the firmware
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
index 9ff04ffba3fa..52af848f2eb3 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
@@ -139,7 +139,7 @@ struct iwl_fw_runtime {
 		/* ts of the beginning of a non-collect fw dbg data period */
 		unsigned long non_collect_ts_start[IWL_FW_TRIGGER_ID_NUM - 1];
 		u32 *d3_debug_data;
-		struct iwl_fw_ini_active_regs active_regs[IWL_FW_INI_MAX_REGION_ID];
+		struct iwl_fw_ini_region_cfg *active_regs[IWL_FW_INI_MAX_REGION_ID];
 		struct iwl_fw_ini_active_triggers active_trigs[IWL_FW_TRIGGER_ID_NUM];
 		u32 lmac_err_id[MAX_NUM_LMAC];
 		u32 umac_err_id;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index 43d815cb3ce9..5798f434f68f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -71,6 +71,7 @@ void iwl_fw_dbg_copy_tlv(struct iwl_trans *trans, struct iwl_ucode_tlv *tlv,
 	u32 apply_point = le32_to_cpu(header->apply_point);
 
 	int copy_size = le32_to_cpu(tlv->length) + sizeof(*tlv);
+	int offset_size = copy_size;
 
 	if (WARN_ONCE(apply_point >= IWL_FW_INI_APPLY_NUM,
 		      "Invalid apply point id %d\n", apply_point))
@@ -81,17 +82,25 @@ void iwl_fw_dbg_copy_tlv(struct iwl_trans *trans, struct iwl_ucode_tlv *tlv,
 	else
 		data = &trans->apply_points[apply_point];
 
+	/* add room for is_alloc field in &iwl_fw_ini_allocation_data struct */
+	if (le32_to_cpu(tlv->type) == IWL_UCODE_TLV_TYPE_BUFFER_ALLOCATION) {
+		struct iwl_fw_ini_allocation_data *buf_alloc =
+			(void *)tlv->data;
+
+		offset_size += sizeof(buf_alloc->is_alloc);
+	}
+
 	/*
 	 * Make sure we still have room to copy this TLV. Offset points to the
 	 * location the last copy ended.
 	 */
-	if (WARN_ONCE(data->offset + copy_size > data->size,
+	if (WARN_ONCE(data->offset + offset_size > data->size,
 		      "Not enough memory for apply point %d\n",
 		      apply_point))
 		return;
 
 	memcpy(data->data + data->offset, (void *)tlv, copy_size);
-	data->offset += copy_size;
+	data->offset += offset_size;
 }
 
 void iwl_alloc_dbg_tlv(struct iwl_trans *trans, size_t len, const u8 *data,
@@ -129,6 +138,16 @@ void iwl_alloc_dbg_tlv(struct iwl_trans *trans, size_t len, const u8 *data,
 		if (WARN_ON(apply >= IWL_FW_INI_APPLY_NUM))
 			continue;
 
+		/* add room for is_alloc field in &iwl_fw_ini_allocation_data
+		 * struct
+		 */
+		if (tlv_type == IWL_UCODE_TLV_TYPE_BUFFER_ALLOCATION) {
+			struct iwl_fw_ini_allocation_data *buf_alloc =
+				(void *)tlv->data;
+
+			size[apply] += sizeof(buf_alloc->is_alloc);
+		}
+
 		size[apply] += sizeof(*tlv) + tlv_len;
 	}
 
-- 
2.20.1

