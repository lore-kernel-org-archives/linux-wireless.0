Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37901 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757095Ab0GFAkr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jul 2010 20:40:47 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	<linux-omap@vger.kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	<akpm@linux-foundation.org>, San Mehat <san@google.com>,
	Ohad Ben-Cohen <ohadb@ti.com>
Subject: [PATCH 11/15] wireless: wl1271: introduce platform device support
Date: Tue,  6 Jul 2010 03:37:42 +0300
Message-Id: <1278376666-3509-12-git-send-email-ohad@wizery.com>
In-Reply-To: <1278376666-3509-1-git-send-email-ohad@wizery.com>
References: <1278376666-3509-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ohad Ben-Cohen <ohadb@ti.com>

Introduce a platform device support which is decoupled
from the life cycle of the sdio function.

The platform device objective is to deliver board-specific
values (like irq, ref_clock, and software card-detect
emulation control).

The driver can then dynamically create (or destroy)
the sdio function whenever the wlan interface is
brought up (or down), as part of the power() operation.

Signed-off-by: Ohad Ben-Cohen <ohadb@ti.com>
---
 drivers/net/wireless/wl12xx/Kconfig       |    1 +
 drivers/net/wireless/wl12xx/wl1271.h      |    1 +
 drivers/net/wireless/wl12xx/wl1271_sdio.c |  185 +++++++++++++++++++++++------
 3 files changed, 150 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
index 337fc7b..8fb7b5a 100644
--- a/drivers/net/wireless/wl12xx/Kconfig
+++ b/drivers/net/wireless/wl12xx/Kconfig
@@ -66,6 +66,7 @@ config WL1271_SPI
 config WL1271_SDIO
 	tristate "TI wl1271 SDIO support"
 	depends on WL1271 && MMC && ARM
+	select MMC_EMBEDDED_SDIO
 	---help---
 	  This module adds support for the SDIO interface of adapters using
 	  TI wl1271 chipset.  Select this if your platform is using
diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 5250361..2df57cc 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -352,6 +352,7 @@ struct wl1271 {
 	bool mac80211_registered;
 
 	void *if_priv;
+	void *if_plat_priv;
 
 	struct wl1271_if_operations *if_ops;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_sdio.c b/drivers/net/wireless/wl12xx/wl1271_sdio.c
index 571c6b9..96b8fc3 100644
--- a/drivers/net/wireless/wl12xx/wl1271_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1271_sdio.c
@@ -28,6 +28,10 @@
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/sdio_ids.h>
 #include <linux/mmc/card.h>
+#include <linux/mmc/host.h>
+#include <linux/completion.h>
+#include <linux/wl12xx.h>
+#include <linux/platform_device.h>
 #include <plat/gpio.h>
 
 #include "wl1271.h"
@@ -36,6 +40,7 @@
 
 
 #define RX71_WL1271_IRQ_GPIO		42
+static DECLARE_COMPLETION(wl1271_sdio_ready);
 
 static const struct sdio_device_id wl1271_devices[] = {
 	{ SDIO_DEVICE(SDIO_VENDOR_ID_TI, SDIO_DEVICE_ID_TI_WL1271) },
@@ -50,7 +55,9 @@ static inline struct sdio_func *wl_to_func(struct wl1271 *wl)
 
 static struct device *wl1271_sdio_wl_to_dev(struct wl1271 *wl)
 {
-	return &(wl_to_func(wl)->dev);
+	struct platform_device *pdev = wl->if_plat_priv;
+
+	return &pdev->dev;
 }
 
 static irqreturn_t wl1271_irq(int irq, void *cookie)
@@ -146,21 +153,44 @@ static void wl1271_sdio_raw_write(struct wl1271 *wl, int addr, void *buf,
 
 static int wl1271_sdio_set_power(struct wl1271 *wl, bool enable)
 {
-	struct sdio_func *func = wl_to_func(wl);
+	int ret = 0, timeleft;
 
-	/* Let the SDIO stack handle wlan_enable control, so we
-	 * keep host claimed while wlan is in use to keep wl1271
-	 * alive.
-	 */
 	if (enable) {
-		sdio_claim_host(func);
-		sdio_enable_func(func);
+		/* save our wl struct as private mmc data */
+		wl->set_embedded_data(wl);
+
+		INIT_COMPLETION(wl1271_sdio_ready);
+		/* 1271 Power Up Sequence */
+		wl->set_power(true);
+		mdelay(15);
+		wl->set_power(false);
+		mdelay(1);
+		wl->set_power(true);
+		mdelay(70);
+
+		/* emulate card detect event */
+		wl->set_carddetect(true);
+
 	} else {
-		sdio_disable_func(func);
-		sdio_release_host(func);
+		wl->set_embedded_data(NULL);
+
+		INIT_COMPLETION(wl1271_sdio_ready);
+
+		wl->set_power(false);
+		mdelay(10);
+
+		wl->set_carddetect(false);
 	}
 
-	return 0;
+	timeleft = wait_for_completion_interruptible_timeout(&wl1271_sdio_ready,
+						msecs_to_jiffies(5000));
+	if (timeleft <= 0) {
+		wl1271_error("%s: unsuccessful SDIO %s (%d)", __func__,
+				enable ? "init" : "deinit", timeleft);
+		ret = (timeleft == 0 ? -EAGAIN : timeleft);
+	}
+
+	return ret;
 }
 
 static struct wl1271_if_operations sdio_ops = {
@@ -174,30 +204,97 @@ static struct wl1271_if_operations sdio_ops = {
 	.disable_irq	= wl1271_sdio_disable_interrupts
 };
 
-static int __devinit wl1271_probe(struct sdio_func *func,
+static int wl1271_sdio_probe(struct sdio_func *func,
 				  const struct sdio_device_id *id)
 {
+	struct wl1271 *wl = mmc_get_embedded_data(func->card->host);
+
+	/* 2nd func is WLAN, make sure wl context is received */
+	if (func->num != 0x02 || !wl)
+		return -ENODEV;
+
+	sdio_set_drvdata(func, wl);
+
+	wl->if_priv = func;
+
+	/* Grab access to FN0 for ELP reg. */
+	func->card->quirks |= MMC_QUIRK_LENIENT_FN0;
+
+	sdio_claim_host(func);
+	sdio_enable_func(func);
+
+	complete(&wl1271_sdio_ready);
+
+	return 0;
+}
+
+static void wl1271_sdio_remove(struct sdio_func *func)
+{
+	struct wl1271 *wl = sdio_get_drvdata(func);
+
+	wl->if_priv = NULL;
+
+	sdio_disable_func(func);
+	sdio_release_host(func);
+
+	complete(&wl1271_sdio_ready);
+}
+
+static struct sdio_driver wl1271_sdio_driver = {
+	.name		= "wl1271_sdio_func",
+	.id_table	= wl1271_devices,
+	.probe		= wl1271_sdio_probe,
+	.remove		= wl1271_sdio_remove,
+};
+
+static int wl1271_plat_probe(struct platform_device *pdev)
+{
+	struct wl12xx_platform_data *pdata;
 	struct ieee80211_hw *hw;
 	struct wl1271 *wl;
 	int ret;
 
-	/* We are only able to handle the wlan function */
-	if (func->num != 0x02)
+	pdata = pdev->dev.platform_data;
+	if (!pdata) {
+		wl1271_error("no platform data");
 		return -ENODEV;
+	}
 
 	hw = wl1271_alloc_hw();
-	if (IS_ERR(hw))
+	if (IS_ERR(hw)) {
+		wl1271_error("wl1271_alloc_hw failed: %ld", PTR_ERR(hw));
 		return PTR_ERR(hw);
+	}
 
 	wl = hw->priv;
 
-	wl->if_priv = func;
 	wl->if_ops = &sdio_ops;
+	wl->if_plat_priv = pdev;
+	platform_set_drvdata(pdev, wl);
 
-	/* Grab access to FN0 for ELP reg. */
-	func->card->quirks |= MMC_QUIRK_LENIENT_FN0;
+	wl->set_embedded_data = pdata->set_embedded_data;
+	if (!wl->set_embedded_data) {
+		wl1271_error("set embedded_data func missing in platform data");
+		ret = -ENODEV;
+		goto out_free;
+	}
+
+	wl->set_carddetect = pdata->set_carddetect;
+	if (!wl->set_carddetect) {
+		wl1271_error("set carddetect func missing in platform data");
+		ret = -ENODEV;
+		goto out_free;
+	}
 
 	wl->irq = gpio_to_irq(RX71_WL1271_IRQ_GPIO);
+
+	wl->set_power = pdata->set_power;
+	if (!wl->set_power) {
+		wl1271_error("set power function missing in platform data");
+		ret = -ENODEV;
+		goto out_free;
+	}
+
 	if (wl->irq < 0) {
 		ret = wl->irq;
 		wl1271_error("could not get irq!");
@@ -215,53 +312,67 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 	disable_irq(wl->irq);
 
 	ret = wl1271_init_ieee80211(wl);
-	if (ret)
+	if (ret) {
+		wl1271_error("wl1271_init_ieee80211 failed: %d", ret);
 		goto out_irq;
+	}
 
 	ret = wl1271_register_hw(wl);
-	if (ret)
+	if (ret) {
+		wl1271_error("wl1271_register_hw failed: %d", ret);
 		goto out_irq;
+	}
 
-	sdio_set_drvdata(func, wl);
+	ret = sdio_register_driver(&wl1271_sdio_driver);
+	if (ret < 0) {
+		wl1271_error("failed to register sdio driver: %d", ret);
+		goto out_hw;
+	}
 
 	wl1271_notice("initialized");
 
 	return 0;
 
- out_irq:
+out_hw:
+	wl1271_unregister_hw(wl);
+out_irq:
 	free_irq(wl->irq, wl);
-
-
- out_free:
+out_free:
 	wl1271_free_hw(wl);
-
 	return ret;
 }
 
-static void __devexit wl1271_remove(struct sdio_func *func)
+static int __devexit wl1271_plat_remove(struct platform_device *pdev)
 {
-	struct wl1271 *wl = sdio_get_drvdata(func);
+	struct wl1271 *wl = platform_get_drvdata(pdev);
 
-	free_irq(wl->irq, wl);
+	sdio_unregister_driver(&wl1271_sdio_driver);
 
 	wl1271_unregister_hw(wl);
+
+	free_irq(wl->irq, wl);
+
 	wl1271_free_hw(wl);
+
+	return 0;
 }
 
-static struct sdio_driver wl1271_sdio_driver = {
-	.name		= "wl1271_sdio",
-	.id_table	= wl1271_devices,
-	.probe		= wl1271_probe,
-	.remove		= __devexit_p(wl1271_remove),
+static struct platform_driver wl1271_plat_driver = {
+	.probe = wl1271_plat_probe,
+	.remove = __devexit_p(wl1271_plat_remove),
+	.driver = {
+		.name		= "wl1271_sdio",
+		.owner		= THIS_MODULE,
+	},
 };
 
 static int __init wl1271_init(void)
 {
 	int ret;
 
-	ret = sdio_register_driver(&wl1271_sdio_driver);
+	ret = platform_driver_register(&wl1271_plat_driver);
 	if (ret < 0) {
-		wl1271_error("failed to register sdio driver: %d", ret);
+		wl1271_error("failed to register plat driver: %d", ret);
 		goto out;
 	}
 
@@ -271,7 +382,7 @@ out:
 
 static void __exit wl1271_exit(void)
 {
-	sdio_unregister_driver(&wl1271_sdio_driver);
+	platform_driver_unregister(&wl1271_plat_driver);
 
 	wl1271_notice("unloaded");
 }
-- 
1.7.0.4

