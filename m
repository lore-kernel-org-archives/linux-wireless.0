Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:53719 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756697Ab2I0Kim (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 06:38:42 -0400
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 15/31] wlcore: make debug prints work without dynamic debug
Date: Thu, 27 Sep 2012 13:37:53 +0300
Message-Id: <1348742289-6587-16-git-send-email-luca@coelho.fi> (sfid-20120927_123937_557609_712B1B28)
In-Reply-To: <1348742289-6587-1-git-send-email-luca@coelho.fi>
References: <1348742289-6587-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Make debug prints operational when dynamic debug is not defined.
This allows better debugging in production environments.

Change the driver prefix to "wlcore" while were at it.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <luca@coelho.fi>
---
 drivers/net/wireless/ti/wlcore/debug.h |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/debug.h b/drivers/net/wireless/ti/wlcore/debug.h
index 6b800b3..db4bf5a 100644
--- a/drivers/net/wireless/ti/wlcore/debug.h
+++ b/drivers/net/wireless/ti/wlcore/debug.h
@@ -28,7 +28,7 @@
 #include <linux/bitops.h>
 #include <linux/printk.h>
 
-#define DRIVER_NAME "wl12xx"
+#define DRIVER_NAME "wlcore"
 #define DRIVER_PREFIX DRIVER_NAME ": "
 
 enum {
@@ -73,11 +73,21 @@ extern u32 wl12xx_debug_level;
 #define wl1271_info(fmt, arg...) \
 	pr_info(DRIVER_PREFIX fmt "\n", ##arg)
 
+/* define the debug macro differently if dynamic debug is supported */
+#if defined(CONFIG_DYNAMIC_DEBUG)
 #define wl1271_debug(level, fmt, arg...) \
 	do { \
-		if (level & wl12xx_debug_level) \
-			pr_debug(DRIVER_PREFIX fmt "\n", ##arg); \
+		if (unlikely(level & wl12xx_debug_level)) \
+			dynamic_pr_debug(DRIVER_PREFIX fmt "\n", ##arg); \
+	} while (0)
+#else
+#define wl1271_debug(level, fmt, arg...) \
+	do { \
+		if (unlikely(level & wl12xx_debug_level)) \
+			printk(KERN_DEBUG pr_fmt(DRIVER_PREFIX fmt "\n"), \
+			       ##arg); \
 	} while (0)
+#endif
 
 /* TODO: use pr_debug_hex_dump when it becomes available */
 #define wl1271_dump(level, prefix, buf, len)	\
-- 
1.7.10.4

