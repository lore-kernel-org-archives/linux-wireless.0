Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47950 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888Ab1GUP0x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 11:26:53 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 20/25] iwlagn: implement WoWLAN
Date: Thu, 21 Jul 2011 07:50:23 -0700
Message-Id: <1311259828-8415-21-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110721_172722_827574_6B34449D)
In-Reply-To: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1311259828-8415-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Implement WoWLAN support in iwlagn. The device
supports a number of wakeup triggers and can do
GTK rekeying when asleep (if HW crypto is used).
Unfortunately, we need to disconnect from the AP
after resume since we can't yet get all the info
out of the wowlan uCode to stay connected safely.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c       |    6 +
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c      |    3 +
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c     |   21 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c           |  517 +++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-commands.h      |  128 ++++++
 drivers/net/wireless/iwlwifi/iwl-core.c          |    6 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h           |    1 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c       |   15 +
 drivers/net/wireless/iwlwifi/iwl-dev.h           |   12 +-
 drivers/net/wireless/iwlwifi/iwl-power.c         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c |    6 +
 11 files changed, 705 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index e77f913..3bee0f1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -400,6 +400,7 @@ void iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	struct iwl_tx_queue *txq = &priv->txq[txq_id];
 	struct ieee80211_tx_info *info;
 	struct iwlagn_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
+	struct ieee80211_hdr *hdr;
 	struct iwl_tx_info *txb;
 	u32 status = le16_to_cpu(tx_resp->status.status);
 	int tid;
@@ -426,6 +427,11 @@ void iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 		IWLAGN_TX_RES_RA_POS;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
+
+	hdr = (void *)txb->skb->data;
+	if (!ieee80211_is_data_qos(hdr->frame_control))
+		priv->last_seq_ctl = tx_resp->seq_ctl;
+
 	if (txq->sched_retry) {
 		const u32 scd_ssn = iwlagn_get_scd_ssn(tx_resp);
 		struct iwl_ht_agg *agg;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 7148748..d78a465 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -855,6 +855,9 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 				iwl_wake_any_queue(priv, ctx);
 			}
 			ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
