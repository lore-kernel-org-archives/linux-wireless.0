Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33919 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab2A3Lnu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 06:43:50 -0500
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH v3 1/4] ath6kl: Re-architect suspend mode handling in ath6kl_sdio_suspend
Date: Mon, 30 Jan 2012 17:13:09 +0530
Message-ID: <1327923792-16408-2-git-send-email-rmani@qca.qualcomm.com> (sfid-20120130_124419_417397_44BD983A)
In-Reply-To: <1327923792-16408-1-git-send-email-rmani@qca.qualcomm.com>
References: <1327923792-16408-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

Using this patch, the user can bypass existing auto
suspend mode selection logic and force ath6kl to enter
into the suspend mode what he/she wants.

If the user doesn't choose any suspend mode while doing
insmod of the driver, auto suspend mode selection logic
will kick in and choose suspend mode based on the host
SDIO controller capability.

Generic module parameter is required to specify suspend
mode including Deep Sleep and WOW while doing insmod.
Renaming existing mod param variable suspend_cutpower
would be sufficient to meet this requirement.

New module parameter suspend_mode can take any one of
the below suspend state,
   1. cut power
   2. deep sleep
   3. wow

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.c |   12 +++--
 drivers/net/wireless/ath/ath6kl/core.h |    4 +-
 drivers/net/wireless/ath/ath6kl/sdio.c |   86 ++++++++++++++++++++------------
 3 files changed, 64 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.c b/drivers/net/wireless/ath/ath6kl/core.c
index 0d92e71..a0b7684 100644
--- a/drivers/net/wireless/ath/ath6kl/core.c
+++ b/drivers/net/wireless/ath/ath6kl/core.c
@@ -25,12 +25,12 @@
 #include "cfg80211.h"
 
 unsigned int debug_mask;
-static bool suspend_cutpower;
+static unsigned int suspend_mode;
 static unsigned int uart_debug;
 static unsigned int ath6kl_p2p;
 
 module_param(debug_mask, uint, 0644);
-module_param(suspend_cutpower, bool, 0444);
+module_param(suspend_mode, uint, 0644);
 module_param(uart_debug, uint, 0644);
 module_param(ath6kl_p2p, uint, 0644);
 
@@ -143,8 +143,12 @@ int ath6kl_core_init(struct ath6kl *ar)
 	ar->conf_flags = ATH6KL_CONF_IGNORE_ERP_BARKER |
 			 ATH6KL_CONF_ENABLE_11N | ATH6KL_CONF_ENABLE_TX_BURST;
 
