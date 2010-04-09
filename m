Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:17339 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756704Ab0DIUJh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 16:09:37 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/12] iwlwifi: make WEP key restoring explicit
Date: Fri,  9 Apr 2010 13:09:19 -0700
Message-Id: <1270843769-30017-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1270843769-30017-1-git-send-email-reinette.chatre@intel.com>
References: <1270843769-30017-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The firmware clears default WEP keys on
transitions to !associated, so we need
to restore them just like stations. This
is rather implicit as part of sending a
station right now, which is odd. Make it
explicit instead and only for agn since
3945 doesn't use hw crypto for WEP.

Due to that, iwl_send_static_wepkey_cmd
is now only used in iwl-sta.c and can be
static.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   25 ++++++++++---------------
 drivers/net/wireless/iwlwifi/iwl-dev.h |    1 -
 drivers/net/wireless/iwlwifi/iwl-sta.c |   14 +++++++++-----
 drivers/net/wireless/iwlwifi/iwl-sta.h |    2 +-
 4 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 978604f..8a3b0ed 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -158,6 +158,11 @@ int iwl_commit_rxon(struct iwl_priv *priv)
 		}
 		iwl_clear_ucode_stations(priv, false);
 		iwl_restore_stations(priv);
+		ret = iwl_restore_default_wep_keys(priv);
+		if (ret) {
+			IWL_ERR(priv, "Failed to restore WEP keys (%d)\n", ret);
+			return ret;
+		}
 	}
 
 	IWL_DEBUG_INFO(priv, "Sending RXON\n"
@@ -185,6 +190,11 @@ int iwl_commit_rxon(struct iwl_priv *priv)
 		memcpy(active_rxon, &priv->staging_rxon, sizeof(*active_rxon));
 		iwl_clear_ucode_stations(priv, false);
 		iwl_restore_stations(priv);
+		ret = iwl_restore_default_wep_keys(priv);
+		if (ret) {
+			IWL_ERR(priv, "Failed to restore WEP keys (%d)\n", ret);
+			return ret;
+		}
 	}
 
 	priv->start_calib = 0;
@@ -3030,19 +3040,6 @@ static void iwl_mac_sta_notify(struct ieee80211_hw *hw,
 	}
 }
 
-/**
- * iwl_restore_wepkeys - Restore WEP keys to device
- */
-static void iwl_restore_wepkeys(struct iwl_priv *priv)
-{
-	mutex_lock(&priv->mutex);
-	if (priv->iw_mode == NL80211_IFTYPE_STATION &&
-	    priv->default_wep_key &&
-	    iwl_send_static_wepkey_cmd(priv, 0))
-		IWL_ERR(priv, "Could not send WEP static key\n");
-	mutex_unlock(&priv->mutex);
-}
-
 static int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif,
 			      struct ieee80211_sta *sta)
@@ -3069,8 +3066,6 @@ static int iwlagn_mac_sta_add(struct ieee80211_hw *hw,
 		return ret;
 	}
 
-	iwl_restore_wepkeys(priv);
-
 	/* Initialize rate scaling */
 	IWL_DEBUG_INFO(priv, "Initializing rate scaling for station %pM\n",
 		       sta->addr);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 4319bda..95c2bc3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1167,7 +1167,6 @@ struct iwl_priv {
 	int num_stations;
 	struct iwl_station_entry stations[IWL_STATION_COUNT];
 	struct iwl_wep_key wep_keys[WEP_KEYS_MAX]; /* protected by mutex */
-	u8 default_wep_key;
 	u8 key_mapping_key;
 	unsigned long ucode_key_table;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index e34ac03..be3d222 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -759,7 +759,7 @@ int iwl_get_free_ucode_key_index(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_get_free_ucode_key_index);
 
-int iwl_send_static_wepkey_cmd(struct iwl_priv *priv, u8 send_if_empty)
+static int iwl_send_static_wepkey_cmd(struct iwl_priv *priv, u8 send_if_empty)
 {
 	int i, not_empty = 0;
 	u8 buff[sizeof(struct iwl_wep_cmd) +
@@ -803,7 +803,14 @@ int iwl_send_static_wepkey_cmd(struct iwl_priv *priv, u8 send_if_empty)
 	else
 		return 0;
 }
-EXPORT_SYMBOL(iwl_send_static_wepkey_cmd);
+
+int iwl_restore_default_wep_keys(struct iwl_priv *priv)
+{
+	WARN_ON(!mutex_is_locked(&priv->mutex));
+
+	return iwl_send_static_wepkey_cmd(priv, 0);
+}
+EXPORT_SYMBOL(iwl_restore_default_wep_keys);
 
 int iwl_remove_default_wep_key(struct iwl_priv *priv,
 			       struct ieee80211_key_conf *keyconf)
@@ -819,7 +826,6 @@ int iwl_remove_default_wep_key(struct iwl_priv *priv,
 		IWL_ERR(priv, "index %d not used in uCode key table.\n",
 			  keyconf->keyidx);
 
-	priv->default_wep_key--;
 	memset(&priv->wep_keys[keyconf->keyidx], 0, sizeof(priv->wep_keys[0]));
 	if (iwl_is_rfkill(priv)) {
 		IWL_DEBUG_WEP(priv, "Not sending REPLY_WEPKEY command due to RFKILL.\n");
@@ -851,8 +857,6 @@ int iwl_set_default_wep_key(struct iwl_priv *priv,
 	keyconf->hw_key_idx = HW_KEY_DEFAULT;
 	priv->stations[IWL_AP_ID].keyinfo.alg = ALG_WEP;
 
-	priv->default_wep_key++;
-
 	if (test_and_set_bit(keyconf->keyidx, &priv->ucode_key_table))
 		IWL_ERR(priv, "index %d already used in uCode key table.\n",
 			  keyconf->keyidx);
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 87a3499..42cd2f4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -44,11 +44,11 @@
  */
 u8 iwl_find_station(struct iwl_priv *priv, const u8 *bssid);
 
-int iwl_send_static_wepkey_cmd(struct iwl_priv *priv, u8 send_if_empty);
 int iwl_remove_default_wep_key(struct iwl_priv *priv,
 			       struct ieee80211_key_conf *key);
 int iwl_set_default_wep_key(struct iwl_priv *priv,
 			    struct ieee80211_key_conf *key);
+int iwl_restore_default_wep_keys(struct iwl_priv *priv);
 int iwl_set_dynamic_key(struct iwl_priv *priv,
 			struct ieee80211_key_conf *key, u8 sta_id);
 int iwl_remove_dynamic_key(struct iwl_priv *priv,
-- 
1.6.3.3

