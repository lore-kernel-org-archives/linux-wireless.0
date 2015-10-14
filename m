Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:43612 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbbJNLr4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 07:47:56 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 08/16] staging: wilc1000: rename aSrcAddress in the struct wilc_vif
Date: Wed, 14 Oct 2015 20:46:36 +0900
Message-ID: <1444823204-16736-8-git-send-email-tony.cho@atmel.com> (sfid-20151014_134802_016491_9A33977E)
In-Reply-To: <1444823204-16736-1-git-send-email-tony.cho@atmel.com>
References: <1444823204-16736-1-git-send-email-tony.cho@atmel.com>
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
index 43c3763..ed21ba8 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1312,13 +1312,13 @@ int mac_open(struct net_device *ndev)
 	/* loop through the NUM of supported devices and set the MAC address */
 	for (i = 0; i < wl->vif_num; i++)
 		if (ndev == wl->vif[i].wilc_netdev) {
-			memcpy(wl->vif[i].aSrcAddress, mac_add, ETH_ALEN);
+			memcpy(wl->vif[i].src_addr, mac_add, ETH_ALEN);
 			wl->vif[i].drvHandler = priv->hWILCWFIDrv;
 			break;
 		}
 
 	/* TODO: get MAC address whenever the source is EPROM - hardcoded and copy it to ndev*/
-	memcpy(ndev->dev_addr, wl->vif[i].aSrcAddress, ETH_ALEN);
+	memcpy(ndev->dev_addr, wl->vif[i].src_addr, ETH_ALEN);
 
 	if (!is_valid_ether_addr(ndev->dev_addr)) {
 		PRINT_ER("Error: Wrong MAC address\n");
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index b1267e9..19bca5d 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2588,7 +2588,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			/*Setting interface 1 drv handler and mac address in newly downloaded FW*/
 			host_int_set_wfi_drv_handler(wl->vif[0].drvHandler);
 			host_int_set_MacAddress(wl->vif[0].drvHandler,
-						wl->vif[0].aSrcAddress);
+						wl->vif[0].src_addr);
 			host_int_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
 
 			/*Add saved WEP keys, if any*/
@@ -2668,7 +2668,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 			host_int_set_wfi_drv_handler(wl->vif[0].drvHandler);
 			host_int_set_MacAddress(wl->vif[0].drvHandler,
-						wl->vif[0].aSrcAddress);
+						wl->vif[0].src_addr);
 			host_int_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
 
 			/*Add saved WEP keys, if any*/
@@ -2784,7 +2784,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 		/*Setting interface 1 drv handler and mac address in newly downloaded FW*/
 		host_int_set_wfi_drv_handler(wl->vif[0].drvHandler);
 		host_int_set_MacAddress(wl->vif[0].drvHandler,
-					wl->vif[0].aSrcAddress);
+					wl->vif[0].src_addr);
 		host_int_set_operation_mode(priv->hWILCWFIDrv, AP_MODE);
 
 		/*Add saved WEP keys, if any*/
@@ -2888,7 +2888,7 @@ static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 	if (s32Error != 0)
 		PRINT_ER("Error in setting channel\n");
 
-	linux_wlan_set_bssid(dev, wl->vif[0].aSrcAddress);
+	linux_wlan_set_bssid(dev, wl->vif[0].src_addr);
 
 	s32Error = host_int_add_beacon(priv->hWILCWFIDrv,
 					settings->beacon_interval,
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index c903664..32efa2b 100644
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

