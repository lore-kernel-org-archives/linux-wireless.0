Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43673 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab0HKSWL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Aug 2010 14:22:11 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	<linux-omap@vger.kernel.org>
Cc: Ido Yariv <ido@wizery.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	<linux-arm-kernel@lists.infradead.org>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	<akpm@linux-foundation.org>, San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Pandita Vikram <vikram.pandita@ti.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v4 4/8] wireless: wl1271: take irq info from private board data
Date: Wed, 11 Aug 2010 21:21:49 +0300
Message-Id: <1281550913-17633-5-git-send-email-ohad@wizery.com>
In-Reply-To: <1281550913-17633-1-git-send-email-ohad@wizery.com>
References: <1281550913-17633-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the hard coded irq information, and instead take
the irq information from the board's platform data.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/net/wireless/wl12xx/wl1271_sdio.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_sdio.c b/drivers/net/wireless/wl12xx/wl1271_sdio.c
index 68b512b..228f5af 100644
--- a/drivers/net/wireless/wl12xx/wl1271_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1271_sdio.c
@@ -38,9 +38,6 @@
 #include "wl12xx_80211.h"
 #include "wl1271_io.h"
 
-
-#define RX71_WL1271_IRQ_GPIO		42
-
 #ifndef SDIO_VENDOR_ID_TI
 #define SDIO_VENDOR_ID_TI		0x0097
 #endif
@@ -191,6 +188,7 @@ static int wl1271_plat_probe(struct platform_device *pdev)
 	struct wl12xx_platform_data *pdata;
 	struct platform_driver *pdriver;
 	struct wl12xx_plat_instance *pinstance;
+	int irq;
 
 	pdata = pdev->dev.platform_data;
 	if (!pdata) {
@@ -198,6 +196,13 @@ static int wl1271_plat_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		wl1271_error("no platform irq data");
+		return -ENODEV;
+	}
+	pdata->irq = irq;
+
 	pdriver = container_of(pdev->dev.driver, struct platform_driver,
 								driver);
 	pinstance = container_of(pdriver, struct wl12xx_plat_instance, pdriver);
@@ -290,12 +295,7 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 		goto out_free;
 	}
 
-	wl->irq = gpio_to_irq(RX71_WL1271_IRQ_GPIO);
-	if (wl->irq < 0) {
-		ret = wl->irq;
-		wl1271_error("could not get irq!");
-		goto put_data;
-	}
+	wl->irq = wlan_data->irq;
 
 	ret = request_irq(wl->irq, wl1271_irq, 0, DRIVER_NAME, wl);
 	if (ret < 0) {
-- 
1.7.0.4

