Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:9552 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbbECTcp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:32:45 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 22/42] iwlwifi: mvm: combine parts of UMAC and LMAC sched scans
Date: Sun,  3 May 2015 22:31:33 +0300
Message-Id: <1430681513-7838-22-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213418_155978_5C7DF9E1)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Similarly to the regular scan patch, a lot of the UMAC and LMAC sched
scan code is also almost identical.  Grab the low hanging fruits by
combining the obvious parts.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 121 +++++++++++++-------------------
 1 file changed, 47 insertions(+), 74 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 0aa0857..7db3bf3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -894,32 +894,16 @@ static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 static int iwl_mvm_sched_scan_lmac(struct iwl_mvm *mvm,
 				   struct ieee80211_vif *vif,
 				   struct cfg80211_sched_scan_request *req,
-				   struct ieee80211_scan_ies *ies)
+				   struct ieee80211_scan_ies *ies,
+				   struct iwl_mvm_scan_params *params)
 {
-	struct iwl_host_cmd hcmd = {
-		.id = SCAN_OFFLOAD_REQUEST_CMD,
-		.len = { iwl_mvm_scan_size(mvm), },
-		.data = { mvm->scan_cmd, },
-		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
-	};
 	struct iwl_scan_req_lmac *cmd = mvm->scan_cmd;
 	struct iwl_scan_probe_req *preq;
-	struct iwl_mvm_scan_params params = {};
-	int ret;
 	u32 flags = 0, ssid_bitmap = 0;
 
 	lockdep_assert_held(&mvm->mutex);
 
-	/* we should have failed registration if scan_cmd was NULL */
-	if (WARN_ON(mvm->scan_cmd == NULL))
-		return -ENOMEM;
-
-	if (!iwl_mvm_scan_fits(mvm, req->n_ssids, ies, req->n_channels))
-		return -ENOBUFS;
-
-	iwl_mvm_scan_calc_params(mvm, vif, req->n_ssids, 0, &params);
-
-	iwl_mvm_build_generic_scan_cmd(mvm, cmd, &params);
+	iwl_mvm_build_generic_scan_cmd(mvm, cmd, params);
 
 	cmd->n_channels = (u8)req->n_channels;
 
@@ -933,7 +917,7 @@ static int iwl_mvm_sched_scan_lmac(struct iwl_mvm *mvm,
 	if (req->n_ssids == 1 && req->ssids[0].ssid_len != 0)
 		flags |= IWL_MVM_LMAC_SCAN_FLAG_PRE_CONNECTION;
 
-	if (params.passive_fragmented)
+	if (params->passive_fragmented)
 		flags |= IWL_MVM_LMAC_SCAN_FLAG_FRAGMENTED;
 
 	if (req->n_ssids == 0)
@@ -987,21 +971,7 @@ static int iwl_mvm_sched_scan_lmac(struct iwl_mvm *mvm,
 			req->mac_addr : NULL,
 		req->mac_addr_mask);
 
-	ret = iwl_mvm_send_cmd(mvm, &hcmd);
-	if (!ret) {
-		IWL_DEBUG_SCAN(mvm,
-			       "Sched scan request was sent successfully\n");
-	} else {
-		/*
-		 * If the scan failed, it usually means that the FW was unable
-		 * to allocate the time events. Warn on it, but maybe we
-		 * should try to send the command again with different params.
-		 */
-		IWL_ERR(mvm, "Sched scan failed! ret %d\n", ret);
-		mvm->scan_status &= ~IWL_MVM_SCAN_SCHED;
-		ret = -EIO;
-	}
-	return ret;
+	return 0;
 }
 
 
@@ -1325,23 +1295,16 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 static int iwl_mvm_sched_scan_umac(struct iwl_mvm *mvm,
 				   struct ieee80211_vif *vif,
 				   struct cfg80211_sched_scan_request *req,
-				   struct ieee80211_scan_ies *ies)
+				   struct ieee80211_scan_ies *ies,
+				   struct iwl_mvm_scan_params *params)
 {
-
-	struct iwl_host_cmd hcmd = {
-		.id = SCAN_REQ_UMAC,
-		.len = { iwl_mvm_scan_size(mvm), },
-		.data = { mvm->scan_cmd, },
-		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
-	};
 	struct iwl_scan_req_umac *cmd = mvm->scan_cmd;
 	struct iwl_scan_req_umac_tail *sec_part = (void *)&cmd->data +
 		sizeof(struct iwl_scan_channel_cfg_umac) *
 			mvm->fw->ucode_capa.n_scan_channels;
-	struct iwl_mvm_scan_params params = {};
 	u32 uid, flags;
 	u32 ssid_bitmap = 0;
-	int ret, uid_idx;
+	int uid_idx;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -1349,17 +1312,7 @@ static int iwl_mvm_sched_scan_umac(struct iwl_mvm *mvm,
 	if (uid_idx >= mvm->max_scans)
 		return -EBUSY;
 
-	/* we should have failed registration if scan_cmd was NULL */
-	if (WARN_ON(mvm->scan_cmd == NULL))
-		return -ENOMEM;
-
-	if (!iwl_mvm_scan_fits(mvm, req->n_ssids, ies, req->n_channels))
-		return -ENOBUFS;
-
-	iwl_mvm_scan_calc_params(mvm, vif, req->n_ssids, req->flags,
-					 &params);
-
-	iwl_mvm_build_generic_umac_scan_cmd(mvm, cmd, &params);
+	iwl_mvm_build_generic_umac_scan_cmd(mvm, cmd, params);
 
 	cmd->flags = cpu_to_le32(IWL_UMAC_SCAN_FLAG_PREEMPTIVE);
 
@@ -1370,7 +1323,7 @@ static int iwl_mvm_sched_scan_umac(struct iwl_mvm *mvm,
 	cmd->ooc_priority = cpu_to_le32(IWL_SCAN_PRIORITY_LOW);
 
 	flags = iwl_mvm_scan_umac_common_flags(mvm, req->n_ssids, req->ssids,
-					       params.passive_fragmented);
+					       params->passive_fragmented);
 
 	flags |= IWL_UMAC_SCAN_GEN_FLAGS_PERIODIC;
 
@@ -1415,19 +1368,7 @@ static int iwl_mvm_sched_scan_umac(struct iwl_mvm *mvm,
 			req->mac_addr : NULL,
 		req->mac_addr_mask);
 
-	ret = iwl_mvm_send_cmd(mvm, &hcmd);
-	if (!ret) {
-		IWL_DEBUG_SCAN(mvm,
-			       "Sched scan request was sent successfully\n");
-	} else {
-		/*
-		 * If the scan failed, it usually means that the FW was unable
-		 * to allocate the time events. Warn on it, but maybe we
-		 * should try to send the command again with different params.
-		 */
-		IWL_ERR(mvm, "Sched scan failed! ret %d\n", ret);
-	}
-	return ret;
+	return 0;
 }
 
 static int iwl_mvm_num_scans(struct iwl_mvm *mvm)
@@ -1547,6 +1488,12 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 			     struct ieee80211_scan_ies *ies,
 			     int type)
 {
+	struct iwl_host_cmd hcmd = {
+		.len = { iwl_mvm_scan_size(mvm), },
+		.data = { mvm->scan_cmd, },
+		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
+	};
+	struct iwl_mvm_scan_params params = {};
 	int ret;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -1560,16 +1507,42 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 	if (ret)
 		return ret;
 
+	/* we should have failed registration if scan_cmd was NULL */
+	if (WARN_ON(!mvm->scan_cmd))
+		return -ENOMEM;
+
+	if (!iwl_mvm_scan_fits(mvm, req->n_ssids, ies, req->n_channels))
+		return -ENOBUFS;
+
+	iwl_mvm_scan_calc_params(mvm, vif, req->n_ssids, req->flags,
+				 &params);
+
 	ret = iwl_mvm_config_sched_scan_profiles(mvm, req);
 	if (ret)
 		return ret;
 
 	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) {
-		ret = iwl_mvm_sched_scan_umac(mvm, vif, req, ies);
+		hcmd.id = SCAN_REQ_UMAC;
+		ret = iwl_mvm_sched_scan_umac(mvm, vif, req, ies, &params);
 	} else {
-		ret = iwl_mvm_sched_scan_lmac(mvm, vif, req, ies);
-		if (!ret)
-			mvm->scan_status |= IWL_MVM_SCAN_SCHED;
+		hcmd.id = SCAN_OFFLOAD_REQUEST_CMD;
+		ret = iwl_mvm_sched_scan_lmac(mvm, vif, req, ies, &params);
+	}
+
+	if (ret)
+		return ret;
+
+	ret = iwl_mvm_send_cmd(mvm, &hcmd);
+	if (!ret) {
+		IWL_DEBUG_SCAN(mvm,
+			       "Sched scan request was sent successfully\n");
+		mvm->scan_status |= type;
+	} else {
+		/* If the scan failed, it usually means that the FW was unable
+		 * to allocate the time events. Warn on it, but maybe we
+		 * should try to send the command again with different params.
+		 */
+		IWL_ERR(mvm, "Sched scan failed! ret %d\n", ret);
 	}
 
 	return ret;
-- 
2.1.0

