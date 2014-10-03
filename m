Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56294 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbaJCPAf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Oct 2014 11:00:35 -0400
Received: by mail-wi0-f178.google.com with SMTP id cc10so2384623wib.11
        for <linux-wireless@vger.kernel.org>; Fri, 03 Oct 2014 08:00:34 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: fill core details for every device
Date: Fri,  3 Oct 2014 17:00:24 +0200
Message-Id: <1412348424-11213-1-git-send-email-zajec5@gmail.com> (sfid-20141003_170038_971002_0F7BB722)
In-Reply-To: <1412246303-18172-1-git-send-email-zajec5@gmail.com>
References: <1412246303-18172-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were setting things like dma_dev, IRQ, etc. during core registration
only. We need such info for cores handled internally (e.g. ChipCommon)
as well.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
---
No changes since RFC. Added Hauke's ack.
---
 drivers/bcma/bcma_private.h | 1 +
 drivers/bcma/main.c         | 9 ++++++---
 drivers/bcma/scan.c         | 1 +
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index b6412b2..314ae40 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -24,6 +24,7 @@ struct bcma_bus;
 /* main.c */
 bool bcma_wait_value(struct bcma_device *core, u16 reg, u32 mask, u32 value,
 		     int timeout);
+void bcma_prepare_core(struct bcma_bus *bus, struct bcma_device *core);
 int bcma_bus_register(struct bcma_bus *bus);
 void bcma_bus_unregister(struct bcma_bus *bus);
 int __init bcma_bus_early_register(struct bcma_bus *bus,
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index d1656c2..9b229c9 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -169,10 +169,8 @@ static void bcma_of_fill_device(struct platform_device *parent,
 }
 #endif /* CONFIG_OF */
 
-static void bcma_register_core(struct bcma_bus *bus, struct bcma_device *core)
+void bcma_prepare_core(struct bcma_bus *bus, struct bcma_device *core)
 {
-	int err;
-
 	core->dev.release = bcma_release_core_dev;
 	core->dev.bus = &bcma_bus_type;
 	dev_set_name(&core->dev, "bcma%d:%d", bus->num, core->core_index);
@@ -196,6 +194,11 @@ static void bcma_register_core(struct bcma_bus *bus, struct bcma_device *core)
 	case BCMA_HOSTTYPE_SDIO:
 		break;
 	}
+}
+
+static void bcma_register_core(struct bcma_bus *bus, struct bcma_device *core)
+{
+	int err;
 
 	err = device_register(&core->dev);
 	if (err) {
diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index 14b5656..9175207 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -505,6 +505,7 @@ int bcma_bus_scan(struct bcma_bus *bus)
 		bus->nr_cores++;
 		other_core = bcma_find_core_reverse(bus, core->id.id);
 		core->core_unit = (other_core == NULL) ? 0 : other_core->core_unit + 1;
+		bcma_prepare_core(bus, core);
 
 		bcma_info(bus, "Core %d found: %s (manuf 0x%03X, id 0x%03X, rev 0x%02X, class 0x%X)\n",
 			  core->core_index, bcma_device_name(&core->id),
-- 
1.8.4.5

