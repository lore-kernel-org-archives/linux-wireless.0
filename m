Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:20931 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965264AbbJ3DJW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 23:09:22 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 17/17] staging: wilc1000: wilc_netdev_init: use wilc instead of g_linux_wlan
Date: Fri, 30 Oct 2015 12:10:42 +0900
Message-ID: <1446174642-28570-17-git-send-email-glen.lee@atmel.com> (sfid-20151030_040929_956768_42DE0E36)
In-Reply-To: <1446174642-28570-1-git-send-email-glen.lee@atmel.com>
References: <1446174642-28570-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use wilc instead of g_linux_wlan. g_liux_wlan is not used anymore, just
delete it.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 22 +++++++++++-----------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  1 -
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 3801a00..5d4e64f 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -112,7 +112,6 @@ static void wilc_set_multicast_list(struct net_device *dev);
  * for now - in frmw_to_linux there should be private data to be passed to it
  * and this data should be pointer to net device
  */
-struct wilc *g_linux_wlan;
 bool bEnablePS = true;
 
 static const struct net_device_ops wilc_netdev_ops = {
@@ -1702,15 +1701,16 @@ int wilc_netdev_init(struct wilc **wilc)
 	int i;
 	perInterface_wlan_t *nic;
 	struct net_device *ndev;
+	struct wilc *wl;
 
 	sema_init(&close_exit_sync, 0);
 
 	/*create the common structure*/
-	g_linux_wlan = kzalloc(sizeof(*g_linux_wlan), GFP_KERNEL);
-	if (!g_linux_wlan)
+	wl = kzalloc(sizeof(struct wilc), GFP_KERNEL);
+	if (!wl)
 		return -ENOMEM;
 
-	*wilc = g_linux_wlan;
+	*wilc = wl;
 
 	register_inetaddr_notifier(&g_dev_notifier);
 
@@ -1737,11 +1737,11 @@ int wilc_netdev_init(struct wilc **wilc)
 		} else
 			strcpy(ndev->name, "p2p%d");
 
-		nic->u8IfIdx = g_linux_wlan->vif_num;
+		nic->u8IfIdx = wl->vif_num;
 		nic->wilc_netdev = ndev;
-		nic->wilc = *wilc;
-		g_linux_wlan->vif[g_linux_wlan->vif_num].ndev = ndev;
-		g_linux_wlan->vif_num++;
+		nic->wilc = wl;
+		wl->vif[wl->vif_num].ndev = ndev;
+		wl->vif_num++;
 		ndev->netdev_ops = &wilc_netdev_ops;
 
 		{
@@ -1781,13 +1781,13 @@ int wilc_netdev_init(struct wilc **wilc)
 	}
 
 	#ifndef WILC_SDIO
-	if (!linux_spi_init(&g_linux_wlan->wilc_spidev)) {
+	if (!linux_spi_init(&wl->wilc_spidev)) {
 		PRINT_ER("Can't initialize SPI\n");
 		return -1; /* ERROR */
 	}
-	g_linux_wlan->wilc_spidev = wilc_spi_dev;
+	wl->wilc_spidev = wilc_spi_dev;
 	#else
-	g_linux_wlan->wilc_sdio_func = local_sdio_func;
+	wl->wilc_sdio_func = local_sdio_func;
 	#endif
 
 	return 0;
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 31d5ac9..54d798c 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -206,7 +206,6 @@ struct WILC_WFI_mon_priv {
 	struct net_device *real_ndev;
 };
 
-extern struct wilc *g_linux_wlan;
 extern struct net_device *WILC_WFI_devs[];
 void frmw_to_linux(struct wilc *wilc, u8 *buff, u32 size, u32 pkt_offset);
 void linux_wlan_mac_indicate(struct wilc *wilc, int flag);
-- 
1.9.1

