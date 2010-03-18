Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:33061 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab0CRK1U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 06:27:20 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 06/21] wl1271: Move platform device registration from _spi to _main
Date: Thu, 18 Mar 2010 12:26:31 +0200
Message-Id: <1268908006-16992-7-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
References: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

In order to get the platform device for both SPI and SDIO, move the platform
device registration to wl1271_main.c from wl1271_spi.c.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |   37 +++++++++++++++++++++++++++-
 drivers/net/wireless/wl12xx/wl1271_spi.c  |   31 +----------------------
 2 files changed, 37 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 6501d6e..ad9c491 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -29,6 +29,7 @@
 #include <linux/etherdevice.h>
 #include <linux/vmalloc.h>
 #include <linux/inetdevice.h>
+#include <linux/platform_device.h>
 
 #include "wl1271.h"
 #include "wl12xx_80211.h"
@@ -280,6 +281,21 @@ static struct conf_drv_settings default_conf = {
 	}
 };
 
+static void wl1271_device_release(struct device *dev)
+{
+
+}
+
+static struct platform_device wl1271_device = {
+	.name           = "wl1271",
+	.id             = -1,
+
+	/* device model insists to have a release function */
+	.dev            = {
+		.release = wl1271_device_release,
+	},
+};
+
 static LIST_HEAD(wl_list);
 
 static void wl1271_conf_init(struct wl1271 *wl)
@@ -2025,12 +2041,13 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 {
 	struct ieee80211_hw *hw;
 	struct wl1271 *wl;
-	int i;
+	int i, ret;
 
 	hw = ieee80211_alloc_hw(sizeof(*wl), &wl1271_ops);
 	if (!hw) {
 		wl1271_error("could not alloc ieee80211_hw");
-		return ERR_PTR(-ENOMEM);
+		ret = -ENOMEM;
+		goto err;
 	}
 
 	wl = hw->priv;
@@ -2070,12 +2087,28 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 
 	wl1271_debugfs_init(wl);
 
+	/* Register platform device */
+	ret = platform_device_register(&wl1271_device);
+	if (ret) {
+		wl1271_error("couldn't register platform device");
+		goto err_hw;
+	}
+	dev_set_drvdata(&wl1271_device.dev, wl);
+
+
 	return hw;
+
+err_hw:
+	ieee80211_unregister_hw(wl->hw);
+
+err:
+	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(wl1271_alloc_hw);
 
 int wl1271_free_hw(struct wl1271 *wl)
 {
+	platform_device_unregister(&wl1271_device);
 	ieee80211_unregister_hw(wl->hw);
 
 	wl1271_debugfs_exit(wl);
diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.c b/drivers/net/wireless/wl12xx/wl1271_spi.c
index 0eea733..4c129c7 100644
--- a/drivers/net/wireless/wl12xx/wl1271_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1271_spi.c
@@ -23,7 +23,6 @@
 
 #include <linux/irq.h>
 #include <linux/module.h>
-#include <linux/platform_device.h>
 #include <linux/crc7.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/wl12xx.h>
@@ -332,21 +331,6 @@ static irqreturn_t wl1271_irq(int irq, void *cookie)
 	return IRQ_HANDLED;
 }
 
-static void wl1271_device_release(struct device *dev)
-{
-
-}
-
-static struct platform_device wl1271_device = {
-	.name           = "wl1271",
-	.id             = -1,
-
-	/* device model insists to have a release function */
-	.dev            = {
-		.release = wl1271_device_release,
-	},
-};
-
 static void wl1271_spi_set_power(struct wl1271 *wl, bool enable)
 {
 	if (wl->set_power)
@@ -422,28 +406,18 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 
 	disable_irq(wl->irq);
 
-	ret = platform_device_register(&wl1271_device);
-	if (ret) {
-		wl1271_error("couldn't register platform device");
-		goto out_irq;
-	}
-	dev_set_drvdata(&wl1271_device.dev, wl);
-
 	ret = wl1271_init_ieee80211(wl);
 	if (ret)
-		goto out_platform;
+		goto out_irq;
 
 	ret = wl1271_register_hw(wl);
 	if (ret)
-		goto out_platform;
+		goto out_irq;
 
 	wl1271_notice("initialized");
 
 	return 0;
 
- out_platform:
-	platform_device_unregister(&wl1271_device);
-
  out_irq:
 	free_irq(wl->irq, wl);
 
@@ -457,7 +431,6 @@ static int __devexit wl1271_remove(struct spi_device *spi)
 {
 	struct wl1271 *wl = dev_get_drvdata(&spi->dev);
 
-	platform_device_unregister(&wl1271_device);
 	free_irq(wl->irq, wl);
 
 	wl1271_free_hw(wl);
-- 
1.6.3.3

