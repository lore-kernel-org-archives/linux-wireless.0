Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redpinesignals.com ([203.196.161.92]:55446 "EHLO
	mail.redpinesignals.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbaCCH5J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 02:57:09 -0500
Received: from [192.168.40.2] ([192.168.40.2])
	(authenticated user fariya.f@redpinesignals.com)
	by mail.redpinesignals.com
	for linux-wireless@vger.kernel.org;
	Mon, 3 Mar 2014 13:27:04 +0530
Message-ID: <5314357A.8090205@redpinesignals.com> (sfid-20140303_085748_342821_9E04171F)
Date: Mon, 03 Mar 2014 13:25:38 +0530
From: Fariya Fatima <fariya.f@redpinesignals.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3.14.0-rc5 v3 1/10] rsi: Adding RS9113 driver files
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fariya Fatima

This driver supports the RS9113 chipset from Redpine Signals Inc. This
driver
supports the IEEE 802.11 b/g/n standard. Both SDIO and USB interfaces are supported.
This patch contains the include files.

Signed-off-by: Fariya Fatima <fariya.f@redpinesignals.com>
---

 Kconfig               |    1 
 Makefile              |    1 
 rsi/Kconfig           |   31 ++++++
 rsi/Makefile          |   12 ++
 rsi/rsi_boot_params.h |  126 +++++++++++++++++++++++++++
 rsi/rsi_debugfs.h     |   52 +++++++++++diff -rupN linux-3.14-rc5/drivers/net/wireless/Kconfig linux-3.14-rc5_new/drivers/net/wireless/Kconfig
--- linux-3.14-rc5/drivers/net/wireless/Kconfig	2014-03-03 08:41:16.000000000 +0545
+++ linux-3.14-rc5_new/drivers/net/wireless/Kconfig	2014-03-04 06:55:03.362958376 +0545
@@ -281,5 +281,6 @@ source "drivers/net/wireless/ti/Kconfig"
 source "drivers/net/wireless/zd1211rw/Kconfig"
 source "drivers/net/wireless/mwifiex/Kconfig"
 source "drivers/net/wireless/cw1200/Kconfig"
+source "drivers/net/wireless/rsi/Kconfig"
 
 endif # WLAN
diff -rupN linux-3.14-rc5/drivers/net/wireless/Makefile linux-3.14-rc5_new/drivers/net/wireless/Makefile
--- linux-3.14-rc5/drivers/net/wireless/Makefile	2014-03-03 08:41:16.000000000 +0545
+++ linux-3.14-rc5_new/drivers/net/wireless/Makefile	2014-03-04 06:55:17.131786241 +0545
@@ -59,3 +59,4 @@ obj-$(CONFIG_BRCMFMAC)	+= brcm80211/
 obj-$(CONFIG_BRCMSMAC)	+= brcm80211/
 
 obj-$(CONFIG_CW1200)	+= cw1200/
