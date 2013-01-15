Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht1.myhostedexchange.com ([69.50.2.37]:64089 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751636Ab3AOMIU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jan 2013 07:08:20 -0500
From: Sven Eckelmann <sven@open-mesh.com>
To: <linux-wireless@vger.kernel.org>
CC: <ath9k-devel@lists.ath9k.org>, Sven Eckelmann <sven@open-mesh.com>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH] ath9k: Save spectral scan data in network byteorder
Date: Tue, 15 Jan 2013 13:02:43 +0100
Message-ID: <1358251363-14385-1-git-send-email-sven@open-mesh.com> (sfid-20130115_130823_978881_4419D471)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The sample data received through the spectral scan can be either in big or
little endian byteorder. This information isn't stored in the output file.
Therefore it is not possible for the analyzer software to find the correct byte
order.

It is relative common to get the data from a low end AP in big endian mode and
transfer it to another computer in little endian mode to analyze it. Therefore,
it would be better to store it in network (big endian) byte order.

Signed-off-by: Sven Eckelmann <sven@open-mesh.com>
Cc: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
A patch for FFT_eval was also sent to the author.

 drivers/net/wireless/ath/ath9k/recv.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index d7c129b..2fac787 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1064,8 +1064,9 @@ static void ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
 
 	fft_sample.tlv.type = ATH_FFT_SAMPLE_HT20;
 	fft_sample.tlv.length = sizeof(fft_sample) - sizeof(fft_sample.tlv);
+	fft_sample.tlv.length = __cpu_to_be16(fft_sample.tlv.length);
 
-	fft_sample.freq = ah->curchan->chan->center_freq;
+	fft_sample.freq = __cpu_to_be16(ah->curchan->chan->center_freq);
 	fft_sample.rssi = fix_rssi_inv_only(rs->rs_rssi_ctl0);
 	fft_sample.noise = ah->noise;
 
@@ -1106,13 +1107,16 @@ static void ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
 	mag_info = ((struct ath_ht20_mag_info *)radar_info) - 1;
 
 	/* Apply exponent and grab further auxiliary information. */
-	for (i = 0; i < SPECTRAL_HT20_NUM_BINS; i++)
+	for (i = 0; i < SPECTRAL_HT20_NUM_BINS; i++) {
 		fft_sample.data[i] = bins[i] << mag_info->max_exp;
+		fft_sample.data[i] = __cpu_to_be16(fft_sample.data[i]);
+	}
 
 	fft_sample.max_magnitude = spectral_max_magnitude(mag_info->all_bins);
+	fft_sample.max_magnitude = __cpu_to_be16(fft_sample.max_magnitude);
 	fft_sample.max_index = spectral_max_index(mag_info->all_bins);
 	fft_sample.bitmap_weight = spectral_bitmap_weight(mag_info->all_bins);
-	fft_sample.tsf = tsf;
+	fft_sample.tsf = __cpu_to_be64(tsf);
 
 	ath_debug_send_fft_sample(sc, &fft_sample.tlv);
 #endif
-- 
1.7.10.4

