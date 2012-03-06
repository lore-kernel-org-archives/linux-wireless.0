Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29680 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756709Ab2CFJeM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 04:34:12 -0500
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH v2] ath6kl: Add provision to define suspend policy in disconnected state.
Date: Tue, 6 Mar 2012 15:03:59 +0530
Message-ID: <1331026439-7822-1-git-send-email-rmani@qca.qualcomm.com> (sfid-20120306_103430_556310_F0F1B1D7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

It gives flexibility to the user to define suspend policy
when the suspend mode is set to WOW and the device is in
disconnected state at the time of suspend.

New module parameter wow_mode is added to get the choice
from the user. This parameter is valid only if the module
parameter suspend_mode is set to WOW.

To force WOW in connected state and cut power
in disconnected state:
  suspend_mode=0x3 wow_mode=0x1

To force WOW in connected state and deep sleep
in disconnected state:
   suspend_mode=0x3 wow_mode=0x2

If there is no value specified to wow_mode during insmod,
deep sleep mode will be tried in the disconnected state.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
V2:
   - Bit usage of suspend_mode is removed and new mod param
     wow_mode is introduced.
   - wow2_suspend_mode variable is renamed to wow_suspend_mode

 drivers/net/wireless/ath/ath6kl/cfg80211.c |    5 ++---
 drivers/net/wireless/ath/ath6kl/core.c     |    9 +++++++++
 drivers/net/wireless/ath/ath6kl/core.h     |    1 +
 drivers/net/wireless/ath/ath6kl/sdio.c     |   18 +++++++++++++-----
 4 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 9abc7a6..5285294 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2046,10 +2046,9 @@ int ath6kl_cfg80211_suspend(struct ath6kl *ar,
 		ath6kl_tx_data_cleanup(ar);
 
 		ret = ath6kl_wow_suspend(ar, wow);
-		if (ret) {
-			ath6kl_err("wow suspend failed: %d\n", ret);
+		if (ret)
 			return ret;
-		}
+
 		ar->state = ATH6KL_STATE_WOW;
 		break;
 
diff --git a/drivers/net/wireless/ath/ath6kl/core.c b/drivers/net/wireless/ath/ath6kl/core.c
index e66cf43..e404db2 100644
--- a/drivers/net/wireless/ath/ath6kl/core.c
+++ b/drivers/net/wireless/ath/ath6kl/core.c
@@ -27,12 +27,14 @@
 
 unsigned int debug_mask;
 static unsigned int suspend_mode;
+static unsigned int wow_mode;
 static unsigned int uart_debug;
 static unsigned int ath6kl_p2p;
 static unsigned int testmode;
 
 module_param(debug_mask, uint, 0644);
 module_param(suspend_mode, uint, 0644);
+module_param(wow_mode, uint, 0644);
 module_param(uart_debug, uint, 0644);
 module_param(ath6kl_p2p, uint, 0644);
 module_param(testmode, uint, 0644);
@@ -119,6 +121,13 @@ int ath6kl_core_init(struct ath6kl *ar)
 	else
 		ar->suspend_mode = 0;
 
+	if (suspend_mode == WLAN_POWER_STATE_WOW &&
+	    (wow_mode == WLAN_POWER_STATE_CUT_PWR ||
+	     wow_mode == WLAN_POWER_STATE_DEEP_SLEEP))
+		ar->wow_suspend_mode = wow_mode;
+	else
+		ar->wow_suspend_mode = 0;
+
 	if (uart_debug)
 		ar->conf_flags |= ATH6KL_CONF_UART_DEBUG;
 
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index b6bdece..b9d810f 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -636,6 +636,7 @@ struct ath6kl {
 
 	u16 conf_flags;
 	u16 suspend_mode;
+	u16 wow_suspend_mode;
 	wait_queue_head_t event_wq;
 	struct ath6kl_mbox_info mbox_info;
 
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index e2f42a1..9b6282a 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -836,6 +836,7 @@ static int ath6kl_sdio_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
 	struct sdio_func *func = ar_sdio->func;
 	mmc_pm_flag_t flags;
+	bool try_deepsleep = false;
 	int ret;
 
 	if (ar->state == ATH6KL_STATE_SCHED_SCAN) {
@@ -862,14 +863,21 @@ static int ath6kl_sdio_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 			goto cut_pwr;
 
 		ret = ath6kl_cfg80211_suspend(ar, ATH6KL_CFG_SUSPEND_WOW, wow);
-		if (ret)
-			goto cut_pwr;
-
-		return 0;
+		if (ret && ret != -ENOTCONN)
+			ath6kl_err("wow suspend failed: %d\n", ret);
+
+		if (ret && (!ar->wow_suspend_mode ||
+		    ar->wow_suspend_mode == WLAN_POWER_STATE_DEEP_SLEEP))
+				try_deepsleep = true;
+		else if (ret &&
+			 ar->wow_suspend_mode == WLAN_POWER_STATE_CUT_PWR)
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

