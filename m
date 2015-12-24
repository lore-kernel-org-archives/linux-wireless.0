Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:33114 "EHLO
	mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933198AbbLXHxL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2015 02:53:11 -0500
Received: by mail-pf0-f179.google.com with SMTP id q63so29060646pfb.0
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2015 23:53:11 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 08/21] staging: wilc1000: rename pfConnectResult in wilc_set_join_req
Date: Thu, 24 Dec 2015 16:52:26 +0900
Message-Id: <1450943559-20937-8-git-send-email-chaehyun.lim@gmail.com> (sfid-20151224_085334_022010_0E7DFF03)
In-Reply-To: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
References: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pfConnectResult to connect_result to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 4421bab..d691c95 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3367,7 +3367,7 @@ int wilc_set_mac_address(struct wilc_vif *vif, u8 *mac_addr)
 
 int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 		      size_t ssid_len, const u8 *ies, size_t ies_len,
-		      wilc_connect_result pfConnectResult, void *pvUserArg,
+		      wilc_connect_result connect_result, void *pvUserArg,
 		      u8 u8security, enum AUTHTYPE tenuAuth_type,
 		      u8 u8channel, void *pJoinParams)
 {
@@ -3375,7 +3375,7 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 	struct host_if_msg msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
-	if (!hif_drv || !pfConnectResult) {
+	if (!hif_drv || !connect_result) {
 		PRINT_ER("Driver is null\n");
 		return -EFAULT;
 	}
@@ -3392,7 +3392,7 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 	msg.body.con_info.security = u8security;
 	msg.body.con_info.auth_type = tenuAuth_type;
 	msg.body.con_info.ch = u8channel;
-	msg.body.con_info.result = pfConnectResult;
+	msg.body.con_info.result = connect_result;
 	msg.body.con_info.arg = pvUserArg;
 	msg.body.con_info.params = pJoinParams;
 	msg.vif = vif;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 5edb178..b426132 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -328,7 +328,7 @@ int wilc_set_mac_address(struct wilc_vif *vif, u8 *mac_addr);
 int wilc_wait_msg_queue_idle(void);
 int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 		      size_t ssid_len, const u8 *ies, size_t ies_len,
-		      wilc_connect_result pfConnectResult, void *pvUserArg,
+		      wilc_connect_result connect_result, void *pvUserArg,
 		      u8 u8security, enum AUTHTYPE tenuAuth_type,
 		      u8 u8channel, void *pJoinParams);
 int wilc_flush_join_req(struct wilc_vif *vif);
-- 
2.6.4

