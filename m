Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:34411 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbcBLOFW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Feb 2016 09:05:22 -0500
Received: by mail-pa0-f67.google.com with SMTP id yy13so3868221pab.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Feb 2016 06:05:22 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 11/11] staging: wilc1000: use netdev_err instead of PRINT_ER
Date: Fri, 12 Feb 2016 23:04:47 +0900
Message-Id: <1455285887-29946-11-git-send-email-chaehyun.lim@gmail.com> (sfid-20160212_150551_694183_BC3A35B9)
In-Reply-To: <1455285887-29946-1-git-send-email-chaehyun.lim@gmail.com>
References: <1455285887-29946-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch uses netdev_err instead of PRINT_ER that is a custom debug
print.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 10c5e4ef..a6bc8a4 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -314,7 +314,7 @@ static void handle_set_channel(struct wilc_vif *vif,
 				   wilc_get_vif_idx(vif));
 
 	if (ret)
-		PRINT_ER("Failed to set channel\n");
+		netdev_err(vif->ndev, "Failed to set channel\n");
 }
 
 static s32 handle_set_wfi_drv_handler(struct wilc_vif *vif,
-- 
2.7.1

