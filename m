Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:13856 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038Ab0LAHfB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 02:35:01 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 23:34:47 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 19/26] ath9k_hw: Configure power control only for chain 0 on AR9485
Date: Tue, 30 Nov 2010 23:32:48 -0800
Message-ID: <1291188775-13707-20-git-send-email-vasanth@atheros.com>
In-Reply-To: <1291188775-13707-1-git-send-email-vasanth@atheros.com>
References: <1291188775-13707-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   28 +++++++++++++----------
 1 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 9d9d637..6115f36 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4277,23 +4277,27 @@ static int ar9003_hw_power_control_override(struct ath_hw *ah,
 	REG_RMW(ah, AR_PHY_TPC_11_B0,
 		(correction[0] << AR_PHY_TPC_OLPC_GAIN_DELTA_S),
 		AR_PHY_TPC_OLPC_GAIN_DELTA);
-	REG_RMW(ah, AR_PHY_TPC_11_B1,
-		(correction[1] << AR_PHY_TPC_OLPC_GAIN_DELTA_S),
-		AR_PHY_TPC_OLPC_GAIN_DELTA);
-	REG_RMW(ah, AR_PHY_TPC_11_B2,
-		(correction[2] << AR_PHY_TPC_OLPC_GAIN_DELTA_S),
-		AR_PHY_TPC_OLPC_GAIN_DELTA);
+	if (!AR_SREV_9485(ah)) {
+		REG_RMW(ah, AR_PHY_TPC_11_B1,
+			(correction[1] << AR_PHY_TPC_OLPC_GAIN_DELTA_S),
+			AR_PHY_TPC_OLPC_GAIN_DELTA);
+		REG_RMW(ah, AR_PHY_TPC_11_B2,
+			(correction[2] << AR_PHY_TPC_OLPC_GAIN_DELTA_S),
+			AR_PHY_TPC_OLPC_GAIN_DELTA);
+	}
 
 	/* enable open loop power control on chip */
 	REG_RMW(ah, AR_PHY_TPC_6_B0,
 		(3 << AR_PHY_TPC_6_ERROR_EST_MODE_S),
 		AR_PHY_TPC_6_ERROR_EST_MODE);
-	REG_RMW(ah, AR_PHY_TPC_6_B1,
-		(3 << AR_PHY_TPC_6_ERROR_EST_MODE_S),
-		AR_PHY_TPC_6_ERROR_EST_MODE);
-	REG_RMW(ah, AR_PHY_TPC_6_B2,
-		(3 << AR_PHY_TPC_6_ERROR_EST_MODE_S),
-		AR_PHY_TPC_6_ERROR_EST_MODE);
+	if (!AR_SREV_9485(ah)) {
+		REG_RMW(ah, AR_PHY_TPC_6_B1,
+			(3 << AR_PHY_TPC_6_ERROR_EST_MODE_S),
+			AR_PHY_TPC_6_ERROR_EST_MODE);
+		REG_RMW(ah, AR_PHY_TPC_6_B2,
+			(3 << AR_PHY_TPC_6_ERROR_EST_MODE_S),
+			AR_PHY_TPC_6_ERROR_EST_MODE);
+	}
 
 	/*
 	 * enable temperature compensation
-- 
1.7.0.4

