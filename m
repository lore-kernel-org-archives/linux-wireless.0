Return-Path: <SRS0=Soq1=NW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AA09C43441
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 20:08:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14EDC2080D
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 20:08:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 14EDC2080D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730701AbeKLF5u (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 00:57:50 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:36032 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726471AbeKLF5t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 00:57:49 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gLw1K-0000JG-TV; Sun, 11 Nov 2018 22:07:47 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 11 Nov 2018 22:07:27 +0200
Message-Id: <20181111200732.8159-12-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181111200732.8159-1-luca@coelho.fi>
References: <20181111200732.8159-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 11/16] iwlwifi: dbg: add apply point logic
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Add a function to be called when apply point occurs.
For each of the TLVs, the function will perform the
apply point logic:
- For HCMD - send the stored host command
- For buffer allocation - allocate the memory and send the
  buffer allocation command
- For trigger and region - update the stored configuration

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 207 ++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   |   4 +
 drivers/net/wireless/intel/iwlwifi/fw/img.h   |  26 +++
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |   3 +
 .../net/wireless/intel/iwlwifi/iwl-dbg-tlv.c  |   3 +
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |   3 +-
 6 files changed, 244 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 6460b937d331..76050cc3532a 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1263,3 +1263,210 @@ void iwl_fw_dbg_read_d3_debug_data(struct iwl_fw_runtime *fwrt)
 				 cfg->d3_debug_data_length);
 }
 IWL_EXPORT_SYMBOL(iwl_fw_dbg_read_d3_debug_data);
