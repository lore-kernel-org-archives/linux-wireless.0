Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:42139 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758563AbcIMVvF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Sep 2016 17:51:05 -0400
From: Tony Lindgren <tony@atomide.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Eyal Reizer <eyalr@ti.com>, Guy Mishol <guym@ti.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH 4/5] wlcore: Fix config firmware loading issues
Date: Tue, 13 Sep 2016 14:50:42 -0700
Message-Id: <20160913215043.29454-5-tony@atomide.com> (sfid-20160913_235109_405067_CACEBCC7)
In-Reply-To: <20160913215043.29454-1-tony@atomide.com>
References: <20160913215043.29454-1-tony@atomide.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Booting multiple wl12xx and wl18xx devices using the same rootfs is
a pain. You currently have to symlink the right nvs file depending
on the wl12xx type.

For example, with wl1271-nvs.bin being a symlink to wl127x-nvs.bin
by default and trying to bring up a wl128x based device:

wlcore: ERROR nvs size is not as expected: 1113 != 912
wlcore: ERROR NVS file is needed during boot
wlcore: ERROR NVS file is needed during boot
wlcore: ERROR firmware boot failed despite 3 retries

Note that wl18xx uses a separate config firmware wl18xx-conf.bin
that can be generated with tools using the following two git repos:

git.ti.com/wilink8-wlan/18xx-ti-utils
git.ti.com/wilink8-wlan/wl18xx_fw

So let's not configure the nvs file for wl18xx as it's not needed
AFAIK. If it turns out that we also need the nvs file for wl18xx,
we can just add it to the config firmware data for wl18xx.

Let's fix the issue by using the chip specific config firmware
data, and make sure we produce understandable warnings if something
is missing.

Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/net/wireless/ti/wlcore/boot.c     | 15 ++++++++++----
 drivers/net/wireless/ti/wlcore/main.c     | 34 +++++++++++++++++++++----------
 drivers/net/wireless/ti/wlcore/wlcore_i.h |  7 -------
 3 files changed, 34 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/boot.c b/drivers/net/wireless/ti/wlcore/boot.c
index f75d304..f00509e 100644
--- a/drivers/net/wireless/ti/wlcore/boot.c
+++ b/drivers/net/wireless/ti/wlcore/boot.c
@@ -282,6 +282,9 @@ EXPORT_SYMBOL_GPL(wlcore_boot_upload_firmware);
 
 int wlcore_boot_upload_nvs(struct wl1271 *wl)
 {
+	struct platform_device *pdev = wl->pdev;
+	struct wlcore_platdev_data *pdev_data = dev_get_platdata(&pdev->dev);
+	const char *nvs_name = "unknown";
 	size_t nvs_len, burst_len;
 	int i;
 	u32 dest_addr, val;
@@ -293,6 +296,9 @@ int wlcore_boot_upload_nvs(struct wl1271 *wl)
 		return -ENODEV;
 	}
 
+	if (pdev_data && pdev_data->family)
+		nvs_name = pdev_data->family->nvs_name;
+
 	if (wl->quirks & WLCORE_QUIRK_LEGACY_NVS) {
 		struct wl1271_nvs_file *nvs =
 			(struct wl1271_nvs_file *)wl->nvs;
@@ -310,8 +316,9 @@ int wlcore_boot_upload_nvs(struct wl1271 *wl)
 		if (wl->nvs_len != sizeof(struct wl1271_nvs_file) &&
 		    (wl->nvs_len != WL1271_INI_LEGACY_NVS_FILE_SIZE ||
 		     wl->enable_11a)) {
-			wl1271_error("nvs size is not as expected: %zu != %zu",
-				wl->nvs_len, sizeof(struct wl1271_nvs_file));
+			wl1271_error("%s size is not as expected: %zu != %zu",
+				     nvs_name, wl->nvs_len,
+				     sizeof(struct wl1271_nvs_file));
 			kfree(wl->nvs);
 			wl->nvs = NULL;
 			wl->nvs_len = 0;
@@ -328,8 +335,8 @@ int wlcore_boot_upload_nvs(struct wl1271 *wl)
 			if (nvs->general_params.dual_mode_select)
 				wl->enable_11a = true;
 		} else {
-			wl1271_error("nvs size is not as expected: %zu != %zu",
-				     wl->nvs_len,
+			wl1271_error("%s size is not as expected: %zu != %zu",
+				     nvs_name, wl->nvs_len,
 				     sizeof(struct wl128x_nvs_file));
 			kfree(wl->nvs);
 			wl->nvs = NULL;
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index ef6c15b..7f26299 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -6413,9 +6413,12 @@ static void wlcore_nvs_cb(const struct firmware *fw, void *context)
 			goto out;
 		}
 		wl->nvs_len = fw->size;
-	} else {
+	} else if (pdev_data->family->nvs_name) {
 		wl1271_debug(DEBUG_BOOT, "Could not get nvs file %s",
-			     WL12XX_NVS_NAME);
+			     pdev_data->family->nvs_name);
+		wl->nvs = NULL;
+		wl->nvs_len = 0;
+	} else {
 		wl->nvs = NULL;
 		wl->nvs_len = 0;
 	}
