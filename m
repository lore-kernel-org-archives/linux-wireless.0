Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:46990 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031997AbbKFJhW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 04:37:22 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 01/26] staging: wilc1000: separate hif_sdio and hif_spi into different module
Date: Fri, 6 Nov 2015 18:39:58 +0900
Message-ID: <1446802823-22598-2-git-send-email-glen.lee@atmel.com> (sfid-20151106_103729_618084_02A8FDDA)
In-Reply-To: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
References: <1446802823-22598-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hif_sdio and hif_spi objects are compiled all the time even though one of SPI
or SDIO is selected. This patch separates hif_sdio and hif_spi into different
modules using ifdef define.
After rework SPI and SDIO modules with only one hif interface, the define
WILC_SDIO will be removed. This is first path of this series.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/Makefile    |  6 +++---
 drivers/staging/wilc1000/wilc_wlan.c | 36 +++++++++++++++++-------------------
 2 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
index 64c2f1b..650123d 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -21,8 +21,8 @@ ccflags-$(CONFIG_WILC1000_DYNAMICALLY_ALLOCATE_MEMROY) += -DWILC_NORMAL_ALLOC
 wilc1000-objs := wilc_wfi_cfgoperations.o linux_wlan.o linux_mon.o \
 			wilc_msgqueue.o \
 			coreconfigurator.o host_interface.o \
-			wilc_sdio.o wilc_spi.o wilc_wlan_cfg.o wilc_debugfs.o \
+			wilc_wlan_cfg.o wilc_debugfs.o \
 			wilc_wlan.o
 
-wilc1000-$(CONFIG_WILC1000_SDIO) += linux_wlan_sdio.o
-wilc1000-$(CONFIG_WILC1000_SPI) += linux_wlan_spi.o
+wilc1000-$(CONFIG_WILC1000_SDIO) += linux_wlan_sdio.o wilc_sdio.o
+wilc1000-$(CONFIG_WILC1000_SPI) += linux_wlan_spi.o wilc_spi.o
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index b6d784b..2ce5870 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -2,8 +2,11 @@
 #include "wilc_wfi_netdevice.h"
 #include "wilc_wlan_cfg.h"
 
+#ifdef WILC_SDIO
 extern struct wilc_hif_func hif_sdio;
+#else
 extern struct wilc_hif_func hif_spi;
+#endif
 u32 wilc_get_chipid(u8 update);
 
 typedef struct {
@@ -1659,26 +1662,21 @@ int wilc_wlan_init(struct net_device *dev, wilc_wlan_inp_t *inp)
 	memcpy((void *)&g_wlan.io_func, (void *)&inp->io_func,
 	       sizeof(wilc_wlan_io_func_t));
 
-	if ((inp->io_func.io_type & 0x1) == HIF_SDIO) {
-		if (!hif_sdio.hif_init(inp, wilc_debug)) {
-			ret = -EIO;
-			goto _fail_;
-		}
-		memcpy((void *)&g_wlan.hif_func, &hif_sdio,
-		       sizeof(struct wilc_hif_func));
-	} else {
-		if ((inp->io_func.io_type & 0x1) == HIF_SPI) {
-			if (!hif_spi.hif_init(inp, wilc_debug)) {
-				ret = -EIO;
-				goto _fail_;
-			}
-			memcpy((void *)&g_wlan.hif_func, &hif_spi,
-			       sizeof(struct wilc_hif_func));
-		} else {
-			ret = -EIO;
-			goto _fail_;
-		}
+#ifdef WILC_SDIO
+	if (!hif_sdio.hif_init(inp, wilc_debug)) {
+		ret = -EIO;
+		goto _fail_;
 	}
+	memcpy((void *)&g_wlan.hif_func, &hif_sdio,
+	       sizeof(struct wilc_hif_func));
+#else
+	if (!hif_spi.hif_init(inp, wilc_debug)) {
+		ret = -EIO;
+		goto _fail_;
+	}
+	memcpy((void *)&g_wlan.hif_func, &hif_spi,
+	       sizeof(struct wilc_hif_func));
+#endif
 
 	if (!wilc_wlan_cfg_init(wilc_debug)) {
 		ret = -ENOBUFS;
-- 
1.9.1

