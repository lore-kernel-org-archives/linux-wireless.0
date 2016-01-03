Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35212 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbcACIg5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2016 03:36:57 -0500
Received: by mail-pa0-f42.google.com with SMTP id do7so1063734pab.2
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jan 2016 00:36:57 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 14/30] staging: wilc1000: rename pstrAddStationMsg in wilc_edit_station
Date: Sun,  3 Jan 2016 17:35:46 +0900
Message-Id: <1451810162-16993-14-git-send-email-chaehyun.lim@gmail.com> (sfid-20160103_095250_330982_68BDEB00)
In-Reply-To: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pstrAddStationMsg to add_sta_info to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index de921fa..2f94804 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4355,7 +4355,7 @@ int wilc_edit_station(struct wilc_vif *vif,
 {
 	int result = 0;
 	struct host_if_msg msg;
-	struct add_sta_param *pstrAddStationMsg = &msg.body.add_sta_info;
+	struct add_sta_param *add_sta_info = &msg.body.add_sta_info;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
@@ -4370,16 +4370,16 @@ int wilc_edit_station(struct wilc_vif *vif,
 	msg.id = HOST_IF_MSG_EDIT_STATION;
 	msg.vif = vif;
 
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
2.6.4

