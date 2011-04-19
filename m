Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:57268 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702Ab1DSN7d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 09:59:33 -0400
Received: from mail.atheros.com ([10.234.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 19 Apr 2011 06:59:07 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org
Subject: [PATCH V2 13/22] ath9k_hw: Don't configure AR_CH0_THERM for AR9340
Date: Tue, 19 Apr 2011 19:29:11 +0530
Message-ID: <1303221560-25139-14-git-send-email-vasanth@atheros.com>
In-Reply-To: <1303221560-25139-1-git-send-email-vasanth@atheros.com>
References: <1303221560-25139-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 6eadf97..5138104 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3448,9 +3448,13 @@ static void ar9003_hw_xpa_bias_level_apply(struct ath_hw *ah, bool is2ghz)
 		REG_RMW_FIELD(ah, AR_CH0_TOP2, AR_CH0_TOP2_XPABIASLVL, bias);
 	else {
 		REG_RMW_FIELD(ah, AR_CH0_TOP, AR_CH0_TOP_XPABIASLVL, bias);
-		REG_RMW_FIELD(ah, AR_CH0_THERM, AR_CH0_THERM_XPABIASLVL_MSB,
-			      bias >> 2);
-		REG_RMW_FIELD(ah, AR_CH0_THERM, AR_CH0_THERM_XPASHORT2GND, 1);
+		if (!AR_SREV_9340(ah)) {
+			REG_RMW_FIELD(ah, AR_CH0_THERM,
+				      AR_CH0_THERM_XPABIASLVL_MSB,
+				      bias >> 2);
+			REG_RMW_FIELD(ah, AR_CH0_THERM,
+				      AR_CH0_THERM_XPASHORT2GND, 1);
+		}
 	}
 }
 
-- 
1.7.0.4

