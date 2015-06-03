Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:13470 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113AbbFCHbu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 03:31:50 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/15] iwlwifi: mvm: add inactive state to ebs status
Date: Wed,  3 Jun 2015 10:31:25 +0300
Message-Id: <1433316696-4612-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150603_093154_584975_8105105D)
In-Reply-To: <1433316253.25661.3.camel@intel.com>
References: <1433316253.25661.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Currently EBS status in scan complete notifications is set to
success if EBS wasn't activated. FW will add a special return
value for cases when EBS wasn't activated and we add a print
of this status.

This change is needed for debug only, no behavior changes.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h |  1 +
 drivers/net/wireless/iwlwifi/mvm/scan.c        | 33 +++++++++++++++++++-------
 2 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
index f34cf00..5e4cbdb 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
@@ -294,6 +294,7 @@ enum iwl_scan_ebs_status {
 	IWL_SCAN_EBS_SUCCESS,
 	IWL_SCAN_EBS_FAILED,
 	IWL_SCAN_EBS_CHAN_NOT_FOUND,
+	IWL_SCAN_EBS_INACTIVE,
 };
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 4f4570d..9409237 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -352,6 +352,20 @@ int iwl_mvm_rx_scan_match_found(struct iwl_mvm *mvm,
 	return 0;
 }
 
+static const char *iwl_mvm_ebs_status_str(enum iwl_scan_ebs_status status)
+{
+	switch (status) {
+	case IWL_SCAN_EBS_SUCCESS:
+		return "successful";
+	case IWL_SCAN_EBS_INACTIVE:
+		return "inactive";
+	case IWL_SCAN_EBS_FAILED:
+	case IWL_SCAN_EBS_CHAN_NOT_FOUND:
+	default:
+		return "failed";
+	}
+}
+
 int iwl_mvm_rx_lmac_scan_complete_notif(struct iwl_mvm *mvm,
 					struct iwl_rx_cmd_buffer *rxb,
 					struct iwl_device_cmd *cmd)
@@ -359,7 +373,6 @@ int iwl_mvm_rx_lmac_scan_complete_notif(struct iwl_mvm *mvm,
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_periodic_scan_complete *scan_notif = (void *)pkt->data;
 	bool aborted = (scan_notif->status == IWL_SCAN_OFFLOAD_ABORTED);
-	bool ebs_successful = (scan_notif->ebs_status == IWL_SCAN_EBS_SUCCESS);
 
 	/* scan status must be locked for proper checking */
 	lockdep_assert_held(&mvm->mutex);
@@ -379,13 +392,13 @@ int iwl_mvm_rx_lmac_scan_complete_notif(struct iwl_mvm *mvm,
 
 		IWL_DEBUG_SCAN(mvm, "Scheduled scan %s, EBS status %s\n",
 			       aborted ? "aborted" : "completed",
-			       ebs_successful ? "successful" : "failed");
+			       iwl_mvm_ebs_status_str(scan_notif->ebs_status));
 
 		mvm->scan_status &= ~IWL_MVM_SCAN_STOPPING_SCHED;
 	} else if (mvm->scan_status & IWL_MVM_SCAN_STOPPING_REGULAR) {
 		IWL_DEBUG_SCAN(mvm, "Regular scan %s, EBS status %s\n",
 			       aborted ? "aborted" : "completed",
-			       ebs_successful ? "successful" : "failed");
+			       iwl_mvm_ebs_status_str(scan_notif->ebs_status));
 
 		mvm->scan_status &= ~IWL_MVM_SCAN_STOPPING_REGULAR;
 	} else if (mvm->scan_status & IWL_MVM_SCAN_SCHED) {
@@ -393,14 +406,14 @@ int iwl_mvm_rx_lmac_scan_complete_notif(struct iwl_mvm *mvm,
 
 		IWL_DEBUG_SCAN(mvm, "Scheduled scan %s, EBS status %s (FW)\n",
 			       aborted ? "aborted" : "completed",
-			       ebs_successful ? "successful" : "failed");
+			       iwl_mvm_ebs_status_str(scan_notif->ebs_status));
 
 		mvm->scan_status &= ~IWL_MVM_SCAN_SCHED;
 		ieee80211_sched_scan_stopped(mvm->hw);
 	} else if (mvm->scan_status & IWL_MVM_SCAN_REGULAR) {
 		IWL_DEBUG_SCAN(mvm, "Regular scan %s, EBS status %s (FW)\n",
 			       aborted ? "aborted" : "completed",
-			       ebs_successful ? "successful" : "failed");
+			       iwl_mvm_ebs_status_str(scan_notif->ebs_status));
 
 		mvm->scan_status &= ~IWL_MVM_SCAN_REGULAR;
 		ieee80211_scan_completed(mvm->hw,
@@ -408,7 +421,9 @@ int iwl_mvm_rx_lmac_scan_complete_notif(struct iwl_mvm *mvm,
 		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
 	}
 
-	mvm->last_ebs_successful = ebs_successful;
+	mvm->last_ebs_successful =
+			scan_notif->ebs_status == IWL_SCAN_EBS_SUCCESS ||
+			scan_notif->ebs_status == IWL_SCAN_EBS_INACTIVE;
 
 	return 0;
 }
@@ -1376,10 +1391,10 @@ int iwl_mvm_rx_umac_scan_complete_notif(struct iwl_mvm *mvm,
 		       uid, mvm->scan_uid_status[uid],
 		       notif->status == IWL_SCAN_OFFLOAD_COMPLETED ?
 				"completed" : "aborted",
-		       notif->ebs_status == IWL_SCAN_EBS_SUCCESS ?
-				"success" : "failed");
+		       iwl_mvm_ebs_status_str(notif->ebs_status));
 
-	if (notif->ebs_status)
+	if (notif->ebs_status != IWL_SCAN_EBS_SUCCESS &&
+	    notif->ebs_status != IWL_SCAN_EBS_INACTIVE)
 		mvm->last_ebs_successful = false;
 
 	mvm->scan_uid_status[uid] = 0;
-- 
2.1.4

