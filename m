Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plout10-02.prod.sin2.secureserver.net ([182.50.145.5]:48374
	"EHLO sg2plout10-02.prod.sin2.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756647Ab3AHP2w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2013 10:28:52 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] ath9k_hw: Fix radio programming for AR9550
Date: Tue,  8 Jan 2013 20:57:53 +0530
Message-Id: <1357658873-14896-3-git-send-email-sujith@msujith.org> (sfid-20130108_162856_648846_B63FF6E1)
In-Reply-To: <1357658873-14896-1-git-send-email-sujith@msujith.org>
References: <1357658873-14896-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

For AR9550, program the synth value based on the ref. clock.
The logic for AR9550 is similar to AR9330, but keep the code
separate since changes for AR9330 are required - which would be
done later.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 31 ++++++++++++++++-------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index ce19c09..0c4c5a6 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -68,7 +68,7 @@ static const int m2ThreshExt_off = 127;
 static int ar9003_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 {
 	u16 bMode, fracMode = 0, aModeRefSel = 0;
-	u32 freq, channelSel = 0, reg32 = 0;
+	u32 freq, chan_frac, div, channelSel = 0, reg32 = 0;
 	struct chan_centers centers;
 	int loadSynthChannel;
 
@@ -77,9 +77,6 @@ static int ar9003_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 
 	if (freq < 4800) {     /* 2 GHz, fractional mode */
 		if (AR_SREV_9330(ah)) {
-			u32 chan_frac;
-			u32 div;
-
 			if (ah->is_clk_25mhz)
 				div = 75;
 			else
@@ -89,34 +86,40 @@ static int ar9003_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 			chan_frac = (((freq * 4) % div) * 0x20000) / div;
 			channelSel = (channelSel << 17) | chan_frac;
 		} else if (AR_SREV_9485(ah) || AR_SREV_9565(ah)) {
-			u32 chan_frac;
-
 			/*
-			 * freq_ref = 40 / (refdiva >> amoderefsel); where refdiva=1 and amoderefsel=0
+			 * freq_ref = 40 / (refdiva >> amoderefsel);
+			 * where refdiva=1 and amoderefsel=0
 			 * ndiv = ((chan_mhz * 4) / 3) / freq_ref;
 			 * chansel = int(ndiv), chanfrac = (ndiv - chansel) * 0x20000
 			 */
 			channelSel = (freq * 4) / 120;
 			chan_frac = (((freq * 4) % 120) * 0x20000) / 120;
 			channelSel = (channelSel << 17) | chan_frac;
-		} else if (AR_SREV_9340(ah) || AR_SREV_9550(ah)) {
+		} else if (AR_SREV_9340(ah)) {
 			if (ah->is_clk_25mhz) {
-				u32 chan_frac;
-
 				channelSel = (freq * 2) / 75;
 				chan_frac = (((freq * 2) % 75) * 0x20000) / 75;
 				channelSel = (channelSel << 17) | chan_frac;
-			} else
+			} else {
 				channelSel = CHANSEL_2G(freq) >> 1;
-		} else
+			}
+		} else if (AR_SREV_9550(ah)) {
+			if (ah->is_clk_25mhz)
+				div = 75;
+			else
+				div = 120;
+
+			channelSel = (freq * 4) / div;
+			chan_frac = (((freq * 4) % div) * 0x20000) / div;
+			channelSel = (channelSel << 17) | chan_frac;
+		} else {
 			channelSel = CHANSEL_2G(freq);
+		}
 		/* Set to 2G mode */
 		bMode = 1;
 	} else {
 		if ((AR_SREV_9340(ah) || AR_SREV_9550(ah)) &&
 		    ah->is_clk_25mhz) {
-			u32 chan_frac;
-
 			channelSel = freq / 75;
 			chan_frac = ((freq % 75) * 0x20000) / 75;
 			channelSel = (channelSel << 17) | chan_frac;
-- 
1.8.1

