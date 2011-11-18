Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755565Ab1KRIVe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:21:34 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8LYFD022617
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:21:34 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 21/77] iwlegacy: s/statistics/stats/
Date: Fri, 18 Nov 2011 09:21:43 +0100
Message-Id: <1321604559-10707-21-git-send-email-sgruszka@redhat.com> (sfid-20111118_092139_719498_2E8FD021)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-3945-debugfs.c |   90 +++++++++---------
 drivers/net/wireless/iwlegacy/iwl-3945-rs.c      |    2 +-
 drivers/net/wireless/iwlegacy/iwl-3945.c         |   44 ++++----
 drivers/net/wireless/iwlegacy/iwl-3945.h         |    6 +-
 drivers/net/wireless/iwlegacy/iwl-4965-calib.c   |   36 ++++----
 drivers/net/wireless/iwlegacy/iwl-4965-debugfs.c |   94 +++++++++---------
 drivers/net/wireless/iwlegacy/iwl-4965-hw.h      |    4 +-
 drivers/net/wireless/iwlegacy/iwl-4965-rs.c      |    4 +-
 drivers/net/wireless/iwlegacy/iwl-4965-rx.c      |   66 +++++++-------
 drivers/net/wireless/iwlegacy/iwl-4965.c         |   12 +-
 drivers/net/wireless/iwlegacy/iwl-4965.h         |    4 +-
 drivers/net/wireless/iwlegacy/iwl-commands.h     |  112 +++++++++++-----------
 drivers/net/wireless/iwlegacy/iwl-core.c         |   20 ++--
 drivers/net/wireless/iwlegacy/iwl-core.h         |    6 +-
 drivers/net/wireless/iwlegacy/iwl-debugfs.c      |   28 +++---
 drivers/net/wireless/iwlegacy/iwl-dev.h          |   32 +++---
 drivers/net/wireless/iwlegacy/iwl-legacy-rs.h    |    2 +-
 drivers/net/wireless/iwlegacy/iwl-scan.c         |    2 +-
 drivers/net/wireless/iwlegacy/iwl3945-base.c     |   10 +-
 drivers/net/wireless/iwlegacy/iwl4965-base.c     |   34 ++++----
 20 files changed, 304 insertions(+), 304 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-3945-debugfs.c b/drivers/net/wireless/iwlegacy/iwl-3945-debugfs.c
index 40e3a70..88b3d8f 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945-debugfs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945-debugfs.c
@@ -29,22 +29,22 @@
 #include "iwl-3945-debugfs.h"
 
 
