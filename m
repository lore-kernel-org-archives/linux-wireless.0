Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:34697 "EHLO
	mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757428AbcBYAQT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 19:16:19 -0500
Received: by mail-pf0-f177.google.com with SMTP id x65so21962398pfb.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 Feb 2016 16:16:18 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 7/9] staging: wilc1000: rename u16ConnectStatus in struct connect_info
Date: Thu, 25 Feb 2016 09:15:48 +0900
Message-Id: <1456359350-17118-7-git-send-email-chaehyun.lim@gmail.com> (sfid-20160225_011627_652741_0A9D421B)
In-Reply-To: <1456359350-17118-1-git-send-email-chaehyun.lim@gmail.com>
References: <1456359350-17118-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u16ConnectStatus to status to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.h       |  2 +-
 drivers/staging/wilc1000/host_interface.c         | 10 +++++-----
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 408031f..9fbd52b 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -111,7 +111,7 @@ struct connect_info {
 	size_t req_ies_len;
 	u8 *resp_ies;
 	u16 resp_ies_len;
-	u16 u16ConnectStatus;
+	u16 status;
 };
 
 typedef struct {
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 58902bf..1ebe08a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1463,9 +1463,9 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 					if (s32Err) {
 						netdev_err(vif->ndev, "wilc_parse_assoc_resp_info() returned error %d\n", s32Err);
 					} else {
-						strConnectInfo.u16ConnectStatus = pstrConnectRespInfo->status;
+						strConnectInfo.status = pstrConnectRespInfo->status;
 
-						if (strConnectInfo.u16ConnectStatus == SUCCESSFUL_STATUSCODE) {
+						if (strConnectInfo.status == SUCCESSFUL_STATUSCODE) {
 							if (pstrConnectRespInfo->ies) {
 								strConnectInfo.resp_ies_len = pstrConnectRespInfo->ies_len;
 								strConnectInfo.resp_ies = kmalloc(pstrConnectRespInfo->ies_len, GFP_KERNEL);
@@ -1483,7 +1483,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 			}
 
 			if ((u8MacStatus == MAC_CONNECTED) &&
-			    (strConnectInfo.u16ConnectStatus != SUCCESSFUL_STATUSCODE))	{
+			    (strConnectInfo.status != SUCCESSFUL_STATUSCODE))	{
 				netdev_err(vif->ndev, "Received MAC status is MAC_CONNECTED while the received status code in Asoc Resp is not SUCCESSFUL_STATUSCODE\n");
 				eth_zero_addr(wilc_connected_ssid);
 			} else if (u8MacStatus == MAC_DISCONNECTED)    {
@@ -1495,7 +1495,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 				memcpy(strConnectInfo.bssid, hif_drv->usr_conn_req.bssid, 6);
 
 				if ((u8MacStatus == MAC_CONNECTED) &&
-				    (strConnectInfo.u16ConnectStatus == SUCCESSFUL_STATUSCODE))	{
+				    (strConnectInfo.status == SUCCESSFUL_STATUSCODE))	{
 					memcpy(hif_drv->assoc_bssid,
 					       hif_drv->usr_conn_req.bssid, ETH_ALEN);
 				}
@@ -1517,7 +1517,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 							  hif_drv->usr_conn_req.arg);
 
 			if ((u8MacStatus == MAC_CONNECTED) &&
-			    (strConnectInfo.u16ConnectStatus == SUCCESSFUL_STATUSCODE))	{
+			    (strConnectInfo.status == SUCCESSFUL_STATUSCODE))	{
 				wilc_set_power_mgmt(vif, 0, 0);
 
 				hif_drv->hif_state = HOST_IF_CONNECTED;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 1dbeca5..c492423 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -502,10 +502,10 @@ static void CfgConnectResult(enum conn_event enuConnDisconnEvent,
 	if (enuConnDisconnEvent == CONN_DISCONN_EVENT_CONN_RESP) {
 		u16 u16ConnectStatus;
 
-		u16ConnectStatus = pstrConnectInfo->u16ConnectStatus;
+		u16ConnectStatus = pstrConnectInfo->status;
 
 		if ((u8MacStatus == MAC_DISCONNECTED) &&
-		    (pstrConnectInfo->u16ConnectStatus == SUCCESSFUL_STATUSCODE)) {
+		    (pstrConnectInfo->status == SUCCESSFUL_STATUSCODE)) {
 			u16ConnectStatus = WLAN_STATUS_UNSPECIFIED_FAILURE;
 			wilc_wlan_set_bssid(priv->dev, NullBssid,
 					    STATION_MODE);
-- 
2.7.1

