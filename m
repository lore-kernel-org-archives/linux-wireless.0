Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:63783 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756505Ab0J0M60 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Oct 2010 08:58:26 -0400
Received: by wwi18 with SMTP id 18so1529589wwi.1
        for <linux-wireless@vger.kernel.org>; Wed, 27 Oct 2010 05:58:24 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Luciano Coelho <luciano.coelho@nokia.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] wl1271: refactor debugfs function generation code
Date: Wed, 27 Oct 2010 14:58:30 +0200
Message-Id: <1288184310-6781-2-git-send-email-eliad@wizery.com>
In-Reply-To: <1288184310-6781-1-git-send-email-eliad@wizery.com>
References: <1288184310-6781-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

refactor wl1271_debugfs by using a format&copy function, instead of
duplicating the code for each generated function.

this change reduces about 3Kb from wl1271.ko

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/wl1271_debugfs.c |  215 +++++++++++++-------------
 1 files changed, 111 insertions(+), 104 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_debugfs.c b/drivers/net/wireless/wl12xx/wl1271_debugfs.c
index 66c2b90..e699478 100644
--- a/drivers/net/wireless/wl12xx/wl1271_debugfs.c
+++ b/drivers/net/wireless/wl12xx/wl1271_debugfs.c
@@ -35,17 +35,28 @@
 #define WL1271_DEBUGFS_STATS_LIFETIME 1000
 
 /* debugfs macros idea from mac80211 */
+#define DEBUGFS_FORMAT_BUFFER_SIZE 100
+static int wl1271_format_buffer(char __user *userbuf, size_t count,
+				    loff_t *ppos, char *fmt, ...)
+{
+	va_list args;
+	char buf[DEBUGFS_FORMAT_BUFFER_SIZE];
+	int res;
 
-#define DEBUGFS_READONLY_FILE(name, buflen, fmt, value...)		\
+	va_start(args, fmt);
+	res = vscnprintf(buf, sizeof(buf), fmt, args);
+	va_end(args);
+
+	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
+}
+
+#define DEBUGFS_READONLY_FILE(name, fmt, value...)			\
 static ssize_t name## _read(struct file *file, char __user *userbuf,	\
 			    size_t count, loff_t *ppos)			\
 {									\
 	struct wl1271 *wl = file->private_data;				\
-	char buf[buflen];						\
-	int res;							\
-									\
-	res = scnprintf(buf, buflen, fmt "\n", ##value);		\
-	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
+	return wl1271_format_buffer(userbuf, count, ppos, 		\
+				    fmt "\n", ##value);			\
 }									\
 									\
 static const struct file_operations name## _ops = {			\
@@ -69,20 +80,17 @@ static const struct file_operations name## _ops = {			\
 		wl->debugfs.name = NULL;				\
 	} while (0)
 
-#define DEBUGFS_FWSTATS_FILE(sub, name, buflen, fmt)			\
+#define DEBUGFS_FWSTATS_FILE(sub, name, fmt)				\
 static ssize_t sub## _ ##name## _read(struct file *file,		\
 				      char __user *userbuf,		\
 				      size_t count, loff_t *ppos)	\
 {									\
 	struct wl1271 *wl = file->private_data;				\
-	char buf[buflen];						\
-	int res;							\
 									\
 	wl1271_debugfs_update_stats(wl);				\
 									\
-	res = scnprintf(buf, buflen, fmt "\n",				\
-			wl->stats.fw_stats->sub.name);			\
-	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
+	return wl1271_format_buffer(userbuf, count, ppos, fmt "\n", 	\
+				    wl->stats.fw_stats->sub.name);	\
 }									\
 									\
 static const struct file_operations sub## _ ##name## _ops = {		\
@@ -126,100 +134,99 @@ static int wl1271_open_file_generic(struct inode *inode, struct file *file)
 	return 0;
 }
 
