Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:34109 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbbD2XwC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2015 19:52:02 -0400
Received: by iget9 with SMTP id t9so951155ige.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2015 16:52:01 -0700 (PDT)
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	adrian.chadd@gmail.com, Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 03/11] ath9k: Move processing of FFT frames to different functions
Date: Wed, 29 Apr 2015 23:51:14 +0000
Message-Id: <1430351482-59418-4-git-send-email-mickflemm@gmail.com> (sfid-20150430_015208_730485_3770157C)
In-Reply-To: <1430351482-59418-1-git-send-email-mickflemm@gmail.com>
References: <1430351482-59418-1-git-send-email-mickflemm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since more checks and fixes will be added later and ath_cmn_process_fft is
already big enough.

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath9k/common-spectral.c | 276 ++++++++++++++---------
 drivers/net/wireless/ath/ath9k/common-spectral.h |   6 +
 2 files changed, 171 insertions(+), 111 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.c b/drivers/net/wireless/ath/ath9k/common-spectral.c
index 8752634..007edb4 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.c
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.c
@@ -36,21 +36,165 @@ static void ath_debug_send_fft_sample(struct ath_spec_scan_priv *spec_priv,
 	relay_write(spec_priv->rfs_chan_spec_scan, fft_sample_tlv, length);
 }
 
