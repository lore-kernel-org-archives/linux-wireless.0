Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:32866 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984Ab1GUP0v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 11:26:51 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 19/25] iwlagn: rewrite HW crypto
Date: Thu, 21 Jul 2011 07:50:22 -0700
Message-Id: <1311259828-8415-20-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110721_172714_264382_15712524)
In-Reply-To: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

As I just discovered while doing WoWLAN, HW crypto
is done wrong for GTKs: they should be programmed
for the AP station ID (in the managed mode case)
and the HW can actually deal with multiple group
keys per station as well (which is useful in IBSS
RSN but that I've chosen not to use this).

To fix all this, modify the way keys are sent to
the device and key offsets are allocated. After
these changes, key offsets are stored into the
hw_key_idx which we can then track for the key
lifetime, not relying on our sta_cmd array. WEP
default keys get special treatment, of course.

Additionally, since I had the API for it, we can
now pre-fill TKIP phase 1 keys for RX now that we
can obtain the P1K from mac80211, a capability I
had added for WoWLAN initially.

Finally, some keys simply don't need to be added
into the device's key cache -- a key that won't
be used for RX is only needed in the TX header,
so "pretend" to have accepted any key without
adding it into the device -- no need to use up
key space there for it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c  |  357 ++++++++++++---------------
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   54 +++--
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    8 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h |    2 +
 drivers/net/wireless/iwlwifi/iwl-sta.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-sta.h      |    5 +-
 6 files changed, 202 insertions(+), 226 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 395dee1..7a2babe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -139,6 +139,14 @@ int iwlagn_add_bssid_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx
 	return 0;
 }
 
+/*
+ * static WEP keys
+ *
+ * For each context, the device has a table of 4 static WEP keys
+ * (one for each key index) that is updated with the following
+ * commands.
+ */
+
 static int iwl_send_static_wepkey_cmd(struct iwl_priv *priv,
 				      struct iwl_rxon_context *ctx,
 				      bool send_if_empty)
@@ -232,8 +240,7 @@ int iwl_set_default_wep_key(struct iwl_priv *priv,
 		return -EINVAL;
 	}
 
