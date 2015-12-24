Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:34446 "EHLO
	mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933206AbbLXHxO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2015 02:53:14 -0500
Received: by mail-pf0-f171.google.com with SMTP id e65so12505824pfe.1
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2015 23:53:14 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 09/21] staging: wilc1000: rename pvUserArg in wilc_set_join_req
Date: Thu, 24 Dec 2015 16:52:27 +0900
Message-Id: <1450943559-20937-9-git-send-email-chaehyun.lim@gmail.com> (sfid-20151224_092249_191947_FBD0D345)
In-Reply-To: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
References: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pvUserArg to user_arg to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d691c95..1190359 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3367,7 +3367,7 @@ int wilc_set_mac_address(struct wilc_vif *vif, u8 *mac_addr)
 
 int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 		      size_t ssid_len, const u8 *ies, size_t ies_len,
-		      wilc_connect_result connect_result, void *pvUserArg,
+		      wilc_connect_result connect_result, void *user_arg,
 		      u8 u8security, enum AUTHTYPE tenuAuth_type,
 		      u8 u8channel, void *pJoinParams)
 {
@@ -3393,7 +3393,7 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 	msg.body.con_info.auth_type = tenuAuth_type;
 	msg.body.con_info.ch = u8channel;
 	msg.body.con_info.result = connect_result;
-	msg.body.con_info.arg = pvUserArg;
+	msg.body.con_info.arg = user_arg;
 	msg.body.con_info.params = pJoinParams;
 	msg.vif = vif;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index b426132..9e66d5e 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -328,7 +328,7 @@ int wilc_set_mac_address(struct wilc_vif *vif, u8 *mac_addr);
 int wilc_wait_msg_queue_idle(void);
 int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 		      size_t ssid_len, const u8 *ies, size_t ies_len,
-		      wilc_connect_result connect_result, void *pvUserArg,
+		      wilc_connect_result connect_result, void *user_arg,
 		      u8 u8security, enum AUTHTYPE tenuAuth_type,
 		      u8 u8channel, void *pJoinParams);
 int wilc_flush_join_req(struct wilc_vif *vif);
-- 
2.6.4

