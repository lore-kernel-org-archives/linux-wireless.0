Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:39411 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751730Ab1JGINZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 04:13:25 -0400
Received: by bkat2 with SMTP id t2so5110997bka.8
        for <linux-wireless@vger.kernel.org>; Fri, 07 Oct 2011 01:13:22 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH] wl12xx: move debugging definitions to a separate file
Date: Fri,  7 Oct 2011 11:13:14 +0300
Message-Id: <1317975194-18306-1-git-send-email-coelho@ti.com> (sfid-20111007_101331_178862_D172F89C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Separate the debugging macros and other definitions to a new debug.h
file.  This is be needed because the sdio and spi modules don't need
to depend on the wl12xx module anymore, but still need to include
wl12xx.h.  Currently they do depend on it, because of the debugging
global that wl12xx exports.  A future patch will remove this
dependency.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/acx.c      |    1 +
 drivers/net/wireless/wl12xx/boot.c     |    1 +
 drivers/net/wireless/wl12xx/cmd.c      |    1 +
 drivers/net/wireless/wl12xx/debug.h    |   98 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/debugfs.c  |    1 +
 drivers/net/wireless/wl12xx/event.c    |    1 +
 drivers/net/wireless/wl12xx/init.c     |    1 +
 drivers/net/wireless/wl12xx/io.c       |    1 +
 drivers/net/wireless/wl12xx/main.c     |    1 +
 drivers/net/wireless/wl12xx/ps.c       |    1 +
 drivers/net/wireless/wl12xx/rx.c       |    1 +
 drivers/net/wireless/wl12xx/scan.c     |    1 +
 drivers/net/wireless/wl12xx/sdio.c     |    1 +
 drivers/net/wireless/wl12xx/spi.c      |    1 +
 drivers/net/wireless/wl12xx/testmode.c |    1 +
 drivers/net/wireless/wl12xx/tx.c       |    1 +
 drivers/net/wireless/wl12xx/wl12xx.h   |   67 ----------------------
 17 files changed, 113 insertions(+), 67 deletions(-)
 create mode 100644 drivers/net/wireless/wl12xx/debug.h

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 5b70cc1..6229c2b 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -29,6 +29,7 @@
 #include <linux/slab.h>
 
 #include "wl12xx.h"
+#include "debug.h"
 #include "wl12xx_80211.h"
 #include "reg.h"
 #include "ps.h"
diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index d4e628d..4ce634b 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/wl12xx.h>
 
+#include "debug.h"
 #include "acx.h"
 #include "reg.h"
 #include "boot.h"
diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 102a8a5..674516d 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -29,6 +29,7 @@
 #include <linux/slab.h>
 
 #include "wl12xx.h"
+#include "debug.h"
 #include "reg.h"
 #include "io.h"
 #include "acx.h"
diff --git a/drivers/net/wireless/wl12xx/debug.h b/drivers/net/wireless/wl12xx/debug.h
new file mode 100644
index 0000000..f0afe4a
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/debug.h
@@ -0,0 +1,98 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (C) 2011 Texas Instruments. All rights reserved.
+ * Copyright (C) 2008-2009 Nokia Corporation
+ *
+ * Contact: Luciano Coelho <coelho@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __DEBUG_H__
+#define __DEBUG_H__
+
+#include <linux/bitops.h>
+#include <linux/printk.h>
+
+enum {
+	DEBUG_NONE	= 0,
+	DEBUG_IRQ	= BIT(0),
+	DEBUG_SPI	= BIT(1),
+	DEBUG_BOOT	= BIT(2),
+	DEBUG_MAILBOX	= BIT(3),
+	DEBUG_TESTMODE	= BIT(4),
+	DEBUG_EVENT	= BIT(5),
+	DEBUG_TX	= BIT(6),
+	DEBUG_RX	= BIT(7),
+	DEBUG_SCAN	= BIT(8),
+	DEBUG_CRYPT	= BIT(9),
+	DEBUG_PSM	= BIT(10),
+	DEBUG_MAC80211	= BIT(11),
+	DEBUG_CMD	= BIT(12),
+	DEBUG_ACX	= BIT(13),
+	DEBUG_SDIO	= BIT(14),
+	DEBUG_FILTERS   = BIT(15),
+	DEBUG_ADHOC     = BIT(16),
+	DEBUG_AP	= BIT(17),
+	DEBUG_MASTER	= (DEBUG_ADHOC | DEBUG_AP),
+	DEBUG_ALL	= ~0,
+};
+
+extern u32 wl12xx_debug_level;
+
+#define DEBUG_DUMP_LIMIT 1024
+
+#define wl1271_error(fmt, arg...) \
+	pr_err(DRIVER_PREFIX "ERROR " fmt "\n", ##arg)
+
+#define wl1271_warning(fmt, arg...) \
+	pr_warning(DRIVER_PREFIX "WARNING " fmt "\n", ##arg)
+
+#define wl1271_notice(fmt, arg...) \
+	pr_info(DRIVER_PREFIX fmt "\n", ##arg)
+
+#define wl1271_info(fmt, arg...) \
+	pr_info(DRIVER_PREFIX fmt "\n", ##arg)
+
+#define wl1271_debug(level, fmt, arg...) \
+	do { \
+		if (level & wl12xx_debug_level) \
+			pr_debug(DRIVER_PREFIX fmt "\n", ##arg); \
+	} while (0)
+
+/* TODO: use pr_debug_hex_dump when it becomes available */
+#define wl1271_dump(level, prefix, buf, len)	\
+	do { \
+		if (level & wl12xx_debug_level) \
+			print_hex_dump(KERN_DEBUG, DRIVER_PREFIX prefix, \
+				       DUMP_PREFIX_OFFSET, 16, 1,	\
+				       buf,				\
+				       min_t(size_t, len, DEBUG_DUMP_LIMIT), \
+				       0);				\
+	} while (0)
+
+#define wl1271_dump_ascii(level, prefix, buf, len)	\
+	do { \
+		if (level & wl12xx_debug_level) \
+			print_hex_dump(KERN_DEBUG, DRIVER_PREFIX prefix, \
+				       DUMP_PREFIX_OFFSET, 16, 1,	\
+				       buf,				\
+				       min_t(size_t, len, DEBUG_DUMP_LIMIT), \
+				       true);				\
+	} while (0)
+
+#endif /* __DEBUG_H__ */
diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index f0398d0..50216cd 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -27,6 +27,7 @@
 #include <linux/slab.h>
 
 #include "wl12xx.h"
+#include "debug.h"
 #include "acx.h"
 #include "ps.h"
 #include "io.h"
diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index 486c8ee..6947fd0 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -22,6 +22,7 @@
  */
 
 #include "wl12xx.h"
+#include "debug.h"
 #include "reg.h"
 #include "io.h"
 #include "event.h"
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 80e89e3..977de9d 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 
+#include "debug.h"
 #include "init.h"
 #include "wl12xx_80211.h"
 #include "acx.h"
diff --git a/drivers/net/wireless/wl12xx/io.c b/drivers/net/wireless/wl12xx/io.c
index 1a7df8a..079ad38 100644
--- a/drivers/net/wireless/wl12xx/io.c
+++ b/drivers/net/wireless/wl12xx/io.c
@@ -27,6 +27,7 @@
 #include <linux/interrupt.h>
 
 #include "wl12xx.h"
+#include "debug.h"
 #include "wl12xx_80211.h"
 #include "io.h"
 #include "tx.h"
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 63ff36c..320d1f4 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -35,6 +35,7 @@
 #include <linux/interrupt.h>
 
 #include "wl12xx.h"
+#include "debug.h"
 #include "wl12xx_80211.h"
 #include "reg.h"
 #include "io.h"
diff --git a/drivers/net/wireless/wl12xx/ps.c b/drivers/net/wireless/wl12xx/ps.c
index ac3f207..f75941d 100644
--- a/drivers/net/wireless/wl12xx/ps.c
+++ b/drivers/net/wireless/wl12xx/ps.c
@@ -25,6 +25,7 @@
 #include "ps.h"
 #include "io.h"
 #include "tx.h"
+#include "debug.h"
 
 #define WL1271_WAKEUP_TIMEOUT 500
 
diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
index 9cfa0b2..b3bc0d5 100644
--- a/drivers/net/wireless/wl12xx/rx.c
+++ b/drivers/net/wireless/wl12xx/rx.c
@@ -25,6 +25,7 @@
 #include <linux/sched.h>
 
 #include "wl12xx.h"
+#include "debug.h"
 #include "acx.h"
 #include "reg.h"
 #include "rx.h"
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index 9372136..9006388 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -24,6 +24,7 @@
 #include <linux/ieee80211.h>
 
 #include "wl12xx.h"
+#include "debug.h"
 #include "cmd.h"
 #include "scan.h"
 #include "acx.h"
diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index 0374bcd..419f014 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -34,6 +34,7 @@
 #include <linux/pm_runtime.h>
 
 #include "wl12xx.h"
+#include "debug.h"
 #include "wl12xx_80211.h"
 #include "io.h"
 
diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index 22c1337..bcc7d7c 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -31,6 +31,7 @@
 #include <linux/slab.h>
 
 #include "wl12xx.h"
+#include "debug.h"
 #include "wl12xx_80211.h"
 #include "io.h"
 
diff --git a/drivers/net/wireless/wl12xx/testmode.c b/drivers/net/wireless/wl12xx/testmode.c
index 4ae8eff..61fff45 100644
--- a/drivers/net/wireless/wl12xx/testmode.c
+++ b/drivers/net/wireless/wl12xx/testmode.c
@@ -26,6 +26,7 @@
 #include <net/genetlink.h>
 
 #include "wl12xx.h"
+#include "debug.h"
 #include "acx.h"
 #include "reg.h"
 
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 1b3d8e3..31dda0e 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -26,6 +26,7 @@
 #include <linux/etherdevice.h>
 
 #include "wl12xx.h"
+#include "debug.h"
 #include "io.h"
 #include "reg.h"
 #include "ps.h"
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index bd58f50..7449752 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -45,73 +45,6 @@
 #define WL12XX_BA_SUPPORT_FW_COST_VER2_START    50
 #define WL12XX_BA_SUPPORT_FW_COST_VER2_END      60
 
-enum {
-	DEBUG_NONE	= 0,
-	DEBUG_IRQ	= BIT(0),
-	DEBUG_SPI	= BIT(1),
-	DEBUG_BOOT	= BIT(2),
-	DEBUG_MAILBOX	= BIT(3),
-	DEBUG_TESTMODE	= BIT(4),
-	DEBUG_EVENT	= BIT(5),
-	DEBUG_TX	= BIT(6),
-	DEBUG_RX	= BIT(7),
-	DEBUG_SCAN	= BIT(8),
-	DEBUG_CRYPT	= BIT(9),
-	DEBUG_PSM	= BIT(10),
-	DEBUG_MAC80211	= BIT(11),
-	DEBUG_CMD	= BIT(12),
-	DEBUG_ACX	= BIT(13),
-	DEBUG_SDIO	= BIT(14),
-	DEBUG_FILTERS   = BIT(15),
-	DEBUG_ADHOC     = BIT(16),
-	DEBUG_AP	= BIT(17),
-	DEBUG_MASTER	= (DEBUG_ADHOC | DEBUG_AP),
-	DEBUG_ALL	= ~0,
-};
-
-extern u32 wl12xx_debug_level;
-
-#define DEBUG_DUMP_LIMIT 1024
-
-#define wl1271_error(fmt, arg...) \
-	pr_err(DRIVER_PREFIX "ERROR " fmt "\n", ##arg)
-
-#define wl1271_warning(fmt, arg...) \
-	pr_warning(DRIVER_PREFIX "WARNING " fmt "\n", ##arg)
-
-#define wl1271_notice(fmt, arg...) \
-	pr_info(DRIVER_PREFIX fmt "\n", ##arg)
-
-#define wl1271_info(fmt, arg...) \
-	pr_info(DRIVER_PREFIX fmt "\n", ##arg)
-
-#define wl1271_debug(level, fmt, arg...) \
-	do { \
-		if (level & wl12xx_debug_level) \
-			pr_debug(DRIVER_PREFIX fmt "\n", ##arg); \
-	} while (0)
-
-/* TODO: use pr_debug_hex_dump when it will be available */
-#define wl1271_dump(level, prefix, buf, len)	\
-	do { \
-		if (level & wl12xx_debug_level) \
-			print_hex_dump(KERN_DEBUG, DRIVER_PREFIX prefix, \
-				       DUMP_PREFIX_OFFSET, 16, 1,	\
-				       buf,				\
-				       min_t(size_t, len, DEBUG_DUMP_LIMIT), \
-				       0);				\
-	} while (0)
-
-#define wl1271_dump_ascii(level, prefix, buf, len)	\
-	do { \
-		if (level & wl12xx_debug_level) \
-			print_hex_dump(KERN_DEBUG, DRIVER_PREFIX prefix, \
-				       DUMP_PREFIX_OFFSET, 16, 1,	\
-				       buf,				\
-				       min_t(size_t, len, DEBUG_DUMP_LIMIT), \
-				       true);				\
-	} while (0)
-
 #define WL127X_FW_NAME "ti-connectivity/wl127x-fw-3.bin"
 #define WL128X_FW_NAME "ti-connectivity/wl128x-fw-3.bin"
 
-- 
1.7.1

