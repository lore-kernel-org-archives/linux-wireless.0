Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:22938 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbbJTF15 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 01:27:57 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 06/12] staging: wilc1000: rename drvHandler in the struct wilc_vif
Date: Tue, 20 Oct 2015 14:26:50 +0900
Message-ID: <1445318816-21686-7-git-send-email-tony.cho@atmel.com> (sfid-20151020_072759_517078_3B4B6021)
In-Reply-To: <1445318816-21686-1-git-send-email-tony.cho@atmel.com>
References: <1445318816-21686-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames drvHandler in the struct wilc_vif to the hif_drv.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c             |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 24 +++++++++++------------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  2 +-
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 493e02c..11e26fb 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1314,7 +1314,7 @@ int mac_open(struct net_device *ndev)
 	for (i = 0; i < g_linux_wlan->vif_num; i++) {
 		if (ndev == g_linux_wlan->vif[i].wilc_netdev) {
 			memcpy(g_linux_wlan->vif[i].src_addr, mac_add, ETH_ALEN);
-			g_linux_wlan->vif[i].drvHandler = priv->hWILCWFIDrv;
+			g_linux_wlan->vif[i].hif_drv = priv->hWILCWFIDrv;
 			break;
 		}
 	}
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index c166d3f..2dfc0fd 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2585,16 +2585,16 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			nic->iftype = interface_type;
 
 			/*Setting interface 1 drv handler and mac address in newly downloaded FW*/
-			host_int_set_wfi_drv_handler(g_linux_wlan->vif[0].drvHandler);
-			host_int_set_MacAddress(g_linux_wlan->vif[0].drvHandler,
+			host_int_set_wfi_drv_handler(g_linux_wlan->vif[0].hif_drv);
+			host_int_set_MacAddress(g_linux_wlan->vif[0].hif_drv,
 						g_linux_wlan->vif[0].src_addr);
 			host_int_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
 
 			/*Add saved WEP keys, if any*/
 			if (g_wep_keys_saved) {
-				host_int_set_WEPDefaultKeyID(g_linux_wlan->vif[0].drvHandler,
+				host_int_set_WEPDefaultKeyID(g_linux_wlan->vif[0].hif_drv,
 							     g_key_wep_params.key_idx);
-				host_int_add_wep_key_bss_sta(g_linux_wlan->vif[0].drvHandler,
+				host_int_add_wep_key_bss_sta(g_linux_wlan->vif[0].hif_drv,
 							     g_key_wep_params.key,
 							     g_key_wep_params.key_len,
 							     g_key_wep_params.key_idx);
@@ -2666,16 +2666,16 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 			wilc1000_wlan_init(dev, nic);
 			g_wilc_initialized = 1;
 
-			host_int_set_wfi_drv_handler(g_linux_wlan->vif[0].drvHandler);
-			host_int_set_MacAddress(g_linux_wlan->vif[0].drvHandler,
+			host_int_set_wfi_drv_handler(g_linux_wlan->vif[0].hif_drv);
+			host_int_set_MacAddress(g_linux_wlan->vif[0].hif_drv,
 						g_linux_wlan->vif[0].src_addr);
 			host_int_set_operation_mode(priv->hWILCWFIDrv, STATION_MODE);
 
 			/*Add saved WEP keys, if any*/
 			if (g_wep_keys_saved) {
-				host_int_set_WEPDefaultKeyID(g_linux_wlan->vif[0].drvHandler,
+				host_int_set_WEPDefaultKeyID(g_linux_wlan->vif[0].hif_drv,
 							     g_key_wep_params.key_idx);
-				host_int_add_wep_key_bss_sta(g_linux_wlan->vif[0].drvHandler,
+				host_int_add_wep_key_bss_sta(g_linux_wlan->vif[0].hif_drv,
 							     g_key_wep_params.key,
 							     g_key_wep_params.key_len,
 							     g_key_wep_params.key_idx);
@@ -2781,16 +2781,16 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 
 
 		/*Setting interface 1 drv handler and mac address in newly downloaded FW*/
-		host_int_set_wfi_drv_handler(g_linux_wlan->vif[0].drvHandler);
-		host_int_set_MacAddress(g_linux_wlan->vif[0].drvHandler,
+		host_int_set_wfi_drv_handler(g_linux_wlan->vif[0].hif_drv);
+		host_int_set_MacAddress(g_linux_wlan->vif[0].hif_drv,
 					g_linux_wlan->vif[0].src_addr);
 		host_int_set_operation_mode(priv->hWILCWFIDrv, AP_MODE);
 
 		/*Add saved WEP keys, if any*/
 		if (g_wep_keys_saved) {
-			host_int_set_WEPDefaultKeyID(g_linux_wlan->vif[0].drvHandler,
+			host_int_set_WEPDefaultKeyID(g_linux_wlan->vif[0].hif_drv,
 						     g_key_wep_params.key_idx);
-			host_int_add_wep_key_bss_sta(g_linux_wlan->vif[0].drvHandler,
+			host_int_add_wep_key_bss_sta(g_linux_wlan->vif[0].hif_drv,
 						     g_key_wep_params.key,
 						     g_key_wep_params.key_len,
 						     g_key_wep_params.key_idx);
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 6ac9328..521d3cb 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -151,7 +151,7 @@ typedef struct {
 struct wilc_vif {
 	u8 src_addr[ETH_ALEN];
 	u8 bssid[ETH_ALEN];
-	struct host_if_drv *drvHandler;
+	struct host_if_drv *hif_drv;
 	struct net_device *wilc_netdev;
 };
 
-- 
1.9.1

