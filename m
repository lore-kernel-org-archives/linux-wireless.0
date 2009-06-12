Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:39173 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbZFLLSH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 07:18:07 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 29/33] wl1251: rename wl12xx.h to wl1251.h
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2009 14:17:25 +0300
Message-ID: <20090612111725.8877.46368.stgit@tikku>
In-Reply-To: <20090612110225.8877.92418.stgit@tikku>
References: <20090612110225.8877.92418.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

wl12xx.h is now only used by 1251 code, so we can rename it.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Vidhya Govindan <vidhya.govindan@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
---

 drivers/net/wireless/wl12xx/reg.h            |    1 
 drivers/net/wireless/wl12xx/wl1251.h         |  420 ++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1251_acx.c     |    2 
 drivers/net/wireless/wl12xx/wl1251_acx.h     |    2 
 drivers/net/wireless/wl12xx/wl1251_boot.h    |    2 
 drivers/net/wireless/wl12xx/wl1251_cmd.c     |    2 
 drivers/net/wireless/wl12xx/wl1251_cmd.h     |    2 
 drivers/net/wireless/wl12xx/wl1251_debugfs.c |    2 
 drivers/net/wireless/wl12xx/wl1251_debugfs.h |    2 
 drivers/net/wireless/wl12xx/wl1251_event.c   |    2 
 drivers/net/wireless/wl12xx/wl1251_init.h    |    2 
 drivers/net/wireless/wl12xx/wl1251_main.c    |    2 
 drivers/net/wireless/wl12xx/wl1251_netlink.c |    2 
 drivers/net/wireless/wl12xx/wl1251_ops.h     |    2 
 drivers/net/wireless/wl12xx/wl1251_ps.h      |    2 
 drivers/net/wireless/wl12xx/wl1251_rx.c      |    2 
 drivers/net/wireless/wl12xx/wl1251_rx.h      |    2 
 drivers/net/wireless/wl12xx/wl1251_spi.c     |    2 
 drivers/net/wireless/wl12xx/wl1251_tx.c      |    2 
 drivers/net/wireless/wl12xx/wl12xx.h         |  420 --------------------------
 20 files changed, 438 insertions(+), 437 deletions(-)
 create mode 100644 drivers/net/wireless/wl12xx/wl1251.h
 delete mode 100644 drivers/net/wireless/wl12xx/wl12xx.h

diff --git a/drivers/net/wireless/wl12xx/reg.h b/drivers/net/wireless/wl12xx/reg.h
index e421643..2de47cc 100644
--- a/drivers/net/wireless/wl12xx/reg.h
+++ b/drivers/net/wireless/wl12xx/reg.h
@@ -26,7 +26,6 @@
 #define __REG_H__
 
 #include <linux/bitops.h>
-#include "wl12xx.h"
 
 #define REGISTERS_BASE 0x00300000
 #define DRPW_BASE      0x00310000