-DEBUGFS_FWSTATS_FILE(tx, internal_desc_overflow, 20, "%u");
-
-DEBUGFS_FWSTATS_FILE(rx, out_of_mem, 20, "%u");
-DEBUGFS_FWSTATS_FILE(rx, hdr_overflow, 20, "%u");
-DEBUGFS_FWSTATS_FILE(rx, hw_stuck, 20, "%u");
-DEBUGFS_FWSTATS_FILE(rx, dropped, 20, "%u");
-DEBUGFS_FWSTATS_FILE(rx, fcs_err, 20, "%u");
-DEBUGFS_FWSTATS_FILE(rx, xfr_hint_trig, 20, "%u");
-DEBUGFS_FWSTATS_FILE(rx, path_reset, 20, "%u");
-DEBUGFS_FWSTATS_FILE(rx, reset_counter, 20, "%u");
-
-DEBUGFS_FWSTATS_FILE(dma, rx_requested, 20, "%u");
-DEBUGFS_FWSTATS_FILE(dma, rx_errors, 20, "%u");
-DEBUGFS_FWSTATS_FILE(dma, tx_requested, 20, "%u");
-DEBUGFS_FWSTATS_FILE(dma, tx_errors, 20, "%u");
-
-DEBUGFS_FWSTATS_FILE(isr, cmd_cmplt, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, fiqs, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, rx_headers, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, rx_mem_overflow, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, rx_rdys, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, irqs, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, tx_procs, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, decrypt_done, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, dma0_done, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, dma1_done, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, tx_exch_complete, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, commands, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, rx_procs, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, hw_pm_mode_changes, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, host_acknowledges, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, pci_pm, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, wakeups, 20, "%u");
-DEBUGFS_FWSTATS_FILE(isr, low_rssi, 20, "%u");
-
-DEBUGFS_FWSTATS_FILE(wep, addr_key_count, 20, "%u");
-DEBUGFS_FWSTATS_FILE(wep, default_key_count, 20, "%u");
+DEBUGFS_FWSTATS_FILE(tx, internal_desc_overflow, "%u");
+
+DEBUGFS_FWSTATS_FILE(rx, out_of_mem, "%u");
+DEBUGFS_FWSTATS_FILE(rx, hdr_overflow, "%u");
+DEBUGFS_FWSTATS_FILE(rx, hw_stuck, "%u");
+DEBUGFS_FWSTATS_FILE(rx, dropped, "%u");
+DEBUGFS_FWSTATS_FILE(rx, fcs_err, "%u");
+DEBUGFS_FWSTATS_FILE(rx, xfr_hint_trig, "%u");
+DEBUGFS_FWSTATS_FILE(rx, path_reset, "%u");
+DEBUGFS_FWSTATS_FILE(rx, reset_counter, "%u");
+
+DEBUGFS_FWSTATS_FILE(dma, rx_requested, "%u");
+DEBUGFS_FWSTATS_FILE(dma, rx_errors, "%u");
+DEBUGFS_FWSTATS_FILE(dma, tx_requested, "%u");
+DEBUGFS_FWSTATS_FILE(dma, tx_errors, "%u");
+
+DEBUGFS_FWSTATS_FILE(isr, cmd_cmplt, "%u");
+DEBUGFS_FWSTATS_FILE(isr, fiqs, "%u");
+DEBUGFS_FWSTATS_FILE(isr, rx_headers, "%u");
+DEBUGFS_FWSTATS_FILE(isr, rx_mem_overflow, "%u");
+DEBUGFS_FWSTATS_FILE(isr, rx_rdys, "%u");
+DEBUGFS_FWSTATS_FILE(isr, irqs, "%u");
+DEBUGFS_FWSTATS_FILE(isr, tx_procs, "%u");
+DEBUGFS_FWSTATS_FILE(isr, decrypt_done, "%u");
+DEBUGFS_FWSTATS_FILE(isr, dma0_done, "%u");
+DEBUGFS_FWSTATS_FILE(isr, dma1_done, "%u");
+DEBUGFS_FWSTATS_FILE(isr, tx_exch_complete, "%u");
+DEBUGFS_FWSTATS_FILE(isr, commands, "%u");
+DEBUGFS_FWSTATS_FILE(isr, rx_procs, "%u");
+DEBUGFS_FWSTATS_FILE(isr, hw_pm_mode_changes, "%u");
+DEBUGFS_FWSTATS_FILE(isr, host_acknowledges, "%u");
+DEBUGFS_FWSTATS_FILE(isr, pci_pm, "%u");
+DEBUGFS_FWSTATS_FILE(isr, wakeups, "%u");
+DEBUGFS_FWSTATS_FILE(isr, low_rssi, "%u");
+
+DEBUGFS_FWSTATS_FILE(wep, addr_key_count, "%u");
+DEBUGFS_FWSTATS_FILE(wep, default_key_count, "%u");
 /* skipping wep.reserved */
