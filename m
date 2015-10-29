Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35397 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbbJ2MaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 08:30:13 -0400
Received: by pasz6 with SMTP id z6so40016799pas.2
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2015 05:30:13 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 11/12] staging: use kmemdup in host_int_add_station
Date: Thu, 29 Oct 2015 21:29:27 +0900
Message-Id: <1446121768-4953-11-git-send-email-chaehyun.lim@gmail.com> (sfid-20151029_134654_769301_75BB8BD3)
In-Reply-To: <1446121768-4953-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446121768-4953-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces kmalloc followed by memcpy with kmemdup.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
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

