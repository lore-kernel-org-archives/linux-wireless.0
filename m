Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8579 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755973AbbLAJ71 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 04:59:27 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/41] iwlwifi: mvm: use build-time assertion for fw trigger ID
Date: Tue,  1 Dec 2015 11:58:39 +0200
Message-Id: <1448963947-24302-13-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_105934_416370_D55BCFCD)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The firmware debug trigger ID is always a compile-time constant,
so we can use a build-time assertion to validate that it is in
fact a valid constant.

To make that really guaranteed to work, convert this and the
inline function iwl_fw_dbg_trigger_simple_stop() to macros.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-fw.h  | 11 +++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h | 15 ++++++++-------
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw.h
index 84ec0ce..c6946f1 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw.h
@@ -311,12 +311,15 @@ iwl_fw_dbg_conf_usniffer(const struct iwl_fw *fw, u8 id)
 })
 
 static inline struct iwl_fw_dbg_trigger_tlv*
-iwl_fw_dbg_get_trigger(const struct iwl_fw *fw, u8 id)
+_iwl_fw_dbg_get_trigger(const struct iwl_fw *fw, enum iwl_fw_dbg_trigger id)
 {
-	if (WARN_ON(id >= ARRAY_SIZE(fw->dbg_trigger_tlv)))
-		return NULL;
-
 	return fw->dbg_trigger_tlv[id];
 }
 
+#define iwl_fw_dbg_get_trigger(fw, id) ({			\
+	BUILD_BUG_ON(!__builtin_constant_p(id));		\
+	BUILD_BUG_ON((id) >= FW_DBG_TRIGGER_MAX);		\
+	_iwl_fw_dbg_get_trigger((fw), (id));			\
+})
+
 #endif  /* __iwl_fw_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index aff71d3..347d953 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1524,20 +1524,21 @@ iwl_fw_dbg_trigger_check_stop(struct iwl_mvm *mvm,
 }
 
 static inline void
-iwl_fw_dbg_trigger_simple_stop(struct iwl_mvm *mvm,
-			       struct ieee80211_vif *vif,
-			       enum iwl_fw_dbg_trigger trig)
+_iwl_fw_dbg_trigger_simple_stop(struct iwl_mvm *mvm,
+				struct ieee80211_vif *vif,
+				struct iwl_fw_dbg_trigger_tlv *trigger)
 {
-	struct iwl_fw_dbg_trigger_tlv *trigger;
-
-	if (!iwl_fw_dbg_trigger_enabled(mvm->fw, trig))
+	if (!trigger)
 		return;
 
-	trigger = iwl_fw_dbg_get_trigger(mvm->fw, trig);
 	if (!iwl_fw_dbg_trigger_check_stop(mvm, vif, trigger))
 		return;
 
 	iwl_mvm_fw_dbg_collect_trig(mvm, trigger, NULL);
 }
+#define iwl_fw_dbg_trigger_simple_stop(mvm, vif, trig)	\
+	_iwl_fw_dbg_trigger_simple_stop((mvm), (vif),	\
+					iwl_fw_dbg_get_trigger((mvm)->fw,\
+							       (trig)))
 
 #endif /* __IWL_MVM_H__ */
-- 
2.5.0

