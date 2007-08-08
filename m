Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:55355 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553AbXHHHhK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 03:37:10 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 01/28] iwlwifi: fix a lot of checkpatch.pl warnings
Date: Wed,  8 Aug 2007 15:33:18 +0800
Message-Id: <11865584292234-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11865584251026-git-send-email-yi.zhu@intel.com>
References: <11865584251026-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-3945-rs.c |    4 +-
 drivers/net/wireless/iwl-3945.c    |   81 ++++++------
 drivers/net/wireless/iwl-4965-rs.c |   96 +++++++-------
 drivers/net/wireless/iwl-4965.c    |  176 ++++++++++++------------
 drivers/net/wireless/iwl-4965.h    |    4 +-
 drivers/net/wireless/iwl-base.c    |  266 +++++++++++++++++-------------------
 drivers/net/wireless/iwl-helpers.h |    5 +-
 drivers/net/wireless/iwl-io.h      |   28 ++--
 drivers/net/wireless/iwlwifi.h     |   14 +-
 9 files changed, 325 insertions(+), 349 deletions(-)

diff --git a/drivers/net/wireless/iwl-3945-rs.c b/drivers/net/wireless/iwl-3945-rs.c
index 0dfafc9..8a98eb8 100644
--- a/drivers/net/wireless/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwl-3945-rs.c
@@ -745,9 +745,9 @@ static struct ieee80211_rate *rs_get_rate(void *priv_rate,
 		IWL_DEBUG_RATE("decrease rate because of low success_ratio\n");
 		scale_action = -1;
 	} else if ((low_tpt == IWL_INVALID_VALUE) &&
-		   (high_tpt == IWL_INVALID_VALUE)) {
+		   (high_tpt == IWL_INVALID_VALUE))
 		scale_action = 1;
