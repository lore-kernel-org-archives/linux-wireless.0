Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:63020 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755589AbXG0J2s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 05:28:48 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Cahill@vger.kernel.org, Ben M <ben.m.cahill@intel.com>
Subject: [PATCH 02/17] iwlwifi: Calculate and report noise level while associated
Date: Fri, 27 Jul 2007 17:26:26 +0800
Message-Id: <11855284053896-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11855284032407-git-send-email-yi.zhu@intel.com>
References: <11855284012123-git-send-email-yi.zhu@intel.com>
 <11855284032407-git-send-email-yi.zhu@intel.com>
To: ipwpatch@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch fixed the "Noise level" info from iwconfig disappeared
after association bug.

Signed-off-by: Cahill, Ben M <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-4965.c |   90 +++++++++++++++++++++++++++------------
 drivers/net/wireless/iwl-4965.h |    2 +-
 drivers/net/wireless/iwl-base.c |    2 +-
 drivers/net/wireless/iwl-priv.h |    6 +--
 4 files changed, 67 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/iwl-4965.c b/drivers/net/wireless/iwl-4965.c
index caefb2c..9991956 100644
--- a/drivers/net/wireless/iwl-4965.c
+++ b/drivers/net/wireless/iwl-4965.c
@@ -3459,6 +3459,43 @@ static int iwl4965_is_temp_calib_needed(struct iwl_priv *priv)
 	return 1;
 }
 
