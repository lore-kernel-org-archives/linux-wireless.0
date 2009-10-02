Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:60581 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758196AbZJBUtu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 16:49:50 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/13] iwlwifi: reliable entering of critical temperature state
Date: Fri,  2 Oct 2009 13:43:58 -0700
Message-Id: <1254516247-4085-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1254516247-4085-1-git-send-email-reinette.chatre@intel.com>
References: <1254516247-4085-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

When uCode detects critical temperature it should send "card state
notification" interrupt to driver and then shut itself down to prevent
overheating. There is a race condition where uCode shuts down before it
can deliver the interrupt to driver.
Additional method provided here for driver to enter CT_KILL state based
on temperature reading.

How it works:
Method 1:
If driver receive "card state notification" interrupt from uCode; it
enters "CT_KILL" state immediately

Method 2:
If the last temperature report by Card reach Critical temperature,
driver will send "statistic notification" request to uCode to verify the
temperature reading, if driver can not get reply from uCode within
300ms, driver will enter CT_KILL state automatically.

Method 3:
If the last temperature report by Card did not reach Critical
temperature, but uCode already shut down due to critical temperature.
All the host commands send to uCode will not get process by uCode;
when command queue reach the limit, driver will check the last reported
temperature reading, if it is within pre-defined margin, enter "CT_KILL"
state immediately. In this case, when uCode ready to exit from "CT_KILL" state,
driver need to restart the adapter in order to reset all the queues and
resume normal operation.

One additional issue being address here, when system is in CT_KILL
state, both tx and rx already stopped, but driver still can send host
command to uCode, it will flood the command queue since card was not
responding; adding STATUS_CT_KILL flag to reject enqueue host commands
to uCode if it is in CT_KILL state, when uCode is ready to come out of
CT_KILL, driver will clear  the STATUS_CT_KILL bit and allow enqueue the host
commands to uCode to recover from CT_KILL state.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.h    |    6 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    2 +
 drivers/net/wireless/iwlwifi/iwl-power.c   |  146 ++++++++++++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-power.h   |    3 +
 drivers/net/wireless/iwlwifi/iwl-tx.c      |   10 ++-
 5 files changed, 135 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 744f0ca..3bd0e59 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -580,6 +580,7 @@ void iwlcore_free_geos(struct iwl_priv *priv);
 #define STATUS_HCMD_SYNC_ACTIVE	1	/* sync host command in progress */
 #define STATUS_INT_ENABLED	2
 #define STATUS_RF_KILL_HW	3
+#define STATUS_CT_KILL		4
 #define STATUS_INIT		5
 #define STATUS_ALIVE		6
 #define STATUS_READY		7
@@ -624,6 +625,11 @@ static inline int iwl_is_rfkill(struct iwl_priv *priv)
 	return iwl_is_rfkill_hw(priv);
 }
 
