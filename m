Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:57272 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268Ab2L2Nv7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Dec 2012 08:51:59 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2] rt2x00: rt2800: convert read_eeprom functions to return an int value
Date: Sat, 29 Dec 2012 14:51:51 +0100
Message-Id: <1356789111-14768-1-git-send-email-juhosg@openwrt.org> (sfid-20121229_145204_352911_20E5215A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both the rtt2x00usb_eeprom_read and the ioremap
functions are allowed to fail, however their
return values are not checked in the read_eeprom
functions in the rt2800{pci,usb} drivers.

The patch adds the missing checks, and converts
all read_eeprom functions to return an int value,
so the error values can be propagated up to the
'rt2800_validate_eeprom' function.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
v2:
  - change subject (was rt2x00: rt2800pci: verify ioremap return value)
  - add missing return call to rt2800pci_read_eeprom_soc
  - convert all related functions to return an int value
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    9 ++++++--
 drivers/net/wireless/rt2x00/rt2800lib.h |    8 +++----
 drivers/net/wireless/rt2x00/rt2800pci.c |   35 +++++++++++++++++++++----------
 drivers/net/wireless/rt2x00/rt2800usb.c |   12 +++++++----
 4 files changed, 43 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 197b446..f273840 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4620,12 +4620,14 @@ static void rt2800_efuse_read(struct rt2x00_dev *rt2x00dev, unsigned int i)
 	mutex_unlock(&rt2x00dev->csr_mutex);
 }
 
-void rt2800_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev)
+int rt2800_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev)
 {
 	unsigned int i;
 
 	for (i = 0; i < EEPROM_SIZE / sizeof(u16); i += 8)
 		rt2800_efuse_read(rt2x00dev, i);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2800_read_eeprom_efuse);
 
@@ -4635,11 +4637,14 @@ static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	u16 word;
 	u8 *mac;
 	u8 default_lna_gain;
+	int retval;
 
 	/*
 	 * Read the EEPROM.
 	 */
-	rt2800_read_eeprom(rt2x00dev);
+	retval = rt2800_read_eeprom(rt2x00dev);
+	if (retval)
+		return retval;
 
 	/*
 	 * Start validation of the data that has been read.
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index a128cea..6ec7394 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -43,7 +43,7 @@ struct rt2800_ops {
 			    const unsigned int offset,
 			    const struct rt2x00_field32 field, u32 *reg);
 
-	void (*read_eeprom)(struct rt2x00_dev *rt2x00dev);
+	int (*read_eeprom)(struct rt2x00_dev *rt2x00dev);
 	bool (*hwcrypt_disabled)(struct rt2x00_dev *rt2x00dev);
 
 	int (*drv_write_firmware)(struct rt2x00_dev *rt2x00dev,
@@ -117,11 +117,11 @@ static inline int rt2800_regbusy_read(struct rt2x00_dev *rt2x00dev,
 	return rt2800ops->regbusy_read(rt2x00dev, offset, field, reg);
 }
 
-static inline void rt2800_read_eeprom(struct rt2x00_dev *rt2x00dev)
+static inline int rt2800_read_eeprom(struct rt2x00_dev *rt2x00dev)
 {
 	const struct rt2800_ops *rt2800ops = rt2x00dev->ops->drv;
 
-	rt2800ops->read_eeprom(rt2x00dev);
+	return rt2800ops->read_eeprom(rt2x00dev);
 }
 
 static inline bool rt2800_hwcrypt_disabled(struct rt2x00_dev *rt2x00dev)
@@ -207,7 +207,7 @@ int rt2800_enable_radio(struct rt2x00_dev *rt2x00dev);
 void rt2800_disable_radio(struct rt2x00_dev *rt2x00dev);
 
 int rt2800_efuse_detect(struct rt2x00_dev *rt2x00dev);
-void rt2800_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev);
+int rt2800_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev);
 
 int rt2800_probe_hw(struct rt2x00_dev *rt2x00dev);
 
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 9224d87..0e8d170 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -90,17 +90,22 @@ static void rt2800pci_mcu_status(struct rt2x00_dev *rt2x00dev, const u8 token)
 }
 
 #if defined(CONFIG_RALINK_RT288X) || defined(CONFIG_RALINK_RT305X)
-static void rt2800pci_read_eeprom_soc(struct rt2x00_dev *rt2x00dev)
+static int rt2800pci_read_eeprom_soc(struct rt2x00_dev *rt2x00dev)
 {
 	void __iomem *base_addr = ioremap(0x1F040000, EEPROM_SIZE);
 
+	if (!base_addr)
+		return -ENOMEM;
+
 	memcpy_fromio(rt2x00dev->eeprom, base_addr, EEPROM_SIZE);
 
 	iounmap(base_addr);
+	return 0;
 }
 #else
-static inline void rt2800pci_read_eeprom_soc(struct rt2x00_dev *rt2x00dev)
+static inline int rt2800pci_read_eeprom_soc(struct rt2x00_dev *rt2x00dev)
 {
+	return -ENOMEM;
 }
 #endif /* CONFIG_RALINK_RT288X || CONFIG_RALINK_RT305X */
 
