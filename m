Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:64125 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaIAVLP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 17:11:15 -0400
Received: by mail-wi0-f179.google.com with SMTP id q5so6751693wiv.12
        for <linux-wireless@vger.kernel.org>; Mon, 01 Sep 2014 14:11:14 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] bcma: move bus struct setup into early part of host specific code
Date: Mon,  1 Sep 2014 23:11:06 +0200
Message-Id: <1409605867-30051-1-git-send-email-zajec5@gmail.com> (sfid-20140901_231125_095742_296D4EFA)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This change is important for SoC host. In future we will want to know
chip ID (needed for early MIPS boot) before doing cores scanning.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/host_pci.c   | 3 +++
 drivers/bcma/host_soc.c   | 3 +++
 drivers/bcma/main.c       | 2 --
 drivers/bcma/scan.c       | 7 -------
 include/linux/bcma/bcma.h | 1 -
 5 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index 294a7dd..3251d52 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -208,6 +208,9 @@ static int bcma_host_pci_probe(struct pci_dev *dev,
 	bus->boardinfo.vendor = bus->host_pci->subsystem_vendor;
 	bus->boardinfo.type = bus->host_pci->subsystem_device;
 
+	/* Initialize struct, detect chip */
+	bcma_init_bus(bus);
+
 	/* Register */
 	err = bcma_bus_register(bus);
 	if (err)
diff --git a/drivers/bcma/host_soc.c b/drivers/bcma/host_soc.c
index 1edd7e0..379e0d4e 100644
--- a/drivers/bcma/host_soc.c
+++ b/drivers/bcma/host_soc.c
@@ -178,6 +178,9 @@ int __init bcma_host_soc_register(struct bcma_soc *soc)
 	bus->hosttype = BCMA_HOSTTYPE_SOC;
 	bus->ops = &bcma_host_soc_ops;
 
+	/* Initialize struct, detect chip */
+	bcma_init_bus(bus);
+
 	/* Register */
 	err = bcma_bus_early_register(bus, &soc->core_cc, &soc->core_mips);
 	if (err)
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 0ff8d58..9f6b0cb 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -334,8 +334,6 @@ int __init bcma_bus_early_register(struct bcma_bus *bus,
 	struct bcma_device *core;
 	struct bcma_device_id match;
 
-	bcma_init_bus(bus);
-
 	match.manuf = BCMA_MANUF_BCM;
 	match.id = bcma_cc_core_id(bus);
 	match.class = BCMA_CL_SIM;
diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index e9bd772..e2b9903 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -438,9 +438,6 @@ void bcma_init_bus(struct bcma_bus *bus)
 	s32 tmp;
 	struct bcma_chipinfo *chipinfo = &(bus->chipinfo);
 
-	if (bus->init_done)
-		return;
-
 	INIT_LIST_HEAD(&bus->cores);
 	bus->nr_cores = 0;
 
@@ -452,8 +449,6 @@ void bcma_init_bus(struct bcma_bus *bus)
 	chipinfo->pkg = (tmp & BCMA_CC_ID_PKG) >> BCMA_CC_ID_PKG_SHIFT;
 	bcma_info(bus, "Found chip with id 0x%04X, rev 0x%02X and package 0x%02X\n",
 		  chipinfo->id, chipinfo->rev, chipinfo->pkg);
-
-	bus->init_done = true;
 }
 
 int bcma_bus_scan(struct bcma_bus *bus)
@@ -463,8 +458,6 @@ int bcma_bus_scan(struct bcma_bus *bus)
 
 	int err, core_num = 0;
 
-	bcma_init_bus(bus);
-
 	erombase = bcma_scan_read32(bus, 0, BCMA_CC_EROM);
 	if (bus->hosttype == BCMA_HOSTTYPE_SOC) {
 		eromptr = ioremap_nocache(erombase, BCMA_CORE_SIZE);
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 0272e49..c1ba87d 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -332,7 +332,6 @@ struct bcma_bus {
 	struct bcma_device *mapped_core;
 	struct list_head cores;
 	u8 nr_cores;
-	u8 init_done:1;
 	u8 num;
 
 	struct bcma_drv_cc drv_cc;
-- 
1.8.4.5

