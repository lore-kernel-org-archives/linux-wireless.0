Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:5156 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbXLFIKA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2007 03:10:00 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 2.6.24] iwlwifi: fix rf_kill state inconsistent during suspend and resume
Date: Thu,  6 Dec 2007 16:08:44 +0800
Message-Id: <1196928524-9384-1-git-send-email-yi.zhu@intel.com> (sfid-20071206_081014_001660_299CE7A9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch fixes the STATUS_RF_KILL_HW state is not cleared problem if the
device goes to suspend when the rf_kill switch is enabled. The bug causes
the driver always thinks the rf_kill switch is enabled (although it is
disabled) after resume.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 +++-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 4bdf237..5eabce7 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4743,8 +4743,10 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 		 *   when we loaded driver, and is now set to "enable".
 		 * After we're Alive, RF_KILL gets handled by
 		 *   iwl_rx_card_state_notif() */
-		if (!hw_rf_kill && !test_bit(STATUS_ALIVE, &priv->status))
+		if (!hw_rf_kill && !test_bit(STATUS_ALIVE, &priv->status)) {
+			clear_bit(STATUS_RF_KILL_HW, &priv->status);
 			queue_work(priv->workqueue, &priv->restart);
+		}
 
 		handled |= CSR_INT_BIT_RF_KILL;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 8f85564..3097323 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -5059,8 +5059,10 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 		 *   when we loaded driver, and is now set to "enable".
 		 * After we're Alive, RF_KILL gets handled by
 		 *   iwl_rx_card_state_notif() */
-		if (!hw_rf_kill && !test_bit(STATUS_ALIVE, &priv->status))
+		if (!hw_rf_kill && !test_bit(STATUS_ALIVE, &priv->status)) {
+			clear_bit(STATUS_RF_KILL_HW, &priv->status);
 			queue_work(priv->workqueue, &priv->restart);
+		}
 
 		handled |= CSR_INT_BIT_RF_KILL;
 	}
-- 
1.5.3.6
