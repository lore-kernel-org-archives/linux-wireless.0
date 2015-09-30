Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:14142 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbbI3JtO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 05:49:14 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 16/32] staging: wilc1000: rename strDelStaParam
Date: Wed, 30 Sep 2015 18:44:33 +0900
Message-ID: <1443606289-25407-16-git-send-email-tony.cho@atmel.com> (sfid-20150930_121654_630868_52C5B7DB)
In-Reply-To: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
References: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames strDelStaParam to del_sta_info to avoid CamelCase
naming convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d9d0b2d..94559bd 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -393,7 +393,7 @@ union message_body {
 	struct channel_attr channel_info;
 	struct beacon_attr beacon_info;
 	struct add_sta_param add_sta_info;
-	struct del_sta strDelStaParam;
+	struct del_sta del_sta_info;
 	struct add_sta_param strEditStaParam;
 	struct timer_cb strTimerCb;
 	struct power_mgmt_param strPowerMgmtparam;
@@ -4146,7 +4146,7 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_DEL_STATION:
-			Handle_DelStation(msg.drvHandler, &msg.body.strDelStaParam);
+			Handle_DelStation(msg.drvHandler, &msg.body.del_sta_info);
 			break;
 
 		case HOST_IF_MSG_EDIT_STATION:
@@ -6700,7 +6700,7 @@ s32 host_int_del_station(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8MacAddr)
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	struct del_sta *pstrDelStationMsg = &msg.body.strDelStaParam;
+	struct del_sta *pstrDelStationMsg = &msg.body.del_sta_info;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
-- 
1.9.1

