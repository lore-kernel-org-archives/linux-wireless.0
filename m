Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34781 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007Ab0IAV1P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Sep 2010 17:27:15 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	<linux-omap@vger.kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
	<linux-arm-kernel@lists.infradead.org>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	<akpm@linux-foundation.org>, San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>, Ido Yariv <ido@wizery.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Russell King <linux@arm.linux.org.uk>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v5 1/7] wireless: wl1271: make wl12xx.h common to both spi and sdio
Date: Thu,  2 Sep 2010 00:26:44 +0300
Message-Id: <1283376410-9999-2-git-send-email-ohad@wizery.com>
In-Reply-To: <1283376410-9999-1-git-send-email-ohad@wizery.com>
References: <1283376410-9999-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move wl12xx.h outside of the spi-specific location,
so it can be shared with both spi and sdio solutions.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
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
index b901b61..a319df1 100644
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
index 27fdfaa..a6faf3e 100644
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
index 4cb99c5..c3fdab7 100644
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

