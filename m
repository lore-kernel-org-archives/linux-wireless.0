Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:49154 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761245Ab2FHGbP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 02:31:15 -0400
Received: by lban1 with SMTP id n1so1018090lba.10
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 23:31:10 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 5/5] wlcore/wl12xx/wl18xx: make NVS file optional for wl18xx
Date: Fri,  8 Jun 2012 09:30:55 +0300
Message-Id: <1339137055-30095-6-git-send-email-coelho@ti.com> (sfid-20120608_083119_875646_C4AF05A2)
In-Reply-To: <1339137055-30095-1-git-send-email-coelho@ti.com>
References: <1339137055-30095-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Don't spew errors when we can't find the NVS file in wlcore. Instead
fail the wl12xx boot HW op if the NVS isn't found.

Take this opportunity to remove some dead code from register_hw()
which looks for the NVS again needlessly.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/boot.c |    4 +++-
 drivers/net/wireless/ti/wlcore/main.c |   22 ++++++----------------
 2 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/boot.c b/drivers/net/wireless/ti/wlcore/boot.c
index ed718f7..7b8e61e 100644
--- a/drivers/net/wireless/ti/wlcore/boot.c
+++ b/drivers/net/wireless/ti/wlcore/boot.c
@@ -211,8 +211,10 @@ int wlcore_boot_upload_nvs(struct wl1271 *wl)
 	u32 dest_addr, val;
 	u8 *nvs_ptr, *nvs_aligned;
 
-	if (wl->nvs == NULL)
+	if (wl->nvs == NULL) {
+		wl1271_error("NVS file is need during boot");
 		return -ENODEV;
+	}
 
 	if (wl->quirks & WLCORE_QUIRK_LEGACY_NVS) {
 		struct wl1271_nvs_file *nvs =
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 176a311..1156e3f 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -715,7 +715,7 @@ out:
 	return ret;
 }
 
-static int wl1271_fetch_nvs(struct wl1271 *wl)
+static void wl1271_fetch_nvs(struct wl1271 *wl)
 {
 	const struct firmware *fw;
 	int ret;
@@ -723,16 +723,15 @@ static int wl1271_fetch_nvs(struct wl1271 *wl)
 	ret = request_firmware(&fw, WL12XX_NVS_NAME, wl->dev);
 
 	if (ret < 0) {
-		wl1271_error("could not get nvs file %s: %d", WL12XX_NVS_NAME,
-			     ret);
-		return ret;
+		wl1271_debug(DEBUG_BOOT, "could not get nvs file %s: %d",
+			     WL12XX_NVS_NAME, ret);
+		return;
 	}
 
 	wl->nvs = kmemdup(fw->data, fw->size, GFP_KERNEL);
 
 	if (!wl->nvs) {
 		wl1271_error("could not allocate memory for the nvs file");
-		ret = -ENOMEM;
 		goto out;
 	}
 
@@ -740,8 +739,6 @@ static int wl1271_fetch_nvs(struct wl1271 *wl)
 
 out:
 	release_firmware(fw);
-
-	return ret;
 }
 
 void wl12xx_queue_recovery_work(struct wl1271 *wl)
@@ -989,13 +986,6 @@ static int wl12xx_chip_wakeup(struct wl1271 *wl, bool plt)
 	if (ret < 0)
 		goto out;
 
-	/* No NVS from netlink, try to get it from the filesystem */
-	if (wl->nvs == NULL) {
-		ret = wl1271_fetch_nvs(wl);
-		if (ret < 0)
-			goto out;
-	}
-
 out:
 	return ret;
 }
@@ -4937,8 +4927,8 @@ static int wl1271_register_hw(struct wl1271 *wl)
 	if (wl->mac80211_registered)
 		return 0;
 
-	ret = wl1271_fetch_nvs(wl);
-	if (ret == 0) {
+	wl1271_fetch_nvs(wl);
+	if (wl->nvs != NULL) {
 		/* NOTE: The wl->nvs->nvs element must be first, in
 		 * order to simplify the casting, we assume it is at
 		 * the beginning of the wl->nvs structure.
-- 
1.7.10

