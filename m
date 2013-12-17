Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:57271 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab3LQUp0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:45:26 -0500
Received: by mail-ee0-f44.google.com with SMTP id b57so3105319eek.31
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:45:24 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 28/36] iwlwifi: mvm: rs: improve rates table algo
Date: Tue, 17 Dec 2013 22:44:31 +0200
Message-Id: <1387313079-28123-28-git-send-email-egrumbach@gmail.com> (sfid-20131217_214622_158252_FC8D43C6)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

The new logic will attempt more rates with less retries
per rate. Also when starting off with MIMO it will
fallback to SISO with the same MCS and only then to Legacy.
Previously we fell back directly to Legacy.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c |  254 ++++++++++++++++++++-------------
 1 file changed, 151 insertions(+), 103 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 30470d4..bc86032 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -42,9 +42,16 @@
 
 #define RS_NAME "iwl-mvm-rs"
 
-#define NUM_TRY_BEFORE_ANT_TOGGLE 1
-#define IWL_NUMBER_TRY      1
-#define IWL_HT_NUMBER_TRY   3
+#define NUM_TRY_BEFORE_ANT_TOGGLE       1
+#define RS_LEGACY_RETRIES_PER_RATE      1
+#define RS_HT_VHT_RETRIES_PER_RATE      2
+#define RS_HT_VHT_RETRIES_PER_RATE_TW   1
+#define RS_INITIAL_MIMO_NUM_RATES       3
+#define RS_INITIAL_SISO_NUM_RATES       3
+#define RS_INITIAL_LEGACY_NUM_RATES     LINK_QUAL_MAX_RETRY_NUM
+#define RS_SECONDARY_LEGACY_NUM_RATES   LINK_QUAL_MAX_RETRY_NUM
+#define RS_SECONDARY_SISO_NUM_RATES     3
+#define RS_SECONDARY_SISO_RETRIES       1
 
 #define IWL_RATE_MAX_WINDOW		62	/* # tx in history window */
 #define IWL_RATE_MIN_FAILURE_TH		3	/* min failures to calc tpt */
@@ -847,54 +854,73 @@ static u16 rs_get_adjacent_rate(struct iwl_mvm *mvm, u8 index, u16 rate_mask,
 	return (high << 8) | low;
 }
 
