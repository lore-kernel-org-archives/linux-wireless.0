Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47178 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755351Ab1C3A5k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 20:57:40 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 17:57:16 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <nsingh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 26/34] ath6kl: propagate errors on hifEnableFunc() failures
Date: Tue, 29 Mar 2011 17:56:23 -0700
Message-ID: <1301446591-15236-27-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
References: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will be passed along to the SDIO probe routine when
it fails. This will generate better error code to the user
when loading the module if it fails.

Cc: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 .../staging/ath6kl/hif/sdio/linux_sdio/src/hif.c   |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
index 001f993..1752b33 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
@@ -1012,7 +1012,7 @@ static int hifEnableFunc(struct hif_device *device, struct sdio_func *func)
             if (ret) {
                 AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("AR6000: failed to enable 4-bit ASYNC IRQ mode %d \n",ret));
                 sdio_release_host(func);
-                return A_ERROR;
+                return ret;
             }
             AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: 4-bit ASYNC IRQ mode enabled\n"));
         }
@@ -1023,14 +1023,14 @@ static int hifEnableFunc(struct hif_device *device, struct sdio_func *func)
             AR_DEBUG_PRINTF(ATH_DEBUG_ERROR, ("AR6000: %s(), Unable to enable AR6K: 0x%X\n",
 					  __FUNCTION__, ret));
             sdio_release_host(func);
-            return A_ERROR;
+            return ret;
         }
         ret = sdio_set_block_size(func, HIF_MBOX_BLOCK_SIZE);
         sdio_release_host(func);
         if (ret) {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERROR, ("AR6000: %s(), Unable to set block size 0x%x  AR6K: 0x%X\n",
 					  __FUNCTION__, HIF_MBOX_BLOCK_SIZE, ret));
-            return A_ERROR;
+            return ret;
         }
         device->is_disabled = false;
         /* create async I/O thread */
@@ -1041,7 +1041,7 @@ static int hifEnableFunc(struct hif_device *device, struct sdio_func *func)
                                            "AR6K Async");
            if (IS_ERR(device->async_task)) {
                AR_DEBUG_PRINTF(ATH_DEBUG_ERROR, ("AR6000: %s(), to create async task\n", __FUNCTION__));
-                return A_ERROR;
+                return -ENOMEM;
            }
            AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: start async task\n"));
            wake_up_process(device->async_task );    
@@ -1056,14 +1056,14 @@ static int hifEnableFunc(struct hif_device *device, struct sdio_func *func)
     } else {
         taskFunc = enable_task;
         taskName = "AR6K enable";
-        ret = A_PENDING;
+        ret = -ENOMEM;
 #endif /* CONFIG_PM */
     }
     /* create resume thread */
     pTask = kthread_create(taskFunc, (void *)device, taskName);
     if (IS_ERR(pTask)) {
         AR_DEBUG_PRINTF(ATH_DEBUG_ERROR, ("AR6000: %s(), to create enabel task\n", __FUNCTION__));
-        return A_ERROR;
+        return -ENOMEM;
     }
     wake_up_process(pTask);
     AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: -hifEnableFunc\n"));
-- 
1.7.0.4

