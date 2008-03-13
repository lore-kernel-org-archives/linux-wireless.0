Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39081 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007AbYCMAIt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2008 20:08:49 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 3/5] iwlwifi-2.6: Cleans up set_key flow
Date: Wed, 12 Mar 2008 17:06:00 -0700
Message-Id: <1205366762-12828-4-git-send-email-reinette.chatre@intel.com> (sfid-20080313_000854_554185_88B9D199)
In-Reply-To: <1205366762-12828-3-git-send-email-reinette.chatre@intel.com>
References: <1205366762-12828-1-git-send-email-reinette.chatre@intel.com>
 <1205366762-12828-2-git-send-email-reinette.chatre@intel.com>
 <1205366762-12828-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch cleans up the set_key flow. Rxon with hw encryption bit set is
not sent upon each call to set_key. Separation is made between global key
(WEP) and dynamic key (TKIP + CCMP and WEP in some cases).

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-commands.h |    1 +
 drivers/net/wireless/iwlwifi/iwl4965-base.c      |  159 ++++++++++++++-------
 2 files changed, 107 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
index 1025ffe..085d813 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-commands.h
@@ -741,6 +741,7 @@ struct iwl4965_qosparam_cmd {
 /* wep key in STA: 5-bytes (0) or 13-bytes (1) */
 #define STA_KEY_FLG_KEY_SIZE_MSK     __constant_cpu_to_le16(0x1000)
 #define STA_KEY_MULTICAST_MSK        __constant_cpu_to_le16(0x4000)
+#define STA_KEY_MAX_NUM		8
 
 /* Flags indicate whether to modify vs. don't change various station params */
 #define	STA_MODIFY_KEY_MASK		0x01
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 396940e..d47941d 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -815,6 +815,17 @@ out:
 	return ret;
 }
 
+static void iwl4965_set_rxon_hwcrypto(struct iwl_priv *priv, int hw_decrypt)
+{
+	struct iwl4965_rxon_cmd *rxon = &priv->staging_rxon;
+
+	if (hw_decrypt)
+		rxon->filter_flags &= ~RXON_FILTER_DIS_DECRYPT_MSK;
+	else
+		rxon->filter_flags |= RXON_FILTER_DIS_DECRYPT_MSK;
+
+}
+
 int iwl4965_send_cmd(struct iwl_priv *priv, struct iwl4965_host_cmd *cmd)
 {
 	if (cmd->meta.flags & CMD_ASYNC)
@@ -1180,6 +1191,7 @@ static int iwl4965_commit_rxon(struct iwl_priv *priv)
 		       le16_to_cpu(priv->staging_rxon.channel),
 		       print_mac(mac, priv->staging_rxon.bssid_addr));
 
+	iwl4965_set_rxon_hwcrypto(priv, iwl4965_param_hwcrypto);
 	/* Apply the new configuration */
 	rc = iwl4965_send_cmd_pdu(priv, REPLY_RXON,
 			      sizeof(struct iwl4965_rxon_cmd), &priv->staging_rxon);
@@ -1392,33 +1404,36 @@ int iwl4965_send_add_station(struct iwl_priv *priv,
 	return rc;
 }
 
