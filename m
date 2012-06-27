Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:39610 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757596Ab2F0Pgd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 11:36:33 -0400
Received: by lbbgj10 with SMTP id gj10so2333498lbb.37
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2012 08:36:30 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 8/8] wl12xx/wlcore: increase FW filename version
Date: Wed, 27 Jun 2012 18:36:02 +0300
Message-Id: <1340811362-30441-9-git-send-email-coelho@ti.com> (sfid-20120627_173638_934653_FB9D11B7)
In-Reply-To: <1340811362-30441-1-git-send-email-coelho@ti.com>
References: <1340811362-30441-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have some API changes and new features in the new firmwares that
are not compatible with older drivers.  Increase the version of the FW
filenames for wl12xx to 5.

Additionally, remove the duplicate definitions from wlcore_i.h and
remove the MODULE_FIRMWARE macro calls from the SDIO and SPI modules,
since they're irrelevant there.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c     |   12 ++++++------
 drivers/net/wireless/ti/wlcore/sdio.c     |    6 ------
 drivers/net/wireless/ti/wlcore/spi.c      |    6 ------
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    9 ---------
 4 files changed, 6 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index b11c4b3..da261cf 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -590,13 +590,13 @@ static const int wl12xx_rtable[REG_TABLE_LEN] = {
 };
 
 /* TODO: maybe move to a new header file? */
-#define WL127X_FW_NAME_MULTI	"ti-connectivity/wl127x-fw-4-mr.bin"
-#define WL127X_FW_NAME_SINGLE	"ti-connectivity/wl127x-fw-4-sr.bin"
-#define WL127X_PLT_FW_NAME	"ti-connectivity/wl127x-fw-4-plt.bin"
+#define WL127X_FW_NAME_MULTI	"ti-connectivity/wl127x-fw-5-mr.bin"
+#define WL127X_FW_NAME_SINGLE	"ti-connectivity/wl127x-fw-5-sr.bin"
+#define WL127X_PLT_FW_NAME	"ti-connectivity/wl127x-fw-5-plt.bin"
 
-#define WL128X_FW_NAME_MULTI	"ti-connectivity/wl128x-fw-4-mr.bin"
-#define WL128X_FW_NAME_SINGLE	"ti-connectivity/wl128x-fw-4-sr.bin"
-#define WL128X_PLT_FW_NAME	"ti-connectivity/wl128x-fw-4-plt.bin"
+#define WL128X_FW_NAME_MULTI	"ti-connectivity/wl128x-fw-5-mr.bin"
+#define WL128X_FW_NAME_SINGLE	"ti-connectivity/wl128x-fw-5-sr.bin"
+#define WL128X_PLT_FW_NAME	"ti-connectivity/wl128x-fw-5-plt.bin"
 
 static int wl127x_prepare_read(struct wl1271 *wl, u32 rx_desc, u32 len)
 {
diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index 204e69f..73ace4b 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -411,9 +411,3 @@ MODULE_PARM_DESC(dump, "Enable sdio read/write dumps.");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
 MODULE_AUTHOR("Juuso Oikarinen <juuso.oikarinen@nokia.com>");
-MODULE_FIRMWARE(WL127X_FW_NAME_SINGLE);
-MODULE_FIRMWARE(WL127X_FW_NAME_MULTI);
-MODULE_FIRMWARE(WL127X_PLT_FW_NAME);
-MODULE_FIRMWARE(WL128X_FW_NAME_SINGLE);
-MODULE_FIRMWARE(WL128X_FW_NAME_MULTI);
-MODULE_FIRMWARE(WL128X_PLT_FW_NAME);
diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti/wlcore/spi.c
index 6420aba..8da4ed2 100644
--- a/drivers/net/wireless/ti/wlcore/spi.c
+++ b/drivers/net/wireless/ti/wlcore/spi.c
@@ -435,10 +435,4 @@ module_exit(wl1271_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
 MODULE_AUTHOR("Juuso Oikarinen <juuso.oikarinen@nokia.com>");
-MODULE_FIRMWARE(WL127X_FW_NAME_SINGLE);
-MODULE_FIRMWARE(WL127X_FW_NAME_MULTI);
-MODULE_FIRMWARE(WL127X_PLT_FW_NAME);
-MODULE_FIRMWARE(WL128X_FW_NAME_SINGLE);
-MODULE_FIRMWARE(WL128X_FW_NAME_MULTI);
-MODULE_FIRMWARE(WL128X_PLT_FW_NAME);
 MODULE_ALIAS("spi:wl1271");
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 4273a21..a760407 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -35,15 +35,6 @@
 #include "conf.h"
 #include "ini.h"
 
-#define WL127X_FW_NAME_MULTI "ti-connectivity/wl127x-fw-4-mr.bin"
-#define WL127X_FW_NAME_SINGLE "ti-connectivity/wl127x-fw-4-sr.bin"
-
-#define WL128X_FW_NAME_MULTI "ti-connectivity/wl128x-fw-4-mr.bin"
-#define WL128X_FW_NAME_SINGLE "ti-connectivity/wl128x-fw-4-sr.bin"
-
-#define WL127X_PLT_FW_NAME "ti-connectivity/wl127x-fw-4-plt.bin"
-#define WL128X_PLT_FW_NAME "ti-connectivity/wl128x-fw-4-plt.bin"
-
 /*
  * wl127x and wl128x are using the same NVS file name. However, the
  * ini parameters between them are different.  The driver validates
-- 
1.7.10

