Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:48192 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765126AbXGaSeF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 14:34:05 -0400
Received: by ug-out-1314.google.com with SMTP id j3so121179ugf
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 11:34:04 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 06/24] rt2x00: Cleanup RF register reading/writing
Date: Tue, 31 Jul 2007 20:37:08 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200707312037.08603.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From a399313df283e8bfe98aa6e87c0ec40e6ee3cae7 Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Fri, 27 Jul 2007 20:08:16 +0200
Subject: [PATCH 06/24] rt2x00: Cleanup RF register reading/writing

Change the way the RF registers are being handled
by making it similar to EEPROM reading where functions
need to be used to obtain the temporary data.
Also when a RF word is being written is should be
accompanied by the word number, which allows us to
store the word in the buffer.

Overall this means that RF register handling is
now the same as all other register access handling.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2400pci.c |   33 +++++++---------
 drivers/net/wireless/rt2400pci.h |    1 +
 drivers/net/wireless/rt2500pci.c |   37 +++++++++---------
 drivers/net/wireless/rt2500pci.h |    1 +
 drivers/net/wireless/rt2500usb.c |   30 +++++++-------
 drivers/net/wireless/rt2500usb.h |    1 +
 drivers/net/wireless/rt2x00.h    |   31 ++++++++++++---
 drivers/net/wireless/rt2x00dev.c |    5 --
 drivers/net/wireless/rt2x00pci.c |   25 ++++++++++++-
 drivers/net/wireless/rt2x00usb.c |   25 ++++++++++++-
 drivers/net/wireless/rt61pci.c   |   68 +++++++++++++++++---------------
 drivers/net/wireless/rt61pci.h   |    1 +
 drivers/net/wireless/rt73usb.c   |   78 +++++++++++++++++++++-----------------
 drivers/net/wireless/rt73usb.h   |    1 +
 14 files changed, 203 insertions(+), 134 deletions(-)

diff --git a/drivers/net/wireless/rt2400pci.c b/drivers/net/wireless/rt2400pci.c
index 46abf85..520c38c 100644
--- a/drivers/net/wireless/rt2400pci.c
+++ b/drivers/net/wireless/rt2400pci.c
@@ -137,7 +137,7 @@ static void rt2400pci_bbp_read(const struct rt2x00_dev *rt2x00dev,
 }
 
 static void rt2400pci_rf_write(const struct rt2x00_dev *rt2x00dev,
-	const u32 value)
+	const unsigned int word, const u32 value)
 {
 	u32 reg;
 	unsigned int i;
@@ -160,6 +160,7 @@ rf_write:
 	rt2x00_set_field32(&reg, RFCSR_BUSY, 1);
 
 	rt2x00pci_register_write(rt2x00dev, RFCSR, reg);
+	rt2x00_rf_write(rt2x00dev, word, value);
 }
 
 static void rt2400pci_eepromregister_read(struct eeprom_93cx6 *eeprom)
@@ -358,9 +359,9 @@ static void rt2400pci_config_channel(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg.rf1, RF1_TUNER, 1);
 	rt2x00_set_field32(&reg.rf3, RF3_TUNER, 1);
 
-	rt2400pci_rf_write(rt2x00dev, reg.rf1);
-	rt2400pci_rf_write(rt2x00dev, reg.rf2);
-	rt2400pci_rf_write(rt2x00dev, reg.rf3);
+	rt2400pci_rf_write(rt2x00dev, 1, reg.rf1);
+	rt2400pci_rf_write(rt2x00dev, 2, reg.rf2);
+	rt2400pci_rf_write(rt2x00dev, 3, reg.rf3);
 
 	/*
 	 * RF2420 chipset don't need any additional actions.
@@ -373,15 +374,15 @@ static void rt2400pci_config_channel(struct rt2x00_dev *rt2x00dev,
 	 * reference clock rate to activate auto_tune.
 	 * After that we set the value back to the correct channel.
 	 */
-	rt2400pci_rf_write(rt2x00dev, reg.rf1);
-	rt2400pci_rf_write(rt2x00dev, 0x000c2a32);
-	rt2400pci_rf_write(rt2x00dev, reg.rf3);
+	rt2400pci_rf_write(rt2x00dev, 1, reg.rf1);
+	rt2400pci_rf_write(rt2x00dev, 2, 0x000c2a32);
+	rt2400pci_rf_write(rt2x00dev, 3, reg.rf3);
 
 	msleep(1);
 
-	rt2400pci_rf_write(rt2x00dev, reg.rf1);
-	rt2400pci_rf_write(rt2x00dev, reg.rf2);
-	rt2400pci_rf_write(rt2x00dev, reg.rf3);
+	rt2400pci_rf_write(rt2x00dev, 1, reg.rf1);
+	rt2400pci_rf_write(rt2x00dev, 2, reg.rf2);
+	rt2400pci_rf_write(rt2x00dev, 3, reg.rf3);
 
 	msleep(1);
 
