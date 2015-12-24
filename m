Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:32997 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933192AbbLXHxn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2015 02:53:43 -0500
Received: by mail-pa0-f54.google.com with SMTP id cy9so63020269pac.0
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2015 23:53:43 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 19/21] staging: wilc1000: rename ps8Rssi in wilc_get_rssi
Date: Thu, 24 Dec 2015 16:52:37 +0900
Message-Id: <1450943559-20937-19-git-send-email-chaehyun.lim@gmail.com> (sfid-20151224_092247_449971_D930DAF2)
In-Reply-To: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
References: <1450943559-20937-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames ps8Rssi to rssi_level to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c059e6d..e1e123b 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3628,7 +3628,7 @@ s32 wilc_get_inactive_time(struct wilc_vif *vif, const u8 *mac,
 	return result;
 }
 
-int wilc_get_rssi(struct wilc_vif *vif, s8 *ps8Rssi)
+int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -3646,12 +3646,12 @@ int wilc_get_rssi(struct wilc_vif *vif, s8 *ps8Rssi)
 
 	down(&hif_drv->sem_get_rssi);
 
-	if (!ps8Rssi) {
+	if (!rssi_level) {
 		PRINT_ER("RSS pointer value is null");
 		return -EFAULT;
 	}
 
-	*ps8Rssi = rssi;
+	*rssi_level = rssi;
 
 	return result;
 }
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 51ec72c..4506e0b 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -334,7 +334,7 @@ int wilc_set_join_req(struct wilc_vif *vif, u8 *bssid, const u8 *ssid,
 int wilc_flush_join_req(struct wilc_vif *vif);
 int wilc_disconnect(struct wilc_vif *vif, u16 reason_code);
 int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel);
-int wilc_get_rssi(struct wilc_vif *vif, s8 *ps8Rssi);
+int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level);
 s32 wilc_scan(struct wilc_vif *vif, u8 u8ScanSource, u8 u8ScanType,
 	      u8 *pu8ChnlFreqList, u8 u8ChnlListLen, const u8 *pu8IEs,
 	      size_t IEsLen, wilc_scan_result ScanResult, void *pvUserArg,
-- 
2.6.4

