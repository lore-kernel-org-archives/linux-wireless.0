Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23614 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594AbZGXSNQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 14:13:16 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/14] iwlwifi: Thermal Throttling Management - part 2
Date: Fri, 24 Jul 2009 11:13:03 -0700
Message-Id: <1248459194-10239-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1248459194-10239-1-git-send-email-reinette.chatre@intel.com>
References: <1248459194-10239-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Part 2 of Thermal Throttling Management -

Thermal Throttling feature is used to put NIC into low power state when
driver detect the Radio temperature reach pre-defined threshold

Two Thermal Throttling Management Methods; this patch introduce the
Advance Thermal Throttling:
TI-0: system power index, no tx/rx restriction, HT enabled
TI-1: power index 5, 1 spatial stream Tx, multiple spatial stream Rx, HT
enabled
TI-2: power index 5: 1 spatial stream Tx, 1 spatial stream Rx, HT
disabled
TI-CT-KILL: power index 5, no Tx, no Rx, HT disabled

For advance Thermal Throttling, CT_KILL_ENTER threshold and CT_KILL_EXIT
threshold are different; uCode will not stay awake until reach
CT_KILL_EXIT threshold.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   48 ++++-
 drivers/net/wireless/iwlwifi/iwl-power.c  |  285 ++++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-power.h  |   51 +++++
 3 files changed, 371 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 40207da..52a4810 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -177,7 +177,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 				   struct sk_buff *skb,
 				   struct ieee80211_sta *sta,
 				   struct iwl_lq_sta *lq_sta);
