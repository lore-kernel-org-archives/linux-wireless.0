Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:34127 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbbD2XwE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2015 19:52:04 -0400
Received: by iget9 with SMTP id t9so951603ige.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2015 16:52:04 -0700 (PDT)
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	adrian.chadd@gmail.com, Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 04/11] ath9k: Perform integrity checks when processing FFT frames
Date: Wed, 29 Apr 2015 23:51:15 +0000
Message-Id: <1430351482-59418-5-git-send-email-mickflemm@gmail.com> (sfid-20150430_015210_855205_D6067815)
In-Reply-To: <1430351482-59418-1-git-send-email-mickflemm@gmail.com>
References: <1430351482-59418-1-git-send-email-mickflemm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

a) Check that the maximum magnitude is at the specified index

b) Check if the maximum magnitude index is at dc_pos and if so
calculate a new one (value at dc_pos is invalid)

c) Check if the specified maximum magnitude is indeed the maximum

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath9k/common-spectral.c | 169 ++++++++++++++++++++++-
 1 file changed, 163 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.c b/drivers/net/wireless/ath/ath9k/common-spectral.c
index 007edb4..12db498 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.c
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.c
@@ -47,12 +47,15 @@ ath_cmn_process_ht20_fft(struct ath_rx_status *rs,
 			u64 tsf, u16 freq, int chan_type)
 {
 	struct fft_sample_ht20 fft_sample_20;
+	struct ath_common *common = ath9k_hw_common(spec_priv->ah);
 	struct ath_hw *ah = spec_priv->ah;
 	struct ath_ht20_mag_info *mag_info;
 	struct fft_sample_tlv *tlv;
+	int i = 0;
+	int ret = 0;
 	int dc_pos = SPECTRAL_HT20_NUM_BINS / 2;
-	u16 magnitude, length;
-	u8 max_index, bitmap_w;
+	u16 magnitude, tmp_mag, length;
+	u8 max_index, bitmap_w, max_exp;
 
 	length = sizeof(fft_sample_20) - sizeof(struct fft_sample_tlv);
 	fft_sample_20.tlv.type = ATH_FFT_SAMPLE_HT20;
@@ -74,18 +77,66 @@ ath_cmn_process_ht20_fft(struct ath_rx_status *rs,
 	bitmap_w = spectral_bitmap_weight(mag_info->all_bins);
 	fft_sample_20.bitmap_weight = bitmap_w;
 
-	fft_sample_20.max_exp = mag_info->max_exp & 0xf;
+	max_exp = mag_info->max_exp & 0xf;
+	fft_sample_20.max_exp = max_exp;
 
 	fft_sample_20.tsf = __cpu_to_be64(tsf);
 
 	memcpy(fft_sample_20.data, sample_buf, SPECTRAL_HT20_NUM_BINS);
 
+	ath_dbg(common, SPECTRAL_SCAN, "FFT HT20 frame: max mag 0x%X,"
+					"max_mag_idx %i\n",
+					magnitude >> max_exp,
+					max_index);
+
+	if (fft_sample_20.data[max_index] != (magnitude >> max_exp)) {
+		ath_dbg(common, SPECTRAL_SCAN, "Magnitude mismatch !\n");
+		ret = -1;
+	}
+
 	/* DC value (value in the middle) is the blind spot of the spectral
 	 * sample and invalid, interpolate it.
 	 */
 	fft_sample_20.data[dc_pos] = (fft_sample_20.data[dc_pos + 1] +
 					fft_sample_20.data[dc_pos - 1]) / 2;
 
+	/* Check if the maximum magnitude is indeed maximum,
+	 * also if the maximum value was at dc_pos, calculate
+	 * a new one (since value at dc_pos is invalid).
+	 */
+	if (max_index == dc_pos) {
+		tmp_mag = 0;
+		for (i = 0; i < dc_pos; i++) {
+			if (fft_sample_20.data[i] > tmp_mag) {
+				tmp_mag = fft_sample_20.data[i];
+				fft_sample_20.max_index = i;
+			}
+		}
+
+		magnitude = tmp_mag << max_exp;
+		fft_sample_20.max_magnitude = __cpu_to_be16(magnitude);
+
+		ath_dbg(common, SPECTRAL_SCAN,
+			"Calculated new lower max 0x%X at %i\n",
+			tmp_mag, fft_sample_20.max_index);
+	} else
+	for (i = 0; i < SPECTRAL_HT20_NUM_BINS; i++) {
+		if (fft_sample_20.data[i] == (magnitude >> max_exp))
+			ath_dbg(common, SPECTRAL_SCAN,
+				"Got max: 0x%X at index %i\n",
+				fft_sample_20.data[i], i);
+
+		if (fft_sample_20.data[i] > (magnitude >> max_exp)) {
+			ath_dbg(common, SPECTRAL_SCAN,
+				"Got bin %i greater than max: 0x%X\n",
+				i, fft_sample_20.data[i]);
+			ret = -1;
+		}
+	}
+
+	if (ret < 0)
+		return ret;
+
 	tlv = (struct fft_sample_tlv *)&fft_sample_20;
 
 	ath_debug_send_fft_sample(spec_priv, tlv);
@@ -100,16 +151,19 @@ ath_cmn_process_ht20_40_fft(struct ath_rx_status *rs,
 			u64 tsf, u16 freq, int chan_type)
 {
 	struct fft_sample_ht20_40 fft_sample_40;
+	struct ath_common *common = ath9k_hw_common(spec_priv->ah);
 	struct ath_hw *ah = spec_priv->ah;
 	struct ath9k_hw_cal_data *caldata = ah->caldata;
 	struct ath_ht20_40_mag_info *mag_info;
 	struct fft_sample_tlv *tlv;
 	int dc_pos = SPECTRAL_HT20_40_NUM_BINS / 2;
+	int i = 0;
+	int ret = 0;
 	s16 ext_nf;
-	u16 lower_mag, upper_mag, length;
+	u16 lower_mag, upper_mag, tmp_mag, length;
 	s8 lower_rssi, upper_rssi;
 	u8 lower_max_index, upper_max_index;
-	u8 lower_bitmap_w, upper_bitmap_w;
+	u8 lower_bitmap_w, upper_bitmap_w, max_exp;
 
 	if (caldata)
 		ext_nf = ath9k_hw_getchan_noise(ah, ah->curchan,
@@ -163,18 +217,121 @@ ath_cmn_process_ht20_40_fft(struct ath_rx_status *rs,
 	upper_bitmap_w = spectral_bitmap_weight(mag_info->upper_bins);
 	fft_sample_40.upper_bitmap_weight = upper_bitmap_w;
 
-	fft_sample_40.max_exp = mag_info->max_exp & 0xf;
+	max_exp = mag_info->max_exp & 0xf;
+	fft_sample_40.max_exp = max_exp;
 
 	fft_sample_40.tsf = __cpu_to_be64(tsf);
 
 	memcpy(fft_sample_40.data, sample_buf, SPECTRAL_HT20_40_NUM_BINS);
 
+	ath_dbg(common, SPECTRAL_SCAN, "FFT HT20/40 frame: lower mag 0x%X,"
+					"lower_mag_idx %i, upper mag 0x%X,"
+					"upper_mag_idx %i\n",
+					lower_mag >> max_exp,
+					lower_max_index,
+					upper_mag >> max_exp,
+					upper_max_index);
+
+	/* Some time hardware messes up the index and adds
+	 * the index of the middle point (dc_pos). Try to fix it.
+	 */
+	if ((upper_max_index - dc_pos > 0) &&
+	   (fft_sample_40.data[upper_max_index] == (upper_mag >> max_exp))) {
+		upper_max_index -= dc_pos;
+		fft_sample_40.upper_max_index = upper_max_index;
+	}
+
+	if ((lower_max_index - dc_pos > 0) &&
+	   (fft_sample_40.data[lower_max_index - dc_pos] ==
+	   (lower_mag >> max_exp))) {
+		lower_max_index -= dc_pos;
+		fft_sample_40.lower_max_index = lower_max_index;
+	}
+
+	/* Check if we got the expected magnitude values at
+	 * the expected bins
+	 */
+	if ((fft_sample_40.data[upper_max_index + dc_pos]
+	    != (upper_mag >> max_exp)) ||
+	   (fft_sample_40.data[lower_max_index]
+	    != (lower_mag >> max_exp))) {
+		ath_dbg(common, SPECTRAL_SCAN, "Magnitude mismatch !\n");
+		ret = -1;
+	}
+
 	/* DC value (value in the middle) is the blind spot of the spectral
 	 * sample and invalid, interpolate it.
 	 */
 	fft_sample_40.data[dc_pos] = (fft_sample_40.data[dc_pos + 1] +
 					fft_sample_40.data[dc_pos - 1]) / 2;
 
+	/* Check if the maximum magnitudes are indeed maximum,
+	 * also if the maximum value was at dc_pos, calculate
+	 * a new one (since value at dc_pos is invalid).
+	 */
+	if (lower_max_index == dc_pos) {
+		tmp_mag = 0;
+		for (i = 0; i < dc_pos; i++) {
+			if (fft_sample_40.data[i] > tmp_mag) {
+				tmp_mag = fft_sample_40.data[i];
+				fft_sample_40.lower_max_index = i;
+			}
+		}
+
+		lower_mag = tmp_mag << max_exp;
+		fft_sample_40.lower_max_magnitude = __cpu_to_be16(lower_mag);
+
+		ath_dbg(common, SPECTRAL_SCAN,
+			"Calculated new lower max 0x%X at %i\n",
+			tmp_mag, fft_sample_40.lower_max_index);
+	} else
+	for (i = 0; i < dc_pos; i++) {
+		if (fft_sample_40.data[i] == (lower_mag >> max_exp))
+			ath_dbg(common, SPECTRAL_SCAN,
+				"Got lower mag: 0x%X at index %i\n",
+				fft_sample_40.data[i], i);
+
+		if (fft_sample_40.data[i] > (lower_mag >> max_exp)) {
+			ath_dbg(common, SPECTRAL_SCAN,
+				"Got lower bin %i higher than max: 0x%X\n",
+				i, fft_sample_40.data[i]);
+			ret = -1;
+		}
+	}
+
+	if (upper_max_index == dc_pos) {
+		tmp_mag = 0;
+		for (i = dc_pos; i < SPECTRAL_HT20_40_NUM_BINS; i++) {
+			if (fft_sample_40.data[i] > tmp_mag) {
+				tmp_mag = fft_sample_40.data[i];
+				fft_sample_40.upper_max_index = i;
+			}
+		}
+		upper_mag = tmp_mag << max_exp;
+		fft_sample_40.upper_max_magnitude = __cpu_to_be16(upper_mag);
+
+		ath_dbg(common, SPECTRAL_SCAN,
+			"Calculated new upper max 0x%X at %i\n",
+			tmp_mag, i);
+	} else
+	for (i = dc_pos; i < SPECTRAL_HT20_40_NUM_BINS; i++) {
+		if (fft_sample_40.data[i] == (upper_mag >> max_exp))
+			ath_dbg(common, SPECTRAL_SCAN,
+				"Got upper mag: 0x%X at index %i\n",
+				fft_sample_40.data[i], i);
+
+		if (fft_sample_40.data[i] > (upper_mag >> max_exp)) {
+			ath_dbg(common, SPECTRAL_SCAN,
+				"Got upper bin %i higher than max: 0x%X\n",
+				i, fft_sample_40.data[i]);
+
+			ret = -1;
+		}
+	}
+
+	if (ret < 0)
+		return ret;
+
 	tlv = (struct fft_sample_tlv *)&fft_sample_40;
 
 	ath_debug_send_fft_sample(spec_priv, tlv);
-- 
2.3.5