-	keyconf->flags &= ~IEEE80211_KEY_FLAG_GENERATE_IV;
-	keyconf->hw_key_idx = HW_KEY_DEFAULT;
+	keyconf->hw_key_idx = IWLAGN_HW_KEY_DEFAULT;
 
 	ctx->wep_keys[keyconf->keyidx].key_size = keyconf->keylen;
 	memcpy(&ctx->wep_keys[keyconf->keyidx].key, &keyconf->key,
@@ -246,147 +253,116 @@ int iwl_set_default_wep_key(struct iwl_priv *priv,
 	return ret;
 }
 
-static int iwl_set_wep_dynamic_key_info(struct iwl_priv *priv,
-					struct iwl_rxon_context *ctx,
-					struct ieee80211_key_conf *keyconf,
-					u8 sta_id)
-{
-	unsigned long flags;
-	__le16 key_flags = 0;
-	struct iwl_addsta_cmd sta_cmd;
-
-	lockdep_assert_held(&priv->mutex);
-
-	keyconf->flags &= ~IEEE80211_KEY_FLAG_GENERATE_IV;
-
-	key_flags |= (STA_KEY_FLG_WEP | STA_KEY_FLG_MAP_KEY_MSK);
-	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
-	key_flags &= ~STA_KEY_FLG_INVALID;
-
-	if (keyconf->keylen == WEP_KEY_LEN_128)
-		key_flags |= STA_KEY_FLG_KEY_SIZE_MSK;
-
-	if (sta_id == ctx->bcast_sta_id)
-		key_flags |= STA_KEY_MULTICAST_MSK;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-
-	memcpy(&priv->stations[sta_id].sta.key.key[3],
-				keyconf->key, keyconf->keylen);
-
-	if ((priv->stations[sta_id].sta.key.key_flags & STA_KEY_FLG_ENCRYPT_MSK)
-			== STA_KEY_FLG_NO_ENC)
-		priv->stations[sta_id].sta.key.key_offset =
-				 iwl_get_free_ucode_key_index(priv);
-	/* else, we are overriding an existing key => no need to allocated room
-	 * in uCode. */
+/*
+ * dynamic (per-station) keys
+ *
+ * The dynamic keys are a little more complicated. The device has
+ * a key cache of up to STA_KEY_MAX_NUM/STA_KEY_MAX_NUM_PAN keys.
+ * These are linked to stations by a table that contains an index
+ * into the key table for each station/key index/{mcast,unicast},
+ * i.e. it's basically an array of pointers like this:
+ *	key_offset_t key_mapping[NUM_STATIONS][4][2];
+ * (it really works differently, but you can think of it as such)
+ *
+ * The key uploading and linking happens in the same command, the
+ * add station command with STA_MODIFY_KEY_MASK.
+ */
 
-	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
-		"no space for a new key");
+static u8 iwlagn_key_sta_id(struct iwl_priv *priv,
+			    struct ieee80211_vif *vif,
+			    struct ieee80211_sta *sta)
+{
+	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
+	u8 sta_id = IWL_INVALID_STATION;
 
-	priv->stations[sta_id].sta.key.key_flags = key_flags;
-	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
-	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+	if (sta)
+		sta_id = iwl_sta_id(sta);
 
-	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(struct iwl_addsta_cmd));
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	/*
+	 * The device expects GTKs for station interfaces to be
+	 * installed as GTKs for the AP station. If we have no
+	 * station ID, then use the ap_sta_id in that case.
+	 */
+	if (!sta && vif && vif_priv->ctx) {
+		switch (vif->type) {
+		case NL80211_IFTYPE_STATION:
+			sta_id = vif_priv->ctx->ap_sta_id;
+			break;
+		default:
+			/*
+			 * In all other cases, the key will be
+			 * used either for TX only or is bound
+			 * to a station already.
+			 */
+			break;
+		}
+	}
 
-	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
+	return sta_id;
 }
 
