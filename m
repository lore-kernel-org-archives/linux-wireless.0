Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 510C1C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 16:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20F062077B
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 16:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729596AbfCOQhT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 12:37:19 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:44352 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729541AbfCOQhT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 12:37:19 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h4ppD-0004qp-NP; Fri, 15 Mar 2019 18:36:52 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 15 Mar 2019 18:36:31 +0200
Message-Id: <20190315163634.17315-14-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190315163634.17315-1-luca@coelho.fi>
References: <20190315163634.17315-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 13/16] iwlwifi: dbg_ini: separate between ini and legacy dump flows
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Separate between ini and legacy dump flows to allow adding ini triggers
that are not supported in the legacy flow and to increase readabilty.

iwl_fw_dbg_ini_collect function is now called with legacy trigger id and
_iwl_fw_dbg_ini_collect is called with ini trigger id.

Also make the actual dumping function static so that any dump collection
will go through iwl_fw_dbg_collect_sync.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c   | 189 ++++++++++--------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h   |  17 +-
 .../net/wireless/intel/iwlwifi/fw/runtime.h   |   1 +
 .../net/wireless/intel/iwlwifi/mvm/debugfs.c  |   2 +-
 4 files changed, 120 insertions(+), 89 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index f119c49cd39c..65252481a306 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -804,8 +804,8 @@ static void iwl_dump_paging(struct iwl_fw_runtime *fwrt,
 }
 
 static struct iwl_fw_error_dump_file *
