Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34360 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab2BOMXF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 07:23:05 -0500
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH] ath6kl: Add provision to define suspend policy in disconnected state.
Date: Wed, 15 Feb 2012 17:52:08 +0530
Message-ID: <1329308528-2925-1-git-send-email-rmani@qca.qualcomm.com> (sfid-20120215_132310_836547_F0869DD1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

It gives flexibility to the user to define suspend policy
when the suspend mode is set to WOW and the device is in 
disconnected state at the time of suspend.

Some bits (bit 4 to 7) of existing mod parameter suspend_mode
is used for that purpose. There is no change in the existing
way of defining suspend mode.

To force cut power:
  suspend_mode=0x1

To force deep sleep:
  suspend_mode=0x2

To force wow (deep sleep is the default mode
in disconnected state):
  suspend_mode=0x3

To force wow in connected state and cut power
in disconnected state:
  suspend_mode=0x13

To force wow in connected state and deep sleep
in disconnected state:
  suspend_mode=0x23

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    1 -
 drivers/net/wireless/ath/ath6kl/core.c     |   26 ++++++++++++++++++++++----
 drivers/net/wireless/ath/ath6kl/core.h     |    1 +
 drivers/net/wireless/ath/ath6kl/sdio.c     |   18 +++++++++++++-----
 4 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 484400d..003f320 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2063,7 +2063,6 @@ int ath6kl_cfg80211_suspend(struct ath6kl *ar,
 
 		ret = ath6kl_wow_suspend(ar, wow);
 		if (ret) {
-			ath6kl_err("wow suspend failed: %d\n", ret);
 			ar->state = prev_state;
 			return ret;
 		}
diff --git a/drivers/net/wireless/ath/ath6kl/core.c b/drivers/net/wireless/ath/ath6kl/core.c
index c4926cf..37c92a1 100644
--- a/drivers/net/wireless/ath/ath6kl/core.c
+++ b/drivers/net/wireless/ath/ath6kl/core.c
@@ -41,6 +41,7 @@ int ath6kl_core_init(struct ath6kl *ar)
 {
 	struct ath6kl_bmi_target_info targ_info;
 	struct net_device *ndev;
+	u16 pri_suspend_mode, wow2_suspend_mode;
 	int ret = 0, i;
 
 	ar->ath6kl_wq = create_singlethread_workqueue("ath6kl");
@@ -148,13 +149,30 @@ int ath6kl_core_init(struct ath6kl *ar)
 	ar->conf_flags = ATH6KL_CONF_IGNORE_ERP_BARKER |
 			 ATH6KL_CONF_ENABLE_11N | ATH6KL_CONF_ENABLE_TX_BURST;
 
-	if (suspend_mode &&
-		suspend_mode >= WLAN_POWER_STATE_CUT_PWR &&
-		suspend_mode <= WLAN_POWER_STATE_WOW)
-		ar->suspend_mode = suspend_mode;
+	/*
+	 * Usage of module parameter 'suspend_mode':
+	 * Bit 3 to 0 - Primary suspend mode (deep sleep/cur pwr/wow).
+	 * Bit 7 to 4 - Suspend mode to use if the primary suspend mode
+	 *		is set to WoW and the device is not connected at
+	 *		the time of suspend.
+	 */
+	pri_suspend_mode = suspend_mode & 0xF;
+	wow2_suspend_mode = (suspend_mode >> 4) & 0xF;
+
+	if (pri_suspend_mode &&
+	    pri_suspend_mode >= WLAN_POWER_STATE_CUT_PWR &&
+	    pri_suspend_mode <= WLAN_POWER_STATE_WOW)
+		ar->suspend_mode = pri_suspend_mode;
 	else
 		ar->suspend_mode = 0;
 
+	if (pri_suspend_mode == WLAN_POWER_STATE_WOW &&
+	    (wow2_suspend_mode == WLAN_POWER_STATE_CUT_PWR ||
+	     wow2_suspend_mode == WLAN_POWER_STATE_DEEP_SLEEP))
+		ar->wow2_suspend_mode = wow2_suspend_mode;
+	else
+		ar->wow2_suspend_mode = 0;
+
 	if (uart_debug)
 		ar->conf_flags |= ATH6KL_CONF_UART_DEBUG;
 
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index adfe8e8..808253e 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -623,6 +623,7 @@ struct ath6kl {
 
 	u16 conf_flags;
 	u16 suspend_mode;
+	u16 wow2_suspend_mode;
 	wait_queue_head_t event_wq;
 	struct ath6kl_mbox_info mbox_info;
 
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index fb6eb0f..a47f648 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -816,6 +816,7 @@ static int ath6kl_sdio_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
 	struct sdio_func *func = ar_sdio->func;
 	mmc_pm_flag_t flags;
+	bool try_deepsleep = false;
 	int ret;
 
 	if (ar->state == ATH6KL_STATE_SCHED_SCAN) {
@@ -842,14 +843,21 @@ static int ath6kl_sdio_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 			goto cut_pwr;
 
 		ret = ath6kl_cfg80211_suspend(ar, ATH6KL_CFG_SUSPEND_WOW, wow);
-		if (ret)
-			goto cut_pwr;
-
-		return 0;
+		if (ret && ret != -ENOTCONN)
+			ath6kl_err("wow suspend failed: %d\n", ret);
+
+		if (ret && (!ar->wow2_suspend_mode ||
+			 ar->wow2_suspend_mode == WLAN_POWER_STATE_DEEP_SLEEP))
+				try_deepsleep = true;
+		else if (ret &&
+			 ar->wow2_suspend_mode == WLAN_POWER_STATE_CUT_PWR)
+				goto cut_pwr;
+		if (!ret)
+			return 0;
 	}
 
 	if (ar->suspend_mode == WLAN_POWER_STATE_DEEP_SLEEP ||
-	    !ar->suspend_mode) {
+	    !ar->suspend_mode || try_deepsleep) {
 
 		flags = sdio_get_host_pm_caps(func);
 		if (!(flags & MMC_PM_KEEP_POWER))
-- 
1.7.1

