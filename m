Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54736 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705Ab0DODax (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:53 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v2 07/97] ath9k_hw: AR9003 does not have AR_RC_AHB skip its setting
Date: Wed, 14 Apr 2010 23:29:21 -0400
Message-Id: <1271302251-9075-8-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR9003 does not have a reset control for AHB.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |   24 +++++++++++++++++++-----
 1 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index d924cbc..0e85a24 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1698,11 +1698,16 @@ static bool ath9k_hw_set_reset(struct ath_hw *ah, int type)
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
@@ -1733,7 +1738,7 @@ static bool ath9k_hw_set_reset_power_on(struct ath_hw *ah)
 	REG_WRITE(ah, AR_RTC_FORCE_WAKE, AR_RTC_FORCE_WAKE_EN |
 		  AR_RTC_FORCE_WAKE_ON_INT);
 
-	if (!AR_SREV_9100(ah))
+	if (!AR_SREV_9100(ah) && !AR_SREV_9300_20_OR_LATER(ah))
 		REG_WRITE(ah, AR_RC, AR_RC_AHB);
 
 	REG_WRITE(ah, AR_RTC_RESET, 0);
@@ -2414,15 +2419,24 @@ EXPORT_SYMBOL(ath9k_hw_keyisvalid);
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
+		/*
+		 * Clear the RTC force wake bit to allow the
+		 * mac to go to sleep.
+		 */
 		REG_CLR_BIT(ah, AR_RTC_FORCE_WAKE,
 			    AR_RTC_FORCE_WAKE_EN);
-		if (!AR_SREV_9100(ah))
+		if (!AR_SREV_9100(ah) && !AR_SREV_9300_20_OR_LATER(ah))
 			REG_WRITE(ah, AR_RC, AR_RC_AHB | AR_RC_HOSTIF);
 
+		/* Shutdown chip. Active low */
 		if (!AR_SREV_5416(ah) && !AR_SREV_9271(ah))
 			REG_CLR_BIT(ah, (AR_RTC_RESET),
 				    AR_RTC_RESET_EN);
-- 
1.6.3.3

