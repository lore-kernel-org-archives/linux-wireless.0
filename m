Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:59381 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758183Ab0FUSGr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 14:06:47 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/9] iwlwifi: move agn specific rx related code to iwl-agn-rx.c
Date: Mon, 21 Jun 2010 11:06:36 -0700
Message-Id: <1277143600-32554-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1277143600-32554-1-git-send-email-reinette.chatre@intel.com>
References: <1277143600-32554-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

To avoid having unnecessary functions in iwlcore.ko, those that
are not shared by agn and 3945, move agn specific rx related code
to iwl-agn-rx.c.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c |  278 +++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h    |   10 +
 drivers/net/wireless/iwlwifi/iwl-core.h   |    8 -
 drivers/net/wireless/iwlwifi/iwl-rx.c     |  238 ------------------------
 5 files changed, 289 insertions(+), 247 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-rx.c

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 7c72353..9084c52 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -11,7 +11,7 @@ CFLAGS_iwl-devtrace.o := -I$(src)
 obj-$(CONFIG_IWLAGN)	+= iwlagn.o
 iwlagn-objs		:= iwl-agn.o iwl-agn-rs.o iwl-agn-led.o iwl-agn-ict.o
 iwlagn-objs		+= iwl-agn-ucode.o iwl-agn-hcmd.o iwl-agn-tx.o
-iwlagn-objs		+= iwl-agn-lib.o
+iwlagn-objs		+= iwl-agn-lib.o iwl-agn-rx.o
 iwlagn-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-agn-debugfs.o
 
 iwlagn-$(CONFIG_IWL4965) += iwl-4965.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
