Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbbEZTSp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:18:45 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 25/39] iwlwifi: mvm: combine part of the scan stop flows
Date: Tue, 26 May 2015 22:17:38 +0300
Message-Id: <1432667872-18092-25-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_213348_891662_1D139122)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

For UMAC scans, we were simply jumping into another function when scan
stop functions were called, while for LMAC scans, the flow continued.
To make the flows cleaner and more balanced, combine the UMAC part
into the main stop functions.  This also makes us take one step closer
into combining the state flags for both APIs.

Note that some STOPPING flags will be dangling in UMAC scans, but it
doesn't matter because they are not used in UMAC yet (and this will be
fixed in subsequent patches).

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 40 ++++++++++-----------------------
 1 file changed, 12 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 579b36b..ec8ef56 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -101,7 +101,7 @@ struct iwl_mvm_scan_params {
 	} schedule[2];
 };
 
-static int iwl_umac_scan_stop(struct iwl_mvm *mvm, int type, bool notify);
+static int iwl_umac_scan_stop(struct iwl_mvm *mvm, int type);
 
 static u8 iwl_mvm_scan_rx_ant(struct iwl_mvm *mvm)
 {
@@ -889,9 +889,6 @@ int iwl_mvm_reg_scan_stop(struct iwl_mvm *mvm)
 {
 	int ret;
 
-	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
-		return iwl_umac_scan_stop(mvm, IWL_MVM_SCAN_REGULAR, true);
-
 	if (!(mvm->scan_status & IWL_MVM_SCAN_REGULAR))
 		return 0;
 
@@ -900,7 +897,11 @@ int iwl_mvm_reg_scan_stop(struct iwl_mvm *mvm)
 		goto out;
 	}
 
-	ret = iwl_mvm_lmac_scan_stop(mvm, IWL_MVM_SCAN_REGULAR);
+	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
+		ret = iwl_umac_scan_stop(mvm, IWL_MVM_SCAN_REGULAR);
+	else
+		ret = iwl_mvm_lmac_scan_stop(mvm, IWL_MVM_SCAN_REGULAR);
+
 	if (!ret)
 		mvm->scan_status |= IWL_MVM_SCAN_STOPPING_REGULAR;
 out:
@@ -922,9 +923,6 @@ int iwl_mvm_sched_scan_stop(struct iwl_mvm *mvm, bool notify)
 {
 	int ret;
 
-	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
-		return iwl_umac_scan_stop(mvm, IWL_MVM_SCAN_SCHED, notify);
-
 	if (!(mvm->scan_status & IWL_MVM_SCAN_SCHED))
 		return 0;
 
@@ -933,7 +931,11 @@ int iwl_mvm_sched_scan_stop(struct iwl_mvm *mvm, bool notify)
 		goto out;
 	}
 
-	ret = iwl_mvm_lmac_scan_stop(mvm, IWL_MVM_SCAN_SCHED);
+	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
+		ret = iwl_umac_scan_stop(mvm, IWL_MVM_SCAN_SCHED);
+	else
+		ret = iwl_mvm_lmac_scan_stop(mvm, IWL_MVM_SCAN_SCHED);
+
 	if (!ret)
 		mvm->scan_status |= IWL_MVM_SCAN_STOPPING_SCHED;
 out:
@@ -1585,7 +1587,7 @@ static int iwl_umac_scan_abort_one(struct iwl_mvm *mvm, u32 uid)
 	return iwl_mvm_send_cmd_pdu(mvm, SCAN_ABORT_UMAC, 0, sizeof(cmd), &cmd);
 }
 
-static int iwl_umac_scan_stop(struct iwl_mvm *mvm, int type, bool notify)
+static int iwl_umac_scan_stop(struct iwl_mvm *mvm, int type)
 {
 	struct iwl_notification_wait wait_scan_done;
 	static const u8 scan_done_notif[] = { SCAN_COMPLETE_UMAC, };
@@ -1606,13 +1608,6 @@ static int iwl_umac_scan_stop(struct iwl_mvm *mvm, int type, bool notify)
 		if (mvm->scan_uid[i] & type) {
 			int err;
 
-			if (iwl_mvm_is_radio_killed(mvm) &&
-			    (type & IWL_MVM_SCAN_REGULAR)) {
-				ieee80211_scan_completed(mvm->hw, true);
-				iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
-				break;
-			}
-
 			err = iwl_umac_scan_abort_one(mvm, mvm->scan_uid[i]);
 			if (!err)
 				ret = 0;
@@ -1626,17 +1621,6 @@ static int iwl_umac_scan_stop(struct iwl_mvm *mvm, int type, bool notify)
 	}
 
 	ret = iwl_wait_notification(&mvm->notif_wait, &wait_scan_done, 1 * HZ);
-	if (ret)
-		return ret;
-
-	if (notify) {
-		if (type & IWL_MVM_SCAN_SCHED)
-			ieee80211_sched_scan_stopped(mvm->hw);
-		if (type & IWL_MVM_SCAN_REGULAR) {
-			ieee80211_scan_completed(mvm->hw, true);
-			iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
-		}
-	}
 
 	return ret;
 }
-- 
2.1.4

