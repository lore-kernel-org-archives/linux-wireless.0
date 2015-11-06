Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:36402 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161036AbbKFKMR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 05:12:17 -0500
Received: by pacdm15 with SMTP id dm15so94626452pac.3
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2015 02:12:17 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 12/12] staging: wilc1000: remove rates variable in host_int_add_station
Date: Fri,  6 Nov 2015 19:11:21 +0900
Message-Id: <1446804681-8873-12-git-send-email-chaehyun.lim@gmail.com> (sfid-20151106_113753_918465_3D339B40)
In-Reply-To: <1446804681-8873-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446804681-8873-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of using rates variable, it is used as add_sta_info->rates
directly.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V3: rebase latest staging-testing.

 drivers/staging/wilc1000/host_interface.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 72d2814..58f7668 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4547,12 +4547,11 @@ int host_int_add_station(struct host_if_drv *hif_drv,
 
 	memcpy(add_sta_info, sta_param, sizeof(struct add_sta_param));
 	if (add_sta_info->rates_len > 0) {
-		u8 *rates = kmemdup(sta_param->rates,
-				    add_sta_info->rates_len,
-				    GFP_KERNEL);
-		if (!rates)
+		add_sta_info->rates = kmemdup(sta_param->rates,
+				      add_sta_info->rates_len,
+				      GFP_KERNEL);
+		if (!add_sta_info->rates)
 			return -ENOMEM;
-		add_sta_info->rates = rates;
 	}
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-- 
2.6.3

