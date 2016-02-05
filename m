Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35354 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbcBEBfj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 20:35:39 -0500
Received: by mail-pa0-f53.google.com with SMTP id ho8so24918955pac.2
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2016 17:35:39 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 2/8] staging: wilc1000: rename pstrCfgParamVal in wilc_hif_set_cfg
Date: Fri,  5 Feb 2016 10:35:12 +0900
Message-Id: <1454636118-9943-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20160205_023542_898605_EF30FC47)
In-Reply-To: <1454636118-9943-1-git-send-email-chaehyun.lim@gmail.com>
References: <1454636118-9943-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames pstrCfgParamVal to cfg_param to avoid camelcase.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a5b7dd1..0f8175f 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3730,7 +3730,7 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 }
 
 int wilc_hif_set_cfg(struct wilc_vif *vif,
-		     struct cfg_param_val *pstrCfgParamVal)
+		     struct cfg_param_val *cfg_param)
 {
 	int result = 0;
 	struct host_if_msg msg;
@@ -3743,7 +3743,7 @@ int wilc_hif_set_cfg(struct wilc_vif *vif,
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_CFG_PARAMS;
-	msg.body.cfg_info.cfg_attr_info = *pstrCfgParamVal;
+	msg.body.cfg_info.cfg_attr_info = *cfg_param;
 	msg.vif = vif;
 
 	result = wilc_mq_send(&hif_msg_q, &msg, sizeof(struct host_if_msg));
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index fe32a9a..4b19bf1 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -340,7 +340,7 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 	      size_t ies_len, wilc_scan_result scan_result, void *user_arg,
 	      struct hidden_network *hidden_network);
 int wilc_hif_set_cfg(struct wilc_vif *vif,
-		     struct cfg_param_val *pstrCfgParamVal);
+		     struct cfg_param_val *cfg_param);
 int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler);
 s32 wilc_deinit(struct wilc_vif *vif);
 int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
-- 
2.7.0

