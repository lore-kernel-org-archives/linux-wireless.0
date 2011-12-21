Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46643 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752773Ab1LULlS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 06:41:18 -0500
Received: by lahd3 with SMTP id d3so505084lah.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 03:41:17 -0800 (PST)
From: Pontus Fuchs <pontus.fuchs@gmail.com>
To: ohad@wizery.com, ido@wizery.com, coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] wl12xx: Fix power control for CONFIG_RUNTIME_PM off configurations
Date: Wed, 21 Dec 2011 12:41:02 +0100
Message-Id: <1324467662-10065-1-git-send-email-pontus.fuchs@gmail.com> (sfid-20111221_124125_205849_E3E6ED7F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On rmmod wl12xx will leave the sdio host powered off, regardless
off runtime PM being enabled or not. This leads to probe failure on
a second insmod, if runtime pm is disabled, because the sdio core
expects the host to be powered on.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
---
 drivers/net/wireless/wl12xx/sdio.c |   49 ++++++++++++++++++++---------------
 1 files changed, 28 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index 468a505..45115a3 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -117,14 +117,17 @@ static void wl12xx_sdio_raw_write(struct device *child, int addr, void *buf,
 		dev_err(child->parent, "sdio write failed (%d)\n", ret);
 }
 
-static int wl12xx_sdio_power_on(struct wl12xx_sdio_glue *glue)
+static int wl12xx_sdio_power_on(struct sdio_func *func, bool noresume)
 {
-	int ret;
-	struct sdio_func *func = dev_to_sdio_func(glue->dev);
+	int ret = 0;
 
 	/* If enabled, tell runtime PM not to power off the card */
 	if (pm_runtime_enabled(&func->dev)) {
-		ret = pm_runtime_get_sync(&func->dev);
+		if (noresume)
+			pm_runtime_get_noresume(&func->dev);
+		else
+			ret = pm_runtime_get_sync(&func->dev);
+
 		if (ret < 0)
 			goto out;
 	} else {
@@ -134,20 +137,13 @@ static int wl12xx_sdio_power_on(struct wl12xx_sdio_glue *glue)
 			goto out;
 	}
 
-	sdio_claim_host(func);
-	sdio_enable_func(func);
-
 out:
 	return ret;
 }
 
-static int wl12xx_sdio_power_off(struct wl12xx_sdio_glue *glue)
+static int wl12xx_sdio_power_off(struct sdio_func *func)
 {
 	int ret;
-	struct sdio_func *func = dev_to_sdio_func(glue->dev);
-
-	sdio_disable_func(func);
-	sdio_release_host(func);
 
 	/* Power off the card manually, even if runtime PM is enabled. */
 	ret = mmc_power_save_host(func->card->host);
@@ -164,11 +160,21 @@ static int wl12xx_sdio_power_off(struct wl12xx_sdio_glue *glue)
 static int wl12xx_sdio_set_power(struct device *child, bool enable)
 {
 	struct wl12xx_sdio_glue *glue = dev_get_drvdata(child->parent);
+	struct sdio_func *func = dev_to_sdio_func(glue->dev);
+	int ret;
 
-	if (enable)
-		return wl12xx_sdio_power_on(glue);
-	else
-		return wl12xx_sdio_power_off(glue);
+	if (enable) {
+		ret = wl12xx_sdio_power_on(func, false);
+		if (ret)
+			return ret;
+		sdio_claim_host(func);
+		sdio_enable_func(func);
+		return ret;
+	} else {
+		sdio_disable_func(func);
+		sdio_release_host(func);
+		return wl12xx_sdio_power_off(func);
+	}
 }
 
 static struct wl1271_if_operations sdio_ops = {
@@ -223,8 +229,8 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 
 	sdio_set_drvdata(func, glue);
 
-	/* Tell PM core that we don't need the card to be powered now */
-	pm_runtime_put_noidle(&func->dev);
+	/* Power off as we don't need the card to be powered now */
+	wl12xx_sdio_power_off(func);
 
 	glue->core = platform_device_alloc("wl12xx", -1);
 	if (!glue->core) {
@@ -275,11 +281,12 @@ static void __devexit wl1271_remove(struct sdio_func *func)
 {
 	struct wl12xx_sdio_glue *glue = sdio_get_drvdata(func);
 
-	/* Undo decrement done above in wl1271_probe */
-	pm_runtime_get_noresume(&func->dev);
-
 	platform_device_del(glue->core);
 	platform_device_put(glue->core);
+
+	/* Leave the sdio host in the state it was in before probing */
+	wl12xx_sdio_power_on(func, true);
+
 	kfree(glue);
 }
 
-- 
1.7.5.4

