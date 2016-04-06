Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:34764 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474AbcDFXLV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 19:11:21 -0400
Received: by mail-pa0-f66.google.com with SMTP id hb4so5263878pac.1
        for <linux-wireless@vger.kernel.org>; Wed, 06 Apr 2016 16:11:21 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 6/7] staging: wilc1000: change data type of result in handle_set_operation_mode
Date: Thu,  7 Apr 2016 08:10:42 +0900
Message-Id: <1459984243-4689-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20160407_011124_614143_3AADE41B)
In-Reply-To: <1459984243-4689-1-git-send-email-chaehyun.lim@gmail.com>
References: <1459984243-4689-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes data type of result variable from s32 to int. result
is used to get return value from wilc_send_config_pkt that has return
type of int.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index ecf4ddc..52eddc4 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -331,7 +331,7 @@ static void handle_set_wfi_drv_handler(struct wilc_vif *vif,
 static void handle_set_operation_mode(struct wilc_vif *vif,
 				      struct op_mode *hif_op_mode)
 {
-	s32 result = 0;
+	int result = 0;
 	struct wid wid;
 
 	wid.id = (u16)WID_SET_OPERATION_MODE;
-- 
2.8.0