+static inline int iwl_is_ctkill(struct iwl_priv *priv)
+{
+	return test_bit(STATUS_CT_KILL, &priv->status);
+}
+
 static inline int iwl_is_ready_rf(struct iwl_priv *priv)
 {
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 037b75c..fa6371d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -535,6 +535,8 @@ static ssize_t iwl_dbgfs_status_read(struct file *file,
 		test_bit(STATUS_INT_ENABLED, &priv->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_RF_KILL_HW:\t %d\n",
 		test_bit(STATUS_RF_KILL_HW, &priv->status));
+	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_CT_KILL:\t\t %d\n",
+		test_bit(STATUS_CT_KILL, &priv->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_INIT:\t\t %d\n",
 		test_bit(STATUS_INIT, &priv->status));
 	pos += scnprintf(buf + pos, bufsz - pos, "STATUS_ALIVE:\t\t %d\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index e50d77b..9c6b149 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -165,26 +165,26 @@ static void iwl_static_sleep_cmd(struct iwl_priv *priv,
  *=============================================================================
  *                 Condition Nxt State  Condition Nxt State Condition Nxt State
  *-----------------------------------------------------------------------------
- *     IWL_TI_0     T >= 115   CT_KILL  115>T>=105   TI_1      N/A      N/A
- *     IWL_TI_1     T >= 115   CT_KILL  115>T>=110   TI_2     T<=95     TI_0
- *     IWL_TI_2     T >= 115   CT_KILL                        T<=100    TI_1
+ *     IWL_TI_0     T >= 114   CT_KILL  114>T>=105   TI_1      N/A      N/A
+ *     IWL_TI_1     T >= 114   CT_KILL  114>T>=110   TI_2     T<=95     TI_0
+ *     IWL_TI_2     T >= 114   CT_KILL                        T<=100    TI_1
  *    IWL_CT_KILL      N/A       N/A       N/A        N/A     T<=95     TI_0
  *=============================================================================
  */
 static const struct iwl_tt_trans tt_range_0[IWL_TI_STATE_MAX - 1] = {
 	{IWL_TI_0, IWL_ABSOLUTE_ZERO, 104},
-	{IWL_TI_1, 105, CT_KILL_THRESHOLD},
-	{IWL_TI_CT_KILL, CT_KILL_THRESHOLD + 1, IWL_ABSOLUTE_MAX}
+	{IWL_TI_1, 105, CT_KILL_THRESHOLD - 1},
+	{IWL_TI_CT_KILL, CT_KILL_THRESHOLD, IWL_ABSOLUTE_MAX}
 };
 static const struct iwl_tt_trans tt_range_1[IWL_TI_STATE_MAX - 1] = {
 	{IWL_TI_0, IWL_ABSOLUTE_ZERO, 95},
-	{IWL_TI_2, 110, CT_KILL_THRESHOLD},
-	{IWL_TI_CT_KILL, CT_KILL_THRESHOLD + 1, IWL_ABSOLUTE_MAX}
+	{IWL_TI_2, 110, CT_KILL_THRESHOLD - 1},
+	{IWL_TI_CT_KILL, CT_KILL_THRESHOLD, IWL_ABSOLUTE_MAX}
 };
 static const struct iwl_tt_trans tt_range_2[IWL_TI_STATE_MAX - 1] = {
 	{IWL_TI_1, IWL_ABSOLUTE_ZERO, 100},
-	{IWL_TI_CT_KILL, CT_KILL_THRESHOLD + 1, IWL_ABSOLUTE_MAX},
-	{IWL_TI_CT_KILL, CT_KILL_THRESHOLD + 1, IWL_ABSOLUTE_MAX}
+	{IWL_TI_CT_KILL, CT_KILL_THRESHOLD, IWL_ABSOLUTE_MAX},
+	{IWL_TI_CT_KILL, CT_KILL_THRESHOLD, IWL_ABSOLUTE_MAX}
 };
 static const struct iwl_tt_trans tt_range_3[IWL_TI_STATE_MAX - 1] = {
 	{IWL_TI_0, IWL_ABSOLUTE_ZERO, CT_KILL_EXIT_THRESHOLD},
@@ -351,6 +351,23 @@ bool iwl_ht_enabled(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_ht_enabled);
 
+bool iwl_within_ct_kill_margin(struct iwl_priv *priv)
+{
+	s32 temp = priv->temperature; /* degrees CELSIUS except 4965 */
+	bool within_margin = false;
+
+	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) == CSR_HW_REV_TYPE_4965)
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
 enum iwl_antenna_ok iwl_tx_ant_restriction(struct iwl_priv *priv)
 {
 	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
@@ -375,6 +392,7 @@ enum iwl_antenna_ok iwl_rx_ant_restriction(struct iwl_priv *priv)
 }
 
 #define CT_KILL_EXIT_DURATION (5)	/* 5 seconds duration */
+#define CT_KILL_WAITING_DURATION (300)	/* 300ms duration */
 
 /*
  * toggle the bit to wake up uCode and check the temperature
@@ -412,6 +430,7 @@ static void iwl_tt_check_exit_ct_kill(unsigned long data)
 		/* Reschedule the ct_kill timer to occur in
 		 * CT_KILL_EXIT_DURATION seconds to ensure we get a
 		 * thermal update */
+		IWL_DEBUG_POWER(priv, "schedule ct_kill exit timer\n");
 		mod_timer(&priv->thermal_throttle.ct_kill_exit_tm, jiffies +
 			  CT_KILL_EXIT_DURATION * HZ);
 	}
@@ -435,6 +454,33 @@ static void iwl_perform_ct_kill_task(struct iwl_priv *priv,
 	}
 }
 
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
+		IWL_DEBUG_POWER(priv, "entering CT_KILL state when temperature timer expired\n");
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
+	iwl_send_statistics_request(priv, 0);
+	/* Reschedule the ct_kill wait timer */
+	mod_timer(&priv->thermal_throttle.ct_kill_waiting_tm,
+		 jiffies + msecs_to_jiffies(CT_KILL_WAITING_DURATION));
+}
+
 #define IWL_MINIMAL_POWER_THRESHOLD		(CT_KILL_THRESHOLD_LEGACY)
 #define IWL_REDUCED_PERFORMANCE_THRESHOLD_2	(100)
 #define IWL_REDUCED_PERFORMANCE_THRESHOLD_1	(90)
