Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:53314 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386AbbJTWsN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 18:48:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-wireless@vger.kernel.org
Cc: Rachel Kim <rachel.kim@atmel.com>, devel@driverdev.osuosl.org,
	Chris Park <chris.park@atmel.com>, gregkh@linuxfoundation.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org, Tony Cho <tony.cho@atmel.com>,
	Glen Lee <glen.lee@atmel.com>, Leo Kim <leo.kim@atmel.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 13/19] staging/wilc1000: move COMPLEMENT_BOOT code to linux_wlan_sdio.c
Date: Wed, 21 Oct 2015 00:47:32 +0200
Message-Id: <1445381258-1455986-14-git-send-email-arnd@arndb.de> (sfid-20151021_005200_612391_A38D8C8E)
In-Reply-To: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
References: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The COMPLEMENT_BOOT code is used only for SDIO and is aware of
details of the SDIO implementation that don't belong into
the common linux_wlan.c file.

This moves the functions to linux_wlan_sdio.c to get them out of
the way.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/linux_wlan.c         | 95 +++------------------------
 drivers/staging/wilc1000/linux_wlan_sdio.c    | 89 +++++++++++++++++++++++--
 drivers/staging/wilc1000/linux_wlan_sdio.h    |  4 --
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  2 +-
 drivers/staging/wilc1000/wilc_wlan.h          |  4 +-
 drivers/staging/wilc1000/wilc_wlan_if.h       |  5 ++
 6 files changed, 103 insertions(+), 96 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index abcb70bb1bd7..980c2c8d300d 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -483,11 +483,7 @@ _fail_:
 
 }
 
-#ifdef COMPLEMENT_BOOT
-static int repeat_power_cycle(perInterface_wlan_t *nic);
-#endif
-
-static int linux_wlan_start_firmware(perInterface_wlan_t *nic)
+int wilc1000_start_firmware(perInterface_wlan_t *nic)
 {
 
 	int ret = 0;
@@ -502,19 +498,17 @@ static int linux_wlan_start_firmware(perInterface_wlan_t *nic)
 	/* wait for mac ready */
 	PRINT_D(INIT_DBG, "Waiting for Firmware to get ready ...\n");
 	ret = linux_wlan_lock_timeout(&wilc1000_dev->sync_event, 5000);
-	if (ret) {
-#ifdef COMPLEMENT_BOOT
+	if (ret && wilc1000_dev->ops->repeat_power_cycle) {
 		static int timeout = 5;
 
 		if (timeout--) {
 			PRINT_D(INIT_DBG, "repeat power cycle[%d]", timeout);
-			ret = repeat_power_cycle(nic);
+			ret = wilc1000_dev->ops->repeat_power_cycle(nic);
 		} else {
 			timeout = 5;
 			ret = -1;
 			goto _fail_;
 		}
-#endif
 		PRINT_D(INIT_DBG, "Firmware start timed out");
 		goto _fail_;
 	}
@@ -527,7 +521,8 @@ static int linux_wlan_start_firmware(perInterface_wlan_t *nic)
 _fail_:
 	return ret;
 }
-static int linux_wlan_firmware_download(struct wilc *p_nic)
+
+int wilc1000_firmware_download(struct wilc *p_nic)
 {
 
 	int ret = 0;
@@ -954,77 +949,6 @@ static void wlan_deinitialize_threads(struct wilc *nic)
 	}
 }
 
