Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:1940 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551Ab1ITXXa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 19:23:30 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.guy@intel.com>
Subject: [PATCH 1/8] iwlagn: move scan code to scan file
Date: Tue, 20 Sep 2011 15:37:20 -0700
Message-Id: <1316558247-10018-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110921_012348_392209_A3CF1D14)
In-Reply-To: <1316558247-10018-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316558247-10018-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since the driver split there's no longer a need
to have the scan code scattered across multiple
files, so move it all back to iwl-scan.c

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |  427 ---------------------------
 drivers/net/wireless/iwlwifi/iwl-agn.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-core.h    |    6 -
 drivers/net/wireless/iwlwifi/iwl-scan.c    |  439 +++++++++++++++++++++++++++-
 4 files changed, 433 insertions(+), 440 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index e8b324c..0a1f331 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -190,433 +190,6 @@ int iwlagn_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band)
 	return -1;
 }
 
-static int iwl_get_single_channel_for_scan(struct iwl_priv *priv,
-					   struct ieee80211_vif *vif,
-					   enum ieee80211_band band,
-					   struct iwl_scan_channel *scan_ch)
-{
-	const struct ieee80211_supported_band *sband;
-	u16 passive_dwell = 0;
-	u16 active_dwell = 0;
-	int added = 0;
-	u16 channel = 0;
-
-	sband = iwl_get_hw_mode(priv, band);
-	if (!sband) {
-		IWL_ERR(priv, "invalid band\n");
-		return added;
-	}
-
-	active_dwell = iwl_get_active_dwell_time(priv, band, 0);
-	passive_dwell = iwl_get_passive_dwell_time(priv, band, vif);
-
-	if (passive_dwell <= active_dwell)
-		passive_dwell = active_dwell + 1;
-
-	channel = iwl_get_single_channel_number(priv, band);
-	if (channel) {
-		scan_ch->channel = cpu_to_le16(channel);
-		scan_ch->type = SCAN_CHANNEL_TYPE_PASSIVE;
-		scan_ch->active_dwell = cpu_to_le16(active_dwell);
-		scan_ch->passive_dwell = cpu_to_le16(passive_dwell);
-		/* Set txpower levels to defaults */
-		scan_ch->dsp_atten = 110;
-		if (band == IEEE80211_BAND_5GHZ)
-			scan_ch->tx_gain = ((1 << 5) | (3 << 3)) | 3;
-		else
-			scan_ch->tx_gain = ((1 << 5) | (5 << 3));
-		added++;
-	} else
-		IWL_ERR(priv, "no valid channel found\n");
-	return added;
-}
-
-static int iwl_get_channels_for_scan(struct iwl_priv *priv,
-				     struct ieee80211_vif *vif,
-				     enum ieee80211_band band,
-				     u8 is_active, u8 n_probes,
-				     struct iwl_scan_channel *scan_ch)
-{
-	struct ieee80211_channel *chan;
-	const struct ieee80211_supported_band *sband;
-	const struct iwl_channel_info *ch_info;
-	u16 passive_dwell = 0;
-	u16 active_dwell = 0;
-	int added, i;
-	u16 channel;
-
-	sband = iwl_get_hw_mode(priv, band);
-	if (!sband)
-		return 0;
-
-	active_dwell = iwl_get_active_dwell_time(priv, band, n_probes);
-	passive_dwell = iwl_get_passive_dwell_time(priv, band, vif);
-
-	if (passive_dwell <= active_dwell)
-		passive_dwell = active_dwell + 1;
-
-	for (i = 0, added = 0; i < priv->scan_request->n_channels; i++) {
-		chan = priv->scan_request->channels[i];
-
-		if (chan->band != band)
-			continue;
-
-		channel = chan->hw_value;
-		scan_ch->channel = cpu_to_le16(channel);
-
-		ch_info = iwl_get_channel_info(priv, band, channel);
-		if (!is_channel_valid(ch_info)) {
-			IWL_DEBUG_SCAN(priv, "Channel %d is INVALID for this band.\n",
-					channel);
-			continue;
-		}
-
-		if (!is_active || is_channel_passive(ch_info) ||
-		    (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN))
-			scan_ch->type = SCAN_CHANNEL_TYPE_PASSIVE;
-		else
-			scan_ch->type = SCAN_CHANNEL_TYPE_ACTIVE;
-
-		if (n_probes)
-			scan_ch->type |= IWL_SCAN_PROBE_MASK(n_probes);
-
-		scan_ch->active_dwell = cpu_to_le16(active_dwell);
-		scan_ch->passive_dwell = cpu_to_le16(passive_dwell);
-
-		/* Set txpower levels to defaults */
-		scan_ch->dsp_atten = 110;
-
-		/* NOTE: if we were doing 6Mb OFDM for scans we'd use
-		 * power level:
-		 * scan_ch->tx_gain = ((1 << 5) | (2 << 3)) | 3;
-		 */
-		if (band == IEEE80211_BAND_5GHZ)
-			scan_ch->tx_gain = ((1 << 5) | (3 << 3)) | 3;
-		else
-			scan_ch->tx_gain = ((1 << 5) | (5 << 3));
-
-		IWL_DEBUG_SCAN(priv, "Scanning ch=%d prob=0x%X [%s %d]\n",
-			       channel, le32_to_cpu(scan_ch->type),
-			       (scan_ch->type & SCAN_CHANNEL_TYPE_ACTIVE) ?
-				"ACTIVE" : "PASSIVE",
-			       (scan_ch->type & SCAN_CHANNEL_TYPE_ACTIVE) ?
-			       active_dwell : passive_dwell);
-
-		scan_ch++;
-		added++;
-	}
-
-	IWL_DEBUG_SCAN(priv, "total channels to scan %d\n", added);
-	return added;
-}
-
-int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
-{
-	struct iwl_host_cmd cmd = {
-		.id = REPLY_SCAN_CMD,
-		.len = { sizeof(struct iwl_scan_cmd), },
-		.flags = CMD_SYNC,
-	};
-	struct iwl_scan_cmd *scan;
-	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
-	u32 rate_flags = 0;
-	u16 cmd_len;
-	u16 rx_chain = 0;
-	enum ieee80211_band band;
-	u8 n_probes = 0;
-	u8 rx_ant = hw_params(priv).valid_rx_ant;
-	u8 rate;
-	bool is_active = false;
-	int  chan_mod;
-	u8 active_chains;
-	u8 scan_tx_antennas = hw_params(priv).valid_tx_ant;
-	int ret;
-
-	lockdep_assert_held(&priv->shrd->mutex);
-
-	if (vif)
-		ctx = iwl_rxon_ctx_from_vif(vif);
-
-	if (!priv->scan_cmd) {
-		priv->scan_cmd = kmalloc(sizeof(struct iwl_scan_cmd) +
-					 IWL_MAX_SCAN_SIZE, GFP_KERNEL);
-		if (!priv->scan_cmd) {
-			IWL_DEBUG_SCAN(priv,
-				       "fail to allocate memory for scan\n");
-			return -ENOMEM;
-		}
-	}
-	scan = priv->scan_cmd;
-	memset(scan, 0, sizeof(struct iwl_scan_cmd) + IWL_MAX_SCAN_SIZE);
-
-	scan->quiet_plcp_th = IWL_PLCP_QUIET_THRESH;
-	scan->quiet_time = IWL_ACTIVE_QUIET_TIME;
-
-	if (priv->scan_type != IWL_SCAN_ROC &&
-	    iwl_is_any_associated(priv)) {
-		u16 interval = 0;
-		u32 extra;
-		u32 suspend_time = 100;
-		u32 scan_suspend_time = 100;
-
-		IWL_DEBUG_INFO(priv, "Scanning while associated...\n");
-		switch (priv->scan_type) {
-		case IWL_SCAN_ROC:
-			WARN_ON(1);
-			break;
-		case IWL_SCAN_RADIO_RESET:
-			interval = 0;
-			break;
-		case IWL_SCAN_NORMAL:
-			interval = vif->bss_conf.beacon_int;
-			break;
-		}
-
-		scan->suspend_time = 0;
-		scan->max_out_time = cpu_to_le32(200 * 1024);
-		if (!interval)
-			interval = suspend_time;
-
-		extra = (suspend_time / interval) << 22;
-		scan_suspend_time = (extra |
-		    ((suspend_time % interval) * 1024));
-		scan->suspend_time = cpu_to_le32(scan_suspend_time);
-		IWL_DEBUG_SCAN(priv, "suspend_time 0x%X beacon interval %d\n",
-			       scan_suspend_time, interval);
-	} else if (priv->scan_type == IWL_SCAN_ROC) {
-		scan->suspend_time = 0;
-		scan->max_out_time = 0;
-		scan->quiet_time = 0;
-		scan->quiet_plcp_th = 0;
-	}
-
-	switch (priv->scan_type) {
-	case IWL_SCAN_RADIO_RESET:
-		IWL_DEBUG_SCAN(priv, "Start internal passive scan.\n");
-		break;
-	case IWL_SCAN_NORMAL:
-		if (priv->scan_request->n_ssids) {
-			int i, p = 0;
-			IWL_DEBUG_SCAN(priv, "Kicking off active scan\n");
-			for (i = 0; i < priv->scan_request->n_ssids; i++) {
-				/* always does wildcard anyway */
-				if (!priv->scan_request->ssids[i].ssid_len)
-					continue;
-				scan->direct_scan[p].id = WLAN_EID_SSID;
-				scan->direct_scan[p].len =
-					priv->scan_request->ssids[i].ssid_len;
-				memcpy(scan->direct_scan[p].ssid,
-				       priv->scan_request->ssids[i].ssid,
-				       priv->scan_request->ssids[i].ssid_len);
-				n_probes++;
-				p++;
-			}
-			is_active = true;
-		} else
-			IWL_DEBUG_SCAN(priv, "Start passive scan.\n");
-		break;
-	case IWL_SCAN_ROC:
-		IWL_DEBUG_SCAN(priv, "Start ROC scan.\n");
-		break;
-	}
-
-	scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
-	scan->tx_cmd.sta_id = ctx->bcast_sta_id;
-	scan->tx_cmd.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
-
-	switch (priv->scan_band) {
-	case IEEE80211_BAND_2GHZ:
-		scan->flags = RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK;
-		chan_mod = le32_to_cpu(
-			priv->contexts[IWL_RXON_CTX_BSS].active.flags &
-						RXON_FLG_CHANNEL_MODE_MSK)
-				       >> RXON_FLG_CHANNEL_MODE_POS;
-		if (chan_mod == CHANNEL_MODE_PURE_40) {
-			rate = IWL_RATE_6M_PLCP;
-		} else {
-			rate = IWL_RATE_1M_PLCP;
-			rate_flags = RATE_MCS_CCK_MSK;
-		}
-		/*
-		 * Internal scans are passive, so we can indiscriminately set
-		 * the BT ignore flag on 2.4 GHz since it applies to TX only.
-		 */
-		if (priv->cfg->bt_params &&
-		    priv->cfg->bt_params->advanced_bt_coexist)
-			scan->tx_cmd.tx_flags |= TX_CMD_FLG_IGNORE_BT;
-		break;
-	case IEEE80211_BAND_5GHZ:
-		rate = IWL_RATE_6M_PLCP;
-		break;
-	default:
-		IWL_WARN(priv, "Invalid scan band\n");
-		return -EIO;
-	}
-
-	/*
-	 * If active scanning is requested but a certain channel is
-	 * marked passive, we can do active scanning if we detect
-	 * transmissions.
-	 *
-	 * There is an issue with some firmware versions that triggers
-	 * a sysassert on a "good CRC threshold" of zero (== disabled),
-	 * on a radar channel even though this means that we should NOT
-	 * send probes.
-	 *
-	 * The "good CRC threshold" is the number of frames that we
-	 * need to receive during our dwell time on a channel before
-	 * sending out probes -- setting this to a huge value will
-	 * mean we never reach it, but at the same time work around
-	 * the aforementioned issue. Thus use IWL_GOOD_CRC_TH_NEVER
-	 * here instead of IWL_GOOD_CRC_TH_DISABLED.
-	 *
-	 * This was fixed in later versions along with some other
-	 * scan changes, and the threshold behaves as a flag in those
-	 * versions.
-	 */
-	if (priv->new_scan_threshold_behaviour)
-		scan->good_CRC_th = is_active ? IWL_GOOD_CRC_TH_DEFAULT :
-						IWL_GOOD_CRC_TH_DISABLED;
-	else
-		scan->good_CRC_th = is_active ? IWL_GOOD_CRC_TH_DEFAULT :
-						IWL_GOOD_CRC_TH_NEVER;
-
-	band = priv->scan_band;
-
-	if (priv->cfg->scan_rx_antennas[band])
-		rx_ant = priv->cfg->scan_rx_antennas[band];
-
-	if (band == IEEE80211_BAND_2GHZ &&
-	    priv->cfg->bt_params &&
-	    priv->cfg->bt_params->advanced_bt_coexist) {
-		/* transmit 2.4 GHz probes only on first antenna */
-		scan_tx_antennas = first_antenna(scan_tx_antennas);
-	}
-
-	priv->scan_tx_ant[band] = iwl_toggle_tx_ant(priv, priv->scan_tx_ant[band],
-						    scan_tx_antennas);
-	rate_flags |= iwl_ant_idx_to_flags(priv->scan_tx_ant[band]);
-	scan->tx_cmd.rate_n_flags = iwl_hw_set_rate_n_flags(rate, rate_flags);
-
-	/* In power save mode use one chain, otherwise use all chains */
-	if (test_bit(STATUS_POWER_PMI, &priv->shrd->status)) {
-		/* rx_ant has been set to all valid chains previously */
-		active_chains = rx_ant &
-				((u8)(priv->chain_noise_data.active_chains));
-		if (!active_chains)
-			active_chains = rx_ant;
-
-		IWL_DEBUG_SCAN(priv, "chain_noise_data.active_chains: %u\n",
-				priv->chain_noise_data.active_chains);
-
-		rx_ant = first_antenna(active_chains);
-	}
-	if (priv->cfg->bt_params &&
-	    priv->cfg->bt_params->advanced_bt_coexist &&
-	    priv->bt_full_concurrent) {
-		/* operated as 1x1 in full concurrency mode */
-		rx_ant = first_antenna(rx_ant);
-	}
-
-	/* MIMO is not used here, but value is required */
-	rx_chain |=
-		hw_params(priv).valid_rx_ant << RXON_RX_CHAIN_VALID_POS;
-	rx_chain |= rx_ant << RXON_RX_CHAIN_FORCE_MIMO_SEL_POS;
-	rx_chain |= rx_ant << RXON_RX_CHAIN_FORCE_SEL_POS;
-	rx_chain |= 0x1 << RXON_RX_CHAIN_DRIVER_FORCE_POS;
-	scan->rx_chain = cpu_to_le16(rx_chain);
-	switch (priv->scan_type) {
-	case IWL_SCAN_NORMAL:
-		cmd_len = iwl_fill_probe_req(priv,
-					(struct ieee80211_mgmt *)scan->data,
-					vif->addr,
-					priv->scan_request->ie,
-					priv->scan_request->ie_len,
-					IWL_MAX_SCAN_SIZE - sizeof(*scan));
-		break;
-	case IWL_SCAN_RADIO_RESET:
-	case IWL_SCAN_ROC:
-		/* use bcast addr, will not be transmitted but must be valid */
-		cmd_len = iwl_fill_probe_req(priv,
-					(struct ieee80211_mgmt *)scan->data,
-					iwl_bcast_addr, NULL, 0,
-					IWL_MAX_SCAN_SIZE - sizeof(*scan));
-		break;
-	default:
-		BUG();
-	}
-	scan->tx_cmd.len = cpu_to_le16(cmd_len);
-
-	scan->filter_flags |= (RXON_FILTER_ACCEPT_GRP_MSK |
-			       RXON_FILTER_BCON_AWARE_MSK);
-
-	switch (priv->scan_type) {
-	case IWL_SCAN_RADIO_RESET:
-		scan->channel_count =
-			iwl_get_single_channel_for_scan(priv, vif, band,
-				(void *)&scan->data[cmd_len]);
-		break;
-	case IWL_SCAN_NORMAL:
-		scan->channel_count =
-			iwl_get_channels_for_scan(priv, vif, band,
-				is_active, n_probes,
-				(void *)&scan->data[cmd_len]);
-		break;
-	case IWL_SCAN_ROC: {
-		struct iwl_scan_channel *scan_ch;
-
-		scan->channel_count = 1;
-
-		scan_ch = (void *)&scan->data[cmd_len];
-		scan_ch->type = SCAN_CHANNEL_TYPE_PASSIVE;
-		scan_ch->channel =
-			cpu_to_le16(priv->hw_roc_channel->hw_value);
-		scan_ch->active_dwell =
-		scan_ch->passive_dwell =
-			cpu_to_le16(priv->hw_roc_duration);
-
-		/* Set txpower levels to defaults */
-		scan_ch->dsp_atten = 110;
-
-		/* NOTE: if we were doing 6Mb OFDM for scans we'd use
-		 * power level:
-		 * scan_ch->tx_gain = ((1 << 5) | (2 << 3)) | 3;
-		 */
-		if (priv->hw_roc_channel->band == IEEE80211_BAND_5GHZ)
-			scan_ch->tx_gain = ((1 << 5) | (3 << 3)) | 3;
-		else
-			scan_ch->tx_gain = ((1 << 5) | (5 << 3));
-		}
-		break;
-	}
-
-	if (scan->channel_count == 0) {
-		IWL_DEBUG_SCAN(priv, "channel count %d\n", scan->channel_count);
-		return -EIO;
-	}
-
-	cmd.len[0] += le16_to_cpu(scan->tx_cmd.len) +
-	    scan->channel_count * sizeof(struct iwl_scan_channel);
-	cmd.data[0] = scan;
-	cmd.dataflags[0] = IWL_HCMD_DFL_NOCOPY;
-	scan->len = cpu_to_le16(cmd.len[0]);
-
-	/* set scan bit here for PAN params */
-	set_bit(STATUS_SCAN_HW, &priv->shrd->status);
-
-	ret = iwlagn_set_pan_params(priv);
-	if (ret)
-		return ret;
-
-	ret = iwl_trans_send_cmd(trans(priv), &cmd);
-	if (ret) {
-		clear_bit(STATUS_SCAN_HW, &priv->shrd->status);
-		iwlagn_set_pan_params(priv);
-	}
-
-	return ret;
-}
-
 int iwlagn_manage_ibss_station(struct iwl_priv *priv,
 			       struct ieee80211_vif *vif, bool add)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 4bc1f46..5c4f8c7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -146,7 +146,6 @@ static inline bool iwl_is_tx_success(u32 status)
 u8 iwl_toggle_tx_ant(struct iwl_priv *priv, u8 ant_idx, u8 valid);
 
 /* scan */
