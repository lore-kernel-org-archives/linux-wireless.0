Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:64249 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab0LOPbE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 10:31:04 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Dec 2010 07:30:48 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/7] ath9k_hw: Remove delay during regwrite of analog shift registers
Date: Wed, 15 Dec 2010 07:30:47 -0800
Message-ID: <1292427053-5880-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is not needed for AR9003.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index da4a571..07b44ce 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -578,10 +578,7 @@ static void ar9003_hw_prog_ini(struct ath_hw *ah,
 		u32 reg = INI_RA(iniArr, i, 0);
 		u32 val = INI_RA(iniArr, i, column);
 
-		if (reg >= 0x16000 && reg < 0x17000)
-			ath9k_hw_analog_shift_regwrite(ah, reg, val);
-		else
-			REG_WRITE(ah, reg, val);
+		REG_WRITE(ah, reg, val);
 
 		DO_DELAY(regWrites);
 	}
-- 
1.7.0.4

