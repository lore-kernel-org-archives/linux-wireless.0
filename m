Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35774 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804AbbLXHw4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2015 02:52:56 -0500
Received: by mail-pa0-f45.google.com with SMTP id jx14so118480327pad.2
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2015 23:52:56 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 03/21] staging: wilc1000: rename pu8bssid in wilc_set_join_req
Date: Thu, 24 Dec 2015 16:52:21 +0900
Message-Id: <1450943559-20937-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20151224_085327_266805_4CECE441)
In-Reply-To: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
References: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pu8bssid to bssid to remove pu8 prefix.
There is no need to add this prefix in order to show data type of this
variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b24697b..bb4b612 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3365,7 +3365,7 @@ int wilc_set_mac_address(struct wilc_vif *vif, u8 *mac_addr)
 	return result;
 }
 
-int wilc_set_join_req(struct wilc_vif *vif, u8 *pu8bssid, const u8 *pu8ssid,
+int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *pu8ssid,
 		      size_t ssidLen, const u8 *pu8IEs, size_t IEsLen,
 		      wilc_connect_result pfConnectResult, void *pvUserArg,
 		      u8 u8security, enum AUTHTYPE tenuAuth_type,
@@ -3397,9 +3397,9 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *pu8bssid, const u8 *pu8ssid,
 	msg.body.con_info.params = pJoinParams;
 	msg.vif = vif;
 
-	if (pu8bssid) {
+	if (bssid) {
 		msg.body.con_info.bssid = kmalloc(6, GFP_KERNEL);
-		memcpy(msg.body.con_info.bssid, pu8bssid, 6);
+		memcpy(msg.body.con_info.bssid, bssid, 6);
 	}
 
 	if (pu8ssid) {
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index eaf3a10..0e40c8f 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -326,7 +326,7 @@ int wilc_set_pmkid_info(struct wilc_vif *vif,
 int wilc_get_mac_address(struct wilc_vif *vif, u8 *mac_addr);
 int wilc_set_mac_address(struct wilc_vif *vif, u8 *mac_addr);
 int wilc_wait_msg_queue_idle(void);
-int wilc_set_join_req(struct wilc_vif *vif, u8 *pu8bssid, const u8 *pu8ssid,
+int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *pu8ssid,
 		      size_t ssidLen, const u8 *pu8IEs, size_t IEsLen,
 		      wilc_connect_result pfConnectResult, void *pvUserArg,
 		      u8 u8security, enum AUTHTYPE tenuAuth_type,
-- 
2.6.4

