Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:39039 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbbHBS05 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2015 14:26:57 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: zajec5@gmail.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] bcma: fix access to host_pdev for PCIe devices
Date: Sun,  2 Aug 2015 20:26:52 +0200
Message-Id: <1438540012-25292-1-git-send-email-hauke@hauke-m.de> (sfid-20150802_202700_287522_889E6A90)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bus->host_pdev is part of a union so bus->host_pdev != NULL is probably
also true for PCIe devices, because there it accesses bus->host_pci. If
we access the dev member at the offset defined in struct
platform_device in struct pci_dev instead we probably get something
else.

This patch adds a new function which returns the host dev struct and
NULL if we do not have a host dev. When this gets registered on MIPS
brcm47xx we do not have a host dev in some situations.
This function could also be used in other places.

This problem was introduced in this commit:
commit cae761b5a6bdc597ba476a040fdcd5b4bc559b85
Author: Rafał Miłecki <zajec5@gmail.com>
Date:   Sun Jun 28 17:17:13 2015 +0200

    bcma: populate bus DT subnodes as platform_device-s

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/bcma_private.h |  1 +
 drivers/bcma/main.c         | 30 +++++++++++++++++++++++++++---
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 15f2b2e..38f1567 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -34,6 +34,7 @@ int __init bcma_bus_early_register(struct bcma_bus *bus);
 int bcma_bus_suspend(struct bcma_bus *bus);
 int bcma_bus_resume(struct bcma_bus *bus);
 #endif
+struct device *bcma_bus_get_host_dev(struct bcma_bus *bus);
 
 /* scan.c */
 void bcma_detect_chip(struct bcma_bus *bus);
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 8d973c4..24882c1 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -7,7 +7,9 @@
 
 #include "bcma_private.h"
 #include <linux/module.h>
+#include <linux/mmc/sdio_func.h>
 #include <linux/platform_device.h>
+#include <linux/pci.h>
 #include <linux/bcma/bcma.h>
 #include <linux/slab.h>
 #include <linux/of_address.h>
@@ -269,6 +271,28 @@ void bcma_prepare_core(struct bcma_bus *bus, struct bcma_device *core)
 	}
 }
 
+struct device *bcma_bus_get_host_dev(struct bcma_bus *bus)
+{
+	switch (bus->hosttype) {
+	case BCMA_HOSTTYPE_PCI:
+		if (bus->host_pci)
+			return &bus->host_pci->dev;
+		else
+			return NULL;
+	case BCMA_HOSTTYPE_SOC:
+		if (bus->host_pdev)
+			return &bus->host_pdev->dev;
+		else
+			return NULL;
+	case BCMA_HOSTTYPE_SDIO:
+		if (bus->host_sdio)
+			return &bus->host_sdio->dev;
+		else
+			return NULL;
+	}
+	return NULL;
+}
+
 void bcma_init_bus(struct bcma_bus *bus)
 {
 	mutex_lock(&bcma_buses_mutex);
@@ -388,6 +412,7 @@ int bcma_bus_register(struct bcma_bus *bus)
 {
 	int err;
 	struct bcma_device *core;
+	struct device *dev;
 
 	/* Scan for devices (cores) */
 	err = bcma_bus_scan(bus);
@@ -410,13 +435,12 @@ int bcma_bus_register(struct bcma_bus *bus)
 		bcma_core_pci_early_init(&bus->drv_pci[0]);
 	}
 
+	dev = bcma_bus_get_host_dev(bus);
 	/* TODO: remove check for IS_BUILTIN(CONFIG_BCMA) check when
 	 * of_default_bus_match_table is exported or in some other way
 	 * accessible. This is just a temporary workaround.
 	 */
-	if (IS_BUILTIN(CONFIG_BCMA) && bus->host_pdev) {
-		struct device *dev = &bus->host_pdev->dev;
-
+	if (IS_BUILTIN(CONFIG_BCMA) && dev) {
 		of_platform_populate(dev->of_node, of_default_bus_match_table,
 				     NULL, dev);
 	}
-- 
2.1.4

