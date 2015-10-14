Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:43569 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932548AbbJNLrm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 07:47:42 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 06/16] staging: wilc1000: rename u8NoIfcs in the struct wilc
Date: Wed, 14 Oct 2015 20:46:34 +0900
Message-ID: <1444823204-16736-6-git-send-email-tony.cho@atmel.com> (sfid-20151014_134750_033102_895A270C)
In-Reply-To: <1444823204-16736-1-git-send-email-tony.cho@atmel.com>
References: <1444823204-16736-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u8NoIfcs of the struct wilc to the vif_num to avoid
CamelCase naming convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c         | 18 +++++++++---------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |  2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index c75dfc4..51c21dd 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -366,7 +366,7 @@ struct net_device *GetIfHandler(u8 *pMacHeader)
 	Bssid  = pMacHeader + 10;
 	Bssid1 = pMacHeader + 4;
 
-	for (i = 0; i < wl->u8NoIfcs; i++)
+	for (i = 0; i < wl->vif_num; i++)
 		if (!memcmp(Bssid1, wl->strInterfaceInfo[i].aBSSID, ETH_ALEN) ||
 		    !memcmp(Bssid, wl->strInterfaceInfo[i].aBSSID, ETH_ALEN))
 			return wl->strInterfaceInfo[i].wilc_netdev;
@@ -376,7 +376,7 @@ struct net_device *GetIfHandler(u8 *pMacHeader)
 		PRINT_D(INIT_DBG, "%02x ", pMacHeader[i]);
 	Bssid  = pMacHeader + 18;
 	Bssid1 = pMacHeader + 12;
-	for (i = 0; i < wl->u8NoIfcs; i++)
+	for (i = 0; i < wl->vif_num; i++)
 		if (!memcmp(Bssid1, wl->strInterfaceInfo[i].aBSSID, ETH_ALEN) ||
 		    !memcmp(Bssid, wl->strInterfaceInfo[i].aBSSID, ETH_ALEN))
 			return wl->strInterfaceInfo[i].wilc_netdev;
@@ -391,7 +391,7 @@ int linux_wlan_set_bssid(struct net_device *wilc_netdev, u8 *pBSSID)
 	int ret = -1;
 
 	PRINT_D(INIT_DBG, "set bssid on[%p]\n", wilc_netdev);
-	for (i = 0; i < wl->u8NoIfcs; i++)
+	for (i = 0; i < wl->vif_num; i++)
 		if (wl->strInterfaceInfo[i].wilc_netdev == wilc_netdev) {
 			memcpy(wl->strInterfaceInfo[i].aBSSID, pBSSID, 6);
 			ret = 0;
@@ -408,7 +408,7 @@ int linux_wlan_get_num_conn_ifcs(void)
 	u8 null_bssid[6] = {0};
 	u8 ret_val = 0;
 
-	for (i = 0; i < wl->u8NoIfcs; i++)
+	for (i = 0; i < wl->vif_num; i++)
 		if (memcmp(wl->strInterfaceInfo[i].aBSSID, null_bssid, 6))
 			ret_val++;
 
@@ -1310,7 +1310,7 @@ int mac_open(struct net_device *ndev)
 	PRINT_D(INIT_DBG, "Mac address: %pM\n", mac_add);
 
 	/* loop through the NUM of supported devices and set the MAC address */
-	for (i = 0; i < wl->u8NoIfcs; i++)
+	for (i = 0; i < wl->vif_num; i++)
 		if (ndev == wl->strInterfaceInfo[i].wilc_netdev) {
 			memcpy(wl->strInterfaceInfo[i].aSrcAddress, mac_add, ETH_ALEN);
 			wl->strInterfaceInfo[i].drvHandler = priv->hWILCWFIDrv;
@@ -1680,7 +1680,7 @@ void WILC_WFI_mgmt_rx(u8 *buff, u32 size)
 
 	/*Pass the frame on the monitor interface, if any.*/
 	/*Otherwise, pass it on p2p0 netdev, if registered on it*/
-	for (i = 0; i < wl->u8NoIfcs; i++) {
+	for (i = 0; i < wl->vif_num; i++) {
 		nic = netdev_priv(wl->strInterfaceInfo[i].wilc_netdev);
 		if (nic->monitor_flag) {
 			WILC_WFI_monitor_rx(buff, size);
@@ -1733,10 +1733,10 @@ int wilc_netdev_init(void)
 		} else
 			strcpy(ndev->name, "p2p%d");
 
-		nic->u8IfIdx = wl->u8NoIfcs;
+		nic->u8IfIdx = wl->vif_num;
 		nic->wilc_netdev = ndev;
-		wl->strInterfaceInfo[wl->u8NoIfcs].wilc_netdev = ndev;
-		wl->u8NoIfcs++;
+		wl->strInterfaceInfo[wl->vif_num].wilc_netdev = ndev;
+		wl->vif_num++;
 		ndev->netdev_ops = &wilc_netdev_ops;
 
 		{
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 15ce2e8..bd82d78 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -162,7 +162,7 @@ struct wilc {
 	unsigned short dev_irq_num;
 	#endif
 	int close;
-	u8 u8NoIfcs;
+	u8 vif_num;
 	struct wilc_vif strInterfaceInfo[NUM_CONCURRENT_IFC];
 	u8 open_ifcs;
 
-- 
1.9.1

