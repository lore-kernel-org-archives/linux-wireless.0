Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33448 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753651AbcGFKon (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:44:43 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Gregory Greenman <gregory.greenman@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:14 +0300
Message-Id: <1467801651-1816-19-git-send-email-luca@coelho.fi> (sfid-20160706_124447_090500_74E46CB5)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 19/56] iwlwifi: mvm: rs: add rate scaling support for 160MHz channels
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

Expand TLC to support 160MHz channels. Full support for A-MSDU
case will be added separately.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c | 81 +++++++++++++++++++++--------
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h |  1 +
 2 files changed, 60 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 7aecf46..227c5ed 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -211,6 +211,9 @@ static bool rs_sgi_allow(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	if (is_ht80(rate) && (vht_cap->cap &
 			     IEEE80211_VHT_CAP_SHORT_GI_80))
 		return true;
+	if (is_ht160(rate) && (vht_cap->cap &
+			     IEEE80211_VHT_CAP_SHORT_GI_160))
+		return true;
 
 	return false;
 }
@@ -445,6 +448,13 @@ static const u16 expected_tpt_siso_80MHz[4][IWL_RATE_COUNT] = {
 	{0, 0, 0, 0, 241, 0, 475, 701, 921, 1343, 1741, 1931, 2117, 2468, 2691},
 };
 
