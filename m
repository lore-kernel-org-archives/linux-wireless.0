Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34217 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbcACIgp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2016 03:36:45 -0500
Received: by mail-pa0-f47.google.com with SMTP id uo6so161303106pac.1
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jan 2016 00:36:45 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 10/30] staging: wilc1000: rename TID in wilc_del_all_rx_ba_session
Date: Sun,  3 Jan 2016 17:35:42 +0900
Message-Id: <1451810162-16993-10-git-send-email-chaehyun.lim@gmail.com> (sfid-20160103_093653_093312_514D7F67)
In-Reply-To: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
References: <1451810162-16993-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames TID to tid to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 735e6f1..265c42b 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -4605,7 +4605,7 @@ static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo)
 	return (void *)pNewJoinBssParam;
 }
 
-int wilc_del_all_rx_ba_session(struct wilc_vif *vif, char *bssid, char TID)
+int wilc_del_all_rx_ba_session(struct wilc_vif *vif, char *bssid, char tid)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -4622,7 +4622,7 @@ int wilc_del_all_rx_ba_session(struct wilc_vif *vif, char *bssid, char TID)
 	msg.id = HOST_IF_MSG_DEL_ALL_RX_BA_SESSIONS;
 
 	memcpy(pBASessionInfo->bssid, bssid, ETH_ALEN);
-	pBASessionInfo->tid = TID;
+	pBASessionInfo->tid = tid;
 	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 5f7156e..6c8fe3a 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -355,7 +355,7 @@ int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout);
 int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
 				u32 count);
 int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx);
-int wilc_del_all_rx_ba_session(struct wilc_vif *vif, char *bssid, char TID);
+int wilc_del_all_rx_ba_session(struct wilc_vif *vif, char *bssid, char tid);
 int wilc_remain_on_channel(struct wilc_vif *vif, u32 session_id,
 			   u32 duration, u16 chan,
 			   wilc_remain_on_chan_expired expired,
-- 
2.6.4

