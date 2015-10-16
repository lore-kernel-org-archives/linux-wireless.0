Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:52488 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbbJPEkO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 00:40:14 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 19/40] staging: wilc1000: rename variable gbScanWhileConnected
Date: Fri, 16 Oct 2015 13:37:49 +0900
Message-ID: <1444970290-17609-19-git-send-email-tony.cho@atmel.com> (sfid-20151016_064701_158587_D4945542)
In-Reply-To: <1444970290-17609-1-git-send-email-tony.cho@atmel.com>
References: <1444970290-17609-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames variable gbScanWhileConnected to scan_while_connected
to avoid CamelCase naming convention.

Add to static because follow warning reported by kbuild system.
 - drivers/staging/wilc1000/host_interface.c:254:6: sparse: symbol
   'scan_while_connected' was not declared. Should it be static?

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 5112aee..e309197 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -251,7 +251,7 @@ u8 gau8MulticastMacAddrList[WILC_MULTICAST_TABLE_SIZE][ETH_ALEN];
 
 static u8 rcv_assoc_resp[MAX_ASSOC_RESP_FRAME_SIZE];
 
-bool gbScanWhileConnected;
+static bool scan_while_connected;
 
 static s8 gs8Rssi;
 static s8 gs8lnkspd;
@@ -918,9 +918,9 @@ static s32 Handle_Scan(struct host_if_drv *hif_drv,
 	u32WidsCount++;
 
 	if (hif_drv->enuHostIFstate == HOST_IF_CONNECTED)
-		gbScanWhileConnected = true;
+		scan_while_connected = true;
 	else if (hif_drv->enuHostIFstate == HOST_IF_IDLE)
-		gbScanWhileConnected = false;
+		scan_while_connected = false;
 
 	s32Error = send_config_pkt(SET_CFG, strWIDList, u32WidsCount,
 				   get_id_from_handler(hif_drv));
@@ -1357,8 +1357,7 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 
 	hif_drv->enuHostIFstate = HOST_IF_IDLE;
 
-	gbScanWhileConnected = false;
-
+	scan_while_connected = false;
 
 	memset(&strConnectInfo, 0, sizeof(tstrConnectInfo));
 
@@ -1658,7 +1657,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 			} else {
 				PRINT_D(HOSTINF_DBG, "MAC status : %d and Connect Status : %d\n", u8MacStatus, strConnectInfo.u16ConnectStatus);
 				hif_drv->enuHostIFstate = HOST_IF_IDLE;
-				gbScanWhileConnected = false;
+				scan_while_connected = false;
 			}
 
 			if (strConnectInfo.pu8RespIEs != NULL) {
@@ -1723,7 +1722,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 			}
 
 			hif_drv->enuHostIFstate = HOST_IF_IDLE;
-			gbScanWhileConnected = false;
+			scan_while_connected = false;
 
 		} else if ((u8MacStatus == MAC_DISCONNECTED) &&
 			   (hif_drv->strWILC_UsrScanReq.pfUserScanResult != NULL)) {
@@ -2093,7 +2092,7 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 			PRINT_ER("strWILC_UsrConnReq.pfUserConnectResult = NULL\n");
 		}
 
-		gbScanWhileConnected = false;
+		scan_while_connected = false;
 
 		hif_drv->enuHostIFstate = HOST_IF_IDLE;
 
@@ -4225,7 +4224,7 @@ s32 host_int_init(struct host_if_drv **hif_drv_handler)
 
 	PRINT_D(HOSTINF_DBG, "Initializing host interface for client %d\n", clients_count + 1);
 
-	gbScanWhileConnected = false;
+	scan_while_connected = false;
 
 	sema_init(&hif_sema_wait_response, 0);
 
@@ -4361,7 +4360,7 @@ s32 host_int_deinit(struct host_if_drv *hif_drv)
 
 	hif_drv->enuHostIFstate = HOST_IF_IDLE;
 
-	gbScanWhileConnected = false;
+	scan_while_connected = false;
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
-- 
1.9.1

