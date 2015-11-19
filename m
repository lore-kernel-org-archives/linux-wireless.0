Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:59037 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787AbbKSGyH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 01:54:07 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 10/26] staging: wilc1000: rename bWilc_ie variable
Date: Thu, 19 Nov 2015 15:56:19 +0900
Message-ID: <1447916195-24851-10-git-send-email-glen.lee@atmel.com> (sfid-20151119_075411_444187_A5CB5BB0)
In-Reply-To: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
References: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames bWilc_ie variable to wilc_ie to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 0a7226c..24e1e15 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -175,7 +175,7 @@ static u8 p2p_oui[] = {0x50, 0x6f, 0x9A, 0x09};
 static u8 p2p_local_random = 0x01;
 static u8 p2p_recv_random = 0x00;
 static u8 p2p_vendor_spec[] = {0xdd, 0x05, 0x00, 0x08, 0x40, 0x03};
-static bool bWilc_ie;
+static bool wilc_ie;
 
 static struct ieee80211_supported_band WILC_WFI_band_2ghz = {
 	.channels = ieee80211_2ghz_channels,
@@ -643,7 +643,7 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 			 pstrDisconnectNotifInfo->u16reason, priv->dev);
 		p2p_local_random = 0x01;
 		p2p_recv_random = 0x00;
-		bWilc_ie = false;
+		wilc_ie = false;
 		eth_zero_addr(priv->au8AssociatedBss);
 		wilc_wlan_set_bssid(priv->dev, NullBssid);
 		eth_zero_addr(wilc_connected_SSID);
@@ -1073,7 +1073,7 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_co
 
 	p2p_local_random = 0x01;
 	p2p_recv_random = 0x00;
-	bWilc_ie = false;
+	wilc_ie = false;
 	pstrWFIDrv->p2p_timeout = 0;
 
 	s32Error = wilc_disconnect(priv->hWILCWFIDrv, reason_code);
@@ -1998,11 +1998,11 @@ void WILC_WFI_p2p_rx (struct net_device *dev, u8 *buff, u32 size)
 				case PUBLIC_ACT_VENDORSPEC:
 					if (!memcmp(p2p_oui, &buff[ACTION_SUBTYPE_ID + 1], 4)) {
 						if ((buff[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_REQ || buff[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_RSP))	{
-							if (!bWilc_ie) {
+							if (!wilc_ie) {
 								for (i = P2P_PUB_ACTION_SUBTYPE; i < size; i++)	{
 									if (!memcmp(p2p_vendor_spec, &buff[i], 6)) {
 										p2p_recv_random = buff[i + 6];
-										bWilc_ie = true;
+										wilc_ie = true;
 										PRINT_D(GENERIC_DBG, "WILC Vendor specific IE:%02x\n", p2p_recv_random);
 										break;
 									}
@@ -2025,7 +2025,7 @@ void WILC_WFI_p2p_rx (struct net_device *dev, u8 *buff, u32 size)
 					}
 
 
-					if ((buff[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_REQ || buff[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_RSP) && (bWilc_ie))	{
+					if ((buff[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_REQ || buff[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_RSP) && (wilc_ie))	{
 						PRINT_D(GENERIC_DBG, "Sending P2P to host without extra elemnt\n");
 						/* extra attribute for sig_dbm: signal strength in mBm, or 0 if unknown */
 						cfg80211_rx_mgmt(priv->wdev, s32Freq, 0, buff, size - 7, 0);
@@ -2560,9 +2560,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 	PRINT_D(HOSTAPD_DBG, "Wireless interface name =%s\n", dev->name);
 	p2p_local_random = 0x01;
 	p2p_recv_random = 0x00;
-
-	bWilc_ie = false;
-
+	wilc_ie = false;
 	wilc_optaining_ip = false;
 	del_timer(&wilc_during_ip_timer);
 	PRINT_D(GENERIC_DBG, "Changing virtual interface, enable scan\n");
-- 
1.9.1

