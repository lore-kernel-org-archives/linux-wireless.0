Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:10226 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786AbXKLDo2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2007 22:44:28 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Mohamed Abbas <mabbas@linux.intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 1/2] iwl3945: place CCK rates in front of OFDM for supported rates
Date: Mon, 12 Nov 2007 11:37:42 +0800
Message-Id: <11948386652152-git-send-email-yi.zhu@intel.com> (sfid-20071112_034436_513516_22F5062C)
In-Reply-To: <11948386633181-git-send-email-yi.zhu@intel.com>
References: <11948386633181-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mabbas@linux.intel.com>

The patch fixes association failure (reason = 18) bug by arranging CCK
rates before OFDM rates. This patch will register with mac80211 the
modified rate arrangement with CCK rate first. Change rate scale algorithm
also to deal with rate change. Fix Txpower and rate Table commands to be
constructed correctly after rearrangement.

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c  |   56 ++++++++++--
 drivers/net/wireless/iwlwifi/iwl-3945-rs.h  |   29 +++++-
 drivers/net/wireless/iwlwifi/iwl-3945.c     |  126 +++++++++++++++------------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 +-
 4 files changed, 143 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index 78a546c..32025ce 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -69,19 +69,19 @@ struct iwl_rate_scale_priv {
 };
 
 static s32 iwl_expected_tpt_g[IWL_RATE_COUNT] = {
-	0, 0, 76, 104, 130, 168, 191, 202, 7, 13, 35, 58
+	7, 13, 35, 58, 0, 0, 76, 104, 130, 168, 191, 202
 };
 
 static s32 iwl_expected_tpt_g_prot[IWL_RATE_COUNT] = {
-	0, 0, 0, 80, 93, 113, 123, 125, 7, 13, 35, 58
+	7, 13, 35, 58, 0, 0, 0, 80, 93, 113, 123, 125
 };
 
 static s32 iwl_expected_tpt_a[IWL_RATE_COUNT] = {
-	40, 57, 72, 98, 121, 154, 177, 186, 0, 0, 0, 0
+	0, 0, 0, 0, 40, 57, 72, 98, 121, 154, 177, 186
 };
 
 static s32 iwl_expected_tpt_b[IWL_RATE_COUNT] = {
-	0, 0, 0, 0, 0, 0, 0, 0, 7, 13, 35, 58
+	7, 13, 35, 58, 0, 0, 0, 0, 0, 0, 0, 0
 };
 
 struct iwl_tpt_entry {
@@ -348,6 +348,10 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 
 	sta->last_txrate = sta->txrate;
 
+	/* For MODE_IEEE80211A mode it start at IWL_FIRST_OFDM_RATE */
+        if (local->hw.conf.phymode == MODE_IEEE80211A)
+                sta->last_txrate += IWL_FIRST_OFDM_RATE;
+
 	IWL_DEBUG_RATE("leave\n");
 }
 
@@ -415,6 +419,33 @@ static void rs_free_sta(void *priv, void *priv_sta)
 	IWL_DEBUG_RATE("leave\n");
 }
 
