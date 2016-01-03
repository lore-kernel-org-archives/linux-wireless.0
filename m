Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:33146 "EHLO
	mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbcACIgj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2016 03:36:39 -0500
Received: by mail-pf0-f172.google.com with SMTP id q63so150375309pfb.0
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jan 2016 00:36:39 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 08/30] staging: wilc1000: fix return type of wilc_del_all_rx_ba_session
Date: Sun,  3 Jan 2016 17:35:40 +0900
Message-Id: <1451810162-16993-8-git-send-email-chaehyun.lim@gmail.com> (sfid-20160103_093649_733389_F5081C7F)
In-Reply-To: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of wilc_del_all_rx_ba_session from s32 to
int. The result variable gets return value from wilc_mq_send that has
return type of int. It should be changed return type of this function as
well as data type of result variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 3636f76..bf01e83 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4605,9 +4605,9 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 	return (void *)pNewJoinBssParam;
 }
 
-s32 wilc_del_all_rx_ba_session(struct wilc_vif *vif, char *pBSSID, char TID)
+int wilc_del_all_rx_ba_session(struct wilc_vif *vif, char *pBSSID, char TID)
 {
-	s32 result = 0;
+	int result = 0;
 	struct host_if_msg msg;
 	struct ba_session_info *pBASessionInfo = &msg.body.session_info;
 	struct host_if_drv *hif_drv = vif->hif_drv;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 4f741ff..85064cd 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -355,7 +355,7 @@ int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout);
 int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
 				u32 count);
 int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx);
-s32 wilc_del_all_rx_ba_session(struct wilc_vif *vif, char *pBSSID, char TID);
+int wilc_del_all_rx_ba_session(struct wilc_vif *vif, char *pBSSID, char TID);
 int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 			   u32 duration, u16 chan,
 			   wilc_remain_on_chan_expired expired,
-- 
2.6.4

