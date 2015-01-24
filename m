Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:35723 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbbAXRrb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2015 12:47:31 -0500
Received: by mail-wg0-f54.google.com with SMTP id b13so2638372wgh.13
        for <linux-wireless@vger.kernel.org>; Sat, 24 Jan 2015 09:47:30 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: simplify freeing cores (internal devices structs)
Date: Sat, 24 Jan 2015 18:47:19 +0100
Message-Id: <1422121640-9227-1-git-send-email-zajec5@gmail.com> (sfid-20150124_184734_169934_A6EE56C6)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/main.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index c3c5e0a..73b2ee3 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -368,12 +368,19 @@ static void bcma_unregister_cores(struct bcma_bus *bus)
 	struct bcma_device *core, *tmp;
 
 	list_for_each_entry_safe(core, tmp, &bus->cores, list) {
+		if (!core->dev_registered)
+			continue;
 		list_del(&core->list);
-		if (core->dev_registered)
-			device_unregister(&core->dev);
+		device_unregister(&core->dev);
 	}
 	if (bus->hosttype == BCMA_HOSTTYPE_SOC)
 		platform_device_unregister(bus->drv_cc.watchdog);
+
+	/* Now noone uses internally-handled cores, we can free them */
+	list_for_each_entry_safe(core, tmp, &bus->cores, list) {
+		list_del(&core->list);
+		kfree(core);
+	}
 }
 
 int bcma_bus_register(struct bcma_bus *bus)
@@ -467,7 +474,6 @@ int bcma_bus_register(struct bcma_bus *bus)
 
 void bcma_bus_unregister(struct bcma_bus *bus)
 {
-	struct bcma_device *cores[3];
 	int err;
 
 	err = bcma_gpio_unregister(&bus->drv_cc);
@@ -478,15 +484,7 @@ void bcma_bus_unregister(struct bcma_bus *bus)
 
 	bcma_core_chipcommon_b_free(&bus->drv_cc_b);
 
-	cores[0] = bcma_find_core(bus, BCMA_CORE_MIPS_74K);
-	cores[1] = bcma_find_core(bus, BCMA_CORE_PCIE);
-	cores[2] = bcma_find_core(bus, BCMA_CORE_4706_MAC_GBIT_COMMON);
-
 	bcma_unregister_cores(bus);
-
-	kfree(cores[2]);
-	kfree(cores[1]);
-	kfree(cores[0]);
 }
 
 /*
-- 
1.8.4.5

