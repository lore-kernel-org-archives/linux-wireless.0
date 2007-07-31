Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:48192 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095AbXGaSd6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 14:33:58 -0400
Received: by ug-out-1314.google.com with SMTP id j3so121179ugf
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 11:33:57 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 02/24] rt2x00: Put rf register value detection in function
Date: Tue, 31 Jul 2007 20:37:00 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707312037.00253.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From b484f881e934f37c2da84e91b879f0416abecb4a Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Fri, 27 Jul 2007 17:34:23 +0200
Subject: [PATCH 02/24] rt2x00: Put rf register value detection in function

Create a get_rf_vals where the RF register values are
being determined based on the channel and chipset.
This cleans up the channel switch code itself and makes
it easier to cleanup get_rf_vals a bit later as well
since the code is still messy.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2400pci.c |   66 +++++++++--------
 drivers/net/wireless/rt2500pci.c |  144 ++++++++++++++++++++-----------------
 drivers/net/wireless/rt2500usb.c |  145 ++++++++++++++++++++-----------------
 drivers/net/wireless/rt2x00.h    |   11 +++
 drivers/net/wireless/rt61pci.c   |  145 ++++++++++++++++++++-----------------
 drivers/net/wireless/rt73usb.c   |  148 ++++++++++++++++++++------------------
 6 files changed, 358 insertions(+), 301 deletions(-)

diff --git a/drivers/net/wireless/rt2400pci.c b/drivers/net/wireless/rt2400pci.c
index a69e0f6..55975d3 100644
--- a/drivers/net/wireless/rt2400pci.c
+++ b/drivers/net/wireless/rt2400pci.c
@@ -330,22 +330,37 @@ static void rt2400pci_config_type(struct rt2x00_dev *rt2x00dev, int type)
 	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 }
 
+static void rt2400pci_get_rf_vals(struct rt2x00_dev *rt2x00dev,
+	const int value, const int channel, struct rf_reg *reg)
+{
+	reg->rf1 = 0x00022058;
+	reg->rf2 = value;
+	if (rt2x00_rf(&rt2x00dev->chip, RF2420))
+		reg->rf3 = 0x00000111;
+	else
+		reg->rf3 = 0x00000101;
+	reg->rf4 = 0;
+}
+
 static void rt2400pci_config_channel(struct rt2x00_dev *rt2x00dev,
 	const int value, const int channel, const int txpower)
 {
-	u32 rf1 = rt2x00dev->rf1;
-	u32 rf2 = value;
-	u32 rf3 = rt2x00dev->rf3;
+	struct rf_reg reg;
+
+	/*
+	 * Fill rf_reg structure.
+	 */
+	rt2400pci_get_rf_vals(rt2x00dev, value, channel, &reg);
 
 	/*
 	 * Switch on tuning bits.
 	 */
-	rt2x00_set_field32(&rf1, RF1_TUNER, 1);
-	rt2x00_set_field32(&rf3, RF3_TUNER, 1);
+	rt2x00_set_field32(&reg.rf1, RF1_TUNER, 1);
+	rt2x00_set_field32(&reg.rf3, RF3_TUNER, 1);
 
-	rt2400pci_rf_write(rt2x00dev, rf1);
-	rt2400pci_rf_write(rt2x00dev, rf2);
-	rt2400pci_rf_write(rt2x00dev, rf3);
+	rt2400pci_rf_write(rt2x00dev, reg.rf1);
+	rt2400pci_rf_write(rt2x00dev, reg.rf2);
+	rt2400pci_rf_write(rt2x00dev, reg.rf3);
 
 	/*
 	 * RF2420 chipset don't need any additional actions.
@@ -358,38 +373,38 @@ static void rt2400pci_config_channel(struct rt2x00_dev *rt2x00dev,
 	 * reference clock rate to activate auto_tune.
 	 * After that we set the value back to the correct channel.
 	 */
-	rt2400pci_rf_write(rt2x00dev, rf1);
+	rt2400pci_rf_write(rt2x00dev, reg.rf1);
 	rt2400pci_rf_write(rt2x00dev, 0x000c2a32);
-	rt2400pci_rf_write(rt2x00dev, rf3);
+	rt2400pci_rf_write(rt2x00dev, reg.rf3);
 
 	msleep(1);
 
-	rt2400pci_rf_write(rt2x00dev, rf1);
-	rt2400pci_rf_write(rt2x00dev, rf2);
-	rt2400pci_rf_write(rt2x00dev, rf3);
+	rt2400pci_rf_write(rt2x00dev, reg.rf1);
+	rt2400pci_rf_write(rt2x00dev, reg.rf2);
+	rt2400pci_rf_write(rt2x00dev, reg.rf3);
 
 	msleep(1);
 
 	/*
 	 * Switch off tuning bits.
 	 */
-	rt2x00_set_field32(&rf1, RF1_TUNER, 0);
-	rt2x00_set_field32(&rf3, RF3_TUNER, 0);
+	rt2x00_set_field32(&reg.rf1, RF1_TUNER, 0);
+	rt2x00_set_field32(&reg.rf3, RF3_TUNER, 0);
 
-	rt2400pci_rf_write(rt2x00dev, rf1);
-	rt2400pci_rf_write(rt2x00dev, rf3);
+	rt2400pci_rf_write(rt2x00dev, reg.rf1);
+	rt2400pci_rf_write(rt2x00dev, reg.rf3);
 
 	/*
 	 * Update rf fields
 	 */
-	rt2x00dev->rf1 = rf1;
-	rt2x00dev->rf2 = rf2;
-	rt2x00dev->rf3 = rf3;
+	rt2x00dev->rf1 = reg.rf1;
+	rt2x00dev->rf2 = reg.rf2;
+	rt2x00dev->rf3 = reg.rf3;
 
 	/*
 	 * Clear false CRC during channel switch.
 	 */
-	rt2x00pci_register_read(rt2x00dev, CNT0, &rf1);
+	rt2x00pci_register_read(rt2x00dev, CNT0, &reg.rf1);
 }
 
 static void rt2400pci_config_txpower(struct rt2x00_dev *rt2x00dev, int txpower)
