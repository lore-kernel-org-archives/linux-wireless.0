Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56484 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247Ab1KJBdf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 20:33:35 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 17/28] iwlwifi: Move the core suspend function to iwl-agn-lib
Date: Wed,  9 Nov 2011 16:39:20 -0800
Message-Id: <1320885571-19122-18-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111110_023401_800792_071A07F8)
In-Reply-To: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1320885571-19122-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The core suspend function is part of agn, iwl_mac80211 should only
handle mac80211 I/F operations.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |  357 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    6 +
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |  347 +--------------------------
 3 files changed, 365 insertions(+), 345 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 6465983..0bc9622 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -984,3 +984,360 @@ void iwlagn_remove_notification(struct iwl_priv *priv,
 	list_del(&wait_entry->list);
 	spin_unlock_bh(&priv->notif_wait_lock);
 }
+
+#ifdef CONFIG_PM_SLEEP
+static void iwlagn_convert_p1k(u16 *p1k, __le16 *out)
+{
+	int i;
+
+	for (i = 0; i < IWLAGN_P1K_SIZE; i++)
+		out[i] = cpu_to_le16(p1k[i]);
+}
+
+struct wowlan_key_data {
+	struct iwl_rxon_context *ctx;
+	struct iwlagn_wowlan_rsc_tsc_params_cmd *rsc_tsc;
+	struct iwlagn_wowlan_tkip_params_cmd *tkip;
+	const u8 *bssid;
+	bool error, use_rsc_tsc, use_tkip;
+};
+
+
+static void iwlagn_wowlan_program_keys(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif,
+			       struct ieee80211_sta *sta,
+			       struct ieee80211_key_conf *key,
+			       void *_data)
+{
+	struct iwl_priv *priv = hw->priv;
+	struct wowlan_key_data *data = _data;
+	struct iwl_rxon_context *ctx = data->ctx;
+	struct aes_sc *aes_sc, *aes_tx_sc = NULL;
+	struct tkip_sc *tkip_sc, *tkip_tx_sc = NULL;
+	struct iwlagn_p1k_cache *rx_p1ks;
+	u8 *rx_mic_key;
+	struct ieee80211_key_seq seq;
+	u32 cur_rx_iv32 = 0;
+	u16 p1k[IWLAGN_P1K_SIZE];
+	int ret, i;
+
+	mutex_lock(&priv->shrd->mutex);
+
+	if ((key->cipher == WLAN_CIPHER_SUITE_WEP40 ||
+	     key->cipher == WLAN_CIPHER_SUITE_WEP104) &&
+	     !sta && !ctx->key_mapping_keys)
+		ret = iwl_set_default_wep_key(priv, ctx, key);
+	else
+		ret = iwl_set_dynamic_key(priv, ctx, key, sta);
+
+	if (ret) {
+		IWL_ERR(priv, "Error setting key during suspend!\n");
+		data->error = true;
+	}
+
+	switch (key->cipher) {
+	case WLAN_CIPHER_SUITE_TKIP:
+		if (sta) {
+			tkip_sc = data->rsc_tsc->all_tsc_rsc.tkip.unicast_rsc;
+			tkip_tx_sc = &data->rsc_tsc->all_tsc_rsc.tkip.tsc;
+
+			rx_p1ks = data->tkip->rx_uni;
+
+			ieee80211_get_key_tx_seq(key, &seq);
+			tkip_tx_sc->iv16 = cpu_to_le16(seq.tkip.iv16);
+			tkip_tx_sc->iv32 = cpu_to_le32(seq.tkip.iv32);
+
+			ieee80211_get_tkip_p1k_iv(key, seq.tkip.iv32, p1k);
+			iwlagn_convert_p1k(p1k, data->tkip->tx.p1k);
+
+			memcpy(data->tkip->mic_keys.tx,
+			       &key->key[NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY],
+			       IWLAGN_MIC_KEY_SIZE);
+
+			rx_mic_key = data->tkip->mic_keys.rx_unicast;
+		} else {
+			tkip_sc =
+				data->rsc_tsc->all_tsc_rsc.tkip.multicast_rsc;
+			rx_p1ks = data->tkip->rx_multi;
+			rx_mic_key = data->tkip->mic_keys.rx_mcast;
+		}
+
+		/*
+		 * For non-QoS this relies on the fact that both the uCode and
+		 * mac80211 use TID 0 (as they need to to avoid replay attacks)
+		 * for checking the IV in the frames.
+		 */
+		for (i = 0; i < IWLAGN_NUM_RSC; i++) {
+			ieee80211_get_key_rx_seq(key, i, &seq);
+			tkip_sc[i].iv16 = cpu_to_le16(seq.tkip.iv16);
+			tkip_sc[i].iv32 = cpu_to_le32(seq.tkip.iv32);
+			/* wrapping isn't allowed, AP must rekey */
+			if (seq.tkip.iv32 > cur_rx_iv32)
+				cur_rx_iv32 = seq.tkip.iv32;
+		}
+
+		ieee80211_get_tkip_rx_p1k(key, data->bssid, cur_rx_iv32, p1k);
+		iwlagn_convert_p1k(p1k, rx_p1ks[0].p1k);
+		ieee80211_get_tkip_rx_p1k(key, data->bssid,
+					  cur_rx_iv32 + 1, p1k);
+		iwlagn_convert_p1k(p1k, rx_p1ks[1].p1k);
+
+		memcpy(rx_mic_key,
+		       &key->key[NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY],
+		       IWLAGN_MIC_KEY_SIZE);
+
+		data->use_tkip = true;
+		data->use_rsc_tsc = true;
+		break;
+	case WLAN_CIPHER_SUITE_CCMP:
+		if (sta) {
+			u8 *pn = seq.ccmp.pn;
+
+			aes_sc = data->rsc_tsc->all_tsc_rsc.aes.unicast_rsc;
+			aes_tx_sc = &data->rsc_tsc->all_tsc_rsc.aes.tsc;
+
+			ieee80211_get_key_tx_seq(key, &seq);
+			aes_tx_sc->pn = cpu_to_le64(
+					(u64)pn[5] |
+					((u64)pn[4] << 8) |
+					((u64)pn[3] << 16) |
+					((u64)pn[2] << 24) |
+					((u64)pn[1] << 32) |
+					((u64)pn[0] << 40));
+		} else
+			aes_sc = data->rsc_tsc->all_tsc_rsc.aes.multicast_rsc;
+
+		/*
+		 * For non-QoS this relies on the fact that both the uCode and
+		 * mac80211 use TID 0 for checking the IV in the frames.
+		 */
+		for (i = 0; i < IWLAGN_NUM_RSC; i++) {
+			u8 *pn = seq.ccmp.pn;
+
+			ieee80211_get_key_rx_seq(key, i, &seq);
+			aes_sc->pn = cpu_to_le64(
+					(u64)pn[5] |
+					((u64)pn[4] << 8) |
+					((u64)pn[3] << 16) |
+					((u64)pn[2] << 24) |
+					((u64)pn[1] << 32) |
+					((u64)pn[0] << 40));
+		}
+		data->use_rsc_tsc = true;
+		break;
+	}
+
+	mutex_unlock(&priv->shrd->mutex);
+}
+
+int iwlagn_send_patterns(struct iwl_priv *priv,
+			struct cfg80211_wowlan *wowlan)
+{
+	struct iwlagn_wowlan_patterns_cmd *pattern_cmd;
+	struct iwl_host_cmd cmd = {
+		.id = REPLY_WOWLAN_PATTERNS,
+		.dataflags[0] = IWL_HCMD_DFL_NOCOPY,
+		.flags = CMD_SYNC,
+	};
+	int i, err;
+
+	if (!wowlan->n_patterns)
+		return 0;
+
+	cmd.len[0] = sizeof(*pattern_cmd) +
+		wowlan->n_patterns * sizeof(struct iwlagn_wowlan_pattern);
+
+	pattern_cmd = kmalloc(cmd.len[0], GFP_KERNEL);
+	if (!pattern_cmd)
+		return -ENOMEM;
+
+	pattern_cmd->n_patterns = cpu_to_le32(wowlan->n_patterns);
+
+	for (i = 0; i < wowlan->n_patterns; i++) {
+		int mask_len = DIV_ROUND_UP(wowlan->patterns[i].pattern_len, 8);
+
+		memcpy(&pattern_cmd->patterns[i].mask,
+			wowlan->patterns[i].mask, mask_len);
+		memcpy(&pattern_cmd->patterns[i].pattern,
+			wowlan->patterns[i].pattern,
+			wowlan->patterns[i].pattern_len);
+		pattern_cmd->patterns[i].mask_size = mask_len;
+		pattern_cmd->patterns[i].pattern_size =
+			wowlan->patterns[i].pattern_len;
+	}
+
+	cmd.data[0] = pattern_cmd;
+	err = iwl_trans_send_cmd(trans(priv), &cmd);
+	kfree(pattern_cmd);
+	return err;
+}
+
+int iwlagn_suspend(struct iwl_priv *priv,
+		struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
+{
+	struct iwlagn_wowlan_wakeup_filter_cmd wakeup_filter_cmd;
+	struct iwl_rxon_cmd rxon;
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
+	struct iwlagn_wowlan_kek_kck_material_cmd kek_kck_cmd;
+	struct iwlagn_wowlan_tkip_params_cmd tkip_cmd = {};
+	struct iwlagn_d3_config_cmd d3_cfg_cmd = {};
+	struct wowlan_key_data key_data = {
+		.ctx = ctx,
+		.bssid = ctx->active.bssid_addr,
+		.use_rsc_tsc = false,
+		.tkip = &tkip_cmd,
+		.use_tkip = false,
+	};
+	int ret, i;
+	u16 seq;
+
+	key_data.rsc_tsc = kzalloc(sizeof(*key_data.rsc_tsc), GFP_KERNEL);
+	if (!key_data.rsc_tsc)
+		return -ENOMEM;
+
+	memset(&wakeup_filter_cmd, 0, sizeof(wakeup_filter_cmd));
+
+	/*
+	 * We know the last used seqno, and the uCode expects to know that
+	 * one, it will increment before TX.
+	 */
+	seq = le16_to_cpu(priv->last_seq_ctl) & IEEE80211_SCTL_SEQ;
+	wakeup_filter_cmd.non_qos_seq = cpu_to_le16(seq);
+
+	/*
+	 * For QoS counters, we store the one to use next, so subtract 0x10
+	 * since the uCode will add 0x10 before using the value.
+	 */
+	for (i = 0; i < 8; i++) {
+		seq = priv->shrd->tid_data[IWL_AP_ID][i].seq_number;
+		seq -= 0x10;
+		wakeup_filter_cmd.qos_seq[i] = cpu_to_le16(seq);
+	}
+
+	if (wowlan->disconnect)
+		wakeup_filter_cmd.enabled |=
+			cpu_to_le32(IWLAGN_WOWLAN_WAKEUP_BEACON_MISS |
+				    IWLAGN_WOWLAN_WAKEUP_LINK_CHANGE);
+	if (wowlan->magic_pkt)
+		wakeup_filter_cmd.enabled |=
+			cpu_to_le32(IWLAGN_WOWLAN_WAKEUP_MAGIC_PACKET);
+	if (wowlan->gtk_rekey_failure)
+		wakeup_filter_cmd.enabled |=
+			cpu_to_le32(IWLAGN_WOWLAN_WAKEUP_GTK_REKEY_FAIL);
+	if (wowlan->eap_identity_req)
+		wakeup_filter_cmd.enabled |=
+			cpu_to_le32(IWLAGN_WOWLAN_WAKEUP_EAP_IDENT_REQ);
+	if (wowlan->four_way_handshake)
+		wakeup_filter_cmd.enabled |=
+			cpu_to_le32(IWLAGN_WOWLAN_WAKEUP_4WAY_HANDSHAKE);
+	if (wowlan->n_patterns)
+		wakeup_filter_cmd.enabled |=
+			cpu_to_le32(IWLAGN_WOWLAN_WAKEUP_PATTERN_MATCH);
+
+	if (wowlan->rfkill_release)
+		d3_cfg_cmd.wakeup_flags |=
+			cpu_to_le32(IWLAGN_D3_WAKEUP_RFKILL);
+
+	iwl_scan_cancel_timeout(priv, 200);
+
+	memcpy(&rxon, &ctx->active, sizeof(rxon));
+
+	iwl_trans_stop_device(trans(priv));
+
+	priv->shrd->wowlan = true;
+
+	ret = iwlagn_load_ucode_wait_alive(priv, IWL_UCODE_WOWLAN);
+	if (ret)
+		goto out;
+
+	/* now configure WoWLAN ucode */
+	ret = iwl_alive_start(priv);
+	if (ret)
+		goto out;
+
+	memcpy(&ctx->staging, &rxon, sizeof(rxon));
+	ret = iwlagn_commit_rxon(priv, ctx);
+	if (ret)
+		goto out;
+
+	ret = iwl_power_update_mode(priv, true);
+	if (ret)
+		goto out;
+
+	if (!iwlagn_mod_params.sw_crypto) {
+		/* mark all keys clear */
+		priv->ucode_key_table = 0;
+		ctx->key_mapping_keys = 0;
+
+		/*
+		 * This needs to be unlocked due to lock ordering
+		 * constraints. Since we're in the suspend path
+		 * that isn't really a problem though.
+		 */
+		mutex_unlock(&priv->shrd->mutex);
+		ieee80211_iter_keys(priv->hw, ctx->vif,
+				    iwlagn_wowlan_program_keys,
+				    &key_data);
+		mutex_lock(&priv->shrd->mutex);
+		if (key_data.error) {
+			ret = -EIO;
+			goto out;
+		}
+
+		if (key_data.use_rsc_tsc) {
+			struct iwl_host_cmd rsc_tsc_cmd = {
+				.id = REPLY_WOWLAN_TSC_RSC_PARAMS,
+				.flags = CMD_SYNC,
+				.data[0] = key_data.rsc_tsc,
+				.dataflags[0] = IWL_HCMD_DFL_NOCOPY,
+				.len[0] = sizeof(key_data.rsc_tsc),
+			};
+
+			ret = iwl_trans_send_cmd(trans(priv), &rsc_tsc_cmd);
+			if (ret)
+				goto out;
+		}
+
+		if (key_data.use_tkip) {
+			ret = iwl_trans_send_cmd_pdu(trans(priv),
+						 REPLY_WOWLAN_TKIP_PARAMS,
+						 CMD_SYNC, sizeof(tkip_cmd),
+						 &tkip_cmd);
+			if (ret)
+				goto out;
+		}
+
+		if (priv->have_rekey_data) {
+			memset(&kek_kck_cmd, 0, sizeof(kek_kck_cmd));
+			memcpy(kek_kck_cmd.kck, priv->kck, NL80211_KCK_LEN);
+			kek_kck_cmd.kck_len = cpu_to_le16(NL80211_KCK_LEN);
+			memcpy(kek_kck_cmd.kek, priv->kek, NL80211_KEK_LEN);
+			kek_kck_cmd.kek_len = cpu_to_le16(NL80211_KEK_LEN);
+			kek_kck_cmd.replay_ctr = priv->replay_ctr;
+
+			ret = iwl_trans_send_cmd_pdu(trans(priv),
+						 REPLY_WOWLAN_KEK_KCK_MATERIAL,
+						 CMD_SYNC, sizeof(kek_kck_cmd),
+						 &kek_kck_cmd);
+			if (ret)
+				goto out;
+		}
+	}
+
+	ret = iwl_trans_send_cmd_pdu(trans(priv), REPLY_D3_CONFIG, CMD_SYNC,
+				     sizeof(d3_cfg_cmd), &d3_cfg_cmd);
+	if (ret)
+		goto out;
+
+	ret = iwl_trans_send_cmd_pdu(trans(priv), REPLY_WOWLAN_WAKEUP_FILTER,
+				 CMD_SYNC, sizeof(wakeup_filter_cmd),
+				 &wakeup_filter_cmd);
+	if (ret)
+		goto out;
+
+	ret = iwlagn_send_patterns(priv, wowlan);
+ out:
+	kfree(key_data.rsc_tsc);
+	return ret;
+}
+#endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index d325132..5d8d2f4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -119,6 +119,12 @@ u16 iwlagn_eeprom_calib_version(struct iwl_priv *priv);
 int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control);
 void iwlagn_dev_txfifo_flush(struct iwl_priv *priv, u16 flush_control);
 int iwlagn_send_beacon_cmd(struct iwl_priv *priv);
