Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:7191 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687Ab1HZGxc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 02:53:32 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 20/60] iwlagn: move iwl_suspend / iwl_resume to the transport layer
Date: Thu, 25 Aug 2011 23:10:52 -0700
Message-Id: <1314339092-20797-21-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110826_085512_857426_85BEE175)
In-Reply-To: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1314339092-20797-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

These flows needs to access the APM and a few other registers that can differ
between different transports.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c    |   10 +++---
 drivers/net/wireless/iwlwifi/iwl-core.c   |   41 -----------------------
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    2 -
 drivers/net/wireless/iwlwifi/iwl-pci.c    |    4 +-
 drivers/net/wireless/iwlwifi/iwl-power.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h |    1 +
 drivers/net/wireless/iwlwifi/iwl-trans.c  |   50 +++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans.h  |   14 ++++++++
 8 files changed, 73 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index fcbc3b1..660abed 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1818,7 +1818,7 @@ int iwl_alive_start(struct iwl_priv *priv)
 	/* Configure Tx antenna selection based on H/W config */
 	iwlagn_send_tx_ant_config(priv, priv->cfg->valid_tx_ant);
 
-	if (iwl_is_associated_ctx(ctx) && !priv->wowlan) {
+	if (iwl_is_associated_ctx(ctx) && !priv->shrd->wowlan) {
 		struct iwl_rxon_cmd *active_rxon =
 				(struct iwl_rxon_cmd *)&ctx->active;
 		/* apply any changes in staging */
@@ -1833,7 +1833,7 @@ int iwl_alive_start(struct iwl_priv *priv)
 		iwlagn_set_rxon_chain(priv, ctx);
 	}
 
-	if (!priv->wowlan) {
+	if (!priv->shrd->wowlan) {
 		/* WoWLAN ucode will not reply in the same way, skip it */
 		iwl_reset_run_time_calib(priv);
 	}
@@ -2593,7 +2593,7 @@ static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
 
 	iwl_trans_stop_device(trans(priv));
 
-	priv->wowlan = true;
+	priv->shrd->wowlan = true;
 
 	ret = iwlagn_load_ucode_wait_alive(priv, &priv->ucode_wowlan,
 					   IWL_UCODE_WOWLAN);
@@ -2693,7 +2693,7 @@ static int iwlagn_mac_suspend(struct ieee80211_hw *hw,
 	goto out;
 
  error:
-	priv->wowlan = false;
+	priv->shrd->wowlan = false;
 	iwlagn_prepare_restart(priv);
 	ieee80211_restart_hw(priv->hw);
  out:
@@ -2745,7 +2745,7 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 	/* we'll clear ctx->vif during iwlagn_prepare_restart() */
 	vif = ctx->vif;
 
-	priv->wowlan = false;
+	priv->shrd->wowlan = false;
 
 	device_set_wakeup_enable(priv->bus->dev, false);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index b5e99a6..d77af69 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1900,44 +1900,3 @@ __le32 iwl_add_beacon_time(struct iwl_priv *priv, u32 base,
 	return cpu_to_le32(res);
 }
 
-#ifdef CONFIG_PM
-
-int iwl_suspend(struct iwl_priv *priv)
-{
-	/*
-	 * This function is called when system goes into suspend state
-	 * mac80211 will call iwl_mac_stop() from the mac80211 suspend function
-	 * first but since iwl_mac_stop() has no knowledge of who the caller is,
-	 * it will not call apm_ops.stop() to stop the DMA operation.
-	 * Calling apm_ops.stop here to make sure we stop the DMA.
-	 *
-	 * But of course ... if we have configured WoWLAN then we did other
-	 * things already :-)
-	 */
-	if (!priv->wowlan)
-		iwl_apm_stop(priv);
-
-	return 0;
-}
-
-int iwl_resume(struct iwl_priv *priv)
-{
-	bool hw_rfkill = false;
-
-	iwl_enable_interrupts(priv);
-
-	if (!(iwl_read32(priv, CSR_GP_CNTRL) &
-				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
-		hw_rfkill = true;
-
-	if (hw_rfkill)
-		set_bit(STATUS_RF_KILL_HW, &priv->shrd->status);
-	else
-		clear_bit(STATUS_RF_KILL_HW, &priv->shrd->status);
-
-	wiphy_rfkill_set_hw_state(priv->hw->wiphy, hw_rfkill);
-
-	return 0;
-}
-
-#endif /* CONFIG_PM */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 9c9dc19..8a8fc74 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1280,8 +1280,6 @@ struct iwl_priv {
 
 	u8 mac80211_registered;
 
-	bool wowlan;
-
 	/* eeprom -- this is in the card's little endian byte order */
 	u8 *eeprom;
 	int    nvm_device_type;
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 521d7e2..4b99090 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -517,7 +517,7 @@ static int iwl_pci_suspend(struct device *device)
 	 * WoWLAN is enabled - don't kill the NIC, someone may need it in Sx.
 	 */
 
-	return iwl_suspend(shrd->priv);
+	return iwl_trans_suspend(shrd->trans);
 }
 
 static int iwl_pci_resume(struct device *device)
@@ -536,7 +536,7 @@ static int iwl_pci_resume(struct device *device)
 	 */
 	pci_write_config_byte(pdev, PCI_CFG_RETRY_TIMEOUT, 0x00);
 
-	return iwl_resume(shrd->priv);
+	return iwl_trans_resume(shrd->trans);
 }
 
 static SIMPLE_DEV_PM_OPS(iwl_dev_pm_ops, iwl_pci_suspend, iwl_pci_resume);
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 5ecb11e..9f0e620 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -348,7 +348,7 @@ static void iwl_power_build_cmd(struct iwl_priv *priv,
 
 	dtimper = priv->hw->conf.ps_dtim_period ?: 1;
 
-	if (priv->wowlan)
+	if (priv->shrd->wowlan)
 		iwl_static_sleep_cmd(priv, cmd, IWL_POWER_INDEX_5, dtimper);
 	else if (!priv->cfg->base_params->no_idle_support &&
 		 priv->hw->conf.flags & IEEE80211_CONF_IDLE)
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 539b76b..a5ef79b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -165,6 +165,7 @@ struct iwl_shared {
 
 	u8 cmd_queue;
 	unsigned long status;
+	bool wowlan;
 
 	struct iwl_bus *bus;
 	struct iwl_priv *priv;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 95d7b04..621b9a8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -1167,6 +1167,54 @@ static void iwl_trans_pcie_free(struct iwl_priv *priv)
 	trans(priv) = NULL;
 }
 
+#ifdef CONFIG_PM
+
+static int iwl_trans_pcie_suspend(struct iwl_trans *trans)
+{
+	/*
+	 * This function is called when system goes into suspend state
+	 * mac80211 will call iwl_mac_stop() from the mac80211 suspend function
+	 * first but since iwl_mac_stop() has no knowledge of who the caller is,
+	 * it will not call apm_ops.stop() to stop the DMA operation.
+	 * Calling apm_ops.stop here to make sure we stop the DMA.
+	 *
+	 * But of course ... if we have configured WoWLAN then we did other
+	 * things already :-)
+	 */
+	if (!trans->shrd->wowlan)
+		iwl_apm_stop(priv(trans));
+
+	return 0;
+}
+
+static int iwl_trans_pcie_resume(struct iwl_trans *trans)
+{
+	bool hw_rfkill = false;
+
+	iwl_enable_interrupts(priv(trans));
+
+	if (!(iwl_read32(priv(trans), CSR_GP_CNTRL) &
+				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
+		hw_rfkill = true;
+
+	if (hw_rfkill)
+		set_bit(STATUS_RF_KILL_HW, &trans->shrd->status);
+	else
+		clear_bit(STATUS_RF_KILL_HW, &trans->shrd->status);
+
+	wiphy_rfkill_set_hw_state(priv(trans)->hw->wiphy, hw_rfkill);
+
+	return 0;
+}
+#else /* CONFIG_PM */
+static int iwl_trans_pcie_suspend(struct iwl_trans *trans)
+{ return 0; }
+
+static int iwl_trans_pcie_resume(struct iwl_trans *trans)
+{ return 0; }
+
+#endif /* CONFIG_PM */
+
 const struct iwl_trans_ops trans_ops_pcie;
 
 static struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd)
@@ -1456,5 +1504,7 @@ const struct iwl_trans_ops trans_ops_pcie = {
 	.free = iwl_trans_pcie_free,
 
 	.dbgfs_register = iwl_trans_pcie_dbgfs_register,
+	.suspend = iwl_trans_pcie_suspend,
+	.resume = iwl_trans_pcie_resume,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 8eee910..c12763c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -102,6 +102,8 @@ struct iwl_shared;
  *        irq, tasklet etc...
  * @dbgfs_register: add the dbgfs files under this directory. Files will be
  *	automatically deleted.
+ * @suspend: stop the device unless WoWLAN is configured
+ * @resume: resume activity of the device
  */
 struct iwl_trans_ops {
 
@@ -134,6 +136,8 @@ struct iwl_trans_ops {
 	void (*free)(struct iwl_priv *priv);
 
 	int (*dbgfs_register)(struct iwl_trans *trans, struct dentry* dir);
+	int (*suspend)(struct iwl_trans *trans);
+	int (*resume)(struct iwl_trans *trans);
 };
 
 /**
@@ -244,6 +248,16 @@ static inline int iwl_trans_dbgfs_register(struct iwl_trans *trans,
 	return trans->ops->dbgfs_register(trans, dir);
 }
 
+static inline int iwl_trans_suspend(struct iwl_trans *trans)
+{
+	return trans->ops->suspend(trans);
+}
+
+static inline int iwl_trans_resume(struct iwl_trans *trans)
+{
+	return trans->ops->resume(trans);
+}
+
 /*****************************************************
 * Transport layers implementations
 ******************************************************/
-- 
1.7.0.4

