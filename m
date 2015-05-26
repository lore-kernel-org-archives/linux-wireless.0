Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107AbbEZTSy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:18:54 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 29/39] iwlwifi: mvm: refactor UMAC scan UID handling
Date: Tue, 26 May 2015 22:17:42 +0300
Message-Id: <1432667872-18092-29-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_211942_508168_FB2C3781)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

We can only have one scan of each type running at the same time, so we
can remove one attribute in the UID information we save.  We had array
index, UID and type, but only UID (== array_index) and type are
necessary.  Refactor the code to use this simplified array.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |   8 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |   3 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c     | 126 ++++++++--------------------
 3 files changed, 39 insertions(+), 98 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index df0199e..cea236b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1434,10 +1434,10 @@ void __iwl_mvm_mac_stop(struct iwl_mvm *mvm)
 		int i;
 
 		for (i = 0; i < mvm->max_scans; i++) {
-			if (WARN_ONCE(mvm->scan_uid[i],
-				      "UMAC scan UID %d was not cleaned\n",
-				      mvm->scan_uid[i]))
-				mvm->scan_uid[i] = 0;
+			if (WARN_ONCE(mvm->scan_uid_status[i],
+				      "UMAC scan UID %d status was not cleaned\n",
+				      i))
+				mvm->scan_uid_status[i] = 0;
 		}
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 760c626..f22d309 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -628,8 +628,7 @@ struct iwl_mvm {
 	unsigned int max_scans;
 
 	/* UMAC scan tracking */
-	u32 scan_uid[IWL_MVM_MAX_UMAC_SCANS];
-	u8 scan_seq_num, sched_scan_seq_num;
+	u32 scan_uid_status[IWL_MVM_MAX_UMAC_SCANS];
 
 	/* rx chain antennas set through debugfs for the scan command */
 	u8 scan_rx_ant;
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index d0312f0..496d1df 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -1013,65 +1013,15 @@ int iwl_mvm_config_scan(struct iwl_mvm *mvm)
 	return ret;
 }
 
-static int iwl_mvm_find_scan_uid(struct iwl_mvm *mvm, u32 uid)
+static int iwl_mvm_scan_uid_by_status(struct iwl_mvm *mvm, int status)
 {
 	int i;
 
 	for (i = 0; i < mvm->max_scans; i++)
-		if (mvm->scan_uid[i] == uid)
+		if (mvm->scan_uid_status[i] == status)
 			return i;
 
-	return i;
-}
-
-static int iwl_mvm_find_free_scan_uid(struct iwl_mvm *mvm)
-{
-	return iwl_mvm_find_scan_uid(mvm, 0);
-}
-
-static bool iwl_mvm_find_scan_type(struct iwl_mvm *mvm, int type)
-{
-	int i;
-
-	for (i = 0; i < mvm->max_scans; i++)
-		if (mvm->scan_uid[i] & type)
-			return true;
-
-	return false;
-}
-
-static int iwl_mvm_find_first_scan(struct iwl_mvm *mvm, int type)
-{
-	int i;
-
-	for (i = 0; i < mvm->max_scans; i++)
-		if (mvm->scan_uid[i] & type)
-			return i;
-
-	return i;
-}
-
-static u32 iwl_generate_scan_uid(struct iwl_mvm *mvm, int type)
-{
-	u32 uid;
-
-	/* make sure exactly one bit is on in scan type */
-	WARN_ON(hweight8(type) != 1);
-
-	/*
-	 * Make sure scan uids are unique. If one scan lasts long time while
-	 * others are completing frequently, the seq number will wrap up and
-	 * we may have more than one scan with the same uid.
-	 */
-	do {
-		uid = type | (mvm->scan_seq_num <<
-			      IWL_UMAC_SCAN_UID_SEQ_OFFSET);
-		mvm->scan_seq_num++;
-	} while (iwl_mvm_find_scan_uid(mvm, uid) < mvm->max_scans);
-
-	IWL_DEBUG_SCAN(mvm, "Generated scan UID %u\n", uid);
-
-	return uid;
+	return -ENOENT;
 }
 
 static void iwl_mvm_scan_umac_dwell(struct iwl_mvm *mvm,
@@ -1146,22 +1096,22 @@ static u32 iwl_mvm_scan_umac_flags(struct iwl_mvm *mvm,
 }
 
 static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-			     struct iwl_mvm_scan_params *params)
