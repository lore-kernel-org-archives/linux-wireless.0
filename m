Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2948 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990AbZAUFba (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 00:31:30 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/5] iwl3945: Use iwl-rfkill
Date: Tue, 20 Jan 2009 21:33:54 -0800
Message-Id: <1232516035-25524-5-git-send-email-reinette.chatre@intel.com> (sfid-20090121_063155_627325_06EF2CD8)
In-Reply-To: <1232516035-25524-4-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232516035-25524-1-git-send-email-reinette.chatre@intel.com>
 <1232516035-25524-2-git-send-email-reinette.chatre@intel.com>
 <1232516035-25524-3-git-send-email-reinette.chatre@intel.com>
 <1232516035-25524-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <samuel.ortiz@intel.com>

Here again, the rfkill routines are duplicated between agn and 3945. Let's
move the agn one to iwlcore, and so we can get rid of the 3945 ones.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig        |    6 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |   12 --
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   34 ------
 drivers/net/wireless/iwlwifi/iwl-core.c     |   35 ++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  151 +--------------------------
 6 files changed, 42 insertions(+), 198 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 47bee0e..4b2d57a 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -110,7 +110,7 @@ config IWL3945
 	select IWLWIFI
 	select MAC80211_LEDS if IWL3945_LEDS
 	select LEDS_CLASS if IWL3945_LEDS
-	select RFKILL if IWL3945_RFKILL
+	select RFKILL if IWLWIFI_RFKILL
 	---help---
 	  Select to build the driver supporting the:
 
@@ -133,10 +133,6 @@ config IWL3945
 	  say M here and read <file:Documentation/kbuild/modules.txt>.  The
 	  module will be called iwl3945.ko.
 
-config IWL3945_RFKILL
-	bool "Enable RF kill support in iwl3945 drivers"
-	depends on IWL3945
-
 config IWL3945_SPECTRUM_MEASUREMENT
 	bool "Enable Spectrum Measurement in iwl3945 drivers"
 	depends on IWL3945
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 97dfa7c..156c828 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -301,18 +301,6 @@ extern int iwl3945_txpower_set_from_eeprom(struct iwl_priv *priv);
 extern u8 iwl3945_sync_sta(struct iwl_priv *priv, int sta_id,
 		 u16 tx_rate, u8 flags);
 
-#ifdef CONFIG_IWL3945_RFKILL
-struct iwl_priv;
-
-void iwl3945_rfkill_set_hw_state(struct iwl_priv *priv);
-void iwl3945_rfkill_unregister(struct iwl_priv *priv);
-int iwl3945_rfkill_init(struct iwl_priv *priv);
-#else
-static inline void iwl3945_rfkill_set_hw_state(struct iwl_priv *priv) {}
-static inline void iwl3945_rfkill_unregister(struct iwl_priv *priv) {}
-static inline int iwl3945_rfkill_init(struct iwl_priv *priv) { return 0; }
-#endif
-
 static inline int iwl3945_is_associated(struct iwl_priv *priv)
 {
 	return (priv->active39_rxon.filter_flags & RXON_FILTER_ASSOC_MSK) ? 1 : 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d1994de..c4fadb6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2143,40 +2143,6 @@ static void iwl_bg_alive_start(struct work_struct *data)
 	mutex_unlock(&priv->mutex);
 }
 
-static void iwl_bg_rf_kill(struct work_struct *work)
-{
-	struct iwl_priv *priv = container_of(work, struct iwl_priv, rf_kill);
-
-	wake_up_interruptible(&priv->wait_command_queue);
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
-	mutex_lock(&priv->mutex);
-
-	if (!iwl_is_rfkill(priv)) {
-		IWL_DEBUG(IWL_DL_RF_KILL,
-			  "HW and/or SW RF Kill no longer active, restarting "
-			  "device\n");
-		if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
-			queue_work(priv->workqueue, &priv->restart);
-	} else {
-		/* make sure mac80211 stop sending Tx frame */
-		if (priv->mac80211_registered)
-			ieee80211_stop_queues(priv->hw);
-
-		if (!test_bit(STATUS_RF_KILL_HW, &priv->status))
-			IWL_DEBUG_RF_KILL("Can not turn radio back on - "
-					  "disabled by SW switch\n");
-		else
-			IWL_WARN(priv, "Radio Frequency Kill Switch is On:\n"
-				    "Kill switch must be turned off for "
-				    "wireless networking to work.\n");
-	}
-	mutex_unlock(&priv->mutex);
-	iwl_rfkill_set_hw_state(priv);
-}
-
 static void iwl_bg_run_time_calib_work(struct work_struct *work)
 {
 	struct iwl_priv *priv = container_of(work, struct iwl_priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index d2ef3e1..f64e3a4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1465,3 +1465,38 @@ int iwl_radio_kill_sw_enable_radio(struct iwl_priv *priv)
 	return 1;
 }
 EXPORT_SYMBOL(iwl_radio_kill_sw_enable_radio);
+
+void iwl_bg_rf_kill(struct work_struct *work)
+{
+	struct iwl_priv *priv = container_of(work, struct iwl_priv, rf_kill);
+
+	wake_up_interruptible(&priv->wait_command_queue);
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	mutex_lock(&priv->mutex);
+
+	if (!iwl_is_rfkill(priv)) {
+		IWL_DEBUG(IWL_DL_RF_KILL,
+			  "HW and/or SW RF Kill no longer active, restarting "
+			  "device\n");
+		if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
+			queue_work(priv->workqueue, &priv->restart);
+	} else {
+		/* make sure mac80211 stop sending Tx frame */
+		if (priv->mac80211_registered)
+			ieee80211_stop_queues(priv->hw);
+
+		if (!test_bit(STATUS_RF_KILL_HW, &priv->status))
+			IWL_DEBUG_RF_KILL("Can not turn radio back on - "
+					  "disabled by SW switch\n");
+		else
+			IWL_WARN(priv, "Radio Frequency Kill Switch is On:\n"
+				    "Kill switch must be turned off for "
+				    "wireless networking to work.\n");
+	}
+	mutex_unlock(&priv->mutex);
+	iwl_rfkill_set_hw_state(priv);
+}
+EXPORT_SYMBOL(iwl_bg_rf_kill);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 466130f..5ceeedc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -267,7 +267,7 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force);
  * RF -Kill - here and not in iwl-rfkill.h to be available when
  * RF-kill subsystem is not compiled.
  ****************************************************/