+
+			if (ctx->ctxid == IWL_RXON_CTX_BSS)
+				priv->have_rekey_data = false;
 		}
 
 		iwlagn_bt_coex_rssi_monitor(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 946d3a1..a895a09 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -513,14 +513,21 @@ int iwlagn_load_ucode_wait_alive(struct iwl_priv *priv,
 		return -EIO;
 	}
 
-	ret = iwl_verify_ucode(priv, image);
-	if (ret) {
-		priv->ucode_type = old_type;
-		return ret;
-	}
+	/*
+	 * This step takes a long time (60-80ms!!) and
+	 * WoWLAN image should be loaded quickly, so
+	 * skip it for WoWLAN.
+	 */
+	if (ucode_type != IWL_UCODE_WOWLAN) {
+		ret = iwl_verify_ucode(priv, image);
+		if (ret) {
+			priv->ucode_type = old_type;
+			return ret;
+		}
 
-	/* delay a bit to give rfkill time to run */
-	msleep(5);
+		/* delay a bit to give rfkill time to run */
+		msleep(5);
+	}
 
 	ret = iwlagn_alive_notify(priv);
 	if (ret) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 0bab195..299acb4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -593,6 +593,7 @@ static void iwl_dealloc_ucode(struct iwl_priv *priv)
 {
 	iwl_free_fw_img(priv, &priv->ucode_rt);
 	iwl_free_fw_img(priv, &priv->ucode_init);
+	iwl_free_fw_img(priv, &priv->ucode_wowlan);
 }
 
 static int iwl_alloc_fw_desc(struct iwl_priv *priv, struct fw_desc *desc,
@@ -662,8 +663,9 @@ static int __must_check iwl_request_firmware(struct iwl_priv *priv, bool first)
 }
 
 struct iwlagn_firmware_pieces {
-	const void *inst, *data, *init, *init_data;
-	size_t inst_size, data_size, init_size, init_data_size;
+	const void *inst, *data, *init, *init_data, *wowlan_inst, *wowlan_data;
+	size_t inst_size, data_size, init_size, init_data_size,
+	       wowlan_inst_size, wowlan_data_size;
 
 	u32 build;
 
@@ -902,6 +904,14 @@ static int iwlagn_load_firmware(struct iwl_priv *priv,
 				goto invalid_tlv_len;
 			priv->enhance_sensitivity_table = true;
 			break;
+		case IWL_UCODE_TLV_WOWLAN_INST:
+			pieces->wowlan_inst = tlv_data;
+			pieces->wowlan_inst_size = tlv_len;
+			break;
+		case IWL_UCODE_TLV_WOWLAN_DATA:
+			pieces->wowlan_data = tlv_data;
+			pieces->wowlan_data_size = tlv_len;
+			break;
 		case IWL_UCODE_TLV_PHY_CALIBRATION_SIZE:
 			if (tlv_len != sizeof(u32))
 				goto invalid_tlv_len;
@@ -1096,6 +1106,18 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 			goto err_pci_alloc;
 	}
 
+	/* WoWLAN instructions and data */
+	if (pieces.wowlan_inst_size && pieces.wowlan_data_size) {
+		if (iwl_alloc_fw_desc(priv, &priv->ucode_wowlan.code,
+				      pieces.wowlan_inst,
+				      pieces.wowlan_inst_size))
+			goto err_pci_alloc;
+		if (iwl_alloc_fw_desc(priv, &priv->ucode_wowlan.data,
+				      pieces.wowlan_data,
+				      pieces.wowlan_data_size))
+			goto err_pci_alloc;
+	}
+
 	/* Now that we can no longer fail, copy information */
 
 	/*
@@ -1698,7 +1720,7 @@ int iwl_alive_start(struct iwl_priv *priv)
 	/* Configure Tx antenna selection based on H/W config */
 	iwlagn_send_tx_ant_config(priv, priv->cfg->valid_tx_ant);
 
-	if (iwl_is_associated_ctx(ctx)) {
+	if (iwl_is_associated_ctx(ctx) && !priv->wowlan) {
 		struct iwl_rxon_cmd *active_rxon =
 				(struct iwl_rxon_cmd *)&ctx->active;
 		/* apply any changes in staging */
@@ -1713,7 +1735,10 @@ int iwl_alive_start(struct iwl_priv *priv)
 		iwlagn_set_rxon_chain(priv, ctx);
 	}
 
-	iwl_reset_run_time_calib(priv);
+	if (!priv->wowlan) {
+		/* WoWLAN ucode will not reply in the same way, skip it */
+		iwl_reset_run_time_calib(priv);
+	}
 
 	set_bit(STATUS_READY, &priv->status);
 
@@ -2153,6 +2178,23 @@ static int iwl_mac_setup_register(struct iwl_priv *priv,
 			    WIPHY_FLAG_DISABLE_BEACON_HINTS |
 			    WIPHY_FLAG_IBSS_RSN;
 
+	if (priv->ucode_wowlan.code.len && device_can_wakeup(priv->bus->dev)) {
+		hw->wiphy->wowlan.flags = WIPHY_WOWLAN_MAGIC_PKT |
+					  WIPHY_WOWLAN_DISCONNECT |
+					  WIPHY_WOWLAN_EAP_IDENTITY_REQ |
+					  WIPHY_WOWLAN_RFKILL_RELEASE;
+		if (!iwlagn_mod_params.sw_crypto)
+			hw->wiphy->wowlan.flags |=
+				WIPHY_WOWLAN_SUPPORTS_GTK_REKEY |
+				WIPHY_WOWLAN_GTK_REKEY_FAILURE;
+
+		hw->wiphy->wowlan.n_patterns = IWLAGN_WOWLAN_MAX_PATTERNS;
+		hw->wiphy->wowlan.pattern_min_len =
+					IWLAGN_WOWLAN_MIN_PATTERN_LEN;
+		hw->wiphy->wowlan.pattern_max_len =
+					IWLAGN_WOWLAN_MAX_PATTERN_LEN;
+	}
+
 	if (iwlagn_mod_params.power_save)
 		hw->wiphy->flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT;
 	else
@@ -2237,6 +2279,467 @@ static void iwlagn_mac_stop(struct ieee80211_hw *hw)
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 }
 
+static int iwlagn_send_patterns(struct iwl_priv *priv,
+				struct cfg80211_wowlan *wowlan)
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
+			wowlan->n_patterns * sizeof(struct iwlagn_wowlan_pattern);
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
+	err = trans_send_cmd(&priv->trans, &cmd);
+	kfree(pattern_cmd);
+	return err;
+}
+
+static void iwlagn_mac_set_rekey_data(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif,
+				      struct cfg80211_gtk_rekey_data *data)
+{
+	struct iwl_priv *priv = hw->priv;
+
+	if (iwlagn_mod_params.sw_crypto)
+		return;
+
+	mutex_lock(&priv->mutex);
+
+	if (priv->contexts[IWL_RXON_CTX_BSS].vif != vif)
+		goto out;
+
+	memcpy(priv->kek, data->kek, NL80211_KEK_LEN);
+	memcpy(priv->kck, data->kck, NL80211_KCK_LEN);
+	priv->replay_ctr = cpu_to_le64(be64_to_cpup((__be64 *)&data->replay_ctr));
+	priv->have_rekey_data = true;
+
+ out:
+	mutex_unlock(&priv->mutex);
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
+static void iwlagn_convert_p1k(u16 *p1k, __le16 *out)
+{
+	int i;
+
+	for (i = 0; i < IWLAGN_P1K_SIZE; i++)
+		out[i] = cpu_to_le16(p1k[i]);
+}
+
+static void iwlagn_wowlan_program_keys(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif,
+				       struct ieee80211_sta *sta,
+				       struct ieee80211_key_conf *key,
+				       void *_data)
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
+	mutex_lock(&priv->mutex);
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
+			tkip_sc = data->rsc_tsc->all_tsc_rsc.tkip.multicast_rsc;
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
+	mutex_unlock(&priv->mutex);
+}
+
+static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
+			      struct cfg80211_wowlan *wowlan)
+{
+	struct iwl_priv *priv = hw->priv;
+	struct iwlagn_wowlan_wakeup_filter_cmd wakeup_filter_cmd;
+	struct iwl_rxon_cmd rxon;
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
+	struct iwlagn_wowlan_kek_kck_material_cmd kek_kck_cmd;
+	struct iwlagn_wowlan_tkip_params_cmd tkip_cmd = {};
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
+	if (WARN_ON(!wowlan))
+		return -EINVAL;
+
+	mutex_lock(&priv->mutex);
+
+	/* Don't attempt WoWLAN when not associated, tear down instead. */
+	if (!ctx->vif || ctx->vif->type != NL80211_IFTYPE_STATION ||
+	    !iwl_is_associated_ctx(ctx)) {
+		ret = 1;
+		goto out;
+	}
+
+	key_data.rsc_tsc = kzalloc(sizeof(*key_data.rsc_tsc), GFP_KERNEL);
+	if (!key_data.rsc_tsc) {
+		ret = -ENOMEM;
+		goto out;
+	}
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
+		seq = priv->stations[IWL_AP_ID].tid[i].seq_number;
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
+	if (wowlan->rfkill_release)
+		wakeup_filter_cmd.enabled |=
+			cpu_to_le32(IWLAGN_WOWLAN_WAKEUP_RFKILL);
+	if (wowlan->n_patterns)
+		wakeup_filter_cmd.enabled |=
+			cpu_to_le32(IWLAGN_WOWLAN_WAKEUP_PATTERN_MATCH);
+
+	iwl_scan_cancel_timeout(priv, 200);
+
+	memcpy(&rxon, &ctx->active, sizeof(rxon));
+
+	trans_stop_device(&priv->trans);
+
+	priv->wowlan = true;
+
+	ret = iwlagn_load_ucode_wait_alive(priv, &priv->ucode_wowlan,
+					   IWL_UCODE_WOWLAN);
+	if (ret)
+		goto error;
+
+	/* now configure WoWLAN ucode */
+	ret = iwl_alive_start(priv);
+	if (ret)
+		goto error;
+
+	memcpy(&ctx->staging, &rxon, sizeof(rxon));
+	ret = iwlagn_commit_rxon(priv, ctx);
+	if (ret)
+		goto error;
+
+	ret = iwl_power_update_mode(priv, true);
+	if (ret)
+		goto error;
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
+		mutex_unlock(&priv->mutex);
+		ieee80211_iter_keys(priv->hw, ctx->vif,
+				    iwlagn_wowlan_program_keys,
+				    &key_data);
+		mutex_lock(&priv->mutex);
+		if (key_data.error) {
+			ret = -EIO;
+			goto error;
+		}
+
+		if (key_data.use_rsc_tsc) {
+			struct iwl_host_cmd rsc_tsc_cmd = {
+				.id = REPLY_WOWLAN_TSC_RSC_PARAMS,
+				.flags = CMD_SYNC,
+				.data[0] = key_data.rsc_tsc,
+				.dataflags[0] = IWL_HCMD_DFL_NOCOPY,
+				.len[0] = sizeof(*key_data.rsc_tsc),
+			};
+
+			ret = trans_send_cmd(&priv->trans, &rsc_tsc_cmd);
+			if (ret)
+				goto error;
+		}
+
+		if (key_data.use_tkip) {
+			ret = trans_send_cmd_pdu(&priv->trans,
+						 REPLY_WOWLAN_TKIP_PARAMS,
+						 CMD_SYNC, sizeof(tkip_cmd),
+						 &tkip_cmd);
+			if (ret)
+				goto error;
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
+			ret = trans_send_cmd_pdu(&priv->trans,
+						 REPLY_WOWLAN_KEK_KCK_MATERIAL,
+						 CMD_SYNC, sizeof(kek_kck_cmd),
+						 &kek_kck_cmd);
+			if (ret)
+				goto error;
+		}
+	}
+
+	ret = trans_send_cmd_pdu(&priv->trans, REPLY_WOWLAN_WAKEUP_FILTER,
+				 CMD_SYNC, sizeof(wakeup_filter_cmd),
+				 &wakeup_filter_cmd);
+	if (ret)
+		goto error;
+
+	ret = iwlagn_send_patterns(priv, wowlan);
+	if (ret)
+		goto error;
+
+	device_set_wakeup_enable(priv->bus->dev, true);
+
+	/* Now let the ucode operate on its own */
+	iwl_write32(priv, CSR_UCODE_DRV_GP1_SET,
+			  CSR_UCODE_DRV_GP1_BIT_D3_CFG_COMPLETE);
+
+	goto out;
+
+ error:
+	priv->wowlan = false;
+	iwlagn_prepare_restart(priv);
+	ieee80211_restart_hw(priv->hw);
+ out:
+	mutex_unlock(&priv->mutex);
+	kfree(key_data.rsc_tsc);
+	return ret;
+}
+
+static int iwlagn_mac_resume(struct ieee80211_hw *hw)
+{
+	struct iwl_priv *priv = hw->priv;
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
+	struct ieee80211_vif *vif;
+	unsigned long flags;
+	u32 base, status = 0xffffffff;
+	int ret = -EIO;
+
+	mutex_lock(&priv->mutex);
+
+	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR,
+			  CSR_UCODE_DRV_GP1_BIT_D3_CFG_COMPLETE);
+
+	base = priv->device_pointers.error_event_table;
+	if (iwlagn_hw_valid_rtc_data_addr(base)) {
+		spin_lock_irqsave(&priv->reg_lock, flags);
+		ret = iwl_grab_nic_access_silent(priv);
+		if (ret == 0) {
+			iwl_write32(priv, HBUS_TARG_MEM_RADDR, base);
+			status = iwl_read32(priv, HBUS_TARG_MEM_RDAT);
+			iwl_release_nic_access(priv);
+		}
+		spin_unlock_irqrestore(&priv->reg_lock, flags);
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+		if (ret == 0) {
+			if (!priv->wowlan_sram)
+				priv->wowlan_sram =
+					kzalloc(priv->ucode_wowlan.data.len,
+						GFP_KERNEL);
+
+			if (priv->wowlan_sram)
+				_iwl_read_targ_mem_words(
+					priv, 0x800000, priv->wowlan_sram,
+					priv->ucode_wowlan.data.len / 4);
+		}
+#endif
+	}
+
+	/* we'll clear ctx->vif during iwlagn_prepare_restart() */
+	vif = ctx->vif;
+
+	priv->wowlan = false;
+
+	device_set_wakeup_enable(priv->bus->dev, false);
+
+	iwlagn_prepare_restart(priv);
+
+	memset((void *)&ctx->active, 0, sizeof(ctx->active));
+	iwl_connection_init_rx_config(priv, ctx);
+	iwlagn_set_rxon_chain(priv, ctx);
+
+	mutex_unlock(&priv->mutex);
+
+	ieee80211_resume_disconnect(vif);
+
+	return 1;
+}
+
 static void iwlagn_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct iwl_priv *priv = hw->priv;
