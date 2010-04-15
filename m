Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54740 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742Ab0DODax (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:53 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 11/97] ath9k_hw: add some comments for ath9k_set_power_network_sleep()
Date: Wed, 14 Apr 2010 23:29:25 -0400
Message-Id: <1271302251-9075-12-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index dd37e90..8aa1684 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2037,6 +2037,11 @@ static void ath9k_set_power_sleep(struct ath_hw *ah, int setChip)
 	}
 }
 
+/*
+ * Notify Power Management is enabled in self-generating
+ * frames. If request, set power mode of chip to
+ * auto/normal.  Duration in units of 128us (1/8 TU).
+ */
 static void ath9k_set_power_network_sleep(struct ath_hw *ah, int setChip)
 {
 	REG_SET_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
@@ -2044,9 +2049,14 @@ static void ath9k_set_power_network_sleep(struct ath_hw *ah, int setChip)
 		struct ath9k_hw_capabilities *pCap = &ah->caps;
 
 		if (!(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
+			/* Set WakeOnInterrupt bit; clear ForceWake bit */
 			REG_WRITE(ah, AR_RTC_FORCE_WAKE,
 				  AR_RTC_FORCE_WAKE_ON_INT);
 		} else {
+			/*
+			 * Clear the RTC force wake bit to allow the
+			 * mac to go to sleep.
+			 */
 			REG_CLR_BIT(ah, AR_RTC_FORCE_WAKE,
 				    AR_RTC_FORCE_WAKE_EN);
 		}
-- 
1.6.3.3

