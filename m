Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:38566 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756298AbaCROqy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:46:54 -0400
Received: by mail-ee0-f54.google.com with SMTP id d49so5431104eek.41
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:46:53 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 30/35] iwlwifi: mvm: restructure scan parameters calculation
Date: Tue, 18 Mar 2014 16:45:34 +0200
Message-Id: <1395153939-23897-30-git-send-email-egrumbach@gmail.com> (sfid-20140318_154704_004228_A9376CD2)
In-Reply-To: <53285AF8.7050305@gmail.com>
References: <53285AF8.7050305@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

Some scan parameters should be dependent on traffic conditions.
Centralize conditions verification in one function and obtain
scan max out-of-channel and suspend time in that new function.
Rely on bound interfaces indication instead of association state
to calculate scan parameters. If no bound interfaces use default
values for out-of-channel and suspend time parameters.

Additionally, get rid of NL80211_SCAN_FLAG_LOW_PRIORITY checks
since no use case for this exists so far.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
[reword commit log a bit]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  3 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c     | 82 ++++++++++++++---------------
 2 files changed, 41 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 8414c03..dbe6ff8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -375,8 +375,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	}
 
 	hw->wiphy->features |= NL80211_FEATURE_P2P_GO_CTWIN |
-			       NL80211_FEATURE_P2P_GO_OPPPS |
-			       NL80211_FEATURE_LOW_PRIORITY_SCAN;
+			       NL80211_FEATURE_P2P_GO_OPPPS;
 
 	mvm->rts_threshold = IEEE80211_MAX_RTS_THRESHOLD;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 945398b..ee3f67f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -70,9 +70,11 @@
 
 #define IWL_PLCP_QUIET_THRESH 1
 #define IWL_ACTIVE_QUIET_TIME 10
-#define LONG_OUT_TIME_PERIOD 600
-#define SHORT_OUT_TIME_PERIOD 200
-#define SUSPEND_TIME_PERIOD 100
+
+struct iwl_mvm_scan_params {
+	u32 max_out_time;
+	u32 suspend_time;
+};
 
 static inline __le16 iwl_mvm_scan_rx_chain(struct iwl_mvm *mvm)
 {
@@ -90,24 +92,6 @@ static inline __le16 iwl_mvm_scan_rx_chain(struct iwl_mvm *mvm)
 	return cpu_to_le16(rx_chain);
 }
 
