Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:29948 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648AbZHFN0Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 09:26:16 -0400
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id n76DPJUZ014199
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2009 08:25:57 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: kalle.valo@nokia.com, juuso.oikarinen@nokia.com
Subject: [PATCH 1/2] wl1271: add wl1271 driver files
Date: Thu,  6 Aug 2009 16:25:28 +0300
Message-Id: <1249565129-12677-2-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1249565129-12677-1-git-send-email-luciano.coelho@nokia.com>
References: <1249565129-12677-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This driver supports the wl1271 chipset from Texas Instruments based on the
WiLink(tm) 6.0 mobile platform.  Support for wl1273 should be relatively easy
to add.  This chipset is designed for embedded devices, with good powersaving
capabilities.  The wl1271 chipset is the successor of wl1251 and supports the
802.11b/g/n standards, but currently this driver supports only b/g.

More information about this chipset can be found here:
http://focus.ti.com/general/docs/wtbu/wtbuproductcontent.tsp?templateId=6123&navigationId=12762&contentId=29993

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h         |  407 ++++++++
 drivers/net/wireless/wl12xx/wl1271_acx.c     |  961 ++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_acx.h     | 1221 ++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_boot.c    |  540 ++++++++++
 drivers/net/wireless/wl12xx/wl1271_boot.h    |   72 ++
 drivers/net/wireless/wl12xx/wl1271_cmd.c     |  813 +++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_cmd.h     |  464 +++++++++
 drivers/net/wireless/wl12xx/wl1271_debugfs.c |  518 ++++++++++
 drivers/net/wireless/wl12xx/wl1271_debugfs.h |   33 +
 drivers/net/wireless/wl12xx/wl1271_event.c   |  125 +++
 drivers/net/wireless/wl12xx/wl1271_event.h   |  110 ++
 drivers/net/wireless/wl12xx/wl1271_init.c    |  397 ++++++++
 drivers/net/wireless/wl12xx/wl1271_init.h    |  115 +++
 drivers/net/wireless/wl12xx/wl1271_main.c    | 1396 ++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_ps.c      |  142 +++
 drivers/net/wireless/wl12xx/wl1271_ps.h      |   35 +
 drivers/net/wireless/wl12xx/wl1271_reg.h     |  758 ++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_rx.c      |  200 ++++
 drivers/net/wireless/wl12xx/wl1271_rx.h      |  121 +++
 drivers/net/wireless/wl12xx/wl1271_spi.c     |  382 +++++++
 drivers/net/wireless/wl12xx/wl1271_spi.h     |  113 +++
 drivers/net/wireless/wl12xx/wl1271_tx.c      |  378 +++++++
 drivers/net/wireless/wl12xx/wl1271_tx.h      |  130 +++
 23 files changed, 9431 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/wl12xx/wl1271.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_acx.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_acx.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_boot.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_boot.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_cmd.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_cmd.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_debugfs.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_debugfs.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_event.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_event.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_init.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_init.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_main.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_ps.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_ps.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_reg.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_rx.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_rx.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_spi.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_spi.h
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_tx.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_tx.h

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
new file mode 100644
index 0000000..55818f9
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -0,0 +1,407 @@
+/*
+ * This file is part of wl1271
+ *
+ * Copyright (C) 1998-2009 Texas Instruments. All rights reserved.
+ * Copyright (C) 2008-2009 Nokia Corporation
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
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
+#ifndef __WL1271_H__
+#define __WL1271_H__
+
+#include <linux/mutex.h>
+#include <linux/completion.h>
+#include <linux/spinlock.h>
+#include <linux/list.h>
+#include <linux/bitops.h>
+#include <net/mac80211.h>
+
+#define DRIVER_NAME "wl1271"
+#define DRIVER_PREFIX DRIVER_NAME ": "
+
+enum {
+	DEBUG_NONE	= 0,
+	DEBUG_IRQ	= BIT(0),
+	DEBUG_SPI	= BIT(1),
+	DEBUG_BOOT	= BIT(2),
+	DEBUG_MAILBOX	= BIT(3),
+	DEBUG_NETLINK	= BIT(4),
+	DEBUG_EVENT	= BIT(5),
+	DEBUG_TX	= BIT(6),
+	DEBUG_RX	= BIT(7),
+	DEBUG_SCAN	= BIT(8),
+	DEBUG_CRYPT	= BIT(9),
+	DEBUG_PSM	= BIT(10),
+	DEBUG_MAC80211	= BIT(11),
+	DEBUG_CMD	= BIT(12),
+	DEBUG_ACX	= BIT(13),
+	DEBUG_ALL	= ~0,
+};
+
+#define DEBUG_LEVEL (DEBUG_NONE)
+
+#define DEBUG_DUMP_LIMIT 1024
+
+#define wl1271_error(fmt, arg...) \
+	printk(KERN_ERR DRIVER_PREFIX "ERROR " fmt "\n", ##arg)
+
+#define wl1271_warning(fmt, arg...) \
+	printk(KERN_WARNING DRIVER_PREFIX "WARNING " fmt "\n", ##arg)
+
+#define wl1271_notice(fmt, arg...) \
+	printk(KERN_INFO DRIVER_PREFIX fmt "\n", ##arg)
+
+#define wl1271_info(fmt, arg...) \
+	printk(KERN_DEBUG DRIVER_PREFIX fmt "\n", ##arg)
+
+#define wl1271_debug(level, fmt, arg...) \
+	do { \
+		if (level & DEBUG_LEVEL) \
+			printk(KERN_DEBUG DRIVER_PREFIX fmt "\n", ##arg); \
+	} while (0)
+
+#define wl1271_dump(level, prefix, buf, len)	\
+	do { \
+		if (level & DEBUG_LEVEL) \
+			print_hex_dump(KERN_DEBUG, DRIVER_PREFIX prefix, \
+				       DUMP_PREFIX_OFFSET, 16, 1,	\
+				       buf,				\
+				       min_t(size_t, len, DEBUG_DUMP_LIMIT), \
+				       0);				\
+	} while (0)
+
+#define wl1271_dump_ascii(level, prefix, buf, len)	\
+	do { \
+		if (level & DEBUG_LEVEL) \
+			print_hex_dump(KERN_DEBUG, DRIVER_PREFIX prefix, \
+				       DUMP_PREFIX_OFFSET, 16, 1,	\
+				       buf,				\
+				       min_t(size_t, len, DEBUG_DUMP_LIMIT), \
+				       true);				\
+	} while (0)
+
+#define WL1271_DEFAULT_RX_CONFIG (CFG_UNI_FILTER_EN |	\
+				  CFG_BSSID_FILTER_EN)
+
+#define WL1271_DEFAULT_RX_FILTER (CFG_RX_RCTS_ACK | CFG_RX_PRSP_EN |  \
+				  CFG_RX_MGMT_EN | CFG_RX_DATA_EN |   \
+				  CFG_RX_CTL_EN | CFG_RX_BCN_EN |     \
+				  CFG_RX_AUTH_EN | CFG_RX_ASSOC_EN)
+
+#define WL1271_FW_NAME "wl1271-fw.bin"
+#define WL1271_NVS_NAME "wl1271-nvs.bin"
+
+#define WL1271_BUSY_WORD_LEN 8
+
+#define WL1271_ELP_HW_STATE_ASLEEP 0
+#define WL1271_ELP_HW_STATE_IRQ    1
+
+enum wl1271_state {
+	WL1271_STATE_OFF,
+	WL1271_STATE_ON,
+	WL1271_STATE_PLT,
+};
+
+enum wl1271_partition_type {
+	PART_DOWN,
+	PART_WORK,
+	PART_DRPW,
+
+	PART_TABLE_LEN
+};
+
+struct wl1271_partition {
+	u32 size;
+	u32 start;
+};
+
+struct wl1271_partition_set {
+	struct wl1271_partition mem;
+	struct wl1271_partition reg;
+};
+
+struct wl1271;
+
+/* FIXME: I'm not sure about this structure name */
+struct wl1271_chip {
+	u32 id;
+	char fw_ver[21];
+};
+
+struct wl1271_stats {
+	struct acx_statistics *fw_stats;
+	unsigned long fw_stats_update;
+
+	unsigned int retry_count;
+	unsigned int excessive_retries;
+};
+
+struct wl1271_debugfs {
+	struct dentry *rootdir;
+	struct dentry *fw_statistics;
+
+	struct dentry *tx_internal_desc_overflow;
+
+	struct dentry *rx_out_of_mem;
+	struct dentry *rx_hdr_overflow;
+	struct dentry *rx_hw_stuck;
+	struct dentry *rx_dropped;
+	struct dentry *rx_fcs_err;
+	struct dentry *rx_xfr_hint_trig;
+	struct dentry *rx_path_reset;
+	struct dentry *rx_reset_counter;
+
+	struct dentry *dma_rx_requested;
+	struct dentry *dma_rx_errors;
+	struct dentry *dma_tx_requested;
+	struct dentry *dma_tx_errors;
+
+	struct dentry *isr_cmd_cmplt;
+	struct dentry *isr_fiqs;
+	struct dentry *isr_rx_headers;
+	struct dentry *isr_rx_mem_overflow;
+	struct dentry *isr_rx_rdys;
+	struct dentry *isr_irqs;
+	struct dentry *isr_tx_procs;
+	struct dentry *isr_decrypt_done;
+	struct dentry *isr_dma0_done;
+	struct dentry *isr_dma1_done;
+	struct dentry *isr_tx_exch_complete;
+	struct dentry *isr_commands;
+	struct dentry *isr_rx_procs;
+	struct dentry *isr_hw_pm_mode_changes;
+	struct dentry *isr_host_acknowledges;
+	struct dentry *isr_pci_pm;
+	struct dentry *isr_wakeups;
+	struct dentry *isr_low_rssi;
+
+	struct dentry *wep_addr_key_count;
+	struct dentry *wep_default_key_count;
+	/* skipping wep.reserved */
+	struct dentry *wep_key_not_found;
+	struct dentry *wep_decrypt_fail;
+	struct dentry *wep_packets;
+	struct dentry *wep_interrupt;
+
+	struct dentry *pwr_ps_enter;
+	struct dentry *pwr_elp_enter;
+	struct dentry *pwr_missing_bcns;
+	struct dentry *pwr_wake_on_host;
+	struct dentry *pwr_wake_on_timer_exp;
+	struct dentry *pwr_tx_with_ps;
+	struct dentry *pwr_tx_without_ps;
+	struct dentry *pwr_rcvd_beacons;
+	struct dentry *pwr_power_save_off;
+	struct dentry *pwr_enable_ps;
+	struct dentry *pwr_disable_ps;
+	struct dentry *pwr_fix_tsf_ps;
+	/* skipping cont_miss_bcns_spread for now */
+	struct dentry *pwr_rcvd_awake_beacons;
+
+	struct dentry *mic_rx_pkts;
+	struct dentry *mic_calc_failure;
+
+	struct dentry *aes_encrypt_fail;
+	struct dentry *aes_decrypt_fail;
+	struct dentry *aes_encrypt_packets;
+	struct dentry *aes_decrypt_packets;
+	struct dentry *aes_encrypt_interrupt;
+	struct dentry *aes_decrypt_interrupt;
+
+	struct dentry *event_heart_beat;
+	struct dentry *event_calibration;
+	struct dentry *event_rx_mismatch;
+	struct dentry *event_rx_mem_empty;
+	struct dentry *event_rx_pool;
+	struct dentry *event_oom_late;
+	struct dentry *event_phy_transmit_error;
+	struct dentry *event_tx_stuck;
+
+	struct dentry *ps_pspoll_timeouts;
+	struct dentry *ps_upsd_timeouts;
+	struct dentry *ps_upsd_max_sptime;
+	struct dentry *ps_upsd_max_apturn;
+	struct dentry *ps_pspoll_max_apturn;
+	struct dentry *ps_pspoll_utilization;
+	struct dentry *ps_upsd_utilization;
+
+	struct dentry *rxpipe_rx_prep_beacon_drop;
+	struct dentry *rxpipe_descr_host_int_trig_rx_data;
+	struct dentry *rxpipe_beacon_buffer_thres_host_int_trig_rx_data;
+	struct dentry *rxpipe_missed_beacon_host_int_trig_rx_data;
+	struct dentry *rxpipe_tx_xfr_host_int_trig_rx_data;
+
+	struct dentry *tx_queue_len;
+
+	struct dentry *retry_count;
+	struct dentry *excessive_retries;
+};
+
+#define NUM_TX_QUEUES              4
+#define NUM_RX_PKT_DESC            8
+
+/* FW status registers */
+struct wl1271_fw_status {
+	u32 intr;
+	u8  fw_rx_counter;
+	u8  drv_rx_counter;
+	u8  reserved;
+	u8  tx_results_counter;
+	u32 rx_pkt_descs[NUM_RX_PKT_DESC];
+	u32 tx_released_blks[NUM_TX_QUEUES];
+	u32 fw_localtime;
+	u32 padding[2];
+} __attribute__ ((packed));
+
+struct wl1271_rx_mem_pool_addr {
+	u32 addr;
+	u32 addr_extra;
+};
+
+struct wl1271 {
+	struct ieee80211_hw *hw;
+	bool mac80211_registered;
+
+	struct spi_device *spi;
+
+	void (*set_power)(bool enable);
+	int irq;
+
+	spinlock_t wl_lock;
+
+	enum wl1271_state state;
+	struct mutex mutex;
+
+	int physical_mem_addr;
+	int physical_reg_addr;
+	int virtual_mem_addr;
+	int virtual_reg_addr;
+
+	struct wl1271_chip chip;
+
+	int cmd_box_addr;
+	int event_box_addr;
+
+	u8 *fw;
+	size_t fw_len;
+	u8 *nvs;
+	size_t nvs_len;
+
+	u8 bssid[ETH_ALEN];
+	u8 mac_addr[ETH_ALEN];
+	u8 bss_type;
+	u8 ssid[IW_ESSID_MAX_SIZE + 1];
+	u8 ssid_len;
+	u8 listen_int;
+	int channel;
+
+	struct wl1271_acx_mem_map *target_mem_map;
+
+	/* Accounting for allocated / available TX blocks on HW */
+	u32 tx_blocks_freed[NUM_TX_QUEUES];
+	u32 tx_blocks_available;
+	u8 tx_results_count;
+
+	/* Transmitted TX packets counter for chipset interface */
+	int tx_packets_count;
+
+	/* Time-offset between host and chipset clocks */
+	int time_offset;
+
+	/* Session counter for the chipset */
+	int session_counter;
+
+	/* Frames scheduled for transmission, not handled yet */
+	struct sk_buff_head tx_queue;
+	bool tx_queue_stopped;
+
+	struct work_struct tx_work;
+	struct work_struct filter_work;
+
+	/* Pending TX frames */
+	struct sk_buff *tx_frames[16];
+
+	/* FW Rx counter */
+	u32 rx_counter;
+
+	/* Rx memory pool address */
+	struct wl1271_rx_mem_pool_addr rx_mem_pool_addr;
+
+	/* The target interrupt mask */
+	struct work_struct irq_work;
+
+	/* The mbox event mask */
+	u32 event_mask;
+
+	/* Mailbox pointers */
+	u32 mbox_ptr[2];
+
+	/* Are we currently scanning */
+	bool scanning;
+
+	/* Our association ID */
+	u16 aid;
+
+	/* Default key (for WEP) */
+	u32 default_key;
+
+	unsigned int rx_config;
+	unsigned int rx_filter;
+
+	/* is firmware in elp mode */
+	bool elp;
+
+	struct completion *elp_compl;
+
+	/* we can be in psm, but not in elp, we have to differentiate */
+	bool psm;
+
+	/* PSM mode requested */
+	bool psm_requested;
+
+	/* in dBm */
+	int power_level;
+
+	struct wl1271_stats stats;
+	struct wl1271_debugfs debugfs;
+
+	u32 buffer_32;
+	u32 buffer_cmd;
+	u8 buffer_busyword[WL1271_BUSY_WORD_LEN];
+	struct wl1271_rx_descriptor *rx_descriptor;
+
+	struct wl1271_fw_status *fw_status;
+	struct wl1271_tx_hw_res_if *tx_res_if;
+};
+
+int wl1271_plt_start(struct wl1271 *wl);
+int wl1271_plt_stop(struct wl1271 *wl);
+
+#define JOIN_TIMEOUT 5000 /* 5000 milliseconds to join */
+
+#define SESSION_COUNTER_MAX 7 /* maximum value for the session counter */
+
+#define WL1271_DEFAULT_POWER_LEVEL 0
+
+#define WL1271_TX_QUEUE_MAX_LENGTH 20
+
+/* WL1271 needs a 200ms sleep after power on */
+#define WL1271_POWER_ON_SLEEP 200 /* in miliseconds */
+
+#endif
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
new file mode 100644
index 0000000..f622a40
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -0,0 +1,961 @@
+/*
+ * This file is part of wl1271
+ *
+ * Copyright (C) 2008-2009 Nokia Corporation
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
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
+#include "wl1271_acx.h"
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/crc7.h>
+#include <linux/spi/spi.h>
+
+#include "wl1271.h"
+#include "wl12xx_80211.h"
+#include "wl1271_reg.h"
+#include "wl1271_spi.h"
+#include "wl1271_ps.h"
+
+int wl1271_acx_wake_up_conditions(struct wl1271 *wl, u8 wake_up_event,
+				  u8 listen_interval)
+{
+	struct acx_wake_up_condition *wake_up;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx wake up conditions");
+
+	wake_up = kzalloc(sizeof(*wake_up), GFP_KERNEL);
+	if (!wake_up) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	wake_up->wake_up_event = wake_up_event;
+	wake_up->listen_interval = listen_interval;
+
+	ret = wl1271_cmd_configure(wl, ACX_WAKE_UP_CONDITIONS,
+				   wake_up, sizeof(*wake_up));
+	if (ret < 0) {
+		wl1271_warning("could not set wake up conditions: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(wake_up);
+	return ret;
+}
+
+int wl1271_acx_sleep_auth(struct wl1271 *wl, u8 sleep_auth)
+{
+	struct acx_sleep_auth *auth;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx sleep auth");
+
+	auth = kzalloc(sizeof(*auth), GFP_KERNEL);
+	if (!auth) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	auth->sleep_auth = sleep_auth;
+
+	ret = wl1271_cmd_configure(wl, ACX_SLEEP_AUTH, auth, sizeof(*auth));
+	if (ret < 0)
+		return ret;
+
+out:
+	kfree(auth);
+	return ret;
+}
+
+int wl1271_acx_fw_version(struct wl1271 *wl, char *buf, size_t len)
+{
+	struct acx_revision *rev;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx fw rev");
+
+	rev = kzalloc(sizeof(*rev), GFP_KERNEL);
+	if (!rev) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = wl1271_cmd_interrogate(wl, ACX_FW_REV, rev, sizeof(*rev));
+	if (ret < 0) {
+		wl1271_warning("ACX_FW_REV interrogate failed");
+		goto out;
+	}
+
+	/* be careful with the buffer sizes */
+	strncpy(buf, rev->fw_version, min(len, sizeof(rev->fw_version)));
+
+	/*
+	 * if the firmware version string is exactly
+	 * sizeof(rev->fw_version) long or fw_len is less than
+	 * sizeof(rev->fw_version) it won't be null terminated
+	 */
+	buf[min(len, sizeof(rev->fw_version)) - 1] = '\0';
+
+out:
+	kfree(rev);
+	return ret;
+}
+
+int wl1271_acx_tx_power(struct wl1271 *wl, int power)
+{
+	struct acx_current_tx_power *acx;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx dot11_cur_tx_pwr");
+
+	if (power < 0 || power > 25)
+		return -EINVAL;
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->current_tx_power = power * 10;
+
+	ret = wl1271_cmd_configure(wl, DOT11_CUR_TX_PWR, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("configure of tx power failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
+
+int wl1271_acx_feature_cfg(struct wl1271 *wl)
+{
+	struct acx_feature_config *feature;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx feature cfg");
+
+	feature = kzalloc(sizeof(*feature), GFP_KERNEL);
+	if (!feature) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* DF_ENCRYPTION_DISABLE and DF_SNIFF_MODE_ENABLE are disabled */
+	feature->data_flow_options = 0;
+	feature->options = 0;
+
+	ret = wl1271_cmd_configure(wl, ACX_FEATURE_CFG,
+				   feature, sizeof(*feature));
+	if (ret < 0) {
+		wl1271_error("Couldnt set HW encryption");
+		goto out;
+	}
+
+out:
+	kfree(feature);
+	return ret;
+}
+
+int wl1271_acx_mem_map(struct wl1271 *wl, struct acx_header *mem_map,
+		       size_t len)
+{
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx mem map");
+
+	ret = wl1271_cmd_interrogate(wl, ACX_MEM_MAP, mem_map, len);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+int wl1271_acx_rx_msdu_life_time(struct wl1271 *wl, u32 life_time)
+{
+	struct acx_rx_msdu_lifetime *acx;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx rx msdu life time");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->lifetime = life_time;
+	ret = wl1271_cmd_configure(wl, DOT11_RX_MSDU_LIFE_TIME,
+				   acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("failed to set rx msdu life time: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
+
+int wl1271_acx_rx_config(struct wl1271 *wl, u32 config, u32 filter)
+{
+	struct acx_rx_config *rx_config;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx rx config");
+
+	rx_config = kzalloc(sizeof(*rx_config), GFP_KERNEL);
+	if (!rx_config) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	rx_config->config_options = config;
+	rx_config->filter_options = filter;
+
+	ret = wl1271_cmd_configure(wl, ACX_RX_CFG,
+				   rx_config, sizeof(*rx_config));
+	if (ret < 0) {
+		wl1271_warning("failed to set rx config: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(rx_config);
+	return ret;
+}
+
+int wl1271_acx_pd_threshold(struct wl1271 *wl)
+{
+	struct acx_packet_detection *pd;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx data pd threshold");
+
+	pd = kzalloc(sizeof(*pd), GFP_KERNEL);
+	if (!pd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* FIXME: threshold value not set */
+
+	ret = wl1271_cmd_configure(wl, ACX_PD_THRESHOLD, pd, sizeof(*pd));
+	if (ret < 0) {
+		wl1271_warning("failed to set pd threshold: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(pd);
+	return 0;
+}
+
+int wl1271_acx_slot(struct wl1271 *wl, enum acx_slot_type slot_time)
+{
+	struct acx_slot *slot;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx slot");
+
+	slot = kzalloc(sizeof(*slot), GFP_KERNEL);
+	if (!slot) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	slot->wone_index = STATION_WONE_INDEX;
+	slot->slot_time = slot_time;
+
+	ret = wl1271_cmd_configure(wl, ACX_SLOT, slot, sizeof(*slot));
+	if (ret < 0) {
+		wl1271_warning("failed to set slot time: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(slot);
+	return ret;
+}
+
+int wl1271_acx_group_address_tbl(struct wl1271 *wl)
+{
+	struct acx_dot11_grp_addr_tbl *acx;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx group address tbl");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* MAC filtering */
+	acx->enabled = 0;
+	acx->num_groups = 0;
+	memset(acx->mac_table, 0, ADDRESS_GROUP_MAX_LEN);
+
+	ret = wl1271_cmd_configure(wl, DOT11_GROUP_ADDRESS_TBL,
+				   acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("failed to set group addr table: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
+
+int wl1271_acx_service_period_timeout(struct wl1271 *wl)
+{
+	struct acx_rx_timeout *rx_timeout;
+	int ret;
+
+	rx_timeout = kzalloc(sizeof(*rx_timeout), GFP_KERNEL);
+	if (!rx_timeout) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	wl1271_debug(DEBUG_ACX, "acx service period timeout");
+
+	rx_timeout->ps_poll_timeout = RX_TIMEOUT_PS_POLL_DEF;
+	rx_timeout->upsd_timeout = RX_TIMEOUT_UPSD_DEF;
+
+	ret = wl1271_cmd_configure(wl, ACX_SERVICE_PERIOD_TIMEOUT,
+				   rx_timeout, sizeof(*rx_timeout));
+	if (ret < 0) {
+		wl1271_warning("failed to set service period timeout: %d",
+			       ret);
+		goto out;
+	}
+
+out:
+	kfree(rx_timeout);
+	return ret;
+}
+
+int wl1271_acx_rts_threshold(struct wl1271 *wl, u16 rts_threshold)
+{
+	struct acx_rts_threshold *rts;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx rts threshold");
+
+	rts = kzalloc(sizeof(*rts), GFP_KERNEL);
+	if (!rts) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	rts->threshold = rts_threshold;
+
+	ret = wl1271_cmd_configure(wl, DOT11_RTS_THRESHOLD, rts, sizeof(*rts));
+	if (ret < 0) {
+		wl1271_warning("failed to set rts threshold: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(rts);
+	return ret;
+}
+
+int wl1271_acx_beacon_filter_opt(struct wl1271 *wl)
+{
+	struct acx_beacon_filter_option *beacon_filter;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx beacon filter opt");
+
+	beacon_filter = kzalloc(sizeof(*beacon_filter), GFP_KERNEL);
+	if (!beacon_filter) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	beacon_filter->enable = 0;
+	beacon_filter->max_num_beacons = 0;
+
+	ret = wl1271_cmd_configure(wl, ACX_BEACON_FILTER_OPT,
+				   beacon_filter, sizeof(*beacon_filter));
+	if (ret < 0) {
+		wl1271_warning("failed to set beacon filter opt: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(beacon_filter);
+	return ret;
+}
+
+int wl1271_acx_beacon_filter_table(struct wl1271 *wl)
+{
+	struct acx_beacon_filter_ie_table *ie_table;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx beacon filter table");
+
+	ie_table = kzalloc(sizeof(*ie_table), GFP_KERNEL);
+	if (!ie_table) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ie_table->num_ie = 0;
+	memset(ie_table->table, 0, BEACON_FILTER_TABLE_MAX_SIZE);
+
+	ret = wl1271_cmd_configure(wl, ACX_BEACON_FILTER_TABLE,
+				   ie_table, sizeof(*ie_table));
+	if (ret < 0) {
+		wl1271_warning("failed to set beacon filter table: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(ie_table);
+	return ret;
+}
+
+int wl1271_acx_sg_enable(struct wl1271 *wl)
+{
+	struct acx_bt_wlan_coex *pta;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx sg enable");
+
+	pta = kzalloc(sizeof(*pta), GFP_KERNEL);
+	if (!pta) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	pta->enable = SG_ENABLE;
+
+	ret = wl1271_cmd_configure(wl, ACX_SG_ENABLE, pta, sizeof(*pta));
+	if (ret < 0) {
+		wl1271_warning("failed to set softgemini enable: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(pta);
+	return ret;
+}
+
+int wl1271_acx_sg_cfg(struct wl1271 *wl)
+{
+	struct acx_bt_wlan_coex_param *param;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx sg cfg");
+
+	param = kzalloc(sizeof(*param), GFP_KERNEL);
+	if (!param) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* BT-WLAN coext parameters */
+	param->min_rate = RATE_INDEX_24MBPS;
+	param->bt_hp_max_time = PTA_BT_HP_MAXTIME_DEF;
+	param->wlan_hp_max_time = PTA_WLAN_HP_MAX_TIME_DEF;
+	param->sense_disable_timer = PTA_SENSE_DISABLE_TIMER_DEF;
+	param->rx_time_bt_hp = PTA_PROTECTIVE_RX_TIME_DEF;
+	param->tx_time_bt_hp = PTA_PROTECTIVE_TX_TIME_DEF;
+	param->rx_time_bt_hp_fast = PTA_PROTECTIVE_RX_TIME_FAST_DEF;
+	param->tx_time_bt_hp_fast = PTA_PROTECTIVE_TX_TIME_FAST_DEF;
+	param->wlan_cycle_fast = PTA_CYCLE_TIME_FAST_DEF;
+	param->bt_anti_starvation_period = PTA_ANTI_STARVE_PERIOD_DEF;
+	param->next_bt_lp_packet = PTA_TIMEOUT_NEXT_BT_LP_PACKET_DEF;
+	param->wake_up_beacon = PTA_TIME_BEFORE_BEACON_DEF;
+	param->hp_dm_max_guard_time = PTA_HPDM_MAX_TIME_DEF;
+	param->next_wlan_packet = PTA_TIME_OUT_NEXT_WLAN_DEF;
+	param->antenna_type = PTA_ANTENNA_TYPE_DEF;
+	param->signal_type = PTA_SIGNALING_TYPE_DEF;
+	param->afh_leverage_on = PTA_AFH_LEVERAGE_ON_DEF;
+	param->quiet_cycle_num = PTA_NUMBER_QUIET_CYCLE_DEF;
+	param->max_cts = PTA_MAX_NUM_CTS_DEF;
+	param->wlan_packets_num = PTA_NUMBER_OF_WLAN_PACKETS_DEF;
+	param->bt_packets_num = PTA_NUMBER_OF_BT_PACKETS_DEF;
+	param->missed_rx_avalanche = PTA_RX_FOR_AVALANCHE_DEF;
+	param->wlan_elp_hp = PTA_ELP_HP_DEF;
+	param->bt_anti_starvation_cycles = PTA_ANTI_STARVE_NUM_CYCLE_DEF;
+	param->ack_mode_dual_ant = PTA_ACK_MODE_DEF;
+	param->pa_sd_enable = PTA_ALLOW_PA_SD_DEF;
+	param->pta_auto_mode_enable = PTA_AUTO_MODE_NO_CTS_DEF;
+	param->bt_hp_respected_num = PTA_BT_HP_RESPECTED_DEF;
+
+	ret = wl1271_cmd_configure(wl, ACX_SG_CFG, param, sizeof(*param));
+	if (ret < 0) {
+		wl1271_warning("failed to set sg config: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(param);
+	return ret;
+}
+
+int wl1271_acx_cca_threshold(struct wl1271 *wl)
+{
+	struct acx_energy_detection *detection;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx cca threshold");
+
+	detection = kzalloc(sizeof(*detection), GFP_KERNEL);
+	if (!detection) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	detection->rx_cca_threshold = CCA_THRSH_DISABLE_ENERGY_D;
+	detection->tx_energy_detection = 0;
+
+	ret = wl1271_cmd_configure(wl, ACX_CCA_THRESHOLD,
+				   detection, sizeof(*detection));
+	if (ret < 0) {
+		wl1271_warning("failed to set cca threshold: %d", ret);
+		return ret;
+	}
+
+out:
+	kfree(detection);
+	return ret;
+}
+
+int wl1271_acx_bcn_dtim_options(struct wl1271 *wl)
+{
+	struct acx_beacon_broadcast *bb;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx bcn dtim options");
+
+	bb = kzalloc(sizeof(*bb), GFP_KERNEL);
+	if (!bb) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	bb->beacon_rx_timeout = BCN_RX_TIMEOUT_DEF_VALUE;
+	bb->broadcast_timeout = BROADCAST_RX_TIMEOUT_DEF_VALUE;
+	bb->rx_broadcast_in_ps = RX_BROADCAST_IN_PS_DEF_VALUE;
+	bb->ps_poll_threshold = CONSECUTIVE_PS_POLL_FAILURE_DEF;
+
+	ret = wl1271_cmd_configure(wl, ACX_BCN_DTIM_OPTIONS, bb, sizeof(*bb));
+	if (ret < 0) {
+		wl1271_warning("failed to set rx config: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(bb);
+	return ret;
+}
+
+int wl1271_acx_aid(struct wl1271 *wl, u16 aid)
+{
+	struct acx_aid *acx_aid;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx aid");
+
+	acx_aid = kzalloc(sizeof(*acx_aid), GFP_KERNEL);
+	if (!acx_aid) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx_aid->aid = aid;
+
+	ret = wl1271_cmd_configure(wl, ACX_AID, acx_aid, sizeof(*acx_aid));
+	if (ret < 0) {
+		wl1271_warning("failed to set aid: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx_aid);
+	return ret;
+}
+
+int wl1271_acx_event_mbox_mask(struct wl1271 *wl, u32 event_mask)
+{
+	struct acx_event_mask *mask;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx event mbox mask");
+
+	mask = kzalloc(sizeof(*mask), GFP_KERNEL);
+	if (!mask) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* high event mask is unused */
+	mask->high_event_mask = 0xffffffff;
+
+	mask->event_mask = event_mask;
+
+	ret = wl1271_cmd_configure(wl, ACX_EVENT_MBOX_MASK,
+				   mask, sizeof(*mask));
+	if (ret < 0) {
+		wl1271_warning("failed to set acx_event_mbox_mask: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(mask);
+	return ret;
+}
+
+int wl1271_acx_set_preamble(struct wl1271 *wl, enum acx_preamble_type preamble)
+{
+	struct acx_preamble *acx;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx_set_preamble");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->preamble = preamble;
+
+	ret = wl1271_cmd_configure(wl, ACX_PREAMBLE_TYPE, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("Setting of preamble failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
+
+int wl1271_acx_cts_protect(struct wl1271 *wl,
+			   enum acx_ctsprotect_type ctsprotect)
+{
+	struct acx_ctsprotect *acx;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx_set_ctsprotect");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->ctsprotect = ctsprotect;
+
+	ret = wl1271_cmd_configure(wl, ACX_CTS_PROTECTION, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("Setting of ctsprotect failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
+
+int wl1271_acx_statistics(struct wl1271 *wl, struct acx_statistics *stats)
+{
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "acx statistics");
+
+	ret = wl1271_cmd_interrogate(wl, ACX_STATISTICS, stats,
+				     sizeof(*stats));
+	if (ret < 0) {
+		wl1271_warning("acx statistics failed: %d", ret);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+int wl1271_acx_rate_policies(struct wl1271 *wl)
+{
+	struct acx_rate_policy *acx;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_ACX, "acx rate policies");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* configure one default (one-size-fits-all) rate class */
+	acx->rate_class_cnt = 1;
+	acx->rate_class[0].enabled_rates = ACX_RATE_MASK_ALL;
+	acx->rate_class[0].short_retry_limit = ACX_RATE_RETRY_LIMIT;
+	acx->rate_class[0].long_retry_limit = ACX_RATE_RETRY_LIMIT;
+	acx->rate_class[0].aflags = 0;
+
+	ret = wl1271_cmd_configure(wl, ACX_RATE_POLICY, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("Setting of rate policies failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
+
+int wl1271_acx_ac_cfg(struct wl1271 *wl)
+{
+	struct acx_ac_cfg *acx;
+	int i, ret = 0;
+
+	wl1271_debug(DEBUG_ACX, "acx access category config");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/*
+	 * FIXME: Configure each AC with appropriate values (most suitable
+	 * values will probably be different for each AC.
+	 */
+	for (i = 0; i < WL1271_ACX_AC_COUNT; i++) {
+		acx->ac = i;
+
+		/*
+		 * FIXME: The following default values originate from
+		 * the TI reference driver. What do they mean?
+		 */
+		acx->cw_min = 15;
+		acx->cw_max = 63;
+		acx->aifsn = 3;
+		acx->reserved = 0;
+		acx->tx_op_limit = 0;
+
+		ret = wl1271_cmd_configure(wl, ACX_AC_CFG, acx, sizeof(*acx));
+		if (ret < 0) {
+			wl1271_warning("Setting of access category "
+				       "config: %d", ret);
+			goto out;
+		}
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
+
+int wl1271_acx_tid_cfg(struct wl1271 *wl)
+{
+	struct acx_tid_config *acx;
+	int i, ret = 0;
+
+	wl1271_debug(DEBUG_ACX, "acx tid config");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* FIXME: configure each TID with a different AC reference */
+	for (i = 0; i < WL1271_ACX_TID_COUNT; i++) {
+		acx->queue_id = i;
+		acx->tsid = WL1271_ACX_AC_BE;
+		acx->ps_scheme = WL1271_ACX_PS_SCHEME_LEGACY;
+		acx->ack_policy = WL1271_ACX_ACK_POLICY_LEGACY;
+
+		ret = wl1271_cmd_configure(wl, ACX_TID_CFG, acx, sizeof(*acx));
+		if (ret < 0) {
+			wl1271_warning("Setting of tid config failed: %d", ret);
+			goto out;
+		}
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
+
+int wl1271_acx_frag_threshold(struct wl1271 *wl)
+{
+	struct acx_frag_threshold *acx;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_ACX, "acx frag threshold");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->frag_threshold = IEEE80211_MAX_FRAG_THRESHOLD;
+	ret = wl1271_cmd_configure(wl, ACX_FRAG_CFG, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("Setting of frag threshold failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
+
+int wl1271_acx_tx_config_options(struct wl1271 *wl)
+{
+	struct acx_tx_config_options *acx;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_ACX, "acx tx config options");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->tx_compl_timeout = WL1271_ACX_TX_COMPL_TIMEOUT;
+	acx->tx_compl_threshold = WL1271_ACX_TX_COMPL_THRESHOLD;
+	ret = wl1271_cmd_configure(wl, ACX_TX_CONFIG_OPT, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("Setting of tx options failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
+
+int wl1271_acx_mem_cfg(struct wl1271 *wl)
+{
+	struct wl1271_acx_config_memory *mem_conf;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "wl1271 mem cfg");
+
+	mem_conf = kzalloc(sizeof(*mem_conf), GFP_KERNEL);
+	if (!mem_conf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* memory config */
+	mem_conf->num_stations = cpu_to_le16(DEFAULT_NUM_STATIONS);
+	mem_conf->rx_mem_block_num = ACX_RX_MEM_BLOCKS;
+	mem_conf->tx_min_mem_block_num = ACX_TX_MIN_MEM_BLOCKS;
+	mem_conf->num_ssid_profiles = ACX_NUM_SSID_PROFILES;
+	mem_conf->total_tx_descriptors = ACX_TX_DESCRIPTORS;
+
+	ret = wl1271_cmd_configure(wl, ACX_MEM_CFG, mem_conf,
+				   sizeof(*mem_conf));
+	if (ret < 0) {
+		wl1271_warning("wl1271 mem config failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(mem_conf);
+	return ret;
+}
+
+int wl1271_acx_init_mem_config(struct wl1271 *wl)
+{
+	int ret;
+
+	ret = wl1271_acx_mem_cfg(wl);
+	if (ret < 0)
+		return ret;
+
+	wl->target_mem_map = kzalloc(sizeof(struct wl1271_acx_mem_map),
+					  GFP_KERNEL);
+	if (!wl->target_mem_map) {
+		wl1271_error("couldn't allocate target memory map");
+		return -ENOMEM;
+	}
+
+	/* we now ask for the firmware built memory map */
+	ret = wl1271_acx_mem_map(wl, (void *)wl->target_mem_map,
+				 sizeof(struct wl1271_acx_mem_map));
+	if (ret < 0) {
+		wl1271_error("couldn't retrieve firmware memory map");
+		kfree(wl->target_mem_map);
+		wl->target_mem_map = NULL;
+		return ret;
+	}
+
+	/* initialize TX block book keeping */
+	wl->tx_blocks_available = wl->target_mem_map->num_tx_mem_blocks;
+	wl1271_debug(DEBUG_TX, "available tx blocks: %d",
+		     wl->tx_blocks_available);
+
+	return 0;
+}
+
+int wl1271_acx_init_rx_interrupt(struct wl1271 *wl)
+{
+	struct wl1271_acx_rx_config_opt *rx_conf;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "wl1271 rx interrupt config");
+
+	rx_conf = kzalloc(sizeof(*rx_conf), GFP_KERNEL);
+	if (!rx_conf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	rx_conf->threshold = WL1271_RX_INTR_THRESHOLD_DEF;
+	rx_conf->timeout = WL1271_RX_INTR_TIMEOUT_DEF;
+	rx_conf->mblk_threshold = USHORT_MAX; /* Disabled */
+	rx_conf->queue_type = RX_QUEUE_TYPE_RX_LOW_PRIORITY;
+
+	ret = wl1271_cmd_configure(wl, ACX_RX_CONFIG_OPT, rx_conf,
+				   sizeof(*rx_conf));
+	if (ret < 0) {
+		wl1271_warning("wl1271 rx config opt failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(rx_conf);
+	return ret;
+}
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
new file mode 100644
index 0000000..9068daa
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -0,0 +1,1221 @@
+/*
+ * This file is part of wl1271
+ *
+ * Copyright (C) 1998-2009 Texas Instruments. All rights reserved.
+ * Copyright (C) 2008-2009 Nokia Corporation
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
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
+#ifndef __WL1271_ACX_H__
+#define __WL1271_ACX_H__
+
+#include "wl1271.h"
+#include "wl1271_cmd.h"
+
+/*************************************************************************
+
+    Host Interrupt Register (WiLink -> Host)
+
+**************************************************************************/
+/* HW Initiated interrupt Watchdog timer expiration */
+#define WL1271_ACX_INTR_WATCHDOG           BIT(0)
+/* Init sequence is done (masked interrupt, detection through polling only ) */
+#define WL1271_ACX_INTR_INIT_COMPLETE      BIT(1)
+/* Event was entered to Event MBOX #A*/
+#define WL1271_ACX_INTR_EVENT_A            BIT(2)
+/* Event was entered to Event MBOX #B*/
+#define WL1271_ACX_INTR_EVENT_B            BIT(3)
+/* Command processing completion*/
+#define WL1271_ACX_INTR_CMD_COMPLETE       BIT(4)
+/* Signaling the host on HW wakeup */
+#define WL1271_ACX_INTR_HW_AVAILABLE       BIT(5)
+/* The MISC bit is used for aggregation of RX, TxComplete and TX rate update */
+#define WL1271_ACX_INTR_DATA               BIT(6)
+/* Trace meassge on MBOX #A */
+#define WL1271_ACX_INTR_TRACE_A            BIT(7)
+/* Trace meassge on MBOX #B */
+#define WL1271_ACX_INTR_TRACE_B            BIT(8)
+
+#define WL1271_ACX_INTR_ALL		   0xFFFFFFFF
+#define WL1271_ACX_ALL_EVENTS_VECTOR       (WL1271_ACX_INTR_WATCHDOG      | \
+					    WL1271_ACX_INTR_INIT_COMPLETE | \
+					    WL1271_ACX_INTR_EVENT_A       | \
+					    WL1271_ACX_INTR_EVENT_B       | \
+					    WL1271_ACX_INTR_CMD_COMPLETE  | \
+					    WL1271_ACX_INTR_HW_AVAILABLE  | \
+					    WL1271_ACX_INTR_DATA)
+
+#define WL1271_INTR_MASK                   (WL1271_ACX_INTR_EVENT_A |	\
+					    WL1271_ACX_INTR_EVENT_B | \
+					    WL1271_ACX_INTR_DATA)
+
+/* Target's information element */
+struct acx_header {
+	struct wl1271_cmd_header cmd;
+
+	/* acx (or information element) header */
+	u16 id;
+
+	/* payload length (not including headers */
+	u16 len;
+};
+
+struct acx_error_counter {
+	struct acx_header header;
+
+	/* The number of PLCP errors since the last time this */
+	/* information element was interrogated. This field is */
+	/* automatically cleared when it is interrogated.*/
+	u32 PLCP_error;
+
+	/* The number of FCS errors since the last time this */
+	/* information element was interrogated. This field is */
+	/* automatically cleared when it is interrogated.*/
+	u32 FCS_error;
+
+	/* The number of MPDUs without PLCP header errors received*/
+	/* since the last time this information element was interrogated. */
+	/* This field is automatically cleared when it is interrogated.*/
+	u32 valid_frame;
+
+	/* the number of missed sequence numbers in the squentially */
+	/* values of frames seq numbers */
+	u32 seq_num_miss;
+} __attribute__ ((packed));
+
+struct acx_revision {
+	struct acx_header header;
+
+	/*
+	 * The WiLink firmware version, an ASCII string x.x.x.x,
+	 * that uniquely identifies the current firmware.
+	 * The left most digit is incremented each time a
+	 * significant change is made to the firmware, such as
+	 * code redesign or new platform support.
+	 * The second digit is incremented when major enhancements
+	 * are added or major fixes are made.
+	 * The third digit is incremented for each GA release.
+	 * The fourth digit is incremented for each build.
+	 * The first two digits identify a firmware release version,
+	 * in other words, a unique set of features.
+	 * The first three digits identify a GA release.
+	 */
+	char fw_version[20];
+
+	/*
+	 * This 4 byte field specifies the WiLink hardware version.
+	 * bits 0  - 15: Reserved.
+	 * bits 16 - 23: Version ID - The WiLink version ID
+	 *              (1 = first spin, 2 = second spin, and so on).
+	 * bits 24 - 31: Chip ID - The WiLink chip ID.
+	 */
+	u32 hw_version;
+} __attribute__ ((packed));
+
+enum wl1271_psm_mode {
+	/* Active mode */
+	WL1271_PSM_CAM = 0,
+
+	/* Power save mode */
+	WL1271_PSM_PS = 1,
+
+	/* Extreme low power */
+	WL1271_PSM_ELP = 2,
+};
+
+struct acx_sleep_auth {
+	struct acx_header header;
+
+	/* The sleep level authorization of the device. */
+	/* 0 - Always active*/
+	/* 1 - Power down mode: light / fast sleep*/
+	/* 2 - ELP mode: Deep / Max sleep*/
+	u8  sleep_auth;
+	u8  padding[3];
+} __attribute__ ((packed));
+
+enum {
+	HOSTIF_PCI_MASTER_HOST_INDIRECT,
+	HOSTIF_PCI_MASTER_HOST_DIRECT,
+	HOSTIF_SLAVE,
+	HOSTIF_PKT_RING,
+	HOSTIF_DONTCARE = 0xFF
+};
+
+#define DEFAULT_UCAST_PRIORITY          0
+#define DEFAULT_RX_Q_PRIORITY           0
+#define DEFAULT_NUM_STATIONS            1
+#define DEFAULT_RXQ_PRIORITY            0 /* low 0 .. 15 high  */
+#define DEFAULT_RXQ_TYPE                0x07    /* All frames, Data/Ctrl/Mgmt */
+#define TRACE_BUFFER_MAX_SIZE           256
+
+#define  DP_RX_PACKET_RING_CHUNK_SIZE 1600
+#define  DP_TX_PACKET_RING_CHUNK_SIZE 1600
+#define  DP_RX_PACKET_RING_CHUNK_NUM 2
+#define  DP_TX_PACKET_RING_CHUNK_NUM 2
+#define  DP_TX_COMPLETE_TIME_OUT 20
+#define  FW_TX_CMPLT_BLOCK_SIZE 16
+
+#define TX_MSDU_LIFETIME_MIN       0
+#define TX_MSDU_LIFETIME_MAX       3000
+#define TX_MSDU_LIFETIME_DEF       512
+#define RX_MSDU_LIFETIME_MIN       0
+#define RX_MSDU_LIFETIME_MAX       0xFFFFFFFF
+#define RX_MSDU_LIFETIME_DEF       512000
+
+struct acx_rx_msdu_lifetime {
+	struct acx_header header;
+
+	/*
+	 * The maximum amount of time, in TU, before the
+	 * firmware discards the MSDU.
+	 */
+	u32 lifetime;
+} __attribute__ ((packed));
+
+/*
+ * RX Config Options Table
+ * Bit		Definition
+ * ===		==========
+ * 31:14		Reserved
+ * 13		Copy RX Status - when set, write three receive status words
+ *		to top of rx'd MPDUs.
+ *		When cleared, do not write three status words (added rev 1.5)
+ * 12		Reserved
+ * 11		RX Complete upon FCS error - when set, give rx complete
+ *		interrupt for FCS errors, after the rx filtering, e.g. unicast
+ *		frames not to us with FCS error will not generate an interrupt.
+ * 10		SSID Filter Enable - When set, the WiLink discards all beacon,
+ *	        probe request, and probe response frames with an SSID that does
+ *		not match the SSID specified by the host in the START/JOIN
+ *		command.
+ *		When clear, the WiLink receives frames with any SSID.
+ * 9		Broadcast Filter Enable - When set, the WiLink discards all
+ *		broadcast frames. When clear, the WiLink receives all received
+ *		broadcast frames.
+ * 8:6		Reserved
+ * 5		BSSID Filter Enable - When set, the WiLink discards any frames
+ *		with a BSSID that does not match the BSSID specified by the
+ *		host.
+ *		When clear, the WiLink receives frames from any BSSID.
+ * 4		MAC Addr Filter - When set, the WiLink discards any frames
+ *		with a destination address that does not match the MAC address
+ *		of the adaptor.
+ *		When clear, the WiLink receives frames destined to any MAC
+ *		address.
+ * 3		Promiscuous - When set, the WiLink receives all valid frames
+ *		(i.e., all frames that pass the FCS check).
+ *		When clear, only frames that pass the other filters specified
+ *		are received.
+ * 2		FCS - When set, the WiLink includes the FCS with the received
+ *		frame.
+ *		When cleared, the FCS is discarded.
+ * 1		PLCP header - When set, write all data from baseband to frame
+ *		buffer including PHY header.
+ * 0		Reserved - Always equal to 0.
+ *
+ * RX Filter Options Table
+ * Bit		Definition
+ * ===		==========
+ * 31:12		Reserved - Always equal to 0.
+ * 11		Association - When set, the WiLink receives all association
+ *		related frames (association request/response, reassocation
+ *		request/response, and disassociation). When clear, these frames
+ *		are discarded.
+ * 10		Auth/De auth - When set, the WiLink receives all authentication
+ *		and de-authentication frames. When clear, these frames are
+ *		discarded.
+ * 9		Beacon - When set, the WiLink receives all beacon frames.
+ *		When clear, these frames are discarded.
+ * 8		Contention Free - When set, the WiLink receives all contention
+ *		free frames.
+ *		When clear, these frames are discarded.
+ * 7		Control - When set, the WiLink receives all control frames.
+ *		When clear, these frames are discarded.
+ * 6		Data - When set, the WiLink receives all data frames.
+ *		When clear, these frames are discarded.
+ * 5		FCS Error - When set, the WiLink receives frames that have FCS
+ *		errors.
+ *		When clear, these frames are discarded.
+ * 4		Management - When set, the WiLink receives all management
+ *		frames.
+ *		When clear, these frames are discarded.
+ * 3		Probe Request - When set, the WiLink receives all probe request
+ *		frames.
+ *		When clear, these frames are discarded.
+ * 2		Probe Response - When set, the WiLink receives all probe
+ *		response frames.
+ *		When clear, these frames are discarded.
+ * 1		RTS/CTS/ACK - When set, the WiLink receives all RTS, CTS and ACK
+ *		frames.
+ *		When clear, these frames are discarded.
+ * 0		Rsvd Type/Sub Type - When set, the WiLink receives all frames
+ *		that have reserved frame types and sub types as defined by the
+ *		802.11 specification.
+ *		When clear, these frames are discarded.
+ */
+struct acx_rx_config {
+	struct acx_header header;
+
+	u32 config_options;
+	u32 filter_options;
+} __attribute__ ((packed));
+
+struct acx_packet_detection {
+	struct acx_header header;
+
+	u32 threshold;
+} __attribute__ ((packed));
+
+
+enum acx_slot_type {
+	SLOT_TIME_LONG = 0,
+	SLOT_TIME_SHORT = 1,
+	DEFAULT_SLOT_TIME = SLOT_TIME_SHORT,
+	MAX_SLOT_TIMES = 0xFF
+};
+
+#define STATION_WONE_INDEX 0
+
+struct acx_slot {
+	struct acx_header header;
+
+	u8 wone_index; /* Reserved */
+	u8 slot_time;
+	u8 reserved[6];
+} __attribute__ ((packed));
+
+
+#define ADDRESS_GROUP_MAX	(8)
+#define ADDRESS_GROUP_MAX_LEN	(ETH_ALEN * ADDRESS_GROUP_MAX)
+
+struct acx_dot11_grp_addr_tbl {
+	struct acx_header header;
+
+	u8 enabled;
+	u8 num_groups;
+	u8 pad[2];
+	u8 mac_table[ADDRESS_GROUP_MAX_LEN];
+} __attribute__ ((packed));
+
+
+#define  RX_TIMEOUT_PS_POLL_MIN    0
+#define  RX_TIMEOUT_PS_POLL_MAX    (200000)
+#define  RX_TIMEOUT_PS_POLL_DEF    (15)
+#define  RX_TIMEOUT_UPSD_MIN       0
+#define  RX_TIMEOUT_UPSD_MAX       (200000)
+#define  RX_TIMEOUT_UPSD_DEF       (15)
+
+struct acx_rx_timeout {
+	struct acx_header header;
+
+	/*
+	 * The longest time the STA will wait to receive
+	 * traffic from the AP after a PS-poll has been
+	 * transmitted.
+	 */
+	u16 ps_poll_timeout;
+
+	/*
+	 * The longest time the STA will wait to receive
+	 * traffic from the AP after a frame has been sent
+	 * from an UPSD enabled queue.
+	 */
+	u16 upsd_timeout;
+} __attribute__ ((packed));
+
+#define RTS_THRESHOLD_MIN              0
+#define RTS_THRESHOLD_MAX              4096
+#define RTS_THRESHOLD_DEF              2347
+
+struct acx_rts_threshold {
+	struct acx_header header;
+
+	u16 threshold;
+	u8 pad[2];
+} __attribute__ ((packed));
+
+struct acx_beacon_filter_option {
+	struct acx_header header;
+
+	u8 enable;
+
+	/*
+	 * The number of beacons without the unicast TIM
+	 * bit set that the firmware buffers before
+	 * signaling the host about ready frames.
+	 * When set to 0 and the filter is enabled, beacons
+	 * without the unicast TIM bit set are dropped.
+	 */
+	u8 max_num_beacons;
+	u8 pad[2];
+} __attribute__ ((packed));
+
+/*
+ * ACXBeaconFilterEntry (not 221)
+ * Byte Offset     Size (Bytes)    Definition
+ * ===========     ============    ==========
+ * 0				1               IE identifier
+ * 1               1               Treatment bit mask
+ *
+ * ACXBeaconFilterEntry (221)
+ * Byte Offset     Size (Bytes)    Definition
+ * ===========     ============    ==========
+ * 0               1               IE identifier
+ * 1               1               Treatment bit mask
+ * 2               3               OUI
+ * 5               1               Type
+ * 6               2               Version
+ *
+ *
+ * Treatment bit mask - The information element handling:
+ * bit 0 - The information element is compared and transferred
+ * in case of change.
+ * bit 1 - The information element is transferred to the host
+ * with each appearance or disappearance.
+ * Note that both bits can be set at the same time.
+ */
+#define	BEACON_FILTER_TABLE_MAX_IE_NUM		       (32)
+#define BEACON_FILTER_TABLE_MAX_VENDOR_SPECIFIC_IE_NUM (6)
+#define BEACON_FILTER_TABLE_IE_ENTRY_SIZE	       (2)
+#define BEACON_FILTER_TABLE_EXTRA_VENDOR_SPECIFIC_IE_SIZE (6)
+#define BEACON_FILTER_TABLE_MAX_SIZE ((BEACON_FILTER_TABLE_MAX_IE_NUM * \
+			    BEACON_FILTER_TABLE_IE_ENTRY_SIZE) + \
+			   (BEACON_FILTER_TABLE_MAX_VENDOR_SPECIFIC_IE_NUM * \
+			    BEACON_FILTER_TABLE_EXTRA_VENDOR_SPECIFIC_IE_SIZE))
+
+struct acx_beacon_filter_ie_table {
+	struct acx_header header;
+
+	u8 num_ie;
+	u8 table[BEACON_FILTER_TABLE_MAX_SIZE];
+	u8 pad[3];
+} __attribute__ ((packed));
+
+enum {
+	SG_ENABLE = 0,
+	SG_DISABLE,
+	SG_SENSE_NO_ACTIVITY,
+	SG_SENSE_ACTIVE
+};
+
+struct acx_bt_wlan_coex {
+	struct acx_header header;
+
+	/*
+	 * 0 -> PTA enabled
+	 * 1 -> PTA disabled
+	 * 2 -> sense no active mode, i.e.
+	 *      an interrupt is sent upon
+	 *      BT activity.
+	 * 3 -> PTA is switched on in response
+	 *      to the interrupt sending.
+	 */
+	u8 enable;
+	u8 pad[3];
+} __attribute__ ((packed));
+
+#define PTA_ANTENNA_TYPE_DEF		  (0)
+#define PTA_BT_HP_MAXTIME_DEF		  (2000)
+#define PTA_WLAN_HP_MAX_TIME_DEF	  (5000)
+#define PTA_SENSE_DISABLE_TIMER_DEF	  (1350)
+#define PTA_PROTECTIVE_RX_TIME_DEF	  (1500)
+#define PTA_PROTECTIVE_TX_TIME_DEF	  (1500)
+#define PTA_TIMEOUT_NEXT_BT_LP_PACKET_DEF (3000)
+#define PTA_SIGNALING_TYPE_DEF		  (1)
+#define PTA_AFH_LEVERAGE_ON_DEF		  (0)
+#define PTA_NUMBER_QUIET_CYCLE_DEF	  (0)
+#define PTA_MAX_NUM_CTS_DEF		  (3)
+#define PTA_NUMBER_OF_WLAN_PACKETS_DEF	  (2)
+#define PTA_NUMBER_OF_BT_PACKETS_DEF	  (2)
+#define PTA_PROTECTIVE_RX_TIME_FAST_DEF	  (1500)
+#define PTA_PROTECTIVE_TX_TIME_FAST_DEF	  (3000)
+#define PTA_CYCLE_TIME_FAST_DEF		  (8700)
+#define PTA_RX_FOR_AVALANCHE_DEF	  (5)
+#define PTA_ELP_HP_DEF			  (0)
+#define PTA_ANTI_STARVE_PERIOD_DEF	  (500)
+#define PTA_ANTI_STARVE_NUM_CYCLE_DEF	  (4)
+#define PTA_ALLOW_PA_SD_DEF		  (1)
+#define PTA_TIME_BEFORE_BEACON_DEF	  (6300)
+#define PTA_HPDM_MAX_TIME_DEF		  (1600)
+#define PTA_TIME_OUT_NEXT_WLAN_DEF	  (2550)
+#define PTA_AUTO_MODE_NO_CTS_DEF	  (0)
+#define PTA_BT_HP_RESPECTED_DEF		  (3)
+#define PTA_WLAN_RX_MIN_RATE_DEF	  (24)
+#define PTA_ACK_MODE_DEF		  (1)
+
+struct acx_bt_wlan_coex_param {
+	struct acx_header header;
+
+	/*
+	 * The minimum rate of a received WLAN packet in the STA,
+	 * during protective mode, of which a new BT-HP request
+	 * during this Rx will always be respected and gain the antenna.
+	 */
+	u32 min_rate;
+
+	/* Max time the BT HP will be respected. */
+	u16 bt_hp_max_time;
+
+	/* Max time the WLAN HP will be respected. */
+	u16 wlan_hp_max_time;
+
+	/*
+	 * The time between the last BT activity
+	 * and the moment when the sense mode returns
+	 * to SENSE_INACTIVE.
+	 */
+	u16 sense_disable_timer;
+
+	/* Time before the next BT HP instance */
+	u16 rx_time_bt_hp;
+	u16 tx_time_bt_hp;
+
+	/* range: 10-20000    default: 1500 */
+	u16 rx_time_bt_hp_fast;
+	u16 tx_time_bt_hp_fast;
+
+	/* range: 2000-65535  default: 8700 */
+	u16 wlan_cycle_fast;
+
+	/* range: 0 - 15000 (Msec) default: 1000 */
+	u16 bt_anti_starvation_period;
+
+	/* range 400-10000(Usec) default: 3000 */
+	u16 next_bt_lp_packet;
+
+	/* Deafult: worst case for BT DH5 traffic */
+	u16 wake_up_beacon;
+
+	/* range: 0-50000(Usec) default: 1050 */
+	u16 hp_dm_max_guard_time;
+
+	/*
+	 * This is to prevent both BT & WLAN antenna
+	 * starvation.
+	 * Range: 100-50000(Usec) default:2550
+	 */
+	u16 next_wlan_packet;
+
+	/* 0 -> shared antenna */
+	u8 antenna_type;
+
+	/*
+	 * 0 -> TI legacy
+	 * 1 -> Palau
+	 */
+	u8 signal_type;
+
+	/*
+	 * BT AFH status
+	 * 0 -> no AFH
+	 * 1 -> from dedicated GPIO
+	 * 2 -> AFH on (from host)
+	 */
+	u8 afh_leverage_on;
+
+	/*
+	 * The number of cycles during which no
+	 * TX will be sent after 1 cycle of RX
+	 * transaction in protective mode
+	 */
+	u8 quiet_cycle_num;
+
+	/*
+	 * The maximum number of CTSs that will
+	 * be sent for receiving RX packet in
+	 * protective mode
+	 */
+	u8 max_cts;
+
+	/*
+	 * The number of WLAN packets
+	 * transferred in common mode before
+	 * switching to BT.
+	 */
+	u8 wlan_packets_num;
+
+	/*
+	 * The number of BT packets
+	 * transferred in common mode before
+	 * switching to WLAN.
+	 */
+	u8 bt_packets_num;
+
+	/* range: 1-255  default: 5 */
+	u8 missed_rx_avalanche;
+
+	/* range: 0-1    default: 1 */
+	u8 wlan_elp_hp;
+
+	/* range: 0 - 15  default: 4 */
+	u8 bt_anti_starvation_cycles;
+
+	u8 ack_mode_dual_ant;
+
+	/*
+	 * Allow PA_SD assertion/de-assertion
+	 * during enabled BT activity.
+	 */
+	u8 pa_sd_enable;
+
+	/*
+	 * Enable/Disable PTA in auto mode:
+	 * Support Both Active & P.S modes
+	 */
+	u8 pta_auto_mode_enable;
+
+	/* range: 0 - 20  default: 1 */
+	u8 bt_hp_respected_num;
+} __attribute__ ((packed));
+
+#define CCA_THRSH_ENABLE_ENERGY_D       0x140A
+#define CCA_THRSH_DISABLE_ENERGY_D      0xFFEF
+
+struct acx_energy_detection {
+	struct acx_header header;
+
+	/* The RX Clear Channel Assessment threshold in the PHY */
+	u16 rx_cca_threshold;
+	u8 tx_energy_detection;
+	u8 pad;
+} __attribute__ ((packed));
+
+#define BCN_RX_TIMEOUT_DEF_VALUE        10000
+#define BROADCAST_RX_TIMEOUT_DEF_VALUE  20000
+#define RX_BROADCAST_IN_PS_DEF_VALUE    1
+#define CONSECUTIVE_PS_POLL_FAILURE_DEF 4
+
+struct acx_beacon_broadcast {
+	struct acx_header header;
+
+	u16 beacon_rx_timeout;
+	u16 broadcast_timeout;
+
+	/* Enables receiving of broadcast packets in PS mode */
+	u8 rx_broadcast_in_ps;
+
+	/* Consecutive PS Poll failures before updating the host */
+	u8 ps_poll_threshold;
+	u8 pad[2];
+} __attribute__ ((packed));
+
+struct acx_event_mask {
+	struct acx_header header;
+
+	u32 event_mask;
+	u32 high_event_mask; /* Unused */
+} __attribute__ ((packed));
+
+#define CFG_RX_FCS		BIT(2)
+#define CFG_RX_ALL_GOOD		BIT(3)
+#define CFG_UNI_FILTER_EN	BIT(4)
+#define CFG_BSSID_FILTER_EN	BIT(5)
+#define CFG_MC_FILTER_EN	BIT(6)
+#define CFG_MC_ADDR0_EN		BIT(7)
+#define CFG_MC_ADDR1_EN		BIT(8)
+#define CFG_BC_REJECT_EN	BIT(9)
+#define CFG_SSID_FILTER_EN	BIT(10)
+#define CFG_RX_INT_FCS_ERROR	BIT(11)
+#define CFG_RX_INT_ENCRYPTED	BIT(12)
+#define CFG_RX_WR_RX_STATUS	BIT(13)
+#define CFG_RX_FILTER_NULTI	BIT(14)
+#define CFG_RX_RESERVE		BIT(15)
+#define CFG_RX_TIMESTAMP_TSF	BIT(16)
+
+#define CFG_RX_RSV_EN		BIT(0)
+#define CFG_RX_RCTS_ACK		BIT(1)
+#define CFG_RX_PRSP_EN		BIT(2)
+#define CFG_RX_PREQ_EN		BIT(3)
+#define CFG_RX_MGMT_EN		BIT(4)
+#define CFG_RX_FCS_ERROR	BIT(5)
+#define CFG_RX_DATA_EN		BIT(6)
+#define CFG_RX_CTL_EN		BIT(7)
+#define CFG_RX_CF_EN		BIT(8)
+#define CFG_RX_BCN_EN		BIT(9)
+#define CFG_RX_AUTH_EN		BIT(10)
+#define CFG_RX_ASSOC_EN		BIT(11)
+
+#define SCAN_PASSIVE		BIT(0)
+#define SCAN_5GHZ_BAND		BIT(1)
+#define SCAN_TRIGGERED		BIT(2)
+#define SCAN_PRIORITY_HIGH	BIT(3)
+
+struct acx_feature_config {
+	struct acx_header header;
+
+	u32 options;
+	u32 data_flow_options;
+} __attribute__ ((packed));
+
+struct acx_current_tx_power {
+	struct acx_header header;
+
+	u8  current_tx_power;
+	u8  padding[3];
+} __attribute__ ((packed));
+
+enum acx_wake_up_event {
+	WAKE_UP_EVENT_BEACON_BITMAP	= 0x01, /* Wake on every Beacon*/
+	WAKE_UP_EVENT_DTIM_BITMAP	= 0x02,	/* Wake on every DTIM*/
+	WAKE_UP_EVENT_N_DTIM_BITMAP	= 0x04, /* Wake on every Nth DTIM */
+	WAKE_UP_EVENT_N_BEACONS_BITMAP	= 0x08, /* Wake on every Nth Beacon */
+	WAKE_UP_EVENT_BITS_MASK		= 0x0F
+};
+
+struct acx_wake_up_condition {
+	struct acx_header header;
+
+	u8 wake_up_event; /* Only one bit can be set */
+	u8 listen_interval;
+	u8 pad[2];
+} __attribute__ ((packed));
+
+struct acx_aid {
+	struct acx_header header;
+
+	/*
+	 * To be set when associated with an AP.
+	 */
+	u16 aid;
+	u8 pad[2];
+} __attribute__ ((packed));
+
+enum acx_preamble_type {
+	ACX_PREAMBLE_LONG = 0,
+	ACX_PREAMBLE_SHORT = 1
+};
+
+struct acx_preamble {
+	struct acx_header header;
+
+	/*
+	 * When set, the WiLink transmits the frames with a short preamble and
+	 * when cleared, the WiLink transmits the frames with a long preamble.
+	 */
+	u8 preamble;
+	u8 padding[3];
+} __attribute__ ((packed));
+
+enum acx_ctsprotect_type {
+	CTSPROTECT_DISABLE = 0,
+	CTSPROTECT_ENABLE = 1
+};
+
+struct acx_ctsprotect {
+	struct acx_header header;
+	u8 ctsprotect;
+	u8 padding[3];
+} __attribute__ ((packed));
+
+struct acx_tx_statistics {
+	u32 internal_desc_overflow;
+}  __attribute__ ((packed));
+
+struct acx_rx_statistics {
+	u32 out_of_mem;
+	u32 hdr_overflow;
+	u32 hw_stuck;
+	u32 dropped;
+	u32 fcs_err;
+	u32 xfr_hint_trig;
+	u32 path_reset;
+	u32 reset_counter;
+} __attribute__ ((packed));
+
+struct acx_dma_statistics {
+	u32 rx_requested;
+	u32 rx_errors;
+	u32 tx_requested;
+	u32 tx_errors;
+}  __attribute__ ((packed));
+
+struct acx_isr_statistics {
+	/* host command complete */
+	u32 cmd_cmplt;
+
+	/* fiqisr() */
+	u32 fiqs;
+
+	/* (INT_STS_ND & INT_TRIG_RX_HEADER) */
+	u32 rx_headers;
+
+	/* (INT_STS_ND & INT_TRIG_RX_CMPLT) */
+	u32 rx_completes;
+
+	/* (INT_STS_ND & INT_TRIG_NO_RX_BUF) */
+	u32 rx_mem_overflow;
+
+	/* (INT_STS_ND & INT_TRIG_S_RX_RDY) */
+	u32 rx_rdys;
+
+	/* irqisr() */
+	u32 irqs;
+
+	/* (INT_STS_ND & INT_TRIG_TX_PROC) */
+	u32 tx_procs;
+
+	/* (INT_STS_ND & INT_TRIG_DECRYPT_DONE) */
+	u32 decrypt_done;
+
+	/* (INT_STS_ND & INT_TRIG_DMA0) */
+	u32 dma0_done;
+
+	/* (INT_STS_ND & INT_TRIG_DMA1) */
+	u32 dma1_done;
+
+	/* (INT_STS_ND & INT_TRIG_TX_EXC_CMPLT) */
+	u32 tx_exch_complete;
+
+	/* (INT_STS_ND & INT_TRIG_COMMAND) */
+	u32 commands;
+
+	/* (INT_STS_ND & INT_TRIG_RX_PROC) */
+	u32 rx_procs;
+
+	/* (INT_STS_ND & INT_TRIG_PM_802) */
+	u32 hw_pm_mode_changes;
+
+	/* (INT_STS_ND & INT_TRIG_ACKNOWLEDGE) */
+	u32 host_acknowledges;
+
+	/* (INT_STS_ND & INT_TRIG_PM_PCI) */
+	u32 pci_pm;
+
+	/* (INT_STS_ND & INT_TRIG_ACM_WAKEUP) */
+	u32 wakeups;
+
+	/* (INT_STS_ND & INT_TRIG_LOW_RSSI) */
+	u32 low_rssi;
+} __attribute__ ((packed));
+
+struct acx_wep_statistics {
+	/* WEP address keys configured */
+	u32 addr_key_count;
+
+	/* default keys configured */
+	u32 default_key_count;
+
+	u32 reserved;
+
+	/* number of times that WEP key not found on lookup */
+	u32 key_not_found;
+
+	/* number of times that WEP key decryption failed */
+	u32 decrypt_fail;
+
+	/* WEP packets decrypted */
+	u32 packets;
+
+	/* WEP decrypt interrupts */
+	u32 interrupt;
+} __attribute__ ((packed));
+
+#define ACX_MISSED_BEACONS_SPREAD 10
+
+struct acx_pwr_statistics {
+	/* the amount of enters into power save mode (both PD & ELP) */
+	u32 ps_enter;
+
+	/* the amount of enters into ELP mode */
+	u32 elp_enter;
+
+	/* the amount of missing beacon interrupts to the host */
+	u32 missing_bcns;
+
+	/* the amount of wake on host-access times */
+	u32 wake_on_host;
+
+	/* the amount of wake on timer-expire */
+	u32 wake_on_timer_exp;
+
+	/* the number of packets that were transmitted with PS bit set */
+	u32 tx_with_ps;
+
+	/* the number of packets that were transmitted with PS bit clear */
+	u32 tx_without_ps;
+
+	/* the number of received beacons */
+	u32 rcvd_beacons;
+
+	/* the number of entering into PowerOn (power save off) */
+	u32 power_save_off;
+
+	/* the number of entries into power save mode */
+	u16 enable_ps;
+
+	/*
+	 * the number of exits from power save, not including failed PS
+	 * transitions
+	 */
+	u16 disable_ps;
+
+	/*
+	 * the number of times the TSF counter was adjusted because
+	 * of drift
+	 */
+	u32 fix_tsf_ps;
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
+	u32 cont_miss_bcns_spread[ACX_MISSED_BEACONS_SPREAD];
+
+	/* the number of beacons in awake mode */
+	u32 rcvd_awake_beacons;
+} __attribute__ ((packed));
+
+struct acx_mic_statistics {
+	u32 rx_pkts;
+	u32 calc_failure;
+} __attribute__ ((packed));
+
+struct acx_aes_statistics {
+	u32 encrypt_fail;
+	u32 decrypt_fail;
+	u32 encrypt_packets;
+	u32 decrypt_packets;
+	u32 encrypt_interrupt;
+	u32 decrypt_interrupt;
+} __attribute__ ((packed));
+
+struct acx_event_statistics {
+	u32 heart_beat;
+	u32 calibration;
+	u32 rx_mismatch;
+	u32 rx_mem_empty;
+	u32 rx_pool;
+	u32 oom_late;
+	u32 phy_transmit_error;
+	u32 tx_stuck;
+} __attribute__ ((packed));
+
+struct acx_ps_statistics {
+	u32 pspoll_timeouts;
+	u32 upsd_timeouts;
+	u32 upsd_max_sptime;
+	u32 upsd_max_apturn;
+	u32 pspoll_max_apturn;
+	u32 pspoll_utilization;
+	u32 upsd_utilization;
+} __attribute__ ((packed));
+
+struct acx_rxpipe_statistics {
+	u32 rx_prep_beacon_drop;
+	u32 descr_host_int_trig_rx_data;
+	u32 beacon_buffer_thres_host_int_trig_rx_data;
+	u32 missed_beacon_host_int_trig_rx_data;
+	u32 tx_xfr_host_int_trig_rx_data;
+} __attribute__ ((packed));
+
+struct acx_statistics {
+	struct acx_header header;
+
+	struct acx_tx_statistics tx;
+	struct acx_rx_statistics rx;
+	struct acx_dma_statistics dma;
+	struct acx_isr_statistics isr;
+	struct acx_wep_statistics wep;
+	struct acx_pwr_statistics pwr;
+	struct acx_aes_statistics aes;
+	struct acx_mic_statistics mic;
+	struct acx_event_statistics event;
+	struct acx_ps_statistics ps;
+	struct acx_rxpipe_statistics rxpipe;
+} __attribute__ ((packed));
+
+#define ACX_MAX_RATE_CLASSES       8
+#define ACX_RATE_MASK_UNSPECIFIED  0
+#define ACX_RATE_MASK_ALL          0x1eff
+#define ACX_RATE_RETRY_LIMIT       10
+
+struct acx_rate_class {
+	u32 enabled_rates;
+	u8 short_retry_limit;
+	u8 long_retry_limit;
+	u8 aflags;
+	u8 reserved;
+};
+
+struct acx_rate_policy {
+	struct acx_header header;
+
+	u32 rate_class_cnt;
+	struct acx_rate_class rate_class[ACX_MAX_RATE_CLASSES];
+} __attribute__ ((packed));
+
+#define WL1271_ACX_AC_COUNT 4
+
+struct acx_ac_cfg {
+	struct acx_header header;
+	u8 ac;
+	u8 cw_min;
+	u16 cw_max;
+	u8 aifsn;
+	u8 reserved;
+	u16 tx_op_limit;
+} __attribute__ ((packed));
+
+enum wl1271_acx_ac {
+	WL1271_ACX_AC_BE = 0,
+	WL1271_ACX_AC_BK = 1,
+	WL1271_ACX_AC_VI = 2,
+	WL1271_ACX_AC_VO = 3,
+	WL1271_ACX_AC_CTS2SELF = 4,
+	WL1271_ACX_AC_ANY_TID = 0x1F,
+	WL1271_ACX_AC_INVALID = 0xFF,
+};
+
+enum wl1271_acx_ps_scheme {
+	WL1271_ACX_PS_SCHEME_LEGACY = 0,
+	WL1271_ACX_PS_SCHEME_UPSD_TRIGGER = 1,
+	WL1271_ACX_PS_SCHEME_LEGACY_PSPOLL = 2,
+	WL1271_ACX_PS_SCHEME_SAPSD = 3,
+};
+
+enum wl1271_acx_ack_policy {
+	WL1271_ACX_ACK_POLICY_LEGACY = 0,
+	WL1271_ACX_ACK_POLICY_NO_ACK = 1,
+	WL1271_ACX_ACK_POLICY_BLOCK = 2,
+};
+
+#define WL1271_ACX_TID_COUNT 7
+
+struct acx_tid_config {
+	struct acx_header header;
+	u8 queue_id;
+	u8 channel_type;
+	u8 tsid;
+	u8 ps_scheme;
+	u8 ack_policy;
+	u8 padding[3];
+	u32 apsd_conf[2];
+} __attribute__ ((packed));
+
+struct acx_frag_threshold {
+	struct acx_header header;
+	u16 frag_threshold;
+	u8 padding[2];
+} __attribute__ ((packed));
+
+#define WL1271_ACX_TX_COMPL_TIMEOUT   5
+#define WL1271_ACX_TX_COMPL_THRESHOLD 5
+
+struct acx_tx_config_options {
+	struct acx_header header;
+	u16 tx_compl_timeout;     /* msec */
+	u16 tx_compl_threshold;   /* number of packets */
+} __attribute__ ((packed));
+
+#define ACX_RX_MEM_BLOCKS     64
+#define ACX_TX_MIN_MEM_BLOCKS 64
+#define ACX_TX_DESCRIPTORS    32
+#define ACX_NUM_SSID_PROFILES 1
+
+struct wl1271_acx_config_memory {
+	struct acx_header header;
+
+	u8 rx_mem_block_num;
+	u8 tx_min_mem_block_num;
+	u8 num_stations;
+	u8 num_ssid_profiles;
+	u32 total_tx_descriptors;
+} __attribute__ ((packed));
+
+struct wl1271_acx_mem_map {
+	struct acx_header header;
+
+	void *code_start;
+	void *code_end;
+
+	void *wep_defkey_start;
+	void *wep_defkey_end;
+
+	void *sta_table_start;
+	void *sta_table_end;
+
+	void *packet_template_start;
+	void *packet_template_end;
+
+	/* Address of the TX result interface (control block) */
+	u32 tx_result;
+	u32 tx_result_queue_start;
+
+	void *queue_memory_start;
+	void *queue_memory_end;
+
+	u32 packet_memory_pool_start;
+	u32 packet_memory_pool_end;
+
+	void *debug_buffer1_start;
+	void *debug_buffer1_end;
+
+	void *debug_buffer2_start;
+	void *debug_buffer2_end;
+
+	/* Number of blocks FW allocated for TX packets */
+	u32 num_tx_mem_blocks;
+
+	/* Number of blocks FW allocated for RX packets */
+	u32 num_rx_mem_blocks;
+
+	/* the following 4 fields are valid in SLAVE mode only */
+	u8 *tx_cbuf;
+	u8 *rx_cbuf;
+	void *rx_ctrl;
+	void *tx_ctrl;
+} __attribute__ ((packed));
+
+enum wl1271_acx_rx_queue_type {
+	RX_QUEUE_TYPE_RX_LOW_PRIORITY,    /* All except the high priority */
+	RX_QUEUE_TYPE_RX_HIGH_PRIORITY,   /* Management and voice packets */
+	RX_QUEUE_TYPE_NUM,
+	RX_QUEUE_TYPE_MAX = USHORT_MAX
+};
+
+#define WL1271_RX_INTR_THRESHOLD_DEF  0       /* no pacing, send interrupt on
+					       * every event */
+#define WL1271_RX_INTR_THRESHOLD_MIN  0
+#define WL1271_RX_INTR_THRESHOLD_MAX  15
+
+#define WL1271_RX_INTR_TIMEOUT_DEF    5
+#define WL1271_RX_INTR_TIMEOUT_MIN    1
+#define WL1271_RX_INTR_TIMEOUT_MAX    100
+
+struct wl1271_acx_rx_config_opt {
+	struct acx_header header;
+
+	u16 mblk_threshold;
+	u16 threshold;
+	u16 timeout;
+	u8 queue_type;
+	u8 reserved;
+} __attribute__ ((packed));
+
+enum {
+	ACX_WAKE_UP_CONDITIONS      = 0x0002,
+	ACX_MEM_CFG                 = 0x0003,
+	ACX_SLOT                    = 0x0004,
+	ACX_AC_CFG                  = 0x0007,
+	ACX_MEM_MAP                 = 0x0008,
+	ACX_AID                     = 0x000A,
+	/* ACX_FW_REV is missing in the ref driver, but seems to work */
+	ACX_FW_REV                  = 0x000D,
+	ACX_MEDIUM_USAGE            = 0x000F,
+	ACX_RX_CFG                  = 0x0010,
+	ACX_TX_QUEUE_CFG            = 0x0011, /* FIXME: only used by wl1251 */
+	ACX_STATISTICS              = 0x0013, /* Debug API */
+	ACX_PWR_CONSUMPTION_STATISTICS = 0x0014,
+	ACX_FEATURE_CFG             = 0x0015,
+	ACX_TID_CFG                 = 0x001A,
+	ACX_PS_RX_STREAMING         = 0x001B,
+	ACX_BEACON_FILTER_OPT       = 0x001F,
+	ACX_NOISE_HIST              = 0x0021,
+	ACX_HDK_VERSION             = 0x0022, /* ??? */
+	ACX_PD_THRESHOLD            = 0x0023,
+	ACX_TX_CONFIG_OPT           = 0x0024,
+	ACX_CCA_THRESHOLD           = 0x0025,
+	ACX_EVENT_MBOX_MASK         = 0x0026,
+	ACX_CONN_MONIT_PARAMS       = 0x002D,
+	ACX_CONS_TX_FAILURE         = 0x002F,
+	ACX_BCN_DTIM_OPTIONS        = 0x0031,
+	ACX_SG_ENABLE               = 0x0032,
+	ACX_SG_CFG                  = 0x0033,
+	ACX_BEACON_FILTER_TABLE     = 0x0038,
+	ACX_ARP_IP_FILTER           = 0x0039,
+	ACX_ROAMING_STATISTICS_TBL  = 0x003B,
+	ACX_RATE_POLICY             = 0x003D,
+	ACX_CTS_PROTECTION          = 0x003E,
+	ACX_SLEEP_AUTH              = 0x003F,
+	ACX_PREAMBLE_TYPE	    = 0x0040,
+	ACX_ERROR_CNT               = 0x0041,
+	ACX_IBSS_FILTER		    = 0x0044,
+	ACX_SERVICE_PERIOD_TIMEOUT  = 0x0045,
+	ACX_TSF_INFO                = 0x0046,
+	ACX_CONFIG_PS_WMM           = 0x0049,
+	ACX_ENABLE_RX_DATA_FILTER   = 0x004A,
+	ACX_SET_RX_DATA_FILTER      = 0x004B,
+	ACX_GET_DATA_FILTER_STATISTICS = 0x004C,
+	ACX_RX_CONFIG_OPT           = 0x004E,
+	ACX_FRAG_CFG                = 0x004F,
+	ACX_BET_ENABLE              = 0x0050,
+	ACX_RSSI_SNR_TRIGGER        = 0x0051,
+	ACX_RSSI_SNR_WEIGHTS        = 0x0051,
+	ACX_KEEP_ALIVE_MODE         = 0x0052,
+	ACX_SET_KEEP_ALIVE_CONFIG   = 0x0054,
+	ACX_BA_SESSION_RESPONDER_POLICY = 0x0055,
+	ACX_BA_SESSION_INITIATOR_POLICY = 0x0056,
+	ACX_PEER_HT_CAP             = 0x0057,
+	ACX_HT_BSS_OPERATION        = 0x0058,
+	ACX_COEX_ACTIVITY           = 0x0059,
+	DOT11_RX_MSDU_LIFE_TIME     = 0x1004,
+	DOT11_CUR_TX_PWR            = 0x100D,
+	DOT11_RX_DOT11_MODE         = 0x1012,
+	DOT11_RTS_THRESHOLD         = 0x1013,
+	DOT11_GROUP_ADDRESS_TBL     = 0x1014,
+
+	MAX_DOT11_IE = DOT11_GROUP_ADDRESS_TBL,
+
+	MAX_IE = 0xFFFF
+};
+
+
+int wl1271_acx_wake_up_conditions(struct wl1271 *wl, u8 wake_up_event,
+				  u8 listen_interval);
+int wl1271_acx_sleep_auth(struct wl1271 *wl, u8 sleep_auth);
+int wl1271_acx_fw_version(struct wl1271 *wl, char *buf, size_t len);
+int wl1271_acx_tx_power(struct wl1271 *wl, int power);
+int wl1271_acx_feature_cfg(struct wl1271 *wl);
+int wl1271_acx_mem_map(struct wl1271 *wl,
+		       struct acx_header *mem_map, size_t len);
+int wl1271_acx_rx_msdu_life_time(struct wl1271 *wl, u32 life_time);
+int wl1271_acx_rx_config(struct wl1271 *wl, u32 config, u32 filter);
+int wl1271_acx_pd_threshold(struct wl1271 *wl);
+int wl1271_acx_slot(struct wl1271 *wl, enum acx_slot_type slot_time);
+int wl1271_acx_group_address_tbl(struct wl1271 *wl);
+int wl1271_acx_service_period_timeout(struct wl1271 *wl);
+int wl1271_acx_rts_threshold(struct wl1271 *wl, u16 rts_threshold);
+int wl1271_acx_beacon_filter_opt(struct wl1271 *wl);
+int wl1271_acx_beacon_filter_table(struct wl1271 *wl);
+int wl1271_acx_sg_enable(struct wl1271 *wl);
+int wl1271_acx_sg_cfg(struct wl1271 *wl);
+int wl1271_acx_cca_threshold(struct wl1271 *wl);
+int wl1271_acx_bcn_dtim_options(struct wl1271 *wl);
+int wl1271_acx_aid(struct wl1271 *wl, u16 aid);
+int wl1271_acx_event_mbox_mask(struct wl1271 *wl, u32 event_mask);
+int wl1271_acx_set_preamble(struct wl1271 *wl, enum acx_preamble_type preamble);
+int wl1271_acx_cts_protect(struct wl1271 *wl,
+			    enum acx_ctsprotect_type ctsprotect);
+int wl1271_acx_statistics(struct wl1271 *wl, struct acx_statistics *stats);
+int wl1271_acx_rate_policies(struct wl1271 *wl);
+int wl1271_acx_ac_cfg(struct wl1271 *wl);
+int wl1271_acx_tid_cfg(struct wl1271 *wl);
+int wl1271_acx_frag_threshold(struct wl1271 *wl);
+int wl1271_acx_tx_config_options(struct wl1271 *wl);
+int wl1271_acx_mem_cfg(struct wl1271 *wl);
+int wl1271_acx_init_mem_config(struct wl1271 *wl);
+int wl1271_acx_init_rx_interrupt(struct wl1271 *wl);
+
+#endif /* __WL1271_ACX_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
new file mode 100644
index 0000000..4c22f25
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -0,0 +1,540 @@
+/*
+ * This file is part of wl1271
+ *
+ * Copyright (C) 2008-2009 Nokia Corporation
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
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
+#include <linux/gpio.h>
+
+#include "wl1271_acx.h"
+#include "wl1271_reg.h"
+#include "wl1271_boot.h"
+#include "wl1271_spi.h"
+#include "wl1271_event.h"
+
+static struct wl1271_partition_set part_table[PART_TABLE_LEN] = {
+	[PART_DOWN] = {
+		.mem = {
+			.start = 0x00000000,
+			.size  = 0x000177c0
+		},
+		.reg = {
+			.start = REGISTERS_BASE,
+			.size  = 0x00008800
+		},
+	},
+
+	[PART_WORK] = {
+		.mem = {
+			.start = 0x00040000,
+			.size  = 0x00014fc0
+		},
+		.reg = {
+			.start = REGISTERS_BASE,
+			.size  = 0x0000b000
+		},
+	},
+
+	[PART_DRPW] = {
+		.mem = {
+			.start = 0x00040000,
+			.size  = 0x00014fc0
+		},
+		.reg = {
+			.start = DRPW_BASE,
+			.size  = 0x00006000
+		}
+	}
+};
+
+static void wl1271_boot_set_ecpu_ctrl(struct wl1271 *wl, u32 flag)
+{
+	u32 cpu_ctrl;
+
+	/* 10.5.0 run the firmware (I) */
+	cpu_ctrl = wl1271_reg_read32(wl, ACX_REG_ECPU_CONTROL);
+
+	/* 10.5.1 run the firmware (II) */
+	cpu_ctrl |= flag;
+	wl1271_reg_write32(wl, ACX_REG_ECPU_CONTROL, cpu_ctrl);
+}
+
+static void wl1271_boot_fw_version(struct wl1271 *wl)
+{
+	struct wl1271_static_data static_data;
+
+	wl1271_spi_mem_read(wl, wl->cmd_box_addr,
+			    &static_data, sizeof(static_data));
+
+	strncpy(wl->chip.fw_ver, static_data.fw_version,
+		sizeof(wl->chip.fw_ver));
+
+	/* make sure the string is NULL-terminated */
+	wl->chip.fw_ver[sizeof(wl->chip.fw_ver) - 1] = '\0';
+}
+
+static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
+					     size_t fw_data_len, u32 dest)
+{
+	int addr, chunk_num, partition_limit;
+	u8 *p;
+
+	/* whal_FwCtrl_LoadFwImageSm() */
+
+	wl1271_debug(DEBUG_BOOT, "starting firmware upload");
+
+	wl1271_debug(DEBUG_BOOT, "fw_data_len %d chunk_size %d", fw_data_len,
+		CHUNK_SIZE);
+
+
+	if ((fw_data_len % 4) != 0) {
+		wl1271_error("firmware length not multiple of four");
+		return -EIO;
+	}
+
+	wl1271_set_partition(wl, dest,
+			     part_table[PART_DOWN].mem.size,
+			     part_table[PART_DOWN].reg.start,
+			     part_table[PART_DOWN].reg.size);
+
+	/* 10.1 set partition limit and chunk num */
+	chunk_num = 0;
+	partition_limit = part_table[PART_DOWN].mem.size;
+
+	while (chunk_num < fw_data_len / CHUNK_SIZE) {
+		/* 10.2 update partition, if needed */
+		addr = dest + (chunk_num + 2) * CHUNK_SIZE;
+		if (addr > partition_limit) {
+			addr = dest + chunk_num * CHUNK_SIZE;
+			partition_limit = chunk_num * CHUNK_SIZE +
+				part_table[PART_DOWN].mem.size;
+
+			/* FIXME: Over 80 chars! */
+			wl1271_set_partition(wl,
+					     addr,
+					     part_table[PART_DOWN].mem.size,
+					     part_table[PART_DOWN].reg.start,
+					     part_table[PART_DOWN].reg.size);
+		}
+
+		/* 10.3 upload the chunk */
+		addr = dest + chunk_num * CHUNK_SIZE;
+		p = buf + chunk_num * CHUNK_SIZE;
+		wl1271_debug(DEBUG_BOOT, "uploading fw chunk 0x%p to 0x%x",
+			     p, addr);
+		wl1271_spi_mem_write(wl, addr, p, CHUNK_SIZE);
+
+		chunk_num++;
+	}
+
+	/* 10.4 upload the last chunk */
+	addr = dest + chunk_num * CHUNK_SIZE;
+	p = buf + chunk_num * CHUNK_SIZE;
+	wl1271_debug(DEBUG_BOOT, "uploading fw last chunk (%d B) 0x%p to 0x%x",
+		     fw_data_len % CHUNK_SIZE, p, addr);
+	wl1271_spi_mem_write(wl, addr, p, fw_data_len % CHUNK_SIZE);
+
+	return 0;
+}
+
+static int wl1271_boot_upload_firmware(struct wl1271 *wl)
+{
+	u32 chunks, addr, len;
+	u8 *fw;
+
+	fw = wl->fw;
+	chunks = be32_to_cpup((u32 *) fw);
+	fw += sizeof(u32);
+
+	wl1271_debug(DEBUG_BOOT, "firmware chunks to be uploaded: %u", chunks);
+
+	while (chunks--) {
+		addr = be32_to_cpup((u32 *) fw);
+		fw += sizeof(u32);
+		len = be32_to_cpup((u32 *) fw);
+		fw += sizeof(u32);
+
+		if (len > 300000) {
+			wl1271_info("firmware chunk too long: %u", len);
+			return -EINVAL;
+		}
+		wl1271_debug(DEBUG_BOOT, "chunk %d addr 0x%x len %u",
+			     chunks, addr, len);
+		wl1271_boot_upload_firmware_chunk(wl, fw, len, addr);
+		fw += len;
+	}
+
+	return 0;
+}
+
+static int wl1271_boot_upload_nvs(struct wl1271 *wl)
+{
+	size_t nvs_len, burst_len;
+	int i;
+	u32 dest_addr, val;
+	u8 *nvs_ptr, *nvs, *nvs_aligned;
+
+	nvs = wl->nvs;
+	if (nvs == NULL)
+		return -ENODEV;
+
+	nvs_ptr = nvs;
+
+	nvs_len = wl->nvs_len;
+
+	/* Update the device MAC address into the nvs */
+	nvs[11] = wl->mac_addr[0];
+	nvs[10] = wl->mac_addr[1];
+	nvs[6] = wl->mac_addr[2];
+	nvs[5] = wl->mac_addr[3];
+	nvs[4] = wl->mac_addr[4];
+	nvs[3] = wl->mac_addr[5];
+
+	/*
+	 * Layout before the actual NVS tables:
+	 * 1 byte : burst length.
+	 * 2 bytes: destination address.
+	 * n bytes: data to burst copy.
+	 *
+	 * This is ended by a 0 length, then the NVS tables.
+	 */
+
+	/* FIXME: Do we need to check here whether the LSB is 1? */
+	while (nvs_ptr[0]) {
+		burst_len = nvs_ptr[0];
+		dest_addr = (nvs_ptr[1] & 0xfe) | ((u32)(nvs_ptr[2] << 8));
+
+		/* FIXME: Due to our new wl1271_translate_reg_addr function,
+		   we need to add the REGISTER_BASE to the destination */
+		dest_addr += REGISTERS_BASE;
+
+		/* We move our pointer to the data */
+		nvs_ptr += 3;
+
+		for (i = 0; i < burst_len; i++) {
+			val = (nvs_ptr[0] | (nvs_ptr[1] << 8)
+			       | (nvs_ptr[2] << 16) | (nvs_ptr[3] << 24));
+
+			wl1271_debug(DEBUG_BOOT,
+				     "nvs burst write 0x%x: 0x%x",
+				     dest_addr, val);
+			wl1271_reg_write32(wl, dest_addr, val);
+
+			nvs_ptr += 4;
+			dest_addr += 4;
+		}
+	}
+
+	/*
+	 * We've reached the first zero length, the first NVS table
+	 * is 7 bytes further.
+	 */
+	nvs_ptr += 7;
+	nvs_len -= nvs_ptr - nvs;
+	nvs_len = ALIGN(nvs_len, 4);
+
+	/* FIXME: The driver sets the partition here, but this is not needed,
+	   since it sets to the same one as currently in use */
+	/* Now we must set the partition correctly */
+	wl1271_set_partition(wl,
+			     part_table[PART_WORK].mem.start,
+			     part_table[PART_WORK].mem.size,
+			     part_table[PART_WORK].reg.start,
+			     part_table[PART_WORK].reg.size);
+
+	/* Copy the NVS tables to a new block to ensure alignment */
+	nvs_aligned = kmemdup(nvs_ptr, nvs_len, GFP_KERNEL);
+
+	/* And finally we upload the NVS tables */
+	/* FIXME: In wl1271, we upload everything at once.
+	   No endianness handling needed here?! The ref driver doesn't do
+	   anything about it at this point */
+	wl1271_spi_mem_write(wl, CMD_MBOX_ADDRESS, nvs_aligned, nvs_len);
+
+	kfree(nvs_aligned);
+	return 0;
+}
+
+static void wl1271_boot_enable_interrupts(struct wl1271 *wl)
+{
+	enable_irq(wl->irq);
+	wl1271_reg_write32(wl, ACX_REG_INTERRUPT_MASK, ~(WL1271_INTR_MASK));
+	wl1271_reg_write32(wl, HI_CFG, HI_CFG_DEF_VAL);
+}
+
+static int wl1271_boot_soft_reset(struct wl1271 *wl)
+{
+	unsigned long timeout;
+	u32 boot_data;
+
+	/* perform soft reset */
+	wl1271_reg_write32(wl, ACX_REG_SLV_SOFT_RESET, ACX_SLV_SOFT_RESET_BIT);
+
+	/* SOFT_RESET is self clearing */
+	timeout = jiffies + usecs_to_jiffies(SOFT_RESET_MAX_TIME);
+	while (1) {
+		boot_data = wl1271_reg_read32(wl, ACX_REG_SLV_SOFT_RESET);
+		wl1271_debug(DEBUG_BOOT, "soft reset bootdata 0x%x", boot_data);
+		if ((boot_data & ACX_SLV_SOFT_RESET_BIT) == 0)
+			break;
+
+		if (time_after(jiffies, timeout)) {
+			/* 1.2 check pWhalBus->uSelfClearTime if the
+			 * timeout was reached */
+			wl1271_error("soft reset timeout");
+			return -1;
+		}
+
+		udelay(SOFT_RESET_STALL_TIME);
+	}
+
+	/* disable Rx/Tx */
+	wl1271_reg_write32(wl, ENABLE, 0x0);
+
+	/* disable auto calibration on start*/
+	wl1271_reg_write32(wl, SPARE_A2, 0xffff);
+
+	return 0;
+}
+
+static int wl1271_boot_run_firmware(struct wl1271 *wl)
+{
+	int loop, ret;
+	u32 chip_id, interrupt;
+
+	wl1271_boot_set_ecpu_ctrl(wl, ECPU_CONTROL_HALT);
+
+	chip_id = wl1271_reg_read32(wl, CHIP_ID_B);
+
+	wl1271_debug(DEBUG_BOOT, "chip id after firmware boot: 0x%x", chip_id);
+
+	if (chip_id != wl->chip.id) {
+		wl1271_error("chip id doesn't match after firmware boot");
+		return -EIO;
+	}
+
+	/* wait for init to complete */
+	loop = 0;
+	while (loop++ < INIT_LOOP) {
+		udelay(INIT_LOOP_DELAY);
+		interrupt = wl1271_reg_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
+
+		if (interrupt == 0xffffffff) {
+			wl1271_error("error reading hardware complete "
+				     "init indication");
+			return -EIO;
+		}
+		/* check that ACX_INTR_INIT_COMPLETE is enabled */
+		else if (interrupt & WL1271_ACX_INTR_INIT_COMPLETE) {
+			wl1271_reg_write32(wl, ACX_REG_INTERRUPT_ACK,
+					   WL1271_ACX_INTR_INIT_COMPLETE);
+			break;
+		}
+	}
+
+	if (loop >= INIT_LOOP) {
+		wl1271_error("timeout waiting for the hardware to "
+			     "complete initialization");
+		return -EIO;
+	}
+
+	/* get hardware config command mail box */
+	wl->cmd_box_addr = wl1271_reg_read32(wl, REG_COMMAND_MAILBOX_PTR);
+
+	/* get hardware config event mail box */
+	wl->event_box_addr = wl1271_reg_read32(wl, REG_EVENT_MAILBOX_PTR);
+
+	/* set the working partition to its "running" mode offset */
+	wl1271_set_partition(wl,
+			     part_table[PART_WORK].mem.start,
+			     part_table[PART_WORK].mem.size,
+			     part_table[PART_WORK].reg.start,
+			     part_table[PART_WORK].reg.size);
+
+	wl1271_debug(DEBUG_MAILBOX, "cmd_box_addr 0x%x event_box_addr 0x%x",
+		     wl->cmd_box_addr, wl->event_box_addr);
+
+	wl1271_boot_fw_version(wl);
+
+	/*
+	 * in case of full asynchronous mode the firmware event must be
+	 * ready to receive event from the command mailbox
+	 */
+
+	/* enable gpio interrupts */
+	wl1271_boot_enable_interrupts(wl);
+
+	/* unmask all mbox events  */
+	wl->event_mask = 0xffffffff;
+
+	ret = wl1271_event_unmask(wl);
+	if (ret < 0) {
+		wl1271_error("EVENT mask setting failed");
+		return ret;
+	}
+
+	wl1271_event_mbox_config(wl);
+
+	/* firmware startup completed */
+	return 0;
+}
+
+static int wl1271_boot_write_irq_polarity(struct wl1271 *wl)
+{
+	u32 polarity, status, i;
+
+	wl1271_reg_write32(wl, OCP_POR_CTR, OCP_REG_POLARITY);
+	wl1271_reg_write32(wl, OCP_CMD, OCP_CMD_READ);
+
+	/* Wait until the command is complete (ie. bit 18 is set) */
+	for (i = 0; i < OCP_CMD_LOOP; i++) {
+		polarity = wl1271_reg_read32(wl, OCP_DATA_READ);
+		if (polarity & OCP_READY_MASK)
+			break;
+	}
+	if (i == OCP_CMD_LOOP) {
+		wl1271_error("OCP command timeout!");
+		return -EIO;
+	}
+
+	status = polarity & OCP_STATUS_MASK;
+	if (status != OCP_STATUS_OK) {
+		wl1271_error("OCP command failed (%d)", status);
+		return -EIO;
+	}
+
+	/* We use HIGH polarity, so unset the LOW bit */
+	polarity &= ~POLARITY_LOW;
+
+	wl1271_reg_write32(wl, OCP_POR_CTR, OCP_REG_POLARITY);
+	wl1271_reg_write32(wl, OCP_DATA_WRITE, polarity);
+	wl1271_reg_write32(wl, OCP_CMD, OCP_CMD_WRITE);
+
+	return 0;
+}
+
+int wl1271_boot(struct wl1271 *wl)
+{
+	int ret = 0;
+	u32 tmp, clk, pause;
+
+	if (REF_CLOCK == 0 || REF_CLOCK == 2)
+		/* ref clk: 19.2/38.4 */
+		clk = 0x3;
+	else if (REF_CLOCK == 1 || REF_CLOCK == 3)
+		/* ref clk: 26/52 */
+		clk = 0x5;
+
+	wl1271_reg_write32(wl, PLL_PARAMETERS, clk);
+
+	pause = wl1271_reg_read32(wl, PLL_PARAMETERS);
+
+	wl1271_debug(DEBUG_BOOT, "pause1 0x%x", pause);
+
+	pause &= ~(WU_COUNTER_PAUSE_VAL); /* FIXME: This should probably be
+					   * WU_COUNTER_PAUSE_VAL instead of
+					   * 0x3ff (magic number ).  How does
+					   * this work?! */
+	pause |= WU_COUNTER_PAUSE_VAL;
+	wl1271_reg_write32(wl, WU_COUNTER_PAUSE, pause);
+
+	/* Continue the ELP wake up sequence */
+	wl1271_reg_write32(wl, WELP_ARM_COMMAND, WELP_ARM_COMMAND_VAL);
+	udelay(500);
+
+	wl1271_set_partition(wl,
+			     part_table[PART_DRPW].mem.start,
+			     part_table[PART_DRPW].mem.size,
+			     part_table[PART_DRPW].reg.start,
+			     part_table[PART_DRPW].reg.size);
+
+	/* Read-modify-write DRPW_SCRATCH_START register (see next state)
+	   to be used by DRPw FW. The RTRIM value will be added by the FW
+	   before taking DRPw out of reset */
+
+	wl1271_debug(DEBUG_BOOT, "DRPW_SCRATCH_START %08x", DRPW_SCRATCH_START);
+	clk = wl1271_reg_read32(wl, DRPW_SCRATCH_START);
+
+	wl1271_debug(DEBUG_BOOT, "clk2 0x%x", clk);
+
+	/* 2 */
+	clk |= (REF_CLOCK << 1) << 4;
+	wl1271_reg_write32(wl, DRPW_SCRATCH_START, clk);
+
+	wl1271_set_partition(wl,
+			     part_table[PART_WORK].mem.start,
+			     part_table[PART_WORK].mem.size,
+			     part_table[PART_WORK].reg.start,
+			     part_table[PART_WORK].reg.size);
+
+	/* Disable interrupts */
+	wl1271_reg_write32(wl, ACX_REG_INTERRUPT_MASK, WL1271_ACX_INTR_ALL);
+
+	ret = wl1271_boot_soft_reset(wl);
+	if (ret < 0)
+		goto out;
+
+	/* 2. start processing NVS file */
+	ret = wl1271_boot_upload_nvs(wl);
+	if (ret < 0)
+		goto out;
+
+	/* write firmware's last address (ie. it's length) to
+	 * ACX_EEPROMLESS_IND_REG */
+	wl1271_debug(DEBUG_BOOT, "ACX_EEPROMLESS_IND_REG");
+
+	wl1271_reg_write32(wl, ACX_EEPROMLESS_IND_REG, ACX_EEPROMLESS_IND_REG);
+
+	tmp = wl1271_reg_read32(wl, CHIP_ID_B);
+
+	wl1271_debug(DEBUG_BOOT, "chip id 0x%x", tmp);
+
+	/* 6. read the EEPROM parameters */
+	tmp = wl1271_reg_read32(wl, SCR_PAD2);
+
+	ret = wl1271_boot_write_irq_polarity(wl);
+	if (ret < 0)
+		goto out;
+
+	/* FIXME: Need to check whether this is really what we want */
+	wl1271_reg_write32(wl, ACX_REG_INTERRUPT_MASK,
+			   WL1271_ACX_ALL_EVENTS_VECTOR);
+
+	/* WL1271: The reference driver skips steps 7 to 10 (jumps directly
+	 * to upload_fw) */
+
+	ret = wl1271_boot_upload_firmware(wl);
+	if (ret < 0)
+		goto out;
+
+	/* 10.5 start firmware */
+	ret = wl1271_boot_run_firmware(wl);
+	if (ret < 0)
+		goto out;
+
+	/* set the wl1271 default filters */
+	wl->rx_config = WL1271_DEFAULT_RX_CONFIG;
+	wl->rx_filter = WL1271_DEFAULT_RX_FILTER;
+
+	wl1271_event_mbox_config(wl);
+
+out:
+	return ret;
+}
diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.h b/drivers/net/wireless/wl12xx/wl1271_boot.h
new file mode 100644
index 0000000..b0d8fb4
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.h
@@ -0,0 +1,72 @@
+/*
+ * This file is part of wl1271
+ *
+ * Copyright (C) 2008-2009 Nokia Corporation
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
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
+#ifndef __BOOT_H__
+#define __BOOT_H__
+
+#include "wl1271.h"
+
+int wl1271_boot(struct wl1271 *wl);
+
+#define WL1271_NO_SUBBANDS 8
+#define WL1271_NO_POWER_LEVELS 4
+#define WL1271_FW_VERSION_MAX_LEN 20
+
+struct wl1271_static_data {
+	u8 mac_address[ETH_ALEN];
+	u8 padding[2];
+	u8 fw_version[WL1271_FW_VERSION_MAX_LEN];
+	u32 hw_version;
+	u8 tx_power_table[WL1271_NO_SUBBANDS][WL1271_NO_POWER_LEVELS];
+};
+
+/* number of times we try to read the INIT interrupt */
+#define INIT_LOOP 20000
+
+/* delay between retries */
+#define INIT_LOOP_DELAY 50
+
+#define REF_CLOCK            2
+#define WU_COUNTER_PAUSE_VAL 0x3FF
+#define WELP_ARM_COMMAND_VAL 0x4
+
+#define OCP_CMD_LOOP  32
+
+#define OCP_CMD_WRITE 0x1
+#define OCP_CMD_READ  0x2
+
+#define OCP_READY_MASK  BIT(18)
+#define OCP_STATUS_MASK (BIT(16) | BIT(17))
+
+#define OCP_STATUS_NO_RESP    0x00000
+#define OCP_STATUS_OK         0x10000
+#define OCP_STATUS_REQ_FAILED 0x20000
+#define OCP_STATUS_RESP_ERROR 0x30000
+
+#define OCP_REG_POLARITY 0x30032
+
+#define CMD_MBOX_ADDRESS 0x407B4
+
+#define POLARITY_LOW BIT(1)
+
+#endif
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
new file mode 100644
index 0000000..2a4351f
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -0,0 +1,813 @@
+/*
+ * This file is part of wl1271
+ *
+ * Copyright (C) 2009 Nokia Corporation
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
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
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/crc7.h>
+#include <linux/spi/spi.h>
+#include <linux/etherdevice.h>
+
+#include "wl1271.h"
+#include "wl1271_reg.h"
+#include "wl1271_spi.h"
+#include "wl1271_acx.h"
+#include "wl12xx_80211.h"
+#include "wl1271_cmd.h"
+
+/*
+ * send command to firmware
+ *
+ * @wl: wl struct
+ * @id: command id
+ * @buf: buffer containing the command, must work with dma
+ * @len: length of the buffer
+ */
+int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len)
+{
+	struct wl1271_cmd_header *cmd;
+	unsigned long timeout;
+	u32 intr;
+	int ret = 0;
+
+	cmd = buf;
+	cmd->id = id;
+	cmd->status = 0;
+
+	WARN_ON(len % 4 != 0);
+
+	wl1271_spi_mem_write(wl, wl->cmd_box_addr, buf, len);
+
+	wl1271_reg_write32(wl, ACX_REG_INTERRUPT_TRIG, INTR_TRIG_CMD);
+
+	timeout = jiffies + msecs_to_jiffies(WL1271_COMMAND_TIMEOUT);
+
+	intr = wl1271_reg_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
+	while (!(intr & WL1271_ACX_INTR_CMD_COMPLETE)) {
+		if (time_after(jiffies, timeout)) {
+			wl1271_error("command complete timeout");
+			ret = -ETIMEDOUT;
+			goto out;
+		}
+
+		msleep(1);
+
+		intr = wl1271_reg_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
+	}
+
+	wl1271_reg_write32(wl, ACX_REG_INTERRUPT_ACK,
+			   WL1271_ACX_INTR_CMD_COMPLETE);
+
+out:
+	return ret;
+}
+
+int wl1271_cmd_cal_channel_tune(struct wl1271 *wl)
+{
+	struct wl1271_cmd_cal_channel_tune *cmd;
+	int ret = 0;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	cmd->test.id = TEST_CMD_CHANNEL_TUNE;
+
+	cmd->band = WL1271_CHANNEL_TUNE_BAND_2_4;
+	/* set up any channel, 7 is in the middle of the range */
+	cmd->channel = 7;
+
+	ret = wl1271_cmd_test(wl, cmd, sizeof(*cmd), 0);
+	if (ret < 0)
+		wl1271_warning("TEST_CMD_CHANNEL_TUNE failed");
+
+	kfree(cmd);
+	return ret;
+}
+
+int wl1271_cmd_cal_update_ref_point(struct wl1271 *wl)
+{
+	struct wl1271_cmd_cal_update_ref_point *cmd;
+	int ret = 0;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	cmd->test.id = TEST_CMD_UPDATE_PD_REFERENCE_POINT;
+
+	/* FIXME: still waiting for the correct values */
+	cmd->ref_power    = 0;
+	cmd->ref_detector = 0;
+
+	cmd->sub_band     = WL1271_PD_REFERENCE_POINT_BAND_B_G;
+
+	ret = wl1271_cmd_test(wl, cmd, sizeof(*cmd), 0);
+	if (ret < 0)
+		wl1271_warning("TEST_CMD_UPDATE_PD_REFERENCE_POINT failed");
+
+	kfree(cmd);
+	return ret;
+}
+
+int wl1271_cmd_cal_p2g(struct wl1271 *wl)
+{
+	struct wl1271_cmd_cal_p2g *cmd;
+	int ret = 0;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	cmd->test.id = TEST_CMD_P2G_CAL;
+
+	cmd->sub_band_mask = WL1271_CAL_P2G_BAND_B_G;
+
+	ret = wl1271_cmd_test(wl, cmd, sizeof(*cmd), 0);
+	if (ret < 0)
+		wl1271_warning("TEST_CMD_P2G_CAL failed");
+
+	kfree(cmd);
+	return ret;
+}
+
+int wl1271_cmd_cal(struct wl1271 *wl)
+{
+	/*
+	 * FIXME: we must make sure that we're not sleeping when calibration
+	 * is done
+	 */
+	int ret;
+
+	wl1271_notice("performing tx calibration");
+
+	ret = wl1271_cmd_cal_channel_tune(wl);
+	if (ret < 0)
+		return ret;
+
+	ret = wl1271_cmd_cal_update_ref_point(wl);
+	if (ret < 0)
+		return ret;
+
+	ret = wl1271_cmd_cal_p2g(wl);
+	if (ret < 0)
+		return ret;
+
+	return ret;
+}
+
+int wl1271_cmd_join(struct wl1271 *wl, u8 bss_type, u8 dtim_interval,
+		    u16 beacon_interval, u8 wait)
+{
+	static bool do_cal = true;
+	unsigned long timeout;
+	struct wl1271_cmd_join *join;
+	int ret, i;
+	u8 *bssid;
+
+	/* FIXME: remove when we get calibration from the factory */
+	if (do_cal) {
+		ret = wl1271_cmd_cal(wl);
+		if (ret < 0)
+			wl1271_warning("couldn't calibrate");
+		else
+			do_cal = false;
+	}
+
+
+	join = kzalloc(sizeof(*join), GFP_KERNEL);
+	if (!join) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	wl1271_debug(DEBUG_CMD, "cmd join");
+
+	/* Reverse order BSSID */
+	bssid = (u8 *) &join->bssid_lsb;
+	for (i = 0; i < ETH_ALEN; i++)
+		bssid[i] = wl->bssid[ETH_ALEN - i - 1];
+
+	join->rx_config_options = wl->rx_config;
+	join->rx_filter_options = wl->rx_filter;
+
+	join->basic_rate_set = RATE_MASK_1MBPS | RATE_MASK_2MBPS |
+		RATE_MASK_5_5MBPS | RATE_MASK_11MBPS;
+
+	join->beacon_interval = beacon_interval;
+	join->dtim_interval = dtim_interval;
+	join->bss_type = bss_type;
+	join->channel = wl->channel;
+	join->ssid_len = wl->ssid_len;
+	memcpy(join->ssid, wl->ssid, wl->ssid_len);
+	join->ctrl = WL1271_JOIN_CMD_CTRL_TX_FLUSH;
+
+	/* increment the session counter */
+	wl->session_counter++;
+	if (wl->session_counter >= SESSION_COUNTER_MAX)
+		wl->session_counter = 0;
+
+	join->ctrl |= wl->session_counter << WL1271_JOIN_CMD_TX_SESSION_OFFSET;
+
+
+	ret = wl1271_cmd_send(wl, CMD_START_JOIN, join, sizeof(*join));
+	if (ret < 0) {
+		wl1271_error("failed to initiate cmd join");
+		goto out_free;
+	}
+
+	timeout = msecs_to_jiffies(JOIN_TIMEOUT);
+
+	/*
+	 * ugly hack: we should wait for JOIN_EVENT_COMPLETE_ID but to
+	 * simplify locking we just sleep instead, for now
+	 */
+	if (wait)
+		msleep(10);
+
+out_free:
+	kfree(join);
+
+out:
+	return ret;
+}
+
+/**
+ * send test command to firmware
+ *
+ * @wl: wl struct
+ * @buf: buffer containing the command, with all headers, must work with dma
+ * @len: length of the buffer
+ * @answer: is answer needed
+ */
+int wl1271_cmd_test(struct wl1271 *wl, void *buf, size_t buf_len, u8 answer)
+{
+	int ret;
+
+	wl1271_debug(DEBUG_CMD, "cmd test");
+
+	ret = wl1271_cmd_send(wl, CMD_TEST, buf, buf_len);
+
+	if (ret < 0) {
+		wl1271_warning("TEST command failed");
+		return ret;
+	}
+
+	if (answer) {
+		struct wl1271_command *cmd_answer;
+
+		/*
+		 * The test command got in, we can read the answer.
+		 * The answer would be a wl1271_command, where the
+		 * parameter array contains the actual answer.
+		 */
+		wl1271_spi_mem_read(wl, wl->cmd_box_addr, buf, buf_len);
+
+		cmd_answer = buf;
+
+		if (cmd_answer->header.status != CMD_STATUS_SUCCESS)
+			wl1271_error("TEST command answer error: %d",
+				     cmd_answer->header.status);
+	}
+
+	return 0;
+}
+
+/**
+ * read acx from firmware
+ *
+ * @wl: wl struct
+ * @id: acx id
+ * @buf: buffer for the response, including all headers, must work with dma
+ * @len: lenght of buf
+ */
+int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf, size_t len)
+{
+	struct acx_header *acx = buf;
+	int ret;
+
+	wl1271_debug(DEBUG_CMD, "cmd interrogate");
+
+	acx->id = id;
+
+	/* payload length, does not include any headers */
+	acx->len = len - sizeof(*acx);
+
+	ret = wl1271_cmd_send(wl, CMD_INTERROGATE, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_error("INTERROGATE command failed");
+		goto out;
+	}
+
+	/* the interrogate command got in, we can read the answer */
+	wl1271_spi_mem_read(wl, wl->cmd_box_addr, buf, len);
+
+	acx = buf;
+	if (acx->cmd.status != CMD_STATUS_SUCCESS)
+		wl1271_error("INTERROGATE command error: %d",
+			     acx->cmd.status);
+
+out:
+	return ret;
+}
+
+/**
+ * write acx value to firmware
+ *
+ * @wl: wl struct
+ * @id: acx id
+ * @buf: buffer containing acx, including all headers, must work with dma
+ * @len: length of buf
+ */
+int wl1271_cmd_configure(struct wl1271 *wl, u16 id, void *buf, size_t len)
+{
+	struct acx_header *acx = buf;
+	int ret;
+
+	wl1271_debug(DEBUG_CMD, "cmd configure");
+
+	acx->id = id;
+
+	/* payload length, does not include any headers */
+	acx->len = len - sizeof(*acx);
+
+	ret = wl1271_cmd_send(wl, CMD_CONFIGURE, acx, len);
+	if (ret < 0) {
+		wl1271_warning("CONFIGURE command NOK");
+		return ret;
+	}
+
+	return 0;
+}
+
+int wl1271_cmd_data_path(struct wl1271 *wl, u8 channel, bool enable)
+{
+	struct cmd_enabledisable_path *cmd;
+	int ret;
+	u16 cmd_rx, cmd_tx;
+
+	wl1271_debug(DEBUG_CMD, "cmd data path");
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	cmd->channel = channel;
+
+	if (enable) {
+		cmd_rx = CMD_ENABLE_RX;
+		cmd_tx = CMD_ENABLE_TX;
+	} else {
+		cmd_rx = CMD_DISABLE_RX;
+		cmd_tx = CMD_DISABLE_TX;
+	}
+
+	ret = wl1271_cmd_send(wl, cmd_rx, cmd, sizeof(*cmd));
+	if (ret < 0) {
+		wl1271_error("rx %s cmd for channel %d failed",
+			     enable ? "start" : "stop", channel);
+		goto out;
+	}
+
+	wl1271_debug(DEBUG_BOOT, "rx %s cmd channel %d",
+		     enable ? "start" : "stop", channel);
+
+	ret = wl1271_cmd_send(wl, cmd_tx, cmd, sizeof(*cmd));
+	if (ret < 0) {
+		wl1271_error("tx %s cmd for channel %d failed",
+			     enable ? "start" : "stop", channel);
+		return ret;
+	}
+
+	wl1271_debug(DEBUG_BOOT, "tx %s cmd channel %d",
+		     enable ? "start" : "stop", channel);
+
+out:
+	kfree(cmd);
+	return ret;
+}
+
+int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode)
+{
+	struct wl1271_cmd_ps_params *ps_params = NULL;
+	int ret = 0;
+
+	/* FIXME: this should be in ps.c */
+	ret = wl1271_acx_wake_up_conditions(wl, WAKE_UP_EVENT_DTIM_BITMAP,
+					    wl->listen_int);
+	if (ret < 0) {
+		wl1271_error("couldn't set wake up conditions");
+		goto out;
+	}
+
+	wl1271_debug(DEBUG_CMD, "cmd set ps mode");
+
+	ps_params = kzalloc(sizeof(*ps_params), GFP_KERNEL);
+	if (!ps_params) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ps_params->ps_mode = ps_mode;
+	ps_params->send_null_data = 1;
+	ps_params->retries = 5;
+	ps_params->hang_over_period = 128;
+	ps_params->null_data_rate = 1; /* 1 Mbps */
+
+	ret = wl1271_cmd_send(wl, CMD_SET_PS_MODE, ps_params,
+			      sizeof(*ps_params));
+	if (ret < 0) {
+		wl1271_error("cmd set_ps_mode failed");
+		goto out;
+	}
+
+out:
+	kfree(ps_params);
+	return ret;
+}
+
+int wl1271_cmd_read_memory(struct wl1271 *wl, u32 addr, void *answer,
+			   size_t len)
+{
+	struct cmd_read_write_memory *cmd;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_CMD, "cmd read memory");
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	WARN_ON(len > MAX_READ_SIZE);
+	len = min_t(size_t, len, MAX_READ_SIZE);
+
+	cmd->addr = addr;
+	cmd->size = len;
+
+	ret = wl1271_cmd_send(wl, CMD_READ_MEMORY, cmd, sizeof(*cmd));
+	if (ret < 0) {
+		wl1271_error("read memory command failed: %d", ret);
+		goto out;
+	}
+
+	/* the read command got in, we can now read the answer */
+	wl1271_spi_mem_read(wl, wl->cmd_box_addr, cmd, sizeof(*cmd));
+
+	if (cmd->header.status != CMD_STATUS_SUCCESS)
+		wl1271_error("error in read command result: %d",
+			     cmd->header.status);
+
+	memcpy(answer, cmd->value, len);
+
+out:
+	kfree(cmd);
+	return ret;
+}
+
+int wl1271_cmd_scan(struct wl1271 *wl, u8 *ssid, size_t len,
+		    u8 active_scan, u8 high_prio, u8 num_channels,
+		    u8 probe_requests)
+{
+
+	struct wl1271_cmd_trigger_scan_to *trigger = NULL;
+	struct wl1271_cmd_scan *params = NULL;
+	int i, ret;
+	u16 scan_options = 0;
+
+	if (wl->scanning)
+		return -EINVAL;
+
+	params = kzalloc(sizeof(*params), GFP_KERNEL);
+	if (!params)
+		return -ENOMEM;
+
+	params->params.rx_config_options = cpu_to_le32(CFG_RX_ALL_GOOD);
+	params->params.rx_filter_options =
+		cpu_to_le32(CFG_RX_PRSP_EN | CFG_RX_MGMT_EN | CFG_RX_BCN_EN);
+
+	if (!active_scan)
+		scan_options |= WL1271_SCAN_OPT_PASSIVE;
+	if (high_prio)
+		scan_options |= WL1271_SCAN_OPT_PRIORITY_HIGH;
+	params->params.scan_options = scan_options;
+
+	params->params.num_channels = num_channels;
+	params->params.num_probe_requests = probe_requests;
+	params->params.tx_rate = cpu_to_le32(RATE_MASK_2MBPS);
+	params->params.tid_trigger = 0;
+	params->params.scan_tag = WL1271_SCAN_DEFAULT_TAG;
+
+	for (i = 0; i < num_channels; i++) {
+		params->channels[i].min_duration =
+			cpu_to_le32(WL1271_SCAN_CHAN_MIN_DURATION);
+		params->channels[i].max_duration =
+			cpu_to_le32(WL1271_SCAN_CHAN_MAX_DURATION);
+		memset(&params->channels[i].bssid_lsb, 0xff, 4);
+		memset(&params->channels[i].bssid_msb, 0xff, 2);
+		params->channels[i].early_termination = 0;
+		params->channels[i].tx_power_att = WL1271_SCAN_CURRENT_TX_PWR;
+		params->channels[i].channel = i + 1;
+	}
+
+	if (len && ssid) {
+		params->params.ssid_len = len;
+		memcpy(params->params.ssid, ssid, len);
+	}
+
+	ret = wl1271_cmd_build_probe_req(wl, ssid, len);
+	if (ret < 0) {
+		wl1271_error("PROBE request template failed");
+		goto out;
+	}
+
+	trigger = kzalloc(sizeof(*trigger), GFP_KERNEL);
+	if (!trigger) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* disable the timeout */
+	trigger->timeout = 0;
+
+	ret = wl1271_cmd_send(wl, CMD_TRIGGER_SCAN_TO, trigger,
+			      sizeof(*trigger));
+	if (ret < 0) {
+		wl1271_error("trigger scan to failed for hw scan");
+		goto out;
+	}
+
+	wl1271_dump(DEBUG_SCAN, "SCAN: ", params, sizeof(*params));
+
+	wl->scanning = true;
+
+	ret = wl1271_cmd_send(wl, CMD_SCAN, params, sizeof(*params));
+	if (ret < 0) {
+		wl1271_error("SCAN failed");
+		goto out;
+	}
+
+	wl1271_spi_mem_read(wl, wl->cmd_box_addr, params, sizeof(*params));
+
+	if (params->header.status != CMD_STATUS_SUCCESS) {
+		wl1271_error("Scan command error: %d",
+			     params->header.status);
+		wl->scanning = false;
+		ret = -EIO;
+		goto out;
+	}
+
+out:
+	kfree(params);
+	return ret;
+}
+
+int wl1271_cmd_template_set(struct wl1271 *wl, u16 template_id,
+			    void *buf, size_t buf_len)
+{
+	struct wl1271_cmd_template_set *cmd;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_CMD, "cmd template_set %d", template_id);
+
+	WARN_ON(buf_len > WL1271_CMD_TEMPL_MAX_SIZE);
+	buf_len = min_t(size_t, buf_len, WL1271_CMD_TEMPL_MAX_SIZE);
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	cmd->len = cpu_to_le16(buf_len);
+	cmd->template_type = template_id;
+	cmd->enabled_rates = ACX_RATE_MASK_UNSPECIFIED;
+	cmd->short_retry_limit = ACX_RATE_RETRY_LIMIT;
+	cmd->long_retry_limit = ACX_RATE_RETRY_LIMIT;
+
+	if (buf)
+		memcpy(cmd->template_data, buf, buf_len);
+
+	ret = wl1271_cmd_send(wl, CMD_SET_TEMPLATE, cmd, sizeof(*cmd));
+	if (ret < 0) {
+		wl1271_warning("cmd set_template failed: %d", ret);
+		goto out_free;
+	}
+
+out_free:
+	kfree(cmd);
+
+out:
+	return ret;
+}
+
+static int wl1271_build_basic_rates(char *rates)
+{
+	u8 index = 0;
+
+	rates[index++] = IEEE80211_BASIC_RATE_MASK | IEEE80211_CCK_RATE_1MB;
+	rates[index++] = IEEE80211_BASIC_RATE_MASK | IEEE80211_CCK_RATE_2MB;
+	rates[index++] = IEEE80211_BASIC_RATE_MASK | IEEE80211_CCK_RATE_5MB;
+	rates[index++] = IEEE80211_BASIC_RATE_MASK | IEEE80211_CCK_RATE_11MB;
+
+	return index;
+}
+
+static int wl1271_build_extended_rates(char *rates)
+{
+	u8 index = 0;
+
+	rates[index++] = IEEE80211_OFDM_RATE_6MB;
+	rates[index++] = IEEE80211_OFDM_RATE_9MB;
+	rates[index++] = IEEE80211_OFDM_RATE_12MB;
+	rates[index++] = IEEE80211_OFDM_RATE_18MB;
+	rates[index++] = IEEE80211_OFDM_RATE_24MB;
+	rates[index++] = IEEE80211_OFDM_RATE_36MB;
+	rates[index++] = IEEE80211_OFDM_RATE_48MB;
+	rates[index++] = IEEE80211_OFDM_RATE_54MB;
+
+	return index;
+}
+
+int wl1271_cmd_build_null_data(struct wl1271 *wl)
+{
+	struct wl12xx_null_data_template template;
+
+	if (!is_zero_ether_addr(wl->bssid)) {
+		memcpy(template.header.da, wl->bssid, ETH_ALEN);
+		memcpy(template.header.bssid, wl->bssid, ETH_ALEN);
+	} else {
+		memset(template.header.da, 0xff, ETH_ALEN);
+		memset(template.header.bssid, 0xff, ETH_ALEN);
+	}
+
+	memcpy(template.header.sa, wl->mac_addr, ETH_ALEN);
+	template.header.frame_ctl = cpu_to_le16(IEEE80211_FTYPE_DATA |
+						IEEE80211_STYPE_NULLFUNC);
+
+	return wl1271_cmd_template_set(wl, CMD_TEMPL_NULL_DATA, &template,
+				       sizeof(template));
+
+}
+
+int wl1271_cmd_build_ps_poll(struct wl1271 *wl, u16 aid)
+{
+	struct wl12xx_ps_poll_template template;
+
+	memcpy(template.bssid, wl->bssid, ETH_ALEN);
+	memcpy(template.ta, wl->mac_addr, ETH_ALEN);
+	template.aid = aid;
+	template.fc = cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_PSPOLL);
+
+	return wl1271_cmd_template_set(wl, CMD_TEMPL_PS_POLL, &template,
+				       sizeof(template));
+
+}
+
+int wl1271_cmd_build_probe_req(struct wl1271 *wl, u8 *ssid, size_t ssid_len)
+{
+	struct wl12xx_probe_req_template template;
+	struct wl12xx_ie_rates *rates;
+	char *ptr;
+	u16 size;
+
+	ptr = (char *)&template;
+	size = sizeof(struct ieee80211_header);
+
+	memset(template.header.da, 0xff, ETH_ALEN);
+	memset(template.header.bssid, 0xff, ETH_ALEN);
+	memcpy(template.header.sa, wl->mac_addr, ETH_ALEN);
+	template.header.frame_ctl = cpu_to_le16(IEEE80211_STYPE_PROBE_REQ);
+
+	/* IEs */
+	/* SSID */
+	template.ssid.header.id = WLAN_EID_SSID;
+	template.ssid.header.len = ssid_len;
+	if (ssid_len && ssid)
+		memcpy(template.ssid.ssid, ssid, ssid_len);
+	size += sizeof(struct wl12xx_ie_header) + ssid_len;
+	ptr += size;
+
+	/* Basic Rates */
+	rates = (struct wl12xx_ie_rates *)ptr;
+	rates->header.id = WLAN_EID_SUPP_RATES;
+	rates->header.len = wl1271_build_basic_rates(rates->rates);
+	size += sizeof(struct wl12xx_ie_header) + rates->header.len;
+	ptr += sizeof(struct wl12xx_ie_header) + rates->header.len;
+
+	/* Extended rates */
+	rates = (struct wl12xx_ie_rates *)ptr;
+	rates->header.id = WLAN_EID_EXT_SUPP_RATES;
+	rates->header.len = wl1271_build_extended_rates(rates->rates);
+	size += sizeof(struct wl12xx_ie_header) + rates->header.len;
+
+	wl1271_dump(DEBUG_SCAN, "PROBE REQ: ", &template, size);
+
+	return wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_2_4,
+				       &template, size);
+}
+
+int wl1271_cmd_set_default_wep_key(struct wl1271 *wl, u8 id)
+{
+	struct wl1271_cmd_set_keys *cmd;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_CMD, "cmd set_default_wep_key %d", id);
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	cmd->id = id;
+	cmd->key_action = KEY_SET_ID;
+	cmd->key_type = KEY_WEP;
+
+	ret = wl1271_cmd_send(wl, CMD_SET_KEYS, cmd, sizeof(*cmd));
+	if (ret < 0) {
+		wl1271_warning("cmd set_default_wep_key failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(cmd);
+
+	return ret;
+}
+
+int wl1271_cmd_set_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
+		       u8 key_size, const u8 *key, const u8 *addr)
+{
+	struct wl1271_cmd_set_keys *cmd;
+	int ret = 0;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (key_type != KEY_WEP)
+		memcpy(cmd->addr, addr, ETH_ALEN);
+
+	cmd->key_action = action;
+	cmd->key_size = key_size;
+	cmd->key_type = key_type;
+
+	/* we have only one SSID profile */
+	cmd->ssid_profile = 0;
+
+	cmd->id = id;
+
+	/* FIXME: this is from wl1251, needs to be checked */
+	if (key_type == KEY_TKIP) {
+		/*
+		 * We get the key in the following form:
+		 * TKIP (16 bytes) - TX MIC (8 bytes) - RX MIC (8 bytes)
+		 * but the target is expecting:
+		 * TKIP - RX MIC - TX MIC
+		 */
+		memcpy(cmd->key, key, 16);
+		memcpy(cmd->key + 16, key + 24, 8);
+		memcpy(cmd->key + 24, key + 16, 8);
+
+	} else {
+		memcpy(cmd->key, key, key_size);
+	}
+
+	wl1271_dump(DEBUG_CRYPT, "TARGET KEY: ", cmd, sizeof(*cmd));
+
+	ret = wl1271_cmd_send(wl, CMD_SET_KEYS, cmd, sizeof(*cmd));
+	if (ret < 0) {
+		wl1271_warning("could not set keys");
+		goto out;
+	}
+
+out:
+	kfree(cmd);
+
+	return ret;
+}
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
new file mode 100644
index 0000000..951a844
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -0,0 +1,464 @@
+/*
+ * This file is part of wl1271
+ *
+ * Copyright (C) 1998-2009 Texas Instruments. All rights reserved.
+ * Copyright (C) 2009 Nokia Corporation
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
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
+#ifndef __WL1271_CMD_H__
+#define __WL1271_CMD_H__
+
+#include "wl1271.h"
+
+struct acx_header;
+
+int wl1271_cmd_send(struct wl1271 *wl, u16 type, void *buf, size_t buf_len);
+int wl1271_cmd_join(struct wl1271 *wl, u8 bss_type, u8 dtim_interval,
+		    u16 beacon_interval, u8 wait);
+int wl1271_cmd_test(struct wl1271 *wl, void *buf, size_t buf_len, u8 answer);
+int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf, size_t len);
+int wl1271_cmd_configure(struct wl1271 *wl, u16 id, void *buf, size_t len);
+int wl1271_cmd_data_path(struct wl1271 *wl, u8 channel, bool enable);
+int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode);
+int wl1271_cmd_read_memory(struct wl1271 *wl, u32 addr, void *answer,
+			   size_t len);
+int wl1271_cmd_scan(struct wl1271 *wl, u8 *ssid, size_t len,
+		    u8 active_scan, u8 high_prio, u8 num_channels,
+		    u8 probe_requests);
+int wl1271_cmd_template_set(struct wl1271 *wl, u16 template_id,
+			    void *buf, size_t buf_len);
+int wl1271_cmd_build_null_data(struct wl1271 *wl);
+int wl1271_cmd_build_ps_poll(struct wl1271 *wl, u16 aid);
+int wl1271_cmd_build_probe_req(struct wl1271 *wl, u8 *ssid, size_t ssid_len);
+int wl1271_cmd_set_default_wep_key(struct wl1271 *wl, u8 id);
+int wl1271_cmd_set_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
+		       u8 key_size, const u8 *key, const u8 *addr);
+
+enum wl1271_commands {
+	CMD_INTERROGATE     = 1,    /*use this to read information elements*/
+	CMD_CONFIGURE       = 2,    /*use this to write information elements*/
+	CMD_ENABLE_RX       = 3,
+	CMD_ENABLE_TX       = 4,
+	CMD_DISABLE_RX      = 5,
+	CMD_DISABLE_TX      = 6,
+	CMD_SCAN            = 8,
+	CMD_STOP_SCAN       = 9,
+	CMD_START_JOIN      = 11,
+	CMD_SET_KEYS        = 12,
+	CMD_READ_MEMORY     = 13,
+	CMD_WRITE_MEMORY    = 14,
+	CMD_SET_TEMPLATE    = 19,
+	CMD_TEST            = 23,
+	CMD_NOISE_HIST      = 28,
+	CMD_LNA_CONTROL     = 32,
+	CMD_SET_BCN_MODE    = 33,
+	CMD_MEASUREMENT      = 34,
+	CMD_STOP_MEASUREMENT = 35,
+	CMD_DISCONNECT       = 36,
+	CMD_SET_PS_MODE      = 37,
+	CMD_CHANNEL_SWITCH   = 38,
+	CMD_STOP_CHANNEL_SWICTH = 39,
+	CMD_AP_DISCOVERY     = 40,
+	CMD_STOP_AP_DISCOVERY = 41,
+	CMD_SPS_SCAN = 42,
+	CMD_STOP_SPS_SCAN = 43,
+	CMD_HEALTH_CHECK     = 45,
+	CMD_DEBUG            = 46,
+	CMD_TRIGGER_SCAN_TO  = 47,
+	CMD_CONNECTION_SCAN_CFG      = 48,
+	CMD_CONNECTION_SCAN_SSID_CFG = 49,
+	CMD_START_PERIODIC_SCAN      = 50,
+	CMD_STOP_PERIODIC_SCAN       = 51,
+	CMD_SET_STA_STATE            = 52,
+
+	NUM_COMMANDS,
+	MAX_COMMAND_ID = 0xFFFF,
+};
+
+#define MAX_CMD_PARAMS 572
+
+enum cmd_templ {
+	CMD_TEMPL_NULL_DATA = 0,
+	CMD_TEMPL_BEACON,
+	CMD_TEMPL_CFG_PROBE_REQ_2_4,
+	CMD_TEMPL_CFG_PROBE_REQ_5,
+	CMD_TEMPL_PROBE_RESPONSE,
+	CMD_TEMPL_QOS_NULL_DATA,
+	CMD_TEMPL_PS_POLL,
+	CMD_TEMPL_KLV,
+	CMD_TEMPL_DISCONNECT,
+	CMD_TEMPL_PROBE_REQ_2_4, /* for firmware internal use only */
+	CMD_TEMPL_PROBE_REQ_5,   /* for firmware internal use only */
+	CMD_TEMPL_BAR,           /* for firmware internal use only */
+	CMD_TEMPL_CTS,           /*
+				  * For CTS-to-self (FastCTS) mechanism
+				  * for BT/WLAN coexistence (SoftGemini). */
+	CMD_TEMPL_MAX = 0xff
+};
+
+/* unit ms */
+#define WL1271_COMMAND_TIMEOUT     2000
+#define WL1271_CMD_TEMPL_MAX_SIZE  252
+
+struct wl1271_cmd_header {
+	u16 id;
+	u16 status;
+	/* payload */
+	u8 data[0];
+} __attribute__ ((packed));
+
+#define WL1271_CMD_MAX_PARAMS 572
+
+struct wl1271_command {
+	struct wl1271_cmd_header header;
+	u8  parameters[WL1271_CMD_MAX_PARAMS];
+} __attribute__ ((packed));
+
+enum {
+	CMD_MAILBOX_IDLE		=  0,
+	CMD_STATUS_SUCCESS		=  1,
+	CMD_STATUS_UNKNOWN_CMD		=  2,
+	CMD_STATUS_UNKNOWN_IE		=  3,
+	CMD_STATUS_REJECT_MEAS_SG_ACTIVE	= 11,
+	CMD_STATUS_RX_BUSY		= 13,
+	CMD_STATUS_INVALID_PARAM		= 14,
+	CMD_STATUS_TEMPLATE_TOO_LARGE		= 15,
+	CMD_STATUS_OUT_OF_MEMORY		= 16,
+	CMD_STATUS_STA_TABLE_FULL		= 17,
+	CMD_STATUS_RADIO_ERROR		= 18,
+	CMD_STATUS_WRONG_NESTING		= 19,
+	CMD_STATUS_TIMEOUT		= 21, /* Driver internal use.*/
+	CMD_STATUS_FW_RESET		= 22, /* Driver internal use.*/
+	MAX_COMMAND_STATUS		= 0xff
+};
+
+
+/*
+ * CMD_READ_MEMORY
+ *
+ * The host issues this command to read the WiLink device memory/registers.
+ *
+ * Note: The Base Band address has special handling (16 bits registers and
+ * addresses). For more information, see the hardware specification.
+ */
+/*
+ * CMD_WRITE_MEMORY
+ *
+ * The host issues this command to write the WiLink device memory/registers.
+ *
+ * The Base Band address has special handling (16 bits registers and
+ * addresses). For more information, see the hardware specification.
+ */
+#define MAX_READ_SIZE 256
+
+struct cmd_read_write_memory {
+	struct wl1271_cmd_header header;
+
+	/* The address of the memory to read from or write to.*/
+	u32 addr;
+
+	/* The amount of data in bytes to read from or write to the WiLink
+	 * device.*/
+	u32 size;
+
+	/* The actual value read from or written to the Wilink. The source
+	   of this field is the Host in WRITE command or the Wilink in READ
+	   command. */
+	u8 value[MAX_READ_SIZE];
+};
+
+#define CMDMBOX_HEADER_LEN 4
+#define CMDMBOX_INFO_ELEM_HEADER_LEN 4
+
+enum {
+	BSS_TYPE_IBSS = 0,
+	BSS_TYPE_STA_BSS = 2,
+	BSS_TYPE_AP_BSS = 3,
+	MAX_BSS_TYPE = 0xFF
+};
+
+#define WL1271_JOIN_CMD_CTRL_TX_FLUSH     0x80 /* Firmware flushes all Tx */
+#define WL1271_JOIN_CMD_TX_SESSION_OFFSET 1
+
+struct wl1271_cmd_join {
+	struct wl1271_cmd_header header;
+
+	u32 bssid_lsb;
+	u16 bssid_msb;
+	u16 beacon_interval; /* in TBTTs */
+	u32 rx_config_options;
+	u32 rx_filter_options;
+
+	/*
+	 * The target uses this field to determine the rate at
+	 * which to transmit control frame responses (such as
+	 * ACK or CTS frames).
+	 */
+	u32 basic_rate_set;
+	u8 dtim_interval;
+	/*
+	 * bits 0-2: This bitwise field specifies the type
+	 * of BSS to start or join (BSS_TYPE_*).
+	 * bit 4: Band - The radio band in which to join
+	 * or start.
+	 *  0 - 2.4GHz band
+	 *  1 - 5GHz band
+	 * bits 3, 5-7: Reserved
+	 */
+	u8 bss_type;
+	u8 channel;
+	u8 ssid_len;
+	u8 ssid[IW_ESSID_MAX_SIZE];
+	u8 ctrl; /* JOIN_CMD_CTRL_* */
+	u8 reserved[3];
+} __attribute__ ((packed));
+
+struct cmd_enabledisable_path {
+	struct wl1271_cmd_header header;
+
+	u8 channel;
+	u8 padding[3];
+} __attribute__ ((packed));
+
+struct wl1271_cmd_template_set {
+	struct wl1271_cmd_header header;
+
+	u16 len;
+	u8 template_type;
+	u8 index;  /* relevant only for KLV_TEMPLATE type */
+	u32 enabled_rates;
+	u8 short_retry_limit;
+	u8 long_retry_limit;
+	u8 aflags;
+	u8 reserved;
+	u8 template_data[WL1271_CMD_TEMPL_MAX_SIZE];
+} __attribute__ ((packed));
+
+#define TIM_ELE_ID    5
+#define PARTIAL_VBM_MAX    251
+
+struct wl1271_tim {
+	u8 identity;
+	u8 length;
+	u8 dtim_count;
+	u8 dtim_period;
+	u8 bitmap_ctrl;
+	u8 pvb_field[PARTIAL_VBM_MAX]; /* Partial Virtual Bitmap */
+} __attribute__ ((packed));
+
+enum wl1271_cmd_ps_mode {
+	STATION_ACTIVE_MODE,
+	STATION_POWER_SAVE_MODE
+};
+
+struct wl1271_cmd_ps_params {
+	struct wl1271_cmd_header header;
+
+	u8 ps_mode; /* STATION_* */
+	u8 send_null_data; /* Do we have to send NULL data packet ? */
+	u8 retries; /* Number of retires for the initial NULL data packet */
+
+	 /*
+	  * TUs during which the target stays awake after switching
+	  * to power save mode.
+	  */
+	u8 hang_over_period;
+	u32 null_data_rate;
+} __attribute__ ((packed));
+
+/* HW encryption keys */
+#define NUM_ACCESS_CATEGORIES_COPY 4
+#define MAX_KEY_SIZE 32
+
+/* When set, disable HW encryption */
+#define DF_ENCRYPTION_DISABLE      0x01
+/* When set, disable HW decryption */
+#define DF_SNIFF_MODE_ENABLE       0x80
+
+enum wl1271_cmd_key_action {
+	KEY_ADD_OR_REPLACE = 1,
+	KEY_REMOVE         = 2,
+	KEY_SET_ID         = 3,
+	MAX_KEY_ACTION     = 0xffff,
+};
+
+enum wl1271_cmd_key_type {
+	KEY_NONE = 0,
+	KEY_WEP  = 1,
+	KEY_TKIP = 2,
+	KEY_AES  = 3,
+	KEY_GEM  = 4
+};
+
+/* FIXME: Add description for key-types */
+
+struct wl1271_cmd_set_keys {
+	struct wl1271_cmd_header header;
+
+	/* Ignored for default WEP key */
+	u8 addr[ETH_ALEN];
+
+	/* key_action_e */
+	u16 key_action;
+
+	u16 reserved_1;
+
+	/* key size in bytes */
+	u8 key_size;
+
+	/* key_type_e */
+	u8 key_type;
+	u8 ssid_profile;
+
+	/*
+	 * TKIP, AES: frame's key id field.
+	 * For WEP default key: key id;
+	 */
+	u8 id;
+	u8 reserved_2[6];
+	u8 key[MAX_KEY_SIZE];
+	u16 ac_seq_num16[NUM_ACCESS_CATEGORIES_COPY];
+	u32 ac_seq_num32[NUM_ACCESS_CATEGORIES_COPY];
+} __attribute__ ((packed));
+
+
+#define WL1271_SCAN_MAX_CHANNELS       24
+#define WL1271_SCAN_DEFAULT_TAG        1
+#define WL1271_SCAN_CURRENT_TX_PWR     0
+#define WL1271_SCAN_OPT_ACTIVE         0
+#define WL1271_SCAN_OPT_PASSIVE	       1
+#define WL1271_SCAN_OPT_PRIORITY_HIGH  4
+#define WL1271_SCAN_CHAN_MIN_DURATION  30000  /* TU */
+#define WL1271_SCAN_CHAN_MAX_DURATION  60000  /* TU */
+
+struct basic_scan_params {
+	u32 rx_config_options;
+	u32 rx_filter_options;
+	/* Scan option flags (WL1271_SCAN_OPT_*) */
+	u16 scan_options;
+	/* Number of scan channels in the list (maximum 30) */
+	u8 num_channels;
+	/* This field indicates the number of probe requests to send
+	   per channel for an active scan */
+	u8 num_probe_requests;
+	/* Rate bit field for sending the probes */
+	u32 tx_rate;
+	u8 tid_trigger;
+	u8 ssid_len;
+	/* in order to align */
+	u8 padding1[2];
+	u8 ssid[IW_ESSID_MAX_SIZE];
+	/* Band to scan */
+	u8 band;
+	u8 use_ssid_list;
+	u8 scan_tag;
+	u8 padding2;
+} __attribute__ ((packed));
+
+struct basic_scan_channel_params {
+	/* Duration in TU to wait for frames on a channel for active scan */
+	u32 min_duration;
+	u32 max_duration;
+	u32 bssid_lsb;
+	u16 bssid_msb;
+	u8 early_termination;
+	u8 tx_power_att;
+	u8 channel;
+	/* FW internal use only! */
+	u8 dfs_candidate;
+	u8 activity_detected;
+	u8 pad;
+} __attribute__ ((packed));
+
+struct wl1271_cmd_scan {
+	struct wl1271_cmd_header header;
+
+	struct basic_scan_params params;
+	struct basic_scan_channel_params channels[WL1271_SCAN_MAX_CHANNELS];
+} __attribute__ ((packed));
+
+struct wl1271_cmd_trigger_scan_to {
+	struct wl1271_cmd_header header;
+
+	u32 timeout;
+};
+
+struct wl1271_cmd_test_header {
+	u8 id;
+	u8 padding[3];
+};
+
+enum wl1271_channel_tune_bands {
+	WL1271_CHANNEL_TUNE_BAND_2_4,
+	WL1271_CHANNEL_TUNE_BAND_5,
+	WL1271_CHANNEL_TUNE_BAND_4_9
+};
+
+#define WL1271_PD_REFERENCE_POINT_BAND_B_G 0
+
+#define TEST_CMD_P2G_CAL                   0x02
+#define TEST_CMD_CHANNEL_TUNE              0x0d
+#define TEST_CMD_UPDATE_PD_REFERENCE_POINT 0x1d
+
+struct wl1271_cmd_cal_channel_tune {
+	struct wl1271_cmd_header header;
+
+	struct wl1271_cmd_test_header test;
+
+	u8 band;
+	u8 channel;
+
+	u16 radio_status;
+} __attribute__ ((packed));
+
+struct wl1271_cmd_cal_update_ref_point {
+	struct wl1271_cmd_header header;
+
+	struct wl1271_cmd_test_header test;
+
+	s32 ref_power;
+	s32 ref_detector;
+	u8  sub_band;
+	u8  padding[3];
+} __attribute__ ((packed));
+
+#define MAX_TLV_LENGTH         400
+#define	MAX_NVS_VERSION_LENGTH 12
+
+#define WL1271_CAL_P2G_BAND_B_G BIT(0)
+
+struct wl1271_cmd_cal_p2g {
+	struct wl1271_cmd_header header;
+
+	struct wl1271_cmd_test_header test;
+
+	u16 len;
+	u8  buf[MAX_TLV_LENGTH];
+	u8  type;
+	u8  padding;
+
+	s16 radio_status;
+	u8  nvs_version[MAX_NVS_VERSION_LENGTH];
+
+	u8  sub_band_mask;
+	u8  padding2;
+} __attribute__ ((packed));
+
+#endif /* __WL1271_CMD_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl1271_debugfs.c b/drivers/net/wireless/wl12xx/wl1271_debugfs.c
new file mode 100644
index 0000000..c1805e5
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1271_debugfs.c
@@ -0,0 +1,518 @@
+/*
+ * This file is part of wl1271
+ *
+ * Copyright (C) 2009 Nokia Corporation
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
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
+#include "wl1271_debugfs.h"
+
+#include <linux/skbuff.h>
+
+#include "wl1271.h"
+#include "wl1271_acx.h"
+#include "wl1271_ps.h"
+
+/* ms */
+#define WL1271_DEBUGFS_STATS_LIFETIME 1000
+
+/* debugfs macros idea from mac80211 */
+
+#define DEBUGFS_READONLY_FILE(name, buflen, fmt, value...)		\
+static ssize_t name## _read(struct file *file, char __user *userbuf,	\
+			    size_t count, loff_t *ppos)			\
+{									\
+	struct wl1271 *wl = file->private_data;				\
+	char buf[buflen];						\
+	int res;							\
+									\
+	res = scnprintf(buf, buflen, fmt "\n", ##value);		\
+	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
+}									\
+									\
+static const struct file_operations name## _ops = {			\
+	.read = name## _read,						\
+	.open = wl1271_open_file_generic,				\
+};
+
+#define DEBUGFS_ADD(name, parent)					\
+	wl->debugfs.name = debugfs_create_file(#name, 0400, parent,	\
+					       wl, &name## _ops);	\
+	if (IS_ERR(wl->debugfs.name)) {					\
+		ret = PTR_ERR(wl->debugfs.name);			\
+		wl->debugfs.name = NULL;				\
+		goto out;						\
+	}
+
+#define DEBUGFS_DEL(name)						\
+	do {								\
+		debugfs_remove(wl->debugfs.name);			\
+		wl->debugfs.name = NULL;				\
+	} while (0)
+
+#define DEBUGFS_FWSTATS_FILE(sub, name, buflen, fmt)			\
+static ssize_t sub## _ ##name## _read(struct file *file,		\
+				      char __user *userbuf,		\
+				      size_t count, loff_t *ppos)	\
+{									\
+	struct wl1271 *wl = file->private_data;				\
+	char buf[buflen];						\
+	int res;							\
+									\
+	wl1271_debugfs_update_stats(wl);				\
+									\
+	res = scnprintf(buf, buflen, fmt "\n",				\
+			wl->stats.fw_stats->sub.name);			\
+	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
+}									\
+									\
+static const struct file_operations sub## _ ##name## _ops = {		\
+	.read = sub## _ ##name## _read,					\
+	.open = wl1271_open_file_generic,				\
+};
+
+#define DEBUGFS_FWSTATS_ADD(sub, name)				\
+	DEBUGFS_ADD(sub## _ ##name, wl->debugfs.fw_statistics)
+
+#define DEBUGFS_FWSTATS_DEL(sub, name)				\
+	DEBUGFS_DEL(sub## _ ##name)
+
+static void wl1271_debugfs_update_stats(struct wl1271 *wl)
+{
+	int ret;
+
+	mutex_lock(&wl->mutex);
+
+	ret = wl1271_ps_elp_wakeup(wl, false);
+	if (ret < 0)
+		goto out;
+
+	if (wl->state == WL1271_STATE_ON &&
+	    time_after(jiffies, wl->stats.fw_stats_update +
+		       msecs_to_jiffies(WL1271_DEBUGFS_STATS_LIFETIME))) {
+		wl1271_acx_statistics(wl, wl->stats.fw_stats);
+		wl->stats.fw_stats_update = jiffies;
+	}
+
+	wl1271_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
+}
+
+static int wl1271_open_file_generic(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+DEBUGFS_FWSTATS_FILE(tx, internal_desc_overflow, 20, "%u");
+
+DEBUGFS_FWSTATS_FILE(rx, out_of_mem, 20, "%u");
+DEBUGFS_FWSTATS_FILE(rx, hdr_overflow, 20, "%u");
+DEBUGFS_FWSTATS_FILE(rx, hw_stuck, 20, "%u");
+DEBUGFS_FWSTATS_FILE(rx, dropped, 20, "%u");
+DEBUGFS_FWSTATS_FILE(rx, fcs_err, 20, "%u");
+DEBUGFS_FWSTATS_FILE(rx, xfr_hint_trig, 20, "%u");
+DEBUGFS_FWSTATS_FILE(rx, path_reset, 20, "%u");
+DEBUGFS_FWSTATS_FILE(rx, reset_counter, 20, "%u");
+
+DEBUGFS_FWSTATS_FILE(dma, rx_requested, 20, "%u");
+DEBUGFS_FWSTATS_FILE(dma, rx_errors, 20, "%u");
+DEBUGFS_FWSTATS_FILE(dma, tx_requested, 20, "%u");
+DEBUGFS_FWSTATS_FILE(dma, tx_errors, 20, "%u");
+
+DEBUGFS_FWSTATS_FILE(isr, cmd_cmplt, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, fiqs, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, rx_headers, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, rx_mem_overflow, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, rx_rdys, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, irqs, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, tx_procs, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, decrypt_done, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, dma0_done, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, dma1_done, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, tx_exch_complete, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, commands, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, rx_procs, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, hw_pm_mode_changes, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, host_acknowledges, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, pci_pm, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, wakeups, 20, "%u");
+DEBUGFS_FWSTATS_FILE(isr, low_rssi, 20, "%u");
+
+DEBUGFS_FWSTATS_FILE(wep, addr_key_count, 20, "%u");
+DEBUGFS_FWSTATS_FILE(wep, default_key_count, 20, "%u");
+/* skipping wep.reserved */
+DEBUGFS_FWSTATS_FILE(wep, key_not_found, 20, "%u");
+DEBUGFS_FWSTATS_FILE(wep, decrypt_fail, 20, "%u");
+DEBUGFS_FWSTATS_FILE(wep, packets, 20, "%u");
+DEBUGFS_FWSTATS_FILE(wep, interrupt, 20, "%u");
+
+DEBUGFS_FWSTATS_FILE(pwr, ps_enter, 20, "%u");
+DEBUGFS_FWSTATS_FILE(pwr, elp_enter, 20, "%u");
+DEBUGFS_FWSTATS_FILE(pwr, missing_bcns, 20, "%u");
+DEBUGFS_FWSTATS_FILE(pwr, wake_on_host, 20, "%u");
+DEBUGFS_FWSTATS_FILE(pwr, wake_on_timer_exp, 20, "%u");
+DEBUGFS_FWSTATS_FILE(pwr, tx_with_ps, 20, "%u");
+DEBUGFS_FWSTATS_FILE(pwr, tx_without_ps, 20, "%u");
+DEBUGFS_FWSTATS_FILE(pwr, rcvd_beacons, 20, "%u");
+DEBUGFS_FWSTATS_FILE(pwr, power_save_off, 20, "%u");
+DEBUGFS_FWSTATS_FILE(pwr, enable_ps, 20, "%u");
+DEBUGFS_FWSTATS_FILE(pwr, disable_ps, 20, "%u");
+DEBUGFS_FWSTATS_FILE(pwr, fix_tsf_ps, 20, "%u");
+/* skipping cont_miss_bcns_spread for now */
+DEBUGFS_FWSTATS_FILE(pwr, rcvd_awake_beacons, 20, "%u");
+
+DEBUGFS_FWSTATS_FILE(mic, rx_pkts, 20, "%u");
+DEBUGFS_FWSTATS_FILE(mic, calc_failure, 20, "%u");
+
+DEBUGFS_FWSTATS_FILE(aes, encrypt_fail, 20, "%u");
+DEBUGFS_FWSTATS_FILE(aes, decrypt_fail, 20, "%u");
+DEBUGFS_FWSTATS_FILE(aes, encrypt_packets, 20, "%u");
+DEBUGFS_FWSTATS_FILE(aes, decrypt_packets, 20, "%u");
+DEBUGFS_FWSTATS_FILE(aes, encrypt_interrupt, 20, "%u");
+DEBUGFS_FWSTATS_FILE(aes, decrypt_interrupt, 20, "%u");
+
+DEBUGFS_FWSTATS_FILE(event, heart_beat, 20, "%u");
+DEBUGFS_FWSTATS_FILE(event, calibration, 20, "%u");
+DEBUGFS_FWSTATS_FILE(event, rx_mismatch, 20, "%u");
+DEBUGFS_FWSTATS_FILE(event, rx_mem_empty, 20, "%u");
+DEBUGFS_FWSTATS_FILE(event, rx_pool, 20, "%u");
+DEBUGFS_FWSTATS_FILE(event, oom_late, 20, "%u");
+DEBUGFS_FWSTATS_FILE(event, phy_transmit_error, 20, "%u");
+DEBUGFS_FWSTATS_FILE(event, tx_stuck, 20, "%u");
+
+DEBUGFS_FWSTATS_FILE(ps, pspoll_timeouts, 20, "%u");
+DEBUGFS_FWSTATS_FILE(ps, upsd_timeouts, 20, "%u");
+DEBUGFS_FWSTATS_FILE(ps, upsd_max_sptime, 20, "%u");
+DEBUGFS_FWSTATS_FILE(ps, upsd_max_apturn, 20, "%u");
+DEBUGFS_FWSTATS_FILE(ps, pspoll_max_apturn, 20, "%u");
+DEBUGFS_FWSTATS_FILE(ps, pspoll_utilization, 20, "%u");
+DEBUGFS_FWSTATS_FILE(ps, upsd_utilization, 20, "%u");
+
+DEBUGFS_FWSTATS_FILE(rxpipe, rx_prep_beacon_drop, 20, "%u");
+DEBUGFS_FWSTATS_FILE(rxpipe, descr_host_int_trig_rx_data, 20, "%u");
+DEBUGFS_FWSTATS_FILE(rxpipe, beacon_buffer_thres_host_int_trig_rx_data,
+		     20, "%u");
+DEBUGFS_FWSTATS_FILE(rxpipe, missed_beacon_host_int_trig_rx_data, 20, "%u");
+DEBUGFS_FWSTATS_FILE(rxpipe, tx_xfr_host_int_trig_rx_data, 20, "%u");
+
+DEBUGFS_READONLY_FILE(retry_count, 20, "%u", wl->stats.retry_count);
+DEBUGFS_READONLY_FILE(excessive_retries, 20, "%u",
+		      wl->stats.excessive_retries);
+
+static ssize_t tx_queue_len_read(struct file *file, char __user *userbuf,
+				 size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+	u32 queue_len;
+	char buf[20];
+	int res;
+
+	queue_len = skb_queue_len(&wl->tx_queue);
+
+	res = scnprintf(buf, sizeof(buf), "%u\n", queue_len);
+	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
+}
+
+static const struct file_operations tx_queue_len_ops = {
+	.read = tx_queue_len_read,
+	.open = wl1271_open_file_generic,
+};
+
+static void wl1271_debugfs_delete_files(struct wl1271 *wl)
+{
+	DEBUGFS_FWSTATS_DEL(tx, internal_desc_overflow);
+
+	DEBUGFS_FWSTATS_DEL(rx, out_of_mem);
+	DEBUGFS_FWSTATS_DEL(rx, hdr_overflow);
+	DEBUGFS_FWSTATS_DEL(rx, hw_stuck);
+	DEBUGFS_FWSTATS_DEL(rx, dropped);
+	DEBUGFS_FWSTATS_DEL(rx, fcs_err);
+	DEBUGFS_FWSTATS_DEL(rx, xfr_hint_trig);
+	DEBUGFS_FWSTATS_DEL(rx, path_reset);
+	DEBUGFS_FWSTATS_DEL(rx, reset_counter);
+
+	DEBUGFS_FWSTATS_DEL(dma, rx_requested);
+	DEBUGFS_FWSTATS_DEL(dma, rx_errors);
+	DEBUGFS_FWSTATS_DEL(dma, tx_requested);
+	DEBUGFS_FWSTATS_DEL(dma, tx_errors);
+
+	DEBUGFS_FWSTATS_DEL(isr, cmd_cmplt);
+	DEBUGFS_FWSTATS_DEL(isr, fiqs);
+	DEBUGFS_FWSTATS_DEL(isr, rx_headers);
+	DEBUGFS_FWSTATS_DEL(isr, rx_mem_overflow);
+	DEBUGFS_FWSTATS_DEL(isr, rx_rdys);
+	DEBUGFS_FWSTATS_DEL(isr, irqs);
+	DEBUGFS_FWSTATS_DEL(isr, tx_procs);
+	DEBUGFS_FWSTATS_DEL(isr, decrypt_done);
+	DEBUGFS_FWSTATS_DEL(isr, dma0_done);
+	DEBUGFS_FWSTATS_DEL(isr, dma1_done);
+	DEBUGFS_FWSTATS_DEL(isr, tx_exch_complete);
+	DEBUGFS_FWSTATS_DEL(isr, commands);
+	DEBUGFS_FWSTATS_DEL(isr, rx_procs);
+	DEBUGFS_FWSTATS_DEL(isr, hw_pm_mode_changes);
+	DEBUGFS_FWSTATS_DEL(isr, host_acknowledges);
+	DEBUGFS_FWSTATS_DEL(isr, pci_pm);
+	DEBUGFS_FWSTATS_DEL(isr, wakeups);
+	DEBUGFS_FWSTATS_DEL(isr, low_rssi);
+
+	DEBUGFS_FWSTATS_DEL(wep, addr_key_count);
+	DEBUGFS_FWSTATS_DEL(wep, default_key_count);
+	/* skipping wep.reserved */
+	DEBUGFS_FWSTATS_DEL(wep, key_not_found);
+	DEBUGFS_FWSTATS_DEL(wep, decrypt_fail);
+	DEBUGFS_FWSTATS_DEL(wep, packets);
+	DEBUGFS_FWSTATS_DEL(wep, interrupt);
+
+	DEBUGFS_FWSTATS_DEL(pwr, ps_enter);
+	DEBUGFS_FWSTATS_DEL(pwr, elp_enter);
+	DEBUGFS_FWSTATS_DEL(pwr, missing_bcns);
+	DEBUGFS_FWSTATS_DEL(pwr, wake_on_host);
+	DEBUGFS_FWSTATS_DEL(pwr, wake_on_timer_exp);
+	DEBUGFS_FWSTATS_DEL(pwr, tx_with_ps);
+	DEBUGFS_FWSTATS_DEL(pwr, tx_without_ps);
+	DEBUGFS_FWSTATS_DEL(pwr, rcvd_beacons);
+	DEBUGFS_FWSTATS_DEL(pwr, power_save_off);
+	DEBUGFS_FWSTATS_DEL(pwr, enable_ps);
+	DEBUGFS_FWSTATS_DEL(pwr, disable_ps);
+	DEBUGFS_FWSTATS_DEL(pwr, fix_tsf_ps);
+	/* skipping cont_miss_bcns_spread for now */
+	DEBUGFS_FWSTATS_DEL(pwr, rcvd_awake_beacons);
+
+	DEBUGFS_FWSTATS_DEL(mic, rx_pkts);
+	DEBUGFS_FWSTATS_DEL(mic, calc_failure);
+
+	DEBUGFS_FWSTATS_DEL(aes, encrypt_fail);
+	DEBUGFS_FWSTATS_DEL(aes, decrypt_fail);
+	DEBUGFS_FWSTATS_DEL(aes, encrypt_packets);
+	DEBUGFS_FWSTATS_DEL(aes, decrypt_packets);
+	DEBUGFS_FWSTATS_DEL(aes, encrypt_interrupt);
+	DEBUGFS_FWSTATS_DEL(aes, decrypt_interrupt);
+
+	DEBUGFS_FWSTATS_DEL(event, heart_beat);
+	DEBUGFS_FWSTATS_DEL(event, calibration);
+	DEBUGFS_FWSTATS_DEL(event, rx_mismatch);
+	DEBUGFS_FWSTATS_DEL(event, rx_mem_empty);
+	DEBUGFS_FWSTATS_DEL(event, rx_pool);
+	DEBUGFS_FWSTATS_DEL(event, oom_late);
+	DEBUGFS_FWSTATS_DEL(event, phy_transmit_error);
+	DEBUGFS_FWSTATS_DEL(event, tx_stuck);
+
+	DEBUGFS_FWSTATS_DEL(ps, pspoll_timeouts);
+	DEBUGFS_FWSTATS_DEL(ps, upsd_timeouts);
+	DEBUGFS_FWSTATS_DEL(ps, upsd_max_sptime);
+	DEBUGFS_FWSTATS_DEL(ps, upsd_max_apturn);
+	DEBUGFS_FWSTATS_DEL(ps, pspoll_max_apturn);
+	DEBUGFS_FWSTATS_DEL(ps, pspoll_utilization);
+	DEBUGFS_FWSTATS_DEL(ps, upsd_utilization);
+
+	DEBUGFS_FWSTATS_DEL(rxpipe, rx_prep_beacon_drop);
+	DEBUGFS_FWSTATS_DEL(rxpipe, descr_host_int_trig_rx_data);
+	DEBUGFS_FWSTATS_DEL(rxpipe, beacon_buffer_thres_host_int_trig_rx_data);
+	DEBUGFS_FWSTATS_DEL(rxpipe, missed_beacon_host_int_trig_rx_data);
+	DEBUGFS_FWSTATS_DEL(rxpipe, tx_xfr_host_int_trig_rx_data);
+
+	DEBUGFS_DEL(tx_queue_len);
+	DEBUGFS_DEL(retry_count);
+	DEBUGFS_DEL(excessive_retries);
+}
+
+static int wl1271_debugfs_add_files(struct wl1271 *wl)
+{
+	int ret = 0;
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
+	DEBUGFS_ADD(tx_queue_len, wl->debugfs.rootdir);
+	DEBUGFS_ADD(retry_count, wl->debugfs.rootdir);
+	DEBUGFS_ADD(excessive_retries, wl->debugfs.rootdir);
+
+out:
+	if (ret < 0)
+		wl1271_debugfs_delete_files(wl);
+
+	return ret;
+}
+
+void wl1271_debugfs_reset(struct wl1271 *wl)
+{
+	memset(wl->stats.fw_stats, 0, sizeof(*wl->stats.fw_stats));
+	wl->stats.retry_count = 0;
+	wl->stats.excessive_retries = 0;
+}
+
+int wl1271_debugfs_init(struct wl1271 *wl)
+{
+	int ret;
+
+	wl->debugfs.rootdir = debugfs_create_dir(KBUILD_MODNAME, NULL);
+
+	if (IS_ERR(wl->debugfs.rootdir)) {
+		ret = PTR_ERR(wl->debugfs.rootdir);
+		wl->debugfs.rootdir = NULL;
+		goto err;
+	}
+
+	wl->debugfs.fw_statistics = debugfs_create_dir("fw-statistics",
+						       wl->debugfs.rootdir);
+
+	if (IS_ERR(wl->debugfs.fw_statistics)) {
+		ret = PTR_ERR(wl->debugfs.fw_statistics);
+		wl->debugfs.fw_statistics = NULL;
+		goto err_root;
+	}
+
+	wl->stats.fw_stats = kzalloc(sizeof(*wl->stats.fw_stats),
+				      GFP_KERNEL);
+
+	if (!wl->stats.fw_stats) {
+		ret = -ENOMEM;
+		goto err_fw;
+	}
+
+	wl->stats.fw_stats_update = jiffies;
+
+	ret = wl1271_debugfs_add_files(wl);
+
+	if (ret < 0)
+		goto err_file;
+
+	return 0;
+
+err_file:
+	kfree(wl->stats.fw_stats);
+	wl->stats.fw_stats = NULL;
+
+err_fw:
+	debugfs_remove(wl->debugfs.fw_statistics);
+	wl->debugfs.fw_statistics = NULL;
+
+err_root:
+	debugfs_remove(wl->debugfs.rootdir);
+	wl->debugfs.rootdir = NULL;
+
+err:
+	return ret;
+}
+
+void wl1271_debugfs_exit(struct wl1271 *wl)
+{
+	wl1271_debugfs_delete_files(wl);
+
+	kfree(wl->stats.fw_stats);
+	wl->stats.fw_stats = NULL;
+
+	debugfs_remove(wl->debugfs.fw_statistics);
+	wl->debugfs.fw_statistics = NULL;
+
+	debugfs_remove(wl->debugfs.rootdir);
+	wl->debugfs.rootdir = NULL;
+
+}
diff --git a/drivers/net/wireless/wl12xx/wl1271_debugfs.h b/drivers/net/wireless/wl12xx/wl1271_debugfs.h
new file mode 100644
index 0000000..00a45b2
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1271_debugfs.h
@@ -0,0 +1,33 @@
+/*
+ * This file is part of wl1271
+ *
+ * Copyright (C) 2009 Nokia Corporation
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
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
+#ifndef WL1271_DEBUGFS_H
+#define WL1271_DEBUGFS_H
+
+#include "wl1271.h"
+
+int wl1271_debugfs_init(struct wl1271 *wl);
+void wl1271_debugfs_exit(struct wl1271 *wl);
+void wl1271_debugfs_reset(struct wl1271 *wl);
+
+#endif /* WL1271_DEBUGFS_H */
diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
new file mode 100644
index 0000000..f3afd4a
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1271_event.c
@@ -0,0 +1,125 @@
+/*
+ * This file is part of wl1271
+ *
+ * Copyright (C) 2008-2009 Nokia Corporation
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
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
+#include "wl1271.h"
+#include "wl1271_reg.h"
+#include "wl1271_spi.h"
+#include "wl1271_event.h"
+#include "wl1271_ps.h"
+
+static int wl1271_event_scan_complete(struct wl1271 *wl,
+				      struct event_mailbox *mbox)
+{
+	wl1271_debug(DEBUG_EVENT, "status: 0x%x",
+		     mbox->scheduled_scan_status);
+
+	if (wl->scanning) {
+		mutex_unlock(&wl->mutex);
+		ieee80211_scan_completed(wl->hw, false);
+		mutex_lock(&wl->mutex);
+		wl->scanning = false;
+	}
+
+	return 0;
+}
+
+static void wl1271_event_mbox_dump(struct event_mailbox *mbox)
+{
+	wl1271_debug(DEBUG_EVENT, "MBOX DUMP:");
+	wl1271_debug(DEBUG_EVENT, "\tvector: 0x%x", mbox->events_vector);
+	wl1271_debug(DEBUG_EVENT, "\tmask: 0x%x", mbox->events_mask);
+}
+
+static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
+{
+	int ret;
+	u32 vector;
+
+	wl1271_event_mbox_dump(mbox);
+
+	vector = mbox->events_vector & ~(mbox->events_mask);
+	wl1271_debug(DEBUG_EVENT, "vector: 0x%x", vector);
+
+	if (vector & SCAN_COMPLETE_EVENT_ID) {
+		ret = wl1271_event_scan_complete(wl, mbox);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (vector & BSS_LOSE_EVENT_ID) {
+		wl1271_debug(DEBUG_EVENT, "BSS_LOSE_EVENT");
+
+		if (wl->psm_requested && wl->psm) {
+			ret = wl1271_ps_set_mode(wl, STATION_ACTIVE_MODE);
+			if (ret < 0)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
+int wl1271_event_unmask(struct wl1271 *wl)
+{
+	int ret;
+
+	ret = wl1271_acx_event_mbox_mask(wl, ~(wl->event_mask));
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+void wl1271_event_mbox_config(struct wl1271 *wl)
+{
+	wl->mbox_ptr[0] = wl1271_reg_read32(wl, REG_EVENT_MAILBOX_PTR);
+	wl->mbox_ptr[1] = wl->mbox_ptr[0] + sizeof(struct event_mailbox);
+
+	wl1271_debug(DEBUG_EVENT, "MBOX ptrs: 0x%x 0x%x",
+		     wl->mbox_ptr[0], wl->mbox_ptr[1]);
+}
+
+int wl1271_event_handle(struct wl1271 *wl, u8 mbox_num)
+{
+	struct event_mailbox mbox;
+	int ret;
+
+	wl1271_debug(DEBUG_EVENT, "EVENT on mbox %d", mbox_num);
+
+	if (mbox_num > 1)
+		return -EINVAL;
+
+	/* first we read the mbox descriptor */
+	wl1271_spi_mem_read(wl, wl->mbox_ptr[mbox_num], &mbox,
+			    sizeof(struct event_mailbox));
+
+	/* process the descriptor */
+	ret = wl1271_event_process(wl, &mbox);
+	if (ret < 0)
+		return ret;
+
+	/* then we let the firmware know it can go on...*/
+	wl1271_reg_write32(wl, ACX_REG_INTERRUPT_TRIG, INTR_TRIG_EVENT_ACK);
+
+	return 0;
+}
diff --git a/drivers/net/wireless/wl12xx/wl1271_event.h b/drivers/net/wireless/wl12xx/wl1271_event.h
new file mode 100644
index 0000000..2cdce7c
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1271_event.h
@@ -0,0 +1,110 @@
+/*
+ * This file is part of wl1271
+ *
+ * Copyright (C) 1998-2009 Texas Instruments. All rights reserved.
+ * Copyright (C) 2008-2009 Nokia Corporation
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
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
+#ifndef __WL1271_EVENT_H__
+#define __WL1271_EVENT_H__
+
+/*
+ * Mbox events
+ *
+ * The event mechanism is based on a pair of event buffers (buffers A and
+ * B) at fixed locations in the target's memory. The host processes one
+ * buffer while the other buffer continues to collect events. If the host
+ * is not processing events, an interrupt is issued to signal that a buffer
+ * is ready. Once the host is done with processing events from one buffer,
+ * it signals the target (with an ACK interrupt) that the event buffer is
+ * free.
+ */
+
+enum {
+	MEASUREMENT_START_EVENT_ID		 = BIT(8),
+	MEASUREMENT_COMPLETE_EVENT_ID		 = BIT(9),
+	SCAN_COMPLETE_EVENT_ID			 = BIT(10),
+	SCHEDULED_SCAN_COMPLETE_EVENT_ID	 = BIT(11),
+	AP_DISCOVERY_COMPLETE_EVENT_ID		 = BIT(12),
+	PS_REPORT_EVENT_ID			 = BIT(13),
+	PSPOLL_DELIVERY_FAILURE_EVENT_ID	 = BIT(14),
+	DISCONNECT_EVENT_COMPLETE_ID		 = BIT(15),
+	JOIN_EVENT_COMPLETE_ID			 = BIT(16),
+	CHANNEL_SWITCH_COMPLETE_EVENT_ID	 = BIT(17),
+	BSS_LOSE_EVENT_ID			 = BIT(18),
+	REGAINED_BSS_EVENT_ID			 = BIT(19),
+	ROAMING_TRIGGER_MAX_TX_RETRY_EVENT_ID	 = BIT(20),
+	SOFT_GEMINI_SENSE_EVENT_ID		 = BIT(22),
+	SOFT_GEMINI_PREDICTION_EVENT_ID		 = BIT(23),
+	SOFT_GEMINI_AVALANCHE_EVENT_ID		 = BIT(24),
+	PLT_RX_CALIBRATION_COMPLETE_EVENT_ID	 = BIT(25),
+	DBG_EVENT_ID				 = BIT(26),
+	HEALTH_CHECK_REPLY_EVENT_ID		 = BIT(27),
+	PERIODIC_SCAN_COMPLETE_EVENT_ID		 = BIT(28),
+	PERIODIC_SCAN_REPORT_EVENT_ID		 = BIT(29),
+	BA_SESSION_TEAR_DOWN_EVENT_ID		 = BIT(30),
+	EVENT_MBOX_ALL_EVENT_ID			 = 0x7fffffff,
+};
+
+struct event_debug_report {
+	u8 debug_event_id;
+	u8 num_params;
+	u16 pad;
+	u32 report_1;
+	u32 report_2;
+	u32 report_3;
+} __attribute__ ((packed));
+
+#define NUM_OF_RSSI_SNR_TRIGGERS 8
+
+struct event_mailbox {
+	u32 events_vector;
+	u32 events_mask;
+	u32 reserved_1;
+	u32 reserved_2;
+
+	u8 dbg_event_id;
+	u8 num_relevant_params;
+	u16 reserved_3;
+	u32 event_report_p1;
+	u32 event_report_p2;
+	u32 event_report_p3;
+
+	u8 number_of_scan_results;
+	u8 scan_tag;
+	u8 reserved_4[2];
+	u32 compl_scheduled_scan_status;
+
+	u16 scheduled_scan_attended_channels;
+	u8 soft_gemini_sense_info;
+	u8 soft_gemini_protective_info;
+	s8 rssi_snr_trigger_metric[NUM_OF_RSSI_SNR_TRIGGERS];
+	u8 channel_switch_status;
+	u8 scheduled_scan_status;
+	u8 ps_status;
+
+	u8 reserved_5[29];
+} __attribute__ ((packed));
+
+int wl1271_event_unmask(struct wl1271 *wl);
+void wl1271_event_mbox_config(struct wl1271 *wl);
+int wl1271_event_handle(struct wl1271 *wl, u8 mbox);
+
+#endif
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
new file mode 100644
index 0000000..490df21
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -0,0 +1,397 @@
+/*
+ * This file is part of wl1271
+ *
+ * Copyright (C) 2009 Nokia Corporation
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
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
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include "wl1271_init.h"
+#include "wl12xx_80211.h"
+#include "wl1271_acx.h"
+#include "wl1271_cmd.h"
+#include "wl1271_reg.h"
+
+static int wl1271_init_hwenc_config(struct wl1271 *wl)
+{
+	int ret;
+
+	ret = wl1271_acx_feature_cfg(wl);
+	if (ret < 0) {
+		wl1271_warning("couldn't set feature config");
+		return ret;
+	}
+
+	ret = wl1271_cmd_set_default_wep_key(wl, wl->default_key);
+	if (ret < 0) {
+		wl1271_warning("couldn't set default key");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int wl1271_init_templates_config(struct wl1271 *wl)
+{
+	int ret;
+
+	/* send empty templates for fw memory reservation */
+	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_2_4, NULL,
+				      sizeof(struct wl12xx_probe_req_template));
+	if (ret < 0)
+		return ret;
+
+	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_NULL_DATA, NULL,
+				      sizeof(struct wl12xx_null_data_template));
+	if (ret < 0)
+		return ret;
+
+	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_PS_POLL, NULL,
+				      sizeof(struct wl12xx_ps_poll_template));
+	if (ret < 0)
+		return ret;
+
+	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_QOS_NULL_DATA, NULL,
+				      sizeof
+				      (struct wl12xx_qos_null_data_template));
+	if (ret < 0)
+		return ret;
+
+	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_PROBE_RESPONSE, NULL,
+				      sizeof
+				      (struct wl12xx_probe_resp_template));
+	if (ret < 0)
+		return ret;
+
+	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_BEACON, NULL,
+				      sizeof
+				      (struct wl12xx_beacon_template));
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int wl1271_init_rx_config(struct wl1271 *wl, u32 config, u32 filter)
+{
+	int ret;
+
+	ret = wl1271_acx_rx_msdu_life_time(wl, RX_MSDU_LIFETIME_DEF);
+	if (ret < 0)
+		return ret;
+
+	ret = wl1271_acx_rx_config(wl, config, filter);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int wl1271_init_phy_config(struct wl1271 *wl)
+{
+	int ret;
+
+	ret = wl1271_acx_pd_threshold(wl);
+	if (ret < 0)
+		return ret;
+
+	ret = wl1271_acx_slot(wl, DEFAULT_SLOT_TIME);
+	if (ret < 0)
+		return ret;
+
+	ret = wl1271_acx_group_address_tbl(wl);
+	if (ret < 0)
+		return ret;
+
+	ret = wl1271_acx_service_period_timeout(wl);
+	if (ret < 0)
+		return ret;
+
+	ret = wl1271_acx_rts_threshold(wl, RTS_THRESHOLD_DEF);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int wl1271_init_beacon_filter(struct wl1271 *wl)
+{
+	int ret;
+
+	ret = wl1271_acx_beacon_filter_opt(wl);
+	if (ret < 0)
+		return ret;
+
+	ret = wl1271_acx_beacon_filter_table(wl);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int wl1271_init_pta(struct wl1271 *wl)
+{
+	int ret;
+
+	ret = wl1271_acx_sg_enable(wl);
+	if (ret < 0)
+		return ret;
+
+	ret = wl1271_acx_sg_cfg(wl);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int wl1271_init_energy_detection(struct wl1271 *wl)
+{
+	int ret;
+
+	ret = wl1271_acx_cca_threshold(wl);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int wl1271_init_beacon_broadcast(struct wl1271 *wl)
+{
+	int ret;
+
+	ret = wl1271_acx_bcn_dtim_options(wl);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int wl1271_init_general_parms(struct wl1271 *wl)
+{
+	struct wl1271_general_parms *gen_parms;
+	int ret;
+
+	gen_parms = kzalloc(sizeof(*gen_parms), GFP_KERNEL);
+	if (!gen_parms)
+		return -ENOMEM;
+
+	gen_parms->id = TEST_CMD_INI_FILE_GENERAL_PARAM;
+
+	gen_parms->ref_clk = REF_CLK_38_4_E;
+	/* FIXME: magic numbers */
+	gen_parms->settling_time = 5;
+	gen_parms->clk_valid_on_wakeup = 0;
+	gen_parms->dc2dcmode = 0;
+	gen_parms->single_dual_band = 0;
+	gen_parms->tx_bip_fem_autodetect = 1;
+	gen_parms->tx_bip_fem_manufacturer = 1;
+	gen_parms->settings = 1;
+
+	ret = wl1271_cmd_test(wl, gen_parms, sizeof(*gen_parms), 0);
+	if (ret < 0) {
+		wl1271_warning("CMD_INI_FILE_GENERAL_PARAM failed");
+		return ret;
+	}
+
+	kfree(gen_parms);
+	return 0;
+}
+
+static int wl1271_init_radio_parms(struct wl1271 *wl)
+{
+	/*
+	 * FIXME: All these magic numbers should be moved to some place where
+	 * they can be configured (separate file?)
+	 */
+
+	struct wl1271_radio_parms *radio_parms;
+	int ret;
+	u8 compensation[] = { 0xec, 0xf6, 0x00, 0x0c, 0x18, 0xf8, 0xfc, 0x00,
+			      0x08, 0x10, 0xf0, 0xf8, 0x00, 0x0a, 0x14 };
+
+	u8 tx_rate_limits_normal[]   = { 0x1e, 0x1f, 0x22, 0x24, 0x28, 0x29 };
+	u8 tx_rate_limits_degraded[] = { 0x1b, 0x1c, 0x1e, 0x20, 0x24, 0x25 };
+
+	u8 tx_channel_limits_11b[] = { 0x22, 0x50, 0x50, 0x50,
+				       0x50, 0x50, 0x50, 0x50,
+				       0x50, 0x50, 0x22, 0x50,
+				       0x22, 0x50 };
+
+	u8 tx_channel_limits_ofdm[] = { 0x20, 0x50, 0x50, 0x50,
+					0x50, 0x50, 0x50, 0x50,
+					0x50, 0x50, 0x20, 0x50,
+					0x20, 0x50 };
+
+	u8 tx_pdv_rate_offsets[] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
+
+	u8 tx_ibias[] = { 0x1a, 0x1a, 0x1a, 0x1a, 0x1a, 0x27 };
+
+	radio_parms = kzalloc(sizeof(*radio_parms), GFP_KERNEL);
+	if (!radio_parms)
+		return -ENOMEM;
+
+	radio_parms->id = TEST_CMD_INI_FILE_RADIO_PARAM;
+
+	/* Static radio parameters */
+	radio_parms->rx_trace_loss = 10;
+	radio_parms->tx_trace_loss = 10;
+	memcpy(radio_parms->rx_rssi_and_proc_compens, compensation,
+	       sizeof(compensation));
+
+	/* We don't set the 5GHz -- N/A */
+
+	/* Dynamic radio parameters */
+	radio_parms->tx_ref_pd_voltage = cpu_to_le16(0x24e);
+	radio_parms->tx_ref_power = 0x78;
+	radio_parms->tx_offset_db = 0x0;
+
+	memcpy(radio_parms->tx_rate_limits_normal, tx_rate_limits_normal,
+	       sizeof(tx_rate_limits_normal));
+	memcpy(radio_parms->tx_rate_limits_degraded, tx_rate_limits_degraded,
+	       sizeof(tx_rate_limits_degraded));
+
+	memcpy(radio_parms->tx_channel_limits_11b, tx_channel_limits_11b,
+	       sizeof(tx_channel_limits_11b));
+	memcpy(radio_parms->tx_channel_limits_ofdm, tx_channel_limits_ofdm,
+	       sizeof(tx_channel_limits_ofdm));
+	memcpy(radio_parms->tx_pdv_rate_offsets, tx_pdv_rate_offsets,
+	       sizeof(tx_pdv_rate_offsets));
+	memcpy(radio_parms->tx_ibias, tx_ibias,
+	       sizeof(tx_ibias));
+
+	radio_parms->rx_fem_insertion_loss = 0x14;
+
+	ret = wl1271_cmd_test(wl, radio_parms, sizeof(*radio_parms), 0);
+	if (ret < 0)
+		wl1271_warning("CMD_INI_FILE_RADIO_PARAM failed");
+
+	kfree(radio_parms);
+	return ret;
+}
+
+int wl1271_hw_init(struct wl1271 *wl)
+{
+	int ret;
+
+	ret = wl1271_init_general_parms(wl);
+	if (ret < 0)
+		return ret;
+
+	ret = wl1271_init_radio_parms(wl);
+	if (ret < 0)
+		return ret;
+
+	/* Template settings */
+	ret = wl1271_init_templates_config(wl);
+	if (ret < 0)
+		return ret;
+
+	/* Default memory configuration */
+	ret = wl1271_acx_init_mem_config(wl);
+	if (ret < 0)
+		return ret;
+
+	/* RX config */
+	ret = wl1271_init_rx_config(wl,
+				       RX_CFG_PROMISCUOUS | RX_CFG_TSF,
+				       RX_FILTER_OPTION_DEF);
+	/* RX_CONFIG_OPTION_ANY_DST_ANY_BSS,
+	   RX_FILTER_OPTION_FILTER_ALL); */
+	if (ret < 0)
+		goto out_free_memmap;
+
+	/* PHY layer config */
+	ret = wl1271_init_phy_config(wl);
+	if (ret < 0)
+		goto out_free_memmap;
+
+	/* Beacon filtering */
+	ret = wl1271_init_beacon_filter(wl);
+	if (ret < 0)
+		goto out_free_memmap;
+
+	/* Configure TX patch complete interrupt behavior */
+	ret = wl1271_acx_tx_config_options(wl);
+	if (ret < 0)
+		goto out_free_memmap;
+
+	/* RX complete interrupt pacing */
+	ret = wl1271_acx_init_rx_interrupt(wl);
+	if (ret < 0)
+		goto out_free_memmap;
+
+	/* Bluetooth WLAN coexistence */
+	ret = wl1271_init_pta(wl);
+	if (ret < 0)
+		goto out_free_memmap;
+
+	/* Energy detection */
+	ret = wl1271_init_energy_detection(wl);
+	if (ret < 0)
+		goto out_free_memmap;
+
+	/* Beacons and boradcast settings */
+	ret = wl1271_init_beacon_broadcast(wl);
+	if (ret < 0)
+		goto out_free_memmap;
+
+	/* Default fragmentation threshold */
+	ret = wl1271_acx_frag_threshold(wl);
+	if (ret < 0)
+		goto out_free_memmap;
+
+	/* Default TID configuration */
+	ret = wl1271_acx_tid_cfg(wl);
+	if (ret < 0)
+		goto out_free_memmap;
+
+	/* Default AC configuration */
+	ret = wl1271_acx_ac_cfg(wl);
+	if (ret < 0)
+		goto out_free_memmap;
+
+	/* Configure TX rate classes */
+	ret = wl1271_acx_rate_policies(wl);
+	if (ret < 0)
+		goto out_free_memmap;
+
+	/* Enable data path */
+	ret = wl1271_cmd_data_path(wl, wl->channel, 1);
+	if (ret < 0)
+		goto out_free_memmap;
+
+	/* Configure for ELP power saving */
+	ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_ELP);
+	if (ret < 0)
+		goto out_free_memmap;
+
+	/* Configure HW encryption */
+	ret = wl1271_init_hwenc_config(wl);
+	if (ret < 0)
+		goto out_free_memmap;
+
+	return 0;
+
+ out_free_memmap:
+	kfree(wl->target_mem_map);
+
+	return ret;
+}
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.h b/drivers/net/wireless/wl12xx/wl1271_init.h
new file mode 100644
index 0000000..bd8ff0f
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1271_init.h
@@ -0,0 +1,115 @@
+/*
+ * This file is part of wl1271
+ *
+ * Copyright (C) 2009 Nokia Corporation
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
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
+#ifndef __WL1271_INIT_H__
+#define __WL1271_INIT_H__
+
+#include "wl1271.h"
+
+int wl1271_hw_init_power_auth(struct wl1271 *wl);
+int wl1271_hw_init(struct wl1271 *wl);
+
+/* These are not really a TEST_CMD, but the ref driver uses them as such */
+#define TEST_CMD_INI_FILE_RADIO_PARAM   0x19
+#define TEST_CMD_INI_FILE_GENERAL_PARAM 0x1E
+
+struct wl1271_general_parms {
+	u8 id;
+	u8 padding[3];
+
+	u8 ref_clk;
+	u8 settling_time;
+	u8 clk_valid_on_wakeup;
+	u8 dc2dcmode;
+	u8 single_dual_band;
+
+	u8 tx_bip_fem_autodetect;
+	u8 tx_bip_fem_manufacturer;
+	u8 settings;
+} __attribute__ ((packed));
+
+enum ref_clk_enum {
+	REF_CLK_19_2_E,
+	REF_CLK_26_E,
+	REF_CLK_38_4_E,
+	REF_CLK_52_E
+};
+
+#define RSSI_AND_PROCESS_COMPENSATION_SIZE 15
+#define NUMBER_OF_SUB_BANDS_5  7
+#define NUMBER_OF_RATE_GROUPS  6
+#define NUMBER_OF_CHANNELS_2_4 14
+#define NUMBER_OF_CHANNELS_5   35
+
+struct wl1271_radio_parms {
+	u8 id;
+	u8 padding[3];
+
+	/* Static radio parameters */
+	/* 2.4GHz */
+	u8 rx_trace_loss;
+	u8 tx_trace_loss;
+	s8 rx_rssi_and_proc_compens[RSSI_AND_PROCESS_COMPENSATION_SIZE];
+
+	/* 5GHz */
+	u8 rx_trace_loss_5[NUMBER_OF_SUB_BANDS_5];
+	u8 tx_trace_loss_5[NUMBER_OF_SUB_BANDS_5];
+	s8 rx_rssi_and_proc_compens_5[RSSI_AND_PROCESS_COMPENSATION_SIZE];
+
+	/* Dynamic radio parameters */
+	/* 2.4GHz */
+	s16 tx_ref_pd_voltage;
+	s8  tx_ref_power;
+	s8  tx_offset_db;
+
+	s8  tx_rate_limits_normal[NUMBER_OF_RATE_GROUPS];
+	s8  tx_rate_limits_degraded[NUMBER_OF_RATE_GROUPS];
+
+	s8  tx_channel_limits_11b[NUMBER_OF_CHANNELS_2_4];
+	s8  tx_channel_limits_ofdm[NUMBER_OF_CHANNELS_2_4];
+	s8  tx_pdv_rate_offsets[NUMBER_OF_RATE_GROUPS];
+
+	u8  tx_ibias[NUMBER_OF_RATE_GROUPS];
+	u8  rx_fem_insertion_loss;
+
+	u8 padding2;
+
+	/* 5GHz */
+	s16 tx_ref_pd_voltage_5[NUMBER_OF_SUB_BANDS_5];
+	s8  tx_ref_power_5[NUMBER_OF_SUB_BANDS_5];
+	s8  tx_offset_db_5[NUMBER_OF_SUB_BANDS_5];
+
+	s8  tx_rate_limits_normal_5[NUMBER_OF_RATE_GROUPS];
+	s8  tx_rate_limits_degraded_5[NUMBER_OF_RATE_GROUPS];
+
+	s8  tx_channel_limits_ofdm_5[NUMBER_OF_CHANNELS_5];
+	s8  tx_pdv_rate_offsets_5[NUMBER_OF_RATE_GROUPS];
+
+	/* FIXME: this is inconsistent with the types for 2.4GHz */
+	s8  tx_ibias_5[NUMBER_OF_RATE_GROUPS];
+	s8  rx_fem_insertion_loss_5[NUMBER_OF_SUB_BANDS_5];
+
+	u8 padding3[2];
+} __attribute__ ((packed));
+
+#endif
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
new file mode 100644
index 0000000..3bb45ce
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -0,0 +1,1396 @@
+/*
+ * This file is part of wl1271
+ *
+ * Copyright (C) 2008-2009 Nokia Corporation
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
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
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/firmware.h>
+#include <linux/delay.h>
+#include <linux/irq.h>
+#include <linux/spi/spi.h>
+#include <linux/crc32.h>
+#include <linux/etherdevice.h>
+#include <linux/spi/wl12xx.h>
+
+#include "wl1271.h"
+#include "wl12xx_80211.h"
+#include "wl1271_reg.h"
+#include "wl1271_spi.h"
+#include "wl1271_event.h"
+#include "wl1271_tx.h"
+#include "wl1271_rx.h"
+#include "wl1271_ps.h"
+#include "wl1271_init.h"
+#include "wl1271_debugfs.h"
+#include "wl1271_cmd.h"
+#include "wl1271_boot.h"
+
+static int wl1271_plt_init(struct wl1271 *wl)
+{
+	int ret;
+
+	ret = wl1271_acx_init_mem_config(wl);
+	if (ret < 0)
+		return ret;
+
+	ret = wl1271_cmd_data_path(wl, wl->channel, 1);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static void wl1271_disable_interrupts(struct wl1271 *wl)
+{
+	disable_irq(wl->irq);
+}
+
+static void wl1271_power_off(struct wl1271 *wl)
+{
+	wl->set_power(false);
+}
+
+static void wl1271_power_on(struct wl1271 *wl)
+{
+	wl->set_power(true);
+}
+
+static void wl1271_fw_status(struct wl1271 *wl, struct wl1271_fw_status *status)
+{
+	u32 total = 0;
+	int i;
+
+	/*
+	 * FIXME: Reading the FW status directly from the registers seems to
+	 * be the right thing to do, but it doesn't work.  And in the
+	 * reference driver, there is a workaround called
+	 * USE_SDIO_24M_WORKAROUND, which reads the status from memory
+	 * instead, so we do the same here.
+	 */
+
+	wl1271_spi_mem_read(wl, STATUS_MEM_ADDRESS, status, sizeof(*status));
+
+	wl1271_debug(DEBUG_IRQ, "intr: 0x%x (fw_rx_counter = %d, "
+		     "drv_rx_counter = %d, tx_results_counter = %d)",
+		     status->intr,
+		     status->fw_rx_counter,
+		     status->drv_rx_counter,
+		     status->tx_results_counter);
+
+	/* update number of available TX blocks */
+	for (i = 0; i < NUM_TX_QUEUES; i++) {
+		u32 cnt = status->tx_released_blks[i] - wl->tx_blocks_freed[i];
+		wl->tx_blocks_freed[i] = status->tx_released_blks[i];
+		wl->tx_blocks_available += cnt;
+		total += cnt;
+	}
+
+	/* if more blocks are available now, schedule some tx work */
+	if (total && !skb_queue_empty(&wl->tx_queue))
+		schedule_work(&wl->tx_work);
+
+	/* update the host-chipset time offset */
+	wl->time_offset = jiffies_to_usecs(jiffies) - status->fw_localtime;
+}
+
+#define WL1271_IRQ_MAX_LOOPS 10
+static void wl1271_irq_work(struct work_struct *work)
+{
+	u32 intr, ctr = WL1271_IRQ_MAX_LOOPS;
+	int ret;
+	struct wl1271 *wl =
+		container_of(work, struct wl1271, irq_work);
+
+	mutex_lock(&wl->mutex);
+
+	wl1271_debug(DEBUG_IRQ, "IRQ work");
+
+	if (wl->state == WL1271_STATE_OFF)
+		goto out;
+
+	ret = wl1271_ps_elp_wakeup(wl, true);
+	if (ret < 0)
+		goto out;
+
+	wl1271_reg_write32(wl, ACX_REG_INTERRUPT_MASK, WL1271_ACX_INTR_ALL);
+
+	intr = wl1271_reg_read32(wl, ACX_REG_INTERRUPT_CLEAR);
+	if (!intr) {
+		wl1271_debug(DEBUG_IRQ, "Zero interrupt received.");
+		goto out_sleep;
+	}
+
+	intr &= WL1271_INTR_MASK;
+
+	do {
+		wl1271_fw_status(wl, wl->fw_status);
+
+
+		if (intr & (WL1271_ACX_INTR_EVENT_A |
+			    WL1271_ACX_INTR_EVENT_B)) {
+			wl1271_debug(DEBUG_IRQ,
+				     "WL1271_ACX_INTR_EVENT (0x%x)", intr);
+			if (intr & WL1271_ACX_INTR_EVENT_A)
+				wl1271_event_handle(wl, 0);
+			else
+				wl1271_event_handle(wl, 1);
+		}
+
+		if (intr & WL1271_ACX_INTR_INIT_COMPLETE)
+			wl1271_debug(DEBUG_IRQ,
+				     "WL1271_ACX_INTR_INIT_COMPLETE");
+
+		if (intr & WL1271_ACX_INTR_HW_AVAILABLE)
+			wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_HW_AVAILABLE");
+
+		if (intr & WL1271_ACX_INTR_DATA) {
+			u8 tx_res_cnt = wl->fw_status->tx_results_counter -
+				wl->tx_results_count;
+
+			wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_DATA");
+
+			/* check for tx results */
+			if (tx_res_cnt)
+				wl1271_tx_complete(wl, tx_res_cnt);
+
+			wl1271_rx(wl, wl->fw_status);
+		}
+
+		intr = wl1271_reg_read32(wl, ACX_REG_INTERRUPT_CLEAR);
+		intr &= WL1271_INTR_MASK;
+	} while (intr && --ctr);
+
+out_sleep:
+	wl1271_reg_write32(wl, ACX_REG_INTERRUPT_MASK, ~(WL1271_INTR_MASK));
+	wl1271_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
+}
+
+static irqreturn_t wl1271_irq(int irq, void *cookie)
+{
+	struct wl1271 *wl;
+	unsigned long flags;
+
+	wl1271_debug(DEBUG_IRQ, "IRQ");
+
+	wl = cookie;
+
+	/* complete the ELP completion */
+	spin_lock_irqsave(&wl->wl_lock, flags);
+	if (wl->elp_compl) {
+		complete(wl->elp_compl);
+		wl->elp_compl = NULL;
+	}
+
+	schedule_work(&wl->irq_work);
+	spin_unlock_irqrestore(&wl->wl_lock, flags);
+
+	return IRQ_HANDLED;
+}
+
+static int wl1271_fetch_firmware(struct wl1271 *wl)
+{
+	const struct firmware *fw;
+	int ret;
+
+	ret = request_firmware(&fw, WL1271_FW_NAME, &wl->spi->dev);
+
+	if (ret < 0) {
+		wl1271_error("could not get firmware: %d", ret);
+		return ret;
+	}
+
+	if (fw->size % 4) {
+		wl1271_error("firmware size is not multiple of 32 bits: %zu",
+			     fw->size);
+		ret = -EILSEQ;
+		goto out;
+	}
+
+	wl->fw_len = fw->size;
+	wl->fw = kmalloc(wl->fw_len, GFP_KERNEL);
+
+	if (!wl->fw) {
+		wl1271_error("could not allocate memory for the firmware");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	memcpy(wl->fw, fw->data, wl->fw_len);
+
+	ret = 0;
+
+out:
+	release_firmware(fw);
+
+	return ret;
+}
+
+static int wl1271_fetch_nvs(struct wl1271 *wl)
+{
+	const struct firmware *fw;
+	int ret;
+
+	ret = request_firmware(&fw, WL1271_NVS_NAME, &wl->spi->dev);
+
+	if (ret < 0) {
+		wl1271_error("could not get nvs file: %d", ret);
+		return ret;
+	}
+
+	if (fw->size % 4) {
+		wl1271_error("nvs size is not multiple of 32 bits: %zu",
+			     fw->size);
+		ret = -EILSEQ;
+		goto out;
+	}
+
+	wl->nvs_len = fw->size;
+	wl->nvs = kmalloc(wl->nvs_len, GFP_KERNEL);
+
+	if (!wl->nvs) {
+		wl1271_error("could not allocate memory for the nvs file");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	memcpy(wl->nvs, fw->data, wl->nvs_len);
+
+	ret = 0;
+
+out:
+	release_firmware(fw);
+
+	return ret;
+}
+
+static void wl1271_fw_wakeup(struct wl1271 *wl)
+{
+	u32 elp_reg;
+
+	elp_reg = ELPCTRL_WAKE_UP;
+	wl1271_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, elp_reg);
+}
+
+static int wl1271_setup(struct wl1271 *wl)
+{
+	wl->fw_status = kmalloc(sizeof(*wl->fw_status), GFP_KERNEL);
+	if (!wl->fw_status)
+		return -ENOMEM;
+
+	wl->tx_res_if = kmalloc(sizeof(*wl->tx_res_if), GFP_KERNEL);
+	if (!wl->tx_res_if) {
+		kfree(wl->fw_status);
+		return -ENOMEM;
+	}
+
+	INIT_WORK(&wl->irq_work, wl1271_irq_work);
+	INIT_WORK(&wl->tx_work, wl1271_tx_work);
+	return 0;
+}
+
+static int wl1271_chip_wakeup(struct wl1271 *wl)
+{
+	int ret = 0;
+
+	wl1271_power_on(wl);
+	msleep(WL1271_POWER_ON_SLEEP);
+	wl1271_spi_reset(wl);
+	wl1271_spi_init(wl);
+
+	/* We don't need a real memory partition here, because we only want
+	 * to use the registers at this point. */
+	wl1271_set_partition(wl,
+			     0x00000000,
+			     0x00000000,
+			     REGISTERS_BASE,
+			     REGISTERS_DOWN_SIZE);
+
+	/* ELP module wake up */
+	wl1271_fw_wakeup(wl);
+
+	/* whal_FwCtrl_BootSm() */
+
+	/* 0. read chip id from CHIP_ID */
+	wl->chip.id = wl1271_reg_read32(wl, CHIP_ID_B);
+
+	/* 1. check if chip id is valid */
+
+	switch (wl->chip.id) {
+	case CHIP_ID_1271_PG10:
+		wl1271_warning("chip id 0x%x (1271 PG10) support is obsolete",
+			       wl->chip.id);
+
+		ret = wl1271_setup(wl);
+		if (ret < 0)
+			goto out;
+		break;
+	case CHIP_ID_1271_PG20:
+		wl1271_debug(DEBUG_BOOT, "chip id 0x%x (1271 PG20)",
+			     wl->chip.id);
+
+		ret = wl1271_setup(wl);
+		if (ret < 0)
+			goto out;
+		break;
+	default:
+		wl1271_error("unsupported chip id: 0x%x", wl->chip.id);
+		ret = -ENODEV;
+		goto out;
+	}
+
+	if (wl->fw == NULL) {
+		ret = wl1271_fetch_firmware(wl);
+		if (ret < 0)
+			goto out;
+	}
+
+	/* No NVS from netlink, try to get it from the filesystem */
+	if (wl->nvs == NULL) {
+		ret = wl1271_fetch_nvs(wl);
+		if (ret < 0)
+			goto out;
+	}
+
+out:
+	return ret;
+}
+
+static void wl1271_filter_work(struct work_struct *work)
+{
+	struct wl1271 *wl =
+		container_of(work, struct wl1271, filter_work);
+	int ret;
+
+	mutex_lock(&wl->mutex);
+
+	if (wl->state == WL1271_STATE_OFF)
+		goto out;
+
+	ret = wl1271_ps_elp_wakeup(wl, false);
+	if (ret < 0)
+		goto out;
+
+	/* FIXME: replace the magic numbers with proper definitions */
+	ret = wl1271_cmd_join(wl, wl->bss_type, 1, 100, 0);
+	if (ret < 0)
+		goto out_sleep;
+
+out_sleep:
+	wl1271_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
+}
+
+int wl1271_plt_start(struct wl1271 *wl)
+{
+	int ret;
+
+	mutex_lock(&wl->mutex);
+
+	wl1271_notice("power up");
+
+	if (wl->state != WL1271_STATE_OFF) {
+		wl1271_error("cannot go into PLT state because not "
+			     "in off state: %d", wl->state);
+		ret = -EBUSY;
+		goto out;
+	}
+
+	wl->state = WL1271_STATE_PLT;
+
+	ret = wl1271_chip_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	ret = wl1271_boot(wl);
+	if (ret < 0)
+		goto out;
+
+	wl1271_notice("firmware booted in PLT mode (%s)", wl->chip.fw_ver);
+
+	ret = wl1271_plt_init(wl);
+	if (ret < 0)
+		goto out;
+
+out:
+	mutex_unlock(&wl->mutex);
+
+	return ret;
+}
+
+int wl1271_plt_stop(struct wl1271 *wl)
+{
+	int ret = 0;
+
+	mutex_lock(&wl->mutex);
+
+	wl1271_notice("power down");
+
+	if (wl->state != WL1271_STATE_PLT) {
+		wl1271_error("cannot power down because not in PLT "
+			     "state: %d", wl->state);
+		ret = -EBUSY;
+		goto out;
+	}
+
+	wl1271_disable_interrupts(wl);
+	wl1271_power_off(wl);
+
+	wl->state = WL1271_STATE_OFF;
+
+out:
+	mutex_unlock(&wl->mutex);
+
+	return ret;
+}
+
+
+static int wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+{
+	struct wl1271 *wl = hw->priv;
+
+	skb_queue_tail(&wl->tx_queue, skb);
+
+	/*
+	 * The chip specific setup must run before the first TX packet -
+	 * before that, the tx_work will not be initialized!
+	 */
+
+	schedule_work(&wl->tx_work);
+
+	/*
+	 * The workqueue is slow to process the tx_queue and we need stop
+	 * the queue here, otherwise the queue will get too long.
+	 */
+	if (skb_queue_len(&wl->tx_queue) >= WL1271_TX_QUEUE_MAX_LENGTH) {
+		ieee80211_stop_queues(wl->hw);
+
+		/*
+		 * FIXME: this is racy, the variable is not properly
+		 * protected. Maybe fix this by removing the stupid
+		 * variable altogether and checking the real queue state?
+		 */
+		wl->tx_queue_stopped = true;
+	}
+
+	return NETDEV_TX_OK;
+}
+
+static int wl1271_op_start(struct ieee80211_hw *hw)
+{
+	struct wl1271 *wl = hw->priv;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_MAC80211, "mac80211 start");
+
+	mutex_lock(&wl->mutex);
+
+	if (wl->state != WL1271_STATE_OFF) {
+		wl1271_error("cannot start because not in off state: %d",
+			     wl->state);
+		ret = -EBUSY;
+		goto out;
+	}
+
+	ret = wl1271_chip_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	ret = wl1271_boot(wl);
+	if (ret < 0)
+		goto out;
+
+	ret = wl1271_hw_init(wl);
+	if (ret < 0)
+		goto out;
+
+	wl->state = WL1271_STATE_ON;
+
+	wl1271_info("firmware booted (%s)", wl->chip.fw_ver);
+
+out:
+	if (ret < 0)
+		wl1271_power_off(wl);
+
+	mutex_unlock(&wl->mutex);
+
+	return ret;
+}
+
+static void wl1271_op_stop(struct ieee80211_hw *hw)
+{
+	struct wl1271 *wl = hw->priv;
+	int i;
+
+	wl1271_info("down");
+
+	wl1271_debug(DEBUG_MAC80211, "mac80211 stop");
+
+	mutex_lock(&wl->mutex);
+
+	WARN_ON(wl->state != WL1271_STATE_ON);
+
+	if (wl->scanning) {
+		mutex_unlock(&wl->mutex);
+		ieee80211_scan_completed(wl->hw, true);
+		mutex_lock(&wl->mutex);
+		wl->scanning = false;
+	}
+
+	wl->state = WL1271_STATE_OFF;
+
+	wl1271_disable_interrupts(wl);
+
+	mutex_unlock(&wl->mutex);
+
+	cancel_work_sync(&wl->irq_work);
+	cancel_work_sync(&wl->tx_work);
+	cancel_work_sync(&wl->filter_work);
+
+	mutex_lock(&wl->mutex);
+
+	/* let's notify MAC80211 about the remaining pending TX frames */
+	wl1271_tx_flush(wl);
+	wl1271_power_off(wl);
+
+	memset(wl->bssid, 0, ETH_ALEN);
+	memset(wl->ssid, 0, IW_ESSID_MAX_SIZE + 1);
+	wl->ssid_len = 0;
+	wl->listen_int = 1;
+	wl->bss_type = MAX_BSS_TYPE;
+
+	wl->rx_counter = 0;
+	wl->elp = false;
+	wl->psm = 0;
+	wl->tx_queue_stopped = false;
+	wl->power_level = WL1271_DEFAULT_POWER_LEVEL;
+	wl->tx_blocks_available = 0;
+	wl->tx_results_count = 0;
+	wl->tx_packets_count = 0;
+	wl->time_offset = 0;
+	wl->session_counter = 0;
+	for (i = 0; i < NUM_TX_QUEUES; i++)
+		wl->tx_blocks_freed[i] = 0;
+
+	wl1271_debugfs_reset(wl);
+	mutex_unlock(&wl->mutex);
+}
+
+static int wl1271_op_add_interface(struct ieee80211_hw *hw,
+				   struct ieee80211_if_init_conf *conf)
+{
+	struct wl1271 *wl = hw->priv;
+	DECLARE_MAC_BUF(mac);
+	int ret = 0;
+
+	wl1271_debug(DEBUG_MAC80211, "mac80211 add interface type %d mac %s",
+		     conf->type, print_mac(mac, conf->mac_addr));
+
+	mutex_lock(&wl->mutex);
+
+	switch (conf->type) {
+	case NL80211_IFTYPE_STATION:
+		wl->bss_type = BSS_TYPE_STA_BSS;
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		wl->bss_type = BSS_TYPE_IBSS;
+		break;
+	default:
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	/* FIXME: what if conf->mac_addr changes? */
+
+out:
+	mutex_unlock(&wl->mutex);
+	return ret;
+}
+
+static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
+					 struct ieee80211_if_init_conf *conf)
+{
+	wl1271_debug(DEBUG_MAC80211, "mac80211 remove interface");
+}
+
+#if 0
+static int wl1271_op_config_interface(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif,
+				      struct ieee80211_if_conf *conf)
+{
+	struct wl1271 *wl = hw->priv;
+	struct sk_buff *beacon;
+	DECLARE_MAC_BUF(mac);
+	int ret;
+
+	wl1271_debug(DEBUG_MAC80211, "mac80211 config_interface bssid %s",
+		     print_mac(mac, conf->bssid));
+	wl1271_dump_ascii(DEBUG_MAC80211, "ssid: ", conf->ssid,
+			  conf->ssid_len);
+
+	mutex_lock(&wl->mutex);
+
+	ret = wl1271_ps_elp_wakeup(wl, false);
+	if (ret < 0)
+		goto out;
+
+	memcpy(wl->bssid, conf->bssid, ETH_ALEN);
+
+	ret = wl1271_cmd_build_null_data(wl);
+	if (ret < 0)
+		goto out_sleep;
+
+	wl->ssid_len = conf->ssid_len;
+	if (wl->ssid_len)
+		memcpy(wl->ssid, conf->ssid, wl->ssid_len);
+
+	if (wl->bss_type != BSS_TYPE_IBSS) {
+		/* FIXME: replace the magic numbers with proper definitions */
+		ret = wl1271_cmd_join(wl, wl->bss_type, 5, 100, 1);
+		if (ret < 0)
+			goto out_sleep;
+	}
+
+	if (conf->changed & IEEE80211_IFCC_BEACON) {
+		beacon = ieee80211_beacon_get(hw, vif);
+		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_BEACON,
+					      beacon->data, beacon->len);
+
+		if (ret < 0) {
+			dev_kfree_skb(beacon);
+			goto out_sleep;
+		}
+
+		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_PROBE_RESPONSE,
+					      beacon->data, beacon->len);
+
+		dev_kfree_skb(beacon);
+
+		if (ret < 0)
+			goto out_sleep;
+
+		/* FIXME: replace the magic numbers with proper definitions */
+		ret = wl1271_cmd_join(wl, wl->bss_type, 1, 100, 0);
+
+		if (ret < 0)
+			goto out_sleep;
+	}
+
+out_sleep:
+	wl1271_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
+
+	return ret;
+}
+#endif
+
+static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
+{
+	struct wl1271 *wl = hw->priv;
+	struct ieee80211_conf *conf = &hw->conf;
+	int channel, ret = 0;
+
+	channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
+
+	wl1271_debug(DEBUG_MAC80211, "mac80211 config ch %d psm %s power %d",
+		     channel,
+		     conf->flags & IEEE80211_CONF_PS ? "on" : "off",
+		     conf->power_level);
+
+	mutex_lock(&wl->mutex);
+
+	ret = wl1271_ps_elp_wakeup(wl, false);
+	if (ret < 0)
+		goto out;
+
+	if (channel != wl->channel) {
+		u8 old_channel = wl->channel;
+		wl->channel = channel;
+
+		/* FIXME: use beacon interval provided by mac80211 */
+		ret = wl1271_cmd_join(wl, wl->bss_type, 1, 100, 0);
+		if (ret < 0) {
+			wl->channel = old_channel;
+			goto out_sleep;
+		}
+	}
+
+	ret = wl1271_cmd_build_null_data(wl);
+	if (ret < 0)
+		goto out_sleep;
+
+	if (conf->flags & IEEE80211_CONF_PS && !wl->psm_requested) {
+		wl1271_info("psm enabled");
+
+		wl->psm_requested = true;
+
+		/*
+		 * We enter PSM only if we're already associated.
+		 * If we're not, we'll enter it when joining an SSID,
+		 * through the bss_info_changed() hook.
+		 */
+		ret = wl1271_ps_set_mode(wl, STATION_POWER_SAVE_MODE);
+	} else if (!(conf->flags & IEEE80211_CONF_PS) &&
+		   wl->psm_requested) {
+		wl1271_info("psm disabled");
+
+		wl->psm_requested = false;
+
+		if (wl->psm)
+			ret = wl1271_ps_set_mode(wl, STATION_ACTIVE_MODE);
+	}
+
+	if (conf->power_level != wl->power_level) {
+		ret = wl1271_acx_tx_power(wl, conf->power_level);
+		if (ret < 0)
+			goto out;
+
+		wl->power_level = conf->power_level;
+	}
+
+out_sleep:
+	wl1271_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
+
+	return ret;
+}
+
+#define WL1271_SUPPORTED_FILTERS (FIF_PROMISC_IN_BSS | \
+				  FIF_ALLMULTI | \
+				  FIF_FCSFAIL | \
+				  FIF_BCN_PRBRESP_PROMISC | \
+				  FIF_CONTROL | \
+				  FIF_OTHER_BSS)
+
+static void wl1271_op_configure_filter(struct ieee80211_hw *hw,
+				       unsigned int changed,
+				       unsigned int *total,
+				       int mc_count,
+				       struct dev_addr_list *mc_list)
+{
+	struct wl1271 *wl = hw->priv;
+
+	wl1271_debug(DEBUG_MAC80211, "mac80211 configure filter");
+
+	*total &= WL1271_SUPPORTED_FILTERS;
+	changed &= WL1271_SUPPORTED_FILTERS;
+
+	if (changed == 0)
+		return;
+
+	/* FIXME: wl->rx_config and wl->rx_filter are not protected */
+	wl->rx_config = WL1271_DEFAULT_RX_CONFIG;
+	wl->rx_filter = WL1271_DEFAULT_RX_FILTER;
+
+	/*
+	 * FIXME: workqueues need to be properly cancelled on stop(), for
+	 * now let's just disable changing the filter settings. They will
+	 * be updated any on config().
+	 */
+	/* schedule_work(&wl->filter_work); */
+}
+
+static int wl1271_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
+			     struct ieee80211_vif *vif,
+			     struct ieee80211_sta *sta,
+			     struct ieee80211_key_conf *key_conf)
+{
+	struct wl1271 *wl = hw->priv;
+	const u8 *addr;
+	int ret;
+	u8 key_type;
+
+	static const u8 bcast_addr[ETH_ALEN] =
+		{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
+
+	wl1271_debug(DEBUG_MAC80211, "mac80211 set key");
+
+	addr = sta ? sta->addr : bcast_addr;
+
+	wl1271_debug(DEBUG_CRYPT, "CMD: 0x%x", cmd);
+	wl1271_dump(DEBUG_CRYPT, "ADDR: ", addr, ETH_ALEN);
+	wl1271_debug(DEBUG_CRYPT, "Key: algo:0x%x, id:%d, len:%d flags 0x%x",
+		     key_conf->alg, key_conf->keyidx,
+		     key_conf->keylen, key_conf->flags);
+	wl1271_dump(DEBUG_CRYPT, "KEY: ", key_conf->key, key_conf->keylen);
+
+	if (is_zero_ether_addr(addr)) {
+		/* We dont support TX only encryption */
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	mutex_lock(&wl->mutex);
+
+	ret = wl1271_ps_elp_wakeup(wl, false);
+	if (ret < 0)
+		goto out_unlock;
+
+	switch (key_conf->alg) {
+	case ALG_WEP:
+		key_type = KEY_WEP;
+
+		key_conf->hw_key_idx = key_conf->keyidx;
+		break;
+	case ALG_TKIP:
+		key_type = KEY_TKIP;
+
+		key_conf->hw_key_idx = key_conf->keyidx;
+		break;
+	case ALG_CCMP:
+		key_type = KEY_AES;
+
+		key_conf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
+		break;
+	default:
+		wl1271_error("Unknown key algo 0x%x", key_conf->alg);
+
+		ret = -EOPNOTSUPP;
+		goto out_sleep;
+	}
+
+	switch (cmd) {
+	case SET_KEY:
+		ret = wl1271_cmd_set_key(wl, KEY_ADD_OR_REPLACE,
+					 key_conf->keyidx, key_type,
+					 key_conf->keylen, key_conf->key,
+					 addr);
+		if (ret < 0) {
+			wl1271_error("Could not add or replace key");
+			goto out_sleep;
+		}
+		break;
+
+	case DISABLE_KEY:
+		ret = wl1271_cmd_set_key(wl, KEY_REMOVE,
+					 key_conf->keyidx, key_type,
+					 key_conf->keylen, key_conf->key,
+					 addr);
+		if (ret < 0) {
+			wl1271_error("Could not remove key");
+			goto out_sleep;
+		}
+		break;
+
+	default:
+		wl1271_error("Unsupported key cmd 0x%x", cmd);
+		ret = -EOPNOTSUPP;
+		goto out_sleep;
+
+		break;
+	}
+
+out_sleep:
+	wl1271_ps_elp_sleep(wl);
+
+out_unlock:
+	mutex_unlock(&wl->mutex);
+
+out:
+	return ret;
+}
+
+static int wl1271_op_hw_scan(struct ieee80211_hw *hw,
+			     struct cfg80211_scan_request *req)
+{
+	struct wl1271 *wl = hw->priv;
+	int ret;
+	u8 *ssid = NULL;
+	size_t ssid_len = 0;
+
+	wl1271_debug(DEBUG_MAC80211, "mac80211 hw scan");
+
+	if (req->n_ssids) {
+		ssid = req->ssids[0].ssid;
+		ssid_len = req->ssids[0].ssid_len;
+	}
+
+	mutex_lock(&wl->mutex);
+
+	ret = wl1271_ps_elp_wakeup(wl, false);
+	if (ret < 0)
+		goto out;
+
+	ret = wl1271_cmd_scan(hw->priv, ssid, ssid_len, 1, 0, 13, 3);
+
+	wl1271_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
+
+	return ret;
+}
+
+static int wl1271_op_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
+{
+	struct wl1271 *wl = hw->priv;
+	int ret;
+
+	mutex_lock(&wl->mutex);
+
+	ret = wl1271_ps_elp_wakeup(wl, false);
+	if (ret < 0)
+		goto out;
+
+	ret = wl1271_acx_rts_threshold(wl, (u16) value);
+	if (ret < 0)
+		wl1271_warning("wl1271_op_set_rts_threshold failed: %d", ret);
+
+	wl1271_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
+
+	return ret;
+}
+
+static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif,
+				       struct ieee80211_bss_conf *bss_conf,
+				       u32 changed)
+{
+	enum wl1271_cmd_ps_mode mode;
+	struct wl1271 *wl = hw->priv;
+	int ret;
+
+	wl1271_debug(DEBUG_MAC80211, "mac80211 bss info changed");
+
+	mutex_lock(&wl->mutex);
+
+	ret = wl1271_ps_elp_wakeup(wl, false);
+	if (ret < 0)
+		goto out;
+
+	if (changed & BSS_CHANGED_ASSOC) {
+		if (bss_conf->assoc) {
+			wl->aid = bss_conf->aid;
+
+			ret = wl1271_cmd_build_ps_poll(wl, wl->aid);
+			if (ret < 0)
+				goto out_sleep;
+
+			ret = wl1271_acx_aid(wl, wl->aid);
+			if (ret < 0)
+				goto out_sleep;
+
+			/* If we want to go in PSM but we're not there yet */
+			if (wl->psm_requested && !wl->psm) {
+				mode = STATION_POWER_SAVE_MODE;
+				ret = wl1271_ps_set_mode(wl, mode);
+				if (ret < 0)
+					goto out_sleep;
+			}
+		}
+	}
+	if (changed & BSS_CHANGED_ERP_SLOT) {
+		if (bss_conf->use_short_slot)
+			ret = wl1271_acx_slot(wl, SLOT_TIME_SHORT);
+		else
+			ret = wl1271_acx_slot(wl, SLOT_TIME_LONG);
+		if (ret < 0) {
+			wl1271_warning("Set slot time failed %d", ret);
+			goto out_sleep;
+		}
+	}
+
+	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
+		if (bss_conf->use_short_preamble)
+			wl1271_acx_set_preamble(wl, ACX_PREAMBLE_SHORT);
+		else
+			wl1271_acx_set_preamble(wl, ACX_PREAMBLE_LONG);
+	}
+
+	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
+		if (bss_conf->use_cts_prot)
+			ret = wl1271_acx_cts_protect(wl, CTSPROTECT_ENABLE);
+		else
+			ret = wl1271_acx_cts_protect(wl, CTSPROTECT_DISABLE);
+		if (ret < 0) {
+			wl1271_warning("Set ctsprotect failed %d", ret);
+			goto out_sleep;
+		}
+	}
+
+out_sleep:
+	wl1271_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
+}
+
+
+/* can't be const, mac80211 writes to this */
+static struct ieee80211_rate wl1271_rates[] = {
+	{ .bitrate = 10,
+	  .hw_value = 0x1,
+	  .hw_value_short = 0x1, },
+	{ .bitrate = 20,
+	  .hw_value = 0x2,
+	  .hw_value_short = 0x2,
+	  .flags = IEEE80211_RATE_SHORT_PREAMBLE },
+	{ .bitrate = 55,
+	  .hw_value = 0x4,
+	  .hw_value_short = 0x4,
+	  .flags = IEEE80211_RATE_SHORT_PREAMBLE },
+	{ .bitrate = 110,
+	  .hw_value = 0x20,
+	  .hw_value_short = 0x20,
+	  .flags = IEEE80211_RATE_SHORT_PREAMBLE },
+	{ .bitrate = 60,
+	  .hw_value = 0x8,
+	  .hw_value_short = 0x8, },
+	{ .bitrate = 90,
+	  .hw_value = 0x10,
+	  .hw_value_short = 0x10, },
+	{ .bitrate = 120,
+	  .hw_value = 0x40,
+	  .hw_value_short = 0x40, },
+	{ .bitrate = 180,
+	  .hw_value = 0x80,
+	  .hw_value_short = 0x80, },
+	{ .bitrate = 240,
+	  .hw_value = 0x200,
+	  .hw_value_short = 0x200, },
+	{ .bitrate = 360,
+	 .hw_value = 0x400,
+	 .hw_value_short = 0x400, },
+	{ .bitrate = 480,
+	  .hw_value = 0x800,
+	  .hw_value_short = 0x800, },
+	{ .bitrate = 540,
+	  .hw_value = 0x1000,
+	  .hw_value_short = 0x1000, },
+};
+
+/* can't be const, mac80211 writes to this */
+static struct ieee80211_channel wl1271_channels[] = {
+	{ .hw_value = 1, .center_freq = 2412},
+	{ .hw_value = 2, .center_freq = 2417},
+	{ .hw_value = 3, .center_freq = 2422},
+	{ .hw_value = 4, .center_freq = 2427},
+	{ .hw_value = 5, .center_freq = 2432},
+	{ .hw_value = 6, .center_freq = 2437},
+	{ .hw_value = 7, .center_freq = 2442},
+	{ .hw_value = 8, .center_freq = 2447},
+	{ .hw_value = 9, .center_freq = 2452},
+	{ .hw_value = 10, .center_freq = 2457},
+	{ .hw_value = 11, .center_freq = 2462},
+	{ .hw_value = 12, .center_freq = 2467},
+	{ .hw_value = 13, .center_freq = 2472},
+};
+
+/* can't be const, mac80211 writes to this */
+static struct ieee80211_supported_band wl1271_band_2ghz = {
+	.channels = wl1271_channels,
+	.n_channels = ARRAY_SIZE(wl1271_channels),
+	.bitrates = wl1271_rates,
+	.n_bitrates = ARRAY_SIZE(wl1271_rates),
+};
+
+static const struct ieee80211_ops wl1271_ops = {
+	.start = wl1271_op_start,
+	.stop = wl1271_op_stop,
+	.add_interface = wl1271_op_add_interface,
+	.remove_interface = wl1271_op_remove_interface,
+	.config = wl1271_op_config,
+/* 	.config_interface = wl1271_op_config_interface, */
+	.configure_filter = wl1271_op_configure_filter,
+	.tx = wl1271_op_tx,
+	.set_key = wl1271_op_set_key,
+	.hw_scan = wl1271_op_hw_scan,
+	.bss_info_changed = wl1271_op_bss_info_changed,
+	.set_rts_threshold = wl1271_op_set_rts_threshold,
+};
+
+static int wl1271_register_hw(struct wl1271 *wl)
+{
+	int ret;
+
+	if (wl->mac80211_registered)
+		return 0;
+
+	SET_IEEE80211_PERM_ADDR(wl->hw, wl->mac_addr);
+
+	ret = ieee80211_register_hw(wl->hw);
+	if (ret < 0) {
+		wl1271_error("unable to register mac80211 hw: %d", ret);
+		return ret;
+	}
+
+	wl->mac80211_registered = true;
+
+	wl1271_notice("loaded");
+
+	return 0;
+}
+
+static int wl1271_init_ieee80211(struct wl1271 *wl)
+{
+	/*
+	 * The tx descriptor buffer and the TKIP space.
+	 *
+	 * FIXME: add correct 1271 descriptor size
+	 */
+	wl->hw->extra_tx_headroom = WL1271_TKIP_IV_SPACE;
+
+	/* unit us */
+	/* FIXME: find a proper value */
+	wl->hw->channel_change_time = 10000;
+
+	wl->hw->flags = IEEE80211_HW_SIGNAL_DBM |
+		IEEE80211_HW_NOISE_DBM;
+
+	wl->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
+	wl->hw->wiphy->max_scan_ssids = 1;
+	wl->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &wl1271_band_2ghz;
+
+	SET_IEEE80211_DEV(wl->hw, &wl->spi->dev);
+
+	return 0;
+}
+
+static void wl1271_device_release(struct device *dev)
+{
+
+}
+
+static struct platform_device wl1271_device = {
+	.name           = "wl1271",
+	.id             = -1,
+
+	/* device model insists to have a release function */
+	.dev            = {
+		.release = wl1271_device_release,
+	},
+};
+
+#define WL1271_DEFAULT_CHANNEL 0
+static int __devinit wl1271_probe(struct spi_device *spi)
+{
+	struct wl12xx_platform_data *pdata;
+	struct ieee80211_hw *hw;
+	struct wl1271 *wl;
+	int ret, i;
+	static const u8 nokia_oui[3] = {0x00, 0x1f, 0xdf};
+
+	pdata = spi->dev.platform_data;
+	if (!pdata) {
+		wl1271_error("no platform data");
+		return -ENODEV;
+	}
+
+	hw = ieee80211_alloc_hw(sizeof(*wl), &wl1271_ops);
+	if (!hw) {
+		wl1271_error("could not alloc ieee80211_hw");
+		return -ENOMEM;
+	}
+
+	wl = hw->priv;
+	memset(wl, 0, sizeof(*wl));
+
+	wl->hw = hw;
+	dev_set_drvdata(&spi->dev, wl);
+	wl->spi = spi;
+
+	skb_queue_head_init(&wl->tx_queue);
+
+	INIT_WORK(&wl->filter_work, wl1271_filter_work);
+	wl->channel = WL1271_DEFAULT_CHANNEL;
+	wl->scanning = false;
+	wl->default_key = 0;
+	wl->listen_int = 1;
+	wl->rx_counter = 0;
+	wl->rx_config = WL1271_DEFAULT_RX_CONFIG;
+	wl->rx_filter = WL1271_DEFAULT_RX_FILTER;
+	wl->elp = false;
+	wl->psm = 0;
+	wl->psm_requested = false;
+	wl->tx_queue_stopped = false;
+	wl->power_level = WL1271_DEFAULT_POWER_LEVEL;
+
+	/* We use the default power on sleep time until we know which chip
+	 * we're using */
+	for (i = 0; i < FW_TX_CMPLT_BLOCK_SIZE; i++)
+		wl->tx_frames[i] = NULL;
+
+	spin_lock_init(&wl->wl_lock);
+
+	/*
+	 * In case our MAC address is not correctly set,
+	 * we use a random but Nokia MAC.
+	 */
+	memcpy(wl->mac_addr, nokia_oui, 3);
+	get_random_bytes(wl->mac_addr + 3, 3);
+
+	wl->state = WL1271_STATE_OFF;
+	mutex_init(&wl->mutex);
+
+	wl->rx_descriptor = kmalloc(sizeof(*wl->rx_descriptor), GFP_KERNEL);
+	if (!wl->rx_descriptor) {
+		wl1271_error("could not allocate memory for rx descriptor");
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
+	/* This is the only SPI value that we need to set here, the rest
+	 * comes from the board-peripherals file */
+	spi->bits_per_word = 32;
+
+	ret = spi_setup(spi);
+	if (ret < 0) {
+		wl1271_error("spi_setup failed");
+		goto out_free;
+	}
+
+	wl->set_power = pdata->set_power;
+	if (!wl->set_power) {
+		wl1271_error("set power function missing in platform data");
+		ret = -ENODEV;
+		goto out_free;
+	}
+
+	wl->irq = spi->irq;
+	if (wl->irq < 0) {
+		wl1271_error("irq missing in platform data");
+		ret = -ENODEV;
+		goto out_free;
+	}
+
+	ret = request_irq(wl->irq, wl1271_irq, 0, DRIVER_NAME, wl);
+	if (ret < 0) {
+		wl1271_error("request_irq() failed: %d", ret);
+		goto out_free;
+	}
+
+	set_irq_type(wl->irq, IRQ_TYPE_EDGE_RISING);
+
+	disable_irq(wl->irq);
+
+	ret = platform_device_register(&wl1271_device);
+	if (ret) {
+		wl1271_error("couldn't register platform device");
+		goto out_irq;
+	}
+	dev_set_drvdata(&wl1271_device.dev, wl);
+
+	ret = wl1271_init_ieee80211(wl);
+	if (ret)
+		goto out_platform;
+
+	ret = wl1271_register_hw(wl);
+	if (ret)
+		goto out_platform;
+
+	wl1271_debugfs_init(wl);
+
+	wl1271_notice("initialized");
+
+	return 0;
+
+ out_platform:
+	platform_device_unregister(&wl1271_device);
+
+ out_irq:
+	free_irq(wl->irq, wl);
+
+ out_free:
+	kfree(wl->rx_descriptor);
+	wl->rx_descriptor = NULL;
+
+	ieee80211_free_hw(hw);
+
+	return ret;
+}
+
+static int __devexit wl1271_remove(struct spi_device *spi)
+{
+	struct wl1271 *wl = dev_get_drvdata(&spi->dev);
+
+	ieee80211_unregister_hw(wl->hw);
+
+	wl1271_debugfs_exit(wl);
+	platform_device_unregister(&wl1271_device);
+	free_irq(wl->irq, wl);
+	kfree(wl->target_mem_map);
+	kfree(wl->fw);
+	wl->fw = NULL;
+	kfree(wl->nvs);
+	wl->nvs = NULL;
+
+	kfree(wl->rx_descriptor);
+	wl->rx_descriptor = NULL;
+
+	kfree(wl->fw_status);
+	kfree(wl->tx_res_if);
+
+	ieee80211_free_hw(wl->hw);
+
+	return 0;
+}
+
+
+static struct spi_driver wl1271_spi_driver = {
+	.driver = {
+		.name		= "wl1271",
+		.bus		= &spi_bus_type,
+		.owner		= THIS_MODULE,
+	},
+
+	.probe		= wl1271_probe,
+	.remove		= __devexit_p(wl1271_remove),
+};
+
+static int __init wl1271_init(void)
+{
+	int ret;
+
+	ret = spi_register_driver(&wl1271_spi_driver);
+	if (ret < 0) {
+		wl1271_error("failed to register spi driver: %d", ret);
+		goto out;
+	}
+
+out:
+	return ret;
+}
+
+static void __exit wl1271_exit(void)
+{
+	spi_unregister_driver(&wl1271_spi_driver);
+
+	wl1271_notice("unloaded");
+}
+
+module_init(wl1271_init);
+module_exit(wl1271_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
diff --git a/drivers/net/wireless/wl12xx/wl1271_ps.c b/drivers/net/wireless/wl12xx/wl1271_ps.c
new file mode 100644
index 0000000..1dc74b0
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1271_ps.c
@@ -0,0 +1,142 @@
+/*
+ * This file is part of wl1271
+ *
+ * Copyright (C) 2008-2009 Nokia Corporation
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
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
+#include "wl1271_reg.h"
+#include "wl1271_ps.h"
+#include "wl1271_spi.h"
+
+#define WL1271_WAKEUP_TIMEOUT 500
+
+/* Routines to toggle sleep mode while in ELP */
+void wl1271_ps_elp_sleep(struct wl1271 *wl)
+{
+	/*
+	 * FIXME: due to a problem in the firmware (causing a firmware
+	 * crash), ELP entry is prevented below. Remove the "true" to
+	 * re-enable ELP entry.
+	 */
+	if (true || wl->elp || !wl->psm)
+		return;
+
+	/*
+	 * Go to ELP unless there is work already pending - pending work
+	 * will immediately wakeup the chipset anyway.
+	 */
+	if (!work_pending(&wl->irq_work) && !work_pending(&wl->tx_work)) {
+		wl1271_debug(DEBUG_PSM, "chip to elp");
+		wl1271_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, ELPCTRL_SLEEP);
+		wl->elp = true;
+	}
+}
+
+int wl1271_ps_elp_wakeup(struct wl1271 *wl, bool chip_awake)
+{
+	DECLARE_COMPLETION_ONSTACK(compl);
+	unsigned long flags;
+	int ret;
+	u32 start_time = jiffies;
+	bool pending = false;
+
+	if (!wl->elp)
+		return 0;
+
+	wl1271_debug(DEBUG_PSM, "waking up chip from elp");
+
+	/*
+	 * The spinlock is required here to synchronize both the work and
+	 * the completion variable in one entity.
+	 */
+	spin_lock_irqsave(&wl->wl_lock, flags);
+	if (work_pending(&wl->irq_work) || chip_awake)
+		pending = true;
+	else
+		wl->elp_compl = &compl;
+	spin_unlock_irqrestore(&wl->wl_lock, flags);
+
+	wl1271_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, ELPCTRL_WAKE_UP);
+
+	if (!pending) {
+		ret = wait_for_completion_timeout(
+			&compl, msecs_to_jiffies(WL1271_WAKEUP_TIMEOUT));
+		if (ret == 0) {
+			wl1271_error("ELP wakeup timeout!");
+			ret = -ETIMEDOUT;
+			goto err;
+		} else if (ret < 0) {
+			wl1271_error("ELP wakeup completion error.");
+			goto err;
+		}
+	}
+
+	wl->elp = false;
+
+	wl1271_debug(DEBUG_PSM, "wakeup time: %u ms",
+		     jiffies_to_msecs(jiffies - start_time));
+	goto out;
+
+err:
+	spin_lock_irqsave(&wl->wl_lock, flags);
+	wl->elp_compl = NULL;
+	spin_unlock_irqrestore(&wl->wl_lock, flags);
+	return ret;
+
+out:
+	return 0;
+}
+
+int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode)
+{
+	int ret;
+
+	switch (mode) {
+	case STATION_POWER_SAVE_MODE:
+		wl1271_debug(DEBUG_PSM, "entering psm");
+		ret = wl1271_cmd_ps_mode(wl, STATION_POWER_SAVE_MODE);
+		if (ret < 0)
+			return ret;
+
+		wl1271_ps_elp_sleep(wl);
+		if (ret < 0)
+			return ret;
+
+		wl->psm = 1;
+		break;
+	case STATION_ACTIVE_MODE:
+	default:
+		wl1271_debug(DEBUG_PSM, "leaving psm");
+		ret = wl1271_ps_elp_wakeup(wl, false);
+		if (ret < 0)
+			return ret;
+
+		ret = wl1271_cmd_ps_mode(wl, STATION_ACTIVE_MODE);
+		if (ret < 0)
+			return ret;
+
+		wl->psm = 0;
+		break;
+	}
+
+	return ret;
+}
+
+
diff --git a/drivers/net/wireless/wl12xx/wl1271_ps.h b/drivers/net/wireless/wl12xx/wl1271_ps.h
new file mode 100644
index 0000000..de2bd3c
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1271_ps.h
@@ -0,0 +1,35 @@
+/*
+ * This file is part of wl1271
+ *
+ * Copyright (C) 2008-2009 Nokia Corporation
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
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
+#ifndef __WL1271_PS_H__
+#define __WL1271_PS_H__
+
+#include "wl1271.h"
+#include "wl1271_acx.h"
+
+int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode);
+void wl1271_ps_elp_sleep(struct wl1271 *wl);
+int wl1271_ps_elp_wakeup(struct wl1271 *wl, bool chip_awake);
+
+
+#endif /* __WL1271_PS_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl1271_reg.h b/drivers/net/wireless/wl12xx/wl1271_reg.h
new file mode 100644
index 0000000..f8ed4a4
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1271_reg.h
@@ -0,0 +1,758 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (C) 1998-2009 Texas Instruments. All rights reserved.
+ * Copyright (C) 2009 Nokia Corporation
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
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
+#ifndef __REG_H__
+#define __REG_H__
+
+#include <linux/bitops.h>
+
+#define REGISTERS_BASE 0x00300000
+#define DRPW_BASE      0x00310000
+
+#define REGISTERS_DOWN_SIZE 0x00008800
+#define REGISTERS_WORK_SIZE 0x0000b000
+
+#define HW_ACCESS_ELP_CTRL_REG_ADDR         0x1FFFC
+#define STATUS_MEM_ADDRESS                  0x40400
+
+/* ELP register commands */
+#define ELPCTRL_WAKE_UP             0x1
+#define ELPCTRL_WAKE_UP_WLAN_READY  0x5
+#define ELPCTRL_SLEEP               0x0
+/* ELP WLAN_READY bit */
+#define ELPCTRL_WLAN_READY          0x2
+
+/*===============================================
+   Host Software Reset - 32bit RW
+ ------------------------------------------
+    [31:1] Reserved
+    0  SOFT_RESET Soft Reset  - When this bit is set,
+    it holds the Wlan hardware in a soft reset state.
+    This reset disables all MAC and baseband processor
+    clocks except the CardBus/PCI interface clock.
+    It also initializes all MAC state machines except
+    the host interface. It does not reload the
+    contents of the EEPROM. When this bit is cleared
+    (not self-clearing), the Wlan hardware
+    exits the software reset state.
+===============================================*/
+#define ACX_REG_SLV_SOFT_RESET         (REGISTERS_BASE + 0x0000)
+
+#define WL1271_SLV_REG_DATA            (REGISTERS_BASE + 0x0008)
+#define WL1271_SLV_REG_ADATA           (REGISTERS_BASE + 0x000c)
+#define WL1271_SLV_MEM_DATA            (REGISTERS_BASE + 0x0018)
+/*
+ * Interrupt registers.
+ * 64 bit interrupt sources registers ws ced.
+ * sme interupts were removed and new ones were added.
+ * Order was changed.
+ */
+#define FIQ_MASK                       (REGISTERS_BASE + 0x0400)
+#define FIQ_MASK_L                     (REGISTERS_BASE + 0x0400)
+#define FIQ_MASK_H                     (REGISTERS_BASE + 0x0404)
+#define FIQ_MASK_SET                   (REGISTERS_BASE + 0x0408)
+#define FIQ_MASK_SET_L                 (REGISTERS_BASE + 0x0408)
+#define FIQ_MASK_SET_H                 (REGISTERS_BASE + 0x040C)
+#define FIQ_MASK_CLR                   (REGISTERS_BASE + 0x0410)
+#define FIQ_MASK_CLR_L                 (REGISTERS_BASE + 0x0410)
+#define FIQ_MASK_CLR_H                 (REGISTERS_BASE + 0x0414)
+#define IRQ_MASK                       (REGISTERS_BASE + 0x0418)
+#define IRQ_MASK_L                     (REGISTERS_BASE + 0x0418)
+#define IRQ_MASK_H                     (REGISTERS_BASE + 0x041C)
+#define IRQ_MASK_SET                   (REGISTERS_BASE + 0x0420)
+#define IRQ_MASK_SET_L                 (REGISTERS_BASE + 0x0420)
+#define IRQ_MASK_SET_H                 (REGISTERS_BASE + 0x0424)
+#define IRQ_MASK_CLR                   (REGISTERS_BASE + 0x0428)
+#define IRQ_MASK_CLR_L                 (REGISTERS_BASE + 0x0428)
+#define IRQ_MASK_CLR_H                 (REGISTERS_BASE + 0x042C)
+#define ECPU_MASK                      (REGISTERS_BASE + 0x0448)
+#define FIQ_STS_L                      (REGISTERS_BASE + 0x044C)
+#define FIQ_STS_H                      (REGISTERS_BASE + 0x0450)
+#define IRQ_STS_L                      (REGISTERS_BASE + 0x0454)
+#define IRQ_STS_H                      (REGISTERS_BASE + 0x0458)
+#define INT_STS_ND                     (REGISTERS_BASE + 0x0464)
+#define INT_STS_RAW_L                  (REGISTERS_BASE + 0x0464)
+#define INT_STS_RAW_H                  (REGISTERS_BASE + 0x0468)
+#define INT_STS_CLR                    (REGISTERS_BASE + 0x04B4)
+#define INT_STS_CLR_L                  (REGISTERS_BASE + 0x04B4)
+#define INT_STS_CLR_H                  (REGISTERS_BASE + 0x04B8)
+#define INT_ACK                        (REGISTERS_BASE + 0x046C)
+#define INT_ACK_L                      (REGISTERS_BASE + 0x046C)
+#define INT_ACK_H                      (REGISTERS_BASE + 0x0470)
+#define INT_TRIG                       (REGISTERS_BASE + 0x0474)
+#define INT_TRIG_L                     (REGISTERS_BASE + 0x0474)
+#define INT_TRIG_H                     (REGISTERS_BASE + 0x0478)
+#define HOST_STS_L                     (REGISTERS_BASE + 0x045C)
+#define HOST_STS_H                     (REGISTERS_BASE + 0x0460)
+#define HOST_MASK                      (REGISTERS_BASE + 0x0430)
+#define HOST_MASK_L                    (REGISTERS_BASE + 0x0430)
+#define HOST_MASK_H                    (REGISTERS_BASE + 0x0434)
+#define HOST_MASK_SET                  (REGISTERS_BASE + 0x0438)
+#define HOST_MASK_SET_L                (REGISTERS_BASE + 0x0438)
+#define HOST_MASK_SET_H                (REGISTERS_BASE + 0x043C)
+#define HOST_MASK_CLR                  (REGISTERS_BASE + 0x0440)
+#define HOST_MASK_CLR_L                (REGISTERS_BASE + 0x0440)
+#define HOST_MASK_CLR_H                (REGISTERS_BASE + 0x0444)
+
+#define ACX_REG_INTERRUPT_TRIG         (REGISTERS_BASE + 0x0474)
+#define ACX_REG_INTERRUPT_TRIG_H       (REGISTERS_BASE + 0x0478)
+
+/* Host Interrupts*/
+#define HINT_MASK                      (REGISTERS_BASE + 0x0494)
+#define HINT_MASK_SET                  (REGISTERS_BASE + 0x0498)
+#define HINT_MASK_CLR                  (REGISTERS_BASE + 0x049C)
+#define HINT_STS_ND_MASKED             (REGISTERS_BASE + 0x04A0)
+/*1150 spec calls this HINT_STS_RAW*/
+#define HINT_STS_ND		       (REGISTERS_BASE + 0x04B0)
+#define HINT_STS_CLR                   (REGISTERS_BASE + 0x04A4)
+#define HINT_ACK                       (REGISTERS_BASE + 0x04A8)
+#define HINT_TRIG                      (REGISTERS_BASE + 0x04AC)
+
+/*=============================================
+  Host Interrupt Mask Register - 32bit (RW)
+  ------------------------------------------
+  Setting a bit in this register masks the
+  corresponding interrupt to the host.
+  0 - RX0		- Rx first dubble buffer Data Interrupt
+  1 - TXD		- Tx Data Interrupt
+  2 - TXXFR		- Tx Transfer Interrupt
+  3 - RX1		- Rx second dubble buffer Data Interrupt
+  4 - RXXFR		- Rx Transfer Interrupt
+  5 - EVENT_A	- Event Mailbox interrupt
+  6 - EVENT_B	- Event Mailbox interrupt
+  7 - WNONHST	- Wake On Host Interrupt
+  8 - TRACE_A	- Debug Trace interrupt
+  9 - TRACE_B	- Debug Trace interrupt
+ 10 - CDCMP		- Command Complete Interrupt
+ 11 -
+ 12 -
+ 13 -
+ 14 - ICOMP		- Initialization Complete Interrupt
+ 16 - SG SE		- Soft Gemini - Sense enable interrupt
+ 17 - SG SD		- Soft Gemini - Sense disable interrupt
+ 18 -			-
+ 19 -			-
+ 20 -			-
+ 21-			-
+ Default: 0x0001
+*==============================================*/
+#define ACX_REG_INTERRUPT_MASK         (REGISTERS_BASE + 0x04DC)
+
+/*=============================================
+  Host Interrupt Mask Set 16bit, (Write only)
+  ------------------------------------------
+ Setting a bit in this register sets
+ the corresponding bin in ACX_HINT_MASK register
+ without effecting the mask
+ state of other bits (0 = no effect).
+==============================================*/
+#define ACX_REG_HINT_MASK_SET          (REGISTERS_BASE + 0x04E0)
+
+/*=============================================
+  Host Interrupt Mask Clear 16bit,(Write only)
+  ------------------------------------------
+ Setting a bit in this register clears
+ the corresponding bin in ACX_HINT_MASK register
+ without effecting the mask
+ state of other bits (0 = no effect).
+=============================================*/
+#define ACX_REG_HINT_MASK_CLR          (REGISTERS_BASE + 0x04E4)
+
+/*=============================================
+  Host Interrupt Status Nondestructive Read
+  16bit,(Read only)
+  ------------------------------------------
+ The host can read this register to determine
+ which interrupts are active.
+ Reading this register doesn't
+ effect its content.
+=============================================*/
+#define ACX_REG_INTERRUPT_NO_CLEAR     (REGISTERS_BASE + 0x04E8)
+
+/*=============================================
+  Host Interrupt Status Clear on Read  Register
+  16bit,(Read only)
+  ------------------------------------------
+ The host can read this register to determine
+ which interrupts are active.
+ Reading this register clears it,
+ thus making all interrupts inactive.
+==============================================*/
+#define ACX_REG_INTERRUPT_CLEAR        (REGISTERS_BASE + 0x04F8)
+
+/*=============================================
+  Host Interrupt Acknowledge Register
+  16bit,(Write only)
+  ------------------------------------------
+ The host can set individual bits in this
+ register to clear (acknowledge) the corresp.
+ interrupt status bits in the HINT_STS_CLR and
+ HINT_STS_ND registers, thus making the
+ assotiated interrupt inactive. (0-no effect)
+==============================================*/
+#define ACX_REG_INTERRUPT_ACK          (REGISTERS_BASE + 0x04F0)
+
+#define RX_DRIVER_DUMMY_WRITE_ADDRESS  (REGISTERS_BASE + 0x0534)
+#define RX_DRIVER_COUNTER_ADDRESS      (REGISTERS_BASE + 0x0538)
+
+/* Device Configuration registers*/
+#define SOR_CFG                        (REGISTERS_BASE + 0x0800)
+
+/* Embedded ARM CPU Control */
+
+/*===============================================
+ Halt eCPU   - 32bit RW
+ ------------------------------------------
+ 0 HALT_ECPU Halt Embedded CPU - This bit is the
+ compliment of bit 1 (MDATA2) in the SOR_CFG register.
+ During a hardware reset, this bit holds
+ the inverse of MDATA2.
+ When downloading firmware from the host,
+ set this bit (pull down MDATA2).
+ The host clears this bit after downloading the firmware into
+ zero-wait-state SSRAM.
+ When loading firmware from Flash, clear this bit (pull up MDATA2)
+ so that the eCPU can run the bootloader code in Flash
+ HALT_ECPU eCPU State
+ --------------------
+ 1 halt eCPU
+ 0 enable eCPU
+ ===============================================*/
+#define ACX_REG_ECPU_CONTROL           (REGISTERS_BASE + 0x0804)
+
+#define HI_CFG                         (REGISTERS_BASE + 0x0808)
+
+/*===============================================
+ EEPROM Burst Read Start  - 32bit RW
+ ------------------------------------------
+ [31:1] Reserved
+ 0  ACX_EE_START -  EEPROM Burst Read Start 0
+ Setting this bit starts a burst read from
+ the external EEPROM.
+ If this bit is set (after reset) before an EEPROM read/write,
+ the burst read starts at EEPROM address 0.
+ Otherwise, it starts at the address
+ following the address of the previous access.
+ TheWlan hardware hardware clears this bit automatically.
+
+ Default: 0x00000000
+*================================================*/
+#define ACX_REG_EE_START               (REGISTERS_BASE + 0x080C)
+
+#define OCP_POR_CTR                    (REGISTERS_BASE + 0x09B4)
+#define OCP_DATA_WRITE                 (REGISTERS_BASE + 0x09B8)
+#define OCP_DATA_READ                  (REGISTERS_BASE + 0x09BC)
+#define OCP_CMD                        (REGISTERS_BASE + 0x09C0)
+
+#define WL1271_HOST_WR_ACCESS          (REGISTERS_BASE + 0x09F8)
+
+#define CHIP_ID_B                      (REGISTERS_BASE + 0x5674)
+
+#define CHIP_ID_1271_PG10              (0x4030101)
+#define CHIP_ID_1271_PG20              (0x4030111)
+
+#define ENABLE                         (REGISTERS_BASE + 0x5450)
+
+/* Power Management registers */
+#define ELP_CFG_MODE                   (REGISTERS_BASE + 0x5804)
+#define ELP_CMD                        (REGISTERS_BASE + 0x5808)
+#define PLL_CAL_TIME                   (REGISTERS_BASE + 0x5810)
+#define CLK_REQ_TIME                   (REGISTERS_BASE + 0x5814)
+#define CLK_BUF_TIME                   (REGISTERS_BASE + 0x5818)
+
+#define CFG_PLL_SYNC_CNT               (REGISTERS_BASE + 0x5820)
+
+/* Scratch Pad registers*/
+#define SCR_PAD0                       (REGISTERS_BASE + 0x5608)
+#define SCR_PAD1                       (REGISTERS_BASE + 0x560C)
+#define SCR_PAD2                       (REGISTERS_BASE + 0x5610)
+#define SCR_PAD3                       (REGISTERS_BASE + 0x5614)
+#define SCR_PAD4                       (REGISTERS_BASE + 0x5618)
+#define SCR_PAD4_SET                   (REGISTERS_BASE + 0x561C)
+#define SCR_PAD4_CLR                   (REGISTERS_BASE + 0x5620)
+#define SCR_PAD5                       (REGISTERS_BASE + 0x5624)
+#define SCR_PAD5_SET                   (REGISTERS_BASE + 0x5628)
+#define SCR_PAD5_CLR                   (REGISTERS_BASE + 0x562C)
+#define SCR_PAD6                       (REGISTERS_BASE + 0x5630)
+#define SCR_PAD7                       (REGISTERS_BASE + 0x5634)
+#define SCR_PAD8                       (REGISTERS_BASE + 0x5638)
+#define SCR_PAD9                       (REGISTERS_BASE + 0x563C)
+
+/* Spare registers*/
+#define SPARE_A1                       (REGISTERS_BASE + 0x0994)
+#define SPARE_A2                       (REGISTERS_BASE + 0x0998)
+#define SPARE_A3                       (REGISTERS_BASE + 0x099C)
+#define SPARE_A4                       (REGISTERS_BASE + 0x09A0)
+#define SPARE_A5                       (REGISTERS_BASE + 0x09A4)
+#define SPARE_A6                       (REGISTERS_BASE + 0x09A8)
+#define SPARE_A7                       (REGISTERS_BASE + 0x09AC)
+#define SPARE_A8                       (REGISTERS_BASE + 0x09B0)
+#define SPARE_B1                       (REGISTERS_BASE + 0x5420)
+#define SPARE_B2                       (REGISTERS_BASE + 0x5424)
+#define SPARE_B3                       (REGISTERS_BASE + 0x5428)
+#define SPARE_B4                       (REGISTERS_BASE + 0x542C)
+#define SPARE_B5                       (REGISTERS_BASE + 0x5430)
+#define SPARE_B6                       (REGISTERS_BASE + 0x5434)
+#define SPARE_B7                       (REGISTERS_BASE + 0x5438)
+#define SPARE_B8                       (REGISTERS_BASE + 0x543C)
+
+#define PLL_PARAMETERS                 (REGISTERS_BASE + 0x6040)
+#define WU_COUNTER_PAUSE               (REGISTERS_BASE + 0x6008)
+#define WELP_ARM_COMMAND               (REGISTERS_BASE + 0x6100)
+#define DRPW_SCRATCH_START             (DRPW_BASE + 0x002C)
+
+
+#define ACX_SLV_SOFT_RESET_BIT   BIT(1)
+#define ACX_REG_EEPROM_START_BIT BIT(1)
+
+/* Command/Information Mailbox Pointers */
+
+/*===============================================
+  Command Mailbox Pointer - 32bit RW
+ ------------------------------------------
+ This register holds the start address of
+ the command mailbox located in the Wlan hardware memory.
+ The host must read this pointer after a reset to
+ find the location of the command mailbox.
+ The Wlan hardware initializes the command mailbox
+ pointer with the default address of the command mailbox.
+ The command mailbox pointer is not valid until after
+ the host receives the Init Complete interrupt from
+ the Wlan hardware.
+ ===============================================*/
+#define REG_COMMAND_MAILBOX_PTR				(SCR_PAD0)
+
+/*===============================================
+  Information Mailbox Pointer - 32bit RW
+ ------------------------------------------
+ This register holds the start address of
+ the information mailbox located in the Wlan hardware memory.
+ The host must read this pointer after a reset to find
+ the location of the information mailbox.
+ The Wlan hardware initializes the information mailbox pointer
+ with the default address of the information mailbox.
+ The information mailbox pointer is not valid
+ until after the host receives the Init Complete interrupt from
+ the Wlan hardware.
+ ===============================================*/
+#define REG_EVENT_MAILBOX_PTR				(SCR_PAD1)
+
+
+/* Misc */
+
+#define REG_ENABLE_TX_RX				(ENABLE)
+/*
+ * Rx configuration (filter) information element
+ * ---------------------------------------------
+ */
+#define REG_RX_CONFIG				(RX_CFG)
+#define REG_RX_FILTER				(RX_FILTER_CFG)
+
+
+#define RX_CFG_ENABLE_PHY_HEADER_PLCP	 0x0002
+
+/* promiscuous - receives all valid frames */
+#define RX_CFG_PROMISCUOUS		 0x0008
+
+/* receives frames from any BSSID */
+#define RX_CFG_BSSID			 0x0020
+
+/* receives frames destined to any MAC address */
+#define RX_CFG_MAC			 0x0010
+
+#define RX_CFG_ENABLE_ONLY_MY_DEST_MAC	 0x0010
+#define RX_CFG_ENABLE_ANY_DEST_MAC	 0x0000
+#define RX_CFG_ENABLE_ONLY_MY_BSSID	 0x0020
+#define RX_CFG_ENABLE_ANY_BSSID		 0x0000
+
+/* discards all broadcast frames */
+#define RX_CFG_DISABLE_BCAST		 0x0200
+
+#define RX_CFG_ENABLE_ONLY_MY_SSID	 0x0400
+#define RX_CFG_ENABLE_RX_CMPLT_FCS_ERROR 0x0800
+#define RX_CFG_COPY_RX_STATUS		 0x2000
+#define RX_CFG_TSF			 0x10000
+
+#define RX_CONFIG_OPTION_ANY_DST_MY_BSS	 (RX_CFG_ENABLE_ANY_DEST_MAC | \
+					  RX_CFG_ENABLE_ONLY_MY_BSSID)
+
+#define RX_CONFIG_OPTION_MY_DST_ANY_BSS	 (RX_CFG_ENABLE_ONLY_MY_DEST_MAC\
+					  | RX_CFG_ENABLE_ANY_BSSID)
+
+#define RX_CONFIG_OPTION_ANY_DST_ANY_BSS (RX_CFG_ENABLE_ANY_DEST_MAC | \
+					  RX_CFG_ENABLE_ANY_BSSID)
+
+#define RX_CONFIG_OPTION_MY_DST_MY_BSS	 (RX_CFG_ENABLE_ONLY_MY_DEST_MAC\
+					  | RX_CFG_ENABLE_ONLY_MY_BSSID)
+
+#define RX_CONFIG_OPTION_FOR_SCAN  (RX_CFG_ENABLE_PHY_HEADER_PLCP \
+				    | RX_CFG_ENABLE_RX_CMPLT_FCS_ERROR \
+				    | RX_CFG_COPY_RX_STATUS | RX_CFG_TSF)
+
+#define RX_CONFIG_OPTION_FOR_MEASUREMENT (RX_CFG_ENABLE_ANY_DEST_MAC)
+
+#define RX_CONFIG_OPTION_FOR_JOIN	 (RX_CFG_ENABLE_ONLY_MY_BSSID | \
+					  RX_CFG_ENABLE_ONLY_MY_DEST_MAC)
+
+#define RX_CONFIG_OPTION_FOR_IBSS_JOIN   (RX_CFG_ENABLE_ONLY_MY_SSID | \
+					  RX_CFG_ENABLE_ONLY_MY_DEST_MAC)
+
+#define RX_FILTER_OPTION_DEF	      (CFG_RX_MGMT_EN | CFG_RX_DATA_EN\
+				       | CFG_RX_CTL_EN | CFG_RX_BCN_EN\
+				       | CFG_RX_AUTH_EN | CFG_RX_ASSOC_EN)
+
+#define RX_FILTER_OPTION_FILTER_ALL	 0
+
+#define RX_FILTER_OPTION_DEF_PRSP_BCN  (CFG_RX_PRSP_EN | CFG_RX_MGMT_EN\
+					| CFG_RX_RCTS_ACK | CFG_RX_BCN_EN)
+
+#define RX_FILTER_OPTION_JOIN	     (CFG_RX_MGMT_EN | CFG_RX_DATA_EN\
+				      | CFG_RX_BCN_EN | CFG_RX_AUTH_EN\
+				      | CFG_RX_ASSOC_EN | CFG_RX_RCTS_ACK\
+				      | CFG_RX_PRSP_EN)
+
+
+/*===============================================
+  Phy regs
+ ===============================================*/
+#define ACX_PHY_ADDR_REG                SBB_ADDR
+#define ACX_PHY_DATA_REG                SBB_DATA
+#define ACX_PHY_CTRL_REG                SBB_CTL
+#define ACX_PHY_REG_WR_MASK             0x00000001ul
+#define ACX_PHY_REG_RD_MASK             0x00000002ul
+
+
+/*===============================================
+ EEPROM Read/Write Request 32bit RW
+ ------------------------------------------
+ 1 EE_READ - EEPROM Read Request 1 - Setting this bit
+ loads a single byte of data into the EE_DATA
+ register from the EEPROM location specified in
+ the EE_ADDR register.
+ The Wlan hardware hardware clears this bit automatically.
+ EE_DATA is valid when this bit is cleared.
+
+ 0 EE_WRITE  - EEPROM Write Request  - Setting this bit
+ writes a single byte of data from the EE_DATA register into the
+ EEPROM location specified in the EE_ADDR register.
+ The Wlan hardware hardware clears this bit automatically.
+*===============================================*/
+#define ACX_EE_CTL_REG                      EE_CTL
+#define EE_WRITE                            0x00000001ul
+#define EE_READ                             0x00000002ul
+
+/*===============================================
+  EEPROM Address  - 32bit RW
+  ------------------------------------------
+  This register specifies the address
+  within the EEPROM from/to which to read/write data.
+  ===============================================*/
+#define ACX_EE_ADDR_REG                     EE_ADDR
+
+/*===============================================
+  EEPROM Data  - 32bit RW
+  ------------------------------------------
+  This register either holds the read 8 bits of
+  data from the EEPROM or the write data
+  to be written to the EEPROM.
+  ===============================================*/
+#define ACX_EE_DATA_REG                     EE_DATA
+
+/*===============================================
+  EEPROM Base Address  - 32bit RW
+  ------------------------------------------
+  This register holds the upper nine bits
+  [23:15] of the 24-bit Wlan hardware memory
+  address for burst reads from EEPROM accesses.
+  The EEPROM provides the lower 15 bits of this address.
+  The MSB of the address from the EEPROM is ignored.
+  ===============================================*/
+#define ACX_EE_CFG                          EE_CFG
+
+/*===============================================
+  GPIO Output Values  -32bit, RW
+  ------------------------------------------
+  [31:16]  Reserved
+  [15: 0]  Specify the output values (at the output driver inputs) for
+  GPIO[15:0], respectively.
+  ===============================================*/
+#define ACX_GPIO_OUT_REG            GPIO_OUT
+#define ACX_MAX_GPIO_LINES          15
+
+/*===============================================
+  Contention window  -32bit, RW
+  ------------------------------------------
+  [31:26]  Reserved
+  [25:16]  Max (0x3ff)
+  [15:07]  Reserved
+  [06:00]  Current contention window value - default is 0x1F
+  ===============================================*/
+#define ACX_CONT_WIND_CFG_REG    CONT_WIND_CFG
+#define ACX_CONT_WIND_MIN_MASK   0x0000007f
+#define ACX_CONT_WIND_MAX        0x03ff0000
+
+/*
+ * Indirect slave register/memory registers
+ * ----------------------------------------
+ */
+#define HW_SLAVE_REG_ADDR_REG		0x00000004
+#define HW_SLAVE_REG_DATA_REG		0x00000008
+#define HW_SLAVE_REG_CTRL_REG		0x0000000c
+
+#define SLAVE_AUTO_INC				0x00010000
+#define SLAVE_NO_AUTO_INC			0x00000000
+#define SLAVE_HOST_LITTLE_ENDIAN	0x00000000
+
+#define HW_SLAVE_MEM_ADDR_REG		SLV_MEM_ADDR
+#define HW_SLAVE_MEM_DATA_REG		SLV_MEM_DATA
+#define HW_SLAVE_MEM_CTRL_REG		SLV_MEM_CTL
+#define HW_SLAVE_MEM_ENDIAN_REG		SLV_END_CTL
+
+#define HW_FUNC_EVENT_INT_EN		0x8000
+#define HW_FUNC_EVENT_MASK_REG		0x00000034
+
+#define ACX_MAC_TIMESTAMP_REG	(MAC_TIMESTAMP)
+
+/*===============================================
+  HI_CFG Interface Configuration Register Values
+  ------------------------------------------
+  ===============================================*/
+#define HI_CFG_UART_ENABLE          0x00000004
+#define HI_CFG_RST232_ENABLE        0x00000008
+#define HI_CFG_CLOCK_REQ_SELECT     0x00000010
+#define HI_CFG_HOST_INT_ENABLE      0x00000020
+#define HI_CFG_VLYNQ_OUTPUT_ENABLE  0x00000040
+#define HI_CFG_HOST_INT_ACTIVE_LOW  0x00000080
+#define HI_CFG_UART_TX_OUT_GPIO_15  0x00000100
+#define HI_CFG_UART_TX_OUT_GPIO_14  0x00000200
+#define HI_CFG_UART_TX_OUT_GPIO_7   0x00000400
+
+/*
+ * NOTE: USE_ACTIVE_HIGH compilation flag should be defined in makefile
+ *       for platforms using active high interrupt level
+ */
+#ifdef USE_ACTIVE_HIGH
+#define HI_CFG_DEF_VAL              \
+	(HI_CFG_UART_ENABLE |        \
+	HI_CFG_RST232_ENABLE |      \
+	HI_CFG_CLOCK_REQ_SELECT |   \
+	HI_CFG_HOST_INT_ENABLE)
+#else
+#define HI_CFG_DEF_VAL              \
+	(HI_CFG_UART_ENABLE |        \
+	HI_CFG_RST232_ENABLE |      \
+	HI_CFG_CLOCK_REQ_SELECT |   \
+	HI_CFG_HOST_INT_ENABLE)
+
+#endif
+
+#define REF_FREQ_19_2                       0
+#define REF_FREQ_26_0                       1
+#define REF_FREQ_38_4                       2
+#define REF_FREQ_40_0                       3
+#define REF_FREQ_33_6                       4
+#define REF_FREQ_NUM                        5
+
+#define LUT_PARAM_INTEGER_DIVIDER           0
+#define LUT_PARAM_FRACTIONAL_DIVIDER        1
+#define LUT_PARAM_ATTN_BB                   2
+#define LUT_PARAM_ALPHA_BB                  3
+#define LUT_PARAM_STOP_TIME_BB              4
+#define LUT_PARAM_BB_PLL_LOOP_FILTER        5
+#define LUT_PARAM_NUM                       6
+
+#define ACX_EEPROMLESS_IND_REG              (SCR_PAD4)
+#define USE_EEPROM                          0
+#define SOFT_RESET_MAX_TIME                 1000000
+#define SOFT_RESET_STALL_TIME               1000
+#define NVS_DATA_BUNDARY_ALIGNMENT          4
+
+
+/* Firmware image load chunk size */
+#define CHUNK_SIZE          512
+
+/* Firmware image header size */
+#define FW_HDR_SIZE 8
+
+#define ECPU_CONTROL_HALT					0x00000101
+
+
+/******************************************************************************
+
+    CHANNELS, BAND & REG DOMAINS definitions
+
+******************************************************************************/
+
+
+enum {
+	RADIO_BAND_2_4GHZ = 0,  /* 2.4 Ghz band */
+	RADIO_BAND_5GHZ = 1,    /* 5 Ghz band */
+	RADIO_BAND_JAPAN_4_9_GHZ = 2,
+	DEFAULT_BAND = RADIO_BAND_2_4GHZ,
+	INVALID_BAND = 0xFE,
+	MAX_RADIO_BANDS = 0xFF
+};
+
+enum {
+	NO_RATE      = 0,
+	RATE_1MBPS   = 0x0A,
+	RATE_2MBPS   = 0x14,
+	RATE_5_5MBPS = 0x37,
+	RATE_6MBPS   = 0x0B,
+	RATE_9MBPS   = 0x0F,
+	RATE_11MBPS  = 0x6E,
+	RATE_12MBPS  = 0x0A,
+	RATE_18MBPS  = 0x0E,
+	RATE_22MBPS  = 0xDC,
+	RATE_24MBPS  = 0x09,
+	RATE_36MBPS  = 0x0D,
+	RATE_48MBPS  = 0x08,
+	RATE_54MBPS  = 0x0C
+};
+
+enum {
+	RATE_INDEX_1MBPS   =  0,
+	RATE_INDEX_2MBPS   =  1,
+	RATE_INDEX_5_5MBPS =  2,
+	RATE_INDEX_6MBPS   =  3,
+	RATE_INDEX_9MBPS   =  4,
+	RATE_INDEX_11MBPS  =  5,
+	RATE_INDEX_12MBPS  =  6,
+	RATE_INDEX_18MBPS  =  7,
+	RATE_INDEX_22MBPS  =  8,
+	RATE_INDEX_24MBPS  =  9,
+	RATE_INDEX_36MBPS  =  10,
+	RATE_INDEX_48MBPS  =  11,
+	RATE_INDEX_54MBPS  =  12,
+	RATE_INDEX_MAX     =  RATE_INDEX_54MBPS,
+	MAX_RATE_INDEX,
+	INVALID_RATE_INDEX = MAX_RATE_INDEX,
+	RATE_INDEX_ENUM_MAX_SIZE = 0x7FFFFFFF
+};
+
+enum {
+	RATE_MASK_1MBPS = 0x1,
+	RATE_MASK_2MBPS = 0x2,
+	RATE_MASK_5_5MBPS = 0x4,
+	RATE_MASK_11MBPS = 0x20,
+};
+
+#define SHORT_PREAMBLE_BIT   BIT(0) /* CCK or Barker depending on the rate */
+#define OFDM_RATE_BIT        BIT(6)
+#define PBCC_RATE_BIT        BIT(7)
+
+enum {
+	CCK_LONG = 0,
+	CCK_SHORT = SHORT_PREAMBLE_BIT,
+	PBCC_LONG = PBCC_RATE_BIT,
+	PBCC_SHORT = PBCC_RATE_BIT | SHORT_PREAMBLE_BIT,
+	OFDM = OFDM_RATE_BIT
+};
+
+/******************************************************************************
+
+Transmit-Descriptor RATE-SET field definitions...
+
+Define a new "Rate-Set" for TX path that incorporates the
+Rate & Modulation info into a single 16-bit field.
+
+TxdRateSet_t:
+b15   - Indicates Preamble type (1=SHORT, 0=LONG).
+	Notes:
+	Must be LONG (0) for 1Mbps rate.
+	Does not apply (set to 0) for RevG-OFDM rates.
+b14   - Indicates PBCC encoding (1=PBCC, 0=not).
+	Notes:
+	Does not apply (set to 0) for rates 1 and 2 Mbps.
+	Does not apply (set to 0) for RevG-OFDM rates.
+b13    - Unused (set to 0).
+b12-b0 - Supported Rate indicator bits as defined below.
+
+******************************************************************************/
+
+
+#define TNETW1251_CHIP_ID_PG1_0         0x07010101
+#define TNETW1251_CHIP_ID_PG1_1         0x07020101
+#define TNETW1251_CHIP_ID_PG1_2	        0x07030101
+
+/*************************************************************************
+
+    Interrupt Trigger Register (Host -> WiLink)
+
+**************************************************************************/
+
+/* Hardware to Embedded CPU Interrupts - first 32-bit register set */
+
+/*
+ * Host Command Interrupt. Setting this bit masks
+ * the interrupt that the host issues to inform
+ * the FW that it has sent a command
+ * to the Wlan hardware Command Mailbox.
+ */
+#define INTR_TRIG_CMD       BIT(0)
+
+/*
+ * Host Event Acknowlegde Interrupt. The host
+ * sets this bit to acknowledge that it received
+ * the unsolicited information from the event
+ * mailbox.
+ */
+#define INTR_TRIG_EVENT_ACK BIT(1)
+
+/*
+ * The host sets this bit to inform the Wlan
+ * FW that a TX packet is in the XFER
+ * Buffer #0.
+ */
+#define INTR_TRIG_TX_PROC0 BIT(2)
+
+/*
+ * The host sets this bit to inform the FW
+ * that it read a packet from RX XFER
+ * Buffer #0.
+ */
+#define INTR_TRIG_RX_PROC0 BIT(3)
+
+#define INTR_TRIG_DEBUG_ACK BIT(4)
+
+#define INTR_TRIG_STATE_CHANGED BIT(5)
+
+
+/* Hardware to Embedded CPU Interrupts - second 32-bit register set */
+
+/*
+ * The host sets this bit to inform the FW
+ * that it read a packet from RX XFER
+ * Buffer #1.
+ */
+#define INTR_TRIG_RX_PROC1 BIT(17)
+
+/*
+ * The host sets this bit to inform the Wlan
+ * hardware that a TX packet is in the XFER
+ * Buffer #1.
+ */
+#define INTR_TRIG_TX_PROC1 BIT(18)
+
+#endif
diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.c b/drivers/net/wireless/wl12xx/wl1271_rx.c
new file mode 100644
index 0000000..ad8b690
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1271_rx.c
@@ -0,0 +1,200 @@
+/*
+ * This file is part of wl1271
+ *
+ * Copyright (C) 2009 Nokia Corporation
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
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
+#include "wl1271.h"
+#include "wl1271_acx.h"
+#include "wl1271_reg.h"
+#include "wl1271_rx.h"
+#include "wl1271_spi.h"
+
+static u8 wl1271_rx_get_mem_block(struct wl1271_fw_status *status,
+				  u32 drv_rx_counter)
+{
+	return status->rx_pkt_descs[drv_rx_counter] & RX_MEM_BLOCK_MASK;
+}
+
+static u32 wl1271_rx_get_buf_size(struct wl1271_fw_status *status,
+				 u32 drv_rx_counter)
+{
+	return (status->rx_pkt_descs[drv_rx_counter] & RX_BUF_SIZE_MASK) >>
+		RX_BUF_SIZE_SHIFT_DIV;
+}
+
+/* The values of this table must match the wl1271_rates[] array */
+static u8 wl1271_rx_rate_to_idx[] = {
+	/* MCS rates are used only with 11n */
+	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_MCS7 */
+	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_MCS6 */
+	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_MCS5 */
+	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_MCS4 */
+	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_MCS3 */
+	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_MCS2 */
+	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_MCS1 */
+	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_MCS0 */
+
+	11,                         /* WL1271_RATE_54   */
+	10,                         /* WL1271_RATE_48   */
+	9,                          /* WL1271_RATE_36   */
+	8,                          /* WL1271_RATE_24   */
+
+	/* TI-specific rate */
+	WL1271_RX_RATE_UNSUPPORTED, /* WL1271_RATE_22   */
+
+	7,                          /* WL1271_RATE_18   */
+	6,                          /* WL1271_RATE_12   */
+	3,                          /* WL1271_RATE_11   */
+	5,                          /* WL1271_RATE_9    */
+	4,                          /* WL1271_RATE_6    */
+	2,                          /* WL1271_RATE_5_5  */
+	1,                          /* WL1271_RATE_2    */
+	0                           /* WL1271_RATE_1    */
+};
+
+static void wl1271_rx_status(struct wl1271 *wl,
+			     struct wl1271_rx_descriptor *desc,
+			     struct ieee80211_rx_status *status,
+			     u8 beacon)
+{
+	memset(status, 0, sizeof(struct ieee80211_rx_status));
+
+	if ((desc->flags & WL1271_RX_DESC_BAND_MASK) == WL1271_RX_DESC_BAND_BG)
+		status->band = IEEE80211_BAND_2GHZ;
+	else
+		wl1271_warning("unsupported band 0x%x",
+			       desc->flags & WL1271_RX_DESC_BAND_MASK);
+
+	/*
+	 * FIXME: Add mactime handling.  For IBSS (ad-hoc) we need to get the
+	 * timestamp from the beacon (acx_tsf_info).  In BSS mode (infra) we
+	 * only need the mactime for monitor mode.  For now the mactime is
+	 * not valid, so RX_FLAG_TSFT should not be set
+	 */
+	status->signal = desc->rssi;
+
+	/* FIXME: Should this be optimized? */
+	status->qual = (desc->rssi - WL1271_RX_MIN_RSSI) * 100 /
+		(WL1271_RX_MAX_RSSI - WL1271_RX_MIN_RSSI);
+	status->qual = min(status->qual, 100);
+	status->qual = max(status->qual, 0);
+
+	/*
+	 * FIXME: In wl1251, the SNR should be divided by two.  In wl1271 we
+	 * need to divide by two for now, but TI has been discussing about
+	 * changing it.  This needs to be rechecked.
+	 */
+	status->noise = desc->rssi - (desc->snr >> 1);
+
+	status->freq = ieee80211_channel_to_frequency(desc->channel);
+
+	if (desc->flags & WL1271_RX_DESC_ENCRYPT_MASK) {
+		status->flag |= RX_FLAG_IV_STRIPPED | RX_FLAG_MMIC_STRIPPED;
+
+		if (likely(!(desc->flags & WL1271_RX_DESC_DECRYPT_FAIL)))
+			status->flag |= RX_FLAG_DECRYPTED;
+
+		if (unlikely(desc->flags & WL1271_RX_DESC_MIC_FAIL))
+			status->flag |= RX_FLAG_MMIC_ERROR;
+	}
+
+	status->rate_idx = wl1271_rx_rate_to_idx[desc->rate];
+
+	if (status->rate_idx == WL1271_RX_RATE_UNSUPPORTED)
+		wl1271_warning("unsupported rate");
+}
+
+static void wl1271_rx_handle_data(struct wl1271 *wl, u32 length)
+{
+	struct ieee80211_rx_status rx_status;
+	struct wl1271_rx_descriptor *desc;
+	struct sk_buff *skb;
+	u16 *fc;
+	u8 *buf;
+	u8 beacon = 0;
+
+	skb = dev_alloc_skb(length);
+	if (!skb) {
+		wl1271_error("Couldn't allocate RX frame");
+		return;
+	}
+
+	buf = skb_put(skb, length);
+	wl1271_spi_reg_read(wl, WL1271_SLV_MEM_DATA, buf, length, true);
+
+	/* the data read starts with the descriptor */
+	desc = (struct wl1271_rx_descriptor *) buf;
+
+	/* now we pull the descriptor out of the buffer */
+	skb_pull(skb, sizeof(*desc));
+
+	fc = (u16 *)skb->data;
+	if ((*fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BEACON)
+		beacon = 1;
+
+	wl1271_rx_status(wl, desc, &rx_status, beacon);
+
+	wl1271_debug(DEBUG_RX, "rx skb 0x%p: %d B %s", skb, skb->len,
+		     beacon ? "beacon" : "");
+
+	memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
+	ieee80211_rx(wl->hw, skb);
+}
+
+void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_status *status)
+{
+	struct wl1271_acx_mem_map *wl_mem_map = wl->target_mem_map;
+	u32 buf_size;
+	u32 fw_rx_counter  = status->fw_rx_counter & NUM_RX_PKT_DESC_MOD_MASK;
+	u32 drv_rx_counter = wl->rx_counter & NUM_RX_PKT_DESC_MOD_MASK;
+	u32 mem_block;
+
+	while (drv_rx_counter != fw_rx_counter) {
+		mem_block = wl1271_rx_get_mem_block(status, drv_rx_counter);
+		buf_size = wl1271_rx_get_buf_size(status, drv_rx_counter);
+
+		if (buf_size == 0) {
+			wl1271_warning("received empty data");
+			break;
+		}
+
+		wl->rx_mem_pool_addr.addr =
+			(mem_block << 8) + wl_mem_map->packet_memory_pool_start;
+		wl->rx_mem_pool_addr.addr_extra =
+			wl->rx_mem_pool_addr.addr + 4;
+
+		/* Choose the block we want to read */
+		wl1271_spi_reg_write(wl, WL1271_SLV_REG_DATA,
+				     &wl->rx_mem_pool_addr,
+				     sizeof(wl->rx_mem_pool_addr), false);
+
+		wl1271_rx_handle_data(wl, buf_size);
+
+		wl->rx_counter++;
+		drv_rx_counter = wl->rx_counter & NUM_RX_PKT_DESC_MOD_MASK;
+	}
+
+	wl1271_reg_write32(wl, RX_DRIVER_COUNTER_ADDRESS, wl->rx_counter);
+
+	/* This is a workaround for some problems in the chip */
+	wl1271_reg_write32(wl, RX_DRIVER_DUMMY_WRITE_ADDRESS, 0x1);
+
+}
diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.h b/drivers/net/wireless/wl12xx/wl1271_rx.h
new file mode 100644
index 0000000..d1ca60e
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1271_rx.h
@@ -0,0 +1,121 @@
+/*
+ * This file is part of wl1271
+ *
+ * Copyright (C) 1998-2009 Texas Instruments. All rights reserved.
+ * Copyright (C) 2008-2009 Nokia Corporation
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
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
+#ifndef __WL1271_RX_H__
+#define __WL1271_RX_H__
+
+#include <linux/bitops.h>
+
+#define WL1271_RX_MAX_RSSI -30
+#define WL1271_RX_MIN_RSSI -95
+
+#define WL1271_RX_ALIGN_TO 4
+#define WL1271_RX_ALIGN(len) (((len) + WL1271_RX_ALIGN_TO - 1) & \
+			     ~(WL1271_RX_ALIGN_TO - 1))
+
+#define SHORT_PREAMBLE_BIT   BIT(0)
+#define OFDM_RATE_BIT        BIT(6)
+#define PBCC_RATE_BIT        BIT(7)
+
+#define PLCP_HEADER_LENGTH 8
+#define RX_DESC_PACKETID_SHIFT 11
+#define RX_MAX_PACKET_ID 3
+
+#define NUM_RX_PKT_DESC_MOD_MASK   7
+#define WL1271_RX_RATE_UNSUPPORTED 0xFF
+
+#define RX_DESC_VALID_FCS         0x0001
+#define RX_DESC_MATCH_RXADDR1     0x0002
+#define RX_DESC_MCAST             0x0004
+#define RX_DESC_STAINTIM          0x0008
+#define RX_DESC_VIRTUAL_BM        0x0010
+#define RX_DESC_BCAST             0x0020
+#define RX_DESC_MATCH_SSID        0x0040
+#define RX_DESC_MATCH_BSSID       0x0080
+#define RX_DESC_ENCRYPTION_MASK   0x0300
+#define RX_DESC_MEASURMENT        0x0400
+#define RX_DESC_SEQNUM_MASK       0x1800
+#define	RX_DESC_MIC_FAIL	  0x2000
+#define	RX_DESC_DECRYPT_FAIL	  0x4000
+
+/*
+ * RX Descriptor flags:
+ *
+ * Bits 0-1 - band
+ * Bit  2   - STBC
+ * Bit  3   - A-MPDU
+ * Bit  4   - HT
+ * Bits 5-7 - encryption
+ */
+#define WL1271_RX_DESC_BAND_MASK    0x03
+#define WL1271_RX_DESC_ENCRYPT_MASK 0xE0
+
+#define WL1271_RX_DESC_BAND_BG      0x00
+#define WL1271_RX_DESC_BAND_J       0x01
+#define WL1271_RX_DESC_BAND_A       0x02
+
+#define WL1271_RX_DESC_STBC         BIT(2)
+#define WL1271_RX_DESC_A_MPDU       BIT(3)
+#define WL1271_RX_DESC_HT           BIT(4)
+
+#define WL1271_RX_DESC_ENCRYPT_WEP  0x20
+#define WL1271_RX_DESC_ENCRYPT_TKIP 0x40
+#define WL1271_RX_DESC_ENCRYPT_AES  0x60
+#define WL1271_RX_DESC_ENCRYPT_GEM  0x80
+
+/*
+ * RX Descriptor status
+ *
+ * Bits 0-2 - status
+ * Bits 3-7 - reserved
+ */
+#define WL1271_RX_DESC_STATUS_MASK      0x07
+
+#define WL1271_RX_DESC_SUCCESS          0x00
+#define WL1271_RX_DESC_DECRYPT_FAIL     0x01
+#define WL1271_RX_DESC_MIC_FAIL         0x02
+#define WL1271_RX_DESC_DRIVER_RX_Q_FAIL 0x03
+
+#define RX_MEM_BLOCK_MASK     0xFF
+#define RX_BUF_SIZE_MASK      0xFFF00
+#define RX_BUF_SIZE_SHIFT_DIV 6
+
+struct wl1271_rx_descriptor {
+	u16 length;
+	u8  status;
+	u8  flags;
+	u8  rate;
+	u8  channel;
+	s8  rssi;
+	u8  snr;
+	u32 timestamp;
+	u8  packet_class;
+	u8  process_id;
+	u8  pad_len;
+	u8  reserved;
+} __attribute__ ((packed));
+
+void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_status *status);
+
+#endif
diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.c b/drivers/net/wireless/wl12xx/wl1271_spi.c
new file mode 100644
index 0000000..4a12880
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1271_spi.c
@@ -0,0 +1,382 @@
+/*
+ * This file is part of wl1271
+ *
+ * Copyright (C) 2008-2009 Nokia Corporation
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
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
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/crc7.h>
+#include <linux/spi/spi.h>
+
+#include "wl1271.h"
+#include "wl12xx_80211.h"
+#include "wl1271_spi.h"
+
+static int wl1271_translate_reg_addr(struct wl1271 *wl, int addr)
+{
+	return addr - wl->physical_reg_addr + wl->virtual_reg_addr;
+}
+
+static int wl1271_translate_mem_addr(struct wl1271 *wl, int addr)
+{
+	return addr - wl->physical_mem_addr + wl->virtual_mem_addr;
+}
+
+
+void wl1271_spi_reset(struct wl1271 *wl)
+{
+	u8 *cmd;
+	struct spi_transfer t;
+	struct spi_message m;
+
+	cmd = kzalloc(WSPI_INIT_CMD_LEN, GFP_KERNEL);
+	if (!cmd) {
+		wl1271_error("could not allocate cmd for spi reset");
+		return;
+	}
+
+	memset(&t, 0, sizeof(t));
+	spi_message_init(&m);
+
+	memset(cmd, 0xff, WSPI_INIT_CMD_LEN);
+
+	t.tx_buf = cmd;
+	t.len = WSPI_INIT_CMD_LEN;
+	spi_message_add_tail(&t, &m);
+
+	spi_sync(wl->spi, &m);
+
+	wl1271_dump(DEBUG_SPI, "spi reset -> ", cmd, WSPI_INIT_CMD_LEN);
+}
+
+void wl1271_spi_init(struct wl1271 *wl)
+{
+	u8 crc[WSPI_INIT_CMD_CRC_LEN], *cmd;
+	struct spi_transfer t;
+	struct spi_message m;
+
+	cmd = kzalloc(WSPI_INIT_CMD_LEN, GFP_KERNEL);
+	if (!cmd) {
+		wl1271_error("could not allocate cmd for spi init");
+		return;
+	}
+
+	memset(crc, 0, sizeof(crc));
+	memset(&t, 0, sizeof(t));
+	spi_message_init(&m);
+
+	/*
+	 * Set WSPI_INIT_COMMAND
+	 * the data is being send from the MSB to LSB
+	 */
+	cmd[2] = 0xff;
+	cmd[3] = 0xff;
+	cmd[1] = WSPI_INIT_CMD_START | WSPI_INIT_CMD_TX;
+	cmd[0] = 0;
+	cmd[7] = 0;
+	cmd[6] |= HW_ACCESS_WSPI_INIT_CMD_MASK << 3;
+	cmd[6] |= HW_ACCESS_WSPI_FIXED_BUSY_LEN & WSPI_INIT_CMD_FIXEDBUSY_LEN;
+
+	if (HW_ACCESS_WSPI_FIXED_BUSY_LEN == 0)
+		cmd[5] |=  WSPI_INIT_CMD_DIS_FIXEDBUSY;
+	else
+		cmd[5] |= WSPI_INIT_CMD_EN_FIXEDBUSY;
+
+	cmd[5] |= WSPI_INIT_CMD_IOD | WSPI_INIT_CMD_IP | WSPI_INIT_CMD_CS
+		| WSPI_INIT_CMD_WSPI | WSPI_INIT_CMD_WS;
+
+	crc[0] = cmd[1];
+	crc[1] = cmd[0];
+	crc[2] = cmd[7];
+	crc[3] = cmd[6];
+	crc[4] = cmd[5];
+
+	cmd[4] |= crc7(0, crc, WSPI_INIT_CMD_CRC_LEN) << 1;
+	cmd[4] |= WSPI_INIT_CMD_END;
+
+	t.tx_buf = cmd;
+	t.len = WSPI_INIT_CMD_LEN;
+	spi_message_add_tail(&t, &m);
+
+	spi_sync(wl->spi, &m);
+
+	wl1271_dump(DEBUG_SPI, "spi init -> ", cmd, WSPI_INIT_CMD_LEN);
+}
+
+/* Set the SPI partitions to access the chip addresses
+ *
+ * There are two VIRTUAL (SPI) partitions (the memory partition and the
+ * registers partition), which are mapped to two different areas of the
+ * PHYSICAL (hardware) memory.  This function also makes other checks to
+ * ensure that the partitions are not overlapping.  In the diagram below, the
+ * memory partition comes before the register partition, but the opposite is
+ * also supported.
+ *
+ *                               PHYSICAL address
+ *                                     space
+ *
+ *                                    |    |
+ *                                 ...+----+--> mem_start
+ *          VIRTUAL address     ...   |    |
+ *               space       ...      |    | [PART_0]
+ *                        ...         |    |
+ * 0x00000000 <--+----+...         ...+----+--> mem_start + mem_size
+ *               |    |         ...   |    |
+ *               |MEM |      ...      |    |
+ *               |    |   ...         |    |
+ *  part_size <--+----+...            |    | {unused area)
+ *               |    |   ...         |    |
+ *               |REG |      ...      |    |
+ *  part_size    |    |         ...   |    |
+ *      +     <--+----+...         ...+----+--> reg_start
+ *  reg_size              ...         |    |
+ *                           ...      |    | [PART_1]
+ *                              ...   |    |
+ *                                 ...+----+--> reg_start + reg_size
+ *                                    |    |
+ *
+ */
+int wl1271_set_partition(struct wl1271 *wl,
+			  u32 mem_start, u32 mem_size,
+			  u32 reg_start, u32 reg_size)
+{
+	struct wl1271_partition *partition;
+	struct spi_transfer t;
+	struct spi_message m;
+	size_t len, cmd_len;
+	u32 *cmd;
+	int addr;
+
+	cmd_len = sizeof(u32) + 2 * sizeof(struct wl1271_partition);
+	cmd = kzalloc(cmd_len, GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	spi_message_init(&m);
+	memset(&t, 0, sizeof(t));
+
+	partition = (struct wl1271_partition *) (cmd + 1);
+	addr = HW_ACCESS_PART0_SIZE_ADDR;
+	len = 2 * sizeof(struct wl1271_partition);
+
+	*cmd |= WSPI_CMD_WRITE;
+	*cmd |= (len << WSPI_CMD_BYTE_LENGTH_OFFSET) & WSPI_CMD_BYTE_LENGTH;
+	*cmd |= addr & WSPI_CMD_BYTE_ADDR;
+
+	wl1271_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
+		     mem_start, mem_size);
+	wl1271_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
+		     reg_start, reg_size);
+
+	/* Make sure that the two partitions together don't exceed the
+	 * address range */
+	if ((mem_size + reg_size) > HW_ACCESS_MEMORY_MAX_RANGE) {
+		wl1271_debug(DEBUG_SPI, "Total size exceeds maximum virtual"
+			     " address range.  Truncating partition[0].");
+		mem_size = HW_ACCESS_MEMORY_MAX_RANGE - reg_size;
+		wl1271_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
+			     mem_start, mem_size);
+		wl1271_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
+			     reg_start, reg_size);
+	}
+
+	if ((mem_start < reg_start) &&
+	    ((mem_start + mem_size) > reg_start)) {
+		/* Guarantee that the memory partition doesn't overlap the
+		 * registers partition */
+		wl1271_debug(DEBUG_SPI, "End of partition[0] is "
+			     "overlapping partition[1].  Adjusted.");
+		mem_size = reg_start - mem_start;
+		wl1271_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
+			     mem_start, mem_size);
+		wl1271_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
+			     reg_start, reg_size);
+	} else if ((reg_start < mem_start) &&
+		   ((reg_start + reg_size) > mem_start)) {
+		/* Guarantee that the register partition doesn't overlap the
+		 * memory partition */
+		wl1271_debug(DEBUG_SPI, "End of partition[1] is"
+			     " overlapping partition[0].  Adjusted.");
+		reg_size = mem_start - reg_start;
+		wl1271_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
+			     mem_start, mem_size);
+		wl1271_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
+			     reg_start, reg_size);
+	}
+
+	partition[0].start = mem_start;
+	partition[0].size  = mem_size;
+	partition[1].start = reg_start;
+	partition[1].size  = reg_size;
+
+	wl->physical_mem_addr = mem_start;
+	wl->physical_reg_addr = reg_start;
+
+	wl->virtual_mem_addr = 0;
+	wl->virtual_reg_addr = mem_size;
+
+	t.tx_buf = cmd;
+	t.len = cmd_len;
+	spi_message_add_tail(&t, &m);
+
+	spi_sync(wl->spi, &m);
+
+	kfree(cmd);
+
+	return 0;
+}
+
+void wl1271_spi_read(struct wl1271 *wl, int addr, void *buf,
+		     size_t len, bool fixed)
+{
+	struct spi_transfer t[3];
+	struct spi_message m;
+	u8 *busy_buf;
+	u32 *cmd;
+
+	cmd = &wl->buffer_cmd;
+	busy_buf = wl->buffer_busyword;
+
+	*cmd = 0;
+	*cmd |= WSPI_CMD_READ;
+	*cmd |= (len << WSPI_CMD_BYTE_LENGTH_OFFSET) & WSPI_CMD_BYTE_LENGTH;
+	*cmd |= addr & WSPI_CMD_BYTE_ADDR;
+
+	if (fixed)
+		*cmd |= WSPI_CMD_FIXED;
+
+	spi_message_init(&m);
+	memset(t, 0, sizeof(t));
+
+	t[0].tx_buf = cmd;
+	t[0].len = 4;
+	spi_message_add_tail(&t[0], &m);
+
+	/* Busy and non busy words read */
+	t[1].rx_buf = busy_buf;
+	t[1].len = WL1271_BUSY_WORD_LEN;
+	spi_message_add_tail(&t[1], &m);
+
+	t[2].rx_buf = buf;
+	t[2].len = len;
+	spi_message_add_tail(&t[2], &m);
+
+	spi_sync(wl->spi, &m);
+
+	/* FIXME: check busy words */
+
+	wl1271_dump(DEBUG_SPI, "spi_read cmd -> ", cmd, sizeof(*cmd));
+	wl1271_dump(DEBUG_SPI, "spi_read buf <- ", buf, len);
+}
+
+void wl1271_spi_write(struct wl1271 *wl, int addr, void *buf,
+		      size_t len, bool fixed)
+{
+	struct spi_transfer t[2];
+	struct spi_message m;
+	u32 *cmd;
+
+	cmd = &wl->buffer_cmd;
+
+	*cmd = 0;
+	*cmd |= WSPI_CMD_WRITE;
+	*cmd |= (len << WSPI_CMD_BYTE_LENGTH_OFFSET) & WSPI_CMD_BYTE_LENGTH;
+	*cmd |= addr & WSPI_CMD_BYTE_ADDR;
+
+	if (fixed)
+		*cmd |= WSPI_CMD_FIXED;
+
+	spi_message_init(&m);
+	memset(t, 0, sizeof(t));
+
+	t[0].tx_buf = cmd;
+	t[0].len = sizeof(*cmd);
+	spi_message_add_tail(&t[0], &m);
+
+	t[1].tx_buf = buf;
+	t[1].len = len;
+	spi_message_add_tail(&t[1], &m);
+
+	spi_sync(wl->spi, &m);
+
+	wl1271_dump(DEBUG_SPI, "spi_write cmd -> ", cmd, sizeof(*cmd));
+	wl1271_dump(DEBUG_SPI, "spi_write buf -> ", buf, len);
+}
+
+void wl1271_spi_mem_read(struct wl1271 *wl, int addr, void *buf,
+			 size_t len)
+{
+	int physical;
+
+	physical = wl1271_translate_mem_addr(wl, addr);
+
+	wl1271_spi_read(wl, physical, buf, len, false);
+}
+
+void wl1271_spi_mem_write(struct wl1271 *wl, int addr, void *buf,
+			  size_t len)
+{
+	int physical;
+
+	physical = wl1271_translate_mem_addr(wl, addr);
+
+	wl1271_spi_write(wl, physical, buf, len, false);
+}
+
+void wl1271_spi_reg_read(struct wl1271 *wl, int addr, void *buf, size_t len,
+			 bool fixed)
+{
+	int physical;
+
+	physical = wl1271_translate_reg_addr(wl, addr);
+
+	wl1271_spi_read(wl, physical, buf, len, fixed);
+}
+
+void wl1271_spi_reg_write(struct wl1271 *wl, int addr, void *buf, size_t len,
+			  bool fixed)
+{
+	int physical;
+
+	physical = wl1271_translate_reg_addr(wl, addr);
+
+	wl1271_spi_write(wl, physical, buf, len, fixed);
+}
+
+u32 wl1271_mem_read32(struct wl1271 *wl, int addr)
+{
+	return wl1271_read32(wl, wl1271_translate_mem_addr(wl, addr));
+}
+
+void wl1271_mem_write32(struct wl1271 *wl, int addr, u32 val)
+{
+	wl1271_write32(wl, wl1271_translate_mem_addr(wl, addr), val);
+}
+
+u32 wl1271_reg_read32(struct wl1271 *wl, int addr)
+{
+	return wl1271_read32(wl, wl1271_translate_reg_addr(wl, addr));
+}
+
+void wl1271_reg_write32(struct wl1271 *wl, int addr, u32 val)
+{
+	wl1271_write32(wl, wl1271_translate_reg_addr(wl, addr), val);
+}
diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.h b/drivers/net/wireless/wl12xx/wl1271_spi.h
new file mode 100644
index 0000000..2c99684
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1271_spi.h
@@ -0,0 +1,113 @@
+/*
+ * This file is part of wl1271
+ *
+ * Copyright (C) 1998-2009 Texas Instruments. All rights reserved.
+ * Copyright (C) 2008-2009 Nokia Corporation
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
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
+#ifndef __WL1271_SPI_H__
+#define __WL1271_SPI_H__
+
+#include "wl1271_reg.h"
+
+#define HW_ACCESS_MEMORY_MAX_RANGE		0x1FFC0
+
+#define HW_ACCESS_PART0_SIZE_ADDR           0x1FFC0
+#define HW_ACCESS_PART0_START_ADDR          0x1FFC4
+#define HW_ACCESS_PART1_SIZE_ADDR           0x1FFC8
+#define HW_ACCESS_PART1_START_ADDR          0x1FFCC
+
+#define HW_ACCESS_REGISTER_SIZE             4
+
+#define HW_ACCESS_PRAM_MAX_RANGE		0x3c000
+
+#define WSPI_CMD_READ                 0x40000000
+#define WSPI_CMD_WRITE                0x00000000
+#define WSPI_CMD_FIXED                0x20000000
+#define WSPI_CMD_BYTE_LENGTH          0x1FFE0000
+#define WSPI_CMD_BYTE_LENGTH_OFFSET   17
+#define WSPI_CMD_BYTE_ADDR            0x0001FFFF
+
+#define WSPI_INIT_CMD_CRC_LEN       5
+
+#define WSPI_INIT_CMD_START         0x00
+#define WSPI_INIT_CMD_TX            0x40
+/* the extra bypass bit is sampled by the TNET as '1' */
+#define WSPI_INIT_CMD_BYPASS_BIT    0x80
+#define WSPI_INIT_CMD_FIXEDBUSY_LEN 0x07
+#define WSPI_INIT_CMD_EN_FIXEDBUSY  0x80
+#define WSPI_INIT_CMD_DIS_FIXEDBUSY 0x00
+#define WSPI_INIT_CMD_IOD           0x40
+#define WSPI_INIT_CMD_IP            0x20
+#define WSPI_INIT_CMD_CS            0x10
+#define WSPI_INIT_CMD_WS            0x08
+#define WSPI_INIT_CMD_WSPI          0x01
+#define WSPI_INIT_CMD_END           0x01
+
+#define WSPI_INIT_CMD_LEN           8
+
+#define HW_ACCESS_WSPI_FIXED_BUSY_LEN \
+		((WL1271_BUSY_WORD_LEN - 4) / sizeof(u32))
+#define HW_ACCESS_WSPI_INIT_CMD_MASK  0
+
+
+/* Raw target IO, address is not translated */
+void wl1271_spi_write(struct wl1271 *wl, int addr, void *buf,
+		      size_t len, bool fixed);
+void wl1271_spi_read(struct wl1271 *wl, int addr, void *buf,
+		     size_t len, bool fixed);
+
+/* Memory target IO, address is tranlated to partition 0 */
+void wl1271_spi_mem_read(struct wl1271 *wl, int addr, void *buf, size_t len);
+void wl1271_spi_mem_write(struct wl1271 *wl, int addr, void *buf, size_t len);
+u32 wl1271_mem_read32(struct wl1271 *wl, int addr);
+void wl1271_mem_write32(struct wl1271 *wl, int addr, u32 val);
+
+/* Registers IO */
+void wl1271_spi_reg_read(struct wl1271 *wl, int addr, void *buf, size_t len,
+			 bool fixed);
+void wl1271_spi_reg_write(struct wl1271 *wl, int addr, void *buf, size_t len,
+			  bool fixed);
+u32 wl1271_reg_read32(struct wl1271 *wl, int addr);
+void wl1271_reg_write32(struct wl1271 *wl, int addr, u32 val);
+
+/* INIT and RESET words */
+void wl1271_spi_reset(struct wl1271 *wl);
+void wl1271_spi_init(struct wl1271 *wl);
+int wl1271_set_partition(struct wl1271 *wl,
+			 u32 part_start, u32 part_size,
+			 u32 reg_start,  u32 reg_size);
+
+static inline u32 wl1271_read32(struct wl1271 *wl, int addr)
+{
+	wl1271_spi_read(wl, addr, &wl->buffer_32,
+			sizeof(wl->buffer_32), false);
+
+	return wl->buffer_32;
+}
+
+static inline void wl1271_write32(struct wl1271 *wl, int addr, u32 val)
+{
+	wl->buffer_32 = val;
+	wl1271_spi_write(wl, addr, &wl->buffer_32,
+			 sizeof(wl->buffer_32), false);
+}
+
+#endif /* __WL1271_SPI_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
new file mode 100644
index 0000000..ff22125
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -0,0 +1,378 @@
+/*
+ * This file is part of wl1271
+ *
+ * Copyright (C) 2009 Nokia Corporation
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
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
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include "wl1271.h"
+#include "wl1271_spi.h"
+#include "wl1271_reg.h"
+#include "wl1271_ps.h"
+#include "wl1271_tx.h"
+
+static int wl1271_tx_id(struct wl1271 *wl, struct sk_buff *skb)
+{
+	int i;
+
+	for (i = 0; i < FW_TX_CMPLT_BLOCK_SIZE; i++)
+		if (wl->tx_frames[i] == NULL) {
+			wl->tx_frames[i] = skb;
+			return i;
+		}
+
+	return -EBUSY;
+}
+
+static int wl1271_tx_allocate(struct wl1271 *wl, struct sk_buff *skb, u32 extra)
+{
+	struct wl1271_tx_hw_descr *desc;
+	u32 total_len = skb->len + sizeof(struct wl1271_tx_hw_descr) + extra;
+	u32 total_blocks, excluded;
+	int id, ret = -EBUSY;
+
+	/* allocate free identifier for the packet */
+	id = wl1271_tx_id(wl, skb);
+	if (id < 0)
+		return id;
+
+	/* approximate the number of blocks required for this packet
+	   in the firmware */
+	/* FIXME: try to figure out what is done here and make it cleaner */
+	total_blocks = (skb->len) >> TX_HW_BLOCK_SHIFT_DIV;
+	excluded = (total_blocks << 2) + (skb->len & 0xff) + 34;
+	total_blocks += (excluded > 252) ? 2 : 1;
+	total_blocks += TX_HW_BLOCK_SPARE;
+
+	if (total_blocks <= wl->tx_blocks_available) {
+		desc = (struct wl1271_tx_hw_descr *)skb_push(
+			skb, total_len - skb->len);
+
+		desc->extra_mem_blocks = TX_HW_BLOCK_SPARE;
+		desc->total_mem_blocks = total_blocks;
+		desc->id = id;
+
+		wl->tx_blocks_available -= total_blocks;
+
+		ret = 0;
+
+		wl1271_debug(DEBUG_TX,
+			     "tx_allocate: size: %d, blocks: %d, id: %d",
+			     total_len, total_blocks, id);
+	} else
+		wl->tx_frames[id] = NULL;
+
+	return ret;
+}
+
+static int wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
+			      u32 extra, struct ieee80211_tx_info *control)
+{
+	struct wl1271_tx_hw_descr *desc;
+	int pad;
+
+	desc = (struct wl1271_tx_hw_descr *) skb->data;
+
+	/* configure packet life time */
+	desc->start_time = jiffies_to_usecs(jiffies) - wl->time_offset;
+	desc->life_time = TX_HW_MGMT_PKT_LIFETIME_TU;
+
+	/* configure the tx attributes */
+	desc->tx_attr = wl->session_counter << TX_HW_ATTR_OFST_SESSION_COUNTER;
+	/* FIXME: do we know the packet priority? can we identify mgmt
+	   packets, and use max prio for them at least? */
+	desc->tid = 0;
+	desc->aid = TX_HW_DEFAULT_AID;
+	desc->reserved = 0;
+
+	/* align the length (and store in terms of words) */
+	pad = WL1271_TX_ALIGN(skb->len);
+	desc->length = pad >> 2;
+
+	/* calculate number of padding bytes */
+	pad = pad - skb->len;
+	desc->tx_attr |= pad << TX_HW_ATTR_OFST_LAST_WORD_PAD;
+
+	wl1271_debug(DEBUG_TX, "tx_fill_hdr: pad: %d", pad);
+	return 0;
+}
+
+static int wl1271_tx_send_packet(struct wl1271 *wl, struct sk_buff *skb,
+				 struct ieee80211_tx_info *control)
+{
+
+	struct wl1271_tx_hw_descr *desc;
+	int len;
+
+	/* FIXME: This is a workaround for getting non-aligned packets.
+	   This happens at least with EAPOL packets from the user space.
+	   Our DMA requires packets to be aligned on a 4-byte boundary.
+	*/
+	if (unlikely((long)skb->data & 0x03)) {
+		int offset = (4 - (long)skb->data) & 0x03;
+		wl1271_debug(DEBUG_TX, "skb offset %d", offset);
+
+		/* check whether the current skb can be used */
+		if (!skb_cloned(skb) && (skb_tailroom(skb) >= offset)) {
+			unsigned char *src = skb->data;
+
+			/* align the buffer on a 4-byte boundary */
+			skb_reserve(skb, offset);
+			memmove(skb->data, src, skb->len);
+		} else {
+			wl1271_info("No handler, fixme!");
+			return -EINVAL;
+		}
+	}
+
+	len = WL1271_TX_ALIGN(skb->len);
+
+	/* perform a fixed address block write with the packet */
+	wl1271_spi_reg_write(wl, WL1271_SLV_MEM_DATA, skb->data, len, true);
+
+	/* write packet new counter into the write access register */
+	wl->tx_packets_count++;
+	wl1271_reg_write32(wl, WL1271_HOST_WR_ACCESS, wl->tx_packets_count);
+
+	desc = (struct wl1271_tx_hw_descr *) skb->data;
+	wl1271_debug(DEBUG_TX, "tx id %u skb 0x%p payload %u (%u words)",
+		     desc->id, skb, len, desc->length);
+
+	return 0;
+}
+
+/* caller must hold wl->mutex */
+static int wl1271_tx_frame(struct wl1271 *wl, struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info;
+	u32 extra = 0;
+	int ret = 0;
+	u8 idx;
+
+	if (!skb)
+		return -EINVAL;
+
+	info = IEEE80211_SKB_CB(skb);
+
+	if (info->control.hw_key &&
+	    info->control.hw_key->alg == ALG_TKIP)
+		extra = WL1271_TKIP_IV_SPACE;
+
+	if (info->control.hw_key) {
+		idx = info->control.hw_key->hw_key_idx;
+
+		/* FIXME: do we have to do this if we're not using WEP? */
+		if (unlikely(wl->default_key != idx)) {
+			ret = wl1271_cmd_set_default_wep_key(wl, idx);
+			if (ret < 0)
+				return ret;
+		}
+	}
+
+	ret = wl1271_tx_allocate(wl, skb, extra);
+	if (ret < 0)
+		return ret;
+
+	ret = wl1271_tx_fill_hdr(wl, skb, extra, info);
+	if (ret < 0)
+		return ret;
+
+	ret = wl1271_tx_send_packet(wl, skb, info);
+	if (ret < 0)
+		return ret;
+
+	return ret;
+}
+
+void wl1271_tx_work(struct work_struct *work)
+{
+	struct wl1271 *wl = container_of(work, struct wl1271, tx_work);
+	struct sk_buff *skb;
+	bool woken_up = false;
+	int ret;
+
+	mutex_lock(&wl->mutex);
+
+	if (unlikely(wl->state == WL1271_STATE_OFF))
+		goto out;
+
+	while ((skb = skb_dequeue(&wl->tx_queue))) {
+		if (!woken_up) {
+			ret = wl1271_ps_elp_wakeup(wl, false);
+			if (ret < 0)
+				goto out;
+			woken_up = true;
+		}
+
+		ret = wl1271_tx_frame(wl, skb);
+		if (ret == -EBUSY) {
+			/* firmware buffer is full, stop queues */
+			wl1271_debug(DEBUG_TX, "tx_work: fw buffer full, "
+				     "stop queues");
+			ieee80211_stop_queues(wl->hw);
+			wl->tx_queue_stopped = true;
+			skb_queue_head(&wl->tx_queue, skb);
+			goto out;
+		} else if (ret < 0) {
+			dev_kfree_skb(skb);
+			goto out;
+		} else if (wl->tx_queue_stopped) {
+			/* firmware buffer has space, restart queues */
+			wl1271_debug(DEBUG_TX,
+				     "complete_packet: waking queues");
+			ieee80211_wake_queues(wl->hw);
+			wl->tx_queue_stopped = false;
+		}
+	}
+
+out:
+	if (woken_up)
+		wl1271_ps_elp_sleep(wl);
+
+	mutex_unlock(&wl->mutex);
+}
+
+static void wl1271_tx_complete_packet(struct wl1271 *wl,
+				      struct wl1271_tx_hw_res_descr *result)
+{
+
+	struct ieee80211_tx_info *info;
+	struct sk_buff *skb;
+	u32 header_len;
+	int id = result->id;
+
+	/* check for id legality */
+	if (id >= TX_HW_RESULT_QUEUE_LEN || wl->tx_frames[id] == NULL) {
+		wl1271_warning("TX result illegal id: %d", id);
+		return;
+	}
+
+	skb = wl->tx_frames[id];
+	info = IEEE80211_SKB_CB(skb);
+
+	/* update packet status */
+	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
+		if (result->status == TX_SUCCESS)
+			info->flags |= IEEE80211_TX_STAT_ACK;
+		if (result->status & TX_RETRY_EXCEEDED) {
+			/* FIXME */
+			/* info->status.excessive_retries = 1; */
+			wl->stats.excessive_retries++;
+		}
+	}
+
+	/* FIXME */
+	/* info->status.retry_count = result->ack_failures; */
+	wl->stats.retry_count += result->ack_failures;
+
+	/* get header len */
+	if (info->control.hw_key &&
+	    info->control.hw_key->alg == ALG_TKIP)
+		header_len = WL1271_TKIP_IV_SPACE +
+			sizeof(struct wl1271_tx_hw_descr);
+	else
+		header_len = sizeof(struct wl1271_tx_hw_descr);
+
+	wl1271_debug(DEBUG_TX, "tx status id %u skb 0x%p failures %u rate 0x%x"
+		     " status 0x%x",
+		     result->id, skb, result->ack_failures,
+		     result->rate_class_index, result->status);
+
+	/* remove private header from packet */
+	skb_pull(skb, header_len);
+
+	/* return the packet to the stack */
+	ieee80211_tx_status(wl->hw, skb);
+	wl->tx_frames[result->id] = NULL;
+}
+
+/* Called upon reception of a TX complete interrupt */
+void wl1271_tx_complete(struct wl1271 *wl, u32 count)
+{
+	struct wl1271_acx_mem_map *memmap =
+		(struct wl1271_acx_mem_map *)wl->target_mem_map;
+	u32 i;
+
+	wl1271_debug(DEBUG_TX, "tx_complete received, packets: %d", count);
+
+	/* read the tx results from the chipset */
+	wl1271_spi_mem_read(wl, memmap->tx_result,
+			    wl->tx_res_if, sizeof(*wl->tx_res_if));
+
+	/* verify that the result buffer is not getting overrun */
+	if (count > TX_HW_RESULT_QUEUE_LEN) {
+		wl1271_warning("TX result overflow from chipset: %d", count);
+		count = TX_HW_RESULT_QUEUE_LEN;
+	}
+
+	/* process the results */
+	for (i = 0; i < count; i++) {
+		struct wl1271_tx_hw_res_descr *result;
+		u8 offset = wl->tx_results_count & TX_HW_RESULT_QUEUE_LEN_MASK;
+
+		/* process the packet */
+		result =  &(wl->tx_res_if->tx_results_queue[offset]);
+		wl1271_tx_complete_packet(wl, result);
+
+		wl->tx_results_count++;
+	}
+
+	/* write host counter to chipset (to ack) */
+	wl1271_mem_write32(wl, memmap->tx_result +
+			   offsetof(struct wl1271_tx_hw_res_if,
+				    tx_result_host_counter),
+			   wl->tx_res_if->tx_result_fw_counter);
+}
+
+/* caller must hold wl->mutex */
+void wl1271_tx_flush(struct wl1271 *wl)
+{
+	int i;
+	struct sk_buff *skb;
+	struct ieee80211_tx_info *info;
+
+	/* TX failure */
+/* 	control->flags = 0; FIXME */
+
+	while ((skb = skb_dequeue(&wl->tx_queue))) {
+		info = IEEE80211_SKB_CB(skb);
+
+		wl1271_debug(DEBUG_TX, "flushing skb 0x%p", skb);
+
+		if (!(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS))
+				continue;
+
+		ieee80211_tx_status(wl->hw, skb);
+	}
+
+	for (i = 0; i < FW_TX_CMPLT_BLOCK_SIZE; i++)
+		if (wl->tx_frames[i] != NULL) {
+			skb = wl->tx_frames[i];
+			info = IEEE80211_SKB_CB(skb);
+
+			if (!(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS))
+				continue;
+
+			ieee80211_tx_status(wl->hw, skb);
+			wl->tx_frames[i] = NULL;
+		}
+}
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.h b/drivers/net/wireless/wl12xx/wl1271_tx.h
new file mode 100644
index 0000000..4a61406
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.h
@@ -0,0 +1,130 @@
+/*
+ * This file is part of wl1271
+ *
+ * Copyright (C) 1998-2009 Texas Instruments. All rights reserved.
+ * Copyright (C) 2009 Nokia Corporation
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
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
+#ifndef __WL1271_TX_H__
+#define __WL1271_TX_H__
+
+#define TX_HW_BLOCK_SPARE                2
+#define TX_HW_BLOCK_SHIFT_DIV            8
+
+#define TX_HW_MGMT_PKT_LIFETIME_TU       2000
+/* The chipset reference driver states, that the "aid" value 1
+ * is for infra-BSS, but is still always used */
+#define TX_HW_DEFAULT_AID                1
+
+#define TX_HW_ATTR_SAVE_RETRIES          BIT(0)
+#define TX_HW_ATTR_HEADER_PAD            BIT(1)
+#define TX_HW_ATTR_SESSION_COUNTER       (BIT(2) | BIT(3) | BIT(4))
+#define TX_HW_ATTR_RATE_POLICY           (BIT(5) | BIT(6) | BIT(7) | \
+					  BIT(8) | BIT(9))
+#define TX_HW_ATTR_LAST_WORD_PAD         (BIT(10) | BIT(11))
+#define TX_HW_ATTR_TX_CMPLT_REQ          BIT(12)
+
+#define TX_HW_ATTR_OFST_SAVE_RETRIES     0
+#define TX_HW_ATTR_OFST_HEADER_PAD       1
+#define TX_HW_ATTR_OFST_SESSION_COUNTER  2
+#define TX_HW_ATTR_OFST_RATE_POLICY      5
+#define TX_HW_ATTR_OFST_LAST_WORD_PAD    10
+#define TX_HW_ATTR_OFST_TX_CMPLT_REQ     12
+
+#define TX_HW_RESULT_QUEUE_LEN           16
+#define TX_HW_RESULT_QUEUE_LEN_MASK      0xf
+
+#define WL1271_TX_ALIGN_TO 4
+#define WL1271_TX_ALIGN(len) (((len) + WL1271_TX_ALIGN_TO - 1) & \
+			     ~(WL1271_TX_ALIGN_TO - 1))
+#define WL1271_TKIP_IV_SPACE 4
+
+struct wl1271_tx_hw_descr {
+	/* Length of packet in words, including descriptor+header+data */
+	u16 length;
+	/* Number of extra memory blocks to allocate for this packet in
+	   addition to the number of blocks derived from the packet length */
+	u8 extra_mem_blocks;
+	/* Total number of memory blocks allocated by the host for this packet.
+	   Must be equal or greater than the actual blocks number allocated by
+	   HW!! */
+	u8 total_mem_blocks;
+	/* Device time (in us) when the packet arrived to the driver */
+	u32 start_time;
+	/* Max delay in TUs until transmission. The last device time the
+	   packet can be transmitted is: startTime+(1024*LifeTime) */
+	u16 life_time;
+	/* Bitwise fields - see TX_ATTR... definitions above. */
+	u16 tx_attr;
+	/* Packet identifier used also in the Tx-Result. */
+	u8 id;
+	/* The packet TID value (as User-Priority) */
+	u8 tid;
+	/* Identifier of the remote STA in IBSS, 1 in infra-BSS */
+	u8 aid;
+	u8 reserved;
+} __attribute__ ((packed));
+
+enum wl1271_tx_hw_res_status {
+	TX_SUCCESS          = 0,
+	TX_HW_ERROR         = 1,
+	TX_DISABLED         = 2,
+	TX_RETRY_EXCEEDED   = 3,
+	TX_TIMEOUT          = 4,
+	TX_KEY_NOT_FOUND    = 5,
+	TX_PEER_NOT_FOUND   = 6,
+	TX_SESSION_MISMATCH = 7
+};
+
+struct wl1271_tx_hw_res_descr {
+	/* Packet Identifier - same value used in the Tx descriptor.*/
+	u8 id;
+	/* The status of the transmission, indicating success or one of
+	   several possible reasons for failure. */
+	u8 status;
+	/* Total air access duration including all retrys and overheads.*/
+	u16 medium_usage;
+	/* The time passed from host xfer to Tx-complete.*/
+	u32 fw_handling_time;
+	/* Total media delay
+	   (from 1st EDCA AIFS counter until TX Complete). */
+	u32 medium_delay;
+	/* LS-byte of last TKIP seq-num (saved per AC for recovery). */
+	u8 lsb_security_sequence_number;
+	/* Retry count - number of transmissions without successful ACK.*/
+	u8 ack_failures;
+	/* The rate that succeeded getting ACK
+	   (Valid only if status=SUCCESS). */
+	u8 rate_class_index;
+	/* for 4-byte alignment. */
+	u8 spare;
+} __attribute__ ((packed));
+
+struct wl1271_tx_hw_res_if {
+	u32 tx_result_fw_counter;
+	u32 tx_result_host_counter;
+	struct wl1271_tx_hw_res_descr tx_results_queue[TX_HW_RESULT_QUEUE_LEN];
+} __attribute__ ((packed));
+
+void wl1271_tx_work(struct work_struct *work);
+void wl1271_tx_complete(struct wl1271 *wl, u32 count);
+void wl1271_tx_flush(struct wl1271 *wl);
+
+#endif
-- 
1.5.6.5

