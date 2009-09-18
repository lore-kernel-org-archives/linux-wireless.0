Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:44861 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756089AbZIRJg6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2009 05:36:58 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2009 02:37:02 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19123.21695.623174.674651@gargle.gargle.HOWL>
Date: Fri, 18 Sep 2009 15:07:03 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 7/9] ath9k: Reduce PLL Settle time and eliminate redundant PLL calls.
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Senthil Balasubramanian <senthilkumar@atheros.com>

Reduce PLL Settle time and eliminate redundant PLL calls. Also reduce
the LoadNF timeout from 10 msec to 250usec as the 10 msec timeout was
hit with AR9285 in some cases.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |    4 ++--
 drivers/net/wireless/ath/ath9k/hw.c    |   15 +++++++++++----
 drivers/net/wireless/ath/ath9k/hw.h    |    2 +-
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 9c46b54..d347ea7 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -653,11 +653,11 @@ void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 		    AR_PHY_AGC_CONTROL_NO_UPDATE_NF);
 	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_NF);
 
-	for (j = 0; j < 1000; j++) {
+	for (j = 0; j < 5; j++) {
 		if ((REG_READ(ah, AR_PHY_AGC_CONTROL) &
 		     AR_PHY_AGC_CONTROL_NF) == 0)
 			break;
-		udelay(10);
+		udelay(50);
 	}
 
 	for (i = 0; i < NUM_NF_READINGS; i++) {
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index a347b40..99c0dac 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1691,8 +1691,6 @@ static bool ath9k_hw_set_reset(struct ath_hw *ah, int type)
 	if (!AR_SREV_9100(ah))
 		REG_WRITE(ah, AR_RC, 0);
 
-	ath9k_hw_init_pll(ah, NULL);
-
 	if (AR_SREV_9100(ah))
 		udelay(50);
 
@@ -2885,6 +2883,7 @@ static bool ath9k_hw_set_power_awake(struct ath_hw *ah, int setChip)
 					   ATH9K_RESET_POWER_ON) != true) {
 				return false;
 			}
+			ath9k_hw_init_pll(ah, NULL);
 		}
 		if (AR_SREV_9100(ah))
 			REG_SET_BIT(ah, AR_RTC_RESET,
@@ -3968,7 +3967,11 @@ void ath9k_hw_setrxfilter(struct ath_hw *ah, u32 bits)
 
 bool ath9k_hw_phy_disable(struct ath_hw *ah)
 {
-	return ath9k_hw_set_reset_reg(ah, ATH9K_RESET_WARM);
+	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_WARM))
+		return false;
+
+	ath9k_hw_init_pll(ah, NULL);
+	return true;
 }
 
 bool ath9k_hw_disable(struct ath_hw *ah)
@@ -3976,7 +3979,11 @@ bool ath9k_hw_disable(struct ath_hw *ah)
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
 		return false;
 
-	return ath9k_hw_set_reset_reg(ah, ATH9K_RESET_COLD);
+	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_COLD))
+		return false;
+
+	ath9k_hw_init_pll(ah, NULL);
+	return true;
 }
 
 void ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit)
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 6673a81..773f5c4 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -102,7 +102,7 @@
 #define AR_GPIO_BIT(_gpio)          (1 << (_gpio))
 
 #define BASE_ACTIVATE_DELAY         100
-#define RTC_PLL_SETTLE_DELAY        1000
+#define RTC_PLL_SETTLE_DELAY        100
 #define COEF_SCALE_S                24
 #define HT40_CHANNEL_CENTER_SHIFT   10
 
-- 
1.6.4.4

