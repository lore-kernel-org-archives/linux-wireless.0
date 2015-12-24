Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33708 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933140AbbLXHw7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2015 02:52:59 -0500
Received: by mail-pa0-f48.google.com with SMTP id cy9so63011539pac.0
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2015 23:52:59 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 04/21] staging: wilc1000: rename pu8ssid in wilc_set_join_req
Date: Thu, 24 Dec 2015 16:52:22 +0900
Message-Id: <1450943559-20937-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20151224_092246_918280_992AABE3)
In-Reply-To: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
References: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pu8ssid to ssid to remove pu8 prefix.
There is no need to add this prefix in order to show data type of this
variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index bb4b612..a146d4f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3365,7 +3365,7 @@ int wilc_set_mac_address(struct wilc_vif *vif, u8 *mac_addr)
 	return result;
 }
 
-int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *pu8ssid,
+int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 		      size_t ssidLen, const u8 *pu8IEs, size_t IEsLen,
 		      wilc_connect_result pfConnectResult, void *pvUserArg,
 		      u8 u8security, enum AUTHTYPE tenuAuth_type,
@@ -3402,10 +3402,10 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *pu8ssid,
 		memcpy(msg.body.con_info.bssid, bssid, 6);
 	}
 
-	if (pu8ssid) {
+	if (ssid) {
 		msg.body.con_info.ssid_len = ssidLen;
 		msg.body.con_info.ssid = kmalloc(ssidLen, GFP_KERNEL);
-		memcpy(msg.body.con_info.ssid, pu8ssid, ssidLen);
+		memcpy(msg.body.con_info.ssid, ssid, ssidLen);
 	}
 
 	if (pu8IEs) {
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 0e40c8f..5d6f807 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -326,7 +326,7 @@ int wilc_set_pmkid_info(struct wilc_vif *vif,
 int wilc_get_mac_address(struct wilc_vif *vif, u8 *mac_addr);
 int wilc_set_mac_address(struct wilc_vif *vif, u8 *mac_addr);
 int wilc_wait_msg_queue_idle(void);
-int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *pu8ssid,
+int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 		      size_t ssidLen, const u8 *pu8IEs, size_t IEsLen,
 		      wilc_connect_result pfConnectResult, void *pvUserArg,
 		      u8 u8security, enum AUTHTYPE tenuAuth_type,
-- 
2.6.4