-static int iwl_set_ccmp_dynamic_key_info(struct iwl_priv *priv,
-					 struct iwl_rxon_context *ctx,
-					 struct ieee80211_key_conf *keyconf,
-					 u8 sta_id)
+static int iwlagn_set_dynamic_key(struct iwl_priv *priv,
+				  struct ieee80211_key_conf *keyconf,
+				  u8 sta_id, u32 tkip_iv32, u16 *tkip_p1k,
+				  u32 cmd_flags)
 {
 	unsigned long flags;
-	__le16 key_flags = 0;
+	__le16 key_flags;
 	struct iwl_addsta_cmd sta_cmd;
-
-	lockdep_assert_held(&priv->mutex);
-
-	key_flags |= (STA_KEY_FLG_CCMP | STA_KEY_FLG_MAP_KEY_MSK);
-	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
-	key_flags &= ~STA_KEY_FLG_INVALID;
-
-	if (sta_id == ctx->bcast_sta_id)
-		key_flags |= STA_KEY_MULTICAST_MSK;
-
-	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
-
+	int i;
 	spin_lock_irqsave(&priv->sta_lock, flags);
-
-	memcpy(priv->stations[sta_id].sta.key.key, keyconf->key,
-	       keyconf->keylen);
-
-	if ((priv->stations[sta_id].sta.key.key_flags & STA_KEY_FLG_ENCRYPT_MSK)
-			== STA_KEY_FLG_NO_ENC)
-		priv->stations[sta_id].sta.key.key_offset =
-				 iwl_get_free_ucode_key_index(priv);
-	/* else, we are overriding an existing key => no need to allocated room
-	 * in uCode. */
-
-	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
-		"no space for a new key");
-
-	priv->stations[sta_id].sta.key.key_flags = key_flags;
-	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
-	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
-
-	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(struct iwl_addsta_cmd));
+	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(sta_cmd));
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
-	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
-}
-
-static int iwl_set_tkip_dynamic_key_info(struct iwl_priv *priv,
-					 struct iwl_rxon_context *ctx,
-					 struct ieee80211_key_conf *keyconf,
-					 u8 sta_id)
-{
-	unsigned long flags;
-	int ret = 0;
-	__le16 key_flags = 0;
+	key_flags = cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
+	key_flags |= STA_KEY_FLG_MAP_KEY_MSK;
 
-	key_flags |= (STA_KEY_FLG_TKIP | STA_KEY_FLG_MAP_KEY_MSK);
-	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
-	key_flags &= ~STA_KEY_FLG_INVALID;
+	switch (keyconf->cipher) {
+	case WLAN_CIPHER_SUITE_CCMP:
+		key_flags |= STA_KEY_FLG_CCMP;
+		memcpy(sta_cmd.key.key, keyconf->key, keyconf->keylen);
+		break;
+	case WLAN_CIPHER_SUITE_TKIP:
+		key_flags |= STA_KEY_FLG_TKIP;
+		sta_cmd.key.tkip_rx_tsc_byte2 = tkip_iv32;
+		for (i = 0; i < 5; i++)
+			sta_cmd.key.tkip_rx_ttak[i] = cpu_to_le16(tkip_p1k[i]);
+		memcpy(sta_cmd.key.key, keyconf->key, keyconf->keylen);
+		break;
+	case WLAN_CIPHER_SUITE_WEP104:
+		key_flags |= STA_KEY_FLG_KEY_SIZE_MSK;
+		/* fall through */
+	case WLAN_CIPHER_SUITE_WEP40:
+		key_flags |= STA_KEY_FLG_WEP;
+		memcpy(&sta_cmd.key.key[3], keyconf->key, keyconf->keylen);
+		break;
+	default:
+		WARN_ON(1);
+		return -EINVAL;
+	}
 
-	if (sta_id == ctx->bcast_sta_id)
+	if (!(keyconf->flags & IEEE80211_KEY_FLAG_PAIRWISE))
 		key_flags |= STA_KEY_MULTICAST_MSK;
 
-	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
-	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-
-	if ((priv->stations[sta_id].sta.key.key_flags & STA_KEY_FLG_ENCRYPT_MSK)
-			== STA_KEY_FLG_NO_ENC)
-		priv->stations[sta_id].sta.key.key_offset =
-				 iwl_get_free_ucode_key_index(priv);
-	/* else, we are overriding an existing key => no need to allocated room
-	 * in uCode. */
-
-	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
-		"no space for a new key");
+	/* key pointer (offset) */
+	sta_cmd.key.key_offset = keyconf->hw_key_idx;
 
-	priv->stations[sta_id].sta.key.key_flags = key_flags;
+	sta_cmd.key.key_flags = key_flags;
+	sta_cmd.mode = STA_CONTROL_MODIFY_MSK;
+	sta_cmd.sta.modify_mask = STA_MODIFY_KEY_MASK;
 
