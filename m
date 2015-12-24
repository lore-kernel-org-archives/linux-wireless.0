Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34070 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbbLXHwu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2015 02:52:50 -0500
Received: by mail-pa0-f44.google.com with SMTP id uo6so40377602pac.1
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2015 23:52:50 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 01/21] staging: wilc1000: fix return type of wilc_flush_join_req
Date: Thu, 24 Dec 2015 16:52:19 +0900
Message-Id: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20151224_085325_114232_A12DD261)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of wilc_flush_join_req from s32 to int.
The result variable gets return value from wilc_mq_send that has return
type of int. It should be changed return type of this function as well
as data type of result variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 78d26ee..78d58e0 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3432,9 +3432,9 @@ s32 wilc_set_join_req(struct wilc_vif *vif, u8 *pu8bssid, const u8 *pu8ssid,
 	return result;
 }
 
-s32 wilc_flush_join_req(struct wilc_vif *vif)
+int wilc_flush_join_req(struct wilc_vif *vif)
 {
-	s32 result = 0;
+	int result = 0;
 	struct host_if_msg msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 13d253c..af85824 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -331,7 +331,7 @@ s32 wilc_set_join_req(struct wilc_vif *vif, u8 *pu8bssid, const u8 *pu8ssid,
 		      wilc_connect_result pfConnectResult, void *pvUserArg,
 		      u8 u8security, enum AUTHTYPE tenuAuth_type,
 		      u8 u8channel, void *pJoinParams);
-s32 wilc_flush_join_req(struct wilc_vif *vif);
+int wilc_flush_join_req(struct wilc_vif *vif);
 s32 wilc_disconnect(struct wilc_vif *vif, u16 u16ReasonCode);
 int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel);
 s32 wilc_get_rssi(struct wilc_vif *vif, s8 *ps8Rssi);
-- 
2.6.4

