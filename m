Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41967 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517AbcAGMsL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 07:48:11 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 19/21] iwlwifi: mvm: constify the parameters of a few functions in fw-dbg.c
Date: Thu,  7 Jan 2016 14:47:39 +0200
Message-Id: <1452170861-10060-19-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160107_134820_938871_E78CF9DE)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The debug functions of fw-dbg.c don't really need to modify
the trigger and the description they receive as a parameter.
Constify the pointers.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h  | 4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c | 8 ++++----
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h | 6 +++---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h    | 6 +++---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 2 +-
 5 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 81b7cb7..82fb3a9 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -663,7 +663,7 @@ struct iwl_trans_ops {
 	void (*resume)(struct iwl_trans *trans);
 
 	struct iwl_trans_dump_data *(*dump_data)(struct iwl_trans *trans,
-						 struct iwl_fw_dbg_trigger_tlv
+						 const struct iwl_fw_dbg_trigger_tlv
 						 *trigger);
 };
 
@@ -966,7 +966,7 @@ static inline void iwl_trans_resume(struct iwl_trans *trans)
 
 static inline struct iwl_trans_dump_data *
 iwl_trans_dump_data(struct iwl_trans *trans,
-		    struct iwl_fw_dbg_trigger_tlv *trigger)
+		    const struct iwl_fw_dbg_trigger_tlv *trigger)
 {
 	if (!trans->ops->dump_data)
 		return NULL;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
index 59450f1..b3bc212 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
@@ -681,15 +681,15 @@ dump_trans_data:
 	clear_bit(IWL_MVM_STATUS_DUMPING_FW_LOG, &mvm->status);
 }
 
-struct iwl_mvm_dump_desc iwl_mvm_dump_desc_assert = {
+const struct iwl_mvm_dump_desc iwl_mvm_dump_desc_assert = {
 	.trig_desc = {
 		.type = cpu_to_le32(FW_DBG_TRIGGER_FW_ASSERT),
 	},
 };
 
 int iwl_mvm_fw_dbg_collect_desc(struct iwl_mvm *mvm,
-				struct iwl_mvm_dump_desc *desc,
-				struct iwl_fw_dbg_trigger_tlv *trigger)
+				const struct iwl_mvm_dump_desc *desc,
+				const struct iwl_fw_dbg_trigger_tlv *trigger)
 {
 	unsigned int delay = 0;
 
@@ -715,7 +715,7 @@ int iwl_mvm_fw_dbg_collect_desc(struct iwl_mvm *mvm,
 
 int iwl_mvm_fw_dbg_collect(struct iwl_mvm *mvm, enum iwl_fw_dbg_trigger trig,
 			   const char *str, size_t len,
-			   struct iwl_fw_dbg_trigger_tlv *trigger)
+			   const struct iwl_fw_dbg_trigger_tlv *trigger)
 {
 	struct iwl_mvm_dump_desc *desc;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h
index 08148b2..f7dff76 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h
@@ -72,11 +72,11 @@
 void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm);
 void iwl_mvm_free_fw_dump_desc(struct iwl_mvm *mvm);
 int iwl_mvm_fw_dbg_collect_desc(struct iwl_mvm *mvm,
-				struct iwl_mvm_dump_desc *desc,
-				struct iwl_fw_dbg_trigger_tlv *trigger);
+				const struct iwl_mvm_dump_desc *desc,
+				const struct iwl_fw_dbg_trigger_tlv *trigger);
 int iwl_mvm_fw_dbg_collect(struct iwl_mvm *mvm, enum iwl_fw_dbg_trigger trig,
 			   const char *str, size_t len,
-			   struct iwl_fw_dbg_trigger_tlv *trigger);
+			   const struct iwl_fw_dbg_trigger_tlv *trigger);
 int iwl_mvm_fw_dbg_collect_trig(struct iwl_mvm *mvm,
 				struct iwl_fw_dbg_trigger_tlv *trigger,
 				const char *fmt, ...) __printf(3, 4);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 7517dc13..5f3ac8c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -157,7 +157,7 @@ struct iwl_mvm_dump_desc {
 	struct iwl_fw_error_dump_trigger_desc trig_desc;
 };
 
-extern struct iwl_mvm_dump_desc iwl_mvm_dump_desc_assert;
+extern const struct iwl_mvm_dump_desc iwl_mvm_dump_desc_assert;
 
 struct iwl_mvm_phy_ctxt {
 	u16 id;
@@ -732,8 +732,8 @@ struct iwl_mvm {
 	s8 restart_fw;
 	u8 fw_dbg_conf;
 	struct delayed_work fw_dump_wk;
-	struct iwl_mvm_dump_desc *fw_dump_desc;
-	struct iwl_fw_dbg_trigger_tlv *fw_dump_trig;
+	const struct iwl_mvm_dump_desc *fw_dump_desc;
+	const struct iwl_fw_dbg_trigger_tlv *fw_dump_trig;
 
 #ifdef CONFIG_IWLWIFI_LEDS
 	struct led_classdev led;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index d44e7af..3a43109 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2364,7 +2364,7 @@ iwl_trans_pcie_dump_monitor(struct iwl_trans *trans,
 
 static struct iwl_trans_dump_data
 *iwl_trans_pcie_dump_data(struct iwl_trans *trans,
-			  struct iwl_fw_dbg_trigger_tlv *trigger)
+			  const struct iwl_fw_dbg_trigger_tlv *trigger)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_fw_error_dump_data *data;
-- 
2.5.0

