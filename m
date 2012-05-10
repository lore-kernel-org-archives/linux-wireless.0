Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50831 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758500Ab2EJJQw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:16:52 -0400
Received: by mail-wi0-f178.google.com with SMTP id hn19so247958wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:16:52 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 64/78] wl18xx: implement fw status debugfs entries
Date: Thu, 10 May 2012 12:14:09 +0300
Message-Id: <1336641263-5761-65-git-send-email-arik@wizery.com> (sfid-20120510_111810_771927_940E53AA)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

Implement the operations that are necessary to fetch the
wl18xx-specific FW statistics and export them in debugfs.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/debugfs.c |    1 +
 drivers/net/wireless/ti/wl18xx/Makefile  |    2 +-
 drivers/net/wireless/ti/wl18xx/acx.h     |  199 ++++++++++++++++-
 drivers/net/wireless/ti/wl18xx/debugfs.c |  345 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/debugfs.h |   28 +++
 drivers/net/wireless/ti/wl18xx/main.c    |    9 +-
 6 files changed, 581 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/wireless/ti/wl18xx/debugfs.c
 create mode 100644 drivers/net/wireless/ti/wl18xx/debugfs.h

diff --git a/drivers/net/wireless/ti/wl12xx/debugfs.c b/drivers/net/wireless/ti/wl12xx/debugfs.c
index 9cc79d8..311703d 100644
--- a/drivers/net/wireless/ti/wl12xx/debugfs.c
+++ b/drivers/net/wireless/ti/wl12xx/debugfs.c
@@ -25,6 +25,7 @@
 
 #include "wl12xx.h"
 #include "acx.h"
+#include "debugfs.h"
 
 #define WL12XX_DEBUGFS_FWSTATS_FILE(a, b, c) \
 	DEBUGFS_FWSTATS_FILE(a, b, c, wl12xx_acx_statistics)
diff --git a/drivers/net/wireless/ti/wl18xx/Makefile b/drivers/net/wireless/ti/wl18xx/Makefile
index abd881f..67c0987 100644
--- a/drivers/net/wireless/ti/wl18xx/Makefile
+++ b/drivers/net/wireless/ti/wl18xx/Makefile
@@ -1,3 +1,3 @@
-wl18xx-objs	= main.o acx.o tx.o io.o
+wl18xx-objs	= main.o acx.o tx.o io.o debugfs.o
 
 obj-$(CONFIG_WL18XX)		+= wl18xx.o
diff --git a/drivers/net/wireless/ti/wl18xx/acx.h b/drivers/net/wireless/ti/wl18xx/acx.h
index 544db6e..c2ccf70 100644
--- a/drivers/net/wireless/ti/wl18xx/acx.h
+++ b/drivers/net/wireless/ti/wl18xx/acx.h
@@ -23,6 +23,7 @@
 #define __WL18XX_ACX_H__
 
 #include "../wlcore/wlcore.h"
+#include "../wlcore/acx.h"
 
 /* numbers of bits the length field takes (add 1 for the actual number) */
 #define WL18XX_HOST_IF_LEN_SIZE_FIELD 15
@@ -60,9 +61,205 @@ struct wl18xx_acx_checksum_state {
 	u8 pad[3];
 } __packed;
 
