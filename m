Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbbEZTS1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:18:27 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/39] iwlwifi: mvm: remove the UMAC specific scan types
Date: Tue, 26 May 2015 22:17:28 +0300
Message-Id: <1432667872-18092-15-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_211832_140921_EAADF060)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

There is no need to have separate definitions for the UMAC scan types,
since they are the same as the LMAC types.  Remove UMAC scan types and
use the generic ones instead.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 47 ++++++++++++---------------------
 1 file changed, 17 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index e54432a..7777d56 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -101,13 +101,7 @@ struct iwl_mvm_scan_params {
 	} schedule[2];
 };
 
-enum iwl_umac_scan_uid_type {
-	IWL_UMAC_SCAN_UID_REG_SCAN	= BIT(0),
-	IWL_UMAC_SCAN_UID_SCHED_SCAN	= BIT(1),
-};
-
-static int iwl_umac_scan_stop(struct iwl_mvm *mvm,
-			      enum iwl_umac_scan_uid_type type, bool notify);
+static int iwl_umac_scan_stop(struct iwl_mvm *mvm, int type, bool notify);
 
 static u8 iwl_mvm_scan_rx_ant(struct iwl_mvm *mvm)
 {
@@ -588,8 +582,7 @@ int iwl_mvm_scan_offload_stop(struct iwl_mvm *mvm, bool notify)
 	lockdep_assert_held(&mvm->mutex);
 
 	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
-		return iwl_umac_scan_stop(mvm, IWL_UMAC_SCAN_UID_SCHED_SCAN,
-					  notify);
+		return iwl_umac_scan_stop(mvm, IWL_MVM_SCAN_SCHED, notify);
 
 	/* FIXME: For now we only check if no scan is set here, since
 	 * we only support LMAC in this flow and it doesn't support
@@ -917,8 +910,7 @@ static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 int iwl_mvm_cancel_scan(struct iwl_mvm *mvm)
 {
 	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
-		return iwl_umac_scan_stop(mvm, IWL_UMAC_SCAN_UID_REG_SCAN,
-					  true);
+		return iwl_umac_scan_stop(mvm, IWL_MVM_SCAN_REGULAR, true);
 
 	if (!(mvm->scan_status & IWL_MVM_SCAN_REGULAR))
 		return 0;
@@ -937,7 +929,7 @@ int iwl_mvm_cancel_scan(struct iwl_mvm *mvm)
 
 struct iwl_umac_scan_done {
 	struct iwl_mvm *mvm;
-	enum iwl_umac_scan_uid_type type;
+	int type;
 };
 
 static int rate_to_scan_rate_flag(unsigned int rate)
@@ -1064,8 +1056,7 @@ static int iwl_mvm_find_free_scan_uid(struct iwl_mvm *mvm)
 	return iwl_mvm_find_scan_uid(mvm, 0);
 }
 
-static bool iwl_mvm_find_scan_type(struct iwl_mvm *mvm,
-				   enum iwl_umac_scan_uid_type type)
+static bool iwl_mvm_find_scan_type(struct iwl_mvm *mvm, int type)
 {
 	int i;
 
@@ -1076,8 +1067,7 @@ static bool iwl_mvm_find_scan_type(struct iwl_mvm *mvm,
 	return false;
 }
 
-static int iwl_mvm_find_first_scan(struct iwl_mvm *mvm,
-				   enum iwl_umac_scan_uid_type type)
+static int iwl_mvm_find_first_scan(struct iwl_mvm *mvm, int type)
 {
 	int i;
 
@@ -1088,8 +1078,7 @@ static int iwl_mvm_find_first_scan(struct iwl_mvm *mvm,
 	return i;
 }
 
-static u32 iwl_generate_scan_uid(struct iwl_mvm *mvm,
-				 enum iwl_umac_scan_uid_type type)
+static u32 iwl_generate_scan_uid(struct iwl_mvm *mvm, int type)
 {
 	u32 uid;
 
@@ -1201,9 +1190,9 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	iwl_mvm_scan_umac_dwell(mvm, cmd, params);
 
 	if (n_iterations == 1)
-		uid = iwl_generate_scan_uid(mvm, IWL_UMAC_SCAN_UID_REG_SCAN);
+		uid = iwl_generate_scan_uid(mvm, IWL_MVM_SCAN_REGULAR);
 	else
-		uid = iwl_generate_scan_uid(mvm, IWL_UMAC_SCAN_UID_SCHED_SCAN);
+		uid = iwl_generate_scan_uid(mvm, IWL_MVM_SCAN_SCHED);
 
 	mvm->scan_uid[uid_idx] = uid;
 	cmd->uid = cpu_to_le32(uid);
@@ -1478,7 +1467,7 @@ int iwl_mvm_rx_umac_scan_complete_notif(struct iwl_mvm *mvm,
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_umac_scan_complete *notif = (void *)pkt->data;
 	u32 uid = __le32_to_cpu(notif->uid);
-	bool sched = !!(uid & IWL_UMAC_SCAN_UID_SCHED_SCAN);
+	bool sched = !!(uid & IWL_MVM_SCAN_SCHED);
 	int uid_idx = iwl_mvm_find_scan_uid(mvm, uid);
 
 	/*
@@ -1505,7 +1494,7 @@ int iwl_mvm_rx_umac_scan_complete_notif(struct iwl_mvm *mvm,
 					 notif->status ==
 						IWL_SCAN_OFFLOAD_ABORTED);
 		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
-	} else if (!iwl_mvm_find_scan_type(mvm, IWL_UMAC_SCAN_UID_SCHED_SCAN)) {
+	} else if (!iwl_mvm_find_scan_type(mvm, IWL_MVM_SCAN_SCHED)) {
 		ieee80211_sched_scan_stopped(mvm->hw);
 	} else {
 		IWL_DEBUG_SCAN(mvm, "Another sched scan is running\n");
@@ -1556,8 +1545,7 @@ static int iwl_umac_scan_abort_one(struct iwl_mvm *mvm, u32 uid)
 	return iwl_mvm_send_cmd_pdu(mvm, SCAN_ABORT_UMAC, 0, sizeof(cmd), &cmd);
 }
 
-static int iwl_umac_scan_stop(struct iwl_mvm *mvm,
-			      enum iwl_umac_scan_uid_type type, bool notify)
+static int iwl_umac_scan_stop(struct iwl_mvm *mvm, int type, bool notify)
 {
 	struct iwl_notification_wait wait_scan_done;
 	static const u8 scan_done_notif[] = { SCAN_COMPLETE_UMAC, };
@@ -1579,7 +1567,7 @@ static int iwl_umac_scan_stop(struct iwl_mvm *mvm,
 			int err;
 
 			if (iwl_mvm_is_radio_killed(mvm) &&
-			    (type & IWL_UMAC_SCAN_UID_REG_SCAN)) {
+			    (type & IWL_MVM_SCAN_REGULAR)) {
 				ieee80211_scan_completed(mvm->hw, true);
 				iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
 				break;
@@ -1602,9 +1590,9 @@ static int iwl_umac_scan_stop(struct iwl_mvm *mvm,
 		return ret;
 
 	if (notify) {
-		if (type & IWL_UMAC_SCAN_UID_SCHED_SCAN)
+		if (type & IWL_MVM_SCAN_SCHED)
 			ieee80211_sched_scan_stopped(mvm->hw);
-		if (type & IWL_UMAC_SCAN_UID_REG_SCAN) {
+		if (type & IWL_MVM_SCAN_REGULAR) {
 			ieee80211_scan_completed(mvm->hw, true);
 			iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
 		}
@@ -1636,13 +1624,12 @@ void iwl_mvm_report_scan_aborted(struct iwl_mvm *mvm)
 	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) {
 		u32 uid, i;
 
-		uid = iwl_mvm_find_first_scan(mvm, IWL_UMAC_SCAN_UID_REG_SCAN);
+		uid = iwl_mvm_find_first_scan(mvm, IWL_MVM_SCAN_REGULAR);
 		if (uid < mvm->max_scans) {
 			ieee80211_scan_completed(mvm->hw, true);
 			mvm->scan_uid[uid] = 0;
 		}
-		uid = iwl_mvm_find_first_scan(mvm,
-					      IWL_UMAC_SCAN_UID_SCHED_SCAN);
+		uid = iwl_mvm_find_first_scan(mvm, IWL_MVM_SCAN_SCHED);
 		if (uid < mvm->max_scans && !mvm->restart_fw) {
 			ieee80211_sched_scan_stopped(mvm->hw);
 			mvm->scan_uid[uid] = 0;
-- 
2.1.4

