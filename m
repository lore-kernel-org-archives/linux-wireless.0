Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:60592 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbbCVSbw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2015 14:31:52 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	ath9k-devel@lists.ath9k.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH v3 14/18] ath9k: ath9k_hw_analog_shift_rmw: use REG_RMW
Date: Sun, 22 Mar 2015 19:29:59 +0100
Message-Id: <1427049003-8443-15-git-send-email-linux@rempel-privat.de> (sfid-20150322_193418_203006_49ACCF0F)
In-Reply-To: <1427049003-8443-1-git-send-email-linux@rempel-privat.de>
References: <1427049003-8443-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

use REG_RMW in ath9k_hw_analog_shift_rmw.
It will double execution speed on usb bus.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/eeprom.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index 971d770..cc81482 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -27,12 +27,7 @@ void ath9k_hw_analog_shift_regwrite(struct ath_hw *ah, u32 reg, u32 val)
 void ath9k_hw_analog_shift_rmw(struct ath_hw *ah, u32 reg, u32 mask,
 			       u32 shift, u32 val)
 {
-	u32 regVal;
-
-	regVal = REG_READ(ah, reg) & ~mask;
-	regVal |= (val << shift) & mask;
-
-	REG_WRITE(ah, reg, regVal);
+	REG_RMW(ah, reg, ((val << shift) & mask), mask);
 
 	if (ah->config.analog_shiftreg)
 		udelay(100);
-- 
1.9.1

