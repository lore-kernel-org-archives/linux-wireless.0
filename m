Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34721 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbbJBMpb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 08:45:31 -0400
Received: by padhy16 with SMTP id hy16so106196527pad.1
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2015 05:45:30 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 08/10] staging: wilc1000: rename s32Error in host_int_wait_msg_queue_idle
Date: Fri,  2 Oct 2015 21:44:54 +0900
Message-Id: <1443789896-7082-8-git-send-email-chaehyun.lim@gmail.com> (sfid-20151002_144537_659986_B9C2A6C4)
In-Reply-To: <1443789896-7082-1-git-send-email-chaehyun.lim@gmail.com>
References: <1443789896-7082-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces s32Error with result to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index e5b7689..69a4e79 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -5344,7 +5344,7 @@ int host_int_set_mac_chnl_num(tstrWILC_WFIDrv *wfi_drv, u8 channel)
 
 int host_int_wait_msg_queue_idle(void)
 {
-	int s32Error = 0;
+	int result = 0;
 
 	struct host_if_msg msg;
 
@@ -5352,16 +5352,16 @@ int host_int_wait_msg_queue_idle(void)
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_Q_IDLE;
-	s32Error = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
-	if (s32Error) {
+	result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
+	if (result) {
 		PRINT_ER("wilc mq send fail\n");
-		s32Error = -EINVAL;
+		result = -EINVAL;
 	}
 
 	/* wait untill MSG Q is empty */
 	down(&hWaitResponse);
 
-	return s32Error;
+	return result;
 
 }
 
-- 
2.6.0