@@ -448,7 +494,7 @@ static void iwl_perform_ct_kill_task(struct iwl_priv *priv,
  *	Throttle early enough to lower the power consumption before
  *	drastic steps are needed
  */
-static void iwl_legacy_tt_handler(struct iwl_priv *priv, s32 temp)
+static void iwl_legacy_tt_handler(struct iwl_priv *priv, s32 temp, bool force)
 {
 	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
 	enum iwl_tt_state old_state;
@@ -477,6 +523,8 @@ static void iwl_legacy_tt_handler(struct iwl_priv *priv, s32 temp)
 #ifdef CONFIG_IWLWIFI_DEBUG
 	tt->tt_previous_temp = temp;
 #endif
+	/* stop ct_kill_waiting_tm timer */
+	del_timer_sync(&priv->thermal_throttle.ct_kill_waiting_tm);
 	if (tt->state != old_state) {
 		switch (tt->state) {
 		case IWL_TI_0:
@@ -497,17 +545,28 @@ static void iwl_legacy_tt_handler(struct iwl_priv *priv, s32 temp)
 			break;
 		}
 		mutex_lock(&priv->mutex);
-		if (iwl_power_update_mode(priv, true)) {
+		if (old_state == IWL_TI_CT_KILL)
+			clear_bit(STATUS_CT_KILL, &priv->status);
+		if (tt->state != IWL_TI_CT_KILL &&
+		    iwl_power_update_mode(priv, true)) {
 			/* TT state not updated
 			 * try again during next temperature read
 			 */
+			if (old_state == IWL_TI_CT_KILL)
+				set_bit(STATUS_CT_KILL, &priv->status);
 			tt->state = old_state;
 			IWL_ERR(priv, "Cannot update power mode, "
 					"TT state not updated\n");
 		} else {
-			if (tt->state == IWL_TI_CT_KILL)
-				iwl_perform_ct_kill_task(priv, true);
-			else if (old_state == IWL_TI_CT_KILL &&
+			if (tt->state == IWL_TI_CT_KILL) {
+				if (force) {
+					set_bit(STATUS_CT_KILL, &priv->status);
+					iwl_perform_ct_kill_task(priv, true);
+				} else {
+					iwl_prepare_ct_kill_task(priv);
+					tt->state = old_state;
+				}
+			} else if (old_state == IWL_TI_CT_KILL &&
 				 tt->state != IWL_TI_CT_KILL)
 				iwl_perform_ct_kill_task(priv, false);
 			IWL_DEBUG_POWER(priv, "Temperature state changed %u\n",
@@ -534,13 +593,13 @@ static void iwl_legacy_tt_handler(struct iwl_priv *priv, s32 temp)
  *=============================================================================
  *                 Condition Nxt State  Condition Nxt State Condition Nxt State
  *-----------------------------------------------------------------------------
- *     IWL_TI_0     T >= 115   CT_KILL  115>T>=105   TI_1      N/A      N/A
- *     IWL_TI_1     T >= 115   CT_KILL  115>T>=110   TI_2     T<=95     TI_0
- *     IWL_TI_2     T >= 115   CT_KILL                        T<=100    TI_1
+ *     IWL_TI_0     T >= 114   CT_KILL  114>T>=105   TI_1      N/A      N/A
+ *     IWL_TI_1     T >= 114   CT_KILL  114>T>=110   TI_2     T<=95     TI_0
+ *     IWL_TI_2     T >= 114   CT_KILL                        T<=100    TI_1
  *    IWL_CT_KILL      N/A       N/A       N/A        N/A     T<=95     TI_0
  *=============================================================================
  */
-static void iwl_advance_tt_handler(struct iwl_priv *priv, s32 temp)
+static void iwl_advance_tt_handler(struct iwl_priv *priv, s32 temp, bool force)
 {
 	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
 	int i;
@@ -585,6 +644,8 @@ static void iwl_advance_tt_handler(struct iwl_priv *priv, s32 temp)
 			break;
 		}
 	}
+	/* stop ct_kill_waiting_tm timer */
+	del_timer_sync(&priv->thermal_throttle.ct_kill_waiting_tm);
 	if (changed) {
 		struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
 
@@ -616,12 +677,17 @@ static void iwl_advance_tt_handler(struct iwl_priv *priv, s32 temp)
 			iwl_set_rxon_ht(priv, &priv->current_ht_config);
 		}
 		mutex_lock(&priv->mutex);
-		if (iwl_power_update_mode(priv, true)) {
+		if (old_state == IWL_TI_CT_KILL)
+			clear_bit(STATUS_CT_KILL, &priv->status);
+		if (tt->state != IWL_TI_CT_KILL &&
+		    iwl_power_update_mode(priv, true)) {
 			/* TT state not updated
 			 * try again during next temperature read
 			 */
 			IWL_ERR(priv, "Cannot update power mode, "
 					"TT state not updated\n");
+			if (old_state == IWL_TI_CT_KILL)
+				set_bit(STATUS_CT_KILL, &priv->status);
 			tt->state = old_state;
 		} else {
 			IWL_DEBUG_POWER(priv,
@@ -629,9 +695,15 @@ static void iwl_advance_tt_handler(struct iwl_priv *priv, s32 temp)
 					tt->state);
 			if (old_state != IWL_TI_CT_KILL &&
 			    tt->state == IWL_TI_CT_KILL) {
-				IWL_DEBUG_POWER(priv, "Enter IWL_TI_CT_KILL\n");
-				iwl_perform_ct_kill_task(priv, true);
-
+				if (force) {
+					IWL_DEBUG_POWER(priv,
+						"Enter IWL_TI_CT_KILL\n");
+					set_bit(STATUS_CT_KILL, &priv->status);
+					iwl_perform_ct_kill_task(priv, true);
+				} else {
+					iwl_prepare_ct_kill_task(priv);
+					tt->state = old_state;
+				}
 			} else if (old_state == IWL_TI_CT_KILL &&
 				  tt->state != IWL_TI_CT_KILL) {
 				IWL_DEBUG_POWER(priv, "Exit IWL_TI_CT_KILL\n");
@@ -668,10 +740,11 @@ static void iwl_bg_ct_enter(struct work_struct *work)
 			      "- ucode going to sleep!\n");
 		if (!priv->thermal_throttle.advanced_tt)
 			iwl_legacy_tt_handler(priv,
-					      IWL_MINIMAL_POWER_THRESHOLD);
+					      IWL_MINIMAL_POWER_THRESHOLD,
+					      true);
 		else
 			iwl_advance_tt_handler(priv,
-					       CT_KILL_THRESHOLD + 1);
+					       CT_KILL_THRESHOLD + 1, true);
 	}
 }
 
@@ -698,11 +771,18 @@ static void iwl_bg_ct_exit(struct work_struct *work)
 		IWL_ERR(priv,
 			"Device temperature below critical"
 			"- ucode awake!\n");
+		/*
+		 * exit from CT_KILL state
+		 * reset the current temperature reading
+		 */
+		priv->temperature = 0;
 		if (!priv->thermal_throttle.advanced_tt)
 			iwl_legacy_tt_handler(priv,
-					IWL_REDUCED_PERFORMANCE_THRESHOLD_2);
+					      IWL_REDUCED_PERFORMANCE_THRESHOLD_2,
+					      true);
 		else
-			iwl_advance_tt_handler(priv, CT_KILL_EXIT_THRESHOLD);
+			iwl_advance_tt_handler(priv, CT_KILL_EXIT_THRESHOLD,
+					       true);
 	}
 }
 
@@ -738,9 +818,9 @@ static void iwl_bg_tt_work(struct work_struct *work)
 		temp = KELVIN_TO_CELSIUS(priv->temperature);
 
 	if (!priv->thermal_throttle.advanced_tt)
-		iwl_legacy_tt_handler(priv, temp);
+		iwl_legacy_tt_handler(priv, temp, false);
 	else
-		iwl_advance_tt_handler(priv, temp);
+		iwl_advance_tt_handler(priv, temp, false);
 }
 
 void iwl_tt_handler(struct iwl_priv *priv)
