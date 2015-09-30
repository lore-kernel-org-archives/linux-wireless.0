Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47107 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbbI3J4S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 05:56:18 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 30/32] staging: wilc1000: rename pUserData
Date: Wed, 30 Sep 2015 18:55:12 +0900
Message-ID: <1443606914-25563-8-git-send-email-tony.cho@atmel.com> (sfid-20150930_115625_000340_CF3A588D)
In-Reply-To: <1443606914-25563-1-git-send-email-tony.cho@atmel.com>
References: <1443606914-25563-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pUserData to data to avoid CamelCase naming
convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 79957f9..3769595 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -392,7 +392,7 @@ union message_body {
 	struct ba_session_info session_info;
 	struct remain_ch remain_on_ch;
 	struct reg_frame reg_f;
-	char *pUserData;
+	char *data;
 	struct del_all_sta strHostIFDelAllSta;
 };
 
@@ -4111,7 +4111,7 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_GET_STATISTICS:
-			Handle_GetStatistics(msg.drvHandler, (tstrStatistics *)msg.body.pUserData);
+			Handle_GetStatistics(msg.drvHandler, (tstrStatistics *)msg.body.data);
 			break;
 
 		case HOST_IF_MSG_GET_CHNL:
@@ -5689,7 +5689,7 @@ s32 host_int_get_statistics(tstrWILC_WFIDrv *hWFIDrv, tstrStatistics *pstrStatis
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_GET_STATISTICS;
-	msg.body.pUserData = (char *)pstrStatistics;
+	msg.body.data = (char *)pstrStatistics;
 	msg.drvHandler = hWFIDrv;
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
-- 
1.9.1

