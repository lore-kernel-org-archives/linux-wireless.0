Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:60019 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbbKPOLL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2015 09:11:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 15/19] staging/wilc1000: turn enable_irq/disable_irq into callbacks
Date: Mon, 16 Nov 2015 15:05:06 +0100
Message-Id: <1447682710-2908925-16-git-send-email-arnd@arndb.de> (sfid-20151116_151118_805865_3CF6681B)
In-Reply-To: <1447682710-2908925-1-git-send-email-arnd@arndb.de>
References: <1447682710-2908925-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As a preparation for turning the SDIO side of wilc1000 into a separate
module, this removes the last direct caller from the core module into
the sdio specific portion. All calls to wilc_sdio_enable_interrupt()
and wilc_sdio_disable_interrupt() now go through a function pointer
in wilc_hif_func. We also change arguments slightly to pass the device,
as we are already touching those lines and the change will be needed
later to remove the global variables.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/linux_wlan.c      | 22 +++++++++++++---------
 drivers/staging/wilc1000/linux_wlan_sdio.c | 21 +++++++++++----------
 drivers/staging/wilc1000/linux_wlan_sdio.h |  4 ++--
 drivers/staging/wilc1000/wilc_sdio.c       |  2 ++
 drivers/staging/wilc1000/wilc_wlan.h       |  2 ++
 5 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 2fb1d97bded1..1b6e1eec2446 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -25,8 +25,6 @@
 
 #include <linux/semaphore.h>
 
