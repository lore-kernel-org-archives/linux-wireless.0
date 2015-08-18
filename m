Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39253 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbbHRH6U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 03:58:20 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Ayala Beker <ayala.beker@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/26] iwlwifi: mvm: add debug info to schedule scan complete message.
Date: Tue, 18 Aug 2015 10:57:26 +0300
Message-Id: <1439884656-18146-16-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150818_100108_649689_F6D11CA8)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ayala Beker <ayala.beker@intel.com>

Add more information to schedule scan complete message.

Signed-off-by: Ayala Beker <ayala.beker@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index f456aad..1505546 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -349,9 +349,13 @@ void iwl_mvm_rx_lmac_scan_complete_notif(struct iwl_mvm *mvm,
 	if (mvm->scan_status & IWL_MVM_SCAN_STOPPING_SCHED) {
 		WARN_ON_ONCE(mvm->scan_status & IWL_MVM_SCAN_STOPPING_REGULAR);
 
-		IWL_DEBUG_SCAN(mvm, "Scheduled scan %s, EBS status %s\n",
+		IWL_DEBUG_SCAN(mvm,
+			       "Scheduled scan %s, EBS status %s, Last line %d, Last iteration %d, Time after last iteration %d\n",
 			       aborted ? "aborted" : "completed",
-			       iwl_mvm_ebs_status_str(scan_notif->ebs_status));
+			       iwl_mvm_ebs_status_str(scan_notif->ebs_status),
+			       scan_notif->last_schedule_line,
+			       scan_notif->last_schedule_iteration,
+			       __le32_to_cpu(scan_notif->time_after_last_iter));
 
 		mvm->scan_status &= ~IWL_MVM_SCAN_STOPPING_SCHED;
 	} else if (mvm->scan_status & IWL_MVM_SCAN_STOPPING_REGULAR) {
@@ -363,9 +367,13 @@ void iwl_mvm_rx_lmac_scan_complete_notif(struct iwl_mvm *mvm,
 	} else if (mvm->scan_status & IWL_MVM_SCAN_SCHED) {
 		WARN_ON_ONCE(mvm->scan_status & IWL_MVM_SCAN_REGULAR);
 
-		IWL_DEBUG_SCAN(mvm, "Scheduled scan %s, EBS status %s (FW)\n",
+		IWL_DEBUG_SCAN(mvm,
+			       "Scheduled scan %s, EBS status %s, Last line %d, Last iteration %d, Time after last iteration %d (FW)\n",
 			       aborted ? "aborted" : "completed",
-			       iwl_mvm_ebs_status_str(scan_notif->ebs_status));
+			       iwl_mvm_ebs_status_str(scan_notif->ebs_status),
+			       scan_notif->last_schedule_line,
+			       scan_notif->last_schedule_iteration,
+			       __le32_to_cpu(scan_notif->time_after_last_iter));
 
 		mvm->scan_status &= ~IWL_MVM_SCAN_SCHED;
 		ieee80211_sched_scan_stopped(mvm->hw);
@@ -1337,13 +1345,14 @@ void iwl_mvm_rx_umac_scan_complete_notif(struct iwl_mvm *mvm,
 	}
 
 	mvm->scan_status &= ~mvm->scan_uid_status[uid];
-
 	IWL_DEBUG_SCAN(mvm,
-		       "Scan completed, uid %u type %u, status %s, EBS status %s\n",
+		       "Scan completed, uid %u type %u, status %s, EBS status %s, Last line %d, Last iteration %d, Time from last iteration %d\n",
 		       uid, mvm->scan_uid_status[uid],
 		       notif->status == IWL_SCAN_OFFLOAD_COMPLETED ?
 				"completed" : "aborted",
-		       iwl_mvm_ebs_status_str(notif->ebs_status));
+		       iwl_mvm_ebs_status_str(notif->ebs_status),
+		       notif->last_schedule, notif->last_iter,
+		       __le32_to_cpu(notif->time_from_last_iter));
 
 	if (notif->ebs_status != IWL_SCAN_EBS_SUCCESS &&
 	    notif->ebs_status != IWL_SCAN_EBS_INACTIVE)
-- 
2.1.4

