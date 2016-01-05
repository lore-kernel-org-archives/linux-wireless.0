Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:34951 "EHLO
	mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbcAEOHH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 09:07:07 -0500
Received: by mail-pf0-f177.google.com with SMTP id 78so223447049pfw.2
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2016 06:07:06 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 02/13] staging: wilc1000: rename u8ScanSource in wilc_scan
Date: Tue,  5 Jan 2016 23:06:46 +0900
Message-Id: <1452002817-30937-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20160105_150710_004933_8013F014)
In-Reply-To: <1452002817-30937-1-git-send-email-chaehyun.lim@gmail.com>
References: <1452002817-30937-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u8ScanSource to scan_source to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 7581c8f..f32cb76 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3672,7 +3672,7 @@ int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats)
 	return result;
 }
 
-int wilc_scan(struct wilc_vif *vif, u8 u8ScanSource, u8 u8ScanType,
+int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 u8ScanType,
 	      u8 *pu8ChnlFreqList, u8 u8ChnlListLen, const u8 *pu8IEs,
 	      size_t IEsLen, wilc_scan_result ScanResult, void *pvUserArg,
 	      struct hidden_network *pstrHiddenNetwork)
@@ -3698,7 +3698,7 @@ int wilc_scan(struct wilc_vif *vif, u8 u8ScanSource, u8 u8ScanType,
 		PRINT_D(HOSTINF_DBG, "pstrHiddenNetwork IS EQUAL TO NULL\n");
 
 	msg.vif = vif;
-	msg.body.scan_info.src = u8ScanSource;
+	msg.body.scan_info.src = scan_source;
 	msg.body.scan_info.type = u8ScanType;
 	msg.body.scan_info.result = ScanResult;
 	msg.body.scan_info.arg = pvUserArg;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 4ff6b4f..fc71f16 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -335,7 +335,7 @@ int wilc_flush_join_req(struct wilc_vif *vif);
 int wilc_disconnect(struct wilc_vif *vif, u16 reason_code);
 int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel);
 int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level);
-int wilc_scan(struct wilc_vif *vif, u8 u8ScanSource, u8 u8ScanType,
+int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 u8ScanType,
 	      u8 *pu8ChnlFreqList, u8 u8ChnlListLen, const u8 *pu8IEs,
 	      size_t IEsLen, wilc_scan_result ScanResult, void *pvUserArg,
 	      struct hidden_network *pstrHiddenNetwork);
-- 
2.6.4

