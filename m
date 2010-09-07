Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38699 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab0IGBYB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Sep 2010 21:24:01 -0400
Received: by bwz11 with SMTP id 11so3713457bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Sep 2010 18:24:00 -0700 (PDT)
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH] wl1271: sdio: claim host only when doing IO
Date: Tue,  7 Sep 2010 04:24:21 +0300
Message-Id: <1283822661-16018-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not maintain a persistent sdio_claim_host state. Instead,
claim host before doing IO and release host soon after.

This fixes several mmc deadlock scenarios, e.g. during
suspend/resume.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/net/wireless/wl12xx/wl1271_sdio.c |   43 +++++++++++++++++++++++-----
 1 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_sdio.c b/drivers/net/wireless/wl12xx/wl1271_sdio.c
index 7059b5c..b3c3158 100644
--- a/drivers/net/wireless/wl12xx/wl1271_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1271_sdio.c
@@ -107,6 +107,8 @@ static void wl1271_sdio_raw_read(struct wl1271 *wl, int addr, void *buf,
 	int ret;
 	struct sdio_func *func = wl_to_func(wl);
 
+	sdio_claim_host(func);
+
 	if (unlikely(addr == HW_ACCESS_ELP_CTRL_REG_ADDR)) {
 		((u8 *)buf)[0] = sdio_f0_readb(func, addr, &ret);
 		wl1271_debug(DEBUG_SDIO, "sdio read 52 addr 0x%x, byte 0x%02x",
@@ -122,9 +124,10 @@ static void wl1271_sdio_raw_read(struct wl1271 *wl, int addr, void *buf,
 		wl1271_dump_ascii(DEBUG_SDIO, "data: ", buf, len);
 	}
 
+	sdio_release_host(func);
+
 	if (ret)
 		wl1271_error("sdio read failed (%d)", ret);
-
 }
 
 static void wl1271_sdio_raw_write(struct wl1271 *wl, int addr, void *buf,
@@ -133,6 +136,8 @@ static void wl1271_sdio_raw_write(struct wl1271 *wl, int addr, void *buf,
 	int ret;
 	struct sdio_func *func = wl_to_func(wl);
 
+	sdio_claim_host(func);
+
 	if (unlikely(addr == HW_ACCESS_ELP_CTRL_REG_ADDR)) {
 		sdio_f0_writeb(func, ((u8 *)buf)[0], addr, &ret);
 		wl1271_debug(DEBUG_SDIO, "sdio write 52 addr 0x%x, byte 0x%02x",
@@ -147,9 +152,33 @@ static void wl1271_sdio_raw_write(struct wl1271 *wl, int addr, void *buf,
 		else
 			ret = sdio_memcpy_toio(func, addr, buf, len);
 	}
+
+	sdio_release_host(func);
+
 	if (ret)
 		wl1271_error("sdio write failed (%d)", ret);
+}
+
+static int wl1271_sdio_power_on(struct wl1271 *wl)
+{
+	struct sdio_func *func = wl_to_func(wl);
+
+	sdio_claim_host(func);
+	sdio_enable_func(func);
+	sdio_release_host(func);
 
+	return 0;
+}
+
+static int wl1271_sdio_power_off(struct wl1271 *wl)
+{
+	struct sdio_func *func = wl_to_func(wl);
+
+	sdio_claim_host(func);
+	sdio_disable_func(func);
+	sdio_release_host(func);
+
+	return 0;
 }
 
 static void wl1271_sdio_set_power(struct wl1271 *wl, bool enable)
@@ -160,13 +189,11 @@ static void wl1271_sdio_set_power(struct wl1271 *wl, bool enable)
 	 * keep host claimed while wlan is in use to keep wl1271
 	 * alive.
 	 */
-	if (enable) {
-		sdio_claim_host(func);
-		sdio_enable_func(func);
-	} else {
-		sdio_disable_func(func);
-		sdio_release_host(func);
-	}
+	if (enable)
+		return wl1271_sdio_power_on(wl);
+	else
+		return wl1271_sdio_power_off(wl);
+
 }
 
 static struct wl1271_if_operations sdio_ops = {
-- 
1.7.0.4

