Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22727 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852Ab0CYUpB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 16:45:01 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 18/22] iwlwifi: remove noise reporting
Date: Thu, 25 Mar 2010 13:44:46 -0700
Message-Id: <1269549890-19195-19-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
References: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We go to great lengths to calculate this value
that is never used by mac80211. Additionally,
it is now deprecated by mac80211 and is causing
driver compilation to give warnings.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c    |   36 ++++------------------------
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   20 +--------------
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c  |    2 -
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    2 -
 drivers/net/wireless/iwlwifi/iwl-rx.c      |    7 +++--
 5 files changed, 11 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 21ae61d..6b72015 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -622,7 +622,6 @@ static void iwl3945_rx_reply_rx(struct iwl_priv *priv,
 	struct iwl3945_rx_frame_stats *rx_stats = IWL_RX_STATS(pkt);
 	struct iwl3945_rx_frame_hdr *rx_hdr = IWL_RX_HDR(pkt);
 	struct iwl3945_rx_frame_end *rx_end = IWL_RX_END(pkt);
-	int snr;
 	u16 rx_stats_sig_avg = le16_to_cpu(rx_stats->sig_avg);
 	u16 rx_stats_noise_diff = le16_to_cpu(rx_stats->noise_diff);
 	u8 network_packet;
@@ -662,43 +661,19 @@ static void iwl3945_rx_reply_rx(struct iwl_priv *priv,
 	/* Convert 3945's rssi indicator to dBm */
 	rx_status.signal = rx_stats->rssi - IWL39_RSSI_OFFSET;
 
-	/* Set default noise value to -127 */
-	if (priv->last_rx_noise == 0)
-		priv->last_rx_noise = IWL_NOISE_MEAS_NOT_AVAILABLE;
-
-	/* 3945 provides noise info for OFDM frames only.
-	 * sig_avg and noise_diff are measured by the 3945's digital signal
-	 *   processor (DSP), and indicate linear levels of signal level and
-	 *   distortion/noise within the packet preamble after
-	 *   automatic gain control (AGC).  sig_avg should stay fairly
-	 *   constant if the radio's AGC is working well.
-	 * Since these values are linear (not dB or dBm), linear
-	 *   signal-to-noise ratio (SNR) is (sig_avg / noise_diff).
-	 * Convert linear SNR to dB SNR, then subtract that from rssi dBm
-	 *   to obtain noise level in dBm.
-	 * Calculate rx_status.signal (quality indicator in %) based on SNR. */
-	if (rx_stats_noise_diff) {
-		snr = rx_stats_sig_avg / rx_stats_noise_diff;
-		rx_status.noise = rx_status.signal -
-					iwl3945_calc_db_from_ratio(snr);
-	} else {
-		rx_status.noise = priv->last_rx_noise;
-	}
-
-
-	IWL_DEBUG_STATS(priv, "Rssi %d noise %d sig_avg %d noise_diff %d\n",
-			rx_status.signal, rx_status.noise,
-			rx_stats_sig_avg, rx_stats_noise_diff);
+	IWL_DEBUG_STATS(priv, "Rssi %d sig_avg %d noise_diff %d\n",
+			rx_status.signal, rx_stats_sig_avg,
+			rx_stats_noise_diff);
 
 	header = (struct ieee80211_hdr *)IWL_RX_DATA(pkt);
 
 	network_packet = iwl3945_is_network_packet(priv, header);
 
-	IWL_DEBUG_STATS_LIMIT(priv, "[%c] %d RSSI:%d Signal:%u, Noise:%u, Rate:%u\n",
+	IWL_DEBUG_STATS_LIMIT(priv, "[%c] %d RSSI:%d Signal:%u, Rate:%u\n",
 			      network_packet ? '*' : ' ',
 			      le16_to_cpu(rx_hdr->channel),
 			      rx_status.signal, rx_status.signal,
-			      rx_status.noise, rx_status.rate_idx);
+			      rx_status.rate_idx);
 
 	/* Set "1" to report good data frames in groups of 100 */
 	iwl3945_dbg_report_frame(priv, pkt, header, 1);
@@ -709,7 +684,6 @@ static void iwl3945_rx_reply_rx(struct iwl_priv *priv,
 			le32_to_cpu(rx_end->beacon_timestamp);
 		priv->_3945.last_tsf = le64_to_cpu(rx_end->timestamp);
 		priv->_3945.last_rx_rssi = rx_status.signal;
-		priv->last_rx_noise = rx_status.noise;
 	}
 
 	iwl3945_pass_packet_to_mac80211(priv, rxb, &rx_status);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 226862d..e8e3118 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1071,30 +1071,14 @@ void iwlagn_rx_reply_rx(struct iwl_priv *priv,
 	/* Find max signal strength (dBm) among 3 antenna/receiver chains */
 	rx_status.signal = iwlagn_calc_rssi(priv, phy_res);
 
-	/* Meaningful noise values are available only from beacon statistics,
-	 *   which are gathered only when associated, and indicate noise
-	 *   only for the associated network channel ...
-	 * Ignore these noise values while scanning (other channels) */
-	if (iwl_is_associated(priv) &&
-	    !test_bit(STATUS_SCANNING, &priv->status)) {
-		rx_status.noise = priv->last_rx_noise;
-	} else {
-		rx_status.noise = IWL_NOISE_MEAS_NOT_AVAILABLE;
-	}
-
-	/* Reset beacon noise level if not associated. */
-	if (!iwl_is_associated(priv))
-		priv->last_rx_noise = IWL_NOISE_MEAS_NOT_AVAILABLE;
-
 #ifdef CONFIG_IWLWIFI_DEBUG
 	/* Set "1" to report good data frames in groups of 100 */
 	if (unlikely(iwl_get_debug_level(priv) & IWL_DL_RX))
 		iwlagn_dbg_report_frame(priv, phy_res, len, header, 1);
 #endif
 	iwl_dbg_log_rx_data_frame(priv, len, header);
-	IWL_DEBUG_STATS_LIMIT(priv, "Rssi %d, noise %d, TSF %llu\n",
-		rx_status.signal, rx_status.noise,
-		(unsigned long long)rx_status.mactime);
+	IWL_DEBUG_STATS_LIMIT(priv, "Rssi %d, TSF %llu\n",
+		rx_status.signal, (unsigned long long)rx_status.mactime);
 
 	/*
 	 * "antenna number"
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 5155b1a..bcae6a0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2940,8 +2940,6 @@ static ssize_t rs_sta_dbgfs_rate_scale_data_read(struct file *file,
 		desc += sprintf(buff+desc,
 				"Bit Rate= %d Mb/s\n",
 				iwl_rates[lq_sta->last_txrate_idx].ieee >> 1);
-	desc += sprintf(buff+desc, "Noise Level= %d dBm\n",
-			priv->last_rx_noise);
 
 	ret = simple_read_from_buffer(user_buf, count, ppos, buff, desc);
 	return ret;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 07d865f..bff182f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1167,8 +1167,6 @@ struct iwl_priv {
 
 	unsigned long status;
 
-	int last_rx_noise;	/* From beacon statistics */
-
 	/* counts mgmt, ctl, and data packets */
 	struct traffic_stats tx_stats;
 	struct traffic_stats rx_stats;
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 3a43138..1dff14a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -259,6 +259,7 @@ static void iwl_rx_calc_noise(struct iwl_priv *priv)
 		le32_to_cpu(rx_info->beacon_silence_rssi_b) & IN_BAND_FILTER;
 	int bcn_silence_c =
 		le32_to_cpu(rx_info->beacon_silence_rssi_c) & IN_BAND_FILTER;
+	int last_rx_noise;
 
 	if (bcn_silence_a) {
 		total_silence += bcn_silence_a;
@@ -275,13 +276,13 @@ static void iwl_rx_calc_noise(struct iwl_priv *priv)
 
 	/* Average among active antennas */
 	if (num_active_rx)
-		priv->last_rx_noise = (total_silence / num_active_rx) - 107;
+		last_rx_noise = (total_silence / num_active_rx) - 107;
 	else
-		priv->last_rx_noise = IWL_NOISE_MEAS_NOT_AVAILABLE;
+		last_rx_noise = IWL_NOISE_MEAS_NOT_AVAILABLE;
 
 	IWL_DEBUG_CALIB(priv, "inband silence a %u, b %u, c %u, dBm %d\n",
 			bcn_silence_a, bcn_silence_b, bcn_silence_c,
-			priv->last_rx_noise);
+			last_rx_noise);
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-- 
1.6.3.3

