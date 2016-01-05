Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35803 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbcAEOH2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 09:07:28 -0500
Received: by mail-pa0-f47.google.com with SMTP id do7so6196787pab.2
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2016 06:07:28 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 09/13] staging: wilc1000: rename pvUserArg in wilc_scan
Date: Tue,  5 Jan 2016 23:06:53 +0900
Message-Id: <1452002817-30937-9-git-send-email-chaehyun.lim@gmail.com> (sfid-20160105_150731_183740_1DFE3D02)
In-Reply-To: <1452002817-30937-1-git-send-email-chaehyun.lim@gmail.com>
References: <1452002817-30937-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pvUserArg to user_arg to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a1e9052..1e27431 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3674,7 +3674,7 @@ int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats)
 
 int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 	      u8 *ch_freq_list, u8 ch_list_len, const u8 *ies,
-	      size_t ies_len, wilc_scan_result scan_result, void *pvUserArg,
+	      size_t ies_len, wilc_scan_result scan_result, void *user_arg,
 	      struct hidden_network *pstrHiddenNetwork)
 {
 	int result = 0;
@@ -3701,7 +3701,7 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 	msg.body.scan_info.src = scan_source;
 	msg.body.scan_info.type = scan_type;
 	msg.body.scan_info.result = scan_result;
-	msg.body.scan_info.arg = pvUserArg;
+	msg.body.scan_info.arg = user_arg;
 
 	msg.body.scan_info.ch_list_len = ch_list_len;
 	msg.body.scan_info.ch_freq_list = kmalloc(ch_list_len, GFP_KERNEL);
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index fd9f21739..693a3f5 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -337,7 +337,7 @@ int wilc_set_mac_chnl_num(struct wilc_vif *vif, u8 channel);
 int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level);
 int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 	      u8 *ch_freq_list, u8 ch_list_len, const u8 *ies,
-	      size_t ies_len, wilc_scan_result scan_result, void *pvUserArg,
+	      size_t ies_len, wilc_scan_result scan_result, void *user_arg,
 	      struct hidden_network *pstrHiddenNetwork);
 int wilc_hif_set_cfg(struct wilc_vif *vif,
 		     struct cfg_param_val *cfg_param);
-- 
2.6.4

