Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:43574 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354Ab0H0Q4s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 12:56:48 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/27] iwlwifi: contextify-stations-completely
Date: Fri, 27 Aug 2010 09:59:33 -0700
Message-Id: <1282928395-32762-6-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The microcode tracks stations per context, so
the driver needs to do that as well for adding,
deleting and restoring them, especially in the
implicit removal case when we send an RXON.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   10 ++++++----
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   10 +++++-----
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   11 +++++++++--
 drivers/net/wireless/iwlwifi/iwl-sta.h      |    5 +++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 6 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 905575c..ba3a9f9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1832,8 +1832,9 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv,
 				  "configuration (%d).\n", rc);
 			return rc;
 		}
-		iwl_clear_ucode_stations(priv);
-		iwl_restore_stations(priv);
+		iwl_clear_ucode_stations(priv,
+					 &priv->contexts[IWL_RXON_CTX_BSS]);
+		iwl_restore_stations(priv, &priv->contexts[IWL_RXON_CTX_BSS]);
 	}
 
 	IWL_DEBUG_INFO(priv, "Sending RXON\n"
@@ -1865,8 +1866,9 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv,
 	memcpy(active_rxon, staging_rxon, sizeof(*active_rxon));
 
 	if (!new_assoc) {
-		iwl_clear_ucode_stations(priv);
-		iwl_restore_stations(priv);
+		iwl_clear_ucode_stations(priv,
+					 &priv->contexts[IWL_RXON_CTX_BSS]);
+		iwl_restore_stations(priv, &priv->contexts[IWL_RXON_CTX_BSS]);
 	}
 
 	/* If we issue a new RXON command which required a tune then we must
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d222278..23db6c3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -163,8 +163,8 @@ int iwl_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 			IWL_ERR(priv, "Error clearing ASSOC_MSK (%d)\n", ret);
 			return ret;
 		}
-		iwl_clear_ucode_stations(priv);
-		iwl_restore_stations(priv);
+		iwl_clear_ucode_stations(priv, ctx);
+		iwl_restore_stations(priv, ctx);
 		ret = iwl_restore_default_wep_keys(priv);
 		if (ret) {
 			IWL_ERR(priv, "Failed to restore WEP keys (%d)\n", ret);
@@ -195,8 +195,8 @@ int iwl_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 		}
 		IWL_DEBUG_INFO(priv, "Return from !new_assoc RXON.\n");
 		memcpy(active_rxon, &ctx->staging, sizeof(*active_rxon));
-		iwl_clear_ucode_stations(priv);
-		iwl_restore_stations(priv);
+		iwl_clear_ucode_stations(priv, ctx);
+		iwl_restore_stations(priv, ctx);
 		ret = iwl_restore_default_wep_keys(priv);
 		if (ret) {
 			IWL_ERR(priv, "Failed to restore WEP keys (%d)\n", ret);
@@ -2830,7 +2830,7 @@ static void __iwl_down(struct iwl_priv *priv)
 	if (priv->cfg->ops->lib->recover_from_tx_stall)
 		del_timer_sync(&priv->monitor_recover);
 
-	iwl_clear_ucode_stations(priv);
+	iwl_clear_ucode_stations(priv, NULL);
 	iwl_dealloc_bcast_stations(priv);
 	iwl_clear_driver_stations(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index f51c07c..da54bd5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -495,7 +495,7 @@ struct iwl_qos_info {
 struct iwl_station_entry {
 	struct iwl_addsta_cmd sta;
 	struct iwl_tid_data tid[MAX_TID_COUNT];
-	u8 used;
+	u8 used, ctxid;
 	struct iwl_hw_key keyinfo;
 	struct iwl_link_quality_cmd *lq;
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index b1275e3..2923562 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -290,6 +290,7 @@ static u8 iwl_prep_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 	station->sta.mode = 0;
 	station->sta.sta.sta_id = sta_id;
 	station->sta.station_flags = 0;
+	station->ctxid = ctx->ctxid;
 
 	/*
 	 * OK to call unconditionally, since local stations (IBSS BSSID
@@ -615,7 +616,8 @@ EXPORT_SYMBOL_GPL(iwl_remove_station);
  * other than explicit station management would cause this in
  * the ucode, e.g. unassociated RXON.
  */
-void iwl_clear_ucode_stations(struct iwl_priv *priv)
+void iwl_clear_ucode_stations(struct iwl_priv *priv,
+			      struct iwl_rxon_context *ctx)
 {
 	int i;
 	unsigned long flags_spin;
@@ -625,6 +627,9 @@ void iwl_clear_ucode_stations(struct iwl_priv *priv)
 
 	spin_lock_irqsave(&priv->sta_lock, flags_spin);
 	for (i = 0; i < priv->hw_params.max_stations; i++) {
+		if (ctx && ctx->ctxid != priv->stations[i].ctxid)
+			continue;
+
 		if (priv->stations[i].used & IWL_STA_UCODE_ACTIVE) {
 			IWL_DEBUG_INFO(priv, "Clearing ucode active for station %d\n", i);
 			priv->stations[i].used &= ~IWL_STA_UCODE_ACTIVE;
@@ -646,7 +651,7 @@ EXPORT_SYMBOL(iwl_clear_ucode_stations);
  *
  * Function sleeps.
  */
-void iwl_restore_stations(struct iwl_priv *priv)
+void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 {
 	struct iwl_addsta_cmd sta_cmd;
 	struct iwl_link_quality_cmd lq;
@@ -664,6 +669,8 @@ void iwl_restore_stations(struct iwl_priv *priv)
 	IWL_DEBUG_ASSOC(priv, "Restoring all known stations ... start.\n");
 	spin_lock_irqsave(&priv->sta_lock, flags_spin);
 	for (i = 0; i < priv->hw_params.max_stations; i++) {
+		if (ctx->ctxid != priv->stations[i].ctxid)
+			continue;
 		if ((priv->stations[i].used & IWL_STA_DRIVER_ACTIVE) &&
 			    !(priv->stations[i].used & IWL_STA_UCODE_ACTIVE)) {
 			IWL_DEBUG_ASSOC(priv, "Restoring sta %pM\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 8a978c6..269a3ed 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -57,8 +57,9 @@ void iwl_update_tkip_key(struct iwl_priv *priv,
 			 struct ieee80211_key_conf *keyconf,
 			 struct ieee80211_sta *sta, u32 iv32, u16 *phase1key);
 
-void iwl_restore_stations(struct iwl_priv *priv);
-void iwl_clear_ucode_stations(struct iwl_priv *priv);
+void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
+void iwl_clear_ucode_stations(struct iwl_priv *priv,
+			      struct iwl_rxon_context *ctx);
 int iwl_alloc_bcast_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 			    bool init_lq);
 void iwl_dealloc_bcast_stations(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 8b07632..630b8d6 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2581,7 +2581,7 @@ static void __iwl3945_down(struct iwl_priv *priv)
 		del_timer_sync(&priv->monitor_recover);
 
 	/* Station information will now be cleared in device */
-	iwl_clear_ucode_stations(priv);
+	iwl_clear_ucode_stations(priv, NULL);
 	iwl_dealloc_bcast_stations(priv);
 	iwl_clear_driver_stations(priv);
 
-- 
1.7.0.4

