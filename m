Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:2446 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540AbZB1AQv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 19:16:51 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/6] iwl3945: unify set key flow with iwlwifi
Date: Fri, 27 Feb 2009 16:21:21 -0800
Message-Id: <1235780484-27979-4-git-send-email-reinette.chatre@intel.com> (sfid-20090228_011658_135931_94298277)
In-Reply-To: <1235780484-27979-3-git-send-email-reinette.chatre@intel.com>
References: <1235780484-27979-1-git-send-email-reinette.chatre@intel.com>
 <1235780484-27979-2-git-send-email-reinette.chatre@intel.com>
 <1235780484-27979-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

unify the set key flow with iwlwifi.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Acked-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-sta.c      |    3 +-
 drivers/net/wireless/iwlwifi/iwl-sta.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  172 ++++++++++++++++++---------
 3 files changed, 121 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 1fae3a6..0ea08d0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -490,7 +490,7 @@ void iwl_clear_stations_table(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_clear_stations_table);
 
-static int iwl_get_free_ucode_key_index(struct iwl_priv *priv)
+int iwl_get_free_ucode_key_index(struct iwl_priv *priv)
 {
 	int i;
 
@@ -500,6 +500,7 @@ static int iwl_get_free_ucode_key_index(struct iwl_priv *priv)
 
 	return WEP_INVALID_OFFSET;
 }
+EXPORT_SYMBOL(iwl_get_free_ucode_key_index);
 
 int iwl_send_static_wepkey_cmd(struct iwl_priv *priv, u8 send_if_empty)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index 97f6169..59a586b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -54,6 +54,7 @@ void iwl_update_tkip_key(struct iwl_priv *priv,
 int iwl_rxon_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap);
 int iwl_remove_station(struct iwl_priv *priv, const u8 *addr, int is_ap);
 void iwl_clear_stations_table(struct iwl_priv *priv);
