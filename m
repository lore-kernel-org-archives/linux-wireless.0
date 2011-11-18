Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755877Ab1KRIVl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:21:41 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8LfoM015713
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:21:41 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 24/77] iwlegacy: s/INDEX/IDX/
Date: Fri, 18 Nov 2011 09:21:46 +0100
Message-Id: <1321604559-10707-24-git-send-email-sgruszka@redhat.com> (sfid-20111118_092146_212520_C916F063)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-3945-rs.c    |   36 +++++-----
 drivers/net/wireless/iwlegacy/iwl-3945.c       |   82 +++++++++++-----------
 drivers/net/wireless/iwlegacy/iwl-4965-calib.c |   22 +++---
 drivers/net/wireless/iwlegacy/iwl-4965-hw.h    |    4 +-
 drivers/net/wireless/iwlegacy/iwl-4965-rs.c    |   36 +++++-----
 drivers/net/wireless/iwlegacy/iwl-4965-sta.c   |    4 +-
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c    |    4 +-
 drivers/net/wireless/iwlegacy/iwl-4965.c       |    8 +-
 drivers/net/wireless/iwlegacy/iwl-commands.h   |   60 ++++++++--------
 drivers/net/wireless/iwlegacy/iwl-fh.h         |    2 +-
 drivers/net/wireless/iwlegacy/iwl-legacy-rs.h  |   90 ++++++++++++------------
 drivers/net/wireless/iwlegacy/iwl-power.h      |   10 ++--
 drivers/net/wireless/iwlegacy/iwl-rx.c         |    8 +-
 drivers/net/wireless/iwlegacy/iwl-tx.c         |    4 +-
 drivers/net/wireless/iwlegacy/iwl3945-base.c   |   10 ++--
 15 files changed, 190 insertions(+), 190 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-3945-rs.c b/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
index 92fa436..4d83c62 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
@@ -64,27 +64,27 @@ struct il3945_tpt_entry {
 };
 
 static struct il3945_tpt_entry il3945_tpt_table_a[] = {
-	{-60, RATE_54M_INDEX},
-	{-64, RATE_48M_INDEX},
-	{-72, RATE_36M_INDEX},
-	{-80, RATE_24M_INDEX},
-	{-84, RATE_18M_INDEX},
-	{-85, RATE_12M_INDEX},
-	{-87, RATE_9M_INDEX},
-	{-89, RATE_6M_INDEX}
+	{-60, RATE_54M_IDX},
+	{-64, RATE_48M_IDX},
+	{-72, RATE_36M_IDX},
+	{-80, RATE_24M_IDX},
+	{-84, RATE_18M_IDX},
+	{-85, RATE_12M_IDX},
+	{-87, RATE_9M_IDX},
+	{-89, RATE_6M_IDX}
 };
 
 static struct il3945_tpt_entry il3945_tpt_table_g[] = {
-	{-60, RATE_54M_INDEX},
-	{-64, RATE_48M_INDEX},
-	{-68, RATE_36M_INDEX},
-	{-80, RATE_24M_INDEX},
-	{-84, RATE_18M_INDEX},
-	{-85, RATE_12M_INDEX},
-	{-86, RATE_11M_INDEX},
-	{-88, RATE_5M_INDEX},
-	{-90, RATE_2M_INDEX},
-	{-92, RATE_1M_INDEX}
+	{-60, RATE_54M_IDX},
+	{-64, RATE_48M_IDX},
+	{-68, RATE_36M_IDX},
+	{-80, RATE_24M_IDX},
+	{-84, RATE_18M_IDX},
+	{-85, RATE_12M_IDX},
+	{-86, RATE_11M_IDX},
+	{-88, RATE_5M_IDX},
+	{-90, RATE_2M_IDX},
+	{-92, RATE_1M_IDX}
 };
 
 #define RATE_MAX_WINDOW          62
diff --git a/drivers/net/wireless/iwlegacy/iwl-3945.c b/drivers/net/wireless/iwlegacy/iwl-3945.c
index 728a90c..3908bff 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945.c
@@ -52,16 +52,16 @@
 #include "iwl-3945-debugfs.h"
 
 #define IL_DECLARE_RATE_INFO(r, ip, in, rp, rn, pp, np)    \