-	if (suspend_cutpower)
-		ar->conf_flags |= ATH6KL_CONF_SUSPEND_CUTPOWER;
+	if (suspend_mode &&
+		suspend_mode >= WLAN_POWER_STATE_CUT_PWR &&
+		suspend_mode <= WLAN_POWER_STATE_WOW)
+		ar->suspend_mode = suspend_mode;
+	else
+		ar->suspend_mode = 0;
 
 	if (uart_debug)
 		ar->conf_flags |= ATH6KL_CONF_UART_DEBUG;
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index ed9fcc1..ab232c5 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -196,8 +196,7 @@ struct ath6kl_fw_ie {
 #define ATH6KL_CONF_IGNORE_PS_FAIL_EVT_IN_SCAN  BIT(1)
 #define ATH6KL_CONF_ENABLE_11N			BIT(2)
 #define ATH6KL_CONF_ENABLE_TX_BURST		BIT(3)
-#define ATH6KL_CONF_SUSPEND_CUTPOWER		BIT(4)
-#define ATH6KL_CONF_UART_DEBUG			BIT(5)
+#define ATH6KL_CONF_UART_DEBUG			BIT(4)
 
 enum wlan_low_pwr_state {
 	WLAN_POWER_STATE_ON,
@@ -618,6 +617,7 @@ struct ath6kl {
 	} hw;
 
 	u16 conf_flags;
+	u16 suspend_mode;
 	wait_queue_head_t event_wq;
 	struct ath6kl_mbox_info mbox_info;
 
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index d9f5591..07dcf00 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -779,7 +779,7 @@ out:
 	return ret;
 }
 
-static int ath6kl_sdio_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
+static int ath6kl_set_sdio_pm_caps(struct ath6kl *ar)
 {
 	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
 	struct sdio_func *func = ar_sdio->func;
@@ -790,60 +790,82 @@ static int ath6kl_sdio_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 
 	ath6kl_dbg(ATH6KL_DBG_SUSPEND, "sdio suspend pm_caps 0x%x\n", flags);
 
-	if (!(flags & MMC_PM_KEEP_POWER) ||
-	    (ar->conf_flags & ATH6KL_CONF_SUSPEND_CUTPOWER)) {
-		/* as host doesn't support keep power we need to cut power */
-		return ath6kl_cfg80211_suspend(ar, ATH6KL_CFG_SUSPEND_CUTPOWER,
-					       NULL);
-	}
+	if (!(flags & MMC_PM_WAKE_SDIO_IRQ) ||
+	    !(flags & MMC_PM_KEEP_POWER))
+		return -EINVAL;
 
 	ret = sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
 	if (ret) {
-		printk(KERN_ERR "ath6kl: set sdio pm flags failed: %d\n",
-		       ret);
+		ath6kl_err("set sdio keep pwr flag failed: %d\n", ret);
 		return ret;
 	}
 
-	if (!(flags & MMC_PM_WAKE_SDIO_IRQ))
-		goto deepsleep;
-
 	/* sdio irq wakes up host */
+	ret = sdio_set_host_pm_flags(func, MMC_PM_WAKE_SDIO_IRQ);
+	if (ret)
+		ath6kl_err("set sdio wake irq flag failed: %d\n", ret);
+
+	return ret;
+}
+
+static int ath6kl_sdio_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
+{
+	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
+	struct sdio_func *func = ar_sdio->func;
+	mmc_pm_flag_t flags;
+	int ret;
 
 	if (ar->state == ATH6KL_STATE_SCHED_SCAN) {
+		ath6kl_dbg(ATH6KL_DBG_SUSPEND, "sched scan is in progress\n");
+
+		ret = ath6kl_set_sdio_pm_caps(ar);
+		if (ret)
+			goto cut_pwr;
+
 		ret =  ath6kl_cfg80211_suspend(ar,
 					       ATH6KL_CFG_SUSPEND_SCHED_SCAN,
 					       NULL);
-		if (ret) {
-			ath6kl_warn("Schedule scan suspend failed: %d", ret);
-			return ret;
-		}
-
-		ret = sdio_set_host_pm_flags(func, MMC_PM_WAKE_SDIO_IRQ);
 		if (ret)
-			ath6kl_warn("set sdio wake irq flag failed: %d\n", ret);
+			goto cut_pwr;
 
-		return ret;
+		return 0;
 	}
 
-	if (wow) {
-		/*
-		 * The host sdio controller is capable of keep power and
-		 * sdio irq wake up at this point. It's fine to continue
-		 * wow suspend operation.
-		 */
+	if (ar->suspend_mode == WLAN_POWER_STATE_WOW ||
+	    (!ar->suspend_mode && wow)) {
+
+		ret = ath6kl_set_sdio_pm_caps(ar);
+		if (ret)
+			goto cut_pwr;
+
 		ret = ath6kl_cfg80211_suspend(ar, ATH6KL_CFG_SUSPEND_WOW, wow);
 		if (ret)
-			return ret;
+			goto cut_pwr;
+
+		return 0;
+	}
+
+	if (ar->suspend_mode == WLAN_POWER_STATE_DEEP_SLEEP ||
+	    !ar->suspend_mode) {
 
-		ret = sdio_set_host_pm_flags(func, MMC_PM_WAKE_SDIO_IRQ);
+		flags = sdio_get_host_pm_caps(func);
+		if (!(flags & MMC_PM_KEEP_POWER))
+			goto cut_pwr;
+
+		ret = sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
 		if (ret)
-			ath6kl_err("set sdio wake irq flag failed: %d\n", ret);
+			goto cut_pwr;
 
-		return ret;
+		ret = ath6kl_cfg80211_suspend(ar, ATH6KL_CFG_SUSPEND_DEEPSLEEP,
+					      NULL);
+		if (ret)
+			goto cut_pwr;
+
+		return 0;
 	}
 
-deepsleep:
-	return ath6kl_cfg80211_suspend(ar, ATH6KL_CFG_SUSPEND_DEEPSLEEP, NULL);
+cut_pwr:
+	return ath6kl_cfg80211_suspend(ar, ATH6KL_CFG_SUSPEND_CUTPOWER, NULL);
 }
 
 static int ath6kl_sdio_resume(struct ath6kl *ar)
-- 
1.7.1

