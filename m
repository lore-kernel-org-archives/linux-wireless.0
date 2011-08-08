Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3122 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014Ab1HHN7a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:30 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 44/82] staging: brcm80211: move brcmf_mmc_suspend to
 sdio layer in fullmac
Date: Mon, 8 Aug 2011 15:58:28 +0200
Message-ID: <1312811946-16713-45-git-send-email-arend@broadcom.com> (sfid-20110808_160146_642593_7CA3A40E)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

brcmf_mmc_suspend is used for sdio suspend/resume function. Hence it
should be placed in sdio interface layer.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   38 +++++++++++++++-----
 drivers/staging/brcm80211/brcmfmac/dhd.h          |   17 ---------
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c    |    8 ----
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c  |    8 ----
 4 files changed, 28 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index bfe73ee..d6f0f92 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -143,6 +143,7 @@ module_param(clockoverride, int, 0644);
 MODULE_PARM_DESC(clockoverride, "SDIO card clock override");
 
 struct brcmf_sdmmc_instance *gInstance;
+static atomic_t brcmf_mmc_suspend;
 
 struct device sdmmc_dev;
 
@@ -157,31 +158,44 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] = {
 	{ /* end: all zeroes */ },
 };
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static const struct dev_pm_ops brcmf_sdio_pm_ops = {
 	.suspend	= brcmf_sdio_suspend,
 	.resume		= brcmf_sdio_resume,
 };
-#endif	/* CONFIG_PM */
+#endif	/* CONFIG_PM_SLEEP */
 
 static struct sdio_driver brcmf_sdmmc_driver = {
 	.probe = brcmf_ops_sdio_probe,
 	.remove = brcmf_ops_sdio_remove,
 	.name = "brcmfmac",
 	.id_table = brcmf_sdmmc_ids,
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 	.drv = {
 		.pm = &brcmf_sdio_pm_ops,
 	},
-#endif	/* CONFIG_PM */
+#endif	/* CONFIG_PM_SLEEP */
 };
 
 MODULE_DEVICE_TABLE(sdio, brcmf_sdmmc_ids);
 
-BRCMF_PM_RESUME_WAIT_INIT(sdioh_request_byte_wait);
-BRCMF_PM_RESUME_WAIT_INIT(sdioh_request_word_wait);
-BRCMF_PM_RESUME_WAIT_INIT(sdioh_request_packet_wait);
-BRCMF_PM_RESUME_WAIT_INIT(sdioh_request_buffer_wait);
+#ifdef CONFIG_PM_SLEEP
+DECLARE_WAIT_QUEUE_HEAD(sdioh_request_byte_wait);
+DECLARE_WAIT_QUEUE_HEAD(sdioh_request_word_wait);
+DECLARE_WAIT_QUEUE_HEAD(sdioh_request_packet_wait);
+DECLARE_WAIT_QUEUE_HEAD(sdioh_request_buffer_wait);
+#define BRCMF_PM_RESUME_WAIT(a) do { \
+		int retry = 0; \
+		while (atomic_read(&brcmf_mmc_suspend) && retry++ != 30) { \
+			wait_event_timeout(a, false, HZ/100); \
+		} \
+	}	while (0)
+#define BRCMF_PM_RESUME_RETURN_ERROR(a)	\
+	do { if (atomic_read(&brcmf_mmc_suspend)) return a; } while (0)
+#else
+#define BRCMF_PM_RESUME_WAIT(a)
+#define BRCMF_PM_RESUME_RETURN_ERROR(a)
+#endif		/* CONFIG_PM_SLEEP */
 
 static int
 brcmf_sdioh_card_regread(struct sdioh_info *sd, int func, u32 regaddr,
@@ -1049,6 +1063,7 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 			sd_trace(("NIC found, calling brcmf_sdio_probe...\n"));
 			ret = brcmf_sdio_probe(&sdmmc_dev);
 		}
+		atomic_set(&brcmf_mmc_suspend, false);
 	}
 
 	gInstance->func[func->num] = func;
