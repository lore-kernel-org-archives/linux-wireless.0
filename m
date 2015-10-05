Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:13346 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbbJEEvD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 00:51:03 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 1/3] staging: wilc1000: rename strHostIfRegisterFrame
Date: Mon, 5 Oct 2015 13:50:44 +0900
Message-ID: <1444020646-3000-1-git-send-email-tony.cho@atmel.com> (sfid-20151005_065107_801896_F411F7D7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames strHostIfRegisterFrame to reg_frame to avoid
CamelCase naming convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
V2:
 rename strHostIfRegisterFrame to reg_frame instead of reg_f because it is
 ambiguous
---
 drivers/staging/wilc1000/host_interface.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 39d72ac..dd65edb 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -385,7 +385,7 @@ union message_body {
 	struct get_mac_addr get_mac_info;
 	struct ba_session_info session_info;
 	struct remain_ch remain_on_ch;
-	struct reg_frame strHostIfRegisterFrame;
+	struct reg_frame reg_frame;
 	char *pUserData;
 	struct del_all_sta strHostIFDelAllSta;
 };
@@ -4185,7 +4185,7 @@ static int hostIFthread(void *pvArg)
 
 		case HOST_IF_MSG_REGISTER_FRAME:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_REGISTER_FRAME\n");
-			Handle_RegisterFrame(msg.drvHandler, &msg.body.strHostIfRegisterFrame);
+			Handle_RegisterFrame(msg.drvHandler, &msg.body.reg_frame);
 			break;
 
 		case HOST_IF_MSG_LISTEN_TIMER_FIRED:
@@ -6482,20 +6482,20 @@ s32 host_int_frame_register(tstrWILC_WFIDrv *hWFIDrv, u16 u16FrameType, bool bRe
 	switch (u16FrameType) {
 	case ACTION:
 		PRINT_D(HOSTINF_DBG, "ACTION\n");
-		msg.body.strHostIfRegisterFrame.u8Regid = ACTION_FRM_IDX;
+		msg.body.reg_frame.u8Regid = ACTION_FRM_IDX;
 		break;
 
 	case PROBE_REQ:
 		PRINT_D(HOSTINF_DBG, "PROBE REQ\n");
-		msg.body.strHostIfRegisterFrame.u8Regid = PROBE_REQ_IDX;
+		msg.body.reg_frame.u8Regid = PROBE_REQ_IDX;
 		break;
 
 	default:
 		PRINT_D(HOSTINF_DBG, "Not valid frame type\n");
 		break;
 	}
-	msg.body.strHostIfRegisterFrame.u16FrameType = u16FrameType;
-	msg.body.strHostIfRegisterFrame.bReg = bReg;
+	msg.body.reg_frame.u16FrameType = u16FrameType;
+	msg.body.reg_frame.bReg = bReg;
 	msg.drvHandler = hWFIDrv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
-- 
1.9.1

