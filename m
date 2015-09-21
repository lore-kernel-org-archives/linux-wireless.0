Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:21359 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001AbbIUDTi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 23:19:38 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 20/34] staging: wilc1000: remove typedef from the struct tstrHostIfStaInactiveT
Date: Mon, 21 Sep 2015 12:16:49 +0900
Message-ID: <1442805423-3711-21-git-send-email-tony.cho@atmel.com> (sfid-20150921_054656_108193_D0DF8E62)
In-Reply-To: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
References: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from the struct tstrHostIfStaInactiveT and
renames it to sta_inactive_t in oder to comply with the Linux coding
style.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d95bba5..ee550c5 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -391,7 +391,7 @@ typedef struct {
 } tstrHostIFSetIPAddr;
 
 /*!
- *  @struct     tstrHostIfStaInactiveT
+ *  @struct     sta_inactive_t
  *  @brief		Get station message body
  *  @details
  *  @todo
@@ -400,10 +400,9 @@ typedef struct {
  *  @date		16 April 2013
  *  @version		1.0
  */
-typedef struct {
+struct sta_inactive_t {
 	u8 mac[6];
-
-} tstrHostIfStaInactiveT;
+};
 /**/
 /*!
  *  @union              message_body
@@ -432,7 +431,7 @@ union message_body {
 	/* tstrScanComplete		strScanComplete;		/ *Received Async. Scan Complete message body* / */
 	struct timer_cb strTimerCb;                                                 /*!< Timer callback message body */
 	struct power_mgmt_param strPowerMgmtparam;     /*!< Power Management message body */
-	tstrHostIfStaInactiveT strHostIfStaInactiveT;
+	struct sta_inactive_t strHostIfStaInactiveT;
 	tstrHostIFSetIPAddr strHostIfSetIP;
 	tstrHostIfSetDrvHandler strHostIfSetDrvHandler;
 	tstrHostIFSetMulti strHostIfSetMulti;
@@ -3376,7 +3375,8 @@ s32 Handle_GetStatistics(tstrWILC_WFIDrv *drvHandler, tstrStatistics *pstrStatis
  *  @date
  *  @version	1.0
  */
-static s32 Handle_Get_InActiveTime(tstrWILC_WFIDrv *drvHandler, tstrHostIfStaInactiveT *strHostIfStaInactiveT)
+static s32 Handle_Get_InActiveTime(tstrWILC_WFIDrv *drvHandler,
+				   struct sta_inactive_t *strHostIfStaInactiveT)
 {
 
 	s32 s32Error = 0;
-- 
1.9.1

