Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51901 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754919AbZCZRIn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 13:08:43 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/3] iwlwifi: merge and better support of suspend/resume for iwlagn and iwl3945
Date: Thu, 26 Mar 2009 10:14:08 -0700
Message-Id: <1238087650-26993-2-git-send-email-reinette.chatre@intel.com> (sfid-20090326_180847_812946_1753BDD4)
In-Reply-To: <1238087650-26993-1-git-send-email-reinette.chatre@intel.com>
References: <1238087650-26993-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

With mac80211's help to call stop() and start() in mac80211
suspend/resume function, both iwlagn and iwl3945 no longer calling
stop() and start(); remove un-necessary STATUS_IN_SUSPEND bit from both
header files and functions,

Move apm_ops.stop() function into pci_suspend() to ensure
DMA is stopped before go into suspend mode.

iwl3945 has the similar suspend/resume function as iwlagn, so move both
functions to iwlcore to be shared by both drivers.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   54 ++---------------------
 drivers/net/wireless/iwlwifi/iwl-core.c     |   40 +++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    5 ++-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    2 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   63 +++-----------------------
 6 files changed, 56 insertions(+), 109 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index ab7aaf6..29bc0d2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -162,7 +162,6 @@ struct iwl3945_frame {
 #define STATUS_TEMPERATURE	8
 #define STATUS_GEO_CONFIGURED	9
 #define STATUS_EXIT_PENDING	10
-#define STATUS_IN_SUSPEND	11
 #define STATUS_STATISTICS	12
 #define STATUS_SCANNING		13
 #define STATUS_SCAN_ABORTING	14
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 663dc83..669b435 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1654,7 +1654,7 @@ static void __iwl_down(struct iwl_priv *priv)
 		ieee80211_stop_queues(priv->hw);
 
 	/* If we have not previously called iwl_init() then
-	 * clear all bits but the RF Kill and SUSPEND bits and return */
+	 * clear all bits but the RF Kill bits and return */
 	if (!iwl_is_init(priv)) {
 		priv->status = test_bit(STATUS_RF_KILL_HW, &priv->status) <<
 					STATUS_RF_KILL_HW |
@@ -1662,23 +1662,19 @@ static void __iwl_down(struct iwl_priv *priv)
 					STATUS_RF_KILL_SW |
 			       test_bit(STATUS_GEO_CONFIGURED, &priv->status) <<
 					STATUS_GEO_CONFIGURED |
-			       test_bit(STATUS_IN_SUSPEND, &priv->status) <<
-					STATUS_IN_SUSPEND |
 			       test_bit(STATUS_EXIT_PENDING, &priv->status) <<
 					STATUS_EXIT_PENDING;
 		goto exit;
 	}
 
-	/* ...otherwise clear out all the status bits but the RF Kill and
-	 * SUSPEND bits and continue taking the NIC down. */
+	/* ...otherwise clear out all the status bits but the RF Kill
+	 * bits and continue taking the NIC down. */
 	priv->status &= test_bit(STATUS_RF_KILL_HW, &priv->status) <<
 				STATUS_RF_KILL_HW |
 			test_bit(STATUS_RF_KILL_SW, &priv->status) <<
 				STATUS_RF_KILL_SW |
 			test_bit(STATUS_GEO_CONFIGURED, &priv->status) <<
 				STATUS_GEO_CONFIGURED |
-			test_bit(STATUS_IN_SUSPEND, &priv->status) <<
-				STATUS_IN_SUSPEND |
 			test_bit(STATUS_FW_ERROR, &priv->status) <<
 				STATUS_FW_ERROR |
 		       test_bit(STATUS_EXIT_PENDING, &priv->status) <<
@@ -1703,7 +1699,7 @@ static void __iwl_down(struct iwl_priv *priv)
 	udelay(5);
 
 	/* FIXME: apm_ops.suspend(priv) */
-	if (exit_pending || test_bit(STATUS_IN_SUSPEND, &priv->status))
+	if (exit_pending)
 		priv->cfg->ops->lib->apm_ops.stop(priv);
 	else
 		priv->cfg->ops->lib->apm_ops.reset(priv);
@@ -2064,9 +2060,6 @@ static int iwl_mac_start(struct ieee80211_hw *hw)
 
 	IWL_DEBUG_INFO(priv, "Start UP work done.\n");
 
-	if (test_bit(STATUS_IN_SUSPEND, &priv->status))
-		return 0;
-
 	/* Wait for START_ALIVE from Run Time ucode. Otherwise callbacks from
 	 * mac80211 will not be run successfully. */
 	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
@@ -3566,45 +3559,6 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 	ieee80211_free_hw(priv->hw);
 }
 
