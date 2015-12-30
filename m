Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:33803 "EHLO
	mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbbL3MPv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2015 07:15:51 -0500
Received: by mail-pf0-f177.google.com with SMTP id e65so88853474pfe.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2015 04:15:51 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 01/20] staging: wilc1000: fix return type of wilc_frame_register
Date: Wed, 30 Dec 2015 21:15:25 +0900
Message-Id: <1451477744-11975-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20151230_131616_503273_6D21D100)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of wilc_frame_register from s32 to int.
The result variable gets return value from wilc_mq_send that has return
type of int. It should be changed return type of this function as well
as data type of result variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 5113d3d..d9e4e11 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4123,9 +4123,9 @@ s32 wilc_listen_state_expired(struct wilc_vif *vif, u32 u32SessionID)
 	return result;
 }
 
-s32 wilc_frame_register(struct wilc_vif *vif, u16 u16FrameType, bool bReg)
+int wilc_frame_register(struct wilc_vif *vif, u16 u16FrameType, bool bReg)
 {
-	s32 result = 0;
+	int result = 0;
 	struct host_if_msg msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index b8b235d..5ecc978 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -362,7 +362,7 @@ s32 wilc_remain_on_channel(struct wilc_vif *vif, u32 u32SessionID,
 			   wilc_remain_on_chan_ready RemainOnChanReady,
 			   void *pvUserArg);
 s32 wilc_listen_state_expired(struct wilc_vif *vif, u32 u32SessionID);
-s32 wilc_frame_register(struct wilc_vif *vif, u16 u16FrameType, bool bReg);
+int wilc_frame_register(struct wilc_vif *vif, u16 u16FrameType, bool bReg);
 int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index);
 int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode);
 int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats);
-- 
2.6.4