-	} else if ((low_tpt != IWL_INVALID_VALUE) &&
+	else if ((low_tpt != IWL_INVALID_VALUE) &&
 		   (high_tpt != IWL_INVALID_VALUE)
 		   && (low_tpt < current_tpt)
 		   && (high_tpt < current_tpt)) {
diff --git a/drivers/net/wireless/iwl-3945.c b/drivers/net/wireless/iwl-3945.c
index 6074ae0..8e78ad5 100644
--- a/drivers/net/wireless/iwl-3945.c
+++ b/drivers/net/wireless/iwl-3945.c
@@ -168,12 +168,12 @@ void iwl_disable_events(struct iwl_priv *priv)
 		IWL_DEBUG_INFO("Disabling selected uCode log events at 0x%x\n",
 			       disable_ptr);
 		rc = iwl_grab_restricted_access(priv);
-		for (i = 0; i < IWL_EVT_DISABLE_SIZE; i++) {
+		for (i = 0; i < IWL_EVT_DISABLE_SIZE; i++)
 			iwl_write_restricted_mem(priv,
 						 disable_ptr +
 						 (i * sizeof(u32)),
 						 evt_disable[i]);
-		}
+
 		iwl_release_restricted_access(priv);
 	} else {
 		IWL_DEBUG_INFO("Selected uCode log events may be disabled\n");
@@ -943,9 +943,8 @@ int iwl_hw_nic_init(struct iwl_priv *priv)
 		IWL_DEBUG_INFO("SKU OP mode is mrc\n");
 		iwl_set_bit(priv, CSR_HW_IF_CONFIG_REG,
 			    CSR_HW_IF_CONFIG_REG_BIT_SKU_MRC);
-	} else {
+	} else
 		IWL_DEBUG_INFO("SKU OP mode is basic\n");
-	}
 
 	if ((priv->eeprom.board_revision & 0xF0) == 0xD0) {
 		IWL_DEBUG_INFO("3945ABG revision is 0x%X\n",
@@ -1076,10 +1075,10 @@ int iwl_hw_nic_stop_master(struct iwl_priv *priv)
 	reg_val = iwl_read32(priv, CSR_GP_CNTRL);
 
 	if (CSR_GP_CNTRL_REG_FLAG_MAC_POWER_SAVE ==
-	    (reg_val & CSR_GP_CNTRL_REG_MSK_POWER_SAVE_TYPE)) {
+	    (reg_val & CSR_GP_CNTRL_REG_MSK_POWER_SAVE_TYPE))
 		IWL_DEBUG_INFO
 		    ("Card in power save, master is already stopped\n");
-	} else {
+	else {
 		rc = iwl_poll_bit(priv,
 				  CSR_RESET,
 				  CSR_RESET_REG_FLAG_MASTER_DISABLED,
@@ -1190,8 +1189,8 @@ static int iwl_hw_reg_txpower_get_temperature(struct iwl_priv *priv)
 		/* if really really hot(?),
 		 *   substitute the 3rd band/group's temp measured at factory */
 		if (priv->last_temperature > 100)
-			temperature =
-				(s16)le16_to_cpu(priv->eeprom.groups[2].temperature);
+			temperature = (s16) le16_to_cpu(
+					priv->eeprom.groups[2].temperature);
 		else /* else use most recent "sane" value from driver */
 			temperature = priv->last_temperature;
 	}
@@ -1325,7 +1324,7 @@ static struct iwl_tx_power power_gain_table[2][IWL_MAX_GAIN_ENTRIES] = {
 	 {3, 113},
 	 {3, 106},
 	 {3, 102},
-	 {3, 95}},		/* 2.4 GHz, lowest power */
+	 {3, 95} },		/* 2.4 GHz, lowest power */
 	{
 	 {251, 127},		/* 5.x GHz, highest power */
 	 {251, 120},
@@ -1404,7 +1403,7 @@ static struct iwl_tx_power power_gain_table[2][IWL_MAX_GAIN_ENTRIES] = {
 	 {35, 113},
 	 {35, 107},
 	 {35, 99},
-	 {3, 120}}		/* 5.x GHz, lowest power */
+	 {3, 120} }		/* 5.x GHz, lowest power */
 };
 
 static inline u8 iwl_hw_reg_fix_power_index(int index)
@@ -1426,7 +1425,7 @@ static inline u8 iwl_hw_reg_fix_power_index(int index)
  * or 6 Mbit (OFDM) rates.
  */
 static void iwl_hw_reg_set_scan_power(struct iwl_priv *priv, u32 scan_tbl_index,
-			       s32 rate_index, const s8 * clip_pwrs,
+			       s32 rate_index, const s8 *clip_pwrs,
 			       struct iwl_channel_info *ch_info,
 			       int band_index)
 {
@@ -1456,11 +1455,6 @@ static void iwl_hw_reg_set_scan_power(struct iwl_priv *priv, u32 scan_tbl_index,
 	    - (power - ch_info->power_info
 	       [IWL_RATE_6M_INDEX].requested_power) * 2;
 
-#if 0
-	IWL_DEBUG_POWER("chnl %d scan power index %d\n",
-			ch_info->channel, power_index);
-#endif
-
 	/* store reference index that we use when adjusting *all* scan
 	 *   powers.  So we can accommodate user (all channel) or spectrum
 	 *   management (single channel) power changes "between" temperature
@@ -1541,9 +1535,9 @@ int iwl_hw_reg_send_txpower(struct iwl_priv *priv)
  *
  * This does *not* send anything to NIC, just sets up ch_info for one channel.
  *
- * NOTE:reg_compensate_for_temperature_dif() *must* be run after this to
- *	properly fill out the scan powers, and actual h/w gain settings,
- *	and send changes to NIC
+ * NOTE: reg_compensate_for_temperature_dif() *must* be run after this to
+ *	 properly fill out the scan powers, and actual h/w gain settings,
+ *	 and send changes to NIC
  */
 static int iwl_hw_reg_set_new_power(struct iwl_priv *priv,
 			     struct iwl_channel_info *ch_info)
@@ -1602,12 +1596,13 @@ static int iwl_hw_reg_set_new_power(struct iwl_priv *priv,
 }
 
 /**
- * iwl_hw_reg_get_channel_txpower_limit - returns new power limit for channel
+ * iwl_hw_reg_get_ch_txpower_limit - returns new power limit for channel
  *
- * NOTE:  Returned power limit may be less (but not more) than requested,
- *   based strictly on regulatory (eeprom and spectrum mgt) limitations
- *   (no consideration for h/w clipping limitations). */
-static int iwl_hw_reg_get_channel_txpower_limit(struct iwl_channel_info *ch_info)
+ * NOTE: Returned power limit may be less (but not more) than requested,
+ *	 based strictly on regulatory (eeprom and spectrum mgt) limitations
+ *	 (no consideration for h/w clipping limitations).
+ */
+static int iwl_hw_reg_get_ch_txpower_limit(struct iwl_channel_info *ch_info)
 {
 	s8 max_power;
 
@@ -1621,6 +1616,7 @@ static int iwl_hw_reg_get_channel_txpower_limit(struct iwl_channel_info *ch_info
 	else
 #endif
 		max_power = ch_info->eeprom.max_power_avg;
+
 	return min(max_power, ch_info->max_power_avg);
 }
 
@@ -1657,7 +1653,8 @@ static int iwl_hw_reg_comp_txpower_temp(struct iwl_priv *priv)
 
 		/* get power index adjustment based on curr and factory
 		 * temps */
-		delta_index = iwl_hw_reg_adjust_power_by_temp(temperature, ref_temp);
+		delta_index = iwl_hw_reg_adjust_power_by_temp(temperature,
+							      ref_temp);
 
 		/* set tx power value for all rates, OFDM and CCK */
 		for (rate_index = 0; rate_index < IWL_RATE_COUNT;
@@ -1720,7 +1717,7 @@ int iwl_hw_reg_set_txpower(struct iwl_priv *priv, s8 power)
 
 		/* find minimum power of all user and regulatory constraints
 		 *    (does not consider h/w clipping limitations) */
-		max_power = iwl_hw_reg_get_channel_txpower_limit(ch_info);
+		max_power = iwl_hw_reg_get_ch_txpower_limit(ch_info);
 		max_power = min(power, max_power);
 		if (max_power != ch_info->curr_txpow) {
 			ch_info->curr_txpow = max_power;
@@ -1784,15 +1781,19 @@ void iwl3945_bg_reg_txpower_periodic(struct work_struct *work)
 	mutex_unlock(&priv->mutex);
 }
 
-/* iwl_hw_reg_get_chnl_grp_index - find the channel-group index (0-4) for the channel.
+/**
+ * iwl_hw_reg_get_ch_grp_index - find the channel-group index (0-4)
+ * 				   for the channel.
+ *
+ * This function is used when initializing channel-info structs.
  *
- *  ... used when initializing channel-info structs.
- * NOTE:  These channel groups do *NOT* match the bands above!
- *   These channel groups are based on factory-tested channels;
- *   on A-band, EEPROM's "group frequency" entries represent the top channel
- *   in each group 1-4.  Group 5 All B/G channels are in group 0.  */
-static u16 iwl_hw_reg_get_chnl_grp_index(struct iwl_priv *priv,
-				  const struct iwl_channel_info *ch_info)
+ * NOTE: These channel groups do *NOT* match the bands above!
+ *	 These channel groups are based on factory-tested channels;
+ *	 on A-band, EEPROM's "group frequency" entries represent the top
+ *	 channel in each group 1-4.  Group 5 All B/G channels are in group 0.
+ */
+static u16 iwl_hw_reg_get_ch_grp_index(struct iwl_priv *priv,
+				       const struct iwl_channel_info *ch_info)
 {
 	struct iwl_eeprom_txpower_group *ch_grp = &priv->eeprom.groups[0];
 	u8 group;
@@ -1827,7 +1828,7 @@ static u16 iwl_hw_reg_get_chnl_grp_index(struct iwl_priv *priv,
  */
 static int iwl_hw_reg_get_matched_power_index(struct iwl_priv *priv,
 				       s8 requested_power,
-				       s32 setting_index, s32 * new_index)
+				       s32 setting_index, s32 *new_index)
 {
 	const struct iwl_eeprom_txpower_group *chnl_grp = NULL;
 	s32 index0, index1;
@@ -1982,17 +1983,17 @@ int iwl3945_txpower_set_from_eeprom(struct iwl_priv *priv)
 			continue;
 
 		/* find this channel's channel group (*not* "band") index */
-		ch_info->group_index = iwl_hw_reg_get_chnl_grp_index(priv, ch_info);
+		ch_info->group_index =
+			iwl_hw_reg_get_ch_grp_index(priv, ch_info);
 
 		/* Get this chnlgrp's rate->max/clip-powers table */
 		clip_pwrs = priv->clip_groups[ch_info->group_index].clip_powers;
 
 		/* calculate power index *adjustment* value according to
 		 *  diff between current temperature and factory temperature */
-		delta_index = iwl_hw_reg_adjust_power_by_temp(
-			temperature,
-			(s16)le16_to_cpu(
-				priv->eeprom.groups[ch_info->group_index].temperature));
+		delta_index = iwl_hw_reg_adjust_power_by_temp(temperature,
+				(s16) le16_to_cpu(priv->eeprom.groups[
+					ch_info->group_index].temperature));
 
 		IWL_DEBUG_POWER("Delta index for channel %d: %d [%d]\n",
 				ch_info->channel, delta_index, temperature +
diff --git a/drivers/net/wireless/iwl-4965-rs.c b/drivers/net/wireless/iwl-4965-rs.c
index 7d4a980..07fe911 100644
--- a/drivers/net/wireless/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwl-4965-rs.c
@@ -203,10 +203,9 @@ static int rs_send_lq_cmd(struct iwl_priv *priv,
 		       lq->general_params.single_stream_ant_msk,
 		       lq->general_params.dual_stream_ant_msk);
 #ifdef CONFIG_IWLWIFI_DEBUG
-	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++) {
+	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++)
 		IWL_DEBUG_RATE("lq index %d 0x%X\n",
 			       i, lq->rate_scale_table[i].rate_n_flags);
-	}
 #endif
 
 	if (flags & CMD_ASYNC)
@@ -217,16 +216,15 @@ static int rs_send_lq_cmd(struct iwl_priv *priv,
 	return rc;
 }
 
-static int rs_rate_scale_clear_window(struct iwl_rate_scale_data
-				      *window)
+static int rs_rate_scale_clear_window(struct iwl_rate_scale_data *window)
 {
-
 	window->data = 0;
 	window->success_counter = 0;
 	window->success_ratio = IWL_INVALID_VALUE;
 	window->counter = 0;
 	window->average_tpt = IWL_INVALID_VALUE;
 	window->stamp = 0;
+
 	return 0;
 }
 
@@ -266,20 +264,19 @@ static int rs_collect_tx_data(struct iwl_rate_scale_data *windows,
 		window->data |= 0x1;
 	}
 
-	if (window->counter > 0) {
+	if (window->counter > 0)
 		window->success_ratio = 128 * (100 * window->success_counter)
 					/ window->counter;
-	} else
+	else
 		window->success_ratio = IWL_INVALID_VALUE;
 
-
 	fail_count = window->counter - window->success_counter;
+
 	if ((fail_count >= IWL_RATE_MIN_FAILURE_TH) ||
 	    (window->success_counter >= IWL_RATE_MIN_SUCCESS_TH))
-		window->average_tpt = ((window->success_ratio *
-					tpt + 64) / 128);
+		window->average_tpt = (window->success_ratio * tpt + 64) / 128;
 	else
-		 window->average_tpt = IWL_INVALID_VALUE;
+		window->average_tpt = IWL_INVALID_VALUE;
 
 	window->stamp = jiffies;
 
@@ -456,9 +453,9 @@ static inline s8 rs_use_green(struct iwl_priv *priv)
  *
  */
 static void rs_get_supported_rates(struct iwl_rate_scale_priv *lq_data,
-				    struct ieee80211_hdr *hdr,
-				    enum iwl_table_type rate_type,
-				    u16 * data_rate)
+				   struct ieee80211_hdr *hdr,
+				   enum iwl_table_type rate_type,
+				   u16 *data_rate)
 {
 	if (is_legacy(rate_type))
 		*data_rate = lq_data->active_rate;
@@ -469,8 +466,8 @@ static void rs_get_supported_rates(struct iwl_rate_scale_priv *lq_data,
 			*data_rate = lq_data->active_mimo_rate;
 	}
 
-	if (hdr && (is_multicast_ether_addr(hdr->addr1))
-	    && (lq_data->active_rate_basic))
+	if (hdr && is_multicast_ether_addr(hdr->addr1) &&
+	    lq_data->active_rate_basic)
 		*data_rate = lq_data->active_rate_basic;
 }
 
@@ -1501,9 +1498,9 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 
 	current_tpt = window->average_tpt;
 
-	if (low != IWL_RATE_INVALID) {
+	if (low != IWL_RATE_INVALID)
 		low_tpt = tbl->win[low].average_tpt;
-	}
+
 	if (high != IWL_RATE_INVALID)
 		high_tpt = tbl->win[high].average_tpt;
 
@@ -1515,14 +1512,14 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 		IWL_DEBUG_RATE("decrease rate because of low success_ratio\n");
 		scale_action = -1;
 	} else if ((low_tpt == IWL_INVALID_VALUE) &&
-		   (high_tpt == IWL_INVALID_VALUE)) {
+		   (high_tpt == IWL_INVALID_VALUE))
 		scale_action = 1;
-	} else if ((low_tpt != IWL_INVALID_VALUE) &&
-		   (high_tpt != IWL_INVALID_VALUE)
-		   && (low_tpt < current_tpt)
-		   && (high_tpt < current_tpt)) {
+	else if ((low_tpt != IWL_INVALID_VALUE) &&
+		 (high_tpt != IWL_INVALID_VALUE) &&
+		 (low_tpt < current_tpt) &&
+		 (high_tpt < current_tpt))
 		scale_action = 0;
-	} else {
+	else {
 		if (high_tpt != IWL_INVALID_VALUE) {
 			if (high_tpt > current_tpt)
 				scale_action = 1;
@@ -1557,7 +1554,6 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 			index = low;
 		}
 		break;
-
 	case 1:
 		if (high != IWL_RATE_INVALID) {
 			update_lq = 1;
@@ -1565,30 +1561,29 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 		}
 
 		break;
-
 	case 0:
-
 	default:
 		break;
 	}
 
-	IWL_DEBUG_HT
-	    ("choose rate scale index %d action %d low %d high %d\n",
-	     index, scale_action, low, high);
+	IWL_DEBUG_HT("choose rate scale index %d action %d low %d high %d\n",
+		     index, scale_action, low, high);
 
  lq_update:
 	if (update_lq) {
 		rs_mcs_from_tbl(&mcs_rate, tbl, index, is_green);
 		rs_fill_link_cmd(lq_data, &mcs_rate, &(lq_data->lq), sta);
+
 		if (!rs_send_lq_cmd(priv, &lq_data->lq, CMD_ASYNC))
 			lq_data->commit_lq = 0;
 		else
 			lq_data->commit_lq = 1;
 	}
 	rs_stay_in_table(lq_data);
-	if (!update_lq
-	    && !done_search && !lq_data->stay_in_tbl) {
+
+	if (!update_lq && !done_search && !lq_data->stay_in_tbl) {
 		lq_data->last_tpt = current_tpt;
+
 		if (is_legacy(tbl->lq_type))
 			rs_move_legacy_other(priv, lq_data, index);
 		else if (is_siso(tbl->lq_type))
@@ -1602,18 +1597,19 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 				rs_rate_scale_clear_window(&(tbl->win[i]));
 
 			index = iwl_rate_index_from_plcp(
-				tbl->current_rate.rate_n_flags);
+					tbl->current_rate.rate_n_flags);
 
 			IWL_DEBUG_HT("Switch current  mcs: %X index: %d\n",
 				     tbl->current_rate.rate_n_flags, index);
 			rs_fill_link_cmd(lq_data, &tbl->current_rate,
-					   &(lq_data->lq), sta);
+					 &(lq_data->lq), sta);
 			if (!rs_send_lq_cmd(priv, &lq_data->lq, CMD_ASYNC))
 				lq_data->commit_lq = 0;
 			else
 				lq_data->commit_lq = 1;
 		}
 		tbl1 = &(lq_data->lq_info[lq_data->active_tbl]);
+
 		if (is_legacy(tbl1->lq_type) &&
 #ifdef CONFIG_IWLWIFI_HT
 		    !priv->current_assoc_ht.is_ht &&
@@ -1642,12 +1638,14 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 			lq_data->flush_timer = jiffies;
 	}
 
- out:
+out:
 	rs_mcs_from_tbl(&tbl->current_rate, tbl, index, is_green);
 	i = index;
 	sta->last_txrate = i;
+
 	/* sta->txrate is an index to A mode rates which start
-	*  at IWL_FIRST_OFDM_RATE  */
+	 * at IWL_FIRST_OFDM_RATE
+	 */
 	if ((lq_data->phymode == (u8) MODE_IEEE80211A) ||
 	    (lq_data->phymode == (u8) MODE_ATHEROS_TURBO))
 		sta->txrate = i - IWL_FIRST_OFDM_RATE;
@@ -1793,9 +1791,8 @@ static struct ieee80211_rate *rs_get_rate(void *priv_rate,
 
  done:
 	sta_info_put(sta);
-	if ((i < 0) || (i > IWL_RATE_COUNT)) {
+	if ((i < 0) || (i > IWL_RATE_COUNT))
 		return rs_get_lowest_rate(local);
-	}
 
 	return &priv->ieee_rates[i];
 }
@@ -1927,7 +1924,8 @@ static int rs_fill_link_cmd(struct iwl_rate_scale_priv *lq_data,
 		repeat_cur_rate = IWL_HT_NUMBER_TRY;
 
 	lq_cmd->rate_scale_table[index].rate_n_flags = tx_mcs->rate_n_flags;
-	lq_cmd->general_params.mimo_delimiter = is_mimo(tbl_type.lq_type) ? 1 : 0;
+	lq_cmd->general_params.mimo_delimiter =
+			is_mimo(tbl_type.lq_type) ? 1 : 0;
 	new_rate.rate_n_flags = tx_mcs->rate_n_flags;
 
 	if (is_mimo(tbl_type.lq_type) || (tbl_type.antenna_type == ANT_MAIN))
@@ -1940,8 +1938,9 @@ static int rs_fill_link_cmd(struct iwl_rate_scale_priv *lq_data,
 
 	while (index < LINK_QUAL_MAX_RETRY_NUM) {
 		while (repeat_cur_rate && (index < LINK_QUAL_MAX_RETRY_NUM)) {
-			if (is_legacy(tbl_type.lq_type)){
-				if (ant_toggle_count < NUM_TRY_BEFORE_ANTENNA_TOGGLE)
+			if (is_legacy(tbl_type.lq_type)) {
+				if (ant_toggle_count <
+				    NUM_TRY_BEFORE_ANTENNA_TOGGLE)
 					ant_toggle_count++;
 				else {
 					rs_toggle_antenna(&new_rate, &tbl_type);
@@ -1954,13 +1953,13 @@ static int rs_fill_link_cmd(struct iwl_rate_scale_priv *lq_data,
 			index++;
 		}
 		rs_get_tbl_info_from_mcs(&lq_cmd->rate_scale_table[index - 1],
-					  lq_data->phymode,
-					  &tbl_type, &rate_idx);
+					 lq_data->phymode, &tbl_type,
+					 &rate_idx);
 		if (is_mimo(tbl_type.lq_type))
 			lq_cmd->general_params.mimo_delimiter = index;
 
 		rs_get_lower_rate(lq_data, &tbl_type, rate_idx,
-				     use_ht_possible, &new_rate, sta);
+				  use_ht_possible, &new_rate, sta);
 
 		if (is_legacy(tbl_type.lq_type)) {
 			if (ant_toggle_count < NUM_TRY_BEFORE_ANTENNA_TOGGLE)
@@ -1970,21 +1969,20 @@ static int rs_fill_link_cmd(struct iwl_rate_scale_priv *lq_data,
 				ant_toggle_count = 1;
 			}
 			repeat_cur_rate = IWL_NUMBER_TRY;
-		} else {
+		} else
 			repeat_cur_rate = IWL_HT_NUMBER_TRY;
-		}
 
 		use_ht_possible = 0;
 
 		lq_cmd->rate_scale_table[index].rate_n_flags =
-		    new_rate.rate_n_flags;
-		/*lq_cmd->rate_scale_table[index].rate_n_flags = 0x800d; */
+				new_rate.rate_n_flags;
+		/* lq_cmd->rate_scale_table[index].rate_n_flags = 0x800d; */
 
 		index++;
 		repeat_cur_rate--;
 	}
 
-	/*lq_cmd->rate_scale_table[0].rate_n_flags = 0x800d; */
+	/* lq_cmd->rate_scale_table[0].rate_n_flags = 0x800d; */
 
 	lq_cmd->general_params.dual_stream_ant_msk = 3;
 	lq_cmd->agg_params.agg_dis_start_th = 3;
diff --git a/drivers/net/wireless/iwl-4965.c b/drivers/net/wireless/iwl-4965.c
index 2e97e6b..6b8fd73 100644
--- a/drivers/net/wireless/iwl-4965.c
+++ b/drivers/net/wireless/iwl-4965.c
@@ -105,7 +105,7 @@ static u8 is_single_stream(struct iwl_priv *priv)
  * This does not determine *which* chains to use, just how many.
  */
 static int iwl4965_get_rx_chain_counter(struct iwl_priv *priv,
-					u8 * idle_state, u8 * rx_state)
+					u8 *idle_state, u8 *rx_state)
 {
 	u8 is_single = is_single_stream(priv);
 	u8 is_cam = (priv->status & STATUS_POWER_PMI) ? 0 : 1;
@@ -205,21 +205,17 @@ static int iwl4965_nic_set_pwr_src(struct iwl_priv *priv, int pwr_max)
 		u32 val;
 		rc = pci_read_config_dword(priv->pci_dev, 0x0C8, &val);
 
-		if (val & PCI_CFG_PMC_PME_FROM_D3COLD_SUPPORT) {
+		if (val & PCI_CFG_PMC_PME_FROM_D3COLD_SUPPORT)
 			iwl_set_bits_mask_restricted_reg(
 				priv, ALM_APMG_PS_CTL,
 				APMG_PS_CTRL_REG_VAL_POWER_SRC_VAUX,
 				~APMG_PS_CTRL_REG_MSK_POWER_SRC);
-
-		}
-	} else {
+	} else
 		iwl_set_bits_mask_restricted_reg(
 			priv, ALM_APMG_PS_CTL,
 			APMG_PS_CTRL_REG_VAL_POWER_SRC_VMAIN,
 			~APMG_PS_CTRL_REG_MSK_POWER_SRC);
 
-	}
-
 	iwl_release_restricted_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -262,7 +258,6 @@ static int iwl4965_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 	 */
 
 	iwl_release_restricted_access(priv);
-
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
@@ -279,9 +274,9 @@ static int iwl4965_kw_init(struct iwl_priv *priv)
 		goto out;
 
 	iwl_write_restricted(priv, IWL_FH_KW_MEM_ADDR_REG,
-			     (priv->kw.dma_addr >> 4));
+			     priv->kw.dma_addr >> 4);
 	iwl_release_restricted_access(priv);
- out:
+out:
 	spin_unlock_irqrestore(&priv->lock, flags);
 	return rc;
 }
@@ -290,6 +285,7 @@ static int iwl4965_kw_alloc(struct iwl_priv *priv)
 {
 	struct pci_dev *dev = priv->pci_dev;
 	struct iwl_kw *kw = &priv->kw;
+
 	kw->size = IWL4965_KW_SIZE;	/* TBW need set somewhere else */
 	kw->v_addr = pci_alloc_consistent(dev, kw->size, &kw->dma_addr);
 	if (!kw->v_addr)
@@ -301,38 +297,37 @@ static int iwl4965_kw_alloc(struct iwl_priv *priv)
 #define CHECK_AND_PRINT(x) ((eeprom_ch->flags & EEPROM_CHANNEL_##x) \
 			    ? # x " " : "")
 
-int iwl4965_set_fat_chan_info(struct iwl_priv *priv, int phymode,
-			      int channel,
+int iwl4965_set_fat_chan_info(struct iwl_priv *priv, int phymode, int channel,
 			      const struct iwl_eeprom_channel *eeprom_ch,
 			      u8 fat_extension_channel)
 {
 	struct iwl_channel_info *ch_info;
 
-	ch_info = (struct iwl_channel_info *)iwl_get_channel_info(priv,
-						phymode,
-						channel);
+	ch_info = (struct iwl_channel_info *)
+			iwl_get_channel_info(priv, phymode, channel);
+
 	if (!is_channel_valid(ch_info))
 		return -1;
 
-		IWL_DEBUG_INFO("FAT Ch. %d [%sGHz] %s%s%s%s%s%s(" BIT_FMT8
-				" %ddBm): Ad-Hoc %ssupported\n",
-				ch_info->channel,
-				is_channel_a_band(ch_info) ?
-				"5.2" : "2.4",
-				CHECK_AND_PRINT(IBSS),
-				CHECK_AND_PRINT(ACTIVE),
-				CHECK_AND_PRINT(RADAR),
-				CHECK_AND_PRINT(WIDE),
-				CHECK_AND_PRINT(NARROW),
-				CHECK_AND_PRINT(DFS),
-				BIT_ARG8(eeprom_ch->flags),
-				eeprom_ch->
-				max_power_avg,
-				((eeprom_ch->
-				flags & EEPROM_CHANNEL_IBSS)
-				&& !(eeprom_ch->
-				flags & EEPROM_CHANNEL_RADAR))
-				? "" : "not ");
+	IWL_DEBUG_INFO("FAT Ch. %d [%sGHz] %s%s%s%s%s%s(" BIT_FMT8
+			" %ddBm): Ad-Hoc %ssupported\n",
+			ch_info->channel,
+			is_channel_a_band(ch_info) ?
+			"5.2" : "2.4",
+			CHECK_AND_PRINT(IBSS),
+			CHECK_AND_PRINT(ACTIVE),
+			CHECK_AND_PRINT(RADAR),
+			CHECK_AND_PRINT(WIDE),
+			CHECK_AND_PRINT(NARROW),
+			CHECK_AND_PRINT(DFS),
+			BIT_ARG8(eeprom_ch->flags),
+			eeprom_ch->
+			max_power_avg,
+			((eeprom_ch->
+			flags & EEPROM_CHANNEL_IBSS)
+			&& !(eeprom_ch->
+			flags & EEPROM_CHANNEL_RADAR))
+			? "" : "not ");
 
 	ch_info->fat_eeprom = *eeprom_ch;
 	ch_info->fat_max_power_avg = eeprom_ch->max_power_avg;
@@ -349,11 +344,11 @@ static void iwl4965_kw_free(struct iwl_priv *priv)
 {
 	struct pci_dev *dev = priv->pci_dev;
 	struct iwl_kw *kw = &priv->kw;
+
 	if (kw->v_addr) {
 		pci_free_consistent(dev, kw->size, kw->v_addr, kw->dma_addr);
 		memset(kw, 0, sizeof(*kw));
 	}
-
 }
 
 /**
@@ -581,10 +576,10 @@ int iwl_hw_nic_stop_master(struct iwl_priv *priv)
 	reg_val = iwl_read32(priv, CSR_GP_CNTRL);
 
 	if (CSR_GP_CNTRL_REG_FLAG_MAC_POWER_SAVE ==
-	    (reg_val & CSR_GP_CNTRL_REG_MSK_POWER_SAVE_TYPE)) {
+	    (reg_val & CSR_GP_CNTRL_REG_MSK_POWER_SAVE_TYPE))
 		IWL_DEBUG_INFO
 		    ("Card in power save, master is already stopped\n");
-	} else {
+	else {
 		rc = iwl_poll_bit(priv,
 				  CSR_RESET,
 				  CSR_RESET_REG_FLAG_MASTER_DISABLED,
@@ -923,10 +918,8 @@ static int iwl4965_sens_energy_cck(struct iwl_priv *priv,
 			data->auto_corr_cck_mrc =
 					 max((u32)AUTO_CORR_MIN_CCK_MRC, val);
 
-		} else {
+		} else
 			IWL_DEBUG_CALIB("... but not changing sensitivity\n");
-		}
-
 
 	/* Else we got a healthy number of false alarms, keep status quo */
 	} else {
@@ -946,9 +939,10 @@ static int iwl4965_sens_energy_cck(struct iwl_priv *priv,
 	}
 
 	/* Make sure the energy threshold does not go above the measured
-	 *   energy of the desired Rx signals (reduced by backoff margin),
-	 *   or else we might start missing Rx frames.
-	 * Lower value is higher energy, so we use max()! */
+	 * energy of the desired Rx signals (reduced by backoff margin),
+	 * or else we might start missing Rx frames.
+	 * Lower value is higher energy, so we use max()!
+	 */
 	data->nrg_th_cck = max(max_nrg_cck, data->nrg_th_cck);
 	IWL_DEBUG_CALIB("new nrg_th_cck %u\n", data->nrg_th_cck);
 
@@ -1016,10 +1010,9 @@ static int iwl4965_sens_auto_corr_ofdm(struct iwl_priv *priv,
 				max((u32)AUTO_CORR_MIN_OFDM_MRC_X1, val);
 	}
 
-	else {
+	else
 		IWL_DEBUG_CALIB("min FA %u < norm FA %u < max FA %u OK\n",
 			 min_false_alarms, false_alarms, max_false_alarms);
-	}
 
 	return 0;
 }
@@ -1392,9 +1385,8 @@ static void iwl4965_noise_calibration(struct iwl_priv *priv,
 
 				data->delta_gain_code[i] =
 					(data->delta_gain_code[i] | (1 << 2));
-			} else {
+			} else
 				data->delta_gain_code[i] = 0;
-			}
 		}
 		IWL_DEBUG_CALIB("delta_gain_codes: a %d b %d c %d\n",
 			     data->delta_gain_code[0],
@@ -1561,10 +1553,9 @@ static void iwl4965_bg_sensitivity_work(struct work_struct *work)
 					IWL_SENS_CALIB_NEED_REINIT) {
 			iwl4965_init_sensitivity(priv, CMD_ASYNC, 0);
 			priv->sensitivity_data.state = IWL_SENS_CALIB_ALLOWED;
-		} else {
+		} else
 			iwl4965_sensitivity_calibration(priv,
 							&priv->statistics);
-		}
 	}
 
 	mutex_unlock(&priv->mutex);
