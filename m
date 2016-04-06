Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:34716 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383AbcDFXLJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 19:11:09 -0400
Received: by mail-pa0-f68.google.com with SMTP id hb4so5263529pac.1
        for <linux-wireless@vger.kernel.org>; Wed, 06 Apr 2016 16:11:09 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 2/7] staging: wilc1000: change handle_set_wfi_drv_handler's return type to void
Date: Thu,  7 Apr 2016 08:10:38 +0900
Message-Id: <1459984243-4689-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20160407_011112_561219_A61986D5)
In-Reply-To: <1459984243-4689-1-git-send-email-chaehyun.lim@gmail.com>
References: <1459984243-4689-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When handle_set_wfi_drv_handler is called in hostIFthread that is a
kernel thread, it is not checked return type of this function. This
patch changes return type to void and removes braces if statement due to
have a single statement.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 09e4ca3..ba472d5 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -307,8 +307,8 @@ static void handle_set_channel(struct wilc_vif *vif,
 		netdev_err(vif->ndev, "Failed to set channel\n");
 }
 
-static s32 handle_set_wfi_drv_handler(struct wilc_vif *vif,
-				      struct drv_handler *hif_drv_handler)
+static void handle_set_wfi_drv_handler(struct wilc_vif *vif,
+				       struct drv_handler *hif_drv_handler)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -324,12 +324,8 @@ static s32 handle_set_wfi_drv_handler(struct wilc_vif *vif,
 	if (!hif_drv_handler->handler)
 		complete(&hif_driver_comp);
 
-	if (result) {
+	if (result)
 		netdev_err(vif->ndev, "Failed to set driver handler\n");
-		return -EINVAL;
-	}
-
-	return result;
 }
 
 static s32 handle_set_operation_mode(struct wilc_vif *vif,
-- 
2.8.0

