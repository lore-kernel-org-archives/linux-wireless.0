Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34362 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbcCHBEp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 20:04:45 -0500
Received: by mail-pa0-f54.google.com with SMTP id fy10so371161pac.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Mar 2016 17:04:45 -0800 (PST)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH] staging: wilc1000: use mutex instead of semaphore sem_cfg_values
Date: Tue,  8 Mar 2016 10:04:32 +0900
Message-Id: <1457399072-5646-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20160308_020449_404945_F5ADBF28)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces struct semaphore sem_cfg_values with struct mutex
cfg_values_lock. It is better to use mutex than semaphore.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 +++++-----
 drivers/staging/wilc1000/host_interface.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 854b674..0a922c7 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -443,7 +443,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 	struct host_if_drv *hif_drv = vif->hif_drv;
 	int i = 0;
 
-	down(&hif_drv->sem_cfg_values);
+	mutex_lock(&hif_drv->cfg_values_lock);
 
 	if (cfg_param_attr->flag & BSS_TYPE) {
 		if (cfg_param_attr->bss_type < 6) {
@@ -725,7 +725,7 @@ static s32 handle_cfg_param(struct wilc_vif *vif,
 		netdev_err(vif->ndev, "Error in setting CFG params\n");
 
 ERRORHANDLER:
-	up(&hif_drv->sem_cfg_values);
+	mutex_unlock(&hif_drv->cfg_values_lock);
 	return result;
 }
 
@@ -3434,8 +3434,8 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 	setup_timer(&hif_drv->connect_timer, TimerCB_Connect, 0);
 	setup_timer(&hif_drv->remain_on_ch_timer, ListenTimerCB, 0);
 
-	sema_init(&hif_drv->sem_cfg_values, 1);
-	down(&hif_drv->sem_cfg_values);
+	mutex_init(&hif_drv->cfg_values_lock);
+	mutex_lock(&hif_drv->cfg_values_lock);
 
 	hif_drv->hif_state = HOST_IF_IDLE;
 	hif_drv->cfg_values.site_survey_enabled = SITE_SURVEY_OFF;
@@ -3446,7 +3446,7 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 
 	hif_drv->p2p_timeout = 0;
 
-	up(&hif_drv->sem_cfg_values);
+	mutex_unlock(&hif_drv->cfg_values_lock);
 
 	clients_count++;
 
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 795c18c..01f3222 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -274,7 +274,7 @@ struct host_if_drv {
 	u8 assoc_bssid[ETH_ALEN];
 	struct cfg_param_attr cfg_values;
 
-	struct semaphore sem_cfg_values;
+	struct mutex cfg_values_lock;
 	struct semaphore sem_test_key_block;
 	struct semaphore sem_test_disconn_block;
 	struct semaphore sem_get_rssi;
-- 
2.7.1

