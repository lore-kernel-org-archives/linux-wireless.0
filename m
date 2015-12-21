Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:11843 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbbLUFTS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 00:19:18 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 42/46] staging: wilc1000: remove used functions
Date: Mon, 21 Dec 2015 14:18:46 +0900
Message-ID: <1450675130-17866-43-git-send-email-glen.lee@atmel.com> (sfid-20151221_061924_698937_4AD463E0)
In-Reply-To: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
References: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch remove unused functions add_handler_in_list and
remove_handler_in_list, and it's related global variable wfidrv_list and codes.
label fail_timer_2 and it's codes are removed since label is not used anymore.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c | 44 -------------------------------
 1 file changed, 44 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index e9a206c..46e009e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -226,7 +226,6 @@ struct join_bss_param {
 	u8 start_time[4];
 };
 
-static struct host_if_drv *wfidrv_list[NUM_CONCURRENT_IFC + 1];
 struct host_if_drv *terminated_handle;
 bool wilc_optaining_ip;
 static u8 P2P_LISTEN_STATE;
@@ -266,34 +265,6 @@ static struct wilc_vif *join_req_vif;
 
 static void *host_int_ParseJoinBssParam(tstrNetworkInfo *ptstrNetworkInfo);
 
-static int add_handler_in_list(struct host_if_drv *handler)
-{
-	int i;
-
-	for (i = 1; i < ARRAY_SIZE(wfidrv_list); i++) {
-		if (!wfidrv_list[i]) {
-			wfidrv_list[i] = handler;
-			return 0;
-		}
-	}
-
-	return -ENOBUFS;
-}
-
-static int remove_handler_in_list(struct host_if_drv *handler)
-{
-	int i;
-
-	for (i = 1; i < ARRAY_SIZE(wfidrv_list); i++) {
-		if (wfidrv_list[i] == handler) {
-			wfidrv_list[i] = NULL;
-			return 0;
-		}
-	}
-
-	return -EINVAL;
-}
-
 /* The u8IfIdx starts from 0 to NUM_CONCURRENT_IFC -1, but 0 index used as
  * special purpose in wilc device, so we add 1 to the index to starts from 1.
  * As a result, the returned index will be 1 to NUM_CONCURRENT_IFC.
@@ -3852,7 +3823,6 @@ s32 wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 {
 	s32 result = 0;
 	struct host_if_drv *hif_drv;
-	int err;
 	struct wilc_vif *vif;
 	struct wilc *wilc;
 
@@ -3872,11 +3842,6 @@ s32 wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 	}
 	hif_drv->wilc = wilc;
 	*hif_drv_handler = hif_drv;
-	err = add_handler_in_list(hif_drv);
-	if (err) {
-		result = -EFAULT;
-		goto _fail_timer_2;
-	}
 
 	wilc_optaining_ip = false;
 
@@ -3946,10 +3911,6 @@ s32 wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 
 	return result;
 
-_fail_timer_2:
-	del_timer_sync(&hif_drv->connect_timer);
-	del_timer_sync(&hif_drv->scan_timer);
-	kthread_stop(hif_thread_handler);
 _fail_mq_:
 	wilc_mq_destroy(&hif_msg_q);
 _fail_:
@@ -3961,7 +3922,6 @@ s32 wilc_deinit(struct wilc_vif *vif)
 	s32 result = 0;
 	struct host_if_msg msg;
 	struct host_if_drv *hif_drv = vif->hif_drv;
-	int ret;
 
 	if (!hif_drv)	{
 		PRINT_ER("hif_drv = NULL\n");
@@ -4016,10 +3976,6 @@ s32 wilc_deinit(struct wilc_vif *vif)
 		wilc_mq_destroy(&hif_msg_q);
 	}
 
-	ret = remove_handler_in_list(hif_drv);
-	if (ret)
-		result = -ENOENT;
-
 	kfree(hif_drv);
 
 	clients_count--;
-- 
1.9.1

