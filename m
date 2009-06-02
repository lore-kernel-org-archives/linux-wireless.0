Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40247 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759670AbZFBLNS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 07:13:18 -0400
Message-Id: <20090602111111.956543636@sipsolutions.net>
References: <20090602111027.460530075@sipsolutions.net>
Date: Tue, 02 Jun 2009 13:10:28 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Reinette Chatre <reinette.chatre@intel.com>
Subject: [RFT 1/3] iwlwifi: port to cfg80211 rfkill
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This ports the iwlwifi rfkill code to the new API offered by
cfg80211 and thus removes a lot of useless stuff. The soft-
rfkill is completely removed since that is now handled by
setting the interfaces down.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig        |    4 
 drivers/net/wireless/iwlwifi/Makefile       |    1 
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    5 -
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   42 ++------
 drivers/net/wireless/iwlwifi/iwl-core.c     |  138 ----------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |   16 ---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    2 
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    5 -
 drivers/net/wireless/iwlwifi/iwl-rfkill.c   |  131 --------------------------
 drivers/net/wireless/iwlwifi/iwl-rfkill.h   |   48 ---------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   41 +-------
 11 files changed, 19 insertions(+), 414 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/iwlwifi/Kconfig	2009-06-02 12:53:44.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/Kconfig	2009-06-02 12:56:07.000000000 +0200
@@ -10,10 +10,6 @@ config IWLWIFI_LEDS
 	bool "Enable LED support in iwlagn and iwl3945 drivers"
 	depends on IWLWIFI
 
-config IWLWIFI_RFKILL
-	def_bool y
-	depends on IWLWIFI && RFKILL
-
 config IWLWIFI_SPECTRUM_MEASUREMENT
 	bool "Enable Spectrum Measurement in iwlagn driver"
 	depends on IWLWIFI
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-3945.h	2009-06-02 12:53:58.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-3945.h	2009-06-02 12:56:07.000000000 +0200
@@ -36,10 +36,6 @@
 #include <linux/kernel.h>
 #include <net/ieee80211_radiotap.h>
 
-/*used for rfkill*/
-#include <linux/rfkill.h>
-#include <linux/input.h>
-
 /* Hardware specific file defines the PCI IDs table for that hardware module */
 extern struct pci_device_id iwl3945_hw_card_ids[];
 
@@ -155,7 +151,6 @@ struct iwl3945_frame {
 #define STATUS_HCMD_SYNC_ACTIVE	1	/* sync host command in progress */
 #define STATUS_INT_ENABLED	2
 #define STATUS_RF_KILL_HW	3
-#define STATUS_RF_KILL_SW	4
 #define STATUS_INIT		5
 #define STATUS_ALIVE		6
 #define STATUS_READY		7
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2009-06-02 12:53:58.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn.c	2009-06-02 12:56:07.000000000 +0200
@@ -737,19 +737,13 @@ static void iwl_rx_card_state_notif(stru
 		clear_bit(STATUS_RF_KILL_HW, &priv->status);
 
 
-	if (flags & SW_CARD_DISABLED)
-		set_bit(STATUS_RF_KILL_SW, &priv->status);
-	else
-		clear_bit(STATUS_RF_KILL_SW, &priv->status);
-
 	if (!(flags & RXON_CARD_DISABLED))
 		iwl_scan_cancel(priv);
 
 	if ((test_bit(STATUS_RF_KILL_HW, &status) !=
-	     test_bit(STATUS_RF_KILL_HW, &priv->status)) ||
-	    (test_bit(STATUS_RF_KILL_SW, &status) !=
-	     test_bit(STATUS_RF_KILL_SW, &priv->status)))
-		queue_work(priv->workqueue, &priv->rf_kill);
+	     test_bit(STATUS_RF_KILL_HW, &priv->status)))
+		wiphy_rfkill_set_hw_state(priv->hw->wiphy,
+			test_bit(STATUS_RF_KILL_HW, &priv->status));
 	else
 		wake_up_interruptible(&priv->wait_command_queue);
 }
