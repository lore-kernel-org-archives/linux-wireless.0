Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33193 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbcBYAQG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 19:16:06 -0500
Received: by mail-pa0-f47.google.com with SMTP id fl4so21505211pad.0
        for <linux-wireless@vger.kernel.org>; Wed, 24 Feb 2016 16:16:06 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 3/9] staging: wilc1000: rename pu8ReqIEs in struct connect_info
Date: Thu, 25 Feb 2016 09:15:44 +0900
Message-Id: <1456359350-17118-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20160225_011610_617138_4090AD9D)
In-Reply-To: <1456359350-17118-1-git-send-email-chaehyun.lim@gmail.com>
References: <1456359350-17118-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pu8ReqIEs to req_ies to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.h       |  2 +-
 drivers/staging/wilc1000/host_interface.c         | 24 +++++++++++------------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  2 +-
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index a32f466..5ef4fd1 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -107,7 +107,7 @@ struct connect_resp_info {
 
 struct connect_info {
 	u8 bssid[6];
-	u8 *pu8ReqIEs;
+	u8 *req_ies;
 	size_t ReqIEsLen;
 	u8 *pu8RespIEs;
 	u16 u16RespIEsLen;
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 4a1bad8..55ed96e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1159,8 +1159,8 @@ ERRORHANDLER:
 
 			if (pstrHostIFconnectAttr->ies) {
 				strConnectInfo.ReqIEsLen = pstrHostIFconnectAttr->ies_len;
-				strConnectInfo.pu8ReqIEs = kmalloc(pstrHostIFconnectAttr->ies_len, GFP_KERNEL);
-				memcpy(strConnectInfo.pu8ReqIEs,
+				strConnectInfo.req_ies = kmalloc(pstrHostIFconnectAttr->ies_len, GFP_KERNEL);
+				memcpy(strConnectInfo.req_ies,
 				       pstrHostIFconnectAttr->ies,
 				       pstrHostIFconnectAttr->ies_len);
 			}
@@ -1171,8 +1171,8 @@ ERRORHANDLER:
 							       NULL,
 							       pstrHostIFconnectAttr->arg);
 			hif_drv->hif_state = HOST_IF_IDLE;
-			kfree(strConnectInfo.pu8ReqIEs);
-			strConnectInfo.pu8ReqIEs = NULL;
+			kfree(strConnectInfo.req_ies);
+			strConnectInfo.req_ies = NULL;
 
 		} else {
 			netdev_err(vif->ndev, "Connect callback is NULL\n");
@@ -1266,8 +1266,8 @@ static s32 Handle_ConnectTimeout(struct wilc_vif *vif)
 
 		if (hif_drv->usr_conn_req.ies) {
 			strConnectInfo.ReqIEsLen = hif_drv->usr_conn_req.ies_len;
-			strConnectInfo.pu8ReqIEs = kmalloc(hif_drv->usr_conn_req.ies_len, GFP_KERNEL);
-			memcpy(strConnectInfo.pu8ReqIEs,
+			strConnectInfo.req_ies = kmalloc(hif_drv->usr_conn_req.ies_len, GFP_KERNEL);
+			memcpy(strConnectInfo.req_ies,
 			       hif_drv->usr_conn_req.ies,
 			       hif_drv->usr_conn_req.ies_len);
 		}
@@ -1278,8 +1278,8 @@ static s32 Handle_ConnectTimeout(struct wilc_vif *vif)
 						  NULL,
 						  hif_drv->usr_conn_req.arg);
 
-		kfree(strConnectInfo.pu8ReqIEs);
-		strConnectInfo.pu8ReqIEs = NULL;
+		kfree(strConnectInfo.req_ies);
+		strConnectInfo.req_ies = NULL;
 	} else {
 		netdev_err(vif->ndev, "Connect callback is NULL\n");
 	}
@@ -1503,8 +1503,8 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 
 			if (hif_drv->usr_conn_req.ies) {
 				strConnectInfo.ReqIEsLen = hif_drv->usr_conn_req.ies_len;
-				strConnectInfo.pu8ReqIEs = kmalloc(hif_drv->usr_conn_req.ies_len, GFP_KERNEL);
-				memcpy(strConnectInfo.pu8ReqIEs,
+				strConnectInfo.req_ies = kmalloc(hif_drv->usr_conn_req.ies_len, GFP_KERNEL);
+				memcpy(strConnectInfo.req_ies,
 				       hif_drv->usr_conn_req.ies,
 				       hif_drv->usr_conn_req.ies_len);
 			}
@@ -1533,8 +1533,8 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 			kfree(strConnectInfo.pu8RespIEs);
 			strConnectInfo.pu8RespIEs = NULL;
 
-			kfree(strConnectInfo.pu8ReqIEs);
-			strConnectInfo.pu8ReqIEs = NULL;
+			kfree(strConnectInfo.req_ies);
+			strConnectInfo.req_ies = NULL;
 			hif_drv->usr_conn_req.ssid_len = 0;
 			kfree(hif_drv->usr_conn_req.ssid);
 			hif_drv->usr_conn_req.ssid = NULL;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 1605199..7260f1d 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -544,7 +544,7 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 		}
 
 		cfg80211_connect_result(dev, pstrConnectInfo->bssid,
-					pstrConnectInfo->pu8ReqIEs, pstrConnectInfo->ReqIEsLen,
+					pstrConnectInfo->req_ies, pstrConnectInfo->ReqIEsLen,
 					pstrConnectInfo->pu8RespIEs, pstrConnectInfo->u16RespIEsLen,
 					u16ConnectStatus, GFP_KERNEL);
 	} else if (enuConnDisconnEvent == CONN_DISCONN_EVENT_DISCONN_NOTIF)    {
-- 
2.7.1

