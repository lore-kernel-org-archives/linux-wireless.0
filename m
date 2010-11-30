Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:64954 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052Ab0K3Tvx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 14:51:53 -0500
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-da02.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oAUJpqew017005
	for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 21:51:52 +0200
From: luciano.coelho@nokia.com
To: linux-wireless@vger.kernel.org
Cc: luciano.coelho@nokia.com, Roger Quadros <roger.quadros@nokia.com>
Subject: [PATCH] wl1271: Add wl1271_load_firmware() and export some functions
Date: Tue, 30 Nov 2010 21:52:28 +0200
Message-Id: <1291146748-8565-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roger Quadros <roger.quadros@nokia.com>

For the SDIO testing module we need to load the firmware but not
boot it. wl1271_load_firmware() is meant to do just the firmware loading part.

We also export some functions so they are usable in the testing module.

Signed-off-by: Roger Quadros <roger.quadros@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/boot.c |   17 ++++++++++++++++-
 drivers/net/wireless/wl12xx/boot.h |    1 +
 drivers/net/wireless/wl12xx/io.c   |    1 +
 3 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index 1eafb81..4a9f929 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -467,7 +467,8 @@ static void wl1271_boot_hw_version(struct wl1271 *wl)
 	wl->hw_pg_ver = (s8)fuse;
 }
 
-int wl1271_boot(struct wl1271 *wl)
+/* uploads NVS and firmware */
+int wl1271_load_firmware(struct wl1271 *wl)
 {
 	int ret = 0;
 	u32 tmp, clk, pause;
@@ -572,6 +573,20 @@ int wl1271_boot(struct wl1271 *wl)
 	if (ret < 0)
 		goto out;
 
+out:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(wl1271_load_firmware);
+
+int wl1271_boot(struct wl1271 *wl)
+{
+	int ret;
+
+	/* upload NVS and firmware */
+	ret = wl1271_load_firmware(wl);
+	if (ret)
+		return ret;
+
 	/* 10.5 start firmware */
 	ret = wl1271_boot_run_firmware(wl);
 	if (ret < 0)
diff --git a/drivers/net/wireless/wl12xx/boot.h b/drivers/net/wireless/wl12xx/boot.h
index c7d7719..d67dcff 100644
--- a/drivers/net/wireless/wl12xx/boot.h
+++ b/drivers/net/wireless/wl12xx/boot.h
@@ -27,6 +27,7 @@
 #include "wl12xx.h"
 
 int wl1271_boot(struct wl1271 *wl);
+int wl1271_load_firmware(struct wl1271 *wl);
 
 #define WL1271_NO_SUBBANDS 8
 #define WL1271_NO_POWER_LEVELS 4
diff --git a/drivers/net/wireless/wl12xx/io.c b/drivers/net/wireless/wl12xx/io.c
index 35c2f1a..d557f73 100644
--- a/drivers/net/wireless/wl12xx/io.c
+++ b/drivers/net/wireless/wl12xx/io.c
@@ -113,6 +113,7 @@ int wl1271_set_partition(struct wl1271 *wl,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(wl1271_set_partition);
 
 void wl1271_io_reset(struct wl1271 *wl)
 {
-- 
1.7.0.4

