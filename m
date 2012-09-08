Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22934 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab2IHHc0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Sep 2012 03:32:26 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20554.62374.945320.866841@gargle.gargle.HOWL> (sfid-20120908_093228_928739_FBD1AF67)
Date: Sat, 8 Sep 2012 12:58:38 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [RFC 6/7] ath9k_hw: Program correct PLL value for AR9565
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 063d724..07dd330 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -837,6 +837,9 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 		REG_RMW_FIELD(ah, AR_CH0_BB_DPLL2,
 			      AR_CH0_BB_DPLL2_PLL_PWD, 0x0);
 		udelay(1000);
+
+		if (AR_SREV_9565(ah))
+			REG_WRITE(ah, AR_RTC_PLL_CONTROL, 0x4142c);
 	} else if (AR_SREV_9330(ah)) {
 		u32 ddr_dpll2, pll_control2, kd;
 
@@ -917,9 +920,10 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 		udelay(1000);
 	}
 
-	pll = ath9k_hw_compute_pll_control(ah, chan);
-
-	REG_WRITE(ah, AR_RTC_PLL_CONTROL, pll);
+	if (!AR_SREV_9565(ah)) {
+		pll = ath9k_hw_compute_pll_control(ah, chan);
+		REG_WRITE(ah, AR_RTC_PLL_CONTROL, pll);
+	}
 
 	if (AR_SREV_9485(ah) || AR_SREV_9340(ah) || AR_SREV_9330(ah) ||
 	    AR_SREV_9550(ah))
-- 
1.7.12

