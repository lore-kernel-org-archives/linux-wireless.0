Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:5236 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965235AbbJ2DAm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 23:00:42 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 31/64] staging: wilc1000: rename pu8ConnReqIEs of struct user_conn_req
Date: Thu, 29 Oct 2015 11:58:54 +0900
Message-ID: <1446087567-16728-31-git-send-email-glen.lee@atmel.com> (sfid-20151029_041656_045726_77793B15)
In-Reply-To: <1446087567-16728-1-git-send-email-glen.lee@atmel.com>
References: <1446087567-16728-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames pu8ConnReqIEs of struct user_conn_req to ies
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 24 ++++++++++++------------
 drivers/staging/wilc1000/host_interface.h |  2 +-
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 9f70a85..667bd2d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1021,8 +1021,8 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 
 	hif_drv->usr_conn_req.ConnReqIEsLen = pstrHostIFconnectAttr->ies_len;
 	if (pstrHostIFconnectAttr->ies) {
-		hif_drv->usr_conn_req.pu8ConnReqIEs = kmalloc(pstrHostIFconnectAttr->ies_len, GFP_KERNEL);
-		memcpy(hif_drv->usr_conn_req.pu8ConnReqIEs,
+		hif_drv->usr_conn_req.ies = kmalloc(pstrHostIFconnectAttr->ies_len, GFP_KERNEL);
+		memcpy(hif_drv->usr_conn_req.ies,
 		       pstrHostIFconnectAttr->ies,
 		       pstrHostIFconnectAttr->ies_len);
 	}
@@ -1053,14 +1053,14 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	{
 		strWIDList[u32WidsCount].id = WID_INFO_ELEMENT_ASSOCIATE;
 		strWIDList[u32WidsCount].type = WID_BIN_DATA;
-		strWIDList[u32WidsCount].val = hif_drv->usr_conn_req.pu8ConnReqIEs;
+		strWIDList[u32WidsCount].val = hif_drv->usr_conn_req.ies;
 		strWIDList[u32WidsCount].size = hif_drv->usr_conn_req.ConnReqIEsLen;
 		u32WidsCount++;
 
 		if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7)) {
 			info_element_size = hif_drv->usr_conn_req.ConnReqIEsLen;
 			info_element = kmalloc(info_element_size, GFP_KERNEL);
-			memcpy(info_element, hif_drv->usr_conn_req.pu8ConnReqIEs,
+			memcpy(info_element, hif_drv->usr_conn_req.ies,
 			       info_element_size);
 		}
 	}
@@ -1339,11 +1339,11 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 			       hif_drv->usr_conn_req.pu8bssid, 6);
 		}
 
-		if (hif_drv->usr_conn_req.pu8ConnReqIEs) {
+		if (hif_drv->usr_conn_req.ies) {
 			strConnectInfo.ReqIEsLen = hif_drv->usr_conn_req.ConnReqIEsLen;
 			strConnectInfo.pu8ReqIEs = kmalloc(hif_drv->usr_conn_req.ConnReqIEsLen, GFP_KERNEL);
 			memcpy(strConnectInfo.pu8ReqIEs,
-			       hif_drv->usr_conn_req.pu8ConnReqIEs,
+			       hif_drv->usr_conn_req.ies,
 			       hif_drv->usr_conn_req.ConnReqIEsLen);
 		}
 
@@ -1375,7 +1375,7 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 	kfree(hif_drv->usr_conn_req.pu8ssid);
 	kfree(hif_drv->usr_conn_req.pu8bssid);
 	hif_drv->usr_conn_req.ConnReqIEsLen = 0;
-	kfree(hif_drv->usr_conn_req.pu8ConnReqIEs);
+	kfree(hif_drv->usr_conn_req.ies);
 
 	eth_zero_addr(u8ConnectedSSID);
 
@@ -1586,11 +1586,11 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 				}
 			}
 
-			if (hif_drv->usr_conn_req.pu8ConnReqIEs) {
+			if (hif_drv->usr_conn_req.ies) {
 				strConnectInfo.ReqIEsLen = hif_drv->usr_conn_req.ConnReqIEsLen;
 				strConnectInfo.pu8ReqIEs = kmalloc(hif_drv->usr_conn_req.ConnReqIEsLen, GFP_KERNEL);
 				memcpy(strConnectInfo.pu8ReqIEs,
-				       hif_drv->usr_conn_req.pu8ConnReqIEs,
+				       hif_drv->usr_conn_req.ies,
 				       hif_drv->usr_conn_req.ConnReqIEsLen);
 			}
 
@@ -1627,7 +1627,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 			kfree(hif_drv->usr_conn_req.pu8ssid);
 			kfree(hif_drv->usr_conn_req.pu8bssid);
 			hif_drv->usr_conn_req.ConnReqIEsLen = 0;
-			kfree(hif_drv->usr_conn_req.pu8ConnReqIEs);
+			kfree(hif_drv->usr_conn_req.ies);
 		} else if ((u8MacStatus == MAC_DISCONNECTED) &&
 			   (hif_drv->hif_state == HOST_IF_CONNECTED)) {
 			PRINT_D(HOSTINF_DBG, "Received MAC_DISCONNECTED from the FW\n");
@@ -1663,7 +1663,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 			kfree(hif_drv->usr_conn_req.pu8ssid);
 			kfree(hif_drv->usr_conn_req.pu8bssid);
 			hif_drv->usr_conn_req.ConnReqIEsLen = 0;
-			kfree(hif_drv->usr_conn_req.pu8ConnReqIEs);
+			kfree(hif_drv->usr_conn_req.ies);
 
 			if (join_req && join_req_drv == hif_drv) {
 				kfree(join_req);
@@ -2027,7 +2027,7 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 		kfree(hif_drv->usr_conn_req.pu8ssid);
 		kfree(hif_drv->usr_conn_req.pu8bssid);
 		hif_drv->usr_conn_req.ConnReqIEsLen = 0;
-		kfree(hif_drv->usr_conn_req.pu8ConnReqIEs);
+		kfree(hif_drv->usr_conn_req.ies);
 
 		if (join_req && join_req_drv == hif_drv) {
 			kfree(join_req);
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 69ce8f1..de4e7d9 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -204,7 +204,7 @@ struct user_conn_req {
 	u8 u8security;
 	enum AUTHTYPE tenuAuth_type;
 	size_t ssid_len;
-	u8 *pu8ConnReqIEs;
+	u8 *ies;
 	size_t ConnReqIEsLen;
 	wilc_connect_result pfUserConnectResult;
 	bool IsHTCapable;
-- 
1.9.1

