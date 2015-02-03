Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1142 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933559AbbBCHPH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 02:15:07 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Haim Dreyfuss <haim.dreyfuss@intel.com>,
	David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/19] iwlwifi: mvm: Fix a few EBS error handling bugs
Date: Tue,  3 Feb 2015 09:14:33 +0200
Message-Id: <1422947678-16917-14-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150203_081531_491015_7A54FAEF)
In-Reply-To: <1422947482.30742.8.camel@egrumbacBox>
References: <1422947482.30742.8.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

Last EBS status wasn't set to success in the initialization, which
caused the first scan to be without EBS. Fix that.

When EBS is not enabled by the driver, the FW still sends ebs_status success,
which can override EBS failure state. Consider only EBS failures, to avoid
such override. Last_ebs_success is set back to true upon disconnection.

Last_ebs_success wasn't set in umac scan abort flow, fix that too.

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: David Spinadel <david.spinadel@intel.com>
Reviewed-by: Alexander Bondar <alexander.bondar@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c  |  3 +++
 drivers/net/wireless/iwlwifi/mvm/scan.c | 13 ++++++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index b6181ef..2dffc36 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -568,6 +568,9 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	if (!mvm->scan_cmd)
 		goto out_free;
 
+	/* Set EBS as successful as long as not stated otherwise by the FW. */
+	mvm->last_ebs_successful = true;
+
 	err = iwl_mvm_mac_setup_register(mvm);
 	if (err)
 		goto out_free;
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 3bd5f34..4169e3d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -704,7 +704,8 @@ int iwl_mvm_rx_scan_offload_complete_notif(struct iwl_mvm *mvm,
 		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
 	}
 
-	mvm->last_ebs_successful = !ebs_status;
+	if (ebs_status)
+		mvm->last_ebs_successful = false;
 
 	return 0;
 }
@@ -2025,7 +2026,9 @@ int iwl_mvm_rx_umac_scan_complete_notif(struct iwl_mvm *mvm,
 		       notif->ebs_status == IWL_SCAN_EBS_SUCCESS ?
 				"success" : "failed");
 
-	mvm->last_ebs_successful = !notif->ebs_status;
+	if (notif->ebs_status)
+		mvm->last_ebs_successful = false;
+
 	mvm->scan_uid[uid_idx] = 0;
 
 	if (!sched) {
@@ -2058,10 +2061,14 @@ static bool iwl_scan_umac_done_check(struct iwl_notif_wait_data *notif_wait,
 
 	/*
 	 * Clear scan uid of scans that was aborted from above and completed
-	 * in FW so the RX handler does nothing.
+	 * in FW so the RX handler does nothing. Set last_ebs_successful here if
+	 * needed.
 	 */
 	scan_done->mvm->scan_uid[uid_idx] = 0;
 
+	if (notif->ebs_status)
+		scan_done->mvm->last_ebs_successful = false;
+
 	return !iwl_mvm_find_scan_type(scan_done->mvm, scan_done->type);
 }
 
-- 
1.9.1

