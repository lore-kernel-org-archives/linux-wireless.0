Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:32858 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbcACIga (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2016 03:36:30 -0500
Received: by mail-pa0-f42.google.com with SMTP id cy9so181761246pac.0
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jan 2016 00:36:30 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 05/30] staging: wilc1000: rename RemainOnChanExpired in wilc_remain_on_channel
Date: Sun,  3 Jan 2016 17:35:37 +0900
Message-Id: <1451810162-16993-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20160103_093644_515411_0D5F1701)
In-Reply-To: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames RemainOnChanExpired to expired to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 116942d..9265328 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4063,7 +4063,7 @@ void wilc_scan_complete_received(struct wilc *wilc, u8 *pu8Buffer,
 
 int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 			   u32 duration, u16 chan,
-			   wilc_remain_on_chan_expired RemainOnChanExpired,
+			   wilc_remain_on_chan_expired expired,
 			   wilc_remain_on_chan_ready RemainOnChanReady,
 			   void *pvUserArg)
 {
@@ -4080,7 +4080,7 @@ int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 
 	msg.id = HOST_IF_MSG_REMAIN_ON_CHAN;
 	msg.body.remain_on_ch.ch = chan;
-	msg.body.remain_on_ch.expired = RemainOnChanExpired;
+	msg.body.remain_on_ch.expired = expired;
 	msg.body.remain_on_ch.ready = RemainOnChanReady;
 	msg.body.remain_on_ch.arg = pvUserArg;
 	msg.body.remain_on_ch.duration = duration;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 4902cc8..d2ca27e 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -358,7 +358,7 @@ int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx);
 s32 wilc_del_all_rx_ba_session(struct wilc_vif *vif, char *pBSSID, char TID);
 int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 			   u32 duration, u16 chan,
-			   wilc_remain_on_chan_expired RemainOnChanExpired,
+			   wilc_remain_on_chan_expired expired,
 			   wilc_remain_on_chan_ready RemainOnChanReady,
 			   void *pvUserArg);
 int wilc_listen_state_expired(struct wilc_vif *vif, u32 session_id);
-- 
2.6.4

