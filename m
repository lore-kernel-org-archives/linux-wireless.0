Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:34968 "EHLO
	mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbcACIgV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2016 03:36:21 -0500
Received: by mail-pf0-f178.google.com with SMTP id 78so187618887pfw.2
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jan 2016 00:36:21 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 02/30] staging: wilc1000: fix return type of wilc_remain_on_channel
Date: Sun,  3 Jan 2016 17:35:34 +0900
Message-Id: <1451810162-16993-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20160103_093638_337102_5A6BBA7A)
In-Reply-To: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of wilc_remain_on_channel from s32 to
int. The result variable gets return value from wilc_mq_send that has
data type of int. It should be changed return type of this function as
well as data type of result variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 39fa5a3..30b4f30 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4061,13 +4061,13 @@ void wilc_scan_complete_received(struct wilc *wilc, u8 *pu8Buffer,
 	return;
 }
 
-s32 wilc_remain_on_channel(struct wilc_vif *vif, u32 u32SessionID,
+int wilc_remain_on_channel(struct wilc_vif *vif, u32 u32SessionID,
 			   u32 u32duration, u16 chan,
 			   wilc_remain_on_chan_expired RemainOnChanExpired,
 			   wilc_remain_on_chan_ready RemainOnChanReady,
 			   void *pvUserArg)
 {
-	s32 result = 0;
+	int result = 0;
 	struct host_if_msg msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index a2f428f..e28f462 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -356,7 +356,7 @@ int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
 				u32 count);
 int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx);
 s32 wilc_del_all_rx_ba_session(struct wilc_vif *vif, char *pBSSID, char TID);
-s32 wilc_remain_on_channel(struct wilc_vif *vif, u32 u32SessionID,
+int wilc_remain_on_channel(struct wilc_vif *vif, u32 u32SessionID,
 			   u32 u32duration, u16 chan,
 			   wilc_remain_on_chan_expired RemainOnChanExpired,
 			   wilc_remain_on_chan_ready RemainOnChanReady,
-- 
2.6.4

