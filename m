Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:52052 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab1KCKSk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 06:18:40 -0400
Subject: [PATCH] ath6kl: add suspend_cutpower module parameter
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 03 Nov 2011 12:18:31 +0200
Message-ID: <20111103101831.15206.39020.stgit@localhost6.localdomain6> (sfid-20111103_111845_512769_AD6AF87A)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is to force ath6kl to power off hardware during suspend even if
sdio support keep power. This is needed, for example, when sdio
controller is buggy or maximum powersaving is desired.

Usage:

insmod ath6kl.ko suspend_cutpower=1

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    1 +
 drivers/net/wireless/ath/ath6kl/init.c |    5 +++++
 drivers/net/wireless/ath/ath6kl/sdio.c |    3 ++-
 3 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index f301c32..c30642e 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -166,6 +166,7 @@ struct ath6kl_fw_ie {
 #define ATH6KL_CONF_IGNORE_PS_FAIL_EVT_IN_SCAN  BIT(1)
 #define ATH6KL_CONF_ENABLE_11N			BIT(2)
 #define ATH6KL_CONF_ENABLE_TX_BURST		BIT(3)
+#define ATH6KL_CONF_SUSPEND_CUTPOWER		BIT(4)
 
 enum wlan_low_pwr_state {
 	WLAN_POWER_STATE_ON,
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 363fb3d..4881a18 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -27,9 +27,11 @@
 
 unsigned int debug_mask;
 static unsigned int testmode;
+static bool suspend_cutpower;
 
 module_param(debug_mask, uint, 0644);
 module_param(testmode, uint, 0644);
+module_param(suspend_cutpower, bool, 0444);
 
 /*
  * Include definitions here that can be used to tune the WLAN module
@@ -1596,6 +1598,9 @@ int ath6kl_core_init(struct ath6kl *ar)
 	ar->conf_flags = ATH6KL_CONF_IGNORE_ERP_BARKER |
 			 ATH6KL_CONF_ENABLE_11N | ATH6KL_CONF_ENABLE_TX_BURST;
 
+	if (suspend_cutpower)
+		ar->conf_flags |= ATH6KL_CONF_SUSPEND_CUTPOWER;
+
 	ar->wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM;
 
 	set_bit(FIRST_BOOT, &ar->flag);
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index ccb888b..a026dae 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -784,7 +784,8 @@ static int ath6kl_sdio_suspend(struct ath6kl *ar)
 
 	ath6kl_dbg(ATH6KL_DBG_SUSPEND, "sdio suspend pm_caps 0x%x\n", flags);
 
-	if (!(flags & MMC_PM_KEEP_POWER)) {
+	if (!(flags & MMC_PM_KEEP_POWER) ||
+	    (ar->conf_flags & ATH6KL_CONF_SUSPEND_CUTPOWER)) {
 		/* as host doesn't support keep power we need to cut power */
 		return ath6kl_cfg80211_suspend(ar, ATH6KL_CFG_SUSPEND_CUTPOWER);
 	}

