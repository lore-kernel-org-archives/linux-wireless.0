Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3048 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227AbbJMKxd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:53:33 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 27/54] staging: wilc1000: rename pu8IEs of struct connect_attr
Date: Tue, 13 Oct 2015 19:49:52 +0900
Message-ID: <1444733419-17679-27-git-send-email-tony.cho@atmel.com> (sfid-20151013_125335_552614_5D18A479)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pu8IEs of struct connect_attr to ies to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 80ac60a..5d0e412 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -111,7 +111,7 @@ struct connect_attr {
 	u8 *bssid;
 	u8 *ssid;
 	size_t ssid_len;
-	u8 *pu8IEs;
+	u8 *ies;
 	size_t IEsLen;
 	u8 u8security;
 	wilc_connect_result pfConnectResult;
@@ -1045,9 +1045,9 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	}
 
 	hif_drv->strWILC_UsrConnReq.ConnReqIEsLen = pstrHostIFconnectAttr->IEsLen;
-	if (pstrHostIFconnectAttr->pu8IEs != NULL) {
+	if (pstrHostIFconnectAttr->ies != NULL) {
 		hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs = kmalloc(pstrHostIFconnectAttr->IEsLen, GFP_KERNEL);
-		memcpy(hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs, pstrHostIFconnectAttr->pu8IEs,
+		memcpy(hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs, pstrHostIFconnectAttr->ies,
 			    pstrHostIFconnectAttr->IEsLen);
 	}
 
@@ -1262,11 +1262,11 @@ ERRORHANDLER:
 			if (pstrHostIFconnectAttr->bssid != NULL)
 				memcpy(strConnectInfo.au8bssid, pstrHostIFconnectAttr->bssid, 6);
 
-			if (pstrHostIFconnectAttr->pu8IEs != NULL) {
+			if (pstrHostIFconnectAttr->ies != NULL) {
 				strConnectInfo.ReqIEsLen = pstrHostIFconnectAttr->IEsLen;
 				strConnectInfo.pu8ReqIEs = kmalloc(pstrHostIFconnectAttr->IEsLen, GFP_KERNEL);
 				memcpy(strConnectInfo.pu8ReqIEs,
-					    pstrHostIFconnectAttr->pu8IEs,
+					    pstrHostIFconnectAttr->ies,
 					    pstrHostIFconnectAttr->IEsLen);
 			}
 
@@ -1297,9 +1297,9 @@ ERRORHANDLER:
 		pstrHostIFconnectAttr->ssid = NULL;
 	}
 
-	if (pstrHostIFconnectAttr->pu8IEs != NULL) {
-		kfree(pstrHostIFconnectAttr->pu8IEs);
-		pstrHostIFconnectAttr->pu8IEs = NULL;
+	if (pstrHostIFconnectAttr->ies != NULL) {
+		kfree(pstrHostIFconnectAttr->ies);
+		pstrHostIFconnectAttr->ies = NULL;
 	}
 
 	if (pu8CurrByte != NULL)
@@ -3632,9 +3632,8 @@ s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 
 	if (pu8IEs != NULL) {
 		msg.body.con_info.IEsLen = IEsLen;
-		msg.body.con_info.pu8IEs = kmalloc(IEsLen, GFP_KERNEL);
-		memcpy(msg.body.con_info.pu8IEs,
-			    pu8IEs, IEsLen);
+		msg.body.con_info.ies = kmalloc(IEsLen, GFP_KERNEL);
+		memcpy(msg.body.con_info.ies, pu8IEs, IEsLen);
 	}
 	if (hif_drv->enuHostIFstate < HOST_IF_CONNECTING)
 		hif_drv->enuHostIFstate = HOST_IF_CONNECTING;
-- 
1.9.1

