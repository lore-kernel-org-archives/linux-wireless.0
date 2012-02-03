Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036Ab2BCMIP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 07:08:15 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 12/25] iwlegacy: move wep_keys out of context
Date: Fri,  3 Feb 2012 13:07:12 +0100
Message-Id: <1328270845-16891-13-git-send-email-sgruszka@redhat.com> (sfid-20120203_130826_239645_72278F6D)
In-Reply-To: <1328270845-16891-1-git-send-email-sgruszka@redhat.com>
References: <1328270845-16891-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c |   58 ++++++++++++++++++-----------
 drivers/net/wireless/iwlegacy/common.h   |   19 ++--------
 2 files changed, 39 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index ecb7b54..35d868c 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -2808,7 +2808,7 @@ static int
 il4965_static_wepkey_cmd(struct il_priv *il, struct il_rxon_context *ctx,
 			 bool send_if_empty)
 {
-	int i, not_empty = 0;
+	int i;
 	u8 buff[sizeof(struct il_wep_cmd) +
 		sizeof(struct il_wep_key) * WEP_KEYS_MAX];
 	struct il_wep_cmd *wep_cmd = (struct il_wep_cmd *)buff;
@@ -2818,6 +2818,7 @@ il4965_static_wepkey_cmd(struct il_priv *il, struct il_rxon_context *ctx,
 		.data = wep_cmd,
 		.flags = CMD_SYNC,
 	};
+	bool not_empty = false;
 
 	might_sleep();
 
@@ -2825,24 +2826,23 @@ il4965_static_wepkey_cmd(struct il_priv *il, struct il_rxon_context *ctx,
 	       cmd_size + (sizeof(struct il_wep_key) * WEP_KEYS_MAX));
 
 	for (i = 0; i < WEP_KEYS_MAX; i++) {
+		u8 key_size = il->_4965.wep_keys[i].key_size;
+
 		wep_cmd->key[i].key_idx = i;
-		if (ctx->wep_keys[i].key_size) {
+		if (key_size) {
 			wep_cmd->key[i].key_offset = i;
-			not_empty = 1;
-		} else {
+			not_empty = true;
+		} else
 			wep_cmd->key[i].key_offset = WEP_INVALID_OFFSET;
-		}
 
-		wep_cmd->key[i].key_size = ctx->wep_keys[i].key_size;
-		memcpy(&wep_cmd->key[i].key[3], ctx->wep_keys[i].key,
-		       ctx->wep_keys[i].key_size);
+		wep_cmd->key[i].key_size = key_size;
+		memcpy(&wep_cmd->key[i].key[3], il->_4965.wep_keys[i].key, key_size);
 	}
 
 	wep_cmd->global_key_type = WEP_KEY_WEP_TYPE;
 	wep_cmd->num_keys = WEP_KEYS_MAX;
 
 	cmd_size += sizeof(struct il_wep_key) * WEP_KEYS_MAX;
-
 	cmd.len = cmd_size;
 
 	if (not_empty || send_if_empty)
@@ -2864,19 +2864,20 @@ il4965_remove_default_wep_key(struct il_priv *il, struct il_rxon_context *ctx,
 			      struct ieee80211_key_conf *keyconf)
 {
 	int ret;
+	int idx = keyconf->keyidx;
 
 	lockdep_assert_held(&il->mutex);
 
-	D_WEP("Removing default WEP key: idx=%d\n", keyconf->keyidx);
+	D_WEP("Removing default WEP key: idx=%d\n", idx);
 
-	memset(&ctx->wep_keys[keyconf->keyidx], 0, sizeof(ctx->wep_keys[0]));
+	memset(&il->_4965.wep_keys[idx], 0, sizeof(struct il_wep_key));
 	if (il_is_rfkill(il)) {
 		D_WEP("Not sending C_WEPKEY command due to RFKILL.\n");
 		/* but keys in device are clear anyway so return success */
 		return 0;
 	}
 	ret = il4965_static_wepkey_cmd(il, ctx, 1);
-	D_WEP("Remove default WEP key: idx=%d ret=%d\n", keyconf->keyidx, ret);
+	D_WEP("Remove default WEP key: idx=%d ret=%d\n", idx, ret);
 
 	return ret;
 }
@@ -2886,11 +2887,12 @@ il4965_set_default_wep_key(struct il_priv *il, struct il_rxon_context *ctx,
 			   struct ieee80211_key_conf *keyconf)
 {
 	int ret;
+	int len = keyconf->keylen;
+	int idx = keyconf->keyidx;
 
 	lockdep_assert_held(&il->mutex);
 
-	if (keyconf->keylen != WEP_KEY_LEN_128 &&
-	    keyconf->keylen != WEP_KEY_LEN_64) {
+	if (len != WEP_KEY_LEN_128 && len != WEP_KEY_LEN_64) {
 		D_WEP("Bad WEP key length %d\n", keyconf->keylen);
 		return -EINVAL;
 	}
@@ -2899,14 +2901,12 @@ il4965_set_default_wep_key(struct il_priv *il, struct il_rxon_context *ctx,
 	keyconf->hw_key_idx = HW_KEY_DEFAULT;
 	il->stations[IL_AP_ID].keyinfo.cipher = keyconf->cipher;
 
-	ctx->wep_keys[keyconf->keyidx].key_size = keyconf->keylen;
-	memcpy(&ctx->wep_keys[keyconf->keyidx].key, &keyconf->key,
-	       keyconf->keylen);
+	il->_4965.wep_keys[idx].key_size = len;
+	memcpy(&il->_4965.wep_keys[idx].key, &keyconf->key, len);
 
 	ret = il4965_static_wepkey_cmd(il, ctx, false);
-	D_WEP("Set default WEP key: len=%d idx=%d ret=%d\n", keyconf->keylen,
-	      keyconf->keyidx, ret);
 
+	D_WEP("Set default WEP key: len=%d idx=%d ret=%d\n", len, idx, ret);
 	return ret;
 }
 
@@ -3106,7 +3106,7 @@ il4965_remove_dynamic_key(struct il_priv *il, struct il_rxon_context *ctx,
 
 	lockdep_assert_held(&il->mutex);
 
-	ctx->key_mapping_keys--;
+	il->_4965.key_mapping_keys--;
 
 	spin_lock_irqsave(&il->sta_lock, flags);
 	key_flags = le16_to_cpu(il->stations[sta_id].sta.key.key_flags);
@@ -3164,7 +3164,7 @@ il4965_set_dynamic_key(struct il_priv *il, struct il_rxon_context *ctx,
 
 	lockdep_assert_held(&il->mutex);
 
-	ctx->key_mapping_keys++;
+	il->_4965.key_mapping_keys++;
 	keyconf->hw_key_idx = HW_KEY_DYNAMIC;
 
 	switch (keyconf->cipher) {
@@ -5067,6 +5067,20 @@ __il4965_down(struct il_priv *il)
 	del_timer_sync(&il->watchdog);
 
 	il_clear_ucode_stations(il, NULL);
+
+	/* FIXME: race conditions ? */
+	spin_lock_irq(&il->sta_lock);
+	/*
+	 * Remove all key information that is not stored as part
+	 * of station information since mac80211 may not have had
+	 * a chance to remove all the keys. When device is
+	 * reconfigured by mac80211 after an error all keys will
+	 * be reconfigured.
+	 */
+	memset(il->_4965.wep_keys, 0, sizeof(il->_4965.wep_keys));
+	il->_4965.key_mapping_keys = 0;
+	spin_unlock_irq(&il->sta_lock);
+
 	il_dealloc_bcast_stations(il);
 	il_clear_driver_stations(il);
 
@@ -5613,7 +5627,7 @@ il4965_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	if ((key->cipher == WLAN_CIPHER_SUITE_WEP40 ||
 	     key->cipher == WLAN_CIPHER_SUITE_WEP104) && !sta) {
 		if (cmd == SET_KEY)
-			is_default_wep_key = !ctx->key_mapping_keys;
+			is_default_wep_key = !il->_4965.key_mapping_keys;
 		else
 			is_default_wep_key =
 			    (key->hw_key_idx == HW_KEY_DEFAULT);
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 89922e0..811e768 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1169,9 +1169,6 @@ struct il_rxon_context {
 
 	struct il_qos_info qos_data;
 
-	struct il_wep_key wep_keys[WEP_KEYS_MAX];
-	u8 key_mapping_keys;
-
 	__le32 station_flags;
 
 	struct {
@@ -1417,6 +1414,9 @@ struct il_priv {
 			u8 phy_calib_chain_noise_reset_cmd;
 			u8 phy_calib_chain_noise_gain_cmd;
 
+			u8 key_mapping_keys;
+			struct il_wep_key wep_keys[WEP_KEYS_MAX];
+
 			struct il_notif_stats stats;
 #ifdef CONFIG_IWLEGACY_DEBUGFS
 			struct il_notif_stats accum_stats;
@@ -2318,24 +2318,11 @@ static inline void
 il_clear_driver_stations(struct il_priv *il)
 {
 	unsigned long flags;
-	struct il_rxon_context *ctx = &il->ctx;
 
 	spin_lock_irqsave(&il->sta_lock, flags);
 	memset(il->stations, 0, sizeof(il->stations));
 	il->num_stations = 0;
-
 	il->ucode_key_table = 0;
-
-	/*
-	 * Remove all key information that is not stored as part
-	 * of station information since mac80211 may not have had
-	 * a chance to remove all the keys. When device is
-	 * reconfigured by mac80211 after an error all keys will
-	 * be reconfigured.
-	 */
-	memset(ctx->wep_keys, 0, sizeof(ctx->wep_keys));
-	ctx->key_mapping_keys = 0;
-
 	spin_unlock_irqrestore(&il->sta_lock, flags);
 }
 
-- 
1.7.1

