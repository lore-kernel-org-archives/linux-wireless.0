Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:49996 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731127AbeISQOj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 12:14:39 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 4/5] ath9k: FFT magnitude check: don't consider lower 3 data bits
Date: Wed, 19 Sep 2018 12:37:10 +0200
Message-Id: <20180919103711.19304-5-sw@simonwunderlich.de> (sfid-20180919_123724_220736_87E7DC96)
In-Reply-To: <20180919103711.19304-1-sw@simonwunderlich.de>
References: <20180919103711.19304-1-sw@simonwunderlich.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There were a lot of Magnitude Mismatch while getting FFT samples on my
hardware (Atheros AR9462. I've compared the reported magnitude with
the data in the FFT bin, and the FFT bin was less accurate:

[ 5395.193030] ath: phy0: FFT HT20 frame: max mag 0x89,max_mag_idx 28,
,magnitude 0x89 max_exp 0, data[28] = 0x88
[ 5395.194525] ath: phy0: FFT HT20 frame: max mag 0x89,max_mag_idx 28,
,magnitude 0x89 max_exp 0, data[28] = 0x88
[ 5395.196012] ath: phy0: FFT HT20 frame: max mag 0x88,max_mag_idx 28,
,magnitude 0x88 max_exp 0, data[28] = 0x88
[ 5395.197509] ath: phy0: FFT HT20 frame: max mag 0x6C,max_mag_idx 28,
,magnitude 0x6C max_exp 0, data[28] = 0x68
[ 5395.199015] ath: phy0: FFT HT20 frame: max mag 0x78,max_mag_idx 28,
,magnitude 0x78 max_exp 0, data[28] = 0x78
[ 5395.200497] ath: phy0: FFT HT20 frame: max mag 0xA1,max_mag_idx 28,
,magnitude 0xA1 max_exp 0, data[28] = 0xA0
[ 5395.202011] ath: phy0: FFT HT20 frame: max mag 0x91,max_mag_idx 28,
,magnitude 0x91 max_exp 0, data[28] = 0x90
[ 5395.203482] ath: phy0: FFT HT20 frame: max mag 0x89,max_mag_idx 28,
,magnitude 0x89 max_exp 0, data[28] = 0x88
[ 5395.204999] ath: phy0: FFT HT20 frame: max mag 0x27,max_mag_idx 4,
,magnitude 0x27 max_exp 0, data[4] = 0x20
[ 5395.206461] ath: phy0: FFT HT20 frame: max mag 0x41,max_mag_idx 28,
,magnitude 0x41 max_exp 0, data[28] = 0x40
[ 5395.207977] ath: phy0: FFT HT20 frame: max mag 0x51,max_mag_idx 28,
,magnitude 0x51 max_exp 0, data[28] = 0x50
[ 5395.209454] ath: phy0: FFT HT20 frame: max mag 0x53,max_mag_idx 28,
,magnitude 0x53 max_exp 0, data[28] = 0x50
[ 5395.210940] ath: phy0: FFT HT20 frame: max mag 0x40,max_mag_idx 28,
,magnitude 0x40 max_exp 0, data[28] = 0x40
[ 5395.212441] ath: phy0: FFT HT20 frame: max mag 0x59,max_mag_idx 28,
,magnitude 0x59 max_exp 0, data[28] = 0x58
[ 5395.213932] ath: phy0: FFT HT20 frame: max mag 0x53,max_mag_idx 28,
,magnitude 0x53 max_exp 0, data[28] = 0x50
[ 5395.215428] ath: phy0: FFT HT20 frame: max mag 0x7D,max_mag_idx 28,
,magnitude 0x7D max_exp 0, data[28] = 0x78
[ 5395.216910] ath: phy0: FFT HT20 frame: max mag 0x8C,max_mag_idx 28,
,magnitude 0x8C max_exp 0, data[28] = 0x88
[ 5395.218413] ath: phy0: FFT HT20 frame: max mag 0x7B,max_mag_idx 28,
,magnitude 0x7B max_exp 0, data[28] = 0x78
[ 5395.219900] ath: phy0: FFT HT20 frame: max mag 0x43,max_mag_idx 28,
,magnitude 0x43 max_exp 0, data[28] = 0x40

It seems like the lower 3 bits on my hardware are always zeroed, but the
magnitude matches otherwise. Therefore, let's not make the magnitude
check so strict so we can get those samples released to userspace.

Cc: Nick Kossifidis <mickflemm@gmail.com>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 drivers/net/wireless/ath/ath9k/common-spectral.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.c b/drivers/net/wireless/ath/ath9k/common-spectral.c
index d10e3f29c356..70ddaf6199a0 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.c
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.c
@@ -71,7 +71,7 @@ ath_cmn_max_idx_verify_ht20_fft(u8 *sample_end, int bytes_read)
 	if (bytes_read < SPECTRAL_HT20_SAMPLE_LEN && max_index < 1)
 		return -1;
 
-	if (sample[max_index] != (max_magnitude >> max_exp))
+	if ((sample[max_index] & 0xf8) != ((max_magnitude >> max_exp) & 0xf8))
 		return -1;
 	else
 		return 0;
@@ -114,8 +114,10 @@ ath_cmn_max_idx_verify_ht20_40_fft(u8 *sample_end, int bytes_read)
 	   ((upper_max_index < 1) || (lower_max_index < 1)))
 		return -1;
 
-	if ((sample[upper_max_index + dc_pos] != (upper_mag >> max_exp)) ||
-	   (sample[lower_max_index] != (lower_mag >> max_exp)))
+	if (((sample[upper_max_index + dc_pos] & 0xf8) !=
+	     ((upper_mag >> max_exp) & 0xf8)) ||
+	    ((sample[lower_max_index] & 0xf8) !=
+	     ((lower_mag >> max_exp) & 0xf8)))
 		return -1;
 	else
 		return 0;
@@ -173,7 +175,8 @@ ath_cmn_process_ht20_fft(struct ath_rx_status *rs,
 					magnitude >> max_exp,
 					max_index);
 
-	if (fft_sample_20.data[max_index] != (magnitude >> max_exp)) {
+	if ((fft_sample_20.data[max_index] & 0xf8) !=
+	    ((magnitude >> max_exp) & 0xf8)) {
 		ath_dbg(common, SPECTRAL_SCAN, "Magnitude mismatch !\n");
 		ret = -1;
 	}
@@ -317,10 +320,10 @@ ath_cmn_process_ht20_40_fft(struct ath_rx_status *rs,
 	/* Check if we got the expected magnitude values at
 	 * the expected bins
 	 */
-	if ((fft_sample_40.data[upper_max_index + dc_pos]
-	    != (upper_mag >> max_exp)) ||
-	   (fft_sample_40.data[lower_max_index]
-	    != (lower_mag >> max_exp))) {
+	if (((fft_sample_40.data[upper_max_index + dc_pos] & 0xf8)
+	    != ((upper_mag >> max_exp) & 0xf8)) ||
+	   ((fft_sample_40.data[lower_max_index] & 0xf8)
+	    != ((lower_mag >> max_exp) & 0xf8))) {
 		ath_dbg(common, SPECTRAL_SCAN, "Magnitude mismatch !\n");
 		ret = -1;
 	}
-- 
2.11.0
