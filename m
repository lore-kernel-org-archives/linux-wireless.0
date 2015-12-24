Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35116 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933209AbbLXHxq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2015 02:53:46 -0500
Received: by mail-pa0-f53.google.com with SMTP id jx14so118490681pad.2
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2015 23:53:46 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 20/21] staging: wilc1000: fix return type of wilc_get_statistics
Date: Thu, 24 Dec 2015 16:52:38 +0900
Message-Id: <1450943559-20937-20-git-send-email-chaehyun.lim@gmail.com> (sfid-20151224_092247_188267_269F88DC)
In-Reply-To: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
References: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of wilc_get_statistics from s32 to int.
The result variable gets return value from wilc_mq_send that has return
type of int. It should be changed return type of this function as well
as data type of result variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index e1e123b..732ea96 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3656,9 +3656,9 @@ int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level)
 	return result;
 }
 
-s32 wilc_get_statistics(struct wilc_vif *vif, struct rf_info *pstrStatistics)
+int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *pstrStatistics)
 {
-	s32 result = 0;
+	int result = 0;
 	struct host_if_msg msg;
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 4506e0b..c64dc13d 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -365,7 +365,7 @@ s32 wilc_listen_state_expired(struct wilc_vif *vif, u32 u32SessionID);
 s32 wilc_frame_register(struct wilc_vif *vif, u16 u16FrameType, bool bReg);
 int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index);
 int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode);
-s32 wilc_get_statistics(struct wilc_vif *vif, struct rf_info *pstrStatistics);
+int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *pstrStatistics);
 void wilc_resolve_disconnect_aberration(struct wilc_vif *vif);
 int wilc_get_vif_idx(struct wilc_vif *vif);
 
-- 
2.6.4

