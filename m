Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47172 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755201Ab1C3A5g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 20:57:36 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 17:57:12 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <nsingh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 24/34] ath6kl: propagate errors on module setup
Date: Tue, 29 Mar 2011 17:56:21 -0700
Message-ID: <1301446591-15236-25-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
References: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This propagates initial platform registration failures and
also HIF initialization failures.

Cc: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 .../staging/ath6kl/hif/sdio/linux_sdio/src/hif.c   |   32 ++++++++-----------
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |   12 ++++---
 drivers/staging/ath6kl/os/linux/ar6000_pm.c        |   26 +++++++++-------
 .../ath6kl/os/linux/include/ar6xapi_linux.h        |    2 +-
 4 files changed, 37 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
index e6d9cd8..001f993 100644
--- a/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
+++ b/drivers/staging/ath6kl/hif/sdio/linux_sdio/src/hif.c
@@ -125,31 +125,27 @@ ATH_DEBUG_INSTANTIATE_MODULE_VAR(hif,
 /* ------ Functions ------ */
 int HIFInit(OSDRV_CALLBACKS *callbacks)
 {
-    int status;
-    AR_DEBUG_ASSERT(callbacks != NULL);
+	int r;
+	AR_DEBUG_ASSERT(callbacks != NULL);
+
+	A_REGISTER_MODULE_DEBUG_INFO(hif);
 
-    A_REGISTER_MODULE_DEBUG_INFO(hif);
+	/* store the callback handlers */
+	osdrvCallbacks = *callbacks;
 
-    /* store the callback handlers */
-    osdrvCallbacks = *callbacks;
+	/* Register with bus driver core */
+	registered = 1;
 
-    /* Register with bus driver core */
-    AR_DEBUG_PRINTF(ATH_DEBUG_TRACE, ("AR6000: HIFInit registering\n"));
-    registered = 1;
 #if defined(CONFIG_PM)
-    if (callbacks->deviceSuspendHandler && callbacks->deviceResumeHandler) {
-        ar6k_driver.drv.pm = &ar6k_device_pm_ops;
-    }
+	if (callbacks->deviceSuspendHandler && callbacks->deviceResumeHandler)
+		ar6k_driver.drv.pm = &ar6k_device_pm_ops;
 #endif /* CONFIG_PM */
-    status = sdio_register_driver(&ar6k_driver);
-    AR_DEBUG_ASSERT(status==0);
 
-    if (status != 0) {
-        return A_ERROR;
-    }
-
-    return 0;
+	r = sdio_register_driver(&ar6k_driver);
+	if (r < 0)
+		return r;
 
+	return 0;
 }
 
 static int
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index f08f165..5f73182 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -603,7 +603,7 @@ static int __init
 ar6000_init_module(void)
 {
     static int probed = 0;
-    int status;
+    int r;
     OSDRV_CALLBACKS osdrvCallbacks;
 
     a_module_debug_support_init();
@@ -636,7 +636,9 @@ ar6000_init_module(void)
     osdrvCallbacks.devicePowerChangeHandler = ar6000_power_change_ev;
 #endif
 
-    ar6000_pm_init();
+    r = ar6000_pm_init();
+    if (r)
+	return r;
 
 #ifdef DEBUG
     /* Set the debug flags if specified at load time */
@@ -655,9 +657,9 @@ ar6000_init_module(void)
     memset(&aptcTR, 0, sizeof(APTC_TRAFFIC_RECORD));
 #endif /* ADAPTIVE_POWER_THROUGHPUT_CONTROL */
 
-    status = HIFInit(&osdrvCallbacks);
-    if (status)
-        return -ENODEV;
+    r = HIFInit(&osdrvCallbacks);
+    if (r)
+        return r;
 
     return 0;
 }
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_pm.c b/drivers/staging/ath6kl/os/linux/ar6000_pm.c
index 1004f24..be401aa 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_pm.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_pm.c
@@ -660,24 +660,28 @@ ar6000_set_wlan_state(struct ar6_softc *ar, AR6000_WLAN_STATE state)
     return status;
 }
 
-void ar6000_pm_init()
+int ar6000_pm_init()
 {
-    A_REGISTER_MODULE_DEBUG_INFO(pm);
+	int  r;
+	A_REGISTER_MODULE_DEBUG_INFO(pm);
+
 #ifdef CONFIG_PM
-    /*
-     * Register ar6000_pm_device into system.
-     * We should also add platform_device into the first item of array
-     * of devices[] in file arch/xxx/mach-xxx/board-xxxx.c
-     */
-    if (platform_driver_register(&ar6000_pm_device)) {
-        AR_DEBUG_PRINTF(ATH_DEBUG_ERR,("ar6000: fail to register the power control driver.\n"));
-    }
+	/*
+	 * Register ar6000_pm_device into system.
+	 * We should also add platform_device into the first item of array
+	 * of devices[] in file arch/xxx/mach-xxx/board-xxxx.c
+	 */
+	r = platform_driver_register(&ar6000_pm_device);
+	if (r < 0)
+		return -ENODEV;
 #endif /* CONFIG_PM */
+
+	return 0;
 }
 
 void ar6000_pm_exit()
 {
 #ifdef CONFIG_PM
-    platform_driver_unregister(&ar6000_pm_device);
+	platform_driver_unregister(&ar6000_pm_device);
 #endif /* CONFIG_PM */
 }
diff --git a/drivers/staging/ath6kl/os/linux/include/ar6xapi_linux.h b/drivers/staging/ath6kl/os/linux/include/ar6xapi_linux.h
index dd6905c..a8e8e36 100644
--- a/drivers/staging/ath6kl/os/linux/include/ar6xapi_linux.h
+++ b/drivers/staging/ath6kl/os/linux/include/ar6xapi_linux.h
@@ -178,7 +178,7 @@ int ar6000_power_change_ev(void *context, u32 config);
 void ar6000_check_wow_status(struct ar6_softc *ar, struct sk_buff *skb, bool isEvent);
 #endif
 
-void ar6000_pm_init(void);
+int ar6000_pm_init(void);
 void ar6000_pm_exit(void);
 
 #ifdef CONFIG_AP_VIRTUAL_ADAPTER_SUPPORT
-- 
1.7.0.4

