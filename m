Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:26503 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399Ab0KJNEH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 08:04:07 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 05:03:54 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 08/11] ath9k_hw: Improve power control accuracy for AR9003
Date: Wed, 10 Nov 2010 05:03:13 -0800
Message-ID: <1289394196-3465-8-git-send-email-vasanth@atheros.com>
In-Reply-To: <1289394196-3465-1-git-send-email-vasanth@atheros.com>
References: <1289394196-3465-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is done for 5Ghz by adding three temperature slopes.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index da26d37..5ffeda2 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4062,6 +4062,7 @@ static int ar9003_hw_power_control_override(struct ath_hw *ah,
 {
 	int tempSlope = 0;
 	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+	int f[3], t[3];
 
 	REG_RMW(ah, AR_PHY_TPC_11_B0,
 		(correction[0] << AR_PHY_TPC_OLPC_GAIN_DELTA_S),
@@ -4090,7 +4091,16 @@ static int ar9003_hw_power_control_override(struct ath_hw *ah,
 	 */
 	if (frequency < 4000)
 		tempSlope = eep->modalHeader2G.tempSlope;
-	else
+	else if (eep->base_ext2.tempSlopeLow != 0) {
+		t[0] = eep->base_ext2.tempSlopeLow;
+		f[0] = 5180;
+		t[1] = eep->modalHeader5G.tempSlope;
+		f[1] = 5500;
+		t[2] = eep->base_ext2.tempSlopeHigh;
+		f[2] = 5785;
+		tempSlope = ar9003_hw_power_interpolate((s32) frequency,
+							f, t, 3);
+	} else
 		tempSlope = eep->modalHeader5G.tempSlope;
 
 	REG_RMW_FIELD(ah, AR_PHY_TPC_19, AR_PHY_TPC_19_ALPHA_THERM, tempSlope);
-- 
1.7.0.4

