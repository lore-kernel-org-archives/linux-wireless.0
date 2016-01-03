Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:32993 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbcACIhE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2016 03:37:04 -0500
Received: by mail-pa0-f44.google.com with SMTP id cy9so181764800pac.0
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jan 2016 00:37:03 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 16/30] staging: wilc1000: remove rates variable in wilc_edit_station
Date: Sun,  3 Jan 2016 17:35:48 +0900
Message-Id: <1451810162-16993-16-git-send-email-chaehyun.lim@gmail.com> (sfid-20160103_095250_671955_4B7F81B1)
In-Reply-To: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of using rates variable, it is used as add_sta_info->rates
directly.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 290c27a..57d59dc 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4372,12 +4372,11 @@ int wilc_edit_station(struct wilc_vif *vif,
 
 	memcpy(add_sta_info, sta_param, sizeof(struct add_sta_param));
 	if (add_sta_info->rates_len > 0) {
-		u8 *rates = kmemdup(sta_param->rates,
-				    add_sta_info->rates_len,
-				    GFP_KERNEL);
-		if (!rates)
+		add_sta_info->rates = kmemdup(sta_param->rates,
+					      add_sta_info->rates_len,
+					      GFP_KERNEL);
+		if (!add_sta_info->rates)
 			return -ENOMEM;
-		add_sta_info->rates = rates;
 	}
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-- 
2.6.4

