Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:34140 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbbD2XwG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2015 19:52:06 -0400
Received: by iget9 with SMTP id t9so951954ige.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2015 16:52:06 -0700 (PDT)
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	adrian.chadd@gmail.com, Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 05/11] ath9k: Support processing of multiple FFT frames per report.
Date: Wed, 29 Apr 2015 23:51:16 +0000
Message-Id: <1430351482-59418-6-git-send-email-mickflemm@gmail.com> (sfid-20150430_015212_343968_E0758EAB)
In-Reply-To: <1430351482-59418-1-git-send-email-mickflemm@gmail.com>
References: <1430351482-59418-1-git-send-email-mickflemm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we can identify the FFT frames on the report by checking the
consistency of their magnitude info, we can process all of them,
even when some of them are corrupted.

This patch introduces two functions to quickly verify the integrity
of the mag_info fields and some further tweaks to detect the frames
in the report and process them.

Note that in case of missing bytes we don't duplicate them, instead
we leave them as zeroes. This way we get less noise on the FFT plot.

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath9k/common-spectral.c | 267 ++++++++++++++++++++---
 1 file changed, 237 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.c b/drivers/net/wireless/ath/ath9k/common-spectral.c
index 12db498..51ab396 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.c
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.c
@@ -36,6 +36,104 @@ static void ath_debug_send_fft_sample(struct ath_spec_scan_priv *spec_priv,
 	relay_write(spec_priv->rfs_chan_spec_scan, fft_sample_tlv, length);
 }
 
+typedef int (ath_cmn_fft_idx_validator) (u8 *sample_end, int bytes_read);
+
+static int
+ath_cmn_max_idx_verify_ht20_fft(u8 *sample_end, int bytes_read)
+{
+	struct ath_ht20_mag_info *mag_info;
+	u8 *sample;
+	u16 max_magnitude;
+	u8 max_index;
+	u8 max_exp;
+
+	/* Sanity check so that we don't read outside the read
+	 * buffer
+	 */
+	if (bytes_read < SPECTRAL_HT20_SAMPLE_LEN - 1)
+		return -1;
+
+	mag_info = (struct ath_ht20_mag_info *) (sample_end -
+				sizeof(struct ath_ht20_mag_info) + 1);
+
+	sample = sample_end - SPECTRAL_HT20_SAMPLE_LEN + 1;
+
+	max_index = spectral_max_index(mag_info->all_bins,
+				       SPECTRAL_HT20_NUM_BINS);
+	max_magnitude = spectral_max_magnitude(mag_info->all_bins);
+
+	max_exp = mag_info->max_exp & 0xf;
+
+	/* Don't try to read something outside the read buffer
+	 * in case of a missing byte (so bins[0] will be outside
+	 * the read buffer)
+	 */
+	if (bytes_read < SPECTRAL_HT20_SAMPLE_LEN && max_index < 1)
+		return -1;
+
+	if (sample[max_index] != (max_magnitude >> max_exp))
+		return -1;
+	else
+		return 0;
+}
+
+static int
+ath_cmn_max_idx_verify_ht20_40_fft(u8 *sample_end, int bytes_read)
+{
+	struct ath_ht20_40_mag_info *mag_info;
+	u8 *sample;
+	u16 lower_mag, upper_mag;
+	u8 lower_max_index, upper_max_index;
+	u8 max_exp;
+	int dc_pos = SPECTRAL_HT20_40_NUM_BINS / 2;
+
+	/* Sanity check so that we don't read outside the read
+	 * buffer
+	 */
+	if (bytes_read < SPECTRAL_HT20_40_SAMPLE_LEN - 1)
+		return -1;
+
+	mag_info = (struct ath_ht20_40_mag_info *) (sample_end -
+				sizeof(struct ath_ht20_40_mag_info) + 1);
+
+	sample = sample_end - SPECTRAL_HT20_40_SAMPLE_LEN + 1;
+
+	lower_mag = spectral_max_magnitude(mag_info->lower_bins);
+	lower_max_index = spectral_max_index(mag_info->lower_bins,
+					     SPECTRAL_HT20_40_NUM_BINS);
+
+	upper_mag = spectral_max_magnitude(mag_info->upper_bins);
+	upper_max_index = spectral_max_index(mag_info->upper_bins,
+					     SPECTRAL_HT20_40_NUM_BINS);
+
+	max_exp = mag_info->max_exp & 0xf;
+
+	/* Don't try to read something outside the read buffer
+	 * in case of a missing byte (so bins[0] will be outside
+	 * the read buffer)
+	 */
+	if (bytes_read < SPECTRAL_HT20_40_SAMPLE_LEN &&
+	   ((upper_max_index < 1) || (lower_max_index < 1)))
+		return -1;
+
+	/* Some time hardware messes up the index and adds
+	 * the index of the middle point (dc_pos). Try to fix it.
+	 */
+	if ((upper_max_index - dc_pos > 0) &&
+	   (sample[upper_max_index] == (upper_mag >> max_exp)))
+		upper_max_index -= dc_pos;
+
+	if ((lower_max_index - dc_pos > 0) &&
+	   (sample[lower_max_index - dc_pos] == (lower_mag >> max_exp)))
+		lower_max_index -= dc_pos;
+
+	if ((sample[upper_max_index + dc_pos] != (upper_mag >> max_exp)) ||
+	   (sample[lower_max_index] != (lower_mag >> max_exp)))
+		return -1;
+	else
+		return 0;
+}
+
 typedef int (ath_cmn_fft_sample_handler) (struct ath_rx_status *rs,
 			struct ath_spec_scan_priv *spec_priv,
 			u8 *sample_buf, u64 tsf, u16 freq, int chan_type);
