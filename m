Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:47087 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbbI3J4M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 05:56:12 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 29/32] staging: wilc1000: rename strHostIfRegisterFrame
Date: Wed, 30 Sep 2015 18:55:11 +0900
Message-ID: <1443606914-25563-7-git-send-email-tony.cho@atmel.com> (sfid-20150930_115624_399992_038AA8C3)
In-Reply-To: <1443606914-25563-1-git-send-email-tony.cho@atmel.com>
References: <1443606914-25563-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames strHostIfRegisterFrame to reg_f to avoid CamelCase
naming convention.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 9dac906..79957f9 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -391,7 +391,7 @@ union message_body {
 	struct get_mac_addr get_mac_info;
 	struct ba_session_info session_info;
 	struct remain_ch remain_on_ch;
-	struct reg_frame strHostIfRegisterFrame;
+	struct reg_frame reg_f;
 	char *pUserData;
 	struct del_all_sta strHostIFDelAllSta;
 };
@@ -4191,7 +4191,7 @@ static int hostIFthread(void *pvArg)
 
 		case HOST_IF_MSG_REGISTER_FRAME:
 			PRINT_D(HOSTINF_DBG, "HOST_IF_MSG_REGISTER_FRAME\n");
-			Handle_RegisterFrame(msg.drvHandler, &msg.body.strHostIfRegisterFrame);
+			Handle_RegisterFrame(msg.drvHandler, &msg.body.reg_f);
 			break;
 
 		case HOST_IF_MSG_LISTEN_TIMER_FIRED:
@@ -6489,20 +6489,20 @@ s32 host_int_frame_register(tstrWILC_WFIDrv *hWFIDrv, u16 u16FrameType, bool bRe
 	switch (u16FrameType) {
 	case ACTION:
 		PRINT_D(HOSTINF_DBG, "ACTION\n");
-		msg.body.strHostIfRegisterFrame.u8Regid = ACTION_FRM_IDX;
+		msg.body.reg_f.u8Regid = ACTION_FRM_IDX;
 		break;
 
 	case PROBE_REQ:
 		PRINT_D(HOSTINF_DBG, "PROBE REQ\n");
-		msg.body.strHostIfRegisterFrame.u8Regid = PROBE_REQ_IDX;
+		msg.body.reg_f.u8Regid = PROBE_REQ_IDX;
 		break;
 
 	default:
 		PRINT_D(HOSTINF_DBG, "Not valid frame type\n");
 		break;
 	}
-	msg.body.strHostIfRegisterFrame.u16FrameType = u16FrameType;
-	msg.body.strHostIfRegisterFrame.bReg = bReg;
+	msg.body.reg_f.u16FrameType = u16FrameType;
+	msg.body.reg_f.bReg = bReg;
 	msg.drvHandler = hWFIDrv;
 
 	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
-- 
1.9.1

