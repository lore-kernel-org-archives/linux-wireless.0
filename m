Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:52616 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177Ab3AWQiZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2013 11:38:25 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, sven@open-mesh.com,
	rodrigue@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH 4/4] ath9k: Update spectral scan output data
Date: Wed, 23 Jan 2013 17:38:07 +0100
Message-Id: <1358959087-24897-4-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130123_173833_723608_0CBF34F0)
In-Reply-To: <1358959087-24897-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1358959087-24897-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sven Eckelmann <sven@open-mesh.com>

The sample data received through the spectral scan can be either in big or
little endian byteorder. This information isn't stored in the output file.
Therefore it is not possible for the analyzer software to find the correct byte
order.

It is relative common to get the data from a low end AP in big endian mode and
transfer it to another computer in little endian mode to analyze it. Therefore,
it would be better to store it in network (big endian) byte order.

The extension of the 8 bit bins for each bin to 16 bit is not necessary. This
operation can be done in userspace or on a different machine. Instead the
max_exp defining the amount of shifting required for each bin is exported to
userspace.

The change of the output format requires a change of the type in the sample
tlv to allow the userspace program to correctly detect the bin format.

Reported-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Signed-off-by: Sven Eckelmann <sven@open-mesh.com>
[squashed patches, update commit message, rebase]
Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    6 +++---
 drivers/net/wireless/ath/ath9k/recv.c  |   14 ++++++++------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 342edc5..67df864 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -864,7 +864,7 @@ static inline u8 spectral_bitmap_weight(u8 *bins)
  * interface.
  */
 enum ath_fft_sample_type {
-	ATH_FFT_SAMPLE_HT20 = 0,
+	ATH_FFT_SAMPLE_HT20 = 1,
 };
 
 struct fft_sample_tlv {
@@ -876,7 +876,7 @@ struct fft_sample_tlv {
 struct fft_sample_ht20 {
 	struct fft_sample_tlv tlv;
 
-	u8 __alignment;
+	u8 max_exp;
 
 	u16 freq;
 	s8 rssi;
@@ -888,7 +888,7 @@ struct fft_sample_ht20 {
 
 	u64 tsf;
 
-	u16 data[SPECTRAL_HT20_NUM_BINS];
+	u8 data[SPECTRAL_HT20_NUM_BINS];
 } __packed;
 
 void ath9k_tasklet(unsigned long data);
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 13ee37b..2af6f19 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1035,7 +1035,7 @@ static int ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
 	struct ath_radar_info *radar_info;
 	struct ath_ht20_mag_info *mag_info;
 	int len = rs->rs_datalen;
-	int i, dc_pos;
+	int dc_pos;
 
 	/* AR9280 and before report via ATH9K_PHYERR_RADAR, AR93xx and newer
 	 * via ATH9K_PHYERR_SPECTRAL. Haven't seen ATH9K_PHYERR_FALSE_RADAR_EXT
@@ -1064,8 +1064,9 @@ static int ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
 
 	fft_sample.tlv.type = ATH_FFT_SAMPLE_HT20;
 	fft_sample.tlv.length = sizeof(fft_sample) - sizeof(fft_sample.tlv);
+	fft_sample.tlv.length = __cpu_to_be16(fft_sample.tlv.length);
 
-	fft_sample.freq = ah->curchan->chan->center_freq;
+	fft_sample.freq = __cpu_to_be16(ah->curchan->chan->center_freq);
 	fft_sample.rssi = fix_rssi_inv_only(rs->rs_rssi_ctl0);
 	fft_sample.noise = ah->noise;
 
@@ -1105,14 +1106,15 @@ static int ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
 	/* mag data is at the end of the frame, in front of radar_info */
 	mag_info = ((struct ath_ht20_mag_info *)radar_info) - 1;
 
-	/* Apply exponent and grab further auxiliary information. */
-	for (i = 0; i < SPECTRAL_HT20_NUM_BINS; i++)
-		fft_sample.data[i] = bins[i] << mag_info->max_exp;
+	/* copy raw bins without scaling them */
+	memcpy(fft_sample.data, bins, SPECTRAL_HT20_NUM_BINS);
+	fft_sample.max_exp = mag_info->max_exp & 0xf;
 
 	fft_sample.max_magnitude = spectral_max_magnitude(mag_info->all_bins);
+	fft_sample.max_magnitude = __cpu_to_be16(fft_sample.max_magnitude);
 	fft_sample.max_index = spectral_max_index(mag_info->all_bins);
 	fft_sample.bitmap_weight = spectral_bitmap_weight(mag_info->all_bins);
-	fft_sample.tsf = tsf;
+	fft_sample.tsf = __cpu_to_be64(tsf);
 
 	ath_debug_send_fft_sample(sc, &fft_sample.tlv);
 	return 1;
-- 
1.7.10.4