@@ -391,15 +392,8 @@ static void rt2400pci_config_channel(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg.rf1, RF1_TUNER, 0);
 	rt2x00_set_field32(&reg.rf3, RF3_TUNER, 0);
 
-	rt2400pci_rf_write(rt2x00dev, reg.rf1);
-	rt2400pci_rf_write(rt2x00dev, reg.rf3);
-
-	/*
-	 * Update rf fields
-	 */
-	rt2x00dev->rf1 = reg.rf1;
-	rt2x00dev->rf2 = reg.rf2;
-	rt2x00dev->rf3 = reg.rf3;
+	rt2400pci_rf_write(rt2x00dev, 1, reg.rf1);
+	rt2400pci_rf_write(rt2x00dev, 3, reg.rf3);
 
 	/*
 	 * Clear false CRC during channel switch.
@@ -1627,6 +1621,7 @@ static const struct rt2x00_ops rt2400pci_ops = {
 	.rxd_size	= RXD_DESC_SIZE,
 	.txd_size	= TXD_DESC_SIZE,
 	.eeprom_size	= EEPROM_SIZE,
+	.rf_size	= RF_SIZE,
 	.lib		= &rt2400pci_rt2x00_ops,
 	.hw		= &rt2400pci_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
diff --git a/drivers/net/wireless/rt2400pci.h b/drivers/net/wireless/rt2400pci.h
index f3382c1..54fd789 100644
--- a/drivers/net/wireless/rt2400pci.h
+++ b/drivers/net/wireless/rt2400pci.h
@@ -48,6 +48,7 @@
 #define EEPROM_BASE			0x0000
 #define EEPROM_SIZE			0x0100
 #define BBP_SIZE			0x0020
+#define RF_SIZE				0x0008
 
 /*
  * Control/Status Registers(CSR).
diff --git a/drivers/net/wireless/rt2500pci.c b/drivers/net/wireless/rt2500pci.c
index 46e11bf..f2ea9bf 100644
--- a/drivers/net/wireless/rt2500pci.c
+++ b/drivers/net/wireless/rt2500pci.c
@@ -137,7 +137,7 @@ static void rt2500pci_bbp_read(const struct rt2x00_dev *rt2x00dev,
 }
 
 static void rt2500pci_rf_write(const struct rt2x00_dev *rt2x00dev,
-	const u32 value)
+	const unsigned int word, const u32 value)
 {
 	u32 reg;
 	unsigned int i;
@@ -160,6 +160,7 @@ rf_write:
 	rt2x00_set_field32(&reg, RFCSR_BUSY, 1);
 
 	rt2x00pci_register_write(rt2x00dev, RFCSR, reg);
+	rt2x00_rf_write(rt2x00dev, word, value);
 }
 
 static void rt2500pci_eepromregister_read(struct eeprom_93cx6 *eeprom)
@@ -429,18 +430,18 @@ static void rt2500pci_config_channel(struct rt2x00_dev *rt2x00dev,
 			0x00080d2e, 0x00080d3a
 		};
 
-		rt2500pci_rf_write(rt2x00dev, reg.rf1);
-		rt2500pci_rf_write(rt2x00dev, vals[channel - 1]);
-		rt2500pci_rf_write(rt2x00dev, reg.rf3);
+		rt2500pci_rf_write(rt2x00dev, 1, reg.rf1);
+		rt2500pci_rf_write(rt2x00dev, 2, vals[channel - 1]);
+		rt2500pci_rf_write(rt2x00dev, 3, reg.rf3);
 		if (reg.rf4)
-			rt2500pci_rf_write(rt2x00dev, reg.rf4);
+			rt2500pci_rf_write(rt2x00dev, 4, reg.rf4);
 	}
 
-	rt2500pci_rf_write(rt2x00dev, reg.rf1);
-	rt2500pci_rf_write(rt2x00dev, reg.rf2);
-	rt2500pci_rf_write(rt2x00dev, reg.rf3);
+	rt2500pci_rf_write(rt2x00dev, 1, reg.rf1);
+	rt2500pci_rf_write(rt2x00dev, 2, reg.rf2);
+	rt2500pci_rf_write(rt2x00dev, 3, reg.rf3);
 	if (reg.rf4)
-		rt2500pci_rf_write(rt2x00dev, reg.rf4);
+		rt2500pci_rf_write(rt2x00dev, 4, reg.rf4);
 
 	/*
 	 * Channel 14 requires the Japan filter bit to be set.
@@ -457,19 +458,15 @@ static void rt2500pci_config_channel(struct rt2x00_dev *rt2x00dev,
 	 */
 	if (!rt2x00_rf(&rt2x00dev->chip, RF2523)) {
 		rt2x00_set_field32(&reg.rf1, RF1_TUNER, 0);
-		rt2500pci_rf_write(rt2x00dev, reg.rf1);
+		rt2500pci_rf_write(rt2x00dev, 1, reg.rf1);
 	}
 
 	rt2x00_set_field32(&reg.rf3, RF3_TUNER, 0);
