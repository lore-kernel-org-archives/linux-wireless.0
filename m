Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:36093 "EHLO
	mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbcACIhb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2016 03:37:31 -0500
Received: by mail-pf0-f176.google.com with SMTP id 65so141451594pff.3
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jan 2016 00:37:31 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 25/30] staging: wilc1000: rename u32DTIMPeriod in wilc_add_beacon
Date: Sun,  3 Jan 2016 17:35:57 +0900
Message-Id: <1451810162-16993-25-git-send-email-chaehyun.lim@gmail.com> (sfid-20160103_095248_848578_1B8FA1A6)
In-Reply-To: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u32DTIMPeriod to dtim_period to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 615ae59..9d9cf91 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4159,7 +4159,7 @@ int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg)
 	return result;
 }
 
-int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 u32DTIMPeriod,
+int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
 		    u32 u32HeadLen, u8 *pu8Head, u32 u32TailLen, u8 *pu8Tail)
 {
 	int result = 0;
@@ -4179,7 +4179,7 @@ int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 u32DTIMPeriod,
 	msg.id = HOST_IF_MSG_ADD_BEACON;
 	msg.vif = vif;
 	pstrSetBeaconParam->interval = interval;
-	pstrSetBeaconParam->dtim_period = u32DTIMPeriod;
+	pstrSetBeaconParam->dtim_period = dtim_period;
 	pstrSetBeaconParam->head_len = u32HeadLen;
 	pstrSetBeaconParam->head = kmemdup(pu8Head, u32HeadLen, GFP_KERNEL);
 	if (!pstrSetBeaconParam->head) {
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 93a8abb..58b73d6 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -343,7 +343,7 @@ s32 wilc_hif_set_cfg(struct wilc_vif *vif,
 		     struct cfg_param_val *pstrCfgParamVal);
 s32 wilc_init(struct net_device *dev, struct host_if_drv **phWFIDrv);
 s32 wilc_deinit(struct wilc_vif *vif);
-int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 u32DTIMPeriod,
+int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
 		    u32 u32HeadLen, u8 *pu8Head, u32 u32TailLen, u8 *pu8Tail);
 int wilc_del_beacon(struct wilc_vif *vif);
 int wilc_add_station(struct wilc_vif *vif, struct add_sta_param *sta_param);
-- 
2.6.4

