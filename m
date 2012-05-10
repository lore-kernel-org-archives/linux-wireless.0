Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51169 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758697Ab2EJJQu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:16:50 -0400
Received: by mail-wi0-f172.google.com with SMTP id hr2so244170wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:16:49 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 63/78] wl12xx: implement fw status debugfs entries
Date: Thu, 10 May 2012 12:14:08 +0300
Message-Id: <1336641263-5761-64-git-send-email-arik@wizery.com> (sfid-20120510_111750_770571_205CAD41)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

Implement the operations that are necessary to fetch the
wl12xx-specific FW statistics.  Re-add some of the code removed from
wlcore.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/Makefile  |    2 +-
 drivers/net/wireless/ti/wl12xx/acx.h     |  223 ++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wl12xx/debugfs.c |  236 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wl12xx/debugfs.h |   28 ++++
 drivers/net/wireless/ti/wl12xx/main.c    |    8 +
 5 files changed, 496 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wireless/ti/wl12xx/debugfs.c
 create mode 100644 drivers/net/wireless/ti/wl12xx/debugfs.h

diff --git a/drivers/net/wireless/ti/wl12xx/Makefile b/drivers/net/wireless/ti/wl12xx/Makefile
index 87f64b1..da509aa 100644
--- a/drivers/net/wireless/ti/wl12xx/Makefile
+++ b/drivers/net/wireless/ti/wl12xx/Makefile
@@ -1,3 +1,3 @@
-wl12xx-objs	= main.o cmd.o acx.o
+wl12xx-objs	= main.o cmd.o acx.o debugfs.o
 
 obj-$(CONFIG_WL12XX)		+= wl12xx.o
diff --git a/drivers/net/wireless/ti/wl12xx/acx.h b/drivers/net/wireless/ti/wl12xx/acx.h
index d1f5aba..1be0f2d 100644
--- a/drivers/net/wireless/ti/wl12xx/acx.h
+++ b/drivers/net/wireless/ti/wl12xx/acx.h
@@ -24,6 +24,7 @@
 #define __WL12XX_ACX_H__
 
 #include "../wlcore/wlcore.h"
