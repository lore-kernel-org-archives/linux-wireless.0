Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2177 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042Ab1ECHBK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 03:01:10 -0400
From: sukeshs@broadcom.com
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] brcm80211: Fix for suspend/resume bug
Date: Tue, 3 May 2011 00:00:57 -0700
Message-ID: <1304406057-8722-3-git-send-email-sukeshs@broadcom.com> (sfid-20110503_090114_954639_923669A6)
In-Reply-To: <1304406057-8722-1-git-send-email-sukeshs@broadcom.com>
References: <1304406057-8722-1-git-send-email-sukeshs@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sukesh Srikakula <sukeshs@xl-sj1-20.sj.broadcom.com>

Currently, there are 2 callbacks registered with OS for getting notifications when system goes to suspend/resume.
Racing between these 2 callbacks leads to failure in the suspend/resume path.
With this fix, we avoid registering dhd callback for suspend/resume notification when cfg80211 is used. Relevant functionality in dhd suspend/resume callback function is moved to cfg80211 suspend/resume functions.

Signed-off-by: Sukesh Srikakula <sukeshs@broadcom.com>
Signed-off-by: Sukesh Srikakula <sukeshs@xl-sj1-20.sj.broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    4 ----
 drivers/staging/brcm80211/brcmfmac/dhd.h          |    3 +++
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c    |    6 ++++--
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c  |    8 ++++++++
 4 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 05f50d3..54ba30d 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -30,10 +30,6 @@
 #include <dngl_stats.h>
 #include <dhd.h>
 
-#if defined(CONFIG_PM_SLEEP)
-#include <linux/suspend.h>
-extern volatile bool dhd_mmc_suspend;
-#endif
 #include "bcmsdh_sdmmc.h"
 
 extern int sdio_function_init(void);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 99c38dd..41c55a6 100644
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
@@ -123,6 +124,8 @@ typedef struct dhd_pub {
 
 #if defined(CONFIG_PM_SLEEP)
 
+extern volatile bool dhd_mmc_suspend;
+
 #define DHD_PM_RESUME_WAIT_INIT(a) DECLARE_WAIT_QUEUE_HEAD(a);
 #define _DHD_PM_RESUME_WAIT(a, b) do {\
 			int retry = 0; \
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index b34c4ea..37b2c0c 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -2015,7 +2015,8 @@ dhd_pub_t *dhd_attach(struct dhd_bus *bus, uint bus_hdrlen)
 	g_bus = bus;
 #endif
 #if defined(CONFIG_PM_SLEEP)
-	register_pm_notifier(&dhd_sleep_pm_notifier);
+	if (!IS_CFG80211_FAVORITE())
+		register_pm_notifier(&dhd_sleep_pm_notifier);
 #endif	/* defined(CONFIG_PM_SLEEP) */
 	/* && defined(DHD_GPL) */
 	/* Init lock suspend to prevent kernel going to suspend */
@@ -2325,7 +2326,8 @@ void dhd_detach(dhd_pub_t *dhdp)
 				wl_cfg80211_detach();
 
 #if defined(CONFIG_PM_SLEEP)
-			unregister_pm_notifier(&dhd_sleep_pm_notifier);
+			if (!IS_CFG80211_FAVORITE())
+				unregister_pm_notifier(&dhd_sleep_pm_notifier);
 #endif	/* defined(CONFIG_PM_SLEEP) */
 			/* && defined(DHD_GPL) */
 			free_netdev(ifp->net);
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index c60fc7c..db77e60 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -1971,6 +1971,10 @@ static s32 wl_cfg80211_resume(struct wiphy *wiphy)
 {
 	s32 err = 0;
 
+#if defined(CONFIG_PM_SLEEP)
+	dhd_mmc_suspend = false;
+#endif /*  defined(CONFIG_PM_SLEEP) */
+
 	CHECK_SYS_UP();
 	wl_invoke_iscan(wiphy_to_wl(wiphy));
 
@@ -1996,6 +2000,10 @@ static s32 wl_cfg80211_suspend(struct wiphy *wiphy)
 
 	sdioh_sdio_set_host_pm_flags(MMC_PM_KEEP_POWER);
 
+#if defined(CONFIG_PM_SLEEP)
+	dhd_mmc_suspend = true;
+#endif /*  defined(CONFIG_PM_SLEEP) */
+
 	return err;
 }
 
-- 
1.7.3.2


