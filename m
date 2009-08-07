Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:1415 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbZHGWl6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 18:41:58 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 12/16] iwlwifi: refactor some thermal throttle code
Date: Fri,  7 Aug 2009 15:41:48 -0700
Message-Id: <1249684912-22936-13-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
References: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

Some of the thermal throttle data structures and code
are really very intermingled with the sleep (power)
control code. They really do belong together in a way
since the thermal throttle code uses powersaving to
achieve its goal, but it's making it hard to work on
the powersave code. Split this up to make that easier.
I've also changed the antenna defines to an enum and
used the same enum for RX and TX.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c  |   14 +++---
 drivers/net/wireless/iwlwifi/iwl-core.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    7 +--
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-power.c   |   78 ++++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-power.h   |   50 +++++++++---------
 6 files changed, 76 insertions(+), 76 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 0c3ed23..2133155 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -1401,7 +1401,7 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 	if (!iwl_ht_enabled(priv))
 		/* stay in Legacy */
 		tbl->action = IWL_LEGACY_SWITCH_ANTENNA1;
-	else if (iwl_tx_ant_restriction(priv) == IWL_TX_SINGLE &&
+	else if (iwl_tx_ant_restriction(priv) == IWL_ANT_OK_SINGLE &&
 		   tbl->action > IWL_LEGACY_SWITCH_SISO)
 		tbl->action = IWL_LEGACY_SWITCH_SISO;
 	for (; ;) {
@@ -1535,7 +1535,7 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 	u8 update_search_tbl_counter = 0;
 	int ret;
 
-	if (iwl_tx_ant_restriction(priv) == IWL_TX_SINGLE &&
+	if (iwl_tx_ant_restriction(priv) == IWL_ANT_OK_SINGLE &&
 	    tbl->action > IWL_SISO_SWITCH_ANTENNA2) {
 		/* stay in SISO */
 		tbl->action = IWL_SISO_SWITCH_ANTENNA1;
@@ -1674,7 +1674,7 @@ static int rs_move_mimo2_to_other(struct iwl_priv *priv,
 	u8 update_search_tbl_counter = 0;
 	int ret;
 
-	if ((iwl_tx_ant_restriction(priv) == IWL_TX_SINGLE) &&
+	if ((iwl_tx_ant_restriction(priv) == IWL_ANT_OK_SINGLE) &&
 	    (tbl->action < IWL_MIMO2_SWITCH_SISO_A ||
 	     tbl->action > IWL_MIMO2_SWITCH_SISO_C)) {
 		/* switch in SISO */
@@ -1816,7 +1816,7 @@ static int rs_move_mimo3_to_other(struct iwl_priv *priv,
 	int ret;
 	u8 update_search_tbl_counter = 0;
 
-	if ((iwl_tx_ant_restriction(priv) == IWL_TX_SINGLE) &&
+	if ((iwl_tx_ant_restriction(priv) == IWL_ANT_OK_SINGLE) &&
 	    (tbl->action < IWL_MIMO3_SWITCH_SISO_A ||
 	     tbl->action > IWL_MIMO3_SWITCH_SISO_C)) {
 		/* switch in SISO */
@@ -2202,7 +2202,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 
 	/* If we are searching for better modulation mode, check success. */
 	if (lq_sta->search_better_tbl &&
-	    (iwl_tx_ant_restriction(priv) == IWL_TX_MULTI)) {
+	    (iwl_tx_ant_restriction(priv) == IWL_ANT_OK_MULTI)) {
 		/* If good success, continue using the "search" mode;
 		 * no need to send new link quality command, since we're
 		 * continuing to use the setup that we've been trying. */
@@ -2332,7 +2332,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 		scale_action = 0;
 	if (!iwl_ht_enabled(priv) && !is_legacy(tbl->lq_type))
 		scale_action = -1;
-	if (iwl_tx_ant_restriction(priv) != IWL_TX_MULTI &&
+	if (iwl_tx_ant_restriction(priv) != IWL_ANT_OK_MULTI &&
 		(is_mimo2(tbl->lq_type) || is_mimo3(tbl->lq_type)))
 		scale_action = -1;
 	switch (scale_action) {
@@ -2368,7 +2368,7 @@ lq_update:
 		rate = rs_update_rate_tbl(priv, lq_sta,
 					  tbl, index, is_green);
 
-	if (iwl_tx_ant_restriction(priv) == IWL_TX_MULTI) {
+	if (iwl_tx_ant_restriction(priv) == IWL_ANT_OK_MULTI) {
 		/* Should we stay with this modulation mode,
 		 * or search for a new one? */
 		rs_stay_in_table(lq_sta);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 79170a9..22961e9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2214,7 +2214,7 @@ void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 	iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR,
 		    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
 	spin_unlock_irqrestore(&priv->lock, flags);
-	priv->power_data.ct_kill_toggle = false;
+	priv->thermal_throttle.ct_kill_toggle = false;
 
 	switch (priv->hw_rev & CSR_HW_REV_TYPE_MSK) {
 	case CSR_HW_REV_TYPE_1000:
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 1ad4ff6..7b578d4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -704,7 +704,7 @@ static ssize_t iwl_dbgfs_thermal_throttling_read(struct file *file,
 				size_t count, loff_t *ppos)
 {
 	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
-	struct iwl_tt_mgmt *tt = &priv->power_data.tt;
+	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
 	struct iwl_tt_restriction *restriction;
 	char buf[100];
 	int pos = 0;
@@ -713,12 +713,11 @@ static ssize_t iwl_dbgfs_thermal_throttling_read(struct file *file,
 
 	pos += scnprintf(buf + pos, bufsz - pos,
 			"Thermal Throttling Mode: %s\n",
-			(priv->power_data.adv_tt)
-			? "Advance" : "Legacy");
+			tt->advanced_tt ? "Advance" : "Legacy");
 	pos += scnprintf(buf + pos, bufsz - pos,
 			"Thermal Throttling State: %d\n",
 			tt->state);
-	if (priv->power_data.adv_tt) {
+	if (tt->advanced_tt) {
 		restriction = tt->restriction + tt->state;
 		pos += scnprintf(buf + pos, bufsz - pos,
 				"Tx mode: %d\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 35d07a8..1aa2ae6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1111,6 +1111,7 @@ struct iwl_priv {
 	struct isr_statistics isr_stats;
 
 	struct iwl_power_mgr power_data;
+	struct iwl_tt_mgmt thermal_throttle;
 
 	struct iwl_notif_statistics statistics;
 	unsigned long last_statistics_time;
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index 9e8916d..27ad59d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -132,10 +132,10 @@ static const struct iwl_tt_trans tt_range_3[IWL_TI_STATE_MAX - 1] = {
 
 /* Advance Thermal Throttling default restriction table */
 static const struct iwl_tt_restriction restriction_range[IWL_TI_STATE_MAX] = {
-	{IWL_TX_MULTI, true, IWL_RX_MULTI},
-	{IWL_TX_SINGLE, true, IWL_RX_MULTI},
-	{IWL_TX_SINGLE, false, IWL_RX_SINGLE},
-	{IWL_TX_NONE, false, IWL_RX_NONE}
+	{IWL_ANT_OK_MULTI, IWL_ANT_OK_MULTI, true },
+	{IWL_ANT_OK_SINGLE, IWL_ANT_OK_MULTI, true },
+	{IWL_ANT_OK_SINGLE, IWL_ANT_OK_SINGLE, false },
+	{IWL_ANT_OK_NONE, IWL_ANT_OK_NONE, false }
 };
 
 /* set card power command */
@@ -251,7 +251,7 @@ int iwl_power_update_mode(struct iwl_priv *priv, bool force)
 {
 	struct iwl_power_mgr *setting = &(priv->power_data);
 	int ret = 0;
-	struct iwl_tt_mgmt *tt = &priv->power_data.tt;
+	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
 	u16 uninitialized_var(final_mode);
 	bool update_chains;
 
@@ -317,35 +317,35 @@ EXPORT_SYMBOL(iwl_power_set_user_mode);
 
 bool iwl_ht_enabled(struct iwl_priv *priv)
 {
-	struct iwl_tt_mgmt *tt = &priv->power_data.tt;
+	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
 	struct iwl_tt_restriction *restriction;
 
-	if (!priv->power_data.adv_tt)
+	if (!priv->thermal_throttle.advanced_tt)
 		return true;
 	restriction = tt->restriction + tt->state;
 	return restriction->is_ht;
 }
 EXPORT_SYMBOL(iwl_ht_enabled);
 
-u8 iwl_tx_ant_restriction(struct iwl_priv *priv)
+enum iwl_antenna_ok iwl_tx_ant_restriction(struct iwl_priv *priv)
 {
-	struct iwl_tt_mgmt *tt = &priv->power_data.tt;
+	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
 	struct iwl_tt_restriction *restriction;
 
-	if (!priv->power_data.adv_tt)
-		return IWL_TX_MULTI;
+	if (!priv->thermal_throttle.advanced_tt)
+		return IWL_ANT_OK_MULTI;
 	restriction = tt->restriction + tt->state;
 	return restriction->tx_stream;
 }
 EXPORT_SYMBOL(iwl_tx_ant_restriction);
 
-u8 iwl_rx_ant_restriction(struct iwl_priv *priv)
+enum iwl_antenna_ok iwl_rx_ant_restriction(struct iwl_priv *priv)
 {
-	struct iwl_tt_mgmt *tt = &priv->power_data.tt;
+	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
 	struct iwl_tt_restriction *restriction;
 
-	if (!priv->power_data.adv_tt)
-		return IWL_RX_MULTI;
+	if (!priv->thermal_throttle.advanced_tt)
+		return IWL_ANT_OK_MULTI;
 	restriction = tt->restriction + tt->state;
 	return restriction->rx_stream;
 }
@@ -364,21 +364,21 @@ EXPORT_SYMBOL(iwl_rx_ant_restriction);
 static void iwl_tt_check_exit_ct_kill(unsigned long data)
 {
 	struct iwl_priv *priv = (struct iwl_priv *)data;
-	struct iwl_tt_mgmt *tt = &priv->power_data.tt;
+	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
 	unsigned long flags;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
 	if (tt->state == IWL_TI_CT_KILL) {
-		if (priv->power_data.ct_kill_toggle) {
+		if (priv->thermal_throttle.ct_kill_toggle) {
 			iwl_write32(priv, CSR_UCODE_DRV_GP1_CLR,
 				    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
-			priv->power_data.ct_kill_toggle = false;
+			priv->thermal_throttle.ct_kill_toggle = false;
 		} else {
 			iwl_write32(priv, CSR_UCODE_DRV_GP1_SET,
 				    CSR_UCODE_DRV_GP1_REG_BIT_CT_KILL_EXIT);
-			priv->power_data.ct_kill_toggle = true;
+			priv->thermal_throttle.ct_kill_toggle = true;
 		}
 		iwl_read32(priv, CSR_UCODE_DRV_GP1);
 		spin_lock_irqsave(&priv->reg_lock, flags);
@@ -389,7 +389,7 @@ static void iwl_tt_check_exit_ct_kill(unsigned long data)
 		/* Reschedule the ct_kill timer to occur in
 		 * CT_KILL_EXIT_DURATION seconds to ensure we get a
 		 * thermal update */
-		mod_timer(&priv->power_data.ct_kill_exit_tm, jiffies +
+		mod_timer(&priv->thermal_throttle.ct_kill_exit_tm, jiffies +
 			  CT_KILL_EXIT_DURATION * HZ);
 	}
 }
@@ -403,7 +403,7 @@ static void iwl_perform_ct_kill_task(struct iwl_priv *priv,
 			ieee80211_stop_queues(priv->hw);
 		IWL_DEBUG_POWER(priv,
 				"Schedule 5 seconds CT_KILL Timer\n");
-		mod_timer(&priv->power_data.ct_kill_exit_tm, jiffies +
+		mod_timer(&priv->thermal_throttle.ct_kill_exit_tm, jiffies +
 			  CT_KILL_EXIT_DURATION * HZ);
 	} else {
 		IWL_DEBUG_POWER(priv, "Wake all queues\n");
@@ -427,7 +427,7 @@ static void iwl_perform_ct_kill_task(struct iwl_priv *priv,
  */
 static void iwl_legacy_tt_handler(struct iwl_priv *priv, s32 temp)
 {
-	struct iwl_tt_mgmt *tt = &priv->power_data.tt;
+	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
 	enum iwl_tt_state old_state;
 	struct iwl_power_mgr *setting = &priv->power_data;
 
@@ -531,7 +531,7 @@ static void iwl_legacy_tt_handler(struct iwl_priv *priv, s32 temp)
  */
 static void iwl_advance_tt_handler(struct iwl_priv *priv, s32 temp)
 {
-	struct iwl_tt_mgmt *tt = &priv->power_data.tt;
+	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
 	int i;
 	bool changed = false;
 	enum iwl_tt_state old_state;
@@ -655,7 +655,7 @@ static void iwl_advance_tt_handler(struct iwl_priv *priv, s32 temp)
 static void iwl_bg_ct_enter(struct work_struct *work)
 {
 	struct iwl_priv *priv = container_of(work, struct iwl_priv, ct_enter);
-	struct iwl_tt_mgmt *tt = &priv->power_data.tt;
+	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
@@ -666,7 +666,7 @@ static void iwl_bg_ct_enter(struct work_struct *work)
 	if (tt->state != IWL_TI_CT_KILL) {
 		IWL_ERR(priv, "Device reached critical temperature "
 			      "- ucode going to sleep!\n");
-		if (!priv->power_data.adv_tt)
+		if (!priv->thermal_throttle.advanced_tt)
 			iwl_legacy_tt_handler(priv,
 					      IWL_MINIMAL_POWER_THRESHOLD);
 		else
@@ -683,7 +683,7 @@ static void iwl_bg_ct_enter(struct work_struct *work)
 static void iwl_bg_ct_exit(struct work_struct *work)
 {
 	struct iwl_priv *priv = container_of(work, struct iwl_priv, ct_exit);
-	struct iwl_tt_mgmt *tt = &priv->power_data.tt;
+	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
@@ -692,13 +692,13 @@ static void iwl_bg_ct_exit(struct work_struct *work)
 		return;
 
 	/* stop ct_kill_exit_tm timer */
-	del_timer_sync(&priv->power_data.ct_kill_exit_tm);
+	del_timer_sync(&priv->thermal_throttle.ct_kill_exit_tm);
 
 	if (tt->state == IWL_TI_CT_KILL) {
 		IWL_ERR(priv,
 			"Device temperature below critical"
 			"- ucode awake!\n");
-		if (!priv->power_data.adv_tt)
+		if (!priv->thermal_throttle.advanced_tt)
 			iwl_legacy_tt_handler(priv,
 					IWL_REDUCED_PERFORMANCE_THRESHOLD_2);
 		else
@@ -737,7 +737,7 @@ static void iwl_bg_tt_work(struct work_struct *work)
 	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) == CSR_HW_REV_TYPE_4965)
 		temp = KELVIN_TO_CELSIUS(priv->temperature);
 
-	if (!priv->power_data.adv_tt)
+	if (!priv->thermal_throttle.advanced_tt)
 		iwl_legacy_tt_handler(priv, temp);
 	else
 		iwl_advance_tt_handler(priv, temp);
@@ -760,7 +760,7 @@ EXPORT_SYMBOL(iwl_tt_handler);
  */
 void iwl_tt_initialize(struct iwl_priv *priv)
 {
-	struct iwl_tt_mgmt *tt = &priv->power_data.tt;
+	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
 	struct iwl_power_mgr *setting = &priv->power_data;
 	int size = sizeof(struct iwl_tt_trans) * (IWL_TI_STATE_MAX - 1);
 	struct iwl_tt_trans *transaction;
@@ -772,9 +772,9 @@ void iwl_tt_initialize(struct iwl_priv *priv)
 	tt->state = IWL_TI_0;
 	tt->sys_power_mode = setting->power_mode;
 	tt->tt_power_mode = tt->sys_power_mode;
-	init_timer(&priv->power_data.ct_kill_exit_tm);
-	priv->power_data.ct_kill_exit_tm.data = (unsigned long)priv;
-	priv->power_data.ct_kill_exit_tm.function = iwl_tt_check_exit_ct_kill;
+	init_timer(&priv->thermal_throttle.ct_kill_exit_tm);
+	priv->thermal_throttle.ct_kill_exit_tm.data = (unsigned long)priv;
+	priv->thermal_throttle.ct_kill_exit_tm.function = iwl_tt_check_exit_ct_kill;
 
 	/* setup deferred ct kill work */
 	INIT_WORK(&priv->tt_work, iwl_bg_tt_work);
@@ -792,7 +792,7 @@ void iwl_tt_initialize(struct iwl_priv *priv)
 			GFP_KERNEL);
 		if (!tt->restriction || !tt->transaction) {
 			IWL_ERR(priv, "Fallback to Legacy Throttling\n");
-			priv->power_data.adv_tt = false;
+			priv->thermal_throttle.advanced_tt = false;
 			kfree(tt->restriction);
 			tt->restriction = NULL;
 			kfree(tt->transaction);
@@ -814,12 +814,12 @@ void iwl_tt_initialize(struct iwl_priv *priv)
 				IWL_TI_STATE_MAX;
 			memcpy(tt->restriction,
 				&restriction_range[0], size);
-			priv->power_data.adv_tt = true;
+			priv->thermal_throttle.advanced_tt = true;
 		}
 		break;
 	default:
 		IWL_DEBUG_POWER(priv, "Legacy Thermal Throttling\n");
-		priv->power_data.adv_tt = false;
+		priv->thermal_throttle.advanced_tt = false;
 		break;
 	}
 }
@@ -828,15 +828,15 @@ EXPORT_SYMBOL(iwl_tt_initialize);
 /* cleanup thermal throttling management related memory and timer */
 void iwl_tt_exit(struct iwl_priv *priv)
 {
-	struct iwl_tt_mgmt *tt = &priv->power_data.tt;
+	struct iwl_tt_mgmt *tt = &priv->thermal_throttle;
 
 	/* stop ct_kill_exit_tm timer if activated */
-	del_timer_sync(&priv->power_data.ct_kill_exit_tm);
+	del_timer_sync(&priv->thermal_throttle.ct_kill_exit_tm);
 	cancel_work_sync(&priv->tt_work);
 	cancel_work_sync(&priv->ct_enter);
 	cancel_work_sync(&priv->ct_exit);
 
-	if (priv->power_data.adv_tt) {
+	if (priv->thermal_throttle.advanced_tt) {
 		/* free advance thermal throttling memory */
 		kfree(tt->restriction);
 		tt->restriction = NULL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.h b/drivers/net/wireless/iwlwifi/iwl-power.h
index 3d49b7a..15e3eab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.h
+++ b/drivers/net/wireless/iwlwifi/iwl-power.h
@@ -37,13 +37,11 @@ struct iwl_priv;
 #define IWL_ABSOLUTE_MAX		0xFFFFFFFF
 #define IWL_TT_INCREASE_MARGIN	5
 
-/* Tx/Rx restrictions */
-#define IWL_TX_MULTI		0x02
-#define IWL_TX_SINGLE		0x01
-#define IWL_TX_NONE		0x00
-#define IWL_RX_MULTI		0x02
-#define IWL_RX_SINGLE		0x01
-#define IWL_RX_NONE		0x00
+enum iwl_antenna_ok {
+	IWL_ANT_OK_NONE,
+	IWL_ANT_OK_SINGLE,
+	IWL_ANT_OK_MULTI,
+};
 
 /* Thermal Throttling State Machine states */
 enum  iwl_tt_state {
@@ -55,27 +53,30 @@ enum  iwl_tt_state {
 };
 
 /**
- * struct iwl_tt_restriction - Thermal Throttling restriction table used
- *		by advance thermal throttling management
- *		based on the current thermal throttling state, determine
- *		number of tx/rx streams; and the status of HT operation
+ * struct iwl_tt_restriction - Thermal Throttling restriction table
  * @tx_stream: number of tx stream allowed
  * @is_ht: ht enable/disable
  * @rx_stream: number of rx stream allowed
+ *
+ * This table is used by advance thermal throttling management
+ * based on the current thermal throttling state, and determines
+ * the number of tx/rx streams and the status of HT operation.
  */
 struct iwl_tt_restriction {
-	u8 tx_stream;
+	enum iwl_antenna_ok tx_stream;
+	enum iwl_antenna_ok rx_stream;
 	bool is_ht;
-	u8 rx_stream;
 };
 
 /**
- * struct iwl_tt_trans - Thermal Throttling transaction table; used by
- * 		advance thermal throttling algorithm to determine next
- *		thermal state to go based on the current temperature
+ * struct iwl_tt_trans - Thermal Throttling transaction table
  * @next_state:  next thermal throttling mode
  * @tt_low: low temperature threshold to change state
  * @tt_high: high temperature threshold to change state
+ *
+ * This is used by the advanced thermal throttling algorithm
+ * to determine the next thermal state to go based on the
+ * current temperature.
  */
 struct iwl_tt_trans {
 	enum iwl_tt_state next_state;
@@ -85,6 +86,7 @@ struct iwl_tt_trans {
 
 /**
  * struct iwl_tt_mgnt - Thermal Throttling Management structure
+ * @advanced_tt:    advanced thermal throttle required
  * @state:          current Thermal Throttling state
  * @tt_power_mode:  Thermal Throttling power mode index
  *		    being used to set power level when
@@ -99,16 +101,21 @@ struct iwl_tt_trans {
  *		    should be used in tt state; and can HT be enabled or not
  * @iwl_tt_trans: ptr to adv trans table, used by advance thermal throttling
  *		    state transaction
+ * @ct_kill_toggle: used to toggle the CSR bit when checking uCode temperature
+ * @ct_kill_exit_tm: timer to exit thermal kill
  */
 struct iwl_tt_mgmt {
 	enum iwl_tt_state state;
+	bool advanced_tt;
 	u8 tt_power_mode;
 	u8 sys_power_mode;
+	bool ct_kill_toggle;
 #ifdef CONFIG_IWLWIFI_DEBUG
 	s32 tt_previous_temp;
 #endif
 	struct iwl_tt_restriction *restriction;
 	struct iwl_tt_trans *transaction;
+	struct timer_list ct_kill_exit_tm;
 };
 
 enum {
@@ -137,20 +144,13 @@ struct iwl_power_mgr {
 	u8 power_mode;
 	u8 user_power_setting; /* set by user through sysfs */
 	u8 power_disabled; /* set by mac80211's CONF_PS */
-	struct iwl_tt_mgmt tt; /* Thermal Throttling Management */
-	bool adv_tt;		/* false: legacy mode */
-				/* true: advance mode */
-	bool ct_kill_toggle;   /* use to toggle the CSR bit when
-				* checking uCode temperature
-				*/
-	struct timer_list ct_kill_exit_tm;
 };
 
 int iwl_power_update_mode(struct iwl_priv *priv, bool force);
 int iwl_power_set_user_mode(struct iwl_priv *priv, u16 mode);
 bool iwl_ht_enabled(struct iwl_priv *priv);
-u8 iwl_tx_ant_restriction(struct iwl_priv *priv);
-u8 iwl_rx_ant_restriction(struct iwl_priv *priv);
+enum iwl_antenna_ok iwl_tx_ant_restriction(struct iwl_priv *priv);
+enum iwl_antenna_ok iwl_rx_ant_restriction(struct iwl_priv *priv);
 void iwl_tt_enter_ct_kill(struct iwl_priv *priv);
 void iwl_tt_exit_ct_kill(struct iwl_priv *priv);
 void iwl_tt_handler(struct iwl_priv *priv);
-- 
1.5.6.3

