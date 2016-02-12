Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36003 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbcBLOFB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Feb 2016 09:05:01 -0500
Received: by mail-pf0-f194.google.com with SMTP id e127so4027677pfe.3
        for <linux-wireless@vger.kernel.org>; Fri, 12 Feb 2016 06:05:00 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 04/11] staging: wilc1000: rename pu8bssid in struct user_conn_req
Date: Fri, 12 Feb 2016 23:04:40 +0900
Message-Id: <1455285887-29946-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20160212_150514_041788_B851481D)
In-Reply-To: <1455285887-29946-1-git-send-email-chaehyun.lim@gmail.com>
References: <1455285887-29946-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pu8bssid to bssid to remove pu8 prefix in struct
user_conn_req. There is no need to use prefix to show data type of this
variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 30 +++++++++++++++---------------
 drivers/staging/wilc1000/host_interface.h |  2 +-
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index cd4a0a6..7cfc722 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -965,8 +965,8 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 	}
 
 	if (pstrHostIFconnectAttr->bssid) {
-		hif_drv->usr_conn_req.pu8bssid = kmalloc(6, GFP_KERNEL);
-		memcpy(hif_drv->usr_conn_req.pu8bssid, pstrHostIFconnectAttr->bssid, 6);
+		hif_drv->usr_conn_req.bssid = kmalloc(6, GFP_KERNEL);
+		memcpy(hif_drv->usr_conn_req.bssid, pstrHostIFconnectAttr->bssid, 6);
 	}
 
 	hif_drv->usr_conn_req.ssid_len = pstrHostIFconnectAttr->ssid_len;
@@ -1271,9 +1271,9 @@ static s32 Handle_ConnectTimeout(struct wilc_vif *vif)
 	memset(&strConnectInfo, 0, sizeof(tstrConnectInfo));
 
 	if (hif_drv->usr_conn_req.conn_result) {
-		if (hif_drv->usr_conn_req.pu8bssid) {
+		if (hif_drv->usr_conn_req.bssid) {
 			memcpy(strConnectInfo.au8bssid,
-			       hif_drv->usr_conn_req.pu8bssid, 6);
+			       hif_drv->usr_conn_req.bssid, 6);
 		}
 
 		if (hif_drv->usr_conn_req.ies) {
@@ -1309,8 +1309,8 @@ static s32 Handle_ConnectTimeout(struct wilc_vif *vif)
 	hif_drv->usr_conn_req.ssid_len = 0;
 	kfree(hif_drv->usr_conn_req.pu8ssid);
 	hif_drv->usr_conn_req.pu8ssid = NULL;
-	kfree(hif_drv->usr_conn_req.pu8bssid);
-	hif_drv->usr_conn_req.pu8bssid = NULL;
+	kfree(hif_drv->usr_conn_req.bssid);
+	hif_drv->usr_conn_req.bssid = NULL;
 	hif_drv->usr_conn_req.ies_len = 0;
 	kfree(hif_drv->usr_conn_req.ies);
 	hif_drv->usr_conn_req.ies = NULL;
@@ -1503,13 +1503,13 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 				eth_zero_addr(wilc_connected_ssid);
 			}
 
-			if (hif_drv->usr_conn_req.pu8bssid) {
-				memcpy(strConnectInfo.au8bssid, hif_drv->usr_conn_req.pu8bssid, 6);
+			if (hif_drv->usr_conn_req.bssid) {
+				memcpy(strConnectInfo.au8bssid, hif_drv->usr_conn_req.bssid, 6);
 
 				if ((u8MacStatus == MAC_CONNECTED) &&
 				    (strConnectInfo.u16ConnectStatus == SUCCESSFUL_STATUSCODE))	{
 					memcpy(hif_drv->assoc_bssid,
-					       hif_drv->usr_conn_req.pu8bssid, ETH_ALEN);
+					       hif_drv->usr_conn_req.bssid, ETH_ALEN);
 				}
 			}
 
@@ -1550,8 +1550,8 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 			hif_drv->usr_conn_req.ssid_len = 0;
 			kfree(hif_drv->usr_conn_req.pu8ssid);
 			hif_drv->usr_conn_req.pu8ssid = NULL;
-			kfree(hif_drv->usr_conn_req.pu8bssid);
-			hif_drv->usr_conn_req.pu8bssid = NULL;
+			kfree(hif_drv->usr_conn_req.bssid);
+			hif_drv->usr_conn_req.bssid = NULL;
 			hif_drv->usr_conn_req.ies_len = 0;
 			kfree(hif_drv->usr_conn_req.ies);
 			hif_drv->usr_conn_req.ies = NULL;
@@ -1586,8 +1586,8 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 			hif_drv->usr_conn_req.ssid_len = 0;
 			kfree(hif_drv->usr_conn_req.pu8ssid);
 			hif_drv->usr_conn_req.pu8ssid = NULL;
-			kfree(hif_drv->usr_conn_req.pu8bssid);
-			hif_drv->usr_conn_req.pu8bssid = NULL;
+			kfree(hif_drv->usr_conn_req.bssid);
+			hif_drv->usr_conn_req.bssid = NULL;
 			hif_drv->usr_conn_req.ies_len = 0;
 			kfree(hif_drv->usr_conn_req.ies);
 			hif_drv->usr_conn_req.ies = NULL;
@@ -1944,8 +1944,8 @@ static void Handle_Disconnect(struct wilc_vif *vif)
 		hif_drv->usr_conn_req.ssid_len = 0;
 		kfree(hif_drv->usr_conn_req.pu8ssid);
 		hif_drv->usr_conn_req.pu8ssid = NULL;
-		kfree(hif_drv->usr_conn_req.pu8bssid);
-		hif_drv->usr_conn_req.pu8bssid = NULL;
+		kfree(hif_drv->usr_conn_req.bssid);
+		hif_drv->usr_conn_req.bssid = NULL;
 		hif_drv->usr_conn_req.ies_len = 0;
 		kfree(hif_drv->usr_conn_req.ies);
 		hif_drv->usr_conn_req.ies = NULL;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 08c072c..18d67e0 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -203,7 +203,7 @@ struct user_scan_req {
 };
 
 struct user_conn_req {
-	u8 *pu8bssid;
+	u8 *bssid;
 	u8 *pu8ssid;
 	u8 u8security;
 	enum AUTHTYPE auth_type;
-- 
2.7.1

