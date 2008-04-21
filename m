Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59302 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887AbYDUWmP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 18:42:15 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Guy Cohen <guy.cohen@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 11/11] iwlwifi: HT antenna/chains overhaul
Date: Mon, 21 Apr 2008 15:42:01 -0700
Message-Id: <1208817721-11333-12-git-send-email-reinette.chatre@intel.com> (sfid-20080422_004344_822128_F8EC1928)
In-Reply-To: <1208817721-11333-11-git-send-email-reinette.chatre@intel.com>
References: <1208817721-11333-1-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-2-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-3-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-4-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-5-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-6-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-7-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-8-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-9-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-10-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-11-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Guy Cohen <guy.cohen@intel.com>

1. This patch restructures rate scale algorithm to support
   SISO, MIMO2, MIMO3
2. It adds support for detailed valid TX and RX antennas settings
3. It removes few unesfull antenna definitions

Signed-off-by: Guy Cohen <guy.cohen@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-commands.h |    9 +-
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c       |  337 +++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-4965-rs.h       |   85 ++++--
 drivers/net/wireless/iwlwifi/iwl-4965.c          |   57 ++--
 drivers/net/wireless/iwlwifi/iwl-4965.h          |   15 +-
 drivers/net/wireless/iwlwifi/iwl-calib.c         |    3 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c      |   39 ---
 7 files changed, 262 insertions(+), 283 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
