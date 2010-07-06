Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37901 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757053Ab0GFAkZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jul 2010 20:40:25 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	<linux-omap@vger.kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	<akpm@linux-foundation.org>, San Mehat <san@google.com>,
	Ohad Ben-Cohen <ohadb@ti.com>
Subject: [PATCH 08/15] wireless: wl1271: make wl12xx.h common to both spi and sdio
Date: Tue,  6 Jul 2010 03:37:39 +0300
Message-Id: <1278376666-3509-9-git-send-email-ohad@wizery.com>
In-Reply-To: <1278376666-3509-1-git-send-email-ohad@wizery.com>
References: <1278376666-3509-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ohad Ben-Cohen <ohadb@ti.com>

Move wl12xx.h outside of the spi-specific location,
so it can be shared with both spi and sdio solutions.

Signed-off-by: Ohad Ben-Cohen <ohadb@ti.com>
---
 drivers/net/wireless/wl12xx/wl1251_sdio.c |    2 +-
 drivers/net/wireless/wl12xx/wl1251_spi.c  |    2 +-
 drivers/net/wireless/wl12xx/wl1271_spi.c  |    2 +-
 include/linux/spi/wl12xx.h                |   34 -----------------------------
 include/linux/wl12xx.h                    |   34 +++++++++++++++++++++++++++++
 5 files changed, 37 insertions(+), 37 deletions(-)
 delete mode 100644 include/linux/spi/wl12xx.h
 create mode 100644 include/linux/wl12xx.h

diff --git a/drivers/net/wireless/wl12xx/wl1251_sdio.c b/drivers/net/wireless/wl12xx/wl1251_sdio.c
index c561332..416d5aa 100644
--- a/drivers/net/wireless/wl12xx/wl1251_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1251_sdio.c
@@ -24,7 +24,7 @@
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/sdio_ids.h>
 #include <linux/platform_device.h>
-#include <linux/spi/wl12xx.h>
+#include <linux/wl12xx.h>
 #include <linux/irq.h>
 
 #include "wl1251.h"
diff --git a/drivers/net/wireless/wl12xx/wl1251_spi.c b/drivers/net/wireless/wl12xx/wl1251_spi.c
index e814742..4847b6a 100644
--- a/drivers/net/wireless/wl12xx/wl1251_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1251_spi.c
@@ -26,7 +26,7 @@
 #include <linux/slab.h>
 #include <linux/crc7.h>
 #include <linux/spi/spi.h>
-#include <linux/spi/wl12xx.h>
+#include <linux/wl12xx.h>
 
 #include "wl1251.h"
 #include "wl1251_reg.h"
diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.c b/drivers/net/wireless/wl12xx/wl1271_spi.c
index 5189b81..e866049 100644
--- a/drivers/net/wireless/wl12xx/wl1271_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1271_spi.c
@@ -25,7 +25,7 @@
 #include <linux/module.h>
 #include <linux/crc7.h>
 #include <linux/spi/spi.h>
-#include <linux/spi/wl12xx.h>
+#include <linux/wl12xx.h>
 #include <linux/slab.h>
 
 #include "wl1271.h"
diff --git a/include/linux/spi/wl12xx.h b/include/linux/spi/wl12xx.h
deleted file mode 100644
index a223ecb..0000000
--- a/include/linux/spi/wl12xx.h
+++ /dev/null
@@ -1,34 +0,0 @@
-/*
- * This file is part of wl12xx
- *
- * Copyright (C) 2009 Nokia Corporation
- *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#ifndef _LINUX_SPI_WL12XX_H
-#define _LINUX_SPI_WL12XX_H
-
-struct wl12xx_platform_data {
-	void (*set_power)(bool enable);
-	/* SDIO only: IRQ number if WLAN_IRQ line is used, 0 for SDIO IRQs */
-	int irq;
-	bool use_eeprom;
-};
-
-#endif
diff --git a/include/linux/wl12xx.h b/include/linux/wl12xx.h
new file mode 100644
index 0000000..137ac89
--- /dev/null
+++ b/include/linux/wl12xx.h
@@ -0,0 +1,34 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (C) 2009 Nokia Corporation
+ *
+ * Contact: Kalle Valo <kalle.valo@nokia.com>
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
+#ifndef _LINUX_WL12XX_H
+#define _LINUX_WL12XX_H
+
+struct wl12xx_platform_data {
+	void (*set_power)(bool enable);
+	/* SDIO only: IRQ number if WLAN_IRQ line is used, 0 for SDIO IRQs */
+	int irq;
+	bool use_eeprom;
+};
+
+#endif
-- 
1.7.0.4

