Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51169 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758764Ab2EJJRV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:17:21 -0400
Received: by mail-wi0-f172.google.com with SMTP id hr2so244170wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:17:20 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 77/78] wl18xx: use new fw stats structures
Date: Thu, 10 May 2012 12:14:22 +0300
Message-Id: <1336641263-5761-78-git-send-email-arik@wizery.com> (sfid-20120510_111738_890608_C173E2C2)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

Some of the structures were updated, other structures had a few
missing values and a few new ones were added.  Change the driver
structs accordingly.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/acx.h     |  156 ++++++++-----------
 drivers/net/wireless/ti/wl18xx/debugfs.c |  248 +++++++++++++-----------------
 2 files changed, 169 insertions(+), 235 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/acx.h b/drivers/net/wireless/ti/wl18xx/acx.h
index c2ccf70..cb6fd85 100644
--- a/drivers/net/wireless/ti/wl18xx/acx.h
+++ b/drivers/net/wireless/ti/wl18xx/acx.h
@@ -71,13 +71,8 @@ struct wl18xx_acx_debug_stats {
 } __packed;
 
 struct wl18xx_acx_ring_stats {
-	u32 tx_procs;
 	u32 prepared_descs;
-	u32 tx_xfr;
-	u32 tx_dma;
 	u32 tx_cmplt;
-	u32 rx_procs;
-	u32 rx_data;
 } __packed;
 
 struct wl18xx_acx_tx_stats {
@@ -98,60 +93,53 @@ struct wl18xx_acx_tx_stats {
 	u32 tx_retry_data;
 	u32 tx_exch_pending;
 	u32 tx_exch_expiry;
-	u32 tx_exch_mismatch;
 	u32 tx_done_template;
 	u32 tx_done_data;
 	u32 tx_done_int_template;
-	u32 tx_pre_xfr;
-	u32 tx_xfr;
-	u32 tx_xfr_out_of_mem;
-	u32 tx_dma_programmed;
-	u32 tx_dma_done;
+	u32 tx_frame_checksum;
+	u32 tx_checksum_result;
+	u32 frag_called;
+	u32 frag_mpdu_alloc_failed;
+	u32 frag_init_called;
+	u32 frag_in_process_called;
+	u32 frag_tkip_called;
+	u32 frag_key_not_found;
+	u32 frag_need_fragmentation;
+	u32 frag_bad_mblk_num;
+	u32 frag_failed;
+	u32 frag_cache_hit;
+	u32 frag_cache_miss;
 } __packed;
 
 struct wl18xx_acx_rx_stats {
 	u32 rx_out_of_mem;
 	u32 rx_hdr_overflow;
-	u32 rx_hw_stuck;
 	u32 rx_dropped_frame;
-	u32 rx_complete_dropped_frame;
-	u32 rx_alloc_frame;
-	u32 rx_done_queue;
+	u32 rx_done_stage;
 	u32 rx_done;
 	u32 rx_defrag;
 	u32 rx_defrag_end;
-	u32 rx_mic;
-	u32 rx_mic_end;
-	u32 rx_xfr;
-	u32 rx_xfr_end;
 	u32 rx_cmplt;
 	u32 rx_pre_complt;
 	u32 rx_cmplt_task;
 	u32 rx_phy_hdr;
 	u32 rx_timeout;
-} __packed;
-
-struct wl18xx_acx_dma_stats {
-	u32 rx_dma_errors;
-	u32 tx_dma_errors;
+	u32 rx_frame_checksum;
+	u32 rx_checksum_result;
+	u32 defrag_called;
+	u32 defrag_init_called;
+	u32 defrag_in_process_called;
+	u32 defrag_tkip_called;
+	u32 defrag_need_defrag;
+	u32 defrag_decrypt_failed;
+	u32 decrypt_key_not_found;
+	u32 defrag_need_decrypt;
 } __packed;
 
 struct wl18xx_acx_isr_stats {
 	u32 irqs;
 } __packed;
 
-struct wl18xx_acx_wep_stats {
-	u32 wep_add_key_count;
-	u32 wep_default_key_count;
-	u32 wep_key_not_found;
-	u32 wep_decrypt_fail;
-	u32 wep_encrypt_fail;
-	u32 wep_dec_packets;
-	u32 wep_dec_interrupt;
-	u32 wep_enc_packets;
-	u32 wep_enc_interrupts;
-} __packed;
-
 #define PWR_STAT_MAX_CONT_MISSED_BCNS_SPREAD 10
 
 struct wl18xx_acx_pwr_stats {
@@ -162,29 +150,6 @@ struct wl18xx_acx_pwr_stats {
 	u32 rcvd_awake_bcns_cnt;
 } __packed;
 
-struct wl18xx_acx_mic_stats {
-	u32 mic_rx_pkts;
-	u32 mic_calc_failure;
-} __packed;
-
-struct wl18xx_acx_aes_stats {
-	u32 aes_encrypt_fail;
-	u32 aes_decrypt_fail;
-	u32 aes_encrypt_packets;
-	u32 aes_decrypt_packets;
-	u32 aes_encrypt_interrupt;
-	u32 aes_decrypt_interrupt;
-} __packed;
-
-struct wl18xx_acx_gem_stats {
-	u32 gem_encrypt_fail;
-	u32 gem_decrypt_fail;
-	u32 gem_encrypt_packets;
-	u32 gem_decrypt_packets;
-	u32 gem_encrypt_interrupt;
-	u32 gem_decrypt_interrupt;
-} __packed;
-
 struct wl18xx_acx_event_stats {
 	u32 calibration;
 	u32 rx_mismatch;
@@ -210,31 +175,44 @@ struct wl18xx_acx_rx_filter_stats {
 	u32 protection_filter;
 } __packed;
 
-struct wl18xx_acx_calibration_stats {
-	u32 init_cal_total;
-	u32 init_radio_bands_fail;
-	u32 init_set_params;
-	u32 init_tx_clpc_fail;
-	u32 init_rx_iw_mm_fail;
-	u32 tune_cal_total;
-	u32 tune_drpw_rtrim_fail;
-	u32 tune_drpw_pd_buf_fail;
-	u32 tune_drpw_tx_mix_freq_fail;
-	u32 tune_drpw_ta_cal;
-	u32 tune_drpw_rx_if_2_gain;
-	u32 tune_drpw_rx_dac;
-	u32 tune_drpw_chan_tune;
-	u32 tune_drpw_rx_tx_lpf;
-	u32 tune_drpw_lna_tank;
-	u32 tune_tx_lo_leak_fail;
-	u32 tune_tx_iq_mm_fail;
-	u32 tune_tx_pdet_fail;
-	u32 tune_tx_ppa_fail;
-	u32 tune_tx_clpc_fail;
-	u32 tune_rx_ana_dc_fail;
-	u32 tune_rx_dig_dc_fail; /* check if this is needed */
-	u32 tune_rx_iq_mm_fail;
-	u32 cal_state_fail;
+struct wl18xx_acx_rx_rate_stats {
+	u32 rx_frames_per_rates[50];
+} __packed;
+
+#define AGGR_STATS_TX_SIZE_LEN 11
+#define AGGR_STATS_RX_SIZE_LEN 11
+
+struct wl18xx_acx_aggr_stats {
+	u32 tx_size[AGGR_STATS_TX_SIZE_LEN];
+	u32 rx_size[AGGR_STATS_RX_SIZE_LEN];
+} __packed;
+
+struct wl18xx_acx_pipeline_stats {
+	u32 hs_tx_stat_fifo_int;
+	u32 hs_rx_stat_fifo_int;
+	u32 tcp_tx_stat_fifo_int;
+	u32 tcp_rx_stat_fifo_int;
+	u32 enc_tx_stat_fifo_int;
+	u32 enc_rx_stat_fifo_int;
+	u32 rx_complete_stat_fifo_int;
+	u32 pre_proc_swi;
+	u32 post_proc_swi;
+	u32 sec_frag_swi;
+	u32 pre_to_defrag_swi;
+	u32 defrag_to_csum_swi;
+	u32 csum_to_rx_xfer_swi;
+	u32 dec_packet_in;
+	u32 dec_packet_in_fifo_full;
+	u32 dec_packet_out;
+	u32 cs_rx_packet_in;
+	u32 cs_rx_packet_out;
+} __packed;
+
+struct wl18xx_acx_mem_stats {
+	u32 rx_free_mem_blks;
+	u32 tx_free_mem_blks;
+	u32 fwlog_free_mem_blks;
+	u32 fw_gen_free_mem_blks;
 } __packed;
 
 struct wl18xx_acx_statistics {
@@ -244,17 +222,15 @@ struct wl18xx_acx_statistics {
 	struct wl18xx_acx_debug_stats		debug;
 	struct wl18xx_acx_tx_stats		tx;
 	struct wl18xx_acx_rx_stats		rx;
-	struct wl18xx_acx_dma_stats		dma;
 	struct wl18xx_acx_isr_stats		isr;
-	struct wl18xx_acx_wep_stats		wep;
 	struct wl18xx_acx_pwr_stats		pwr;
-	struct wl18xx_acx_aes_stats		aes;
-	struct wl18xx_acx_mic_stats		mic;
 	struct wl18xx_acx_event_stats		event;
 	struct wl18xx_acx_ps_poll_stats		ps_poll;
 	struct wl18xx_acx_rx_filter_stats	rx_filter;
-	struct wl18xx_acx_calibration_stats	calibration;
-	struct wl18xx_acx_gem_stats		gem;
+	struct wl18xx_acx_rx_rate_stats		rx_rate;
+	struct wl18xx_acx_aggr_stats		aggr_size;
+	struct wl18xx_acx_pipeline_stats	pipeline;
+	struct wl18xx_acx_mem_stats		mem;
 } __packed;
 
 int wl18xx_acx_host_if_cfg_bitmap(struct wl1271 *wl, u32 host_cfg_bitmap,
diff --git a/drivers/net/wireless/ti/wl18xx/debugfs.c b/drivers/net/wireless/ti/wl18xx/debugfs.c
index f4127bf..93c625b 100644
--- a/drivers/net/wireless/ti/wl18xx/debugfs.c
+++ b/drivers/net/wireless/ti/wl18xx/debugfs.c
@@ -32,6 +32,7 @@
 #define WL18XX_DEBUGFS_FWSTATS_FILE_ARRAY(a, b, c) \
 	DEBUGFS_FWSTATS_FILE_ARRAY(a, b, c, wl18xx_acx_statistics)
 
+
 WL18XX_DEBUGFS_FWSTATS_FILE(debug, debug1, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(debug, debug2, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(debug, debug3, "%u");
@@ -39,13 +40,8 @@ WL18XX_DEBUGFS_FWSTATS_FILE(debug, debug4, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(debug, debug5, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(debug, debug6, "%u");
 
-WL18XX_DEBUGFS_FWSTATS_FILE(ring, tx_procs, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(ring, prepared_descs, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(ring, tx_xfr, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(ring, tx_dma, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(ring, tx_cmplt, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(ring, rx_procs, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(ring, rx_data, "%u");
 
 WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_template_prepared, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_data_prepared, "%u");
@@ -64,51 +60,47 @@ WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_retry_template, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_retry_data, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_exch_pending, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_exch_expiry, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_exch_mismatch, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_done_template, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_done_data, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_done_int_template, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_pre_xfr, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_xfr, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_xfr_out_of_mem, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_dma_programmed, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_dma_done, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_frame_checksum, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_checksum_result, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, frag_called, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, frag_mpdu_alloc_failed, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, frag_init_called, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, frag_in_process_called, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, frag_tkip_called, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, frag_key_not_found, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, frag_need_fragmentation, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, frag_bad_mblk_num, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, frag_failed, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, frag_cache_hit, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, frag_cache_miss, "%u");
 
 WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_out_of_mem, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_hdr_overflow, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_hw_stuck, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_dropped_frame, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_complete_dropped_frame, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_alloc_frame, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_done_queue, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_done, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_defrag, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_defrag_end, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_mic, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_mic_end, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_xfr, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_xfr_end, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_cmplt, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_pre_complt, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_cmplt_task, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_phy_hdr, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_timeout, "%u");
-
-WL18XX_DEBUGFS_FWSTATS_FILE(dma, rx_dma_errors, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(dma, tx_dma_errors, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_frame_checksum, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_checksum_result, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, defrag_called, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, defrag_init_called, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, defrag_in_process_called, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, defrag_tkip_called, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, defrag_need_defrag, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, defrag_decrypt_failed, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, decrypt_key_not_found, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, defrag_need_decrypt, "%u");
 
 WL18XX_DEBUGFS_FWSTATS_FILE(isr, irqs, "%u");
 
-WL18XX_DEBUGFS_FWSTATS_FILE(wep, wep_add_key_count, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(wep, wep_default_key_count, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(wep, wep_key_not_found, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(wep, wep_decrypt_fail, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(wep, wep_encrypt_fail, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(wep, wep_dec_packets, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(wep, wep_dec_interrupt, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(wep, wep_enc_packets, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(wep, wep_enc_interrupts, "%u");
-
 WL18XX_DEBUGFS_FWSTATS_FILE(pwr, missing_bcns_cnt, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(pwr, rcvd_bcns_cnt, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(pwr, connection_out_of_sync, "%u");
@@ -116,22 +108,6 @@ WL18XX_DEBUGFS_FWSTATS_FILE_ARRAY(pwr, cont_miss_bcns_spread,
 				  PWR_STAT_MAX_CONT_MISSED_BCNS_SPREAD);
 WL18XX_DEBUGFS_FWSTATS_FILE(pwr, rcvd_awake_bcns_cnt, "%u");
 
-WL18XX_DEBUGFS_FWSTATS_FILE(mic, mic_rx_pkts, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(mic, mic_calc_failure, "%u");
-
-WL18XX_DEBUGFS_FWSTATS_FILE(aes, aes_encrypt_fail, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(aes, aes_decrypt_fail, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(aes, aes_encrypt_packets, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(aes, aes_decrypt_packets, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(aes, aes_encrypt_interrupt, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(aes, aes_decrypt_interrupt, "%u");
-
-WL18XX_DEBUGFS_FWSTATS_FILE(gem, gem_encrypt_fail, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(gem, gem_decrypt_fail, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(gem, gem_encrypt_packets, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(gem, gem_decrypt_packets, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(gem, gem_encrypt_interrupt, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(gem, gem_decrypt_interrupt, "%u");
 
 WL18XX_DEBUGFS_FWSTATS_FILE(event, calibration, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(event, rx_mismatch, "%u");
@@ -152,30 +128,35 @@ WL18XX_DEBUGFS_FWSTATS_FILE(rx_filter, data_filter, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(rx_filter, ibss_filter, "%u");
 WL18XX_DEBUGFS_FWSTATS_FILE(rx_filter, protection_filter, "%u");
 
-WL18XX_DEBUGFS_FWSTATS_FILE(calibration, init_cal_total, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(calibration, init_radio_bands_fail, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(calibration, init_set_params, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(calibration, init_tx_clpc_fail, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(calibration, init_rx_iw_mm_fail, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_cal_total, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_drpw_rtrim_fail, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_drpw_pd_buf_fail, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_drpw_tx_mix_freq_fail, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_drpw_ta_cal, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_drpw_rx_if_2_gain, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_drpw_rx_dac, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_drpw_chan_tune, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_drpw_rx_tx_lpf, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_drpw_lna_tank, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_tx_lo_leak_fail, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_tx_iq_mm_fail, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_tx_pdet_fail, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_tx_ppa_fail, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_tx_clpc_fail, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_rx_ana_dc_fail, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_rx_dig_dc_fail, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_rx_iq_mm_fail, "%u");
-WL18XX_DEBUGFS_FWSTATS_FILE(calibration, cal_state_fail, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx_rate, rx_frames_per_rates, "%u");
+
+WL18XX_DEBUGFS_FWSTATS_FILE_ARRAY(aggr_size, tx_size,
+				  AGGR_STATS_TX_SIZE_LEN);
+WL18XX_DEBUGFS_FWSTATS_FILE_ARRAY(aggr_size, rx_size,
+				  AGGR_STATS_RX_SIZE_LEN);
+
+WL18XX_DEBUGFS_FWSTATS_FILE(pipeline, hs_tx_stat_fifo_int, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(pipeline, tcp_tx_stat_fifo_int, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(pipeline, tcp_rx_stat_fifo_int, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(pipeline, enc_tx_stat_fifo_int, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(pipeline, enc_rx_stat_fifo_int, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(pipeline, rx_complete_stat_fifo_int, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(pipeline, pre_proc_swi, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(pipeline, post_proc_swi, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(pipeline, sec_frag_swi, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(pipeline, pre_to_defrag_swi, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(pipeline, defrag_to_csum_swi, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(pipeline, csum_to_rx_xfer_swi, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(pipeline, dec_packet_in, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(pipeline, dec_packet_in_fifo_full, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(pipeline, dec_packet_out, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(pipeline, cs_rx_packet_in, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(pipeline, cs_rx_packet_out, "%u");
+
+WL18XX_DEBUGFS_FWSTATS_FILE(mem, rx_free_mem_blks, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(mem, tx_free_mem_blks, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(mem, fwlog_free_mem_blks, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(mem, fw_gen_free_mem_blks, "%u");
 
 int wl18xx_debugfs_add_files(struct wl1271 *wl,
 			     struct dentry *rootdir)
@@ -202,13 +183,8 @@ int wl18xx_debugfs_add_files(struct wl1271 *wl,
 	DEBUGFS_FWSTATS_ADD(debug, debug5);
 	DEBUGFS_FWSTATS_ADD(debug, debug6);
 
-	DEBUGFS_FWSTATS_ADD(ring, tx_procs);
 	DEBUGFS_FWSTATS_ADD(ring, prepared_descs);
-	DEBUGFS_FWSTATS_ADD(ring, tx_xfr);
-	DEBUGFS_FWSTATS_ADD(ring, tx_dma);
 	DEBUGFS_FWSTATS_ADD(ring, tx_cmplt);
-	DEBUGFS_FWSTATS_ADD(ring, rx_procs);
-	DEBUGFS_FWSTATS_ADD(ring, rx_data);
 
 	DEBUGFS_FWSTATS_ADD(tx, tx_template_prepared);
 	DEBUGFS_FWSTATS_ADD(tx, tx_data_prepared);
@@ -227,74 +203,53 @@ int wl18xx_debugfs_add_files(struct wl1271 *wl,
 	DEBUGFS_FWSTATS_ADD(tx, tx_retry_data);
 	DEBUGFS_FWSTATS_ADD(tx, tx_exch_pending);
 	DEBUGFS_FWSTATS_ADD(tx, tx_exch_expiry);
-	DEBUGFS_FWSTATS_ADD(tx, tx_exch_mismatch);
 	DEBUGFS_FWSTATS_ADD(tx, tx_done_template);
 	DEBUGFS_FWSTATS_ADD(tx, tx_done_data);
 	DEBUGFS_FWSTATS_ADD(tx, tx_done_int_template);
-	DEBUGFS_FWSTATS_ADD(tx, tx_pre_xfr);
-	DEBUGFS_FWSTATS_ADD(tx, tx_xfr);
-	DEBUGFS_FWSTATS_ADD(tx, tx_xfr_out_of_mem);
-	DEBUGFS_FWSTATS_ADD(tx, tx_dma_programmed);
-	DEBUGFS_FWSTATS_ADD(tx, tx_dma_done);
+	DEBUGFS_FWSTATS_ADD(tx, tx_frame_checksum);
+	DEBUGFS_FWSTATS_ADD(tx, tx_checksum_result);
+	DEBUGFS_FWSTATS_ADD(tx, frag_called);
+	DEBUGFS_FWSTATS_ADD(tx, frag_mpdu_alloc_failed);
+	DEBUGFS_FWSTATS_ADD(tx, frag_init_called);
+	DEBUGFS_FWSTATS_ADD(tx, frag_in_process_called);
+	DEBUGFS_FWSTATS_ADD(tx, frag_tkip_called);
+	DEBUGFS_FWSTATS_ADD(tx, frag_key_not_found);
+	DEBUGFS_FWSTATS_ADD(tx, frag_need_fragmentation);
+	DEBUGFS_FWSTATS_ADD(tx, frag_bad_mblk_num);
+	DEBUGFS_FWSTATS_ADD(tx, frag_failed);
+	DEBUGFS_FWSTATS_ADD(tx, frag_cache_hit);
+	DEBUGFS_FWSTATS_ADD(tx, frag_cache_miss);
 
 	DEBUGFS_FWSTATS_ADD(rx, rx_out_of_mem);
 	DEBUGFS_FWSTATS_ADD(rx, rx_hdr_overflow);
-	DEBUGFS_FWSTATS_ADD(rx, rx_hw_stuck);
 	DEBUGFS_FWSTATS_ADD(rx, rx_dropped_frame);
-	DEBUGFS_FWSTATS_ADD(rx, rx_complete_dropped_frame);
-	DEBUGFS_FWSTATS_ADD(rx, rx_alloc_frame);
-	DEBUGFS_FWSTATS_ADD(rx, rx_done_queue);
 	DEBUGFS_FWSTATS_ADD(rx, rx_done);
 	DEBUGFS_FWSTATS_ADD(rx, rx_defrag);
 	DEBUGFS_FWSTATS_ADD(rx, rx_defrag_end);
-	DEBUGFS_FWSTATS_ADD(rx, rx_mic);
-	DEBUGFS_FWSTATS_ADD(rx, rx_mic_end);
-	DEBUGFS_FWSTATS_ADD(rx, rx_xfr);
-	DEBUGFS_FWSTATS_ADD(rx, rx_xfr_end);
 	DEBUGFS_FWSTATS_ADD(rx, rx_cmplt);
 	DEBUGFS_FWSTATS_ADD(rx, rx_pre_complt);
 	DEBUGFS_FWSTATS_ADD(rx, rx_cmplt_task);
 	DEBUGFS_FWSTATS_ADD(rx, rx_phy_hdr);
 	DEBUGFS_FWSTATS_ADD(rx, rx_timeout);
-
-	DEBUGFS_FWSTATS_ADD(dma, rx_dma_errors);
-	DEBUGFS_FWSTATS_ADD(dma, tx_dma_errors);
+	DEBUGFS_FWSTATS_ADD(rx, rx_frame_checksum);
+	DEBUGFS_FWSTATS_ADD(rx, rx_checksum_result);
+	DEBUGFS_FWSTATS_ADD(rx, defrag_called);
+	DEBUGFS_FWSTATS_ADD(rx, defrag_init_called);
+	DEBUGFS_FWSTATS_ADD(rx, defrag_in_process_called);
+	DEBUGFS_FWSTATS_ADD(rx, defrag_tkip_called);
+	DEBUGFS_FWSTATS_ADD(rx, defrag_need_defrag);
+	DEBUGFS_FWSTATS_ADD(rx, defrag_decrypt_failed);
+	DEBUGFS_FWSTATS_ADD(rx, decrypt_key_not_found);
+	DEBUGFS_FWSTATS_ADD(rx, defrag_need_decrypt);
 
 	DEBUGFS_FWSTATS_ADD(isr, irqs);
 
-	DEBUGFS_FWSTATS_ADD(wep, wep_add_key_count);
-	DEBUGFS_FWSTATS_ADD(wep, wep_default_key_count);
-	DEBUGFS_FWSTATS_ADD(wep, wep_key_not_found);
-	DEBUGFS_FWSTATS_ADD(wep, wep_decrypt_fail);
-	DEBUGFS_FWSTATS_ADD(wep, wep_encrypt_fail);
-	DEBUGFS_FWSTATS_ADD(wep, wep_dec_packets);
-	DEBUGFS_FWSTATS_ADD(wep, wep_dec_interrupt);
-	DEBUGFS_FWSTATS_ADD(wep, wep_enc_packets);
-	DEBUGFS_FWSTATS_ADD(wep, wep_enc_interrupts);
-
 	DEBUGFS_FWSTATS_ADD(pwr, missing_bcns_cnt);
 	DEBUGFS_FWSTATS_ADD(pwr, rcvd_bcns_cnt);
 	DEBUGFS_FWSTATS_ADD(pwr, connection_out_of_sync);
 	DEBUGFS_FWSTATS_ADD(pwr, cont_miss_bcns_spread);
 	DEBUGFS_FWSTATS_ADD(pwr, rcvd_awake_bcns_cnt);
 
-	DEBUGFS_FWSTATS_ADD(mic, mic_rx_pkts);
-	DEBUGFS_FWSTATS_ADD(mic, mic_calc_failure);
-
-	DEBUGFS_FWSTATS_ADD(aes, aes_encrypt_fail);
-	DEBUGFS_FWSTATS_ADD(aes, aes_decrypt_fail);
-	DEBUGFS_FWSTATS_ADD(aes, aes_encrypt_packets);
-	DEBUGFS_FWSTATS_ADD(aes, aes_decrypt_packets);
-	DEBUGFS_FWSTATS_ADD(aes, aes_encrypt_interrupt);
-	DEBUGFS_FWSTATS_ADD(aes, aes_decrypt_interrupt);
-
-	DEBUGFS_FWSTATS_ADD(gem, gem_encrypt_fail);
-	DEBUGFS_FWSTATS_ADD(gem, gem_decrypt_fail);
-	DEBUGFS_FWSTATS_ADD(gem, gem_encrypt_packets);
-	DEBUGFS_FWSTATS_ADD(gem, gem_decrypt_packets);
-	DEBUGFS_FWSTATS_ADD(gem, gem_encrypt_interrupt);
-	DEBUGFS_FWSTATS_ADD(gem, gem_decrypt_interrupt);
-
 	DEBUGFS_FWSTATS_ADD(event, calibration);
 	DEBUGFS_FWSTATS_ADD(event, rx_mismatch);
 	DEBUGFS_FWSTATS_ADD(event, rx_mem_empty);
@@ -314,30 +269,33 @@ int wl18xx_debugfs_add_files(struct wl1271 *wl,
 	DEBUGFS_FWSTATS_ADD(rx_filter, ibss_filter);
 	DEBUGFS_FWSTATS_ADD(rx_filter, protection_filter);
 
-	DEBUGFS_FWSTATS_ADD(calibration, init_cal_total);
-	DEBUGFS_FWSTATS_ADD(calibration, init_radio_bands_fail);
-	DEBUGFS_FWSTATS_ADD(calibration, init_set_params);
-	DEBUGFS_FWSTATS_ADD(calibration, init_tx_clpc_fail);
-	DEBUGFS_FWSTATS_ADD(calibration, init_rx_iw_mm_fail);
-	DEBUGFS_FWSTATS_ADD(calibration, tune_cal_total);
-	DEBUGFS_FWSTATS_ADD(calibration, tune_drpw_rtrim_fail);
-	DEBUGFS_FWSTATS_ADD(calibration, tune_drpw_pd_buf_fail);
-	DEBUGFS_FWSTATS_ADD(calibration, tune_drpw_tx_mix_freq_fail);
-	DEBUGFS_FWSTATS_ADD(calibration, tune_drpw_ta_cal);
-	DEBUGFS_FWSTATS_ADD(calibration, tune_drpw_rx_if_2_gain);
-	DEBUGFS_FWSTATS_ADD(calibration, tune_drpw_rx_dac);
-	DEBUGFS_FWSTATS_ADD(calibration, tune_drpw_chan_tune);
-	DEBUGFS_FWSTATS_ADD(calibration, tune_drpw_rx_tx_lpf);
-	DEBUGFS_FWSTATS_ADD(calibration, tune_drpw_lna_tank);
-	DEBUGFS_FWSTATS_ADD(calibration, tune_tx_lo_leak_fail);
-	DEBUGFS_FWSTATS_ADD(calibration, tune_tx_iq_mm_fail);
-	DEBUGFS_FWSTATS_ADD(calibration, tune_tx_pdet_fail);
-	DEBUGFS_FWSTATS_ADD(calibration, tune_tx_ppa_fail);
-	DEBUGFS_FWSTATS_ADD(calibration, tune_tx_clpc_fail);
-	DEBUGFS_FWSTATS_ADD(calibration, tune_rx_ana_dc_fail);
-	DEBUGFS_FWSTATS_ADD(calibration, tune_rx_dig_dc_fail);
-	DEBUGFS_FWSTATS_ADD(calibration, tune_rx_iq_mm_fail);
-	DEBUGFS_FWSTATS_ADD(calibration, cal_state_fail);
+	DEBUGFS_FWSTATS_ADD(rx_rate, rx_frames_per_rates);
+
+	DEBUGFS_FWSTATS_ADD(aggr_size, tx_size);
+	DEBUGFS_FWSTATS_ADD(aggr_size, rx_size);
+
+	DEBUGFS_FWSTATS_ADD(pipeline, hs_tx_stat_fifo_int);
+	DEBUGFS_FWSTATS_ADD(pipeline, tcp_tx_stat_fifo_int);
+	DEBUGFS_FWSTATS_ADD(pipeline, tcp_rx_stat_fifo_int);
+	DEBUGFS_FWSTATS_ADD(pipeline, enc_tx_stat_fifo_int);
+	DEBUGFS_FWSTATS_ADD(pipeline, enc_rx_stat_fifo_int);
+	DEBUGFS_FWSTATS_ADD(pipeline, rx_complete_stat_fifo_int);
+	DEBUGFS_FWSTATS_ADD(pipeline, pre_proc_swi);
+	DEBUGFS_FWSTATS_ADD(pipeline, post_proc_swi);
+	DEBUGFS_FWSTATS_ADD(pipeline, sec_frag_swi);
+	DEBUGFS_FWSTATS_ADD(pipeline, pre_to_defrag_swi);
+	DEBUGFS_FWSTATS_ADD(pipeline, defrag_to_csum_swi);
+	DEBUGFS_FWSTATS_ADD(pipeline, csum_to_rx_xfer_swi);
+	DEBUGFS_FWSTATS_ADD(pipeline, dec_packet_in);
+	DEBUGFS_FWSTATS_ADD(pipeline, dec_packet_in_fifo_full);
+	DEBUGFS_FWSTATS_ADD(pipeline, dec_packet_out);
+	DEBUGFS_FWSTATS_ADD(pipeline, cs_rx_packet_in);
+	DEBUGFS_FWSTATS_ADD(pipeline, cs_rx_packet_out);
+
+	DEBUGFS_FWSTATS_ADD(mem, rx_free_mem_blks);
+	DEBUGFS_FWSTATS_ADD(mem, tx_free_mem_blks);
+	DEBUGFS_FWSTATS_ADD(mem, fwlog_free_mem_blks);
+	DEBUGFS_FWSTATS_ADD(mem, fw_gen_free_mem_blks);
 
 	return 0;
 
-- 
1.7.9.5

