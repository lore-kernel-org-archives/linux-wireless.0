Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:35887 "EHLO
	mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbcACIgg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2016 03:36:36 -0500
Received: by mail-pf0-f173.google.com with SMTP id 65so141445837pff.3
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jan 2016 00:36:36 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 07/30] staging: wilc1000: rename pvUserArg in wilc_remain_on_channel
Date: Sun,  3 Jan 2016 17:35:39 +0900
Message-Id: <1451810162-16993-7-git-send-email-chaehyun.lim@gmail.com> (sfid-20160103_093654_228269_17830C0A)
In-Reply-To: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pvUserArg to user_arg to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 21d1e87e..3636f76 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4065,7 +4065,7 @@ int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 			   u32 duration, u16 chan,
 			   wilc_remain_on_chan_expired expired,
 			   wilc_remain_on_chan_ready ready,
-			   void *pvUserArg)
+			   void *user_arg)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -4082,7 +4082,7 @@ int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 	msg.body.remain_on_ch.ch = chan;
 	msg.body.remain_on_ch.expired = expired;
 	msg.body.remain_on_ch.ready = ready;
-	msg.body.remain_on_ch.arg = pvUserArg;
+	msg.body.remain_on_ch.arg = user_arg;
 	msg.body.remain_on_ch.duration = duration;
 	msg.body.remain_on_ch.id = session_id;
 	msg.vif = vif;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 8a03055..4f741ff 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -360,7 +360,7 @@ int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 			   u32 duration, u16 chan,
 			   wilc_remain_on_chan_expired expired,
 			   wilc_remain_on_chan_ready ready,
-			   void *pvUserArg);
+			   void *user_arg);
 int wilc_listen_state_expired(struct wilc_vif *vif, u32 session_id);
 int wilc_frame_register(struct wilc_vif *vif, u16 frame_type, bool reg);
 int wilc_set_wfi_drv_handler(struct wilc_vif *vif, int index);
-- 
2.6.4

