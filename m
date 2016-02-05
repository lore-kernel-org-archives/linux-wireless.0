Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:36555 "EHLO
	mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbcBEBfg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 20:35:36 -0500
Received: by mail-pf0-f171.google.com with SMTP id n128so59011758pfn.3
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2016 17:35:36 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/8] staging: wilc1000: fix return type of wilc_hif_set_cfg
Date: Fri,  5 Feb 2016 10:35:11 +0900
Message-Id: <1454636118-9943-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20160205_023540_434076_FC1E38E4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of wilc_hif_set_cfg from s32 to int.
The result variable gets return value from wilc_mq_send that has data
type of int. It should be changed return type of this function as well
as data type of result variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d77e2b2..a5b7dd1 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3729,10 +3729,10 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 	return result;
 }
 
-s32 wilc_hif_set_cfg(struct wilc_vif *vif,
+int wilc_hif_set_cfg(struct wilc_vif *vif,
 		     struct cfg_param_val *pstrCfgParamVal)
 {
-	s32 result = 0;
+	int result = 0;
 	struct host_if_msg msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 4c02e6b..fe32a9a 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -339,7 +339,7 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 	      u8 *ch_freq_list, u8 ch_list_len, const u8 *ies,
 	      size_t ies_len, wilc_scan_result scan_result, void *user_arg,
 	      struct hidden_network *hidden_network);
-s32 wilc_hif_set_cfg(struct wilc_vif *vif,
+int wilc_hif_set_cfg(struct wilc_vif *vif,
 		     struct cfg_param_val *pstrCfgParamVal);
 int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler);
 s32 wilc_deinit(struct wilc_vif *vif);
-- 
2.7.0

