Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3413 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758161Ab1EMKAF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 06:00:05 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Sukesh Srikakula" <sukeshs@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Grant Grundler" <grundler@chromium.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 19/32] staging: brcm80211: Fix for suspend issue in
 brcmfmac driver
Date: Fri, 13 May 2011 11:59:39 +0200
Message-ID: <1305280792-9475-19-git-send-email-arend@broadcom.com> (sfid-20110513_120017_044452_4D165775)
In-Reply-To: <1305280792-9475-1-git-send-email-arend@broadcom.com>
References: <1305280792-9475-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sukesh Srikakula <sukeshs@broadcom.com>

Currently, there are 2 callbacks registered with OS for getting
notifications when system goes to suspend/resume. Racing between
these 2 callbacks results in random suspend failures. With this fix,
we avoid registering dhd callback for suspend/resume notification
when cfg80211 is used. Relevent functionality in dhd suspend/resume
callback function is moved to cfg80211 suspend/resume functions.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Grant Grundler <grundler@chromium.org>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    5 +-
 drivers/staging/brcm80211/brcmfmac/dhd.h          |   22 ++++---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c    |   20 ++++--
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c  |   77 ++++++++++++++++++---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h  |    1 +
 5 files changed, 97 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 43aebfd..c0ffbd3 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -26,14 +26,11 @@
 #include <linux/mmc/core.h>
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/sdio_ids.h>
+#include <linux/suspend.h>
 
 #include <dngl_stats.h>
 #include <dhd.h>
 
-#if defined(CONFIG_PM_SLEEP)
-#include <linux/suspend.h>
-extern volatile bool dhd_mmc_suspend;
-#endif
 #include "bcmsdh_sdmmc.h"
 
 extern int sdio_function_init(void);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 99c38dd..a726b49 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -31,6 +31,7 @@
 #include <linux/random.h>
 #include <linux/spinlock.h>
 #include <linux/ethtool.h>
+#include <linux/suspend.h>
 #include <asm/uaccess.h>
 #include <asm/unaligned.h>
 /* The kernel threading is sdio-specific */
@@ -122,19 +123,22 @@ typedef struct dhd_pub {
 } dhd_pub_t;
 
 #if defined(CONFIG_PM_SLEEP)
-
+extern atomic_t dhd_mmc_suspend;
 #define DHD_PM_RESUME_WAIT_INIT(a) DECLARE_WAIT_QUEUE_HEAD(a);
-#define _DHD_PM_RESUME_WAIT(a, b) do {\
-			int retry = 0; \
-			while (dhd_mmc_suspend && retry++ != b) { \
-				wait_event_timeout(a, false, HZ/100); \
-			} \
-		}	while (0)
+#define _DHD_PM_RESUME_WAIT(a, b) do { \
+		int retry = 0; \
+		while (atomic_read(&dhd_mmc_suspend) && retry++ != b) { \
+			wait_event_timeout(a, false, HZ/100); \
+		} \
+	}	while (0)
 #define DHD_PM_RESUME_WAIT(a)	_DHD_PM_RESUME_WAIT(a, 30)
 #define DHD_PM_RESUME_WAIT_FOREVER(a)	_DHD_PM_RESUME_WAIT(a, ~0)
 #define DHD_PM_RESUME_RETURN_ERROR(a)	\
-	do { if (dhd_mmc_suspend) return a; } while (0)
-#define DHD_PM_RESUME_RETURN	do { if (dhd_mmc_suspend) return; } while (0)
+	do { if (atomic_read(&dhd_mmc_suspend)) return a; } while (0)
+#define DHD_PM_RESUME_RETURN	do { \
+	if (atomic_read(&dhd_mmc_suspend)) \
+		return; \
+	} while (0)
 
 #define DHD_SPINWAIT_SLEEP_INIT(a) DECLARE_WAIT_QUEUE_HEAD(a);
 #define SPINWAIT_SLEEP(a, exp, us) do { \
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index ba73ce0..31a5ca0 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -166,7 +166,7 @@ void wifi_del_dev(void)
 
 #if defined(CONFIG_PM_SLEEP)
 #include <linux/suspend.h>
-volatile bool dhd_mmc_suspend = false;
+atomic_t dhd_mmc_suspend;
 DECLARE_WAIT_QUEUE_HEAD(dhd_dpc_wait);
 #endif	/*  defined(CONFIG_PM_SLEEP) */
 
@@ -407,11 +407,11 @@ static int dhd_sleep_pm_callback(struct notifier_block *nfb,
 	switch (action) {
 	case PM_HIBERNATION_PREPARE:
 	case PM_SUSPEND_PREPARE:
-		dhd_mmc_suspend = true;
+		atomic_set(&dhd_mmc_suspend, true);
 		return NOTIFY_OK;
 	case PM_POST_HIBERNATION:
 	case PM_POST_SUSPEND:
-		dhd_mmc_suspend = false;
+		atomic_set(&dhd_mmc_suspend, false);
 		return NOTIFY_OK;
 	}
 	return 0;
@@ -2011,7 +2011,9 @@ dhd_pub_t *dhd_attach(struct dhd_bus *bus, uint bus_hdrlen)
 	g_bus = bus;
 #endif
 #if defined(CONFIG_PM_SLEEP)
-	register_pm_notifier(&dhd_sleep_pm_notifier);
+	atomic_set(&dhd_mmc_suspend, false);
+	if (!IS_CFG80211_FAVORITE())
+		register_pm_notifier(&dhd_sleep_pm_notifier);
 #endif	/* defined(CONFIG_PM_SLEEP) */
 	/* && defined(DHD_GPL) */
 	/* Init lock suspend to prevent kernel going to suspend */
@@ -2305,7 +2307,8 @@ void dhd_detach(dhd_pub_t *dhdp)
 				wl_cfg80211_detach();
 
 #if defined(CONFIG_PM_SLEEP)
-			unregister_pm_notifier(&dhd_sleep_pm_notifier);
+			if (!IS_CFG80211_FAVORITE())
+				unregister_pm_notifier(&dhd_sleep_pm_notifier);
 #endif	/* defined(CONFIG_PM_SLEEP) */
 			/* && defined(DHD_GPL) */
 			free_netdev(ifp->net);
@@ -2816,6 +2819,13 @@ int dhd_wait_pend8021x(struct net_device *dev)
 	return pend;
 }
 
