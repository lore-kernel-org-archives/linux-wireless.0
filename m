Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36291 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161036AbbKFKMK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 05:12:10 -0500
Received: by pacdm15 with SMTP id dm15so94623479pac.3
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2015 02:12:10 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V3 10/12] staging: wilc1000: rename pstrAddStationMsg in host_int_add_station
Date: Fri,  6 Nov 2015 19:11:19 +0900
Message-Id: <1446804681-8873-10-git-send-email-chaehyun.lim@gmail.com> (sfid-20151106_111216_550704_D04F51E3)
In-Reply-To: <1446804681-8873-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446804681-8873-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pstrAddStationMsg to add_sta_info to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V3: rebase latest staging-testing.

 drivers/staging/wilc1000/host_interface.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index dcf77ed..501b2e9a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4531,7 +4531,7 @@ int host_int_add_station(struct host_if_drv *hif_drv,
 {
 	int result = 0;
 	struct host_if_msg msg;
-	struct add_sta_param *pstrAddStationMsg = &msg.body.add_sta_info;
+	struct add_sta_param *add_sta_info = &msg.body.add_sta_info;
 
 	if (!hif_drv) {
 		PRINT_ER("driver is null\n");
@@ -4545,16 +4545,16 @@ int host_int_add_station(struct host_if_drv *hif_drv,
 	msg.id = HOST_IF_MSG_ADD_STATION;
 	msg.drv = hif_drv;
 
-	memcpy(pstrAddStationMsg, sta_param, sizeof(struct add_sta_param));
-	if (pstrAddStationMsg->rates_len > 0) {
-		u8 *rates = kmalloc(pstrAddStationMsg->rates_len, GFP_KERNEL);
+	memcpy(add_sta_info, sta_param, sizeof(struct add_sta_param));
+	if (add_sta_info->rates_len > 0) {
+		u8 *rates = kmalloc(add_sta_info->rates_len, GFP_KERNEL);
 
 		if (!rates)
 			return -ENOMEM;
 
 		memcpy(rates, sta_param->rates,
-		       pstrAddStationMsg->rates_len);
-		pstrAddStationMsg->rates = rates;
+		       add_sta_info->rates_len);
+		add_sta_info->rates = rates;
 	}
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-- 
2.6.3

