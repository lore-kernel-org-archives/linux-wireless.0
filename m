Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:35970 "EHLO
	mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815AbbLXHx0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2015 02:53:26 -0500
Received: by mail-pf0-f170.google.com with SMTP id 65so20563180pff.3
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2015 23:53:25 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 13/21] staging: wilc1000: rename pJoinParams in wilc_set_join_req
Date: Thu, 24 Dec 2015 16:52:31 +0900
Message-Id: <1450943559-20937-13-git-send-email-chaehyun.lim@gmail.com> (sfid-20151224_092246_510344_AA0A55D1)
In-Reply-To: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
References: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pJoinParams to join_params to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 66abfa7..79f3d9f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3369,7 +3369,7 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 		      size_t ssid_len, const u8 *ies, size_t ies_len,
 		      wilc_connect_result connect_result, void *user_arg,
 		      u8 security, enum AUTHTYPE auth_type,
-		      u8 channel, void *pJoinParams)
+		      u8 channel, void *join_params)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -3380,7 +3380,7 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 		return -EFAULT;
 	}
 
-	if (!pJoinParams) {
+	if (!join_params) {
 		PRINT_ER("Unable to Join - JoinParams is NULL\n");
 		return -EFAULT;
 	}
@@ -3394,7 +3394,7 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 	msg.body.con_info.ch = channel;
 	msg.body.con_info.result = connect_result;
 	msg.body.con_info.arg = user_arg;
-	msg.body.con_info.params = pJoinParams;
+	msg.body.con_info.params = join_params;
 	msg.vif = vif;
 
 	if (bssid) {
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index b12c04f..698d1b6 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -330,7 +330,7 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 		      size_t ssid_len, const u8 *ies, size_t ies_len,
 		      wilc_connect_result connect_result, void *user_arg,
 		      u8 security, enum AUTHTYPE auth_type,
-		      u8 channel, void *pJoinParams);
+		      u8 channel, void *join_params);
 int wilc_flush_join_req(struct wilc_vif *vif);
 s32 wilc_disconnect(struct wilc_vif *vif, u16 u16ReasonCode);
 int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel);
-- 
2.6.4

