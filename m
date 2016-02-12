Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:35319 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbcBLOFE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Feb 2016 09:05:04 -0500
Received: by mail-pa0-f68.google.com with SMTP id fl4so3853442pad.2
        for <linux-wireless@vger.kernel.org>; Fri, 12 Feb 2016 06:05:04 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 05/11] staging: wilc1000: rename pu8ssid in struct user_conn_req
Date: Fri, 12 Feb 2016 23:04:41 +0900
Message-Id: <1455285887-29946-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20160212_150511_110458_6F71EB41)
In-Reply-To: <1455285887-29946-1-git-send-email-chaehyun.lim@gmail.com>
References: <1455285887-29946-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pu8ssid to ssid to remove pu8 prefix in struct
user_conn_req. There is no need to use prefix to show data type of this
variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 22 +++++++++++-----------
 drivers/staging/wilc1000/host_interface.h |  2 +-
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 7cfc722..397ef61 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -971,11 +971,11 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 
 	hif_drv->usr_conn_req.ssid_len = pstrHostIFconnectAttr->ssid_len;
 	if (pstrHostIFconnectAttr->ssid) {
-		hif_drv->usr_conn_req.pu8ssid = kmalloc(pstrHostIFconnectAttr->ssid_len + 1, GFP_KERNEL);
-		memcpy(hif_drv->usr_conn_req.pu8ssid,
+		hif_drv->usr_conn_req.ssid = kmalloc(pstrHostIFconnectAttr->ssid_len + 1, GFP_KERNEL);
+		memcpy(hif_drv->usr_conn_req.ssid,
 		       pstrHostIFconnectAttr->ssid,
 		       pstrHostIFconnectAttr->ssid_len);
-		hif_drv->usr_conn_req.pu8ssid[pstrHostIFconnectAttr->ssid_len] = '\0';
+		hif_drv->usr_conn_req.ssid[pstrHostIFconnectAttr->ssid_len] = '\0';
 	}
 
 	hif_drv->usr_conn_req.ies_len = pstrHostIFconnectAttr->ies_len;
@@ -1307,8 +1307,8 @@ static s32 Handle_ConnectTimeout(struct wilc_vif *vif)
 		PRINT_ER("Failed to send dissconect config packet\n");
 
 	hif_drv->usr_conn_req.ssid_len = 0;
-	kfree(hif_drv->usr_conn_req.pu8ssid);
-	hif_drv->usr_conn_req.pu8ssid = NULL;
+	kfree(hif_drv->usr_conn_req.ssid);
+	hif_drv->usr_conn_req.ssid = NULL;
 	kfree(hif_drv->usr_conn_req.bssid);
 	hif_drv->usr_conn_req.bssid = NULL;
 	hif_drv->usr_conn_req.ies_len = 0;
@@ -1548,8 +1548,8 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 			kfree(strConnectInfo.pu8ReqIEs);
 			strConnectInfo.pu8ReqIEs = NULL;
 			hif_drv->usr_conn_req.ssid_len = 0;
-			kfree(hif_drv->usr_conn_req.pu8ssid);
-			hif_drv->usr_conn_req.pu8ssid = NULL;
+			kfree(hif_drv->usr_conn_req.ssid);
+			hif_drv->usr_conn_req.ssid = NULL;
 			kfree(hif_drv->usr_conn_req.bssid);
 			hif_drv->usr_conn_req.bssid = NULL;
 			hif_drv->usr_conn_req.ies_len = 0;
@@ -1584,8 +1584,8 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 			eth_zero_addr(hif_drv->assoc_bssid);
 
 			hif_drv->usr_conn_req.ssid_len = 0;
-			kfree(hif_drv->usr_conn_req.pu8ssid);
-			hif_drv->usr_conn_req.pu8ssid = NULL;
+			kfree(hif_drv->usr_conn_req.ssid);
+			hif_drv->usr_conn_req.ssid = NULL;
 			kfree(hif_drv->usr_conn_req.bssid);
 			hif_drv->usr_conn_req.bssid = NULL;
 			hif_drv->usr_conn_req.ies_len = 0;
@@ -1942,8 +1942,8 @@ static void Handle_Disconnect(struct wilc_vif *vif)
 		eth_zero_addr(hif_drv->assoc_bssid);
 
 		hif_drv->usr_conn_req.ssid_len = 0;
-		kfree(hif_drv->usr_conn_req.pu8ssid);
-		hif_drv->usr_conn_req.pu8ssid = NULL;
+		kfree(hif_drv->usr_conn_req.ssid);
+		hif_drv->usr_conn_req.ssid = NULL;
 		kfree(hif_drv->usr_conn_req.bssid);
 		hif_drv->usr_conn_req.bssid = NULL;
 		hif_drv->usr_conn_req.ies_len = 0;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 18d67e0..30acf40 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -204,7 +204,7 @@ struct user_scan_req {
 
 struct user_conn_req {
 	u8 *bssid;
-	u8 *pu8ssid;
+	u8 *ssid;
 	u8 u8security;
 	enum AUTHTYPE auth_type;
 	size_t ssid_len;
-- 
2.7.1

