Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:20917 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965264AbbJ3DJQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 23:09:16 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 16/17] staging: wilc1000: linux_wlan_get_num_conn_ifcs: add argument net_device
Date: Fri, 30 Oct 2015 12:10:41 +0900
Message-ID: <1446174642-28570-16-git-send-email-glen.lee@atmel.com> (sfid-20151030_040928_740373_5BD4B151)
In-Reply-To: <1446174642-28570-1-git-send-email-glen.lee@atmel.com>
References: <1446174642-28570-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch add new argument struct net_device and use netdev private data
member wilc instead of g_linux_wlan, pass dev to the function as well.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c     |  4 +---
 drivers/staging/wilc1000/linux_wlan.c         | 10 +++++++---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  1 +
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 1263b5e..2a8330e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -271,8 +271,6 @@ static struct host_if_drv *join_req_drv;
 
 static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo);
 
-extern int linux_wlan_get_num_conn_ifcs(void);
-
 static int add_handler_in_list(struct host_if_drv *handler)
 {
 	int i;
@@ -2991,7 +2989,7 @@ static int hostIFthread(void *pvArg)
 			del_timer(&hif_drv->scan_timer);
 			PRINT_D(HOSTINF_DBG, "scan completed successfully\n");
 
-			if (!linux_wlan_get_num_conn_ifcs())
+			if (!linux_wlan_get_num_conn_ifcs(hif_drv->priv->dev))
 				chip_sleep_manually(hif_drv->priv->dev,
 						    INFINITE_SLEEP_TIME);
 
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 2226ddb..3801a00 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -421,14 +421,18 @@ int linux_wlan_set_bssid(struct net_device *wilc_netdev, u8 *pBSSID)
 }
 
 /*Function to get number of connected interfaces*/
-int linux_wlan_get_num_conn_ifcs(void)
+int linux_wlan_get_num_conn_ifcs(struct net_device *dev)
 {
 	u8 i = 0;
 	u8 null_bssid[6] = {0};
 	u8 ret_val = 0;
+	perInterface_wlan_t *nic = netdev_priv(dev);
+	struct wilc *wilc;
 
-	for (i = 0; i < g_linux_wlan->vif_num; i++)
-		if (memcmp(g_linux_wlan->vif[i].bssid, null_bssid, 6))
+	wilc = nic->wilc;
+
+	for (i = 0; i < wilc->vif_num; i++)
+		if (memcmp(wilc->vif[i].bssid, null_bssid, 6))
 			ret_val++;
 
 	return ret_val;
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 07917ea..31d5ac9 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -219,4 +219,5 @@ void wilc1000_wlan_deinit(struct net_device *dev);
 void WILC_WFI_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size);
 u16 Set_machw_change_vir_if(struct net_device *dev, bool bValue);
 int linux_wlan_get_firmware(struct net_device *dev);
+int linux_wlan_get_num_conn_ifcs(struct net_device *dev);
 #endif
-- 
1.9.1

