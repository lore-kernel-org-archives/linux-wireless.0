Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:34590 "EHLO
	mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933209AbbLXHxf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2015 02:53:35 -0500
Received: by mail-pf0-f177.google.com with SMTP id e65so12509874pfe.1
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2015 23:53:35 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 16/21] staging: wilc1000: rename u16ReasonCode in wilc_disconnect
Date: Thu, 24 Dec 2015 16:52:34 +0900
Message-Id: <1450943559-20937-16-git-send-email-chaehyun.lim@gmail.com> (sfid-20151224_092248_213075_6752DF95)
In-Reply-To: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
References: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u16ReasonCode to reason_code to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 5ddf78d..6e5bccc 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3461,7 +3461,7 @@ int wilc_flush_join_req(struct wilc_vif *vif)
 	return result;
 }
 
-int wilc_disconnect(struct wilc_vif *vif, u16 u16ReasonCode)
+int wilc_disconnect(struct wilc_vif *vif, u16 reason_code)
 {
 	int result = 0;
 	struct host_if_msg msg;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index e8c556a..fa5d292 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -332,7 +332,7 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 		      u8 security, enum AUTHTYPE auth_type,
 		      u8 channel, void *join_params);
 int wilc_flush_join_req(struct wilc_vif *vif);
-int wilc_disconnect(struct wilc_vif *vif, u16 u16ReasonCode);
+int wilc_disconnect(struct wilc_vif *vif, u16 reason_code);
 int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel);
 s32 wilc_get_rssi(struct wilc_vif *vif, s8 *ps8Rssi);
 s32 wilc_scan(struct wilc_vif *vif, u8 u8ScanSource, u8 u8ScanType,
-- 
2.6.4

