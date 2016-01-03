Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35322 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbcACIh2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2016 03:37:28 -0500
Received: by mail-pa0-f46.google.com with SMTP id do7so1066952pab.2
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jan 2016 00:37:28 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 24/30] staging: wilc1000: rename u32Interval in wilc_add_beacon
Date: Sun,  3 Jan 2016 17:35:56 +0900
Message-Id: <1451810162-16993-24-git-send-email-chaehyun.lim@gmail.com> (sfid-20160103_095249_360751_F3148902)
In-Reply-To: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u32Interval to interval to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8d935e4..615ae59 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4159,7 +4159,7 @@ int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg)
 	return result;
 }
 
-int wilc_add_beacon(struct wilc_vif *vif, u32 u32Interval, u32 u32DTIMPeriod,
+int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 u32DTIMPeriod,
 		    u32 u32HeadLen, u8 *pu8Head, u32 u32TailLen, u8 *pu8Tail)
 {
 	int result = 0;
@@ -4178,7 +4178,7 @@ int wilc_add_beacon(struct wilc_vif *vif, u32 u32Interval, u32 u32DTIMPeriod,
 
 	msg.id = HOST_IF_MSG_ADD_BEACON;
 	msg.vif = vif;
-	pstrSetBeaconParam->interval = u32Interval;
+	pstrSetBeaconParam->interval = interval;
 	pstrSetBeaconParam->dtim_period = u32DTIMPeriod;
 	pstrSetBeaconParam->head_len = u32HeadLen;
 	pstrSetBeaconParam->head = kmemdup(pu8Head, u32HeadLen, GFP_KERNEL);
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 272b696..93a8abb 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -343,7 +343,7 @@ s32 wilc_hif_set_cfg(struct wilc_vif *vif,
 		     struct cfg_param_val *pstrCfgParamVal);
 s32 wilc_init(struct net_device *dev, struct host_if_drv **phWFIDrv);
 s32 wilc_deinit(struct wilc_vif *vif);
-int wilc_add_beacon(struct wilc_vif *vif, u32 u32Interval, u32 u32DTIMPeriod,
+int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 u32DTIMPeriod,
 		    u32 u32HeadLen, u8 *pu8Head, u32 u32TailLen, u8 *pu8Tail);
 int wilc_del_beacon(struct wilc_vif *vif);
 int wilc_add_station(struct wilc_vif *vif, struct add_sta_param *sta_param);
-- 
2.6.4

