Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34374 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbcACIhZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2016 03:37:25 -0500
Received: by mail-pa0-f52.google.com with SMTP id uo6so161307631pac.1
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jan 2016 00:37:25 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 23/30] staging: wilc1000: fix return type of wilc_add_beacon
Date: Sun,  3 Jan 2016 17:35:55 +0900
Message-Id: <1451810162-16993-23-git-send-email-chaehyun.lim@gmail.com> (sfid-20160103_095248_606238_CF4183FF)
In-Reply-To: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of wilc_add_beacon from s32 to int.
The result variable gets return value from wilc_mq_send that has data
type of int. It should be changed return type of this function as well
as result variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 0ff500d..8d935e4 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4159,10 +4159,10 @@ int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg)
 	return result;
 }
 
-s32 wilc_add_beacon(struct wilc_vif *vif, u32 u32Interval, u32 u32DTIMPeriod,
+int wilc_add_beacon(struct wilc_vif *vif, u32 u32Interval, u32 u32DTIMPeriod,
 		    u32 u32HeadLen, u8 *pu8Head, u32 u32TailLen, u8 *pu8Tail)
 {
-	s32 result = 0;
+	int result = 0;
 	struct host_if_msg msg;
 	struct beacon_attr *pstrSetBeaconParam = &msg.body.beacon_info;
 	struct host_if_drv *hif_drv = vif->hif_drv;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 3c932e7a..272b696 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -343,7 +343,7 @@ s32 wilc_hif_set_cfg(struct wilc_vif *vif,
 		     struct cfg_param_val *pstrCfgParamVal);
 s32 wilc_init(struct net_device *dev, struct host_if_drv **phWFIDrv);
 s32 wilc_deinit(struct wilc_vif *vif);
-s32 wilc_add_beacon(struct wilc_vif *vif, u32 u32Interval, u32 u32DTIMPeriod,
+int wilc_add_beacon(struct wilc_vif *vif, u32 u32Interval, u32 u32DTIMPeriod,
 		    u32 u32HeadLen, u8 *pu8Head, u32 u32TailLen, u8 *pu8Tail);
 int wilc_del_beacon(struct wilc_vif *vif);
 int wilc_add_station(struct wilc_vif *vif, struct add_sta_param *sta_param);
-- 
2.6.4