@@ -6510,21 +6513,29 @@ static void wlcore_nvs_cb(const struct firmware *fw, void *context)
 
 int wlcore_probe(struct wl1271 *wl, struct platform_device *pdev)
 {
+	struct wlcore_platdev_data *pdev_data = dev_get_platdata(&pdev->dev);
+	const char *nvs_name;
 	int ret;
 
-	if (!wl->ops || !wl->ptable)
+	if (!wl->ops || !wl->ptable || !pdev_data)
 		return -EINVAL;
 
 	wl->dev = &pdev->dev;
 	wl->pdev = pdev;
 	platform_set_drvdata(pdev, wl);
 
-	ret = request_firmware_nowait(THIS_MODULE, FW_ACTION_HOTPLUG,
-				      WL12XX_NVS_NAME, &pdev->dev, GFP_KERNEL,
-				      wl, wlcore_nvs_cb);
-	if (ret < 0) {
-		wl1271_error("request_firmware_nowait failed: %d", ret);
-		complete_all(&wl->nvs_loading_complete);
+	if (pdev_data->family && pdev_data->family->nvs_name) {
+		nvs_name = pdev_data->family->nvs_name;
+		ret = request_firmware_nowait(THIS_MODULE, FW_ACTION_HOTPLUG,
+					      nvs_name, &pdev->dev, GFP_KERNEL,
+					      wl, wlcore_nvs_cb);
+		if (ret < 0) {
+			wl1271_error("request_firmware_nowait failed for %s: %d",
+				     nvs_name, ret);
+			complete_all(&wl->nvs_loading_complete);
+		}
+	} else {
+		wlcore_nvs_cb(NULL, wl);
 	}
 
 	return ret;
@@ -6533,9 +6544,11 @@ EXPORT_SYMBOL_GPL(wlcore_probe);
 
 int wlcore_remove(struct platform_device *pdev)
 {
+	struct wlcore_platdev_data *pdev_data = dev_get_platdata(&pdev->dev);
 	struct wl1271 *wl = platform_get_drvdata(pdev);
 
-	wait_for_completion(&wl->nvs_loading_complete);
+	if (pdev_data->family && pdev_data->family->nvs_name)
+		wait_for_completion(&wl->nvs_loading_complete);
 	if (!wl->initialized)
 		return 0;
 
@@ -6572,4 +6585,3 @@ MODULE_PARM_DESC(no_recovery, "Prevent HW recovery. FW will remain stuck.");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
 MODULE_AUTHOR("Juuso Oikarinen <juuso.oikarinen@nokia.com>");
-MODULE_FIRMWARE(WL12XX_NVS_NAME);
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index f68280d..e840985 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -35,13 +35,6 @@
 #include "conf.h"
 #include "ini.h"
 
-/*
- * wl127x and wl128x are using the same NVS file name. However, the
- * ini parameters between them are different.  The driver validates
- * the correct NVS size in wl1271_boot_upload_nvs().
- */
-#define WL12XX_NVS_NAME "ti-connectivity/wl1271-nvs.bin"
-
 struct wilink_family_data {
 	const char *name;
 	const char *nvs_name;	/* wl12xx nvs file */
-- 
2.9.3
