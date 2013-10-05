Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:58167 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab3JEVQR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Oct 2013 17:16:17 -0400
Received: by mail-ea0-f176.google.com with SMTP id q16so2460817ead.35
        for <linux-wireless@vger.kernel.org>; Sat, 05 Oct 2013 14:16:15 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, mcgrof@qca.qualcomm.com,
	simon.wunderlich@s2003.tu-chemnitz.de
Subject: [PATCH 2/2] ath9k: add HT40 spectral scan capability
Date: Sat,  5 Oct 2013 23:16:09 +0200
Message-Id: <1381007769-11800-3-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20131005_231620_674372_62EE498B)
In-Reply-To: <1381007769-11800-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1381007769-11800-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add spectral scan feature on HT40 channels for ath9k. This patch extends
previous capability added by Simon Wunderlich

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  28 +++++++
 drivers/net/wireless/ath/ath9k/recv.c  | 144 ++++++++++++++++++++++++---------
 2 files changed, 134 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 8878f2d..62d2812 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -879,6 +879,7 @@ static inline u8 spectral_bitmap_weight(u8 *bins)
  */
 enum ath_fft_sample_type {
 	ATH_FFT_SAMPLE_HT20 = 1,
+	ATH_FFT_SAMPLE_HT20_40,
 };
 
 struct fft_sample_tlv {
@@ -905,6 +906,33 @@ struct fft_sample_ht20 {
 	u8 data[SPECTRAL_HT20_NUM_BINS];
 } __packed;
 
+struct fft_sample_ht20_40 {
+	struct fft_sample_tlv tlv;
+
+	u8 max_exp;
+
+	__be16 freq;
+
+	s8 lower_rssi;
+	s8 upper_rssi;
+
+	__be64 tsf;
+
+	s8 lower_noise;
+	s8 upper_noise;
+
+	__be16 lower_max_magnitude;
+	__be16 upper_max_magnitude;
+
+	u8 lower_max_index;
+	u8 upper_max_index;
+
+	u8 lower_bitmap_weight;
+	u8 upper_bitmap_weight;
+
+	u8 data[SPECTRAL_HT20_40_NUM_BINS];
+} __packed;
+
 void ath9k_tasklet(unsigned long data);
 int ath_cabq_update(struct ath_softc *);
 
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index ab9e3a8..b49fd13 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -972,14 +972,14 @@ static int ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
 {
 #ifdef CONFIG_ATH9K_DEBUGFS
 	struct ath_hw *ah = sc->sc_ah;
-	u8 bins[SPECTRAL_HT20_NUM_BINS];
-	u8 *vdata = (u8 *)hdr;
-	struct fft_sample_ht20 fft_sample;
+	u8 num_bins, *bins, *sample, *vdata = (u8 *)hdr;
+	struct fft_sample_ht20 fft_sample_20;
+	struct fft_sample_ht20_40 fft_sample_40;
 	struct ath_radar_info *radar_info;
-	struct ath_ht20_mag_info *mag_info;
 	int len = rs->rs_datalen;
 	int dc_pos;
-	u16 length, max_magnitude;
+	u16 fft_len, length, freq = ah->curchan->chan->center_freq;
+	enum nl80211_channel_type chan_type;
 
 	/* AR9280 and before report via ATH9K_PHYERR_RADAR, AR93xx and newer
 	 * via ATH9K_PHYERR_SPECTRAL. Haven't seen ATH9K_PHYERR_FALSE_RADAR_EXT
@@ -997,45 +997,44 @@ static int ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
 	if (!(radar_info->pulse_bw_info & SPECTRAL_SCAN_BITMASK))
 		return 0;
 
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
+	chan_type = cfg80211_get_chandef_type(&sc->hw->conf.chandef);
+	if ((chan_type == NL80211_CHAN_HT40MINUS) ||
+	    (chan_type == NL80211_CHAN_HT40PLUS)) {
+		fft_len = SPECTRAL_HT20_40_TOTAL_DATA_LEN;
+		num_bins = SPECTRAL_HT20_40_NUM_BINS;
+		bins = (u8 *) fft_sample_40.data;
+	} else {
+		fft_len = SPECTRAL_HT20_TOTAL_DATA_LEN;
+		num_bins = SPECTRAL_HT20_NUM_BINS;
+		bins = (u8 *) fft_sample_20.data;
+	}
 
-	fft_sample.freq = __cpu_to_be16(ah->curchan->chan->center_freq);
-	fft_sample.rssi = fix_rssi_inv_only(rs->rs_rssi_ctl0);
-	fft_sample.noise = ah->noise;
+	/* Variation in the data length is possible and will be fixed later */
+	if ((len > fft_len + 2) || (len < fft_len - 1))
+		return 1;
 
-	switch (len - SPECTRAL_HT20_TOTAL_DATA_LEN) {
+	switch (len - fft_len) {
 	case 0:
 		/* length correct, nothing to do. */
-		memcpy(bins, vdata, SPECTRAL_HT20_NUM_BINS);
+		memcpy(bins, vdata, num_bins);
 		break;
 	case -1:
 		/* first byte missing, duplicate it. */
-		memcpy(&bins[1], vdata, SPECTRAL_HT20_NUM_BINS - 1);
+		memcpy(&bins[1], vdata, num_bins - 1);
 		bins[0] = vdata[0];
 		break;
 	case 2:
 		/* MAC added 2 extra bytes at bin 30 and 32, remove them. */
 		memcpy(bins, vdata, 30);
 		bins[30] = vdata[31];
-		memcpy(&bins[31], &vdata[33], SPECTRAL_HT20_NUM_BINS - 31);
+		memcpy(&bins[31], &vdata[33], num_bins - 31);
 		break;
 	case 1:
 		/* MAC added 2 extra bytes AND first byte is missing. */
 		bins[0] = vdata[0];
-		memcpy(&bins[0], vdata, 30);
+		memcpy(&bins[1], vdata, 30);
 		bins[31] = vdata[31];
-		memcpy(&bins[32], &vdata[33], SPECTRAL_HT20_NUM_BINS - 32);
+		memcpy(&bins[32], &vdata[33], num_bins - 32);
 		break;
 	default:
 		return 1;
@@ -1044,23 +1043,92 @@ static int ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
 	/* DC value (value in the middle) is the blind spot of the spectral
 	 * sample and invalid, interpolate it.
 	 */
-	dc_pos = SPECTRAL_HT20_NUM_BINS / 2;
+	dc_pos = num_bins / 2;
 	bins[dc_pos] = (bins[dc_pos + 1] + bins[dc_pos - 1]) / 2;
 
-	/* mag data is at the end of the frame, in front of radar_info */
-	mag_info = ((struct ath_ht20_mag_info *)radar_info) - 1;
+	if ((chan_type == NL80211_CHAN_HT40MINUS) ||
+	    (chan_type == NL80211_CHAN_HT40PLUS)) {
+		s8 lower_rssi, upper_rssi;
+		s16 ext_nf;
+		u8 lower_max_index, upper_max_index;
+		u8 lower_bitmap_w, upper_bitmap_w;
+		u16 lower_mag, upper_mag;
+		struct ath9k_hw_cal_data *caldata = ah->caldata;
+		struct ath_ht20_40_mag_info *mag_info;
+
+		if (caldata)
+			ext_nf = ath9k_hw_getchan_noise(ah, ah->curchan,
+					caldata->nfCalHist[3].privNF);
+		else
+			ext_nf = ATH_DEFAULT_NOISE_FLOOR;
+
+		length = sizeof(fft_sample_40) - sizeof(struct fft_sample_tlv);
+		fft_sample_40.tlv.type = ATH_FFT_SAMPLE_HT20_40;
+		fft_sample_40.tlv.length = __cpu_to_be16(length);
+		fft_sample_40.freq = __cpu_to_be16(freq);
 
-	/* copy raw bins without scaling them */
-	memcpy(fft_sample.data, bins, SPECTRAL_HT20_NUM_BINS);
-	fft_sample.max_exp = mag_info->max_exp & 0xf;
+		if (chan_type == NL80211_CHAN_HT40PLUS) {
+			lower_rssi = fix_rssi_inv_only(rs->rs_rssi_ctl0);
+			upper_rssi = fix_rssi_inv_only(rs->rs_rssi_ext0);
+
+			fft_sample_40.lower_noise = ah->noise;
+			fft_sample_40.upper_noise = ext_nf;
+		} else {
+			lower_rssi = fix_rssi_inv_only(rs->rs_rssi_ext0);
+			upper_rssi = fix_rssi_inv_only(rs->rs_rssi_ctl0);
 
-	max_magnitude = spectral_max_magnitude(mag_info->all_bins);
-	fft_sample.max_magnitude = __cpu_to_be16(max_magnitude);
-	fft_sample.max_index = spectral_max_index(mag_info->all_bins);
-	fft_sample.bitmap_weight = spectral_bitmap_weight(mag_info->all_bins);
-	fft_sample.tsf = __cpu_to_be64(tsf);
+			fft_sample_40.lower_noise = ext_nf;
+			fft_sample_40.upper_noise = ah->noise;
+		}
+		fft_sample_40.lower_rssi = lower_rssi;
+		fft_sample_40.upper_rssi = upper_rssi;
+
+		mag_info = ((struct ath_ht20_40_mag_info *)radar_info) - 1;
+		lower_mag = spectral_max_magnitude(mag_info->lower_bins);
+		upper_mag = spectral_max_magnitude(mag_info->upper_bins);
+		fft_sample_40.lower_max_magnitude = __cpu_to_be16(lower_mag);
+		fft_sample_40.upper_max_magnitude = __cpu_to_be16(upper_mag);
+		lower_max_index = spectral_max_index(mag_info->lower_bins);
+		upper_max_index = spectral_max_index(mag_info->upper_bins);
+		fft_sample_40.lower_max_index = lower_max_index;
+		fft_sample_40.upper_max_index = upper_max_index;
+		lower_bitmap_w = spectral_bitmap_weight(mag_info->lower_bins);
+		upper_bitmap_w = spectral_bitmap_weight(mag_info->upper_bins);
+		fft_sample_40.lower_bitmap_weight = lower_bitmap_w;
+		fft_sample_40.upper_bitmap_weight = upper_bitmap_w;
+		fft_sample_40.max_exp = mag_info->max_exp & 0xf;
+
+		fft_sample_40.tsf = __cpu_to_be64(tsf);
+
+		sample = (u8 *) &fft_sample_40;
+	} else {
+		u8 max_index, bitmap_w;
+		u16 magnitude;
+		struct ath_ht20_mag_info *mag_info;
+
+		length = sizeof(fft_sample_20) - sizeof(struct fft_sample_tlv);
+		fft_sample_20.tlv.type = ATH_FFT_SAMPLE_HT20;
+		fft_sample_20.tlv.length = __cpu_to_be16(length);
+		fft_sample_20.freq = __cpu_to_be16(freq);
+
+		fft_sample_20.rssi = fix_rssi_inv_only(rs->rs_rssi_ctl0);
+		fft_sample_20.noise = ah->noise;
+
+		mag_info = ((struct ath_ht20_mag_info *)radar_info) - 1;
+		magnitude = spectral_max_magnitude(mag_info->all_bins);
+		fft_sample_20.max_magnitude = __cpu_to_be16(magnitude);
+		max_index = spectral_max_index(mag_info->all_bins);
+		fft_sample_20.max_index = max_index;
+		bitmap_w = spectral_bitmap_weight(mag_info->all_bins);
+		fft_sample_20.bitmap_weight = bitmap_w;
+		fft_sample_20.max_exp = mag_info->max_exp & 0xf;
+
+		fft_sample_20.tsf = __cpu_to_be64(tsf);
+
+		sample = (u8 *) &fft_sample_20;
+	}
 
-	ath_debug_send_fft_sample(sc, &fft_sample.tlv);
+	ath_debug_send_fft_sample(sc, (struct fft_sample_tlv *) sample);
 	return 1;
 #else
 	return 0;
-- 
1.8.1.2

