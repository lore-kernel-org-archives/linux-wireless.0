Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:51835 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813AbaIDWTD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 18:19:03 -0400
Received: by mail-wi0-f181.google.com with SMTP id e4so1982018wiv.8
        for <linux-wireless@vger.kernel.org>; Thu, 04 Sep 2014 15:19:02 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] bcma: move code for core registration into separate function
Date: Fri,  5 Sep 2014 00:18:48 +0200
Message-Id: <1409869129-15674-1-git-send-email-zajec5@gmail.com> (sfid-20140905_001908_762504_EADB129C)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This cleans code a bit and will us to register cores in other places as
well. The only difference with this patch is using "core_index" for
setting device name.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/main.c | 67 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 36 insertions(+), 31 deletions(-)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 9f6b0cb..9a86352 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -120,10 +120,42 @@ static void bcma_release_core_dev(struct device *dev)
 	kfree(core);
 }
 
-static int bcma_register_cores(struct bcma_bus *bus)
+static void bcma_register_core(struct bcma_bus *bus, struct bcma_device *core)
+{
+	int err;
+
+	core->dev.release = bcma_release_core_dev;
+	core->dev.bus = &bcma_bus_type;
+	dev_set_name(&core->dev, "bcma%d:%d", bus->num, core->core_index);
+
+	switch (bus->hosttype) {
+	case BCMA_HOSTTYPE_PCI:
+		core->dev.parent = &bus->host_pci->dev;
+		core->dma_dev = &bus->host_pci->dev;
+		core->irq = bus->host_pci->irq;
+		break;
+	case BCMA_HOSTTYPE_SOC:
+		core->dev.dma_mask = &core->dev.coherent_dma_mask;
+		core->dma_dev = &core->dev;
+		break;
+	case BCMA_HOSTTYPE_SDIO:
+		break;
+	}
+
+	err = device_register(&core->dev);
+	if (err) {
+		bcma_err(bus, "Could not register dev for core 0x%03X\n",
+			 core->id.id);
+		put_device(&core->dev);
+		return;
+	}
+	core->dev_registered = true;
+}
+
+static int bcma_register_devices(struct bcma_bus *bus)
 {
 	struct bcma_device *core;
-	int err, dev_id = 0;
+	int err;
 
 	list_for_each_entry(core, &bus->cores, list) {
 		/* We support that cores ourself */
@@ -143,34 +175,7 @@ static int bcma_register_cores(struct bcma_bus *bus)
 		    core->core_unit > 0)
 			continue;
 
-		core->dev.release = bcma_release_core_dev;
-		core->dev.bus = &bcma_bus_type;
-		dev_set_name(&core->dev, "bcma%d:%d", bus->num, dev_id);
-
-		switch (bus->hosttype) {
-		case BCMA_HOSTTYPE_PCI:
-			core->dev.parent = &bus->host_pci->dev;
-			core->dma_dev = &bus->host_pci->dev;
-			core->irq = bus->host_pci->irq;
-			break;
-		case BCMA_HOSTTYPE_SOC:
-			core->dev.dma_mask = &core->dev.coherent_dma_mask;
-			core->dma_dev = &core->dev;
-			break;
-		case BCMA_HOSTTYPE_SDIO:
-			break;
-		}
-
-		err = device_register(&core->dev);
-		if (err) {
-			bcma_err(bus,
-				 "Could not register dev for core 0x%03X\n",
-				 core->id.id);
-			put_device(&core->dev);
-			continue;
-		}
-		core->dev_registered = true;
-		dev_id++;
+		bcma_register_core(bus, core);
 	}
 
 #ifdef CONFIG_BCMA_DRIVER_MIPS
@@ -297,7 +302,7 @@ int bcma_bus_register(struct bcma_bus *bus)
 	}
 
 	/* Register found cores */
-	bcma_register_cores(bus);
+	bcma_register_devices(bus);
 
 	bcma_info(bus, "Bus registered\n");
 
-- 
1.8.4.5

