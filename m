Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:38635 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755527Ab3C3Nwi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Mar 2013 09:52:38 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	users@rt2x00.serialmonkey.com, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 2/3] rt2x00: rt2800lib: separate RT and RF chipset detection
Date: Sat, 30 Mar 2013 14:53:09 +0100
Message-Id: <1364651590-29710-3-git-send-email-juhosg@openwrt.org> (sfid-20130330_145249_132381_655B486F)
In-Reply-To: <1364651590-29710-1-git-send-email-juhosg@openwrt.org>
References: <1364651590-29710-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the newly introduced rt2x00_set_{rf,rt} helpers
to set the RT and RF chipset separately.

This change makes it possible to move the RT
detection code into another function which will
be done in a subseqent patch.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   56 ++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index f08a042..c4cc624 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -5434,33 +5434,19 @@ static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	u32 reg;
 	u16 value;
 	u16 eeprom;
+	u32 rt;
+	u32 rev;
+	u16 rf;
 
-	/*
-	 * Read EEPROM word for configuration.
-	 */
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
-
-	/*
-	 * Identify RF chipset by EEPROM value
-	 * RT28xx/RT30xx: defined in "EEPROM_NIC_CONF0_RF_TYPE" field
-	 * RT53xx: defined in "EEPROM_CHIP_ID" field
-	 */
 	if (rt2x00_rt(rt2x00dev, RT3290))
 		rt2800_register_read(rt2x00dev, MAC_CSR0_3290, &reg);
 	else
 		rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
 
-	if (rt2x00_get_field32(reg, MAC_CSR0_CHIPSET) == RT3290 ||
-	    rt2x00_get_field32(reg, MAC_CSR0_CHIPSET) == RT5390 ||
-	    rt2x00_get_field32(reg, MAC_CSR0_CHIPSET) == RT5392)
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_CHIP_ID, &value);
-	else
-		value = rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RF_TYPE);
-
-	rt2x00_set_chip(rt2x00dev, rt2x00_get_field32(reg, MAC_CSR0_CHIPSET),
-			value, rt2x00_get_field32(reg, MAC_CSR0_REVISION));
+	rt = rt2x00_get_field32(reg, MAC_CSR0_CHIPSET);
+	rev = rt2x00_get_field32(reg, MAC_CSR0_REVISION);
 
-	switch (rt2x00dev->chip.rt) {
+	switch (rt) {
 	case RT2860:
 	case RT2872:
 	case RT2883:
@@ -5476,11 +5462,32 @@ static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	case RT5592:
 		break;
 	default:
-		ERROR(rt2x00dev, "Invalid RT chipset 0x%04x detected.\n", rt2x00dev->chip.rt);
+		ERROR(rt2x00dev,
+		      "Invalid RT chipset 0x%04x, rev %04x detected.\n",
+		      rt, rev);
 		return -ENODEV;
 	}
 
-	switch (rt2x00dev->chip.rf) {
+	rt2x00_set_rt(rt2x00dev, rt, rev);
+
+	/*
+	 * Read EEPROM word for configuration.
+	 */
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
+
+	/*
+	 * Identify RF chipset by EEPROM value
+	 * RT28xx/RT30xx: defined in "EEPROM_NIC_CONF0_RF_TYPE" field
+	 * RT53xx: defined in "EEPROM_CHIP_ID" field
+	 */
+	if (rt2x00_rt(rt2x00dev, RT3290) ||
+	    rt2x00_rt(rt2x00dev, RT5390) ||
+	    rt2x00_rt(rt2x00dev, RT5392))
+		rt2x00_eeprom_read(rt2x00dev, EEPROM_CHIP_ID, &rf);
+	else
+		rf = rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RF_TYPE);
+
+	switch (rf) {
 	case RF2820:
 	case RF2850:
 	case RF2720:
@@ -5501,11 +5508,12 @@ static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	case RF5592:
 		break;
 	default:
-		ERROR(rt2x00dev, "Invalid RF chipset 0x%04x detected.\n",
-		      rt2x00dev->chip.rf);
+		ERROR(rt2x00dev, "Invalid RF chipset 0x%04x detected.\n", rf);
 		return -ENODEV;
 	}
 
+	rt2x00_set_rf(rt2x00dev, rf);
+
 	/*
 	 * Identify default antenna configuration.
 	 */
-- 
1.7.10