-_iwl_fw_error_dump(struct iwl_fw_runtime *fwrt,
-		   struct iwl_fw_dump_ptrs *fw_error_dump)
+iwl_fw_error_dump_file(struct iwl_fw_runtime *fwrt,
+		       struct iwl_fw_dump_ptrs *fw_error_dump)
 {
 	struct iwl_fw_error_dump_file *dump_file;
 	struct iwl_fw_error_dump_data *dump_data;
@@ -1791,16 +1791,13 @@ static void iwl_fw_ini_dump_trigger(struct iwl_fw_runtime *fwrt,
 }
 
 static struct iwl_fw_error_dump_file *
-_iwl_fw_error_ini_dump(struct iwl_fw_runtime *fwrt,
-		       struct iwl_fw_dump_ptrs *fw_error_dump)
+iwl_fw_error_ini_dump_file(struct iwl_fw_runtime *fwrt)
 {
-	int size, id = le32_to_cpu(fwrt->dump.desc->trig_desc.type);
+	int size;
 	struct iwl_fw_error_dump_data *dump_data;
 	struct iwl_fw_error_dump_file *dump_file;
 	struct iwl_fw_ini_trigger *trigger;
-
-	if (id == FW_DBG_TRIGGER_FW_ASSERT)
-		id = IWL_FW_TRIGGER_ID_FW_ASSERT;
+	enum iwl_fw_ini_trigger_id id = fwrt->dump.ini_trig_id;
 
 	if (!iwl_fw_ini_trigger_on(fwrt, id))
 		return NULL;
@@ -1817,8 +1814,6 @@ _iwl_fw_error_ini_dump(struct iwl_fw_runtime *fwrt,
 	if (!dump_file)
 		return NULL;
 
-	fw_error_dump->fwrt_ptr = dump_file;
-
 	dump_file->barker = cpu_to_le32(IWL_FW_ERROR_DUMP_BARKER);
 	dump_data = (void *)dump_file->data;
 	dump_file->file_len = cpu_to_le32(size);
@@ -1828,47 +1823,27 @@ _iwl_fw_error_ini_dump(struct iwl_fw_runtime *fwrt,
 	return dump_file;
 }
 
-void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
+static void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 {
-	struct iwl_fw_dump_ptrs *fw_error_dump;
+	struct iwl_fw_dump_ptrs fw_error_dump = {};
 	struct iwl_fw_error_dump_file *dump_file;
 	struct scatterlist *sg_dump_data;
 	u32 file_len;
 	u32 dump_mask = fwrt->fw->dbg.dump_mask;
 
-	IWL_DEBUG_INFO(fwrt, "WRT dump start\n");
-
-	/* there's no point in fw dump if the bus is dead */
-	if (test_bit(STATUS_TRANS_DEAD, &fwrt->trans->status)) {
-		IWL_ERR(fwrt, "Skip fw error dump since bus is dead\n");
-		goto out;
-	}
-
-	fw_error_dump = kzalloc(sizeof(*fw_error_dump), GFP_KERNEL);
-	if (!fw_error_dump)
-		goto out;
-
-	if (fwrt->trans->ini_valid)
-		dump_file = _iwl_fw_error_ini_dump(fwrt, fw_error_dump);
-	else
-		dump_file = _iwl_fw_error_dump(fwrt, fw_error_dump);
-
-	if (!dump_file) {
-		kfree(fw_error_dump);
+	dump_file = iwl_fw_error_dump_file(fwrt, &fw_error_dump);
+	if (!dump_file)
 		goto out;
-	}
 
 	if (!fwrt->trans->ini_valid && fwrt->dump.monitor_only)
 		dump_mask &= IWL_FW_ERROR_DUMP_FW_MONITOR;
 
-	if (!fwrt->trans->ini_valid)
-		fw_error_dump->trans_ptr =
-			iwl_trans_dump_data(fwrt->trans, dump_mask);
-
+	fw_error_dump.trans_ptr = iwl_trans_dump_data(fwrt->trans, dump_mask);
 	file_len = le32_to_cpu(dump_file->file_len);
-	fw_error_dump->fwrt_len = file_len;
-	if (fw_error_dump->trans_ptr) {
-		file_len += fw_error_dump->trans_ptr->len;
+	fw_error_dump.fwrt_len = file_len;
+
+	if (fw_error_dump.trans_ptr) {
+		file_len += fw_error_dump.trans_ptr->len;
 		dump_file->file_len = cpu_to_le32(file_len);
 	}
 
@@ -1876,27 +1851,49 @@ void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt)
 	if (sg_dump_data) {
 		sg_pcopy_from_buffer(sg_dump_data,
 				     sg_nents(sg_dump_data),
-				     fw_error_dump->fwrt_ptr,
-				     fw_error_dump->fwrt_len, 0);
-		if (fw_error_dump->trans_ptr)
+				     fw_error_dump.fwrt_ptr,
+				     fw_error_dump.fwrt_len, 0);
+		if (fw_error_dump.trans_ptr)
 			sg_pcopy_from_buffer(sg_dump_data,
 					     sg_nents(sg_dump_data),
-					     fw_error_dump->trans_ptr->data,
-					     fw_error_dump->trans_ptr->len,
-					     fw_error_dump->fwrt_len);
+					     fw_error_dump.trans_ptr->data,
+					     fw_error_dump.trans_ptr->len,
+					     fw_error_dump.fwrt_len);
 		dev_coredumpsg(fwrt->trans->dev, sg_dump_data, file_len,
 			       GFP_KERNEL);
 	}
-	vfree(fw_error_dump->fwrt_ptr);
-	vfree(fw_error_dump->trans_ptr);
-	kfree(fw_error_dump);
+	vfree(fw_error_dump.fwrt_ptr);
+	vfree(fw_error_dump.trans_ptr);
 
 out:
 	iwl_fw_free_dump_desc(fwrt);
 	clear_bit(IWL_FWRT_STATUS_DUMPING, &fwrt->status);
-	IWL_DEBUG_INFO(fwrt, "WRT dump done\n");
 }
-IWL_EXPORT_SYMBOL(iwl_fw_error_dump);
+
+static void iwl_fw_error_ini_dump(struct iwl_fw_runtime *fwrt)
+{
+	struct iwl_fw_error_dump_file *dump_file;
+	struct scatterlist *sg_dump_data;
+	u32 file_len;
+
+	dump_file = iwl_fw_error_ini_dump_file(fwrt);
+	if (!dump_file)
+		goto out;
+
+	file_len = le32_to_cpu(dump_file->file_len);
+
+	sg_dump_data = alloc_sgtable(file_len);
+	if (sg_dump_data) {
+		sg_pcopy_from_buffer(sg_dump_data, sg_nents(sg_dump_data),
+				     dump_file, file_len, 0);
+		dev_coredumpsg(fwrt->trans->dev, sg_dump_data, file_len,
+			       GFP_KERNEL);
+	}
+	vfree(dump_file);
+out:
+	fwrt->dump.ini_trig_id = IWL_FW_TRIGGER_ID_INVALID;
+	clear_bit(IWL_FWRT_STATUS_DUMPING, &fwrt->status);
+}
 
 const struct iwl_fw_dump_desc iwl_dump_desc_assert = {
 	.trig_desc = {
@@ -1910,6 +1907,17 @@ int iwl_fw_dbg_collect_desc(struct iwl_fw_runtime *fwrt,
 			    bool monitor_only,
 			    unsigned int delay)
 {
+	u32 trig_type = le32_to_cpu(desc->trig_desc.type);
+	int ret;
+
+	if (fwrt->trans->ini_valid) {
+		ret = iwl_fw_dbg_ini_collect(fwrt, trig_type);
+		if (!ret)
+			iwl_fw_free_dump_desc(fwrt);
+
+		return ret;
+	}
+
 	if (test_and_set_bit(IWL_FWRT_STATUS_DUMPING, &fwrt->status))
 		return -EBUSY;
 
@@ -1955,10 +1963,10 @@ int iwl_fw_dbg_error_collect(struct iwl_fw_runtime *fwrt,
 }
 IWL_EXPORT_SYMBOL(iwl_fw_dbg_error_collect);
 
-int _iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
-			enum iwl_fw_dbg_trigger trig,
-			const char *str, size_t len,
-			struct iwl_fw_dbg_trigger_tlv *trigger)
+int iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
+		       enum iwl_fw_dbg_trigger trig,
+		       const char *str, size_t len,
+		       struct iwl_fw_dbg_trigger_tlv *trigger)
 {
 	struct iwl_fw_dump_desc *desc;
 	unsigned int delay = 0;
@@ -1995,50 +2003,64 @@ int _iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
 
 	return iwl_fw_dbg_collect_desc(fwrt, desc, monitor_only, delay);
 }
-IWL_EXPORT_SYMBOL(_iwl_fw_dbg_collect);
+IWL_EXPORT_SYMBOL(iwl_fw_dbg_collect);
 
-int iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
-		       u32 id, const char *str, size_t len)
+int _iwl_fw_dbg_ini_collect(struct iwl_fw_runtime *fwrt,
+			    enum iwl_fw_ini_trigger_id id)
 {
-	struct iwl_fw_dump_desc *desc;
 	struct iwl_fw_ini_active_triggers *active;
 	u32 occur, delay;
 
-	if (!fwrt->trans->ini_valid)
-		return _iwl_fw_dbg_collect(fwrt, id, str, len, NULL);
+	if (WARN_ON(!iwl_fw_ini_trigger_on(fwrt, id)))
+		return -EINVAL;
 
-	if (id == FW_DBG_TRIGGER_USER)
-		id = IWL_FW_TRIGGER_ID_USER_TRIGGER;
+	if (test_and_set_bit(IWL_FWRT_STATUS_DUMPING, &fwrt->status))
+		return -EBUSY;
 
 	active = &fwrt->dump.active_trigs[id];
-
-	if (WARN_ON(!active->active))
-		return -EINVAL;
-
 	delay = le32_to_cpu(active->trig->dump_delay);
 	occur = le32_to_cpu(active->trig->occurrences);
 	if (!occur)
 		return 0;
 
+	active->trig->occurrences = cpu_to_le32(--occur);
+
 	if (le32_to_cpu(active->trig->force_restart)) {
 		IWL_WARN(fwrt, "Force restart: trigger %d fired.\n", id);
 		iwl_force_nmi(fwrt->trans);
 		return 0;
 	}
 
-	desc = kzalloc(sizeof(*desc) + len, GFP_ATOMIC);
-	if (!desc)
-		return -ENOMEM;
+	fwrt->dump.ini_trig_id = id;
 
-	active->trig->occurrences = cpu_to_le32(--occur);
+	IWL_WARN(fwrt, "Collecting data: ini trigger %d fired.\n", id);
 
-	desc->len = len;
-	desc->trig_desc.type = cpu_to_le32(id);
-	memcpy(desc->trig_desc.data, str, len);
+	schedule_delayed_work(&fwrt->dump.wk, usecs_to_jiffies(delay));
 
-	return iwl_fw_dbg_collect_desc(fwrt, desc, true, delay);
+	return 0;
 }
-IWL_EXPORT_SYMBOL(iwl_fw_dbg_collect);
+IWL_EXPORT_SYMBOL(_iwl_fw_dbg_ini_collect);
+
+int iwl_fw_dbg_ini_collect(struct iwl_fw_runtime *fwrt, u32 legacy_trigger_id)
+{
+	int id;
+
+	switch (legacy_trigger_id) {
+	case FW_DBG_TRIGGER_FW_ASSERT:
+	case FW_DBG_TRIGGER_ALIVE_TIMEOUT:
+	case FW_DBG_TRIGGER_DRIVER:
+		id = IWL_FW_TRIGGER_ID_FW_ASSERT;
+		break;
+	case FW_DBG_TRIGGER_USER:
+		id = IWL_FW_TRIGGER_ID_USER_TRIGGER;
+		break;
+	default:
+		return -EIO;
+	}
+
+	return _iwl_fw_dbg_ini_collect(fwrt, id);
+}
+IWL_EXPORT_SYMBOL(iwl_fw_dbg_ini_collect);
 
 int iwl_fw_dbg_collect_trig(struct iwl_fw_runtime *fwrt,
 			    struct iwl_fw_dbg_trigger_tlv *trigger,
@@ -2066,8 +2088,8 @@ int iwl_fw_dbg_collect_trig(struct iwl_fw_runtime *fwrt,
 		len = strlen(buf) + 1;
 	}
 
-	ret = _iwl_fw_dbg_collect(fwrt, le32_to_cpu(trigger->id), buf, len,
-				  trigger);
+	ret = iwl_fw_dbg_collect(fwrt, le32_to_cpu(trigger->id), buf, len,
+				 trigger);
 
 	if (ret)
 		return ret;
@@ -2141,9 +2163,20 @@ void iwl_fw_dbg_collect_sync(struct iwl_fw_runtime *fwrt)
 		return;
 	}
 
+	/* there's no point in fw dump if the bus is dead */
+	if (test_bit(STATUS_TRANS_DEAD, &fwrt->trans->status)) {
+		IWL_ERR(fwrt, "Skip fw error dump since bus is dead\n");
+		return;
+	}
+
 	iwl_fw_dbg_stop_recording(fwrt, &params);
 
-	iwl_fw_error_dump(fwrt);
+	IWL_DEBUG_INFO(fwrt, "WRT dump start\n");
+	if (fwrt->trans->ini_valid)
+		iwl_fw_error_ini_dump(fwrt);
+	else
+		iwl_fw_error_dump(fwrt);
+	IWL_DEBUG_INFO(fwrt, "WRT dump done\n");
 
 	/* start recording again if the firmware is not crashed */
 	if (!test_bit(STATUS_FW_ERROR, &fwrt->trans->status) &&
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index a199056234d3..13cb164a4fb9 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -108,18 +108,17 @@ static inline void iwl_fw_free_dump_desc(struct iwl_fw_runtime *fwrt)
 	fwrt->dump.umac_err_id = 0;
 }
 
-void iwl_fw_error_dump(struct iwl_fw_runtime *fwrt);
 int iwl_fw_dbg_collect_desc(struct iwl_fw_runtime *fwrt,
 			    const struct iwl_fw_dump_desc *desc,
 			    bool monitor_only, unsigned int delay);
 int iwl_fw_dbg_error_collect(struct iwl_fw_runtime *fwrt,
 			     enum iwl_fw_dbg_trigger trig_type);
-int _iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
-			enum iwl_fw_dbg_trigger trig,
-			const char *str, size_t len,
-			struct iwl_fw_dbg_trigger_tlv *trigger);
+int _iwl_fw_dbg_ini_collect(struct iwl_fw_runtime *fwrt,
+			    enum iwl_fw_ini_trigger_id id);
+int iwl_fw_dbg_ini_collect(struct iwl_fw_runtime *fwrt, u32 legacy_trigger_id);
 int iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