@@ -1415,15 +1430,6 @@ static void rt2400pci_init_hw_mode(struct rt2x00_dev *rt2x00dev)
 		rt2x00_eeprom_addr(rt2x00dev, EEPROM_MAC_ADDR_0));
 
 	/*
-	 * Set device specific, but channel independent RF values.
-	 */
-	rt2x00dev->rf1 = 0x00022058;
-	if (rt2x00_rf(&rt2x00dev->chip, RF2420))
-		rt2x00dev->rf3 = 0x00000111;
-	else
-		rt2x00dev->rf3 = 0x00000101;
-
-	/*
 	 * Convert tx_power array in eeprom.
 	 */
 	txpower = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_START);
diff --git a/drivers/net/wireless/rt2500pci.c b/drivers/net/wireless/rt2500pci.c
index 76f5551..0535c1d 100644
--- a/drivers/net/wireless/rt2500pci.c
+++ b/drivers/net/wireless/rt2500pci.c
@@ -337,53 +337,86 @@ static void rt2500pci_config_type(struct rt2x00_dev *rt2x00dev,
 	rt2x00pci_register_write(rt2x00dev, CSR14, reg);
 }
 
-static void rt2500pci_config_channel(struct rt2x00_dev *rt2x00dev,
-	const int value, const int channel, const int txpower)
-{
-	u32 rf1 = rt2x00dev->rf1;
-	u32 rf2 = value;
-	u32 rf3 = rt2x00dev->rf3;
-	u32 rf4 = rt2x00dev->rf4;
-	u8 r70;
+static const struct {
+	unsigned int chip;
+	u32 val[3];
+} rf_vals[] = {
+	{ RF2522,	{ 0x00002050, 0x00000101, 0x00000000 } },
+	{ RF2523,	{ 0x00022010, 0x000e0111, 0x00000a1b } },
+	{ RF2524,	{ 0x00032020, 0x00000101, 0x00000a1b } },
+	{ RF2525,	{ 0x00022020, 0x00060111, 0x00000a1b } },
+	{ RF2525E,	{ 0x00022020, 0x00060111, 0x00000a0b } },
+};
 
-	if (rt2x00_rf(&rt2x00dev->chip, RF2525) ||
-	    rt2x00_rf(&rt2x00dev->chip, RF2525E))
-		rf2 |= 0x00080000;
+static void rt2500pci_get_rf_vals(struct rt2x00_dev *rt2x00dev,
+	const int value, const int channel, struct rf_reg *reg)
+{
+	unsigned int i;
 
-	if (rt2x00_rf(&rt2x00dev->chip, RF2525E) && channel == 14)
-		rf4 |= 0x00000010;
+	reg->rf1 = 0;
+	reg->rf2 = value;
+	reg->rf3 = 0;
+	reg->rf4 = 0;
 
 	if (rt2x00_rf(&rt2x00dev->chip, RF5222)) {
+		reg->rf3 = 0x00000101;
 		if (channel < 14) {
-			rf1 = 0x00022020;
-			rf4 = 0x00000a0b;
+			reg->rf1 = 0x00022020;
+			reg->rf4 = 0x00000a0b;
 		} else if (channel == 14) {
-			rf1 = 0x00022010;
-			rf4 = 0x00000a1b;
+			reg->rf1 = 0x00022010;
+			reg->rf4 = 0x00000a1b;
 		} else if (channel < 64) {
-			rf1 = 0x00022010;
-			rf4 = 0x00000a1f;
+			reg->rf1 = 0x00022010;
+			reg->rf4 = 0x00000a1f;
 		} else if (channel < 140) {
-			rf1 = 0x00022010;
-			rf4 = 0x00000a0f;
+			reg->rf1 = 0x00022010;
+			reg->rf4 = 0x00000a0f;
 		} else if (channel < 161) {
-			rf1 = 0x00022020;
-			rf4 = 0x00000a07;
+			reg->rf1 = 0x00022020;
+			reg->rf4 = 0x00000a07;
 		}
+	} else {
+		if (rt2x00_rf(&rt2x00dev->chip, RF2525) ||
+		    rt2x00_rf(&rt2x00dev->chip, RF2525E))
+			reg->rf2 |= 0x00080000;
+
+		for (i = 0; i < ARRAY_SIZE(rf_vals); i++) {
+			if (rt2x00_rf(&rt2x00dev->chip, rf_vals[i].chip)) {
+				reg->rf1 = rf_vals[i].val[0];
+				reg->rf3 = rf_vals[i].val[1];
+				reg->rf4 = rf_vals[i].val[2];
+			}
+		}
+
+		if (rt2x00_rf(&rt2x00dev->chip, RF2525E) && channel == 14)
+			reg->rf4 |= 0x00000010;
 	}
+}
+
+static void rt2500pci_config_channel(struct rt2x00_dev *rt2x00dev,
+	const int value, const int channel, const int txpower)
+{
+	struct rf_reg reg;
+	u8 r70;
+
+	/*
+	 * Fill rf_reg structure.
+	 */
+	rt2500pci_get_rf_vals(rt2x00dev, value, channel, &reg);
 
 	/*
 	 * Set TXpower.
 	 */
-	rt2x00_set_field32(&rf3, RF3_TXPOWER, TXPOWER_TO_DEV(txpower));
+	rt2x00_set_field32(&reg.rf3, RF3_TXPOWER, TXPOWER_TO_DEV(txpower));
 
 	/*
 	 * Switch on tuning bits.
 	 * For RT2523 devices we do not need to update the R1 register.
 	 */
 	if (!rt2x00_rf(&rt2x00dev->chip, RF2523))
-		rt2x00_set_field32(&rf1, RF1_TUNER, 1);
-	rt2x00_set_field32(&rf3, RF3_TUNER, 1);
+		rt2x00_set_field32(&reg.rf1, RF1_TUNER, 1);
+	rt2x00_set_field32(&reg.rf3, RF3_TUNER, 1);
 
 	/*
 	 * For RT2525 we should first set the channel to half band higher.
@@ -396,18 +429,18 @@ static void rt2500pci_config_channel(struct rt2x00_dev *rt2x00dev,
 			0x00080d2e, 0x00080d3a
 		};
 
-		rt2500pci_rf_write(rt2x00dev, rf1);
+		rt2500pci_rf_write(rt2x00dev, reg.rf1);
 		rt2500pci_rf_write(rt2x00dev, vals[channel - 1]);
-		rt2500pci_rf_write(rt2x00dev, rf3);
-		if (rf4)
-			rt2500pci_rf_write(rt2x00dev, rf4);
+		rt2500pci_rf_write(rt2x00dev, reg.rf3);
+		if (reg.rf4)
+			rt2500pci_rf_write(rt2x00dev, reg.rf4);
 	}
 
-	rt2500pci_rf_write(rt2x00dev, rf1);
-	rt2500pci_rf_write(rt2x00dev, rf2);
-	rt2500pci_rf_write(rt2x00dev, rf3);
-	if (rf4)
-		rt2500pci_rf_write(rt2x00dev, rf4);
+	rt2500pci_rf_write(rt2x00dev, reg.rf1);
+	rt2500pci_rf_write(rt2x00dev, reg.rf2);
+	rt2500pci_rf_write(rt2x00dev, reg.rf3);
+	if (reg.rf4)
+		rt2500pci_rf_write(rt2x00dev, reg.rf4);
 
 	/*
 	 * Channel 14 requires the Japan filter bit to be set.
@@ -422,28 +455,28 @@ static void rt2500pci_config_channel(struct rt2x00_dev *rt2x00dev,
 	 * Switch off tuning bits.
 	 * For RT2523 devices we do not need to update the R1 register.
 	 */
-	rt2x00_set_field32(&rf1, RF1_TUNER, 0);
-	rt2x00_set_field32(&rf3, RF3_TUNER, 0);
+	rt2x00_set_field32(&reg.rf1, RF1_TUNER, 0);
+	rt2x00_set_field32(&reg.rf3, RF3_TUNER, 0);
 
 
 	if (!rt2x00_rf(&rt2x00dev->chip, RF2523))
-		rt2500pci_rf_write(rt2x00dev, rf1);
+		rt2500pci_rf_write(rt2x00dev, reg.rf1);
 
-	rt2500pci_rf_write(rt2x00dev, rf3);
+	rt2500pci_rf_write(rt2x00dev, reg.rf3);
 
 	/*
 	 * Update rf fields
 	 */
-	rt2x00dev->rf1 = rf1;
-	rt2x00dev->rf2 = rf2;
-	rt2x00dev->rf3 = rf3;
-	rt2x00dev->rf4 = rf4;
+	rt2x00dev->rf1 = reg.rf1;
+	rt2x00dev->rf2 = reg.rf2;
+	rt2x00dev->rf3 = reg.rf3;
+	rt2x00dev->rf4 = reg.rf4;
 	rt2x00dev->tx_power = txpower;
 
 	/*
 	 * Clear false CRC during channel switch.
 	 */
-	rt2x00pci_register_read(rt2x00dev, CNT0, &rf1);
+	rt2x00pci_register_read(rt2x00dev, CNT0, &reg.rf1);
 }
 
 static void rt2500pci_config_txpower(struct rt2x00_dev *rt2x00dev,
@@ -1565,18 +1598,6 @@ static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	return 0;
 }
 
-static const struct {
-	unsigned int chip;
-	u32 val[3];
-} rf_vals[] = {
-	{ RF2522,	{ 0x00002050, 0x00000101, 0x00000000 } },
-	{ RF2523,	{ 0x00022010, 0x000e0111, 0x00000a1b } },
-	{ RF2524,	{ 0x00032020, 0x00000101, 0x00000a1b } },
-	{ RF2525,	{ 0x00022020, 0x00060111, 0x00000a1b } },
-	{ RF2525E,	{ 0x00022020, 0x00060111, 0x00000a0b } },
-	{ RF5222,	{ 0x00000000, 0x00000101, 0x00000000 } },
-};
-
 /*
  * RF value list for RF2522
  * Supports: 2.4 GHz
@@ -1644,17 +1665,6 @@ static void rt2500pci_init_hw_mode(struct rt2x00_dev *rt2x00dev)
 		rt2x00_eeprom_addr(rt2x00dev, EEPROM_MAC_ADDR_0));
 
 	/*
-	 * Set device specific, but channel independent RF values.
-	 */
-	for (i = 0; i < ARRAY_SIZE(rf_vals); i++) {
-		if (rt2x00_rf(&rt2x00dev->chip, rf_vals[i].chip)) {
-			rt2x00dev->rf1 = rf_vals[i].val[0];
-			rt2x00dev->rf3 = rf_vals[i].val[1];
-			rt2x00dev->rf4 = rf_vals[i].val[2];
-		}
-	}
-
-	/*
 	 * Convert tx_power array in eeprom.
 	 */
 	txpower = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_START);
