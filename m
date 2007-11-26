Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:52348 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbXKZOVw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 09:21:52 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 14/15] iwlwifi: 802.11n comply HT rate scaling flows with mac80211 framework
Date: Mon, 26 Nov 2007 16:14:41 +0200
Message-Id: <11960864924152-git-send-email-ron.rindjunsky@intel.com> (sfid-20071126_143522_617026_05FA0A40)
In-Reply-To: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
References: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch conforms the rate scaling flows according to the new mac80211's
HT framework

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |   93 +++++++++++++++++-----------
 1 files changed, 57 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 5d37ff4..6a835e8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -440,15 +440,14 @@ static inline void rs_toggle_antenna(struct iwl4965_rate *new_rate,
 	}
 }
 
-static inline u8 rs_use_green(struct iwl4965_priv *priv)
+static inline u8 rs_use_green(struct iwl4965_priv *priv,
+			      struct ieee80211_conf *conf)
 {
 #ifdef CONFIG_IWL4965_HT
-	if (!priv->is_ht_enabled || !priv->current_assoc_ht.is_ht)
-		return 0;
-
-	return ((priv->current_assoc_ht.is_green_field) &&
-	    !(priv->current_assoc_ht.operating_mode & 0x4));
-#endif	/*CONFIG_IWL4965_HT */
+	return ((conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) &&
+		priv->current_ht_config.is_green_field &&
+		!priv->current_ht_config.non_GF_STA_present);
+#endif	/* CONFIG_IWL4965_HT */
 	return 0;
 }
 
