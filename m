Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24109 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293AbbCATcj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 14:32:39 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 24/31] iwlwifi: mvm: add the cause of the firmware dump in the dump
Date: Sun,  1 Mar 2015 21:31:37 +0200
Message-Id: <1425238304-498-24-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_203418_108793_6B2526DE)
In-Reply-To: <1425238186.30202.5.camel@egrumbacBox>
References: <1425238186.30202.5.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that the firmware dump can be triggered by events in
the code and not only the user or an firmware ASSERT, we
need a way to know why the firmware dump was triggered.
Add a section in the dump file for that.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h | 13 ++++++++
 drivers/net/wireless/iwlwifi/mvm/debugfs.c       |  2 +-
 drivers/net/wireless/iwlwifi/mvm/fw.c            | 35 ++++++++++++++++++---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c      | 40 +++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h           | 28 ++++++++++++++---
 drivers/net/wireless/iwlwifi/mvm/ops.c           |  2 +-
 6 files changed, 108 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
index fabddd8..b733c58 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h
@@ -82,6 +82,8 @@
  *	sections like this in a single file.
  * @IWL_FW_ERROR_DUMP_FH_REGS: range of FH registers
  * @IWL_FW_ERROR_DUMP_MEM: chunk of memory
+ * @IWL_FW_ERROR_DUMP_ERROR_INFO: description of what triggered this dump.
+ *	Structured as &struct iwl_fw_error_dump_trigger_desc.
  */
 enum iwl_fw_error_dump_type {
 	/* 0 is deprecated */
@@ -94,6 +96,7 @@ enum iwl_fw_error_dump_type {
 	IWL_FW_ERROR_DUMP_TXF = 7,
 	IWL_FW_ERROR_DUMP_FH_REGS = 8,
 	IWL_FW_ERROR_DUMP_MEM = 9,
+	IWL_FW_ERROR_DUMP_ERROR_INFO = 10,
 
 	IWL_FW_ERROR_DUMP_MAX,
 };
@@ -248,4 +251,14 @@ enum iwl_fw_dbg_trigger {
 	FW_DBG_TRIGGER_MAX,
 };
 
+/**
+ * struct iwl_fw_error_dump_trigger_desc - describes the trigger condition
+ * @type: %enum iwl_fw_dbg_trigger
+ * @data: raw data about what happened
+ */
+struct iwl_fw_error_dump_trigger_desc {
+	__le32 type;
+	u8 data[];
+};
+
 #endif /* __fw_error_dump_h__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index f890d5e..8cbe77d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -985,7 +985,7 @@ static ssize_t iwl_dbgfs_fw_dbg_collect_write(struct iwl_mvm *mvm,
 	if (ret)
 		return ret;
 
-	iwl_mvm_fw_dbg_collect(mvm, FW_DBG_TRIGGER_USER, 0);
+	iwl_mvm_fw_dbg_collect(mvm, FW_DBG_TRIGGER_USER, NULL, 0, 0);
 
 	iwl_mvm_unref(mvm, IWL_MVM_REF_PRPH_WRITE);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 8d684d5..64e9039 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -479,13 +479,20 @@ exit:
 	iwl_free_resp(&cmd);
 }
 
