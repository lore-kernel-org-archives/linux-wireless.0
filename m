Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:44710 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbaFXTwd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 15:52:33 -0400
Received: by mail-wg0-f45.google.com with SMTP id l18so888296wgh.28
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 12:52:31 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/27] iwlwifi: mvm: add back support for low-priority scan
Date: Tue, 24 Jun 2014 22:51:57 +0300
Message-Id: <1403639541-4621-3-git-send-email-egrumbach@gmail.com> (sfid-20140624_215243_010493_E4CE2F1E)
In-Reply-To: <53A9D6CF.9040100@gmail.com>
References: <53A9D6CF.9040100@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The low-priority scan feature can be useful, e.g. for OBSS
scans (if those are required by the AP); add back support
for it, restoring the maximum out time to the value it was
for low-priority scan before that was removed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 1 +
 drivers/net/wireless/iwlwifi/mvm/scan.c     | 9 ++++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 7215f59..41c0aac 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -374,6 +374,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	hw->wiphy->max_sched_scan_ie_len = SCAN_OFFLOAD_PROBE_REQ_SIZE - 24 - 2;
 
 	hw->wiphy->features |= NL80211_FEATURE_P2P_GO_CTWIN |
+			       NL80211_FEATURE_LOW_PRIORITY_SCAN |
 			       NL80211_FEATURE_P2P_GO_OPPPS;
 
 	mvm->rts_threshold = IEEE80211_MAX_RTS_THRESHOLD;
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index df8f3eb..896c21d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -267,7 +267,7 @@ static void iwl_mvm_scan_condition_iterator(void *data, u8 *mac,
 
 static void iwl_mvm_scan_calc_params(struct iwl_mvm *mvm,
 				     struct ieee80211_vif *vif,
-				     int n_ssids,
+				     int n_ssids, u32 flags,
 				     struct iwl_mvm_scan_params *params)
 {
 	bool global_bound = false;
@@ -289,6 +289,9 @@ static void iwl_mvm_scan_calc_params(struct iwl_mvm *mvm,
 		params->max_out_time = 250;
 	}
 
+	if (flags & NL80211_SCAN_FLAG_LOW_PRIORITY)
+		params->max_out_time = 200;
+
 not_bound:
 
 	for (band = IEEE80211_BAND_2GHZ; band < IEEE80211_NUM_BANDS; band++) {
@@ -332,7 +335,7 @@ int iwl_mvm_scan_request(struct iwl_mvm *mvm,
 	cmd->quiet_plcp_th = cpu_to_le16(IWL_PLCP_QUIET_THRESH);
 	cmd->rxchain_sel_flags = iwl_mvm_scan_rx_chain(mvm);
 
-	iwl_mvm_scan_calc_params(mvm, vif, req->n_ssids, &params);
+	iwl_mvm_scan_calc_params(mvm, vif, req->n_ssids, req->flags, &params);
 	cmd->max_out_time = cpu_to_le32(params.max_out_time);
 	cmd->suspend_time = cpu_to_le32(params.suspend_time);
 	if (params.passive_fragmented)
@@ -758,7 +761,7 @@ int iwl_mvm_config_sched_scan(struct iwl_mvm *mvm,
 	if (!scan_cfg)
 		return -ENOMEM;
 
-	iwl_mvm_scan_calc_params(mvm, vif, req->n_ssids, &params);
+	iwl_mvm_scan_calc_params(mvm, vif, req->n_ssids, 0, &params);
 	iwl_build_scan_cmd(mvm, vif, req, &scan_cfg->scan_cmd, &params);
 	scan_cfg->scan_cmd.len = cpu_to_le16(cmd_len);
 
-- 
1.8.3.2

