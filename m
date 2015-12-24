Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:36226 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933209AbbLXHxu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2015 02:53:50 -0500
Received: by mail-pa0-f52.google.com with SMTP id q3so124624974pav.3
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2015 23:53:49 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 21/21] staging: wilc1000: rename pstrStatistics in wilc_get_statistics
Date: Thu, 24 Dec 2015 16:52:39 +0900
Message-Id: <1450943559-20937-21-git-send-email-chaehyun.lim@gmail.com> (sfid-20151224_092249_800051_29309C65)
In-Reply-To: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
References: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pstrStatistics to stats to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 732ea96..5113d3d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3656,14 +3656,14 @@ int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level)
 	return result;
 }
 
-int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *pstrStatistics)
+int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats)
 {
 	int result = 0;
 	struct host_if_msg msg;
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_GET_STATISTICS;
-	msg.body.data = (char *)pstrStatistics;
+	msg.body.data = (char *)stats;
 	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index c64dc13d..b8b235d 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -365,7 +365,7 @@ s32 wilc_listen_state_expired(struct wilc_vif *vif, u32 u32SessionID);
 s32 wilc_frame_register(struct wilc_vif *vif, u16 u16FrameType, bool bReg);
 int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index);
 int wilc_set_operation_mode(struct wilc_vif *vif, u32 mode);
-int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *pstrStatistics);
+int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats);
 void wilc_resolve_disconnect_aberration(struct wilc_vif *vif);
 int wilc_get_vif_idx(struct wilc_vif *vif);
 
-- 
2.6.4

