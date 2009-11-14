Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:61072 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751300AbZKNTUt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Nov 2009 14:20:49 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 1/2] rt2x00: Log RT/RF chipset information correctly.
Date: Sat, 14 Nov 2009 20:20:35 +0100
Message-Id: <1258226436-4673-2-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1258226436-4673-1-git-send-email-gwingerde@gmail.com>
References: <1258226436-4673-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some drivers (rt2800* most notably) cannot set the RF and RT chipset in
the correct order to have the information logging in rt2x00_set_chip
be correct.
Fix this by decoupling the setting of the chipset information from the
logging of the chipset information so that drivers can determine
themselves when all information is set.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    1 +
 drivers/net/wireless/rt2x00/rt2500pci.c |    1 +
 drivers/net/wireless/rt2x00/rt2500usb.c |    1 +
 drivers/net/wireless/rt2x00/rt2800lib.c |    1 +
 drivers/net/wireless/rt2x00/rt2x00.h    |   11 +++++++----
 drivers/net/wireless/rt2x00/rt61pci.c   |    1 +
 drivers/net/wireless/rt2x00/rt73usb.c   |    1 +
 7 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 0f912f5..6e68bc7 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1341,6 +1341,7 @@ static int rt2400pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
 	rt2x00pci_register_read(rt2x00dev, CSR0, &reg);
 	rt2x00_set_chip_rf(rt2x00dev, value, reg);
+	rt2x00_print_chip(rt2x00dev);
 
 	if (!rt2x00_rf(&rt2x00dev->chip, RF2420) &&
 	    !rt2x00_rf(&rt2x00dev->chip, RF2421)) {
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 6618cbd..9a31e5e 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1505,6 +1505,7 @@ static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
 	rt2x00pci_register_read(rt2x00dev, CSR0, &reg);
 	rt2x00_set_chip_rf(rt2x00dev, value, reg);
+	rt2x00_print_chip(rt2x00dev);
 
 	if (!rt2x00_rf(&rt2x00dev->chip, RF2522) &&
 	    !rt2x00_rf(&rt2x00dev->chip, RF2523) &&
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index bb64473..b2de43e 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1409,6 +1409,7 @@ static int rt2500usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
 	rt2500usb_register_read(rt2x00dev, MAC_CSR0, &reg);
 	rt2x00_set_chip(rt2x00dev, RT2570, value, reg);
+	rt2x00_print_chip(rt2x00dev);
 
 	if (!rt2x00_check_rev(&rt2x00dev->chip, 0x000ffff0, 0) ||
 	    rt2x00_check_rev(&rt2x00dev->chip, 0x0000000f, 0)) {
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index d88857c..c710805 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1854,6 +1854,7 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 			return -ENODEV;
 		}
 	}
+	rt2x00_print_chip(rt2x00dev);
 
 	if (!rt2x00_rf(&rt2x00dev->chip, RF2820) &&
 	    !rt2x00_rf(&rt2x00dev->chip, RF2850) &&
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 62da572..1cbb7ac 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -906,10 +906,6 @@ static inline void rt2x00_eeprom_write(struct rt2x00_dev *rt2x00dev,
 static inline void rt2x00_set_chip(struct rt2x00_dev *rt2x00dev,
 				   const u16 rt, const u16 rf, const u32 rev)
 {
-	INFO(rt2x00dev,
-	     "Chipset detected - rt: %04x, rf: %04x, rev: %08x.\n",
-	     rt, rf, rev);
-
 	rt2x00dev->chip.rt = rt;
 	rt2x00dev->chip.rf = rf;
 	rt2x00dev->chip.rev = rev;
@@ -927,6 +923,13 @@ static inline void rt2x00_set_chip_rf(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_chip(rt2x00dev, rt2x00dev->chip.rt, rf, rev);
 }
 
+static inline void rt2x00_print_chip(struct rt2x00_dev *rt2x00dev)
+{
+	INFO(rt2x00dev,
+	     "Chipset detected - rt: %04x, rf: %04x, rev: %08x.\n",
+	     rt2x00dev->chip.rt, rt2x00dev->chip.rf, rt2x00dev->chip.rev);
+}
+
 static inline char rt2x00_rt(const struct rt2x00_chip *chipset, const u16 chip)
 {
 	return (chipset->rt == chip);
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 6e46135..bf04605 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2300,6 +2300,7 @@ static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
 	rt2x00pci_register_read(rt2x00dev, MAC_CSR0, &reg);
 	rt2x00_set_chip_rf(rt2x00dev, value, reg);
+	rt2x00_print_chip(rt2x00dev);
 
 	if (!rt2x00_rf(&rt2x00dev->chip, RF5225) &&
 	    !rt2x00_rf(&rt2x00dev->chip, RF5325) &&
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 7236f01..5bbcf66 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1825,6 +1825,7 @@ static int rt73usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
 	rt2x00usb_register_read(rt2x00dev, MAC_CSR0, &reg);
 	rt2x00_set_chip(rt2x00dev, RT2571, value, reg);
+	rt2x00_print_chip(rt2x00dev);
 
 	if (!rt2x00_check_rev(&rt2x00dev->chip, 0x000ffff0, 0x25730) ||
 	    rt2x00_check_rev(&rt2x00dev->chip, 0x0000000f, 0)) {
-- 
1.6.5.2

