Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:43574 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080Ab0H0Q4v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 12:56:51 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 12/27] iwlwifi: make hw crypto context aware
Date: Fri, 27 Aug 2010 09:59:40 -0700
Message-Id: <1282928395-32762-13-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282928395-32762-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

HW crypto needs to be aware of the context, and there
are different command IDs for the WEP keys per context,
so move the key tracking variables and command IDs into
the context structure.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 +
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   17 ++++++++---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    1 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    9 ++++-
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   41 +++++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-sta.h      |   27 +++++++++++------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 +
 7 files changed, 63 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index ba3a9f9..5d09686 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2430,6 +2430,8 @@ int iwl3945_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.max_stations = IWL3945_STATION_COUNT;
 	priv->contexts[IWL_RXON_CTX_BSS].bcast_sta_id = IWL3945_BROADCAST_ID;
 
+	priv->sta_key_max_num = STA_KEY_MAX_NUM;
+
 	priv->hw_params.rx_wrt_ptr_reg = FH39_RSCSR_CHNL0_WPTR;
 	priv->hw_params.max_beacon_itrvl = IWL39_MAX_UCODE_BEACON_INTERVAL;
 	priv->hw_params.beacon_time_tsf_bits = IWL3945_EXT_BEACON_TIME_POS;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index a67b04b..837406e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -165,7 +165,7 @@ int iwl_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 		}
 		iwl_clear_ucode_stations(priv, ctx);
 		iwl_restore_stations(priv, ctx);