new file mode 100644
index 0000000..20343b1
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -0,0 +1,278 @@
+/******************************************************************************
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ *****************************************************************************/
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/sched.h>
+
+#include "iwl-dev.h"
+#include "iwl-core.h"
+#include "iwl-calib.h"
+#include "iwl-sta.h"
+#include "iwl-io.h"
+#include "iwl-helpers.h"
+#include "iwl-agn-hw.h"
+#include "iwl-agn.h"
+
+void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
+				struct iwl_rx_mem_buffer *rxb)
+
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_missed_beacon_notif *missed_beacon;
+
+	missed_beacon = &pkt->u.missed_beacon;
+	if (le32_to_cpu(missed_beacon->consecutive_missed_beacons) >
+	    priv->missed_beacon_threshold) {
+		IWL_DEBUG_CALIB(priv,
+		    "missed bcn cnsq %d totl %d rcd %d expctd %d\n",
+		    le32_to_cpu(missed_beacon->consecutive_missed_beacons),
+		    le32_to_cpu(missed_beacon->total_missed_becons),
+		    le32_to_cpu(missed_beacon->num_recvd_beacons),
+		    le32_to_cpu(missed_beacon->num_expected_beacons));
+		if (!test_bit(STATUS_SCANNING, &priv->status))
+			iwl_init_sensitivity(priv);
+	}
+}
+
+/* Calculate noise level, based on measurements during network silence just
+ *   before arriving beacon.  This measurement can be done only if we know
+ *   exactly when to expect beacons, therefore only when we're associated. */
+static void iwl_rx_calc_noise(struct iwl_priv *priv)
+{
+	struct statistics_rx_non_phy *rx_info
+				= &(priv->statistics.rx.general);
+	int num_active_rx = 0;
+	int total_silence = 0;
+	int bcn_silence_a =
+		le32_to_cpu(rx_info->beacon_silence_rssi_a) & IN_BAND_FILTER;
+	int bcn_silence_b =
+		le32_to_cpu(rx_info->beacon_silence_rssi_b) & IN_BAND_FILTER;
+	int bcn_silence_c =
+		le32_to_cpu(rx_info->beacon_silence_rssi_c) & IN_BAND_FILTER;
+	int last_rx_noise;
+
+	if (bcn_silence_a) {
+		total_silence += bcn_silence_a;
+		num_active_rx++;
+	}
+	if (bcn_silence_b) {
+		total_silence += bcn_silence_b;
+		num_active_rx++;
+	}
+	if (bcn_silence_c) {
+		total_silence += bcn_silence_c;
+		num_active_rx++;
+	}
+
+	/* Average among active antennas */
+	if (num_active_rx)
+		last_rx_noise = (total_silence / num_active_rx) - 107;
+	else
+		last_rx_noise = IWL_NOISE_MEAS_NOT_AVAILABLE;
+
+	IWL_DEBUG_CALIB(priv, "inband silence a %u, b %u, c %u, dBm %d\n",
+			bcn_silence_a, bcn_silence_b, bcn_silence_c,
+			last_rx_noise);
+}
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+/*
+ *  based on the assumption of all statistics counter are in DWORD
+ *  FIXME: This function is for debugging, do not deal with
+ *  the case of counters roll-over.
+ */
+static void iwl_accumulative_statistics(struct iwl_priv *priv,
+					__le32 *stats)
+{
+	int i;
+	__le32 *prev_stats;
+	u32 *accum_stats;
+	u32 *delta, *max_delta;
+
+	prev_stats = (__le32 *)&priv->statistics;
+	accum_stats = (u32 *)&priv->accum_statistics;
+	delta = (u32 *)&priv->delta_statistics;
+	max_delta = (u32 *)&priv->max_delta;
+
+	for (i = sizeof(__le32); i < sizeof(struct iwl_notif_statistics);
+	     i += sizeof(__le32), stats++, prev_stats++, delta++,
+	     max_delta++, accum_stats++) {
+		if (le32_to_cpu(*stats) > le32_to_cpu(*prev_stats)) {
+			*delta = (le32_to_cpu(*stats) -
+				le32_to_cpu(*prev_stats));
+			*accum_stats += *delta;
+			if (*delta > *max_delta)
+				*max_delta = *delta;
+		}
+	}
+
+	/* reset accumulative statistics for "no-counter" type statistics */
+	priv->accum_statistics.general.temperature =
+		priv->statistics.general.temperature;
+	priv->accum_statistics.general.temperature_m =
+		priv->statistics.general.temperature_m;
+	priv->accum_statistics.general.ttl_timestamp =
+		priv->statistics.general.ttl_timestamp;
+	priv->accum_statistics.tx.tx_power.ant_a =
+		priv->statistics.tx.tx_power.ant_a;
+	priv->accum_statistics.tx.tx_power.ant_b =
+		priv->statistics.tx.tx_power.ant_b;
+	priv->accum_statistics.tx.tx_power.ant_c =
+		priv->statistics.tx.tx_power.ant_c;
+}
+#endif
+
+#define REG_RECALIB_PERIOD (60)
+
+/**
+ * iwl_good_plcp_health - checks for plcp error.
+ *
+ * When the plcp error is exceeding the thresholds, reset the radio
+ * to improve the throughput.
+ */
+bool iwl_good_plcp_health(struct iwl_priv *priv,
+				struct iwl_rx_packet *pkt)
+{
+	bool rc = true;
+	int combined_plcp_delta;
+	unsigned int plcp_msec;
+	unsigned long plcp_received_jiffies;
+
+	/*
+	 * check for plcp_err and trigger radio reset if it exceeds
+	 * the plcp error threshold plcp_delta.
+	 */
+	plcp_received_jiffies = jiffies;
+	plcp_msec = jiffies_to_msecs((long) plcp_received_jiffies -
+					(long) priv->plcp_jiffies);
+	priv->plcp_jiffies = plcp_received_jiffies;
+	/*
+	 * check to make sure plcp_msec is not 0 to prevent division
+	 * by zero.
+	 */
+	if (plcp_msec) {
+		combined_plcp_delta =
+			(le32_to_cpu(pkt->u.stats.rx.ofdm.plcp_err) -
+			le32_to_cpu(priv->statistics.rx.ofdm.plcp_err)) +
+			(le32_to_cpu(pkt->u.stats.rx.ofdm_ht.plcp_err) -
+			le32_to_cpu(priv->statistics.rx.ofdm_ht.plcp_err));
+
+		if ((combined_plcp_delta > 0) &&
+		    ((combined_plcp_delta * 100) / plcp_msec) >
+			priv->cfg->plcp_delta_threshold) {
+			/*
+			 * if plcp_err exceed the threshold,
+			 * the following data is printed in csv format:
+			 *    Text: plcp_err exceeded %d,
+			 *    Received ofdm.plcp_err,
+			 *    Current ofdm.plcp_err,
+			 *    Received ofdm_ht.plcp_err,
+			 *    Current ofdm_ht.plcp_err,
+			 *    combined_plcp_delta,
+			 *    plcp_msec
+			 */
+			IWL_DEBUG_RADIO(priv, "plcp_err exceeded %u, "
+				"%u, %u, %u, %u, %d, %u mSecs\n",
+				priv->cfg->plcp_delta_threshold,
+				le32_to_cpu(pkt->u.stats.rx.ofdm.plcp_err),
+				le32_to_cpu(
+				       priv->statistics.rx.ofdm.plcp_err),
+				le32_to_cpu(pkt->u.stats.rx.ofdm_ht.plcp_err),
+				le32_to_cpu(
+				  priv->statistics.rx.ofdm_ht.plcp_err),
+				combined_plcp_delta, plcp_msec);
+			rc = false;
+		}
+	}
+	return rc;
+}
+
+void iwl_rx_statistics(struct iwl_priv *priv,
+			      struct iwl_rx_mem_buffer *rxb)
+{
+	int change;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+
+
+	IWL_DEBUG_RX(priv, "Statistics notification received (%d vs %d).\n",
+		     (int)sizeof(priv->statistics),
+		     le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK);
+
+	change = ((priv->statistics.general.temperature !=
+		   pkt->u.stats.general.temperature) ||
+		  ((priv->statistics.flag &
+		    STATISTICS_REPLY_FLG_HT40_MODE_MSK) !=
+		   (pkt->u.stats.flag & STATISTICS_REPLY_FLG_HT40_MODE_MSK)));
+
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	iwl_accumulative_statistics(priv, (__le32 *)&pkt->u.stats);
+#endif
+	iwl_recover_from_statistics(priv, pkt);
+
+	memcpy(&priv->statistics, &pkt->u.stats,
+	       sizeof(priv->statistics));
+
+	set_bit(STATUS_STATISTICS, &priv->status);
+
+	/* Reschedule the statistics timer to occur in
+	 * REG_RECALIB_PERIOD seconds to ensure we get a
+	 * thermal update even if the uCode doesn't give
+	 * us one */
+	mod_timer(&priv->statistics_periodic, jiffies +
+		  msecs_to_jiffies(REG_RECALIB_PERIOD * 1000));
+
+	if (unlikely(!test_bit(STATUS_SCANNING, &priv->status)) &&
+	    (pkt->hdr.cmd == STATISTICS_NOTIFICATION)) {
+		iwl_rx_calc_noise(priv);
+		queue_work(priv->workqueue, &priv->run_time_calib_work);
+	}
+	if (priv->cfg->ops->lib->temp_ops.temperature && change)
+		priv->cfg->ops->lib->temp_ops.temperature(priv);
+}
+
+void iwl_reply_statistics(struct iwl_priv *priv,
+			      struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+
+	if (le32_to_cpu(pkt->u.stats.flag) & UCODE_STATISTICS_CLEAR_MSK) {
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+		memset(&priv->accum_statistics, 0,
+			sizeof(struct iwl_notif_statistics));
+		memset(&priv->delta_statistics, 0,
+			sizeof(struct iwl_notif_statistics));
+		memset(&priv->max_delta, 0,
+			sizeof(struct iwl_notif_statistics));
+#endif
+		IWL_DEBUG_RX(priv, "Statistics have been cleared\n");
+	}
+	iwl_rx_statistics(priv, rxb);
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 5c32777..be9d298 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -201,6 +201,16 @@ static inline bool iwl_is_tx_success(u32 status)
 	       (status == TX_STATUS_DIRECT_DONE);
 }
 
