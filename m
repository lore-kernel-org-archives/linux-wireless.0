Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35393 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbcACIhq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2016 03:37:46 -0500
Received: by mail-pa0-f46.google.com with SMTP id do7so1068881pab.2
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jan 2016 00:37:46 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 30/30] staging: wilc1000: rename pstrSetBeaconParam in wilc_add_beacon
Date: Sun,  3 Jan 2016 17:36:02 +0900
Message-Id: <1451810162-16993-30-git-send-email-chaehyun.lim@gmail.com> (sfid-20160103_095247_827272_EA4330E6)
In-Reply-To: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pstrSetBeaconParam to beacon_info to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8f8c583..34d56cd 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4164,7 +4164,7 @@ int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
 {
 	int result = 0;
 	struct host_if_msg msg;
-	struct beacon_attr *pstrSetBeaconParam = &msg.body.beacon_info;
+	struct beacon_attr *beacon_info = &msg.body.beacon_info;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv) {
@@ -4178,25 +4178,24 @@ int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
 
 	msg.id = HOST_IF_MSG_ADD_BEACON;
 	msg.vif = vif;
-	pstrSetBeaconParam->interval = interval;
-	pstrSetBeaconParam->dtim_period = dtim_period;
-	pstrSetBeaconParam->head_len = head_len;
-	pstrSetBeaconParam->head = kmemdup(head, head_len, GFP_KERNEL);
-	if (!pstrSetBeaconParam->head) {
+	beacon_info->interval = interval;
+	beacon_info->dtim_period = dtim_period;
+	beacon_info->head_len = head_len;
+	beacon_info->head = kmemdup(head, head_len, GFP_KERNEL);
+	if (!beacon_info->head) {
 		result = -ENOMEM;
 		goto ERRORHANDLER;
 	}
-	pstrSetBeaconParam->tail_len = tail_len;
+	beacon_info->tail_len = tail_len;
 
 	if (tail_len > 0) {
-		pstrSetBeaconParam->tail = kmemdup(tail, tail_len,
-						   GFP_KERNEL);
-		if (!pstrSetBeaconParam->tail) {
+		beacon_info->tail = kmemdup(tail, tail_len, GFP_KERNEL);
+		if (!beacon_info->tail) {
 			result = -ENOMEM;
 			goto ERRORHANDLER;
 		}
 	} else {
-		pstrSetBeaconParam->tail = NULL;
+		beacon_info->tail = NULL;
 	}
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
@@ -4205,9 +4204,9 @@ int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
 
 ERRORHANDLER:
 	if (result) {
-		kfree(pstrSetBeaconParam->head);
+		kfree(beacon_info->head);
 
-		kfree(pstrSetBeaconParam->tail);
+		kfree(beacon_info->tail);
 	}
 
 	return result;
-- 
2.6.4

