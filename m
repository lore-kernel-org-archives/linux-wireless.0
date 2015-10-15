Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:6418 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbbJOE2o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 00:28:44 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 29/40] staging: wilc1000: rename variable gu8FlushedInfoElemAsoc
Date: Thu, 15 Oct 2015 13:25:10 +0900
Message-ID: <1444883121-31757-29-git-send-email-tony.cho@atmel.com> (sfid-20151015_064654_280664_79C1259E)
In-Reply-To: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
References: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames variable gu8FlushedInfoElemAsoc to info_element
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 38ce396..0ede4a6d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -262,7 +262,7 @@ static u32 inactive_time;
 static u8 del_beacon;
 
 u8 *join_req;
-u8 *gu8FlushedInfoElemAsoc;
+u8 *info_element;
 u8 gu8Flushed11iMode;
 u8 gu8FlushedAuthType;
 u32 gu32FlushedJoinReqSize;
@@ -1076,8 +1076,8 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 		if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7)) {
 
 			gu32FlushedInfoElemAsocSize = hif_drv->strWILC_UsrConnReq.ConnReqIEsLen;
-			gu8FlushedInfoElemAsoc =  kmalloc(gu32FlushedInfoElemAsocSize, GFP_KERNEL);
-			memcpy(gu8FlushedInfoElemAsoc, hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs,
+			info_element = kmalloc(gu32FlushedInfoElemAsocSize, GFP_KERNEL);
+			memcpy(info_element, hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs,
 			       gu32FlushedInfoElemAsocSize);
 		}
 	}
@@ -1302,7 +1302,7 @@ static s32 Handle_FlushConnect(struct host_if_drv *hif_drv)
 
 	strWIDList[u32WidsCount].id = WID_INFO_ELEMENT_ASSOCIATE;
 	strWIDList[u32WidsCount].type = WID_BIN_DATA;
-	strWIDList[u32WidsCount].val = gu8FlushedInfoElemAsoc;
+	strWIDList[u32WidsCount].val = info_element;
 	strWIDList[u32WidsCount].size = gu32FlushedInfoElemAsocSize;
 	u32WidsCount++;
 
@@ -1411,9 +1411,10 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 		kfree(join_req);
 		join_req = NULL;
 	}
-	if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == hif_drv) {
-		kfree(gu8FlushedInfoElemAsoc);
-		gu8FlushedInfoElemAsoc = NULL;
+
+	if (info_element != NULL && gu8FlushedJoinReqDrvHandler == hif_drv) {
+		kfree(info_element);
+		info_element = NULL;
 	}
 
 	return s32Error;
@@ -1714,9 +1715,10 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 				kfree(join_req);
 				join_req = NULL;
 			}
-			if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == hif_drv) {
-				kfree(gu8FlushedInfoElemAsoc);
-				gu8FlushedInfoElemAsoc = NULL;
+
+			if (info_element != NULL && gu8FlushedJoinReqDrvHandler == hif_drv) {
+				kfree(info_element);
+				info_element = NULL;
 			}
 
 			hif_drv->enuHostIFstate = HOST_IF_IDLE;
@@ -2106,9 +2108,10 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 			kfree(join_req);
 			join_req = NULL;
 		}
-		if (gu8FlushedInfoElemAsoc != NULL && gu8FlushedJoinReqDrvHandler == hif_drv) {
-			kfree(gu8FlushedInfoElemAsoc);
-			gu8FlushedInfoElemAsoc = NULL;
+
+		if (info_element != NULL && gu8FlushedJoinReqDrvHandler == hif_drv) {
+			kfree(info_element);
+			info_element = NULL;
 		}
 
 	}
-- 
1.9.1

