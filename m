Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:6457 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbbJOE25 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2015 00:28:57 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 31/40] staging: wilc1000: rename variable gu8FlushedAuthType
Date: Thu, 15 Oct 2015 13:25:12 +0900
Message-ID: <1444883121-31757-31-git-send-email-tony.cho@atmel.com> (sfid-20151015_064655_530226_43CD3462)
In-Reply-To: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
References: <1444883121-31757-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames variable gu8FlushedAuthType to auth_type
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 778d9b3..e76dfaa 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -264,7 +264,7 @@ static u8 del_beacon;
 u8 *join_req;
 u8 *info_element;
 u8 mode_11i;
-u8 gu8FlushedAuthType;
+u8 auth_type;
 u32 gu32FlushedJoinReqSize;
 u32 gu32FlushedInfoElemAsocSize;
 struct host_if_drv *gu8FlushedJoinReqDrvHandler;
@@ -1100,7 +1100,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	u32WidsCount++;
 
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7))
-		gu8FlushedAuthType = (u8)hif_drv->strWILC_UsrConnReq.tenuAuth_type;
+		auth_type = (u8)hif_drv->strWILC_UsrConnReq.tenuAuth_type;
 
 	PRINT_INFO(HOSTINF_DBG, "Authentication Type = %x\n", hif_drv->strWILC_UsrConnReq.tenuAuth_type);
 	PRINT_D(HOSTINF_DBG, "Connecting to network of SSID %s on channel %d\n",
@@ -1317,7 +1317,7 @@ static s32 Handle_FlushConnect(struct host_if_drv *hif_drv)
 	strWIDList[u32WidsCount].id = (u16)WID_AUTH_TYPE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
-	strWIDList[u32WidsCount].val = (s8 *)(&gu8FlushedAuthType);
+	strWIDList[u32WidsCount].val = (s8 *)(&auth_type);
 	u32WidsCount++;
 
 	strWIDList[u32WidsCount].id = (u16)WID_JOIN_REQ_EXTENDED;
-- 
1.9.1

