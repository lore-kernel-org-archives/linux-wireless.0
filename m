Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:17025 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbbJTIO4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 04:14:56 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 07/13] staging: wilc1000: wilc1000_wlan_deinit: change argument and use wilc
Date: Tue, 20 Oct 2015 17:13:57 +0900
Message-ID: <1445328843-32247-7-git-send-email-tony.cho@atmel.com> (sfid-20151020_101459_976476_31E2DC7D)
In-Reply-To: <1445328843-32247-1-git-send-email-tony.cho@atmel.com>
References: <1445328843-32247-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

This patch changes function argument wilc with net_device and use nic->wilc
instead of global variable g_linux_wlan. The null check codes should be placed
before it is used so move it.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c             | 45 +++++++++++++----------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  7 ++--
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  1 +
 3 files changed, 29 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 93475aa..2c4673c 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -49,7 +49,6 @@ extern bool g_obtainingIP;
 extern u16 Set_machw_change_vir_if(bool bValue);
 extern void resolve_disconnect_aberration(void *drvHandler);
 extern u8 gau8MulticastMacAddrList[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
-void wilc1000_wlan_deinit(struct wilc *nic);
 extern struct timer_list hDuringIpTimer;
 
 static int linux_wlan_device_power(int on_off)
@@ -860,15 +859,21 @@ _fail_:
 }
 
 /**************************/
-void wilc1000_wlan_deinit(struct wilc *nic)
+void wilc1000_wlan_deinit(struct net_device *dev)
 {
-	if (g_linux_wlan->initialized)	{
-		printk("Deinitializing wilc1000  ...\n");
+	perInterface_wlan_t *nic;
+	struct wilc *wl;
 
-		if (nic == NULL) {
-			PRINT_ER("nic is NULL\n");
-			return;
-		}
+	nic = netdev_priv(dev);
+	wl = nic->wilc;
+
+	if (!wl) {
+		netdev_err(dev, "wl is NULL\n");
+		return;
+	}
+
+	if (wl->initialized)	{
+		netdev_info(dev, "Deinitializing wilc1000...\n");
 
 #if defined(PLAT_ALLWINNER_A20) || defined(PLAT_ALLWINNER_A23) || defined(PLAT_ALLWINNER_A31)
 		/* johnny : remove */
@@ -879,18 +884,18 @@ void wilc1000_wlan_deinit(struct wilc *nic)
 
 		PRINT_D(INIT_DBG, "Disabling IRQ\n");
 #ifdef WILC_SDIO
-		mutex_lock(&g_linux_wlan->hif_cs);
+		mutex_lock(&wl->hif_cs);
 		disable_sdio_interrupt();
-		mutex_unlock(&g_linux_wlan->hif_cs);
+		mutex_unlock(&wl->hif_cs);
 #endif
-		if (&g_linux_wlan->txq_event != NULL)
-			up(&g_linux_wlan->txq_event);
+		if (&wl->txq_event != NULL)
+			up(&wl->txq_event);
 
 		PRINT_D(INIT_DBG, "Deinitializing Threads\n");
-		wlan_deinitialize_threads(nic);
+		wlan_deinitialize_threads(wl);
 
 		PRINT_D(INIT_DBG, "Deinitializing IRQ\n");
-		deinit_irq(g_linux_wlan);
+		deinit_irq(wl);
 
 		wilc_wlan_stop();
 
@@ -900,18 +905,18 @@ void wilc1000_wlan_deinit(struct wilc *nic)
   #if defined(PLAT_ALLWINNER_A20) || defined(PLAT_ALLWINNER_A23) || defined(PLAT_ALLWINNER_A31)
 		PRINT_D(INIT_DBG, "Disabling IRQ 2\n");
 
-		mutex_lock(&g_linux_wlan->hif_cs);
+		mutex_lock(&wl->hif_cs);
 		disable_sdio_interrupt();
-		mutex_unlock(&g_linux_wlan->hif_cs);
+		mutex_unlock(&wl->hif_cs);
   #endif
 #endif
 
 		/*De-Initialize locks*/
 		PRINT_D(INIT_DBG, "Deinitializing Locks\n");
-		wlan_deinit_locks(g_linux_wlan);
+		wlan_deinit_locks(wl);
 
 		/* announce that wilc1000 is not initialized */
-		g_linux_wlan->initialized = false;
+		wl->initialized = false;
 
 		PRINT_D(INIT_DBG, "wilc1000 deinitialization Done\n");
 
@@ -1232,7 +1237,7 @@ int mac_open(struct net_device *ndev)
 
 _err_:
 	wilc_deinit_host_int(ndev);
-	wilc1000_wlan_deinit(wl);
+	wilc1000_wlan_deinit(ndev);
 	return ret;
 }
 
@@ -1431,7 +1436,7 @@ int mac_close(struct net_device *ndev)
 	if (wl->open_ifcs == 0) {
 		PRINT_D(GENERIC_DBG, "Deinitializing wilc1000\n");
 		wl->close = 1;
-		wilc1000_wlan_deinit(wl);
+		wilc1000_wlan_deinit(ndev);
 		WILC_WFI_deinit_mon_interface();
 	}
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 422d462..33a082f 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2523,7 +2523,6 @@ static int set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
  *  @date	01 MAR 2012
  *  @version	1.0
  */
-void wilc1000_wlan_deinit(struct wilc *nic);
 int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic);
 
 static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
@@ -2582,7 +2581,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			/*Eliminate host interface blocking state*/
 			up(&wl->cfg_event);
 
-			wilc1000_wlan_deinit(wl);
+			wilc1000_wlan_deinit(dev);
 			wilc1000_wlan_init(dev, nic);
 			g_wilc_initialized = 1;
 			nic->iftype = interface_type;
@@ -2666,7 +2665,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			/* ensure that the message Q is empty */
 			host_int_wait_msg_queue_idle();
 
-			wilc1000_wlan_deinit(wl);
+			wilc1000_wlan_deinit(dev);
 			wilc1000_wlan_init(dev, nic);
 			g_wilc_initialized = 1;
 
@@ -2780,7 +2779,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 		/* ensure that the message Q is empty */
 		host_int_wait_msg_queue_idle();
-		wilc1000_wlan_deinit(wl);
+		wilc1000_wlan_deinit(dev);
 		wilc1000_wlan_init(dev, nic);
 		g_wilc_initialized = 1;
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 40a44f8..8aa3355 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -215,4 +215,5 @@ void linux_wlan_dbg(u8 *buff);
 int linux_wlan_lock_timeout(void *vp, u32 timeout);
 void wl_wlan_cleanup(void);
 int wilc_netdev_init(struct wilc **wilc);
+void wilc1000_wlan_deinit(struct net_device *dev);
 #endif
-- 
1.9.1