@@ -888,6 +887,8 @@ static inline u8 rs_is_both_ant_supp(u8 valid_antenna)
 
 static int rs_switch_to_mimo(struct iwl4965_priv *priv,
 			     struct iwl4965_rate_scale_priv *lq_data,
+			     struct ieee80211_conf *conf,
+			     struct sta_info *sta,
 			     struct iwl4965_scale_tbl_info *tbl, int index)
 {
 #ifdef CONFIG_IWL4965_HT
@@ -895,7 +896,8 @@ static int rs_switch_to_mimo(struct iwl4965_priv *priv,
 	s32 rate;
 	s8 is_green = lq_data->is_green;
 
-	if (!priv->is_ht_enabled || !priv->current_assoc_ht.is_ht)
+	if (!(conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) ||
+	    !sta->ht_info.ht_supported)
 		return -1;
 
 	IWL_DEBUG_HT("LQ: try to switch to MIMO\n");
@@ -903,7 +905,7 @@ static int rs_switch_to_mimo(struct iwl4965_priv *priv,
 	rs_get_supported_rates(lq_data, NULL, tbl->lq_type,
 				&rate_mask);
 
-	if (priv->current_assoc_ht.tx_mimo_ps_mode == IWL_MIMO_PS_STATIC)
+	if (priv->current_ht_config.tx_mimo_ps_mode == IWL_MIMO_PS_STATIC)
 		return -1;
 
 	if (!rs_is_both_ant_supp(lq_data->antenna))
@@ -911,17 +913,18 @@ static int rs_switch_to_mimo(struct iwl4965_priv *priv,
 
 	tbl->is_dup = lq_data->is_dup;
 	tbl->action = 0;
-	if (priv->current_channel_width == IWL_CHANNEL_WIDTH_40MHZ)
+	if (priv->current_ht_config.supported_chan_width
+	    == IWL_CHANNEL_WIDTH_40MHZ)
 		tbl->is_fat = 1;
 	else
 		tbl->is_fat = 0;
 
 	if (tbl->is_fat) {
-		if (priv->current_assoc_ht.sgf & HT_SHORT_GI_40MHZ_ONLY)
+		if (priv->current_ht_config.sgf & HT_SHORT_GI_40MHZ_ONLY)
 			tbl->is_SGI = 1;
 		else
 			tbl->is_SGI = 0;
-	} else if (priv->current_assoc_ht.sgf & HT_SHORT_GI_20MHZ_ONLY)
+	} else if (priv->current_ht_config.sgf & HT_SHORT_GI_20MHZ_ONLY)
 		tbl->is_SGI = 1;
 	else
 		tbl->is_SGI = 0;
@@ -945,6 +948,8 @@ static int rs_switch_to_mimo(struct iwl4965_priv *priv,
 
 static int rs_switch_to_siso(struct iwl4965_priv *priv,
 			     struct iwl4965_rate_scale_priv *lq_data,
+			     struct ieee80211_conf *conf,
+			     struct sta_info *sta,
 			     struct iwl4965_scale_tbl_info *tbl, int index)
 {
 #ifdef CONFIG_IWL4965_HT
@@ -953,7 +958,8 @@ static int rs_switch_to_siso(struct iwl4965_priv *priv,
 	s32 rate;
 
 	IWL_DEBUG_HT("LQ: try to switch to SISO\n");
-	if (!priv->is_ht_enabled || !priv->current_assoc_ht.is_ht)
+	if (!(conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) ||
+	    !sta->ht_info.ht_supported)
 		return -1;
 
 	tbl->is_dup = lq_data->is_dup;
@@ -962,17 +968,18 @@ static int rs_switch_to_siso(struct iwl4965_priv *priv,
 	rs_get_supported_rates(lq_data, NULL, tbl->lq_type,
 				&rate_mask);
 
-	if (priv->current_channel_width == IWL_CHANNEL_WIDTH_40MHZ)
+	if (priv->current_ht_config.supported_chan_width
+	    == IWL_CHANNEL_WIDTH_40MHZ)
 		tbl->is_fat = 1;
 	else
 		tbl->is_fat = 0;
 
 	if (tbl->is_fat) {
-		if (priv->current_assoc_ht.sgf & HT_SHORT_GI_40MHZ_ONLY)
+		if (priv->current_ht_config.sgf & HT_SHORT_GI_40MHZ_ONLY)
 			tbl->is_SGI = 1;
 		else
 			tbl->is_SGI = 0;
-	} else if (priv->current_assoc_ht.sgf & HT_SHORT_GI_20MHZ_ONLY)
+	} else if (priv->current_ht_config.sgf & HT_SHORT_GI_20MHZ_ONLY)
 		tbl->is_SGI = 1;
 	else
 		tbl->is_SGI = 0;
@@ -1001,6 +1008,8 @@ static int rs_switch_to_siso(struct iwl4965_priv *priv,
 
 static int rs_move_legacy_other(struct iwl4965_priv *priv,
 				struct iwl4965_rate_scale_priv *lq_data,
+				struct ieee80211_conf *conf,
+				struct sta_info *sta,
 				int index)
 {
 	int ret = 0;
@@ -1040,8 +1049,8 @@ static int rs_move_legacy_other(struct iwl4965_priv *priv,
 			search_tbl->lq_type = LQ_SISO;
 			search_tbl->is_SGI = 0;
 			search_tbl->is_fat = 0;
-			ret = rs_switch_to_siso(priv, lq_data, search_tbl,
-					       index);
+			ret = rs_switch_to_siso(priv, lq_data, conf, sta,
+						 search_tbl, index);
 			if (!ret) {
 				lq_data->search_better_tbl = 1;
 				lq_data->action_counter = 0;
@@ -1056,8 +1065,8 @@ static int rs_move_legacy_other(struct iwl4965_priv *priv,
 			search_tbl->is_SGI = 0;
 			search_tbl->is_fat = 0;
 			search_tbl->antenna_type = ANT_BOTH;
-			ret = rs_switch_to_mimo(priv, lq_data, search_tbl,
-					       index);
+			ret = rs_switch_to_mimo(priv, lq_data, conf, sta,
+						 search_tbl, index);
 			if (!ret) {
 				lq_data->search_better_tbl = 1;
 				lq_data->action_counter = 0;
@@ -1085,6 +1094,8 @@ static int rs_move_legacy_other(struct iwl4965_priv *priv,
 
 static int rs_move_siso_to_other(struct iwl4965_priv *priv,
 				 struct iwl4965_rate_scale_priv *lq_data,
+				 struct ieee80211_conf *conf,
+				 struct sta_info *sta,
 				 int index)
 {
 	int ret;
@@ -1125,8 +1136,8 @@ static int rs_move_siso_to_other(struct iwl4965_priv *priv,
 			search_tbl->is_SGI = 0;
 			search_tbl->is_fat = 0;
 			search_tbl->antenna_type = ANT_BOTH;
-			ret = rs_switch_to_mimo(priv, lq_data, search_tbl,
-					       index);
+			ret = rs_switch_to_mimo(priv, lq_data, conf, sta,
+						 search_tbl, index);
 			if (!ret) {
 				lq_data->search_better_tbl = 1;
 				goto out;
@@ -1175,6 +1186,8 @@ static int rs_move_siso_to_other(struct iwl4965_priv *priv,
 
 static int rs_move_mimo_to_other(struct iwl4965_priv *priv,
 				 struct iwl4965_rate_scale_priv *lq_data,
+				 struct ieee80211_conf *conf,
+				 struct sta_info *sta,
 				 int index)
 {
 	int ret;
@@ -1202,8 +1215,8 @@ static int rs_move_mimo_to_other(struct iwl4965_priv *priv,
 			else
 				search_tbl->antenna_type = ANT_AUX;
 
-			ret = rs_switch_to_siso(priv, lq_data, search_tbl,
-					       index);
+			ret = rs_switch_to_siso(priv, lq_data, conf, sta,
+						 search_tbl, index);
 			if (!ret) {
 				lq_data->search_better_tbl = 1;
 				goto out;
@@ -1310,6 +1323,9 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 				  struct ieee80211_hdr *hdr,
 				  struct sta_info *sta)
 {
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_hw *hw = local_to_hw(local);
+	struct ieee80211_conf *conf = &hw->conf;
 	int low = IWL_RATE_INVALID;
 	int high = IWL_RATE_INVALID;
 	int index;
@@ -1548,11 +1564,11 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 		lq_data->last_tpt = current_tpt;
 
 		if (is_legacy(tbl->lq_type))
-			rs_move_legacy_other(priv, lq_data, index);
+			rs_move_legacy_other(priv, lq_data, conf, sta, index);
 		else if (is_siso(tbl->lq_type))
-			rs_move_siso_to_other(priv, lq_data, index);
+			rs_move_siso_to_other(priv, lq_data, conf, sta, index);
 		else
-			rs_move_mimo_to_other(priv, lq_data, index);
+			rs_move_mimo_to_other(priv, lq_data, conf, sta, index);
 
 		if (lq_data->search_better_tbl) {
 			tbl = &(lq_data->lq_info[(1 - lq_data->active_tbl)]);
@@ -1572,7 +1588,7 @@ static void rs_rate_scale_perform(struct iwl4965_priv *priv,
 
 		if (is_legacy(tbl1->lq_type) &&
 #ifdef CONFIG_IWL4965_HT
-		    !priv->current_assoc_ht.is_ht &&
+		   (!(conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE)) &&
 #endif
 		    (lq_data->action_counter >= 1)) {
 			lq_data->action_counter = 0;
@@ -1616,6 +1632,7 @@ out:
 
 
 static void rs_initialize_lq(struct iwl4965_priv *priv,
+			     struct ieee80211_conf *conf,
 			     struct sta_info *sta)
 {
 	int i;
@@ -1623,7 +1640,7 @@ static void rs_initialize_lq(struct iwl4965_priv *priv,
 	struct iwl4965_scale_tbl_info *tbl;
 	u8 active_tbl = 0;
 	int rate_idx;
-	u8 use_green = rs_use_green(priv);
+	u8 use_green = rs_use_green(priv, conf);
 	struct iwl4965_rate mcs_rate;
 
 	if (!sta || !sta->rate_ctrl_priv)
@@ -1692,6 +1709,7 @@ static struct ieee80211_rate *rs_get_rate(void *priv_rate,
 
 	int i;
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_conf *conf = &local->hw.conf;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct sta_info *sta;
 	u16 fc;
@@ -1735,7 +1753,7 @@ static struct ieee80211_rate *rs_get_rate(void *priv_rate,
 			lq->lq.sta_id = sta_id;
 			lq->lq.rs_table[0].rate_n_flags = 0;
 			lq->ibss_sta_added = 1;
-			rs_initialize_lq(priv, sta);
+			rs_initialize_lq(priv, conf, sta);
 		}
 		if (!lq->ibss_sta_added)
 			goto done;
@@ -1775,6 +1793,7 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 			 struct sta_info *sta)
 {
 	int i, j;
+	struct ieee80211_conf *conf = &local->hw.conf;
 	struct ieee80211_hw_mode *mode = local->oper_hw_mode;
 	struct iwl4965_priv *priv = (struct iwl4965_priv *)priv_rate;
 	struct iwl4965_rate_scale_priv *crl = priv_sta;
@@ -1830,19 +1849,21 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 	crl->is_dup = 0;
 	crl->valid_antenna = priv->valid_antenna;
 	crl->antenna = priv->antenna;
-	crl->is_green = rs_use_green(priv);
+	crl->is_green = rs_use_green(priv, conf);
 	crl->active_rate = priv->active_rate;
 	crl->active_rate &= ~(0x1000);
 	crl->active_rate_basic = priv->active_rate_basic;
 	crl->phymode = priv->phymode;
 #ifdef CONFIG_IWL4965_HT
-	crl->active_siso_rate = (priv->current_assoc_ht.supp_rates[0] << 1);
-	crl->active_siso_rate |= (priv->current_assoc_ht.supp_rates[0] & 0x1);
+	crl->active_siso_rate = (priv->current_ht_config.supp_mcs_set[0] << 1);
+	crl->active_siso_rate |=
+			(priv->current_ht_config.supp_mcs_set[0] & 0x1);
 	crl->active_siso_rate &= ~((u16)0x2);
 	crl->active_siso_rate = crl->active_siso_rate << IWL_FIRST_OFDM_RATE;
 
-	crl->active_mimo_rate = (priv->current_assoc_ht.supp_rates[1] << 1);
-	crl->active_mimo_rate |= (priv->current_assoc_ht.supp_rates[1] & 0x1);
+	crl->active_mimo_rate = (priv->current_ht_config.supp_mcs_set[1] << 1);
+	crl->active_mimo_rate |=
+			(priv->current_ht_config.supp_mcs_set[1] & 0x1);
 	crl->active_mimo_rate &= ~((u16)0x2);
 	crl->active_mimo_rate = crl->active_mimo_rate << IWL_FIRST_OFDM_RATE;
 	IWL_DEBUG_HT("MIMO RATE 0x%X SISO MASK 0x%X\n", crl->active_siso_rate,
@@ -1855,7 +1876,7 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 	if (priv->assoc_station_added)
 		priv->lq_mngr.lq_ready = 1;
 
-	rs_initialize_lq(priv, sta);
+	rs_initialize_lq(priv, conf, sta);
 }
 
 static void rs_fill_link_cmd(struct iwl4965_rate_scale_priv *lq_data,
-- 
1.5.3.3
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
