Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:22908 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbbJTF1o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 01:27:44 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 04/12] staging: wilc1000: rename aSrcAddress in the struct wilc_vif
Date: Tue, 20 Oct 2015 14:26:48 +0900
Message-ID: <1445318816-21686-5-git-send-email-tony.cho@atmel.com> (sfid-20151020_072747_414150_39F4E319)
In-Reply-To: <1445318816-21686-1-git-send-email-tony.cho@atmel.com>
References: <1445318816-21686-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames aSrcAddress in the struct wilc_vif to the src_addr.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c             | 4 ++--
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     | 2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 971b99a..9d57962 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1313,14 +1313,14 @@ int mac_open(struct net_device *ndev)
 	/* loop through the NUM of supported devices and set the MAC address */
 	for (i = 0; i < g_linux_wlan->vif_num; i++) {
 		if (ndev == g_linux_wlan->vif[i].wilc_netdev) {
-			memcpy(g_linux_wlan->vif[i].aSrcAddress, mac_add, ETH_ALEN);
+			memcpy(g_linux_wlan->vif[i].src_addr, mac_add, ETH_ALEN);
 			g_linux_wlan->vif[i].drvHandler = priv->hWILCWFIDrv;
 			break;
 		}
 	}
 
 	/* TODO: get MAC address whenever the source is EPROM - hardcoded and copy it to ndev*/
-	memcpy(ndev->dev_addr, g_linux_wlan->vif[i].aSrcAddress, ETH_ALEN);
+	memcpy(ndev->dev_addr, g_linux_wlan->vif[i].src_addr, ETH_ALEN);
 
 	if (!is_valid_ether_addr(ndev->dev_addr)) {
 		PRINT_ER("Error: Wrong MAC address\n");
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index f2c8a45..b39ea18 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2587,7 +2587,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			/*Setting interface 1 drv handler and mac address in newly downloaded FW*/
 			host_int_set_wfi_drv_handler(g_linux_wlan->vif[0].drvHandler);
 			host_int_set_MacAddress(g_linux_wlan->vif[0].drvHandler,
-						g_linux_wlan->vif[0].aSrcAddress);
+						g_linux_wlan->vif[0].src_addr);
 			host_int_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
 
 			/*Add saved WEP keys, if any*/
@@ -2668,7 +2668,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 			host_int_set_wfi_drv_handler(g_linux_wlan->vif[0].drvHandler);
 			host_int_set_MacAddress(g_linux_wlan->vif[0].drvHandler,
-						g_linux_wlan->vif[0].aSrcAddress);
+						g_linux_wlan->vif[0].src_addr);
 			host_int_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
 
 			/*Add saved WEP keys, if any*/
@@ -2783,7 +2783,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		/*Setting interface 1 drv handler and mac address in newly downloaded FW*/
 		host_int_set_wfi_drv_handler(g_linux_wlan->vif[0].drvHandler);
 		host_int_set_MacAddress(g_linux_wlan->vif[0].drvHandler,
-					g_linux_wlan->vif[0].aSrcAddress);
+					g_linux_wlan->vif[0].src_addr);
 		host_int_set_operation_mode(priv->hWILCWFIDrv, AP_MODE);
 
 		/*Add saved WEP keys, if any*/
@@ -2888,7 +2888,7 @@ static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 	if (s32Error != 0)
 		PRINT_ER("Error in setting channel\n");
 
-	linux_wlan_set_bssid(dev, g_linux_wlan->vif[0].aSrcAddress);
+	linux_wlan_set_bssid(dev, g_linux_wlan->vif[0].src_addr);
 
 	s32Error = host_int_add_beacon(priv->hWILCWFIDrv,
 					settings->beacon_interval,
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 71cd3de..3089129 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -149,7 +149,7 @@ typedef struct {
 } struct_frame_reg;
 
 struct wilc_vif {
-	u8 aSrcAddress[ETH_ALEN];
+	u8 src_addr[ETH_ALEN];
 	u8 aBSSID[ETH_ALEN];
 	struct host_if_drv *drvHandler;
 	struct net_device *wilc_netdev;
-- 
1.9.1