+obj-$(CONFIG_RSI_91x)	+= rsi/
diff -rupN linux-3.14-rc5/drivers/net/wireless/rsi/Kconfig linux-3.14-rc5_new/drivers/net/wireless/rsi/Kconfig
--- linux-3.14-rc5/drivers/net/wireless/rsi/Kconfig	1970-01-01 05:30:00.000000000 +0530
+++ linux-3.14-rc5_new/drivers/net/wireless/rsi/Kconfig	2014-03-04 06:54:16.502544211 +0545
@@ -0,0 +1,31 @@
+config RSI_91x
+	tristate "Redpine Signals Inc 91x WLAN driver support"
+	depends on MAC80211
+	default m
+	---help---
+	  This option enabes support for RSI 1x1 devices.
+	  Select M (recommended), if you have a RSI 1x1 wireless module.
+
+config RSI_DEBUGFS
+	bool "Redpine Signals Inc debug support"
+	depends on RSI_91x
+	default y
+	---help---
+	 Say Y, if you would like to enable debug support. This option
+	 creates debugfs entries 
+
+config RSI_SDIO
+	tristate "Redpine Signals SDIO bus support"
+	depends on MMC && RSI_91x
+	default m
+	---help---
+	  This option enables the SDIO bus support in rsi drivers.
+	  Select M (recommended), if you have a RSI 1x1 wireless module.
+
+config RSI_USB
+	tristate "Redpine Signals USB bus support"
+	depends on USB && RSI_91x
+	default m
+	---help---
+	  This option enables the USB bus support in rsi drivers.
+	  Select M (recommended), if you have a RSI 1x1 wireless module.
diff -rupN linux-3.14-rc5/drivers/net/wireless/rsi/Makefile linux-3.14-rc5_new/drivers/net/wireless/rsi/Makefile
--- linux-3.14-rc5/drivers/net/wireless/rsi/Makefile	1970-01-01 05:30:00.000000000 +0530
+++ linux-3.14-rc5_new/drivers/net/wireless/rsi/Makefile	2014-03-04 06:54:16.531543849 +0545
@@ -0,0 +1,12 @@
+rsi_91x-y			+= rsi_91x_main.o 
+rsi_91x-y			+= rsi_91x_core.o
+rsi_91x-y			+= rsi_91x_mac80211.o
+rsi_91x-y			+= rsi_91x_mgmt.o
+rsi_91x-y			+= rsi_91x_pkt.o
+rsi_91x-$(CONFIG_RSI_DEBUGFS)	+= rsi_91x_debugfs.o
+
+rsi_usb-y			+= rsi_91x_usb.o rsi_91x_usb_ops.o
+rsi_sdio-y			+= rsi_91x_sdio.o rsi_91x_sdio_ops.o
+obj-$(CONFIG_RSI_91x) 		+= rsi_91x.o
+obj-$(CONFIG_RSI_SDIO)		+= rsi_sdio.o
+obj-$(CONFIG_RSI_USB)		+= rsi_usb.o
diff -rupN linux-3.14-rc5/drivers/net/wireless/rsi/rsi_boot_params.h linux-3.14-rc5_new/drivers/net/wireless/rsi/rsi_boot_params.h
--- linux-3.14-rc5/drivers/net/wireless/rsi/rsi_boot_params.h	1970-01-01 05:30:00.000000000 +0530
+++ linux-3.14-rc5_new/drivers/net/wireless/rsi/rsi_boot_params.h	2014-03-04 06:54:16.382545711 +0545
@@ -0,0 +1,126 @@
+/**
+ * Copyright (c) 2014 Redpine Signals Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef __RSI_BOOTPARAMS_HEADER_H__
+#define __RSI_BOOTPARAMS_HEADER_H__
+
+#define CRYSTAL_GOOD_TIME                BIT(0)
+#define BOOTUP_MODE_INFO                 BIT(1)
+#define WIFI_TAPLL_CONFIGS               BIT(5)
+#define WIFI_PLL960_CONFIGS              BIT(6)
+#define WIFI_AFEPLL_CONFIGS              BIT(7)
+#define WIFI_SWITCH_CLK_CONFIGS          BIT(8)
+
+#define TA_PLL_M_VAL_20                  8
+#define TA_PLL_N_VAL_20                  1
+#define TA_PLL_P_VAL_20                  4
+
+#define PLL960_M_VAL_20                  0x14
+#define PLL960_N_VAL_20                  0
+#define PLL960_P_VAL_20                  5
+
+#define UMAC_CLK_40MHZ                   40
+
+#define TA_PLL_M_VAL_40                  46
+#define TA_PLL_N_VAL_40                  3
+#define TA_PLL_P_VAL_40                  3
+
+#define PLL960_M_VAL_40                  0x14
+#define PLL960_N_VAL_40                  0
+#define PLL960_P_VAL_40                  5
+
+#define UMAC_CLK_20BW \
+	(((TA_PLL_M_VAL_20 + 1) * 40) / \
+	 ((TA_PLL_N_VAL_20 + 1) * (TA_PLL_P_VAL_20 + 1)))
+#define VALID_20 \
+	(WIFI_PLL960_CONFIGS | WIFI_AFEPLL_CONFIGS | WIFI_SWITCH_CLK_CONFIGS)
+#define UMAC_CLK_40BW   \
+	(((TA_PLL_M_VAL_40 + 1) * 40) / \
+	 ((TA_PLL_N_VAL_40 + 1) * (TA_PLL_P_VAL_40 + 1)))
+#define VALID_40 \
+	(WIFI_PLL960_CONFIGS | WIFI_AFEPLL_CONFIGS | WIFI_SWITCH_CLK_CONFIGS | \
+	 WIFI_TAPLL_CONFIGS | CRYSTAL_GOOD_TIME | BOOTUP_MODE_INFO)
+
+/* structure to store configs related to TAPLL programming */
+struct tapll_info {
+	__le16 pll_reg_1;
+	__le16 pll_reg_2;
+} __packed;
+
+/* structure to store configs related to PLL960 programming */
+struct pll960_info {
+	__le16 pll_reg_1;
+	__le16 pll_reg_2;
+	__le16 pll_reg_3;
+} __packed;
+
+/* structure to store configs related to AFEPLL programming */
+struct afepll_info {
+	__le16 pll_reg;
+} __packed;
+
+/* structure to store configs related to pll configs */
+struct pll_config {
+	struct tapll_info tapll_info_g;
+	struct pll960_info pll960_info_g;
+	struct afepll_info afepll_info_g;
+} __packed;
+
+/* structure to store configs related to UMAC clk programming */
+struct switch_clk {
+	__le16 switch_clk_info;
+	/* If switch_bbp_lmac_clk_reg is set then this value will be programmed
+	 * into reg
+	 */
+	__le16 bbp_lmac_clk_reg_val;
+	/* if switch_umac_clk is set then this value will be programmed */
+	__le16 umac_clock_reg_config;
+	/* if switch_qspi_clk is set then this value will be programmed */
+	__le16 qspi_uart_clock_reg_config;
+} __packed;
+
+struct device_clk_info {
+	struct pll_config pll_config_g;
+	struct switch_clk switch_clk_g;
+} __packed;
+
+struct bootup_params {
+	__le16 magic_number;
+	__le16 crystal_good_time;
+	__le32 valid;
+	__le32 reserved_for_valids;
+	__le16 bootup_mode_info;
+	/* configuration used for digital loop back */
+	__le16 digital_loop_back_params;
+	__le16 rtls_timestamp_en;
+	__le16 host_spi_intr_cfg;
+	struct device_clk_info device_clk_info[3];
+	/* ulp buckboost wait time  */
+	__le32 buckboost_wakeup_cnt;
+	/* pmu wakeup wait time & WDT EN info */
+	__le16 pmu_wakeup_wait;
+	u8 shutdown_wait_time;
+	/* Sleep clock source selection */
+	u8 pmu_slp_clkout_sel;
+	/* WDT programming values */
+	__le32 wdt_prog_value;
+	/* WDT soc reset delay */
+	__le32 wdt_soc_rst_delay;
+	/* dcdc modes configs */
+	__le32 dcdc_operation_mode;
+	__le32 soc_reset_wait_cnt;
+} __packed;
+#endif
diff -rupN linux-3.14-rc5/drivers/net/wireless/rsi/rsi_debugfs.h linux-3.14-rc5_new/drivers/net/wireless/rsi/rsi_debugfs.h
--- linux-3.14-rc5/drivers/net/wireless/rsi/rsi_debugfs.h	1970-01-01 05:30:00.000000000 +0530
+++ linux-3.14-rc5_new/drivers/net/wireless/rsi/rsi_debugfs.h	2014-03-04 06:54:16.533543824 +0545
@@ -0,0 +1,52 @@
+/**
+ * Copyright (c) 2014 Redpine Signals Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef __RSI_DEBUGFS_H__
+#define __RSI_DEBUGFS_H__
+
+#include "rsi_main.h"
+#include <linux/debugfs.h>
+
+#define FOPS(fopen) { \
+	.owner = THIS_MODULE, \
+	.open = (fopen), \
+	.read = seq_read, \
+	.llseek = seq_lseek, \
+}
+
+#define FOPS_RW(fopen, fwrite) { \
+	.owner = THIS_MODULE, \
+	.open = (fopen), \
+	.read = seq_read, \
+	.llseek = seq_lseek, \
+	.write = (fwrite), \
+}
+
+struct rsi_dbg_files {
+	const char *name;
+	umode_t perms;
+	const struct file_operations fops;
+};
+
+struct rsi_debugfs {
+	struct dentry *subdir;
+	struct rsi_dbg_ops *dfs_get_ops;
+	struct dentry *rsi_files[MAX_DEBUGFS_ENTRIES];
+};
+
+int rsi_init_dbgfs(struct rsi_hw *adapter);
+void rsi_remove_dbgfs(struct rsi_hw *adapter);
+#endif
diff -rupN linux-3.14-rc5/drivers/net/wireless/rsi/rsi_main.h linux-3.14-rc5_new/drivers/net/wireless/rsi/rsi_main.h
--- linux-3.14-rc5/drivers/net/wireless/rsi/rsi_main.h	1970-01-01 05:30:00.000000000 +0530
+++ linux-3.14-rc5_new/drivers/net/wireless/rsi/rsi_main.h	2014-03-04 06:54:16.490544361 +0545
@@ -0,0 +1,232 @@
+/**
+ * Copyright (c) 2014 Redpine Signals Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef __RSI_MAIN_H__
+#define __RSI_MAIN_H__
+
+#include <linux/string.h>
+#include <linux/skbuff.h>
+#include <net/mac80211.h>
+
+#define ERR_ZONE                        BIT(0)  /* For Error Msgs             */
+#define INFO_ZONE                       BIT(1)  /* For General Status Msgs    */
+#define INIT_ZONE                       BIT(2)  /* For Driver Init Seq Msgs   */
+#define MGMT_TX_ZONE                    BIT(3)  /* For TX Mgmt Path Msgs      */
+#define MGMT_RX_ZONE                    BIT(4)  /* For RX Mgmt Path Msgs      */
+#define DATA_TX_ZONE                    BIT(5)  /* For TX Data Path Msgs      */
+#define DATA_RX_ZONE                    BIT(6)  /* For RX Data Path Msgs      */
+#define FSM_ZONE                        BIT(7)  /* For State Machine Msgs     */
+#define ISR_ZONE                        BIT(8)  /* For Interrupt Msgs         */
+
+#define FSM_CARD_NOT_READY              0
+#define FSM_BOOT_PARAMS_SENT            1
+#define FSM_EEPROM_READ_MAC_ADDR        2
+#define FSM_RESET_MAC_SENT              3
+#define FSM_RADIO_CAPS_SENT             4
+#define FSM_BB_RF_PROG_SENT             5
+#define FSM_MAC_INIT_DONE               6
+
+extern u32 rsi_zone_enabled;
+
+static inline void rsi_dbg(u32 zone, const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	if (zone & rsi_zone_enabled)
+		pr_info("%pV", &vaf);
+	va_end(args);
+}
+
+#define RSI_MAX_VIFS                    1
+#define NUM_EDCA_QUEUES                 4
+#define IEEE80211_ADDR_LEN              6
+#define FRAME_DESC_SZ                   16
+#define MIN_802_11_HDR_LEN              24
+
+#define DATA_QUEUE_WATER_MARK           400
+#define MIN_DATA_QUEUE_WATER_MARK       300
+#define MULTICAST_WATER_MARK            200
+#define MAC_80211_HDR_FRAME_CONTROL     0
+#define WME_NUM_AC                      4
+#define NUM_SOFT_QUEUES                 5
+#define MAX_HW_QUEUES                   8
+#define INVALID_QUEUE                   0xff
+#define MAX_CONTINUOUS_VO_PKTS          8
+#define MAX_CONTINUOUS_VI_PKTS          4
+
+/* Queue information */
+#define RSI_WIFI_MGMT_Q                 0x4
+#define RSI_WIFI_DATA_Q                 0x5
+#define IEEE80211_MGMT_FRAME            0x00
+#define IEEE80211_CTL_FRAME             0x04
+
+#define IEEE80211_QOS_TID               0x0f
+#define IEEE80211_NONQOS_TID            16
+
+#define MAX_DEBUGFS_ENTRIES             4
+
+#define TID_TO_WME_AC(_tid) (      \
+	((_tid) == 0 || (_tid) == 3) ? BE_Q : \
+	((_tid) < 3) ? BK_Q : \
+	((_tid) < 6) ? VI_Q : \
+	VO_Q)
+
+#define WME_AC(_q) (    \
+	((_q) == BK_Q) ? IEEE80211_AC_BK : \
+	((_q) == BE_Q) ? IEEE80211_AC_BE : \
+	((_q) == VI_Q) ? IEEE80211_AC_VI : \
+	IEEE80211_AC_VO)
+
+struct version_info {
+	u16 major;
+	u16 minor;
+	u16 release_num;
+	u16 patch_num;
+} __packed;
+
+struct skb_info {
+	s8 rssi;
+	u32 flags;
+	u16 channel;
+	s8 tid;
+	s8 sta_id;
+};
+
+enum EDCA_QUEUE {
+	BK_Q,
+	BE_Q,
+	VI_Q,
+	VO_Q,
+	MGMT_SOFT_Q
+};
+
+struct security_info {
+	bool security_enable;
+	u32 ptk_cipher;
+	u32 gtk_cipher;
+};
+
+struct wmm_qinfo {
+	s32 weight;
+	s32 wme_params;
+	s32 pkt_contended;
+};
+
+struct transmit_q_stats {
+	u32 total_tx_pkt_send[NUM_EDCA_QUEUES + 1];
+	u32 total_tx_pkt_freed[NUM_EDCA_QUEUES + 1];
+};
+
+struct vif_priv {
+	bool is_ht;
+	bool sgi;
+	u16 seq_start;
+};
+
+struct rsi_event {
+	atomic_t event_condition;
+	wait_queue_head_t event_queue;
+};
+
+struct rsi_thread {
+	void (*thread_function)(void *);
+	struct completion completion;
+	struct task_struct *task;
+	struct rsi_event event;
+	atomic_t thread_done;
+};
+
+struct rsi_hw;
+
+struct rsi_common {
+	struct rsi_hw *priv;
+	struct vif_priv vif_info[RSI_MAX_VIFS];
+
+	bool mgmt_q_block;
+	struct version_info driver_ver;
+	struct version_info fw_ver;
+
+	struct rsi_thread tx_thread;
+	struct sk_buff_head tx_queue[NUM_EDCA_QUEUES + 1];
+	/* Mutex declaration */
+	struct mutex mutex;
+	/* Mutex used between tx/rx threads */
+	struct mutex tx_rxlock;
+	u8 endpoint;
+
+	/* Channel/band related */
+	u8 band;
+	u8 channel_width;
+
+	u16 rts_threshold;
+	u16 bitrate_mask[2];
+	u32 fixedrate_mask[2];
+
+	u8 rf_reset;
+	struct transmit_q_stats tx_stats;
+	struct security_info secinfo;
+	struct wmm_qinfo tx_qinfo[NUM_EDCA_QUEUES];
+	struct ieee80211_tx_queue_params edca_params[NUM_EDCA_QUEUES];
+	u8 mac_addr[IEEE80211_ADDR_LEN];
+
+	/* state related */
+	u32 fsm_state;
+	bool init_done;
+	u8 bb_rf_prog_count;
+	bool iface_down;
+
+	/* Generic */
+	u8 channel;
+	u8 *rx_data_pkt;
+	u8 mac_id;
+	u8 radio_id;
+	u16 rate_pwr[20];
+	u16 min_rate;
+
+	/* WMM algo related */
+	u8 selected_qnum;
+	u32 pkt_cnt;
+	u8 min_weight;
+};
+
+struct rsi_hw {
+	struct rsi_common *priv;
+	struct ieee80211_hw *hw;
+	struct ieee80211_vif *vifs[RSI_MAX_VIFS];
+	struct ieee80211_tx_queue_params edca_params[NUM_EDCA_QUEUES];
+	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
+
+	struct device *device;
+	u8 sc_nvifs;
+
+#ifdef CONFIG_RSI_DEBUGFS
+	struct rsi_debugfs *dfsentry;
+	u8 num_debugfs_entries;
+#endif
+	void *rsi_dev;
+	int (*host_intf_read_pkt)(struct rsi_hw *adapter, u8 *pkt, u32 len);
+	int (*host_intf_write_pkt)(struct rsi_hw *adapter, u8 *pkt, u32 len);
+	int (*check_hw_queue_status)(struct rsi_hw *adapter, u8 q_num);
+	int (*rx_urb_submit)(struct rsi_hw *adapter);
+	int (*determine_event_timeout)(struct rsi_hw *adapter);
+};
+#endif
diff -rupN linux-3.14-rc5/drivers/net/wireless/rsi/rsi_sdio.h linux-3.14-rc5_new/drivers/net/wireless/rsi/rsi_sdio.h
--- linux-3.14-rc5/drivers/net/wireless/rsi/rsi_sdio.h	1970-01-01 05:30:00.000000000 +0530
+++ linux-3.14-rc5_new/drivers/net/wireless/rsi/rsi_sdio.h	2014-03-04 06:54:16.491544349 +0545
@@ -0,0 +1,129 @@
+/**
+ * @section LICENSE
+ * Copyright (c) 2014 Redpine Signals Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ *
+ */
+
+#ifndef __RSI_SDIO_INTF__
+#define __RSI_SDIO_INTF__
+
+#include <linux/mmc/card.h>
+#include <linux/mmc/mmc.h>
+#include <linux/mmc/host.h>
+#include <linux/mmc/sdio_func.h>
+#include <linux/mmc/sdio.h>
+#include <linux/mmc/sd.h>
+#include <linux/mmc/sdio_ids.h>
+#include "rsi_main.h"
+
+enum SDIO_INTERRUPT_TYPE {
+	BUFFER_FULL         = 0x0,
+	BUFFER_AVAILABLE    = 0x1,
+	FIRMWARE_ASSERT_IND = 0x3,
+	MSDU_PACKET_PENDING = 0x4,
+	UNKNOWN_INT         = 0XE
+};
+
+/* Buffer status register related info */
+#define PKT_BUFF_SEMI_FULL                      0
+#define PKT_BUFF_FULL                           1
+#define PKT_MGMT_BUFF_FULL                      2
+#define MSDU_PKT_PENDING                        3
+/* Interrupt Bit Related Macros */
+#define PKT_BUFF_AVAILABLE                      0
+#define FW_ASSERT_IND                           2
+
+#define RSI_DEVICE_BUFFER_STATUS_REGISTER       0xf3
+#define RSI_FN1_INT_REGISTER                    0xf9
+#define RSI_SD_REQUEST_MASTER                   0x10000
+
+/* FOR SD CARD ONLY */
+#define SDIO_RX_NUM_BLOCKS_REG                  0x000F1
+#define SDIO_FW_STATUS_REG                      0x000F2
+#define SDIO_NXT_RD_DELAY2                      0x000F5
+#define SDIO_MASTER_ACCESS_MSBYTE               0x000FA
+#define SDIO_MASTER_ACCESS_LSBYTE               0x000FB
+#define SDIO_READ_START_LVL                     0x000FC
+#define SDIO_READ_FIFO_CTL                      0x000FD
+#define SDIO_WRITE_FIFO_CTL                     0x000FE
+#define SDIO_FUN1_INTR_CLR_REG                  0x0008
+#define SDIO_REG_HIGH_SPEED                     0x0013
+
+#define RSI_GET_SDIO_INTERRUPT_TYPE(_I, TYPE)      \
+	{					   \
+		TYPE =                             \
+		(_I & (1 << PKT_BUFF_AVAILABLE)) ? \
+		BUFFER_AVAILABLE :		   \
+		(_I & (1 << MSDU_PKT_PENDING)) ?   \
+		MSDU_PACKET_PENDING :              \
+		(_I & (1 << FW_ASSERT_IND)) ?      \
+		FIRMWARE_ASSERT_IND : UNKNOWN_INT; \
+	}
+
+/* common registers in SDIO function1 */
+#define TA_SOFT_RESET_REG            0x0004
+#define TA_TH0_PC_REG                0x0400
+#define TA_HOLD_THREAD_REG           0x0844
+#define TA_RELEASE_THREAD_REG        0x0848
+
+#define TA_SOFT_RST_CLR              0
+#define TA_SOFT_RST_SET              BIT(0)
+#define TA_PC_ZERO                   0
+#define TA_HOLD_THREAD_VALUE         cpu_to_le32(0xF)
+#define TA_RELEASE_THREAD_VALUE      cpu_to_le32(0xF)
+#define TA_BASE_ADDR                 0x2200
+#define MISC_CFG_BASE_ADDR           0x4150
+
+struct receive_info {
+	bool buffer_full;
+	bool semi_buffer_full;
+	bool mgmt_buffer_full;
+	u32 mgmt_buf_full_counter;
+	u32 buf_semi_full_counter;
+	u8 watch_bufferfull_count;
+	u32 sdio_intr_status_zero;
+	u32 sdio_int_counter;
+	u32 total_sdio_msdu_pending_intr;
+	u32 total_sdio_unknown_intr;
+	u32 buf_full_counter;
+	u32 buf_avilable_counter;
+};
+
+struct rsi_91x_sdiodev {
+	struct sdio_func *pfunction;
+	struct task_struct *in_sdio_litefi_irq;
+	struct receive_info rx_info;
+	u32 next_read_delay;
+	u32 sdio_high_speed_enable;
+	u8 sdio_clock_speed;
+	u32 cardcapability;
+	u8 prev_desc[16];
+	u32 tx_blk_size;
+	u8 write_fail;
+};
+
+void rsi_interrupt_handler(struct rsi_hw *adapter);
+int rsi_init_sdio_slave_regs(struct rsi_hw *adapter);
+int rsi_device_init(struct rsi_common *common);
+int rsi_read_register(struct rsi_hw *adapter, u32 addr, u8 *data);
+int rsi_host_intf_read_pkt(struct rsi_hw *adapter, u8 *pkt, u32 length);
+int rsi_host_intf_write_pkt(struct rsi_hw *adapter, u8 *pkt, u32 len);
+int rsi_write_register(struct rsi_hw *adapter, u8 function, u32 addr, u8 *data);
+int rsi_write_register_multiple(struct rsi_hw *adapter, u32 addr,
+				u8 *data, u32 count);
+void rsi_ack_interrupt(struct rsi_hw *adapter, u8 int_bit);
+int rsi_determine_event_timeout(struct rsi_hw *adapter);
+int rsi_read_buffer_status_register(struct rsi_hw *adapter, u8 q_num);
+#endif
diff -rupN linux-3.14-rc5/drivers/net/wireless/rsi/rsi_usb.h linux-3.14-rc5_new/drivers/net/wireless/rsi/rsi_usb.h
--- linux-3.14-rc5/drivers/net/wireless/rsi/rsi_usb.h	1970-01-01 05:30:00.000000000 +0530
+++ linux-3.14-rc5_new/drivers/net/wireless/rsi/rsi_usb.h	2014-03-04 06:54:16.532543836 +0545
@@ -0,0 +1,70 @@
+/**
+ * @section LICENSE
+ * Copyright (c) 2014 Redpine Signals Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef __RSI_USB_INTF__
+#define __RSI_USB_INTF__
+
+#include <linux/usb.h>
+#include "rsi_main.h"
+#include "rsi_common.h"
+
+#define USB_INTERNAL_REG_1           0x25000
+#define RSI_USB_READY_MAGIC_NUM      0xab
+#define FW_STATUS_REG                0x41050012
+
+#define USB_VENDOR_REGISTER_READ     0x15
+#define USB_VENDOR_REGISTER_WRITE    0x16
+#define RSI_USB_TX_HEAD_ROOM         128
+
+#define MAX_RX_URBS                  1
+#define MAX_BULK_EP                  8
+#define MGMT_EP                      1
+#define DATA_EP                      2
+
+struct rsi_91x_usbdev {
+	struct rsi_thread rx_thread;
+	u8 endpoint;
+	struct usb_device *usbdev;
+	struct usb_interface *pfunction;
+	struct urb *rx_usb_urb[MAX_RX_URBS];
+	u8 *tx_buffer;
+	__le16 bulkin_size;
+	u8 bulkin_endpoint_addr;
+	__le16 bulkout_size[MAX_BULK_EP];
+	u8 bulkout_endpoint_addr[MAX_BULK_EP];
+	u32 tx_blk_size;
+	u8 write_fail;
+};
+
+static inline int rsi_check_queue_status(struct rsi_hw *adapter, u8 q_num)
+{
+	/* In USB, there isn't any need to check the queue status */
+	return QUEUE_NOT_FULL;
+}
+
+static inline int rsi_event_timeout(struct rsi_hw *adapter)
+{
+	return EVENT_WAIT_FOREVER;
+}
+
+int rsi_device_init(struct rsi_common *common);
+int rsi_write_ta_register_multiple(struct rsi_hw *adapter, u32 addr,
+				   u8 *data, u32 count);
+int rsi_rx_urb_submit(struct rsi_hw *adapter);
+int rsi_host_intf_write_pkt(struct rsi_hw *adapter, u8 *pkt, u32 len);
+void rsi_usb_rx_thread(struct rsi_common *common);
+#endif

 rsi/rsi_main.h        |  232 ++++++++++++++++++++++++++++++++++++++++++++++++++
 rsi/rsi_sdio.h        |  129 +++++++++++++++++++++++++++
 rsi/rsi_usb.h         |   70 +++++++++++++++
 9 files changed, 654 insertions(+)