-		ret = iwl_restore_default_wep_keys(priv);
+		ret = iwl_restore_default_wep_keys(priv, ctx);
 		if (ret) {
 			IWL_ERR(priv, "Failed to restore WEP keys (%d)\n", ret);
 			return ret;
@@ -197,7 +197,7 @@ int iwl_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 		memcpy(active_rxon, &ctx->staging, sizeof(*active_rxon));
 		iwl_clear_ucode_stations(priv, ctx);
 		iwl_restore_stations(priv, ctx);
-		ret = iwl_restore_default_wep_keys(priv);
+		ret = iwl_restore_default_wep_keys(priv, ctx);
 		if (ret) {
 			IWL_ERR(priv, "Failed to restore WEP keys (%d)\n", ret);
 			return ret;
@@ -2222,6 +2222,11 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 		priv->_agn.inst_evtlog_size = priv->cfg->max_event_log_size;
 	priv->_agn.inst_errlog_ptr = pieces.inst_errlog_ptr;
 
+	if (priv->valid_contexts == BIT(IWL_RXON_CTX_BSS))
+		priv->sta_key_max_num = STA_KEY_MAX_NUM;
+	else
+		priv->sta_key_max_num = STA_KEY_MAX_NUM_PAN;
+
 	/* Copy images into buffers for card's bus-master reads ... */
 
 	/* Runtime instructions (first block of data in file) */
@@ -3548,6 +3553,7 @@ static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 {
 	struct iwl_priv *priv = hw->priv;
 	struct iwl_vif_priv *vif_priv = (void *)vif->drv_priv;
+	struct iwl_rxon_context *ctx = vif_priv->ctx;
 	int ret;
 	u8 sta_id;
 	bool is_default_wep_key = false;
@@ -3576,7 +3582,7 @@ static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	     key->cipher == WLAN_CIPHER_SUITE_WEP104) &&
 	    !sta) {
 		if (cmd == SET_KEY)
-			is_default_wep_key = !priv->key_mapping_key;
+			is_default_wep_key = !ctx->key_mapping_keys;
 		else
 			is_default_wep_key =
 					(key->hw_key_idx == HW_KEY_DEFAULT);
@@ -3594,9 +3600,9 @@ static int iwl_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		break;
 	case DISABLE_KEY:
 		if (is_default_wep_key)
-			ret = iwl_remove_default_wep_key(priv, key);
+			ret = iwl_remove_default_wep_key(priv, ctx, key);
 		else
-			ret = iwl_remove_dynamic_key(priv, key, sta_id);
+			ret = iwl_remove_dynamic_key(priv, ctx, key, sta_id);
 
 		IWL_DEBUG_MAC80211(priv, "disable hwcrypto key\n");
 		break;
@@ -4209,6 +4215,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	priv->contexts[IWL_RXON_CTX_BSS].rxon_assoc_cmd = REPLY_RXON_ASSOC;
 	priv->contexts[IWL_RXON_CTX_BSS].qos_cmd = REPLY_QOS_PARAM;
 	priv->contexts[IWL_RXON_CTX_BSS].ap_sta_id = IWL_AP_ID;
+	priv->contexts[IWL_RXON_CTX_BSS].wep_key_cmd = REPLY_WEPKEY;
 	BUILD_BUG_ON(NUM_IWL_RXON_CTX != 1);
 
 	SET_IEEE80211_DEV(hw, &pdev->dev);
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 9b53583..55779bf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1001,6 +1001,7 @@ struct iwl_qosparam_cmd {
 #define STA_KEY_FLG_KEY_SIZE_MSK     cpu_to_le16(0x1000)
 #define STA_KEY_MULTICAST_MSK        cpu_to_le16(0x4000)
 #define STA_KEY_MAX_NUM		8
+#define STA_KEY_MAX_NUM_PAN	16
 
 /* Flags indicate whether to modify vs. don't change various station params */
 #define	STA_MODIFY_KEY_MASK		0x01
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index d1400a0..ef7862b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1133,6 +1133,10 @@ struct iwl_rxon_context {
 
 	u8 rxon_cmd, rxon_assoc_cmd, rxon_timing_cmd;
 	u8 qos_cmd;
+	u8 wep_key_cmd;
+
+	struct iwl_wep_key wep_keys[WEP_KEYS_MAX];
+	u8 key_mapping_keys;
 };
 
 struct iwl_priv {
@@ -1217,6 +1221,9 @@ struct iwl_priv {
 	/* command queue number */
 	u8 cmd_queue;
 
+	/* max number of station keys */
+	u8 sta_key_max_num;
+
 	/* EEPROM MAC addresses */
 	struct mac_address addresses[2];
 
@@ -1296,8 +1303,6 @@ struct iwl_priv {
 	spinlock_t sta_lock;
 	int num_stations;
 	struct iwl_station_entry stations[IWL_STATION_COUNT];
-	struct iwl_wep_key wep_keys[WEP_KEYS_MAX]; /* protected by mutex */
-	u8 key_mapping_key;
 	unsigned long ucode_key_table;
 
 	/* queue refcounts */
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index f5500cc..ac6e2be 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -724,7 +724,7 @@ int iwl_get_free_ucode_key_index(struct iwl_priv *priv)
 {
 	int i;
 
-	for (i = 0; i < STA_KEY_MAX_NUM; i++)
+	for (i = 0; i < priv->sta_key_max_num; i++)
 		if (!test_and_set_bit(i, &priv->ucode_key_table))
 			return i;
 
@@ -732,7 +732,9 @@ int iwl_get_free_ucode_key_index(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_get_free_ucode_key_index);
 
-static int iwl_send_static_wepkey_cmd(struct iwl_priv *priv, u8 send_if_empty)
+static int iwl_send_static_wepkey_cmd(struct iwl_priv *priv,
+				      struct iwl_rxon_context *ctx,
+				      bool send_if_empty)
 {
 	int i, not_empty = 0;
 	u8 buff[sizeof(struct iwl_wep_cmd) +
@@ -740,7 +742,7 @@ static int iwl_send_static_wepkey_cmd(struct iwl_priv *priv, u8 send_if_empty)
 	struct iwl_wep_cmd *wep_cmd = (struct iwl_wep_cmd *)buff;
 	size_t cmd_size  = sizeof(struct iwl_wep_cmd);
 	struct iwl_host_cmd cmd = {
-		.id = REPLY_WEPKEY,
+		.id = ctx->wep_key_cmd,
 		.data = wep_cmd,
 		.flags = CMD_SYNC,
 	};
@@ -752,16 +754,16 @@ static int iwl_send_static_wepkey_cmd(struct iwl_priv *priv, u8 send_if_empty)
 
 	for (i = 0; i < WEP_KEYS_MAX ; i++) {
 		wep_cmd->key[i].key_index = i;
-		if (priv->wep_keys[i].key_size) {
+		if (ctx->wep_keys[i].key_size) {
 			wep_cmd->key[i].key_offset = i;
 			not_empty = 1;
 		} else {
 			wep_cmd->key[i].key_offset = WEP_INVALID_OFFSET;
 		}
 
-		wep_cmd->key[i].key_size = priv->wep_keys[i].key_size;
-		memcpy(&wep_cmd->key[i].key[3], priv->wep_keys[i].key,
-				priv->wep_keys[i].key_size);
+		wep_cmd->key[i].key_size = ctx->wep_keys[i].key_size;
+		memcpy(&wep_cmd->key[i].key[3], ctx->wep_keys[i].key,
+				ctx->wep_keys[i].key_size);
 	}
 
 	wep_cmd->global_key_type = WEP_KEY_WEP_TYPE;
@@ -777,15 +779,17 @@ static int iwl_send_static_wepkey_cmd(struct iwl_priv *priv, u8 send_if_empty)
 		return 0;
 }
 
-int iwl_restore_default_wep_keys(struct iwl_priv *priv)
+int iwl_restore_default_wep_keys(struct iwl_priv *priv,
+				 struct iwl_rxon_context *ctx)
 {
 	lockdep_assert_held(&priv->mutex);
 
-	return iwl_send_static_wepkey_cmd(priv, 0);
+	return iwl_send_static_wepkey_cmd(priv, ctx, false);
 }
 EXPORT_SYMBOL(iwl_restore_default_wep_keys);
 
 int iwl_remove_default_wep_key(struct iwl_priv *priv,
+			       struct iwl_rxon_context *ctx,
 			       struct ieee80211_key_conf *keyconf)
 {
 	int ret;
@@ -795,13 +799,13 @@ int iwl_remove_default_wep_key(struct iwl_priv *priv,
 	IWL_DEBUG_WEP(priv, "Removing default WEP key: idx=%d\n",
 		      keyconf->keyidx);
 
-	memset(&priv->wep_keys[keyconf->keyidx], 0, sizeof(priv->wep_keys[0]));
+	memset(&ctx->wep_keys[keyconf->keyidx], 0, sizeof(ctx->wep_keys[0]));
 	if (iwl_is_rfkill(priv)) {
 		IWL_DEBUG_WEP(priv, "Not sending REPLY_WEPKEY command due to RFKILL.\n");
 		/* but keys in device are clear anyway so return success */
 		return 0;
 	}
-	ret = iwl_send_static_wepkey_cmd(priv, 1);
+	ret = iwl_send_static_wepkey_cmd(priv, ctx, 1);
 	IWL_DEBUG_WEP(priv, "Remove default WEP key: idx=%d ret=%d\n",
 		      keyconf->keyidx, ret);
 
@@ -827,11 +831,11 @@ int iwl_set_default_wep_key(struct iwl_priv *priv,
 	keyconf->hw_key_idx = HW_KEY_DEFAULT;
 	priv->stations[ctx->ap_sta_id].keyinfo.cipher = keyconf->cipher;
 
-	priv->wep_keys[keyconf->keyidx].key_size = keyconf->keylen;
-	memcpy(&priv->wep_keys[keyconf->keyidx].key, &keyconf->key,
+	ctx->wep_keys[keyconf->keyidx].key_size = keyconf->keylen;
+	memcpy(&ctx->wep_keys[keyconf->keyidx].key, &keyconf->key,
 							keyconf->keylen);
 
-	ret = iwl_send_static_wepkey_cmd(priv, 0);
+	ret = iwl_send_static_wepkey_cmd(priv, ctx, false);
 	IWL_DEBUG_WEP(priv, "Set default WEP key: len=%d idx=%d ret=%d\n",
 		keyconf->keylen, keyconf->keyidx, ret);
 
@@ -1029,8 +1033,9 @@ void iwl_update_tkip_key(struct iwl_priv *priv,
 EXPORT_SYMBOL(iwl_update_tkip_key);
 
 int iwl_remove_dynamic_key(struct iwl_priv *priv,
-				struct ieee80211_key_conf *keyconf,
-				u8 sta_id)
+			   struct iwl_rxon_context *ctx,
+			   struct ieee80211_key_conf *keyconf,
+			   u8 sta_id)
 {
 	unsigned long flags;
 	u16 key_flags;
@@ -1039,7 +1044,7 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 
 	lockdep_assert_held(&priv->mutex);
 
-	priv->key_mapping_key--;
+	ctx->key_mapping_keys--;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
 	key_flags = le16_to_cpu(priv->stations[sta_id].sta.key.key_flags);
@@ -1098,7 +1103,7 @@ int iwl_set_dynamic_key(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 
 	lockdep_assert_held(&priv->mutex);
 
-	priv->key_mapping_key++;
+	ctx->key_mapping_keys++;
 	keyconf->hw_key_idx = HW_KEY_DYNAMIC;
 
 	switch (keyconf->cipher) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.h b/drivers/net/wireless/iwlwifi/iwl-sta.h
index b7f7006..6ab5587 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.h
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.h
@@ -44,14 +44,16 @@
 
 
 int iwl_remove_default_wep_key(struct iwl_priv *priv,
+			       struct iwl_rxon_context *ctx,
 			       struct ieee80211_key_conf *key);
 int iwl_set_default_wep_key(struct iwl_priv *priv,
 			    struct iwl_rxon_context *ctx,
 			    struct ieee80211_key_conf *key);
-int iwl_restore_default_wep_keys(struct iwl_priv *priv);
+int iwl_restore_default_wep_keys(struct iwl_priv *priv,
+				 struct iwl_rxon_context *ctx);
 int iwl_set_dynamic_key(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 			struct ieee80211_key_conf *key, u8 sta_id);
-int iwl_remove_dynamic_key(struct iwl_priv *priv,
+int iwl_remove_dynamic_key(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 			   struct ieee80211_key_conf *key, u8 sta_id);
 void iwl_update_tkip_key(struct iwl_priv *priv,
 			 struct iwl_rxon_context *ctx,
@@ -97,20 +99,25 @@ void iwl_sta_modify_sleep_tx_count(struct iwl_priv *priv, int sta_id, int cnt);
 static inline void iwl_clear_driver_stations(struct iwl_priv *priv)
 {
 	unsigned long flags;
+	struct iwl_rxon_context *ctx;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
 	memset(priv->stations, 0, sizeof(priv->stations));
 	priv->num_stations = 0;
 
-	/*
-	 * Remove all key information that is not stored as part of station
-	 * information since mac80211 may not have had a
-	 * chance to remove all the keys. When device is reconfigured by
-	 * mac80211 after an error all keys will be reconfigured.
-	 */
 	priv->ucode_key_table = 0;
-	priv->key_mapping_key = 0;
-	memset(priv->wep_keys, 0, sizeof(priv->wep_keys));
+
+	for_each_context(priv, ctx) {
+		/*
+		 * Remove all key information that is not stored as part
+		 * of station information since mac80211 may not have had
+		 * a chance to remove all the keys. When device is
+		 * reconfigured by mac80211 after an error all keys will
+		 * be reconfigured.
+		 */
+		memset(ctx->wep_keys, 0, sizeof(ctx->wep_keys));
+		ctx->key_mapping_keys = 0;
+	}
 
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 29d1376..be48f79 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4022,6 +4022,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	priv->contexts[IWL_RXON_CTX_BSS].rxon_assoc_cmd = REPLY_RXON_ASSOC;
 	priv->contexts[IWL_RXON_CTX_BSS].qos_cmd = REPLY_QOS_PARAM;
 	priv->contexts[IWL_RXON_CTX_BSS].ap_sta_id = IWL_AP_ID;
+	priv->contexts[IWL_RXON_CTX_BSS].wep_key_cmd = REPLY_WEPKEY;
 
 	/*
 	 * Disabling hardware scan means that mac80211 will perform scans
-- 
1.7.0.4

