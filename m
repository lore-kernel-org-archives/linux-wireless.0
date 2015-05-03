Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:9552 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbbECTct (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:32:49 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 24/42] iwlwifi: mvm: combine ssid_bitmap setting for regular scans
Date: Sun,  3 May 2015 22:31:35 +0300
Message-Id: <1430681513-7838-24-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213304_420386_5181F7CF)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

The only difference in the ssid_bitmap between LMAC and UMAC scans is
that in LMAC bits 1 to 20 are used, while in UMAC bits 0 to 19 are
used (*sigh*).  So we can combine the bitmap creation into a single
function and simply shift left if LMAC is used.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 2836792..551f66d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -162,9 +162,10 @@ iwl_mvm_scan_rate_n_flags(struct iwl_mvm *mvm, enum ieee80211_band band,
  * request.
  */
 static void iwl_mvm_scan_fill_ssids(struct iwl_ssid_ie *cmd_ssid,
-				    struct iwl_mvm_scan_params *params)
+				    struct iwl_mvm_scan_params *params,
+				    u32 *ssid_bitmap)
 {
-	int fw_idx, req_idx;
+	int fw_idx, req_idx, i;
 
 	for (req_idx = params->n_ssids - 1, fw_idx = 0; req_idx >= 0;
 	     req_idx--, fw_idx++) {
@@ -174,6 +175,9 @@ static void iwl_mvm_scan_fill_ssids(struct iwl_ssid_ie *cmd_ssid,
 		       params->ssids[req_idx].ssid,
 		       params->ssids[req_idx].ssid_len);
 	}
+
+	for (i = 0; i < params->n_ssids; i++)
+		*ssid_bitmap |= BIT(i);
 }
 
 /*
@@ -834,7 +838,6 @@ static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	struct iwl_scan_req_lmac *cmd = mvm->scan_cmd;
 	struct iwl_scan_probe_req *preq;
 	u32 flags = 0, ssid_bitmap = 0;
-	int i;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -870,7 +873,10 @@ static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	cmd->filter_flags = cpu_to_le32(MAC_FILTER_ACCEPT_GRP |
 					MAC_FILTER_IN_BEACON);
 	iwl_mvm_scan_fill_tx_cmd(mvm, cmd->tx_cmd, params->no_cck);
-	iwl_mvm_scan_fill_ssids(cmd->direct_scan, params);
+	iwl_mvm_scan_fill_ssids(cmd->direct_scan, params, &ssid_bitmap);
+
+	/* this API uses bits 1-20 instead of 0-19 */
+	ssid_bitmap <<= 1;
 
 	cmd->schedule[0].delay = cpu_to_le16(params->interval);
 	cmd->schedule[0].iterations = 1;
@@ -895,9 +901,6 @@ static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			cpu_to_le16(IWL_SPARSE_EBS_SCAN_RATIO);
 	}
 
-	for (i = 1; i <= params->n_ssids; i++)
-		ssid_bitmap |= BIT(i);
-
 	iwl_mvm_lmac_scan_cfg_channels(mvm, params->channels,
 				       params->n_channels, ssid_bitmap, cmd);
 
@@ -1260,7 +1263,7 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			mvm->fw->ucode_capa.n_scan_channels;
 	u32 uid, flags;
 	u32 ssid_bitmap = 0;
-	int uid_idx, i;
+	int uid_idx;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -1295,8 +1298,7 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	cmd->n_channels = params->n_channels;
 
-	for (i = 0; i < params->n_ssids; i++)
-		ssid_bitmap |= BIT(i);
+	iwl_mvm_scan_fill_ssids(sec_part->direct_scan, params, &ssid_bitmap);
 
 	iwl_mvm_umac_scan_cfg_channels(mvm, params->channels,
 				       params->n_channels, ssid_bitmap, cmd);
@@ -1309,8 +1311,6 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			params->mac_addr : NULL,
 		params->mac_addr_mask);
 
-	iwl_mvm_scan_fill_ssids(sec_part->direct_scan, params);
-
 	return 0;
 }
 
-- 
2.1.0

