Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:36393 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757160AbbJ2XS3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 19:18:29 -0400
Received: by pacik9 with SMTP id ik9so5865627pac.3
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2015 16:18:28 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 12/12] staging: wilc1000: remove rates in host_int_add_station
Date: Fri, 30 Oct 2015 08:17:48 +0900
Message-Id: <1446160668-10747-12-git-send-email-chaehyun.lim@gmail.com> (sfid-20151030_001838_778538_C84508D8)
In-Reply-To: <1446160668-10747-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446160668-10747-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of using rates variable, it is used as add_sta_info->pu8Rates
directly.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: resend because 11/12 patch is changed.

 drivers/staging/wilc1000/host_interface.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 6b804e6..e2bdac8 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4537,13 +4537,11 @@ int host_int_add_station(struct host_if_drv *hif_drv,
 
 	memcpy(add_sta_info, sta_param, sizeof(struct add_sta_param));
 	if (add_sta_info->u8NumRates > 0) {
-		u8 *rates = kmemdup(sta_param->pu8Rates,
-				    add_sta_info->u8NumRates,
-				    GFP_KERNEL);
-		if (!rates)
+		add_sta_info->pu8Rates = kmemdup(sta_param->pu8Rates,
+						 add_sta_info->u8NumRates,
+						 GFP_KERNEL);
+		if (!add_sta_info->pu8Rates)
 			return -ENOMEM;
-
-		add_sta_info->pu8Rates = rates;
 	}
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-- 
2.6.1

