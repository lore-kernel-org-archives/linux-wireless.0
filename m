Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35854 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848Ab1GIENQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jul 2011 00:13:16 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 1/9] ath9k_hw: remove hardcoded PLL overrides for AR9280
Date: Sat,  9 Jul 2011 11:12:46 +0700
Message-Id: <1310184774-32913-1-git-send-email-nbd@openwrt.org> (sfid-20110709_061320_207160_F7E4003C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the proper masks for the register instead.
Fixes adding the (still unused) half/quarter PLL flags.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9002_phy.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index 2fe0a34..abc2cc8 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -447,26 +447,27 @@ static void ar9002_olc_init(struct ath_hw *ah)
 static u32 ar9002_hw_compute_pll_control(struct ath_hw *ah,
 					 struct ath9k_channel *chan)
 {
+	int ref_div = 5;
+	int pll_div = 0x2c;
 	u32 pll;
 
-	pll = SM(0x5, AR_RTC_9160_PLL_REFDIV);
+	if (chan && IS_CHAN_5GHZ(chan) && !IS_CHAN_A_FAST_CLOCK(ah, chan)) {
+		if (AR_SREV_9280_20(ah)) {
+			ref_div = 10;
+			pll_div = 0x50;
+		} else {
+			pll_div = 0x28;
+		}
+	}
+
+	pll = SM(ref_div, AR_RTC_9160_PLL_REFDIV);
+	pll |= SM(pll_div, AR_RTC_9160_PLL_DIV);
 
 	if (chan && IS_CHAN_HALF_RATE(chan))
 		pll |= SM(0x1, AR_RTC_9160_PLL_CLKSEL);
 	else if (chan && IS_CHAN_QUARTER_RATE(chan))
 		pll |= SM(0x2, AR_RTC_9160_PLL_CLKSEL);
 
-	if (chan && IS_CHAN_5GHZ(chan)) {
-		if (IS_CHAN_A_FAST_CLOCK(ah, chan))
-			pll = 0x142c;
-		else if (AR_SREV_9280_20(ah))
-			pll = 0x2850;
-		else
-			pll |= SM(0x28, AR_RTC_9160_PLL_DIV);
-	} else {
-		pll |= SM(0x2c, AR_RTC_9160_PLL_DIV);
-	}
-
 	return pll;
 }
 
-- 
1.7.3.2

