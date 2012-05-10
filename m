Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61669 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758371Ab2EJJQp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:16:45 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1110716wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:16:44 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 61/78] wlcore: abstract debugfs fw_stats to be handled by the lower drivers
Date: Thu, 10 May 2012 12:14:06 +0300
Message-Id: <1336641263-5761-62-git-send-email-arik@wizery.com> (sfid-20120510_111828_692845_3D170B3C)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

The FW statistics differ from hardware to hardware.  This commit
prepares for hardware-specific implementation of the FW statistics
debugfs entries.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/acx.c      |    4 +-
 drivers/net/wireless/ti/wlcore/acx.h      |  224 +----------------------
 drivers/net/wireless/ti/wlcore/debugfs.c  |  279 +++--------------------------
 drivers/net/wireless/ti/wlcore/debugfs.h  |   60 +++++++
 drivers/net/wireless/ti/wlcore/hw_ops.h   |    9 +
 drivers/net/wireless/ti/wlcore/wlcore.h   |   10 ++
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    8 -
 7 files changed, 104 insertions(+), 490 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/acx.c b/drivers/net/wireless/ti/wlcore/acx.c
index 611666e..6480a02 100644
--- a/drivers/net/wireless/ti/wlcore/acx.c
+++ b/drivers/net/wireless/ti/wlcore/acx.c
@@ -709,14 +709,14 @@ out:
 	return ret;
 }
 
