Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:2928 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbbLUUuz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:50:55 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Gregory Greenman <gregory.greenman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/45] iwlwifi: mvm: add an option to start rs from HT/VHT rates
Date: Mon, 21 Dec 2015 22:50:03 +0200
Message-Id: <1450731046-2796-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_215104_021452_73CB214B)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

Extend the configurable option of setting initial rate to RSSI based.
Make the initial rate to be set to VHT/HT SISO or legacy depending on
the AP capabilities.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c | 67 ++++++++++++++++++++++-------
 1 file changed, 52 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 54789bd..feb775a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -2550,6 +2550,8 @@ static const struct rs_init_rate_info rs_optimal_rates_vht_40_80mhz[] = {
 	{ S8_MIN, IWL_RATE_MCS_0_INDEX },
 };
 
+#define IWL_RS_LOW_RSSI_THRESHOLD (-76) /* dBm */
+
 /* Init the optimal rate based on STA caps
  * This combined with rssi is used to report the last tx rate
  * to userspace when we haven't transmitted enough frames.
@@ -2635,11 +2637,13 @@ static struct rs_rate *rs_get_optimal_rate(struct iwl_mvm *mvm,
  * of last Rx
  */
 static void rs_get_initial_rate(struct iwl_mvm *mvm,
+				struct ieee80211_sta *sta,
 				struct iwl_lq_sta *lq_sta,
 				enum ieee80211_band band,
 				struct rs_rate *rate)
 {
 	int i, nentries;
+	unsigned long active_rate;
 	s8 best_rssi = S8_MIN;
 	u8 best_ant = ANT_NONE;
 	u8 valid_tx_ant = iwl_mvm_get_valid_tx_ant(mvm);
@@ -2680,19 +2684,55 @@ static void rs_get_initial_rate(struct iwl_mvm *mvm,
 		nentries = ARRAY_SIZE(rs_optimal_rates_24ghz_legacy);
 	}
 
-	if (IWL_MVM_RS_RSSI_BASED_INIT_RATE) {
-		for (i = 0; i < nentries; i++) {
-			int rate_idx = initial_rates[i].rate_idx;
-			if ((best_rssi >= initial_rates[i].rssi) &&
-			    (BIT(rate_idx) & lq_sta->active_legacy_rate)) {
-				rate->index = rate_idx;
-				break;
-			}
+	if (!IWL_MVM_RS_RSSI_BASED_INIT_RATE)
+		goto out;
+
+	/* Start from a higher rate if the corresponding debug capability
+	 * is enabled. The rate is chosen according to AP capabilities.
+	 * In case of VHT/HT when the rssi is low fallback to the case of
+	 * legacy rates.
+	 */
+	if (sta->vht_cap.vht_supported &&
+	    best_rssi > IWL_RS_LOW_RSSI_THRESHOLD) {
+		if (sta->bandwidth >= IEEE80211_STA_RX_BW_40) {
+			initial_rates = rs_optimal_rates_vht_40_80mhz;
+			nentries = ARRAY_SIZE(rs_optimal_rates_vht_40_80mhz);
+			if (sta->bandwidth >= IEEE80211_STA_RX_BW_80)
+				rate->bw = RATE_MCS_CHAN_WIDTH_80;
+			else
+				rate->bw = RATE_MCS_CHAN_WIDTH_40;
+		} else if (sta->bandwidth == IEEE80211_STA_RX_BW_20) {
+			initial_rates = rs_optimal_rates_vht_20mhz;
+			nentries = ARRAY_SIZE(rs_optimal_rates_vht_20mhz);
+			rate->bw = RATE_MCS_CHAN_WIDTH_20;
+		} else {
+			IWL_ERR(mvm, "Invalid BW %d\n", sta->bandwidth);
+			goto out;
 		}
+		active_rate = lq_sta->active_siso_rate;
+		rate->type = LQ_VHT_SISO;
+	} else if (sta->ht_cap.ht_supported &&
+		   best_rssi > IWL_RS_LOW_RSSI_THRESHOLD) {
+		initial_rates = rs_optimal_rates_ht;
+		nentries = ARRAY_SIZE(rs_optimal_rates_ht);
+		active_rate = lq_sta->active_siso_rate;
+		rate->type = LQ_HT_SISO;
+	} else {
+		active_rate = lq_sta->active_legacy_rate;
 	}
 
-	IWL_DEBUG_RATE(mvm, "rate_idx %d ANT %s\n", rate->index,
-		       rs_pretty_ant(rate->ant));
+	for (i = 0; i < nentries; i++) {
+		int rate_idx = initial_rates[i].rate_idx;
+
+		if ((best_rssi >= initial_rates[i].rssi) &&
+		    (BIT(rate_idx) & active_rate)) {
+			rate->index = rate_idx;
+			break;
+		}
+	}
+
+out:
+	rs_dump_rate(mvm, rate, "INITIAL");
 }
 
 /* Save info about RSSI of last Rx */
@@ -2752,14 +2792,11 @@ static void rs_initialize_lq(struct iwl_mvm *mvm,
 	tbl = &(lq_sta->lq_info[active_tbl]);
 	rate = &tbl->rate;
 
-	rs_get_initial_rate(mvm, lq_sta, band, rate);
+	rs_get_initial_rate(mvm, sta, lq_sta, band, rate);
 	rs_init_optimal_rate(mvm, sta, lq_sta);
 
 	WARN_ON_ONCE(rate->ant != ANT_A && rate->ant != ANT_B);
-	if (rate->ant == ANT_A)
-		tbl->column = RS_COLUMN_LEGACY_ANT_A;
-	else
-		tbl->column = RS_COLUMN_LEGACY_ANT_B;
+	tbl->column = rs_get_column_from_rate(rate);
 
 	rs_set_expected_tpt_table(lq_sta, tbl);
 	rs_fill_lq_cmd(mvm, sta, lq_sta, rate);
-- 
2.5.0

