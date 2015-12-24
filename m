Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:35908 "EHLO
	mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933207AbbLXHxR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2015 02:53:17 -0500
Received: by mail-pf0-f178.google.com with SMTP id 65so20561484pff.3
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2015 23:53:16 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 10/21] staging: wilc1000: rename u8security in wilc_set_join_req
Date: Thu, 24 Dec 2015 16:52:28 +0900
Message-Id: <1450943559-20937-10-git-send-email-chaehyun.lim@gmail.com> (sfid-20151224_085336_638935_4CE1901B)
In-Reply-To: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
References: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u8security to security to remove u8 prefix.
There is no need to add prefix in order to show data type of this
variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 1190359..64189fa 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3368,7 +3368,7 @@ int wilc_set_mac_address(struct wilc_vif *vif, u8 *mac_addr)
 int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 		      size_t ssid_len, const u8 *ies, size_t ies_len,
 		      wilc_connect_result connect_result, void *user_arg,
-		      u8 u8security, enum AUTHTYPE tenuAuth_type,
+		      u8 security, enum AUTHTYPE tenuAuth_type,
 		      u8 u8channel, void *pJoinParams)
 {
 	int result = 0;
@@ -3389,7 +3389,7 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 
 	msg.id = HOST_IF_MSG_CONNECT;
 
-	msg.body.con_info.security = u8security;
+	msg.body.con_info.security = security;
 	msg.body.con_info.auth_type = tenuAuth_type;
 	msg.body.con_info.ch = u8channel;
 	msg.body.con_info.result = connect_result;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 9e66d5e..bb08e7f 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -329,7 +329,7 @@ int wilc_wait_msg_queue_idle(void);
 int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 		      size_t ssid_len, const u8 *ies, size_t ies_len,
 		      wilc_connect_result connect_result, void *user_arg,
-		      u8 u8security, enum AUTHTYPE tenuAuth_type,
+		      u8 security, enum AUTHTYPE tenuAuth_type,
 		      u8 u8channel, void *pJoinParams);
 int wilc_flush_join_req(struct wilc_vif *vif);
 s32 wilc_disconnect(struct wilc_vif *vif, u16 u16ReasonCode);
-- 
2.6.4