-		       u32 id, const char *str, size_t len);
+		       enum iwl_fw_dbg_trigger trig, const char *str,
+		       size_t len, struct iwl_fw_dbg_trigger_tlv *trigger);
 int iwl_fw_dbg_collect_trig(struct iwl_fw_runtime *fwrt,
 			    struct iwl_fw_dbg_trigger_tlv *trigger,
 			    const char *fmt, ...) __printf(3, 4);
@@ -229,10 +228,8 @@ iwl_fw_ini_trigger_on(struct iwl_fw_runtime *fwrt,
 	struct iwl_fw_ini_trigger *trig;
 	u32 usec;
 
-
-
-	if (!fwrt->trans->ini_valid || id >= IWL_FW_TRIGGER_ID_NUM ||
-	    !fwrt->dump.active_trigs[id].active)
+	if (!fwrt->trans->ini_valid || id == IWL_FW_TRIGGER_ID_INVALID ||
+	    id >= IWL_FW_TRIGGER_ID_NUM || !fwrt->dump.active_trigs[id].active)
 		return false;
 
 	trig = fwrt->dump.active_trigs[id].trig;
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
index a5fe1a8ca426..88a558e082a3 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/runtime.h
@@ -145,6 +145,7 @@ struct iwl_fw_runtime {
 		u32 lmac_err_id[MAX_NUM_LMAC];
 		u32 umac_err_id;
 		void *fifo_iter;
+		enum iwl_fw_ini_trigger_id ini_trig_id;
 	} dump;
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	struct {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 776b24f54200..472d330661d3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1349,7 +1349,7 @@ static ssize_t iwl_dbgfs_fw_dbg_collect_write(struct iwl_mvm *mvm,
 		return 0;
 
 	iwl_fw_dbg_collect(&mvm->fwrt, FW_DBG_TRIGGER_USER, buf,
-			   (count - 1));
+			   (count - 1), NULL);
 
 	iwl_mvm_unref(mvm, IWL_MVM_REF_PRPH_WRITE);
 
-- 
2.20.1

