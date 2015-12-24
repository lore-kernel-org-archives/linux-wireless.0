Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36172 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933265AbbLXHxl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2015 02:53:41 -0500
Received: by mail-pa0-f42.google.com with SMTP id q3so124623343pav.3
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2015 23:53:40 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 18/21] staging: wilc1000: fix return type of wilc_get_rssi
Date: Thu, 24 Dec 2015 16:52:36 +0900
Message-Id: <1450943559-20937-18-git-send-email-chaehyun.lim@gmail.com> (sfid-20151224_092248_768597_4FEDE5AA)
In-Reply-To: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
References: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of wilc_get_rssi from s32 to int.
The result variable gets return value from wilc_mq_send that has return
type of int. It should be changed return type of this function as well
as data type of result variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 724b4bd..c059e6d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3628,9 +3628,9 @@ s32 wilc_get_inactive_time(struct wilc_vif *vif, const u8 *mac,
 	return result;
 }
 
-s32 wilc_get_rssi(struct wilc_vif *vif, s8 *ps8Rssi)
+int wilc_get_rssi(struct wilc_vif *vif, s8 *ps8Rssi)
 {
-	s32 result = 0;
+	int result = 0;
 	struct host_if_msg msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 7ac85f2..51ec72c 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -334,7 +334,7 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 int wilc_flush_join_req(struct wilc_vif *vif);
 int wilc_disconnect(struct wilc_vif *vif, u16 reason_code);
 int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel);
-s32 wilc_get_rssi(struct wilc_vif *vif, s8 *ps8Rssi);
+int wilc_get_rssi(struct wilc_vif *vif, s8 *ps8Rssi);
 s32 wilc_scan(struct wilc_vif *vif, u8 u8ScanSource, u8 u8ScanType,
 	      u8 *pu8ChnlFreqList, u8 u8ChnlListLen, const u8 *pu8IEs,
 	      size_t IEsLen, wilc_scan_result ScanResult, void *pvUserArg,
-- 
2.6.4