-	memcpy(priv->stations[sta_id].sta.key.key, keyconf->key, 16);
-
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-
-	return ret;
+	return iwl_send_add_sta(priv, &sta_cmd, cmd_flags);
 }
 
 void iwl_update_tkip_key(struct iwl_priv *priv,
-			 struct iwl_rxon_context *ctx,
+			 struct ieee80211_vif *vif,
 			 struct ieee80211_key_conf *keyconf,
 			 struct ieee80211_sta *sta, u32 iv32, u16 *phase1key)
 {
-	u8 sta_id;
-	unsigned long flags;
-	int i;
+	u8 sta_id = iwlagn_key_sta_id(priv, vif, sta);
+
+	if (sta_id == IWL_INVALID_STATION)
+		return;
 
 	if (iwl_scan_cancel(priv)) {
 		/* cancel scan failed, just live w/ bad key and rely
@@ -394,119 +370,110 @@ void iwl_update_tkip_key(struct iwl_priv *priv,
 		return;
 	}
 
-	sta_id = iwl_sta_id_or_broadcast(priv, ctx, sta);
-	if (sta_id == IWL_INVALID_STATION)
-		return;
-
-	spin_lock_irqsave(&priv->sta_lock, flags);
-
-	priv->stations[sta_id].sta.key.tkip_rx_tsc_byte2 = (u8) iv32;
-
-	for (i = 0; i < 5; i++)
-		priv->stations[sta_id].sta.key.tkip_rx_ttak[i] =
-			cpu_to_le16(phase1key[i]);
-
-	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
-	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
-
-	iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
-
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
-
+	iwlagn_set_dynamic_key(priv, keyconf, sta_id,
+			       iv32, phase1key, CMD_ASYNC);
 }
 
 int iwl_remove_dynamic_key(struct iwl_priv *priv,
 			   struct iwl_rxon_context *ctx,
 			   struct ieee80211_key_conf *keyconf,
-			   u8 sta_id)
+			   struct ieee80211_sta *sta)
 {
 	unsigned long flags;
-	u16 key_flags;
-	u8 keyidx;
 	struct iwl_addsta_cmd sta_cmd;
+	u8 sta_id = iwlagn_key_sta_id(priv, ctx->vif, sta);
+
+	/* if station isn't there, neither is the key */
+	if (sta_id == IWL_INVALID_STATION)
+		return -ENOENT;
+
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(sta_cmd));
+	if (!(priv->stations[sta_id].used & IWL_STA_UCODE_ACTIVE))
+		sta_id = IWL_INVALID_STATION;
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
+	if (sta_id == IWL_INVALID_STATION)
+		return 0;
 
 	lockdep_assert_held(&priv->mutex);
 
 	ctx->key_mapping_keys--;
 
-	spin_lock_irqsave(&priv->sta_lock, flags);
-	key_flags = le16_to_cpu(priv->stations[sta_id].sta.key.key_flags);
-	keyidx = (key_flags >> STA_KEY_FLG_KEYID_POS) & 0x3;
-
 	IWL_DEBUG_WEP(priv, "Remove dynamic key: idx=%d sta=%d\n",
 		      keyconf->keyidx, sta_id);
 
-	if (keyconf->keyidx != keyidx) {
-		/* We need to remove a key with index different that the one
-		 * in the uCode. This means that the key we need to remove has
-		 * been replaced by another one with different index.
-		 * Don't do anything and return ok
-		 */
-		spin_unlock_irqrestore(&priv->sta_lock, flags);
-		return 0;
-	}
-
-	if (priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET) {
-		IWL_WARN(priv, "Removing wrong key %d 0x%x\n",
-			    keyconf->keyidx, key_flags);
-		spin_unlock_irqrestore(&priv->sta_lock, flags);
-		return 0;
-	}
-
-	if (!test_and_clear_bit(priv->stations[sta_id].sta.key.key_offset,
-		&priv->ucode_key_table))
-		IWL_ERR(priv, "index %d not used in uCode key table.\n",
-			priv->stations[sta_id].sta.key.key_offset);
-	memset(&priv->stations[sta_id].sta.key, 0,
-					sizeof(struct iwl_keyinfo));
-	priv->stations[sta_id].sta.key.key_flags =
-			STA_KEY_FLG_NO_ENC | STA_KEY_FLG_INVALID;
-	priv->stations[sta_id].sta.key.key_offset = WEP_INVALID_OFFSET;
-	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
-	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
+	if (!test_and_clear_bit(keyconf->hw_key_idx, &priv->ucode_key_table))
+		IWL_ERR(priv, "offset %d not used in uCode key table.\n",
+			keyconf->hw_key_idx);
 
-	if (iwl_is_rfkill(priv)) {
-		IWL_DEBUG_WEP(priv, "Not sending REPLY_ADD_STA command because RFKILL enabled.\n");
-		spin_unlock_irqrestore(&priv->sta_lock, flags);
-		return 0;
-	}
-	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(struct iwl_addsta_cmd));
-	spin_unlock_irqrestore(&priv->sta_lock, flags);
+	sta_cmd.key.key_flags = STA_KEY_FLG_NO_ENC | STA_KEY_FLG_INVALID;
+	sta_cmd.key.key_offset = WEP_INVALID_OFFSET;
+	sta_cmd.sta.modify_mask = STA_MODIFY_KEY_MASK;
+	sta_cmd.mode = STA_CONTROL_MODIFY_MSK;
 
 	return iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
 }
 