@@ -1614,24 +1605,24 @@ static void iwl4965_set_wr_ptrs(struct iwl_priv *priv, int txq_id, u32 index)
 /*
  * Acquire priv->lock before calling this function !
  */
-static void iwl4965_tx_queue_set_status(struct iwl_priv *priv, struct iwl_tx_queue *txq,
-			    int tx_fifo_id, int scd_retry)
+static void iwl4965_tx_queue_set_status(struct iwl_priv *priv,
+					struct iwl_tx_queue *txq,
+					int tx_fifo_id, int scd_retry)
 {
 	int txq_id = txq->q.id;
 	int active = test_bit(txq_id, &priv->txq_ctx_active_msk)?1:0;
 
-	iwl_write_restricted_reg(priv,
-				 SCD_QUEUE_STATUS_BITS(txq_id),
-				 (active << SCD_QUEUE_STTS_REG_POS_ACTIVE)|
-				 (tx_fifo_id << SCD_QUEUE_STTS_REG_POS_TXF)|
-				 (scd_retry << SCD_QUEUE_STTS_REG_POS_WSL)|
-				 (scd_retry << SCD_QUEUE_STTS_REG_POS_SCD_ACK)|
+	iwl_write_restricted_reg(priv, SCD_QUEUE_STATUS_BITS(txq_id),
+				 (active << SCD_QUEUE_STTS_REG_POS_ACTIVE) |
+				 (tx_fifo_id << SCD_QUEUE_STTS_REG_POS_TXF) |
+				 (scd_retry << SCD_QUEUE_STTS_REG_POS_WSL) |
+				 (scd_retry << SCD_QUEUE_STTS_REG_POS_SCD_ACK) |
 				 SCD_QUEUE_STTS_REG_MSK);
 
 	txq->sched_retry = scd_retry;
 
 	IWL_DEBUG_INFO("%s %s Queue %d on AC %d\n",
-		       (active ? "Activete" : "Deactivate"),
+		       active ? "Activete" : "Deactivate",
 		       scd_retry ? "BA" : "AC", txq_id, tx_fifo_id);
 }
 
@@ -1718,7 +1709,7 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 				 SCD_TXFACT_REG_TXFIFO_MASK(0, 7));
 
 	iwl4965_set_wr_ptrs(priv, IWL_CMD_QUEUE_NUM, 0);