-#ifdef COMPLEMENT_BOOT
-
-#define READY_CHECK_THRESHOLD		30
-static u8 wilc1000_prepare_11b_core(struct wilc *nic)
-{
-	u8 trials = 0;
-
-	while ((wilc1000_core_11b_ready() && (READY_CHECK_THRESHOLD > (trials++)))) {
-		PRINT_D(INIT_DBG, "11b core not ready yet: %u\n", trials);
-		wilc_wlan_cleanup();
-		wilc_wlan_global_reset();
-		sdio_unregister_driver(&wilc_bus);
-
-		sdio_register_driver(&wilc_bus);
-
-		while (!wilc1000_probe)
-			msleep(100);
-		wilc1000_probe = 0;
-		wilc1000_dev->dev = &wilc1000_sdio_func->dev;
-		nic->ops = &wilc1000_sdio_ops;
-		wilc_wlan_init(nic);
-	}
-
-	if (READY_CHECK_THRESHOLD <= trials)
-		return 1;
-	else
-		return 0;
-
-}
-
-static int repeat_power_cycle(perInterface_wlan_t *nic)
-{
-	int ret = 0;
-	sdio_unregister_driver(&wilc_bus);
-
-	sdio_register_driver(&wilc_bus);
-
-	/* msleep(1000); */
-	while (!wilc1000_probe)
-		msleep(100);
-	wilc1000_probe = 0;
-	wilc1000_dev->dev = &wilc1000_sdio_func->dev;
-	wilc1000_dev->ops = &wilc1000_sdio_ops;
-	ret = wilc_wlan_init(wilc1000_dev);
-
-	wilc1000_dev->mac_status = WILC_MAC_STATUS_INIT;
-	#if (defined WILC_SDIO) && (!defined WILC_SDIO_IRQ_GPIO)
-	wilc1000_sdio_enable_interrupt();
-	#endif
-
-	if (wilc1000_wlan_get_firmware(nic)) {
-		PRINT_ER("Can't get firmware\n");
-		ret = -1;
-		goto __fail__;
-	}
-
-	/*Download firmware*/
-	ret = linux_wlan_firmware_download(wilc1000_dev);
-	if (ret < 0) {
-		PRINT_ER("Failed to download firmware\n");
-		goto __fail__;
-	}
-	/* Start firmware*/
-	ret = linux_wlan_start_firmware(nic);
-	if (ret < 0)
-		PRINT_ER("Failed to start firmware\n");
-__fail__:
-	return ret;
-}
-#endif
-
 int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 {
 	perInterface_wlan_t *nic = p_nic;
@@ -1051,13 +975,12 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 			goto _fail_wilc_wlan_;
 		}
 
