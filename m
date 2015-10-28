Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:42144 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122AbbJ1HAb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:00:31 -0400
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 29/80] staging: wilc1000: rename hRemainOnChannel of struct host_if_drv
Date: Wed, 28 Oct 2015 15:59:49 +0900
Message-ID: <1446015640-29398-29-git-send-email-glen.lee@atmel.com> (sfid-20151028_081700_082677_8BD79BFD)
In-Reply-To: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
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
index 8ee0a94..b29d651 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2531,8 +2531,8 @@ static int Handle_RemainOnChan(struct host_if_drv *hif_drv,
 ERRORHANDLER:
 	{
 		P2P_LISTEN_STATE = 1;
-		hif_drv->hRemainOnChannel.data = (unsigned long)hif_drv;
-		mod_timer(&hif_drv->hRemainOnChannel,
+		hif_drv->remain_on_ch_timer.data = (unsigned long)hif_drv;
+		mod_timer(&hif_drv->remain_on_ch_timer,
 			  jiffies +
 			  msecs_to_jiffies(pstrHostIfRemainOnChan->u32duration));
 
@@ -2629,7 +2629,7 @@ static void ListenTimerCB(unsigned long arg)
 	struct host_if_msg msg;
 	struct host_if_drv *hif_drv = (struct host_if_drv *)arg;
 
-	del_timer(&hif_drv->hRemainOnChannel);
+	del_timer(&hif_drv->remain_on_ch_timer);
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_LISTEN_TIMER_FIRED;
@@ -4136,7 +4136,7 @@ s32 host_int_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 
 	setup_timer(&hif_drv->scan_timer, TimerCB_Scan, 0);
 	setup_timer(&hif_drv->connect_timer, TimerCB_Connect, 0);
-	setup_timer(&hif_drv->hRemainOnChannel, ListenTimerCB, 0);
+	setup_timer(&hif_drv->remain_on_ch_timer, ListenTimerCB, 0);
 
 	sema_init(&hif_drv->sem_cfg_values, 1);
 	down(&hif_drv->sem_cfg_values);
@@ -4199,7 +4199,7 @@ s32 host_int_deinit(struct host_if_drv *hif_drv)
 	if (del_timer_sync(&periodic_rssi))
 		PRINT_D(HOSTINF_DBG, ">> Connect timer is active\n");
 
-	del_timer_sync(&hif_drv->hRemainOnChannel);
+	del_timer_sync(&hif_drv->remain_on_ch_timer);
 
 	host_int_set_wfi_drv_handler(NULL);
 	down(&hif_sema_driver);
@@ -4388,7 +4388,7 @@ s32 host_int_ListenStateExpired(struct host_if_drv *hif_drv, u32 u32SessionID)
 		return -EFAULT;
 	}
 
-	del_timer(&hif_drv->hRemainOnChannel);
+	del_timer(&hif_drv->remain_on_ch_timer);
 
 	memset(&msg, 0, sizeof(struct host_if_msg));
 	msg.id = HOST_IF_MSG_LISTEN_TIMER_FIRED;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index d149fd5..1a41e3f 100644
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

