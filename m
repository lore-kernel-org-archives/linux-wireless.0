Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:6476 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbbJOE3D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 00:29:03 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 32/40] staging: wilc1000: rename variable gu32FlushedJoinReqSize
Date: Thu, 15 Oct 2015 13:25:13 +0900
Message-ID: <1444883121-31757-32-git-send-email-tony.cho@atmel.com> (sfid-20151015_064656_293174_D74F07BF)
In-Reply-To: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
References: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames variable gu32FlushedJoinReqSize to join_req_size
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index e76dfaa..29ee4bd 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -265,7 +265,7 @@ u8 *join_req;
 u8 *info_element;
 u8 mode_11i;
 u8 auth_type;
-u32 gu32FlushedJoinReqSize;
+u32 join_req_size;
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