+/* rx */
+void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
+				struct iwl_rx_mem_buffer *rxb);
+bool iwl_good_plcp_health(struct iwl_priv *priv,
+			  struct iwl_rx_packet *pkt);
+void iwl_rx_statistics(struct iwl_priv *priv,
+		       struct iwl_rx_mem_buffer *rxb);
+void iwl_reply_statistics(struct iwl_priv *priv,
+			  struct iwl_rx_mem_buffer *rxb);
+
 /* scan */
 void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 76288c5..1c09dc8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -455,20 +455,12 @@ void iwl_rx_queue_update_write_ptr(struct iwl_priv *priv,
 int iwl_rx_queue_space(const struct iwl_rx_queue *q);
 void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
 /* Handlers */
-void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
-			       struct iwl_rx_mem_buffer *rxb);
 void iwl_rx_spectrum_measure_notif(struct iwl_priv *priv,
 					  struct iwl_rx_mem_buffer *rxb);
-bool iwl_good_plcp_health(struct iwl_priv *priv,
-				 struct iwl_rx_packet *pkt);
 bool iwl_good_ack_health(struct iwl_priv *priv,
 				 struct iwl_rx_packet *pkt);
 void iwl_recover_from_statistics(struct iwl_priv *priv,
 				struct iwl_rx_packet *pkt);