diff --git a/drivers/net/wireless/rt2500usb.c b/drivers/net/wireless/rt2500usb.c
index 2cceb6c..375971e 100644
--- a/drivers/net/wireless/rt2500usb.c
+++ b/drivers/net/wireless/rt2500usb.c
@@ -335,55 +335,87 @@ static void rt2500usb_config_type(struct rt2x00_dev *rt2x00dev,
 	rt2500usb_register_write(rt2x00dev, TXRX_CSR19, reg);
 }
 
-static void rt2500usb_config_channel(struct rt2x00_dev *rt2x00dev,
-	const int value, const int channel, const int txpower)
-{
-	u32 rf1 = rt2x00dev->rf1;
-	u32 rf2 = value;
-	u32 rf3 = rt2x00dev->rf3;
-	u32 rf4 = rt2x00dev->rf4;
-
-	if (rt2x00_rf(&rt2x00dev->chip, RF2525))
-		rf2 |= 0x00080000;
+static const struct {
+	unsigned int chip;
+	u32 val[3];
+} rf_vals[] = {
+	{ RF2522,	{ 0x00002050, 0x00000101, 0x00000000 } },
+	{ RF2523,	{ 0x00022010, 0x000e0111, 0x00000a1b } },
+	{ RF2524,	{ 0x00032020, 0x00000101, 0x00000a1b } },
+	{ RF2525,	{ 0x00022020, 0x00060111, 0x00000a1b } },
+	{ RF2525E,	{ 0x00022010, 0x00060111, 0x00000000 } },
+};
 
-	if ((rt2x00_rf(&rt2x00dev->chip, RF2523) ||
-	     rt2x00_rf(&rt2x00dev->chip, RF2524) ||
-	     rt2x00_rf(&rt2x00dev->chip, RF2525)) &&
-	     channel == 14)
-		rf4 &= ~0x00000018;
+static void rt2500usb_get_rf_vals(struct rt2x00_dev *rt2x00dev,
+	const int value, const int channel, struct rf_reg *reg)
+{
+	unsigned int i;
 
-	if (rt2x00_rf(&rt2x00dev->chip, RF2525E)) {
-		if (channel & 0x01)
-			rf4 = 0x00000e1b;
-		else
-			rf4 = 0x00000e07;
-		if (channel == 14)
-			rf4 = 0x00000e23;
-	}
+	reg->rf1 = 0;
+	reg->rf2 = value;
+	reg->rf3 = 0;
+	reg->rf4 = 0;
 
 	if (rt2x00_rf(&rt2x00dev->chip, RF5222)) {
+		reg->rf3 = 0x00000101;
 		if (channel < 14) {
-			rf1 = 0x00022020;
-			rf4 = 0x00000a0b;
+			reg->rf1 = 0x00022020;
+			reg->rf4 = 0x00000a0b;
 		} else if (channel == 14) {
-			rf1 = 0x00022010;
-			rf4 = 0x00000a1b;
+			reg->rf1 = 0x00022010;
+			reg->rf4 = 0x00000a1b;
 		} else if (channel < 64) {
-			rf1 = 0x00022010;
-			rf4 = 0x00000a1f;
+			reg->rf1 = 0x00022010;
+			reg->rf4 = 0x00000a1f;
 		} else if (channel < 140) {
-			rf1 = 0x00022010;
-			rf4 = 0x00000a0f;
+			reg->rf1 = 0x00022010;
+			reg->rf4 = 0x00000a0f;
 		} else if (channel < 161) {
-			rf1 = 0x00022020;
-			rf4 = 0x00000a07;
+			reg->rf1 = 0x00022020;
+			reg->rf4 = 0x00000a07;
+		}
+	} else {
+		if (rt2x00_rf(&rt2x00dev->chip, RF2525))
+			reg->rf2 |= 0x00080000;
+
+		for (i = 0; i < ARRAY_SIZE(rf_vals); i++) {
+			if (rt2x00_rf(&rt2x00dev->chip, rf_vals[i].chip)) {
+				reg->rf1 = rf_vals[i].val[0];
+				reg->rf3 = rf_vals[i].val[1];
+				reg->rf4 = rf_vals[i].val[2];
+			}
+		}
+
+		if ((rt2x00_rf(&rt2x00dev->chip, RF2523) ||
+		     rt2x00_rf(&rt2x00dev->chip, RF2524) ||
+		     rt2x00_rf(&rt2x00dev->chip, RF2525)) &&
+		     channel == 14)
+			reg->rf4 &= ~0x00000018;
+		else if (rt2x00_rf(&rt2x00dev->chip, RF2525E)) {
+			if (channel & 0x01)
+				reg->rf4 = 0x00000e1b;
+			else
+				reg->rf4 = 0x00000e07;
+			if (channel == 14)
+				reg->rf4 = 0x00000e23;
 		}
 	}
+}
+
+static void rt2500usb_config_channel(struct rt2x00_dev *rt2x00dev,
+	const int value, const int channel, const int txpower)
+{
+	struct rf_reg reg;
+
+	/*
+	 * Fill rf_reg structure.
+	 */
+	rt2500usb_get_rf_vals(rt2x00dev, value, channel, &reg);
 
 	/*
 	 * Set TXpower.
 	 */
-	rt2x00_set_field32(&rf3, RF3_TXPOWER, TXPOWER_TO_DEV(txpower));
+	rt2x00_set_field32(&reg.rf3, RF3_TXPOWER, TXPOWER_TO_DEV(txpower));
 
 	/*
 	 * For RT2525E we should first set the channel to half band higher.
@@ -397,23 +429,23 @@ static void rt2500usb_config_channel(struct rt2x00_dev *rt2x00dev,
 		};
 
 		rt2500usb_rf_write(rt2x00dev, vals[channel - 1]);
-		if (rf4)
-			rt2500usb_rf_write(rt2x00dev, rf4);
+		if (reg.rf4)
+			rt2500usb_rf_write(rt2x00dev, reg.rf4);
 	}
 
-	rt2500usb_rf_write(rt2x00dev, rf1);
-	rt2500usb_rf_write(rt2x00dev, rf2);
-	rt2500usb_rf_write(rt2x00dev, rf3);
-	if (rf4)
-		rt2500usb_rf_write(rt2x00dev, rf4);
+	rt2500usb_rf_write(rt2x00dev, reg.rf1);
+	rt2500usb_rf_write(rt2x00dev, reg.rf2);
+	rt2500usb_rf_write(rt2x00dev, reg.rf3);
+	if (reg.rf4)
+		rt2500usb_rf_write(rt2x00dev, reg.rf4);
 
 	/*
 	 * Update rf fields
 	 */
-	rt2x00dev->rf1 = rf1;
-	rt2x00dev->rf2 = rf2;
-	rt2x00dev->rf3 = rf3;
-	rt2x00dev->rf4 = rf4;
+	rt2x00dev->rf1 = reg.rf1;
+	rt2x00dev->rf2 = reg.rf2;
+	rt2x00dev->rf3 = reg.rf3;
+	rt2x00dev->rf4 = reg.rf4;
 	rt2x00dev->tx_power = txpower;
 }
 
@@ -1274,18 +1306,6 @@ static int rt2500usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	return 0;
 }
 