+
+/*
+ * get ieee prev rate from rate scale table.
+ * for A and B mode we need to overright prev
+ * value
+ */
+static int rs_adjust_next_rate(struct iwl_priv *priv, int rate)
+{
+	int next_rate = iwl_get_prev_ieee_rate(rate);
+
+	switch (priv->phymode) {
+	case MODE_IEEE80211A:
+		if (rate == IWL_RATE_12M_INDEX)
+			next_rate = IWL_RATE_9M_INDEX;
+		else if (rate == IWL_RATE_6M_INDEX)
+			next_rate = IWL_RATE_6M_INDEX;
+		break;
+	case MODE_IEEE80211B:
+		if (rate == IWL_RATE_11M_INDEX_TABLE)
+			next_rate = IWL_RATE_5M_INDEX_TABLE;
+		break;
+	default:
+		break;
+	}
+
+	return next_rate;
+}
 /**
  * rs_tx_status - Update rate control values based on Tx results
  *
@@ -477,7 +508,8 @@ static void rs_tx_status(void *priv_rate,
 			last_index = scale_rate_index;
 		} else {
 			current_count = priv->retry_rate;
-			last_index = iwl_get_prev_ieee_rate(scale_rate_index);
+			last_index = rs_adjust_next_rate(priv,
+							 scale_rate_index);
 		}
 
 		/* Update this rate accounting for as many retries
@@ -492,9 +524,10 @@ static void rs_tx_status(void *priv_rate,
 
 		if (retries)
 			scale_rate_index =
-			    iwl_get_prev_ieee_rate(scale_rate_index);
+			    rs_adjust_next_rate(priv, scale_rate_index);
 	}
 
+
 	/* Update the last index window with success/failure based on ACK */
 	IWL_DEBUG_RATE("Update rate %d with %s.\n",
 		       last_index,
@@ -670,7 +703,10 @@ static struct ieee80211_rate *rs_get_rate(void *priv_rate,
 	}
 
 	rate_mask = sta->supp_rates;
-	index = min(sta->txrate & 0xffff, IWL_RATE_COUNT - 1);
+	index = min(sta->last_txrate & 0xffff, IWL_RATE_COUNT - 1);
+
+	if (priv->phymode == (u8) MODE_IEEE80211A)
+		rate_mask = rate_mask << IWL_FIRST_OFDM_RATE;
 
 	rs_priv = (void *)sta->rate_ctrl_priv;
 
@@ -799,7 +835,11 @@ static struct ieee80211_rate *rs_get_rate(void *priv_rate,
  out:
 
 	sta->last_txrate = index;
-	sta->txrate = sta->last_txrate;
+	if (priv->phymode == (u8) MODE_IEEE80211A)
+		sta->txrate = sta->last_txrate - IWL_FIRST_OFDM_RATE;
+	else
+		sta->txrate = sta->last_txrate;
+
 	sta_info_put(sta);
 
 	IWL_DEBUG_RATE("leave: %d\n", index);
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.h b/drivers/net/wireless/iwlwifi/iwl-3945-rs.h
index 09fa1a7..4f21bc7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.h
@@ -36,10 +36,17 @@ struct iwl_rate_info {
 	u8 next_rs;		/* next rate used in rs algo */
 	u8 prev_rs_tgg;		/* previous rate used in TGG rs algo */
 	u8 next_rs_tgg;		/* next rate used in TGG rs algo */
+        u8 table_rs_index;	/* index in rate scale table cmd */
+        u8 prev_table_rs;	/* prev in rate table cmd */
+
 };
 
 enum {
-	IWL_RATE_6M_INDEX = 0,
+	IWL_RATE_1M_INDEX = 0,
+	IWL_RATE_2M_INDEX,
+	IWL_RATE_5M_INDEX,
+	IWL_RATE_11M_INDEX,
+	IWL_RATE_6M_INDEX,
 	IWL_RATE_9M_INDEX,
 	IWL_RATE_12M_INDEX,
 	IWL_RATE_18M_INDEX,
@@ -47,16 +54,28 @@ enum {
 	IWL_RATE_36M_INDEX,
 	IWL_RATE_48M_INDEX,
 	IWL_RATE_54M_INDEX,
-	IWL_RATE_1M_INDEX,
-	IWL_RATE_2M_INDEX,
-	IWL_RATE_5M_INDEX,
-	IWL_RATE_11M_INDEX,
 	IWL_RATE_COUNT,
 	IWL_RATE_INVM_INDEX,
 	IWL_RATE_INVALID = IWL_RATE_INVM_INDEX
 };
 
 enum {
+	IWL_RATE_6M_INDEX_TABLE = 0,
+	IWL_RATE_9M_INDEX_TABLE,
+	IWL_RATE_12M_INDEX_TABLE,
+	IWL_RATE_18M_INDEX_TABLE,
+	IWL_RATE_24M_INDEX_TABLE,
+	IWL_RATE_36M_INDEX_TABLE,
+	IWL_RATE_48M_INDEX_TABLE,
+	IWL_RATE_54M_INDEX_TABLE,
+	IWL_RATE_1M_INDEX_TABLE,
+	IWL_RATE_2M_INDEX_TABLE,
+	IWL_RATE_5M_INDEX_TABLE,
+	IWL_RATE_11M_INDEX_TABLE,
+	IWL_RATE_INVM_INDEX_TABLE = IWL_RATE_INVM_INDEX,
+};
+
+enum {
 	IWL_FIRST_OFDM_RATE = IWL_RATE_6M_INDEX,
 	IWL_LAST_OFDM_RATE = IWL_RATE_54M_INDEX,
 	IWL_FIRST_CCK_RATE = IWL_RATE_1M_INDEX,
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index e9cb40e..39e7b07 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -51,7 +51,9 @@
 				    IWL_RATE_##rp##M_INDEX, \
 				    IWL_RATE_##rn##M_INDEX, \
 				    IWL_RATE_##pp##M_INDEX, \
-				    IWL_RATE_##np##M_INDEX }
+				    IWL_RATE_##np##M_INDEX, \
+				    IWL_RATE_##r##M_INDEX_TABLE, \
+				    IWL_RATE_##ip##M_INDEX_TABLE }
 
 /*
  * Parameter order:
@@ -62,6 +64,10 @@
  *
  */
 const struct iwl_rate_info iwl_rates[IWL_RATE_COUNT] = {
+	IWL_DECLARE_RATE_INFO(1, INV, 2, INV, 2, INV, 2),    /*  1mbps */
+	IWL_DECLARE_RATE_INFO(2, 1, 5, 1, 5, 1, 5),          /*  2mbps */
+	IWL_DECLARE_RATE_INFO(5, 2, 6, 2, 11, 2, 11),        /*5.5mbps */
+	IWL_DECLARE_RATE_INFO(11, 9, 12, 5, 12, 5, 18),      /* 11mbps */
 	IWL_DECLARE_RATE_INFO(6, 5, 9, 5, 11, 5, 11),        /*  6mbps */
 	IWL_DECLARE_RATE_INFO(9, 6, 11, 5, 11, 5, 11),       /*  9mbps */
 	IWL_DECLARE_RATE_INFO(12, 11, 18, 11, 18, 11, 18),   /* 12mbps */
@@ -70,10 +76,6 @@ const struct iwl_rate_info iwl_rates[IWL_RATE_COUNT] = {
 	IWL_DECLARE_RATE_INFO(36, 24, 48, 24, 48, 24, 48),   /* 36mbps */
 	IWL_DECLARE_RATE_INFO(48, 36, 54, 36, 54, 36, 54),   /* 48mbps */
 	IWL_DECLARE_RATE_INFO(54, 48, INV, 48, INV, 48, INV),/* 54mbps */
-	IWL_DECLARE_RATE_INFO(1, INV, 2, INV, 2, INV, 2),    /*  1mbps */
-	IWL_DECLARE_RATE_INFO(2, 1, 5, 1, 5, 1, 5),          /*  2mbps */
-	IWL_DECLARE_RATE_INFO(5, 2, 6, 2, 11, 2, 11),        /*5.5mbps */
-	IWL_DECLARE_RATE_INFO(11, 9, 12, 5, 12, 5, 18),      /* 11mbps */
 };
 
 /* 1 = enable the iwl_disable_events() function */
@@ -658,10 +660,11 @@ void iwl_hw_build_tx_cmd_rate(struct iwl_priv *priv,
 	cmd->cmd.tx.tx_flags = tx_flags;
 
 	/* OFDM */
-	cmd->cmd.tx.supp_rates[0] = rate_mask & IWL_OFDM_RATES_MASK;
+	cmd->cmd.tx.supp_rates[0] =
+	   ((rate_mask & IWL_OFDM_RATES_MASK) >> IWL_FIRST_OFDM_RATE) & 0xFF;
 
 	/* CCK */
-	cmd->cmd.tx.supp_rates[1] = (rate_mask >> 8) & 0xF;
+	cmd->cmd.tx.supp_rates[1] = (rate_mask & 0xF);
 
 	IWL_DEBUG_RATE("Tx sta id: %d, rate: %d (plcp), flags: 0x%4X "
 		       "cck/ofdm mask: 0x%x/0x%x\n", sta_id,
@@ -1415,7 +1418,7 @@ static void iwl_hw_reg_set_scan_power(struct iwl_priv *priv, u32 scan_tbl_index,
 	/* use this channel group's 6Mbit clipping/saturation pwr,
 	 *   but cap at regulatory scan power restriction (set during init
 	 *   based on eeprom channel data) for this channel.  */
-	power = min(ch_info->scan_power, clip_pwrs[IWL_RATE_6M_INDEX]);
+	power = min(ch_info->scan_power, clip_pwrs[IWL_RATE_6M_INDEX_TABLE]);
 
 	/* further limit to user's max power preference.
 	 * FIXME:  Other spectrum management power limitations do not
@@ -1430,7 +1433,7 @@ static void iwl_hw_reg_set_scan_power(struct iwl_priv *priv, u32 scan_tbl_index,
 	 *   *index*. */
 	power_index = ch_info->power_info[rate_index].power_table_index
 	    - (power - ch_info->power_info
-	       [IWL_RATE_6M_INDEX].requested_power) * 2;
+	       [IWL_RATE_6M_INDEX_TABLE].requested_power) * 2;
 
 	/* store reference index that we use when adjusting *all* scan
 	 *   powers.  So we can accommodate user (all channel) or spectrum
@@ -1459,7 +1462,7 @@ static void iwl_hw_reg_set_scan_power(struct iwl_priv *priv, u32 scan_tbl_index,
  */
 int iwl_hw_reg_send_txpower(struct iwl_priv *priv)
 {
-	int rate_idx;
+	int rate_idx, i;
 	const struct iwl_channel_info *ch_info = NULL;
 	struct iwl_txpowertable_cmd txpower = {
 		.channel = priv->active_rxon.channel,
@@ -1483,20 +1486,36 @@ int iwl_hw_reg_send_txpower(struct iwl_priv *priv)
 	}
 
 	/* fill cmd with power settings for all rates for current channel */
-	for (rate_idx = 0; rate_idx < IWL_RATE_COUNT; rate_idx++) {
-		txpower.power[rate_idx].tpc = ch_info->power_info[rate_idx].tpc;
-		txpower.power[rate_idx].rate = iwl_rates[rate_idx].plcp;
+	/* Fill OFDM rate */
+	for (rate_idx = IWL_FIRST_OFDM_RATE, i = 0;
+	     rate_idx <= IWL_LAST_OFDM_RATE; rate_idx++, i++) {
+
+		txpower.power[i].tpc = ch_info->power_info[i].tpc;
+		txpower.power[i].rate = iwl_rates[rate_idx].plcp;
 
 		IWL_DEBUG_POWER("ch %d:%d rf %d dsp %3d rate code 0x%02x\n",
 				le16_to_cpu(txpower.channel),
 				txpower.band,
-				txpower.power[rate_idx].tpc.tx_gain,
-				txpower.power[rate_idx].tpc.dsp_atten,
-				txpower.power[rate_idx].rate);
+				txpower.power[i].tpc.tx_gain,
+				txpower.power[i].tpc.dsp_atten,
+				txpower.power[i].rate);
+	}
+	/* Fill CCK rates */
+	for (rate_idx = IWL_FIRST_CCK_RATE;
+	     rate_idx <= IWL_LAST_CCK_RATE; rate_idx++, i++) {
+		txpower.power[i].tpc = ch_info->power_info[i].tpc;
+		txpower.power[i].rate = iwl_rates[rate_idx].plcp;
+
+		IWL_DEBUG_POWER("ch %d:%d rf %d dsp %3d rate code 0x%02x\n",
+				le16_to_cpu(txpower.channel),
+				txpower.band,
+				txpower.power[i].tpc.tx_gain,
+				txpower.power[i].tpc.dsp_atten,
+				txpower.power[i].rate);
 	}
 
 	return iwl_send_cmd_pdu(priv, REPLY_TX_PWR_TABLE_CMD,
-				sizeof(struct iwl_txpowertable_cmd), &txpower);
+			sizeof(struct iwl_txpowertable_cmd), &txpower);
 
 }
 
@@ -1532,7 +1551,7 @@ static int iwl_hw_reg_set_new_power(struct iwl_priv *priv,
 	power_info = ch_info->power_info;
 
 	/* update OFDM Txpower settings */
-	for (i = IWL_FIRST_OFDM_RATE; i <= IWL_LAST_OFDM_RATE;
+	for (i = IWL_RATE_6M_INDEX_TABLE; i <= IWL_RATE_54M_INDEX_TABLE;
 	     i++, ++power_info) {
 		int delta_idx;
 
@@ -1556,14 +1575,14 @@ static int iwl_hw_reg_set_new_power(struct iwl_priv *priv,
 	 *    ... all CCK power settings for a given channel are the *same*. */
 	if (power_changed) {
 		power =
-		    ch_info->power_info[IWL_RATE_12M_INDEX].
+		    ch_info->power_info[IWL_RATE_12M_INDEX_TABLE].
 		    requested_power + IWL_CCK_FROM_OFDM_POWER_DIFF;
 
 		/* do all CCK rates' iwl_channel_power_info structures */
-		for (i = IWL_FIRST_CCK_RATE; i <= IWL_LAST_CCK_RATE; i++) {
+		for (i = IWL_RATE_1M_INDEX_TABLE; i <= IWL_RATE_11M_INDEX_TABLE; i++) {
 			power_info->requested_power = power;
 			power_info->base_power_index =
-			    ch_info->power_info[IWL_RATE_12M_INDEX].
+			    ch_info->power_info[IWL_RATE_12M_INDEX_TABLE].
 			    base_power_index + IWL_CCK_FROM_OFDM_INDEX_DIFF;
 			++power_info;
 		}
@@ -1657,7 +1676,7 @@ static int iwl_hw_reg_comp_txpower_temp(struct iwl_priv *priv)
 		for (scan_tbl_index = 0;
 		     scan_tbl_index < IWL_NUM_SCAN_RATES; scan_tbl_index++) {
 			s32 actual_index = (scan_tbl_index == 0) ?
-			    IWL_RATE_1M_INDEX : IWL_RATE_6M_INDEX;
+			    IWL_RATE_1M_INDEX_TABLE : IWL_RATE_6M_INDEX_TABLE;
 			iwl_hw_reg_set_scan_power(priv, scan_tbl_index,
 					   actual_index, clip_pwrs,
 					   ch_info, a_band);
@@ -1888,19 +1907,19 @@ static void iwl_hw_reg_init_channel_groups(struct iwl_priv *priv)
 		for (rate_index = 0;
 		     rate_index < IWL_RATE_COUNT; rate_index++, clip_pwrs++) {
 			switch (rate_index) {
-			case IWL_RATE_36M_INDEX:
+			case IWL_RATE_36M_INDEX_TABLE:
 				if (i == 0)	/* B/G */
 					*clip_pwrs = satur_pwr;
 				else	/* A */
 					*clip_pwrs = satur_pwr - 5;
 				break;
-			case IWL_RATE_48M_INDEX:
+			case IWL_RATE_48M_INDEX_TABLE:
 				if (i == 0)
 					*clip_pwrs = satur_pwr - 7;
 				else
 					*clip_pwrs = satur_pwr - 10;
 				break;
-			case IWL_RATE_54M_INDEX:
+			case IWL_RATE_54M_INDEX_TABLE:
 				if (i == 0)
 					*clip_pwrs = satur_pwr - 9;
 				else
@@ -2014,7 +2033,7 @@ int iwl3945_txpower_set_from_eeprom(struct iwl_priv *priv)
 		}
 
 		/* set tx power for CCK rates, based on OFDM 12 Mbit settings*/
-		pwr_info = &ch_info->power_info[IWL_RATE_12M_INDEX];
+		pwr_info = &ch_info->power_info[IWL_RATE_12M_INDEX_TABLE];
 		power = pwr_info->requested_power +
 			IWL_CCK_FROM_OFDM_POWER_DIFF;
 		pwr_index = pwr_info->power_table_index +
@@ -2030,9 +2049,9 @@ int iwl3945_txpower_set_from_eeprom(struct iwl_priv *priv)
 		/* fill each CCK rate's iwl_channel_power_info structure
 		 * NOTE:  All CCK-rate Txpwrs are the same for a given chnl!
 		 * NOTE:  CCK rates start at end of OFDM rates! */
-		for (rate_index = IWL_OFDM_RATES;
-		     rate_index < IWL_RATE_COUNT; rate_index++) {
-			pwr_info = &ch_info->power_info[rate_index];
+		for (rate_index = 0;
+		     rate_index < IWL_CCK_RATES; rate_index++) {
+			pwr_info = &ch_info->power_info[rate_index+IWL_OFDM_RATES];
 			pwr_info->requested_power = power;
 			pwr_info->power_table_index = pwr_index;
 			pwr_info->base_power_index = base_pwr_index;
@@ -2044,7 +2063,7 @@ int iwl3945_txpower_set_from_eeprom(struct iwl_priv *priv)
 		for (scan_tbl_index = 0;
 		     scan_tbl_index < IWL_NUM_SCAN_RATES; scan_tbl_index++) {
 			s32 actual_index = (scan_tbl_index == 0) ?
-				IWL_RATE_1M_INDEX : IWL_RATE_6M_INDEX;
+				IWL_RATE_1M_INDEX_TABLE : IWL_RATE_6M_INDEX_TABLE;
 			iwl_hw_reg_set_scan_power(priv, scan_tbl_index,
 				actual_index, clip_pwrs, ch_info, a_band);
 		}
@@ -2122,17 +2141,20 @@ int iwl_hw_get_rx_read(struct iwl_priv *priv)
  */
 int iwl3945_init_hw_rate_table(struct iwl_priv *priv)
 {
-	int rc, i;
+	int rc, i, index, prev_index;
 	struct iwl_rate_scaling_cmd rate_cmd = {
 		.reserved = {0, 0, 0},
 	};
 	struct iwl_rate_scaling_info *table = rate_cmd.table;
 
 	for (i = 0; i < ARRAY_SIZE(iwl_rates); i++) {
-		table[i].rate_n_flags =
+		index = iwl_rates[i].table_rs_index;
+
+		table[index].rate_n_flags =
 			iwl_hw_set_rate_n_flags(iwl_rates[i].plcp, 0);
-		table[i].try_cnt = priv->retry_rate;
-		table[i].next_rate_index = iwl_get_prev_ieee_rate(i);
+		table[index].try_cnt = priv->retry_rate;
+		prev_index = iwl_get_prev_ieee_rate(i);
+		table[index].next_rate_index = iwl_rates[prev_index].table_rs_index;
 	}
 
 	switch (priv->phymode) {
@@ -2140,26 +2162,26 @@ int iwl3945_init_hw_rate_table(struct iwl_priv *priv)
 		IWL_DEBUG_RATE("Select A mode rate scale\n");
 		/* If one of the following CCK rates is used,
 		 * have it fall back to the 6M OFDM rate */
-		for (i = IWL_FIRST_CCK_RATE; i <= IWL_LAST_CCK_RATE; i++)
-			table[i].next_rate_index = IWL_FIRST_OFDM_RATE;
+		for (i = IWL_RATE_1M_INDEX_TABLE; i <= IWL_RATE_11M_INDEX_TABLE; i++)
+			table[i].next_rate_index = iwl_rates[IWL_FIRST_OFDM_RATE].table_rs_index;
 
 		/* Don't fall back to CCK rates */
-		table[IWL_RATE_12M_INDEX].next_rate_index = IWL_RATE_9M_INDEX;
+		table[IWL_RATE_12M_INDEX_TABLE].next_rate_index = IWL_RATE_9M_INDEX_TABLE;
 
 		/* Don't drop out of OFDM rates */
-		table[IWL_FIRST_OFDM_RATE].next_rate_index =
-		    IWL_FIRST_OFDM_RATE;
+		table[IWL_RATE_6M_INDEX_TABLE].next_rate_index =
+		    iwl_rates[IWL_FIRST_OFDM_RATE].table_rs_index;
 		break;
 
 	case MODE_IEEE80211B:
 		IWL_DEBUG_RATE("Select B mode rate scale\n");
 		/* If an OFDM rate is used, have it fall back to the
 		 * 1M CCK rates */
-		for (i = IWL_FIRST_OFDM_RATE; i <= IWL_LAST_OFDM_RATE; i++)
-			table[i].next_rate_index = IWL_FIRST_CCK_RATE;
+		for (i = IWL_RATE_6M_INDEX_TABLE; i <= IWL_RATE_54M_INDEX_TABLE; i++)
+			table[i].next_rate_index = iwl_rates[IWL_FIRST_CCK_RATE].table_rs_index;
 
 		/* CCK shouldn't fall back to OFDM... */
-		table[IWL_RATE_11M_INDEX].next_rate_index = IWL_RATE_5M_INDEX;
+		table[IWL_RATE_11M_INDEX_TABLE].next_rate_index = IWL_RATE_5M_INDEX_TABLE;
 		break;
 
 	default:
@@ -2230,22 +2252,12 @@ unsigned int iwl_hw_get_beacon_cmd(struct iwl_priv *priv,
 	tx_beacon_cmd->tx.tx_flags = (TX_CMD_FLG_SEQ_CTL_MSK |
 				      TX_CMD_FLG_TSF_MSK);
 
-	/* supp_rates[0] == OFDM  */
-	tx_beacon_cmd->tx.supp_rates[0] = IWL_OFDM_BASIC_RATES_MASK;
-
-	/* supp_rates[1] == CCK
-	 *
-	 * NOTE:  IWL_*_RATES_MASK are not in the order that supp_rates
-	 * expects so we have to shift them around.
-	 *
-	 * supp_rates expects:
-	 * CCK rates are bit0..3
-	 *
-	 * However IWL_*_RATES_MASK has:
-	 * CCK rates are bit8..11
-	 */
+	/* supp_rates[0] == OFDM start at IWL_FIRST_OFDM_RATE*/
+	tx_beacon_cmd->tx.supp_rates[0] =
+		(IWL_OFDM_BASIC_RATES_MASK >> IWL_FIRST_OFDM_RATE) & 0xFF;
+
 	tx_beacon_cmd->tx.supp_rates[1] =
-		(IWL_CCK_BASIC_RATES_MASK >> 8) & 0xF;
+		(IWL_CCK_BASIC_RATES_MASK & 0xF);
 
 	return (sizeof(struct iwl_tx_beacon_cmd) + frame_size);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 12b2dcf..454477b 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5319,13 +5319,13 @@ static int iwl_init_geos(struct iwl_priv *priv)
 	/* 5.2GHz channels start after the 2.4GHz channels */
 	modes[A].mode = MODE_IEEE80211A;
 	modes[A].channels = &channels[ARRAY_SIZE(iwl_eeprom_band_1)];
-	modes[A].rates = rates;
+	modes[A].rates = &rates[4];
 	modes[A].num_rates = 8;	/* just OFDM */
 	modes[A].num_channels = 0;
 
 	modes[B].mode = MODE_IEEE80211B;
 	modes[B].channels = channels;
-	modes[B].rates = &rates[8];
+	modes[B].rates = rates;
 	modes[B].num_rates = 4;	/* just CCK */
 	modes[B].num_channels = 0;
 
-- 
1.5.2