+/* Calculate noise level, based on measurements during network silence just
+ *   before arriving beacon.  This measurement can be done only if we know
+ *   exactly when to expect beacons, therefore only when we're associated. */
+static void iwl4965_rx_calc_noise(struct iwl_priv *priv)
+{
+	struct statistics_rx_non_phy *rx_info
+				= &(priv->statistics.rx.general);
+	int num_active_rx = 0;
+	int total_silence = 0;
+	int bcn_silence_a = rx_info->beacon_silence_rssi_a & IN_BAND_FILTER;
+	int bcn_silence_b = rx_info->beacon_silence_rssi_b & IN_BAND_FILTER;
+	int bcn_silence_c = rx_info->beacon_silence_rssi_c & IN_BAND_FILTER;
+
+	if (bcn_silence_a) {
+		total_silence += bcn_silence_a;
+		num_active_rx++;
+	}
+	if (bcn_silence_b) {
+		total_silence += bcn_silence_b;
+		num_active_rx++;
+	}
+	if (bcn_silence_c) {
+		total_silence += bcn_silence_c;
+		num_active_rx++;
+	}
+
+	/* Average among active antennas */
+	if (num_active_rx)
+		priv->last_rx_noise = (total_silence / num_active_rx) - 107;
+	else
+		priv->last_rx_noise = -127;
+
+	IWL_DEBUG_CALIB("inband silence a %u, b %u, c %u, dBm %d\n",
+			bcn_silence_a, bcn_silence_b, bcn_silence_c,
+			priv->last_rx_noise);
+}
+
 void iwl_hw_rx_statistics(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
@@ -3485,11 +3522,14 @@ void iwl_hw_rx_statistics(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	mod_timer(&priv->statistics_periodic, jiffies +
 		  msecs_to_jiffies(REG_RECALIB_PERIOD * 1000));
 
-#ifdef CONFIG_IWLWIFI_SENSITIVITY
 	if (unlikely(!(priv->status & STATUS_SCANNING)) &&
-	    (pkt->hdr.cmd == STATISTICS_NOTIFICATION))
+	    (pkt->hdr.cmd == STATISTICS_NOTIFICATION)) {
+		iwl4965_rx_calc_noise(priv);
+#ifdef CONFIG_IWLWIFI_SENSITIVITY
 		queue_work(priv->workqueue, &priv->sensitivity_work);
 #endif
+	}
+
 	/* If the hardware hasn't reported a change in
 	 * temperature then don't bother computing a
 	 * calibrated temperature value */
@@ -3828,46 +3868,42 @@ static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 	/* Find max signal strength (dBm) among 3 antenna/receiver chains */
 	stats.ssi = iwl4965_calc_rssi(rx_start);
 
-	IWL_DEBUG_RX("Rssi %d, TSF %llu\n", stats.ssi,
-			le64_to_cpu(rx_start->timestamp));
-
-	/* Sensitivity algo, if used (only while associated, not scanning),
-	 * calculates signal-to-noise ratio in dB.  Use this if available,
-	 * else calculate signal quality using only the signal strength. */
-	if (priv->last_rx_snr && iwl_is_associated(priv) &&
-			!(priv->status & STATUS_SCANNING)) {
-		/* TODO:  Find better noise level reference, use
-		 *        in iwl_calc_sig_qual() */
-		stats.noise = stats.ssi - priv->last_rx_snr;
-		stats.signal = iwl_calc_sig_qual(stats.ssi, 0);
+	/* Meaningful noise values are available only from beacon statistics,
+	 *   which are gathered only when associated, and indicate noise
+	 *   only for the associated network channel ...
+	 * Ignore these noise values while scanning (other channels) */
+	if (iwl_is_associated(priv) && !(priv->status & STATUS_SCANNING)) {
+		stats.noise = priv->last_rx_noise;
+		stats.signal = iwl_calc_sig_qual(stats.ssi, stats.noise);
 	} else {
+		stats.noise = -127;
 		stats.signal = iwl_calc_sig_qual(stats.ssi, 0);
+	}
 
-		/* Reset noise values if not associated or snr not available. */
-		/* Set default noise value to -127 ... this works better than
-		 *   0 when averaging frames with/without noise info;
-		 *   measured dBm values are always negative ... using a
-		 *   negative value as the default keeps all averages
-		 *   within an s8's (used in some apps) range of negative
-		 *   values. */
-		priv->last_rx_snr = 0;
+	/* Reset beacon noise level if not associated.
+	 * Use default noise value of -127 ... this works better than
+	 *   0 when averaging frames with/without noise info;
+	 *   measured dBm values are always negative ... using a
+	 *   negative value as the default keeps all averages within
+	 *   an s8's (used in some apps) range of negative values. */
+	if (!iwl_is_associated(priv))
 		priv->last_rx_noise = -127;
-		stats.noise = -127;
-	}
-	IWL_DEBUG_STATS("Rssi %d noise %d qual %d snr db %d\n", stats.ssi,
-			stats.noise, stats.signal, priv->last_rx_snr);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	/* TODO:  Parts of iwl_report_frame are broken for 4965 */
 	if (iwl_debug_level & (IWL_DL_RX))
 		/* Set "1" to report good data frames in groups of 100 */
 		iwl_report_frame(priv, pkt, header, 1);
+
+	if (iwl_debug_level & (IWL_DL_RX | IWL_DL_STATS))
+	IWL_DEBUG_RX("Rssi %d, noise %d, qual %d, TSF %lu\n",
+		stats.ssi, stats.noise, stats.signal,
+		 (long unsigned int)le64_to_cpu(rx_start->timestamp));
 #endif
 
 	network_packet = iwl_is_network_packet(priv, header);
 	if (network_packet) {
 		priv->last_rx_rssi = stats.ssi;
-		priv->last_rx_noise = stats.noise;
 		priv->last_beacon_time =  priv->ucode_beacon_time;
 		priv->last_tsf = le64_to_cpu(rx_start->timestamp);
 	}
diff --git a/drivers/net/wireless/iwl-4965.h b/drivers/net/wireless/iwl-4965.h
index a2452e9..816df54 100644
--- a/drivers/net/wireless/iwl-4965.h
+++ b/drivers/net/wireless/iwl-4965.h
@@ -197,7 +197,6 @@ struct iwl_lq_mngr {
 /* Sensitivity and chain noise calibration */
 #define INITIALIZATION_VALUE		0xFFFF
 #define CAL_NUM_OF_BEACONS		20
-#define IN_BAND_FILTER			0xFF
 #define MAXIMUM_ALLOWED_PATHLOSS	15
 
 /* Param table within SENSITIVITY_CMD */
@@ -257,6 +256,7 @@ struct iwl_lq_mngr {
 #define CHAIN_C             2
 #define CHAIN_NOISE_DELTA_GAIN_INIT_VAL 4
 #define ALL_BAND_FILTER			0xFF00
+#define IN_BAND_FILTER			0xFF
 #define MIN_AVERAGE_NOISE_MAX_VALUE	0xFFFFFFFF
 
 enum iwl_false_alarm_state {
diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index 8671891..7f8f2ac 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -3655,7 +3655,7 @@ static void iwl_rx_reply_tx(struct iwl_priv *priv,
 		__le16 *qc = ieee80211_get_qos_ctrl(hdr);
 
 		if(qc == NULL) {
-			IWL_ERROR("BUG_ON qc is null!!!!");
+			IWL_ERROR("BUG_ON qc is null!!!!\n");
 			return;
 		}
 
diff --git a/drivers/net/wireless/iwl-priv.h b/drivers/net/wireless/iwl-priv.h
index 0a0f4bc..9de898d 100644
--- a/drivers/net/wireless/iwl-priv.h
+++ b/drivers/net/wireless/iwl-priv.h
@@ -182,10 +182,8 @@ struct iwl_priv {
 	u32 status;
 	u32 config;
 
-	int quality;
-	int last_rx_rssi;
-	int last_rx_noise;
-	int last_rx_snr;
+	int last_rx_rssi;	/* From Rx packet statisitics */
+	int last_rx_noise;	/* From beacon statistics */
 
 	struct iwl_power_mgr power_data;
 
-- 
1.5.2