-int iwl_set_dynamic_key(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
-			struct ieee80211_key_conf *keyconf, u8 sta_id)
+int iwl_set_dynamic_key(struct iwl_priv *priv,
+			struct iwl_rxon_context *ctx,
+			struct ieee80211_key_conf *keyconf,
+			struct ieee80211_sta *sta)
 {
+	struct ieee80211_key_seq seq;
+	u16 p1k[5];
 	int ret;
+	u8 sta_id = iwlagn_key_sta_id(priv, ctx->vif, sta);
+	const u8 *addr;
+
+	if (sta_id == IWL_INVALID_STATION)
+		return -EINVAL;
 
 	lockdep_assert_held(&priv->mutex);
 
+	keyconf->hw_key_idx = iwl_get_free_ucode_key_offset(priv);
+	if (keyconf->hw_key_idx == WEP_INVALID_OFFSET)
+		return -ENOSPC;
+
 	ctx->key_mapping_keys++;
-	keyconf->hw_key_idx = HW_KEY_DYNAMIC;
 
 	switch (keyconf->cipher) {
-	case WLAN_CIPHER_SUITE_CCMP:
-		ret = iwl_set_ccmp_dynamic_key_info(priv, ctx, keyconf, sta_id);
-		break;
 	case WLAN_CIPHER_SUITE_TKIP:
-		ret = iwl_set_tkip_dynamic_key_info(priv, ctx, keyconf, sta_id);
+		keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
+		keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+
+		if (sta)
+			addr = sta->addr;
+		else /* station mode case only */
+			addr = ctx->active.bssid_addr;
+
+		/* pre-fill phase 1 key into device cache */
+		ieee80211_get_key_rx_seq(keyconf, 0, &seq);
+		ieee80211_get_tkip_rx_p1k(keyconf, addr, seq.tkip.iv32, p1k);
+		ret = iwlagn_set_dynamic_key(priv, keyconf, sta_id,
+					     seq.tkip.iv32, p1k, CMD_SYNC);
 		break;
+	case WLAN_CIPHER_SUITE_CCMP:
+		keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+		/* fall through */
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
-		ret = iwl_set_wep_dynamic_key_info(priv, ctx, keyconf, sta_id);
+		ret = iwlagn_set_dynamic_key(priv, keyconf, sta_id,
+					     0, NULL, CMD_SYNC);
 		break;
 	default:
-		IWL_ERR(priv,
-			"Unknown alg: %s cipher = %x\n", __func__,
-			keyconf->cipher);
+		IWL_ERR(priv, "Unknown cipher %x\n", keyconf->cipher);
 		ret = -EINVAL;
 	}
 
-	IWL_DEBUG_WEP(priv, "Set dynamic key: cipher=%x len=%d idx=%d sta=%d ret=%d\n",
+	if (ret) {
+		ctx->key_mapping_keys--;
+		clear_bit(keyconf->hw_key_idx, &priv->ucode_key_table);
+	}
+
+	IWL_DEBUG_WEP(priv, "Set dynamic key: cipher=%x len=%d idx=%d sta=%pM ret=%d\n",
 		      keyconf->cipher, keyconf->keylen, keyconf->keyidx,
-		      sta_id, ret);
+		      sta ? sta->addr : NULL, ret);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 6df2443..0bab195 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2259,14 +2259,8 @@ static void iwlagn_mac_update_tkip_key(struct ieee80211_hw *hw,
 				       u32 iv32, u16 *phase1key)
 {
 	struct iwl_priv *priv = hw->priv;
-	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
-
-	IWL_DEBUG_MAC80211(priv, "enter\n");
 
-	iwl_update_tkip_key(priv, vif_priv->ctx, keyconf, sta,
-			    iv32, phase1key);
-
-	IWL_DEBUG_MAC80211(priv, "leave\n");
+	iwl_update_tkip_key(priv, vif, keyconf, sta, iv32, phase1key);
 }
 
 static int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
@@ -2278,7 +2272,6 @@ static int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
 	struct iwl_rxon_context *ctx = vif_priv->ctx;
 	int ret;
-	u8 sta_id;
 	bool is_default_wep_key = false;
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
@@ -2289,20 +2282,27 @@ static int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	}
 
 	/*
-	 * To support IBSS RSN, don't program group keys in IBSS, the
-	 * hardware will then not attempt to decrypt the frames.
+	 * We could program these keys into the hardware as well, but we
+	 * don't expect much multicast traffic in IBSS and having keys
+	 * for more stations is probably more useful.
+	 *
+	 * Mark key TX-only and return 0.
 	 */
 	if (vif->type == NL80211_IFTYPE_ADHOC &&
-	    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
-		return -EOPNOTSUPP;
+	    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
+		key->hw_key_idx = WEP_INVALID_OFFSET;
+		return 0;
+	}
 
