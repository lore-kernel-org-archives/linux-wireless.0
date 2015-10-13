Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3005 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbbJMKxU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:53:20 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 25/54] staging: wilc1000: rename pu8ssid of struct connect_attr
Date: Tue, 13 Oct 2015 19:49:50 +0900
Message-ID: <1444733419-17679-25-git-send-email-tony.cho@atmel.com> (sfid-20151013_125323_227805_70DBEA14)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pu8ssid of struct connect_attr to ssid to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 32 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b450136..3c044d2 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -109,7 +109,7 @@ struct scan_attr {
 
 struct connect_attr {
 	u8 *bssid;
-	u8 *pu8ssid;
+	u8 *ssid;
 	size_t ssidLen;
 	u8 *pu8IEs;
 	size_t IEsLen;
@@ -1037,9 +1037,9 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	}
 
 	hif_drv->strWILC_UsrConnReq.ssidLen = pstrHostIFconnectAttr->ssidLen;
-	if (pstrHostIFconnectAttr->pu8ssid != NULL) {
+	if (pstrHostIFconnectAttr->ssid != NULL) {
 		hif_drv->strWILC_UsrConnReq.pu8ssid = kmalloc(pstrHostIFconnectAttr->ssidLen + 1, GFP_KERNEL);
-		memcpy(hif_drv->strWILC_UsrConnReq.pu8ssid, pstrHostIFconnectAttr->pu8ssid,
+		memcpy(hif_drv->strWILC_UsrConnReq.pu8ssid, pstrHostIFconnectAttr->ssid,
 			    pstrHostIFconnectAttr->ssidLen);
 		hif_drv->strWILC_UsrConnReq.pu8ssid[pstrHostIFconnectAttr->ssidLen] = '\0';
 	}
@@ -1081,7 +1081,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 		strWIDList[u32WidsCount].size = hif_drv->strWILC_UsrConnReq.ConnReqIEsLen;
 		u32WidsCount++;
 
-		if (memcmp("DIRECT-", pstrHostIFconnectAttr->pu8ssid, 7)) {
+		if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7)) {
 
 			gu32FlushedInfoElemAsocSize = hif_drv->strWILC_UsrConnReq.ConnReqIEsLen;
 			gu8FlushedInfoElemAsoc =  kmalloc(gu32FlushedInfoElemAsocSize, GFP_KERNEL);
@@ -1095,7 +1095,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	strWIDList[u32WidsCount].val = (s8 *)(&(hif_drv->strWILC_UsrConnReq.u8security));
 	u32WidsCount++;
 
-	if (memcmp("DIRECT-", pstrHostIFconnectAttr->pu8ssid, 7))
+	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7))
 		gu8Flushed11iMode = hif_drv->strWILC_UsrConnReq.u8security;
 
 	PRINT_INFO(HOSTINF_DBG, "Encrypt Mode = %x\n", hif_drv->strWILC_UsrConnReq.u8security);
@@ -1107,7 +1107,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	strWIDList[u32WidsCount].val = (s8 *)(&hif_drv->strWILC_UsrConnReq.tenuAuth_type);
 	u32WidsCount++;
 
-	if (memcmp("DIRECT-", pstrHostIFconnectAttr->pu8ssid, 7))
+	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7))
 		gu8FlushedAuthType = (u8)hif_drv->strWILC_UsrConnReq.tenuAuth_type;
 
 	PRINT_INFO(HOSTINF_DBG, "Authentication Type = %x\n", hif_drv->strWILC_UsrConnReq.tenuAuth_type);
@@ -1119,7 +1119,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	strWIDList[u32WidsCount].size = 112;
 	strWIDList[u32WidsCount].val = kmalloc(strWIDList[u32WidsCount].size, GFP_KERNEL);
 
-	if (memcmp("DIRECT-", pstrHostIFconnectAttr->pu8ssid, 7)) {
+	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7)) {
 		gu32FlushedJoinReqSize = strWIDList[u32WidsCount].size;
 		gu8FlushedJoinReq = kmalloc(gu32FlushedJoinReqSize, GFP_KERNEL);
 	}
@@ -1131,8 +1131,8 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	pu8CurrByte = strWIDList[u32WidsCount].val;
 
 
-	if (pstrHostIFconnectAttr->pu8ssid != NULL) {
-		memcpy(pu8CurrByte, pstrHostIFconnectAttr->pu8ssid, pstrHostIFconnectAttr->ssidLen);
+	if (pstrHostIFconnectAttr->ssid != NULL) {
+		memcpy(pu8CurrByte, pstrHostIFconnectAttr->ssid, pstrHostIFconnectAttr->ssidLen);
 		pu8CurrByte[pstrHostIFconnectAttr->ssidLen] = '\0';
 	}
 	pu8CurrByte += MAX_SSID_LEN;
@@ -1223,7 +1223,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	u32WidsCount++;
 	gu32WidConnRstHack = 0;
 
-	if (memcmp("DIRECT-", pstrHostIFconnectAttr->pu8ssid, 7)) {
+	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7)) {
 		memcpy(gu8FlushedJoinReq, pu8CurrByte, gu32FlushedJoinReqSize);
 		gu8FlushedJoinReqDrvHandler = hif_drv;
 	}
@@ -1292,9 +1292,9 @@ ERRORHANDLER:
 		pstrHostIFconnectAttr->bssid = NULL;
 	}
 
-	if (pstrHostIFconnectAttr->pu8ssid != NULL) {
-		kfree(pstrHostIFconnectAttr->pu8ssid);
-		pstrHostIFconnectAttr->pu8ssid = NULL;
+	if (pstrHostIFconnectAttr->ssid != NULL) {
+		kfree(pstrHostIFconnectAttr->ssid);
+		pstrHostIFconnectAttr->ssid = NULL;
 	}
 
 	if (pstrHostIFconnectAttr->pu8IEs != NULL) {
@@ -3626,10 +3626,8 @@ s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 
 	if (pu8ssid != NULL) {
 		msg.body.con_info.ssidLen = ssidLen;
-		msg.body.con_info.pu8ssid = kmalloc(ssidLen, GFP_KERNEL);
-		memcpy(msg.body.con_info.pu8ssid,
-
-			    pu8ssid, ssidLen);
+		msg.body.con_info.ssid = kmalloc(ssidLen, GFP_KERNEL);
+		memcpy(msg.body.con_info.ssid, pu8ssid, ssidLen);
 	}
 
 	if (pu8IEs != NULL) {
-- 
1.9.1

