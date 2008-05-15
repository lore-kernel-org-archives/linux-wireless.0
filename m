Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14460 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbYEOF4Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 01:56:24 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 10/26] iwlwifi: remove 4965 from iwl4965_rate_info
Date: Thu, 15 May 2008 13:54:02 +0800
Message-Id: <1210830858-3410-11-git-send-email-yi.zhu@intel.com> (sfid-20080515_075631_535298_37DB397A)
In-Reply-To: <1210830858-3410-10-git-send-email-yi.zhu@intel.com>
References: <1210830858-3410-1-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-2-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-3-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-4-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-5-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-6-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-7-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-8-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-9-git-send-email-yi.zhu@intel.com>
 <1210830858-3410-10-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch removes 4965 from iwl4965_rate_info structure and
associated variables.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c  |   27 ++++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-4965-rs.h  |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   12 ++++++------
 drivers/net/wireless/iwlwifi/iwl-core.c     |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    6 +++---
 5 files changed, 31 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 8e3660e..e2123ab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -481,7 +481,7 @@ static u32 rate_n_flags_from_tbl(struct iwl4965_scale_tbl_info *tbl,
 	u32 rate_n_flags = 0;
 
 	if (is_legacy(tbl->lq_type)) {
-		rate_n_flags = iwl4965_rates[index].plcp;
+		rate_n_flags = iwl_rates[index].plcp;
 		if (index >= IWL_FIRST_CCK_RATE && index <= IWL_LAST_CCK_RATE)
 			rate_n_flags |= RATE_MCS_CCK_MSK;
 
@@ -493,11 +493,11 @@ static u32 rate_n_flags_from_tbl(struct iwl4965_scale_tbl_info *tbl,
 		rate_n_flags = RATE_MCS_HT_MSK;
 
 		if (is_siso(tbl->lq_type))
-			rate_n_flags |=	iwl4965_rates[index].plcp_siso;
+			rate_n_flags |=	iwl_rates[index].plcp_siso;
 		else if (is_mimo2(tbl->lq_type))
-			rate_n_flags |=	iwl4965_rates[index].plcp_mimo2;
+			rate_n_flags |=	iwl_rates[index].plcp_mimo2;
 		else
-			rate_n_flags |=	iwl4965_rates[index].plcp_mimo3;
+			rate_n_flags |=	iwl_rates[index].plcp_mimo3;
 	} else {
 		IWL_ERROR("Invalid tbl->lq_type %d\n", tbl->lq_type);
 	}
@@ -697,7 +697,7 @@ static u16 rs_get_adjacent_rate(struct iwl_priv *priv, u8 index, u16 rate_mask,
 
 	low = index;
 	while (low != IWL_RATE_INVALID) {
-		low = iwl4965_rates[low].prev_rs;
+		low = iwl_rates[low].prev_rs;
 		if (low == IWL_RATE_INVALID)
 			break;
 		if (rate_mask & (1 << low))
@@ -707,7 +707,7 @@ static u16 rs_get_adjacent_rate(struct iwl_priv *priv, u8 index, u16 rate_mask,
 
 	high = index;
 	while (high != IWL_RATE_INVALID) {
-		high = iwl4965_rates[high].next_rs;
+		high = iwl_rates[high].next_rs;
 		if (high == IWL_RATE_INVALID)
 			break;
 		if (rate_mask & (1 << high))
@@ -2088,7 +2088,7 @@ static void rs_initialize_lq(struct iwl_priv *priv,
 		i = 0;
 
 	/* FIXME:RS: This is also wrong in 4965 */
-	rate = iwl4965_rates[i].plcp;
+	rate = iwl_rates[i].plcp;
 	rate |= RATE_MCS_ANT_B_MSK;
 	rate &= ~RATE_MCS_ANT_A_MSK;
 
@@ -2691,7 +2691,7 @@ int iwl4965_fill_rs_info(struct ieee80211_hw *hw, char *buf, u8 sta_id)
 		int active = lq_sta->active_tbl;
 
 		cnt +=
-		    sprintf(&buf[cnt], " %2dMbs: ", iwl4965_rates[i].ieee / 2);
+		    sprintf(&buf[cnt], " %2dMbs: ", iwl_rates[i].ieee / 2);
 
 		mask = (1ULL << (IWL_RATE_MAX_WINDOW - 1));
 		for (j = 0; j < IWL_RATE_MAX_WINDOW; j++, mask >>= 1)
@@ -2702,7 +2702,7 @@ int iwl4965_fill_rs_info(struct ieee80211_hw *hw, char *buf, u8 sta_id)
 		samples += lq_sta->lq_info[active].win[i].counter;
 		good += lq_sta->lq_info[active].win[i].success_counter;
 		success += lq_sta->lq_info[active].win[i].success_counter *
-			   iwl4965_rates[i].ieee;
+			   iwl_rates[i].ieee;
 
 		if (lq_sta->lq_info[active].win[i].stamp) {
 			int delta =
@@ -2722,10 +2722,11 @@ int iwl4965_fill_rs_info(struct ieee80211_hw *hw, char *buf, u8 sta_id)
 		i = j;
 	}
 
-	/* Display the average rate of all samples taken.
-	 *
-	 * NOTE:  We multiply # of samples by 2 since the IEEE measurement
-	 * added from iwl4965_rates is actually 2X the rate */
+	/*
+	 * Display the average rate of all samples taken.
+	 * NOTE: We multiply # of samples by 2 since the IEEE measurement
+	 * added from iwl_rates is actually 2X the rate.
+	 */
 	if (samples)
 		cnt += sprintf(&buf[cnt],
 			 "\nAverage rate is %3d.%02dMbs over last %4dms\n"
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.h b/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
index 7ea2041..1dd4124 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
@@ -29,7 +29,7 @@
 
 #include "iwl-dev.h"
 
-struct iwl4965_rate_info {
+struct iwl_rate_info {
 	u8 plcp;	/* uCode API:  IWL_RATE_6M_PLCP, etc. */
 	u8 plcp_siso;	/* uCode API:  IWL_RATE_SISO_6M_PLCP, etc. */
 	u8 plcp_mimo2;	/* uCode API:  IWL_RATE_MIMO2_6M_PLCP, etc. */
@@ -45,7 +45,7 @@ struct iwl4965_rate_info {
 
 /*
  * These serve as indexes into
- * struct iwl4965_rate_info iwl4965_rates[IWL_RATE_COUNT];
+ * struct iwl_rate_info iwl_rates[IWL_RATE_COUNT];
  */
 enum {
 	IWL_RATE_1M_INDEX = 0,
@@ -240,7 +240,7 @@ enum {
 #define TID_MAX_TIME_DIFF ((TID_QUEUE_MAX_SIZE - 1) * TID_QUEUE_CELL_SPACING)
 #define TIME_WRAP_AROUND(x, y) (((y) > (x)) ? (y) - (x) : (0-(x)) + (y))
 
-extern const struct iwl4965_rate_info iwl4965_rates[IWL_RATE_COUNT];
+extern const struct iwl_rate_info iwl_rates[IWL_RATE_COUNT];
 
 enum iwl_table_type {
 	LQ_NONE,
@@ -279,7 +279,7 @@ static inline u8 num_of_ant(u8 mask)
 
 static inline u8 iwl4965_get_prev_ieee_rate(u8 rate_index)
 {
-	u8 rate = iwl4965_rates[rate_index].prev_ieee;
+	u8 rate = iwl_rates[rate_index].prev_ieee;
 
 	if (rate == IWL_RATE_INVALID)
 		rate = rate_index;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 922b0a1..1ec53a3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -345,8 +345,8 @@ int iwl4965_hwrate_to_plcp_idx(u32 rate_n_flags)
 
 	/* 4965 legacy rate format, search for match in table */
 	} else {
-		for (idx = 0; idx < ARRAY_SIZE(iwl4965_rates); idx++)
-			if (iwl4965_rates[idx].plcp == (rate_n_flags & 0xFF))
+		for (idx = 0; idx < ARRAY_SIZE(iwl_rates); idx++)
+			if (iwl_rates[idx].plcp == (rate_n_flags & 0xFF))
 				return idx;
 	}
 
@@ -1951,7 +1951,7 @@ void iwl4965_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 	u16 rate_flags = 0;
 	int rate_idx = min(ctrl->tx_rate->hw_value & 0xffff, IWL_RATE_COUNT - 1);
 
-	rate_plcp = iwl4965_rates[rate_idx].plcp;
+	rate_plcp = iwl_rates[rate_idx].plcp;
 
 	rts_retry_limit = (is_hcca) ?
 	    RTS_HCCA_RETRY_LIMIT : RTS_DFAULT_RETRY_LIMIT;
@@ -2436,7 +2436,7 @@ static void iwl4965_add_radiotap(struct iwl_priv *priv,
 	if (rate == -1)
 		iwl4965_rt->rt_rate = 0;
 	else
-		iwl4965_rt->rt_rate = iwl4965_rates[rate].ieee;
+		iwl4965_rt->rt_rate = iwl_rates[rate].ieee;
 
 	/*
 	 * "antenna number"
@@ -2848,7 +2848,7 @@ static void iwl4965_dbg_report_frame(struct iwl_priv *priv,
 		if (unlikely(rate_idx == -1))
 			bitrate = 0;
 		else
-			bitrate = iwl4965_rates[rate_idx].ieee / 2;
+			bitrate = iwl_rates[rate_idx].ieee / 2;
 
 		/* print frame summary.
 		 * MAC addresses show just the last byte (for brevity),
@@ -3473,7 +3473,7 @@ void iwl4965_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
 		rate_flags |= RATE_MCS_ANT_B_MSK; /*FIXME:RS*/
 
 		link_cmd.rs_table[i].rate_n_flags =
-			iwl4965_hw_set_rate_n_flags(iwl4965_rates[r].plcp, rate_flags);
+			iwl4965_hw_set_rate_n_flags(iwl_rates[r].plcp, rate_flags);
 		r = iwl4965_get_prev_ieee_rate(r);
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index b800031..8e411de 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -67,7 +67,7 @@ MODULE_LICENSE("GPL");
  * maps to IWL_RATE_INVALID
  *
  */
-const struct iwl4965_rate_info iwl4965_rates[IWL_RATE_COUNT] = {
+const struct iwl_rate_info iwl_rates[IWL_RATE_COUNT] = {
 	IWL_DECLARE_RATE_INFO(1, INV, INV, 2, INV, 2, INV, 2),    /*  1mbps */
 	IWL_DECLARE_RATE_INFO(2, INV, 1, 5, 1, 5, 1, 5),          /*  2mbps */
 	IWL_DECLARE_RATE_INFO(5, INV, 2, 6, 2, 11, 2, 11),        /*5.5mbps */
@@ -83,7 +83,7 @@ const struct iwl4965_rate_info iwl4965_rates[IWL_RATE_COUNT] = {
 	IWL_DECLARE_RATE_INFO(60, 60, 48, INV, 48, INV, 48, INV),/* 60mbps */
 	/* FIXME:RS:          ^^    should be INV (legacy) */
 };
-EXPORT_SYMBOL(iwl4965_rates);
+EXPORT_SYMBOL(iwl_rates);
 
 /* This function both allocates and initializes hw and priv. */
 struct ieee80211_hw *iwl_alloc_all(struct iwl_cfg *cfg,
@@ -383,7 +383,7 @@ static void iwlcore_init_hw_rates(struct iwl_priv *priv,
 	int i;
 
 	for (i = 0; i < IWL_RATE_COUNT; i++) {
-		rates[i].bitrate = iwl4965_rates[i].ieee * 5;
+		rates[i].bitrate = iwl_rates[i].ieee * 5;
 		rates[i].hw_value = i; /* Rate scaling will work on indexes */
 		rates[i].hw_value_short = i;
 		rates[i].flags = 0;
@@ -392,7 +392,7 @@ static void iwlcore_init_hw_rates(struct iwl_priv *priv,
 			 * If CCK != 1M then set short preamble rate flag.
 			 */
 			rates[i].flags |=
-				(iwl4965_rates[i].plcp == IWL_RATE_1M_PLCP) ?
+				(iwl_rates[i].plcp == IWL_RATE_1M_PLCP) ?
 					0 : IEEE80211_RATE_SHORT_PREAMBLE;
 		}
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 1c45b6f..edde814 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -878,9 +878,9 @@ static u8 iwl4965_rate_get_lowest_plcp(struct iwl_priv *priv)
 
 	/* Find lowest valid rate */
 	for (i = IWL_RATE_1M_INDEX; i != IWL_RATE_INVALID;
-					i = iwl4965_rates[i].next_ieee) {
+					i = iwl_rates[i].next_ieee) {
 		if (rate_mask & (1 << i))
-			return iwl4965_rates[i].plcp;
+			return iwl_rates[i].plcp;
 	}
 
 	/* No valid rate was found. Assign the lowest one */
@@ -939,7 +939,7 @@ static u16 iwl4965_supported_rate_to_ie(u8 *ie, u16 supported_rate,
 	for (bit = 1, i = 0; i < IWL_RATE_COUNT; i++, bit <<= 1) {
 		if (bit & supported_rate) {
 			ret_rates |= bit;
-			rates[*cnt] = iwl4965_rates[i].ieee |
+			rates[*cnt] = iwl_rates[i].ieee |
 				((bit & basic_rate) ? 0x80 : 0x00);
 			(*cnt)++;
 			(*left)--;
-- 
1.5.3.6

