Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:49984 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731091AbeISQOi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 12:14:38 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 3/5] ath9k: fix and simplify FFT max index retrieval
Date: Wed, 19 Sep 2018 12:37:09 +0200
Message-Id: <20180919103711.19304-4-sw@simonwunderlich.de> (sfid-20180919_123723_622470_3DB744BB)
In-Reply-To: <20180919103711.19304-1-sw@simonwunderlich.de>
References: <20180919103711.19304-1-sw@simonwunderlich.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FFT max index retrieval was not retrieved correctly for HT20/HT40 FFT
frames. Fixing the retrieval allows us to remove the fixup function as
well. While at it, split the spectral_max_index function into versions
for ht20 and ht40 to simplify the code.

Cc: Nick Kossifidis <mickflemm@gmail.com>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 drivers/net/wireless/ath/ath9k/common-spectral.c | 45 ++++--------------------
 drivers/net/wireless/ath/ath9k/common-spectral.h | 17 +++++++++
 2 files changed, 23 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.c b/drivers/net/wireless/ath/ath9k/common-spectral.c
index f6dd0ecfbbf3..d10e3f29c356 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.c
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.c
@@ -59,8 +59,7 @@ ath_cmn_max_idx_verify_ht20_fft(u8 *sample_end, int bytes_read)
 
 	sample = sample_end - SPECTRAL_HT20_SAMPLE_LEN + 1;
 
-	max_index = spectral_max_index(mag_info->all_bins,
-				       SPECTRAL_HT20_NUM_BINS);
+	max_index = spectral_max_index_ht20(mag_info->all_bins);
 	max_magnitude = spectral_max_magnitude(mag_info->all_bins);
 
 	max_exp = mag_info->max_exp & 0xf;
@@ -100,12 +99,10 @@ ath_cmn_max_idx_verify_ht20_40_fft(u8 *sample_end, int bytes_read)
 	sample = sample_end - SPECTRAL_HT20_40_SAMPLE_LEN + 1;
 
 	lower_mag = spectral_max_magnitude(mag_info->lower_bins);
-	lower_max_index = spectral_max_index(mag_info->lower_bins,
-					     SPECTRAL_HT20_40_NUM_BINS);
+	lower_max_index = spectral_max_index_ht40(mag_info->lower_bins);
 
 	upper_mag = spectral_max_magnitude(mag_info->upper_bins);
-	upper_max_index = spectral_max_index(mag_info->upper_bins,
-					     SPECTRAL_HT20_40_NUM_BINS);
+	upper_max_index = spectral_max_index_ht40(mag_info->upper_bins);
 
 	max_exp = mag_info->max_exp & 0xf;
 
@@ -117,17 +114,6 @@ ath_cmn_max_idx_verify_ht20_40_fft(u8 *sample_end, int bytes_read)
 	   ((upper_max_index < 1) || (lower_max_index < 1)))
 		return -1;
 
-	/* Some time hardware messes up the index and adds
-	 * the index of the middle point (dc_pos). Try to fix it.
-	 */
-	if ((upper_max_index - dc_pos > 0) &&
-	   (sample[upper_max_index] == (upper_mag >> max_exp)))
-		upper_max_index -= dc_pos;
-
-	if ((lower_max_index - dc_pos > 0) &&
-	   (sample[lower_max_index - dc_pos] == (lower_mag >> max_exp)))
-		lower_max_index -= dc_pos;
-
 	if ((sample[upper_max_index + dc_pos] != (upper_mag >> max_exp)) ||
 	   (sample[lower_max_index] != (lower_mag >> max_exp)))
 		return -1;
@@ -169,8 +155,7 @@ ath_cmn_process_ht20_fft(struct ath_rx_status *rs,
 	magnitude = spectral_max_magnitude(mag_info->all_bins);
 	fft_sample_20.max_magnitude = __cpu_to_be16(magnitude);
 
-	max_index = spectral_max_index(mag_info->all_bins,
-					SPECTRAL_HT20_NUM_BINS);
+	max_index = spectral_max_index_ht20(mag_info->all_bins);
 	fft_sample_20.max_index = max_index;
 
 	bitmap_w = spectral_bitmap_weight(mag_info->all_bins);
@@ -302,12 +287,10 @@ ath_cmn_process_ht20_40_fft(struct ath_rx_status *rs,
 	upper_mag = spectral_max_magnitude(mag_info->upper_bins);
 	fft_sample_40.upper_max_magnitude = __cpu_to_be16(upper_mag);
 
-	lower_max_index = spectral_max_index(mag_info->lower_bins,
-					SPECTRAL_HT20_40_NUM_BINS);
+	lower_max_index = spectral_max_index_ht40(mag_info->lower_bins);
 	fft_sample_40.lower_max_index = lower_max_index;
 
-	upper_max_index = spectral_max_index(mag_info->upper_bins,
-					SPECTRAL_HT20_40_NUM_BINS);
+	upper_max_index = spectral_max_index_ht40(mag_info->upper_bins);
 	fft_sample_40.upper_max_index = upper_max_index;
 
 	lower_bitmap_w = spectral_bitmap_weight(mag_info->lower_bins);
@@ -331,22 +314,6 @@ ath_cmn_process_ht20_40_fft(struct ath_rx_status *rs,
 					upper_mag >> max_exp,
 					upper_max_index);
 
-	/* Some time hardware messes up the index and adds
-	 * the index of the middle point (dc_pos). Try to fix it.
-	 */
-	if ((upper_max_index - dc_pos > 0) &&
-	   (fft_sample_40.data[upper_max_index] == (upper_mag >> max_exp))) {
-		upper_max_index -= dc_pos;
-		fft_sample_40.upper_max_index = upper_max_index;
-	}
-
-	if ((lower_max_index - dc_pos > 0) &&
-	   (fft_sample_40.data[lower_max_index - dc_pos] ==
-	   (lower_mag >> max_exp))) {
-		lower_max_index -= dc_pos;
-		fft_sample_40.lower_max_index = lower_max_index;
-	}
-
 	/* Check if we got the expected magnitude values at
 	 * the expected bins
 	 */
diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.h b/drivers/net/wireless/ath/ath9k/common-spectral.h
index 303ab470ce34..011d8ab8b974 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.h
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.h
@@ -145,6 +145,23 @@ static inline u8 spectral_max_index(u8 *bins, int num_bins)
 	return m;
 }
 
+static inline u8 spectral_max_index_ht40(u8 *bins)
+{
+	u8 idx;
+
+	idx = spectral_max_index(bins, SPECTRAL_HT20_40_NUM_BINS);
+
+	/* positive values and zero are starting at the beginning
+	 * of the data field.
+	 */
+	return idx % (SPECTRAL_HT20_40_NUM_BINS / 2);
+}
+
+static inline u8 spectral_max_index_ht20(u8 *bins)
+{
+	return spectral_max_index(bins, SPECTRAL_HT20_NUM_BINS);
+}
+
 /* return the bitmap weight from the all/upper/lower bins */
 static inline u8 spectral_bitmap_weight(u8 *bins)
 {
-- 
2.11.0
