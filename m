Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23612 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbZGXSNP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 14:13:15 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/14] iwlwifi: Thermal Throttling Management - Part 1
Date: Fri, 24 Jul 2009 11:13:02 -0700
Message-Id: <1248459194-10239-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1248459194-10239-1-git-send-email-reinette.chatre@intel.com>
References: <1248459194-10239-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Part 1 of Thermal Throttling Management -

Thermal Throttling feature is used to put NIC into low power state when
driver detect the Radio temperature reach pre-defined threshold

Two Thermal Throttling Management Methods; this patch introduce the
Legacy Thermal Management:
   IWL_TI_0: normal temperature, system power state
   IWL_TI_1: high temperature detect, low power state
   IWL_TI_2: higher temperature detected, lower power state
   IWL_TI_CT_KILL: critical temperature detected, lowest power state

Once get into CT_KILL state, uCode go into sleep, driver will stop all
the active queues, then move to IWL_TI_CT_KILL state; also set up 5
seconds timer to toggle CSR flag, uCode wake up upon CSR flag change,
then measure the temperature.
If temperature is above CT_KILL exit threshold, uCode go backto sleep;
if temperature is below CT_KILL exit threshold, uCode send Card State
Notification response with appropriate CT_KILL status flag, and uCode
remain awake, Driver receive Card State Notification Response and update
the card temperature to the CT_KILL exit threshold.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c  |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c  |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.c   |   19 +--
 drivers/net/wireless/iwlwifi/iwl-core.c  |    1 +
 drivers/net/wireless/iwlwifi/iwl-power.c |  249 ++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-power.h |   42 +++++
 6 files changed, 301 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 23925bd..6702148 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1797,6 +1797,7 @@ static void iwl4965_temperature_calib(struct iwl_priv *priv)
 	}
 
 	priv->temperature = temp;
