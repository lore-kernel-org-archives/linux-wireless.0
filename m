Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:49410 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab2LVXSp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2012 18:18:45 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH 13/17] cw1200: v2: common registration/setup code
Date: Sat, 22 Dec 2012 18:18:28 -0500
Message-Id: <1356218312-13616-14-git-send-email-pizza@shaftnet.org> (sfid-20121223_002322_348865_0965B0BA)
In-Reply-To: <1356218312-13616-1-git-send-email-pizza@shaftnet.org>
References: <1356218312-13616-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/staging/cw1200/main.c | 650 ++++++++++++++++++++++++++++++++++++++++++
 drivers/staging/cw1200/sbus.h |  43 +++
 2 files changed, 693 insertions(+)
 create mode 100644 drivers/staging/cw1200/main.c
 create mode 100644 drivers/staging/cw1200/sbus.h

diff --git a/drivers/staging/cw1200/main.c b/drivers/staging/cw1200/main.c
new file mode 100644
index 0000000..dc206ac
--- /dev/null
+++ b/drivers/staging/cw1200/main.c
@@ -0,0 +1,650 @@
+/*
+ * mac80211 glue code for mac80211 ST-Ericsson CW1200 drivers
+ *
+ * Copyright (c) 2010, ST-Ericsson
+ * Author: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
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
+#include "ap.h"
+#include "scan.h"
+#include "debug.h"
+#include "pm.h"
+
+MODULE_AUTHOR("Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>");
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
+/* TODO: use rates and channels from the device */
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
+#ifdef CONFIG_CW1200_5GHZ_SUPPORT
+#define CHAN5G(_channel, _flags) {				\
+	.band			= IEEE80211_BAND_5GHZ,		\
+	.center_freq	= 5000 + (5 * (_channel)),		\
+	.hw_value		= (_channel),			\
+	.flags			= (_flags),			\
+	.max_antenna_gain	= 0,				\
+	.max_power		= 30,				\
+}
+#endif
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
+#ifdef CONFIG_CW1200_5GHZ_SUPPORT
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
+#endif
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
+#ifdef CONFIG_CW1200_5GHZ_SUPPORT
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
+#endif
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
+#ifdef CONFIG_CW1200_PM
+	.suspend		= cw1200_wow_suspend,
+	.resume			= cw1200_wow_resume,
+#endif /* CONFIG_CW1200_PM */
+	/* Intentionally not offloaded:					*/
+	/*.channel_switch	= cw1200_channel_switch,		*/
+	/*.remain_on_channel	= cw1200_remain_on_channel,		*/
+	/*.cancel_remain_on_channel = cw1200_cancel_remain_on_channel,	*/
+};
+
+static struct ieee80211_hw *cw1200_init_common(const u8 *macaddr)
+{
+	int i;
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
+	/* Enable block ACK for all but TID6/7 (voice). */
+	priv->ba_tid_mask = 0x3F;
+
+	hw->flags = IEEE80211_HW_SIGNAL_DBM |
+		    IEEE80211_HW_SUPPORTS_PS |
+		    IEEE80211_HW_SUPPORTS_DYNAMIC_PS |
+		    IEEE80211_HW_REPORTS_TX_ACK_STATUS |
+		    IEEE80211_HW_SUPPORTS_UAPSD |
+		    IEEE80211_HW_CONNECTION_MONITOR |
+		    IEEE80211_HW_AMPDU_AGGREGATION |
+		    IEEE80211_HW_TX_AMPDU_SETUP_IN_HW |
+		    IEEE80211_HW_NEED_DTIM_PERIOD;
+
+	hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
+					  BIT(NL80211_IFTYPE_ADHOC) |
+					  BIT(NL80211_IFTYPE_AP) |
+					  BIT(NL80211_IFTYPE_MESH_POINT) |
+					  BIT(NL80211_IFTYPE_P2P_CLIENT) |
+					  BIT(NL80211_IFTYPE_P2P_GO);
+
+#ifdef CONFIG_CW1200_PM
+	/* Support only for limited wowlan functionalities */
+	hw->wiphy->wowlan.flags = WIPHY_WOWLAN_ANY |
+					  WIPHY_WOWLAN_DISCONNECT;
+	hw->wiphy->wowlan.n_patterns = 0;
+#endif
+
+	hw->wiphy->flags |= WIPHY_FLAG_AP_UAPSD;
+
+	hw->channel_change_time = 1000;	/* TODO: find actual value */
+	/* priv->beacon_req_id = cpu_to_le32(0); */
+	hw->queues = 4;
+	priv->noise = -94;
+
+	hw->max_rates = 8;
+	hw->max_rate_tries = 15;
+	hw->extra_tx_headroom = WSM_TX_EXTRA_HEADROOM +
+		8;  /* TKIP IV */
+
+	hw->sta_data_size = sizeof(struct cw1200_sta_priv);
+
+	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &cw1200_band_2ghz;
+#ifdef CONFIG_CW1200_5GHZ_SUPPORT
+	hw->wiphy->bands[IEEE80211_BAND_5GHZ] = &cw1200_band_5ghz;
+#endif /* CONFIG_CW1200_5GHZ_SUPPORT */
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
+	INIT_WORK(&priv->join_work, cw1200_join_work);
+	INIT_DELAYED_WORK(&priv->join_timeout, cw1200_join_timeout);
+	INIT_WORK(&priv->unjoin_work, cw1200_unjoin_work);
+	INIT_WORK(&priv->offchannel_work, cw1200_offchannel_work);
+	INIT_WORK(&priv->wep_key_work, cw1200_wep_key_work);
+	INIT_WORK(&priv->tx_policy_upload_work, tx_policy_upload_work);
+	spin_lock_init(&priv->event_queue_lock);
+	INIT_LIST_HEAD(&priv->event_queue);
+	INIT_WORK(&priv->event_handler, cw1200_event_handler);
+	INIT_DELAYED_WORK(&priv->bss_loss_work, cw1200_bss_loss_work);
+	INIT_DELAYED_WORK(&priv->connection_loss_work,
+			  cw1200_connection_loss_work);
+	spin_lock_init(&priv->bss_loss_lock);
+	spin_lock_init(&priv->ps_state_lock);
+	INIT_DELAYED_WORK(&priv->set_cts_work, cw1200_set_cts_work);
+	INIT_WORK(&priv->set_tim_work, cw1200_set_tim_work);
+	INIT_WORK(&priv->multicast_start_work, cw1200_multicast_start_work);
+	INIT_WORK(&priv->multicast_stop_work, cw1200_multicast_stop_work);
+	INIT_WORK(&priv->link_id_work, cw1200_link_id_work);
+	INIT_DELAYED_WORK(&priv->link_id_gc_work, cw1200_link_id_gc_work);
+	INIT_WORK(&priv->linkid_reset_work, cw1200_link_id_reset);
+	INIT_WORK(&priv->update_filtering_work, cw1200_update_filtering_work);
+	INIT_WORK(&priv->ba_work, cw1200_ba_work);
+	spin_lock_init(&priv->ba_lock);
+	init_timer(&priv->ba_timer);
+	priv->ba_timer.data = (unsigned long)priv;
+	priv->ba_timer.function = cw1200_ba_timer;
+	init_timer(&priv->mcast_timeout);
+	priv->mcast_timeout.data = (unsigned long)priv;
+	priv->mcast_timeout.function = cw1200_mcast_timeout;
+
+	if (unlikely(cw1200_queue_stats_init(&priv->tx_queue_stats,
+			CW1200_LINK_ID_MAX,
+			cw1200_skb_dtor,
+			priv))) {
+		ieee80211_free_hw(hw);
+		return NULL;
+	}
+
+	for (i = 0; i < 4; ++i) {
+		if (unlikely(cw1200_queue_init(&priv->tx_queue[i],
+				&priv->tx_queue_stats, i, 16,
+				cw1200_ttl[i]))) {
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
+	wsm_buf_init(&priv->wsm_cmd_buf);
+	spin_lock_init(&priv->wsm_cmd.lock);
+	priv->wsm_cmd.done = 1;
+	tx_policy_init(priv);
+
+	return hw;
+}
+
+int cw1200_register_common(struct ieee80211_hw *dev)
+{
+	struct cw1200_common *priv = dev->priv;
+	int err;
+
+#ifdef CONFIG_CW1200_ETF
+	if (etf_mode)
+		goto done;
+#endif
+
+#ifdef CONFIG_CW1200_PM
+	err = cw1200_pm_init(&priv->pm_state, priv);
+	if (err) {
+		pr_err("Cannot init PM. (%d).\n",
+		       err);
+		return err;
+	}
+#endif
+	err = ieee80211_register_hw(dev);
+	if (err) {
+		pr_err("Cannot register device (%d).\n",
+		       err);
+#ifdef CONFIG_CW1200_PM
+		cw1200_pm_deinit(&priv->pm_state);
+#endif
+		return err;
+	}
+
+#ifdef CONFIG_CW1200_LEDS
+	err = cw1200_init_leds(priv);
+	if (err) {
+#ifdef CONFIG_CW1200_PM
+		cw1200_pm_deinit(&priv->pm_state);
+#endif
+		ieee80211_unregister_hw(dev);
+		return err;
+	}
+#endif /* CONFIG_CW1200_LEDS */
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
+void cw1200_free_common(struct ieee80211_hw *dev)
+{
+	ieee80211_free_hw(dev);
+}
+
+void cw1200_unregister_common(struct ieee80211_hw *dev)
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
+	del_timer_sync(&priv->ba_timer);
+	cw1200_unregister_bh(priv);
+
+	cw1200_debug_release(priv);
+
+#ifdef CONFIG_CW1200_LEDS
+	cw1200_unregister_leds(priv);
+#endif /* CONFIG_CW1200_LEDS */
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
+	cw1200_queue_stats_deinit(&priv->tx_queue_stats);
+#ifdef CONFIG_CW1200_PM
+	cw1200_pm_deinit(&priv->pm_state);
+#endif
+}
+
+/* Clock is in KHz */
+u32 cw1200_dpll_from_clk(u16 clk)
+{
+	switch (clk) {
+	case 0x32C8:
+		return 0x1D89D241;
+	case 0x3E80:
+		return 0x1E1;
+	case 0x41A0:
+		return 0x124931C1;
+	case 0x4B00:
+		return 0x191;
+	case 0x5DC0:
+		return 0x141;
+	case 0x6590:
+		return 0x0EC4F121;
+	case 0x8340:
+		return 0x92490E1;
+	case 0x9600:
+		return 0x100010C1;
+	case 0x9C40:
+		return 0xC1;
+	case 0xBB80:
+		return 0xA1;
+	case 0xCB20:
+		return 0x7627091;
+	default:
+		pr_err("ERROR: Unknown Reference clock frequency found (0x%04x), using default (26MHz)\n", clk);
+		return 0x0EC4F121;
+	}
+}
+
+int cw1200_core_probe(const struct sbus_ops *sbus_ops,
+		      struct sbus_priv *sbus,
+		      struct device *pdev,
+		      struct cw1200_common **core,
+		      int ref_clk, const u8 *macaddr,
+		      const char *sdd_path)
+{
+	int err = -ENOMEM;
+	struct ieee80211_hw *dev;
+	struct cw1200_common *priv;
+	struct wsm_operational_mode mode = {
+		.power_mode = cw1200_power_mode,
+		.disableMoreFlagUsage = true,
+	};
+
+	pr_info("CW1200 driver options: "
+#ifdef CONFIG_CW1200_NON_POWER_OF_TWO_BLOCKSIZES
+	       "NPTB "
+#endif
+#ifdef CONFIG_CW1200_USE_GPIO_IRQ
+	       "GPIO "
+#endif
+#ifdef CONFIG_CW1200_5GHZ_SUPPORT
+	       "5G "
+#endif
+#ifdef CONFIG_CW1200_PM
+	       "PM "
+#endif
+#ifdef CONFIG_CW1200_DEBUGFS
+	       "DBG "
+#endif
+#ifdef CONFIG_CW1200_POLL_IRQ
+	       "IRQPOLL "
+#endif
+	       "\n");
+
+	dev = cw1200_init_common(macaddr);
+	if (!dev)
+		goto err;
+
+	priv = dev->priv;
+	priv->hw_refclk = ref_clk;
+	if (cw1200_refclk) {
+		priv->hw_refclk = cw1200_refclk;
+	}
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
+	/* WSM callbacks. */
+	priv->wsm_cbc.scan_complete = cw1200_scan_complete_cb;
+	priv->wsm_cbc.scan_failed = cw1200_scan_failed_cb;
+	priv->wsm_cbc.tx_confirm = cw1200_tx_confirm_cb;
+	priv->wsm_cbc.rx = cw1200_rx_cb;
+	priv->wsm_cbc.suspend_resume = cw1200_suspend_resume;
+	/* priv->wsm_cbc.set_pm_complete = cw1200_set_pm_complete_cb; */
+	priv->wsm_cbc.channel_switch = cw1200_channel_switch_cb;
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
+				priv->wsm_caps.firmwareReady, 3*HZ) <= 0) {
+		/* TODO: Needs to find how to reset device */
+		/*       in QUEUE mode properly.           */
+		pr_err("Timeout waiting on device startup\n");
+		err = -ETIMEDOUT;
+		goto err2;
+	}
+
+	/* Set low-power mode. */
+	WARN_ON(wsm_set_operational_mode(priv, &mode));
+
+	/* Enable multi-TX confirmation */
+	WARN_ON(wsm_use_multi_tx_conf(priv, true));
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
+#ifndef CONFIG_CW1200_POLL_IRQ
+	priv->sbus_ops->irq_unsubscribe(priv->sbus_priv);
+#endif
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
+	cw1200_unregister_common(self->hw);
+	cw1200_free_common(self->hw);
+	return;
+}
+EXPORT_SYMBOL_GPL(cw1200_core_release);
diff --git a/drivers/staging/cw1200/sbus.h b/drivers/staging/cw1200/sbus.h
new file mode 100644
index 0000000..0461639
--- /dev/null
+++ b/drivers/staging/cw1200/sbus.h
@@ -0,0 +1,43 @@
+/*
+ * Common sbus abstraction layer interface for cw1200 wireless driver
+ *
+ * Copyright (c) 2010, ST-Ericsson
+ * Author: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
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
+int __cw1200_irq_enable(struct cw1200_common *priv, int enable);  /* Must be wrapped with sbus_ops->lock/unlock */
+
+struct sbus_ops {
+	int (*sbus_memcpy_fromio)(struct sbus_priv *self, unsigned int addr,
+					void *dst, int count);
+	int (*sbus_memcpy_toio)(struct sbus_priv *self, unsigned int addr,
+					const void *src, int count);
+	void (*lock)(struct sbus_priv *self);
+	void (*unlock)(struct sbus_priv *self);
+#ifndef CONFIG_CW1200_POLL_IRQ
+	int (*irq_subscribe)(struct sbus_priv *self);
+	int (*irq_unsubscribe)(struct sbus_priv *self);
+	void (*irq_enable)(struct sbus_priv *self, int enable);
+#endif
+	int (*reset)(struct sbus_priv *self);
+	size_t (*align_size)(struct sbus_priv *self, size_t size);
+#ifdef CONFIG_CW1200_PM
+	int (*power_mgmt)(struct sbus_priv *self, bool suspend);
+#endif
+};
+
+#endif /* CW1200_SBUS_H */
-- 
1.7.11.7