-	[RATE_##r##M_INDEX] = { RATE_##r##M_PLCP,   \
+	[RATE_##r##M_IDX] = { RATE_##r##M_PLCP,   \
 				    RATE_##r##M_IEEE,   \
-				    RATE_##ip##M_INDEX, \
-				    RATE_##in##M_INDEX, \
-				    RATE_##rp##M_INDEX, \
-				    RATE_##rn##M_INDEX, \
-				    RATE_##pp##M_INDEX, \
-				    RATE_##np##M_INDEX, \
-				    RATE_##r##M_INDEX_TABLE, \
-				    RATE_##ip##M_INDEX_TABLE }
+				    RATE_##ip##M_IDX, \
+				    RATE_##in##M_IDX, \
+				    RATE_##rp##M_IDX, \
+				    RATE_##rn##M_IDX, \
+				    RATE_##pp##M_IDX, \
+				    RATE_##np##M_IDX, \
+				    RATE_##r##M_IDX_TABLE, \
+				    RATE_##ip##M_IDX_TABLE }
 
 /*
  * Parameter order:
@@ -246,16 +246,16 @@ int il3945_rs_next_rate(struct il_priv *il, int rate)
 
 	switch (il->band) {
 	case IEEE80211_BAND_5GHZ:
-		if (rate == RATE_12M_INDEX)
-			next_rate = RATE_9M_INDEX;
-		else if (rate == RATE_6M_INDEX)
-			next_rate = RATE_6M_INDEX;
+		if (rate == RATE_12M_IDX)
+			next_rate = RATE_9M_IDX;
+		else if (rate == RATE_6M_IDX)
+			next_rate = RATE_6M_IDX;
 		break;
 	case IEEE80211_BAND_2GHZ:
 		if (!(il->_3945.sta_supp_rates & IL_OFDM_RATES_MASK) &&
 		    il_is_associated(il)) {
-			if (rate == RATE_11M_INDEX)
-				next_rate = RATE_5M_INDEX;
+			if (rate == RATE_11M_IDX)
+				next_rate = RATE_5M_IDX;
 		}
 		break;
 
@@ -307,7 +307,7 @@ static void il3945_rx_reply_tx(struct il_priv *il,
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	int txq_id = SEQ_TO_QUEUE(sequence);
-	int index = SEQ_TO_INDEX(sequence);
+	int index = SEQ_TO_IDX(sequence);
 	struct il_tx_queue *txq = &il->txq[txq_id];
 	struct ieee80211_tx_info *info;
 	struct il3945_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
@@ -1133,7 +1133,7 @@ static int il3945_is_temp_calib_needed(struct il_priv *il)
 
 #define IL_MAX_GAIN_ENTRIES 78
 #define IL_CCK_FROM_OFDM_POWER_DIFF  -5
-#define IL_CCK_FROM_OFDM_INDEX_DIFF (10)
+#define IL_CCK_FROM_OFDM_IDX_DIFF (10)
 
 /* radio and DSP power table, each step is 1/2 dB.
  * 1st number is for RF analog gain, 2nd number is for DSP pre-DAC gain. */
@@ -1330,7 +1330,7 @@ static void il3945_hw_reg_set_scan_power(struct il_priv *il, u32 scan_tbl_index,
 	/* use this channel group's 6Mbit clipping/saturation pwr,
 	 *   but cap at regulatory scan power restriction (set during init
 	 *   based on eeprom channel data) for this channel.  */
-	power = min(ch_info->scan_power, clip_pwrs[RATE_6M_INDEX_TABLE]);
+	power = min(ch_info->scan_power, clip_pwrs[RATE_6M_IDX_TABLE]);
 
 	power = min(power, il->tx_power_user_lmt);
 	scan_power_info->requested_power = power;
@@ -1342,7 +1342,7 @@ static void il3945_hw_reg_set_scan_power(struct il_priv *il, u32 scan_tbl_index,
 	 *   *index*. */
 	power_index = ch_info->power_info[rate_index].power_table_index
 	    - (power - ch_info->power_info
-	       [RATE_6M_INDEX_TABLE].requested_power) * 2;
+	       [RATE_6M_IDX_TABLE].requested_power) * 2;
 
 	/* store reference index that we use when adjusting *all* scan
 	 *   powers.  So we can accommodate user (all channel) or spectrum
@@ -1466,7 +1466,7 @@ static int il3945_hw_reg_set_new_power(struct il_priv *il,
 	power_info = ch_info->power_info;
 
 	/* update OFDM Txpower settings */
-	for (i = RATE_6M_INDEX_TABLE; i <= RATE_54M_INDEX_TABLE;
+	for (i = RATE_6M_IDX_TABLE; i <= RATE_54M_IDX_TABLE;
 	     i++, ++power_info) {
 		int delta_idx;
 
@@ -1490,15 +1490,15 @@ static int il3945_hw_reg_set_new_power(struct il_priv *il,
 	 *    ... all CCK power settings for a given channel are the *same*. */
 	if (power_changed) {
 		power =
-		    ch_info->power_info[RATE_12M_INDEX_TABLE].
+		    ch_info->power_info[RATE_12M_IDX_TABLE].
 		    requested_power + IL_CCK_FROM_OFDM_POWER_DIFF;
 
 		/* do all CCK rates' il3945_channel_power_info structures */
-		for (i = RATE_1M_INDEX_TABLE; i <= RATE_11M_INDEX_TABLE; i++) {
+		for (i = RATE_1M_IDX_TABLE; i <= RATE_11M_IDX_TABLE; i++) {
 			power_info->requested_power = power;
 			power_info->base_power_index =
-			    ch_info->power_info[RATE_12M_INDEX_TABLE].
-			    base_power_index + IL_CCK_FROM_OFDM_INDEX_DIFF;
+			    ch_info->power_info[RATE_12M_IDX_TABLE].
+			    base_power_index + IL_CCK_FROM_OFDM_IDX_DIFF;
 			++power_info;
 		}
 	}
@@ -1597,7 +1597,7 @@ static int il3945_hw_reg_comp_txpower_temp(struct il_priv *il)
 		for (scan_tbl_index = 0;
 		     scan_tbl_index < IL_NUM_SCAN_RATES; scan_tbl_index++) {
 			s32 actual_index = (scan_tbl_index == 0) ?
-			    RATE_1M_INDEX_TABLE : RATE_6M_INDEX_TABLE;
+			    RATE_1M_IDX_TABLE : RATE_6M_IDX_TABLE;
 			il3945_hw_reg_set_scan_power(il, scan_tbl_index,
 					   actual_index, clip_pwrs,
 					   ch_info, a_band);
@@ -2012,19 +2012,19 @@ static void il3945_hw_reg_init_channel_groups(struct il_priv *il)
 		for (rate_index = 0;
 		     rate_index < RATE_COUNT_3945; rate_index++, clip_pwrs++) {
 			switch (rate_index) {
-			case RATE_36M_INDEX_TABLE:
+			case RATE_36M_IDX_TABLE:
 				if (i == 0)	/* B/G */
 					*clip_pwrs = satur_pwr;
 				else	/* A */
 					*clip_pwrs = satur_pwr - 5;
 				break;
-			case RATE_48M_INDEX_TABLE:
+			case RATE_48M_IDX_TABLE:
 				if (i == 0)
 					*clip_pwrs = satur_pwr - 7;
 				else
 					*clip_pwrs = satur_pwr - 10;
 				break;
-			case RATE_54M_INDEX_TABLE:
+			case RATE_54M_IDX_TABLE:
 				if (i == 0)
 					*clip_pwrs = satur_pwr - 9;
 				else
@@ -2139,13 +2139,13 @@ int il3945_txpower_set_from_eeprom(struct il_priv *il)
 		}
 
 		/* set tx power for CCK rates, based on OFDM 12 Mbit settings*/
-		pwr_info = &ch_info->power_info[RATE_12M_INDEX_TABLE];
+		pwr_info = &ch_info->power_info[RATE_12M_IDX_TABLE];
 		power = pwr_info->requested_power +
 			IL_CCK_FROM_OFDM_POWER_DIFF;
 		pwr_index = pwr_info->power_table_index +
-			IL_CCK_FROM_OFDM_INDEX_DIFF;
+			IL_CCK_FROM_OFDM_IDX_DIFF;
 		base_pwr_index = pwr_info->base_power_index +
-			IL_CCK_FROM_OFDM_INDEX_DIFF;
+			IL_CCK_FROM_OFDM_IDX_DIFF;
 
 		/* stay within table range */
 		pwr_index = il3945_hw_reg_fix_power_index(pwr_index);
@@ -2169,7 +2169,7 @@ int il3945_txpower_set_from_eeprom(struct il_priv *il)
 		for (scan_tbl_index = 0;
 		     scan_tbl_index < IL_NUM_SCAN_RATES; scan_tbl_index++) {
 			s32 actual_index = (scan_tbl_index == 0) ?
-				RATE_1M_INDEX_TABLE : RATE_6M_INDEX_TABLE;
+				RATE_1M_IDX_TABLE : RATE_6M_IDX_TABLE;
 			il3945_hw_reg_set_scan_power(il, scan_tbl_index,
 				actual_index, clip_pwrs, ch_info, a_band);
 		}
@@ -2326,17 +2326,17 @@ int il3945_init_hw_rate_table(struct il_priv *il)
 		D_RATE("Select A mode rate scale\n");
 		/* If one of the following CCK rates is used,
 		 * have it fall back to the 6M OFDM rate */
-		for (i = RATE_1M_INDEX_TABLE;
-			i <= RATE_11M_INDEX_TABLE; i++)
+		for (i = RATE_1M_IDX_TABLE;
+			i <= RATE_11M_IDX_TABLE; i++)
 			table[i].next_rate_index =
 			  il3945_rates[IL_FIRST_OFDM_RATE].table_rs_index;
 
 		/* Don't fall back to CCK rates */
-		table[RATE_12M_INDEX_TABLE].next_rate_index =
-						RATE_9M_INDEX_TABLE;
+		table[RATE_12M_IDX_TABLE].next_rate_index =
+						RATE_9M_IDX_TABLE;
 
 		/* Don't drop out of OFDM rates */
-		table[RATE_6M_INDEX_TABLE].next_rate_index =
+		table[RATE_6M_IDX_TABLE].next_rate_index =
 		    il3945_rates[IL_FIRST_OFDM_RATE].table_rs_index;
 		break;
 
@@ -2349,14 +2349,14 @@ int il3945_init_hw_rate_table(struct il_priv *il)
 		    il_is_associated(il)) {
 
 			index = IL_FIRST_CCK_RATE;
-			for (i = RATE_6M_INDEX_TABLE;
-			     i <= RATE_54M_INDEX_TABLE; i++)
+			for (i = RATE_6M_IDX_TABLE;
+			     i <= RATE_54M_IDX_TABLE; i++)
 				table[i].next_rate_index =
 					il3945_rates[index].table_rs_index;
 
-			index = RATE_11M_INDEX_TABLE;
+			index = RATE_11M_IDX_TABLE;
 			/* CCK shouldn't fall back to OFDM... */
-			table[index].next_rate_index = RATE_5M_INDEX_TABLE;
+			table[index].next_rate_index = RATE_5M_IDX_TABLE;
 		}
 		break;
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-calib.c b/drivers/net/wireless/iwlegacy/iwl-4965-calib.c
index bb3bc15..d622b27 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-calib.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-calib.c
@@ -374,30 +374,30 @@ static void il4965_prepare_legacy_sensitivity_tbl(struct il_priv *il,
 				struct il_sensitivity_data *data,
 				__le16 *tbl)
 {
-	tbl[HD_AUTO_CORR32_X4_TH_ADD_MIN_INDEX] =
+	tbl[HD_AUTO_CORR32_X4_TH_ADD_MIN_IDX] =
 				cpu_to_le16((u16)data->auto_corr_ofdm);
-	tbl[HD_AUTO_CORR32_X4_TH_ADD_MIN_MRC_INDEX] =
+	tbl[HD_AUTO_CORR32_X4_TH_ADD_MIN_MRC_IDX] =
 				cpu_to_le16((u16)data->auto_corr_ofdm_mrc);
-	tbl[HD_AUTO_CORR32_X1_TH_ADD_MIN_INDEX] =
+	tbl[HD_AUTO_CORR32_X1_TH_ADD_MIN_IDX] =
 				cpu_to_le16((u16)data->auto_corr_ofdm_x1);
-	tbl[HD_AUTO_CORR32_X1_TH_ADD_MIN_MRC_INDEX] =
+	tbl[HD_AUTO_CORR32_X1_TH_ADD_MIN_MRC_IDX] =
 				cpu_to_le16((u16)data->auto_corr_ofdm_mrc_x1);
 
-	tbl[HD_AUTO_CORR40_X4_TH_ADD_MIN_INDEX] =
+	tbl[HD_AUTO_CORR40_X4_TH_ADD_MIN_IDX] =
 				cpu_to_le16((u16)data->auto_corr_cck);
-	tbl[HD_AUTO_CORR40_X4_TH_ADD_MIN_MRC_INDEX] =
+	tbl[HD_AUTO_CORR40_X4_TH_ADD_MIN_MRC_IDX] =
 				cpu_to_le16((u16)data->auto_corr_cck_mrc);
 
-	tbl[HD_MIN_ENERGY_CCK_DET_INDEX] =
+	tbl[HD_MIN_ENERGY_CCK_DET_IDX] =
 				cpu_to_le16((u16)data->nrg_th_cck);
-	tbl[HD_MIN_ENERGY_OFDM_DET_INDEX] =
+	tbl[HD_MIN_ENERGY_OFDM_DET_IDX] =
 				cpu_to_le16((u16)data->nrg_th_ofdm);
 
-	tbl[HD_BARKER_CORR_TH_ADD_MIN_INDEX] =
+	tbl[HD_BARKER_CORR_TH_ADD_MIN_IDX] =
 				cpu_to_le16(data->barker_corr_th_min);
-	tbl[HD_BARKER_CORR_TH_ADD_MIN_MRC_INDEX] =
+	tbl[HD_BARKER_CORR_TH_ADD_MIN_MRC_IDX] =
 				cpu_to_le16(data->barker_corr_th_min_mrc);
-	tbl[HD_OFDM_ENERGY_TH_IN_INDEX] =
+	tbl[HD_OFDM_ENERGY_TH_IN_IDX] =
 				cpu_to_le16(data->nrg_th_cca);
 
 	D_CALIB("ofdm: ac %u mrc %u x1 %u mrc_x1 %u thresh %u\n",
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-hw.h b/drivers/net/wireless/iwlegacy/iwl-4965-hw.h
index 83748c7..2c1b000 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-hw.h
@@ -433,8 +433,8 @@ static inline int il4965_hw_valid_rtc_data_addr(u32 addr)
  * present during factory calibration).  A 5 Ghz EEPROM index of "40"
  * corresponds to the 49th entry in the table used by the driver.
  */
-#define MIN_TX_GAIN_INDEX		(0)  /* highest gain, lowest idx, 2.4 */
-#define MIN_TX_GAIN_INDEX_52GHZ_EXT	(-9) /* highest gain, lowest idx, 5 */
+#define MIN_TX_GAIN_IDX		(0)  /* highest gain, lowest idx, 2.4 */
+#define MIN_TX_GAIN_IDX_52GHZ_EXT	(-9) /* highest gain, lowest idx, 5 */
 
 /**
  * 2.4 GHz gain table
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
index e31ee20..7478e91 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
@@ -56,13 +56,13 @@
 #define RATE_SCALE_FLUSH_INTVL   (3*HZ)
 
 static u8 rs_ht_to_legacy[] = {
-	RATE_6M_INDEX, RATE_6M_INDEX,
-	RATE_6M_INDEX, RATE_6M_INDEX,
-	RATE_6M_INDEX,
-	RATE_6M_INDEX, RATE_9M_INDEX,
-	RATE_12M_INDEX, RATE_18M_INDEX,
-	RATE_24M_INDEX, RATE_36M_INDEX,
-	RATE_48M_INDEX, RATE_54M_INDEX
+	RATE_6M_IDX, RATE_6M_IDX,
+	RATE_6M_IDX, RATE_6M_IDX,
+	RATE_6M_IDX,
+	RATE_6M_IDX, RATE_9M_IDX,
+	RATE_12M_IDX, RATE_18M_IDX,
+	RATE_24M_IDX, RATE_36M_IDX,
+	RATE_48M_IDX, RATE_54M_IDX
 };
 
 static const u8 ant_toggle_lookup[] = {
@@ -77,16 +77,16 @@ static const u8 ant_toggle_lookup[] = {
 };
 
 #define IL_DECLARE_RATE_INFO(r, s, ip, in, rp, rn, pp, np)    \
-	[RATE_##r##M_INDEX] = { RATE_##r##M_PLCP,      \
+	[RATE_##r##M_IDX] = { RATE_##r##M_PLCP,      \
 				    RATE_SISO_##s##M_PLCP, \
 				    RATE_MIMO2_##s##M_PLCP,\
 				    RATE_##r##M_IEEE,      \
-				    RATE_##ip##M_INDEX,    \
-				    RATE_##in##M_INDEX,    \
-				    RATE_##rp##M_INDEX,    \
-				    RATE_##rn##M_INDEX,    \
-				    RATE_##pp##M_INDEX,    \
-				    RATE_##np##M_INDEX }
+				    RATE_##ip##M_IDX,    \
+				    RATE_##in##M_IDX,    \
+				    RATE_##rp##M_IDX,    \
+				    RATE_##rn##M_IDX,    \
+				    RATE_##pp##M_IDX,    \
+				    RATE_##np##M_IDX }
 
 /*
  * Parameter order:
@@ -125,7 +125,7 @@ static int il4965_hwrate_to_plcp_idx(u32 rate_n_flags)
 
 		idx += IL_FIRST_OFDM_RATE;
 		/* skip 9M not supported in ht*/
-		if (idx >= RATE_9M_INDEX)
+		if (idx >= RATE_9M_IDX)
 			idx += 1;
 		if (idx >= IL_FIRST_OFDM_RATE && idx <= IL_LAST_OFDM_RATE)
 			return idx;
@@ -218,7 +218,7 @@ static const struct il_rate_mcs_info il_rate_mcs[RATE_COUNT] = {
 	{ "60", "64QAM 5/6"},
 };
 
-#define MCS_INDEX_PER_STREAM	(8)
+#define MCS_IDX_PER_STREAM	(8)
 
 static inline u8 il4965_rs_extract_rate(u32 rate_n_flags)
 {
@@ -856,7 +856,7 @@ il4965_rs_tx_status(void *il_r, struct ieee80211_supported_band *sband,
 	/* For HT packets, map MCS to PLCP */
 	if (mac_flags & IEEE80211_TX_RC_MCS) {
 		mac_index &= RATE_MCS_CODE_MSK;	/* Remove # of streams */
-		if (mac_index >= (RATE_9M_INDEX - IL_FIRST_OFDM_RATE))
+		if (mac_index >= (RATE_9M_IDX - IL_FIRST_OFDM_RATE))
 			mac_index++;
 		/*
 		 * mac80211 HT index is always zero-indexed; we need to move
@@ -2276,7 +2276,7 @@ il4965_rs_get_rate(void *il_r, struct ieee80211_sta *sta, void *il_sta,
 		rate_idx = (rate_idx > 0) ? (rate_idx - 1) : 0;
 		if (il4965_rs_extract_rate(lq_sta->last_rate_n_flags) >=
 			 RATE_MIMO2_6M_PLCP)
-			rate_idx = rate_idx + MCS_INDEX_PER_STREAM;
+			rate_idx = rate_idx + MCS_IDX_PER_STREAM;
 		info->control.rates[0].flags = IEEE80211_TX_RC_MCS;
 		if (lq_sta->last_rate_n_flags & RATE_MCS_SGI_MSK)
 			info->control.rates[0].flags |=
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-sta.c b/drivers/net/wireless/iwlegacy/iwl-4965-sta.c
index 278517c..c50d639 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-sta.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-sta.c
@@ -50,9 +50,9 @@ il4965_sta_alloc_lq(struct il_priv *il, u8 sta_id)
 	/* Set up the rate scaling to start at selected rate, fall back
 	 * all the way down to 1M in IEEE order, and then spin on 1M */
 	if (il->band == IEEE80211_BAND_5GHZ)
-		r = RATE_6M_INDEX;
+		r = RATE_6M_IDX;
 	else
-		r = RATE_1M_INDEX;
+		r = RATE_1M_IDX;
 
 	if (r >= IL_FIRST_CCK_RATE && r <= IL_LAST_CCK_RATE)
 		rate_flags |= RATE_MCS_CCK_MSK;
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
index 9671e10..8f18d36 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
@@ -423,7 +423,7 @@ int il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
 	 */
 	out_cmd->hdr.cmd = REPLY_TX;
 	out_cmd->hdr.sequence = cpu_to_le16((u16)(QUEUE_TO_SEQ(txq_id) |
-				INDEX_TO_SEQ(q->write_ptr)));
+				IDX_TO_SEQ(q->write_ptr)));
 
 	/* Copy MAC header from skb into command buffer */
 	memcpy(tx_cmd->hdr, hdr, hdr_len);
@@ -1172,7 +1172,7 @@ static int il4965_tx_status_reply_compressed_ba(struct il_priv *il,
 							ba_resp->seq_ctl);
 
 	/* Calculate shift to align block-ack bits with our Tx win bits */
-	sh = agg->start_idx - SEQ_TO_INDEX(seq_ctl >> 4);
+	sh = agg->start_idx - SEQ_TO_IDX(seq_ctl >> 4);
 	if (sh < 0) /* tbw something is wrong with indices */
 		sh += 0x100;
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965.c b/drivers/net/wireless/iwlegacy/iwl-4965.c
index f62475d..58bdf93 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.c
@@ -632,9 +632,9 @@ static s32 get_min_power_index(s32 rate_power_index, u32 band)
 {
 	if (!band) {
 		if ((rate_power_index & 7) <= 4)
-			return MIN_TX_GAIN_INDEX_52GHZ_EXT;
+			return MIN_TX_GAIN_IDX_52GHZ_EXT;
 	}
-	return MIN_TX_GAIN_INDEX;
+	return MIN_TX_GAIN_IDX;
 }
 
 struct gain_entry {
@@ -1654,7 +1654,7 @@ static int il4965_tx_status_reply_tx(struct il_priv *il,
 			u16 sc;
 			status = le16_to_cpu(frame_status[i].status);
 			seq  = le16_to_cpu(frame_status[i].sequence);
-			idx = SEQ_TO_INDEX(seq);
+			idx = SEQ_TO_IDX(seq);
 			txq_id = SEQ_TO_QUEUE(seq);
 
 			if (status & (AGG_TX_STATE_FEW_BYTES_MSK |
@@ -1777,7 +1777,7 @@ static void il4965_rx_reply_tx(struct il_priv *il,
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	int txq_id = SEQ_TO_QUEUE(sequence);
-	int index = SEQ_TO_INDEX(sequence);
+	int index = SEQ_TO_IDX(sequence);
 	struct il_tx_queue *txq = &il->txq[txq_id];
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_tx_info *info;
diff --git a/drivers/net/wireless/iwlegacy/iwl-commands.h b/drivers/net/wireless/iwlegacy/iwl-commands.h
index aed1101..002f1d7 100644
--- a/drivers/net/wireless/iwlegacy/iwl-commands.h
+++ b/drivers/net/wireless/iwlegacy/iwl-commands.h
@@ -168,8 +168,8 @@ enum {
 
 #define SEQ_TO_QUEUE(s)	(((s) >> 8) & 0x1f)
 #define QUEUE_TO_SEQ(q)	(((q) & 0x1f) << 8)
-#define SEQ_TO_INDEX(s)	((s) & 0xff)
-#define INDEX_TO_SEQ(i)	((i) & 0xff)
+#define SEQ_TO_IDX(s)	((s) & 0xff)
+#define IDX_TO_SEQ(i)	((i) & 0xff)
 #define SEQ_HUGE_FRAME	cpu_to_le16(0x4000)
 #define SEQ_RX_FRAME	cpu_to_le16(0x8000)
 
@@ -3116,10 +3116,10 @@ struct il_missed_beacon_notif {
  * maximum sensitivity):
  *
  *                                             START  /  MIN  /  MAX
- *   HD_AUTO_CORR32_X1_TH_ADD_MIN_INDEX          90   /   85  /  120
- *   HD_AUTO_CORR32_X1_TH_ADD_MIN_MRC_INDEX     170   /  170  /  210
- *   HD_AUTO_CORR32_X4_TH_ADD_MIN_INDEX         105   /  105  /  140
- *   HD_AUTO_CORR32_X4_TH_ADD_MIN_MRC_INDEX     220   /  220  /  270
+ *   HD_AUTO_CORR32_X1_TH_ADD_MIN_IDX          90   /   85  /  120
+ *   HD_AUTO_CORR32_X1_TH_ADD_MIN_MRC_IDX     170   /  170  /  210
+ *   HD_AUTO_CORR32_X4_TH_ADD_MIN_IDX         105   /  105  /  140
+ *   HD_AUTO_CORR32_X4_TH_ADD_MIN_MRC_IDX     220   /  220  /  270
  *
  *   If actual rate of OFDM false alarms (+ plcp_errors) is too high
  *   (greater than 50 for each 204.8 msecs listening), reduce sensitivity
@@ -3156,26 +3156,26 @@ struct il_missed_beacon_notif {
  * (notice that the start points for CCK are at maximum sensitivity):
  *
  *                                             START  /  MIN  /  MAX
- *   HD_AUTO_CORR40_X4_TH_ADD_MIN_INDEX         125   /  125  /  200
- *   HD_AUTO_CORR40_X4_TH_ADD_MIN_MRC_INDEX     200   /  200  /  400
- *   HD_MIN_ENERGY_CCK_DET_INDEX                100   /    0  /  100
+ *   HD_AUTO_CORR40_X4_TH_ADD_MIN_IDX         125   /  125  /  200
+ *   HD_AUTO_CORR40_X4_TH_ADD_MIN_MRC_IDX     200   /  200  /  400
+ *   HD_MIN_ENERGY_CCK_DET_IDX                100   /    0  /  100
  *
  *   If actual rate of CCK false alarms (+ plcp_errors) is too high
  *   (greater than 50 for each 204.8 msecs listening), method for reducing
  *   sensitivity is:
  *
- *   1)  *Add* 3 to value in HD_AUTO_CORR40_X4_TH_ADD_MIN_MRC_INDEX,
+ *   1)  *Add* 3 to value in HD_AUTO_CORR40_X4_TH_ADD_MIN_MRC_IDX,
  *       up to max 400.
  *
- *   2)  If current value in HD_AUTO_CORR40_X4_TH_ADD_MIN_INDEX is < 160,
+ *   2)  If current value in HD_AUTO_CORR40_X4_TH_ADD_MIN_IDX is < 160,
  *       sensitivity has been reduced a significant amount; bring it up to
  *       a moderate 161.  Otherwise, *add* 3, up to max 200.
  *
- *   3)  a)  If current value in HD_AUTO_CORR40_X4_TH_ADD_MIN_INDEX is > 160,
+ *   3)  a)  If current value in HD_AUTO_CORR40_X4_TH_ADD_MIN_IDX is > 160,
  *       sensitivity has been reduced only a moderate or small amount;
- *       *subtract* 2 from value in HD_MIN_ENERGY_CCK_DET_INDEX,
+ *       *subtract* 2 from value in HD_MIN_ENERGY_CCK_DET_IDX,
  *       down to min 0.  Otherwise (if gain has been significantly reduced),
- *       don't change the HD_MIN_ENERGY_CCK_DET_INDEX value.
+ *       don't change the HD_MIN_ENERGY_CCK_DET_IDX value.
  *
  *       b)  Save a snapshot of the "silence reference".
  *
@@ -3191,13 +3191,13 @@ struct il_missed_beacon_notif {
  *
  *   Method for increasing sensitivity:
  *
- *   1)  *Subtract* 3 from value in HD_AUTO_CORR40_X4_TH_ADD_MIN_INDEX,
+ *   1)  *Subtract* 3 from value in HD_AUTO_CORR40_X4_TH_ADD_MIN_IDX,
  *       down to min 125.
  *
- *   2)  *Subtract* 3 from value in HD_AUTO_CORR40_X4_TH_ADD_MIN_MRC_INDEX,
+ *   2)  *Subtract* 3 from value in HD_AUTO_CORR40_X4_TH_ADD_MIN_MRC_IDX,
  *       down to min 200.
  *
- *   3)  *Add* 2 to value in HD_MIN_ENERGY_CCK_DET_INDEX, up to max 100.
+ *   3)  *Add* 2 to value in HD_MIN_ENERGY_CCK_DET_IDX, up to max 100.
  *
  *   If actual rate of CCK false alarms (+ plcp_errors) is within good range
  *   (between 5 and 50 for each 204.8 msecs listening):
@@ -3206,13 +3206,13 @@ struct il_missed_beacon_notif {
  *
  *   2)  If previous beacon had too many CCK false alarms (+ plcp_errors),
  *       give some extra margin to energy threshold by *subtracting* 8
- *       from value in HD_MIN_ENERGY_CCK_DET_INDEX.
+ *       from value in HD_MIN_ENERGY_CCK_DET_IDX.
  *
  *   For all cases (too few, too many, good range), make sure that the CCK
  *   detection threshold (energy) is below the energy level for robust
  *   detection over the past 10 beacon periods, the "Max cck energy".
  *   Lower values mean higher energy; this means making sure that the value
- *   in HD_MIN_ENERGY_CCK_DET_INDEX is at or *above* "Max cck energy".
+ *   in HD_MIN_ENERGY_CCK_DET_IDX is at or *above* "Max cck energy".
  *
  */
 
@@ -3220,17 +3220,17 @@ struct il_missed_beacon_notif {
  * Table entries in SENSITIVITY_CMD (struct il_sensitivity_cmd)
  */
 #define HD_TABLE_SIZE  (11)	/* number of entries */
-#define HD_MIN_ENERGY_CCK_DET_INDEX                 (0)	/* table indexes */
-#define HD_MIN_ENERGY_OFDM_DET_INDEX                (1)
-#define HD_AUTO_CORR32_X1_TH_ADD_MIN_INDEX          (2)
-#define HD_AUTO_CORR32_X1_TH_ADD_MIN_MRC_INDEX      (3)
-#define HD_AUTO_CORR40_X4_TH_ADD_MIN_MRC_INDEX      (4)
-#define HD_AUTO_CORR32_X4_TH_ADD_MIN_INDEX          (5)
-#define HD_AUTO_CORR32_X4_TH_ADD_MIN_MRC_INDEX      (6)
-#define HD_BARKER_CORR_TH_ADD_MIN_INDEX             (7)
-#define HD_BARKER_CORR_TH_ADD_MIN_MRC_INDEX         (8)
-#define HD_AUTO_CORR40_X4_TH_ADD_MIN_INDEX          (9)
-#define HD_OFDM_ENERGY_TH_IN_INDEX                  (10)
+#define HD_MIN_ENERGY_CCK_DET_IDX                 (0)	/* table indexes */
+#define HD_MIN_ENERGY_OFDM_DET_IDX                (1)
+#define HD_AUTO_CORR32_X1_TH_ADD_MIN_IDX          (2)
+#define HD_AUTO_CORR32_X1_TH_ADD_MIN_MRC_IDX      (3)
+#define HD_AUTO_CORR40_X4_TH_ADD_MIN_MRC_IDX      (4)
+#define HD_AUTO_CORR32_X4_TH_ADD_MIN_IDX          (5)
+#define HD_AUTO_CORR32_X4_TH_ADD_MIN_MRC_IDX      (6)
+#define HD_BARKER_CORR_TH_ADD_MIN_IDX             (7)
+#define HD_BARKER_CORR_TH_ADD_MIN_MRC_IDX         (8)
+#define HD_AUTO_CORR40_X4_TH_ADD_MIN_IDX          (9)
+#define HD_OFDM_ENERGY_TH_IN_IDX                  (10)
 
 /* Control field in struct il_sensitivity_cmd */
 #define SENSITIVITY_CMD_CONTROL_DEFAULT_TABLE	cpu_to_le16(0)
diff --git a/drivers/net/wireless/iwlegacy/iwl-fh.h b/drivers/net/wireless/iwlegacy/iwl-fh.h
index 0ae36df..e993e3e 100644
--- a/drivers/net/wireless/iwlegacy/iwl-fh.h
+++ b/drivers/net/wireless/iwlegacy/iwl-fh.h
@@ -162,7 +162,7 @@
  * RBs), should be 8 after preparing the first 8 RBs (for example), and must
  * wrap back to 0 at the end of the circular buffer (but don't wrap before
  * "read" index has advanced past 1!  See below).
- * NOTE:  4965 EXPECTS THE WRITE INDEX TO BE INCREMENTED IN MULTIPLES OF 8.
+ * NOTE:  4965 EXPECTS THE WRITE IDX TO BE INCREMENTED IN MULTIPLES OF 8.
  *
  * As the 4965 fills RBs (referenced from contiguous RBDs within the circular
  * buffer), it updates the Rx status buffer in host DRAM, 2) described above,
diff --git a/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h b/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
index 6670f2e..f3ee0dd 100644
--- a/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
+++ b/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
@@ -59,64 +59,64 @@ struct il3945_rate_info {
  * struct il_rate_info il_rates[RATE_COUNT];
  */
 enum {
-	RATE_1M_INDEX = 0,
-	RATE_2M_INDEX,
-	RATE_5M_INDEX,
-	RATE_11M_INDEX,
-	RATE_6M_INDEX,
-	RATE_9M_INDEX,
-	RATE_12M_INDEX,
-	RATE_18M_INDEX,
-	RATE_24M_INDEX,
-	RATE_36M_INDEX,
-	RATE_48M_INDEX,
-	RATE_54M_INDEX,
-	RATE_60M_INDEX,
+	RATE_1M_IDX = 0,
+	RATE_2M_IDX,
+	RATE_5M_IDX,
+	RATE_11M_IDX,
+	RATE_6M_IDX,
+	RATE_9M_IDX,
+	RATE_12M_IDX,
+	RATE_18M_IDX,
+	RATE_24M_IDX,
+	RATE_36M_IDX,
+	RATE_48M_IDX,
+	RATE_54M_IDX,
+	RATE_60M_IDX,
 	RATE_COUNT,
 	RATE_COUNT_LEGACY = RATE_COUNT - 1,	/* Excluding 60M */
 	RATE_COUNT_3945 = RATE_COUNT - 1,
-	RATE_INVM_INDEX = RATE_COUNT,
+	RATE_INVM_IDX = RATE_COUNT,
 	RATE_INVALID = RATE_COUNT,
 };
 
 enum {
-	RATE_6M_INDEX_TABLE = 0,
-	RATE_9M_INDEX_TABLE,
-	RATE_12M_INDEX_TABLE,
-	RATE_18M_INDEX_TABLE,
-	RATE_24M_INDEX_TABLE,
-	RATE_36M_INDEX_TABLE,
-	RATE_48M_INDEX_TABLE,
-	RATE_54M_INDEX_TABLE,
-	RATE_1M_INDEX_TABLE,
-	RATE_2M_INDEX_TABLE,
-	RATE_5M_INDEX_TABLE,
-	RATE_11M_INDEX_TABLE,
-	RATE_INVM_INDEX_TABLE = RATE_INVM_INDEX - 1,
+	RATE_6M_IDX_TABLE = 0,
+	RATE_9M_IDX_TABLE,
+	RATE_12M_IDX_TABLE,
+	RATE_18M_IDX_TABLE,
+	RATE_24M_IDX_TABLE,
+	RATE_36M_IDX_TABLE,
+	RATE_48M_IDX_TABLE,
+	RATE_54M_IDX_TABLE,
+	RATE_1M_IDX_TABLE,
+	RATE_2M_IDX_TABLE,
+	RATE_5M_IDX_TABLE,
+	RATE_11M_IDX_TABLE,
+	RATE_INVM_IDX_TABLE = RATE_INVM_IDX - 1,
 };
 
 enum {
-	IL_FIRST_OFDM_RATE = RATE_6M_INDEX,
-	IL39_LAST_OFDM_RATE = RATE_54M_INDEX,
-	IL_LAST_OFDM_RATE = RATE_60M_INDEX,
-	IL_FIRST_CCK_RATE = RATE_1M_INDEX,
-	IL_LAST_CCK_RATE = RATE_11M_INDEX,
+	IL_FIRST_OFDM_RATE = RATE_6M_IDX,
+	IL39_LAST_OFDM_RATE = RATE_54M_IDX,
+	IL_LAST_OFDM_RATE = RATE_60M_IDX,
+	IL_FIRST_CCK_RATE = RATE_1M_IDX,
+	IL_LAST_CCK_RATE = RATE_11M_IDX,
 };
 
 /* #define vs. enum to keep from defaulting to 'large integer' */
-#define	RATE_6M_MASK   (1 << RATE_6M_INDEX)
-#define	RATE_9M_MASK   (1 << RATE_9M_INDEX)
-#define	RATE_12M_MASK  (1 << RATE_12M_INDEX)
-#define	RATE_18M_MASK  (1 << RATE_18M_INDEX)
-#define	RATE_24M_MASK  (1 << RATE_24M_INDEX)
-#define	RATE_36M_MASK  (1 << RATE_36M_INDEX)
-#define	RATE_48M_MASK  (1 << RATE_48M_INDEX)
-#define	RATE_54M_MASK  (1 << RATE_54M_INDEX)
-#define RATE_60M_MASK  (1 << RATE_60M_INDEX)
-#define	RATE_1M_MASK   (1 << RATE_1M_INDEX)
-#define	RATE_2M_MASK   (1 << RATE_2M_INDEX)
-#define	RATE_5M_MASK   (1 << RATE_5M_INDEX)
-#define	RATE_11M_MASK  (1 << RATE_11M_INDEX)
+#define	RATE_6M_MASK   (1 << RATE_6M_IDX)
+#define	RATE_9M_MASK   (1 << RATE_9M_IDX)
+#define	RATE_12M_MASK  (1 << RATE_12M_IDX)
+#define	RATE_18M_MASK  (1 << RATE_18M_IDX)
+#define	RATE_24M_MASK  (1 << RATE_24M_IDX)
+#define	RATE_36M_MASK  (1 << RATE_36M_IDX)
+#define	RATE_48M_MASK  (1 << RATE_48M_IDX)
+#define	RATE_54M_MASK  (1 << RATE_54M_IDX)
+#define RATE_60M_MASK  (1 << RATE_60M_IDX)
+#define	RATE_1M_MASK   (1 << RATE_1M_IDX)
+#define	RATE_2M_MASK   (1 << RATE_2M_IDX)
+#define	RATE_5M_MASK   (1 << RATE_5M_IDX)
+#define	RATE_11M_MASK  (1 << RATE_11M_IDX)
 
 /* uCode API values for legacy bit rates, both OFDM and CCK */
 enum {
diff --git a/drivers/net/wireless/iwlegacy/iwl-power.h b/drivers/net/wireless/iwlegacy/iwl-power.h
index e149f78..e4a0ef2 100644
--- a/drivers/net/wireless/iwlegacy/iwl-power.h
+++ b/drivers/net/wireless/iwlegacy/iwl-power.h
@@ -31,11 +31,11 @@
 #include "iwl-commands.h"
 
 enum il_power_level {
-	IL_POWER_INDEX_1,
-	IL_POWER_INDEX_2,
-	IL_POWER_INDEX_3,
-	IL_POWER_INDEX_4,
-	IL_POWER_INDEX_5,
+	IL_POWER_IDX_1,
+	IL_POWER_IDX_2,
+	IL_POWER_IDX_3,
+	IL_POWER_IDX_4,
+	IL_POWER_IDX_5,
 	IL_POWER_NUM
 };
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-rx.c b/drivers/net/wireless/iwlegacy/iwl-rx.c
index a6bee84..5c0d131 100644
--- a/drivers/net/wireless/iwlegacy/iwl-rx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-rx.c
@@ -62,7 +62,7 @@
  * WRITE = READ.
  *
  * During initialization, the host sets up the READ queue position to the first
- * INDEX position, and WRITE to the last (READ - 1 wrapped)
+ * IDX position, and WRITE to the last (READ - 1 wrapped)
  *
  * When the firmware places a packet in a buffer, it will advance the READ index
  * and fire the RX interrupt.  The driver can then query the READ index and
@@ -74,13 +74,13 @@
  *   iwl->rxq->free_count drops to or below RX_LOW_WATERMARK, work is scheduled
  *   to replenish the iwl->rxq->rx_free.
  * + In il_rx_replenish (scheduled) if 'processed' != 'read' then the
- *   iwl->rxq is replenished and the READ INDEX is updated (updating the
+ *   iwl->rxq is replenished and the READ IDX is updated (updating the
  *   'processed' and 'read' driver indexes as well)
  * + A received packet is processed and handed to the kernel network stack,
  *   detached from the iwl->rxq.  The driver 'processed' index is updated.
  * + The Host/Firmware iwl->rxq is replenished at tasklet time from the rx_free
  *   list. If there are no allocated buffers in iwl->rxq->rx_free, the READ
- *   INDEX is not incremented and iwl->status(RX_STALLED) is set.  If there
+ *   IDX is not incremented and iwl->status(RX_STALLED) is set.  If there
  *   were enough free buffers and RX_STALLED is set it is cleared.
  *
  *
@@ -96,7 +96,7 @@
  *
  * -- enable interrupts --
  * ISR - il_rx()         Detach il_rx_bufs from pool up to the
- *                            READ INDEX, detaching the SKB from the pool.
+ *                            READ IDX, detaching the SKB from the pool.
  *                            Moves the packet buffer from queue to rx_used.
  *                            Calls il_rx_queue_restock to refill any empty
  *                            slots.
diff --git a/drivers/net/wireless/iwlegacy/iwl-tx.c b/drivers/net/wireless/iwlegacy/iwl-tx.c
index b9c417c..45114b4 100644
--- a/drivers/net/wireless/iwlegacy/iwl-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-tx.c
@@ -500,7 +500,7 @@ int il_enqueue_hcmd(struct il_priv *il, struct il_host_cmd *cmd)
 
 	out_cmd->hdr.flags = 0;
 	out_cmd->hdr.sequence = cpu_to_le16(QUEUE_TO_SEQ(il->cmd_queue) |
-			INDEX_TO_SEQ(q->write_ptr));
+			IDX_TO_SEQ(q->write_ptr));
 	if (cmd->flags & CMD_SIZE_HUGE)
 		out_cmd->hdr.sequence |= SEQ_HUGE_FRAME;
 	len = sizeof(struct il_device_cmd);
@@ -598,7 +598,7 @@ il_tx_cmd_complete(struct il_priv *il, struct il_rx_buf *rxb)
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	int txq_id = SEQ_TO_QUEUE(sequence);
-	int index = SEQ_TO_INDEX(sequence);
+	int index = SEQ_TO_IDX(sequence);
 	int cmd_index;
 	bool huge = !!(pkt->hdr.sequence & SEQ_HUGE_FRAME);
 	struct il_device_cmd *cmd;
diff --git a/drivers/net/wireless/iwlegacy/iwl3945-base.c b/drivers/net/wireless/iwlegacy/iwl3945-base.c
index 1fc9bfb..017b297 100644
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
@@ -563,7 +563,7 @@ static int il3945_tx_skb(struct il_priv *il, struct sk_buff *skb)
 	 */
 	out_cmd->hdr.cmd = REPLY_TX;
 	out_cmd->hdr.sequence = cpu_to_le16((u16)(QUEUE_TO_SEQ(txq_id) |
-				INDEX_TO_SEQ(q->write_ptr)));
+				IDX_TO_SEQ(q->write_ptr)));
 
 	/* Copy MAC header from skb into command buffer */
 	memcpy(tx_cmd->hdr, hdr, hdr_len);
@@ -903,7 +903,7 @@ static void il3945_setup_rx_handlers(struct il_priv *il)
  * WRITE = READ.
  *
  * During initialization, the host sets up the READ queue position to the first
- * INDEX position, and WRITE to the last (READ - 1 wrapped)
+ * IDX position, and WRITE to the last (READ - 1 wrapped)
  *
  * When the firmware places a packet in a buffer, it will advance the READ index
  * and fire the RX interrupt.  The driver can then query the READ index and
@@ -915,13 +915,13 @@ static void il3945_setup_rx_handlers(struct il_priv *il)
  *   iwl->rxq->free_count drops to or below RX_LOW_WATERMARK, work is scheduled
  *   to replenish the iwl->rxq->rx_free.
  * + In il3945_rx_replenish (scheduled) if 'processed' != 'read' then the
- *   iwl->rxq is replenished and the READ INDEX is updated (updating the
+ *   iwl->rxq is replenished and the READ IDX is updated (updating the
  *   'processed' and 'read' driver indexes as well)
  * + A received packet is processed and handed to the kernel network stack,
  *   detached from the iwl->rxq.  The driver 'processed' index is updated.
  * + The Host/Firmware iwl->rxq is replenished at tasklet time from the rx_free
  *   list. If there are no allocated buffers in iwl->rxq->rx_free, the READ
- *   INDEX is not incremented and iwl->status(RX_STALLED) is set.  If there
+ *   IDX is not incremented and iwl->status(RX_STALLED) is set.  If there
  *   were enough free buffers and RX_STALLED is set it is cleared.
  *
  *
@@ -936,7 +936,7 @@ static void il3945_setup_rx_handlers(struct il_priv *il)
  *
  * -- enable interrupts --
  * ISR - il3945_rx()         Detach il_rx_bufs from pool up to the
- *                            READ INDEX, detaching the SKB from the pool.
+ *                            READ IDX, detaching the SKB from the pool.
  *                            Moves the packet buffer from queue to rx_used.
  *                            Calls il3945_rx_queue_restock to refill any empty
  *                            slots.
-- 
1.7.1

