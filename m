Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3154 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089AbbJMKyF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:54:05 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 32/54] staging: wilc1000: rename tenuAuth_type of struct connect_attr
Date: Tue, 13 Oct 2015 19:49:57 +0900
Message-ID: <1444733419-17679-32-git-send-email-tony.cho@atmel.com> (sfid-20151013_125412_497243_ADE9ED87)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames tenuAuth_type of struct connect_attr to auth_type to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 0790dcb..695fd5c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -116,7 +116,7 @@ struct connect_attr {
 	u8 security;
 	wilc_connect_result result;
 	void *arg;
-	enum AUTHTYPE tenuAuth_type;
+	enum AUTHTYPE auth_type;
 	u8 u8channel;
 	void *pJoinParams;
 };
@@ -1052,7 +1052,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	}
 
 	hif_drv->strWILC_UsrConnReq.u8security = pstrHostIFconnectAttr->security;
-	hif_drv->strWILC_UsrConnReq.tenuAuth_type = pstrHostIFconnectAttr->tenuAuth_type;
+	hif_drv->strWILC_UsrConnReq.tenuAuth_type = pstrHostIFconnectAttr->auth_type;
 	hif_drv->strWILC_UsrConnReq.pfUserConnectResult = pstrHostIFconnectAttr->result;
 	hif_drv->strWILC_UsrConnReq.u32UserConnectPvoid = pstrHostIFconnectAttr->arg;
 
@@ -3612,7 +3612,7 @@ s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 	msg.id = HOST_IF_MSG_CONNECT;
 
 	msg.body.con_info.security = u8security;
-	msg.body.con_info.tenuAuth_type = tenuAuth_type;
+	msg.body.con_info.auth_type = tenuAuth_type;
 	msg.body.con_info.u8channel = u8channel;
 	msg.body.con_info.result = pfConnectResult;
 	msg.body.con_info.arg = pvUserArg;
-- 
1.9.1

