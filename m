Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:43700 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbbJNLsY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 07:48:24 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 12/16] staging: wilc1000: move clean up codes into wl_wlan_cleanup function
Date: Wed, 14 Oct 2015 20:46:40 +0900
Message-ID: <1444823204-16736-12-git-send-email-tony.cho@atmel.com> (sfid-20151014_134831_139358_A12E105D)
In-Reply-To: <1444823204-16736-1-git-send-email-tony.cho@atmel.com>
References: <1444823204-16736-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

This patch moves clean up codes from exit_wilc_driver into the wl_wlan_cleanup
newly introduced in this patch. In addition, it is called by linux_sdio_remove
function.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 87 ++++++++++++---------------
 drivers/staging/wilc1000/linux_wlan_sdio.c    |  5 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  2 +-
 3 files changed, 42 insertions(+), 52 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 3d02ae7..e22d164 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1694,6 +1694,46 @@ void WILC_WFI_mgmt_rx(u8 *buff, u32 size)
 		WILC_WFI_p2p_rx(wl->vif[1].ndev, buff, size);
 }
 
+void wl_wlan_cleanup(void)
+{
+	int i = 0;
+	perInterface_wlan_t *nic[NUM_CONCURRENT_IFC];
+
+	if (wl && (wl->vif[0].ndev || wl->vif[1].ndev)) {
+		unregister_inetaddr_notifier(&g_dev_notifier);
+
+		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
+			nic[i] = netdev_priv(wl->vif[i].ndev);
+	}
+
+	if (wl && wl->wilc_firmware)
+		release_firmware(wl->wilc_firmware);
+
+	if (wl && (wl->vif[0].ndev || wl->vif[1].ndev)) {
+		linux_wlan_lock_timeout(&close_exit_sync, 12 * 1000);
+
+		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
+			if (wl->vif[i].ndev)
+				if (nic[i]->mac_opened)
+					mac_close(wl->vif[i].ndev);
+
+		for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
+			unregister_netdev(wl->vif[i].ndev);
+			wilc_free_wiphy(wl->vif[i].ndev);
+			free_netdev(wl->vif[i].ndev);
+		}
+	}
+
+	if (wl)
+		kfree(wl);
+
+#if defined(WILC_DEBUGFS)
+	wilc_debugfs_remove();
+#endif
+	linux_wlan_device_detection(0);
+	linux_wlan_device_power(0);
+}
+
 int wilc_netdev_init(void)
 {
 
@@ -1826,44 +1866,6 @@ late_initcall(init_wilc_driver);
 
 static void __exit exit_wilc_driver(void)
 {
-	int i = 0;
-	perInterface_wlan_t *nic[NUM_CONCURRENT_IFC] = {NULL,};
-	#define CLOSE_TIMEOUT (12 * 1000)
-
-	if (wl && (wl->vif[0].ndev || wl->vif[1].ndev)) {
-		unregister_inetaddr_notifier(&g_dev_notifier);
-
-		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
-			nic[i] = netdev_priv(wl->vif[i].ndev);
-	}
-
-	if (wl && wl->wilc_firmware) {
-		release_firmware(wl->wilc_firmware);
-		wl->wilc_firmware = NULL;
-	}
-
-	if (wl && (wl->vif[0].ndev || wl->vif[1].ndev)) {
-		PRINT_D(INIT_DBG, "Waiting for mac_close ....\n");
-
-		if (linux_wlan_lock_timeout(&close_exit_sync, CLOSE_TIMEOUT) < 0)
-			PRINT_D(INIT_DBG, "Closed TimedOUT\n");
-		else
-			PRINT_D(INIT_DBG, "mac_closed\n");
-
-		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
-			if (wl->vif[i].ndev)
-				if (nic[i]->mac_opened)
-					mac_close(wl->vif[i].ndev);
-
-		for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
-			unregister_netdev(wl->vif[i].ndev);
-			PRINT_D(INIT_DBG, "Freeing Wiphy...\n");
-			wilc_free_wiphy(wl->vif[i].ndev);
-			PRINT_D(INIT_DBG, "Freeing netdev...\n");
-			free_netdev(wl->vif[i].ndev);
-		}
-	}
-
 #ifndef WILC_SDIO
 	PRINT_D(INIT_DBG, "SPI unregsiter...\n");
 	spi_unregister_driver(&wilc_bus);
@@ -1871,15 +1873,6 @@ static void __exit exit_wilc_driver(void)
 	PRINT_D(INIT_DBG, "SDIO unregsiter...\n");
 	sdio_unregister_driver(&wilc_bus);
 #endif
-	kfree(wl);
-	printk("Module_exit Done.\n");
-
-#if defined(WILC_DEBUGFS)
-	wilc_debugfs_remove();
-#endif
-
-	linux_wlan_device_detection(0);
-	linux_wlan_device_power(0);
 }
 module_exit(exit_wilc_driver);
 
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 0dd4b19..c78f3a5 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -136,10 +136,7 @@ static int linux_sdio_probe(struct sdio_func *func, const struct sdio_device_id
 
 static void linux_sdio_remove(struct sdio_func *func)
 {
-	/**
-	 *      TODO
-	 **/
-
+	wl_wlan_cleanup();
 }
 
 struct sdio_driver wilc_bus = {
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 54b6039..4f7c600 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -213,5 +213,5 @@ void linux_wlan_mac_indicate(int flag);
 void linux_wlan_rx_complete(void);
 void linux_wlan_dbg(u8 *buff);
 int linux_wlan_lock_timeout(void *vp, u32 timeout);
-
+void wl_wlan_cleanup(void);
 #endif
-- 
1.9.1