-	rt2500pci_rf_write(rt2x00dev, reg.rf3);
+	rt2500pci_rf_write(rt2x00dev, 3, reg.rf3);
 
 	/*
-	 * Update rf fields
+	 * Update tx_power field
 	 */
-	rt2x00dev->rf1 = reg.rf1;
-	rt2x00dev->rf2 = reg.rf2;
-	rt2x00dev->rf3 = reg.rf3;
-	rt2x00dev->rf4 = reg.rf4;
 	rt2x00dev->tx_power = txpower;
 
 	/*
@@ -481,10 +478,11 @@ static void rt2500pci_config_channel(struct rt2x00_dev *rt2x00dev,
 static void rt2500pci_config_txpower(struct rt2x00_dev *rt2x00dev,
 	const int txpower)
 {
-	rt2x00_set_field32(&rt2x00dev->rf3, RF3_TXPOWER,
-		TXPOWER_TO_DEV(txpower));
-	rt2500pci_rf_write(rt2x00dev, rt2x00dev->rf3);
+	u32 rf3;
 
+	rt2x00_rf_read(rt2x00dev, 3, &rf3);
+	rt2x00_set_field32(&rf3, RF3_TXPOWER, TXPOWER_TO_DEV(txpower));
+	rt2500pci_rf_write(rt2x00dev, 3, rf3);
 }
 
 static void rt2500pci_config_antenna(struct rt2x00_dev *rt2x00dev,
@@ -1852,6 +1850,7 @@ static const struct rt2x00_ops rt2500pci_ops = {
 	.rxd_size	= RXD_DESC_SIZE,
 	.txd_size	= TXD_DESC_SIZE,
 	.eeprom_size	= EEPROM_SIZE,
+	.rf_size	= RF_SIZE,
 	.lib		= &rt2500pci_rt2x00_ops,
 	.hw		= &rt2500pci_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
diff --git a/drivers/net/wireless/rt2500pci.h b/drivers/net/wireless/rt2500pci.h
index 556f896..49c6792 100644
--- a/drivers/net/wireless/rt2500pci.h
+++ b/drivers/net/wireless/rt2500pci.h
@@ -59,6 +59,7 @@
 #define EEPROM_BASE			0x0000
 #define EEPROM_SIZE			0x0200
 #define BBP_SIZE			0x0040
+#define RF_SIZE				0x000c
 
 /*
  * Control/Status Registers(CSR).
diff --git a/drivers/net/wireless/rt2500usb.c b/drivers/net/wireless/rt2500usb.c
index 1ec3592..b9ae223 100644
--- a/drivers/net/wireless/rt2500usb.c
+++ b/drivers/net/wireless/rt2500usb.c
@@ -173,7 +173,7 @@ static void rt2500usb_bbp_read(const struct rt2x00_dev *rt2x00dev,
 }
 
 static void rt2500usb_rf_write(const struct rt2x00_dev *rt2x00dev,
-	const u32 value)
+	const unsigned int word, const u32 value)
 {
 	u16 reg;
 	unsigned int i;
@@ -200,6 +200,7 @@ rf_write:
 	rt2x00_set_field16(&reg, PHY_CSR10_RF_BUSY, 1);
 
 	rt2500usb_register_write(rt2x00dev, PHY_CSR10, reg);
+	rt2x00_rf_write(rt2x00dev, word, value);
 }
 
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
@@ -428,33 +429,31 @@ static void rt2500usb_config_channel(struct rt2x00_dev *rt2x00dev,
 			0x00000902, 0x00000906
 		};
 
-		rt2500usb_rf_write(rt2x00dev, vals[channel - 1]);
+		rt2500usb_rf_write(rt2x00dev, 2, vals[channel - 1]);
 		if (reg.rf4)
-			rt2500usb_rf_write(rt2x00dev, reg.rf4);
+			rt2500usb_rf_write(rt2x00dev, 4, reg.rf4);
 	}
 
-	rt2500usb_rf_write(rt2x00dev, reg.rf1);
-	rt2500usb_rf_write(rt2x00dev, reg.rf2);
-	rt2500usb_rf_write(rt2x00dev, reg.rf3);
+	rt2500usb_rf_write(rt2x00dev, 1, reg.rf1);
+	rt2500usb_rf_write(rt2x00dev, 2, reg.rf2);
+	rt2500usb_rf_write(rt2x00dev, 3, reg.rf3);
 	if (reg.rf4)
-		rt2500usb_rf_write(rt2x00dev, reg.rf4);
+		rt2500usb_rf_write(rt2x00dev, 4, reg.rf4);
 
 	/*
-	 * Update rf fields
+	 * Update tx_power field
 	 */
