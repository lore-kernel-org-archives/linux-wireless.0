Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51629 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565Ab2DVWD3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Apr 2012 18:03:29 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/7] compat-wireless: ath6kl: deactivate suspend/resume only for SDIO
Date: Mon, 23 Apr 2012 00:03:13 +0200
Message-Id: <1335132199-21320-1-git-send-email-hauke@hauke-m.de> (sfid-20120423_000332_284293_DA0A9E8A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If ath6kl is used on a USB device suspend/resume should work, only on
SDIO based devices this causes some problems with older kernel versions.
---
 patches/29-sdio_no_suspend.patch |   84 +++++++-------------------------------
 1 file changed, 15 insertions(+), 69 deletions(-)

diff --git a/patches/29-sdio_no_suspend.patch b/patches/29-sdio_no_suspend.patch
index e1a3f85..d7574d0 100644
--- a/patches/29-sdio_no_suspend.patch
+++ b/patches/29-sdio_no_suspend.patch
@@ -3,89 +3,35 @@ Starting with commit 66fceb69b72ff7e9cd8da2ca70033982d5376e0e
 libertas uses new functions from the in kernel sdio framework for
 suspend and resume that are not backported.
 
---- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
-+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
-@@ -2376,7 +2376,7 @@ int ath6kl_cfg80211_resume(struct ath6kl
- }
- EXPORT_SYMBOL(ath6kl_cfg80211_resume);
- 
--#ifdef CONFIG_PM
-+#if defined(CONFIG_PM) && (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
- 
- /* hif layer decides what suspend mode to use */
- static int __ath6kl_cfg80211_suspend(struct wiphy *wiphy,
-@@ -3209,7 +3209,7 @@ static struct cfg80211_ops ath6kl_cfg802
- 	.del_pmksa = ath6kl_del_pmksa,
- 	.flush_pmksa = ath6kl_flush_pmksa,
- 	CFG80211_TESTMODE_CMD(ath6kl_tm_cmd)
--#ifdef CONFIG_PM
-+#if defined(CONFIG_PM) && (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
- 	.suspend = __ath6kl_cfg80211_suspend,
- 	.resume = __ath6kl_cfg80211_resume,
- #endif
---- a/drivers/net/wireless/ath/ath6kl/hif-ops.h
-+++ b/drivers/net/wireless/ath/ath6kl/hif-ops.h
-@@ -84,6 +84,7 @@ static inline void ath6kl_hif_cleanup_sc
- 	return ar->hif_ops->cleanup_scatter(ar);
- }
- 
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
- static inline int ath6kl_hif_suspend(struct ath6kl *ar,
- 				     struct cfg80211_wowlan *wow)
- {
-@@ -91,6 +92,7 @@ static inline int ath6kl_hif_suspend(str
- 
- 	return ar->hif_ops->suspend(ar, wow);
- }
-+#endif
- 
- /*
-  * Read from the ATH6KL through its diagnostic window. No cooperation from
-@@ -122,12 +124,14 @@ static inline int ath6kl_hif_bmi_write(s
- 	return ar->hif_ops->bmi_write(ar, buf, len);
- }
- 
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
- static inline int ath6kl_hif_resume(struct ath6kl *ar)
- {
- 	ath6kl_dbg(ATH6KL_DBG_HIF, "hif resume\n");
- 
- 	return ar->hif_ops->resume(ar);
- }
-+#endif
- 
- static inline int ath6kl_hif_power_on(struct ath6kl *ar)
- {
 --- a/drivers/net/wireless/ath/ath6kl/sdio.c
 +++ b/drivers/net/wireless/ath/ath6kl/sdio.c
-@@ -836,6 +836,7 @@ static int ath6kl_set_sdio_pm_caps(struc
+@@ -807,6 +807,7 @@ out:
  	return ret;
  }
  
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
- static int ath6kl_sdio_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
+ static int ath6kl_set_sdio_pm_caps(struct ath6kl *ar)
  {
  	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
-@@ -953,6 +954,7 @@ static int ath6kl_sdio_resume(struct ath
+@@ -953,6 +954,17 @@ static int ath6kl_sdio_resume(struct ath
  
  	return 0;
  }
++#else
++static int ath6kl_sdio_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
++{
++	return 0;
++}
++
++static int ath6kl_sdio_resume(struct ath6kl *ar)
++{
++	return 0;
++}
 +#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34)) */
  
  /* set the window address register (using 4-byte register access ). */
  static int ath6kl_set_addrwin_reg(struct ath6kl *ar, u32 reg_addr, u32 addr)
-@@ -1254,8 +1256,10 @@ static const struct ath6kl_hif_ops ath6k
- 	.enable_scatter = ath6kl_sdio_enable_scatter,
- 	.scat_req_rw = ath6kl_sdio_async_rw_scatter,
- 	.cleanup_scatter = ath6kl_sdio_cleanup_scatter,
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
- 	.suspend = ath6kl_sdio_suspend,
- 	.resume = ath6kl_sdio_resume,
-+#endif
- 	.diag_read32 = ath6kl_sdio_diag_read32,
- 	.diag_write32 = ath6kl_sdio_diag_write32,
- 	.bmi_read = ath6kl_sdio_bmi_read,
-@@ -1265,7 +1269,7 @@ static const struct ath6kl_hif_ops ath6k
+@@ -1265,7 +1277,7 @@ static const struct ath6kl_hif_ops ath6k
  	.stop = ath6kl_sdio_stop,
  };
  
@@ -94,7 +40,7 @@ suspend and resume that are not backported.
  
  /*
   * Empty handlers so that mmc subsystem doesn't remove us entirely during
-@@ -1415,7 +1419,9 @@ static struct sdio_driver ath6kl_sdio_dr
+@@ -1415,7 +1427,9 @@ static struct sdio_driver ath6kl_sdio_dr
  	.id_table = ath6kl_sdio_devices,
  	.probe = ath6kl_sdio_probe,
  	.remove = ath6kl_sdio_remove,
-- 
1.7.9.5