@@ -135,7 +140,7 @@ static void rt2800pci_eepromregister_write(struct eeprom_93cx6 *eeprom)
 	rt2x00pci_register_write(rt2x00dev, E2PROM_CSR, reg);
 }
 
-static void rt2800pci_read_eeprom_pci(struct rt2x00_dev *rt2x00dev)
+static int rt2800pci_read_eeprom_pci(struct rt2x00_dev *rt2x00dev)
 {
 	struct eeprom_93cx6 eeprom;
 	u32 reg;
@@ -164,6 +169,8 @@ static void rt2800pci_read_eeprom_pci(struct rt2x00_dev *rt2x00dev)
 
 	eeprom_93cx6_multiread(&eeprom, EEPROM_BASE, rt2x00dev->eeprom,
 			       EEPROM_SIZE / sizeof(u16));
+
+	return 0;
 }
 
 static int rt2800pci_efuse_detect(struct rt2x00_dev *rt2x00dev)
@@ -171,13 +178,14 @@ static int rt2800pci_efuse_detect(struct rt2x00_dev *rt2x00dev)
 	return rt2800_efuse_detect(rt2x00dev);
 }
 
-static inline void rt2800pci_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev)
+static inline int rt2800pci_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev)
 {
-	rt2800_read_eeprom_efuse(rt2x00dev);
+	return rt2800_read_eeprom_efuse(rt2x00dev);
 }
 #else
-static inline void rt2800pci_read_eeprom_pci(struct rt2x00_dev *rt2x00dev)
+static inline int rt2800pci_read_eeprom_pci(struct rt2x00_dev *rt2x00dev)
 {
+	return -EOPNOTSUPP;
 }
 
 static inline int rt2800pci_efuse_detect(struct rt2x00_dev *rt2x00dev)
@@ -185,8 +193,9 @@ static inline int rt2800pci_efuse_detect(struct rt2x00_dev *rt2x00dev)
 	return 0;
 }
 
-static inline void rt2800pci_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev)
+static inline int rt2800pci_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev)
 {
+	return -EOPNOTSUPP;
 }
 #endif /* CONFIG_PCI */
 
@@ -970,14 +979,18 @@ static irqreturn_t rt2800pci_interrupt(int irq, void *dev_instance)
 /*
  * Device probe functions.
  */
-static void rt2800pci_read_eeprom(struct rt2x00_dev *rt2x00dev)
+static int rt2800pci_read_eeprom(struct rt2x00_dev *rt2x00dev)
 {
+	int retval;
+
 	if (rt2x00_is_soc(rt2x00dev))
-		rt2800pci_read_eeprom_soc(rt2x00dev);
+		retval = rt2800pci_read_eeprom_soc(rt2x00dev);
 	else if (rt2800pci_efuse_detect(rt2x00dev))
-		rt2800pci_read_eeprom_efuse(rt2x00dev);
+		retval = rt2800pci_read_eeprom_efuse(rt2x00dev);
 	else
-		rt2800pci_read_eeprom_pci(rt2x00dev);
+		retval = rt2800pci_read_eeprom_pci(rt2x00dev);
+
+	return retval;
 }
 
 static const struct ieee80211_ops rt2800pci_mac80211_ops = {
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 5c149b5..4721cad 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -735,13 +735,17 @@ static void rt2800usb_fill_rxdone(struct queue_entry *entry,
 /*
  * Device probe functions.
  */
-static void rt2800usb_read_eeprom(struct rt2x00_dev *rt2x00dev)
+static int rt2800usb_read_eeprom(struct rt2x00_dev *rt2x00dev)
 {
+	int retval;
+
 	if (rt2800_efuse_detect(rt2x00dev))
-		rt2800_read_eeprom_efuse(rt2x00dev);
+		retval = rt2800_read_eeprom_efuse(rt2x00dev);
 	else
-		rt2x00usb_eeprom_read(rt2x00dev, rt2x00dev->eeprom,
-				      EEPROM_SIZE);
+		retval = rt2x00usb_eeprom_read(rt2x00dev, rt2x00dev->eeprom,
+					       EEPROM_SIZE);
+
+	return retval;
 }
 
 static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
-- 
1.7.10

