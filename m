Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:45484 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbbIRJNy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 05:13:54 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 19/34] staging: wilc1000: remove typedef from the struct tstrHostIfPowerMgmtParam
Date: Fri, 18 Sep 2015 18:11:21 +0900
Message-ID: <1442567496-29331-19-git-send-email-tony.cho@atmel.com> (sfid-20150918_111409_373830_37ABB190)
In-Reply-To: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
References: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from the struct tstrHostIfPowerMgmtParam and
renames it to power_mgmt_param in order to comply with the Linux coding
style.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 5f546e5..12adb03 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -360,7 +360,7 @@ struct timer_cb {
 };
 
 /*!
- *  @struct     tstrHostIfPowerMgmtParam
+ *  @struct     power_mgmt_param
  *  @brief		Power management message body
  *  @details
  *  @todo
@@ -369,11 +369,11 @@ struct timer_cb {
  *  @date		24 November 2012
  *  @version		1.0
  */
-typedef struct {
+struct power_mgmt_param {
 
 	bool bIsEnabled;
 	u32 u32Timeout;
-} tstrHostIfPowerMgmtParam;
+};
 
 /*!
  *  @struct             tstrHostIFSetIPAddr
@@ -432,7 +432,7 @@ union message_body {
 	struct add_sta_param strEditStaParam;                           /*!< Edit station message body */
 	/* tstrScanComplete		strScanComplete;		/ *Received Async. Scan Complete message body* / */
 	struct timer_cb strTimerCb;                                                 /*!< Timer callback message body */
-	tstrHostIfPowerMgmtParam strPowerMgmtparam;     /*!< Power Management message body */
+	struct power_mgmt_param strPowerMgmtparam;     /*!< Power Management message body */
 	tstrHostIfStaInactiveT strHostIfStaInactiveT;
 	tstrHostIFSetIPAddr strHostIfSetIP;
 	tstrHostIfSetDrvHandler strHostIfSetDrvHandler;
@@ -4020,7 +4020,8 @@ static void ListenTimerCB(unsigned long arg)
  *  @date
  *  @version	1.0
  */
-static void Handle_PowerManagement(tstrWILC_WFIDrv *drvHandler, tstrHostIfPowerMgmtParam *strPowerMgmtParam)
+static void Handle_PowerManagement(tstrWILC_WFIDrv *drvHandler,
+				   struct power_mgmt_param *strPowerMgmtParam)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
@@ -7266,7 +7267,7 @@ s32 host_int_set_power_mgmt(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32Ti
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	tstrHostIfPowerMgmtParam *pstrPowerMgmtParam = &msg.body.strPowerMgmtparam;
+	struct power_mgmt_param *pstrPowerMgmtParam = &msg.body.strPowerMgmtparam;
 
 	PRINT_INFO(HOSTINF_DBG, "\n\n>> Setting PS to %d <<\n\n", bIsEnabled);
 
-- 
1.9.1

