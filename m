Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35016 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbcBYAQD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 19:16:03 -0500
Received: by mail-pa0-f50.google.com with SMTP id ho8so22086141pac.2
        for <linux-wireless@vger.kernel.org>; Wed, 24 Feb 2016 16:16:03 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 2/9] staging: wilc1000: rename au8bssid in struct connect_info
Date: Thu, 25 Feb 2016 09:15:43 +0900
Message-Id: <1456359350-17118-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20160225_011608_671818_35EBF20E)
In-Reply-To: <1456359350-17118-1-git-send-email-chaehyun.lim@gmail.com>
References: <1456359350-17118-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames au8bssid to bssid to remove au8 prefix in struct
connect_info. There is no need to use prefix to show data type of this
variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.h       | 2 +-
 drivers/staging/wilc1000/host_interface.c         | 6 +++---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 0f39bc8..a32f466 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -106,7 +106,7 @@ struct connect_resp_info {
 };
 
 struct connect_info {
-	u8 au8bssid[6];
+	u8 bssid[6];
 	u8 *pu8ReqIEs;
 	size_t ReqIEsLen;
 	u8 *pu8RespIEs;
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b093304..4a1bad8 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1155,7 +1155,7 @@ ERRORHANDLER:
 
 		if (pstrHostIFconnectAttr->result) {
 			if (pstrHostIFconnectAttr->bssid)
-				memcpy(strConnectInfo.au8bssid, pstrHostIFconnectAttr->bssid, 6);
+				memcpy(strConnectInfo.bssid, pstrHostIFconnectAttr->bssid, 6);
 
 			if (pstrHostIFconnectAttr->ies) {
 				strConnectInfo.ReqIEsLen = pstrHostIFconnectAttr->ies_len;
@@ -1260,7 +1260,7 @@ static s32 Handle_ConnectTimeout(struct wilc_vif *vif)
 
 	if (hif_drv->usr_conn_req.conn_result) {
 		if (hif_drv->usr_conn_req.bssid) {
-			memcpy(strConnectInfo.au8bssid,
+			memcpy(strConnectInfo.bssid,
 			       hif_drv->usr_conn_req.bssid, 6);
 		}
 
@@ -1492,7 +1492,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 			}
 
 			if (hif_drv->usr_conn_req.bssid) {
-				memcpy(strConnectInfo.au8bssid, hif_drv->usr_conn_req.bssid, 6);
+				memcpy(strConnectInfo.bssid, hif_drv->usr_conn_req.bssid, 6);
 
 				if ((u8MacStatus == MAC_CONNECTED) &&
 				    (strConnectInfo.u16ConnectStatus == SUCCESSFUL_STATUSCODE))	{
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 52553a5..1605199 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -521,12 +521,12 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 			bool bNeedScanRefresh = false;
 			u32 i;
 
-			memcpy(priv->au8AssociatedBss, pstrConnectInfo->au8bssid, ETH_ALEN);
+			memcpy(priv->au8AssociatedBss, pstrConnectInfo->bssid, ETH_ALEN);
 
 
 			for (i = 0; i < last_scanned_cnt; i++) {
 				if (memcmp(last_scanned_shadow[i].bssid,
-					   pstrConnectInfo->au8bssid,
+					   pstrConnectInfo->bssid,
 					   ETH_ALEN) == 0) {
 					unsigned long now = jiffies;
 
@@ -543,7 +543,7 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 				refresh_scan(priv, 1, true);
 		}
 
-		cfg80211_connect_result(dev, pstrConnectInfo->au8bssid,
+		cfg80211_connect_result(dev, pstrConnectInfo->bssid,
 					pstrConnectInfo->pu8ReqIEs, pstrConnectInfo->ReqIEsLen,
 					pstrConnectInfo->pu8RespIEs, pstrConnectInfo->u16RespIEsLen,
 					u16ConnectStatus, GFP_KERNEL);
-- 
2.7.1