-void iwl_rf_kill(struct iwl_priv *priv);
+void iwl_bg_rf_kill(struct work_struct *work);
 void iwl_radio_kill_sw_disable_radio(struct iwl_priv *priv);
 int iwl_radio_kill_sw_enable_radio(struct iwl_priv *priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index ee7bccf..be02272 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5464,39 +5464,6 @@ static void iwl3945_bg_alive_start(struct work_struct *data)
 	mutex_unlock(&priv->mutex);
 }
 
-static void iwl3945_bg_rf_kill(struct work_struct *work)
-{
-	struct iwl_priv *priv = container_of(work, struct iwl_priv, rf_kill);
-
-	wake_up_interruptible(&priv->wait_command_queue);
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
-	mutex_lock(&priv->mutex);
-
-	if (!iwl_is_rfkill(priv)) {
-		IWL_DEBUG(IWL_DL_INFO | IWL_DL_RF_KILL,
-			  "HW and/or SW RF Kill no longer active, restarting "
-			  "device\n");
-		if (!test_bit(STATUS_EXIT_PENDING, &priv->status) &&
-		     test_bit(STATUS_ALIVE, &priv->status))
-			queue_work(priv->workqueue, &priv->restart);
-	} else {
-
-		if (!test_bit(STATUS_RF_KILL_HW, &priv->status))
-			IWL_DEBUG_RF_KILL("Can not turn radio back on - "
-					  "disabled by SW switch\n");
-		else
-			IWL_WARN(priv, "Radio Frequency Kill Switch is On:\n"
-				    "Kill switch must be turned off for "
-				    "wireless networking to work.\n");
-	}
-
-	mutex_unlock(&priv->mutex);
-	iwl3945_rfkill_set_hw_state(priv);
-}
-
 static void iwl3945_rfkill_poll(struct work_struct *data)
 {
 	struct iwl_priv *priv =
@@ -5745,7 +5712,7 @@ static void iwl3945_bg_up(struct work_struct *data)
 	mutex_lock(&priv->mutex);
 	__iwl3945_up(priv);
 	mutex_unlock(&priv->mutex);
-	iwl3945_rfkill_set_hw_state(priv);
+	iwl_rfkill_set_hw_state(priv);
 }
 
 static void iwl3945_bg_restart(struct work_struct *data)
@@ -5938,7 +5905,7 @@ static int iwl3945_mac_start(struct ieee80211_hw *hw)
 
 	mutex_unlock(&priv->mutex);
 
-	iwl3945_rfkill_set_hw_state(priv);
+	iwl_rfkill_set_hw_state(priv);
 
 	if (ret)
 		goto out_release_irq;
@@ -7208,7 +7175,7 @@ static void iwl3945_setup_deferred_work(struct iwl_priv *priv)
 	INIT_WORK(&priv->scan_completed, iwl3945_bg_scan_completed);
 	INIT_WORK(&priv->request_scan, iwl3945_bg_request_scan);
 	INIT_WORK(&priv->abort_scan, iwl3945_bg_abort_scan);
-	INIT_WORK(&priv->rf_kill, iwl3945_bg_rf_kill);
+	INIT_WORK(&priv->rf_kill, iwl_bg_rf_kill);
 	INIT_WORK(&priv->beacon_update, iwl3945_bg_beacon_update);
 	INIT_DELAYED_WORK(&priv->init_alive_start, iwl3945_bg_init_alive_start);
 	INIT_DELAYED_WORK(&priv->alive_start, iwl3945_bg_alive_start);
