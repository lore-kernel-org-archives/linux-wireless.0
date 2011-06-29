Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4627 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757834Ab1F2Xso (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:44 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 077/119] staging: brcm80211: move sdio related
 suspend/resume code to bus interface layer
Date: Wed, 29 Jun 2011 16:47:41 -0700
Message-ID: <1309391303-22741-78-git-send-email-frankyl@broadcom.com> (sfid-20110630_014947_536489_A3829943)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In fullmac some SDIO configurations should be done in suspend/resume
routine. It was placed under pm ops in wl_cfg80211.c which is
inappropriate. This patchs move them to sdio layer.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdbus.h      |    3 +
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c  |    8 ++++
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |    7 ---
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |   42 ++++++++++++++++++++
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |    7 ---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |   14 +------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h   |    2 -
 7 files changed, 55 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h b/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
index 05600e0..f1d04e0 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
@@ -111,4 +111,7 @@ extern int brcmf_sdioh_reset(struct sdioh_info *si);
 /* Helper function */
 void *brcmf_sdcard_get_sdioh(struct brcmf_sdio *sdh);
 
+/* Watchdog timer interface for pm ops */
+extern void brcmf_sdio_wdtmr_enable(bool enable);
+
 #endif				/* _sdio_api_h_ */
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index c4b74ab..d0be99f 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -218,3 +218,11 @@ module_param(sd_msglevel, uint, 0);
 
 extern uint sd_f2_blocksize;
 module_param(sd_f2_blocksize, int, 0);
+
+void brcmf_sdio_wdtmr_enable(bool enable)
+{
+	if (enable)
+		brcmf_os_wd_timer(sdhcinfo->ch, brcmf_watchdog_ms);
+	else
+		brcmf_os_wd_timer(sdhcinfo->ch, 0);
+}
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index c1de2cd..48527bb 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -55,13 +55,6 @@ DHD_PM_RESUME_WAIT_INIT(sdioh_request_buffer_wait);
 int brcmf_sdioh_card_regread(struct sdioh_info *sd, int func, u32 regaddr,
 			     int regsize, u32 *data);
 
