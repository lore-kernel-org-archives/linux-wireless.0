Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f43.google.com ([209.85.161.43]:43170 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab0LLKPd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Dec 2010 05:15:33 -0500
Received: by fxm18 with SMTP id 18so5298820fxm.2
        for <linux-wireless@vger.kernel.org>; Sun, 12 Dec 2010 02:15:32 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: allow runtime changing of debug_level
Date: Sun, 12 Dec 2010 12:15:35 +0200
Message-Id: <1292148935-8709-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, the debug level is set in compilation time (by the DEBUG_LEVEL
const). This method has the advantage of compiling only the relevant
messages, while optimizing out the unused ones.

In order to allow runtime control over the debug_level, while optimizing
out messages when debug messages are not needed, we combine some methods:
1. use dynamic_debug (pr_debug) rather then printk.
2. add debug_level module param in order to set debug level during insmod.
3. add debug_level sysfs file in order to allow dynamic control over the
   debug level.

Since patches for pr_debug_hex_dump() implementation haven't been applied yet,
we are still temporarly using print_hex_dump().

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |    5 +++++
 drivers/net/wireless/wl12xx/main.c    |    5 +++++
 drivers/net/wireless/wl12xx/wl12xx.h  |   19 ++++++++++---------
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 8106a6c..c2cd580 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -401,6 +401,11 @@ static int wl1271_debugfs_add_files(struct wl1271 *wl)
 
 	DEBUGFS_ADD(gpio_power, wl->rootdir);
 
+	entry = debugfs_create_x32("debug_level", 0600, wl->rootdir,
+				   &wl12xx_debug_level);
+	if (!entry || IS_ERR(entry))
+		goto err;
+
 	return 0;
 
 err:
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index dc3a093..3428c45 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2806,6 +2806,11 @@ int wl1271_free_hw(struct wl1271 *wl)
 }
 EXPORT_SYMBOL_GPL(wl1271_free_hw);
 
+u32 wl12xx_debug_level;
+EXPORT_SYMBOL_GPL(wl12xx_debug_level);
+module_param_named(debug_level, wl12xx_debug_level, uint, DEBUG_NONE);
+MODULE_PARM_DESC(debug_level, "wl12xx debugging level");
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
 MODULE_AUTHOR("Juuso Oikarinen <juuso.oikarinen@nokia.com>");
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index e904c72..07c2297 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -60,31 +60,32 @@ enum {
 	DEBUG_ALL	= ~0,
 };
 
-#define DEBUG_LEVEL (DEBUG_NONE)
+extern u32 wl12xx_debug_level;
 
 #define DEBUG_DUMP_LIMIT 1024
 
 #define wl1271_error(fmt, arg...) \
-	printk(KERN_ERR DRIVER_PREFIX "ERROR " fmt "\n", ##arg)
+	pr_err(DRIVER_PREFIX "ERROR " fmt "\n", ##arg)
 
 #define wl1271_warning(fmt, arg...) \
-	printk(KERN_WARNING DRIVER_PREFIX "WARNING " fmt "\n", ##arg)
+	pr_warning(DRIVER_PREFIX "WARNING " fmt "\n", ##arg)
 
 #define wl1271_notice(fmt, arg...) \
-	printk(KERN_INFO DRIVER_PREFIX fmt "\n", ##arg)
+	pr_info(DRIVER_PREFIX fmt "\n", ##arg)
 
 #define wl1271_info(fmt, arg...) \
-	printk(KERN_DEBUG DRIVER_PREFIX fmt "\n", ##arg)
+	pr_info(DRIVER_PREFIX fmt "\n", ##arg)
 
 #define wl1271_debug(level, fmt, arg...) \
 	do { \
-		if (level & DEBUG_LEVEL) \
-			printk(KERN_DEBUG DRIVER_PREFIX fmt "\n", ##arg); \
+		if (level & wl12xx_debug_level) \
+			pr_debug(DRIVER_PREFIX fmt "\n", ##arg); \
 	} while (0)
 
+/* TODO: use pr_debug_hex_dump when it will be available */
 #define wl1271_dump(level, prefix, buf, len)	\
 	do { \
-		if (level & DEBUG_LEVEL) \
+		if (level & wl12xx_debug_level) \
 			print_hex_dump(KERN_DEBUG, DRIVER_PREFIX prefix, \
 				       DUMP_PREFIX_OFFSET, 16, 1,	\
 				       buf,				\
@@ -94,7 +95,7 @@ enum {
 
 #define wl1271_dump_ascii(level, prefix, buf, len)	\
 	do { \
-		if (level & DEBUG_LEVEL) \
+		if (level & wl12xx_debug_level) \
 			print_hex_dump(KERN_DEBUG, DRIVER_PREFIX prefix, \
 				       DUMP_PREFIX_OFFSET, 16, 1,	\
 				       buf,				\
-- 
1.7.0.4

