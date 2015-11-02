Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:7380 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbbKBItW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 03:49:22 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 11/38] staging: wilc1000: rename pstrWFIDrv of function dev_state_ev_handler
Date: Mon, 2 Nov 2015 17:50:54 +0900
Message-ID: <1446454281-22484-11-git-send-email-glen.lee@atmel.com> (sfid-20151102_094925_210387_AE7782B4)
In-Reply-To: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
References: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pstrWFIDrv of function dev_state_ev_handler to hif_drv
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 05f33ec..b4e84e3 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -122,7 +122,7 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 {
 	struct in_ifaddr *dev_iface = (struct in_ifaddr *)ptr;
 	struct wilc_priv *priv;
-	struct host_if_drv *pstrWFIDrv;
+	struct host_if_drv *hif_drv;
 	struct net_device *dev;
 	u8 *pIP_Add_buff;
 	perInterface_wlan_t *nic;
@@ -149,9 +149,9 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 		PRINT_D(GENERIC_DBG, "No Wireless Priv\n");
 		return NOTIFY_DONE;
 	}
-	pstrWFIDrv = (struct host_if_drv *)priv->hWILCWFIDrv;
+	hif_drv = (struct host_if_drv *)priv->hWILCWFIDrv;
 	nic = netdev_priv(dev);
-	if (!nic || !pstrWFIDrv) {
+	if (!nic || !hif_drv) {
 		PRINT_D(GENERIC_DBG, "No Wireless Priv\n");
 		return NOTIFY_DONE;
 	}
@@ -166,20 +166,20 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 
 		/*If we are in station mode or client mode*/
 		if (nic->iftype == STATION_MODE || nic->iftype == CLIENT_MODE) {
-			pstrWFIDrv->IFC_UP = 1;
+			hif_drv->IFC_UP = 1;
 			g_obtainingIP = false;
 			del_timer(&hDuringIpTimer);
 			PRINT_D(GENERIC_DBG, "IP obtained , enable scan\n");
 		}
 
 		if (bEnablePS)
-			host_int_set_power_mgmt(pstrWFIDrv, 1, 0);
+			host_int_set_power_mgmt(hif_drv, 1, 0);
 
 		PRINT_D(GENERIC_DBG, "[%s] Up IP\n", dev_iface->ifa_label);
 
 		pIP_Add_buff = (char *) (&(dev_iface->ifa_address));
 		PRINT_D(GENERIC_DBG, "IP add=%d:%d:%d:%d\n", pIP_Add_buff[0], pIP_Add_buff[1], pIP_Add_buff[2], pIP_Add_buff[3]);
-		host_int_setup_ipaddress(pstrWFIDrv, pIP_Add_buff, nic->u8IfIdx);
+		host_int_setup_ipaddress(hif_drv, pIP_Add_buff, nic->u8IfIdx);
 
 		break;
 
@@ -188,21 +188,21 @@ static int dev_state_ev_handler(struct notifier_block *this, unsigned long event
 
 		PRINT_INFO(GENERIC_DBG, "\n ============== IP Address Released ===============\n\n");
 		if (nic->iftype == STATION_MODE || nic->iftype == CLIENT_MODE) {
-			pstrWFIDrv->IFC_UP = 0;
+			hif_drv->IFC_UP = 0;
 			g_obtainingIP = false;
 		}
 
 		if (memcmp(dev_iface->ifa_label, wlan_dev_name, 5) == 0)
-			host_int_set_power_mgmt(pstrWFIDrv, 0, 0);
+			host_int_set_power_mgmt(hif_drv, 0, 0);
 
-		resolve_disconnect_aberration(pstrWFIDrv);
+		resolve_disconnect_aberration(hif_drv);
 
 		PRINT_D(GENERIC_DBG, "[%s] Down IP\n", dev_iface->ifa_label);
 
 		pIP_Add_buff = null_ip;
 		PRINT_D(GENERIC_DBG, "IP add=%d:%d:%d:%d\n", pIP_Add_buff[0], pIP_Add_buff[1], pIP_Add_buff[2], pIP_Add_buff[3]);
 
-		host_int_setup_ipaddress(pstrWFIDrv, pIP_Add_buff, nic->u8IfIdx);
+		host_int_setup_ipaddress(hif_drv, pIP_Add_buff, nic->u8IfIdx);
 
 		break;
 
-- 
1.9.1

