Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38062 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266Ab0KHNaH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Nov 2010 08:30:07 -0500
Received: by fxm16 with SMTP id 16so3971185fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 08 Nov 2010 05:30:06 -0800 (PST)
From: Grazvydas Ignotas <notasas@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@adurom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCHv2 2/3] wl1251: add runtime PM support for SDIO
Date: Mon,  8 Nov 2010 15:29:36 +0200
Message-Id: <1289222976-19793-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add runtime PM support, similar to how it's done for wl1271.
This allows to power down the card when the driver is loaded but
network is not in use.

Cc: Ohad Ben-Cohen <ohad@wizery.com>
Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/net/wireless/wl1251/sdio.c |   64 ++++++++++++++++++++++++++++++++++--
 1 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl1251/sdio.c b/drivers/net/wireless/wl1251/sdio.c
index 0285190..f3e185e 100644
--- a/drivers/net/wireless/wl1251/sdio.c
+++ b/drivers/net/wireless/wl1251/sdio.c
@@ -26,6 +26,7 @@
 #include <linux/platform_device.h>
 #include <linux/wl12xx.h>
 #include <linux/irq.h>
+#include <linux/pm_runtime.h>
 
 #include "wl1251.h"
 
@@ -173,10 +174,40 @@ static void wl1251_disable_line_irq(struct wl1251 *wl)
 
 static int wl1251_sdio_set_power(struct wl1251 *wl, bool enable)
 {
-	if (wl->set_power)
-		wl->set_power(enable);
+	struct sdio_func *func = wl_to_func(wl);
+	int ret;
 
-	return 0;
+	if (enable) {
+		/*
+		 * Power is controlled by runtime PM, but we still call board
+		 * callback in case it wants to do any additional setup,
+		 * for example enabling clock buffer for the module.
+		 */
+		if (wl->set_power)
+			wl->set_power(true);
+
+		ret = pm_runtime_get_sync(&func->dev);
+		if (ret < 0)
+			goto out;
+
+		sdio_claim_host(func);
+		sdio_enable_func(func);
+		sdio_release_host(func);
+	} else {
+		sdio_claim_host(func);
+		sdio_disable_func(func);
+		sdio_release_host(func);
+
+		ret = pm_runtime_put_sync(&func->dev);
+		if (ret < 0)
+			goto out;
+
+		if (wl->set_power)
+			wl->set_power(false);
+	}
+
+out:
+	return ret;
 }
 
 static struct wl1251_if_operations wl1251_sdio_ops = {
@@ -277,6 +308,10 @@ static int wl1251_sdio_probe(struct sdio_func *func,
 		goto out_free_irq;
 
 	sdio_set_drvdata(func, wl);
+
+	/* Tell PM core that we don't need the card to be powered now */
+	pm_runtime_put_noidle(&func->dev);
+
 	return ret;
 
 out_free_irq:
@@ -298,6 +333,9 @@ static void __devexit wl1251_sdio_remove(struct sdio_func *func)
 	struct wl1251 *wl = sdio_get_drvdata(func);
 	struct wl1251_sdio *wl_sdio = wl->if_priv;
 
+	/* Undo decrement done above in wl1251_probe */
+	pm_runtime_get_noresume(&func->dev);
+
 	if (wl->irq)
 		free_irq(wl->irq, wl);
 	kfree(wl_sdio);
@@ -309,11 +347,31 @@ static void __devexit wl1251_sdio_remove(struct sdio_func *func)
 	sdio_release_host(func);
 }
 
+static int wl1251_suspend(struct device *dev)
+{
+	/*
+	 * Tell MMC/SDIO core it's OK to power down the card
+	 * (if it isn't already), but not to remove it completely.
+	 */
+	return 0;
+}
+
+static int wl1251_resume(struct device *dev)
+{
+	return 0;
+}
+
+static const struct dev_pm_ops wl1251_sdio_pm_ops = {
+	.suspend        = wl1251_suspend,
+	.resume         = wl1251_resume,
+};
+
 static struct sdio_driver wl1251_sdio_driver = {
 	.name		= "wl1251_sdio",
 	.id_table	= wl1251_devices,
 	.probe		= wl1251_sdio_probe,
 	.remove		= __devexit_p(wl1251_sdio_remove),
+	.drv.pm		= &wl1251_sdio_pm_ops,
 };
 
 static int __init wl1251_sdio_init(void)
-- 
1.6.3.3