-static void rs_get_lower_rate(struct iwl_lq_sta *lq_sta,
-			      struct rs_rate *rate,
-			      u8 scale_index, u8 ht_possible)
+static inline bool rs_rate_supported(struct iwl_lq_sta *lq_sta,
+				     struct rs_rate *rate)
 {
-	s32 low;
-	u16 rate_mask;
+	return BIT(rate->index) & rs_get_supported_rates(lq_sta, rate);
+}
+
+/* Get the next supported lower rate in the current column.
+ * Return true if bottom rate in the current column was reached
+ */
+static bool rs_get_lower_rate_in_column(struct iwl_lq_sta *lq_sta,
+					struct rs_rate *rate)
+{
+	u8 low;
 	u16 high_low;
-	u8 switch_to_legacy = 0;
+	u16 rate_mask;
+	struct iwl_mvm *mvm = lq_sta->drv;
+
+	rate_mask = rs_get_supported_rates(lq_sta, rate);
+	high_low = rs_get_adjacent_rate(mvm, rate->index, rate_mask,
+					rate->type);
+	low = high_low & 0xff;
+
+	/* Bottom rate of column reached */
+	if (low == IWL_RATE_INVALID)
+		return true;
+
+	rate->index = low;
+	return false;
+}
+
+/* Get the next rate to use following a column downgrade */
+static void rs_get_lower_rate_down_column(struct iwl_lq_sta *lq_sta,
+					  struct rs_rate *rate)
+{
 	struct iwl_mvm *mvm = lq_sta->drv;
 
-	/* check if we need to switch from HT to legacy rates.
-	 * assumption is that mandatory rates (1Mbps or 6Mbps)
-	 * are always supported (spec demand) */
-	if (!is_legacy(rate) && (!ht_possible || !scale_index)) {
-		switch_to_legacy = 1;
-		WARN_ON_ONCE(scale_index < IWL_RATE_MCS_0_INDEX &&
-			     scale_index > IWL_RATE_MCS_9_INDEX);
-		scale_index = rs_ht_to_legacy[scale_index];
+	if (is_legacy(rate)) {
+		/* No column to downgrade from Legacy */
+		return;
+	} else if (is_siso(rate)) {
+		/* Downgrade to Legacy if we were in SISO */
 		if (lq_sta->band == IEEE80211_BAND_5GHZ)
 			rate->type = LQ_LEGACY_A;
 		else
 			rate->type = LQ_LEGACY_G;
 
-		if (num_of_ant(rate->ant) > 1)
-			rate->ant =
-			    first_antenna(iwl_fw_valid_tx_ant(mvm->fw));
-
 		rate->bw = RATE_MCS_CHAN_WIDTH_20;
-		rate->sgi = false;
-	}
 
-	rate_mask = rs_get_supported_rates(lq_sta, rate);
+		WARN_ON_ONCE(rate->index < IWL_RATE_MCS_0_INDEX &&
+			     rate->index > IWL_RATE_MCS_9_INDEX);
 
-	/* If we switched from HT to legacy, check current rate */
-	if (switch_to_legacy && (rate_mask & (1 << scale_index))) {
-		low = scale_index;
-		goto out;
+		rate->index = rs_ht_to_legacy[rate->index];
+	} else {
+		/* Downgrade to SISO with same MCS if in MIMO  */
+		rate->type = is_vht_mimo2(rate) ?
+			LQ_VHT_SISO : LQ_HT_SISO;
 	}
 
-	high_low = rs_get_adjacent_rate(lq_sta->drv, scale_index, rate_mask,
-					rate->type);
-	low = high_low & 0xff;
 
-	if (low == IWL_RATE_INVALID)
-		low = scale_index;
+	if (num_of_ant(rate->ant) > 1)
+		rate->ant = first_antenna(iwl_fw_valid_tx_ant(mvm->fw));
 
-out:
-	rate->index = low;
+	/* Relevant in both switching to SISO or Legacy */
+	rate->sgi = false;
+
+	if (!rs_rate_supported(lq_sta, rate))
+		rs_get_lower_rate_in_column(lq_sta, rate);
 }
 
 /* Simple function to compare two rate scale table types */
@@ -2333,96 +2359,118 @@ static void rs_build_rates_table_from_fixed(struct iwl_mvm *mvm,
 }
 #endif /* CONFIG_MAC80211_DEBUGFS */
 
+static void rs_fill_rates_for_column(struct iwl_mvm *mvm,
+				     struct iwl_lq_sta *lq_sta,
+				     struct rs_rate *rate,
+				     __le32 *rs_table, int *rs_table_index,
+				     int num_rates, int num_retries,
+				     u8 valid_tx_ant, bool toggle_ant)
+{
+	int i, j;
+	__le32 ucode_rate;
+	bool bottom_reached = false;
+	int prev_rate_idx = rate->index;
+	int end = LINK_QUAL_MAX_RETRY_NUM;
+	int index = *rs_table_index;
+
+	for (i = 0; i < num_rates && index < end; i++) {
+		ucode_rate = cpu_to_le32(ucode_rate_from_rs_rate(mvm, rate));
+		for (j = 0; j < num_retries && index < end; j++, index++)
+			rs_table[index] = ucode_rate;
+
+		if (toggle_ant)
+			rs_toggle_antenna(valid_tx_ant, rate);
+
+		prev_rate_idx = rate->index;
+		bottom_reached = rs_get_lower_rate_in_column(lq_sta, rate);
+		if (bottom_reached && !is_legacy(rate))
+			break;
+	}
+
+	if (!bottom_reached)
+		rate->index = prev_rate_idx;
+
+	*rs_table_index = index;
+}
+
+/* Building the rate table is non trivial. When we're in MIMO2/VHT/80Mhz/SGI
+ * column the rate table should look like this:
+ *
+ * rate[0] 0x400D019 VHT | ANT: AB BW: 80Mhz MCS: 9 NSS: 2 SGI
+ * rate[1] 0x400D019 VHT | ANT: AB BW: 80Mhz MCS: 9 NSS: 2 SGI
+ * rate[2] 0x400D018 VHT | ANT: AB BW: 80Mhz MCS: 8 NSS: 2 SGI
+ * rate[3] 0x400D018 VHT | ANT: AB BW: 80Mhz MCS: 8 NSS: 2 SGI
+ * rate[4] 0x400D017 VHT | ANT: AB BW: 80Mhz MCS: 7 NSS: 2 SGI
+ * rate[5] 0x400D017 VHT | ANT: AB BW: 80Mhz MCS: 7 NSS: 2 SGI
+ * rate[6] 0x4005007 VHT | ANT: A BW: 80Mhz MCS: 7 NSS: 1 NGI
+ * rate[7] 0x4009006 VHT | ANT: B BW: 80Mhz MCS: 6 NSS: 1 NGI
+ * rate[8] 0x4005005 VHT | ANT: A BW: 80Mhz MCS: 5 NSS: 1 NGI
+ * rate[9] 0x800B Legacy | ANT: B Rate: 36 Mbps
+ * rate[10] 0x4009 Legacy | ANT: A Rate: 24 Mbps
+ * rate[11] 0x8007 Legacy | ANT: B Rate: 18 Mbps
+ * rate[12] 0x4005 Legacy | ANT: A Rate: 12 Mbps
+ * rate[13] 0x800F Legacy | ANT: B Rate: 9 Mbps
+ * rate[14] 0x400D Legacy | ANT: A Rate: 6 Mbps
+ * rate[15] 0x800D Legacy | ANT: B Rate: 6 Mbps
+ */
 static void rs_build_rates_table(struct iwl_mvm *mvm,
 				 struct iwl_lq_sta *lq_sta,
 				 const struct rs_rate *initial_rate)
 {
 	struct rs_rate rate;
-	int index = 0;
-	int repeat_rate = 0;
-	u8 ant_toggle_cnt = 0;
-	u8 use_ht_possible = 1;
+	int num_rates, num_retries, index = 0;
 	u8 valid_tx_ant = 0;
 	struct iwl_lq_cmd *lq_cmd = &lq_sta->lq;
+	bool toggle_ant = false;
 
 	memcpy(&rate, initial_rate, sizeof(struct rs_rate));
 
-	lq_cmd->mimo_delim = is_mimo(&rate) ? 1 : 0;
-
-	/* Fill 1st table entry (index 0) */
-	lq_cmd->rs_table[index] = cpu_to_le32(
-		ucode_rate_from_rs_rate(mvm, &rate));
+	if (mvm)
+		valid_tx_ant = iwl_fw_valid_tx_ant(mvm->fw);
 
-	/* How many times should we repeat the initial rate? */
-	if (is_legacy(&rate)) {
-		ant_toggle_cnt = 1;
-		repeat_rate = IWL_NUMBER_TRY;
+	if (is_siso(&rate)) {
+		num_rates = RS_INITIAL_SISO_NUM_RATES;
+		num_retries = RS_HT_VHT_RETRIES_PER_RATE;
+	} else if (is_mimo(&rate)) {
+		num_rates = RS_INITIAL_MIMO_NUM_RATES;
+		num_retries = RS_HT_VHT_RETRIES_PER_RATE;
 	} else {
-		repeat_rate = min(IWL_HT_NUMBER_TRY,
-				  LINK_QUAL_AGG_DISABLE_START_DEF - 1);
+		num_rates = RS_INITIAL_LEGACY_NUM_RATES;
+		num_retries = RS_LEGACY_RETRIES_PER_RATE;
+		toggle_ant = true;
 	}
 
-	index++;
-	repeat_rate--;
-	if (mvm)
-		valid_tx_ant = iwl_fw_valid_tx_ant(mvm->fw);
+	rs_fill_rates_for_column(mvm, lq_sta, &rate, lq_cmd->rs_table, &index,
+				 num_rates, num_retries, valid_tx_ant,
+				 toggle_ant);
 
-	/* Fill rest of rate table */
-	while (index < LINK_QUAL_MAX_RETRY_NUM) {
-		/* Repeat initial/next rate.
-		 * For legacy IWL_NUMBER_TRY == 1, this loop will not execute.
-		 * For HT IWL_HT_NUMBER_TRY == 3, this executes twice. */
-		while (repeat_rate > 0 && (index < LINK_QUAL_MAX_RETRY_NUM)) {
-			if (is_legacy(&rate)) {
-				if (ant_toggle_cnt < NUM_TRY_BEFORE_ANT_TOGGLE)
-					ant_toggle_cnt++;
-				else if (mvm &&
-					 rs_toggle_antenna(valid_tx_ant, &rate))
-					ant_toggle_cnt = 1;
-			}
-
-			/* Fill next table entry */
-			lq_cmd->rs_table[index] = cpu_to_le32(
-				ucode_rate_from_rs_rate(mvm, &rate));
-			repeat_rate--;
-			index++;
-		}
+	rs_get_lower_rate_down_column(lq_sta, &rate);
 
-		/* Indicate to uCode which entries might be MIMO.
-		 * If initial rate was MIMO, this will finally end up
-		 * as (IWL_HT_NUMBER_TRY * 2), after 2nd pass, otherwise 0. */
-		if (is_mimo(&rate))
-			lq_cmd->mimo_delim = index;
+	if (is_siso(&rate)) {
+		num_rates = RS_SECONDARY_SISO_NUM_RATES;
+		num_retries = RS_SECONDARY_SISO_RETRIES;
+	} else if (is_legacy(&rate)) {
+		num_rates = RS_SECONDARY_LEGACY_NUM_RATES;
+		num_retries = RS_LEGACY_RETRIES_PER_RATE;
+	} else {
+		WARN_ON_ONCE(1);
+	}
 
-		/* Get next rate */
-		rs_get_lower_rate(lq_sta, &rate, rate.index, use_ht_possible);
+	toggle_ant = true;
 
-		/* How many times should we repeat the next rate? */
-		if (is_legacy(&rate)) {
-			if (ant_toggle_cnt < NUM_TRY_BEFORE_ANT_TOGGLE)
-				ant_toggle_cnt++;
-			else if (mvm &&
-				 rs_toggle_antenna(valid_tx_ant, &rate))
-				ant_toggle_cnt = 1;
+	rs_fill_rates_for_column(mvm, lq_sta, &rate, lq_cmd->rs_table, &index,
+				 num_rates, num_retries, valid_tx_ant,
+				 toggle_ant);
 
-			repeat_rate = IWL_NUMBER_TRY;
-		} else {
-			repeat_rate = IWL_HT_NUMBER_TRY;
-		}
+	rs_get_lower_rate_down_column(lq_sta, &rate);
 
-		/* Don't allow HT rates after next pass.
-		 * rs_get_lower_rate() will change type to LQ_LEGACY_A
-		 * or LQ_LEGACY_G.
-		 */
-		use_ht_possible = 0;
+	num_rates = RS_SECONDARY_LEGACY_NUM_RATES;
+	num_retries = RS_LEGACY_RETRIES_PER_RATE;
 
-		/* Fill next table entry */
-		lq_cmd->rs_table[index] = cpu_to_le32(
-			ucode_rate_from_rs_rate(mvm, &rate));
+	rs_fill_rates_for_column(mvm, lq_sta, &rate, lq_cmd->rs_table, &index,
+				 num_rates, num_retries, valid_tx_ant,
+				 toggle_ant);
 
-		index++;
-		repeat_rate--;
-	}
 }
 
 static void rs_fill_lq_cmd(struct iwl_mvm *mvm,
-- 
1.7.9.5

