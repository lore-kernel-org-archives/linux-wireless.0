Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:41074 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab1JDLLU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 07:11:20 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: deactivate sdio suspend in ath6kl with kernel < 2.6.34
Date: Tue,  4 Oct 2011 13:11:10 +0200
Message-Id: <1317726670-23319-2-git-send-email-hauke@hauke-m.de> (sfid-20111004_131124_786773_8CEA1CC5)
In-Reply-To: <1317726670-23319-1-git-send-email-hauke@hauke-m.de>
References: <1317726670-23319-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The API to sdio suspend changed in kernel 2.6.34 and it is not
backported by compat. Just deactivate it when compat-wireless is
compiled for such an old kernel.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/29-sdio_no_suspend.patch |   62 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/patches/29-sdio_no_suspend.patch b/patches/29-sdio_no_suspend.patch
index 5cc26a1..1d09d34 100644
--- a/patches/29-sdio_no_suspend.patch
+++ b/patches/29-sdio_no_suspend.patch
@@ -3,6 +3,68 @@ Starting with commit 66fceb69b72ff7e9cd8da2ca70033982d5376e0e
 libertas uses new functions from the in kernel sdio framework for
 suspend and resume that are not backported.
 
+--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
++++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
+@@ -1411,7 +1411,7 @@ static int ath6kl_flush_pmksa(struct wip
+ 	return 0;
+ }
+ 
+-#ifdef CONFIG_PM
++#if defined(CONFIG_PM) && (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
+ static int ar6k_cfg80211_suspend(struct wiphy *wiphy,
+ 				 struct cfg80211_wowlan *wow)
+ {
+@@ -1827,7 +1827,7 @@ static struct cfg80211_ops ath6kl_cfg802
+ 	.del_pmksa = ath6kl_del_pmksa,
+ 	.flush_pmksa = ath6kl_flush_pmksa,
+ 	CFG80211_TESTMODE_CMD(ath6kl_tm_cmd)
+-#ifdef CONFIG_PM
++#if defined(CONFIG_PM) && (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
+ 	.suspend = ar6k_cfg80211_suspend,
+ #endif
+ 	.set_channel = ath6kl_set_channel,
+--- a/drivers/net/wireless/ath/ath6kl/hif-ops.h
++++ b/drivers/net/wireless/ath/ath6kl/hif-ops.h
+@@ -69,9 +69,11 @@ static inline void ath6kl_hif_cleanup_sc
+ 	return ar->hif_ops->cleanup_scatter(ar);
+ }
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
+ static inline int ath6kl_hif_suspend(struct ath6kl *ar)
+ {
+ 	return ar->hif_ops->suspend(ar);
+ }
++#endif
+ 
+ #endif
+--- a/drivers/net/wireless/ath/ath6kl/sdio.c
++++ b/drivers/net/wireless/ath/ath6kl/sdio.c
+@@ -724,6 +724,7 @@ static int ath6kl_sdio_enable_scatter(st
+ 	return 0;
+ }
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
+ static int ath6kl_sdio_suspend(struct ath6kl *ar)
+ {
+ 	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
+@@ -751,6 +752,7 @@ static int ath6kl_sdio_suspend(struct at
+ 
+ 	return 0;
+ }
++#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34)) */
+ 
+ static const struct ath6kl_hif_ops ath6kl_sdio_ops = {
+ 	.read_write_sync = ath6kl_sdio_read_write_sync,
+@@ -762,7 +764,9 @@ static const struct ath6kl_hif_ops ath6k
+ 	.enable_scatter = ath6kl_sdio_enable_scatter,
+ 	.scat_req_rw = ath6kl_sdio_async_rw_scatter,
+ 	.cleanup_scatter = ath6kl_sdio_cleanup_scatter,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,34))
+ 	.suspend = ath6kl_sdio_suspend,
++#endif
+ };
+ 
+ static int ath6kl_sdio_probe(struct sdio_func *func,
 --- a/drivers/net/wireless/libertas/if_sdio.c
 +++ b/drivers/net/wireless/libertas/if_sdio.c
 @@ -1306,6 +1306,7 @@ static void if_sdio_remove(struct sdio_f
-- 
1.7.4.1

