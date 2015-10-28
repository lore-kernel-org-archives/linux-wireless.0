Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:42887 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbbJ1HE1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:04:27 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 51/80] staging: wilc1000: rename u32UserConnectPvoid of struct user_conn_req
Date: Wed, 28 Oct 2015 16:06:56 +0900
Message-ID: <1446016045-32154-1-git-send-email-glen.lee@atmel.com> (sfid-20151028_080430_221983_AE8AC727)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u32UserConnectPvoid of struct user_conn_req to arg
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 +++++-----
 drivers/staging/wilc1000/host_interface.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 008d8ba..357f68d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1030,7 +1030,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	hif_drv->usr_conn_req.u8security = pstrHostIFconnectAttr->security;
 	hif_drv->usr_conn_req.tenuAuth_type = pstrHostIFconnectAttr->auth_type;
 	hif_drv->usr_conn_req.conn_result = pstrHostIFconnectAttr->result;
-	hif_drv->usr_conn_req.u32UserConnectPvoid = pstrHostIFconnectAttr->arg;
+	hif_drv->usr_conn_req.arg = pstrHostIFconnectAttr->arg;
 
 	strWIDList[u32WidsCount].id = WID_SUCCESS_FRAME_COUNT;
 	strWIDList[u32WidsCount].type = WID_INT;
@@ -1351,7 +1351,7 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 						  &strConnectInfo,
 						  MAC_DISCONNECTED,
 						  NULL,
-						  hif_drv->usr_conn_req.u32UserConnectPvoid);
+						  hif_drv->usr_conn_req.arg);
 
 		kfree(strConnectInfo.pu8ReqIEs);
 		strConnectInfo.pu8ReqIEs = NULL;
@@ -1599,7 +1599,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 							  &strConnectInfo,
 							  u8MacStatus,
 							  NULL,
-							  hif_drv->usr_conn_req.u32UserConnectPvoid);
+							  hif_drv->usr_conn_req.arg);
 
 			if ((u8MacStatus == MAC_CONNECTED) &&
 			    (strConnectInfo.u16ConnectStatus == SUCCESSFUL_STATUSCODE))	{
@@ -1652,7 +1652,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 								  NULL,
 								  0,
 								  &strDisconnectNotifInfo,
-								  hif_drv->usr_conn_req.u32UserConnectPvoid);
+								  hif_drv->usr_conn_req.arg);
 			} else {
 				PRINT_ER("Connect result callback function is NULL\n");
 			}
@@ -2018,7 +2018,7 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 							  NULL,
 							  0,
 							  &strDisconnectNotifInfo,
-							  hif_drv->usr_conn_req.u32UserConnectPvoid);
+							  hif_drv->usr_conn_req.arg);
 		} else {
 			PRINT_ER("usr_conn_req.conn_result = NULL\n");
 		}
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 79e9e87..6f2cf5c 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -208,7 +208,7 @@ struct user_conn_req {
 	size_t ies_len;
 	wilc_connect_result conn_result;
 	bool ht_capable;
-	void *u32UserConnectPvoid;
+	void *arg;
 };
 
 struct drv_handler {
-- 
1.9.1

