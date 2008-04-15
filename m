Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54268 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbYDOEQT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 00:16:19 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 07/12] iwlwifi: moves security functions to iwl-sta.c
Date: Mon, 14 Apr 2008 21:16:09 -0700
Message-Id: <1208232974-3828-8-git-send-email-reinette.chatre@intel.com> (sfid-20080415_051628_483263_0084DC09)
In-Reply-To: <1208232974-3828-7-git-send-email-reinette.chatre@intel.com>
References: <1208232974-3828-1-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-2-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-3-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-4-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-5-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-6-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-7-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch moves security related functions to iwl-sta.c.
Note that iwl4965_mac_update_tkip_key is still in iwl4965-base.c since it
is a mac80211 handler.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-sta.c      |  119 ++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-sta.h      |    7 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |  120 +--------------------------
 3 files changed, 123 insertions(+), 123 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 41238f2..8765358 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -139,7 +139,7 @@ int iwl_set_default_wep_key(struct iwl_priv *priv,
 	return ret;
 }
 
-int iwl_set_wep_dynamic_key_info(struct iwl_priv *priv,
+static int iwl_set_wep_dynamic_key_info(struct iwl_priv *priv,
 				struct ieee80211_key_conf *keyconf,
 				u8 sta_id)
 {
@@ -186,3 +186,120 @@ int iwl_set_wep_dynamic_key_info(struct iwl_priv *priv,
 
 	return ret;
 }
+
+static int iwl_set_ccmp_dynamic_key_info(struct iwl_priv *priv,
+				   struct ieee80211_key_conf *keyconf,
+				   u8 sta_id)
+{
+	unsigned long flags;
+	__le16 key_flags = 0;
+
+	key_flags |= (STA_KEY_FLG_CCMP | STA_KEY_FLG_MAP_KEY_MSK);
+	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
+	key_flags &= ~STA_KEY_FLG_INVALID;
+
+	if (sta_id == priv->hw_setting.bcast_sta_id)
+		key_flags |= STA_KEY_MULTICAST_MSK;
+
+	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+	keyconf->hw_key_idx = keyconf->keyidx;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	priv->stations[sta_id].keyinfo.alg = keyconf->alg;
+	priv->stations[sta_id].keyinfo.keylen = keyconf->keylen;
+
+	memcpy(priv->stations[sta_id].keyinfo.key, keyconf->key,
+	       keyconf->keylen);
+
+	memcpy(priv->stations[sta_id].sta.key.key, keyconf->key,
+	       keyconf->keylen);
+
+	priv->stations[sta_id].sta.key.key_offset =
+				iwl_get_free_ucode_key_index(priv);
+	priv->stations[sta_id].sta.key.key_flags = key_flags;
+	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
+	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	IWL_DEBUG_INFO("hwcrypto: modify ucode station key info\n");
+	return iwl4965_send_add_station(priv,
+				&priv->stations[sta_id].sta, CMD_ASYNC);
+}
+
+static int iwl_set_tkip_dynamic_key_info(struct iwl_priv *priv,
+				   struct ieee80211_key_conf *keyconf,
+				   u8 sta_id)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
+	keyconf->hw_key_idx = keyconf->keyidx;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+
+	priv->stations[sta_id].keyinfo.alg = keyconf->alg;
+	priv->stations[sta_id].keyinfo.conf = keyconf;
+	priv->stations[sta_id].keyinfo.keylen = 16;
+
+	/* This copy is acutally not needed: we get the key with each TX */
+	memcpy(priv->stations[sta_id].keyinfo.key, keyconf->key, 16);
+
+	memcpy(priv->stations[sta_id].sta.key.key, keyconf->key, 16);
+
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	return ret;
+}
+
+int iwl_remove_dynamic_key(struct iwl_priv *priv, u8 sta_id)
+{
+	unsigned long flags;
+
+	priv->key_mapping_key = 0;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	if (!test_and_clear_bit(priv->stations[sta_id].sta.key.key_offset,
+		&priv->ucode_key_table))
+		IWL_ERROR("index %d not used in uCode key table.\n",
+			priv->stations[sta_id].sta.key.key_offset);
+	memset(&priv->stations[sta_id].keyinfo, 0,
+					sizeof(struct iwl4965_hw_key));
+	memset(&priv->stations[sta_id].sta.key, 0,
+					sizeof(struct iwl4965_keyinfo));
+	priv->stations[sta_id].sta.key.key_flags = STA_KEY_FLG_NO_ENC;
+	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
+	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	IWL_DEBUG_INFO("hwcrypto: clear ucode station key info\n");
+	return iwl4965_send_add_station(priv, &priv->stations[sta_id].sta, 0);
+}
+
+int iwl_set_dynamic_key(struct iwl_priv *priv,
+				struct ieee80211_key_conf *key, u8 sta_id)
+{
+	int ret;
+
+	priv->key_mapping_key = 1;
+
+	switch (key->alg) {
+	case ALG_CCMP:
+		ret = iwl_set_ccmp_dynamic_key_info(priv, key, sta_id);
+		break;
+	case ALG_TKIP:
+		ret = iwl_set_tkip_dynamic_key_info(priv, key, sta_id);
+		break;
+	case ALG_WEP:
+		ret = iwl_set_wep_dynamic_key_info(priv, key, sta_id);
+		break;
+	default:
+		IWL_ERROR("Unknown alg: %s alg = %d\n", __func__, key->alg);
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 3f1b205..44f272e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -43,8 +43,7 @@ int iwl_remove_default_wep_key(struct iwl_priv *priv,
 				struct ieee80211_key_conf *key);
 int iwl_set_default_wep_key(struct iwl_priv *priv,
 				struct ieee80211_key_conf *key);
-int iwl_set_wep_dynamic_key_info(struct iwl_priv *priv,
-				struct ieee80211_key_conf *keyconf,
-				u8 sta_id);
-
+int iwl_remove_dynamic_key(struct iwl_priv *priv, u8 sta_id);
+int iwl_set_dynamic_key(struct iwl_priv *priv,
+				struct ieee80211_key_conf *key, u8 sta_id);
 #endif /* __iwl_sta_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index da01896..bfefb05 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1112,122 +1112,6 @@ int iwl4965_send_add_station(struct iwl_priv *priv,
 	return rc;
 }
 
-static int iwl4965_set_ccmp_dynamic_key_info(struct iwl_priv *priv,
-				   struct ieee80211_key_conf *keyconf,
-				   u8 sta_id)
-{
-	unsigned long flags;
-	__le16 key_flags = 0;
-
-	key_flags |= (STA_KEY_FLG_CCMP | STA_KEY_FLG_MAP_KEY_MSK);
-	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
-
-	if (sta_id == priv->hw_setting.bcast_sta_id)
-		key_flags |= STA_KEY_MULTICAST_MSK;
-
-	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
-	keyconf->hw_key_idx = keyconf->keyidx;
-
-	key_flags &= ~STA_KEY_FLG_INVALID;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-	priv->stations[sta_id].keyinfo.alg = keyconf->alg;
-	priv->stations[sta_id].keyinfo.keylen = keyconf->keylen;
-
-	memcpy(priv->stations[sta_id].keyinfo.key, keyconf->key,
-	       keyconf->keylen);
-
-	memcpy(priv->stations[sta_id].sta.key.key, keyconf->key,
-	       keyconf->keylen);
-
-	priv->stations[sta_id].sta.key.key_offset =
-				iwl_get_free_ucode_key_index(priv);
-	priv->stations[sta_id].sta.key.key_flags = key_flags;
-	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
-	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
-
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-
-	IWL_DEBUG_INFO("hwcrypto: modify ucode station key info\n");
-	return iwl4965_send_add_station(priv,
-				&priv->stations[sta_id].sta, CMD_ASYNC);
-}
-
-static int iwl4965_set_tkip_dynamic_key_info(struct iwl_priv *priv,
-				   struct ieee80211_key_conf *keyconf,
-				   u8 sta_id)
-{
-	unsigned long flags;
-	int ret = 0;
-
-	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
-	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
-	keyconf->hw_key_idx = keyconf->keyidx;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-
-	priv->stations[sta_id].keyinfo.alg = keyconf->alg;
-	priv->stations[sta_id].keyinfo.conf = keyconf;
-	priv->stations[sta_id].keyinfo.keylen = 16;
-
-	/* This copy is acutally not needed: we get the key with each TX */
-	memcpy(priv->stations[sta_id].keyinfo.key, keyconf->key, 16);
-
-	memcpy(priv->stations[sta_id].sta.key.key, keyconf->key, 16);
-
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-
-	return ret;
-}
-
-static int iwl4965_clear_sta_key_info(struct iwl_priv *priv, u8 sta_id)
-{
-	unsigned long flags;
-
-	priv->key_mapping_key = 0;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-	if (!test_and_clear_bit(priv->stations[sta_id].sta.key.key_offset,
-		&priv->ucode_key_table))
-		IWL_ERROR("index %d not used in uCode key table.\n",
-			priv->stations[sta_id].sta.key.key_offset);
-	memset(&priv->stations[sta_id].keyinfo, 0, sizeof(struct iwl4965_hw_key));
-	memset(&priv->stations[sta_id].sta.key, 0, sizeof(struct iwl4965_keyinfo));
-	priv->stations[sta_id].sta.key.key_flags = STA_KEY_FLG_NO_ENC;
-	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
-	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-
-	IWL_DEBUG_INFO("hwcrypto: clear ucode station key info\n");
-	iwl4965_send_add_station(priv, &priv->stations[sta_id].sta, 0);
-	return 0;
-}
-
-static int iwl4965_set_dynamic_key(struct iwl_priv *priv,
-				struct ieee80211_key_conf *key, u8 sta_id)
-{
-	int ret;
-
-	priv->key_mapping_key = 1;
-
-	switch (key->alg) {
-	case ALG_CCMP:
-		ret = iwl4965_set_ccmp_dynamic_key_info(priv, key, sta_id);
-		break;
-	case ALG_TKIP:
-		ret = iwl4965_set_tkip_dynamic_key_info(priv, key, sta_id);
-		break;
-	case ALG_WEP:
-		ret = iwl_set_wep_dynamic_key_info(priv, key, sta_id);
-		break;
-	default:
-		IWL_ERROR("Unknown alg: %s alg = %d\n", __func__, key->alg);
-		ret = -EINVAL;
-	}
-
-	return ret;
-}
-
 static void iwl4965_clear_free_frames(struct iwl_priv *priv)
 {
 	struct list_head *element;
@@ -7043,7 +6927,7 @@ static int iwl4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		if (is_default_wep_key)
 			ret = iwl_set_default_wep_key(priv, key);
 		else
-			ret = iwl4965_set_dynamic_key(priv, key, sta_id);
+			ret = iwl_set_dynamic_key(priv, key, sta_id);
 
 		IWL_DEBUG_MAC80211("enable hwcrypto key\n");
 		break;
@@ -7051,7 +6935,7 @@ static int iwl4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		if (is_default_wep_key)
 			ret = iwl_remove_default_wep_key(priv, key);
 		else
-			ret = iwl4965_clear_sta_key_info(priv, sta_id);
+			ret = iwl_remove_dynamic_key(priv, sta_id);
 
 		IWL_DEBUG_MAC80211("disable hwcrypto key\n");
 		break;
-- 
1.5.3.4

