Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:55161 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756473Ab0GaQyr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jul 2010 12:54:47 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3/8] iwlwifi: separate thermal throttling function
Date: Sat, 31 Jul 2010 08:34:07 -0700
Message-Id: <1280590452-10655-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1280590452-10655-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1280590452-10655-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

"Thermal Throttling" is an advance feature which only available for
newer _agn devices. Move from iwl-core to iwl-agn for better code
organization.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile     |    1 +
 drivers/net/wireless/iwlwifi/iwl-1000.c   |    5 +
 drivers/net/wireless/iwlwifi/iwl-5000.c   |   10 +
 drivers/net/wireless/iwlwifi/iwl-6000.c   |    5 +
 drivers/net/wireless/iwlwifi/iwl-agn-tt.c |  697 +++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn-tt.h |  129 ++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c    |   46 ++
 drivers/net/wireless/iwlwifi/iwl-core.c   |   48 --
 drivers/net/wireless/iwlwifi/iwl-core.h   |   10 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    1 +
 drivers/net/wireless/iwlwifi/iwl-power.c  |  640 +--------------------------
 drivers/net/wireless/iwlwifi/iwl-power.h  |   93 ----
 drivers/net/wireless/iwlwifi/iwl-tx.c     |    9 +-
 13 files changed, 918 insertions(+), 776 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-tt.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-tt.h

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 728bb85..4931639 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_IWLAGN)	+= iwlagn.o
 iwlagn-objs		:= iwl-agn.o iwl-agn-rs.o iwl-agn-led.o iwl-agn-ict.o
 iwlagn-objs		+= iwl-agn-ucode.o iwl-agn-hcmd.o iwl-agn-tx.o
 iwlagn-objs		+= iwl-agn-lib.o iwl-agn-rx.o iwl-agn-calib.o
+iwlagn-objs		+= iwl-agn-tt.o
 iwlagn-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-agn-debugfs.o
 
 iwlagn-$(CONFIG_IWL4965) += iwl-4965.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 8848333..5ed2441 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -229,6 +229,11 @@ static struct iwl_lib_ops iwl1000_lib = {
 	.check_ack_health = iwl_good_ack_health,
 	.txfifo_flush = iwlagn_txfifo_flush,
 	.dev_txfifo_flush = iwlagn_dev_txfifo_flush,
+	.tt_ops = {
+		.lower_power_detection = iwl_tt_is_low_power_state,
+		.tt_power_mode = iwl_tt_current_power_mode,
+		.ct_kill_check = iwl_check_for_ct_kill,
+	}
 };
 
 static const struct iwl_ops iwl1000_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 8093ce2..68e282b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -405,6 +405,11 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.check_ack_health = iwl_good_ack_health,
 	.txfifo_flush = iwlagn_txfifo_flush,
 	.dev_txfifo_flush = iwlagn_dev_txfifo_flush,
