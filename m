Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:60163 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306AbcC3OGZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:06:25 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luca Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 36/43] iwlwifi: mvm: add a scan timeout for regular scans
Date: Wed, 30 Mar 2016 17:05:08 +0300
Message-Id: <1459346715-7954-36-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160630_773075_34CFE8E1)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

If something goes wrong with the firmware and we never get a scan
complete notification, we stay stuck forever.  In order to avoid this
situation, add a timeout and trigger an NMI if it expires before
receiving the notification., so we can clean things up.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  5 +++++
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 21 +++++++++++++++++++++
 3 files changed, 28 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index cd5f16e..2d685e0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -710,6 +710,7 @@ struct iwl_mvm {
 	struct iwl_mcast_filter_cmd *mcast_filter_cmd;
 	enum iwl_mvm_scan_type scan_type;
 	enum iwl_mvm_sched_scan_pass_all_states sched_scan_pass_all;
+	struct timer_list scan_timer;
 
 	/* max number of simultaneous scans the FW supports */
 	unsigned int max_scans;
@@ -1314,6 +1315,7 @@ int iwl_mvm_scan_size(struct iwl_mvm *mvm);
 int iwl_mvm_scan_stop(struct iwl_mvm *mvm, int type, bool notify);
 int iwl_mvm_max_scan_ie_len(struct iwl_mvm *mvm);
 void iwl_mvm_report_scan_aborted(struct iwl_mvm *mvm);
+void iwl_mvm_scan_timeout(unsigned long data);
 
 /* Scheduled scan */
 void iwl_mvm_rx_lmac_scan_complete_notif(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index cb00926..656541c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -728,6 +728,9 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
 	iwl_mvm_tof_init(mvm);
 
+	setup_timer(&mvm->scan_timer, iwl_mvm_scan_timeout,
+		    (unsigned long)mvm);
+
 	return op_mode;
 
  out_unregister:
@@ -783,6 +786,8 @@ static void iwl_op_mode_mvm_stop(struct iwl_op_mode *op_mode)
 
 	iwl_mvm_tof_clean(mvm);
 
+	del_timer_sync(&mvm->scan_timer);
+
 	mutex_destroy(&mvm->mutex);
 	mutex_destroy(&mvm->d0i3_suspend_mutex);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 25b007c..c1d1be9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -70,6 +70,7 @@
 
 #include "mvm.h"
 #include "fw-api-scan.h"
+#include "iwl-io.h"
 
 #define IWL_DENSE_EBS_SCAN_RATIO 5
 #define IWL_SPARSE_EBS_SCAN_RATIO 1
@@ -398,6 +399,10 @@ void iwl_mvm_rx_lmac_scan_complete_notif(struct iwl_mvm *mvm,
 		ieee80211_scan_completed(mvm->hw,
 				scan_notif->status == IWL_SCAN_OFFLOAD_ABORTED);
 		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
+		del_timer(&mvm->scan_timer);
+	} else {
+		IWL_ERR(mvm,
+			"got scan complete notification but no scan is running\n");
 	}
 
 	mvm->last_ebs_successful =
@@ -1217,6 +1222,18 @@ static int iwl_mvm_check_running_scans(struct iwl_mvm *mvm, int type)
 	return -EIO;
 }
 
+#define SCAN_TIMEOUT (16 * HZ)
+
+void iwl_mvm_scan_timeout(unsigned long data)
+{
+	struct iwl_mvm *mvm = (struct iwl_mvm *)data;
+
+	IWL_ERR(mvm, "regular scan timed out\n");
+
+	del_timer(&mvm->scan_timer);
+	iwl_force_nmi(mvm->trans);
+}
+
 int iwl_mvm_reg_scan_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			   struct cfg80211_scan_request *req,
 			   struct ieee80211_scan_ies *ies)
@@ -1296,6 +1313,8 @@ int iwl_mvm_reg_scan_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	mvm->scan_status |= IWL_MVM_SCAN_REGULAR;
 	iwl_mvm_ref(mvm, IWL_MVM_REF_SCAN);
 
+	mod_timer(&mvm->scan_timer, jiffies + SCAN_TIMEOUT);
+
 	return 0;
 }
 
@@ -1413,6 +1432,7 @@ void iwl_mvm_rx_umac_scan_complete_notif(struct iwl_mvm *mvm,
 	if (mvm->scan_uid_status[uid] == IWL_MVM_SCAN_REGULAR) {
 		ieee80211_scan_completed(mvm->hw, aborted);
 		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
+		del_timer(&mvm->scan_timer);
 	} else if (mvm->scan_uid_status[uid] == IWL_MVM_SCAN_SCHED) {
 		ieee80211_sched_scan_stopped(mvm->hw);
 		mvm->sched_scan_pass_all = SCHED_SCAN_PASS_ALL_DISABLED;
@@ -1608,6 +1628,7 @@ out:
 		 * to release the scan reference here.
 		 */
 		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
+		del_timer(&mvm->scan_timer);
 		if (notify)
 			ieee80211_scan_completed(mvm->hw, true);
 	} else if (notify) {
-- 
2.5.0

