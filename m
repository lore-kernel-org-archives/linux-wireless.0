Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34016 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbbJ2MaK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 08:30:10 -0400
Received: by padhk11 with SMTP id hk11so40061008pad.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2015 05:30:10 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 10/12] staging: wilc1000: rename pstrAddStationMsg in host_int_add_station
Date: Thu, 29 Oct 2015 21:29:26 +0900
Message-Id: <1446121768-4953-10-git-send-email-chaehyun.lim@gmail.com> (sfid-20151029_133015_554471_A8EE76FA)
In-Reply-To: <1446121768-4953-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446121768-4953-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pstrAddStationMsg to add_sta_info to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 57287d4..3c5de75 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4521,7 +4521,7 @@ int host_int_add_station(struct host_if_drv *hif_drv,
 {
 	int result = 0;
 	struct host_if_msg msg;
-	struct add_sta_param *pstrAddStationMsg = &msg.body.add_sta_info;
+	struct add_sta_param *add_sta_info = &msg.body.add_sta_info;
 
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
@@ -4535,15 +4535,15 @@ int host_int_add_station(struct host_if_drv *hif_drv,
 	msg.id = HOST_IF_MSG_ADD_STATION;
 	msg.drv = hif_drv;
 
-	memcpy(pstrAddStationMsg, sta_param, sizeof(struct add_sta_param));
-	if (pstrAddStationMsg->u8NumRates > 0) {
-		u8 *rates = kmalloc(pstrAddStationMsg->u8NumRates, GFP_KERNEL);
+	memcpy(add_sta_info, sta_param, sizeof(struct add_sta_param));
+	if (add_sta_info->u8NumRates > 0) {
+		u8 *rates = kmalloc(add_sta_info->u8NumRates, GFP_KERNEL);
 
 		if (!rates)
 			return -ENOMEM;
 
-		memcpy(rates, sta_param->pu8Rates, pstrAddStationMsg->u8NumRates);
-		pstrAddStationMsg->pu8Rates = rates;
+		memcpy(rates, sta_param->pu8Rates, add_sta_info->u8NumRates);
+		add_sta_info->pu8Rates = rates;
 	}
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-- 
2.6.1

