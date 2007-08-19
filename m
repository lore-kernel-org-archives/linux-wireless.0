Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:22582 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404AbXHSSao convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 14:30:44 -0400
Received: by ug-out-1314.google.com with SMTP id j3so446922ugf
        for <linux-wireless@vger.kernel.org>; Sun, 19 Aug 2007 11:30:43 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 11/30] rt2x00: Rework RF register handling
Date: Sun, 19 Aug 2007 20:25:15 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200708192018.30624.IvDoorn@gmail.com>
In-Reply-To: <200708192018.30624.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708192025.15177.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From bd6c96f98df0e85bf9985bee8df71750e3ec2f20 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 18 Aug 2007 13:01:58 +0200
Subject: [PATCH 11/30] rt2x00: Rework RF register handling

Move RF registers inside static constant arrays.
This has several benefits:
	- We can easily inform rt2x00lib which channels we support
	- We don't have to use lots of if/switch statements
	- Easy comparison against legacy driver values
	- Bug fix for rt73usb: Some chips have 21bit RF values.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2400pci.c |   44 +++---
 drivers/net/wireless/rt2500pci.c |  256 ++++++++++++++++++-----------
 drivers/net/wireless/rt2500usb.c |  266 ++++++++++++++++++-------------
 drivers/net/wireless/rt2x00.h    |    9 +-
 drivers/net/wireless/rt2x00dev.c |   34 ++---
 drivers/net/wireless/rt61pci.c   |  332 ++++++++++++++------------------------
 drivers/net/wireless/rt73usb.c   |  281 +++++++++++++++++---------------
 7 files changed, 619 insertions(+), 603 deletions(-)

diff --git a/drivers/net/wireless/rt2400pci.c b/drivers/net/wireless/rt2400pci.c
index 8ebfae8..7bd975d 100644
--- a/drivers/net/wireless/rt2400pci.c
+++ b/drivers/net/wireless/rt2400pci.c
@@ -419,28 +419,15 @@ static void rt2400pci_config_phymode(struct rt2x00_dev *rt2x00dev,
 	rt2400pci_config_rate(rt2x00dev, rate->val2);
 }
 