+static const u16 expected_tpt_siso_160MHz[4][IWL_RATE_COUNT] = {
+	{0, 0, 0, 0, 191, 0, 244, 288,  298,  308,  313,  318,  323,  328,  330},
+	{0, 0, 0, 0, 200, 0, 251, 293,  302,  312,  317,  322,  327,  332,  334},
+	{0, 0, 0, 0, 439, 0, 875, 1307, 1736, 2584, 3419, 3831, 4240, 5049, 5581},
+	{0, 0, 0, 0, 488, 0, 972, 1451, 1925, 2864, 3785, 4240, 4691, 5581, 6165},
+};
+
 static const u16 expected_tpt_mimo2_20MHz[4][IWL_RATE_COUNT] = {
 	{0, 0, 0, 0,  74, 0, 123, 155, 179, 213, 235, 243, 250,  261, 0},
 	{0, 0, 0, 0,  81, 0, 131, 164, 187, 221, 242, 250, 256,  267, 0},
@@ -466,6 +476,13 @@ static const u16 expected_tpt_mimo2_80MHz[4][IWL_RATE_COUNT] = {
 	{0, 0, 0, 0, 474, 0, 920, 1338, 1732, 2464, 3116, 3418, 3705, 4225, 4545},
 };
 
+static const u16 expected_tpt_mimo2_160MHz[4][IWL_RATE_COUNT] = {
+	{0, 0, 0, 0, 240, 0, 278,  308,  313,  319,  322,  324,  328,  330,   334},
+	{0, 0, 0, 0, 247, 0, 282,  310,  315,  320,  323,  325,  329,  332,   338},
+	{0, 0, 0, 0, 875, 0, 1735, 2582, 3414, 5043, 6619, 7389, 8147, 9629,  10592},
+	{0, 0, 0, 0, 971, 0, 1925, 2861, 3779, 5574, 7304, 8147, 8976, 10592, 11640},
+};
+
 /* mbps, mcs */
 static const struct iwl_rate_mcs_info iwl_rate_mcs[IWL_RATE_COUNT] = {
 	{  "1", "BPSK DSSS"},
@@ -901,7 +918,6 @@ static int rs_rate_from_ucode_rate(const u32 ucode_rate,
 		}
 	}
 
-	WARN_ON_ONCE(rate->bw == RATE_MCS_CHAN_WIDTH_160);
 	WARN_ON_ONCE(rate->bw == RATE_MCS_CHAN_WIDTH_80 &&
 		     !is_vht(rate));
 
@@ -1495,6 +1511,9 @@ static const u16 *rs_get_expected_tpt_table(struct iwl_lq_sta *lq_sta,
 		case RATE_MCS_CHAN_WIDTH_80:
 			ht_tbl_pointer = expected_tpt_siso_80MHz;
 			break;
+		case RATE_MCS_CHAN_WIDTH_160:
+			ht_tbl_pointer = expected_tpt_siso_160MHz;
+			break;
 		default:
 			WARN_ON_ONCE(1);
 		}
@@ -1509,6 +1528,9 @@ static const u16 *rs_get_expected_tpt_table(struct iwl_lq_sta *lq_sta,
 		case RATE_MCS_CHAN_WIDTH_80:
 			ht_tbl_pointer = expected_tpt_mimo2_80MHz;
 			break;
+		case RATE_MCS_CHAN_WIDTH_160:
+			ht_tbl_pointer = expected_tpt_mimo2_160MHz;
+			break;
 		default:
 			WARN_ON_ONCE(1);
 		}
@@ -1583,12 +1605,17 @@ static s32 rs_get_best_rate(struct iwl_mvm *mvm,
 
 static u32 rs_bw_from_sta_bw(struct ieee80211_sta *sta)
 {
-	if (sta->bandwidth >= IEEE80211_STA_RX_BW_80)
+	switch (sta->bandwidth) {
+	case IEEE80211_STA_RX_BW_160:
+		return RATE_MCS_CHAN_WIDTH_160;
+	case IEEE80211_STA_RX_BW_80:
 		return RATE_MCS_CHAN_WIDTH_80;
-	else if (sta->bandwidth >= IEEE80211_STA_RX_BW_40)
+	case IEEE80211_STA_RX_BW_40:
 		return RATE_MCS_CHAN_WIDTH_40;
-
-	return RATE_MCS_CHAN_WIDTH_20;
+	case IEEE80211_STA_RX_BW_20:
+	default:
+		return RATE_MCS_CHAN_WIDTH_20;
+	}
 }
 
 /*
@@ -2566,6 +2593,9 @@ static const struct rs_init_rate_info rs_optimal_rates_ht[] = {
 	{ S8_MIN, IWL_RATE_MCS_0_INDEX},
 };
 
+/* MCS index 9 is not valid for 20MHz VHT channel width,
+ * but is ok for 40, 80 and 160MHz channels.
+ */
 static const struct rs_init_rate_info rs_optimal_rates_vht_20mhz[] = {
 	{ -60, IWL_RATE_MCS_8_INDEX },
 	{ -64, IWL_RATE_MCS_7_INDEX },
@@ -2578,7 +2608,7 @@ static const struct rs_init_rate_info rs_optimal_rates_vht_20mhz[] = {
 	{ S8_MIN, IWL_RATE_MCS_0_INDEX},
 };
 
-static const struct rs_init_rate_info rs_optimal_rates_vht_40_80mhz[] = {
+static const struct rs_init_rate_info rs_optimal_rates_vht[] = {
 	{ -60, IWL_RATE_MCS_9_INDEX },
 	{ -64, IWL_RATE_MCS_8_INDEX },
 	{ -68, IWL_RATE_MCS_7_INDEX },
@@ -2641,9 +2671,9 @@ static void rs_init_optimal_rate(struct iwl_mvm *mvm,
 			lq_sta->optimal_nentries =
 				ARRAY_SIZE(rs_optimal_rates_vht_20mhz);
 		} else {
-			lq_sta->optimal_rates = rs_optimal_rates_vht_40_80mhz;
+			lq_sta->optimal_rates = rs_optimal_rates_vht;
 			lq_sta->optimal_nentries =
-				ARRAY_SIZE(rs_optimal_rates_vht_40_80mhz);
+				ARRAY_SIZE(rs_optimal_rates_vht);
 		}
 	} else if (is_ht(rate)) {
 		lq_sta->optimal_rates = rs_optimal_rates_ht;
@@ -2735,23 +2765,25 @@ static void rs_get_initial_rate(struct iwl_mvm *mvm,
 	 */
 	if (sta->vht_cap.vht_supported &&
 	    best_rssi > IWL_RS_LOW_RSSI_THRESHOLD) {
-		if (sta->bandwidth >= IEEE80211_STA_RX_BW_40) {
-			initial_rates = rs_optimal_rates_vht_40_80mhz;
-			nentries = ARRAY_SIZE(rs_optimal_rates_vht_40_80mhz);
-			if (sta->bandwidth >= IEEE80211_STA_RX_BW_80)
-				rate->bw = RATE_MCS_CHAN_WIDTH_80;
-			else
-				rate->bw = RATE_MCS_CHAN_WIDTH_40;
-		} else if (sta->bandwidth == IEEE80211_STA_RX_BW_20) {
+		switch (sta->bandwidth) {
+		case IEEE80211_STA_RX_BW_160:
+		case IEEE80211_STA_RX_BW_80:
+		case IEEE80211_STA_RX_BW_40:
+			initial_rates = rs_optimal_rates_vht;
+			nentries = ARRAY_SIZE(rs_optimal_rates_vht);
+			break;
+		case IEEE80211_STA_RX_BW_20:
 			initial_rates = rs_optimal_rates_vht_20mhz;
 			nentries = ARRAY_SIZE(rs_optimal_rates_vht_20mhz);
-			rate->bw = RATE_MCS_CHAN_WIDTH_20;
-		} else {
+			break;
+		default:
 			IWL_ERR(mvm, "Invalid BW %d\n", sta->bandwidth);
 			goto out;
 		}
+
 		active_rate = lq_sta->active_siso_rate;
 		rate->type = LQ_VHT_SISO;
+		rate->bw = rs_bw_from_sta_bw(sta);
 	} else if (sta->ht_cap.ht_supported &&
 		   best_rssi > IWL_RS_LOW_RSSI_THRESHOLD) {
 		initial_rates = rs_optimal_rates_ht;
@@ -3058,6 +3090,9 @@ void iwl_mvm_update_frame_stats(struct iwl_mvm *mvm, u32 rate, bool agg)
 	case RATE_MCS_CHAN_WIDTH_80:
 		mvm->drv_rx_stats.bw_80_frames++;
 		break;
+	case RATE_MCS_CHAN_WIDTH_160:
+		mvm->drv_rx_stats.bw_160_frames++;
+		break;
 	default:
 		WARN_ONCE(1, "bad BW. rate 0x%x", rate);
 	}
@@ -3706,7 +3741,8 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 		desc += sprintf(buff + desc, " %s",
 				(is_ht20(rate)) ? "20MHz" :
 				(is_ht40(rate)) ? "40MHz" :
-				(is_ht80(rate)) ? "80Mhz" : "BAD BW");
+				(is_ht80(rate)) ? "80MHz" :
+				(is_ht160(rate)) ? "160MHz" : "BAD BW");
 		desc += sprintf(buff + desc, " %s %s %s %s\n",
 				(rate->sgi) ? "SGI" : "NGI",
 				(rate->ldpc) ? "LDPC" : "BCC",
@@ -3788,9 +3824,10 @@ static ssize_t rs_sta_dbgfs_stats_table_read(struct file *file,
 				lq_sta->active_tbl == i ? "*" : "x",
 				rate->type,
 				rate->sgi,
-				is_ht20(rate) ? "20Mhz" :
-				is_ht40(rate) ? "40Mhz" :
-				is_ht80(rate) ? "80Mhz" : "ERR",
+				is_ht20(rate) ? "20MHz" :
+				is_ht40(rate) ? "40MHz" :
+				is_ht80(rate) ? "80MHz" :
+				is_ht160(rate) ? "160MHz" : "ERR",
 				rate->index);
 		for (j = 0; j < IWL_RATE_COUNT; j++) {
 			desc += sprintf(buff+desc,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.h b/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
index d4a7fe2..ee207f2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.h
@@ -205,6 +205,7 @@ struct rs_rate {
 #define is_ht20(rate)         ((rate)->bw == RATE_MCS_CHAN_WIDTH_20)
 #define is_ht40(rate)         ((rate)->bw == RATE_MCS_CHAN_WIDTH_40)
 #define is_ht80(rate)         ((rate)->bw == RATE_MCS_CHAN_WIDTH_80)
+#define is_ht160(rate)        ((rate)->bw == RATE_MCS_CHAN_WIDTH_160)
 
 #define IWL_MAX_MCS_DISPLAY_SIZE	12
 
-- 
2.8.1