-	iwl4965_txq_ctx_activate(priv,IWL_CMD_QUEUE_NUM);
+	iwl4965_txq_ctx_activate(priv, IWL_CMD_QUEUE_NUM);
 	iwl4965_tx_queue_set_status(priv, &priv->txq[IWL_CMD_QUEUE_NUM],
 				    IWL_CMD_FIFO_NUM, 0);
 	/* map qos queues to fifos one-to-one */
@@ -1850,7 +1841,7 @@ int iwl_hw_reg_set_txpower(struct iwl_priv *priv, s8 power)
 #define IWL_TX_POWER_CCK_COMPENSATION_B_STEP (9)
 #define IWL_TX_POWER_CCK_COMPENSATION_C_STEP (5)
 
-static s32 iwl4965_math_div_round(s32 num, s32 denom, s32 * res)
+static s32 iwl4965_math_div_round(s32 num, s32 denom, s32 *res)
 {
 	s32 sign = 1;
 
@@ -3093,21 +3084,21 @@ static void iwl4965_turn_on_agg_for_tid(struct iwl_priv *priv,
 
 		spin_lock_irqsave(&priv->lq_mngr.lock, flags);
 		if (!available_queues) {
-			if (auto_agg) {
+			if (auto_agg)
 				lq->agg_ctrl.tid_retry |= tid_msk;
-			} else {
+			else {
 				lq->agg_ctrl.requested_ba &= ~tid_msk;
 				lq->agg_ctrl.wait_for_agg_status &= ~tid_msk;
 			}
 		} else if ((auto_agg) &&
-			   ((load <= lq->agg_ctrl.tid_traffic_load_threshold)
-			    || ((lq->agg_ctrl.wait_for_agg_status & tid_msk)))) {
+			   ((load <= lq->agg_ctrl.tid_traffic_load_threshold) ||
+			    ((lq->agg_ctrl.wait_for_agg_status & tid_msk))))
 			lq->agg_ctrl.tid_retry |= tid_msk;
-		} else {
+		else {
 			lq->agg_ctrl.wait_for_agg_status |= tid_msk;
 			spin_unlock_irqrestore(&priv->lq_mngr.lock, flags);
 			iwl4965_perform_addba(priv, tid, 0x40,
-					   lq->agg_ctrl.ba_timeout);
+					      lq->agg_ctrl.ba_timeout);
 			spin_lock_irqsave(&priv->lq_mngr.lock, flags);
 		}
 	}
@@ -3122,13 +3113,13 @@ static void iwl4965_turn_on_agg(struct iwl_priv *priv, u8 tid)
 	lq = (struct iwl_lq_mngr *)&(priv->lq_mngr);
 
 	if ((tid < TID_MAX_LOAD_COUNT))
-		iwl4965_turn_on_agg_for_tid(priv, lq, lq->agg_ctrl.auto_agg, tid);
+		iwl4965_turn_on_agg_for_tid(priv, lq, lq->agg_ctrl.auto_agg,
+					    tid);
 	else if (tid == TID_ALL_SPECIFIED) {
 		if (lq->agg_ctrl.requested_ba) {
 			for (tid = 0; tid < TID_MAX_LOAD_COUNT; tid++)
 				iwl4965_turn_on_agg_for_tid(priv, lq,
-							 lq->agg_ctrl.auto_agg,
-							 tid);
+					lq->agg_ctrl.auto_agg, tid);
 		} else {
 			spin_lock_irqsave(&priv->lq_mngr.lock, flags);
 			lq->agg_ctrl.tid_retry = 0;
@@ -3138,6 +3129,7 @@ static void iwl4965_turn_on_agg(struct iwl_priv *priv, u8 tid)
 	}
 
 }
