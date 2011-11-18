Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755970Ab1KRIVn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:21:43 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8LhtS015721
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:21:43 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 25/77] iwlegacy: s/index/idx/
Date: Fri, 18 Nov 2011 09:21:47 +0100
Message-Id: <1321604559-10707-25-git-send-email-sgruszka@redhat.com> (sfid-20111118_092152_111003_0B12370B)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-3945-hw.h   |    6 +-
 drivers/net/wireless/iwlegacy/iwl-3945-rs.c   |  110 +++++-----
 drivers/net/wireless/iwlegacy/iwl-3945.c      |  314 ++++++++++++------------
 drivers/net/wireless/iwlegacy/iwl-4965-hw.h   |   36 ++--
 drivers/net/wireless/iwlegacy/iwl-4965-lib.c  |    4 +-
 drivers/net/wireless/iwlegacy/iwl-4965-rs.c   |  290 ++++++++++++------------
 drivers/net/wireless/iwlegacy/iwl-4965-sta.c  |   14 +-
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c   |   34 ++--
 drivers/net/wireless/iwlegacy/iwl-4965.c      |   84 ++++----
 drivers/net/wireless/iwlegacy/iwl-4965.h      |    4 +-
 drivers/net/wireless/iwlegacy/iwl-commands.h  |   42 ++--
 drivers/net/wireless/iwlegacy/iwl-csr.h       |    6 +-
 drivers/net/wireless/iwlegacy/iwl-dev.h       |   34 ++--
 drivers/net/wireless/iwlegacy/iwl-eeprom.c    |   30 ++--
 drivers/net/wireless/iwlegacy/iwl-eeprom.h    |    2 +-
 drivers/net/wireless/iwlegacy/iwl-fh.h        |   30 ++--
 drivers/net/wireless/iwlegacy/iwl-helpers.h   |   16 +-
 drivers/net/wireless/iwlegacy/iwl-led.c       |    2 +-
 drivers/net/wireless/iwlegacy/iwl-legacy-rs.h |    6 +-
 drivers/net/wireless/iwlegacy/iwl-prph.h      |   18 +-
 drivers/net/wireless/iwlegacy/iwl-rx.c        |   22 +-
 drivers/net/wireless/iwlegacy/iwl-sta.c       |   14 +-
 drivers/net/wireless/iwlegacy/iwl-sta.h       |    2 +-
 drivers/net/wireless/iwlegacy/iwl-tx.c        |   36 ++--
 drivers/net/wireless/iwlegacy/iwl3945-base.c  |   44 ++--
 drivers/net/wireless/iwlegacy/iwl4965-base.c  |   36 ++--
 26 files changed, 618 insertions(+), 618 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-3945-hw.h b/drivers/net/wireless/iwlegacy/iwl-3945-hw.h
index fcb466a..53e5fb4 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlegacy/iwl-3945-hw.h
@@ -81,7 +81,7 @@
 
 /*
  * Mapping of a Tx power level, at factory calibration temperature,
- *   to a radio/DSP gain table index.
+ *   to a radio/DSP gain table idx.
  * One for each of 5 "sample" power levels in each band.
  * v_det is measured at the factory, using the 3945's built-in power amplifier
  *   (PA) output voltage detector.  This same detector is used during Tx of
@@ -91,13 +91,13 @@
  * DO NOT ALTER THIS STRUCTURE!!!
  */
 struct il3945_eeprom_txpower_sample {
-	u8 gain_index;		/* index into power (gain) setup table ... */
+	u8 gain_idx;		/* idx into power (gain) setup table ... */
 	s8 power;		/* ... for this pwr level for this chnl group */
 	u16 v_det;		/* PA output voltage */
 } __packed;
 
 /*
- * Mappings of Tx power levels -> nominal radio/DSP gain table indexes.
+ * Mappings of Tx power levels -> nominal radio/DSP gain table idxes.
  * One for each channel group (a.k.a. "band") (1 for BG, 4 for A).
  * Tx power setup code interpolates between the 5 "sample" power levels
  *    to determine the nominal setup for a requested power level.
diff --git a/drivers/net/wireless/iwlegacy/iwl-3945-rs.c b/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
index 4d83c62..f84ed5e 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
@@ -60,7 +60,7 @@ static s32 il3945_expected_tpt_b[RATE_COUNT_3945] = {
 
 struct il3945_tpt_entry {
 	s8 min_rssi;
-	u8 index;
+	u8 idx;
 };
 
 static struct il3945_tpt_entry il3945_tpt_table_a[] = {
@@ -98,9 +98,9 @@ static struct il3945_tpt_entry il3945_tpt_table_g[] = {
 #define RATE_DECREASE_TH       1920
 #define RATE_RETRY_TH	     15
 
-static u8 il3945_get_rate_index_by_rssi(s32 rssi, enum ieee80211_band band)
+static u8 il3945_get_rate_idx_by_rssi(s32 rssi, enum ieee80211_band band)
 {
-	u32 index = 0;
+	u32 idx = 0;
 	u32 table_size = 0;
 	struct il3945_tpt_entry *tpt_table = NULL;
 
@@ -123,12 +123,12 @@ static u8 il3945_get_rate_index_by_rssi(s32 rssi, enum ieee80211_band band)
 		break;
 	}
 
-	while (index < table_size && rssi < tpt_table[index].min_rssi)
-		index++;
+	while (idx < table_size && rssi < tpt_table[idx].min_rssi)
+		idx++;
 
-	index = min(index, (table_size - 1));
+	idx = min(idx, (table_size - 1));
 
-	return tpt_table[index].index;
+	return tpt_table[idx].idx;
 }
 
 static void il3945_clear_win(struct il3945_rate_scale_data *win)
@@ -168,7 +168,7 @@ static int il3945_rate_scale_flush_wins(struct il3945_rs_sta *rs_sta)
 		if (time_after(jiffies, rs_sta->win[i].stamp +
 			       RATE_WIN_FLUSH)) {
 			D_RATE("flushing %d samples of rate "
-				       "index %d\n",
+				       "idx %d\n",
 				       rs_sta->win[i].counter, i);
 			il3945_clear_win(&rs_sta->win[i]);
 		} else
@@ -256,7 +256,7 @@ static void il3945_bg_rate_scale_flush(unsigned long data)
  */
 static void il3945_collect_tx_data(struct il3945_rs_sta *rs_sta,
 				struct il3945_rate_scale_data *win,
-				int success, int retries, int index)
+				int success, int retries, int idx)
 {
 	unsigned long flags;
 	s32 fail_count;
@@ -318,7 +318,7 @@ static void il3945_collect_tx_data(struct il3945_rs_sta *rs_sta,
 	if (fail_count >= RATE_MIN_FAILURE_TH ||
 	    win->success_counter >= RATE_MIN_SUCCESS_TH)
 		win->average_tpt = ((win->success_ratio *
-				rs_sta->expected_tpt[index] + 64) / 128);
+				rs_sta->expected_tpt[idx] + 64) / 128);
 	else
 		win->average_tpt = IL_INVALID_VALUE;
 