+#ifdef CONFIG_PM_SLEEP
+int iwlagn_send_patterns(struct iwl_priv *priv,
+			 struct cfg80211_wowlan *wowlan);
+int iwlagn_suspend(struct iwl_priv *priv,
+		   struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan);
+#endif
 
 /* rx */
 int iwlagn_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band);
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index b46702c..073e827 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -368,209 +368,13 @@ static void iwlagn_mac_set_rekey_data(struct ieee80211_hw *hw,
 }
 
 #ifdef CONFIG_PM_SLEEP
-struct wowlan_key_data {
-	struct iwl_rxon_context *ctx;
-	struct iwlagn_wowlan_rsc_tsc_params_cmd *rsc_tsc;
-	struct iwlagn_wowlan_tkip_params_cmd *tkip;
-	const u8 *bssid;
-	bool error, use_rsc_tsc, use_tkip;
-};
-
-static void iwlagn_convert_p1k(u16 *p1k, __le16 *out)
-{
-	int i;
-
-	for (i = 0; i < IWLAGN_P1K_SIZE; i++)
-		out[i] = cpu_to_le16(p1k[i]);
-}
-
-static void iwlagn_wowlan_program_keys(struct ieee80211_hw *hw,
-				       struct ieee80211_vif *vif,
-				       struct ieee80211_sta *sta,
-				       struct ieee80211_key_conf *key,
-				       void *_data)
-{
-	struct iwl_priv *priv = hw->priv;
-	struct wowlan_key_data *data = _data;
-	struct iwl_rxon_context *ctx = data->ctx;
-	struct aes_sc *aes_sc, *aes_tx_sc = NULL;
-	struct tkip_sc *tkip_sc, *tkip_tx_sc = NULL;
-	struct iwlagn_p1k_cache *rx_p1ks;
-	u8 *rx_mic_key;
-	struct ieee80211_key_seq seq;
-	u32 cur_rx_iv32 = 0;
-	u16 p1k[IWLAGN_P1K_SIZE];
-	int ret, i;
-
-	mutex_lock(&priv->shrd->mutex);
-
-	if ((key->cipher == WLAN_CIPHER_SUITE_WEP40 ||
-	     key->cipher == WLAN_CIPHER_SUITE_WEP104) &&
-	     !sta && !ctx->key_mapping_keys)
-		ret = iwl_set_default_wep_key(priv, ctx, key);
-	else
-		ret = iwl_set_dynamic_key(priv, ctx, key, sta);
-
-	if (ret) {
-		IWL_ERR(priv, "Error setting key during suspend!\n");
-		data->error = true;
-	}
-
-	switch (key->cipher) {
-	case WLAN_CIPHER_SUITE_TKIP:
-		if (sta) {
-			tkip_sc = data->rsc_tsc->all_tsc_rsc.tkip.unicast_rsc;
-			tkip_tx_sc = &data->rsc_tsc->all_tsc_rsc.tkip.tsc;
-
-			rx_p1ks = data->tkip->rx_uni;
-
-			ieee80211_get_key_tx_seq(key, &seq);
-			tkip_tx_sc->iv16 = cpu_to_le16(seq.tkip.iv16);
-			tkip_tx_sc->iv32 = cpu_to_le32(seq.tkip.iv32);
-
-			ieee80211_get_tkip_p1k_iv(key, seq.tkip.iv32, p1k);
-			iwlagn_convert_p1k(p1k, data->tkip->tx.p1k);
-
-			memcpy(data->tkip->mic_keys.tx,
-			       &key->key[NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY],
-			       IWLAGN_MIC_KEY_SIZE);
-
-			rx_mic_key = data->tkip->mic_keys.rx_unicast;
-		} else {
-			tkip_sc = data->rsc_tsc->all_tsc_rsc.tkip.multicast_rsc;
-			rx_p1ks = data->tkip->rx_multi;
-			rx_mic_key = data->tkip->mic_keys.rx_mcast;
-		}
-
-		/*
-		 * For non-QoS this relies on the fact that both the uCode and
-		 * mac80211 use TID 0 (as they need to to avoid replay attacks)
-		 * for checking the IV in the frames.
-		 */
-		for (i = 0; i < IWLAGN_NUM_RSC; i++) {
-			ieee80211_get_key_rx_seq(key, i, &seq);
-			tkip_sc[i].iv16 = cpu_to_le16(seq.tkip.iv16);
-			tkip_sc[i].iv32 = cpu_to_le32(seq.tkip.iv32);
-			/* wrapping isn't allowed, AP must rekey */
-			if (seq.tkip.iv32 > cur_rx_iv32)
-				cur_rx_iv32 = seq.tkip.iv32;
-		}
-
-		ieee80211_get_tkip_rx_p1k(key, data->bssid, cur_rx_iv32, p1k);
-		iwlagn_convert_p1k(p1k, rx_p1ks[0].p1k);
-		ieee80211_get_tkip_rx_p1k(key, data->bssid,
-					  cur_rx_iv32 + 1, p1k);
-		iwlagn_convert_p1k(p1k, rx_p1ks[1].p1k);
-
-		memcpy(rx_mic_key,
-		       &key->key[NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY],
-		       IWLAGN_MIC_KEY_SIZE);
-
-		data->use_tkip = true;
-		data->use_rsc_tsc = true;
-		break;
-	case WLAN_CIPHER_SUITE_CCMP:
-		if (sta) {
-			u8 *pn = seq.ccmp.pn;
-
-			aes_sc = data->rsc_tsc->all_tsc_rsc.aes.unicast_rsc;
-			aes_tx_sc = &data->rsc_tsc->all_tsc_rsc.aes.tsc;
-
-			ieee80211_get_key_tx_seq(key, &seq);
-			aes_tx_sc->pn = cpu_to_le64(
-					(u64)pn[5] |
-					((u64)pn[4] << 8) |
-					((u64)pn[3] << 16) |
-					((u64)pn[2] << 24) |
-					((u64)pn[1] << 32) |
-					((u64)pn[0] << 40));
-		} else
-			aes_sc = data->rsc_tsc->all_tsc_rsc.aes.multicast_rsc;
-
-		/*
-		 * For non-QoS this relies on the fact that both the uCode and
-		 * mac80211 use TID 0 for checking the IV in the frames.
-		 */
-		for (i = 0; i < IWLAGN_NUM_RSC; i++) {
-			u8 *pn = seq.ccmp.pn;
-
-			ieee80211_get_key_rx_seq(key, i, &seq);
-			aes_sc->pn = cpu_to_le64(
-					(u64)pn[5] |
-					((u64)pn[4] << 8) |
-					((u64)pn[3] << 16) |
-					((u64)pn[2] << 24) |
-					((u64)pn[1] << 32) |
-					((u64)pn[0] << 40));
-		}
-		data->use_rsc_tsc = true;
-		break;
-	}
-
-	mutex_unlock(&priv->shrd->mutex);
-}
-
-static int iwlagn_send_patterns(struct iwl_priv *priv,
-				struct cfg80211_wowlan *wowlan)
-{
-	struct iwlagn_wowlan_patterns_cmd *pattern_cmd;
-	struct iwl_host_cmd cmd = {
-		.id = REPLY_WOWLAN_PATTERNS,
-		.dataflags[0] = IWL_HCMD_DFL_NOCOPY,
-		.flags = CMD_SYNC,
-	};
-	int i, err;
-
-	if (!wowlan->n_patterns)
-		return 0;
-
-	cmd.len[0] = sizeof(*pattern_cmd) +
-		wowlan->n_patterns * sizeof(struct iwlagn_wowlan_pattern);
-
-	pattern_cmd = kmalloc(cmd.len[0], GFP_KERNEL);
-	if (!pattern_cmd)
-		return -ENOMEM;
-
-	pattern_cmd->n_patterns = cpu_to_le32(wowlan->n_patterns);
-
-	for (i = 0; i < wowlan->n_patterns; i++) {
-		int mask_len = DIV_ROUND_UP(wowlan->patterns[i].pattern_len, 8);
-
-		memcpy(&pattern_cmd->patterns[i].mask,
-			wowlan->patterns[i].mask, mask_len);
-		memcpy(&pattern_cmd->patterns[i].pattern,
-			wowlan->patterns[i].pattern,
-			wowlan->patterns[i].pattern_len);
-		pattern_cmd->patterns[i].mask_size = mask_len;
-		pattern_cmd->patterns[i].pattern_size =
-			wowlan->patterns[i].pattern_len;
-	}
-
-	cmd.data[0] = pattern_cmd;
-	err = iwl_trans_send_cmd(trans(priv), &cmd);
-	kfree(pattern_cmd);
-	return err;
-}
 
 static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
 			      struct cfg80211_wowlan *wowlan)
 {
 	struct iwl_priv *priv = hw->priv;
-	struct iwlagn_wowlan_wakeup_filter_cmd wakeup_filter_cmd;
-	struct iwl_rxon_cmd rxon;
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
-	struct iwlagn_wowlan_kek_kck_material_cmd kek_kck_cmd;
-	struct iwlagn_wowlan_tkip_params_cmd tkip_cmd = {};
-	struct wowlan_key_data key_data = {
-		.ctx = ctx,
-		.bssid = ctx->active.bssid_addr,
-		.use_rsc_tsc = false,
-		.tkip = &tkip_cmd,
-		.use_tkip = false,
-	};
-	struct iwlagn_d3_config_cmd d3_cfg_cmd = {};
-	int ret, i;
-	u16 seq;
+	int ret;
 
 	if (WARN_ON(!wowlan))
 		return -EINVAL;
@@ -585,153 +389,7 @@ static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
 		goto out;
 	}
 