@@ -7536,7 +7503,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	priv->hw->conf.beacon_int = 100;
 	priv->mac80211_registered = 1;
 
-	err = iwl3945_rfkill_init(priv);
+	err = iwl_rfkill_init(priv);
 	if (err)
 		IWL_ERR(priv, "Unable to initialize RFKILL system. "
 				  "Ignoring error: %d\n", err);
@@ -7602,7 +7569,7 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 
 	sysfs_remove_group(&pdev->dev.kobj, &iwl3945_attribute_group);
 
-	iwl3945_rfkill_unregister(priv);
+	iwl_rfkill_unregister(priv);
 	cancel_delayed_work(&priv->rfkill_poll);
 
 	iwl3945_dealloc_ucode_pci(priv);
@@ -7675,114 +7642,6 @@ static int iwl3945_pci_resume(struct pci_dev *pdev)
 
 #endif /* CONFIG_PM */
 
-/*************** RFKILL FUNCTIONS **********/
-#ifdef CONFIG_IWL3945_RFKILL
-/* software rf-kill from user */
-static int iwl3945_rfkill_soft_rf_kill(void *data, enum rfkill_state state)
-{
-	struct iwl_priv *priv = data;
-	int err = 0;
-
-	if (!priv->rfkill)
-	return 0;
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return 0;
-
-	IWL_DEBUG_RF_KILL("we received soft RFKILL set to state %d\n", state);
-	mutex_lock(&priv->mutex);
-
-	switch (state) {
-	case RFKILL_STATE_UNBLOCKED:
-		if (iwl_is_rfkill_hw(priv)) {
-			err = -EBUSY;
-			goto out_unlock;
-		}
-		iwl3945_radio_kill_sw(priv, 0);
-		break;
-	case RFKILL_STATE_SOFT_BLOCKED:
-		iwl3945_radio_kill_sw(priv, 1);
-		break;
-	default:
-		IWL_WARN(priv, "received unexpected RFKILL state %d\n", state);
-		break;
-	}
-out_unlock:
-	mutex_unlock(&priv->mutex);
-
-	return err;
-}
-
-int iwl3945_rfkill_init(struct iwl_priv *priv)
-{
-	struct device *device = wiphy_dev(priv->hw->wiphy);
-	int ret = 0;
-
-	BUG_ON(device == NULL);
-
-	IWL_DEBUG_RF_KILL("Initializing RFKILL.\n");
-	priv->rfkill = rfkill_allocate(device, RFKILL_TYPE_WLAN);
-	if (!priv->rfkill) {
-		IWL_ERR(priv, "Unable to allocate rfkill device.\n");
-		ret = -ENOMEM;
-		goto error;
-	}
-
-	priv->rfkill->name = priv->cfg->name;
-	priv->rfkill->data = priv;
-	priv->rfkill->state = RFKILL_STATE_UNBLOCKED;
-	priv->rfkill->toggle_radio = iwl3945_rfkill_soft_rf_kill;
-	priv->rfkill->user_claim_unsupported = 1;
-
-	priv->rfkill->dev.class->suspend = NULL;
-	priv->rfkill->dev.class->resume = NULL;
-
-	ret = rfkill_register(priv->rfkill);
-	if (ret) {
-		IWL_ERR(priv, "Unable to register rfkill: %d\n", ret);
-		goto freed_rfkill;
-	}
-
-	IWL_DEBUG_RF_KILL("RFKILL initialization complete.\n");
-	return ret;
-
-freed_rfkill:
-	if (priv->rfkill != NULL)
-		rfkill_free(priv->rfkill);
-	priv->rfkill = NULL;
-
-error:
-	IWL_DEBUG_RF_KILL("RFKILL initialization complete.\n");
-	return ret;
-}
-
-void iwl3945_rfkill_unregister(struct iwl_priv *priv)
-{
-	if (priv->rfkill)
-		rfkill_unregister(priv->rfkill);
-
-	priv->rfkill = NULL;
-}
-
-/* set rf-kill to the right state. */
-void iwl3945_rfkill_set_hw_state(struct iwl_priv *priv)
-{
-
-	if (!priv->rfkill)
-		return;
-
-	if (iwl_is_rfkill_hw(priv)) {
-		rfkill_force_state(priv->rfkill, RFKILL_STATE_HARD_BLOCKED);
-		return;
-	}
-
-	if (!iwl_is_rfkill_sw(priv))
-		rfkill_force_state(priv->rfkill, RFKILL_STATE_UNBLOCKED);
-	else
-		rfkill_force_state(priv->rfkill, RFKILL_STATE_SOFT_BLOCKED);
-}
-#endif
-
 /*****************************************************************************
  *
  * driver and module entry point
-- 
1.5.4.3

