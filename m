Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44704 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab0HKNTp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Aug 2010 09:19:45 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	<akpm@linux-foundation.org>, Ido Yariv <ido@wizery.com>,
	San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Gao Yunpeng <yunpeng.gao@intel.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [RFC/PATCH 6/6] wireless: wl1271_sdio: enable Runtime PM
Date: Wed, 11 Aug 2010 16:19:30 +0300
Message-Id: <1281532770-27545-7-git-send-email-ohad@wizery.com>
In-Reply-To: <1281532770-27545-1-git-send-email-ohad@wizery.com>
References: <1281532770-27545-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable runtime pm for the wl1271 SDIO device.

We request power whenever the WLAN interface is brought up,
and release it after the WLAN interface is taken down.

As a result, power is released immediately after probe returns,
since at that point power has not been explicitly requested yet
(i.e. the WLAN interface is still down).

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/net/wireless/wl12xx/wl1271_sdio.c |   37 ++++++++++++++++++++++++++++-
 1 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_sdio.c b/drivers/net/wireless/wl12xx/wl1271_sdio.c
index bfb18b6..2dede64 100644
--- a/drivers/net/wireless/wl12xx/wl1271_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1271_sdio.c
@@ -33,6 +33,7 @@
 #include <linux/gpio.h>
 #include <linux/platform_device.h>
 #include <linux/completion.h>
+#include <linux/pm_runtime.h>
 
 #include "wl1271.h"
 #include "wl12xx_80211.h"
@@ -156,20 +157,23 @@ static void wl1271_sdio_raw_write(struct wl1271 *wl, int addr, void *buf,
 static int wl1271_sdio_set_power(struct wl1271 *wl, bool enable)
 {
 	struct sdio_func *func = wl_to_func(wl);
+	int err;
 
 	/* Let the SDIO stack handle wlan_enable control, so we
 	 * keep host claimed while wlan is in use to keep wl1271
 	 * alive.
 	 */
 	if (enable) {
+		err = pm_runtime_get_sync(&func->dev);
 		sdio_claim_host(func);
 		sdio_enable_func(func);
 	} else {
 		sdio_disable_func(func);
 		sdio_release_host(func);
+		err = pm_runtime_put_sync(&func->dev);
 	}
 
-	return 0;
+	return err;
 }
 
 static struct wl1271_if_operations sdio_ops = {
@@ -318,10 +322,23 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 
 	sdio_set_drvdata(func, wl);
 
+	/* indicate to Runtime PM core that our device is active */
+	ret = pm_runtime_set_active(&func->dev);
+	if (ret)
+		goto unreg_hw;
+
+	/* enable Runtime PM.
+	 * When probe will return, runtime pm will immediately release power
+	 * for us since we call pm_runtime_get() only when the user brings up
+	 * the WLAN interface */
+	pm_runtime_enable(&func->dev);
+
 	wl1271_notice("initialized");
 
 	return 0;
 
+unreg_hw:
+	wl1271_unregister_hw(wl);
 out_irq:
 	free_irq(wl->irq, wl);
 put_data:
@@ -346,11 +363,29 @@ static void __devexit wl1271_remove(struct sdio_func *func)
 	wl1271_free_hw(wl);
 }
 
+static int wl1271_sdio_runtime_suspend(struct device *dev)
+{
+	return 0;
+}
+
+static int wl1271_sdio_runtime_resume(struct device *dev)
+{
+	return 0;
+}
+
+static const struct dev_pm_ops wl1271_sdio_pm_ops = {
+	.runtime_suspend = wl1271_sdio_runtime_suspend,
+	.runtime_resume = wl1271_sdio_runtime_resume,
+};
+
 static struct sdio_driver wl1271_sdio_driver = {
 	.name		= "wl1271_sdio",
 	.id_table	= wl1271_devices,
 	.probe		= wl1271_probe,
 	.remove		= __devexit_p(wl1271_remove),
+	.drv = {
+		.pm = &wl1271_sdio_pm_ops,
+	},
 };
 
 static int __init wl1271_init(void)
-- 
1.7.0.4

