Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:45531 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbbIRJOB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 05:14:01 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 20/34] staging: wilc1000: remove typedef from the struct tstrHostIfStaInactiveT
Date: Fri, 18 Sep 2015 18:11:22 +0900
Message-ID: <1442567496-29331-20-git-send-email-tony.cho@atmel.com> (sfid-20150918_111408_314059_D181AF83)
In-Reply-To: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
References: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
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
index 12adb03..8fc9186 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -392,7 +392,7 @@ typedef struct {
 } tstrHostIFSetIPAddr;
 
 /*!
- *  @struct     tstrHostIfStaInactiveT
+ *  @struct     sta_inactive_t
  *  @brief		Get station message body
  *  @details
  *  @todo
@@ -401,10 +401,9 @@ typedef struct {
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
@@ -433,7 +432,7 @@ union message_body {
 	/* tstrScanComplete		strScanComplete;		/ *Received Async. Scan Complete message body* / */
 	struct timer_cb strTimerCb;                                                 /*!< Timer callback message body */
 	struct power_mgmt_param strPowerMgmtparam;     /*!< Power Management message body */
-	tstrHostIfStaInactiveT strHostIfStaInactiveT;
+	struct sta_inactive_t strHostIfStaInactiveT;
 	tstrHostIFSetIPAddr strHostIfSetIP;
 	tstrHostIfSetDrvHandler strHostIfSetDrvHandler;
 	tstrHostIFSetMulti strHostIfSetMulti;
@@ -3393,7 +3392,8 @@ s32 Handle_GetStatistics(tstrWILC_WFIDrv *drvHandler, tstrStatistics *pstrStatis
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

