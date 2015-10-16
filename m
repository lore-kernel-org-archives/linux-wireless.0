Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:34544 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbbJPJYA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 05:24:00 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 07/13] staging: wilc1000: wilc1000_wlan_deinit: change argument and use nic->wilc
Date: Fri, 16 Oct 2015 18:23:03 +0900
Message-ID: <1444987389-14151-7-git-send-email-tony.cho@atmel.com> (sfid-20151016_112405_554391_E4006AE5)
In-Reply-To: <1444987389-14151-1-git-send-email-tony.cho@atmel.com>
References: <1444987389-14151-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Glen Lee <glen.lee@atmel.com>

This patch changes function argument wilc with net_device and use nic->wilc
instead of global variable wl. The null check codes should be placed before it
is used so move it.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c             | 25 ++++++++++++++---------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  7 +++----
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  1 +
 3 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 8c98a0c..b32a8ce 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -49,7 +49,6 @@ extern bool g_obtainingIP;
 extern u16 Set_machw_change_vir_if(bool bValue);
 extern void resolve_disconnect_aberration(void *drvHandler);
 extern u8 gau8MulticastMacAddrList[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
-void wilc1000_wlan_deinit(struct wilc *nic);
 extern struct timer_list hDuringIpTimer;
 
 static int linux_wlan_device_power(int on_off)
@@ -861,16 +860,22 @@ _fail_:
 }
 
 /**************************/
-void wilc1000_wlan_deinit(struct wilc *nic)
+void wilc1000_wlan_deinit(struct net_device *dev)
 {
+	perInterface_wlan_t *nic;
+	struct wilc *wl;
+
+	nic = netdev_priv(dev);
+	wl = nic->wilc;
+
+	if (!wl) {
+		netdev_err(dev, "wl is NULL\n");
+		return;
+	}
+
 	if (wl->initialized) {
 		printk("Deinitializing wilc1000  ...\n");
 
-		if (nic == NULL) {
-			PRINT_ER("nic is NULL\n");
-			return;
-		}
-
 #if defined(PLAT_ALLWINNER_A20) || defined(PLAT_ALLWINNER_A23) || defined(PLAT_ALLWINNER_A31)
 		/* johnny : remove */
 		PRINT_D(INIT_DBG, "skip wilc_bus_set_default_speed\n");
@@ -888,7 +893,7 @@ void wilc1000_wlan_deinit(struct wilc *nic)
 			up(&wl->txq_event);
 
 		PRINT_D(INIT_DBG, "Deinitializing Threads\n");
-		wlan_deinitialize_threads(nic);
+		wlan_deinitialize_threads(wl);
 
 		PRINT_D(INIT_DBG, "Deinitializing IRQ\n");
 		deinit_irq(wl);
@@ -1226,7 +1231,7 @@ int mac_open(struct net_device *ndev)
 
 _err_:
 	wilc_deinit_host_int(ndev);
-	wilc1000_wlan_deinit(wl);
+	wilc1000_wlan_deinit(ndev);
 	return ret;
 }
 
@@ -1425,7 +1430,7 @@ int mac_close(struct net_device *ndev)
 	if (wl->open_ifcs == 0) {
 		PRINT_D(GENERIC_DBG, "Deinitializing wilc1000\n");
 		wl->close = 1;
-		wilc1000_wlan_deinit(wl);
+		wilc1000_wlan_deinit(ndev);
 		WILC_WFI_deinit_mon_interface();
 	}
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index b34b7d0..270f454 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2522,7 +2522,6 @@ static int set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
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
@@ -2664,7 +2663,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			/* ensure that the message Q is empty */
 			host_int_wait_msg_queue_idle();
 
-			wilc1000_wlan_deinit(wl);
+			wilc1000_wlan_deinit(dev);
 			wilc1000_wlan_init(dev, nic);
 			g_wilc_initialized = 1;
 
@@ -2778,7 +2777,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 		/* ensure that the message Q is empty */
 		host_int_wait_msg_queue_idle();
-		wilc1000_wlan_deinit(wl);
+		wilc1000_wlan_deinit(dev);
 		wilc1000_wlan_init(dev, nic);
 		g_wilc_initialized = 1;
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index cb23134..5769359 100644
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

