Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:33851 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbbJEKf0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 06:35:26 -0400
Received: by pablk4 with SMTP id lk4so21485265pab.1
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2015 03:35:26 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 06/20] staging: wilc1000: rename s32Error in host_int_set_operation_mode
Date: Mon,  5 Oct 2015 19:34:50 +0900
Message-Id: <1444041304-7727-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20151005_123530_336190_69875B90)
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
index 092ecf5..7855b85 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -5386,7 +5386,7 @@ int host_int_set_wfi_drv_handler(tstrWILC_WFIDrv *address)
 
 int host_int_set_operation_mode(tstrWILC_WFIDrv *hWFIDrv, u32 u32mode)
 {
-	int s32Error = 0;
+	int result = 0;
 
 	struct host_if_msg msg;
 
@@ -5398,13 +5398,13 @@ int host_int_set_operation_mode(tstrWILC_WFIDrv *hWFIDrv, u32 u32mode)
 	msg.body.mode.u32Mode = u32mode;
 	msg.drvHandler = hWFIDrv;
 
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
 
 /**
-- 
2.6.0

