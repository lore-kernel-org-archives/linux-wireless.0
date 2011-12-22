Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55532 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951Ab1LVUrw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 15:47:52 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/6] compat-wireless: make patches apply again
Date: Thu, 22 Dec 2011 21:47:28 +0100
Message-Id: <1324586850-5212-5-git-send-email-hauke@hauke-m.de> (sfid-20111222_214755_852600_B5C89D02)
In-Reply-To: <1324586850-5212-1-git-send-email-hauke@hauke-m.de>
References: <1324586850-5212-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* sk_add_backlog() is no longer used in net/bluetooth/l2cap_core.c so
the patch is not needed any more.
* ath6k got some now functions and the patches did not apply any more.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/29-sdio_no_suspend.patch         |   47 ++++++++++++++++++++---------
 patches/31-backport-sk_add_backlog.patch |   24 ---------------
 patches/35-fix-makefile-includes.patch   |    4 +-
 3 files changed, 34 insertions(+), 41 deletions(-)
 delete mode 100644 patches/31-backport-sk_add_backlog.patch

diff --git a/patches/29-sdio_no_suspend.patch b/patches/29-sdio_no_suspend.patch
index 1684bc5..9bb1b43 100644
--- a/patches/29-sdio_no_suspend.patch
+++ b/patches/29-sdio_no_suspend.patch
@@ -5,7 +5,7 @@ suspend and resume that are not backported.
 
 --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
 +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
