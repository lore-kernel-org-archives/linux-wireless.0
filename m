Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34676 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbbIGPgs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2015 11:36:48 -0400
Received: by padhy16 with SMTP id hy16so97498932pad.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2015 08:36:48 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/5] staging: wilc1000: linux_wlan.c: use kzalloc instead of WILC_MALLOC
Date: Tue,  8 Sep 2015 00:36:35 +0900
Message-Id: <1441640199-1507-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20150907_173654_254725_DAF3883A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces WILC_MALLOC with kzalloc.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index afd6702..f7dda75 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -2269,8 +2269,7 @@ int wilc_netdev_init(void)
 	sema_init(&close_exit_sync, 0);
 
 	/*create the common structure*/
-	g_linux_wlan = WILC_MALLOC(sizeof(linux_wlan_t));
-	memset(g_linux_wlan, 0, sizeof(linux_wlan_t));
+	g_linux_wlan = kzalloc(sizeof(linux_wlan_t), GFP_KERNEL);
 
 	/*Reset interrupt count debug*/
 	int_rcvdU = 0;
-- 
2.5.1

