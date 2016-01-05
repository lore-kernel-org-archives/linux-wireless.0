Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:33847 "EHLO
	mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbcAEOHQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 09:07:16 -0500
Received: by mail-pf0-f169.google.com with SMTP id e65so167951214pfe.1
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2016 06:07:15 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 05/13] staging: wilc1000: rename u8ChnlListLen in wilc_scan
Date: Tue,  5 Jan 2016 23:06:49 +0900
Message-Id: <1452002817-30937-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20160105_150719_401129_482DB0CF)
In-Reply-To: <1452002817-30937-1-git-send-email-chaehyun.lim@gmail.com>
References: <1452002817-30937-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames u8ChnlListLen to ch_list_len to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 48c40de..07ff083 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3673,7 +3673,7 @@ int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats)
 }
 
 int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
-	      u8 *ch_freq_list, u8 u8ChnlListLen, const u8 *pu8IEs,
+	      u8 *ch_freq_list, u8 ch_list_len, const u8 *pu8IEs,
 	      size_t IEsLen, wilc_scan_result ScanResult, void *pvUserArg,
 	      struct hidden_network *pstrHiddenNetwork)
 {
@@ -3703,9 +3703,9 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 	msg.body.scan_info.result = ScanResult;
 	msg.body.scan_info.arg = pvUserArg;
 
-	msg.body.scan_info.ch_list_len = u8ChnlListLen;
-	msg.body.scan_info.ch_freq_list = kmalloc(u8ChnlListLen, GFP_KERNEL);
-	memcpy(msg.body.scan_info.ch_freq_list, ch_freq_list, u8ChnlListLen);
+	msg.body.scan_info.ch_list_len = ch_list_len;
+	msg.body.scan_info.ch_freq_list = kmalloc(ch_list_len, GFP_KERNEL);
+	memcpy(msg.body.scan_info.ch_freq_list, ch_freq_list, ch_list_len);
 
 	msg.body.scan_info.ies_len = IEsLen;
 	msg.body.scan_info.ies = kmalloc(IEsLen, GFP_KERNEL);
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 998d449..7d7675a 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -336,7 +336,7 @@ int wilc_disconnect(struct wilc_vif *vif, u16 reason_code);
 int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel);
 int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level);
 int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
-	      u8 *ch_freq_list, u8 u8ChnlListLen, const u8 *pu8IEs,
+	      u8 *ch_freq_list, u8 ch_list_len, const u8 *pu8IEs,
 	      size_t IEsLen, wilc_scan_result ScanResult, void *pvUserArg,
 	      struct hidden_network *pstrHiddenNetwork);
 int wilc_hif_set_cfg(struct wilc_vif *vif,
-- 
2.6.4

