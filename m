Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47203 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755183Ab1C3A5x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 20:57:53 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 17:57:29 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <nsingh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 32/34] ath6kl: remove chatty debug messages on ath6kl driver ops
Date: Tue, 29 Mar 2011 17:56:29 -0700
Message-ID: <1301446591-15236-33-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
References: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These do not help in any way.

Cc: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 .../staging/ath6kl/hif/sdio/linux_sdio/src/hif.c   |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
index 314c552..c8f1a6e 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
@@ -144,7 +144,6 @@ static void ath6kl_hifdev_remove(struct sdio_func *func)
 {
 	int status = 0;
 	struct hif_device *device;
-	AR_DEBUG_ASSERT(func != NULL);
 
 	device = ath6kl_get_hifdev(func);
 	if (device->claimedContext != NULL)
@@ -159,8 +158,6 @@ static void ath6kl_hifdev_remove(struct sdio_func *func)
 	CleanupHIFScatterResources(device);
 
 	delHifDevice(device);
-	AR_DEBUG_ASSERT(status == 0);
-	AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: -hifDeviceRemoved\n"));
 }
 
 #if defined(CONFIG_PM)
@@ -171,7 +168,6 @@ static int ath6kl_hifdev_suspend(struct device *dev)
 	struct hif_device *device;
 
 	device = ath6kl_get_hifdev(func);
-	AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: +ath6kl_hifdev_suspend\n"));
 
 	if (device && device->claimedContext &&
 	    osdrvCallbacks.deviceSuspendHandler) {
@@ -184,7 +180,6 @@ static int ath6kl_hifdev_suspend(struct device *dev)
 	}
 
 	CleanupHIFScatterResources(device);
-	AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: -ath6kl_hifdev_suspend\n"));
 
 	switch (status) {
 	case 0:
@@ -204,7 +199,6 @@ static int ath6kl_hifdev_resume(struct device *dev)
 	struct hif_device *device;
 
 	device = ath6kl_get_hifdev(func);
-	AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: +ath6kl_hifdev_resume\n"));
 	if (device && device->claimedContext &&
 	    osdrvCallbacks.deviceSuspendHandler) {
 		status = osdrvCallbacks.
@@ -212,7 +206,6 @@ static int ath6kl_hifdev_resume(struct device *dev)
 		if (status == 0)
 			device->is_suspend = false;
 	}
-	AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: -ath6kl_hifdev_resume\n"));
 
 	return status;
 }
-- 
1.7.0.4

