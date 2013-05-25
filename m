Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rrcs-24-73-230-86.se.biz.rr.com ([24.73.230.86]:39180 "EHLO
	stuffed.shaftnet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab3EYAFf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 May 2013 20:05:35 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH 11/14] cw1200: v7: Common definitions, state, and registration handling
Date: Fri, 24 May 2013 20:04:48 -0400
Message-Id: <1369440291-8961-12-git-send-email-pizza@shaftnet.org> (sfid-20130525_020544_241701_BE13B2F3)
In-Reply-To: <1369440291-8961-1-git-send-email-pizza@shaftnet.org>
References: <1369440291-8961-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/net/wireless/cw1200/cw1200.h | 332 +++++++++++++++++++
 drivers/net/wireless/cw1200/main.c   | 618 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/cw1200/sbus.h   |  37 +++
 3 files changed, 987 insertions(+)
 create mode 100644 drivers/net/wireless/cw1200/cw1200.h
 create mode 100644 drivers/net/wireless/cw1200/main.c
 create mode 100644 drivers/net/wireless/cw1200/sbus.h

diff --git a/drivers/net/wireless/cw1200/cw1200.h b/drivers/net/wireless/cw1200/cw1200.h
new file mode 100644
index 0000000..2aa17ca
--- /dev/null
+++ b/drivers/net/wireless/cw1200/cw1200.h
@@ -0,0 +1,332 @@
+/*
+ * Common private data for ST-Ericsson CW1200 drivers
+ *
+ * Copyright (c) 2010, ST-Ericsson
+ * Author: Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>
+ *
+ * Based on the mac80211 Prism54 code, which is
+ * Copyright (c) 2006, Michael Wu <flamingice@sourmilk.net>
+ *
+ * Based on the islsm (softmac prism54) driver, which is:
+ * Copyright 2004-2006 Jean-Baptiste Note <jbnote@gmail.com>, et al.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef CW1200_H
+#define CW1200_H
+
+#include <linux/wait.h>
+#include <linux/version.h>
+#include <linux/mutex.h>
+#include <linux/workqueue.h>
+#include <net/mac80211.h>
+
+#include "queue.h"
+#include "wsm.h"
+#include "scan.h"
+#include "txrx.h"
+#include "pm.h"
+
+/* Forward declarations */
+struct sbus_ops;
+struct task_struct;
+struct cw1200_debug_priv;
+struct firmware;
+
+#ifdef CONFIG_CW1200_ETF
+extern int etf_mode;
+extern char *etf_firmware;
+#endif
+
+#define CW1200_MAX_CTRL_FRAME_LEN	(0x1000)
+
+#define CW1200_MAX_STA_IN_AP_MODE	(5)
+#define CW1200_LINK_ID_AFTER_DTIM	(CW1200_MAX_STA_IN_AP_MODE + 1)
+#define CW1200_LINK_ID_UAPSD		(CW1200_MAX_STA_IN_AP_MODE + 2)
+#define CW1200_LINK_ID_MAX		(CW1200_MAX_STA_IN_AP_MODE + 3)
+#define CW1200_MAX_REQUEUE_ATTEMPTS	(5)
+
+#define CW1200_MAX_TID			(8)
+
+#define CW1200_BLOCK_ACK_CNT		(30)
+#define CW1200_BLOCK_ACK_THLD		(800)
+#define CW1200_BLOCK_ACK_HIST		(3)
+#define CW1200_BLOCK_ACK_INTERVAL	(1 * HZ / CW1200_BLOCK_ACK_HIST)
+
+#define CW1200_JOIN_TIMEOUT		(1 * HZ)
+#define CW1200_AUTH_TIMEOUT		(5 * HZ)
+
+struct cw1200_ht_info {
+	struct ieee80211_sta_ht_cap     ht_cap;
+	enum nl80211_channel_type       channel_type;
+	u16                             operation_mode;
+};
+
+/* Please keep order */
+enum cw1200_join_status {
+	CW1200_JOIN_STATUS_PASSIVE = 0,
+	CW1200_JOIN_STATUS_MONITOR,
+	CW1200_JOIN_STATUS_JOINING,
+	CW1200_JOIN_STATUS_PRE_STA,
+	CW1200_JOIN_STATUS_STA,
+	CW1200_JOIN_STATUS_IBSS,
+	CW1200_JOIN_STATUS_AP,
+};
+
+enum cw1200_link_status {
+	CW1200_LINK_OFF,
+	CW1200_LINK_RESERVE,
+	CW1200_LINK_SOFT,
+	CW1200_LINK_HARD,
+	CW1200_LINK_RESET,
+	CW1200_LINK_RESET_REMAP,
+};
+
+extern int cw1200_power_mode;
+extern const char * const cw1200_fw_types[];
+
+struct cw1200_link_entry {
+	unsigned long			timestamp;
+	enum cw1200_link_status		status;
+	enum cw1200_link_status		prev_status;
+	u8				mac[ETH_ALEN];
+	u8				buffered[CW1200_MAX_TID];
+	struct sk_buff_head		rx_queue;
+};
+
+struct cw1200_common {
+	/* interfaces to the rest of the stack */
+	struct ieee80211_hw		*hw;
+	struct ieee80211_vif		*vif;
+	struct device			*pdev;
+
+	/* Statistics */
+	struct ieee80211_low_level_stats stats;
+
+	/* Our macaddr */
+	u8 mac_addr[ETH_ALEN];
+
+	/* Hardware interface */
+	const struct sbus_ops		*sbus_ops;
+	struct sbus_priv		*sbus_priv;
+
+	/* Hardware information */
+	enum {
+		HIF_9000_SILICON_VERSATILE = 0,
+		HIF_8601_VERSATILE,
+		HIF_8601_SILICON,
+	} hw_type;
+	enum {
+		CW1200_HW_REV_CUT10 = 10,
+		CW1200_HW_REV_CUT11 = 11,
+		CW1200_HW_REV_CUT20 = 20,
+		CW1200_HW_REV_CUT22 = 22,
+		CW1X60_HW_REV       = 40,
+	} hw_revision;
+	int                             hw_refclk;
+	bool				hw_have_5ghz;
+	const struct firmware		*sdd;
+	char                            *sdd_path;
+
+	struct cw1200_debug_priv	*debug;
+
+	struct workqueue_struct		*workqueue;
+	struct mutex			conf_mutex;
+
+	struct cw1200_queue		tx_queue[4];
+	struct cw1200_queue_stats	tx_queue_stats;
+	int				tx_burst_idx;
+
+	/* firmware/hardware info */
+	unsigned int tx_hdr_len;
+
+	/* Radio data */
+	int output_power;
+
+	/* BBP/MAC state */
+	struct ieee80211_rate		*rates;
+	struct ieee80211_rate		*mcs_rates;
+	struct ieee80211_channel	*channel;
+	struct wsm_edca_params		edca;
+	struct wsm_tx_queue_params	tx_queue_params;
+	struct wsm_mib_association_mode	association_mode;
+	struct wsm_set_bss_params	bss_params;
+	struct cw1200_ht_info		ht_info;
+	struct wsm_set_pm		powersave_mode;
+	struct wsm_set_pm		firmware_ps_mode;
+	int				cqm_rssi_thold;
+	unsigned			cqm_rssi_hyst;
+	bool				cqm_use_rssi;
+	int				cqm_beacon_loss_count;
+	int				channel_switch_in_progress;
+	wait_queue_head_t		channel_switch_done;
+	u8				long_frame_max_tx_count;
+	u8				short_frame_max_tx_count;
+	int				mode;
+	bool				enable_beacon;
+	int				beacon_int;
+	bool				listening;
+	struct wsm_rx_filter		rx_filter;
+	struct wsm_mib_multicast_filter multicast_filter;
+	bool				has_multicast_subscription;
+	bool				disable_beacon_filter;
+	struct work_struct		update_filtering_work;
+	struct work_struct		set_beacon_wakeup_period_work;
+
+	u8				ba_rx_tid_mask;
+	u8				ba_tx_tid_mask;
+
+	struct cw1200_pm_state		pm_state;
+
+	struct wsm_p2p_ps_modeinfo	p2p_ps_modeinfo;
+	struct wsm_uapsd_info		uapsd_info;
+	bool				setbssparams_done;
+	bool				bt_present;
+	u8				conf_listen_interval;
+	u32				listen_interval;
+	u32				erp_info;
+	u32				rts_threshold;
+
+	/* BH */
+	atomic_t			bh_rx;
+	atomic_t			bh_tx;
+	atomic_t			bh_term;
+	atomic_t			bh_suspend;
+
+	struct workqueue_struct         *bh_workqueue;
+	struct work_struct              bh_work;
+
+	int				bh_error;
+	wait_queue_head_t		bh_wq;
+	wait_queue_head_t		bh_evt_wq;
+	u8				buf_id_tx;
+	u8				buf_id_rx;
+	u8				wsm_rx_seq;
+	u8				wsm_tx_seq;
+	int				hw_bufs_used;
+	bool				powersave_enabled;
+	bool				device_can_sleep;
+
+	/* Scan status */
+	struct cw1200_scan scan;
+	/* Keep cw1200 awake (WUP = 1) 1 second after each scan to avoid
+	 * FW issue with sleeping/waking up. */
+	atomic_t			recent_scan;
+	struct delayed_work		clear_recent_scan_work;
+
+	/* WSM */
+	struct wsm_startup_ind		wsm_caps;
+	struct mutex			wsm_cmd_mux;
+	struct wsm_buf			wsm_cmd_buf;
+	struct wsm_cmd			wsm_cmd;
+	wait_queue_head_t		wsm_cmd_wq;
+	wait_queue_head_t		wsm_startup_done;
+	int                             firmware_ready;
+	atomic_t			tx_lock;
+
+	/* WSM debug */
+	int				wsm_enable_wsm_dumps;
+
+	/* WSM Join */
+	enum cw1200_join_status	join_status;
+	u32			pending_frame_id;
+	bool			join_pending;
+	struct delayed_work	join_timeout;
+	struct work_struct	unjoin_work;
+	struct work_struct	join_complete_work;
+	int			join_complete_status;
+	int			join_dtim_period;
+	bool			delayed_unjoin;
+
+	/* TX/RX and security */
+	s8			wep_default_key_id;
+	struct work_struct	wep_key_work;
+	u32			key_map;
+	struct wsm_add_key	keys[WSM_KEY_MAX_INDEX + 1];
+
+	/* AP powersave */
+	u32			link_id_map;
+	struct cw1200_link_entry link_id_db[CW1200_MAX_STA_IN_AP_MODE];
+	struct work_struct	link_id_work;
+	struct delayed_work	link_id_gc_work;
+	u32			sta_asleep_mask;
+	u32			pspoll_mask;
+	bool			aid0_bit_set;
+	spinlock_t		ps_state_lock; /* Protect power save state */
+	bool			buffered_multicasts;
+	bool			tx_multicast;
+	struct work_struct	set_tim_work;
+	struct work_struct	set_cts_work;
+	struct work_struct	multicast_start_work;
+	struct work_struct	multicast_stop_work;
+	struct timer_list	mcast_timeout;
+
+	/* WSM events and CQM implementation */
+	spinlock_t		event_queue_lock; /* Protect event queue */
+	struct list_head	event_queue;
+	struct work_struct	event_handler;
+
+	struct delayed_work	bss_loss_work;
+	spinlock_t		bss_loss_lock; /* Protect BSS loss state */
+	int                     bss_loss_state;
+	int                     bss_loss_confirm_id;
+	int			delayed_link_loss;
+	struct work_struct	bss_params_work;
+
+	/* TX rate policy cache */
+	struct tx_policy_cache tx_policy_cache;
+	struct work_struct tx_policy_upload_work;
+
+	/* legacy PS mode switch in suspend */
+	int			ps_mode_switch_in_progress;
+	wait_queue_head_t	ps_mode_switch_done;
+
+	/* Workaround for WFD testcase 6.1.10*/
+	struct work_struct	linkid_reset_work;
+	u8			action_frame_sa[ETH_ALEN];
+	u8			action_linkid;
+
+#ifdef CONFIG_CW1200_ETF
+	struct sk_buff_head etf_q;
+#endif
+};
+
+struct cw1200_sta_priv {
+	int link_id;
+};
+
+/* interfaces for the drivers */
+int cw1200_core_probe(const struct sbus_ops *sbus_ops,
+		      struct sbus_priv *sbus,
+		      struct device *pdev,
+		      struct cw1200_common **pself,
+		      int ref_clk, const u8 *macaddr,
+		      const char *sdd_path, bool have_5ghz);
+void cw1200_core_release(struct cw1200_common *self);
+
+#define FWLOAD_BLOCK_SIZE (1024)
+
+static inline int cw1200_is_ht(const struct cw1200_ht_info *ht_info)
+{
+	return ht_info->channel_type != NL80211_CHAN_NO_HT;
+}
+
+static inline int cw1200_ht_greenfield(const struct cw1200_ht_info *ht_info)
+{
+	return cw1200_is_ht(ht_info) &&
+		(ht_info->ht_cap.cap & IEEE80211_HT_CAP_GRN_FLD) &&
+		!(ht_info->operation_mode &
+		  IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
+}
+
+static inline int cw1200_ht_ampdu_density(const struct cw1200_ht_info *ht_info)
+{
+	if (!cw1200_is_ht(ht_info))
+		return 0;
+	return ht_info->ht_cap.ampdu_density;
+}
+
+#endif /* CW1200_H */
diff --git a/drivers/net/wireless/cw1200/main.c b/drivers/net/wireless/cw1200/main.c
new file mode 100644
index 0000000..8426d3d
--- /dev/null
+++ b/drivers/net/wireless/cw1200/main.c
@@ -0,0 +1,618 @@
+/*
+ * mac80211 glue code for mac80211 ST-Ericsson CW1200 drivers
+ *
+ * Copyright (c) 2010, ST-Ericsson
+ * Author: Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>
+ *
+ * Based on:
+ * Copyright (c) 2006, Michael Wu <flamingice@sourmilk.net>
+ * Copyright (c) 2007-2009, Christian Lamparter <chunkeey@web.de>
+ * Copyright 2008, Johannes Berg <johannes@sipsolutions.net>
+ *
+ * Based on:
+ * - the islsm (softmac prism54) driver, which is:
+ *   Copyright 2004-2006 Jean-Baptiste Note <jbnote@gmail.com>, et al.
+ * - stlc45xx driver
+ *   Copyright (C) 2008 Nokia Corporation and/or its subsidiary(-ies).
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/firmware.h>
+#include <linux/etherdevice.h>
+#include <linux/vmalloc.h>
+#include <linux/random.h>
+#include <linux/sched.h>
+#include <net/mac80211.h>
+
+#include "cw1200.h"
+#include "txrx.h"
+#include "sbus.h"
+#include "fwio.h"
+#include "hwio.h"
+#include "bh.h"
+#include "sta.h"
+#include "scan.h"
+#include "debug.h"
+#include "pm.h"
+
+MODULE_AUTHOR("Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>");
+MODULE_DESCRIPTION("Softmac ST-Ericsson CW1200 common code");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("cw1200_core");
+
+/* Accept MAC address of the form macaddr=0x00,0x80,0xE1,0x30,0x40,0x50 */
+static u8 cw1200_mac_template[ETH_ALEN] = {0x02, 0x80, 0xe1, 0x00, 0x00, 0x00};
+module_param_array_named(macaddr, cw1200_mac_template, byte, NULL, S_IRUGO);
+MODULE_PARM_DESC(macaddr, "Override platform_data MAC address");
+
+static char *cw1200_sdd_path;
+module_param(cw1200_sdd_path, charp, 0644);
+MODULE_PARM_DESC(cw1200_sdd_path, "Override platform_data SDD file");
+static int cw1200_refclk;
+module_param(cw1200_refclk, int, 0644);
+MODULE_PARM_DESC(cw1200_refclk, "Override platform_data reference clock");
+
+int cw1200_power_mode = wsm_power_mode_quiescent;
+module_param(cw1200_power_mode, int, 0644);
+MODULE_PARM_DESC(cw1200_power_mode, "WSM power mode.  0 == active, 1 == doze, 2 == quiescent (default)");
+
+#ifdef CONFIG_CW1200_ETF
+int etf_mode;
+module_param(etf_mode, int, 0644);
+MODULE_PARM_DESC(etf_mode, "Enable EngineeringTestingFramework operation");
+#endif
+
+#define RATETAB_ENT(_rate, _rateid, _flags)		\
+	{						\
+		.bitrate	= (_rate),		\
+		.hw_value	= (_rateid),		\
+		.flags		= (_flags),		\
+	}
+
+static struct ieee80211_rate cw1200_rates[] = {
+	RATETAB_ENT(10,  0,   0),
+	RATETAB_ENT(20,  1,   0),
+	RATETAB_ENT(55,  2,   0),
+	RATETAB_ENT(110, 3,   0),
+	RATETAB_ENT(60,  6,  0),
+	RATETAB_ENT(90,  7,  0),
+	RATETAB_ENT(120, 8,  0),
+	RATETAB_ENT(180, 9,  0),
+	RATETAB_ENT(240, 10, 0),
+	RATETAB_ENT(360, 11, 0),
+	RATETAB_ENT(480, 12, 0),
+	RATETAB_ENT(540, 13, 0),
+};
+
+static struct ieee80211_rate cw1200_mcs_rates[] = {
+	RATETAB_ENT(65,  14, IEEE80211_TX_RC_MCS),
+	RATETAB_ENT(130, 15, IEEE80211_TX_RC_MCS),
+	RATETAB_ENT(195, 16, IEEE80211_TX_RC_MCS),
+	RATETAB_ENT(260, 17, IEEE80211_TX_RC_MCS),
+	RATETAB_ENT(390, 18, IEEE80211_TX_RC_MCS),
+	RATETAB_ENT(520, 19, IEEE80211_TX_RC_MCS),
+	RATETAB_ENT(585, 20, IEEE80211_TX_RC_MCS),
+	RATETAB_ENT(650, 21, IEEE80211_TX_RC_MCS),
+};
+
+#define cw1200_a_rates		(cw1200_rates + 4)
+#define cw1200_a_rates_size	(ARRAY_SIZE(cw1200_rates) - 4)
+#define cw1200_g_rates		(cw1200_rates + 0)
+#define cw1200_g_rates_size	(ARRAY_SIZE(cw1200_rates))
+#define cw1200_n_rates		(cw1200_mcs_rates)
+#define cw1200_n_rates_size	(ARRAY_SIZE(cw1200_mcs_rates))
+
+
+#define CHAN2G(_channel, _freq, _flags) {			\
+	.band			= IEEE80211_BAND_2GHZ,		\
+	.center_freq		= (_freq),			\
+	.hw_value		= (_channel),			\
+	.flags			= (_flags),			\
+	.max_antenna_gain	= 0,				\
+	.max_power		= 30,				\
+}
+
+#define CHAN5G(_channel, _flags) {				\
+	.band			= IEEE80211_BAND_5GHZ,		\
+	.center_freq	= 5000 + (5 * (_channel)),		\
+	.hw_value		= (_channel),			\
+	.flags			= (_flags),			\
+	.max_antenna_gain	= 0,				\
+	.max_power		= 30,				\
+}
+
+static struct ieee80211_channel cw1200_2ghz_chantable[] = {
+	CHAN2G(1, 2412, 0),
+	CHAN2G(2, 2417, 0),
+	CHAN2G(3, 2422, 0),
+	CHAN2G(4, 2427, 0),
+	CHAN2G(5, 2432, 0),
+	CHAN2G(6, 2437, 0),
+	CHAN2G(7, 2442, 0),
+	CHAN2G(8, 2447, 0),
+	CHAN2G(9, 2452, 0),
+	CHAN2G(10, 2457, 0),
+	CHAN2G(11, 2462, 0),
+	CHAN2G(12, 2467, 0),
+	CHAN2G(13, 2472, 0),
+	CHAN2G(14, 2484, 0),
+};
+
+static struct ieee80211_channel cw1200_5ghz_chantable[] = {
+	CHAN5G(34, 0),		CHAN5G(36, 0),
+	CHAN5G(38, 0),		CHAN5G(40, 0),
+	CHAN5G(42, 0),		CHAN5G(44, 0),
+	CHAN5G(46, 0),		CHAN5G(48, 0),
+	CHAN5G(52, 0),		CHAN5G(56, 0),
+	CHAN5G(60, 0),		CHAN5G(64, 0),
+	CHAN5G(100, 0),		CHAN5G(104, 0),
+	CHAN5G(108, 0),		CHAN5G(112, 0),
+	CHAN5G(116, 0),		CHAN5G(120, 0),
+	CHAN5G(124, 0),		CHAN5G(128, 0),
+	CHAN5G(132, 0),		CHAN5G(136, 0),
+	CHAN5G(140, 0),		CHAN5G(149, 0),
+	CHAN5G(153, 0),		CHAN5G(157, 0),
+	CHAN5G(161, 0),		CHAN5G(165, 0),
+	CHAN5G(184, 0),		CHAN5G(188, 0),
+	CHAN5G(192, 0),		CHAN5G(196, 0),
+	CHAN5G(200, 0),		CHAN5G(204, 0),
+	CHAN5G(208, 0),		CHAN5G(212, 0),
+	CHAN5G(216, 0),
+};
+
+static struct ieee80211_supported_band cw1200_band_2ghz = {
+	.channels = cw1200_2ghz_chantable,
+	.n_channels = ARRAY_SIZE(cw1200_2ghz_chantable),
+	.bitrates = cw1200_g_rates,
+	.n_bitrates = cw1200_g_rates_size,
+	.ht_cap = {
+		.cap = IEEE80211_HT_CAP_GRN_FLD |
+			(1 << IEEE80211_HT_CAP_RX_STBC_SHIFT) |
+			IEEE80211_HT_CAP_MAX_AMSDU,
+		.ht_supported = 1,
+		.ampdu_factor = IEEE80211_HT_MAX_AMPDU_8K,
+		.ampdu_density = IEEE80211_HT_MPDU_DENSITY_NONE,
+		.mcs = {
+			.rx_mask[0] = 0xFF,
+			.rx_highest = __cpu_to_le16(0x41),
+			.tx_params = IEEE80211_HT_MCS_TX_DEFINED,
+		},
+	},
+};
+
+static struct ieee80211_supported_band cw1200_band_5ghz = {
+	.channels = cw1200_5ghz_chantable,
+	.n_channels = ARRAY_SIZE(cw1200_5ghz_chantable),
+	.bitrates = cw1200_a_rates,
+	.n_bitrates = cw1200_a_rates_size,
+	.ht_cap = {
+		.cap = IEEE80211_HT_CAP_GRN_FLD |
+			(1 << IEEE80211_HT_CAP_RX_STBC_SHIFT) |
+			IEEE80211_HT_CAP_MAX_AMSDU,
+		.ht_supported = 1,
+		.ampdu_factor = IEEE80211_HT_MAX_AMPDU_8K,
+		.ampdu_density = IEEE80211_HT_MPDU_DENSITY_NONE,
+		.mcs = {
+			.rx_mask[0] = 0xFF,
+			.rx_highest = __cpu_to_le16(0x41),
+			.tx_params = IEEE80211_HT_MCS_TX_DEFINED,
+		},
+	},
+};
+
+static const unsigned long cw1200_ttl[] = {
+	1 * HZ,	/* VO */
+	2 * HZ,	/* VI */
+	5 * HZ, /* BE */
+	10 * HZ	/* BK */
+};
+
+static const struct ieee80211_ops cw1200_ops = {
+	.start			= cw1200_start,
+	.stop			= cw1200_stop,
+	.add_interface		= cw1200_add_interface,
+	.remove_interface	= cw1200_remove_interface,
+	.change_interface	= cw1200_change_interface,
+	.tx			= cw1200_tx,
+	.hw_scan		= cw1200_hw_scan,
+	.set_tim		= cw1200_set_tim,
+	.sta_notify		= cw1200_sta_notify,
+	.sta_add		= cw1200_sta_add,
+	.sta_remove		= cw1200_sta_remove,
+	.set_key		= cw1200_set_key,
+	.set_rts_threshold	= cw1200_set_rts_threshold,
+	.config			= cw1200_config,
+	.bss_info_changed	= cw1200_bss_info_changed,
+	.prepare_multicast	= cw1200_prepare_multicast,
+	.configure_filter	= cw1200_configure_filter,
+	.conf_tx		= cw1200_conf_tx,
+	.get_stats		= cw1200_get_stats,
+	.ampdu_action		= cw1200_ampdu_action,
+	.flush			= cw1200_flush,
+	.suspend		= cw1200_wow_suspend,
+	.resume			= cw1200_wow_resume,
+	/* Intentionally not offloaded:					*/
+	/*.channel_switch	= cw1200_channel_switch,		*/
+	/*.remain_on_channel	= cw1200_remain_on_channel,		*/
+	/*.cancel_remain_on_channel = cw1200_cancel_remain_on_channel,	*/
+};
+
+int cw1200_ba_rx_tids = -1;
+int cw1200_ba_tx_tids = -1;
+module_param(cw1200_ba_rx_tids, int, 0644);
+module_param(cw1200_ba_tx_tids, int, 0644);
+MODULE_PARM_DESC(cw1200_ba_rx_tids, "Block ACK RX TIDs");
+MODULE_PARM_DESC(cw1200_ba_tx_tids, "Block ACK TX TIDs");
+
+static struct ieee80211_hw *cw1200_init_common(const u8 *macaddr,
+						const bool have_5ghz)
+{
+	int i, band;
+	struct ieee80211_hw *hw;
+	struct cw1200_common *priv;
+
+	hw = ieee80211_alloc_hw(sizeof(struct cw1200_common), &cw1200_ops);
+	if (!hw)
+		return NULL;
+
+	priv = hw->priv;
+	priv->hw = hw;
+	priv->hw_type = -1;
+	priv->mode = NL80211_IFTYPE_UNSPECIFIED;
+	priv->rates = cw1200_rates; /* TODO: fetch from FW */
+	priv->mcs_rates = cw1200_n_rates;
+	if (cw1200_ba_rx_tids != -1)
+		priv->ba_rx_tid_mask = cw1200_ba_rx_tids;
+	else
+		priv->ba_rx_tid_mask = 0xFF; /* Enable RX BLKACK for all TIDs */
+	if (cw1200_ba_tx_tids != -1)
+		priv->ba_tx_tid_mask = cw1200_ba_tx_tids;
+	else
+		priv->ba_tx_tid_mask = 0xff; /* Enable TX BLKACK for all TIDs */
+
+	hw->flags = IEEE80211_HW_SIGNAL_DBM |
+		    IEEE80211_HW_SUPPORTS_PS |
+		    IEEE80211_HW_SUPPORTS_DYNAMIC_PS |
+		    IEEE80211_HW_REPORTS_TX_ACK_STATUS |
+		    IEEE80211_HW_SUPPORTS_UAPSD |
+		    IEEE80211_HW_CONNECTION_MONITOR |
+		    IEEE80211_HW_AMPDU_AGGREGATION |
+		    IEEE80211_HW_TX_AMPDU_SETUP_IN_HW |
+		    IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC;
+
+	hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
+					  BIT(NL80211_IFTYPE_ADHOC) |
+					  BIT(NL80211_IFTYPE_AP) |
+					  BIT(NL80211_IFTYPE_MESH_POINT) |
+					  BIT(NL80211_IFTYPE_P2P_CLIENT) |
+					  BIT(NL80211_IFTYPE_P2P_GO);
+
+	/* Support only for limited wowlan functionalities */
+	hw->wiphy->wowlan.flags = WIPHY_WOWLAN_ANY |
+		WIPHY_WOWLAN_DISCONNECT;
+	hw->wiphy->wowlan.n_patterns = 0;
+
+	hw->wiphy->flags |= WIPHY_FLAG_AP_UAPSD;
+
+	hw->channel_change_time = 1000;	/* TODO: find actual value */
+	hw->queues = 4;
+
+	priv->rts_threshold = -1;
+
+	hw->max_rates = 8;
+	hw->max_rate_tries = 15;
+	hw->extra_tx_headroom = WSM_TX_EXTRA_HEADROOM +
+		8;  /* TKIP IV */
+
+	hw->sta_data_size = sizeof(struct cw1200_sta_priv);
+
+	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &cw1200_band_2ghz;
+	if (have_5ghz)
+		hw->wiphy->bands[IEEE80211_BAND_5GHZ] = &cw1200_band_5ghz;
+
+	/* Channel params have to be cleared before registering wiphy again */
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		struct ieee80211_supported_band *sband = hw->wiphy->bands[band];
+		if (!sband)
+			continue;
+		for (i = 0; i < sband->n_channels; i++) {
+			sband->channels[i].flags = 0;
+			sband->channels[i].max_antenna_gain = 0;
+			sband->channels[i].max_power = 30;
+		}
+	}
+
+	hw->wiphy->max_scan_ssids = 2;
+	hw->wiphy->max_scan_ie_len = IEEE80211_MAX_DATA_LEN;
+
+	if (macaddr)
+		SET_IEEE80211_PERM_ADDR(hw, (u8 *)macaddr);
+	else
+		SET_IEEE80211_PERM_ADDR(hw, cw1200_mac_template);
+
+	/* Fix up mac address if necessary */
+	if (hw->wiphy->perm_addr[3] == 0 &&
+	    hw->wiphy->perm_addr[4] == 0 &&
+	    hw->wiphy->perm_addr[5] == 0) {
+		get_random_bytes(&hw->wiphy->perm_addr[3], 3);
+	}
+
+	mutex_init(&priv->wsm_cmd_mux);
+	mutex_init(&priv->conf_mutex);
+	priv->workqueue = create_singlethread_workqueue("cw1200_wq");
+	sema_init(&priv->scan.lock, 1);
+	INIT_WORK(&priv->scan.work, cw1200_scan_work);
+	INIT_DELAYED_WORK(&priv->scan.probe_work, cw1200_probe_work);
+	INIT_DELAYED_WORK(&priv->scan.timeout, cw1200_scan_timeout);
+	INIT_DELAYED_WORK(&priv->clear_recent_scan_work,
+			  cw1200_clear_recent_scan_work);
+	INIT_DELAYED_WORK(&priv->join_timeout, cw1200_join_timeout);
+	INIT_WORK(&priv->unjoin_work, cw1200_unjoin_work);
+	INIT_WORK(&priv->join_complete_work, cw1200_join_complete_work);
+	INIT_WORK(&priv->wep_key_work, cw1200_wep_key_work);
+	INIT_WORK(&priv->tx_policy_upload_work, tx_policy_upload_work);
+	spin_lock_init(&priv->event_queue_lock);
+	INIT_LIST_HEAD(&priv->event_queue);
+	INIT_WORK(&priv->event_handler, cw1200_event_handler);
+	INIT_DELAYED_WORK(&priv->bss_loss_work, cw1200_bss_loss_work);
+	INIT_WORK(&priv->bss_params_work, cw1200_bss_params_work);
+	spin_lock_init(&priv->bss_loss_lock);
+	spin_lock_init(&priv->ps_state_lock);
+	INIT_WORK(&priv->set_cts_work, cw1200_set_cts_work);
+	INIT_WORK(&priv->set_tim_work, cw1200_set_tim_work);
+	INIT_WORK(&priv->multicast_start_work, cw1200_multicast_start_work);
+	INIT_WORK(&priv->multicast_stop_work, cw1200_multicast_stop_work);
+	INIT_WORK(&priv->link_id_work, cw1200_link_id_work);
+	INIT_DELAYED_WORK(&priv->link_id_gc_work, cw1200_link_id_gc_work);
+	INIT_WORK(&priv->linkid_reset_work, cw1200_link_id_reset);
+	INIT_WORK(&priv->update_filtering_work, cw1200_update_filtering_work);
+	INIT_WORK(&priv->set_beacon_wakeup_period_work,
+		  cw1200_set_beacon_wakeup_period_work);
+	init_timer(&priv->mcast_timeout);
+	priv->mcast_timeout.data = (unsigned long)priv;
+	priv->mcast_timeout.function = cw1200_mcast_timeout;
+
+	if (cw1200_queue_stats_init(&priv->tx_queue_stats,
+				    CW1200_LINK_ID_MAX,
+				    cw1200_skb_dtor,
+				    priv)) {
+		ieee80211_free_hw(hw);
+		return NULL;
+	}
+
+	for (i = 0; i < 4; ++i) {
+		if (cw1200_queue_init(&priv->tx_queue[i],
+				      &priv->tx_queue_stats, i, 16,
+				      cw1200_ttl[i])) {
+			for (; i > 0; i--)
+				cw1200_queue_deinit(&priv->tx_queue[i - 1]);
+			cw1200_queue_stats_deinit(&priv->tx_queue_stats);
+			ieee80211_free_hw(hw);
+			return NULL;
+		}
+	}
+
+	init_waitqueue_head(&priv->channel_switch_done);
+	init_waitqueue_head(&priv->wsm_cmd_wq);
+	init_waitqueue_head(&priv->wsm_startup_done);
+	init_waitqueue_head(&priv->ps_mode_switch_done);
+	wsm_buf_init(&priv->wsm_cmd_buf);
+	spin_lock_init(&priv->wsm_cmd.lock);
+	priv->wsm_cmd.done = 1;
+	tx_policy_init(priv);
+
+	return hw;
+}
+
+static int cw1200_register_common(struct ieee80211_hw *dev)
+{
+	struct cw1200_common *priv = dev->priv;
+	int err;
+
+#ifdef CONFIG_CW1200_ETF
+	if (etf_mode)
+		goto done;
+#endif
+
+	err = cw1200_pm_init(&priv->pm_state, priv);
+	if (err) {
+		pr_err("Cannot init PM. (%d).\n",
+		       err);
+		return err;
+	}
+
+	err = ieee80211_register_hw(dev);
+	if (err) {
+		pr_err("Cannot register device (%d).\n",
+		       err);
+		cw1200_pm_deinit(&priv->pm_state);
+		return err;
+	}
+
+#ifdef CONFIG_CW1200_ETF
+done:
+#endif
+	cw1200_debug_init(priv);
+
+	pr_info("Registered as '%s'\n", wiphy_name(dev->wiphy));
+	return 0;
+}
+
+static void cw1200_free_common(struct ieee80211_hw *dev)
+{
+	ieee80211_free_hw(dev);
+}
+
+static void cw1200_unregister_common(struct ieee80211_hw *dev)
+{
+	struct cw1200_common *priv = dev->priv;
+	int i;
+
+#ifdef CONFIG_CW1200_ETF
+	if (!etf_mode) {
+#endif
+		ieee80211_unregister_hw(dev);
+#ifdef CONFIG_CW1200_ETF
+	}
+#endif
+
+	del_timer_sync(&priv->mcast_timeout);
+	cw1200_unregister_bh(priv);
+
+	cw1200_debug_release(priv);
+
+	mutex_destroy(&priv->conf_mutex);
+
+	wsm_buf_deinit(&priv->wsm_cmd_buf);
+
+	destroy_workqueue(priv->workqueue);
+	priv->workqueue = NULL;
+
+	if (priv->sdd) {
+		release_firmware(priv->sdd);
+		priv->sdd = NULL;
+	}
+
+	for (i = 0; i < 4; ++i)
+		cw1200_queue_deinit(&priv->tx_queue[i]);
+
+	cw1200_queue_stats_deinit(&priv->tx_queue_stats);
+	cw1200_pm_deinit(&priv->pm_state);
+}
+
+/* Clock is in KHz */
+u32 cw1200_dpll_from_clk(u16 clk_khz)
+{
+	switch (clk_khz) {
+	case 0x32C8: /* 13000 KHz */
+		return 0x1D89D241;
+	case 0x3E80: /* 16000 KHz */
+		return 0x000001E1;
+	case 0x41A0: /* 16800 KHz */
+		return 0x124931C1;
+	case 0x4B00: /* 19200 KHz */
+		return 0x00000191;
+	case 0x5DC0: /* 24000 KHz */
+		return 0x00000141;
+	case 0x6590: /* 26000 KHz */
+		return 0x0EC4F121;
+	case 0x8340: /* 33600 KHz */
+		return 0x092490E1;
+	case 0x9600: /* 38400 KHz */
+		return 0x100010C1;
+	case 0x9C40: /* 40000 KHz */
+		return 0x000000C1;
+	case 0xBB80: /* 48000 KHz */
+		return 0x000000A1;
+	case 0xCB20: /* 52000 KHz */
+		return 0x07627091;
+	default:
+		pr_err("Unknown Refclk freq (0x%04x), using 2600KHz\n",
+		       clk_khz);
+		return 0x0EC4F121;
+	}
+}
+
+int cw1200_core_probe(const struct sbus_ops *sbus_ops,
+		      struct sbus_priv *sbus,
+		      struct device *pdev,
+		      struct cw1200_common **core,
+		      int ref_clk, const u8 *macaddr,
+		      const char *sdd_path, bool have_5ghz)
+{
+	int err = -EINVAL;
+	struct ieee80211_hw *dev;
+	struct cw1200_common *priv;
+	struct wsm_operational_mode mode = {
+		.power_mode = cw1200_power_mode,
+		.disable_more_flag_usage = true,
+	};
+
+	dev = cw1200_init_common(macaddr, have_5ghz);
+	if (!dev)
+		goto err;
+
+	priv = dev->priv;
+	priv->hw_refclk = ref_clk;
+	if (cw1200_refclk)
+		priv->hw_refclk = cw1200_refclk;
+
+	priv->sdd_path = (char *)sdd_path;
+	if (cw1200_sdd_path)
+		priv->sdd_path = cw1200_sdd_path;
+
+	priv->sbus_ops = sbus_ops;
+	priv->sbus_priv = sbus;
+	priv->pdev = pdev;
+	SET_IEEE80211_DEV(priv->hw, pdev);
+
+	/* Pass struct cw1200_common back up */
+	*core = priv;
+
+	err = cw1200_register_bh(priv);
+	if (err)
+		goto err1;
+
+#ifdef CONFIG_CW1200_ETF
+	if (etf_mode)
+		goto skip_fw;
+#endif
+
+	err = cw1200_load_firmware(priv);
+	if (err)
+		goto err2;
+
+	if (wait_event_interruptible_timeout(priv->wsm_startup_done,
+					     priv->firmware_ready,
+					     3*HZ) <= 0) {
+		/* TODO: Need to find how to reset device
+		   in QUEUE mode properly.
+		*/
+		pr_err("Timeout waiting on device startup\n");
+		err = -ETIMEDOUT;
+		goto err2;
+	}
+
+	/* Set low-power mode. */
+	wsm_set_operational_mode(priv, &mode);
+
+	/* Enable multi-TX confirmation */
+	wsm_use_multi_tx_conf(priv, true);
+
+#ifdef CONFIG_CW1200_ETF
+skip_fw:
+#endif
+	err = cw1200_register_common(dev);
+	if (err)
+		goto err2;
+
+	return err;
+
+err2:
+	cw1200_unregister_bh(priv);
+err1:
+	cw1200_free_common(dev);
+err:
+	*core = NULL;
+	return err;
+}
+EXPORT_SYMBOL_GPL(cw1200_core_probe);
+
+void cw1200_core_release(struct cw1200_common *self)
+{
+	/* Disable device interrupts */
+	self->sbus_ops->lock(self->sbus_priv);
+	__cw1200_irq_enable(self, 0);
+	self->sbus_ops->unlock(self->sbus_priv);
+
+	/* And then clean up */
+	cw1200_unregister_common(self->hw);
+	cw1200_free_common(self->hw);
+	return;
+}
+EXPORT_SYMBOL_GPL(cw1200_core_release);
diff --git a/drivers/net/wireless/cw1200/sbus.h b/drivers/net/wireless/cw1200/sbus.h
new file mode 100644
index 0000000..603fd25
--- /dev/null
+++ b/drivers/net/wireless/cw1200/sbus.h
@@ -0,0 +1,37 @@
+/*
+ * Common sbus abstraction layer interface for cw1200 wireless driver
+ *
+ * Copyright (c) 2010, ST-Ericsson
+ * Author: Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef CW1200_SBUS_H
+#define CW1200_SBUS_H
+
+/*
+ * sbus priv forward definition.
+ * Implemented and instantiated in particular modules.
+ */
+struct sbus_priv;
+
+void cw1200_irq_handler(struct cw1200_common *priv);
+
+/* This MUST be wrapped with sbus_ops->lock/unlock! */
+int __cw1200_irq_enable(struct cw1200_common *priv, int enable);
+
+struct sbus_ops {
+	int (*sbus_memcpy_fromio)(struct sbus_priv *self, unsigned int addr,
+					void *dst, int count);
+	int (*sbus_memcpy_toio)(struct sbus_priv *self, unsigned int addr,
+					const void *src, int count);
+	void (*lock)(struct sbus_priv *self);
+	void (*unlock)(struct sbus_priv *self);
+	size_t (*align_size)(struct sbus_priv *self, size_t size);
+	int (*power_mgmt)(struct sbus_priv *self, bool suspend);
+};
+
+#endif /* CW1200_SBUS_H */
-- 
1.8.1.4