+int iwl_get_free_ucode_key_index(struct iwl_priv *priv);
 int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr);
 int iwl_get_ra_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr);
 int iwl_send_add_sta(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 443c00e..18735aa 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -407,6 +407,8 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 	staging_rxon->reserved4 = 0;
 	staging_rxon->reserved5 = 0;
 
+	iwl_set_rxon_hwcrypto(priv, !priv->hw_params.sw_crypto);
+
 	/* Apply the new configuration */
 	rc = iwl_send_cmd_pdu(priv, REPLY_RXON,
 			      sizeof(struct iwl3945_rxon_cmd),
@@ -456,25 +458,24 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 	return 0;
 }
 
-static int iwl3945_update_sta_key_info(struct iwl_priv *priv,
+static int iwl3945_set_ccmp_dynamic_key_info(struct iwl_priv *priv,
 				   struct ieee80211_key_conf *keyconf,
 				   u8 sta_id)
 {
 	unsigned long flags;
 	__le16 key_flags = 0;
+	int ret;
+
+	key_flags |= (STA_KEY_FLG_CCMP | STA_KEY_FLG_MAP_KEY_MSK);
+	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
+
+	if (sta_id == priv->hw_params.bcast_sta_id)
+		key_flags |= STA_KEY_MULTICAST_MSK;
+
+	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+	keyconf->hw_key_idx = keyconf->keyidx;
+	key_flags &= ~STA_KEY_FLG_INVALID;
 
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
 	spin_lock_irqsave(&priv->sta_lock, flags);
 	priv->stations_39[sta_id].keyinfo.alg = keyconf->alg;
 	priv->stations_39[sta_id].keyinfo.keylen = keyconf->keylen;
@@ -483,16 +484,43 @@ static int iwl3945_update_sta_key_info(struct iwl_priv *priv,
 
 	memcpy(priv->stations_39[sta_id].sta.key.key, keyconf->key,
 	       keyconf->keylen);
+
+	if ((priv->stations[sta_id].sta.key.key_flags & STA_KEY_FLG_ENCRYPT_MSK)
+			== STA_KEY_FLG_NO_ENC)
+		priv->stations[sta_id].sta.key.key_offset =
+				 iwl_get_free_ucode_key_index(priv);
+	/* else, we are overriding an existing key => no need to allocated room
+	* in uCode. */
+
+	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
+		"no space for a new key");
+
 	priv->stations_39[sta_id].sta.key.key_flags = key_flags;
 	priv->stations_39[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
 	priv->stations_39[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 
+	IWL_DEBUG_INFO(priv, "hwcrypto: modify ucode station key info\n");
+
+	ret = iwl_send_add_sta(priv,
+		(struct iwl_addsta_cmd *)&priv->stations_39[sta_id].sta, CMD_ASYNC);
+
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
-	IWL_DEBUG_INFO(priv, "hwcrypto: modify ucode station key info\n");
-	iwl_send_add_sta(priv,
-		(struct iwl_addsta_cmd *)&priv->stations_39[sta_id].sta, 0);
-	return 0;
+	return ret;
+}
+
+static int iwl3945_set_tkip_dynamic_key_info(struct iwl_priv *priv,
+				  struct ieee80211_key_conf *keyconf,
+				  u8 sta_id)
+{
+	return -EOPNOTSUPP;
+}
+
+static int iwl3945_set_wep_dynamic_key_info(struct iwl_priv *priv,
+				  struct ieee80211_key_conf *keyconf,
+				  u8 sta_id)
+{
+	return -EOPNOTSUPP;
 }
 
 static int iwl3945_clear_sta_key_info(struct iwl_priv *priv, u8 sta_id)
@@ -514,6 +542,52 @@ static int iwl3945_clear_sta_key_info(struct iwl_priv *priv, u8 sta_id)
 	return 0;
 }
 
+int iwl3945_set_dynamic_key(struct iwl_priv *priv,
+			struct ieee80211_key_conf *keyconf, u8 sta_id)
+{
+	int ret = 0;
+
+	keyconf->hw_key_idx = HW_KEY_DYNAMIC;
+
+	switch (keyconf->alg) {
+	case ALG_CCMP:
+		ret = iwl3945_set_ccmp_dynamic_key_info(priv, keyconf, sta_id);
+		break;
+	case ALG_TKIP:
+		ret = iwl3945_set_tkip_dynamic_key_info(priv, keyconf, sta_id);
+		break;
+	case ALG_WEP:
+		ret = iwl3945_set_wep_dynamic_key_info(priv, keyconf, sta_id);
+		break;
+	default:
+		IWL_ERR(priv,"Unknown alg: %s alg = %d\n", __func__, keyconf->alg);
+		ret = -EINVAL;
+	}
+
+	IWL_DEBUG_WEP(priv, "Set dynamic key: alg= %d len=%d idx=%d sta=%d ret=%d\n",
+		      keyconf->alg, keyconf->keylen, keyconf->keyidx,
+		      sta_id, ret);
+
+	return ret;
+}
+
+static int iwl3945_remove_static_key(struct iwl_priv *priv)
+{
+	int ret = -EOPNOTSUPP;
+
+	return ret;
+}
+
+static int iwl3945_set_static_key(struct iwl_priv *priv,
+				struct ieee80211_key_conf *key)
+{
+	if (key->alg == ALG_WEP)
+		return -EOPNOTSUPP;
+
+	IWL_ERR(priv, "Static key invalid: alg %d\n", key->alg);
+	return -EINVAL;
+}
+
 static void iwl3945_clear_free_frames(struct iwl_priv *priv)
 {
 	struct list_head *element;
@@ -766,11 +840,11 @@ static void iwl3945_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
 				      struct ieee80211_tx_info *info,
 				      struct iwl_cmd *cmd,
 				      struct sk_buff *skb_frag,
-				      int last_frag)
+				      int sta_id)
 {
 	struct iwl3945_tx_cmd *tx = (struct iwl3945_tx_cmd *)cmd->cmd.payload;
 	struct iwl3945_hw_key *keyinfo =
-	    &priv->stations_39[info->control.hw_key->hw_key_idx].keyinfo;
+	    &priv->stations_39[sta_id].keyinfo;
 
 	switch (keyinfo->alg) {
 	case ALG_CCMP:
@@ -780,15 +854,6 @@ static void iwl3945_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
 		break;
 
 	case ALG_TKIP:
-#if 0
-		tx->sec_ctl = TX_CMD_SEC_TKIP;
-
-		if (last_frag)
-			memcpy(tx->tkip_mic.byte, skb_frag->tail - 8,
-			       8);
-		else
-			memset(tx->tkip_mic.byte, 0, 8);
-#endif
 		break;
 
 	case ALG_WEP:
@@ -1088,7 +1153,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 						   txcmd_phys, len, 1, 0);
 
 	if (info->control.hw_key)
-		iwl3945_build_tx_cmd_hwcrypto(priv, info, out_cmd, skb, 0);
+		iwl3945_build_tx_cmd_hwcrypto(priv, info, out_cmd, skb, sta_id);
 
 	/* Set up TFD's 2nd entry to point directly to remainder of skb,
 	 * if any (802.11 null frames have no payload). */
@@ -4110,8 +4175,9 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 {
 	struct iwl_priv *priv = hw->priv;
 	const u8 *addr;
-	int ret;
-	u8 sta_id;
+	int ret = 0;
+	u8 sta_id = IWL_INVALID_STATION;
+	u8 static_key;
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
@@ -4121,43 +4187,41 @@ static int iwl3945_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	}
 
 	addr = sta ? sta->addr : iwl_bcast_addr;
-	sta_id = iwl3945_hw_find_station(priv, addr);
-	if (sta_id == IWL_INVALID_STATION) {
-		IWL_DEBUG_MAC80211(priv, "leave - %pM not in station map.\n",
-				   addr);
-		return -EINVAL;
+	static_key = !iwl_is_associated(priv);
+
+	if (!static_key) {
+		sta_id = iwl3945_hw_find_station(priv, addr);
+		if (sta_id == IWL_INVALID_STATION) {
+			IWL_DEBUG_MAC80211(priv, "leave - %pMnot in station map.\n",
+					    addr);
+			return -EINVAL;
+		}
 	}
 
 	mutex_lock(&priv->mutex);
-
 	iwl_scan_cancel_timeout(priv, 100);
+	mutex_unlock(&priv->mutex);
 
 	switch (cmd) {
-	case  SET_KEY:
-		ret = iwl3945_update_sta_key_info(priv, key, sta_id);
-		if (!ret) {
-			iwl_set_rxon_hwcrypto(priv, 1);
-			iwl3945_commit_rxon(priv);
-			key->hw_key_idx = sta_id;
-			IWL_DEBUG_MAC80211(priv,
-				"set_key success, using hwcrypto\n");
-			key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
-		}
+	case SET_KEY:
+		if (static_key)
+			ret = iwl3945_set_static_key(priv, key);
+		else
+			ret = iwl3945_set_dynamic_key(priv, key, sta_id);
+		IWL_DEBUG_MAC80211(priv, "enable hwcrypto key\n");
 		break;
 	case DISABLE_KEY:
-		ret = iwl3945_clear_sta_key_info(priv, sta_id);
-		if (!ret) {
-			iwl_set_rxon_hwcrypto(priv, 0);
-			iwl3945_commit_rxon(priv);
-			IWL_DEBUG_MAC80211(priv, "disable hwcrypto key\n");
-		}
+		if (static_key)
+			ret = iwl3945_remove_static_key(priv);
+		else
+			ret = iwl3945_clear_sta_key_info(priv, sta_id);
+		IWL_DEBUG_MAC80211(priv, "disable hwcrypto key\n");
 		break;
 	default:
 		ret = -EINVAL;
 	}
 
 	IWL_DEBUG_MAC80211(priv, "leave\n");
-	mutex_unlock(&priv->mutex);
 
 	return ret;
 }
-- 
1.5.6.3

