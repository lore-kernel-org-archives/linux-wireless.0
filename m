Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:35580
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751792AbaJYTgc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:36:32 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, sujith@msujith.org
Subject: [PATCH v2 08/10] ath9k: add support for endian swap of eeprom from platform data
Date: Sat, 25 Oct 2014 17:19:33 +0200
Message-Id: <1414250375-74121-8-git-send-email-nbd@openwrt.org> (sfid-20141025_213635_835177_301AA6C5)
In-Reply-To: <1414250375-74121-1-git-send-email-nbd@openwrt.org>
References: <1414250375-74121-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On some devices (especially little-endian ones), the flash EEPROM data
has a different endian, which needs to be detected.
Add a flag to the platform data to allow overriding that behavior

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/eeprom_def.c | 31 ++++++++++-------------------
 drivers/net/wireless/ath/ath9k/hw.h         |  1 +
 drivers/net/wireless/ath/ath9k/init.c       |  2 ++
 include/linux/ath9k_platform.h              |  1 +
 4 files changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 3218ca9..122b846 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -262,7 +262,7 @@ static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 {
 	struct ar5416_eeprom_def *eep = &ah->eeprom.def;
 	struct ath_common *common = ath9k_hw_common(ah);
-	u16 *eepdata, temp, magic, magic2;
+	u16 *eepdata, temp, magic;
 	u32 sum = 0, el;
 	bool need_swap = false;
 	int i, addr, size;
@@ -272,27 +272,16 @@ static int ath9k_hw_def_check_eeprom(struct ath_hw *ah)
 		return false;
 	}
 
-	if (!ath9k_hw_use_flash(ah)) {
-		ath_dbg(common, EEPROM, "Read Magic = 0x%04X\n", magic);
-
-		if (magic != AR5416_EEPROM_MAGIC) {
-			magic2 = swab16(magic);
-
-			if (magic2 == AR5416_EEPROM_MAGIC) {
-				size = sizeof(struct ar5416_eeprom_def);
-				need_swap = true;
-				eepdata = (u16 *) (&ah->eeprom);
+	if (swab16(magic) == AR5416_EEPROM_MAGIC &&
+	    !(ah->ah_flags & AH_NO_EEP_SWAP)) {
+		size = sizeof(struct ar5416_eeprom_def);
+		need_swap = true;
+		eepdata = (u16 *) (&ah->eeprom);
 
-				for (addr = 0; addr < size / sizeof(u16); addr++) {
-					temp = swab16(*eepdata);
-					*eepdata = temp;
-					eepdata++;
-				}
-			} else {
-				ath_err(common,
-					"Invalid EEPROM Magic. Endianness mismatch.\n");
-				return -EINVAL;
-			}
+		for (addr = 0; addr < size / sizeof(u16); addr++) {
+			temp = swab16(*eepdata);
+			*eepdata = temp;
+			eepdata++;
 		}
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index f204099..c6dba9b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -731,6 +731,7 @@ enum ath_cal_list {
 #define AH_USE_EEPROM   0x1
 #define AH_UNPLUGGED    0x2 /* The card has been physically removed. */
 #define AH_FASTCC       0x4
+#define AH_NO_EEP_SWAP  0x8 /* Do not swap EEPROM data */
 
 struct ath_hw {
 	struct ath_ops reg_ops;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 0d80011..3a1da83 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -531,6 +531,8 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 		ah->is_clk_25mhz = pdata->is_clk_25mhz;
 		ah->get_mac_revision = pdata->get_mac_revision;
 		ah->external_reset = pdata->external_reset;
+		if (!pdata->endian_check)
+			ah->ah_flags |= AH_NO_EEP_SWAP;
 	}
 
 	common->ops = &ah->reg_ops;
diff --git a/include/linux/ath9k_platform.h b/include/linux/ath9k_platform.h
index a495a95..4350165 100644
--- a/include/linux/ath9k_platform.h
+++ b/include/linux/ath9k_platform.h
@@ -31,6 +31,7 @@ struct ath9k_platform_data {
 	u32 gpio_mask;
 	u32 gpio_val;
 
+	bool endian_check;
 	bool is_clk_25mhz;
 	bool tx_gain_buffalo;
 
-- 
2.1.2

