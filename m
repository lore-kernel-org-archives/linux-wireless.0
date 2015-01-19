Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:34887 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbbASHax (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 02:30:53 -0500
Received: by mail-we0-f170.google.com with SMTP id x3so3328446wes.1
        for <linux-wireless@vger.kernel.org>; Sun, 18 Jan 2015 23:30:52 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V2] bcma: use standard bus scanning during early register
Date: Mon, 19 Jan 2015 08:30:30 +0100
Message-Id: <1421652630-26665-1-git-send-email-zajec5@gmail.com> (sfid-20150119_083056_834282_387EE5AC)
In-Reply-To: <1421442493-32133-1-git-send-email-zajec5@gmail.com>
References: <1421442493-32133-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Starting with kernel 3.19-rc1 early registration of bcma on MIPS is done
a bit later, with memory allocator available. This allows us to simplify
code by using standard bus scanning method.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: Add comment about skipping scanning for the 2nd time
---
 drivers/bcma/bcma_private.h   |  7 +----
 drivers/bcma/host_soc.c       |  2 +-
 drivers/bcma/main.c           | 33 +++++++----------------
 drivers/bcma/scan.c           | 62 +++----------------------------------------
 include/linux/bcma/bcma_soc.h |  2 --
 5 files changed, 15 insertions(+), 91 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 59422b5..3f314c9 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -28,9 +28,7 @@ void bcma_prepare_core(struct bcma_bus *bus, struct bcma_device *core);
 void bcma_init_bus(struct bcma_bus *bus);
 int bcma_bus_register(struct bcma_bus *bus);
 void bcma_bus_unregister(struct bcma_bus *bus);
-int __init bcma_bus_early_register(struct bcma_bus *bus,
-				   struct bcma_device *core_cc,
-				   struct bcma_device *core_mips);
+int __init bcma_bus_early_register(struct bcma_bus *bus);
 #ifdef CONFIG_PM
 int bcma_bus_suspend(struct bcma_bus *bus);
 int bcma_bus_resume(struct bcma_bus *bus);
@@ -39,9 +37,6 @@ int bcma_bus_resume(struct bcma_bus *bus);
 /* scan.c */
 void bcma_detect_chip(struct bcma_bus *bus);
 int bcma_bus_scan(struct bcma_bus *bus);
-int __init bcma_bus_scan_early(struct bcma_bus *bus,
-			       struct bcma_device_id *match,
-			       struct bcma_device *core);
 
 /* sprom.c */
 int bcma_sprom_get(struct bcma_bus *bus);
diff --git a/drivers/bcma/host_soc.c b/drivers/bcma/host_soc.c
index 335cbcf..2dce347 100644
--- a/drivers/bcma/host_soc.c
+++ b/drivers/bcma/host_soc.c
@@ -193,7 +193,7 @@ int __init bcma_host_soc_init(struct bcma_soc *soc)
 	int err;
 
 	/* Scan bus and initialize it */
-	err = bcma_bus_early_register(bus, &soc->core_cc, &soc->core_mips);
+	err = bcma_bus_early_register(bus);
 	if (err)
 		iounmap(bus->mmio);
 
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index c166d44..c3c5e0a 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -489,35 +489,20 @@ void bcma_bus_unregister(struct bcma_bus *bus)
 	kfree(cores[0]);
 }
 
