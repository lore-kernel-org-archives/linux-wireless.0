Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:50913 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759093Ab1JFTLV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 15:11:21 -0400
Received: by mail-bw0-f41.google.com with SMTP id zs2so4789869bkb.14
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2011 12:11:16 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/8] wl12xx: add a platform device to the sdio module
Date: Thu,  6 Oct 2011 22:10:54 +0300
Message-Id: <1317928259-26437-4-git-send-email-coelho@ti.com> (sfid-20111006_211123_415129_7999372E)
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
 drivers/net/wireless/wl12xx/sdio.c |   44 ++++++++++++++++++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index c3ddaa6..500704f 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -24,6 +24,7 @@
 #include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/vmalloc.h>
+#include <linux/platform_device.h>
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/sdio_ids.h>
 #include <linux/mmc/card.h>
@@ -47,6 +48,7 @@
 struct wl12xx_sdio_glue {
 	struct device *dev;
 	struct wl1271 *wl;
+	struct platform_device *core;
 };
 
 static const struct sdio_device_id wl1271_devices[] __devinitconst = {
@@ -234,6 +236,7 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 	const struct wl12xx_platform_data *wlan_data;
 	struct wl1271 *wl;
 	struct wl12xx_sdio_glue *glue;
+	struct resource res[1];
 	unsigned long irqflags;
 	mmc_pm_flag_t mmcflags;
 	int ret = -ENOMEM;
@@ -321,8 +324,47 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 	/* Tell PM core that we don't need the card to be powered now */
 	pm_runtime_put_noidle(&func->dev);
 
+	glue->core = platform_device_alloc("wl12xx-sdio", -1);
+	if (!glue->core) {
+		wl1271_error("can't allocate platform_device");
+		ret = -ENOMEM;
+		goto out_unreg_hw;
+	}
+
+	glue->core->dev.parent = &func->dev;
+
+	memset(res, 0x00, sizeof(res));
+
+	res[0].start = wlan_data->irq;
+	res[0].flags = IORESOURCE_IRQ;
+	res[0].name = "irq";
+
+	ret = platform_device_add_resources(glue->core, res, ARRAY_SIZE(res));
+	if (ret) {
+		wl1271_error("can't add resources");
+		goto out_dev_put;
+	}
+
+	ret = platform_device_add_data(glue->core, wlan_data,
+				       sizeof(*wlan_data));
+	if (ret) {
+		wl1271_error("can't add platform data");
+		goto out_dev_put;
+	}
+
+	ret = platform_device_add(glue->core);
+	if (ret) {
+		wl1271_error("can't add platform device");
+		goto out_dev_put;
+	}
 	return 0;
 
+out_dev_put:
+	platform_device_put(glue->core);
+
+out_unreg_hw:
+	wl1271_unregister_hw(wl);
+
 out_irq:
 	free_irq(wl->irq, wl);
 
@@ -350,6 +392,8 @@ static void __devexit wl1271_remove(struct sdio_func *func)
 	}
 	free_irq(wl->irq, wl);
 	wl1271_free_hw(wl);
+	platform_device_del(glue->core);
+	platform_device_put(glue->core);
 	kfree(glue);
 }
 
-- 
1.7.1

