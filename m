Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36225 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758321AbbKHHvJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2015 02:51:09 -0500
Received: by pacdm15 with SMTP id dm15so141920180pac.3
        for <linux-wireless@vger.kernel.org>; Sat, 07 Nov 2015 23:51:08 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 32/32] staging: wilc1000: remove host_int_get_rx_power_level
Date: Sun,  8 Nov 2015 16:49:25 +0900
Message-Id: <1446968965-8958-32-git-send-email-chaehyun.lim@gmail.com> (sfid-20151108_085112_825432_0FEDF097)
In-Reply-To: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
References: <1446968965-8958-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes host_int_get_rx_power_level function definition and
declaration that is defined at host_interface.c and host_interface.h.
This function is defined but not used anywhere in this driver so just
remove it.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 14 --------------
 drivers/staging/wilc1000/host_interface.h |  3 ---
 2 files changed, 17 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index ff15179..5bf9a55 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3560,20 +3560,6 @@ s32 host_int_get_assoc_res_info(struct host_if_drv *hif_drv,
 	return result;
 }
 
-s32 host_int_get_rx_power_level(struct host_if_drv *hif_drv,
-				u8 *pu8RxPowerLevel,
-				u32 u32RxPowerLevelLen)
-{
-	struct wid wid;
-
-	wid.id = (u16)WID_RX_POWER_LEVEL;
-	wid.type = WID_STR;
-	wid.val = pu8RxPowerLevel;
-	wid.size = u32RxPowerLevelLen;
-
-	return 0;
-}
-
 int host_int_set_mac_chnl_num(struct host_if_drv *hif_drv, u8 channel)
 {
 	int result;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 8870458..c01f441 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -339,9 +339,6 @@ s32 host_int_get_assoc_res_info(struct host_if_drv *hWFIDrv,
 				u8 *pu8AssocRespInfo,
 				u32 u32MaxAssocRespInfoLen,
 				u32 *pu32RcvdAssocRespInfoLen);
-s32 host_int_get_rx_power_level(struct host_if_drv *hWFIDrv,
-				u8 *pu8RxPowerLevel,
-				u32 u32RxPowerLevelLen);
 int host_int_set_mac_chnl_num(struct host_if_drv *wfi_drv, u8 channel);
 s32 host_int_get_host_chnl_num(struct host_if_drv *hWFIDrv, u8 *pu8ChNo);
 s32 host_int_get_rssi(struct host_if_drv *hWFIDrv, s8 *ps8Rssi);
-- 
2.6.3

