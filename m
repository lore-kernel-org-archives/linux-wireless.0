Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:44159 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760889Ab2FHGbK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 02:31:10 -0400
Received: by lagz14 with SMTP id z14so922131lag.7
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 23:31:07 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Ido Reis <idor@ti.com>
Subject: [PATCH 2/5] wl18xx: update fw statistics
Date: Fri,  8 Jun 2012 09:30:52 +0300
Message-Id: <1339137055-30095-3-git-send-email-coelho@ti.com> (sfid-20120608_083123_239079_CCD31491)
In-Reply-To: <1339137055-30095-1-git-send-email-coelho@ti.com>
References: <1339137055-30095-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Reis <idor@ti.com>

Aligned to the struct in FW 8.2.0.0.91 and updated the debugfs entries
accordingly.

Signed-off-by: Ido Reis <idor@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl18xx/acx.h     |   33 ++++++++++++++----
 drivers/net/wireless/ti/wl18xx/debugfs.c |   56 ++++++++++++++++++++----------
 2 files changed, 65 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/acx.h b/drivers/net/wireless/ti/wl18xx/acx.h
index 3e5cd9f..8a6fed3 100644
--- a/drivers/net/wireless/ti/wl18xx/acx.h
+++ b/drivers/net/wireless/ti/wl18xx/acx.h
@@ -85,6 +85,15 @@ struct wl18xx_acx_checksum_state {
 	u8 pad[3];
 } __packed;
 
