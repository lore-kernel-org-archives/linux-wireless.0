Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36151 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbcCWM2r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2016 08:28:47 -0400
Received: by mail-pf0-f194.google.com with SMTP id q129so3224003pfb.3
        for <linux-wireless@vger.kernel.org>; Wed, 23 Mar 2016 05:28:47 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 1/2] staging: wilc1000: use completion instead of struct semaphore hif_sema_thread
Date: Wed, 23 Mar 2016 21:28:33 +0900
Message-Id: <1458736114-7018-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20160323_132851_036479_9BF47836)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

struct semaphore hif_sema_thread is used to signal completion of host
interface thread. This patch replaces struct semaphore hif_sema_thread
with struct completion hif_thread_comp. It is better to use completion
than semaphore for this case.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b1ffa91..3d17972 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -231,7 +231,7 @@ bool wilc_optaining_ip;
 static u8 P2P_LISTEN_STATE;
 static struct task_struct *hif_thread_handler;
 static struct message_queue hif_msg_q;
-static struct semaphore hif_sema_thread;
+static struct completion hif_thread_comp;
 static struct semaphore hif_sema_driver;
 static struct completion hif_wait_response;
 static struct mutex hif_deinit_lock;
@@ -2668,7 +2668,7 @@ static int hostIFthread(void *pvArg)
 		}
 	}
 
-	up(&hif_sema_thread);
+	complete(&hif_thread_comp);
 	return 0;
 }
 
@@ -3400,7 +3400,7 @@ int wilc_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
 	wilc_optaining_ip = false;
 
 	if (clients_count == 0)	{
-		sema_init(&hif_sema_thread, 0);
+		init_completion(&hif_thread_comp);
 		sema_init(&hif_sema_driver, 0);
 		mutex_init(&hif_deinit_lock);
 	}
@@ -3503,7 +3503,7 @@ int wilc_deinit(struct wilc_vif *vif)
 		if (result != 0)
 			netdev_err(vif->ndev, "deinit : Error(%d)\n", result);
 
-		down(&hif_sema_thread);
+		wait_for_completion(&hif_thread_comp);
 
 		wilc_mq_destroy(&hif_msg_q);
 	}
-- 
2.7.3

