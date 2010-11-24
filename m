Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55642 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab0KXJfU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 04:35:20 -0500
Received: by bwz15 with SMTP id 15so8012068bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Nov 2010 01:35:18 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl1271: use debugfs_remove_recursive
Date: Wed, 24 Nov 2010 11:35:33 +0200
Message-Id: <1290591333-30453-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Documentation/filesystems/debugfs.txt:
"""
Once upon a time, debugfs users were required to remember the dentry pointer
for every debugfs file they created so that all files could be cleaned up.
We live in more civilized times now, though, and debugfs users can call:

    void debugfs_remove_recursive(struct dentry *dentry);
"""

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |  181 ++++++---------------------------
 drivers/net/wireless/wl12xx/wl12xx.h  |  104 +-------------------
 2 files changed, 32 insertions(+), 253 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index dd71b7d..402df14 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -66,19 +66,10 @@ static const struct file_operations name## _ops = {			\
 };
 
 #define DEBUGFS_ADD(name, parent)					\
-	wl->debugfs.name = debugfs_create_file(#name, 0400, parent,	\
-					       wl, &name## _ops);	\
-	if (IS_ERR(wl->debugfs.name)) {					\
-		ret = PTR_ERR(wl->debugfs.name);			\
-		wl->debugfs.name = NULL;				\
-		goto out;						\
-	}
-
-#define DEBUGFS_DEL(name)						\
-	do {								\
-		debugfs_remove(wl->debugfs.name);			\
-		wl->debugfs.name = NULL;				\
-	} while (0)
+	entry = debugfs_create_file(#name, 0400, parent,		\
+				    wl, &name## _ops);			\
+	if (!entry || IS_ERR(entry))					\
+		goto err;						\
 
 #define DEBUGFS_FWSTATS_FILE(sub, name, fmt)				\
 static ssize_t sub## _ ##name## _read(struct file *file,		\
@@ -100,10 +91,7 @@ static const struct file_operations sub## _ ##name## _ops = {		\
 };
 
 #define DEBUGFS_FWSTATS_ADD(sub, name)				\
-	DEBUGFS_ADD(sub## _ ##name, wl->debugfs.fw_statistics)
-
-#define DEBUGFS_FWSTATS_DEL(sub, name)				\
-	DEBUGFS_DEL(sub## _ ##name)
+	DEBUGFS_ADD(sub## _ ##name, stats)
 
 static void wl1271_debugfs_update_stats(struct wl1271 *wl)
 {
@@ -305,109 +293,16 @@ static const struct file_operations gpio_power_ops = {
 	.llseek = default_llseek,
 };
 
-static void wl1271_debugfs_delete_files(struct wl1271 *wl)
-{
-	DEBUGFS_FWSTATS_DEL(tx, internal_desc_overflow);
-
-	DEBUGFS_FWSTATS_DEL(rx, out_of_mem);
-	DEBUGFS_FWSTATS_DEL(rx, hdr_overflow);
-	DEBUGFS_FWSTATS_DEL(rx, hw_stuck);
-	DEBUGFS_FWSTATS_DEL(rx, dropped);
-	DEBUGFS_FWSTATS_DEL(rx, fcs_err);
-	DEBUGFS_FWSTATS_DEL(rx, xfr_hint_trig);
-	DEBUGFS_FWSTATS_DEL(rx, path_reset);
-	DEBUGFS_FWSTATS_DEL(rx, reset_counter);
-
-	DEBUGFS_FWSTATS_DEL(dma, rx_requested);
-	DEBUGFS_FWSTATS_DEL(dma, rx_errors);
-	DEBUGFS_FWSTATS_DEL(dma, tx_requested);
-	DEBUGFS_FWSTATS_DEL(dma, tx_errors);
-
-	DEBUGFS_FWSTATS_DEL(isr, cmd_cmplt);
-	DEBUGFS_FWSTATS_DEL(isr, fiqs);
-	DEBUGFS_FWSTATS_DEL(isr, rx_headers);
-	DEBUGFS_FWSTATS_DEL(isr, rx_mem_overflow);
-	DEBUGFS_FWSTATS_DEL(isr, rx_rdys);
-	DEBUGFS_FWSTATS_DEL(isr, irqs);
-	DEBUGFS_FWSTATS_DEL(isr, tx_procs);
-	DEBUGFS_FWSTATS_DEL(isr, decrypt_done);
-	DEBUGFS_FWSTATS_DEL(isr, dma0_done);
-	DEBUGFS_FWSTATS_DEL(isr, dma1_done);
-	DEBUGFS_FWSTATS_DEL(isr, tx_exch_complete);
-	DEBUGFS_FWSTATS_DEL(isr, commands);
-	DEBUGFS_FWSTATS_DEL(isr, rx_procs);
-	DEBUGFS_FWSTATS_DEL(isr, hw_pm_mode_changes);
-	DEBUGFS_FWSTATS_DEL(isr, host_acknowledges);
-	DEBUGFS_FWSTATS_DEL(isr, pci_pm);
-	DEBUGFS_FWSTATS_DEL(isr, wakeups);
-	DEBUGFS_FWSTATS_DEL(isr, low_rssi);
-
-	DEBUGFS_FWSTATS_DEL(wep, addr_key_count);
-	DEBUGFS_FWSTATS_DEL(wep, default_key_count);
-	/* skipping wep.reserved */
-	DEBUGFS_FWSTATS_DEL(wep, key_not_found);
-	DEBUGFS_FWSTATS_DEL(wep, decrypt_fail);
-	DEBUGFS_FWSTATS_DEL(wep, packets);
-	DEBUGFS_FWSTATS_DEL(wep, interrupt);
-
-	DEBUGFS_FWSTATS_DEL(pwr, ps_enter);
-	DEBUGFS_FWSTATS_DEL(pwr, elp_enter);
-	DEBUGFS_FWSTATS_DEL(pwr, missing_bcns);
-	DEBUGFS_FWSTATS_DEL(pwr, wake_on_host);
-	DEBUGFS_FWSTATS_DEL(pwr, wake_on_timer_exp);
-	DEBUGFS_FWSTATS_DEL(pwr, tx_with_ps);
-	DEBUGFS_FWSTATS_DEL(pwr, tx_without_ps);
-	DEBUGFS_FWSTATS_DEL(pwr, rcvd_beacons);
-	DEBUGFS_FWSTATS_DEL(pwr, power_save_off);
-	DEBUGFS_FWSTATS_DEL(pwr, enable_ps);
-	DEBUGFS_FWSTATS_DEL(pwr, disable_ps);
-	DEBUGFS_FWSTATS_DEL(pwr, fix_tsf_ps);
-	/* skipping cont_miss_bcns_spread for now */
-	DEBUGFS_FWSTATS_DEL(pwr, rcvd_awake_beacons);
-
-	DEBUGFS_FWSTATS_DEL(mic, rx_pkts);
-	DEBUGFS_FWSTATS_DEL(mic, calc_failure);
-
-	DEBUGFS_FWSTATS_DEL(aes, encrypt_fail);
-	DEBUGFS_FWSTATS_DEL(aes, decrypt_fail);
-	DEBUGFS_FWSTATS_DEL(aes, encrypt_packets);
-	DEBUGFS_FWSTATS_DEL(aes, decrypt_packets);
-	DEBUGFS_FWSTATS_DEL(aes, encrypt_interrupt);
-	DEBUGFS_FWSTATS_DEL(aes, decrypt_interrupt);
-
-	DEBUGFS_FWSTATS_DEL(event, heart_beat);
-	DEBUGFS_FWSTATS_DEL(event, calibration);
-	DEBUGFS_FWSTATS_DEL(event, rx_mismatch);
-	DEBUGFS_FWSTATS_DEL(event, rx_mem_empty);
-	DEBUGFS_FWSTATS_DEL(event, rx_pool);
-	DEBUGFS_FWSTATS_DEL(event, oom_late);
-	DEBUGFS_FWSTATS_DEL(event, phy_transmit_error);
-	DEBUGFS_FWSTATS_DEL(event, tx_stuck);
-
-	DEBUGFS_FWSTATS_DEL(ps, pspoll_timeouts);
-	DEBUGFS_FWSTATS_DEL(ps, upsd_timeouts);
-	DEBUGFS_FWSTATS_DEL(ps, upsd_max_sptime);
-	DEBUGFS_FWSTATS_DEL(ps, upsd_max_apturn);
-	DEBUGFS_FWSTATS_DEL(ps, pspoll_max_apturn);
-	DEBUGFS_FWSTATS_DEL(ps, pspoll_utilization);
-	DEBUGFS_FWSTATS_DEL(ps, upsd_utilization);
-
-	DEBUGFS_FWSTATS_DEL(rxpipe, rx_prep_beacon_drop);
-	DEBUGFS_FWSTATS_DEL(rxpipe, descr_host_int_trig_rx_data);
-	DEBUGFS_FWSTATS_DEL(rxpipe, beacon_buffer_thres_host_int_trig_rx_data);
-	DEBUGFS_FWSTATS_DEL(rxpipe, missed_beacon_host_int_trig_rx_data);
-	DEBUGFS_FWSTATS_DEL(rxpipe, tx_xfr_host_int_trig_rx_data);
-
-	DEBUGFS_DEL(tx_queue_len);
-	DEBUGFS_DEL(retry_count);
-	DEBUGFS_DEL(excessive_retries);
-
-	DEBUGFS_DEL(gpio_power);
-}
-
 static int wl1271_debugfs_add_files(struct wl1271 *wl)
 {
 	int ret = 0;
+	struct dentry *entry, *stats;
+
+	stats = debugfs_create_dir("fw-statistics", wl->rootdir);
+	if (!stats || IS_ERR(stats)) {
+		entry = stats;
+		goto err;
+	}
 
 	DEBUGFS_FWSTATS_ADD(tx, internal_desc_overflow);
 
@@ -500,15 +395,19 @@ static int wl1271_debugfs_add_files(struct wl1271 *wl)
 	DEBUGFS_FWSTATS_ADD(rxpipe, missed_beacon_host_int_trig_rx_data);
 	DEBUGFS_FWSTATS_ADD(rxpipe, tx_xfr_host_int_trig_rx_data);
 
-	DEBUGFS_ADD(tx_queue_len, wl->debugfs.rootdir);
-	DEBUGFS_ADD(retry_count, wl->debugfs.rootdir);
-	DEBUGFS_ADD(excessive_retries, wl->debugfs.rootdir);
+	DEBUGFS_ADD(tx_queue_len, wl->rootdir);
+	DEBUGFS_ADD(retry_count, wl->rootdir);
+	DEBUGFS_ADD(excessive_retries, wl->rootdir);
 
-	DEBUGFS_ADD(gpio_power, wl->debugfs.rootdir);
+	DEBUGFS_ADD(gpio_power, wl->rootdir);
 
-out:
-	if (ret < 0)
-		wl1271_debugfs_delete_files(wl);
+	return 0;
+
+err:
+	if (IS_ERR(entry))
+		ret = PTR_ERR(entry);
+	else
+		ret = -ENOMEM;
 
 	return ret;
 }
@@ -524,23 +423,14 @@ int wl1271_debugfs_init(struct wl1271 *wl)
 {
 	int ret;
 
-	wl->debugfs.rootdir = debugfs_create_dir(KBUILD_MODNAME, NULL);
+	wl->rootdir = debugfs_create_dir(KBUILD_MODNAME, NULL);
 
-	if (IS_ERR(wl->debugfs.rootdir)) {
-		ret = PTR_ERR(wl->debugfs.rootdir);
-		wl->debugfs.rootdir = NULL;
+	if (IS_ERR(wl->rootdir)) {
+		ret = PTR_ERR(wl->rootdir);
+		wl->rootdir = NULL;
 		goto err;
 	}
 
-	wl->debugfs.fw_statistics = debugfs_create_dir("fw-statistics",
-						       wl->debugfs.rootdir);
-
-	if (IS_ERR(wl->debugfs.fw_statistics)) {
-		ret = PTR_ERR(wl->debugfs.fw_statistics);
-		wl->debugfs.fw_statistics = NULL;
-		goto err_root;
-	}
-
 	wl->stats.fw_stats = kzalloc(sizeof(*wl->stats.fw_stats),
 				      GFP_KERNEL);
 
@@ -563,12 +453,8 @@ err_file:
 	wl->stats.fw_stats = NULL;
 
 err_fw:
-	debugfs_remove(wl->debugfs.fw_statistics);
-	wl->debugfs.fw_statistics = NULL;
-
-err_root:
-	debugfs_remove(wl->debugfs.rootdir);
-	wl->debugfs.rootdir = NULL;
+	debugfs_remove_recursive(wl->rootdir);
+	wl->rootdir = NULL;
 
 err:
 	return ret;
@@ -576,15 +462,10 @@ err:
 
 void wl1271_debugfs_exit(struct wl1271 *wl)
 {
-	wl1271_debugfs_delete_files(wl);
-
 	kfree(wl->stats.fw_stats);
 	wl->stats.fw_stats = NULL;
 
-	debugfs_remove(wl->debugfs.fw_statistics);
-	wl->debugfs.fw_statistics = NULL;
-
-	debugfs_remove(wl->debugfs.rootdir);
-	wl->debugfs.rootdir = NULL;
+	debugfs_remove_recursive(wl->rootdir);
+	wl->rootdir = NULL;
 
 }
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 3c836e6..e9ef286 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -174,108 +174,6 @@ struct wl1271_stats {
 	unsigned int excessive_retries;
 };
 
-struct wl1271_debugfs {
-	struct dentry *rootdir;
-	struct dentry *fw_statistics;
-
-	struct dentry *tx_internal_desc_overflow;
-
-	struct dentry *rx_out_of_mem;
-	struct dentry *rx_hdr_overflow;
-	struct dentry *rx_hw_stuck;
-	struct dentry *rx_dropped;
-	struct dentry *rx_fcs_err;
-	struct dentry *rx_xfr_hint_trig;
-	struct dentry *rx_path_reset;
-	struct dentry *rx_reset_counter;
-
-	struct dentry *dma_rx_requested;
-	struct dentry *dma_rx_errors;
-	struct dentry *dma_tx_requested;
-	struct dentry *dma_tx_errors;
-
-	struct dentry *isr_cmd_cmplt;
-	struct dentry *isr_fiqs;
-	struct dentry *isr_rx_headers;
-	struct dentry *isr_rx_mem_overflow;
-	struct dentry *isr_rx_rdys;
-	struct dentry *isr_irqs;
-	struct dentry *isr_tx_procs;
-	struct dentry *isr_decrypt_done;
-	struct dentry *isr_dma0_done;
-	struct dentry *isr_dma1_done;
-	struct dentry *isr_tx_exch_complete;
-	struct dentry *isr_commands;
-	struct dentry *isr_rx_procs;
-	struct dentry *isr_hw_pm_mode_changes;
-	struct dentry *isr_host_acknowledges;
-	struct dentry *isr_pci_pm;
-	struct dentry *isr_wakeups;
-	struct dentry *isr_low_rssi;
-
-	struct dentry *wep_addr_key_count;
-	struct dentry *wep_default_key_count;
-	/* skipping wep.reserved */
-	struct dentry *wep_key_not_found;
-	struct dentry *wep_decrypt_fail;
-	struct dentry *wep_packets;
-	struct dentry *wep_interrupt;
-
-	struct dentry *pwr_ps_enter;
-	struct dentry *pwr_elp_enter;
-	struct dentry *pwr_missing_bcns;
-	struct dentry *pwr_wake_on_host;
-	struct dentry *pwr_wake_on_timer_exp;
-	struct dentry *pwr_tx_with_ps;
-	struct dentry *pwr_tx_without_ps;
-	struct dentry *pwr_rcvd_beacons;
-	struct dentry *pwr_power_save_off;
-	struct dentry *pwr_enable_ps;
-	struct dentry *pwr_disable_ps;
-	struct dentry *pwr_fix_tsf_ps;
-	/* skipping cont_miss_bcns_spread for now */
-	struct dentry *pwr_rcvd_awake_beacons;
-
-	struct dentry *mic_rx_pkts;
-	struct dentry *mic_calc_failure;
-
-	struct dentry *aes_encrypt_fail;
-	struct dentry *aes_decrypt_fail;
-	struct dentry *aes_encrypt_packets;
-	struct dentry *aes_decrypt_packets;
-	struct dentry *aes_encrypt_interrupt;
-	struct dentry *aes_decrypt_interrupt;
-
-	struct dentry *event_heart_beat;
-	struct dentry *event_calibration;
-	struct dentry *event_rx_mismatch;
-	struct dentry *event_rx_mem_empty;
-	struct dentry *event_rx_pool;
-	struct dentry *event_oom_late;
-	struct dentry *event_phy_transmit_error;
-	struct dentry *event_tx_stuck;
-
-	struct dentry *ps_pspoll_timeouts;
-	struct dentry *ps_upsd_timeouts;
-	struct dentry *ps_upsd_max_sptime;
-	struct dentry *ps_upsd_max_apturn;
-	struct dentry *ps_pspoll_max_apturn;
-	struct dentry *ps_pspoll_utilization;
-	struct dentry *ps_upsd_utilization;
-
-	struct dentry *rxpipe_rx_prep_beacon_drop;
-	struct dentry *rxpipe_descr_host_int_trig_rx_data;
-	struct dentry *rxpipe_beacon_buffer_thres_host_int_trig_rx_data;
-	struct dentry *rxpipe_missed_beacon_host_int_trig_rx_data;
-	struct dentry *rxpipe_tx_xfr_host_int_trig_rx_data;
-
-	struct dentry *tx_queue_len;
-
-	struct dentry *retry_count;
-	struct dentry *excessive_retries;
-	struct dentry *gpio_power;
-};
-
 #define NUM_TX_QUEUES              4
 #define NUM_RX_PKT_DESC            8
 
@@ -475,7 +373,7 @@ struct wl1271 {
 	int last_rssi_event;
 
 	struct wl1271_stats stats;
-	struct wl1271_debugfs debugfs;
+	struct dentry *rootdir;
 
 	__le32 buffer_32;
 	u32 buffer_cmd;
-- 
1.7.0.4

