Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:34275 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbcACIhB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2016 03:37:01 -0500
Received: by mail-pa0-f45.google.com with SMTP id uo6so161304797pac.1
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jan 2016 00:37:00 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 15/30] staging: wilc1000: use kmemdup in wilc_edit_station
Date: Sun,  3 Jan 2016 17:35:47 +0900
Message-Id: <1451810162-16993-15-git-send-email-chaehyun.lim@gmail.com> (sfid-20160103_095247_345472_045099A8)
In-Reply-To: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces kmalloc followed by memcpy with kmemdup.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 2f94804..290c27a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4372,13 +4372,11 @@ int wilc_edit_station(struct wilc_vif *vif,
 
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
2.6.4

