Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:27037 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965300AbbJ2DEl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 23:04:41 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 45/64] staging: wilc1000: rename tenuAuth_type of struct user_conn_req
Date: Thu, 29 Oct 2015 12:05:37 +0900
Message-ID: <1446087956-19054-12-git-send-email-glen.lee@atmel.com> (sfid-20151029_040444_102497_2182598B)
In-Reply-To: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
References: <1446087956-19054-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames tenuAuth_type of struct user_conn_req to auth_type
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 9 +++++----
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index f465233..6c49091 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1028,7 +1028,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	}
 
 	hif_drv->usr_conn_req.u8security = pstrHostIFconnectAttr->security;
-	hif_drv->usr_conn_req.tenuAuth_type = pstrHostIFconnectAttr->auth_type;
+	hif_drv->usr_conn_req.auth_type = pstrHostIFconnectAttr->auth_type;
 	hif_drv->usr_conn_req.conn_result = pstrHostIFconnectAttr->result;
 	hif_drv->usr_conn_req.arg = pstrHostIFconnectAttr->arg;
 
@@ -1078,13 +1078,14 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	strWIDList[u32WidsCount].id = (u16)WID_AUTH_TYPE;
 	strWIDList[u32WidsCount].type = WID_CHAR;
 	strWIDList[u32WidsCount].size = sizeof(char);
-	strWIDList[u32WidsCount].val = (s8 *)(&hif_drv->usr_conn_req.tenuAuth_type);
+	strWIDList[u32WidsCount].val = (s8 *)&hif_drv->usr_conn_req.auth_type;
 	u32WidsCount++;
 
 	if (memcmp("DIRECT-", pstrHostIFconnectAttr->ssid, 7))
-		auth_type = (u8)hif_drv->usr_conn_req.tenuAuth_type;
+		auth_type = (u8)hif_drv->usr_conn_req.auth_type;
 
-	PRINT_INFO(HOSTINF_DBG, "Authentication Type = %x\n", hif_drv->usr_conn_req.tenuAuth_type);
+	PRINT_INFO(HOSTINF_DBG, "Authentication Type = %x\n",
+		   hif_drv->usr_conn_req.auth_type);
 	PRINT_D(HOSTINF_DBG, "Connecting to network of SSID %s on channel %d\n",
 		hif_drv->usr_conn_req.pu8ssid, pstrHostIFconnectAttr->ch);
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index f824866..c338028 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -206,7 +206,7 @@ struct user_conn_req {
 	u8 *pu8bssid;
 	u8 *pu8ssid;
 	u8 u8security;
-	enum AUTHTYPE tenuAuth_type;
+	enum AUTHTYPE auth_type;
 	size_t ssid_len;
 	u8 *ies;
 	size_t ies_len;
-- 
1.9.1

