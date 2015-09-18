Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:45773 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbbIRJOs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 05:14:48 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 27/34] staging: wilc1000: remove typedef from the struct tstrHostIfBASessionInfo
Date: Fri, 18 Sep 2015 18:11:29 +0900
Message-ID: <1442567496-29331-27-git-send-email-tony.cho@atmel.com> (sfid-20150918_111452_171444_06090C1A)
In-Reply-To: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
References: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
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
 drivers/staging/wilc1000/host_interface.h |  5 ++---
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 86fce58..163f78e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -438,7 +438,7 @@ union message_body {
 	struct op_mode strHostIfSetOperationMode;
 	struct set_mac_addr strHostIfSetMacAddress;
 	struct get_mac_addr strHostIfGetMacAddress;
-	tstrHostIfBASessionInfo strHostIfBASessionInfo;
+	struct ba_session_info strHostIfBASessionInfo;
 	tstrHostIfRemainOnChan strHostIfRemainOnChan;
 	tstrHostIfRegisterFrame strHostIfRegisterFrame;
 	char *pUserData;
@@ -4111,7 +4111,8 @@ ERRORHANDLER:
  *  @date			Feb. 2014
  *  @version		9.0
  */
-static s32 Handle_AddBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionInfo *strHostIfBASessionInfo)
+static s32 Handle_AddBASession(tstrWILC_WFIDrv *drvHandler,
+			       struct ba_session_info *strHostIfBASessionInfo)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
@@ -4201,7 +4202,8 @@ static s32 Handle_AddBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
  *  @date			Feb. 2013
  *  @version		9.0
  */
-static s32 Handle_DelBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionInfo *strHostIfBASessionInfo)
+static s32 Handle_DelBASession(tstrWILC_WFIDrv *drvHandler,
+			       struct ba_session_info *strHostIfBASessionInfo)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
@@ -4273,7 +4275,8 @@ static s32 Handle_DelBASession(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionI
  *  @date			Feb. 2013
  *  @version		9.0
  */
-static s32 Handle_DelAllRxBASessions(tstrWILC_WFIDrv *drvHandler, tstrHostIfBASessionInfo *strHostIfBASessionInfo)
+static s32 Handle_DelAllRxBASessions(tstrWILC_WFIDrv *drvHandler,
+				     struct ba_session_info *strHostIfBASessionInfo)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
@@ -7572,7 +7575,7 @@ static int host_int_addBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TI
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	tstrHostIfBASessionInfo *pBASessionInfo = &msg.body.strHostIfBASessionInfo;
+	struct ba_session_info *pBASessionInfo = &msg.body.strHostIfBASessionInfo;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
@@ -7603,7 +7606,7 @@ s32 host_int_delBASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char TID)
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	tstrHostIfBASessionInfo *pBASessionInfo = &msg.body.strHostIfBASessionInfo;
+	struct ba_session_info *pBASessionInfo = &msg.body.strHostIfBASessionInfo;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
@@ -7634,7 +7637,7 @@ s32 host_int_del_All_Rx_BASession(tstrWILC_WFIDrv *hWFIDrv, char *pBSSID, char T
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	tstrHostIfBASessionInfo *pBASessionInfo = &msg.body.strHostIfBASessionInfo;
+	struct ba_session_info *pBASessionInfo = &msg.body.strHostIfBASessionInfo;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index d257183..9a1d3599 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -272,13 +272,12 @@ struct get_mac_addr {
 	u8 *u8MacAddress;
 };
 
-/*BugID_5222*/
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