-static int il3945_statistics_flag(struct il_priv *il, char *buf, int bufsz)
+static int il3945_stats_flag(struct il_priv *il, char *buf, int bufsz)
 {
 	int p = 0;
 
 	p += scnprintf(buf + p, bufsz - p, "Statistics Flag(0x%X):\n",
-		       le32_to_cpu(il->_3945.statistics.flag));
-	if (le32_to_cpu(il->_3945.statistics.flag) &
+		       le32_to_cpu(il->_3945.stats.flag));
+	if (le32_to_cpu(il->_3945.stats.flag) &
 			UCODE_STATISTICS_CLEAR_MSK)
 		p += scnprintf(buf + p, bufsz - p,
 			       "\tStatistics have been cleared\n");
 	p += scnprintf(buf + p, bufsz - p, "\tOperational Frequency: %s\n",
-		       (le32_to_cpu(il->_3945.statistics.flag) &
+		       (le32_to_cpu(il->_3945.stats.flag) &
 			UCODE_STATISTICS_FREQUENCY_MSK)
 			? "2.4 GHz" : "5.2 GHz");
 	p += scnprintf(buf + p, bufsz - p, "\tTGj Narrow Band: %s\n",
-		       (le32_to_cpu(il->_3945.statistics.flag) &
+		       (le32_to_cpu(il->_3945.stats.flag) &
 			UCODE_STATISTICS_NARROW_BAND_MSK)
 			? "enabled" : "disabled");
 	return p;
@@ -57,14 +57,14 @@ ssize_t il3945_ucode_rx_stats_read(struct file *file,
 	struct il_priv *il = file->private_data;
 	int pos = 0;
 	char *buf;
-	int bufsz = sizeof(struct iwl39_statistics_rx_phy) * 40 +
-		    sizeof(struct iwl39_statistics_rx_non_phy) * 40 + 400;
+	int bufsz = sizeof(struct iwl39_stats_rx_phy) * 40 +
+		    sizeof(struct iwl39_stats_rx_non_phy) * 40 + 400;
 	ssize_t ret;
-	struct iwl39_statistics_rx_phy *ofdm, *accum_ofdm, *delta_ofdm,
+	struct iwl39_stats_rx_phy *ofdm, *accum_ofdm, *delta_ofdm,
 					*max_ofdm;
-	struct iwl39_statistics_rx_phy *cck, *accum_cck, *delta_cck, *max_cck;
-	struct iwl39_statistics_rx_non_phy *general, *accum_general;
-	struct iwl39_statistics_rx_non_phy *delta_general, *max_general;
+	struct iwl39_stats_rx_phy *cck, *accum_cck, *delta_cck, *max_cck;
+	struct iwl39_stats_rx_non_phy *general, *accum_general;
+	struct iwl39_stats_rx_non_phy *delta_general, *max_general;
 
 	if (!il_is_alive(il))
 		return -EAGAIN;
@@ -77,23 +77,23 @@ ssize_t il3945_ucode_rx_stats_read(struct file *file,
 
 	/*
 	 * The statistic information display here is based on
-	 * the last statistics notification from uCode
+	 * the last stats notification from uCode
 	 * might not reflect the current uCode activity
 	 */
-	ofdm = &il->_3945.statistics.rx.ofdm;
-	cck = &il->_3945.statistics.rx.cck;
-	general = &il->_3945.statistics.rx.general;
-	accum_ofdm = &il->_3945.accum_statistics.rx.ofdm;
-	accum_cck = &il->_3945.accum_statistics.rx.cck;
-	accum_general = &il->_3945.accum_statistics.rx.general;
-	delta_ofdm = &il->_3945.delta_statistics.rx.ofdm;
-	delta_cck = &il->_3945.delta_statistics.rx.cck;
-	delta_general = &il->_3945.delta_statistics.rx.general;
+	ofdm = &il->_3945.stats.rx.ofdm;
+	cck = &il->_3945.stats.rx.cck;
+	general = &il->_3945.stats.rx.general;
+	accum_ofdm = &il->_3945.accum_stats.rx.ofdm;
+	accum_cck = &il->_3945.accum_stats.rx.cck;
+	accum_general = &il->_3945.accum_stats.rx.general;
+	delta_ofdm = &il->_3945.delta_stats.rx.ofdm;
+	delta_cck = &il->_3945.delta_stats.rx.cck;
+	delta_general = &il->_3945.delta_stats.rx.general;
 	max_ofdm = &il->_3945.max_delta.rx.ofdm;
 	max_cck = &il->_3945.max_delta.rx.cck;
 	max_general = &il->_3945.max_delta.rx.general;
 
-	pos += il3945_statistics_flag(il, buf, bufsz);
+	pos += il3945_stats_flag(il, buf, bufsz);
 	pos += scnprintf(buf + pos, bufsz - pos, "%-32s     current"
 			 "acumulative       delta         max\n",
 			 "Statistics_Rx - OFDM:");
@@ -332,9 +332,9 @@ ssize_t il3945_ucode_tx_stats_read(struct file *file,
 	struct il_priv *il = file->private_data;
 	int pos = 0;
 	char *buf;
-	int bufsz = (sizeof(struct iwl39_statistics_tx) * 48) + 250;
+	int bufsz = (sizeof(struct iwl39_stats_tx) * 48) + 250;
 	ssize_t ret;
-	struct iwl39_statistics_tx *tx, *accum_tx, *delta_tx, *max_tx;
+	struct iwl39_stats_tx *tx, *accum_tx, *delta_tx, *max_tx;
 
 	if (!il_is_alive(il))
 		return -EAGAIN;
@@ -347,14 +347,14 @@ ssize_t il3945_ucode_tx_stats_read(struct file *file,
 
 	/*
 	 * The statistic information display here is based on
-	 * the last statistics notification from uCode
+	 * the last stats notification from uCode
 	 * might not reflect the current uCode activity
 	 */
-	tx = &il->_3945.statistics.tx;
-	accum_tx = &il->_3945.accum_statistics.tx;
-	delta_tx = &il->_3945.delta_statistics.tx;
+	tx = &il->_3945.stats.tx;
+	accum_tx = &il->_3945.accum_stats.tx;
+	delta_tx = &il->_3945.delta_stats.tx;
 	max_tx = &il->_3945.max_delta.tx;
-	pos += il3945_statistics_flag(il, buf, bufsz);
+	pos += il3945_stats_flag(il, buf, bufsz);
 	pos += scnprintf(buf + pos, bufsz - pos, "%-32s     current"
 			 "acumulative       delta         max\n",
 			 "Statistics_Tx:");
@@ -428,12 +428,12 @@ ssize_t il3945_ucode_general_stats_read(struct file *file,
 	struct il_priv *il = file->private_data;
 	int pos = 0;
 	char *buf;
-	int bufsz = sizeof(struct iwl39_statistics_general) * 10 + 300;
+	int bufsz = sizeof(struct iwl39_stats_general) * 10 + 300;
 	ssize_t ret;
-	struct iwl39_statistics_general *general, *accum_general;
-	struct iwl39_statistics_general *delta_general, *max_general;
-	struct statistics_dbg *dbg, *accum_dbg, *delta_dbg, *max_dbg;
-	struct iwl39_statistics_div *div, *accum_div, *delta_div, *max_div;
+	struct iwl39_stats_general *general, *accum_general;
+	struct iwl39_stats_general *delta_general, *max_general;
+	struct stats_dbg *dbg, *accum_dbg, *delta_dbg, *max_dbg;
+	struct iwl39_stats_div *div, *accum_div, *delta_div, *max_div;
 
 	if (!il_is_alive(il))
 		return -EAGAIN;
@@ -446,22 +446,22 @@ ssize_t il3945_ucode_general_stats_read(struct file *file,
 
 	/*
 	 * The statistic information display here is based on
-	 * the last statistics notification from uCode
+	 * the last stats notification from uCode
 	 * might not reflect the current uCode activity
 	 */
-	general = &il->_3945.statistics.general;
-	dbg = &il->_3945.statistics.general.dbg;
-	div = &il->_3945.statistics.general.div;
-	accum_general = &il->_3945.accum_statistics.general;
-	delta_general = &il->_3945.delta_statistics.general;
+	general = &il->_3945.stats.general;
+	dbg = &il->_3945.stats.general.dbg;
+	div = &il->_3945.stats.general.div;
+	accum_general = &il->_3945.accum_stats.general;
+	delta_general = &il->_3945.delta_stats.general;
 	max_general = &il->_3945.max_delta.general;
-	accum_dbg = &il->_3945.accum_statistics.general.dbg;
-	delta_dbg = &il->_3945.delta_statistics.general.dbg;
+	accum_dbg = &il->_3945.accum_stats.general.dbg;
+	delta_dbg = &il->_3945.delta_stats.general.dbg;
 	max_dbg = &il->_3945.max_delta.general.dbg;
-	accum_div = &il->_3945.accum_statistics.general.div;
-	delta_div = &il->_3945.delta_statistics.general.div;
+	accum_div = &il->_3945.accum_stats.general.div;
+	delta_div = &il->_3945.delta_stats.general.div;
 	max_div = &il->_3945.max_delta.general.div;
-	pos += il3945_statistics_flag(il, buf, bufsz);
+	pos += il3945_stats_flag(il, buf, bufsz);
 	pos += scnprintf(buf + pos, bufsz - pos, "%-32s     current"
 			 "acumulative       delta         max\n",
 			 "Statistics_General:");
diff --git a/drivers/net/wireless/iwlegacy/iwl-3945-rs.c b/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
index 0707301..ebee6c3 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
@@ -158,7 +158,7 @@ static int il3945_rate_scale_flush_windows(struct il3945_rs_sta *rs_sta)
 	/*
 	 * For each rate, if we have collected data on that rate
 	 * and it has been more than IL_RATE_WIN_FLUSH
-	 * since we flushed, clear out the gathered statistics
+	 * since we flushed, clear out the gathered stats
 	 */
 	for (i = 0; i < IL_RATE_COUNT_3945; i++) {
 		if (!rs_sta->win[i].counter)
diff --git a/drivers/net/wireless/iwlegacy/iwl-3945.c b/drivers/net/wireless/iwlegacy/iwl-3945.c
index ad78d3f..fa4c33a 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945.c
@@ -362,7 +362,7 @@ static void il3945_rx_reply_tx(struct il_priv *il,
  *
  *****************************************************************************/
 #ifdef CONFIG_IWLEGACY_DEBUGFS
-static void il3945_accumulative_statistics(struct il_priv *il,
+static void il3945_accumulative_stats(struct il_priv *il,
 					    __le32 *stats)
 {
 	int i;
@@ -370,12 +370,12 @@ static void il3945_accumulative_statistics(struct il_priv *il,
 	u32 *accum_stats;
 	u32 *delta, *max_delta;
 
-	prev_stats = (__le32 *)&il->_3945.statistics;
-	accum_stats = (u32 *)&il->_3945.accum_statistics;
-	delta = (u32 *)&il->_3945.delta_statistics;
+	prev_stats = (__le32 *)&il->_3945.stats;
+	accum_stats = (u32 *)&il->_3945.accum_stats;
+	delta = (u32 *)&il->_3945.delta_stats;
 	max_delta = (u32 *)&il->_3945.max_delta;
 
-	for (i = sizeof(__le32); i < sizeof(struct il3945_notif_statistics);
+	for (i = sizeof(__le32); i < sizeof(struct il3945_notif_stats);
 	     i += sizeof(__le32), stats++, prev_stats++, delta++,
 	     max_delta++, accum_stats++) {
 		if (le32_to_cpu(*stats) > le32_to_cpu(*prev_stats)) {
@@ -387,30 +387,30 @@ static void il3945_accumulative_statistics(struct il_priv *il,
 		}
 	}
 
-	/* reset accumulative statistics for "no-counter" type statistics */
-	il->_3945.accum_statistics.general.temperature =
-		il->_3945.statistics.general.temperature;
-	il->_3945.accum_statistics.general.ttl_timestamp =
-		il->_3945.statistics.general.ttl_timestamp;
+	/* reset accumulative stats for "no-counter" type stats */
+	il->_3945.accum_stats.general.temperature =
+		il->_3945.stats.general.temperature;
+	il->_3945.accum_stats.general.ttl_timestamp =
+		il->_3945.stats.general.ttl_timestamp;
 }
 #endif
 
-void il3945_hw_rx_statistics(struct il_priv *il,
+void il3945_hw_rx_stats(struct il_priv *il,
 		struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 
 	D_RX("Statistics notification received (%d vs %d).\n",
-		     (int)sizeof(struct il3945_notif_statistics),
+		     (int)sizeof(struct il3945_notif_stats),
 		     le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK);
 #ifdef CONFIG_IWLEGACY_DEBUGFS
-	il3945_accumulative_statistics(il, (__le32 *)&pkt->u.raw);
+	il3945_accumulative_stats(il, (__le32 *)&pkt->u.raw);
 #endif
 
-	memcpy(&il->_3945.statistics, pkt->u.raw, sizeof(il->_3945.statistics));
+	memcpy(&il->_3945.stats, pkt->u.raw, sizeof(il->_3945.stats));
 }
 
-void il3945_reply_statistics(struct il_priv *il,
+void il3945_reply_stats(struct il_priv *il,
 			      struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
@@ -418,16 +418,16 @@ void il3945_reply_statistics(struct il_priv *il,
 
 	if (le32_to_cpu(*flag) & UCODE_STATISTICS_CLEAR_MSK) {
 #ifdef CONFIG_IWLEGACY_DEBUGFS
-		memset(&il->_3945.accum_statistics, 0,
-			sizeof(struct il3945_notif_statistics));
-		memset(&il->_3945.delta_statistics, 0,
-			sizeof(struct il3945_notif_statistics));
+		memset(&il->_3945.accum_stats, 0,
+			sizeof(struct il3945_notif_stats));
+		memset(&il->_3945.delta_stats, 0,
+			sizeof(struct il3945_notif_stats));
 		memset(&il->_3945.max_delta, 0,
-			sizeof(struct il3945_notif_statistics));
+			sizeof(struct il3945_notif_stats));
 #endif
 		D_RX("Statistics have been cleared\n");
 	}
-	il3945_hw_rx_statistics(il, rxb);
+	il3945_hw_rx_stats(il, rxb);
 }
 
 
@@ -437,7 +437,7 @@ void il3945_reply_statistics(struct il_priv *il,
  *
  ******************************************************************************/
 
-/* This is necessary only for a number of statistics, see the caller. */
+/* This is necessary only for a number of stats, see the caller. */
 static int il3945_is_network_packet(struct il_priv *il,
 		struct ieee80211_hdr *header)
 {
diff --git a/drivers/net/wireless/iwlegacy/iwl-3945.h b/drivers/net/wireless/iwlegacy/iwl-3945.h
index 8a294ca..967e733 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945.h
+++ b/drivers/net/wireless/iwlegacy/iwl-3945.h
@@ -60,7 +60,7 @@ extern const struct pci_device_id il3945_hw_card_ids[];
 
 /* Default noise level to report when noise measurement is not available.
  *   This may be because we're:
- *   1)  Not associated (4965, no beacon statistics being sent to driver)
+ *   1)  Not associated (4965, no beacon stats being sent to driver)
  *   2)  Scanning (noise measurement does not apply to associated channel)
  *   3)  Receiving CCK (3945 delivers noise info only for OFDM frames)
  * Use default noise value of -127 ... this is below the range of measurable
@@ -258,9 +258,9 @@ void il3945_hw_build_tx_cmd_rate(struct il_priv *il,
 				  int sta_id, int tx_id);
 extern int il3945_hw_reg_send_txpower(struct il_priv *il);
 extern int il3945_hw_reg_set_txpower(struct il_priv *il, s8 power);
-extern void il3945_hw_rx_statistics(struct il_priv *il,
+extern void il3945_hw_rx_stats(struct il_priv *il,
 				 struct il_rx_buf *rxb);
-void il3945_reply_statistics(struct il_priv *il,
+void il3945_reply_stats(struct il_priv *il,
 			      struct il_rx_buf *rxb);
 extern void il3945_disable_events(struct il_priv *il);
 extern int il4965_get_temperature(const struct il_priv *il);
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-calib.c b/drivers/net/wireless/iwlegacy/iwl-4965-calib.c
index 4c2b491..bb3bc15 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-calib.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-calib.c
@@ -71,7 +71,7 @@
  * INIT calibrations framework
  *****************************************************************************/
 
-struct statistics_general_data {
+struct stats_general_data {
 	u32 beacon_silence_rssi_a;
 	u32 beacon_silence_rssi_b;
 	u32 beacon_silence_rssi_c;
@@ -106,7 +106,7 @@ void il4965_calib_free_results(struct il_priv *il)
 static int il4965_sens_energy_cck(struct il_priv *il,
 				   u32 norm_fa,
 				   u32 rx_enable_time,
-				   struct statistics_general_data *rx_info)
+				   struct stats_general_data *rx_info)
 {
 	u32 max_nrg_cck = 0;
 	int i = 0;
@@ -509,10 +509,10 @@ void il4965_sensitivity_calibration(struct il_priv *il, void *resp)
 	u32 norm_fa_ofdm;
 	u32 norm_fa_cck;
 	struct il_sensitivity_data *data = NULL;
-	struct statistics_rx_non_phy *rx_info;
-	struct statistics_rx_phy *ofdm, *cck;
+	struct stats_rx_non_phy *rx_info;
+	struct stats_rx_phy *ofdm, *cck;
 	unsigned long flags;
-	struct statistics_general_data statis;
+	struct stats_general_data statis;
 
 	if (il->disable_sens_cal)
 		return;
@@ -526,9 +526,9 @@ void il4965_sensitivity_calibration(struct il_priv *il, void *resp)
 
 	spin_lock_irqsave(&il->lock, flags);
 
-	rx_info = &(((struct il_notif_statistics *)resp)->rx.general);
-	ofdm = &(((struct il_notif_statistics *)resp)->rx.ofdm);
-	cck = &(((struct il_notif_statistics *)resp)->rx.cck);
+	rx_info = &(((struct il_notif_stats *)resp)->rx.general);
+	ofdm = &(((struct il_notif_stats *)resp)->rx.ofdm);
+	cck = &(((struct il_notif_stats *)resp)->rx.cck);
 
 	if (rx_info->interference_data_flag != INTERFERENCE_DATA_AVAILABLE) {
 		D_CALIB("<< invalid data.\n");
@@ -565,9 +565,9 @@ void il4965_sensitivity_calibration(struct il_priv *il, void *resp)
 		return;
 	}
 
-	/* These statistics increase monotonically, and do not reset
+	/* These stats increase monotonically, and do not reset
 	 *   at each beacon.  Calculate difference from last value, or just
-	 *   use the new statistics value if it has reset or wrapped around. */
+	 *   use the new stats value if it has reset or wrapped around. */
 	if (data->last_bad_plcp_cnt_cck > bad_plcp_cck)
 		data->last_bad_plcp_cnt_cck = bad_plcp_cck;
 	else {
@@ -793,7 +793,7 @@ static void il4965_gain_computation(struct il_priv *il,
 
 
 /*
- * Accumulate 16 beacons of signal and noise statistics for each of
+ * Accumulate 16 beacons of signal and noise stats for each of
  *   3 receivers/antennas/rx-chains, then figure out:
  * 1)  Which antennas are connected.
  * 2)  Differential rx gain settings to balance the 3 receivers.
@@ -818,7 +818,7 @@ void il4965_chain_noise_calibration(struct il_priv *il, void *stat_resp)
 	u8 rxon_band24;
 	u8 stat_band24;
 	unsigned long flags;
-	struct statistics_rx_non_phy *rx_info;
+	struct stats_rx_non_phy *rx_info;
 
 	struct il_rxon_context *ctx = &il->ctx;
 
@@ -839,7 +839,7 @@ void il4965_chain_noise_calibration(struct il_priv *il, void *stat_resp)
 
 	spin_lock_irqsave(&il->lock, flags);
 
-	rx_info = &(((struct il_notif_statistics *)stat_resp)->
+	rx_info = &(((struct il_notif_stats *)stat_resp)->
 		      rx.general);
 
 	if (rx_info->interference_data_flag != INTERFERENCE_DATA_AVAILABLE) {
@@ -851,10 +851,10 @@ void il4965_chain_noise_calibration(struct il_priv *il, void *stat_resp)
 	rxon_band24 = !!(ctx->staging.flags & RXON_FLG_BAND_24G_MSK);
 	rxon_chnum = le16_to_cpu(ctx->staging.channel);
 
-	stat_band24 = !!(((struct il_notif_statistics *)
+	stat_band24 = !!(((struct il_notif_stats *)
 			 stat_resp)->flag &
 			 STATISTICS_REPLY_FLG_BAND_24G_MSK);
-	stat_chnum = le32_to_cpu(((struct il_notif_statistics *)
+	stat_chnum = le32_to_cpu(((struct il_notif_stats *)
 				 stat_resp)->flag) >> 16;
 
 	/* Make sure we accumulate data for just the associated channel
@@ -867,7 +867,7 @@ void il4965_chain_noise_calibration(struct il_priv *il, void *stat_resp)
 	}
 
 	/*
-	 *  Accumulate beacon statistics values across
+	 *  Accumulate beacon stats values across
 	 * "chain_noise_num_beacons"
 	 */
 	chain_noise_a = le32_to_cpu(rx_info->beacon_silence_rssi_a) &
@@ -960,7 +960,7 @@ void il4965_reset_run_time_calib(struct il_priv *il)
 		il->chain_noise_data.delta_gain_code[i] =
 				CHAIN_NOISE_DELTA_GAIN_INIT_VAL;
 
-	/* Ask for statistics now, the uCode will send notification
+	/* Ask for stats now, the uCode will send notification
 	 * periodically after association */
-	il_send_statistics_request(il, CMD_ASYNC, true);
+	il_send_stats_request(il, CMD_ASYNC, true);
 }
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-debugfs.c b/drivers/net/wireless/iwlegacy/iwl-4965-debugfs.c
index ebb71a6..89e5828 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-debugfs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-debugfs.c
@@ -33,12 +33,12 @@ static const char *fmt_table = "  %-30s %10u  %10u  %10u  %10u\n";
 static const char *fmt_header =
 	"%-32s    current  cumulative       delta         max\n";
 
-static int il4965_statistics_flag(struct il_priv *il, char *buf, int bufsz)
+static int il4965_stats_flag(struct il_priv *il, char *buf, int bufsz)
 {
 	int p = 0;
 	u32 flag;
 
-	flag = le32_to_cpu(il->_4965.statistics.flag);
+	flag = le32_to_cpu(il->_4965.stats.flag);
 
 	p += scnprintf(buf + p, bufsz - p, "Statistics Flag(0x%X):\n", flag);
 	if (flag & UCODE_STATISTICS_CLEAR_MSK)
@@ -60,15 +60,15 @@ ssize_t il4965_ucode_rx_stats_read(struct file *file, char __user *user_buf,
 	struct il_priv *il = file->private_data;
 	int pos = 0;
 	char *buf;
-	int bufsz = sizeof(struct statistics_rx_phy) * 40 +
-		    sizeof(struct statistics_rx_non_phy) * 40 +
-		    sizeof(struct statistics_rx_ht_phy) * 40 + 400;
+	int bufsz = sizeof(struct stats_rx_phy) * 40 +
+		    sizeof(struct stats_rx_non_phy) * 40 +
+		    sizeof(struct stats_rx_ht_phy) * 40 + 400;
 	ssize_t ret;
-	struct statistics_rx_phy *ofdm, *accum_ofdm, *delta_ofdm, *max_ofdm;
-	struct statistics_rx_phy *cck, *accum_cck, *delta_cck, *max_cck;
-	struct statistics_rx_non_phy *general, *accum_general;
-	struct statistics_rx_non_phy *delta_general, *max_general;
-	struct statistics_rx_ht_phy *ht, *accum_ht, *delta_ht, *max_ht;
+	struct stats_rx_phy *ofdm, *accum_ofdm, *delta_ofdm, *max_ofdm;
+	struct stats_rx_phy *cck, *accum_cck, *delta_cck, *max_cck;
+	struct stats_rx_non_phy *general, *accum_general;
+	struct stats_rx_non_phy *delta_general, *max_general;
+	struct stats_rx_ht_phy *ht, *accum_ht, *delta_ht, *max_ht;
 
 	if (!il_is_alive(il))
 		return -EAGAIN;
@@ -81,27 +81,27 @@ ssize_t il4965_ucode_rx_stats_read(struct file *file, char __user *user_buf,
 
 	/*
 	 * the statistic information display here is based on
-	 * the last statistics notification from uCode
+	 * the last stats notification from uCode
 	 * might not reflect the current uCode activity
 	 */
-	ofdm = &il->_4965.statistics.rx.ofdm;
-	cck = &il->_4965.statistics.rx.cck;
-	general = &il->_4965.statistics.rx.general;
-	ht = &il->_4965.statistics.rx.ofdm_ht;
-	accum_ofdm = &il->_4965.accum_statistics.rx.ofdm;
-	accum_cck = &il->_4965.accum_statistics.rx.cck;
-	accum_general = &il->_4965.accum_statistics.rx.general;
-	accum_ht = &il->_4965.accum_statistics.rx.ofdm_ht;
-	delta_ofdm = &il->_4965.delta_statistics.rx.ofdm;
-	delta_cck = &il->_4965.delta_statistics.rx.cck;
-	delta_general = &il->_4965.delta_statistics.rx.general;
-	delta_ht = &il->_4965.delta_statistics.rx.ofdm_ht;
+	ofdm = &il->_4965.stats.rx.ofdm;
+	cck = &il->_4965.stats.rx.cck;
+	general = &il->_4965.stats.rx.general;
+	ht = &il->_4965.stats.rx.ofdm_ht;
+	accum_ofdm = &il->_4965.accum_stats.rx.ofdm;
+	accum_cck = &il->_4965.accum_stats.rx.cck;
+	accum_general = &il->_4965.accum_stats.rx.general;
+	accum_ht = &il->_4965.accum_stats.rx.ofdm_ht;
+	delta_ofdm = &il->_4965.delta_stats.rx.ofdm;
+	delta_cck = &il->_4965.delta_stats.rx.cck;
+	delta_general = &il->_4965.delta_stats.rx.general;
+	delta_ht = &il->_4965.delta_stats.rx.ofdm_ht;
 	max_ofdm = &il->_4965.max_delta.rx.ofdm;
 	max_cck = &il->_4965.max_delta.rx.cck;
 	max_general = &il->_4965.max_delta.rx.general;
 	max_ht = &il->_4965.max_delta.rx.ofdm_ht;
 
-	pos += il4965_statistics_flag(il, buf, bufsz);
+	pos += il4965_stats_flag(il, buf, bufsz);
 	pos += scnprintf(buf + pos, bufsz - pos,
 			 fmt_header, "Statistics_Rx - OFDM:");
 	pos += scnprintf(buf + pos, bufsz - pos,
@@ -492,9 +492,9 @@ ssize_t il4965_ucode_tx_stats_read(struct file *file,
 	struct il_priv *il = file->private_data;
 	int pos = 0;
 	char *buf;
-	int bufsz = (sizeof(struct statistics_tx) * 48) + 250;
+	int bufsz = (sizeof(struct stats_tx) * 48) + 250;
 	ssize_t ret;
-	struct statistics_tx *tx, *accum_tx, *delta_tx, *max_tx;
+	struct stats_tx *tx, *accum_tx, *delta_tx, *max_tx;
 
 	if (!il_is_alive(il))
 		return -EAGAIN;
@@ -506,15 +506,15 @@ ssize_t il4965_ucode_tx_stats_read(struct file *file,
 	}
 
 	/* the statistic information display here is based on
-	  * the last statistics notification from uCode
+	  * the last stats notification from uCode
 	  * might not reflect the current uCode activity
 	  */
-	tx = &il->_4965.statistics.tx;
-	accum_tx = &il->_4965.accum_statistics.tx;
-	delta_tx = &il->_4965.delta_statistics.tx;
+	tx = &il->_4965.stats.tx;
+	accum_tx = &il->_4965.accum_stats.tx;
+	delta_tx = &il->_4965.delta_stats.tx;
 	max_tx = &il->_4965.max_delta.tx;
 
-	pos += il4965_statistics_flag(il, buf, bufsz);
+	pos += il4965_stats_flag(il, buf, bufsz);
 	pos += scnprintf(buf + pos, bufsz - pos,
 			 fmt_header, "Statistics_Tx:");
 	pos += scnprintf(buf + pos, bufsz - pos,
@@ -667,12 +667,12 @@ il4965_ucode_general_stats_read(struct file *file, char __user *user_buf,
 	struct il_priv *il = file->private_data;
 	int pos = 0;
 	char *buf;
-	int bufsz = sizeof(struct statistics_general) * 10 + 300;
+	int bufsz = sizeof(struct stats_general) * 10 + 300;
 	ssize_t ret;
-	struct statistics_general_common *general, *accum_general;
-	struct statistics_general_common *delta_general, *max_general;
-	struct statistics_dbg *dbg, *accum_dbg, *delta_dbg, *max_dbg;
-	struct statistics_div *div, *accum_div, *delta_div, *max_div;
+	struct stats_general_common *general, *accum_general;
+	struct stats_general_common *delta_general, *max_general;
+	struct stats_dbg *dbg, *accum_dbg, *delta_dbg, *max_dbg;
+	struct stats_div *div, *accum_div, *delta_div, *max_div;
 
 	if (!il_is_alive(il))
 		return -EAGAIN;
@@ -684,23 +684,23 @@ il4965_ucode_general_stats_read(struct file *file, char __user *user_buf,
 	}
 
 	/* the statistic information display here is based on
-	  * the last statistics notification from uCode
+	  * the last stats notification from uCode
 	  * might not reflect the current uCode activity
 	  */
-	general = &il->_4965.statistics.general.common;
-	dbg = &il->_4965.statistics.general.common.dbg;
-	div = &il->_4965.statistics.general.common.div;
-	accum_general = &il->_4965.accum_statistics.general.common;
-	accum_dbg = &il->_4965.accum_statistics.general.common.dbg;
-	accum_div = &il->_4965.accum_statistics.general.common.div;
-	delta_general = &il->_4965.delta_statistics.general.common;
+	general = &il->_4965.stats.general.common;
+	dbg = &il->_4965.stats.general.common.dbg;
+	div = &il->_4965.stats.general.common.div;
+	accum_general = &il->_4965.accum_stats.general.common;
+	accum_dbg = &il->_4965.accum_stats.general.common.dbg;
+	accum_div = &il->_4965.accum_stats.general.common.div;
+	delta_general = &il->_4965.delta_stats.general.common;
 	max_general = &il->_4965.max_delta.general.common;
-	delta_dbg = &il->_4965.delta_statistics.general.common.dbg;
+	delta_dbg = &il->_4965.delta_stats.general.common.dbg;
 	max_dbg = &il->_4965.max_delta.general.common.dbg;
-	delta_div = &il->_4965.delta_statistics.general.common.div;
+	delta_div = &il->_4965.delta_stats.general.common.div;
 	max_div = &il->_4965.max_delta.general.common.div;
 
-	pos += il4965_statistics_flag(il, buf, bufsz);
+	pos += il4965_stats_flag(il, buf, bufsz);
 	pos += scnprintf(buf + pos, bufsz - pos,
 			 fmt_header, "Statistics_General:");
 	pos += scnprintf(buf + pos, bufsz - pos,
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-hw.h b/drivers/net/wireless/iwlegacy/iwl-4965-hw.h
index ecebc69..21ff694 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-hw.h
@@ -119,7 +119,7 @@ static inline int il4965_hw_valid_rtc_data_addr(u32 addr)
  *
  * uCode provides all 4 values to the driver via the "initialize alive"
  * notification (see struct il4965_init_alive_resp).  After the runtime uCode
- * image loads, uCode updates the R4 value via statistics notifications
+ * image loads, uCode updates the R4 value via stats notifications
  * (see STATISTICS_NOTIFICATION), which occur after each received beacon
  * when associated, or can be requested via REPLY_STATISTICS_CMD.
  *
@@ -159,7 +159,7 @@ static inline int il4965_hw_valid_rtc_data_addr(u32 addr)
  *
  *     1) EEPROM
  *     2) "initialize" alive notification
- *     3) statistics notifications
+ *     3) stats notifications
  *
  * EEPROM data consists of:
  *
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
index 9c8cc32..e99a20c 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-rs.c
@@ -242,7 +242,7 @@ static inline u8 il4965_rs_is_valid_ant(u8 valid_antenna, u8 ant_type)
 }
 
 /*
- *	removes the old data from the statistics. All data that is older than
+ *	removes the old data from the stats. All data that is older than
  *	TID_MAX_TIME_DIFF, will be deleted.
  */
 static void
@@ -991,7 +991,7 @@ done:
  * Begin a period of staying with a selected modulation mode.
  * Set "stay_in_tbl" flag to prevent any mode switches.
  * Set frame tx success limits according to legacy vs. high-throughput,
- * and reset overall (spanning all rates) tx success history statistics.
+ * and reset overall (spanning all rates) tx success history stats.
  * These control how long we stay using same modulation mode before
  * searching for a new mode.
  */
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-rx.c b/drivers/net/wireless/iwlegacy/iwl-4965-rx.c
index 9ccec09..b322957 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-rx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-rx.c
@@ -67,13 +67,13 @@ void il4965_rx_missed_beacon_notif(struct il_priv *il,
  *   exactly when to expect beacons, therefore only when we're associated. */
 static void il4965_rx_calc_noise(struct il_priv *il)
 {
-	struct statistics_rx_non_phy *rx_info;
+	struct stats_rx_non_phy *rx_info;
 	int num_active_rx = 0;
 	int total_silence = 0;
 	int bcn_silence_a, bcn_silence_b, bcn_silence_c;
 	int last_rx_noise;
 
-	rx_info = &(il->_4965.statistics.rx.general);
+	rx_info = &(il->_4965.stats.rx.general);
 	bcn_silence_a =
 		le32_to_cpu(rx_info->beacon_silence_rssi_a) & IN_BAND_FILTER;
 	bcn_silence_b =
@@ -107,28 +107,28 @@ static void il4965_rx_calc_noise(struct il_priv *il)
 
 #ifdef CONFIG_IWLEGACY_DEBUGFS
 /*
- *  based on the assumption of all statistics counter are in DWORD
+ *  based on the assumption of all stats counter are in DWORD
  *  FIXME: This function is for debugging, do not deal with
  *  the case of counters roll-over.
  */
-static void il4965_accumulative_statistics(struct il_priv *il,
+static void il4965_accumulative_stats(struct il_priv *il,
 					__le32 *stats)
 {
 	int i, size;
 	__le32 *prev_stats;
 	u32 *accum_stats;
 	u32 *delta, *max_delta;
-	struct statistics_general_common *general, *accum_general;
-	struct statistics_tx *tx, *accum_tx;
-
-	prev_stats = (__le32 *)&il->_4965.statistics;
-	accum_stats = (u32 *)&il->_4965.accum_statistics;
-	size = sizeof(struct il_notif_statistics);
-	general = &il->_4965.statistics.general.common;
-	accum_general = &il->_4965.accum_statistics.general.common;
-	tx = &il->_4965.statistics.tx;
-	accum_tx = &il->_4965.accum_statistics.tx;
-	delta = (u32 *)&il->_4965.delta_statistics;
+	struct stats_general_common *general, *accum_general;
+	struct stats_tx *tx, *accum_tx;
+
+	prev_stats = (__le32 *)&il->_4965.stats;
+	accum_stats = (u32 *)&il->_4965.accum_stats;
+	size = sizeof(struct il_notif_stats);
+	general = &il->_4965.stats.general.common;
+	accum_general = &il->_4965.accum_stats.general.common;
+	tx = &il->_4965.stats.tx;
+	accum_tx = &il->_4965.accum_stats.tx;
+	delta = (u32 *)&il->_4965.delta_stats;
 	max_delta = (u32 *)&il->_4965.max_delta;
 
 	for (i = sizeof(__le32); i < size;
@@ -143,7 +143,7 @@ static void il4965_accumulative_statistics(struct il_priv *il,
 		}
 	}
 
-	/* reset accumulative statistics for "no-counter" type statistics */
+	/* reset accumulative stats for "no-counter" type stats */
 	accum_general->temperature = general->temperature;
 	accum_general->ttl_timestamp = general->ttl_timestamp;
 }
@@ -151,7 +151,7 @@ static void il4965_accumulative_statistics(struct il_priv *il,
 
 #define REG_RECALIB_PERIOD (60)
 
-void il4965_rx_statistics(struct il_priv *il,
+void il4965_rx_stats(struct il_priv *il,
 			      struct il_rx_buf *rxb)
 {
 	int change;
@@ -159,31 +159,31 @@ void il4965_rx_statistics(struct il_priv *il,
 
 	D_RX(
 		     "Statistics notification received (%d vs %d).\n",
-		     (int)sizeof(struct il_notif_statistics),
+		     (int)sizeof(struct il_notif_stats),
 		     le32_to_cpu(pkt->len_n_flags) &
 		     FH_RSCSR_FRAME_SIZE_MSK);
 
-	change = ((il->_4965.statistics.general.common.temperature !=
+	change = ((il->_4965.stats.general.common.temperature !=
 		   pkt->u.stats.general.common.temperature) ||
-		   ((il->_4965.statistics.flag &
+		   ((il->_4965.stats.flag &
 		   STATISTICS_REPLY_FLG_HT40_MODE_MSK) !=
 		   (pkt->u.stats.flag &
 		   STATISTICS_REPLY_FLG_HT40_MODE_MSK)));
 #ifdef CONFIG_IWLEGACY_DEBUGFS
-	il4965_accumulative_statistics(il, (__le32 *)&pkt->u.stats);
+	il4965_accumulative_stats(il, (__le32 *)&pkt->u.stats);
 #endif
 
-	/* TODO: reading some of statistics is unneeded */
-	memcpy(&il->_4965.statistics, &pkt->u.stats,
-		sizeof(il->_4965.statistics));
+	/* TODO: reading some of stats is unneeded */
+	memcpy(&il->_4965.stats, &pkt->u.stats,
+		sizeof(il->_4965.stats));
 
 	set_bit(STATUS_STATISTICS, &il->status);
 
-	/* Reschedule the statistics timer to occur in
+	/* Reschedule the stats timer to occur in
 	 * REG_RECALIB_PERIOD seconds to ensure we get a
 	 * thermal update even if the uCode doesn't give
 	 * us one */
-	mod_timer(&il->statistics_periodic, jiffies +
+	mod_timer(&il->stats_periodic, jiffies +
 		  msecs_to_jiffies(REG_RECALIB_PERIOD * 1000));
 
 	if (unlikely(!test_bit(STATUS_SCANNING, &il->status)) &&
@@ -195,21 +195,21 @@ void il4965_rx_statistics(struct il_priv *il,
 		il->cfg->ops->lib->temp_ops.temperature(il);
 }
 
-void il4965_reply_statistics(struct il_priv *il,
+void il4965_reply_stats(struct il_priv *il,
 			      struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 
 	if (le32_to_cpu(pkt->u.stats.flag) & UCODE_STATISTICS_CLEAR_MSK) {
 #ifdef CONFIG_IWLEGACY_DEBUGFS
-		memset(&il->_4965.accum_statistics, 0,
-			sizeof(struct il_notif_statistics));
-		memset(&il->_4965.delta_statistics, 0,
-			sizeof(struct il_notif_statistics));
+		memset(&il->_4965.accum_stats, 0,
+			sizeof(struct il_notif_stats));
+		memset(&il->_4965.delta_stats, 0,
+			sizeof(struct il_notif_stats));
 		memset(&il->_4965.max_delta, 0,
-			sizeof(struct il_notif_statistics));
+			sizeof(struct il_notif_stats));
 #endif
 		D_RX("Statistics have been cleared\n");
 	}
-	il4965_rx_statistics(il, rxb);
+	il4965_rx_stats(il, rxb);
 }
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965.c b/drivers/net/wireless/iwlegacy/iwl-4965.c
index 5dd963e..9cfc140 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.c
@@ -1436,9 +1436,9 @@ static void il4965_txq_update_byte_cnt_tbl(struct il_priv *il,
 
 /**
  * il4965_hw_get_temperature - return the calibrated temperature (in Kelvin)
- * @statistics: Provides the temperature reading from the uCode
+ * @stats: Provides the temperature reading from the uCode
  *
- * A return of <0 indicates bogus data in the statistics
+ * A return of <0 indicates bogus data in the stats
  */
 static int il4965_hw_get_temperature(struct il_priv *il)
 {
@@ -1448,7 +1448,7 @@ static int il4965_hw_get_temperature(struct il_priv *il)
 	u32 R4;
 
 	if (test_bit(STATUS_TEMPERATURE, &il->status) &&
-	    (il->_4965.statistics.flag &
+	    (il->_4965.stats.flag &
 			STATISTICS_REPLY_FLG_HT40_MODE_MSK)) {
 		D_TEMP("Running HT40 temperature calibration\n");
 		R1 = (s32)le32_to_cpu(il->card_alive_init.therm_r1[1]);
@@ -1466,14 +1466,14 @@ static int il4965_hw_get_temperature(struct il_priv *il)
 	/*
 	 * Temperature is only 23 bits, so sign extend out to 32.
 	 *
-	 * NOTE If we haven't received a statistics notification yet
+	 * NOTE If we haven't received a stats notification yet
 	 * with an updated temperature, use R4 provided to us in the
 	 * "initialize" ALIVE response.
 	 */
 	if (!test_bit(STATUS_TEMPERATURE, &il->status))
 		vt = sign_extend32(R4, 23);
 	else
-		vt = sign_extend32(le32_to_cpu(il->_4965.statistics.
+		vt = sign_extend32(le32_to_cpu(il->_4965.stats.
 				 general.common.temperature), 23);
 
 	D_TEMP("Calib values R[1-3]: %d %d %d R4: %d\n", R1, R2, R3, vt);
@@ -1512,7 +1512,7 @@ static int il4965_is_temp_calib_needed(struct il_priv *il)
 	int temp_diff;
 
 	if (!test_bit(STATUS_STATISTICS, &il->status)) {
-		D_TEMP("Temperature not updated -- no statistics.\n");
+		D_TEMP("Temperature not updated -- no stats.\n");
 		return 0;
 	}
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965.h b/drivers/net/wireless/iwlegacy/iwl-4965.h
index b5b27f4..a75b62c 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965.h
+++ b/drivers/net/wireless/iwlegacy/iwl-4965.h
@@ -174,9 +174,9 @@ void il4965_rx_missed_beacon_notif(struct il_priv *il,
 				struct il_rx_buf *rxb);
 bool il4965_good_plcp_health(struct il_priv *il,
 			  struct il_rx_pkt *pkt);
-void il4965_rx_statistics(struct il_priv *il,
+void il4965_rx_stats(struct il_priv *il,
 		       struct il_rx_buf *rxb);
-void il4965_reply_statistics(struct il_priv *il,
+void il4965_reply_stats(struct il_priv *il,
 			  struct il_rx_buf *rxb);
 
 /* scan */
diff --git a/drivers/net/wireless/iwlegacy/iwl-commands.h b/drivers/net/wireless/iwlegacy/iwl-commands.h
index d9873cb..ea6c0f5 100644
--- a/drivers/net/wireless/iwlegacy/iwl-commands.h
+++ b/drivers/net/wireless/iwlegacy/iwl-commands.h
@@ -2016,7 +2016,7 @@ struct il_link_qual_agg_params {
  *         good performance; higher rate is sure to have poorer success.
  *
  * 6)  Re-evaluate the rate after each tx frame.  If working with block-
- *     acknowledge, history and statistics may be calculated for the entire
+ *     acknowledge, history and stats may be calculated for the entire
  *     block (including prior history that fits within the history windows),
  *     before re-evaluation.
  *
@@ -2637,7 +2637,7 @@ struct il_scanresults_notification {
 	u8 num_probe_not_sent; /* not enough time to send */
 	__le32 tsf_low;
 	__le32 tsf_high;
-	__le32 statistics[NUMBER_OF_STATISTICS];
+	__le32 stats[NUMBER_OF_STATISTICS];
 } __packed;
 
 /*
@@ -2727,9 +2727,9 @@ struct rate_histogram {
 	} failed;
 } __packed;
 
-/* statistics command response */
+/* stats command response */
 
-struct iwl39_statistics_rx_phy {
+struct iwl39_stats_rx_phy {
 	__le32 ina_cnt;
 	__le32 fina_cnt;
 	__le32 plcp_err;
@@ -2747,7 +2747,7 @@ struct iwl39_statistics_rx_phy {
 	__le32 sent_cts_cnt;
 } __packed;
 
-struct iwl39_statistics_rx_non_phy {
+struct iwl39_stats_rx_non_phy {
 	__le32 bogus_cts;	/* CTS received when not expecting CTS */
 	__le32 bogus_ack;	/* ACK received when not expecting ACK */
 	__le32 non_bssid_frames;	/* number of frames with BSSID that
@@ -2758,13 +2758,13 @@ struct iwl39_statistics_rx_non_phy {
 					 * our serving channel */
 } __packed;
 
-struct iwl39_statistics_rx {
-	struct iwl39_statistics_rx_phy ofdm;
-	struct iwl39_statistics_rx_phy cck;
-	struct iwl39_statistics_rx_non_phy general;
+struct iwl39_stats_rx {
+	struct iwl39_stats_rx_phy ofdm;
+	struct iwl39_stats_rx_phy cck;
+	struct iwl39_stats_rx_non_phy general;
 } __packed;
 
-struct iwl39_statistics_tx {
+struct iwl39_stats_tx {
 	__le32 preamble_cnt;
 	__le32 rx_detected_cnt;
 	__le32 bt_prio_defer_cnt;
@@ -2776,31 +2776,31 @@ struct iwl39_statistics_tx {
 	__le32 actual_ack_cnt;
 } __packed;
 
-struct statistics_dbg {
+struct stats_dbg {
 	__le32 burst_check;
 	__le32 burst_count;
 	__le32 wait_for_silence_timeout_cnt;
 	__le32 reserved[3];
 } __packed;
 
-struct iwl39_statistics_div {
+struct iwl39_stats_div {
 	__le32 tx_on_a;
 	__le32 tx_on_b;
 	__le32 exec_time;
 	__le32 probe_time;
 } __packed;
 
-struct iwl39_statistics_general {
+struct iwl39_stats_general {
 	__le32 temperature;
-	struct statistics_dbg dbg;
+	struct stats_dbg dbg;
 	__le32 sleep_time;
 	__le32 slots_out;
 	__le32 slots_idle;
 	__le32 ttl_timestamp;
-	struct iwl39_statistics_div div;
+	struct iwl39_stats_div div;
 } __packed;
 
-struct statistics_rx_phy {
+struct stats_rx_phy {
 	__le32 ina_cnt;
 	__le32 fina_cnt;
 	__le32 plcp_err;
@@ -2823,7 +2823,7 @@ struct statistics_rx_phy {
 	__le32 reserved3;
 } __packed;
 
-struct statistics_rx_ht_phy {
+struct stats_rx_ht_phy {
 	__le32 plcp_err;
 	__le32 overrun_err;
 	__le32 early_overrun_err;
@@ -2838,7 +2838,7 @@ struct statistics_rx_ht_phy {
 
 #define INTERFERENCE_DATA_AVAILABLE      cpu_to_le32(1)
 
-struct statistics_rx_non_phy {
+struct stats_rx_non_phy {
 	__le32 bogus_cts;	/* CTS received when not expecting CTS */
 	__le32 bogus_ack;	/* ACK received when not expecting ACK */
 	__le32 non_bssid_frames;	/* number of frames with BSSID that
@@ -2871,28 +2871,28 @@ struct statistics_rx_non_phy {
 	__le32 beacon_energy_c;
 } __packed;
 
-struct statistics_rx {
-	struct statistics_rx_phy ofdm;
-	struct statistics_rx_phy cck;
-	struct statistics_rx_non_phy general;
-	struct statistics_rx_ht_phy ofdm_ht;
+struct stats_rx {
+	struct stats_rx_phy ofdm;
+	struct stats_rx_phy cck;
+	struct stats_rx_non_phy general;
+	struct stats_rx_ht_phy ofdm_ht;
 } __packed;
 
 /**
- * struct statistics_tx_power - current tx power
+ * struct stats_tx_power - current tx power
  *
  * @ant_a: current tx power on chain a in 1/2 dB step
  * @ant_b: current tx power on chain b in 1/2 dB step
  * @ant_c: current tx power on chain c in 1/2 dB step
  */
-struct statistics_tx_power {
+struct stats_tx_power {
 	u8 ant_a;
 	u8 ant_b;
 	u8 ant_c;
 	u8 reserved;
 } __packed;
 
-struct statistics_tx_non_phy_agg {
+struct stats_tx_non_phy_agg {
 	__le32 ba_timeout;
 	__le32 ba_reschedule_frames;
 	__le32 scd_query_agg_frame_cnt;
@@ -2905,7 +2905,7 @@ struct statistics_tx_non_phy_agg {
 	__le32 rx_ba_rsp_cnt;
 } __packed;
 
-struct statistics_tx {
+struct stats_tx {
 	__le32 preamble_cnt;
 	__le32 rx_detected_cnt;
 	__le32 bt_prio_defer_cnt;
@@ -2920,13 +2920,13 @@ struct statistics_tx {
 	__le32 burst_abort_missing_next_frame_cnt;
 	__le32 cts_timeout_collision;
 	__le32 ack_or_ba_timeout_collision;
-	struct statistics_tx_non_phy_agg agg;
+	struct stats_tx_non_phy_agg agg;
 
 	__le32 reserved1;
 } __packed;
 
 
-struct statistics_div {
+struct stats_div {
 	__le32 tx_on_a;
 	__le32 tx_on_b;
 	__le32 exec_time;
@@ -2935,14 +2935,14 @@ struct statistics_div {
 	__le32 reserved2;
 } __packed;
 
-struct statistics_general_common {
+struct stats_general_common {
 	__le32 temperature;   /* radio temperature */
-	struct statistics_dbg dbg;
+	struct stats_dbg dbg;
 	__le32 sleep_time;
 	__le32 slots_out;
 	__le32 slots_idle;
 	__le32 ttl_timestamp;
-	struct statistics_div div;
+	struct stats_div div;
 	__le32 rx_enable_counter;
 	/*
 	 * num_of_sos_states:
@@ -2952,8 +2952,8 @@ struct statistics_general_common {
 	__le32 num_of_sos_states;
 } __packed;
 
-struct statistics_general {
-	struct statistics_general_common common;
+struct stats_general {
+	struct stats_general_common common;
 	__le32 reserved2;
 	__le32 reserved3;
 } __packed;
@@ -2966,11 +2966,11 @@ struct statistics_general {
  * REPLY_STATISTICS_CMD = 0x9c,
  * all devices identical.
  *
- * This command triggers an immediate response containing uCode statistics.
+ * This command triggers an immediate response containing uCode stats.
  * The response is in the same format as STATISTICS_NOTIFICATION 0x9d, below.
  *
  * If the CLEAR_STATS configuration flag is set, uCode will clear its
- * internal copy of the statistics (counters) after issuing the response.
+ * internal copy of the stats (counters) after issuing the response.
  * This flag does not affect STATISTICS_NOTIFICATIONs after beacons (see below).
  *
  * If the DISABLE_NOTIF configuration flag is set, uCode will not issue
@@ -2979,7 +2979,7 @@ struct statistics_general {
  */
 #define IL_STATS_CONF_CLEAR_STATS cpu_to_le32(0x1)	/* see above */
 #define IL_STATS_CONF_DISABLE_NOTIF cpu_to_le32(0x2)/* see above */
-struct il_statistics_cmd {
+struct il_stats_cmd {
 	__le32 configuration_flags;	/* IL_STATS_CONF_* */
 } __packed;
 
@@ -2994,25 +2994,25 @@ struct il_statistics_cmd {
  * cleared when changing channels or when driver issues REPLY_STATISTICS_CMD
  * 0x9c with CLEAR_STATS bit set (see above).
  *
- * uCode also issues this notification during scans.  uCode clears statistics
- * appropriately so that each notification contains statistics for only the
+ * uCode also issues this notification during scans.  uCode clears stats
+ * appropriately so that each notification contains stats for only the
  * one channel that has just been scanned.
  */
 #define STATISTICS_REPLY_FLG_BAND_24G_MSK         cpu_to_le32(0x2)
 #define STATISTICS_REPLY_FLG_HT40_MODE_MSK        cpu_to_le32(0x8)
 
-struct il3945_notif_statistics {
+struct il3945_notif_stats {
 	__le32 flag;
-	struct iwl39_statistics_rx rx;
-	struct iwl39_statistics_tx tx;
-	struct iwl39_statistics_general general;
+	struct iwl39_stats_rx rx;
+	struct iwl39_stats_tx tx;
+	struct iwl39_stats_general general;
 } __packed;
 
-struct il_notif_statistics {
+struct il_notif_stats {
 	__le32 flag;
-	struct statistics_rx rx;
-	struct statistics_tx tx;
-	struct statistics_general general;
+	struct stats_rx rx;
+	struct stats_tx tx;
+	struct stats_general general;
 } __packed;
 
 /*
@@ -3078,10 +3078,10 @@ struct il_missed_beacon_notif {
  *
  * While associated, uCode delivers STATISTICS_NOTIFICATIONs after each
  * received beacon.  These provide information to the driver to analyze the
- * sensitivity.  Don't analyze statistics that come in from scanning, or any
- * other non-associated-network source.  Pertinent statistics include:
+ * sensitivity.  Don't analyze stats that come in from scanning, or any
+ * other non-associated-network source.  Pertinent stats include:
  *
- * From "general" statistics (struct statistics_rx_non_phy):
+ * From "general" stats (struct stats_rx_non_phy):
  *
  * (beacon_energy_[abc] & 0x0FF00) >> 8 (unsigned, higher value is lower level)
  *   Measure of energy of desired signal.  Used for establishing a level
@@ -3094,7 +3094,7 @@ struct il_missed_beacon_notif {
  *   uSecs of actual Rx time during beacon period (varies according to
  *   how much time was spent transmitting).
  *
- * From "cck" and "ofdm" statistics (struct statistics_rx_phy), separately:
+ * From "cck" and "ofdm" stats (struct stats_rx_phy), separately:
  *
  * false_alarm_cnt
  *   Signal locks abandoned early (before phy-level header).
@@ -3255,8 +3255,8 @@ struct il_sensitivity_cmd {
  * This command sets the relative gains of 4965 device's 3 radio receiver chains.
  *
  * After the first association, driver should accumulate signal and noise
- * statistics from the STATISTICS_NOTIFICATIONs that follow the first 20
- * beacons from the associated network (don't collect statistics that come
+ * stats from the STATISTICS_NOTIFICATIONs that follow the first 20
+ * beacons from the associated network (don't collect stats that come
  * in from scanning, or any other non-network source).
  *
  * DISCONNECTED ANTENNA:
@@ -3264,7 +3264,7 @@ struct il_sensitivity_cmd {
  * Driver should determine which antennas are actually connected, by comparing
  * average beacon signal levels for the 3 Rx chains.  Accumulate (add) the
  * following values over 20 beacons, one accumulator for each of the chains
- * a/b/c, from struct statistics_rx_non_phy:
+ * a/b/c, from struct stats_rx_non_phy:
  *
  * beacon_rssi_[abc] & 0x0FF (unsigned, units in dB)
  *
@@ -3283,7 +3283,7 @@ struct il_sensitivity_cmd {
  * to antennas, see above) for gain, by comparing the average signal levels
  * detected during the silence after each beacon (background noise).
  * Accumulate (add) the following values over 20 beacons, one accumulator for
- * each of the chains a/b/c, from struct statistics_rx_non_phy:
+ * each of the chains a/b/c, from struct stats_rx_non_phy:
  *
  * beacon_silence_rssi_[abc] & 0x0FF (unsigned, units in dB)
  *
@@ -3387,7 +3387,7 @@ struct il_rx_pkt {
 		struct il_rem_sta_resp rem_sta;
 		struct il_sleep_notification sleep_notif;
 		struct il_spectrum_resp spectrum;
-		struct il_notif_statistics stats;
+		struct il_notif_stats stats;
 		struct il_compressed_ba_resp compressed_ba;
 		struct il_missed_beacon_notif missed_beacon;
 		__le32 status;
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index 8feb2dd..475bcac 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -1187,23 +1187,23 @@ void il_send_bt_config(struct il_priv *il)
 }
 EXPORT_SYMBOL(il_send_bt_config);
 
-int il_send_statistics_request(struct il_priv *il, u8 flags, bool clear)
+int il_send_stats_request(struct il_priv *il, u8 flags, bool clear)
 {
-	struct il_statistics_cmd statistics_cmd = {
+	struct il_stats_cmd stats_cmd = {
 		.configuration_flags =
 			clear ? IL_STATS_CONF_CLEAR_STATS : 0,
 	};
 
 	if (flags & CMD_ASYNC)
 		return il_send_cmd_pdu_async(il, REPLY_STATISTICS_CMD,
-					sizeof(struct il_statistics_cmd),
-					&statistics_cmd, NULL);
+					sizeof(struct il_stats_cmd),
+					&stats_cmd, NULL);
 	else
 		return il_send_cmd_pdu(il, REPLY_STATISTICS_CMD,
-					sizeof(struct il_statistics_cmd),
-					&statistics_cmd);
+					sizeof(struct il_stats_cmd),
+					&stats_cmd);
 }
-EXPORT_SYMBOL(il_send_statistics_request);
+EXPORT_SYMBOL(il_send_stats_request);
 
 void il_rx_pm_sleep_notif(struct il_priv *il,
 			   struct il_rx_buf *rxb)
@@ -1217,7 +1217,7 @@ void il_rx_pm_sleep_notif(struct il_priv *il,
 }
 EXPORT_SYMBOL(il_rx_pm_sleep_notif);
 
-void il_rx_pm_debug_statistics_notif(struct il_priv *il,
+void il_rx_pm_debug_stats_notif(struct il_priv *il,
 				      struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
@@ -1227,7 +1227,7 @@ void il_rx_pm_debug_statistics_notif(struct il_priv *il,
 			il_get_cmd_string(pkt->hdr.cmd));
 	il_print_hex_dump(il, IL_DL_RADIO, pkt->u.raw, len);
 }
-EXPORT_SYMBOL(il_rx_pm_debug_statistics_notif);
+EXPORT_SYMBOL(il_rx_pm_debug_stats_notif);
 
 void il_rx_reply_error(struct il_priv *il,
 			struct il_rx_buf *rxb)
@@ -1614,7 +1614,7 @@ void il_clear_traffic_stats(struct il_priv *il)
  * if CONFIG_IWLEGACY_DEBUGFS defined,
  * il_update_stats function will
  * record all the MGMT, CTRL and DATA pkt for both TX and Rx pass
- * Use debugFs to display the rx/rx_statistics
+ * Use debugFs to display the rx/rx_stats
  * if CONFIG_IWLEGACY_DEBUGFS not being defined, then no MGMT and CTRL
  * information will be recorded, but DATA pkt still will be recorded
  * for the reason of il_led.c need to control the led blinking based on
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.h b/drivers/net/wireless/iwlegacy/iwl-core.h
index bc2ae06..8333761 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.h
+++ b/drivers/net/wireless/iwlegacy/iwl-core.h
@@ -371,7 +371,7 @@ static inline void il_update_stats(struct il_priv *il, bool is_tx,
  * **************************************************/
 void il_rx_pm_sleep_notif(struct il_priv *il,
 			   struct il_rx_buf *rxb);
-void il_rx_pm_debug_statistics_notif(struct il_priv *il,
+void il_rx_pm_debug_stats_notif(struct il_priv *il,
 				      struct il_rx_buf *rxb);
 void il_rx_reply_error(struct il_priv *il,
 			struct il_rx_buf *rxb);
@@ -390,7 +390,7 @@ void il_tx_cmd_complete(struct il_priv *il,
 /* Handlers */
 void il_rx_spectrum_measure_notif(struct il_priv *il,
 					  struct il_rx_buf *rxb);
-void il_recover_from_statistics(struct il_priv *il,
+void il_recover_from_stats(struct il_priv *il,
 				struct il_rx_pkt *pkt);
 void il_chswitch_done(struct il_priv *il, bool is_success);
 void il_rx_csa(struct il_priv *il, struct il_rx_buf *rxb);
@@ -596,7 +596,7 @@ static inline int il_is_ready_rf(struct il_priv *il)
 }
 
 extern void il_send_bt_config(struct il_priv *il);
-extern int il_send_statistics_request(struct il_priv *il,
+extern int il_send_stats_request(struct il_priv *il,
 				       u8 flags, bool clear);
 void il_apm_stop(struct il_priv *il);
 int il_apm_init(struct il_priv *il);
diff --git a/drivers/net/wireless/iwlegacy/iwl-debugfs.c b/drivers/net/wireless/iwlegacy/iwl-debugfs.c
index a4b1f37..e8153b0 100644
--- a/drivers/net/wireless/iwlegacy/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-debugfs.c
@@ -102,7 +102,7 @@ static const struct file_operations il_dbgfs_##name##_ops = {	\
 	.llseek = generic_file_llseek,					\
 };
 
-static ssize_t il_dbgfs_tx_statistics_read(struct file *file,
+static ssize_t il_dbgfs_tx_stats_read(struct file *file,
 						char __user *user_buf,
 						size_t count, loff_t *ppos) {
 
@@ -142,7 +142,7 @@ static ssize_t il_dbgfs_tx_statistics_read(struct file *file,
 }
 
 static ssize_t
-il_dbgfs_clear_traffic_statistics_write(struct file *file,
+il_dbgfs_clear_traffic_stats_write(struct file *file,
 					const char __user *user_buf,
 					size_t count, loff_t *ppos)
 {
@@ -162,7 +162,7 @@ il_dbgfs_clear_traffic_statistics_write(struct file *file,
 	return count;
 }
 
-static ssize_t il_dbgfs_rx_statistics_read(struct file *file,
+static ssize_t il_dbgfs_rx_stats_read(struct file *file,
 						char __user *user_buf,
 						size_t count, loff_t *ppos) {
 
@@ -1031,7 +1031,7 @@ static ssize_t il_dbgfs_power_save_status_read(struct file *file,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
-static ssize_t il_dbgfs_clear_ucode_statistics_write(struct file *file,
+static ssize_t il_dbgfs_clear_ucode_stats_write(struct file *file,
 					 const char __user *user_buf,
 					 size_t count, loff_t *ppos)
 {
@@ -1047,9 +1047,9 @@ static ssize_t il_dbgfs_clear_ucode_statistics_write(struct file *file,
 	if (sscanf(buf, "%d", &clear) != 1)
 		return -EFAULT;
 
-	/* make request to uCode to retrieve statistics information */
+	/* make request to uCode to retrieve stats information */
 	mutex_lock(&il->mutex);
-	il_send_statistics_request(il, CMD_SYNC, true);
+	il_send_stats_request(il, CMD_SYNC, true);
 	mutex_unlock(&il->mutex);
 
 	return count;
@@ -1206,8 +1206,8 @@ static ssize_t il_dbgfs_wd_timeout_write(struct file *file,
 	return count;
 }
 
-DEBUGFS_READ_FILE_OPS(rx_statistics);
-DEBUGFS_READ_FILE_OPS(tx_statistics);
+DEBUGFS_READ_FILE_OPS(rx_stats);
+DEBUGFS_READ_FILE_OPS(tx_stats);
 DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
 DEBUGFS_READ_FILE_OPS(rx_queue);
 DEBUGFS_READ_FILE_OPS(tx_queue);
@@ -1217,8 +1217,8 @@ DEBUGFS_READ_FILE_OPS(ucode_general_stats);
 DEBUGFS_READ_FILE_OPS(sensitivity);
 DEBUGFS_READ_FILE_OPS(chain_noise);
 DEBUGFS_READ_FILE_OPS(power_save_status);
-DEBUGFS_WRITE_FILE_OPS(clear_ucode_statistics);
-DEBUGFS_WRITE_FILE_OPS(clear_traffic_statistics);
+DEBUGFS_WRITE_FILE_OPS(clear_ucode_stats);
+DEBUGFS_WRITE_FILE_OPS(clear_traffic_stats);
 DEBUGFS_READ_FILE_OPS(fh_reg);
 DEBUGFS_READ_WRITE_FILE_OPS(missed_beacon);
 DEBUGFS_READ_WRITE_FILE_OPS(force_reset);
@@ -1259,14 +1259,14 @@ int il_dbgfs_register(struct il_priv *il, const char *name)
 	DEBUGFS_ADD_FILE(interrupt, dir_data, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(qos, dir_data, S_IRUSR);
 	DEBUGFS_ADD_FILE(disable_ht40, dir_data, S_IWUSR | S_IRUSR);
-	DEBUGFS_ADD_FILE(rx_statistics, dir_debug, S_IRUSR);
-	DEBUGFS_ADD_FILE(tx_statistics, dir_debug, S_IRUSR);
+	DEBUGFS_ADD_FILE(rx_stats, dir_debug, S_IRUSR);
+	DEBUGFS_ADD_FILE(tx_stats, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(traffic_log, dir_debug, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(rx_queue, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(tx_queue, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(power_save_status, dir_debug, S_IRUSR);
-	DEBUGFS_ADD_FILE(clear_ucode_statistics, dir_debug, S_IWUSR);
-	DEBUGFS_ADD_FILE(clear_traffic_statistics, dir_debug, S_IWUSR);
+	DEBUGFS_ADD_FILE(clear_ucode_stats, dir_debug, S_IWUSR);
+	DEBUGFS_ADD_FILE(clear_traffic_stats, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(fh_reg, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(missed_beacon, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(force_reset, dir_debug, S_IWUSR | S_IRUSR);
diff --git a/drivers/net/wireless/iwlegacy/iwl-dev.h b/drivers/net/wireless/iwlegacy/iwl-dev.h
index ad72d39..4388538 100644
--- a/drivers/net/wireless/iwlegacy/iwl-dev.h
+++ b/drivers/net/wireless/iwlegacy/iwl-dev.h
@@ -57,7 +57,7 @@ struct il_tx_queue;
 
 /* Default noise level to report when noise measurement is not available.
  *   This may be because we're:
- *   1)  Not associated (4965, no beacon statistics being sent to driver)
+ *   1)  Not associated (4965, no beacon stats being sent to driver)
  *   2)  Scanning (noise measurement does not apply to associated channel)
  *   3)  Receiving CCK (3945 delivers noise info only for OFDM frames)
  * Use default noise value of -127 ... this is below the range of measurable
@@ -801,8 +801,8 @@ enum {
 	MEASUREMENT_ACTIVE = (1 << 1),
 };
 
-/* interrupt statistics */
-struct isr_statistics {
+/* interrupt stats */
+struct isr_stats {
 	u32 hw;
 	u32 sw;
 	u32 err_code;
@@ -817,7 +817,7 @@ struct isr_statistics {
 	u32 unhandled;
 };
 
-/* management statistics */
+/* management stats */
 enum il_mgmt_stats {
 	MANAGEMENT_ASSOC_REQ = 0,
 	MANAGEMENT_ASSOC_RESP,
@@ -833,7 +833,7 @@ enum il_mgmt_stats {
 	MANAGEMENT_ACTION,
 	MANAGEMENT_MAX,
 };
-/* control statistics */
+/* control stats */
 enum il_ctrl_stats {
 	CONTROL_BACK_REQ =  0,
 	CONTROL_BACK,
@@ -1087,7 +1087,7 @@ struct il_priv {
 	struct traffic_stats rx_stats;
 
 	/* counts interrupts */
-	struct isr_statistics isr_stats;
+	struct isr_stats isr_stats;
 
 	struct il_power_mgr power_data;
 
@@ -1131,15 +1131,15 @@ struct il_priv {
 			struct delayed_work thermal_periodic;
 			struct delayed_work rfkill_poll;
 
-			struct il3945_notif_statistics statistics;
+			struct il3945_notif_stats stats;
 #ifdef CONFIG_IWLEGACY_DEBUGFS
-			struct il3945_notif_statistics accum_statistics;
-			struct il3945_notif_statistics delta_statistics;
-			struct il3945_notif_statistics max_delta;
+			struct il3945_notif_stats accum_stats;
+			struct il3945_notif_stats delta_stats;
+			struct il3945_notif_stats max_delta;
 #endif
 
 			u32 sta_supp_rates;
-			int last_rx_rssi;	/* From Rx packet statistics */
+			int last_rx_rssi;	/* From Rx packet stats */
 
 			/* Rx'd packet timing information */
 			u32 last_beacon_time;
@@ -1169,11 +1169,11 @@ struct il_priv {
 			u8 phy_calib_chain_noise_reset_cmd;
 			u8 phy_calib_chain_noise_gain_cmd;
 
-			struct il_notif_statistics statistics;
+			struct il_notif_stats stats;
 #ifdef CONFIG_IWLEGACY_DEBUGFS
-			struct il_notif_statistics accum_statistics;
-			struct il_notif_statistics delta_statistics;
-			struct il_notif_statistics max_delta;
+			struct il_notif_stats accum_stats;
+			struct il_notif_stats delta_stats;
+			struct il_notif_stats max_delta;
 #endif
 
 		} _4965;
@@ -1229,7 +1229,7 @@ struct il_priv {
 	u32 disable_chain_noise_cal;
 	u32 disable_tx_power_cal;
 	struct work_struct run_time_calib_work;
-	struct timer_list statistics_periodic;
+	struct timer_list stats_periodic;
 	struct timer_list watchdog;
 	bool hw_ready;
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h b/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
index f24b6b8..19fa92d 100644
--- a/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
+++ b/drivers/net/wireless/iwlegacy/iwl-legacy-rs.h
@@ -335,7 +335,7 @@ struct il_scale_tbl_info {
 };
 
 struct il_traffic_load {
-	unsigned long time_stamp;	/* age of the oldest statistics */
+	unsigned long time_stamp;	/* age of the oldest stats */
 	u32 packet_count[TID_QUEUE_MAX_SIZE];   /* packet count in this time
 						 * slice */
 	u32 total;			/* total num of packets during the
diff --git a/drivers/net/wireless/iwlegacy/iwl-scan.c b/drivers/net/wireless/iwlegacy/iwl-scan.c
index dfc1431..71b2fac 100644
--- a/drivers/net/wireless/iwlegacy/iwl-scan.c
+++ b/drivers/net/wireless/iwlegacy/iwl-scan.c
@@ -229,7 +229,7 @@ static void il_rx_scan_results_notif(struct il_priv *il,
 		       notif->band ? "bg" : "a",
 		       le32_to_cpu(notif->tsf_high),
 		       le32_to_cpu(notif->tsf_low),
-		       le32_to_cpu(notif->statistics[0]),
+		       le32_to_cpu(notif->stats[0]),
 		       le32_to_cpu(notif->tsf_low) - il->scan_start_tsf);
 #endif
 }
diff --git a/drivers/net/wireless/iwlegacy/iwl3945-base.c b/drivers/net/wireless/iwlegacy/iwl3945-base.c
index 446bdb5..c602570 100644
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
@@ -862,16 +862,16 @@ static void il3945_setup_rx_handlers(struct il_priv *il)
 			il_rx_spectrum_measure_notif;
 	il->rx_handlers[PM_SLEEP_NOTIFICATION] = il_rx_pm_sleep_notif;
 	il->rx_handlers[PM_DEBUG_STATISTIC_NOTIFIC] =
-	    il_rx_pm_debug_statistics_notif;
+	    il_rx_pm_debug_stats_notif;
 	il->rx_handlers[BEACON_NOTIFICATION] = il3945_rx_beacon_notif;
 
 	/*
 	 * The same handler is used for both the REPLY to a discrete
-	 * statistics request from the host as well as for the periodic
-	 * statistics notifications (after received beacons) from the uCode.
+	 * stats request from the host as well as for the periodic
+	 * stats notifications (after received beacons) from the uCode.
 	 */
-	il->rx_handlers[REPLY_STATISTICS_CMD] = il3945_reply_statistics;
-	il->rx_handlers[STATISTICS_NOTIFICATION] = il3945_hw_rx_statistics;
+	il->rx_handlers[REPLY_STATISTICS_CMD] = il3945_reply_stats;
+	il->rx_handlers[STATISTICS_NOTIFICATION] = il3945_hw_rx_stats;
 
 	il_setup_rx_scan_handlers(il);
 	il->rx_handlers[CARD_STATE_NOTIFICATION] = il3945_rx_card_state_notif;
diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index 81613ed..736c2f5 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -464,16 +464,16 @@ static void il4965_rx_reply_alive(struct il_priv *il,
 }
 
 /**
- * il4965_bg_statistics_periodic - Timer callback to queue statistics
+ * il4965_bg_stats_periodic - Timer callback to queue stats
  *
- * This callback is provided in order to send a statistics request.
+ * This callback is provided in order to send a stats request.
  *
  * This timer function is continually reset to execute within
  * REG_RECALIB_PERIOD seconds since the last STATISTICS_NOTIFICATION
- * was received.  We need to ensure we receive the statistics in order
+ * was received.  We need to ensure we receive the stats in order
  * to update the temperature used for calibrating the TXPOWER.
  */
-static void il4965_bg_statistics_periodic(unsigned long data)
+static void il4965_bg_stats_periodic(unsigned long data)
 {
 	struct il_priv *il = (struct il_priv *)data;
 
@@ -484,7 +484,7 @@ static void il4965_bg_statistics_periodic(unsigned long data)
 	if (!il_is_ready_rf(il))
 		return;
 
-	il_send_statistics_request(il, CMD_ASYNC, false);
+	il_send_stats_request(il, CMD_ASYNC, false);
 }
 
 static void il4965_rx_beacon_notif(struct il_priv *il,
@@ -596,16 +596,16 @@ static void il4965_setup_rx_handlers(struct il_priv *il)
 			il_rx_spectrum_measure_notif;
 	il->rx_handlers[PM_SLEEP_NOTIFICATION] = il_rx_pm_sleep_notif;
 	il->rx_handlers[PM_DEBUG_STATISTIC_NOTIFIC] =
-	    il_rx_pm_debug_statistics_notif;
+	    il_rx_pm_debug_stats_notif;
 	il->rx_handlers[BEACON_NOTIFICATION] = il4965_rx_beacon_notif;
 
 	/*
 	 * The same handler is used for both the REPLY to a discrete
-	 * statistics request from the host as well as for the periodic
-	 * statistics notifications (after received beacons) from the uCode.
+	 * stats request from the host as well as for the periodic
+	 * stats notifications (after received beacons) from the uCode.
 	 */
-	il->rx_handlers[REPLY_STATISTICS_CMD] = il4965_reply_statistics;
-	il->rx_handlers[STATISTICS_NOTIFICATION] = il4965_rx_statistics;
+	il->rx_handlers[REPLY_STATISTICS_CMD] = il4965_reply_stats;
+	il->rx_handlers[STATISTICS_NOTIFICATION] = il4965_rx_stats;
 
 	il_setup_rx_scan_handlers(il);
 
@@ -2105,9 +2105,9 @@ static void il4965_bg_run_time_calib_work(struct work_struct *work)
 
 	if (il->start_calib) {
 		il4965_chain_noise_calibration(il,
-				(void *)&il->_4965.statistics);
+				(void *)&il->_4965.stats);
 		il4965_sensitivity_calibration(il,
-				(void *)&il->_4965.statistics);
+				(void *)&il->_4965.stats);
 	}
 
 	mutex_unlock(&il->mutex);
@@ -2647,7 +2647,7 @@ static void il4965_bg_txpower_work(struct work_struct *work)
 	mutex_lock(&il->mutex);
 
 	/* If a scan happened to start before we got here
-	 * then just return; the statistics notification will
+	 * then just return; the stats notification will
 	 * kick off another scheduled work to compensate for
 	 * any temperature delta we missed here. */
 	if (test_bit(STATUS_EXIT_PENDING, &il->status) ||
@@ -2682,9 +2682,9 @@ static void il4965_setup_deferred_work(struct il_priv *il)
 
 	INIT_WORK(&il->txpower_work, il4965_bg_txpower_work);
 
-	init_timer(&il->statistics_periodic);
-	il->statistics_periodic.data = (unsigned long)il;
-	il->statistics_periodic.function = il4965_bg_statistics_periodic;
+	init_timer(&il->stats_periodic);
+	il->stats_periodic.data = (unsigned long)il;
+	il->stats_periodic.function = il4965_bg_stats_periodic;
 
 	init_timer(&il->watchdog);
 	il->watchdog.data = (unsigned long)il;
@@ -2703,7 +2703,7 @@ static void il4965_cancel_deferred_work(struct il_priv *il)
 
 	il_cancel_scan_deferred_work(il);
 
-	del_timer_sync(&il->statistics_periodic);
+	del_timer_sync(&il->stats_periodic);
 }
 
 static void il4965_init_hw_rates(struct il_priv *il,
-- 
1.7.1

