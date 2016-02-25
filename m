Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:33297 "EHLO
	mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbcBYAQJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 19:16:09 -0500
Received: by mail-pf0-f179.google.com with SMTP id q63so21941935pfb.0
        for <linux-wireless@vger.kernel.org>; Wed, 24 Feb 2016 16:16:09 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 4/9] staging: wilc1000: rename ReqIEsLen in struct connec_info
Date: Thu, 25 Feb 2016 09:15:45 +0900
Message-Id: <1456359350-17118-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20160225_011613_396662_46029DE1)
In-Reply-To: <1456359350-17118-1-git-send-email-chaehyun.lim@gmail.com>
References: <1456359350-17118-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames ReqIEsLen to req_ies_len to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.h       | 2 +-
 drivers/staging/wilc1000/host_interface.c         | 6 +++---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 5ef4fd1..d26e597 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -108,7 +108,7 @@ struct connect_resp_info {
 struct connect_info {
 	u8 bssid[6];
 	u8 *req_ies;
-	size_t ReqIEsLen;
+	size_t req_ies_len;
 	u8 *pu8RespIEs;
 	u16 u16RespIEsLen;
 	u16 u16ConnectStatus;
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 55ed96e..dec3d08 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1158,7 +1158,7 @@ ERRORHANDLER:
 				memcpy(strConnectInfo.bssid, pstrHostIFconnectAttr->bssid, 6);
 
 			if (pstrHostIFconnectAttr->ies) {
-				strConnectInfo.ReqIEsLen = pstrHostIFconnectAttr->ies_len;
+				strConnectInfo.req_ies_len = pstrHostIFconnectAttr->ies_len;
 				strConnectInfo.req_ies = kmalloc(pstrHostIFconnectAttr->ies_len, GFP_KERNEL);
 				memcpy(strConnectInfo.req_ies,
 				       pstrHostIFconnectAttr->ies,
@@ -1265,7 +1265,7 @@ static s32 Handle_ConnectTimeout(struct wilc_vif *vif)
 		}
 
 		if (hif_drv->usr_conn_req.ies) {
-			strConnectInfo.ReqIEsLen = hif_drv->usr_conn_req.ies_len;
+			strConnectInfo.req_ies_len = hif_drv->usr_conn_req.ies_len;
 			strConnectInfo.req_ies = kmalloc(hif_drv->usr_conn_req.ies_len, GFP_KERNEL);
 			memcpy(strConnectInfo.req_ies,
 			       hif_drv->usr_conn_req.ies,
@@ -1502,7 +1502,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 			}
 
 			if (hif_drv->usr_conn_req.ies) {
-				strConnectInfo.ReqIEsLen = hif_drv->usr_conn_req.ies_len;
+				strConnectInfo.req_ies_len = hif_drv->usr_conn_req.ies_len;
 				strConnectInfo.req_ies = kmalloc(hif_drv->usr_conn_req.ies_len, GFP_KERNEL);
 				memcpy(strConnectInfo.req_ies,
 				       hif_drv->usr_conn_req.ies,
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 7260f1d..f8cd128 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -544,7 +544,7 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 		}
 
 		cfg80211_connect_result(dev, pstrConnectInfo->bssid,
-					pstrConnectInfo->req_ies, pstrConnectInfo->ReqIEsLen,
+					pstrConnectInfo->req_ies, pstrConnectInfo->req_ies_len,
 					pstrConnectInfo->pu8RespIEs, pstrConnectInfo->u16RespIEsLen,
 					u16ConnectStatus, GFP_KERNEL);
 	} else if (enuConnDisconnEvent == CONN_DISCONN_EVENT_DISCONN_NOTIF)    {
-- 
2.7.1

