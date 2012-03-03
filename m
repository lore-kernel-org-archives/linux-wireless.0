Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40172 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421Ab2CCORS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Mar 2012 09:17:18 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 1/5] ath9k_hw: use cold instead of warm reset on AR9280
Date: Sat,  3 Mar 2012 15:17:02 +0100
Message-Id: <1330784226-65563-1-git-send-email-nbd@openwrt.org> (sfid-20120303_151725_193187_BF2D689B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cold reset is more reliable for getting the hardware out of some specific
stuck states.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8c840ca..d582cf7 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1386,10 +1386,16 @@ static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type)
 static bool ath9k_hw_chip_reset(struct ath_hw *ah,
 				struct ath9k_channel *chan)
 {
-	if (AR_SREV_9280(ah) && ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL)) {
-		if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON))
-			return false;
-	} else if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_WARM))
+	int reset_type = ATH9K_RESET_WARM;
+
+	if (AR_SREV_9280(ah)) {
+		if (ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL))
+			reset_type = ATH9K_RESET_POWER_ON;
+		else
+			reset_type = ATH9K_RESET_COLD;
+	}
+
+	if (!ath9k_hw_set_reset_reg(ah, reset_type))
 		return false;
 
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
-- 
1.7.3.2

