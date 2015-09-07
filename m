Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35812 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbbIGPgv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2015 11:36:51 -0400
Received: by pacfv12 with SMTP id fv12so102006993pac.2
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2015 08:36:50 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 2/5] staging: wilc1000: linux_wlan.c: add kzalloc error check
Date: Tue,  8 Sep 2015 00:36:36 +0900
Message-Id: <1441640199-1507-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20150907_173659_229381_7FC60328)
In-Reply-To: <1441640199-1507-1-git-send-email-chaehyun.lim@gmail.com>
References: <1441640199-1507-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds error check if kzalloc is failed.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index f7dda75..76c48a4 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -2270,6 +2270,8 @@ int wilc_netdev_init(void)
 
 	/*create the common structure*/
 	g_linux_wlan = kzalloc(sizeof(linux_wlan_t), GFP_KERNEL);
+	if (!g_linux_wlan)
+		return -ENOMEM;
 
 	/*Reset interrupt count debug*/
 	int_rcvdU = 0;
-- 
2.5.1

