Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:51368 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbbCTMkH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 08:40:07 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kvalo@codeaurora.org, adrian@freebsd.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 02/18] ath9k: ar9271_hw_pa_cal - use defs instead of magin numbers
Date: Fri, 20 Mar 2015 13:38:42 +0100
Message-Id: <1426855138-6121-3-git-send-email-linux@rempel-privat.de> (sfid-20150320_134016_932446_051220DC)
In-Reply-To: <1426855138-6121-1-git-send-email-linux@rempel-privat.de>
References: <1426855138-6121-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function uses mixed styles for register names/numbers which
is make harder reading and optimisation.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/ar9002_calib.c | 35 ++++++++++++++-------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index 42190b6..4576b99 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -430,22 +430,22 @@ static void ar9271_hw_pa_cal(struct ath_hw *ah, bool is_reset)
 	u32 regVal;
 	unsigned int i;
 	u32 regList[][2] = {
-		{ 0x786c, 0 },
-		{ 0x7854, 0 },
-		{ 0x7820, 0 },
-		{ 0x7824, 0 },
-		{ 0x7868, 0 },
-		{ 0x783c, 0 },
-		{ 0x7838, 0 } ,
-		{ 0x7828, 0 } ,
+		{ AR9285_AN_TOP3, 0 },
+		{ AR9285_AN_RXTXBB1, 0 },
+		{ AR9285_AN_RF2G1, 0 },
+		{ AR9285_AN_RF2G2, 0 },
+		{ AR9285_AN_TOP2, 0 },
+		{ AR9285_AN_RF2G8, 0 },
+		{ AR9285_AN_RF2G7, 0 } ,
+		{ AR9285_AN_RF2G3, 0 } ,
 	};
 
 	for (i = 0; i < ARRAY_SIZE(regList); i++)
 		regList[i][1] = REG_READ(ah, regList[i][0]);
 
-	regVal = REG_READ(ah, 0x7834);
+	regVal = REG_READ(ah, AR9285_AN_RF2G6);
 	regVal &= (~(0x1));
-	REG_WRITE(ah, 0x7834, regVal);
+	REG_WRITE(ah, AR9285_AN_RF2G6, regVal);
 	regVal = REG_READ(ah, 0x9808);
 	regVal |= (0x1 << 27);
 	REG_WRITE(ah, 0x9808, regVal);
@@ -477,7 +477,7 @@ static void ar9271_hw_pa_cal(struct ath_hw *ah, bool is_reset)
 	 * does not matter since we turn it off
 	 */
 	REG_RMW_FIELD(ah, AR9285_AN_RF2G7, AR9285_AN_RF2G7_PADRVGN2TAB0, 0);
-
+	/* 7828, b0-11, ccom=fff */
 	REG_RMW_FIELD(ah, AR9285_AN_RF2G3, AR9271_AN_RF2G3_CCOMP, 0xfff);
 
 	/* Set:
@@ -490,15 +490,16 @@ static void ar9271_hw_pa_cal(struct ath_hw *ah, bool is_reset)
 
 	/* find off_6_1; */
 	for (i = 6; i > 0; i--) {
-		regVal = REG_READ(ah, 0x7834);
+		regVal = REG_READ(ah, AR9285_AN_RF2G6);
 		regVal |= (1 << (20 + i));
-		REG_WRITE(ah, 0x7834, regVal);
+		REG_WRITE(ah, AR9285_AN_RF2G6, regVal);
 		udelay(1);
 		/* regVal = REG_READ(ah, 0x7834); */
 		regVal &= (~(0x1 << (20 + i)));
-		regVal |= (MS(REG_READ(ah, 0x7840), AR9285_AN_RXTXBB1_SPARE9)
+		regVal |= (MS(REG_READ(ah, AR9285_AN_RF2G9),
+			      AR9285_AN_RXTXBB1_SPARE9)
 			    << (20 + i));
-		REG_WRITE(ah, 0x7834, regVal);
+		REG_WRITE(ah, AR9285_AN_RF2G6, regVal);
 	}
 
 	regVal = (regVal >> 20) & 0x7f;
@@ -517,9 +518,9 @@ static void ar9271_hw_pa_cal(struct ath_hw *ah, bool is_reset)
 
 	ENABLE_REGWRITE_BUFFER(ah);
 
-	regVal = REG_READ(ah, 0x7834);
+	regVal = REG_READ(ah, AR_AN_RF2G1_CH1);
 	regVal |= 0x1;
-	REG_WRITE(ah, 0x7834, regVal);
+	REG_WRITE(ah, AR_AN_RF2G1_CH1, regVal);
 	regVal = REG_READ(ah, 0x9808);
 	regVal &= (~(0x1 << 27));
 	REG_WRITE(ah, 0x9808, regVal);
-- 
1.9.1

