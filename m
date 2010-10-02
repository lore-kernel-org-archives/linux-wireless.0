Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33923 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab0JBL5j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 07:57:39 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-mmc@vger.kernel.org>, <linux-wireless@vger.kernel.org>
Cc: Chris Ball <cjb@laptop.org>, Nicolas Pitre <nico@fluxnic.net>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v2 10/11] wl1271: sdio: enable runtime PM
Date: Sat,  2 Oct 2010 13:54:14 +0200
Message-Id: <1286020455-28946-11-git-send-email-ohad@wizery.com>
In-Reply-To: <1286020455-28946-1-git-send-email-ohad@wizery.com>
References: <1286020455-28946-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable runtime PM for the wl1271 SDIO device.

We request power whenever the WLAN interface is brought up,
and release it after the WLAN interface is taken down.

As a result, power is released immediately after probe returns,
since at that point power has not been explicitly requested yet
(i.e. the WLAN interface is still down).

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Acked-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_sdio.c |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_sdio.c b/drivers/net/wireless/wl12xx/wl1271_sdio.c
index 4c250d7..f7bef32 100644
--- a/drivers/net/wireless/wl12xx/wl1271_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1271_sdio.c
@@ -30,6 +30,7 @@
 #include <linux/mmc/card.h>
 #include <linux/gpio.h>
 #include <linux/wl12xx.h>
+#include <linux/pm_runtime.h>
 
 #include "wl1271.h"
 #include "wl12xx_80211.h"
@@ -160,12 +161,19 @@ static void wl1271_sdio_raw_write(struct wl1271 *wl, int addr, void *buf,
 static int wl1271_sdio_power_on(struct wl1271 *wl)
 {
 	struct sdio_func *func = wl_to_func(wl);
+	int ret;
+
+	/* Power up the card */
+	ret = pm_runtime_get_sync(&func->dev);
+	if (ret < 0)
+		goto out;
 
 	sdio_claim_host(func);
 	sdio_enable_func(func);
 	sdio_release_host(func);
 
-	return 0;
+out:
+	return ret;
 }
 
 static int wl1271_sdio_power_off(struct wl1271 *wl)
@@ -176,15 +184,12 @@ static int wl1271_sdio_power_off(struct wl1271 *wl)
 	sdio_disable_func(func);
 	sdio_release_host(func);
 
-	return 0;
+	/* Power down the card */
+	return pm_runtime_put_sync(&func->dev);
 }
 
 static int wl1271_sdio_set_power(struct wl1271 *wl, bool enable)
 {
-	/* Let the SDIO stack handle wlan_enable control, so we
-	 * keep host claimed while wlan is in use to keep wl1271
-	 * alive.
-	 */
 	if (enable)
 		return wl1271_sdio_power_on(wl);
 	else
@@ -256,6 +261,9 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 
 	sdio_set_drvdata(func, wl);
 
+	/* Tell PM core that we don't need the card to be powered now */
+	pm_runtime_put_noidle(&func->dev);
+
 	wl1271_notice("initialized");
 
 	return 0;
@@ -274,6 +282,9 @@ static void __devexit wl1271_remove(struct sdio_func *func)
 {
 	struct wl1271 *wl = sdio_get_drvdata(func);
 
+	/* Undo decrement done above in wl1271_probe */
+	pm_runtime_get_noresume(&func->dev);
+
 	wl1271_unregister_hw(wl);
 	free_irq(wl->irq, wl);
 	wl1271_free_hw(wl);
-- 
1.7.0.4

