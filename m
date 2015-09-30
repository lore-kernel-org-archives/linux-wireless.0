Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47042 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbbI3J4C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 05:56:02 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 28/32] staging: wilc1000: rename strHostIfRemainOnChan
Date: Wed, 30 Sep 2015 18:55:10 +0900
Message-ID: <1443606914-25563-6-git-send-email-tony.cho@atmel.com> (sfid-20150930_115609_998549_AB89A2E3)
In-Reply-To: <1443606914-25563-1-git-send-email-tony.cho@atmel.com>
References: <1443606914-25563-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames strHostIfRemainOnChan to remain_on_ch to avoid
CamelCase naming convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b7797a5..9dac906 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -390,7 +390,7 @@ union message_body {
 	struct set_mac_addr set_mac_info;
 	struct get_mac_addr get_mac_info;
 	struct ba_session_info session_info;
-	struct remain_ch strHostIfRemainOnChan;
+	struct remain_ch remain_on_ch;
 	struct reg_frame strHostIfRegisterFrame;
 	char *pUserData;
 	struct del_all_sta strHostIFDelAllSta;
@@ -3693,7 +3693,7 @@ static void ListenTimerCB(unsigned long arg)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_LISTEN_TIMER_FIRED;
 	msg.drvHandler = pstrWFIDrv;
-	msg.body.strHostIfRemainOnChan.u32ListenSessionID = pstrWFIDrv->strHostIfRemainOnChan.u32ListenSessionID;
+	msg.body.remain_on_ch.u32ListenSessionID = pstrWFIDrv->strHostIfRemainOnChan.u32ListenSessionID;
 
 	/* send the message */
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -4098,7 +4098,7 @@ static int hostIFthread(void *pvArg)
 			Handle_ScanDone(msg.drvHandler, SCAN_EVENT_DONE);
 
 			if (pstrWFIDrv->u8RemainOnChan_pendingreq)
-				Handle_RemainOnChan(msg.drvHandler, &msg.body.strHostIfRemainOnChan);
+				Handle_RemainOnChan(msg.drvHandler, &msg.body.remain_on_ch);
 
 			break;
 
@@ -4186,7 +4186,7 @@ static int hostIFthread(void *pvArg)
 
 		case HOST_IF_MSG_REMAIN_ON_CHAN:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_REMAIN_ON_CHAN\n");
-			Handle_RemainOnChan(msg.drvHandler, &msg.body.strHostIfRemainOnChan);
+			Handle_RemainOnChan(msg.drvHandler, &msg.body.remain_on_ch);
 			break;
 
 		case HOST_IF_MSG_REGISTER_FRAME:
@@ -4195,7 +4195,7 @@ static int hostIFthread(void *pvArg)
 			break;
 
 		case HOST_IF_MSG_LISTEN_TIMER_FIRED:
-			Handle_ListenStateExpired(msg.drvHandler, &msg.body.strHostIfRemainOnChan);
+			Handle_ListenStateExpired(msg.drvHandler, &msg.body.remain_on_ch);
 			break;
 
 		case HOST_IF_MSG_SET_MULTICAST_FILTER:
@@ -6407,12 +6407,12 @@ s32 host_int_remain_on_channel(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID, u32 u
 
 	/* prepare the WiphyParams Message */
 	msg.id = HOST_IF_MSG_REMAIN_ON_CHAN;
-	msg.body.strHostIfRemainOnChan.u16Channel = chan;
-	msg.body.strHostIfRemainOnChan.pRemainOnChanExpired = RemainOnChanExpired;
-	msg.body.strHostIfRemainOnChan.pRemainOnChanReady = RemainOnChanReady;
-	msg.body.strHostIfRemainOnChan.pVoid = pvUserArg;
-	msg.body.strHostIfRemainOnChan.u32duration = u32duration;
-	msg.body.strHostIfRemainOnChan.u32ListenSessionID = u32SessionID;
+	msg.body.remain_on_ch.u16Channel = chan;
+	msg.body.remain_on_ch.pRemainOnChanExpired = RemainOnChanExpired;
+	msg.body.remain_on_ch.pRemainOnChanReady = RemainOnChanReady;
+	msg.body.remain_on_ch.pVoid = pvUserArg;
+	msg.body.remain_on_ch.u32duration = u32duration;
+	msg.body.remain_on_ch.u32ListenSessionID = u32SessionID;
 	msg.drvHandler = hWFIDrv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
@@ -6454,7 +6454,7 @@ s32 host_int_ListenStateExpired(tstrWILC_WFIDrv *hWFIDrv, u32 u32SessionID)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_LISTEN_TIMER_FIRED;
 	msg.drvHandler = hWFIDrv;
-	msg.body.strHostIfRemainOnChan.u32ListenSessionID = u32SessionID;
+	msg.body.remain_on_ch.u32ListenSessionID = u32SessionID;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (s32Error)
-- 
1.9.1

