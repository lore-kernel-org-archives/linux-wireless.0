Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5218 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942Ab1JYKkr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 06:40:47 -0400
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH 5/7] ath6kl: Invoke wow suspend/resume calls during PM operations
Date: Tue, 25 Oct 2011 16:07:25 +0530
Message-ID: <1319539047-8756-6-git-send-email-rmani@qca.qualcomm.com> (sfid-20111025_124051_531545_EB488555)
In-Reply-To: <1319539047-8756-1-git-send-email-rmani@qca.qualcomm.com>
References: <1319539047-8756-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

 Link ath6kl's wow suspend/resume functions with the callback functions
 registered with the CFG layer for suspend and resume operation.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   20 ++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/hif-ops.h  |    5 +++++
 drivers/net/wireless/ath/ath6kl/hif.h      |    1 +
 drivers/net/wireless/ath/ath6kl/sdio.c     |   18 +++++++++++++++++-
 4 files changed, 43 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index aaf8d0f..ddef445 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1606,6 +1606,19 @@ static int ar6k_cfg80211_suspend(struct wiphy *wiphy,
 				 struct cfg80211_wowlan *wow)
 {
 	struct ath6kl *ar = wiphy_priv(wiphy);
+	int ret;
+
+	if (wow && ath6kl_cfg80211_ready(ar) &&
+	    test_bit(CONNECTED, &ar->flag) &&
+	    ath6kl_hif_keep_pwr_caps(ar)) {
+
+		/* Flush all non control pkts in Tx path */
+		ath6kl_tx_data_cleanup(ar);
+
+		ret = ath6kl_pm_wow_suspend(ar, wow);
+		if (ret)
+			return ret;
+	}
 
 	return ath6kl_hif_suspend(ar);
 }
@@ -1613,6 +1626,13 @@ static int ar6k_cfg80211_suspend(struct wiphy *wiphy,
 static int ar6k_cfg80211_resume(struct wiphy *wiphy)
 {
 	struct ath6kl *ar = wiphy_priv(wiphy);
+	int ret;
+
+	if (ar->wow_state == ATH6KL_WOW_STATE_SUSPENDED) {
+		ret = ath6kl_pm_wow_resume(ar);
+		if (ret)
+			return ret;
+	}
 
 	return ath6kl_hif_resume(ar);
 }
diff --git a/drivers/net/wireless/ath/ath6kl/hif-ops.h b/drivers/net/wireless/ath/ath6kl/hif-ops.h
index 95e7303..ab1140d 100644
--- a/drivers/net/wireless/ath/ath6kl/hif-ops.h
+++ b/drivers/net/wireless/ath/ath6kl/hif-ops.h
@@ -96,4 +96,9 @@ static inline int ath6kl_hif_resume(struct ath6kl *ar)
 
 	return ar->hif_ops->resume(ar);
 }
+
+static inline int ath6kl_hif_keep_pwr_caps(struct ath6kl *ar)
+{
+	return ar->hif_ops->keep_pwr_caps(ar);
+}
 #endif
diff --git a/drivers/net/wireless/ath/ath6kl/hif.h b/drivers/net/wireless/ath/ath6kl/hif.h
index 93d2912..fbe3622 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.h
+++ b/drivers/net/wireless/ath/ath6kl/hif.h
@@ -242,6 +242,7 @@ struct ath6kl_hif_ops {
 	void (*cleanup_scatter)(struct ath6kl *ar);
 	int (*suspend)(struct ath6kl *ar);
 	int (*resume)(struct ath6kl *ar);
+	bool (*keep_pwr_caps)(struct ath6kl *ar);
 };
 
 int ath6kl_hif_setup(struct ath6kl_device *dev);
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 58e31f6..ec0e58c 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -739,7 +739,8 @@ static int ath6kl_sdio_suspend(struct ath6kl *ar)
 		return ret;
 	}
 
-	ath6kl_deep_sleep_enable(ar);
+	if (ar->wow_state != ATH6KL_WOW_STATE_SUSPENDED)
+		ath6kl_deep_sleep_enable(ar);
 
 	return 0;
 }
@@ -756,6 +757,20 @@ static int ath6kl_sdio_resume(struct ath6kl *ar)
 	return 0;
 }
 
+static bool ath6kl_sdio_keep_pwr_caps(struct ath6kl *ar)
+{
+	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
+	struct sdio_func *func = ar_sdio->func;
+	mmc_pm_flag_t flags;
+
+	flags = sdio_get_host_pm_caps(func);
+
+	if (!(flags & MMC_PM_KEEP_POWER))
+		return false;
+
+	return true;
+}
+
 static const struct ath6kl_hif_ops ath6kl_sdio_ops = {
 	.read_write_sync = ath6kl_sdio_read_write_sync,
 	.write_async = ath6kl_sdio_write_async,
@@ -768,6 +783,7 @@ static const struct ath6kl_hif_ops ath6kl_sdio_ops = {
 	.cleanup_scatter = ath6kl_sdio_cleanup_scatter,
 	.suspend = ath6kl_sdio_suspend,
 	.resume = ath6kl_sdio_resume,
+	.keep_pwr_caps = ath6kl_sdio_keep_pwr_caps,
 };
 
 static int ath6kl_sdio_probe(struct sdio_func *func,
-- 
1.7.0.4

