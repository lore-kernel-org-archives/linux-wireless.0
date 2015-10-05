Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36342 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbbJEKfX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 06:35:23 -0400
Received: by pablk4 with SMTP id lk4so172800062pab.3
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2015 03:35:23 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 05/20] staging: wilc1000: fix return type of host_int_set_operation_mode
Date: Mon,  5 Oct 2015 19:34:49 +0900
Message-Id: <1444041304-7727-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20151005_123528_143162_8B446991)
In-Reply-To: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of host_int_set_operation_mode from s32
to int. s32Error gets return value from wilc_mq_send that has return
type of int. It should be changed return type by int as well as data
type of s32Error.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 7c617f7..092ecf5 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -5384,9 +5384,9 @@ int host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *address)
 	return result;
 }
 
-s32 host_int_set_operation_mode(tstrWILC_WFIDrv *hWFIDrv, u32 u32mode)
+int host_int_set_operation_mode(tstrWILC_WFIDrv *hWFIDrv, u32 u32mode)
 {
-	s32 s32Error = 0;
+	int s32Error = 0;
 
 	struct host_if_msg msg;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 341c2f3..e9db06c 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -1187,7 +1187,7 @@ s32 host_int_frame_register(tstrWILC_WFIDrv *hWFIDrv, u16 u16FrameType, bool bRe
  *  @version	1.0
  */
 int host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *address);
-s32 host_int_set_operation_mode(tstrWILC_WFIDrv *hWFIDrv, u32 u32mode);
+int host_int_set_operation_mode(tstrWILC_WFIDrv *hWFIDrv, u32 u32mode);
 
 static s32 Handle_ScanDone(tstrWILC_WFIDrv *drvHandler, tenuScanEvent enuEvent);
 
-- 
2.6.0

