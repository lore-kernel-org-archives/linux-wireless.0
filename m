Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plsmtpa01-01.prod.sin2.secureserver.net ([182.50.145.6]:33912
	"EHLO sg2plsmtpa01-01.prod.sin2.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754960Ab2LGKCm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 05:02:42 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 2/8] ath9k_hw: Fix PAPRD training
Date: Fri,  7 Dec 2012 15:31:55 +0530
Message-Id: <1354874521-4138-3-git-send-email-sujith@msujith.org> (sfid-20121207_110259_691386_2D2F8D59)
In-Reply-To: <1354874521-4138-1-git-send-email-sujith@msujith.org>
References: <1354874521-4138-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The PAPRD training control registers have to be
programmed with values that depend on the chip. This patch
ensures that the correct values are chosen for the chip
in use.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c | 36 +++++++++++++++++++++------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
index 0ed3846..2cd23e5 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -204,7 +204,20 @@ static int ar9003_paprd_setup_single_table(struct ath_hw *ah)
 		      AR_PHY_PAPRD_TRAINER_CNTL1_CF_PAPRD_AGC2_SETTLING, 28);
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_TRAINER_CNTL1,
 		      AR_PHY_PAPRD_TRAINER_CNTL1_CF_CF_PAPRD_TRAIN_ENABLE, 1);
-	val = AR_SREV_9462(ah) ? 0x91 : 147;
+
+	if (AR_SREV_9485(ah)) {
+		val = 148;
+	} else {
+		if (IS_CHAN_2GHZ(ah->curchan)) {
+			if (AR_SREV_9462(ah) || AR_SREV_9565(ah))
+				val = 0x91;
+			else
+				val = 147;
+		} else {
+			val = 137;
+		}
+	}
+
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_TRAINER_CNTL2,
 		      AR_PHY_PAPRD_TRAINER_CNTL2_CF_PAPRD_INIT_RX_BB_GAIN, val);
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_TRAINER_CNTL3,
@@ -215,15 +228,24 @@ static int ar9003_paprd_setup_single_table(struct ath_hw *ah)
 		      AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_NUM_CORR_STAGES, 7);
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_TRAINER_CNTL3,
 		      AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_MIN_LOOPBACK_DEL, 1);
-	if (AR_SREV_9485(ah) || AR_SREV_9462(ah) || AR_SREV_9550(ah))
+
+	if (AR_SREV_9485(ah) ||
+	    AR_SREV_9462(ah) ||
+	    AR_SREV_9565(ah) ||
+	    AR_SREV_9550(ah) ||
+	    AR_SREV_9330(ah) ||
+	    AR_SREV_9340(ah))
 		REG_RMW_FIELD(ah, AR_PHY_PAPRD_TRAINER_CNTL3,
-			      AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_QUICK_DROP,
-			      -3);
+			      AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_QUICK_DROP, -3);
 	else
 		REG_RMW_FIELD(ah, AR_PHY_PAPRD_TRAINER_CNTL3,
-			      AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_QUICK_DROP,
-			      -6);
-	val = AR_SREV_9462(ah) ? -10 : -15;
+			      AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_QUICK_DROP, -6);
+
+	val = -10;
+
+	if (IS_CHAN_2GHZ(ah->curchan) && !AR_SREV_9462(ah) && !AR_SREV_9565(ah))
+		val = -15;
+
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_TRAINER_CNTL3,
 		      AR_PHY_PAPRD_TRAINER_CNTL3_CF_PAPRD_ADC_DESIRED_SIZE,
 		      val);
-- 
1.8.0.1

