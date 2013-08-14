Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:54432 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759357Ab3HNDpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 23:45:14 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 06/14] ath9k: Reorder some functions
Date: Wed, 14 Aug 2013 09:11:14 +0530
Message-Id: <1376451682-25862-6-git-send-email-sujith@msujith.org> (sfid-20130814_054522_628999_F5941D00)
In-Reply-To: <1376451682-25862-1-git-send-email-sujith@msujith.org>
References: <1376451682-25862-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c | 220 +++++++++++++++++-----------------
 1 file changed, 110 insertions(+), 110 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 9fabd5f..51e7d16 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -929,6 +929,116 @@ static void ath9k_process_tsf(struct ath_rx_status *rs,
 		rxs->mactime += 0x100000000ULL;
 }
 
+#ifdef CONFIG_ATH9K_DEBUGFS
+static s8 fix_rssi_inv_only(u8 rssi_val)
+{
+	if (rssi_val == 128)
+		rssi_val = 0;
+	return (s8) rssi_val;
+}
+#endif
+
+/* returns 1 if this was a spectral frame, even if not handled. */
+static int ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
+			   struct ath_rx_status *rs, u64 tsf)
+{
+#ifdef CONFIG_ATH9K_DEBUGFS
+	struct ath_hw *ah = sc->sc_ah;
+	u8 bins[SPECTRAL_HT20_NUM_BINS];
+	u8 *vdata = (u8 *)hdr;
+	struct fft_sample_ht20 fft_sample;
+	struct ath_radar_info *radar_info;
+	struct ath_ht20_mag_info *mag_info;
+	int len = rs->rs_datalen;
+	int dc_pos;
+	u16 length, max_magnitude;
+
+	/* AR9280 and before report via ATH9K_PHYERR_RADAR, AR93xx and newer
+	 * via ATH9K_PHYERR_SPECTRAL. Haven't seen ATH9K_PHYERR_FALSE_RADAR_EXT
+	 * yet, but this is supposed to be possible as well.
+	 */
+	if (rs->rs_phyerr != ATH9K_PHYERR_RADAR &&
+	    rs->rs_phyerr != ATH9K_PHYERR_FALSE_RADAR_EXT &&
+	    rs->rs_phyerr != ATH9K_PHYERR_SPECTRAL)
+		return 0;
+
+	/* check if spectral scan bit is set. This does not have to be checked
+	 * if received through a SPECTRAL phy error, but shouldn't hurt.
+	 */
+	radar_info = ((struct ath_radar_info *)&vdata[len]) - 1;
+	if (!(radar_info->pulse_bw_info & SPECTRAL_SCAN_BITMASK))
+		return 0;
+
+	/* Variation in the data length is possible and will be fixed later.
+	 * Note that we only support HT20 for now.
+	 *
+	 * TODO: add HT20_40 support as well.
+	 */
+	if ((len > SPECTRAL_HT20_TOTAL_DATA_LEN + 2) ||
+	    (len < SPECTRAL_HT20_TOTAL_DATA_LEN - 1))
+		return 1;
+
+	fft_sample.tlv.type = ATH_FFT_SAMPLE_HT20;
+	length = sizeof(fft_sample) - sizeof(fft_sample.tlv);
+	fft_sample.tlv.length = __cpu_to_be16(length);
+
+	fft_sample.freq = __cpu_to_be16(ah->curchan->chan->center_freq);
+	fft_sample.rssi = fix_rssi_inv_only(rs->rs_rssi_ctl0);
+	fft_sample.noise = ah->noise;
+
+	switch (len - SPECTRAL_HT20_TOTAL_DATA_LEN) {
+	case 0:
+		/* length correct, nothing to do. */
+		memcpy(bins, vdata, SPECTRAL_HT20_NUM_BINS);
+		break;
+	case -1:
+		/* first byte missing, duplicate it. */
+		memcpy(&bins[1], vdata, SPECTRAL_HT20_NUM_BINS - 1);
+		bins[0] = vdata[0];
+		break;
+	case 2:
+		/* MAC added 2 extra bytes at bin 30 and 32, remove them. */
+		memcpy(bins, vdata, 30);
+		bins[30] = vdata[31];
+		memcpy(&bins[31], &vdata[33], SPECTRAL_HT20_NUM_BINS - 31);
+		break;
+	case 1:
+		/* MAC added 2 extra bytes AND first byte is missing. */
+		bins[0] = vdata[0];
+		memcpy(&bins[0], vdata, 30);
+		bins[31] = vdata[31];
+		memcpy(&bins[32], &vdata[33], SPECTRAL_HT20_NUM_BINS - 32);
+		break;
+	default:
+		return 1;
+	}
+
+	/* DC value (value in the middle) is the blind spot of the spectral
+	 * sample and invalid, interpolate it.
+	 */
+	dc_pos = SPECTRAL_HT20_NUM_BINS / 2;
+	bins[dc_pos] = (bins[dc_pos + 1] + bins[dc_pos - 1]) / 2;
+
+	/* mag data is at the end of the frame, in front of radar_info */
+	mag_info = ((struct ath_ht20_mag_info *)radar_info) - 1;
+
+	/* copy raw bins without scaling them */
+	memcpy(fft_sample.data, bins, SPECTRAL_HT20_NUM_BINS);
+	fft_sample.max_exp = mag_info->max_exp & 0xf;
+
+	max_magnitude = spectral_max_magnitude(mag_info->all_bins);
+	fft_sample.max_magnitude = __cpu_to_be16(max_magnitude);
+	fft_sample.max_index = spectral_max_index(mag_info->all_bins);
+	fft_sample.bitmap_weight = spectral_bitmap_weight(mag_info->all_bins);
+	fft_sample.tsf = __cpu_to_be64(tsf);
+
+	ath_debug_send_fft_sample(sc, &fft_sample.tlv);
+	return 1;
+#else
+	return 0;
+#endif
+}
+
 /*
  * For Decrypt or Demic errors, we only mark packet status here and always push
  * up the frame up to let mac80211 handle the actual error case, be it no
@@ -1052,116 +1162,6 @@ static void ath9k_rx_skb_postprocess(struct ath_common *common,
 		rxs->flag &= ~RX_FLAG_DECRYPTED;
 }
 
-#ifdef CONFIG_ATH9K_DEBUGFS
-static s8 fix_rssi_inv_only(u8 rssi_val)
-{
-	if (rssi_val == 128)
-		rssi_val = 0;
-	return (s8) rssi_val;
-}
-#endif
-
-/* returns 1 if this was a spectral frame, even if not handled. */
-static int ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
-			   struct ath_rx_status *rs, u64 tsf)
-{
-#ifdef CONFIG_ATH9K_DEBUGFS
-	struct ath_hw *ah = sc->sc_ah;
-	u8 bins[SPECTRAL_HT20_NUM_BINS];
-	u8 *vdata = (u8 *)hdr;
-	struct fft_sample_ht20 fft_sample;
-	struct ath_radar_info *radar_info;
-	struct ath_ht20_mag_info *mag_info;
-	int len = rs->rs_datalen;
-	int dc_pos;
-	u16 length, max_magnitude;
-
-	/* AR9280 and before report via ATH9K_PHYERR_RADAR, AR93xx and newer
-	 * via ATH9K_PHYERR_SPECTRAL. Haven't seen ATH9K_PHYERR_FALSE_RADAR_EXT
-	 * yet, but this is supposed to be possible as well.
-	 */
-	if (rs->rs_phyerr != ATH9K_PHYERR_RADAR &&
-	    rs->rs_phyerr != ATH9K_PHYERR_FALSE_RADAR_EXT &&
-	    rs->rs_phyerr != ATH9K_PHYERR_SPECTRAL)
-		return 0;
-
-	/* check if spectral scan bit is set. This does not have to be checked
-	 * if received through a SPECTRAL phy error, but shouldn't hurt.
-	 */
-	radar_info = ((struct ath_radar_info *)&vdata[len]) - 1;
-	if (!(radar_info->pulse_bw_info & SPECTRAL_SCAN_BITMASK))
-		return 0;
-
-	/* Variation in the data length is possible and will be fixed later.
-	 * Note that we only support HT20 for now.
-	 *
-	 * TODO: add HT20_40 support as well.
-	 */
-	if ((len > SPECTRAL_HT20_TOTAL_DATA_LEN + 2) ||
-	    (len < SPECTRAL_HT20_TOTAL_DATA_LEN - 1))
-		return 1;
-
-	fft_sample.tlv.type = ATH_FFT_SAMPLE_HT20;
-	length = sizeof(fft_sample) - sizeof(fft_sample.tlv);
-	fft_sample.tlv.length = __cpu_to_be16(length);
-
-	fft_sample.freq = __cpu_to_be16(ah->curchan->chan->center_freq);
-	fft_sample.rssi = fix_rssi_inv_only(rs->rs_rssi_ctl0);
-	fft_sample.noise = ah->noise;
-
-	switch (len - SPECTRAL_HT20_TOTAL_DATA_LEN) {
-	case 0:
-		/* length correct, nothing to do. */
-		memcpy(bins, vdata, SPECTRAL_HT20_NUM_BINS);
-		break;
-	case -1:
-		/* first byte missing, duplicate it. */
-		memcpy(&bins[1], vdata, SPECTRAL_HT20_NUM_BINS - 1);
-		bins[0] = vdata[0];
-		break;
-	case 2:
-		/* MAC added 2 extra bytes at bin 30 and 32, remove them. */
-		memcpy(bins, vdata, 30);
-		bins[30] = vdata[31];
-		memcpy(&bins[31], &vdata[33], SPECTRAL_HT20_NUM_BINS - 31);
-		break;
-	case 1:
-		/* MAC added 2 extra bytes AND first byte is missing. */
-		bins[0] = vdata[0];
-		memcpy(&bins[0], vdata, 30);
-		bins[31] = vdata[31];
-		memcpy(&bins[32], &vdata[33], SPECTRAL_HT20_NUM_BINS - 32);
-		break;
-	default:
-		return 1;
-	}
-
-	/* DC value (value in the middle) is the blind spot of the spectral
-	 * sample and invalid, interpolate it.
-	 */
-	dc_pos = SPECTRAL_HT20_NUM_BINS / 2;
-	bins[dc_pos] = (bins[dc_pos + 1] + bins[dc_pos - 1]) / 2;
-
-	/* mag data is at the end of the frame, in front of radar_info */
-	mag_info = ((struct ath_ht20_mag_info *)radar_info) - 1;
-
-	/* copy raw bins without scaling them */
-	memcpy(fft_sample.data, bins, SPECTRAL_HT20_NUM_BINS);
-	fft_sample.max_exp = mag_info->max_exp & 0xf;
-
-	max_magnitude = spectral_max_magnitude(mag_info->all_bins);
-	fft_sample.max_magnitude = __cpu_to_be16(max_magnitude);
-	fft_sample.max_index = spectral_max_index(mag_info->all_bins);
-	fft_sample.bitmap_weight = spectral_bitmap_weight(mag_info->all_bins);
-	fft_sample.tsf = __cpu_to_be64(tsf);
-
-	ath_debug_send_fft_sample(sc, &fft_sample.tlv);
-	return 1;
-#else
-	return 0;
-#endif
-}
-
 static void ath9k_apply_ampdu_details(struct ath_softc *sc,
 	struct ath_rx_status *rs, struct ieee80211_rx_status *rxs)
 {
-- 
1.8.3.4