-static const struct {
-	unsigned int chip;
-	u32 val[3];
-} rf_vals[] = {
-	{ RF2522,	{ 0x00002050, 0x00000101, 0x00000000 } },
-	{ RF2523,	{ 0x00022010, 0x000e0111, 0x00000a1b } },
-	{ RF2524,	{ 0x00032020, 0x00000101, 0x00000a1b } },
-	{ RF2525,	{ 0x00022020, 0x00060111, 0x00000a1b } },
-	{ RF2525E,	{ 0x00022010, 0x00060111, 0x00000000 } },
-	{ RF5222,	{ 0x00000000, 0x00000101, 0x00000000 } }
-};
-
 /*
  * RF value list for RF2522
  * Supports: 2.4 GHz
@@ -1357,17 +1377,6 @@ static void rt2500usb_init_hw_mode(struct rt2x00_dev *rt2x00dev)
 		rt2x00_eeprom_addr(rt2x00dev, EEPROM_MAC_ADDR_0));
 
 	/*
-	 * Set device specific, but channel independent RF values.
-	 */
-	for (i = 0; i < ARRAY_SIZE(rf_vals); i++) {
-		if (rt2x00_rf(&rt2x00dev->chip, rf_vals[i].chip)) {
-			rt2x00dev->rf1 = rf_vals[i].val[0];
-			rt2x00dev->rf3 = rf_vals[i].val[1];
-			rt2x00dev->rf4 = rf_vals[i].val[2];
-		}
-	}
-
-	/*
 	 * Convert tx_power array in eeprom.
 	 */
 	txpower = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_START);
