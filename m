Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:36603 "EHLO
	mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbcBEBfn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 20:35:43 -0500
Received: by mail-pf0-f182.google.com with SMTP id n128so59013104pfn.3
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2016 17:35:42 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 3/8] staging: wilc1000: fix return type of wilc_deinit
Date: Fri,  5 Feb 2016 10:35:13 +0900
Message-Id: <1454636118-9943-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20160205_023545_923788_CB0DE552)
In-Reply-To: <1454636118-9943-1-git-send-email-chaehyun.lim@gmail.com>
References: <1454636118-9943-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of wilc_deinit from s32 to int.
The result variable gets return value from wilc_mq_send that has return
type of int. It should be changed return type of this function as well
as data type of result variable.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 0f8175f..36eeeb4 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3882,9 +3882,9 @@ _fail_:
 	return result;
 }
 
-s32 wilc_deinit(struct wilc_vif *vif)
+int wilc_deinit(struct wilc_vif *vif)
 {
-	s32 result = 0;
+	int result = 0;
 	struct host_if_msg msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 4b19bf1..f4e6839 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -342,7 +342,7 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 int wilc_hif_set_cfg(struct wilc_vif *vif,
 		     struct cfg_param_val *cfg_param);
 int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler);
-s32 wilc_deinit(struct wilc_vif *vif);
+int wilc_deinit(struct wilc_vif *vif);
 int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
 		    u32 head_len, u8 *head, u32 tail_len, u8 *tail);
 int wilc_del_beacon(struct wilc_vif *vif);
-- 
2.7.0

