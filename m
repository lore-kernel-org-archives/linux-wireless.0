Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:34376 "EHLO
	mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbcACIgY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2016 03:36:24 -0500
Received: by mail-pf0-f176.google.com with SMTP id e65so133503008pfe.1
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jan 2016 00:36:24 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 03/30] staging: wilc1000: rename u32SessionID in wilc_remain_on_channel
Date: Sun,  3 Jan 2016 17:35:35 +0900
Message-Id: <1451810162-16993-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20160103_093641_705574_2F4797EE)
In-Reply-To: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u32SessionID to session_id to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 30b4f30..6ea907e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4061,7 +4061,7 @@ void wilc_scan_complete_received(struct wilc *wilc, u8 *pu8Buffer,
 	return;
 }
 
-int wilc_remain_on_channel(struct wilc_vif *vif, u32 u32SessionID,
+int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 			   u32 u32duration, u16 chan,
 			   wilc_remain_on_chan_expired RemainOnChanExpired,
 			   wilc_remain_on_chan_ready RemainOnChanReady,
@@ -4084,7 +4084,7 @@ int wilc_remain_on_channel(struct wilc_vif *vif, u32 u32SessionID,
 	msg.body.remain_on_ch.ready = RemainOnChanReady;
 	msg.body.remain_on_ch.arg = pvUserArg;
 	msg.body.remain_on_ch.duration = u32duration;
-	msg.body.remain_on_ch.id = u32SessionID;
+	msg.body.remain_on_ch.id = session_id;
 	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index e28f462..c935e49 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -356,7 +356,7 @@ int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
 				u32 count);
 int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx);
 s32 wilc_del_all_rx_ba_session(struct wilc_vif *vif, char *pBSSID, char TID);
-int wilc_remain_on_channel(struct wilc_vif *vif, u32 u32SessionID,
+int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 			   u32 u32duration, u16 chan,
 			   wilc_remain_on_chan_expired RemainOnChanExpired,
 			   wilc_remain_on_chan_ready RemainOnChanReady,
-- 
2.6.4

