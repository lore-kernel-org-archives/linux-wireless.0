Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:2983 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbbJMKxN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:53:13 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 24/54] staging: wilc1000: rename pu8bssid of struct connect_attr
Date: Tue, 13 Oct 2015 19:49:49 +0900
Message-ID: <1444733419-17679-24-git-send-email-tony.cho@atmel.com> (sfid-20151013_125316_448305_78BDB520)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pu8bssid of struct connect_attr to bssid to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 33 +++++++++++++++----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 91ea327..b450136 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -108,7 +108,7 @@ struct scan_attr {
 };
 
 struct connect_attr {
-	u8 *pu8bssid;
+	u8 *bssid;
 	u8 *pu8ssid;
 	size_t ssidLen;
 	u8 *pu8IEs;
@@ -1015,7 +1015,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 
 	PRINT_D(GENERIC_DBG, "Handling connect request\n");
 
-	if (memcmp(pstrHostIFconnectAttr->pu8bssid, u8ConnectedSSID, ETH_ALEN) == 0) {
+	if (memcmp(pstrHostIFconnectAttr->bssid, u8ConnectedSSID, ETH_ALEN) == 0) {
 
 		s32Error = 0;
 		PRINT_ER("Trying to connect to an already connected AP, Discard connect request\n");
@@ -1031,9 +1031,9 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 		goto ERRORHANDLER;
 	}
 
-	if (pstrHostIFconnectAttr->pu8bssid != NULL) {
+	if (pstrHostIFconnectAttr->bssid != NULL) {
 		hif_drv->strWILC_UsrConnReq.pu8bssid = kmalloc(6, GFP_KERNEL);
-		memcpy(hif_drv->strWILC_UsrConnReq.pu8bssid, pstrHostIFconnectAttr->pu8bssid, 6);
+		memcpy(hif_drv->strWILC_UsrConnReq.pu8bssid, pstrHostIFconnectAttr->bssid, 6);
 	}
 
 	hif_drv->strWILC_UsrConnReq.ssidLen = pstrHostIFconnectAttr->ssidLen;
@@ -1148,8 +1148,8 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	*(pu8CurrByte++)  = ((ptstrJoinBssParam->cap_info) >> 8) & 0xFF;
 	PRINT_D(HOSTINF_DBG, "* Cap Info %0x*\n", (*(pu8CurrByte - 2) | ((*(pu8CurrByte - 1)) << 8)));
 
-	if (pstrHostIFconnectAttr->pu8bssid != NULL)
-		memcpy(pu8CurrByte, pstrHostIFconnectAttr->pu8bssid, 6);
+	if (pstrHostIFconnectAttr->bssid != NULL)
+		memcpy(pu8CurrByte, pstrHostIFconnectAttr->bssid, 6);
 	pu8CurrByte += 6;
 
 	*(pu8CurrByte++)  = (ptstrJoinBssParam->beacon_period) & 0xFF;
@@ -1230,10 +1230,10 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 
 	PRINT_D(GENERIC_DBG, "send HOST_IF_WAITING_CONN_RESP\n");
 
-	if (pstrHostIFconnectAttr->pu8bssid != NULL) {
-		memcpy(u8ConnectedSSID, pstrHostIFconnectAttr->pu8bssid, ETH_ALEN);
+	if (pstrHostIFconnectAttr->bssid != NULL) {
+		memcpy(u8ConnectedSSID, pstrHostIFconnectAttr->bssid, ETH_ALEN);
 
-		PRINT_D(GENERIC_DBG, "save Bssid = %pM\n", pstrHostIFconnectAttr->pu8bssid);
+		PRINT_D(GENERIC_DBG, "save Bssid = %pM\n", pstrHostIFconnectAttr->bssid);
 		PRINT_D(GENERIC_DBG, "save bssid = %pM\n", u8ConnectedSSID);
 	}
 
@@ -1259,8 +1259,8 @@ ERRORHANDLER:
 		memset(&strConnectInfo, 0, sizeof(tstrConnectInfo));
 
 		if (pstrHostIFconnectAttr->pfConnectResult != NULL) {
-			if (pstrHostIFconnectAttr->pu8bssid != NULL)
-				memcpy(strConnectInfo.au8bssid, pstrHostIFconnectAttr->pu8bssid, 6);
+			if (pstrHostIFconnectAttr->bssid != NULL)
+				memcpy(strConnectInfo.au8bssid, pstrHostIFconnectAttr->bssid, 6);
 
 			if (pstrHostIFconnectAttr->pu8IEs != NULL) {
 				strConnectInfo.ReqIEsLen = pstrHostIFconnectAttr->IEsLen;
@@ -1287,9 +1287,9 @@ ERRORHANDLER:
 	}
 
 	PRINT_D(HOSTINF_DBG, "Deallocating connection parameters\n");
-	if (pstrHostIFconnectAttr->pu8bssid != NULL) {
-		kfree(pstrHostIFconnectAttr->pu8bssid);
-		pstrHostIFconnectAttr->pu8bssid = NULL;
+	if (pstrHostIFconnectAttr->bssid != NULL) {
+		kfree(pstrHostIFconnectAttr->bssid);
+		pstrHostIFconnectAttr->bssid = NULL;
 	}
 
 	if (pstrHostIFconnectAttr->pu8ssid != NULL) {
@@ -3620,9 +3620,8 @@ s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 	msg.drv = hif_drv ;
 
 	if (pu8bssid != NULL) {
-		msg.body.con_info.pu8bssid = kmalloc(6, GFP_KERNEL);
-		memcpy(msg.body.con_info.pu8bssid,
-			    pu8bssid, 6);
+		msg.body.con_info.bssid = kmalloc(6, GFP_KERNEL);
+		memcpy(msg.body.con_info.bssid, pu8bssid, 6);
 	}
 
 	if (pu8ssid != NULL) {
-- 
1.9.1