diff --git a/drivers/net/wireless/rt2x00.h b/drivers/net/wireless/rt2x00.h
index cca9160..eb96d07 100644
--- a/drivers/net/wireless/rt2x00.h
+++ b/drivers/net/wireless/rt2x00.h
@@ -343,6 +343,17 @@ struct rt2x00_chip {
 };
 
 /*
+ * RF register collection structure
+ * This structure contains the value for all RF register words.
+ */
+struct rf_reg {
+	u32 rf1;
+	u32 rf2;
+	u32 rf3;
+	u32 rf4;
+};
+
+/*
  * data_desc
  * Each data entry also contains a descriptor which is used by the
  * device to determine what should be done with the packet and
diff --git a/drivers/net/wireless/rt61pci.c b/drivers/net/wireless/rt61pci.c
index 4d50f95..d900af3 100644
--- a/drivers/net/wireless/rt61pci.c
+++ b/drivers/net/wireless/rt61pci.c
@@ -354,138 +354,137 @@ static void rt61pci_config_type(struct rt2x00_dev *rt2x00dev,
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR9, reg);
 }
 
-static void rt61pci_config_channel(struct rt2x00_dev *rt2x00dev,
-	const int value, const int channel, const int txpower)
+static void rt61pci_get_rf_vals(struct rt2x00_dev *rt2x00dev,
+	const int value, const int channel, struct rf_reg *reg)
 {
-	u8 reg = 0;
-	u32 rf1 = 0;
-	u32 rf2 = value;
-	u32 rf3 = 0;
-	u32 rf4 = 0;
+	reg->rf1 = 0;
+	reg->rf2 = value;
+	reg->rf3 = 0;
+	reg->rf4 = 0;
 
 	if (!test_bit(CONFIG_RF_SEQUENCE, &rt2x00dev->flags) || channel <= 14)
-		rf1 = 0x00002ccc;
+		reg->rf1 = 0x00002ccc;
 	else if (channel == 36 ||
 		(channel >= 100 && channel <= 116) ||
 		channel >= 157)
-		rf1 = 0x00002cd4;
+		reg->rf1 = 0x00002cd4;
 	else
-		rf1 = 0x00002cd0;
+		reg->rf1 = 0x00002cd0;
 
 	if (channel <= 14) {
-		rf3 = 0x00068455;
+		reg->rf3 = 0x00068455;
 	} else if (!test_bit(CONFIG_RF_SEQUENCE, &rt2x00dev->flags)) {
 		if (channel >= 36 && channel <= 48)
-			rf3 = 0x0009be55;
+			reg->rf3 = 0x0009be55;
 		else if (channel >= 52 && channel <= 64)
-			rf3 = 0x0009ae55;
+			reg->rf3 = 0x0009ae55;
 		else if (channel >= 100 && channel <= 112)
-			rf3 = 0x000bae55;
+			reg->rf3 = 0x000bae55;
 		else
-			rf3 = 0x000bbe55;
+			reg->rf3 = 0x000bbe55;
 	} else {
 		switch (channel) {
 			case 36:
 			case 40:
 			case 44:
-				rf3 = 0x00098455;
+				reg->rf3 = 0x00098455;
 				break;
 			case 48:
-				rf3 = 0x00098655;
+				reg->rf3 = 0x00098655;
 				break;
 			case 52:
-				rf3 = 0x00098855;
+				reg->rf3 = 0x00098855;
 				break;
 			case 56:
-				rf3 = 0x00098c55;
+				reg->rf3 = 0x00098c55;
 
 			case 60:
-				rf3 = 0x00098e55;
+				reg->rf3 = 0x00098e55;
 				break;
 			case 64:
-				rf3 = 0x00099255;
+				reg->rf3 = 0x00099255;
 				break;
 			case 100:
 			case 104:
 			case 108:
-				rf3 = 0x000b9855;
+				reg->rf3 = 0x000b9855;
 				break;
 			case 112:
 			case 116:
 			case 120:
 			case 124:
-				rf3 = 0x000b9a55;
+				reg->rf3 = 0x000b9a55;
 				break;
 			case 128:
 			case 132:
-				rf3 = 0x000b9c55;
+				reg->rf3 = 0x000b9c55;
 				break;
 			case 136:
 			case 140:
-				rf3 = 0x000b9e55;
+				reg->rf3 = 0x000b9e55;
 				break;
 			case 149:
 			case 153:
 			case 157:
 			case 161:
 			case 165:
-				rf3 = 0x000ba255;
+				reg->rf3 = 0x000ba255;
 				break;
 		}
 	}
 
 	if (channel < 14) {
 		if (channel & 1)
-			rf4 = 0x000ffa0b;
+			reg->rf4 = 0x000ffa0b;
 		else
-			rf4 = 0x000ffa1f;
+			reg->rf4 = 0x000ffa1f;
 	} else if (channel == 14) {
-		rf4 = 0x000ffa13;
+		reg->rf4 = 0x000ffa13;
 	} else if (!test_bit(CONFIG_RF_SEQUENCE, &rt2x00dev->flags)) {
 		switch (channel) {
 			case 36:
 			case 56:
 			case 116:
 			case 136:
-				rf4 = 0x000ffa23;
+				reg->rf4 = 0x000ffa23;
 				break;
 			case 40:
 			case 60:
 			case 100:
 			case 120:
 			case 140:
-				rf4 = 0x000ffa03;
+				reg->rf4 = 0x000ffa03;
 				break;
 			case 44:
 			case 64:
 			case 104:
 			case 124:
-				rf4 = 0x000ffa0b;
+				reg->rf4 = 0x000ffa0b;
 				break;
 			case 48:
 			case 108:
 			case 128:
-				rf4 = 0x000ffa13;
+				reg->rf4 = 0x000ffa13;
 				break;
 			case 52:
 			case 112:
 			case 132:
-				rf4 = 0x000ffa1b;
+				reg->rf4 = 0x000ffa1b;
 				break;
 			case 149:
-				rf4 = 0x000ffa1f;
+				reg->rf4 = 0x000ffa1f;
 				break;
 			case 153:
-				rf4 = 0x000ffa27;
+				reg->rf4 = 0x000ffa27;
 				break;
 			case 157:
-				rf4 = 0x000ffa07;
+				reg->rf4 = 0x000ffa07;
 				break;
 			case 161:
-				rf4 = 0x000ffa0f;
+				reg->rf4 = 0x000ffa0f;
 				break;
 			case 165:
-				rf4 = 0x000ffa17;
+				reg->rf4 = 0x000ffa17;
 				break;
 		}
 	} else {
@@ -500,81 +499,93 @@ static void rt61pci_config_channel(struct rt2x00_dev *rt2x00dev,
 			case 112:
 			case 116:
 			case 120:
-				rf4 = 0x000c0a03;
+				reg->rf4 = 0x000c0a03;
 				break;
 			case 44:
 			case 64:
 			case 124:
 			case 149:
-				rf4 = 0x000c0a1b;
+				reg->rf4 = 0x000c0a1b;
 				break;
 			case 48:
 			case 128:
 			case 153:
-				rf4 = 0x000c0a0b;
+				reg->rf4 = 0x000c0a0b;
 				break;
 			case 52:
 			case 132:
-				rf4 = 0x000c0a23;
+				reg->rf4 = 0x000c0a23;
 				break;
 			case 56:
 			case 136:
-				rf4 = 0x000c0a13;
+				reg->rf4 = 0x000c0a13;
 				break;
 			case 157:
 			case 161:
 			case 165:
-				rf4 = 0x000c0a17;
+				reg->rf4 = 0x000c0a17;
 				break;
 		}
 	}
+}
+
+static void rt61pci_config_channel(struct rt2x00_dev *rt2x00dev,
+	const int value, const int channel, const int txpower)
+{
+	struct rf_reg reg;
+	u8 bbp = 0;
+
+	/*
+	 * Fill rf_reg structure.
+	 */
+	rt61pci_get_rf_vals(rt2x00dev, value, channel, &reg);
 
 	/*
 	 * Set TXpower.
 	 */