-static void rt2400pci_get_rf_vals(struct rt2x00_dev *rt2x00dev,
-				  const int value, const int channel,
-				  struct rf_reg *reg)
-{
-	reg->rf1 = 0x00022058;
-	reg->rf2 = value;
-	if (rt2x00_rf(&rt2x00dev->chip, RF2420))
-		reg->rf3 = 0x00000111;
-	else
-		reg->rf3 = 0x00000101;
-	reg->rf4 = 0;
-}
-
 static void rt2400pci_config_channel(struct rt2x00_dev *rt2x00dev,
-				     const int value, const int channel)
+				     const int index, const int channel)
 {
-	struct rf_reg reg;
+	struct rf_channel reg;
 
 	/*
 	 * Fill rf_reg structure.
 	 */
-	rt2400pci_get_rf_vals(rt2x00dev, value, channel, &reg);
+	memcpy(&reg, &rt2x00dev->spec.channels[index], sizeof(reg));
 
 	/*
 	 * Switch on tuning bits.
@@ -1434,10 +1421,21 @@ static int rt2400pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
  * RF value list for RF2420 & RF2421
  * Supports: 2.4 GHz
  */
-static const u32 rf_vals_bg[] = {
-	0x000c1fda, 0x000c1fee, 0x000c2002, 0x000c2016, 0x000c202a,
-	0x000c203e, 0x000c2052, 0x000c2066, 0x000c207a, 0x000c208e,
-	0x000c20a2, 0x000c20b6, 0x000c20ca, 0x000c20fa
+static const struct rf_channel rf_vals_bg[] = {
+	{ 1,  0x00022058, 0x000c1fda, 0x00000101, 0 },
+	{ 2,  0x00022058, 0x000c1fee, 0x00000101, 0 },
+	{ 3,  0x00022058, 0x000c2002, 0x00000101, 0 },
+	{ 4,  0x00022058, 0x000c2016, 0x00000101, 0 },
+	{ 5,  0x00022058, 0x000c202a, 0x00000101, 0 },
+	{ 6,  0x00022058, 0x000c203e, 0x00000101, 0 },
+	{ 7,  0x00022058, 0x000c2052, 0x00000101, 0 },
+	{ 8,  0x00022058, 0x000c2066, 0x00000101, 0 },
+	{ 9,  0x00022058, 0x000c207a, 0x00000101, 0 },
+	{ 10, 0x00022058, 0x000c208e, 0x00000101, 0 },
+	{ 11, 0x00022058, 0x000c20a2, 0x00000101, 0 },
+	{ 12, 0x00022058, 0x000c20b6, 0x00000101, 0 },
+	{ 13, 0x00022058, 0x000c20ca, 0x00000101, 0 },
+	{ 14, 0x00022058, 0x000c20fa, 0x00000101, 0 },
 };
 
 static void rt2400pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
@@ -1479,12 +1477,12 @@ static void rt2400pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	 */
 	spec->num_modes = 1;
 	spec->num_rates = 4;
-	spec->num_channels = 14;
 	spec->tx_power_a = NULL;
 	spec->tx_power_bg = txpower;
 	spec->tx_power_default = DEFAULT_TXPOWER;
-	spec->chan_val_a = NULL;
-	spec->chan_val_bg = rf_vals_bg;
+
+	spec->num_channels = ARRAY_SIZE(rf_vals_bg);
+	spec->channels = rf_vals_bg;
 }
 
 static int rt2400pci_probe_hw(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/rt2500pci.c b/drivers/net/wireless/rt2500pci.c
index a5bfb00..d6b88f6 100644
--- a/drivers/net/wireless/rt2500pci.c
+++ b/drivers/net/wireless/rt2500pci.c
@@ -432,75 +432,17 @@ static void rt2500pci_config_phymode(struct rt2x00_dev *rt2x00dev,
 	rt2500pci_config_rate(rt2x00dev, rate->val2);
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
-};
-
-static void rt2500pci_get_rf_vals(struct rt2x00_dev *rt2x00dev,
-				  const int value, const int channel,
-				  struct rf_reg *reg)
-{
-	unsigned int i;
-
-	reg->rf1 = 0;
-	reg->rf2 = value;
-	reg->rf3 = 0;
-	reg->rf4 = 0;
-
-	if (rt2x00_rf(&rt2x00dev->chip, RF5222)) {
-		reg->rf3 = 0x00000101;
-		if (channel < 14) {
-			reg->rf1 = 0x00022020;
-			reg->rf4 = 0x00000a0b;
-		} else if (channel == 14) {
-			reg->rf1 = 0x00022010;
-			reg->rf4 = 0x00000a1b;
-		} else if (channel < 64) {
-			reg->rf1 = 0x00022010;
-			reg->rf4 = 0x00000a1f;
-		} else if (channel < 140) {
-			reg->rf1 = 0x00022010;
-			reg->rf4 = 0x00000a0f;
-		} else if (channel < 161) {
-			reg->rf1 = 0x00022020;
-			reg->rf4 = 0x00000a07;
-		}
-	} else {
-		if (rt2x00_rf(&rt2x00dev->chip, RF2525) ||
-		    rt2x00_rf(&rt2x00dev->chip, RF2525E))
-			reg->rf2 |= 0x00080000;
-
-		for (i = 0; i < ARRAY_SIZE(rf_vals); i++) {
-			if (rt2x00_rf(&rt2x00dev->chip, rf_vals[i].chip)) {
-				reg->rf1 = rf_vals[i].val[0];
-				reg->rf3 = rf_vals[i].val[1];
-				reg->rf4 = rf_vals[i].val[2];
-			}
-		}
-
-		if (rt2x00_rf(&rt2x00dev->chip, RF2525E) && channel == 14)
-			reg->rf4 |= 0x00000010;
-	}
-}
-
 static void rt2500pci_config_channel(struct rt2x00_dev *rt2x00dev,
-				     const int value, const int channel,
+				     const int index, const int channel,
 				     const int txpower)
 {
-	struct rf_reg reg;
+	struct rf_channel reg;
 	u8 r70;
 
 	/*
 	 * Fill rf_reg structure.
 	 */
-	rt2500pci_get_rf_vals(rt2x00dev, value, channel, &reg);
+	memcpy(&reg, &rt2x00dev->spec.channels[index], sizeof(reg));
 
 	/*
 	 * Set TXpower.
@@ -1647,42 +1589,155 @@ static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
  * RF value list for RF2522
  * Supports: 2.4 GHz
  */
-static const u32 rf_vals_bg_2522[] = {
-	0x000c1fda, 0x000c1fee, 0x000c2002, 0x000c2016, 0x000c202a,
-	0x000c203e, 0x000c2052, 0x000c2066, 0x000c207a, 0x000c208e,
-	0x000c20a2, 0x000c20b6, 0x000c20ca, 0x000c20fa
+static const struct rf_channel rf_vals_bg_2522[] = {
+	{ 1,  0x00002050, 0x000c1fda, 0x00000101, 0 },
+	{ 2,  0x00002050, 0x000c1fee, 0x00000101, 0 },
+	{ 3,  0x00002050, 0x000c2002, 0x00000101, 0 },
+	{ 4,  0x00002050, 0x000c2016, 0x00000101, 0 },
+	{ 5,  0x00002050, 0x000c202a, 0x00000101, 0 },
+	{ 6,  0x00002050, 0x000c203e, 0x00000101, 0 },
+	{ 7,  0x00002050, 0x000c2052, 0x00000101, 0 },
+	{ 8,  0x00002050, 0x000c2066, 0x00000101, 0 },
+	{ 9,  0x00002050, 0x000c207a, 0x00000101, 0 },
+	{ 10, 0x00002050, 0x000c208e, 0x00000101, 0 },
+	{ 11, 0x00002050, 0x000c20a2, 0x00000101, 0 },
+	{ 12, 0x00002050, 0x000c20b6, 0x00000101, 0 },
+	{ 13, 0x00002050, 0x000c20ca, 0x00000101, 0 },
+	{ 14, 0x00002050, 0x000c20fa, 0x00000101, 0 },
 };
 
 /*
- * RF value list for RF2523, RF2524 & RF2525
+ * RF value list for RF2523
  * Supports: 2.4 GHz
  */
-static const u32 rf_vals_bg_252x[] = {
-	0x00000c9e, 0x00000ca2, 0x00000ca6, 0x00000caa, 0x00000cae,
-	0x00000cb2, 0x00000cb6, 0x00000cba, 0x00000cbe, 0x00000d02,
-	0x00000d06, 0x00000d0a, 0x00000d0e, 0x00000d1a
+static const struct rf_channel rf_vals_bg_2523[] = {
+	{ 1,  0x00022010, 0x00000c9e, 0x000e0111, 0x00000a1b },
+	{ 2,  0x00022010, 0x00000ca2, 0x000e0111, 0x00000a1b },
+	{ 3,  0x00022010, 0x00000ca6, 0x000e0111, 0x00000a1b },
+	{ 4,  0x00022010, 0x00000caa, 0x000e0111, 0x00000a1b },
+	{ 5,  0x00022010, 0x00000cae, 0x000e0111, 0x00000a1b },
+	{ 6,  0x00022010, 0x00000cb2, 0x000e0111, 0x00000a1b },
+	{ 7,  0x00022010, 0x00000cb6, 0x000e0111, 0x00000a1b },
+	{ 8,  0x00022010, 0x00000cba, 0x000e0111, 0x00000a1b },
+	{ 9,  0x00022010, 0x00000cbe, 0x000e0111, 0x00000a1b },
+	{ 10, 0x00022010, 0x00000d02, 0x000e0111, 0x00000a1b },
+	{ 11, 0x00022010, 0x00000d06, 0x000e0111, 0x00000a1b },
+	{ 12, 0x00022010, 0x00000d0a, 0x000e0111, 0x00000a1b },
+	{ 13, 0x00022010, 0x00000d0e, 0x000e0111, 0x00000a1b },
+	{ 14, 0x00022010, 0x00000d1a, 0x000e0111, 0x00000a03 },
 };
 
 /*
- * RF value list for RF2525E & RF5222
+ * RF value list for RF2524
  * Supports: 2.4 GHz
  */
-static const u32 rf_vals_bg_5x[] = {
-	0x00001136, 0x0000113a, 0x0000113e, 0x00001182, 0x00001186,
-	0x0000118a, 0x0000118e, 0x00001192, 0x00001196, 0x0000119a,
-	0x0000119e, 0x000011a2, 0x000011a6, 0x000011ae
+static const struct rf_channel rf_vals_bg_2524[] = {
+	{ 1,  0x00032020, 0x00000c9e, 0x00000101, 0x00000a1b },
+	{ 2,  0x00032020, 0x00000ca2, 0x00000101, 0x00000a1b },
+	{ 3,  0x00032020, 0x00000ca6, 0x00000101, 0x00000a1b },
+	{ 4,  0x00032020, 0x00000caa, 0x00000101, 0x00000a1b },
+	{ 5,  0x00032020, 0x00000cae, 0x00000101, 0x00000a1b },
+	{ 6,  0x00032020, 0x00000cb2, 0x00000101, 0x00000a1b },
+	{ 7,  0x00032020, 0x00000cb6, 0x00000101, 0x00000a1b },
+	{ 8,  0x00032020, 0x00000cba, 0x00000101, 0x00000a1b },
+	{ 9,  0x00032020, 0x00000cbe, 0x00000101, 0x00000a1b },
+	{ 10, 0x00032020, 0x00000d02, 0x00000101, 0x00000a1b },
+	{ 11, 0x00032020, 0x00000d06, 0x00000101, 0x00000a1b },
+	{ 12, 0x00032020, 0x00000d0a, 0x00000101, 0x00000a1b },
+	{ 13, 0x00032020, 0x00000d0e, 0x00000101, 0x00000a1b },
+	{ 14, 0x00032020, 0x00000d1a, 0x00000101, 0x00000a03 },
 };
 
 /*
- * RF value list for RF5222 (supplement to rf_vals_bg_5x)
- * Supports: 5.2 GHz
+ * RF value list for RF2525
+ * Supports: 2.4 GHz
+ */
+static const struct rf_channel rf_vals_bg_2525[] = {
+	{ 1,  0x00022020, 0x00080c9e, 0x00060111, 0x00000a1b },
+	{ 2,  0x00022020, 0x00080ca2, 0x00060111, 0x00000a1b },
+	{ 3,  0x00022020, 0x00080ca6, 0x00060111, 0x00000a1b },
+	{ 4,  0x00022020, 0x00080caa, 0x00060111, 0x00000a1b },
+	{ 5,  0x00022020, 0x00080cae, 0x00060111, 0x00000a1b },
+	{ 6,  0x00022020, 0x00080cb2, 0x00060111, 0x00000a1b },
+	{ 7,  0x00022020, 0x00080cb6, 0x00060111, 0x00000a1b },
+	{ 8,  0x00022020, 0x00080cba, 0x00060111, 0x00000a1b },
+	{ 9,  0x00022020, 0x00080cbe, 0x00060111, 0x00000a1b },
+	{ 10, 0x00022020, 0x00080d02, 0x00060111, 0x00000a1b },
+	{ 11, 0x00022020, 0x00080d06, 0x00060111, 0x00000a1b },
+	{ 12, 0x00022020, 0x00080d0a, 0x00060111, 0x00000a1b },
+	{ 13, 0x00022020, 0x00080d0e, 0x00060111, 0x00000a1b },
+	{ 14, 0x00022020, 0x00080d1a, 0x00060111, 0x00000a03 },
+};
+
+/*
+ * RF value list for RF2525e
+ * Supports: 2.4 GHz
  */
-static const u32 rf_vals_a_5x[] = {
-	0x00018896, 0x0001889a, 0x0001889e, 0x000188a2, 0x000188a6,
-	0x000188aa, 0x000188ae, 0x000188b2, 0x00008802, 0x00008806,
-	0x0000880a, 0x0000880e, 0x00008812, 0x00008816, 0x0000881a,
-	0x0000881e, 0x00008822, 0x00008826, 0x0000882a, 0x000090a6,
-	0x000090ae, 0x000090b6, 0x000090be
+static const struct rf_channel rf_vals_bg_2525e[] = {
+	{ 1,  0x00022020, 0x00081136, 0x00060111, 0x00000a0b },
+	{ 2,  0x00022020, 0x0008113a, 0x00060111, 0x00000a0b },
+	{ 3,  0x00022020, 0x0008113e, 0x00060111, 0x00000a0b },
+	{ 4,  0x00022020, 0x00081182, 0x00060111, 0x00000a0b },
+	{ 5,  0x00022020, 0x00081186, 0x00060111, 0x00000a0b },
+	{ 6,  0x00022020, 0x0008118a, 0x00060111, 0x00000a0b },
+	{ 7,  0x00022020, 0x0008118e, 0x00060111, 0x00000a0b },
+	{ 8,  0x00022020, 0x00081192, 0x00060111, 0x00000a0b },
+	{ 9,  0x00022020, 0x00081196, 0x00060111, 0x00000a0b },
+	{ 10, 0x00022020, 0x0008119a, 0x00060111, 0x00000a0b },
+	{ 11, 0x00022020, 0x0008119e, 0x00060111, 0x00000a0b },
+	{ 12, 0x00022020, 0x000811a2, 0x00060111, 0x00000a0b },
+	{ 13, 0x00022020, 0x000811a6, 0x00060111, 0x00000a0b },
+	{ 14, 0x00022020, 0x000811ae, 0x00060111, 0x00000a1b },
+};
+
+/*
+ * RF value list for RF5222
+ * Supports: 2.4 GHz & 5.2 GHz
+ */
+static const struct rf_channel rf_vals_5222[] = {
+	{ 1,  0x00022020, 0x00001136, 0x00000101, 0x00000a0b },
+	{ 2,  0x00022020, 0x0000113a, 0x00000101, 0x00000a0b },
+	{ 3,  0x00022020, 0x0000113e, 0x00000101, 0x00000a0b },
+	{ 4,  0x00022020, 0x00001182, 0x00000101, 0x00000a0b },
+	{ 5,  0x00022020, 0x00001186, 0x00000101, 0x00000a0b },
+	{ 6,  0x00022020, 0x0000118a, 0x00000101, 0x00000a0b },
+	{ 7,  0x00022020, 0x0000118e, 0x00000101, 0x00000a0b },
+	{ 8,  0x00022020, 0x00001192, 0x00000101, 0x00000a0b },
+	{ 9,  0x00022020, 0x00001196, 0x00000101, 0x00000a0b },
+	{ 10, 0x00022020, 0x0000119a, 0x00000101, 0x00000a0b },
+	{ 11, 0x00022020, 0x0000119e, 0x00000101, 0x00000a0b },
+	{ 12, 0x00022020, 0x000011a2, 0x00000101, 0x00000a0b },
+	{ 13, 0x00022020, 0x000011a6, 0x00000101, 0x00000a0b },
+	{ 14, 0x00022020, 0x000011ae, 0x00000101, 0x00000a1b },
+
+	/* 802.11 UNI / HyperLan 2 */
+	{ 36, 0x00022010, 0x00018896, 0x00000101, 0x00000a1f },
+	{ 40, 0x00022010, 0x0001889a, 0x00000101, 0x00000a1f },
+	{ 44, 0x00022010, 0x0001889e, 0x00000101, 0x00000a1f },
+	{ 48, 0x00022010, 0x000188a2, 0x00000101, 0x00000a1f },
+	{ 52, 0x00022010, 0x000188a6, 0x00000101, 0x00000a1f },
+	{ 66, 0x00022010, 0x000188aa, 0x00000101, 0x00000a1f },
+	{ 60, 0x00022010, 0x000188ae, 0x00000101, 0x00000a1f },
+	{ 64, 0x00022010, 0x000188b2, 0x00000101, 0x00000a1f },
+
+	/* 802.11 HyperLan 2 */
+	{ 100, 0x00022010, 0x00008802, 0x00000101, 0x00000a0f },
+	{ 104, 0x00022010, 0x00008806, 0x00000101, 0x00000a0f },
+	{ 108, 0x00022010, 0x0000880a, 0x00000101, 0x00000a0f },
+	{ 112, 0x00022010, 0x0000880e, 0x00000101, 0x00000a0f },
+	{ 116, 0x00022010, 0x00008812, 0x00000101, 0x00000a0f },
+	{ 120, 0x00022010, 0x00008816, 0x00000101, 0x00000a0f },
+	{ 124, 0x00022010, 0x0000881a, 0x00000101, 0x00000a0f },
+	{ 128, 0x00022010, 0x0000881e, 0x00000101, 0x00000a0f },
+	{ 132, 0x00022010, 0x00008822, 0x00000101, 0x00000a0f },
+	{ 136, 0x00022010, 0x00008826, 0x00000101, 0x00000a0f },
+
+	/* 802.11 UNII */
+	{ 140, 0x00022010, 0x0000882a, 0x00000101, 0x00000a0f },
+	{ 149, 0x00022020, 0x000090a6, 0x00000101, 0x00000a07 },
+	{ 153, 0x00022020, 0x000090ae, 0x00000101, 0x00000a07 },
+	{ 157, 0x00022020, 0x000090b6, 0x00000101, 0x00000a07 },
+	{ 161, 0x00022020, 0x000090be, 0x00000101, 0x00000a07 },
 };
 
 static void rt2500pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
@@ -1724,26 +1779,29 @@ static void rt2500pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	 */
 	spec->num_modes = 2;
 	spec->num_rates = 12;
-	spec->num_channels = 14;
 	spec->tx_power_a = NULL;
 	spec->tx_power_bg = txpower;
 	spec->tx_power_default = DEFAULT_TXPOWER;
-	spec->chan_val_a = NULL;
-
-	if (rt2x00_rf(&rt2x00dev->chip, RF2522))
-		spec->chan_val_bg = rf_vals_bg_2522;
-	else if (rt2x00_rf(&rt2x00dev->chip, RF2523) ||
-		 rt2x00_rf(&rt2x00dev->chip, RF2524) ||
-		 rt2x00_rf(&rt2x00dev->chip, RF2525))
-		spec->chan_val_bg = rf_vals_bg_252x;
-	else if (rt2x00_rf(&rt2x00dev->chip, RF2525E) ||
-		 rt2x00_rf(&rt2x00dev->chip, RF5222))
-		spec->chan_val_bg = rf_vals_bg_5x;
-
-	if (rt2x00_rf(&rt2x00dev->chip, RF5222)) {
+
+	if (rt2x00_rf(&rt2x00dev->chip, RF2522)) {
+		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2522);
+		spec->channels = rf_vals_bg_2522;
+	} else if (rt2x00_rf(&rt2x00dev->chip, RF2523)) {
+		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2523);
+		spec->channels = rf_vals_bg_2523;
+	} else if (rt2x00_rf(&rt2x00dev->chip, RF2524)) {
+		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2524);
+		spec->channels = rf_vals_bg_2524;
+	} else if (rt2x00_rf(&rt2x00dev->chip, RF2525)) {
+		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2525);
+		spec->channels = rf_vals_bg_2525;
+	} else if (rt2x00_rf(&rt2x00dev->chip, RF2525E)) {
+		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2525e);
+		spec->channels = rf_vals_bg_2525e;
+	} else if (rt2x00_rf(&rt2x00dev->chip, RF5222)) {
+		spec->num_channels = ARRAY_SIZE(rf_vals_5222);
+		spec->channels = rf_vals_5222;
 		spec->num_modes = 3;
-		spec->num_channels += 23;
-		spec->chan_val_a = rf_vals_a_5x;
 	}
 }
 
diff --git a/drivers/net/wireless/rt2500usb.c b/drivers/net/wireless/rt2500usb.c
index e9f6747..25d0aec 100644
--- a/drivers/net/wireless/rt2500usb.c
+++ b/drivers/net/wireless/rt2500usb.c
@@ -429,84 +429,16 @@ static void rt2500usb_config_phymode(struct rt2x00_dev *rt2x00dev,
 	}
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
-};
-
-static void rt2500usb_get_rf_vals(struct rt2x00_dev *rt2x00dev,
-				  const int value, const int channel,
-				  struct rf_reg *reg)
-{
-	unsigned int i;
-
-	reg->rf1 = 0;
-	reg->rf2 = value;
-	reg->rf3 = 0;
-	reg->rf4 = 0;
-
-	if (rt2x00_rf(&rt2x00dev->chip, RF5222)) {
-		reg->rf3 = 0x00000101;
-		if (channel < 14) {
-			reg->rf1 = 0x00022020;
-			reg->rf4 = 0x00000a0b;
-		} else if (channel == 14) {
-			reg->rf1 = 0x00022010;
-			reg->rf4 = 0x00000a1b;
-		} else if (channel < 64) {
-			reg->rf1 = 0x00022010;
-			reg->rf4 = 0x00000a1f;
-		} else if (channel < 140) {
-			reg->rf1 = 0x00022010;
-			reg->rf4 = 0x00000a0f;
-		} else if (channel < 161) {
-			reg->rf1 = 0x00022020;
-			reg->rf4 = 0x00000a07;
-		}
-	} else {
-		if (rt2x00_rf(&rt2x00dev->chip, RF2525))
-			reg->rf2 |= 0x00080000;
-
-		for (i = 0; i < ARRAY_SIZE(rf_vals); i++) {
-			if (rt2x00_rf(&rt2x00dev->chip, rf_vals[i].chip)) {
-				reg->rf1 = rf_vals[i].val[0];
-				reg->rf3 = rf_vals[i].val[1];
-				reg->rf4 = rf_vals[i].val[2];
-			}
-		}
-
-		if ((rt2x00_rf(&rt2x00dev->chip, RF2523) ||
-		     rt2x00_rf(&rt2x00dev->chip, RF2524) ||
-		     rt2x00_rf(&rt2x00dev->chip, RF2525)) &&
-		     channel == 14)
-			reg->rf4 &= ~0x00000018;
-		else if (rt2x00_rf(&rt2x00dev->chip, RF2525E)) {
-			if (channel & 0x01)
-				reg->rf4 = 0x00000e1b;
-			else
-				reg->rf4 = 0x00000e07;
-			if (channel == 14)
-				reg->rf4 = 0x00000e23;
-		}
-	}
-}
-
 static void rt2500usb_config_channel(struct rt2x00_dev *rt2x00dev,
-				     const int value, const int channel,
+				     const int index, const int channel,
 				     const int txpower)
 {
-	struct rf_reg reg;
+	struct rf_channel reg;
 
 	/*
 	 * Fill rf_reg structure.
 	 */
-	rt2500usb_get_rf_vals(rt2x00dev, value, channel, &reg);
+	memcpy(&reg, &rt2x00dev->spec.channels[index], sizeof(reg));
 
 	/*
 	 * Set TXpower.
@@ -1374,45 +1306,155 @@ static int rt2500usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
  * RF value list for RF2522
  * Supports: 2.4 GHz
  */
-static const u32 rf_vals_bg_2522[] = {
-	0x000c1fda, 0x000c1fee, 0x000c2002, 0x000c2016, 0x000c202a,
-	0x000c203e, 0x000c2052, 0x000c2066, 0x000c207a, 0x000c208e,
-	0x000c20a2, 0x000c20b6, 0x000c20ca, 0x000c20fa
+static const struct rf_channel rf_vals_bg_2522[] = {
+	{ 1,  0x00002050, 0x000c1fda, 0x00000101, 0 },
+	{ 2,  0x00002050, 0x000c1fee, 0x00000101, 0 },
+	{ 3,  0x00002050, 0x000c2002, 0x00000101, 0 },
+	{ 4,  0x00002050, 0x000c2016, 0x00000101, 0 },
+	{ 5,  0x00002050, 0x000c202a, 0x00000101, 0 },
+	{ 6,  0x00002050, 0x000c203e, 0x00000101, 0 },
+	{ 7,  0x00002050, 0x000c2052, 0x00000101, 0 },
+	{ 8,  0x00002050, 0x000c2066, 0x00000101, 0 },
+	{ 9,  0x00002050, 0x000c207a, 0x00000101, 0 },
+	{ 10, 0x00002050, 0x000c208e, 0x00000101, 0 },
+	{ 11, 0x00002050, 0x000c20a2, 0x00000101, 0 },
+	{ 12, 0x00002050, 0x000c20b6, 0x00000101, 0 },
+	{ 13, 0x00002050, 0x000c20ca, 0x00000101, 0 },
+	{ 14, 0x00002050, 0x000c20fa, 0x00000101, 0 },
+};
+
+/*
+ * RF value list for RF2523
+ * Supports: 2.4 GHz
+ */
+static const struct rf_channel rf_vals_bg_2523[] = {
+	{ 1,  0x00022010, 0x00000c9e, 0x000e0111, 0x00000a1b },
+	{ 2,  0x00022010, 0x00000ca2, 0x000e0111, 0x00000a1b },
+	{ 3,  0x00022010, 0x00000ca6, 0x000e0111, 0x00000a1b },
+	{ 4,  0x00022010, 0x00000caa, 0x000e0111, 0x00000a1b },
+	{ 5,  0x00022010, 0x00000cae, 0x000e0111, 0x00000a1b },
+	{ 6,  0x00022010, 0x00000cb2, 0x000e0111, 0x00000a1b },
+	{ 7,  0x00022010, 0x00000cb6, 0x000e0111, 0x00000a1b },
+	{ 8,  0x00022010, 0x00000cba, 0x000e0111, 0x00000a1b },
+	{ 9,  0x00022010, 0x00000cbe, 0x000e0111, 0x00000a1b },
+	{ 10, 0x00022010, 0x00000d02, 0x000e0111, 0x00000a1b },
+	{ 11, 0x00022010, 0x00000d06, 0x000e0111, 0x00000a1b },
+	{ 12, 0x00022010, 0x00000d0a, 0x000e0111, 0x00000a1b },
+	{ 13, 0x00022010, 0x00000d0e, 0x000e0111, 0x00000a1b },
+	{ 14, 0x00022010, 0x00000d1a, 0x000e0111, 0x00000a03 },
 };
 
 /*
- * RF value list for RF2523, RF2524 & RF2525
+ * RF value list for RF2524
  * Supports: 2.4 GHz
  */
-static const u32 rf_vals_bg_252x[] = {
-	0x00000c9e, 0x00000ca2, 0x00000ca6, 0x00000caa, 0x00000cae,
-	0x00000cb2, 0x00000cb6, 0x00000cba, 0x00000cbe, 0x00000d02,
-	0x00000d06, 0x00000d0a, 0x00000d0e, 0x00000d1a
+static const struct rf_channel rf_vals_bg_2524[] = {
+	{ 1,  0x00032020, 0x00000c9e, 0x00000101, 0x00000a1b },
+	{ 2,  0x00032020, 0x00000ca2, 0x00000101, 0x00000a1b },
+	{ 3,  0x00032020, 0x00000ca6, 0x00000101, 0x00000a1b },
+	{ 4,  0x00032020, 0x00000caa, 0x00000101, 0x00000a1b },
+	{ 5,  0x00032020, 0x00000cae, 0x00000101, 0x00000a1b },
+	{ 6,  0x00032020, 0x00000cb2, 0x00000101, 0x00000a1b },
+	{ 7,  0x00032020, 0x00000cb6, 0x00000101, 0x00000a1b },
+	{ 8,  0x00032020, 0x00000cba, 0x00000101, 0x00000a1b },
+	{ 9,  0x00032020, 0x00000cbe, 0x00000101, 0x00000a1b },
+	{ 10, 0x00032020, 0x00000d02, 0x00000101, 0x00000a1b },
+	{ 11, 0x00032020, 0x00000d06, 0x00000101, 0x00000a1b },
+	{ 12, 0x00032020, 0x00000d0a, 0x00000101, 0x00000a1b },
+	{ 13, 0x00032020, 0x00000d0e, 0x00000101, 0x00000a1b },
+	{ 14, 0x00032020, 0x00000d1a, 0x00000101, 0x00000a03 },
 };
 
 /*
- * RF value list for RF2525E
+ * RF value list for RF2525
  * Supports: 2.4 GHz
  */
-static const u32 rf_vals_bg_2525e[] = {
-	0x0000089a, 0x0000089e, 0x0000089e, 0x000008a2, 0x000008a2,
-	0x000008a6, 0x000008a6, 0x000008aa, 0x000008aa, 0x000008ae,
-	0x000008ae, 0x000008b2, 0x000008b2, 0x000008b6
+static const struct rf_channel rf_vals_bg_2525[] = {
+	{ 1,  0x00022020, 0x00080c9e, 0x00060111, 0x00000a1b },
+	{ 2,  0x00022020, 0x00080ca2, 0x00060111, 0x00000a1b },
+	{ 3,  0x00022020, 0x00080ca6, 0x00060111, 0x00000a1b },
+	{ 4,  0x00022020, 0x00080caa, 0x00060111, 0x00000a1b },
+	{ 5,  0x00022020, 0x00080cae, 0x00060111, 0x00000a1b },
+	{ 6,  0x00022020, 0x00080cb2, 0x00060111, 0x00000a1b },
+	{ 7,  0x00022020, 0x00080cb6, 0x00060111, 0x00000a1b },
+	{ 8,  0x00022020, 0x00080cba, 0x00060111, 0x00000a1b },
+	{ 9,  0x00022020, 0x00080cbe, 0x00060111, 0x00000a1b },
+	{ 10, 0x00022020, 0x00080d02, 0x00060111, 0x00000a1b },
+	{ 11, 0x00022020, 0x00080d06, 0x00060111, 0x00000a1b },
+	{ 12, 0x00022020, 0x00080d0a, 0x00060111, 0x00000a1b },
+	{ 13, 0x00022020, 0x00080d0e, 0x00060111, 0x00000a1b },
+	{ 14, 0x00022020, 0x00080d1a, 0x00060111, 0x00000a03 },
+};
+
+/*
+ * RF value list for RF2525e
+ * Supports: 2.4 GHz
+ */
+static const struct rf_channel rf_vals_bg_2525e[] = {
+	{ 1,  0x00022010, 0x0000089a, 0x00060111, 0x00000e1b },
+	{ 2,  0x00022010, 0x0000089e, 0x00060111, 0x00000e07 },
+	{ 3,  0x00022010, 0x0000089e, 0x00060111, 0x00000e1b },
+	{ 4,  0x00022010, 0x000008a2, 0x00060111, 0x00000e07 },
+	{ 5,  0x00022010, 0x000008a2, 0x00060111, 0x00000e1b },
+	{ 6,  0x00022010, 0x000008a6, 0x00060111, 0x00000e07 },
+	{ 7,  0x00022010, 0x000008a6, 0x00060111, 0x00000e1b },
+	{ 8,  0x00022010, 0x000008aa, 0x00060111, 0x00000e07 },
+	{ 9,  0x00022010, 0x000008aa, 0x00060111, 0x00000e1b },
+	{ 10, 0x00022010, 0x000008ae, 0x00060111, 0x00000e07 },
+	{ 11, 0x00022010, 0x000008ae, 0x00060111, 0x00000e1b },
+	{ 12, 0x00022010, 0x000008b2, 0x00060111, 0x00000e07 },
+	{ 13, 0x00022010, 0x000008b2, 0x00060111, 0x00000e1b },
+	{ 14, 0x00022010, 0x000008b6, 0x00060111, 0x00000e23 },
 };
 
 /*
  * RF value list for RF5222
  * Supports: 2.4 GHz & 5.2 GHz
  */
-static const u32 rf_vals_abg_5222[] = {
-	0x00001136, 0x0000113a, 0x0000113e, 0x00001182, 0x00001186,
-	0x0000118a, 0x0000118e, 0x00001192, 0x00001196, 0x0000119a,
-	0x0000119e, 0x000011a2, 0x000011a6, 0x000011ae, 0x0001889a,
-	0x0001889a, 0x0001889e, 0x000188a2, 0x000188a6, 0x000188aa,
-	0x000188ae, 0x000188b2, 0x00008802, 0x00008806, 0x0000880a,
-	0x0000880e, 0x00008812, 0x00008816, 0x0000881a, 0x0000881e,
-	0x00008822, 0x00008826, 0x0000882a, 0x000090a6, 0x000090ae,
-	0x000090b6, 0x000090be
+static const struct rf_channel rf_vals_5222[] = {
+	{ 1,  0x00022020, 0x00001136, 0x00000101, 0x00000a0b },
+	{ 2,  0x00022020, 0x0000113a, 0x00000101, 0x00000a0b },
+	{ 3,  0x00022020, 0x0000113e, 0x00000101, 0x00000a0b },
+	{ 4,  0x00022020, 0x00001182, 0x00000101, 0x00000a0b },
+	{ 5,  0x00022020, 0x00001186, 0x00000101, 0x00000a0b },
+	{ 6,  0x00022020, 0x0000118a, 0x00000101, 0x00000a0b },
+	{ 7,  0x00022020, 0x0000118e, 0x00000101, 0x00000a0b },
+	{ 8,  0x00022020, 0x00001192, 0x00000101, 0x00000a0b },
+	{ 9,  0x00022020, 0x00001196, 0x00000101, 0x00000a0b },
+	{ 10, 0x00022020, 0x0000119a, 0x00000101, 0x00000a0b },
+	{ 11, 0x00022020, 0x0000119e, 0x00000101, 0x00000a0b },
+	{ 12, 0x00022020, 0x000011a2, 0x00000101, 0x00000a0b },
+	{ 13, 0x00022020, 0x000011a6, 0x00000101, 0x00000a0b },
+	{ 14, 0x00022020, 0x000011ae, 0x00000101, 0x00000a1b },
+
+	/* 802.11 UNI / HyperLan 2 */
+	{ 36, 0x00022010, 0x00018896, 0x00000101, 0x00000a1f },
+	{ 40, 0x00022010, 0x0001889a, 0x00000101, 0x00000a1f },
+	{ 44, 0x00022010, 0x0001889e, 0x00000101, 0x00000a1f },
+	{ 48, 0x00022010, 0x000188a2, 0x00000101, 0x00000a1f },
+	{ 52, 0x00022010, 0x000188a6, 0x00000101, 0x00000a1f },
+	{ 66, 0x00022010, 0x000188aa, 0x00000101, 0x00000a1f },
+	{ 60, 0x00022010, 0x000188ae, 0x00000101, 0x00000a1f },
+	{ 64, 0x00022010, 0x000188b2, 0x00000101, 0x00000a1f },
+
+	/* 802.11 HyperLan 2 */
+	{ 100, 0x00022010, 0x00008802, 0x00000101, 0x00000a0f },
+	{ 104, 0x00022010, 0x00008806, 0x00000101, 0x00000a0f },
+	{ 108, 0x00022010, 0x0000880a, 0x00000101, 0x00000a0f },
+	{ 112, 0x00022010, 0x0000880e, 0x00000101, 0x00000a0f },
+	{ 116, 0x00022010, 0x00008812, 0x00000101, 0x00000a0f },
+	{ 120, 0x00022010, 0x00008816, 0x00000101, 0x00000a0f },
+	{ 124, 0x00022010, 0x0000881a, 0x00000101, 0x00000a0f },
+	{ 128, 0x00022010, 0x0000881e, 0x00000101, 0x00000a0f },
+	{ 132, 0x00022010, 0x00008822, 0x00000101, 0x00000a0f },
+	{ 136, 0x00022010, 0x00008826, 0x00000101, 0x00000a0f },
+
+	/* 802.11 UNII */
+	{ 140, 0x00022010, 0x0000882a, 0x00000101, 0x00000a0f },
+	{ 149, 0x00022020, 0x000090a6, 0x00000101, 0x00000a07 },
+	{ 153, 0x00022020, 0x000090ae, 0x00000101, 0x00000a07 },
+	{ 157, 0x00022020, 0x000090b6, 0x00000101, 0x00000a07 },
+	{ 161, 0x00022020, 0x000090be, 0x00000101, 0x00000a07 },
 };
 
 static void rt2500usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
@@ -1455,27 +1497,29 @@ static void rt2500usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	 */
 	spec->num_modes = 2;
 	spec->num_rates = 12;
-	spec->num_channels = 14;
 	spec->tx_power_a = NULL;
 	spec->tx_power_bg = txpower;
 	spec->tx_power_default = DEFAULT_TXPOWER;
-	spec->chan_val_a = NULL;
-
-	if (rt2x00_rf(&rt2x00dev->chip, RF2522))
-		spec->chan_val_bg = rf_vals_bg_2522;
-	else if (rt2x00_rf(&rt2x00dev->chip, RF2523) ||
-		 rt2x00_rf(&rt2x00dev->chip, RF2524) ||
-		 rt2x00_rf(&rt2x00dev->chip, RF2525))
-		spec->chan_val_bg = rf_vals_bg_252x;
-	else if (rt2x00_rf(&rt2x00dev->chip, RF2525E))
-		spec->chan_val_bg = rf_vals_bg_2525e;
-	else if (rt2x00_rf(&rt2x00dev->chip, RF5222))
-		spec->chan_val_bg = rf_vals_abg_5222;
-
-	if (rt2x00_rf(&rt2x00dev->chip, RF5222)) {
+
+	if (rt2x00_rf(&rt2x00dev->chip, RF2522)) {
+		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2522);
+		spec->channels = rf_vals_bg_2522;
+	} else if (rt2x00_rf(&rt2x00dev->chip, RF2523)) {
+		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2523);
+		spec->channels = rf_vals_bg_2523;
+	} else if (rt2x00_rf(&rt2x00dev->chip, RF2524)) {
+		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2524);
+		spec->channels = rf_vals_bg_2524;
+	} else if (rt2x00_rf(&rt2x00dev->chip, RF2525)) {
+		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2525);
+		spec->channels = rf_vals_bg_2525;
+	} else if (rt2x00_rf(&rt2x00dev->chip, RF2525E)) {
+		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2525e);
+		spec->channels = rf_vals_bg_2525e;
+	} else if (rt2x00_rf(&rt2x00dev->chip, RF5222)) {
+		spec->num_channels = ARRAY_SIZE(rf_vals_5222);
+		spec->channels = rf_vals_5222;
 		spec->num_modes = 3;
-		spec->num_channels += 23;
-		spec->chan_val_a = &rf_vals_abg_5222[14];
 	}
 }
 
diff --git a/drivers/net/wireless/rt2x00.h b/drivers/net/wireless/rt2x00.h
index 5c6d7d0..cfd5384 100644
--- a/drivers/net/wireless/rt2x00.h
+++ b/drivers/net/wireless/rt2x00.h
@@ -168,10 +168,10 @@ struct rt2x00_chip {
 };
 
 /*
- * RF register collection structure
- * This structure contains the value for all RF register words.
+ * RF register values that belong to a particular channel.
  */
-struct rf_reg {
+struct rf_channel {
+	int channel;
 	u32 rf1;
 	u32 rf2;
 	u32 rf3;
@@ -346,8 +346,7 @@ struct hw_mode_spec {
 	/*
 	 * Device/chipset specific value.
 	 */
-	const u32 *chan_val_a;
-	const u32 *chan_val_bg;
+	const struct rf_channel *channels;
 };
 
 /*
diff --git a/drivers/net/wireless/rt2x00dev.c b/drivers/net/wireless/rt2x00dev.c
index f952595..3671f74 100644
--- a/drivers/net/wireless/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00dev.c
@@ -611,29 +611,17 @@ static int rt2x00lib_probe_hw_modes(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Initialize Channel list.
 	 */
-	for (i = 0; i < 14; i++)
-		rt2x00lib_channel(&channels[i], i + 1,
-				  spec->tx_power_bg[i], spec->chan_val_bg[i]);
-
-	if (spec->num_channels > 14) {
-		for (i = 14; i < spec->num_channels; i++) {
-			if (i < 22)
-				channels[i].chan = 36;
-			else if (i < 33)
-				channels[i].chan = 100;
-			else
-				channels[i].chan = 149;
-			channels[i].chan += ((i - 14) * 4);
-
-			if (spec->tx_power_a)
-				tx_power = spec->tx_power_a[i];
-			else
-				tx_power = spec->tx_power_default;
-
-			rt2x00lib_channel(&channels[i],
-					  channels[i].chan, tx_power,
-					  spec->chan_val_a[i]);
-		}
+	for (i = 0; i < spec->num_channels; i++) {
+		if (spec->channels[i].channel <= 14)
+			tx_power = spec->tx_power_bg[i];
+		else if (spec->tx_power_a)
+			tx_power = spec->tx_power_a[i];
+		else
+			tx_power = spec->tx_power_default;
+
+		rt2x00lib_channel(&channels[i],
+				  spec->channels[i].channel,
+				  tx_power, i);
 	}
 
 	/*
diff --git a/drivers/net/wireless/rt61pci.c b/drivers/net/wireless/rt61pci.c
index 8c6c778..d0c2323 100644
--- a/drivers/net/wireless/rt61pci.c
+++ b/drivers/net/wireless/rt61pci.c
@@ -436,192 +436,17 @@ static void rt61pci_config_phymode(struct rt2x00_dev *rt2x00dev,
 	rt61pci_config_rate(rt2x00dev, rate->val2);
 }
 
-static void rt61pci_get_rf_vals(struct rt2x00_dev *rt2x00dev,
-				const int value, const int channel,
-				struct rf_reg *reg)
-{
-	reg->rf1 = 0;
-	reg->rf2 = value;
-	reg->rf3 = 0;
-	reg->rf4 = 0;
-
-	if (!test_bit(CONFIG_RF_SEQUENCE, &rt2x00dev->flags) || channel <= 14)
-		reg->rf1 = 0x00002ccc;
-	else if (channel == 36 ||
-		(channel >= 100 && channel <= 116) ||
-		channel >= 157)
-		reg->rf1 = 0x00002cd4;
-	else
-		reg->rf1 = 0x00002cd0;
-
-	if (channel <= 14) {
-		reg->rf3 = 0x00068455;
-	} else if (!test_bit(CONFIG_RF_SEQUENCE, &rt2x00dev->flags)) {
-		if (channel >= 36 && channel <= 48)
-			reg->rf3 = 0x0009be55;
-		else if (channel >= 52 && channel <= 64)
-			reg->rf3 = 0x0009ae55;
-		else if (channel >= 100 && channel <= 112)
-			reg->rf3 = 0x000bae55;
-		else
-			reg->rf3 = 0x000bbe55;
-	} else {
-		switch (channel) {
-		case 36:
-		case 40:
-		case 44:
-			reg->rf3 = 0x00098455;
-			break;
-		case 48:
-			reg->rf3 = 0x00098655;
-			break;
-		case 52:
-			reg->rf3 = 0x00098855;
-			break;
-		case 56:
-			reg->rf3 = 0x00098c55;
-		case 60:
-			reg->rf3 = 0x00098e55;
-			break;
-		case 64:
-			reg->rf3 = 0x00099255;
-			break;
-		case 100:
-		case 104:
-		case 108:
-			reg->rf3 = 0x000b9855;
-			break;
-		case 112:
-		case 116:
-		case 120:
-		case 124:
-			reg->rf3 = 0x000b9a55;
-			break;
-		case 128:
-		case 132:
-			reg->rf3 = 0x000b9c55;
-			break;
-		case 136:
-		case 140:
-			reg->rf3 = 0x000b9e55;
-			break;
-		case 149:
-		case 153:
-		case 157:
-		case 161:
-		case 165:
-			reg->rf3 = 0x000ba255;
-			break;
-		}
-	}
-
-	if (channel < 14) {
-		if (channel & 1)
-			reg->rf4 = 0x000ffa0b;
-		else
-			reg->rf4 = 0x000ffa1f;
-	} else if (channel == 14) {
-		reg->rf4 = 0x000ffa13;
-	} else if (!test_bit(CONFIG_RF_SEQUENCE, &rt2x00dev->flags)) {
-		switch (channel) {
-		case 36:
-		case 56:
-		case 116:
-		case 136:
-			reg->rf4 = 0x000ffa23;
-			break;
-		case 40:
-		case 60:
-		case 100:
-		case 120:
-		case 140:
-			reg->rf4 = 0x000ffa03;
-			break;
-		case 44:
-		case 64:
-		case 104:
-		case 124:
-			reg->rf4 = 0x000ffa0b;
-			break;
-		case 48:
-		case 108:
-		case 128:
-			reg->rf4 = 0x000ffa13;
-			break;
-		case 52:
-		case 112:
-		case 132:
-			reg->rf4 = 0x000ffa1b;
-			break;
-		case 149:
-			reg->rf4 = 0x000ffa1f;
-			break;
-		case 153:
-			reg->rf4 = 0x000ffa27;
-			break;
-		case 157:
-			reg->rf4 = 0x000ffa07;
-			break;
-		case 161:
-			reg->rf4 = 0x000ffa0f;
-			break;
-		case 165:
-			reg->rf4 = 0x000ffa17;
-			break;
-		}
-	} else {
-		switch (channel) {
-		case 36:
-		case 40:
-		case 60:
-		case 140:
-		case 100:
-		case 104:
-		case 108:
-		case 112:
-		case 116:
-		case 120:
-			reg->rf4 = 0x000c0a03;
-			break;
-		case 44:
-		case 64:
-		case 124:
-		case 149:
-			reg->rf4 = 0x000c0a1b;
-			break;
-		case 48:
-		case 128:
-		case 153:
-			reg->rf4 = 0x000c0a0b;
-			break;
-		case 52:
-		case 132:
-			reg->rf4 = 0x000c0a23;
-			break;
-		case 56:
-		case 136:
-			reg->rf4 = 0x000c0a13;
-			break;
-		case 157:
-		case 161:
-		case 165:
-			reg->rf4 = 0x000c0a17;
-			break;
-		}
-	}
-}
-
 static void rt61pci_config_channel(struct rt2x00_dev *rt2x00dev,
-				   const int value, const int channel,
+				   const int index, const int channel,
 				   const int txpower)
 {
-	struct rf_reg reg;
+	struct rf_channel reg;
 	u8 bbp = 0;
 
 	/*
 	 * Fill rf_reg structure.
 	 */
-	rt61pci_get_rf_vals(rt2x00dev, value, channel, &reg);
+	memcpy(&reg, &rt2x00dev->spec.channels[index], sizeof(reg));
 
 	/*
 	 * Set TXpower.
@@ -666,7 +491,7 @@ static void rt61pci_config_channel(struct rt2x00_dev *rt2x00dev,
 static void rt61pci_config_txpower(struct rt2x00_dev *rt2x00dev,
 				   const int txpower)
 {
-	struct rf_reg rf;
+	struct rf_channel rf;
 
 	rt2x00_rf_read(rt2x00dev, 1, &rf.rf1);
 	rt2x00_rf_read(rt2x00dev, 2, &rf.rf2);
@@ -2176,37 +2001,117 @@ static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 }
 
 /*
- * RF value list for RF5225, RF5325, RF2527 & RF2529
- * Supports: 2.4 GHz
+ * RF value list for RF5225 & RF5325
+ * Supports: 2.4 GHz & 5.2 GHz, rf_sequence disabled
  */
-static const u32 rf_vals_bg[] = {
-	0x00004786, 0x00004786, 0x0000478a, 0x0000478a, 0x0000478e,
-	0x0000478e, 0x00004792, 0x00004792, 0x00004796, 0x00004796,
-	0x0000479a, 0x0000479a, 0x0000479e, 0x000047a2
+static const struct rf_channel rf_vals_noseq[] = {
+	{ 1,  0x00002ccc, 0x00004786, 0x00068455, 0x000ffa0b },
+	{ 2,  0x00002ccc, 0x00004786, 0x00068455, 0x000ffa1f },
+	{ 3,  0x00002ccc, 0x0000478a, 0x00068455, 0x000ffa0b },
+	{ 4,  0x00002ccc, 0x0000478a, 0x00068455, 0x000ffa1f },
+	{ 5,  0x00002ccc, 0x0000478e, 0x00068455, 0x000ffa0b },
+	{ 6,  0x00002ccc, 0x0000478e, 0x00068455, 0x000ffa1f },
+	{ 7,  0x00002ccc, 0x00004792, 0x00068455, 0x000ffa0b },
+	{ 8,  0x00002ccc, 0x00004792, 0x00068455, 0x000ffa1f },
+	{ 9,  0x00002ccc, 0x00004796, 0x00068455, 0x000ffa0b },
+	{ 10, 0x00002ccc, 0x00004796, 0x00068455, 0x000ffa1f },
+	{ 11, 0x00002ccc, 0x0000479a, 0x00068455, 0x000ffa0b },
+	{ 12, 0x00002ccc, 0x0000479a, 0x00068455, 0x000ffa1f },
+	{ 13, 0x00002ccc, 0x0000479e, 0x00068455, 0x000ffa0b },
+	{ 14, 0x00002ccc, 0x000047a2, 0x00068455, 0x000ffa13 },
+
+	/* 802.11 UNI / HyperLan 2 */
+	{ 36, 0x00002ccc, 0x0000499a, 0x0009be55, 0x000ffa23 },
+	{ 40, 0x00002ccc, 0x000049a2, 0x0009be55, 0x000ffa03 },
+	{ 44, 0x00002ccc, 0x000049a6, 0x0009be55, 0x000ffa0b },
+	{ 48, 0x00002ccc, 0x000049aa, 0x0009be55, 0x000ffa13 },
+	{ 52, 0x00002ccc, 0x000049ae, 0x0009ae55, 0x000ffa1b },
+	{ 56, 0x00002ccc, 0x000049b2, 0x0009ae55, 0x000ffa23 },
+	{ 60, 0x00002ccc, 0x000049ba, 0x0009ae55, 0x000ffa03 },
+	{ 64, 0x00002ccc, 0x000049be, 0x0009ae55, 0x000ffa0b },
+
+	/* 802.11 HyperLan 2 */
+	{ 100, 0x00002ccc, 0x00004a2a, 0x000bae55, 0x000ffa03 },
+	{ 104, 0x00002ccc, 0x00004a2e, 0x000bae55, 0x000ffa0b },
+	{ 108, 0x00002ccc, 0x00004a32, 0x000bae55, 0x000ffa13 },
+	{ 112, 0x00002ccc, 0x00004a36, 0x000bae55, 0x000ffa1b },
+	{ 116, 0x00002ccc, 0x00004a3a, 0x000bbe55, 0x000ffa23 },
+	{ 120, 0x00002ccc, 0x00004a82, 0x000bbe55, 0x000ffa03 },
+	{ 124, 0x00002ccc, 0x00004a86, 0x000bbe55, 0x000ffa0b },
+	{ 128, 0x00002ccc, 0x00004a8a, 0x000bbe55, 0x000ffa13 },
+	{ 132, 0x00002ccc, 0x00004a8e, 0x000bbe55, 0x000ffa1b },
+	{ 136, 0x00002ccc, 0x00004a92, 0x000bbe55, 0x000ffa23 },
+
+	/* 802.11 UNII */
+	{ 140, 0x00002ccc, 0x00004a9a, 0x000bbe55, 0x000ffa03 },
+	{ 149, 0x00002ccc, 0x00004aa2, 0x000bbe55, 0x000ffa1f },
+	{ 153, 0x00002ccc, 0x00004aa6, 0x000bbe55, 0x000ffa27 },
+	{ 157, 0x00002ccc, 0x00004aae, 0x000bbe55, 0x000ffa07 },
+	{ 161, 0x00002ccc, 0x00004ab2, 0x000bbe55, 0x000ffa0f },
+	{ 165, 0x00002ccc, 0x00004ab6, 0x000bbe55, 0x000ffa17 },
+
+	/* MMAC(Japan)J52 ch 34,38,42,46 */
+	{ 34, 0x00002ccc, 0x0000499a, 0x0009be55, 0x000ffa0b },
+	{ 38, 0x00002ccc, 0x0000499e, 0x0009be55, 0x000ffa13 },
+	{ 42, 0x00002ccc, 0x000049a2, 0x0009be55, 0x000ffa1b },
+	{ 46, 0x00002ccc, 0x000049a6, 0x0009be55, 0x000ffa23 },
 };
 
 /*
- * RF value list for RF5225 & RF5325 (supplement to vals_bg)
- * Supports: 5.2 GHz, rf_sequence disabled
+ * RF value list for RF5225 & RF5325
+ * Supports: 2.4 GHz & 5.2 GHz, rf_sequence enabled
  */
-static const u32 rf_vals_a_5x_noseq[] = {
-	0x0000499a, 0x000049a2, 0x000049a6, 0x000049aa, 0x000049ae,
-	0x000049b2, 0x000049ba, 0x000049be, 0x00004a2a, 0x00004a2e,
-	0x00004a32, 0x00004a36, 0x00004a3a, 0x00004a82, 0x00004a86,
-	0x00004a8a, 0x00004a8e, 0x00004a92, 0x00004a9a, 0x00004aa2,
-	0x00004aa6, 0x00004aae, 0x00004ab2, 0x00004ab6
-};
-
-/*
- * RF value list for RF5225 & RF5325 (supplement to vals_bg)
- * Supports: 5.2 GHz, rf_sequence enabled
- */
-static const u32 rf_vals_a_5x_seq[] = {
-	0x0004481a, 0x00044682, 0x00044686, 0x0004468e, 0x00044692,
-	0x0004469a, 0x000446a2, 0x000446a6, 0x0004489a, 0x000448a2,
-	0x000448aa, 0x000448b2, 0x000448ba, 0x00044702, 0x00044706,
-	0x0004470e, 0x00044712, 0x0004471a, 0x00044722, 0x0004472e,
-	0x00044736, 0x0004490a, 0x00044912, 0x0004491a
+static const struct rf_channel rf_vals_seq[] = {
+	{ 1,  0x00002ccc, 0x00004786, 0x00068455, 0x000ffa0b },
+	{ 2,  0x00002ccc, 0x00004786, 0x00068455, 0x000ffa1f },
+	{ 3,  0x00002ccc, 0x0000478a, 0x00068455, 0x000ffa0b },
+	{ 4,  0x00002ccc, 0x0000478a, 0x00068455, 0x000ffa1f },
+	{ 5,  0x00002ccc, 0x0000478e, 0x00068455, 0x000ffa0b },
+	{ 6,  0x00002ccc, 0x0000478e, 0x00068455, 0x000ffa1f },
+	{ 7,  0x00002ccc, 0x00004792, 0x00068455, 0x000ffa0b },
+	{ 8,  0x00002ccc, 0x00004792, 0x00068455, 0x000ffa1f },
+	{ 9,  0x00002ccc, 0x00004796, 0x00068455, 0x000ffa0b },
+	{ 10, 0x00002ccc, 0x00004796, 0x00068455, 0x000ffa1f },
+	{ 11, 0x00002ccc, 0x0000479a, 0x00068455, 0x000ffa0b },
+	{ 12, 0x00002ccc, 0x0000479a, 0x00068455, 0x000ffa1f },
+	{ 13, 0x00002ccc, 0x0000479e, 0x00068455, 0x000ffa0b },
+	{ 14, 0x00002ccc, 0x000047a2, 0x00068455, 0x000ffa13 },
+
+	/* 802.11 UNI / HyperLan 2 */
+	{ 36, 0x00002cd4, 0x0004481a, 0x00098455, 0x000c0a03 },
+	{ 40, 0x00002cd0, 0x00044682, 0x00098455, 0x000c0a03 },
+	{ 44, 0x00002cd0, 0x00044686, 0x00098455, 0x000c0a1b },
+	{ 48, 0x00002cd0, 0x0004468e, 0x00098655, 0x000c0a0b },
+	{ 52, 0x00002cd0, 0x00044692, 0x00098855, 0x000c0a23 },
+	{ 56, 0x00002cd0, 0x0004469a, 0x00098c55, 0x000c0a13 },
+	{ 60, 0x00002cd0, 0x000446a2, 0x00098e55, 0x000c0a03 },
+	{ 64, 0x00002cd0, 0x000446a6, 0x00099255, 0x000c0a1b },
+
+	/* 802.11 HyperLan 2 */
+	{ 100, 0x00002cd4, 0x0004489a, 0x000b9855, 0x000c0a03 },
+	{ 104, 0x00002cd4, 0x000448a2, 0x000b9855, 0x000c0a03 },
+	{ 108, 0x00002cd4, 0x000448aa, 0x000b9855, 0x000c0a03 },
+	{ 112, 0x00002cd4, 0x000448b2, 0x000b9a55, 0x000c0a03 },
+	{ 116, 0x00002cd4, 0x000448ba, 0x000b9a55, 0x000c0a03 },
+	{ 120, 0x00002cd0, 0x00044702, 0x000b9a55, 0x000c0a03 },
+	{ 124, 0x00002cd0, 0x00044706, 0x000b9a55, 0x000c0a1b },
+	{ 128, 0x00002cd0, 0x0004470e, 0x000b9c55, 0x000c0a0b },
+	{ 132, 0x00002cd0, 0x00044712, 0x000b9c55, 0x000c0a23 },
+	{ 136, 0x00002cd0, 0x0004471a, 0x000b9e55, 0x000c0a13 },
+
+	/* 802.11 UNII */
+	{ 140, 0x00002cd0, 0x00044722, 0x000b9e55, 0x000c0a03 },
+	{ 149, 0x00002cd0, 0x0004472e, 0x000ba255, 0x000c0a1b },
+	{ 153, 0x00002cd0, 0x00044736, 0x000ba255, 0x000c0a0b },
+	{ 157, 0x00002cd4, 0x0004490a, 0x000ba255, 0x000c0a17 },
+	{ 161, 0x00002cd4, 0x00044912, 0x000ba255, 0x000c0a17 },
+	{ 165, 0x00002cd4, 0x0004491a, 0x000ba255, 0x000c0a17 },
+
+	/* MMAC(Japan)J52 ch 34,38,42,46 */
+	{ 34, 0x00002ccc, 0x0000499a, 0x0009be55, 0x000c0a0b },
+	{ 38, 0x00002ccc, 0x0000499e, 0x0009be55, 0x000c0a13 },
+	{ 42, 0x00002ccc, 0x000049a2, 0x0009be55, 0x000c0a1b },
+	{ 46, 0x00002ccc, 0x000049a6, 0x0009be55, 0x000c0a23 },
 };
 
 static void rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
@@ -2248,27 +2153,28 @@ static void rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	 */
 	spec->num_modes = 2;
 	spec->num_rates = 12;
-	spec->num_channels = 14;
 	spec->tx_power_a = NULL;
 	spec->tx_power_bg = txpower;
 	spec->tx_power_default = DEFAULT_TXPOWER;
-	spec->chan_val_a = NULL;
-	spec->chan_val_bg = rf_vals_bg;
+
+	if (!test_bit(CONFIG_RF_SEQUENCE, &rt2x00dev->flags)) {
+		spec->num_channels = 14;
+		spec->channels = rf_vals_noseq;
+	} else {
+		spec->num_channels = 14;
+		spec->channels = rf_vals_seq;
+	}
 
 	if (rt2x00_rf(&rt2x00dev->chip, RF5225) ||
 	    rt2x00_rf(&rt2x00dev->chip, RF5325)) {
 		spec->num_modes = 3;
-		spec->num_channels += 24;
+		spec->num_channels = ARRAY_SIZE(rf_vals_seq);
 
 		txpower = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A_START);
 		for (i = 0; i < 14; i++)
 			txpower[i] = TXPOWER_FROM_DEV(txpower[i]);
 
 		spec->tx_power_a = txpower;
-		if (!test_bit(CONFIG_RF_SEQUENCE, &rt2x00dev->flags))
-			spec->chan_val_a = rf_vals_a_5x_noseq;
-		else
-			spec->chan_val_a = rf_vals_a_5x_seq;
 	}
 }
 
diff --git a/drivers/net/wireless/rt73usb.c b/drivers/net/wireless/rt73usb.c
index 30d4189..413725c 100644
--- a/drivers/net/wireless/rt73usb.c
+++ b/drivers/net/wireless/rt73usb.c
@@ -194,7 +194,13 @@ static void rt73usb_rf_write(const struct rt2x00_dev *rt2x00dev,
 rf_write:
 	reg = 0;
 	rt2x00_set_field32(&reg, PHY_CSR4_VALUE, value);
-	rt2x00_set_field32(&reg, PHY_CSR4_NUMBER_OF_BITS, 20);
+
+	if (rt2x00_rf(&rt2x00dev->chip, RF5225) ||
+	    rt2x00_rf(&rt2x00dev->chip, RF2527))
+		rt2x00_set_field32(&reg, PHY_CSR4_NUMBER_OF_BITS, 21);
+	else
+		rt2x00_set_field32(&reg, PHY_CSR4_NUMBER_OF_BITS, 20);
+
 	rt2x00_set_field32(&reg, PHY_CSR4_IF_SELECT, 0);
 	rt2x00_set_field32(&reg, PHY_CSR4_BUSY, 1);
 
@@ -406,123 +412,17 @@ static void rt73usb_config_phymode(struct rt2x00_dev *rt2x00dev,
 	rt73usb_config_rate(rt2x00dev, rate->val2);
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
-static void rt73usb_get_rf_vals(struct rt2x00_dev *rt2x00dev,
-				const int value, const int channel,
-				struct rf_reg *reg)
-{
-	unsigned int i;
-
-	reg->rf1 = 0;
-	reg->rf2 = value;
-	reg->rf3 = 0;
-	reg->rf4 = 0;
-
-	for (i = 0; i < ARRAY_SIZE(rf_vals); i++) {
-		if (rt2x00_rf(&rt2x00dev->chip, rf_vals[i].chip)) {
-			reg->rf1 = rf_vals[i].val[0];
-			reg->rf3 = rf_vals[i].val[1];
-		}
-	}
-
-	if (rt2x00_rf(&rt2x00dev->chip, RF5225) ||
-	    rt2x00_rf(&rt2x00dev->chip, RF2527))
-		reg->rf2 |= 0x00004000;
-
-	if (rt2x00_rf(&rt2x00dev->chip, RF5225)) {
-		if (channel <= 14)
-			reg->rf3 = 0x00068455;
-		else if (channel >= 36 && channel <= 48)
-			reg->rf3 = 0x0009be55;
-		else if (channel >= 52 && channel <= 64)
-			reg->rf3 = 0x0009ae55;
-		else if (channel >= 100 && channel <= 112)
-			reg->rf3 = 0x000bae55;
-		else
-			reg->rf3 = 0x000bbe55;
-	}
-
-	if (channel < 14) {
-		if (channel & 0x01)
-			reg->rf4 = 0x000fea0b;
-		else
-			reg->rf4 = 0x000fea1f;
-	} else if (channel == 14) {
-		reg->rf4 = 0x000fea13;
-	} else {
-		switch (channel) {
-		case 36:
-		case 56:
-		case 116:
-		case 136:
-			reg->rf4 = 0x000fea23;
-			break;
-		case 40:
-		case 60:
-		case 100:
-		case 120:
-		case 140:
-			reg->rf4 = 0x000fea03;
-			break;
-		case 44:
-		case 64:
-		case 104:
-		case 124:
-			reg->rf4 = 0x000fea0b;
-			break;
-		case 48:
-		case 108:
-		case 128:
-			reg->rf4 = 0x000fea13;
-			break;
-		case 52:
-		case 112:
-		case 132:
-			reg->rf4 = 0x000fea1b;
-			break;
-		case 149:
-			reg->rf4 = 0x000fea1f;
-			break;
-		case 153:
-			reg->rf4 = 0x000fea27;
-			break;
-		case 157:
-			reg->rf4 = 0x000fea07;
-			break;
-		case 161:
-			reg->rf4 = 0x000fea0f;
-			break;
-		case 165:
-			reg->rf4 = 0x000fea17;
-			break;
-		}
-	}
-
-	if (rt2x00_rf(&rt2x00dev->chip, RF2527) ||
-	    rt2x00_rf(&rt2x00dev->chip, RF5225))
-		reg->rf4 |= 0x00010000;
-}
-
 static void rt73usb_config_channel(struct rt2x00_dev *rt2x00dev,
-				   const int value, const int channel,
+				   const int index, const int channel,
 				   const int txpower)
 {
-	struct rf_reg reg;
+	struct rf_channel reg;
 	u8 bbp = 0;
 
 	/*
 	 * Fill rf_reg structure.
 	 */
-	rt73usb_get_rf_vals(rt2x00dev, value, channel, &reg);
+	memcpy(&reg, &rt2x00dev->spec.channels[index], sizeof(reg));
 
 	/*
 	 * Set TXpower.
@@ -563,7 +463,7 @@ static void rt73usb_config_channel(struct rt2x00_dev *rt2x00dev,
 static void rt73usb_config_txpower(struct rt2x00_dev *rt2x00dev,
 				   const int txpower)
 {
-	struct rf_reg rf;
+	struct rf_channel rf;
 
 	rt2x00_rf_read(rt2x00dev, 1, &rf.rf1);
 	rt2x00_rf_read(rt2x00dev, 2, &rf.rf2);
@@ -1654,27 +1554,141 @@ static int rt73usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 }
 
 /*
- * RF value list for RF5226, RF2528, RF5225 & RF2527
+ * RF value list for RF2528
  * Supports: 2.4 GHz
  */
-static const u32 rf_vals_bg[] = {
-	0x00000786, 0x00000786, 0x0000078a, 0x0000078a, 0x0000078e,
-	0x0000078e, 0x00000792, 0x00000792, 0x00000796, 0x00000796,
-	0x0000079a, 0x0000079a, 0x0000079e, 0x000007a2
+static const struct rf_channel rf_vals_bg_2528[] = {
+	{ 1,  0x00002c0c, 0x00000786, 0x00068255, 0x000fea0b },
+	{ 2,  0x00002c0c, 0x00000786, 0x00068255, 0x000fea1f },
+	{ 3,  0x00002c0c, 0x0000078a, 0x00068255, 0x000fea0b },
+	{ 4,  0x00002c0c, 0x0000078a, 0x00068255, 0x000fea1f },
+	{ 5,  0x00002c0c, 0x0000078e, 0x00068255, 0x000fea0b },
+	{ 6,  0x00002c0c, 0x0000078e, 0x00068255, 0x000fea1f },
+	{ 7,  0x00002c0c, 0x00000792, 0x00068255, 0x000fea0b },
+	{ 8,  0x00002c0c, 0x00000792, 0x00068255, 0x000fea1f },
+	{ 9,  0x00002c0c, 0x00000796, 0x00068255, 0x000fea0b },
+	{ 10, 0x00002c0c, 0x00000796, 0x00068255, 0x000fea1f },
+	{ 11, 0x00002c0c, 0x0000079a, 0x00068255, 0x000fea0b },
+	{ 12, 0x00002c0c, 0x0000079a, 0x00068255, 0x000fea1f },
+	{ 13, 0x00002c0c, 0x0000079e, 0x00068255, 0x000fea0b },
+	{ 14, 0x00002c0c, 0x000007a2, 0x00068255, 0x000fea13 },
+};
+
+/*
+ * RF value list for RF5226
+ * Supports: 2.4 GHz & 5.2 GHz
+ */
+static const struct rf_channel rf_vals_5226[] = {
+	{ 1,  0x00002c0c, 0x00000786, 0x00068255, 0x000fea0b },
+	{ 2,  0x00002c0c, 0x00000786, 0x00068255, 0x000fea1f },
+	{ 3,  0x00002c0c, 0x0000078a, 0x00068255, 0x000fea0b },
+	{ 4,  0x00002c0c, 0x0000078a, 0x00068255, 0x000fea1f },
+	{ 5,  0x00002c0c, 0x0000078e, 0x00068255, 0x000fea0b },
+	{ 6,  0x00002c0c, 0x0000078e, 0x00068255, 0x000fea1f },
+	{ 7,  0x00002c0c, 0x00000792, 0x00068255, 0x000fea0b },
+	{ 8,  0x00002c0c, 0x00000792, 0x00068255, 0x000fea1f },
+	{ 9,  0x00002c0c, 0x00000796, 0x00068255, 0x000fea0b },
+	{ 10, 0x00002c0c, 0x00000796, 0x00068255, 0x000fea1f },
+	{ 11, 0x00002c0c, 0x0000079a, 0x00068255, 0x000fea0b },
+	{ 12, 0x00002c0c, 0x0000079a, 0x00068255, 0x000fea1f },
+	{ 13, 0x00002c0c, 0x0000079e, 0x00068255, 0x000fea0b },
+	{ 14, 0x00002c0c, 0x000007a2, 0x00068255, 0x000fea13 },
+
+	/* 802.11 UNI / HyperLan 2 */
+	{ 36, 0x00002c0c, 0x0000099a, 0x00098255, 0x000fea23 },
+	{ 40, 0x00002c0c, 0x000009a2, 0x00098255, 0x000fea03 },
+	{ 44, 0x00002c0c, 0x000009a6, 0x00098255, 0x000fea0b },
+	{ 48, 0x00002c0c, 0x000009aa, 0x00098255, 0x000fea13 },
+	{ 52, 0x00002c0c, 0x000009ae, 0x00098255, 0x000fea1b },
+	{ 56, 0x00002c0c, 0x000009b2, 0x00098255, 0x000fea23 },
+	{ 60, 0x00002c0c, 0x000009ba, 0x00098255, 0x000fea03 },
+	{ 64, 0x00002c0c, 0x000009be, 0x00098255, 0x000fea0b },
+
+	/* 802.11 HyperLan 2 */
+	{ 100, 0x00002c0c, 0x00000a2a, 0x000b8255, 0x000fea03 },
+	{ 104, 0x00002c0c, 0x00000a2e, 0x000b8255, 0x000fea0b },
+	{ 108, 0x00002c0c, 0x00000a32, 0x000b8255, 0x000fea13 },
+	{ 112, 0x00002c0c, 0x00000a36, 0x000b8255, 0x000fea1b },
+	{ 116, 0x00002c0c, 0x00000a3a, 0x000b8255, 0x000fea23 },
+	{ 120, 0x00002c0c, 0x00000a82, 0x000b8255, 0x000fea03 },
+	{ 124, 0x00002c0c, 0x00000a86, 0x000b8255, 0x000fea0b },
+	{ 128, 0x00002c0c, 0x00000a8a, 0x000b8255, 0x000fea13 },
+	{ 132, 0x00002c0c, 0x00000a8e, 0x000b8255, 0x000fea1b },
+	{ 136, 0x00002c0c, 0x00000a92, 0x000b8255, 0x000fea23 },
+
+	/* 802.11 UNII */
+	{ 140, 0x00002c0c, 0x00000a9a, 0x000b8255, 0x000fea03 },
+	{ 149, 0x00002c0c, 0x00000aa2, 0x000b8255, 0x000fea1f },
+	{ 153, 0x00002c0c, 0x00000aa6, 0x000b8255, 0x000fea27 },
+	{ 157, 0x00002c0c, 0x00000aae, 0x000b8255, 0x000fea07 },
+	{ 161, 0x00002c0c, 0x00000ab2, 0x000b8255, 0x000fea0f },
+	{ 165, 0x00002c0c, 0x00000ab6, 0x000b8255, 0x000fea17 },
+
+	/* MMAC(Japan)J52 ch 34,38,42,46 */
+	{ 34, 0x00002c0c, 0x0008099a, 0x000da255, 0x000d3a0b },
+	{ 38, 0x00002c0c, 0x0008099e, 0x000da255, 0x000d3a13 },
+	{ 42, 0x00002c0c, 0x000809a2, 0x000da255, 0x000d3a1b },
+	{ 46, 0x00002c0c, 0x000809a6, 0x000da255, 0x000d3a23 },
 };
 
 /*
- * RF value list for RF5226 & RF5225 (supplement to vals_bg)
- * Supports: 5.2 GHz
+ * RF value list for RF5225 & RF2527
+ * Supports: 2.4 GHz & 5.2 GHz
  */
-static const u32 rf_vals_a_5x[] = {
-	0x0000099a, 0x000009a2, 0x000009a6, 0x000009aa, 0x000009ae,
-	0x000009b2, 0x000009ba, 0x000009be, 0x00000a2a, 0x00000a2e,
-	0x00000a32, 0x00000a36, 0x00000a3a, 0x00000a82, 0x00000a86,
-	0x00000a8a, 0x00000a8e, 0x00000a92, 0x00000a9a, 0x00000aa2,
-	0x00000aa6, 0x00000aae, 0x00000ab2, 0x00000ab6
+static const struct rf_channel rf_vals_5225_2527[] = {
+	{ 1,  0x00002ccc, 0x00004786, 0x00068455, 0x000ffa0b },
+	{ 2,  0x00002ccc, 0x00004786, 0x00068455, 0x000ffa1f },
+	{ 3,  0x00002ccc, 0x0000478a, 0x00068455, 0x000ffa0b },
+	{ 4,  0x00002ccc, 0x0000478a, 0x00068455, 0x000ffa1f },
+	{ 5,  0x00002ccc, 0x0000478e, 0x00068455, 0x000ffa0b },
+	{ 6,  0x00002ccc, 0x0000478e, 0x00068455, 0x000ffa1f },
+	{ 7,  0x00002ccc, 0x00004792, 0x00068455, 0x000ffa0b },
+	{ 8,  0x00002ccc, 0x00004792, 0x00068455, 0x000ffa1f },
+	{ 9,  0x00002ccc, 0x00004796, 0x00068455, 0x000ffa0b },
+	{ 10, 0x00002ccc, 0x00004796, 0x00068455, 0x000ffa1f },
+	{ 11, 0x00002ccc, 0x0000479a, 0x00068455, 0x000ffa0b },
+	{ 12, 0x00002ccc, 0x0000479a, 0x00068455, 0x000ffa1f },
+	{ 13, 0x00002ccc, 0x0000479e, 0x00068455, 0x000ffa0b },
+	{ 14, 0x00002ccc, 0x000047a2, 0x00068455, 0x000ffa13 },
+
+	/* 802.11 UNI / HyperLan 2 */
+	{ 36, 0x00002ccc, 0x0000499a, 0x0009be55, 0x000ffa23 },
+	{ 40, 0x00002ccc, 0x000049a2, 0x0009be55, 0x000ffa03 },
+	{ 44, 0x00002ccc, 0x000049a6, 0x0009be55, 0x000ffa0b },
+	{ 48, 0x00002ccc, 0x000049aa, 0x0009be55, 0x000ffa13 },
+	{ 52, 0x00002ccc, 0x000049ae, 0x0009ae55, 0x000ffa1b },
+	{ 56, 0x00002ccc, 0x000049b2, 0x0009ae55, 0x000ffa23 },
+	{ 60, 0x00002ccc, 0x000049ba, 0x0009ae55, 0x000ffa03 },
+	{ 64, 0x00002ccc, 0x000049be, 0x0009ae55, 0x000ffa0b },
+
+	/* 802.11 HyperLan 2 */
+	{ 100, 0x00002ccc, 0x00004a2a, 0x000bae55, 0x000ffa03 },
+	{ 104, 0x00002ccc, 0x00004a2e, 0x000bae55, 0x000ffa0b },
+	{ 108, 0x00002ccc, 0x00004a32, 0x000bae55, 0x000ffa13 },
+	{ 112, 0x00002ccc, 0x00004a36, 0x000bae55, 0x000ffa1b },
+	{ 116, 0x00002ccc, 0x00004a3a, 0x000bbe55, 0x000ffa23 },
+	{ 120, 0x00002ccc, 0x00004a82, 0x000bbe55, 0x000ffa03 },
+	{ 124, 0x00002ccc, 0x00004a86, 0x000bbe55, 0x000ffa0b },
+	{ 128, 0x00002ccc, 0x00004a8a, 0x000bbe55, 0x000ffa13 },
+	{ 132, 0x00002ccc, 0x00004a8e, 0x000bbe55, 0x000ffa1b },
+	{ 136, 0x00002ccc, 0x00004a92, 0x000bbe55, 0x000ffa23 },
+
+	/* 802.11 UNII */
+	{ 140, 0x00002ccc, 0x00004a9a, 0x000bbe55, 0x000ffa03 },
+	{ 149, 0x00002ccc, 0x00004aa2, 0x000bbe55, 0x000ffa1f },
+	{ 153, 0x00002ccc, 0x00004aa6, 0x000bbe55, 0x000ffa27 },
+	{ 157, 0x00002ccc, 0x00004aae, 0x000bbe55, 0x000ffa07 },
+	{ 161, 0x00002ccc, 0x00004ab2, 0x000bbe55, 0x000ffa0f },
+	{ 165, 0x00002ccc, 0x00004ab6, 0x000bbe55, 0x000ffa17 },
+
+	/* MMAC(Japan)J52 ch 34,38,42,46 */
+	{ 34, 0x00002ccc, 0x0000499a, 0x0009be55, 0x000ffa0b },
+	{ 38, 0x00002ccc, 0x0000499e, 0x0009be55, 0x000ffa13 },
+	{ 42, 0x00002ccc, 0x000049a2, 0x0009be55, 0x000ffa1b },
+	{ 46, 0x00002ccc, 0x000049a6, 0x0009be55, 0x000ffa23 },
 };
 
+
 static void rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 {
 	struct hw_mode_spec *spec = &rt2x00dev->spec;
@@ -1714,24 +1728,33 @@ static void rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	 */
 	spec->num_modes = 2;
 	spec->num_rates = 12;
-	spec->num_channels = 14;
 	spec->tx_power_a = NULL;
 	spec->tx_power_bg = txpower;
 	spec->tx_power_default = DEFAULT_TXPOWER;
-	spec->chan_val_a = NULL;
-	spec->chan_val_bg = rf_vals_bg;
+
+	if (rt2x00_rf(&rt2x00dev->chip, RF2528)) {
+		spec->num_channels = ARRAY_SIZE(rf_vals_bg_2528);
+		spec->channels = rf_vals_bg_2528;
+	} else if (rt2x00_rf(&rt2x00dev->chip, RF5226)) {
+		spec->num_channels = ARRAY_SIZE(rf_vals_5226);
+		spec->channels = rf_vals_5226;
+	} else if (rt2x00_rf(&rt2x00dev->chip, RF2527)) {
+		spec->num_channels = 14;
+		spec->channels = rf_vals_5225_2527;
+	} else if (rt2x00_rf(&rt2x00dev->chip, RF5225)) {
+		spec->num_channels = ARRAY_SIZE(rf_vals_5225_2527);
+		spec->channels = rf_vals_5225_2527;
+	}
 
 	if (rt2x00_rf(&rt2x00dev->chip, RF5225) ||
 	    rt2x00_rf(&rt2x00dev->chip, RF5226)) {
 		spec->num_modes = 3;
-		spec->num_channels += 24;
 
 		txpower = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A_START);
 		for (i = 0; i < 14; i++)
 			txpower[i] = TXPOWER_FROM_DEV(txpower[i]);
 
 		spec->tx_power_a = txpower;
-		spec->chan_val_a = rf_vals_a_5x;
 	}
 }
 
-- 
1.5.3.rc5

