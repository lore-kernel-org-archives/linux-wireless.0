Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:14045 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021AbbI3Jsl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 05:48:41 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 11/32] staging: wilc1000: rename strHostIFSetChan
Date: Wed, 30 Sep 2015 18:44:28 +0900
Message-ID: <1443606289-25407-11-git-send-email-tony.cho@atmel.com> (sfid-20150930_114843_995003_B98F01CA)
In-Reply-To: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
References: <1443606289-25407-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames strHostIFSetChan to channel_info to avoid CamelCase
naming convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index e66118a..4559ed5 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -406,7 +406,7 @@ union message_body {
 	struct rcvd_async_info async_info;
 	struct key_attr key_info;
 	struct cfg_param_attr cfg_info;
-	struct channel_attr strHostIFSetChan;
+	struct channel_attr channel_info;
 	struct set_beacon strHostIFSetBeacon;
 	struct del_beacon strHostIFDelBeacon;
 	struct add_sta_param strAddStaParam;
@@ -4113,7 +4113,7 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_SET_CHANNEL:
-			Handle_SetChannel(msg.drvHandler, &msg.body.strHostIFSetChan);
+			Handle_SetChannel(msg.drvHandler, &msg.body.channel_info);
 			break;
 
 		case HOST_IF_MSG_DISCONNECT:
@@ -5368,7 +5368,7 @@ s32 host_int_set_mac_chnl_num(tstrWILC_WFIDrv *hWFIDrv, u8 u8ChNum)
 	/* prepare the set channel message */
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_CHANNEL;
-	msg.body.strHostIFSetChan.u8SetChan = u8ChNum;
+	msg.body.channel_info.u8SetChan = u8ChNum;
 	msg.drvHandler = hWFIDrv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
-- 
1.9.1

