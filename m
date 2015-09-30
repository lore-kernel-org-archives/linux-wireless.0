Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:14086 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106AbbI3Jsy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 05:48:54 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 13/32] staging: wilc1000: rename struct set_beacon
Date: Wed, 30 Sep 2015 18:44:30 +0900
Message-ID: <1443606289-25407-13-git-send-email-tony.cho@atmel.com> (sfid-20150930_114857_330604_235BB85A)
In-Reply-To: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
References: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames struct set_beacon to beacon_attr to keep the naming
convention as scan_attr, connect_attr and channel_attr.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 686402a9..2f211f9 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -248,7 +248,7 @@ struct channel_attr {
  * } tstrScanComplete;*/
 
 /*!
- *  @struct             set_beacon
+ *  @struct             beacon_attr
  *  @brief		Set Beacon  message body
  *  @details
  *  @todo
@@ -257,7 +257,7 @@ struct channel_attr {
  *  @date		10 July 2012
  *  @version		1.0
  */
-struct set_beacon {
+struct beacon_attr {
 	u32 u32Interval;                        /*!< Beacon Interval. Period between two successive beacons on air  */
 	u32 u32DTIMPeriod;              /*!< DTIM Period. Indicates how many Beacon frames
 											*                              (including the current frame) appear before the next DTIM		*/
@@ -391,7 +391,7 @@ union message_body {
 	struct key_attr key_info;
 	struct cfg_param_attr cfg_info;
 	struct channel_attr channel_info;
-	struct set_beacon strHostIFSetBeacon;
+	struct beacon_attr strHostIFSetBeacon;
 	struct add_sta_param strAddStaParam;
 	struct del_sta strDelStaParam;
 	struct add_sta_param strEditStaParam;
@@ -3158,14 +3158,14 @@ static s32 Handle_Get_InActiveTime(tstrWILC_WFIDrv *drvHandler,
 /**
  *  @brief Handle_AddBeacon
  *  @details       Sending config packet to add beacon
- *  @param[in]    struct set_beacon *pstrSetBeaconParam
+ *  @param[in]    struct beacon_attr *pstrSetBeaconParam
  *  @return         NONE
  *  @author
  *  @date
  *  @version	1.0
  */
 static void Handle_AddBeacon(tstrWILC_WFIDrv *drvHandler,
-			     struct set_beacon *pstrSetBeaconParam)
+			     struct beacon_attr *pstrSetBeaconParam)
 {
 	s32 s32Error = 0;
 	tstrWID strWID;
@@ -6548,7 +6548,7 @@ s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	struct set_beacon *pstrSetBeaconParam = &msg.body.strHostIFSetBeacon;
+	struct beacon_attr *pstrSetBeaconParam = &msg.body.strHostIFSetBeacon;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
-- 
1.9.1

