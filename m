Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43142 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958Ab3BKMiZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 07:38:25 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 02/14] mac80211: stop toggling IEEE80211_HT_CAP_SUP_WIDTH_20_40
Date: Mon, 11 Feb 2013 13:38:06 +0100
Message-Id: <1360586298-15028-3-git-send-email-johannes@sipsolutions.net> (sfid-20130211_134231_751487_0141AC1A)
In-Reply-To: <1360586298-15028-1-git-send-email-johannes@sipsolutions.net>
References: <[PATCH 00/14] mac80211: HT/VHT handling>
 <1360586298-15028-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For VHT, many more bandwidth changes are possible. As a first
step, stop toggling the IEEE80211_HT_CAP_SUP_WIDTH_20_40 flag
in the HT capabilities and instead introduce a bandwidth field
indicating the currently usable bandwidth to transmit to the
station. Of course, make all drivers use it.

To achieve this, make ieee80211_ht_cap_ie_to_sta_ht_cap() get
the station as an argument, rather than the new capabilities,
so it can set up the new bandwidth field.

If the station is a VHT station and VHT bandwidth is in use,
also set the bandwidth accordingly.

Doing this allows us to get rid of the supports_40mhz flag as
the HT capabilities now reflect the true capability instead of
the current setting.

While at it, also fix ieee80211_ht_cap_ie_to_sta_ht_cap() to not
ignore HT cap overrides when MCS TX isn't supported (not that it
really happens...)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath9k/rc.c          |  2 +-
 drivers/net/wireless/iwlwifi/dvm/agn.h       |  2 +-
 drivers/net/wireless/iwlwifi/dvm/rs.c        |  6 +-
 drivers/net/wireless/iwlwifi/dvm/sta.c       | 19 ++-----
 drivers/net/wireless/iwlwifi/mvm/rs.c        | 24 ++------
 drivers/net/wireless/rtlwifi/base.c          |  7 +--
 drivers/net/wireless/rtlwifi/rc.c            |  5 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c  |  6 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c |  3 +-
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c  |  3 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c |  3 +-
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c  |  3 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c |  3 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c  |  3 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/trx.c |  3 +-
 drivers/net/wireless/ti/wl18xx/main.c        |  2 +-
 include/net/mac80211.h                       | 24 +++++++-
 net/mac80211/cfg.c                           |  3 +-
 net/mac80211/ht.c                            | 82 +++++++++++++++++-----------
 net/mac80211/ibss.c                          | 23 +++-----
 net/mac80211/ieee80211_i.h                   |  5 +-
 net/mac80211/mesh_plink.c                    |  6 +-
 net/mac80211/mlme.c                          | 22 ++++----
 net/mac80211/rc80211_minstrel_ht.c           | 19 +++----
 net/mac80211/rx.c                            | 21 +++----
 net/mac80211/sta_info.h                      |  4 --
 net/mac80211/vht.c                           | 39 +++++++++++++
 27 files changed, 184 insertions(+), 158 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 714558d..54150b6 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1204,7 +1204,7 @@ static u8 ath_rc_build_ht_caps(struct ath_softc *sc, struct ieee80211_sta *sta)
 			caps |= WLAN_RC_TS_FLAG | WLAN_RC_DS_FLAG;
 		else if (sta->ht_cap.mcs.rx_mask[1])
 			caps |= WLAN_RC_DS_FLAG;
