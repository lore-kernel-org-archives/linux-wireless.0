Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42529 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab1KGF1j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 00:27:39 -0500
From: Raja Mani <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH v2 07/11] ath6kl: Invoke WOW suspend/resume calls during PM operation
Date: Mon, 7 Nov 2011 10:55:43 +0530
Message-ID: <1320643547-3578-8-git-send-email-rmani@qca.qualcomm.com> (sfid-20111107_062742_206715_9447E3D1)
In-Reply-To: <1320643547-3578-1-git-send-email-rmani@qca.qualcomm.com>
References: <1320643547-3578-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Link ath6kl's wow suspend/resume functions with the actual suspend/resume path.

WOW mode is selected when the host sdio controller supports both
MMC_PM_KEEP_POWER and MMC_PM_WAKE_SDIO_IRQ capabilities.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   28 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/sdio.c     |   20 ++++++++++++++++++++
 2 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 2cd43c8..42dcbea 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1760,6 +1760,21 @@ int ath6kl_cfg80211_suspend(struct ath6kl *ar,
 	int ret;
 
 	switch (mode) {
+	case ATH6KL_CFG_SUSPEND_WOW:
+
+		ath6kl_dbg(ATH6KL_DBG_SUSPEND, "wow mode suspend\n");
+
+		/* Flush all non control pkts in TX path */
+		ath6kl_tx_data_cleanup(ar);
+
+		ret = ath6kl_wow_suspend(ar, wow);
+		if (ret) {
+			ath6kl_err("wow suspend failed: %d\n", ret);
+			return ret;
+		}
+		ar->state = ATH6KL_STATE_WOW;
+		break;
+
 	case ATH6KL_CFG_SUSPEND_DEEPSLEEP:
 
 		ath6kl_cfg80211_stop(ar);
@@ -1811,6 +1826,18 @@ int ath6kl_cfg80211_resume(struct ath6kl *ar)
 	int ret;
 
 	switch (ar->state) {
+	case  ATH6KL_STATE_WOW:
+		ath6kl_dbg(ATH6KL_DBG_SUSPEND, "wow mode resume\n");
+
+		ret = ath6kl_wow_resume(ar);
+		if (ret) {
+			ath6kl_warn("wow mode resume failed: %d\n", ret);
+			return ret;
+		}
+
+		ar->state = ATH6KL_STATE_ON;
+		break;
+
 	case ATH6KL_STATE_DEEPSLEEP:
 		if (ar->wmi->pwr_mode != ar->wmi->saved_pwr_mode) {
 			ret = ath6kl_wmi_powermode_cmd(ar->wmi, 0,
@@ -1833,6 +1860,7 @@ int ath6kl_cfg80211_resume(struct ath6kl *ar)
 			ath6kl_warn("Failed to boot hw in resume: %d\n", ret);
 			return ret;
 		}
+		break;
 
 	default:
 		break;
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index b576b76..0586b3b 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -798,6 +798,23 @@ static int ath6kl_sdio_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 		return ret;
 	}
 
+	if ((flags & MMC_PM_WAKE_SDIO_IRQ) && wow) {
+		/*
+		 * The host sdio controller is capable of keep power and
+		 * sdio irq wake up at this point. It's fine to continue
+		 * wow suspend operation.
+		 */
+		ret = ath6kl_cfg80211_suspend(ar, ATH6KL_CFG_SUSPEND_WOW, wow);
+		if (ret)
+			return ret;
+
+		ret = sdio_set_host_pm_flags(func, MMC_PM_WAKE_SDIO_IRQ);
+		if (ret)
+			ath6kl_err("set sdio wake irq flag failed: %d\n", ret);
+
+		return ret;
+	}
+
 	return ath6kl_cfg80211_suspend(ar, ATH6KL_CFG_SUSPEND_DEEPSLEEP, NULL);
 }
 
@@ -820,6 +837,9 @@ static int ath6kl_sdio_resume(struct ath6kl *ar)
 
 	case ATH6KL_STATE_DEEPSLEEP:
 		break;
+
+	case ATH6KL_STATE_WOW:
+		break;
 	}
 
 	ath6kl_cfg80211_resume(ar);
-- 
1.7.1

