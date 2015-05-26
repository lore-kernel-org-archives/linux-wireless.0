Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbbEZTS4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:18:56 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 30/39] iwlwifi: mvm: remove code that stops multiple UMAC scans of a type
Date: Tue, 26 May 2015 22:17:43 +0300
Message-Id: <1432667872-18092-30-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_211930_697462_E63E20F5)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

We can only have one scan per type at the same time, so the code that
tries to stop several scans of a type is unnecessary.  Remove that to
reduce code complexity.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 74 ++++++++++-----------------------
 1 file changed, 21 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 496d1df..4199c60 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -898,13 +898,6 @@ static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	return 0;
 }
 
-/* UMAC scan API */
-
-struct iwl_umac_scan_done {
-	struct iwl_mvm *mvm;
-	int type;
-};
-
 static int rate_to_scan_rate_flag(unsigned int rate)
 {
 	static const int rate_to_scan_rate[IWL_RATE_COUNT] = {
@@ -1443,76 +1436,51 @@ int iwl_mvm_rx_umac_scan_iter_complete_notif(struct iwl_mvm *mvm,
 	return 0;
 }
 
-static bool iwl_scan_umac_done_check(struct iwl_notif_wait_data *notif_wait,
-				     struct iwl_rx_packet *pkt, void *data)
-{
-	struct iwl_umac_scan_done *scan_done = data;
-	struct iwl_umac_scan_complete *notif = (void *)pkt->data;
-	u32 uid = __le32_to_cpu(notif->uid);
-
-	if (WARN_ON(pkt->hdr.cmd != SCAN_COMPLETE_UMAC))
-		return false;
-
-	if (scan_done->mvm->scan_uid_status[uid] == 0)
-		return false;
-
-	/*
-	 * Clear scan uid of scans that was aborted from above and completed
-	 * in FW so the RX handler does nothing. Set last_ebs_successful here if
-	 * needed.
-	 */
-	scan_done->mvm->scan_uid_status[uid] = 0;
-
-	if (notif->ebs_status)
-		scan_done->mvm->last_ebs_successful = false;
-
-	return iwl_mvm_scan_uid_by_status(scan_done->mvm, scan_done->type) < 0;
-}
-
-static int iwl_umac_scan_abort_one(struct iwl_mvm *mvm, u32 uid)
+static int iwl_mvm_umac_scan_abort(struct iwl_mvm *mvm, int type)
 {
 	struct iwl_umac_scan_abort cmd = {
 		.hdr.size = cpu_to_le16(sizeof(struct iwl_umac_scan_abort) -
 					sizeof(struct iwl_mvm_umac_cmd_hdr)),
-		.uid = cpu_to_le32(uid),
 	};
+	int uid, ret;
 
 	lockdep_assert_held(&mvm->mutex);
 
+	/* We should always get a valid index here, because we already
+	 * checked that this type of scan was running in the generic
+	 * code.
+	 */
+	uid = iwl_mvm_scan_uid_by_status(mvm, type);
+	if (WARN_ON_ONCE(uid < 0))
+		return uid;
+
+	cmd.uid = cpu_to_le32(uid);
+
 	IWL_DEBUG_SCAN(mvm, "Sending scan abort, uid %u\n", uid);
 
-	return iwl_mvm_send_cmd_pdu(mvm, SCAN_ABORT_UMAC, 0, sizeof(cmd), &cmd);
+	ret = iwl_mvm_send_cmd_pdu(mvm, SCAN_ABORT_UMAC, 0, sizeof(cmd), &cmd);
+	if (!ret)
+		mvm->scan_uid_status[uid] = 0;
+
+	return ret;
 }
 
 static int iwl_mvm_umac_scan_stop(struct iwl_mvm *mvm, int type)
 {
 	struct iwl_notification_wait wait_scan_done;
 	static const u8 scan_done_notif[] = { SCAN_COMPLETE_UMAC, };
-	struct iwl_umac_scan_done scan_done = {
-		.mvm = mvm,
-		.type = type,
-	};
-	int i, ret = -EIO;
+	int ret;
 
 	iwl_init_notification_wait(&mvm->notif_wait, &wait_scan_done,
 				   scan_done_notif,
 				   ARRAY_SIZE(scan_done_notif),
-				   iwl_scan_umac_done_check, &scan_done);
+				   NULL, NULL);
 
 	IWL_DEBUG_SCAN(mvm, "Preparing to stop scan, type %x\n", type);
 
-	for (i = 0; i < mvm->max_scans; i++) {
-		if (mvm->scan_uid_status[i] == type) {
-			int err;
-
-			err = iwl_umac_scan_abort_one(mvm, i);
-			if (!err)
-				ret = 0;
-		}
-	}
-
+	ret = iwl_mvm_umac_scan_abort(mvm, type);
 	if (ret) {
-		IWL_DEBUG_SCAN(mvm, "Couldn't stop scan\n");
+		IWL_DEBUG_SCAN(mvm, "couldn't stop scan type %d\n", type);
 		iwl_remove_notification(&mvm->notif_wait, &wait_scan_done);
 		return ret;
 	}
-- 
2.1.4

