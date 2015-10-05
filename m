Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35791 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044AbbJEKfU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 06:35:20 -0400
Received: by pacfv12 with SMTP id fv12so177129291pac.2
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2015 03:35:19 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 04/20] staging: wilc1000: rename u32address in host_int_set_wfi_drv_handler
Date: Mon,  5 Oct 2015 19:34:48 +0900
Message-Id: <1444041304-7727-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20151005_123720_643523_6D71AD14)
In-Reply-To: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces u32address with address to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index ea618e5..7c617f7 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -5362,7 +5362,7 @@ int host_int_wait_msg_queue_idle(void)
 	return result;
 }
 
-int host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address)
+int host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *address)
 {
 	int result = 0;
 
@@ -5372,8 +5372,8 @@ int host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_SET_WFIDRV_HANDLER;
-	msg.body.drv.u32Address = get_id_from_handler(u32address);
-	msg.drvHandler = u32address;
+	msg.body.drv.u32Address = get_id_from_handler(address);
+	msg.drvHandler = address;
 
 	result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (result) {
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 123c508..341c2f3 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -1186,7 +1186,7 @@ s32 host_int_frame_register(tstrWILC_WFIDrv *hWFIDrv, u16 u16FrameType, bool bRe
  *  @date
  *  @version	1.0
  */
-int host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address);
+int host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *address);
 s32 host_int_set_operation_mode(tstrWILC_WFIDrv *hWFIDrv, u32 u32mode);
 
 static s32 Handle_ScanDone(tstrWILC_WFIDrv *drvHandler, tenuScanEvent enuEvent);
-- 
2.6.0

