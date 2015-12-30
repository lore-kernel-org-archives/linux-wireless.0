Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:36415 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbbL3MQE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2015 07:16:04 -0500
Received: by mail-pa0-f48.google.com with SMTP id yy13so45544919pab.3
        for <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2015 04:16:03 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 05/20] staging: wilc1000: rename u32SessionID in wilc_listen_state_expired
Date: Wed, 30 Dec 2015 21:15:29 +0900
Message-Id: <1451477744-11975-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20151230_131623_867713_640719FA)
In-Reply-To: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u32SessionID to session_id to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 4db211b..3a9a967 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4098,7 +4098,7 @@ s32 wilc_remain_on_channel(struct wilc_vif *vif, u32 u32SessionID,
 	return result;
 }
 
-int wilc_listen_state_expired(struct wilc_vif *vif, u32 u32SessionID)
+int wilc_listen_state_expired(struct wilc_vif *vif, u32 session_id)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -4114,7 +4114,7 @@ int wilc_listen_state_expired(struct wilc_vif *vif, u32 u32SessionID)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_LISTEN_TIMER_FIRED;
 	msg.vif = vif;
-	msg.body.remain_on_ch.id = u32SessionID;
+	msg.body.remain_on_ch.id = session_id;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result)
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index fbc1ee1..47c664e 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -361,7 +361,7 @@ s32 wilc_remain_on_channel(struct wilc_vif *vif, u32 u32SessionID,
 			   wilc_remain_on_chan_expired RemainOnChanExpired,
 			   wilc_remain_on_chan_ready RemainOnChanReady,
 			   void *pvUserArg);
-int wilc_listen_state_expired(struct wilc_vif *vif, u32 u32SessionID);
+int wilc_listen_state_expired(struct wilc_vif *vif, u32 session_id);
 int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg);
 int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index);
 int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode);
-- 
2.6.4

