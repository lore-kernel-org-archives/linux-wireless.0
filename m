Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:34711 "EHLO
	mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbcBEBf7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 20:35:59 -0500
Received: by mail-pf0-f180.google.com with SMTP id o185so59360077pfb.1
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2016 17:35:58 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 8/8] staging: wilc1000: rename counter in wilc_send_config_pkt
Date: Fri,  5 Feb 2016 10:35:18 +0900
Message-Id: <1454636118-9943-8-git-send-email-chaehyun.lim@gmail.com> (sfid-20160205_023605_615528_70877F71)
In-Reply-To: <1454636118-9943-1-git-send-email-chaehyun.lim@gmail.com>
References: <1454636118-9943-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

counter is used as for-loop control variable and indicating index of
struct wid array. It is to improve readability by changing counter
variable name as i because wilc_send_config_pkt has a similar argument
name as count.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 38 ++++++++++++++---------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index dda81ee..00081bc 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -452,36 +452,36 @@ s32 wilc_dealloc_assoc_resp_info(tstrConnectRespInfo *pstrConnectRespInfo)
 int wilc_send_config_pkt(struct wilc *wilc, u8 mode, struct wid *wids,
 			 u32 count, u32 drv)
 {
-	int counter;
+	int i;
 	int ret = 0;
 
 	if (mode == GET_CFG) {
-		for (counter = 0; counter < count; counter++) {
-			PRINT_INFO(CORECONFIG_DBG, "Sending CFG packet [%d][%d]\n", !counter,
-				   (counter == count - 1));
-			if (!wilc_wlan_cfg_get(wilc, !counter,
-					       wids[counter].id,
-					       (counter == count - 1),
+		for (i = 0; i < count; i++) {
+			PRINT_INFO(CORECONFIG_DBG, "Sending CFG packet [%d][%d]\n", !i,
+				   (i == count - 1));
+			if (!wilc_wlan_cfg_get(wilc, !i,
+					       wids[i].id,
+					       (i == count - 1),
 					       drv)) {
 				ret = -ETIMEDOUT;
 				printk("[Sendconfigpkt]Get Timed out\n");
 				break;
 			}
 		}
-		for (counter = 0; counter < count; counter++) {
-			wids[counter].size = wilc_wlan_cfg_get_val(
-					wids[counter].id,
-					wids[counter].val,
-					wids[counter].size);
+		for (i = 0; i < count; i++) {
+			wids[i].size = wilc_wlan_cfg_get_val(
+					wids[i].id,
+					wids[i].val,
+					wids[i].size);
 		}
 	} else if (mode == SET_CFG) {
-		for (counter = 0; counter < count; counter++) {
-			PRINT_D(CORECONFIG_DBG, "Sending config SET PACKET WID:%x\n", wids[counter].id);
-			if (!wilc_wlan_cfg_set(wilc, !counter,
-					       wids[counter].id,
-					       wids[counter].val,
-					       wids[counter].size,
-					       (counter == count - 1),
+		for (i = 0; i < count; i++) {
+			PRINT_D(CORECONFIG_DBG, "Sending config SET PACKET WID:%x\n", wids[i].id);
+			if (!wilc_wlan_cfg_set(wilc, !i,
+					       wids[i].id,
+					       wids[i].val,
+					       wids[i].size,
+					       (i == count - 1),
 					       drv)) {
 				ret = -ETIMEDOUT;
 				printk("[Sendconfigpkt]Set Timed out\n");
-- 
2.7.0