-static void rs_fill_link_cmd(const struct iwl_priv *priv,
+static void rs_fill_link_cmd(struct iwl_priv *priv,
 			     struct iwl_lq_sta *lq_sta, u32 rate_n_flags);
 
 
@@ -1398,6 +1398,12 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 	int ret = 0;
 	u8 update_search_tbl_counter = 0;
 
+	if (!iwl_ht_enabled(priv))
+		/* stay in Legacy */
+		tbl->action = IWL_LEGACY_SWITCH_ANTENNA1;
+	else if (iwl_tx_ant_restriction(priv) == IWL_TX_SINGLE &&
+		   tbl->action > IWL_LEGACY_SWITCH_SISO)
+		tbl->action = IWL_LEGACY_SWITCH_SISO;
 	for (; ;) {
 		lq_sta->action_counter++;
 		switch (tbl->action) {
@@ -1529,6 +1535,11 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 	u8 update_search_tbl_counter = 0;
 	int ret;
 
+	if (iwl_tx_ant_restriction(priv) == IWL_TX_SINGLE &&
+	    tbl->action > IWL_SISO_SWITCH_ANTENNA2) {
+		/* stay in SISO */
+		tbl->action = IWL_SISO_SWITCH_ANTENNA1;
+	}
 	for (;;) {
 		lq_sta->action_counter++;
 		switch (tbl->action) {
@@ -1663,6 +1674,12 @@ static int rs_move_mimo2_to_other(struct iwl_priv *priv,
 	u8 update_search_tbl_counter = 0;
 	int ret;
 
+	if ((iwl_tx_ant_restriction(priv) == IWL_TX_SINGLE) &&
+	    (tbl->action < IWL_MIMO2_SWITCH_SISO_A ||
+	     tbl->action > IWL_MIMO2_SWITCH_SISO_C)) {
+		/* switch in SISO */
+		tbl->action = IWL_MIMO2_SWITCH_SISO_A;
+	}
 	for (;;) {
 		lq_sta->action_counter++;
 		switch (tbl->action) {
@@ -1799,6 +1816,12 @@ static int rs_move_mimo3_to_other(struct iwl_priv *priv,
 	int ret;
 	u8 update_search_tbl_counter = 0;
 
+	if ((iwl_tx_ant_restriction(priv) == IWL_TX_SINGLE) &&
+	    (tbl->action < IWL_MIMO3_SWITCH_SISO_A ||
+	     tbl->action > IWL_MIMO3_SWITCH_SISO_C)) {
+		/* switch in SISO */
+		tbl->action = IWL_MIMO3_SWITCH_SISO_A;
+	}
 	for (;;) {
 		lq_sta->action_counter++;
 		switch (tbl->action) {
@@ -2178,8 +2201,8 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 			tbl->expected_tpt[index] + 64) / 128));
 
 	/* If we are searching for better modulation mode, check success. */
-	if (lq_sta->search_better_tbl) {
-
+	if (lq_sta->search_better_tbl &&
+	    (iwl_tx_ant_restriction(priv) == IWL_TX_MULTI)) {
 		/* If good success, continue using the "search" mode;
 		 * no need to send new link quality command, since we're
 		 * continuing to use the setup that we've been trying. */
@@ -2307,7 +2330,11 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 		    ((sr > IWL_RATE_HIGH_TH) ||
 		     (current_tpt > (100 * tbl->expected_tpt[low]))))
 		scale_action = 0;
-
+	if (!iwl_ht_enabled(priv) && !is_legacy(tbl->lq_type))
+		scale_action = -1;
+	if (iwl_tx_ant_restriction(priv) != IWL_TX_MULTI &&
+		(is_mimo2(tbl->lq_type) || is_mimo3(tbl->lq_type)))
+		scale_action = -1;
 	switch (scale_action) {
 	case -1:
 		/* Decrease starting rate, update uCode's rate table */
@@ -2341,9 +2368,11 @@ lq_update:
 		rate = rs_update_rate_tbl(priv, lq_sta,
 					  tbl, index, is_green);
 
-	/* Should we stay with this modulation mode, or search for a new one? */
-	rs_stay_in_table(lq_sta);
-
+	if (iwl_tx_ant_restriction(priv) == IWL_TX_MULTI) {
+		/* Should we stay with this modulation mode,
+		 * or search for a new one? */
+		rs_stay_in_table(lq_sta);
+	}
 	/*
 	 * Search for new modulation mode if we're:
 	 * 1)  Not changing rates right now
@@ -2400,7 +2429,8 @@ lq_update:
 		 * have been tried and compared, stay in this best modulation
 		 * mode for a while before next round of mode comparisons. */
 		if (lq_sta->enable_counter &&
-		    (lq_sta->action_counter >= tbl1->max_search)) {
+		    (lq_sta->action_counter >= tbl1->max_search) &&
+		    iwl_ht_enabled(priv)) {
 			if ((lq_sta->last_tpt > IWL_AGG_TPT_THREHOLD) &&
 			    (lq_sta->tx_agg_tid_en & (1 << tid)) &&
 			    (tid != MAX_TID_COUNT)) {
@@ -2686,7 +2716,7 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 	rs_initialize_lq(priv, conf, sta, lq_sta);
 }
 
-static void rs_fill_link_cmd(const struct iwl_priv *priv,
+static void rs_fill_link_cmd(struct iwl_priv *priv,
 			     struct iwl_lq_sta *lq_sta, u32 new_rate)
 {
 	struct iwl_scale_tbl_info tbl_type;
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c b/drivers/net/wireless/iwlwifi/iwl-power.c
index d7fdb58..00937b3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -98,6 +98,45 @@ static const struct iwl_power_vec_entry range_2[IWL_POWER_NUM] = {
 	{{SLP, SLP_TOUT(25), SLP_TOUT(25), SLP_VEC(4, 7, 10, 10, 0xFF)}, 0}
 };
 
+/* default Thermal Throttling transaction table
+ * Current state   |         Throttling Down               |  Throttling Up
+ *=============================================================================
+ *                 Condition Nxt State  Condition Nxt State Condition Nxt State
+ *-----------------------------------------------------------------------------
+ *     IWL_TI_0     T >= 115   CT_KILL  115>T>=105   TI_1      N/A      N/A
+ *     IWL_TI_1     T >= 115   CT_KILL  115>T>=110   TI_2     T<=95     TI_0
+ *     IWL_TI_2     T >= 115   CT_KILL                        T<=100    TI_1
+ *    IWL_CT_KILL      N/A       N/A       N/A        N/A     T<=95     TI_0
+ *=============================================================================
+ */
+static const struct iwl_tt_trans tt_range_0[IWL_TI_STATE_MAX - 1] = {
+	{IWL_TI_0, IWL_ABSOLUTE_ZERO, 104},
+	{IWL_TI_1, 105, CT_KILL_THRESHOLD},
+	{IWL_TI_CT_KILL, CT_KILL_THRESHOLD + 1, IWL_ABSOLUTE_MAX}
+};
+static const struct iwl_tt_trans tt_range_1[IWL_TI_STATE_MAX - 1] = {
+	{IWL_TI_0, IWL_ABSOLUTE_ZERO, 95},
+	{IWL_TI_2, 110, CT_KILL_THRESHOLD},
+	{IWL_TI_CT_KILL, CT_KILL_THRESHOLD + 1, IWL_ABSOLUTE_MAX}
+};
+static const struct iwl_tt_trans tt_range_2[IWL_TI_STATE_MAX - 1] = {
+	{IWL_TI_1, IWL_ABSOLUTE_ZERO, 100},
+	{IWL_TI_CT_KILL, CT_KILL_THRESHOLD + 1, IWL_ABSOLUTE_MAX},
+	{IWL_TI_CT_KILL, CT_KILL_THRESHOLD + 1, IWL_ABSOLUTE_MAX}
+};
+static const struct iwl_tt_trans tt_range_3[IWL_TI_STATE_MAX - 1] = {
+	{IWL_TI_0, IWL_ABSOLUTE_ZERO, CT_KILL_EXIT_THRESHOLD},
+	{IWL_TI_CT_KILL, CT_KILL_EXIT_THRESHOLD + 1, IWL_ABSOLUTE_MAX},
+	{IWL_TI_CT_KILL, CT_KILL_EXIT_THRESHOLD + 1, IWL_ABSOLUTE_MAX}
+};
+
+/* Advance Thermal Throttling default restriction table */
+static const struct iwl_tt_restriction restriction_range[IWL_TI_STATE_MAX] = {
+	{IWL_TX_MULTI, true, IWL_RX_MULTI},
+	{IWL_TX_SINGLE, true, IWL_RX_MULTI},
+	{IWL_TX_SINGLE, false, IWL_RX_SINGLE},
+	{IWL_TX_NONE, false, IWL_RX_NONE}
+};
 
 /* set card power command */
 static int iwl_set_power(struct iwl_priv *priv, void *cmd)
@@ -273,6 +312,42 @@ int iwl_power_set_user_mode(struct iwl_priv *priv, u16 mode)
 }
 EXPORT_SYMBOL(iwl_power_set_user_mode);
 
+bool iwl_ht_enabled(struct iwl_priv *priv)
+{
+	struct iwl_tt_mgmt *tt = &priv->power_data.tt;
+	struct iwl_tt_restriction *restriction;
+
+	if (!priv->power_data.adv_tt)
+		return true;
+	restriction = tt->restriction + tt->state;
+	return restriction->is_ht;
+}
+EXPORT_SYMBOL(iwl_ht_enabled);
+
+u8 iwl_tx_ant_restriction(struct iwl_priv *priv)
+{
+	struct iwl_tt_mgmt *tt = &priv->power_data.tt;
+	struct iwl_tt_restriction *restriction;
+
+	if (!priv->power_data.adv_tt)
+		return IWL_TX_MULTI;
+	restriction = tt->restriction + tt->state;
+	return restriction->tx_stream;
+}
+EXPORT_SYMBOL(iwl_tx_ant_restriction);
+
+u8 iwl_rx_ant_restriction(struct iwl_priv *priv)
+{
+	struct iwl_tt_mgmt *tt = &priv->power_data.tt;
+	struct iwl_tt_restriction *restriction;
+
+	if (!priv->power_data.adv_tt)
+		return IWL_RX_MULTI;
+	restriction = tt->restriction + tt->state;
+	return restriction->rx_stream;
+}
+EXPORT_SYMBOL(iwl_rx_ant_restriction);
+
 #define CT_KILL_EXIT_DURATION (5)	/* 5 seconds duration */
 
 /*
@@ -427,12 +502,147 @@ static void iwl_legacy_tt_handler(struct iwl_priv *priv, s32 temp)
 	}
 }
 
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
+ *     IWL_TI_0     T >= 115   CT_KILL  115>T>=105   TI_1      N/A      N/A
+ *     IWL_TI_1     T >= 115   CT_KILL  115>T>=110   TI_2     T<=95     TI_0
+ *     IWL_TI_2     T >= 115   CT_KILL                        T<=100    TI_1
+ *    IWL_CT_KILL      N/A       N/A       N/A        N/A     T<=95     TI_0
+ *=============================================================================
+ */
+static void iwl_advance_tt_handler(struct iwl_priv *priv, s32 temp)
+{
+	struct iwl_tt_mgmt *tt = &priv->power_data.tt;
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
+	if (changed) {
+		struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
+		struct iwl_power_mgr *setting = &priv->power_data;
+
+		if (tt->state >= IWL_TI_1) {
+			/* if switching from IWL_TI_0 to other TT state
+			 * save previous power setting in tt->sys_power_mode */
+			if (old_state == IWL_TI_0)
+				tt->sys_power_mode = setting->power_mode;
+			/* force PI = IWL_POWER_INDEX_5 in the case of TI > 0 */
+			tt->tt_power_mode = IWL_POWER_INDEX_5;
+			if (!iwl_ht_enabled(priv))
+				/* disable HT */
+				rxon->flags &= ~(RXON_FLG_CHANNEL_MODE_MSK |
+					RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK |
+					RXON_FLG_FAT_PROT_MSK |
+					RXON_FLG_HT_PROT_MSK);
+			else {
+				/* check HT capability and set
+				 * according to the system HT capability
+				 * in case get disabled before */
+				iwl_set_rxon_ht(priv, &priv->current_ht_config);
+			}
+
+		} else {
+			/* restore system power setting */
+			/* the previous power mode was saved in
+			 * tt->sys_power_mode when system move into
+			 * Thermal Throttling state
+			 * set power_data.user_power_setting to the previous
+			 * system power mode to make sure power will get
+			 * updated correctly
+			 */
+			priv->power_data.user_power_setting =
+				tt->sys_power_mode;
+			tt->tt_power_mode = tt->sys_power_mode;
+			/* check HT capability and set
+			 * according to the system HT capability
+			 * in case get disabled before */
+			iwl_set_rxon_ht(priv, &priv->current_ht_config);
+		}
+		if (iwl_power_update_mode(priv, true)) {
+			/* TT state not updated
+			 * try again during next temperature read
+			 */
+			IWL_ERR(priv, "Cannot update power mode, "
+					"TT state not updated\n");
+			tt->state = old_state;
+		} else {
+			IWL_DEBUG_POWER(priv,
+					"Thermal Throttling to new state: %u\n",
+					tt->state);
+			if (old_state != IWL_TI_CT_KILL &&
+			    tt->state == IWL_TI_CT_KILL) {
+				IWL_DEBUG_POWER(priv, "Enter IWL_TI_CT_KILL\n");
+				iwl_perform_ct_kill_task(priv, true);
+
+			} else if (old_state == IWL_TI_CT_KILL &&
+				  tt->state != IWL_TI_CT_KILL) {
+				IWL_DEBUG_POWER(priv, "Exit IWL_TI_CT_KILL\n");
+				iwl_perform_ct_kill_task(priv, false);
+			}
+		}
+	}
+}
+
 /* Card State Notification indicated reach critical temperature
  * if PSP not enable, no Thermal Throttling function will be performed
  * just set the GP1 bit to acknowledge the event
  * otherwise, go into IWL_TI_CT_KILL state
  * since Card State Notification will not provide any temperature reading
+ * for Legacy mode
  * so just pass the CT_KILL temperature to iwl_legacy_tt_handler()
+ * for advance mode
+ * pass CT_KILL_THRESHOLD+1 to make sure move into IWL_TI_CT_KILL state
  */
 void iwl_tt_enter_ct_kill(struct iwl_priv *priv)
 {
@@ -444,7 +654,12 @@ void iwl_tt_enter_ct_kill(struct iwl_priv *priv)
 	if (tt->state != IWL_TI_CT_KILL) {
 		IWL_ERR(priv, "Device reached critical temperature "
 			      "- ucode going to sleep!\n");
-		iwl_legacy_tt_handler(priv, IWL_MINIMAL_POWER_THRESHOLD);
+		if (!priv->power_data.adv_tt)
+			iwl_legacy_tt_handler(priv,
+					      IWL_MINIMAL_POWER_THRESHOLD);
+		else
+			iwl_advance_tt_handler(priv,
+					       CT_KILL_THRESHOLD + 1);
 	}
 }
 EXPORT_SYMBOL(iwl_tt_enter_ct_kill);
@@ -468,8 +683,11 @@ void iwl_tt_exit_ct_kill(struct iwl_priv *priv)
 		IWL_ERR(priv,
 			"Device temperature below critical"
 			"- ucode awake!\n");
-		iwl_legacy_tt_handler(priv,
-			IWL_REDUCED_PERFORMANCE_THRESHOLD_2);
+		if (!priv->power_data.adv_tt)
+			iwl_legacy_tt_handler(priv,
+					IWL_REDUCED_PERFORMANCE_THRESHOLD_2);
+		else
+			iwl_advance_tt_handler(priv, CT_KILL_EXIT_THRESHOLD);
 	}
 }
 EXPORT_SYMBOL(iwl_tt_exit_ct_kill);
@@ -484,16 +702,24 @@ void iwl_tt_handler(struct iwl_priv *priv)
 	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) == CSR_HW_REV_TYPE_4965)
 		temp = KELVIN_TO_CELSIUS(priv->temperature);
 
-	iwl_legacy_tt_handler(priv, temp);
+	if (!priv->power_data.adv_tt)
+		iwl_legacy_tt_handler(priv, temp);
+	else
+		iwl_advance_tt_handler(priv, temp);
 }
 EXPORT_SYMBOL(iwl_tt_handler);
 
 /* Thermal throttling initialization
+ * For advance thermal throttling:
+ *     Initialize Thermal Index and temperature threshold table
+ *     Initialize thermal throttling restriction table
  */
 void iwl_tt_initialize(struct iwl_priv *priv)
 {
 	struct iwl_tt_mgmt *tt = &priv->power_data.tt;
 	struct iwl_power_mgr *setting = &priv->power_data;
+	int size = sizeof(struct iwl_tt_trans) * (IWL_TI_STATE_MAX - 1);
+	struct iwl_tt_trans *transaction;
 
 	IWL_DEBUG_POWER(priv, "Initialize Thermal Throttling \n");
 
@@ -505,14 +731,65 @@ void iwl_tt_initialize(struct iwl_priv *priv)
 	init_timer(&priv->power_data.ct_kill_exit_tm);
 	priv->power_data.ct_kill_exit_tm.data = (unsigned long)priv;
 	priv->power_data.ct_kill_exit_tm.function = iwl_tt_check_exit_ct_kill;
+	switch (priv->hw_rev & CSR_HW_REV_TYPE_MSK) {
+	case CSR_HW_REV_TYPE_6x00:
+	case CSR_HW_REV_TYPE_6x50:
+		IWL_DEBUG_POWER(priv, "Advanced Thermal Throttling\n");
+		tt->restriction = kzalloc(sizeof(struct iwl_tt_restriction) *
+					 IWL_TI_STATE_MAX, GFP_KERNEL);
+		tt->transaction = kzalloc(sizeof(struct iwl_tt_trans) *
+			IWL_TI_STATE_MAX * (IWL_TI_STATE_MAX - 1),
+			GFP_KERNEL);
+		if (!tt->restriction || !tt->transaction) {
+			IWL_ERR(priv, "Fallback to Legacy Throttling\n");
+			priv->power_data.adv_tt = false;
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
+			priv->power_data.adv_tt = true;
+		}
+		break;
+	default:
+		IWL_DEBUG_POWER(priv, "Legacy Thermal Throttling\n");
+		priv->power_data.adv_tt = false;
+		break;
+	}
 }
 EXPORT_SYMBOL(iwl_tt_initialize);
 
 /* cleanup thermal throttling management related memory and timer */
 void iwl_tt_exit(struct iwl_priv *priv)
 {
+	struct iwl_tt_mgmt *tt = &priv->power_data.tt;
+
 	/* stop ct_kill_exit_tm timer if activated */
 	del_timer_sync(&priv->power_data.ct_kill_exit_tm);
+
+	if (priv->power_data.adv_tt) {
+		/* free advance thermal throttling memory */
+		kfree(tt->restriction);
+		tt->restriction = NULL;
+		kfree(tt->transaction);
+		tt->transaction = NULL;
+	}
 }
 EXPORT_SYMBOL(iwl_tt_exit);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-power.h b/drivers/net/wireless/iwlwifi/iwl-power.h
index 7bb10d4..3d49b7a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.h
+++ b/drivers/net/wireless/iwlwifi/iwl-power.h
@@ -33,8 +33,18 @@
 
 struct iwl_priv;
 
+#define IWL_ABSOLUTE_ZERO		0
+#define IWL_ABSOLUTE_MAX		0xFFFFFFFF
 #define IWL_TT_INCREASE_MARGIN	5
 
+/* Tx/Rx restrictions */
+#define IWL_TX_MULTI		0x02
+#define IWL_TX_SINGLE		0x01
+#define IWL_TX_NONE		0x00
+#define IWL_RX_MULTI		0x02
+#define IWL_RX_SINGLE		0x01
+#define IWL_RX_NONE		0x00
+
 /* Thermal Throttling State Machine states */
 enum  iwl_tt_state {
 	IWL_TI_0,	/* normal temperature, system power state */
@@ -45,6 +55,35 @@ enum  iwl_tt_state {
 };
 
 /**
+ * struct iwl_tt_restriction - Thermal Throttling restriction table used
+ *		by advance thermal throttling management
+ *		based on the current thermal throttling state, determine
+ *		number of tx/rx streams; and the status of HT operation
+ * @tx_stream: number of tx stream allowed
+ * @is_ht: ht enable/disable
+ * @rx_stream: number of rx stream allowed
+ */
+struct iwl_tt_restriction {
+	u8 tx_stream;
+	bool is_ht;
+	u8 rx_stream;
+};
+
+/**
+ * struct iwl_tt_trans - Thermal Throttling transaction table; used by
+ * 		advance thermal throttling algorithm to determine next
+ *		thermal state to go based on the current temperature
+ * @next_state:  next thermal throttling mode
+ * @tt_low: low temperature threshold to change state
+ * @tt_high: high temperature threshold to change state
+ */
+struct iwl_tt_trans {
+	enum iwl_tt_state next_state;
+	u32 tt_low;
+	u32 tt_high;
+};
+
+/**
  * struct iwl_tt_mgnt - Thermal Throttling Management structure
  * @state:          current Thermal Throttling state
  * @tt_power_mode:  Thermal Throttling power mode index
@@ -55,6 +94,11 @@ enum  iwl_tt_state {
  * @sys_power_mode: previous system power mode
  *                  before transition into TT state
  * @tt_previous_temperature: last measured temperature
+ * @iwl_tt_restriction: ptr to restriction tbl, used by advance
+ *		    thermal throttling to determine how many tx/rx streams
+ *		    should be used in tt state; and can HT be enabled or not
+ * @iwl_tt_trans: ptr to adv trans table, used by advance thermal throttling
+ *		    state transaction
  */
 struct iwl_tt_mgmt {
 	enum iwl_tt_state state;
@@ -63,6 +107,8 @@ struct iwl_tt_mgmt {
 #ifdef CONFIG_IWLWIFI_DEBUG
 	s32 tt_previous_temp;
 #endif
+	struct iwl_tt_restriction *restriction;
+	struct iwl_tt_trans *transaction;
 };
 
 enum {
@@ -92,6 +138,8 @@ struct iwl_power_mgr {
 	u8 user_power_setting; /* set by user through sysfs */
 	u8 power_disabled; /* set by mac80211's CONF_PS */
 	struct iwl_tt_mgmt tt; /* Thermal Throttling Management */
+	bool adv_tt;		/* false: legacy mode */
+				/* true: advance mode */
 	bool ct_kill_toggle;   /* use to toggle the CSR bit when
 				* checking uCode temperature
 				*/
@@ -100,6 +148,9 @@ struct iwl_power_mgr {
 
 int iwl_power_update_mode(struct iwl_priv *priv, bool force);
 int iwl_power_set_user_mode(struct iwl_priv *priv, u16 mode);
+bool iwl_ht_enabled(struct iwl_priv *priv);
+u8 iwl_tx_ant_restriction(struct iwl_priv *priv);
+u8 iwl_rx_ant_restriction(struct iwl_priv *priv);
 void iwl_tt_enter_ct_kill(struct iwl_priv *priv);
 void iwl_tt_exit_ct_kill(struct iwl_priv *priv);
 void iwl_tt_handler(struct iwl_priv *priv);
-- 
1.5.6.3

