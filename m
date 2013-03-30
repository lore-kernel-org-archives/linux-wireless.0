Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:38637 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756101Ab3C3Nwi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Mar 2013 09:52:38 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	users@rt2x00.serialmonkey.com, Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 3/3] rt2x00: rt2800lib: probe RT chipset earlier
Date: Sat, 30 Mar 2013 14:53:10 +0100
Message-Id: <1364651590-29710-4-git-send-email-juhosg@openwrt.org> (sfid-20130330_145248_384840_77149B88)
In-Reply-To: <1364651590-29710-1-git-send-email-juhosg@openwrt.org>
References: <1364651590-29710-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 'rt2800_validate_eeprom' function uses the type of
the RT chipset for verifying the number of RX streams
on RT28x0 devices. However the type of the RT chipset
is not yet detected when the 'rt2800_validate_eeprom'
function is called.

Move the RT chipset detection code into a separate helper
function, and call it before rt2800_validate_eeprom.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   80 +++++++++++++++++--------------
 1 file changed, 45 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index c4cc624..7deac4d 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -5431,45 +5431,10 @@ static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 
 static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 {
-	u32 reg;
 	u16 value;
 	u16 eeprom;
-	u32 rt;
-	u32 rev;
 	u16 rf;
 
-	if (rt2x00_rt(rt2x00dev, RT3290))
-		rt2800_register_read(rt2x00dev, MAC_CSR0_3290, &reg);
-	else
-		rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
-
-	rt = rt2x00_get_field32(reg, MAC_CSR0_CHIPSET);
-	rev = rt2x00_get_field32(reg, MAC_CSR0_REVISION);
-
-	switch (rt) {
-	case RT2860:
-	case RT2872:
-	case RT2883:
-	case RT3070:
-	case RT3071:
-	case RT3090:
-	case RT3290:
-	case RT3352:
-	case RT3390:
-	case RT3572:
-	case RT5390:
-	case RT5392:
-	case RT5592:
-		break;
-	default:
-		ERROR(rt2x00dev,
-		      "Invalid RT chipset 0x%04x, rev %04x detected.\n",
-		      rt, rev);
-		return -ENODEV;
-	}
-
-	rt2x00_set_rt(rt2x00dev, rt, rev);
-
 	/*
 	 * Read EEPROM word for configuration.
 	 */
@@ -6067,11 +6032,56 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	return 0;
 }
 
+static int rt2800_probe_rt(struct rt2x00_dev *rt2x00dev)
+{
+	u32 reg;
+	u32 rt;
+	u32 rev;
+
+	if (rt2x00_rt(rt2x00dev, RT3290))
+		rt2800_register_read(rt2x00dev, MAC_CSR0_3290, &reg);
+	else
+		rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
+
+	rt = rt2x00_get_field32(reg, MAC_CSR0_CHIPSET);
+	rev = rt2x00_get_field32(reg, MAC_CSR0_REVISION);
+
+	switch (rt) {
+	case RT2860:
+	case RT2872:
+	case RT2883:
+	case RT3070:
+	case RT3071:
+	case RT3090:
+	case RT3290:
+	case RT3352:
+	case RT3390:
+	case RT3572:
+	case RT5390:
+	case RT5392:
+	case RT5592:
+		break;
+	default:
+		ERROR(rt2x00dev,
+		      "Invalid RT chipset 0x%04x, rev %04x detected.\n",
+		      rt, rev);
+		return -ENODEV;
+	}
+
+	rt2x00_set_rt(rt2x00dev, rt, rev);
+
+	return 0;
+}
+
 int rt2800_probe_hw(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
 	u32 reg;
 
+	retval = rt2800_probe_rt(rt2x00dev);
+	if (retval)
+		return retval;
+
 	/*
 	 * Allocate eeprom data.
 	 */
-- 
1.7.10