-static int iwl4965_update_sta_key_info(struct iwl_priv *priv,
+static int iwl4965_set_ccmp_dynamic_key_info(struct iwl_priv *priv,
 				   struct ieee80211_key_conf *keyconf,
 				   u8 sta_id)
 {
 	unsigned long flags;
 	__le16 key_flags = 0;
 
-	switch (keyconf->alg) {
-	case ALG_CCMP:
-		key_flags |= STA_KEY_FLG_CCMP;
-		key_flags |= cpu_to_le16(
-				keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
-		key_flags &= ~STA_KEY_FLG_INVALID;
-		break;
-	case ALG_TKIP:
-	case ALG_WEP:
-	default:
-		return -EINVAL;
-	}
+	key_flags |= (STA_KEY_FLG_CCMP | STA_KEY_FLG_MAP_KEY_MSK);
+	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
+
+	if (sta_id == priv->hw_setting.bcast_sta_id)
+		key_flags |= STA_KEY_MULTICAST_MSK;
+
+	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+	keyconf->hw_key_idx = sta_id;
+
+	key_flags &= ~STA_KEY_FLG_INVALID;
+
 	spin_lock_irqsave(&priv->sta_lock, flags);
 	priv->stations[sta_id].keyinfo.alg = keyconf->alg;
 	priv->stations[sta_id].keyinfo.keylen = keyconf->keylen;
+
 	memcpy(priv->stations[sta_id].keyinfo.key, keyconf->key,
 	       keyconf->keylen);
 
 	memcpy(priv->stations[sta_id].sta.key.key, keyconf->key,
 	       keyconf->keylen);
+
+	priv->stations[sta_id].sta.key.key_offset
+			= (sta_id % STA_KEY_MAX_NUM);/*FIXME*/
 	priv->stations[sta_id].sta.key.key_flags = key_flags;
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
@@ -1426,8 +1441,15 @@ static int iwl4965_update_sta_key_info(struct iwl_priv *priv,
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
 	IWL_DEBUG_INFO("hwcrypto: modify ucode station key info\n");
-	iwl4965_send_add_station(priv, &priv->stations[sta_id].sta, 0);
-	return 0;
+	return iwl4965_send_add_station(priv,
+				&priv->stations[sta_id].sta, CMD_ASYNC);
+}
+
+static int iwl4965_set_tkip_dynamic_key_info(struct iwl_priv *priv,
+				   struct ieee80211_key_conf *keyconf,
+				   u8 sta_id)
+{
+	return -EOPNOTSUPP;
 }
 
 static int iwl4965_clear_sta_key_info(struct iwl_priv *priv, u8 sta_id)
@@ -1447,6 +1469,46 @@ static int iwl4965_clear_sta_key_info(struct iwl_priv *priv, u8 sta_id)
 	return 0;
 }
 
+static int iwl4965_set_dynamic_key(struct iwl_priv *priv,
+				struct ieee80211_key_conf *key, u8 sta_id)
+{
+	int ret;
+
+	switch (key->alg) {
+	case ALG_CCMP:
+		ret = iwl4965_set_ccmp_dynamic_key_info(priv, key, sta_id);
+		break;
+	case ALG_TKIP:
+		ret = iwl4965_set_tkip_dynamic_key_info(priv, key, sta_id);
+		break;
+	case ALG_WEP:
+		ret = -EOPNOTSUPP;
+		break;
+	default:
+		IWL_ERROR("Unknown alg: %s alg = %d\n", __func__, key->alg);
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static int iwl4965_remove_static_key(struct iwl_priv *priv)
+{
+	int ret = -EOPNOTSUPP;
+
+	return ret;
+}
+
+static int iwl4965_set_static_key(struct iwl_priv *priv,
+				struct ieee80211_key_conf *key)
+{
+	if (key->alg == ALG_WEP)
+		return -EOPNOTSUPP;
+
+	IWL_ERROR("Static key invalid: alg %d\n", key->alg);
+	return -EINVAL;
+}
+
 static void iwl4965_clear_free_frames(struct iwl_priv *priv)
 {
 	struct list_head *element;
@@ -2265,17 +2327,6 @@ static int iwl4965_scan_initiate(struct iwl_priv *priv)
 	return 0;
 }
 
-static int iwl4965_set_rxon_hwcrypto(struct iwl_priv *priv, int hw_decrypt)
-{
-	struct iwl4965_rxon_cmd *rxon = &priv->staging_rxon;
-
-	if (hw_decrypt)
-		rxon->filter_flags &= ~RXON_FILTER_DIS_DECRYPT_MSK;
-	else
-		rxon->filter_flags |= RXON_FILTER_DIS_DECRYPT_MSK;
-
-	return 0;
-}
 
 static void iwl4965_set_flags_for_phymode(struct iwl_priv *priv,
 					  enum ieee80211_band band)
@@ -7566,8 +7617,9 @@ static int iwl4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 {
 	struct iwl_priv *priv = hw->priv;
 	DECLARE_MAC_BUF(mac);
-	int rc = 0;
-	u8 sta_id;
+	int ret = 0;
+	u8 sta_id = IWL_INVALID_STATION;
+	u8 static_key;
 
 	IWL_DEBUG_MAC80211("enter\n");
 
@@ -7580,44 +7632,45 @@ static int iwl4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		/* only support pairwise keys */
 		return -EOPNOTSUPP;
 
-	sta_id = iwl4965_hw_find_station(priv, addr);
-	if (sta_id == IWL_INVALID_STATION) {
-		IWL_DEBUG_MAC80211("leave - %s not in station map.\n",
-				   print_mac(mac, addr));
-		return -EINVAL;
-	}
+	/* FIXME: need to differenciate between static and dynamic key
+	 * in the level of mac80211 */
+	static_key = !iwl4965_is_associated(priv);
 
-	mutex_lock(&priv->mutex);
+	if (!static_key) {
+		sta_id = iwl4965_hw_find_station(priv, addr);
+		if (sta_id == IWL_INVALID_STATION) {
+			IWL_DEBUG_MAC80211("leave - %s not in station map.\n",
+					   print_mac(mac, addr));
+			return -EINVAL;
+		}
+	}
 
 	iwl4965_scan_cancel_timeout(priv, 100);
 
 	switch (cmd) {
-	case  SET_KEY:
-		rc = iwl4965_update_sta_key_info(priv, key, sta_id);
-		if (!rc) {
-			iwl4965_set_rxon_hwcrypto(priv, 1);
-			iwl4965_commit_rxon(priv);
-			key->hw_key_idx = sta_id;
-			IWL_DEBUG_MAC80211("set_key success, using hwcrypto\n");
-			key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
-		}
+	case SET_KEY:
+		if (static_key)
+			ret = iwl4965_set_static_key(priv, key);
+		else
+			ret = iwl4965_set_dynamic_key(priv, key, sta_id);
+
+		IWL_DEBUG_MAC80211("enable hwcrypto key\n");
 		break;
 	case DISABLE_KEY:
-		rc = iwl4965_clear_sta_key_info(priv, sta_id);
-		if (!rc) {
-			iwl4965_set_rxon_hwcrypto(priv, 0);
-			iwl4965_commit_rxon(priv);
-			IWL_DEBUG_MAC80211("disable hwcrypto key\n");
-		}
+		if (static_key)
+			ret = iwl4965_remove_static_key(priv);
+		else
+			ret = iwl4965_clear_sta_key_info(priv, sta_id);
+
+		IWL_DEBUG_MAC80211("disable hwcrypto key\n");
 		break;
 	default:
-		rc = -EINVAL;
+		ret = -EINVAL;
 	}
 
 	IWL_DEBUG_MAC80211("leave\n");
-	mutex_unlock(&priv->mutex);
 
-	return rc;
+	return ret;
 }
 
 static int iwl4965_mac_conf_tx(struct ieee80211_hw *hw, int queue,
-- 
1.5.3.4