+
+static void
+iwl_fw_dbg_buffer_allocation(struct iwl_fw_runtime *fwrt,
+			     struct iwl_fw_ini_allocation_tlv *alloc)
+{
+	struct iwl_trans *trans = fwrt->trans;
+	struct iwl_continuous_record_cmd cont_rec = {};
+	struct iwl_buffer_allocation_cmd *cmd = (void *)&cont_rec.pad[0];
+	struct iwl_host_cmd hcmd = {
+		.id = LDBG_CONFIG_CMD,
+		.flags = CMD_ASYNC,
+		.data[0] = &cont_rec,
+		.len[0] = sizeof(cont_rec),
+	};
+	void *virtual_addr = NULL;
+	u32 size = le32_to_cpu(alloc->size);
+	dma_addr_t phys_addr;
+
+	cont_rec.record_mode.enable_recording = cpu_to_le16(BUFFER_ALLOCATION);
+
+	if (!trans->num_blocks &&
+	    le32_to_cpu(alloc->buffer_location) !=
+	    IWL_FW_INI_LOCATION_DRAM_PATH)
+		return;
+
+	virtual_addr = dma_alloc_coherent(fwrt->trans->dev, size,
+					  &phys_addr, GFP_KERNEL);
+
+	/* TODO: alloc fragments if needed */
+	if (!virtual_addr)
+		IWL_ERR(fwrt, "Failed to allocate debug memory\n");
+
+	if (WARN_ON_ONCE(trans->num_blocks == ARRAY_SIZE(trans->fw_mon)))
+		return;
+
+	trans->fw_mon[trans->num_blocks].block = virtual_addr;
+	trans->fw_mon[trans->num_blocks].physical = phys_addr;
+	trans->fw_mon[trans->num_blocks].size = size;
+	trans->num_blocks++;
+
+	IWL_DEBUG_FW(trans, "Allocated debug block of size %d\n", size);
+
+	/* First block is assigned via registers / context info */
+	if (trans->num_blocks == 1)
+		return;
+
+	cmd->num_frags = cpu_to_le32(1);
+	cmd->fragments[0].address = cpu_to_le64(phys_addr);
+	cmd->fragments[0].size = alloc->size;
+	cmd->allocation_id = alloc->allocation_id;
+	cmd->buffer_location = alloc->buffer_location;
+
+	iwl_trans_send_cmd(trans, &hcmd);
+}
+
+static void iwl_fw_dbg_send_hcmd(struct iwl_fw_runtime *fwrt,
+				 struct iwl_ucode_tlv *tlv)
+{
+	struct iwl_fw_ini_hcmd_tlv *hcmd_tlv = (void *)&tlv->data[0];
+	struct iwl_fw_ini_hcmd *data = &hcmd_tlv->hcmd;
+	u16 len = le32_to_cpu(tlv->length) - sizeof(*hcmd_tlv);
+
+	struct iwl_host_cmd hcmd = {
+		.id = WIDE_ID(data->group, data->id),
+		.len = { len, },
+		.data = { data->data, },
+	};
+
+	iwl_trans_send_cmd(fwrt->trans, &hcmd);
+}
+
+static void iwl_fw_dbg_update_regions(struct iwl_fw_runtime *fwrt,
+				      struct iwl_fw_ini_region_tlv *tlv,
+				      bool ext, enum iwl_fw_ini_apply_point pnt)
+{
+	void *iter = (void *)tlv->region_config;
+	int i, size = le32_to_cpu(tlv->num_regions);
+
+	for (i = 0; i < size; i++) {
+		struct iwl_fw_ini_region_cfg *reg = iter;
+		int id = le32_to_cpu(reg->region_id);
+		struct iwl_fw_ini_active_regs *active;
+
+		if (WARN_ON(id >= ARRAY_SIZE(fwrt->dump.active_regs)))
+			break;
+
+		active = &fwrt->dump.active_regs[id];
+
+		if (ext && active->apply_point == pnt)
+			IWL_WARN(fwrt->trans,
+				 "External region TLV overrides FW default %x\n",
+				 id);
+
+		IWL_DEBUG_FW(fwrt,
+			     "%s: apply point %d, activating region ID %d\n",
+			     __func__, pnt, id);
+
+		active->reg = reg;
+		active->apply_point = pnt;
+
+		if (le32_to_cpu(reg->region_type) !=
+		    IWL_FW_INI_REGION_DRAM_BUFFER)
+			iter += le32_to_cpu(reg->num_regions) * sizeof(__le32);
+
+		iter += sizeof(*reg);
+	}
+}
+
+static void iwl_fw_dbg_update_triggers(struct iwl_fw_runtime *fwrt,
+				       struct iwl_fw_ini_trigger_tlv *tlv,
+				       bool ext,
+				       enum iwl_fw_ini_apply_point apply_point)
+{
+	int i, size = le32_to_cpu(tlv->num_triggers);
+	void *iter = (void *)tlv->trigger_config;
+
+	for (i = 0; i < size; i++) {
+		struct iwl_fw_ini_trigger *trig = iter;
+		struct iwl_fw_ini_active_triggers *active;
+		int id = le32_to_cpu(trig->trigger_id);
+		u32 num;
+
+		if (WARN_ON(id >= ARRAY_SIZE(fwrt->dump.active_trigs)))
+			break;
+
+		active = &fwrt->dump.active_trigs[id];
+
+		if (active->apply_point != apply_point) {
+			active->conf = NULL;
+			active->conf_ext = NULL;
+		}
+
+		num = le32_to_cpu(trig->num_regions);
+
+		if (ext && active->apply_point == apply_point) {
+			num += le32_to_cpu(active->conf->num_regions);
+			if (trig->ignore_default) {
+				active->conf_ext = active->conf;
+				active->conf = trig;
+			} else {
+				active->conf_ext = trig;
+			}
+		} else {
+			active->conf = trig;
+		}
+
+		iter += sizeof(*trig) +
+			le32_to_cpu(trig->num_regions) * sizeof(__le32);
+
+		active->active = num;
+		active->apply_point = apply_point;
+	}
+}
+
+static void _iwl_fw_dbg_apply_point(struct iwl_fw_runtime *fwrt,
+				    struct iwl_apply_point_data *data,
+				    enum iwl_fw_ini_apply_point pnt,
+				    bool ext)
+{
+	void *iter = data->data;
+
+	while (iter && iter < data->data + data->size) {
+		struct iwl_ucode_tlv *tlv = iter;
+		void *ini_tlv = (void *)tlv->data;
+		u32 type = le32_to_cpu(tlv->type);
+
+		switch (type) {
+		case IWL_UCODE_TLV_TYPE_BUFFER_ALLOCATION:
+			iwl_fw_dbg_buffer_allocation(fwrt, ini_tlv);
+			break;
+		case IWL_UCODE_TLV_TYPE_HCMD:
+			if (pnt < IWL_FW_INI_APPLY_AFTER_ALIVE) {
+				IWL_ERR(fwrt,
+					"Invalid apply point %x for host command\n",
+					pnt);
+				goto next;
+			}
+			iwl_fw_dbg_send_hcmd(fwrt, tlv);
+			break;
+		case IWL_UCODE_TLV_TYPE_REGIONS:
+			iwl_fw_dbg_update_regions(fwrt, ini_tlv, ext, pnt);
+			break;
+		case IWL_UCODE_TLV_TYPE_TRIGGERS:
+			iwl_fw_dbg_update_triggers(fwrt, ini_tlv, ext, pnt);
+			break;
+		case IWL_UCODE_TLV_TYPE_DEBUG_FLOW:
+			break;
+		default:
+			WARN_ONCE(1, "Invalid TLV %x for apply point\n", type);
+			break;
+		}
+next:
+		iter += sizeof(*tlv) + le32_to_cpu(tlv->length);
+	}
+}
+
+void iwl_fw_dbg_apply_point(struct iwl_fw_runtime *fwrt,
+			    enum iwl_fw_ini_apply_point apply_point)
+{
+	void *data = &fwrt->trans->apply_points[apply_point];
+
+	_iwl_fw_dbg_apply_point(fwrt, data, apply_point, false);
+
+	data = &fwrt->trans->apply_points_ext[apply_point];
+	_iwl_fw_dbg_apply_point(fwrt, data, apply_point, true);
+}
+IWL_EXPORT_SYMBOL(iwl_fw_dbg_apply_point);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index 07403aa29793..6b3c5677c53a 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -72,6 +72,7 @@
 #include "file.h"
 #include "error-dump.h"
 #include "api/commands.h"