-	rt2x00_set_field32(&rf3, RF3_TXPOWER, TXPOWER_TO_DEV(txpower));
+	rt2x00_set_field32(&reg.rf3, RF3_TXPOWER, TXPOWER_TO_DEV(txpower));
 
 	/*
 	 * Set Frequency offset.
 	 */
-	rt2x00_set_field32(&rf4, RF4_FREQ_OFFSET, rt2x00dev->freq_offset);
+	rt2x00_set_field32(&reg.rf4, RF4_FREQ_OFFSET, rt2x00dev->freq_offset);
 
-	rt61pci_rf_write(rt2x00dev, rf1);
-	rt61pci_rf_write(rt2x00dev, rf2);
-	rt61pci_rf_write(rt2x00dev, rf3 & ~0x00000004);
-	rt61pci_rf_write(rt2x00dev, rf4);
+	rt61pci_rf_write(rt2x00dev, reg.rf1);
+	rt61pci_rf_write(rt2x00dev, reg.rf2);
+	rt61pci_rf_write(rt2x00dev, reg.rf3 & ~0x00000004);
+	rt61pci_rf_write(rt2x00dev, reg.rf4);
 
 	udelay(200);
 
-	rt61pci_rf_write(rt2x00dev, rf1);
-	rt61pci_rf_write(rt2x00dev, rf2);
-	rt61pci_rf_write(rt2x00dev, rf3 | 0x00000004);
-	rt61pci_rf_write(rt2x00dev, rf4);
+	rt61pci_rf_write(rt2x00dev, reg.rf1);
+	rt61pci_rf_write(rt2x00dev, reg.rf2);
+	rt61pci_rf_write(rt2x00dev, reg.rf3 | 0x00000004);
+	rt61pci_rf_write(rt2x00dev, reg.rf4);
 
 	udelay(200);
 
