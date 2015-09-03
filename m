Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:33002 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbbICSs5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2015 14:48:57 -0400
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org,
	Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH v2] staging/wilc1000: Use %pM format specifier to print mac address
Date: Fri,  4 Sep 2015 00:48:14 +0600
Message-Id: <1441306094-11162-1-git-send-email-kuleshovmail@gmail.com> (sfid-20150903_204919_263527_E4A3699F)
In-Reply-To: <20150903184150.GA31230@kroah.com>
References: <20150903184150.GA31230@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

printk() supports %pM format specifier for printing 6-byte MAC/FDDI
addresses in hex notation small buffers, let's use it intead of %x:%x...

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
Changelog:

v1 -> v2:

* In the first version of the patch was instruduced incorrect conversion,
now there is previous formatting in the WILC_WFI_mon_xmit().
 
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 drivers/staging/wilc1000/linux_wlan.c     | 3 +--
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 6b10bbb..48ee908 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -854,7 +854,7 @@ static s32 Handle_SetMacAddress(void *drvHandler, tstrHostIfSetMacAddress *pstrH
 	strWID.enuWIDtype = WID_STR;
 	strWID.ps8WidVal = mac_buf;
 	strWID.s32ValueSize = ETH_ALEN;
-	PRINT_D(GENERIC_DBG, "mac addr = :%x:%x:%x:%x:%x:%x\n", strWID.ps8WidVal[0], strWID.ps8WidVal[1], strWID.ps8WidVal[2], strWID.ps8WidVal[3], strWID.ps8WidVal[4], strWID.ps8WidVal[5]);
+	PRINT_D(GENERIC_DBG, "mac addr = :%pM\n", strWID.ps8WidVal);
 	/*Sending Cfg*/
 	s32Error = SendConfigPkt(SET_CFG, &strWID, 1, true, (u32)pstrWFIDrv);
 	if (s32Error) {
@@ -1965,8 +1965,8 @@ static s32 Handle_Connect(void *drvHandler, tstrHostIFconnectAttr *pstrHostIFcon
 	if (pstrHostIFconnectAttr->pu8bssid != NULL) {
 		WILC_memcpy(u8ConnectedSSID, pstrHostIFconnectAttr->pu8bssid, ETH_ALEN);
 
-		PRINT_D(GENERIC_DBG, "save Bssid = %x:%x:%x:%x:%x:%x\n", (pstrHostIFconnectAttr->pu8bssid[0]), (pstrHostIFconnectAttr->pu8bssid[1]), (pstrHostIFconnectAttr->pu8bssid[2]), (pstrHostIFconnectAttr->pu8bssid[3]), (pstrHostIFconnectAttr->pu8bssid[4]), (pstrHostIFconnectAttr->pu8bssid[5]));
-		PRINT_D(GENERIC_DBG, "save bssid = %x:%x:%x:%x:%x:%x\n", (u8ConnectedSSID[0]), (u8ConnectedSSID[1]), (u8ConnectedSSID[2]), (u8ConnectedSSID[3]), (u8ConnectedSSID[4]), (u8ConnectedSSID[5]));
+		PRINT_D(GENERIC_DBG, "save Bssid = %pM\n", pstrHostIFconnectAttr->pu8bssid);
+		PRINT_D(GENERIC_DBG, "save bssid = %pM\n", u8ConnectedSSID);
 	}
 
 	s32Error = SendConfigPkt(SET_CFG, strWIDList, u32WidsCount, false, (u32)pstrWFIDrv);
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index b352c50..b65e0ae 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -2071,8 +2071,7 @@ int mac_open(struct net_device *ndev)
 	Set_machw_change_vir_if(false);
 
 	host_int_get_MacAddress(priv->hWILCWFIDrv, mac_add);
-	PRINT_D(INIT_DBG, "Mac address: %x:%x:%x:%x:%x:%x\n", mac_add[0], mac_add[1], mac_add[2],
-		mac_add[3], mac_add[4], mac_add[5]);
+	PRINT_D(INIT_DBG, "Mac address: %pM\n", mac_add);
 
 	/* loop through the NUM of supported devices and set the MAC address */
 	for (i = 0; i < g_linux_wlan->u8NoIfcs; i++) {
-- 
2.5.0

