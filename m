Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47189 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125Ab1C3A5q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 20:57:46 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2011 17:57:22 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <nsingh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 29/34] ath6kl: remove completely pointles platform driver
Date: Tue, 29 Mar 2011 17:56:26 -0700
Message-ID: <1301446591-15236-30-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
References: <1301446591-15236-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Perhaps there was some good intention on having some platform
driver on ath6kl, but right now its pointless. Kill!

Cc: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |    6 --
 drivers/staging/ath6kl/os/linux/ar6000_pm.c        |   55 --------------------
 .../ath6kl/os/linux/include/ar6xapi_linux.h        |    3 -
 3 files changed, 0 insertions(+), 64 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index 056acae..e3c1f58 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -636,10 +636,6 @@ ar6000_init_module(void)
     osdrvCallbacks.devicePowerChangeHandler = ar6000_power_change_ev;
 #endif
 
-    r = ar6000_pm_init();
-    if (r)
-	return r;
-
 #ifdef DEBUG
     /* Set the debug flags if specified at load time */
     if(debugflags != 0)
@@ -689,8 +685,6 @@ ar6000_cleanup_module(void)
 
     a_module_debug_support_cleanup();
 
-    ar6000_pm_exit();
-
     AR_DEBUG_PRINTF(ATH_DEBUG_INFO,("ar6000_cleanup: success\n"));
 }
 
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_pm.c b/drivers/staging/ath6kl/os/linux/ar6000_pm.c
index eeb3807..1e0ace8 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_pm.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_pm.c
@@ -302,35 +302,6 @@ int ar6000_power_change_ev(void *context, u32 config)
     return status;
 }
 
-static int ar6000_pm_probe(struct platform_device *pdev)
-{
-    return 0;
-}
-
-static int ar6000_pm_remove(struct platform_device *pdev)
-{
-    return 0;
-}
-
-static int ar6000_pm_suspend(struct platform_device *pdev, pm_message_t state)
-{
-    return 0;
-}
-
-static int ar6000_pm_resume(struct platform_device *pdev)
-{
-    return 0;
-}
-
-static struct platform_driver ar6000_pm_device = {
-    .probe      = ar6000_pm_probe,
-    .remove     = ar6000_pm_remove,
-    .suspend    = ar6000_pm_suspend,
-    .resume     = ar6000_pm_resume,
-    .driver     = {
-        .name = "wlan_ar6000_pm",
-    },
-};
 #endif /* CONFIG_PM */
 
 int
@@ -653,29 +624,3 @@ ar6000_set_wlan_state(struct ar6_softc *ar, AR6000_WLAN_STATE state)
     status = ar6000_update_wlan_pwr_state(ar, state, false);
     return status;
 }
-
-int ar6000_pm_init()
-{
-	int  r;
-	A_REGISTER_MODULE_DEBUG_INFO(pm);
-
-#ifdef CONFIG_PM
-	/*
-	 * Register ar6000_pm_device into system.
-	 * We should also add platform_device into the first item of array
-	 * of devices[] in file arch/xxx/mach-xxx/board-xxxx.c
-	 */
-	r = platform_driver_register(&ar6000_pm_device);
-	if (r < 0)
-		return -ENODEV;
-#endif /* CONFIG_PM */
-
-	return 0;
-}
-
-void ar6000_pm_exit()
-{
-#ifdef CONFIG_PM
-	platform_driver_unregister(&ar6000_pm_device);
-#endif /* CONFIG_PM */
-}
diff --git a/drivers/staging/ath6kl/os/linux/include/ar6xapi_linux.h b/drivers/staging/ath6kl/os/linux/include/ar6xapi_linux.h
index a8e8e36..184dbdb 100644
--- a/drivers/staging/ath6kl/os/linux/include/ar6xapi_linux.h
+++ b/drivers/staging/ath6kl/os/linux/include/ar6xapi_linux.h
@@ -178,9 +178,6 @@ int ar6000_power_change_ev(void *context, u32 config);
 void ar6000_check_wow_status(struct ar6_softc *ar, struct sk_buff *skb, bool isEvent);
 #endif
 
-int ar6000_pm_init(void);
-void ar6000_pm_exit(void);
-
 #ifdef CONFIG_AP_VIRTUAL_ADAPTER_SUPPORT
 int ar6000_add_ap_interface(struct ar6_softc *ar, char *ifname);
 int ar6000_remove_ap_interface(struct ar6_softc *ar);
-- 
1.7.0.4