-	key_data.rsc_tsc = kzalloc(sizeof(*key_data.rsc_tsc), GFP_KERNEL);
-	if (!key_data.rsc_tsc) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	memset(&wakeup_filter_cmd, 0, sizeof(wakeup_filter_cmd));
-
-	/*
-	 * We know the last used seqno, and the uCode expects to know that
-	 * one, it will increment before TX.
-	 */
-	seq = le16_to_cpu(priv->last_seq_ctl) & IEEE80211_SCTL_SEQ;
-	wakeup_filter_cmd.non_qos_seq = cpu_to_le16(seq);
-
-	/*
-	 * For QoS counters, we store the one to use next, so subtract 0x10
-	 * since the uCode will add 0x10 before using the value.
-	 */
-	for (i = 0; i < 8; i++) {
-		seq = priv->shrd->tid_data[IWL_AP_ID][i].seq_number;
-		seq -= 0x10;
-		wakeup_filter_cmd.qos_seq[i] = cpu_to_le16(seq);
-	}
-
-	if (wowlan->disconnect)
-		wakeup_filter_cmd.enabled |=
-			cpu_to_le32(IWLAGN_WOWLAN_WAKEUP_BEACON_MISS |
-				    IWLAGN_WOWLAN_WAKEUP_LINK_CHANGE);
-	if (wowlan->magic_pkt)
-		wakeup_filter_cmd.enabled |=
-			cpu_to_le32(IWLAGN_WOWLAN_WAKEUP_MAGIC_PACKET);
-	if (wowlan->gtk_rekey_failure)
-		wakeup_filter_cmd.enabled |=
-			cpu_to_le32(IWLAGN_WOWLAN_WAKEUP_GTK_REKEY_FAIL);
-	if (wowlan->eap_identity_req)
-		wakeup_filter_cmd.enabled |=
-			cpu_to_le32(IWLAGN_WOWLAN_WAKEUP_EAP_IDENT_REQ);
-	if (wowlan->four_way_handshake)
-		wakeup_filter_cmd.enabled |=
-			cpu_to_le32(IWLAGN_WOWLAN_WAKEUP_4WAY_HANDSHAKE);
-	if (wowlan->n_patterns)
-		wakeup_filter_cmd.enabled |=
-			cpu_to_le32(IWLAGN_WOWLAN_WAKEUP_PATTERN_MATCH);
-
-	if (wowlan->rfkill_release)
-		d3_cfg_cmd.wakeup_flags |=
-			cpu_to_le32(IWLAGN_D3_WAKEUP_RFKILL);
-
-	iwl_scan_cancel_timeout(priv, 200);
-
-	memcpy(&rxon, &ctx->active, sizeof(rxon));
-
-	iwl_trans_stop_device(trans(priv));
-
-	priv->shrd->wowlan = true;
-
-	ret = iwlagn_load_ucode_wait_alive(priv, IWL_UCODE_WOWLAN);
-	if (ret)
-		goto error;
-
-	/* now configure WoWLAN ucode */
-	ret = iwl_alive_start(priv);
-	if (ret)
-		goto error;
-
-	memcpy(&ctx->staging, &rxon, sizeof(rxon));
-	ret = iwlagn_commit_rxon(priv, ctx);
-	if (ret)
-		goto error;
-
-	ret = iwl_power_update_mode(priv, true);
-	if (ret)
-		goto error;
-
-	if (!iwlagn_mod_params.sw_crypto) {
-		/* mark all keys clear */
-		priv->ucode_key_table = 0;
-		ctx->key_mapping_keys = 0;
-
-		/*
-		 * This needs to be unlocked due to lock ordering
-		 * constraints. Since we're in the suspend path
-		 * that isn't really a problem though.
-		 */
-		mutex_unlock(&priv->shrd->mutex);
-		ieee80211_iter_keys(priv->hw, ctx->vif,
-				    iwlagn_wowlan_program_keys,
-				    &key_data);
-		mutex_lock(&priv->shrd->mutex);
-		if (key_data.error) {
-			ret = -EIO;
-			goto error;
-		}
-
-		if (key_data.use_rsc_tsc) {
-			struct iwl_host_cmd rsc_tsc_cmd = {
-				.id = REPLY_WOWLAN_TSC_RSC_PARAMS,
-				.flags = CMD_SYNC,
-				.data[0] = key_data.rsc_tsc,
-				.dataflags[0] = IWL_HCMD_DFL_NOCOPY,
-				.len[0] = sizeof(*key_data.rsc_tsc),
-			};
-
-			ret = iwl_trans_send_cmd(trans(priv), &rsc_tsc_cmd);
-			if (ret)
-				goto error;
-		}
-
-		if (key_data.use_tkip) {
-			ret = iwl_trans_send_cmd_pdu(trans(priv),
-						 REPLY_WOWLAN_TKIP_PARAMS,
-						 CMD_SYNC, sizeof(tkip_cmd),
-						 &tkip_cmd);
-			if (ret)
-				goto error;
-		}
-
-		if (priv->have_rekey_data) {
-			memset(&kek_kck_cmd, 0, sizeof(kek_kck_cmd));
-			memcpy(kek_kck_cmd.kck, priv->kck, NL80211_KCK_LEN);
-			kek_kck_cmd.kck_len = cpu_to_le16(NL80211_KCK_LEN);
-			memcpy(kek_kck_cmd.kek, priv->kek, NL80211_KEK_LEN);
-			kek_kck_cmd.kek_len = cpu_to_le16(NL80211_KEK_LEN);
-			kek_kck_cmd.replay_ctr = priv->replay_ctr;
-
-			ret = iwl_trans_send_cmd_pdu(trans(priv),
-						 REPLY_WOWLAN_KEK_KCK_MATERIAL,
-						 CMD_SYNC, sizeof(kek_kck_cmd),
-						 &kek_kck_cmd);
-			if (ret)
-				goto error;
-		}
-	}
-
-	ret = iwl_trans_send_cmd_pdu(trans(priv), REPLY_D3_CONFIG, CMD_SYNC,
-				     sizeof(d3_cfg_cmd), &d3_cfg_cmd);
-	if (ret)
-		goto error;
-
-	ret = iwl_trans_send_cmd_pdu(trans(priv), REPLY_WOWLAN_WAKEUP_FILTER,
-				 CMD_SYNC, sizeof(wakeup_filter_cmd),
-				 &wakeup_filter_cmd);
-	if (ret)
-		goto error;
-
-	ret = iwlagn_send_patterns(priv, wowlan);
+	ret = iwlagn_suspend(priv, hw, wowlan);
 	if (ret)
 		goto error;
 
@@ -749,7 +407,6 @@ static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
 	ieee80211_restart_hw(priv->hw);
  out:
 	mutex_unlock(&priv->shrd->mutex);
-	kfree(key_data.rsc_tsc);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 
 	return ret;
-- 
1.7.0.4

