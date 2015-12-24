Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:34934 "EHLO
	mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933231AbbLXHxb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2015 02:53:31 -0500
Received: by mail-pf0-f180.google.com with SMTP id 78so62820950pfw.2
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2015 23:53:31 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 15/21] staging: wilc1000: fix return type of wilc_disconnect
Date: Thu, 24 Dec 2015 16:52:33 +0900
Message-Id: <1450943559-20937-15-git-send-email-chaehyun.lim@gmail.com> (sfid-20151224_092250_084013_BCD12DDA)
In-Reply-To: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
References: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of wilc_disconnect from s32 to int.
The result variable gets return value from wilc_disconnect that has
return type of int. It should be changed return type of this function as
well as data type of result variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 6518942..5ddf78d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3461,9 +3461,9 @@ int wilc_flush_join_req(struct wilc_vif *vif)
 	return result;
 }
 
-s32 wilc_disconnect(struct wilc_vif *vif, u16 u16ReasonCode)
+int wilc_disconnect(struct wilc_vif *vif, u16 u16ReasonCode)
 {
-	s32 result = 0;
+	int result = 0;
 	struct host_if_msg msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 698d1b6..e8c556a 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -332,7 +332,7 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 		      u8 security, enum AUTHTYPE auth_type,
 		      u8 channel, void *join_params);
 int wilc_flush_join_req(struct wilc_vif *vif);
-s32 wilc_disconnect(struct wilc_vif *vif, u16 u16ReasonCode);
+int wilc_disconnect(struct wilc_vif *vif, u16 u16ReasonCode);
 int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel);
 s32 wilc_get_rssi(struct wilc_vif *vif, s8 *ps8Rssi);
 s32 wilc_scan(struct wilc_vif *vif, u8 u8ScanSource, u8 u8ScanType,
-- 
2.6.4