-#include "linux_wlan_sdio.h"
-
 static int dev_state_ev_handler(struct notifier_block *this, unsigned long event, void *ptr);
 
 static struct notifier_block g_dev_notifier = {
@@ -739,9 +737,10 @@ void wilc1000_wlan_deinit(struct net_device *dev)
 #endif
 
 		PRINT_D(INIT_DBG, "Disabling IRQ\n");
-		if (!wl->dev_irq_num) {
+		if (!wl->dev_irq_num &&
+		    wl->ops->disable_interrupt) {
 			mutex_lock(&wl->hif_cs);
-			wilc_sdio_disable_interrupt();
+			wl->ops->disable_interrupt(wl);
 			mutex_unlock(&wl->hif_cs);
 		}
 		if (&wl->txq_event)
@@ -758,11 +757,13 @@ void wilc1000_wlan_deinit(struct net_device *dev)
 		PRINT_D(INIT_DBG, "Deinitializing WILC Wlan\n");
 		wilc_wlan_cleanup(dev);
 #if defined(PLAT_ALLWINNER_A20) || defined(PLAT_ALLWINNER_A23) || defined(PLAT_ALLWINNER_A31)
-		if (!wl->dev_irq_num) {
+		if (!wl->dev_irq_num &&
+		    wl->ops->disable_interrupt) {
+
 			PRINT_D(INIT_DBG, "Disabling IRQ 2\n");
 
 			mutex_lock(&wl->hif_cs);
-			wilc_sdio_disable_interrupt();
+			wl->ops->disable_interrupt(wl);
 			mutex_unlock(&wl->hif_cs);
 		}
 #endif
@@ -897,7 +898,9 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 			goto _fail_wilc_wlan_;
 		}
 
-		if (!wl->dev_irq_num && wilc_sdio_enable_interrupt()) {
+		if (!wl->dev_irq_num &&
+		    wl->ops->enable_interrupt &&
+		    wl->ops->enable_interrupt(wl)) {
 			PRINT_ER("couldn't initialize IRQ\n");
 			ret = -EIO;
 			goto _fail_irq_init_;
@@ -950,8 +953,9 @@ _fail_fw_start_:
 		wilc_wlan_stop();
 
 _fail_irq_enable_:
-		if (!wl->dev_irq_num)
-			wilc_sdio_disable_interrupt();
+		if (!wl->dev_irq_num &&
+		    wl->ops->disable_interrupt)
+			wl->ops->disable_interrupt(wl);
 _fail_irq_init_:
 		if (wl->dev_irq_num)
 			deinit_irq(dev);
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index f4250fda6cf1..9072de43bcd9 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -1,5 +1,4 @@
 #include "wilc_wfi_netdevice.h"
-#include "linux_wlan_sdio.h"
 
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/card.h>
@@ -8,7 +7,7 @@
 #include <linux/mmc/host.h>
 #include <linux/of_gpio.h>
 
-
+#include "linux_wlan_sdio.h"
 
 #define SDIO_MODALIAS "wilc1000_sdio"
 
@@ -143,13 +142,14 @@ static struct sdio_driver wilc_bus = {
 	.remove		= linux_sdio_remove,
 };
 
-int wilc_sdio_enable_interrupt(void)
+int wilc_sdio_enable_interrupt(struct wilc *dev)
 {
+	struct sdio_func *func = container_of(dev->dev, struct sdio_func, dev);
 	int ret = 0;
 
-	sdio_claim_host(wilc_sdio_func);
-	ret = sdio_claim_irq(wilc_sdio_func, wilc_sdio_interrupt);
-	sdio_release_host(wilc_sdio_func);
+	sdio_claim_host(func);
+	ret = sdio_claim_irq(func, wilc_sdio_interrupt);
+	sdio_release_host(func);
 
 	if (ret < 0) {
 		PRINT_ER("can't claim sdio_irq, err(%d)\n", ret);
@@ -158,18 +158,19 @@ int wilc_sdio_enable_interrupt(void)
 	return ret;
 }
 
-void wilc_sdio_disable_interrupt(void)
+void wilc_sdio_disable_interrupt(struct wilc *dev)
 {
+	struct sdio_func *func = container_of(dev->dev, struct sdio_func, dev);
 	int ret;
 
 	PRINT_D(INIT_DBG, "wilc_sdio_disable_interrupt IN\n");
 
-	sdio_claim_host(wilc_sdio_func);
-	ret = sdio_release_irq(wilc_sdio_func);
+	sdio_claim_host(func);
+	ret = sdio_release_irq(func);
 	if (ret < 0) {
 		PRINT_ER("can't release sdio_irq, err(%d)\n", ret);
 	}
-	sdio_release_host(wilc_sdio_func);
+	sdio_release_host(func);
 
 	PRINT_D(INIT_DBG, "wilc_sdio_disable_interrupt OUT\n");
 }
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.h b/drivers/staging/wilc1000/linux_wlan_sdio.h
index df733c25e770..d7b213a7b18d 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.h
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.h
@@ -4,8 +4,8 @@ int wilc_sdio_init(void);
 int wilc_sdio_cmd52(sdio_cmd52_t *cmd);
 int wilc_sdio_cmd53(sdio_cmd53_t *cmd);
 
-int wilc_sdio_enable_interrupt(void);
-void wilc_sdio_disable_interrupt(void);
+int wilc_sdio_enable_interrupt(struct wilc *);
+void wilc_sdio_disable_interrupt(struct wilc *);
 int wilc_sdio_set_max_speed(void);
 int wilc_sdio_set_default_speed(void);
 
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 006aae4679cb..f550ce059c15 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -929,5 +929,7 @@ const struct wilc_hif_func wilc_hif_sdio = {
 	.hif_sync_ext = sdio_sync_ext,
 	.hif_set_max_bus_speed = sdio_set_max_speed,
 	.hif_set_default_bus_speed = sdio_set_default_speed,
+	.enable_interrupt = wilc_sdio_enable_interrupt,
+	.disable_interrupt = wilc_sdio_disable_interrupt,
 };
 
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index c0a5a955b1d4..44a590f80def 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -256,6 +256,8 @@ struct wilc_hif_func {
 	int (*hif_sync_ext)(int);
 	void (*hif_set_max_bus_speed)(void);
 	void (*hif_set_default_bus_speed)(void);
+	int (*enable_interrupt)(struct wilc *nic);
+	void (*disable_interrupt)(struct wilc *nic);
 };
 
 extern const struct wilc_hif_func wilc_hif_spi;
-- 
2.1.0.rc2

