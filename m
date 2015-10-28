Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:42540 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472AbbJ1HCM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:02:12 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 46/80] staging: wilc1000: rename ssidLen of struct user_conn_req
Date: Wed, 28 Oct 2015 16:00:06 +0900
Message-ID: <1446015640-29398-46-git-send-email-glen.lee@atmel.com> (sfid-20151028_080216_553601_C45A7AC4)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames ssidLen of struct user_conn_req to ssid_len
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 +++++-----
 drivers/staging/wilc1000/host_interface.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b613258..8ad31d2 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1010,7 +1010,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 		memcpy(hif_drv->usr_conn_req.pu8bssid, pstrHostIFconnectAttr->bssid, 6);
 	}
 
-	hif_drv->usr_conn_req.ssidLen = pstrHostIFconnectAttr->ssid_len;
+	hif_drv->usr_conn_req.ssid_len = pstrHostIFconnectAttr->ssid_len;
 	if (pstrHostIFconnectAttr->ssid) {
 		hif_drv->usr_conn_req.pu8ssid = kmalloc(pstrHostIFconnectAttr->ssid_len + 1, GFP_KERNEL);
 		memcpy(hif_drv->usr_conn_req.pu8ssid,
@@ -1371,7 +1371,7 @@ static s32 Handle_ConnectTimeout(struct host_if_drv *hif_drv)
 	if (result)
 		PRINT_ER("Failed to send dissconect config packet\n");
 
-	hif_drv->usr_conn_req.ssidLen = 0;
+	hif_drv->usr_conn_req.ssid_len = 0;
 	kfree(hif_drv->usr_conn_req.pu8ssid);
 	kfree(hif_drv->usr_conn_req.pu8bssid);
 	hif_drv->usr_conn_req.ConnReqIEsLen = 0;
@@ -1623,7 +1623,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 
 			kfree(strConnectInfo.pu8ReqIEs);
 			strConnectInfo.pu8ReqIEs = NULL;
-			hif_drv->usr_conn_req.ssidLen = 0;
+			hif_drv->usr_conn_req.ssid_len = 0;
 			kfree(hif_drv->usr_conn_req.pu8ssid);
 			kfree(hif_drv->usr_conn_req.pu8bssid);
 			hif_drv->usr_conn_req.ConnReqIEsLen = 0;
@@ -1659,7 +1659,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct host_if_drv *hif_drv,
 
 			eth_zero_addr(hif_drv->assoc_bssid);
 
-			hif_drv->usr_conn_req.ssidLen = 0;
+			hif_drv->usr_conn_req.ssid_len = 0;
 			kfree(hif_drv->usr_conn_req.pu8ssid);
 			kfree(hif_drv->usr_conn_req.pu8bssid);
 			hif_drv->usr_conn_req.ConnReqIEsLen = 0;
@@ -2024,7 +2024,7 @@ static void Handle_Disconnect(struct host_if_drv *hif_drv)
 
 		eth_zero_addr(hif_drv->assoc_bssid);
 
-		hif_drv->usr_conn_req.ssidLen = 0;
+		hif_drv->usr_conn_req.ssid_len = 0;
 		kfree(hif_drv->usr_conn_req.pu8ssid);
 		kfree(hif_drv->usr_conn_req.pu8bssid);
 		hif_drv->usr_conn_req.ConnReqIEsLen = 0;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 2fe9f67..832e064 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -203,7 +203,7 @@ struct user_conn_req {
 	u8 *pu8ssid;
 	u8 u8security;
 	enum AUTHTYPE tenuAuth_type;
-	size_t ssidLen;
+	size_t ssid_len;
 	u8 *pu8ConnReqIEs;
 	size_t ConnReqIEsLen;
 	wilc_connect_result pfUserConnectResult;
-- 
1.9.1

