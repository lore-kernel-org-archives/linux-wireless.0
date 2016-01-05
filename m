Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:35034 "EHLO
	mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbcAEOHT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 09:07:19 -0500
Received: by mail-pf0-f182.google.com with SMTP id 78so223449370pfw.2
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2016 06:07:19 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 06/13] staging: wilc1000: rename pu8IEs in wilc_scan
Date: Tue,  5 Jan 2016 23:06:50 +0900
Message-Id: <1452002817-30937-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20160105_150723_127404_E0A075AF)
In-Reply-To: <1452002817-30937-1-git-send-email-chaehyun.lim@gmail.com>
References: <1452002817-30937-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pu8IEs to ies to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 07ff083..3907717 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3673,7 +3673,7 @@ int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats)
 }
 
 int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
-	      u8 *ch_freq_list, u8 ch_list_len, const u8 *pu8IEs,
+	      u8 *ch_freq_list, u8 ch_list_len, const u8 *ies,
 	      size_t IEsLen, wilc_scan_result ScanResult, void *pvUserArg,
 	      struct hidden_network *pstrHiddenNetwork)
 {
@@ -3709,7 +3709,7 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 
 	msg.body.scan_info.ies_len = IEsLen;
 	msg.body.scan_info.ies = kmalloc(IEsLen, GFP_KERNEL);
-	memcpy(msg.body.scan_info.ies, pu8IEs, IEsLen);
+	memcpy(msg.body.scan_info.ies, ies, IEsLen);
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
 	if (result) {
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 7d7675a..b7bcd93 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -336,7 +336,7 @@ int wilc_disconnect(struct wilc_vif *vif, u16 reason_code);
 int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel);
 int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level);
 int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
-	      u8 *ch_freq_list, u8 ch_list_len, const u8 *pu8IEs,
+	      u8 *ch_freq_list, u8 ch_list_len, const u8 *ies,
 	      size_t IEsLen, wilc_scan_result ScanResult, void *pvUserArg,
 	      struct hidden_network *pstrHiddenNetwork);
 int wilc_hif_set_cfg(struct wilc_vif *vif,
-- 
2.6.4