-int wl1271_acx_statistics(struct wl1271 *wl, struct acx_statistics *stats)
+int wl1271_acx_statistics(struct wl1271 *wl, void *stats)
 {
 	int ret;
 
 	wl1271_debug(DEBUG_ACX, "acx statistics");
 
 	ret = wl1271_cmd_interrogate(wl, ACX_STATISTICS, stats,
-				     sizeof(*stats));
+				     wl->stats.fw_stats_len);
 	if (ret < 0) {
 		wl1271_warning("acx statistics failed: %d", ret);
 		return -ENOMEM;
diff --git a/drivers/net/wireless/ti/wlcore/acx.h b/drivers/net/wireless/ti/wlcore/acx.h
index e513b1b..28fb35c 100644
--- a/drivers/net/wireless/ti/wlcore/acx.h
+++ b/drivers/net/wireless/ti/wlcore/acx.h
@@ -417,228 +417,6 @@ struct acx_ctsprotect {
 	u8 padding[2];
 } __packed;
 
-struct acx_tx_statistics {
-	__le32 internal_desc_overflow;
-}  __packed;
-
-struct acx_rx_statistics {
-	__le32 out_of_mem;
-	__le32 hdr_overflow;
-	__le32 hw_stuck;
-	__le32 dropped;
-	__le32 fcs_err;
-	__le32 xfr_hint_trig;
-	__le32 path_reset;
-	__le32 reset_counter;
-} __packed;
-
-struct acx_dma_statistics {
-	__le32 rx_requested;
-	__le32 rx_errors;
-	__le32 tx_requested;
-	__le32 tx_errors;
-}  __packed;
-
-struct acx_isr_statistics {
-	/* host command complete */
-	__le32 cmd_cmplt;
-
-	/* fiqisr() */
-	__le32 fiqs;
-
-	/* (INT_STS_ND & INT_TRIG_RX_HEADER) */
-	__le32 rx_headers;
-
-	/* (INT_STS_ND & INT_TRIG_RX_CMPLT) */
-	__le32 rx_completes;
-
-	/* (INT_STS_ND & INT_TRIG_NO_RX_BUF) */
-	__le32 rx_mem_overflow;
-
-	/* (INT_STS_ND & INT_TRIG_S_RX_RDY) */
-	__le32 rx_rdys;
-
-	/* irqisr() */
-	__le32 irqs;
-
-	/* (INT_STS_ND & INT_TRIG_TX_PROC) */
-	__le32 tx_procs;
-
-	/* (INT_STS_ND & INT_TRIG_DECRYPT_DONE) */
-	__le32 decrypt_done;
-
-	/* (INT_STS_ND & INT_TRIG_DMA0) */
-	__le32 dma0_done;
-
-	/* (INT_STS_ND & INT_TRIG_DMA1) */
-	__le32 dma1_done;
-
-	/* (INT_STS_ND & INT_TRIG_TX_EXC_CMPLT) */
-	__le32 tx_exch_complete;
-
-	/* (INT_STS_ND & INT_TRIG_COMMAND) */
-	__le32 commands;
-
-	/* (INT_STS_ND & INT_TRIG_RX_PROC) */
-	__le32 rx_procs;
-
-	/* (INT_STS_ND & INT_TRIG_PM_802) */
-	__le32 hw_pm_mode_changes;
-
-	/* (INT_STS_ND & INT_TRIG_ACKNOWLEDGE) */
-	__le32 host_acknowledges;
-
-	/* (INT_STS_ND & INT_TRIG_PM_PCI) */
-	__le32 pci_pm;
-
-	/* (INT_STS_ND & INT_TRIG_ACM_WAKEUP) */
-	__le32 wakeups;
-
-	/* (INT_STS_ND & INT_TRIG_LOW_RSSI) */
-	__le32 low_rssi;
-} __packed;
-
-struct acx_wep_statistics {
-	/* WEP address keys configured */
-	__le32 addr_key_count;
-
-	/* default keys configured */
-	__le32 default_key_count;
-
-	__le32 reserved;
-
-	/* number of times that WEP key not found on lookup */
-	__le32 key_not_found;
-
-	/* number of times that WEP key decryption failed */
-	__le32 decrypt_fail;
-
-	/* WEP packets decrypted */
-	__le32 packets;
-
-	/* WEP decrypt interrupts */
-	__le32 interrupt;
-} __packed;
-
-#define ACX_MISSED_BEACONS_SPREAD 10
-
-struct acx_pwr_statistics {
-	/* the amount of enters into power save mode (both PD & ELP) */
-	__le32 ps_enter;
-
-	/* the amount of enters into ELP mode */
-	__le32 elp_enter;
-
-	/* the amount of missing beacon interrupts to the host */
-	__le32 missing_bcns;
-
-	/* the amount of wake on host-access times */
-	__le32 wake_on_host;
-
-	/* the amount of wake on timer-expire */
-	__le32 wake_on_timer_exp;
-
-	/* the number of packets that were transmitted with PS bit set */
-	__le32 tx_with_ps;
-
-	/* the number of packets that were transmitted with PS bit clear */
-	__le32 tx_without_ps;
-
-	/* the number of received beacons */
-	__le32 rcvd_beacons;
-
-	/* the number of entering into PowerOn (power save off) */
-	__le32 power_save_off;
-
-	/* the number of entries into power save mode */
-	__le16 enable_ps;
-
-	/*
-	 * the number of exits from power save, not including failed PS
-	 * transitions
-	 */
-	__le16 disable_ps;
-
-	/*
-	 * the number of times the TSF counter was adjusted because
-	 * of drift
-	 */
-	__le32 fix_tsf_ps;
-
-	/* Gives statistics about the spread continuous missed beacons.
-	 * The 16 LSB are dedicated for the PS mode.
-	 * The 16 MSB are dedicated for the PS mode.
-	 * cont_miss_bcns_spread[0] - single missed beacon.
-	 * cont_miss_bcns_spread[1] - two continuous missed beacons.
-	 * cont_miss_bcns_spread[2] - three continuous missed beacons.
-	 * ...
-	 * cont_miss_bcns_spread[9] - ten and more continuous missed beacons.
-	*/
-	__le32 cont_miss_bcns_spread[ACX_MISSED_BEACONS_SPREAD];
-
-	/* the number of beacons in awake mode */
-	__le32 rcvd_awake_beacons;
-} __packed;
-
-struct acx_mic_statistics {
-	__le32 rx_pkts;
-	__le32 calc_failure;
-} __packed;
-
-struct acx_aes_statistics {
-	__le32 encrypt_fail;
-	__le32 decrypt_fail;
-	__le32 encrypt_packets;
-	__le32 decrypt_packets;
-	__le32 encrypt_interrupt;
-	__le32 decrypt_interrupt;
-} __packed;
-
-struct acx_event_statistics {
-	__le32 heart_beat;
-	__le32 calibration;
-	__le32 rx_mismatch;
-	__le32 rx_mem_empty;
-	__le32 rx_pool;
-	__le32 oom_late;
-	__le32 phy_transmit_error;
-	__le32 tx_stuck;
-} __packed;
-
-struct acx_ps_statistics {
-	__le32 pspoll_timeouts;
-	__le32 upsd_timeouts;
-	__le32 upsd_max_sptime;
-	__le32 upsd_max_apturn;
-	__le32 pspoll_max_apturn;
-	__le32 pspoll_utilization;
-	__le32 upsd_utilization;
-} __packed;
-
-struct acx_rxpipe_statistics {
-	__le32 rx_prep_beacon_drop;
-	__le32 descr_host_int_trig_rx_data;
-	__le32 beacon_buffer_thres_host_int_trig_rx_data;
-	__le32 missed_beacon_host_int_trig_rx_data;
-	__le32 tx_xfr_host_int_trig_rx_data;
-} __packed;
-
-struct acx_statistics {
-	struct acx_header header;
-
-	struct acx_tx_statistics tx;
-	struct acx_rx_statistics rx;
-	struct acx_dma_statistics dma;
-	struct acx_isr_statistics isr;
-	struct acx_wep_statistics wep;
-	struct acx_pwr_statistics pwr;
-	struct acx_aes_statistics aes;
-	struct acx_mic_statistics mic;
-	struct acx_event_statistics event;
-	struct acx_ps_statistics ps;
-	struct acx_rxpipe_statistics rxpipe;
-} __packed;
-
 struct acx_rate_class {
 	__le32 enabled_rates;
 	u8 short_retry_limit;
@@ -1284,7 +1062,7 @@ int wl1271_acx_set_preamble(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			    enum acx_preamble_type preamble);
 int wl1271_acx_cts_protect(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			   enum acx_ctsprotect_type ctsprotect);
-int wl1271_acx_statistics(struct wl1271 *wl, struct acx_statistics *stats);
+int wl1271_acx_statistics(struct wl1271 *wl, void *stats);
 int wl1271_acx_sta_rate_policies(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl1271_acx_ap_rate_policy(struct wl1271 *wl, struct conf_tx_rate_class *c,
 		      u8 idx);
diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index d377519..57c1eae 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -25,6 +25,7 @@
 
 #include <linux/skbuff.h>
 #include <linux/slab.h>
+#include <linux/module.h>
 
 #include "wlcore.h"
 #include "debug.h"
@@ -32,14 +33,15 @@
 #include "ps.h"
 #include "io.h"
 #include "tx.h"
+#include "hw_ops.h"
 
 /* ms */
 #define WL1271_DEBUGFS_STATS_LIFETIME 1000
 
 /* debugfs macros idea from mac80211 */
 #define DEBUGFS_FORMAT_BUFFER_SIZE 100
-static int wl1271_format_buffer(char __user *userbuf, size_t count,
-				    loff_t *ppos, char *fmt, ...)
+int wl1271_format_buffer(char __user *userbuf, size_t count,
+			 loff_t *ppos, char *fmt, ...)
 {
 	va_list args;
 	char buf[DEBUGFS_FORMAT_BUFFER_SIZE];
@@ -51,59 +53,9 @@ static int wl1271_format_buffer(char __user *userbuf, size_t count,
 
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
 }
+EXPORT_SYMBOL_GPL(wl1271_format_buffer);
 
-#define DEBUGFS_READONLY_FILE(name, fmt, value...)			\
-static ssize_t name## _read(struct file *file, char __user *userbuf,	\
-			    size_t count, loff_t *ppos)			\
-{									\
-	struct wl1271 *wl = file->private_data;				\
-	return wl1271_format_buffer(userbuf, count, ppos,		\
-				    fmt "\n", ##value);			\
-}									\
-									\
-static const struct file_operations name## _ops = {			\
-	.read = name## _read,						\
-	.open = simple_open,						\
-	.llseek	= generic_file_llseek,					\
-};
-
-#define DEBUGFS_ADD(name, parent)					\
-	entry = debugfs_create_file(#name, 0400, parent,		\
-				    wl, &name## _ops);			\
-	if (!entry || IS_ERR(entry))					\
-		goto err;						\
-
-#define DEBUGFS_ADD_PREFIX(prefix, name, parent)			\
-	do {								\
-		entry = debugfs_create_file(#name, 0400, parent,	\
-				    wl, &prefix## _## name## _ops);	\
-		if (!entry || IS_ERR(entry))				\
-			goto err;					\
-	} while (0);
-
-#define DEBUGFS_FWSTATS_FILE(sub, name, fmt)				\
-static ssize_t sub## _ ##name## _read(struct file *file,		\
-				      char __user *userbuf,		\
-				      size_t count, loff_t *ppos)	\
-{									\
-	struct wl1271 *wl = file->private_data;				\
-									\
-	wl1271_debugfs_update_stats(wl);				\
-									\
-	return wl1271_format_buffer(userbuf, count, ppos, fmt "\n",	\
-				    wl->stats.fw_stats->sub.name);	\
-}									\
-									\
-static const struct file_operations sub## _ ##name## _ops = {		\
-	.read = sub## _ ##name## _read,					\
-	.open = simple_open,						\
-	.llseek	= generic_file_llseek,					\
-};
-
-#define DEBUGFS_FWSTATS_ADD(sub, name)				\
-	DEBUGFS_ADD(sub## _ ##name, stats)
-
-static void wl1271_debugfs_update_stats(struct wl1271 *wl)
+void wl1271_debugfs_update_stats(struct wl1271 *wl)
 {
 	int ret;
 
@@ -125,97 +77,7 @@ static void wl1271_debugfs_update_stats(struct wl1271 *wl)
 out:
 	mutex_unlock(&wl->mutex);
 }
-
-DEBUGFS_FWSTATS_FILE(tx, internal_desc_overflow, "%u");
-
-DEBUGFS_FWSTATS_FILE(rx, out_of_mem, "%u");
-DEBUGFS_FWSTATS_FILE(rx, hdr_overflow, "%u");
-DEBUGFS_FWSTATS_FILE(rx, hw_stuck, "%u");
-DEBUGFS_FWSTATS_FILE(rx, dropped, "%u");
-DEBUGFS_FWSTATS_FILE(rx, fcs_err, "%u");
-DEBUGFS_FWSTATS_FILE(rx, xfr_hint_trig, "%u");
-DEBUGFS_FWSTATS_FILE(rx, path_reset, "%u");
-DEBUGFS_FWSTATS_FILE(rx, reset_counter, "%u");
-
-DEBUGFS_FWSTATS_FILE(dma, rx_requested, "%u");
-DEBUGFS_FWSTATS_FILE(dma, rx_errors, "%u");
-DEBUGFS_FWSTATS_FILE(dma, tx_requested, "%u");
-DEBUGFS_FWSTATS_FILE(dma, tx_errors, "%u");
-
-DEBUGFS_FWSTATS_FILE(isr, cmd_cmplt, "%u");
-DEBUGFS_FWSTATS_FILE(isr, fiqs, "%u");
-DEBUGFS_FWSTATS_FILE(isr, rx_headers, "%u");
-DEBUGFS_FWSTATS_FILE(isr, rx_mem_overflow, "%u");
-DEBUGFS_FWSTATS_FILE(isr, rx_rdys, "%u");
-DEBUGFS_FWSTATS_FILE(isr, irqs, "%u");
-DEBUGFS_FWSTATS_FILE(isr, tx_procs, "%u");
-DEBUGFS_FWSTATS_FILE(isr, decrypt_done, "%u");
-DEBUGFS_FWSTATS_FILE(isr, dma0_done, "%u");
-DEBUGFS_FWSTATS_FILE(isr, dma1_done, "%u");
-DEBUGFS_FWSTATS_FILE(isr, tx_exch_complete, "%u");
-DEBUGFS_FWSTATS_FILE(isr, commands, "%u");
-DEBUGFS_FWSTATS_FILE(isr, rx_procs, "%u");
-DEBUGFS_FWSTATS_FILE(isr, hw_pm_mode_changes, "%u");
-DEBUGFS_FWSTATS_FILE(isr, host_acknowledges, "%u");
-DEBUGFS_FWSTATS_FILE(isr, pci_pm, "%u");
-DEBUGFS_FWSTATS_FILE(isr, wakeups, "%u");
-DEBUGFS_FWSTATS_FILE(isr, low_rssi, "%u");
-
-DEBUGFS_FWSTATS_FILE(wep, addr_key_count, "%u");
-DEBUGFS_FWSTATS_FILE(wep, default_key_count, "%u");
-/* skipping wep.reserved */
-DEBUGFS_FWSTATS_FILE(wep, key_not_found, "%u");
-DEBUGFS_FWSTATS_FILE(wep, decrypt_fail, "%u");
-DEBUGFS_FWSTATS_FILE(wep, packets, "%u");
-DEBUGFS_FWSTATS_FILE(wep, interrupt, "%u");
-
-DEBUGFS_FWSTATS_FILE(pwr, ps_enter, "%u");
-DEBUGFS_FWSTATS_FILE(pwr, elp_enter, "%u");
-DEBUGFS_FWSTATS_FILE(pwr, missing_bcns, "%u");
-DEBUGFS_FWSTATS_FILE(pwr, wake_on_host, "%u");
-DEBUGFS_FWSTATS_FILE(pwr, wake_on_timer_exp, "%u");
-DEBUGFS_FWSTATS_FILE(pwr, tx_with_ps, "%u");
-DEBUGFS_FWSTATS_FILE(pwr, tx_without_ps, "%u");
-DEBUGFS_FWSTATS_FILE(pwr, rcvd_beacons, "%u");
-DEBUGFS_FWSTATS_FILE(pwr, power_save_off, "%u");
-DEBUGFS_FWSTATS_FILE(pwr, enable_ps, "%u");
-DEBUGFS_FWSTATS_FILE(pwr, disable_ps, "%u");
-DEBUGFS_FWSTATS_FILE(pwr, fix_tsf_ps, "%u");
-/* skipping cont_miss_bcns_spread for now */
-DEBUGFS_FWSTATS_FILE(pwr, rcvd_awake_beacons, "%u");
-
-DEBUGFS_FWSTATS_FILE(mic, rx_pkts, "%u");
-DEBUGFS_FWSTATS_FILE(mic, calc_failure, "%u");
-
-DEBUGFS_FWSTATS_FILE(aes, encrypt_fail, "%u");
-DEBUGFS_FWSTATS_FILE(aes, decrypt_fail, "%u");
-DEBUGFS_FWSTATS_FILE(aes, encrypt_packets, "%u");
-DEBUGFS_FWSTATS_FILE(aes, decrypt_packets, "%u");
-DEBUGFS_FWSTATS_FILE(aes, encrypt_interrupt, "%u");
-DEBUGFS_FWSTATS_FILE(aes, decrypt_interrupt, "%u");
-
-DEBUGFS_FWSTATS_FILE(event, heart_beat, "%u");
-DEBUGFS_FWSTATS_FILE(event, calibration, "%u");
-DEBUGFS_FWSTATS_FILE(event, rx_mismatch, "%u");
-DEBUGFS_FWSTATS_FILE(event, rx_mem_empty, "%u");
-DEBUGFS_FWSTATS_FILE(event, rx_pool, "%u");
-DEBUGFS_FWSTATS_FILE(event, oom_late, "%u");
-DEBUGFS_FWSTATS_FILE(event, phy_transmit_error, "%u");
-DEBUGFS_FWSTATS_FILE(event, tx_stuck, "%u");
-
-DEBUGFS_FWSTATS_FILE(ps, pspoll_timeouts, "%u");
-DEBUGFS_FWSTATS_FILE(ps, upsd_timeouts, "%u");
-DEBUGFS_FWSTATS_FILE(ps, upsd_max_sptime, "%u");
-DEBUGFS_FWSTATS_FILE(ps, upsd_max_apturn, "%u");
-DEBUGFS_FWSTATS_FILE(ps, pspoll_max_apturn, "%u");
-DEBUGFS_FWSTATS_FILE(ps, pspoll_utilization, "%u");
-DEBUGFS_FWSTATS_FILE(ps, upsd_utilization, "%u");
-
-DEBUGFS_FWSTATS_FILE(rxpipe, rx_prep_beacon_drop, "%u");
-DEBUGFS_FWSTATS_FILE(rxpipe, descr_host_int_trig_rx_data, "%u");
-DEBUGFS_FWSTATS_FILE(rxpipe, beacon_buffer_thres_host_int_trig_rx_data, "%u");
-DEBUGFS_FWSTATS_FILE(rxpipe, missed_beacon_host_int_trig_rx_data, "%u");
-DEBUGFS_FWSTATS_FILE(rxpipe, tx_xfr_host_int_trig_rx_data, "%u");
+EXPORT_SYMBOL_GPL(wl1271_debugfs_update_stats);
 
 DEBUGFS_READONLY_FILE(retry_count, "%u", wl->stats.retry_count);
 DEBUGFS_READONLY_FILE(excessive_retries, "%u",
@@ -1002,107 +864,10 @@ static const struct file_operations beacon_filtering_ops = {
 };
 
 static int wl1271_debugfs_add_files(struct wl1271 *wl,
-				     struct dentry *rootdir)
+				    struct dentry *rootdir)
 {
 	int ret = 0;
-	struct dentry *entry, *stats, *streaming;
-
-	stats = debugfs_create_dir("fw-statistics", rootdir);
-	if (!stats || IS_ERR(stats)) {
-		entry = stats;
-		goto err;
-	}
-
-	DEBUGFS_FWSTATS_ADD(tx, internal_desc_overflow);
-
-	DEBUGFS_FWSTATS_ADD(rx, out_of_mem);
-	DEBUGFS_FWSTATS_ADD(rx, hdr_overflow);
-	DEBUGFS_FWSTATS_ADD(rx, hw_stuck);
-	DEBUGFS_FWSTATS_ADD(rx, dropped);
-	DEBUGFS_FWSTATS_ADD(rx, fcs_err);
-	DEBUGFS_FWSTATS_ADD(rx, xfr_hint_trig);
-	DEBUGFS_FWSTATS_ADD(rx, path_reset);
-	DEBUGFS_FWSTATS_ADD(rx, reset_counter);
-
-	DEBUGFS_FWSTATS_ADD(dma, rx_requested);
-	DEBUGFS_FWSTATS_ADD(dma, rx_errors);
-	DEBUGFS_FWSTATS_ADD(dma, tx_requested);
-	DEBUGFS_FWSTATS_ADD(dma, tx_errors);
-
-	DEBUGFS_FWSTATS_ADD(isr, cmd_cmplt);
-	DEBUGFS_FWSTATS_ADD(isr, fiqs);
-	DEBUGFS_FWSTATS_ADD(isr, rx_headers);
-	DEBUGFS_FWSTATS_ADD(isr, rx_mem_overflow);
-	DEBUGFS_FWSTATS_ADD(isr, rx_rdys);
-	DEBUGFS_FWSTATS_ADD(isr, irqs);
-	DEBUGFS_FWSTATS_ADD(isr, tx_procs);
-	DEBUGFS_FWSTATS_ADD(isr, decrypt_done);
-	DEBUGFS_FWSTATS_ADD(isr, dma0_done);
-	DEBUGFS_FWSTATS_ADD(isr, dma1_done);
-	DEBUGFS_FWSTATS_ADD(isr, tx_exch_complete);
-	DEBUGFS_FWSTATS_ADD(isr, commands);
-	DEBUGFS_FWSTATS_ADD(isr, rx_procs);
-	DEBUGFS_FWSTATS_ADD(isr, hw_pm_mode_changes);
-	DEBUGFS_FWSTATS_ADD(isr, host_acknowledges);
-	DEBUGFS_FWSTATS_ADD(isr, pci_pm);
-	DEBUGFS_FWSTATS_ADD(isr, wakeups);
-	DEBUGFS_FWSTATS_ADD(isr, low_rssi);
-
-	DEBUGFS_FWSTATS_ADD(wep, addr_key_count);
-	DEBUGFS_FWSTATS_ADD(wep, default_key_count);
-	/* skipping wep.reserved */
-	DEBUGFS_FWSTATS_ADD(wep, key_not_found);
-	DEBUGFS_FWSTATS_ADD(wep, decrypt_fail);
-	DEBUGFS_FWSTATS_ADD(wep, packets);
-	DEBUGFS_FWSTATS_ADD(wep, interrupt);
-
-	DEBUGFS_FWSTATS_ADD(pwr, ps_enter);
-	DEBUGFS_FWSTATS_ADD(pwr, elp_enter);
-	DEBUGFS_FWSTATS_ADD(pwr, missing_bcns);
-	DEBUGFS_FWSTATS_ADD(pwr, wake_on_host);
-	DEBUGFS_FWSTATS_ADD(pwr, wake_on_timer_exp);
-	DEBUGFS_FWSTATS_ADD(pwr, tx_with_ps);
-	DEBUGFS_FWSTATS_ADD(pwr, tx_without_ps);
-	DEBUGFS_FWSTATS_ADD(pwr, rcvd_beacons);
-	DEBUGFS_FWSTATS_ADD(pwr, power_save_off);
-	DEBUGFS_FWSTATS_ADD(pwr, enable_ps);
-	DEBUGFS_FWSTATS_ADD(pwr, disable_ps);
-	DEBUGFS_FWSTATS_ADD(pwr, fix_tsf_ps);
-	/* skipping cont_miss_bcns_spread for now */
-	DEBUGFS_FWSTATS_ADD(pwr, rcvd_awake_beacons);
-
-	DEBUGFS_FWSTATS_ADD(mic, rx_pkts);
-	DEBUGFS_FWSTATS_ADD(mic, calc_failure);
-
-	DEBUGFS_FWSTATS_ADD(aes, encrypt_fail);
-	DEBUGFS_FWSTATS_ADD(aes, decrypt_fail);
-	DEBUGFS_FWSTATS_ADD(aes, encrypt_packets);
-	DEBUGFS_FWSTATS_ADD(aes, decrypt_packets);
-	DEBUGFS_FWSTATS_ADD(aes, encrypt_interrupt);
-	DEBUGFS_FWSTATS_ADD(aes, decrypt_interrupt);
-
-	DEBUGFS_FWSTATS_ADD(event, heart_beat);
-	DEBUGFS_FWSTATS_ADD(event, calibration);
-	DEBUGFS_FWSTATS_ADD(event, rx_mismatch);
-	DEBUGFS_FWSTATS_ADD(event, rx_mem_empty);
-	DEBUGFS_FWSTATS_ADD(event, rx_pool);
-	DEBUGFS_FWSTATS_ADD(event, oom_late);
-	DEBUGFS_FWSTATS_ADD(event, phy_transmit_error);
-	DEBUGFS_FWSTATS_ADD(event, tx_stuck);
-
-	DEBUGFS_FWSTATS_ADD(ps, pspoll_timeouts);
-	DEBUGFS_FWSTATS_ADD(ps, upsd_timeouts);
-	DEBUGFS_FWSTATS_ADD(ps, upsd_max_sptime);
-	DEBUGFS_FWSTATS_ADD(ps, upsd_max_apturn);
-	DEBUGFS_FWSTATS_ADD(ps, pspoll_max_apturn);
-	DEBUGFS_FWSTATS_ADD(ps, pspoll_utilization);
-	DEBUGFS_FWSTATS_ADD(ps, upsd_utilization);
-
-	DEBUGFS_FWSTATS_ADD(rxpipe, rx_prep_beacon_drop);
-	DEBUGFS_FWSTATS_ADD(rxpipe, descr_host_int_trig_rx_data);
-	DEBUGFS_FWSTATS_ADD(rxpipe, beacon_buffer_thres_host_int_trig_rx_data);
-	DEBUGFS_FWSTATS_ADD(rxpipe, missed_beacon_host_int_trig_rx_data);
-	DEBUGFS_FWSTATS_ADD(rxpipe, tx_xfr_host_int_trig_rx_data);
+	struct dentry *entry, *streaming;
 
 	DEBUGFS_ADD(tx_queue_len, rootdir);
 	DEBUGFS_ADD(retry_count, rootdir);
@@ -1144,7 +909,7 @@ void wl1271_debugfs_reset(struct wl1271 *wl)
 	if (!wl->stats.fw_stats)
 		return;
 
-	memset(wl->stats.fw_stats, 0, sizeof(*wl->stats.fw_stats));
+	memset(wl->stats.fw_stats, 0, wl->stats.fw_stats_len);
 	wl->stats.retry_count = 0;
 	wl->stats.excessive_retries = 0;
 }
@@ -1159,34 +924,34 @@ int wl1271_debugfs_init(struct wl1271 *wl)
 
 	if (IS_ERR(rootdir)) {
 		ret = PTR_ERR(rootdir);
-		goto err;
+		goto out;
 	}
 
-	wl->stats.fw_stats = kzalloc(sizeof(*wl->stats.fw_stats),
-				      GFP_KERNEL);
-
+	wl->stats.fw_stats = kzalloc(wl->stats.fw_stats_len, GFP_KERNEL);
 	if (!wl->stats.fw_stats) {
 		ret = -ENOMEM;
-		goto err_fw;
+		goto out_remove;
 	}
 
 	wl->stats.fw_stats_update = jiffies;
 
 	ret = wl1271_debugfs_add_files(wl, rootdir);
+	if (ret < 0)
+		goto out_exit;
 
+	ret = wlcore_debugfs_init(wl, rootdir);
 	if (ret < 0)
-		goto err_file;
+		goto out_exit;
 
-	return 0;
+	goto out;
 
-err_file:
-	kfree(wl->stats.fw_stats);
-	wl->stats.fw_stats = NULL;
+out_exit:
+	wl1271_debugfs_exit(wl);
 
-err_fw:
+out_remove:
 	debugfs_remove_recursive(rootdir);
 
-err:
+out:
 	return ret;
 }
 
diff --git a/drivers/net/wireless/ti/wlcore/debugfs.h b/drivers/net/wireless/ti/wlcore/debugfs.h
index a8d3aef..e1a5bf1 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.h
+++ b/drivers/net/wireless/ti/wlcore/debugfs.h
@@ -26,8 +26,68 @@
 
 #include "wlcore.h"
 
+int wl1271_format_buffer(char __user *userbuf, size_t count,
+			 loff_t *ppos, char *fmt, ...);
+
 int wl1271_debugfs_init(struct wl1271 *wl);
 void wl1271_debugfs_exit(struct wl1271 *wl);
 void wl1271_debugfs_reset(struct wl1271 *wl);
+void wl1271_debugfs_update_stats(struct wl1271 *wl);
+
+#define DEBUGFS_READONLY_FILE(name, fmt, value...)			\
+static ssize_t name## _read(struct file *file, char __user *userbuf,	\
+			    size_t count, loff_t *ppos)			\
+{									\
+	struct wl1271 *wl = file->private_data;				\
+	return wl1271_format_buffer(userbuf, count, ppos,		\
+				    fmt "\n", ##value);			\
+}									\
+									\
+static const struct file_operations name## _ops = {			\
+	.read = name## _read,						\
+	.open = simple_open,						\
+	.llseek	= generic_file_llseek,					\
+};
+
+#define DEBUGFS_ADD(name, parent)					\
+	do {								\
+		entry = debugfs_create_file(#name, 0400, parent,	\
+					    wl, &name## _ops);		\
+		if (!entry || IS_ERR(entry))				\
+			goto err;					\
+	} while (0);
+
+
+#define DEBUGFS_ADD_PREFIX(prefix, name, parent)			\
+	do {								\
+		entry = debugfs_create_file(#name, 0400, parent,	\
+				    wl, &prefix## _## name## _ops);	\
+		if (!entry || IS_ERR(entry))				\
+			goto err;					\
+	} while (0);
+
+#define DEBUGFS_FWSTATS_FILE(sub, name, fmt, struct_type)		\
+static ssize_t sub## _ ##name## _read(struct file *file,		\
+				      char __user *userbuf,		\
+				      size_t count, loff_t *ppos)	\
+{									\
+	struct wl1271 *wl = file->private_data;				\
+	struct struct_type *stats = wl->stats.fw_stats;			\
+									\
+	wl1271_debugfs_update_stats(wl);				\
+									\
+	return wl1271_format_buffer(userbuf, count, ppos, fmt "\n",	\
+				    stats->sub.name);			\
+}									\
+									\
+static const struct file_operations sub## _ ##name## _ops = {		\
+	.read = sub## _ ##name## _read,					\
+	.open = simple_open,						\
+	.llseek	= generic_file_llseek,					\
+};
+
+#define DEBUGFS_FWSTATS_ADD(sub, name)					\
+	DEBUGFS_ADD(sub## _ ##name, stats)
+
 
 #endif /* WL1271_DEBUGFS_H */
diff --git a/drivers/net/wireless/ti/wlcore/hw_ops.h b/drivers/net/wireless/ti/wlcore/hw_ops.h
index 6d3e378..1555c3e 100644
--- a/drivers/net/wireless/ti/wlcore/hw_ops.h
+++ b/drivers/net/wireless/ti/wlcore/hw_ops.h
@@ -149,4 +149,13 @@ wlcore_hw_ap_get_mimo_wide_rate_mask(struct wl1271 *wl,
 	return 0;
 }
 
+static inline int
+wlcore_debugfs_init(struct wl1271 *wl, struct dentry *rootdir)
+{
+	if (wl->ops->debugfs_init)
+		return wl->ops->debugfs_init(wl, rootdir);
+
+	return 0;
+}
+
 #endif
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 9ca3829..85fd3d9 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -71,6 +71,7 @@ struct wlcore_ops {
 			    struct sk_buff *skb);
 	u32 (*ap_get_mimo_wide_rate_mask)(struct wl1271 *wl,
 					  struct wl12xx_vif *wlvif);
+	int (*debugfs_init)(struct wl1271 *wl, struct dentry *rootdir);
 };
 
 enum wlcore_partitions {
@@ -119,6 +120,15 @@ enum wlcore_registers {
 	REG_TABLE_LEN,
 };
 
+struct wl1271_stats {
+	void *fw_stats;
+	unsigned long fw_stats_update;
+	size_t fw_stats_len;
+
+	unsigned int retry_count;
+	unsigned int excessive_retries;
+};
+
 struct wl1271 {
 	struct ieee80211_hw *hw;
 	bool mac80211_registered;
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 0422753..45c07dc 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -132,14 +132,6 @@ struct wl1271_chip {
 	unsigned int fw_ver[NUM_FW_VER];
 };
 
-struct wl1271_stats {
-	struct acx_statistics *fw_stats;
-	unsigned long fw_stats_update;
-
-	unsigned int retry_count;
-	unsigned int excessive_retries;
-};
-
 #define NUM_TX_QUEUES              4
 
 #define AP_MAX_STATIONS            8
-- 
1.7.9.5

