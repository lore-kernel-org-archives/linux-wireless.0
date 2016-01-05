Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36661 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbcAEOHb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 09:07:31 -0500
Received: by mail-pa0-f41.google.com with SMTP id yy13so123272972pab.3
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2016 06:07:31 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 10/13] staging: wilc1000: rename pstrHiddenNetwork in wilc_scan
Date: Tue,  5 Jan 2016 23:06:54 +0900
Message-Id: <1452002817-30937-10-git-send-email-chaehyun.lim@gmail.com> (sfid-20160105_150734_472992_FFA94D71)
In-Reply-To: <1452002817-30937-1-git-send-email-chaehyun.lim@gmail.com>
References: <1452002817-30937-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pstrHiddenNetwork to hidden_network to avoid
camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 +++++-----
 drivers/staging/wilc1000/host_interface.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 1e27431..85aae56 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3675,7 +3675,7 @@ int wilc_get_statistics(struct wilc_vif *vif, struct rf_info *stats)
 int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 	      u8 *ch_freq_list, u8 ch_list_len, const u8 *ies,
 	      size_t ies_len, wilc_scan_result scan_result, void *user_arg,
-	      struct hidden_network *pstrHiddenNetwork)
+	      struct hidden_network *hidden_network)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -3690,12 +3690,12 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 
 	msg.id = HOST_IF_MSG_SCAN;
 
-	if (pstrHiddenNetwork) {
-		msg.body.scan_info.hidden_network.net_info = pstrHiddenNetwork->net_info;
-		msg.body.scan_info.hidden_network.n_ssids = pstrHiddenNetwork->n_ssids;
+	if (hidden_network) {
+		msg.body.scan_info.hidden_network.net_info = hidden_network->net_info;
+		msg.body.scan_info.hidden_network.n_ssids = hidden_network->n_ssids;
 
 	} else
-		PRINT_D(HOSTINF_DBG, "pstrHiddenNetwork IS EQUAL TO NULL\n");
+		PRINT_D(HOSTINF_DBG, "hidden_network IS EQUAL TO NULL\n");
 
 	msg.vif = vif;
 	msg.body.scan_info.src = scan_source;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 693a3f5..b58c33a 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -338,7 +338,7 @@ int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level);
 int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 	      u8 *ch_freq_list, u8 ch_list_len, const u8 *ies,
 	      size_t ies_len, wilc_scan_result scan_result, void *user_arg,
-	      struct hidden_network *pstrHiddenNetwork);
+	      struct hidden_network *hidden_network);
 int wilc_hif_set_cfg(struct wilc_vif *vif,
 		     struct cfg_param_val *cfg_param);
 s32 wilc_init(struct net_device *dev, struct host_if_drv **phWFIDrv);
-- 
2.6.4

