Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34173 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbcBLOFN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Feb 2016 09:05:13 -0500
Received: by mail-pf0-f195.google.com with SMTP id 71so4033611pfv.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Feb 2016 06:05:13 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 08/11] staging: wilc1000: change handle_set_channel's return type to void
Date: Fri, 12 Feb 2016 23:04:44 +0900
Message-Id: <1455285887-29946-8-git-send-email-chaehyun.lim@gmail.com> (sfid-20160212_150522_547096_534941BA)
In-Reply-To: <1455285887-29946-1-git-send-email-chaehyun.lim@gmail.com>
References: <1455285887-29946-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When handle_set_channel is called in hostIFthread that is a kernel
thread, it is not checked return type of this function. This patch
changes return type to void and removes braces if statement due
to have a single statement.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index e9a6aa7..eecd697 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -299,8 +299,8 @@ static struct wilc_vif *wilc_get_vif_from_idx(struct wilc *wilc, int idx)
 	return wilc->vif[index];
 }
 
-static s32 handle_set_channel(struct wilc_vif *vif,
-			      struct channel_attr *hif_set_ch)
+static void handle_set_channel(struct wilc_vif *vif,
+			       struct channel_attr *hif_set_ch)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -313,12 +313,8 @@ static s32 handle_set_channel(struct wilc_vif *vif,
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
 
-	if (result) {
+	if (result)
 		PRINT_ER("Failed to set channel\n");
-		return -EINVAL;
-	}
-
-	return result;
 }
 
 static s32 handle_set_wfi_drv_handler(struct wilc_vif *vif,
-- 
2.7.1

