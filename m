Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36545 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab0BSNAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 08:00:10 -0500
Subject: Re: [PATCH 2/6] iwlwifi: enable iwl_send_static_wepkey_cmd to sleep
From: Johannes Berg <johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1266570799.3991.52.camel@jlt3.sipsolutions.net>
References: <1266559387-19637-1-git-send-email-reinette.chatre@intel.com>
	 <1266559387-19637-3-git-send-email-reinette.chatre@intel.com>
	 <1266570799.3991.52.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Feb 2010 13:59:59 +0100
Message-ID: <1266584399.14781.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Or probably better would be this:

iwlwifi: change WEP key protection to use mutex

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 4a616c5..f46e7c6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2841,7 +2841,6 @@ static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	mutex_lock(&priv->mutex);
 	iwl_scan_cancel_timeout(priv, 100);
-	mutex_unlock(&priv->mutex);
 
 	/* If we are getting WEP group key and we didn't receive any key mapping
 	 * so far, we are in legacy wep mode (group key only), otherwise we are
@@ -2877,6 +2876,7 @@ static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		ret = -EINVAL;
 	}
 
+	mutex_unlock(&priv->mutex);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 
 	return ret;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 6ac1199..f978037 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1227,7 +1227,7 @@ struct iwl_priv {
 	spinlock_t sta_lock;
 	int num_stations;
 	struct iwl_station_entry stations[IWL_STATION_COUNT];
-	struct iwl_wep_key wep_keys[WEP_KEYS_MAX];
+	struct iwl_wep_key wep_keys[WEP_KEYS_MAX]; /* protected by mutex */
 	u8 default_wep_key;
 	u8 key_mapping_key;
 	unsigned long ucode_key_table;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index b5f4830..1159d88 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -807,6 +807,8 @@ int iwl_send_static_wepkey_cmd(struct iwl_priv *priv, u8 send_if_empty)
 		.flags = CMD_SYNC,
 	};
 
+	might_sleep();
+
 	memset(wep_cmd, 0, cmd_size +
 			(sizeof(struct iwl_wep_key) * WEP_KEYS_MAX));
 
@@ -842,9 +844,9 @@ int iwl_remove_default_wep_key(struct iwl_priv *priv,
 			       struct ieee80211_key_conf *keyconf)
 {
 	int ret;
-	unsigned long flags;
 
-	spin_lock_irqsave(&priv->sta_lock, flags);
+	WARN_ON(!mutex_is_locked(&priv->mutex));
+
 	IWL_DEBUG_WEP(priv, "Removing default WEP key: idx=%d\n",
 		      keyconf->keyidx);
 
@@ -856,13 +858,12 @@ int iwl_remove_default_wep_key(struct iwl_priv *priv,
 	memset(&priv->wep_keys[keyconf->keyidx], 0, sizeof(priv->wep_keys[0]));
 	if (iwl_is_rfkill(priv)) {
 		IWL_DEBUG_WEP(priv, "Not sending REPLY_WEPKEY command due to RFKILL.\n");
-		spin_unlock_irqrestore(&priv->sta_lock, flags);
+		/* but keys in device are clear anyway so return success */
 		return 0;
 	}
 	ret = iwl_send_static_wepkey_cmd(priv, 1);
 	IWL_DEBUG_WEP(priv, "Remove default WEP key: idx=%d ret=%d\n",
 		      keyconf->keyidx, ret);
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
 	return ret;
 }
@@ -872,7 +873,8 @@ int iwl_set_default_wep_key(struct iwl_priv *priv,
 			    struct ieee80211_key_conf *keyconf)
 {
 	int ret;
-	unsigned long flags;
+
+	WARN_ON(!mutex_is_locked(&priv->mutex));
 
 	if (keyconf->keylen != WEP_KEY_LEN_128 &&
 	    keyconf->keylen != WEP_KEY_LEN_64) {
@@ -884,12 +886,11 @@ int iwl_set_default_wep_key(struct iwl_priv *priv,
 	keyconf->hw_key_idx = HW_KEY_DEFAULT;
 	priv->stations[IWL_AP_ID].keyinfo.alg = ALG_WEP;
 
-	spin_lock_irqsave(&priv->sta_lock, flags);
 	priv->default_wep_key++;
 
 	if (test_and_set_bit(keyconf->keyidx, &priv->ucode_key_table))
 		IWL_ERR(priv, "index %d already used in uCode key table.\n",
-			keyconf->keyidx);
+			  keyconf->keyidx);
 
 	priv->wep_keys[keyconf->keyidx].key_size = keyconf->keylen;
 	memcpy(&priv->wep_keys[keyconf->keyidx].key, &keyconf->key,
@@ -898,7 +899,6 @@ int iwl_set_default_wep_key(struct iwl_priv *priv,
 	ret = iwl_send_static_wepkey_cmd(priv, 0);
 	IWL_DEBUG_WEP(priv, "Set default WEP key: len=%d idx=%d ret=%d\n",
 		keyconf->keylen, keyconf->keyidx, ret);
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 6665236..23f1ff2 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3342,7 +3342,6 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	mutex_lock(&priv->mutex);
 	iwl_scan_cancel_timeout(priv, 100);
-	mutex_unlock(&priv->mutex);
 
 	switch (cmd) {
 	case SET_KEY:
@@ -3363,6 +3362,7 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		ret = -EINVAL;
 	}
 
+	mutex_unlock(&priv->mutex);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 
 	return ret;


