Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:43904 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab2GIUOS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 16:14:18 -0400
Received: by wibhq12 with SMTP id hq12so2977962wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2012 13:14:16 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [RFC][PATCH] bcma: support alternative (BCM4706) ChipCommon core id
Date: Mon,  9 Jul 2012 22:14:08 +0200
Message-Id: <1341864848-9707-1-git-send-email-zajec5@gmail.com> (sfid-20120709_221421_636665_14326872)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 drivers/bcma/main.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 173a0b4..61ac6cf 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -61,6 +61,13 @@ static struct bus_type bcma_bus_type = {
 	.dev_attrs	= bcma_device_attrs,
 };
 
+static u16 bcma_cc_core_id(struct bcma_bus *bus)
+{
+	if (bus->chipinfo.id == BCMA_CHIP_ID_BCM4706)
+		return BCMA_CORE_4706_CHIPCOMMON;
+	return BCMA_CORE_CHIPCOMMON;
+}
+
 struct bcma_device *bcma_find_core(struct bcma_bus *bus, u16 coreid)
 {
 	struct bcma_device *core;
@@ -91,6 +98,7 @@ static int bcma_register_cores(struct bcma_bus *bus)
 	list_for_each_entry(core, &bus->cores, list) {
 		/* We support that cores ourself */
 		switch (core->id.id) {
+		case BCMA_CORE_4706_CHIPCOMMON:
 		case BCMA_CORE_CHIPCOMMON:
 		case BCMA_CORE_PCI:
 		case BCMA_CORE_PCIE:
@@ -157,7 +165,7 @@ int __devinit bcma_bus_register(struct bcma_bus *bus)
 	}
 
 	/* Init CC core */
-	core = bcma_find_core(bus, BCMA_CORE_CHIPCOMMON);
+	core = bcma_find_core(bus, bcma_cc_core_id(bus));
 	if (core) {
 		bus->drv_cc.core = core;
 		bcma_core_chipcommon_init(&bus->drv_cc);
@@ -215,7 +223,7 @@ int __init bcma_bus_early_register(struct bcma_bus *bus,
 	bcma_init_bus(bus);
 
 	match.manuf = BCMA_MANUF_BCM;
-	match.id = BCMA_CORE_CHIPCOMMON;
+	match.id = bcma_cc_core_id(bus);
 	match.class = BCMA_CL_SIM;
 	match.rev = BCMA_ANY_REV;
 
@@ -239,7 +247,7 @@ int __init bcma_bus_early_register(struct bcma_bus *bus,
 	}
 
 	/* Init CC core */
-	core = bcma_find_core(bus, BCMA_CORE_CHIPCOMMON);
+	core = bcma_find_core(bus, bcma_cc_core_id(bus));
 	if (core) {
 		bus->drv_cc.core = core;
 		bcma_core_chipcommon_init(&bus->drv_cc);
-- 
1.7.7

