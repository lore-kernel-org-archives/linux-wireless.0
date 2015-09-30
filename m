Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:14129 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579AbbI3JtI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 05:49:08 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 15/32] staging: wilc1000: rename strAddStaParam
Date: Wed, 30 Sep 2015 18:44:32 +0900
Message-ID: <1443606289-25407-15-git-send-email-tony.cho@atmel.com> (sfid-20150930_121654_026687_A2401BC1)
In-Reply-To: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
References: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames strAddStaParam to add_sta_info to avoid CamelCase
naming convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 7e53aa9..d9d0b2d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -392,7 +392,7 @@ union message_body {
 	struct cfg_param_attr cfg_info;
 	struct channel_attr channel_info;
 	struct beacon_attr beacon_info;
-	struct add_sta_param strAddStaParam;
+	struct add_sta_param add_sta_info;
 	struct del_sta strDelStaParam;
 	struct add_sta_param strEditStaParam;
 	struct timer_cb strTimerCb;
@@ -4142,7 +4142,7 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_ADD_STATION:
-			Handle_AddStation(msg.drvHandler, &msg.body.strAddStaParam);
+			Handle_AddStation(msg.drvHandler, &msg.body.add_sta_info);
 			break;
 
 		case HOST_IF_MSG_DEL_STATION:
@@ -6651,7 +6651,7 @@ s32 host_int_add_station(tstrWILC_WFIDrv *hWFIDrv,
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	struct add_sta_param *pstrAddStationMsg = &msg.body.strAddStaParam;
+	struct add_sta_param *pstrAddStationMsg = &msg.body.add_sta_info;
 
 
 	if (pstrWFIDrv == NULL) {
@@ -6802,7 +6802,7 @@ s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv,
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	struct add_sta_param *pstrAddStationMsg = &msg.body.strAddStaParam;
+	struct add_sta_param *pstrAddStationMsg = &msg.body.add_sta_info;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
-- 
1.9.1

