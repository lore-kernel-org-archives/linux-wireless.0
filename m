Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35584 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbcCWM2v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2016 08:28:51 -0400
Received: by mail-pf0-f196.google.com with SMTP id u190so3185464pfb.2
        for <linux-wireless@vger.kernel.org>; Wed, 23 Mar 2016 05:28:50 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 2/2] staging: wilc1000: use completion instead of struct semaphore hif_sema_driver
Date: Wed, 23 Mar 2016 21:28:34 +0900
Message-Id: <1458736114-7018-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20160323_132853_914396_22B4C98F)
In-Reply-To: <1458736114-7018-1-git-send-email-chaehyun.lim@gmail.com>
References: <1458736114-7018-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

struct semaphore hif_sema_driver is used to signal completion of host
interface message. This patch replaces struct semaphore hif_sema_driver
with struct completion hif_driver_comp. It is better to use completion
than semaphore for this case.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 3d17972..29d4d8a 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -232,7 +232,7 @@ static u8 P2P_LISTEN_STATE;
 static struct task_struct *hif_thread_handler;
 static struct message_queue hif_msg_q;
 static struct completion hif_thread_comp;
-static struct semaphore hif_sema_driver;
+static struct completion hif_driver_comp;
 static struct completion hif_wait_response;
 static struct mutex hif_deinit_lock;
 static struct timer_list periodic_rssi;
@@ -321,7 +321,7 @@ static s32 handle_set_wfi_drv_handler(struct wilc_vif *vif,
 				      hif_drv_handler->handler);
 
 	if (!hif_drv_handler->handler)
-		up(&hif_sema_driver);
+		complete(&hif_driver_comp);
 
 	if (result) {
 		netdev_err(vif->ndev, "Failed to set driver handler\n");
@@ -346,7 +346,7 @@ static s32 handle_set_operation_mode(struct wilc_vif *vif,
 				      wilc_get_vif_idx(vif));
 
 	if ((hif_op_mode->mode) == IDLE_MODE)
-		up(&hif_sema_driver);
+		complete(&hif_driver_comp);
 
 	if (result) {
 		netdev_err(vif->ndev, "Failed to set driver handler\n");
@@ -3401,7 +3401,7 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 
 	if (clients_count == 0)	{
 		init_completion(&hif_thread_comp);
-		sema_init(&hif_sema_driver, 0);
+		init_completion(&hif_driver_comp);
 		mutex_init(&hif_deinit_lock);
 	}
 
@@ -3480,7 +3480,7 @@ int wilc_deinit(struct wilc_vif *vif)
 	del_timer_sync(&hif_drv->remain_on_ch_timer);
 
 	wilc_set_wfi_drv_handler(vif, 0, 0);
-	down(&hif_sema_driver);
+	wait_for_completion(&hif_driver_comp);
 
 	if (hif_drv->usr_scan_req.scan_result) {
 		hif_drv->usr_scan_req.scan_result(SCAN_EVENT_ABORTED, NULL,
-- 
2.7.3

