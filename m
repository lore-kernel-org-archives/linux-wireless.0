Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:36553 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbbD2XwA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2015 19:52:00 -0400
Received: by iebrs15 with SMTP id rs15so55324979ieb.3
        for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2015 16:51:59 -0700 (PDT)
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	adrian.chadd@gmail.com, Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 02/11] ath9k: Fix hanlding of maximum magnitude index
Date: Wed, 29 Apr 2015 23:51:13 +0000
Message-Id: <1430351482-59418-3-git-send-email-mickflemm@gmail.com> (sfid-20150430_015206_041944_B8F32B7E)
In-Reply-To: <1430351482-59418-1-git-send-email-mickflemm@gmail.com>
References: <1430351482-59418-1-git-send-email-mickflemm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maximum magnitude index is a 5bit signed integer,
convert to an 8bit signed integer and then "shift" it so that it can be used
as an array index. Note that the current implementation adds +1 to the index
value (so it can't be used as an array index) and it's only valid for HT20
channels.

Note that the maximum magnitude index is not being used by
the userspace tools that parse FFT samples (they just use
maximum magnitude) so this doesn't break userspace compatibility.

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath9k/common-spectral.c |  9 +++++---
 drivers/net/wireless/ath/ath9k/common-spectral.h | 29 ++++++++++++++++++------
 2 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.c b/drivers/net/wireless/ath/ath9k/common-spectral.c
index 5cee231..8752634 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.c
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.c
@@ -160,8 +160,10 @@ int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv, struct ieee80211_h
 		upper_mag = spectral_max_magnitude(mag_info->upper_bins);
 		fft_sample_40.lower_max_magnitude = __cpu_to_be16(lower_mag);
 		fft_sample_40.upper_max_magnitude = __cpu_to_be16(upper_mag);
-		lower_max_index = spectral_max_index(mag_info->lower_bins);
-		upper_max_index = spectral_max_index(mag_info->upper_bins);
+		lower_max_index = spectral_max_index(mag_info->lower_bins,
+								num_bins);
+		upper_max_index = spectral_max_index(mag_info->upper_bins,
+								num_bins);
 		fft_sample_40.lower_max_index = lower_max_index;
 		fft_sample_40.upper_max_index = upper_max_index;
 		lower_bitmap_w = spectral_bitmap_weight(mag_info->lower_bins);
@@ -189,7 +191,8 @@ int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv, struct ieee80211_h
 		mag_info = ((struct ath_ht20_mag_info *)radar_info) - 1;
 		magnitude = spectral_max_magnitude(mag_info->all_bins);
 		fft_sample_20.max_magnitude = __cpu_to_be16(magnitude);
-		max_index = spectral_max_index(mag_info->all_bins);
+		max_index = spectral_max_index(mag_info->all_bins,
+							num_bins);
 		fft_sample_20.max_index = max_index;
 		bitmap_w = spectral_bitmap_weight(mag_info->all_bins);
 		fft_sample_20.bitmap_weight = bitmap_w;
diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.h b/drivers/net/wireless/ath/ath9k/common-spectral.h
index d45dc83..75e24da 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.h
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.h
@@ -117,17 +117,32 @@ static inline u16 spectral_max_magnitude(u8 *bins)
 }
 
 /* return the max magnitude from the all/upper/lower bins */
-static inline u8 spectral_max_index(u8 *bins)
+static inline u8 spectral_max_index(u8 *bins, int num_bins)
 {
 	s8 m = (bins[2] & 0xfc) >> 2;
-
-	/* TODO: this still doesn't always report the right values ... */
-	if (m > 32)
+	u8 zero_idx = num_bins / 2;
+
+	/* It's a 5 bit signed int, remove its sign and use one's
+	 * complement interpretation to add the sign back to the 8
+	 * bit int
+	 */
+	if (m & 0x20) {
+		m &= ~0x20;
 		m |= 0xe0;
-	else
-		m &= ~0xe0;
+	}
+
+	/* Bring the zero point to the beginning
+	 * instead of the middle so that we can use
+	 * it for array lookup and that we don't deal
+	 * with negative values later
+	 */
+	m += zero_idx;
+
+	/* Sanity check to make sure index is within bounds */
+	if (m < 0 || m > num_bins - 1)
+		m = 0;
 
-	return m + 29;
+	return m;
 }
 
 /* return the bitmap weight from the all/upper/lower bins */
-- 
2.3.5

