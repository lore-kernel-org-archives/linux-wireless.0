Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:35935 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474AbcDFXLP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 19:11:15 -0400
Received: by mail-pa0-f67.google.com with SMTP id k3so1538385pav.3
        for <linux-wireless@vger.kernel.org>; Wed, 06 Apr 2016 16:11:15 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 4/7] staging: wilc1000: rename result in handle_set_wfi_drv_handler
Date: Thu,  7 Apr 2016 08:10:40 +0900
Message-Id: <1459984243-4689-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20160407_011118_435313_E5B4A604)
In-Reply-To: <1459984243-4689-1-git-send-email-chaehyun.lim@gmail.com>
References: <1459984243-4689-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames result to ret that is used to get return value from
wilc_send_config_pkt. Some handle_*() function are used as result,
others are used as ret. It will be changed as ret in all handle_*()
function to match variable name.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 33735fd..4fd429e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -310,7 +310,7 @@ static void handle_set_channel(struct wilc_vif *vif,
 static void handle_set_wfi_drv_handler(struct wilc_vif *vif,
 				       struct drv_handler *hif_drv_handler)
 {
-	int result = 0;
+	int ret = 0;
 	struct wid wid;
 
 	wid.id = (u16)WID_SET_DRV_HANDLER;
@@ -318,13 +318,13 @@ static void handle_set_wfi_drv_handler(struct wilc_vif *vif,
 	wid.val = (s8 *)hif_drv_handler;
 	wid.size = sizeof(*hif_drv_handler);
 
-	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
-				      hif_drv_handler->handler);
+	ret = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
+				   hif_drv_handler->handler);
 
 	if (!hif_drv_handler->handler)
 		complete(&hif_driver_comp);
 
-	if (result)
+	if (ret)
 		netdev_err(vif->ndev, "Failed to set driver handler\n");
 }
 
-- 
2.8.0

