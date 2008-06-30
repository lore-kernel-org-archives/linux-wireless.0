Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18215 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759553AbYF3J1O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 05:27:14 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 25/33] iwlwifi: clean up HW RF-kill state machine and restarts
Date: Mon, 30 Jun 2008 17:23:25 +0800
Message-Id: <1214817813-17639-26-git-send-email-yi.zhu@intel.com> (sfid-20080630_113811_528358_D856ED7F)
In-Reply-To: <1214817813-17639-25-git-send-email-yi.zhu@intel.com>
References: <1214817813-17639-1-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-2-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-3-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-4-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-5-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-6-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-7-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-8-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-9-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-10-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-11-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-12-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-13-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-14-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-15-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-16-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-17-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-18-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-19-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-20-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-21-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-22-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-23-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-24-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-25-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch cleans up HW RF-kill state machine.

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c     |   15 ++++++++++++---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   12 +++++-------
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 08a42a7..eee220c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1407,7 +1407,14 @@ int iwl_radio_kill_sw_enable_radio(struct iwl_priv *priv)
 	spin_lock_irqsave(&priv->lock, flags);
 	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
 
-	clear_bit(STATUS_RF_KILL_SW, &priv->status);
+	/* If the driver is up it will receive CARD_STATE_NOTIFICATION
+	 * notification where it will clear SW rfkill status.
+	 * Setting it here would break the handler. Only if the
+	 * interface is down we can set here since we don't
+	 * receive any further notification.
+	 */
+	if (!priv->is_open)
+		clear_bit(STATUS_RF_KILL_SW, &priv->status);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	/* wake up ucode */
@@ -1425,8 +1432,10 @@ int iwl_radio_kill_sw_enable_radio(struct iwl_priv *priv)
 		return 0;
 	}
 
-	if (priv->is_open)
-		queue_work(priv->workqueue, &priv->restart);
+	/* If the driver is already loaded, it will receive
+	 * CARD_STATE_NOTIFICATION notifications and the handler will
+	 * call restart to reload the driver.
+	 */
 	return 1;
 }
 EXPORT_SYMBOL(iwl_radio_kill_sw_enable_radio);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index e9b6f30..a4aebe1 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1606,14 +1606,12 @@ static void iwl4965_irq_tasklet(struct iwl_priv *priv)
 		IWL_DEBUG(IWL_DL_RF_KILL, "RF_KILL bit toggled to %s.\n",
 				hw_rf_kill ? "disable radio":"enable radio");
 
-		/* Queue restart only if RF_KILL switch was set to "kill"
-		 *   when we loaded driver, and is now set to "enable".
-		 * After we're Alive, RF_KILL gets handled by
-		 *   iwl4965_rx_card_state_notif() */
-		if (!hw_rf_kill && !test_bit(STATUS_ALIVE, &priv->status)) {
+		/* driver only loads ucode once setting the interface up.
+		 * the driver as well won't allow loading if RFKILL is set
+		 * therefore no need to restart the driver from this handler
+		 */
+		if (!hw_rf_kill && !test_bit(STATUS_ALIVE, &priv->status))
 			clear_bit(STATUS_RF_KILL_HW, &priv->status);
-			queue_work(priv->workqueue, &priv->restart);
-		}
 
 		handled |= CSR_INT_BIT_RF_KILL;
 	}
-- 
1.5.3.6

