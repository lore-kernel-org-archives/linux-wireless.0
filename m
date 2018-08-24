Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:43880 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726969AbeHXOEb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 10:04:31 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Naftali Goldstein <naftali.goldstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 24 Aug 2018 13:30:10 +0300
Message-Id: <20180824103018.15011-9-luca@coelho.fi> (sfid-20180824_123037_056817_2E1E9038)
In-Reply-To: <20180824103018.15011-1-luca@coelho.fi>
References: <20180824103018.15011-1-luca@coelho.fi>
Subject: [PATCH 08/16] iwlwifi: mvm: always init rs_fw with 20MHz bandwidth rates
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Naftali Goldstein <naftali.goldstein@intel.com>

As with the non-offloaded rs case, during assoc on the ap side the phy
context is set to 20MHz until authorization of a client that supports
wider channel-widths. Support this by sending the initial
tlc_config_cmd with max supported channel width of 20MHz until
authorization succeeds.

Fixes: 6b7a5aea71b3 ("iwlwifi: mvm: always init rs with 20mhz bandwidth rates")
Signed-off-by: Naftali Goldstein <naftali.goldstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c | 5 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c    | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h    | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
index 8169d1450b3b..1a7a158890cb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
@@ -311,7 +311,7 @@ void iwl_mvm_tlc_update_notif(struct iwl_mvm *mvm,
 }
 
 void rs_fw_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
-		     enum nl80211_band band)
+		     enum nl80211_band band, bool update)
 {
 	struct ieee80211_hw *hw = mvm->hw;
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
@@ -320,7 +320,8 @@ void rs_fw_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	struct ieee80211_supported_band *sband;
 	struct iwl_tlc_config_cmd cfg_cmd = {
 		.sta_id = mvmsta->sta_id,
-		.max_ch_width = rs_fw_bw_from_sta_bw(sta),
+		.max_ch_width = update ?
+			rs_fw_bw_from_sta_bw(sta) : RATE_MCS_CHAN_WIDTH_20,
 		.flags = cpu_to_le16(rs_fw_set_config_flags(mvm, sta)),
 		.chains = rs_fw_set_active_chains(iwl_mvm_get_valid_tx_ant(mvm)),
 		.max_mpdu_len = cpu_to_le16(sta->max_amsdu_len),
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index d3e389a99a8a..c3282f1d77ba 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -4099,7 +4099,7 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			  enum nl80211_band band, bool update)
 {
 	if (iwl_mvm_has_tlc_offload(mvm))
-		rs_fw_rate_init(mvm, sta, band);
+		rs_fw_rate_init(mvm, sta, band, update);
 	else
 		rs_drv_rate_init(mvm, sta, band, update);
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.h b/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
index 8e7f993e2911..d0f47899f284 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
@@ -461,7 +461,7 @@ void rs_remove_sta_debugfs(void *mvm, void *mvm_sta);
 
 void iwl_mvm_rs_add_sta(struct iwl_mvm *mvm, struct iwl_mvm_sta *mvmsta);
 void rs_fw_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
-		     enum nl80211_band band);
+		     enum nl80211_band band, bool update);
 int rs_fw_tx_protection(struct iwl_mvm *mvm, struct iwl_mvm_sta *mvmsta,
 			bool enable);
 void iwl_mvm_tlc_update_notif(struct iwl_mvm *mvm,
-- 
2.18.0