-#if (defined WILC_SDIO) && (defined COMPLEMENT_BOOT)
-		if (wilc1000_prepare_11b_core(wilc1000_dev)) {
+		if (wilc1000_dev->ops->prepare_11b_core &&
+		    wilc1000_dev->ops->prepare_11b_core(wilc1000_dev)) {
 			PRINT_ER("11b Core is not ready\n");
 			ret = -EIO;
 			goto _fail_threads_;
 		}
-#endif
 
 #if (!defined WILC_SDIO) || (defined WILC_SDIO_IRQ_GPIO)
 		if (init_irq(wilc1000_dev)) {
@@ -1082,7 +1005,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 		}
 
 		/*Download firmware*/
-		ret = linux_wlan_firmware_download(wilc1000_dev);
+		ret = wilc1000_firmware_download(wilc1000_dev);
 		if (ret < 0) {
 			PRINT_ER("Failed to download firmware\n");
 			ret = -EIO;
@@ -1090,7 +1013,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 		}
 
 		/* Start firmware*/
-		ret = linux_wlan_start_firmware(nic);
+		ret = wilc1000_start_firmware(nic);
 		if (ret < 0) {
 			PRINT_ER("Failed to start firmware\n");
 			ret = -EIO;
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 429bdc85ed62..bb4a3acf16d0 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -1,5 +1,6 @@
 #include "wilc_wfi_netdevice.h"
 #include "linux_wlan_sdio.h"
+#include "wilc_wfi_netdevice.h"
 
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/card.h>
@@ -23,7 +24,7 @@
 #endif
 
 
-struct sdio_func *wilc1000_sdio_func;
+static struct sdio_func *wilc1000_sdio_func;
 static unsigned int sdio_default_speed;
 
 #define SDIO_VENDOR_ID_WILC 0x0296
@@ -108,7 +109,83 @@ static int wilc1000_sdio_cmd53(sdio_cmd53_t *cmd)
 	return 1;
 }
 
-volatile int wilc1000_probe; /* COMPLEMENT_BOOT */
+static const struct wilc1000_ops wilc1000_sdio_ops;
+
+#ifdef COMPLEMENT_BOOT
+/* FIXME: remove all of COMPLEMENT_BOOT */
+
+static struct sdio_driver wilc_bus;
+static volatile int wilc1000_probe;
+
+#define READY_CHECK_THRESHOLD		30
+static u8 wilc1000_prepare_11b_core(struct wilc *nic)
+{
+	u8 trials = 0;
+
+	while ((wilc1000_core_11b_ready() && (READY_CHECK_THRESHOLD > (trials++)))) {
+		PRINT_D(INIT_DBG, "11b core not ready yet: %u\n", trials);
+		wilc_wlan_cleanup();
+		wilc_wlan_global_reset();
+		sdio_unregister_driver(&wilc_bus);
+
+		sdio_register_driver(&wilc_bus);
+
+		while (!wilc1000_probe)
+			msleep(100);
+		wilc1000_probe = 0;
+		wilc1000_dev->dev = &wilc1000_sdio_func->dev;
+		nic->ops = &wilc1000_sdio_ops;
+		wilc_wlan_init(nic);
+	}
+
+	if (READY_CHECK_THRESHOLD <= trials)
+		return 1;
+	else
+		return 0;
+
+}
+
+static int repeat_power_cycle(perInterface_wlan_t *nic)
+{
+	int ret = 0;
+	sdio_unregister_driver(&wilc_bus);
+
+	sdio_register_driver(&wilc_bus);
+
+	/* msleep(1000); */
+	while (!wilc1000_probe)
+		msleep(100);
+	wilc1000_probe = 0;
+	wilc1000_dev->dev = &wilc1000_sdio_func->dev;
+	wilc1000_dev->ops = &wilc1000_sdio_ops;
+	ret = wilc_wlan_init(wilc1000_dev);
+
+	wilc1000_dev->mac_status = WILC_MAC_STATUS_INIT;
+#if !defined WILC_SDIO_IRQ_GPIO
+	wilc1000_sdio_enable_interrupt();
+#endif
+
+	if (wilc1000_wlan_get_firmware(nic)) {
+		PRINT_ER("Can't get firmware\n");
+		ret = -1;
+		goto __fail__;
+	}
+
+	/*Download firmware*/
+	ret = wilc1000_firmware_download(wilc1000_dev);
+	if (ret < 0) {
+		PRINT_ER("Failed to download firmware\n");
+		goto __fail__;
+	}
+	/* Start firmware*/
+	ret = wilc1000_start_firmware(nic);
+	if (ret < 0)
+		PRINT_ER("Failed to start firmware\n");
+__fail__:
+	return ret;
+}
+#endif
+
 static int linux_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
 {
 	PRINT_D(INIT_DBG, "probe function\n");
@@ -141,7 +218,7 @@ static void linux_sdio_remove(struct sdio_func *func)
 
 }
 
-struct sdio_driver wilc_bus = {
+static struct sdio_driver wilc_bus = {
 	.name		= SDIO_MODALIAS,
 	.id_table	= wilc_sdio_ids,
 	.probe		= linux_sdio_probe,
@@ -238,10 +315,14 @@ static int wilc1000_sdio_set_default_speed(void)
 	return linux_sdio_set_speed(sdio_default_speed);
 }
 
-const struct wilc1000_ops wilc1000_sdio_ops = {
+static const struct wilc1000_ops wilc1000_sdio_ops = {
 	.io_type = HIF_SDIO,
 	.io_init = wilc1000_sdio_init,
 	.io_deinit = wilc1000_sdio_deinit,
+#ifdef COMPLEMENT_BOOT
+	.repeat_power_cycle = repeat_power_cycle,
+	.prepare_11b_core = wilc1000_prepare_11b_core,
+#endif
 	.u.sdio.sdio_cmd52 = wilc1000_sdio_cmd52,
 	.u.sdio.sdio_cmd53 = wilc1000_sdio_cmd53,
 	.u.sdio.sdio_set_max_speed = wilc1000_sdio_set_max_speed,
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.h b/drivers/staging/wilc1000/linux_wlan_sdio.h
index de79aff9f11c..b4995a3211c7 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.h
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.h
@@ -1,9 +1,5 @@
 #include <linux/mmc/sdio_func.h>
 
-extern struct sdio_func *wilc1000_sdio_func;
-extern struct sdio_driver wilc_bus;
-extern const struct wilc1000_ops wilc1000_sdio_ops;
-
 int wilc1000_sdio_enable_interrupt(void);
 void wilc1000_sdio_disable_interrupt(void);
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 1e5e7dcee11d..ec5a8b1215b7 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -188,7 +188,7 @@ struct wilc {
 	struct device *dev;
 };
 
-typedef struct {
+typedef struct wilc_per_interface {
 	u8 u8IfIdx;
 	u8 iftype;
 	int monitor_flag;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 2297e31b5b75..10b2a2f9e1b2 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -338,7 +338,9 @@ void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size);
 u8 wilc1000_core_11b_ready(void);
 
 extern bool wilc1000_enable_ps;
-extern volatile int wilc1000_probe;
+
+int wilc1000_firmware_download(struct wilc *p_nic);
+int wilc1000_start_firmware(struct wilc_per_interface *nic);
 
 void __init wilc1000_init_driver(void);
 void __exit wilc1000_exit_driver(void);
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index bfa1291e22ed..a4befcb74c82 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -71,10 +71,15 @@ typedef struct {
 	u32 block_size;
 } sdio_cmd53_t;
 
+struct wilc;
+struct wilc_per_interface;
 struct wilc1000_ops {
 	int io_type;
 	int (*io_init)(void *);
 	void (*io_deinit)(void *);
+	int (*repeat_power_cycle)(struct wilc_per_interface *nic);
+	u8 (*prepare_11b_core)(struct wilc *nic);
+
 	union {
 		struct {
 			int (*sdio_cmd52)(sdio_cmd52_t *);
-- 
2.1.0.rc2