-DEBUGFS_FWSTATS_FILE(wep, key_not_found, 20, "%u");
-DEBUGFS_FWSTATS_FILE(wep, decrypt_fail, 20, "%u");
-DEBUGFS_FWSTATS_FILE(wep, packets, 20, "%u");
-DEBUGFS_FWSTATS_FILE(wep, interrupt, 20, "%u");
-
-DEBUGFS_FWSTATS_FILE(pwr, ps_enter, 20, "%u");
-DEBUGFS_FWSTATS_FILE(pwr, elp_enter, 20, "%u");
-DEBUGFS_FWSTATS_FILE(pwr, missing_bcns, 20, "%u");
-DEBUGFS_FWSTATS_FILE(pwr, wake_on_host, 20, "%u");
-DEBUGFS_FWSTATS_FILE(pwr, wake_on_timer_exp, 20, "%u");
-DEBUGFS_FWSTATS_FILE(pwr, tx_with_ps, 20, "%u");
-DEBUGFS_FWSTATS_FILE(pwr, tx_without_ps, 20, "%u");
-DEBUGFS_FWSTATS_FILE(pwr, rcvd_beacons, 20, "%u");
-DEBUGFS_FWSTATS_FILE(pwr, power_save_off, 20, "%u");
-DEBUGFS_FWSTATS_FILE(pwr, enable_ps, 20, "%u");
-DEBUGFS_FWSTATS_FILE(pwr, disable_ps, 20, "%u");
-DEBUGFS_FWSTATS_FILE(pwr, fix_tsf_ps, 20, "%u");
+DEBUGFS_FWSTATS_FILE(wep, key_not_found, "%u");
+DEBUGFS_FWSTATS_FILE(wep, decrypt_fail, "%u");
+DEBUGFS_FWSTATS_FILE(wep, packets, "%u");
+DEBUGFS_FWSTATS_FILE(wep, interrupt, "%u");
+
+DEBUGFS_FWSTATS_FILE(pwr, ps_enter, "%u");
+DEBUGFS_FWSTATS_FILE(pwr, elp_enter, "%u");
+DEBUGFS_FWSTATS_FILE(pwr, missing_bcns, "%u");
+DEBUGFS_FWSTATS_FILE(pwr, wake_on_host, "%u");
+DEBUGFS_FWSTATS_FILE(pwr, wake_on_timer_exp, "%u");
+DEBUGFS_FWSTATS_FILE(pwr, tx_with_ps, "%u");
+DEBUGFS_FWSTATS_FILE(pwr, tx_without_ps, "%u");
+DEBUGFS_FWSTATS_FILE(pwr, rcvd_beacons, "%u");
+DEBUGFS_FWSTATS_FILE(pwr, power_save_off, "%u");
+DEBUGFS_FWSTATS_FILE(pwr, enable_ps, "%u");
+DEBUGFS_FWSTATS_FILE(pwr, disable_ps, "%u");
+DEBUGFS_FWSTATS_FILE(pwr, fix_tsf_ps, "%u");
 /* skipping cont_miss_bcns_spread for now */
