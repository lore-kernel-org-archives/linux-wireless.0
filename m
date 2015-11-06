Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36343 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161036AbbKFKMO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 05:12:14 -0500
Received: by pacdm15 with SMTP id dm15so94624894pac.3
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2015 02:12:14 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 11/12] staging: wilc1000: use kmemdup in host_int_add_station
Date: Fri,  6 Nov 2015 19:11:20 +0900
Message-Id: <1446804681-8873-11-git-send-email-chaehyun.lim@gmail.com> (sfid-20151106_113754_269112_3984B1D8)
In-Reply-To: <1446804681-8873-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446804681-8873-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces kmalloc followed by memcpy with kmemdup.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V3: rebase latest staging-testing.

 drivers/staging/wilc1000/host_interface.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 501b2e9a..72d2814 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4547,13 +4547,11 @@ int host_int_add_station(struct host_if_drv *hif_drv,
 
 	memcpy(add_sta_info, sta_param, sizeof(struct add_sta_param));
 	if (add_sta_info->rates_len > 0) {
-		u8 *rates = kmalloc(add_sta_info->rates_len, GFP_KERNEL);
-
+		u8 *rates = kmemdup(sta_param->rates,
+				    add_sta_info->rates_len,
+				    GFP_KERNEL);
 		if (!rates)
 			return -ENOMEM;
-
-		memcpy(rates, sta_param->rates,
-		       add_sta_info->rates_len);
 		add_sta_info->rates = rates;
 	}
 
-- 
2.6.3

