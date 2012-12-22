Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:49410 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab2LVXSp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2012 18:18:45 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH 14/17] cw1200: v2: driver state and definitions
Date: Sat, 22 Dec 2012 18:18:29 -0500
Message-Id: <1356218312-13616-15-git-send-email-pizza@shaftnet.org> (sfid-20121223_002323_767208_EB699FB9)
In-Reply-To: <1356218312-13616-1-git-send-email-pizza@shaftnet.org>
References: <1356218312-13616-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/staging/cw1200/cw1200.h | 327 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 327 insertions(+)
 create mode 100644 drivers/staging/cw1200/cw1200.h

diff --git a/drivers/staging/cw1200/cw1200.h b/drivers/staging/cw1200/cw1200.h
new file mode 100644
index 0000000..eaf1281
--- /dev/null
+++ b/drivers/staging/cw1200/cw1200.h
@@ -0,0 +1,327 @@
+/*
+ * Common private data for ST-Ericsson CW1200 drivers
+ *
+ * Copyright (c) 2010, ST-Ericsson
+ * Author: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
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
+	CW1200_JOIN_STATUS_STA,
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
+enum cw1200_bss_loss_status {
+	CW1200_BSS_LOSS_NONE,
+	CW1200_BSS_LOSS_CHECKING,
+	CW1200_BSS_LOSS_CONFIRMING,
+	CW1200_BSS_LOSS_CONFIRMED,
+};
+
+extern int cw1200_power_mode;
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
+	struct cw1200_queue		tx_queue[4];
+	struct cw1200_queue_stats	tx_queue_stats;
+	int				tx_burst_idx;
+	struct cw1200_debug_priv	*debug;
+
+	struct ieee80211_hw		*hw;
+	struct ieee80211_vif		*vif;
+	struct device			*pdev;
+	struct workqueue_struct		*workqueue;
+
+	struct mutex			conf_mutex;
+
+	const struct sbus_ops		*sbus_ops;
+	struct sbus_priv		*sbus_priv;
+
+	/* HW type (HIF_...) */
+	int				hw_type;
+	int				hw_revision;
+	int                             hw_refclk;
+
+	/* firmware/hardware info */
+	unsigned int tx_hdr_len;
+
+	/* Radio data */
+	int output_power;
+	int noise;
+
+	/* calibration, output power limit and rssi<->dBm conversation data */
+
+	/* BBP/MAC state */
+	const struct firmware		*sdd;
+	char                            *sdd_path;
+	struct ieee80211_rate		*rates;
+	struct ieee80211_rate		*mcs_rates;
+	u8 mac_addr[ETH_ALEN];
+	struct ieee80211_channel	*channel;
+	u8 bssid[ETH_ALEN];
+	struct wsm_edca_params		edca;
+	struct wsm_tx_queue_params	tx_queue_params;
+	struct wsm_association_mode	association_mode;
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
+	size_t				ssid_length;
+	u8				ssid[IEEE80211_MAX_SSID_LEN];
+	bool				listening;
+	struct wsm_rx_filter		rx_filter;
+	struct wsm_beacon_filter_table	bf_table;
+	struct wsm_beacon_filter_control bf_control;
+	struct wsm_multicast_filter	multicast_filter;
+	bool				has_multicast_subscription;
+	bool				disable_beacon_filter;
+	struct work_struct		update_filtering_work;
+
+	u8				ba_tid_mask;
+	int				ba_acc;
+	int				ba_cnt;
+	int				ba_hist;
+	struct timer_list		ba_timer;
+	spinlock_t			ba_lock;
+	bool				ba_ena;
+	struct work_struct              ba_work;
+
+#ifdef CONFIG_CW1200_PM
+	struct cw1200_pm_state		pm_state;
+#endif
+	struct wsm_p2p_ps_modeinfo	p2p_ps_modeinfo;
+	struct wsm_uapsd_info		uapsd_info;
+	bool				setbssparams_done;
+	bool				is_BT_Present;
+	u8				conf_listen_interval;
+	u32				listen_interval;
+	u32				erp_info;
+
+	/* BH */
+	atomic_t			bh_rx;
+	atomic_t			bh_tx;
+	atomic_t			bh_term;
+	atomic_t			bh_suspend;
+	struct task_struct		*bh_thread;
+	int				bh_error;
+	wait_queue_head_t		bh_wq;
+	wait_queue_head_t		bh_evt_wq;
+	int				buf_id_tx;	/* byte */
+	int				buf_id_rx;	/* byte */
+	int				wsm_rx_seq;	/* byte */
+	int				wsm_tx_seq;	/* byte */
+	int				hw_bufs_used;
+	bool				powersave_enabled;
+	bool				device_can_sleep;
+
+	/* WSM */
+	struct wsm_caps			wsm_caps;
+	struct mutex			wsm_cmd_mux;
+	struct wsm_buf			wsm_cmd_buf;
+	struct wsm_cmd			wsm_cmd;
+	wait_queue_head_t		wsm_cmd_wq;
+	wait_queue_head_t		wsm_startup_done;
+	struct wsm_cbc			wsm_cbc;
+	atomic_t			tx_lock;
+
+	/* WSM debug */
+	int				wsm_enable_wsm_dumps;
+
+	/* Scan status */
+	struct cw1200_scan scan;
+
+	/* WSM Join */
+	enum cw1200_join_status	join_status;
+	u8			join_bssid[ETH_ALEN];
+	u32			pending_frame_id;
+	struct work_struct	join_work;
+	struct delayed_work	join_timeout;
+	struct work_struct	unjoin_work;
+	struct work_struct	offchannel_work;
+	int			join_dtim_period;
+	bool			delayed_unjoin;
+
+	/* TX/RX and security */
+	s8			wep_default_key_id;
+	struct work_struct	wep_key_work;
+	u32			key_map;
+	struct wsm_add_key	keys[WSM_KEY_MAX_INDEX + 1];
+	unsigned long		rx_timestamp;
+
+	/* AP powersave */
+	u32			link_id_map;
+	struct cw1200_link_entry link_id_db[CW1200_MAX_STA_IN_AP_MODE];
+	struct work_struct	link_id_work;
+	struct delayed_work	link_id_gc_work;
+	u32			sta_asleep_mask;
+	u32			pspoll_mask;
+	bool			aid0_bit_set;
+	spinlock_t		ps_state_lock;
+	bool			buffered_multicasts;
+	bool			tx_multicast;
+	struct work_struct	set_tim_work;
+	struct delayed_work	set_cts_work;
+	struct work_struct	multicast_start_work;
+	struct work_struct	multicast_stop_work;
+	struct timer_list	mcast_timeout;
+
+
+	/* WSM events and CQM implementation */
+	spinlock_t		event_queue_lock;
+	struct list_head	event_queue;
+	struct work_struct	event_handler;
+	struct delayed_work	bss_loss_work;
+	struct delayed_work	connection_loss_work;
+	int			delayed_link_loss;
+	spinlock_t		bss_loss_lock;
+	int			bss_loss_status;
+	int			bss_loss_confirm_id;
+
+	/* TX rate policy cache */
+	struct tx_policy_cache tx_policy_cache;
+	struct work_struct tx_policy_upload_work;
+
+	/* cryptographic engine information */
+
+	/* bit field of glowing LEDs */
+	u16 softled_state;
+
+	/* statistics */
+	struct ieee80211_low_level_stats stats;
+	/* Workaround for WFD testcase 6.1.10*/
+	struct work_struct	linkid_reset_work;
+	u8			action_frame_sa[ETH_ALEN];
+	u8			action_linkid;
+
+#ifdef CONFIG_CW1200_ETF
+	struct sk_buff_head etf_q;
+#endif
+
+
+#ifdef CONFIG_CW1200_POLL_IRQ
+	struct timer_list	irqpoll_timer;
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
+		      const char *sdd_path);
+void cw1200_core_release(struct cw1200_common *self);
+
+#define FWLOAD_BLOCK_SIZE (1024)
+
+static inline int cw1200_is_ht(const struct cw1200_ht_info *ht_info)
+{
+        return ht_info->channel_type != NL80211_CHAN_NO_HT;
+}
+
+static inline int cw1200_ht_greenfield(const struct cw1200_ht_info *ht_info)
+{
+        return cw1200_is_ht(ht_info) &&
+                (ht_info->ht_cap.cap & IEEE80211_HT_CAP_GRN_FLD) &&
+                !(ht_info->operation_mode &
+                        IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
+}
+
+static inline int cw1200_ht_ampdu_density(const struct cw1200_ht_info *ht_info)
+{
+        if (!cw1200_is_ht(ht_info))
+                return 0;
+        return ht_info->ht_cap.ampdu_density;
+}
+
+#endif /* CW1200_H */
-- 
1.7.11.7

