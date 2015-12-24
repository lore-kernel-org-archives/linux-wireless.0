Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:34507 "EHLO
	mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933211AbbLXHxX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2015 02:53:23 -0500
Received: by mail-pf0-f182.google.com with SMTP id e65so12507480pfe.1
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2015 23:53:22 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 12/21] staging: wilc1000: rename u8channel in wilc_set_join_req
Date: Thu, 24 Dec 2015 16:52:30 +0900
Message-Id: <1450943559-20937-12-git-send-email-chaehyun.lim@gmail.com> (sfid-20151224_085339_914740_DB10C466)
In-Reply-To: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
References: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u8channel to channel to remove u8 prefix.
There is no need to add prefix in order to show data type of this
variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d3c595e..66abfa7 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3369,7 +3369,7 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 		      size_t ssid_len, const u8 *ies, size_t ies_len,
 		      wilc_connect_result connect_result, void *user_arg,
 		      u8 security, enum AUTHTYPE auth_type,
-		      u8 u8channel, void *pJoinParams)
+		      u8 channel, void *pJoinParams)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -3391,7 +3391,7 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 
 	msg.body.con_info.security = security;
 	msg.body.con_info.auth_type = auth_type;
-	msg.body.con_info.ch = u8channel;
+	msg.body.con_info.ch = channel;
 	msg.body.con_info.result = connect_result;
 	msg.body.con_info.arg = user_arg;
 	msg.body.con_info.params = pJoinParams;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 3d5fea7..b12c04f 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -330,7 +330,7 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 		      size_t ssid_len, const u8 *ies, size_t ies_len,
 		      wilc_connect_result connect_result, void *user_arg,
 		      u8 security, enum AUTHTYPE auth_type,
-		      u8 u8channel, void *pJoinParams);
+		      u8 channel, void *pJoinParams);
 int wilc_flush_join_req(struct wilc_vif *vif);
 s32 wilc_disconnect(struct wilc_vif *vif, u16 u16ReasonCode);
 int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel);
-- 
2.6.4