-	sta_id = iwl_sta_id_or_broadcast(priv, vif_priv->ctx, sta);
-	if (sta_id == IWL_INVALID_STATION)
-		return -EINVAL;
+	/* If they key was TX-only, accept deletion */
+	if (cmd == DISABLE_KEY && key->hw_key_idx == WEP_INVALID_OFFSET)
+		return 0;
 
 	mutex_lock(&priv->mutex);
 	iwl_scan_cancel_timeout(priv, 100);
 
+	BUILD_BUG_ON(WEP_INVALID_OFFSET == IWLAGN_HW_KEY_DEFAULT);
+
 	/*
 	 * If we are getting WEP group key and we didn't receive any key mapping
 	 * so far, we are in legacy wep mode (group key only), otherwise we are
@@ -2310,22 +2310,30 @@ static int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	 * In legacy wep mode, we use another host command to the uCode.
 	 */
 	if ((key->cipher == WLAN_CIPHER_SUITE_WEP40 ||
-	     key->cipher == WLAN_CIPHER_SUITE_WEP104) &&
-	    !sta) {
+	     key->cipher == WLAN_CIPHER_SUITE_WEP104) && !sta) {
 		if (cmd == SET_KEY)
 			is_default_wep_key = !ctx->key_mapping_keys;
 		else
 			is_default_wep_key =
-					(key->hw_key_idx == HW_KEY_DEFAULT);
+				key->hw_key_idx == IWLAGN_HW_KEY_DEFAULT;
 	}
 
