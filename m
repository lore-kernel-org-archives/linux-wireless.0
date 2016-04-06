Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33996 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405AbcDFXLM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 19:11:12 -0400
Received: by mail-pf0-f196.google.com with SMTP id d184so5489669pfc.1
        for <linux-wireless@vger.kernel.org>; Wed, 06 Apr 2016 16:11:12 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 3/7] staging: wilc1000: change data type of result in handle_set_wfi_drv_handler
Date: Thu,  7 Apr 2016 08:10:39 +0900
Message-Id: <1459984243-4689-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20160407_011116_240730_04E0EA77)
In-Reply-To: <1459984243-4689-1-git-send-email-chaehyun.lim@gmail.com>
References: <1459984243-4689-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes data type of result variable from s32 to int.
result is used to get return value from wilc_send_config_pkt that has
return type of int.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index ba472d5..33735fd 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -310,7 +310,7 @@ static void handle_set_channel(struct wilc_vif *vif,
 static void handle_set_wfi_drv_handler(struct wilc_vif *vif,
 				       struct drv_handler *hif_drv_handler)
 {
-	s32 result = 0;
+	int result = 0;
 	struct wid wid;
 
 	wid.id = (u16)WID_SET_DRV_HANDLER;
-- 
2.8.0

