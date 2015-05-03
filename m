Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:1907 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651AbbECTca (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:32:30 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/42] iwlwifi: mvm: generalize the other-scan stopping code
Date: Sun,  3 May 2015 22:31:20 +0300
Message-Id: <1430681513-7838-9-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213236_043009_2CFEA3AF)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Instead of hardcoding the differences between UMAC scans and LMAC
scans (which in this case is the number of simultaneous scans that can
run), introduce a max_scans variable and stop scans of the other type
(i.e. stop sched scan if regular scan is being attempted and
vice-versa) if the number of running scans reached the maximum.

Add a function that checks if the maximum number of scans was reached
and stops the appropriate scan to make room for the new scan.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h | 10 ++--
 drivers/net/wireless/iwlwifi/mvm/mac80211.c    | 74 ++++++++++++++++++--------
 drivers/net/wireless/iwlwifi/mvm/mvm.h         |  5 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c        | 25 +++++----
 4 files changed, 76 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
index d6cced4..69daa4e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -32,7 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -582,7 +582,11 @@ struct iwl_mvm_umac_cmd_hdr {
 	u8 ver;
 } __packed;
 
-#define IWL_MVM_MAX_SIMULTANEOUS_SCANS 8
+/* The maximum of either of these cannot exceed 8, because we use an
+ * 8-bit mask (see IWL_MVM_SCAN_MASK in mvm.h).
+ */
+#define IWL_MVM_MAX_UMAC_SCANS 8
+#define IWL_MVM_MAX_LMAC_SCANS 1
 
 enum scan_config_flags {
 	SCAN_CONFIG_FLAG_ACTIVATE			= BIT(0),
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index f57d584..a5fe070 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -510,6 +510,14 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 
 	hw->wiphy->max_scan_ssids = PROBE_OPTION_MAX;
 
+	BUILD_BUG_ON(IWL_MVM_MAX_UMAC_SCANS > HWEIGHT32(IWL_MVM_SCAN_MASK) ||
+		     IWL_MVM_MAX_LMAC_SCANS > HWEIGHT32(IWL_MVM_SCAN_MASK));
+
+	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
+		mvm->max_scans = IWL_MVM_MAX_UMAC_SCANS;
+	else
+		mvm->max_scans = IWL_MVM_MAX_LMAC_SCANS;
+
 	if (mvm->nvm_data->bands[IEEE80211_BAND_2GHZ].n_channels)
 		hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
 			&mvm->nvm_data->bands[IEEE80211_BAND_2GHZ];
@@ -1426,7 +1434,7 @@ void __iwl_mvm_mac_stop(struct iwl_mvm *mvm)
 	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) {
 		int i;
 
-		for (i = 0; i < IWL_MVM_MAX_SIMULTANEOUS_SCANS; i++) {
+		for (i = 0; i < mvm->max_scans; i++) {
 			if (WARN_ONCE(mvm->scan_uid[i],
 				      "UMAC scan UID %d was not cleaned\n",
 				      mvm->scan_uid[i]))
@@ -2373,6 +2381,46 @@ static void iwl_mvm_bss_info_changed(struct ieee80211_hw *hw,
 	iwl_mvm_unref(mvm, IWL_MVM_REF_BSS_CHANGED);
 }
 
+static int iwl_mvm_num_scans(struct iwl_mvm *mvm)
+{
+	return hweight32(mvm->scan_status & IWL_MVM_SCAN_MASK);
+}
+
+static int iwl_mvm_check_running_scans(struct iwl_mvm *mvm, int type)
+{
+	/* This looks a bit arbitrary, but the idea is that if we run
+	 * out of possible simultaneous scans and the userspace is
+	 * trying to run a scan type that is already running, we
+	 * return -EBUSY.  But if the userspace wants to start a
+	 * different type of scan, we stop the opposite type to make
+	 * space for the new request.  The reason is backwards
+	 * compatibility with old wpa_supplicant that wouldn't stop a
+	 * scheduled scan before starting a normal scan.
+	 */
+
+	if (iwl_mvm_num_scans(mvm) < mvm->max_scans)
+		return 0;
+
+	/* Use a switch, even though this is a bitmask, so that more
+	 * than one bits set will fall in default and we will warn.
+	 */
+	switch (type) {
+	case IWL_MVM_SCAN_REGULAR:
+		if (mvm->scan_status & IWL_MVM_SCAN_REGULAR_MASK)
+			return -EBUSY;
+		return iwl_mvm_scan_offload_stop(mvm, true);
+	case IWL_MVM_SCAN_SCHED:
+		if (mvm->scan_status & IWL_MVM_SCAN_SCHED_MASK)
+			return -EBUSY;
+		return iwl_mvm_cancel_scan(mvm);
+	default:
+		WARN_ON(1);
+		break;
+	}
+
+	return -EIO;
+}
+
 static int iwl_mvm_mac_hw_scan(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif,
 			       struct ieee80211_scan_request *hw_req)
@@ -2393,17 +2441,9 @@ static int iwl_mvm_mac_hw_scan(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	if (mvm->scan_status & IWL_MVM_SCAN_REGULAR) {
-		ret = -EBUSY;
+	ret = iwl_mvm_check_running_scans(mvm, IWL_MVM_SCAN_REGULAR);
+	if (ret)
 		goto out;
-	}
-
-	if (!(mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) &&
-	    (mvm->scan_status & IWL_MVM_SCAN_SCHED)) {
-		ret = iwl_mvm_scan_offload_stop(mvm, true);
-		if (ret)
-			goto out;
-	}
 
 	iwl_mvm_ref(mvm, IWL_MVM_REF_SCAN);
 
@@ -2769,17 +2809,9 @@ static int iwl_mvm_mac_sched_scan_start(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	if (mvm->scan_status & IWL_MVM_SCAN_SCHED) {
-		ret = -EBUSY;
+	ret = iwl_mvm_check_running_scans(mvm, IWL_MVM_SCAN_SCHED);
+	if (ret)
 		goto out;
-	}
-
-	if (!(mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) &&
-	    (mvm->scan_status & IWL_MVM_SCAN_REGULAR)) {
-		ret = iwl_mvm_cancel_scan(mvm);
-		if (ret)
-			goto out;
-	}
 
 	ret = iwl_mvm_scan_offload_start(mvm, vif, req, ies);
 	if (ret)
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index a8648fa..cb99eb7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -661,8 +661,11 @@ struct iwl_mvm {
 	void *scan_cmd;
 	struct iwl_mcast_filter_cmd *mcast_filter_cmd;
 
+	/* max number of simultaneous scans the FW supports */
+	unsigned int max_scans;
+
 	/* UMAC scan tracking */
-	u32 scan_uid[IWL_MVM_MAX_SIMULTANEOUS_SCANS];
+	u32 scan_uid[IWL_MVM_MAX_UMAC_SCANS];
 	u8 scan_seq_num, sched_scan_seq_num;
 
 	/* rx chain antennas set through debugfs for the scan command */
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 833d078..3721b16 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -1200,7 +1200,7 @@ static int iwl_mvm_find_scan_uid(struct iwl_mvm *mvm, u32 uid)
 {
 	int i;
 
-	for (i = 0; i < IWL_MVM_MAX_SIMULTANEOUS_SCANS; i++)
+	for (i = 0; i < mvm->max_scans; i++)
 		if (mvm->scan_uid[i] == uid)
 			return i;
 
@@ -1217,7 +1217,7 @@ static bool iwl_mvm_find_scan_type(struct iwl_mvm *mvm,
 {
 	int i;
 
-	for (i = 0; i < IWL_MVM_MAX_SIMULTANEOUS_SCANS; i++)
+	for (i = 0; i < mvm->max_scans; i++)
 		if (mvm->scan_uid[i] & type)
 			return true;
 
@@ -1229,7 +1229,7 @@ static int iwl_mvm_find_first_scan(struct iwl_mvm *mvm,
 {
 	int i;
 
-	for (i = 0; i < IWL_MVM_MAX_SIMULTANEOUS_SCANS; i++)
+	for (i = 0; i < mvm->max_scans; i++)
 		if (mvm->scan_uid[i] & type)
 			return i;
 
@@ -1253,8 +1253,7 @@ static u32 iwl_generate_scan_uid(struct iwl_mvm *mvm,
 		uid = type | (mvm->scan_seq_num <<
 			      IWL_UMAC_SCAN_UID_SEQ_OFFSET);
 		mvm->scan_seq_num++;
-	} while (iwl_mvm_find_scan_uid(mvm, uid) <
-		 IWL_MVM_MAX_SIMULTANEOUS_SCANS);
+	} while (iwl_mvm_find_scan_uid(mvm, uid) < mvm->max_scans);
 
 	IWL_DEBUG_SCAN(mvm, "Generated scan UID %u\n", uid);
 
@@ -1338,7 +1337,7 @@ int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	lockdep_assert_held(&mvm->mutex);
 
 	uid_idx = iwl_mvm_find_free_scan_uid(mvm);
-	if (uid_idx >= IWL_MVM_MAX_SIMULTANEOUS_SCANS)
+	if (uid_idx >= mvm->max_scans)
 		return -EBUSY;
 
 	/* we should have failed registration if scan_cmd was NULL */
@@ -1435,7 +1434,7 @@ int iwl_mvm_sched_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	lockdep_assert_held(&mvm->mutex);
 
 	uid_idx = iwl_mvm_find_free_scan_uid(mvm);
-	if (uid_idx >= IWL_MVM_MAX_SIMULTANEOUS_SCANS)
+	if (uid_idx >= mvm->max_scans)
 		return -EBUSY;
 
 	/* we should have failed registration if scan_cmd was NULL */
@@ -1536,7 +1535,7 @@ int iwl_mvm_rx_umac_scan_complete_notif(struct iwl_mvm *mvm,
 	/*
 	 * Scan uid may be set to zero in case of scan abort request from above.
 	 */
-	if (uid_idx >= IWL_MVM_MAX_SIMULTANEOUS_SCANS)
+	if (uid_idx >= mvm->max_scans)
 		return 0;
 
 	IWL_DEBUG_SCAN(mvm,
@@ -1577,7 +1576,7 @@ static bool iwl_scan_umac_done_check(struct iwl_notif_wait_data *notif_wait,
 	if (WARN_ON(pkt->hdr.cmd != SCAN_COMPLETE_UMAC))
 		return false;
 
-	if (uid_idx >= IWL_MVM_MAX_SIMULTANEOUS_SCANS)
+	if (uid_idx >= scan_done->mvm->max_scans)
 		return false;
 
 	/*
@@ -1626,7 +1625,7 @@ static int iwl_umac_scan_stop(struct iwl_mvm *mvm,
 
 	IWL_DEBUG_SCAN(mvm, "Preparing to stop scan, type %x\n", type);
 
-	for (i = 0; i < IWL_MVM_MAX_SIMULTANEOUS_SCANS; i++) {
+	for (i = 0; i < mvm->max_scans; i++) {
 		if (mvm->scan_uid[i] & type) {
 			int err;
 
@@ -1689,13 +1688,13 @@ void iwl_mvm_report_scan_aborted(struct iwl_mvm *mvm)
 		u32 uid, i;
 
 		uid = iwl_mvm_find_first_scan(mvm, IWL_UMAC_SCAN_UID_REG_SCAN);
-		if (uid < IWL_MVM_MAX_SIMULTANEOUS_SCANS) {
+		if (uid < mvm->max_scans) {
 			ieee80211_scan_completed(mvm->hw, true);
 			mvm->scan_uid[uid] = 0;
 		}
 		uid = iwl_mvm_find_first_scan(mvm,
 					      IWL_UMAC_SCAN_UID_SCHED_SCAN);
-		if (uid < IWL_MVM_MAX_SIMULTANEOUS_SCANS && !mvm->restart_fw) {
+		if (uid < mvm->max_scans && !mvm->restart_fw) {
 			ieee80211_sched_scan_stopped(mvm->hw);
 			mvm->scan_uid[uid] = 0;
 		}
@@ -1704,7 +1703,7 @@ void iwl_mvm_report_scan_aborted(struct iwl_mvm *mvm)
 		 * UIDs to make sure there's nothing left there and warn if
 		 * any is found.
 		 */
-		for (i = 0; i < IWL_MVM_MAX_SIMULTANEOUS_SCANS; i++) {
+		for (i = 0; i < mvm->max_scans; i++) {
 			if (WARN_ONCE(mvm->scan_uid[i],
 				      "UMAC scan UID %d was not cleaned\n",
 				      mvm->scan_uid[i]))
-- 
2.1.0

