Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:8682 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932079Ab1DVRzO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2011 13:55:14 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/10] iwlagn: refactor up path
Date: Fri, 22 Apr 2011 10:33:12 -0700
Message-Id: <1303493598-10979-5-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1303493598-10979-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1303493598-10979-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Starting the device consists of many things,
refactor out enabling the hardware and also
return -ERFKILL when the rfkill signal is
found to be asserted (which makes more sense
anyway, but is also required now to make the
__iwl_up function return right away.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   46 ++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c     |   44 ++-------------------------
 drivers/net/wireless/iwlwifi/iwl-agn.h     |    2 +
 3 files changed, 51 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 5c7eeac..5e62a08 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -2294,6 +2294,52 @@ void iwlagn_remove_notification(struct iwl_priv *priv,
 	spin_unlock_bh(&priv->_agn.notif_wait_lock);
 }
 
+int iwlagn_start_device(struct iwl_priv *priv)
+{
+	int ret;
+
+	iwl_prepare_card_hw(priv);
+	if (!priv->hw_ready) {
+		IWL_WARN(priv, "Exit HW not ready\n");
+		return -EIO;
+	}
+
+	/* If platform's RF_KILL switch is NOT set to KILL */
+	if (iwl_read32(priv, CSR_GP_CNTRL) & CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
+		clear_bit(STATUS_RF_KILL_HW, &priv->status);
+	else
+		set_bit(STATUS_RF_KILL_HW, &priv->status);
+
+	if (iwl_is_rfkill(priv)) {
+		wiphy_rfkill_set_hw_state(priv->hw->wiphy, true);
+		iwl_enable_interrupts(priv);
+		return -ERFKILL;
+	}
+
+	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
+
+	ret = iwlagn_hw_nic_init(priv);
+	if (ret) {
+		IWL_ERR(priv, "Unable to init nic\n");
+		return ret;
+	}
+
+	/* make sure rfkill handshake bits are cleared */
+	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR,
+		    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
+
+	/* clear (again), then enable host interrupts */
+	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
+	iwl_enable_interrupts(priv);
+
+	/* really make sure rfkill handshake bits are cleared */
+	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
+
+	return 0;
+}
+
 void iwlagn_stop_device(struct iwl_priv *priv)
 {
 	unsigned long flags;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index f3d9055..e99cd94 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2416,7 +2416,7 @@ static int iwl_set_hw_ready(struct iwl_priv *priv)
 	return ret;
 }
 
-static int iwl_prepare_card_hw(struct iwl_priv *priv)
+int iwl_prepare_card_hw(struct iwl_priv *priv)
 {
 	int ret = 0;
 
@@ -2462,47 +2462,9 @@ static int __iwl_up(struct iwl_priv *priv)
 		}
 	}
 
-	iwl_prepare_card_hw(priv);
-
-	if (!priv->hw_ready) {
-		IWL_WARN(priv, "Exit HW not ready\n");
-		return -EIO;
-	}
-
-	/* If platform's RF_KILL switch is NOT set to KILL */
-	if (iwl_read32(priv, CSR_GP_CNTRL) & CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
-		clear_bit(STATUS_RF_KILL_HW, &priv->status);
-	else
-		set_bit(STATUS_RF_KILL_HW, &priv->status);
-
-	if (iwl_is_rfkill(priv)) {
-		wiphy_rfkill_set_hw_state(priv->hw->wiphy, true);
-
-		iwl_enable_interrupts(priv);
-		IWL_WARN(priv, "Radio disabled by HW RF Kill switch\n");
-		return 0;
-	}
-
-	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
-
-	ret = iwlagn_hw_nic_init(priv);
-	if (ret) {
-		IWL_ERR(priv, "Unable to init nic\n");
+	ret = iwlagn_start_device(priv);
+	if (ret)
 		return ret;
-	}
-
-	/* make sure rfkill handshake bits are cleared */
-	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR,
-		    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
-
-	/* clear (again), then enable host interrupts */
-	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
-	iwl_enable_interrupts(priv);
-
-	/* really make sure rfkill handshake bits are cleared */
-	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
 
 	for (i = 0; i < MAX_HW_RESTARTS; i++) {
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 1211f45..ef1bbd4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -128,7 +128,9 @@ static inline void iwl_synchronize_irq(struct iwl_priv *priv)
 	tasklet_kill(&priv->irq_tasklet);
 }
 
+int iwl_prepare_card_hw(struct iwl_priv *priv);
 
+int iwlagn_start_device(struct iwl_priv *priv);
 void iwlagn_stop_device(struct iwl_priv *priv);
 
 /* tx queue */
-- 
1.7.0.4

