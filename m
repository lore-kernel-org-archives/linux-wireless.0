Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35369 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbcACIhk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2016 03:37:40 -0500
Received: by mail-pa0-f46.google.com with SMTP id do7so1068230pab.2
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jan 2016 00:37:40 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 28/30] staging: wilc1000: rename u32TailLen in wilc_add_beacon
Date: Sun,  3 Jan 2016 17:36:00 +0900
Message-Id: <1451810162-16993-28-git-send-email-chaehyun.lim@gmail.com> (sfid-20160103_095250_910040_9869080A)
In-Reply-To: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u32TailLen to tail_len to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index e35465e..c81c749 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4160,7 +4160,7 @@ int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg)
 }
 
 int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
-		    u32 head_len, u8 *head, u32 u32TailLen, u8 *pu8Tail)
+		    u32 head_len, u8 *head, u32 tail_len, u8 *pu8Tail)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -4186,10 +4186,10 @@ int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
 		result = -ENOMEM;
 		goto ERRORHANDLER;
 	}
-	pstrSetBeaconParam->tail_len = u32TailLen;
+	pstrSetBeaconParam->tail_len = tail_len;
 
-	if (u32TailLen > 0) {
-		pstrSetBeaconParam->tail = kmemdup(pu8Tail, u32TailLen,
+	if (tail_len > 0) {
+		pstrSetBeaconParam->tail = kmemdup(pu8Tail, tail_len,
 						   GFP_KERNEL);
 		if (!pstrSetBeaconParam->tail) {
 			result = -ENOMEM;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 1c3f741..7e4ea18 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -344,7 +344,7 @@ s32 wilc_hif_set_cfg(struct wilc_vif *vif,
 s32 wilc_init(struct net_device *dev, struct host_if_drv **phWFIDrv);
 s32 wilc_deinit(struct wilc_vif *vif);
 int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
-		    u32 head_len, u8 *head, u32 u32TailLen, u8 *pu8Tail);
+		    u32 head_len, u8 *head, u32 tail_len, u8 *pu8Tail);
 int wilc_del_beacon(struct wilc_vif *vif);
 int wilc_add_station(struct wilc_vif *vif, struct add_sta_param *sta_param);
 int wilc_del_allstation(struct wilc_vif *vif, u8 mac_addr[][ETH_ALEN]);
-- 
2.6.4

