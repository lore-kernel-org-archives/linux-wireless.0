Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:9552 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbbECTdU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:33:20 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 38/42] iwlwifi: mvm: rename generic_scan_cmd functions to dwell
Date: Sun,  3 May 2015 22:31:49 +0300
Message-Id: <1430681513-7838-38-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213347_619928_58DBDDC0)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

The generic scan command functions are now irrelevant, since both
sched and regular scans are in the same code.  So rename this
functions to dwell and isolate all the dwell-related setting to them.
Keeping the dwell code separate makes it easier to compare the LMAC
and UMAC versions.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 40 +++++++++++++++++----------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 277fe79..8646887 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -782,22 +782,18 @@ iwl_mvm_build_scan_probe(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	params->preq.common_data.len = cpu_to_le16(ies->common_ie_len);
 }
 
-static void
-iwl_mvm_build_generic_scan_cmd(struct iwl_mvm *mvm,
-			       struct iwl_scan_req_lmac *cmd,
-			       struct iwl_mvm_scan_params *params)
+static void iwl_mvm_scan_lmac_dwell(struct iwl_mvm *mvm,
+				    struct iwl_scan_req_lmac *cmd,
+				    struct iwl_mvm_scan_params *params)
 {
-	memset(cmd, 0, ksize(cmd));
 	cmd->active_dwell = params->dwell[IEEE80211_BAND_2GHZ].active;
 	cmd->passive_dwell = params->dwell[IEEE80211_BAND_2GHZ].passive;
 	if (params->passive_fragmented)
 		cmd->fragmented_dwell =
 				params->dwell[IEEE80211_BAND_2GHZ].fragmented;
-	cmd->rx_chain_select = iwl_mvm_scan_rx_chain(mvm);
 	cmd->max_out_time = cpu_to_le32(params->max_out_time);
 	cmd->suspend_time = cpu_to_le32(params->suspend_time);
 	cmd->scan_prio = cpu_to_le32(IWL_SCAN_PRIORITY_HIGH);
-	cmd->iter_num = cpu_to_le32(1);
 }
 
 static inline bool iwl_mvm_scan_fits(struct iwl_mvm *mvm, int n_ssids,
@@ -874,8 +870,12 @@ static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	lockdep_assert_held(&mvm->mutex);
 
-	iwl_mvm_build_generic_scan_cmd(mvm, cmd, params);
+	memset(cmd, 0, ksize(cmd));
+
+	iwl_mvm_scan_lmac_dwell(mvm, cmd, params);
 
+	cmd->rx_chain_select = iwl_mvm_scan_rx_chain(mvm);
+	cmd->iter_num = cpu_to_le32(1);
 	cmd->n_channels = (u8)params->n_channels;
 
 	cmd->delay = cpu_to_le32(params->delay);
@@ -1119,14 +1119,10 @@ static u32 iwl_generate_scan_uid(struct iwl_mvm *mvm,
 	return uid;
 }
 
-static void
-iwl_mvm_build_generic_umac_scan_cmd(struct iwl_mvm *mvm,
+static void iwl_mvm_scan_umac_dwell(struct iwl_mvm *mvm,
 				    struct iwl_scan_req_umac *cmd,
 				    struct iwl_mvm_scan_params *params)
 {
-	memset(cmd, 0, ksize(cmd));
-	cmd->hdr.size = cpu_to_le16(iwl_mvm_scan_size(mvm) -
-				    sizeof(struct iwl_mvm_umac_cmd_hdr));
 	cmd->active_dwell = params->dwell[IEEE80211_BAND_2GHZ].active;
 	cmd->passive_dwell = params->dwell[IEEE80211_BAND_2GHZ].passive;
 	if (params->passive_fragmented)
@@ -1135,6 +1131,11 @@ iwl_mvm_build_generic_umac_scan_cmd(struct iwl_mvm *mvm,
 	cmd->max_out_time = cpu_to_le32(params->max_out_time);
 	cmd->suspend_time = cpu_to_le32(params->suspend_time);
 	cmd->scan_priority = cpu_to_le32(IWL_SCAN_PRIORITY_HIGH);
+
+	if (iwl_mvm_scan_total_iterations(params) == 0)
+		cmd->ooc_priority = cpu_to_le32(IWL_SCAN_PRIORITY_HIGH);
+	else
+		cmd->ooc_priority = cpu_to_le32(IWL_SCAN_PRIORITY_LOW);
 }
 
 static void
@@ -1200,15 +1201,16 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (uid_idx >= mvm->max_scans)
 		return -EBUSY;
 
-	iwl_mvm_build_generic_umac_scan_cmd(mvm, cmd, params);
+	memset(cmd, 0, ksize(cmd));
+	cmd->hdr.size = cpu_to_le16(iwl_mvm_scan_size(mvm) -
+				    sizeof(struct iwl_mvm_umac_cmd_hdr));
 
-	if (n_iterations == 1) {
-		cmd->ooc_priority = cpu_to_le32(IWL_SCAN_PRIORITY_HIGH);
+	iwl_mvm_scan_umac_dwell(mvm, cmd, params);
+
+	if (n_iterations == 1)
 		uid = iwl_generate_scan_uid(mvm, IWL_UMAC_SCAN_UID_REG_SCAN);
-	} else {
-		cmd->ooc_priority = cpu_to_le32(IWL_SCAN_PRIORITY_LOW);
+	else
 		uid = iwl_generate_scan_uid(mvm, IWL_UMAC_SCAN_UID_SCHED_SCAN);
-	}
 
 	mvm->scan_uid[uid_idx] = uid;
 	cmd->uid = cpu_to_le32(uid);
-- 
2.1.0

