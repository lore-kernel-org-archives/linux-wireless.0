Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33322 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbcAEOHW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 09:07:22 -0500
Received: by mail-pa0-f54.google.com with SMTP id cy9so215790557pac.0
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2016 06:07:21 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 07/13] staging: wilc1000: rename IEsLen in wilc_scan
Date: Tue,  5 Jan 2016 23:06:51 +0900
Message-Id: <1452002817-30937-7-git-send-email-chaehyun.lim@gmail.com> (sfid-20160105_150726_503160_743DCBF9)
In-Reply-To: <1452002817-30937-1-git-send-email-chaehyun.lim@gmail.com>
References: <1452002817-30937-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames IEsLen to ies_len to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 3907717..67d0d14 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3674,7 +3674,7 @@ int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats)
 
 int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 	      u8 *ch_freq_list, u8 ch_list_len, const u8 *ies,
-	      size_t IEsLen, wilc_scan_result ScanResult, void *pvUserArg,
+	      size_t ies_len, wilc_scan_result ScanResult, void *pvUserArg,
 	      struct hidden_network *pstrHiddenNetwork)
 {
 	int result = 0;
@@ -3707,9 +3707,9 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 	msg.body.scan_info.ch_freq_list = kmalloc(ch_list_len, GFP_KERNEL);
 	memcpy(msg.body.scan_info.ch_freq_list, ch_freq_list, ch_list_len);
 
-	msg.body.scan_info.ies_len = IEsLen;
-	msg.body.scan_info.ies = kmalloc(IEsLen, GFP_KERNEL);
-	memcpy(msg.body.scan_info.ies, ies, IEsLen);
+	msg.body.scan_info.ies_len = ies_len;
+	msg.body.scan_info.ies = kmalloc(ies_len, GFP_KERNEL);
+	memcpy(msg.body.scan_info.ies, ies, ies_len);
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result) {
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index b7bcd93..ed00f9d 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -337,7 +337,7 @@ int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel);
 int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level);
 int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 	      u8 *ch_freq_list, u8 ch_list_len, const u8 *ies,
-	      size_t IEsLen, wilc_scan_result ScanResult, void *pvUserArg,
+	      size_t ies_len, wilc_scan_result ScanResult, void *pvUserArg,
 	      struct hidden_network *pstrHiddenNetwork);
 int wilc_hif_set_cfg(struct wilc_vif *vif,
 		     struct cfg_param_val *cfg_param);
-- 
2.6.4

