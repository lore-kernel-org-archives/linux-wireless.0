Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:63959 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956Ab1DKOw2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 10:52:28 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2011 07:52:03 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 1/4] ath9k_hw: Remove unused code in AR9287 eeprom
Date: Mon, 11 Apr 2011 20:22:28 +0530
Message-ID: <1302533551-27462-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/eeprom_9287.c |   25 +------------------------
 1 files changed, 1 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 2f0712e..1357975 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -858,35 +858,12 @@ static void ath9k_hw_ar9287_set_board_values(struct ath_hw *ah,
 {
 	struct ar9287_eeprom *eep = &ah->eeprom.map9287;
 	struct modal_eep_ar9287_header *pModal = &eep->modalHeader;
-	u16 antWrites[AR9287_ANT_16S];
 	u32 regChainOffset, regval;
 	u8 txRxAttenLocal;
-	int i, j, offset_num;
+	int i;
 
 	pModal = &eep->modalHeader;
 
-	antWrites[0] = (u16)((pModal->antCtrlCommon >> 28) & 0xF);
-	antWrites[1] = (u16)((pModal->antCtrlCommon >> 24) & 0xF);
-	antWrites[2] = (u16)((pModal->antCtrlCommon >> 20) & 0xF);
-	antWrites[3] = (u16)((pModal->antCtrlCommon >> 16) & 0xF);
-	antWrites[4] = (u16)((pModal->antCtrlCommon >> 12) & 0xF);
-	antWrites[5] = (u16)((pModal->antCtrlCommon >> 8) & 0xF);
-	antWrites[6] = (u16)((pModal->antCtrlCommon >> 4)  & 0xF);
-	antWrites[7] = (u16)(pModal->antCtrlCommon & 0xF);
-
-	offset_num = 8;
-
-	for (i = 0, j = offset_num; i < AR9287_MAX_CHAINS; i++) {
-		antWrites[j++] = (u16)((pModal->antCtrlChain[i] >> 28) & 0xf);
-		antWrites[j++] = (u16)((pModal->antCtrlChain[i] >> 10) & 0x3);
-		antWrites[j++] = (u16)((pModal->antCtrlChain[i] >> 8) & 0x3);
-		antWrites[j++] = 0;
-		antWrites[j++] = (u16)((pModal->antCtrlChain[i] >> 6) & 0x3);
-		antWrites[j++] = (u16)((pModal->antCtrlChain[i] >> 4) & 0x3);
-		antWrites[j++] = (u16)((pModal->antCtrlChain[i] >> 2) & 0x3);
-		antWrites[j++] = (u16)(pModal->antCtrlChain[i] & 0x3);
-	}
-
 	REG_WRITE(ah, AR_PHY_SWITCH_COM, pModal->antCtrlCommon);
 
 	for (i = 0; i < AR9287_MAX_CHAINS; i++)	{
-- 
1.7.4.4

