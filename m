Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33921 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525AbbL3MQA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2015 07:16:00 -0500
Received: by mail-pa0-f47.google.com with SMTP id uo6so116318241pac.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2015 04:16:00 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 04/20] staging: wilc1000: fix return type of wilc_listen_state_expired
Date: Wed, 30 Dec 2015 21:15:28 +0900
Message-Id: <1451477744-11975-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20151230_131622_110908_FDEA6F93)
In-Reply-To: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of wilc_listen_state_expired from s32 to
int. The result variable gets return value from wilc_mq_send that has
return type of int. It should be changed return type of this function as
well as data type of result variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 9b72519..4db211b 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4098,9 +4098,9 @@ s32 wilc_remain_on_channel(struct wilc_vif *vif, u32 u32SessionID,
 	return result;
 }
 
-s32 wilc_listen_state_expired(struct wilc_vif *vif, u32 u32SessionID)
+int wilc_listen_state_expired(struct wilc_vif *vif, u32 u32SessionID)
 {
-	s32 result = 0;
+	int result = 0;
 	struct host_if_msg msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index b43e0a1..fbc1ee1 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -361,7 +361,7 @@ s32 wilc_remain_on_channel(struct wilc_vif *vif, u32 u32SessionID,
 			   wilc_remain_on_chan_expired RemainOnChanExpired,
 			   wilc_remain_on_chan_ready RemainOnChanReady,
 			   void *pvUserArg);
-s32 wilc_listen_state_expired(struct wilc_vif *vif, u32 u32SessionID);
+int wilc_listen_state_expired(struct wilc_vif *vif, u32 u32SessionID);
 int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg);
 int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index);
 int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode);
-- 
2.6.4

