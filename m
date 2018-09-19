Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:49960 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731072AbeISQOh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 12:14:37 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 1/5] ath9k: add counters for good and errorneous FFT/spectral frames
Date: Wed, 19 Sep 2018 12:37:07 +0200
Message-Id: <20180919103711.19304-2-sw@simonwunderlich.de> (sfid-20180919_123723_049278_D1FFB309)
In-Reply-To: <20180919103711.19304-1-sw@simonwunderlich.de>
References: <20180919103711.19304-1-sw@simonwunderlich.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is helpful to see whether spectral samples get discarded.

Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 drivers/net/wireless/ath/ath9k/common-debug.c    |  2 ++
 drivers/net/wireless/ath/ath9k/common-debug.h    |  4 ++++
 drivers/net/wireless/ath/ath9k/common-spectral.c | 15 +++++++++++++--
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-debug.c b/drivers/net/wireless/ath/ath9k/common-debug.c
index 239429f10378..53ca4b063eb9 100644
--- a/drivers/net/wireless/ath/ath9k/common-debug.c
+++ b/drivers/net/wireless/ath/ath9k/common-debug.c
@@ -144,6 +144,8 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 	RXS_ERR("BEACONS", rx_beacons);
 	RXS_ERR("FRAGS", rx_frags);
 	RXS_ERR("SPECTRAL", rx_spectral);
+	RXS_ERR("SPECTRAL SMPL GOOD", rx_spectral_sample_good);
+	RXS_ERR("SPECTRAL SMPL ERR", rx_spectral_sample_err);
 
 	RXS_ERR("CRC ERR", crc_err);
 	RXS_ERR("DECRYPT CRC ERR", decrypt_crc_err);
diff --git a/drivers/net/wireless/ath/ath9k/common-debug.h b/drivers/net/wireless/ath/ath9k/common-debug.h
index 3376990d3a24..2938b5b96b07 100644
--- a/drivers/net/wireless/ath/ath9k/common-debug.h
+++ b/drivers/net/wireless/ath/ath9k/common-debug.h
@@ -39,6 +39,8 @@
  * @rx_beacons:  No. of beacons received.
  * @rx_frags:  No. of rx-fragements received.
  * @rx_spectral: No of spectral packets received.
+ * @rx_spectral_sample_good: No. of good spectral samples
+ * @rx_spectral_sample_err: No. of good spectral samples
  */
 struct ath_rx_stats {
 	u32 rx_pkts_all;
@@ -58,6 +60,8 @@ struct ath_rx_stats {
 	u32 rx_beacons;
 	u32 rx_frags;
 	u32 rx_spectral;
+	u32 rx_spectral_sample_good;
+	u32 rx_spectral_sample_err;
 };
 
 #ifdef CONFIG_ATH9K_COMMON_DEBUG
diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.c b/drivers/net/wireless/ath/ath9k/common-spectral.c
index 440e16e641e4..0c5559009a28 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.c
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.c
@@ -501,6 +501,7 @@ int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv, struct ieee80211_h
 	u8 sample_buf[SPECTRAL_SAMPLE_MAX_LEN] = {0};
 	struct ath_hw *ah = spec_priv->ah;
 	struct ath_common *common = ath9k_hw_common(spec_priv->ah);
+	struct ath_softc *sc = (struct ath_softc *)common->priv;
 	u8 num_bins, *vdata = (u8 *)hdr;
 	struct ath_radar_info *radar_info;
 	int len = rs->rs_datalen;
@@ -649,8 +650,13 @@ int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv, struct ieee80211_h
 						       sample_buf, sample_len,
 						       sample_bytes);
 
-				fft_handler(rs, spec_priv, sample_buf,
-					    tsf, freq, chan_type);
+				ret = fft_handler(rs, spec_priv, sample_buf,
+						  tsf, freq, chan_type);
+
+				if (ret == 0)
+					RX_STAT_INC(rx_spectral_sample_good);
+				else
+					RX_STAT_INC(rx_spectral_sample_err);
 
 				memset(sample_buf, 0, SPECTRAL_SAMPLE_MAX_LEN);
 
@@ -665,6 +671,11 @@ int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv, struct ieee80211_h
 				ret = fft_handler(rs, spec_priv, sample_start,
 						  tsf, freq, chan_type);
 
+				if (ret == 0)
+					RX_STAT_INC(rx_spectral_sample_good);
+				else
+					RX_STAT_INC(rx_spectral_sample_err);
+
 				/* Mix the received bins to the /dev/random
 				 * pool
 				 */
-- 
2.11.0
