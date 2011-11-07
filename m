Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62504 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab1KGF1Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 00:27:16 -0500
From: Raja Mani <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH v2 04/11] ath6kl: Include new parameter in suspend path for wowlan
Date: Mon, 7 Nov 2011 10:55:40 +0530
Message-ID: <1320643547-3578-5-git-send-email-rmani@qca.qualcomm.com> (sfid-20111107_062720_162676_A173C81C)
In-Reply-To: <1320643547-3578-1-git-send-email-rmani@qca.qualcomm.com>
References: <1320643547-3578-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211 layer provides user defined wow parameters like Filter options, Patterns,
Pattern's mask, etc via "struct cfg80211_wowlan *wow" to suspend function.

Right now, this wowlan parameter is not handled in __ath6kl_cfg80211_suspend func.
This parameter has to be passed to HIF layer, So that it can be passed back to
ath6kl's cfg interface layer when WOW mode is selected.

In case of deep sleep and cut power mode, it's not handled.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    5 +++--
 drivers/net/wireless/ath/ath6kl/cfg80211.h |    4 +++-
 drivers/net/wireless/ath/ath6kl/hif-ops.h  |    5 +++--
 drivers/net/wireless/ath/ath6kl/hif.h      |    2 +-
 drivers/net/wireless/ath/ath6kl/sdio.c     |    7 ++++---
 5 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 68cfb81..1dc7374 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1754,7 +1754,8 @@ static int ath6kl_wow_resume(struct ath6kl *ar)
 }
 
 int ath6kl_cfg80211_suspend(struct ath6kl *ar,
-			    enum ath6kl_cfg_suspend_mode mode)
+			    enum ath6kl_cfg_suspend_mode mode,
+			    struct cfg80211_wowlan *wow)
 {
 	int ret;
 
@@ -1844,7 +1845,7 @@ static int __ath6kl_cfg80211_suspend(struct wiphy *wiphy,
 {
 	struct ath6kl *ar = wiphy_priv(wiphy);
 
-	return ath6kl_hif_suspend(ar);
+	return ath6kl_hif_suspend(ar, wow);
 }
 
 static int __ath6kl_cfg80211_resume(struct wiphy *wiphy)
diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.h b/drivers/net/wireless/ath/ath6kl/cfg80211.h
index 72eadf8..b4781e5 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.h
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.h
@@ -46,7 +46,9 @@ void ath6kl_cfg80211_tkip_micerr_event(struct ath6kl_vif *vif, u8 keyid,
 				     bool ismcast);
 
 int ath6kl_cfg80211_suspend(struct ath6kl *ar,
-			    enum ath6kl_cfg_suspend_mode mode);
+			    enum ath6kl_cfg_suspend_mode mode,
+			    struct cfg80211_wowlan *wow);
+
 int ath6kl_cfg80211_resume(struct ath6kl *ar);
 
 void ath6kl_cfg80211_stop(struct ath6kl *ar);
diff --git a/drivers/net/wireless/ath/ath6kl/hif-ops.h b/drivers/net/wireless/ath/ath6kl/hif-ops.h
index 50fd3e9..eed2287 100644
--- a/drivers/net/wireless/ath/ath6kl/hif-ops.h
+++ b/drivers/net/wireless/ath/ath6kl/hif-ops.h
@@ -83,11 +83,12 @@ static inline void ath6kl_hif_cleanup_scatter(struct ath6kl *ar)
 	return ar->hif_ops->cleanup_scatter(ar);
 }
 
-static inline int ath6kl_hif_suspend(struct ath6kl *ar)
+static inline int ath6kl_hif_suspend(struct ath6kl *ar,
+				     struct cfg80211_wowlan *wow)
 {
 	ath6kl_dbg(ATH6KL_DBG_HIF, "hif suspend\n");
 
-	return ar->hif_ops->suspend(ar);
+	return ar->hif_ops->suspend(ar, wow);
 }
 
 static inline int ath6kl_hif_resume(struct ath6kl *ar)
diff --git a/drivers/net/wireless/ath/ath6kl/hif.h b/drivers/net/wireless/ath/ath6kl/hif.h
index 814386d..f2dc3bc 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.h
+++ b/drivers/net/wireless/ath/ath6kl/hif.h
@@ -242,7 +242,7 @@ struct ath6kl_hif_ops {
 	int (*scat_req_rw) (struct ath6kl *ar,
 			    struct hif_scatter_req *scat_req);
 	void (*cleanup_scatter)(struct ath6kl *ar);
-	int (*suspend)(struct ath6kl *ar);
+	int (*suspend)(struct ath6kl *ar, struct cfg80211_wowlan *wow);
 	int (*resume)(struct ath6kl *ar);
 	int (*power_on)(struct ath6kl *ar);
 	int (*power_off)(struct ath6kl *ar);
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index a026dae..b576b76 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -773,7 +773,7 @@ out:
 	return ret;
 }
 
-static int ath6kl_sdio_suspend(struct ath6kl *ar)
+static int ath6kl_sdio_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 {
 	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
 	struct sdio_func *func = ar_sdio->func;
@@ -787,7 +787,8 @@ static int ath6kl_sdio_suspend(struct ath6kl *ar)
 	if (!(flags & MMC_PM_KEEP_POWER) ||
 	    (ar->conf_flags & ATH6KL_CONF_SUSPEND_CUTPOWER)) {
 		/* as host doesn't support keep power we need to cut power */
-		return ath6kl_cfg80211_suspend(ar, ATH6KL_CFG_SUSPEND_CUTPOWER);
+		return ath6kl_cfg80211_suspend(ar, ATH6KL_CFG_SUSPEND_CUTPOWER,
+					       NULL);
 	}
 
 	ret = sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
@@ -797,7 +798,7 @@ static int ath6kl_sdio_suspend(struct ath6kl *ar)
 		return ret;
 	}
 
-	return ath6kl_cfg80211_suspend(ar, ATH6KL_CFG_SUSPEND_DEEPSLEEP);
+	return ath6kl_cfg80211_suspend(ar, ATH6KL_CFG_SUSPEND_DEEPSLEEP, NULL);
 }
 
 static int ath6kl_sdio_resume(struct ath6kl *ar)
-- 
1.7.1