@@ -771,8 +851,12 @@ void iwl_tt_initialize(struct iwl_priv *priv)
 	tt->state = IWL_TI_0;
 	init_timer(&priv->thermal_throttle.ct_kill_exit_tm);
 	priv->thermal_throttle.ct_kill_exit_tm.data = (unsigned long)priv;
-	priv->thermal_throttle.ct_kill_exit_tm.function = iwl_tt_check_exit_ct_kill;
-
+	priv->thermal_throttle.ct_kill_exit_tm.function =
+		iwl_tt_check_exit_ct_kill;
+	init_timer(&priv->thermal_throttle.ct_kill_waiting_tm);
+	priv->thermal_throttle.ct_kill_waiting_tm.data = (unsigned long)priv;
+	priv->thermal_throttle.ct_kill_waiting_tm.function =
+		iwl_tt_ready_for_ct_kill;
 	/* setup deferred ct kill work */
 	INIT_WORK(&priv->tt_work, iwl_bg_tt_work);
 	INIT_WORK(&priv->ct_enter, iwl_bg_ct_enter);
@@ -829,6 +913,8 @@ void iwl_tt_exit(struct iwl_priv *priv)
 
 	/* stop ct_kill_exit_tm timer if activated */
 	del_timer_sync(&priv->thermal_throttle.ct_kill_exit_tm);
