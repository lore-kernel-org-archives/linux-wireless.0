Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:63482 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbZCMDaI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 23:30:08 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2009 20:30:07 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18873.53834.275330.188365@gargle.gargle.HOWL> (sfid-20090313_043015_338210_61803B47)
Date: Fri, 13 Mar 2009 08:56:02 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 2/7] ath9k: Move AR5416_VER_MASK to a common location
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/eeprom.c |    4 ----
 drivers/net/wireless/ath9k/eeprom.h |    1 +
 2 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath9k/eeprom.c b/drivers/net/wireless/ath9k/eeprom.c
index 6c9bc5f..49dee23 100644
--- a/drivers/net/wireless/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath9k/eeprom.c
@@ -1588,7 +1588,6 @@ static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 static u32 ath9k_hw_def_get_eeprom(struct ath_hw *ah,
 				   enum eeprom_param param)
 {
-#define AR5416_VER_MASK (pBase->version & AR5416_EEP_VER_MINOR_MASK)
 	struct ar5416_eeprom_def *eep = &ah->eeprom.def;
 	struct modal_eep_header *pModal = eep->modalHeader;
 	struct base_eep_header *pBase = &eep->baseEepHeader;
@@ -1655,14 +1654,12 @@ static u32 ath9k_hw_def_get_eeprom(struct ath_hw *ah,
 	default:
 		return 0;
 	}
-#undef AR5416_VER_MASK
 }
 
 /* XXX: Clean me up, make me more legible */
 static bool ath9k_hw_def_set_board_values(struct ath_hw *ah,
 					  struct ath9k_channel *chan)
 {
-#define AR5416_VER_MASK (eep->baseEepHeader.version & AR5416_EEP_VER_MINOR_MASK)
 	struct modal_eep_header *pModal;
 	struct ar5416_eeprom_def *eep = &ah->eeprom.def;
 	int i, regChainOffset;
@@ -1910,7 +1907,6 @@ static bool ath9k_hw_def_set_board_values(struct ath_hw *ah,
 	}
 
 	return true;
-#undef AR5416_VER_MASK
 }
 
 static void ath9k_hw_def_set_addac(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath9k/eeprom.h b/drivers/net/wireless/ath9k/eeprom.h
index d6f6108..0a4b22a 100644
--- a/drivers/net/wireless/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath9k/eeprom.h
@@ -95,6 +95,7 @@
 #define FREQ2FBIN(x, y)		((y) ? ((x) - 2300) : (((x) - 4800) / 5))
 #define ath9k_hw_use_flash(_ah)	(!(_ah->ah_flags & AH_USE_EEPROM))
 
+#define AR5416_VER_MASK (eep->baseEepHeader.version & AR5416_EEP_VER_MINOR_MASK)
 #define OLC_FOR_AR9280_20_LATER (AR_SREV_9280_20_OR_LATER(ah) && \
 				 ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL))
 
-- 
1.6.2

