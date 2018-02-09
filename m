Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:58250 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751091AbeBINMq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Feb 2018 08:12:46 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Naftali Goldstein <naftali.goldstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  9 Feb 2018 15:12:34 +0200
Message-Id: <20180209131234.8504-6-luca@coelho.fi> (sfid-20180209_141253_679964_39F2E03B)
In-Reply-To: <20180209131234.8504-1-luca@coelho.fi>
References: <20180209131234.8504-1-luca@coelho.fi>
Subject: [PATCH 5/5] iwlwifi: mvm: always init rs with 20mhz bandwidth rates
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Naftali Goldstein <naftali.goldstein@intel.com>

In AP mode, when a new station associates, rs is initialized immediately
upon association completion, before the phy context is updated with the
association parameters, so the sta bandwidth might be wider than the phy
context allows.
To avoid this issue, always initialize rs with 20mhz bandwidth rate, and
after authorization, when the phy context is already up-to-date, re-init
rs with the correct bw.

Signed-off-by: Naftali Goldstein <naftali.goldstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  4 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c       | 28 ++++++++++++++++-------
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 8aed40a8bc38..08de822c3ef0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2682,6 +2682,10 @@ static int iwl_mvm_mac_sta_state(struct ieee80211_hw *hw,
 
 		/* enable beacon filtering */
 		WARN_ON(iwl_mvm_enable_beacon_filter(mvm, vif, 0));
+
+		iwl_mvm_rs_rate_init(mvm, sta, mvmvif->phy_ctxt->channel->band,
+				     false);
+
 		ret = 0;
 	} else if (old_state == IEEE80211_STA_AUTHORIZED &&
 		   new_state == IEEE80211_STA_ASSOC) {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 60abb0084ee5..47f4c7a1d80d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -2684,7 +2684,8 @@ static void rs_get_initial_rate(struct iwl_mvm *mvm,
 				struct ieee80211_sta *sta,
 				struct iwl_lq_sta *lq_sta,
 				enum nl80211_band band,
-				struct rs_rate *rate)
+				struct rs_rate *rate,
+				bool init)
 {
 	int i, nentries;
 	unsigned long active_rate;
@@ -2738,14 +2739,25 @@ static void rs_get_initial_rate(struct iwl_mvm *mvm,
 	 */
 	if (sta->vht_cap.vht_supported &&
 	    best_rssi > IWL_RS_LOW_RSSI_THRESHOLD) {
-		switch (sta->bandwidth) {
-		case IEEE80211_STA_RX_BW_160:
-		case IEEE80211_STA_RX_BW_80:
-		case IEEE80211_STA_RX_BW_40:
+		/*
+		 * In AP mode, when a new station associates, rs is initialized
+		 * immediately upon association completion, before the phy
+		 * context is updated with the association parameters, so the
+		 * sta bandwidth might be wider than the phy context allows.
+		 * To avoid this issue, always initialize rs with 20mhz
+		 * bandwidth rate, and after authorization, when the phy context
+		 * is already up-to-date, re-init rs with the correct bw.
+		 */
+		u32 bw = init ? RATE_MCS_CHAN_WIDTH_20 : rs_bw_from_sta_bw(sta);
+
+		switch (bw) {
+		case RATE_MCS_CHAN_WIDTH_40:
+		case RATE_MCS_CHAN_WIDTH_80:
+		case RATE_MCS_CHAN_WIDTH_160:
 			initial_rates = rs_optimal_rates_vht;
 			nentries = ARRAY_SIZE(rs_optimal_rates_vht);
 			break;
-		case IEEE80211_STA_RX_BW_20:
+		case RATE_MCS_CHAN_WIDTH_20:
 			initial_rates = rs_optimal_rates_vht_20mhz;
 			nentries = ARRAY_SIZE(rs_optimal_rates_vht_20mhz);
 			break;
@@ -2756,7 +2768,7 @@ static void rs_get_initial_rate(struct iwl_mvm *mvm,
 
 		active_rate = lq_sta->active_siso_rate;
 		rate->type = LQ_VHT_SISO;
-		rate->bw = rs_bw_from_sta_bw(sta);
+		rate->bw = bw;
 	} else if (sta->ht_cap.ht_supported &&
 		   best_rssi > IWL_RS_LOW_RSSI_THRESHOLD) {
 		initial_rates = rs_optimal_rates_ht;
@@ -2839,7 +2851,7 @@ static void rs_initialize_lq(struct iwl_mvm *mvm,
 	tbl = &(lq_sta->lq_info[active_tbl]);
 	rate = &tbl->rate;
 
-	rs_get_initial_rate(mvm, sta, lq_sta, band, rate);
+	rs_get_initial_rate(mvm, sta, lq_sta, band, rate, init);
 	rs_init_optimal_rate(mvm, sta, lq_sta);
 
 	WARN_ONCE(rate->ant != ANT_A && rate->ant != ANT_B,
-- 
2.15.1
