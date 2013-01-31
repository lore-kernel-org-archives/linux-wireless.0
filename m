Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:42971 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753726Ab3AaJ1Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 04:27:16 -0500
From: Sven Eckelmann <sven@narfation.org>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linville@tuxdriver.com, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5/6] ath9k: Fix sparse __CHECK_ENDIAN__ for spectral code
Date: Thu, 31 Jan 2013 10:26:48 +0100
Message-Id: <1359624409-14815-5-git-send-email-sven@narfation.org> (sfid-20130131_102720_709917_A2B74B92)
In-Reply-To: <1359624409-14815-1-git-send-email-sven@narfation.org>
References: <1359624409-14815-1-git-send-email-sven@narfation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    8 ++++----
 drivers/net/wireless/ath/ath9k/recv.c  |    9 +++++----
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 67df864..5fb99d6 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -869,7 +869,7 @@ enum ath_fft_sample_type {
 
 struct fft_sample_tlv {
 	u8 type;	/* see ath_fft_sample */
-	u16 length;
+	__be16 length;
 	/* type dependent data follows */
 } __packed;
 
@@ -878,15 +878,15 @@ struct fft_sample_ht20 {
 
 	u8 max_exp;
 
-	u16 freq;
+	__be16 freq;
 	s8 rssi;
 	s8 noise;
 
-	u16 max_magnitude;
+	__be16 max_magnitude;
 	u8 max_index;
 	u8 bitmap_weight;
 
-	u64 tsf;
+	__be64 tsf;
 
 	u8 data[SPECTRAL_HT20_NUM_BINS];
 } __packed;
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index e349bff..0910146 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1038,6 +1038,7 @@ static int ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
 	struct ath_ht20_mag_info *mag_info;
 	int len = rs->rs_datalen;
 	int dc_pos;
+	u16 length, max_magnitude;
 
 	/* AR9280 and before report via ATH9K_PHYERR_RADAR, AR93xx and newer
 	 * via ATH9K_PHYERR_SPECTRAL. Haven't seen ATH9K_PHYERR_FALSE_RADAR_EXT
@@ -1065,8 +1066,8 @@ static int ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
 		return 1;
 
 	fft_sample.tlv.type = ATH_FFT_SAMPLE_HT20;
-	fft_sample.tlv.length = sizeof(fft_sample) - sizeof(fft_sample.tlv);
-	fft_sample.tlv.length = __cpu_to_be16(fft_sample.tlv.length);
+	length = sizeof(fft_sample) - sizeof(fft_sample.tlv);
+	fft_sample.tlv.length = __cpu_to_be16(length);
 
 	fft_sample.freq = __cpu_to_be16(ah->curchan->chan->center_freq);
 	fft_sample.rssi = fix_rssi_inv_only(rs->rs_rssi_ctl0);
@@ -1112,8 +1113,8 @@ static int ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
 	memcpy(fft_sample.data, bins, SPECTRAL_HT20_NUM_BINS);
 	fft_sample.max_exp = mag_info->max_exp & 0xf;
 
-	fft_sample.max_magnitude = spectral_max_magnitude(mag_info->all_bins);
-	fft_sample.max_magnitude = __cpu_to_be16(fft_sample.max_magnitude);
+	max_magnitude = spectral_max_magnitude(mag_info->all_bins);
+	fft_sample.max_magnitude = __cpu_to_be16(max_magnitude);
 	fft_sample.max_index = spectral_max_index(mag_info->all_bins);
 	fft_sample.bitmap_weight = spectral_bitmap_weight(mag_info->all_bins);
 	fft_sample.tsf = __cpu_to_be64(tsf);
-- 
1.7.10.4

