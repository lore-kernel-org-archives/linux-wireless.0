Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:5416 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150Ab1FXTjJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 15:39:09 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 5/5] iwlagn: don't use CCK rates for P2P interfaces
Date: Fri, 24 Jun 2011 12:07:17 -0700
Message-Id: <1308942437-6039-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110624_213926_442045_15D2CB64)
In-Reply-To: <1308942437-6039-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1308942437-6039-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

P2P interfaces must not use CCK rates, only OFDM
rates are allowed. To set this up, we need to set
up the broadcast station to start with 6M instead
of starting with 1M.

Since the interface type can change, also reset
the broadcast station when RXON changes.

This will affect beacons as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    2 ++
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c  |   17 +++++++++++------
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    2 ++
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index a7c66c4..8fa43d4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -210,6 +210,8 @@ static int iwlagn_rxon_disconn(struct iwl_priv *priv,
 	 * keys, so we have to restore those afterwards.
 	 */
 	iwl_clear_ucode_stations(priv, ctx);
+	/* update -- might need P2P now */
+	iwl_update_bcast_station(priv, ctx);
 	iwl_restore_stations(priv, ctx);
 	ret = iwl_restore_default_wep_keys(priv, ctx);
 	if (ret) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 0bd722c..9b32f83 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -35,7 +35,7 @@
 #include "iwl-agn.h"
 
 static struct iwl_link_quality_cmd *
-iwl_sta_alloc_lq(struct iwl_priv *priv, u8 sta_id)
+iwl_sta_alloc_lq(struct iwl_priv *priv, struct iwl_rxon_context *ctx, u8 sta_id)
 {
 	int i, r;
 	struct iwl_link_quality_cmd *link_cmd;
@@ -47,10 +47,15 @@ iwl_sta_alloc_lq(struct iwl_priv *priv, u8 sta_id)
 		IWL_ERR(priv, "Unable to allocate memory for LQ cmd.\n");
 		return NULL;
 	}
+
+	lockdep_assert_held(&priv->mutex);
+
 	/* Set up the rate scaling to start at selected rate, fall back
 	 * all the way down to 1M in IEEE order, and then spin on 1M */
 	if (priv->band == IEEE80211_BAND_5GHZ)
 		r = IWL_RATE_6M_INDEX;
+	else if (ctx && ctx->vif && ctx->vif->p2p)
+		r = IWL_RATE_6M_INDEX;
 	else
 		r = IWL_RATE_1M_INDEX;
 
@@ -115,7 +120,7 @@ int iwlagn_add_bssid_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
 	/* Set up default rate scaling table in device's station table */
-	link_cmd = iwl_sta_alloc_lq(priv, sta_id);
+	link_cmd = iwl_sta_alloc_lq(priv, ctx, sta_id);
 	if (!link_cmd) {
 		IWL_ERR(priv, "Unable to initialize rate scaling for station %pM.\n",
 			addr);
@@ -554,7 +559,7 @@ int iwlagn_alloc_bcast_station(struct iwl_priv *priv,
 	priv->stations[sta_id].used |= IWL_STA_BCAST;
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
-	link_cmd = iwl_sta_alloc_lq(priv, sta_id);
+	link_cmd = iwl_sta_alloc_lq(priv, ctx, sta_id);
 	if (!link_cmd) {
 		IWL_ERR(priv,
 			"Unable to initialize rate scaling for bcast station.\n");
@@ -574,14 +579,14 @@ int iwlagn_alloc_bcast_station(struct iwl_priv *priv,
  * Only used by iwlagn. Placed here to have all bcast station management
  * code together.
  */
-static int iwl_update_bcast_station(struct iwl_priv *priv,
-				    struct iwl_rxon_context *ctx)
+int iwl_update_bcast_station(struct iwl_priv *priv,
+			     struct iwl_rxon_context *ctx)
 {
 	unsigned long flags;
 	struct iwl_link_quality_cmd *link_cmd;
 	u8 sta_id = ctx->bcast_sta_id;
 
-	link_cmd = iwl_sta_alloc_lq(priv, sta_id);
+	link_cmd = iwl_sta_alloc_lq(priv, ctx, sta_id);
 	if (!link_cmd) {
 		IWL_ERR(priv, "Unable to initialize rate scaling for bcast station.\n");
 		return -ENOMEM;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 6d5584a..dcdf225 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -304,6 +304,8 @@ int iwl_sta_rx_agg_start(struct iwl_priv *priv, struct ieee80211_sta *sta,
 int iwl_sta_rx_agg_stop(struct iwl_priv *priv, struct ieee80211_sta *sta,
 			int tid);
 void iwl_sta_modify_sleep_tx_count(struct iwl_priv *priv, int sta_id, int cnt);
+int iwl_update_bcast_station(struct iwl_priv *priv,
+			     struct iwl_rxon_context *ctx);
 int iwl_update_bcast_stations(struct iwl_priv *priv);
 void iwlagn_mac_sta_notify(struct ieee80211_hw *hw,
 			   struct ieee80211_vif *vif,
-- 
1.7.0.4

