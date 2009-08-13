Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:3757 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932410AbZHMUbS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 16:31:18 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel C Halperin <daniel.c.halperin@intel.com>
Subject: [PATCH 09/13] iwlwifi: check short GI support per-station rather than globally
Date: Thu, 13 Aug 2009 13:30:58 -0700
Message-Id: <1250195462-15811-10-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1250195462-15811-1-git-send-email-reinette.chatre@intel.com>
References: <1250195462-15811-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel C Halperin <daniel.c.halperin@intel.com>

Short guard interval support is a local per-station parameter not a global
per-NIC parameter.  (mac80211 will correctly remove SGI support from station
capabilities if the BSS does not permit it).  This patch removes the short GI
support bitfield from the global iwl_ht_info struct and properly uses
per-station HT capabilities during rate selection.

Signed-off-by: Daniel C Halperin <daniel.c.halperin@intel.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   69 ++++++----------------------
 drivers/net/wireless/iwlwifi/iwl-core.c   |    5 --
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    4 --
 3 files changed, 15 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 551c4ba..3b1bbc3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -1225,18 +1225,6 @@ static int rs_switch_to_mimo2(struct iwl_priv *priv,
 	else
 		tbl->is_ht40 = 0;
 
-	/* FIXME: - don't toggle SGI here
-	if (tbl->is_ht40) {
-		if (priv->current_ht_config.sgf & HT_SHORT_GI_40MHZ_ONLY)
-			tbl->is_SGI = 1;
-		else
-			tbl->is_SGI = 0;
-	} else if (priv->current_ht_config.sgf & HT_SHORT_GI_20MHZ_ONLY)
-		tbl->is_SGI = 1;
-	else
-		tbl->is_SGI = 0;
-	*/
-
 	rs_set_expected_tpt_table(lq_sta, tbl);
 
 	rate = rs_get_best_rate(priv, lq_sta, tbl, rate_mask, index);
@@ -1291,18 +1279,6 @@ static int rs_switch_to_mimo3(struct iwl_priv *priv,
 	else
 		tbl->is_ht40 = 0;
 
-	/* FIXME: - don't toggle SGI here
-	if (tbl->is_ht40) {
-		if (priv->current_ht_config.sgf & HT_SHORT_GI_40MHZ_ONLY)
-			tbl->is_SGI = 1;
-		else
-			tbl->is_SGI = 0;
-	} else if (priv->current_ht_config.sgf & HT_SHORT_GI_20MHZ_ONLY)
-		tbl->is_SGI = 1;
-	else
-		tbl->is_SGI = 0;
-	*/
-
 	rs_set_expected_tpt_table(lq_sta, tbl);
 
 	rate = rs_get_best_rate(priv, lq_sta, tbl, rate_mask, index);
@@ -1350,18 +1326,6 @@ static int rs_switch_to_siso(struct iwl_priv *priv,
 	else
 		tbl->is_ht40 = 0;
 
-	/* FIXME: - don't toggle SGI here
-	if (tbl->is_ht40) {
-		if (priv->current_ht_config.sgf & HT_SHORT_GI_40MHZ_ONLY)
-			tbl->is_SGI = 1;
-		else
-			tbl->is_SGI = 0;
-	} else if (priv->current_ht_config.sgf & HT_SHORT_GI_20MHZ_ONLY)
-		tbl->is_SGI = 1;
-	else
-		tbl->is_SGI = 0;
-	*/
-
 	if (is_green)
 		tbl->is_SGI = 0; /*11n spec: no SGI in SISO+Greenfield*/
 
@@ -1530,6 +1494,7 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 	struct iwl_scale_tbl_info *search_tbl =
 				&(lq_sta->lq_info[(1 - lq_sta->active_tbl)]);
 	struct iwl_rate_scale_data *window = &(tbl->win[index]);
+	struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
 	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
 		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
 	u8 start_action = tbl->action;
@@ -1589,13 +1554,11 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 				goto out;
 			break;
 		case IWL_SISO_SWITCH_GI:
-			if (!tbl->is_ht40 &&
-				!(priv->current_ht_config.sgf &
-						HT_SHORT_GI_20MHZ))
+			if (!tbl->is_ht40 && !(ht_cap->cap &
+						IEEE80211_HT_CAP_SGI_20))
 				break;
-			if (tbl->is_ht40 &&
-				!(priv->current_ht_config.sgf &
-						HT_SHORT_GI_40MHZ))
+			if (tbl->is_ht40 && !(ht_cap->cap &
+						IEEE80211_HT_CAP_SGI_40))
 				break;
 
 			IWL_DEBUG_RATE(priv, "LQ: SISO toggle SGI/NGI\n");
@@ -1669,6 +1632,7 @@ static int rs_move_mimo2_to_other(struct iwl_priv *priv,
 	struct iwl_scale_tbl_info *search_tbl =
 				&(lq_sta->lq_info[(1 - lq_sta->active_tbl)]);
 	struct iwl_rate_scale_data *window = &(tbl->win[index]);
+	struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
 	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
 		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
 	u8 start_action = tbl->action;
@@ -1729,13 +1693,11 @@ static int rs_move_mimo2_to_other(struct iwl_priv *priv,
 			break;
 
 		case IWL_MIMO2_SWITCH_GI:
-			if (!tbl->is_ht40 &&
-				!(priv->current_ht_config.sgf &
-						HT_SHORT_GI_20MHZ))
+			if (!tbl->is_ht40 && !(ht_cap->cap &
+						IEEE80211_HT_CAP_SGI_20))
 				break;
-			if (tbl->is_ht40 &&
-				!(priv->current_ht_config.sgf &
-						HT_SHORT_GI_40MHZ))
+			if (tbl->is_ht40 && !(ht_cap->cap &
+						IEEE80211_HT_CAP_SGI_40))
 				break;
 
 			IWL_DEBUG_RATE(priv, "LQ: MIMO2 toggle SGI/NGI\n");
@@ -1811,6 +1773,7 @@ static int rs_move_mimo3_to_other(struct iwl_priv *priv,
 	struct iwl_scale_tbl_info *search_tbl =
 				&(lq_sta->lq_info[(1 - lq_sta->active_tbl)]);
 	struct iwl_rate_scale_data *window = &(tbl->win[index]);
+	struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
 	u32 sz = (sizeof(struct iwl_scale_tbl_info) -
 		  (sizeof(struct iwl_rate_scale_data) * IWL_RATE_COUNT));
 	u8 start_action = tbl->action;
@@ -1893,13 +1856,11 @@ static int rs_move_mimo3_to_other(struct iwl_priv *priv,
 			break;
 
 		case IWL_MIMO3_SWITCH_GI:
-			if (!tbl->is_ht40 &&
-				!(priv->current_ht_config.sgf &
-						HT_SHORT_GI_20MHZ))
+			if (!tbl->is_ht40 && !(ht_cap->cap &
+						IEEE80211_HT_CAP_SGI_20))
 				break;
-			if (tbl->is_ht40 &&
-				!(priv->current_ht_config.sgf &
-						HT_SHORT_GI_40MHZ))
+			if (tbl->is_ht40 && !(ht_cap->cap &
+						IEEE80211_HT_CAP_SGI_40))
 				break;
 
 			IWL_DEBUG_RATE(priv, "LQ: MIMO3 toggle SGI/NGI\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 104fd95..b845cf3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2391,11 +2391,6 @@ static void iwl_ht_conf(struct iwl_priv *priv,
 	}
 	ht_conf = &sta->ht_cap;
 
-	if (ht_conf->cap & IEEE80211_HT_CAP_SGI_20)
-		iwl_conf->sgf |= HT_SHORT_GI_20MHZ;
-	if (ht_conf->cap & IEEE80211_HT_CAP_SGI_40)
-		iwl_conf->sgf |= HT_SHORT_GI_40MHZ;
-
 	iwl_conf->is_green_field = !!(ht_conf->cap & IEEE80211_HT_CAP_GRN_FLD);
 
 	iwl_conf->sm_ps = (u8)((ht_conf->cap & IEEE80211_HT_CAP_SM_PS) >> 2);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index db74534..e6a1c6f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -508,7 +508,6 @@ struct iwl_ht_info {
 	u8 supported_chan_width;
 	u8 sm_ps;
 	u8 is_green_field;
-	u8 sgf;			/* HT_SHORT_GI_* short guard interval */
 	struct ieee80211_mcs_info mcs;
 	/* BSS related data */
 	u8 extension_chan_offset;
@@ -728,9 +727,6 @@ struct iwl_dma_ptr {
 	size_t size;
 };
 
-#define HT_SHORT_GI_20MHZ	(1 << 0)
-#define HT_SHORT_GI_40MHZ	(1 << 1)
-
 #define IWL_CHANNEL_WIDTH_20MHZ   0
 #define IWL_CHANNEL_WIDTH_40MHZ   1
 
-- 
1.5.6.3

