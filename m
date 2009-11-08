Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:62471 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbZKHNkJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 08:40:09 -0500
Received: by mail-ew0-f207.google.com with SMTP id 3so2371374ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 05:40:15 -0800 (PST)
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Date: Sun, 08 Nov 2009 14:39:48 +0100
Message-Id: <20091108133948.23584.12804.sendpatchset@localhost.localdomain>
In-Reply-To: <20091108133854.23584.86842.sendpatchset@localhost.localdomain>
References: <20091108133854.23584.86842.sendpatchset@localhost.localdomain>
Subject: [PATCH 8/9] rt2800: add eFuse EEPROM support code to rt2800lib
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800: add eFuse EEPROM support code to rt2800lib

eFuse EEPROM is used also by USB chips (i.e. RT3070)
so move the needed code from rt2800pci to rt2800lib.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800.h    |   29 +++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2800lib.c |   43 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2800lib.h |    2 +
 drivers/net/wireless/rt2x00/rt2800pci.c |   38 ++--------------------------
 drivers/net/wireless/rt2x00/rt2800pci.h |   29 ---------------------
 5 files changed, 77 insertions(+), 64 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2800.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -362,6 +362,35 @@
 #define RF_CSR_CFG_BUSY			FIELD32(0x00020000)
 
 /*
+ * EFUSE_CSR: RT30x0 EEPROM
+ */
+#define EFUSE_CTRL			0x0580
+#define EFUSE_CTRL_ADDRESS_IN		FIELD32(0x03fe0000)
+#define EFUSE_CTRL_MODE			FIELD32(0x000000c0)
+#define EFUSE_CTRL_KICK			FIELD32(0x40000000)
+#define EFUSE_CTRL_PRESENT		FIELD32(0x80000000)
+
+/*
+ * EFUSE_DATA0
+ */
+#define EFUSE_DATA0			0x0590
+
+/*
+ * EFUSE_DATA1
+ */
+#define EFUSE_DATA1			0x0594
+
+/*
+ * EFUSE_DATA2
+ */
+#define EFUSE_DATA2			0x0598
+
+/*
+ * EFUSE_DATA3
+ */
+#define EFUSE_DATA3			0x059c
+
+/*
  * MAC Control/Status Registers(CSR).
  * Some values are set in TU, whereas 1 TU == 1024 us.
  */
Index: b/drivers/net/wireless/rt2x00/rt2800lib.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1659,6 +1659,49 @@ int rt2800_init_rfcsr(struct rt2x00_dev 
 }
 EXPORT_SYMBOL_GPL(rt2800_init_rfcsr);
 
+int rt2800_efuse_detect(struct rt2x00_dev *rt2x00dev)
+{
+	u32 reg;
+
+	rt2800_register_read(rt2x00dev, EFUSE_CTRL, &reg);
+
+	return rt2x00_get_field32(reg, EFUSE_CTRL_PRESENT);
+}
+EXPORT_SYMBOL_GPL(rt2800_efuse_detect);
+
+static void rt2800_efuse_read(struct rt2x00_dev *rt2x00dev, unsigned int i)
+{
+	u32 reg;
+
+	rt2800_register_read(rt2x00dev, EFUSE_CTRL, &reg);
+	rt2x00_set_field32(&reg, EFUSE_CTRL_ADDRESS_IN, i);
+	rt2x00_set_field32(&reg, EFUSE_CTRL_MODE, 0);
+	rt2x00_set_field32(&reg, EFUSE_CTRL_KICK, 1);
+	rt2800_register_write(rt2x00dev, EFUSE_CTRL, reg);
+
+	/* Wait until the EEPROM has been loaded */
+	rt2800_regbusy_read(rt2x00dev, EFUSE_CTRL, EFUSE_CTRL_KICK, &reg);
+
+	/* Apparently the data is read from end to start */
+	rt2800_register_read(rt2x00dev, EFUSE_DATA3,
+				(u32 *)&rt2x00dev->eeprom[i]);
+	rt2800_register_read(rt2x00dev, EFUSE_DATA2,
+				(u32 *)&rt2x00dev->eeprom[i + 2]);
+	rt2800_register_read(rt2x00dev, EFUSE_DATA1,
+				(u32 *)&rt2x00dev->eeprom[i + 4]);
+	rt2800_register_read(rt2x00dev, EFUSE_DATA0,
+				(u32 *)&rt2x00dev->eeprom[i + 6]);
+}
+
+void rt2800_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev)
+{
+	unsigned int i;
+
+	for (i = 0; i < EEPROM_SIZE / sizeof(u16); i += 8)
+		rt2800_efuse_read(rt2x00dev, i);
+}
+EXPORT_SYMBOL_GPL(rt2800_read_eeprom_efuse);
+
 int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 {
 	u16 word;
Index: b/drivers/net/wireless/rt2x00/rt2800lib.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -129,6 +129,8 @@ int rt2800_init_registers(struct rt2x00_
 int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev);
 int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev);
 
