Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:37058 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933459Ab1IOMZq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 08:25:46 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH RESEND 2/4] ath9k_hw: remove dead code in the eeprom ops
Date: Thu, 15 Sep 2011 14:25:36 +0200
Message-Id: <1316089538-91685-2-git-send-email-nbd@openwrt.org> (sfid-20110915_142556_399585_2C9CDDE7)
In-Reply-To: <1316089538-91685-1-git-send-email-nbd@openwrt.org>
References: <1316089538-91685-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The eeprom .set_addac function is only necessary for AR9160, remove it
from eeprom_4k.c and remove the dummy function from eeprom_9287.c

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c  |    3 ++-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c   |   23 -----------------------
 drivers/net/wireless/ath/ath9k/eeprom_9287.c |    6 ------
 3 files changed, 2 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index b130c26..1381a39 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -801,7 +801,8 @@ static int ar5008_hw_process_ini(struct ath_hw *ah,
 
 	/* Write ADDAC shifts */
 	REG_WRITE(ah, AR_PHY_ADC_SERIAL_CTL, AR_PHY_SEL_EXTERNAL_RADIO);
-	ah->eep_ops->set_addac(ah, chan);
+	if (ah->eep_ops->set_addac)
+		ah->eep_ops->set_addac(ah, chan);
 
 	if (AR_SREV_5416_22_OR_LATER(ah)) {
 		REG_WRITE_ARRAY(&ah->iniAddac, 1, regWrites);
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 99f7a08..303560e 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -779,28 +779,6 @@ static void ath9k_hw_4k_set_txpower(struct ath_hw *ah,
 	REGWRITE_BUFFER_FLUSH(ah);
 }
 
-static void ath9k_hw_4k_set_addac(struct ath_hw *ah,
-				  struct ath9k_channel *chan)
-{
-	struct modal_eep_4k_header *pModal;
-	struct ar5416_eeprom_4k *eep = &ah->eeprom.map4k;
-	u8 biaslevel;
-
-	if (ah->hw_version.macVersion != AR_SREV_VERSION_9160)
-		return;
-
-	if (ah->eep_ops->get_eeprom_rev(ah) < AR5416_EEP_MINOR_VER_7)
-		return;
-
-	pModal = &eep->modalHeader;
-
-	if (pModal->xpaBiasLvl != 0xff) {
-		biaslevel = pModal->xpaBiasLvl;
-		INI_RA(&ah->iniAddac, 7, 1) =
-		  (INI_RA(&ah->iniAddac, 7, 1) & (~0x18)) | biaslevel << 3;
-	}
-}
-
 static void ath9k_hw_4k_set_gain(struct ath_hw *ah,
 				 struct modal_eep_4k_header *pModal,
 				 struct ar5416_eeprom_4k *eep,
@@ -1152,7 +1130,6 @@ const struct eeprom_ops eep_4k_ops = {
 	.get_eeprom_ver		= ath9k_hw_4k_get_eeprom_ver,
 	.get_eeprom_rev		= ath9k_hw_4k_get_eeprom_rev,
 	.set_board_values	= ath9k_hw_4k_set_board_values,
-	.set_addac		= ath9k_hw_4k_set_addac,
 	.set_txpower		= ath9k_hw_4k_set_txpower,
 	.get_spur_channel	= ath9k_hw_4k_get_spur_channel
 };
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index ebf97ba..6698b72 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -942,11 +942,6 @@ static void ath9k_hw_ar9287_set_txpower(struct ath_hw *ah,
 	REGWRITE_BUFFER_FLUSH(ah);
 }
 
-static void ath9k_hw_ar9287_set_addac(struct ath_hw *ah,
-				      struct ath9k_channel *chan)
-{
-}
-
 static void ath9k_hw_ar9287_set_board_values(struct ath_hw *ah,
 					     struct ath9k_channel *chan)
 {
@@ -1098,7 +1093,6 @@ const struct eeprom_ops eep_ar9287_ops = {
 	.get_eeprom_ver		= ath9k_hw_ar9287_get_eeprom_ver,
 	.get_eeprom_rev		= ath9k_hw_ar9287_get_eeprom_rev,
 	.set_board_values	= ath9k_hw_ar9287_set_board_values,
-	.set_addac		= ath9k_hw_ar9287_set_addac,
 	.set_txpower		= ath9k_hw_ar9287_set_txpower,
 	.get_spur_channel	= ath9k_hw_ar9287_get_spur_channel
 };
-- 
1.7.3.2