-int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif);
 void iwlagn_post_scan(struct iwl_priv *priv);
 void iwlagn_disable_roc(struct iwl_priv *priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 6d7ad45..74d4cff 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -330,12 +330,6 @@ int iwl_force_reset(struct iwl_priv *priv, int mode, bool external);
 u16 iwl_fill_probe_req(struct iwl_priv *priv, struct ieee80211_mgmt *frame,
 		       const u8 *ta, const u8 *ie, int ie_len, int left);
 void iwl_setup_rx_scan_handlers(struct iwl_priv *priv);
-u16 iwl_get_active_dwell_time(struct iwl_priv *priv,
-			      enum ieee80211_band band,
-			      u8 n_probes);
-u16 iwl_get_passive_dwell_time(struct iwl_priv *priv,
-			       enum ieee80211_band band,
-			       struct ieee80211_vif *vif);
 void iwl_setup_scan_deferred_work(struct iwl_priv *priv);
 void iwl_cancel_scan_deferred_work(struct iwl_priv *priv);
 int __must_check iwl_scan_initiate(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index fc5af34..8ac6b05 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -299,9 +299,8 @@ void iwl_setup_rx_scan_handlers(struct iwl_priv *priv)
 					iwl_rx_scan_complete_notif;
 }
 
-inline u16 iwl_get_active_dwell_time(struct iwl_priv *priv,
-				     enum ieee80211_band band,
-				     u8 n_probes)
+static u16 iwl_get_active_dwell_time(struct iwl_priv *priv,
+				     enum ieee80211_band band, u8 n_probes)
 {
 	if (band == IEEE80211_BAND_5GHZ)
 		return IWL_ACTIVE_DWELL_TIME_52 +
@@ -311,9 +310,8 @@ inline u16 iwl_get_active_dwell_time(struct iwl_priv *priv,
 			IWL_ACTIVE_DWELL_FACTOR_24GHZ * (n_probes + 1);
 }
 
-u16 iwl_get_passive_dwell_time(struct iwl_priv *priv,
-			       enum ieee80211_band band,
-			       struct ieee80211_vif *vif)
+static u16 iwl_get_passive_dwell_time(struct iwl_priv *priv,
+				      enum ieee80211_band band)
 {
 	struct iwl_rxon_context *ctx;
 	u16 passive = (band == IEEE80211_BAND_2GHZ) ?
@@ -342,6 +340,435 @@ u16 iwl_get_passive_dwell_time(struct iwl_priv *priv,
 	return passive;
 }
 
+static int iwl_get_single_channel_for_scan(struct iwl_priv *priv,
+					   struct ieee80211_vif *vif,
+					   enum ieee80211_band band,
+					   struct iwl_scan_channel *scan_ch)
+{
+	const struct ieee80211_supported_band *sband;
+	u16 passive_dwell = 0;
+	u16 active_dwell = 0;
+	int added = 0;
+	u16 channel = 0;
+
+	sband = iwl_get_hw_mode(priv, band);
+	if (!sband) {
+		IWL_ERR(priv, "invalid band\n");
+		return added;
+	}
+
+	active_dwell = iwl_get_active_dwell_time(priv, band, 0);
+	passive_dwell = iwl_get_passive_dwell_time(priv, band);
+
+	if (passive_dwell <= active_dwell)
+		passive_dwell = active_dwell + 1;
+
+	channel = iwl_get_single_channel_number(priv, band);
+	if (channel) {
+		scan_ch->channel = cpu_to_le16(channel);
+		scan_ch->type = SCAN_CHANNEL_TYPE_PASSIVE;
+		scan_ch->active_dwell = cpu_to_le16(active_dwell);
+		scan_ch->passive_dwell = cpu_to_le16(passive_dwell);
+		/* Set txpower levels to defaults */
+		scan_ch->dsp_atten = 110;
+		if (band == IEEE80211_BAND_5GHZ)
+			scan_ch->tx_gain = ((1 << 5) | (3 << 3)) | 3;
+		else
+			scan_ch->tx_gain = ((1 << 5) | (5 << 3));
+		added++;
+	} else
+		IWL_ERR(priv, "no valid channel found\n");
+	return added;
+}
+
+static int iwl_get_channels_for_scan(struct iwl_priv *priv,
+				     struct ieee80211_vif *vif,
+				     enum ieee80211_band band,
+				     u8 is_active, u8 n_probes,
+				     struct iwl_scan_channel *scan_ch)
+{
+	struct ieee80211_channel *chan;
+	const struct ieee80211_supported_band *sband;
+	const struct iwl_channel_info *ch_info;
+	u16 passive_dwell = 0;
+	u16 active_dwell = 0;
+	int added, i;
+	u16 channel;
+
+	sband = iwl_get_hw_mode(priv, band);
+	if (!sband)
+		return 0;
+
+	active_dwell = iwl_get_active_dwell_time(priv, band, n_probes);
+	passive_dwell = iwl_get_passive_dwell_time(priv, band);
+
+	if (passive_dwell <= active_dwell)
+		passive_dwell = active_dwell + 1;
+
+	for (i = 0, added = 0; i < priv->scan_request->n_channels; i++) {
+		chan = priv->scan_request->channels[i];
+
+		if (chan->band != band)
+			continue;
+
+		channel = chan->hw_value;
+		scan_ch->channel = cpu_to_le16(channel);
+
+		ch_info = iwl_get_channel_info(priv, band, channel);
+		if (!is_channel_valid(ch_info)) {
+			IWL_DEBUG_SCAN(priv,
+				       "Channel %d is INVALID for this band.\n",
+				       channel);
+			continue;
+		}
+
+		if (!is_active || is_channel_passive(ch_info) ||
+		    (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN))
+			scan_ch->type = SCAN_CHANNEL_TYPE_PASSIVE;
+		else
+			scan_ch->type = SCAN_CHANNEL_TYPE_ACTIVE;
+
+		if (n_probes)
+			scan_ch->type |= IWL_SCAN_PROBE_MASK(n_probes);
+
+		scan_ch->active_dwell = cpu_to_le16(active_dwell);
+		scan_ch->passive_dwell = cpu_to_le16(passive_dwell);
+
+		/* Set txpower levels to defaults */
+		scan_ch->dsp_atten = 110;
+
+		/* NOTE: if we were doing 6Mb OFDM for scans we'd use
+		 * power level:
+		 * scan_ch->tx_gain = ((1 << 5) | (2 << 3)) | 3;
+		 */
+		if (band == IEEE80211_BAND_5GHZ)
+			scan_ch->tx_gain = ((1 << 5) | (3 << 3)) | 3;
+		else
+			scan_ch->tx_gain = ((1 << 5) | (5 << 3));
+
+		IWL_DEBUG_SCAN(priv, "Scanning ch=%d prob=0x%X [%s %d]\n",
+			       channel, le32_to_cpu(scan_ch->type),
+			       (scan_ch->type & SCAN_CHANNEL_TYPE_ACTIVE) ?
+				"ACTIVE" : "PASSIVE",
+			       (scan_ch->type & SCAN_CHANNEL_TYPE_ACTIVE) ?
+			       active_dwell : passive_dwell);
+
+		scan_ch++;
+		added++;
+	}
+
+	IWL_DEBUG_SCAN(priv, "total channels to scan %d\n", added);
+	return added;
+}
+
+static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
+{
+	struct iwl_host_cmd cmd = {
+		.id = REPLY_SCAN_CMD,
+		.len = { sizeof(struct iwl_scan_cmd), },
+		.flags = CMD_SYNC,
+	};
+	struct iwl_scan_cmd *scan;
+	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
+	u32 rate_flags = 0;
+	u16 cmd_len;
+	u16 rx_chain = 0;
+	enum ieee80211_band band;
+	u8 n_probes = 0;
+	u8 rx_ant = hw_params(priv).valid_rx_ant;
+	u8 rate;
+	bool is_active = false;
+	int  chan_mod;
+	u8 active_chains;
+	u8 scan_tx_antennas = hw_params(priv).valid_tx_ant;
+	int ret;
+
+	lockdep_assert_held(&priv->shrd->mutex);
+
+	if (vif)
+		ctx = iwl_rxon_ctx_from_vif(vif);
+
+	if (!priv->scan_cmd) {
+		priv->scan_cmd = kmalloc(sizeof(struct iwl_scan_cmd) +
+					 IWL_MAX_SCAN_SIZE, GFP_KERNEL);
+		if (!priv->scan_cmd) {
+			IWL_DEBUG_SCAN(priv,
+				       "fail to allocate memory for scan\n");
+			return -ENOMEM;
+		}
+	}
+	scan = priv->scan_cmd;
+	memset(scan, 0, sizeof(struct iwl_scan_cmd) + IWL_MAX_SCAN_SIZE);
+
+	scan->quiet_plcp_th = IWL_PLCP_QUIET_THRESH;
+	scan->quiet_time = IWL_ACTIVE_QUIET_TIME;
+
+	if (priv->scan_type != IWL_SCAN_ROC &&
+	    iwl_is_any_associated(priv)) {
+		u16 interval = 0;
+		u32 extra;
+		u32 suspend_time = 100;
+		u32 scan_suspend_time = 100;
+
+		IWL_DEBUG_INFO(priv, "Scanning while associated...\n");
+		switch (priv->scan_type) {
+		case IWL_SCAN_ROC:
+			WARN_ON(1);
+			break;
+		case IWL_SCAN_RADIO_RESET:
+			interval = 0;
+			break;
+		case IWL_SCAN_NORMAL:
+			interval = vif->bss_conf.beacon_int;
+			break;
+		}
+
+		scan->suspend_time = 0;
+		scan->max_out_time = cpu_to_le32(200 * 1024);
+		if (!interval)
+			interval = suspend_time;
+
+		extra = (suspend_time / interval) << 22;
+		scan_suspend_time = (extra |
+		    ((suspend_time % interval) * 1024));
+		scan->suspend_time = cpu_to_le32(scan_suspend_time);
+		IWL_DEBUG_SCAN(priv, "suspend_time 0x%X beacon interval %d\n",
+			       scan_suspend_time, interval);
+	} else if (priv->scan_type == IWL_SCAN_ROC) {
+		scan->suspend_time = 0;
+		scan->max_out_time = 0;
+		scan->quiet_time = 0;
+		scan->quiet_plcp_th = 0;
+	}
+
+	switch (priv->scan_type) {
+	case IWL_SCAN_RADIO_RESET:
+		IWL_DEBUG_SCAN(priv, "Start internal passive scan.\n");
+		break;
+	case IWL_SCAN_NORMAL:
+		if (priv->scan_request->n_ssids) {
+			int i, p = 0;
+			IWL_DEBUG_SCAN(priv, "Kicking off active scan\n");
+			for (i = 0; i < priv->scan_request->n_ssids; i++) {
+				/* always does wildcard anyway */
+				if (!priv->scan_request->ssids[i].ssid_len)
+					continue;
+				scan->direct_scan[p].id = WLAN_EID_SSID;
+				scan->direct_scan[p].len =
+					priv->scan_request->ssids[i].ssid_len;
+				memcpy(scan->direct_scan[p].ssid,
+				       priv->scan_request->ssids[i].ssid,
+				       priv->scan_request->ssids[i].ssid_len);
+				n_probes++;
+				p++;
+			}
+			is_active = true;
+		} else
+			IWL_DEBUG_SCAN(priv, "Start passive scan.\n");
+		break;
+	case IWL_SCAN_ROC:
+		IWL_DEBUG_SCAN(priv, "Start ROC scan.\n");
+		break;
+	}
+
+	scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
+	scan->tx_cmd.sta_id = ctx->bcast_sta_id;
+	scan->tx_cmd.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
+
+	switch (priv->scan_band) {
+	case IEEE80211_BAND_2GHZ:
+		scan->flags = RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK;
+		chan_mod = le32_to_cpu(
+			priv->contexts[IWL_RXON_CTX_BSS].active.flags &
+						RXON_FLG_CHANNEL_MODE_MSK)
+				       >> RXON_FLG_CHANNEL_MODE_POS;
+		if (chan_mod == CHANNEL_MODE_PURE_40) {
+			rate = IWL_RATE_6M_PLCP;
+		} else {
+			rate = IWL_RATE_1M_PLCP;
+			rate_flags = RATE_MCS_CCK_MSK;
+		}
+		/*
+		 * Internal scans are passive, so we can indiscriminately set
+		 * the BT ignore flag on 2.4 GHz since it applies to TX only.
+		 */
+		if (priv->cfg->bt_params &&
+		    priv->cfg->bt_params->advanced_bt_coexist)
+			scan->tx_cmd.tx_flags |= TX_CMD_FLG_IGNORE_BT;
+		break;
+	case IEEE80211_BAND_5GHZ:
+		rate = IWL_RATE_6M_PLCP;
+		break;
+	default:
+		IWL_WARN(priv, "Invalid scan band\n");
+		return -EIO;
+	}
+
+	/*
+	 * If active scanning is requested but a certain channel is
+	 * marked passive, we can do active scanning if we detect
+	 * transmissions.
+	 *
+	 * There is an issue with some firmware versions that triggers
+	 * a sysassert on a "good CRC threshold" of zero (== disabled),
+	 * on a radar channel even though this means that we should NOT
+	 * send probes.
+	 *
+	 * The "good CRC threshold" is the number of frames that we
+	 * need to receive during our dwell time on a channel before
+	 * sending out probes -- setting this to a huge value will
+	 * mean we never reach it, but at the same time work around
+	 * the aforementioned issue. Thus use IWL_GOOD_CRC_TH_NEVER
+	 * here instead of IWL_GOOD_CRC_TH_DISABLED.
+	 *
+	 * This was fixed in later versions along with some other
+	 * scan changes, and the threshold behaves as a flag in those
+	 * versions.
+	 */
+	if (priv->new_scan_threshold_behaviour)
+		scan->good_CRC_th = is_active ? IWL_GOOD_CRC_TH_DEFAULT :
+						IWL_GOOD_CRC_TH_DISABLED;
+	else
+		scan->good_CRC_th = is_active ? IWL_GOOD_CRC_TH_DEFAULT :
+						IWL_GOOD_CRC_TH_NEVER;
+
+	band = priv->scan_band;
+
+	if (priv->cfg->scan_rx_antennas[band])
+		rx_ant = priv->cfg->scan_rx_antennas[band];
+
+	if (band == IEEE80211_BAND_2GHZ &&
+	    priv->cfg->bt_params &&
+	    priv->cfg->bt_params->advanced_bt_coexist) {
+		/* transmit 2.4 GHz probes only on first antenna */
+		scan_tx_antennas = first_antenna(scan_tx_antennas);
+	}
+
+	priv->scan_tx_ant[band] = iwl_toggle_tx_ant(priv,
+						    priv->scan_tx_ant[band],
+						    scan_tx_antennas);
+	rate_flags |= iwl_ant_idx_to_flags(priv->scan_tx_ant[band]);
+	scan->tx_cmd.rate_n_flags = iwl_hw_set_rate_n_flags(rate, rate_flags);
+
+	/* In power save mode use one chain, otherwise use all chains */
+	if (test_bit(STATUS_POWER_PMI, &priv->shrd->status)) {
+		/* rx_ant has been set to all valid chains previously */
+		active_chains = rx_ant &
+				((u8)(priv->chain_noise_data.active_chains));
+		if (!active_chains)
+			active_chains = rx_ant;
+
+		IWL_DEBUG_SCAN(priv, "chain_noise_data.active_chains: %u\n",
+				priv->chain_noise_data.active_chains);
+
+		rx_ant = first_antenna(active_chains);
+	}
+	if (priv->cfg->bt_params &&
+	    priv->cfg->bt_params->advanced_bt_coexist &&
+	    priv->bt_full_concurrent) {
+		/* operated as 1x1 in full concurrency mode */
+		rx_ant = first_antenna(rx_ant);
+	}
+
+	/* MIMO is not used here, but value is required */
+	rx_chain |=
+		hw_params(priv).valid_rx_ant << RXON_RX_CHAIN_VALID_POS;
+	rx_chain |= rx_ant << RXON_RX_CHAIN_FORCE_MIMO_SEL_POS;
+	rx_chain |= rx_ant << RXON_RX_CHAIN_FORCE_SEL_POS;
+	rx_chain |= 0x1 << RXON_RX_CHAIN_DRIVER_FORCE_POS;
+	scan->rx_chain = cpu_to_le16(rx_chain);
+	switch (priv->scan_type) {
+	case IWL_SCAN_NORMAL:
+		cmd_len = iwl_fill_probe_req(priv,
+					(struct ieee80211_mgmt *)scan->data,
+					vif->addr,
+					priv->scan_request->ie,
+					priv->scan_request->ie_len,
+					IWL_MAX_SCAN_SIZE - sizeof(*scan));
+		break;
+	case IWL_SCAN_RADIO_RESET:
+	case IWL_SCAN_ROC:
+		/* use bcast addr, will not be transmitted but must be valid */
+		cmd_len = iwl_fill_probe_req(priv,
+					(struct ieee80211_mgmt *)scan->data,
+					iwl_bcast_addr, NULL, 0,
+					IWL_MAX_SCAN_SIZE - sizeof(*scan));
+		break;
+	default:
+		BUG();
+	}
+	scan->tx_cmd.len = cpu_to_le16(cmd_len);
+
+	scan->filter_flags |= (RXON_FILTER_ACCEPT_GRP_MSK |
+			       RXON_FILTER_BCON_AWARE_MSK);
+
+	switch (priv->scan_type) {
+	case IWL_SCAN_RADIO_RESET:
+		scan->channel_count =
+			iwl_get_single_channel_for_scan(priv, vif, band,
+				(void *)&scan->data[cmd_len]);
+		break;
+	case IWL_SCAN_NORMAL:
+		scan->channel_count =
+			iwl_get_channels_for_scan(priv, vif, band,
+				is_active, n_probes,
+				(void *)&scan->data[cmd_len]);
+		break;
+	case IWL_SCAN_ROC: {
+		struct iwl_scan_channel *scan_ch;
+
+		scan->channel_count = 1;
+
+		scan_ch = (void *)&scan->data[cmd_len];
+		scan_ch->type = SCAN_CHANNEL_TYPE_PASSIVE;
+		scan_ch->channel =
+			cpu_to_le16(priv->hw_roc_channel->hw_value);
+		scan_ch->active_dwell =
+		scan_ch->passive_dwell =
+			cpu_to_le16(priv->hw_roc_duration);
+
+		/* Set txpower levels to defaults */
+		scan_ch->dsp_atten = 110;
+
+		/* NOTE: if we were doing 6Mb OFDM for scans we'd use
+		 * power level:
+		 * scan_ch->tx_gain = ((1 << 5) | (2 << 3)) | 3;
+		 */
+		if (priv->hw_roc_channel->band == IEEE80211_BAND_5GHZ)
+			scan_ch->tx_gain = ((1 << 5) | (3 << 3)) | 3;
+		else
+			scan_ch->tx_gain = ((1 << 5) | (5 << 3));
+		}
+		break;
+	}
+
+	if (scan->channel_count == 0) {
+		IWL_DEBUG_SCAN(priv, "channel count %d\n", scan->channel_count);
+		return -EIO;
+	}
+
+	cmd.len[0] += le16_to_cpu(scan->tx_cmd.len) +
+	    scan->channel_count * sizeof(struct iwl_scan_channel);
+	cmd.data[0] = scan;
+	cmd.dataflags[0] = IWL_HCMD_DFL_NOCOPY;
+	scan->len = cpu_to_le16(cmd.len[0]);
+
+	/* set scan bit here for PAN params */
+	set_bit(STATUS_SCAN_HW, &priv->shrd->status);
+
+	ret = iwlagn_set_pan_params(priv);
+	if (ret)
+		return ret;
+
+	ret = iwl_trans_send_cmd(trans(priv), &cmd);
+	if (ret) {
+		clear_bit(STATUS_SCAN_HW, &priv->shrd->status);
+		iwlagn_set_pan_params(priv);
+	}
+
+	return ret;
+}
+
 void iwl_init_scan_params(struct iwl_priv *priv)
 {
 	u8 ant_idx = fls(hw_params(priv).valid_tx_ant) - 1;
-- 
1.7.0.4