@@ -1045,7 +1039,7 @@ static void iwl_irq_tasklet_legacy(struc
 				set_bit(STATUS_RF_KILL_HW, &priv->status);
 			else
 				clear_bit(STATUS_RF_KILL_HW, &priv->status);
-			queue_work(priv->workqueue, &priv->rf_kill);
+			wiphy_rfkill_set_hw_state(priv->hw->wiphy, hw_rf_kill);
 		}
 
 		handled |= CSR_INT_BIT_RF_KILL;
@@ -1218,7 +1212,7 @@ static void iwl_irq_tasklet(struct iwl_p
 				set_bit(STATUS_RF_KILL_HW, &priv->status);
 			else
 				clear_bit(STATUS_RF_KILL_HW, &priv->status);
-			queue_work(priv->workqueue, &priv->rf_kill);
+			wiphy_rfkill_set_hw_state(priv->hw->wiphy, hw_rf_kill);
 		}
 
 		handled |= CSR_INT_BIT_RF_KILL;
@@ -1726,12 +1720,10 @@ static void __iwl_down(struct iwl_priv *
 		ieee80211_stop_queues(priv->hw);
 
 	/* If we have not previously called iwl_init() then
-	 * clear all bits but the RF Kill bits and return */
+	 * clear all bits but the RF Kill bit and return */
 	if (!iwl_is_init(priv)) {
 		priv->status = test_bit(STATUS_RF_KILL_HW, &priv->status) <<
 					STATUS_RF_KILL_HW |
-			       test_bit(STATUS_RF_KILL_SW, &priv->status) <<
-					STATUS_RF_KILL_SW |
 			       test_bit(STATUS_GEO_CONFIGURED, &priv->status) <<
 					STATUS_GEO_CONFIGURED |
 			       test_bit(STATUS_EXIT_PENDING, &priv->status) <<
@@ -1740,11 +1732,9 @@ static void __iwl_down(struct iwl_priv *
 	}
 
 	/* ...otherwise clear out all the status bits but the RF Kill
-	 * bits and continue taking the NIC down. */
+	 * bit and continue taking the NIC down. */
 	priv->status &= test_bit(STATUS_RF_KILL_HW, &priv->status) <<
 				STATUS_RF_KILL_HW |
-			test_bit(STATUS_RF_KILL_SW, &priv->status) <<
-				STATUS_RF_KILL_SW |
 			test_bit(STATUS_GEO_CONFIGURED, &priv->status) <<
 				STATUS_GEO_CONFIGURED |
 			test_bit(STATUS_FW_ERROR, &priv->status) <<
@@ -1866,9 +1856,10 @@ static int __iwl_up(struct iwl_priv *pri
 		set_bit(STATUS_RF_KILL_HW, &priv->status);
 
 	if (iwl_is_rfkill(priv)) {
+		wiphy_rfkill_set_hw_state(priv->hw->wiphy, true);
+
 		iwl_enable_interrupts(priv);
-		IWL_WARN(priv, "Radio disabled by %s RF Kill switch\n",
-		    test_bit(STATUS_RF_KILL_HW, &priv->status) ? "HW" : "SW");
+		IWL_WARN(priv, "Radio disabled by HW RF Kill switch\n");
 		return 0;
 	}
 
@@ -2000,7 +1991,6 @@ static void iwl_bg_up(struct work_struct
 	mutex_lock(&priv->mutex);
 	__iwl_up(priv);
 	mutex_unlock(&priv->mutex);
-	iwl_rfkill_set_hw_state(priv);
 }
 
 static void iwl_bg_restart(struct work_struct *data)
@@ -2178,8 +2168,6 @@ static int iwl_mac_start(struct ieee8021
 
 	mutex_unlock(&priv->mutex);
 
-	iwl_rfkill_set_hw_state(priv);
-
 	if (ret)
 		return ret;
 
@@ -2774,7 +2762,6 @@ static void iwl_setup_deferred_work(stru
 	INIT_WORK(&priv->up, iwl_bg_up);
 	INIT_WORK(&priv->restart, iwl_bg_restart);
 	INIT_WORK(&priv->rx_replenish, iwl_bg_rx_replenish);
-	INIT_WORK(&priv->rf_kill, iwl_bg_rf_kill);
 	INIT_WORK(&priv->beacon_update, iwl_bg_beacon_update);
 	INIT_WORK(&priv->run_time_calib_work, iwl_bg_run_time_calib_work);
 	INIT_DELAYED_WORK(&priv->init_alive_start, iwl_bg_init_alive_start);
@@ -3045,12 +3032,8 @@ static int iwl_pci_probe(struct pci_dev 
 	else
 		set_bit(STATUS_RF_KILL_HW, &priv->status);
 
-	err = iwl_rfkill_init(priv);
-	if (err)
-		IWL_ERR(priv, "Unable to initialize RFKILL system. "
-				  "Ignoring error: %d\n", err);
-	else
-		iwl_rfkill_set_hw_state(priv);
+	wiphy_rfkill_set_hw_state(priv->hw->wiphy,
+		test_bit(STATUS_RF_KILL_HW, &priv->status));
 
 	iwl_power_initialize(priv);
 	return 0;
@@ -3114,7 +3097,6 @@ static void __devexit iwl_pci_remove(str
 
 	iwl_synchronize_irq(priv);
 
-	iwl_rfkill_unregister(priv);
 	iwl_dealloc_ucode_pci(priv);
 
 	if (priv->rxq.bd)
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-core.c	2009-06-02 12:53:59.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-core.c	2009-06-02 12:56:07.000000000 +0200
@@ -36,7 +36,6 @@
 #include "iwl-debug.h"
 #include "iwl-core.h"
 #include "iwl-io.h"
-#include "iwl-rfkill.h"
 #include "iwl-power.h"
 #include "iwl-sta.h"
 #include "iwl-helpers.h"
@@ -2211,126 +2210,6 @@ int iwl_send_card_state(struct iwl_priv 
 }
 EXPORT_SYMBOL(iwl_send_card_state);
 
-void iwl_radio_kill_sw_disable_radio(struct iwl_priv *priv)
-{
-	unsigned long flags;
-
-	if (test_bit(STATUS_RF_KILL_SW, &priv->status))
-		return;
-
-	IWL_DEBUG_RF_KILL(priv, "Manual SW RF KILL set to: RADIO OFF\n");
-
-	iwl_scan_cancel(priv);
-	/* FIXME: This is a workaround for AP */
-	if (priv->iw_mode != NL80211_IFTYPE_AP) {
-		spin_lock_irqsave(&priv->lock, flags);
-		iwl_write32(priv, CSR_UCODE_DRV_GP1_SET,
-			    CSR_UCODE_SW_BIT_RFKILL);
-		spin_unlock_irqrestore(&priv->lock, flags);
-		/* call the host command only if no hw rf-kill set */
-		if (!test_bit(STATUS_RF_KILL_HW, &priv->status) &&
-		    iwl_is_ready(priv))
-			iwl_send_card_state(priv,
-				CARD_STATE_CMD_DISABLE, 0);
-		set_bit(STATUS_RF_KILL_SW, &priv->status);
-			/* make sure mac80211 stop sending Tx frame */
-		if (priv->mac80211_registered)
-			ieee80211_stop_queues(priv->hw);
-	}
-}
-EXPORT_SYMBOL(iwl_radio_kill_sw_disable_radio);
-
-int iwl_radio_kill_sw_enable_radio(struct iwl_priv *priv)
-{
-	unsigned long flags;
-
-	if (!test_bit(STATUS_RF_KILL_SW, &priv->status))
-		return 0;
-
-	IWL_DEBUG_RF_KILL(priv, "Manual SW RF KILL set to: RADIO ON\n");
-
-	spin_lock_irqsave(&priv->lock, flags);
-	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
-
-	/* If the driver is up it will receive CARD_STATE_NOTIFICATION
-	 * notification where it will clear SW rfkill status.
-	 * Setting it here would break the handler. Only if the
-	 * interface is down we can set here since we don't
-	 * receive any further notification.
-	 */
-	if (!priv->is_open)
-		clear_bit(STATUS_RF_KILL_SW, &priv->status);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	/* wake up ucode */
-	msleep(10);
-
-	iwl_read32(priv, CSR_UCODE_DRV_GP1);
-	spin_lock_irqsave(&priv->reg_lock, flags);
-	if (!iwl_grab_nic_access(priv))
-		iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->reg_lock, flags);
-
-	if (test_bit(STATUS_RF_KILL_HW, &priv->status)) {
-		IWL_DEBUG_RF_KILL(priv, "Can not turn radio back on - "
-				  "disabled by HW switch\n");
-		return 0;
-	}
-
-	/* when driver is up while rfkill is on, it wont receive
-	 * any CARD_STATE_NOTIFICATION notifications so we have to
-	 * restart it in here
-	 */
-	if (priv->is_open && !test_bit(STATUS_ALIVE, &priv->status)) {
-		clear_bit(STATUS_RF_KILL_SW, &priv->status);
-		if (!iwl_is_rfkill(priv))
-			queue_work(priv->workqueue, &priv->up);
-	}
-
-	/* If the driver is already loaded, it will receive
-	 * CARD_STATE_NOTIFICATION notifications and the handler will
-	 * call restart to reload the driver.
-	 */
-	return 1;
-}
-EXPORT_SYMBOL(iwl_radio_kill_sw_enable_radio);
-
-void iwl_bg_rf_kill(struct work_struct *work)
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
-		IWL_DEBUG_RF_KILL(priv,
-			  "HW and/or SW RF Kill no longer active, restarting "
-			  "device\n");
-		if (!test_bit(STATUS_EXIT_PENDING, &priv->status) &&
-		    priv->is_open)
-			queue_work(priv->workqueue, &priv->restart);
-	} else {
-		/* make sure mac80211 stop sending Tx frame */
-		if (priv->mac80211_registered)
-			ieee80211_stop_queues(priv->hw);
-
-		if (!test_bit(STATUS_RF_KILL_HW, &priv->status))
-			IWL_DEBUG_RF_KILL(priv, "Can not turn radio back on - "
-					  "disabled by SW switch\n");
-		else
-			IWL_WARN(priv, "Radio Frequency Kill Switch is On:\n"
-				    "Kill switch must be turned off for "
-				    "wireless networking to work.\n");
-	}
-	mutex_unlock(&priv->mutex);
-	iwl_rfkill_set_hw_state(priv);
-}
-EXPORT_SYMBOL(iwl_bg_rf_kill);
-
 void iwl_rx_pm_sleep_notif(struct iwl_priv *priv,
 			   struct iwl_rx_mem_buffer *rxb)
 {
@@ -2849,23 +2728,6 @@ int iwl_mac_config(struct ieee80211_hw *
 	if (priv->cfg->ops->hcmd->set_rxon_chain)
 		priv->cfg->ops->hcmd->set_rxon_chain(priv);
 
-	if (changed & IEEE80211_CONF_CHANGE_RADIO_ENABLED) {
-		if (conf->radio_enabled &&
-			iwl_radio_kill_sw_enable_radio(priv)) {
-			IWL_DEBUG_MAC80211(priv, "leave - RF-KILL - "
-						"waiting for uCode\n");
-			goto out;
-		}
-
-		if (!conf->radio_enabled)
-			iwl_radio_kill_sw_disable_radio(priv);
-	}
-
-	if (!conf->radio_enabled) {
-		IWL_DEBUG_MAC80211(priv, "leave - radio disabled\n");
-		goto out;
-	}
-
 	if (!iwl_is_ready(priv)) {
 		IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
 		goto out;
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-core.h	2009-06-02 12:53:58.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-core.h	2009-06-02 12:56:07.000000000 +0200
@@ -358,14 +358,6 @@ int iwl_txq_check_empty(struct iwl_priv 
  ****************************************************/
 int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force);
 
-/*****************************************************
- * RF -Kill - here and not in iwl-rfkill.h to be available when
- * RF-kill subsystem is not compiled.
- ****************************************************/
-void iwl_bg_rf_kill(struct work_struct *work);
-void iwl_radio_kill_sw_disable_radio(struct iwl_priv *priv);
-int iwl_radio_kill_sw_enable_radio(struct iwl_priv *priv);
-
 /*******************************************************************************
  * Rate
  ******************************************************************************/
@@ -508,7 +500,6 @@ void iwlcore_free_geos(struct iwl_priv *
 #define STATUS_HCMD_SYNC_ACTIVE	1	/* sync host command in progress */
 #define STATUS_INT_ENABLED	2
 #define STATUS_RF_KILL_HW	3
-#define STATUS_RF_KILL_SW	4
 #define STATUS_INIT		5
 #define STATUS_ALIVE		6
 #define STATUS_READY		7
@@ -543,11 +534,6 @@ static inline int iwl_is_init(struct iwl
 	return test_bit(STATUS_INIT, &priv->status);
 }
 
-static inline int iwl_is_rfkill_sw(struct iwl_priv *priv)
-{
-	return test_bit(STATUS_RF_KILL_SW, &priv->status);
-}
-
 static inline int iwl_is_rfkill_hw(struct iwl_priv *priv)
 {
 	return test_bit(STATUS_RF_KILL_HW, &priv->status);
@@ -555,7 +541,7 @@ static inline int iwl_is_rfkill_hw(struc
 
 static inline int iwl_is_rfkill(struct iwl_priv *priv)
 {
-	return iwl_is_rfkill_hw(priv) || iwl_is_rfkill_sw(priv);
+	return iwl_is_rfkill_hw(priv);
 }
 
 static inline int iwl_is_ready_rf(struct iwl_priv *priv)
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-debugfs.c	2009-06-02 12:53:45.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-debugfs.c	2009-06-02 12:56:07.000000000 +0200
@@ -449,8 +449,6 @@ static ssize_t iwl_dbgfs_status_read(str
 		test_bit(STATUS_INT_ENABLED, &priv->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_RF_KILL_HW:\t %d\n",
 		test_bit(STATUS_RF_KILL_HW, &priv->status));
-	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_RF_KILL_SW:\t %d\n",
-		test_bit(STATUS_RF_KILL_SW, &priv->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_INIT:\t\t %d\n",
 		test_bit(STATUS_INIT, &priv->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_ALIVE:\t\t %d\n",
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-dev.h	2009-06-02 12:53:58.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-dev.h	2009-06-02 12:56:07.000000000 +0200
@@ -41,7 +41,6 @@
 #include "iwl-prph.h"
 #include "iwl-fh.h"
 #include "iwl-debug.h"
-#include "iwl-rfkill.h"
 #include "iwl-4965-hw.h"
 #include "iwl-3945-hw.h"
 #include "iwl-3945-led.h"
@@ -937,9 +936,6 @@ struct iwl_priv {
 	 * 4965's initialize alive response contains some calibration data. */
 	struct iwl_init_alive_resp card_alive_init;
 	struct iwl_alive_resp card_alive;
-#if defined(CONFIG_IWLWIFI_RFKILL)
-	struct rfkill *rfkill;
-#endif
 
 #ifdef CONFIG_IWLWIFI_LEDS
 	unsigned long last_blink_time;
@@ -1073,7 +1069,6 @@ struct iwl_priv {
 	struct work_struct calibrated_work;
 	struct work_struct scan_completed;
 	struct work_struct rx_replenish;
-	struct work_struct rf_kill;
 	struct work_struct abort_scan;
 	struct work_struct update_link_led;
 	struct work_struct auth_work;
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2009-06-02 12:53:58.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl3945-base.c	2009-06-02 12:56:07.000000000 +0200
@@ -1149,18 +1149,12 @@ static void iwl3945_rx_card_state_notif(
 		clear_bit(STATUS_RF_KILL_HW, &priv->status);
 
 
-	if (flags & SW_CARD_DISABLED)
-		set_bit(STATUS_RF_KILL_SW, &priv->status);
-	else
-		clear_bit(STATUS_RF_KILL_SW, &priv->status);
-
 	iwl_scan_cancel(priv);
 
 	if ((test_bit(STATUS_RF_KILL_HW, &status) !=
-	     test_bit(STATUS_RF_KILL_HW, &priv->status)) ||
-	    (test_bit(STATUS_RF_KILL_SW, &status) !=
-	     test_bit(STATUS_RF_KILL_SW, &priv->status)))
-		queue_work(priv->workqueue, &priv->rf_kill);
+	     test_bit(STATUS_RF_KILL_HW, &priv->status)))
+		wiphy_rfkill_set_hw_state(priv->hw->wiphy,
+				test_bit(STATUS_RF_KILL_HW, &priv->status));
 	else
 		wake_up_interruptible(&priv->wait_command_queue);
 }
@@ -2708,8 +2702,6 @@ static void __iwl3945_down(struct iwl_pr
 	if (!iwl_is_init(priv)) {
 		priv->status = test_bit(STATUS_RF_KILL_HW, &priv->status) <<
 					STATUS_RF_KILL_HW |
-			       test_bit(STATUS_RF_KILL_SW, &priv->status) <<
-					STATUS_RF_KILL_SW |
 			       test_bit(STATUS_GEO_CONFIGURED, &priv->status) <<
 					STATUS_GEO_CONFIGURED |
 				test_bit(STATUS_EXIT_PENDING, &priv->status) <<
@@ -2718,11 +2710,9 @@ static void __iwl3945_down(struct iwl_pr
 	}
 
 	/* ...otherwise clear out all the status bits but the RF Kill
-	 * bits and continue taking the NIC down. */
+	 * bit and continue taking the NIC down. */
 	priv->status &= test_bit(STATUS_RF_KILL_HW, &priv->status) <<
 				STATUS_RF_KILL_HW |
-			test_bit(STATUS_RF_KILL_SW, &priv->status) <<
-				STATUS_RF_KILL_SW |
 			test_bit(STATUS_GEO_CONFIGURED, &priv->status) <<
 				STATUS_GEO_CONFIGURED |
 			test_bit(STATUS_FW_ERROR, &priv->status) <<
@@ -2779,12 +2769,6 @@ static int __iwl3945_up(struct iwl_priv 
 		return -EIO;
 	}
 
-	if (test_bit(STATUS_RF_KILL_SW, &priv->status)) {
-		IWL_WARN(priv, "Radio disabled by SW RF kill (module "
-			    "parameter)\n");
-		return -ENODEV;
-	}
-
 	if (!priv->ucode_data_backup.v_addr || !priv->ucode_data.v_addr) {
 		IWL_ERR(priv, "ucode not available for device bring up\n");
 		return -EIO;
@@ -2901,15 +2885,14 @@ static void iwl3945_rfkill_poll(struct w
 {
 	struct iwl_priv *priv =
 	    container_of(data, struct iwl_priv, rfkill_poll.work);
-	unsigned long status = priv->status;
 
 	if (iwl_read32(priv, CSR_GP_CNTRL) & CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
 		clear_bit(STATUS_RF_KILL_HW, &priv->status);
 	else
 		set_bit(STATUS_RF_KILL_HW, &priv->status);
 
-	if (test_bit(STATUS_RF_KILL_HW, &status) != test_bit(STATUS_RF_KILL_HW, &priv->status))
-		queue_work(priv->workqueue, &priv->rf_kill);
+	wiphy_rfkill_set_hw_state(priv->hw->wiphy,
+			test_bit(STATUS_RF_KILL_HW, &priv->status));
 
 	queue_delayed_work(priv->workqueue, &priv->rfkill_poll,
 			   round_jiffies_relative(2 * HZ));
@@ -3141,7 +3124,6 @@ static void iwl3945_bg_up(struct work_st
 	mutex_lock(&priv->mutex);
 	__iwl3945_up(priv);
 	mutex_unlock(&priv->mutex);
-	iwl_rfkill_set_hw_state(priv);
 }
 
 static void iwl3945_bg_restart(struct work_struct *data)
@@ -3304,8 +3286,6 @@ static int iwl3945_mac_start(struct ieee
 
 	mutex_unlock(&priv->mutex);
 
-	iwl_rfkill_set_hw_state(priv);
-
 	if (ret)
 		goto out_release_irq;
 
@@ -3958,7 +3938,6 @@ static void iwl3945_setup_deferred_work(
 	INIT_WORK(&priv->up, iwl3945_bg_up);
 	INIT_WORK(&priv->restart, iwl3945_bg_restart);
 	INIT_WORK(&priv->rx_replenish, iwl3945_bg_rx_replenish);
-	INIT_WORK(&priv->rf_kill, iwl_bg_rf_kill);
 	INIT_WORK(&priv->beacon_update, iwl3945_bg_beacon_update);
 	INIT_DELAYED_WORK(&priv->init_alive_start, iwl3945_bg_init_alive_start);
 	INIT_DELAYED_WORK(&priv->alive_start, iwl3945_bg_alive_start);
@@ -4325,13 +4304,6 @@ static int iwl3945_pci_probe(struct pci_
 	if (err)
 		IWL_ERR(priv, "failed to create debugfs files. Ignoring error: %d\n", err);
 
-	err = iwl_rfkill_init(priv);
-	if (err)
-		IWL_ERR(priv, "Unable to initialize RFKILL system. "
-				  "Ignoring error: %d\n", err);
-	else
-		iwl_rfkill_set_hw_state(priv);
-
 	/* Start monitoring the killswitch */
 	queue_delayed_work(priv->workqueue, &priv->rfkill_poll,
 			   2 * HZ);
@@ -4397,7 +4369,6 @@ static void __devexit iwl3945_pci_remove
 
 	sysfs_remove_group(&pdev->dev.kobj, &iwl3945_attribute_group);
 
-	iwl_rfkill_unregister(priv);
 	cancel_delayed_work_sync(&priv->rfkill_poll);
 
 	iwl3945_dealloc_ucode_pci(priv);
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-rfkill.c	2009-06-02 12:53:44.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,131 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2003 - 2009 Intel Corporation. All rights reserved.
- *
- * Portions of this file are derived from the ipw3945 project, as well
- * as portions of the ieee80211 subsystem header files.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- * The full GNU General Public License is included in this distribution in the
- * file called LICENSE.
- *
- * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *****************************************************************************/
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-
-#include <net/mac80211.h>
-
-#include "iwl-eeprom.h"
-#include "iwl-dev.h"
-#include "iwl-core.h"
-
-/* software rf-kill from user */
-static int iwl_rfkill_soft_rf_kill(void *data, bool blocked)
-{
-	struct iwl_priv *priv = data;
-
-	if (!priv->rfkill)
-		return -EINVAL;
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return 0;
-
-	IWL_DEBUG_RF_KILL(priv, "received soft RFKILL: block=%d\n", blocked);
-
-	mutex_lock(&priv->mutex);
-
-	if (iwl_is_rfkill_hw(priv))
-		goto out_unlock;
-
-	if (!blocked)
-		iwl_radio_kill_sw_enable_radio(priv);
-	else
-		iwl_radio_kill_sw_disable_radio(priv);
-
-out_unlock:
-	mutex_unlock(&priv->mutex);
-	return 0;
-}
-
-static const struct rfkill_ops iwl_rfkill_ops = {
-	.set_block = iwl_rfkill_soft_rf_kill,
-};
-
-int iwl_rfkill_init(struct iwl_priv *priv)
-{
-	struct device *device = wiphy_dev(priv->hw->wiphy);
-	int ret = 0;
-
-	BUG_ON(device == NULL);
-
-	IWL_DEBUG_RF_KILL(priv, "Initializing RFKILL.\n");
-	priv->rfkill = rfkill_alloc(priv->cfg->name,
-				    device,
-				    RFKILL_TYPE_WLAN,
-				    &iwl_rfkill_ops, priv);
-	if (!priv->rfkill) {
-		IWL_ERR(priv, "Unable to allocate RFKILL device.\n");
-		ret = -ENOMEM;
-		goto error;
-	}
-
-	ret = rfkill_register(priv->rfkill);
-	if (ret) {
-		IWL_ERR(priv, "Unable to register RFKILL: %d\n", ret);
-		goto free_rfkill;
-	}
-
-	IWL_DEBUG_RF_KILL(priv, "RFKILL initialization complete.\n");
-	return 0;
-
-free_rfkill:
-	rfkill_destroy(priv->rfkill);
-	priv->rfkill = NULL;
-
-error:
-	IWL_DEBUG_RF_KILL(priv, "RFKILL initialization complete.\n");
-	return ret;
-}
-EXPORT_SYMBOL(iwl_rfkill_init);
-
-void iwl_rfkill_unregister(struct iwl_priv *priv)
-{
-
-	if (priv->rfkill) {
-		rfkill_unregister(priv->rfkill);
-		rfkill_destroy(priv->rfkill);
-	}
-
-	priv->rfkill = NULL;
-}
-EXPORT_SYMBOL(iwl_rfkill_unregister);
-
-/* set RFKILL to the right state. */
-void iwl_rfkill_set_hw_state(struct iwl_priv *priv)
-{
-	if (!priv->rfkill)
-		return;
-
-	if (rfkill_set_hw_state(priv->rfkill,
-				!!iwl_is_rfkill_hw(priv)))
-		iwl_radio_kill_sw_disable_radio(priv);
-	else
-		iwl_radio_kill_sw_enable_radio(priv);
-}
-EXPORT_SYMBOL(iwl_rfkill_set_hw_state);
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-rfkill.h	2009-06-02 12:53:45.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,48 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2007 - 2009 Intel Corporation. All rights reserved.
- *
- * Portions of this file are derived from the ipw3945 project, as well
- * as portions of the ieee80211 subsystem header files.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- * The full GNU General Public License is included in this distribution in the
- * file called LICENSE.
- *
- * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *****************************************************************************/
-#ifndef __iwl_rf_kill_h__
-#define __iwl_rf_kill_h__
-
-struct iwl_priv;
-
-#include <linux/rfkill.h>
-
-#ifdef CONFIG_IWLWIFI_RFKILL
-
-void iwl_rfkill_set_hw_state(struct iwl_priv *priv);
-void iwl_rfkill_unregister(struct iwl_priv *priv);
-int iwl_rfkill_init(struct iwl_priv *priv);
-#else
-static inline void iwl_rfkill_set_hw_state(struct iwl_priv *priv) {}
-static inline void iwl_rfkill_unregister(struct iwl_priv *priv) {}
-static inline int iwl_rfkill_init(struct iwl_priv *priv) { return 0; }
-#endif
-
-
-
-#endif  /* __iwl_rf_kill_h__ */
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/Makefile	2009-06-02 12:53:44.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/Makefile	2009-06-02 12:56:07.000000000 +0200
@@ -4,7 +4,6 @@ iwlcore-objs 		+= iwl-rx.o iwl-tx.o iwl-
 iwlcore-objs 		+= iwl-scan.o
 iwlcore-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
 iwlcore-$(CONFIG_IWLWIFI_LEDS) += iwl-led.o
-iwlcore-$(CONFIG_IWLWIFI_RFKILL) += iwl-rfkill.o
 iwlcore-$(CONFIG_IWLWIFI_SPECTRUM_MEASUREMENT) += iwl-spectrum.o
 
 obj-$(CONFIG_IWLAGN)	+= iwlagn.o

-- 

