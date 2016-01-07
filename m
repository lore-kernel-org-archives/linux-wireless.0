Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:39244 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490AbcAGMr7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 07:47:59 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Golan Ben-Ami <golan.ben.ami@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/21] iwlwifi: mvm: add a non-trigger window to fw dbg triggers
Date: Thu,  7 Jan 2016 14:47:31 +0200
Message-Id: <1452170861-10060-11-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160107_134813_993294_52E370B5)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben-Ami <golan.ben.ami@intel.com>

Allow the user to configure a non-trigger session - a window
between triggers in which the driver won't collect fw debug data.
This can be useful when the frequent collection of fw data
has an impact on the performance, such as debugging
tx flows.

Signed-off-by: Golan Ben-Ami <golan.ben.ami@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h |  5 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h  | 24 ++++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h     |  3 +++
 3 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
index 8d37e33..84f8aeb 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
@@ -557,6 +557,8 @@ enum iwl_fw_dbg_trigger_vif_type {
  * @start_conf_id: if mode is %IWL_FW_DBG_TRIGGER_START, this defines what
  *	configuration should be applied when the triggers kicks in.
  * @occurrences: number of occurrences. 0 means the trigger will never fire.
+ * @trig_dis_ms: the time, in milliseconds, after an occurrence of this
+ *	trigger in which another occurrence should be ignored.
  */
 struct iwl_fw_dbg_trigger_tlv {
 	__le32 id;
@@ -566,7 +568,8 @@ struct iwl_fw_dbg_trigger_tlv {
 	u8 mode;
 	u8 start_conf_id;
 	__le16 occurrences;
-	__le32 reserved[2];
+	__le16 trig_dis_ms;
+	__le16 reserved[3];
 
 	u8 data[0];
 } __packed;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h
index 461acdf..08148b2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h
@@ -118,6 +118,24 @@ iwl_fw_dbg_trigger_stop_conf_match(struct iwl_mvm *mvm,
 }
 
 static inline bool
+iwl_fw_dbg_no_trig_window(struct iwl_mvm *mvm,
+			  struct iwl_fw_dbg_trigger_tlv *trig)
+{
+	unsigned long wind_jiff =
+		msecs_to_jiffies(le16_to_cpu(trig->trig_dis_ms));
+	u32 id = le32_to_cpu(trig->id);
+
+	/* If this is the first event checked, jump to update start ts */
+	if (mvm->fw_dbg_non_collect_ts_start[id] &&
+	    (time_after(mvm->fw_dbg_non_collect_ts_start[id] + wind_jiff,
+			jiffies)))
+		return true;
+
+	mvm->fw_dbg_non_collect_ts_start[id] = jiffies;
+	return false;
+}
+
+static inline bool
 iwl_fw_dbg_trigger_check_stop(struct iwl_mvm *mvm,
 			      struct ieee80211_vif *vif,
 			      struct iwl_fw_dbg_trigger_tlv *trig)
@@ -125,6 +143,12 @@ iwl_fw_dbg_trigger_check_stop(struct iwl_mvm *mvm,
 	if (vif && !iwl_fw_dbg_trigger_vif_match(trig, vif))
 		return false;
 
+	if (iwl_fw_dbg_no_trig_window(mvm, trig)) {
+		IWL_WARN(mvm, "Trigger %d occurred while no-collect window.\n",
+			 trig->id);
+		return false;
+	}
+
 	return iwl_fw_dbg_trigger_stop_conf_match(mvm, trig);
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 287c162..7517dc13 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -658,6 +658,9 @@ struct iwl_mvm {
 	/* max number of simultaneous scans the FW supports */
 	unsigned int max_scans;
 
+	/* ts of the beginning of a non-collect fw dbg data period */
+	unsigned long fw_dbg_non_collect_ts_start[FW_DBG_TRIGGER_MAX - 1];
+
 	/* UMAC scan tracking */
 	u32 scan_uid_status[IWL_MVM_MAX_UMAC_SCANS];
 
-- 
2.5.0

