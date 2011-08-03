Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from AShevkov.infinet.ru ([91.191.225.92]:38628 "EHLO
	AShevkov.infinet.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab1HCLmQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2011 07:42:16 -0400
From: Alex Hacker <hacker@epn.ru>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Alex Hacker <hacker@epn.ru>
Subject: [PATCH] ath9k_hw: use register name in place of magic value
Date: Wed,  3 Aug 2011 17:41:54 +0600
Message-Id: <1312371714-28069-1-git-send-email-hacker@epn.ru> (sfid-20110803_134219_546149_F19F0E0B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Alex Hacker <hacker@epn.ru>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index d109c25..c2f07e8 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4061,7 +4061,7 @@ static int ar9003_hw_tx_power_regwrite(struct ath_hw *ah, u8 * pPwrArray)
         /* Write the power for duplicated frames - HT40 */
 
         /* dup40_cck (LSB), dup40_ofdm, ext20_cck, ext20_ofdm (MSB) */
-	REG_WRITE(ah, 0xa3e0,
+	REG_WRITE(ah, AR_PHY_POWER_TX_RATE(8),
 		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_6_24], 24) |
 		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_1L_5L], 16) |
 		  POW_SM(pPwrArray[ALL_TARGET_LEGACY_6_24],  8) |
-- 
1.7.4

