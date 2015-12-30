Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:35822 "EHLO
	mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbbL3MPy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2015 07:15:54 -0500
Received: by mail-pf0-f171.google.com with SMTP id 78so141432878pfw.2
        for <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2015 04:15:54 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 02/20] staging: wilc1000: rename u16FrameType in wilc_frame_register
Date: Wed, 30 Dec 2015 21:15:26 +0900
Message-Id: <1451477744-11975-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20151230_131617_167924_0FE668FF)
In-Reply-To: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u16FrameType to frame_type to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d9e4e11..c3e59d8 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4123,7 +4123,7 @@ s32 wilc_listen_state_expired(struct wilc_vif *vif, u32 u32SessionID)
 	return result;
 }
 
-int wilc_frame_register(struct wilc_vif *vif, u16 u16FrameType, bool bReg)
+int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool bReg)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -4137,7 +4137,7 @@ int wilc_frame_register(struct wilc_vif *vif, u16 u16FrameType, bool bReg)
 	memset(&msg, 0, sizeof(struct host_if_msg));
 
 	msg.id = HOST_IF_MSG_REGISTER_FRAME;
-	switch (u16FrameType) {
+	switch (frame_type) {
 	case ACTION:
 		PRINT_D(HOSTINF_DBG, "ACTION\n");
 		msg.body.reg_frame.reg_id = ACTION_FRM_IDX;
@@ -4152,7 +4152,7 @@ int wilc_frame_register(struct wilc_vif *vif, u16 u16FrameType, bool bReg)
 		PRINT_D(HOSTINF_DBG, "Not valid frame type\n");
 		break;
 	}
-	msg.body.reg_frame.frame_type = u16FrameType;
+	msg.body.reg_frame.frame_type = frame_type;
 	msg.body.reg_frame.reg = bReg;
 	msg.vif = vif;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 5ecc978..efb657b 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -362,7 +362,7 @@ s32 wilc_remain_on_channel(struct wilc_vif *vif, u32 u32SessionID,
 			   wilc_remain_on_chan_ready RemainOnChanReady,
 			   void *pvUserArg);
 s32 wilc_listen_state_expired(struct wilc_vif *vif, u32 u32SessionID);
-int wilc_frame_register(struct wilc_vif *vif, u16 u16FrameType, bool bReg);
+int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool bReg);
 int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index);
 int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode);
 int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats);
-- 
2.6.4

