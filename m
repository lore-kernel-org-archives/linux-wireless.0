Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:33301 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbcBLOFK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Feb 2016 09:05:10 -0500
Received: by mail-pa0-f67.google.com with SMTP id y7so665470paa.0
        for <linux-wireless@vger.kernel.org>; Fri, 12 Feb 2016 06:05:10 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 07/11] staging: wilc1000: define a new local variable in wilc_scan
Date: Fri, 12 Feb 2016 23:04:43 +0900
Message-Id: <1455285887-29946-7-git-send-email-chaehyun.lim@gmail.com> (sfid-20160212_150519_664307_04E5C28B)
In-Reply-To: <1455285887-29946-1-git-send-email-chaehyun.lim@gmail.com>
References: <1455285887-29946-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

struct scan_info is defined as a new local variable in wilc_scan
function. It makes some assignment short as well as improve more
readability.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a9c8b15..e9a6aa7 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3511,6 +3511,7 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 {
 	int result = 0;
 	struct host_if_msg msg;
+	struct scan_attr *scan_info = &msg.body.scan_info;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv || !scan_result) {
@@ -3523,26 +3524,26 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 	msg.id = HOST_IF_MSG_SCAN;
 
 	if (hidden_network) {
-		msg.body.scan_info.hidden_network.net_info = hidden_network->net_info;
-		msg.body.scan_info.hidden_network.n_ssids = hidden_network->n_ssids;
+		scan_info->hidden_network.net_info = hidden_network->net_info;
+		scan_info->hidden_network.n_ssids = hidden_network->n_ssids;
 	}
 
 	msg.vif = vif;
-	msg.body.scan_info.src = scan_source;
-	msg.body.scan_info.type = scan_type;
-	msg.body.scan_info.result = scan_result;
-	msg.body.scan_info.arg = user_arg;
-
-	msg.body.scan_info.ch_list_len = ch_list_len;
-	msg.body.scan_info.ch_freq_list = kmemdup(ch_freq_list,
-						  ch_list_len,
-						  GFP_KERNEL);
-	if (!msg.body.scan_info.ch_freq_list)
+	scan_info->src = scan_source;
+	scan_info->type = scan_type;
+	scan_info->result = scan_result;
+	scan_info->arg = user_arg;
+
+	scan_info->ch_list_len = ch_list_len;
+	scan_info->ch_freq_list = kmemdup(ch_freq_list,
+					  ch_list_len,
+					  GFP_KERNEL);
+	if (!scan_info->ch_freq_list)
 		return -ENOMEM;
 
-	msg.body.scan_info.ies_len = ies_len;
-	msg.body.scan_info.ies = kmemdup(ies, ies_len, GFP_KERNEL);
-	if (!msg.body.scan_info.ies)
+	scan_info->ies_len = ies_len;
+	scan_info->ies = kmemdup(ies, ies_len, GFP_KERNEL);
+	if (!scan_info->ies)
 		return -ENOMEM;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
-- 
2.7.1

