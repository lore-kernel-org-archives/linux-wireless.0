Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46708 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933170Ab0DHT1j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:39 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 007/102] ath9k_hw: AR9003 does not have AR_RC_AHB skip its setting
Date: Thu,  8 Apr 2010 15:26:03 -0400
Message-Id: <1270754858-26266-8-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR9003 does not have a reset control for AHB.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8f3b602..a6711dc 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1743,15 +1743,21 @@ static bool ath9k_hw_set_reset(struct ath_hw *ah, int type)
 		rst_flags = AR_RTC_RC_MAC_WARM | AR_RTC_RC_MAC_COLD |
 			AR_RTC_RC_COLD_RESET | AR_RTC_RC_WARM_RESET;
 	} else {
+
 		tmpReg = REG_READ(ah, AR_INTR_SYNC_CAUSE);
 		if (tmpReg &
 		    (AR_INTR_SYNC_LOCAL_TIMEOUT |
 		     AR_INTR_SYNC_RADM_CPL_TIMEOUT)) {
+			u32 val;
 			REG_WRITE(ah, AR_INTR_SYNC_ENABLE, 0);
-			REG_WRITE(ah, AR_RC, AR_RC_AHB | AR_RC_HOSTIF);
-		} else {
+
+			val = AR_RC_HOSTIF;
+			if (!AR_SREV_9300_20_OR_LATER(ah))
+				val |= AR_RC_AHB;
+			REG_WRITE(ah, AR_RC, val);
+
+		} else if (!AR_SREV_9300_20_OR_LATER(ah))
 			REG_WRITE(ah, AR_RC, AR_RC_AHB);
-		}
 
 		rst_flags = AR_RTC_RC_MAC_WARM;
 		if (type == ATH9K_RESET_COLD)
@@ -1782,7 +1788,7 @@ static bool ath9k_hw_set_reset_power_on(struct ath_hw *ah)
 	REG_WRITE(ah, AR_RTC_FORCE_WAKE, AR_RTC_FORCE_WAKE_EN |
 		  AR_RTC_FORCE_WAKE_ON_INT);
 
-	if (!AR_SREV_9100(ah))
+	if (!AR_SREV_9100(ah) && !AR_SREV_9300_20_OR_LATER(ah))
 		REG_WRITE(ah, AR_RC, AR_RC_AHB);
 
 	REG_WRITE(ah, AR_RTC_RESET, 0);
@@ -2463,15 +2469,20 @@ EXPORT_SYMBOL(ath9k_hw_keyisvalid);
 /* Power Management (Chipset) */
 /******************************/
 
+/*
+ * Notify Power Mgt is disabled in self-generated frames.
+ * If requested, force chip to sleep.
+ */
 static void ath9k_set_power_sleep(struct ath_hw *ah, int setChip)
 {
 	REG_SET_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
 	if (setChip) {
+		/* Clear the RTC force wake bit to allow the mac to go to sleep */
 		REG_CLR_BIT(ah, AR_RTC_FORCE_WAKE,
 			    AR_RTC_FORCE_WAKE_EN);
-		if (!AR_SREV_9100(ah))
+		if (!AR_SREV_9100(ah) && !AR_SREV_9300_20_OR_LATER(ah))
 			REG_WRITE(ah, AR_RC, AR_RC_AHB | AR_RC_HOSTIF);
-
+		/* Shutdown chip. Active low */
 		if (!AR_SREV_5416(ah) && !AR_SREV_9271(ah))
 			REG_CLR_BIT(ah, (AR_RTC_RESET),
 				    AR_RTC_RESET_EN);
-- 
1.6.3.3

