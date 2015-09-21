Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:21498 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878AbbIUDUZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 23:20:25 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 27/34] staging: wilc1000: remove typedef from the struct tstrHostIfBASessionInfo
Date: Mon, 21 Sep 2015 12:16:56 +0900
Message-ID: <1442805423-3711-28-git-send-email-tony.cho@atmel.com> (sfid-20150921_052029_134069_D6F53E08)
In-Reply-To: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
References: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from the struct tstrHostIfBASessionInfo and
renames it to ba_session_info in order to comply with the Linux coding
style.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 17 ++++++++++-------
 drivers/staging/wilc1000/host_interface.h |  4 ++--
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d35122e3..d405d03 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -437,7 +437,7 @@ union message_body {
 	struct op_mode strHostIfSetOperationMode;
 	struct set_mac_addr strHostIfSetMacAddress;
 	struct get_mac_addr strHostIfGetMacAddress;
-	tstrHostIfBASessionInfo strHostIfBASessionInfo;
+	struct ba_session_info strHostIfBASessionInfo;
 	tstrHostIfRemainOnChan strHostIfRemainOnChan;
 	tstrHostIfRegisterFrame strHostIfRegisterFrame;
 	char *pUserData;
@@ -4092,7 +4092,8 @@ ERRORHANDLER:
  *  @date			Feb. 2014
  *  @version		9.0
  */
-static s32 Handle_AddBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionInfo *strHostIfBASessionInfo)
+static s32 Handle_AddBASession(tstrWILC_WFIDrv *drvHandler,
+			       struct ba_session_info *strHostIfBASessionInfo)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
@@ -4181,7 +4182,8 @@ static s32 Handle_AddBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
  *  @date			Feb. 2013
  *  @version		9.0
  */
-static s32 Handle_DelBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionInfo *strHostIfBASessionInfo)
+static s32 Handle_DelBASession(tstrWILC_WFIDrv *drvHandler,
+			       struct ba_session_info *strHostIfBASessionInfo)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
@@ -4252,7 +4254,8 @@ static s32 Handle_DelBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
  *  @date			Feb. 2013
  *  @version		9.0
  */
-static s32 Handle_DelAllRxBASessions(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionInfo *strHostIfBASessionInfo)
+static s32 Handle_DelAllRxBASessions(tstrWILC_WFIDrv *drvHandler,
+				     struct ba_session_info *strHostIfBASessionInfo)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
@@ -7535,7 +7538,7 @@ static int host_int_addBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TI
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	tstrHostIfBASessionInfo *pBASessionInfo = &msg.body.strHostIfBASessionInfo;
+	struct ba_session_info *pBASessionInfo = &msg.body.strHostIfBASessionInfo;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
@@ -7566,7 +7569,7 @@ s32 host_int_delBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID)
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	tstrHostIfBASessionInfo *pBASessionInfo = &msg.body.strHostIfBASessionInfo;
+	struct ba_session_info *pBASessionInfo = &msg.body.strHostIfBASessionInfo;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
@@ -7596,7 +7599,7 @@ s32 host_int_del_All_Rx_BASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char T
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	tstrHostIfBASessionInfo *pBASessionInfo = &msg.body.strHostIfBASessionInfo;
+	struct ba_session_info *pBASessionInfo = &msg.body.strHostIfBASessionInfo;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index c8b482f..aba00f1 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -271,12 +271,12 @@ struct get_mac_addr {
 	u8 *u8MacAddress;
 };
 
-typedef struct {
+struct ba_session_info {
 	u8 au8Bssid[ETH_ALEN];
 	u8 u8Ted;
 	u16 u16BufferSize;
 	u16 u16SessionTimeout;
-} tstrHostIfBASessionInfo;
+};
 
 typedef struct {
 	u16 u16Channel;
-- 
1.9.1

