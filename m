Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:52755 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbbJPEl2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 00:41:28 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 32/40] staging: wilc1000: rename variable gu32FlushedJoinReqSize
Date: Fri, 16 Oct 2015 13:38:02 +0900
Message-ID: <1444970290-17609-32-git-send-email-tony.cho@atmel.com> (sfid-20151016_064700_381284_F9C69F96)
In-Reply-To: <1444970290-17609-1-git-send-email-tony.cho@atmel.com>
References: <1444970290-17609-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames variable gu32FlushedJoinReqSize to join_req_size
to avoid CamelCase naming convention.

Add to static because follow warning reported by kbuild system.
 - drivers/staging/wilc1000/host_interface.c:268:5: sparse: symbol
   'join_req_size' was not declared. Should it be static?

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index f06280b..f41a365 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -265,7 +265,7 @@ static u8 *join_req;
 static u8 *info_element;
 static u8 mode_11i;
 static u8 auth_type;
-u32 gu32FlushedJoinReqSize;
+static u32 join_req_size;
 u32 gu32FlushedInfoElemAsocSize;
 struct host_if_drv *gu8FlushedJoinReqDrvHandler;
 #define REAL_JOIN_REQ 0
@@ -1112,8 +1112,8 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	strWIDList[u32WidsCount].val = kmalloc(strWIDList[u32WidsCount].size, GFP_KERNEL);
 
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7)) {
-		gu32FlushedJoinReqSize = strWIDList[u32WidsCount].size;
-		join_req = kmalloc(gu32FlushedJoinReqSize, GFP_KERNEL);
+		join_req_size = strWIDList[u32WidsCount].size;
+		join_req = kmalloc(join_req_size, GFP_KERNEL);
 	}
 	if (strWIDList[u32WidsCount].val == NULL) {
 		s32Error = -EFAULT;
@@ -1210,7 +1210,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	u32WidsCount++;
 
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7)) {
-		memcpy(join_req, pu8CurrByte, gu32FlushedJoinReqSize);
+		memcpy(join_req, pu8CurrByte, join_req_size);
 		gu8FlushedJoinReqDrvHandler = hif_drv;
 	}
 
@@ -1322,7 +1322,7 @@ static s32 Handle_FlushConnect(struct host_if_drv *hif_drv)
 
 	strWIDList[u32WidsCount].id = (u16)WID_JOIN_REQ_EXTENDED;
 	strWIDList[u32WidsCount].type = WID_STR;
-	strWIDList[u32WidsCount].size = gu32FlushedJoinReqSize;
+	strWIDList[u32WidsCount].size = join_req_size;
 	strWIDList[u32WidsCount].val = (s8 *)join_req;
 	pu8CurrByte = strWIDList[u32WidsCount].val;
 
-- 
1.9.1

