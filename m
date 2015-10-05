Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:32775 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbbJECHg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 22:07:36 -0400
Received: by pacex6 with SMTP id ex6so160798749pac.0
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2015 19:07:36 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 3/3] staging: wilc1000: return error code direclty in host_int_wait_msg_queue_idle
Date: Mon,  5 Oct 2015 11:07:23 +0900
Message-Id: <1444010843-16796-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20151005_040739_495681_D2A7AAD4)
In-Reply-To: <1444010843-16796-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444010843-16796-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no need to pass the error code to the variable 'result'.
Just return the error directly when error occurs.
Return 0 at the end of this function when error is not happened.

Suggested-by: Julian Calaby <julian.calaby@gmail.com>
Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b1aa7dd..427fbaa 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -5343,7 +5343,7 @@ int host_int_set_mac_chnl_num(tstrWILC_WFIDrv *wfi_drv, u8 channel)
 
 int host_int_wait_msg_queue_idle(void)
 {
-	int result = 0;
+	int result;
 
 	struct host_if_msg msg;
 
@@ -5354,13 +5354,13 @@ int host_int_wait_msg_queue_idle(void)
 	result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (result) {
 		PRINT_ER("wilc mq send fail\n");
-		result = -EINVAL;
+		return -EINVAL;
 	}
 
 	/* wait untill MSG Q is empty */
 	down(&hWaitResponse);
 
-	return result;
+	return 0;
 }
 
 s32 host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *u32address)
-- 
2.6.0

