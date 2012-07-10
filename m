Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:41460 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab2GJVpz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 17:45:55 -0400
Received: by weyx8 with SMTP id x8so383202wey.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jul 2012 14:45:54 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: support alternative (BCM4706) ChipCommon core id
Date: Tue, 10 Jul 2012 23:45:49 +0200
Message-Id: <1341956749-14722-1-git-send-email-zajec5@gmail.com> (sfid-20120710_234559_440397_34645F4F)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
Final vs. RFC: improved bcma_bus_resume
---
 drivers/bcma/main.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 7ff4bac..151bddc 100644
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
@@ -208,7 +216,7 @@ int __init bcma_bus_early_register(struct bcma_bus *bus,
 	bcma_init_bus(bus);
 
 	match.manuf = BCMA_MANUF_BCM;
-	match.id = BCMA_CORE_CHIPCOMMON;
+	match.id = bcma_cc_core_id(bus);
 	match.class = BCMA_CL_SIM;
 	match.rev = BCMA_ANY_REV;
 
@@ -232,7 +240,7 @@ int __init bcma_bus_early_register(struct bcma_bus *bus,
 	}
 
 	/* Init CC core */
-	core = bcma_find_core(bus, BCMA_CORE_CHIPCOMMON);
+	core = bcma_find_core(bus, bcma_cc_core_id(bus));
 	if (core) {
 		bus->drv_cc.core = core;
 		bcma_core_chipcommon_init(&bus->drv_cc);
@@ -271,8 +279,7 @@ int bcma_bus_resume(struct bcma_bus *bus)
 	struct bcma_device *core;
 
 	/* Init CC core */
-	core = bcma_find_core(bus, BCMA_CORE_CHIPCOMMON);
-	if (core) {
+	if (bus->drv_cc.core) {
 		bus->drv_cc.setup_done = false;
 		bcma_core_chipcommon_init(&bus->drv_cc);
 	}
-- 
1.7.7

