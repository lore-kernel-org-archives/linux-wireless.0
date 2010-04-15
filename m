Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54925 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756793Ab0DODa4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:56 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 68/97] ath9k_hw: restore mac address reading logic
Date: Wed, 14 Apr 2010 23:30:22 -0400
Message-Id: <1271302251-9075-69-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Once upon a time the AR_EEPROM_MAC macro was added to let us
add a random attribute to the three 4-bytes of MAC addresses
entries we read from the EEPROM. This was good while a random
high-enough value was used which did not conflict with any
of the already existing enum eeprom_param values. With AR9003
support the enums overlap and it means we either increment
the random offset or just restore the reading logic to match
what the HAL has. I choose to do the later to synchronize
the logic on both code bases.

This should fix reading the MAC address from the EEPROM
on AR9003 hardware.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/eeprom.h      |    1 -
 drivers/net/wireless/ath/ath9k/eeprom_4k.c   |    6 +++---
 drivers/net/wireless/ath/ath9k/eeprom_9287.c |    6 +++---
 drivers/net/wireless/ath/ath9k/eeprom_def.c  |    6 +++---
 drivers/net/wireless/ath/ath9k/hw.c          |    3 ++-
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 60fd5b6..289084c 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -93,7 +93,6 @@
  */
 #define AR9285_RDEXT_DEFAULT    0x1F
 
-#define AR_EEPROM_MAC(i)	(0x1d+(i))
 #define ATH9K_POW_SM(_r, _s)	(((_r) & 0x3f) << (_s))
 #define FREQ2FBIN(x, y)		((y) ? ((x) - 2300) : (((x) - 4800) / 5))
 #define ath9k_hw_use_flash(_ah)	(!(_ah->ah_flags & AH_USE_EEPROM))
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index 97279a5..2384a9f 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -183,11 +183,11 @@ static u32 ath9k_hw_4k_get_eeprom(struct ath_hw *ah,
 	switch (param) {
 	case EEP_NFTHRESH_2:
 		return pModal->noiseFloorThreshCh[0];
-	case AR_EEPROM_MAC(0):
+	case EEP_MAC_LSW:
 		return pBase->macAddr[0] << 8 | pBase->macAddr[1];
-	case AR_EEPROM_MAC(1):
+	case EEP_MAC_MID:
 		return pBase->macAddr[2] << 8 | pBase->macAddr[3];
-	case AR_EEPROM_MAC(2):
+	case EEP_MAC_MSW:
 		return pBase->macAddr[4] << 8 | pBase->macAddr[5];
 	case EEP_REG_0:
 		return pBase->regDmn[0];
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 0b1e885..b471db5 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -173,11 +173,11 @@ static u32 ath9k_hw_AR9287_get_eeprom(struct ath_hw *ah,
 	switch (param) {
 	case EEP_NFTHRESH_2:
 		return pModal->noiseFloorThreshCh[0];
-	case AR_EEPROM_MAC(0):
+	case EEP_MAC_LSW:
 		return pBase->macAddr[0] << 8 | pBase->macAddr[1];
-	case AR_EEPROM_MAC(1):
+	case EEP_MAC_MID:
 		return pBase->macAddr[2] << 8 | pBase->macAddr[3];
-	case AR_EEPROM_MAC(2):
+	case EEP_MAC_MSW:
 		return pBase->macAddr[4] << 8 | pBase->macAddr[5];
 	case EEP_REG_0:
 		return pBase->regDmn[0];
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 99f16a3..3d1b86b 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -238,11 +238,11 @@ static u32 ath9k_hw_def_get_eeprom(struct ath_hw *ah,
 		return pModal[0].noiseFloorThreshCh[0];
 	case EEP_NFTHRESH_2:
 		return pModal[1].noiseFloorThreshCh[0];
-	case AR_EEPROM_MAC(0):
+	case EEP_MAC_LSW:
 		return pBase->macAddr[0] << 8 | pBase->macAddr[1];
-	case AR_EEPROM_MAC(1):
+	case EEP_MAC_MID:
 		return pBase->macAddr[2] << 8 | pBase->macAddr[3];
-	case AR_EEPROM_MAC(2):
+	case EEP_MAC_MSW:
 		return pBase->macAddr[4] << 8 | pBase->macAddr[5];
 	case EEP_REG_0:
 		return pBase->regDmn[0];
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index b8ef2e1..8c25059 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -473,10 +473,11 @@ static int ath9k_hw_init_macaddr(struct ath_hw *ah)
 	u32 sum;
 	int i;
 	u16 eeval;
+	u32 EEP_MAC[] = { EEP_MAC_LSW, EEP_MAC_MID, EEP_MAC_MSW };
 
 	sum = 0;
 	for (i = 0; i < 3; i++) {
-		eeval = ah->eep_ops->get_eeprom(ah, AR_EEPROM_MAC(i));
+		eeval = ah->eep_ops->get_eeprom(ah, EEP_MAC[i]);
 		sum += eeval;
 		common->macaddr[2 * i] = eeval >> 8;
 		common->macaddr[2 * i + 1] = eeval & 0xff;
-- 
1.6.3.3

