Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:58985 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757770AbbKSGx4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 01:53:56 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 08/26] staging: wilc1000: rename u8P2Precvrandom variable
Date: Thu, 19 Nov 2015 15:56:17 +0900
Message-ID: <1447916195-24851-8-git-send-email-glen.lee@atmel.com> (sfid-20151119_075358_932280_56EFCB85)
In-Reply-To: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
References: <1447916195-24851-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u8P2Precvrandom variable to p2p_recv_random
to avoid camelcase.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 24 +++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index dd8d404..904b214 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -173,7 +173,7 @@ static u8 wlan_channel = INVALID_CHANNEL;
 static u8 curr_channel;
 static u8 p2p_oui[] = {0x50, 0x6f, 0x9A, 0x09};
 static u8 p2p_local_random = 0x01;
-static u8 u8P2Precvrandom = 0x00;
+static u8 p2p_recv_random = 0x00;
 static u8 u8P2P_vendorspec[] = {0xdd, 0x05, 0x00, 0x08, 0x40, 0x03};
 static bool bWilc_ie;
 
@@ -642,7 +642,7 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 		PRINT_ER("Received MAC_DISCONNECTED from firmware with reason %d on dev [%p]\n",
 			 pstrDisconnectNotifInfo->u16reason, priv->dev);
 		p2p_local_random = 0x01;
-		u8P2Precvrandom = 0x00;
+		p2p_recv_random = 0x00;
 		bWilc_ie = false;
 		eth_zero_addr(priv->au8AssociatedBss);
 		wilc_wlan_set_bssid(priv->dev, NullBssid);
@@ -1072,7 +1072,7 @@ static int disconnect(struct wiphy *wiphy, struct net_device *dev, u16 reason_co
 	PRINT_D(CFG80211_DBG, "Disconnecting with reason code(%d)\n", reason_code);
 
 	p2p_local_random = 0x01;
-	u8P2Precvrandom = 0x00;
+	p2p_recv_random = 0x00;
 	bWilc_ie = false;
 	pstrWFIDrv->p2p_timeout = 0;
 
@@ -2001,15 +2001,15 @@ void WILC_WFI_p2p_rx (struct net_device *dev, u8 *buff, u32 size)
 							if (!bWilc_ie) {
 								for (i = P2P_PUB_ACTION_SUBTYPE; i < size; i++)	{
 									if (!memcmp(u8P2P_vendorspec, &buff[i], 6)) {
-										u8P2Precvrandom = buff[i + 6];
+										p2p_recv_random = buff[i + 6];
 										bWilc_ie = true;
-										PRINT_D(GENERIC_DBG, "WILC Vendor specific IE:%02x\n", u8P2Precvrandom);
+										PRINT_D(GENERIC_DBG, "WILC Vendor specific IE:%02x\n", p2p_recv_random);
 										break;
 									}
 								}
 							}
 						}
-						if (p2p_local_random > u8P2Precvrandom)	{
+						if (p2p_local_random > p2p_recv_random)	{
 							if ((buff[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_REQ || buff[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_RSP
 							      || buff[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_REQ || buff[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_RSP)) {
 								for (i = P2P_PUB_ACTION_SUBTYPE + 2; i < size; i++) {
@@ -2020,7 +2020,7 @@ void WILC_WFI_p2p_rx (struct net_device *dev, u8 *buff, u32 size)
 								}
 							}
 						} else {
-							PRINT_D(GENERIC_DBG, "PEER WILL BE GO LocaRand=%02x RecvRand %02x\n", p2p_local_random, u8P2Precvrandom);
+							PRINT_D(GENERIC_DBG, "PEER WILL BE GO LocaRand=%02x RecvRand %02x\n", p2p_local_random, p2p_recv_random);
 						}
 					}
 
@@ -2293,7 +2293,7 @@ static int mgmt_tx(struct wiphy *wiphy,
 					if (!memcmp(p2p_oui, &buf[ACTION_SUBTYPE_ID + 1], 4)) {
 						/*For the connection of two WILC's connection generate a rand number to determine who will be a GO*/
 						if ((buf[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_REQ || buf[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_RSP)) {
-							if (p2p_local_random == 1 && u8P2Precvrandom < p2p_local_random) {
+							if (p2p_local_random == 1 && p2p_recv_random < p2p_local_random) {
 								get_random_bytes(&p2p_local_random, 1);
 								p2p_local_random++;
 							}
@@ -2301,8 +2301,8 @@ static int mgmt_tx(struct wiphy *wiphy,
 
 						if ((buf[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_REQ || buf[P2P_PUB_ACTION_SUBTYPE] == GO_NEG_RSP
 						      || buf[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_REQ || buf[P2P_PUB_ACTION_SUBTYPE] == P2P_INV_RSP)) {
-							if (p2p_local_random > u8P2Precvrandom)	{
-								PRINT_D(GENERIC_DBG, "LOCAL WILL BE GO LocaRand=%02x RecvRand %02x\n", p2p_local_random, u8P2Precvrandom);
+							if (p2p_local_random > p2p_recv_random)	{
+								PRINT_D(GENERIC_DBG, "LOCAL WILL BE GO LocaRand=%02x RecvRand %02x\n", p2p_local_random, p2p_recv_random);
 
 								/*Search for the p2p information information element , after the Public action subtype theres a byte for teh dialog token, skip that*/
 								for (i = P2P_PUB_ACTION_SUBTYPE + 2; i < len; i++) {
@@ -2328,7 +2328,7 @@ static int mgmt_tx(struct wiphy *wiphy,
 									mgmt_tx->size = buf_len;
 								}
 							} else {
-								PRINT_D(GENERIC_DBG, "PEER WILL BE GO LocaRand=%02x RecvRand %02x\n", p2p_local_random, u8P2Precvrandom);
+								PRINT_D(GENERIC_DBG, "PEER WILL BE GO LocaRand=%02x RecvRand %02x\n", p2p_local_random, p2p_recv_random);
 							}
 						}
 
@@ -2559,7 +2559,7 @@ static int change_virtual_intf(struct wiphy *wiphy, struct net_device *dev,
 	PRINT_D(HOSTAPD_DBG, "In Change virtual interface function\n");
 	PRINT_D(HOSTAPD_DBG, "Wireless interface name =%s\n", dev->name);
 	p2p_local_random = 0x01;
-	u8P2Precvrandom = 0x00;
+	p2p_recv_random = 0x00;
 
 	bWilc_ie = false;
 
-- 
1.9.1

