Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47016 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937AbbI3Jzz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 05:55:55 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 27/32] staging: wilc1000: rename strHostIfBASessionInfo
Date: Wed, 30 Sep 2015 18:55:09 +0900
Message-ID: <1443606914-25563-5-git-send-email-tony.cho@atmel.com> (sfid-20150930_115606_849240_8FBC9B9D)
In-Reply-To: <1443606914-25563-1-git-send-email-tony.cho@atmel.com>
References: <1443606914-25563-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames strHostIfBASessionInfo to session_info to avoid
CamelCase naming convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a6702dd..b7797a5 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -389,7 +389,7 @@ union message_body {
 	struct op_mode mode;
 	struct set_mac_addr set_mac_info;
 	struct get_mac_addr get_mac_info;
-	struct ba_session_info strHostIfBASessionInfo;
+	struct ba_session_info session_info;
 	struct remain_ch strHostIfRemainOnChan;
 	struct reg_frame strHostIfRegisterFrame;
 	char *pUserData;
@@ -4204,11 +4204,11 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_ADD_BA_SESSION:
-			Handle_AddBASession(msg.drvHandler, &msg.body.strHostIfBASessionInfo);
+			Handle_AddBASession(msg.drvHandler, &msg.body.session_info);
 			break;
 
 		case HOST_IF_MSG_DEL_ALL_RX_BA_SESSIONS:
-			Handle_DelAllRxBASessions(msg.drvHandler, &msg.body.strHostIfBASessionInfo);
+			Handle_DelAllRxBASessions(msg.drvHandler, &msg.body.session_info);
 			break;
 
 		case HOST_IF_MSG_DEL_ALL_STA:
@@ -7119,7 +7119,7 @@ static int host_int_addBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TI
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	struct ba_session_info *pBASessionInfo = &msg.body.strHostIfBASessionInfo;
+	struct ba_session_info *pBASessionInfo = &msg.body.session_info;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
@@ -7150,7 +7150,7 @@ s32 host_int_delBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID)
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	struct ba_session_info *pBASessionInfo = &msg.body.strHostIfBASessionInfo;
+	struct ba_session_info *pBASessionInfo = &msg.body.session_info;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
@@ -7180,7 +7180,7 @@ s32 host_int_del_All_Rx_BASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char T
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	struct ba_session_info *pBASessionInfo = &msg.body.strHostIfBASessionInfo;
+	struct ba_session_info *pBASessionInfo = &msg.body.session_info;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
-- 
1.9.1

