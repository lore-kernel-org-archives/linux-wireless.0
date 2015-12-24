Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:32835 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933209AbbLXHxU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2015 02:53:20 -0500
Received: by mail-pa0-f53.google.com with SMTP id cy9so63015675pac.0
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2015 23:53:19 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 11/21] staging: wilc1000: rename tenuAuth_type in wilc_set_join_req
Date: Thu, 24 Dec 2015 16:52:29 +0900
Message-Id: <1450943559-20937-11-git-send-email-chaehyun.lim@gmail.com> (sfid-20151224_085346_796817_4BE5A31B)
In-Reply-To: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
References: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames tenuAuth_type to auth_type to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 64189fa..d3c595e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3368,7 +3368,7 @@ int wilc_set_mac_address(struct wilc_vif *vif, u8 *mac_addr)
 int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 		      size_t ssid_len, const u8 *ies, size_t ies_len,
 		      wilc_connect_result connect_result, void *user_arg,
-		      u8 security, enum AUTHTYPE tenuAuth_type,
+		      u8 security, enum AUTHTYPE auth_type,
 		      u8 u8channel, void *pJoinParams)
 {
 	int result = 0;
@@ -3390,7 +3390,7 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 	msg.id = HOST_IF_MSG_CONNECT;
 
 	msg.body.con_info.security = security;
-	msg.body.con_info.auth_type = tenuAuth_type;
+	msg.body.con_info.auth_type = auth_type;
 	msg.body.con_info.ch = u8channel;
 	msg.body.con_info.result = connect_result;
 	msg.body.con_info.arg = user_arg;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index bb08e7f..3d5fea7 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -329,7 +329,7 @@ int wilc_wait_msg_queue_idle(void);
 int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 		      size_t ssid_len, const u8 *ies, size_t ies_len,
 		      wilc_connect_result connect_result, void *user_arg,
-		      u8 security, enum AUTHTYPE tenuAuth_type,
+		      u8 security, enum AUTHTYPE auth_type,
 		      u8 u8channel, void *pJoinParams);
 int wilc_flush_join_req(struct wilc_vif *vif);
 s32 wilc_disconnect(struct wilc_vif *vif, u16 u16ReasonCode);
-- 
2.6.4

