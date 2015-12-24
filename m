Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33756 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933192AbbLXHxF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2015 02:53:05 -0500
Received: by mail-pa0-f48.google.com with SMTP id cy9so63012738pac.0
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2015 23:53:05 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 06/21] staging: wilc1000: rename pu8IEs in wilc_set_join_req
Date: Thu, 24 Dec 2015 16:52:24 +0900
Message-Id: <1450943559-20937-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20151224_092249_496203_4A6DBA5B)
In-Reply-To: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
References: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pu8IEs to ies to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 4730b60..bf1597c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3366,7 +3366,7 @@ int wilc_set_mac_address(struct wilc_vif *vif, u8 *mac_addr)
 }
 
 int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
-		      size_t ssid_len, const u8 *pu8IEs, size_t IEsLen,
+		      size_t ssid_len, const u8 *ies, size_t IEsLen,
 		      wilc_connect_result pfConnectResult, void *pvUserArg,
 		      u8 u8security, enum AUTHTYPE tenuAuth_type,
 		      u8 u8channel, void *pJoinParams)
@@ -3408,10 +3408,10 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 		memcpy(msg.body.con_info.ssid, ssid, ssid_len);
 	}
 
-	if (pu8IEs) {
+	if (ies) {
 		msg.body.con_info.ies_len = IEsLen;
 		msg.body.con_info.ies = kmalloc(IEsLen, GFP_KERNEL);
-		memcpy(msg.body.con_info.ies, pu8IEs, IEsLen);
+		memcpy(msg.body.con_info.ies, ies, IEsLen);
 	}
 	if (hif_drv->hif_state < HOST_IF_CONNECTING)
 		hif_drv->hif_state = HOST_IF_CONNECTING;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 4c4674b..44929a6 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -327,7 +327,7 @@ int wilc_get_mac_address(struct wilc_vif *vif, u8 *mac_addr);
 int wilc_set_mac_address(struct wilc_vif *vif, u8 *mac_addr);
 int wilc_wait_msg_queue_idle(void);
 int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
-		      size_t ssid_len, const u8 *pu8IEs, size_t IEsLen,
+		      size_t ssid_len, const u8 *ies, size_t IEsLen,
 		      wilc_connect_result pfConnectResult, void *pvUserArg,
 		      u8 u8security, enum AUTHTYPE tenuAuth_type,
 		      u8 u8channel, void *pJoinParams);
-- 
2.6.4