+			     struct iwl_mvm_scan_params *params,
+			     int type)
 {
 	struct iwl_scan_req_umac *cmd = mvm->scan_cmd;
 	struct iwl_scan_req_umac_tail *sec_part = (void *)&cmd->data +
 		sizeof(struct iwl_scan_channel_cfg_umac) *
 			mvm->fw->ucode_capa.n_scan_channels;
-	u32 uid;
+	int uid;
 	u32 ssid_bitmap = 0;
 	int n_iterations = iwl_mvm_scan_total_iterations(params);
-	int uid_idx;
 
 	lockdep_assert_held(&mvm->mutex);
 
-	uid_idx = iwl_mvm_find_free_scan_uid(mvm);
-	if (uid_idx >= mvm->max_scans)
-		return -EBUSY;
+	uid = iwl_mvm_scan_uid_by_status(mvm, 0);
+	if (uid < 0)
+		return uid;
 
 	memset(cmd, 0, ksize(cmd));
 	cmd->hdr.size = cpu_to_le16(iwl_mvm_scan_size(mvm) -
@@ -1169,14 +1119,9 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	iwl_mvm_scan_umac_dwell(mvm, cmd, params);
 
-	if (n_iterations == 1)
-		uid = iwl_generate_scan_uid(mvm, IWL_MVM_SCAN_REGULAR);
-	else
-		uid = iwl_generate_scan_uid(mvm, IWL_MVM_SCAN_SCHED);
+	mvm->scan_uid_status[uid] = type;
 
-	mvm->scan_uid[uid_idx] = uid;
 	cmd->uid = cpu_to_le32(uid);
-
 	cmd->general_flags = cpu_to_le32(iwl_mvm_scan_umac_flags(mvm, params));
 
 	if (iwl_mvm_scan_use_ebs(mvm, n_iterations))
@@ -1308,7 +1253,8 @@ int iwl_mvm_reg_scan_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) {
 		hcmd.id = SCAN_REQ_UMAC;
-		ret = iwl_mvm_scan_umac(mvm, vif, &params);
+		ret = iwl_mvm_scan_umac(mvm, vif, &params,
+					IWL_MVM_SCAN_REGULAR);
 	} else {
 		hcmd.id = SCAN_OFFLOAD_REQUEST_CMD;
 		ret = iwl_mvm_scan_lmac(mvm, vif, &params);
@@ -1415,7 +1361,7 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 
 	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) {
 		hcmd.id = SCAN_REQ_UMAC;
-		ret = iwl_mvm_scan_umac(mvm, vif, &params);
+		ret = iwl_mvm_scan_umac(mvm, vif, &params, IWL_MVM_SCAN_SCHED);
 	} else {
 		hcmd.id = SCAN_OFFLOAD_REQUEST_CMD;
 		ret = iwl_mvm_scan_lmac(mvm, vif, &params);
@@ -1447,13 +1393,10 @@ int iwl_mvm_rx_umac_scan_complete_notif(struct iwl_mvm *mvm,
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_umac_scan_complete *notif = (void *)pkt->data;
 	u32 uid = __le32_to_cpu(notif->uid);
-	bool sched = !!(uid & IWL_MVM_SCAN_SCHED);
-	int uid_idx = iwl_mvm_find_scan_uid(mvm, uid);
+	bool sched = (mvm->scan_uid_status[uid] == IWL_MVM_SCAN_SCHED);
 
-	/*
-	 * Scan uid may be set to zero in case of scan abort request from above.
-	 */
-	if (uid_idx >= mvm->max_scans)
+	/* the status may be already zero in case of scan abort from above */
+	if (mvm->scan_uid_status[uid] == 0)
 		return 0;
 
 	IWL_DEBUG_SCAN(mvm,
@@ -1467,14 +1410,14 @@ int iwl_mvm_rx_umac_scan_complete_notif(struct iwl_mvm *mvm,
 	if (notif->ebs_status)
 		mvm->last_ebs_successful = false;
 
-	mvm->scan_uid[uid_idx] = 0;
+	mvm->scan_uid_status[uid] = 0;
 
 	if (!sched) {
 		ieee80211_scan_completed(mvm->hw,
 					 notif->status ==
 						IWL_SCAN_OFFLOAD_ABORTED);
 		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
-	} else if (!iwl_mvm_find_scan_type(mvm, IWL_MVM_SCAN_SCHED)) {
+	} else if (iwl_mvm_scan_uid_by_status(mvm, IWL_MVM_SCAN_SCHED) < 0) {
 		ieee80211_sched_scan_stopped(mvm->hw);
 	} else {
 		IWL_DEBUG_SCAN(mvm, "Another sched scan is running\n");
@@ -1506,12 +1449,11 @@ static bool iwl_scan_umac_done_check(struct iwl_notif_wait_data *notif_wait,
 	struct iwl_umac_scan_done *scan_done = data;
 	struct iwl_umac_scan_complete *notif = (void *)pkt->data;
 	u32 uid = __le32_to_cpu(notif->uid);
-	int uid_idx = iwl_mvm_find_scan_uid(scan_done->mvm, uid);
 
 	if (WARN_ON(pkt->hdr.cmd != SCAN_COMPLETE_UMAC))
 		return false;
 
-	if (uid_idx >= scan_done->mvm->max_scans)
+	if (scan_done->mvm->scan_uid_status[uid] == 0)
 		return false;
 
 	/*
@@ -1519,12 +1461,12 @@ static bool iwl_scan_umac_done_check(struct iwl_notif_wait_data *notif_wait,
 	 * in FW so the RX handler does nothing. Set last_ebs_successful here if
 	 * needed.
 	 */
-	scan_done->mvm->scan_uid[uid_idx] = 0;
+	scan_done->mvm->scan_uid_status[uid] = 0;
 
 	if (notif->ebs_status)
 		scan_done->mvm->last_ebs_successful = false;
 
-	return !iwl_mvm_find_scan_type(scan_done->mvm, scan_done->type);
+	return iwl_mvm_scan_uid_by_status(scan_done->mvm, scan_done->type) < 0;
 }
 
 static int iwl_umac_scan_abort_one(struct iwl_mvm *mvm, u32 uid)
@@ -1560,10 +1502,10 @@ static int iwl_mvm_umac_scan_stop(struct iwl_mvm *mvm, int type)
 	IWL_DEBUG_SCAN(mvm, "Preparing to stop scan, type %x\n", type);
 
 	for (i = 0; i < mvm->max_scans; i++) {
-		if (mvm->scan_uid[i] & type) {
+		if (mvm->scan_uid_status[i] == type) {
 			int err;
 
-			err = iwl_umac_scan_abort_one(mvm, mvm->scan_uid[i]);
+			err = iwl_umac_scan_abort_one(mvm, i);
 			if (!err)
 				ret = 0;
 		}
@@ -1601,17 +1543,17 @@ int iwl_mvm_scan_size(struct iwl_mvm *mvm)
 void iwl_mvm_report_scan_aborted(struct iwl_mvm *mvm)
 {
 	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) {
-		u32 uid, i;
+		int uid, i;
 
-		uid = iwl_mvm_find_first_scan(mvm, IWL_MVM_SCAN_REGULAR);
-		if (uid < mvm->max_scans) {
+		uid = iwl_mvm_scan_uid_by_status(mvm, IWL_MVM_SCAN_REGULAR);
+		if (uid >= 0) {
 			ieee80211_scan_completed(mvm->hw, true);
-			mvm->scan_uid[uid] = 0;
+			mvm->scan_uid_status[uid] = 0;
 		}
-		uid = iwl_mvm_find_first_scan(mvm, IWL_MVM_SCAN_SCHED);
-		if (uid < mvm->max_scans && !mvm->restart_fw) {
+		uid = iwl_mvm_scan_uid_by_status(mvm, IWL_MVM_SCAN_SCHED);
+		if (uid >= 0 && !mvm->restart_fw) {
 			ieee80211_sched_scan_stopped(mvm->hw);
-			mvm->scan_uid[uid] = 0;
+			mvm->scan_uid_status[uid] = 0;
 		}
 
 		/* We shouldn't have any UIDs still set.  Loop over all the
@@ -1619,10 +1561,10 @@ void iwl_mvm_report_scan_aborted(struct iwl_mvm *mvm)
 		 * any is found.
 		 */
 		for (i = 0; i < mvm->max_scans; i++) {
-			if (WARN_ONCE(mvm->scan_uid[i],
-				      "UMAC scan UID %d was not cleaned\n",
-				      mvm->scan_uid[i]))
-				mvm->scan_uid[i] = 0;
+			if (WARN_ONCE(mvm->scan_uid_status[i],
+				      "UMAC scan UID %d status was not cleaned\n",
+				      i))
+				mvm->scan_uid_status[i] = 0;
 		}
 	} else {
 		if (mvm->scan_status & IWL_MVM_SCAN_REGULAR)
-- 
2.1.4

