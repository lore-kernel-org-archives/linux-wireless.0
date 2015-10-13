Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3175 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089AbbJMKyM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 06:54:12 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 33/54] staging: wilc1000: rename u8channel of struct connect_attr
Date: Tue, 13 Oct 2015 19:49:58 +0900
Message-ID: <1444733419-17679-33-git-send-email-tony.cho@atmel.com> (sfid-20151013_125415_787882_BD2EA342)
In-Reply-To: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
References: <1444733419-17679-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames u8channel of struct connect_attr to ch to
avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 695fd5c..fbc48ee 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -117,7 +117,7 @@ struct connect_attr {
 	wilc_connect_result result;
 	void *arg;
 	enum AUTHTYPE auth_type;
-	u8 u8channel;
+	u8 ch;
 	void *pJoinParams;
 };
 
@@ -1112,7 +1112,7 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 
 	PRINT_INFO(HOSTINF_DBG, "Authentication Type = %x\n", hif_drv->strWILC_UsrConnReq.tenuAuth_type);
 	PRINT_D(HOSTINF_DBG, "Connecting to network of SSID %s on channel %d\n",
-		hif_drv->strWILC_UsrConnReq.pu8ssid, pstrHostIFconnectAttr->u8channel);
+		hif_drv->strWILC_UsrConnReq.pu8ssid, pstrHostIFconnectAttr->ch);
 
 	strWIDList[u32WidsCount].id = (u16)WID_JOIN_REQ_EXTENDED;
 	strWIDList[u32WidsCount].type = WID_STR;
@@ -1138,8 +1138,8 @@ static s32 Handle_Connect(struct host_if_drv *hif_drv,
 	pu8CurrByte += MAX_SSID_LEN;
 	*(pu8CurrByte++) = INFRASTRUCTURE;
 
-	if ((pstrHostIFconnectAttr->u8channel >= 1) && (pstrHostIFconnectAttr->u8channel <= 14)) {
-		*(pu8CurrByte++) = pstrHostIFconnectAttr->u8channel;
+	if ((pstrHostIFconnectAttr->ch >= 1) && (pstrHostIFconnectAttr->ch <= 14)) {
+		*(pu8CurrByte++) = pstrHostIFconnectAttr->ch;
 	} else {
 		PRINT_ER("Channel out of range\n");
 		*(pu8CurrByte++) = 0xFF;
@@ -3613,7 +3613,7 @@ s32 host_int_set_join_req(struct host_if_drv *hif_drv, u8 *pu8bssid,
 
 	msg.body.con_info.security = u8security;
 	msg.body.con_info.auth_type = tenuAuth_type;
-	msg.body.con_info.u8channel = u8channel;
+	msg.body.con_info.ch = u8channel;
 	msg.body.con_info.result = pfConnectResult;
 	msg.body.con_info.arg = pvUserArg;
 	msg.body.con_info.pJoinParams = pJoinParams;
-- 
1.9.1

