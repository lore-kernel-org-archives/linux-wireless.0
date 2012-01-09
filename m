Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33211 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab2AIIhS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 03:37:18 -0500
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH 2/8] ath6kl: Re-architect suspend mode handling in ath6kl_sdio_suspend()
Date: Mon, 9 Jan 2012 14:06:16 +0530
Message-ID: <1326098182-9103-3-git-send-email-rmani@qca.qualcomm.com> (sfid-20120109_093723_365924_8D7FBB38)
In-Reply-To: <1326098182-9103-1-git-send-email-rmani@qca.qualcomm.com>
References: <1326098182-9103-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

Dynamic suspend mode selection logic based on the host sdio
controller capability (MMC_PM_KEEP_POWER and MMC_PM_WAKE_SDIO_IRQ)
is completely removed.

Now, ath6kl_sdio_suspend() func will react based on the suspend mode
specified at the time of loading the driver (via module parameter
suspend_mode).

Additionally, new logic is added to have backup retry.
In other words, If the driver fails to enter into either
WOW (or) DEEP SLEEP mode, it would give a try in CUT POWER mode.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/sdio.c |  105 ++++++++++++++++++++------------
 1 files changed, 66 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 278a9f3..9eae745 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -787,66 +787,93 @@ static int ath6kl_sdio_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
 	struct sdio_func *func = ar_sdio->func;
 	mmc_pm_flag_t flags;
-	int ret;
+	unsigned char pmode_to_try;
+	int ret = -EINVAL;
 
 	flags = sdio_get_host_pm_caps(func);
 
 	ath6kl_dbg(ATH6KL_DBG_SUSPEND, "sdio suspend pm_caps 0x%x\n", flags);
 
-	if (!(flags & MMC_PM_KEEP_POWER) ||
-	    (ar->conf_flags & ATH6KL_CONF_SUSPEND_CUTPOWER)) {
-		/* as host doesn't support keep power we need to cut power */
-		return ath6kl_cfg80211_suspend(ar, ATH6KL_CFG_SUSPEND_CUTPOWER,
-					       NULL);
-	}
-
-	ret = sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
-	if (ret) {
-		printk(KERN_ERR "ath6kl: set sdio pm flags failed: %d\n",
-		       ret);
-		return ret;
-	}
+	/* Schedule scan uses WOW internally */
+	pmode_to_try = (ar->state == ATH6KL_STATE_SCHED_SCAN) ?
+			WLAN_POWER_STATE_WOW : ar->suspend_mode;
+retry:
+	switch (pmode_to_try) {
+	case WLAN_POWER_STATE_CUT_PWR:
+		ret = ath6kl_cfg80211_suspend(ar, ATH6KL_CFG_SUSPEND_CUTPOWER,
+					      NULL);
+		break;
 
-	if (!(flags & MMC_PM_WAKE_SDIO_IRQ))
-		goto deepsleep;
+	case WLAN_POWER_STATE_DEEP_SLEEP:
+		/* Try cut power if deep sleep suspend fails */
+		pmode_to_try = WLAN_POWER_STATE_CUT_PWR;
 
-	/* sdio irq wakes up host */
+		if (!(flags & MMC_PM_KEEP_POWER))
+			goto retry;
 
-	if (ar->state == ATH6KL_STATE_SCHED_SCAN) {
-		ret =  ath6kl_cfg80211_suspend(ar,
-					       ATH6KL_CFG_SUSPEND_SCHED_SCAN,
-					       NULL);
+		ret = sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
 		if (ret) {
-			ath6kl_warn("Schedule scan suspend failed: %d", ret);
-			return ret;
+			ath6kl_warn("failed to set sdio keep power flag: %d\n",
+				     ret);
+			goto retry;
 		}
 
-		ret = sdio_set_host_pm_flags(func, MMC_PM_WAKE_SDIO_IRQ);
+		ret = ath6kl_cfg80211_suspend(ar, ATH6KL_CFG_SUSPEND_DEEPSLEEP,
+					      NULL);
 		if (ret)
-			ath6kl_warn("set sdio wake irq flag failed: %d\n", ret);
+			goto retry;
 
-		return ret;
-	}
+		break;
 
-	if (wow) {
+	case WLAN_POWER_STATE_WOW:
+		/* Try cut power if wow suspend fails */
+		pmode_to_try = WLAN_POWER_STATE_CUT_PWR;
+
+		if (!(flags & MMC_PM_KEEP_POWER) ||
+		    !(flags & MMC_PM_WAKE_SDIO_IRQ))
+			goto retry;
+
+		ret = sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
+		if (ret) {
+			ath6kl_warn("failed to set sdio keep power flag: %d\n",
+				     ret);
+			goto retry;
+		}
+
+		ret = sdio_set_host_pm_flags(func, MMC_PM_WAKE_SDIO_IRQ);
+		if (ret) {
+			ath6kl_warn("failed to set sdio wake irq flag: %d\n",
+				     ret);
+			goto retry;
+		}
 		/*
 		 * The host sdio controller is capable of keep power and
-		 * sdio irq wake up at this point. It's fine to continue
-		 * wow suspend operation.
+		 * sdio irq wake up at this point.
 		 */
-		ret = ath6kl_cfg80211_suspend(ar, ATH6KL_CFG_SUSPEND_WOW, wow);
-		if (ret)
-			return ret;
-
-		ret = sdio_set_host_pm_flags(func, MMC_PM_WAKE_SDIO_IRQ);
+		if (ar->state == ATH6KL_STATE_SCHED_SCAN) {
+			ath6kl_dbg(ATH6KL_DBG_SUSPEND,
+				  "sched scan is in progress\n");
+			ret =  ath6kl_cfg80211_suspend(ar,
+						ATH6KL_CFG_SUSPEND_SCHED_SCAN,
+						NULL);
+			if (ret)
+				ath6kl_warn("schedule scan suspend failed: %d",
+					    ret);
+		} else
+			ret = ath6kl_cfg80211_suspend(ar,
+					ATH6KL_CFG_SUSPEND_WOW, wow);
 		if (ret)
-			ath6kl_err("set sdio wake irq flag failed: %d\n", ret);
+			goto retry;
+		break;
 
-		return ret;
+	default:
+		/* We shouldn't be here. */
+		WARN_ON(1);
+		break;
 	}
 
-deepsleep:
-	return ath6kl_cfg80211_suspend(ar, ATH6KL_CFG_SUSPEND_DEEPSLEEP, NULL);
+	return ret;
+
 }
 
 static int ath6kl_sdio_resume(struct ath6kl *ar)
-- 
1.7.1