-	rt2x00dev->rf1 = reg.rf1;
-	rt2x00dev->rf2 = reg.rf2;
-	rt2x00dev->rf3 = reg.rf3;
-	rt2x00dev->rf4 = reg.rf4;
 	rt2x00dev->tx_power = txpower;
 }
 
 static void rt2500usb_config_txpower(struct rt2x00_dev *rt2x00dev,
 	const int txpower)
 {
-	rt2x00_set_field32(&rt2x00dev->rf3, RF3_TXPOWER,
-		TXPOWER_TO_DEV(txpower));
-	rt2500usb_rf_write(rt2x00dev, rt2x00dev->rf3);
+	u32 rf3;
+
+	rt2x00_rf_read(rt2x00dev, 3, &rf3);
+	rt2x00_set_field32(&rf3, RF3_TXPOWER, TXPOWER_TO_DEV(txpower));
+	rt2500usb_rf_write(rt2x00dev, 3, rf3);
 }
 
 static void rt2500usb_config_antenna(struct rt2x00_dev *rt2x00dev,
@@ -1516,6 +1515,7 @@ static const struct rt2x00_ops rt2500usb_ops = {
 	.rxd_size	= RXD_DESC_SIZE,
 	.txd_size	= TXD_DESC_SIZE,
 	.eeprom_size	= EEPROM_SIZE,
+	.rf_size	= RF_SIZE,
 	.lib		= &rt2500usb_rt2x00_ops,
 	.hw		= &rt2500usb_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
diff --git a/drivers/net/wireless/rt2500usb.h b/drivers/net/wireless/rt2500usb.h
index 88a20aa..425c804 100644
--- a/drivers/net/wireless/rt2500usb.h
+++ b/drivers/net/wireless/rt2500usb.h
@@ -59,6 +59,7 @@
 #define EEPROM_BASE			0x0000
 #define EEPROM_SIZE			0x006a
 #define BBP_SIZE			0x0060
+#define RF_SIZE				0x000c
 
 /*
  * Control/Status Registers(CSR).
diff --git a/drivers/net/wireless/rt2x00.h b/drivers/net/wireless/rt2x00.h
index 14aba76..bf80f51 100644
--- a/drivers/net/wireless/rt2x00.h
+++ b/drivers/net/wireless/rt2x00.h
@@ -733,6 +733,7 @@ struct rt2x00_ops {
 	const unsigned int rxd_size;
 	const unsigned int txd_size;
 	const unsigned int eeprom_size;
+	const unsigned int rf_size;
 	const struct rt2x00lib_ops *lib;
 	const struct ieee80211_ops *hw;
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
@@ -845,13 +846,13 @@ struct rt2x00_dev {
 
 	/*
 	 * Active RF register values.
-	 * These are stored here for easier working
-	 * with the rf registers.
+	 * These are stored here so we don't need
+	 * to read the rf registers and can directly
+	 * use this value instead.
+	 * This field should be accessed by using
+	 * rt2x00_rf_read() and rt2x00_rf_write().
 	 */
-	u32 rf1;
-	u32 rf2;
-	u32 rf3;
-	u32 rf4;
+	u32 *rf;
 
 	/*
 	 * Current TX power value.
@@ -954,11 +955,27 @@ static inline struct data_ring* rt2x00_get_ring(
 	ring_loop(__entry, (__dev)->tx, ring_end(__dev))
 
 /*
+ * RF access.
+ * The RF is being accessed by word index.
+ */
+static inline void rt2x00_rf_read(const struct rt2x00_dev *rt2x00dev,
+	const unsigned int word, u32 *data)
+{
+	*data = rt2x00dev->rf[word - 1];
+}
+
+static inline void rt2x00_rf_write(const struct rt2x00_dev *rt2x00dev,
+	const unsigned int word, u32 data)
+{
+	rt2x00dev->rf[word] = data;
+}
+
+/*
  * EEPROM access.
  * The EEPROM is being accessed by word index.
  */
 static inline void* rt2x00_eeprom_addr(const struct rt2x00_dev *rt2x00dev,
-	const u8 word)
+	const unsigned int word)
 {
 	return (void*)&rt2x00dev->eeprom[word];
 }
diff --git a/drivers/net/wireless/rt2x00dev.c b/drivers/net/wireless/rt2x00dev.c
index 5c45f63..3ab1738 100644
--- a/drivers/net/wireless/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00dev.c
@@ -169,11 +169,6 @@ void rt2x00lib_config_channel(struct rt2x00_dev *rt2x00dev, const int value,
 	rt2x00dev->ops->lib->config_channel(rt2x00dev, value, channel, txpower);
 	rt2x00dev->ops->lib->reset_tuner(rt2x00dev);
 
-	INFO(rt2x00dev, "Switching channel. "
-		"RF1: 0x%08x, RF2: 0x%08x, RF3: 0x%08x, RF3: 0x%08x.\n",
-		rt2x00dev->rf1, rt2x00dev->rf2,
-		rt2x00dev->rf3, rt2x00dev->rf4);
-
 	rt2x00dev->rx_status.freq = freq;
 	rt2x00dev->rx_status.channel = channel;
 }
diff --git a/drivers/net/wireless/rt2x00pci.c b/drivers/net/wireless/rt2x00pci.c
index 8d7d9dc..80e2204 100644
--- a/drivers/net/wireless/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00pci.c
@@ -327,6 +327,21 @@ static void rt2x00pci_free_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->eeprom = NULL;
 }
 
