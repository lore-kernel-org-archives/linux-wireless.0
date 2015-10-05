Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36521 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbbJEKfd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 06:35:33 -0400
Received: by pablk4 with SMTP id lk4so172804182pab.3
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2015 03:35:32 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 08/20] staging: wilc1000: rename u32mode in host_int_set_operation_mode
Date: Mon,  5 Oct 2015 19:34:52 +0900
Message-Id: <1444041304-7727-8-git-send-email-chaehyun.lim@gmail.com> (sfid-20151005_123535_898121_9AFD1551)
In-Reply-To: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces u32mode with mode that is second argument of
host_int_set_operation_mode to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 33563cc..998c644 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -5384,7 +5384,7 @@ int host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *address)
 	return result;
 }
 
-int host_int_set_operation_mode(tstrWILC_WFIDrv *wfi_drv, u32 u32mode)
+int host_int_set_operation_mode(tstrWILC_WFIDrv *wfi_drv, u32 mode)
 {
 	int result = 0;
 
@@ -5395,7 +5395,7 @@ int host_int_set_operation_mode(tstrWILC_WFIDrv *wfi_drv, u32 u32mode)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_OPERATION_MODE;
-	msg.body.mode.u32Mode = u32mode;
+	msg.body.mode.u32Mode = mode;
 	msg.drvHandler = wfi_drv;
 
 	result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 890644a..8f77ccb 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -1187,7 +1187,7 @@ s32 host_int_frame_register(tstrWILC_WFIDrv *hWFIDrv, u16 u16FrameType, bool bRe
  *  @version	1.0
  */
 int host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *address);
-int host_int_set_operation_mode(tstrWILC_WFIDrv *wfi_drv, u32 u32mode);
+int host_int_set_operation_mode(tstrWILC_WFIDrv *wfi_drv, u32 mode);
 
 static s32 Handle_ScanDone(tstrWILC_WFIDrv *drvHandler, tenuScanEvent enuEvent);
 
-- 
2.6.0