-void iwl_rx_statistics(struct iwl_priv *priv,
-			      struct iwl_rx_mem_buffer *rxb);
-void iwl_reply_statistics(struct iwl_priv *priv,
-			  struct iwl_rx_mem_buffer *rxb);
 void iwl_chswitch_done(struct iwl_priv *priv, bool is_success);
 void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 86a3537..b437f31 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -205,26 +205,6 @@ err_bd:
 }
 EXPORT_SYMBOL(iwl_rx_queue_alloc);
 
-void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
-				struct iwl_rx_mem_buffer *rxb)
-
-{
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_missed_beacon_notif *missed_beacon;
-
-	missed_beacon = &pkt->u.missed_beacon;
-	if (le32_to_cpu(missed_beacon->consecutive_missed_beacons) >
-	    priv->missed_beacon_threshold) {
-		IWL_DEBUG_CALIB(priv, "missed bcn cnsq %d totl %d rcd %d expctd %d\n",
-		    le32_to_cpu(missed_beacon->consecutive_missed_beacons),
-		    le32_to_cpu(missed_beacon->total_missed_becons),
-		    le32_to_cpu(missed_beacon->num_recvd_beacons),
-		    le32_to_cpu(missed_beacon->num_expected_beacons));
-		if (!test_bit(STATUS_SCANNING, &priv->status))
-			iwl_init_sensitivity(priv);
-	}
-}
-EXPORT_SYMBOL(iwl_rx_missed_beacon_notif);
 
 void iwl_rx_spectrum_measure_notif(struct iwl_priv *priv,
 					  struct iwl_rx_mem_buffer *rxb)
@@ -243,161 +223,6 @@ void iwl_rx_spectrum_measure_notif(struct iwl_priv *priv,
 }
 EXPORT_SYMBOL(iwl_rx_spectrum_measure_notif);
 