+
 	switch (cmd) {
 	case SET_KEY:
-		if (is_default_wep_key)
+		if (is_default_wep_key) {
 			ret = iwl_set_default_wep_key(priv, vif_priv->ctx, key);
-		else
-			ret = iwl_set_dynamic_key(priv, vif_priv->ctx,
-						  key, sta_id);
+			break;
+		}
+		ret = iwl_set_dynamic_key(priv, vif_priv->ctx, key, sta);
+		if (ret) {
+			/*
+			 * can't add key for RX, but we don't need it
+			 * in the device for TX so still return 0
+			 */
+			ret = 0;
+			key->hw_key_idx = WEP_INVALID_OFFSET;
+		}
 
 		IWL_DEBUG_MAC80211(priv, "enable hwcrypto key\n");
 		break;
@@ -2333,7 +2341,7 @@ static int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		if (is_default_wep_key)
 			ret = iwl_remove_default_wep_key(priv, ctx, key);
 		else
-			ret = iwl_remove_dynamic_key(priv, ctx, key, sta_id);
+			ret = iwl_remove_dynamic_key(priv, ctx, key, sta);
 
 		IWL_DEBUG_MAC80211(priv, "disable hwcrypto key\n");
 		break;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 785987d..d941c4c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -246,11 +246,13 @@ int iwl_set_default_wep_key(struct iwl_priv *priv,
 int iwl_restore_default_wep_keys(struct iwl_priv *priv,
 				 struct iwl_rxon_context *ctx);
 int iwl_set_dynamic_key(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
-			struct ieee80211_key_conf *key, u8 sta_id);
+			struct ieee80211_key_conf *key,
+			struct ieee80211_sta *sta);
 int iwl_remove_dynamic_key(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
-			   struct ieee80211_key_conf *key, u8 sta_id);
+			   struct ieee80211_key_conf *key,
+			   struct ieee80211_sta *sta);
 void iwl_update_tkip_key(struct iwl_priv *priv,
-			 struct iwl_rxon_context *ctx,
+			 struct ieee80211_vif *vif,
 			 struct ieee80211_key_conf *keyconf,
 			 struct ieee80211_sta *sta, u32 iv32, u16 *phase1key);
 int iwl_sta_tx_modify_enable_tid(struct iwl_priv *priv, int sta_id, int tid);
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 80174d1..b589853 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -832,6 +832,8 @@ struct iwl_qosparam_cmd {
 #define STA_KEY_MULTICAST_MSK        cpu_to_le16(0x4000)
 #define STA_KEY_MAX_NUM		8
 #define STA_KEY_MAX_NUM_PAN	16
+/* must not match WEP_INVALID_OFFSET */
+#define IWLAGN_HW_KEY_DEFAULT	0xfe
 
 /* Flags indicate whether to modify vs. don't change various station params */
 #define	STA_MODIFY_KEY_MASK		0x01
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 58dba0a..1ef3b71 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -669,7 +669,7 @@ void iwl_reprogram_ap_sta(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	iwl_send_lq_cmd(priv, ctx, &lq, CMD_SYNC, true);
 }
 
-int iwl_get_free_ucode_key_index(struct iwl_priv *priv)
+int iwl_get_free_ucode_key_offset(struct iwl_priv *priv)
 {
 	int i;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index ff64027..9a6768d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -31,9 +31,6 @@
 
 #include "iwl-dev.h"
 
-#define HW_KEY_DYNAMIC 0
-#define HW_KEY_DEFAULT 1
-
 #define IWL_STA_DRIVER_ACTIVE BIT(0) /* driver entry is active */
 #define IWL_STA_UCODE_ACTIVE  BIT(1) /* ucode entry is active */
 #define IWL_STA_UCODE_INPROGRESS  BIT(2) /* ucode entry is in process of
@@ -47,7 +44,7 @@ void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx);
 void iwl_clear_ucode_stations(struct iwl_priv *priv,
 			      struct iwl_rxon_context *ctx);
 void iwl_dealloc_bcast_stations(struct iwl_priv *priv);
-int iwl_get_free_ucode_key_index(struct iwl_priv *priv);
+int iwl_get_free_ucode_key_offset(struct iwl_priv *priv);
 int iwl_send_add_sta(struct iwl_priv *priv,
 		     struct iwl_addsta_cmd *sta, u8 flags);
 int iwl_add_station_common(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
-- 
1.7.0.4