+struct wl18xx_acx_debug_stats {
+	u32 debug1;
+	u32 debug2;
+	u32 debug3;
+	u32 debug4;
+	u32 debug5;
+	u32 debug6;
+} __packed;
+
+struct wl18xx_acx_ring_stats {
+	u32 tx_procs;
+	u32 prepared_descs;
+	u32 tx_xfr;
+	u32 tx_dma;
+	u32 tx_cmplt;
+	u32 rx_procs;
+	u32 rx_data;
+} __packed;
+
+struct wl18xx_acx_tx_stats {
+	u32 tx_template_prepared;
+	u32 tx_data_prepared;
+	u32 tx_template_programmed;
+	u32 tx_data_programmed;
+	u32 tx_burst_programmed;
+	u32 tx_starts;
+	u32 tx_imm_resp;
+	u32 tx_start_templates;
+	u32 tx_start_int_templates;
+	u32 tx_start_fw_gen;
+	u32 tx_start_data;
+	u32 tx_start_null_frame;
+	u32 tx_exch;
+	u32 tx_retry_template;
+	u32 tx_retry_data;
+	u32 tx_exch_pending;
+	u32 tx_exch_expiry;
+	u32 tx_exch_mismatch;
+	u32 tx_done_template;
+	u32 tx_done_data;
+	u32 tx_done_int_template;
+	u32 tx_pre_xfr;
+	u32 tx_xfr;
+	u32 tx_xfr_out_of_mem;
+	u32 tx_dma_programmed;
+	u32 tx_dma_done;
+} __packed;
+
+struct wl18xx_acx_rx_stats {
+	u32 rx_out_of_mem;
+	u32 rx_hdr_overflow;
+	u32 rx_hw_stuck;
+	u32 rx_dropped_frame;
+	u32 rx_complete_dropped_frame;
+	u32 rx_alloc_frame;
+	u32 rx_done_queue;
+	u32 rx_done;
+	u32 rx_defrag;
+	u32 rx_defrag_end;
+	u32 rx_mic;
+	u32 rx_mic_end;
+	u32 rx_xfr;
+	u32 rx_xfr_end;
+	u32 rx_cmplt;
+	u32 rx_pre_complt;
+	u32 rx_cmplt_task;
+	u32 rx_phy_hdr;
+	u32 rx_timeout;
+} __packed;
+
+struct wl18xx_acx_dma_stats {
+	u32 rx_dma_errors;
+	u32 tx_dma_errors;
+} __packed;
+
+struct wl18xx_acx_isr_stats {
+	u32 irqs;
+} __packed;
+
+struct wl18xx_acx_wep_stats {
+	u32 wep_add_key_count;
+	u32 wep_default_key_count;
+	u32 wep_key_not_found;
+	u32 wep_decrypt_fail;
+	u32 wep_encrypt_fail;
+	u32 wep_dec_packets;
+	u32 wep_dec_interrupt;
+	u32 wep_enc_packets;
+	u32 wep_enc_interrupts;
+} __packed;
+
+#define PWR_STAT_MAX_CONT_MISSED_BCNS_SPREAD 10
+
+struct wl18xx_acx_pwr_stats {
+	u32 missing_bcns_cnt;
+	u32 rcvd_bcns_cnt;
+	u32 connection_out_of_sync;
+	u32 cont_miss_bcns_spread[PWR_STAT_MAX_CONT_MISSED_BCNS_SPREAD];
+	u32 rcvd_awake_bcns_cnt;
+} __packed;
+
+struct wl18xx_acx_mic_stats {
+	u32 mic_rx_pkts;
+	u32 mic_calc_failure;
+} __packed;
+
+struct wl18xx_acx_aes_stats {
+	u32 aes_encrypt_fail;
+	u32 aes_decrypt_fail;
+	u32 aes_encrypt_packets;
+	u32 aes_decrypt_packets;
+	u32 aes_encrypt_interrupt;
+	u32 aes_decrypt_interrupt;
+} __packed;
+
+struct wl18xx_acx_gem_stats {
+	u32 gem_encrypt_fail;
+	u32 gem_decrypt_fail;
+	u32 gem_encrypt_packets;
+	u32 gem_decrypt_packets;
+	u32 gem_encrypt_interrupt;
+	u32 gem_decrypt_interrupt;
+} __packed;
+
+struct wl18xx_acx_event_stats {
+	u32 calibration;
+	u32 rx_mismatch;
+	u32 rx_mem_empty;
+} __packed;
+
+struct wl18xx_acx_ps_poll_stats {
+	u32 ps_poll_timeouts;
+	u32 upsd_timeouts;
+	u32 upsd_max_ap_turn;
+	u32 ps_poll_max_ap_turn;
+	u32 ps_poll_utilization;
+	u32 upsd_utilization;
+} __packed;
+
+struct wl18xx_acx_rx_filter_stats {
+	u32 beacon_filter;
+	u32 arp_filter;
+	u32 mc_filter;
+	u32 dup_filter;
+	u32 data_filter;
+	u32 ibss_filter;
+	u32 protection_filter;
+} __packed;
+
+struct wl18xx_acx_calibration_stats {
+	u32 init_cal_total;
+	u32 init_radio_bands_fail;
+	u32 init_set_params;
+	u32 init_tx_clpc_fail;
+	u32 init_rx_iw_mm_fail;
+	u32 tune_cal_total;
+	u32 tune_drpw_rtrim_fail;
+	u32 tune_drpw_pd_buf_fail;
+	u32 tune_drpw_tx_mix_freq_fail;
+	u32 tune_drpw_ta_cal;
+	u32 tune_drpw_rx_if_2_gain;
+	u32 tune_drpw_rx_dac;
+	u32 tune_drpw_chan_tune;
+	u32 tune_drpw_rx_tx_lpf;
+	u32 tune_drpw_lna_tank;
+	u32 tune_tx_lo_leak_fail;
+	u32 tune_tx_iq_mm_fail;
+	u32 tune_tx_pdet_fail;
+	u32 tune_tx_ppa_fail;
+	u32 tune_tx_clpc_fail;
+	u32 tune_rx_ana_dc_fail;
+	u32 tune_rx_dig_dc_fail; /* check if this is needed */
+	u32 tune_rx_iq_mm_fail;
+	u32 cal_state_fail;
+} __packed;
+
+struct wl18xx_acx_statistics {
+	struct acx_header header;
+
+	struct wl18xx_acx_ring_stats		ring;
+	struct wl18xx_acx_debug_stats		debug;
+	struct wl18xx_acx_tx_stats		tx;
+	struct wl18xx_acx_rx_stats		rx;
+	struct wl18xx_acx_dma_stats		dma;
+	struct wl18xx_acx_isr_stats		isr;
+	struct wl18xx_acx_wep_stats		wep;
+	struct wl18xx_acx_pwr_stats		pwr;
+	struct wl18xx_acx_aes_stats		aes;
+	struct wl18xx_acx_mic_stats		mic;
+	struct wl18xx_acx_event_stats		event;
+	struct wl18xx_acx_ps_poll_stats		ps_poll;
+	struct wl18xx_acx_rx_filter_stats	rx_filter;
+	struct wl18xx_acx_calibration_stats	calibration;
+	struct wl18xx_acx_gem_stats		gem;
+} __packed;
+
 int wl18xx_acx_host_if_cfg_bitmap(struct wl1271 *wl, u32 host_cfg_bitmap,
 				  u32 sdio_blk_size, u32 extra_mem_blks,
 				  u32 len_field_size);
 int wl18xx_acx_set_checksum_state(struct wl1271 *wl);
 