+	/* stop ct_kill_waiting_tm timer if activated */
+	del_timer_sync(&priv->thermal_throttle.ct_kill_waiting_tm);
 	cancel_work_sync(&priv->tt_work);
 	cancel_work_sync(&priv->ct_enter);
 	cancel_work_sync(&priv->ct_exit);
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.h b/drivers/net/wireless/iwlwifi/iwl-power.h
index df6f6a4..310c32e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.h
+++ b/drivers/net/wireless/iwlwifi/iwl-power.h
@@ -33,6 +33,7 @@
 #define IWL_ABSOLUTE_ZERO		0
 #define IWL_ABSOLUTE_MAX		0xFFFFFFFF
 #define IWL_TT_INCREASE_MARGIN	5
+#define IWL_TT_CT_KILL_MARGIN	3
 
 enum iwl_antenna_ok {
 	IWL_ANT_OK_NONE,
@@ -110,6 +111,7 @@ struct iwl_tt_mgmt {
 	struct iwl_tt_restriction *restriction;
 	struct iwl_tt_trans *transaction;
 	struct timer_list ct_kill_exit_tm;
+	struct timer_list ct_kill_waiting_tm;
 };
 
 enum iwl_power_level {
@@ -129,6 +131,7 @@ struct iwl_power_mgr {
 
 int iwl_power_update_mode(struct iwl_priv *priv, bool force);
 bool iwl_ht_enabled(struct iwl_priv *priv);
+bool iwl_within_ct_kill_margin(struct iwl_priv *priv);
 enum iwl_antenna_ok iwl_tx_ant_restriction(struct iwl_priv *priv);
 enum iwl_antenna_ok iwl_rx_ant_restriction(struct iwl_priv *priv);
 void iwl_tt_enter_ct_kill(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index ad69479..2ba9725 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -969,13 +969,19 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	BUG_ON((fix_size > TFD_MAX_PAYLOAD_SIZE) &&
 	       !(cmd->flags & CMD_SIZE_HUGE));
 
-	if (iwl_is_rfkill(priv)) {
-		IWL_DEBUG_INFO(priv, "Not sending command - RF KILL\n");
+	if (iwl_is_rfkill(priv) || iwl_is_ctkill(priv)) {
+		IWL_DEBUG_INFO(priv, "Not sending command - RF/CT KILL\n");
 		return -EIO;
 	}
 
 	if (iwl_queue_space(q) < ((cmd->flags & CMD_ASYNC) ? 2 : 1)) {
 		IWL_ERR(priv, "No space for Tx\n");
+		if (iwl_within_ct_kill_margin(priv))
+			iwl_tt_enter_ct_kill(priv);
+		else {
+			IWL_ERR(priv, "Restarting adapter due to queue full\n");
+			queue_work(priv->workqueue, &priv->restart);
+		}
 		return -ENOSPC;
 	}
 
-- 
1.5.6.3

