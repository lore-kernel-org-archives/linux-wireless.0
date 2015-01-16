Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:50357 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbbAPVrU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 16:47:20 -0500
Received: by mail-wi0-f173.google.com with SMTP id r20so5223917wiv.0
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2015 13:47:19 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	"Saul St. John" <saul.stjohn@gmail.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH RFC] bcma: simplify freeing cores (internal devices structs)
Date: Fri, 16 Jan 2015 22:47:08 +0100
Message-Id: <1421444828-32616-1-git-send-email-zajec5@gmail.com> (sfid-20150116_224723_494408_88736BFF)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
This code was introduced by Saul in
ee91592711ed90a1abfbb1b2ceadded11d685164
bcma: don't leak memory for PCIE, MIPS, GBIT cores

I don't really see reason for making it in so complicated way.
I tested my patch for crashes, but didn't really try kmemleak.
Is my simple solution OK? Or am I missing something? Anyone?
---
 drivers/bcma/main.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index c3c5e0a..58dd582 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -371,6 +371,8 @@ static void bcma_unregister_cores(struct bcma_bus *bus)
 		list_del(&core->list);
 		if (core->dev_registered)
 			device_unregister(&core->dev);
+		else
+			kfree(core);
 	}
 	if (bus->hosttype == BCMA_HOSTTYPE_SOC)
 		platform_device_unregister(bus->drv_cc.watchdog);
@@ -467,7 +469,6 @@ int bcma_bus_register(struct bcma_bus *bus)
 
 void bcma_bus_unregister(struct bcma_bus *bus)
 {
-	struct bcma_device *cores[3];
 	int err;
 
 	err = bcma_gpio_unregister(&bus->drv_cc);
@@ -478,15 +479,7 @@ void bcma_bus_unregister(struct bcma_bus *bus)
 
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