-#endif /* __WL12XX_ACX_H__ */
+#endif /* __WL18XX_ACX_H__ */
diff --git a/drivers/net/wireless/ti/wl18xx/debugfs.c b/drivers/net/wireless/ti/wl18xx/debugfs.c
new file mode 100644
index 0000000..8354dfc
--- /dev/null
+++ b/drivers/net/wireless/ti/wl18xx/debugfs.c
@@ -0,0 +1,345 @@
+/*
+ * This file is part of wl18xx
+ *
+ * Copyright (C) 2009 Nokia Corporation
+ * Copyright (C) 2011-2012 Texas Instruments
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include "../wlcore/debugfs.h"
+#include "../wlcore/wlcore.h"
+
+#include "wl18xx.h"
+#include "acx.h"
+#include "debugfs.h"
+
+#define WL18XX_DEBUGFS_FWSTATS_FILE(a, b, c) \
+	DEBUGFS_FWSTATS_FILE(a, b, c, wl18xx_acx_statistics)
+#define WL18XX_DEBUGFS_FWSTATS_FILE_ARRAY(a, b, c) \
+	DEBUGFS_FWSTATS_FILE_ARRAY(a, b, c, wl18xx_acx_statistics)
+
+WL18XX_DEBUGFS_FWSTATS_FILE(debug, debug1, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(debug, debug2, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(debug, debug3, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(debug, debug4, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(debug, debug5, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(debug, debug6, "%u");
+
+WL18XX_DEBUGFS_FWSTATS_FILE(ring, tx_procs, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(ring, prepared_descs, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(ring, tx_xfr, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(ring, tx_dma, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(ring, tx_cmplt, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(ring, rx_procs, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(ring, rx_data, "%u");
+
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_template_prepared, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_data_prepared, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_template_programmed, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_data_programmed, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_burst_programmed, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_starts, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_imm_resp, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_start_templates, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_start_int_templates, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_start_fw_gen, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_start_data, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_start_null_frame, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_exch, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_retry_template, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_retry_data, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_exch_pending, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_exch_expiry, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_exch_mismatch, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_done_template, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_done_data, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_done_int_template, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_pre_xfr, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_xfr, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_xfr_out_of_mem, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_dma_programmed, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(tx, tx_dma_done, "%u");
+
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_out_of_mem, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_hdr_overflow, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_hw_stuck, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_dropped_frame, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_complete_dropped_frame, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_alloc_frame, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_done_queue, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_done, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_defrag, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_defrag_end, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_mic, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_mic_end, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_xfr, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_xfr_end, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_cmplt, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_pre_complt, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_cmplt_task, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_phy_hdr, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx, rx_timeout, "%u");
+
+WL18XX_DEBUGFS_FWSTATS_FILE(dma, rx_dma_errors, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(dma, tx_dma_errors, "%u");
+
+WL18XX_DEBUGFS_FWSTATS_FILE(isr, irqs, "%u");
+
+WL18XX_DEBUGFS_FWSTATS_FILE(wep, wep_add_key_count, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(wep, wep_default_key_count, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(wep, wep_key_not_found, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(wep, wep_decrypt_fail, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(wep, wep_encrypt_fail, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(wep, wep_dec_packets, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(wep, wep_dec_interrupt, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(wep, wep_enc_packets, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(wep, wep_enc_interrupts, "%u");
+
+WL18XX_DEBUGFS_FWSTATS_FILE(pwr, missing_bcns_cnt, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(pwr, rcvd_bcns_cnt, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(pwr, connection_out_of_sync, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE_ARRAY(pwr, cont_miss_bcns_spread,
+				  PWR_STAT_MAX_CONT_MISSED_BCNS_SPREAD);
+WL18XX_DEBUGFS_FWSTATS_FILE(pwr, rcvd_awake_bcns_cnt, "%u");
+
+WL18XX_DEBUGFS_FWSTATS_FILE(mic, mic_rx_pkts, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(mic, mic_calc_failure, "%u");
+
+WL18XX_DEBUGFS_FWSTATS_FILE(aes, aes_encrypt_fail, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(aes, aes_decrypt_fail, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(aes, aes_encrypt_packets, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(aes, aes_decrypt_packets, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(aes, aes_encrypt_interrupt, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(aes, aes_decrypt_interrupt, "%u");
+
+WL18XX_DEBUGFS_FWSTATS_FILE(gem, gem_encrypt_fail, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(gem, gem_decrypt_fail, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(gem, gem_encrypt_packets, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(gem, gem_decrypt_packets, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(gem, gem_encrypt_interrupt, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(gem, gem_decrypt_interrupt, "%u");
+
+WL18XX_DEBUGFS_FWSTATS_FILE(event, calibration, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(event, rx_mismatch, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(event, rx_mem_empty, "%u");
+
+WL18XX_DEBUGFS_FWSTATS_FILE(ps_poll, ps_poll_timeouts, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(ps_poll, upsd_timeouts, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(ps_poll, upsd_max_ap_turn, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(ps_poll, ps_poll_max_ap_turn, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(ps_poll, ps_poll_utilization, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(ps_poll, upsd_utilization, "%u");
+
+WL18XX_DEBUGFS_FWSTATS_FILE(rx_filter, beacon_filter, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx_filter, arp_filter, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx_filter, mc_filter, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx_filter, dup_filter, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx_filter, data_filter, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx_filter, ibss_filter, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(rx_filter, protection_filter, "%u");
+
+WL18XX_DEBUGFS_FWSTATS_FILE(calibration, init_cal_total, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(calibration, init_radio_bands_fail, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(calibration, init_set_params, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(calibration, init_tx_clpc_fail, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(calibration, init_rx_iw_mm_fail, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_cal_total, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_drpw_rtrim_fail, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_drpw_pd_buf_fail, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_drpw_tx_mix_freq_fail, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_drpw_ta_cal, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_drpw_rx_if_2_gain, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_drpw_rx_dac, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_drpw_chan_tune, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_drpw_rx_tx_lpf, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_drpw_lna_tank, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_tx_lo_leak_fail, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_tx_iq_mm_fail, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_tx_pdet_fail, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_tx_ppa_fail, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_tx_clpc_fail, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_rx_ana_dc_fail, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_rx_dig_dc_fail, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(calibration, tune_rx_iq_mm_fail, "%u");
+WL18XX_DEBUGFS_FWSTATS_FILE(calibration, cal_state_fail, "%u");
+
+int wl18xx_debugfs_add_files(struct wl1271 *wl,
+			     struct dentry *rootdir)
+{
+	int ret = 0;
+	struct dentry *entry, *stats;
+
+	stats = debugfs_create_dir("wl18xx_fw_stats", rootdir);
+	if (!stats || IS_ERR(stats)) {
+		entry = stats;
+		goto err;
+	}
+
+	DEBUGFS_FWSTATS_ADD(debug, debug1);
+	DEBUGFS_FWSTATS_ADD(debug, debug2);
+	DEBUGFS_FWSTATS_ADD(debug, debug3);
+	DEBUGFS_FWSTATS_ADD(debug, debug4);
+	DEBUGFS_FWSTATS_ADD(debug, debug5);
+	DEBUGFS_FWSTATS_ADD(debug, debug6);
+
+	DEBUGFS_FWSTATS_ADD(ring, tx_procs);
+	DEBUGFS_FWSTATS_ADD(ring, prepared_descs);
+	DEBUGFS_FWSTATS_ADD(ring, tx_xfr);
+	DEBUGFS_FWSTATS_ADD(ring, tx_dma);
+	DEBUGFS_FWSTATS_ADD(ring, tx_cmplt);
+	DEBUGFS_FWSTATS_ADD(ring, rx_procs);
+	DEBUGFS_FWSTATS_ADD(ring, rx_data);
+
+	DEBUGFS_FWSTATS_ADD(tx, tx_template_prepared);
+	DEBUGFS_FWSTATS_ADD(tx, tx_data_prepared);
+	DEBUGFS_FWSTATS_ADD(tx, tx_template_programmed);
+	DEBUGFS_FWSTATS_ADD(tx, tx_data_programmed);
+	DEBUGFS_FWSTATS_ADD(tx, tx_burst_programmed);
+	DEBUGFS_FWSTATS_ADD(tx, tx_starts);
+	DEBUGFS_FWSTATS_ADD(tx, tx_imm_resp);
+	DEBUGFS_FWSTATS_ADD(tx, tx_start_templates);
+	DEBUGFS_FWSTATS_ADD(tx, tx_start_int_templates);
+	DEBUGFS_FWSTATS_ADD(tx, tx_start_fw_gen);
+	DEBUGFS_FWSTATS_ADD(tx, tx_start_data);
+	DEBUGFS_FWSTATS_ADD(tx, tx_start_null_frame);
+	DEBUGFS_FWSTATS_ADD(tx, tx_exch);
+	DEBUGFS_FWSTATS_ADD(tx, tx_retry_template);
+	DEBUGFS_FWSTATS_ADD(tx, tx_retry_data);
+	DEBUGFS_FWSTATS_ADD(tx, tx_exch_pending);
+	DEBUGFS_FWSTATS_ADD(tx, tx_exch_expiry);
+	DEBUGFS_FWSTATS_ADD(tx, tx_exch_mismatch);
+	DEBUGFS_FWSTATS_ADD(tx, tx_done_template);
+	DEBUGFS_FWSTATS_ADD(tx, tx_done_data);
+	DEBUGFS_FWSTATS_ADD(tx, tx_done_int_template);
+	DEBUGFS_FWSTATS_ADD(tx, tx_pre_xfr);
+	DEBUGFS_FWSTATS_ADD(tx, tx_xfr);
+	DEBUGFS_FWSTATS_ADD(tx, tx_xfr_out_of_mem);
+	DEBUGFS_FWSTATS_ADD(tx, tx_dma_programmed);
+	DEBUGFS_FWSTATS_ADD(tx, tx_dma_done);
+
+	DEBUGFS_FWSTATS_ADD(rx, rx_out_of_mem);
+	DEBUGFS_FWSTATS_ADD(rx, rx_hdr_overflow);
+	DEBUGFS_FWSTATS_ADD(rx, rx_hw_stuck);
+	DEBUGFS_FWSTATS_ADD(rx, rx_dropped_frame);
+	DEBUGFS_FWSTATS_ADD(rx, rx_complete_dropped_frame);
+	DEBUGFS_FWSTATS_ADD(rx, rx_alloc_frame);
+	DEBUGFS_FWSTATS_ADD(rx, rx_done_queue);
+	DEBUGFS_FWSTATS_ADD(rx, rx_done);
+	DEBUGFS_FWSTATS_ADD(rx, rx_defrag);
+	DEBUGFS_FWSTATS_ADD(rx, rx_defrag_end);
+	DEBUGFS_FWSTATS_ADD(rx, rx_mic);
+	DEBUGFS_FWSTATS_ADD(rx, rx_mic_end);
+	DEBUGFS_FWSTATS_ADD(rx, rx_xfr);
+	DEBUGFS_FWSTATS_ADD(rx, rx_xfr_end);
+	DEBUGFS_FWSTATS_ADD(rx, rx_cmplt);
+	DEBUGFS_FWSTATS_ADD(rx, rx_pre_complt);
+	DEBUGFS_FWSTATS_ADD(rx, rx_cmplt_task);
+	DEBUGFS_FWSTATS_ADD(rx, rx_phy_hdr);
+	DEBUGFS_FWSTATS_ADD(rx, rx_timeout);
+
+	DEBUGFS_FWSTATS_ADD(dma, rx_dma_errors);
+	DEBUGFS_FWSTATS_ADD(dma, tx_dma_errors);
+
+	DEBUGFS_FWSTATS_ADD(isr, irqs);
+
+	DEBUGFS_FWSTATS_ADD(wep, wep_add_key_count);
+	DEBUGFS_FWSTATS_ADD(wep, wep_default_key_count);
+	DEBUGFS_FWSTATS_ADD(wep, wep_key_not_found);
+	DEBUGFS_FWSTATS_ADD(wep, wep_decrypt_fail);
+	DEBUGFS_FWSTATS_ADD(wep, wep_encrypt_fail);
+	DEBUGFS_FWSTATS_ADD(wep, wep_dec_packets);
+	DEBUGFS_FWSTATS_ADD(wep, wep_dec_interrupt);
+	DEBUGFS_FWSTATS_ADD(wep, wep_enc_packets);
+	DEBUGFS_FWSTATS_ADD(wep, wep_enc_interrupts);
+
+	DEBUGFS_FWSTATS_ADD(pwr, missing_bcns_cnt);
+	DEBUGFS_FWSTATS_ADD(pwr, rcvd_bcns_cnt);
+	DEBUGFS_FWSTATS_ADD(pwr, connection_out_of_sync);
+	DEBUGFS_FWSTATS_ADD(pwr, cont_miss_bcns_spread);
+	DEBUGFS_FWSTATS_ADD(pwr, rcvd_awake_bcns_cnt);
+
+	DEBUGFS_FWSTATS_ADD(mic, mic_rx_pkts);
+	DEBUGFS_FWSTATS_ADD(mic, mic_calc_failure);
+
+	DEBUGFS_FWSTATS_ADD(aes, aes_encrypt_fail);
+	DEBUGFS_FWSTATS_ADD(aes, aes_decrypt_fail);
+	DEBUGFS_FWSTATS_ADD(aes, aes_encrypt_packets);
+	DEBUGFS_FWSTATS_ADD(aes, aes_decrypt_packets);
+	DEBUGFS_FWSTATS_ADD(aes, aes_encrypt_interrupt);
+	DEBUGFS_FWSTATS_ADD(aes, aes_decrypt_interrupt);
+
+	DEBUGFS_FWSTATS_ADD(gem, gem_encrypt_fail);
+	DEBUGFS_FWSTATS_ADD(gem, gem_decrypt_fail);
+	DEBUGFS_FWSTATS_ADD(gem, gem_encrypt_packets);
+	DEBUGFS_FWSTATS_ADD(gem, gem_decrypt_packets);
+	DEBUGFS_FWSTATS_ADD(gem, gem_encrypt_interrupt);
+	DEBUGFS_FWSTATS_ADD(gem, gem_decrypt_interrupt);
+
+	DEBUGFS_FWSTATS_ADD(event, calibration);
+	DEBUGFS_FWSTATS_ADD(event, rx_mismatch);
+	DEBUGFS_FWSTATS_ADD(event, rx_mem_empty);
+
+	DEBUGFS_FWSTATS_ADD(ps_poll, ps_poll_timeouts);
+	DEBUGFS_FWSTATS_ADD(ps_poll, upsd_timeouts);
+	DEBUGFS_FWSTATS_ADD(ps_poll, upsd_max_ap_turn);
+	DEBUGFS_FWSTATS_ADD(ps_poll, ps_poll_max_ap_turn);
+	DEBUGFS_FWSTATS_ADD(ps_poll, ps_poll_utilization);
+	DEBUGFS_FWSTATS_ADD(ps_poll, upsd_utilization);
+
+	DEBUGFS_FWSTATS_ADD(rx_filter, beacon_filter);
+	DEBUGFS_FWSTATS_ADD(rx_filter, arp_filter);
+	DEBUGFS_FWSTATS_ADD(rx_filter, mc_filter);
+	DEBUGFS_FWSTATS_ADD(rx_filter, dup_filter);
+	DEBUGFS_FWSTATS_ADD(rx_filter, data_filter);
+	DEBUGFS_FWSTATS_ADD(rx_filter, ibss_filter);
+	DEBUGFS_FWSTATS_ADD(rx_filter, protection_filter);
+
+	DEBUGFS_FWSTATS_ADD(calibration, init_cal_total);
+	DEBUGFS_FWSTATS_ADD(calibration, init_radio_bands_fail);
+	DEBUGFS_FWSTATS_ADD(calibration, init_set_params);
+	DEBUGFS_FWSTATS_ADD(calibration, init_tx_clpc_fail);
+	DEBUGFS_FWSTATS_ADD(calibration, init_rx_iw_mm_fail);
+	DEBUGFS_FWSTATS_ADD(calibration, tune_cal_total);
+	DEBUGFS_FWSTATS_ADD(calibration, tune_drpw_rtrim_fail);
+	DEBUGFS_FWSTATS_ADD(calibration, tune_drpw_pd_buf_fail);
+	DEBUGFS_FWSTATS_ADD(calibration, tune_drpw_tx_mix_freq_fail);
+	DEBUGFS_FWSTATS_ADD(calibration, tune_drpw_ta_cal);
+	DEBUGFS_FWSTATS_ADD(calibration, tune_drpw_rx_if_2_gain);
+	DEBUGFS_FWSTATS_ADD(calibration, tune_drpw_rx_dac);
+	DEBUGFS_FWSTATS_ADD(calibration, tune_drpw_chan_tune);
+	DEBUGFS_FWSTATS_ADD(calibration, tune_drpw_rx_tx_lpf);
+	DEBUGFS_FWSTATS_ADD(calibration, tune_drpw_lna_tank);
+	DEBUGFS_FWSTATS_ADD(calibration, tune_tx_lo_leak_fail);
+	DEBUGFS_FWSTATS_ADD(calibration, tune_tx_iq_mm_fail);
+	DEBUGFS_FWSTATS_ADD(calibration, tune_tx_pdet_fail);
+	DEBUGFS_FWSTATS_ADD(calibration, tune_tx_ppa_fail);
+	DEBUGFS_FWSTATS_ADD(calibration, tune_tx_clpc_fail);
+	DEBUGFS_FWSTATS_ADD(calibration, tune_rx_ana_dc_fail);
+	DEBUGFS_FWSTATS_ADD(calibration, tune_rx_dig_dc_fail);
+	DEBUGFS_FWSTATS_ADD(calibration, tune_rx_iq_mm_fail);
+	DEBUGFS_FWSTATS_ADD(calibration, cal_state_fail);
+
+	return 0;
+
+err:
+	if (IS_ERR(entry))
+		ret = PTR_ERR(entry);
+	else
+		ret = -ENOMEM;
+
+	return ret;
+}
diff --git a/drivers/net/wireless/ti/wl18xx/debugfs.h b/drivers/net/wireless/ti/wl18xx/debugfs.h
new file mode 100644
index 0000000..ed679be
--- /dev/null
+++ b/drivers/net/wireless/ti/wl18xx/debugfs.h
@@ -0,0 +1,28 @@
+/*
+ * This file is part of wl18xx
+ *
+ * Copyright (C) 2012 Texas Instruments. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __WL18XX_DEBUGFS_H__
+#define __WL18XX_DEBUGFS_H__
+
+int wl18xx_debugfs_add_files(struct wl1271 *wl,
+			     struct dentry *rootdir);
+
+#endif /* __WL18XX_DEBUGFS_H__ */
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index afa2334..24673e3 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -38,7 +38,7 @@
 #include "tx.h"
 #include "wl18xx.h"
 #include "io.h"
