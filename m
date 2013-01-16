Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht1.myhostedexchange.com ([69.50.2.37]:18568 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752613Ab3APTqy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 14:46:54 -0500
From: Sven Eckelmann <sven@open-mesh.com>
To: <linux-wireless@vger.kernel.org>
CC: <ath9k-devel@lists.ath9k.org>, <zefir.kurtisi@neratec.com>,
	<simon.wunderlich@s2003.tu-chemnitz.de>,
	<tobias.steinicke@net.t-labs.tu-berlin.de>,
	<mathias.kretschmer@fokus.fraunhofer.de>,
	<achadd@qca.qualcomm.com>, Sven Eckelmann <sven@open-mesh.com>
Subject: [RFC] ath9k: Don't preshift spectral scan bins
Date: Wed, 16 Jan 2013 20:46:39 +0100
Message-ID: <1358365599-16122-1-git-send-email-sven@open-mesh.com> (sfid-20130116_204658_025130_BE4CB52B)
In-Reply-To: <50F6CE89.5060106@neratec.com>
References: <50F6CE89.5060106@neratec.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The extension of the 8 bit bins for each bin to 16 bit is not necessary. This
operation can be done in userspace or on a different machine. Instead the
max_exp defining the amount of shifting required for each bin is exported to
userspace.

The change of the output format requires a change of the type in the sample
tlv to allow the userspace program to correctly detect the bin format.

Reported-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Signed-off-by: Sven Eckelmann <sven@open-mesh.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    6 +++---
 drivers/net/wireless/ath/ath9k/recv.c  |   10 ++++------
 2 files changed, 7 insertions(+), 9 deletions(-)

This patch requires the previous patch
"[PATCH] ath9k: Save spectral scan data in network byteorder"

Please discuss the final format before this patch is applied.

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 8250330..cc6b786 100644
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
index 2fac787..717ca9d 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1035,7 +1035,7 @@ static void ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
 	struct ath_radar_info *radar_info;
 	struct ath_ht20_mag_info *mag_info;
 	int len = rs->rs_datalen;
-	int i, dc_pos;
+	int dc_pos;
 
 	/* AR9280 and before report via ATH9K_PHYERR_RADAR, AR93xx and newer
 	 * via ATH9K_PHYERR_SPECTRAL. Haven't seen ATH9K_PHYERR_FALSE_RADAR_EXT
@@ -1106,11 +1106,9 @@ static void ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
 	/* mag data is at the end of the frame, in front of radar_info */
 	mag_info = ((struct ath_ht20_mag_info *)radar_info) - 1;
 
-	/* Apply exponent and grab further auxiliary information. */
-	for (i = 0; i < SPECTRAL_HT20_NUM_BINS; i++) {
-		fft_sample.data[i] = bins[i] << mag_info->max_exp;
-		fft_sample.data[i] = __cpu_to_be16(fft_sample.data[i]);
-	}
+	/* copy raw bins without scaling them */
+	memcpy(fft_sample.data, bins, SPECTRAL_HT20_NUM_BINS);
+	fft_sample.max_exp = mag_info->max_exp & 0xf;
 
 	fft_sample.max_magnitude = spectral_max_magnitude(mag_info->all_bins);
 	fft_sample.max_magnitude = __cpu_to_be16(fft_sample.max_magnitude);
-- 
1.7.10.4