-#ifdef CONFIG_PM
-
-static int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
-{
-	struct iwl_priv *priv = pci_get_drvdata(pdev);
-
-	if (priv->is_open) {
-		set_bit(STATUS_IN_SUSPEND, &priv->status);
-		iwl_mac_stop(priv->hw);
-		priv->is_open = 1;
-	}
-
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, PCI_D3hot);
-
-	return 0;
-}
-
-static int iwl_pci_resume(struct pci_dev *pdev)
-{
-	struct iwl_priv *priv = pci_get_drvdata(pdev);
-	int ret;
-
-	pci_set_power_state(pdev, PCI_D0);
-	ret = pci_enable_device(pdev);
-	if (ret)
-		return ret;
-	pci_restore_state(pdev);
-	iwl_enable_interrupts(priv);
-
-	if (priv->is_open)
-		iwl_mac_start(priv->hw);
-
-	clear_bit(STATUS_IN_SUSPEND, &priv->status);
-	return 0;
-}
-
-#endif /* CONFIG_PM */
 
 /*****************************************************************************
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 4b1298c..e1b5472 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2115,3 +2115,43 @@ void iwl_rx_reply_error(struct iwl_priv *priv,
 }
 EXPORT_SYMBOL(iwl_rx_reply_error);
 
+#ifdef CONFIG_PM
+
+int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct iwl_priv *priv = pci_get_drvdata(pdev);
+
+	/*
+	 * This function is called when system goes into suspend state
+	 * mac80211 will call iwl_mac_stop() from the mac80211 suspend function
+	 * first but since iwl_mac_stop() has no knowledge of who the caller is,
+	 * it will not call apm_ops.stop() to stop the DMA operation.
+	 * Calling apm_ops.stop here to make sure we stop the DMA.
+	 */
+	priv->cfg->ops->lib->apm_ops.stop(priv);
+
+	pci_save_state(pdev);
+	pci_disable_device(pdev);
+	pci_set_power_state(pdev, PCI_D3hot);
+
+	return 0;
+}
+EXPORT_SYMBOL(iwl_pci_suspend);
+
+int iwl_pci_resume(struct pci_dev *pdev)
+{
+	struct iwl_priv *priv = pci_get_drvdata(pdev);
+	int ret;
+
+	pci_set_power_state(pdev, PCI_D0);
+	ret = pci_enable_device(pdev);
+	if (ret)
+		return ret;
+	pci_restore_state(pdev);
+	iwl_enable_interrupts(priv);
+
+	return 0;
+}
+EXPORT_SYMBOL(iwl_pci_resume);
+
+#endif /* CONFIG_PM */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index a8eac8c..5d49045 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -432,6 +432,10 @@ static inline u16 iwl_pcie_link_ctl(struct iwl_priv *priv)
 	pci_read_config_word(priv->pci_dev, pos + PCI_EXP_LNKCTL, &pci_lnk_ctl);
 	return pci_lnk_ctl;
 }
+#ifdef CONFIG_PM
+int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state);
+int iwl_pci_resume(struct pci_dev *pdev);
+#endif /* CONFIG_PM */
 
 /*****************************************************
 *  Error Handling Debugging
@@ -458,7 +462,6 @@ void iwlcore_free_geos(struct iwl_priv *priv);
 #define STATUS_TEMPERATURE	8
 #define STATUS_GEO_CONFIGURED	9
 #define STATUS_EXIT_PENDING	10
-#define STATUS_IN_SUSPEND	11
 #define STATUS_STATISTICS	12
 #define STATUS_SCANNING		13
 #define STATUS_SCAN_ABORTING	14
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 64eb585..af1d121 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -456,8 +456,6 @@ static ssize_t iwl_dbgfs_status_read(struct file *file,
 		test_bit(STATUS_GEO_CONFIGURED, &priv->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_EXIT_PENDING:\t %d\n",
 		test_bit(STATUS_EXIT_PENDING, &priv->status));
-	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_IN_SUSPEND:\t %d\n",
-		test_bit(STATUS_IN_SUSPEND, &priv->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_STATISTICS:\t %d\n",
 		test_bit(STATUS_STATISTICS, &priv->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_SCANNING:\t %d\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 279d10c..33f5b00 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2996,7 +2996,7 @@ static void __iwl3945_down(struct iwl_priv *priv)
 		ieee80211_stop_queues(priv->hw);
 
 	/* If we have not previously called iwl3945_init() then
-	 * clear all bits but the RF Kill and SUSPEND bits and return */
+	 * clear all bits but the RF Kill bits and return */
 	if (!iwl_is_init(priv)) {
 		priv->status = test_bit(STATUS_RF_KILL_HW, &priv->status) <<
 					STATUS_RF_KILL_HW |
@@ -3004,23 +3004,19 @@ static void __iwl3945_down(struct iwl_priv *priv)
 					STATUS_RF_KILL_SW |
 			       test_bit(STATUS_GEO_CONFIGURED, &priv->status) <<
 					STATUS_GEO_CONFIGURED |
-			       test_bit(STATUS_IN_SUSPEND, &priv->status) <<
-					STATUS_IN_SUSPEND |
 				test_bit(STATUS_EXIT_PENDING, &priv->status) <<
 					STATUS_EXIT_PENDING;
 		goto exit;
 	}
 
