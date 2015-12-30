Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33905 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbbL3MP5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2015 07:15:57 -0500
Received: by mail-pa0-f45.google.com with SMTP id uo6so116317745pac.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2015 04:15:57 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 03/20] staging: wilc1000: rename bReg in wilc_frame_register
Date: Wed, 30 Dec 2015 21:15:27 +0900
Message-Id: <1451477744-11975-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20151230_131618_721342_A98508F5)
In-Reply-To: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames bReg to reg to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c3e59d8..9b72519 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4123,7 +4123,7 @@ s32 wilc_listen_state_expired(struct wilc_vif *vif, u32 u32SessionID)
 	return result;
 }
 
-int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool bReg)
+int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -4153,7 +4153,7 @@ int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool bReg)
 		break;
 	}
 	msg.body.reg_frame.frame_type = frame_type;
-	msg.body.reg_frame.reg = bReg;
+	msg.body.reg_frame.reg = reg;
 	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index efb657b..b43e0a1 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -362,7 +362,7 @@ s32 wilc_remain_on_channel(struct wilc_vif *vif, u32 u32SessionID,
 			   wilc_remain_on_chan_ready RemainOnChanReady,
 			   void *pvUserArg);
 s32 wilc_listen_state_expired(struct wilc_vif *vif, u32 u32SessionID);
-int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool bReg);
+int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg);
 int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index);
 int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode);
 int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats);
-- 
2.6.4

