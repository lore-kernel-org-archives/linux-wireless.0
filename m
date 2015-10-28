Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:6048 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609AbbJ1HqZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:46:25 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 09/12] staging: wilc1000: linux_wlan_get_firmware: change argument p_nic with dev
Date: Wed, 28 Oct 2015 16:48:25 +0900
Message-ID: <1446018508-17889-9-git-send-email-glen.lee@atmel.com> (sfid-20151028_084632_855064_F9E1B0CA)
In-Reply-To: <1446018508-17889-1-git-send-email-glen.lee@atmel.com>
References: <1446018508-17889-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes argument perInterface_wlan_t *p_nic with struct net_device
*dev and use netdev private data nic and it's member wilc instead of
g_linux_wlan.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c             | 17 ++++++++++-------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  4 +---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  1 +
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 895eb60..971b154 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -518,14 +518,17 @@ void linux_wlan_rx_complete(void)
 	PRINT_D(RX_DBG, "RX completed\n");
 }
 
-int linux_wlan_get_firmware(perInterface_wlan_t *p_nic)
+int linux_wlan_get_firmware(struct net_device *dev)
 {
-
-	perInterface_wlan_t *nic = p_nic;
+	perInterface_wlan_t *nic;
+	struct wilc *wilc;
 	int ret = 0;
 	const struct firmware *wilc_firmware;
 	char *firmware;
 
+	nic = netdev_priv(dev);
+	wilc = nic->wilc;
+
 	if (nic->iftype == AP_MODE)
 		firmware = AP_FIRMWARE;
 	else if (nic->iftype == STATION_MODE)
@@ -550,19 +553,19 @@ int linux_wlan_get_firmware(perInterface_wlan_t *p_nic)
 	 *      root file system with the name specified above */
 
 #ifdef WILC_SDIO
-	if (request_firmware(&wilc_firmware, firmware, &g_linux_wlan->wilc_sdio_func->dev) != 0) {
+	if (request_firmware(&wilc_firmware, firmware, &wilc->wilc_sdio_func->dev) != 0) {
 		PRINT_ER("%s - firmare not available\n", firmware);
 		ret = -1;
 		goto _fail_;
 	}
 #else
-	if (request_firmware(&wilc_firmware, firmware, &g_linux_wlan->wilc_spidev->dev) != 0) {
+	if (request_firmware(&wilc_firmware, firmware, &wilc->wilc_spidev->dev) != 0) {
 		PRINT_ER("%s - firmare not available\n", firmware);
 		ret = -1;
 		goto _fail_;
 	}
 #endif
-	g_linux_wlan->firmware = wilc_firmware;
+	wilc->firmware = wilc_firmware;
 
 _fail_:
 
@@ -1126,7 +1129,7 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 		}
 #endif
 
-		if (linux_wlan_get_firmware(nic)) {
+		if (linux_wlan_get_firmware(dev)) {
 			PRINT_ER("Can't get firmware\n");
 			ret = -EIO;
 			goto _fail_irq_enable_;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index bcc71ff..f7c3648 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -21,8 +21,6 @@
 #define IS_MGMT_STATUS_SUCCES			0x040
 #define GET_PKT_OFFSET(a) (((a) >> 22) & 0x1ff)
 
-extern int linux_wlan_get_firmware(perInterface_wlan_t *p_nic);
-
 extern int mac_open(struct net_device *ndev);
 extern int mac_close(struct net_device *ndev);
 
@@ -2747,7 +2745,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		PRINT_D(CORECONFIG_DBG, "priv->hWILCWFIDrv[%p]\n", priv->hWILCWFIDrv);
 
 		PRINT_D(HOSTAPD_DBG, "Downloading AP firmware\n");
-		linux_wlan_get_firmware(nic);
+		linux_wlan_get_firmware(dev);
 		/*If wilc is running, then close-open to actually get new firmware running (serves P2P)*/
 		if (wl->initialized)	{
 			nic->iftype = AP_MODE;
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 0bfe762..0435cb5 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -218,4 +218,5 @@ int wilc_netdev_init(struct wilc **wilc);
 void wilc1000_wlan_deinit(struct net_device *dev);
 void WILC_WFI_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size);
 u16 Set_machw_change_vir_if(struct net_device *dev, bool bValue);
+int linux_wlan_get_firmware(struct net_device *dev);
 #endif
-- 
1.9.1

