Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:64363 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673AbbJTWsS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 18:48:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-wireless@vger.kernel.org
Cc: Rachel Kim <rachel.kim@atmel.com>, devel@driverdev.osuosl.org,
	Chris Park <chris.park@atmel.com>, gregkh@linuxfoundation.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org, Tony Cho <tony.cho@atmel.com>,
	Glen Lee <glen.lee@atmel.com>, Leo Kim <leo.kim@atmel.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 15/19] staging/wilc1000: turn enable_irq/disable_irq into callbacks
Date: Wed, 21 Oct 2015 00:47:34 +0200
Message-Id: <1445381258-1455986-16-git-send-email-arnd@arndb.de> (sfid-20151021_004912_625398_A7E18A95)
In-Reply-To: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
References: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As a preparation for turning the SDIO side of wilc1000 into a separate
module, this removes the last direct caller from the core module into
the sdio specific portion. All calls to wilc1000_sdio_enable_interrupt()
and wilc1000_sdio_disable_interrupt() now go through a function pointer
in wilc1000_ops. We also change arguments slightly to pass the device,
as we are already touching those lines and the change will be needed
later to remove the global variables.

The linux_wlan_sdio.h file is now unused and gets deleted.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/linux_wlan.c      | 21 ++++++++++++---------
 drivers/staging/wilc1000/linux_wlan_sdio.c | 23 +++++++++++++----------
 drivers/staging/wilc1000/linux_wlan_sdio.h |  5 -----
 drivers/staging/wilc1000/wilc_wlan_if.h    |  2 ++
 4 files changed, 27 insertions(+), 24 deletions(-)
 delete mode 100644 drivers/staging/wilc1000/linux_wlan_sdio.h

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index beafc543aac3..7b0ac31f04a2 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -26,8 +26,6 @@
 #include <linux/version.h>
 #include <linux/semaphore.h>
 
