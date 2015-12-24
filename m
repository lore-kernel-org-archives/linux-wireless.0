Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:36823 "EHLO
	mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933188AbbLXHxC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2015 02:53:02 -0500
Received: by mail-pf0-f180.google.com with SMTP id 65so20558485pff.3
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2015 23:53:02 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 05/21] staging: wilc1000: rename ssidLen in wilc_set_join_req
Date: Thu, 24 Dec 2015 16:52:23 +0900
Message-Id: <1450943559-20937-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20151224_085331_130326_A8FE7033)
In-Reply-To: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
References: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames ssidLen to ssid_len to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a146d4f..4730b60 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3366,7 +3366,7 @@ int wilc_set_mac_address(struct wilc_vif *vif, u8 *mac_addr)
 }
 
 int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
-		      size_t ssidLen, const u8 *pu8IEs, size_t IEsLen,
+		      size_t ssid_len, const u8 *pu8IEs, size_t IEsLen,
 		      wilc_connect_result pfConnectResult, void *pvUserArg,
 		      u8 u8security, enum AUTHTYPE tenuAuth_type,
 		      u8 u8channel, void *pJoinParams)
@@ -3403,9 +3403,9 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 	}
 
 	if (ssid) {
-		msg.body.con_info.ssid_len = ssidLen;
-		msg.body.con_info.ssid = kmalloc(ssidLen, GFP_KERNEL);
-		memcpy(msg.body.con_info.ssid, ssid, ssidLen);
+		msg.body.con_info.ssid_len = ssid_len;
+		msg.body.con_info.ssid = kmalloc(ssid_len, GFP_KERNEL);
+		memcpy(msg.body.con_info.ssid, ssid, ssid_len);
 	}
 
 	if (pu8IEs) {
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 5d6f807..4c4674b 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -327,7 +327,7 @@ int wilc_get_mac_address(struct wilc_vif *vif, u8 *mac_addr);
 int wilc_set_mac_address(struct wilc_vif *vif, u8 *mac_addr);
 int wilc_wait_msg_queue_idle(void);
 int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
-		      size_t ssidLen, const u8 *pu8IEs, size_t IEsLen,
+		      size_t ssid_len, const u8 *pu8IEs, size_t IEsLen,
 		      wilc_connect_result pfConnectResult, void *pvUserArg,
 		      u8 u8security, enum AUTHTYPE tenuAuth_type,
 		      u8 u8channel, void *pJoinParams);
-- 
2.6.4