@@ -1077,7 +1092,7 @@ static void brcmf_ops_sdio_remove(struct sdio_func *func)
 }
 
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int brcmf_sdio_suspend(struct device *dev)
 {
 	mmc_pm_flag_t sdio_flags;
@@ -1085,6 +1100,8 @@ static int brcmf_sdio_suspend(struct device *dev)
 
 	sd_trace(("%s\n", __func__));
 
+	atomic_set(&brcmf_mmc_suspend, true);
+
 	sdio_flags = sdio_get_host_pm_caps(gInstance->func[1]);
 	if (!(sdio_flags & MMC_PM_KEEP_POWER)) {
 		sd_err(("Host can't keep power while suspended\n"));
@@ -1105,9 +1122,10 @@ static int brcmf_sdio_suspend(struct device *dev)
 static int brcmf_sdio_resume(struct device *dev)
 {
 	brcmf_sdio_wdtmr_enable(true);
+	atomic_set(&brcmf_mmc_suspend, false);
 	return 0;
 }
-#endif		/* CONFIG_PM */
+#endif		/* CONFIG_PM_SLEEP */
 
 int brcmf_sdioh_osinit(struct sdioh_info *sd)
 {
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 1fe9d69..9afd9ff 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -620,18 +620,6 @@ struct bcmevent_name {
 };
 
 #if defined(CONFIG_PM_SLEEP)
-extern atomic_t brcmf_mmc_suspend;
-#define BRCMF_PM_RESUME_WAIT_INIT(a) DECLARE_WAIT_QUEUE_HEAD(a);
-#define _BRCMF_PM_RESUME_WAIT(a, b) do { \
-		int retry = 0; \
-		while (atomic_read(&brcmf_mmc_suspend) && retry++ != b) { \
-			wait_event_timeout(a, false, HZ/100); \
-		} \
-	}	while (0)
-#define BRCMF_PM_RESUME_WAIT(a)	_BRCMF_PM_RESUME_WAIT(a, 30)
-#define BRCMF_PM_RESUME_RETURN_ERROR(a)	\
-	do { if (atomic_read(&brcmf_mmc_suspend)) return a; } while (0)
-
 #define BRCMF_SPINWAIT_SLEEP_INIT(a) DECLARE_WAIT_QUEUE_HEAD(a);
 #define BRCMF_SPINWAIT_SLEEP(a, exp, us) do { \
 		uint countdown = (us) + 9999; \
@@ -642,11 +630,6 @@ extern atomic_t brcmf_mmc_suspend;
 	} while (0)
 
 #else
-
-#define BRCMF_PM_RESUME_WAIT_INIT(a)
-#define BRCMF_PM_RESUME_WAIT(a)
-#define BRCMF_PM_RESUME_RETURN_ERROR(a)
-
 #define BRCMF_SPINWAIT_SLEEP_INIT(a)
 #define BRCMF_SPINWAIT_SLEEP(a, exp, us)  do { \
 		uint countdown = (us) + 9; \
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 07ceaf9..9dc327b 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -43,11 +43,6 @@
 #include "wl_cfg80211.h"
 #include "bcmchip.h"
 
-#if defined(CONFIG_PM_SLEEP)
-#include <linux/suspend.h>
-atomic_t brcmf_mmc_suspend;
-#endif	/*  defined(CONFIG_PM_SLEEP) */
-
 MODULE_AUTHOR("Broadcom Corporation");
 MODULE_DESCRIPTION("Broadcom 802.11n wireless LAN fullmac driver.");
 MODULE_SUPPORTED_DEVICE("Broadcom 802.11n WLAN fullmac cards");
@@ -1274,9 +1269,6 @@ struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
 	 */
 	memcpy(netdev_priv(net), &drvr_priv, sizeof(drvr_priv));
 
-#if defined(CONFIG_PM_SLEEP)
-	atomic_set(&brcmf_mmc_suspend, false);
-#endif	/* defined(CONFIG_PM_SLEEP) */
 	return &drvr_priv->pub;
 
 fail:
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 440ae6d..02137ac 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2102,10 +2102,6 @@ static s32 brcmf_cfg80211_resume(struct wiphy *wiphy)
 	 */
 	WL_TRACE("Enter\n");
 
-#if defined(CONFIG_PM_SLEEP)
-	atomic_set(&brcmf_mmc_suspend, false);
-#endif	/*  defined(CONFIG_PM_SLEEP) */
-
 	if (test_bit(WL_STATUS_READY, &cfg_priv->status))
 		brcmf_invoke_iscan(wiphy_to_cfg(wiphy));
 
@@ -2167,10 +2163,6 @@ static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy,
 		brcmf_set_mpc(ndev, 1);
 	}
 
-#if defined(CONFIG_PM_SLEEP)
-	atomic_set(&brcmf_mmc_suspend, true);
-#endif	/*  defined(CONFIG_PM_SLEEP) */
-
 	WL_TRACE("Exit\n");
 
 	return 0;
-- 
1.7.4.1


