Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:32823 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824AbbLQTyH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2015 14:54:07 -0500
Received: by mail-lb0-f176.google.com with SMTP id kw15so51896012lbb.0
        for <linux-wireless@vger.kernel.org>; Thu, 17 Dec 2015 11:54:06 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: use module_init for the main part of bus initialization
Date: Thu, 17 Dec 2015 20:53:54 +0100
Message-Id: <1450382034-3976-1-git-send-email-zajec5@gmail.com> (sfid-20151217_205413_978002_56E6C03E)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So far we were using fs_initcall. It was (and still is) needed because
struct bus_type has to be registered early. However main bus
initialization has to happen later as it requires SPROM which depends on
NVRAM which depends on mtd.
Solve it by using fs_initcall only for bus_register call and module_init
for the rest. It affects bcma only when built-in obviously.

This was tested with BCM4706 and BCM5357C0 (BCM47XX), BCM4708A0
(ARCH_BCM_5301X) and BCM43225 (PCIe card with bcma as module).

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
This change was already suggested in RFC patch early this year:
https://patchwork.kernel.org/patch/5802611/

Noone objected / got any better idea, so I'm sending a final version.

V1 (from RFC):
* Use int bcma_bus_registered to avoid #ifdef MODULE and make code simpler.
* Document reason for this behavior better.
---
 drivers/bcma/main.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 59d8d0d..c466f75 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -668,11 +668,36 @@ static int bcma_device_uevent(struct device *dev, struct kobj_uevent_env *env)
 			      core->id.rev, core->id.class);
 }
 
-static int __init bcma_modinit(void)
+static unsigned int bcma_bus_registered;
+
+/*
+ * If built-in, bus has to be registered early, before any driver calls
+ * bcma_driver_register.
+ * Otherwise registering driver would trigger BUG in driver_register.
+ */
+static int __init bcma_init_bus_register(void)
 {
 	int err;
 
+	if (bcma_bus_registered)
+		return 0;
+
 	err = bus_register(&bcma_bus_type);
+	if (!err)
+		bcma_bus_registered = 1;
+
+	return err;
+}
+#ifndef MODULE
+fs_initcall(bcma_init_bus_register);
+#endif
+
+/* Main initialization has to be done with SPI/mtd/NAND/SPROM available */
+static int __init bcma_modinit(void)
+{
+	int err;
+
+	err = bcma_init_bus_register();
 	if (err)
 		return err;
 
@@ -691,7 +716,7 @@ static int __init bcma_modinit(void)
 
 	return err;
 }
-fs_initcall(bcma_modinit);
+module_init(bcma_modinit);
 
 static void __exit bcma_modexit(void)
 {
-- 
1.8.4.5

