Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:65293 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbbCTMlF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 08:41:05 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kvalo@codeaurora.org, adrian@freebsd.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 14/18] ath9k: ath9k_hw_analog_shift_rmw: use REG_RMW
Date: Fri, 20 Mar 2015 13:38:54 +0100
Message-Id: <1426855138-6121-15-git-send-email-linux@rempel-privat.de> (sfid-20150320_134125_808826_8086F0B0)
In-Reply-To: <1426855138-6121-1-git-send-email-linux@rempel-privat.de>
References: <1426855138-6121-1-git-send-email-linux@rempel-privat.de>
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