+void wl_os_wd_timer(struct net_device *ndev, uint wdtick)
+{
+	dhd_info_t *dhd = *(dhd_info_t **)netdev_priv(ndev);
+
+	dhd_os_wd_timer(&dhd->pub, wdtick);
+}
+
 #ifdef DHD_DEBUG
 int write_to_file(dhd_pub_t *dhd, u8 *buf, int size)
 {
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index c60fc7c..2d67048 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -1969,34 +1969,91 @@ wl_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *dev,
 
 static s32 wl_cfg80211_resume(struct wiphy *wiphy)
 {
-	s32 err = 0;
+	struct wl_priv *wl = wiphy_to_wl(wiphy);
+	struct net_device *ndev = wl_to_ndev(wl);
 
-	CHECK_SYS_UP();
-	wl_invoke_iscan(wiphy_to_wl(wiphy));
+	/*
+	 * Check for WL_STATUS_READY before any function call which
+	 * could result is bus access. Don't block the resume for
+	 * any driver error conditions
+	 */
 
-	return err;
+#if defined(CONFIG_PM_SLEEP)
+	atomic_set(&dhd_mmc_suspend, false);
+#endif	/*  defined(CONFIG_PM_SLEEP) */
+
+	if (test_bit(WL_STATUS_READY, &wl->status)) {
+		/* Turn on Watchdog timer */
+		wl_os_wd_timer(ndev, dhd_watchdog_ms);
+		wl_invoke_iscan(wiphy_to_wl(wiphy));
+	}
+
+	return 0;
 }
 
 static s32 wl_cfg80211_suspend(struct wiphy *wiphy)
 {
 	struct wl_priv *wl = wiphy_to_wl(wiphy);
 	struct net_device *ndev = wl_to_ndev(wl);
-	s32 err = 0;
+
+
+	/*
+	 * Check for WL_STATUS_READY before any function call which
+	 * could result is bus access. Don't block the suspend for
+	 * any driver error conditions
+	 */
+
+	/*
+	 * While going to suspend if associated with AP disassociate
+	 * from AP to save power while system is in suspended state
+	 */
+	if (test_bit(WL_STATUS_CONNECTED, &wl->status) &&
+		test_bit(WL_STATUS_READY, &wl->status)) {
+		WL_INFO("Disassociating from AP"
+			" while entering suspend state\n");
+		wl_link_down(wl);
+
+		/*
+		 * Make sure WPA_Supplicant receives all the event
+		 * generated due to DISASSOC call to the fw to keep
+		 * the state fw and WPA_Supplicant state consistent
+		 */
+		rtnl_unlock();
+		wl_delay(500);
+		rtnl_lock();
+	}
 
 	set_bit(WL_STATUS_SCAN_ABORTING, &wl->status);
-	wl_term_iscan(wl);
+	if (test_bit(WL_STATUS_READY, &wl->status))
+		wl_term_iscan(wl);
+
 	if (wl->scan_request) {
-		cfg80211_scan_done(wl->scan_request, true);	/* true means
-								 abort */
-		wl_set_mpc(ndev, 1);
+		/* Indidate scan abort to cfg80211 layer */
+		WL_INFO("Terminating scan in progress\n");
+		cfg80211_scan_done(wl->scan_request, true);
 		wl->scan_request = NULL;
 	}
 	clear_bit(WL_STATUS_SCANNING, &wl->status);
 	clear_bit(WL_STATUS_SCAN_ABORTING, &wl->status);
+	clear_bit(WL_STATUS_CONNECTING, &wl->status);
+	clear_bit(WL_STATUS_CONNECTED, &wl->status);
 
+	/* Inform SDIO stack not to switch off power to the chip */
 	sdioh_sdio_set_host_pm_flags(MMC_PM_KEEP_POWER);
 
-	return err;
+	/* Turn off watchdog timer */
+	if (test_bit(WL_STATUS_READY, &wl->status)) {
+		WL_INFO("Terminate watchdog timer and enable MPC\n");
+		wl_set_mpc(ndev, 1);
+		wl_os_wd_timer(ndev, 0);
+	}
+
+#if defined(CONFIG_PM_SLEEP)
+	atomic_set(&dhd_mmc_suspend, true);
+#endif	/*  defined(CONFIG_PM_SLEEP) */
+
+
+	return 0;
 }
 
 static __used s32
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index 5112160..3c8b902 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -375,5 +375,6 @@ extern s8 *wl_cfg80211_get_fwname(void);	/* get firmware name for
 						 the dongle */
 extern s8 *wl_cfg80211_get_nvramname(void);	/* get nvram name for
 						 the dongle */
+extern void wl_os_wd_timer(struct net_device *ndev, uint wdtick);
 
 #endif				/* _wl_cfg80211_h_ */
-- 
1.7.4.1