-		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) {
+		if (sta->bandwidth >= IEEE80211_STA_RX_BW_40) {
 			caps |= WLAN_RC_40_FLAG;
 			if (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40)
 				caps |= WLAN_RC_SGI_FLAG;
diff --git a/drivers/net/wireless/iwlwifi/dvm/agn.h b/drivers/net/wireless/iwlwifi/dvm/agn.h
index f41ae79..41ec27c 100644
--- a/drivers/net/wireless/iwlwifi/dvm/agn.h
+++ b/drivers/net/wireless/iwlwifi/dvm/agn.h
@@ -338,7 +338,7 @@ int iwl_sta_update_ht(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 
 bool iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
 			    struct iwl_rxon_context *ctx,
-			    struct ieee80211_sta_ht_cap *ht_cap);
+			    struct ieee80211_sta *sta);
 
 static inline int iwl_sta_id(struct ieee80211_sta *sta)
 {
diff --git a/drivers/net/wireless/iwlwifi/dvm/rs.c b/drivers/net/wireless/iwlwifi/dvm/rs.c
index a131227..b25de02 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rs.c
@@ -1305,7 +1305,7 @@ static int rs_switch_to_mimo2(struct iwl_priv *priv,
 	tbl->max_search = IWL_MAX_SEARCH;
 	rate_mask = lq_sta->active_mimo2_rate;
 
-	if (iwl_is_ht40_tx_allowed(priv, ctx, &sta->ht_cap))
+	if (iwl_is_ht40_tx_allowed(priv, ctx, sta))
 		tbl->is_ht40 = 1;
 	else
 		tbl->is_ht40 = 0;
@@ -1361,7 +1361,7 @@ static int rs_switch_to_mimo3(struct iwl_priv *priv,
 	tbl->max_search = IWL_MAX_11N_MIMO3_SEARCH;
 	rate_mask = lq_sta->active_mimo3_rate;
 
-	if (iwl_is_ht40_tx_allowed(priv, ctx, &sta->ht_cap))
+	if (iwl_is_ht40_tx_allowed(priv, ctx, sta))
 		tbl->is_ht40 = 1;
 	else
 		tbl->is_ht40 = 0;
@@ -1410,7 +1410,7 @@ static int rs_switch_to_siso(struct iwl_priv *priv,
 	tbl->max_search = IWL_MAX_SEARCH;
 	rate_mask = lq_sta->active_siso_rate;
 
-	if (iwl_is_ht40_tx_allowed(priv, ctx, &sta->ht_cap))
+	if (iwl_is_ht40_tx_allowed(priv, ctx, sta))
 		tbl->is_ht40 = 1;
 	else
 		tbl->is_ht40 = 0;
diff --git a/drivers/net/wireless/iwlwifi/dvm/sta.c b/drivers/net/wireless/iwlwifi/dvm/sta.c
index ab76804..6deab38 100644
--- a/drivers/net/wireless/iwlwifi/dvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/dvm/sta.c
@@ -173,7 +173,7 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 
 bool iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
 			    struct iwl_rxon_context *ctx,
-			    struct ieee80211_sta_ht_cap *ht_cap)
+			    struct ieee80211_sta *sta)
 {
 	if (!ctx->ht.enabled || !ctx->ht.is_40mhz)
 		return false;
@@ -183,20 +183,11 @@ bool iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
 		return false;
 #endif
 
-	/*
-	 * Remainder of this function checks ht_cap, but if it's
-	 * NULL then we can do HT40 (special case for RXON)
-	 */
-	if (!ht_cap)
+	/* special case for RXON */
+	if (!sta)
 		return true;
 
-	if (!ht_cap->ht_supported)
-		return false;
-
-	if (!(ht_cap->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40))
-		return false;
-
-	return true;
+	return sta->bandwidth >= IEEE80211_STA_RX_BW_40;
 }
 
 static void iwl_sta_calc_ht_flags(struct iwl_priv *priv,
@@ -246,7 +237,7 @@ static void iwl_sta_calc_ht_flags(struct iwl_priv *priv,
 	*flags |= cpu_to_le32(
 		(u32)sta_ht_inf->ampdu_density << STA_FLG_AGG_MPDU_DENSITY_POS);
 
-	if (iwl_is_ht40_tx_allowed(priv, ctx, &sta->ht_cap))
+	if (iwl_is_ht40_tx_allowed(priv, ctx, sta))
 		*flags |= STA_FLG_HT40_EN_MSK;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 60a4291..8ba36e5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -1209,23 +1209,9 @@ static s32 rs_get_best_rate(struct iwl_mvm *mvm,
 	return new_rate;
 }
 
-static bool iwl_is_ht40_tx_allowed(struct iwl_mvm *mvm,
-			    struct ieee80211_sta_ht_cap *ht_cap)
+static bool iwl_is_ht40_tx_allowed(struct ieee80211_sta *sta)
 {
-	/*
-	 * Remainder of this function checks ht_cap, but if it's
-	 * NULL then we can do HT40 (special case for RXON)
-	 */
-	if (!ht_cap)
-		return true;
-
-	if (!ht_cap->ht_supported)
-		return false;
-
-	if (!(ht_cap->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40))
-		return false;
-
-	return true;
+	return sta->bandwidth >= IEEE80211_STA_RX_BW_40;
 }
 
 /*
@@ -1258,7 +1244,7 @@ static int rs_switch_to_mimo2(struct iwl_mvm *mvm,
 	tbl->max_search = IWL_MAX_SEARCH;
 	rate_mask = lq_sta->active_mimo2_rate;
 
-	if (iwl_is_ht40_tx_allowed(mvm, &sta->ht_cap))
+	if (iwl_is_ht40_tx_allowed(sta))
 		tbl->is_ht40 = 1;
 	else
 		tbl->is_ht40 = 0;
@@ -1311,7 +1297,7 @@ static int rs_switch_to_mimo3(struct iwl_mvm *mvm,
 	tbl->max_search = IWL_MAX_11N_MIMO3_SEARCH;
 	rate_mask = lq_sta->active_mimo3_rate;
 
-	if (iwl_is_ht40_tx_allowed(mvm, &sta->ht_cap))
+	if (iwl_is_ht40_tx_allowed(sta))
 		tbl->is_ht40 = 1;
 	else
 		tbl->is_ht40 = 0;
@@ -1356,7 +1342,7 @@ static int rs_switch_to_siso(struct iwl_mvm *mvm,
 	tbl->max_search = IWL_MAX_SEARCH;
 	rate_mask = lq_sta->active_siso_rate;
 
-	if (iwl_is_ht40_tx_allowed(mvm, &sta->ht_cap))
+	if (iwl_is_ht40_tx_allowed(sta))
 		tbl->is_ht40 = 1;
 	else
 		tbl->is_ht40 = 0;
diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
index 4494d13..84ea04d 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -523,8 +523,8 @@ static void _rtl_query_shortgi(struct ieee80211_hw *hw,
 	if (mac->opmode == NL80211_IFTYPE_STATION)
 		bw_40 = mac->bw_40;
 	else if (mac->opmode == NL80211_IFTYPE_AP ||
-		mac->opmode == NL80211_IFTYPE_ADHOC)
-		bw_40 = sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+		 mac->opmode == NL80211_IFTYPE_ADHOC)
+		bw_40 = sta->bandwidth >= IEEE80211_STA_RX_BW_40;
 
 	if (bw_40 && sgi_40)
 		tcb_desc->use_shortgi = true;
@@ -634,8 +634,7 @@ static void _rtl_query_bandwidth_mode(struct ieee80211_hw *hw,
 		return;
 	if (mac->opmode == NL80211_IFTYPE_AP ||
 	    mac->opmode == NL80211_IFTYPE_ADHOC) {
-		if (!(sta->ht_cap.ht_supported) ||
-		    !(sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40))
+		if (sta->bandwidth == IEEE80211_STA_RX_BW_20)
 			return;
 	} else if (mac->opmode == NL80211_IFTYPE_STATION) {
 		if (!mac->bw_40 || !(sta->ht_cap.ht_supported))
diff --git a/drivers/net/wireless/rtlwifi/rc.c b/drivers/net/wireless/rtlwifi/rc.c
index 204f46c..c12a866 100644
--- a/drivers/net/wireless/rtlwifi/rc.c
+++ b/drivers/net/wireless/rtlwifi/rc.c
@@ -116,9 +116,8 @@ static void _rtl_rc_rate_set_series(struct rtl_priv *rtlpriv,
 		if (txrc->short_preamble)
 			rate->flags |= IEEE80211_TX_RC_USE_SHORT_PREAMBLE;
 		if (mac->opmode == NL80211_IFTYPE_AP ||
-			mac->opmode == NL80211_IFTYPE_ADHOC) {
-			if (sta && (sta->ht_cap.cap &
-			    IEEE80211_HT_CAP_SUP_WIDTH_20_40))
+		    mac->opmode == NL80211_IFTYPE_ADHOC) {
+			if (sta && (sta->bandwidth >= IEEE80211_STA_RX_BW_40))
 				rate->flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
 		} else {
 			if (mac->bw_40)
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
index d1f34f6..1b65db7 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -1846,9 +1846,9 @@ static void rtl92ce_update_hal_rate_mask(struct ieee80211_hw *hw,
 	struct rtl_sta_info *sta_entry = NULL;
 	u32 ratr_bitmap;
 	u8 ratr_index;
-	u8 curtxbw_40mhz = (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
-				? 1 : 0;
-	u8 curshortgi_40mhz = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40) ?
+	u8 curtxbw_40mhz = (sta->bandwidth >= IEEE80211_STA_RX_BW_40) ? 1 : 0;
+	u8 curshortgi_40mhz = curtxbw_40mhz &&
+			      (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40) ?
 				1 : 0;
 	u8 curshortgi_20mhz = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20) ?
 				1 : 0;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
index c31795e..82479dd 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
@@ -626,8 +626,7 @@ void rtl92ce_tx_fill_desc(struct ieee80211_hw *hw,
 	} else if (mac->opmode == NL80211_IFTYPE_AP ||
 		mac->opmode == NL80211_IFTYPE_ADHOC) {
 		if (sta)
-			bw_40 = sta->ht_cap.cap &
-				IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+			bw_40 = sta->bandwidth >= IEEE80211_STA_RX_BW_40;
 	}
 
 	seq_number = (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ) >> 4;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
index f4051f4..aa5b425 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
@@ -1970,8 +1970,7 @@ static void rtl92de_update_hal_rate_mask(struct ieee80211_hw *hw,
 	struct rtl_sta_info *sta_entry = NULL;
 	u32 ratr_bitmap;
 	u8 ratr_index;
-	u8 curtxbw_40mhz = (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
-							? 1 : 0;
+	u8 curtxbw_40mhz = (sta->bandwidth >= IEEE80211_STA_RX_BW_40) ? 1 : 0;
 	u8 curshortgi_40mhz = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40) ?
 							1 : 0;
 	u8 curshortgi_20mhz = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20) ?
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/trx.c b/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
index cdb570f..941080e 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
@@ -574,8 +574,7 @@ void rtl92de_tx_fill_desc(struct ieee80211_hw *hw,
 	} else if (mac->opmode == NL80211_IFTYPE_AP ||
 		mac->opmode == NL80211_IFTYPE_ADHOC) {
 		if (sta)
-			bw_40 = sta->ht_cap.cap &
-				IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+			bw_40 = sta->bandwidth >= IEEE80211_STA_RX_BW_40;
 	}
 	seq_number = (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ) >> 4;
 	rtl_get_tcb_desc(hw, info, sta, skb, ptcb_desc);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
index 28526a7..084e777 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
@@ -2085,8 +2085,7 @@ static void rtl92se_update_hal_rate_mask(struct ieee80211_hw *hw,
 	struct rtl_sta_info *sta_entry = NULL;
 	u32 ratr_bitmap;
 	u8 ratr_index = 0;
-	u8 curtxbw_40mhz = (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
-				? 1 : 0;
+	u8 curtxbw_40mhz = (sta->bandwidth >= IEEE80211_STA_RX_BW_40) ? 1 : 0;
 	u8 curshortgi_40mhz = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40) ?
 				1 : 0;
 	u8 curshortgi_20mhz = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20) ?
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
index f8431a3..7b0a2e7 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
@@ -621,8 +621,7 @@ void rtl92se_tx_fill_desc(struct ieee80211_hw *hw,
 	} else if (mac->opmode == NL80211_IFTYPE_AP ||
 		mac->opmode == NL80211_IFTYPE_ADHOC) {
 		if (sta)
-			bw_40 = sta->ht_cap.cap &
-				    IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+			bw_40 = sta->bandwidth >= IEEE80211_STA_RX_BW_40;
 	}
 
 	seq_number = (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ) >> 4;
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c b/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
index 1498048..9a0c71c 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/hw.c
@@ -1866,8 +1866,7 @@ static void rtl8723ae_update_hal_rate_mask(struct ieee80211_hw *hw,
 	struct rtl_sta_info *sta_entry = NULL;
 	u32 ratr_bitmap;
 	u8 ratr_index;
-	u8 curtxbw_40mhz = (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
-				? 1 : 0;
+	u8 curtxbw_40mhz = (sta->bandwidth >= IEEE80211_STA_RX_BW_40) ? 1 : 0;
 	u8 curshortgi_40mhz = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40) ?
 				1 : 0;
 	u8 curshortgi_20mhz = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20) ?
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c b/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c
index b1fd2b3..ac08129 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c
@@ -395,8 +395,7 @@ void rtl8723ae_tx_fill_desc(struct ieee80211_hw *hw,
 	} else if (mac->opmode == NL80211_IFTYPE_AP ||
 		mac->opmode == NL80211_IFTYPE_ADHOC) {
 		if (sta)
-			bw_40 = sta->ht_cap.cap &
-				IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+			bw_40 = sta->bandwidth >= IEEE80211_STA_RX_BW_40;
 	}
 
 	seq_number = (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ) >> 4;
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 0be1cfc..227ebfd 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1369,7 +1369,7 @@ static void wl18xx_sta_rc_update(struct wl1271 *wl,
 				 struct ieee80211_sta *sta,
 				 u32 changed)
 {
-	bool wide = sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+	bool wide = sta->bandwidth >= IEEE80211_STA_RX_BW_40;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 sta_rc_update wide %d", wide);
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 86ad2c3..6a2290b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1186,6 +1186,24 @@ enum ieee80211_sta_state {
 };
 
 /**
+ * enum ieee80211_sta_rx_bandwidth - station RX bandwidth
+ * @IEEE80211_STA_RX_BW_20: station can only receive 20 MHz
+ * @IEEE80211_STA_RX_BW_40: station can receive up to 40 MHz
+ * @IEEE80211_STA_RX_BW_80: station can receive up to 80 MHz
+ * @IEEE80211_STA_RX_BW_160: station can receive up to 160 MHz
+ *	(including 80+80 MHz)
+ *
+ * Implementation note: 20 must be zero to be initialized
+ *	correctly, the values must be sorted.
+ */
+enum ieee80211_sta_rx_bandwidth {
+	IEEE80211_STA_RX_BW_20 = 0,
+	IEEE80211_STA_RX_BW_40,
+	IEEE80211_STA_RX_BW_80,
+	IEEE80211_STA_RX_BW_160,
+};
+
+/**
  * struct ieee80211_sta - station table entry
  *
  * A station table entry represents a station we are possibly
@@ -1207,6 +1225,7 @@ enum ieee80211_sta_state {
  * @uapsd_queues: bitmap of queues configured for uapsd. Only valid
  *	if wme is supported.
  * @max_sp: max Service Period. Only valid if wme is supported.
+ * @bandwidth: current bandwidth the station can receive with
  */
 struct ieee80211_sta {
 	u32 supp_rates[IEEE80211_NUM_BANDS];
@@ -1217,6 +1236,7 @@ struct ieee80211_sta {
 	bool wme;
 	u8 uapsd_queues;
 	u8 max_sp;
+	enum ieee80211_sta_rx_bandwidth bandwidth;
 
 	/* must be last */
 	u8 drv_priv[0] __aligned(sizeof(void *));
@@ -2075,7 +2095,9 @@ enum ieee80211_frame_release_type {
  * enum ieee80211_rate_control_changed - flags to indicate what changed
  *
  * @IEEE80211_RC_BW_CHANGED: The bandwidth that can be used to transmit
- *	to this station changed.
+ *	to this station changed. The actual bandwidth is in the station
+ *	information -- for HT20/40 the IEEE80211_HT_CAP_SUP_WIDTH_20_40
+ *	flag changes, for HT and VHT the bandwidth field changes.
  * @IEEE80211_RC_SMPS_CHANGED: The SMPS state of the station changed.
  * @IEEE80211_RC_SUPP_RATES_CHANGED: The supported rate set of this peer
  *	changed (in IBSS mode) due to discovering more information about
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 8f3e3a2..68eca17 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1251,8 +1251,7 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 
 	if (params->ht_capa)
 		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
-						  params->ht_capa,
-						  &sta->sta.ht_cap);
+						  params->ht_capa, sta);
 
 	if (params->vht_capa)
 		ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband,
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 9e7560b..a64b4f0 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -37,6 +37,9 @@ void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
 	u8 *smask = (u8 *)(&sdata->u.mgd.ht_capa_mask.mcs.rx_mask);
 	int i;
 
+	if (!ht_cap->ht_supported)
+		return;
+
 	if (sdata->vif.type != NL80211_IFTYPE_STATION) {
 		/* AP interfaces call this code when adding new stations,
 		 * so just silently ignore non station interfaces.
@@ -89,22 +92,23 @@ void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
 }
 
 
-void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
+bool ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 				       struct ieee80211_supported_band *sband,
 				       struct ieee80211_ht_cap *ht_cap_ie,
-				       struct ieee80211_sta_ht_cap *ht_cap)
+				       struct sta_info *sta)
 {
+	struct ieee80211_sta_ht_cap ht_cap;
 	u8 ampdu_info, tx_mcs_set_cap;
 	int i, max_tx_streams;
+	bool changed;
+	enum ieee80211_sta_rx_bandwidth bw;
 
-	BUG_ON(!ht_cap);
-
-	memset(ht_cap, 0, sizeof(*ht_cap));
+	memset(&ht_cap, 0, sizeof(ht_cap));
 
 	if (!ht_cap_ie || !sband->ht_cap.ht_supported)
-		return;
+		goto apply;
 
-	ht_cap->ht_supported = true;
+	ht_cap.ht_supported = true;
 
 	/*
 	 * The bits listed in this expression should be
@@ -112,7 +116,7 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 	 * advertises more then we can't use those thus
 	 * we mask them out.
 	 */
-	ht_cap->cap = le16_to_cpu(ht_cap_ie->cap_info) &
+	ht_cap.cap = le16_to_cpu(ht_cap_ie->cap_info) &
 		(sband->ht_cap.cap |
 		 ~(IEEE80211_HT_CAP_LDPC_CODING |
 		   IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
@@ -121,44 +125,30 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 		   IEEE80211_HT_CAP_SGI_40 |
 		   IEEE80211_HT_CAP_DSSSCCK40));
 
-	/* Unset 40 MHz if we're not using a 40 MHz channel */
-	switch (sdata->vif.bss_conf.chandef.width) {
-	case NL80211_CHAN_WIDTH_20_NOHT:
-	case NL80211_CHAN_WIDTH_20:
-		ht_cap->cap &= ~IEEE80211_HT_CAP_SGI_40;
-		ht_cap->cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
-		break;
-	case NL80211_CHAN_WIDTH_40:
-	case NL80211_CHAN_WIDTH_80:
-	case NL80211_CHAN_WIDTH_80P80:
-	case NL80211_CHAN_WIDTH_160:
-		break;
-	}
-
 	/*
 	 * The STBC bits are asymmetric -- if we don't have
 	 * TX then mask out the peer's RX and vice versa.
 	 */
 	if (!(sband->ht_cap.cap & IEEE80211_HT_CAP_TX_STBC))
-		ht_cap->cap &= ~IEEE80211_HT_CAP_RX_STBC;
+		ht_cap.cap &= ~IEEE80211_HT_CAP_RX_STBC;
 	if (!(sband->ht_cap.cap & IEEE80211_HT_CAP_RX_STBC))
-		ht_cap->cap &= ~IEEE80211_HT_CAP_TX_STBC;
+		ht_cap.cap &= ~IEEE80211_HT_CAP_TX_STBC;
 
 	ampdu_info = ht_cap_ie->ampdu_params_info;
-	ht_cap->ampdu_factor =
+	ht_cap.ampdu_factor =
 		ampdu_info & IEEE80211_HT_AMPDU_PARM_FACTOR;
-	ht_cap->ampdu_density =
+	ht_cap.ampdu_density =
 		(ampdu_info & IEEE80211_HT_AMPDU_PARM_DENSITY) >> 2;
 
 	/* own MCS TX capabilities */
 	tx_mcs_set_cap = sband->ht_cap.mcs.tx_params;
 
 	/* Copy peer MCS TX capabilities, the driver might need them. */
-	ht_cap->mcs.tx_params = ht_cap_ie->mcs.tx_params;
+	ht_cap.mcs.tx_params = ht_cap_ie->mcs.tx_params;
 
 	/* can we TX with MCS rates? */
 	if (!(tx_mcs_set_cap & IEEE80211_HT_MCS_TX_DEFINED))
-		return;
+		goto apply;
 
 	/* Counting from 0, therefore +1 */
 	if (tx_mcs_set_cap & IEEE80211_HT_MCS_TX_RX_DIFF)
@@ -176,25 +166,53 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 	 * - remainder are multiple spatial streams using unequal modulation
 	 */
 	for (i = 0; i < max_tx_streams; i++)
-		ht_cap->mcs.rx_mask[i] =
+		ht_cap.mcs.rx_mask[i] =
 			sband->ht_cap.mcs.rx_mask[i] & ht_cap_ie->mcs.rx_mask[i];
 
 	if (tx_mcs_set_cap & IEEE80211_HT_MCS_TX_UNEQUAL_MODULATION)
 		for (i = IEEE80211_HT_MCS_UNEQUAL_MODULATION_START_BYTE;
 		     i < IEEE80211_HT_MCS_MASK_LEN; i++)
-			ht_cap->mcs.rx_mask[i] =
+			ht_cap.mcs.rx_mask[i] =
 				sband->ht_cap.mcs.rx_mask[i] &
 					ht_cap_ie->mcs.rx_mask[i];
 
 	/* handle MCS rate 32 too */
 	if (sband->ht_cap.mcs.rx_mask[32/8] & ht_cap_ie->mcs.rx_mask[32/8] & 1)
-		ht_cap->mcs.rx_mask[32/8] |= 1;
+		ht_cap.mcs.rx_mask[32/8] |= 1;
 
+ apply:
 	/*
 	 * If user has specified capability over-rides, take care
 	 * of that here.
 	 */
-	ieee80211_apply_htcap_overrides(sdata, ht_cap);
+	ieee80211_apply_htcap_overrides(sdata, &ht_cap);
+
+	changed = memcmp(&sta->sta.ht_cap, &ht_cap, sizeof(ht_cap));
+
+	memcpy(&sta->sta.ht_cap, &ht_cap, sizeof(ht_cap));
+
+	switch (sdata->vif.bss_conf.chandef.width) {
+	default:
+		WARN_ON_ONCE(1);
+		/* fall through */
+	case NL80211_CHAN_WIDTH_20_NOHT:
+	case NL80211_CHAN_WIDTH_20:
+		bw = IEEE80211_STA_RX_BW_20;
+		break;
+	case NL80211_CHAN_WIDTH_40:
+	case NL80211_CHAN_WIDTH_80:
+	case NL80211_CHAN_WIDTH_80P80:
+	case NL80211_CHAN_WIDTH_160:
+		bw = ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40 ?
+				IEEE80211_STA_RX_BW_40 : IEEE80211_STA_RX_BW_20;
+		break;
+	}
+
+	if (bw != sta->sta.bandwidth)
+		changed = true;
+	sta->sta.bandwidth = bw;
+
+	return changed;
 }
 
 void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta,
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 2db1f2b..40b71df 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -496,33 +496,26 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		if (sta && elems->ht_operation && elems->ht_cap_elem &&
 		    sdata->u.ibss.channel_type != NL80211_CHAN_NO_HT) {
 			/* we both use HT */
-			struct ieee80211_sta_ht_cap sta_ht_cap_new;
+			struct ieee80211_ht_cap htcap_ie;
 			struct cfg80211_chan_def chandef;
 
 			ieee80211_ht_oper_to_chandef(channel,
 						     elems->ht_operation,
 						     &chandef);
 
-			ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
-							  elems->ht_cap_elem,
-							  &sta_ht_cap_new);
+			memcpy(&htcap_ie, elems->ht_cap_elem, sizeof(htcap_ie));
 
 			/*
 			 * fall back to HT20 if we don't use or use
 			 * the other extension channel
 			 */
-			if (chandef.width != NL80211_CHAN_WIDTH_40 ||
-			    cfg80211_get_chandef_type(&chandef) !=
+			if (cfg80211_get_chandef_type(&chandef) !=
 						sdata->u.ibss.channel_type)
-				sta_ht_cap_new.cap &=
-					~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
-
-			if (memcmp(&sta->sta.ht_cap, &sta_ht_cap_new,
-				   sizeof(sta_ht_cap_new))) {
-				memcpy(&sta->sta.ht_cap, &sta_ht_cap_new,
-				       sizeof(sta_ht_cap_new));
-				rates_updated = true;
-			}
+				htcap_ie.cap_info &=
+					cpu_to_le16(~IEEE80211_HT_CAP_SUP_WIDTH_20_40);
+
+			rates_updated |= ieee80211_ht_cap_ie_to_sta_ht_cap(
+						sdata, sband, &htcap_ie, sta);
 		}
 
 		if (sta && rates_updated) {
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2512124..fa122c0 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1373,10 +1373,10 @@ void ieee80211_purge_tx_queue(struct ieee80211_hw *hw,
 /* HT */
 void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_sta_ht_cap *ht_cap);
-void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
+bool ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 				       struct ieee80211_supported_band *sband,
 				       struct ieee80211_ht_cap *ht_cap_ie,
-				       struct ieee80211_sta_ht_cap *ht_cap);
+				       struct sta_info *sta);
 void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata,
 			  const u8 *da, u16 tid,
 			  u16 initiator, u16 reason_code);
@@ -1420,6 +1420,7 @@ void ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 					 struct ieee80211_supported_band *sband,
 					 struct ieee80211_vht_cap *vht_cap_ie,
 					 struct sta_info *sta);
+enum ieee80211_sta_rx_bandwidth ieee80211_sta_cur_vht_bw(struct sta_info *sta);
 
 /* Spectrum management */
 void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 56c9b31..d107265 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -373,8 +373,7 @@ static void mesh_sta_info_init(struct ieee80211_sub_if_data *sdata,
 	if (elems->ht_cap_elem &&
 	    sdata->vif.bss_conf.chandef.width != NL80211_CHAN_WIDTH_20_NOHT)
 		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
-						  elems->ht_cap_elem,
-						  &sta->sta.ht_cap);
+						  elems->ht_cap_elem, sta);
 	else
 		memset(&sta->sta.ht_cap, 0, sizeof(sta->sta.ht_cap));
 
@@ -383,8 +382,7 @@ static void mesh_sta_info_init(struct ieee80211_sub_if_data *sdata,
 
 		if (!(elems->ht_operation->ht_param &
 		      IEEE80211_HT_PARAM_CHAN_WIDTH_ANY))
-			sta->sta.ht_cap.cap &=
-					    ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+			sta->sta.bandwidth = IEEE80211_STA_RX_BW_20;
 		ieee80211_ht_oper_to_chandef(sdata->vif.bss_conf.chandef.chan,
 					     elems->ht_operation, &chandef);
 		if (sta->ch_width != chandef.width)
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index f1c8532..4487a55 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -219,19 +219,20 @@ static u32 ieee80211_config_ht_tx(struct ieee80211_sub_if_data *sdata,
 	mutex_lock(&local->sta_mtx);
 	sta = sta_info_get(sdata, bssid);
 
-	WARN_ON_ONCE(!sta);
+	if (WARN_ON_ONCE(!sta)) {
+		mutex_unlock(&local->sta_mtx);
+		return changed;
+	}
 
-	if (sta && !sta->supports_40mhz)
+	if (!(sta->sta.ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40))
 		disable_40 = true;
 
-	if (sta && (!reconfig ||
-		    (disable_40 != !(sta->sta.ht_cap.cap &
-					IEEE80211_HT_CAP_SUP_WIDTH_20_40)))) {
-
+	if (!reconfig ||
+	    disable_40 != (sta->sta.bandwidth < IEEE80211_STA_RX_BW_40)) {
 		if (disable_40)
-			sta->sta.ht_cap.cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+			sta->sta.bandwidth = IEEE80211_STA_RX_BW_20;
 		else
-			sta->sta.ht_cap.cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+			sta->sta.bandwidth = ieee80211_sta_cur_vht_bw(sta);
 
 		rate_control_rate_update(local, sband, sta,
 					 IEEE80211_RC_BW_CHANGED);
@@ -2193,10 +2194,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 
 	if (elems.ht_cap_elem && !(ifmgd->flags & IEEE80211_STA_DISABLE_HT))
 		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
-				elems.ht_cap_elem, &sta->sta.ht_cap);
-
-	sta->supports_40mhz =
-		sta->sta.ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+						  elems.ht_cap_elem, sta);
 
 	if (elems.vht_cap_elem && !(ifmgd->flags & IEEE80211_STA_DISABLE_VHT))
 		ieee80211_vht_cap_ie_to_sta_vht_cap(sdata, sband,
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 9f9c453..d239bd7 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -739,20 +739,19 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 		IEEE80211_HT_CAP_SM_PS_SHIFT;
 
 	for (i = 0; i < ARRAY_SIZE(mi->groups); i++) {
-		u16 req = 0;
-
 		mi->groups[i].supported = 0;
 		if (minstrel_mcs_groups[i].flags & IEEE80211_TX_RC_SHORT_GI) {
-			if (minstrel_mcs_groups[i].flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
-				req |= IEEE80211_HT_CAP_SGI_40;
-			else
-				req |= IEEE80211_HT_CAP_SGI_20;
+			if (minstrel_mcs_groups[i].flags & IEEE80211_TX_RC_40_MHZ_WIDTH) {
+				if (!(sta_cap & IEEE80211_HT_CAP_SGI_40))
+					continue;
+			} else {
+				if (!(sta_cap & IEEE80211_HT_CAP_SGI_20))
+					continue;
+			}
 		}
 
-		if (minstrel_mcs_groups[i].flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
-			req |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
-
-		if ((sta_cap & req) != req)
+		if (minstrel_mcs_groups[i].flags & IEEE80211_TX_RC_40_MHZ_WIDTH &&
+		    sta->bandwidth < IEEE80211_STA_RX_BW_40)
 			continue;
 
 		/* Mark MCS > 7 as unsupported if STA is in static SMPS mode */
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index b5f1bba..8a861a5 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2410,26 +2410,21 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 		case WLAN_HT_ACTION_NOTIFY_CHANWIDTH: {
 			struct ieee80211_supported_band *sband;
 			u8 chanwidth = mgmt->u.action.u.ht_notify_cw.chanwidth;
-			bool old_40mhz, new_40mhz;
+			enum ieee80211_sta_rx_bandwidth new_bw;
 
 			/* If it doesn't support 40 MHz it can't change ... */
-			if (!rx->sta->supports_40mhz)
+			if (!(rx->sta->sta.ht_cap.cap &
+					IEEE80211_HT_CAP_SUP_WIDTH_20_40))
 				goto handled;
 
-			old_40mhz = rx->sta->sta.ht_cap.cap &
-					IEEE80211_HT_CAP_SUP_WIDTH_20_40;
-			new_40mhz = chanwidth == IEEE80211_HT_CHANWIDTH_ANY;
+			if (chanwidth == IEEE80211_HT_CHANWIDTH_20MHZ)
+				new_bw = IEEE80211_STA_RX_BW_20;
+			else
+				new_bw = ieee80211_sta_cur_vht_bw(rx->sta);
 
-			if (old_40mhz == new_40mhz)
+			if (rx->sta->sta.bandwidth == new_bw)
 				goto handled;
 
-			if (new_40mhz)
-				rx->sta->sta.ht_cap.cap |=
-					IEEE80211_HT_CAP_SUP_WIDTH_20_40;
-			else
-				rx->sta->sta.ht_cap.cap &=
-					~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
-
 			sband = rx->local->hw.wiphy->bands[status->band];
 
 			rate_control_rate_update(local, sband, rx->sta,
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 350578c..03c42f8 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -296,8 +296,6 @@ struct sta_ampdu_mlme {
  * @sta: station information we share with the driver
  * @sta_state: duplicates information about station state (for debug)
  * @beacon_loss_count: number of times beacon loss has triggered
- * @supports_40mhz: tracks whether the station advertised 40 MHz support
- *	as we overwrite its HT parameters with the currently used value
  * @rcu_head: RCU head used for freeing this station struct
  */
 struct sta_info {
@@ -403,8 +401,6 @@ struct sta_info {
 	unsigned int lost_packets;
 	unsigned int beacon_loss_count;
 
-	bool supports_40mhz;
-
 	/* keep last! */
 	struct ieee80211_sta sta;
 };
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index 1606aa1..0fc9a2f 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -27,6 +27,10 @@ void ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 	if (!vht_cap_ie || !sband->vht_cap.vht_supported)
 		return;
 
+	/* A VHT STA must support 40 MHz */
+	if (!(sta->sta.ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40))
+		return;
+
 	vht_cap->vht_supported = true;
 
 	vht_cap->cap = le32_to_cpu(vht_cap_ie->vht_cap_info);
@@ -34,4 +38,39 @@ void ieee80211_vht_cap_ie_to_sta_vht_cap(struct ieee80211_sub_if_data *sdata,
 	/* Copy peer MCS info, the driver might need them. */
 	memcpy(&vht_cap->vht_mcs, &vht_cap_ie->supp_mcs,
 	       sizeof(struct ieee80211_vht_mcs_info));
+
+	sta->sta.bandwidth = ieee80211_sta_cur_vht_bw(sta);
+}
+
+enum ieee80211_sta_rx_bandwidth ieee80211_sta_cur_vht_bw(struct sta_info *sta)
+{
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	u32 cap = sta->sta.vht_cap.cap;
+
+	if (!sta->sta.vht_cap.vht_supported)
+		return sta->sta.ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40 ?
+				IEEE80211_STA_RX_BW_40 : IEEE80211_STA_RX_BW_20;
+
+	/* TODO: handle VHT opmode notification data */
+
+	switch (sdata->vif.bss_conf.chandef.width) {
+	default:
+		WARN_ON_ONCE(1);
+		/* fall through */
+	case NL80211_CHAN_WIDTH_20_NOHT:
+	case NL80211_CHAN_WIDTH_20:
+	case NL80211_CHAN_WIDTH_40:
+		return sta->sta.ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40 ?
+				IEEE80211_STA_RX_BW_40 : IEEE80211_STA_RX_BW_20;
+	case NL80211_CHAN_WIDTH_160:
+		if (cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ)
+			return IEEE80211_STA_RX_BW_160;
+		/* fall through */
+	case NL80211_CHAN_WIDTH_80P80:
+		if (cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ)
+			return IEEE80211_STA_RX_BW_160;
+		/* fall through */
+	case NL80211_CHAN_WIDTH_80:
+		return IEEE80211_STA_RX_BW_80;
+	}
 }
-- 
1.8.0

