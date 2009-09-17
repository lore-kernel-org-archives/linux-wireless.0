Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:21658 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760658AbZIQD6R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 23:58:17 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2009 20:58:21 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19121.46045.975544.100257@gargle.gargle.HOWL>
Date: Thu, 17 Sep 2009 09:28:21 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 10/12] ath9k: Fix bug in chain handling
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Senthil Balasubramanian <senthilkumar@atheros.com>

* This patch fixes a bug in calculating the scaled
  power for three chain chipsets.

* Also, a delay is needed after setting DAC low-power mode in
  TOP1 RF register (Top Level Register Bits).

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/eeprom_def.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index ae7fb5d..4071fc9 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -509,6 +509,8 @@ static void ath9k_hw_def_set_board_values(struct ath_hw *ah,
 			REG_RMW_FIELD(ah, AR_AN_TOP1, AR_AN_TOP1_DACIPMODE,
 				      eep->baseEepHeader.dacLpMode);
 
+		udelay(100);
+
 		REG_RMW_FIELD(ah, AR_PHY_FRAME_CTL, AR_PHY_FRAME_CTL_TX_CLIP,
 			      pModal->miscBits >> 2);
 
@@ -902,7 +904,7 @@ static void ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
 						  u16 powerLimit)
 {
 #define REDUCE_SCALED_POWER_BY_TWO_CHAIN     6  /* 10*log10(2)*2 */
-#define REDUCE_SCALED_POWER_BY_THREE_CHAIN   10 /* 10*log10(3)*2 */
+#define REDUCE_SCALED_POWER_BY_THREE_CHAIN   9 /* 10*log10(3)*2 */
 
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	struct ar5416_eeprom_def *pEepData = &ah->eeprom.def;
-- 
1.6.4.3

