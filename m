Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:6492 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbbJOE3K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 00:29:10 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 33/40] staging: wilc1000: rename variable gu32FlushedInfoElemAsocSize
Date: Thu, 15 Oct 2015 13:25:14 +0900
Message-ID: <1444883121-31757-33-git-send-email-tony.cho@atmel.com> (sfid-20151015_064658_618764_01CD57D3)
In-Reply-To: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
References: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames variable gu32FlushedInfoElemAsocSize to info_element_size
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 29ee4bd..961e853 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -266,7 +266,7 @@ u8 *info_element;
 u8 mode_11i;
 u8 auth_type;
 u32 join_req_size;
-u32 gu32FlushedInfoElemAsocSize;
+u32 info_element_size;
 struct host_if_drv *gu8FlushedJoinReqDrvHandler;
 #define REAL_JOIN_REQ 0
 #define FLUSHED_JOIN_REQ 1
@@ -1074,11 +1074,10 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 		u32WidsCount++;
 
 		if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7)) {
-
-			gu32FlushedInfoElemAsocSize = hif_drv->strWILC_UsrConnReq.ConnReqIEsLen;
-			info_element = kmalloc(gu32FlushedInfoElemAsocSize, GFP_KERNEL);
+			info_element_size = hif_drv->strWILC_UsrConnReq.ConnReqIEsLen;
+			info_element = kmalloc(info_element_size, GFP_KERNEL);
 			memcpy(info_element, hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs,
-			       gu32FlushedInfoElemAsocSize);
+			       info_element_size);
 		}
 	}
 	strWIDList[u32WidsCount].id = (u16)WID_11I_MODE;
@@ -1303,7 +1302,7 @@ static s32 Handle_FlushConnect(struct host_if_drv *hif_drv)
 	strWIDList[u32WidsCount].id = WID_INFO_ELEMENT_ASSOCIATE;
 	strWIDList[u32WidsCount].type = WID_BIN_DATA;
 	strWIDList[u32WidsCount].val = info_element;
-	strWIDList[u32WidsCount].size = gu32FlushedInfoElemAsocSize;
+	strWIDList[u32WidsCount].size = info_element_size;
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].id = (u16)WID_11I_MODE;
-- 
1.9.1

