Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:52140 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbbJWF2L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 01:28:11 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 23/28] staging: wilc1000: Set_machw_change_vir_if: add argument dev
Date: Fri, 23 Oct 2015 14:28:39 +0900
Message-ID: <1445578124-31486-23-git-send-email-glen.lee@atmel.com> (sfid-20151023_074700_317783_19279901)
In-Reply-To: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
References: <1445578124-31486-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add new argument net_device *dev and use netdev private data member wilc
instead of g_linux_wlan. Pass argument dev to the function as well.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c             |  3 +--
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  7 +++----
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  1 +
 drivers/staging/wilc1000/wilc_wlan.c              | 12 ++++++++----
 4 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 9d03235..a2d8053 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -46,7 +46,6 @@
 #endif
 
 extern bool g_obtainingIP;
-extern u16 Set_machw_change_vir_if(bool bValue);
 extern void resolve_disconnect_aberration(void *drvHandler);
 extern u8 gau8MulticastMacAddrList[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
 extern struct timer_list hDuringIpTimer;
@@ -1237,7 +1236,7 @@ int mac_open(struct net_device *ndev)
 		return ret;
 	}
 
-	Set_machw_change_vir_if(false);
+	Set_machw_change_vir_if(ndev, false);
 
 	host_int_get_MacAddress(priv->hWILCWFIDrv, mac_add);
 	PRINT_D(INIT_DBG, "Mac address: %pM\n", mac_add);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 7b21bea..624ad15 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -22,7 +22,6 @@
 #define GET_PKT_OFFSET(a) (((a) >> 22) & 0x1ff)
 
 extern int linux_wlan_get_firmware(perInterface_wlan_t *p_nic);
-extern u16 Set_machw_change_vir_if(bool bValue);
 
 extern int mac_open(struct net_device *ndev);
 extern int mac_close(struct net_device *ndev);
@@ -1413,7 +1412,7 @@ static int del_key(struct wiphy *wiphy, struct net_device *netdev,
 		g_key_gtk_params.seq = NULL;
 
 		/*Reset WILC_CHANGING_VIR_IF register to allow adding futrue keys to CE H/W*/
-		Set_machw_change_vir_if(false);
+		Set_machw_change_vir_if(netdev, false);
 	}
 
 	if (key_index >= 0 && key_index <= 3) {
@@ -2562,7 +2561,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 	PRINT_D(GENERIC_DBG, "Changing virtual interface, enable scan\n");
 	/*Set WILC_CHANGING_VIR_IF register to disallow adding futrue keys to CE H/W*/
 	if (g_ptk_keys_saved && g_gtk_keys_saved) {
-		Set_machw_change_vir_if(true);
+		Set_machw_change_vir_if(dev, true);
 	}
 
 	switch (type) {
@@ -2724,7 +2723,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 			/*Refresh scan, to refresh the scan results to the wpa_supplicant. Set MachHw to false to enable further key installments*/
 			refresh_scan(priv, 1, true);
-			Set_machw_change_vir_if(false);
+			Set_machw_change_vir_if(dev, false);
 
 			if (wl->initialized)	{
 				for (i = 0; i < num_reg_frame; i++) {
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index bca3e25..0bfe762 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -217,4 +217,5 @@ void wl_wlan_cleanup(void);
 int wilc_netdev_init(struct wilc **wilc);
 void wilc1000_wlan_deinit(struct net_device *dev);
 void WILC_WFI_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size);
+u16 Set_machw_change_vir_if(struct net_device *dev, bool bValue);
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index e197c88..8cc533a 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -19,7 +19,6 @@
 extern wilc_hif_func_t hif_sdio;
 extern wilc_hif_func_t hif_spi;
 u32 wilc_get_chipid(u8 update);
-u16 Set_machw_change_vir_if(bool bValue);
 
 
 
@@ -2033,13 +2032,18 @@ _fail_:
 
 }
 
-u16 Set_machw_change_vir_if(bool bValue)
+u16 Set_machw_change_vir_if(struct net_device *dev, bool bValue)
 {
 	u16 ret;
 	u32 reg;
+	perInterface_wlan_t *nic;
+	struct wilc *wl;
+
+	nic = netdev_priv(dev);
+	wl = nic->wilc;
 
 	/*Reset WILC_CHANGING_VIR_IF register to allow adding futrue keys to CE H/W*/
-	mutex_lock(&g_linux_wlan->hif_cs);
+	mutex_lock(&wl->hif_cs);
 	ret = (&g_wlan)->hif_func.hif_read_reg(WILC_CHANGING_VIR_IF, &reg);
 	if (!ret)
 		PRINT_ER("Error while Reading reg WILC_CHANGING_VIR_IF\n");
@@ -2054,7 +2058,7 @@ u16 Set_machw_change_vir_if(bool bValue)
 	if (!ret)
 		PRINT_ER("Error while writing reg WILC_CHANGING_VIR_IF\n");
 
-	mutex_unlock(&g_linux_wlan->hif_cs);
+	mutex_unlock(&wl->hif_cs);
 
 	return ret;
 }
-- 
1.9.1