-static inline __le32 iwl_mvm_scan_max_out_time(struct ieee80211_vif *vif,
-					       u32 flags, bool is_assoc)
-{
-	if (!is_assoc)
-		return 0;
-	if (flags & NL80211_SCAN_FLAG_LOW_PRIORITY)
-		return cpu_to_le32(ieee80211_tu_to_usec(SHORT_OUT_TIME_PERIOD));
-	return cpu_to_le32(ieee80211_tu_to_usec(LONG_OUT_TIME_PERIOD));
-}
-
-static inline __le32 iwl_mvm_scan_suspend_time(struct ieee80211_vif *vif,
-					       bool is_assoc)
-{
-	if (!is_assoc)
-		return 0;
-	return cpu_to_le32(ieee80211_tu_to_usec(SUSPEND_TIME_PERIOD));
-}
-
 static inline __le32
 iwl_mvm_scan_rxon_flags(struct cfg80211_scan_request *req)
 {
@@ -267,13 +251,30 @@ static u16 iwl_mvm_fill_probe_req(struct ieee80211_mgmt *frame, const u8 *ta,
 	return (u16)len;
 }
 
-static void iwl_mvm_vif_assoc_iterator(void *data, u8 *mac,
-				       struct ieee80211_vif *vif)
+static void iwl_mvm_scan_condition_iterator(void *data, u8 *mac,
+					    struct ieee80211_vif *vif)
 {
-	bool *is_assoc = data;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	bool *global_bound = data;
 
-	if (vif->bss_conf.assoc)
-		*is_assoc = true;
+	if (mvmvif->phy_ctxt && mvmvif->phy_ctxt->id < MAX_PHYS)
+		*global_bound = true;
+}
+
+static void iwl_mvm_scan_calc_params(struct iwl_mvm *mvm,
+				     struct iwl_mvm_scan_params *params)
+{
+	bool global_bound = false;
+
+	ieee80211_iterate_active_interfaces_atomic(mvm->hw,
+					    IEEE80211_IFACE_ITER_NORMAL,
+					    iwl_mvm_scan_condition_iterator,
+					    &global_bound);
+	if (!global_bound)
+		return;
+
+	params->suspend_time = ieee80211_tu_to_usec(100);
+	params->max_out_time = ieee80211_tu_to_usec(600);
 }
 
 int iwl_mvm_scan_request(struct iwl_mvm *mvm,
@@ -288,13 +289,13 @@ int iwl_mvm_scan_request(struct iwl_mvm *mvm,
 		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
 	};
 	struct iwl_scan_cmd *cmd = mvm->scan_cmd;
-	bool is_assoc = false;
 	int ret;
 	u32 status;
 	int ssid_len = 0;
 	u8 *ssid = NULL;
 	bool basic_ssid = !(mvm->fw->ucode_capa.flags &
 			   IWL_UCODE_TLV_FLAGS_NO_BASIC_SSID);
+	struct iwl_mvm_scan_params params = {};
 
 	lockdep_assert_held(&mvm->mutex);
 	BUG_ON(mvm->scan_cmd == NULL);
@@ -304,17 +305,16 @@ int iwl_mvm_scan_request(struct iwl_mvm *mvm,
 	memset(cmd, 0, sizeof(struct iwl_scan_cmd) +
 	       mvm->fw->ucode_capa.max_probe_length +
 	       (MAX_NUM_SCAN_CHANNELS * sizeof(struct iwl_scan_channel)));
-	ieee80211_iterate_active_interfaces_atomic(mvm->hw,
-					    IEEE80211_IFACE_ITER_NORMAL,
-					    iwl_mvm_vif_assoc_iterator,
-					    &is_assoc);
+
 	cmd->channel_count = (u8)req->n_channels;
 	cmd->quiet_time = cpu_to_le16(IWL_ACTIVE_QUIET_TIME);
 	cmd->quiet_plcp_th = cpu_to_le16(IWL_PLCP_QUIET_THRESH);
 	cmd->rxchain_sel_flags = iwl_mvm_scan_rx_chain(mvm);
-	cmd->max_out_time = iwl_mvm_scan_max_out_time(vif, req->flags,
-						      is_assoc);
-	cmd->suspend_time = iwl_mvm_scan_suspend_time(vif, is_assoc);
+
+	iwl_mvm_scan_calc_params(mvm, &params);
+	cmd->max_out_time = cpu_to_le32(params.max_out_time);
+	cmd->suspend_time = cpu_to_le32(params.suspend_time);
+
 	cmd->rxon_flags = iwl_mvm_scan_rxon_flags(req);
 	cmd->filter_flags = cpu_to_le32(MAC_FILTER_ACCEPT_GRP |
 					MAC_FILTER_IN_BEACON);
@@ -556,12 +556,8 @@ static void iwl_build_scan_cmd(struct iwl_mvm *mvm,
 			       struct cfg80211_sched_scan_request *req,
 			       struct iwl_scan_offload_cmd *scan)
 {
-	bool is_assoc = false;
+	struct iwl_mvm_scan_params params = {};
 
-	ieee80211_iterate_active_interfaces_atomic(mvm->hw,
-					    IEEE80211_IFACE_ITER_NORMAL,
-					    iwl_mvm_vif_assoc_iterator,
-					    &is_assoc);
 	scan->channel_count =
 		mvm->nvm_data->bands[IEEE80211_BAND_2GHZ].n_channels +
 		mvm->nvm_data->bands[IEEE80211_BAND_5GHZ].n_channels;
@@ -569,9 +565,11 @@ static void iwl_build_scan_cmd(struct iwl_mvm *mvm,
 	scan->quiet_plcp_th = cpu_to_le16(IWL_PLCP_QUIET_THRESH);
 	scan->good_CRC_th = IWL_GOOD_CRC_TH_DEFAULT;
 	scan->rx_chain = iwl_mvm_scan_rx_chain(mvm);
-	scan->max_out_time = iwl_mvm_scan_max_out_time(vif, req->flags,
-						       is_assoc);
-	scan->suspend_time = iwl_mvm_scan_suspend_time(vif, is_assoc);
+
+	iwl_mvm_scan_calc_params(mvm, &params);
+	scan->max_out_time = cpu_to_le32(params.max_out_time);
+	scan->suspend_time = cpu_to_le32(params.suspend_time);
+
 	scan->filter_flags |= cpu_to_le32(MAC_FILTER_ACCEPT_GRP |
 					  MAC_FILTER_IN_BEACON);
 	scan->scan_type = cpu_to_le32(SCAN_TYPE_BACKGROUND);
-- 
1.8.3.2

