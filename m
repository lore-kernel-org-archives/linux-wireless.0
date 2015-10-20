Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:22880 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbbJTF1b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 01:27:31 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 02/12] staging: wilc1000: rename u8NoIfcs in the struct wilc
Date: Tue, 20 Oct 2015 14:26:46 +0900
Message-ID: <1445318816-21686-3-git-send-email-tony.cho@atmel.com> (sfid-20151020_072733_770890_9CF28800)
In-Reply-To: <1445318816-21686-1-git-send-email-tony.cho@atmel.com>
References: <1445318816-21686-1-git-send-email-tony.cho@atmel.com>
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
index 191851b..2bea103 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -366,7 +366,7 @@ struct net_device *GetIfHandler(u8 *pMacHeader)
 	Bssid  = pMacHeader + 10;
 	Bssid1 = pMacHeader + 4;
 
-	for (i = 0; i < g_linux_wlan->u8NoIfcs; i++) {
+	for (i = 0; i < g_linux_wlan->vif_num; i++) {
 		if (!memcmp(Bssid1, g_linux_wlan->strInterfaceInfo[i].aBSSID, ETH_ALEN) ||
 		    !memcmp(Bssid, g_linux_wlan->strInterfaceInfo[i].aBSSID, ETH_ALEN))	{
 			return g_linux_wlan->strInterfaceInfo[i].wilc_netdev;
@@ -377,7 +377,7 @@ struct net_device *GetIfHandler(u8 *pMacHeader)
 		PRINT_D(INIT_DBG, "%02x ", pMacHeader[i]);
 	Bssid  = pMacHeader + 18;
 	Bssid1 = pMacHeader + 12;
-	for (i = 0; i < g_linux_wlan->u8NoIfcs; i++) {
+	for (i = 0; i < g_linux_wlan->vif_num; i++) {
 		if (!memcmp(Bssid1, g_linux_wlan->strInterfaceInfo[i].aBSSID, ETH_ALEN) ||
 		    !memcmp(Bssid, g_linux_wlan->strInterfaceInfo[i].aBSSID, ETH_ALEN))	{
 			PRINT_D(INIT_DBG, "Ctx [%p]\n", g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
@@ -394,7 +394,7 @@ int linux_wlan_set_bssid(struct net_device *wilc_netdev, u8 *pBSSID)
 	int ret = -1;
 
 	PRINT_D(INIT_DBG, "set bssid on[%p]\n", wilc_netdev);
-	for (i = 0; i < g_linux_wlan->u8NoIfcs; i++) {
+	for (i = 0; i < g_linux_wlan->vif_num; i++) {
 		if (g_linux_wlan->strInterfaceInfo[i].wilc_netdev == wilc_netdev) {
 			PRINT_D(INIT_DBG, "set bssid [%x][%x][%x]\n", pBSSID[0], pBSSID[1], pBSSID[2]);
 			memcpy(g_linux_wlan->strInterfaceInfo[i].aBSSID, pBSSID, 6);
@@ -412,7 +412,7 @@ int linux_wlan_get_num_conn_ifcs(void)
 	u8 null_bssid[6] = {0};
 	u8 ret_val = 0;
 
-	for (i = 0; i < g_linux_wlan->u8NoIfcs; i++) {
+	for (i = 0; i < g_linux_wlan->vif_num; i++) {
 		if (memcmp(g_linux_wlan->strInterfaceInfo[i].aBSSID, null_bssid, 6))
 			ret_val++;
 	}
@@ -1316,7 +1316,7 @@ int mac_open(struct net_device *ndev)
 	PRINT_D(INIT_DBG, "Mac address: %pM\n", mac_add);
 
 	/* loop through the NUM of supported devices and set the MAC address */
-	for (i = 0; i < g_linux_wlan->u8NoIfcs; i++) {
+	for (i = 0; i < g_linux_wlan->vif_num; i++) {
 		if (ndev == g_linux_wlan->strInterfaceInfo[i].wilc_netdev) {
 			memcpy(g_linux_wlan->strInterfaceInfo[i].aSrcAddress, mac_add, ETH_ALEN);
 			g_linux_wlan->strInterfaceInfo[i].drvHandler = priv->hWILCWFIDrv;
@@ -1687,7 +1687,7 @@ void WILC_WFI_mgmt_rx(u8 *buff, u32 size)
 
 	/*Pass the frame on the monitor interface, if any.*/
 	/*Otherwise, pass it on p2p0 netdev, if registered on it*/
-	for (i = 0; i < g_linux_wlan->u8NoIfcs; i++) {
+	for (i = 0; i < g_linux_wlan->vif_num; i++) {
 		nic = netdev_priv(g_linux_wlan->strInterfaceInfo[i].wilc_netdev);
 		if (nic->monitor_flag) {
 			WILC_WFI_monitor_rx(buff, size);
@@ -1740,10 +1740,10 @@ int wilc_netdev_init(void)
 		} else
 			strcpy(ndev->name, "p2p%d");
 
-		nic->u8IfIdx = g_linux_wlan->u8NoIfcs;
+		nic->u8IfIdx = g_linux_wlan->vif_num;
 		nic->wilc_netdev = ndev;
-		g_linux_wlan->strInterfaceInfo[g_linux_wlan->u8NoIfcs].wilc_netdev = ndev;
-		g_linux_wlan->u8NoIfcs++;
+		g_linux_wlan->strInterfaceInfo[g_linux_wlan->vif_num].wilc_netdev = ndev;
+		g_linux_wlan->vif_num++;
 		ndev->netdev_ops = &wilc_netdev_ops;
 
 		{
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 863571a..a3f18b5 100644
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

