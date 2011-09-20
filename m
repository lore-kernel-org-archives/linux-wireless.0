Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:1940 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554Ab1ITXX2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 19:23:28 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/8] iwlagn: remove common station priv
Date: Tue, 20 Sep 2011 15:37:21 -0700
Message-Id: <1316558247-10018-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110921_012336_895529_E97F60D1)
In-Reply-To: <1316558247-10018-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316558247-10018-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since the driver split there's no more need for
shared/non-shared private station data so remove
struct iwl_station_priv_common entirely.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   16 ++++++++--------
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    8 ++------
 drivers/net/wireless/iwlwifi/iwl-sta.c    |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-sta.h    |    2 +-
 5 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index ffee15b..c14f8d6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -346,7 +346,7 @@ static void rs_program_fix_rate(struct iwl_priv *priv,
 {
 	struct iwl_station_priv *sta_priv =
 		container_of(lq_sta, struct iwl_station_priv, lq_sta);
-	struct iwl_rxon_context *ctx = sta_priv->common.ctx;
+	struct iwl_rxon_context *ctx = sta_priv->ctx;
 
 	lq_sta->active_legacy_rate = 0x0FFF;	/* 1 - 54 MBits, includes CCK */
 	lq_sta->active_siso_rate   = 0x1FD0;	/* 6 - 60 MBits, no 9, no CCK */
@@ -710,7 +710,7 @@ static int rs_toggle_antenna(u32 valid_ant, u32 *rate_n_flags,
 static bool rs_use_green(struct ieee80211_sta *sta)
 {
 	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
-	struct iwl_rxon_context *ctx = sta_priv->common.ctx;
+	struct iwl_rxon_context *ctx = sta_priv->ctx;
 
 	return (sta->ht_cap.cap & IEEE80211_HT_CAP_GRN_FLD) &&
 		!(ctx->ht.non_gf_sta_present);
@@ -917,7 +917,7 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 	struct iwl_scale_tbl_info tbl_type;
 	struct iwl_scale_tbl_info *curr_tbl, *other_tbl, *tmp_tbl;
 	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
-	struct iwl_rxon_context *ctx = sta_priv->common.ctx;
+	struct iwl_rxon_context *ctx = sta_priv->ctx;
 
 	IWL_DEBUG_RATE_LIMIT(priv, "get frame ack response, update rate scale window\n");
 
@@ -1283,7 +1283,7 @@ static int rs_switch_to_mimo2(struct iwl_priv *priv,
 	s32 rate;
 	s8 is_green = lq_sta->is_green;
 	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
-	struct iwl_rxon_context *ctx = sta_priv->common.ctx;
+	struct iwl_rxon_context *ctx = sta_priv->ctx;
 
 	if (!conf_is_ht(conf) || !sta->ht_cap.ht_supported)
 		return -1;
@@ -1339,7 +1339,7 @@ static int rs_switch_to_mimo3(struct iwl_priv *priv,
 	s32 rate;
 	s8 is_green = lq_sta->is_green;
 	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
-	struct iwl_rxon_context *ctx = sta_priv->common.ctx;
+	struct iwl_rxon_context *ctx = sta_priv->ctx;
 
 	if (!conf_is_ht(conf) || !sta->ht_cap.ht_supported)
 		return -1;
@@ -1396,7 +1396,7 @@ static int rs_switch_to_siso(struct iwl_priv *priv,
 	u8 is_green = lq_sta->is_green;
 	s32 rate;
 	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
-	struct iwl_rxon_context *ctx = sta_priv->common.ctx;
+	struct iwl_rxon_context *ctx = sta_priv->ctx;
 
 	if (!conf_is_ht(conf) || !sta->ht_cap.ht_supported)
 		return -1;
@@ -2263,7 +2263,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	u8 tid = IWL_MAX_TID_COUNT;
 	struct iwl_tid_data *tid_data;
 	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
-	struct iwl_rxon_context *ctx = sta_priv->common.ctx;
+	struct iwl_rxon_context *ctx = sta_priv->ctx;
 
 	IWL_DEBUG_RATE(priv, "rate scale calculate new rate for skb\n");
 
@@ -2706,7 +2706,7 @@ static void rs_initialize_lq(struct iwl_priv *priv,
 		return;
 
 	sta_priv = (void *)sta->drv_priv;
-	ctx = sta_priv->common.ctx;
+	ctx = sta_priv->ctx;
 
 	i = lq_sta->last_txrate_idx;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 6def1c2..fcfb410 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2513,7 +2513,7 @@ static int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
 	mutex_lock(&priv->shrd->mutex);
 	IWL_DEBUG_INFO(priv, "proceeding to add station %pM\n",
 			sta->addr);
-	sta_priv->common.sta_id = IWL_INVALID_STATION;
+	sta_priv->sta_id = IWL_INVALID_STATION;
 
 	atomic_set(&sta_priv->pending_frames, 0);
 	if (vif->type == NL80211_IFTYPE_AP)
@@ -2529,7 +2529,7 @@ static int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
 		return ret;
 	}
 
-	sta_priv->common.sta_id = sta_id;
+	sta_priv->sta_id = sta_id;
 
 	/* Initialize rate scaling */
 	IWL_DEBUG_INFO(priv, "Initializing rate scaling for station %pM\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index f69e556..fabfc8b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -202,11 +202,6 @@ struct iwl_station_entry {
 	struct iwl_link_quality_cmd *lq;
 };
 
-struct iwl_station_priv_common {
-	struct iwl_rxon_context *ctx;
-	u8 sta_id;
-};
-
 /*
  * iwl_station_priv: Driver's private station information
  *
@@ -215,12 +210,13 @@ struct iwl_station_priv_common {
  * space.
  */
 struct iwl_station_priv {
-	struct iwl_station_priv_common common;
+	struct iwl_rxon_context *ctx;
 	struct iwl_lq_sta lq_sta;
 	atomic_t pending_frames;
 	bool client;
 	bool asleep;
 	u8 max_agg_bufsize;
+	u8 sta_id;
 };
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index e24135e..f35cfa2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -305,7 +305,7 @@ u8 iwl_prep_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 	station->ctxid = ctx->ctxid;
 
 	if (sta) {
-		struct iwl_station_priv_common *sta_priv;
+		struct iwl_station_priv *sta_priv;
 
 		sta_priv = (void *)sta->drv_priv;
 		sta_priv->ctx = ctx;
@@ -821,7 +821,7 @@ int iwl_mac_sta_remove(struct ieee80211_hw *hw,
 		       struct ieee80211_sta *sta)
 {
 	struct iwl_priv *priv = hw->priv;
-	struct iwl_station_priv_common *sta_common = (void *)sta->drv_priv;
+	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
 	int ret;
 
 	IWL_DEBUG_INFO(priv, "received request to remove station %pM\n",
@@ -829,7 +829,7 @@ int iwl_mac_sta_remove(struct ieee80211_hw *hw,
 	mutex_lock(&priv->shrd->mutex);
 	IWL_DEBUG_INFO(priv, "proceeding to remove station %pM\n",
 			sta->addr);
-	ret = iwl_remove_station(priv, sta_common->sta_id, sta->addr);
+	ret = iwl_remove_station(priv, sta_priv->sta_id, sta->addr);
 	if (ret)
 		IWL_ERR(priv, "Error removing station %pM\n",
 			sta->addr);
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 9641eb6..02491b9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -102,7 +102,7 @@ static inline int iwl_sta_id(struct ieee80211_sta *sta)
 	if (WARN_ON(!sta))
 		return IWL_INVALID_STATION;
 
-	return ((struct iwl_station_priv_common *)sta->drv_priv)->sta_id;
+	return ((struct iwl_station_priv *)sta->drv_priv)->sta_id;
 }
 
 /**
-- 
1.7.0.4

