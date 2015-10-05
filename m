Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:34942 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbbJEKfa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 06:35:30 -0400
Received: by pacfv12 with SMTP id fv12so177133329pac.2
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2015 03:35:29 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 07/20] staging: wilc1000: rename hWFIDrv in host_int_set_operation_mode
Date: Mon,  5 Oct 2015 19:34:51 +0900
Message-Id: <1444041304-7727-7-git-send-email-chaehyun.lim@gmail.com> (sfid-20151005_123532_818946_F8308EBD)
In-Reply-To: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces hWFIDrv with wfi_drv that is first argument of
host_int_set_operation_mode to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 7855b85..33563cc 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -5384,7 +5384,7 @@ int host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *address)
 	return result;
 }
 
-int host_int_set_operation_mode(tstrWILC_WFIDrv *hWFIDrv, u32 u32mode)
+int host_int_set_operation_mode(tstrWILC_WFIDrv *wfi_drv, u32 u32mode)
 {
 	int result = 0;
 
@@ -5396,7 +5396,7 @@ int host_int_set_operation_mode(tstrWILC_WFIDrv *hWFIDrv, u32 u32mode)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_OPERATION_MODE;
 	msg.body.mode.u32Mode = u32mode;
-	msg.drvHandler = hWFIDrv;
+	msg.drvHandler = wfi_drv;
 
 	result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (result) {
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index e9db06c..890644a 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -1187,7 +1187,7 @@ s32 host_int_frame_register(tstrWILC_WFIDrv *hWFIDrv, u16 u16FrameType, bool bRe
  *  @version	1.0
  */
 int host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *address);
-int host_int_set_operation_mode(tstrWILC_WFIDrv *hWFIDrv, u32 u32mode);
+int host_int_set_operation_mode(tstrWILC_WFIDrv *wfi_drv, u32 u32mode);
 
 static s32 Handle_ScanDone(tstrWILC_WFIDrv *drvHandler, tenuScanEvent enuEvent);
 
-- 
2.6.0