+#include "api/dbg-tlv.h"
 
 /**
  * struct iwl_fw_dump_desc - describes the dump
@@ -384,4 +385,7 @@ static inline void iwl_fw_resume_timestamp(struct iwl_fw_runtime *fwrt) {}
 void iwl_fw_assert_error_dump(struct iwl_fw_runtime *fwrt);
 void iwl_fw_alive_error_dump(struct iwl_fw_runtime *fwrt);
 void iwl_fw_dbg_collect_sync(struct iwl_fw_runtime *fwrt);
+void iwl_fw_dbg_apply_point(struct iwl_fw_runtime *fwrt,
+			    enum iwl_fw_ini_apply_point apply_point);
+
 #endif  /* __iwl_fw_dbg_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/img.h b/drivers/net/wireless/intel/iwlwifi/fw/img.h
index 54dbbd998abf..12333167ea23 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/img.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/img.h
@@ -65,6 +65,8 @@
 #define __iwl_fw_img_h__
 #include <linux/types.h>
 
+#include "api/dbg-tlv.h"
+
 #include "file.h"
 #include "error-dump.h"
 
@@ -220,6 +222,30 @@ struct iwl_fw_dbg {
 	u32 dump_mask;
 };
 
+/**
+ * struct iwl_fw_ini_active_triggers
+ * @active: is this trigger active
+ * @apply_point: last apply point that updated this trigger
+ * @conf: active trigger
+ * @conf_ext: second trigger, contains extra regions to dump
+ */
+struct iwl_fw_ini_active_triggers {
+	bool active;
+	enum iwl_fw_ini_apply_point apply_point;
+	struct iwl_fw_ini_trigger *conf;
+	struct iwl_fw_ini_trigger *conf_ext;
+};
+
+/**
+ * struct iwl_fw_ini_active_regs
+ * @reg: active region from TLV
+ * @apply_point: apply point where it became active
+ */
+struct iwl_fw_ini_active_regs {
+	struct iwl_fw_ini_region_cfg *reg;
+	enum iwl_fw_ini_apply_point apply_point;
+};
+
 /**
  * struct iwl_fw - variables associated with the firmware
  *
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
index 8a139431e7be..886227b7c949 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
@@ -64,6 +64,7 @@
 #include "iwl-trans.h"
 #include "img.h"
 #include "fw/api/debug.h"
+#include "fw/api/dbg-tlv.h"
 #include "fw/api/paging.h"
 #include "iwl-eeprom-parse.h"
 
@@ -139,6 +140,8 @@ struct iwl_fw_runtime {
 		/* ts of the beginning of a non-collect fw dbg data period */
 		unsigned long non_collect_ts_start[FW_DBG_TRIGGER_MAX - 1];
 		u32 *d3_debug_data;
+		struct iwl_fw_ini_active_regs active_regs[IWL_FW_INI_MAX_REGION_ID];
+		struct iwl_fw_ini_active_triggers active_trigs[IWL_FW_TRIGGER_ID_NUM];
 	} dump;
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	struct {
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index 0160662a1749..bc1e4d4bb42d 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -123,6 +123,9 @@ void iwl_alloc_dbg_tlv(struct iwl_trans *trans, size_t len, const u8 *data,
 		hdr = (void *)&tlv->data[0];
 		apply = le32_to_cpu(hdr->apply_point);
 
+		IWL_DEBUG_FW(trans, "Read TLV %x, apply point %d\n",
+			     le32_to_cpu(tlv->type), apply);
+
 		if (WARN_ON(apply >= IWL_FW_INI_APPLY_NUM))
 			continue;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 3d455cf5822b..c2531eae5e16 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -680,7 +680,6 @@ enum iwl_plat_pm_mode {
  * enter/exit (in msecs).
  */
 #define IWL_TRANS_IDLE_TIMEOUT 2000
-#define IWL_MAX_DEBUG_ALLOCATIONS	1
 
 /**
  * struct iwl_dram_data
@@ -786,7 +785,7 @@ struct iwl_trans {
 	struct iwl_fw_dbg_trigger_tlv * const *dbg_trigger_tlv;
 	u8 dbg_n_dest_reg;
 	int num_blocks;
-	struct iwl_dram_data fw_mon[IWL_MAX_DEBUG_ALLOCATIONS];
+	struct iwl_dram_data fw_mon[IWL_FW_INI_APPLY_NUM];
 
 	enum iwl_plat_pm_mode system_pm_mode;
 	enum iwl_plat_pm_mode runtime_pm_mode;
-- 
2.19.1

