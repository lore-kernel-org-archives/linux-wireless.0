Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41936 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848AbZLWMVx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 07:21:53 -0500
Message-Id: <20091223121416.345689520@sipsolutions.net>
Date: Wed, 23 Dec 2009 13:12:04 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2.6.33 2/3] wireless: remove remaining qual code
References: <20091223121202.581948600@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes the remaining users of the rx status
'qual' field and the field itself.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/ath/ath5k/base.c       |   11 --
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   10 --
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    1 
 drivers/net/wireless/iwlwifi/iwl-rx.c       |   48 ---------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   41 --------
 drivers/net/wireless/libertas_tf/main.c     |    1 
 drivers/net/wireless/zd1211rw/zd_chip.c     |  140 ----------------------------
 drivers/net/wireless/zd1211rw/zd_chip.h     |    3 
 drivers/net/wireless/zd1211rw/zd_mac.c      |    3 
 include/net/mac80211.h                      |    2 
 10 files changed, 4 insertions(+), 256 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath/ath5k/base.c	2009-12-23 10:03:47.000000000 +0100
+++ wireless-testing/drivers/net/wireless/ath/ath5k/base.c	2009-12-23 10:32:26.000000000 +0100
@@ -1903,17 +1903,6 @@ accept:
 		rxs->noise = sc->ah->ah_noise_floor;
 		rxs->signal = rxs->noise + rs.rs_rssi;
 
-		/* An rssi of 35 indicates you should be able use
-		 * 54 Mbps reliably. A more elaborate scheme can be used
-		 * here but it requires a map of SNR/throughput for each
-		 * possible mode used */
-		rxs->qual = rs.rs_rssi * 100 / 35;
-
-		/* rssi can be more than 35 though, anything above that
-		 * should be considered at 100% */
-		if (rxs->qual > 100)
-			rxs->qual = 100;
-
 		rxs->antenna = rs.rs_antenna;
 		rxs->rate_idx = ath5k_hw_to_driver_rix(sc, rs.rs_rate);
 		rxs->flag |= ath5k_rx_decrypted(sc, ds, skb, &rs);
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-3945.c	2009-12-23 10:10:23.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-3945.c	2009-12-23 10:32:26.000000000 +0100
@@ -681,19 +681,13 @@ static void iwl3945_rx_reply_rx(struct i
 		snr = rx_stats_sig_avg / rx_stats_noise_diff;
 		rx_status.noise = rx_status.signal -
 					iwl3945_calc_db_from_ratio(snr);
-		rx_status.qual = iwl3945_calc_sig_qual(rx_status.signal,
-							 rx_status.noise);
-
-	/* If noise info not available, calculate signal quality indicator (%)
-	 *   using just the dBm signal level. */
 	} else {
 		rx_status.noise = priv->last_rx_noise;
-		rx_status.qual = iwl3945_calc_sig_qual(rx_status.signal, 0);
 	}
 
 
