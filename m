Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06992C282C4
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 22:37:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8F202173B
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 22:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbfBGWhD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 17:37:03 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:56688 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726758AbfBGWhD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 17:37:03 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1grsHm-0002II-79; Fri, 08 Feb 2019 00:36:46 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Feb 2019 00:36:17 +0200
Message-Id: <20190207223622.9642-13-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190207223622.9642-1-luca@coelho.fi>
References: <20190207223622.9642-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 12/17] iwlwifi: dbg_ini: rewrite trigger flow and align to FW API changes
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Trigger field ignore_default was changed to override_trig.
The first byte of the field indicates the driver to override existing
configuration or keep the previous one
The second byte of the field indicated the driver to replace the regions
of the previous trigger or to append new regions to it.

Change the way the active triggers are maintained to support trigger
override in different apply points.
Do this by making a trigger that updates at runtime by the
triggers that are being used in the different apply points.

In case of an assert, the driver does not reconfigure the triggers
and uses the old configuration which leads to undefined behavior.
Solve this by clearing the triggers in assert recovery flow.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/fw/api/dbg-tlv.h   |  11 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 116 ++++++++++++------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   |   7 +-
 drivers/net/wireless/intel/iwlwifi/fw/img.h   |  10 +-
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |  12 ++
 5 files changed, 107 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h b/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
