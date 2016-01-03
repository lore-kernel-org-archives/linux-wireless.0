Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36439 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbcACIg1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2016 03:36:27 -0500
Received: by mail-pa0-f44.google.com with SMTP id yy13so89267985pab.3
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jan 2016 00:36:27 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 04/30] staging: wilc1000: rename u32duration in wilc_remain_on_channel
Date: Sun,  3 Jan 2016 17:35:36 +0900
Message-Id: <1451810162-16993-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20160103_093642_618848_6B311706)
In-Reply-To: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u32duration to duration to remove u32 prefix.
There is no need u32 prefix to show data type of this variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 6ea907e..116942d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4062,7 +4062,7 @@ void wilc_scan_complete_received(struct wilc *wilc, u8 *pu8Buffer,
 }
 
 int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
-			   u32 u32duration, u16 chan,
+			   u32 duration, u16 chan,
 			   wilc_remain_on_chan_expired RemainOnChanExpired,
 			   wilc_remain_on_chan_ready RemainOnChanReady,
 			   void *pvUserArg)
@@ -4083,7 +4083,7 @@ int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 	msg.body.remain_on_ch.expired = RemainOnChanExpired;
 	msg.body.remain_on_ch.ready = RemainOnChanReady;
 	msg.body.remain_on_ch.arg = pvUserArg;
-	msg.body.remain_on_ch.duration = u32duration;
+	msg.body.remain_on_ch.duration = duration;
 	msg.body.remain_on_ch.id = session_id;
 	msg.vif = vif;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index c935e49..4902cc8 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -357,7 +357,7 @@ int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
 int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx);
 s32 wilc_del_all_rx_ba_session(struct wilc_vif *vif, char *pBSSID, char TID);
 int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
-			   u32 u32duration, u16 chan,
+			   u32 duration, u16 chan,
 			   wilc_remain_on_chan_expired RemainOnChanExpired,
 			   wilc_remain_on_chan_ready RemainOnChanReady,
 			   void *pvUserArg);
-- 
2.6.4