diff --git a/drivers/net/wireless/wl12xx/wl1251.h b/drivers/net/wireless/wl12xx/wl1251.h
new file mode 100644
index 0000000..c673cdb
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1251.h
@@ -0,0 +1,420 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (c) 1998-2007 Texas Instruments Incorporated
+ * Copyright (C) 2008-2009 Nokia Corporation
+ *
+ * Contact: Kalle Valo <kalle.valo@nokia.com>
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
+#ifndef __WL12XX_H__
+#define __WL12XX_H__
+
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include <linux/bitops.h>
+#include <net/mac80211.h>
+
+#define DRIVER_NAME "wl12xx"
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
+#define wl12xx_error(fmt, arg...) \
+	printk(KERN_ERR DRIVER_PREFIX "ERROR " fmt "\n", ##arg)
+
+#define wl12xx_warning(fmt, arg...) \
+	printk(KERN_WARNING DRIVER_PREFIX "WARNING " fmt "\n", ##arg)
+
+#define wl12xx_notice(fmt, arg...) \
+	printk(KERN_INFO DRIVER_PREFIX fmt "\n", ##arg)
+
+#define wl12xx_info(fmt, arg...) \
+	printk(KERN_DEBUG DRIVER_PREFIX fmt "\n", ##arg)
+
+#define wl12xx_debug(level, fmt, arg...) \
+	do { \
+		if (level & DEBUG_LEVEL) \
+			printk(KERN_DEBUG DRIVER_PREFIX fmt "\n", ##arg); \
+	} while (0)
+
+#define wl12xx_dump(level, prefix, buf, len)	\
+	do { \
+		if (level & DEBUG_LEVEL) \
+			print_hex_dump(KERN_DEBUG, DRIVER_PREFIX prefix, \
+				       DUMP_PREFIX_OFFSET, 16, 1,	\
+				       buf,				\
+				       min_t(size_t, len, DEBUG_DUMP_LIMIT), \
+				       0);				\
+	} while (0)
+
+#define wl12xx_dump_ascii(level, prefix, buf, len)	\
+	do { \
+		if (level & DEBUG_LEVEL) \
+			print_hex_dump(KERN_DEBUG, DRIVER_PREFIX prefix, \
+				       DUMP_PREFIX_OFFSET, 16, 1,	\
+				       buf,				\
+				       min_t(size_t, len, DEBUG_DUMP_LIMIT), \
+				       true);				\
+	} while (0)
+
+#define WL12XX_DEFAULT_RX_CONFIG (CFG_UNI_FILTER_EN |	\
+				  CFG_BSSID_FILTER_EN)
+
+#define WL12XX_DEFAULT_RX_FILTER (CFG_RX_PRSP_EN |  \
+				  CFG_RX_MGMT_EN |  \
+				  CFG_RX_DATA_EN |  \
+				  CFG_RX_CTL_EN |   \
+				  CFG_RX_BCN_EN |   \
+				  CFG_RX_AUTH_EN |  \
+				  CFG_RX_ASSOC_EN)
+
+#define WL12XX_BUSY_WORD_LEN 8
+
+struct boot_attr {
+	u32 radio_type;
+	u8 mac_clock;
+	u8 arm_clock;
+	int firmware_debug;
+	u32 minor;
+	u32 major;
+	u32 bugfix;
+};
+
+enum wl12xx_state {
+	WL12XX_STATE_OFF,
+	WL12XX_STATE_ON,
+	WL12XX_STATE_PLT,
+};
+
+enum wl12xx_partition_type {
+	PART_DOWN,
+	PART_WORK,
+	PART_DRPW,
+
+	PART_TABLE_LEN
+};
+
+struct wl12xx_partition {
+	u32 size;
+	u32 start;
+};
+
+struct wl12xx_partition_set {
+	struct wl12xx_partition mem;
+	struct wl12xx_partition reg;
+};
+
+struct wl12xx;
+
+/* FIXME: I'm not sure about this structure name */
+struct wl12xx_chip {
+	u32 id;
+
+	const char *fw_filename;
+	const char *nvs_filename;
+
+	char fw_ver[21];
+
+	unsigned int power_on_sleep;
+	int intr_cmd_complete;
+	int intr_init_complete;
+
+	int (*op_upload_fw)(struct wl12xx *wl);
+	int (*op_upload_nvs)(struct wl12xx *wl);
+	int (*op_boot)(struct wl12xx *wl);
+	void (*op_set_ecpu_ctrl)(struct wl12xx *wl, u32 flag);
+	void (*op_target_enable_interrupts)(struct wl12xx *wl);
+	int (*op_hw_init)(struct wl12xx *wl);
+	int (*op_plt_init)(struct wl12xx *wl);
+	void (*op_tx_flush)(struct wl12xx *wl);
+	void (*op_fw_version)(struct wl12xx *wl);
+	int (*op_cmd_join)(struct wl12xx *wl, u8 bss_type, u8 dtim_interval,
+			    u16 beacon_interval, u8 wait);
+
+	struct wl12xx_partition_set *p_table;
+	enum wl12xx_acx_int_reg *acx_reg_table;
+};
+
+struct wl12xx_stats {
+	struct acx_statistics *fw_stats;
+	unsigned long fw_stats_update;
+
+	unsigned int retry_count;
+	unsigned int excessive_retries;
+};
+
+struct wl12xx_debugfs {
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
+struct wl12xx {
+	struct ieee80211_hw *hw;
+	bool mac80211_registered;
+
+	struct spi_device *spi;
+
+	void (*set_power)(bool enable);
+	int irq;
+
+	enum wl12xx_state state;
+	struct mutex mutex;
+
+	int physical_mem_addr;
+	int physical_reg_addr;
+	int virtual_mem_addr;
+	int virtual_reg_addr;
+
+	struct wl12xx_chip chip;
+
+	int cmd_box_addr;
+	int event_box_addr;
+	struct boot_attr boot_attr;
+
+	u8 *fw;
+	size_t fw_len;
+	u8 *nvs;
+	size_t nvs_len;
+
+	u8 bssid[ETH_ALEN];
+	u8 mac_addr[ETH_ALEN];
+	u8 bss_type;
+	u8 listen_int;
+	int channel;
+
+	void *target_mem_map;
+	struct acx_data_path_params_resp *data_path;
+
+	/* Number of TX packets transferred to the FW, modulo 16 */
+	u32 data_in_count;
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
+	/*
+	 * Index pointing to the next TX complete entry
+	 * in the cyclic XT complete array we get from
+	 * the FW.
+	 */
+	u32 next_tx_complete;
+
+	/* FW Rx counter */
+	u32 rx_counter;
+
+	/* Rx frames handled */
+	u32 rx_handled;
+
+	/* Current double buffer */
+	u32 rx_current_buffer;
+	u32 rx_last_id;
+
+	/* The target interrupt mask */
+	u32 intr_mask;
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
+	unsigned int tx_mgmt_frm_rate;
+	unsigned int tx_mgmt_frm_mod;
+
+	unsigned int rx_config;
+	unsigned int rx_filter;
+
+	/* is firmware in elp mode */
+	bool elp;
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
+	struct wl12xx_stats stats;
+	struct wl12xx_debugfs debugfs;
+
+	u32 buffer_32;
+	u32 buffer_cmd;
+	u8 buffer_busyword[WL12XX_BUSY_WORD_LEN];
+	struct wl12xx_rx_descriptor *rx_descriptor;
+};
+
+int wl12xx_plt_start(struct wl12xx *wl);
+int wl12xx_plt_stop(struct wl12xx *wl);
+
+#define DEFAULT_HW_GEN_MODULATION_TYPE    CCK_LONG /* Long Preamble */
+#define DEFAULT_HW_GEN_TX_RATE          RATE_2MBPS
+#define JOIN_TIMEOUT 5000 /* 5000 milliseconds to join */
+
+#define WL12XX_DEFAULT_POWER_LEVEL 20
+
+#define WL12XX_TX_QUEUE_MAX_LENGTH 20
+
+/* Different chips need different sleep times after power on.  WL1271 needs
+ * 200ms, WL1251 needs only 10ms.  By default we use 200ms, but as soon as we
+ * know the chip ID, we change the sleep value in the wl12xx chip structure,
+ * so in subsequent power ons, we don't waste more time then needed.  */
+#define WL12XX_DEFAULT_POWER_ON_SLEEP 200
+
+#define CHIP_ID_1251_PG10	           (0x7010101)
+#define CHIP_ID_1251_PG11	           (0x7020101)
+#define CHIP_ID_1251_PG12	           (0x7030101)
+#define CHIP_ID_1271_PG10	           (0x4030101)
+#define CHIP_ID_1271_PG20	           (0x4030111)
+
+#endif
diff --git a/drivers/net/wireless/wl12xx/wl1251_acx.c b/drivers/net/wireless/wl12xx/wl1251_acx.c
index cecc1fa..1a840fa 100644
--- a/drivers/net/wireless/wl12xx/wl1251_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1251_acx.c
@@ -4,7 +4,7 @@
 #include <linux/crc7.h>
 #include <linux/spi/spi.h>
 
-#include "wl12xx.h"
+#include "wl1251.h"
 #include "wl12xx_80211.h"
 #include "reg.h"
 #include "wl1251_spi.h"
diff --git a/drivers/net/wireless/wl12xx/wl1251_acx.h b/drivers/net/wireless/wl12xx/wl1251_acx.h
index 203f11f..a239120 100644
--- a/drivers/net/wireless/wl12xx/wl1251_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1251_acx.h
@@ -25,7 +25,7 @@
 #ifndef __WL12XX_ACX_H__
 #define __WL12XX_ACX_H__
 
-#include "wl12xx.h"
+#include "wl1251.h"
 #include "wl1251_cmd.h"
 
 /* Target's information element */
diff --git a/drivers/net/wireless/wl12xx/wl1251_boot.h b/drivers/net/wireless/wl12xx/wl1251_boot.h
index 4fa7313..3e2b766 100644
--- a/drivers/net/wireless/wl12xx/wl1251_boot.h
+++ b/drivers/net/wireless/wl12xx/wl1251_boot.h
@@ -24,7 +24,7 @@
 #ifndef __BOOT_H__
 #define __BOOT_H__
 
-#include "wl12xx.h"
+#include "wl1251.h"
 
 int wl12xx_boot_soft_reset(struct wl12xx *wl);
 int wl12xx_boot_init_seq(struct wl12xx *wl);
diff --git a/drivers/net/wireless/wl12xx/wl1251_cmd.c b/drivers/net/wireless/wl12xx/wl1251_cmd.c
index d0c2df6..92c7fb6 100644
--- a/drivers/net/wireless/wl12xx/wl1251_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1251_cmd.c
@@ -4,7 +4,7 @@
 #include <linux/crc7.h>
 #include <linux/spi/spi.h>
 
-#include "wl12xx.h"
+#include "wl1251.h"
 #include "wl12xx_80211.h"
 #include "reg.h"
 #include "wl1251_spi.h"
diff --git a/drivers/net/wireless/wl12xx/wl1251_cmd.h b/drivers/net/wireless/wl12xx/wl1251_cmd.h
index a2eae54..b252ad2 100644
--- a/drivers/net/wireless/wl12xx/wl1251_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1251_cmd.h
@@ -25,7 +25,7 @@
 #ifndef __WL12XX_CMD_H__
 #define __WL12XX_CMD_H__
 
-#include "wl12xx.h"
+#include "wl1251.h"
 
 struct acx_header;
 
diff --git a/drivers/net/wireless/wl12xx/wl1251_debugfs.c b/drivers/net/wireless/wl12xx/wl1251_debugfs.c
index a63bc78..866303d 100644
--- a/drivers/net/wireless/wl12xx/wl1251_debugfs.c
+++ b/drivers/net/wireless/wl12xx/wl1251_debugfs.c
@@ -25,7 +25,7 @@
 
 #include <linux/skbuff.h>
 
-#include "wl12xx.h"
+#include "wl1251.h"
 #include "wl1251_acx.h"
 #include "wl1251_ps.h"
 
diff --git a/drivers/net/wireless/wl12xx/wl1251_debugfs.h b/drivers/net/wireless/wl12xx/wl1251_debugfs.h
index 562cdcb..37653eb 100644
--- a/drivers/net/wireless/wl12xx/wl1251_debugfs.h
+++ b/drivers/net/wireless/wl12xx/wl1251_debugfs.h
@@ -24,7 +24,7 @@
 #ifndef WL12XX_DEBUGFS_H
 #define WL12XX_DEBUGFS_H
 
-#include "wl12xx.h"
+#include "wl1251.h"
 
 int wl12xx_debugfs_init(struct wl12xx *wl);
 void wl12xx_debugfs_exit(struct wl12xx *wl);
diff --git a/drivers/net/wireless/wl12xx/wl1251_event.c b/drivers/net/wireless/wl12xx/wl1251_event.c
index 50b5e43..a6d9234 100644
--- a/drivers/net/wireless/wl12xx/wl1251_event.c
+++ b/drivers/net/wireless/wl12xx/wl1251_event.c
@@ -22,7 +22,7 @@
  *
  */
 
-#include "wl12xx.h"
+#include "wl1251.h"
 #include "reg.h"
 #include "wl1251_spi.h"
 #include "wl1251_event.h"
diff --git a/drivers/net/wireless/wl12xx/wl1251_init.h b/drivers/net/wireless/wl12xx/wl1251_init.h
index c8b6cd0..5b3301a 100644
--- a/drivers/net/wireless/wl12xx/wl1251_init.h
+++ b/drivers/net/wireless/wl12xx/wl1251_init.h
@@ -24,7 +24,7 @@
 #ifndef __WL12XX_INIT_H__
 #define __WL12XX_INIT_H__
 
-#include "wl12xx.h"
+#include "wl1251.h"
 
 int wl12xx_hw_init_hwenc_config(struct wl12xx *wl);
 int wl12xx_hw_init_templates_config(struct wl12xx *wl);
diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 16cd46c..41b9c61 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -31,7 +31,7 @@
 #include <linux/etherdevice.h>
 #include <linux/spi/wl12xx.h>
 
-#include "wl12xx.h"
+#include "wl1251.h"
 #include "wl12xx_80211.h"
 #include "reg.h"
 #include "wl1251_ops.h"
diff --git a/drivers/net/wireless/wl12xx/wl1251_netlink.c b/drivers/net/wireless/wl12xx/wl1251_netlink.c
index 1bc049f..ca9a856 100644
--- a/drivers/net/wireless/wl12xx/wl1251_netlink.c
+++ b/drivers/net/wireless/wl12xx/wl1251_netlink.c
@@ -30,7 +30,7 @@
 #include <net/wireless.h>
 #include <net/mac80211.h>
 
-#include "wl12xx.h"
+#include "wl1251.h"
 #include "wl1251_spi.h"
 #include "wl1251_acx.h"
 
diff --git a/drivers/net/wireless/wl12xx/wl1251_ops.h b/drivers/net/wireless/wl12xx/wl1251_ops.h
index 7a78cc9..c5c997b 100644
--- a/drivers/net/wireless/wl12xx/wl1251_ops.h
+++ b/drivers/net/wireless/wl12xx/wl1251_ops.h
@@ -26,7 +26,7 @@
 
 #include <linux/bitops.h>
 
-#include "wl12xx.h"
+#include "wl1251.h"
 #include "wl1251_acx.h"
 
 #define WL1251_FW_NAME "wl1251-fw.bin"
diff --git a/drivers/net/wireless/wl12xx/wl1251_ps.h b/drivers/net/wireless/wl12xx/wl1251_ps.h
index db9f7ed..8877842 100644
--- a/drivers/net/wireless/wl12xx/wl1251_ps.h
+++ b/drivers/net/wireless/wl12xx/wl1251_ps.h
@@ -25,7 +25,7 @@
  *
  */
 
-#include "wl12xx.h"
+#include "wl1251.h"
 #include "wl1251_acx.h"
 
 int wl12xx_ps_set_mode(struct wl12xx *wl, enum wl12xx_cmd_ps_mode mode);
diff --git a/drivers/net/wireless/wl12xx/wl1251_rx.c b/drivers/net/wireless/wl12xx/wl1251_rx.c
index d73e014..280fc18 100644
--- a/drivers/net/wireless/wl12xx/wl1251_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1251_rx.c
@@ -25,7 +25,7 @@
 #include <linux/skbuff.h>
 #include <net/mac80211.h>
 
-#include "wl12xx.h"
+#include "wl1251.h"
 #include "reg.h"
 #include "wl1251_spi.h"
 #include "wl1251_rx.h"
diff --git a/drivers/net/wireless/wl12xx/wl1251_rx.h b/drivers/net/wireless/wl12xx/wl1251_rx.h
index 8a23fde..4379c53 100644
--- a/drivers/net/wireless/wl12xx/wl1251_rx.h
+++ b/drivers/net/wireless/wl12xx/wl1251_rx.h
@@ -27,6 +27,8 @@
 
 #include <linux/bitops.h>
 
+#include "wl1251.h"
+
 /*
  * RX PATH
  *
diff --git a/drivers/net/wireless/wl12xx/wl1251_spi.c b/drivers/net/wireless/wl12xx/wl1251_spi.c
index d7eee8c..5b4889e 100644
--- a/drivers/net/wireless/wl12xx/wl1251_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1251_spi.c
@@ -25,7 +25,7 @@
 #include <linux/crc7.h>
 #include <linux/spi/spi.h>
 
-#include "wl12xx.h"
+#include "wl1251.h"
 #include "wl12xx_80211.h"
 #include "reg.h"
 #include "wl1251_spi.h"
diff --git a/drivers/net/wireless/wl12xx/wl1251_tx.c b/drivers/net/wireless/wl12xx/wl1251_tx.c
index c57330e..00c5649 100644
--- a/drivers/net/wireless/wl12xx/wl1251_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1251_tx.c
@@ -25,7 +25,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 
-#include "wl12xx.h"
+#include "wl1251.h"
 #include "reg.h"
 #include "wl1251_spi.h"
 #include "wl1251_tx.h"
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
deleted file mode 100644
index c673cdb..0000000
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ /dev/null
@@ -1,420 +0,0 @@
-/*
- * This file is part of wl12xx
- *
- * Copyright (c) 1998-2007 Texas Instruments Incorporated
- * Copyright (C) 2008-2009 Nokia Corporation
- *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#ifndef __WL12XX_H__
-#define __WL12XX_H__
-
-#include <linux/mutex.h>
-#include <linux/list.h>
-#include <linux/bitops.h>
-#include <net/mac80211.h>
-
-#define DRIVER_NAME "wl12xx"
-#define DRIVER_PREFIX DRIVER_NAME ": "
-
-enum {
-	DEBUG_NONE	= 0,
-	DEBUG_IRQ	= BIT(0),
-	DEBUG_SPI	= BIT(1),
-	DEBUG_BOOT	= BIT(2),
-	DEBUG_MAILBOX	= BIT(3),
-	DEBUG_NETLINK	= BIT(4),
-	DEBUG_EVENT	= BIT(5),
-	DEBUG_TX	= BIT(6),
-	DEBUG_RX	= BIT(7),
-	DEBUG_SCAN	= BIT(8),
-	DEBUG_CRYPT	= BIT(9),
-	DEBUG_PSM	= BIT(10),
-	DEBUG_MAC80211	= BIT(11),
-	DEBUG_CMD	= BIT(12),
-	DEBUG_ACX	= BIT(13),
-	DEBUG_ALL	= ~0,
-};
-
-#define DEBUG_LEVEL (DEBUG_NONE)
-
-#define DEBUG_DUMP_LIMIT 1024
-
-#define wl12xx_error(fmt, arg...) \
-	printk(KERN_ERR DRIVER_PREFIX "ERROR " fmt "\n", ##arg)
-
-#define wl12xx_warning(fmt, arg...) \
-	printk(KERN_WARNING DRIVER_PREFIX "WARNING " fmt "\n", ##arg)
-
-#define wl12xx_notice(fmt, arg...) \
-	printk(KERN_INFO DRIVER_PREFIX fmt "\n", ##arg)
-
-#define wl12xx_info(fmt, arg...) \
-	printk(KERN_DEBUG DRIVER_PREFIX fmt "\n", ##arg)
-
-#define wl12xx_debug(level, fmt, arg...) \
-	do { \
-		if (level & DEBUG_LEVEL) \
-			printk(KERN_DEBUG DRIVER_PREFIX fmt "\n", ##arg); \
-	} while (0)
-
-#define wl12xx_dump(level, prefix, buf, len)	\
-	do { \
-		if (level & DEBUG_LEVEL) \
-			print_hex_dump(KERN_DEBUG, DRIVER_PREFIX prefix, \
-				       DUMP_PREFIX_OFFSET, 16, 1,	\
-				       buf,				\
-				       min_t(size_t, len, DEBUG_DUMP_LIMIT), \
-				       0);				\
-	} while (0)
-
-#define wl12xx_dump_ascii(level, prefix, buf, len)	\
-	do { \
-		if (level & DEBUG_LEVEL) \
-			print_hex_dump(KERN_DEBUG, DRIVER_PREFIX prefix, \
-				       DUMP_PREFIX_OFFSET, 16, 1,	\
-				       buf,				\
-				       min_t(size_t, len, DEBUG_DUMP_LIMIT), \
-				       true);				\
-	} while (0)
-
-#define WL12XX_DEFAULT_RX_CONFIG (CFG_UNI_FILTER_EN |	\
-				  CFG_BSSID_FILTER_EN)
-
-#define WL12XX_DEFAULT_RX_FILTER (CFG_RX_PRSP_EN |  \
-				  CFG_RX_MGMT_EN |  \
-				  CFG_RX_DATA_EN |  \
-				  CFG_RX_CTL_EN |   \
-				  CFG_RX_BCN_EN |   \
-				  CFG_RX_AUTH_EN |  \
-				  CFG_RX_ASSOC_EN)
-
-#define WL12XX_BUSY_WORD_LEN 8
-
-struct boot_attr {
-	u32 radio_type;
-	u8 mac_clock;
-	u8 arm_clock;
-	int firmware_debug;
-	u32 minor;
-	u32 major;
-	u32 bugfix;
-};
-
-enum wl12xx_state {
-	WL12XX_STATE_OFF,
-	WL12XX_STATE_ON,
-	WL12XX_STATE_PLT,
-};
-
-enum wl12xx_partition_type {
-	PART_DOWN,
-	PART_WORK,
-	PART_DRPW,
-
-	PART_TABLE_LEN
-};
-
-struct wl12xx_partition {
-	u32 size;
-	u32 start;
-};
-
-struct wl12xx_partition_set {
-	struct wl12xx_partition mem;
-	struct wl12xx_partition reg;
-};
-
-struct wl12xx;
-
-/* FIXME: I'm not sure about this structure name */
-struct wl12xx_chip {
-	u32 id;
-
-	const char *fw_filename;
-	const char *nvs_filename;
-
-	char fw_ver[21];
-
-	unsigned int power_on_sleep;
-	int intr_cmd_complete;
-	int intr_init_complete;
-
-	int (*op_upload_fw)(struct wl12xx *wl);
-	int (*op_upload_nvs)(struct wl12xx *wl);
-	int (*op_boot)(struct wl12xx *wl);
-	void (*op_set_ecpu_ctrl)(struct wl12xx *wl, u32 flag);
-	void (*op_target_enable_interrupts)(struct wl12xx *wl);
-	int (*op_hw_init)(struct wl12xx *wl);
-	int (*op_plt_init)(struct wl12xx *wl);
-	void (*op_tx_flush)(struct wl12xx *wl);
-	void (*op_fw_version)(struct wl12xx *wl);
-	int (*op_cmd_join)(struct wl12xx *wl, u8 bss_type, u8 dtim_interval,
-			    u16 beacon_interval, u8 wait);
-
-	struct wl12xx_partition_set *p_table;
-	enum wl12xx_acx_int_reg *acx_reg_table;
-};
-
-struct wl12xx_stats {
-	struct acx_statistics *fw_stats;
-	unsigned long fw_stats_update;
-
-	unsigned int retry_count;
-	unsigned int excessive_retries;
-};
-
-struct wl12xx_debugfs {
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
-};
-
-struct wl12xx {
-	struct ieee80211_hw *hw;
-	bool mac80211_registered;
-
-	struct spi_device *spi;
-
-	void (*set_power)(bool enable);
-	int irq;
-
-	enum wl12xx_state state;
-	struct mutex mutex;
-
-	int physical_mem_addr;
-	int physical_reg_addr;
-	int virtual_mem_addr;
-	int virtual_reg_addr;
-
-	struct wl12xx_chip chip;
-
-	int cmd_box_addr;
-	int event_box_addr;
-	struct boot_attr boot_attr;
-
-	u8 *fw;
-	size_t fw_len;
-	u8 *nvs;
-	size_t nvs_len;
-
-	u8 bssid[ETH_ALEN];
-	u8 mac_addr[ETH_ALEN];
-	u8 bss_type;
-	u8 listen_int;
-	int channel;
-
-	void *target_mem_map;
-	struct acx_data_path_params_resp *data_path;
-
-	/* Number of TX packets transferred to the FW, modulo 16 */
-	u32 data_in_count;
-
-	/* Frames scheduled for transmission, not handled yet */
-	struct sk_buff_head tx_queue;
-	bool tx_queue_stopped;
-
-	struct work_struct tx_work;
-	struct work_struct filter_work;
-
-	/* Pending TX frames */
-	struct sk_buff *tx_frames[16];
-
-	/*
-	 * Index pointing to the next TX complete entry
-	 * in the cyclic XT complete array we get from
-	 * the FW.
-	 */
-	u32 next_tx_complete;
-
-	/* FW Rx counter */
-	u32 rx_counter;
-
-	/* Rx frames handled */
-	u32 rx_handled;
-
-	/* Current double buffer */
-	u32 rx_current_buffer;
-	u32 rx_last_id;
-
-	/* The target interrupt mask */
-	u32 intr_mask;
-	struct work_struct irq_work;
-
-	/* The mbox event mask */
-	u32 event_mask;
-
-	/* Mailbox pointers */
-	u32 mbox_ptr[2];
-
-	/* Are we currently scanning */
-	bool scanning;
-
-	/* Our association ID */
-	u16 aid;
-
-	/* Default key (for WEP) */
-	u32 default_key;
-
-	unsigned int tx_mgmt_frm_rate;
-	unsigned int tx_mgmt_frm_mod;
-
-	unsigned int rx_config;
-	unsigned int rx_filter;
-
-	/* is firmware in elp mode */
-	bool elp;
-
-	/* we can be in psm, but not in elp, we have to differentiate */
-	bool psm;
-
-	/* PSM mode requested */
-	bool psm_requested;
-
-	/* in dBm */
-	int power_level;
-
-	struct wl12xx_stats stats;
-	struct wl12xx_debugfs debugfs;
-
-	u32 buffer_32;
-	u32 buffer_cmd;
-	u8 buffer_busyword[WL12XX_BUSY_WORD_LEN];
-	struct wl12xx_rx_descriptor *rx_descriptor;
-};
-
-int wl12xx_plt_start(struct wl12xx *wl);
-int wl12xx_plt_stop(struct wl12xx *wl);
-
-#define DEFAULT_HW_GEN_MODULATION_TYPE    CCK_LONG /* Long Preamble */
-#define DEFAULT_HW_GEN_TX_RATE          RATE_2MBPS
-#define JOIN_TIMEOUT 5000 /* 5000 milliseconds to join */
-
-#define WL12XX_DEFAULT_POWER_LEVEL 20
-
-#define WL12XX_TX_QUEUE_MAX_LENGTH 20
-
-/* Different chips need different sleep times after power on.  WL1271 needs
- * 200ms, WL1251 needs only 10ms.  By default we use 200ms, but as soon as we
- * know the chip ID, we change the sleep value in the wl12xx chip structure,
- * so in subsequent power ons, we don't waste more time then needed.  */
-#define WL12XX_DEFAULT_POWER_ON_SLEEP 200
-
-#define CHIP_ID_1251_PG10	           (0x7010101)
-#define CHIP_ID_1251_PG11	           (0x7020101)
-#define CHIP_ID_1251_PG12	           (0x7030101)
-#define CHIP_ID_1271_PG10	           (0x4030101)
-#define CHIP_ID_1271_PG20	           (0x4030111)
-
-#endif

