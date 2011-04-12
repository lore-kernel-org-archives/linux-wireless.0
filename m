Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:38773 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590Ab1DLM5n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 08:57:43 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 05:57:18 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 13/22] ath9k_hw: Don't configure AR_CH0_THERM for AR9340
Date: Tue, 12 Apr 2011 18:27:13 +0530
Message-ID: <1302613042-1754-14-git-send-email-vasanth@atheros.com>
In-Reply-To: <1302613042-1754-1-git-send-email-vasanth@atheros.com>
References: <1302613042-1754-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 4a92718..685ce91 100644
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

