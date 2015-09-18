Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:45348 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbbIRJN2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 05:13:28 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 15/34] staging: wilc1000: remove typedef from the struct tstrHostIFSetBeacon
Date: Fri, 18 Sep 2015 18:11:17 +0900
Message-ID: <1442567496-29331-15-git-send-email-tony.cho@atmel.com> (sfid-20150918_111654_561887_ED230F38)
In-Reply-To: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
References: <1442567496-29331-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes typedef from the struct tstrHostIFSetBeacon and
renames it to set_beacon in order to comply with the Linux coding style.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 58f138b..06091da 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -261,7 +261,7 @@ struct get_channel {
  * } tstrScanComplete;*/
 
 /*!
- *  @struct             tstrHostIFSetBeacon
+ *  @struct             set_beacon
  *  @brief		Set Beacon  message body
  *  @details
  *  @todo
@@ -270,7 +270,7 @@ struct get_channel {
  *  @date		10 July 2012
  *  @version		1.0
  */
-typedef struct _tstrHostIFSetBeacon {
+struct set_beacon {
 	u32 u32Interval;                        /*!< Beacon Interval. Period between two successive beacons on air  */
 	u32 u32DTIMPeriod;              /*!< DTIM Period. Indicates how many Beacon frames
 											*                              (including the current frame) appear before the next DTIM		*/
@@ -280,7 +280,7 @@ typedef struct _tstrHostIFSetBeacon {
 	u32 u32TailLen;                         /*!< Length of the tail buffer in bytes	*/
 	u8 *pu8Tail;                    /*!< Pointer to the beacon's tail buffer. Beacon's tail	starts just
 											*                              after the TIM inormation element	*/
-} tstrHostIFSetBeacon;
+};
 
 
 
@@ -425,7 +425,7 @@ union message_body {
 	struct cfg_param_attr strHostIFCfgParamAttr;            /*! <CFG Parameter message Body> */
 	struct set_channel strHostIFSetChan;
 	struct get_channel strHostIFGetChan;
-	tstrHostIFSetBeacon strHostIFSetBeacon;                 /*!< Set beacon message body */
+	struct set_beacon strHostIFSetBeacon;                 /*!< Set beacon message body */
 	tstrHostIFDelBeacon strHostIFDelBeacon;                 /*!< Del beacon message body */
 	tstrWILC_AddStaParam strAddStaParam;                    /*!< Add station message body */
 	tstrHostIFDelSta strDelStaParam;                                /*!< Del Station message body */
@@ -3453,13 +3453,14 @@ static s32 Handle_Get_InActiveTime(tstrWILC_WFIDrv *drvHandler, tstrHostIfStaIna
 /**
  *  @brief Handle_AddBeacon
  *  @details       Sending config packet to add beacon
- *  @param[in]    tstrHostIFSetBeacon* pstrSetBeaconParam
+ *  @param[in]    struct set_beacon *pstrSetBeaconParam
  *  @return         NONE
  *  @author
  *  @date
  *  @version	1.0
  */
-static void Handle_AddBeacon(tstrWILC_WFIDrv *drvHandler, tstrHostIFSetBeacon *pstrSetBeaconParam)
+static void Handle_AddBeacon(tstrWILC_WFIDrv *drvHandler,
+			     struct set_beacon *pstrSetBeaconParam)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
@@ -6964,7 +6965,7 @@ s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	tstrHostIFSetBeacon *pstrSetBeaconParam = &msg.body.strHostIFSetBeacon;
+	struct set_beacon *pstrSetBeaconParam = &msg.body.strHostIFSetBeacon;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
-- 
1.9.1

