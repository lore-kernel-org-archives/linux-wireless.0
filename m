Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:53565 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759159Ab1JFTLV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 15:11:21 -0400
Received: by mail-bw0-f53.google.com with SMTP id zt12so4381156bkb.26
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2011 12:11:18 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/8] wl12xx: add a platform device to the spi module
Date: Thu,  6 Oct 2011 22:10:55 +0300
Message-Id: <1317928259-26437-5-git-send-email-coelho@ti.com> (sfid-20111006_211125_334821_2FDB1EB8)
In-Reply-To: <1317928259-26437-1-git-send-email-coelho@ti.com>
References: <1317928259-26437-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felipe Balbi <balbi@ti.com>

The platform device will be used to match the platform driver that
will be implemented by the core module.

Signed-off-by: Felipe Balbi <balbi@ti.com>
[forward-ported, cleaned-up and rephrased commit message]
[call platform_device_add() instead of platform_device_register()]
[store alloc'ed device platform directly in glue->core]
[fixed the length of memset(res...)]
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/spi.c |   44 +++++++++++++++++++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index 16f0c71..e075d69 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -27,6 +27,7 @@
 #include <linux/crc7.h>
 #include <linux/spi/spi.h>
 #include <linux/wl12xx.h>
+#include <linux/platform_device.h>
 #include <linux/slab.h>
 
 #include "wl12xx.h"
@@ -72,6 +73,7 @@
 struct wl12xx_spi_glue {
 	struct device *dev;
 	struct wl1271 *wl;
+	struct platform_device *core;
 };
 
 static inline struct wl12xx_spi_glue *wl_to_glue(struct wl1271 *wl)
@@ -376,6 +378,7 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 	struct wl12xx_platform_data *pdata;
 	struct ieee80211_hw *hw;
 	struct wl1271 *wl;
+	struct resource res[1];
 	unsigned long irqflags;
 	int ret = -ENOMEM;
 
@@ -458,8 +461,47 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 	if (ret)
 		goto out_irq;
 
+	glue->core = platform_device_alloc("wl12xx-spi", -1);
+	if (!glue->core) {
+		dev_err(&spi->dev, "can't allocate platform_device\n");
+		ret = -ENOMEM;
+		goto out_unreg_hw;
+	}
+
+	glue->core->dev.parent = &spi->dev;
+
+	memset(res, 0x00, sizeof(res));
+
+	res[0].start = spi->irq;
+	res[0].flags = IORESOURCE_IRQ;
+	res[0].name = "irq";
+
+	ret = platform_device_add_resources(glue->core, res, ARRAY_SIZE(res));
+	if (ret) {
+		wl1271_error("can't add resources");
+		goto out_dev_put;
+	}
+
+	ret = platform_device_add_data(glue->core, pdata, sizeof(*pdata));
+	if (ret) {
+		wl1271_error("can't add platform data");
+		goto out_dev_put;
+	}
+
+	ret = platform_device_add(glue->core);
+	if (ret) {
+		wl1271_error("can't register platform device");
+		goto out_dev_put;
+	}
+
 	return 0;
 
+out_dev_put:
+	platform_device_put(glue->core);
+
+out_unreg_hw:
+	wl1271_unregister_hw(wl);
+
 out_irq:
 	free_irq(wl->irq, wl);
 
@@ -480,6 +522,8 @@ static int __devexit wl1271_remove(struct spi_device *spi)
 	wl1271_unregister_hw(wl);
 	free_irq(wl->irq, wl);
 	wl1271_free_hw(wl);
+	platform_device_del(glue->core);
+	platform_device_put(glue->core);
 	kfree(glue);
 
 	return 0;
-- 
1.7.1

