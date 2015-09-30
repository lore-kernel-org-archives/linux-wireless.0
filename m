Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:14062 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbbI3Jsr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 05:48:47 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 12/32] staging: wilc1000: remove struct del_beacon
Date: Wed, 30 Sep 2015 18:44:29 +0900
Message-ID: <1443606289-25407-12-git-send-email-tony.cho@atmel.com> (sfid-20150930_114850_453512_FC34615D)
In-Reply-To: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
References: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes struct del_beacon which is not necessary. This patch
also changes Handle_DelBeacon function by removing 2nd parameter, struct
del_beacon because it is not used inside.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 4559ed5..686402a9 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -269,22 +269,6 @@ struct set_beacon {
 											*                              after the TIM inormation element	*/
 };
 
-
-
-/*!
- *  @struct             del_beacon
- *  @brief		Del Beacon  message body
- *  @details
- *  @todo
- *  @sa
- *  @author		Adham Abozaeid
- *  @date		15 July 2012
- *  @version		1.0
- */
-struct del_beacon {
-	u8 u8dummy;
-};
-
 /*!
  *  @struct             set_multicast
  *  @brief		set Multicast filter Address
@@ -408,7 +392,6 @@ union message_body {
 	struct cfg_param_attr cfg_info;
 	struct channel_attr channel_info;
 	struct set_beacon strHostIFSetBeacon;
-	struct del_beacon strHostIFDelBeacon;
 	struct add_sta_param strAddStaParam;
 	struct del_sta strDelStaParam;
 	struct add_sta_param strEditStaParam;
@@ -3244,14 +3227,13 @@ ERRORHANDLER:
 /**
  *  @brief Handle_AddBeacon
  *  @details       Sending config packet to delete beacon
- *  @param[in]   struct del_beacon *pstrDelBeacon
+ *  @param[in]	tstrWILC_WFIDrv *drvHandler
  *  @return         NONE
  *  @author
  *  @date
  *  @version	1.0
  */
-static void Handle_DelBeacon(tstrWILC_WFIDrv *drvHandler,
-			     struct del_beacon *pstrDelBeacon)
+static void Handle_DelBeacon(tstrWILC_WFIDrv *drvHandler)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
@@ -4156,7 +4138,7 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_DEL_BEACON:
-			Handle_DelBeacon(msg.drvHandler, &msg.body.strHostIFDelBeacon);
+			Handle_DelBeacon(msg.drvHandler);
 			break;
 
 		case HOST_IF_MSG_ADD_STATION:
-- 
1.9.1