-
-
-/* Calculate noise level, based on measurements during network silence just
- *   before arriving beacon.  This measurement can be done only if we know
- *   exactly when to expect beacons, therefore only when we're associated. */
-static void iwl_rx_calc_noise(struct iwl_priv *priv)
-{
-	struct statistics_rx_non_phy *rx_info
-				= &(priv->statistics.rx.general);
-	int num_active_rx = 0;
-	int total_silence = 0;
-	int bcn_silence_a =
-		le32_to_cpu(rx_info->beacon_silence_rssi_a) & IN_BAND_FILTER;
-	int bcn_silence_b =
-		le32_to_cpu(rx_info->beacon_silence_rssi_b) & IN_BAND_FILTER;
-	int bcn_silence_c =
-		le32_to_cpu(rx_info->beacon_silence_rssi_c) & IN_BAND_FILTER;
-	int last_rx_noise;
-
-	if (bcn_silence_a) {
-		total_silence += bcn_silence_a;
-		num_active_rx++;
-	}
-	if (bcn_silence_b) {
-		total_silence += bcn_silence_b;
-		num_active_rx++;
-	}
-	if (bcn_silence_c) {
-		total_silence += bcn_silence_c;
-		num_active_rx++;
-	}
-
-	/* Average among active antennas */
-	if (num_active_rx)
-		last_rx_noise = (total_silence / num_active_rx) - 107;
-	else
-		last_rx_noise = IWL_NOISE_MEAS_NOT_AVAILABLE;
-
-	IWL_DEBUG_CALIB(priv, "inband silence a %u, b %u, c %u, dBm %d\n",
-			bcn_silence_a, bcn_silence_b, bcn_silence_c,
-			last_rx_noise);
-}
-
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-/*
- *  based on the assumption of all statistics counter are in DWORD
- *  FIXME: This function is for debugging, do not deal with
- *  the case of counters roll-over.
- */
-static void iwl_accumulative_statistics(struct iwl_priv *priv,
-					__le32 *stats)
-{
-	int i;
-	__le32 *prev_stats;
-	u32 *accum_stats;
-	u32 *delta, *max_delta;
-
-	prev_stats = (__le32 *)&priv->statistics;
-	accum_stats = (u32 *)&priv->accum_statistics;
-	delta = (u32 *)&priv->delta_statistics;
-	max_delta = (u32 *)&priv->max_delta;
-
-	for (i = sizeof(__le32); i < sizeof(struct iwl_notif_statistics);
-	     i += sizeof(__le32), stats++, prev_stats++, delta++,
-	     max_delta++, accum_stats++) {
-		if (le32_to_cpu(*stats) > le32_to_cpu(*prev_stats)) {
-			*delta = (le32_to_cpu(*stats) -
-				le32_to_cpu(*prev_stats));
-			*accum_stats += *delta;
-			if (*delta > *max_delta)
-				*max_delta = *delta;
-		}
-	}
-
-	/* reset accumulative statistics for "no-counter" type statistics */
-	priv->accum_statistics.general.temperature =
-		priv->statistics.general.temperature;
-	priv->accum_statistics.general.temperature_m =
-		priv->statistics.general.temperature_m;
-	priv->accum_statistics.general.ttl_timestamp =
-		priv->statistics.general.ttl_timestamp;
-	priv->accum_statistics.tx.tx_power.ant_a =
-		priv->statistics.tx.tx_power.ant_a;
-	priv->accum_statistics.tx.tx_power.ant_b =
-		priv->statistics.tx.tx_power.ant_b;
-	priv->accum_statistics.tx.tx_power.ant_c =
-		priv->statistics.tx.tx_power.ant_c;
-}
-#endif
-
-#define REG_RECALIB_PERIOD (60)
-
-/**
- * iwl_good_plcp_health - checks for plcp error.
- *
- * When the plcp error is exceeding the thresholds, reset the radio
- * to improve the throughput.
- */
-bool iwl_good_plcp_health(struct iwl_priv *priv,
-				struct iwl_rx_packet *pkt)
-{
-	bool rc = true;
-	int combined_plcp_delta;
-	unsigned int plcp_msec;
-	unsigned long plcp_received_jiffies;
-
-	/*
-	 * check for plcp_err and trigger radio reset if it exceeds
-	 * the plcp error threshold plcp_delta.
-	 */
-	plcp_received_jiffies = jiffies;
-	plcp_msec = jiffies_to_msecs((long) plcp_received_jiffies -
-					(long) priv->plcp_jiffies);
-	priv->plcp_jiffies = plcp_received_jiffies;
-	/*
-	 * check to make sure plcp_msec is not 0 to prevent division
-	 * by zero.
-	 */
-	if (plcp_msec) {
-		combined_plcp_delta =
-			(le32_to_cpu(pkt->u.stats.rx.ofdm.plcp_err) -
-			le32_to_cpu(priv->statistics.rx.ofdm.plcp_err)) +
-			(le32_to_cpu(pkt->u.stats.rx.ofdm_ht.plcp_err) -
-			le32_to_cpu(priv->statistics.rx.ofdm_ht.plcp_err));
-
-		if ((combined_plcp_delta > 0) &&
-		    ((combined_plcp_delta * 100) / plcp_msec) >
-			priv->cfg->plcp_delta_threshold) {
-			/*
-			 * if plcp_err exceed the threshold,
-			 * the following data is printed in csv format:
-			 *    Text: plcp_err exceeded %d,
-			 *    Received ofdm.plcp_err,
-			 *    Current ofdm.plcp_err,
-			 *    Received ofdm_ht.plcp_err,
-			 *    Current ofdm_ht.plcp_err,
-			 *    combined_plcp_delta,
-			 *    plcp_msec
-			 */
-			IWL_DEBUG_RADIO(priv, "plcp_err exceeded %u, "
-				"%u, %u, %u, %u, %d, %u mSecs\n",
-				priv->cfg->plcp_delta_threshold,
-				le32_to_cpu(pkt->u.stats.rx.ofdm.plcp_err),
-				le32_to_cpu(priv->statistics.rx.ofdm.plcp_err),
-				le32_to_cpu(pkt->u.stats.rx.ofdm_ht.plcp_err),
-				le32_to_cpu(
-				  priv->statistics.rx.ofdm_ht.plcp_err),
-				combined_plcp_delta, plcp_msec);
-			rc = false;
-		}
-	}
-	return rc;
-}
-EXPORT_SYMBOL(iwl_good_plcp_health);
-
 void iwl_recover_from_statistics(struct iwl_priv *priv,
 				struct iwl_rx_packet *pkt)
 {
@@ -431,69 +256,6 @@ void iwl_recover_from_statistics(struct iwl_priv *priv,
 }
 EXPORT_SYMBOL(iwl_recover_from_statistics);
 
-void iwl_rx_statistics(struct iwl_priv *priv,
-			      struct iwl_rx_mem_buffer *rxb)
-{
-	int change;
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-
-
-	IWL_DEBUG_RX(priv, "Statistics notification received (%d vs %d).\n",
-		     (int)sizeof(priv->statistics),
-		     le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK);
-
-	change = ((priv->statistics.general.temperature !=
-		   pkt->u.stats.general.temperature) ||
-		  ((priv->statistics.flag &
-		    STATISTICS_REPLY_FLG_HT40_MODE_MSK) !=
-		   (pkt->u.stats.flag & STATISTICS_REPLY_FLG_HT40_MODE_MSK)));
-
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-	iwl_accumulative_statistics(priv, (__le32 *)&pkt->u.stats);
-#endif
-	iwl_recover_from_statistics(priv, pkt);
-
-	memcpy(&priv->statistics, &pkt->u.stats, sizeof(priv->statistics));
-
-	set_bit(STATUS_STATISTICS, &priv->status);
-
-	/* Reschedule the statistics timer to occur in
-	 * REG_RECALIB_PERIOD seconds to ensure we get a
-	 * thermal update even if the uCode doesn't give
-	 * us one */
-	mod_timer(&priv->statistics_periodic, jiffies +
-		  msecs_to_jiffies(REG_RECALIB_PERIOD * 1000));
-
-	if (unlikely(!test_bit(STATUS_SCANNING, &priv->status)) &&
-	    (pkt->hdr.cmd == STATISTICS_NOTIFICATION)) {
-		iwl_rx_calc_noise(priv);
-		queue_work(priv->workqueue, &priv->run_time_calib_work);
-	}
-	if (priv->cfg->ops->lib->temp_ops.temperature && change)
-		priv->cfg->ops->lib->temp_ops.temperature(priv);
-}
-EXPORT_SYMBOL(iwl_rx_statistics);
-
-void iwl_reply_statistics(struct iwl_priv *priv,
-			      struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-
-	if (le32_to_cpu(pkt->u.stats.flag) & UCODE_STATISTICS_CLEAR_MSK) {
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-		memset(&priv->accum_statistics, 0,
-			sizeof(struct iwl_notif_statistics));
-		memset(&priv->delta_statistics, 0,
-			sizeof(struct iwl_notif_statistics));
-		memset(&priv->max_delta, 0,
-			sizeof(struct iwl_notif_statistics));
-#endif
-		IWL_DEBUG_RX(priv, "Statistics have been cleared\n");
-	}
-	iwl_rx_statistics(priv, rxb);
-}
-EXPORT_SYMBOL(iwl_reply_statistics);
-
 /*
  * returns non-zero if packet should be dropped
  */
-- 
1.7.0.4

