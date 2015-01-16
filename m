Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:34144 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128AbbAPTTP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 14:19:15 -0500
Received: by mail-wg0-f45.google.com with SMTP id y19so22240223wgg.4
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2015 11:19:14 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: clean bus initialiation code
Date: Fri, 16 Jan 2015 20:18:49 +0100
Message-Id: <1421435929-21499-1-git-send-email-zajec5@gmail.com> (sfid-20150116_201940_730633_8A467042)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This moves main bus init code to the main.c and renames old function to
make its purpose clear.
Thanks to this change we'll also be able to separate scanning from
registration (and support PCIe Gen 2 devices) in the future.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/bcma_private.h |  3 ++-
 drivers/bcma/main.c         | 16 ++++++++++++----
 drivers/bcma/scan.c         |  5 +----
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 314ae40..08fa58a 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -25,6 +25,7 @@ struct bcma_bus;
 bool bcma_wait_value(struct bcma_device *core, u16 reg, u32 mask, u32 value,
 		     int timeout);
 void bcma_prepare_core(struct bcma_bus *bus, struct bcma_device *core);
+void bcma_init_bus(struct bcma_bus *bus);
 int bcma_bus_register(struct bcma_bus *bus);
 void bcma_bus_unregister(struct bcma_bus *bus);
 int __init bcma_bus_early_register(struct bcma_bus *bus,
@@ -40,7 +41,7 @@ int bcma_bus_scan(struct bcma_bus *bus);
 int __init bcma_bus_scan_early(struct bcma_bus *bus,
 			       struct bcma_device_id *match,
 			       struct bcma_device *core);
-void bcma_init_bus(struct bcma_bus *bus);
+void bcma_detect_chip(struct bcma_bus *bus);
 
 /* sprom.c */
 int bcma_sprom_get(struct bcma_bus *bus);
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 534e133..c166d44 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -268,6 +268,18 @@ void bcma_prepare_core(struct bcma_bus *bus, struct bcma_device *core)
 	}
 }
 
+void bcma_init_bus(struct bcma_bus *bus)
+{
+	mutex_lock(&bcma_buses_mutex);
+	bus->num = bcma_bus_next_num++;
+	mutex_unlock(&bcma_buses_mutex);
+
+	INIT_LIST_HEAD(&bus->cores);
+	bus->nr_cores = 0;
+
+	bcma_detect_chip(bus);
+}
+
 static void bcma_register_core(struct bcma_bus *bus, struct bcma_device *core)
 {
 	int err;
@@ -369,10 +381,6 @@ int bcma_bus_register(struct bcma_bus *bus)
 	int err;
 	struct bcma_device *core;
 
-	mutex_lock(&bcma_buses_mutex);
-	bus->num = bcma_bus_next_num++;
-	mutex_unlock(&bcma_buses_mutex);
-
 	/* Scan for devices (cores) */
 	err = bcma_bus_scan(bus);
 	if (err) {
diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index 9175207..5328ee5 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -435,15 +435,12 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 	return 0;
 }
 
-void bcma_init_bus(struct bcma_bus *bus)
+void bcma_detect_chip(struct bcma_bus *bus)
 {
 	s32 tmp;
 	struct bcma_chipinfo *chipinfo = &(bus->chipinfo);
 	char chip_id[8];
 
-	INIT_LIST_HEAD(&bus->cores);
-	bus->nr_cores = 0;
-
 	bcma_scan_switch_core(bus, BCMA_ADDR_BASE);
 
 	tmp = bcma_scan_read32(bus, 0, BCMA_CC_ID);
-- 
1.8.4.5

