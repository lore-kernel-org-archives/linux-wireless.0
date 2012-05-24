Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30950 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab2EXEFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2012 00:05:07 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20413.45875.660660.458659@gargle.gargle.HOWL> (sfid-20120524_060513_721995_ABC2879D)
Date: Thu, 24 May 2012 09:34:03 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 21/22] ath9k_hw: fix power state for MCI
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

Program MCI related power registers only if MCI interrupts
are enabled. This could help to reduce power consumptions when
WLAN alone is enabled in BT coex chips.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 9e8fef2..d13211d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2006,12 +2006,9 @@ static void ath9k_set_power_sleep(struct ath_hw *ah)
 	REG_SET_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
 
 	if (AR_SREV_9462(ah)) {
-		REG_WRITE(ah, AR_TIMER_MODE,
-			  REG_READ(ah, AR_TIMER_MODE) & 0xFFFFFF00);
-		REG_WRITE(ah, AR_NDP2_TIMER_MODE,
-			  REG_READ(ah, AR_NDP2_TIMER_MODE) & 0xFFFFFF00);
-		REG_WRITE(ah, AR_SLP32_INC,
-			  REG_READ(ah, AR_SLP32_INC) & 0xFFF00000);
+		REG_CLR_BIT(ah, AR_TIMER_MODE, 0xff);
+		REG_CLR_BIT(ah, AR_NDP2_TIMER_MODE, 0xff);
+		REG_CLR_BIT(ah, AR_SLP32_INC, 0xfffff);
 		/* xxx Required for WLAN only case ? */
 		REG_WRITE(ah, AR_MCI_INTERRUPT_RX_MSG_EN, 0);
 		udelay(100);
@@ -2023,7 +2020,7 @@ static void ath9k_set_power_sleep(struct ath_hw *ah)
 	 */
 	REG_CLR_BIT(ah, AR_RTC_FORCE_WAKE, AR_RTC_FORCE_WAKE_EN);
 
-	if (AR_SREV_9462(ah))
+	if (ath9k_hw_mci_is_enabled(ah))
 		udelay(100);
 
 	if (!AR_SREV_9100(ah) && !AR_SREV_9300_20_OR_LATER(ah))
@@ -2048,7 +2045,6 @@ static void ath9k_set_power_sleep(struct ath_hw *ah)
 static void ath9k_set_power_network_sleep(struct ath_hw *ah)
 {
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
-	u32 val;
 
 	REG_SET_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
 
@@ -2067,19 +2063,16 @@ static void ath9k_set_power_network_sleep(struct ath_hw *ah)
 		 * SYS_WAKING and SYS_SLEEPING messages which will make
 		 * BT CPU to busy to process.
 		 */
-		if (AR_SREV_9462(ah)) {
-			val = REG_READ(ah, AR_MCI_INTERRUPT_RX_MSG_EN) &
-				~AR_MCI_INTERRUPT_RX_HW_MSG_MASK;
-			REG_WRITE(ah, AR_MCI_INTERRUPT_RX_MSG_EN, val);
-		}
+		if (ath9k_hw_mci_is_enabled(ah))
+			REG_CLR_BIT(ah, AR_MCI_INTERRUPT_RX_MSG_EN,
+				    AR_MCI_INTERRUPT_RX_HW_MSG_MASK);
 		/*
 		 * Clear the RTC force wake bit to allow the
 		 * mac to go to sleep.
 		 */
-		REG_CLR_BIT(ah, AR_RTC_FORCE_WAKE,
-			    AR_RTC_FORCE_WAKE_EN);
+		REG_CLR_BIT(ah, AR_RTC_FORCE_WAKE, AR_RTC_FORCE_WAKE_EN);
 
-		if (AR_SREV_9462(ah))
+		if (ath9k_hw_mci_is_enabled(ah))
 			udelay(30);
 	}
 
-- 
1.7.10.2

