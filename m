Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:18292 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbZHGVqX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 17:46:23 -0400
Received: by ey-out-2122.google.com with SMTP id 9so588418eyd.37
        for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2009 14:46:23 -0700 (PDT)
Message-ID: <4A7CA188.1070706@gmail.com>
Date: Fri, 07 Aug 2009 23:50:00 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Jouni Malinen <jmalinen@atheros.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ath9k: Fix read buffer overflow
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prevent a read of powInfo[-1] in the first iteration.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
The last hunk I already sent in a previous patch.

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index a2fda70..ef4bf89 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -150,10 +150,10 @@ static void ath9k_hw_get_legacy_target_powers(struct ath_hw *ah,
 						       IS_CHAN_2GHZ(chan))) {
 				matchIndex = i;
 				break;
-			} else if ((freq < ath9k_hw_fbin2freq(powInfo[i].bChannel,
-						      IS_CHAN_2GHZ(chan))) &&
-				   (freq > ath9k_hw_fbin2freq(powInfo[i - 1].bChannel,
-						      IS_CHAN_2GHZ(chan)))) {
+			} else if (freq < ath9k_hw_fbin2freq(powInfo[i].bChannel,
+						      IS_CHAN_2GHZ(chan)) && i > 0 &&
+				   freq > ath9k_hw_fbin2freq(powInfo[i - 1].bChannel,
+						      IS_CHAN_2GHZ(chan))) {
 				lowIndex = i - 1;
 				break;
 			}
@@ -268,10 +268,10 @@ static void ath9k_hw_get_target_powers(struct ath_hw *ah,
 				matchIndex = i;
 				break;
 			} else
-				if ((freq < ath9k_hw_fbin2freq(powInfo[i].bChannel,
-						       IS_CHAN_2GHZ(chan))) &&
-				    (freq > ath9k_hw_fbin2freq(powInfo[i - 1].bChannel,
-						       IS_CHAN_2GHZ(chan)))) {
+				if (freq < ath9k_hw_fbin2freq(powInfo[i].bChannel,
+						       IS_CHAN_2GHZ(chan)) && i > 0 &&
+				    freq > ath9k_hw_fbin2freq(powInfo[i - 1].bChannel,
+						       IS_CHAN_2GHZ(chan))) {
 					lowIndex = i - 1;
 					break;
 				}
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
