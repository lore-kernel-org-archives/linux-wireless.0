Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21161 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964817Ab2ESIoz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 May 2012 04:44:55 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 10/10] ath9k_hw: fix power state for MCI
Date: Sat, 19 May 2012 14:13:56 +0530
Message-ID: <1337417036-1431-10-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120519_104504_108988_06935858)
In-Reply-To: <1337417036-1431-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1337417036-1431-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