+typedef int (ath_cmn_fft_sample_handler) (struct ath_rx_status *rs,
+			struct ath_spec_scan_priv *spec_priv,
+			u8 *sample_buf, u64 tsf, u16 freq, int chan_type);
+
+static int
+ath_cmn_process_ht20_fft(struct ath_rx_status *rs,
+			struct ath_spec_scan_priv *spec_priv,
+			u8 *sample_buf,
+			u64 tsf, u16 freq, int chan_type)
+{
+	struct fft_sample_ht20 fft_sample_20;
+	struct ath_hw *ah = spec_priv->ah;
+	struct ath_ht20_mag_info *mag_info;
+	struct fft_sample_tlv *tlv;
+	int dc_pos = SPECTRAL_HT20_NUM_BINS / 2;
+	u16 magnitude, length;
+	u8 max_index, bitmap_w;
+
+	length = sizeof(fft_sample_20) - sizeof(struct fft_sample_tlv);
+	fft_sample_20.tlv.type = ATH_FFT_SAMPLE_HT20;
+	fft_sample_20.tlv.length = __cpu_to_be16(length);
+	fft_sample_20.freq = __cpu_to_be16(freq);
+	fft_sample_20.rssi = fix_rssi_inv_only(rs->rs_rssi_ctl[0]);
+	fft_sample_20.noise = ah->noise;
+
+	mag_info = (struct ath_ht20_mag_info *) (sample_buf +
+					SPECTRAL_HT20_NUM_BINS);
+
+	magnitude = spectral_max_magnitude(mag_info->all_bins);
+	fft_sample_20.max_magnitude = __cpu_to_be16(magnitude);
+
+	max_index = spectral_max_index(mag_info->all_bins,
+					SPECTRAL_HT20_NUM_BINS);
+	fft_sample_20.max_index = max_index;
+
+	bitmap_w = spectral_bitmap_weight(mag_info->all_bins);
+	fft_sample_20.bitmap_weight = bitmap_w;
+
+	fft_sample_20.max_exp = mag_info->max_exp & 0xf;
+
+	fft_sample_20.tsf = __cpu_to_be64(tsf);
+
+	memcpy(fft_sample_20.data, sample_buf, SPECTRAL_HT20_NUM_BINS);
+
+	/* DC value (value in the middle) is the blind spot of the spectral
+	 * sample and invalid, interpolate it.
+	 */
+	fft_sample_20.data[dc_pos] = (fft_sample_20.data[dc_pos + 1] +
+					fft_sample_20.data[dc_pos - 1]) / 2;
+
+	tlv = (struct fft_sample_tlv *)&fft_sample_20;
+
+	ath_debug_send_fft_sample(spec_priv, tlv);
+
+	return 0;
+}
+
+static int
+ath_cmn_process_ht20_40_fft(struct ath_rx_status *rs,
+			struct ath_spec_scan_priv *spec_priv,
+			u8 *sample_buf,
+			u64 tsf, u16 freq, int chan_type)
+{
+	struct fft_sample_ht20_40 fft_sample_40;
+	struct ath_hw *ah = spec_priv->ah;
+	struct ath9k_hw_cal_data *caldata = ah->caldata;
+	struct ath_ht20_40_mag_info *mag_info;
+	struct fft_sample_tlv *tlv;
+	int dc_pos = SPECTRAL_HT20_40_NUM_BINS / 2;
+	s16 ext_nf;
+	u16 lower_mag, upper_mag, length;
+	s8 lower_rssi, upper_rssi;
+	u8 lower_max_index, upper_max_index;
+	u8 lower_bitmap_w, upper_bitmap_w;
+
+	if (caldata)
+		ext_nf = ath9k_hw_getchan_noise(ah, ah->curchan,
+				caldata->nfCalHist[3].privNF);
+	else
+		ext_nf = ATH_DEFAULT_NOISE_FLOOR;
+
+	length = sizeof(fft_sample_40) - sizeof(struct fft_sample_tlv);
+	fft_sample_40.tlv.type = ATH_FFT_SAMPLE_HT20_40;
+	fft_sample_40.tlv.length = __cpu_to_be16(length);
+	fft_sample_40.freq = __cpu_to_be16(freq);
+	fft_sample_40.channel_type = chan_type;
+
+	if (chan_type == NL80211_CHAN_HT40PLUS) {
+		lower_rssi = fix_rssi_inv_only(rs->rs_rssi_ctl[0]);
+		upper_rssi = fix_rssi_inv_only(rs->rs_rssi_ext[0]);
+
+		fft_sample_40.lower_noise = ah->noise;
+		fft_sample_40.upper_noise = ext_nf;
+	} else {
+		lower_rssi = fix_rssi_inv_only(rs->rs_rssi_ext[0]);
+		upper_rssi = fix_rssi_inv_only(rs->rs_rssi_ctl[0]);
+
+		fft_sample_40.lower_noise = ext_nf;
+		fft_sample_40.upper_noise = ah->noise;
+	}
+
+	fft_sample_40.lower_rssi = lower_rssi;
+	fft_sample_40.upper_rssi = upper_rssi;
+
+	mag_info = (struct ath_ht20_40_mag_info *) (sample_buf +
+					SPECTRAL_HT20_40_NUM_BINS);
+
+	lower_mag = spectral_max_magnitude(mag_info->lower_bins);
+	fft_sample_40.lower_max_magnitude = __cpu_to_be16(lower_mag);
+
+	upper_mag = spectral_max_magnitude(mag_info->upper_bins);
+	fft_sample_40.upper_max_magnitude = __cpu_to_be16(upper_mag);
+
+	lower_max_index = spectral_max_index(mag_info->lower_bins,
+					SPECTRAL_HT20_40_NUM_BINS);
+	fft_sample_40.lower_max_index = lower_max_index;
+
+	upper_max_index = spectral_max_index(mag_info->upper_bins,
+					SPECTRAL_HT20_40_NUM_BINS);
+	fft_sample_40.upper_max_index = upper_max_index;
+
+	lower_bitmap_w = spectral_bitmap_weight(mag_info->lower_bins);
+	fft_sample_40.lower_bitmap_weight = lower_bitmap_w;
+
+	upper_bitmap_w = spectral_bitmap_weight(mag_info->upper_bins);
+	fft_sample_40.upper_bitmap_weight = upper_bitmap_w;
+
+	fft_sample_40.max_exp = mag_info->max_exp & 0xf;
+
+	fft_sample_40.tsf = __cpu_to_be64(tsf);
+
+	memcpy(fft_sample_40.data, sample_buf, SPECTRAL_HT20_40_NUM_BINS);
+
+	/* DC value (value in the middle) is the blind spot of the spectral
+	 * sample and invalid, interpolate it.
+	 */
+	fft_sample_40.data[dc_pos] = (fft_sample_40.data[dc_pos + 1] +
+					fft_sample_40.data[dc_pos - 1]) / 2;
+
+	tlv = (struct fft_sample_tlv *)&fft_sample_40;
+
+	ath_debug_send_fft_sample(spec_priv, tlv);
+
+	return 0;
+}
+
 /* returns 1 if this was a spectral frame, even if not handled. */
 int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv, struct ieee80211_hdr *hdr,
 		    struct ath_rx_status *rs, u64 tsf)
 {
+	u8 sample_buf[SPECTRAL_SAMPLE_MAX_LEN] = {0};
 	struct ath_hw *ah = spec_priv->ah;
 	struct ath_common *common = ath9k_hw_common(spec_priv->ah);
-	u8 num_bins, *bins, *vdata = (u8 *)hdr;
-	struct fft_sample_ht20 fft_sample_20;
-	struct fft_sample_ht20_40 fft_sample_40;
-	struct fft_sample_tlv *tlv;
+	u8 num_bins, *vdata = (u8 *)hdr;
 	struct ath_radar_info *radar_info;
 	int len = rs->rs_datalen;
-	int dc_pos;
-	u16 fft_len, length, freq = ah->curchan->chan->center_freq;
+	u16 fft_len, sample_len, freq = ah->curchan->chan->center_freq;
 	enum nl80211_channel_type chan_type;
+	ath_cmn_fft_sample_handler *fft_handler;
 
 	/* AR9280 and before report via ATH9K_PHYERR_RADAR, AR93xx and newer
 	 * via ATH9K_PHYERR_SPECTRAL. Haven't seen ATH9K_PHYERR_FALSE_RADAR_EXT
@@ -72,12 +216,14 @@ int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv, struct ieee80211_h
 	if ((chan_type == NL80211_CHAN_HT40MINUS) ||
 	    (chan_type == NL80211_CHAN_HT40PLUS)) {
 		fft_len = SPECTRAL_HT20_40_TOTAL_DATA_LEN;
+		sample_len = SPECTRAL_HT20_40_SAMPLE_LEN;
 		num_bins = SPECTRAL_HT20_40_NUM_BINS;
-		bins = (u8 *)fft_sample_40.data;
+		fft_handler = &ath_cmn_process_ht20_40_fft;
 	} else {
 		fft_len = SPECTRAL_HT20_TOTAL_DATA_LEN;
+		sample_len = SPECTRAL_HT20_SAMPLE_LEN;
 		num_bins = SPECTRAL_HT20_NUM_BINS;
-		bins = (u8 *)fft_sample_20.data;
+		fft_handler = &ath_cmn_process_ht20_fft;
 	}
 
 	/* Variation in the data length is possible and will be fixed later */
@@ -87,123 +233,31 @@ int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv, struct ieee80211_h
 	switch (len - fft_len) {
 	case 0:
 		/* length correct, nothing to do. */
-		memcpy(bins, vdata, num_bins);
+		memcpy(sample_buf, vdata, sample_len);
 		break;
 	case -1:
 		/* first byte missing, duplicate it. */
-		memcpy(&bins[1], vdata, num_bins - 1);
-		bins[0] = vdata[0];
+		memcpy(&sample_buf[1], vdata, sample_len - 1);
+		sample_buf[0] = vdata[0];
 		break;
 	case 2:
 		/* MAC added 2 extra bytes at bin 30 and 32, remove them. */
-		memcpy(bins, vdata, 30);
-		bins[30] = vdata[31];
-		memcpy(&bins[31], &vdata[33], num_bins - 31);
+		memcpy(sample_buf, vdata, 30);
+		sample_buf[30] = vdata[31];
+		memcpy(&sample_buf[31], &vdata[33], sample_len - 31);
 		break;
 	case 1:
 		/* MAC added 2 extra bytes AND first byte is missing. */
-		bins[0] = vdata[0];
-		memcpy(&bins[1], vdata, 30);
-		bins[31] = vdata[31];
-		memcpy(&bins[32], &vdata[33], num_bins - 32);
+		sample_buf[0] = vdata[0];
+		memcpy(&sample_buf[1], vdata, 30);
+		sample_buf[31] = vdata[31];
+		memcpy(&sample_buf[32], &vdata[33], sample_len - 32);
 		break;
 	default:
 		return 1;
 	}
 
-	/* DC value (value in the middle) is the blind spot of the spectral
-	 * sample and invalid, interpolate it.
-	 */
-	dc_pos = num_bins / 2;
-	bins[dc_pos] = (bins[dc_pos + 1] + bins[dc_pos - 1]) / 2;
-
-	if ((chan_type == NL80211_CHAN_HT40MINUS) ||
-	    (chan_type == NL80211_CHAN_HT40PLUS)) {
-		s8 lower_rssi, upper_rssi;
-		s16 ext_nf;
-		u8 lower_max_index, upper_max_index;
-		u8 lower_bitmap_w, upper_bitmap_w;
-		u16 lower_mag, upper_mag;
-		struct ath9k_hw_cal_data *caldata = ah->caldata;
-		struct ath_ht20_40_mag_info *mag_info;
-
-		if (caldata)
-			ext_nf = ath9k_hw_getchan_noise(ah, ah->curchan,
-					caldata->nfCalHist[3].privNF);
-		else
-			ext_nf = ATH_DEFAULT_NOISE_FLOOR;
-
-		length = sizeof(fft_sample_40) - sizeof(struct fft_sample_tlv);
-		fft_sample_40.tlv.type = ATH_FFT_SAMPLE_HT20_40;
-		fft_sample_40.tlv.length = __cpu_to_be16(length);
-		fft_sample_40.freq = __cpu_to_be16(freq);
-		fft_sample_40.channel_type = chan_type;
-
-		if (chan_type == NL80211_CHAN_HT40PLUS) {
-			lower_rssi = fix_rssi_inv_only(rs->rs_rssi_ctl[0]);
-			upper_rssi = fix_rssi_inv_only(rs->rs_rssi_ext[0]);
-
-			fft_sample_40.lower_noise = ah->noise;
-			fft_sample_40.upper_noise = ext_nf;
-		} else {
-			lower_rssi = fix_rssi_inv_only(rs->rs_rssi_ext[0]);
-			upper_rssi = fix_rssi_inv_only(rs->rs_rssi_ctl[0]);
-
-			fft_sample_40.lower_noise = ext_nf;
-			fft_sample_40.upper_noise = ah->noise;
-		}
-		fft_sample_40.lower_rssi = lower_rssi;
-		fft_sample_40.upper_rssi = upper_rssi;
-
-		mag_info = ((struct ath_ht20_40_mag_info *)radar_info) - 1;
-		lower_mag = spectral_max_magnitude(mag_info->lower_bins);
-		upper_mag = spectral_max_magnitude(mag_info->upper_bins);
-		fft_sample_40.lower_max_magnitude = __cpu_to_be16(lower_mag);
-		fft_sample_40.upper_max_magnitude = __cpu_to_be16(upper_mag);
-		lower_max_index = spectral_max_index(mag_info->lower_bins,
-								num_bins);
-		upper_max_index = spectral_max_index(mag_info->upper_bins,
-								num_bins);
-		fft_sample_40.lower_max_index = lower_max_index;
-		fft_sample_40.upper_max_index = upper_max_index;
-		lower_bitmap_w = spectral_bitmap_weight(mag_info->lower_bins);
-		upper_bitmap_w = spectral_bitmap_weight(mag_info->upper_bins);
-		fft_sample_40.lower_bitmap_weight = lower_bitmap_w;
-		fft_sample_40.upper_bitmap_weight = upper_bitmap_w;
-		fft_sample_40.max_exp = mag_info->max_exp & 0xf;
-
-		fft_sample_40.tsf = __cpu_to_be64(tsf);
-
-		tlv = (struct fft_sample_tlv *)&fft_sample_40;
-	} else {
-		u8 max_index, bitmap_w;
-		u16 magnitude;
-		struct ath_ht20_mag_info *mag_info;
-
-		length = sizeof(fft_sample_20) - sizeof(struct fft_sample_tlv);
-		fft_sample_20.tlv.type = ATH_FFT_SAMPLE_HT20;
-		fft_sample_20.tlv.length = __cpu_to_be16(length);
-		fft_sample_20.freq = __cpu_to_be16(freq);
-
-		fft_sample_20.rssi = fix_rssi_inv_only(rs->rs_rssi_ctl[0]);
-		fft_sample_20.noise = ah->noise;
-
-		mag_info = ((struct ath_ht20_mag_info *)radar_info) - 1;
-		magnitude = spectral_max_magnitude(mag_info->all_bins);
-		fft_sample_20.max_magnitude = __cpu_to_be16(magnitude);
-		max_index = spectral_max_index(mag_info->all_bins,
-							num_bins);
-		fft_sample_20.max_index = max_index;
-		bitmap_w = spectral_bitmap_weight(mag_info->all_bins);
-		fft_sample_20.bitmap_weight = bitmap_w;
-		fft_sample_20.max_exp = mag_info->max_exp & 0xf;
-
-		fft_sample_20.tsf = __cpu_to_be64(tsf);
-
-		tlv = (struct fft_sample_tlv *)&fft_sample_20;
-	}
-
-	ath_debug_send_fft_sample(spec_priv, tlv);
+	fft_handler(rs, spec_priv, sample_buf, tsf, freq, chan_type);
 
 	return 1;
 }
diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.h b/drivers/net/wireless/ath/ath9k/common-spectral.h
index 072ff76..998743b 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.h
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.h
@@ -66,6 +66,8 @@ struct ath_ht20_fft_packet {
 } __packed;
 
 #define SPECTRAL_HT20_TOTAL_DATA_LEN	(sizeof(struct ath_ht20_fft_packet))
+#define	SPECTRAL_HT20_SAMPLE_LEN	(sizeof(struct ath_ht20_mag_info) +\
+					SPECTRAL_HT20_NUM_BINS)
 
 /* Dynamic 20/40 mode:
  *
@@ -101,6 +103,10 @@ struct ath_spec_scan_priv {
 };
 
 #define SPECTRAL_HT20_40_TOTAL_DATA_LEN	(sizeof(struct ath_ht20_40_fft_packet))
+#define	SPECTRAL_HT20_40_SAMPLE_LEN	(sizeof(struct ath_ht20_40_mag_info) +\
+					SPECTRAL_HT20_40_NUM_BINS)
+
+#define	SPECTRAL_SAMPLE_MAX_LEN		SPECTRAL_HT20_40_SAMPLE_LEN
 
 /* grabs the max magnitude from the all/upper/lower bins */
 static inline u16 spectral_max_magnitude(u8 *bins)
-- 
2.3.5

