Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:34657 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855AbbJ2XS0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 19:18:26 -0400
Received: by padda3 with SMTP id da3so5889237pad.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2015 16:18:25 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 11/12] staging: wilc1000: use kmemdup in host_int_add_station
Date: Fri, 30 Oct 2015 08:17:47 +0900
Message-Id: <1446160668-10747-11-git-send-email-chaehyun.lim@gmail.com> (sfid-20151030_001832_339013_418E67C1)
In-Reply-To: <1446160668-10747-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446160668-10747-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces kmalloc followed by memcpy with kmemdup.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: add wilc1000 driver name in commit title
    because driver name is not included at V1.

 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 3c5de75..6b804e6 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4537,12 +4537,12 @@ int host_int_add_station(struct host_if_drv *hif_drv,
 
 	memcpy(add_sta_info, sta_param, sizeof(struct add_sta_param));
 	if (add_sta_info->u8NumRates > 0) {
-		u8 *rates = kmalloc(add_sta_info->u8NumRates, GFP_KERNEL);
-
+		u8 *rates = kmemdup(sta_param->pu8Rates,
+				    add_sta_info->u8NumRates,
+				    GFP_KERNEL);
 		if (!rates)
 			return -ENOMEM;
 
-		memcpy(rates, sta_param->pu8Rates, add_sta_info->u8NumRates);
 		add_sta_info->pu8Rates = rates;
 	}
 
-- 
2.6.1

