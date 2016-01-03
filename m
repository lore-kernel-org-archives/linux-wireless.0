Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:34170 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbcACIgd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2016 03:36:33 -0500
Received: by mail-pa0-f43.google.com with SMTP id uo6so161301857pac.1
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jan 2016 00:36:33 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 06/30] staging: wilc1000: rename RemainOnChanReady in wilc_remain_on_channel
Date: Sun,  3 Jan 2016 17:35:38 +0900
Message-Id: <1451810162-16993-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20160103_093646_100319_B2008B10)
In-Reply-To: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames RemainOnChanReady to ready to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 9265328..21d1e87e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4064,7 +4064,7 @@ void wilc_scan_complete_received(struct wilc *wilc, u8 *pu8Buffer,
 int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 			   u32 duration, u16 chan,
 			   wilc_remain_on_chan_expired expired,
-			   wilc_remain_on_chan_ready RemainOnChanReady,
+			   wilc_remain_on_chan_ready ready,
 			   void *pvUserArg)
 {
 	int result = 0;
@@ -4081,7 +4081,7 @@ int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 	msg.id = HOST_IF_MSG_REMAIN_ON_CHAN;
 	msg.body.remain_on_ch.ch = chan;
 	msg.body.remain_on_ch.expired = expired;
-	msg.body.remain_on_ch.ready = RemainOnChanReady;
+	msg.body.remain_on_ch.ready = ready;
 	msg.body.remain_on_ch.arg = pvUserArg;
 	msg.body.remain_on_ch.duration = duration;
 	msg.body.remain_on_ch.id = session_id;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index d2ca27e..8a03055 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -359,7 +359,7 @@ s32 wilc_del_all_rx_ba_session(struct wilc_vif *vif, char *pBSSID, char TID);
 int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 			   u32 duration, u16 chan,
 			   wilc_remain_on_chan_expired expired,
-			   wilc_remain_on_chan_ready RemainOnChanReady,
+			   wilc_remain_on_chan_ready ready,
 			   void *pvUserArg);
 int wilc_listen_state_expired(struct wilc_vif *vif, u32 session_id);
 int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg);
-- 
2.6.4

