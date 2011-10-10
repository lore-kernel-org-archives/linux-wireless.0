Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54032 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab1JJPQa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 11:16:30 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 25/34] iwlagn: add debug for mac80211 callback
Date: Mon, 10 Oct 2011 07:27:10 -0700
Message-Id: <1318256839-31837-26-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111010_171634_911176_10CCD5E9)
In-Reply-To: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add IWL_DEBUG_MAC80211 debug for all mac80211 callback function

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    4 ++-
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c  |    3 ++
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   32 +++++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-core.c     |    4 +++
 drivers/net/wireless/iwlwifi/iwl-sta.c      |    6 +++-
 5 files changed, 40 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index ca632f9..8155522 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -539,7 +539,7 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 	const struct iwl_channel_info *ch_info;
 	int ret = 0;
 
-	IWL_DEBUG_MAC80211(priv, "changed %#x", changed);
+	IWL_DEBUG_MAC80211(priv, "enter: changed %#x", changed);
 
 	mutex_lock(&priv->shrd->mutex);
 
@@ -657,6 +657,8 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 	}
  out:
 	mutex_unlock(&priv->shrd->mutex);
+	IWL_DEBUG_MAC80211(priv, "leave\n");
+
 	return ret;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 8e7177b..c1807fa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -685,6 +685,8 @@ void iwlagn_mac_sta_notify(struct ieee80211_hw *hw,
 	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
 	int sta_id;
 
+	IWL_DEBUG_MAC80211(priv, "enter\n");
+
 	switch (cmd) {
 	case STA_NOTIFY_SLEEP:
 		WARN_ON(!sta_priv->client);
@@ -704,4 +706,5 @@ void iwlagn_mac_sta_notify(struct ieee80211_hw *hw,
 	default:
 		break;
 	}
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index f00484e..dccb230 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1855,6 +1855,7 @@ static void iwlagn_mac_set_rekey_data(struct ieee80211_hw *hw,
 	if (iwlagn_mod_params.sw_crypto)
 		return;
 
+	IWL_DEBUG_MAC80211(priv, "enter\n");
 	mutex_lock(&priv->shrd->mutex);
 
 	if (priv->contexts[IWL_RXON_CTX_BSS].vif != vif)
@@ -1867,6 +1868,7 @@ static void iwlagn_mac_set_rekey_data(struct ieee80211_hw *hw,
 
  out:
 	mutex_unlock(&priv->shrd->mutex);
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
 struct wowlan_key_data {
@@ -2034,6 +2036,7 @@ static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
 	if (WARN_ON(!wowlan))
 		return -EINVAL;
 
+	IWL_DEBUG_MAC80211(priv, "enter\n");
 	mutex_lock(&priv->shrd->mutex);
 
 	/* Don't attempt WoWLAN when not associated, tear down instead. */
@@ -2203,6 +2206,8 @@ static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
  out:
 	mutex_unlock(&priv->shrd->mutex);
 	kfree(key_data.rsc_tsc);
+	IWL_DEBUG_MAC80211(priv, "leave\n");
+
 	return ret;
 }
 
@@ -2215,6 +2220,7 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 	u32 base, status = 0xffffffff;
 	int ret = -EIO;
 
+	IWL_DEBUG_MAC80211(priv, "enter\n");
 	mutex_lock(&priv->shrd->mutex);
 
 	iwl_write32(bus(priv), CSR_UCODE_DRV_GP1_CLR,
@@ -2260,6 +2266,7 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 	iwlagn_set_rxon_chain(priv, ctx);
 
 	mutex_unlock(&priv->shrd->mutex);
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 
 	ieee80211_resume_disconnect(vif);
 
@@ -2402,6 +2409,7 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 	if (!(priv->cfg->sku & EEPROM_SKU_CAP_11N_ENABLE))
 		return -EACCES;
 
+	IWL_DEBUG_MAC80211(priv, "enter\n");
 	mutex_lock(&priv->shrd->mutex);
 
 	switch (action) {
@@ -2492,7 +2500,7 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 		break;
 	}
 	mutex_unlock(&priv->shrd->mutex);
-
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 	return ret;
 }
 
@@ -2504,10 +2512,10 @@ static int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
 	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
 	bool is_ap = vif->type == NL80211_IFTYPE_STATION;
-	int ret;
+	int ret = 0;
 	u8 sta_id;
 
-	IWL_DEBUG_INFO(priv, "received request to add station %pM\n",
+	IWL_DEBUG_MAC80211(priv, "received request to add station %pM\n",
 			sta->addr);
 	mutex_lock(&priv->shrd->mutex);
 	IWL_DEBUG_INFO(priv, "proceeding to add station %pM\n",
@@ -2524,8 +2532,7 @@ static int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
 		IWL_ERR(priv, "Unable to add station %pM (%d)\n",
 			sta->addr, ret);
 		/* Should we return success if return code is EEXIST ? */
-		mutex_unlock(&priv->shrd->mutex);
-		return ret;
+		goto out;
 	}
 
 	sta_priv->sta_id = sta_id;
@@ -2534,9 +2541,11 @@ static int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
 	IWL_DEBUG_INFO(priv, "Initializing rate scaling for station %pM\n",
 		       sta->addr);
 	iwl_rs_rate_init(priv, sta, sta_id);
+ out:
 	mutex_unlock(&priv->shrd->mutex);
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 
-	return 0;
+	return ret;
 }
 
 static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
@@ -2767,6 +2776,7 @@ static int iwl_mac_remain_on_channel(struct ieee80211_hw *hw,
 	if (!(ctx->interface_modes & BIT(NL80211_IFTYPE_P2P_CLIENT)))
 		return -EOPNOTSUPP;
 
+	IWL_DEBUG_MAC80211(priv, "enter\n");
 	mutex_lock(&priv->shrd->mutex);
 
 	if (test_bit(STATUS_SCAN_HW, &priv->shrd->status)) {
@@ -2810,6 +2820,7 @@ static int iwl_mac_remain_on_channel(struct ieee80211_hw *hw,
 
  out:
 	mutex_unlock(&priv->shrd->mutex);
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 
 	return err;
 }
@@ -2821,10 +2832,12 @@ static int iwl_mac_cancel_remain_on_channel(struct ieee80211_hw *hw)
 	if (!(priv->shrd->valid_contexts & BIT(IWL_RXON_CTX_PAN)))
 		return -EOPNOTSUPP;
 
+	IWL_DEBUG_MAC80211(priv, "enter\n");
 	mutex_lock(&priv->shrd->mutex);
 	iwl_scan_cancel_timeout(priv, priv->hw_roc_duration);
 	iwlagn_disable_roc(priv);
 	mutex_unlock(&priv->shrd->mutex);
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 
 	return 0;
 }
@@ -2838,6 +2851,7 @@ static int iwl_mac_tx_sync(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	int ret;
 	u8 sta_id;
 
+	IWL_DEBUG_MAC80211(priv, "enter\n");
 	mutex_lock(&priv->shrd->mutex);
 
 	if (iwl_is_associated_ctx(ctx)) {
@@ -2871,6 +2885,8 @@ static int iwl_mac_tx_sync(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	iwl_remove_station(priv, sta_id, bssid);
  out:
 	mutex_unlock(&priv->shrd->mutex);
+	IWL_DEBUG_MAC80211(priv, "leave\n");
+
 	return ret;
 }
 
@@ -2883,6 +2899,7 @@ static void iwl_mac_finish_tx_sync(struct ieee80211_hw *hw,
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
 	struct iwl_rxon_context *ctx = vif_priv->ctx;
 
+	IWL_DEBUG_MAC80211(priv, "enter\n");
 	mutex_lock(&priv->shrd->mutex);
 
 	if (iwl_is_associated_ctx(ctx))
@@ -2893,6 +2910,7 @@ static void iwl_mac_finish_tx_sync(struct ieee80211_hw *hw,
 	/* no need to commit */
  out:
 	mutex_unlock(&priv->shrd->mutex);
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
 /*****************************************************************************
@@ -3054,6 +3072,7 @@ static void iwl_mac_rssi_callback(struct ieee80211_hw *hw,
 {
 	struct iwl_priv *priv = hw->priv;
 
+	IWL_DEBUG_MAC80211(priv, "enter\n");
 	mutex_lock(&priv->shrd->mutex);
 
 	if (priv->cfg->bt_params &&
@@ -3070,6 +3089,7 @@ static void iwl_mac_rssi_callback(struct ieee80211_hw *hw,
 	}
 
 	mutex_unlock(&priv->shrd->mutex);
+	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
 static int iwl_mac_set_tim(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 132fbfc..20e56ec 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1662,6 +1662,8 @@ int iwl_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	u32 interface_modes;
 	int err;
 
+	IWL_DEBUG_MAC80211(priv, "enter\n");
+
 	newtype = ieee80211_iftype_p2p(newtype, newp2p);
 
 	mutex_lock(&priv->shrd->mutex);
@@ -1729,6 +1731,8 @@ int iwl_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
  out:
 	mutex_unlock(&priv->shrd->mutex);
+	IWL_DEBUG_MAC80211(priv, "leave\n");
+
 	return err;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 23a9364..07b72f2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -823,8 +823,8 @@ int iwl_mac_sta_remove(struct ieee80211_hw *hw,
 	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
 	int ret;
 
-	IWL_DEBUG_INFO(priv, "received request to remove station %pM\n",
-			sta->addr);
+	IWL_DEBUG_MAC80211(priv, "enter: received request to remove "
+			   "station %pM\n", sta->addr);
 	mutex_lock(&priv->shrd->mutex);
 	IWL_DEBUG_INFO(priv, "proceeding to remove station %pM\n",
 			sta->addr);
@@ -833,5 +833,7 @@ int iwl_mac_sta_remove(struct ieee80211_hw *hw,
 		IWL_ERR(priv, "Error removing station %pM\n",
 			sta->addr);
 	mutex_unlock(&priv->shrd->mutex);
+	IWL_DEBUG_MAC80211(priv, "leave\n");
+
 	return ret;
 }
-- 
1.7.0.4

