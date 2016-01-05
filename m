Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:34003 "EHLO
	mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbcAEOHk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 09:07:40 -0500
Received: by mail-pf0-f172.google.com with SMTP id e65so167955741pfe.1
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2016 06:07:40 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 13/13] staging: wilc1000: fix return type of wilc_init
Date: Tue,  5 Jan 2016 23:06:57 +0900
Message-Id: <1452002817-30937-13-git-send-email-chaehyun.lim@gmail.com> (sfid-20160105_150745_302277_E13DF802)
In-Reply-To: <1452002817-30937-1-git-send-email-chaehyun.lim@gmail.com>
References: <1452002817-30937-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes return type of wilc_init from s32 to int.
The error code as -ENOMEM or -EFAULT is returned in the wilc_init.
It is better to use return type of int in this function, not s32.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 8d022a0..5fac516 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3779,9 +3779,9 @@ static void GetPeriodicRSSI(unsigned long arg)
 	mod_timer(&periodic_rssi, jiffies + msecs_to_jiffies(5000));
 }
 
-s32 wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
+int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 {
-	s32 result = 0;
+	int result = 0;
 	struct host_if_drv *hif_drv;
 	struct wilc_vif *vif;
 	struct wilc *wilc;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index e2d5ee2..f4e6839 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -341,7 +341,7 @@ int wilc_scan(struct wilc_vif *vif, u8 scan_source, u8 scan_type,
 	      struct hidden_network *hidden_network);
 int wilc_hif_set_cfg(struct wilc_vif *vif,
 		     struct cfg_param_val *cfg_param);
-s32 wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler);
+int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler);
 int wilc_deinit(struct wilc_vif *vif);
 int wilc_add_beacon(struct wilc_vif *vif, u32 interval, u32 dtim_period,
 		    u32 head_len, u8 *head, u32 tail_len, u8 *tail);
-- 
2.6.4

