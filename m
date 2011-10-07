Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:60409 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965366Ab1JGLfL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 07:35:11 -0400
Received: by mail-bw0-f43.google.com with SMTP id s6so5210266bka.2
        for <linux-wireless@vger.kernel.org>; Fri, 07 Oct 2011 04:35:10 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH 1/2] wl12xx: sdio: use dev_dbg instead of wl1271_debug
Date: Fri,  7 Oct 2011 14:34:56 +0300
Message-Id: <1317987297-18172-1-git-send-email-coelho@ti.com> (sfid-20111007_133520_086817_AE40D0AE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To prevent a useless dependency between the sdio module and the wl12xx
module, we need to replace the wl1271_debug macros (and friends) for
dev_dbg and other equivalents.

At the same time, remove the SDIO data hexdump, since this produces
way too much data and is not particularly useful.  There's not
print_hex_dump() equivalent for dynamic debug, so it's hard to control
when the dumps are printed out.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/sdio.c |   47 ++++++++++++++++-------------------
 1 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index 55c63ad..50fdd9b 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -34,7 +34,6 @@
 #include <linux/pm_runtime.h>
 
 #include "wl12xx.h"
-#include "debug.h"
 #include "wl12xx_80211.h"
 #include "io.h"
 
@@ -77,21 +76,20 @@ static void wl12xx_sdio_raw_read(struct device *child, int addr, void *buf,
 
 	if (unlikely(addr == HW_ACCESS_ELP_CTRL_REG_ADDR)) {
 		((u8 *)buf)[0] = sdio_f0_readb(func, addr, &ret);
-		wl1271_debug(DEBUG_SDIO, "sdio read 52 addr 0x%x, byte 0x%02x",
-			     addr, ((u8 *)buf)[0]);
+		dev_dbg(child->parent, "sdio read 52 addr 0x%x, byte 0x%02x\n",
+			addr, ((u8 *)buf)[0]);
 	} else {
 		if (fixed)
 			ret = sdio_readsb(func, buf, addr, len);
 		else
 			ret = sdio_memcpy_fromio(func, buf, addr, len);
 
-		wl1271_debug(DEBUG_SDIO, "sdio read 53 addr 0x%x, %zu bytes",
-			     addr, len);
-		wl1271_dump_ascii(DEBUG_SDIO, "data: ", buf, len);
+		dev_dbg(child->parent, "sdio read 53 addr 0x%x, %zu bytes\n",
+			addr, len);
 	}
 
 	if (ret)
-		wl1271_error("sdio read failed (%d)", ret);
+		dev_err(child->parent, "sdio read failed (%d)\n", ret);
 }
 
 static void wl12xx_sdio_raw_write(struct device *child, int addr, void *buf,
@@ -103,12 +101,11 @@ static void wl12xx_sdio_raw_write(struct device *child, int addr, void *buf,
 
 	if (unlikely(addr == HW_ACCESS_ELP_CTRL_REG_ADDR)) {
 		sdio_f0_writeb(func, ((u8 *)buf)[0], addr, &ret);
-		wl1271_debug(DEBUG_SDIO, "sdio write 52 addr 0x%x, byte 0x%02x",
-			     addr, ((u8 *)buf)[0]);
+		dev_dbg(child->parent, "sdio write 52 addr 0x%x, byte 0x%02x\n",
+			addr, ((u8 *)buf)[0]);
 	} else {
-		wl1271_debug(DEBUG_SDIO, "sdio write 53 addr 0x%x, %zu bytes",
-			     addr, len);
-		wl1271_dump_ascii(DEBUG_SDIO, "data: ", buf, len);
+		dev_dbg(child->parent, "sdio write 53 addr 0x%x, %zu bytes\n",
+			addr, len);
 
 		if (fixed)
 			ret = sdio_writesb(func, addr, buf, len);
@@ -117,7 +114,7 @@ static void wl12xx_sdio_raw_write(struct device *child, int addr, void *buf,
 	}
 
 	if (ret)
-		wl1271_error("sdio write failed (%d)", ret);
+		dev_err(child->parent, "sdio write failed (%d)\n", ret);
 }
 
 static int wl12xx_sdio_power_on(struct wl12xx_sdio_glue *glue)
@@ -196,7 +193,7 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 
 	glue = kzalloc(sizeof(*glue), GFP_KERNEL);
 	if (!glue) {
-		wl1271_error("can't allocate glue");
+		dev_err(&func->dev, "can't allocate glue\n");
 		goto out;
 	}
 
@@ -211,13 +208,13 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 	wlan_data = wl12xx_get_platform_data();
 	if (IS_ERR(wlan_data)) {
 		ret = PTR_ERR(wlan_data);
-		wl1271_error("missing wlan platform data: %d", ret);
+		dev_err(glue->dev, "missing wlan platform data: %d\n", ret);
 		goto out_free_glue;
 	}
 
 	/* if sdio can keep power while host is suspended, enable wow */
 	mmcflags = sdio_get_host_pm_caps(func);
-	wl1271_debug(DEBUG_SDIO, "sdio PM caps = 0x%x", mmcflags);
+	dev_dbg(glue->dev, "sdio PM caps = 0x%x\n", mmcflags);
 
 	if (mmcflags & MMC_PM_KEEP_POWER)
 		wlan_data->pwr_in_suspend = true;
@@ -231,7 +228,7 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 
 	glue->core = platform_device_alloc("wl12xx-sdio", -1);
 	if (!glue->core) {
-		wl1271_error("can't allocate platform_device");
+		dev_err(glue->dev, "can't allocate platform_device");
 		ret = -ENOMEM;
 		goto out_free_glue;
 	}
@@ -246,20 +243,20 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 
 	ret = platform_device_add_resources(glue->core, res, ARRAY_SIZE(res));
 	if (ret) {
-		wl1271_error("can't add resources");
+		dev_err(glue->dev, "can't add resources\n");
 		goto out_dev_put;
 	}
 
 	ret = platform_device_add_data(glue->core, wlan_data,
 				       sizeof(*wlan_data));
 	if (ret) {
-		wl1271_error("can't add platform data");
+		dev_err(glue->dev, "can't add platform data\n");
 		goto out_dev_put;
 	}
 
 	ret = platform_device_add(glue->core);
 	if (ret) {
-		wl1271_error("can't add platform device");
+		dev_err(glue->dev, "can't add platform device\n");
 		goto out_dev_put;
 	}
 	return 0;
@@ -296,15 +293,15 @@ static int wl1271_suspend(struct device *dev)
 	mmc_pm_flag_t sdio_flags;
 	int ret = 0;
 
-	wl1271_debug(DEBUG_MAC80211, "wl1271 suspend. wow_enabled: %d",
-		     wl->wow_enabled);
+	dev_dbg(dev, "wl1271 suspend. wow_enabled: %d\n",
+		wl->wow_enabled);
 
 	/* check whether sdio should keep power */
 	if (wl->wow_enabled) {
 		sdio_flags = sdio_get_host_pm_caps(func);
 
 		if (!(sdio_flags & MMC_PM_KEEP_POWER)) {
-			wl1271_error("can't keep power while host "
+			dev_err(dev, "can't keep power while host \n"
 				     "is suspended");
 			ret = -EINVAL;
 			goto out;
@@ -313,7 +310,7 @@ static int wl1271_suspend(struct device *dev)
 		/* keep power while host suspended */
 		ret = sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
 		if (ret) {
-			wl1271_error("error while trying to keep power");
+			dev_err(dev, "error while trying to keep power\n");
 			goto out;
 		}
 
@@ -329,7 +326,7 @@ static int wl1271_resume(struct device *dev)
 	struct sdio_func *func = dev_to_sdio_func(dev);
 	struct wl1271 *wl = sdio_get_drvdata(func);
 
-	wl1271_debug(DEBUG_MAC80211, "wl1271 resume");
+	dev_dbg(dev, "wl1271 resume\n");
 	if (wl->wow_enabled) {
 		/* claim back host */
 		sdio_claim_host(func);
-- 
1.7.1

