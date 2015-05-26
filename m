Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbbEZTS6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:18:58 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 31/39] iwlwifi: mvm: combine UMAC and LMAC scan_stop functions
Date: Tue, 26 May 2015 22:17:44 +0300
Message-Id: <1432667872-18092-31-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_211905_296261_212238B9)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

The UMAC and LMAC scan_stop functions are now nearly identical, so
they can be combined into a single function instead.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 57 ++++++++-------------------------
 1 file changed, 13 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 4199c60..49bcf7d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -557,7 +557,7 @@ static bool iwl_mvm_scan_pass_all(struct iwl_mvm *mvm,
 	return true;
 }
 
-static int iwl_mvm_send_lmac_scan_abort(struct iwl_mvm *mvm)
+static int iwl_mvm_lmac_scan_abort(struct iwl_mvm *mvm)
 {
 	int ret;
 	struct iwl_host_cmd cmd = {
@@ -584,36 +584,6 @@ static int iwl_mvm_send_lmac_scan_abort(struct iwl_mvm *mvm)
 	return ret;
 }
 
-static int iwl_mvm_lmac_scan_stop(struct iwl_mvm *mvm, int type)
-{
-	int ret;
-	struct iwl_notification_wait wait_scan_done;
-	static const u8 scan_done_notif[] = { SCAN_OFFLOAD_COMPLETE, };
-	bool sched = type & IWL_MVM_SCAN_SCHED;
-
-	lockdep_assert_held(&mvm->mutex);
-
-	iwl_init_notification_wait(&mvm->notif_wait, &wait_scan_done,
-				   scan_done_notif,
-				   ARRAY_SIZE(scan_done_notif),
-				   NULL, NULL);
-
-	ret = iwl_mvm_send_lmac_scan_abort(mvm);
-	if (ret) {
-		IWL_DEBUG_SCAN(mvm, "Send stop %sscan failed %d\n",
-			       sched ? "offloaded " : "", ret);
-		iwl_remove_notification(&mvm->notif_wait, &wait_scan_done);
-		goto out;
-	}
-
-	IWL_DEBUG_SCAN(mvm, "Successfully sent stop %sscan\n",
-		       sched ? "scheduled " : "");
-
-	ret = iwl_wait_notification(&mvm->notif_wait, &wait_scan_done, 1 * HZ);
-out:
-	return ret;
-}
-
 static void iwl_mvm_scan_fill_tx_cmd(struct iwl_mvm *mvm,
 				     struct iwl_scan_req_tx_cmd *tx_cmd,
 				     bool no_cck)
@@ -1465,12 +1435,15 @@ static int iwl_mvm_umac_scan_abort(struct iwl_mvm *mvm, int type)
 	return ret;
 }
 
-static int iwl_mvm_umac_scan_stop(struct iwl_mvm *mvm, int type)
+static int iwl_mvm_scan_stop_wait(struct iwl_mvm *mvm, int type)
 {
 	struct iwl_notification_wait wait_scan_done;
-	static const u8 scan_done_notif[] = { SCAN_COMPLETE_UMAC, };
+	static const u8 scan_done_notif[] = { SCAN_COMPLETE_UMAC,
+					      SCAN_OFFLOAD_COMPLETE, };
 	int ret;
 
+	lockdep_assert_held(&mvm->mutex);
+
 	iwl_init_notification_wait(&mvm->notif_wait, &wait_scan_done,
 				   scan_done_notif,
 				   ARRAY_SIZE(scan_done_notif),
@@ -1478,7 +1451,11 @@ static int iwl_mvm_umac_scan_stop(struct iwl_mvm *mvm, int type)
 
 	IWL_DEBUG_SCAN(mvm, "Preparing to stop scan, type %x\n", type);
 
-	ret = iwl_mvm_umac_scan_abort(mvm, type);
+	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
+		ret = iwl_mvm_umac_scan_abort(mvm, type);
+	else
+		ret = iwl_mvm_lmac_scan_abort(mvm);
+
 	if (ret) {
 		IWL_DEBUG_SCAN(mvm, "couldn't stop scan type %d\n", type);
 		iwl_remove_notification(&mvm->notif_wait, &wait_scan_done);
@@ -1559,11 +1536,7 @@ int iwl_mvm_reg_scan_stop(struct iwl_mvm *mvm)
 		goto out;
 	}
 
-	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
-		ret = iwl_mvm_umac_scan_stop(mvm, IWL_MVM_SCAN_REGULAR);
-	else
-		ret = iwl_mvm_lmac_scan_stop(mvm, IWL_MVM_SCAN_REGULAR);
-
+	ret = iwl_mvm_scan_stop_wait(mvm, IWL_MVM_SCAN_REGULAR);
 	if (!ret)
 		mvm->scan_status |= IWL_MVM_SCAN_STOPPING_REGULAR;
 out:
@@ -1593,11 +1566,7 @@ int iwl_mvm_sched_scan_stop(struct iwl_mvm *mvm, bool notify)
 		goto out;
 	}
 
-	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
-		ret = iwl_mvm_umac_scan_stop(mvm, IWL_MVM_SCAN_SCHED);
-	else
-		ret = iwl_mvm_lmac_scan_stop(mvm, IWL_MVM_SCAN_SCHED);
-
+	ret = iwl_mvm_scan_stop_wait(mvm, IWL_MVM_SCAN_SCHED);
 	if (!ret)
 		mvm->scan_status |= IWL_MVM_SCAN_STOPPING_SCHED;
 out:
-- 
2.1.4

