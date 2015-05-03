Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:9552 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbbECTcm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:32:42 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 21/42] iwlwifi: mvm: combine parts of UMAC and LMAC scans
Date: Sun,  3 May 2015 22:31:32 +0300
Message-Id: <1430681513-7838-21-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213425_382450_FA5D3136)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

A lot of the UMAC and LMAC scan code is almost identical.  Grab the
low hanging fruits by combining the obvious parts.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 125 +++++++++++++-------------------
 1 file changed, 50 insertions(+), 75 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 95b9862..0aa0857 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -815,36 +815,18 @@ static inline bool iwl_mvm_scan_fits(struct iwl_mvm *mvm, int n_ssids,
 
 static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			     struct cfg80211_scan_request *req,
-			     struct ieee80211_scan_ies *ies)
+			     struct ieee80211_scan_ies *ies,
+			     struct iwl_mvm_scan_params *params)
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
 	u32 flags;
 	u32 ssid_bitmap = 0;
-	int ret, i;
+	int i;
 
 	lockdep_assert_held(&mvm->mutex);
 
-	/* we should have failed registration if scan_cmd was NULL */
-	if (WARN_ON(mvm->scan_cmd == NULL))
-		return -ENOMEM;
-
-	if (!iwl_mvm_scan_fits(mvm, req->n_ssids, ies, req->n_channels))
-		return -ENOBUFS;
-
-	mvm->scan_status |= IWL_MVM_SCAN_REGULAR;
-
-	iwl_mvm_scan_calc_params(mvm, vif, req->n_ssids, req->flags,
-				 &params);
-
-	iwl_mvm_build_generic_scan_cmd(mvm, cmd, &params);
+	iwl_mvm_build_generic_scan_cmd(mvm, cmd, params);
 
 	cmd->n_channels = (u8)req->n_channels;
 
@@ -853,7 +835,7 @@ static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (req->n_ssids == 1 && req->ssids[0].ssid_len != 0)
 		flags |= IWL_MVM_LMAC_SCAN_FLAG_PRE_CONNECTION;
 
-	if (params.passive_fragmented)
+	if (params->passive_fragmented)
 		flags |= IWL_MVM_LMAC_SCAN_FLAG_FRAGMENTED;
 
 	if (req->n_ssids == 0)
@@ -906,20 +888,7 @@ static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			req->mac_addr : NULL,
 		req->mac_addr_mask);
 
-	ret = iwl_mvm_send_cmd(mvm, &hcmd);
-	if (!ret) {
-		IWL_DEBUG_SCAN(mvm, "Scan request was sent successfully\n");
-	} else {
-		/*
-		 * If the scan failed, it usually means that the FW was unable
-		 * to allocate the time events. Warn on it, but maybe we
-		 * should try to send the command again with different params.
-		 */
-		IWL_ERR(mvm, "Scan failed! ret %d\n", ret);
-		mvm->scan_status &= ~IWL_MVM_SCAN_REGULAR;
-		ret = -EIO;
-	}
-	return ret;
+	return 0;
 }
 
 static int iwl_mvm_sched_scan_lmac(struct iwl_mvm *mvm,
@@ -1292,22 +1261,16 @@ static u32 iwl_mvm_scan_umac_common_flags(struct iwl_mvm *mvm, int n_ssids,
 
 static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			     struct cfg80211_scan_request *req,
-			     struct ieee80211_scan_ies *ies)
+			     struct ieee80211_scan_ies *ies,
+			     struct iwl_mvm_scan_params *params)
 {
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
-	int ret, i, uid_idx;
+	int i, uid_idx;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -1315,17 +1278,7 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
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
-				 &params);
-
-	iwl_mvm_build_generic_umac_scan_cmd(mvm, cmd, &params);
+	iwl_mvm_build_generic_umac_scan_cmd(mvm, cmd, params);
 
 	uid = iwl_generate_scan_uid(mvm, IWL_UMAC_SCAN_UID_REG_SCAN);
 	mvm->scan_uid[uid_idx] = uid;
@@ -1335,7 +1288,7 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	flags = iwl_mvm_scan_umac_common_flags(mvm, req->n_ssids,
 					       req->ssids,
-					       params.passive_fragmented);
+					       params->passive_fragmented);
 
 	flags |= IWL_UMAC_SCAN_GEN_FLAGS_PASS_ALL;
 
@@ -1366,19 +1319,7 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	iwl_mvm_scan_fill_ssids(sec_part->direct_scan, req->ssids,
 				req->n_ssids, 0);
 
-	ret = iwl_mvm_send_cmd(mvm, &hcmd);
-	if (!ret) {
-		IWL_DEBUG_SCAN(mvm,
-			       "Scan request was sent successfully\n");
-	} else {
-		/*
-		 * If the scan failed, it usually means that the FW was unable
-		 * to allocate the time events. Warn on it, but maybe we
-		 * should try to send the command again with different params.
-		 */
-		IWL_ERR(mvm, "Scan failed! ret %d\n", ret);
-	}
-	return ret;
+	return 0;
 }
 
 static int iwl_mvm_sched_scan_umac(struct iwl_mvm *mvm,
@@ -1540,6 +1481,12 @@ int iwl_mvm_reg_scan_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			   struct cfg80211_scan_request *req,
 			   struct ieee80211_scan_ies *ies)
 {
+	struct iwl_host_cmd hcmd = {
+		.len = { iwl_mvm_scan_size(mvm), },
+		.data = { mvm->scan_cmd, },
+		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
+	};
+	struct iwl_mvm_scan_params params = {};
 	int ret;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -1555,10 +1502,38 @@ int iwl_mvm_reg_scan_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	iwl_mvm_ref(mvm, IWL_MVM_REF_SCAN);
 
-	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
-		ret = iwl_mvm_scan_umac(mvm, vif, req, ies);
-	else
-		ret = iwl_mvm_scan_lmac(mvm, vif, req, ies);
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
+	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) {
+		hcmd.id = SCAN_REQ_UMAC;
+		ret = iwl_mvm_scan_umac(mvm, vif, req, ies, &params);
+	} else {
+		hcmd.id = SCAN_OFFLOAD_REQUEST_CMD;
+		ret = iwl_mvm_scan_lmac(mvm, vif, req, ies, &params);
+	}
+
+	if (ret)
+		return ret;
+
+	ret = iwl_mvm_send_cmd(mvm, &hcmd);
+	if (!ret) {
+		IWL_DEBUG_SCAN(mvm, "Scan request was sent successfully\n");
+		mvm->scan_status |= IWL_MVM_SCAN_REGULAR;
+	} else {
+		/* If the scan failed, it usually means that the FW was unable
+		 * to allocate the time events. Warn on it, but maybe we
+		 * should try to send the command again with different params.
+		 */
+		IWL_ERR(mvm, "Scan failed! ret %d\n", ret);
+	}
 
 	if (ret)
 		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
-- 
2.1.0