-DEBUGFS_FWSTATS_FILE(pwr, rcvd_awake_beacons, 20, "%u");
-
-DEBUGFS_FWSTATS_FILE(mic, rx_pkts, 20, "%u");
-DEBUGFS_FWSTATS_FILE(mic, calc_failure, 20, "%u");
-
-DEBUGFS_FWSTATS_FILE(aes, encrypt_fail, 20, "%u");
-DEBUGFS_FWSTATS_FILE(aes, decrypt_fail, 20, "%u");
-DEBUGFS_FWSTATS_FILE(aes, encrypt_packets, 20, "%u");
-DEBUGFS_FWSTATS_FILE(aes, decrypt_packets, 20, "%u");
-DEBUGFS_FWSTATS_FILE(aes, encrypt_interrupt, 20, "%u");
-DEBUGFS_FWSTATS_FILE(aes, decrypt_interrupt, 20, "%u");
-
-DEBUGFS_FWSTATS_FILE(event, heart_beat, 20, "%u");
-DEBUGFS_FWSTATS_FILE(event, calibration, 20, "%u");
-DEBUGFS_FWSTATS_FILE(event, rx_mismatch, 20, "%u");
-DEBUGFS_FWSTATS_FILE(event, rx_mem_empty, 20, "%u");
-DEBUGFS_FWSTATS_FILE(event, rx_pool, 20, "%u");
-DEBUGFS_FWSTATS_FILE(event, oom_late, 20, "%u");
-DEBUGFS_FWSTATS_FILE(event, phy_transmit_error, 20, "%u");
-DEBUGFS_FWSTATS_FILE(event, tx_stuck, 20, "%u");
-
-DEBUGFS_FWSTATS_FILE(ps, pspoll_timeouts, 20, "%u");
-DEBUGFS_FWSTATS_FILE(ps, upsd_timeouts, 20, "%u");
-DEBUGFS_FWSTATS_FILE(ps, upsd_max_sptime, 20, "%u");
-DEBUGFS_FWSTATS_FILE(ps, upsd_max_apturn, 20, "%u");
-DEBUGFS_FWSTATS_FILE(ps, pspoll_max_apturn, 20, "%u");
-DEBUGFS_FWSTATS_FILE(ps, pspoll_utilization, 20, "%u");
-DEBUGFS_FWSTATS_FILE(ps, upsd_utilization, 20, "%u");
-
-DEBUGFS_FWSTATS_FILE(rxpipe, rx_prep_beacon_drop, 20, "%u");
-DEBUGFS_FWSTATS_FILE(rxpipe, descr_host_int_trig_rx_data, 20, "%u");
-DEBUGFS_FWSTATS_FILE(rxpipe, beacon_buffer_thres_host_int_trig_rx_data,
-		     20, "%u");
-DEBUGFS_FWSTATS_FILE(rxpipe, missed_beacon_host_int_trig_rx_data, 20, "%u");
-DEBUGFS_FWSTATS_FILE(rxpipe, tx_xfr_host_int_trig_rx_data, 20, "%u");
-
-DEBUGFS_READONLY_FILE(retry_count, 20, "%u", wl->stats.retry_count);
-DEBUGFS_READONLY_FILE(excessive_retries, 20, "%u",
+DEBUGFS_FWSTATS_FILE(pwr, rcvd_awake_beacons, "%u");
+
+DEBUGFS_FWSTATS_FILE(mic, rx_pkts, "%u");
+DEBUGFS_FWSTATS_FILE(mic, calc_failure, "%u");
+
+DEBUGFS_FWSTATS_FILE(aes, encrypt_fail, "%u");
+DEBUGFS_FWSTATS_FILE(aes, decrypt_fail, "%u");
+DEBUGFS_FWSTATS_FILE(aes, encrypt_packets, "%u");
+DEBUGFS_FWSTATS_FILE(aes, decrypt_packets, "%u");
+DEBUGFS_FWSTATS_FILE(aes, encrypt_interrupt, "%u");
+DEBUGFS_FWSTATS_FILE(aes, decrypt_interrupt, "%u");
+
+DEBUGFS_FWSTATS_FILE(event, heart_beat, "%u");
+DEBUGFS_FWSTATS_FILE(event, calibration, "%u");
+DEBUGFS_FWSTATS_FILE(event, rx_mismatch, "%u");
+DEBUGFS_FWSTATS_FILE(event, rx_mem_empty, "%u");
+DEBUGFS_FWSTATS_FILE(event, rx_pool, "%u");
+DEBUGFS_FWSTATS_FILE(event, oom_late, "%u");
+DEBUGFS_FWSTATS_FILE(event, phy_transmit_error, "%u");
+DEBUGFS_FWSTATS_FILE(event, tx_stuck, "%u");
+
+DEBUGFS_FWSTATS_FILE(ps, pspoll_timeouts, "%u");
+DEBUGFS_FWSTATS_FILE(ps, upsd_timeouts, "%u");
+DEBUGFS_FWSTATS_FILE(ps, upsd_max_sptime, "%u");
+DEBUGFS_FWSTATS_FILE(ps, upsd_max_apturn, "%u");
+DEBUGFS_FWSTATS_FILE(ps, pspoll_max_apturn, "%u");
+DEBUGFS_FWSTATS_FILE(ps, pspoll_utilization, "%u");
+DEBUGFS_FWSTATS_FILE(ps, upsd_utilization, "%u");
+
+DEBUGFS_FWSTATS_FILE(rxpipe, rx_prep_beacon_drop, "%u");
+DEBUGFS_FWSTATS_FILE(rxpipe, descr_host_int_trig_rx_data, "%u");
+DEBUGFS_FWSTATS_FILE(rxpipe, beacon_buffer_thres_host_int_trig_rx_data, "%u");
+DEBUGFS_FWSTATS_FILE(rxpipe, missed_beacon_host_int_trig_rx_data, "%u");
+DEBUGFS_FWSTATS_FILE(rxpipe, tx_xfr_host_int_trig_rx_data, "%u");
+
+DEBUGFS_READONLY_FILE(retry_count, "%u", wl->stats.retry_count);
+DEBUGFS_READONLY_FILE(excessive_retries, "%u",
 		      wl->stats.excessive_retries);
 
 static ssize_t tx_queue_len_read(struct file *file, char __user *userbuf,
-- 
1.7.0.4

