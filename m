Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:30100 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933379AbbFJIHQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 04:07:16 -0400
From: Johnny Kim <johnny.kim@atmel.com>
To: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>
CC: <johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<Rachel.kim@atmel.com>, <dean.lee@atmel.com>, <tony.cho@atmel.com>
Subject: [PATCH 3/4] staging: wilc1000: modify printk format
Date: Wed, 10 Jun 2015 17:06:46 +0900
Message-ID: <1433923607-20927-4-git-send-email-johnny.kim@atmel.com> (sfid-20150610_100722_844759_5DAEE30F)
In-Reply-To: <1433923607-20927-1-git-send-email-johnny.kim@atmel.com>
References: <1433923607-20927-1-git-send-email-johnny.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This remove compile warnings about printk format.

Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         | 8 ++++----
 drivers/staging/wilc1000/linux_wlan.c             | 2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 4b005fa..e4ad07a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -703,7 +703,7 @@ static WILC_Sint32 Handle_SetOperationMode(void *drvHandler, tstrHostIfSetOperat
 	strWID.s32ValueSize = sizeof(WILC_Uint32);
 
 	/*Sending Cfg*/
-	PRINT_INFO(HOSTINF_DBG, "(WILC_Uint32)pstrWFIDrv= %x \n", (WILC_Uint32)pstrWFIDrv);
+	PRINT_INFO(HOSTINF_DBG, "(size_t)pstrWFIDrv= %p \n", pstrWFIDrv);
 
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, WILC_TRUE, (size_t)pstrWFIDrv);
 
@@ -6631,7 +6631,7 @@ WILC_Sint32 host_int_init(WILC_WFIDrvHandle *phWFIDrv)
 	g_obtainingIP = WILC_FALSE;
 	#endif
 
-	PRINT_D(HOSTINF_DBG, "Global handle pointer value=%x\n", (WILC_Uint32)pstrWFIDrv);
+	PRINT_D(HOSTINF_DBG, "Global handle pointer value=%p\n", pstrWFIDrv);
 	/* /////////////////////////////////////// */
 	if (clients_count == 0)	{
 		sema_init(&hSemHostIFthrdEnd, 0);
@@ -6933,7 +6933,7 @@ void NetworkInfoReceived(u8 *pu8Buffer, WILC_Uint32 u32Length)
 
 
 	if (pstrWFIDrv == NULL || pstrWFIDrv == terminated_handle)	{
-		PRINT_ER("NetworkInfo received but driver not init[%x]\n", (WILC_Uint32)pstrWFIDrv);
+		PRINT_ER("NetworkInfo received but driver not init[%p]\n", pstrWFIDrv);
 		return;
 	}
 
@@ -7053,7 +7053,7 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, WILC_Uint32 u32Length)
 	pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
 
 
-	PRINT_D(GENERIC_DBG, "Scan notification received %x\n", (WILC_Uint32)pstrWFIDrv);
+	PRINT_D(GENERIC_DBG, "Scan notification received %p\n", pstrWFIDrv);
 
 	if (pstrWFIDrv == NULL || pstrWFIDrv == terminated_handle) {
 		return;
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 49d7d8c..cb0765f 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1113,7 +1113,7 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 	#endif
 	priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
 	pstrWFIDrv = (tstrWILC_WFIDrv *)priv->hWILCWFIDrv;
-	PRINT_D(INIT_DBG, "Host = %x\n", (WILC_Uint32)pstrWFIDrv);
+	PRINT_D(INIT_DBG, "Host = %p\n", pstrWFIDrv);
 
 	PRINT_D(INIT_DBG, "MAC address is : %02x-%02x-%02x-%02x-%02x-%02x\n", mac_add[0], mac_add[1], mac_add[2], mac_add[3], mac_add[4], mac_add[5]);
 	wilc_get_chipid(0);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index e6cc1e9..f3068c0 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -844,7 +844,7 @@ static int WILC_WFI_CfgConnect(struct wiphy *wiphy, struct net_device *dev,
 
 	host_int_set_wfi_drv_handler((size_t)priv->hWILCWFIDrv);
 
-	PRINT_D(CFG80211_DBG, "Connecting to SSID [%s] on netdev [%p] host if [%x]\n", sme->ssid, dev, (WILC_Uint32)priv->hWILCWFIDrv);
+	PRINT_D(CFG80211_DBG, "Connecting to SSID [%s] on netdev [%p] host if [%p]\n", sme->ssid, dev, priv->hWILCWFIDrv);
 	#ifdef WILC_P2P
 	if (!(WILC_strncmp(sme->ssid, "DIRECT-", 7))) {
 		PRINT_D(CFG80211_DBG, "Connected to Direct network,OBSS disabled\n");
@@ -1147,7 +1147,7 @@ static int WILC_WFI_add_key(struct wiphy *wiphy, struct net_device *netdev, u8 k
 	PRINT_D(CFG80211_DBG, "Adding key with cipher suite = %x\n", params->cipher);
 
 	/*BugID_5137*/
-	PRINT_D(CFG80211_DBG, "%x %x %d\n", (WILC_Uint32)wiphy, (WILC_Uint32)netdev, key_index);
+	PRINT_D(CFG80211_DBG, "%p %p %d\n", wiphy, netdev, key_index);
 
 	PRINT_D(CFG80211_DBG, "key %x %x %x\n", params->key[0],
 		params->key[1],
@@ -3062,7 +3062,7 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev->iftype = type;
 		nic->iftype = AP_MODE;
-		PRINT_D(CORECONFIG_DBG, "(WILC_Uint32)priv->hWILCWFIDrv[%x]\n", (WILC_Uint32)priv->hWILCWFIDrv);
+		PRINT_D(CORECONFIG_DBG, "priv->hWILCWFIDrv[%p]\n", priv->hWILCWFIDrv);
 
 		#ifndef SIMULATION
 		PRINT_D(HOSTAPD_DBG, "Downloading AP firmware\n");
@@ -3108,7 +3108,7 @@ static int WILC_WFI_change_virt_intf(struct wiphy *wiphy, struct net_device *dev
 		dev->ieee80211_ptr->iftype = type;
 		priv->wdev->iftype = type;
 
-		PRINT_D(CORECONFIG_DBG, "(WILC_Uint32)priv->hWILCWFIDrv[%x]\n", (WILC_Uint32)priv->hWILCWFIDrv);
+		PRINT_D(CORECONFIG_DBG, "priv->hWILCWFIDrv[%p]\n", priv->hWILCWFIDrv);
 
 		#ifndef SIMULATION
 		#ifdef WILC_P2P
-- 
1.9.1