+int rt2800_efuse_detect(struct rt2x00_dev *rt2x00dev);
+void rt2800_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev);
 int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev);
 int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev);
 int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev);
Index: b/drivers/net/wireless/rt2x00/rt2800pci.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -147,44 +147,12 @@ static void rt2800pci_read_eeprom_pci(st
 
 static int rt2800pci_efuse_detect(struct rt2x00_dev *rt2x00dev)
 {
-	u32 reg;
-
-	rt2800_register_read(rt2x00dev, EFUSE_CTRL, &reg);
-
-	return rt2x00_get_field32(reg, EFUSE_CTRL_PRESENT);
+	return rt2800_efuse_detect(rt2x00dev);
 }
 
-static void rt2800pci_efuse_read(struct rt2x00_dev *rt2x00dev,
-				 unsigned int i)
-{
-	u32 reg;
-
-	rt2800_register_read(rt2x00dev, EFUSE_CTRL, &reg);
-	rt2x00_set_field32(&reg, EFUSE_CTRL_ADDRESS_IN, i);
-	rt2x00_set_field32(&reg, EFUSE_CTRL_MODE, 0);
-	rt2x00_set_field32(&reg, EFUSE_CTRL_KICK, 1);
-	rt2800_register_write(rt2x00dev, EFUSE_CTRL, reg);
-
-	/* Wait until the EEPROM has been loaded */
-	rt2800_regbusy_read(rt2x00dev, EFUSE_CTRL, EFUSE_CTRL_KICK, &reg);
-
-	/* Apparently the data is read from end to start */
-	rt2800_register_read(rt2x00dev, EFUSE_DATA3,
-				(u32 *)&rt2x00dev->eeprom[i]);
-	rt2800_register_read(rt2x00dev, EFUSE_DATA2,
-				(u32 *)&rt2x00dev->eeprom[i + 2]);
-	rt2800_register_read(rt2x00dev, EFUSE_DATA1,
-				(u32 *)&rt2x00dev->eeprom[i + 4]);
-	rt2800_register_read(rt2x00dev, EFUSE_DATA0,
-				(u32 *)&rt2x00dev->eeprom[i + 6]);
-}
-
-static void rt2800pci_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev)
+static inline void rt2800pci_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev)
 {
-	unsigned int i;
-
-	for (i = 0; i < EEPROM_SIZE / sizeof(u16); i += 8)
-		rt2800pci_efuse_read(rt2x00dev, i);
+	rt2800_read_eeprom_efuse(rt2x00dev);
 }
 #else
 static inline void rt2800pci_read_eeprom_pci(struct rt2x00_dev *rt2x00dev)
Index: b/drivers/net/wireless/rt2x00/rt2800pci.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800pci.h
+++ b/drivers/net/wireless/rt2x00/rt2800pci.h
@@ -56,35 +56,6 @@
 #define TX_DTX_IDX(__x)			TX_DTX_IDX0 + ((__x) * TX_QUEUE_REG_OFFSET)
 
 /*
- * EFUSE_CSR: RT3090 EEPROM
- */
-#define EFUSE_CTRL			0x0580
-#define EFUSE_CTRL_ADDRESS_IN		FIELD32(0x03fe0000)
-#define EFUSE_CTRL_MODE			FIELD32(0x000000c0)
-#define EFUSE_CTRL_KICK			FIELD32(0x40000000)
-#define EFUSE_CTRL_PRESENT		FIELD32(0x80000000)
-
-/*
- * EFUSE_DATA0
- */
-#define EFUSE_DATA0			0x0590
-
-/*
- * EFUSE_DATA1
- */
-#define EFUSE_DATA1			0x0594
-
-/*
- * EFUSE_DATA2
- */
-#define EFUSE_DATA2			0x0598
-
-/*
- * EFUSE_DATA3
- */
-#define EFUSE_DATA3			0x059c
-
-/*
  * 8051 firmware image.
  */
 #define FIRMWARE_RT2860			"rt2860.bin"
