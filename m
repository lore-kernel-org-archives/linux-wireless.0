Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36114 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbbJEKfK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 06:35:10 -0400
Received: by pablk4 with SMTP id lk4so172794660pab.3
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2015 03:35:10 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 01/20] staging: wilc1000: fix return type of host_int_set_wfi_drv_handler
Date: Mon,  5 Oct 2015 19:34:45 +0900
Message-Id: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20151005_123514_789178_CB027908)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of host_int_set_wfi_drv_handler from s32
to int. s32Error gets return value from wilc_mq_send that has return
type of int. It should be changed return type by int as well as data
type of s32Error.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b1aa7dd..038923d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -5363,9 +5363,9 @@ int host_int_wait_msg_queue_idle(void)
 	return result;
 }
 
-s32 host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address)
+int host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address)
 {
-	s32 s32Error = 0;
+	int s32Error = 0;
 
 	struct host_if_msg msg;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index bc8acde..123c508 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -1186,7 +1186,7 @@ s32 host_int_frame_register(tstrWILC_WFIDrv *hWFIDrv, u16 u16FrameType, bool bRe
  *  @date
  *  @version	1.0
  */
-s32 host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address);
+int host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address);
 s32 host_int_set_operation_mode(tstrWILC_WFIDrv *hWFIDrv, u32 u32mode);
 
 static s32 Handle_ScanDone(tstrWILC_WFIDrv *drvHandler, tenuScanEvent enuEvent);
-- 
2.6.0

