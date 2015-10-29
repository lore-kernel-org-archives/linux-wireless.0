Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:4813 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964921AbbJ2C5k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 22:57:40 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH V2 13/64] staging: wilc1000: rename hRemainOnChannel of struct host_if_drv
Date: Thu, 29 Oct 2015 11:58:36 +0900
Message-ID: <1446087567-16728-13-git-send-email-glen.lee@atmel.com> (sfid-20151029_035743_073874_1000A790)
In-Reply-To: <1446087567-16728-1-git-send-email-glen.lee@atmel.com>
References: <1446087567-16728-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch renames hRemainOnChannel of struct host_if_drv to remain_on_ch_timer
to avoid CamelCase naming convention.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 12 ++++++------
 drivers/staging/wilc1000/host_interface.h |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 6cde0bf..3cff865 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2530,8 +2530,8 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 ERRORHANDLER:
 	{
 		P2P_LISTEN_STATE = 1;
-		hif_drv->hRemainOnChannel.data = (unsigned long)hif_drv;
-		mod_timer(&hif_drv->hRemainOnChannel,
+		hif_drv->remain_on_ch_timer.data = (unsigned long)hif_drv;
+		mod_timer(&hif_drv->remain_on_ch_timer,
 			  jiffies +
 			  msecs_to_jiffies(pstrHostIfRemainOnChan->u32duration));
 
@@ -2628,7 +2628,7 @@ static void ListenTimerCB(unsigned long arg)
 	struct host_if_msg msg;
 	struct host_if_drv *hif_drv = (struct host_if_drv *)arg;
 
-	del_timer(&hif_drv->hRemainOnChannel);
+	del_timer(&hif_drv->remain_on_ch_timer);
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_LISTEN_TIMER_FIRED;
@@ -4139,7 +4139,7 @@ s32 host_int_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 
 	setup_timer(&hif_drv->scan_timer, TimerCB_Scan, 0);
 	setup_timer(&hif_drv->connect_timer, TimerCB_Connect, 0);
-	setup_timer(&hif_drv->hRemainOnChannel, ListenTimerCB, 0);
+	setup_timer(&hif_drv->remain_on_ch_timer, ListenTimerCB, 0);
 
 	sema_init(&hif_drv->sem_cfg_values, 1);
 	down(&hif_drv->sem_cfg_values);
@@ -4202,7 +4202,7 @@ s32 host_int_deinit(struct host_if_drv *hif_drv)
 	if (del_timer_sync(&periodic_rssi))
 		PRINT_D(HOSTINF_DBG, ">> Connect timer is active\n");
 
-	del_timer_sync(&hif_drv->hRemainOnChannel);
+	del_timer_sync(&hif_drv->remain_on_ch_timer);
 
 	host_int_set_wfi_drv_handler(NULL);
 	down(&hif_sema_driver);
@@ -4391,7 +4391,7 @@ s32 host_int_ListenStateExpired(struct host_if_drv *hif_drv, u32 u32SessionID)
 		return -EFAULT;
 	}
 
-	del_timer(&hif_drv->hRemainOnChannel);
+	del_timer(&hif_drv->remain_on_ch_timer);
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_LISTEN_TIMER_FIRED;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index d95011e..71788b1 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -314,7 +314,7 @@ struct host_if_drv {
 
 	struct timer_list scan_timer;
 	struct timer_list connect_timer;
-	struct timer_list hRemainOnChannel;
+	struct timer_list remain_on_ch_timer;
 
 	bool IFC_UP;
 };
-- 
1.9.1

