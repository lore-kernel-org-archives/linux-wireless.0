Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:48321 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbZGYVSt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 17:18:49 -0400
Received: by ewy26 with SMTP id 26so2433113ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2009 14:18:48 -0700 (PDT)
Message-ID: <4A6B7752.1080405@gmail.com>
Date: Sat, 25 Jul 2009 23:21:22 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ath9k: Read outside array bounds
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Incorrect limits leads to reads outside array bounds.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index a2fda70..ce0e86c 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -460,7 +460,7 @@ static int ath9k_hw_4k_check_eeprom(struct ath_hw *ah)
 		integer = swab32(eep->modalHeader.antCtrlCommon);
 		eep->modalHeader.antCtrlCommon = integer;
 
-		for (i = 0; i < AR5416_MAX_CHAINS; i++) {
+		for (i = 0; i < AR5416_EEP4K_MAX_CHAINS; i++) {
 			integer = swab32(eep->modalHeader.antCtrlChain[i]);
 			eep->modalHeader.antCtrlChain[i] = integer;
 		}
@@ -914,7 +914,7 @@ static void ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 			ctlMode, numCtlModes, isHt40CtlMode,
 			(pCtlMode[ctlMode] & EXT_ADDITIVE));
 
-		for (i = 0; (i < AR5416_NUM_CTLS) &&
+		for (i = 0; (i < AR5416_EEP4K_NUM_CTLS) &&
 				pEepData->ctlIndex[i]; i++) {
 			DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 				"  LOOP-Ctlidx %d: cfgCtl 0x%2.2x "