-void brcmf_sdioh_set_host_pm_flags(int flag)
-{
-	if (sdio_set_host_pm_flags(gInstance->func[1], flag))
-		printk(KERN_ERR "%s: Failed to set pm_flags 0x%08x\n",\
-			 __func__, (unsigned int)flag);
-}
-
 static int brcmf_sdioh_enablefuncs(struct sdioh_info *sd)
 {
 	int err_ret;
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
index 6abd9c0..39b0cbe 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
@@ -136,11 +136,53 @@ static const struct sdio_device_id bcmsdh_sdmmc_ids[] = {
 
 MODULE_DEVICE_TABLE(sdio, bcmsdh_sdmmc_ids);
 
+#ifdef CONFIG_PM
+static int brcmf_sdio_suspend(struct device *dev)
+{
+	mmc_pm_flag_t sdio_flags;
+	int ret = 0;
+
+	sd_trace(("%s\n", __func__));
+
+	sdio_flags = sdio_get_host_pm_caps(gInstance->func[1]);
+	if (!(sdio_flags & MMC_PM_KEEP_POWER)) {
+		sd_err(("Host can't keep power while suspended\n"));
+		return -EINVAL;
+	}
+
+	ret = sdio_set_host_pm_flags(gInstance->func[1], MMC_PM_KEEP_POWER);
+	if (ret) {
+		sd_err(("Failed to set pm_flags\n"));
+		return ret;
+	}
+
+	brcmf_sdio_wdtmr_enable(false);
+
+	return ret;
+}
+
+static int brcmf_sdio_resume(struct device *dev)
+{
+	brcmf_sdio_wdtmr_enable(true);
+	return 0;
+}
+
+static const struct dev_pm_ops brcmf_sdio_pm_ops = {
+	.suspend	= brcmf_sdio_suspend,
+	.resume		= brcmf_sdio_resume,
+};
+#endif		/* CONFIG_PM */
+
 static struct sdio_driver bcmsdh_sdmmc_driver = {
 	.probe = brcmf_ops_sdio_probe,
 	.remove = brcmf_ops_sdio_remove,
 	.name = "brcmfmac",
 	.id_table = bcmsdh_sdmmc_ids,
+#ifdef CONFIG_PM
+	.drv = {
+		.pm = &brcmf_sdio_pm_ops,
+	},
+#endif		/* CONFIG_PM */
 };
 
 struct sdos_info {
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index c3cbda6..6f351eb 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -2382,13 +2382,6 @@ int brcmf_netdev_wait_pend8021x(struct net_device *dev)
 	return pend;
 }
 
-void brcmf_netdev_os_wd_timer(struct net_device *ndev, uint wdtick)
-{
-	dhd_info_t *dhd = *(dhd_info_t **)netdev_priv(ndev);
-
-	brcmf_os_wd_timer(&dhd->pub, wdtick);
-}
-
 #ifdef BCMDBG
 int brcmf_write_to_file(dhd_pub_t *dhd, u8 *buf, int size)
 {
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 1d80d75..a3c2e87 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -36,8 +36,6 @@
 #include "dhd.h"
 #include "wl_cfg80211.h"
 
-void brcmf_sdioh_set_host_pm_flags(int flag);
-
 static struct sdio_func *cfg80211_sdio_func;
 static struct wl_dev *wl_cfg80211_dev;
 static const u8 ether_bcast[ETH_ALEN] = {255, 255, 255, 255, 255, 255};
@@ -2071,7 +2069,6 @@ done:
 static s32 wl_cfg80211_resume(struct wiphy *wiphy)
 {
 	struct wl_priv *wl = wiphy_to_wl(wiphy);
-	struct net_device *ndev = wl_to_ndev(wl);
 
 	/*
 	 * Check for WL_STATUS_READY before any function call which
@@ -2084,11 +2081,8 @@ static s32 wl_cfg80211_resume(struct wiphy *wiphy)
 	atomic_set(&brcmf_mmc_suspend, false);
 #endif	/*  defined(CONFIG_PM_SLEEP) */
 
-	if (test_bit(WL_STATUS_READY, &wl->status)) {
-		/* Turn on Watchdog timer */
-		brcmf_netdev_os_wd_timer(ndev, brcmf_watchdog_ms);
+	if (test_bit(WL_STATUS_READY, &wl->status))
 		wl_invoke_iscan(wiphy_to_wl(wiphy));
-	}
 
 	WL_TRACE("Exit\n");
 	return 0;
@@ -2141,14 +2135,10 @@ static s32 wl_cfg80211_suspend(struct wiphy *wiphy, struct cfg80211_wowlan *wow)
 	clear_bit(WL_STATUS_SCANNING, &wl->status);
 	clear_bit(WL_STATUS_SCAN_ABORTING, &wl->status);
 
-	/* Inform SDIO stack not to switch off power to the chip */
-	brcmf_sdioh_set_host_pm_flags(MMC_PM_KEEP_POWER);
-
 	/* Turn off watchdog timer */
 	if (test_bit(WL_STATUS_READY, &wl->status)) {
-		WL_INFO("Terminate watchdog timer and enable MPC\n");
+		WL_INFO("Enable MPC\n");
 		wl_set_mpc(ndev, 1);
-		brcmf_netdev_os_wd_timer(ndev, 0);
 	}
 
 #if defined(CONFIG_PM_SLEEP)
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index 6ad6b5b..bc7b4a3 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -404,6 +404,4 @@ extern s8 *wl_cfg80211_get_fwname(void);	/* get firmware name for
 						 the dongle */
 extern s8 *wl_cfg80211_get_nvramname(void);	/* get nvram name for
 						 the dongle */
-extern void brcmf_netdev_os_wd_timer(struct net_device *ndev, uint wdtick);
-
 #endif				/* _wl_cfg80211_h_ */
-- 
1.7.1