-	rt61pci_rf_write(rt2x00dev, rf1);
-	rt61pci_rf_write(rt2x00dev, rf2);
-	rt61pci_rf_write(rt2x00dev, rf3 & ~0x00000004);
-	rt61pci_rf_write(rt2x00dev, rf4);
+	rt61pci_rf_write(rt2x00dev, reg.rf1);
+	rt61pci_rf_write(rt2x00dev, reg.rf2);
+	rt61pci_rf_write(rt2x00dev, reg.rf3 & ~0x00000004);
+	rt61pci_rf_write(rt2x00dev, reg.rf4);
 
-	rt61pci_bbp_read(rt2x00dev, 3, &reg);
+	rt61pci_bbp_read(rt2x00dev, 3, &bbp);
 	if (rt2x00_rf(&rt2x00dev->chip, RF5225) ||
 	    rt2x00_rf(&rt2x00dev->chip, RF2527))
-		reg &= ~0x01;
+		bbp &= ~0x01;
 	else
-		reg |= 0x01;
-	rt61pci_bbp_write(rt2x00dev, 3, reg);
+		bbp |= 0x01;
+	rt61pci_bbp_write(rt2x00dev, 3, bbp);
 
 	msleep(1);
 
 	/*
 	 * Update rf fields
 	 */
-	rt2x00dev->rf1 = rf1;
-	rt2x00dev->rf2 = rf2;
-	rt2x00dev->rf3 = rf3;
-	rt2x00dev->rf4 = rf4;
+	rt2x00dev->rf1 = reg.rf1;
+	rt2x00dev->rf2 = reg.rf2;
+	rt2x00dev->rf3 = reg.rf3;
+	rt2x00dev->rf4 = reg.rf4;
 	rt2x00dev->tx_power = txpower;
 }
 
diff --git a/drivers/net/wireless/rt73usb.c b/drivers/net/wireless/rt73usb.c
index bc9b56c..03a842b 100644
--- a/drivers/net/wireless/rt73usb.c
+++ b/drivers/net/wireless/rt73usb.c
@@ -323,134 +323,164 @@ static void rt73usb_config_type(struct rt2x00_dev *rt2x00dev,
 	rt73usb_register_write(rt2x00dev, TXRX_CSR9, reg);
 }
 
