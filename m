Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:28656 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932584Ab0DPVwn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 17:52:43 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/21] iwlwifi: trigger scan synchronously
Date: Fri, 16 Apr 2010 14:52:24 -0700
Message-Id: <1271454758-14351-8-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
References: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Scan requesting doesn't need to be asynchronous
since all code paths leading up to it can sleep.
Make the scan request a new util operation that
is hw-specific (to account for 3945 vs. agn)
and call it right in place.

This patch moves a lot of code into iwlagn as
it need not be in iwlcore.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    3 +
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |  395 +++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    3 +
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 -
 drivers/net/wireless/iwlwifi/iwl-scan.c     |  418 +--------------------------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   10 +-
 10 files changed, 416 insertions(+), 419 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 15de649..51f1895 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2740,6 +2740,7 @@ static struct iwl_hcmd_utils_ops iwl3945_hcmd_utils = {
 	.get_hcmd_size = iwl3945_get_hcmd_size,
 	.build_addsta_hcmd = iwl3945_build_addsta_hcmd,
 	.rts_tx_cmd_flag = iwlcore_rts_tx_cmd_flag,
+	.request_scan = iwl3945_request_scan,
 };
 
 static const struct iwl_ops iwl3945_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index b892195..e9674f0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -294,6 +294,9 @@ extern const struct iwl_channel_info *iwl3945_get_channel_info(
 
 extern int iwl3945_rs_next_rate(struct iwl_priv *priv, int rate);
 
+/* scanning */
+void iwl3945_request_scan(struct iwl_priv *priv);
+
 /* Requires full declaration of iwl_priv before including */
 #include "iwl-io.h"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 2e3cda7..0a5f21e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2162,6 +2162,7 @@ static struct iwl_hcmd_utils_ops iwl4965_hcmd_utils = {
 	.gain_computation = iwl4965_gain_computation,
 	.rts_tx_cmd_flag = iwlcore_rts_tx_cmd_flag,
 	.calc_rssi = iwl4965_calc_rssi,
+	.request_scan = iwlagn_request_scan,
 };
 
 static struct iwl_lib_ops iwl4965_lib = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index 28bc8f8..231d0e6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -271,4 +271,5 @@ struct iwl_hcmd_utils_ops iwlagn_hcmd_utils = {
 	.chain_noise_reset = iwlagn_chain_noise_reset,
 	.rts_tx_cmd_flag = iwlagn_rts_tx_cmd_flag,
 	.calc_rssi = iwlagn_calc_rssi,
+	.request_scan = iwlagn_request_scan,
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index c465c85..048c615 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1111,3 +1111,398 @@ void iwlagn_rx_reply_rx_phy(struct iwl_priv *priv,
 	memcpy(&priv->_agn.last_phy_res, pkt->u.raw,
 	       sizeof(struct iwl_rx_phy_res));
 }
+
+static int iwl_get_single_channel_for_scan(struct iwl_priv *priv,
+				     enum ieee80211_band band,
+				     struct iwl_scan_channel *scan_ch)
+{
+	const struct ieee80211_supported_band *sband;
+	const struct iwl_channel_info *ch_info;
+	u16 passive_dwell = 0;
+	u16 active_dwell = 0;
+	int i, added = 0;
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
+	/* only scan single channel, good enough to reset the RF */
+	/* pick the first valid not in-use channel */
+	if (band == IEEE80211_BAND_5GHZ) {
+		for (i = 14; i < priv->channel_count; i++) {
+			if (priv->channel_info[i].channel !=
+			    le16_to_cpu(priv->staging_rxon.channel)) {
+				channel = priv->channel_info[i].channel;
+				ch_info = iwl_get_channel_info(priv,
+					band, channel);
+				if (is_channel_valid(ch_info))
+					break;
+			}
+		}
+	} else {
+		for (i = 0; i < 14; i++) {
+			if (priv->channel_info[i].channel !=
+			    le16_to_cpu(priv->staging_rxon.channel)) {
+					channel =
+						priv->channel_info[i].channel;
+					ch_info = iwl_get_channel_info(priv,
+						band, channel);
+					if (is_channel_valid(ch_info))
+						break;
+			}
+		}
+	}
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
+		channel = ieee80211_frequency_to_channel(chan->center_freq);
+		scan_ch->channel = cpu_to_le16(channel);
+
+		ch_info = iwl_get_channel_info(priv, band, channel);
+		if (!is_channel_valid(ch_info)) {
+			IWL_DEBUG_SCAN(priv, "Channel %d is INVALID for this band.\n",
+					channel);
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
+void iwlagn_request_scan(struct iwl_priv *priv)
+{
+	struct iwl_host_cmd cmd = {
+		.id = REPLY_SCAN_CMD,
+		.len = sizeof(struct iwl_scan_cmd),
+		.flags = CMD_SIZE_HUGE,
+	};
+	struct iwl_scan_cmd *scan;
+	struct ieee80211_conf *conf = NULL;
+	u32 rate_flags = 0;
+	u16 cmd_len;
+	u16 rx_chain = 0;
+	enum ieee80211_band band;
+	u8 n_probes = 0;
+	u8 rx_ant = priv->hw_params.valid_rx_ant;
+	u8 rate;
+	bool is_active = false;
+	int  chan_mod;
+	u8 active_chains;
+
+	conf = ieee80211_get_hw_conf(priv->hw);
+
+	cancel_delayed_work(&priv->scan_check);
+
+	if (!iwl_is_ready(priv)) {
+		IWL_WARN(priv, "request scan called when driver not ready.\n");
+		goto done;
+	}
+
+	/* Make sure the scan wasn't canceled before this queued work
+	 * was given the chance to run... */
+	if (!test_bit(STATUS_SCANNING, &priv->status))
+		goto done;
+
+	/* This should never be called or scheduled if there is currently
+	 * a scan active in the hardware. */
+	if (test_bit(STATUS_SCAN_HW, &priv->status)) {
+		IWL_DEBUG_INFO(priv, "Multiple concurrent scan requests in parallel. "
+			       "Ignoring second request.\n");
+		goto done;
+	}
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
+		IWL_DEBUG_SCAN(priv, "Aborting scan due to device shutdown\n");
+		goto done;
+	}
+
+	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
+		IWL_DEBUG_HC(priv, "Scan request while abort pending.  Queuing.\n");
+		goto done;
+	}
+
+	if (iwl_is_rfkill(priv)) {
+		IWL_DEBUG_HC(priv, "Aborting scan due to RF Kill activation\n");
+		goto done;
+	}
+
+	if (!test_bit(STATUS_READY, &priv->status)) {
+		IWL_DEBUG_HC(priv, "Scan request while uninitialized.  Queuing.\n");
+		goto done;
+	}
+
+	if (!priv->scan_cmd) {
+		priv->scan_cmd = kmalloc(sizeof(struct iwl_scan_cmd) +
+					 IWL_MAX_SCAN_SIZE, GFP_KERNEL);
+		if (!priv->scan_cmd) {
+			IWL_DEBUG_SCAN(priv,
+				       "fail to allocate memory for scan\n");
+			goto done;
+		}
+	}
+	scan = priv->scan_cmd;
+	memset(scan, 0, sizeof(struct iwl_scan_cmd) + IWL_MAX_SCAN_SIZE);
+
+	scan->quiet_plcp_th = IWL_PLCP_QUIET_THRESH;
+	scan->quiet_time = IWL_ACTIVE_QUIET_TIME;
+
+	if (iwl_is_associated(priv)) {
+		u16 interval = 0;
+		u32 extra;
+		u32 suspend_time = 100;
+		u32 scan_suspend_time = 100;
+		unsigned long flags;
+
+		IWL_DEBUG_INFO(priv, "Scanning while associated...\n");
+		spin_lock_irqsave(&priv->lock, flags);
+		interval = priv->beacon_int;
+		spin_unlock_irqrestore(&priv->lock, flags);
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
+	}
+
+	if (priv->is_internal_short_scan) {
+		IWL_DEBUG_SCAN(priv, "Start internal passive scan.\n");
+	} else if (priv->scan_request->n_ssids) {
+		int i, p = 0;
+		IWL_DEBUG_SCAN(priv, "Kicking off active scan\n");
+		for (i = 0; i < priv->scan_request->n_ssids; i++) {
+			/* always does wildcard anyway */
+			if (!priv->scan_request->ssids[i].ssid_len)
+				continue;
+			scan->direct_scan[p].id = WLAN_EID_SSID;
+			scan->direct_scan[p].len =
+				priv->scan_request->ssids[i].ssid_len;
+			memcpy(scan->direct_scan[p].ssid,
+			       priv->scan_request->ssids[i].ssid,
+			       priv->scan_request->ssids[i].ssid_len);
+			n_probes++;
+			p++;
+		}
+		is_active = true;
+	} else
+		IWL_DEBUG_SCAN(priv, "Start passive scan.\n");
+
+	scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
+	scan->tx_cmd.sta_id = priv->hw_params.bcast_sta_id;
+	scan->tx_cmd.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
+
+	switch (priv->scan_band) {
+	case IEEE80211_BAND_2GHZ:
+		scan->flags = RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK;
+		chan_mod = le32_to_cpu(priv->active_rxon.flags & RXON_FLG_CHANNEL_MODE_MSK)
+				       >> RXON_FLG_CHANNEL_MODE_POS;
+		if (chan_mod == CHANNEL_MODE_PURE_40) {
+			rate = IWL_RATE_6M_PLCP;
+		} else {
+			rate = IWL_RATE_1M_PLCP;
+			rate_flags = RATE_MCS_CCK_MSK;
+		}
+		scan->good_CRC_th = 0;
+		break;
+	case IEEE80211_BAND_5GHZ:
+		rate = IWL_RATE_6M_PLCP;
+		/*
+		 * If active scaning is requested but a certain channel
+		 * is marked passive, we can do active scanning if we
+		 * detect transmissions.
+		 */
+		scan->good_CRC_th = is_active ? IWL_GOOD_CRC_TH : 0;
+
+		/* Force use of chains B and C (0x6) for scan Rx
+		 * Avoid A (0x1) for the device has off-channel reception
+		 * on A-band.
+		 */
+		if (priv->cfg->off_channel_workaround)
+			rx_ant = ANT_BC;
+		break;
+	default:
+		IWL_WARN(priv, "Invalid scan band count\n");
+		goto done;
+	}
+
+	band = priv->scan_band;
+
+	priv->scan_tx_ant[band] =
+			iwl_toggle_tx_ant(priv, priv->scan_tx_ant[band]);
+	rate_flags |= iwl_ant_idx_to_flags(priv->scan_tx_ant[band]);
+	scan->tx_cmd.rate_n_flags = iwl_hw_set_rate_n_flags(rate, rate_flags);
+
+	/* In power save mode use one chain, otherwise use all chains */
+	if (test_bit(STATUS_POWER_PMI, &priv->status)) {
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
+	/* MIMO is not used here, but value is required */
+	rx_chain |= priv->hw_params.valid_rx_ant << RXON_RX_CHAIN_VALID_POS;
+	rx_chain |= rx_ant << RXON_RX_CHAIN_FORCE_MIMO_SEL_POS;
+	rx_chain |= rx_ant << RXON_RX_CHAIN_FORCE_SEL_POS;
+	rx_chain |= 0x1 << RXON_RX_CHAIN_DRIVER_FORCE_POS;
+	scan->rx_chain = cpu_to_le16(rx_chain);
+	if (!priv->is_internal_short_scan) {
+		cmd_len = iwl_fill_probe_req(priv,
+					(struct ieee80211_mgmt *)scan->data,
+					priv->scan_request->ie,
+					priv->scan_request->ie_len,
+					IWL_MAX_SCAN_SIZE - sizeof(*scan));
+	} else {
+		cmd_len = iwl_fill_probe_req(priv,
+					(struct ieee80211_mgmt *)scan->data,
+					NULL, 0,
+					IWL_MAX_SCAN_SIZE - sizeof(*scan));
+
+	}
+	scan->tx_cmd.len = cpu_to_le16(cmd_len);
+	if (iwl_is_monitor_mode(priv))
+		scan->filter_flags = RXON_FILTER_PROMISC_MSK;
+
+	scan->filter_flags |= (RXON_FILTER_ACCEPT_GRP_MSK |
+			       RXON_FILTER_BCON_AWARE_MSK);
+
+	if (priv->is_internal_short_scan) {
+		scan->channel_count =
+			iwl_get_single_channel_for_scan(priv, band,
+				(void *)&scan->data[le16_to_cpu(
+				scan->tx_cmd.len)]);
+	} else {
+		scan->channel_count =
+			iwl_get_channels_for_scan(priv, band,
+				is_active, n_probes,
+				(void *)&scan->data[le16_to_cpu(
+				scan->tx_cmd.len)]);
+	}
+	if (scan->channel_count == 0) {
+		IWL_DEBUG_SCAN(priv, "channel count %d\n", scan->channel_count);
+		goto done;
+	}
+
+	cmd.len += le16_to_cpu(scan->tx_cmd.len) +
+	    scan->channel_count * sizeof(struct iwl_scan_channel);
+	cmd.data = scan;
+	scan->len = cpu_to_le16(cmd.len);
+
+	set_bit(STATUS_SCAN_HW, &priv->status);
+	if (iwl_send_cmd_sync(priv, &cmd))
+		goto done;
+
+	queue_delayed_work(priv->workqueue, &priv->scan_check,
+			   IWL_SCAN_CHECK_WATCHDOG);
+
+	return;
+
+ done:
+	/* Cannot perform scan. Make sure we clear scanning
+	* bits from status so next scan request can be performed.
+	* If we don't clear scanning status bit here all next scan
+	* will fail
+	*/
+	clear_bit(STATUS_SCAN_HW, &priv->status);
+	clear_bit(STATUS_SCANNING, &priv->status);
+	/* inform mac80211 scan aborted */
+	queue_work(priv->workqueue, &priv->scan_completed);
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 5d31422..cfee999 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -171,4 +171,7 @@ static inline bool iwl_is_tx_success(u32 status)
 	       (status == TX_STATUS_DIRECT_DONE);
 }
 
+/* scan */
+void iwlagn_request_scan(struct iwl_priv *priv);
+
 #endif /* __iwl_agn_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 6c3f012..1d91ffd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -105,6 +105,7 @@ struct iwl_hcmd_utils_ops {
 			__le32 *tx_flags);
 	int  (*calc_rssi)(struct iwl_priv *priv,
 			  struct iwl_rx_phy_res *rx_resp);
+	void (*request_scan)(struct iwl_priv *priv);
 };
 
 struct iwl_apm_ops {
@@ -526,6 +527,7 @@ void iwl_setup_scan_deferred_work(struct iwl_priv *priv);
 #define IWL_ACTIVE_QUIET_TIME       cpu_to_le16(10)  /* msec */
 #define IWL_PLCP_QUIET_THRESH       cpu_to_le16(1)  /* packets */
 
+#define IWL_SCAN_CHECK_WATCHDOG		(HZ * 7)
 
 /*******************************************************************************
  * Calibrations - implemented in iwl-calib.c
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 4007b57..dc9d8ae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1257,7 +1257,6 @@ struct iwl_priv {
 	struct work_struct scan_completed;
 	struct work_struct rx_replenish;
 	struct work_struct abort_scan;
-	struct work_struct request_scan;
 	struct work_struct beacon_update;
 	struct work_struct tt_work;
 	struct work_struct ct_enter;
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 18b89d3..92115f5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -284,150 +284,6 @@ u16 iwl_get_passive_dwell_time(struct iwl_priv *priv,
 }
 EXPORT_SYMBOL(iwl_get_passive_dwell_time);
 
-static int iwl_get_single_channel_for_scan(struct iwl_priv *priv,
-				     enum ieee80211_band band,
-				     struct iwl_scan_channel *scan_ch)
-{
-	const struct ieee80211_supported_band *sband;
-	const struct iwl_channel_info *ch_info;
-	u16 passive_dwell = 0;
-	u16 active_dwell = 0;
-	int i, added = 0;
-	u16 channel = 0;
-
-	sband = iwl_get_hw_mode(priv, band);
-	if (!sband) {
-		IWL_ERR(priv, "invalid band\n");
-		return added;
-	}
-
-	active_dwell = iwl_get_active_dwell_time(priv, band, 0);
-	passive_dwell = iwl_get_passive_dwell_time(priv, band);
-
-	if (passive_dwell <= active_dwell)
-		passive_dwell = active_dwell + 1;
-
-	/* only scan single channel, good enough to reset the RF */
-	/* pick the first valid not in-use channel */
-	if (band == IEEE80211_BAND_5GHZ) {
-		for (i = 14; i < priv->channel_count; i++) {
-			if (priv->channel_info[i].channel !=
-			    le16_to_cpu(priv->staging_rxon.channel)) {
-				channel = priv->channel_info[i].channel;
-				ch_info = iwl_get_channel_info(priv,
-					band, channel);
-				if (is_channel_valid(ch_info))
-					break;
-			}
-		}
-	} else {
-		for (i = 0; i < 14; i++) {
-			if (priv->channel_info[i].channel !=
-			    le16_to_cpu(priv->staging_rxon.channel)) {
-					channel =
-						priv->channel_info[i].channel;
-					ch_info = iwl_get_channel_info(priv,
-						band, channel);
-					if (is_channel_valid(ch_info))
-						break;
-			}
-		}
-	}
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
-	passive_dwell = iwl_get_passive_dwell_time(priv, band);
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
-		channel = ieee80211_frequency_to_channel(chan->center_freq);
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
 void iwl_init_scan_params(struct iwl_priv *priv)
 {
 	u8 ant_idx = fls(priv->hw_params.valid_tx_ant) - 1;
@@ -447,7 +303,10 @@ static int iwl_scan_initiate(struct iwl_priv *priv)
 	priv->is_internal_short_scan = false;
 	priv->scan_start = jiffies;
 
-	queue_work(priv->workqueue, &priv->request_scan);
+	if (WARN_ON(!priv->cfg->ops->utils->request_scan))
+		return -EOPNOTSUPP;
+
+	priv->cfg->ops->utils->request_scan(priv);
 
 	return 0;
 }
@@ -455,7 +314,6 @@ static int iwl_scan_initiate(struct iwl_priv *priv)
 int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 		     struct cfg80211_scan_request *req)
 {
-	unsigned long flags;
 	struct iwl_priv *priv = hw->priv;
 	int ret;
 
@@ -465,7 +323,6 @@ int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 		return -EINVAL;
 
 	mutex_lock(&priv->mutex);
-	spin_lock_irqsave(&priv->lock, flags);
 
 	if (!iwl_is_ready_rf(priv)) {
 		ret = -EIO;
@@ -494,7 +351,6 @@ int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 	IWL_DEBUG_MAC80211(priv, "leave\n");
 
 out_unlock:
-	spin_unlock_irqrestore(&priv->lock, flags);
 	mutex_unlock(&priv->mutex);
 
 	return ret;
@@ -537,13 +393,15 @@ static void iwl_bg_start_internal_scan(struct work_struct *work)
 	IWL_DEBUG_SCAN(priv, "Start internal short scan...\n");
 	set_bit(STATUS_SCANNING, &priv->status);
 	priv->is_internal_short_scan = true;
-	queue_work(priv->workqueue, &priv->request_scan);
+
+	if (WARN_ON(!priv->cfg->ops->utils->request_scan))
+		goto unlock;
+
+	priv->cfg->ops->utils->request_scan(priv);
  unlock:
 	mutex_unlock(&priv->mutex);
 }
 
-#define IWL_SCAN_CHECK_WATCHDOG (7 * HZ)
-
 void iwl_bg_scan_check(struct work_struct *data)
 {
 	struct iwl_priv *priv =
@@ -614,263 +472,6 @@ u16 iwl_fill_probe_req(struct iwl_priv *priv, struct ieee80211_mgmt *frame,
 }
 EXPORT_SYMBOL(iwl_fill_probe_req);
 
-static void iwl_bg_request_scan(struct work_struct *data)
-{
-	struct iwl_priv *priv =
-	    container_of(data, struct iwl_priv, request_scan);
-	struct iwl_host_cmd cmd = {
-		.id = REPLY_SCAN_CMD,
-		.len = sizeof(struct iwl_scan_cmd),
-		.flags = CMD_SIZE_HUGE,
-	};
-	struct iwl_scan_cmd *scan;
-	struct ieee80211_conf *conf = NULL;
-	u32 rate_flags = 0;
-	u16 cmd_len;
-	u16 rx_chain = 0;
-	enum ieee80211_band band;
-	u8 n_probes = 0;
-	u8 rx_ant = priv->hw_params.valid_rx_ant;
-	u8 rate;
-	bool is_active = false;
-	int  chan_mod;
-	u8 active_chains;
-
-	conf = ieee80211_get_hw_conf(priv->hw);
-
-	mutex_lock(&priv->mutex);
-
-	cancel_delayed_work(&priv->scan_check);
-
-	if (!iwl_is_ready(priv)) {
-		IWL_WARN(priv, "request scan called when driver not ready.\n");
-		goto done;
-	}
-
-	/* Make sure the scan wasn't canceled before this queued work
-	 * was given the chance to run... */
-	if (!test_bit(STATUS_SCANNING, &priv->status))
-		goto done;
-
-	/* This should never be called or scheduled if there is currently
-	 * a scan active in the hardware. */
-	if (test_bit(STATUS_SCAN_HW, &priv->status)) {
-		IWL_DEBUG_INFO(priv, "Multiple concurrent scan requests in parallel. "
-			       "Ignoring second request.\n");
-		goto done;
-	}
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
-		IWL_DEBUG_SCAN(priv, "Aborting scan due to device shutdown\n");
-		goto done;
-	}
-
-	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
-		IWL_DEBUG_HC(priv, "Scan request while abort pending.  Queuing.\n");
-		goto done;
-	}
-
-	if (iwl_is_rfkill(priv)) {
-		IWL_DEBUG_HC(priv, "Aborting scan due to RF Kill activation\n");
-		goto done;
-	}
-
-	if (!test_bit(STATUS_READY, &priv->status)) {
-		IWL_DEBUG_HC(priv, "Scan request while uninitialized.  Queuing.\n");
-		goto done;
-	}
-
-	if (!priv->scan_cmd) {
-		priv->scan_cmd = kmalloc(sizeof(struct iwl_scan_cmd) +
-					 IWL_MAX_SCAN_SIZE, GFP_KERNEL);
-		if (!priv->scan_cmd) {
-			IWL_DEBUG_SCAN(priv,
-				       "fail to allocate memory for scan\n");
-			goto done;
-		}
-	}
-	scan = priv->scan_cmd;
-	memset(scan, 0, sizeof(struct iwl_scan_cmd) + IWL_MAX_SCAN_SIZE);
-
-	scan->quiet_plcp_th = IWL_PLCP_QUIET_THRESH;
-	scan->quiet_time = IWL_ACTIVE_QUIET_TIME;
-
-	if (iwl_is_associated(priv)) {
-		u16 interval = 0;
-		u32 extra;
-		u32 suspend_time = 100;
-		u32 scan_suspend_time = 100;
-		unsigned long flags;
-
-		IWL_DEBUG_INFO(priv, "Scanning while associated...\n");
-		spin_lock_irqsave(&priv->lock, flags);
-		interval = priv->beacon_int;
-		spin_unlock_irqrestore(&priv->lock, flags);
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
-	}
-
-	if (priv->is_internal_short_scan) {
-		IWL_DEBUG_SCAN(priv, "Start internal passive scan.\n");
-	} else if (priv->scan_request->n_ssids) {
-		int i, p = 0;
-		IWL_DEBUG_SCAN(priv, "Kicking off active scan\n");
-		for (i = 0; i < priv->scan_request->n_ssids; i++) {
-			/* always does wildcard anyway */
-			if (!priv->scan_request->ssids[i].ssid_len)
-				continue;
-			scan->direct_scan[p].id = WLAN_EID_SSID;
-			scan->direct_scan[p].len =
-				priv->scan_request->ssids[i].ssid_len;
-			memcpy(scan->direct_scan[p].ssid,
-			       priv->scan_request->ssids[i].ssid,
-			       priv->scan_request->ssids[i].ssid_len);
-			n_probes++;
-			p++;
-		}
-		is_active = true;
-	} else
-		IWL_DEBUG_SCAN(priv, "Start passive scan.\n");
-
-	scan->tx_cmd.tx_flags = TX_CMD_FLG_SEQ_CTL_MSK;
-	scan->tx_cmd.sta_id = priv->hw_params.bcast_sta_id;
-	scan->tx_cmd.stop_time.life_time = TX_CMD_LIFE_TIME_INFINITE;
-
-	switch (priv->scan_band) {
-	case IEEE80211_BAND_2GHZ:
-		scan->flags = RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK;
-		chan_mod = le32_to_cpu(priv->active_rxon.flags & RXON_FLG_CHANNEL_MODE_MSK)
-				       >> RXON_FLG_CHANNEL_MODE_POS;
-		if (chan_mod == CHANNEL_MODE_PURE_40) {
-			rate = IWL_RATE_6M_PLCP;
-		} else {
-			rate = IWL_RATE_1M_PLCP;
-			rate_flags = RATE_MCS_CCK_MSK;
-		}
-		scan->good_CRC_th = 0;
-		break;
-	case IEEE80211_BAND_5GHZ:
-		rate = IWL_RATE_6M_PLCP;
-		/*
-		 * If active scaning is requested but a certain channel
-		 * is marked passive, we can do active scanning if we
-		 * detect transmissions.
-		 */
-		scan->good_CRC_th = is_active ? IWL_GOOD_CRC_TH : 0;
-
-		/* Force use of chains B and C (0x6) for scan Rx
-		 * Avoid A (0x1) for the device has off-channel reception
-		 * on A-band.
-		 */
-		if (priv->cfg->off_channel_workaround)
-			rx_ant = ANT_BC;
-		break;
-	default:
-		IWL_WARN(priv, "Invalid scan band count\n");
-		goto done;
-	}
-
-	band = priv->scan_band;
-
-	priv->scan_tx_ant[band] =
-			iwl_toggle_tx_ant(priv, priv->scan_tx_ant[band]);
-	rate_flags |= iwl_ant_idx_to_flags(priv->scan_tx_ant[band]);
-	scan->tx_cmd.rate_n_flags = iwl_hw_set_rate_n_flags(rate, rate_flags);
-
-	/* In power save mode use one chain, otherwise use all chains */
-	if (test_bit(STATUS_POWER_PMI, &priv->status)) {
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
-	/* MIMO is not used here, but value is required */
-	rx_chain |= priv->hw_params.valid_rx_ant << RXON_RX_CHAIN_VALID_POS;
-	rx_chain |= rx_ant << RXON_RX_CHAIN_FORCE_MIMO_SEL_POS;
-	rx_chain |= rx_ant << RXON_RX_CHAIN_FORCE_SEL_POS;
-	rx_chain |= 0x1 << RXON_RX_CHAIN_DRIVER_FORCE_POS;
-	scan->rx_chain = cpu_to_le16(rx_chain);
-	if (!priv->is_internal_short_scan) {
-		cmd_len = iwl_fill_probe_req(priv,
-					(struct ieee80211_mgmt *)scan->data,
-					priv->scan_request->ie,
-					priv->scan_request->ie_len,
-					IWL_MAX_SCAN_SIZE - sizeof(*scan));
-	} else {
-		cmd_len = iwl_fill_probe_req(priv,
-					(struct ieee80211_mgmt *)scan->data,
-					NULL, 0,
-					IWL_MAX_SCAN_SIZE - sizeof(*scan));
-
-	}
-	scan->tx_cmd.len = cpu_to_le16(cmd_len);
-	if (iwl_is_monitor_mode(priv))
-		scan->filter_flags = RXON_FILTER_PROMISC_MSK;
-
-	scan->filter_flags |= (RXON_FILTER_ACCEPT_GRP_MSK |
-			       RXON_FILTER_BCON_AWARE_MSK);
-
-	if (priv->is_internal_short_scan) {
-		scan->channel_count =
-			iwl_get_single_channel_for_scan(priv, band,
-				(void *)&scan->data[le16_to_cpu(
-				scan->tx_cmd.len)]);
-	} else {
-		scan->channel_count =
-			iwl_get_channels_for_scan(priv, band,
-				is_active, n_probes,
-				(void *)&scan->data[le16_to_cpu(
-				scan->tx_cmd.len)]);
-	}
-	if (scan->channel_count == 0) {
-		IWL_DEBUG_SCAN(priv, "channel count %d\n", scan->channel_count);
-		goto done;
-	}
-
-	cmd.len += le16_to_cpu(scan->tx_cmd.len) +
-	    scan->channel_count * sizeof(struct iwl_scan_channel);
-	cmd.data = scan;
-	scan->len = cpu_to_le16(cmd.len);
-
-	set_bit(STATUS_SCAN_HW, &priv->status);
-	if (iwl_send_cmd_sync(priv, &cmd))
-		goto done;
-
-	queue_delayed_work(priv->workqueue, &priv->scan_check,
-			   IWL_SCAN_CHECK_WATCHDOG);
-
-	mutex_unlock(&priv->mutex);
-	return;
-
- done:
-	/* Cannot perform scan. Make sure we clear scanning
-	* bits from status so next scan request can be performed.
-	* If we don't clear scanning status bit here all next scan
-	* will fail
-	*/
-	clear_bit(STATUS_SCAN_HW, &priv->status);
-	clear_bit(STATUS_SCANNING, &priv->status);
-	/* inform mac80211 scan aborted */
-	queue_work(priv->workqueue, &priv->scan_completed);
-	mutex_unlock(&priv->mutex);
-}
-
 void iwl_bg_abort_scan(struct work_struct *work)
 {
 	struct iwl_priv *priv = container_of(work, struct iwl_priv, abort_scan);
@@ -918,7 +519,6 @@ EXPORT_SYMBOL(iwl_bg_scan_completed);
 void iwl_setup_scan_deferred_work(struct iwl_priv *priv)
 {
 	INIT_WORK(&priv->scan_completed, iwl_bg_scan_completed);
-	INIT_WORK(&priv->request_scan, iwl_bg_request_scan);
 	INIT_WORK(&priv->abort_scan, iwl_bg_abort_scan);
 	INIT_WORK(&priv->start_internal_scan, iwl_bg_start_internal_scan);
 	INIT_DELAYED_WORK(&priv->scan_check, iwl_bg_scan_check);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 0f77397..06004d0 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2790,11 +2790,8 @@ static void iwl3945_rfkill_poll(struct work_struct *data)
 
 }
 
-#define IWL_SCAN_CHECK_WATCHDOG (7 * HZ)
-static void iwl3945_bg_request_scan(struct work_struct *data)
+void iwl3945_request_scan(struct iwl_priv *priv)
 {
-	struct iwl_priv *priv =
-	    container_of(data, struct iwl_priv, request_scan);
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_SCAN_CMD,
 		.len = sizeof(struct iwl3945_scan_cmd),
@@ -2808,8 +2805,6 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 
 	conf = ieee80211_get_hw_conf(priv->hw);
 
-	mutex_lock(&priv->mutex);
-
 	cancel_delayed_work(&priv->scan_check);
 
 	if (!iwl_is_ready(priv)) {
@@ -2992,7 +2987,6 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 	queue_delayed_work(priv->workqueue, &priv->scan_check,
 			   IWL_SCAN_CHECK_WATCHDOG);
 
-	mutex_unlock(&priv->mutex);
 	return;
 
  done:
@@ -3006,7 +3000,6 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 
 	/* inform mac80211 scan aborted */
 	queue_work(priv->workqueue, &priv->scan_completed);
-	mutex_unlock(&priv->mutex);
 }
 
 static void iwl3945_bg_restart(struct work_struct *data)
@@ -3785,7 +3778,6 @@ static void iwl3945_setup_deferred_work(struct iwl_priv *priv)
 	INIT_DELAYED_WORK(&priv->alive_start, iwl3945_bg_alive_start);
 	INIT_DELAYED_WORK(&priv->_3945.rfkill_poll, iwl3945_rfkill_poll);
 	INIT_WORK(&priv->scan_completed, iwl_bg_scan_completed);
-	INIT_WORK(&priv->request_scan, iwl3945_bg_request_scan);
 	INIT_WORK(&priv->abort_scan, iwl_bg_abort_scan);
 	INIT_DELAYED_WORK(&priv->scan_check, iwl_bg_scan_check);
 
-- 
1.6.3.3