index 75e23c426be8..70cc0820e068 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h
@@ -204,8 +204,13 @@ struct iwl_fw_ini_region_tlv {
  * struct iwl_fw_ini_trigger - (IWL_FW_INI_TLV_TYPE_DUMP_CFG)
  * Region sections define IDs and triggers that use those IDs TLV
  *
- * @trigger_id: enum &iwl_fw_ini_trigger_id
- * @ignore_default: override FW TLV with binary TLV
+ * @trigger_id: enum &iwl_fw_ini_tigger_id
+ * @override_trig: determines how apply trigger in case a trigger with the
+ *	same id is already in use. Using the first 2 bytes:
+ *	Byte 0: if 0, override trigger configuration, otherwise use the
+ *	existing configuration.
+ *	Byte 1: if 0, override trigger regions, otherwise append regions to
+ *	existing trigger.
  * @dump_delay: delay from trigger fire to dump, in usec
  * @occurrences: max amount of times to be fired
  * @ignore_consec: ignore consecutive triggers, in usec
@@ -217,7 +222,7 @@ struct iwl_fw_ini_region_tlv {
  */
 struct iwl_fw_ini_trigger {
 	__le32 trigger_id;
-	__le32 ignore_default;
+	__le32 override_trig;
 	__le32 dump_delay;
 	__le32 occurrences;
 	__le32 ignore_consec;
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 512af6128fa5..728fe051745b 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1473,20 +1473,19 @@ _iwl_fw_error_ini_dump(struct iwl_fw_runtime *fwrt,
 	int size, id = le32_to_cpu(fwrt->dump.desc->trig_desc.type);
 	struct iwl_fw_error_dump_data *dump_data;
 	struct iwl_fw_error_dump_file *dump_file;
-	struct iwl_fw_ini_trigger *trigger, *ext;
+	struct iwl_fw_ini_trigger *trigger;
 
 	if (id == FW_DBG_TRIGGER_FW_ASSERT)
 		id = IWL_FW_TRIGGER_ID_FW_ASSERT;
 
-	if (WARN_ON(id >= ARRAY_SIZE(fwrt->dump.active_trigs)))
+	if (WARN_ON(id >= ARRAY_SIZE(fwrt->dump.active_trigs)) ||
+	    !fwrt->dump.active_trigs[id].active)
 		return NULL;
 
-	trigger = fwrt->dump.active_trigs[id].conf;
-	ext = fwrt->dump.active_trigs[id].conf_ext;
+	trigger = fwrt->dump.active_trigs[id].trig;
 
 	size = sizeof(*dump_file);
 	size += iwl_fw_ini_get_trigger_len(fwrt, trigger);
-	size += iwl_fw_ini_get_trigger_len(fwrt, ext);
 
 	if (!size)
 		return NULL;
@@ -1501,10 +1500,7 @@ _iwl_fw_error_ini_dump(struct iwl_fw_runtime *fwrt,
 	dump_data = (void *)dump_file->data;
 	dump_file->file_len = cpu_to_le32(size);
 
-	if (trigger)
-		iwl_fw_ini_dump_trigger(fwrt, trigger, &dump_data);
-	if (ext)
-		iwl_fw_ini_dump_trigger(fwrt, ext, &dump_data);
+	iwl_fw_ini_dump_trigger(fwrt, trigger, &dump_data);
 
 	return dump_file;
 }
@@ -1696,6 +1692,7 @@ int iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
 		       u32 id, const char *str, size_t len)
 {
 	struct iwl_fw_dump_desc *desc;
+	struct iwl_fw_ini_active_triggers *active;
 	u32 occur, delay;
 
 	if (!fwrt->trans->ini_valid)
@@ -1704,15 +1701,17 @@ int iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
 	if (id == FW_DBG_TRIGGER_USER)
 		id = IWL_FW_TRIGGER_ID_USER_TRIGGER;
 
-	if (WARN_ON(!fwrt->dump.active_trigs[id].active))
+	active = &fwrt->dump.active_trigs[id];
+
+	if (WARN_ON(!active->active))
 		return -EINVAL;
 
-	delay = le32_to_cpu(fwrt->dump.active_trigs[id].conf->dump_delay);
-	occur = le32_to_cpu(fwrt->dump.active_trigs[id].conf->occurrences);
+	delay = le32_to_cpu(active->trig->dump_delay);
+	occur = le32_to_cpu(active->trig->occurrences);
 	if (!occur)
 		return 0;
 
-	if (le32_to_cpu(fwrt->dump.active_trigs[id].conf->force_restart)) {
+	if (le32_to_cpu(active->trig->force_restart)) {
 		IWL_WARN(fwrt, "Force restart: trigger %d fired.\n", id);
 		iwl_force_nmi(fwrt->trans);
 		return 0;
@@ -1722,8 +1721,7 @@ int iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
 	if (!desc)
 		return -ENOMEM;
 
-	occur--;
-	fwrt->dump.active_trigs[id].conf->occurrences = cpu_to_le32(occur);
+	active->trig->occurrences = cpu_to_le32(--occur);
 
 	desc->len = len;
 	desc->trig_desc.type = cpu_to_le32(id);
@@ -2022,6 +2020,26 @@ static void iwl_fw_dbg_update_regions(struct iwl_fw_runtime *fwrt,
 	}
 }
 
+static int iwl_fw_dbg_trig_realloc(struct iwl_fw_runtime *fwrt,
+				   struct iwl_fw_ini_active_triggers *active,
+				   u32 id, int size)
+{
+	void *ptr;
+
+	if (size <= active->size)
+		return 0;
+
+	ptr = krealloc(active->trig, size, GFP_KERNEL);
+	if (!ptr) {
+		IWL_ERR(fwrt, "Failed to allocate memory for trigger %d\n", id);
+		return -ENOMEM;
+	}
+	active->trig = ptr;
+	active->size = size;
+
+	return 0;
+}
+
 static void iwl_fw_dbg_update_triggers(struct iwl_fw_runtime *fwrt,
 				       struct iwl_fw_ini_trigger_tlv *tlv,
 				       bool ext,
@@ -2034,43 +2052,63 @@ static void iwl_fw_dbg_update_triggers(struct iwl_fw_runtime *fwrt,
 		struct iwl_fw_ini_trigger *trig = iter;
 		struct iwl_fw_ini_active_triggers *active;
 		int id = le32_to_cpu(trig->trigger_id);
-		u32 num;
+		u32 trig_regs_size = le32_to_cpu(trig->num_regions) *
+			sizeof(__le32);
 
 		if (WARN_ON(id >= ARRAY_SIZE(fwrt->dump.active_trigs)))
 			break;
 
 		active = &fwrt->dump.active_trigs[id];
 
-		if (active->apply_point != apply_point) {
-			active->conf = NULL;
-			active->conf_ext = NULL;
-		}
+		if (!active->active) {
+			size_t trig_size = sizeof(*trig) + trig_regs_size;
+
+			if (iwl_fw_dbg_trig_realloc(fwrt, active, id,
+						    trig_size))
+				goto next;
 
-		num = le32_to_cpu(trig->num_regions);
+			memcpy(active->trig, trig, trig_size);
 
-		if (ext && active->apply_point == apply_point) {
-			num += le32_to_cpu(active->conf->num_regions);
-			if (trig->ignore_default) {
-				active->conf_ext = active->conf;
-				active->conf = trig;
+		} else {
+			u32 conf_override =
+				!(le32_to_cpu(trig->override_trig) & 0xff);
+			u32 region_override =
+				!(le32_to_cpu(trig->override_trig) & 0xff00);
+			u32 offset = 0;
+			u32 active_regs =
+				le32_to_cpu(active->trig->num_regions);
+			u32 new_regs = le32_to_cpu(trig->num_regions);
+			int mem_to_add = trig_regs_size;
+
+			if (region_override) {
+				mem_to_add -= active_regs * sizeof(__le32);
 			} else {
-				active->conf_ext = trig;
+				offset += active_regs;
+				new_regs += active_regs;
 			}
-		} else {
-			active->conf = trig;
+
+			if (iwl_fw_dbg_trig_realloc(fwrt, active, id,
+						    active->size + mem_to_add))
+				goto next;
+
+			if (conf_override)
+				memcpy(active->trig, trig, sizeof(*trig));
+
+			memcpy(active->trig->data + offset, trig->data,
+			       trig_regs_size);
+			active->trig->num_regions = cpu_to_le32(new_regs);
 		}
 
 		/* Since zero means infinity - just set to -1 */
-		if (!le32_to_cpu(trig->occurrences))
-			trig->occurrences = cpu_to_le32(-1);
-		if (!le32_to_cpu(trig->ignore_consec))
-			trig->ignore_consec = cpu_to_le32(-1);
+		if (!le32_to_cpu(active->trig->occurrences))
+			active->trig->occurrences = cpu_to_le32(-1);
+		if (!le32_to_cpu(active->trig->ignore_consec))
+			active->trig->ignore_consec = cpu_to_le32(-1);
 
-		iter += sizeof(*trig) +
-			le32_to_cpu(trig->num_regions) * sizeof(__le32);
+		active->active = true;
+next:
+		iter += sizeof(*trig) + trig_regs_size;
 
-		active->active = num;
-		active->apply_point = apply_point;
 	}
 }
 
@@ -2129,6 +2167,10 @@ void iwl_fw_dbg_apply_point(struct iwl_fw_runtime *fwrt,
 	if (apply_point == IWL_FW_INI_APPLY_EARLY) {
 		for (i = 0; i < IWL_FW_INI_MAX_REGION_ID; i++)
 			fwrt->dump.active_regs[i] = NULL;
+
+		/* disable the triggers, used in recovery flow */
+		for (i = 0; i < IWL_FW_TRIGGER_ID_NUM; i++)
+			fwrt->dump.active_trigs[i].active = false;
 	}
 
 	_iwl_fw_dbg_apply_point(fwrt, data, apply_point, false);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index d11923edd695..b64fdfdcbce7 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -225,16 +225,17 @@ static inline bool
 _iwl_fw_ini_trigger_on(struct iwl_fw_runtime *fwrt,
 		       const enum iwl_fw_dbg_trigger id)
 {
-	struct iwl_fw_ini_active_triggers *trig = &fwrt->dump.active_trigs[id];
+	struct iwl_fw_ini_active_triggers *active =
+		&fwrt->dump.active_trigs[id];
 	u32 ms;
 
 	if (!fwrt->trans->ini_valid)
 		return false;
 
-	if (!trig || !trig->active)
+	if (!active->active)
 		return false;
 
-	ms = le32_to_cpu(trig->conf->ignore_consec);
+	ms = le32_to_cpu(active->trig->ignore_consec);
 	if (ms)
 		ms /= USEC_PER_MSEC;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/img.h b/drivers/net/wireless/intel/iwlwifi/fw/img.h
index 23f982be800f..6ffa2e39a25c 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/img.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/img.h
@@ -234,15 +234,13 @@ struct iwl_fw_ini_allocation_data {
 /**
  * struct iwl_fw_ini_active_triggers
  * @active: is this trigger active
- * @apply_point: last apply point that updated this trigger
- * @conf: active trigger
- * @conf_ext: second trigger, contains extra regions to dump
+ * @size: allocated memory size of the trigger
+ * @trig: trigger
  */
 struct iwl_fw_ini_active_triggers {
 	bool active;
-	enum iwl_fw_ini_apply_point apply_point;
-	struct iwl_fw_ini_trigger *conf;
-	struct iwl_fw_ini_trigger *conf_ext;
+	size_t size;
+	struct iwl_fw_ini_trigger *trig;
 };
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
index 52af848f2eb3..2bbae7a1f492 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
@@ -160,8 +160,20 @@ void iwl_fw_runtime_init(struct iwl_fw_runtime *fwrt, struct iwl_trans *trans,
 
 static inline void iwl_fw_runtime_free(struct iwl_fw_runtime *fwrt)
 {
+	int i;
+
 	kfree(fwrt->dump.d3_debug_data);
 	fwrt->dump.d3_debug_data = NULL;
+
+	for (i = 0; i < IWL_FW_TRIGGER_ID_NUM; i++) {
+		struct iwl_fw_ini_active_triggers *active =
+			&fwrt->dump.active_trigs[i];
+
+		active->active = false;
+		active->size = 0;
+		kfree(active->trig);
+		active->trig = NULL;
+	}
 }
 
 void iwl_fw_runtime_suspend(struct iwl_fw_runtime *fwrt);
-- 
2.20.1

