Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64487 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab0KWT22 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 14:28:28 -0500
Received: by eye27 with SMTP id 27so4893631eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 11:28:27 -0800 (PST)
Date: Tue, 23 Nov 2010 21:28:15 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Subject: [PATCH 20/30] ath5k: Update spur mitigation filter for
 turbo/half/quarter
Message-ID: <20101123192815.GT4303@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Add spur mitigation filter support for half/quarter and turbo.

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/phy.c |   53 ++++++++++++++++++++-------------
 1 files changed, 32 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 6913a52..b908915 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1622,7 +1622,7 @@ ath5k_hw_set_spur_mitigation_filter(struct ath5k_hw *ah,
 	spur_chan_fbin = AR5K_EEPROM_NO_SPUR;
 	spur_detection_window = AR5K_SPUR_CHAN_WIDTH;
 	/* XXX: Half/Quarter channels ?*/
-	if (channel->hw_value & CHANNEL_TURBO)
+	if (ah->ah_bwmode == AR5K_BWMODE_40MHZ)
 		spur_detection_window *= 2;
 
 	for (i = 0; i < AR5K_EEPROM_N_SPUR_CHANS; i++) {
@@ -1651,32 +1651,43 @@ ath5k_hw_set_spur_mitigation_filter(struct ath5k_hw *ah,
 		 * Calculate deltas:
 		 * spur_freq_sigma_delta -> spur_offset / sample_freq << 21
 		 * spur_delta_phase -> spur_offset / chip_freq << 11
-		 * Note: Both values have 100KHz resolution
+		 * Note: Both values have 100Hz resolution
 		 */
-		/* XXX: Half/Quarter rate channels ? */
-		switch (channel->hw_value) {
-		case CHANNEL_A:
-			/* Both sample_freq and chip_freq are 40MHz */
-			spur_delta_phase = (spur_offset << 17) / 25;
-			spur_freq_sigma_delta = (spur_delta_phase >> 10);
-			symbol_width = AR5K_SPUR_SYMBOL_WIDTH_BASE_100Hz;
-			break;
-		case CHANNEL_G:
-			/* sample_freq -> 40MHz chip_freq -> 44MHz
-			 * (for b compatibility) */
-			spur_freq_sigma_delta = (spur_offset << 8) / 55;
-			spur_delta_phase = (spur_offset << 17) / 25;
-			symbol_width = AR5K_SPUR_SYMBOL_WIDTH_BASE_100Hz;
-			break;
-		case CHANNEL_T:
-		case CHANNEL_TG:
+		switch (ah->ah_bwmode) {
+		case AR5K_BWMODE_40MHZ:
 			/* Both sample_freq and chip_freq are 80MHz */
 			spur_delta_phase = (spur_offset << 16) / 25;
 			spur_freq_sigma_delta = (spur_delta_phase >> 10);
-			symbol_width = AR5K_SPUR_SYMBOL_WIDTH_TURBO_100Hz;
+			symbol_width = AR5K_SPUR_SYMBOL_WIDTH_BASE_100Hz * 2;
 			break;
+		case AR5K_BWMODE_10MHZ:
+			/* Both sample_freq and chip_freq are 20MHz (?) */
+			spur_delta_phase = (spur_offset << 18) / 25;
+			spur_freq_sigma_delta = (spur_delta_phase >> 10);
+			symbol_width = AR5K_SPUR_SYMBOL_WIDTH_BASE_100Hz / 2;
+		case AR5K_BWMODE_5MHZ:
+			/* Both sample_freq and chip_freq are 10MHz (?) */
+			spur_delta_phase = (spur_offset << 19) / 25;
+			spur_freq_sigma_delta = (spur_delta_phase >> 10);
+			symbol_width = AR5K_SPUR_SYMBOL_WIDTH_BASE_100Hz / 4;
 		default:
-			return;
+			if (channel->hw_value == CHANNEL_A) {
+				/* Both sample_freq and chip_freq are 40MHz */
+				spur_delta_phase = (spur_offset << 17) / 25;
+				spur_freq_sigma_delta =
+						(spur_delta_phase >> 10);
+				symbol_width =
+					AR5K_SPUR_SYMBOL_WIDTH_BASE_100Hz;
+			} else {
+				/* sample_freq -> 40MHz chip_freq -> 44MHz
+				 * (for b compatibility) */
+				spur_delta_phase = (spur_offset << 17) / 25;
+				spur_freq_sigma_delta =
+						(spur_offset << 8) / 55;
+				symbol_width =
+					AR5K_SPUR_SYMBOL_WIDTH_BASE_100Hz;
+			}
+			break;
 		}
 
 		/* Calculate pilot and magnitude masks */
