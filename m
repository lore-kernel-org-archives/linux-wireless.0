Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:45807 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbbIRJOz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 05:14:55 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 28/34] staging: wilc1000: remove typedef from the struct tstrHostIFDelSta
Date: Fri, 18 Sep 2015 18:11:30 +0900
Message-ID: <1442567496-29331-28-git-send-email-tony.cho@atmel.com> (sfid-20150918_111459_191054_47FCD7E5)
In-Reply-To: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
References: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from the struct tstrHostIFDelSta and renames
it del_sta in order to comply with the Linux coding style.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 163f78e..8894f90 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -331,7 +331,7 @@ typedef struct {
 } tstrHostIFDelAllSta;
 
 /*!
- *  @struct             tstrHostIFDelSta
+ *  @struct             del_sta
  *  @brief		Delete station message body
  *  @details
  *  @todo
@@ -340,10 +340,9 @@ typedef struct {
  *  @date		15 July 2012
  *  @version		1.0 Description
  */
-
-typedef struct {
+struct del_sta {
 	u8 au8MacAddr[ETH_ALEN];
-} tstrHostIFDelSta;
+};
 
 /*!
  *  @struct             timer_cb
@@ -426,7 +425,7 @@ union message_body {
 	struct set_beacon strHostIFSetBeacon;                 /*!< Set beacon message body */
 	struct del_beacon strHostIFDelBeacon;                 /*!< Del beacon message body */
 	struct add_sta_param strAddStaParam;                    /*!< Add station message body */
-	tstrHostIFDelSta strDelStaParam;                                /*!< Del Station message body */
+	struct del_sta strDelStaParam;                                /*!< Del Station message body */
 	struct add_sta_param strEditStaParam;                           /*!< Edit station message body */
 	/* tstrScanComplete		strScanComplete;		/ *Received Async. Scan Complete message body* / */
 	struct timer_cb strTimerCb;                                                 /*!< Timer callback message body */
@@ -3714,13 +3713,14 @@ ERRORHANDLER:
 /**
  *  @brief Handle_DelStation
  *  @details        Sending config packet to delete station
- *  @param[in]   tstrHostIFDelSta* pstrDelStaParam
+ *  @param[in]   struct del_sta *pstrDelStaParam
  *  @return         NONE
  *  @author
  *  @date
  *  @version	1.0
  */
-static void Handle_DelStation(tstrWILC_WFIDrv *drvHandler, tstrHostIFDelSta *pstrDelStaParam)
+static void Handle_DelStation(tstrWILC_WFIDrv *drvHandler,
+			      struct del_sta *pstrDelStaParam)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
@@ -7130,7 +7130,7 @@ s32 host_int_del_station(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8MacAddr)
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	tstrHostIFDelSta *pstrDelStationMsg = &msg.body.strDelStaParam;
+	struct del_sta *pstrDelStationMsg = &msg.body.strDelStaParam;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
-- 
1.9.1

