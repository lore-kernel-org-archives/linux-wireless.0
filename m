Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:50988 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754737Ab3AWOlj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2013 09:41:39 -0500
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id r0NEfdA0019110
	for <linux-wireless@vger.kernel.org>; Wed, 23 Jan 2013 08:41:39 -0600
Received: from DFLE73.ent.ti.com (dfle73.ent.ti.com [128.247.5.110])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id r0NEfd7d026066
	for <linux-wireless@vger.kernel.org>; Wed, 23 Jan 2013 08:41:39 -0600
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>
Subject: [PATCH 5/5] wlcore: move wl12xx_platform_data up and make it truly optional
Date: Wed, 23 Jan 2013 16:40:38 +0200
Message-ID: <1358952038-5982-6-git-send-email-coelho@ti.com> (sfid-20130123_154145_518396_FD5D7186)
In-Reply-To: <1358952038-5982-1-git-send-email-coelho@ti.com>
References: <1358952038-5982-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The platform data is used not only by wlcore-based drivers, but also
by wl1251.  Move it up in the directory hierarchy to reflect this.

Additionally, make it truly optional.  At the moment, disabling
platform data while wl1251_sdio or wlcore_sdio are enabled doesn't
work, but it will be necessary when device tree support is
implemented.

Reviewed-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/Kconfig                          |    9 +++++++++
 drivers/net/wireless/ti/Makefile                         |    3 +++
 .../wl12xx_platform_data.c => wilink_platform_data.c}    |    0
 drivers/net/wireless/ti/wlcore/Kconfig                   |    5 -----
 drivers/net/wireless/ti/wlcore/Makefile                  |    3 ---
 include/linux/wl12xx.h                                   |   14 +++++++++++---
 6 files changed, 23 insertions(+), 11 deletions(-)
 rename drivers/net/wireless/ti/{wlcore/wl12xx_platform_data.c => wilink_platform_data.c} (100%)

diff --git a/drivers/net/wireless/ti/Kconfig b/drivers/net/wireless/ti/Kconfig
index be80011..cbe1e7f 100644
--- a/drivers/net/wireless/ti/Kconfig
+++ b/drivers/net/wireless/ti/Kconfig
@@ -12,4 +12,13 @@ source "drivers/net/wireless/ti/wl18xx/Kconfig"
 
 # keep last for automatic dependencies
 source "drivers/net/wireless/ti/wlcore/Kconfig"
+
+config WILINK_PLATFORM_DATA
+	bool "TI WiLink platform data"
+	depends on WLCORE_SDIO || WL1251_SDIO
+	default y
+	---help---
+	Small platform data bit needed to pass data to the sdio modules.
+
+
 endif # WL_TI
diff --git a/drivers/net/wireless/ti/Makefile b/drivers/net/wireless/ti/Makefile
index 4d68239..62cd419 100644
--- a/drivers/net/wireless/ti/Makefile
+++ b/drivers/net/wireless/ti/Makefile
@@ -3,3 +3,6 @@ obj-$(CONFIG_WL12XX)			+= wl12xx/
 obj-$(CONFIG_WL12XX_PLATFORM_DATA)	+= wlcore/
 obj-$(CONFIG_WL1251)			+= wl1251/
 obj-$(CONFIG_WL18XX)			+= wl18xx/
+
+# small builtin driver bit
+obj-$(CONFIG_WILINK_PLATFORM_DATA)	+= wilink_platform_data.o
diff --git a/drivers/net/wireless/ti/wlcore/wl12xx_platform_data.c b/drivers/net/wireless/ti/wilink_platform_data.c
similarity index 100%
rename from drivers/net/wireless/ti/wlcore/wl12xx_platform_data.c
rename to drivers/net/wireless/ti/wilink_platform_data.c
diff --git a/drivers/net/wireless/ti/wlcore/Kconfig b/drivers/net/wireless/ti/wlcore/Kconfig
index d7b907e..2b83282 100644
--- a/drivers/net/wireless/ti/wlcore/Kconfig
+++ b/drivers/net/wireless/ti/wlcore/Kconfig
@@ -33,8 +33,3 @@ config WLCORE_SDIO
 
 	  If you choose to build a module, it'll be called wlcore_sdio.
 	  Say N if unsure.
-
-config WL12XX_PLATFORM_DATA
-	bool
-	depends on WLCORE_SDIO != n || WL1251_SDIO != n
-	default y
diff --git a/drivers/net/wireless/ti/wlcore/Makefile b/drivers/net/wireless/ti/wlcore/Makefile
index d9fba9e..b21398f 100644
--- a/drivers/net/wireless/ti/wlcore/Makefile
+++ b/drivers/net/wireless/ti/wlcore/Makefile
@@ -9,7 +9,4 @@ obj-$(CONFIG_WLCORE)			+= wlcore.o
 obj-$(CONFIG_WLCORE_SPI)		+= wlcore_spi.o
 obj-$(CONFIG_WLCORE_SDIO)		+= wlcore_sdio.o
 
-# small builtin driver bit
-obj-$(CONFIG_WL12XX_PLATFORM_DATA)	+= wl12xx_platform_data.o
-
 ccflags-y += -D__CHECK_ENDIAN__
diff --git a/include/linux/wl12xx.h b/include/linux/wl12xx.h
index 360c9bc..a54fe82 100644
--- a/include/linux/wl12xx.h
+++ b/include/linux/wl12xx.h
@@ -24,6 +24,8 @@
 #ifndef _LINUX_WL12XX_H
 #define _LINUX_WL12XX_H
 
+#include <linux/err.h>
+
 /* Reference clock values */
 enum {
 	WL12XX_REFCLOCK_19	= 0, /* 19.2 MHz */
@@ -60,10 +62,12 @@ struct wl12xx_platform_data {
 /* Platform does not support level trigger interrupts */
 #define WL12XX_PLATFORM_QUIRK_EDGE_IRQ	BIT(0)
 
-#ifdef CONFIG_WL12XX_PLATFORM_DATA
+#ifdef CONFIG_WILINK_PLATFORM_DATA
 
 int wl12xx_set_platform_data(const struct wl12xx_platform_data *data);
 
+struct wl12xx_platform_data *wl12xx_get_platform_data(void);
+
 #else
 
 static inline
@@ -72,8 +76,12 @@ int wl12xx_set_platform_data(const struct wl12xx_platform_data *data)
 	return -ENOSYS;
 }
 
-#endif
+static inline
+struct wl12xx_platform_data *wl12xx_get_platform_data(void)
+{
+	return ERR_PTR(-ENODATA);
+}
 
-struct wl12xx_platform_data *wl12xx_get_platform_data(void);
+#endif
 
 #endif
-- 
1.7.10.4

