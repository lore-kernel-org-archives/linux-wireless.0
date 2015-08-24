Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50549 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152AbbHXUAr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2015 16:00:47 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Ayala Beker <ayala.beker@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 4/6] iwlwifi: mvm: split debug message to avoid exceeding 110 characters
Date: Mon, 24 Aug 2015 23:00:35 +0300
Message-Id: <1440446437-29188-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150824_220050_023809_49CBAF04)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E827CB7@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E827CB7@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ayala Beker <ayala.beker@intel.com>

split long debug messages that may result warning in tracing.

Fixes: 1a84e7716086 ("iwlwifi: mvm: add debug info to schedule scan complete message.")
Signed-off-by: Ayala Beker <ayala.beker@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 1505546..56559d4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -349,10 +349,11 @@ void iwl_mvm_rx_lmac_scan_complete_notif(struct iwl_mvm *mvm,
 	if (mvm->scan_status & IWL_MVM_SCAN_STOPPING_SCHED) {
 		WARN_ON_ONCE(mvm->scan_status & IWL_MVM_SCAN_STOPPING_REGULAR);
 
-		IWL_DEBUG_SCAN(mvm,
-			       "Scheduled scan %s, EBS status %s, Last line %d, Last iteration %d, Time after last iteration %d\n",
+		IWL_DEBUG_SCAN(mvm, "Scheduled scan %s, EBS status %s\n",
 			       aborted ? "aborted" : "completed",
-			       iwl_mvm_ebs_status_str(scan_notif->ebs_status),
+			       iwl_mvm_ebs_status_str(scan_notif->ebs_status));
+		IWL_DEBUG_SCAN(mvm,
+			       "Last line %d, Last iteration %d, Time after last iteration %d\n",
 			       scan_notif->last_schedule_line,
 			       scan_notif->last_schedule_iteration,
 			       __le32_to_cpu(scan_notif->time_after_last_iter));
@@ -367,10 +368,11 @@ void iwl_mvm_rx_lmac_scan_complete_notif(struct iwl_mvm *mvm,
 	} else if (mvm->scan_status & IWL_MVM_SCAN_SCHED) {
 		WARN_ON_ONCE(mvm->scan_status & IWL_MVM_SCAN_REGULAR);
 
-		IWL_DEBUG_SCAN(mvm,
-			       "Scheduled scan %s, EBS status %s, Last line %d, Last iteration %d, Time after last iteration %d (FW)\n",
+		IWL_DEBUG_SCAN(mvm, "Scheduled scan %s, EBS status %s\n",
 			       aborted ? "aborted" : "completed",
-			       iwl_mvm_ebs_status_str(scan_notif->ebs_status),
+			       iwl_mvm_ebs_status_str(scan_notif->ebs_status));
+		IWL_DEBUG_SCAN(mvm,
+			       "Last line %d, Last iteration %d, Time after last iteration %d (FW)\n",
 			       scan_notif->last_schedule_line,
 			       scan_notif->last_schedule_iteration,
 			       __le32_to_cpu(scan_notif->time_after_last_iter));
@@ -1346,11 +1348,13 @@ void iwl_mvm_rx_umac_scan_complete_notif(struct iwl_mvm *mvm,
 
 	mvm->scan_status &= ~mvm->scan_uid_status[uid];
 	IWL_DEBUG_SCAN(mvm,
-		       "Scan completed, uid %u type %u, status %s, EBS status %s, Last line %d, Last iteration %d, Time from last iteration %d\n",
+		       "Scan completed, uid %u type %u, status %s, EBS status %s\n",
 		       uid, mvm->scan_uid_status[uid],
 		       notif->status == IWL_SCAN_OFFLOAD_COMPLETED ?
 				"completed" : "aborted",
-		       iwl_mvm_ebs_status_str(notif->ebs_status),
+		       iwl_mvm_ebs_status_str(notif->ebs_status));
+	IWL_DEBUG_SCAN(mvm,
+		       "Last line %d, Last iteration %d, Time from last iteration %d\n",
 		       notif->last_schedule, notif->last_iter,
 		       __le32_to_cpu(notif->time_from_last_iter));
 
-- 
2.1.4