-	IWL_DEBUG_STATS(priv, "Rssi %d noise %d qual %d sig_avg %d noise_diff %d\n",
-			rx_status.signal, rx_status.noise, rx_status.qual,
+	IWL_DEBUG_STATS(priv, "Rssi %d noise %d sig_avg %d noise_diff %d\n",
+			rx_status.signal, rx_status.noise,
 			rx_stats_sig_avg, rx_stats_noise_diff);
 
 	header = (struct ieee80211_hdr *)IWL_RX_DATA(pkt);
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-rx.c	2009-12-23 10:10:24.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-rx.c	2009-12-23 10:32:26.000000000 +0100
@@ -650,47 +650,6 @@ void iwl_reply_statistics(struct iwl_pri
 }
 EXPORT_SYMBOL(iwl_reply_statistics);
 
-#define PERFECT_RSSI (-20) /* dBm */
-#define WORST_RSSI (-95)   /* dBm */
-#define RSSI_RANGE (PERFECT_RSSI - WORST_RSSI)
-
-/* Calculate an indication of rx signal quality (a percentage, not dBm!).
- * See http://www.ces.clemson.edu/linux/signal_quality.shtml for info
- *   about formulas used below. */
-static int iwl_calc_sig_qual(int rssi_dbm, int noise_dbm)
-{
-	int sig_qual;
-	int degradation = PERFECT_RSSI - rssi_dbm;
-
-	/* If we get a noise measurement, use signal-to-noise ratio (SNR)
-	 * as indicator; formula is (signal dbm - noise dbm).
-	 * SNR at or above 40 is a great signal (100%).
-	 * Below that, scale to fit SNR of 0 - 40 dB within 0 - 100% indicator.
-	 * Weakest usable signal is usually 10 - 15 dB SNR. */
-	if (noise_dbm) {
-		if (rssi_dbm - noise_dbm >= 40)
-			return 100;
-		else if (rssi_dbm < noise_dbm)
-			return 0;
-		sig_qual = ((rssi_dbm - noise_dbm) * 5) / 2;
-
-	/* Else use just the signal level.
-	 * This formula is a least squares fit of data points collected and
-	 *   compared with a reference system that had a percentage (%) display
-	 *   for signal quality. */
-	} else
-		sig_qual = (100 * (RSSI_RANGE * RSSI_RANGE) - degradation *
-			    (15 * RSSI_RANGE + 62 * degradation)) /
-			   (RSSI_RANGE * RSSI_RANGE);
-
-	if (sig_qual > 100)
-		sig_qual = 100;
-	else if (sig_qual < 1)
-		sig_qual = 0;
-
-	return sig_qual;
-}
-
 /* Calc max signal level (dBm) among 3 possible receivers */
 static inline int iwl_calc_rssi(struct iwl_priv *priv,
 				struct iwl_rx_phy_res *rx_resp)
@@ -1101,11 +1060,8 @@ void iwl_rx_reply_rx(struct iwl_priv *pr
 	if (iwl_is_associated(priv) &&
 	    !test_bit(STATUS_SCANNING, &priv->status)) {
 		rx_status.noise = priv->last_rx_noise;
-		rx_status.qual = iwl_calc_sig_qual(rx_status.signal,
-							 rx_status.noise);
 	} else {
 		rx_status.noise = IWL_NOISE_MEAS_NOT_AVAILABLE;
-		rx_status.qual = iwl_calc_sig_qual(rx_status.signal, 0);
 	}
 
 	/* Reset beacon noise level if not associated. */
@@ -1118,8 +1074,8 @@ void iwl_rx_reply_rx(struct iwl_priv *pr
 		iwl_dbg_report_frame(priv, phy_res, len, header, 1);
 #endif
 	iwl_dbg_log_rx_data_frame(priv, len, header);
-	IWL_DEBUG_STATS_LIMIT(priv, "Rssi %d, noise %d, qual %d, TSF %llu\n",
-		rx_status.signal, rx_status.noise, rx_status.qual,
+	IWL_DEBUG_STATS_LIMIT(priv, "Rssi %d, noise %d, TSF %llu\n",
+		rx_status.signal, rx_status.noise,
 		(unsigned long long)rx_status.mactime);
 
 	/*
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2009-12-23 10:10:24.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl3945-base.c	2009-12-23 10:32:26.000000000 +0100
@@ -1299,47 +1299,6 @@ int iwl3945_calc_db_from_ratio(int sig_r
 	return (int)ratio2dB[sig_ratio];
 }
 
-#define PERFECT_RSSI (-20) /* dBm */
-#define WORST_RSSI (-95)   /* dBm */
-#define RSSI_RANGE (PERFECT_RSSI - WORST_RSSI)
-
-/* Calculate an indication of rx signal quality (a percentage, not dBm!).
- * See http://www.ces.clemson.edu/linux/signal_quality.shtml for info
- *   about formulas used below. */
-int iwl3945_calc_sig_qual(int rssi_dbm, int noise_dbm)
-{
-	int sig_qual;
-	int degradation = PERFECT_RSSI - rssi_dbm;
-
-	/* If we get a noise measurement, use signal-to-noise ratio (SNR)
-	 * as indicator; formula is (signal dbm - noise dbm).
-	 * SNR at or above 40 is a great signal (100%).
-	 * Below that, scale to fit SNR of 0 - 40 dB within 0 - 100% indicator.
-	 * Weakest usable signal is usually 10 - 15 dB SNR. */
-	if (noise_dbm) {
-		if (rssi_dbm - noise_dbm >= 40)
-			return 100;
-		else if (rssi_dbm < noise_dbm)
-			return 0;
-		sig_qual = ((rssi_dbm - noise_dbm) * 5) / 2;
-
-	/* Else use just the signal level.
-	 * This formula is a least squares fit of data points collected and
-	 *   compared with a reference system that had a percentage (%) display
-	 *   for signal quality. */
-	} else
-		sig_qual = (100 * (RSSI_RANGE * RSSI_RANGE) - degradation *
-			    (15 * RSSI_RANGE + 62 * degradation)) /
-			   (RSSI_RANGE * RSSI_RANGE);
-
-	if (sig_qual > 100)
-		sig_qual = 100;
-	else if (sig_qual < 1)
-		sig_qual = 0;
-
-	return sig_qual;
-}
-
 /**
  * iwl3945_rx_handle - Main entry function for receiving responses from uCode
  *
--- wireless-testing.orig/drivers/net/wireless/libertas_tf/main.c	2009-12-23 10:03:47.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas_tf/main.c	2009-12-23 10:32:26.000000000 +0100
@@ -495,7 +495,6 @@ int lbtf_rx(struct lbtf_private *priv, s
 	stats.band = IEEE80211_BAND_2GHZ;
 	stats.signal = prxpd->snr;
 	stats.noise = prxpd->nf;
-	stats.qual = prxpd->snr - prxpd->nf;
 	/* Marvell rate index has a hole at value 4 */
 	if (prxpd->rx_rate > 4)
 		--prxpd->rx_rate;
--- wireless-testing.orig/drivers/net/wireless/zd1211rw/zd_chip.c	2009-12-23 10:03:47.000000000 +0100
+++ wireless-testing/drivers/net/wireless/zd1211rw/zd_chip.c	2009-12-23 10:32:26.000000000 +0100
@@ -1325,151 +1325,11 @@ int zd_chip_set_basic_rates(struct zd_ch
 	return r;
 }
 
-static int ofdm_qual_db(u8 status_quality, u8 zd_rate, unsigned int size)
-{
-	static const u16 constants[] = {
-		715, 655, 585, 540, 470, 410, 360, 315,
-		270, 235, 205, 175, 150, 125, 105,  85,
-		 65,  50,  40,  25,  15
-	};
-
-	int i;
-	u32 x;
-
-	/* It seems that their quality parameter is somehow per signal
-	 * and is now transferred per bit.
-	 */
-	switch (zd_rate) {
-	case ZD_OFDM_RATE_6M:
-	case ZD_OFDM_RATE_12M:
-	case ZD_OFDM_RATE_24M:
-		size *= 2;
-		break;
-	case ZD_OFDM_RATE_9M:
-	case ZD_OFDM_RATE_18M:
-	case ZD_OFDM_RATE_36M:
-	case ZD_OFDM_RATE_54M:
-		size *= 4;
-		size /= 3;
-		break;
-	case ZD_OFDM_RATE_48M:
-		size *= 3;
-		size /= 2;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	x = (10000 * status_quality)/size;
-	for (i = 0; i < ARRAY_SIZE(constants); i++) {
-		if (x > constants[i])
-			break;
-	}
-
-	switch (zd_rate) {
-	case ZD_OFDM_RATE_6M:
-	case ZD_OFDM_RATE_9M:
-		i += 3;
-		break;
-	case ZD_OFDM_RATE_12M:
-	case ZD_OFDM_RATE_18M:
-		i += 5;
-		break;
-	case ZD_OFDM_RATE_24M:
-	case ZD_OFDM_RATE_36M:
-		i += 9;
-		break;
-	case ZD_OFDM_RATE_48M:
-	case ZD_OFDM_RATE_54M:
-		i += 15;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return i;
-}
-
-static int ofdm_qual_percent(u8 status_quality, u8 zd_rate, unsigned int size)
-{
-	int r;
-
-	r = ofdm_qual_db(status_quality, zd_rate, size);
-	ZD_ASSERT(r >= 0);
-	if (r < 0)
-		r = 0;
-
-	r = (r * 100)/29;
-	return r <= 100 ? r : 100;
-}
-
-static unsigned int log10times100(unsigned int x)
-{
-	static const u8 log10[] = {
-		  0,
-		  0,   30,   47,   60,   69,   77,   84,   90,   95,  100,
-		104,  107,  111,  114,  117,  120,  123,  125,  127,  130,
-		132,  134,  136,  138,  139,  141,  143,  144,  146,  147,
-		149,  150,  151,  153,  154,  155,  156,  157,  159,  160,
-		161,  162,  163,  164,  165,  166,  167,  168,  169,  169,
-		170,  171,  172,  173,  174,  174,  175,  176,  177,  177,
-		178,  179,  179,  180,  181,  181,  182,  183,  183,  184,
-		185,  185,  186,  186,  187,  188,  188,  189,  189,  190,
-		190,  191,  191,  192,  192,  193,  193,  194,  194,  195,
-		195,  196,  196,  197,  197,  198,  198,  199,  199,  200,
-		200,  200,  201,  201,  202,  202,  202,  203,  203,  204,
-		204,  204,  205,  205,  206,  206,  206,  207,  207,  207,
-		208,  208,  208,  209,  209,  210,  210,  210,  211,  211,
-		211,  212,  212,  212,  213,  213,  213,  213,  214,  214,
-		214,  215,  215,  215,  216,  216,  216,  217,  217,  217,
-		217,  218,  218,  218,  219,  219,  219,  219,  220,  220,
-		220,  220,  221,  221,  221,  222,  222,  222,  222,  223,
-		223,  223,  223,  224,  224,  224,  224,
-	};
-
-	return x < ARRAY_SIZE(log10) ? log10[x] : 225;
-}
-
-enum {
-	MAX_CCK_EVM_DB = 45,
-};
-
-static int cck_evm_db(u8 status_quality)
-{
-	return (20 * log10times100(status_quality)) / 100;
-}
-
-static int cck_snr_db(u8 status_quality)
-{
-	int r = MAX_CCK_EVM_DB - cck_evm_db(status_quality);
-	ZD_ASSERT(r >= 0);
-	return r;
-}
-
-static int cck_qual_percent(u8 status_quality)
-{
-	int r;
-
-	r = cck_snr_db(status_quality);
-	r = (100*r)/17;
-	return r <= 100 ? r : 100;
-}
-
 static inline u8 zd_rate_from_ofdm_plcp_header(const void *rx_frame)
 {
 	return ZD_OFDM | zd_ofdm_plcp_header_rate(rx_frame);
 }
 
-u8 zd_rx_qual_percent(const void *rx_frame, unsigned int size,
-	              const struct rx_status *status)
-{
-	return (status->frame_status&ZD_RX_OFDM) ?
-		ofdm_qual_percent(status->signal_quality_ofdm,
-				  zd_rate_from_ofdm_plcp_header(rx_frame),
-			          size) :
-		cck_qual_percent(status->signal_quality_cck);
-}
-
 /**
  * zd_rx_rate - report zd-rate
  * @rx_frame - received frame
--- wireless-testing.orig/drivers/net/wireless/zd1211rw/zd_chip.h	2009-12-23 10:03:47.000000000 +0100
+++ wireless-testing/drivers/net/wireless/zd1211rw/zd_chip.h	2009-12-23 10:32:26.000000000 +0100
@@ -929,9 +929,6 @@ static inline int zd_get_beacon_interval
 
 struct rx_status;
 
-u8 zd_rx_qual_percent(const void *rx_frame, unsigned int size,
-	               const struct rx_status *status);
-
 u8 zd_rx_rate(const void *rx_frame, const struct rx_status *status);
 
 struct zd_mc_hash {
--- wireless-testing.orig/drivers/net/wireless/zd1211rw/zd_mac.c	2009-12-23 10:10:26.000000000 +0100
+++ wireless-testing/drivers/net/wireless/zd1211rw/zd_mac.c	2009-12-23 10:32:26.000000000 +0100
@@ -828,9 +828,6 @@ int zd_mac_rx(struct ieee80211_hw *hw, c
 	stats.freq = zd_channels[_zd_chip_get_channel(&mac->chip) - 1].center_freq;
 	stats.band = IEEE80211_BAND_2GHZ;
 	stats.signal = status->signal_strength;
-	stats.qual = zd_rx_qual_percent(buffer,
-		                          length - sizeof(struct rx_status),
-		                          status);
 
 	rate = zd_rx_rate(buffer, status);
 
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-3945.h	2009-12-23 10:10:23.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-3945.h	2009-12-23 10:32:26.000000000 +0100
@@ -222,7 +222,6 @@ struct iwl3945_ibss_seq {
  *
  *****************************************************************************/
 extern int iwl3945_calc_db_from_ratio(int sig_ratio);
-extern int iwl3945_calc_sig_qual(int rssi_dbm, int noise_dbm);
 extern void iwl3945_rx_replenish(void *data);
 extern void iwl3945_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
 extern unsigned int iwl3945_fill_beacon_frame(struct iwl_priv *priv,
--- wireless-testing.orig/include/net/mac80211.h	2009-12-23 10:30:38.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-12-23 10:32:26.000000000 +0100
@@ -547,7 +547,6 @@ enum mac80211_rx_flags {
  *	unspecified depending on the hardware capabilities flags
  *	@IEEE80211_HW_SIGNAL_*
  * @noise: noise when receiving this frame, in dBm.
- * @qual: overall signal quality indication, in percent (0-100).
  * @antenna: antenna used
  * @rate_idx: index of data rate into band's supported rates or MCS index if
  *	HT rates are use (RX_FLAG_HT)
@@ -559,7 +558,6 @@ struct ieee80211_rx_status {
 	int freq;
 	int signal;
 	int noise;
-	int __deprecated qual;
 	int antenna;
 	int rate_idx;
 	int flag;


