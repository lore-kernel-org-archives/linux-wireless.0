Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:34456 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaKFFAo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 00:00:44 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	stable@vger.kernel.org
Subject: [PATCH] ath9k: Fix RTC_DERIVED_CLK usage
Date: Thu,  6 Nov 2014 10:32:03 +0530
Message-Id: <1415250123-16055-1-git-send-email-sujith@msujith.org> (sfid-20141106_060048_297701_1A158F15)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

From: Miaoqing Pan <miaoqing@qca.qualcomm.com>

Based on the reference clock, which could be 25MHz or 40MHz,
AR_RTC_DERIVED_CLK is programmed differently for AR9340 and AR9550.
But, when a chip reset is done, processing the initvals
sets the register back to the default value.

Fix this by moving the code in ath9k_hw_init_pll() to
ar9003_hw_override_ini(). Also, do this override for AR9531.

Cc: stable@vger.kernel.org
Signed-off-by: Miaoqing Pan <miaoqing@qca.qualcomm.com>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 13 +++++++++++++
 drivers/net/wireless/ath/ath9k/hw.c         | 13 -------------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 9bdaa0a..2df6d2e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -664,6 +664,19 @@ static void ar9003_hw_override_ini(struct ath_hw *ah)
 		ah->enabled_cals |= TX_CL_CAL;
 	else
 		ah->enabled_cals &= ~TX_CL_CAL;
+
+	if (AR_SREV_9340(ah) || AR_SREV_9531(ah) || AR_SREV_9550(ah)) {
+		if (ah->is_clk_25mhz) {
+			REG_WRITE(ah, AR_RTC_DERIVED_CLK, 0x17c << 1);
+			REG_WRITE(ah, AR_SLP32_MODE, 0x0010f3d7);
+			REG_WRITE(ah, AR_SLP32_INC, 0x0001e7ae);
+		} else {
+			REG_WRITE(ah, AR_RTC_DERIVED_CLK, 0x261 << 1);
+			REG_WRITE(ah, AR_SLP32_MODE, 0x0010f400);
+			REG_WRITE(ah, AR_SLP32_INC, 0x0001e800);
+		}
+		udelay(100);
+	}
 }
 
 static void ar9003_hw_prog_ini(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index ee9fb52..04ae1f8 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -870,19 +870,6 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 	udelay(RTC_PLL_SETTLE_DELAY);
 
 	REG_WRITE(ah, AR_RTC_SLEEP_CLK, AR_RTC_FORCE_DERIVED_CLK);
-
-	if (AR_SREV_9340(ah) || AR_SREV_9550(ah)) {
-		if (ah->is_clk_25mhz) {
-			REG_WRITE(ah, AR_RTC_DERIVED_CLK, 0x17c << 1);
-			REG_WRITE(ah, AR_SLP32_MODE, 0x0010f3d7);
-			REG_WRITE(ah,  AR_SLP32_INC, 0x0001e7ae);
-		} else {
-			REG_WRITE(ah, AR_RTC_DERIVED_CLK, 0x261 << 1);
-			REG_WRITE(ah, AR_SLP32_MODE, 0x0010f400);
-			REG_WRITE(ah,  AR_SLP32_INC, 0x0001e800);
-		}
-		udelay(100);
-	}
 }
 
 static void ath9k_hw_init_interrupt_masks(struct ath_hw *ah,
-- 
2.1.3

