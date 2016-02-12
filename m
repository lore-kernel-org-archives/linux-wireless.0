Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36024 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbcBLOFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Feb 2016 09:05:07 -0500
Received: by mail-pf0-f194.google.com with SMTP id e127so4027790pfe.3
        for <linux-wireless@vger.kernel.org>; Fri, 12 Feb 2016 06:05:07 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 06/11] staging: wilc1000: rename u8security in user_conn_req
Date: Fri, 12 Feb 2016 23:04:42 +0900
Message-Id: <1455285887-29946-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20160212_150526_862439_2FA8D63A)
In-Reply-To: <1455285887-29946-1-git-send-email-chaehyun.lim@gmail.com>
References: <1455285887-29946-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u8security to security to remove u8 prefix in struct
user_conn_req. There is no need to use prefix to show data type of this
variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 397ef61..a9c8b15 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -986,7 +986,7 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 		       pstrHostIFconnectAttr->ies_len);
 	}
 
-	hif_drv->usr_conn_req.u8security = pstrHostIFconnectAttr->security;
+	hif_drv->usr_conn_req.security = pstrHostIFconnectAttr->security;
 	hif_drv->usr_conn_req.auth_type = pstrHostIFconnectAttr->auth_type;
 	hif_drv->usr_conn_req.conn_result = pstrHostIFconnectAttr->result;
 	hif_drv->usr_conn_req.arg = pstrHostIFconnectAttr->arg;
@@ -1026,11 +1026,11 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 	strWIDList[u32WidsCount].id = (u16)WID_11I_MODE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
-	strWIDList[u32WidsCount].val = (s8 *)&hif_drv->usr_conn_req.u8security;
+	strWIDList[u32WidsCount].val = (s8 *)&hif_drv->usr_conn_req.security;
 	u32WidsCount++;
 
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7))
-		mode_11i = hif_drv->usr_conn_req.u8security;
+		mode_11i = hif_drv->usr_conn_req.security;
 
 	strWIDList[u32WidsCount].id = (u16)WID_AUTH_TYPE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 30acf40..5e65f2c 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -205,7 +205,7 @@ struct user_scan_req {
 struct user_conn_req {
 	u8 *bssid;
 	u8 *ssid;
-	u8 u8security;
+	u8 security;
 	enum AUTHTYPE auth_type;
 	size_t ssid_len;
 	u8 *ies;
-- 
2.7.1