-#include "linux_wlan_sdio.h"
-
 static int dev_state_ev_handler(struct notifier_block *this, unsigned long event, void *ptr);
 
 static struct notifier_block g_dev_notifier = {
@@ -826,9 +824,10 @@ void wilc1000_wlan_deinit(struct wilc *nic)
 #endif
 
 		PRINT_D(INIT_DBG, "Disabling IRQ\n");
-		if (wilc1000_dev->gpio < 0) {
+		if (wilc1000_dev->gpio < 0 &&
+		    wilc1000_dev->ops->disable_interrupt) {
 			mutex_lock(&wilc1000_dev->hif_cs);
-			wilc1000_sdio_disable_interrupt();
+			wilc1000_dev->ops->disable_interrupt(wilc1000_dev);
 			mutex_unlock(&wilc1000_dev->hif_cs);
 		}
 		if (&wilc1000_dev->txq_event != NULL)
@@ -845,11 +844,12 @@ void wilc1000_wlan_deinit(struct wilc *nic)
 		PRINT_D(INIT_DBG, "Deinitializing WILC Wlan\n");
 		wilc_wlan_cleanup();
 #if defined(PLAT_ALLWINNER_A20) || defined(PLAT_ALLWINNER_A23) || defined(PLAT_ALLWINNER_A31)
-		if (wilc1000_dev->gpio < 0) {
+		if (wilc1000_dev->gpio < 0 &&
+		    wilc1000_dev->ops->disable_interrupt) {
 			PRINT_D(INIT_DBG, "Disabling IRQ 2\n");
 
 			mutex_lock(&wilc1000_dev->hif_cs);
-			wilc1000_sdio_disable_interrupt();
+			wilc1000_dev->ops->disable_interrupt(wilc1000_dev);
 			mutex_unlock(&wilc1000_dev->hif_cs);
 #endif
 
@@ -983,7 +983,9 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 			goto _fail_threads_;
 		}
 
-		if (wilc1000_dev->gpio < 0 && wilc1000_sdio_enable_interrupt()) {
+		if (wilc1000_dev->gpio < 0 &&
+		    wilc1000_dev->ops->enable_interrupt &&
+		    wilc1000_dev->ops->enable_interrupt(wilc1000_dev)) {
 			PRINT_ER("couldn't initialize IRQ\n");
 			ret = -EIO;
 			goto _fail_irq_init_;
@@ -1039,8 +1041,9 @@ _fail_fw_start_:
 		wilc_wlan_stop();
 
 _fail_irq_enable_:
-		if (wilc1000_dev->gpio < 0)
-			wilc1000_sdio_disable_interrupt();
+		if (wilc1000_dev->gpio < 0 &&
+		    wilc1000_dev->ops->disable_interrupt)
+			wilc1000_dev->ops->disable_interrupt(wilc1000_dev);
 _fail_irq_init_:
 		if (wilc1000_dev->gpio >= 0)
 			deinit_irq(wilc1000_dev);
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 64c8c5725277..86251b907197 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -1,5 +1,4 @@
 #include "wilc_wfi_netdevice.h"
-#include "linux_wlan_sdio.h"
 #include "wilc_wfi_netdevice.h"
 
 #include <linux/mmc/sdio_func.h>
@@ -160,7 +159,7 @@ static int repeat_power_cycle(perInterface_wlan_t *nic)
 
 	wilc1000_dev->mac_status = WILC_MAC_STATUS_INIT;
 	if (wilc1000_dev->gpio < 0)
-		wilc1000_sdio_enable_interrupt();
+		wilc1000_dev->ops->enable_interrupt(wilc1000_dev);
 
 	if (wilc1000_wlan_get_firmware(nic)) {
 		PRINT_ER("Can't get firmware\n");
@@ -232,13 +231,14 @@ static struct sdio_driver wilc_bus = {
 	.remove		= linux_sdio_remove,
 };
 
-int wilc1000_sdio_enable_interrupt(void)
+static int wilc1000_sdio_enable_interrupt(struct wilc *dev)
 {
+	struct sdio_func *func = container_of(dev->dev, struct sdio_func, dev);
 	int ret = 0;
 
-	sdio_claim_host(wilc1000_sdio_func);
-	ret = sdio_claim_irq(wilc1000_sdio_func, wilc_sdio_interrupt);
-	sdio_release_host(wilc1000_sdio_func);
+	sdio_claim_host(func);
+	ret = sdio_claim_irq(func, wilc_sdio_interrupt);
+	sdio_release_host(func);
 
 	if (ret < 0) {
 		PRINT_ER("can't claim sdio_irq, err(%d)\n", ret);
@@ -247,18 +247,19 @@ int wilc1000_sdio_enable_interrupt(void)
 	return ret;
 }
 
-void wilc1000_sdio_disable_interrupt(void)
+static void wilc1000_sdio_disable_interrupt(struct wilc *dev)
 {
+	struct sdio_func *func = container_of(dev->dev, struct sdio_func, dev);
 	int ret;
 
 	PRINT_D(INIT_DBG, "wilc1000_sdio_disable_interrupt IN\n");
 
-	sdio_claim_host(wilc1000_sdio_func);
-	ret = sdio_release_irq(wilc1000_sdio_func);
+	sdio_claim_host(func);
+	ret = sdio_release_irq(func);
 	if (ret < 0) {
 		PRINT_ER("can't release sdio_irq, err(%d)\n", ret);
 	}
-	sdio_release_host(wilc1000_sdio_func);
+	sdio_release_host(func);
 
 	PRINT_D(INIT_DBG, "wilc1000_sdio_disable_interrupt OUT\n");
 }
@@ -325,6 +326,8 @@ static const struct wilc1000_ops wilc1000_sdio_ops = {
 	.repeat_power_cycle = repeat_power_cycle,
 	.prepare_11b_core = wilc1000_prepare_11b_core,
 #endif
+	.enable_interrupt = wilc1000_sdio_enable_interrupt,
+	.disable_interrupt = wilc1000_sdio_disable_interrupt,
 	.u.sdio.sdio_cmd52 = wilc1000_sdio_cmd52,
 	.u.sdio.sdio_cmd53 = wilc1000_sdio_cmd53,
 	.u.sdio.sdio_set_max_speed = wilc1000_sdio_set_max_speed,
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.h b/drivers/staging/wilc1000/linux_wlan_sdio.h
deleted file mode 100644
index b4995a3211c7..000000000000
--- a/drivers/staging/wilc1000/linux_wlan_sdio.h
+++ /dev/null
@@ -1,5 +0,0 @@
-#include <linux/mmc/sdio_func.h>
-
-int wilc1000_sdio_enable_interrupt(void);
-void wilc1000_sdio_disable_interrupt(void);
-
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index a4befcb74c82..2fdf411d6e13 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -79,6 +79,8 @@ struct wilc1000_ops {
 	void (*io_deinit)(void *);
 	int (*repeat_power_cycle)(struct wilc_per_interface *nic);
 	u8 (*prepare_11b_core)(struct wilc *nic);
+	int (*enable_interrupt)(struct wilc *nic);
+	void (*disable_interrupt)(struct wilc *nic);
 
 	union {
 		struct {
-- 
2.1.0.rc2

