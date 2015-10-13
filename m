Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3125 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150AbbJMKxw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:53:52 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 30/54] staging: wilc1000: rename pfConnectResult of struct connect_attr
Date: Tue, 13 Oct 2015 19:49:55 +0900
Message-ID: <1444733419-17679-30-git-send-email-tony.cho@atmel.com> (sfid-20151013_125404_505885_449A9F49)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pfConnectResult of struct connect_attr to result to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 6e5db9d..fc82d46 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -114,7 +114,7 @@ struct connect_attr {
 	u8 *ies;
 	size_t ies_len;
 	u8 security;
-	wilc_connect_result pfConnectResult;
+	wilc_connect_result result;
 	void *pvUserArg;
 	enum AUTHTYPE tenuAuth_type;
 	u8 u8channel;
@@ -1053,7 +1053,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 
 	hif_drv->strWILC_UsrConnReq.u8security = pstrHostIFconnectAttr->security;
 	hif_drv->strWILC_UsrConnReq.tenuAuth_type = pstrHostIFconnectAttr->tenuAuth_type;
-	hif_drv->strWILC_UsrConnReq.pfUserConnectResult = pstrHostIFconnectAttr->pfConnectResult;
+	hif_drv->strWILC_UsrConnReq.pfUserConnectResult = pstrHostIFconnectAttr->result;
 	hif_drv->strWILC_UsrConnReq.u32UserConnectPvoid = pstrHostIFconnectAttr->pvUserArg;
 
 	strWIDList[u32WidsCount].id = WID_SUCCESS_FRAME_COUNT;
@@ -1258,7 +1258,7 @@ ERRORHANDLER:
 
 		memset(&strConnectInfo, 0, sizeof(tstrConnectInfo));
 
-		if (pstrHostIFconnectAttr->pfConnectResult != NULL) {
+		if (pstrHostIFconnectAttr->result != NULL) {
 			if (pstrHostIFconnectAttr->bssid != NULL)
 				memcpy(strConnectInfo.au8bssid, pstrHostIFconnectAttr->bssid, 6);
 
@@ -1270,7 +1270,7 @@ ERRORHANDLER:
 					    pstrHostIFconnectAttr->ies_len);
 			}
 
-			pstrHostIFconnectAttr->pfConnectResult(CONN_DISCONN_EVENT_CONN_RESP,
+			pstrHostIFconnectAttr->result(CONN_DISCONN_EVENT_CONN_RESP,
 							       &strConnectInfo,
 							       MAC_DISCONNECTED,
 							       NULL,
@@ -3614,7 +3614,7 @@ s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 	msg.body.con_info.security = u8security;
 	msg.body.con_info.tenuAuth_type = tenuAuth_type;
 	msg.body.con_info.u8channel = u8channel;
-	msg.body.con_info.pfConnectResult = pfConnectResult;
+	msg.body.con_info.result = pfConnectResult;
 	msg.body.con_info.pvUserArg = pvUserArg;
 	msg.body.con_info.pJoinParams = pJoinParams;
 	msg.drv = hif_drv ;
-- 
1.9.1

