Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:43243 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab3H0GIX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 02:08:23 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Enable D3/L1 ASPM fix for AR9462
Date: Tue, 27 Aug 2013 11:34:39 +0530
Message-Id: <1377583479-16280-1-git-send-email-sujith@msujith.org> (sfid-20130827_080825_570100_0356DBD2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

AR9462 requires this HW fix for ASPM to work properly.
Also, since WARegVal is used only for the AR8003 family,
use AR_SREV_9300_20_OR_LATER.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index ec47c50..ecc6ec4 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -574,18 +574,17 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	 * We need to do this to avoid RMW of this register. We cannot
 	 * read the reg when chip is asleep.
 	 */
-	ah->WARegVal = REG_READ(ah, AR_WA);
-	ah->WARegVal |= (AR_WA_D3_L1_DISABLE |
-			 AR_WA_ASPM_TIMER_BASED_DISABLE);
+	if (AR_SREV_9300_20_OR_LATER(ah)) {
+		ah->WARegVal = REG_READ(ah, AR_WA);
+		ah->WARegVal |= (AR_WA_D3_L1_DISABLE |
+				 AR_WA_ASPM_TIMER_BASED_DISABLE);
+	}
 
 	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON)) {
 		ath_err(common, "Couldn't reset chip\n");
 		return -EIO;
 	}
 
-	if (AR_SREV_9462(ah))
-		ah->WARegVal &= ~AR_WA_D3_L1_DISABLE;
-
 	if (AR_SREV_9565(ah)) {
 		ah->WARegVal |= AR_WA_BIT22;
 		REG_WRITE(ah, AR_WA, ah->WARegVal);
-- 
1.8.4

