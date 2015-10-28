Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:42590 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548AbbJ1HCY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:02:24 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 48/80] staging: wilc1000: rename ConnReqIEsLen of struct user_conn_req
Date: Wed, 28 Oct 2015 16:00:08 +0900
Message-ID: <1446015640-29398-48-git-send-email-glen.lee@atmel.com> (sfid-20151028_080227_186330_6102EA45)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames ConnReqIEsLen of struct user_conn_req to ies_len
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 26 +++++++++++++-------------
 drivers/staging/wilc1000/host_interface.h |  2 +-
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 2921004..148c82a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1019,7 +1019,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 		hif_drv->usr_conn_req.pu8ssid[pstrHostIFconnectAttr->ssid_len] = '\0';
 	}
 
-	hif_drv->usr_conn_req.ConnReqIEsLen = pstrHostIFconnectAttr->ies_len;
+	hif_drv->usr_conn_req.ies_len = pstrHostIFconnectAttr->ies_len;
 	if (pstrHostIFconnectAttr->ies) {
 		hif_drv->usr_conn_req.ies = kmalloc(pstrHostIFconnectAttr->ies_len, GFP_KERNEL);
 		memcpy(hif_drv->usr_conn_req.ies,
@@ -1054,11 +1054,11 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 		strWIDList[u32WidsCount].id = WID_INFO_ELEMENT_ASSOCIATE;
 		strWIDList[u32WidsCount].type = WID_BIN_DATA;
 		strWIDList[u32WidsCount].val = hif_drv->usr_conn_req.ies;
-		strWIDList[u32WidsCount].size = hif_drv->usr_conn_req.ConnReqIEsLen;
+		strWIDList[u32WidsCount].size = hif_drv->usr_conn_req.ies_len;
 		u32WidsCount++;
 
 		if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7)) {
-			info_element_size = hif_drv->usr_conn_req.ConnReqIEsLen;
+			info_element_size = hif_drv->usr_conn_req.ies_len;
 			info_element = kmalloc(info_element_size, GFP_KERNEL);
 			memcpy(info_element, hif_drv->usr_conn_req.ies,
 			       info_element_size);
@@ -1340,11 +1340,11 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 		}
 
 		if (hif_drv->usr_conn_req.ies) {
-			strConnectInfo.ReqIEsLen = hif_drv->usr_conn_req.ConnReqIEsLen;
-			strConnectInfo.pu8ReqIEs = kmalloc(hif_drv->usr_conn_req.ConnReqIEsLen, GFP_KERNEL);
+			strConnectInfo.ReqIEsLen = hif_drv->usr_conn_req.ies_len;
+			strConnectInfo.pu8ReqIEs = kmalloc(hif_drv->usr_conn_req.ies_len, GFP_KERNEL);
 			memcpy(strConnectInfo.pu8ReqIEs,
 			       hif_drv->usr_conn_req.ies,
-			       hif_drv->usr_conn_req.ConnReqIEsLen);
+			       hif_drv->usr_conn_req.ies_len);
 		}
 
 		hif_drv->usr_conn_req.pfUserConnectResult(CONN_DISCONN_EVENT_CONN_RESP,
@@ -1374,7 +1374,7 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 	hif_drv->usr_conn_req.ssid_len = 0;
 	kfree(hif_drv->usr_conn_req.pu8ssid);
 	kfree(hif_drv->usr_conn_req.pu8bssid);
-	hif_drv->usr_conn_req.ConnReqIEsLen = 0;
+	hif_drv->usr_conn_req.ies_len = 0;
 	kfree(hif_drv->usr_conn_req.ies);
 
 	eth_zero_addr(u8ConnectedSSID);
@@ -1587,11 +1587,11 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 			}
 
 			if (hif_drv->usr_conn_req.ies) {
-				strConnectInfo.ReqIEsLen = hif_drv->usr_conn_req.ConnReqIEsLen;
-				strConnectInfo.pu8ReqIEs = kmalloc(hif_drv->usr_conn_req.ConnReqIEsLen, GFP_KERNEL);
+				strConnectInfo.ReqIEsLen = hif_drv->usr_conn_req.ies_len;
+				strConnectInfo.pu8ReqIEs = kmalloc(hif_drv->usr_conn_req.ies_len, GFP_KERNEL);
 				memcpy(strConnectInfo.pu8ReqIEs,
 				       hif_drv->usr_conn_req.ies,
-				       hif_drv->usr_conn_req.ConnReqIEsLen);
+				       hif_drv->usr_conn_req.ies_len);
 			}
 
 			del_timer(&hif_drv->connect_timer);
@@ -1626,7 +1626,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 			hif_drv->usr_conn_req.ssid_len = 0;
 			kfree(hif_drv->usr_conn_req.pu8ssid);
 			kfree(hif_drv->usr_conn_req.pu8bssid);
-			hif_drv->usr_conn_req.ConnReqIEsLen = 0;
+			hif_drv->usr_conn_req.ies_len = 0;
 			kfree(hif_drv->usr_conn_req.ies);
 		} else if ((u8MacStatus == MAC_DISCONNECTED) &&
 			   (hif_drv->hif_state == HOST_IF_CONNECTED)) {
@@ -1662,7 +1662,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 			hif_drv->usr_conn_req.ssid_len = 0;
 			kfree(hif_drv->usr_conn_req.pu8ssid);
 			kfree(hif_drv->usr_conn_req.pu8bssid);
-			hif_drv->usr_conn_req.ConnReqIEsLen = 0;
+			hif_drv->usr_conn_req.ies_len = 0;
 			kfree(hif_drv->usr_conn_req.ies);
 
 			if (join_req && join_req_drv == hif_drv) {
@@ -2027,7 +2027,7 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 		hif_drv->usr_conn_req.ssid_len = 0;
 		kfree(hif_drv->usr_conn_req.pu8ssid);
 		kfree(hif_drv->usr_conn_req.pu8bssid);
-		hif_drv->usr_conn_req.ConnReqIEsLen = 0;
+		hif_drv->usr_conn_req.ies_len = 0;
 		kfree(hif_drv->usr_conn_req.ies);
 
 		if (join_req && join_req_drv == hif_drv) {
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 059fdf0..96343f2 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -205,7 +205,7 @@ struct user_conn_req {
 	enum AUTHTYPE tenuAuth_type;
 	size_t ssid_len;
 	u8 *ies;
-	size_t ConnReqIEsLen;
+	size_t ies_len;
 	wilc_connect_result pfUserConnectResult;
 	bool IsHTCapable;
 	void *u32UserConnectPvoid;
-- 
1.9.1