+#include "../wlcore/acx.h"
 
 struct wl1271_acx_host_config_bitmap {
 	struct acx_header header;
@@ -31,6 +32,228 @@ struct wl1271_acx_host_config_bitmap {
 	__le32 host_cfg_bitmap;
 } __packed;
 
+struct wl12xx_acx_tx_statistics {
+	__le32 internal_desc_overflow;
+}  __packed;
+
+struct wl12xx_acx_rx_statistics {
+	__le32 out_of_mem;
+	__le32 hdr_overflow;
+	__le32 hw_stuck;
+	__le32 dropped;
+	__le32 fcs_err;
+	__le32 xfr_hint_trig;
+	__le32 path_reset;
+	__le32 reset_counter;
+} __packed;
+
+struct wl12xx_acx_dma_statistics {
+	__le32 rx_requested;
+	__le32 rx_errors;
+	__le32 tx_requested;
+	__le32 tx_errors;
+}  __packed;
+
+struct wl12xx_acx_isr_statistics {
+	/* host command complete */
+	__le32 cmd_cmplt;
+
+	/* fiqisr() */
+	__le32 fiqs;
+
+	/* (INT_STS_ND & INT_TRIG_RX_HEADER) */
+	__le32 rx_headers;
+
+	/* (INT_STS_ND & INT_TRIG_RX_CMPLT) */
+	__le32 rx_completes;
+
+	/* (INT_STS_ND & INT_TRIG_NO_RX_BUF) */
+	__le32 rx_mem_overflow;
+
+	/* (INT_STS_ND & INT_TRIG_S_RX_RDY) */
+	__le32 rx_rdys;
+
+	/* irqisr() */
+	__le32 irqs;
+
+	/* (INT_STS_ND & INT_TRIG_TX_PROC) */
+	__le32 tx_procs;
+
+	/* (INT_STS_ND & INT_TRIG_DECRYPT_DONE) */
+	__le32 decrypt_done;
+
+	/* (INT_STS_ND & INT_TRIG_DMA0) */
+	__le32 dma0_done;
+
+	/* (INT_STS_ND & INT_TRIG_DMA1) */
+	__le32 dma1_done;
+
+	/* (INT_STS_ND & INT_TRIG_TX_EXC_CMPLT) */
+	__le32 tx_exch_complete;
+
+	/* (INT_STS_ND & INT_TRIG_COMMAND) */
+	__le32 commands;
+
+	/* (INT_STS_ND & INT_TRIG_RX_PROC) */
+	__le32 rx_procs;
+
+	/* (INT_STS_ND & INT_TRIG_PM_802) */
+	__le32 hw_pm_mode_changes;
+
+	/* (INT_STS_ND & INT_TRIG_ACKNOWLEDGE) */
+	__le32 host_acknowledges;
+
+	/* (INT_STS_ND & INT_TRIG_PM_PCI) */
+	__le32 pci_pm;
+
+	/* (INT_STS_ND & INT_TRIG_ACM_WAKEUP) */
+	__le32 wakeups;
+
+	/* (INT_STS_ND & INT_TRIG_LOW_RSSI) */
+	__le32 low_rssi;
+} __packed;
+
+struct wl12xx_acx_wep_statistics {
+	/* WEP address keys configured */
+	__le32 addr_key_count;
+
+	/* default keys configured */
+	__le32 default_key_count;
+
+	__le32 reserved;
+
+	/* number of times that WEP key not found on lookup */
+	__le32 key_not_found;
+
+	/* number of times that WEP key decryption failed */
+	__le32 decrypt_fail;
+
+	/* WEP packets decrypted */
+	__le32 packets;
+
+	/* WEP decrypt interrupts */
+	__le32 interrupt;
+} __packed;
+
+#define ACX_MISSED_BEACONS_SPREAD 10
+
+struct wl12xx_acx_pwr_statistics {
+	/* the amount of enters into power save mode (both PD & ELP) */
+	__le32 ps_enter;
+
+	/* the amount of enters into ELP mode */
+	__le32 elp_enter;
+
+	/* the amount of missing beacon interrupts to the host */
+	__le32 missing_bcns;
+
+	/* the amount of wake on host-access times */
+	__le32 wake_on_host;
+
+	/* the amount of wake on timer-expire */
+	__le32 wake_on_timer_exp;
+
+	/* the number of packets that were transmitted with PS bit set */
+	__le32 tx_with_ps;
+
+	/* the number of packets that were transmitted with PS bit clear */
+	__le32 tx_without_ps;
+
+	/* the number of received beacons */
+	__le32 rcvd_beacons;
+
+	/* the number of entering into PowerOn (power save off) */
+	__le32 power_save_off;
+
+	/* the number of entries into power save mode */
+	__le16 enable_ps;
+
+	/*
+	 * the number of exits from power save, not including failed PS
+	 * transitions
+	 */
+	__le16 disable_ps;
+
+	/*
+	 * the number of times the TSF counter was adjusted because
+	 * of drift
+	 */
+	__le32 fix_tsf_ps;
+
+	/* Gives statistics about the spread continuous missed beacons.
+	 * The 16 LSB are dedicated for the PS mode.
+	 * The 16 MSB are dedicated for the PS mode.
+	 * cont_miss_bcns_spread[0] - single missed beacon.
+	 * cont_miss_bcns_spread[1] - two continuous missed beacons.
+	 * cont_miss_bcns_spread[2] - three continuous missed beacons.
+	 * ...
+	 * cont_miss_bcns_spread[9] - ten and more continuous missed beacons.
+	*/
+	__le32 cont_miss_bcns_spread[ACX_MISSED_BEACONS_SPREAD];
+
+	/* the number of beacons in awake mode */
+	__le32 rcvd_awake_beacons;
+} __packed;
+
+struct wl12xx_acx_mic_statistics {
+	__le32 rx_pkts;
+	__le32 calc_failure;
+} __packed;
+
+struct wl12xx_acx_aes_statistics {
+	__le32 encrypt_fail;
+	__le32 decrypt_fail;
+	__le32 encrypt_packets;
+	__le32 decrypt_packets;
+	__le32 encrypt_interrupt;
+	__le32 decrypt_interrupt;
+} __packed;
+
+struct wl12xx_acx_event_statistics {
+	__le32 heart_beat;
+	__le32 calibration;
+	__le32 rx_mismatch;
+	__le32 rx_mem_empty;
+	__le32 rx_pool;
+	__le32 oom_late;
+	__le32 phy_transmit_error;
+	__le32 tx_stuck;
+} __packed;
+
+struct wl12xx_acx_ps_statistics {
+	__le32 pspoll_timeouts;
+	__le32 upsd_timeouts;
+	__le32 upsd_max_sptime;
+	__le32 upsd_max_apturn;
+	__le32 pspoll_max_apturn;
+	__le32 pspoll_utilization;
+	__le32 upsd_utilization;
+} __packed;
+
+struct wl12xx_acx_rxpipe_statistics {
+	__le32 rx_prep_beacon_drop;
+	__le32 descr_host_int_trig_rx_data;
+	__le32 beacon_buffer_thres_host_int_trig_rx_data;
+	__le32 missed_beacon_host_int_trig_rx_data;
+	__le32 tx_xfr_host_int_trig_rx_data;
+} __packed;
+
+struct wl12xx_acx_statistics {
+	struct acx_header header;
+
+	struct wl12xx_acx_tx_statistics tx;
+	struct wl12xx_acx_rx_statistics rx;
+	struct wl12xx_acx_dma_statistics dma;
+	struct wl12xx_acx_isr_statistics isr;
+	struct wl12xx_acx_wep_statistics wep;
+	struct wl12xx_acx_pwr_statistics pwr;
+	struct wl12xx_acx_aes_statistics aes;
+	struct wl12xx_acx_mic_statistics mic;
+	struct wl12xx_acx_event_statistics event;
+	struct wl12xx_acx_ps_statistics ps;
+	struct wl12xx_acx_rxpipe_statistics rxpipe;
+} __packed;
+
 int wl1271_acx_host_if_cfg_bitmap(struct wl1271 *wl, u32 host_cfg_bitmap);
 
 #endif /* __WL12XX_ACX_H__ */
diff --git a/drivers/net/wireless/ti/wl12xx/debugfs.c b/drivers/net/wireless/ti/wl12xx/debugfs.c
new file mode 100644
index 0000000..9cc79d8
--- /dev/null
+++ b/drivers/net/wireless/ti/wl12xx/debugfs.c
@@ -0,0 +1,236 @@
+/*
+ * This file is part of wl12xx
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
+#include "wl12xx.h"
+#include "acx.h"
+
+#define WL12XX_DEBUGFS_FWSTATS_FILE(a, b, c) \
+	DEBUGFS_FWSTATS_FILE(a, b, c, wl12xx_acx_statistics)
+
+WL12XX_DEBUGFS_FWSTATS_FILE(tx, internal_desc_overflow, "%u");
+
+WL12XX_DEBUGFS_FWSTATS_FILE(rx, out_of_mem, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(rx, hdr_overflow, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(rx, hw_stuck, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(rx, dropped, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(rx, fcs_err, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(rx, xfr_hint_trig, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(rx, path_reset, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(rx, reset_counter, "%u");
+
+WL12XX_DEBUGFS_FWSTATS_FILE(dma, rx_requested, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(dma, rx_errors, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(dma, tx_requested, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(dma, tx_errors, "%u");
+
+WL12XX_DEBUGFS_FWSTATS_FILE(isr, cmd_cmplt, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(isr, fiqs, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(isr, rx_headers, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(isr, rx_mem_overflow, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(isr, rx_rdys, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(isr, irqs, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(isr, tx_procs, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(isr, decrypt_done, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(isr, dma0_done, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(isr, dma1_done, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(isr, tx_exch_complete, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(isr, commands, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(isr, rx_procs, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(isr, hw_pm_mode_changes, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(isr, host_acknowledges, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(isr, pci_pm, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(isr, wakeups, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(isr, low_rssi, "%u");
+
+WL12XX_DEBUGFS_FWSTATS_FILE(wep, addr_key_count, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(wep, default_key_count, "%u");
+/* skipping wep.reserved */
+WL12XX_DEBUGFS_FWSTATS_FILE(wep, key_not_found, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(wep, decrypt_fail, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(wep, packets, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(wep, interrupt, "%u");
+
+WL12XX_DEBUGFS_FWSTATS_FILE(pwr, ps_enter, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(pwr, elp_enter, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(pwr, missing_bcns, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(pwr, wake_on_host, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(pwr, wake_on_timer_exp, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(pwr, tx_with_ps, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(pwr, tx_without_ps, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(pwr, rcvd_beacons, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(pwr, power_save_off, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(pwr, enable_ps, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(pwr, disable_ps, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(pwr, fix_tsf_ps, "%u");
+/* skipping cont_miss_bcns_spread for now */
+WL12XX_DEBUGFS_FWSTATS_FILE(pwr, rcvd_awake_beacons, "%u");
+
+WL12XX_DEBUGFS_FWSTATS_FILE(mic, rx_pkts, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(mic, calc_failure, "%u");
+
+WL12XX_DEBUGFS_FWSTATS_FILE(aes, encrypt_fail, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(aes, decrypt_fail, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(aes, encrypt_packets, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(aes, decrypt_packets, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(aes, encrypt_interrupt, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(aes, decrypt_interrupt, "%u");
+
+WL12XX_DEBUGFS_FWSTATS_FILE(event, heart_beat, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(event, calibration, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(event, rx_mismatch, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(event, rx_mem_empty, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(event, rx_pool, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(event, oom_late, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(event, phy_transmit_error, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(event, tx_stuck, "%u");
+
+WL12XX_DEBUGFS_FWSTATS_FILE(ps, pspoll_timeouts, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(ps, upsd_timeouts, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(ps, upsd_max_sptime, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(ps, upsd_max_apturn, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(ps, pspoll_max_apturn, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(ps, pspoll_utilization, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(ps, upsd_utilization, "%u");
+
+WL12XX_DEBUGFS_FWSTATS_FILE(rxpipe, rx_prep_beacon_drop, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(rxpipe, descr_host_int_trig_rx_data, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(rxpipe, beacon_buffer_thres_host_int_trig_rx_data,
+			    "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(rxpipe, missed_beacon_host_int_trig_rx_data, "%u");
+WL12XX_DEBUGFS_FWSTATS_FILE(rxpipe, tx_xfr_host_int_trig_rx_data, "%u");
+
+int wl12xx_debugfs_add_files(struct wl1271 *wl,
+			     struct dentry *rootdir)
+{
+	int ret = 0;
+	struct dentry *entry, *stats;
+
+	stats = debugfs_create_dir("wl12xx_fw_stats", rootdir);
+	if (!stats || IS_ERR(stats)) {
+		entry = stats;
+		goto err;
+	}
+
+	DEBUGFS_FWSTATS_ADD(tx, internal_desc_overflow);
+
+	DEBUGFS_FWSTATS_ADD(rx, out_of_mem);
+	DEBUGFS_FWSTATS_ADD(rx, hdr_overflow);
+	DEBUGFS_FWSTATS_ADD(rx, hw_stuck);
+	DEBUGFS_FWSTATS_ADD(rx, dropped);
+	DEBUGFS_FWSTATS_ADD(rx, fcs_err);
+	DEBUGFS_FWSTATS_ADD(rx, xfr_hint_trig);
+	DEBUGFS_FWSTATS_ADD(rx, path_reset);
+	DEBUGFS_FWSTATS_ADD(rx, reset_counter);
+
+	DEBUGFS_FWSTATS_ADD(dma, rx_requested);
+	DEBUGFS_FWSTATS_ADD(dma, rx_errors);
+	DEBUGFS_FWSTATS_ADD(dma, tx_requested);
+	DEBUGFS_FWSTATS_ADD(dma, tx_errors);
+
+	DEBUGFS_FWSTATS_ADD(isr, cmd_cmplt);
+	DEBUGFS_FWSTATS_ADD(isr, fiqs);
+	DEBUGFS_FWSTATS_ADD(isr, rx_headers);
+	DEBUGFS_FWSTATS_ADD(isr, rx_mem_overflow);
+	DEBUGFS_FWSTATS_ADD(isr, rx_rdys);
+	DEBUGFS_FWSTATS_ADD(isr, irqs);
+	DEBUGFS_FWSTATS_ADD(isr, tx_procs);
+	DEBUGFS_FWSTATS_ADD(isr, decrypt_done);
+	DEBUGFS_FWSTATS_ADD(isr, dma0_done);
+	DEBUGFS_FWSTATS_ADD(isr, dma1_done);
+	DEBUGFS_FWSTATS_ADD(isr, tx_exch_complete);
+	DEBUGFS_FWSTATS_ADD(isr, commands);
+	DEBUGFS_FWSTATS_ADD(isr, rx_procs);
+	DEBUGFS_FWSTATS_ADD(isr, hw_pm_mode_changes);
+	DEBUGFS_FWSTATS_ADD(isr, host_acknowledges);
+	DEBUGFS_FWSTATS_ADD(isr, pci_pm);
+	DEBUGFS_FWSTATS_ADD(isr, wakeups);
+	DEBUGFS_FWSTATS_ADD(isr, low_rssi);
+
+	DEBUGFS_FWSTATS_ADD(wep, addr_key_count);
+	DEBUGFS_FWSTATS_ADD(wep, default_key_count);
+	/* skipping wep.reserved */
+	DEBUGFS_FWSTATS_ADD(wep, key_not_found);
+	DEBUGFS_FWSTATS_ADD(wep, decrypt_fail);
+	DEBUGFS_FWSTATS_ADD(wep, packets);
+	DEBUGFS_FWSTATS_ADD(wep, interrupt);
+
+	DEBUGFS_FWSTATS_ADD(pwr, ps_enter);
+	DEBUGFS_FWSTATS_ADD(pwr, elp_enter);
+	DEBUGFS_FWSTATS_ADD(pwr, missing_bcns);
+	DEBUGFS_FWSTATS_ADD(pwr, wake_on_host);
+	DEBUGFS_FWSTATS_ADD(pwr, wake_on_timer_exp);
+	DEBUGFS_FWSTATS_ADD(pwr, tx_with_ps);
+	DEBUGFS_FWSTATS_ADD(pwr, tx_without_ps);
+	DEBUGFS_FWSTATS_ADD(pwr, rcvd_beacons);
+	DEBUGFS_FWSTATS_ADD(pwr, power_save_off);
+	DEBUGFS_FWSTATS_ADD(pwr, enable_ps);
+	DEBUGFS_FWSTATS_ADD(pwr, disable_ps);
+	DEBUGFS_FWSTATS_ADD(pwr, fix_tsf_ps);
+	/* skipping cont_miss_bcns_spread for now */
+	DEBUGFS_FWSTATS_ADD(pwr, rcvd_awake_beacons);
+
+	DEBUGFS_FWSTATS_ADD(mic, rx_pkts);
+	DEBUGFS_FWSTATS_ADD(mic, calc_failure);
+
+	DEBUGFS_FWSTATS_ADD(aes, encrypt_fail);
+	DEBUGFS_FWSTATS_ADD(aes, decrypt_fail);
+	DEBUGFS_FWSTATS_ADD(aes, encrypt_packets);
+	DEBUGFS_FWSTATS_ADD(aes, decrypt_packets);
+	DEBUGFS_FWSTATS_ADD(aes, encrypt_interrupt);
+	DEBUGFS_FWSTATS_ADD(aes, decrypt_interrupt);
+
+	DEBUGFS_FWSTATS_ADD(event, heart_beat);
+	DEBUGFS_FWSTATS_ADD(event, calibration);
+	DEBUGFS_FWSTATS_ADD(event, rx_mismatch);
+	DEBUGFS_FWSTATS_ADD(event, rx_mem_empty);
+	DEBUGFS_FWSTATS_ADD(event, rx_pool);
+	DEBUGFS_FWSTATS_ADD(event, oom_late);
+	DEBUGFS_FWSTATS_ADD(event, phy_transmit_error);
+	DEBUGFS_FWSTATS_ADD(event, tx_stuck);
+
+	DEBUGFS_FWSTATS_ADD(ps, pspoll_timeouts);
+	DEBUGFS_FWSTATS_ADD(ps, upsd_timeouts);
+	DEBUGFS_FWSTATS_ADD(ps, upsd_max_sptime);
+	DEBUGFS_FWSTATS_ADD(ps, upsd_max_apturn);
+	DEBUGFS_FWSTATS_ADD(ps, pspoll_max_apturn);
+	DEBUGFS_FWSTATS_ADD(ps, pspoll_utilization);
+	DEBUGFS_FWSTATS_ADD(ps, upsd_utilization);
+
+	DEBUGFS_FWSTATS_ADD(rxpipe, rx_prep_beacon_drop);
+	DEBUGFS_FWSTATS_ADD(rxpipe, descr_host_int_trig_rx_data);
+	DEBUGFS_FWSTATS_ADD(rxpipe, beacon_buffer_thres_host_int_trig_rx_data);
+	DEBUGFS_FWSTATS_ADD(rxpipe, missed_beacon_host_int_trig_rx_data);
+	DEBUGFS_FWSTATS_ADD(rxpipe, tx_xfr_host_int_trig_rx_data);
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
diff --git a/drivers/net/wireless/ti/wl12xx/debugfs.h b/drivers/net/wireless/ti/wl12xx/debugfs.h
new file mode 100644
index 0000000..96898e2
--- /dev/null
+++ b/drivers/net/wireless/ti/wl12xx/debugfs.h
@@ -0,0 +1,28 @@
+/*
+ * This file is part of wl12xx
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
+#ifndef __WL12XX_DEBUGFS_H__
+#define __WL12XX_DEBUGFS_H__
+
+int wl12xx_debugfs_add_files(struct wl1271 *wl,
+			     struct dentry *rootdir);
+
+#endif /* __WL12XX_DEBUGFS_H__ */
diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 82e0c6a..2ac8407 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -39,6 +39,7 @@
 #include "reg.h"
 #include "cmd.h"
 #include "acx.h"
+#include "debugfs.h"
 
 static char *fref_param;
 static char *tcxo_param;
@@ -1359,6 +1360,11 @@ out:
 	return ret;
 }
 
+static int wl12xx_debugfs_init(struct wl1271 *wl, struct dentry *rootdir)
+{
+	return wl12xx_debugfs_add_files(wl, rootdir);
+}
+
 static struct wlcore_ops wl12xx_ops = {
 	.identify_chip		= wl12xx_identify_chip,
 	.identify_fw		= wl12xx_identify_fw,
@@ -1381,6 +1387,7 @@ static struct wlcore_ops wl12xx_ops = {
 	.set_tx_desc_csum	= wl12xx_set_tx_desc_csum,
 	.set_rx_csum		= NULL,
 	.ap_get_mimo_wide_rate_mask = NULL,
+	.debugfs_init		= wl12xx_debugfs_init,
 };
 
 static struct ieee80211_sta_ht_cap wl12xx_ht_cap = {
@@ -1422,6 +1429,7 @@ static int __devinit wl12xx_probe(struct platform_device *pdev)
 	wl->hw_tx_rate_tbl_size = WL12XX_CONF_HW_RXTX_RATE_MAX;
 	wl->hw_min_ht_rate = WL12XX_CONF_HW_RXTX_RATE_MCS0;
 	wl->fw_status_priv_len = 0;
+	wl->stats.fw_stats_len = sizeof(struct wl12xx_acx_statistics);
 	memcpy(&wl->ht_cap, &wl12xx_ht_cap, sizeof(wl12xx_ht_cap));
 	wl12xx_conf_init(wl);
 
-- 
1.7.9.5