index b2fa58d..7ffae05 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
@@ -269,10 +269,11 @@ struct iwl_cmd_header {
  *          10 B active, A inactive
  *          11 Both active
  */
-#define RATE_MCS_ANT_POS       14
-#define RATE_MCS_ANT_A_MSK     0x04000
-#define RATE_MCS_ANT_B_MSK     0x08000
-#define RATE_MCS_ANT_AB_MSK    0x0C000
+#define RATE_MCS_ANT_POS      14
+#define RATE_MCS_ANT_A_MSK    0x04000
+#define RATE_MCS_ANT_B_MSK    0x08000
+#define RATE_MCS_ANT_C_MSK    0x10000
+#define RATE_MCS_ANT_ABC_MSK  0x1C000
 
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index e20c938..31a0451 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -87,8 +87,8 @@ struct iwl4965_rate_scale_data {
  * one for "active", and one for "search".
  */
 struct iwl4965_scale_tbl_info {
-	enum iwl4965_table_type lq_type;
-	enum iwl4965_antenna_type antenna_type;
+	enum iwl_table_type lq_type;
+	u8 ant_type;
 	u8 is_SGI;	/* 1 = short guard interval */
 	u8 is_fat;	/* 1 = 40 MHz channel width */
 	u8 is_dup;	/* 1 = duplicated data streams */
@@ -146,7 +146,8 @@ struct iwl4965_lq_sta {
 	u32 supp_rates;
 	u16 active_rate;
 	u16 active_siso_rate;
-	u16 active_mimo_rate;
+	u16 active_mimo2_rate;
+	u16 active_mimo3_rate;
 	u16 active_rate_basic;
 
 	struct iwl_link_quality_cmd lq;
@@ -170,7 +171,8 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 				   struct net_device *dev,
 				   struct ieee80211_hdr *hdr,
 				   struct sta_info *sta);
-static void rs_fill_link_cmd(struct iwl4965_lq_sta *lq_sta,
+static void rs_fill_link_cmd(const struct iwl_priv *priv,
+			     struct iwl4965_lq_sta *lq_sta,
 			     struct iwl4965_rate *tx_mcs,
 			     struct iwl_link_quality_cmd *tbl);
 
@@ -189,6 +191,7 @@ static void rs_dbgfs_set_mcs(struct iwl4965_lq_sta *lq_sta,
  * 1, 2, 5.5, 11, 6, 9, 12, 18, 24, 36, 48, 54, 60 MBits
  * "G" is the only table that supports CCK (the first 4 rates).
  */
+/*FIXME:RS:need to spearate tables for MIMO2/MIMO3*/
 static s32 expected_tpt_A[IWL_RATE_COUNT] = {
 	0, 0, 0, 0, 40, 57, 72, 98, 121, 154, 177, 186, 186
 };
@@ -373,6 +376,13 @@ static void rs_tl_turn_on_agg(struct iwl_priv *priv, u8 tid,
 
 #endif /* CONFIG_IWLWIFI_HT */
 
+static inline int get_num_of_ant_from_mcs(u32 mcs)
+{
+	return (!!(mcs & RATE_MCS_ANT_A_MSK) +
+		!!(mcs & RATE_MCS_ANT_B_MSK) +
+		!!(mcs & RATE_MCS_ANT_C_MSK));
+}
+
 /**
  * rs_collect_tx_data - Update the success/failure sliding window
  *
@@ -466,31 +476,28 @@ static void rs_mcs_from_tbl(struct iwl4965_rate *mcs_rate,
 		if (index >= IWL_FIRST_CCK_RATE && index <= IWL_LAST_CCK_RATE)
 			mcs_rate->rate_n_flags |= RATE_MCS_CCK_MSK;
 
-	} else if (is_siso(tbl->lq_type)) {
-		if (index > IWL_LAST_OFDM_RATE)
+	} else if (is_Ht(tbl->lq_type)) {
+		if (index > IWL_LAST_OFDM_RATE) {
+			IWL_ERROR("invalid HT rate index %d\n", index);
 			index = IWL_LAST_OFDM_RATE;
-		 mcs_rate->rate_n_flags = iwl4965_rates[index].plcp_siso |
-					  RATE_MCS_HT_MSK;
+		}
+		mcs_rate->rate_n_flags = RATE_MCS_HT_MSK;
+
+		if (is_siso(tbl->lq_type))
+			mcs_rate->rate_n_flags |=
+					iwl4965_rates[index].plcp_siso;
+		else if (is_mimo2(tbl->lq_type))
+			mcs_rate->rate_n_flags |=
+					iwl4965_rates[index].plcp_mimo2;
+		else
+			mcs_rate->rate_n_flags |=
+					iwl4965_rates[index].plcp_mimo3;
 	} else {
-		if (index > IWL_LAST_OFDM_RATE)
-			index = IWL_LAST_OFDM_RATE;
-		mcs_rate->rate_n_flags = iwl4965_rates[index].plcp_mimo |
-					 RATE_MCS_HT_MSK;
+		IWL_ERROR("Invalid tbl->lq_type %d\n", tbl->lq_type);
 	}
 
-	switch (tbl->antenna_type) {
-	case ANT_BOTH:
-		mcs_rate->rate_n_flags |= RATE_MCS_ANT_AB_MSK;
-		break;
-	case ANT_MAIN:
-		mcs_rate->rate_n_flags |= RATE_MCS_ANT_A_MSK;
-		break;
-	case ANT_AUX:
-		mcs_rate->rate_n_flags |= RATE_MCS_ANT_B_MSK;
-		break;
-	case ANT_NONE:
-		break;
-	}
+	mcs_rate->rate_n_flags |= ((tbl->ant_type << RATE_MCS_ANT_POS) &
+						     RATE_MCS_ANT_ABC_MSK);
 
 	if (is_legacy(tbl->lq_type))
 		return;
@@ -520,69 +527,31 @@ static int rs_get_tbl_info_from_mcs(const struct iwl4965_rate *mcs_rate,
 				    struct iwl4965_scale_tbl_info *tbl,
 				    int *rate_idx)
 {
-	int index;
-	u32 ant_msk;
+	u32 ant_msk = (mcs_rate->rate_n_flags & RATE_MCS_ANT_ABC_MSK);
+	u8 num_of_ant = get_num_of_ant_from_mcs(ant_msk);
 
-	index = iwl4965_hwrate_to_plcp_idx(mcs_rate->rate_n_flags);
+	*rate_idx = iwl4965_hwrate_to_plcp_idx(mcs_rate->rate_n_flags);
 
-	if (index  == IWL_RATE_INVALID) {
+	if (*rate_idx  == IWL_RATE_INVALID) {
 		*rate_idx = -1;
 		return -EINVAL;
 	}
 	tbl->is_SGI = 0;	/* default legacy setup */
 	tbl->is_fat = 0;
 	tbl->is_dup = 0;
-	tbl->antenna_type = ANT_BOTH;	/* default MIMO setup */
+	tbl->ant_type = (ant_msk >> RATE_MCS_ANT_POS);
+	tbl->lq_type = LQ_NONE;
 
 	/* legacy rate format */
 	if (!(mcs_rate->rate_n_flags & RATE_MCS_HT_MSK)) {
-		ant_msk = (mcs_rate->rate_n_flags & RATE_MCS_ANT_AB_MSK);
-
-		if (ant_msk == RATE_MCS_ANT_AB_MSK)
-			tbl->lq_type = LQ_NONE;
-		else {
-
+		if (num_of_ant == 1) {
 			if (band == IEEE80211_BAND_5GHZ)
 				tbl->lq_type = LQ_A;
 			else
 				tbl->lq_type = LQ_G;
-
-			if (mcs_rate->rate_n_flags & RATE_MCS_ANT_A_MSK)
-				tbl->antenna_type = ANT_MAIN;
-			else
-				tbl->antenna_type = ANT_AUX;
-		}
-		*rate_idx = index;
-
-	/* HT rate format, SISO (might be 20 MHz legacy or 40 MHz fat width) */
-	} else if (iwl4965_rate_get_rate(mcs_rate->rate_n_flags)
-					<= IWL_RATE_SISO_60M_PLCP) {
-		tbl->lq_type = LQ_SISO;
-
-		ant_msk = (mcs_rate->rate_n_flags & RATE_MCS_ANT_AB_MSK);
-		if (ant_msk == RATE_MCS_ANT_AB_MSK)
-			tbl->lq_type = LQ_NONE;
-		else {
-			if (mcs_rate->rate_n_flags & RATE_MCS_ANT_A_MSK)
-				tbl->antenna_type = ANT_MAIN;
-			else
-				tbl->antenna_type = ANT_AUX;
 		}
-		if (mcs_rate->rate_n_flags & RATE_MCS_SGI_MSK)
-			tbl->is_SGI = 1;
-
-		if ((mcs_rate->rate_n_flags & RATE_MCS_FAT_MSK) ||
-		    (mcs_rate->rate_n_flags & RATE_MCS_DUP_MSK))
-			tbl->is_fat = 1;
-
-		if (mcs_rate->rate_n_flags & RATE_MCS_DUP_MSK)
-			tbl->is_dup = 1;
-
-		*rate_idx = index;
-
-	/* HT rate format, MIMO (might be 20 MHz legacy or 40 MHz fat width) */
+	/* HT rate format */
 	} else {
-		tbl->lq_type = LQ_MIMO;
 		if (mcs_rate->rate_n_flags & RATE_MCS_SGI_MSK)
 			tbl->is_SGI = 1;
 
@@ -592,23 +561,32 @@ static int rs_get_tbl_info_from_mcs(const struct iwl4965_rate *mcs_rate,
 
 		if (mcs_rate->rate_n_flags & RATE_MCS_DUP_MSK)
 			tbl->is_dup = 1;
-		*rate_idx = index;
+
+		/* SISO */
+		if (iwl4965_rate_get_rate(mcs_rate->rate_n_flags)
+						<= IWL_RATE_SISO_60M_PLCP) {
+
+			if (num_of_ant == 1)
+				tbl->lq_type = LQ_SISO; /*else NONE*/
+		/* MIMO2 */
+		} else if (iwl4965_rate_get_rate(mcs_rate->rate_n_flags)
+						<= IWL_RATE_MIMO2_60M_PLCP) {
+			if (num_of_ant == 2)
+				tbl->lq_type = LQ_MIMO2;
+		/* MIMO3 */
+		} else {
+			if (num_of_ant == 3)
+				tbl->lq_type = LQ_MIMO3;
+		}
 	}
 	return 0;
 }
-
+/* FIXME:RS: need to toggle also ANT_C, and also AB,AC,BC */
 static inline void rs_toggle_antenna(struct iwl4965_rate *new_rate,
 				     struct iwl4965_scale_tbl_info *tbl)
 {
-	if (tbl->antenna_type == ANT_AUX) {
-		tbl->antenna_type = ANT_MAIN;
-		new_rate->rate_n_flags &= ~RATE_MCS_ANT_B_MSK;
-		new_rate->rate_n_flags |= RATE_MCS_ANT_A_MSK;
-	} else {
-		tbl->antenna_type = ANT_AUX;
-		new_rate->rate_n_flags &= ~RATE_MCS_ANT_A_MSK;
-		new_rate->rate_n_flags |= RATE_MCS_ANT_B_MSK;
-	}
+	tbl->ant_type ^= ANT_AB;
+	new_rate->rate_n_flags ^= (RATE_MCS_ANT_A_MSK|RATE_MCS_ANT_B_MSK);
 }
 
 static inline u8 rs_use_green(struct iwl_priv *priv,
@@ -631,7 +609,7 @@ static inline u8 rs_use_green(struct iwl_priv *priv,
  */
 static void rs_get_supported_rates(struct iwl4965_lq_sta *lq_sta,
 				   struct ieee80211_hdr *hdr,
-				   enum iwl4965_table_type rate_type,
+				   enum iwl_table_type rate_type,
 				   u16 *data_rate)
 {
 	if (is_legacy(rate_type))
@@ -639,8 +617,10 @@ static void rs_get_supported_rates(struct iwl4965_lq_sta *lq_sta,
 	else {
 		if (is_siso(rate_type))
 			*data_rate = lq_sta->active_siso_rate;
+		else if (is_mimo2(rate_type))
+			*data_rate = lq_sta->active_mimo2_rate;
 		else
-			*data_rate = lq_sta->active_mimo_rate;
+			*data_rate = lq_sta->active_mimo3_rate;
 	}
 
 	if (hdr && is_multicast_ether_addr(hdr->addr1) &&
@@ -725,9 +705,8 @@ static void rs_get_lower_rate(struct iwl4965_lq_sta *lq_sta,
 		else
 			tbl->lq_type = LQ_G;
 
-		if ((tbl->antenna_type == ANT_BOTH) ||
-		    (tbl->antenna_type == ANT_NONE))
-			tbl->antenna_type = ANT_MAIN;
+		if (num_of_ant(tbl->ant_type > 1))
+			tbl->ant_type = ANT_A;/*FIXME:RS*/
 
 		tbl->is_fat = 0;
 		tbl->is_SGI = 0;
@@ -821,13 +800,6 @@ static void rs_tx_status(void *priv_rate, struct net_device *dev,
 	table = &lq_sta->lq;
 	active_index = lq_sta->active_tbl;
 
-	/* Get mac80211 antenna info */
-	lq_sta->antenna =
-		(lq_sta->valid_antenna & local->hw.conf.antenna_sel_tx);
-	if (!lq_sta->antenna)
-		lq_sta->antenna = lq_sta->valid_antenna;
-
-	/* Ignore mac80211 antenna info for now */
 	lq_sta->antenna = lq_sta->valid_antenna;
 
 	curr_tbl = &(lq_sta->lq_info[active_index]);
@@ -857,8 +829,7 @@ static void rs_tx_status(void *priv_rate, struct net_device *dev,
 		!!(tx_resp->control.flags & IEEE80211_TXCTL_40_MHZ_WIDTH)) ||
 	    (tbl_type.is_dup ^
 		!!(tx_resp->control.flags & IEEE80211_TXCTL_DUP_DATA)) ||
-	    (tbl_type.antenna_type ^
-		tx_resp->control.antenna_sel_tx) ||
+	    (tbl_type.ant_type ^ tx_resp->control.antenna_sel_tx) ||
 	    (!!(tx_mcs.rate_n_flags & RATE_MCS_HT_MSK) ^
 		!!(tx_resp->control.flags & IEEE80211_TXCTL_OFDM_HT)) ||
 	    (!!(tx_mcs.rate_n_flags & RATE_MCS_GF_MSK) ^
@@ -882,7 +853,7 @@ static void rs_tx_status(void *priv_rate, struct net_device *dev,
 		/* If type matches "search" table,
 		 * add failure to "search" history */
 		if ((tbl_type.lq_type == search_tbl->lq_type) &&
-		    (tbl_type.antenna_type == search_tbl->antenna_type) &&
+		    (tbl_type.ant_type == search_tbl->ant_type) &&
 		    (tbl_type.is_SGI == search_tbl->is_SGI)) {
 			if (search_tbl->expected_tpt)
 				tpt = search_tbl->expected_tpt[rs_index];
@@ -893,7 +864,7 @@ static void rs_tx_status(void *priv_rate, struct net_device *dev,
 		/* Else if type matches "current/active" table,
 		 * add failure to "current/active" history */
 		} else if ((tbl_type.lq_type == curr_tbl->lq_type) &&
-			   (tbl_type.antenna_type == curr_tbl->antenna_type) &&
+			   (tbl_type.ant_type == curr_tbl->ant_type) &&
 			   (tbl_type.is_SGI == curr_tbl->is_SGI)) {
 			if (curr_tbl->expected_tpt)
 				tpt = curr_tbl->expected_tpt[rs_index];
@@ -928,7 +899,7 @@ static void rs_tx_status(void *priv_rate, struct net_device *dev,
 	/* If type matches "search" table,
 	 * add final tx status to "search" history */
 	if ((tbl_type.lq_type == search_tbl->lq_type) &&
-	    (tbl_type.antenna_type == search_tbl->antenna_type) &&
+	    (tbl_type.ant_type == search_tbl->ant_type) &&
 	    (tbl_type.is_SGI == search_tbl->is_SGI)) {
 		if (search_tbl->expected_tpt)
 			tpt = search_tbl->expected_tpt[rs_index];
@@ -944,7 +915,7 @@ static void rs_tx_status(void *priv_rate, struct net_device *dev,
 	/* Else if type matches "current/active" table,
 	 * add final tx status to "current/active" history */
 	} else if ((tbl_type.lq_type == curr_tbl->lq_type) &&
-		   (tbl_type.antenna_type == curr_tbl->antenna_type) &&
+		   (tbl_type.ant_type == curr_tbl->ant_type) &&
 		   (tbl_type.is_SGI == curr_tbl->is_SGI)) {
 		if (curr_tbl->expected_tpt)
 			tpt = curr_tbl->expected_tpt[rs_index];
@@ -981,26 +952,18 @@ out:
 	return;
 }
 
-static u8 rs_is_ant_connected(u8 valid_antenna,
-			      enum iwl4965_antenna_type antenna_type)
+static inline u8 rs_is_ant_connected(u8 valid_antenna, u8 ant_type)
 {
-	if (antenna_type == ANT_AUX)
-		return ((valid_antenna & 0x2) ? 1:0);
-	else if (antenna_type == ANT_MAIN)
-		return ((valid_antenna & 0x1) ? 1:0);
-	else if (antenna_type == ANT_BOTH)
-		return ((valid_antenna & 0x3) == 0x3);
-
-	return 1;
+	return ((ant_type & valid_antenna) == ant_type);
 }
 
-static u8 rs_is_other_ant_connected(u8 valid_antenna,
-				    enum iwl4965_antenna_type antenna_type)
+/*FIXME:RS: this function should be replaced*/
+static u8 rs_is_other_ant_connected(u8 valid_antenna, u8 ant_type)
 {
-	if (antenna_type == ANT_AUX)
-		return rs_is_ant_connected(valid_antenna, ANT_MAIN);
+	if (ant_type == ANT_B)
+		return rs_is_ant_connected(valid_antenna, ANT_A);
 	else
-		return rs_is_ant_connected(valid_antenna, ANT_AUX);
+		return rs_is_ant_connected(valid_antenna, ANT_B);
 
 	return 0;
 }
@@ -1054,7 +1017,7 @@ static void rs_get_expected_tpt_table(struct iwl4965_lq_sta *lq_sta,
 		else
 			tbl->expected_tpt = expected_tpt_siso20MHz;
 
-	} else if (is_mimo(tbl->lq_type)) {
+	} else if (is_mimo(tbl->lq_type)) { /* FIXME:need to separate mimo2/3 */
 		if (tbl->is_fat && !lq_sta->is_dup)
 			if (tbl->is_SGI)
 				tbl->expected_tpt = expected_tpt_mimo40MHzSGI;
@@ -1171,21 +1134,22 @@ static s32 rs_get_best_rate(struct iwl_priv *priv,
 }
 #endif				/* CONFIG_IWL4965_HT */
 
+/*FIXME:RS:this function should be replaced*/
 static inline u8 rs_is_both_ant_supp(u8 valid_antenna)
 {
-	return (rs_is_ant_connected(valid_antenna, ANT_BOTH));
+	return (rs_is_ant_connected(valid_antenna, ANT_AB));
 }
 
 /*
  * Set up search table for MIMO
  */
-static int rs_switch_to_mimo(struct iwl_priv *priv,
+#ifdef CONFIG_IWL4965_HT
+static int rs_switch_to_mimo2(struct iwl_priv *priv,
 			     struct iwl4965_lq_sta *lq_sta,
 			     struct ieee80211_conf *conf,
 			     struct sta_info *sta,
 			     struct iwl4965_scale_tbl_info *tbl, int index)
 {
-#ifdef CONFIG_IWL4965_HT
 	u16 rate_mask;
 	s32 rate;
 	s8 is_green = lq_sta->is_green;
@@ -1195,7 +1159,7 @@ static int rs_switch_to_mimo(struct iwl_priv *priv,
 		return -1;
 
 	IWL_DEBUG_HT("LQ: try to switch to MIMO\n");
-	tbl->lq_type = LQ_MIMO;
+	tbl->lq_type = LQ_MIMO2;
 	rs_get_supported_rates(lq_sta, NULL, tbl->lq_type,
 				&rate_mask);
 
@@ -1203,7 +1167,7 @@ static int rs_switch_to_mimo(struct iwl_priv *priv,
 		return -1;
 
 	/* Need both Tx chains/antennas to support MIMO */
-	if (!rs_is_both_ant_supp(lq_sta->antenna))
+	if (!rs_is_both_ant_supp(priv->hw_params.valid_tx_ant))
 		return -1;
 
 	tbl->is_dup = lq_sta->is_dup;
@@ -1236,10 +1200,17 @@ static int rs_switch_to_mimo(struct iwl_priv *priv,
 	IWL_DEBUG_HT("LQ: Switch to new mcs %X index is green %X\n",
 		     tbl->current_rate.rate_n_flags, is_green);
 	return 0;
+}
 #else
+static int rs_switch_to_mimo2(struct iwl_priv *priv,
+			     struct iwl4965_lq_sta *lq_sta,
+			     struct ieee80211_conf *conf,
+			     struct sta_info *sta,
+			     struct iwl4965_scale_tbl_info *tbl, int index)
+{
 	return -1;
-#endif	/*CONFIG_IWL4965_HT */
 }
+#endif	/*CONFIG_IWL4965_HT */
 
 /*
  * Set up search table for SISO
@@ -1313,7 +1284,6 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 				struct sta_info *sta,
 				int index)
 {
-	int ret = 0;
 	struct iwl4965_scale_tbl_info *tbl =
 	    &(lq_sta->lq_info[lq_sta->active_tbl]);
 	struct iwl4965_scale_tbl_info *search_tbl =
@@ -1322,6 +1292,8 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 	u32 sz = (sizeof(struct iwl4965_scale_tbl_info) -
 		  (sizeof(struct iwl4965_rate_scale_data) * IWL_RATE_COUNT));
 	u8 start_action = tbl->action;
+	u8 valid_tx_ant = priv->hw_params.valid_tx_ant;
+	int ret = 0;
 
 	for (; ;) {
 		switch (tbl->action) {
@@ -1336,8 +1308,8 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 				break;
 
 			/* Don't change antenna if other one is not connected */
-			if (!rs_is_other_ant_connected(lq_sta->antenna,
-							tbl->antenna_type))
+			if (!rs_is_other_ant_connected(valid_tx_ant,
+							tbl->ant_type))
 				break;
 
 			/* Set up search table to try other antenna */
@@ -1366,16 +1338,17 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 			}
 
 			break;
-		case IWL_LEGACY_SWITCH_MIMO:
+		case IWL_LEGACY_SWITCH_MIMO2:
 			IWL_DEBUG_HT("LQ: Legacy switch MIMO\n");
 
 			/* Set up search table to try MIMO */
 			memcpy(search_tbl, tbl, sz);
-			search_tbl->lq_type = LQ_MIMO;
+			search_tbl->lq_type = LQ_MIMO2;
 			search_tbl->is_SGI = 0;
 			search_tbl->is_fat = 0;
-			search_tbl->antenna_type = ANT_BOTH;
-			ret = rs_switch_to_mimo(priv, lq_sta, conf, sta,
+			search_tbl->ant_type = ANT_AB;/*FIXME:RS*/
+				/*FIXME:RS:need to check ant validity*/
+			ret = rs_switch_to_mimo2(priv, lq_sta, conf, sta,
 						 search_tbl, index);
 			if (!ret) {
 				lq_sta->search_better_tbl = 1;
@@ -1385,7 +1358,7 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 			break;
 		}
 		tbl->action++;
-		if (tbl->action > IWL_LEGACY_SWITCH_MIMO)
+		if (tbl->action > IWL_LEGACY_SWITCH_MIMO2)
 			tbl->action = IWL_LEGACY_SWITCH_ANTENNA;
 
 		if (tbl->action == start_action)
@@ -1396,7 +1369,7 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 
  out:
 	tbl->action++;
-	if (tbl->action > IWL_LEGACY_SWITCH_MIMO)
+	if (tbl->action > IWL_LEGACY_SWITCH_MIMO2)
 		tbl->action = IWL_LEGACY_SWITCH_ANTENNA;
 	return 0;
 
@@ -1411,7 +1384,6 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 				 struct sta_info *sta,
 				 int index)
 {
-	int ret;
 	u8 is_green = lq_sta->is_green;
 	struct iwl4965_scale_tbl_info *tbl =
 	    &(lq_sta->lq_info[lq_sta->active_tbl]);
@@ -1421,6 +1393,8 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 	u32 sz = (sizeof(struct iwl4965_scale_tbl_info) -
 		  (sizeof(struct iwl4965_rate_scale_data) * IWL_RATE_COUNT));
 	u8 start_action = tbl->action;
+	u8 valid_tx_ant = priv->hw_params.valid_tx_ant;
+	int ret;
 
 	for (;;) {
 		lq_sta->action_counter++;
@@ -1430,26 +1404,26 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 			search_tbl->lq_type = LQ_NONE;
 			if (window->success_ratio >= IWL_RS_GOOD_RATIO)
 				break;
-			if (!rs_is_other_ant_connected(lq_sta->antenna,
-						       tbl->antenna_type))
+			if (!rs_is_other_ant_connected(valid_tx_ant,
+						       tbl->ant_type))
 				break;
 
 			memcpy(search_tbl, tbl, sz);
-			search_tbl->action = IWL_SISO_SWITCH_MIMO;
+			search_tbl->action = IWL_SISO_SWITCH_MIMO2;
 			rs_toggle_antenna(&(search_tbl->current_rate),
 					   search_tbl);
 			lq_sta->search_better_tbl = 1;
 
 			goto out;
 
-		case IWL_SISO_SWITCH_MIMO:
-			IWL_DEBUG_HT("LQ: SISO SWITCH TO MIMO FROM SISO\n");
+		case IWL_SISO_SWITCH_MIMO2:
+			IWL_DEBUG_HT("LQ: SISO SWITCH TO MIMO2 FROM SISO\n");
 			memcpy(search_tbl, tbl, sz);
-			search_tbl->lq_type = LQ_MIMO;
+			search_tbl->lq_type = LQ_MIMO2;
 			search_tbl->is_SGI = 0;
 			search_tbl->is_fat = 0;
-			search_tbl->antenna_type = ANT_BOTH;
-			ret = rs_switch_to_mimo(priv, lq_sta, conf, sta,
+			search_tbl->ant_type = ANT_AB; /*FIXME:RS*/
+			ret = rs_switch_to_mimo2(priv, lq_sta, conf, sta,
 						 search_tbl, index);
 			if (!ret) {
 				lq_sta->search_better_tbl = 1;
@@ -1530,10 +1504,11 @@ static int rs_move_mimo_to_other(struct iwl_priv *priv,
 			search_tbl->lq_type = LQ_SISO;
 			search_tbl->is_SGI = 0;
 			search_tbl->is_fat = 0;
+				/*FIXME:RS:need to check ant validity + C*/
 			if (tbl->action == IWL_MIMO_SWITCH_ANTENNA_A)
-				search_tbl->antenna_type = ANT_MAIN;
+				search_tbl->ant_type = ANT_A;
 			else
-				search_tbl->antenna_type = ANT_AUX;
+				search_tbl->ant_type = ANT_B;
 
 			ret = rs_switch_to_siso(priv, lq_sta, conf, sta,
 						 search_tbl, index);
@@ -1548,8 +1523,6 @@ static int rs_move_mimo_to_other(struct iwl_priv *priv,
 
 			/* Set up new search table for MIMO */
 			memcpy(search_tbl, tbl, sz);
-			search_tbl->lq_type = LQ_MIMO;
-			search_tbl->antenna_type = ANT_BOTH;
 			search_tbl->action = 0;
 			if (search_tbl->is_SGI)
 				search_tbl->is_SGI = 0;
@@ -1563,7 +1536,7 @@ static int rs_move_mimo_to_other(struct iwl_priv *priv,
 			 * and it's working well, there's no need to look
 			 * for a better type of modulation!
 			 */
-			if ((tbl->lq_type == LQ_MIMO) &&
+			if ((tbl->lq_type == LQ_MIMO2) &&
 			    (tbl->is_SGI)) {
 				s32 tpt = lq_sta->last_tpt / 100;
 				if (((!tbl->is_fat) &&
@@ -1830,7 +1803,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 		/* Set up new rate table in uCode, if needed */
 		if (update_lq) {
 			rs_mcs_from_tbl(&mcs_rate, tbl, index, is_green);
-			rs_fill_link_cmd(lq_sta, &mcs_rate, &lq_sta->lq);
+			rs_fill_link_cmd(priv, lq_sta, &mcs_rate, &lq_sta->lq);
 			iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
 		}
 		goto out;
@@ -1995,7 +1968,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	/* Replace uCode's rate table for the destination station. */
 	if (update_lq) {
 		rs_mcs_from_tbl(&mcs_rate, tbl, index, is_green);
-		rs_fill_link_cmd(lq_sta, &mcs_rate, &lq_sta->lq);
+		rs_fill_link_cmd(priv, lq_sta, &mcs_rate, &lq_sta->lq);
 		iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
 	}
 
@@ -2034,7 +2007,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 
 			IWL_DEBUG_HT("Switch current  mcs: %X index: %d\n",
 				     tbl->current_rate.rate_n_flags, index);
-			rs_fill_link_cmd(lq_sta, &tbl->current_rate,
+			rs_fill_link_cmd(priv, lq_sta, &tbl->current_rate,
 					 &lq_sta->lq);
 			iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
 		}
@@ -2133,6 +2106,7 @@ static void rs_initialize_lq(struct iwl_priv *priv,
 	if ((i < 0) || (i >= IWL_RATE_COUNT))
 		i = 0;
 
+	/* FIXME:RS: This is also wrong in 4965 */
 	mcs_rate.rate_n_flags = iwl4965_rates[i].plcp ;
 	mcs_rate.rate_n_flags |= RATE_MCS_ANT_B_MSK;
 	mcs_rate.rate_n_flags &= ~RATE_MCS_ANT_A_MSK;
@@ -2140,15 +2114,15 @@ static void rs_initialize_lq(struct iwl_priv *priv,
 	if (i >= IWL_FIRST_CCK_RATE && i <= IWL_LAST_CCK_RATE)
 		mcs_rate.rate_n_flags |= RATE_MCS_CCK_MSK;
 
-	tbl->antenna_type = ANT_AUX;
+	tbl->ant_type = ANT_B;
 	rs_get_tbl_info_from_mcs(&mcs_rate, priv->band, tbl, &rate_idx);
-	if (!rs_is_ant_connected(priv->valid_antenna, tbl->antenna_type))
+	if (!rs_is_ant_connected(priv->hw_params.valid_tx_ant, tbl->ant_type))
 	    rs_toggle_antenna(&mcs_rate, tbl);
 
 	rs_mcs_from_tbl(&mcs_rate, tbl, rate_idx, use_green);
 	tbl->current_rate.rate_n_flags = mcs_rate.rate_n_flags;
 	rs_get_expected_tpt_table(lq_sta, tbl);
-	rs_fill_link_cmd(lq_sta, &mcs_rate, &lq_sta->lq);
+	rs_fill_link_cmd(NULL, lq_sta, &mcs_rate, &lq_sta->lq);
 	iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
  out:
 	return;
@@ -2300,8 +2274,6 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 		sta->last_txrate_idx += IWL_FIRST_OFDM_RATE;
 
 	lq_sta->is_dup = 0;
-	lq_sta->valid_antenna = priv->valid_antenna;
-	lq_sta->antenna = priv->antenna;
 	lq_sta->is_green = rs_use_green(priv, conf);
 	lq_sta->active_rate = priv->active_rate;
 	lq_sta->active_rate &= ~(0x1000);
@@ -2312,23 +2284,33 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 	 * active_siso_rate mask includes 9 MBits (bit 5), and CCK (bits 0-3),
 	 * supp_rates[] does not; shift to convert format, force 9 MBits off.
 	 */
-	lq_sta->active_siso_rate = (priv->current_ht_config.supp_mcs_set[0] << 1);
+	lq_sta->active_siso_rate =
+		priv->current_ht_config.supp_mcs_set[0] << 1;
 	lq_sta->active_siso_rate |=
-			(priv->current_ht_config.supp_mcs_set[0] & 0x1);
+		priv->current_ht_config.supp_mcs_set[0] & 0x1;
 	lq_sta->active_siso_rate &= ~((u16)0x2);
-	lq_sta->active_siso_rate =
-			lq_sta->active_siso_rate << IWL_FIRST_OFDM_RATE;
+	lq_sta->active_siso_rate <<= IWL_FIRST_OFDM_RATE;
 
 	/* Same here */
-	lq_sta->active_mimo_rate = (priv->current_ht_config.supp_mcs_set[1] << 1);
-	lq_sta->active_mimo_rate |=
-			(priv->current_ht_config.supp_mcs_set[1] & 0x1);
-	lq_sta->active_mimo_rate &= ~((u16)0x2);
-	lq_sta->active_mimo_rate =
-			lq_sta->active_mimo_rate << IWL_FIRST_OFDM_RATE;
-	IWL_DEBUG_HT("SISO RATE 0x%X MIMO RATE 0x%X\n",
+	lq_sta->active_mimo2_rate =
+		priv->current_ht_config.supp_mcs_set[1] << 1;
+	lq_sta->active_mimo2_rate |=
+		priv->current_ht_config.supp_mcs_set[1] & 0x1;
+	lq_sta->active_mimo2_rate &= ~((u16)0x2);
+	lq_sta->active_mimo2_rate <<= IWL_FIRST_OFDM_RATE;
+
+	lq_sta->active_mimo3_rate =
+		priv->current_ht_config.supp_mcs_set[2] << 1;
+	lq_sta->active_mimo3_rate |=
+		priv->current_ht_config.supp_mcs_set[2] & 0x1;
+	lq_sta->active_mimo3_rate &= ~((u16)0x2);
+	lq_sta->active_mimo3_rate <<= IWL_FIRST_OFDM_RATE;
+
+	IWL_DEBUG_HT("SISO RATE %X MIMO2 RATE %X MIMO3 RATE %X\n",
 		     lq_sta->active_siso_rate,
-		     lq_sta->active_mimo_rate);
+		     lq_sta->active_mimo2_rate,
+		     lq_sta->active_mimo3_rate);
+
 	/* as default allow aggregation for all tids */
 	lq_sta->tx_agg_tid_en = IWL_AGG_ALL_TID;
 #endif /*CONFIG_IWL4965_HT*/
@@ -2342,9 +2324,10 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 	rs_initialize_lq(priv, conf, sta);
 }
 
-static void rs_fill_link_cmd(struct iwl4965_lq_sta *lq_sta,
-			    struct iwl4965_rate *tx_mcs,
-			    struct iwl_link_quality_cmd *lq_cmd)
+static void rs_fill_link_cmd(const struct iwl_priv *priv,
+			     struct iwl4965_lq_sta *lq_sta,
+			     struct iwl4965_rate *tx_mcs,
+			     struct iwl_link_quality_cmd *lq_cmd)
 {
 	int index = 0;
 	int rate_idx;
@@ -2376,7 +2359,8 @@ static void rs_fill_link_cmd(struct iwl4965_lq_sta *lq_sta,
 			cpu_to_le32(tx_mcs->rate_n_flags);
 	new_rate.rate_n_flags = tx_mcs->rate_n_flags;
 
-	if (is_mimo(tbl_type.lq_type) || (tbl_type.antenna_type == ANT_MAIN))
+	/*FIXME:RS*/
+	if (is_mimo(tbl_type.lq_type) || (tbl_type.ant_type == ANT_A))
 		lq_cmd->general_params.single_stream_ant_msk
 			= LINK_QUAL_ANT_A_MSK;
 	else
@@ -2396,7 +2380,9 @@ static void rs_fill_link_cmd(struct iwl4965_lq_sta *lq_sta,
 				if (ant_toggle_count <
 				    NUM_TRY_BEFORE_ANTENNA_TOGGLE)
 					ant_toggle_count++;
-				else {
+				else if (priv && rs_is_other_ant_connected(
+						priv->hw_params.valid_tx_ant,
+						tbl_type.ant_type)) {
 					rs_toggle_antenna(&new_rate, &tbl_type);
 					ant_toggle_count = 1;
 				}
@@ -2429,7 +2415,9 @@ static void rs_fill_link_cmd(struct iwl4965_lq_sta *lq_sta,
 		if (is_legacy(tbl_type.lq_type)) {
 			if (ant_toggle_count < NUM_TRY_BEFORE_ANTENNA_TOGGLE)
 				ant_toggle_count++;
-			else {
+			else if (priv && rs_is_other_ant_connected(
+						priv->hw_params.valid_tx_ant,
+						tbl_type.ant_type)) {
 				rs_toggle_antenna(&new_rate, &tbl_type);
 				ant_toggle_count = 1;
 			}
@@ -2536,13 +2524,14 @@ static ssize_t rs_sta_dbgfs_scale_table_write(struct file *file,
 
 	lq_sta->active_rate = 0x0FFF;	/* 1 - 54 MBits, includes CCK */
 	lq_sta->active_siso_rate = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
-	lq_sta->active_mimo_rate = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
+	lq_sta->active_mimo2_rate = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
+	lq_sta->active_mimo3_rate = 0x1FD0;     /* 6 - 60 MBits, no 9, no CCK */
 
 	IWL_DEBUG_RATE("sta_id %d rate 0x%X\n",
 		lq_sta->lq.sta_id, lq_sta->dbg_fixed.rate_n_flags);
 
 	if (lq_sta->dbg_fixed.rate_n_flags) {
-		rs_fill_link_cmd(lq_sta, &lq_sta->dbg_fixed, &lq_sta->lq);
+		rs_fill_link_cmd(NULL, lq_sta, &lq_sta->dbg_fixed, &lq_sta->lq);
 		iwl_send_lq_cmd(lq_sta->drv, &lq_sta->lq, CMD_ASYNC);
 	}
 
@@ -2703,7 +2692,7 @@ int iwl4965_fill_rs_info(struct ieee80211_hw *hw, char *buf, u8 sta_id)
 	lq_sta = (void *)sta->rate_ctrl_priv;
 
 	lq_type = lq_sta->lq_info[lq_sta->active_tbl].lq_type;
-	antenna = lq_sta->lq_info[lq_sta->active_tbl].antenna_type;
+	antenna = lq_sta->lq_info[lq_sta->active_tbl].ant_type;
 
 	if (is_legacy(lq_type))
 		i = IWL_RATE_54M_INDEX;
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.h b/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
index 866e378..f679320 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.h
@@ -32,7 +32,8 @@
 struct iwl4965_rate_info {
 	u8 plcp;	/* uCode API:  IWL_RATE_6M_PLCP, etc. */
 	u8 plcp_siso;	/* uCode API:  IWL_RATE_SISO_6M_PLCP, etc. */
-	u8 plcp_mimo;	/* uCode API:  IWL_RATE_MIMO_6M_PLCP, etc. */
+	u8 plcp_mimo2;	/* uCode API:  IWL_RATE_MIMO2_6M_PLCP, etc. */
+	u8 plcp_mimo3;  /* uCode API:  IWL_RATE_MIMO3_6M_PLCP, etc. */
 	u8 ieee;	/* MAC header:  IWL_RATE_6M_IEEE, etc. */
 	u8 prev_ieee;    /* previous rate in IEEE speeds */
 	u8 next_ieee;    /* next rate in IEEE speeds */
@@ -60,9 +61,9 @@ enum {
 	IWL_RATE_48M_INDEX,
 	IWL_RATE_54M_INDEX,
 	IWL_RATE_60M_INDEX,
-	IWL_RATE_COUNT,
+	IWL_RATE_COUNT, /*FIXME:RS:change to IWL_RATE_INDEX_COUNT,*/
 	IWL_RATE_INVM_INDEX = IWL_RATE_COUNT,
-	IWL_RATE_INVALID = IWL_RATE_INVM_INDEX
+	IWL_RATE_INVALID = IWL_RATE_COUNT,
 };
 
 enum {
@@ -97,11 +98,13 @@ enum {
 	IWL_RATE_36M_PLCP = 11,
 	IWL_RATE_48M_PLCP = 1,
 	IWL_RATE_54M_PLCP = 3,
-	IWL_RATE_60M_PLCP = 3,
+	IWL_RATE_60M_PLCP = 3,/*FIXME:RS:should be removed*/
 	IWL_RATE_1M_PLCP  = 10,
 	IWL_RATE_2M_PLCP  = 20,
 	IWL_RATE_5M_PLCP  = 55,
 	IWL_RATE_11M_PLCP = 110,
+	/*FIXME:RS:change to IWL_RATE_LEGACY_??M_PLCP */
+	/*FIXME:RS:add IWL_RATE_LEGACY_INVM_PLCP = 0,*/
 };
 
 /* 4965 uCode API values for OFDM high-throughput (HT) bit rates */
@@ -114,16 +117,25 @@ enum {
 	IWL_RATE_SISO_48M_PLCP = 5,
 	IWL_RATE_SISO_54M_PLCP = 6,
 	IWL_RATE_SISO_60M_PLCP = 7,
-	IWL_RATE_MIMO_6M_PLCP  = 0x8,
-	IWL_RATE_MIMO_12M_PLCP = 0x9,
-	IWL_RATE_MIMO_18M_PLCP = 0xa,
-	IWL_RATE_MIMO_24M_PLCP = 0xb,
-	IWL_RATE_MIMO_36M_PLCP = 0xc,
-	IWL_RATE_MIMO_48M_PLCP = 0xd,
-	IWL_RATE_MIMO_54M_PLCP = 0xe,
-	IWL_RATE_MIMO_60M_PLCP = 0xf,
+	IWL_RATE_MIMO2_6M_PLCP  = 0x8,
+	IWL_RATE_MIMO2_12M_PLCP = 0x9,
+	IWL_RATE_MIMO2_18M_PLCP = 0xa,
+	IWL_RATE_MIMO2_24M_PLCP = 0xb,
+	IWL_RATE_MIMO2_36M_PLCP = 0xc,
+	IWL_RATE_MIMO2_48M_PLCP = 0xd,
+	IWL_RATE_MIMO2_54M_PLCP = 0xe,
+	IWL_RATE_MIMO2_60M_PLCP = 0xf,
+	IWL_RATE_MIMO3_6M_PLCP  = 0x10,
+	IWL_RATE_MIMO3_12M_PLCP = 0x11,
+	IWL_RATE_MIMO3_18M_PLCP = 0x12,
+	IWL_RATE_MIMO3_24M_PLCP = 0x13,
+	IWL_RATE_MIMO3_36M_PLCP = 0x14,
+	IWL_RATE_MIMO3_48M_PLCP = 0x15,
+	IWL_RATE_MIMO3_54M_PLCP = 0x16,
+	IWL_RATE_MIMO3_60M_PLCP = 0x17,
 	IWL_RATE_SISO_INVM_PLCP,
-	IWL_RATE_MIMO_INVM_PLCP = IWL_RATE_SISO_INVM_PLCP,
+	IWL_RATE_MIMO2_INVM_PLCP = IWL_RATE_SISO_INVM_PLCP,
+	IWL_RATE_MIMO3_INVM_PLCP = IWL_RATE_SISO_INVM_PLCP,
 };
 
 /* MAC header values for bit rates */
@@ -196,11 +208,11 @@ enum {
 /* possible actions when in legacy mode */
 #define IWL_LEGACY_SWITCH_ANTENNA	0
 #define IWL_LEGACY_SWITCH_SISO		1
-#define IWL_LEGACY_SWITCH_MIMO	        2
+#define IWL_LEGACY_SWITCH_MIMO2		2
 
 /* possible actions when in siso mode */
 #define IWL_SISO_SWITCH_ANTENNA		0
-#define IWL_SISO_SWITCH_MIMO		1
+#define IWL_SISO_SWITCH_MIMO2		1
 #define IWL_SISO_SWITCH_GI		2
 
 /* possible actions when in mimo mode */
@@ -208,6 +220,10 @@ enum {
 #define IWL_MIMO_SWITCH_ANTENNA_B	1
 #define IWL_MIMO_SWITCH_GI		2
 
+/*FIXME:RS:separate MIMO2/3 transitions*/
+
+/*FIXME:RS:add posible acctions for MIMO3*/
+
 #define IWL_ACTION_LIMIT		3	/* # possible actions */
 
 #define LQ_SIZE		2	/* 2 mode tables:  "Active" and "Search" */
@@ -226,29 +242,40 @@ enum {
 
 extern const struct iwl4965_rate_info iwl4965_rates[IWL_RATE_COUNT];
 
-enum iwl4965_table_type {
+enum iwl_table_type {
 	LQ_NONE,
 	LQ_G,		/* legacy types */
 	LQ_A,
 	LQ_SISO,	/* high-throughput types */
-	LQ_MIMO,
+	LQ_MIMO2,
+	LQ_MIMO3,
 	LQ_MAX,
 };
 
 #define is_legacy(tbl) (((tbl) == LQ_G) || ((tbl) == LQ_A))
-#define is_siso(tbl) (((tbl) == LQ_SISO))
-#define is_mimo(tbl) (((tbl) == LQ_MIMO))
+#define is_siso(tbl) ((tbl) == LQ_SISO)
+#define is_mimo2(tbl) ((tbl) == LQ_MIMO2)
+#define is_mimo3(tbl) ((tbl) == LQ_MIMO3)
+#define is_mimo(tbl) (is_mimo2(tbl) || is_mimo3(tbl))
 #define is_Ht(tbl) (is_siso(tbl) || is_mimo(tbl))
-#define is_a_band(tbl) (((tbl) == LQ_A))
-#define is_g_and(tbl) (((tbl) == LQ_G))
-
-/* 4965 has 2 antennas/chains for Tx (but 3 for Rx) */
-enum iwl4965_antenna_type {
-	ANT_NONE,
-	ANT_MAIN,
-	ANT_AUX,
-	ANT_BOTH,
-};
+#define is_a_band(tbl) ((tbl) == LQ_A)
+#define is_g_and(tbl) ((tbl) == LQ_G)
+
+#define	ANT_NONE	0x0
+#define	ANT_A		BIT(0)
+#define	ANT_B		BIT(1)
+#define	ANT_AB		(ANT_A | ANT_B)
+#define ANT_C		BIT(2)
+#define	ANT_AC		(ANT_A | ANT_C)
+#define ANT_BC		(ANT_B | ANT_C)
+#define ANT_ABC		(ANT_AB | ANT_C)
+
+static inline u8 num_of_ant(u8 mask)
+{
+	return  !!((mask) & ANT_A) +
+		!!((mask) & ANT_B) +
+		!!((mask) & ANT_C);
+}
 
 static inline u8 iwl4965_get_prev_ieee_rate(u8 rate_index)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 91cc03f..2c5bfa4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -58,7 +58,8 @@ static void iwl4965_hw_card_show_info(struct iwl_priv *priv);
 #define IWL_DECLARE_RATE_INFO(r, s, ip, in, rp, rn, pp, np)    \
 	[IWL_RATE_##r##M_INDEX] = { IWL_RATE_##r##M_PLCP,      \
 				    IWL_RATE_SISO_##s##M_PLCP, \
-				    IWL_RATE_MIMO_##s##M_PLCP, \
+				    IWL_RATE_MIMO2_##s##M_PLCP,\
+				    IWL_RATE_MIMO3_##s##M_PLCP,\
 				    IWL_RATE_##r##M_IEEE,      \
 				    IWL_RATE_##ip##M_INDEX,    \
 				    IWL_RATE_##in##M_INDEX,    \
@@ -89,6 +90,7 @@ const struct iwl4965_rate_info iwl4965_rates[IWL_RATE_COUNT] = {
 	IWL_DECLARE_RATE_INFO(48, 48, 36, 54, 36, 54, 36, 54),   /* 48mbps */
 	IWL_DECLARE_RATE_INFO(54, 54, 48, INV, 48, INV, 48, INV),/* 54mbps */
 	IWL_DECLARE_RATE_INFO(60, 60, 48, INV, 48, INV, 48, INV),/* 60mbps */
+	/* FIXME:RS:          ^^    should be INV (legacy) */
 };
 
 #ifdef CONFIG_IWL4965_HT
@@ -265,7 +267,6 @@ static int iwl4965_init_drv(struct iwl_priv *priv)
 	int ret;
 	int i;
 
-	priv->antenna = (enum iwl4965_antenna)priv->cfg->mod_params->antenna;
 	priv->retry_rate = 1;
 	priv->ibss_beacon = NULL;
 
@@ -305,7 +306,6 @@ static int iwl4965_init_drv(struct iwl_priv *priv)
 	priv->iw_mode = IEEE80211_IF_TYPE_STA;
 
 	priv->use_ant_b_for_management_frame = 1; /* start with ant B */
-	priv->valid_antenna = 0x7;	/* assume all 3 connected */
 	priv->ps_mode = IWL_MIMO_PS_NONE;
 
 	/* Choose which receivers/antennas to use */
@@ -361,18 +361,20 @@ static int is_fat_channel(__le32 rxon_flags)
 		(rxon_flags & RXON_FLG_CHANNEL_MODE_MIXED_MSK);
 }
 
-static u8 is_single_stream(struct iwl_priv *priv)
-{
 #ifdef CONFIG_IWL4965_HT
-	if (!priv->current_ht_config.is_ht ||
-	    (priv->current_ht_config.supp_mcs_set[1] == 0) ||
-	    (priv->ps_mode == IWL_MIMO_PS_STATIC))
-		return 1;
+static u8 is_single_rx_stream(struct iwl_priv *priv)
+{
+	return !priv->current_ht_config.is_ht ||
+	       ((priv->current_ht_config.supp_mcs_set[1] == 0) &&
+		(priv->current_ht_config.supp_mcs_set[2] == 0)) ||
+	       priv->ps_mode == IWL_MIMO_PS_STATIC;
+}
 #else
+static inline u8 is_single_rx_stream(struct iwl_priv *priv)
+{
 	return 1;
-#endif	/*CONFIG_IWL4965_HT */
-	return 0;
 }
+#endif	/*CONFIG_IWL4965_HT */
 
 int iwl4965_hwrate_to_plcp_idx(u32 rate_n_flags)
 {
@@ -382,8 +384,8 @@ int iwl4965_hwrate_to_plcp_idx(u32 rate_n_flags)
 	if (rate_n_flags & RATE_MCS_HT_MSK) {
 		idx = (rate_n_flags & 0xff);
 
-		if (idx >= IWL_RATE_MIMO_6M_PLCP)
-			idx = idx - IWL_RATE_MIMO_6M_PLCP;
+		if (idx >= IWL_RATE_MIMO2_6M_PLCP)
+			idx = idx - IWL_RATE_MIMO2_6M_PLCP;
 
 		idx += IWL_FIRST_OFDM_RATE;
 		/* skip 9M not supported in ht*/
@@ -411,7 +413,7 @@ void iwl4965_hwrate_to_tx_control(struct iwl_priv *priv, u32 rate_n_flags,
 	int rate_index;
 
 	control->antenna_sel_tx =
-		((rate_n_flags & RATE_MCS_ANT_AB_MSK) >> RATE_MCS_ANT_POS);
+		((rate_n_flags & RATE_MCS_ANT_ABC_MSK) >> RATE_MCS_ANT_POS);
 	if (rate_n_flags & RATE_MCS_HT_MSK)
 		control->flags |= IEEE80211_TXCTL_OFDM_HT;
 	if (rate_n_flags & RATE_MCS_GF_MSK)
@@ -441,7 +443,7 @@ void iwl4965_hwrate_to_tx_control(struct iwl_priv *priv, u32 rate_n_flags,
 static int iwl4965_get_rx_chain_counter(struct iwl_priv *priv,
 					u8 *idle_state, u8 *rx_state)
 {
-	u8 is_single = is_single_stream(priv);
+	u8 is_single = is_single_rx_stream(priv);
 	u8 is_cam = test_bit(STATUS_POWER_PMI, &priv->status) ? 0 : 1;
 
 	/* # of Rx chains to use when expecting MIMO. */
@@ -1344,8 +1346,8 @@ int iwl4965_hw_set_hw_params(struct iwl_priv *priv)
 
 	priv->hw_params.tx_chains_num = 2;
 	priv->hw_params.rx_chains_num = 2;
-	priv->hw_params.valid_tx_ant = (IWL_ANTENNA_MAIN | IWL_ANTENNA_AUX);
-	priv->hw_params.valid_rx_ant = (IWL_ANTENNA_MAIN | IWL_ANTENNA_AUX);
+	priv->hw_params.valid_tx_ant = ANT_A | ANT_B;
+	priv->hw_params.valid_rx_ant = ANT_A | ANT_B;
 	priv->hw_params.ct_kill_threshold = CELSIUS_TO_KELVIN(CT_KILL_THRESHOLD);
 
 #ifdef CONFIG_IWL4965_RUN_TIME_CALIB
@@ -2512,7 +2514,7 @@ static void iwl4965_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
  */
 void iwl4965_set_rxon_chain(struct iwl_priv *priv)
 {
-	u8 is_single = is_single_stream(priv);
+	u8 is_single = is_single_rx_stream(priv);
 	u8 idle_state, rx_state;
 
 	priv->staging_rxon.rx_chain = 0;
@@ -2523,7 +2525,8 @@ void iwl4965_set_rxon_chain(struct iwl_priv *priv)
 	 * Just after first association, iwl_chain_noise_calibration()
 	 *    checks which antennas actually *are* connected. */
 	priv->staging_rxon.rx_chain |=
-	    cpu_to_le16(priv->valid_antenna << RXON_RX_CHAIN_VALID_POS);
+		    cpu_to_le16(priv->hw_params.valid_rx_ant <<
+						 RXON_RX_CHAIN_VALID_POS);
 
 	/* How many receivers should we use? */
 	iwl4965_get_rx_chain_counter(priv, &idle_state, &rx_state);
@@ -3106,7 +3109,7 @@ static int iwl4965_calc_rssi(struct iwl4965_rx_phy_res *rx_resp)
 
 #ifdef CONFIG_IWL4965_HT
 
-void iwl4965_init_ht_hw_capab(struct iwl_priv *priv,
+void iwl4965_init_ht_hw_capab(const struct iwl_priv *priv,
 			      struct ieee80211_ht_info *ht_info,
 			      enum ieee80211_band band)
 {
@@ -3132,7 +3135,10 @@ void iwl4965_init_ht_hw_capab(struct iwl_priv *priv,
 	ht_info->ampdu_density = CFG_HT_MPDU_DENSITY_DEF;
 
 	ht_info->supp_mcs_set[0] = 0xFF;
-	ht_info->supp_mcs_set[1] = 0xFF;
+	if (priv->hw_params.tx_chains_num >= 2)
+		ht_info->supp_mcs_set[1] = 0xFF;
+	if (priv->hw_params.tx_chains_num >= 3)
+		ht_info->supp_mcs_set[2] = 0xFF;
 }
 #endif /* CONFIG_IWL4965_HT */
 
@@ -3910,8 +3916,7 @@ void iwl4965_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
 			rate_flags |= RATE_MCS_CCK_MSK;
 
 		/* Use Tx antenna B only */
-		rate_flags |= RATE_MCS_ANT_B_MSK;
-		rate_flags &= ~RATE_MCS_ANT_A_MSK;
+		rate_flags |= RATE_MCS_ANT_B_MSK; /*FIXME:RS*/
 
 		link_cmd.rs_table[i].rate_n_flags =
 			iwl4965_hw_set_rate_n_flags(iwl4965_rates[r].plcp, rate_flags);
@@ -4016,11 +4021,13 @@ void iwl4965_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_info *ht_info)
 
 	iwl4965_set_rxon_chain(priv);
 
-	IWL_DEBUG_ASSOC("supported HT rate 0x%X %X "
+	IWL_DEBUG_ASSOC("supported HT rate 0x%X 0x%X 0x%X "
 			"rxon flags 0x%X operation mode :0x%X "
 			"extension channel offset 0x%x "
 			"control chan %d\n",
-			ht_info->supp_mcs_set[0], ht_info->supp_mcs_set[1],
+			ht_info->supp_mcs_set[0],
+			ht_info->supp_mcs_set[1],
+			ht_info->supp_mcs_set[2],
 			le32_to_cpu(rxon->flags), ht_info->ht_protection,
 			ht_info->extension_chan_offset,
 			ht_info->control_channel);
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 07209f8..6df51cc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -71,12 +71,6 @@ extern struct iwl_cfg iwl4965_agn_cfg;
  *   averages within an s8's (used in some apps) range of negative values. */
 #define IWL_NOISE_MEAS_NOT_AVAILABLE (-127)
 
-enum iwl4965_antenna {
-	IWL_ANTENNA_DIVERSITY,
-	IWL_ANTENNA_MAIN,
-	IWL_ANTENNA_AUX
-};
-
 /*
  * RTS threshold here is total size [2347] minus 4 FCS bytes
  * Per spec:
@@ -763,9 +757,9 @@ extern void iwl4965_hwrate_to_tx_control(struct iwl_priv *priv,
 					 struct ieee80211_tx_control *control);
 
 #ifdef CONFIG_IWL4965_HT
-void iwl4965_init_ht_hw_capab(struct iwl_priv *priv,
-			      struct ieee80211_ht_info *ht_info,
-			      enum ieee80211_band band);
+extern void iwl4965_init_ht_hw_capab(const struct iwl_priv *priv,
+				struct ieee80211_ht_info *ht_info,
+				enum ieee80211_band band);
 void iwl4965_set_rxon_ht(struct iwl_priv *priv,
 			 struct iwl_ht_info *ht_info);
 void iwl4965_set_ht_add_station(struct iwl_priv *priv, u8 index,
@@ -776,7 +770,7 @@ int iwl4965_mac_ampdu_action(struct ieee80211_hw *hw,
 int iwl4965_check_empty_hw_queue(struct iwl_priv *priv, int sta_id,
 					u8 tid, int txq_id);
 #else
-static inline void iwl4965_init_ht_hw_capab(struct iwl_priv *priv,
+static inline void iwl4965_init_ht_hw_capab(const struct iwl_priv *priv,
 					    struct ieee80211_ht_info *ht_info,
 					    enum ieee80211_band band) {}
 
@@ -1052,7 +1046,6 @@ struct iwl_priv {
 
 	u8 assoc_station_added;
 	u8 use_ant_b_for_management_frame;	/* Tx antenna selection */
-	u8 valid_antenna;	/* Bit mask of antennas actually connected */
 	u8 start_calib;
 #ifdef CONFIG_IWLWIFI_RUN_TIME_CALIB
 	struct iwl_sensitivity_data sensitivity_data;
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.c b/drivers/net/wireless/iwlwifi/iwl-calib.c
index 16213b0..59bbd7c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.c
@@ -747,7 +747,8 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv,
 			active_chains);
 
 	/* Save for use within RXON, TX, SCAN commands, etc. */
-	priv->valid_antenna = active_chains;
+	/*priv->valid_antenna = active_chains;*/
+	/*FIXME: should be reflected in RX chains in RXON */
 
 	/* Analyze noise for rx balance */
 	average_noise[0] = ((data->chain_noise_a)/CAL_NUM_OF_BEACONS);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 7710460..6842de8 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -7243,44 +7243,6 @@ static ssize_t show_statistics(struct device *d,
 
 static DEVICE_ATTR(statistics, S_IRUGO, show_statistics, NULL);
 
-static ssize_t show_antenna(struct device *d,
-			    struct device_attribute *attr, char *buf)
-{
-	struct iwl_priv *priv = dev_get_drvdata(d);
-
-	if (!iwl_is_alive(priv))
-		return -EAGAIN;
-
-	return sprintf(buf, "%d\n", priv->antenna);
-}
-
-static ssize_t store_antenna(struct device *d,
-			     struct device_attribute *attr,
-			     const char *buf, size_t count)
-{
-	int ant;
-	struct iwl_priv *priv = dev_get_drvdata(d);
-
-	if (count == 0)
-		return 0;
-
-	if (sscanf(buf, "%1i", &ant) != 1) {
-		IWL_DEBUG_INFO("not in hex or decimal form.\n");
-		return count;
-	}
-
-	if ((ant >= 0) && (ant <= 2)) {
-		IWL_DEBUG_INFO("Setting antenna select to %d.\n", ant);
-		priv->antenna = (enum iwl4965_antenna)ant;
-	} else
-		IWL_DEBUG_INFO("Bad antenna select value %d.\n", ant);
-
-
-	return count;
-}
-
-static DEVICE_ATTR(antenna, S_IWUSR | S_IRUGO, show_antenna, store_antenna);
-
 static ssize_t show_status(struct device *d,
 			   struct device_attribute *attr, char *buf)
 {
@@ -7363,7 +7325,6 @@ static void iwl4965_cancel_deferred_work(struct iwl_priv *priv)
 }
 
 static struct attribute *iwl4965_sysfs_entries[] = {
-	&dev_attr_antenna.attr,
 	&dev_attr_channels.attr,
 	&dev_attr_dump_errors.attr,
 	&dev_attr_dump_events.attr,
-- 
1.5.3.4