@@ -349,8 +447,14 @@ int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv, struct ieee80211_h
 	u8 num_bins, *vdata = (u8 *)hdr;
 	struct ath_radar_info *radar_info;
 	int len = rs->rs_datalen;
+	int i;
+	int got_slen = 0;
+	u8  *sample_start;
+	int sample_bytes = 0;
+	int ret = 0;
 	u16 fft_len, sample_len, freq = ah->curchan->chan->center_freq;
 	enum nl80211_channel_type chan_type;
+	ath_cmn_fft_idx_validator *fft_idx_validator;
 	ath_cmn_fft_sample_handler *fft_handler;
 
 	/* AR9280 and before report via ATH9K_PHYERR_RADAR, AR93xx and newer
@@ -375,47 +479,150 @@ int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv, struct ieee80211_h
 		fft_len = SPECTRAL_HT20_40_TOTAL_DATA_LEN;
 		sample_len = SPECTRAL_HT20_40_SAMPLE_LEN;
 		num_bins = SPECTRAL_HT20_40_NUM_BINS;
+		fft_idx_validator = &ath_cmn_max_idx_verify_ht20_40_fft;
 		fft_handler = &ath_cmn_process_ht20_40_fft;
 	} else {
 		fft_len = SPECTRAL_HT20_TOTAL_DATA_LEN;
 		sample_len = SPECTRAL_HT20_SAMPLE_LEN;
 		num_bins = SPECTRAL_HT20_NUM_BINS;
+		fft_idx_validator = ath_cmn_max_idx_verify_ht20_fft;
 		fft_handler = &ath_cmn_process_ht20_fft;
 	}
 
-	/* Variation in the data length is possible and will be fixed later */
-	if ((len > fft_len + 2) || (len < fft_len - 1))
-		return 1;
+	ath_dbg(common, SPECTRAL_SCAN, "Got radar dump bw_info: 0x%X,"
+					"len: %i fft_len: %i\n",
+					radar_info->pulse_bw_info,
+					len,
+					fft_len);
+	sample_start = vdata;
+	for (i = 0; i < len - 2; i++) {
+		sample_bytes++;
+
+		/* Only a single sample received, no need to look
+		 * for the sample's end, do the correction based
+		 * on the packet's length instead. Note that hw
+		 * will always put the radar_info structure on
+		 * the end.
+		 */
+		if (len <= fft_len + 2) {
+			sample_bytes = len - sizeof(struct ath_radar_info);
+			got_slen = 1;
+		}
 
-	switch (len - fft_len) {
-	case 0:
-		/* length correct, nothing to do. */
-		memcpy(sample_buf, vdata, sample_len);
-		break;
-	case -1:
-		/* first byte missing, duplicate it. */
-		memcpy(&sample_buf[1], vdata, sample_len - 1);
-		sample_buf[0] = vdata[0];
-		break;
-	case 2:
-		/* MAC added 2 extra bytes at bin 30 and 32, remove them. */
-		memcpy(sample_buf, vdata, 30);
-		sample_buf[30] = vdata[31];
-		memcpy(&sample_buf[31], &vdata[33], sample_len - 31);
-		break;
-	case 1:
-		/* MAC added 2 extra bytes AND first byte is missing. */
-		sample_buf[0] = vdata[0];
-		memcpy(&sample_buf[1], vdata, 30);
-		sample_buf[31] = vdata[31];
-		memcpy(&sample_buf[32], &vdata[33], sample_len - 32);
-		break;
-	default:
-		return 1;
-	}
+		/* Search for the end of the FFT frame between
+		 * sample_len - 1 and sample_len + 2. exp_max is 3
+		 * bits long and it's the only value on the last
+		 * byte of the frame so since it'll be smaller than
+		 * the next byte (the first bin of the next sample)
+		 * 90% of the time, we can use it as a separator.
+		 */
+		if (vdata[i] <= 0x7 && sample_bytes >= sample_len - 1) {
+
+			/* Got a frame length within boundaries, there are
+			 * four scenarios here:
+			 *
+			 * a) sample_len -> We got the correct length
+			 * b) sample_len + 2 -> 2 bytes added around bin[31]
+			 * c) sample_len - 1 -> The first byte is missing
+			 * d) sample_len + 1 -> b + c at the same time
+			 *
+			 * When MAC adds 2 extra bytes, bin[31] and bin[32]
+			 * have the same value, so we can use that for further
+			 * verification in cases b and d.
+			 */
+
+			/* Did we go too far ? If so we couldn't determine
+			 * this sample's boundaries, discard any further
+			 * data
+			 */
+			if ((sample_bytes > sample_len + 2) ||
+			   ((sample_bytes > sample_len) &&
+			   (sample_start[31] != sample_start[32])))
+				break;
+
+			/* See if we got a valid frame by checking the
+			 * consistency of mag_info fields. This is to
+			 * prevent from "fixing" a correct frame.
+			 * Failure is non-fatal, later frames may
+			 * be valid.
+			 */
+			if (!fft_idx_validator(&vdata[i], i)) {
+				ath_dbg(common, SPECTRAL_SCAN,
+					"Found valid fft frame at %i\n", i);
+				got_slen = 1;
+			}
 
-	fft_handler(rs, spec_priv, sample_buf, tsf, freq, chan_type);
+			/* We expect 1 - 2 more bytes */
+			else if ((sample_start[31] == sample_start[32]) &&
+				(sample_bytes >= sample_len) &&
+				(sample_bytes < sample_len + 2) &&
+				(vdata[i + 1] <= 0x7))
+				continue;
+
+			/* Try to distinguish cases a and c */
+			else if ((sample_bytes == sample_len - 1) &&
+				(vdata[i + 1] <= 0x7))
+				continue;
+
+			got_slen = 1;
+		}
+
+		if (got_slen) {
+			ath_dbg(common, SPECTRAL_SCAN, "FFT frame len: %i\n",
+				sample_bytes);
+			switch (sample_bytes - sample_len) {
+			case -1:
+				/* First byte missing */
+				memcpy(&sample_buf[1], sample_start,
+				       sample_len - 1);
+				break;
+			case 0:
+				/* Length correct, nothing to do. */
+				memcpy(sample_buf, sample_start, sample_len);
+				break;
+			case 1:
+				/* MAC added 2 extra bytes AND first byte
+				 * is missing.
+				 */
+				memcpy(&sample_buf[1], sample_start, 30);
+				sample_buf[31] = sample_start[31];
+				memcpy(&sample_buf[32], &sample_start[33],
+				       sample_len - 32);
+				break;
+			case 2:
+				/* MAC added 2 extra bytes at bin 30 and 32,
+				 * remove them.
+				 */
+				memcpy(sample_buf, sample_start, 30);
+				sample_buf[30] = sample_start[31];
+				memcpy(&sample_buf[31], &sample_start[33],
+				       sample_len - 31);
+				break;
+			default:
+				break;
+			}
+
+			ret = fft_handler(rs, spec_priv, sample_buf, tsf,
+							freq, chan_type);
+			memset(sample_buf, 0, SPECTRAL_SAMPLE_MAX_LEN);
+			sample_start = &vdata[i + 1];
+			/* -1 to grab sample_len -1, -2 since
+			 * they 'll get increased by one. In case
+			 * of failure try to recover by going byte
+			 * by byte instead. */
+			if (ret == 0) {
+				i += num_bins - 2;
+				sample_bytes = num_bins - 2;
+			}
+			got_slen = 0;
+		}
+	}
 
+	i -= num_bins - 2;
+	if (len - i != sizeof(struct ath_radar_info))
+		ath_dbg(common, SPECTRAL_SCAN, "FFT report truncated"
+						"(bytes left: %i)\n",
+						len - i);
 	return 1;
 }
 EXPORT_SYMBOL(ath_cmn_process_fft);
-- 
2.3.5

