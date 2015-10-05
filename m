Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33919 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbbJEKfR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 06:35:17 -0400
Received: by padhy16 with SMTP id hy16so33460845pad.1
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2015 03:35:16 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 03/20] staging: wilc1000: rename s32Error in host_int_set_wfi_drv_handler
Date: Mon,  5 Oct 2015 19:34:47 +0900
Message-Id: <1444041304-7727-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20151005_123525_313050_A24363C5)
In-Reply-To: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces s32Error with result to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index f8206a2..ea618e5 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -5364,7 +5364,7 @@ int host_int_wait_msg_queue_idle(void)
 
 int host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address)
 {
-	int s32Error = 0;
+	int result = 0;
 
 	struct host_if_msg msg;
 
@@ -5375,13 +5375,13 @@ int host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address)
 	msg.body.drv.u32Address = get_id_from_handler(u32address);
 	msg.drvHandler = u32address;
 
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
-	if (s32Error) {
+	result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	if (result) {
 		PRINT_ER("wilc mq send fail\n");
-		s32Error = -EINVAL;
+		result = -EINVAL;
 	}
 
-	return s32Error;
+	return result;
 }
 
 s32 host_int_set_operation_mode(tstrWILC_WFIDrv *hWFIDrv, u32 u32mode)
-- 
2.6.0

