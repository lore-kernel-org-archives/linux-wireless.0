Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:57212 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752205AbbJEPBx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 11:01:53 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 17:36:55 +0300
Message-Id: <1444055820-27506-24-git-send-email-luca@coelho.fi> (sfid-20151005_170157_558084_1BF3B769)
In-Reply-To: <1444050759.27220.15.camel@coelho.fi>
References: <1444050759.27220.15.camel@coelho.fi>
Subject: [PATCH 24/29] iwlwifi: mvm: rs: dynamically switch between 80MHz and 20MHz in some scenarios
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

This is a tweak which has been shown to improve performance when
moving away from the AP while working in 80Mhz.
When RS decides to go down to 80MHz SISO MCS0 instead switch to 20MHz MCS4.
Go back to 80MHz MCS1 if RS can sustain 20MHz MCS5.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/constants.h |  1 +
 drivers/net/wireless/iwlwifi/mvm/rs.c        | 47 ++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/constants.h b/drivers/net/wireless/iwlwifi/mvm/constants.h
index b8ee312..a3ca6db 100644
--- a/drivers/net/wireless/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/iwlwifi/mvm/constants.h
@@ -102,6 +102,7 @@
 #define IWL_MVM_QUOTA_THRESHOLD			4
 #define IWL_MVM_RS_RSSI_BASED_INIT_RATE         0
 #define IWL_MVM_RS_DISABLE_P2P_MIMO		0
+#define IWL_MVM_RS_80_20_FAR_RANGE_TWEAK	1
 #define IWL_MVM_TOF_IS_RESPONDER		0
 #define IWL_MVM_RS_NUM_TRY_BEFORE_ANT_TOGGLE    1
 #define IWL_MVM_RS_HT_VHT_RETRIES_PER_RATE      2
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 435e1e4..34d98b2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -1664,6 +1664,51 @@ static void rs_update_rate_tbl(struct iwl_mvm *mvm,
 	iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq, false);
 }
 
+static bool rs_tweak_rate_tbl(struct iwl_mvm *mvm,
+			      struct ieee80211_sta *sta,
+			      struct iwl_lq_sta *lq_sta,
+			      struct iwl_scale_tbl_info *tbl,
+			      enum rs_action scale_action)
+{
+	if (sta->bandwidth != IEEE80211_STA_RX_BW_80)
+		return false;
+
+	if (!is_vht_siso(&tbl->rate))
+		return false;
+
+	if ((tbl->rate.bw == RATE_MCS_CHAN_WIDTH_80) &&
+	    (tbl->rate.index == IWL_RATE_MCS_0_INDEX) &&
+	    (scale_action == RS_ACTION_DOWNSCALE)) {
+		tbl->rate.bw = RATE_MCS_CHAN_WIDTH_20;
+		tbl->rate.index = IWL_RATE_MCS_4_INDEX;
+		IWL_DEBUG_RATE(mvm, "Switch 80Mhz SISO MCS0 -> 20Mhz MCS4\n");
+		goto tweaked;
+	}
+
+	/* Go back to 80Mhz MCS1 only if we've established that 20Mhz MCS5 is
+	 * sustainable, i.e. we're past the test window. We can't go back
+	 * if MCS5 is just tested as this will happen always after switching
+	 * to 20Mhz MCS4 because the rate stats are cleared.
+	 */
+	if ((tbl->rate.bw == RATE_MCS_CHAN_WIDTH_20) &&
+	    (((tbl->rate.index == IWL_RATE_MCS_5_INDEX) &&
+	     (scale_action == RS_ACTION_STAY)) ||
+	     ((tbl->rate.index > IWL_RATE_MCS_5_INDEX) &&
+	      (scale_action == RS_ACTION_UPSCALE)))) {
+		tbl->rate.bw = RATE_MCS_CHAN_WIDTH_80;
+		tbl->rate.index = IWL_RATE_MCS_1_INDEX;
+		IWL_DEBUG_RATE(mvm, "Switch 20Mhz SISO MCS5 -> 80Mhz MCS1\n");
+		goto tweaked;
+	}
+
+	return false;
+
+tweaked:
+	rs_set_expected_tpt_table(lq_sta, tbl);
+	rs_rate_scale_clear_tbl_windows(mvm, tbl);
+	return true;
+}
+
 static enum rs_column rs_get_next_column(struct iwl_mvm *mvm,
 					 struct iwl_lq_sta *lq_sta,
 					 struct ieee80211_sta *sta,
@@ -2347,6 +2392,8 @@ lq_update:
 	/* Replace uCode's rate table for the destination station. */
 	if (update_lq) {
 		tbl->rate.index = index;
+		if (IWL_MVM_RS_80_20_FAR_RANGE_TWEAK)
+			rs_tweak_rate_tbl(mvm, sta, lq_sta, tbl, scale_action);
 		rs_update_rate_tbl(mvm, sta, lq_sta, tbl);
 	}
 
-- 
2.5.3

