Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:34391 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbcBLOFQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Feb 2016 09:05:16 -0500
Received: by mail-pa0-f67.google.com with SMTP id yy13so3868122pab.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Feb 2016 06:05:16 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 09/11] staging: wilc1000: change data type of result variable to int.
Date: Fri, 12 Feb 2016 23:04:45 +0900
Message-Id: <1455285887-29946-9-git-send-email-chaehyun.lim@gmail.com> (sfid-20160212_150529_333623_737C676D)
In-Reply-To: <1455285887-29946-1-git-send-email-chaehyun.lim@gmail.com>
References: <1455285887-29946-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

result variable gets value from wilc_send_config_pkt that has
return value of int. This patch changes data type of result variable to
int.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index eecd697..0f7a36c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -302,7 +302,7 @@ static struct wilc_vif *wilc_get_vif_from_idx(struct wilc *wilc, int idx)
 static void handle_set_channel(struct wilc_vif *vif,
 			       struct channel_attr *hif_set_ch)
 {
-	s32 result = 0;
+	int result = 0;
 	struct wid wid;
 
 	wid.id = (u16)WID_CURRENT_CHANNEL;
-- 
2.7.1

