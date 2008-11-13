Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:17358 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbYKMM3l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 07:29:41 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 13 Nov 2008 04:29:41 -0800
Date: Thu, 13 Nov 2008 17:59:36 +0530
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <jouni.malinen@atheros.com>,
	<lrodriguez@atheros.com>
Subject: [PATCH 02/05] ath9k: incorrect noise floor threshold values.
Message-ID: <20081113122936.GC7688@senthil-lnx.users.atheros.com> (sfid-20081113_132944_703032_734E0BF6)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes incorrect noise floor threshold values.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath9k/calib.c  |    4 ++--
 drivers/net/wireless/ath9k/eeprom.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath9k/calib.c b/drivers/net/wireless/ath9k/calib.c
index 1690759..0e214f7 100644
--- a/drivers/net/wireless/ath9k/calib.c
+++ b/drivers/net/wireless/ath9k/calib.c
@@ -176,14 +176,14 @@ static bool getNoiseFloorThresh(struct ath_hal *ah,
 	case CHANNEL_A_HT20:
 	case CHANNEL_A_HT40PLUS:
 	case CHANNEL_A_HT40MINUS:
-		*nft = (int16_t)ath9k_hw_get_eeprom(ah, EEP_NFTHRESH_5);
+		*nft = (int8_t)ath9k_hw_get_eeprom(ah, EEP_NFTHRESH_5);
 		break;
 	case CHANNEL_B:
 	case CHANNEL_G:
 	case CHANNEL_G_HT20:
 	case CHANNEL_G_HT40PLUS:
 	case CHANNEL_G_HT40MINUS:
-		*nft = (int16_t)ath9k_hw_get_eeprom(ah, EEP_NFTHRESH_2);
+		*nft = (int8_t)ath9k_hw_get_eeprom(ah, EEP_NFTHRESH_2);
 		break;
 	default:
 		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
diff --git a/drivers/net/wireless/ath9k/eeprom.c b/drivers/net/wireless/ath9k/eeprom.c
index 9b2fdc5..180e541 100644
--- a/drivers/net/wireless/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath9k/eeprom.c
@@ -1551,9 +1551,9 @@ u32 ath9k_hw_get_eeprom(struct ath_hal *ah,
 
 	switch (param) {
 	case EEP_NFTHRESH_5:
-		return -pModal[0].noiseFloorThreshCh[0];
+		return pModal[0].noiseFloorThreshCh[0];
 	case EEP_NFTHRESH_2:
-		return -pModal[1].noiseFloorThreshCh[0];
+		return pModal[1].noiseFloorThreshCh[0];
 	case AR_EEPROM_MAC(0):
 		return pBase->macAddr[0] << 8 | pBase->macAddr[1];
 	case AR_EEPROM_MAC(1):
-- 
1.5.5

