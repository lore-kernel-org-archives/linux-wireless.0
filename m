Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:57656 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511Ab0CJFWH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 00:22:07 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 18/24] iwlwifi: change WEP key protection to use mutex
Date: Tue,  9 Mar 2010 21:21:46 -0800
Message-Id: <1268198512-6572-19-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
References: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For later station notification support we would like WEP key setting to be
done synchronously always. Currently all places from which WEP key is set
can sleep, but the usage of sta_lock prevents it to do so. Modify the
locking to use priv->mutex instead and thus enable this call to sleep.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   18 +++++++++---------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index bc84fd4..d6e1a05 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2869,7 +2869,6 @@ static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	mutex_lock(&priv->mutex);
 	iwl_scan_cancel_timeout(priv, 100);
-	mutex_unlock(&priv->mutex);
 
 	/* If we are getting WEP group key and we didn't receive any key mapping
 	 * so far, we are in legacy wep mode (group key only), otherwise we are
@@ -2905,6 +2904,7 @@ static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		ret = -EINVAL;
 	}
 
+	mutex_unlock(&priv->mutex);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 
 	return ret;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 90d2b6e..bac8e7c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1220,7 +1220,7 @@ struct iwl_priv {
 	spinlock_t sta_lock;
 	int num_stations;
 	struct iwl_station_entry stations[IWL_STATION_COUNT];
-	struct iwl_wep_key wep_keys[WEP_KEYS_MAX];
+	struct iwl_wep_key wep_keys[WEP_KEYS_MAX]; /* protected by mutex */
 	u8 default_wep_key;
 	u8 key_mapping_key;
 	unsigned long ucode_key_table;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 4a6686f..b1aad30 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -549,9 +549,11 @@ int iwl_send_static_wepkey_cmd(struct iwl_priv *priv, u8 send_if_empty)
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_WEPKEY,
 		.data = wep_cmd,
-		.flags = CMD_ASYNC,
+		.flags = CMD_SYNC,
 	};
 
+	might_sleep();
+
 	memset(wep_cmd, 0, cmd_size +
 			(sizeof(struct iwl_wep_key) * WEP_KEYS_MAX));
 
@@ -587,9 +589,9 @@ int iwl_remove_default_wep_key(struct iwl_priv *priv,
 			       struct ieee80211_key_conf *keyconf)
 {
 	int ret;
-	unsigned long flags;
 
-	spin_lock_irqsave(&priv->sta_lock, flags);
+	WARN_ON(!mutex_is_locked(&priv->mutex));
+
 	IWL_DEBUG_WEP(priv, "Removing default WEP key: idx=%d\n",
 		      keyconf->keyidx);
 
@@ -601,13 +603,12 @@ int iwl_remove_default_wep_key(struct iwl_priv *priv,
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
@@ -617,7 +618,8 @@ int iwl_set_default_wep_key(struct iwl_priv *priv,
 			    struct ieee80211_key_conf *keyconf)
 {
 	int ret;
-	unsigned long flags;
+
+	WARN_ON(!mutex_is_locked(&priv->mutex));
 
 	if (keyconf->keylen != WEP_KEY_LEN_128 &&
 	    keyconf->keylen != WEP_KEY_LEN_64) {
@@ -629,12 +631,11 @@ int iwl_set_default_wep_key(struct iwl_priv *priv,
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
@@ -643,7 +644,6 @@ int iwl_set_default_wep_key(struct iwl_priv *priv,
 	ret = iwl_send_static_wepkey_cmd(priv, 0);
 	IWL_DEBUG_WEP(priv, "Set default WEP key: len=%d idx=%d ret=%d\n",
 		keyconf->keylen, keyconf->keyidx, ret);
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 2fd1b3d..dd33251 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3344,7 +3344,6 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	mutex_lock(&priv->mutex);
 	iwl_scan_cancel_timeout(priv, 100);
-	mutex_unlock(&priv->mutex);
 
 	switch (cmd) {
 	case SET_KEY:
@@ -3365,6 +3364,7 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		ret = -EINVAL;
 	}
 
+	mutex_unlock(&priv->mutex);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 
 	return ret;
-- 
1.6.3.3

