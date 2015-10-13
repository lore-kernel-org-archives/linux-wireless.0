Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3074 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbbJMKxj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:53:39 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 28/54] staging: wilc1000: rename IEsLen of struct connect_attr
Date: Tue, 13 Oct 2015 19:49:53 +0900
Message-ID: <1444733419-17679-28-git-send-email-tony.cho@atmel.com> (sfid-20151013_131654_774575_79A062EB)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames IEsLen of struct connect_attr to ies_len to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 5d0e412..545f763 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -112,7 +112,7 @@ struct connect_attr {
 	u8 *ssid;
 	size_t ssid_len;
 	u8 *ies;
-	size_t IEsLen;
+	size_t ies_len;
 	u8 u8security;
 	wilc_connect_result pfConnectResult;
 	void *pvUserArg;
@@ -1044,11 +1044,11 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 		hif_drv->strWILC_UsrConnReq.pu8ssid[pstrHostIFconnectAttr->ssid_len] = '\0';
 	}
 
-	hif_drv->strWILC_UsrConnReq.ConnReqIEsLen = pstrHostIFconnectAttr->IEsLen;
+	hif_drv->strWILC_UsrConnReq.ConnReqIEsLen = pstrHostIFconnectAttr->ies_len;
 	if (pstrHostIFconnectAttr->ies != NULL) {
-		hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs = kmalloc(pstrHostIFconnectAttr->IEsLen, GFP_KERNEL);
+		hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs = kmalloc(pstrHostIFconnectAttr->ies_len, GFP_KERNEL);
 		memcpy(hif_drv->strWILC_UsrConnReq.pu8ConnReqIEs, pstrHostIFconnectAttr->ies,
-			    pstrHostIFconnectAttr->IEsLen);
+			    pstrHostIFconnectAttr->ies_len);
 	}
 
 	hif_drv->strWILC_UsrConnReq.u8security = pstrHostIFconnectAttr->u8security;
@@ -1263,11 +1263,11 @@ ERRORHANDLER:
 				memcpy(strConnectInfo.au8bssid, pstrHostIFconnectAttr->bssid, 6);
 
 			if (pstrHostIFconnectAttr->ies != NULL) {
-				strConnectInfo.ReqIEsLen = pstrHostIFconnectAttr->IEsLen;
-				strConnectInfo.pu8ReqIEs = kmalloc(pstrHostIFconnectAttr->IEsLen, GFP_KERNEL);
+				strConnectInfo.ReqIEsLen = pstrHostIFconnectAttr->ies_len;
+				strConnectInfo.pu8ReqIEs = kmalloc(pstrHostIFconnectAttr->ies_len, GFP_KERNEL);
 				memcpy(strConnectInfo.pu8ReqIEs,
 					    pstrHostIFconnectAttr->ies,
-					    pstrHostIFconnectAttr->IEsLen);
+					    pstrHostIFconnectAttr->ies_len);
 			}
 
 			pstrHostIFconnectAttr->pfConnectResult(CONN_DISCONN_EVENT_CONN_RESP,
@@ -3631,7 +3631,7 @@ s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 	}
 
 	if (pu8IEs != NULL) {
-		msg.body.con_info.IEsLen = IEsLen;
+		msg.body.con_info.ies_len = IEsLen;
 		msg.body.con_info.ies = kmalloc(IEsLen, GFP_KERNEL);
 		memcpy(msg.body.con_info.ies, pu8IEs, IEsLen);
 	}
-- 
1.9.1