-@@ -1871,7 +1871,7 @@ int ath6kl_cfg80211_resume(struct ath6kl
+@@ -1963,7 +1963,7 @@ int ath6kl_cfg80211_resume(struct ath6kl
  	return 0;
  }
  
@@ -14,7 +14,7 @@ suspend and resume that are not backported.
  
  /* hif layer decides what suspend mode to use */
  static int __ath6kl_cfg80211_suspend(struct wiphy *wiphy,
-@@ -2346,7 +2346,7 @@ static struct cfg80211_ops ath6kl_cfg802
+@@ -2554,7 +2554,7 @@ static struct cfg80211_ops ath6kl_cfg802
  	.del_pmksa = ath6kl_del_pmksa,
  	.flush_pmksa = ath6kl_flush_pmksa,
  	CFG80211_TESTMODE_CMD(ath6kl_tm_cmd)
@@ -33,7 +33,22 @@ suspend and resume that are not backported.
  static inline int ath6kl_hif_suspend(struct ath6kl *ar,
  				     struct cfg80211_wowlan *wow)
  {
-@@ -97,6 +98,7 @@ static inline int ath6kl_hif_resume(stru
+@@ -90,6 +91,7 @@ static inline int ath6kl_hif_suspend(str
+ 
+ 	return ar->hif_ops->suspend(ar, wow);
+ }
++#endif
+ 
+ /*
+  * Read from the ATH6KL through its diagnostic window. No cooperation from
+@@ -121,12 +123,14 @@ static inline int ath6kl_hif_bmi_write(s
+ 	return ar->hif_ops->bmi_write(ar, buf, len);
+ }
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
+ static inline int ath6kl_hif_resume(struct ath6kl *ar)
+ {
+ 	ath6kl_dbg(ATH6KL_DBG_HIF, "hif resume\n");
  
  	return ar->hif_ops->resume(ar);
  }
@@ -43,7 +58,7 @@ suspend and resume that are not backported.
  {
 --- a/drivers/net/wireless/ath/ath6kl/sdio.c
 +++ b/drivers/net/wireless/ath/ath6kl/sdio.c
-@@ -774,6 +774,7 @@ out:
+@@ -782,6 +782,7 @@ out:
  	return ret;
  }
  
@@ -51,15 +66,15 @@ suspend and resume that are not backported.
  static int ath6kl_sdio_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
  {
  	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
-@@ -845,6 +846,7 @@ static int ath6kl_sdio_resume(struct ath
+@@ -877,6 +878,7 @@ static int ath6kl_sdio_resume(struct ath
  
  	return 0;
  }
 +#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34)) */
  
- static void ath6kl_sdio_stop(struct ath6kl *ar)
- {
-@@ -888,14 +890,16 @@ static const struct ath6kl_hif_ops ath6k
+ /* set the window address register (using 4-byte register access ). */
+ static int ath6kl_set_addrwin_reg(struct ath6kl *ar, u32 reg_addr, u32 addr)
+@@ -1178,8 +1180,10 @@ static const struct ath6kl_hif_ops ath6k
  	.enable_scatter = ath6kl_sdio_enable_scatter,
  	.scat_req_rw = ath6kl_sdio_async_rw_scatter,
  	.cleanup_scatter = ath6kl_sdio_cleanup_scatter,
@@ -67,8 +82,10 @@ suspend and resume that are not backported.
  	.suspend = ath6kl_sdio_suspend,
  	.resume = ath6kl_sdio_resume,
 +#endif
- 	.power_on = ath6kl_sdio_power_on,
- 	.power_off = ath6kl_sdio_power_off,
+ 	.diag_read32 = ath6kl_sdio_diag_read32,
+ 	.diag_write32 = ath6kl_sdio_diag_write32,
+ 	.bmi_read = ath6kl_sdio_bmi_read,
+@@ -1189,7 +1193,7 @@ static const struct ath6kl_hif_ops ath6k
  	.stop = ath6kl_sdio_stop,
  };
  
@@ -77,7 +94,7 @@ suspend and resume that are not backported.
  
  /*
   * Empty handlers so that mmc subsystem doesn't remove us entirely during
-@@ -1037,7 +1041,9 @@ static struct sdio_driver ath6kl_sdio_dr
+@@ -1336,7 +1340,9 @@ static struct sdio_driver ath6kl_sdio_dr
  	.id_table = ath6kl_sdio_devices,
  	.probe = ath6kl_sdio_probe,
  	.remove = ath6kl_sdio_remove,
@@ -170,7 +187,7 @@ suspend and resume that are not backported.
  
 --- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
 +++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
-@@ -55,7 +55,7 @@ static bool
+@@ -56,7 +56,7 @@ static bool
  brcmf_pm_resume_error(struct brcmf_sdio_dev *sdiodev)
  {
  	bool is_err = false;
@@ -179,7 +196,7 @@ suspend and resume that are not backported.
  	is_err = atomic_read(&sdiodev->suspend);
  #endif
  	return is_err;
-@@ -64,7 +64,7 @@ brcmf_pm_resume_error(struct brcmf_sdio_
+@@ -65,7 +65,7 @@ brcmf_pm_resume_error(struct brcmf_sdio_
  static void
  brcmf_pm_resume_wait(struct brcmf_sdio_dev *sdiodev, wait_queue_head_t *wq)
  {
@@ -188,7 +205,7 @@ suspend and resume that are not backported.
  	int retry = 0;
  	while (atomic_read(&sdiodev->suspend) && retry++ != 30)
  		wait_event_timeout(*wq, false, HZ/100);
-@@ -530,7 +530,7 @@ static void brcmf_ops_sdio_remove(struct
+@@ -536,7 +536,7 @@ static void brcmf_ops_sdio_remove(struct
  	}
  }
  
@@ -197,7 +214,7 @@ suspend and resume that are not backported.
  static int brcmf_sdio_suspend(struct device *dev)
  {
  	mmc_pm_flag_t sdio_flags;
-@@ -585,7 +585,7 @@ static struct sdio_driver brcmf_sdmmc_dr
+@@ -586,7 +586,7 @@ static struct sdio_driver brcmf_sdmmc_dr
  	.remove = brcmf_ops_sdio_remove,
  	.name = "brcmfmac",
  	.id_table = brcmf_sdmmc_ids,
diff --git a/patches/31-backport-sk_add_backlog.patch b/patches/31-backport-sk_add_backlog.patch
deleted file mode 100644
index eb2be15..0000000
--- a/patches/31-backport-sk_add_backlog.patch
+++ /dev/null
@@ -1,24 +0,0 @@
-
-v2.6.34-rc2~48 got 8eae939f net: add limit for socket backlog
-This adds sk_add_backlog_limitted() which makes the backlog
-have a size, and therefore adding an skb to the backlog can
-fail, a later patch changed all non-limitted calls to use the
-limitted caller via a3a858ff. The older kernels don't have a
-size and as such always are successfull when adding to the
-backlog.
-
---- a/net/bluetooth/l2cap_core.c
-+++ b/net/bluetooth/l2cap_core.c
-@@ -4240,8 +4240,12 @@ static inline int l2cap_data_channel(str
- 		if (!sock_owned_by_user(sk)) {
- 			l2cap_ertm_data_rcv(sk, skb);
- 		} else {
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
- 			if (sk_add_backlog(sk, skb))
- 				goto drop;
-+#else
-+			sk_add_backlog(sk, skb);
-+#endif
- 		}
- 
- 		goto done;
diff --git a/patches/35-fix-makefile-includes.patch b/patches/35-fix-makefile-includes.patch
index f9fa1c2..43bbcb1 100644
--- a/patches/35-fix-makefile-includes.patch
+++ b/patches/35-fix-makefile-includes.patch
@@ -29,8 +29,8 @@ path the make process will search in the kernel tree for the headers.
 +	-I$(obj)		\
 +	-I$(obj)/../include
  
- DHDOFILES = \
- 	wl_cfg80211.o \
+ obj-$(CONFIG_BRCMFMAC) += brcmfmac.o
+ brcmfmac-objs += \
 --- a/drivers/net/wireless/brcm80211/brcmsmac/Makefile
 +++ b/drivers/net/wireless/brcm80211/brcmsmac/Makefile
 @@ -17,9 +17,9 @@
-- 
1.7.5.4

