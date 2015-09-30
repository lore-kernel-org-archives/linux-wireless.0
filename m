Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:14106 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbbI3JtB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 05:49:01 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 14/32] staging: wilc1000: rename strHostIFSetBeacon
Date: Wed, 30 Sep 2015 18:44:31 +0900
Message-ID: <1443606289-25407-14-git-send-email-tony.cho@atmel.com> (sfid-20150930_114904_207827_9479F936)
In-Reply-To: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
References: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames strHostIFSetBeacon to beacon_info to avoid CamelCase
naming convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 2f211f9..7e53aa9 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -391,7 +391,7 @@ union message_body {
 	struct key_attr key_info;
 	struct cfg_param_attr cfg_info;
 	struct channel_attr channel_info;
-	struct beacon_attr strHostIFSetBeacon;
+	struct beacon_attr beacon_info;
 	struct add_sta_param strAddStaParam;
 	struct del_sta strDelStaParam;
 	struct add_sta_param strEditStaParam;
@@ -4134,7 +4134,7 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_ADD_BEACON:
-			Handle_AddBeacon(msg.drvHandler, &msg.body.strHostIFSetBeacon);
+			Handle_AddBeacon(msg.drvHandler, &msg.body.beacon_info);
 			break;
 
 		case HOST_IF_MSG_DEL_BEACON:
@@ -6548,7 +6548,7 @@ s32 host_int_add_beacon(tstrWILC_WFIDrv *hWFIDrv, u32 u32Interval,
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
 	struct host_if_msg msg;
-	struct beacon_attr *pstrSetBeaconParam = &msg.body.strHostIFSetBeacon;
+	struct beacon_attr *pstrSetBeaconParam = &msg.body.beacon_info;
 
 	if (pstrWFIDrv == NULL) {
 		PRINT_ER("driver is null\n");
-- 
1.9.1

