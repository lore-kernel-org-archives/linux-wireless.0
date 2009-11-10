Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:49861 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758372AbZKJVmU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 16:42:20 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH v2] rt2x00: Properly detect Ralink RT3070 devices.
Date: Tue, 10 Nov 2009 22:41:51 +0100
Message-Id: <1257889311-354-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow rt2800usb to properly detect RT307X based devices, and set the appropriate chipset values.

Signed-off-by: Gertjan van Wingede <gwingerde@gmail.com>
---

Rebased to apply on top of Bart's second series of unification patches.

---
 drivers/net/wireless/rt2x00/rt2800lib.c |   28 +++++++++++++++-------------
 drivers/net/wireless/rt2x00/rt2x00.h    |    1 +
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index eb6d129..c41bb4a 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1828,24 +1828,26 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
 	rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
 
+	rt2x00_set_chip_rf(rt2x00dev, value, reg);
+
 	if (rt2x00_intf_is_usb(rt2x00dev)) {
 		struct rt2x00_chip *chip = &rt2x00dev->chip;
 
-		rt2x00_set_chip(rt2x00dev, RT2870, value, reg);
-
 		/*
 		 * The check for rt2860 is not a typo, some rt2870 hardware
 		 * identifies itself as rt2860 in the CSR register.
 		 */
-		if (!rt2x00_check_rev(chip, 0xfff00000, 0x28600000) &&
-		    !rt2x00_check_rev(chip, 0xfff00000, 0x28700000) &&
-		    !rt2x00_check_rev(chip, 0xfff00000, 0x28800000) &&
-		    !rt2x00_check_rev(chip, 0xffff0000, 0x30700000)) {
+		if (rt2x00_check_rev(chip, 0xfff00000, 0x28600000) ||
+		    rt2x00_check_rev(chip, 0xfff00000, 0x28700000) ||
+		    rt2x00_check_rev(chip, 0xfff00000, 0x28800000)) {
+			rt2x00_set_chip_rt(rt2x00dev, RT2870);
+		} else if (rt2x00_check_rev(chip, 0xffff0000, 0x30700000)) {
+			rt2x00_set_chip_rt(rt2x00dev, RT3070);
+		} else {
 			ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
 			return -ENODEV;
 		}
-	} else if (rt2x00_intf_is_pci(rt2x00dev))
-		rt2x00_set_chip_rf(rt2x00dev, value, reg);
+	}
 
 	if (!rt2x00_rf(&rt2x00dev->chip, RF2820) &&
 	    !rt2x00_rf(&rt2x00dev->chip, RF2850) &&
@@ -1853,10 +1855,8 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	    !rt2x00_rf(&rt2x00dev->chip, RF2750) &&
 	    !rt2x00_rf(&rt2x00dev->chip, RF3020) &&
 	    !rt2x00_rf(&rt2x00dev->chip, RF2020) &&
-	    (rt2x00_intf_is_usb(rt2x00dev) ||
-	     (rt2x00_intf_is_pci(rt2x00dev) &&
-	      !rt2x00_rf(&rt2x00dev->chip, RF3021) &&
-	      !rt2x00_rf(&rt2x00dev->chip, RF3022)))) {
+	    !rt2x00_rf(&rt2x00dev->chip, RF3021) &&
+	    !rt2x00_rf(&rt2x00dev->chip, RF3022)) {
 		ERROR(rt2x00dev, "Invalid RF chipset detected.\n");
 		return -ENODEV;
 	}
@@ -2057,7 +2057,9 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 		spec->channels = rf_vals;
 	} else if (rt2x00_intf_is_usb(rt2x00dev) &&
 		    (rt2x00_rf(chip, RF3020) ||
-		     rt2x00_rf(chip, RF2020))) {
+		     rt2x00_rf(chip, RF2020) ||
+		     rt2x00_rf(chip, RF3021) ||
+		     rt2x00_rf(chip, RF3022))) {
 		spec->num_channels = ARRAY_SIZE(rf_vals_3070);
 		spec->channels = rf_vals_3070;
 	}
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 5a1b161..62da572 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -172,6 +172,7 @@ struct rt2x00_chip {
 #define RT3052		0x3052	/* WSOC */
 #define RT3090		0x3090	/* 2.4GHz PCIe */
 #define RT2870		0x1600
+#define RT3070		0x1800
 
 	u16 rf;
 	u32 rev;
-- 
1.6.5.2

