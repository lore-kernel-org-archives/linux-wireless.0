Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:35258 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759465AbZC1Tww (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2009 15:52:52 -0400
Received: by ewy9 with SMTP id 9so1517407ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 28 Mar 2009 12:52:48 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/4] rt2x00: Move Move pci_dev specific access to rt2x00pci
Date: Sat, 28 Mar 2009 20:51:24 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903282051.25112.IvDoorn@gmail.com> (sfid-20090328_205306_067606_2D7F0614)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pci_dev->irq and pci_name(pci_dev) access should be limited
to rt2x00pci only. This is more generic and allows a rt2x00 pci
driver to be controlled as PCI device but also as platform driver
(needed for rt2800pci SoC support).

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt2500pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt2x00.h    |   18 ++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00pci.c |   16 ++++++++++++----
 drivers/net/wireless/rt2x00/rt61pci.c   |    7 +------
 drivers/net/wireless/rt2x00/rt61pci.h   |    6 ------
 6 files changed, 33 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 0f08773..411eb9c 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1361,7 +1361,7 @@ static int rt2400pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	 */
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
 	rt2x00pci_register_read(rt2x00dev, CSR0, &reg);
-	rt2x00_set_chip(rt2x00dev, RT2460, value, reg);
+	rt2x00_set_chip_rf(rt2x00dev, value, reg);
 
 	if (!rt2x00_rf(&rt2x00dev->chip, RF2420) &&
 	    !rt2x00_rf(&rt2x00dev->chip, RF2421)) {
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 276a823..e1be67c 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1525,7 +1525,7 @@ static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	 */
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
 	rt2x00pci_register_read(rt2x00dev, CSR0, &reg);
-	rt2x00_set_chip(rt2x00dev, RT2560, value, reg);
+	rt2x00_set_chip_rf(rt2x00dev, value, reg);
 
 	if (!rt2x00_rf(&rt2x00dev->chip, RF2522) &&
 	    !rt2x00_rf(&rt2x00dev->chip, RF2523) &&
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 84bd6f1..e03d699 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -672,6 +672,12 @@ struct rt2x00_dev {
 	unsigned long flags;
 
 	/*
+	 * Device information, Bus IRQ and name (PCI, SoC)
+	 */
+	int irq;
+	const char *name;
+
+	/*
 	 * Chipset identification.
 	 */
 	struct rt2x00_chip chip;
@@ -860,6 +866,18 @@ static inline void rt2x00_set_chip(struct rt2x00_dev *rt2x00dev,
 	rt2x00dev->chip.rev = rev;
 }
 
+static inline void rt2x00_set_chip_rt(struct rt2x00_dev *rt2x00dev,
+				      const u16 rt)
+{
+	rt2x00dev->chip.rt = rt;
+}
+
+static inline void rt2x00_set_chip_rf(struct rt2x00_dev *rt2x00dev,
+				      const u16 rf, const u32 rev)
+{
+	rt2x00_set_chip(rt2x00dev, rt2x00dev->chip.rt, rf, rev);
+}
+
 static inline char rt2x00_rt(const struct rt2x00_chip *chipset, const u16 chip)
 {
 	return (chipset->rt == chip);
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index e616c20..eef2761 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -170,7 +170,6 @@ static void rt2x00pci_free_queue_dma(struct rt2x00_dev *rt2x00dev,
 
 int rt2x00pci_initialize(struct rt2x00_dev *rt2x00dev)
 {
-	struct pci_dev *pci_dev = to_pci_dev(rt2x00dev->dev);
 	struct data_queue *queue;
 	int status;
 
@@ -186,11 +185,11 @@ int rt2x00pci_initialize(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Register interrupt handler.
 	 */
-	status = request_irq(pci_dev->irq, rt2x00dev->ops->lib->irq_handler,
-			     IRQF_SHARED, pci_name(pci_dev), rt2x00dev);
+	status = request_irq(rt2x00dev->irq, rt2x00dev->ops->lib->irq_handler,
+			     IRQF_SHARED, rt2x00dev->name, rt2x00dev);
 	if (status) {
 		ERROR(rt2x00dev, "IRQ %d allocation failed (error %d).\n",
-		      pci_dev->irq, status);
+		      rt2x00dev->irq, status);
 		goto exit;
 	}
 
@@ -270,6 +269,7 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 	struct ieee80211_hw *hw;
 	struct rt2x00_dev *rt2x00dev;
 	int retval;
+	u16 chip;
 
 	retval = pci_request_regions(pci_dev, pci_name(pci_dev));
 	if (retval) {
@@ -307,6 +307,14 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 	rt2x00dev->dev = &pci_dev->dev;
 	rt2x00dev->ops = ops;
 	rt2x00dev->hw = hw;
+	rt2x00dev->irq = pci_dev->irq;
+	rt2x00dev->name = pci_name(pci_dev);
+
+	/*
+	 * Determine RT chipset by reading PCI header.
+	 */
+	pci_read_config_word(pci_dev, PCI_DEVICE_ID, &chip);
+	rt2x00_set_chip_rt(rt2x00dev, chip);
 
 	retval = rt2x00pci_alloc_reg(rt2x00dev);
 	if (retval)
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 2ca8b7a..4346cd1 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2308,7 +2308,6 @@ static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	u32 reg;
 	u16 value;
 	u16 eeprom;
-	u16 device;
 
 	/*
 	 * Read EEPROM word for configuration.
@@ -2317,14 +2316,10 @@ static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 
 	/*
 	 * Identify RF chipset.
-	 * To determine the RT chip we have to read the
-	 * PCI header of the device.
 	 */
-	pci_read_config_word(to_pci_dev(rt2x00dev->dev),
-			     PCI_CONFIG_HEADER_DEVICE, &device);
 	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
 	rt2x00pci_register_read(rt2x00dev, MAC_CSR0, &reg);
-	rt2x00_set_chip(rt2x00dev, device, value, reg);
+	rt2x00_set_chip_rf(rt2x00dev, value, reg);
 
 	if (!rt2x00_rf(&rt2x00dev->chip, RF5225) &&
 	    !rt2x00_rf(&rt2x00dev->chip, RF5325) &&
diff --git a/drivers/net/wireless/rt2x00/rt61pci.h b/drivers/net/wireless/rt2x00/rt61pci.h
index 41e8959..6c71f77 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/rt2x00/rt61pci.h
@@ -63,12 +63,6 @@
  */
 
 /*
- * PCI Configuration Header
- */
-#define PCI_CONFIG_HEADER_VENDOR	0x0000
-#define PCI_CONFIG_HEADER_DEVICE	0x0002
-
-/*
  * HOST_CMD_CSR: For HOST to interrupt embedded processor
  */
 #define HOST_CMD_CSR			0x0008
-- 
1.5.6.1

