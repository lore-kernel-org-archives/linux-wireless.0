Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:45434 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933313AbbBIRmJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2015 12:42:09 -0500
Received: by mail-wg0-f54.google.com with SMTP id y19so2245523wgg.13
        for <linux-wireless@vger.kernel.org>; Mon, 09 Feb 2015 09:42:08 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH RFC] bcma: use two different initcalls if built-in
Date: Mon,  9 Feb 2015 18:42:02 +0100
Message-Id: <1423503722-20819-1-git-send-email-zajec5@gmail.com> (sfid-20150209_184213_753063_D809E99B)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is needed as we can't initialize bus during fs_initcall.
Initialization requires SPROM which depends on NVRAM which depends on
mtd. Since mtd, spi, nand, spi-nor use standard module_init, we have to
do the same in bcma.
Without this we'll try to initialize SPROM without having a ready SPROM
proviver registered using bcma_arch_register_fallback_sprom.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
While this patch seems to work and I can compile bcma as built-in and
module, I'm not too proud of it. I don't really like these #if(n)def
tricks and I'm afraid bcma_modinit may be called even if
bcma_modinit_early failed.

Do you see any better idea of solving this?
---
 drivers/bcma/main.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 9635f10..c394207 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -637,13 +637,25 @@ static int bcma_device_uevent(struct device *dev, struct kobj_uevent_env *env)
 			      core->id.rev, core->id.class);
 }
 
+/* Bus has to be registered early, before any bcma driver */
+static int __init bcma_modinit_early(void)
+{
+	return bus_register(&bcma_bus_type);
+}
+#ifndef MODULE
+fs_initcall(bcma_modinit_early);
+#endif
+
+/* Initialization has to be done later with SPI/mtd/NAND/SPROM available */
 static int __init bcma_modinit(void)
 {
 	int err;
 
-	err = bus_register(&bcma_bus_type);
+#ifdef MODULE
+	err = bcma_modinit_early();
 	if (err)
 		return err;
+#endif
 
 	err = bcma_host_soc_register_driver();
 	if (err) {
@@ -660,7 +672,7 @@ static int __init bcma_modinit(void)
 
 	return err;
 }
-fs_initcall(bcma_modinit);
+module_init(bcma_modinit);
 
 static void __exit bcma_modexit(void)
 {
-- 
1.8.4.5

