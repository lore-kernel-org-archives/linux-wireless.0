Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:34909 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbcBKEqp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Feb 2016 23:46:45 -0500
Received: by mail-pa0-f66.google.com with SMTP id fl4so1875930pad.2
        for <linux-wireless@vger.kernel.org>; Wed, 10 Feb 2016 20:46:45 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 4/4] staging: wilc1000: rename counter in wilc_send_config_pkt
Date: Thu, 11 Feb 2016 13:46:25 +0900
Message-Id: <1455165985-5509-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20160211_054648_017015_B1868AC8)
In-Reply-To: <1455165985-5509-1-git-send-email-chaehyun.lim@gmail.com>
References: <1455165985-5509-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames the name of counter variable to i.
This change makes more readability because wilc_send_config_pkt has a
similar argument name as count.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
v2: rebase latest staging-testing

 drivers/staging/wilc1000/wilc_wlan.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index c6bfec3..8712eda 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1352,32 +1352,31 @@ int wilc_wlan_cfg_get_val(u32 wid, u8 *buffer, u32 buffer_size)
 int wilc_send_config_pkt(struct wilc_vif *vif, u8 mode, struct wid *wids,
 			 u32 count, u32 drv)
 {
-	int counter;
+	int i;
 	int ret = 0;
 
 	if (mode == GET_CFG) {
-		for (counter = 0; counter < count; counter++) {
-			if (!wilc_wlan_cfg_get(vif, !counter,
-					       wids[counter].id,
-					       (counter == count - 1),
+		for (i = 0; i < count; i++) {
+			if (!wilc_wlan_cfg_get(vif, !i,
+					       wids[i].id,
+					       (i == count - 1),
 					       drv)) {
 				ret = -ETIMEDOUT;
 				break;
 			}
 		}
-		for (counter = 0; counter < count; counter++) {
-			wids[counter].size = wilc_wlan_cfg_get_val(
-					wids[counter].id,
-					wids[counter].val,
-					wids[counter].size);
+		for (i = 0; i < count; i++) {
+			wids[i].size = wilc_wlan_cfg_get_val(wids[i].id,
+							     wids[i].val,
+							     wids[i].size);
 		}
 	} else if (mode == SET_CFG) {
-		for (counter = 0; counter < count; counter++) {
-			if (!wilc_wlan_cfg_set(vif, !counter,
-					       wids[counter].id,
-					       wids[counter].val,
-					       wids[counter].size,
-					       (counter == count - 1),
+		for (i = 0; i < count; i++) {
+			if (!wilc_wlan_cfg_set(vif, !i,
+					       wids[i].id,
+					       wids[i].val,
+					       wids[i].size,
+					       (i == count - 1),
 					       drv)) {
 				ret = -ETIMEDOUT;
 				break;
-- 
2.7.1

