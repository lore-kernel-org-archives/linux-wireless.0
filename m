Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36410 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbcACIgS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2016 03:36:18 -0500
Received: by mail-pa0-f44.google.com with SMTP id yy13so89267106pab.3
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jan 2016 00:36:17 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 01/30] staging: wilc1000: rename u32duration in struct remain_ch
Date: Sun,  3 Jan 2016 17:35:33 +0900
Message-Id: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20160103_093637_717792_5C526E21)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch renames u32duration to duration that is a member of struct
remain_ch. The prefix u32 shows data type of its member, but there is no
need to use u32 prefix to represent data type.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 5a97a9d..39fa5a3 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2558,7 +2558,7 @@ ERRORHANDLER:
 		hif_drv->remain_on_ch_timer.data = (unsigned long)vif;
 		mod_timer(&hif_drv->remain_on_ch_timer,
 			  jiffies +
-			  msecs_to_jiffies(pstrHostIfRemainOnChan->u32duration));
+			  msecs_to_jiffies(pstrHostIfRemainOnChan->duration));
 
 		if (hif_drv->remain_on_ch.ready)
 			hif_drv->remain_on_ch.ready(hif_drv->remain_on_ch.arg);
@@ -4083,7 +4083,7 @@ s32 wilc_remain_on_channel(struct wilc_vif *vif, u32 u32SessionID,
 	msg.body.remain_on_ch.expired = RemainOnChanExpired;
 	msg.body.remain_on_ch.ready = RemainOnChanReady;
 	msg.body.remain_on_ch.arg = pvUserArg;
-	msg.body.remain_on_ch.u32duration = u32duration;
+	msg.body.remain_on_ch.duration = u32duration;
 	msg.body.remain_on_ch.id = u32SessionID;
 	msg.vif = vif;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index f90a530..a2f428f 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -240,7 +240,7 @@ struct ba_session_info {
 
 struct remain_ch {
 	u16 ch;
-	u32 u32duration;
+	u32 duration;
 	wilc_remain_on_chan_expired expired;
 	wilc_remain_on_chan_ready ready;
 	void *arg;
-- 
2.6.4

