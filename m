Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:11196 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755101AbZAWJNS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 04:13:18 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2009 01:13:18 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 2/2] ath9k: Clean up the way the eeprom antenna configuration is read
Date: Fri, 23 Jan 2009 14:40:37 +0530
Message-ID: <1232701837-25673-2-git-send-email-vasanth@atheros.com> (sfid-20090123_101327_621644_91E60356)
In-Reply-To: <1232701837-25673-1-git-send-email-vasanth@atheros.com>
References: <1232701837-25673-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h  |    5 +--
 drivers/net/wireless/ath9k/eeprom.c |   63 ++++++++--------------------------
 2 files changed, 17 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index f5d6131..c28d7dc 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -992,9 +992,8 @@ bool ath9k_hw_set_power_cal_table(struct ath_hal *ah,
 				  int16_t *pTxPowerIndexOffset);
 bool ath9k_hw_eeprom_set_board_values(struct ath_hal *ah,
 				      struct ath9k_channel *chan);
-int ath9k_hw_get_eeprom_antenna_cfg(struct ath_hal *ah,
-				    struct ath9k_channel *chan,
-				    u8 index, u16 *config);
+u16 ath9k_hw_get_eeprom_antenna_cfg(struct ath_hal *ah,
+				    struct ath9k_channel *chan);
 u8 ath9k_hw_get_num_ant_config(struct ath_hal *ah,
 			       enum ieee80211_band freq_band);
 u16 ath9k_hw_eeprom_get_spur_chan(struct ath_hal *ah, u16 i, bool is2GHz);
diff --git a/drivers/net/wireless/ath9k/eeprom.c b/drivers/net/wireless/ath9k/eeprom.c
index 50cb388..5038907 100644
--- a/drivers/net/wireless/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath9k/eeprom.c
@@ -2085,14 +2085,13 @@ static bool ath9k_hw_eeprom_set_def_board_values(struct ath_hal *ah,
 	struct ar5416_eeprom_def *eep = &ahp->ah_eeprom.def;
 	int i, regChainOffset;
 	u8 txRxAttenLocal;
-	u16 ant_config;
 
 	pModal = &(eep->modalHeader[IS_CHAN_2GHZ(chan)]);
 
 	txRxAttenLocal = IS_CHAN_2GHZ(chan) ? 23 : 44;
 
-	ath9k_hw_get_eeprom_antenna_cfg(ah, chan, 0, &ant_config);
-	REG_WRITE(ah, AR_PHY_SWITCH_COM, ant_config);
+	REG_WRITE(ah, AR_PHY_SWITCH_COM,
+		  ath9k_hw_get_eeprom_antenna_cfg(ah, chan));
 
 	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
 		if (AR_SREV_9280(ah)) {
@@ -2330,7 +2329,6 @@ static bool ath9k_hw_eeprom_set_4k_board_values(struct ath_hal *ah,
 	struct ar5416_eeprom_4k *eep = &ahp->ah_eeprom.map4k;
 	int regChainOffset;
 	u8 txRxAttenLocal;
-	u16 ant_config = 0;
 	u8 ob[5], db1[5], db2[5];
 	u8 ant_div_control1, ant_div_control2;
 	u32 regVal;
@@ -2340,8 +2338,8 @@ static bool ath9k_hw_eeprom_set_4k_board_values(struct ath_hal *ah,
 
 	txRxAttenLocal = 23;
 
-	ath9k_hw_get_eeprom_antenna_cfg(ah, chan, 0, &ant_config);
-	REG_WRITE(ah, AR_PHY_SWITCH_COM, ant_config);
+	REG_WRITE(ah, AR_PHY_SWITCH_COM,
+		  ath9k_hw_get_eeprom_antenna_cfg(ah, chan));
 
 	regChainOffset = 0;
 	REG_WRITE(ah, AR_PHY_SWITCH_CHAIN_0 + regChainOffset,
@@ -2524,70 +2522,39 @@ bool ath9k_hw_eeprom_set_board_values(struct ath_hal *ah,
 	return ath9k_eeprom_set_board_values[ahp->ah_eep_map](ah, chan);
 }
 
-static int ath9k_hw_get_def_eeprom_antenna_cfg(struct ath_hal *ah,
-				    struct ath9k_channel *chan,
-				    u8 index, u16 *config)
+static u16 ath9k_hw_get_def_eeprom_antenna_cfg(struct ath_hal *ah,
+					       struct ath9k_channel *chan)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ar5416_eeprom_def *eep = &ahp->ah_eeprom.def;
 	struct modal_eep_header *pModal =
 		&(eep->modalHeader[IS_CHAN_2GHZ(chan)]);
-	struct base_eep_header *pBase = &eep->baseEepHeader;
 
-	switch (index) {
-	case 0:
-		*config = pModal->antCtrlCommon & 0xFFFF;
-		return 0;
-	case 1:
-		if (pBase->version >= 0x0E0D) {
-			if (pModal->useAnt1) {
-				*config =
-				((pModal->antCtrlCommon & 0xFFFF0000) >> 16);
-				return 0;
-			}
-		}
-		break;
-	default:
-		break;
-	}
-
-	return -EINVAL;
+	return pModal->antCtrlCommon & 0xFFFF;
 }
 
-static int ath9k_hw_get_4k_eeprom_antenna_cfg(struct ath_hal *ah,
-				    struct ath9k_channel *chan,
-				    u8 index, u16 *config)
+static u16 ath9k_hw_get_4k_eeprom_antenna_cfg(struct ath_hal *ah,
+					      struct ath9k_channel *chan)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ar5416_eeprom_4k *eep = &ahp->ah_eeprom.map4k;
 	struct modal_eep_4k_header *pModal = &eep->modalHeader;
 
-	switch (index) {
-	case 0:
-		*config = pModal->antCtrlCommon & 0xFFFF;
-		return 0;
-	default:
-		break;
-	}
-
-	return -EINVAL;
+	return pModal->antCtrlCommon & 0xFFFF;
 }
 
-static int (*ath9k_get_eeprom_antenna_cfg[])(struct ath_hal *,
-					     struct ath9k_channel *,
-					     u8, u16 *) = {
+static u16 (*ath9k_get_eeprom_antenna_cfg[])(struct ath_hal *,
+					     struct ath9k_channel *) = {
 	ath9k_hw_get_def_eeprom_antenna_cfg,
 	ath9k_hw_get_4k_eeprom_antenna_cfg
 };
 
-int ath9k_hw_get_eeprom_antenna_cfg(struct ath_hal *ah,
-				    struct ath9k_channel *chan,
-				    u8 index, u16 *config)
+u16 ath9k_hw_get_eeprom_antenna_cfg(struct ath_hal *ah,
+				    struct ath9k_channel *chan)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
-	return ath9k_get_eeprom_antenna_cfg[ahp->ah_eep_map](ah, chan,
-							     index, config);
+	return ath9k_get_eeprom_antenna_cfg[ahp->ah_eep_map](ah, chan);
 }
 
 static u8 ath9k_hw_get_4k_num_ant_config(struct ath_hal *ah,
-- 
1.5.5.1