+static int rt2x00pci_alloc_rf(struct rt2x00_dev *rt2x00dev)
+{
+	rt2x00dev->rf = kzalloc(4 * sizeof(u32), GFP_KERNEL);
+	if (!rt2x00dev->rf)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void rt2x00pci_free_rf(struct rt2x00_dev *rt2x00dev)
+{
+	kfree(rt2x00dev->rf);
+	rt2x00dev->rf = NULL;
+}
+
 int rt2x00pci_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 {
 	struct rt2x00_ops *ops = (struct rt2x00_ops*)id->driver_data;
@@ -380,12 +395,19 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 	if (retval)
 		goto exit_free_csr;
 
-	retval = rt2x00lib_probe_dev(rt2x00dev);
+	retval = rt2x00pci_alloc_rf(rt2x00dev);
 	if (retval)
 		goto exit_free_eeprom;
 
+	retval = rt2x00lib_probe_dev(rt2x00dev);
+	if (retval)
+		goto exit_free_rf;
+
 	return 0;
 
+exit_free_rf:
+	rt2x00pci_free_rf(rt2x00dev);
+
 exit_free_eeprom:
 	rt2x00pci_free_eeprom(rt2x00dev);
 
@@ -417,6 +439,7 @@ void rt2x00pci_remove(struct pci_dev *pci_dev)
 	 * Free all allocated data.
 	 */
 	rt2x00lib_remove_dev(rt2x00dev);
+	rt2x00pci_free_rf(rt2x00dev);
 	rt2x00pci_free_eeprom(rt2x00dev);
 	rt2x00pci_free_csr(rt2x00dev);
 	ieee80211_free_hw(hw);
diff --git a/drivers/net/wireless/rt2x00usb.c b/drivers/net/wireless/rt2x00usb.c
index 0fb2f04..39f178a 100644
--- a/drivers/net/wireless/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00usb.c
@@ -511,6 +511,21 @@ static void rt2x00usb_free_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->eeprom = NULL;
 }
 
+static int rt2x00usb_alloc_rf(struct rt2x00_dev *rt2x00dev)
+{
+	rt2x00dev->rf = kzalloc(rt2x00dev->ops->rf_size, GFP_KERNEL);
+	if (!rt2x00dev->rf)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void rt2x00usb_free_rf(struct rt2x00_dev *rt2x00dev)
+{
+	kfree(rt2x00dev->rf);
+	rt2x00dev->rf = NULL;
+}
+
 int rt2x00usb_probe(struct usb_interface *usb_intf,
 	const struct usb_device_id *id)
 {
@@ -540,12 +555,19 @@ int rt2x00usb_probe(struct usb_interface *usb_intf,
 	if (retval)
 		goto exit_free_device;
 
-	retval = rt2x00lib_probe_dev(rt2x00dev);
+	retval = rt2x00usb_alloc_rf(rt2x00dev);
 	if (retval)
 		goto exit_free_eeprom;
 
+	retval = rt2x00lib_probe_dev(rt2x00dev);
+	if (retval)
+		goto exit_free_rf;
+
 	return 0;
 
+exit_free_rf:
+	rt2x00usb_free_rf(rt2x00dev);
+
 exit_free_eeprom:
 	rt2x00usb_free_eeprom(rt2x00dev);
 
@@ -570,6 +592,7 @@ void rt2x00usb_disconnect(struct usb_interface *usb_intf)
 	 * Free all allocated data.
 	 */
 	rt2x00lib_remove_dev(rt2x00dev);
+	rt2x00usb_free_rf(rt2x00dev);
 	rt2x00usb_free_eeprom(rt2x00dev);
 	ieee80211_free_hw(hw);
 
diff --git a/drivers/net/wireless/rt61pci.c b/drivers/net/wireless/rt61pci.c
index 326112d..3059b45 100644
--- a/drivers/net/wireless/rt61pci.c
+++ b/drivers/net/wireless/rt61pci.c
@@ -135,7 +135,7 @@ static void rt61pci_bbp_read(const struct rt2x00_dev *rt2x00dev,
 }
 
 static void rt61pci_rf_write(const struct rt2x00_dev *rt2x00dev,
-	const u32 value)
+	const unsigned int word, const u32 value)
 {
 	u32 reg;
 	unsigned int i;
@@ -158,6 +158,7 @@ rf_write:
 	rt2x00_set_field32(&reg, PHY_CSR4_BUSY, 1);
 
 	rt2x00pci_register_write(rt2x00dev, PHY_CSR4, reg);
+	rt2x00_rf_write(rt2x00dev, word, value);
 }
 
 static void rt61pci_mcu_request(const struct rt2x00_dev *rt2x00dev,
@@ -550,24 +551,24 @@ static void rt61pci_config_channel(struct rt2x00_dev *rt2x00dev,
 	 */
 	rt2x00_set_field32(&reg.rf4, RF4_FREQ_OFFSET, rt2x00dev->freq_offset);
 
-	rt61pci_rf_write(rt2x00dev, reg.rf1);
-	rt61pci_rf_write(rt2x00dev, reg.rf2);
-	rt61pci_rf_write(rt2x00dev, reg.rf3 & ~0x00000004);
-	rt61pci_rf_write(rt2x00dev, reg.rf4);
+	rt61pci_rf_write(rt2x00dev, 1, reg.rf1);
+	rt61pci_rf_write(rt2x00dev, 2, reg.rf2);
+	rt61pci_rf_write(rt2x00dev, 3, reg.rf3 & ~0x00000004);
+	rt61pci_rf_write(rt2x00dev, 4, reg.rf4);
 
 	udelay(200);
 
-	rt61pci_rf_write(rt2x00dev, reg.rf1);
-	rt61pci_rf_write(rt2x00dev, reg.rf2);
-	rt61pci_rf_write(rt2x00dev, reg.rf3 | 0x00000004);
-	rt61pci_rf_write(rt2x00dev, reg.rf4);
+	rt61pci_rf_write(rt2x00dev, 1, reg.rf1);
+	rt61pci_rf_write(rt2x00dev, 2, reg.rf2);
+	rt61pci_rf_write(rt2x00dev, 3, reg.rf3 | 0x00000004);
+	rt61pci_rf_write(rt2x00dev, 4, reg.rf4);
 
 	udelay(200);
 
-	rt61pci_rf_write(rt2x00dev, reg.rf1);
-	rt61pci_rf_write(rt2x00dev, reg.rf2);
-	rt61pci_rf_write(rt2x00dev, reg.rf3 & ~0x00000004);
-	rt61pci_rf_write(rt2x00dev, reg.rf4);
+	rt61pci_rf_write(rt2x00dev, 1, reg.rf1);
+	rt61pci_rf_write(rt2x00dev, 2, reg.rf2);
+	rt61pci_rf_write(rt2x00dev, 3, reg.rf3 & ~0x00000004);
+	rt61pci_rf_write(rt2x00dev, 4, reg.rf4);
 
 	rt61pci_bbp_read(rt2x00dev, 3, &bbp);
 	if (rt2x00_rf(&rt2x00dev->chip, RF5225) ||
@@ -580,39 +581,41 @@ static void rt61pci_config_channel(struct rt2x00_dev *rt2x00dev,
 	msleep(1);
 
 	/*
-	 * Update rf fields
+	 * Update tx_power field
 	 */
-	rt2x00dev->rf1 = reg.rf1;
-	rt2x00dev->rf2 = reg.rf2;
-	rt2x00dev->rf3 = reg.rf3;
-	rt2x00dev->rf4 = reg.rf4;
 	rt2x00dev->tx_power = txpower;
 }
 
 static void rt61pci_config_txpower(struct rt2x00_dev *rt2x00dev,
 	const int txpower)
 {
-	rt2x00_set_field32(&rt2x00dev->rf3, RF3_TXPOWER,
-		TXPOWER_TO_DEV(txpower));
+	struct rf_reg rf;
 
-	rt61pci_rf_write(rt2x00dev, rt2x00dev->rf1);
-	rt61pci_rf_write(rt2x00dev, rt2x00dev->rf2);
-	rt61pci_rf_write(rt2x00dev, rt2x00dev->rf3 & ~0x00000004);
-	rt61pci_rf_write(rt2x00dev, rt2x00dev->rf4);
+	rt2x00_rf_read(rt2x00dev, 1, &rf.rf1);
+	rt2x00_rf_read(rt2x00dev, 2, &rf.rf2);
+	rt2x00_rf_read(rt2x00dev, 3, &rf.rf3);
+	rt2x00_rf_read(rt2x00dev, 4, &rf.rf4);
+
+	rt2x00_set_field32(&rf.rf3, RF3_TXPOWER, TXPOWER_TO_DEV(txpower));
+
+	rt61pci_rf_write(rt2x00dev, 1, rf.rf1);
+	rt61pci_rf_write(rt2x00dev, 2, rf.rf2);
+	rt61pci_rf_write(rt2x00dev, 3, rf.rf3 & ~0x00000004);
+	rt61pci_rf_write(rt2x00dev, 4, rf.rf4);
 
 	udelay(200);
 
-	rt61pci_rf_write(rt2x00dev, rt2x00dev->rf1);
-	rt61pci_rf_write(rt2x00dev, rt2x00dev->rf2);
-	rt61pci_rf_write(rt2x00dev, rt2x00dev->rf3 | 0x00000004);
-	rt61pci_rf_write(rt2x00dev, rt2x00dev->rf4);
+	rt61pci_rf_write(rt2x00dev, 1, rf.rf1);
+	rt61pci_rf_write(rt2x00dev, 2, rf.rf2);
+	rt61pci_rf_write(rt2x00dev, 3, rf.rf3 | 0x00000004);
+	rt61pci_rf_write(rt2x00dev, 4, rf.rf4);
 
 	udelay(200);
 
-	rt61pci_rf_write(rt2x00dev, rt2x00dev->rf1);
-	rt61pci_rf_write(rt2x00dev, rt2x00dev->rf2);
-	rt61pci_rf_write(rt2x00dev, rt2x00dev->rf3 & ~0x00000004);
-	rt61pci_rf_write(rt2x00dev, rt2x00dev->rf4);
+	rt61pci_rf_write(rt2x00dev, 1, rf.rf1);
+	rt61pci_rf_write(rt2x00dev, 2, rf.rf2);
+	rt61pci_rf_write(rt2x00dev, 3, rf.rf3 & ~0x00000004);
+	rt61pci_rf_write(rt2x00dev, 4, rf.rf4);
 }
 
 static void rt61pci_config_antenna(struct rt2x00_dev *rt2x00dev,
@@ -2352,6 +2355,7 @@ static const struct rt2x00_ops rt61pci_ops = {
 	.rxd_size	= RXD_DESC_SIZE,
 	.txd_size	= TXD_DESC_SIZE,
 	.eeprom_size	= EEPROM_SIZE,
+	.rf_size	= RF_SIZE,
 	.lib		= &rt61pci_rt2x00_ops,
 	.hw		= &rt61pci_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
diff --git a/drivers/net/wireless/rt61pci.h b/drivers/net/wireless/rt61pci.h
index 1286391..ed450e7 100644
--- a/drivers/net/wireless/rt61pci.h
+++ b/drivers/net/wireless/rt61pci.h
@@ -50,6 +50,7 @@
 #define EEPROM_BASE			0x0000
 #define EEPROM_SIZE			0x0100
 #define BBP_SIZE			0x0080
+#define RF_SIZE				0x000c
 
 /*
  * PCI registers.
diff --git a/drivers/net/wireless/rt73usb.c b/drivers/net/wireless/rt73usb.c
index 5cd7953..6a7b1f9 100644
--- a/drivers/net/wireless/rt73usb.c
+++ b/drivers/net/wireless/rt73usb.c
@@ -174,7 +174,7 @@ static void rt73usb_bbp_read(const struct rt2x00_dev *rt2x00dev,
 }
 
 static void rt73usb_rf_write(const struct rt2x00_dev *rt2x00dev,
-	const u32 value)
+	const unsigned int word, const u32 value)
 {
 	u32 reg;
 	unsigned int i;
@@ -197,6 +197,7 @@ rf_write:
 	rt2x00_set_field32(&reg, PHY_CSR4_BUSY, 1);
 
 	rt73usb_register_write(rt2x00dev, PHY_CSR4, reg);
+	rt2x00_rf_write(rt2x00dev, word, value);
 }
 
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
@@ -457,53 +458,59 @@ static void rt73usb_config_channel(struct rt2x00_dev *rt2x00dev,
 		bbp |= 0x01;
 	rt73usb_bbp_write(rt2x00dev, 3, bbp);
 
-	rt73usb_rf_write(rt2x00dev, reg.rf1);
-	rt73usb_rf_write(rt2x00dev, reg.rf2);
-	rt73usb_rf_write(rt2x00dev, reg.rf3 & ~0x00000004);
-	rt73usb_rf_write(rt2x00dev, reg.rf4);
+	rt73usb_rf_write(rt2x00dev, 1, reg.rf1);
+	rt73usb_rf_write(rt2x00dev, 2, reg.rf2);
+	rt73usb_rf_write(rt2x00dev, 3, reg.rf3 & ~0x00000004);
+	rt73usb_rf_write(rt2x00dev, 4, reg.rf4);
 
-	rt73usb_rf_write(rt2x00dev, reg.rf1);
-	rt73usb_rf_write(rt2x00dev, reg.rf2);
-	rt73usb_rf_write(rt2x00dev, reg.rf3 | 0x00000004);
-	rt73usb_rf_write(rt2x00dev, reg.rf4);
+	rt73usb_rf_write(rt2x00dev, 1, reg.rf1);
+	rt73usb_rf_write(rt2x00dev, 2, reg.rf2);
+	rt73usb_rf_write(rt2x00dev, 3, reg.rf3 | 0x00000004);
+	rt73usb_rf_write(rt2x00dev, 4, reg.rf4);
 
-	rt73usb_rf_write(rt2x00dev, reg.rf1);
-	rt73usb_rf_write(rt2x00dev, reg.rf2);
-	rt73usb_rf_write(rt2x00dev, reg.rf3 & ~0x00000004);
-	rt73usb_rf_write(rt2x00dev, reg.rf4);
+	rt73usb_rf_write(rt2x00dev, 1, reg.rf1);
+	rt73usb_rf_write(rt2x00dev, 2, reg.rf2);
+	rt73usb_rf_write(rt2x00dev, 3, reg.rf3 & ~0x00000004);
+	rt73usb_rf_write(rt2x00dev, 4, reg.rf4);
 
 	msleep(1);
 
 	/*
-	 * Update rf fields
+	 * Update tx_power field
 	 */
-	rt2x00dev->rf1 = reg.rf1;
-	rt2x00dev->rf2 = reg.rf2;
-	rt2x00dev->rf3 = reg.rf3;
-	rt2x00dev->rf4 = reg.rf4;
 	rt2x00dev->tx_power = txpower;
 }
 
 static void rt73usb_config_txpower(struct rt2x00_dev *rt2x00dev,
 	const int txpower)
 {
-	rt2x00_set_field32(&rt2x00dev->rf3, RF3_TXPOWER,
-		TXPOWER_TO_DEV(txpower));
-
-	rt73usb_rf_write(rt2x00dev, rt2x00dev->rf1);
-	rt73usb_rf_write(rt2x00dev, rt2x00dev->rf2);
-	rt73usb_rf_write(rt2x00dev, rt2x00dev->rf3 & ~0x00000004);
-	rt73usb_rf_write(rt2x00dev, rt2x00dev->rf4);
-
-	rt73usb_rf_write(rt2x00dev, rt2x00dev->rf1);
-	rt73usb_rf_write(rt2x00dev, rt2x00dev->rf2);
-	rt73usb_rf_write(rt2x00dev, rt2x00dev->rf3 | 0x00000004);
-	rt73usb_rf_write(rt2x00dev, rt2x00dev->rf4);
-
-	rt73usb_rf_write(rt2x00dev, rt2x00dev->rf1);
-	rt73usb_rf_write(rt2x00dev, rt2x00dev->rf2);
-	rt73usb_rf_write(rt2x00dev, rt2x00dev->rf3 & ~0x00000004);
-	rt73usb_rf_write(rt2x00dev, rt2x00dev->rf4);
+	struct rf_reg rf;
+
+	rt2x00_rf_read(rt2x00dev, 1, &rf.rf1);
+	rt2x00_rf_read(rt2x00dev, 2, &rf.rf2);
+	rt2x00_rf_read(rt2x00dev, 3, &rf.rf3);
+	rt2x00_rf_read(rt2x00dev, 4, &rf.rf4);
+
+	rt2x00_set_field32(&rf.rf3, RF3_TXPOWER, TXPOWER_TO_DEV(txpower));
+
+	rt73usb_rf_write(rt2x00dev, 1, rf.rf1);
+	rt73usb_rf_write(rt2x00dev, 2, rf.rf2);
+	rt73usb_rf_write(rt2x00dev, 3, rf.rf3 & ~0x00000004);
+	rt73usb_rf_write(rt2x00dev, 4, rf.rf4);
+
+	udelay(200);
+
+	rt73usb_rf_write(rt2x00dev, 1, rf.rf1);
+	rt73usb_rf_write(rt2x00dev, 2, rf.rf2);
+	rt73usb_rf_write(rt2x00dev, 3, rf.rf3 | 0x00000004);
+	rt73usb_rf_write(rt2x00dev, 4, rf.rf4);
+
+	udelay(200);
+
+	rt73usb_rf_write(rt2x00dev, 1, rf.rf1);
+	rt73usb_rf_write(rt2x00dev, 2, rf.rf2);
+	rt73usb_rf_write(rt2x00dev, 3, rf.rf3 & ~0x00000004);
+	rt73usb_rf_write(rt2x00dev, 4, rf.rf4);
 }
 
 static void rt73usb_config_antenna(struct rt2x00_dev *rt2x00dev,
@@ -1814,6 +1821,7 @@ static const struct rt2x00_ops rt73usb_ops = {
 	.rxd_size	= RXD_DESC_SIZE,
 	.txd_size	= TXD_DESC_SIZE,
 	.eeprom_size	= EEPROM_SIZE,
+	.rf_size	= RF_SIZE,
 	.lib		= &rt73usb_rt2x00_ops,
 	.hw		= &rt73usb_mac80211_ops,
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
diff --git a/drivers/net/wireless/rt73usb.h b/drivers/net/wireless/rt73usb.h
index 09dd708..276fa3f 100644
--- a/drivers/net/wireless/rt73usb.h
+++ b/drivers/net/wireless/rt73usb.h
@@ -50,6 +50,7 @@
 #define EEPROM_BASE			0x0000
 #define EEPROM_SIZE			0x0100
 #define BBP_SIZE			0x0080
+#define RF_SIZE				0x000c
 
 /*
  * USB registers.
-- 
1.5.2.4