@@ -2926,6 +3429,9 @@ static void iwl_uninit_drv(struct iwl_priv *priv)
 	iwl_free_channel_map(priv);
 	kfree(priv->scan_cmd);
 	kfree(priv->beacon_cmd);
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	kfree(priv->wowlan_sram);
+#endif
 }
 
 static void iwl_mac_rssi_callback(struct ieee80211_hw *hw,
@@ -2955,6 +3461,8 @@ struct ieee80211_ops iwlagn_hw_ops = {
 	.tx = iwlagn_mac_tx,
 	.start = iwlagn_mac_start,
 	.stop = iwlagn_mac_stop,
+	.suspend = iwlagn_mac_suspend,
+	.resume = iwlagn_mac_resume,
 	.add_interface = iwl_mac_add_interface,
 	.remove_interface = iwl_mac_remove_interface,
 	.change_interface = iwl_mac_change_interface,
@@ -2962,6 +3470,7 @@ struct ieee80211_ops iwlagn_hw_ops = {
 	.configure_filter = iwlagn_configure_filter,
 	.set_key = iwlagn_mac_set_key,
 	.update_tkip_key = iwlagn_mac_update_tkip_key,
+	.set_rekey_data = iwlagn_mac_set_rekey_data,
 	.conf_tx = iwl_mac_conf_tx,
 	.bss_info_changed = iwlagn_bss_info_changed,
 	.ampdu_action = iwlagn_mac_ampdu_action,
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index b589853..5769ca5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -188,6 +188,13 @@ enum {
 	REPLY_WIPAN_NOA_NOTIFICATION = 0xbc,
 	REPLY_WIPAN_DEACTIVATION_COMPLETE = 0xbd,
 
+	REPLY_WOWLAN_PATTERNS = 0xe0,
+	REPLY_WOWLAN_WAKEUP_FILTER = 0xe1,
+	REPLY_WOWLAN_TSC_RSC_PARAMS = 0xe2,
+	REPLY_WOWLAN_TKIP_PARAMS = 0xe3,
+	REPLY_WOWLAN_KEK_KCK_MATERIAL = 0xe4,
+	REPLY_WOWLAN_GET_STATUS = 0xe5,
+
 	REPLY_MAX = 0xff
 };
 
@@ -3764,6 +3771,127 @@ struct iwl_bt_coex_prot_env_cmd {
 	u8 reserved[2];
 } __attribute__((packed));
 
+/*
+ * REPLY_WOWLAN_PATTERNS
+ */
+#define IWLAGN_WOWLAN_MIN_PATTERN_LEN	16
+#define IWLAGN_WOWLAN_MAX_PATTERN_LEN	128
+
+struct iwlagn_wowlan_pattern {
+	u8 mask[IWLAGN_WOWLAN_MAX_PATTERN_LEN / 8];
+	u8 pattern[IWLAGN_WOWLAN_MAX_PATTERN_LEN];
+	u8 mask_size;
+	u8 pattern_size;
+	__le16 reserved;
+} __packed;
+
+#define IWLAGN_WOWLAN_MAX_PATTERNS	20
+
+struct iwlagn_wowlan_patterns_cmd {
+	__le32 n_patterns;
+	struct iwlagn_wowlan_pattern patterns[];
+} __packed;
+
+/*
+ * REPLY_WOWLAN_WAKEUP_FILTER
+ */
+enum iwlagn_wowlan_wakeup_filters {
+	IWLAGN_WOWLAN_WAKEUP_MAGIC_PACKET	= BIT(0),
+	IWLAGN_WOWLAN_WAKEUP_PATTERN_MATCH	= BIT(1),
+	IWLAGN_WOWLAN_WAKEUP_BEACON_MISS	= BIT(2),
+	IWLAGN_WOWLAN_WAKEUP_LINK_CHANGE	= BIT(3),
+	IWLAGN_WOWLAN_WAKEUP_GTK_REKEY_FAIL	= BIT(4),
+	IWLAGN_WOWLAN_WAKEUP_RFKILL		= BIT(5),
+	IWLAGN_WOWLAN_WAKEUP_UCODE_ERROR	= BIT(6),
+	IWLAGN_WOWLAN_WAKEUP_EAP_IDENT_REQ	= BIT(7),
+	IWLAGN_WOWLAN_WAKEUP_4WAY_HANDSHAKE	= BIT(8),
+	IWLAGN_WOWLAN_WAKEUP_ALWAYS		= BIT(9),
+	IWLAGN_WOWLAN_WAKEUP_ENABLE_NET_DETECT	= BIT(10),
+};
+
+struct iwlagn_wowlan_wakeup_filter_cmd {
+	__le32 enabled;
+	__le16 non_qos_seq;
+	u8 min_sleep_seconds;
+	u8 reserved;
+	__le16 qos_seq[8];
+};
+
+/*
+ * REPLY_WOWLAN_TSC_RSC_PARAMS
+ */
+#define IWLAGN_NUM_RSC	16
+
+struct tkip_sc {
+	__le16 iv16;
+	__le16 pad;
+	__le32 iv32;
+} __packed;
+
+struct iwlagn_tkip_rsc_tsc {
+	struct tkip_sc unicast_rsc[IWLAGN_NUM_RSC];
+	struct tkip_sc multicast_rsc[IWLAGN_NUM_RSC];
+	struct tkip_sc tsc;
+} __packed;
+
+struct aes_sc {
+	__le64 pn;
+} __packed;
+
+struct iwlagn_aes_rsc_tsc {
+	struct aes_sc unicast_rsc[IWLAGN_NUM_RSC];
+	struct aes_sc multicast_rsc[IWLAGN_NUM_RSC];
+	struct aes_sc tsc;
+} __packed;
+
+union iwlagn_all_tsc_rsc {
+	struct iwlagn_tkip_rsc_tsc tkip;
+	struct iwlagn_aes_rsc_tsc aes;
+};
+
+struct iwlagn_wowlan_rsc_tsc_params_cmd {
+	union iwlagn_all_tsc_rsc all_tsc_rsc;
+} __packed;
+
+/*
+ * REPLY_WOWLAN_TKIP_PARAMS
+ */
+#define IWLAGN_MIC_KEY_SIZE	8
+#define IWLAGN_P1K_SIZE		5
+struct iwlagn_mic_keys {
+	u8 tx[IWLAGN_MIC_KEY_SIZE];
+	u8 rx_unicast[IWLAGN_MIC_KEY_SIZE];
+	u8 rx_mcast[IWLAGN_MIC_KEY_SIZE];
+} __packed;
+
+struct iwlagn_p1k_cache {
+	__le16 p1k[IWLAGN_P1K_SIZE];
+} __packed;
+
+#define IWLAGN_NUM_RX_P1K_CACHE	2
+
+struct iwlagn_wowlan_tkip_params_cmd {
+	struct iwlagn_mic_keys mic_keys;
+	struct iwlagn_p1k_cache tx;
+	struct iwlagn_p1k_cache rx_uni[IWLAGN_NUM_RX_P1K_CACHE];
+	struct iwlagn_p1k_cache rx_multi[IWLAGN_NUM_RX_P1K_CACHE];
+} __packed;
+
+/*
+ * REPLY_WOWLAN_KEK_KCK_MATERIAL
+ */
+
+#define IWLAGN_KCK_MAX_SIZE	32
+#define IWLAGN_KEK_MAX_SIZE	32
+
+struct iwlagn_wowlan_kek_kck_material_cmd {
+	u8	kck[IWLAGN_KCK_MAX_SIZE];
+	u8	kek[IWLAGN_KEK_MAX_SIZE];
+	__le16	kck_len;
+	__le16	kek_len;
+	__le64	replay_ctr;
+} __packed;
+
 /******************************************************************************
  * (13)
  * Union of all expected notifications/responses:
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 9b9f462..2f42547 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1903,8 +1903,12 @@ int iwl_suspend(struct iwl_priv *priv)
 	 * first but since iwl_mac_stop() has no knowledge of who the caller is,
 	 * it will not call apm_ops.stop() to stop the DMA operation.
 	 * Calling apm_ops.stop here to make sure we stop the DMA.
+	 *
+	 * But of course ... if we have configured WoWLAN then we did other
+	 * things already :-)
 	 */
-	iwl_apm_stop(priv);
+	if (!priv->wowlan)
+		iwl_apm_stop(priv);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 5ab90ba..d6dbb04 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -351,6 +351,7 @@
 #define CSR_UCODE_SW_BIT_RFKILL                     (0x00000002)
 #define CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED           (0x00000004)
 #define CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT      (0x00000008)
+#define CSR_UCODE_DRV_GP1_BIT_D3_CFG_COMPLETE       (0x00000020)
 
 /* GP Driver */
 #define CSR_GP_DRIVER_REG_BIT_RADIO_SKU_MSK	    (0x00000003)
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 17aebf0..ec1485b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -322,6 +322,19 @@ static ssize_t iwl_dbgfs_sram_write(struct file *file,
 	return count;
 }
 
+static ssize_t iwl_dbgfs_wowlan_sram_read(struct file *file,
+					  char __user *user_buf,
+					  size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = file->private_data;
+
+	if (!priv->wowlan_sram)
+		return -ENODATA;
+
+	return simple_read_from_buffer(user_buf, count, ppos,
+				       priv->wowlan_sram,
+				       priv->ucode_wowlan.data.len);
+}
 static ssize_t iwl_dbgfs_stations_read(struct file *file, char __user *user_buf,
 					size_t count, loff_t *ppos)
 {
@@ -856,6 +869,7 @@ static ssize_t iwl_dbgfs_current_sleep_command_read(struct file *file,
 }
 
 DEBUGFS_READ_WRITE_FILE_OPS(sram);
+DEBUGFS_READ_FILE_OPS(wowlan_sram);
 DEBUGFS_READ_WRITE_FILE_OPS(log_event);
 DEBUGFS_READ_FILE_OPS(nvm);
 DEBUGFS_READ_FILE_OPS(stations);
@@ -2667,6 +2681,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 
 	DEBUGFS_ADD_FILE(nvm, dir_data, S_IRUSR);
 	DEBUGFS_ADD_FILE(sram, dir_data, S_IWUSR | S_IRUSR);
+	DEBUGFS_ADD_FILE(wowlan_sram, dir_data, S_IRUSR);
 	DEBUGFS_ADD_FILE(log_event, dir_data, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(stations, dir_data, S_IRUSR);
 	DEBUGFS_ADD_FILE(channels, dir_data, S_IRUSR);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index c273804..fc23873 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -551,7 +551,8 @@ enum iwl_ucode_tlv_type {
 	IWL_UCODE_TLV_INIT_ERRLOG_PTR	= 13,
 	IWL_UCODE_TLV_ENHANCE_SENS_TBL	= 14,
 	IWL_UCODE_TLV_PHY_CALIBRATION_SIZE = 15,
-	/* 16 and 17 reserved for future use */
+	IWL_UCODE_TLV_WOWLAN_INST	= 16,
+	IWL_UCODE_TLV_WOWLAN_DATA	= 17,
 	IWL_UCODE_TLV_FLAGS		= 18,
 };
 
@@ -1284,6 +1285,7 @@ struct iwl_priv {
 
 	struct fw_img ucode_rt;
 	struct fw_img ucode_init;
+	struct fw_img ucode_wowlan;
 
 	enum iwlagn_ucode_type ucode_type;
 	u8 ucode_write_complete;	/* the image write is complete */
@@ -1356,6 +1358,8 @@ struct iwl_priv {
 
 	u8 mac80211_registered;
 
+	bool wowlan;
+
 	/* eeprom -- this is in the card's little endian byte order */
 	u8 *eeprom;
 	int    nvm_device_type;
@@ -1508,6 +1512,7 @@ struct iwl_priv {
 	struct dentry *debugfs_dir;
 	u32 dbgfs_sram_offset, dbgfs_sram_len;
 	bool disable_ht40;
+	void *wowlan_sram;
 #endif /* CONFIG_IWLWIFI_DEBUGFS */
 
 	struct work_struct txpower_work;
@@ -1528,6 +1533,11 @@ struct iwl_priv {
 	u32 tm_fixed_rate;
 #endif
 
+	/* WoWLAN GTK rekey data */
+	u8 kck[NL80211_KCK_LEN], kek[NL80211_KEK_LEN];
+	__le64 replay_ctr;
+	__le16 last_seq_ctl;
+	bool have_rekey_data;
 }; /*iwl_priv */
 
 static inline void iwl_txq_ctx_activate(struct iwl_priv *priv, int txq_id)
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index de4f333..3ec619c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -347,7 +347,9 @@ static void iwl_power_build_cmd(struct iwl_priv *priv,
 
 	dtimper = priv->hw->conf.ps_dtim_period ?: 1;
 
-	if (priv->hw->conf.flags & IEEE80211_CONF_IDLE)
+	if (priv->wowlan)
+		iwl_static_sleep_cmd(priv, cmd, IWL_POWER_INDEX_5, dtimper);
+	else if (priv->hw->conf.flags & IEEE80211_CONF_IDLE)
 		iwl_static_sleep_cmd(priv, cmd, IWL_POWER_INDEX_5, 20);
 	else if (iwl_tt_is_low_power_state(priv)) {
 		/* in thermal throttling low power state */
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
index 27f78fe..a6b2b1d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@ -866,6 +866,12 @@ const char *get_cmd_string(u8 cmd)
 		IWL_CMD(REPLY_WIPAN_P2P_CHANNEL_SWITCH);
 		IWL_CMD(REPLY_WIPAN_NOA_NOTIFICATION);
 		IWL_CMD(REPLY_WIPAN_DEACTIVATION_COMPLETE);
+		IWL_CMD(REPLY_WOWLAN_PATTERNS);
+		IWL_CMD(REPLY_WOWLAN_WAKEUP_FILTER);
+		IWL_CMD(REPLY_WOWLAN_TSC_RSC_PARAMS);
+		IWL_CMD(REPLY_WOWLAN_TKIP_PARAMS);
+		IWL_CMD(REPLY_WOWLAN_KEK_KCK_MATERIAL);
+		IWL_CMD(REPLY_WOWLAN_GET_STATUS);
 	default:
 		return "UNKNOWN";
 
-- 
1.7.0.4