@@ -447,7 +447,7 @@ static void il3945_rs_tx_status(void *il_rate, struct ieee80211_supported_band *
 			 struct sk_buff *skb)
 {
 	s8 retries = 0, current_count;
-	int scale_rate_index, first_index, last_index;
+	int scale_rate_idx, first_idx, last_idx;
 	unsigned long flags;
 	struct il_priv *il = (struct il_priv *)il_rate;
 	struct il3945_rs_sta *rs_sta = il_sta;
@@ -460,9 +460,9 @@ static void il3945_rs_tx_status(void *il_rate, struct ieee80211_supported_band *
 	if (retries > RATE_RETRY_TH)
 		retries = RATE_RETRY_TH;
 
-	first_index = sband->bitrates[info->status.rates[0].idx].hw_value;
-	if (first_index < 0 || first_index >= RATE_COUNT_3945) {
-		D_RATE("leave: Rate out of bounds: %d\n", first_index);
+	first_idx = sband->bitrates[info->status.rates[0].idx].hw_value;
+	if (first_idx < 0 || first_idx >= RATE_COUNT_3945) {
+		D_RATE("leave: Rate out of bounds: %d\n", first_idx);
 		return;
 	}
 
@@ -480,8 +480,8 @@ static void il3945_rs_tx_status(void *il_rate, struct ieee80211_supported_band *
 
 	rs_sta->tx_packets++;
 
-	scale_rate_index = first_index;
-	last_index = first_index;
+	scale_rate_idx = first_idx;
+	last_idx = first_idx;
 
 	/*
 	 * Update the win for each rate.  We determine which rates
@@ -489,42 +489,42 @@ static void il3945_rs_tx_status(void *il_rate, struct ieee80211_supported_band *
 	 * of retries configured for each rate -- currently set to the
 	 * il value 'retry_rate' vs. rate specific
 	 *
-	 * On exit from this while loop last_index indicates the rate
+	 * On exit from this while loop last_idx indicates the rate
 	 * at which the frame was finally transmitted (or failed if no
 	 * ACK)
 	 */
 	while (retries > 1) {
 		if ((retries - 1) < il->retry_rate) {
 			current_count = (retries - 1);
-			last_index = scale_rate_index;
+			last_idx = scale_rate_idx;
 		} else {
 			current_count = il->retry_rate;
-			last_index = il3945_rs_next_rate(il,
-							 scale_rate_index);
+			last_idx = il3945_rs_next_rate(il,
+							 scale_rate_idx);
 		}
 
 		/* Update this rate accounting for as many retries
 		 * as was used for it (per current_count) */
 		il3945_collect_tx_data(rs_sta,
-				    &rs_sta->win[scale_rate_index],
-				    0, current_count, scale_rate_index);
+				    &rs_sta->win[scale_rate_idx],
+				    0, current_count, scale_rate_idx);
 		D_RATE("Update rate %d for %d retries.\n",
-			       scale_rate_index, current_count);
+			       scale_rate_idx, current_count);
 
 		retries -= current_count;
 
-		scale_rate_index = last_index;
+		scale_rate_idx = last_idx;
 	}
 
 
-	/* Update the last index win with success/failure based on ACK */
+	/* Update the last idx win with success/failure based on ACK */
 	D_RATE("Update rate %d with %s.\n",
-		       last_index,
+		       last_idx,
 		       (info->flags & IEEE80211_TX_STAT_ACK) ?
 		       "success" : "failure");
 	il3945_collect_tx_data(rs_sta,
-			    &rs_sta->win[last_index],
-			    info->flags & IEEE80211_TX_STAT_ACK, 1, last_index);
+			    &rs_sta->win[last_idx],
+			    info->flags & IEEE80211_TX_STAT_ACK, 1, last_idx);
 
 	/* We updated the rate scale win -- if its been more than
 	 * flush_time since the last run, schedule the flush
@@ -547,7 +547,7 @@ static void il3945_rs_tx_status(void *il_rate, struct ieee80211_supported_band *
 }
 
 static u16 il3945_get_adjacent_rate(struct il3945_rs_sta *rs_sta,
-				 u8 index, u16 rate_mask, enum ieee80211_band band)
+				 u8 idx, u16 rate_mask, enum ieee80211_band band)
 {
 	u8 high = RATE_INVALID;
 	u8 low = RATE_INVALID;
@@ -560,7 +560,7 @@ static u16 il3945_get_adjacent_rate(struct il3945_rs_sta *rs_sta,
 		u32 mask;
 
 		/* Find the previous rate that is in the rate mask */
-		i = index - 1;
+		i = idx - 1;
 		for (mask = (1 << i); i >= 0; i--, mask >>= 1) {
 			if (rate_mask & mask) {
 				low = i;
@@ -569,7 +569,7 @@ static u16 il3945_get_adjacent_rate(struct il3945_rs_sta *rs_sta,
 		}
 
 		/* Find the next rate that is in the rate mask */
-		i = index + 1;
+		i = idx + 1;
 		for (mask = (1 << i); i < RATE_COUNT_3945;
 		     i++, mask <<= 1) {
 			if (rate_mask & mask) {
@@ -581,7 +581,7 @@ static u16 il3945_get_adjacent_rate(struct il3945_rs_sta *rs_sta,
 		return (high << 8) | low;
 	}
 
-	low = index;
+	low = idx;
 	while (low != RATE_INVALID) {
 		if (rs_sta->tgg)
 			low = il3945_rates[low].prev_rs_tgg;
@@ -594,7 +594,7 @@ static u16 il3945_get_adjacent_rate(struct il3945_rs_sta *rs_sta,
 		D_RATE("Skipping masked lower rate: %d\n", low);
 	}
 
-	high = index;
+	high = idx;
 	while (high != RATE_INVALID) {
 		if (rs_sta->tgg)
 			high = il3945_rates[high].next_rs_tgg;
@@ -622,7 +622,7 @@ static u16 il3945_get_adjacent_rate(struct il3945_rs_sta *rs_sta,
  * the entire A/B/G spectrum vs. being limited to just one particular
  * hw_mode.
  *
- * As such, we can't convert the index obtained below into the hw_mode's
+ * As such, we can't convert the idx obtained below into the hw_mode's
  * rate table and must reference the driver allocated rate table
  *
  */
@@ -634,7 +634,7 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 	u8 low = RATE_INVALID;
 	u8 high = RATE_INVALID;
 	u16 high_low;
-	int index;
+	int idx;
 	struct il3945_rs_sta *rs_sta = il_sta;
 	struct il3945_rate_scale_data *win = NULL;
 	int current_tpt = IL_INVALID_VALUE;
@@ -668,7 +668,7 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 	if (max_rate_idx < 0 || max_rate_idx >= RATE_COUNT)
 		max_rate_idx = -1;
 
-	index = min(rs_sta->last_txrate_idx & 0xffff, RATE_COUNT_3945 - 1);
+	idx = min(rs_sta->last_txrate_idx & 0xffff, RATE_COUNT_3945 - 1);
 
 	if (sband->band == IEEE80211_BAND_5GHZ)
 		rate_mask = rate_mask << IL_FIRST_OFDM_RATE;
@@ -679,19 +679,19 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 	 * to rssi value
 	 */
 	if (rs_sta->start_rate != RATE_INVALID) {
-		if (rs_sta->start_rate < index &&
+		if (rs_sta->start_rate < idx &&
 		   (rate_mask & (1 << rs_sta->start_rate)))
-			index = rs_sta->start_rate;
+			idx = rs_sta->start_rate;
 		rs_sta->start_rate = RATE_INVALID;
 	}
 
 	/* force user max rate if set by user */
-	if (max_rate_idx != -1 && max_rate_idx < index) {
+	if (max_rate_idx != -1 && max_rate_idx < idx) {
 		if (rate_mask & (1 << max_rate_idx))
-			index = max_rate_idx;
+			idx = max_rate_idx;
 	}
 
-	win = &(rs_sta->win[index]);
+	win = &(rs_sta->win[idx]);
 
 	fail_count = win->counter - win->success_counter;
 
@@ -702,7 +702,7 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 		D_RATE("Invalid average_tpt on rate %d: "
 			       "counter: %d, success_counter: %d, "
 			       "expected_tpt is %sNULL\n",
-			       index,
+			       idx,
 			       win->counter,
 			       win->success_counter,
 			       rs_sta->expected_tpt ? "not " : "");
@@ -715,7 +715,7 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 
 	current_tpt = win->average_tpt;
 
-	high_low = il3945_get_adjacent_rate(rs_sta, index, rate_mask,
+	high_low = il3945_get_adjacent_rate(rs_sta, idx, rate_mask,
 					     sband->band);
 	low = high_low & 0xff;
 	high = (high_low >> 8) & 0xff;
@@ -800,13 +800,13 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 
 		/* Decrese rate */
 		if (low != RATE_INVALID)
-			index = low;
+			idx = low;
 		break;
 
 	case 1:
 		/* Increase rate */
 		if (high != RATE_INVALID)
-			index = high;
+			idx = high;
 
 		break;
 
@@ -817,21 +817,21 @@ static void il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta,
 	}
 
 	D_RATE("Selected %d (action %d) - low %d high %d\n",
-		       index, scale_action, low, high);
+		       idx, scale_action, low, high);
 
  out:
 
 	if (sband->band == IEEE80211_BAND_5GHZ) {
-		if (WARN_ON_ONCE(index < IL_FIRST_OFDM_RATE))
-			index = IL_FIRST_OFDM_RATE;
-		rs_sta->last_txrate_idx = index;
-		info->control.rates[0].idx = index - IL_FIRST_OFDM_RATE;
+		if (WARN_ON_ONCE(idx < IL_FIRST_OFDM_RATE))
+			idx = IL_FIRST_OFDM_RATE;
+		rs_sta->last_txrate_idx = idx;
+		info->control.rates[0].idx = idx - IL_FIRST_OFDM_RATE;
 	} else {
-		rs_sta->last_txrate_idx = index;
+		rs_sta->last_txrate_idx = idx;
 		info->control.rates[0].idx = rs_sta->last_txrate_idx;
 	}
 
-	D_RATE("leave: %d\n", index);
+	D_RATE("leave: %d\n", idx);
 }
 
 #ifdef CONFIG_MAC80211_DEBUGFS
@@ -855,7 +855,7 @@ static ssize_t il3945_sta_dbgfs_stats_table_read(struct file *file,
 	if (!buff)
 		return -ENOMEM;
 
-	desc += sprintf(buff + desc, "tx packets=%d last rate index=%d\n"
+	desc += sprintf(buff + desc, "tx packets=%d last rate idx=%d\n"
 			"rate=0x%X flush time %d\n",
 			lq_sta->tx_packets,
 			lq_sta->last_txrate_idx,
@@ -977,9 +977,9 @@ void il3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
 
 	D_RATE("Network RSSI: %d\n", rssi);
 
-	rs_sta->start_rate = il3945_get_rate_index_by_rssi(rssi, il->band);
+	rs_sta->start_rate = il3945_get_rate_idx_by_rssi(rssi, il->band);
 
-	D_RATE("leave: rssi %d assign rate index: "
+	D_RATE("leave: rssi %d assign rate idx: "
 		       "%d (plcp 0x%x)\n", rssi, rs_sta->start_rate,
 		       il3945_rates[rs_sta->start_rate].plcp);
 	rcu_read_unlock();
diff --git a/drivers/net/wireless/iwlegacy/iwl-3945.c b/drivers/net/wireless/iwlegacy/iwl-3945.c
index 3908bff..96a7628 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945.c
@@ -86,12 +86,12 @@ const struct il3945_rate_info il3945_rates[RATE_COUNT_3945] = {
 	IL_DECLARE_RATE_INFO(54, 48, INV, 48, INV, 48, INV),/* 54mbps */
 };
 
-static inline u8 il3945_get_prev_ieee_rate(u8 rate_index)
+static inline u8 il3945_get_prev_ieee_rate(u8 rate_idx)
 {
-	u8 rate = il3945_rates[rate_index].prev_ieee;
+	u8 rate = il3945_rates[rate_idx].prev_ieee;
 
 	if (rate == RATE_INVALID)
-		rate = rate_index;
+		rate = rate_idx;
 	return rate;
 }
 
@@ -270,12 +270,12 @@ int il3945_rs_next_rate(struct il_priv *il, int rate)
 /**
  * il3945_tx_queue_reclaim - Reclaim Tx queue entries already Tx'd
  *
- * When FW advances 'R' index, all entries between old and new 'R' index
+ * When FW advances 'R' idx, all entries between old and new 'R' idx
  * need to be reclaimed. As result, some free space forms. If there is
  * enough free space (> low mark), wake the stack that feeds us.
  */
 static void il3945_tx_queue_reclaim(struct il_priv *il,
-				     int txq_id, int index)
+				     int txq_id, int idx)
 {
 	struct il_tx_queue *txq = &il->txq[txq_id];
 	struct il_queue *q = &txq->q;
@@ -283,8 +283,8 @@ static void il3945_tx_queue_reclaim(struct il_priv *il,
 
 	BUG_ON(txq_id == IL39_CMD_QUEUE_NUM);
 
-	for (index = il_queue_inc_wrap(index, q->n_bd);
-		q->read_ptr != index;
+	for (idx = il_queue_inc_wrap(idx, q->n_bd);
+		q->read_ptr != idx;
 		q->read_ptr = il_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 
 		tx_info = &txq->txb[txq->q.read_ptr];
@@ -307,7 +307,7 @@ static void il3945_rx_reply_tx(struct il_priv *il,
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	int txq_id = SEQ_TO_QUEUE(sequence);
-	int index = SEQ_TO_IDX(sequence);
+	int idx = SEQ_TO_IDX(sequence);
 	struct il_tx_queue *txq = &il->txq[txq_id];
 	struct ieee80211_tx_info *info;
 	struct il3945_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
@@ -315,10 +315,10 @@ static void il3945_rx_reply_tx(struct il_priv *il,
 	int rate_idx;
 	int fail;
 
-	if (index >= txq->q.n_bd || il_queue_used(&txq->q, index) == 0) {
-		IL_ERR("Read index for DMA queue txq_id (%d) index %d "
+	if (idx >= txq->q.n_bd || il_queue_used(&txq->q, idx) == 0) {
+		IL_ERR("Read idx for DMA queue txq_id (%d) idx %d "
 			  "is out of range [0-%d] %d %d\n", txq_id,
-			  index, txq->q.n_bd, txq->q.write_ptr,
+			  idx, txq->q.n_bd, txq->q.write_ptr,
 			  txq->q.read_ptr);
 		return;
 	}
@@ -345,8 +345,8 @@ static void il3945_rx_reply_tx(struct il_priv *il,
 			txq_id, il3945_get_tx_fail_reason(status), status,
 			tx_resp->rate, tx_resp->failure_frame);
 
-	D_TX_REPLY("Tx queue reclaim %d\n", index);
-	il3945_tx_queue_reclaim(il, txq_id, index);
+	D_TX_REPLY("Tx queue reclaim %d\n", idx);
+	il3945_tx_queue_reclaim(il, txq_id, idx);
 
 	if (status & TX_ABORT_REQUIRED_MSK)
 		IL_ERR("TODO:  Implement Tx ABORT REQUIRED!!!\n");
@@ -616,15 +616,15 @@ int il3945_hw_txq_attach_buf_to_tfd(struct il_priv *il,
 }
 
 /**
- * il3945_hw_txq_free_tfd - Free one TFD, those at index [txq->q.read_ptr]
+ * il3945_hw_txq_free_tfd - Free one TFD, those at idx [txq->q.read_ptr]
  *
- * Does NOT advance any indexes
+ * Does NOT advance any idxes
  */
 void il3945_hw_txq_free_tfd(struct il_priv *il, struct il_tx_queue *txq)
 {
 	struct il3945_tfd *tfd_tmp = (struct il3945_tfd *)txq->tfds;
-	int index = txq->q.read_ptr;
-	struct il3945_tfd *tfd = &tfd_tmp[index];
+	int idx = txq->q.read_ptr;
+	struct il3945_tfd *tfd = &tfd_tmp[idx];
 	struct pci_dev *dev = il->pci_dev;
 	int i;
 	int counter;
@@ -640,8 +640,8 @@ void il3945_hw_txq_free_tfd(struct il_priv *il, struct il_tx_queue *txq)
 	/* Unmap tx_cmd */
 	if (counter)
 		pci_unmap_single(dev,
-				dma_unmap_addr(&txq->meta[index], mapping),
-				dma_unmap_len(&txq->meta[index], len),
+				dma_unmap_addr(&txq->meta[idx], mapping),
+				dma_unmap_len(&txq->meta[idx], len),
 				PCI_DMA_TODEVICE);
 
 	/* unmap chunks if any */
@@ -675,7 +675,7 @@ void il3945_hw_build_tx_cmd_rate(struct il_priv *il,
 				  int sta_id, int tx_id)
 {
 	u16 hw_value = ieee80211_get_tx_rate(il->hw, info)->hw_value;
-	u16 rate_index = min(hw_value & 0xffff, RATE_COUNT_3945);
+	u16 rate_idx = min(hw_value & 0xffff, RATE_COUNT_3945);
 	u16 rate_mask;
 	int rate;
 	u8 rts_retry_limit;
@@ -684,7 +684,7 @@ void il3945_hw_build_tx_cmd_rate(struct il_priv *il,
 	__le16 fc = hdr->frame_control;
 	struct il3945_tx_cmd *tx_cmd = (struct il3945_tx_cmd *)cmd->cmd.payload;
 
-	rate = il3945_rates[rate_index].plcp;
+	rate = il3945_rates[rate_idx].plcp;
 	tx_flags = tx_cmd->tx_flags;
 
 	/* We need to figure out how to get the sta->supp_rates while
@@ -1040,7 +1040,7 @@ void il3945_hw_txq_ctx_stop(struct il_priv *il)
 
 /**
  * il3945_hw_reg_adjust_power_by_temp
- * return index delta into power gain settings table
+ * return idx delta into power gain settings table
 */
 static int il3945_hw_reg_adjust_power_by_temp(int new_reading, int old_reading)
 {
@@ -1298,13 +1298,13 @@ static struct il3945_tx_power power_gain_table[2][IL_MAX_GAIN_ENTRIES] = {
 	 {3, 120} }		/* 5.x GHz, lowest power */
 };
 
-static inline u8 il3945_hw_reg_fix_power_index(int index)
+static inline u8 il3945_hw_reg_fix_power_idx(int idx)
 {
-	if (index < 0)
+	if (idx < 0)
 		return 0;
-	if (index >= IL_MAX_GAIN_ENTRIES)
+	if (idx >= IL_MAX_GAIN_ENTRIES)
 		return IL_MAX_GAIN_ENTRIES - 1;
-	return (u8) index;
+	return (u8) idx;
 }
 
 /* Kick off thermal recalibration check every 60 seconds */
@@ -1316,16 +1316,16 @@ static inline u8 il3945_hw_reg_fix_power_index(int index)
  * Set (in our channel info database) the direct scan Tx power for 1 Mbit (CCK)
  * or 6 Mbit (OFDM) rates.
  */
-static void il3945_hw_reg_set_scan_power(struct il_priv *il, u32 scan_tbl_index,
-			       s32 rate_index, const s8 *clip_pwrs,
+static void il3945_hw_reg_set_scan_power(struct il_priv *il, u32 scan_tbl_idx,
+			       s32 rate_idx, const s8 *clip_pwrs,
 			       struct il_channel_info *ch_info,
-			       int band_index)
+			       int band_idx)
 {
 	struct il3945_scan_power_info *scan_power_info;
 	s8 power;
-	u8 power_index;
+	u8 power_idx;
 
-	scan_power_info = &ch_info->scan_pwr_info[scan_tbl_index];
+	scan_power_info = &ch_info->scan_pwr_info[scan_tbl_idx];
 
 	/* use this channel group's 6Mbit clipping/saturation pwr,
 	 *   but cap at regulatory scan power restriction (set during init
@@ -1337,30 +1337,30 @@ static void il3945_hw_reg_set_scan_power(struct il_priv *il, u32 scan_tbl_index,
 
 	/* find difference between new scan *power* and current "normal"
 	 *   Tx *power* for 6Mb.  Use this difference (x2) to adjust the
-	 *   current "normal" temperature-compensated Tx power *index* for
+	 *   current "normal" temperature-compensated Tx power *idx* for
 	 *   this rate (1Mb or 6Mb) to yield new temp-compensated scan power
-	 *   *index*. */
-	power_index = ch_info->power_info[rate_index].power_table_index
+	 *   *idx*. */
+	power_idx = ch_info->power_info[rate_idx].power_table_idx
 	    - (power - ch_info->power_info
 	       [RATE_6M_IDX_TABLE].requested_power) * 2;
 
-	/* store reference index that we use when adjusting *all* scan
+	/* store reference idx that we use when adjusting *all* scan
 	 *   powers.  So we can accommodate user (all channel) or spectrum
 	 *   management (single channel) power changes "between" temperature
 	 *   feedback compensation procedures.
-	 * don't force fit this reference index into gain table; it may be a
+	 * don't force fit this reference idx into gain table; it may be a
 	 *   negative number.  This will help avoid errors when we're at
 	 *   the lower bounds (highest gains, for warmest temperatures)
 	 *   of the table. */
 
 	/* don't exceed table bounds for "real" setting */
-	power_index = il3945_hw_reg_fix_power_index(power_index);
+	power_idx = il3945_hw_reg_fix_power_idx(power_idx);
 
-	scan_power_info->power_table_index = power_index;
+	scan_power_info->power_table_idx = power_idx;
 	scan_power_info->tpc.tx_gain =
-	    power_gain_table[band_index][power_index].tx_gain;
+	    power_gain_table[band_idx][power_idx].tx_gain;
 	scan_power_info->tpc.dsp_atten =
-	    power_gain_table[band_index][power_index].dsp_atten;
+	    power_gain_table[band_idx][power_idx].dsp_atten;
 }
 
 /**
@@ -1438,7 +1438,7 @@ static int il3945_send_tx_power(struct il_priv *il)
  * il3945_hw_reg_set_new_power - Configures power tables at new levels
  * @ch_info: Channel to update.  Uses power_info.requested_power.
  *
- * Replace requested_power and base_power_index ch_info fields for
+ * Replace requested_power and base_power_idx ch_info fields for
  * one channel.
  *
  * Called if user or spectrum management changes power preferences.
@@ -1460,7 +1460,7 @@ static int il3945_hw_reg_set_new_power(struct il_priv *il,
 	int power;
 
 	/* Get this chnlgrp's rate-to-max/clip-powers table */
-	clip_pwrs = il->_3945.clip_groups[ch_info->group_index].clip_powers;
+	clip_pwrs = il->_3945.clip_groups[ch_info->group_idx].clip_powers;
 
 	/* Get this channel's rate-to-current-power settings table */
 	power_info = ch_info->power_info;
@@ -1476,9 +1476,9 @@ static int il3945_hw_reg_set_new_power(struct il_priv *il,
 			continue;
 
 		/* find difference between old and new requested powers,
-		 *    update base (non-temp-compensated) power index */
+		 *    update base (non-temp-compensated) power idx */
 		delta_idx = (power - power_info->requested_power) * 2;
-		power_info->base_power_index -= delta_idx;
+		power_info->base_power_idx -= delta_idx;
 
 		/* save new requested power value */
 		power_info->requested_power = power;
@@ -1496,9 +1496,9 @@ static int il3945_hw_reg_set_new_power(struct il_priv *il,
 		/* do all CCK rates' il3945_channel_power_info structures */
 		for (i = RATE_1M_IDX_TABLE; i <= RATE_11M_IDX_TABLE; i++) {
 			power_info->requested_power = power;
-			power_info->base_power_index =
+			power_info->base_power_idx =
 			    ch_info->power_info[RATE_12M_IDX_TABLE].
-			    base_power_index + IL_CCK_FROM_OFDM_IDX_DIFF;
+			    base_power_idx + IL_CCK_FROM_OFDM_IDX_DIFF;
 			++power_info;
 		}
 	}
@@ -1537,7 +1537,7 @@ static int il3945_hw_reg_get_ch_txpower_limit(struct il_channel_info *ch_info)
  * Compensate txpower settings of *all* channels for temperature.
  * This only accounts for the difference between current temperature
  *   and the factory calibration temperatures, and bases the new settings
- *   on the channel's base_power_index.
+ *   on the channel's base_power_idx.
  *
  * If RxOn is "associated", this sends the new Txpower to NIC!
  */
@@ -1545,11 +1545,11 @@ static int il3945_hw_reg_comp_txpower_temp(struct il_priv *il)
 {
 	struct il_channel_info *ch_info = NULL;
 	struct il3945_eeprom *eeprom = (struct il3945_eeprom *)il->eeprom;
-	int delta_index;
+	int delta_idx;
 	const s8 *clip_pwrs; /* array of h/w max power levels for each rate */
 	u8 a_band;
-	u8 rate_index;
-	u8 scan_tbl_index;
+	u8 rate_idx;
+	u8 scan_tbl_idx;
 	u8 i;
 	int ref_temp;
 	int temperature = il->temperature;
@@ -1565,41 +1565,41 @@ static int il3945_hw_reg_comp_txpower_temp(struct il_priv *il)
 		a_band = il_is_channel_a_band(ch_info);
 
 		/* Get this chnlgrp's factory calibration temperature */
-		ref_temp = (s16)eeprom->groups[ch_info->group_index].
+		ref_temp = (s16)eeprom->groups[ch_info->group_idx].
 		    temperature;
 
-		/* get power index adjustment based on current and factory
+		/* get power idx adjustment based on current and factory
 		 * temps */
-		delta_index = il3945_hw_reg_adjust_power_by_temp(temperature,
+		delta_idx = il3945_hw_reg_adjust_power_by_temp(temperature,
 							      ref_temp);
 
 		/* set tx power value for all rates, OFDM and CCK */
-		for (rate_index = 0; rate_index < RATE_COUNT_3945;
-		     rate_index++) {
+		for (rate_idx = 0; rate_idx < RATE_COUNT_3945;
+		     rate_idx++) {
 			int power_idx =
-			    ch_info->power_info[rate_index].base_power_index;
+			    ch_info->power_info[rate_idx].base_power_idx;
 
 			/* temperature compensate */
-			power_idx += delta_index;
+			power_idx += delta_idx;
 
 			/* stay within table range */
-			power_idx = il3945_hw_reg_fix_power_index(power_idx);
-			ch_info->power_info[rate_index].
-			    power_table_index = (u8) power_idx;
-			ch_info->power_info[rate_index].tpc =
+			power_idx = il3945_hw_reg_fix_power_idx(power_idx);
+			ch_info->power_info[rate_idx].
+			    power_table_idx = (u8) power_idx;
+			ch_info->power_info[rate_idx].tpc =
 			    power_gain_table[a_band][power_idx];
 		}
 
 		/* Get this chnlgrp's rate-to-max/clip-powers table */
-		clip_pwrs = il->_3945.clip_groups[ch_info->group_index].clip_powers;
+		clip_pwrs = il->_3945.clip_groups[ch_info->group_idx].clip_powers;
 
 		/* set scan tx power, 1Mbit for CCK, 6Mbit for OFDM */
-		for (scan_tbl_index = 0;
-		     scan_tbl_index < IL_NUM_SCAN_RATES; scan_tbl_index++) {
-			s32 actual_index = (scan_tbl_index == 0) ?
+		for (scan_tbl_idx = 0;
+		     scan_tbl_idx < IL_NUM_SCAN_RATES; scan_tbl_idx++) {
+			s32 actual_idx = (scan_tbl_idx == 0) ?
 			    RATE_1M_IDX_TABLE : RATE_6M_IDX_TABLE;
-			il3945_hw_reg_set_scan_power(il, scan_tbl_index,
-					   actual_index, clip_pwrs,
+			il3945_hw_reg_set_scan_power(il, scan_tbl_idx,
+					   actual_idx, clip_pwrs,
 					   ch_info, a_band);
 		}
 	}
@@ -1878,7 +1878,7 @@ static void il3945_bg_reg_txpower_periodic(struct work_struct *work)
 }
 
 /**
- * il3945_hw_reg_get_ch_grp_index - find the channel-group index (0-4)
+ * il3945_hw_reg_get_ch_grp_idx - find the channel-group idx (0-4)
  * 				   for the channel.
  *
  * This function is used when initializing channel-info structs.
@@ -1888,48 +1888,48 @@ static void il3945_bg_reg_txpower_periodic(struct work_struct *work)
  *	 on A-band, EEPROM's "group frequency" entries represent the top
  *	 channel in each group 1-4.  Group 5 All B/G channels are in group 0.
  */
-static u16 il3945_hw_reg_get_ch_grp_index(struct il_priv *il,
+static u16 il3945_hw_reg_get_ch_grp_idx(struct il_priv *il,
 				       const struct il_channel_info *ch_info)
 {
 	struct il3945_eeprom *eeprom = (struct il3945_eeprom *)il->eeprom;
 	struct il3945_eeprom_txpower_group *ch_grp = &eeprom->groups[0];
 	u8 group;
-	u16 group_index = 0;	/* based on factory calib frequencies */
+	u16 group_idx = 0;	/* based on factory calib frequencies */
 	u8 grp_channel;
 
-	/* Find the group index for the channel ... don't use index 1(?) */
+	/* Find the group idx for the channel ... don't use idx 1(?) */
 	if (il_is_channel_a_band(ch_info)) {
 		for (group = 1; group < 5; group++) {
 			grp_channel = ch_grp[group].group_channel;
 			if (ch_info->channel <= grp_channel) {
-				group_index = group;
+				group_idx = group;
 				break;
 			}
 		}
 		/* group 4 has a few channels *above* its factory cal freq */
 		if (group == 5)
-			group_index = 4;
+			group_idx = 4;
 	} else
-		group_index = 0;	/* 2.4 GHz, group 0 */
+		group_idx = 0;	/* 2.4 GHz, group 0 */
 
 	D_POWER("Chnl %d mapped to grp %d\n", ch_info->channel,
-			group_index);
-	return group_index;
+			group_idx);
+	return group_idx;
 }
 
 /**
- * il3945_hw_reg_get_matched_power_index - Interpolate to get nominal index
+ * il3945_hw_reg_get_matched_power_idx - Interpolate to get nominal idx
  *
- * Interpolate to get nominal (i.e. at factory calibration temperature) index
+ * Interpolate to get nominal (i.e. at factory calibration temperature) idx
  *   into radio/DSP gain settings table for requested power.
  */
-static int il3945_hw_reg_get_matched_power_index(struct il_priv *il,
+static int il3945_hw_reg_get_matched_power_idx(struct il_priv *il,
 				       s8 requested_power,
-				       s32 setting_index, s32 *new_index)
+				       s32 setting_idx, s32 *new_idx)
 {
 	const struct il3945_eeprom_txpower_group *chnl_grp = NULL;
 	struct il3945_eeprom *eeprom = (struct il3945_eeprom *)il->eeprom;
-	s32 index0, index1;
+	s32 idx0, idx1;
 	s32 power = 2 * requested_power;
 	s32 i;
 	const struct il3945_eeprom_txpower_sample *samples;
@@ -1937,45 +1937,45 @@ static int il3945_hw_reg_get_matched_power_index(struct il_priv *il,
 	s32 res;
 	s32 denominator;
 
-	chnl_grp = &eeprom->groups[setting_index];
+	chnl_grp = &eeprom->groups[setting_idx];
 	samples = chnl_grp->samples;
 	for (i = 0; i < 5; i++) {
 		if (power == samples[i].power) {
-			*new_index = samples[i].gain_index;
+			*new_idx = samples[i].gain_idx;
 			return 0;
 		}
 	}
 
 	if (power > samples[1].power) {
-		index0 = 0;
-		index1 = 1;
+		idx0 = 0;
+		idx1 = 1;
 	} else if (power > samples[2].power) {
-		index0 = 1;
-		index1 = 2;
+		idx0 = 1;
+		idx1 = 2;
 	} else if (power > samples[3].power) {
-		index0 = 2;
-		index1 = 3;
+		idx0 = 2;
+		idx1 = 3;
 	} else {
-		index0 = 3;
-		index1 = 4;
+		idx0 = 3;
+		idx1 = 4;
 	}
 
-	denominator = (s32) samples[index1].power - (s32) samples[index0].power;
+	denominator = (s32) samples[idx1].power - (s32) samples[idx0].power;
 	if (denominator == 0)
 		return -EINVAL;
-	gains0 = (s32) samples[index0].gain_index * (1 << 19);
-	gains1 = (s32) samples[index1].gain_index * (1 << 19);
+	gains0 = (s32) samples[idx0].gain_idx * (1 << 19);
+	gains1 = (s32) samples[idx1].gain_idx * (1 << 19);
 	res = gains0 + (gains1 - gains0) *
-	    ((s32) power - (s32) samples[index0].power) / denominator +
+	    ((s32) power - (s32) samples[idx0].power) / denominator +
 	    (1 << 18);
-	*new_index = res >> 19;
+	*new_idx = res >> 19;
 	return 0;
 }
 
 static void il3945_hw_reg_init_channel_groups(struct il_priv *il)
 {
 	u32 i;
-	s32 rate_index;
+	s32 rate_idx;
 	struct il3945_eeprom *eeprom = (struct il3945_eeprom *)il->eeprom;
 	const struct il3945_eeprom_txpower_group *group;
 
@@ -2009,9 +2009,9 @@ static void il3945_hw_reg_init_channel_groups(struct il_priv *il)
 		satur_pwr = (s8) (group->saturation_power >> 1);
 
 		/* fill in channel group's nominal powers for each rate */
-		for (rate_index = 0;
-		     rate_index < RATE_COUNT_3945; rate_index++, clip_pwrs++) {
-			switch (rate_index) {
+		for (rate_idx = 0;
+		     rate_idx < RATE_COUNT_3945; rate_idx++, clip_pwrs++) {
+			switch (rate_idx) {
 			case RATE_36M_IDX_TABLE:
 				if (i == 0)	/* B/G */
 					*clip_pwrs = satur_pwr;
@@ -2058,13 +2058,13 @@ int il3945_txpower_set_from_eeprom(struct il_priv *il)
 	struct il_channel_info *ch_info = NULL;
 	struct il3945_channel_power_info *pwr_info;
 	struct il3945_eeprom *eeprom = (struct il3945_eeprom *)il->eeprom;
-	int delta_index;
-	u8 rate_index;
-	u8 scan_tbl_index;
+	int delta_idx;
+	u8 rate_idx;
+	u8 scan_tbl_idx;
 	const s8 *clip_pwrs;	/* array of power levels for each rate */
 	u8 gain, dsp_atten;
 	s8 power;
-	u8 pwr_index, base_pwr_index, a_band;
+	u8 pwr_idx, base_pwr_idx, a_band;
 	u8 i;
 	int temperature;
 
@@ -2082,56 +2082,56 @@ int il3945_txpower_set_from_eeprom(struct il_priv *il)
 		if (!il_is_channel_valid(ch_info))
 			continue;
 
-		/* find this channel's channel group (*not* "band") index */
-		ch_info->group_index =
-			il3945_hw_reg_get_ch_grp_index(il, ch_info);
+		/* find this channel's channel group (*not* "band") idx */
+		ch_info->group_idx =
+			il3945_hw_reg_get_ch_grp_idx(il, ch_info);
 
 		/* Get this chnlgrp's rate->max/clip-powers table */
-		clip_pwrs = il->_3945.clip_groups[ch_info->group_index].clip_powers;
+		clip_pwrs = il->_3945.clip_groups[ch_info->group_idx].clip_powers;
 
-		/* calculate power index *adjustment* value according to
+		/* calculate power idx *adjustment* value according to
 		 *  diff between current temperature and factory temperature */
-		delta_index = il3945_hw_reg_adjust_power_by_temp(temperature,
-				eeprom->groups[ch_info->group_index].
+		delta_idx = il3945_hw_reg_adjust_power_by_temp(temperature,
+				eeprom->groups[ch_info->group_idx].
 				temperature);
 
-		D_POWER("Delta index for channel %d: %d [%d]\n",
-				ch_info->channel, delta_index, temperature +
+		D_POWER("Delta idx for channel %d: %d [%d]\n",
+				ch_info->channel, delta_idx, temperature +
 				IL_TEMP_CONVERT);
 
 		/* set tx power value for all OFDM rates */
-		for (rate_index = 0; rate_index < IL_OFDM_RATES;
-		     rate_index++) {
+		for (rate_idx = 0; rate_idx < IL_OFDM_RATES;
+		     rate_idx++) {
 			s32 uninitialized_var(power_idx);
 			int rc;
 
 			/* use channel group's clip-power table,
 			 *   but don't exceed channel's max power */
 			s8 pwr = min(ch_info->max_power_avg,
-				     clip_pwrs[rate_index]);
+				     clip_pwrs[rate_idx]);
 
-			pwr_info = &ch_info->power_info[rate_index];
+			pwr_info = &ch_info->power_info[rate_idx];
 
 			/* get base (i.e. at factory-measured temperature)
-			 *    power table index for this rate's power */
-			rc = il3945_hw_reg_get_matched_power_index(il, pwr,
-							 ch_info->group_index,
+			 *    power table idx for this rate's power */
+			rc = il3945_hw_reg_get_matched_power_idx(il, pwr,
+							 ch_info->group_idx,
 							 &power_idx);
 			if (rc) {
-				IL_ERR("Invalid power index\n");
+				IL_ERR("Invalid power idx\n");
 				return rc;
 			}
-			pwr_info->base_power_index = (u8) power_idx;
+			pwr_info->base_power_idx = (u8) power_idx;
 
 			/* temperature compensate */
-			power_idx += delta_index;
+			power_idx += delta_idx;
 
 			/* stay within range of gain table */
-			power_idx = il3945_hw_reg_fix_power_index(power_idx);
+			power_idx = il3945_hw_reg_fix_power_idx(power_idx);
 
 			/* fill 1 OFDM rate's il3945_channel_power_info struct */
 			pwr_info->requested_power = pwr;
-			pwr_info->power_table_index = (u8) power_idx;
+			pwr_info->power_table_idx = (u8) power_idx;
 			pwr_info->tpc.tx_gain =
 			    power_gain_table[a_band][power_idx].tx_gain;
 			pwr_info->tpc.dsp_atten =
@@ -2142,36 +2142,36 @@ int il3945_txpower_set_from_eeprom(struct il_priv *il)
 		pwr_info = &ch_info->power_info[RATE_12M_IDX_TABLE];
 		power = pwr_info->requested_power +
 			IL_CCK_FROM_OFDM_POWER_DIFF;
-		pwr_index = pwr_info->power_table_index +
+		pwr_idx = pwr_info->power_table_idx +
 			IL_CCK_FROM_OFDM_IDX_DIFF;
-		base_pwr_index = pwr_info->base_power_index +
+		base_pwr_idx = pwr_info->base_power_idx +
 			IL_CCK_FROM_OFDM_IDX_DIFF;
 
 		/* stay within table range */
-		pwr_index = il3945_hw_reg_fix_power_index(pwr_index);
-		gain = power_gain_table[a_band][pwr_index].tx_gain;
-		dsp_atten = power_gain_table[a_band][pwr_index].dsp_atten;
+		pwr_idx = il3945_hw_reg_fix_power_idx(pwr_idx);
+		gain = power_gain_table[a_band][pwr_idx].tx_gain;
+		dsp_atten = power_gain_table[a_band][pwr_idx].dsp_atten;
 
 		/* fill each CCK rate's il3945_channel_power_info structure
 		 * NOTE:  All CCK-rate Txpwrs are the same for a given chnl!
 		 * NOTE:  CCK rates start at end of OFDM rates! */
-		for (rate_index = 0;
-		     rate_index < IL_CCK_RATES; rate_index++) {
-			pwr_info = &ch_info->power_info[rate_index+IL_OFDM_RATES];
+		for (rate_idx = 0;
+		     rate_idx < IL_CCK_RATES; rate_idx++) {
+			pwr_info = &ch_info->power_info[rate_idx+IL_OFDM_RATES];
 			pwr_info->requested_power = power;
-			pwr_info->power_table_index = pwr_index;
-			pwr_info->base_power_index = base_pwr_index;
+			pwr_info->power_table_idx = pwr_idx;
+			pwr_info->base_power_idx = base_pwr_idx;
 			pwr_info->tpc.tx_gain = gain;
 			pwr_info->tpc.dsp_atten = dsp_atten;
 		}
 
 		/* set scan tx power, 1Mbit for CCK, 6Mbit for OFDM */
-		for (scan_tbl_index = 0;
-		     scan_tbl_index < IL_NUM_SCAN_RATES; scan_tbl_index++) {
-			s32 actual_index = (scan_tbl_index == 0) ?
+		for (scan_tbl_idx = 0;
+		     scan_tbl_idx < IL_NUM_SCAN_RATES; scan_tbl_idx++) {
+			s32 actual_idx = (scan_tbl_idx == 0) ?
 				RATE_1M_IDX_TABLE : RATE_6M_IDX_TABLE;
-			il3945_hw_reg_set_scan_power(il, scan_tbl_index,
-				actual_index, clip_pwrs, ch_info, a_band);
+			il3945_hw_reg_set_scan_power(il, scan_tbl_idx,
+				actual_idx, clip_pwrs, ch_info, a_band);
 		}
 	}
 
@@ -2304,21 +2304,21 @@ static int il3945_manage_ibss_station(struct il_priv *il,
  */
 int il3945_init_hw_rate_table(struct il_priv *il)
 {
-	int rc, i, index, prev_index;
+	int rc, i, idx, prev_idx;
 	struct il3945_rate_scaling_cmd rate_cmd = {
 		.reserved = {0, 0, 0},
 	};
 	struct il3945_rate_scaling_info *table = rate_cmd.table;
 
 	for (i = 0; i < ARRAY_SIZE(il3945_rates); i++) {
-		index = il3945_rates[i].table_rs_index;
+		idx = il3945_rates[i].table_rs_idx;
 
-		table[index].rate_n_flags =
+		table[idx].rate_n_flags =
 			il3945_hw_set_rate_n_flags(il3945_rates[i].plcp, 0);
-		table[index].try_cnt = il->retry_rate;
-		prev_index = il3945_get_prev_ieee_rate(i);
-		table[index].next_rate_index =
-				il3945_rates[prev_index].table_rs_index;
+		table[idx].try_cnt = il->retry_rate;
+		prev_idx = il3945_get_prev_ieee_rate(i);
+		table[idx].next_rate_idx =
+				il3945_rates[prev_idx].table_rs_idx;
 	}
 
 	switch (il->band) {
@@ -2328,16 +2328,16 @@ int il3945_init_hw_rate_table(struct il_priv *il)
 		 * have it fall back to the 6M OFDM rate */
 		for (i = RATE_1M_IDX_TABLE;
 			i <= RATE_11M_IDX_TABLE; i++)
-			table[i].next_rate_index =
-			  il3945_rates[IL_FIRST_OFDM_RATE].table_rs_index;
+			table[i].next_rate_idx =
+			  il3945_rates[IL_FIRST_OFDM_RATE].table_rs_idx;
 
 		/* Don't fall back to CCK rates */
-		table[RATE_12M_IDX_TABLE].next_rate_index =
+		table[RATE_12M_IDX_TABLE].next_rate_idx =
 						RATE_9M_IDX_TABLE;
 
 		/* Don't drop out of OFDM rates */
-		table[RATE_6M_IDX_TABLE].next_rate_index =
-		    il3945_rates[IL_FIRST_OFDM_RATE].table_rs_index;
+		table[RATE_6M_IDX_TABLE].next_rate_idx =
+		    il3945_rates[IL_FIRST_OFDM_RATE].table_rs_idx;
 		break;
 
 	case IEEE80211_BAND_2GHZ:
@@ -2348,15 +2348,15 @@ int il3945_init_hw_rate_table(struct il_priv *il)
 		if (!(il->_3945.sta_supp_rates & IL_OFDM_RATES_MASK) &&
 		    il_is_associated(il)) {
 
-			index = IL_FIRST_CCK_RATE;
+			idx = IL_FIRST_CCK_RATE;
 			for (i = RATE_6M_IDX_TABLE;
 			     i <= RATE_54M_IDX_TABLE; i++)
-				table[i].next_rate_index =
-					il3945_rates[index].table_rs_index;
+				table[i].next_rate_idx =
+					il3945_rates[idx].table_rs_idx;
 
-			index = RATE_11M_IDX_TABLE;
+			idx = RATE_11M_IDX_TABLE;
 			/* CCK shouldn't fall back to OFDM... */
-			table[index].next_rate_index = RATE_5M_IDX_TABLE;
+			table[idx].next_rate_idx = RATE_5M_IDX_TABLE;
 		}
 		break;
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-hw.h b/drivers/net/wireless/iwlegacy/iwl-4965-hw.h
index 2c1b000..5c8b8ba 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-hw.h
@@ -203,7 +203,7 @@ static inline int il4965_hw_valid_rtc_data_addr(u32 addr)
  * 1)  Compare desired txpower vs. (EEPROM) regulatory limit for this channel.
  *     Do not exceed regulatory limit; reduce target txpower if necessary.
  *
- *     If setting up txpowers for MIMO rates (rate indexes 8-15, 24-31),
+ *     If setting up txpowers for MIMO rates (rate idxes 8-15, 24-31),
  *     2 transmitters will be used simultaneously; driver must reduce the
  *     regulatory limit by 3 dB (half-power) for each transmitter, so the
  *     combined total output of the 2 transmitters is within regulatory limits.
@@ -269,7 +269,7 @@ static inline int il4965_hw_valid_rtc_data_addr(u32 addr)
  *     be used (although only one at a time) even for non-MIMO transmissions.
  *
  *     Driver should interpolate factory values for temperature, gain table
- *     index, and actual power.  The power amplifier detector values are
+ *     idx, and actual power.  The power amplifier detector values are
  *     not used by the driver.
  *
  *     Sanity check:  If the target channel happens to be one of the sample
@@ -278,13 +278,13 @@ static inline int il4965_hw_valid_rtc_data_addr(u32 addr)
  *
  *
  * 5)  Find difference between desired txpower and (interpolated)
- *     factory-measured txpower.  Using (interpolated) factory gain table index
- *     (shown elsewhere) as a starting point, adjust this index lower to
+ *     factory-measured txpower.  Using (interpolated) factory gain table idx
+ *     (shown elsewhere) as a starting point, adjust this idx lower to
  *     increase txpower, or higher to decrease txpower, until the target
  *     txpower is reached.  Each step in the gain table is 1/2 dB.
  *
  *     For example, if factory measured txpower is 16 dBm, and target txpower
- *     is 13 dBm, add 6 steps to the factory gain index to reduce txpower
+ *     is 13 dBm, add 6 steps to the factory gain idx to reduce txpower
  *     by 3 dB.
  *
  *
@@ -294,7 +294,7 @@ static inline int il4965_hw_valid_rtc_data_addr(u32 addr)
  *     "4965 temperature calculation".
  *
  *     If current temperature is higher than factory temperature, driver must
- *     increase gain (lower gain table index), and vice verse.
+ *     increase gain (lower gain table idx), and vice verse.
  *
  *     Temperature affects gain differently for different channels:
  *
@@ -313,16 +313,16 @@ static inline int il4965_hw_valid_rtc_data_addr(u32 addr)
  *     indicator (EEPROM).
  *
  *     If the current voltage is higher (indicator is lower) than factory
- *     voltage, gain should be reduced (gain table index increased) by:
+ *     voltage, gain should be reduced (gain table idx increased) by:
  *
  *     (eeprom - current) / 7
  *
  *     If the current voltage is lower (indicator is higher) than factory
- *     voltage, gain should be increased (gain table index decreased) by:
+ *     voltage, gain should be increased (gain table idx decreased) by:
  *
  *     2 * (current - eeprom) / 7
  *
- *     If number of index steps in either direction turns out to be > 2,
+ *     If number of idx steps in either direction turns out to be > 2,
  *     something is wrong ... just use 0.
  *
  *     NOTE:  Voltage compensation is independent of band/channel.
@@ -333,7 +333,7 @@ static inline int il4965_hw_valid_rtc_data_addr(u32 addr)
  *            may be calculated once and used until the next uCode bootload.
  *
  *
- * 8)  If setting up txpowers for MIMO rates (rate indexes 8-15, 24-31),
+ * 8)  If setting up txpowers for MIMO rates (rate idxes 8-15, 24-31),
  *     adjust txpower for each transmitter chain, so txpower is balanced
  *     between the two chains.  There are 5 pairs of tx_atten[group][chain]
  *     values in "initialize alive", one pair for each of 5 channel ranges:
@@ -344,7 +344,7 @@ static inline int il4965_hw_valid_rtc_data_addr(u32 addr)
  *     Group 3:  5 GHz channel 125-200
  *     Group 4:  2.4 GHz all channels
  *
- *     Add the tx_atten[group][chain] value to the index for the target chain.
+ *     Add the tx_atten[group][chain] value to the idx for the target chain.
  *     The values are signed, but are in pairs of 0 and a non-negative number,
  *     so as to reduce gain (if necessary) of the "hotter" channel.  This
  *     avoids any need to double-check for regulatory compliance after
@@ -352,7 +352,7 @@ static inline int il4965_hw_valid_rtc_data_addr(u32 addr)
  *
  *
  * 9)  If setting up for a CCK rate, lower the gain by adding a CCK compensation
- *     value to the index:
+ *     value to the idx:
  *
  *     Hardware rev B:  9 steps (4.5 dB)
  *     Hardware rev C:  5 steps (2.5 dB)
@@ -366,7 +366,7 @@ static inline int il4965_hw_valid_rtc_data_addr(u32 addr)
  *
  * 10) Select the gain table, based on band (2.4 vs 5 GHz).
  *
- *     Limit the adjusted index to stay within the table!
+ *     Limit the adjusted idx to stay within the table!
  *
  *
  * 11) Read gain table entries for DSP and radio gain, place into appropriate
@@ -389,7 +389,7 @@ static inline int il4965_hw_valid_rtc_data_addr(u32 addr)
  *
  * When calculating txpowers for CCK, after making sure that the target power
  * is within regulatory and saturation limits, driver must additionally
- * back off gain by adding these values to the gain table index.
+ * back off gain by adding these values to the gain table idx.
  *
  * Hardware rev for 4965 can be determined by reading CSR_HW_REV_WA_REG,
  * bits [3:2], 1 = B, 2 = C.
@@ -428,9 +428,9 @@ static inline int il4965_hw_valid_rtc_data_addr(u32 addr)
  * driver work with the same table).
  *
  * There are separate tables for 2.4 GHz and 5 GHz bands.  The 5 GHz table
- * has an extension (into negative indexes), in case the driver needs to
+ * has an extension (into negative idxes), in case the driver needs to
  * boost power setting for high device temperatures (higher than would be
- * present during factory calibration).  A 5 Ghz EEPROM index of "40"
+ * present during factory calibration).  A 5 Ghz EEPROM idx of "40"
  * corresponds to the 49th entry in the table used by the driver.
  */
 #define MIN_TX_GAIN_IDX		(0)  /* highest gain, lowest idx, 2.4 */
@@ -778,8 +778,8 @@ enum {
  *
  * When driver sets up a new TFD, it must also enter the total byte count
  * of the frame to be transmitted into the corresponding entry in the byte
- * count table for the chosen Tx queue.  If the TFD index is 0-63, the driver
- * must duplicate the byte count entry in corresponding index 256-319.
+ * count table for the chosen Tx queue.  If the TFD idx is 0-63, the driver
+ * must duplicate the byte count entry in corresponding idx 256-319.
  *
  * padding puts each byte count table on a 1024-byte boundary;
  * 4965 assumes tables are separated by 1024 bytes.
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
index ee04977..bbec6bd 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-lib.c
@@ -105,7 +105,7 @@ int il4965_rx_init(struct il_priv *il, struct il_rx_queue *rxq)
 	/* Stop Rx DMA */
 	il_wr(il, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
 
-	/* Reset driver's Rx queue write index */
+	/* Reset driver's Rx queue write idx */
 	il_wr(il, FH_RSCSR_CHNL0_RBDCB_WPTR_REG, 0);
 
 	/* Tell device where to find RBD circular buffer in DRAM */
@@ -222,7 +222,7 @@ static inline __le32 il4965_dma_addr2rbd_ptr(struct il_priv *il,
  * and we have free pre-allocated buffers, fill the ranks as much
  * as we can, pulling from rx_free.
  *
- * This moves the 'write' index forward to catch up with 'processed', and
+ * This moves the 'write' idx forward to catch up with 'processed', and
  * also updates the memory address in the firmware to reference the new
  * target buffer.
  */
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
index 7478e91..b8f8064 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
@@ -151,10 +151,10 @@ static void il4965_rs_stay_in_table(struct il_lq_sta *lq_sta,
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 static void il4965_rs_dbgfs_set_mcs(struct il_lq_sta *lq_sta,
-			     u32 *rate_n_flags, int index);
+			     u32 *rate_n_flags, int idx);
 #else
 static void il4965_rs_dbgfs_set_mcs(struct il_lq_sta *lq_sta,
-			     u32 *rate_n_flags, int index)
+			     u32 *rate_n_flags, int idx)
 {}
 #endif
 
@@ -271,7 +271,7 @@ static u8 il4965_rs_tl_add_packet(struct il_lq_sta *lq_data,
 {
 	u32 curr_time = jiffies_to_msecs(jiffies);
 	u32 time_diff;
-	s32 index;
+	s32 idx;
 	struct il_traffic_load *tl = NULL;
 	u8 tid;
 
@@ -299,19 +299,19 @@ static u8 il4965_rs_tl_add_packet(struct il_lq_sta *lq_data,
 	}
 
 	time_diff = TIME_WRAP_AROUND(tl->time_stamp, curr_time);
-	index = time_diff / TID_QUEUE_CELL_SPACING;
+	idx = time_diff / TID_QUEUE_CELL_SPACING;
 
 	/* The history is too long: remove data that is older than */
 	/* TID_MAX_TIME_DIFF */
-	if (index >= TID_QUEUE_MAX_SIZE)
+	if (idx >= TID_QUEUE_MAX_SIZE)
 		il4965_rs_tl_rm_old_stats(tl, curr_time);
 
-	index = (tl->head + index) % TID_QUEUE_MAX_SIZE;
-	tl->packet_count[index] = tl->packet_count[index] + 1;
+	idx = (tl->head + idx) % TID_QUEUE_MAX_SIZE;
+	tl->packet_count[idx] = tl->packet_count[idx] + 1;
 	tl->total = tl->total + 1;
 
-	if ((index + 1) > tl->queue_count)
-		tl->queue_count = index + 1;
+	if ((idx + 1) > tl->queue_count)
+		tl->queue_count = idx + 1;
 
 	return tid;
 }
@@ -323,7 +323,7 @@ static u32 il4965_rs_tl_get_load(struct il_lq_sta *lq_data, u8 tid)
 {
 	u32 curr_time = jiffies_to_msecs(jiffies);
 	u32 time_diff;
-	s32 index;
+	s32 idx;
 	struct il_traffic_load *tl = NULL;
 
 	if (tid >= TID_MAX_LOAD_COUNT)
@@ -337,11 +337,11 @@ static u32 il4965_rs_tl_get_load(struct il_lq_sta *lq_data, u8 tid)
 		return 0;
 
 	time_diff = TIME_WRAP_AROUND(tl->time_stamp, curr_time);
-	index = time_diff / TID_QUEUE_CELL_SPACING;
+	idx = time_diff / TID_QUEUE_CELL_SPACING;
 
 	/* The history is too long: remove data that is older than */
 	/* TID_MAX_TIME_DIFF */
-	if (index >= TID_QUEUE_MAX_SIZE)
+	if (idx >= TID_QUEUE_MAX_SIZE)
 		il4965_rs_tl_rm_old_stats(tl, curr_time);
 
 	return tl->total;
@@ -400,10 +400,10 @@ static inline int il4965_get_il4965_num_of_ant_from_rate(u32 rate_n_flags)
  * that wraps a NULL pointer check
  */
 static s32
-il4965_get_expected_tpt(struct il_scale_tbl_info *tbl, int rs_index)
+il4965_get_expected_tpt(struct il_scale_tbl_info *tbl, int rs_idx)
 {
 	if (tbl->expected_tpt)
-		return tbl->expected_tpt[rs_index];
+		return tbl->expected_tpt[rs_idx];
 	return 0;
 }
 
@@ -415,20 +415,20 @@ il4965_get_expected_tpt(struct il_scale_tbl_info *tbl, int rs_index)
  * packets.
  */
 static int il4965_rs_collect_tx_data(struct il_scale_tbl_info *tbl,
-			      int scale_index, int attempts, int successes)
+			      int scale_idx, int attempts, int successes)
 {
 	struct il_rate_scale_data *win = NULL;
 	static const u64 mask = (((u64)1) << (RATE_MAX_WINDOW - 1));
 	s32 fail_count, tpt;
 
-	if (scale_index < 0 || scale_index >= RATE_COUNT)
+	if (scale_idx < 0 || scale_idx >= RATE_COUNT)
 		return -EINVAL;
 
 	/* Select win for current tx bit rate */
-	win = &(tbl->win[scale_index]);
+	win = &(tbl->win[scale_idx]);
 
 	/* Get expected throughput */
-	tpt = il4965_get_expected_tpt(tbl, scale_index);
+	tpt = il4965_get_expected_tpt(tbl, scale_idx);
 
 	/*
 	 * Keep track of only the latest 62 tx frame attempts in this rate's
@@ -493,26 +493,26 @@ static int il4965_rs_collect_tx_data(struct il_scale_tbl_info *tbl,
  */
 static u32 il4965_rate_n_flags_from_tbl(struct il_priv *il,
 				 struct il_scale_tbl_info *tbl,
-				 int index, u8 use_green)
+				 int idx, u8 use_green)
 {
 	u32 rate_n_flags = 0;
 
 	if (is_legacy(tbl->lq_type)) {
-		rate_n_flags = il_rates[index].plcp;
-		if (index >= IL_FIRST_CCK_RATE && index <= IL_LAST_CCK_RATE)
+		rate_n_flags = il_rates[idx].plcp;
+		if (idx >= IL_FIRST_CCK_RATE && idx <= IL_LAST_CCK_RATE)
 			rate_n_flags |= RATE_MCS_CCK_MSK;
 
 	} else if (is_Ht(tbl->lq_type)) {
-		if (index > IL_LAST_OFDM_RATE) {
-			IL_ERR("Invalid HT rate index %d\n", index);
-			index = IL_LAST_OFDM_RATE;
+		if (idx > IL_LAST_OFDM_RATE) {
+			IL_ERR("Invalid HT rate idx %d\n", idx);
+			idx = IL_LAST_OFDM_RATE;
 		}
 		rate_n_flags = RATE_MCS_HT_MSK;
 
 		if (is_siso(tbl->lq_type))
-			rate_n_flags |=	il_rates[index].plcp_siso;
+			rate_n_flags |=	il_rates[idx].plcp_siso;
 		else
-			rate_n_flags |=	il_rates[index].plcp_mimo2;
+			rate_n_flags |=	il_rates[idx].plcp_mimo2;
 	} else {
 		IL_ERR("Invalid tbl->lq_type %d\n", tbl->lq_type);
 	}
@@ -666,7 +666,7 @@ static u16 il4965_rs_get_supported_rates(struct il_lq_sta *lq_sta,
 }
 
 static u16
-il4965_rs_get_adjacent_rate(struct il_priv *il, u8 index, u16 rate_mask,
+il4965_rs_get_adjacent_rate(struct il_priv *il, u8 idx, u16 rate_mask,
 				int rate_type)
 {
 	u8 high = RATE_INVALID;
@@ -679,7 +679,7 @@ il4965_rs_get_adjacent_rate(struct il_priv *il, u8 index, u16 rate_mask,
 		u32 mask;
 
 		/* Find the previous rate that is in the rate mask */
-		i = index - 1;
+		i = idx - 1;
 		for (mask = (1 << i); i >= 0; i--, mask >>= 1) {
 			if (rate_mask & mask) {
 				low = i;
@@ -688,7 +688,7 @@ il4965_rs_get_adjacent_rate(struct il_priv *il, u8 index, u16 rate_mask,
 		}
 
 		/* Find the next rate that is in the rate mask */
-		i = index + 1;
+		i = idx + 1;
 		for (mask = (1 << i); i < RATE_COUNT; i++, mask <<= 1) {
 			if (rate_mask & mask) {
 				high = i;
@@ -699,7 +699,7 @@ il4965_rs_get_adjacent_rate(struct il_priv *il, u8 index, u16 rate_mask,
 		return (high << 8) | low;
 	}
 
-	low = index;
+	low = idx;
 	while (low != RATE_INVALID) {
 		low = il_rates[low].prev_rs;
 		if (low == RATE_INVALID)
@@ -709,7 +709,7 @@ il4965_rs_get_adjacent_rate(struct il_priv *il, u8 index, u16 rate_mask,
 		D_RATE("Skipping masked lower rate: %d\n", low);
 	}
 
-	high = index;
+	high = idx;
 	while (high != RATE_INVALID) {
 		high = il_rates[high].next_rs;
 		if (high == RATE_INVALID)
@@ -724,7 +724,7 @@ il4965_rs_get_adjacent_rate(struct il_priv *il, u8 index, u16 rate_mask,
 
 static u32 il4965_rs_get_lower_rate(struct il_lq_sta *lq_sta,
 			     struct il_scale_tbl_info *tbl,
-			     u8 scale_index, u8 ht_possible)
+			     u8 scale_idx, u8 ht_possible)
 {
 	s32 low;
 	u16 rate_mask;
@@ -736,9 +736,9 @@ static u32 il4965_rs_get_lower_rate(struct il_lq_sta *lq_sta,
 	/* check if we need to switch from HT to legacy rates.
 	 * assumption is that mandatory rates (1Mbps or 6Mbps)
 	 * are always supported (spec demand) */
-	if (!is_legacy(tbl->lq_type) && (!ht_possible || !scale_index)) {
+	if (!is_legacy(tbl->lq_type) && (!ht_possible || !scale_idx)) {
 		switch_to_legacy = 1;
-		scale_index = rs_ht_to_legacy[scale_index];
+		scale_idx = rs_ht_to_legacy[scale_idx];
 		if (lq_sta->band == IEEE80211_BAND_5GHZ)
 			tbl->lq_type = LQ_A;
 		else
@@ -766,18 +766,18 @@ static u32 il4965_rs_get_lower_rate(struct il_lq_sta *lq_sta,
 	}
 
 	/* If we switched from HT to legacy, check current rate */
-	if (switch_to_legacy && (rate_mask & (1 << scale_index))) {
-		low = scale_index;
+	if (switch_to_legacy && (rate_mask & (1 << scale_idx))) {
+		low = scale_idx;
 		goto out;
 	}
 
 	high_low = il4965_rs_get_adjacent_rate(lq_sta->drv,
-					scale_index, rate_mask,
+					scale_idx, rate_mask,
 					tbl->lq_type);
 	low = high_low & 0xff;
 
 	if (low == RATE_INVALID)
-		low = scale_index;
+		low = scale_idx;
 
 out:
 	return il4965_rate_n_flags_from_tbl(lq_sta->drv, tbl, low, is_green);
@@ -803,7 +803,7 @@ il4965_rs_tx_status(void *il_r, struct ieee80211_supported_band *sband,
 {
 	int legacy_success;
 	int retries;
-	int rs_index, mac_index, i;
+	int rs_idx, mac_idx, i;
 	struct il_lq_sta *lq_sta = il_sta;
 	struct il_link_quality_cmd *table;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
@@ -848,35 +848,35 @@ il4965_rs_tx_status(void *il_r, struct ieee80211_supported_band *sband,
 	table = &lq_sta->lq;
 	tx_rate = le32_to_cpu(table->rs_table[0].rate_n_flags);
 	il4965_rs_get_tbl_info_from_mcs(tx_rate,
-			 il->band, &tbl_type, &rs_index);
+			 il->band, &tbl_type, &rs_idx);
 	if (il->band == IEEE80211_BAND_5GHZ)
-		rs_index -= IL_FIRST_OFDM_RATE;
+		rs_idx -= IL_FIRST_OFDM_RATE;
 	mac_flags = info->status.rates[0].flags;
-	mac_index = info->status.rates[0].idx;
+	mac_idx = info->status.rates[0].idx;
 	/* For HT packets, map MCS to PLCP */
 	if (mac_flags & IEEE80211_TX_RC_MCS) {
-		mac_index &= RATE_MCS_CODE_MSK;	/* Remove # of streams */
-		if (mac_index >= (RATE_9M_IDX - IL_FIRST_OFDM_RATE))
-			mac_index++;
+		mac_idx &= RATE_MCS_CODE_MSK;	/* Remove # of streams */
+		if (mac_idx >= (RATE_9M_IDX - IL_FIRST_OFDM_RATE))
+			mac_idx++;
 		/*
-		 * mac80211 HT index is always zero-indexed; we need to move
+		 * mac80211 HT idx is always zero-idxed; we need to move
 		 * HT OFDM rates after CCK rates in 2.4 GHz band
 		 */
 		if (il->band == IEEE80211_BAND_2GHZ)
-			mac_index += IL_FIRST_OFDM_RATE;
+			mac_idx += IL_FIRST_OFDM_RATE;
 	}
 	/* Here we actually compare this rate to the latest LQ command */
-	if (mac_index < 0 ||
+	if (mac_idx < 0 ||
 	    tbl_type.is_SGI != !!(mac_flags & IEEE80211_TX_RC_SHORT_GI) ||
 	    tbl_type.is_ht40 != !!(mac_flags & IEEE80211_TX_RC_40_MHZ_WIDTH) ||
 	    tbl_type.is_dup != !!(mac_flags & IEEE80211_TX_RC_DUP_DATA) ||
 	    tbl_type.ant_type != info->antenna_sel_tx ||
 	    !!(tx_rate & RATE_MCS_HT_MSK) != !!(mac_flags & IEEE80211_TX_RC_MCS) ||
 	    !!(tx_rate & RATE_MCS_GF_MSK) != !!(mac_flags & IEEE80211_TX_RC_GREEN_FIELD) ||
-	    rs_index != mac_index) {
+	    rs_idx != mac_idx) {
 		D_RATE(
 		"initial rate %d does not match %d (0x%x)\n",
-			 mac_index, rs_index, tx_rate);
+			 mac_idx, rs_idx, tx_rate);
 		/*
 		 * Since rates mis-match, the last LQ command may have failed.
 		 * After IL_MISSED_RATE_MAX mis-matches, resync the uCode with
@@ -927,13 +927,13 @@ il4965_rs_tx_status(void *il_r, struct ieee80211_supported_band *sband,
 	 * aggregated.
 	 *
 	 * For aggregation, all packets were transmitted at the same rate, the
-	 * first index into rate scale table.
+	 * first idx into rate scale table.
 	 */
 	if (info->flags & IEEE80211_TX_STAT_AMPDU) {
 		tx_rate = le32_to_cpu(table->rs_table[0].rate_n_flags);
 		il4965_rs_get_tbl_info_from_mcs(tx_rate, il->band, &tbl_type,
-				&rs_index);
-		il4965_rs_collect_tx_data(curr_tbl, rs_index,
+				&rs_idx);
+		il4965_rs_collect_tx_data(curr_tbl, rs_idx,
 				   info->status.ampdu_len,
 				   info->status.ampdu_ack_len);
 
@@ -957,7 +957,7 @@ il4965_rs_tx_status(void *il_r, struct ieee80211_supported_band *sband,
 		for (i = 0; i <= retries; ++i) {
 			tx_rate = le32_to_cpu(table->rs_table[i].rate_n_flags);
 			il4965_rs_get_tbl_info_from_mcs(tx_rate, il->band,
-					&tbl_type, &rs_index);
+					&tbl_type, &rs_idx);
 			/*
 			 * Only collect stats if retried rate is in the same RS
 			 * table as active/search.
@@ -969,7 +969,7 @@ il4965_rs_tx_status(void *il_r, struct ieee80211_supported_band *sband,
 				tmp_tbl = other_tbl;
 			else
 				continue;
-			il4965_rs_collect_tx_data(tmp_tbl, rs_index, 1,
+			il4965_rs_collect_tx_data(tmp_tbl, rs_idx, 1,
 					   i < retries ? 0 : legacy_success);
 		}
 
@@ -1074,20 +1074,20 @@ static void il4965_rs_set_expected_tpt_table(struct il_lq_sta *lq_sta,
 static s32 il4965_rs_get_best_rate(struct il_priv *il,
 			    struct il_lq_sta *lq_sta,
 			    struct il_scale_tbl_info *tbl,	/* "search" */
-			    u16 rate_mask, s8 index)
+			    u16 rate_mask, s8 idx)
 {
 	/* "active" values */
 	struct il_scale_tbl_info *active_tbl =
 	    &(lq_sta->lq_info[lq_sta->active_tbl]);
-	s32 active_sr = active_tbl->win[index].success_ratio;
-	s32 active_tpt = active_tbl->expected_tpt[index];
+	s32 active_sr = active_tbl->win[idx].success_ratio;
+	s32 active_tpt = active_tbl->expected_tpt[idx];
 
 	/* expected "search" throughput */
 	s32 *tpt_tbl = tbl->expected_tpt;
 
 	s32 new_rate, high, low, start_hi;
 	u16 high_low;
-	s8 rate = index;
+	s8 rate = idx;
 
 	new_rate = high = low = start_hi = RATE_INVALID;
 
@@ -1169,7 +1169,7 @@ static int il4965_rs_switch_to_mimo2(struct il_priv *il,
 			     struct il_lq_sta *lq_sta,
 			     struct ieee80211_conf *conf,
 			     struct ieee80211_sta *sta,
-			     struct il_scale_tbl_info *tbl, int index)
+			     struct il_scale_tbl_info *tbl, int idx)
 {
 	u16 rate_mask;
 	s32 rate;
@@ -1203,20 +1203,20 @@ static int il4965_rs_switch_to_mimo2(struct il_priv *il,
 
 	il4965_rs_set_expected_tpt_table(lq_sta, tbl);
 
-	rate = il4965_rs_get_best_rate(il, lq_sta, tbl, rate_mask, index);
+	rate = il4965_rs_get_best_rate(il, lq_sta, tbl, rate_mask, idx);
 
 	D_RATE("LQ: MIMO2 best rate %d mask %X\n",
 				rate, rate_mask);
 	if (rate == RATE_INVALID || !((1 << rate) & rate_mask)) {
 		D_RATE(
-				"Can't switch with index %d rate mask %x\n",
+				"Can't switch with idx %d rate mask %x\n",
 						rate, rate_mask);
 		return -1;
 	}
 	tbl->current_rate = il4965_rate_n_flags_from_tbl(il,
 						 tbl, rate, is_green);
 
-	D_RATE("LQ: Switch to new mcs %X index is green %X\n",
+	D_RATE("LQ: Switch to new mcs %X idx is green %X\n",
 		     tbl->current_rate, is_green);
 	return 0;
 }
@@ -1228,7 +1228,7 @@ static int il4965_rs_switch_to_siso(struct il_priv *il,
 			     struct il_lq_sta *lq_sta,
 			     struct ieee80211_conf *conf,
 			     struct ieee80211_sta *sta,
-			     struct il_scale_tbl_info *tbl, int index)
+			     struct il_scale_tbl_info *tbl, int idx)
 {
 	u16 rate_mask;
 	u8 is_green = lq_sta->is_green;
@@ -1256,18 +1256,18 @@ static int il4965_rs_switch_to_siso(struct il_priv *il,
 		tbl->is_SGI = 0; /*11n spec: no SGI in SISO+Greenfield*/
 
 	il4965_rs_set_expected_tpt_table(lq_sta, tbl);
-	rate = il4965_rs_get_best_rate(il, lq_sta, tbl, rate_mask, index);
+	rate = il4965_rs_get_best_rate(il, lq_sta, tbl, rate_mask, idx);
 
 	D_RATE("LQ: get best rate %d mask %X\n", rate, rate_mask);
 	if (rate == RATE_INVALID || !((1 << rate) & rate_mask)) {
 		D_RATE(
-			"can not switch with index %d rate mask %x\n",
+			"can not switch with idx %d rate mask %x\n",
 			     rate, rate_mask);
 		return -1;
 	}
 	tbl->current_rate = il4965_rate_n_flags_from_tbl(il,
 						tbl, rate, is_green);
-	D_RATE("LQ: Switch to new mcs %X index is green %X\n",
+	D_RATE("LQ: Switch to new mcs %X idx is green %X\n",
 		     tbl->current_rate, is_green);
 	return 0;
 }
@@ -1279,12 +1279,12 @@ static int il4965_rs_move_legacy_other(struct il_priv *il,
 				struct il_lq_sta *lq_sta,
 				struct ieee80211_conf *conf,
 				struct ieee80211_sta *sta,
-				int index)
+				int idx)
 {
 	struct il_scale_tbl_info *tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
 	struct il_scale_tbl_info *search_tbl =
 				&(lq_sta->lq_info[(1 - lq_sta->active_tbl)]);
-	struct il_rate_scale_data *win = &(tbl->win[index]);
+	struct il_rate_scale_data *win = &(tbl->win[idx]);
 	u32 sz = (sizeof(struct il_scale_tbl_info) -
 		  (sizeof(struct il_rate_scale_data) * RATE_COUNT));
 	u8 start_action;
@@ -1331,7 +1331,7 @@ static int il4965_rs_move_legacy_other(struct il_priv *il,
 			memcpy(search_tbl, tbl, sz);
 			search_tbl->is_SGI = 0;
 			ret = il4965_rs_switch_to_siso(il, lq_sta, conf, sta,
-						 search_tbl, index);
+						 search_tbl, idx);
 			if (!ret) {
 				lq_sta->action_counter = 0;
 				goto out;
@@ -1360,7 +1360,7 @@ static int il4965_rs_move_legacy_other(struct il_priv *il,
 
 			ret = il4965_rs_switch_to_mimo2(il, lq_sta,
 						conf, sta,
-						 search_tbl, index);
+						 search_tbl, idx);
 			if (!ret) {
 				lq_sta->action_counter = 0;
 				goto out;
@@ -1395,13 +1395,13 @@ out:
 static int il4965_rs_move_siso_to_other(struct il_priv *il,
 				 struct il_lq_sta *lq_sta,
 				 struct ieee80211_conf *conf,
-				 struct ieee80211_sta *sta, int index)
+				 struct ieee80211_sta *sta, int idx)
 {
 	u8 is_green = lq_sta->is_green;
 	struct il_scale_tbl_info *tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
 	struct il_scale_tbl_info *search_tbl =
 				&(lq_sta->lq_info[(1 - lq_sta->active_tbl)]);
-	struct il_rate_scale_data *win = &(tbl->win[index]);
+	struct il_rate_scale_data *win = &(tbl->win[idx]);
 	struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
 	u32 sz = (sizeof(struct il_scale_tbl_info) -
 		  (sizeof(struct il_rate_scale_data) * RATE_COUNT));
@@ -1455,7 +1455,7 @@ static int il4965_rs_move_siso_to_other(struct il_priv *il,
 
 			ret = il4965_rs_switch_to_mimo2(il, lq_sta,
 						conf, sta,
-						 search_tbl, index);
+						 search_tbl, idx);
 			if (!ret)
 				goto out;
 			break;
@@ -1481,12 +1481,12 @@ static int il4965_rs_move_siso_to_other(struct il_priv *il,
 			il4965_rs_set_expected_tpt_table(lq_sta, search_tbl);
 			if (tbl->is_SGI) {
 				s32 tpt = lq_sta->last_tpt / 100;
-				if (tpt >= search_tbl->expected_tpt[index])
+				if (tpt >= search_tbl->expected_tpt[idx])
 					break;
 			}
 			search_tbl->current_rate =
 				il4965_rate_n_flags_from_tbl(il, search_tbl,
-						      index, is_green);
+						      idx, is_green);
 			update_search_tbl_counter = 1;
 			goto out;
 		}
@@ -1517,13 +1517,13 @@ static int il4965_rs_move_siso_to_other(struct il_priv *il,
 static int il4965_rs_move_mimo2_to_other(struct il_priv *il,
 				 struct il_lq_sta *lq_sta,
 				 struct ieee80211_conf *conf,
-				 struct ieee80211_sta *sta, int index)
+				 struct ieee80211_sta *sta, int idx)
 {
 	s8 is_green = lq_sta->is_green;
 	struct il_scale_tbl_info *tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
 	struct il_scale_tbl_info *search_tbl =
 				&(lq_sta->lq_info[(1 - lq_sta->active_tbl)]);
-	struct il_rate_scale_data *win = &(tbl->win[index]);
+	struct il_rate_scale_data *win = &(tbl->win[idx]);
 	struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
 	u32 sz = (sizeof(struct il_scale_tbl_info) -
 		  (sizeof(struct il_rate_scale_data) * RATE_COUNT));
@@ -1575,7 +1575,7 @@ static int il4965_rs_move_mimo2_to_other(struct il_priv *il,
 
 			ret = il4965_rs_switch_to_siso(il, lq_sta,
 						conf, sta,
-						 search_tbl, index);
+						 search_tbl, idx);
 			if (!ret)
 				goto out;
 
@@ -1603,12 +1603,12 @@ static int il4965_rs_move_mimo2_to_other(struct il_priv *il,
 			 */
 			if (tbl->is_SGI) {
 				s32 tpt = lq_sta->last_tpt / 100;
-				if (tpt >= search_tbl->expected_tpt[index])
+				if (tpt >= search_tbl->expected_tpt[idx])
 					break;
 			}
 			search_tbl->current_rate =
 				il4965_rate_n_flags_from_tbl(il, search_tbl,
-						      index, is_green);
+						      idx, is_green);
 			update_search_tbl_counter = 1;
 			goto out;
 
@@ -1728,12 +1728,12 @@ static u32 il4965_rs_update_rate_tbl(struct il_priv *il,
 			      struct il_rxon_context *ctx,
 				struct il_lq_sta *lq_sta,
 				struct il_scale_tbl_info *tbl,
-				int index, u8 is_green)
+				int idx, u8 is_green)
 {
 	u32 rate;
 
 	/* Update uCode's rate table. */
-	rate = il4965_rate_n_flags_from_tbl(il, tbl, index, is_green);
+	rate = il4965_rate_n_flags_from_tbl(il, tbl, idx, is_green);
 	il4965_rs_fill_link_cmd(il, lq_sta, rate);
 	il_send_lq_cmd(il, ctx, &lq_sta->lq, CMD_ASYNC, false);
 
@@ -1754,7 +1754,7 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	int low = RATE_INVALID;
 	int high = RATE_INVALID;
-	int index;
+	int idx;
 	int i;
 	struct il_rate_scale_data *win = NULL;
 	int current_tpt = IL_INVALID_VALUE;
@@ -1765,7 +1765,7 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 	u16 rate_mask;
 	u8 update_lq = 0;
 	struct il_scale_tbl_info *tbl, *tbl1;
-	u16 rate_scale_index_msk = 0;
+	u16 rate_scale_idx_msk = 0;
 	u32 rate;
 	u8 is_green = 0;
 	u8 active_tbl = 0;
@@ -1818,9 +1818,9 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 	is_green = lq_sta->is_green;
 
 	/* current tx rate */
-	index = lq_sta->last_txrate_idx;
+	idx = lq_sta->last_txrate_idx;
 
-	D_RATE("Rate scale index %d for type %d\n", index,
+	D_RATE("Rate scale idx %d for type %d\n", idx,
 		       tbl->lq_type);
 
 	/* rates available for this association, and for modulation mode */
@@ -1832,19 +1832,19 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 	if (is_legacy(tbl->lq_type)) {
 		if (lq_sta->band == IEEE80211_BAND_5GHZ)
 			/* supp_rates has no CCK bits in A mode */
-			rate_scale_index_msk = (u16) (rate_mask &
+			rate_scale_idx_msk = (u16) (rate_mask &
 				(lq_sta->supp_rates << IL_FIRST_OFDM_RATE));
 		else
-			rate_scale_index_msk = (u16) (rate_mask &
+			rate_scale_idx_msk = (u16) (rate_mask &
 						      lq_sta->supp_rates);
 
 	} else
-		rate_scale_index_msk = rate_mask;
+		rate_scale_idx_msk = rate_mask;
 
-	if (!rate_scale_index_msk)
-		rate_scale_index_msk = rate_mask;
+	if (!rate_scale_idx_msk)
+		rate_scale_idx_msk = rate_mask;
 
-	if (!((1 << index) & rate_scale_index_msk)) {
+	if (!((1 << idx) & rate_scale_idx_msk)) {
 		IL_ERR("Current Rate is not valid\n");
 		if (lq_sta->search_better_tbl) {
 			/* revert to active table if search table is not valid*/
@@ -1852,9 +1852,9 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 			lq_sta->search_better_tbl = 0;
 			tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
 			/* get "active" rate info */
-			index = il4965_hwrate_to_plcp_idx(tbl->current_rate);
+			idx = il4965_hwrate_to_plcp_idx(tbl->current_rate);
 			rate = il4965_rs_update_rate_tbl(il, ctx, lq_sta,
-						  tbl, index, is_green);
+						  tbl, idx, is_green);
 		}
 		return;
 	}
@@ -1867,14 +1867,14 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 
 	/* force user max rate if set by user */
 	if (lq_sta->max_rate_idx != -1 &&
-	    lq_sta->max_rate_idx < index) {
-		index = lq_sta->max_rate_idx;
+	    lq_sta->max_rate_idx < idx) {
+		idx = lq_sta->max_rate_idx;
 		update_lq = 1;
-		win = &(tbl->win[index]);
+		win = &(tbl->win[idx]);
 		goto lq_update;
 	}
 
-	win = &(tbl->win[index]);
+	win = &(tbl->win[idx]);
 
 	/*
 	 * If there is not enough history to calculate actual average
@@ -1887,8 +1887,8 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 	if (fail_count < RATE_MIN_FAILURE_TH &&
 	    win->success_counter < RATE_MIN_SUCCESS_TH) {
 		D_RATE("LQ: still below TH. succ=%d total=%d "
-			       "for index %d\n",
-			       win->success_counter, win->counter, index);
+			       "for idx %d\n",
+			       win->success_counter, win->counter, idx);
 
 		/* Can't calculate this yet; not enough history */
 		win->average_tpt = IL_INVALID_VALUE;
@@ -1902,11 +1902,11 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 	/* Else we have enough samples; calculate estimate of
 	 * actual average throughput */
 	if (win->average_tpt != ((win->success_ratio *
-			tbl->expected_tpt[index] + 64) / 128)) {
+			tbl->expected_tpt[idx] + 64) / 128)) {
 		IL_ERR(
 			 "expected_tpt should have been calculated by now\n");
 		win->average_tpt = ((win->success_ratio *
-					tbl->expected_tpt[index] + 64) / 128);
+					tbl->expected_tpt[idx] + 64) / 128);
 	}
 
 	/* If we are searching for better modulation mode, check success. */
@@ -1946,7 +1946,7 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 			tbl = &(lq_sta->lq_info[active_tbl]);
 
 			/* Revert to "active" rate and throughput info */
-			index = il4965_hwrate_to_plcp_idx(tbl->current_rate);
+			idx = il4965_hwrate_to_plcp_idx(tbl->current_rate);
 			current_tpt = lq_sta->last_tpt;
 
 			/* Need to set up a new rate table in uCode */
@@ -1962,8 +1962,8 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 
 	/* (Else) not in search of better modulation mode, try for better
 	 * starting rate, while staying in this mode. */
-	high_low = il4965_rs_get_adjacent_rate(il, index,
-					rate_scale_index_msk,
+	high_low = il4965_rs_get_adjacent_rate(il, idx,
+					rate_scale_idx_msk,
 					tbl->lq_type);
 	low = high_low & 0xff;
 	high = (high_low >> 8) & 0xff;
@@ -2043,7 +2043,7 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 		/* Decrease starting rate, update uCode's rate table */
 		if (low != RATE_INVALID) {
 			update_lq = 1;
-			index = low;
+			idx = low;
 		}
 
 		break;
@@ -2051,7 +2051,7 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 		/* Increase starting rate, update uCode's rate table */
 		if (high != RATE_INVALID) {
 			update_lq = 1;
-			index = high;
+			idx = high;
 		}
 
 		break;
@@ -2061,15 +2061,15 @@ static void il4965_rs_rate_scale_perform(struct il_priv *il,
 		break;
 	}
 
-	D_RATE("choose rate scale index %d action %d low %d "
+	D_RATE("choose rate scale idx %d action %d low %d "
 		    "high %d type %d\n",
-		     index, scale_action, low, high, tbl->lq_type);
+		     idx, scale_action, low, high, tbl->lq_type);
 
 lq_update:
 	/* Replace uCode's rate table for the destination station. */
 	if (update_lq)
 		rate = il4965_rs_update_rate_tbl(il, ctx, lq_sta,
-					  tbl, index, is_green);
+					  tbl, idx, is_green);
 
 	/* Should we stay with this modulation mode,
 	 * or search for a new one? */
@@ -2090,13 +2090,13 @@ lq_update:
 		 * If one is found, set up the new "search" table. */
 		if (is_legacy(tbl->lq_type))
 			il4965_rs_move_legacy_other(il, lq_sta,
-							conf, sta, index);
+							conf, sta, idx);
 		else if (is_siso(tbl->lq_type))
 			il4965_rs_move_siso_to_other(il, lq_sta,
-							conf, sta, index);
+							conf, sta, idx);
 		else /* (is_mimo2(tbl->lq_type)) */
 			il4965_rs_move_mimo2_to_other(il, lq_sta,
-							conf, sta, index);
+							conf, sta, idx);
 
 		/* If new "search" mode was selected, set up in uCode table */
 		if (lq_sta->search_better_tbl) {
@@ -2107,11 +2107,11 @@ lq_update:
 							&(tbl->win[i]));
 
 			/* Use new "search" start rate */
-			index = il4965_hwrate_to_plcp_idx(tbl->current_rate);
+			idx = il4965_hwrate_to_plcp_idx(tbl->current_rate);
 
 			D_RATE(
-				"Switch current  mcs: %X index: %d\n",
-				     tbl->current_rate, index);
+				"Switch current  mcs: %X idx: %d\n",
+				     tbl->current_rate, idx);
 			il4965_rs_fill_link_cmd(il, lq_sta,
 						tbl->current_rate);
 			il_send_lq_cmd(il, ctx,
@@ -2157,8 +2157,8 @@ lq_update:
 
 out:
 	tbl->current_rate = il4965_rate_n_flags_from_tbl(il, tbl,
-							index, is_green);
-	i = index;
+							idx, is_green);
+	i = idx;
 	lq_sta->last_txrate_idx = i;
 }
 
@@ -2272,7 +2272,7 @@ il4965_rs_get_rate(void *il_r, struct ieee80211_sta *sta, void *il_sta,
 
 	if (lq_sta->last_rate_n_flags & RATE_MCS_HT_MSK) {
 		rate_idx -= IL_FIRST_OFDM_RATE;
-		/* 6M and 9M shared same MCS index */
+		/* 6M and 9M shared same MCS idx */
 		rate_idx = (rate_idx > 0) ? (rate_idx - 1) : 0;
 		if (il4965_rs_extract_rate(lq_sta->last_rate_n_flags) >=
 			 RATE_MIMO2_6M_PLCP)
@@ -2296,7 +2296,7 @@ il4965_rs_get_rate(void *il_r, struct ieee80211_sta *sta, void *il_sta,
 		    (sband->band == IEEE80211_BAND_5GHZ &&
 		     rate_idx < IL_FIRST_OFDM_RATE))
 			rate_idx = rate_lowest_index(sband, sta);
-		/* On valid 5 GHz rate, adjust index */
+		/* On valid 5 GHz rate, adjust idx */
 		else if (sband->band == IEEE80211_BAND_5GHZ)
 			rate_idx -= IL_FIRST_OFDM_RATE;
 		info->control.rates[0].flags = 0;
@@ -2419,7 +2419,7 @@ static void il4965_rs_fill_link_cmd(struct il_priv *il,
 			     struct il_lq_sta *lq_sta, u32 new_rate)
 {
 	struct il_scale_tbl_info tbl_type;
-	int index = 0;
+	int idx = 0;
 	int rate_idx;
 	int repeat_rate = 0;
 	u8 ant_toggle_cnt = 0;
@@ -2427,8 +2427,8 @@ static void il4965_rs_fill_link_cmd(struct il_priv *il,
 	u8 valid_tx_ant = 0;
 	struct il_link_quality_cmd *lq_cmd = &lq_sta->lq;
 
-	/* Override starting rate (index 0) if needed for debug purposes */
-	il4965_rs_dbgfs_set_mcs(lq_sta, &new_rate, index);
+	/* Override starting rate (idx 0) if needed for debug purposes */
+	il4965_rs_dbgfs_set_mcs(lq_sta, &new_rate, idx);
 
 	/* Interpret new_rate (rate_n_flags) */
 	il4965_rs_get_tbl_info_from_mcs(new_rate, lq_sta->band,
@@ -2445,8 +2445,8 @@ static void il4965_rs_fill_link_cmd(struct il_priv *il,
 	lq_cmd->general_params.mimo_delimiter =
 			is_mimo(tbl_type.lq_type) ? 1 : 0;
 
-	/* Fill 1st table entry (index 0) */
-	lq_cmd->rs_table[index].rate_n_flags = cpu_to_le32(new_rate);
+	/* Fill 1st table entry (idx 0) */
+	lq_cmd->rs_table[idx].rate_n_flags = cpu_to_le32(new_rate);
 
 	if (il4965_num_of_ant(tbl_type.ant_type) == 1) {
 		lq_cmd->general_params.single_stream_ant_msk =
@@ -2456,17 +2456,17 @@ static void il4965_rs_fill_link_cmd(struct il_priv *il,
 						tbl_type.ant_type;
 	} /* otherwise we don't modify the existing value */
 
-	index++;
+	idx++;
 	repeat_rate--;
 	if (il)
 		valid_tx_ant = il->hw_params.valid_tx_ant;
 
 	/* Fill rest of rate table */
-	while (index < LINK_QUAL_MAX_RETRY_NUM) {
+	while (idx < LINK_QUAL_MAX_RETRY_NUM) {
 		/* Repeat initial/next rate.
 		 * For legacy IL_NUMBER_TRY == 1, this loop will not execute.
 		 * For HT IL_HT_NUMBER_TRY == 3, this executes twice. */
-		while (repeat_rate > 0 && index < LINK_QUAL_MAX_RETRY_NUM) {
+		while (repeat_rate > 0 && idx < LINK_QUAL_MAX_RETRY_NUM) {
 			if (is_legacy(tbl_type.lq_type)) {
 				if (ant_toggle_cnt < NUM_TRY_BEFORE_ANT_TOGGLE)
 					ant_toggle_cnt++;
@@ -2477,13 +2477,13 @@ static void il4965_rs_fill_link_cmd(struct il_priv *il,
 			}
 
 			/* Override next rate if needed for debug purposes */
-			il4965_rs_dbgfs_set_mcs(lq_sta, &new_rate, index);
+			il4965_rs_dbgfs_set_mcs(lq_sta, &new_rate, idx);
 
 			/* Fill next table entry */
-			lq_cmd->rs_table[index].rate_n_flags =
+			lq_cmd->rs_table[idx].rate_n_flags =
 					cpu_to_le32(new_rate);
 			repeat_rate--;
-			index++;
+			idx++;
 		}
 
 		il4965_rs_get_tbl_info_from_mcs(new_rate,
@@ -2494,7 +2494,7 @@ static void il4965_rs_fill_link_cmd(struct il_priv *il,
 		 * If initial rate was MIMO, this will finally end up
 		 * as (IL_HT_NUMBER_TRY * 2), after 2nd pass, otherwise 0. */
 		if (is_mimo(tbl_type.lq_type))
-			lq_cmd->general_params.mimo_delimiter = index;
+			lq_cmd->general_params.mimo_delimiter = idx;
 
 		/* Get next rate */
 		new_rate = il4965_rs_get_lower_rate(lq_sta,
@@ -2520,12 +2520,12 @@ static void il4965_rs_fill_link_cmd(struct il_priv *il,
 		use_ht_possible = 0;
 
 		/* Override next rate if needed for debug purposes */
-		il4965_rs_dbgfs_set_mcs(lq_sta, &new_rate, index);
+		il4965_rs_dbgfs_set_mcs(lq_sta, &new_rate, idx);
 
 		/* Fill next table entry */
-		lq_cmd->rs_table[index].rate_n_flags = cpu_to_le32(new_rate);
+		lq_cmd->rs_table[idx].rate_n_flags = cpu_to_le32(new_rate);
 
-		index++;
+		idx++;
 		repeat_rate--;
 	}
 
@@ -2564,7 +2564,7 @@ static int il4965_open_file_generic(struct inode *inode, struct file *file)
 	return 0;
 }
 static void il4965_rs_dbgfs_set_mcs(struct il_lq_sta *lq_sta,
-			     u32 *rate_n_flags, int index)
+			     u32 *rate_n_flags, int idx)
 {
 	struct il_priv *il;
 	u8 valid_tx_ant;
@@ -2636,7 +2636,7 @@ static ssize_t il4965_rs_sta_dbgfs_scale_table_read(struct file *file,
 	char *buff;
 	int desc = 0;
 	int i = 0;
-	int index = 0;
+	int idx = 0;
 	ssize_t ret;
 
 	struct il_lq_sta *lq_sta = file->private_data;
@@ -2687,25 +2687,25 @@ static ssize_t il4965_rs_sta_dbgfs_scale_table_read(struct file *file,
 
 	desc += sprintf(buff+desc,
 			"Start idx [0]=0x%x [1]=0x%x [2]=0x%x [3]=0x%x\n",
-			lq_sta->lq.general_params.start_rate_index[0],
-			lq_sta->lq.general_params.start_rate_index[1],
-			lq_sta->lq.general_params.start_rate_index[2],
-			lq_sta->lq.general_params.start_rate_index[3]);
+			lq_sta->lq.general_params.start_rate_idx[0],
+			lq_sta->lq.general_params.start_rate_idx[1],
+			lq_sta->lq.general_params.start_rate_idx[2],
+			lq_sta->lq.general_params.start_rate_idx[3]);
 
 	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++) {
-		index = il4965_hwrate_to_plcp_idx(
+		idx = il4965_hwrate_to_plcp_idx(
 			le32_to_cpu(lq_sta->lq.rs_table[i].rate_n_flags));
 		if (is_legacy(tbl->lq_type)) {
 			desc += sprintf(buff+desc, " rate[%d] 0x%X %smbps\n",
 			i,
 			le32_to_cpu(lq_sta->lq.rs_table[i].rate_n_flags),
-			il_rate_mcs[index].mbps);
+			il_rate_mcs[idx].mbps);
 		} else {
 			desc += sprintf(buff+desc,
 			" rate[%d] 0x%X %smbps (%s)\n",
 			i,
 			le32_to_cpu(lq_sta->lq.rs_table[i].rate_n_flags),
-			il_rate_mcs[index].mbps, il_rate_mcs[index].mcs);
+			il_rate_mcs[idx].mbps, il_rate_mcs[idx].mcs);
 		}
 	}
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-sta.c b/drivers/net/wireless/iwlegacy/iwl-4965-sta.c
index c50d639..4cda277 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-sta.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-sta.c
@@ -157,7 +157,7 @@ static int il4965_static_wepkey_cmd(struct il_priv *il,
 			(sizeof(struct il_wep_key) * WEP_KEYS_MAX));
 
 	for (i = 0; i < WEP_KEYS_MAX ; i++) {
-		wep_cmd->key[i].key_index = i;
+		wep_cmd->key[i].key_idx = i;
 		if (ctx->wep_keys[i].key_size) {
 			wep_cmd->key[i].key_offset = i;
 			not_empty = 1;
@@ -283,7 +283,7 @@ static int il4965_set_wep_dynamic_key_info(struct il_priv *il,
 	if ((il->stations[sta_id].sta.key.key_flags & STA_KEY_FLG_ENCRYPT_MSK)
 			== STA_KEY_FLG_NO_ENC)
 		il->stations[sta_id].sta.key.key_offset =
-				 il_get_free_ucode_key_index(il);
+				 il_get_free_ucode_key_idx(il);
 	/* else, we are overriding an existing key => no need to allocated room
 	 * in uCode. */
 
@@ -334,7 +334,7 @@ static int il4965_set_ccmp_dynamic_key_info(struct il_priv *il,
 	if ((il->stations[sta_id].sta.key.key_flags & STA_KEY_FLG_ENCRYPT_MSK)
 			== STA_KEY_FLG_NO_ENC)
 		il->stations[sta_id].sta.key.key_offset =
-				 il_get_free_ucode_key_index(il);
+				 il_get_free_ucode_key_idx(il);
 	/* else, we are overriding an existing key => no need to allocated room
 	 * in uCode. */
 
@@ -379,7 +379,7 @@ static int il4965_set_tkip_dynamic_key_info(struct il_priv *il,
 	if ((il->stations[sta_id].sta.key.key_flags & STA_KEY_FLG_ENCRYPT_MSK)
 			== STA_KEY_FLG_NO_ENC)
 		il->stations[sta_id].sta.key.key_offset =
-				 il_get_free_ucode_key_index(il);
+				 il_get_free_ucode_key_idx(il);
 	/* else, we are overriding an existing key => no need to allocated room
 	 * in uCode. */
 
@@ -457,9 +457,9 @@ int il4965_remove_dynamic_key(struct il_priv *il,
 		      keyconf->keyidx, sta_id);
 
 	if (keyconf->keyidx != keyidx) {
-		/* We need to remove a key with index different that the one
+		/* We need to remove a key with idx different that the one
 		 * in the uCode. This means that the key we need to remove has
-		 * been replaced by another one with different index.
+		 * been replaced by another one with different idx.
 		 * Don't do anything and return ok
 		 */
 		spin_unlock_irqrestore(&il->sta_lock, flags);
@@ -475,7 +475,7 @@ int il4965_remove_dynamic_key(struct il_priv *il,
 
 	if (!test_and_clear_bit(il->stations[sta_id].sta.key.key_offset,
 		&il->ucode_key_table))
-		IL_ERR("index %d not used in uCode key table.\n",
+		IL_ERR("idx %d not used in uCode key table.\n",
 			il->stations[sta_id].sta.key.key_offset);
 	memset(&il->stations[sta_id].keyinfo, 0,
 					sizeof(struct il_hw_key));
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
index 8f18d36..a6fa1c2 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
@@ -183,7 +183,7 @@ static void il4965_tx_cmd_build_rate(struct il_priv *il,
 	/* DATA packets will use the uCode station table for rate/antenna
 	 * selection */
 	if (ieee80211_is_data(fc)) {
-		tx_cmd->initial_rate_index = 0;
+		tx_cmd->initial_rate_idx = 0;
 		tx_cmd->tx_flags |= TX_CMD_FLG_STA_RATE_MSK;
 		return;
 	}
@@ -192,7 +192,7 @@ static void il4965_tx_cmd_build_rate(struct il_priv *il,
 	 * If the current TX rate stored in mac80211 has the MCS bit set, it's
 	 * not really a TX rate.  Thus, we use the lowest supported rate for
 	 * this band.  Also use the lowest supported rate if the stored rate
-	 * index is invalid.
+	 * idx is invalid.
 	 */
 	rate_idx = info->control.rates[0].idx;
 	if ((info->control.rates[0].flags & IEEE80211_TX_RC_MCS) ||
@@ -319,7 +319,7 @@ int il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
 	if (!ieee80211_is_data(fc))
 		sta_id = ctx->bcast_sta_id;
 	else {
-		/* Find index into station table for destination station */
+		/* Find idx into station table for destination station */
 		sta_id = il_sta_id_or_broadcast(il, ctx, info->control.sta);
 
 		if (sta_id == IL_INVALID_STATION) {
@@ -417,7 +417,7 @@ int il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
 
 	/*
 	 * Set up the Tx-command (not MAC!) header.
-	 * Store the chosen Tx queue and TFD index within the sequence field;
+	 * Store the chosen Tx queue and TFD idx within the sequence field;
 	 * after Tx, uCode's Tx response will return this value so driver can
 	 * locate the frame within the tx queue and do post-tx processing.
 	 */
@@ -513,7 +513,7 @@ int il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
 	pci_dma_sync_single_for_device(il->pci_dev, txcmd_phys,
 				       firstlen, PCI_DMA_BIDIRECTIONAL);
 
-	/* Tell device the write index *just past* this latest filled TFD */
+	/* Tell device the write idx *just past* this latest filled TFD */
 	q->write_ptr = il_queue_inc_wrap(q->write_ptr, q->n_bd);
 	il_txq_update_write_ptr(il, txq);
 	spin_unlock_irqrestore(&il->lock, flags);
@@ -828,7 +828,7 @@ static int il4965_txq_agg_enable(struct il_priv *il, int txq_id,
 	/* Set this queue as a chain-building queue */
 	il_set_bits_prph(il, IL49_SCD_QUEUECHAIN_SEL, (1 << txq_id));
 
-	/* Place first TFD at index corresponding to start sequence number.
+	/* Place first TFD at idx corresponding to start sequence number.
 	 * Assumes that ssn_idx is valid (!= 0xFFF) */
 	il->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
 	il->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
@@ -1105,7 +1105,7 @@ il4965_tx_status(struct il_priv *il, struct il_tx_info *tx_info,
 	ieee80211_tx_status_irqsafe(il->hw, tx_info->skb);
 }
 
-int il4965_tx_queue_reclaim(struct il_priv *il, int txq_id, int index)
+int il4965_tx_queue_reclaim(struct il_priv *il, int txq_id, int idx)
 {
 	struct il_tx_queue *txq = &il->txq[txq_id];
 	struct il_queue *q = &txq->q;
@@ -1113,15 +1113,15 @@ int il4965_tx_queue_reclaim(struct il_priv *il, int txq_id, int index)
 	int nfreed = 0;
 	struct ieee80211_hdr *hdr;
 
-	if (index >= q->n_bd || il_queue_used(q, index) == 0) {
-		IL_ERR("Read index for DMA queue txq id (%d), index %d, "
+	if (idx >= q->n_bd || il_queue_used(q, idx) == 0) {
+		IL_ERR("Read idx for DMA queue txq id (%d), idx %d, "
 			  "is out of range [0-%d] %d %d.\n", txq_id,
-			  index, q->n_bd, q->write_ptr, q->read_ptr);
+			  idx, q->n_bd, q->write_ptr, q->read_ptr);
 		return 0;
 	}
 
-	for (index = il_queue_inc_wrap(index, q->n_bd);
-	     q->read_ptr != index;
+	for (idx = il_queue_inc_wrap(idx, q->n_bd);
+	     q->read_ptr != idx;
 	     q->read_ptr = il_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 
 		tx_info = &txq->txb[txq->q.read_ptr];
@@ -1252,7 +1252,7 @@ void il4965_rx_reply_compressed_ba(struct il_priv *il,
 	struct il_compressed_ba_resp *ba_resp = &pkt->u.compressed_ba;
 	struct il_tx_queue *txq = NULL;
 	struct il_ht_agg *agg;
-	int index;
+	int idx;
 	int sta_id;
 	int tid;
 	unsigned long flags;
@@ -1260,7 +1260,7 @@ void il4965_rx_reply_compressed_ba(struct il_priv *il,
 	/* "flow" corresponds to Tx queue */
 	u16 scd_flow = le16_to_cpu(ba_resp->scd_flow);
 
-	/* "ssn" is start of block-ack Tx win, corresponds to index
+	/* "ssn" is start of block-ack Tx win, corresponds to idx
 	 * (in Tx queue's circular buffer) of first TFD/frame in win */
 	u16 ba_resp_scd_ssn = le16_to_cpu(ba_resp->scd_ssn);
 
@@ -1287,8 +1287,8 @@ void il4965_rx_reply_compressed_ba(struct il_priv *il,
 		return;
 	}
 
-	/* Find index just before block-ack win */
-	index = il_queue_dec_wrap(ba_resp_scd_ssn & 0xff, txq->q.n_bd);
+	/* Find idx just before block-ack win */
+	idx = il_queue_dec_wrap(ba_resp_scd_ssn & 0xff, txq->q.n_bd);
 
 	spin_lock_irqsave(&il->sta_lock, flags);
 
@@ -1317,7 +1317,7 @@ void il4965_rx_reply_compressed_ba(struct il_priv *il,
 	 * transmitted ... if not, it's too late anyway). */
 	if (txq->q.read_ptr != (ba_resp_scd_ssn & 0xff)) {
 		/* calculate mac80211 ampdu sw queue to wake */
-		int freed = il4965_tx_queue_reclaim(il, scd_flow, index);
+		int freed = il4965_tx_queue_reclaim(il, scd_flow, idx);
 		il4965_free_tfds_in_queue(il, sta_id, tid, freed);
 
 		if (il_queue_space(&txq->q) > txq->q.low_mark &&
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965.c b/drivers/net/wireless/iwlegacy/iwl-4965.c
index 58bdf93..8fd383e 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.c
@@ -446,12 +446,12 @@ static s32 il4965_math_div_round(s32 num, s32 denom, s32 *res)
  * il4965_get_voltage_compensation - Power supply voltage comp for txpower
  *
  * Determines power supply voltage compensation for txpower calculations.
- * Returns number of 1/2-dB steps to subtract from gain table index,
+ * Returns number of 1/2-dB steps to subtract from gain table idx,
  * to compensate for difference between power supply voltage during
  * factory measurements, vs. current power supply voltage.
  *
  * Voltage indication is higher for lower voltage.
- * Lower voltage requires more gain (lower gain table index).
+ * Lower voltage requires more gain (lower gain table idx).
  */
 static s32 il4965_get_voltage_compensation(s32 eeprom_voltage,
 					    s32 current_voltage)
@@ -628,10 +628,10 @@ static struct il4965_txpower_comp_entry {
 	{3, 1}			/* group 4 2.4, ch   all */
 };
 
-static s32 get_min_power_index(s32 rate_power_index, u32 band)
+static s32 get_min_power_idx(s32 rate_power_idx, u32 band)
 {
 	if (!band) {
-		if ((rate_power_index & 7) <= 4)
+		if ((rate_power_idx & 7) <= 4)
 			return MIN_TX_GAIN_IDX_52GHZ_EXT;
 	}
 	return MIN_TX_GAIN_IDX;
@@ -643,7 +643,7 @@ struct gain_entry {
 };
 
 static const struct gain_entry gain_table[2][108] = {
-	/* 5.2GHz power gain index table */
+	/* 5.2GHz power gain idx table */
 	{
 	 {123, 0x3F},		/* highest txpower */
 	 {117, 0x3F},
@@ -754,7 +754,7 @@ static const struct gain_entry gain_table[2][108] = {
 	 {83, 0x00},
 	 {78, 0x00},
 	 },
-	/* 2.4GHz power gain index table */
+	/* 2.4GHz power gain idx table */
 	{
 	 {110, 0x3f},		/* highest txpower */
 	 {104, 0x3f},
@@ -891,12 +891,12 @@ static int il4965_fill_txpower_tbl(struct il_priv *il, u8 band, u16 channel,
 	s32 degrees_per_05db_denom;
 	s32 factory_temp;
 	s32 temperature_comp[2];
-	s32 factory_gain_index[2];
+	s32 factory_gain_idx[2];
 	s32 factory_actual_pwr[2];
-	s32 power_index;
+	s32 power_idx;
 
 	/* tx_power_user_lmt is in dBm, convert to half-dBm (half-dB units
-	 *   are used for indexing into txpower table) */
+	 *   are used for idxing into txpower table) */
 	user_target_power = 2 * il->tx_power_user_lmt;
 
 	/* Get current (RXON) channel, band, width */
@@ -995,7 +995,7 @@ static int il4965_fill_txpower_tbl(struct il_priv *il, u8 band, u16 channel,
 				       degrees_per_05db_num,
 				       &temperature_comp[c]);
 
-		factory_gain_index[c] = measurement->gain_idx;
+		factory_gain_idx[c] = measurement->gain_idx;
 		factory_actual_pwr[c] = measurement->actual_pow;
 
 		D_TXPOWER("chain = %d\n", c);
@@ -1005,7 +1005,7 @@ static int il4965_fill_txpower_tbl(struct il_priv *il, u8 band, u16 channel,
 				  temperature_comp[c]);
 
 		D_TXPOWER("fctry idx %d, fctry pwr %d\n",
-				  factory_gain_index[c],
+				  factory_gain_idx[c],
 				  factory_actual_pwr[c]);
 	}
 
@@ -1053,50 +1053,50 @@ static int il4965_fill_txpower_tbl(struct il_priv *il, u8 band, u16 channel,
 			else
 				atten_value = 0;
 
-			/* calculate index; higher index means lower txpower */
-			power_index = (u8) (factory_gain_index[c] -
+			/* calculate idx; higher idx means lower txpower */
+			power_idx = (u8) (factory_gain_idx[c] -
 					    (target_power -
 					     factory_actual_pwr[c]) -
 					    temperature_comp[c] -
 					    voltage_compensation +
 					    atten_value);
 
-/*			D_TXPOWER("calculated txpower index %d\n",
-						power_index); */
+/*			D_TXPOWER("calculated txpower idx %d\n",
+						power_idx); */
 
-			if (power_index < get_min_power_index(i, band))
-				power_index = get_min_power_index(i, band);
+			if (power_idx < get_min_power_idx(i, band))
+				power_idx = get_min_power_idx(i, band);
 
-			/* adjust 5 GHz index to support negative indexes */
+			/* adjust 5 GHz idx to support negative idxes */
 			if (!band)
-				power_index += 9;
+				power_idx += 9;
 
 			/* CCK, rate 32, reduce txpower for CCK */
 			if (i == POWER_TABLE_CCK_ENTRY)
-				power_index +=
+				power_idx +=
 				    IL_TX_POWER_CCK_COMPENSATION_C_STEP;
 
 			/* stay within the table! */
-			if (power_index > 107) {
-				IL_WARN("txpower index %d > 107\n",
-					    power_index);
-				power_index = 107;
+			if (power_idx > 107) {
+				IL_WARN("txpower idx %d > 107\n",
+					    power_idx);
+				power_idx = 107;
 			}
-			if (power_index < 0) {
-				IL_WARN("txpower index %d < 0\n",
-					    power_index);
-				power_index = 0;
+			if (power_idx < 0) {
+				IL_WARN("txpower idx %d < 0\n",
+					    power_idx);
+				power_idx = 0;
 			}
 
 			/* fill txpower command for this rate/chain */
 			tx_power.s.radio_tx_gain[c] =
-				gain_table[band][power_index].radio;
+				gain_table[band][power_idx].radio;
 			tx_power.s.dsp_predis_atten[c] =
-				gain_table[band][power_index].dsp;
+				gain_table[band][power_idx].dsp;
 
-			D_TXPOWER("chain %d mimo %d index %d "
+			D_TXPOWER("chain %d mimo %d idx %d "
 					  "gain 0x%02x dsp %d\n",
-					  c, atten_value, power_index,
+					  c, atten_value, power_idx,
 					tx_power.s.radio_tx_gain[c],
 					tx_power.s.dsp_predis_atten[c]);
 		} /* for each chain */
@@ -1777,7 +1777,7 @@ static void il4965_rx_reply_tx(struct il_priv *il,
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	int txq_id = SEQ_TO_QUEUE(sequence);
-	int index = SEQ_TO_IDX(sequence);
+	int idx = SEQ_TO_IDX(sequence);
 	struct il_tx_queue *txq = &il->txq[txq_id];
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_tx_info *info;
@@ -1789,10 +1789,10 @@ static void il4965_rx_reply_tx(struct il_priv *il,
 	u8 *qc = NULL;
 	unsigned long flags;
 
-	if (index >= txq->q.n_bd || il_queue_used(&txq->q, index) == 0) {
-		IL_ERR("Read index for DMA queue txq_id (%d) index %d "
+	if (idx >= txq->q.n_bd || il_queue_used(&txq->q, idx) == 0) {
+		IL_ERR("Read idx for DMA queue txq_id (%d) idx %d "
 			  "is out of range [0-%d] %d %d\n", txq_id,
-			  index, txq->q.n_bd, txq->q.write_ptr,
+			  idx, txq->q.n_bd, txq->q.write_ptr,
 			  txq->q.read_ptr);
 		return;
 	}
@@ -1801,7 +1801,7 @@ static void il4965_rx_reply_tx(struct il_priv *il,
 	info = IEEE80211_SKB_CB(txq->txb[txq->q.read_ptr].skb);
 	memset(&info->status, 0, sizeof(info->status));
 
-	hdr = il_tx_queue_get_hdr(il, txq_id, index);
+	hdr = il_tx_queue_get_hdr(il, txq_id, idx);
 	if (ieee80211_is_data_qos(hdr->frame_control)) {
 		qc = ieee80211_get_qos_ctl(hdr);
 		tid = qc[0] & 0xf;
@@ -1821,18 +1821,18 @@ static void il4965_rx_reply_tx(struct il_priv *il,
 
 		agg = &il->stations[sta_id].tid[tid].agg;
 
-		il4965_tx_status_reply_tx(il, agg, tx_resp, txq_id, index);
+		il4965_tx_status_reply_tx(il, agg, tx_resp, txq_id, idx);
 
 		/* check if BAR is needed */
 		if ((tx_resp->frame_count == 1) && !il4965_is_tx_success(status))
 			info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
 
 		if (txq->q.read_ptr != (scd_ssn & 0xff)) {
-			index = il_queue_dec_wrap(scd_ssn & 0xff,
+			idx = il_queue_dec_wrap(scd_ssn & 0xff,
 								txq->q.n_bd);
 			D_TX_REPLY("Retry scheduler reclaim scd_ssn "
-					   "%d index %d\n", scd_ssn , index);
-			freed = il4965_tx_queue_reclaim(il, txq_id, index);
+					   "%d idx %d\n", scd_ssn , idx);
+			freed = il4965_tx_queue_reclaim(il, txq_id, idx);
 			if (qc)
 				il4965_free_tfds_in_queue(il, sta_id,
 						       tid, freed);
@@ -1856,7 +1856,7 @@ static void il4965_rx_reply_tx(struct il_priv *il,
 				   le32_to_cpu(tx_resp->rate_n_flags),
 				   tx_resp->failure_frame);
 
-		freed = il4965_tx_queue_reclaim(il, txq_id, index);
+		freed = il4965_tx_queue_reclaim(il, txq_id, idx);
 		if (qc && likely(sta_id != IL_INVALID_STATION))
 			il4965_free_tfds_in_queue(il, sta_id, tid, freed);
 		else if (sta_id == IL_INVALID_STATION)
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965.h b/drivers/net/wireless/iwlegacy/iwl-4965.h
index a75b62c..8076bbe 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965.h
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.h
@@ -123,7 +123,7 @@ int il4965_txq_check_empty(struct il_priv *il,
 			   int sta_id, u8 tid, int txq_id);
 void il4965_rx_reply_compressed_ba(struct il_priv *il,
 				struct il_rx_buf *rxb);
-int il4965_tx_queue_reclaim(struct il_priv *il, int txq_id, int index);
+int il4965_tx_queue_reclaim(struct il_priv *il, int txq_id, int idx);
 void il4965_hw_txq_ctx_free(struct il_priv *il);
 int il4965_txq_ctx_alloc(struct il_priv *il);
 void il4965_txq_ctx_reset(struct il_priv *il);
@@ -133,7 +133,7 @@ void il4965_txq_set_sched(struct il_priv *il, u32 mask);
 /*
  * Acquire il->lock before calling this function !
  */
-void il4965_set_wr_ptrs(struct il_priv *il, int txq_id, u32 index);
+void il4965_set_wr_ptrs(struct il_priv *il, int txq_id, u32 idx);
 /**
  * il4965_tx_queue_set_status - (optionally) start Tx/Cmd queue
  * @tx_fifo_id: Tx DMA/FIFO channel (range 0-7) that the queue will feed
diff --git a/drivers/net/wireless/iwlegacy/iwl-commands.h b/drivers/net/wireless/iwlegacy/iwl-commands.h
index 002f1d7..4083912 100644
--- a/drivers/net/wireless/iwlegacy/iwl-commands.h
+++ b/drivers/net/wireless/iwlegacy/iwl-commands.h
@@ -197,7 +197,7 @@ struct il_cmd_header {
 	 *
 	 * The Linux driver uses the following format:
 	 *
-	 *  0:7		tfd index - position within TX queue
+	 *  0:7		tfd idx - position within TX queue
 	 *  8:12	TX queue id
 	 *  13		reserved
 	 *  14		huge - driver sets this to indicate command is in the
@@ -454,7 +454,7 @@ struct il_init_alive_resp {
  *	__le32 log_size;     log capacity (in number of entries)
  *	__le32 type;         (1) timestamp with each entry, (0) no timestamp
  *	__le32 wraps;        # times uCode has wrapped to top of circular buffer
- *      __le32 write_index;  next circular buffer entry that uCode would fill
+ *      __le32 write_idx;  next circular buffer entry that uCode would fill
  *
  *     The header is followed by the circular buffer of log entries.  Entries
  *     with timestamps have the following format:
@@ -901,7 +901,7 @@ struct il_qosparam_cmd {
 #define STA_MODIFY_DELBA_TID_MSK	0x10
 #define STA_MODIFY_SLEEP_TX_COUNT_MSK	0x20
 
-/* Receiver address (actually, Rx station's index into station table),
+/* Receiver address (actually, Rx station's idx into station table),
  * combined with Traffic ID (QOS priority), in format used by Tx Scheduler */
 #define BUILD_RAxTID(sta_id, tid)	(((sta_id) << 4) + (tid))
 
@@ -918,12 +918,12 @@ struct il4965_keyinfo {
 /**
  * struct sta_id_modify
  * @addr[ETH_ALEN]: station's MAC address
- * @sta_id: index of station in uCode's station table
+ * @sta_id: idx of station in uCode's station table
  * @modify_mask: STA_MODIFY_*, 1: modify, 0: don't change
  *
- * Driver selects unused table index when adding new station,
- * or the index to a pre-existing station entry when modifying that station.
- * Some indexes have special purposes (IL_AP_ID, index 0, is for AP).
+ * Driver selects unused table idx when adding new station,
+ * or the idx to a pre-existing station entry when modifying that station.
+ * Some idxes have special purposes (IL_AP_ID, idx 0, is for AP).
  *
  * modify_mask flags select which parameters to modify vs. leave alone.
  */
@@ -959,7 +959,7 @@ struct sta_id_modify {
  *        in the IL_AP_ID entry (1st entry in the table).  BROADCAST and AP
  *        are all that are needed for a BSS client station.  If the device is
  *        used as AP, or in an IBSS network, driver must set up station table
- *        entries for all STAs in network, starting with index IL_STA_ID.
+ *        entries for all STAs in network, starting with idx IL_STA_ID.
  */
 
 struct il3945_addsta_cmd {
@@ -1109,7 +1109,7 @@ struct il_rem_sta_cmd {
  * REPLY_WEP_KEY = 0x20
  */
 struct il_wep_key {
-	u8 key_index;
+	u8 key_idx;
 	u8 key_offset;
 	u8 reserved1[2];
 	u8 key_size;
@@ -1297,7 +1297,7 @@ struct il_rx_mpdu_res_start {
 
 /* For 4965 devices:
  * 1: Use rate scale table (see REPLY_TX_LINK_QUALITY_CMD).
- *    Tx command's initial_rate_index indicates first rate to try;
+ *    Tx command's initial_rate_idx indicates first rate to try;
  *    uCode walks through table for additional Tx attempts.
  * 0: Use Tx rate/MCS from Tx command's rate_n_flags field.
  *    This rate will be used for all Tx attempts; it will not be scaled. */
@@ -1499,7 +1499,7 @@ struct il_tx_cmd {
 	 * rate (via non-0 value) for special frames (e.g. management), while
 	 * still supporting rate scaling for all frames.
 	 */
-	u8 initial_rate_index;
+	u8 initial_rate_idx;
 	u8 reserved;
 	u8 key[16];
 	__le16 next_frame_flags;
@@ -1792,7 +1792,7 @@ struct il4965_txpowertable_cmd {
 struct il3945_rate_scaling_info {
 	__le16 rate_n_flags;
 	u8 try_cnt;
-	u8 next_rate_index;
+	u8 next_rate_idx;
 } __packed;
 
 struct il3945_rate_scaling_cmd {
@@ -1825,7 +1825,7 @@ struct il3945_rate_scaling_cmd {
 struct il_link_qual_general_params {
 	u8 flags;
 
-	/* No entries at or above this (driver chosen) index contain MIMO */
+	/* No entries at or above this (driver chosen) idx contain MIMO */
 	u8 mimo_delimiter;
 
 	/* Best single antenna to use for single stream (legacy, SISO). */
@@ -1837,7 +1837,7 @@ struct il_link_qual_general_params {
 	/*
 	 * If driver needs to use different initial rates for different
 	 * EDCA QOS access categories (as implemented by tx fifos 0-3),
-	 * this table will set that up, by indicating the indexes in the
+	 * this table will set that up, by indicating the idxes in the
 	 * rs_table[LINK_QUAL_MAX_RETRY_NUM] rate table at which to start.
 	 * Otherwise, driver should set all entries to 0.
 	 *
@@ -1845,7 +1845,7 @@ struct il_link_qual_general_params {
 	 * 0 = Background, 1 = Best Effort (normal), 2 = Video, 3 = Voice
 	 * TX FIFOs above 3 use same value (typically 0) as TX FIFO 3.
 	 */
-	u8 start_rate_index[LINK_QUAL_AC_NUM];
+	u8 start_rate_idx[LINK_QUAL_AC_NUM];
 } __packed;
 
 #define LINK_QUAL_AGG_TIME_LIMIT_DEF	(4000) /* 4 milliseconds */
@@ -2089,8 +2089,8 @@ struct il_link_quality_cmd {
 	struct il_link_qual_agg_params agg_params;
 
 	/*
-	 * Rate info; when using rate-scaling, Tx command's initial_rate_index
-	 * specifies 1st Tx rate attempted, via index into this table.
+	 * Rate info; when using rate-scaling, Tx command's initial_rate_idx
+	 * specifies 1st Tx rate attempted, via idx into this table.
 	 * 4965 devices works its way through table when retrying Tx.
 	 */
 	struct {
@@ -2233,7 +2233,7 @@ enum il_measure_type {
 struct il_spectrum_notification {
 	u8 id;			/* measurement id -- 0 or 1 */
 	u8 token;
-	u8 channel_index;	/* index in measurement channel list */
+	u8 channel_idx;	/* idx in measurement channel list */
 	u8 state;		/* 0 - start, 1 - stop */
 	__le32 start_time;	/* lower 32-bits of TSF */
 	u8 band;		/* 0 - 5.2GHz, 1 - 2.4GHz */
@@ -3220,7 +3220,7 @@ struct il_missed_beacon_notif {
  * Table entries in SENSITIVITY_CMD (struct il_sensitivity_cmd)
  */
 #define HD_TABLE_SIZE  (11)	/* number of entries */
-#define HD_MIN_ENERGY_CCK_DET_IDX                 (0)	/* table indexes */
+#define HD_MIN_ENERGY_CCK_DET_IDX                 (0)	/* table idxes */
 #define HD_MIN_ENERGY_OFDM_DET_IDX                (1)
 #define HD_AUTO_CORR32_X1_TH_ADD_MIN_IDX          (2)
 #define HD_AUTO_CORR32_X1_TH_ADD_MIN_MRC_IDX      (3)
@@ -3239,13 +3239,13 @@ struct il_missed_beacon_notif {
 /**
  * struct il_sensitivity_cmd
  * @control:  (1) updates working table, (0) updates default table
- * @table:  energy threshold values, use HD_* as index into table
+ * @table:  energy threshold values, use HD_* as idx into table
  *
  * Always use "1" in "control" to update uCode's working table and DSP.
  */
 struct il_sensitivity_cmd {
 	__le16 control;			/* always use "1" */
-	__le16 table[HD_TABLE_SIZE];	/* use HD_* as index */
+	__le16 table[HD_TABLE_SIZE];	/* use HD_* as idx */
 } __packed;
 
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-csr.h b/drivers/net/wireless/iwlegacy/iwl-csr.h
index c00ec35..34edec3 100644
--- a/drivers/net/wireless/iwlegacy/iwl-csr.h
+++ b/drivers/net/wireless/iwlegacy/iwl-csr.h
@@ -411,10 +411,10 @@
 #define HBUS_TARG_PRPH_RDAT     (HBUS_BASE+0x050)
 
 /*
- * Per-Tx-queue write pointer (index, really!)
- * Indicates index to next TFD that driver will fill (1 past latest filled).
+ * Per-Tx-queue write pointer (idx, really!)
+ * Indicates idx to next TFD that driver will fill (1 past latest filled).
  * Bit usage:
- *  0-7:  queue write index
+ *  0-7:  queue write idx
  * 11-8:  queue selector
  */
 #define HBUS_TARG_WRPTR         (HBUS_BASE+0x060)
diff --git a/drivers/net/wireless/iwlegacy/iwl-dev.h b/drivers/net/wireless/iwlegacy/iwl-dev.h
index 18dd253..2555f9f 100644
--- a/drivers/net/wireless/iwlegacy/iwl-dev.h
+++ b/drivers/net/wireless/iwlegacy/iwl-dev.h
@@ -125,8 +125,8 @@ struct il_cmd_meta {
  */
 struct il_queue {
 	int n_bd;              /* number of BDs in this queue */
-	int write_ptr;       /* 1-st empty entry (index) host_w*/
-	int read_ptr;         /* last used entry (index) host_r*/
+	int write_ptr;       /* 1-st empty entry (idx) host_w*/
+	int read_ptr;         /* last used entry (idx) host_r*/
 	/* use for monitoring and recovering the stuck queue */
 	dma_addr_t dma_addr;   /* physical addr for BD's */
 	int n_win;	       /* safe queue win */
@@ -152,7 +152,7 @@ struct il_tx_info {
  * @dma_addr_cmd: physical address of cmd/tx buffer array
  * @txb: array of per-TFD driver data
  * @time_stamp: time (in jiffies) of last read_ptr change
- * @need_update: indicates need to update read/write index
+ * @need_update: indicates need to update read/write idx
  * @sched_retry: indicates queue is high-throughput aggregation (HT AGG) enabled
  *
  * A Tx queue consists of circular buffer of BDs (a.k.a. TFDs, transmit frame
@@ -199,11 +199,11 @@ struct il3945_clip_group {
  * -- hardware capabilities (clip-powers)
  * -- spectrum management
  * -- user preference (e.g. iwconfig)
- * when requested power is set, base power index must also be set. */
+ * when requested power is set, base power idx must also be set. */
 struct il3945_channel_power_info {
 	struct il3945_tx_power tpc;	/* actual radio and DSP gain settings */
-	s8 power_table_index;	/* actual (compenst'd) index into gain table */
-	s8 base_power_index;	/* gain index for power at factory temp. */
+	s8 power_table_idx;	/* actual (compenst'd) idx into gain table */
+	s8 base_power_idx;	/* gain idx for power at factory temp. */
 	s8 requested_power;	/* power (dBm) requested for this chnl/rate */
 };
 
@@ -211,7 +211,7 @@ struct il3945_channel_power_info {
  * channel. */
 struct il3945_scan_power_info {
 	struct il3945_tx_power tpc;	/* actual radio and DSP gain settings */
-	s8 power_table_index;	/* actual (compenst'd) index into gain table */
+	s8 power_table_idx;	/* actual (compenst'd) idx into gain table */
 	s8 requested_power;	/* scan pwr (dBm) requested for chnl/rate */
 };
 
@@ -234,8 +234,8 @@ struct il_channel_info {
 	s8 min_power;	  /* always 0 */
 	s8 scan_power;	  /* (dBm) regul. eeprom, direct scans, any rate */
 
-	u8 group_index;	  /* 0-4, maps channel to group1/2/3/4/5 */
-	u8 band_index;	  /* 0-4, maps channel to band1/2/3/4/5 */
+	u8 group_idx;	  /* 0-4, maps channel to group1/2/3/4/5 */
+	u8 band_idx;	  /* 0-4, maps channel to band1/2/3/4/5 */
 	enum ieee80211_band band;
 
 	/* HT40 channel info */
@@ -245,7 +245,7 @@ struct il_channel_info {
 
 	/* Radio/DSP gain settings for each "normal" data Tx rate.
 	 * These include, in addition to RF and DSP gain, a few fields for
-	 *   remembering/modifying gain settings (indexes). */
+	 *   remembering/modifying gain settings (idxes). */
 	struct il3945_channel_power_info power_info[IL4965_MAX_RATE];
 
 	/* Radio/DSP gain settings for each scan rate, for directed scans. */
@@ -337,12 +337,12 @@ struct il_host_cmd {
  * struct il_rx_queue - Rx queue
  * @bd: driver's pointer to buffer of receive buffer descriptors (rbd)
  * @bd_dma: bus address of buffer of receive buffer descriptors (rbd)
- * @read: Shared index to newest available Rx buffer
- * @write: Shared index to oldest written Rx packet
+ * @read: Shared idx to newest available Rx buffer
+ * @write: Shared idx to oldest written Rx packet
  * @free_count: Number of pre-allocated buffers in rx_free
  * @rx_free: list of free SKBs for use
  * @rx_used: List of Rx buffers with no SKB
- * @need_update: flag to indicate we need to update read/write index
+ * @need_update: flag to indicate we need to update read/write idx
  * @rb_stts: driver's pointer to receive buffer status
  * @rb_stts_dma: bus address of receive buffer status
  *
@@ -636,7 +636,7 @@ static inline int il_queue_used(const struct il_queue *q, int i)
 }
 
 
-static inline u8 il_get_cmd_index(struct il_queue *q, u32 index,
+static inline u8 il_get_cmd_idx(struct il_queue *q, u32 idx,
 								int is_huge)
 {
 	/*
@@ -648,7 +648,7 @@ static inline u8 il_get_cmd_index(struct il_queue *q, u32 index,
 		return q->n_win;	/* must be power of 2 */
 
 	/* Otherwise, use normal size buffers */
-	return index & (q->n_win - 1);
+	return idx & (q->n_win - 1);
 }
 
 
@@ -987,7 +987,7 @@ struct il_priv {
 	struct il_force_reset force_reset;
 
 	/* we allocate array of il_channel_info for NIC's valid channels.
-	 *    Access via channel # using indirect index array */
+	 *    Access via channel # using indirect idx array */
 	struct il_channel_info *channel_info;	/* channel info array */
 	u8 channel_count;	/* # of channels */
 
@@ -1033,7 +1033,7 @@ struct il_priv {
 	struct mac_address addresses[1];
 
 	/* uCode images, save to reload in case of failure */
-	int fw_index;			/* firmware we're trying to load */
+	int fw_idx;			/* firmware we're trying to load */
 	u32 ucode_ver;			/* version of ucode, copy of
 					   il_ucode.ver */
 	struct fw_desc ucode_code;	/* runtime inst */
diff --git a/drivers/net/wireless/iwlegacy/iwl-eeprom.c b/drivers/net/wireless/iwlegacy/iwl-eeprom.c
index 5786abd..ee5ad69 100644
--- a/drivers/net/wireless/iwlegacy/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlegacy/iwl-eeprom.c
@@ -89,7 +89,7 @@
  * During init, we copy the eeprom information and channel map
  * information into il->channel_info_24/52 and il->channel_map_24/52
  *
- * channel_map_24/52 provides the index in the channel_info array for a
+ * channel_map_24/52 provides the idx in the channel_info array for a
  * given channel.  We have to have two separate maps as there is channel
  * overlap with the 2.4GHz and 5.2GHz spectrum as seen in band_1 and
  * band_2
@@ -267,7 +267,7 @@ EXPORT_SYMBOL(il_eeprom_free);
 static void il_init_band_reference(const struct il_priv *il,
 			int eep_band, int *eeprom_ch_count,
 			const struct il_eeprom_channel **eeprom_ch_info,
-			const u8 **eeprom_ch_index)
+			const u8 **eeprom_ch_idx)
 {
 	u32 offset = il->cfg->ops->lib->
 			eeprom_ops.regulatory_bands[eep_band - 1];
@@ -276,43 +276,43 @@ static void il_init_band_reference(const struct il_priv *il,
 		*eeprom_ch_count = ARRAY_SIZE(il_eeprom_band_1);
 		*eeprom_ch_info = (struct il_eeprom_channel *)
 				il_eeprom_query_addr(il, offset);
-		*eeprom_ch_index = il_eeprom_band_1;
+		*eeprom_ch_idx = il_eeprom_band_1;
 		break;
 	case 2:		/* 4.9GHz band */
 		*eeprom_ch_count = ARRAY_SIZE(il_eeprom_band_2);
 		*eeprom_ch_info = (struct il_eeprom_channel *)
 				il_eeprom_query_addr(il, offset);
-		*eeprom_ch_index = il_eeprom_band_2;
+		*eeprom_ch_idx = il_eeprom_band_2;
 		break;
 	case 3:		/* 5.2GHz band */
 		*eeprom_ch_count = ARRAY_SIZE(il_eeprom_band_3);
 		*eeprom_ch_info = (struct il_eeprom_channel *)
 				il_eeprom_query_addr(il, offset);
-		*eeprom_ch_index = il_eeprom_band_3;
+		*eeprom_ch_idx = il_eeprom_band_3;
 		break;
 	case 4:		/* 5.5GHz band */
 		*eeprom_ch_count = ARRAY_SIZE(il_eeprom_band_4);
 		*eeprom_ch_info = (struct il_eeprom_channel *)
 				il_eeprom_query_addr(il, offset);
-		*eeprom_ch_index = il_eeprom_band_4;
+		*eeprom_ch_idx = il_eeprom_band_4;
 		break;
 	case 5:		/* 5.7GHz band */
 		*eeprom_ch_count = ARRAY_SIZE(il_eeprom_band_5);
 		*eeprom_ch_info = (struct il_eeprom_channel *)
 				il_eeprom_query_addr(il, offset);
-		*eeprom_ch_index = il_eeprom_band_5;
+		*eeprom_ch_idx = il_eeprom_band_5;
 		break;
 	case 6:		/* 2.4GHz ht40 channels */
 		*eeprom_ch_count = ARRAY_SIZE(il_eeprom_band_6);
 		*eeprom_ch_info = (struct il_eeprom_channel *)
 				il_eeprom_query_addr(il, offset);
-		*eeprom_ch_index = il_eeprom_band_6;
+		*eeprom_ch_idx = il_eeprom_band_6;
 		break;
 	case 7:		/* 5 GHz ht40 channels */
 		*eeprom_ch_count = ARRAY_SIZE(il_eeprom_band_7);
 		*eeprom_ch_info = (struct il_eeprom_channel *)
 				il_eeprom_query_addr(il, offset);
-		*eeprom_ch_index = il_eeprom_band_7;
+		*eeprom_ch_idx = il_eeprom_band_7;
 		break;
 	default:
 		BUG();
@@ -374,7 +374,7 @@ static int il_mod_ht40_chan_info(struct il_priv *il,
 int il_init_channel_map(struct il_priv *il)
 {
 	int eeprom_ch_count = 0;
-	const u8 *eeprom_ch_index = NULL;
+	const u8 *eeprom_ch_idx = NULL;
 	const struct il_eeprom_channel *eeprom_ch_info = NULL;
 	int band, ch;
 	struct il_channel_info *ch_info;
@@ -412,11 +412,11 @@ int il_init_channel_map(struct il_priv *il)
 	for (band = 1; band <= 5; band++) {
 
 		il_init_band_reference(il, band, &eeprom_ch_count,
-					&eeprom_ch_info, &eeprom_ch_index);
+					&eeprom_ch_info, &eeprom_ch_idx);
 
 		/* Loop through each band adding each of the channels */
 		for (ch = 0; ch < eeprom_ch_count; ch++) {
-			ch_info->channel = eeprom_ch_index[ch];
+			ch_info->channel = eeprom_ch_idx[ch];
 			ch_info->band = (band == 1) ? IEEE80211_BAND_2GHZ :
 			    IEEE80211_BAND_5GHZ;
 
@@ -486,7 +486,7 @@ int il_init_channel_map(struct il_priv *il)
 		enum ieee80211_band ieeeband;
 
 		il_init_band_reference(il, band, &eeprom_ch_count,
-					&eeprom_ch_info, &eeprom_ch_index);
+					&eeprom_ch_info, &eeprom_ch_idx);
 
 		/* EEPROM band 6 is 2.4, band 7 is 5 GHz */
 		ieeeband =
@@ -496,13 +496,13 @@ int il_init_channel_map(struct il_priv *il)
 		for (ch = 0; ch < eeprom_ch_count; ch++) {
 			/* Set up driver's info for lower half */
 			il_mod_ht40_chan_info(il, ieeeband,
-						eeprom_ch_index[ch],
+						eeprom_ch_idx[ch],
 						&eeprom_ch_info[ch],
 						IEEE80211_CHAN_NO_HT40PLUS);
 
 			/* Set up driver's info for upper half */
 			il_mod_ht40_chan_info(il, ieeeband,
-						eeprom_ch_index[ch] + 4,
+						eeprom_ch_idx[ch] + 4,
 						&eeprom_ch_info[ch],
 						IEEE80211_CHAN_NO_HT40MINUS);
 		}
diff --git a/drivers/net/wireless/iwlegacy/iwl-eeprom.h b/drivers/net/wireless/iwlegacy/iwl-eeprom.h
index b97c837..eb868c0 100644
--- a/drivers/net/wireless/iwlegacy/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlegacy/iwl-eeprom.h
@@ -153,7 +153,7 @@ extern const u8 il_eeprom_band_1[14];
  *
  * 1)  Temperature (degrees Celsius) of device when measurement was made.
  *
- * 2)  Gain table index used to achieve the target measurement power.
+ * 2)  Gain table idx used to achieve the target measurement power.
  *     This refers to the "well-known" gain tables (see iwl-4965-hw.h).
  *
  * 3)  Actual measured output power, in half-dBm ("34" = 17 dBm).
diff --git a/drivers/net/wireless/iwlegacy/iwl-fh.h b/drivers/net/wireless/iwlegacy/iwl-fh.h
index e993e3e..f53f1b8 100644
--- a/drivers/net/wireless/iwlegacy/iwl-fh.h
+++ b/drivers/net/wireless/iwlegacy/iwl-fh.h
@@ -141,7 +141,7 @@
  *     into FH_RSCSR_CHNL0_RBDCB_BASE_REG [27:0].
  *
  * 2)  Rx status buffer, 8 bytes, in which 4965 indicates which Rx Buffers
- *     (RBs) have been filled, via a "write pointer", actually the index of
+ *     (RBs) have been filled, via a "write pointer", actually the idx of
  *     the RB's corresponding RBD within the circular buffer.  Driver sets
  *     physical address [35:4] into FH_RSCSR_CHNL0_STTS_WPTR_REG [31:0].
  *
@@ -153,33 +153,33 @@
  *
  * As the driver prepares Receive Buffers (RBs) for 4965 to fill, driver must
  * enter pointers to these RBs into contiguous RBD circular buffer entries,
- * and update the 4965's "write" index register,
+ * and update the 4965's "write" idx register,
  * FH_RSCSR_CHNL0_RBDCB_WPTR_REG.
  *
- * This "write" index corresponds to the *next* RBD that the driver will make
+ * This "write" idx corresponds to the *next* RBD that the driver will make
  * available, i.e. one RBD past the tail of the ready-to-fill RBDs within
  * the circular buffer.  This value should initially be 0 (before preparing any
  * RBs), should be 8 after preparing the first 8 RBs (for example), and must
  * wrap back to 0 at the end of the circular buffer (but don't wrap before
- * "read" index has advanced past 1!  See below).
+ * "read" idx has advanced past 1!  See below).
  * NOTE:  4965 EXPECTS THE WRITE IDX TO BE INCREMENTED IN MULTIPLES OF 8.
  *
  * As the 4965 fills RBs (referenced from contiguous RBDs within the circular
  * buffer), it updates the Rx status buffer in host DRAM, 2) described above,
- * to tell the driver the index of the latest filled RBD.  The driver must
- * read this "read" index from DRAM after receiving an Rx interrupt from 4965.
+ * to tell the driver the idx of the latest filled RBD.  The driver must
+ * read this "read" idx from DRAM after receiving an Rx interrupt from 4965.
  *
- * The driver must also internally keep track of a third index, which is the
+ * The driver must also internally keep track of a third idx, which is the
  * next RBD to process.  When receiving an Rx interrupt, driver should process
  * all filled but unprocessed RBs up to, but not including, the RB
- * corresponding to the "read" index.  For example, if "read" index becomes "1",
+ * corresponding to the "read" idx.  For example, if "read" idx becomes "1",
  * driver may process the RB pointed to by RBD 0.  Depending on volume of
  * traffic, there may be many RBs to process.
  *
- * If read index == write index, 4965 thinks there is no room to put new data.
+ * If read idx == write idx, 4965 thinks there is no room to put new data.
  * Due to this, the maximum number of filled RBs is 255, instead of 256.  To
  * be safe, make sure that there is a gap of at least 2 RBDs between "write"
- * and "read" indexes; that is, make sure that there are no more than 254
+ * and "read" idxes; that is, make sure that there are no more than 254
  * buffers waiting to be filled.
  */
 #define FH_MEM_RSCSR_LOWER_BOUND	(FH_MEM_LOWER_BOUND + 0xBC0)
@@ -201,7 +201,7 @@
 #define FH_RSCSR_CHNL0_RBDCB_BASE_REG	(FH_MEM_RSCSR_CHNL0 + 0x004)
 
 /**
- * Rx write pointer (index, really!).
+ * Rx write pointer (idx, really!).
  * Bit fields:
  *  11-0:  Index of driver's most recent prepared-to-be-filled RBD, + 1.
  *         NOTE:  For 256-entry circular buffer, use only bits [7:0].
@@ -431,11 +431,11 @@
 /**
  * struct il_rb_status - reseve buffer status
  * 	host memory mapped FH registers
- * @closed_rb_num [0:11] - Indicates the index of the RB which was closed
- * @closed_fr_num [0:11] - Indicates the index of the RX Frame which was closed
- * @finished_rb_num [0:11] - Indicates the index of the current RB
+ * @closed_rb_num [0:11] - Indicates the idx of the RB which was closed
+ * @closed_fr_num [0:11] - Indicates the idx of the RX Frame which was closed
+ * @finished_rb_num [0:11] - Indicates the idx of the current RB
  * 	in which the last frame was written to
- * @finished_fr_num [0:11] - Indicates the index of the RX Frame
+ * @finished_fr_num [0:11] - Indicates the idx of the RX Frame
  * 	which was transferred
  */
 struct il_rb_status {
diff --git a/drivers/net/wireless/iwlegacy/iwl-helpers.h b/drivers/net/wireless/iwlegacy/iwl-helpers.h
index a9d8702..5fcb23e 100644
--- a/drivers/net/wireless/iwlegacy/iwl-helpers.h
+++ b/drivers/net/wireless/iwlegacy/iwl-helpers.h
@@ -45,23 +45,23 @@ static inline struct ieee80211_conf *il_ieee80211_get_hw_conf(
 }
 
 /**
- * il_queue_inc_wrap - increment queue index, wrap back to beginning
- * @index -- current index
+ * il_queue_inc_wrap - increment queue idx, wrap back to beginning
+ * @idx -- current idx
  * @n_bd -- total number of entries in queue (must be power of 2)
  */
-static inline int il_queue_inc_wrap(int index, int n_bd)
+static inline int il_queue_inc_wrap(int idx, int n_bd)
 {
-	return ++index & (n_bd - 1);
+	return ++idx & (n_bd - 1);
 }
 
 /**
- * il_queue_dec_wrap - decrement queue index, wrap back to end
- * @index -- current index
+ * il_queue_dec_wrap - decrement queue idx, wrap back to end
+ * @idx -- current idx
  * @n_bd -- total number of entries in queue (must be power of 2)
  */
-static inline int il_queue_dec_wrap(int index, int n_bd)
+static inline int il_queue_dec_wrap(int idx, int n_bd)
 {
-	return --index & (n_bd - 1);
+	return --idx & (n_bd - 1);
 }
 
 /* TODO: Move fw_desc functions to iwl-pci.ko */
diff --git a/drivers/net/wireless/iwlegacy/iwl-led.c b/drivers/net/wireless/iwlegacy/iwl-led.c
index a283804..3652cdc 100644
--- a/drivers/net/wireless/iwlegacy/iwl-led.c
+++ b/drivers/net/wireless/iwlegacy/iwl-led.c
@@ -41,7 +41,7 @@
 #include "iwl-core.h"
 #include "iwl-io.h"
 
-/* default: IL_LED_BLINK(0) using blinking index table */
+/* default: IL_LED_BLINK(0) using blinking idx table */
 static int led_mode;
 module_param(led_mode, int, S_IRUGO);
 MODULE_PARM_DESC(led_mode, "0=system default, "
diff --git a/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h b/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
index f3ee0dd..bc09a5d 100644
--- a/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
+++ b/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
@@ -49,13 +49,13 @@ struct il3945_rate_info {
 	u8 next_rs;		/* next rate used in rs algo */
 	u8 prev_rs_tgg;		/* previous rate used in TGG rs algo */
 	u8 next_rs_tgg;		/* next rate used in TGG rs algo */
-	u8 table_rs_index;	/* index in rate scale table cmd */
+	u8 table_rs_idx;	/* idx in rate scale table cmd */
 	u8 prev_table_rs;	/* prev in rate table cmd */
 };
 
 
 /*
- * These serve as indexes into
+ * These serve as idxes into
  * struct il_rate_info il_rates[RATE_COUNT];
  */
 enum {
@@ -351,7 +351,7 @@ struct il_traffic_load {
  * Pointer to this gets passed back and forth between driver and mac80211.
  */
 struct il_lq_sta {
-	u8 active_tbl;		/* index of active table, range 0-1 */
+	u8 active_tbl;		/* idx of active table, range 0-1 */
 	u8 enable_counter;	/* indicates HT mode */
 	u8 stay_in_tbl;		/* 1: disallow, 0: allow search for new mode */
 	u8 search_better_tbl;	/* 1: currently trying alternate mode */
diff --git a/drivers/net/wireless/iwlegacy/iwl-prph.h b/drivers/net/wireless/iwlegacy/iwl-prph.h
index 200f295..8128c87 100644
--- a/drivers/net/wireless/iwlegacy/iwl-prph.h
+++ b/drivers/net/wireless/iwlegacy/iwl-prph.h
@@ -336,7 +336,7 @@
 
 /*
  * Driver may need to update queue-empty bits after changing queue's
- * write and read pointers (indexes) during (re-)initialization (i.e. when
+ * write and read pointers (idxes) during (re-)initialization (i.e. when
  * scheduler is not tracking what's happening).
  * Bit fields:
  * 31-16:  Write mask -- 1: update empty bit, 0: don't change empty bit
@@ -351,7 +351,7 @@
  * This register points to BC CB for queue 0, must be on 1024-byte boundary.
  * Others are spaced by 1024 bytes.
  * Each BC CB is 2 bytes * (256 + 64) = 740 bytes, followed by 384 bytes pad.
- * (Index into a queue's BC CB) = (index into queue's TFD CB) = (SSN & 0xff).
+ * (Index into a queue's BC CB) = (idx into queue's TFD CB) = (SSN & 0xff).
  * Bit fields:
  * 25-00:  Byte Count CB physical address [35:10], must be 1024-byte aligned.
  */
@@ -366,18 +366,18 @@
  */
 #define IL49_SCD_TXFACT                   (IL49_SCD_START_OFFSET + 0x1c)
 /*
- * Queue (x) Write Pointers (indexes, really!), one for each Tx queue.
+ * Queue (x) Write Pointers (idxes, really!), one for each Tx queue.
  * Initialized and updated by driver as new TFDs are added to queue.
- * NOTE:  If using Block Ack, index must correspond to frame's
- *        Start Sequence Number; index = (SSN & 0xff)
+ * NOTE:  If using Block Ack, idx must correspond to frame's
+ *        Start Sequence Number; idx = (SSN & 0xff)
  * NOTE:  Alternative to HBUS_TARG_WRPTR, which is what Linux driver uses?
  */
 #define IL49_SCD_QUEUE_WRPTR(x)  (IL49_SCD_START_OFFSET + 0x24 + (x) * 4)
 
 /*
- * Queue (x) Read Pointers (indexes, really!), one for each Tx queue.
- * For FIFO mode, index indicates next frame to transmit.
- * For Scheduler-ACK mode, index indicates first frame in Tx win.
+ * Queue (x) Read Pointers (idxes, really!), one for each Tx queue.
+ * For FIFO mode, idx indicates next frame to transmit.
+ * For Scheduler-ACK mode, idx indicates first frame in Tx win.
  * Initialized by driver, updated by scheduler.
  */
 #define IL49_SCD_QUEUE_RDPTR(x)  (IL49_SCD_START_OFFSET + 0x64 + (x) * 4)
@@ -395,7 +395,7 @@
 
 /*
  * Select which queues interrupt driver when scheduler increments
- * a queue's read pointer (index).
+ * a queue's read pointer (idx).
  * Bit fields:
  * 31-16:  Reserved
  * 15-00:  Interrupt enable, one bit for each queue -- 1: enabled, 0: disabled
diff --git a/drivers/net/wireless/iwlegacy/iwl-rx.c b/drivers/net/wireless/iwlegacy/iwl-rx.c
index 5c0d131..58d19c1 100644
--- a/drivers/net/wireless/iwlegacy/iwl-rx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-rx.c
@@ -45,17 +45,17 @@
  * each of which point to Receive Buffers to be filled by the NIC.  These get
  * used not only for Rx frames, but for any command response or notification
  * from the NIC.  The driver and NIC manage the Rx buffers by means
- * of indexes into the circular buffer.
+ * of idxes into the circular buffer.
  *
  * Rx Queue Indexes
- * The host/firmware share two index registers for managing the Rx buffers.
+ * The host/firmware share two idx registers for managing the Rx buffers.
  *
- * The READ index maps to the first position that the firmware may be writing
+ * The READ idx maps to the first position that the firmware may be writing
  * to -- the driver can read up to (but not including) this position and get
  * good data.
- * The READ index is managed by the firmware once the card is enabled.
+ * The READ idx is managed by the firmware once the card is enabled.
  *
- * The WRITE index maps to the last position the driver has read from -- the
+ * The WRITE idx maps to the last position the driver has read from -- the
  * position preceding WRITE is the last slot the firmware can place a packet.
  *
  * The queue is empty (no good data) if WRITE = READ - 1, and is full if
@@ -64,9 +64,9 @@
  * During initialization, the host sets up the READ queue position to the first
  * IDX position, and WRITE to the last (READ - 1 wrapped)
  *
- * When the firmware places a packet in a buffer, it will advance the READ index
- * and fire the RX interrupt.  The driver can then query the READ index and
- * process as many packets as possible, moving the WRITE index forward as it
+ * When the firmware places a packet in a buffer, it will advance the READ idx
+ * and fire the RX interrupt.  The driver can then query the READ idx and
+ * process as many packets as possible, moving the WRITE idx forward as it
  * resets the Rx queue buffers with new memory.
  *
  * The management in the driver is as follows:
@@ -75,9 +75,9 @@
  *   to replenish the iwl->rxq->rx_free.
  * + In il_rx_replenish (scheduled) if 'processed' != 'read' then the
  *   iwl->rxq is replenished and the READ IDX is updated (updating the
- *   'processed' and 'read' driver indexes as well)
+ *   'processed' and 'read' driver idxes as well)
  * + A received packet is processed and handed to the kernel network stack,
- *   detached from the iwl->rxq.  The driver 'processed' index is updated.
+ *   detached from the iwl->rxq.  The driver 'processed' idx is updated.
  * + The Host/Firmware iwl->rxq is replenished at tasklet time from the rx_free
  *   list. If there are no allocated buffers in iwl->rxq->rx_free, the READ
  *   IDX is not incremented and iwl->status(RX_STALLED) is set.  If there
@@ -91,7 +91,7 @@
  *                            il_rx_queue_restock
  * il_rx_queue_restock() Moves available buffers from rx_free into Rx
  *                            queue, updates firmware pointers, and updates
- *                            the WRITE index.  If insufficient rx_free buffers
+ *                            the WRITE idx.  If insufficient rx_free buffers
  *                            are available, schedules il_rx_replenish
  *
  * -- enable interrupts --
diff --git a/drivers/net/wireless/iwlegacy/iwl-sta.c b/drivers/net/wireless/iwlegacy/iwl-sta.c
index dcaa3fb..a7fe9ea 100644
--- a/drivers/net/wireless/iwlegacy/iwl-sta.c
+++ b/drivers/net/wireless/iwlegacy/iwl-sta.c
@@ -174,7 +174,7 @@ int il_send_add_sta(struct il_priv *il,
 }
 EXPORT_SYMBOL(il_send_add_sta);
 
-static void il_set_ht_add_station(struct il_priv *il, u8 index,
+static void il_set_ht_add_station(struct il_priv *il, u8 idx,
 				   struct ieee80211_sta *sta,
 				   struct il_rxon_context *ctx)
 {
@@ -192,7 +192,7 @@ static void il_set_ht_add_station(struct il_priv *il, u8 index,
 			(mimo_ps_mode == WLAN_HT_CAP_SM_PS_DYNAMIC) ?
 			"dynamic" : "disabled");
 
-	sta_flags = il->stations[index].sta.station_flags;
+	sta_flags = il->stations[idx].sta.station_flags;
 
 	sta_flags &= ~(STA_FLG_RTS_MIMO_PROT_MSK | STA_FLG_MIMO_DIS_MSK);
 
@@ -221,7 +221,7 @@ static void il_set_ht_add_station(struct il_priv *il, u8 index,
 	else
 		sta_flags &= ~STA_FLG_HT40_EN_MSK;
 
-	il->stations[index].sta.station_flags = sta_flags;
+	il->stations[idx].sta.station_flags = sta_flags;
  done:
 	return;
 }
@@ -649,7 +649,7 @@ il_restore_stations(struct il_priv *il, struct il_rxon_context *ctx)
 }
 EXPORT_SYMBOL(il_restore_stations);
 
-int il_get_free_ucode_key_index(struct il_priv *il)
+int il_get_free_ucode_key_idx(struct il_priv *il)
 {
 	int i;
 
@@ -659,7 +659,7 @@ int il_get_free_ucode_key_index(struct il_priv *il)
 
 	return WEP_INVALID_OFFSET;
 }
-EXPORT_SYMBOL(il_get_free_ucode_key_index);
+EXPORT_SYMBOL(il_get_free_ucode_key_idx);
 
 void il_dealloc_bcast_stations(struct il_priv *il)
 {
@@ -692,7 +692,7 @@ static void il_dump_lq_cmd(struct il_priv *il,
 		       lq->general_params.dual_stream_ant_msk);
 
 	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++)
-		D_RATE("lq index %d 0x%X\n",
+		D_RATE("lq idx %d 0x%X\n",
 			       i, lq->rs_table[i].rate_n_flags);
 }
 #else
@@ -728,7 +728,7 @@ static bool il_is_lq_table_valid(struct il_priv *il,
 		if (le32_to_cpu(lq->rs_table[i].rate_n_flags) &
 						RATE_MCS_HT_MSK) {
 			D_INFO(
-				       "index %d of LQ expects HT channel\n",
+				       "idx %d of LQ expects HT channel\n",
 				       i);
 			return false;
 		}
diff --git a/drivers/net/wireless/iwlegacy/iwl-sta.h b/drivers/net/wireless/iwlegacy/iwl-sta.h
index 77cdfd4..f07cd7f 100644
--- a/drivers/net/wireless/iwlegacy/iwl-sta.h
+++ b/drivers/net/wireless/iwlegacy/iwl-sta.h
@@ -48,7 +48,7 @@ void il_restore_stations(struct il_priv *il,
 void il_clear_ucode_stations(struct il_priv *il,
 			      struct il_rxon_context *ctx);
 void il_dealloc_bcast_stations(struct il_priv *il);
-int il_get_free_ucode_key_index(struct il_priv *il);
+int il_get_free_ucode_key_idx(struct il_priv *il);
 int il_send_add_sta(struct il_priv *il,
 			struct il_addsta_cmd *sta, u8 flags);
 int il_add_station_common(struct il_priv *il,
diff --git a/drivers/net/wireless/iwlegacy/iwl-tx.c b/drivers/net/wireless/iwlegacy/iwl-tx.c
index 45114b4..10a0914 100644
--- a/drivers/net/wireless/iwlegacy/iwl-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-tx.c
@@ -39,7 +39,7 @@
 #include "iwl-helpers.h"
 
 /**
- * il_txq_update_write_ptr - Send new write index to hardware
+ * il_txq_update_write_ptr - Send new write idx to hardware
  */
 void
 il_txq_update_write_ptr(struct il_priv *il, struct il_tx_queue *txq)
@@ -152,7 +152,7 @@ void il_cmd_queue_unmap(struct il_priv *il)
 		return;
 
 	while (q->read_ptr != q->write_ptr) {
-		i = il_get_cmd_index(q, q->read_ptr, 0);
+		i = il_get_cmd_idx(q, q->read_ptr, 0);
 
 		if (txq->meta[i].flags & CMD_MAPPED) {
 			pci_unmap_single(il->pci_dev,
@@ -254,7 +254,7 @@ EXPORT_SYMBOL(il_queue_space);
 
 
 /**
- * il_queue_init - Initialize queue's high/low-water and read/write indexes
+ * il_queue_init - Initialize queue's high/low-water and read/write idxes
  */
 static int il_queue_init(struct il_priv *il, struct il_queue *q,
 			  int count, int slots_num, u32 id)
@@ -268,7 +268,7 @@ static int il_queue_init(struct il_priv *il, struct il_queue *q,
 	BUG_ON(!is_power_of_2(count));
 
 	/* slots_num must be power-of-two size, otherwise
-	 * il_get_cmd_index is broken. */
+	 * il_get_cmd_idx is broken. */
 	BUG_ON(!is_power_of_2(slots_num));
 
 	q->low_mark = q->n_win / 4;
@@ -385,7 +385,7 @@ int il_tx_queue_init(struct il_priv *il, struct il_tx_queue *txq,
 	 * il_queue_inc_wrap and il_queue_dec_wrap are broken. */
 	BUILD_BUG_ON(TFD_QUEUE_SIZE_MAX & (TFD_QUEUE_SIZE_MAX - 1));
 
-	/* Initialize queue's high/low-water marks, and head/tail indexes */
+	/* Initialize queue's high/low-water marks, and head/tail idxes */
 	il_queue_init(il, &txq->q,
 				TFD_QUEUE_SIZE_MAX, slots_num, txq_id);
 
@@ -416,7 +416,7 @@ void il_tx_queue_reset(struct il_priv *il, struct il_tx_queue *txq,
 
 	txq->need_update = 0;
 
-	/* Initialize queue's high/low-water marks, and head/tail indexes */
+	/* Initialize queue's high/low-water marks, and head/tail idxes */
 	il_queue_init(il, &txq->q,
 				TFD_QUEUE_SIZE_MAX, slots_num, txq_id);
 
@@ -433,7 +433,7 @@ EXPORT_SYMBOL(il_tx_queue_reset);
  * @cmd: a point to the ucode command structure
  *
  * The function returns < 0 values to indicate the operation is
- * failed. On success, it turns the index (> 0) of command in the
+ * failed. On success, it turns the idx (> 0) of command in the
  * command queue.
  */
 int il_enqueue_hcmd(struct il_priv *il, struct il_host_cmd *cmd)
@@ -476,7 +476,7 @@ int il_enqueue_hcmd(struct il_priv *il, struct il_host_cmd *cmd)
 		return -ENOSPC;
 	}
 
-	idx = il_get_cmd_index(q, q->write_ptr, cmd->flags & CMD_SIZE_HUGE);
+	idx = il_get_cmd_idx(q, q->write_ptr, cmd->flags & CMD_SIZE_HUGE);
 	out_cmd = txq->cmd[idx];
 	out_meta = &txq->meta[idx];
 
@@ -543,7 +543,7 @@ int il_enqueue_hcmd(struct il_priv *il, struct il_host_cmd *cmd)
 						   phys_addr, fix_size, 1,
 						   U32_PAD(cmd->len));
 
-	/* Increment and update queue's write index */
+	/* Increment and update queue's write idx */
 	q->write_ptr = il_queue_inc_wrap(q->write_ptr, q->n_bd);
 	il_txq_update_write_ptr(il, txq);
 
@@ -554,7 +554,7 @@ int il_enqueue_hcmd(struct il_priv *il, struct il_host_cmd *cmd)
 /**
  * il_hcmd_queue_reclaim - Reclaim TX command queue entries already Tx'd
  *
- * When FW advances 'R' index, all entries between old and new 'R' index
+ * When FW advances 'R' idx, all entries between old and new 'R' idx
  * need to be reclaimed. As result, some free space forms.  If there is
  * enough free space (> low mark), wake the stack that feeds us.
  */
@@ -566,7 +566,7 @@ static void il_hcmd_queue_reclaim(struct il_priv *il, int txq_id,
 	int nfreed = 0;
 
 	if (idx >= q->n_bd || il_queue_used(q, idx) == 0) {
-		IL_ERR("Read index for DMA queue txq id (%d), index %d, "
+		IL_ERR("Read idx for DMA queue txq id (%d), idx %d, "
 			  "is out of range [0-%d] %d %d.\n", txq_id,
 			  idx, q->n_bd, q->write_ptr, q->read_ptr);
 		return;
@@ -576,7 +576,7 @@ static void il_hcmd_queue_reclaim(struct il_priv *il, int txq_id,
 	     q->read_ptr = il_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 
 		if (nfreed++ > 0) {
-			IL_ERR("HCMD skipped: index (%d) %d %d\n", idx,
+			IL_ERR("HCMD skipped: idx (%d) %d %d\n", idx,
 					q->write_ptr, q->read_ptr);
 			queue_work(il->workqueue, &il->restart);
 		}
@@ -598,8 +598,8 @@ il_tx_cmd_complete(struct il_priv *il, struct il_rx_buf *rxb)
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	int txq_id = SEQ_TO_QUEUE(sequence);
-	int index = SEQ_TO_IDX(sequence);
-	int cmd_index;
+	int idx = SEQ_TO_IDX(sequence);
+	int cmd_idx;
 	bool huge = !!(pkt->hdr.sequence & SEQ_HUGE_FRAME);
 	struct il_device_cmd *cmd;
 	struct il_cmd_meta *meta;
@@ -618,9 +618,9 @@ il_tx_cmd_complete(struct il_priv *il, struct il_rx_buf *rxb)
 		return;
 	}
 
-	cmd_index = il_get_cmd_index(&txq->q, index, huge);
-	cmd = txq->cmd[cmd_index];
-	meta = &txq->meta[cmd_index];
+	cmd_idx = il_get_cmd_idx(&txq->q, idx, huge);
+	cmd = txq->cmd[cmd_idx];
+	meta = &txq->meta[cmd_idx];
 
 	txq->time_stamp = jiffies;
 
@@ -638,7 +638,7 @@ il_tx_cmd_complete(struct il_priv *il, struct il_rx_buf *rxb)
 
 	spin_lock_irqsave(&il->hcmd_lock, flags);
 
-	il_hcmd_queue_reclaim(il, txq_id, index, cmd_index);
+	il_hcmd_queue_reclaim(il, txq_id, idx, cmd_idx);
 
 	if (!(meta->flags & CMD_ASYNC)) {
 		clear_bit(STATUS_HCMD_ACTIVE, &il->status);
diff --git a/drivers/net/wireless/iwlegacy/iwl3945-base.c b/drivers/net/wireless/iwlegacy/iwl3945-base.c
index 017b297..9244208 100644
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
@@ -163,7 +163,7 @@ static int il3945_set_ccmp_dynamic_key_info(struct il_priv *il,
 	if ((il->stations[sta_id].sta.key.key_flags & STA_KEY_FLG_ENCRYPT_MSK)
 			== STA_KEY_FLG_NO_ENC)
 		il->stations[sta_id].sta.key.key_offset =
-				 il_get_free_ucode_key_index(il);
+				 il_get_free_ucode_key_idx(il);
 	/* else, we are overriding an existing key => no need to allocated room
 	* in uCode. */
 
@@ -513,7 +513,7 @@ static int il3945_tx_skb(struct il_priv *il, struct sk_buff *skb)
 
 	hdr_len = ieee80211_hdrlen(fc);
 
-	/* Find index into station table for destination station */
+	/* Find idx into station table for destination station */
 	sta_id = il_sta_id_or_broadcast(
 			il, &il->ctx,
 			info->control.sta);
@@ -541,7 +541,7 @@ static int il3945_tx_skb(struct il_priv *il, struct sk_buff *skb)
 
 	spin_lock_irqsave(&il->lock, flags);
 
-	idx = il_get_cmd_index(q, q->write_ptr, 0);
+	idx = il_get_cmd_idx(q, q->write_ptr, 0);
 
 	/* Set up driver data for this TFD */
 	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct il_tx_info));
@@ -557,7 +557,7 @@ static int il3945_tx_skb(struct il_priv *il, struct sk_buff *skb)
 
 	/*
 	 * Set up the Tx-command (not MAC!) header.
-	 * Store the chosen Tx queue and TFD index within the sequence field;
+	 * Store the chosen Tx queue and TFD idx within the sequence field;
 	 * after Tx, uCode's Tx response will return this value so driver can
 	 * locate the frame within the tx queue and do post-tx processing.
 	 */
@@ -641,7 +641,7 @@ static int il3945_tx_skb(struct il_priv *il, struct sk_buff *skb)
 	}
 
 
-	/* Tell device the write index *just past* this latest filled TFD */
+	/* Tell device the write idx *just past* this latest filled TFD */
 	q->write_ptr = il_queue_inc_wrap(q->write_ptr, q->n_bd);
 	il_txq_update_write_ptr(il, txq);
 	spin_unlock_irqrestore(&il->lock, flags);
@@ -889,14 +889,14 @@ static void il3945_setup_rx_handlers(struct il_priv *il)
  * 0 to 31
  *
  * Rx Queue Indexes
- * The host/firmware share two index registers for managing the Rx buffers.
+ * The host/firmware share two idx registers for managing the Rx buffers.
  *
- * The READ index maps to the first position that the firmware may be writing
+ * The READ idx maps to the first position that the firmware may be writing
  * to -- the driver can read up to (but not including) this position and get
  * good data.
- * The READ index is managed by the firmware once the card is enabled.
+ * The READ idx is managed by the firmware once the card is enabled.
  *
- * The WRITE index maps to the last position the driver has read from -- the
+ * The WRITE idx maps to the last position the driver has read from -- the
  * position preceding WRITE is the last slot the firmware can place a packet.
  *
  * The queue is empty (no good data) if WRITE = READ - 1, and is full if
@@ -905,9 +905,9 @@ static void il3945_setup_rx_handlers(struct il_priv *il)
  * During initialization, the host sets up the READ queue position to the first
  * IDX position, and WRITE to the last (READ - 1 wrapped)
  *
- * When the firmware places a packet in a buffer, it will advance the READ index
- * and fire the RX interrupt.  The driver can then query the READ index and
- * process as many packets as possible, moving the WRITE index forward as it
+ * When the firmware places a packet in a buffer, it will advance the READ idx
+ * and fire the RX interrupt.  The driver can then query the READ idx and
+ * process as many packets as possible, moving the WRITE idx forward as it
  * resets the Rx queue buffers with new memory.
  *
  * The management in the driver is as follows:
@@ -916,9 +916,9 @@ static void il3945_setup_rx_handlers(struct il_priv *il)
  *   to replenish the iwl->rxq->rx_free.
  * + In il3945_rx_replenish (scheduled) if 'processed' != 'read' then the
  *   iwl->rxq is replenished and the READ IDX is updated (updating the
- *   'processed' and 'read' driver indexes as well)
+ *   'processed' and 'read' driver idxes as well)
  * + A received packet is processed and handed to the kernel network stack,
- *   detached from the iwl->rxq.  The driver 'processed' index is updated.
+ *   detached from the iwl->rxq.  The driver 'processed' idx is updated.
  * + The Host/Firmware iwl->rxq is replenished at tasklet time from the rx_free
  *   list. If there are no allocated buffers in iwl->rxq->rx_free, the READ
  *   IDX is not incremented and iwl->status(RX_STALLED) is set.  If there
@@ -931,7 +931,7 @@ static void il3945_setup_rx_handlers(struct il_priv *il)
  *                            il3945_rx_queue_restock
  * il3945_rx_queue_restock() Moves available buffers from rx_free into Rx
  *                            queue, updates firmware pointers, and updates
- *                            the WRITE index.  If insufficient rx_free buffers
+ *                            the WRITE idx.  If insufficient rx_free buffers
  *                            are available, schedules il3945_rx_replenish
  *
  * -- enable interrupts --
@@ -960,7 +960,7 @@ static inline __le32 il3945_dma_addr2rbd_ptr(struct il_priv *il,
  * and we have free pre-allocated buffers, fill the ranks as much
  * as we can, pulling from rx_free.
  *
- * This moves the 'write' index forward to catch up with 'processed', and
+ * This moves the 'write' idx forward to catch up with 'processed', and
  * also updates the memory address in the firmware to reference the new
  * target buffer.
  */
@@ -1211,7 +1211,7 @@ static void il3945_rx_handle(struct il_priv *il)
 	u32 count = 8;
 	int total_empty = 0;
 
-	/* uCode's read index (stored in shared DRAM) indicates the last Rx
+	/* uCode's read idx (stored in shared DRAM) indicates the last Rx
 	 * buffer that the driver may process (last buffer filled by ucode). */
 	r = le16_to_cpu(rxq->rb_stts->closed_rb_num) &  0x0FFF;
 	i = rxq->read;
@@ -1656,7 +1656,7 @@ static void il3945_init_hw_rates(struct il_priv *il,
 
 	for (i = 0; i < RATE_COUNT_LEGACY; i++) {
 		rates[i].bitrate = il3945_rates[i].ieee * 5;
-		rates[i].hw_value = i; /* Rate scaling will work on indexes */
+		rates[i].hw_value = i; /* Rate scaling will work on idxes */
 		rates[i].hw_value_short = i;
 		rates[i].flags = 0;
 		if (i > IL39_LAST_OFDM_RATE || i < IL_FIRST_OFDM_RATE) {
@@ -1850,7 +1850,7 @@ IL3945_UCODE_GET(boot_size);
 static int il3945_read_ucode(struct il_priv *il)
 {
 	const struct il_ucode_header *ucode;
-	int ret = -EINVAL, index;
+	int ret = -EINVAL, idx;
 	const struct firmware *ucode_raw;
 	/* firmware file name contains uCode/driver compatibility version */
 	const char *name_pre = il->cfg->fw_name_pre;
@@ -1863,8 +1863,8 @@ static int il3945_read_ucode(struct il_priv *il)
 
 	/* Ask kernel firmware_class module to get the boot firmware off disk.
 	 * request_firmware() is synchronous, file is in memory on return. */
-	for (index = api_max; index >= api_min; index--) {
-		sprintf(buf, "%s%u%s", name_pre, index, ".ucode");
+	for (idx = api_max; idx >= api_min; idx--) {
+		sprintf(buf, "%s%u%s", name_pre, idx, ".ucode");
 		ret = request_firmware(&ucode_raw, buf, &il->pci_dev->dev);
 		if (ret < 0) {
 			IL_ERR("%s firmware file req failed: %d\n",
@@ -1874,7 +1874,7 @@ static int il3945_read_ucode(struct il_priv *il)
 			else
 				goto error;
 		} else {
-			if (index < api_max)
+			if (idx < api_max)
 				IL_ERR("Loaded firmware %s, "
 					"which is deprecated. "
 					" Please use API v%u instead.\n",
diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index bc5a008..afdec78 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -173,7 +173,7 @@ static void il4965_set_beacon_tim(struct il_priv *il,
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)beacon;
 
 	/*
-	 * The index is relative to frame start but we start looking at the
+	 * The idx is relative to frame start but we start looking at the
 	 * variable-length part of the beacon.
 	 */
 	tim_idx = mgmt->u.beacon.variable - beacon;
@@ -318,7 +318,7 @@ static inline u8 il4965_tfd_get_num_tbs(struct il_tfd *tfd)
  * @il - driver ilate data
  * @txq - tx queue
  *
- * Does NOT advance any TFD circular buffer read/write indexes
+ * Does NOT advance any TFD circular buffer read/write idxes
  * Does NOT free the TFD itself (which is within circular buffer)
  */
 void il4965_hw_txq_free_tfd(struct il_priv *il, struct il_tx_queue *txq)
@@ -326,11 +326,11 @@ void il4965_hw_txq_free_tfd(struct il_priv *il, struct il_tx_queue *txq)
 	struct il_tfd *tfd_tmp = (struct il_tfd *)txq->tfds;
 	struct il_tfd *tfd;
 	struct pci_dev *dev = il->pci_dev;
-	int index = txq->q.read_ptr;
+	int idx = txq->q.read_ptr;
 	int i;
 	int num_tbs;
 
-	tfd = &tfd_tmp[index];
+	tfd = &tfd_tmp[idx];
 
 	/* Sanity check on number of chunks */
 	num_tbs = il4965_tfd_get_num_tbs(tfd);
@@ -344,8 +344,8 @@ void il4965_hw_txq_free_tfd(struct il_priv *il, struct il_tx_queue *txq)
 	/* Unmap tx_cmd */
 	if (num_tbs)
 		pci_unmap_single(dev,
-				dma_unmap_addr(&txq->meta[index], mapping),
-				dma_unmap_len(&txq->meta[index], len),
+				dma_unmap_addr(&txq->meta[idx], mapping),
+				dma_unmap_len(&txq->meta[idx], len),
 				PCI_DMA_BIDIRECTIONAL);
 
 	/* Unmap chunks, if any. */
@@ -643,7 +643,7 @@ void il4965_rx_handle(struct il_priv *il)
 	u32 count = 8;
 	int total_empty;
 
-	/* uCode's read index (stored in shared DRAM) indicates the last Rx
+	/* uCode's read idx (stored in shared DRAM) indicates the last Rx
 	 * buffer that the driver may process (last buffer filled by ucode). */
 	r = le16_to_cpu(rxq->rb_stts->closed_rb_num) &  0x0FFF;
 	i = rxq->read;
@@ -1106,14 +1106,14 @@ static int __must_check il4965_request_firmware(struct il_priv *il, bool first)
 	char tag[8];
 
 	if (first) {
-		il->fw_index = il->cfg->ucode_api_max;
-		sprintf(tag, "%d", il->fw_index);
+		il->fw_idx = il->cfg->ucode_api_max;
+		sprintf(tag, "%d", il->fw_idx);
 	} else {
-		il->fw_index--;
-		sprintf(tag, "%d", il->fw_index);
+		il->fw_idx--;
+		sprintf(tag, "%d", il->fw_idx);
 	}
 
-	if (il->fw_index < il->cfg->ucode_api_min) {
+	if (il->fw_idx < il->cfg->ucode_api_min) {
 		IL_ERR("no suitable firmware found!\n");
 		return -ENOENT;
 	}
@@ -1213,7 +1213,7 @@ il4965_ucode_callback(const struct firmware *ucode_raw, void *context)
 	memset(&pieces, 0, sizeof(pieces));
 
 	if (!ucode_raw) {
-		if (il->fw_index <= il->cfg->ucode_api_max)
+		if (il->fw_idx <= il->cfg->ucode_api_max)
 			IL_ERR(
 				"request for firmware file '%s' failed.\n",
 				il->firmware_name);
@@ -1655,7 +1655,7 @@ static int il4965_alive_notify(struct il_priv *il)
 	/* Initialize each Tx queue (including the command queue) */
 	for (i = 0; i < il->hw_params.max_txq_num; i++) {
 
-		/* TFD circular buffer read/write indexes */
+		/* TFD circular buffer read/write idxes */
 		il_wr_prph(il, IL49_SCD_QUEUE_RDPTR(i), 0);
 		il_wr(il, HBUS_TARG_WRPTR, 0 | (i << 8));
 
@@ -2713,7 +2713,7 @@ static void il4965_init_hw_rates(struct il_priv *il,
 
 	for (i = 0; i < RATE_COUNT_LEGACY; i++) {
 		rates[i].bitrate = il_rates[i].ieee * 5;
-		rates[i].hw_value = i; /* Rate scaling will work on indexes */
+		rates[i].hw_value = i; /* Rate scaling will work on idxes */
 		rates[i].hw_value_short = i;
 		rates[i].flags = 0;
 		if ((i >= IL_FIRST_CCK_RATE) && (i <= IL_LAST_CCK_RATE)) {
@@ -2729,11 +2729,11 @@ static void il4965_init_hw_rates(struct il_priv *il,
 /*
  * Acquire il->lock before calling this function !
  */
-void il4965_set_wr_ptrs(struct il_priv *il, int txq_id, u32 index)
+void il4965_set_wr_ptrs(struct il_priv *il, int txq_id, u32 idx)
 {
 	il_wr(il, HBUS_TARG_WRPTR,
-			     (index & 0xff) | (txq_id << 8));
-	il_wr_prph(il, IL49_SCD_QUEUE_RDPTR(txq_id), index);
+			     (idx & 0xff) | (txq_id << 8));
+	il_wr_prph(il, IL49_SCD_QUEUE_RDPTR(txq_id), idx);
 }
 
 void il4965_tx_queue_set_status(struct il_priv *il,
-- 
1.7.1

