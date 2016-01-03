Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:34641 "EHLO
	mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbcACIhe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2016 03:37:34 -0500
Received: by mail-pf0-f171.google.com with SMTP id e65so133510430pfe.1
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jan 2016 00:37:34 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 26/30] staging: wilc1000: rename u32HeadLen in wilc_add_beacon
Date: Sun,  3 Jan 2016 17:35:58 +0900
Message-Id: <1451810162-16993-26-git-send-email-chaehyun.lim@gmail.com> (sfid-20160103_095246_686602_17841C0F)
In-Reply-To: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u32HeadLen to head_len to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 9d9cf91..07674d2 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4160,7 +4160,7 @@ int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg)
 }
 
 int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
-		    u32 u32HeadLen, u8 *pu8Head, u32 u32TailLen, u8 *pu8Tail)
+		    u32 head_len, u8 *pu8Head, u32 u32TailLen, u8 *pu8Tail)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -4180,8 +4180,8 @@ int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
 	msg.vif = vif;
 	pstrSetBeaconParam->interval = interval;
 	pstrSetBeaconParam->dtim_period = dtim_period;
-	pstrSetBeaconParam->head_len = u32HeadLen;
-	pstrSetBeaconParam->head = kmemdup(pu8Head, u32HeadLen, GFP_KERNEL);
+	pstrSetBeaconParam->head_len = head_len;
+	pstrSetBeaconParam->head = kmemdup(pu8Head, head_len, GFP_KERNEL);
 	if (!pstrSetBeaconParam->head) {
 		result = -ENOMEM;
 		goto ERRORHANDLER;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 58b73d6..0275028 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -344,7 +344,7 @@ s32 wilc_hif_set_cfg(struct wilc_vif *vif,
 s32 wilc_init(struct net_device *dev, struct host_if_drv **phWFIDrv);
 s32 wilc_deinit(struct wilc_vif *vif);
 int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
-		    u32 u32HeadLen, u8 *pu8Head, u32 u32TailLen, u8 *pu8Tail);
+		    u32 head_len, u8 *pu8Head, u32 u32TailLen, u8 *pu8Tail);
 int wilc_del_beacon(struct wilc_vif *vif);
 int wilc_add_station(struct wilc_vif *vif, struct add_sta_param *sta_param);
 int wilc_del_allstation(struct wilc_vif *vif, u8 mac_addr[][ETH_ALEN]);
-- 
2.6.4