+
+struct wl18xx_acx_error_stats {
+	u32 error_frame;
+	u32 error_null_Frame_tx_start;
+	u32 error_numll_frame_cts_start;
+	u32 error_bar_retry;
+	u32 error_frame_cts_nul_flid;
+} __packed;
+
 struct wl18xx_acx_debug_stats {
 	u32 debug1;
 	u32 debug2;
@@ -100,6 +109,8 @@ struct wl18xx_acx_ring_stats {
 } __packed;
 
 struct wl18xx_acx_tx_stats {
+	u32 tx_prepared_descs;
+	u32 tx_cmplt;
 	u32 tx_template_prepared;
 	u32 tx_data_prepared;
 	u32 tx_template_programmed;
@@ -136,7 +147,8 @@ struct wl18xx_acx_tx_stats {
 } __packed;
 
 struct wl18xx_acx_rx_stats {
-	u32 rx_out_of_mem;
+        u32 rx_beacon_early_term;
+        u32 rx_out_of_mpdu_nodes;
 	u32 rx_hdr_overflow;
 	u32 rx_dropped_frame;
 	u32 rx_done_stage;
@@ -148,6 +160,9 @@ struct wl18xx_acx_rx_stats {
 	u32 rx_cmplt_task;
 	u32 rx_phy_hdr;
 	u32 rx_timeout;
+	u32 rx_timeout_wa;
+	u32 rx_wa_density_dropped_frame;
+	u32 rx_wa_ba_not_expected;
 	u32 rx_frame_checksum;
 	u32 rx_checksum_result;
 	u32 defrag_called;
@@ -158,6 +173,7 @@ struct wl18xx_acx_rx_stats {
 	u32 defrag_decrypt_failed;
 	u32 decrypt_key_not_found;
 	u32 defrag_need_decrypt;
+	u32 rx_tkip_replays;
 } __packed;
 
 struct wl18xx_acx_isr_stats {
@@ -197,20 +213,25 @@ struct wl18xx_acx_rx_filter_stats {
 	u32 data_filter;
 	u32 ibss_filter;
 	u32 protection_filter;
+	u32 accum_arp_pend_requests;
+	u32 max_arp_queue_dep;
 } __packed;
 
 struct wl18xx_acx_rx_rate_stats {
 	u32 rx_frames_per_rates[50];
 } __packed;
 
-#define AGGR_STATS_TX_SIZE_LEN 11
-#define AGGR_STATS_RX_SIZE_LEN 11
+#define AGGR_STATS_TX_AGG	16
+#define AGGR_STATS_TX_RATE	16
+#define AGGR_STATS_RX_SIZE_LEN	16
 
 struct wl18xx_acx_aggr_stats {
-	u32 tx_size[AGGR_STATS_TX_SIZE_LEN];
+	u32 tx_agg_vs_rate[AGGR_STATS_TX_AGG * AGGR_STATS_TX_RATE];
 	u32 rx_size[AGGR_STATS_RX_SIZE_LEN];
 } __packed;
 
+#define PIPE_STATS_HW_FIFO	11
+
 struct wl18xx_acx_pipeline_stats {
 	u32 hs_tx_stat_fifo_int;
 	u32 hs_rx_stat_fifo_int;
@@ -230,6 +251,7 @@ struct wl18xx_acx_pipeline_stats {
 	u32 dec_packet_out;
 	u32 cs_rx_packet_in;
 	u32 cs_rx_packet_out;
+	u16 pipeline_fifo_full[PIPE_STATS_HW_FIFO];
 } __packed;
 
 struct wl18xx_acx_mem_stats {
@@ -242,13 +264,12 @@ struct wl18xx_acx_mem_stats {
 struct wl18xx_acx_statistics {
 	struct acx_header header;
 
-	struct wl18xx_acx_ring_stats		ring;
+	struct wl18xx_acx_error_stats		error;
 	struct wl18xx_acx_debug_stats		debug;
 	struct wl18xx_acx_tx_stats		tx;
 	struct wl18xx_acx_rx_stats		rx;
 	struct wl18xx_acx_isr_stats		isr;
 	struct wl18xx_acx_pwr_stats		pwr;
-	struct wl18xx_acx_event_stats		event;
 	struct wl18xx_acx_ps_poll_stats		ps_poll;
 	struct wl18xx_acx_rx_filter_stats	rx_filter;
 	struct wl18xx_acx_rx_rate_stats		rx_rate;
diff --git a/drivers/net/wireless/ti/wl18xx/debugfs.c b/drivers/net/wireless/ti/wl18xx/debugfs.c
index 96b1496..fb0969d 100644
--- a/drivers/net/wireless/ti/wl18xx/debugfs.c
+++ b/drivers/net/wireless/ti/wl18xx/debugfs.c
@@ -40,9 +40,14 @@ WL18XX_DEBUGFS_FWSTATS_FILE(debug, debug4, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(debug, debug5, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(debug, debug6, "%u");
 
-WL18XX_DEBUGFS_FWSTATS_FILE(ring, prepared_descs, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(ring, tx_cmplt, "%u");
-
+WL18XX_DEBUGFS_FWSTATS_FILE(error, error_frame, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(error, error_null_Frame_tx_start, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(error, error_numll_frame_cts_start, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(error, error_bar_retry, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(error, error_frame_cts_nul_flid, "%u");
+
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_prepared_descs, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_cmplt, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_template_prepared, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_data_prepared, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_template_programmed, "%u");
@@ -77,7 +82,8 @@ WL18XX_DEBUGFS_FWSTATS_FILE(tx, frag_failed, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(tx, frag_cache_hit, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(tx, frag_cache_miss, "%u");
 
-WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_out_of_mem, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_beacon_early_term, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_out_of_mpdu_nodes, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_hdr_overflow, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_dropped_frame, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_done, "%u");
@@ -88,6 +94,9 @@ WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_pre_complt, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_cmplt_task, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_phy_hdr, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_timeout, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_timeout_wa, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_wa_density_dropped_frame, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_wa_ba_not_expected, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_frame_checksum, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_checksum_result, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(rx, defrag_called, "%u");
@@ -98,6 +107,7 @@ WL18XX_DEBUGFS_FWSTATS_FILE(rx, defrag_need_defrag, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(rx, defrag_decrypt_failed, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(rx, decrypt_key_not_found, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(rx, defrag_need_decrypt, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_tkip_replays, "%u");
 
 WL18XX_DEBUGFS_FWSTATS_FILE(isr, irqs, "%u");
 
@@ -109,10 +119,6 @@ WL18XX_DEBUGFS_FWSTATS_FILE_ARRAY(pwr, cont_miss_bcns_spread,
 WL18XX_DEBUGFS_FWSTATS_FILE(pwr, rcvd_awake_bcns_cnt, "%u");
 
 
-WL18XX_DEBUGFS_FWSTATS_FILE(event, calibration, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(event, rx_mismatch, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(event, rx_mem_empty, "%u");
-
 WL18XX_DEBUGFS_FWSTATS_FILE(ps_poll, ps_poll_timeouts, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(ps_poll, upsd_timeouts, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(ps_poll, upsd_max_ap_turn, "%u");
@@ -127,11 +133,13 @@ WL18XX_DEBUGFS_FWSTATS_FILE(rx_filter, dup_filter, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(rx_filter, data_filter, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(rx_filter, ibss_filter, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(rx_filter, protection_filter, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx_filter, accum_arp_pend_requests, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx_filter, max_arp_queue_dep, "%u");
 
 WL18XX_DEBUGFS_FWSTATS_FILE(rx_rate, rx_frames_per_rates, "%u");
 
-WL18XX_DEBUGFS_FWSTATS_FILE_ARRAY(aggr_size, tx_size,
-				  AGGR_STATS_TX_SIZE_LEN);
+WL18XX_DEBUGFS_FWSTATS_FILE_ARRAY(aggr_size, tx_agg_vs_rate,
+				  AGGR_STATS_TX_AGG*AGGR_STATS_TX_RATE);
 WL18XX_DEBUGFS_FWSTATS_FILE_ARRAY(aggr_size, rx_size,
 				  AGGR_STATS_RX_SIZE_LEN);
 
@@ -153,6 +161,9 @@ WL18XX_DEBUGFS_FWSTATS_FILE(pipeline, dec_packet_out, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(pipeline, cs_rx_packet_in, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(pipeline, cs_rx_packet_out, "%u");
 
+WL18XX_DEBUGFS_FWSTATS_FILE_ARRAY(pipeline, pipeline_fifo_full,
+				  PIPE_STATS_HW_FIFO);
+
 WL18XX_DEBUGFS_FWSTATS_FILE(mem, rx_free_mem_blks, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(mem, tx_free_mem_blks, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(mem, fwlog_free_mem_blks, "%u");
@@ -255,9 +266,14 @@ int wl18xx_debugfs_add_files(struct wl1271 *wl,
 	DEBUGFS_FWSTATS_ADD(debug, debug5);
 	DEBUGFS_FWSTATS_ADD(debug, debug6);
 
-	DEBUGFS_FWSTATS_ADD(ring, prepared_descs);
-	DEBUGFS_FWSTATS_ADD(ring, tx_cmplt);
+	DEBUGFS_FWSTATS_ADD(error, error_frame);
+	DEBUGFS_FWSTATS_ADD(error, error_null_Frame_tx_start);
+	DEBUGFS_FWSTATS_ADD(error, error_numll_frame_cts_start);
+	DEBUGFS_FWSTATS_ADD(error, error_bar_retry);
+	DEBUGFS_FWSTATS_ADD(error, error_frame_cts_nul_flid);
 
+	DEBUGFS_FWSTATS_ADD(tx, tx_prepared_descs);
+	DEBUGFS_FWSTATS_ADD(tx, tx_cmplt);
 	DEBUGFS_FWSTATS_ADD(tx, tx_template_prepared);
 	DEBUGFS_FWSTATS_ADD(tx, tx_data_prepared);
 	DEBUGFS_FWSTATS_ADD(tx, tx_template_programmed);
@@ -292,7 +308,8 @@ int wl18xx_debugfs_add_files(struct wl1271 *wl,
 	DEBUGFS_FWSTATS_ADD(tx, frag_cache_hit);
 	DEBUGFS_FWSTATS_ADD(tx, frag_cache_miss);
 
-	DEBUGFS_FWSTATS_ADD(rx, rx_out_of_mem);
+        DEBUGFS_FWSTATS_ADD(rx, rx_beacon_early_term);
+        DEBUGFS_FWSTATS_ADD(rx, rx_out_of_mpdu_nodes);
 	DEBUGFS_FWSTATS_ADD(rx, rx_hdr_overflow);
 	DEBUGFS_FWSTATS_ADD(rx, rx_dropped_frame);
 	DEBUGFS_FWSTATS_ADD(rx, rx_done);
@@ -303,6 +320,9 @@ int wl18xx_debugfs_add_files(struct wl1271 *wl,
 	DEBUGFS_FWSTATS_ADD(rx, rx_cmplt_task);
 	DEBUGFS_FWSTATS_ADD(rx, rx_phy_hdr);
 	DEBUGFS_FWSTATS_ADD(rx, rx_timeout);
+        DEBUGFS_FWSTATS_ADD(rx, rx_timeout_wa);
+        DEBUGFS_FWSTATS_ADD(rx, rx_wa_density_dropped_frame);
+        DEBUGFS_FWSTATS_ADD(rx, rx_wa_ba_not_expected);
 	DEBUGFS_FWSTATS_ADD(rx, rx_frame_checksum);
 	DEBUGFS_FWSTATS_ADD(rx, rx_checksum_result);
 	DEBUGFS_FWSTATS_ADD(rx, defrag_called);
@@ -313,6 +333,7 @@ int wl18xx_debugfs_add_files(struct wl1271 *wl,
 	DEBUGFS_FWSTATS_ADD(rx, defrag_decrypt_failed);
 	DEBUGFS_FWSTATS_ADD(rx, decrypt_key_not_found);
 	DEBUGFS_FWSTATS_ADD(rx, defrag_need_decrypt);
+	DEBUGFS_FWSTATS_ADD(rx, rx_tkip_replays);
 
 	DEBUGFS_FWSTATS_ADD(isr, irqs);
 
@@ -322,10 +343,6 @@ int wl18xx_debugfs_add_files(struct wl1271 *wl,
 	DEBUGFS_FWSTATS_ADD(pwr, cont_miss_bcns_spread);
 	DEBUGFS_FWSTATS_ADD(pwr, rcvd_awake_bcns_cnt);
 
-	DEBUGFS_FWSTATS_ADD(event, calibration);
-	DEBUGFS_FWSTATS_ADD(event, rx_mismatch);
-	DEBUGFS_FWSTATS_ADD(event, rx_mem_empty);
-
 	DEBUGFS_FWSTATS_ADD(ps_poll, ps_poll_timeouts);
 	DEBUGFS_FWSTATS_ADD(ps_poll, upsd_timeouts);
 	DEBUGFS_FWSTATS_ADD(ps_poll, upsd_max_ap_turn);
@@ -340,10 +357,12 @@ int wl18xx_debugfs_add_files(struct wl1271 *wl,
 	DEBUGFS_FWSTATS_ADD(rx_filter, data_filter);
 	DEBUGFS_FWSTATS_ADD(rx_filter, ibss_filter);
 	DEBUGFS_FWSTATS_ADD(rx_filter, protection_filter);
+        DEBUGFS_FWSTATS_ADD(rx_filter, accum_arp_pend_requests);
+        DEBUGFS_FWSTATS_ADD(rx_filter, max_arp_queue_dep);
 
 	DEBUGFS_FWSTATS_ADD(rx_rate, rx_frames_per_rates);
 
-	DEBUGFS_FWSTATS_ADD(aggr_size, tx_size);
+	DEBUGFS_FWSTATS_ADD(aggr_size, tx_agg_vs_rate);
 	DEBUGFS_FWSTATS_ADD(aggr_size, rx_size);
 
 	DEBUGFS_FWSTATS_ADD(pipeline, hs_tx_stat_fifo_int);
@@ -363,6 +382,7 @@ int wl18xx_debugfs_add_files(struct wl1271 *wl,
 	DEBUGFS_FWSTATS_ADD(pipeline, dec_packet_out);
 	DEBUGFS_FWSTATS_ADD(pipeline, cs_rx_packet_in);
 	DEBUGFS_FWSTATS_ADD(pipeline, cs_rx_packet_out);
+        DEBUGFS_FWSTATS_ADD(pipeline, pipeline_fifo_full);
 
 	DEBUGFS_FWSTATS_ADD(mem, rx_free_mem_blks);
 	DEBUGFS_FWSTATS_ADD(mem, tx_free_mem_blks);
-- 
1.7.10

