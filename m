Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:9552 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbbECTcy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:32:54 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 26/42] iwlwifi: mvm: combine SSID functions for sched and regular scans
Date: Sun,  3 May 2015 22:31:37 +0300
Message-Id: <1430681513-7838-26-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213307_181243_D4488ED1)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Now that both scheduled scan and regular scan SSID populating
functions do the same thing, they can be combined into a single
function.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 71 +++++++++++----------------------
 1 file changed, 24 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 785e99c..36254c5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -156,31 +156,6 @@ iwl_mvm_scan_rate_n_flags(struct iwl_mvm *mvm, enum ieee80211_band band,
 }
 
 /*
- * We insert the SSIDs in an inverted order, because the FW will
- * invert it back. The most prioritized SSID, which is first in the
- * request list, is not copied here, but inserted directly to the probe
- * request.
- */
-static void iwl_mvm_scan_fill_ssids(struct iwl_ssid_ie *cmd_ssid,
-				    struct iwl_mvm_scan_params *params,
-				    u32 *ssid_bitmap)
-{
-	int fw_idx, req_idx, i;
-
-	for (req_idx = params->n_ssids - 1, fw_idx = 0; req_idx >= 0;
-	     req_idx--, fw_idx++) {
-		cmd_ssid[fw_idx].id = WLAN_EID_SSID;
-		cmd_ssid[fw_idx].len = params->ssids[req_idx].ssid_len;
-		memcpy(cmd_ssid[fw_idx].ssid,
-		       params->ssids[req_idx].ssid,
-		       params->ssids[req_idx].ssid_len);
-	}
-
-	for (i = 0; i < params->n_ssids; i++)
-		*ssid_bitmap |= BIT(i);
-}
-
-/*
  * If req->n_ssids > 0, it means we should do an active scan.
  * In case of active scan w/o directed scan, we receive a zero-length SSID
  * just to notify that this scan is active and not passive.
@@ -445,9 +420,12 @@ static int iwl_ssid_exist(u8 *ssid, u8 ssid_len, struct iwl_ssid_ie *ssid_list)
 	return -1;
 }
 
-static void iwl_scan_offload_build_ssid(struct iwl_mvm_scan_params *params,
-					struct iwl_ssid_ie *ssid,
-					u32 *ssid_bitmap)
+/* We insert the SSIDs in an inverted order, because the FW will
+ * invert it back.
+ */
+static void iwl_scan_build_ssids(struct iwl_mvm_scan_params *params,
+				 struct iwl_ssid_ie *ssids,
+				 u32 *ssid_bitmap)
 {
 	int i, j;
 	int index;
@@ -463,10 +441,10 @@ static void iwl_scan_offload_build_ssid(struct iwl_mvm_scan_params *params,
 		/* skip empty SSID matchsets */
 		if (!params->match_sets[j].ssid.ssid_len)
 			continue;
-		ssid[i].id = WLAN_EID_SSID;
-		ssid[i].len = params->match_sets[j].ssid.ssid_len;
-		memcpy(ssid[i].ssid, params->match_sets[j].ssid.ssid,
-		       ssid[i].len);
+		ssids[i].id = WLAN_EID_SSID;
+		ssids[i].len = params->match_sets[j].ssid.ssid_len;
+		memcpy(ssids[i].ssid, params->match_sets[j].ssid.ssid,
+		       ssids[i].len);
 	}
 
 	/* add SSIDs from scan SSID list */
@@ -476,17 +454,17 @@ static void iwl_scan_offload_build_ssid(struct iwl_mvm_scan_params *params,
 	     i++, j--) {
 		index = iwl_ssid_exist(params->ssids[j].ssid,
 				       params->ssids[j].ssid_len,
-				       ssid);
+				       ssids);
 		if (index < 0) {
 			if (!params->ssids[j].ssid_len)
 				continue;
-			ssid[i].id = WLAN_EID_SSID;
-			ssid[i].len = params->ssids[j].ssid_len;
-			memcpy(ssid[i].ssid, params->ssids[j].ssid,
-			       ssid[i].len);
-			*ssid_bitmap |= BIT(i + 1);
+			ssids[i].id = WLAN_EID_SSID;
+			ssids[i].len = params->ssids[j].ssid_len;
+			memcpy(ssids[i].ssid, params->ssids[j].ssid,
+			       ssids[i].len);
+			*ssid_bitmap |= BIT(i);
 		} else {
-			*ssid_bitmap |= BIT(index + 1);
+			*ssid_bitmap |= BIT(index);
 		}
 	}
 }
@@ -876,7 +854,7 @@ static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	cmd->filter_flags = cpu_to_le32(MAC_FILTER_ACCEPT_GRP |
 					MAC_FILTER_IN_BEACON);
 	iwl_mvm_scan_fill_tx_cmd(mvm, cmd->tx_cmd, params->no_cck);
-	iwl_mvm_scan_fill_ssids(cmd->direct_scan, params, &ssid_bitmap);
+	iwl_scan_build_ssids(params, cmd->direct_scan, &ssid_bitmap);
 
 	/* this API uses bits 1-20 instead of 0-19 */
 	ssid_bitmap <<= 1;
@@ -961,7 +939,10 @@ iwl_mvm_sched_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 					MAC_FILTER_IN_BEACON);
 	iwl_mvm_scan_fill_tx_cmd(mvm, cmd->tx_cmd, params->no_cck);
 
-	iwl_scan_offload_build_ssid(params, cmd->direct_scan, &ssid_bitmap);
+	iwl_scan_build_ssids(params, cmd->direct_scan, &ssid_bitmap);
+
+	/* this API uses bits 1-20 instead of 0-19 */
+	ssid_bitmap <<= 1;
 
 	cmd->schedule[0].delay = cpu_to_le16(params->interval);
 	cmd->schedule[0].iterations = IWL_FAST_SCHED_SCAN_ITERATIONS;
@@ -1301,7 +1282,7 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	cmd->n_channels = params->n_channels;
 
-	iwl_mvm_scan_fill_ssids(sec_part->direct_scan, params, &ssid_bitmap);
+	iwl_scan_build_ssids(params, sec_part->direct_scan, &ssid_bitmap);
 
 	iwl_mvm_umac_scan_cfg_channels(mvm, params->channels,
 				       params->n_channels, ssid_bitmap, cmd);
@@ -1367,11 +1348,7 @@ static int iwl_mvm_sched_scan_umac(struct iwl_mvm *mvm,
 
 	cmd->n_channels = params->n_channels;
 
-	iwl_scan_offload_build_ssid(params, sec_part->direct_scan,
-				    &ssid_bitmap);
-
-	/* This API uses bits 0-19 instead of 1-20. */
-	ssid_bitmap = ssid_bitmap >> 1;
+	iwl_scan_build_ssids(params, sec_part->direct_scan, &ssid_bitmap);
 
 	iwl_mvm_umac_scan_cfg_channels(mvm, params->channels,
 				       params->n_channels, ssid_bitmap, cmd);
-- 
2.1.0

