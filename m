Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157AbbEZTTJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:19:09 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 36/39] iwlwifi: mvm: make UMAC scans use the stopping scan status
Date: Tue, 26 May 2015 22:17:49 +0300
Message-Id: <1432667872-18092-36-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_211923_387566_277F7A52)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

UMAC scans now use the general scan status for almost everything, the
only part missing was in the scan complete notifications.  Change it
to use the stopping flags instead of clearing the flags when the stop
comes from above and clean the handler function a bit.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index d8de906..4f4570d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -1356,15 +1356,24 @@ int iwl_mvm_rx_umac_scan_complete_notif(struct iwl_mvm *mvm,
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_umac_scan_complete *notif = (void *)pkt->data;
 	u32 uid = __le32_to_cpu(notif->uid);
-	bool sched = (mvm->scan_uid_status[uid] == IWL_MVM_SCAN_SCHED);
+	bool aborted = (notif->status == IWL_SCAN_OFFLOAD_ABORTED);
 
-	/* the status may be already zero in case of scan abort from above */
-	if (mvm->scan_uid_status[uid] == 0)
+	if (WARN_ON(!(mvm->scan_uid_status[uid] & mvm->scan_status)))
 		return 0;
 
+	/* if the scan is already stopping, we don't need to notify mac80211 */
+	if (mvm->scan_uid_status[uid] == IWL_MVM_SCAN_REGULAR) {
+		ieee80211_scan_completed(mvm->hw, aborted);
+		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
+	} else if (mvm->scan_uid_status[uid] == IWL_MVM_SCAN_SCHED) {
+		ieee80211_sched_scan_stopped(mvm->hw);
+	}
+
+	mvm->scan_status &= ~mvm->scan_uid_status[uid];
+
 	IWL_DEBUG_SCAN(mvm,
-		       "Scan completed, uid %u type %s, status %s, EBS status %s\n",
-		       uid, sched ? "sched" : "regular",
+		       "Scan completed, uid %u type %u, status %s, EBS status %s\n",
+		       uid, mvm->scan_uid_status[uid],
 		       notif->status == IWL_SCAN_OFFLOAD_COMPLETED ?
 				"completed" : "aborted",
 		       notif->ebs_status == IWL_SCAN_EBS_SUCCESS ?
@@ -1375,17 +1384,6 @@ int iwl_mvm_rx_umac_scan_complete_notif(struct iwl_mvm *mvm,
 
 	mvm->scan_uid_status[uid] = 0;
 
-	if (!sched) {
-		ieee80211_scan_completed(mvm->hw,
-					 notif->status ==
-						IWL_SCAN_OFFLOAD_ABORTED);
-		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
-	} else if (iwl_mvm_scan_uid_by_status(mvm, IWL_MVM_SCAN_SCHED) < 0) {
-		ieee80211_sched_scan_stopped(mvm->hw);
-	} else {
-		IWL_DEBUG_SCAN(mvm, "Another sched scan is running\n");
-	}
-
 	return 0;
 }
 
@@ -1430,7 +1428,7 @@ static int iwl_mvm_umac_scan_abort(struct iwl_mvm *mvm, int type)
 
 	ret = iwl_mvm_send_cmd_pdu(mvm, SCAN_ABORT_UMAC, 0, sizeof(cmd), &cmd);
 	if (!ret)
-		mvm->scan_uid_status[uid] = 0;
+		mvm->scan_uid_status[uid] = type << IWL_MVM_SCAN_STOPPING_SHIFT;
 
 	return ret;
 }
-- 
2.1.4