+	.tt_ops = {
+		.lower_power_detection = iwl_tt_is_low_power_state,
+		.tt_power_mode = iwl_tt_current_power_mode,
+		.ct_kill_check = iwl_check_for_ct_kill,
+	}
 };
 
 static struct iwl_lib_ops iwl5150_lib = {
@@ -470,6 +475,11 @@ static struct iwl_lib_ops iwl5150_lib = {
 	.check_ack_health = iwl_good_ack_health,
 	.txfifo_flush = iwlagn_txfifo_flush,
 	.dev_txfifo_flush = iwlagn_dev_txfifo_flush,
+	.tt_ops = {
+		.lower_power_detection = iwl_tt_is_low_power_state,
+		.tt_power_mode = iwl_tt_current_power_mode,
+		.ct_kill_check = iwl_check_for_ct_kill,
+	}
 };
 
 static const struct iwl_ops iwl5000_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 5827052..f900e98 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -330,6 +330,11 @@ static struct iwl_lib_ops iwl6000_lib = {
 	.check_ack_health = iwl_good_ack_health,
 	.txfifo_flush = iwlagn_txfifo_flush,
 	.dev_txfifo_flush = iwlagn_dev_txfifo_flush,
+	.tt_ops = {
+		.lower_power_detection = iwl_tt_is_low_power_state,
+		.tt_power_mode = iwl_tt_current_power_mode,
+		.ct_kill_check = iwl_check_for_ct_kill,
+	}
 };
 
 static const struct iwl_ops iwl6000_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.c b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
new file mode 100644
index 0000000..e4b8ebb
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tt.c
@@ -0,0 +1,697 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2007 - 2010 Intel Corporation. All rights reserved.
+ *
+ * Portions of this file are derived from the ipw3945 project, as well
+ * as portions of the ieee80211 subsystem header files.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *****************************************************************************/
+
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+
+#include <net/mac80211.h>
+
+#include "iwl-eeprom.h"
+#include "iwl-dev.h"
+#include "iwl-core.h"
+#include "iwl-io.h"
+#include "iwl-commands.h"
+#include "iwl-debug.h"
+#include "iwl-agn-tt.h"
+
+/* default Thermal Throttling transaction table
+ * Current state   |         Throttling Down               |  Throttling Up
+ *=============================================================================
+ *                 Condition Nxt State  Condition Nxt State Condition Nxt State
+ *-----------------------------------------------------------------------------
+ *     IWL_TI_0     T >= 114   CT_KILL  114>T>=105   TI_1      N/A      N/A
+ *     IWL_TI_1     T >= 114   CT_KILL  114>T>=110   TI_2     T<=95     TI_0
+ *     IWL_TI_2     T >= 114   CT_KILL                        T<=100    TI_1
+ *    IWL_CT_KILL      N/A       N/A       N/A        N/A     T<=95     TI_0
+ *=============================================================================
+ */
+static const struct iwl_tt_trans tt_range_0[IWL_TI_STATE_MAX - 1] = {
+	{IWL_TI_0, IWL_ABSOLUTE_ZERO, 104},
+	{IWL_TI_1, 105, CT_KILL_THRESHOLD - 1},
+	{IWL_TI_CT_KILL, CT_KILL_THRESHOLD, IWL_ABSOLUTE_MAX}
+};
+static const struct iwl_tt_trans tt_range_1[IWL_TI_STATE_MAX - 1] = {
+	{IWL_TI_0, IWL_ABSOLUTE_ZERO, 95},
+	{IWL_TI_2, 110, CT_KILL_THRESHOLD - 1},
+	{IWL_TI_CT_KILL, CT_KILL_THRESHOLD, IWL_ABSOLUTE_MAX}
+};
+static const struct iwl_tt_trans tt_range_2[IWL_TI_STATE_MAX - 1] = {
+	{IWL_TI_1, IWL_ABSOLUTE_ZERO, 100},
+	{IWL_TI_CT_KILL, CT_KILL_THRESHOLD, IWL_ABSOLUTE_MAX},
+	{IWL_TI_CT_KILL, CT_KILL_THRESHOLD, IWL_ABSOLUTE_MAX}
+};
+static const struct iwl_tt_trans tt_range_3[IWL_TI_STATE_MAX - 1] = {
+	{IWL_TI_0, IWL_ABSOLUTE_ZERO, CT_KILL_EXIT_THRESHOLD},
+	{IWL_TI_CT_KILL, CT_KILL_EXIT_THRESHOLD + 1, IWL_ABSOLUTE_MAX},
+	{IWL_TI_CT_KILL, CT_KILL_EXIT_THRESHOLD + 1, IWL_ABSOLUTE_MAX}
+};
+
+/* Advance Thermal Throttling default restriction table */
+static const struct iwl_tt_restriction restriction_range[IWL_TI_STATE_MAX] = {
+	{IWL_ANT_OK_MULTI, IWL_ANT_OK_MULTI, true },
+	{IWL_ANT_OK_SINGLE, IWL_ANT_OK_MULTI, true },
+	{IWL_ANT_OK_SINGLE, IWL_ANT_OK_SINGLE, false },
+	{IWL_ANT_OK_NONE, IWL_ANT_OK_NONE, false }
+};
+
+bool iwl_tt_is_low_power_state(struct iwl_priv *priv)
+{
+	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
+
+	if (tt->state >= IWL_TI_1)
+		return true;
+	return false;
+}
+
+u8 iwl_tt_current_power_mode(struct iwl_priv *priv)
+{
+	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
+
+	return tt->tt_power_mode;
+}
+
+bool iwl_ht_enabled(struct iwl_priv *priv)
+{
+	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
+	struct iwl_tt_restriction *restriction;
+
+	if (!priv->thermal_throttle.advanced_tt)
+		return true;
+	restriction = tt->restriction + tt->state;
+	return restriction->is_ht;
+}
+
+static bool iwl_within_ct_kill_margin(struct iwl_priv *priv)
+{
+	s32 temp = priv->temperature; /* degrees CELSIUS except specified */
+	bool within_margin = false;
+
+	if (priv->cfg->temperature_kelvin)
+		temp = KELVIN_TO_CELSIUS(priv->temperature);
+
+	if (!priv->thermal_throttle.advanced_tt)
+		within_margin = ((temp + IWL_TT_CT_KILL_MARGIN) >=
+				CT_KILL_THRESHOLD_LEGACY) ? true : false;
+	else
+		within_margin = ((temp + IWL_TT_CT_KILL_MARGIN) >=
+				CT_KILL_THRESHOLD) ? true : false;
+	return within_margin;
+}
+
+bool iwl_check_for_ct_kill(struct iwl_priv *priv)
+{
+	bool is_ct_kill = false;
+
+	if (iwl_within_ct_kill_margin(priv)) {
+		iwl_tt_enter_ct_kill(priv);
+		is_ct_kill = true;
+	}
+	return is_ct_kill;
+}
+
+enum iwl_antenna_ok iwl_tx_ant_restriction(struct iwl_priv *priv)
+{
+	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
+	struct iwl_tt_restriction *restriction;
+
+	if (!priv->thermal_throttle.advanced_tt)
+		return IWL_ANT_OK_MULTI;
+	restriction = tt->restriction + tt->state;
+	return restriction->tx_stream;
+}
+
+enum iwl_antenna_ok iwl_rx_ant_restriction(struct iwl_priv *priv)
+{
+	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
+	struct iwl_tt_restriction *restriction;
+
+	if (!priv->thermal_throttle.advanced_tt)
+		return IWL_ANT_OK_MULTI;
+	restriction = tt->restriction + tt->state;
+	return restriction->rx_stream;
+}
+
+#define CT_KILL_EXIT_DURATION (5)	/* 5 seconds duration */
+#define CT_KILL_WAITING_DURATION (300)	/* 300ms duration */
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
+	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
+	unsigned long flags;
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	if (tt->state == IWL_TI_CT_KILL) {
+		if (priv->thermal_throttle.ct_kill_toggle) {
+			iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR,
+				    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
+			priv->thermal_throttle.ct_kill_toggle = false;
+		} else {
+			iwl_write32(priv, CSR_UCODE_DRV_GP1_SET,
+				    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
+			priv->thermal_throttle.ct_kill_toggle = true;
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
+		IWL_DEBUG_POWER(priv, "schedule ct_kill exit timer\n");
+		mod_timer(&priv->thermal_throttle.ct_kill_exit_tm,
+			  jiffies + CT_KILL_EXIT_DURATION * HZ);
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
+		mod_timer(&priv->thermal_throttle.ct_kill_exit_tm,
+			  jiffies + CT_KILL_EXIT_DURATION * HZ);
+	} else {
+		IWL_DEBUG_POWER(priv, "Wake all queues\n");
+		if (priv->mac80211_registered)
+			ieee80211_wake_queues(priv->hw);
+	}
+}
+
+static void iwl_tt_ready_for_ct_kill(unsigned long data)
+{
+	struct iwl_priv *priv = (struct iwl_priv *)data;
+	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	/* temperature timer expired, ready to go into CT_KILL state */
+	if (tt->state != IWL_TI_CT_KILL) {
+		IWL_DEBUG_POWER(priv, "entering CT_KILL state when "
+				"temperature timer expired\n");
+		tt->state = IWL_TI_CT_KILL;
+		set_bit(STATUS_CT_KILL, &priv->status);
+		iwl_perform_ct_kill_task(priv, true);
+	}
+}
+
+static void iwl_prepare_ct_kill_task(struct iwl_priv *priv)
+{
+	IWL_DEBUG_POWER(priv, "Prepare to enter IWL_TI_CT_KILL\n");
+	/* make request to retrieve statistics information */
+	iwl_send_statistics_request(priv, CMD_SYNC, false);
+	/* Reschedule the ct_kill wait timer */
+	mod_timer(&priv->thermal_throttle.ct_kill_waiting_tm,
+		 jiffies + msecs_to_jiffies(CT_KILL_WAITING_DURATION));
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
+static void iwl_legacy_tt_handler(struct iwl_priv *priv, s32 temp, bool force)
+{
+	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
+	enum iwl_tt_state old_state;
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
+	old_state = tt->state;
+	/* in Celsius */
+	if (temp >= IWL_MINIMAL_POWER_THRESHOLD)
+		tt->state = IWL_TI_CT_KILL;
+	else if (temp >= IWL_REDUCED_PERFORMANCE_THRESHOLD_2)
+		tt->state = IWL_TI_2;
+	else if (temp >= IWL_REDUCED_PERFORMANCE_THRESHOLD_1)
+		tt->state = IWL_TI_1;
+	else
+		tt->state = IWL_TI_0;
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	tt->tt_previous_temp = temp;
+#endif
+	/* stop ct_kill_waiting_tm timer */
+	del_timer_sync(&priv->thermal_throttle.ct_kill_waiting_tm);
+	if (tt->state != old_state) {
+		switch (tt->state) {
+		case IWL_TI_0:
+			/*
+			 * When the system is ready to go back to IWL_TI_0
+			 * we only have to call iwl_power_update_mode() to
+			 * do so.
+			 */
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
+		mutex_lock(&priv->mutex);
+		if (old_state == IWL_TI_CT_KILL)
+			clear_bit(STATUS_CT_KILL, &priv->status);
+		if (tt->state != IWL_TI_CT_KILL &&
+		    iwl_power_update_mode(priv, true)) {
+			/* TT state not updated
+			 * try again during next temperature read
+			 */
+			if (old_state == IWL_TI_CT_KILL)
+				set_bit(STATUS_CT_KILL, &priv->status);
+			tt->state = old_state;
+			IWL_ERR(priv, "Cannot update power mode, "
+					"TT state not updated\n");
+		} else {
+			if (tt->state == IWL_TI_CT_KILL) {
+				if (force) {
+					set_bit(STATUS_CT_KILL, &priv->status);
+					iwl_perform_ct_kill_task(priv, true);
+				} else {
+					iwl_prepare_ct_kill_task(priv);
+					tt->state = old_state;
+				}
+			} else if (old_state == IWL_TI_CT_KILL &&
+				 tt->state != IWL_TI_CT_KILL)
+				iwl_perform_ct_kill_task(priv, false);
+			IWL_DEBUG_POWER(priv, "Temperature state changed %u\n",
+					tt->state);
+			IWL_DEBUG_POWER(priv, "Power Index change to %u\n",
+					tt->tt_power_mode);
+		}
+		mutex_unlock(&priv->mutex);
+	}
+}
+
+/*
+ * Advance thermal throttling
+ * 1) Avoid NIC destruction due to high temperatures
+ *	Chip will identify dangerously high temperatures that can
+ *	harm the device and will power down
+ * 2) Avoid the NIC power down due to high temperature
+ *	Throttle early enough to lower the power consumption before
+ *	drastic steps are needed
+ *	Actions include relaxing the power down sleep thresholds and
+ *	decreasing the number of TX streams
+ * 3) Avoid throughput performance impact as much as possible
+ *
+ *=============================================================================
+ *                 Condition Nxt State  Condition Nxt State Condition Nxt State
+ *-----------------------------------------------------------------------------
+ *     IWL_TI_0     T >= 114   CT_KILL  114>T>=105   TI_1      N/A      N/A
+ *     IWL_TI_1     T >= 114   CT_KILL  114>T>=110   TI_2     T<=95     TI_0
+ *     IWL_TI_2     T >= 114   CT_KILL                        T<=100    TI_1
+ *    IWL_CT_KILL      N/A       N/A       N/A        N/A     T<=95     TI_0
+ *=============================================================================
+ */
+static void iwl_advance_tt_handler(struct iwl_priv *priv, s32 temp, bool force)
+{
+	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
+	int i;
+	bool changed = false;
+	enum iwl_tt_state old_state;
+	struct iwl_tt_trans *transaction;
+
+	old_state = tt->state;
+	for (i = 0; i < IWL_TI_STATE_MAX - 1; i++) {
+		/* based on the current TT state,
+		 * find the curresponding transaction table
+		 * each table has (IWL_TI_STATE_MAX - 1) entries
+		 * tt->transaction + ((old_state * (IWL_TI_STATE_MAX - 1))
+		 * will advance to the correct table.
+		 * then based on the current temperature
+		 * find the next state need to transaction to
+		 * go through all the possible (IWL_TI_STATE_MAX - 1) entries
+		 * in the current table to see if transaction is needed
+		 */
+		transaction = tt->transaction +
+			((old_state * (IWL_TI_STATE_MAX - 1)) + i);
+		if (temp >= transaction->tt_low &&
+		    temp <= transaction->tt_high) {
+#ifdef CONFIG_IWLWIFI_DEBUG
+			if ((tt->tt_previous_temp) &&
+			    (temp > tt->tt_previous_temp) &&
+			    ((temp - tt->tt_previous_temp) >
+			    IWL_TT_INCREASE_MARGIN)) {
+				IWL_DEBUG_POWER(priv,
+					"Temperature increase %d "
+					"degree Celsius\n",
+					(temp - tt->tt_previous_temp));
+			}
+			tt->tt_previous_temp = temp;
+#endif
+			if (old_state !=
+			    transaction->next_state) {
+				changed = true;
+				tt->state =
+					transaction->next_state;
+			}
+			break;
+		}
+	}
+	/* stop ct_kill_waiting_tm timer */
+	del_timer_sync(&priv->thermal_throttle.ct_kill_waiting_tm);
+	if (changed) {
+		struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
+
+		if (tt->state >= IWL_TI_1) {
+			/* force PI = IWL_POWER_INDEX_5 in the case of TI > 0 */
+			tt->tt_power_mode = IWL_POWER_INDEX_5;
+			if (!iwl_ht_enabled(priv))
+				/* disable HT */
+				rxon->flags &= ~(RXON_FLG_CHANNEL_MODE_MSK |
+					RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK |
+					RXON_FLG_HT40_PROT_MSK |
+					RXON_FLG_HT_PROT_MSK);
+			else {
+				/* check HT capability and set
+				 * according to the system HT capability
+				 * in case get disabled before */
+				iwl_set_rxon_ht(priv, &priv->current_ht_config);
+			}
+
+		} else {
+			/*
+			 * restore system power setting -- it will be
+			 * recalculated automatically.
+			 */
+
+			/* check HT capability and set
+			 * according to the system HT capability
+			 * in case get disabled before */
+			iwl_set_rxon_ht(priv, &priv->current_ht_config);
+		}
+		mutex_lock(&priv->mutex);
+		if (old_state == IWL_TI_CT_KILL)
+			clear_bit(STATUS_CT_KILL, &priv->status);
+		if (tt->state != IWL_TI_CT_KILL &&
+		    iwl_power_update_mode(priv, true)) {
+			/* TT state not updated
+			 * try again during next temperature read
+			 */
+			IWL_ERR(priv, "Cannot update power mode, "
+					"TT state not updated\n");
+			if (old_state == IWL_TI_CT_KILL)
+				set_bit(STATUS_CT_KILL, &priv->status);
+			tt->state = old_state;
+		} else {
+			IWL_DEBUG_POWER(priv,
+					"Thermal Throttling to new state: %u\n",
+					tt->state);
+			if (old_state != IWL_TI_CT_KILL &&
+			    tt->state == IWL_TI_CT_KILL) {
+				if (force) {
+					IWL_DEBUG_POWER(priv,
+						"Enter IWL_TI_CT_KILL\n");
+					set_bit(STATUS_CT_KILL, &priv->status);
+					iwl_perform_ct_kill_task(priv, true);
+				} else {
+					iwl_prepare_ct_kill_task(priv);
+					tt->state = old_state;
+				}
+			} else if (old_state == IWL_TI_CT_KILL &&
+				  tt->state != IWL_TI_CT_KILL) {
+				IWL_DEBUG_POWER(priv, "Exit IWL_TI_CT_KILL\n");
+				iwl_perform_ct_kill_task(priv, false);
+			}
+		}
+		mutex_unlock(&priv->mutex);
+	}
+}
+
+/* Card State Notification indicated reach critical temperature
+ * if PSP not enable, no Thermal Throttling function will be performed
+ * just set the GP1 bit to acknowledge the event
+ * otherwise, go into IWL_TI_CT_KILL state
+ * since Card State Notification will not provide any temperature reading
+ * for Legacy mode
+ * so just pass the CT_KILL temperature to iwl_legacy_tt_handler()
+ * for advance mode
+ * pass CT_KILL_THRESHOLD+1 to make sure move into IWL_TI_CT_KILL state
+ */
+static void iwl_bg_ct_enter(struct work_struct *work)
+{
+	struct iwl_priv *priv = container_of(work, struct iwl_priv, ct_enter);
+	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	if (!iwl_is_ready(priv))
+		return;
+
+	if (tt->state != IWL_TI_CT_KILL) {
+		IWL_ERR(priv, "Device reached critical temperature "
+			      "- ucode going to sleep!\n");
+		if (!priv->thermal_throttle.advanced_tt)
+			iwl_legacy_tt_handler(priv,
+					      IWL_MINIMAL_POWER_THRESHOLD,
+					      true);
+		else
+			iwl_advance_tt_handler(priv,
+					       CT_KILL_THRESHOLD + 1, true);
+	}
+}
+
+/* Card State Notification indicated out of critical temperature
+ * since Card State Notification will not provide any temperature reading
+ * so pass the IWL_REDUCED_PERFORMANCE_THRESHOLD_2 temperature
+ * to iwl_legacy_tt_handler() to get out of IWL_CT_KILL state
+ */
+static void iwl_bg_ct_exit(struct work_struct *work)
+{
+	struct iwl_priv *priv = container_of(work, struct iwl_priv, ct_exit);
+	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	if (!iwl_is_ready(priv))
+		return;
+
+	/* stop ct_kill_exit_tm timer */
+	del_timer_sync(&priv->thermal_throttle.ct_kill_exit_tm);
+
+	if (tt->state == IWL_TI_CT_KILL) {
+		IWL_ERR(priv,
+			"Device temperature below critical"
+			"- ucode awake!\n");
+		/*
+		 * exit from CT_KILL state
+		 * reset the current temperature reading
+		 */
+		priv->temperature = 0;
+		if (!priv->thermal_throttle.advanced_tt)
+			iwl_legacy_tt_handler(priv,
+				      IWL_REDUCED_PERFORMANCE_THRESHOLD_2,
+				      true);
+		else
+			iwl_advance_tt_handler(priv, CT_KILL_EXIT_THRESHOLD,
+					       true);
+	}
+}
+
+void iwl_tt_enter_ct_kill(struct iwl_priv *priv)
+{
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	IWL_DEBUG_POWER(priv, "Queueing critical temperature enter.\n");
+	queue_work(priv->workqueue, &priv->ct_enter);
+}
+EXPORT_SYMBOL(iwl_tt_enter_ct_kill);
+
+void iwl_tt_exit_ct_kill(struct iwl_priv *priv)
+{
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	IWL_DEBUG_POWER(priv, "Queueing critical temperature exit.\n");
+	queue_work(priv->workqueue, &priv->ct_exit);
+}
+EXPORT_SYMBOL(iwl_tt_exit_ct_kill);
+
+static void iwl_bg_tt_work(struct work_struct *work)
+{
+	struct iwl_priv *priv = container_of(work, struct iwl_priv, tt_work);
+	s32 temp = priv->temperature; /* degrees CELSIUS except specified */
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	if (priv->cfg->temperature_kelvin)
+		temp = KELVIN_TO_CELSIUS(priv->temperature);
+
+	if (!priv->thermal_throttle.advanced_tt)
+		iwl_legacy_tt_handler(priv, temp, false);
+	else
+		iwl_advance_tt_handler(priv, temp, false);
+}
+
+void iwl_tt_handler(struct iwl_priv *priv)
+{
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	IWL_DEBUG_POWER(priv, "Queueing thermal throttling work.\n");
+	queue_work(priv->workqueue, &priv->tt_work);
+}
+EXPORT_SYMBOL(iwl_tt_handler);
+
+/* Thermal throttling initialization
+ * For advance thermal throttling:
+ *     Initialize Thermal Index and temperature threshold table
+ *     Initialize thermal throttling restriction table
+ */
+void iwl_tt_initialize(struct iwl_priv *priv)
+{
+	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
+	int size = sizeof(struct iwl_tt_trans) * (IWL_TI_STATE_MAX - 1);
+	struct iwl_tt_trans *transaction;
+
+	IWL_DEBUG_POWER(priv, "Initialize Thermal Throttling\n");
+
+	memset(tt, 0, sizeof(struct iwl_tt_mgmt));
+
+	tt->state = IWL_TI_0;
+	init_timer(&priv->thermal_throttle.ct_kill_exit_tm);
+	priv->thermal_throttle.ct_kill_exit_tm.data = (unsigned long)priv;
+	priv->thermal_throttle.ct_kill_exit_tm.function =
+		iwl_tt_check_exit_ct_kill;
+	init_timer(&priv->thermal_throttle.ct_kill_waiting_tm);
+	priv->thermal_throttle.ct_kill_waiting_tm.data =
+		(unsigned long)priv;
+	priv->thermal_throttle.ct_kill_waiting_tm.function =
+		iwl_tt_ready_for_ct_kill;
+	/* setup deferred ct kill work */
+	INIT_WORK(&priv->tt_work, iwl_bg_tt_work);
+	INIT_WORK(&priv->ct_enter, iwl_bg_ct_enter);
+	INIT_WORK(&priv->ct_exit, iwl_bg_ct_exit);
+
+	if (priv->cfg->adv_thermal_throttle) {
+		IWL_DEBUG_POWER(priv, "Advanced Thermal Throttling\n");
+		tt->restriction = kzalloc(sizeof(struct iwl_tt_restriction) *
+					 IWL_TI_STATE_MAX, GFP_KERNEL);
+		tt->transaction = kzalloc(sizeof(struct iwl_tt_trans) *
+			IWL_TI_STATE_MAX * (IWL_TI_STATE_MAX - 1),
+			GFP_KERNEL);
+		if (!tt->restriction || !tt->transaction) {
+			IWL_ERR(priv, "Fallback to Legacy Throttling\n");
+			priv->thermal_throttle.advanced_tt = false;
+			kfree(tt->restriction);
+			tt->restriction = NULL;
+			kfree(tt->transaction);
+			tt->transaction = NULL;
+		} else {
+			transaction = tt->transaction +
+				(IWL_TI_0 * (IWL_TI_STATE_MAX - 1));
+			memcpy(transaction, &tt_range_0[0], size);
+			transaction = tt->transaction +
+				(IWL_TI_1 * (IWL_TI_STATE_MAX - 1));
+			memcpy(transaction, &tt_range_1[0], size);
+			transaction = tt->transaction +
+				(IWL_TI_2 * (IWL_TI_STATE_MAX - 1));
+			memcpy(transaction, &tt_range_2[0], size);
+			transaction = tt->transaction +
+				(IWL_TI_CT_KILL * (IWL_TI_STATE_MAX - 1));
+			memcpy(transaction, &tt_range_3[0], size);
+			size = sizeof(struct iwl_tt_restriction) *
+				IWL_TI_STATE_MAX;
+			memcpy(tt->restriction,
+				&restriction_range[0], size);
+			priv->thermal_throttle.advanced_tt = true;
+		}
+	} else {
+		IWL_DEBUG_POWER(priv, "Legacy Thermal Throttling\n");
+		priv->thermal_throttle.advanced_tt = false;
+	}
+}
+EXPORT_SYMBOL(iwl_tt_initialize);
+
+/* cleanup thermal throttling management related memory and timer */
+void iwl_tt_exit(struct iwl_priv *priv)
+{
+	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
+
+	/* stop ct_kill_exit_tm timer if activated */
+	del_timer_sync(&priv->thermal_throttle.ct_kill_exit_tm);
+	/* stop ct_kill_waiting_tm timer if activated */
+	del_timer_sync(&priv->thermal_throttle.ct_kill_waiting_tm);
+	cancel_work_sync(&priv->tt_work);
+	cancel_work_sync(&priv->ct_enter);
+	cancel_work_sync(&priv->ct_exit);
+
+	if (priv->thermal_throttle.advanced_tt) {
+		/* free advance thermal throttling memory */
+		kfree(tt->restriction);
+		tt->restriction = NULL;
+		kfree(tt->transaction);
+		tt->transaction = NULL;
+	}
+}
+EXPORT_SYMBOL(iwl_tt_exit);
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tt.h b/drivers/net/wireless/iwlwifi/iwl-agn-tt.h
new file mode 100644
index 0000000..d550604
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tt.h
@@ -0,0 +1,129 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2007 - 2010 Intel Corporation. All rights reserved.
+ *
+ * Portions of this file are derived from the ipw3945 project, as well
+ * as portions of the ieee80211 subsystem header files.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *****************************************************************************/
+#ifndef __iwl_tt_setting_h__
+#define __iwl_tt_setting_h__
+
+#include "iwl-commands.h"
+
+#define IWL_ABSOLUTE_ZERO		0
+#define IWL_ABSOLUTE_MAX		0xFFFFFFFF
+#define IWL_TT_INCREASE_MARGIN	5
+#define IWL_TT_CT_KILL_MARGIN	3
+
+enum iwl_antenna_ok {
+	IWL_ANT_OK_NONE,
+	IWL_ANT_OK_SINGLE,
+	IWL_ANT_OK_MULTI,
+};
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
+ * struct iwl_tt_restriction - Thermal Throttling restriction table
+ * @tx_stream: number of tx stream allowed
+ * @is_ht: ht enable/disable
+ * @rx_stream: number of rx stream allowed
+ *
+ * This table is used by advance thermal throttling management
+ * based on the current thermal throttling state, and determines
+ * the number of tx/rx streams and the status of HT operation.
+ */
+struct iwl_tt_restriction {
+	enum iwl_antenna_ok tx_stream;
+	enum iwl_antenna_ok rx_stream;
+	bool is_ht;
+};
+
+/**
+ * struct iwl_tt_trans - Thermal Throttling transaction table
+ * @next_state:  next thermal throttling mode
+ * @tt_low: low temperature threshold to change state
+ * @tt_high: high temperature threshold to change state
+ *
+ * This is used by the advanced thermal throttling algorithm
+ * to determine the next thermal state to go based on the
+ * current temperature.
+ */
+struct iwl_tt_trans {
+	enum iwl_tt_state next_state;
+	u32 tt_low;
+	u32 tt_high;
+};
+
+/**
+ * struct iwl_tt_mgnt - Thermal Throttling Management structure
+ * @advanced_tt:    advanced thermal throttle required
+ * @state:          current Thermal Throttling state
+ * @tt_power_mode:  Thermal Throttling power mode index
+ *		    being used to set power level when
+ *		    when thermal throttling state != IWL_TI_0
+ *		    the tt_power_mode should set to different
+ *		    power mode based on the current tt state
+ * @tt_previous_temperature: last measured temperature
+ * @iwl_tt_restriction: ptr to restriction tbl, used by advance
+ *		    thermal throttling to determine how many tx/rx streams
+ *		    should be used in tt state; and can HT be enabled or not
+ * @iwl_tt_trans: ptr to adv trans table, used by advance thermal throttling
+ *		    state transaction
+ * @ct_kill_toggle: used to toggle the CSR bit when checking uCode temperature
+ * @ct_kill_exit_tm: timer to exit thermal kill
+ */
+struct iwl_tt_mgmt {
+	enum iwl_tt_state state;
+	bool advanced_tt;
+	u8 tt_power_mode;
+	bool ct_kill_toggle;
+#ifdef CONFIG_IWLWIFI_DEBUG
+	s32 tt_previous_temp;
+#endif
+	struct iwl_tt_restriction *restriction;
+	struct iwl_tt_trans *transaction;
+	struct timer_list ct_kill_exit_tm;
+	struct timer_list ct_kill_waiting_tm;
+};
+
+u8 iwl_tt_current_power_mode(struct iwl_priv *priv);
+bool iwl_tt_is_low_power_state(struct iwl_priv *priv);
+bool iwl_ht_enabled(struct iwl_priv *priv);
+bool iwl_check_for_ct_kill(struct iwl_priv *priv);
+enum iwl_antenna_ok iwl_tx_ant_restriction(struct iwl_priv *priv);
+enum iwl_antenna_ok iwl_rx_ant_restriction(struct iwl_priv *priv);
+void iwl_tt_enter_ct_kill(struct iwl_priv *priv);
+void iwl_tt_exit_ct_kill(struct iwl_priv *priv);
+void iwl_tt_handler(struct iwl_priv *priv);
+void iwl_tt_initialize(struct iwl_priv *priv);
+void iwl_tt_exit(struct iwl_priv *priv);
+
+#endif  /* __iwl_tt_setting_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 982e2c7..fcbc42c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2632,6 +2632,52 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 	return pos;
 }
 
+static void iwl_rf_kill_ct_config(struct iwl_priv *priv)
+{
+	struct iwl_ct_kill_config cmd;
+	struct iwl_ct_kill_throttling_config adv_cmd;
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR,
+		    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
+	spin_unlock_irqrestore(&priv->lock, flags);
+	priv->thermal_throttle.ct_kill_toggle = false;
+
+	if (priv->cfg->support_ct_kill_exit) {
+		adv_cmd.critical_temperature_enter =
+			cpu_to_le32(priv->hw_params.ct_kill_threshold);
+		adv_cmd.critical_temperature_exit =
+			cpu_to_le32(priv->hw_params.ct_kill_exit_threshold);
+
+		ret = iwl_send_cmd_pdu(priv, REPLY_CT_KILL_CONFIG_CMD,
+				       sizeof(adv_cmd), &adv_cmd);
+		if (ret)
+			IWL_ERR(priv, "REPLY_CT_KILL_CONFIG_CMD failed\n");
+		else
+			IWL_DEBUG_INFO(priv, "REPLY_CT_KILL_CONFIG_CMD "
+					"succeeded, "
+					"critical temperature enter is %d,"
+					"exit is %d\n",
+				       priv->hw_params.ct_kill_threshold,
+				       priv->hw_params.ct_kill_exit_threshold);
+	} else {
+		cmd.critical_temperature_R =
+			cpu_to_le32(priv->hw_params.ct_kill_threshold);
+
+		ret = iwl_send_cmd_pdu(priv, REPLY_CT_KILL_CONFIG_CMD,
+				       sizeof(cmd), &cmd);
+		if (ret)
+			IWL_ERR(priv, "REPLY_CT_KILL_CONFIG_CMD failed\n");
+		else
+			IWL_DEBUG_INFO(priv, "REPLY_CT_KILL_CONFIG_CMD "
+					"succeeded, "
+					"critical temperature is %d\n",
+					priv->hw_params.ct_kill_threshold);
+	}
+}
+
 /**
  * iwl_alive_start - called after REPLY_ALIVE notification received
  *                   from protocol/runtime uCode (initialization uCode's
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index dbc279d..5af5e23 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1516,54 +1516,6 @@ int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags, bool clear)
 }
 EXPORT_SYMBOL(iwl_send_statistics_request);
 
-void iwl_rf_kill_ct_config(struct iwl_priv *priv)
-{
-	struct iwl_ct_kill_config cmd;
-	struct iwl_ct_kill_throttling_config adv_cmd;
-	unsigned long flags;
-	int ret = 0;
-
-	spin_lock_irqsave(&priv->lock, flags);
-	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR,
-		    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
-	spin_unlock_irqrestore(&priv->lock, flags);
-	priv->thermal_throttle.ct_kill_toggle = false;
-
-	if (priv->cfg->support_ct_kill_exit) {
-		adv_cmd.critical_temperature_enter =
-			cpu_to_le32(priv->hw_params.ct_kill_threshold);
-		adv_cmd.critical_temperature_exit =
-			cpu_to_le32(priv->hw_params.ct_kill_exit_threshold);
-
-		ret = iwl_send_cmd_pdu(priv, REPLY_CT_KILL_CONFIG_CMD,
-				       sizeof(adv_cmd), &adv_cmd);
-		if (ret)
-			IWL_ERR(priv, "REPLY_CT_KILL_CONFIG_CMD failed\n");
-		else
-			IWL_DEBUG_INFO(priv, "REPLY_CT_KILL_CONFIG_CMD "
-					"succeeded, "
-					"critical temperature enter is %d,"
-					"exit is %d\n",
-				       priv->hw_params.ct_kill_threshold,
-				       priv->hw_params.ct_kill_exit_threshold);
-	} else {
-		cmd.critical_temperature_R =
-			cpu_to_le32(priv->hw_params.ct_kill_threshold);
-
-		ret = iwl_send_cmd_pdu(priv, REPLY_CT_KILL_CONFIG_CMD,
-				       sizeof(cmd), &cmd);
-		if (ret)
-			IWL_ERR(priv, "REPLY_CT_KILL_CONFIG_CMD failed\n");
-		else
-			IWL_DEBUG_INFO(priv, "REPLY_CT_KILL_CONFIG_CMD "
-					"succeeded, "
-					"critical temperature is %d\n",
-					priv->hw_params.ct_kill_threshold);
-	}
-}
-EXPORT_SYMBOL(iwl_rf_kill_ct_config);
-
-
 /*
  * CARD_STATE_CMD
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 7e51a9b..4c3bf4d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -135,6 +135,12 @@ struct iwl_temp_ops {
 	void (*set_calib_version)(struct iwl_priv *priv);
 };
 
+struct iwl_tt_ops {
+	bool (*lower_power_detection)(struct iwl_priv *priv);
+	u8 (*tt_power_mode)(struct iwl_priv *priv);
+	bool (*ct_kill_check)(struct iwl_priv *priv);
+};
+
 struct iwl_lib_ops {
 	/* set hw dependent parameters */
 	int (*set_hw_params)(struct iwl_priv *priv);
@@ -211,6 +217,9 @@ struct iwl_lib_ops {
 	void (*dev_txfifo_flush)(struct iwl_priv *priv, u16 flush_control);
 
 	struct iwl_debugfs_ops debugfs_ops;
+
+	/* thermal throttling */
+	struct iwl_tt_ops tt_ops;
 };
 
 struct iwl_led_ops {
@@ -695,7 +704,6 @@ static inline int iwl_is_ready_rf(struct iwl_priv *priv)
 	return iwl_is_ready(priv);
 }
 
-extern void iwl_rf_kill_ct_config(struct iwl_priv *priv);
 extern void iwl_send_bt_config(struct iwl_priv *priv);
 extern int iwl_send_statistics_request(struct iwl_priv *priv,
 				       u8 flags, bool clear);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index f35bcad..3d9b656 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -47,6 +47,7 @@
 #include "iwl-led.h"
 #include "iwl-power.h"
 #include "iwl-agn-rs.h"
+#include "iwl-agn-tt.h"
 
 struct iwl_tx_queue;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index cda6a94..da1f2ae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -192,47 +192,6 @@ static void iwl_static_sleep_cmd(struct iwl_priv *priv,
 	IWL_DEBUG_POWER(priv, "Sleep command for index %d\n", lvl + 1);
 }
 
-/* default Thermal Throttling transaction table
- * Current state   |         Throttling Down               |  Throttling Up
- *=============================================================================
- *                 Condition Nxt State  Condition Nxt State Condition Nxt State
- *-----------------------------------------------------------------------------
- *     IWL_TI_0     T >= 114   CT_KILL  114>T>=105   TI_1      N/A      N/A
- *     IWL_TI_1     T >= 114   CT_KILL  114>T>=110   TI_2     T<=95     TI_0
- *     IWL_TI_2     T >= 114   CT_KILL                        T<=100    TI_1
- *    IWL_CT_KILL      N/A       N/A       N/A        N/A     T<=95     TI_0
- *=============================================================================
- */
-static const struct iwl_tt_trans tt_range_0[IWL_TI_STATE_MAX - 1] = {
-	{IWL_TI_0, IWL_ABSOLUTE_ZERO, 104},
-	{IWL_TI_1, 105, CT_KILL_THRESHOLD - 1},
-	{IWL_TI_CT_KILL, CT_KILL_THRESHOLD, IWL_ABSOLUTE_MAX}
-};
-static const struct iwl_tt_trans tt_range_1[IWL_TI_STATE_MAX - 1] = {
-	{IWL_TI_0, IWL_ABSOLUTE_ZERO, 95},
-	{IWL_TI_2, 110, CT_KILL_THRESHOLD - 1},
-	{IWL_TI_CT_KILL, CT_KILL_THRESHOLD, IWL_ABSOLUTE_MAX}
-};
-static const struct iwl_tt_trans tt_range_2[IWL_TI_STATE_MAX - 1] = {
-	{IWL_TI_1, IWL_ABSOLUTE_ZERO, 100},
-	{IWL_TI_CT_KILL, CT_KILL_THRESHOLD, IWL_ABSOLUTE_MAX},
-	{IWL_TI_CT_KILL, CT_KILL_THRESHOLD, IWL_ABSOLUTE_MAX}
-};
-static const struct iwl_tt_trans tt_range_3[IWL_TI_STATE_MAX - 1] = {
-	{IWL_TI_0, IWL_ABSOLUTE_ZERO, CT_KILL_EXIT_THRESHOLD},
-	{IWL_TI_CT_KILL, CT_KILL_EXIT_THRESHOLD + 1, IWL_ABSOLUTE_MAX},
-	{IWL_TI_CT_KILL, CT_KILL_EXIT_THRESHOLD + 1, IWL_ABSOLUTE_MAX}
-};
-
-/* Advance Thermal Throttling default restriction table */
-static const struct iwl_tt_restriction restriction_range[IWL_TI_STATE_MAX] = {
-	{IWL_ANT_OK_MULTI, IWL_ANT_OK_MULTI, true },
-	{IWL_ANT_OK_SINGLE, IWL_ANT_OK_MULTI, true },
-	{IWL_ANT_OK_SINGLE, IWL_ANT_OK_SINGLE, false },
-	{IWL_ANT_OK_NONE, IWL_ANT_OK_NONE, false }
-};
-
-
 static void iwl_power_sleep_cam_cmd(struct iwl_priv *priv,
 				    struct iwl_powertable_cmd *cmd)
 {
@@ -308,7 +267,6 @@ static int iwl_set_power(struct iwl_priv *priv, struct iwl_powertable_cmd *cmd)
 int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 {
 	int ret = 0;
-	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
 	bool enabled = priv->hw->conf.flags & IEEE80211_CONF_PS;
 	bool update_chains;
 	struct iwl_powertable_cmd cmd;
@@ -325,9 +283,15 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 	else if (priv->cfg->supports_idle &&
 		 priv->hw->conf.flags & IEEE80211_CONF_IDLE)
 		iwl_static_sleep_cmd(priv, &cmd, IWL_POWER_INDEX_5, 20);
-	else if (tt->state >= IWL_TI_1)
-		iwl_static_sleep_cmd(priv, &cmd, tt->tt_power_mode, dtimper);
-	else if (!enabled)
+	else if (priv->cfg->ops->lib->tt_ops.lower_power_detection &&
+		 priv->cfg->ops->lib->tt_ops.tt_power_mode) {
+		if (priv->cfg->ops->lib->tt_ops.lower_power_detection(priv)) {
+			/* in thermal throttling low power state */
+			iwl_static_sleep_cmd(priv, &cmd,
+			    priv->cfg->ops->lib->tt_ops.tt_power_mode(priv),
+			    dtimper);
+		}
+	} else if (!enabled)
 		iwl_power_sleep_cam_cmd(priv, &cmd);
 	else if (priv->power_data.debug_sleep_level_override >= 0)
 		iwl_static_sleep_cmd(priv, &cmd,
@@ -367,592 +331,6 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 }
 EXPORT_SYMBOL(iwl_power_update_mode);
 
-bool iwl_ht_enabled(struct iwl_priv *priv)
-{
-	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
-	struct iwl_tt_restriction *restriction;
-
-	if (!priv->thermal_throttle.advanced_tt)
-		return true;
-	restriction = tt->restriction + tt->state;
-	return restriction->is_ht;
-}
-EXPORT_SYMBOL(iwl_ht_enabled);
-
-bool iwl_within_ct_kill_margin(struct iwl_priv *priv)
-{
-	s32 temp = priv->temperature; /* degrees CELSIUS except specified */
-	bool within_margin = false;
-
-	if (priv->cfg->temperature_kelvin)
-		temp = KELVIN_TO_CELSIUS(priv->temperature);
-
-	if (!priv->thermal_throttle.advanced_tt)
-		within_margin = ((temp + IWL_TT_CT_KILL_MARGIN) >=
-				CT_KILL_THRESHOLD_LEGACY) ? true : false;
-	else
-		within_margin = ((temp + IWL_TT_CT_KILL_MARGIN) >=
-				CT_KILL_THRESHOLD) ? true : false;
-	return within_margin;
-}
-
-enum iwl_antenna_ok iwl_tx_ant_restriction(struct iwl_priv *priv)
-{
-	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
-	struct iwl_tt_restriction *restriction;
-
-	if (!priv->thermal_throttle.advanced_tt)
-		return IWL_ANT_OK_MULTI;
-	restriction = tt->restriction + tt->state;
-	return restriction->tx_stream;
-}
-EXPORT_SYMBOL(iwl_tx_ant_restriction);
-
-enum iwl_antenna_ok iwl_rx_ant_restriction(struct iwl_priv *priv)
-{
-	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
-	struct iwl_tt_restriction *restriction;
-
-	if (!priv->thermal_throttle.advanced_tt)
-		return IWL_ANT_OK_MULTI;
-	restriction = tt->restriction + tt->state;
-	return restriction->rx_stream;
-}
-
-#define CT_KILL_EXIT_DURATION (5)	/* 5 seconds duration */
-#define CT_KILL_WAITING_DURATION (300)	/* 300ms duration */
-
-/*
- * toggle the bit to wake up uCode and check the temperature
- * if the temperature is below CT, uCode will stay awake and send card
- * state notification with CT_KILL bit clear to inform Thermal Throttling
- * Management to change state. Otherwise, uCode will go back to sleep
- * without doing anything, driver should continue the 5 seconds timer
- * to wake up uCode for temperature check until temperature drop below CT
- */
-static void iwl_tt_check_exit_ct_kill(unsigned long data)
-{
-	struct iwl_priv *priv = (struct iwl_priv *)data;
-	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
-	unsigned long flags;
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
-	if (tt->state == IWL_TI_CT_KILL) {
-		if (priv->thermal_throttle.ct_kill_toggle) {
-			iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR,
-				    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
-			priv->thermal_throttle.ct_kill_toggle = false;
-		} else {
-			iwl_write32(priv, CSR_UCODE_DRV_GP1_SET,
-				    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
-			priv->thermal_throttle.ct_kill_toggle = true;
-		}
-		iwl_read32(priv, CSR_UCODE_DRV_GP1);
-		spin_lock_irqsave(&priv->reg_lock, flags);
-		if (!iwl_grab_nic_access(priv))
-			iwl_release_nic_access(priv);
-		spin_unlock_irqrestore(&priv->reg_lock, flags);
-
-		/* Reschedule the ct_kill timer to occur in
-		 * CT_KILL_EXIT_DURATION seconds to ensure we get a
-		 * thermal update */
-		IWL_DEBUG_POWER(priv, "schedule ct_kill exit timer\n");
-		mod_timer(&priv->thermal_throttle.ct_kill_exit_tm, jiffies +
-			  CT_KILL_EXIT_DURATION * HZ);
-	}
-}
-
-static void iwl_perform_ct_kill_task(struct iwl_priv *priv,
-			   bool stop)
-{
-	if (stop) {
-		IWL_DEBUG_POWER(priv, "Stop all queues\n");
-		if (priv->mac80211_registered)
-			ieee80211_stop_queues(priv->hw);
-		IWL_DEBUG_POWER(priv,
-				"Schedule 5 seconds CT_KILL Timer\n");
-		mod_timer(&priv->thermal_throttle.ct_kill_exit_tm, jiffies +
-			  CT_KILL_EXIT_DURATION * HZ);
-	} else {
-		IWL_DEBUG_POWER(priv, "Wake all queues\n");
-		if (priv->mac80211_registered)
-			ieee80211_wake_queues(priv->hw);
-	}
-}
-
-static void iwl_tt_ready_for_ct_kill(unsigned long data)
-{
-	struct iwl_priv *priv = (struct iwl_priv *)data;
-	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
-	/* temperature timer expired, ready to go into CT_KILL state */
-	if (tt->state != IWL_TI_CT_KILL) {
-		IWL_DEBUG_POWER(priv, "entering CT_KILL state when temperature timer expired\n");
-		tt->state = IWL_TI_CT_KILL;
-		set_bit(STATUS_CT_KILL, &priv->status);
-		iwl_perform_ct_kill_task(priv, true);
-	}
-}
-
-static void iwl_prepare_ct_kill_task(struct iwl_priv *priv)
-{
-	IWL_DEBUG_POWER(priv, "Prepare to enter IWL_TI_CT_KILL\n");
-	/* make request to retrieve statistics information */
-	iwl_send_statistics_request(priv, CMD_SYNC, false);
-	/* Reschedule the ct_kill wait timer */
-	mod_timer(&priv->thermal_throttle.ct_kill_waiting_tm,
-		 jiffies + msecs_to_jiffies(CT_KILL_WAITING_DURATION));
-}
-
-#define IWL_MINIMAL_POWER_THRESHOLD		(CT_KILL_THRESHOLD_LEGACY)
-#define IWL_REDUCED_PERFORMANCE_THRESHOLD_2	(100)
-#define IWL_REDUCED_PERFORMANCE_THRESHOLD_1	(90)
-
-/*
- * Legacy thermal throttling
- * 1) Avoid NIC destruction due to high temperatures
- *	Chip will identify dangerously high temperatures that can
- *	harm the device and will power down
- * 2) Avoid the NIC power down due to high temperature
- *	Throttle early enough to lower the power consumption before
- *	drastic steps are needed
- */
-static void iwl_legacy_tt_handler(struct iwl_priv *priv, s32 temp, bool force)
-{
-	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
-	enum iwl_tt_state old_state;
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if ((tt->tt_previous_temp) &&
-	    (temp > tt->tt_previous_temp) &&
-	    ((temp - tt->tt_previous_temp) >
-	    IWL_TT_INCREASE_MARGIN)) {
-		IWL_DEBUG_POWER(priv,
-			"Temperature increase %d degree Celsius\n",
-			(temp - tt->tt_previous_temp));
-	}
-#endif
-	old_state = tt->state;
-	/* in Celsius */
-	if (temp >= IWL_MINIMAL_POWER_THRESHOLD)
-		tt->state = IWL_TI_CT_KILL;
-	else if (temp >= IWL_REDUCED_PERFORMANCE_THRESHOLD_2)
-		tt->state = IWL_TI_2;
-	else if (temp >= IWL_REDUCED_PERFORMANCE_THRESHOLD_1)
-		tt->state = IWL_TI_1;
-	else
-		tt->state = IWL_TI_0;
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	tt->tt_previous_temp = temp;
-#endif
-	/* stop ct_kill_waiting_tm timer */
-	del_timer_sync(&priv->thermal_throttle.ct_kill_waiting_tm);
-	if (tt->state != old_state) {
-		switch (tt->state) {
-		case IWL_TI_0:
-			/*
-			 * When the system is ready to go back to IWL_TI_0
-			 * we only have to call iwl_power_update_mode() to
-			 * do so.
-			 */
-			break;
-		case IWL_TI_1:
-			tt->tt_power_mode = IWL_POWER_INDEX_3;
-			break;
-		case IWL_TI_2:
-			tt->tt_power_mode = IWL_POWER_INDEX_4;
-			break;
-		default:
-			tt->tt_power_mode = IWL_POWER_INDEX_5;
-			break;
-		}
-		mutex_lock(&priv->mutex);
-		if (old_state == IWL_TI_CT_KILL)
-			clear_bit(STATUS_CT_KILL, &priv->status);
-		if (tt->state != IWL_TI_CT_KILL &&
-		    iwl_power_update_mode(priv, true)) {
-			/* TT state not updated
-			 * try again during next temperature read
-			 */
-			if (old_state == IWL_TI_CT_KILL)
-				set_bit(STATUS_CT_KILL, &priv->status);
-			tt->state = old_state;
-			IWL_ERR(priv, "Cannot update power mode, "
-					"TT state not updated\n");
-		} else {
-			if (tt->state == IWL_TI_CT_KILL) {
-				if (force) {
-					set_bit(STATUS_CT_KILL, &priv->status);
-					iwl_perform_ct_kill_task(priv, true);
-				} else {
-					iwl_prepare_ct_kill_task(priv);
-					tt->state = old_state;
-				}
-			} else if (old_state == IWL_TI_CT_KILL &&
-				 tt->state != IWL_TI_CT_KILL)
-				iwl_perform_ct_kill_task(priv, false);
-			IWL_DEBUG_POWER(priv, "Temperature state changed %u\n",
-					tt->state);
-			IWL_DEBUG_POWER(priv, "Power Index change to %u\n",
-					tt->tt_power_mode);
-		}
-		mutex_unlock(&priv->mutex);
-	}
-}
-
-/*
- * Advance thermal throttling
- * 1) Avoid NIC destruction due to high temperatures
- *	Chip will identify dangerously high temperatures that can
- *	harm the device and will power down
- * 2) Avoid the NIC power down due to high temperature
- *	Throttle early enough to lower the power consumption before
- *	drastic steps are needed
- *	Actions include relaxing the power down sleep thresholds and
- *	decreasing the number of TX streams
- * 3) Avoid throughput performance impact as much as possible
- *
- *=============================================================================
- *                 Condition Nxt State  Condition Nxt State Condition Nxt State
- *-----------------------------------------------------------------------------
- *     IWL_TI_0     T >= 114   CT_KILL  114>T>=105   TI_1      N/A      N/A
- *     IWL_TI_1     T >= 114   CT_KILL  114>T>=110   TI_2     T<=95     TI_0
- *     IWL_TI_2     T >= 114   CT_KILL                        T<=100    TI_1
- *    IWL_CT_KILL      N/A       N/A       N/A        N/A     T<=95     TI_0
- *=============================================================================
- */
-static void iwl_advance_tt_handler(struct iwl_priv *priv, s32 temp, bool force)
-{
-	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
-	int i;
-	bool changed = false;
-	enum iwl_tt_state old_state;
-	struct iwl_tt_trans *transaction;
-
-	old_state = tt->state;
-	for (i = 0; i < IWL_TI_STATE_MAX - 1; i++) {
-		/* based on the current TT state,
-		 * find the curresponding transaction table
-		 * each table has (IWL_TI_STATE_MAX - 1) entries
-		 * tt->transaction + ((old_state * (IWL_TI_STATE_MAX - 1))
-		 * will advance to the correct table.
-		 * then based on the current temperature
-		 * find the next state need to transaction to
-		 * go through all the possible (IWL_TI_STATE_MAX - 1) entries
-		 * in the current table to see if transaction is needed
-		 */
-		transaction = tt->transaction +
-			((old_state * (IWL_TI_STATE_MAX - 1)) + i);
-		if (temp >= transaction->tt_low &&
-		    temp <= transaction->tt_high) {
-#ifdef CONFIG_IWLWIFI_DEBUG
-			if ((tt->tt_previous_temp) &&
-			    (temp > tt->tt_previous_temp) &&
-			    ((temp - tt->tt_previous_temp) >
-			    IWL_TT_INCREASE_MARGIN)) {
-				IWL_DEBUG_POWER(priv,
-					"Temperature increase %d "
-					"degree Celsius\n",
-					(temp - tt->tt_previous_temp));
-			}
-			tt->tt_previous_temp = temp;
-#endif
-			if (old_state !=
-			    transaction->next_state) {
-				changed = true;
-				tt->state =
-					transaction->next_state;
-			}
-			break;
-		}
-	}
-	/* stop ct_kill_waiting_tm timer */
-	del_timer_sync(&priv->thermal_throttle.ct_kill_waiting_tm);
-	if (changed) {
-		struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
-
-		if (tt->state >= IWL_TI_1) {
-			/* force PI = IWL_POWER_INDEX_5 in the case of TI > 0 */
-			tt->tt_power_mode = IWL_POWER_INDEX_5;
-			if (!iwl_ht_enabled(priv))
-				/* disable HT */
-				rxon->flags &= ~(RXON_FLG_CHANNEL_MODE_MSK |
-					RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK |
-					RXON_FLG_HT40_PROT_MSK |
-					RXON_FLG_HT_PROT_MSK);
-			else {
-				/* check HT capability and set
-				 * according to the system HT capability
-				 * in case get disabled before */
-				iwl_set_rxon_ht(priv, &priv->current_ht_config);
-			}
-
-		} else {
-			/*
-			 * restore system power setting -- it will be
-			 * recalculated automatically.
-			 */
-
-			/* check HT capability and set
-			 * according to the system HT capability
-			 * in case get disabled before */
-			iwl_set_rxon_ht(priv, &priv->current_ht_config);
-		}
-		mutex_lock(&priv->mutex);
-		if (old_state == IWL_TI_CT_KILL)
-			clear_bit(STATUS_CT_KILL, &priv->status);
-		if (tt->state != IWL_TI_CT_KILL &&
-		    iwl_power_update_mode(priv, true)) {
-			/* TT state not updated
-			 * try again during next temperature read
-			 */
-			IWL_ERR(priv, "Cannot update power mode, "
-					"TT state not updated\n");
-			if (old_state == IWL_TI_CT_KILL)
-				set_bit(STATUS_CT_KILL, &priv->status);
-			tt->state = old_state;
-		} else {
-			IWL_DEBUG_POWER(priv,
-					"Thermal Throttling to new state: %u\n",
-					tt->state);
-			if (old_state != IWL_TI_CT_KILL &&
-			    tt->state == IWL_TI_CT_KILL) {
-				if (force) {
-					IWL_DEBUG_POWER(priv,
-						"Enter IWL_TI_CT_KILL\n");
-					set_bit(STATUS_CT_KILL, &priv->status);
-					iwl_perform_ct_kill_task(priv, true);
-				} else {
-					iwl_prepare_ct_kill_task(priv);
-					tt->state = old_state;
-				}
-			} else if (old_state == IWL_TI_CT_KILL &&
-				  tt->state != IWL_TI_CT_KILL) {
-				IWL_DEBUG_POWER(priv, "Exit IWL_TI_CT_KILL\n");
-				iwl_perform_ct_kill_task(priv, false);
-			}
-		}
-		mutex_unlock(&priv->mutex);
-	}
-}
-
-/* Card State Notification indicated reach critical temperature
- * if PSP not enable, no Thermal Throttling function will be performed
- * just set the GP1 bit to acknowledge the event
- * otherwise, go into IWL_TI_CT_KILL state
- * since Card State Notification will not provide any temperature reading
- * for Legacy mode
- * so just pass the CT_KILL temperature to iwl_legacy_tt_handler()
- * for advance mode
- * pass CT_KILL_THRESHOLD+1 to make sure move into IWL_TI_CT_KILL state
- */
-static void iwl_bg_ct_enter(struct work_struct *work)
-{
-	struct iwl_priv *priv = container_of(work, struct iwl_priv, ct_enter);
-	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
-	if (!iwl_is_ready(priv))
-		return;
-
-	if (tt->state != IWL_TI_CT_KILL) {
-		IWL_ERR(priv, "Device reached critical temperature "
-			      "- ucode going to sleep!\n");
-		if (!priv->thermal_throttle.advanced_tt)
-			iwl_legacy_tt_handler(priv,
-					      IWL_MINIMAL_POWER_THRESHOLD,
-					      true);
-		else
-			iwl_advance_tt_handler(priv,
-					       CT_KILL_THRESHOLD + 1, true);
-	}
-}
-
-/* Card State Notification indicated out of critical temperature
- * since Card State Notification will not provide any temperature reading
- * so pass the IWL_REDUCED_PERFORMANCE_THRESHOLD_2 temperature
- * to iwl_legacy_tt_handler() to get out of IWL_CT_KILL state
- */
-static void iwl_bg_ct_exit(struct work_struct *work)
-{
-	struct iwl_priv *priv = container_of(work, struct iwl_priv, ct_exit);
-	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
-	if (!iwl_is_ready(priv))
-		return;
-
-	/* stop ct_kill_exit_tm timer */
-	del_timer_sync(&priv->thermal_throttle.ct_kill_exit_tm);
-
-	if (tt->state == IWL_TI_CT_KILL) {
-		IWL_ERR(priv,
-			"Device temperature below critical"
-			"- ucode awake!\n");
-		/*
-		 * exit from CT_KILL state
-		 * reset the current temperature reading
-		 */
-		priv->temperature = 0;
-		if (!priv->thermal_throttle.advanced_tt)
-			iwl_legacy_tt_handler(priv,
-					      IWL_REDUCED_PERFORMANCE_THRESHOLD_2,
-					      true);
-		else
-			iwl_advance_tt_handler(priv, CT_KILL_EXIT_THRESHOLD,
-					       true);
-	}
-}
-
-void iwl_tt_enter_ct_kill(struct iwl_priv *priv)
-{
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
-	IWL_DEBUG_POWER(priv, "Queueing critical temperature enter.\n");
-	queue_work(priv->workqueue, &priv->ct_enter);
-}
-EXPORT_SYMBOL(iwl_tt_enter_ct_kill);
-
-void iwl_tt_exit_ct_kill(struct iwl_priv *priv)
-{
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
-	IWL_DEBUG_POWER(priv, "Queueing critical temperature exit.\n");
-	queue_work(priv->workqueue, &priv->ct_exit);
-}
-EXPORT_SYMBOL(iwl_tt_exit_ct_kill);
-
-static void iwl_bg_tt_work(struct work_struct *work)
-{
-	struct iwl_priv *priv = container_of(work, struct iwl_priv, tt_work);
-	s32 temp = priv->temperature; /* degrees CELSIUS except specified */
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
-	if (priv->cfg->temperature_kelvin)
-		temp = KELVIN_TO_CELSIUS(priv->temperature);
-
-	if (!priv->thermal_throttle.advanced_tt)
-		iwl_legacy_tt_handler(priv, temp, false);
-	else
-		iwl_advance_tt_handler(priv, temp, false);
-}
-
-void iwl_tt_handler(struct iwl_priv *priv)
-{
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
-	IWL_DEBUG_POWER(priv, "Queueing thermal throttling work.\n");
-	queue_work(priv->workqueue, &priv->tt_work);
-}
-EXPORT_SYMBOL(iwl_tt_handler);
-
-/* Thermal throttling initialization
- * For advance thermal throttling:
- *     Initialize Thermal Index and temperature threshold table
- *     Initialize thermal throttling restriction table
- */
-void iwl_tt_initialize(struct iwl_priv *priv)
-{
-	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
-	int size = sizeof(struct iwl_tt_trans) * (IWL_TI_STATE_MAX - 1);
-	struct iwl_tt_trans *transaction;
-
-	IWL_DEBUG_POWER(priv, "Initialize Thermal Throttling\n");
-
-	memset(tt, 0, sizeof(struct iwl_tt_mgmt));
-
-	tt->state = IWL_TI_0;
-	init_timer(&priv->thermal_throttle.ct_kill_exit_tm);
-	priv->thermal_throttle.ct_kill_exit_tm.data = (unsigned long)priv;
-	priv->thermal_throttle.ct_kill_exit_tm.function =
-		iwl_tt_check_exit_ct_kill;
-	init_timer(&priv->thermal_throttle.ct_kill_waiting_tm);
-	priv->thermal_throttle.ct_kill_waiting_tm.data = (unsigned long)priv;
-	priv->thermal_throttle.ct_kill_waiting_tm.function =
-		iwl_tt_ready_for_ct_kill;
-	/* setup deferred ct kill work */
-	INIT_WORK(&priv->tt_work, iwl_bg_tt_work);
-	INIT_WORK(&priv->ct_enter, iwl_bg_ct_enter);
-	INIT_WORK(&priv->ct_exit, iwl_bg_ct_exit);
-
-	if (priv->cfg->adv_thermal_throttle) {
-		IWL_DEBUG_POWER(priv, "Advanced Thermal Throttling\n");
-		tt->restriction = kzalloc(sizeof(struct iwl_tt_restriction) *
-					 IWL_TI_STATE_MAX, GFP_KERNEL);
-		tt->transaction = kzalloc(sizeof(struct iwl_tt_trans) *
-			IWL_TI_STATE_MAX * (IWL_TI_STATE_MAX - 1),
-			GFP_KERNEL);
-		if (!tt->restriction || !tt->transaction) {
-			IWL_ERR(priv, "Fallback to Legacy Throttling\n");
-			priv->thermal_throttle.advanced_tt = false;
-			kfree(tt->restriction);
-			tt->restriction = NULL;
-			kfree(tt->transaction);
-			tt->transaction = NULL;
-		} else {
-			transaction = tt->transaction +
-				(IWL_TI_0 * (IWL_TI_STATE_MAX - 1));
-			memcpy(transaction, &tt_range_0[0], size);
-			transaction = tt->transaction +
-				(IWL_TI_1 * (IWL_TI_STATE_MAX - 1));
-			memcpy(transaction, &tt_range_1[0], size);
-			transaction = tt->transaction +
-				(IWL_TI_2 * (IWL_TI_STATE_MAX - 1));
-			memcpy(transaction, &tt_range_2[0], size);
-			transaction = tt->transaction +
-				(IWL_TI_CT_KILL * (IWL_TI_STATE_MAX - 1));
-			memcpy(transaction, &tt_range_3[0], size);
-			size = sizeof(struct iwl_tt_restriction) *
-				IWL_TI_STATE_MAX;
-			memcpy(tt->restriction,
-				&restriction_range[0], size);
-			priv->thermal_throttle.advanced_tt = true;
-		}
-	} else {
-		IWL_DEBUG_POWER(priv, "Legacy Thermal Throttling\n");
-		priv->thermal_throttle.advanced_tt = false;
-	}
-}
-EXPORT_SYMBOL(iwl_tt_initialize);
-
-/* cleanup thermal throttling management related memory and timer */
-void iwl_tt_exit(struct iwl_priv *priv)
-{
-	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
-
-	/* stop ct_kill_exit_tm timer if activated */
-	del_timer_sync(&priv->thermal_throttle.ct_kill_exit_tm);
-	/* stop ct_kill_waiting_tm timer if activated */
-	del_timer_sync(&priv->thermal_throttle.ct_kill_waiting_tm);
-	cancel_work_sync(&priv->tt_work);
-	cancel_work_sync(&priv->ct_enter);
-	cancel_work_sync(&priv->ct_exit);
-
-	if (priv->thermal_throttle.advanced_tt) {
-		/* free advance thermal throttling memory */
-		kfree(tt->restriction);
-		tt->restriction = NULL;
-		kfree(tt->transaction);
-		tt->transaction = NULL;
-	}
-}
-EXPORT_SYMBOL(iwl_tt_exit);
-
 /* initialize to default */
 void iwl_power_initialize(struct iwl_priv *priv)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.h b/drivers/net/wireless/iwlwifi/iwl-power.h
index 5db91c1..df81565 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.h
+++ b/drivers/net/wireless/iwlwifi/iwl-power.h
@@ -30,90 +30,6 @@
 
 #include "iwl-commands.h"
 
-#define IWL_ABSOLUTE_ZERO		0
-#define IWL_ABSOLUTE_MAX		0xFFFFFFFF
-#define IWL_TT_INCREASE_MARGIN	5
-#define IWL_TT_CT_KILL_MARGIN	3
-
-enum iwl_antenna_ok {
-	IWL_ANT_OK_NONE,
-	IWL_ANT_OK_SINGLE,
-	IWL_ANT_OK_MULTI,
-};
-
-/* Thermal Throttling State Machine states */
-enum  iwl_tt_state {
-	IWL_TI_0,	/* normal temperature, system power state */
-	IWL_TI_1,	/* high temperature detect, low power state */
-	IWL_TI_2,	/* higher temperature detected, lower power state */
-	IWL_TI_CT_KILL, /* critical temperature detected, lowest power state */
-	IWL_TI_STATE_MAX
-};
-
-/**
- * struct iwl_tt_restriction - Thermal Throttling restriction table
- * @tx_stream: number of tx stream allowed
- * @is_ht: ht enable/disable
- * @rx_stream: number of rx stream allowed
- *
- * This table is used by advance thermal throttling management
- * based on the current thermal throttling state, and determines
- * the number of tx/rx streams and the status of HT operation.
- */
-struct iwl_tt_restriction {
-	enum iwl_antenna_ok tx_stream;
-	enum iwl_antenna_ok rx_stream;
-	bool is_ht;
-};
-
-/**
- * struct iwl_tt_trans - Thermal Throttling transaction table
- * @next_state:  next thermal throttling mode
- * @tt_low: low temperature threshold to change state
- * @tt_high: high temperature threshold to change state
- *
- * This is used by the advanced thermal throttling algorithm
- * to determine the next thermal state to go based on the
- * current temperature.
- */
-struct iwl_tt_trans {
-	enum iwl_tt_state next_state;
-	u32 tt_low;
-	u32 tt_high;
-};
-
-/**
- * struct iwl_tt_mgnt - Thermal Throttling Management structure
- * @advanced_tt:    advanced thermal throttle required
- * @state:          current Thermal Throttling state
- * @tt_power_mode:  Thermal Throttling power mode index
- *		    being used to set power level when
- * 		    when thermal throttling state != IWL_TI_0
- *		    the tt_power_mode should set to different
- *		    power mode based on the current tt state
- * @tt_previous_temperature: last measured temperature
- * @iwl_tt_restriction: ptr to restriction tbl, used by advance
- *		    thermal throttling to determine how many tx/rx streams
- *		    should be used in tt state; and can HT be enabled or not
- * @iwl_tt_trans: ptr to adv trans table, used by advance thermal throttling
- *		    state transaction
- * @ct_kill_toggle: used to toggle the CSR bit when checking uCode temperature
- * @ct_kill_exit_tm: timer to exit thermal kill
- */
-struct iwl_tt_mgmt {
-	enum iwl_tt_state state;
-	bool advanced_tt;
-	u8 tt_power_mode;
-	bool ct_kill_toggle;
-#ifdef CONFIG_IWLWIFI_DEBUG
-	s32 tt_previous_temp;
-#endif
-	struct iwl_tt_restriction *restriction;
-	struct iwl_tt_trans *transaction;
-	struct timer_list ct_kill_exit_tm;
-	struct timer_list ct_kill_waiting_tm;
-};
-
 enum iwl_power_level {
 	IWL_POWER_INDEX_1,
 	IWL_POWER_INDEX_2,
@@ -130,15 +46,6 @@ struct iwl_power_mgr {
 };
 
 int iwl_power_update_mode(struct iwl_priv *priv, bool force);
-bool iwl_ht_enabled(struct iwl_priv *priv);
-bool iwl_within_ct_kill_margin(struct iwl_priv *priv);
-enum iwl_antenna_ok iwl_tx_ant_restriction(struct iwl_priv *priv);
-enum iwl_antenna_ok iwl_rx_ant_restriction(struct iwl_priv *priv);
-void iwl_tt_enter_ct_kill(struct iwl_priv *priv);
-void iwl_tt_exit_ct_kill(struct iwl_priv *priv);
-void iwl_tt_handler(struct iwl_priv *priv);
-void iwl_tt_initialize(struct iwl_priv *priv);
-void iwl_tt_exit(struct iwl_priv *priv);
 void iwl_power_initialize(struct iwl_priv *priv);
 
 extern bool no_sleep_autoadjust;
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index a81989c..c308dab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -422,6 +422,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	int len;
 	u32 idx;
 	u16 fix_size;
+	bool is_ct_kill = false;
 
 	cmd->len = priv->cfg->ops->utils->get_hcmd_size(cmd->id, cmd->len);
 	fix_size = (u16)(cmd->len + sizeof(out_cmd->hdr));
@@ -443,9 +444,11 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 
 	if (iwl_queue_space(q) < ((cmd->flags & CMD_ASYNC) ? 2 : 1)) {
 		IWL_ERR(priv, "No space in command queue\n");
-		if (iwl_within_ct_kill_margin(priv))
-			iwl_tt_enter_ct_kill(priv);
-		else {
+		if (priv->cfg->ops->lib->tt_ops.ct_kill_check) {
+			is_ct_kill =
+				priv->cfg->ops->lib->tt_ops.ct_kill_check(priv);
+		}
+		if (!is_ct_kill) {
 			IWL_ERR(priv, "Restarting adapter due to queue full\n");
 			queue_work(priv->workqueue, &priv->restart);
 		}
-- 
1.7.0.4

