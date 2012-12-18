Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:41969 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754980Ab2LRQWf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2012 11:22:35 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Daniel Golle <dgolle@allnet.de>, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 2/2] rt2x00: rt2800pci: allow to load EEPROM data via firmware API
Date: Tue, 18 Dec 2012 17:22:23 +0100
Message-Id: <1355847743-16659-2-git-send-email-juhosg@openwrt.org> (sfid-20121218_172239_704545_4419E164)
In-Reply-To: <1355847743-16659-1-git-send-email-juhosg@openwrt.org>
References: <1355847743-16659-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the driver fetches the EEPROM data
from a fixed memory location for SoC devices
for SoC devices with a built-in wireless MAC.

The usability of this approach is quite
limited, because it is only suitable if the
location of the EEPROM data is mapped into
the memory. This condition is true on embedded
boards equipped which are using a parallel NOR
flash, but it is not true for boards equipped
with SPI or NAND flashes. The fixed location
also does not work in all cases, because the
offset of the EEPROM data varies between
different boards.

Additionally, various embedded boards are using
a PCI/PCIe chip soldered directly onto the PCB.
Such boards usually does not have a separate
EEPROM chip for the PCI/PCIe devices, the data
of the EEPROM is stored in the main flash
instead.

The patch makes it possible to load the EEPROM
data via firmware API. This new method works
regardless of the type of the flash, and it is
usable with built-in and with PCI/PCIe devices.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |   77 +++++++++++++++++++++++++------
 include/linux/platform_data/rt2800pci.h |   19 ++++++++
 2 files changed, 81 insertions(+), 15 deletions(-)
 create mode 100644 include/linux/platform_data/rt2800pci.h

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 5fc16dd..a63a359 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -39,6 +39,8 @@
 #include <linux/pci.h>
 #include <linux/platform_device.h>
 #include <linux/eeprom_93cx6.h>
+#include <linux/firmware.h>
+#include <linux/platform_data/rt2800pci.h>
 
 #include "rt2x00.h"
 #include "rt2x00pci.h"
@@ -47,6 +49,11 @@
 #include "rt2800.h"
 #include "rt2800pci.h"
 
+struct rt2800pci_eeprom_ctx {
+	struct completion complete;
+	const struct firmware *blob;
+};
+
 /*
  * Allow hardware encryption to be disabled.
  */
@@ -89,24 +96,49 @@ static void rt2800pci_mcu_status(struct rt2x00_dev *rt2x00dev, const u8 token)
 	rt2x00pci_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
 }
 
-#if defined(CONFIG_RALINK_RT288X) || defined(CONFIG_RALINK_RT305X)
-static int rt2800pci_read_eeprom_soc(struct rt2x00_dev *rt2x00dev)
+static void rt2800pci_eeprom_request_cb(const struct firmware *blob,
+					void *ctx)
 {
-	void __iomem *base_addr = ioremap(0x1F040000, EEPROM_SIZE);
-
-	if (!base_addr)
-		return -ENOMEM;
+	struct rt2800pci_eeprom_ctx *ec = ctx;
 
-	memcpy_fromio(rt2x00dev->eeprom, base_addr, EEPROM_SIZE);
-
-	iounmap(base_addr);
+	ec->blob = blob;
+	complete(&ec->complete);
 }
-#else
-static inline int rt2800pci_read_eeprom_soc(struct rt2x00_dev *rt2x00dev)
+
+static int rt2800pci_read_eeprom_file(struct rt2x00_dev *rt2x00dev,
+				      const char *name)
 {
-	return -ENOMEM;
+
+	struct rt2800pci_eeprom_ctx ec = {};
+	int retval;
+
+	init_completion(&ec.complete);
+	retval = request_firmware_nowait(THIS_MODULE, 1, name,
+					 rt2x00dev->dev, GFP_KERNEL, &ec,
+					 rt2800pci_eeprom_request_cb);
+	if (retval < 0) {
+		ERROR(rt2x00dev, "EEPROM request failed\n");
+		return retval;
+	}
+
+	wait_for_completion(&ec.complete);
+	if (!ec.blob) {
+		ERROR(rt2x00dev, "Unable to load EEPROM file %s\n", name);
+		return -EINVAL;
+	}
+
+	if (ec.blob->size < EEPROM_SIZE) {
+		ERROR(rt2x00dev, "invalid EEPROM file %s\n", name);
+		retval = -EINVAL;
+		goto release_eeprom;
+	}
+
+	memcpy(rt2x00dev->eeprom, ec.blob->data, EEPROM_SIZE);
+	retval = 0;
+
+release_eeprom:
+	return retval;
 }
-#endif /* CONFIG_RALINK_RT288X || CONFIG_RALINK_RT305X */
 
 #ifdef CONFIG_PCI
 static void rt2800pci_eepromregister_read(struct eeprom_93cx6 *eeprom)
@@ -976,8 +1008,17 @@ static irqreturn_t rt2800pci_interrupt(int irq, void *dev_instance)
  */
 static int rt2800pci_read_eeprom(struct rt2x00_dev *rt2x00dev)
 {
-	if (rt2x00_is_soc(rt2x00dev))
-		return rt2800pci_read_eeprom_soc(rt2x00dev);
+	struct rt2800pci_platform_data *pdata;
+
+	pdata = rt2x00dev->dev->platform_data;
+	if (pdata && pdata->eeprom_name) {
+		/* If the eeprom_name is provided via
+		 * platform_data, load the EEPROM content
+		 * from that file.
+		 */
+		return rt2800pci_read_eeprom_file(rt2x00dev,
+						  pdata->eeprom_name);
+	}
 
 	if (rt2800pci_efuse_detect(rt2x00dev))
 		rt2800pci_read_eeprom_efuse(rt2x00dev);
@@ -1173,6 +1214,12 @@ MODULE_LICENSE("GPL");
 #if defined(CONFIG_RALINK_RT288X) || defined(CONFIG_RALINK_RT305X)
 static int rt2800soc_probe(struct platform_device *pdev)
 {
+	struct rt2800pci_platform_data *pdata;
+
+	pdata = pdev->dev.platform_data;
+	if (!pdata || !pdata->eeprom_name)
+		return -EINVAL;
+
 	return rt2x00soc_probe(pdev, &rt2800pci_ops);
 }
 
diff --git a/include/linux/platform_data/rt2800pci.h b/include/linux/platform_data/rt2800pci.h
new file mode 100644
index 0000000..1caced9
--- /dev/null
+++ b/include/linux/platform_data/rt2800pci.h
@@ -0,0 +1,19 @@
+/*
+ * Platform data definition for the rt2800pci driver
+ *
+ * Copyright (C) 2011-2012 Gabor Juhos <juhosg@openwrt.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ */
+
+#ifndef _RT2800PCI_PLATFORM_H
+#define _RT2800PCI_PLATFORM_H
+
+struct rt2800pci_platform_data {
+	const char *eeprom_name;
+};
+
+#endif /* _RT2800PCI_PLATFORM_H */
-- 
1.7.10

