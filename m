Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60703 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab0BSJN0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 04:13:26 -0500
Subject: Re: [PATCH 2/6] iwlwifi: enable iwl_send_static_wepkey_cmd to sleep
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1266559387-19637-3-git-send-email-reinette.chatre@intel.com>
References: <1266559387-19637-1-git-send-email-reinette.chatre@intel.com>
	 <1266559387-19637-3-git-send-email-reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Feb 2010 10:13:19 +0100
Message-ID: <1266570799.3991.52.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-02-18 at 22:03 -0800, Reinette Chatre wrote:
> From: Reinette Chatre <reinette.chatre@intel.com>
> 
> iwl_send_static_wepkey_cmd is only called from places that are able to
> sleep. Modify it so that it itself is able to sleep.

Oops, this patch seems wrong (was just working on the wep key restore
stuff):

int iwl_remove_default_wep_key(struct iwl_priv *priv,
                               struct ieee80211_key_conf *keyconf)
...
        spin_lock_irqsave(&priv->sta_lock, flags);
...
        ret = iwl_send_static_wepkey_cmd(priv, 1);
...
        spin_unlock_irqrestore(&priv->sta_lock, flags);

and same in iwl_set_default_wep_key().


How about this in addition? Changes protection from sta_lock to mutex
for wep keys (untested!).

johannes

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 1d8c940..d0a2e7d 100644
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
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 18cf981..e544be9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -806,6 +806,8 @@ int iwl_send_static_wepkey_cmd(struct iwl_priv *priv, u8 send_if_empty)
 		.flags = CMD_SYNC,
 	};
 
+	might_sleep();
+
 	memset(wep_cmd, 0, cmd_size +
 			(sizeof(struct iwl_wep_key) * WEP_KEYS_MAX));
 
@@ -841,27 +843,28 @@ int iwl_remove_default_wep_key(struct iwl_priv *priv,
 			       struct ieee80211_key_conf *keyconf)
 {
 	int ret;
-	unsigned long flags;
 
-	spin_lock_irqsave(&priv->sta_lock, flags);
+	WARN_ON(!mutex_is_locked(&priv->mutex));
+
 	IWL_DEBUG_WEP(priv, "Removing default WEP key: idx=%d\n",
 		      keyconf->keyidx);
 
-	if (!test_and_clear_bit(keyconf->keyidx, &priv->ucode_key_table))
+	if (!test_and_clear_bit(keyconf->keyidx, &priv->ucode_key_table)) {
 		IWL_ERR(priv, "index %d not used in uCode key table.\n",
-			  keyconf->keyidx);
+			keyconf->keyidx);
+		return -ENOENT;
+	}
 
 	priv->default_wep_key--;
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
@@ -871,7 +874,8 @@ int iwl_set_default_wep_key(struct iwl_priv *priv,
 			    struct ieee80211_key_conf *keyconf)
 {
 	int ret;
-	unsigned long flags;
+
+	WARN_ON(!mutex_is_locked(&priv->mutex));
 
 	if (keyconf->keylen != WEP_KEY_LEN_128 &&
 	    keyconf->keylen != WEP_KEY_LEN_64) {
@@ -883,12 +887,13 @@ int iwl_set_default_wep_key(struct iwl_priv *priv,
 	keyconf->hw_key_idx = HW_KEY_DEFAULT;
 	priv->stations[IWL_AP_ID].keyinfo.alg = ALG_WEP;
 
-	spin_lock_irqsave(&priv->sta_lock, flags);
 	priv->default_wep_key++;
 
-	if (test_and_set_bit(keyconf->keyidx, &priv->ucode_key_table))
+	if (test_and_set_bit(keyconf->keyidx, &priv->ucode_key_table)) {
 		IWL_ERR(priv, "index %d already used in uCode key table.\n",
 			keyconf->keyidx);
+		return -EBUSY;
+	}
 
 	priv->wep_keys[keyconf->keyidx].key_size = keyconf->keylen;
 	memcpy(&priv->wep_keys[keyconf->keyidx].key, &keyconf->key,
@@ -897,7 +902,6 @@ int iwl_set_default_wep_key(struct iwl_priv *priv,
 	ret = iwl_send_static_wepkey_cmd(priv, 0);
 	IWL_DEBUG_WEP(priv, "Set default WEP key: len=%d idx=%d ret=%d\n",
 		keyconf->keylen, keyconf->keyidx, ret);
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
 	return ret;
 }


