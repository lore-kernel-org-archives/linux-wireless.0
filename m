Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24559 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab2AIIhK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 03:37:10 -0500
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH 1/8] ath6kl: Rename modparam variable suspend_cutpower to suspend_mode
Date: Mon, 9 Jan 2012 14:06:15 +0530
Message-ID: <1326098182-9103-2-git-send-email-rmani@qca.qualcomm.com> (sfid-20120109_093715_933835_B526D59C)
In-Reply-To: <1326098182-9103-1-git-send-email-rmani@qca.qualcomm.com>
References: <1326098182-9103-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

suspend_cutpower was introduced to force cut power mode when
system goes to suspend state. Now, generic module parameter
is required to specify suspend mode including DEEP SLEEP and WOW
while doing insmod. Renaming existing module parameter variable
suspend_cutpower would be sufficient to meet this requirement.

suspend_mode can take any one of three suspend state,
   1) cut power
   2) deep sleep
   3) wow

For invalid value other than above mode, cut power mode will be
selected.

To avoid externing mod parameter suspend_mode, new variable
ar->suspend_mode is added to have copy of mod param variable
and will be in sdio.c in the following patches.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    1 +
 drivers/net/wireless/ath/ath6kl/init.c |   11 +++++++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index c095faf..be61fc3 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -590,6 +590,7 @@ struct ath6kl {
 	} hw;
 
 	u16 conf_flags;
+	u8 suspend_mode;
 	wait_queue_head_t event_wq;
 	struct ath6kl_mbox_info mbox_info;
 
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index a481b6a..feff095 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -27,12 +27,12 @@
 
 unsigned int debug_mask;
 static unsigned int testmode;
-static bool suspend_cutpower;
+static unsigned char suspend_mode;
 static unsigned int uart_debug;
 
 module_param(debug_mask, uint, 0644);
 module_param(testmode, uint, 0644);
-module_param(suspend_cutpower, bool, 0444);
+module_param(suspend_mode, byte, 0644);
 module_param(uart_debug, uint, 0644);
 
 static const struct ath6kl_hw hw_list[] = {
@@ -1676,8 +1676,11 @@ int ath6kl_core_init(struct ath6kl *ar)
 	ar->conf_flags = ATH6KL_CONF_IGNORE_ERP_BARKER |
 			 ATH6KL_CONF_ENABLE_11N | ATH6KL_CONF_ENABLE_TX_BURST;
 
-	if (suspend_cutpower)
-		ar->conf_flags |= ATH6KL_CONF_SUSPEND_CUTPOWER;
+	if (suspend_mode < WLAN_POWER_STATE_CUT_PWR ||
+	    suspend_mode > WLAN_POWER_STATE_WOW)
+		ar->suspend_mode = WLAN_POWER_STATE_CUT_PWR;
+	else
+		ar->suspend_mode = suspend_mode;
 
 	ar->wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM |
 			    WIPHY_FLAG_HAVE_AP_SME |
-- 
1.7.1

