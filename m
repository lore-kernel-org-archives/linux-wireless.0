Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:59183 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755394Ab0LBLMs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 06:12:48 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 03:12:34 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 14/27] ath9k_hw: Read spur channel information from eeprom for AR9485
Date: Thu, 2 Dec 2010 03:06:58 -0800
Message-ID: <1291288031-3409-15-git-send-email-vasanth@atheros.com>
In-Reply-To: <1291288031-3409-1-git-send-email-vasanth@atheros.com>
References: <1291288031-3409-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also spur channel count and range is different for AR9485.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   35 ++++++++++++++++++++++++--
 1 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 136e64a..bf686ac 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -154,21 +154,50 @@ static void ar9003_hw_spur_mitigate_mrc_cck(struct ath_hw *ah,
 	static const u32 spur_freq[4] = { 2420, 2440, 2464, 2480 };
 	int cur_bb_spur, negative = 0, cck_spur_freq;
 	int i;
+	int range, max_spur_cnts, synth_freq;
+	u8 *spur_fbin_ptr = NULL;
 
 	/*
 	 * Need to verify range +/- 10 MHz in control channel, otherwise spur
 	 * is out-of-band and can be ignored.
 	 */
 
-	for (i = 0; i < 4; i++) {
+	if (AR_SREV_9485(ah)) {
+		spur_fbin_ptr = ar9003_get_spur_chan_ptr(ah,
+							 IS_CHAN_2GHZ(chan));
+		if (spur_fbin_ptr[0] == 0) /* No spur */
+			return;
+		max_spur_cnts = 5;
+		if (IS_CHAN_HT40(chan)) {
+			range = 19;
+			if (REG_READ_FIELD(ah, AR_PHY_GEN_CTRL,
+					   AR_PHY_GC_DYN2040_PRI_CH) == 0)
+				synth_freq = chan->channel + 10;
+			else
+				synth_freq = chan->channel - 10;
+		} else {
+			range = 10;
+			synth_freq = chan->channel;
+		}
+	} else {
+		range = 10;
+		max_spur_cnts = 4;
+		synth_freq = chan->channel;
+	}
+
+	for (i = 0; i < max_spur_cnts; i++) {
 		negative = 0;
-		cur_bb_spur = spur_freq[i] - chan->channel;
+		if (AR_SREV_9485(ah))
+			cur_bb_spur = FBIN2FREQ(spur_fbin_ptr[i],
+					IS_CHAN_2GHZ(chan)) - synth_freq;
+		else
+			cur_bb_spur = spur_freq[i] - synth_freq;
 
 		if (cur_bb_spur < 0) {
 			negative = 1;
 			cur_bb_spur = -cur_bb_spur;
 		}
-		if (cur_bb_spur < 10) {
+		if (cur_bb_spur < range) {
 			cck_spur_freq = (int)((cur_bb_spur << 19) / 11);
 
 			if (negative == 1)
-- 
1.7.0.4