-
+#include "debugfs.h"
 
 #define WL18XX_RX_CHECKSUM_MASK      0x40
 
@@ -1011,6 +1011,11 @@ static void wl18xx_get_mac(struct wl1271 *wl)
 	wlcore_set_partition(wl, &wl->ptable[PART_DOWN]);
 }
 
+static int wl18xx_debugfs_init(struct wl1271 *wl, struct dentry *rootdir)
+{
+	return wl18xx_debugfs_add_files(wl, rootdir);
+}
+
 static struct wlcore_ops wl18xx_ops = {
 	.identify_chip	= wl18xx_identify_chip,
 	.boot		= wl18xx_boot,
@@ -1031,6 +1036,7 @@ static struct wlcore_ops wl18xx_ops = {
 	.sta_get_ap_rate_mask = wl18xx_sta_get_ap_rate_mask,
 	.ap_get_mimo_wide_rate_mask = wl18xx_ap_get_mimo_wide_rate_mask,
 	.get_mac	= wl18xx_get_mac,
+	.debugfs_init	= wl18xx_debugfs_init,
 };
 
 /* HT cap appropriate for wide channels */
@@ -1085,6 +1091,7 @@ int __devinit wl18xx_probe(struct platform_device *pdev)
 	wl->hw_tx_rate_tbl_size = WL18XX_CONF_HW_RXTX_RATE_MAX;
 	wl->hw_min_ht_rate = WL18XX_CONF_HW_RXTX_RATE_MCS0;
 	wl->fw_status_priv_len = sizeof(struct wl18xx_fw_status_priv);
+	wl->stats.fw_stats_len = sizeof(struct wl18xx_acx_statistics);
 	memcpy(&wl->ht_cap, &wl18xx_ht_cap, sizeof(wl18xx_ht_cap));
 	if (ht_mode_param && !strcmp(ht_mode_param, "mimo"))
 		memcpy(&wl->ht_cap, &wl18xx_mimo_ht_cap,
-- 
1.7.9.5

