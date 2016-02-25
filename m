Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:34235 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbcBYAQA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 19:16:00 -0500
Received: by mail-pa0-f43.google.com with SMTP id fy10so21437828pac.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 Feb 2016 16:16:00 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/9] staging: wilc1000: rename struct tstrConnectInfo
Date: Thu, 25 Feb 2016 09:15:42 +0900
Message-Id: <1456359350-17118-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20160225_011605_570123_CE1726F5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames struct tstrConnectInfo to connect_info to avoid
camelcase and removes typedef.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.h       |  4 ++--
 drivers/staging/wilc1000/host_interface.c         | 12 ++++++------
 drivers/staging/wilc1000/host_interface.h         |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 748199d..0f39bc8 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -105,14 +105,14 @@ struct connect_resp_info {
 	u16 ies_len;
 };
 
-typedef struct {
+struct connect_info {
 	u8 au8bssid[6];
 	u8 *pu8ReqIEs;
 	size_t ReqIEsLen;
 	u8 *pu8RespIEs;
 	u16 u16RespIEsLen;
 	u16 u16ConnectStatus;
-} tstrConnectInfo;
+};
 
 typedef struct {
 	u16 u16reason;
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 2ace069..b093304 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1147,11 +1147,11 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 
 ERRORHANDLER:
 	if (result) {
-		tstrConnectInfo strConnectInfo;
+		struct connect_info strConnectInfo;
 
 		del_timer(&hif_drv->connect_timer);
 
-		memset(&strConnectInfo, 0, sizeof(tstrConnectInfo));
+		memset(&strConnectInfo, 0, sizeof(struct connect_info));
 
 		if (pstrHostIFconnectAttr->result) {
 			if (pstrHostIFconnectAttr->bssid)
@@ -1242,7 +1242,7 @@ static s32 Handle_FlushConnect(struct wilc_vif *vif)
 static s32 Handle_ConnectTimeout(struct wilc_vif *vif)
 {
 	s32 result = 0;
-	tstrConnectInfo strConnectInfo;
+	struct connect_info strConnectInfo;
 	struct wid wid;
 	u16 u16DummyReasonCode = 0;
 	struct host_if_drv *hif_drv = vif->hif_drv;
@@ -1256,7 +1256,7 @@ static s32 Handle_ConnectTimeout(struct wilc_vif *vif)
 
 	scan_while_connected = false;
 
-	memset(&strConnectInfo, 0, sizeof(tstrConnectInfo));
+	memset(&strConnectInfo, 0, sizeof(struct connect_info));
 
 	if (hif_drv->usr_conn_req.conn_result) {
 		if (hif_drv->usr_conn_req.bssid) {
@@ -1410,7 +1410,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 	u8 u8MacStatus;
 	u8 u8MacStatusReasonCode;
 	u8 u8MacStatusAdditionalInfo;
-	tstrConnectInfo strConnectInfo;
+	struct connect_info strConnectInfo;
 	tstrDisconnectNotifInfo strDisconnectNotifInfo;
 	s32 s32Err = 0;
 	struct host_if_drv *hif_drv = vif->hif_drv;
@@ -1447,7 +1447,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 			u32 u32RcvdAssocRespInfoLen = 0;
 			struct connect_resp_info *pstrConnectRespInfo = NULL;
 
-			memset(&strConnectInfo, 0, sizeof(tstrConnectInfo));
+			memset(&strConnectInfo, 0, sizeof(struct connect_info));
 
 			if (u8MacStatus == MAC_CONNECTED) {
 				memset(rcv_assoc_resp, 0, MAX_ASSOC_RESP_FRAME_SIZE);
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index f70ad7a..f4a3e4f 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -172,7 +172,7 @@ typedef void (*wilc_scan_result)(enum scan_event, struct network_info *,
 				 void *, void *);
 
 typedef void (*wilc_connect_result)(enum conn_event,
-				     tstrConnectInfo *,
+				     struct connect_info *,
 				     u8,
 				     tstrDisconnectNotifInfo *,
 				     void *);
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 21f0f18..52553a5 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -479,7 +479,7 @@ static void CfgScanResult(enum scan_event scan_event,
 int wilc_connecting;
 
 static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
-			     tstrConnectInfo *pstrConnectInfo,
+			     struct connect_info *pstrConnectInfo,
 			     u8 u8MacStatus,
 			     tstrDisconnectNotifInfo *pstrDisconnectNotifInfo,
 			     void *pUserVoid)
-- 
2.7.1

