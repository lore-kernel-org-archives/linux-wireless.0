Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:6063 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312AbbJ1Hqb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:46:31 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 10/12] staging: wilc1000: wl_wlan_cleanup: add argument struct wilc
Date: Wed, 28 Oct 2015 16:48:26 +0900
Message-ID: <1446018508-17889-10-git-send-email-glen.lee@atmel.com> (sfid-20151028_084638_754583_27F4F971)
In-Reply-To: <1446018508-17889-1-git-send-email-glen.lee@atmel.com>
References: <1446018508-17889-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds new argument struct wilc and use it instead of g_linux_wlan.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 28 +++++++++++++--------------
 drivers/staging/wilc1000/linux_wlan_sdio.c    |  2 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  2 +-
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 971b154..017799f 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1652,39 +1652,39 @@ void WILC_WFI_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size)
 		WILC_WFI_p2p_rx(wilc->vif[1].ndev, buff, size);
 }
 
-void wl_wlan_cleanup(void)
+void wl_wlan_cleanup(struct wilc *wilc)
 {
 	int i = 0;
 	perInterface_wlan_t *nic[NUM_CONCURRENT_IFC];
 
-	if (g_linux_wlan &&
-	   (g_linux_wlan->vif[0].ndev || g_linux_wlan->vif[1].ndev)) {
+	if (wilc &&
+	   (wilc->vif[0].ndev || wilc->vif[1].ndev)) {
 		unregister_inetaddr_notifier(&g_dev_notifier);
 
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
-			nic[i] = netdev_priv(g_linux_wlan->vif[i].ndev);
+			nic[i] = netdev_priv(wilc->vif[i].ndev);
 	}
 
-	if (g_linux_wlan && g_linux_wlan->firmware)
-		release_firmware(g_linux_wlan->firmware);
+	if (wilc && wilc->firmware)
+		release_firmware(wilc->firmware);
 
-	if (g_linux_wlan &&
-	   (g_linux_wlan->vif[0].ndev || g_linux_wlan->vif[1].ndev)) {
+	if (wilc&&
+	   (wilc->vif[0].ndev || wilc->vif[1].ndev)) {
 		linux_wlan_lock_timeout(&close_exit_sync, 12 * 1000);
 
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++)
-			if (g_linux_wlan->vif[i].ndev)
+			if (wilc->vif[i].ndev)
 				if (nic[i]->mac_opened)
-					mac_close(g_linux_wlan->vif[i].ndev);
+					mac_close(wilc->vif[i].ndev);
 
 		for (i = 0; i < NUM_CONCURRENT_IFC; i++) {
-			unregister_netdev(g_linux_wlan->vif[i].ndev);
-			wilc_free_wiphy(g_linux_wlan->vif[i].ndev);
-			free_netdev(g_linux_wlan->vif[i].ndev);
+			unregister_netdev(wilc->vif[i].ndev);
+			wilc_free_wiphy(wilc->vif[i].ndev);
+			free_netdev(wilc->vif[i].ndev);
 		}
 	}
 
-	kfree(g_linux_wlan);
+	kfree(wilc);
 
 #if defined(WILC_DEBUGFS)
 	wilc_debugfs_remove();
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 4aff953..bf05e22 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -146,7 +146,7 @@ static void linux_sdio_remove(struct sdio_func *func)
 	struct wilc_sdio *wl_sdio;
 
 	wl_sdio = sdio_get_drvdata(func);
-	wl_wlan_cleanup();
+	wl_wlan_cleanup(wl_sdio->wilc);
 	kfree(wl_sdio);
 }
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 0435cb5..07917ea 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -213,7 +213,7 @@ void linux_wlan_mac_indicate(struct wilc *wilc, int flag);
 void linux_wlan_rx_complete(void);
 void linux_wlan_dbg(u8 *buff);
 int linux_wlan_lock_timeout(void *vp, u32 timeout);
-void wl_wlan_cleanup(void);
+void wl_wlan_cleanup(struct wilc *wilc);
 int wilc_netdev_init(struct wilc **wilc);
 void wilc1000_wlan_deinit(struct net_device *dev);
 void WILC_WFI_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size);
-- 
1.9.1