-int __init bcma_bus_early_register(struct bcma_bus *bus,
-				   struct bcma_device *core_cc,
-				   struct bcma_device *core_mips)
+/*
+ * This is a special version of bus registration function designed for SoCs.
+ * It scans bus and performs basic initialization of main cores only.
+ * Please note it requires memory allocation, however it won't try to sleep.
+ */
+int __init bcma_bus_early_register(struct bcma_bus *bus)
 {
 	int err;
 	struct bcma_device *core;
-	struct bcma_device_id match;
-
-	match.manuf = BCMA_MANUF_BCM;
-	match.id = bcma_cc_core_id(bus);
-	match.class = BCMA_CL_SIM;
-	match.rev = BCMA_ANY_REV;
-
-	/* Scan for chip common core */
-	err = bcma_bus_scan_early(bus, &match, core_cc);
-	if (err) {
-		bcma_err(bus, "Failed to scan for common core: %d\n", err);
-		return -1;
-	}
-
-	match.manuf = BCMA_MANUF_MIPS;
-	match.id = BCMA_CORE_MIPS_74K;
-	match.class = BCMA_CL_SIM;
-	match.rev = BCMA_ANY_REV;
 
-	/* Scan for mips core */
-	err = bcma_bus_scan_early(bus, &match, core_mips);
+	/* Scan for devices (cores) */
+	err = bcma_bus_scan(bus);
 	if (err) {
-		bcma_err(bus, "Failed to scan for mips core: %d\n", err);
+		bcma_err(bus, "Failed to scan bus: %d\n", err);
 		return -1;
 	}
 
diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index 5328ee5..df806b9 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -461,6 +461,10 @@ int bcma_bus_scan(struct bcma_bus *bus)
 
 	int err, core_num = 0;
 
+	/* Skip if bus was already scanned (e.g. during early register) */
+	if (bus->nr_cores)
+		return 0;
+
 	erombase = bcma_scan_read32(bus, 0, BCMA_CC_EROM);
 	if (bus->hosttype == BCMA_HOSTTYPE_SOC) {
 		eromptr = ioremap_nocache(erombase, BCMA_CORE_SIZE);
@@ -519,61 +523,3 @@ out:
 
 	return err;
 }
-
-int __init bcma_bus_scan_early(struct bcma_bus *bus,
-			       struct bcma_device_id *match,
-			       struct bcma_device *core)
-{
-	u32 erombase;
-	u32 __iomem *eromptr, *eromend;
-
-	int err = -ENODEV;
-	int core_num = 0;
-
-	erombase = bcma_scan_read32(bus, 0, BCMA_CC_EROM);
-	if (bus->hosttype == BCMA_HOSTTYPE_SOC) {
-		eromptr = ioremap_nocache(erombase, BCMA_CORE_SIZE);
-		if (!eromptr)
-			return -ENOMEM;
-	} else {
-		eromptr = bus->mmio;
-	}
-
-	eromend = eromptr + BCMA_CORE_SIZE / sizeof(u32);
-
-	bcma_scan_switch_core(bus, erombase);
-
-	while (eromptr < eromend) {
-		memset(core, 0, sizeof(*core));
-		INIT_LIST_HEAD(&core->list);
-		core->bus = bus;
-
-		err = bcma_get_next_core(bus, &eromptr, match, core_num, core);
-		if (err == -ENODEV) {
-			core_num++;
-			continue;
-		} else if (err == -ENXIO)
-			continue;
-		else if (err == -ESPIPE)
-			break;
-		else if (err < 0)
-			goto out;
-
-		core->core_index = core_num++;
-		bus->nr_cores++;
-		bcma_info(bus, "Core %d found: %s (manuf 0x%03X, id 0x%03X, rev 0x%02X, class 0x%X)\n",
-			  core->core_index, bcma_device_name(&core->id),
-			  core->id.manuf, core->id.id, core->id.rev,
-			  core->id.class);
-
-		list_add_tail(&core->list, &bus->cores);
-		err = 0;
-		break;
-	}
-
-out:
-	if (bus->hosttype == BCMA_HOSTTYPE_SOC)
-		iounmap(eromptr);
-
-	return err;
-}
diff --git a/include/linux/bcma/bcma_soc.h b/include/linux/bcma/bcma_soc.h
index f24d245..1b5fc0c 100644
--- a/include/linux/bcma/bcma_soc.h
+++ b/include/linux/bcma/bcma_soc.h
@@ -5,8 +5,6 @@
 
 struct bcma_soc {
 	struct bcma_bus bus;
-	struct bcma_device core_cc;
-	struct bcma_device core_mips;
 };
 
 int __init bcma_host_soc_register(struct bcma_soc *soc);
-- 
1.8.4.5

