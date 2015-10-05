Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36140 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbbJEKgL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 06:36:11 -0400
Received: by pablk4 with SMTP id lk4so172818792pab.3
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2015 03:36:11 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 20/20] staging: wilc1000: remove unnecessary parentheses in host_int_remove_wep_key
Date: Mon,  5 Oct 2015 19:35:04 +0900
Message-Id: <1444041304-7727-20-git-send-email-chaehyun.lim@gmail.com> (sfid-20151005_123615_394316_55E998BD)
In-Reply-To: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
References: <1444041304-7727-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unnecessary parentheses in host_int_remove_wep_key
found by checkpatch.

CHECK: Unnecessary parentheses around wfi_drv->hSemTestKeyBlock
FILE: drivers/staging/wilc1000/host_interface.c:4320:

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index ade9be02..9878cb1 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4317,7 +4317,7 @@ int host_int_remove_wep_key(tstrWILC_WFIDrv *wfi_drv, u8 index)
 	result = wilc_mq_send(&gMsgQHostIF, &msg, sizeof(struct host_if_msg));
 	if (result)
 		PRINT_ER("Error in sending message queue : Request to remove WEP key\n");
-	down(&(wfi_drv->hSemTestKeyBlock));
+	down(&wfi_drv->hSemTestKeyBlock);
 
 	return result;
 }
-- 
2.6.0