+	iwl_tt_handler(priv);
 	set_bit(STATUS_TEMPERATURE, &priv->status);
 
 	if (!priv->disable_tx_power_cal &&
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 076acb1..ddd64fe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1405,6 +1405,7 @@ void iwl5000_temperature(struct iwl_priv *priv)
 {
 	/* store temperature from statistics (in Celsius) */
 	priv->temperature = le32_to_cpu(priv->statistics.general.temperature);
+	iwl_tt_handler(priv);
 }
 
 static void iwl5150_temperature(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 44c7f23..23ae991 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -637,7 +637,6 @@ static void iwl_rx_card_state_notif(struct iwl_priv *priv,
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	u32 flags = le32_to_cpu(pkt->u.card_state_notif.flags);
 	unsigned long status = priv->status;
-	unsigned long reg_flags;
 
 	IWL_DEBUG_RF_KILL(priv, "Card state received: HW:%s SW:%s\n",
 			  (flags & HW_CARD_DISABLED) ? "Kill" : "On",
@@ -657,19 +656,12 @@ static void iwl_rx_card_state_notif(struct iwl_priv *priv,
 				    CSR_UCODE_DRV_GP1_BIT_CMD_BLOCKED);
 			iwl_write_direct32(priv, HBUS_TARG_MBX_C,
 					HBUS_TARG_MBX_C_REG_BIT_CMD_BLOCKED);
-
-		}
-
-		if (flags & RF_CARD_DISABLED) {
-			iwl_write32(priv, CSR_UCODE_DRV_GP1_SET,
-				    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
-			iwl_read32(priv, CSR_UCODE_DRV_GP1);
-			spin_lock_irqsave(&priv->reg_lock, reg_flags);
-			if (!iwl_grab_nic_access(priv))
-				iwl_release_nic_access(priv);
-			spin_unlock_irqrestore(&priv->reg_lock, reg_flags);
 		}
+		if (flags & RF_CARD_DISABLED)
+			iwl_tt_enter_ct_kill(priv);
 	}
+	if (!(flags & RF_CARD_DISABLED))
+		iwl_tt_exit_ct_kill(priv);
 
 	if (flags & HW_CARD_DISABLED)
 		set_bit(STATUS_RF_KILL_HW, &priv->status);
@@ -3015,6 +3007,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		test_bit(STATUS_RF_KILL_HW, &priv->status));
 
 	iwl_power_initialize(priv);
+	iwl_tt_initialize(priv);
 	return 0;
 
  out_remove_sysfs:
@@ -3067,6 +3060,8 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 		iwl_down(priv);
 	}
 
+	iwl_tt_exit(priv);
+
 	/* make sure we flush any pending irq or
 	 * tasklet for the driver
 	 */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 5ef3c37..d8aeb24 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2232,6 +2232,7 @@ void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR,
 		    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
 	spin_unlock_irqrestore(&priv->lock, flags);
+	priv->power_data.ct_kill_toggle = false;
 
 	switch (priv->hw_rev & CSR_HW_REV_TYPE_MSK) {
 	case CSR_HW_REV_TYPE_1000:
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index f2ea3f0..d7fdb58 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -36,6 +36,7 @@
 #include "iwl-eeprom.h"
 #include "iwl-dev.h"
 #include "iwl-core.h"
+#include "iwl-io.h"
 #include "iwl-commands.h"
 #include "iwl-debug.h"
 #include "iwl-power.h"
@@ -211,6 +212,7 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 {
 	struct iwl_power_mgr *setting = &(priv->power_data);
 	int ret = 0;
+	struct iwl_tt_mgmt *tt = &priv->power_data.tt;
 	u16 uninitialized_var(final_mode);
 	bool update_chains;
 
@@ -223,6 +225,10 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 	if (setting->power_disabled)
 		final_mode = IWL_POWER_MODE_CAM;
 
+	if (tt->state >= IWL_TI_1) {
+		/* TT power setting overwrite user & system power setting */
+		final_mode = tt->tt_power_mode;
+	}
 	if (iwl_is_ready_rf(priv) &&
 	    ((setting->power_mode != final_mode) || force)) {
 		struct iwl_powertable_cmd cmd;
@@ -267,6 +273,249 @@ int iwl_power_set_user_mode(struct iwl_priv *priv, u16 mode)
 }
 EXPORT_SYMBOL(iwl_power_set_user_mode);
 
+#define CT_KILL_EXIT_DURATION (5)	/* 5 seconds duration */
+
+/*
+ * toggle the bit to wake up uCode and check the temperature
+ * if the temperature is below CT, uCode will stay awake and send card
+ * state notification with CT_KILL bit clear to inform Thermal Throttling
+ * Management to change state. Otherwise, uCode will go back to sleep
+ * without doing anything, driver should continue the 5 seconds timer
+ * to wake up uCode for temperature check until temperature drop below CT
+ */
+static void iwl_tt_check_exit_ct_kill(unsigned long data)
+{
+	struct iwl_priv *priv = (struct iwl_priv *)data;
+	struct iwl_tt_mgmt *tt = &priv->power_data.tt;
+	unsigned long flags;
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	if (tt->state == IWL_TI_CT_KILL) {
+		if (priv->power_data.ct_kill_toggle) {
+			iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR,
+				    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
+			priv->power_data.ct_kill_toggle = false;
+		} else {
+			iwl_write32(priv, CSR_UCODE_DRV_GP1_SET,
+				    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
+			priv->power_data.ct_kill_toggle = true;
+		}
+		iwl_read32(priv, CSR_UCODE_DRV_GP1);
+		spin_lock_irqsave(&priv->reg_lock, flags);
+		if (!iwl_grab_nic_access(priv))
+			iwl_release_nic_access(priv);
+		spin_unlock_irqrestore(&priv->reg_lock, flags);
+
+		/* Reschedule the ct_kill timer to occur in
+		 * CT_KILL_EXIT_DURATION seconds to ensure we get a
+		 * thermal update */
+		mod_timer(&priv->power_data.ct_kill_exit_tm, jiffies +
+			  CT_KILL_EXIT_DURATION * HZ);
+	}
+}
+
+static void iwl_perform_ct_kill_task(struct iwl_priv *priv,
+			   bool stop)
+{
+	if (stop) {
+		IWL_DEBUG_POWER(priv, "Stop all queues\n");
+		if (priv->mac80211_registered)
+			ieee80211_stop_queues(priv->hw);
+		IWL_DEBUG_POWER(priv,
+				"Schedule 5 seconds CT_KILL Timer\n");
+		mod_timer(&priv->power_data.ct_kill_exit_tm, jiffies +
+			  CT_KILL_EXIT_DURATION * HZ);
+	} else {
+		IWL_DEBUG_POWER(priv, "Wake all queues\n");
+		if (priv->mac80211_registered)
+			ieee80211_wake_queues(priv->hw);
+	}
+}
+
+#define IWL_MINIMAL_POWER_THRESHOLD		(CT_KILL_THRESHOLD_LEGACY)
+#define IWL_REDUCED_PERFORMANCE_THRESHOLD_2	(100)
+#define IWL_REDUCED_PERFORMANCE_THRESHOLD_1	(90)
+
+/*
+ * Legacy thermal throttling
+ * 1) Avoid NIC destruction due to high temperatures
+ *	Chip will identify dangerously high temperatures that can
+ *	harm the device and will power down
+ * 2) Avoid the NIC power down due to high temperature
+ *	Throttle early enough to lower the power consumption before
+ *	drastic steps are needed
+ */
+static void iwl_legacy_tt_handler(struct iwl_priv *priv, s32 temp)
+{
+	struct iwl_tt_mgmt *tt = &priv->power_data.tt;
+	enum iwl_tt_state new_state;
+	struct iwl_power_mgr *setting = &priv->power_data;
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if ((tt->tt_previous_temp) &&
+	    (temp > tt->tt_previous_temp) &&
+	    ((temp - tt->tt_previous_temp) >
+	    IWL_TT_INCREASE_MARGIN)) {
+		IWL_DEBUG_POWER(priv,
+			"Temperature increase %d degree Celsius\n",
+			(temp - tt->tt_previous_temp));
+	}
+#endif
+	/* in Celsius */
+	if (temp >= IWL_MINIMAL_POWER_THRESHOLD)
+		new_state = IWL_TI_CT_KILL;
+	else if (temp >= IWL_REDUCED_PERFORMANCE_THRESHOLD_2)
+		new_state = IWL_TI_2;
+	else if (temp >= IWL_REDUCED_PERFORMANCE_THRESHOLD_1)
+		new_state = IWL_TI_1;
+	else
+		new_state = IWL_TI_0;
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	tt->tt_previous_temp = temp;
+#endif
+	if (tt->state != new_state) {
+		if (tt->state == IWL_TI_0) {
+			tt->sys_power_mode = setting->power_mode;
+			IWL_DEBUG_POWER(priv, "current power mode: %u\n",
+				setting->power_mode);
+		}
+		switch (new_state) {
+		case IWL_TI_0:
+			/* when system ready to go back to IWL_TI_0 state
+			 * using system power mode instead of TT power mode
+			 * revert back to the orginal power mode which was saved
+			 * before enter Thermal Throttling state
+			 * update priv->power_data.user_power_setting to the
+			 * required power mode to make sure
+			 * iwl_power_update_mode() will update power correctly.
+			 */
+			priv->power_data.user_power_setting =
+				tt->sys_power_mode;
+			tt->tt_power_mode = tt->sys_power_mode;
+			break;
+		case IWL_TI_1:
+			tt->tt_power_mode = IWL_POWER_INDEX_3;
+			break;
+		case IWL_TI_2:
+			tt->tt_power_mode = IWL_POWER_INDEX_4;
+			break;
+		default:
+			tt->tt_power_mode = IWL_POWER_INDEX_5;
+			break;
+		}
+		if (iwl_power_update_mode(priv, true)) {
+			/* TT state not updated
+			 * try again during next temperature read
+			 */
+			IWL_ERR(priv, "Cannot update power mode, "
+					"TT state not updated\n");
+		} else {
+			if (new_state == IWL_TI_CT_KILL)
+				iwl_perform_ct_kill_task(priv, true);
+			else if (tt->state == IWL_TI_CT_KILL &&
+				 new_state != IWL_TI_CT_KILL)
+				iwl_perform_ct_kill_task(priv, false);
+			tt->state = new_state;
+			IWL_DEBUG_POWER(priv, "Temperature state changed %u\n",
+					tt->state);
+			IWL_DEBUG_POWER(priv, "Power Index change to %u\n",
+					tt->tt_power_mode);
+		}
+	}
+}
+
+/* Card State Notification indicated reach critical temperature
+ * if PSP not enable, no Thermal Throttling function will be performed
+ * just set the GP1 bit to acknowledge the event
+ * otherwise, go into IWL_TI_CT_KILL state
+ * since Card State Notification will not provide any temperature reading
+ * so just pass the CT_KILL temperature to iwl_legacy_tt_handler()
+ */
+void iwl_tt_enter_ct_kill(struct iwl_priv *priv)
+{
+	struct iwl_tt_mgmt *tt = &priv->power_data.tt;
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	if (tt->state != IWL_TI_CT_KILL) {
+		IWL_ERR(priv, "Device reached critical temperature "
+			      "- ucode going to sleep!\n");
+		iwl_legacy_tt_handler(priv, IWL_MINIMAL_POWER_THRESHOLD);
+	}
+}
+EXPORT_SYMBOL(iwl_tt_enter_ct_kill);
+
+/* Card State Notification indicated out of critical temperature
+ * since Card State Notification will not provide any temperature reading
+ * so pass the IWL_REDUCED_PERFORMANCE_THRESHOLD_2 temperature
+ * to iwl_legacy_tt_handler() to get out of IWL_CT_KILL state
+ */
+void iwl_tt_exit_ct_kill(struct iwl_priv *priv)
+{
+	struct iwl_tt_mgmt *tt = &priv->power_data.tt;
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	/* stop ct_kill_exit_tm timer */
+	del_timer_sync(&priv->power_data.ct_kill_exit_tm);
+
+	if (tt->state == IWL_TI_CT_KILL) {
+		IWL_ERR(priv,
+			"Device temperature below critical"
+			"- ucode awake!\n");
+		iwl_legacy_tt_handler(priv,
+			IWL_REDUCED_PERFORMANCE_THRESHOLD_2);
+	}
+}
+EXPORT_SYMBOL(iwl_tt_exit_ct_kill);
+
+void iwl_tt_handler(struct iwl_priv *priv)
+{
+	s32 temp = priv->temperature; /* degrees CELSIUS except 4965 */
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) == CSR_HW_REV_TYPE_4965)
+		temp = KELVIN_TO_CELSIUS(priv->temperature);
+
+	iwl_legacy_tt_handler(priv, temp);
+}
+EXPORT_SYMBOL(iwl_tt_handler);
+
+/* Thermal throttling initialization
+ */
+void iwl_tt_initialize(struct iwl_priv *priv)
+{
+	struct iwl_tt_mgmt *tt = &priv->power_data.tt;
+	struct iwl_power_mgr *setting = &priv->power_data;
+
+	IWL_DEBUG_POWER(priv, "Initialize Thermal Throttling \n");
+
+	memset(tt, 0, sizeof(struct iwl_tt_mgmt));
+
+	tt->state = IWL_TI_0;
+	tt->sys_power_mode = setting->power_mode;
+	tt->tt_power_mode = tt->sys_power_mode;
+	init_timer(&priv->power_data.ct_kill_exit_tm);
+	priv->power_data.ct_kill_exit_tm.data = (unsigned long)priv;
+	priv->power_data.ct_kill_exit_tm.function = iwl_tt_check_exit_ct_kill;
+}
+EXPORT_SYMBOL(iwl_tt_initialize);
+
+/* cleanup thermal throttling management related memory and timer */
+void iwl_tt_exit(struct iwl_priv *priv)
+{
+	/* stop ct_kill_exit_tm timer if activated */
+	del_timer_sync(&priv->power_data.ct_kill_exit_tm);
+}
+EXPORT_SYMBOL(iwl_tt_exit);
+
 /* initialize to default */
 void iwl_power_initialize(struct iwl_priv *priv)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.h b/drivers/net/wireless/iwlwifi/iwl-power.h
index 37ba3bb..7bb10d4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.h
+++ b/drivers/net/wireless/iwlwifi/iwl-power.h
@@ -33,6 +33,38 @@
 
 struct iwl_priv;
 
+#define IWL_TT_INCREASE_MARGIN	5
+
+/* Thermal Throttling State Machine states */
+enum  iwl_tt_state {
+	IWL_TI_0,	/* normal temperature, system power state */
+	IWL_TI_1,	/* high temperature detect, low power state */
+	IWL_TI_2,	/* higher temperature detected, lower power state */
+	IWL_TI_CT_KILL, /* critical temperature detected, lowest power state */
+	IWL_TI_STATE_MAX
+};
+
+/**
+ * struct iwl_tt_mgnt - Thermal Throttling Management structure
+ * @state:          current Thermal Throttling state
+ * @tt_power_mode:  Thermal Throttling power mode index
+ *		    being used to set power level when
+ * 		    when thermal throttling state != IWL_TI_0
+ *		    the tt_power_mode should set to different
+ *		    power mode based on the current tt state
+ * @sys_power_mode: previous system power mode
+ *                  before transition into TT state
+ * @tt_previous_temperature: last measured temperature
+ */
+struct iwl_tt_mgmt {
+	enum iwl_tt_state state;
+	u8 tt_power_mode;
+	u8 sys_power_mode;
+#ifdef CONFIG_IWLWIFI_DEBUG
+	s32 tt_previous_temp;
+#endif
+};
+
 enum {
 	IWL_POWER_MODE_CAM, /* Continuously Aware Mode, always on */
 	IWL_POWER_INDEX_1,
@@ -59,10 +91,20 @@ struct iwl_power_mgr {
 	u8 power_mode;
 	u8 user_power_setting; /* set by user through sysfs */
 	u8 power_disabled; /* set by mac80211's CONF_PS */
+	struct iwl_tt_mgmt tt; /* Thermal Throttling Management */
+	bool ct_kill_toggle;   /* use to toggle the CSR bit when
+				* checking uCode temperature
+				*/
+	struct timer_list ct_kill_exit_tm;
 };
 
 int iwl_power_update_mode(struct iwl_priv *priv, bool force);
 int iwl_power_set_user_mode(struct iwl_priv *priv, u16 mode);
+void iwl_tt_enter_ct_kill(struct iwl_priv *priv);
+void iwl_tt_exit_ct_kill(struct iwl_priv *priv);
+void iwl_tt_handler(struct iwl_priv *priv);
+void iwl_tt_initialize(struct iwl_priv *priv);
+void iwl_tt_exit(struct iwl_priv *priv);
 void iwl_power_initialize(struct iwl_priv *priv);
 
 #endif  /* __iwl_power_setting_h__ */
-- 
1.5.6.3