-int iwl_mvm_fw_dbg_collect(struct iwl_mvm *mvm, enum iwl_fw_dbg_trigger trig,
-			   unsigned int delay)
+int iwl_mvm_fw_dbg_collect_desc(struct iwl_mvm *mvm,
+				struct iwl_mvm_dump_desc *desc,
+				unsigned int delay)
 {
 	if (test_and_set_bit(IWL_MVM_STATUS_DUMPING_FW_LOG, &mvm->status))
 		return -EBUSY;
 
-	IWL_WARN(mvm, "Collecting data: trigger %d fired.\n", trig);
+	if (WARN_ON(mvm->fw_dump_desc))
+		iwl_mvm_free_fw_dump_desc(mvm);
+
+	IWL_WARN(mvm, "Collecting data: trigger %d fired.\n",
+		 le32_to_cpu(desc->trig_desc.type));
+
+	mvm->fw_dump_desc = desc;
 
 	/* stop recording */
 	if (mvm->cfg->device_family == IWL_DEVICE_FAMILY_7000) {
@@ -501,8 +508,25 @@ int iwl_mvm_fw_dbg_collect(struct iwl_mvm *mvm, enum iwl_fw_dbg_trigger trig,
 	return 0;
 }
 
+int iwl_mvm_fw_dbg_collect(struct iwl_mvm *mvm, enum iwl_fw_dbg_trigger trig,
+			   const char *str, size_t len, unsigned int delay)
+{
+	struct iwl_mvm_dump_desc *desc;
+
+	desc = kzalloc(sizeof(*desc) + len, GFP_ATOMIC);
+	if (!desc)
+		return -ENOMEM;
+
+	desc->len = len;
+	desc->trig_desc.type = cpu_to_le32(trig);
+	memcpy(desc->trig_desc.data, str, len);
+
+	return iwl_mvm_fw_dbg_collect_desc(mvm, desc, delay);
+}
+
 int iwl_mvm_fw_dbg_collect_trig(struct iwl_mvm *mvm,
-				struct iwl_fw_dbg_trigger_tlv *trigger)
+				struct iwl_fw_dbg_trigger_tlv *trigger,
+				const char *str, size_t len)
 {
 	unsigned int delay = msecs_to_jiffies(le32_to_cpu(trigger->stop_delay));
 	u16 occurrences = le16_to_cpu(trigger->occurrences);
@@ -511,7 +535,8 @@ int iwl_mvm_fw_dbg_collect_trig(struct iwl_mvm *mvm,
 	if (!occurrences)
 		return 0;
 
-	ret = iwl_mvm_fw_dbg_collect(mvm, le32_to_cpu(trigger->id), delay);
+	ret = iwl_mvm_fw_dbg_collect(mvm, le32_to_cpu(trigger->id), str,
+				     len, delay);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index a5261a4..3b6b9f6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -886,12 +886,23 @@ static void iwl_mvm_dump_fifos(struct iwl_mvm *mvm,
 	iwl_trans_release_nic_access(mvm->trans, &flags);
 }
 
+void iwl_mvm_free_fw_dump_desc(struct iwl_mvm *mvm)
+{
+	if (mvm->fw_dump_desc == &iwl_mvm_dump_desc_assert ||
+	    !mvm->fw_dump_desc)
+		return;
+
+	kfree(mvm->fw_dump_desc);
+	mvm->fw_dump_desc = NULL;
+}
+
 void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 {
 	struct iwl_fw_error_dump_file *dump_file;
 	struct iwl_fw_error_dump_data *dump_data;
 	struct iwl_fw_error_dump_info *dump_info;
 	struct iwl_fw_error_dump_mem *dump_mem;
+	struct iwl_fw_error_dump_trigger_desc *dump_trig;
 	struct iwl_mvm_dump_ptrs *fw_error_dump;
 	u32 sram_len, sram_ofs;
 	u32 file_len, fifo_data_len = 0;
@@ -961,6 +972,10 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		   fifo_data_len +
 		   sizeof(*dump_info);
 
+	if (mvm->fw_dump_desc)
+		file_len += sizeof(*dump_data) + sizeof(*dump_trig) +
+			    mvm->fw_dump_desc->len;
+
 	/* Make room for the SMEM, if it exists */
 	if (smem_len)
 		file_len += sizeof(*dump_data) + sizeof(*dump_mem) + smem_len;
@@ -972,6 +987,7 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	dump_file = vzalloc(file_len);
 	if (!dump_file) {
 		kfree(fw_error_dump);
+		iwl_mvm_free_fw_dump_desc(mvm);
 		return;
 	}
 
@@ -1000,6 +1016,19 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	if (test_bit(STATUS_FW_ERROR, &mvm->trans->status))
 		iwl_mvm_dump_fifos(mvm, &dump_data);
 
+	if (mvm->fw_dump_desc) {
+		dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_ERROR_INFO);
+		dump_data->len = cpu_to_le32(sizeof(*dump_trig) +
+					     mvm->fw_dump_desc->len);
+		dump_trig = (void *)dump_data->data;
+		memcpy(dump_trig, &mvm->fw_dump_desc->trig_desc,
+		       sizeof(*dump_trig) + mvm->fw_dump_desc->len);
+
+		/* now we can free this copy */
+		iwl_mvm_free_fw_dump_desc(mvm);
+		dump_data = iwl_fw_error_next_data(dump_data);
+	}
+
 	dump_data->type = cpu_to_le32(IWL_FW_ERROR_DUMP_MEM);
 	dump_data->len = cpu_to_le32(sram_len + sizeof(*dump_mem));
 	dump_mem = (void *)dump_data->data;
@@ -1042,14 +1071,22 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	clear_bit(IWL_MVM_STATUS_DUMPING_FW_LOG, &mvm->status);
 }
 
+struct iwl_mvm_dump_desc iwl_mvm_dump_desc_assert = {
+	.trig_desc = {
+		.type = cpu_to_le32(FW_DBG_TRIGGER_FW_ASSERT),
+	},
+};
+
 static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 {
 	/* clear the D3 reconfig, we only need it to avoid dumping a
 	 * firmware coredump on reconfiguration, we shouldn't do that
 	 * on D3->D0 transition
 	 */
-	if (!test_and_clear_bit(IWL_MVM_STATUS_D3_RECONFIG, &mvm->status))
+	if (!test_and_clear_bit(IWL_MVM_STATUS_D3_RECONFIG, &mvm->status)) {
+		mvm->fw_dump_desc = &iwl_mvm_dump_desc_assert;
 		iwl_mvm_fw_error_dump(mvm);
+	}
 
 	/* cleanup all stale references (scan, roc), but keep the
 	 * ucode_down ref until reconfig is complete
@@ -1261,6 +1298,7 @@ static void iwl_mvm_mac_stop(struct ieee80211_hw *hw)
 	flush_work(&mvm->d0i3_exit_work);
 	flush_work(&mvm->async_handlers_wk);
 	cancel_delayed_work_sync(&mvm->fw_dump_wk);
+	iwl_mvm_free_fw_dump_desc(mvm);
 
 	mutex_lock(&mvm->mutex);
 	__iwl_mvm_mac_stop(mvm);
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 4068139..f4ecd1b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -146,6 +146,19 @@ struct iwl_mvm_dump_ptrs {
 	u32 op_mode_len;
 };
 
+/**
+ * struct iwl_mvm_dump_desc - describes the dump
+ * @len: length of trig_desc->data
+ * @trig_desc: the description of the dump
+ */
+struct iwl_mvm_dump_desc {
+	size_t len;
+	/* must be last */
+	struct iwl_fw_error_dump_trigger_desc trig_desc;
+};
+
+extern struct iwl_mvm_dump_desc iwl_mvm_dump_desc_assert;
+
 struct iwl_mvm_phy_ctxt {
 	u16 id;
 	u16 color;
@@ -706,6 +719,7 @@ struct iwl_mvm {
 	s8 restart_fw;
 	u8 fw_dbg_conf;
 	struct delayed_work fw_dump_wk;
+	struct iwl_mvm_dump_desc *fw_dump_desc;
 
 #ifdef CONFIG_IWLWIFI_LEDS
 	struct led_classdev led;
@@ -1415,9 +1429,14 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm);
 
 int iwl_mvm_start_fw_dbg_conf(struct iwl_mvm *mvm, u8 id);
 int iwl_mvm_fw_dbg_collect(struct iwl_mvm *mvm, enum iwl_fw_dbg_trigger trig,
-			   unsigned int delay);
+			   const char *str, size_t len, unsigned int delay);
+int iwl_mvm_fw_dbg_collect_desc(struct iwl_mvm *mvm,
+				struct iwl_mvm_dump_desc *desc,
+				unsigned int delay);
+void iwl_mvm_free_fw_dump_desc(struct iwl_mvm *mvm);
 int iwl_mvm_fw_dbg_collect_trig(struct iwl_mvm *mvm,
-				struct iwl_fw_dbg_trigger_tlv *trigger);
+				struct iwl_fw_dbg_trigger_tlv *trigger,
+				const char *str, size_t len);
 
 static inline bool
 iwl_fw_dbg_trigger_vif_match(struct iwl_fw_dbg_trigger_tlv *trig,
@@ -1451,7 +1470,8 @@ iwl_fw_dbg_trigger_check_stop(struct iwl_mvm *mvm,
 static inline void
 iwl_fw_dbg_trigger_simple_stop(struct iwl_mvm *mvm,
 			       struct ieee80211_vif *vif,
-			       enum iwl_fw_dbg_trigger trig)
+			       enum iwl_fw_dbg_trigger trig,
+			       const char *str, size_t len)
 {
 	struct iwl_fw_dbg_trigger_tlv *trigger;
 
@@ -1462,7 +1482,7 @@ iwl_fw_dbg_trigger_simple_stop(struct iwl_mvm *mvm,
 	if (!iwl_fw_dbg_trigger_check_stop(mvm, vif, trigger))
 		return;
 
-	iwl_mvm_fw_dbg_collect_trig(mvm, trigger);
+	iwl_mvm_fw_dbg_collect_trig(mvm, trigger, str, len);
 }
 
 #endif /* __IWL_MVM_H__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 96a4a15..f1c5751 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -879,7 +879,7 @@ void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error)
 	 * can't recover this since we're already half suspended.
 	 */
 	if (!mvm->restart_fw && fw_error) {
-		iwl_mvm_fw_dbg_collect(mvm, FW_DBG_TRIGGER_FW_ASSERT, 0);
+		iwl_mvm_fw_dbg_collect_desc(mvm, &iwl_mvm_dump_desc_assert, 0);
 	} else if (test_and_set_bit(IWL_MVM_STATUS_IN_HW_RESTART,
 				    &mvm->status)) {
 		struct iwl_mvm_reprobe *reprobe;
-- 
1.9.1

