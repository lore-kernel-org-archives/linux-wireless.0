Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:62079 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441Ab0H0Q4w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 12:56:52 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 14/27] iwlwifi: add context pointer to station
Date: Fri, 27 Aug 2010 09:59:42 -0700
Message-Id: <1282928395-32762-15-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Sometimes we only pass around station
pointers but need to find the context
they belong to, so store it in there.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   22 +++++++++++++++-------
 drivers/net/wireless/iwlwifi/iwl-sta.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 5 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 837406e..de8db3a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3751,7 +3751,7 @@ static int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
 		sta_priv->client = true;
 
 	ret = iwl_add_station_common(priv, vif_priv->ctx, sta->addr,
-				     is_ap, &sta->ht_cap, &sta_id);
+				     is_ap, sta, &sta_id);
 	if (ret) {
 		IWL_ERR(priv, "Unable to add station %pM (%d)\n",
 			sta->addr, ret);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 2f9d1da..9364768 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -502,6 +502,7 @@ struct iwl_station_entry {
 };
 
 struct iwl_station_priv_common {
+	struct iwl_rxon_context *ctx;
 	u8 sta_id;
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index e6bb81b..c18eb89 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -172,12 +172,13 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 EXPORT_SYMBOL(iwl_send_add_sta);
 
 static void iwl_set_ht_add_station(struct iwl_priv *priv, u8 index,
-				   struct ieee80211_sta_ht_cap *sta_ht_inf)
+				   struct ieee80211_sta *sta)
 {
+	struct ieee80211_sta_ht_cap *sta_ht_inf = &sta->ht_cap;
 	__le32 sta_flags;
 	u8 mimo_ps_mode;
 
-	if (!sta_ht_inf || !sta_ht_inf->ht_supported)
+	if (!sta || !sta_ht_inf->ht_supported)
 		goto done;
 
 	mimo_ps_mode = (sta_ht_inf->cap & IEEE80211_HT_CAP_SM_PS) >> 2;
@@ -228,7 +229,7 @@ static void iwl_set_ht_add_station(struct iwl_priv *priv, u8 index,
  */
 static u8 iwl_prep_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 			   const u8 *addr, bool is_ap,
-			   struct ieee80211_sta_ht_cap *ht_info)
+			   struct ieee80211_sta *sta)
 {
 	struct iwl_station_entry *station;
 	int i;
@@ -292,12 +293,19 @@ static u8 iwl_prep_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 	station->sta.station_flags = ctx->station_flags;
 	station->ctxid = ctx->ctxid;
 
+	if (sta) {
+		struct iwl_station_priv_common *sta_priv;
+
+		sta_priv = (void *)sta->drv_priv;
+		sta_priv->ctx = ctx;
+	}
+
 	/*
 	 * OK to call unconditionally, since local stations (IBSS BSSID
-	 * STA and broadcast STA) pass in a NULL ht_info, and mac80211
+	 * STA and broadcast STA) pass in a NULL sta, and mac80211
 	 * doesn't allow HT IBSS.
 	 */
-	iwl_set_ht_add_station(priv, sta_id, ht_info);
+	iwl_set_ht_add_station(priv, sta_id, sta);
 
 	/* 3945 only */
 	rate = (priv->band == IEEE80211_BAND_5GHZ) ?
@@ -316,7 +324,7 @@ static u8 iwl_prep_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
  */
 int iwl_add_station_common(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 			   const u8 *addr, bool is_ap,
-			   struct ieee80211_sta_ht_cap *ht_info, u8 *sta_id_r)
+			   struct ieee80211_sta *sta, u8 *sta_id_r)
 {
 	unsigned long flags_spin;
 	int ret = 0;
@@ -325,7 +333,7 @@ int iwl_add_station_common(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 
 	*sta_id_r = 0;
 	spin_lock_irqsave(&priv->sta_lock, flags_spin);
-	sta_id = iwl_prep_station(priv, ctx, addr, is_ap, ht_info);
+	sta_id = iwl_prep_station(priv, ctx, addr, is_ap, sta);
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_ERR(priv, "Unable to prepare station %pM for addition\n",
 			addr);
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 6ab5587..56bad3f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -74,7 +74,7 @@ int iwl_add_bssid_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 			  const u8 *addr, bool init_rs, u8 *sta_id_r);
 int iwl_add_station_common(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 			   const u8 *addr, bool is_ap,
-			   struct ieee80211_sta_ht_cap *ht_info, u8 *sta_id_r);
+			   struct ieee80211_sta *sta, u8 *sta_id_r);
 int iwl_remove_station(struct iwl_priv *priv, const u8 sta_id,
 		       const u8 *addr);
 int iwl_mac_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index be48f79..c048c1d 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3390,7 +3390,7 @@ static int iwl3945_mac_sta_add(struct ieee80211_hw *hw,
 
 
 	ret = iwl_add_station_common(priv, &priv->contexts[IWL_RXON_CTX_BSS],
-				     sta->addr, is_ap, &sta->ht_cap, &sta_id);
+				     sta->addr, is_ap, sta, &sta_id);
 	if (ret) {
 		IWL_ERR(priv, "Unable to add station %pM (%d)\n",
 			sta->addr, ret);
-- 
1.7.0.4

