Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3142 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150AbbJMKx7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:53:59 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 31/54] staging: wilc1000: rename pvUserArg of struct connect_attr
Date: Tue, 13 Oct 2015 19:49:56 +0900
Message-ID: <1444733419-17679-31-git-send-email-tony.cho@atmel.com> (sfid-20151013_125405_140176_650968C3)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pvUserArg of struct connect_attr to arg to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index fc82d46..0790dcb 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -115,7 +115,7 @@ struct connect_attr {
 	size_t ies_len;
 	u8 security;
 	wilc_connect_result result;
-	void *pvUserArg;
+	void *arg;
 	enum AUTHTYPE tenuAuth_type;
 	u8 u8channel;
 	void *pJoinParams;
@@ -1054,7 +1054,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	hif_drv->strWILC_UsrConnReq.u8security = pstrHostIFconnectAttr->security;
 	hif_drv->strWILC_UsrConnReq.tenuAuth_type = pstrHostIFconnectAttr->tenuAuth_type;
 	hif_drv->strWILC_UsrConnReq.pfUserConnectResult = pstrHostIFconnectAttr->result;
-	hif_drv->strWILC_UsrConnReq.u32UserConnectPvoid = pstrHostIFconnectAttr->pvUserArg;
+	hif_drv->strWILC_UsrConnReq.u32UserConnectPvoid = pstrHostIFconnectAttr->arg;
 
 	strWIDList[u32WidsCount].id = WID_SUCCESS_FRAME_COUNT;
 	strWIDList[u32WidsCount].type = WID_INT;
@@ -1274,7 +1274,7 @@ ERRORHANDLER:
 							       &strConnectInfo,
 							       MAC_DISCONNECTED,
 							       NULL,
-							       pstrHostIFconnectAttr->pvUserArg);
+							       pstrHostIFconnectAttr->arg);
 			hif_drv->enuHostIFstate = HOST_IF_IDLE;
 			if (strConnectInfo.pu8ReqIEs != NULL) {
 				kfree(strConnectInfo.pu8ReqIEs);
@@ -3615,7 +3615,7 @@ s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 	msg.body.con_info.tenuAuth_type = tenuAuth_type;
 	msg.body.con_info.u8channel = u8channel;
 	msg.body.con_info.result = pfConnectResult;
-	msg.body.con_info.pvUserArg = pvUserArg;
+	msg.body.con_info.arg = pvUserArg;
 	msg.body.con_info.pJoinParams = pJoinParams;
 	msg.drv = hif_drv ;
 
-- 
1.9.1