+
 void iwl4965_turn_off_agg(struct iwl_priv *priv, u8 tid)
 {
 	u32 tid_msk;
@@ -3715,7 +3707,7 @@ struct ieee802_11_elems {
 	u8 ht_extra_param_len;
 };
 
-static int parse_elems(u8 * start, size_t len, struct ieee802_11_elems *elems)
+static int parse_elems(u8 *start, size_t len, struct ieee802_11_elems *elems)
 {
 	size_t left = len;
 	u8 *pos = start;
@@ -3792,9 +3784,9 @@ static void iwl4965_update_ps_mode(struct iwl_priv *priv, u16 ps_bit, u8 *addr)
 	if (sta_id != IWL_INVALID_STATION) {
 		u8 sta_awake = priv->stations[sta_id].
 				ps_status == STA_PS_STATUS_WAKE;
-		if (sta_awake && ps_bit) {
+		if (sta_awake && ps_bit)
 			priv->stations[sta_id].ps_status = STA_PS_STATUS_SLEEP;
-		} else if (!sta_awake && !ps_bit) {
+		else if (!sta_awake && !ps_bit) {
 			iwl4965_sta_modify_ps_wake(priv, sta_id);
 			priv->stations[sta_id].ps_status = STA_PS_STATUS_WAKE;
 		}
@@ -4074,7 +4066,7 @@ static void iwl4965_rx_reply_rx_phy(struct iwl_priv *priv,
 	       sizeof(struct iwl4965_rx_phy_res));
 }
 
-static void iwl4965_rx_missed_beacon_notif (struct iwl_priv *priv,
+static void iwl4965_rx_missed_beacon_notif(struct iwl_priv *priv,
 					   struct iwl_rx_mem_buffer *rxb)
 
 {
@@ -4099,8 +4091,8 @@ static void iwl4965_rx_missed_beacon_notif (struct iwl_priv *priv,
 #ifdef CONFIG_IWLWIFI_HT
 #ifdef CONFIG_IWLWIFI_HT_AGG
 
-static void iwl4965_set_tx_status(struct iwl_priv *priv,int txq_id, int idx,
-				  u32 status,u32 retry_count, u32 rate)
+static void iwl4965_set_tx_status(struct iwl_priv *priv, int txq_id, int idx,
+				  u32 status, u32 retry_count, u32 rate)
 {
 	struct ieee80211_tx_status *tx_status =
 		&(priv->txq[txq_id].txb[idx].status);
@@ -4110,8 +4102,8 @@ static void iwl4965_set_tx_status(struct iwl_priv *priv,int txq_id, int idx,
 }
 
 
-static void iwl_sta_modify_enable_tid_tx(struct iwl_priv *priv, int sta_id,
-						int tid)
+static void iwl_sta_modify_enable_tid_tx(struct iwl_priv *priv,
+					 int sta_id, int tid)
 {
 	unsigned long lock_flags;
 
@@ -4120,6 +4112,7 @@ static void iwl_sta_modify_enable_tid_tx(struct iwl_priv *priv, int sta_id,
 	priv->stations[sta_id].sta.tid_disable_tx &= cpu_to_le32(~(1 << tid));
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 	spin_unlock_irqrestore(&priv->sta_lock, lock_flags);
+
 	iwl_send_add_station(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
 }
 
@@ -4299,16 +4292,15 @@ int iwl4965_tx_queue_agg_enable(struct iwl_priv *priv, int txq_id, int tx_fifo,
 	/* supposes that ssn_idx is valid (!= 0xFFF) */
 	iwl4965_set_wr_ptrs(priv, txq_id, ssn_idx);
 
-	iwl_write_restricted_mem(priv, priv->scd_base_addr +
-				SCD_CONTEXT_QUEUE_OFFSET(txq_id),
-				(SCD_WIN_SIZE << SCD_QUEUE_CTX_REG1_WIN_SIZE_POS) &
-				SCD_QUEUE_CTX_REG1_WIN_SIZE_MSK);
+	iwl_write_restricted_mem(priv,
+			priv->scd_base_addr + SCD_CONTEXT_QUEUE_OFFSET(txq_id),
+			(SCD_WIN_SIZE << SCD_QUEUE_CTX_REG1_WIN_SIZE_POS) &
+			SCD_QUEUE_CTX_REG1_WIN_SIZE_MSK);
 
 	iwl_write_restricted_mem(priv, priv->scd_base_addr +
-				SCD_CONTEXT_QUEUE_OFFSET(txq_id) +
-				sizeof(u32),
-				(SCD_FRAME_LIMIT << SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
-				SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK);
+			SCD_CONTEXT_QUEUE_OFFSET(txq_id) + sizeof(u32),
+			(SCD_FRAME_LIMIT << SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS)
+			& SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK);
 
 	iwl_set_bits_restricted_reg(priv, SCD_INTERRUPT_MASK, (1 << txq_id));
 
@@ -4352,7 +4344,7 @@ int iwl4965_tx_queue_agg_disable(struct iwl_priv *priv, u16 txq_id,
 	iwl4965_set_wr_ptrs(priv, txq_id, ssn_idx);
 
 	iwl_clear_bits_restricted_reg(priv, SCD_INTERRUPT_MASK, (1 << txq_id));
-	iwl4965_txq_ctx_deactivate(priv,txq_id);
+	iwl4965_txq_ctx_deactivate(priv, txq_id);
 	iwl4965_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 0);
 
 	iwl_release_restricted_access(priv);
@@ -4384,7 +4376,7 @@ int iwl4965_init_hw_rates(struct iwl_priv *priv, struct ieee80211_rate *rates)
  * rc80211_simple which is what this driver is currently using.
  *
  */
-void iwl4965_add_station(struct iwl_priv *priv, const u8 * addr, int is_ap)
+void iwl4965_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
 {
 	int i, r;
 	struct iwl_link_quality_cmd link_cmd = {
@@ -4404,9 +4396,9 @@ void iwl4965_add_station(struct iwl_priv *priv, const u8 * addr, int is_ap)
 		r = IWL_RATE_1M_INDEX;
 
 	while (i < LINK_QUAL_MAX_RETRY_NUM) {
-		if (r >= IWL_FIRST_CCK_RATE && r <= IWL_LAST_CCK_RATE) {
+		if (r >= IWL_FIRST_CCK_RATE && r <= IWL_LAST_CCK_RATE)
 			table[i].rate_n_flags |= RATE_MCS_CCK_MSK;
-		}
+
 		table[i].s.rate = iwl_rates[r].plcp;
 		table[i].rate_n_flags |= RATE_MCS_ANT_B_MSK;
 		table[i].rate_n_flags &= ~RATE_MCS_ANT_A_MSK;
@@ -4524,6 +4516,7 @@ void iwl4965_set_rxon_ht(struct iwl_priv *priv,
 			ht_info->extension_chan_offset, ht_info->control_chan);
 	return;
 }
+
 void iwl4965_set_ht_add_station(struct iwl_priv *priv,
 				u8 index, u8 need_to_lock)
 {
@@ -4627,6 +4620,7 @@ static const u16 default_tid_to_ac[] = {
 static int iwl_txq_ctx_activate_free(struct iwl_priv *priv)
 {
 	int txq_id;
+
 	for (txq_id = 0; txq_id < IWL4965_NUM_QUEUES; txq_id++)
 		if (!test_and_set_bit(txq_id, &priv->txq_ctx_active_msk))
 			return txq_id;
@@ -4650,8 +4644,8 @@ int iwl_mac_ht_tx_agg_start(struct ieee80211_hw *hw, u8 *da, u16 tid,
 	else
 		return -EINVAL;
 
-	IWL_WARNING("iwl-AGG iwl_mac_ht_tx_agg_start on da=" MAC_FMT " tid=%d\n",
-		    MAC_ARG(da), tid);
+	IWL_WARNING("iwl-AGG iwl_mac_ht_tx_agg_start on da=" MAC_FMT
+		    " tid=%d\n", MAC_ARG(da), tid);
 
 	sta_id = iwl_hw_find_station(priv, da);
 	if (sta_id == IWL_INVALID_STATION)
diff --git a/drivers/net/wireless/iwl-4965.h b/drivers/net/wireless/iwl-4965.h
index 7fa17ee..db4a02e 100644
--- a/drivers/net/wireless/iwl-4965.h
+++ b/drivers/net/wireless/iwl-4965.h
@@ -36,7 +36,7 @@ struct sta_ht_info;
  */
 static inline void iwl_eeprom_release_semaphore(struct iwl_priv *priv) {}
 
-static inline void iwl4965_add_station(struct iwl_priv *priv, const u8 * addr,
+static inline void iwl4965_add_station(struct iwl_priv *priv, const u8 *addr,
 				       int is_ap) {}
 static inline void iwl4965_set_rxon_ht(struct iwl_priv *priv,
 				       struct sta_ht_info *ht_info) {}
@@ -77,7 +77,7 @@ extern void iwl_eeprom_release_semaphore(struct iwl_priv *priv);
 extern int iwl4965_tx_queue_update_wr_ptr(struct iwl_priv *priv,
 					  struct iwl_tx_queue *txq,
 					  u16 byte_cnt);
-extern void iwl4965_add_station(struct iwl_priv *priv, const u8 * addr,
+extern void iwl4965_add_station(struct iwl_priv *priv, const u8 *addr,
 				int is_ap);
 extern void iwl4965_set_rxon_ht(struct iwl_priv *priv,
 				struct sta_ht_info *ht_info);
diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index 9a5041a..d082a10 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -72,11 +72,11 @@ u32 iwl_debug_level;
  ******************************************************************************/
 
 /* module parameters */
-int iwl_param_disable_hw_scan = 0;
-int iwl_param_debug = 0;
-int iwl_param_disable = 0;      /* def: enable radio */
-int iwl_param_antenna = 0;      /* def: 0 = both antennas (use diversity) */
-int iwl_param_hwcrypto = 0;     /* def: using software encryption */
+int iwl_param_disable_hw_scan;
+int iwl_param_debug;
+int iwl_param_disable;      /* def: enable radio */
+int iwl_param_antenna;      /* def: 0 = both antennas (use diversity) */
+int iwl_param_hwcrypto;     /* def: using software encryption */
 int iwl_param_qos_enable = 1;
 
 /*
@@ -293,13 +293,13 @@ void iwl_tx_queue_free(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 
 	/* first, empty all BD's */
 	for (; q->first_empty != q->last_used;
-	     q->last_used = iwl_queue_inc_wrap(q->last_used, q->n_bd)) {
+	     q->last_used = iwl_queue_inc_wrap(q->last_used, q->n_bd))
 		iwl_hw_tx_queue_free_tfd(priv, txq);
-	}
 
 	len = sizeof(txq->cmd[0]) * q->n_window;
 	if (q->id == IWL_CMD_QUEUE_NUM);
-                len +=  IWL_MAX_SCAN_SIZE;
+		len += IWL_MAX_SCAN_SIZE;
+
 	pci_free_consistent(dev, len, txq->cmd, txq->dma_addr_cmd);
 
 	/* free buffers belonging to queue itself */
@@ -329,13 +329,14 @@ const u8 BROADCAST_ADDR[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 
 /**************************************************************/
 
-static u8 iwl_remove_station(struct iwl_priv *priv, const u8 * bssid, int is_ap)
+static u8 iwl_remove_station(struct iwl_priv *priv, const u8 *bssid, int is_ap)
 {
 	int index = IWL_INVALID_STATION;
 	int i;
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
+
 	if (is_ap) {
 		index = IWL_AP_ID;
 		if ((priv->stations[index].used))
@@ -344,17 +345,17 @@ static u8 iwl_remove_station(struct iwl_priv *priv, const u8 * bssid, int is_ap)
 		index = IWL_BROADCAST_ID;
 		if ((priv->stations[index].used))
 			priv->stations[index].used = 0;
-	} else
+	} else {
 		for (i = IWL_STA_ID; i < priv->num_stations + IWL_STA_ID; i++) {
 			if (priv->stations[i].used &&
-			    !compare_ether_addr(
-				    priv->stations[i].sta.sta.addr, bssid)) {
+			    !compare_ether_addr(priv->stations[i].sta.sta.addr,
+						bssid)) {
 				index = i;
 				priv->stations[index].used = 0;
 				break;
 			}
 		}
-
+	}
 	if (index != IWL_INVALID_STATION) {
 		if (priv->num_stations > 0)
 			priv->num_stations--;
@@ -371,12 +372,12 @@ static void iwl_clear_stations_table(struct iwl_priv *priv)
 	spin_lock_irqsave(&priv->sta_lock, flags);
 
 	priv->num_stations = 0;
-	memset(priv->stations, 0,
-	       IWL_STATION_COUNT * sizeof(struct iwl_station_entry));
+	memset(priv->stations, 0, sizeof(priv->stations));
+
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 }
 
-u8 iwl_add_station(struct iwl_priv *priv, const u8 * bssid, int is_ap, u8 flags)
+u8 iwl_add_station(struct iwl_priv *priv, const u8 *bssid, int is_ap, u8 flags)
 {
 	int i = IWL_STATION_COUNT;
 	int index = IWL_INVALID_STATION;
@@ -398,7 +399,7 @@ u8 iwl_add_station(struct iwl_priv *priv, const u8 * bssid, int is_ap, u8 flags)
 		    !compare_ether_addr(priv->stations[index].sta.sta.addr,
 					bssid))
 			goto done;
-	} else
+	} else {
 		for (i = IWL_STA_ID; i < priv->num_stations + IWL_STA_ID; i++) {
 			if (priv->stations[i].used &&
 			    !compare_ether_addr(priv->stations[i].sta.sta.addr,
@@ -409,6 +410,7 @@ u8 iwl_add_station(struct iwl_priv *priv, const u8 * bssid, int is_ap, u8 flags)
 			    index == IWL_INVALID_STATION)
 				index = i;
 		}
+	}
 
 	if (index != IWL_INVALID_STATION)
 		i = index;
@@ -437,8 +439,8 @@ u8 iwl_add_station(struct iwl_priv *priv, const u8 * bssid, int is_ap, u8 flags)
 
 	station->sta.station_flags |= STA_FLG_TX_RATE_MSK;
 
-	station->current_rate.rate_n_flags = le16_to_cpu(
-		station->sta.rate_n_flags);
+	station->current_rate.rate_n_flags =
+		le16_to_cpu(station->sta.rate_n_flags);
 #endif
 
 #if IWL == 4965
@@ -822,18 +824,18 @@ int iwl_send_statistics_request(struct iwl_priv *priv)
  * NOTE: mutex must be held before calling the this fnction
 */
 static int iwl_rxon_add_station(struct iwl_priv *priv,
-				const u8 * addr, int is_ap)
+				const u8 *addr, int is_ap)
 {
-	u8 i;
+	u8 rc;
 
 	/* Remove this station if it happens to already exist */
 	iwl_remove_station(priv, addr, is_ap);
 
-	i = iwl_add_station(priv, addr, is_ap, 0);
+	rc = iwl_add_station(priv, addr, is_ap, 0);
 
 	iwl4965_add_station(priv, addr, is_ap);
 
-	return i;
+	return rc;
 }
 
 /**
@@ -1470,8 +1472,8 @@ static void iwl_free_frame(struct iwl_priv *priv, struct iwl_frame *frame)
 	list_add(&frame->list, &priv->free_frames);
 }
 
-int iwl_fill_beacon_frame(struct iwl_priv *priv,
-			  struct ieee80211_hdr *hdr, const u8 * dest, int left)
+int iwl_fill_beacon_frame(struct iwl_priv *priv, struct ieee80211_hdr *hdr,
+			  const u8 *dest, int left)
 {
 
 	if (!iwl_is_associated(priv) || !priv->ibss_beacon ||
@@ -1528,7 +1530,7 @@ static int iwl_send_beacon_cmd(struct iwl_priv *priv)
  *
  ******************************************************************************/
 
-static void get_eeprom_mac(struct iwl_priv *priv, u8 * mac)
+static void get_eeprom_mac(struct iwl_priv *priv, u8 *mac)
 {
 	memcpy(mac, priv->eeprom.mac_address, 6);
 }
@@ -1678,9 +1680,9 @@ void iwl_report_frame(struct iwl_priv *priv,
 	if (to_us && (frame_ctl & ~IEEE80211_FCTL_PROTECTED) ==
 	    (IEEE80211_FCTL_FROMDS | IEEE80211_FTYPE_DATA)) {
 		dataframe = 1;
-		if (!group100) {
+		if (!group100)
 			print_summary = 1;	/* print each frame */
-		} else if (priv->framecnt_to_us < 100) {
+		else if (priv->framecnt_to_us < 100) {
 			priv->framecnt_to_us++;
 			print_summary = 0;
 		} else {
@@ -1731,12 +1733,12 @@ void iwl_report_frame(struct iwl_priv *priv,
 		/* print frame summary.
 		 * MAC addresses show just the last byte (for brevity),
 		 *    but you can hack it to show more, if you'd like to. */
-		if (dataframe) {
+		if (dataframe)
 			IWL_DEBUG_RX("%s: mhd=0x%04x, dst=0x%02x, "
 				     "len=%u, rssi=%d, chnl=%d, rate=%u, \n",
 				     title, frame_ctl, header->addr1[5],
 				     length, rssi, channel, rate);
-		} else {
+		else {
 			/* src/dst addresses assume managed mode */
 			IWL_DEBUG_RX("%s: 0x%04x, dst=0x%02x, "
 				     "src=0x%02x, rssi=%u, tim=%lu usec, "
@@ -1766,7 +1768,7 @@ static void iwl_unset_hw_setting(struct iwl_priv *priv)
  *
  * return : set the bit for each supported rate insert in ie
  */
-static u16 iwl_supported_rate_to_ie(u8 * ie, u16 supported_rate,
+static u16 iwl_supported_rate_to_ie(u8 *ie, u16 supported_rate,
 				    u16 basic_rate, int max_count)
 {
 	u16 ret_rates = 0, bit;
@@ -2046,7 +2048,7 @@ static void iwl_activate_qos(struct iwl_priv *priv, u8 force)
 #define NOSLP 0, 0, 0
 #define SLP IWL_POWER_DRIVER_ALLOW_SLEEP_MSK, 0, 0
 #endif
-#define SLP_TIMEOUT(T)  __constant_cpu_to_le32((T) * MSEC_TO_USEC)
+#define SLP_TIMEOUT(T) __constant_cpu_to_le32((T) * MSEC_TO_USEC)
 #define SLP_VEC(X0, X1, X2, X3, X4) {__constant_cpu_to_le32(X0), \
 				     __constant_cpu_to_le32(X1), \
 				     __constant_cpu_to_le32(X2), \
@@ -2068,11 +2070,15 @@ static struct iwl_power_vec_entry range_0[IWL_POWER_AC] = {
 /* for tim > 10 */
 static struct iwl_power_vec_entry range_1[IWL_POWER_AC] = {
 	{{NOSLP, SLP_TIMEOUT(0), SLP_TIMEOUT(0), SLP_VEC(0, 0, 0, 0, 0)}, 0},
-	{{SLP, SLP_TIMEOUT(200), SLP_TIMEOUT(500), SLP_VEC(1, 2, 3, 4, 0xFF)}, 0},
-	{{SLP, SLP_TIMEOUT(200), SLP_TIMEOUT(300), SLP_VEC(2, 4, 6, 7, 0xFF)}, 0},
-	{{SLP, SLP_TIMEOUT(50), SLP_TIMEOUT(100), SLP_VEC(2, 6, 9, 9, 0xFF)}, 0},
+	{{SLP, SLP_TIMEOUT(200), SLP_TIMEOUT(500),
+		 SLP_VEC(1, 2, 3, 4, 0xFF)}, 0},
+	{{SLP, SLP_TIMEOUT(200), SLP_TIMEOUT(300),
+		 SLP_VEC(2, 4, 6, 7, 0xFF)}, 0},
+	{{SLP, SLP_TIMEOUT(50), SLP_TIMEOUT(100),
+		 SLP_VEC(2, 6, 9, 9, 0xFF)}, 0},
 	{{SLP, SLP_TIMEOUT(50), SLP_TIMEOUT(25), SLP_VEC(2, 7, 9, 9, 0xFF)}, 0},
-	{{SLP, SLP_TIMEOUT(25), SLP_TIMEOUT(25), SLP_VEC(4, 7, 10, 10, 0xFF)}, 0}
+	{{SLP, SLP_TIMEOUT(25), SLP_TIMEOUT(25),
+		 SLP_VEC(4, 7, 10, 10, 0xFF)}, 0}
 };
 
 int iwl_power_init_handle(struct iwl_priv *priv)
@@ -2863,7 +2869,6 @@ static int iwl_tx_skb(struct iwl_priv *priv,
 #endif /* CONFIG_IWLWIFI_HT_AGG */
 #endif /* CONFIG_IWLWIFI_HT */
 #endif
-
 	}
 
 	txq = &priv->txq[txq_id];
@@ -2895,13 +2900,13 @@ static int iwl_tx_skb(struct iwl_priv *priv,
 	len_org = len;
 	len = (len + 3) & ~3;
 
-	if (len_org != len) {
+	if (len_org != len)
 		len_org = 1;
-	} else
+	else
 		len_org = 0;
-	txcmd_phys =
-		txq->dma_addr_cmd + sizeof(struct iwl_cmd) * idx +
-		offsetof(struct iwl_cmd, hdr);
+
+	txcmd_phys = txq->dma_addr_cmd + sizeof(struct iwl_cmd) * idx +
+		     offsetof(struct iwl_cmd, hdr);
 
 	iwl_hw_tx_queue_attach_buffer_to_tfd(priv, tfd, txcmd_phys, len);
 
@@ -2911,13 +2916,11 @@ static int iwl_tx_skb(struct iwl_priv *priv,
 	/* 802.11 null functions have no payload... */
 	len = skb->len - hdr_len;
 	if (len) {
-		phys_addr = pci_map_single(priv->pci_dev,
-						       skb->data + hdr_len,
-						       len, PCI_DMA_TODEVICE);
+		phys_addr = pci_map_single(priv->pci_dev, skb->data + hdr_len,
+					   len, PCI_DMA_TODEVICE);
 		iwl_hw_tx_queue_attach_buffer_to_tfd(priv, tfd, phys_addr, len);
 	}
 
-
 #if IWL == 3945
 	/* If there is no payload, then only one TFD is used */
 	if (!len)
@@ -2946,9 +2949,9 @@ static int iwl_tx_skb(struct iwl_priv *priv,
 	out_cmd->cmd.tx.tx_flags &= ~TX_CMD_FLG_ANT_B_MSK;
 #endif
 
-	if (!(ieee80211_get_morefrag(hdr))) {
+	if (!ieee80211_get_morefrag(hdr)) {
 		txq->need_update = 1;
-		if ( qc ) {
+		if (qc) {
 			u8 tid = (u8)(le16_to_cpu(*qc) & 0xf);
 			priv->stations[sta_id].tid[tid].seq_number =
 				seq_number;
@@ -3018,10 +3021,9 @@ static void iwl_set_rate(struct iwl_priv *priv)
 			priv->active_rate |= (1 << rate->val);
 			if (rate->flags & IEEE80211_RATE_BASIC)
 				priv->active_rate_basic |= (1 << rate->val);
-		} else {
+		} else
 			IWL_DEBUG_RATE("Not adding rate %d (plcp %d)\n",
 				       rate->val, iwl_rates[rate->val].plcp);
-		}
 	}
 
 	IWL_DEBUG_RATE("Set active_rate = %0x, active_rate_basic = %0x\n",
@@ -3503,8 +3505,8 @@ static int iwl_is_tx_success(u32 status)
  *
  ******************************************************************************/
 #if IWL == 4965
-#ifdef  CONFIG_IWLWIFI_HT
-#ifdef  CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWLWIFI_HT_AGG
 
 static inline int iwl_get_ra_sta_id(struct iwl_priv *priv,
 				    struct ieee80211_hdr *hdr)
@@ -3546,24 +3548,23 @@ int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 	int txq_id, idx;
 	u16 seq;
 
-	if (agg->wait_for_ba) {
+	if (agg->wait_for_ba)
 		IWL_DEBUG_TX_REPLY("got tx repsons w/o back\n");
-	}
-
 
 	agg->frame_count = tx_resp->frame_count;
 	agg->start_idx = start_idx;
 	agg->rate_n_flags = le32_to_cpu(tx_resp->rate_n_flags);
 	agg->bitmap0 = agg->bitmap1 = 0;
+
 	if (agg->frame_count == 1) {
 		status = le32_to_cpu(frame_status[0]);
 		seq  = status >> 16;
 		idx = SEQ_TO_INDEX(seq);
 		txq_id = SEQ_TO_QUEUE(seq);
 
-/* FIXME: code repetition */
+		/* FIXME: code repetition */
 		IWL_DEBUG_TX_REPLY("FrameCnt = %d, StartIdx=%d idx=%d\n",
-				agg->frame_count, agg->start_idx, idx);
+				   agg->frame_count, agg->start_idx, idx);
 
 		tx_status = &(priv->txq[txq_id].txb[idx].status);
 		tx_status->retry_count = tx_resp->failure_frame;
@@ -3575,9 +3576,7 @@ int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 			IEEE80211_TX_STATUS_ACK : 0;
 		tx_status->control.tx_rate =
 				iwl_hw_get_rate_n_flags(tx_resp->rate_n_flags);
-
-/* FIXME: code repetition end */
-
+		/* FIXME: code repetition end */
 
 		IWL_DEBUG_TX_REPLY("1 Frame 0x%x idx %d failure :%d\n",
 				    status & 0xff, idx, tx_resp->failure_frame);
@@ -3588,16 +3587,15 @@ int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 	} else {
 		u64 bitmap = 0;
 		int start = agg->start_idx;
-		for (i = 0; i < agg->frame_count; i++) {
 
+		for (i = 0; i < agg->frame_count; i++) {
 			status = le32_to_cpu(frame_status[i]);
 			seq  = status >> 16;
 			idx = SEQ_TO_INDEX(seq);
 			txq_id = SEQ_TO_QUEUE(seq);
 
-			if (status &
-				(AGG_TX_STATE_FEW_BYTES_MSK|
-				 AGG_TX_STATE_ABORT_MSK))
+			if (status & (AGG_TX_STATE_FEW_BYTES_MSK |
+				      AGG_TX_STATE_ABORT_MSK))
 				continue;
 
 			IWL_DEBUG_TX_REPLY("FrameCnt = %d, txq_id=%d idx=%d\n",
@@ -3613,7 +3611,6 @@ int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 				return -1;
 			}
 
-
 			IWL_DEBUG_TX_REPLY("AGG Frame i=%d idx %d seq=%d\n",
 					   i, idx, SEQ_TO_SN(hdr->seq_ctrl));
 
@@ -3623,9 +3620,9 @@ int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 				bitmap = bitmap << sh;
 				sh = 0;
 				start = idx;
-			} else if ( sh < -64) {
+			} else if ( sh < -64)
 				sh  = 0xff - (start - idx);
-			} else if (sh < 0) {
+			else if (sh < 0) {
 				sh = start - idx;
 				start = idx;
 				bitmap = bitmap << sh;
@@ -3641,9 +3638,8 @@ int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 		agg->start_idx = start;
 		agg->rate_n_flags = cpu_to_le32(tx_resp->rate_n_flags);
 		IWL_DEBUG_TX_REPLY("Frames %d start_idx=%d bitmap=0x%x\n",
-				agg->frame_count,
-				agg->start_idx,
-				agg->bitmap0);
+				   agg->frame_count, agg->start_idx,
+				   agg->bitmap0);
 
 		if (bitmap)
 			agg->wait_for_ba = 1;
@@ -3666,8 +3662,8 @@ static void iwl_rx_reply_tx(struct iwl_priv *priv,
 	struct iwl_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
 	u32  status = le32_to_cpu(tx_resp->status);
 #if IWL == 4965
-#ifdef  CONFIG_IWLWIFI_HT
-#ifdef  CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWLWIFI_HT_AGG
 	int tid, sta_id;
 #endif
 #endif
@@ -3682,16 +3678,16 @@ static void iwl_rx_reply_tx(struct iwl_priv *priv,
 	}
 
 #if IWL == 4965
-#ifdef  CONFIG_IWLWIFI_HT
-#ifdef  CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWLWIFI_HT_AGG
 	if (txq->sched_retry) {
 		const u32 scd_ssn = iwl_get_scd_ssn(tx_resp);
-		struct ieee80211_hdr *hdr = iwl_tx_queue_get_hdr(priv, txq_id,
-								 index);
+		struct ieee80211_hdr *hdr =
+			iwl_tx_queue_get_hdr(priv, txq_id, index);
 		struct iwl_ht_agg *agg = NULL;
 		__le16 *qc = ieee80211_get_qos_ctrl(hdr);
 
-		if(qc == NULL) {
+		if (qc == NULL) {
 			IWL_ERROR("BUG_ON qc is null!!!!\n");
 			return;
 		}
@@ -3715,8 +3711,8 @@ static void iwl_rx_reply_tx(struct iwl_priv *priv,
 
 		if (txq->q.last_used != (scd_ssn & 0xff)) {
 			index = iwl_queue_dec_wrap(scd_ssn & 0xff, txq->q.n_bd);
-			IWL_DEBUG_TX_REPLY("Retry scheduler reclaim scd_ssn %d index %d\n",
-					    scd_ssn , index);
+			IWL_DEBUG_TX_REPLY("Retry scheduler reclaim scd_ssn "
+					   "%d index %d\n", scd_ssn , index);
 			iwl_tx_queue_reclaim(priv, txq_id, index);
 		}
 	} else {
@@ -3734,31 +3730,27 @@ static void iwl_rx_reply_tx(struct iwl_priv *priv,
 	    iwl_is_tx_success(status) ? IEEE80211_TX_STATUS_ACK : 0;
 
 #if IWL == 3945
-
 	tx_status->control.tx_rate = iwl_rate_index_from_plcp(tx_resp->rate);
 
 	IWL_DEBUG_TX("Tx queue %d Status %s (0x%08x) plcp rate %d retries %d\n",
 			txq_id, iwl_get_tx_fail_reason(status), status,
 			tx_resp->rate, tx_resp->failure_frame);
-
 #elif IWL == 4965
-
 	tx_status->control.tx_rate =
 		iwl_hw_get_rate_n_flags(tx_resp->rate_n_flags);
 
 	IWL_DEBUG_TX("Tx queue %d Status %s (0x%08x) rate_n_flags 0x%x "
-			"retries %d\n",
-			txq_id, iwl_get_tx_fail_reason(status),
-			status, le32_to_cpu(tx_resp->rate_n_flags),
-			tx_resp->failure_frame);
+		     "retries %d\n", txq_id, iwl_get_tx_fail_reason(status),
+		     status, le32_to_cpu(tx_resp->rate_n_flags),
+		     tx_resp->failure_frame);
 #endif
 
 	IWL_DEBUG_TX_REPLY("Tx queue reclaim %d\n", index);
 	if (index != -1)
 		iwl_tx_queue_reclaim(priv, txq_id, index);
 #if IWL == 4965
-#ifdef  CONFIG_IWLWIFI_HT
-#ifdef  CONFIG_IWLWIFI_HT_AGG
+#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWLWIFI_HT_AGG
 	}
 #endif /* CONFIG_IWLWIFI_HT_AGG */
 #endif /* CONFIG_IWLWIFI_HT */
@@ -3770,7 +3762,7 @@ static void iwl_rx_reply_tx(struct iwl_priv *priv,
 
 
 static void iwl_rx_reply_alive(struct iwl_priv *priv,
-			   struct iwl_rx_mem_buffer *rxb)
+			       struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
 	struct iwl_alive_resp *palive;
@@ -4550,16 +4542,16 @@ int iwl_calc_sig_qual(int rssi_dbm, int noise_dbm)
 	 * This formula is a least squares fit of data points collected and
 	 *   compared with a reference system that had a percentage (%) display
 	 *   for signal quality. */
-	} else {
-		sig_qual =
-			(100 * (RSSI_RANGE * RSSI_RANGE) -
-			degradation * (15 * RSSI_RANGE + 62 * degradation)) /
-			(RSSI_RANGE * RSSI_RANGE);
-	}
+	} else
+		sig_qual = (100 * (RSSI_RANGE * RSSI_RANGE) -
+			    degradation * (15 * RSSI_RANGE + 62 * degradation)) /
+			   (RSSI_RANGE * RSSI_RANGE);
+
 	if (sig_qual > 100)
 		sig_qual = 100;
 	else if (sig_qual < 1)
 		sig_qual = 0;
+
 	return sig_qual;
 }
 
@@ -4687,10 +4679,9 @@ int iwl_tx_queue_update_write_ptr(struct iwl_priv *priv,
 
 	/* else not in power-save mode, uCode will never sleep when we're
 	 * trying to tx (during RFKILL, we're not trying to tx). */
-	} else {
+	} else
 		iwl_write32(priv, HBUS_TARG_WRPTR,
 			    txq->q.first_empty | (txq_id << 8));
-	}
 
 	txq->need_update = 0;
 
@@ -4698,7 +4689,6 @@ int iwl_tx_queue_update_write_ptr(struct iwl_priv *priv,
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-
 static void iwl_print_rx_config_cmd(struct iwl_rxon_cmd *rxon)
 {
 	IWL_DEBUG_RADIO("RX CONFIG:\n");
@@ -4722,7 +4712,6 @@ static void iwl_print_rx_config_cmd(struct iwl_rxon_cmd *rxon)
 			MAC_ARG(rxon->bssid_addr));
 	IWL_DEBUG_RADIO("u16 assoc_id: 0x%x\n", le16_to_cpu(rxon->assoc_id));
 }
-
 #endif
 
 static void iwl_enable_interrupts(struct iwl_priv *priv)
@@ -4887,9 +4876,9 @@ static void iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 		ptr += sizeof(u32);
 		time = iwl_read_restricted_mem(priv, ptr);
 		ptr += sizeof(u32);
-		if (mode == 0) {
+		if (mode == 0)
 			IWL_ERROR("0x%08x\t%04u\n", time, ev); /* data, ev */
-		} else {
+		else {
 			data = iwl_read_restricted_mem(priv, ptr);
 			ptr += sizeof(u32);
 			IWL_ERROR("%010u\t0x%08x\t%04u\n", time, data, ev);
@@ -4938,11 +4927,10 @@ static void iwl_dump_nic_event_log(struct iwl_priv *priv)
 		  size, num_wraps);
 
 	/* if uCode has wrapped back to top of log, start at the oldest entry,
-	 *    i.e the next one that uCode would fill. */
-	if (num_wraps) {
+	 * i.e the next one that uCode would fill. */
+	if (num_wraps)
 		iwl_print_event_log(priv, next_entry,
 				    capacity - next_entry, mode);
-	}
 
 	/* (then/else) start at top of log */
 	iwl_print_event_log(priv, 0, next_entry, mode);
@@ -5188,8 +5176,8 @@ static irqreturn_t iwl_isr(int irq, void *data)
 		goto none;
 	}
 
-	IWL_DEBUG_ISR ("ISR inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
-	     inta, inta_mask, inta_fh);
+	IWL_DEBUG_ISR("ISR inta 0x%08x, enabled 0x%08x, fh 0x%08x\n",
+		      inta, inta_mask, inta_fh);
 
 	/* iwl_irq_tasklet() will service interrupts and re-enable them */
 	tasklet_schedule(&priv->irq_tasklet);
@@ -5612,9 +5600,9 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv, int phymode,
 
 		/*scan_pwr_info->tpc.tx_gain; */
 		if ((phymode == MODE_IEEE80211A) ||
-		    (phymode == MODE_ATHEROS_TURBO)) {
+		    (phymode == MODE_ATHEROS_TURBO))
 			scan_ch->tpc.tx_gain = ((1 << 5) | (3 << 3)) | 3;
-		} else {
+		else {
 			scan_ch->tpc.tx_gain = ((1 << 5) | (5 << 3));
 			/* NOTE: if we were doing 6Mb OFDM for scans we'd use
 			 * power level
@@ -5665,7 +5653,7 @@ static void iwl_init_hw_rates(struct iwl_priv *priv,
 			 * which is CCK | PREAMBLE2
 			 */
 			rates[i].flags |= (iwl_rates[i].plcp == 10) ?
-			    IEEE80211_RATE_CCK : IEEE80211_RATE_CCK_2;
+				IEEE80211_RATE_CCK : IEEE80211_RATE_CCK_2;
 		}
 
 		/* Set up which ones are basic rates... */
@@ -5966,7 +5954,7 @@ static int iwl_verify_inst_full(struct iwl_priv *priv, __le32 * image, u32 len)
  *   using sample data 100 bytes apart.  If these sample points are good,
  *   it's a pretty good bet that everything between them is good, too.
  */
-static int iwl_verify_inst_sparse(struct iwl_priv *priv, __le32 * image, u32 len)
+static int iwl_verify_inst_sparse(struct iwl_priv *priv, __le32 *image, u32 len)
 {
 	u32 val;
 	int rc = 0;
@@ -6009,7 +5997,7 @@ static int iwl_verify_inst_sparse(struct iwl_priv *priv, __le32 * image, u32 len
  * iwl_verify_ucode - determine which instruction image is in SRAM,
  *    and verify its contents
  */
-static int iwl_verify_ucode(struct iwl_priv * priv)
+static int iwl_verify_ucode(struct iwl_priv *priv)
 {
 	__le32 *image;
 	u32 len;
@@ -6055,7 +6043,7 @@ static int iwl_verify_ucode(struct iwl_priv * priv)
 
 
 /* check contents of special bootstrap uCode SRAM */
-static int iwl_verify_bsm(struct iwl_priv * priv)
+static int iwl_verify_bsm(struct iwl_priv *priv)
 {
 	__le32 *image = priv->ucode_boot.v_addr;
 	u32 len = priv->ucode_boot.len;
@@ -6117,7 +6105,7 @@ static int iwl_verify_bsm(struct iwl_priv * priv)
  * the runtime uCode instructions and the backup data cache into SRAM,
  * and re-launches the runtime uCode from where it left off.
  */
-static int iwl_load_bsm(struct iwl_priv * priv)
+static int iwl_load_bsm(struct iwl_priv *priv)
 {
 	__le32 *image = priv->ucode_boot.v_addr;
 	u32 len = priv->ucode_boot.len;
@@ -6164,7 +6152,8 @@ static int iwl_load_bsm(struct iwl_priv * priv)
 	for (reg_offset = BSM_SRAM_LOWER_BOUND;
 	     reg_offset < BSM_SRAM_LOWER_BOUND + len;
 	     reg_offset += sizeof(u32), image++)
-		_iwl_write_restricted_reg(priv, reg_offset, le32_to_cpu( *image));
+		_iwl_write_restricted_reg(priv, reg_offset,
+					  le32_to_cpu(*image));
 
 	rc = iwl_verify_bsm(priv);
 	if (rc) {
@@ -6648,12 +6637,12 @@ static void iwl_alive_start(struct iwl_priv *priv)
 
 	iwl_send_power_mode(priv, IWL_POWER_LEVEL(priv->power_mode));
 
-        if (iwl_is_associated(priv)) {
+	if (iwl_is_associated(priv)) {
 		struct iwl_rxon_cmd *active_rxon =
 				(struct iwl_rxon_cmd *)(&priv->active_rxon);
 
 		memcpy(&priv->staging_rxon, &priv->active_rxon,
-			sizeof(priv->staging_rxon));
+		       sizeof(priv->staging_rxon));
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	} else {
 		/* Initialize our rx_config data */
@@ -7087,9 +7076,8 @@ static void iwl_bg_request_scan(struct work_struct *data)
 		scan->direct_scan[0].len = priv->essid_len;
 		memcpy(scan->direct_scan[0].ssid, priv->essid, priv->essid_len);
 		direct_mask = 1;
-	} else {
+	} else
 		direct_mask = 0;
-	}
 
 	/* We don't build a direct scan probe request; the uCode will do
 	 * that based on the direct_mask added to each channel entry */
@@ -7621,9 +7609,9 @@ static int iwl_mac_config_interface(struct ieee80211_hw *hw, int if_id,
 			IWL_DEBUG_MAC80211("bssid was set to: " MAC_FMT "\n",
 					   MAC_ARG(conf->bssid));
 		}
-		if (priv->ibss_beacon) {
+		if (priv->ibss_beacon)
 			dev_kfree_skb(priv->ibss_beacon);
-		}
+
 		priv->ibss_beacon = conf->beacon;
 	}
 
@@ -7700,7 +7688,7 @@ static void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 }
 
 #define IWL_DELAY_NEXT_SCAN (HZ*2)
-static int iwl_mac_hw_scan(struct ieee80211_hw *hw, u8 * ssid, size_t len)
+static int iwl_mac_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
 {
 	int rc = 0;
 	unsigned long flags;
@@ -7750,7 +7738,7 @@ static int iwl_mac_hw_scan(struct ieee80211_hw *hw, u8 * ssid, size_t len)
 	return rc;
 }
 
-static int iwl_mac_set_key(struct ieee80211_hw *hw, set_key_cmd cmd, u8 * addr,
+static int iwl_mac_set_key(struct ieee80211_hw *hw, set_key_cmd cmd, u8 *addr,
 			   struct ieee80211_key_conf *key, int aid)
 {
 	struct iwl_priv *priv = hw->priv;
@@ -8051,7 +8039,7 @@ union ht_cap_info {
 		u16 sig_txop_protection_support	:1;
 	};
 	u16 val;
-}__attribute__ ((packed));
+} __attribute__ ((packed));
 
 union ht_param_info{
 	struct {
@@ -8060,9 +8048,9 @@ union ht_param_info{
 		u8 reserved		:3;
 	};
 	u8 val;
-}__attribute__ ((packed));
+} __attribute__ ((packed));
 
-union ht_exra_param_info{
+union ht_exra_param_info {
 	struct {
 		u8 ext_chan_offset		:2;
 		u8 tx_chan_width		:1;
@@ -8071,7 +8059,7 @@ union ht_exra_param_info{
 		u8 service_interval_granularity	:3;
 	};
 	u8 val;
-}__attribute__ ((packed));
+} __attribute__ ((packed));
 
 union ht_operation_mode{
 	struct {
@@ -8080,7 +8068,7 @@ union ht_operation_mode{
 		u16 reserved	:13;
 	};
 	u16 val;
-}__attribute__ ((packed));
+} __attribute__ ((packed));
 
 
 static int sta_ht_info_init(struct ieee80211_ht_capability *ht_cap,
@@ -8361,9 +8349,9 @@ static ssize_t store_flags(struct device *d,
 	mutex_lock(&priv->mutex);
 	if (priv->staging_rxon.flags != flags) {
 		/* Cancel any currently running scans... */
-		if (iwl_scan_cancel(priv, 100)) {
+		if (iwl_scan_cancel(priv, 100))
 			IWL_WARNING("Could not cancel scan.\n");
-		} else {
+		else {
 			IWL_DEBUG_INFO("Committing rxon.flags = 0x%04X\n",
 				       flags);
 			priv->staging_rxon.flags = flags;
@@ -8395,9 +8383,9 @@ static ssize_t store_filter_flags(struct device *d,
 	mutex_lock(&priv->mutex);
 	if (priv->staging_rxon.filter_flags != filter_flags) {
 		/* Cancel any currently running scans... */
-		if (iwl_scan_cancel(priv, 100)) {
+		if (iwl_scan_cancel(priv, 100))
 			IWL_WARNING("Could not cancel scan.\n");
-		} else {
+		else {
 			IWL_DEBUG_INFO("Committing rxon.filter_flags = "
 				       "0x%04X\n", filter_flags);
 			priv->staging_rxon.filter_flags = filter_flags;
@@ -8449,9 +8437,9 @@ static ssize_t store_tune(struct device *d,
 		}
 
 		/* Cancel any currently running scans... */
-		if (iwl_scan_cancel(priv, 100)) {
+		if (iwl_scan_cancel(priv, 100))
 			IWL_WARNING("Could not cancel scan.\n");
-		} else {
+		else {
 			IWL_DEBUG_INFO("Committing phymode and "
 				       "rxon.channel = %d %d\n",
 				       phymode, channel);
@@ -8708,7 +8696,7 @@ static ssize_t show_channels(struct device *d,
 		    "Displaying %d channels in 2.4GHz band "
 		    "(802.11bg):\n", count);
 
-	for (i = 0; i < count; i++) {
+	for (i = 0; i < count; i++)
 		len += sprintf(&buf[len], "%d: %ddBm: BSS%s%s, %s.\n",
 			       channels[i].chan,
 			       channels[i].power_level,
@@ -8723,7 +8711,6 @@ static ssize_t show_channels(struct device *d,
 			       channels[i].
 			       flag & IEEE80211_CHAN_W_ACTIVE_SCAN ?
 			       "active/passive" : "passive only");
-	}
 
 	hw_mode = iwl_get_hw_mode(priv, MODE_IEEE80211A);
 	if (hw_mode) {
@@ -8734,12 +8721,10 @@ static ssize_t show_channels(struct device *d,
 		count = 0;
 	}
 
-	len +=
-	    sprintf(&buf[len],
-		    "Displaying %d channels in 5.2GHz band "
-		    "(802.11a):\n", count);
+	len += sprintf(&buf[len], "Displaying %d channels in 5.2GHz band "
+		       "(802.11a):\n", count);
 
-	for (i = 0; i < count; i++) {
+	for (i = 0; i < count; i++)
 		len += sprintf(&buf[len], "%d: %ddBm: BSS%s%s, %s.\n",
 			       channels[i].chan,
 			       channels[i].power_level,
@@ -8754,7 +8739,6 @@ static ssize_t show_channels(struct device *d,
 			       channels[i].
 			       flag & IEEE80211_CHAN_W_ACTIVE_SCAN ?
 			       "active/passive" : "passive only");
-	}
 
 	return len;
 }
diff --git a/drivers/net/wireless/iwl-helpers.h b/drivers/net/wireless/iwl-helpers.h
index 94dbb38..c0ea48e 100644
--- a/drivers/net/wireless/iwl-helpers.h
+++ b/drivers/net/wireless/iwl-helpers.h
@@ -314,9 +314,8 @@ static inline const char *iwl_escape_essid(const char *essid, u8 essid_len)
 			*d++ = '\\';
 			*d++ = '0';
 			s++;
-		} else {
+		} else
 			*d++ = *s++;
-		}
 	}
 	*d = '\0';
 	return escaped;
@@ -334,7 +333,7 @@ static inline unsigned long elapsed_jiffies(unsigned long start,
 
 
 static inline int snprint_line(char *buf, size_t count,
-			       const u8 * data, u32 len, u32 ofs)
+			       const u8 *data, u32 len, u32 ofs)
 {
 	int out, i, j, l;
 	char c;
diff --git a/drivers/net/wireless/iwl-io.h b/drivers/net/wireless/iwl-io.h
index e870cd8..0ae031a 100644
--- a/drivers/net/wireless/iwl-io.h
+++ b/drivers/net/wireless/iwl-io.h
@@ -178,10 +178,9 @@ static inline int _iwl_grab_restricted_access(struct iwl_priv *priv)
 			IWL_DEBUG_RF_KILL("Wait for complete power-down, "
 				"gpctl = 0x%08x\n", gp_ctl);
 			mdelay(10);
-		} else {
+		} else
 			IWL_DEBUG_RF_KILL("power-down complete, "
-				"gpctl = 0x%08x\n", gp_ctl);
-		}
+					  "gpctl = 0x%08x\n", gp_ctl);
 	}
 
 	/* this bit wakes up the NIC */
@@ -268,7 +267,7 @@ static inline u32 __iwl_read_restricted(const char *f, u32 l,
 #define iwl_read_restricted(p, r) _iwl_read_restricted(p, r)
 #endif
 
-static void inline _iwl_write_restricted(struct iwl_priv *priv,
+static inline void _iwl_write_restricted(struct iwl_priv *priv,
 					 u32 reg, u32 value)
 {
 	_iwl_write32(priv, reg, value);
@@ -285,9 +284,10 @@ static void __iwl_write_restricted(u32 line,
 	__iwl_write_restricted(__LINE__, priv, reg, value)
 
 static inline void iwl_write_buffer_restricted(struct iwl_priv *priv,
-					       u32 reg, u32 len, u32 * values)
+					       u32 reg, u32 len, u32 *values)
 {
 	u32 count = sizeof(u32);
+
 	if ((priv != NULL) && (values != NULL)) {
 		for (; 0 < len; len -= count, reg += count, values++)
 			_iwl_write_restricted(priv, reg, *values);
@@ -308,19 +308,19 @@ static inline int _iwl_poll_restricted_bit(struct iwl_priv *priv,
 
 	return -ETIMEDOUT;
 }
+
 static inline int __iwl_poll_restricted_bit(const char *f, u32 l,
 					    struct iwl_priv *priv,
 					    u32 addr, u32 mask, int timeout)
 {
 	int rc = _iwl_poll_restricted_bit(priv, addr, mask, timeout);
+
 	if (unlikely(rc == -ETIMEDOUT))
-		IWL_DEBUG_IO
-		    ("poll_restricted_bit(0x%08X, 0x%08X) - timedout - %s %d\n",
-		     addr, mask, f, l);
+		IWL_DEBUG_IO("poll_restricted_bit(0x%08X, 0x%08X) - "
+			     "timedout - %s %d\n", addr, mask, f, l);
 	else
-		IWL_DEBUG_IO
-		    ("poll_restricted_bit(0x%08X, 0x%08X) = 0x%08X - %s %d\n",
-		     addr, mask, rc, f, l);
+		IWL_DEBUG_IO("poll_restricted_bit(0x%08X, 0x%08X) = 0x%08X "
+			     "- %s %d\n", addr, mask, rc, f, l);
 	return rc;
 }
 
@@ -383,7 +383,7 @@ static inline void __iwl_set_bits_restricted_reg(u32 line, struct iwl_priv
 #define _iwl_set_bits_mask_restricted_reg(priv, reg, bits, mask) \
 	_iwl_write_restricted_reg( \
 	    priv, reg, ((_iwl_read_restricted_reg(priv, reg) & mask) | bits))
-static void inline __iwl_set_bits_mask_restricted_reg(u32 line, struct iwl_priv
+static inline void __iwl_set_bits_mask_restricted_reg(u32 line, struct iwl_priv
 						      *priv, u32 reg,
 						      u32 bits, u32 mask)
 {
@@ -417,7 +417,7 @@ static inline void iwl_write_restricted_mem(struct iwl_priv *priv, u32 addr,
 
 static inline void iwl_write_restricted_mem_buffer(struct iwl_priv *priv,
 						   u32 addr, u32 len,
-						   u32 * values)
+						   u32 *values)
 {
 	iwl_write_restricted(priv, HBUS_TARG_MEM_WADDR, addr);
 	for (; 0 < len; len -= sizeof(u32), values++)
@@ -426,7 +426,7 @@ static inline void iwl_write_restricted_mem_buffer(struct iwl_priv *priv,
 
 static inline void iwl_write_restricted_reg_buffer(struct iwl_priv *priv,
 						   u32 reg, u32 len,
-						   u8 * values)
+						   u8 *values)
 {
 	u32 reg_offset = reg;
 	u32 aligment = reg & 0x3;
diff --git a/drivers/net/wireless/iwlwifi.h b/drivers/net/wireless/iwlwifi.h
index 3de6425..002f8e8 100644
--- a/drivers/net/wireless/iwlwifi.h
+++ b/drivers/net/wireless/iwlwifi.h
@@ -520,11 +520,11 @@ struct fw_image_desc {
 /* uCode file layout */
 struct iwl_ucode {
 	__le32 ver;		/* major/minor/subminor */
-	__le32 inst_size;		/* bytes of runtime instructions */
-	__le32 data_size;		/* bytes of runtime data */
-	__le32 init_size;		/* bytes of initialization instructions */
+	__le32 inst_size;	/* bytes of runtime instructions */
+	__le32 data_size;	/* bytes of runtime data */
+	__le32 init_size;	/* bytes of initialization instructions */
 	__le32 init_data_size;	/* bytes of initialization data */
-	__le32 boot_size;		/* bytes of bootstrap instructions */
+	__le32 boot_size;	/* bytes of bootstrap instructions */
 	u8 data[0];		/* data in same order as "size" elements */
 };
 
@@ -590,7 +590,7 @@ struct iwl_addsta_cmd;
 extern int iwl_send_add_station(struct iwl_priv *priv,
 				struct iwl_addsta_cmd *sta, u8 flags);
 extern const char *iwl_get_tx_fail_reason(u32 status);
-extern u8 iwl_add_station(struct iwl_priv *priv, const u8 * bssid,
+extern u8 iwl_add_station(struct iwl_priv *priv, const u8 *bssid,
 			  int is_ap, u8 flags);
 extern int iwl_is_network_packet(struct iwl_priv *priv,
 				 struct ieee80211_hdr *header);
@@ -631,7 +631,7 @@ extern int iwl_send_cmd_pdu(struct iwl_priv *priv, u8 id, u16 len,
 extern int __must_check iwl_send_cmd(struct iwl_priv *priv,
 				     struct iwl_host_cmd *cmd);
 extern int iwl_fill_beacon_frame(struct iwl_priv *priv,
-				 struct ieee80211_hdr *hdr, const u8 * dest,
+				 struct ieee80211_hdr *hdr, const u8 *dest,
 				 int left);
 extern int iwl_rx_queue_update_write_ptr(struct iwl_priv *priv,
 					 struct iwl_rx_queue *q);
@@ -715,7 +715,7 @@ extern int iwl4965_get_temperature(const struct iwl_priv *priv);
  * not yet been merged into a single common layer for managing the
  * station tables.
  */
-extern u8 iwl_hw_find_station(struct iwl_priv *priv, const u8 * bssid);
+extern u8 iwl_hw_find_station(struct iwl_priv *priv, const u8 *bssid);
 
 extern int iwl_hw_channel_switch(struct iwl_priv *priv, u8 channel);
 extern int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index);
-- 
1.5.2