-static void rt73usb_config_channel(struct rt2x00_dev *rt2x00dev,
-	const int value, const int channel, const int txpower)
+static const struct {
+	unsigned int chip;
+	u32 val[3];
+} rf_vals[] = {
+	{ RF5226,	{ 0x00002c0c, 0x00068255 } },
+	{ RF2528,	{ 0x00002c0c, 0x00068255 } },
+	{ RF5225,	{ 0x00002ccc, 0x00000000 } },
+	{ RF2527,	{ 0x00002ccc, 0x00068455 } },
+};
+
+static void rt73usb_get_rf_vals(struct rt2x00_dev *rt2x00dev,
+	const int value, const int channel, struct rf_reg *reg)
 {
-	u8 reg = 0;
-	u32 rf1 = rt2x00dev->rf1;
-	u32 rf2 = value;
-	u32 rf3 = rt2x00dev->rf3;
-	u32 rf4 = 0;
+	unsigned int i;
+
+	reg->rf1 = 0;
+	reg->rf2 = value;
+	reg->rf3 = 0;
+	reg->rf4 = 0;
+
+	for (i = 0; i < ARRAY_SIZE(rf_vals); i++) {
+		if (rt2x00_rf(&rt2x00dev->chip, rf_vals[i].chip)) {
+			reg->rf1 = rf_vals[i].val[0];
+			reg->rf3 = rf_vals[i].val[1];
+		}
+	}
 
 	if (rt2x00_rf(&rt2x00dev->chip, RF5225) ||
 	    rt2x00_rf(&rt2x00dev->chip, RF2527))
-		rf2 |= 0x00004000;
+		reg->rf2 |= 0x00004000;
 
 	if (rt2x00_rf(&rt2x00dev->chip, RF5225)) {
 		if (channel <= 14)
-			rf3 = 0x00068455;
+			reg->rf3 = 0x00068455;
 		else if (channel >= 36 && channel <= 48)
-			rf3 = 0x0009be55;
+			reg->rf3 = 0x0009be55;
 		else if (channel >= 52 && channel <= 64)
-			rf3 = 0x0009ae55;
+			reg->rf3 = 0x0009ae55;
 		else if (channel >= 100 && channel <= 112)
-			rf3 = 0x000bae55;
+			reg->rf3 = 0x000bae55;
 		else
-			rf3 = 0x000bbe55;
+			reg->rf3 = 0x000bbe55;
 	}
 
 	if (channel < 14) {
 		if (channel & 0x01)
-			rf4 = 0x000fea0b;
+			reg->rf4 = 0x000fea0b;
 		else
-			rf4 = 0x000fea1f;
+			reg->rf4 = 0x000fea1f;
 	} else if (channel == 14) {
-		rf4 = 0x000fea13;
+		reg->rf4 = 0x000fea13;
 	} else {
 		switch (channel) {
 			case 36:
 			case 56:
 			case 116:
 			case 136:
-				rf4 = 0x000fea23;
+				reg->rf4 = 0x000fea23;
 				break;
 			case 40:
 			case 60:
 			case 100:
 			case 120:
 			case 140:
-				rf4 = 0x000fea03;
+				reg->rf4 = 0x000fea03;
 				break;
 			case 44:
 			case 64:
 			case 104:
 			case 124:
-				rf4 = 0x000fea0b;
+				reg->rf4 = 0x000fea0b;
 				break;
 			case 48:
 			case 108:
 			case 128:
-				rf4 = 0x000fea13;
+				reg->rf4 = 0x000fea13;
 				break;
 			case 52:
 			case 112:
 			case 132:
-				rf4 = 0x000fea1b;
+				reg->rf4 = 0x000fea1b;
 				break;
 			case 149:
-				rf4 = 0x000fea1f;
+				reg->rf4 = 0x000fea1f;
 				break;
 			case 153:
-				rf4 = 0x000fea27;
+				reg->rf4 = 0x000fea27;
 				break;
 			case 157:
-				rf4 = 0x000fea07;
+				reg->rf4 = 0x000fea07;
 				break;
 			case 161:
-				rf4 = 0x000fea0f;
+				reg->rf4 = 0x000fea0f;
 				break;
 			case 165:
-				rf4 = 0x000fea17;
+				reg->rf4 = 0x000fea17;
 				break;
 		}
 	}
 
 	if (rt2x00_rf(&rt2x00dev->chip, RF2527) ||
 	    rt2x00_rf(&rt2x00dev->chip, RF5225))
-		rf4 |= 0x00010000;
+		reg->rf4 |= 0x00010000;
+}
+
+static void rt73usb_config_channel(struct rt2x00_dev *rt2x00dev,
+	const int value, const int channel, const int txpower)
+{
+	struct rf_reg reg;
+	u8 bbp = 0;
+
+	/*
+	 * Fill rf_reg structure.
+	 */
+	rt73usb_get_rf_vals(rt2x00dev, value, channel, &reg);
 
 	/*
 	 * Set TXpower.
 	 */
-	rt2x00_set_field32(&rf3, RF3_TXPOWER, TXPOWER_TO_DEV(txpower));
+	rt2x00_set_field32(&reg.rf3, RF3_TXPOWER, TXPOWER_TO_DEV(txpower));
 
 	/*
 	 * Set Frequency offset.
 	 */
-	rt2x00_set_field32(&rf4, RF4_FREQ_OFFSET, rt2x00dev->freq_offset);
+	rt2x00_set_field32(&reg.rf4, RF4_FREQ_OFFSET, rt2x00dev->freq_offset);
 
-	rt73usb_bbp_read(rt2x00dev, 3, &reg);
+	rt73usb_bbp_read(rt2x00dev, 3, &bbp);
 	if (rt2x00_rf(&rt2x00dev->chip, RF5225) ||
 	    rt2x00_rf(&rt2x00dev->chip, RF2527))
-		reg &= ~0x01;
+		bbp &= ~0x01;
 	else
-		reg |= 0x01;
-	rt73usb_bbp_write(rt2x00dev, 3, reg);
+		bbp |= 0x01;
+	rt73usb_bbp_write(rt2x00dev, 3, bbp);
 
-	rt73usb_rf_write(rt2x00dev, rf1);
-	rt73usb_rf_write(rt2x00dev, rf2);
-	rt73usb_rf_write(rt2x00dev, rf3 & ~0x00000004);
-	rt73usb_rf_write(rt2x00dev, rf4);
+	rt73usb_rf_write(rt2x00dev, reg.rf1);
+	rt73usb_rf_write(rt2x00dev, reg.rf2);
+	rt73usb_rf_write(rt2x00dev, reg.rf3 & ~0x00000004);
+	rt73usb_rf_write(rt2x00dev, reg.rf4);
 
-	rt73usb_rf_write(rt2x00dev, rf1);
-	rt73usb_rf_write(rt2x00dev, rf2);
-	rt73usb_rf_write(rt2x00dev, rf3 | 0x00000004);
-	rt73usb_rf_write(rt2x00dev, rf4);
+	rt73usb_rf_write(rt2x00dev, reg.rf1);
+	rt73usb_rf_write(rt2x00dev, reg.rf2);
+	rt73usb_rf_write(rt2x00dev, reg.rf3 | 0x00000004);
+	rt73usb_rf_write(rt2x00dev, reg.rf4);
 
-	rt73usb_rf_write(rt2x00dev, rf1);
-	rt73usb_rf_write(rt2x00dev, rf2);
-	rt73usb_rf_write(rt2x00dev, rf3 & ~0x00000004);
-	rt73usb_rf_write(rt2x00dev, rf4);
+	rt73usb_rf_write(rt2x00dev, reg.rf1);
+	rt73usb_rf_write(rt2x00dev, reg.rf2);
+	rt73usb_rf_write(rt2x00dev, reg.rf3 & ~0x00000004);
+	rt73usb_rf_write(rt2x00dev, reg.rf4);
 
 	msleep(1);
 
 	/*
 	 * Update rf fields
 	 */
-	rt2x00dev->rf1 = rf1;
-	rt2x00dev->rf2 = rf2;
-	rt2x00dev->rf3 = rf3;
-	rt2x00dev->rf4 = rf4;
+	rt2x00dev->rf1 = reg.rf1;
+	rt2x00dev->rf2 = reg.rf2;
+	rt2x00dev->rf3 = reg.rf3;
+	rt2x00dev->rf4 = reg.rf4;
 	rt2x00dev->tx_power = txpower;
 }
 
@@ -1552,16 +1582,6 @@ static int rt73usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	return 0;
 }
 
-static const struct {
-	unsigned int chip;
-	u32 val[3];
-} rf_vals[] = {
-	{ RF5226,	{ 0x00002c0c, 0x00068255 } },
-	{ RF2528,	{ 0x00002c0c, 0x00068255 } },
-	{ RF5225,	{ 0x00002ccc, 0x00000000 } },
-	{ RF2527,	{ 0x00002ccc, 0x00068455 } },
-};
-
 /*
  * RF value list for RF5226, RF2528, RF5225 & RF2527
  * Supports: 2.4 GHz
@@ -1609,16 +1629,6 @@ static void rt73usb_init_hw_mode(struct rt2x00_dev *rt2x00dev)
 		rt2x00_eeprom_addr(rt2x00dev, EEPROM_MAC_ADDR_0));
 
 	/*
-	 * Set device specific, but channel independent RF values.
-	 */
-	for (i = 0; i < ARRAY_SIZE(rf_vals); i++) {
-		if (rt2x00_rf(&rt2x00dev->chip, rf_vals[i].chip)) {
-			rt2x00dev->rf1 = rf_vals[i].val[0];
-			rt2x00dev->rf3 = rf_vals[i].val[1];
-		}
-	}
-
-	/*
 	 * Convert tx_power array in eeprom.
 	 */
 	txpower = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_G_START);
-- 
1.5.2.4