-	/* ...otherwise clear out all the status bits but the RF Kill and
-	 * SUSPEND bits and continue taking the NIC down. */
+	/* ...otherwise clear out all the status bits but the RF Kill
+	 * bits and continue taking the NIC down. */
 	priv->status &= test_bit(STATUS_RF_KILL_HW, &priv->status) <<
 				STATUS_RF_KILL_HW |
 			test_bit(STATUS_RF_KILL_SW, &priv->status) <<
 				STATUS_RF_KILL_SW |
 			test_bit(STATUS_GEO_CONFIGURED, &priv->status) <<
 				STATUS_GEO_CONFIGURED |
-			test_bit(STATUS_IN_SUSPEND, &priv->status) <<
-				STATUS_IN_SUSPEND |
 			test_bit(STATUS_FW_ERROR, &priv->status) <<
 				STATUS_FW_ERROR |
 			test_bit(STATUS_EXIT_PENDING, &priv->status) <<
@@ -3044,7 +3040,7 @@ static void __iwl3945_down(struct iwl_priv *priv)
 
 	udelay(5);
 
-	if (exit_pending || test_bit(STATUS_IN_SUSPEND, &priv->status))
+	if (exit_pending)
 		priv->cfg->ops->lib->apm_ops.stop(priv);
 	else
 		priv->cfg->ops->lib->apm_ops.reset(priv);
@@ -3097,10 +3093,8 @@ static int __iwl3945_up(struct iwl_priv *priv)
 		clear_bit(STATUS_RF_KILL_HW, &priv->status);
 	else {
 		set_bit(STATUS_RF_KILL_HW, &priv->status);
-		if (!test_bit(STATUS_IN_SUSPEND, &priv->status)) {
-			IWL_WARN(priv, "Radio disabled by HW RF Kill switch\n");
-			return -ENODEV;
-		}
+		IWL_WARN(priv, "Radio disabled by HW RF Kill switch\n");
+		return -ENODEV;
 	}
 
 	iwl_write32(priv, CSR_INT, 0xFFFFFFFF);
@@ -3592,9 +3586,6 @@ static int iwl3945_mac_start(struct ieee80211_hw *hw)
 
 	IWL_DEBUG_INFO(priv, "Start UP work.\n");
 
-	if (test_bit(STATUS_IN_SUSPEND, &priv->status))
-		return 0;
-
 	/* Wait for START_ALIVE from ucode. Otherwise callbacks from
 	 * mac80211 will not be run successfully. */
 	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
@@ -5231,44 +5222,6 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 	ieee80211_free_hw(priv->hw);
 }
 
-#ifdef CONFIG_PM
-
-static int iwl3945_pci_suspend(struct pci_dev *pdev, pm_message_t state)
-{
-	struct iwl_priv *priv = pci_get_drvdata(pdev);
-
-	if (priv->is_open) {
-		set_bit(STATUS_IN_SUSPEND, &priv->status);
-		iwl3945_mac_stop(priv->hw);
-		priv->is_open = 1;
-	}
-
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, PCI_D3hot);
-
-	return 0;
-}
-
-static int iwl3945_pci_resume(struct pci_dev *pdev)
-{
-	struct iwl_priv *priv = pci_get_drvdata(pdev);
-	int ret;
-
-	pci_set_power_state(pdev, PCI_D0);
-	ret = pci_enable_device(pdev);
-	if (ret)
-		return ret;
-	pci_restore_state(pdev);
-
-	if (priv->is_open)
-		iwl3945_mac_start(priv->hw);
-
-	clear_bit(STATUS_IN_SUSPEND, &priv->status);
-	return 0;
-}
-
-#endif /* CONFIG_PM */
 
 /*****************************************************************************
  *
@@ -5282,8 +5235,8 @@ static struct pci_driver iwl3945_driver = {
 	.probe = iwl3945_pci_probe,
 	.remove = __devexit_p(iwl3945_pci_remove),
 #ifdef CONFIG_PM
-	.suspend = iwl3945_pci_suspend,
-	.resume = iwl3945_pci_resume,
+	.suspend = iwl_pci_suspend,
+	.resume = iwl_pci_resume,
 #endif
 };
 
-- 
1.5.6.3

