Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:40089 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947054Ab3BHUcd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 15:32:33 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH 07/14] cw1200: v4: mac80211 API implementation
Date: Fri,  8 Feb 2013 15:32:00 -0500
Message-Id: <1360355527-12159-8-git-send-email-pizza@shaftnet.org> (sfid-20130208_214109_189287_50A0A59A)
In-Reply-To: <1360355527-12159-1-git-send-email-pizza@shaftnet.org>
References: <1360355527-12159-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/net/wireless/cw1200/sta.c | 2485 +++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/cw1200/sta.h |  122 ++
 2 files changed, 2607 insertions(+)
 create mode 100644 drivers/net/wireless/cw1200/sta.c
 create mode 100644 drivers/net/wireless/cw1200/sta.h

diff --git a/drivers/net/wireless/cw1200/sta.c b/drivers/net/wireless/cw1200/sta.c
new file mode 100644
index 0000000..0656fff
--- /dev/null
+++ b/drivers/net/wireless/cw1200/sta.c
@@ -0,0 +1,2485 @@
+/*
+ * Mac80211 STA API for ST-Ericsson CW1200 drivers
+ *
+ * Copyright (c) 2010, ST-Ericsson
+ * Author: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/vmalloc.h>
+#include <linux/sched.h>
+#include <linux/firmware.h>
+
+#include "cw1200.h"
+#include "sta.h"
+#include "fwio.h"
+#include "bh.h"
+#include "debug.h"
+
+#ifndef ERP_INFO_BYTE_OFFSET
+#define ERP_INFO_BYTE_OFFSET 2
+#endif
+
+
+static int cw1200_upload_beacon(struct cw1200_common *priv);
+static int cw1200_upload_pspoll(struct cw1200_common *priv);
+static int cw1200_upload_null(struct cw1200_common *priv);
+static int cw1200_upload_qosnull(struct cw1200_common *priv);
+static int cw1200_start_ap(struct cw1200_common *priv);
+static int cw1200_update_beaconing(struct cw1200_common *priv);
+static int cw1200_enable_beaconing(struct cw1200_common *priv,
+				   bool enable);
+static void __cw1200_sta_notify(struct ieee80211_hw *dev,
+				struct ieee80211_vif *vif,
+				enum sta_notify_cmd notify_cmd,
+				int link_id);
+static int __cw1200_flush(struct cw1200_common *priv, bool drop);
+
+static inline void __cw1200_free_event_queue(struct list_head *list)
+{
+	struct cw1200_wsm_event *event, *tmp;
+	list_for_each_entry_safe(event, tmp, list, link) {
+		list_del(&event->link);
+		kfree(event);
+	}
+}
+
+static inline void __cw1200_bf_configure(struct cw1200_common *priv)
+{
+	priv->bf_table.numOfIEs = __cpu_to_le32(3);
+	priv->bf_table.entry[0].ieId = WLAN_EID_VENDOR_SPECIFIC;
+	priv->bf_table.entry[0].actionFlags = WSM_BEACON_FILTER_IE_HAS_CHANGED |
+					WSM_BEACON_FILTER_IE_NO_LONGER_PRESENT |
+					WSM_BEACON_FILTER_IE_HAS_APPEARED;
+	priv->bf_table.entry[0].oui[0] = 0x50;
+	priv->bf_table.entry[0].oui[1] = 0x6F;
+	priv->bf_table.entry[0].oui[2] = 0x9A;
+	priv->bf_table.entry[1].ieId = WLAN_EID_ERP_INFO;
+	priv->bf_table.entry[1].actionFlags = WSM_BEACON_FILTER_IE_HAS_CHANGED |
+					WSM_BEACON_FILTER_IE_NO_LONGER_PRESENT |
+					WSM_BEACON_FILTER_IE_HAS_APPEARED;
+	priv->bf_table.entry[2].ieId = WLAN_EID_HT_OPERATION;
+	priv->bf_table.entry[2].actionFlags = WSM_BEACON_FILTER_IE_HAS_CHANGED |
+					WSM_BEACON_FILTER_IE_NO_LONGER_PRESENT |
+					WSM_BEACON_FILTER_IE_HAS_APPEARED;
+
+	priv->bf_control.enabled = WSM_BEACON_FILTER_ENABLE;
+}
+
+/* ******************************************************************** */
+/* STA API								*/
+
+int cw1200_start(struct ieee80211_hw *dev)
+{
+	struct cw1200_common *priv = dev->priv;
+	int ret = 0;
+
+	cw1200_pm_stay_awake(&priv->pm_state, HZ);
+
+	mutex_lock(&priv->conf_mutex);
+
+	/* default EDCA */
+	WSM_EDCA_SET(&priv->edca, 0, 0x0002, 0x0003, 0x0007, 47, 0xc8, false);
+	WSM_EDCA_SET(&priv->edca, 1, 0x0002, 0x0007, 0x000f, 94, 0xc8, false);
+	WSM_EDCA_SET(&priv->edca, 2, 0x0003, 0x000f, 0x03ff, 0, 0xc8, false);
+	WSM_EDCA_SET(&priv->edca, 3, 0x0007, 0x000f, 0x03ff, 0, 0xc8, false);
+	ret = wsm_set_edca_params(priv, &priv->edca);
+	if (WARN_ON(ret))
+		goto out;
+
+	ret = cw1200_set_uapsd_param(priv, &priv->edca);
+	if (WARN_ON(ret))
+		goto out;
+
+	priv->setbssparams_done = false;
+
+	memcpy(priv->mac_addr, dev->wiphy->perm_addr, ETH_ALEN);
+	priv->mode = NL80211_IFTYPE_MONITOR;
+	priv->wep_default_key_id = -1;
+
+	priv->cqm_beacon_loss_count = 20;
+
+	/* Temporary configuration - beacon filter table */
+	__cw1200_bf_configure(priv);
+
+	ret = cw1200_setup_mac(priv);
+	if (WARN_ON(ret))
+		goto out;
+
+	/* err = cw1200_set_leds(priv); */
+
+out:
+	mutex_unlock(&priv->conf_mutex);
+	return ret;
+}
+
+void cw1200_stop(struct ieee80211_hw *dev)
+{
+	struct cw1200_common *priv = dev->priv;
+	LIST_HEAD(list);
+	int i;
+
+	wsm_lock_tx(priv);
+
+	while (down_trylock(&priv->scan.lock)) {
+		/* Scan is in progress. Force it to stop. */
+		priv->scan.req = NULL;
+		schedule();
+	}
+	up(&priv->scan.lock);
+
+	cancel_delayed_work_sync(&priv->scan.probe_work);
+	cancel_delayed_work_sync(&priv->scan.timeout);
+	cancel_delayed_work_sync(&priv->clear_recent_scan_work);
+	cancel_delayed_work_sync(&priv->join_timeout);
+	cancel_delayed_work_sync(&priv->bss_loss_work);
+	cancel_delayed_work_sync(&priv->connection_loss_work);
+	cancel_work_sync(&priv->unjoin_work);
+	cancel_delayed_work_sync(&priv->link_id_gc_work);
+	flush_workqueue(priv->workqueue);
+	del_timer_sync(&priv->mcast_timeout);
+	mutex_lock(&priv->conf_mutex);
+	priv->mode = NL80211_IFTYPE_UNSPECIFIED;
+	priv->listening = false;
+
+	spin_lock(&priv->event_queue_lock);
+	list_splice_init(&priv->event_queue, &list);
+	spin_unlock(&priv->event_queue_lock);
+	__cw1200_free_event_queue(&list);
+
+	priv->delayed_link_loss = 0;
+	spin_lock(&priv->bss_loss_lock);
+	priv->bss_loss_status = CW1200_BSS_LOSS_NONE;
+	priv->bss_loss_checking = 0;
+	spin_unlock(&priv->bss_loss_lock);
+
+	priv->join_status = CW1200_JOIN_STATUS_PASSIVE;
+	priv->join_pending = 0;
+
+	for (i = 0; i < 4; i++)
+		cw1200_queue_clear(&priv->tx_queue[i]);
+	mutex_unlock(&priv->conf_mutex);
+	tx_policy_clean(priv);
+
+	/* HACK! */
+	if (atomic_xchg(&priv->tx_lock, 1) != 1)
+		pr_debug("[STA] TX is force-unlocked due to stop request.\n");
+
+	wsm_unlock_tx(priv);
+	atomic_xchg(&priv->tx_lock, 0); /* for recovery to work */
+}
+
+int cw1200_add_interface(struct ieee80211_hw *dev,
+			 struct ieee80211_vif *vif)
+{
+	int ret;
+	struct cw1200_common *priv = dev->priv;
+	/* __le32 auto_calibration_mode = __cpu_to_le32(1); */
+
+	vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER |
+			     IEEE80211_VIF_SUPPORTS_CQM_RSSI;
+
+	mutex_lock(&priv->conf_mutex);
+
+	if (priv->mode != NL80211_IFTYPE_MONITOR) {
+		mutex_unlock(&priv->conf_mutex);
+		return -EOPNOTSUPP;
+	}
+
+	switch (vif->type) {
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_MESH_POINT:
+	case NL80211_IFTYPE_AP:
+		priv->mode = vif->type;
+		break;
+	default:
+		mutex_unlock(&priv->conf_mutex);
+		return -EOPNOTSUPP;
+	}
+
+	priv->vif = vif;
+	memcpy(priv->mac_addr, vif->addr, ETH_ALEN);
+	ret = WARN_ON(cw1200_setup_mac(priv));
+	/* Enable auto-calibration */
+	/* Exception in subsequent channel switch; disabled.
+	WARN_ON(wsm_write_mib(priv, WSM_MIB_ID_SET_AUTO_CALIBRATION_MODE,
+		&auto_calibration_mode, sizeof(auto_calibration_mode)));
+	*/
+
+	mutex_unlock(&priv->conf_mutex);
+	return ret;
+}
+
+void cw1200_remove_interface(struct ieee80211_hw *dev,
+			     struct ieee80211_vif *vif)
+{
+	struct cw1200_common *priv = dev->priv;
+	struct wsm_reset reset = {
+		.reset_statistics = true,
+	};
+	int i;
+
+	mutex_lock(&priv->conf_mutex);
+	wsm_lock_tx(priv);
+	switch (priv->join_status) {
+	case CW1200_JOIN_STATUS_JOINING:
+	case CW1200_JOIN_STATUS_PRE_STA:
+	case CW1200_JOIN_STATUS_STA:
+		wsm_lock_tx(priv);
+		if (queue_work(priv->workqueue, &priv->unjoin_work) <= 0)
+			wsm_unlock_tx(priv);
+		break;
+	case CW1200_JOIN_STATUS_AP:
+		for (i = 0; priv->link_id_map; ++i) {
+			if (priv->link_id_map & BIT(i)) {
+				reset.link_id = i;
+				wsm_reset(priv, &reset);
+				priv->link_id_map &= ~BIT(i);
+			}
+		}
+		memset(priv->link_id_db, 0,
+				sizeof(priv->link_id_db));
+		priv->sta_asleep_mask = 0;
+		priv->enable_beacon = false;
+		priv->tx_multicast = false;
+		priv->aid0_bit_set = false;
+		priv->buffered_multicasts = false;
+		priv->pspoll_mask = 0;
+		reset.link_id = 0;
+		wsm_reset(priv, &reset);
+		break;
+	case CW1200_JOIN_STATUS_MONITOR:
+		cw1200_update_listening(priv, false);
+		break;
+	default:
+		break;
+	}
+	priv->vif = NULL;
+	priv->mode = NL80211_IFTYPE_MONITOR;
+	memset(priv->mac_addr, 0, ETH_ALEN);
+	memset(&priv->p2p_ps_modeinfo, 0, sizeof(priv->p2p_ps_modeinfo));
+	cw1200_free_keys(priv);
+	cw1200_setup_mac(priv);
+	priv->listening = false;
+	priv->join_status = CW1200_JOIN_STATUS_PASSIVE;
+	__cw1200_flush(priv, true);
+	wsm_unlock_tx(priv);
+
+	mutex_unlock(&priv->conf_mutex);
+}
+
+int cw1200_change_interface(struct ieee80211_hw *dev,
+			    struct ieee80211_vif *vif,
+			    enum nl80211_iftype new_type,
+			    bool p2p)
+{
+	int ret = 0;
+	pr_debug("%s called: new_type: %d (%d), old_type: %d (%d)\n", __func__, new_type,
+		   p2p, vif->type, vif->p2p);
+
+	if (new_type != vif->type || vif->p2p != p2p) {
+		cw1200_remove_interface(dev, vif);
+		vif->type = new_type;
+		vif->p2p = p2p;
+		ret = cw1200_add_interface(dev, vif);
+	}
+
+	return ret;
+}
+
+int cw1200_config(struct ieee80211_hw *dev, u32 changed)
+{
+	int ret = 0;
+	struct cw1200_common *priv = dev->priv;
+	struct ieee80211_conf *conf = &dev->conf;
+
+	down(&priv->scan.lock);
+	mutex_lock(&priv->conf_mutex);
+	/* TODO: IEEE80211_CONF_CHANGE_QOS */
+	if (changed & IEEE80211_CONF_CHANGE_POWER) {
+		priv->output_power = conf->power_level;
+		pr_debug("[STA] TX power: %d\n",
+				priv->output_power);
+		WARN_ON(wsm_set_output_power(priv, priv->output_power * 10));
+	}
+
+	if ((changed & IEEE80211_CONF_CHANGE_CHANNEL) &&
+			(priv->channel != conf->channel)) {
+		struct ieee80211_channel *ch = conf->channel;
+		struct wsm_switch_channel channel = {
+			.newChannelNumber = ch->hw_value,
+		};
+		pr_debug("[STA] Freq %d (wsm ch: %d).\n",
+			ch->center_freq, ch->hw_value);
+
+		ret = __cw1200_flush(priv, false);
+		if (!ret) {
+			ret = WARN_ON(wsm_switch_channel(priv, &channel));
+			if (!ret) {
+				ret = wait_event_timeout(
+					priv->channel_switch_done,
+					!priv->channel_switch_in_progress,
+					3 * HZ);
+				/* TODO: We should check also switch channel
+				 * complete indication
+				 */
+				if (ret) {
+					priv->channel = ch;
+					ret = 0;
+				} else
+					ret = -ETIMEDOUT;
+			} else
+				wsm_unlock_tx(priv);
+		}
+	}
+
+	if (changed & IEEE80211_CONF_CHANGE_PS) {
+		if (!(conf->flags & IEEE80211_CONF_PS))
+			priv->powersave_mode.pmMode = WSM_PSM_ACTIVE;
+		else if (conf->dynamic_ps_timeout <= 0)
+			priv->powersave_mode.pmMode = WSM_PSM_PS;
+		else
+			priv->powersave_mode.pmMode = WSM_PSM_FAST_PS;
+
+		/* Firmware requires that value for this 1-byte field must
+		 * be specified in units of 500us. Values above the 128ms
+		 * threshold are not supported. */
+		if (conf->dynamic_ps_timeout >= 0x80)
+			priv->powersave_mode.fastPsmIdlePeriod = 0xFF;
+		else
+			priv->powersave_mode.fastPsmIdlePeriod =
+					conf->dynamic_ps_timeout << 1;
+
+		if (priv->join_status == CW1200_JOIN_STATUS_STA &&
+				priv->bss_params.aid)
+			cw1200_set_pm(priv, &priv->powersave_mode);
+	}
+
+	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
+		/* TBD: It looks like it's transparent
+		 * there's a monitor interface present -- use this
+		 * to determine for example whether to calculate
+		 * timestamps for packets or not, do not use instead
+		 * of filter flags! */
+	}
+
+	if (changed & IEEE80211_CONF_CHANGE_IDLE) {
+		struct wsm_operational_mode mode = {
+			.power_mode = cw1200_power_mode,
+			.disableMoreFlagUsage = true,
+		};
+
+		wsm_lock_tx(priv);
+		/* Disable p2p-dev mode forced by TX request */
+		if ((priv->join_status == CW1200_JOIN_STATUS_MONITOR) &&
+				(conf->flags & IEEE80211_CONF_IDLE) &&
+				!priv->listening) {
+			cw1200_disable_listening(priv);
+			priv->join_status = CW1200_JOIN_STATUS_PASSIVE;
+		}
+		WARN_ON(wsm_set_operational_mode(priv, &mode));
+		wsm_unlock_tx(priv);
+	}
+
+	if (changed & IEEE80211_CONF_CHANGE_RETRY_LIMITS) {
+		pr_debug("[STA] Retry limits: %d (long), " \
+			"%d (short).\n",
+			conf->long_frame_max_tx_count,
+			conf->short_frame_max_tx_count);
+		spin_lock_bh(&priv->tx_policy_cache.lock);
+		priv->long_frame_max_tx_count = conf->long_frame_max_tx_count;
+		priv->short_frame_max_tx_count =
+			(conf->short_frame_max_tx_count < 0x0F) ?
+			conf->short_frame_max_tx_count : 0x0F;
+		priv->hw->max_rate_tries = priv->short_frame_max_tx_count;
+		spin_unlock_bh(&priv->tx_policy_cache.lock);
+		/* TBD: I think we don't need tx_policy_force_upload().
+		 * Outdated policies will leave cache in a normal way. */
+		/* WARN_ON(tx_policy_force_upload(priv)); */
+	}
+	mutex_unlock(&priv->conf_mutex);
+	up(&priv->scan.lock);
+	return ret;
+}
+
+void cw1200_update_filtering(struct cw1200_common *priv)
+{
+	int ret;
+	bool bssid_filtering = !priv->rx_filter.bssid;
+	bool is_p2p = priv->vif && priv->vif->p2p;
+	bool is_sta = priv->vif && NL80211_IFTYPE_STATION == priv->vif->type;
+	static struct wsm_beacon_filter_control bf_disabled = {
+		.enabled = 0,
+		.bcn_count = 1,
+	};
+	static struct wsm_beacon_filter_table bf_table_auto = {
+		.numOfIEs = __cpu_to_le32(2),
+		.entry[0].ieId = WLAN_EID_VENDOR_SPECIFIC,
+		.entry[0].actionFlags = WSM_BEACON_FILTER_IE_HAS_CHANGED |
+					WSM_BEACON_FILTER_IE_NO_LONGER_PRESENT |
+					WSM_BEACON_FILTER_IE_HAS_APPEARED,
+		.entry[0].oui[0] = 0x50,
+		.entry[0].oui[1] = 0x6F,
+		.entry[0].oui[2] = 0x9A,
+		.entry[1].ieId = WLAN_EID_HT_OPERATION,
+		.entry[1].actionFlags = WSM_BEACON_FILTER_IE_HAS_CHANGED |
+					WSM_BEACON_FILTER_IE_NO_LONGER_PRESENT |
+					WSM_BEACON_FILTER_IE_HAS_APPEARED,
+	};
+	static struct wsm_beacon_filter_control bf_auto = {
+		.enabled = WSM_BEACON_FILTER_ENABLE |
+			WSM_BEACON_FILTER_AUTO_ERP,
+		.bcn_count = 1,
+	};
+	bf_auto.bcn_count = priv->bf_control.bcn_count;
+
+	if (priv->join_status == CW1200_JOIN_STATUS_PASSIVE)
+		return;
+	else if (priv->join_status == CW1200_JOIN_STATUS_MONITOR)
+		bssid_filtering = false;
+
+	/*
+	* When acting as p2p client being connected to p2p GO, in order to
+	* receive frames from a different p2p device, turn off bssid filter.
+	*
+	* WARNING: FW dependency!
+	* This can only be used with FW WSM371 and its successors.
+	* In that FW version even with bssid filter turned off,
+	* device will block most of the unwanted frames.
+	*/
+	if (is_p2p)
+		bssid_filtering = false;
+
+	ret = wsm_set_rx_filter(priv, &priv->rx_filter);
+	if (!ret) {
+		if (is_p2p || !is_sta)
+			ret = wsm_set_beacon_filter_table(priv, &priv->bf_table);
+		else
+			ret = wsm_set_beacon_filter_table(priv, &bf_table_auto);
+	}
+	if (!ret) {
+		if (priv->disable_beacon_filter) {
+			ret = wsm_beacon_filter_control(priv,
+					&bf_disabled);
+		} else {
+			if (is_p2p || !is_sta)
+				ret = wsm_beacon_filter_control(priv,
+						&priv->bf_control);
+			else
+				ret = wsm_beacon_filter_control(priv,
+						&bf_auto);
+		}
+	}
+	if (!ret)
+		ret = wsm_set_bssid_filtering(priv, bssid_filtering);
+	if (!ret)
+		ret = wsm_set_multicast_filter(priv, &priv->multicast_filter);
+	if (ret)
+		wiphy_err(priv->hw->wiphy,
+				"%s: Update filtering failed: %d.\n",
+				__func__, ret);
+	return;
+}
+
+void cw1200_update_filtering_work(struct work_struct *work)
+{
+	struct cw1200_common *priv =
+		container_of(work, struct cw1200_common,
+		update_filtering_work);
+
+	cw1200_update_filtering(priv);
+}
+
+void cw1200_set_beacon_wakeup_period_work(struct work_struct *work)
+{
+	struct cw1200_common *priv =
+		container_of(work, struct cw1200_common,
+		set_beacon_wakeup_period_work);
+
+	WARN_ON(wsm_set_beacon_wakeup_period(priv,
+		priv->beacon_int * priv->join_dtim_period >
+		MAX_BEACON_SKIP_TIME_MS ? 1 :
+		priv->join_dtim_period, 0));
+}
+
+u64 cw1200_prepare_multicast(struct ieee80211_hw *hw,
+			     struct netdev_hw_addr_list *mc_list)
+{
+	static u8 broadcast_ipv6[ETH_ALEN] = {
+		0x33, 0x33, 0x00, 0x00, 0x00, 0x01
+	};
+	static u8 broadcast_ipv4[ETH_ALEN] = {
+		0x01, 0x00, 0x5e, 0x00, 0x00, 0x01
+	};
+	struct cw1200_common *priv = hw->priv;
+	struct netdev_hw_addr *ha;
+	int count = 0;
+
+	/* Disable multicast filtering */
+	priv->has_multicast_subscription = false;
+	memset(&priv->multicast_filter, 0x00, sizeof(priv->multicast_filter));
+
+	if (netdev_hw_addr_list_count(mc_list) > WSM_MAX_GRP_ADDRTABLE_ENTRIES)
+		return 0;
+
+	/* Enable if requested */
+	netdev_hw_addr_list_for_each(ha, mc_list) {
+		pr_debug("[STA] multicast: %pM\n", ha->addr);
+		memcpy(&priv->multicast_filter.macAddress[count],
+		       ha->addr, ETH_ALEN);
+		if (memcmp(ha->addr, broadcast_ipv4, ETH_ALEN) &&
+				memcmp(ha->addr, broadcast_ipv6, ETH_ALEN))
+			priv->has_multicast_subscription = true;
+		count++;
+	}
+
+	if (count) {
+		priv->multicast_filter.enable = __cpu_to_le32(1);
+		priv->multicast_filter.numOfAddresses = __cpu_to_le32(count);
+	}
+
+	return netdev_hw_addr_list_count(mc_list);
+}
+
+void cw1200_configure_filter(struct ieee80211_hw *dev,
+			     unsigned int changed_flags,
+			     unsigned int *total_flags,
+			     u64 multicast)
+{
+	struct cw1200_common *priv = dev->priv;
+	bool listening = !!(*total_flags &
+			(FIF_PROMISC_IN_BSS |
+			 FIF_OTHER_BSS |
+			 FIF_BCN_PRBRESP_PROMISC |
+			 FIF_PROBE_REQ));
+
+	*total_flags &= FIF_PROMISC_IN_BSS |
+			FIF_OTHER_BSS |
+			FIF_FCSFAIL |
+			FIF_BCN_PRBRESP_PROMISC |
+			FIF_PROBE_REQ;
+
+	down(&priv->scan.lock);
+	mutex_lock(&priv->conf_mutex);
+
+	priv->rx_filter.promiscuous = (*total_flags & FIF_PROMISC_IN_BSS)
+			? 1 : 0;
+	priv->rx_filter.bssid = (*total_flags & (FIF_OTHER_BSS |
+			FIF_PROBE_REQ)) ? 1 : 0;
+	priv->rx_filter.fcs = (*total_flags & FIF_FCSFAIL) ? 1 : 0;
+	priv->bf_control.bcn_count = (*total_flags &
+			(FIF_BCN_PRBRESP_PROMISC |
+			 FIF_PROMISC_IN_BSS |
+			 FIF_PROBE_REQ)) ? 1 : 0;
+	if (priv->listening != listening) {
+		priv->listening = listening;
+		wsm_lock_tx(priv);
+		cw1200_update_listening(priv, listening);
+		wsm_unlock_tx(priv);
+	}
+	cw1200_update_filtering(priv);
+	mutex_unlock(&priv->conf_mutex);
+	up(&priv->scan.lock);
+}
+
+int cw1200_conf_tx(struct ieee80211_hw *dev, struct ieee80211_vif *vif,
+		   u16 queue, const struct ieee80211_tx_queue_params *params)
+{
+	struct cw1200_common *priv = dev->priv;
+	int ret = 0;
+	/* To prevent re-applying PM request OID again and again*/
+	bool old_uapsdFlags;
+
+	mutex_lock(&priv->conf_mutex);
+
+	if (queue < dev->queues) {
+		old_uapsdFlags = priv->uapsd_info.uapsdFlags;
+
+		WSM_TX_QUEUE_SET(&priv->tx_queue_params, queue, 0, 0, 0);
+		ret = wsm_set_tx_queue_params(priv,
+				&priv->tx_queue_params.params[queue], queue);
+		if (ret) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		WSM_EDCA_SET(&priv->edca, queue, params->aifs,
+			params->cw_min, params->cw_max, params->txop, 0xc8,
+			params->uapsd);
+		ret = wsm_set_edca_params(priv, &priv->edca);
+		if (ret) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		if (priv->mode == NL80211_IFTYPE_STATION) {
+			ret = cw1200_set_uapsd_param(priv, &priv->edca);
+			if (!ret && priv->setbssparams_done &&
+				(priv->join_status == CW1200_JOIN_STATUS_STA) &&
+				(old_uapsdFlags != priv->uapsd_info.uapsdFlags))
+				cw1200_set_pm(priv, &priv->powersave_mode);
+		}
+	} else
+		ret = -EINVAL;
+
+out:
+	mutex_unlock(&priv->conf_mutex);
+	return ret;
+}
+
+int cw1200_get_stats(struct ieee80211_hw *dev,
+		     struct ieee80211_low_level_stats *stats)
+{
+	struct cw1200_common *priv = dev->priv;
+
+	memcpy(stats, &priv->stats, sizeof(*stats));
+	return 0;
+}
+
+/*
+int cw1200_get_tx_stats(struct ieee80211_hw *dev,
+			struct ieee80211_tx_queue_stats *stats)
+{
+	int i;
+	struct cw1200_common *priv = dev->priv;
+
+	for (i = 0; i < dev->queues; ++i)
+		cw1200_queue_get_stats(&priv->tx_queue[i], &stats[i]);
+
+	return 0;
+}
+*/
+
+int cw1200_set_pm(struct cw1200_common *priv, const struct wsm_set_pm *arg)
+{
+	struct wsm_set_pm pm = *arg;
+
+	if (priv->uapsd_info.uapsdFlags != 0)
+		pm.pmMode &= ~WSM_PSM_FAST_PS_FLAG;
+
+	if (memcmp(&pm, &priv->firmware_ps_mode,
+			sizeof(struct wsm_set_pm))) {
+		priv->firmware_ps_mode = pm;
+		return wsm_set_pm(priv, &pm);
+	} else {
+		return 0;
+	}
+}
+
+int cw1200_set_key(struct ieee80211_hw *dev, enum set_key_cmd cmd,
+		   struct ieee80211_vif *vif, struct ieee80211_sta *sta,
+		   struct ieee80211_key_conf *key)
+{
+	int ret = -EOPNOTSUPP;
+	struct cw1200_common *priv = dev->priv;
+
+	mutex_lock(&priv->conf_mutex);
+
+	if (cmd == SET_KEY) {
+		u8 *peer_addr = NULL;
+		int pairwise = (key->flags & IEEE80211_KEY_FLAG_PAIRWISE) ?
+			1 : 0;
+		int idx = cw1200_alloc_key(priv);
+		struct wsm_add_key *wsm_key = &priv->keys[idx];
+
+		if (idx < 0) {
+			ret = -EINVAL;
+			goto finally;
+		}
+
+		if (sta)
+			peer_addr = sta->addr;
+
+		key->flags |= IEEE80211_KEY_FLAG_PUT_IV_SPACE;
+
+		switch (key->cipher) {
+		case WLAN_CIPHER_SUITE_WEP40:
+		case WLAN_CIPHER_SUITE_WEP104:
+			if (key->keylen > 16) {
+				cw1200_free_key(priv, idx);
+				ret = -EINVAL;
+				goto finally;
+			}
+
+			if (pairwise) {
+				wsm_key->type = WSM_KEY_TYPE_WEP_PAIRWISE;
+				memcpy(wsm_key->wepPairwiseKey.peerAddress,
+					 peer_addr, ETH_ALEN);
+				memcpy(wsm_key->wepPairwiseKey.keyData,
+					&key->key[0], key->keylen);
+				wsm_key->wepPairwiseKey.keyLength = key->keylen;
+			} else {
+				wsm_key->type = WSM_KEY_TYPE_WEP_DEFAULT;
+				memcpy(wsm_key->wepGroupKey.keyData,
+					&key->key[0], key->keylen);
+				wsm_key->wepGroupKey.keyLength = key->keylen;
+				wsm_key->wepGroupKey.keyId = key->keyidx;
+			}
+			break;
+		case WLAN_CIPHER_SUITE_TKIP:
+			if (pairwise) {
+				wsm_key->type = WSM_KEY_TYPE_TKIP_PAIRWISE;
+				memcpy(wsm_key->tkipPairwiseKey.peerAddress,
+					peer_addr, ETH_ALEN);
+				memcpy(wsm_key->tkipPairwiseKey.tkipKeyData,
+					&key->key[0],  16);
+				memcpy(wsm_key->tkipPairwiseKey.txMicKey,
+					&key->key[16],  8);
+				memcpy(wsm_key->tkipPairwiseKey.rxMicKey,
+					&key->key[24],  8);
+			} else {
+				size_t mic_offset =
+					(priv->mode == NL80211_IFTYPE_AP) ?
+					16 : 24;
+				wsm_key->type = WSM_KEY_TYPE_TKIP_GROUP;
+				memcpy(wsm_key->tkipGroupKey.tkipKeyData,
+					&key->key[0],  16);
+				memcpy(wsm_key->tkipGroupKey.rxMicKey,
+					&key->key[mic_offset],  8);
+
+				/* TODO: Where can I find TKIP SEQ? */
+				memset(wsm_key->tkipGroupKey.rxSeqCounter,
+					0,		8);
+				wsm_key->tkipGroupKey.keyId = key->keyidx;
+			}
+			break;
+		case WLAN_CIPHER_SUITE_CCMP:
+			if (pairwise) {
+				wsm_key->type = WSM_KEY_TYPE_AES_PAIRWISE;
+				memcpy(wsm_key->aesPairwiseKey.peerAddress,
+					peer_addr, ETH_ALEN);
+				memcpy(wsm_key->aesPairwiseKey.aesKeyData,
+					&key->key[0],  16);
+			} else {
+				wsm_key->type = WSM_KEY_TYPE_AES_GROUP;
+				memcpy(wsm_key->aesGroupKey.aesKeyData,
+					&key->key[0],  16);
+				/* TODO: Where can I find AES SEQ? */
+				memset(wsm_key->aesGroupKey.rxSeqCounter,
+					0,              8);
+				wsm_key->aesGroupKey.keyId = key->keyidx;
+			}
+			break;
+		case WLAN_CIPHER_SUITE_SMS4:
+			if (pairwise) {
+				wsm_key->type = WSM_KEY_TYPE_WAPI_PAIRWISE;
+				memcpy(wsm_key->wapiPairwiseKey.peerAddress,
+					peer_addr, ETH_ALEN);
+				memcpy(wsm_key->wapiPairwiseKey.wapiKeyData,
+					&key->key[0],  16);
+				memcpy(wsm_key->wapiPairwiseKey.micKeyData,
+					&key->key[16], 16);
+				wsm_key->wapiPairwiseKey.keyId = key->keyidx;
+			} else {
+				wsm_key->type = WSM_KEY_TYPE_WAPI_GROUP;
+				memcpy(wsm_key->wapiGroupKey.wapiKeyData,
+					&key->key[0],  16);
+				memcpy(wsm_key->wapiGroupKey.micKeyData,
+					&key->key[16], 16);
+				wsm_key->wapiGroupKey.keyId = key->keyidx;
+			}
+			break;
+		default:
+			WARN_ON(1);
+			cw1200_free_key(priv, idx);
+			ret = -EOPNOTSUPP;
+			goto finally;
+		}
+		ret = WARN_ON(wsm_add_key(priv, wsm_key));
+		if (!ret)
+			key->hw_key_idx = idx;
+		else
+			cw1200_free_key(priv, idx);
+	} else if (cmd == DISABLE_KEY) {
+		struct wsm_remove_key wsm_key = {
+			.entryIndex = key->hw_key_idx,
+		};
+
+		if (wsm_key.entryIndex > WSM_KEY_MAX_INDEX) {
+			ret = -EINVAL;
+			goto finally;
+		}
+
+		cw1200_free_key(priv, wsm_key.entryIndex);
+		ret = wsm_remove_key(priv, &wsm_key);
+	} else {
+		BUG_ON("Unsupported command");
+	}
+
+finally:
+	mutex_unlock(&priv->conf_mutex);
+	return ret;
+}
+
+void cw1200_wep_key_work(struct work_struct *work)
+{
+	struct cw1200_common *priv =
+		container_of(work, struct cw1200_common, wep_key_work);
+	u8 queueId = cw1200_queue_get_queue_id(priv->pending_frame_id);
+	struct cw1200_queue *queue = &priv->tx_queue[queueId];
+	__le32 wep_default_key_id = __cpu_to_le32(
+		priv->wep_default_key_id);
+
+	pr_debug("[STA] Setting default WEP key: %d\n",
+		priv->wep_default_key_id);
+	wsm_flush_tx(priv);
+	WARN_ON(wsm_write_mib(priv, WSM_MIB_ID_DOT11_WEP_DEFAULT_KEY_ID,
+		&wep_default_key_id, sizeof(wep_default_key_id)));
+	cw1200_queue_requeue(queue, priv->pending_frame_id);
+	wsm_unlock_tx(priv);
+}
+
+int cw1200_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
+{
+	int ret = 0;
+	__le32 val32;
+	struct cw1200_common *priv = hw->priv;
+
+	if (priv->mode == NL80211_IFTYPE_UNSPECIFIED)
+		return 0;
+
+	if (value != (u32) -1)
+		val32 = __cpu_to_le32(value);
+	else
+		val32 = 0; /* disabled */
+
+	if (priv->mode == NL80211_IFTYPE_UNSPECIFIED) {
+		/* device is down, can _not_ set threshold */
+		ret = -ENODEV;
+		goto out;
+	}
+
+	if (priv->rts_threshold == value)
+		goto out;
+
+	pr_debug("[STA] Setting RTS threshold: %d\n",
+		 priv->rts_threshold);
+
+	/* mutex_lock(&priv->conf_mutex); */
+	ret = WARN_ON(wsm_write_mib(priv, WSM_MIB_ID_DOT11_RTS_THRESHOLD,
+				    &val32, sizeof(val32)));
+	if (!ret)
+		priv->rts_threshold = value;
+	/* mutex_unlock(&priv->conf_mutex); */
+
+out:
+	return ret;
+}
+
+static int __cw1200_flush(struct cw1200_common *priv, bool drop)
+{
+	int i, ret;
+
+	for (;;) {
+		/* TODO: correct flush handling is required when dev_stop.
+		 * Temporary workaround: 2s
+		 */
+		if (drop) {
+			for (i = 0; i < 4; ++i)
+				cw1200_queue_clear(&priv->tx_queue[i]);
+		} else {
+			ret = wait_event_timeout(
+				priv->tx_queue_stats.wait_link_id_empty,
+				cw1200_queue_stats_is_empty(
+					&priv->tx_queue_stats, -1),
+				2 * HZ);
+		}
+
+		if (!drop && ret <= 0) {
+			ret = -ETIMEDOUT;
+			break;
+		} else {
+			ret = 0;
+		}
+
+		wsm_lock_tx(priv);
+		if (!cw1200_queue_stats_is_empty(&priv->tx_queue_stats, -1)) {
+			/* Highly unlekely: WSM requeued frames. */
+			wsm_unlock_tx(priv);
+			continue;
+		}
+		break;
+	}
+	return ret;
+}
+
+void cw1200_flush(struct ieee80211_hw *hw, bool drop)
+{
+	struct cw1200_common *priv = hw->priv;
+
+	switch (priv->mode) {
+	case NL80211_IFTYPE_MONITOR:
+		drop = true;
+		break;
+	case NL80211_IFTYPE_AP:
+		if (!priv->enable_beacon)
+			drop = true;
+		break;
+	}
+
+	__cw1200_flush(priv, drop);
+	wsm_unlock_tx(priv);
+
+	return;
+}
+
+/* ******************************************************************** */
+/* WSM callbacks							*/
+
+void cw1200_channel_switch_cb(struct cw1200_common *priv)
+{
+	wsm_unlock_tx(priv);
+}
+
+void cw1200_free_event_queue(struct cw1200_common *priv)
+{
+	LIST_HEAD(list);
+
+	spin_lock(&priv->event_queue_lock);
+	list_splice_init(&priv->event_queue, &list);
+	spin_unlock(&priv->event_queue_lock);
+
+	__cw1200_free_event_queue(&list);
+}
+
+void cw1200_event_handler(struct work_struct *work)
+{
+	struct cw1200_common *priv =
+		container_of(work, struct cw1200_common, event_handler);
+	struct cw1200_wsm_event *event;
+	LIST_HEAD(list);
+
+	spin_lock(&priv->event_queue_lock);
+	list_splice_init(&priv->event_queue, &list);
+	spin_unlock(&priv->event_queue_lock);
+
+	list_for_each_entry(event, &list, link) {
+		switch (event->evt.eventId) {
+		case WSM_EVENT_ERROR:
+			pr_err("Unhandled WSM Error from LMAC\n");
+			break;
+		case WSM_EVENT_BSS_LOST:
+		{
+			spin_lock(&priv->bss_loss_lock);
+			if (priv->bss_loss_status > CW1200_BSS_LOSS_NONE) {
+				spin_unlock(&priv->bss_loss_lock);
+				break;
+			}
+			priv->bss_loss_status = CW1200_BSS_LOSS_CHECKING;
+			spin_unlock(&priv->bss_loss_lock);
+
+			pr_debug("[CQM] BSS lost.\n");
+			cancel_delayed_work_sync(&priv->bss_loss_work);
+			cancel_delayed_work_sync(&priv->connection_loss_work);
+			cancel_work_sync(&priv->unjoin_work);
+			if (!down_trylock(&priv->scan.lock)) {
+				up(&priv->scan.lock);
+				priv->delayed_link_loss = 0;
+				queue_delayed_work(priv->workqueue,
+						   &priv->bss_loss_work, 0);
+			} else {
+				/* Scan is in progress. Delay reporting. */
+				/* Scan complete will trigger bss_loss_work */
+				priv->delayed_link_loss = 1;
+				/* Also we're starting watchdog. */
+				queue_delayed_work(priv->workqueue,
+						&priv->bss_loss_work, 10 * HZ);
+			}
+			break;
+		}
+		case WSM_EVENT_BSS_REGAINED:
+		{
+			pr_debug("[CQM] BSS regained.\n");
+			priv->delayed_link_loss = 0;
+			spin_lock(&priv->bss_loss_lock);
+			priv->bss_loss_status = CW1200_BSS_LOSS_NONE;
+			priv->bss_loss_checking = 0;
+			spin_unlock(&priv->bss_loss_lock);
+			cancel_delayed_work_sync(&priv->bss_loss_work);
+			cancel_delayed_work_sync(&priv->connection_loss_work);
+			cancel_work_sync(&priv->unjoin_work);
+			break;
+		}
+		case WSM_EVENT_RADAR_DETECTED:
+			wiphy_info(priv->hw->wiphy, "radar pulse detected\n");
+			break;
+		case WSM_EVENT_RCPI_RSSI:
+		{
+			/* RSSI: signed Q8.0, RCPI: unsigned Q7.1
+			 * RSSI = RCPI / 2 - 110 */
+			int rcpiRssi = (int)(event->evt.eventData & 0xFF);
+			int cqm_evt;
+			if (priv->cqm_use_rssi)
+				rcpiRssi = (s8)rcpiRssi;
+			else
+				rcpiRssi =  rcpiRssi / 2 - 110;
+
+			cqm_evt = (rcpiRssi <= priv->cqm_rssi_thold) ?
+				NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW :
+				NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH;
+			pr_debug("[CQM] RSSI event: %d.\n", rcpiRssi);
+			ieee80211_cqm_rssi_notify(priv->vif, cqm_evt,
+								GFP_KERNEL);
+			break;
+		}
+		case WSM_EVENT_BT_INACTIVE:
+			pr_warn("Unhandled BT INACTIVE from LMAC\n");
+			break;
+		case WSM_EVENT_BT_ACTIVE:
+			pr_warn("Unhandled BT ACTIVE from LMAC\n");
+			break;
+		}
+	}
+	__cw1200_free_event_queue(&list);
+}
+
+void cw1200_bss_loss_work(struct work_struct *work)
+{
+	struct cw1200_common *priv =
+		container_of(work, struct cw1200_common, bss_loss_work.work);
+	int timeout; /* in beacons */
+	struct sk_buff *skb;
+
+	timeout = priv->cqm_beacon_loss_count * 3;
+
+	/* Skip the confimration procedure in P2P case */
+	if (priv->vif->p2p)
+		goto report;
+
+	spin_lock(&priv->bss_loss_lock);
+	if (priv->bss_loss_status == CW1200_BSS_LOSS_CHECKING) {
+		spin_unlock(&priv->bss_loss_lock);
+		skb = ieee80211_nullfunc_get(priv->hw, priv->vif);
+		if (!(WARN_ON(!skb))) {
+			cw1200_tx(priv->hw, NULL, skb);
+			/* Start watchdog -- if nullfunc TX doesn't fail
+			 * in 1 sec, forward event to upper layers */
+			queue_delayed_work(priv->workqueue,
+					&priv->bss_loss_work, 1 * HZ);
+		}
+		return;
+	} else if (priv->bss_loss_status == CW1200_BSS_LOSS_CONFIRMING) {
+		priv->bss_loss_status = CW1200_BSS_LOSS_NONE;
+		priv->bss_loss_checking = 0;
+		spin_unlock(&priv->bss_loss_lock);
+		return;
+	}
+	spin_unlock(&priv->bss_loss_lock);
+
+report:
+	if (priv->cqm_beacon_loss_count) {
+		pr_debug("[CQM] Beacon loss.\n");
+		if (timeout <= 0)
+			timeout = 0;
+	} else {
+		timeout = 0;
+	}
+
+	cancel_work_sync(&priv->unjoin_work);
+	cancel_delayed_work_sync(&priv->connection_loss_work);
+	queue_delayed_work(priv->workqueue,
+		&priv->connection_loss_work,
+		timeout * HZ / 10);
+
+	spin_lock(&priv->bss_loss_lock);
+	priv->bss_loss_status = CW1200_BSS_LOSS_NONE;
+	priv->bss_loss_checking = 0;
+	spin_unlock(&priv->bss_loss_lock);
+}
+
+void cw1200_connection_loss_work(struct work_struct *work)
+{
+	struct cw1200_common *priv =
+		container_of(work, struct cw1200_common,
+				connection_loss_work.work);
+
+	pr_debug("[CQM] Reporting connection loss.\n");
+	wsm_lock_tx(priv);
+	if (queue_work(priv->workqueue, &priv->unjoin_work) <= 0)
+		wsm_unlock_tx(priv);
+}
+
+/* ******************************************************************** */
+/* Internal API								*/
+
+/*
+ * This function is called to Parse the SDD file
+ * to extract listen_interval and PTA related information
+ * sdd is a TLV: u8 id, u8 len, u8 data[]
+ */
+static int cw1200_parse_SDD_file(struct cw1200_common *priv)
+{
+	const u8 *p = priv->sdd->data;
+	int ret = 0;
+
+	while (p + 2 <= priv->sdd->data + priv->sdd->size) {
+		if (p + p[1] + 2 > priv->sdd->data + priv->sdd->size) {
+			printk(KERN_WARNING "Malformed sdd structure\n");
+			return -1;
+		}
+		switch (p[0]) {
+		case SDD_PTA_CFG_ELT_ID: {
+			u16 v;
+			if (p[1] < 4) {
+				pr_warning("SDD_PTA_CFG_ELT_ID malformed\n");
+				ret = -1;
+				break;
+			}
+			v = le16_to_cpu(*((u16 *)(p + 2)));
+			if (!v)  /* non-zero means this is enabled */
+				break;
+
+			v = le16_to_cpu(*((u16 *)(p + 4)));
+			priv->conf_listen_interval = (v >> 7) & 0x1F;
+			pr_debug("PTA found; Listen Interval %d\n", priv->conf_listen_interval);
+			break;
+		}
+		case SDD_REFERENCE_FREQUENCY_ELT_ID: {
+			u16 clk = le16_to_cpu(*((u16 *)(p + 2)));
+			if (clk != priv->hw_refclk) {
+				pr_warn("SDD file doesn't match configured refclk (%d vs %d)\n",
+				       priv->hw_refclk, clk);
+			}
+			break;
+		}
+		default:
+			break;
+		}
+		p += p[1] + 2;
+
+	}
+
+	if (priv->is_BT_Present == false) {
+		pr_debug("PTA element NOT found.\n");
+		priv->conf_listen_interval = 0;
+	}
+	return ret;
+
+}
+
+int cw1200_setup_mac(struct cw1200_common *priv)
+{
+	int ret = 0;
+
+	/* NOTE: There is a bug in FW: it reports signal
+	* as RSSI if RSSI subscription is enabled.
+	* It's not enough to set WSM_RCPI_RSSI_USE_RSSI. */
+	/* NOTE2: RSSI based reports have been switched to RCPI, since
+	* FW has a bug and RSSI reported values are not stable,
+	* what can leads to signal level oscilations in user-end applications */
+	struct wsm_rcpi_rssi_threshold threshold = {
+		.rssiRcpiMode = WSM_RCPI_RSSI_THRESHOLD_ENABLE |
+		WSM_RCPI_RSSI_DONT_USE_UPPER |
+		WSM_RCPI_RSSI_DONT_USE_LOWER,
+		.rollingAverageCount = 16,
+	};
+
+	struct wsm_configuration cfg = {
+		.dot11StationId = &priv->mac_addr[0],
+	};
+
+	/* Remember the decission here to make sure, we will handle
+	 * the RCPI/RSSI value correctly on WSM_EVENT_RCPI_RSS */
+	if (threshold.rssiRcpiMode & WSM_RCPI_RSSI_USE_RSSI)
+		priv->cqm_use_rssi = true;
+
+	if (!priv->sdd) {
+		ret = request_firmware(&priv->sdd,
+			priv->sdd_path, priv->pdev);
+
+		if (ret) {
+			pr_err("%s: can't load sdd file %s.\n",
+			       __func__, priv->sdd_path);
+			return ret;
+		}
+		/* Parse SDD file for PTA element */
+		cw1200_parse_SDD_file(priv);
+	}
+
+	cfg.dpdData = priv->sdd->data;
+	cfg.dpdData_size = priv->sdd->size;
+	ret = WARN_ON(wsm_configuration(priv, &cfg));
+	if (ret)
+		return ret;
+
+	/* Configure RSSI/SCPI reporting as RSSI. */
+	WARN_ON(wsm_set_rcpi_rssi_threshold(priv, &threshold));
+
+	return 0;
+}
+
+void cw1200_offchannel_work(struct work_struct *work)
+{
+	struct cw1200_common *priv =
+		container_of(work, struct cw1200_common, offchannel_work);
+	u8 queueId = cw1200_queue_get_queue_id(priv->pending_frame_id);
+	struct cw1200_queue *queue = &priv->tx_queue[queueId];
+
+	mutex_lock(&priv->conf_mutex);
+	if (!priv->join_status) {
+		wsm_flush_tx(priv);
+		cw1200_update_listening(priv, true);
+		cw1200_update_filtering(priv);
+	}
+	if (!priv->join_status)
+		cw1200_queue_remove(queue, priv->pending_frame_id);
+	else
+		cw1200_queue_requeue(queue, priv->pending_frame_id);
+	mutex_unlock(&priv->conf_mutex);
+	wsm_unlock_tx(priv);
+}
+
+static void cw1200_join_complete(struct cw1200_common *priv)
+{
+	pr_debug("[STA] Join complete.\n");
+
+	mutex_lock(&priv->conf_mutex);
+	priv->join_pending = false;
+	if (priv->join_complete_status) {
+		priv->join_status = CW1200_JOIN_STATUS_PASSIVE;
+		memset(&priv->join_bssid[0], 0, sizeof(priv->join_bssid));
+		wsm_lock_tx(priv);
+		cw1200_update_listening(priv, priv->listening);
+		wsm_unlock_tx(priv);
+	} else {
+		priv->join_status = CW1200_JOIN_STATUS_PRE_STA;
+		/* Assoc timeout, not to leave device in full power. */
+		queue_delayed_work(priv->workqueue,
+			&priv->join_timeout, CW1200_AUTH_TIMEOUT);
+		/* Due to beacon filtering it is possible that the
+		* AP's beacon is not known for the mac80211 stack.
+		* Disable filtering temporary to make sure the stack
+		* receives at least one */
+		priv->disable_beacon_filter = true;
+		cw1200_update_filtering(priv);
+	}
+	mutex_unlock(&priv->conf_mutex);
+}
+
+void cw1200_join_complete_work(struct work_struct *work)
+{
+	struct cw1200_common *priv =
+		container_of(work, struct cw1200_common, join_complete_work);
+	cw1200_join_complete(priv);
+}
+
+void cw1200_join_complete_cb(struct cw1200_common *priv,
+				struct wsm_join_complete *arg)
+{
+	pr_debug("[STA] cw1200_join_complete_cb called, status=%d.\n", arg->status);
+
+	if (cancel_delayed_work(&priv->join_timeout)) {
+		priv->join_complete_status = arg->status;
+		queue_work(priv->workqueue, &priv->join_complete_work);
+	}
+}
+
+void cw1200_join_work(struct work_struct *work)
+{
+	struct cw1200_common *priv =
+		container_of(work, struct cw1200_common, join_work);
+	u8 queueId = cw1200_queue_get_queue_id(priv->pending_frame_id);
+	struct cw1200_queue *queue = &priv->tx_queue[queueId];
+	const struct cw1200_txpriv *txpriv = NULL;
+	struct sk_buff *skb = NULL;
+	const struct wsm_tx *wsm;
+	const struct ieee80211_hdr *frame;
+	const u8 *bssid;
+	struct cfg80211_bss *bss;
+	const u8 *ssidie;
+	struct wsm_protected_mgmt_policy mgmt_policy;
+
+	if (delayed_work_pending(&priv->join_timeout)) {
+		pr_warn("[STA] Skipping join request - previous request yet to be completed\n");
+		wsm_unlock_tx(priv);
+		return;
+	}
+
+	if (cw1200_queue_get_skb(queue,	priv->pending_frame_id,
+			&skb, &txpriv)) {
+		wsm_unlock_tx(priv);
+		priv->join_pending = false;
+		return;
+	}
+	wsm = (struct wsm_tx *)skb->data;
+	frame = (struct ieee80211_hdr *)&skb->data[txpriv->offset];
+	bssid = frame->addr3; /* BSSID is A3 in TODS/FROMDS/NODS */
+
+	if (priv->join_status) {
+		wsm_lock_tx(priv);
+		cw1200_unjoin_work(&priv->unjoin_work);
+	}
+
+	bss = cfg80211_get_bss(priv->hw->wiphy, priv->channel,
+			bssid, NULL, 0, 0, 0);
+	if (!bss) {
+		cw1200_queue_remove(queue, priv->pending_frame_id);
+		wsm_unlock_tx(priv);
+		priv->join_pending = false;
+		return;
+	}
+
+	mutex_lock(&priv->conf_mutex);
+	{
+		struct wsm_join join = {
+			.mode = (bss->capability & WLAN_CAPABILITY_IBSS) ?
+				WSM_JOIN_MODE_IBSS : WSM_JOIN_MODE_BSS,
+			.preambleType = WSM_JOIN_PREAMBLE_SHORT,
+			.probeForJoin = 1,
+			.atimWindow = 1,
+			.beaconInterval = bss->beacon_interval,
+			/* basicRateSet will be updated after association */
+			.basicRateSet = 7,
+		};
+
+		/* Under the conf lock: check scan status and
+		 * bail out if it is in progress. */
+		if (atomic_read(&priv->scan.in_progress)) {
+			cw1200_queue_remove(queue, priv->pending_frame_id);
+			mutex_unlock(&priv->conf_mutex);
+			wsm_unlock_tx(priv);
+			return;
+		}
+
+		/* BT Coex related changes */
+		if (priv->is_BT_Present) {
+			if (((priv->conf_listen_interval * 100) %
+					bss->beacon_interval) == 0)
+				priv->listen_interval =
+					((priv->conf_listen_interval * 100) /
+					bss->beacon_interval);
+			else
+				priv->listen_interval =
+					((priv->conf_listen_interval * 100) /
+					bss->beacon_interval + 1);
+		}
+
+		if (priv->hw->conf.ps_dtim_period)
+			priv->join_dtim_period = priv->hw->conf.ps_dtim_period;
+		join.dtimPeriod = priv->join_dtim_period;
+
+		priv->beacon_int = bss->beacon_interval;
+		join.channelNumber = priv->channel->hw_value;
+		join.band = (priv->channel->band == IEEE80211_BAND_5GHZ) ?
+			WSM_PHY_BAND_5G : WSM_PHY_BAND_2_4G;
+
+		pr_debug("[STA] Join DTIM: %d, interval: %d\n",
+				join.dtimPeriod, priv->beacon_int);
+
+		memcpy(&join.bssid[0], bssid, sizeof(join.bssid));
+		memcpy(&priv->join_bssid[0], bssid, sizeof(priv->join_bssid));
+
+		rcu_read_lock();
+		ssidie = ieee80211_bss_get_ie(bss, WLAN_EID_SSID);
+		if (ssidie) {
+			join.ssidLength = ssidie[1];
+			if (WARN_ON(join.ssidLength > sizeof(join.ssid)))
+				join.ssidLength = sizeof(join.ssid);
+			memcpy(&join.ssid[0], &ssidie[2], join.ssidLength);
+		}
+		rcu_read_unlock();
+
+		if (priv->vif->p2p) {
+			join.flags |= WSM_JOIN_FLAGS_P2P_GO;
+			join.basicRateSet =
+				cw1200_rate_mask_to_wsm(priv, 0xFF0);
+		}
+
+		/* Enable asynchronous join calls */
+		join.flags |= WSM_JOIN_FLAGS_FORCE;
+		join.flags |= WSM_JOIN_FLAGS_FORCE_WITH_COMPLETE_IND;
+
+		wsm_flush_tx(priv);
+
+		queue_delayed_work(priv->workqueue,
+			&priv->join_timeout, CW1200_JOIN_TIMEOUT);
+
+		/* Stay Awake for Join and Auth Timeouts and a bit more */
+		cw1200_pm_stay_awake(&priv->pm_state, CW1200_JOIN_TIMEOUT + CW1200_AUTH_TIMEOUT);
+
+		cw1200_update_listening(priv, false);
+
+		/* Turn on Block ACKs */
+		WARN_ON(wsm_set_block_ack_policy(priv,
+			priv->ba_tx_tid_mask, priv->ba_rx_tid_mask));
+
+		mgmt_policy.protectedMgmtEnable = 0;
+		mgmt_policy.unprotectedMgmtFramesAllowed = 1;
+		mgmt_policy.encryptionForAuthFrame = 1;
+		wsm_set_protected_mgmt_policy(priv, &mgmt_policy);
+
+		if (wsm_join(priv, &join)) {
+			pr_err("[STA] cw1200_join_work: wsm_join request failed!\n");
+			memset(&priv->join_bssid[0],
+				0, sizeof(priv->join_bssid));
+			cw1200_queue_remove(queue, priv->pending_frame_id);
+			cancel_delayed_work_sync(&priv->join_timeout);
+			cw1200_update_listening(priv, priv->listening);
+		} else {
+			pr_debug("[STA] cw1200_join_work: wsm_join request send succesfully\n");
+			priv->join_status = CW1200_JOIN_STATUS_JOINING;
+			/* Upload keys */
+			WARN_ON(cw1200_upload_keys(priv));
+			cw1200_queue_requeue(queue, priv->pending_frame_id);
+
+			/* Due to beacon filtering it is possible that the
+			 * AP's beacon is not known for the mac80211 stack.
+			 * Disable filtering temporary to make sure the stack
+			 * receives at least one */
+			priv->disable_beacon_filter = true;
+
+		}
+		cw1200_update_filtering(priv);
+	}
+	mutex_unlock(&priv->conf_mutex);
+	cfg80211_put_bss(bss);
+	wsm_unlock_tx(priv);
+}
+
+void cw1200_join_timeout(struct work_struct *work)
+{
+	struct cw1200_common *priv =
+		container_of(work, struct cw1200_common, join_timeout.work);
+	pr_debug("[WSM] Issue unjoin command (TMO).\n");
+	wsm_lock_tx(priv);
+	cw1200_unjoin_work(&priv->unjoin_work);
+}
+
+void cw1200_unjoin_work(struct work_struct *work)
+{
+	struct cw1200_common *priv =
+		container_of(work, struct cw1200_common, unjoin_work);
+
+	struct wsm_reset reset = {
+		.reset_statistics = true,
+	};
+
+	cancel_delayed_work(&priv->join_timeout);
+
+	mutex_lock(&priv->conf_mutex);
+	priv->join_pending = false;
+
+	if (atomic_read(&priv->scan.in_progress)) {
+		if (priv->delayed_unjoin) {
+			wiphy_dbg(priv->hw->wiphy, "Delayed unjoin is already scheduled.\n");
+			wsm_unlock_tx(priv);
+		} else {
+			priv->delayed_unjoin = true;
+		}
+		mutex_unlock(&priv->conf_mutex);
+		return;
+	}
+
+	if (priv->join_status) {
+		if (priv->join_status > CW1200_JOIN_STATUS_STA) {
+			wiphy_err(priv->hw->wiphy, "Unexpected: join status: %d\n",
+				  priv->join_status);
+			BUG_ON(1);
+		}
+
+		cancel_work_sync(&priv->update_filtering_work);
+		cancel_work_sync(&priv->set_beacon_wakeup_period_work);
+		memset(&priv->join_bssid[0], 0, sizeof(priv->join_bssid));
+		priv->join_status = CW1200_JOIN_STATUS_PASSIVE;
+
+		/* Unjoin is a reset. */
+		wsm_flush_tx(priv);
+		WARN_ON(wsm_keep_alive_period(priv, 0));
+		WARN_ON(wsm_reset(priv, &reset));
+		WARN_ON(wsm_set_output_power(priv, priv->output_power * 10));
+		priv->join_dtim_period = 0;
+		WARN_ON(cw1200_setup_mac(priv));
+		cw1200_free_event_queue(priv);
+		cancel_work_sync(&priv->event_handler);
+		cancel_delayed_work_sync(&priv->connection_loss_work);
+		cw1200_update_listening(priv, priv->listening);
+
+		/* Disable Block ACKs */
+		WARN_ON(wsm_set_block_ack_policy(priv, 0, 0));
+ 
+		priv->disable_beacon_filter = false;
+		cw1200_update_filtering(priv);
+		priv->setbssparams_done = false;
+		memset(&priv->association_mode, 0,
+			sizeof(priv->association_mode));
+		memset(&priv->bss_params, 0, sizeof(priv->bss_params));
+		memset(&priv->firmware_ps_mode, 0,
+			sizeof(priv->firmware_ps_mode));
+		pr_debug("[STA] Unjoin.\n");
+
+		/* Tell the stack we're dead */
+		ieee80211_connection_loss(priv->vif);
+	}
+	mutex_unlock(&priv->conf_mutex);
+	wsm_unlock_tx(priv);
+}
+
+int cw1200_enable_listening(struct cw1200_common *priv)
+{
+	struct wsm_start start = {
+		.mode = WSM_START_MODE_P2P_DEV,
+		.band = WSM_PHY_BAND_2_4G,
+		.channelNumber = 1,
+		.beaconInterval = 100,
+		.DTIMPeriod = 1,
+		.probeDelay = 0,
+		.basicRateSet = 0x0F,
+	};
+
+	if (priv->channel) {
+		start.band = priv->channel->band == IEEE80211_BAND_5GHZ ?
+			     WSM_PHY_BAND_5G : WSM_PHY_BAND_2_4G;
+		start.channelNumber = priv->channel->hw_value;
+	}
+
+	return wsm_start(priv, &start);
+}
+
+int cw1200_disable_listening(struct cw1200_common *priv)
+{
+	int ret;
+	struct wsm_reset reset = {
+		.reset_statistics = true,
+	};
+	ret = wsm_reset(priv, &reset);
+	return ret;
+}
+
+void cw1200_update_listening(struct cw1200_common *priv, bool enabled)
+{
+	if (enabled) {
+		switch (priv->join_status) {
+		case CW1200_JOIN_STATUS_PASSIVE:
+			if (!WARN_ON(cw1200_enable_listening(priv)))
+				priv->join_status = CW1200_JOIN_STATUS_MONITOR;
+			WARN_ON(wsm_set_probe_responder(priv, true));
+			break;
+		default:
+			break;
+		}
+	} else {
+		switch (priv->join_status) {
+		case CW1200_JOIN_STATUS_MONITOR:
+			if (!WARN_ON(cw1200_disable_listening(priv)))
+				priv->join_status = CW1200_JOIN_STATUS_PASSIVE;
+			WARN_ON(wsm_set_probe_responder(priv, false));
+		default:
+			break;
+		}
+	}
+}
+
+int cw1200_set_uapsd_param(struct cw1200_common *priv,
+				const struct wsm_edca_params *arg)
+{
+	int ret;
+	u16 uapsdFlags = 0;
+
+	/* Here's the mapping AC [queue, bit]
+	VO [0,3], VI [1, 2], BE [2, 1], BK [3, 0]*/
+
+	if (arg->params[0].uapsdEnable)
+		uapsdFlags |= 1 << 3;
+
+	if (arg->params[1].uapsdEnable)
+		uapsdFlags |= 1 << 2;
+
+	if (arg->params[2].uapsdEnable)
+		uapsdFlags |= 1 << 1;
+
+	if (arg->params[3].uapsdEnable)
+		uapsdFlags |= 1;
+
+	/* Currently pseudo U-APSD operation is not supported, so setting
+	* MinAutoTriggerInterval, MaxAutoTriggerInterval and
+	* AutoTriggerStep to 0 */
+
+	priv->uapsd_info.uapsdFlags = cpu_to_le16(uapsdFlags);
+	priv->uapsd_info.minAutoTriggerInterval = 0;
+	priv->uapsd_info.maxAutoTriggerInterval = 0;
+	priv->uapsd_info.autoTriggerStep = 0;
+
+	ret = wsm_set_uapsd_info(priv, &priv->uapsd_info);
+	return ret;
+}
+
+/* ******************************************************************** */
+/* AP API								*/
+
+int cw1200_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		   struct ieee80211_sta *sta)
+{
+	struct cw1200_common *priv = hw->priv;
+	struct cw1200_sta_priv *sta_priv =
+			(struct cw1200_sta_priv *)&sta->drv_priv;
+	struct cw1200_link_entry *entry;
+	struct sk_buff *skb;
+
+	if (priv->mode != NL80211_IFTYPE_AP)
+		return 0;
+
+	sta_priv->link_id = cw1200_find_link_id(priv, sta->addr);
+	if (WARN_ON(!sta_priv->link_id)) {
+		/* Impossible error */
+		wiphy_info(priv->hw->wiphy,
+			"[AP] No more link IDs available.\n");
+		return -ENOENT;
+	}
+
+	entry = &priv->link_id_db[sta_priv->link_id - 1];
+	spin_lock_bh(&priv->ps_state_lock);
+	if ((sta->uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_MASK) ==
+					IEEE80211_WMM_IE_STA_QOSINFO_AC_MASK)
+		priv->sta_asleep_mask |= BIT(sta_priv->link_id);
+	entry->status = CW1200_LINK_HARD;
+	while ((skb = skb_dequeue(&entry->rx_queue)))
+		ieee80211_rx_irqsafe(priv->hw, skb);
+	spin_unlock_bh(&priv->ps_state_lock);
+	return 0;
+}
+
+int cw1200_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		      struct ieee80211_sta *sta)
+{
+	struct cw1200_common *priv = hw->priv;
+	struct cw1200_sta_priv *sta_priv =
+			(struct cw1200_sta_priv *)&sta->drv_priv;
+	struct cw1200_link_entry *entry;
+
+	if (priv->mode != NL80211_IFTYPE_AP || !sta_priv->link_id)
+		return 0;
+
+	entry = &priv->link_id_db[sta_priv->link_id - 1];
+	spin_lock_bh(&priv->ps_state_lock);
+	entry->status = CW1200_LINK_RESERVE;
+	entry->timestamp = jiffies;
+	wsm_lock_tx_async(priv);
+	if (queue_work(priv->workqueue, &priv->link_id_work) <= 0)
+		wsm_unlock_tx(priv);
+	spin_unlock_bh(&priv->ps_state_lock);
+	flush_workqueue(priv->workqueue);
+	return 0;
+}
+
+static void __cw1200_sta_notify(struct ieee80211_hw *dev,
+				struct ieee80211_vif *vif,
+				enum sta_notify_cmd notify_cmd,
+				int link_id)
+{
+	struct cw1200_common *priv = dev->priv;
+	u32 bit, prev;
+
+	/* Zero link id means "for all link IDs" */
+	if (link_id)
+		bit = BIT(link_id);
+	else if (WARN_ON_ONCE(notify_cmd != STA_NOTIFY_AWAKE))
+		bit = 0;
+	else
+		bit = priv->link_id_map;
+	prev = priv->sta_asleep_mask & bit;
+
+	switch (notify_cmd) {
+	case STA_NOTIFY_SLEEP:
+		if (!prev) {
+			if (priv->buffered_multicasts &&
+					!priv->sta_asleep_mask)
+				queue_work(priv->workqueue,
+					&priv->multicast_start_work);
+			priv->sta_asleep_mask |= bit;
+		}
+		break;
+	case STA_NOTIFY_AWAKE:
+		if (prev) {
+			priv->sta_asleep_mask &= ~bit;
+			priv->pspoll_mask &= ~bit;
+			if (priv->tx_multicast && link_id &&
+					!priv->sta_asleep_mask)
+				queue_work(priv->workqueue,
+					&priv->multicast_stop_work);
+			cw1200_bh_wakeup(priv);
+		}
+		break;
+	}
+}
+
+void cw1200_sta_notify(struct ieee80211_hw *dev,
+		       struct ieee80211_vif *vif,
+		       enum sta_notify_cmd notify_cmd,
+		       struct ieee80211_sta *sta)
+{
+	struct cw1200_common *priv = dev->priv;
+	struct cw1200_sta_priv *sta_priv =
+		(struct cw1200_sta_priv *)&sta->drv_priv;
+
+	spin_lock_bh(&priv->ps_state_lock);
+	__cw1200_sta_notify(dev, vif, notify_cmd, sta_priv->link_id);
+	spin_unlock_bh(&priv->ps_state_lock);
+}
+
+static void cw1200_ps_notify(struct cw1200_common *priv,
+		      int link_id, bool ps)
+{
+	if (link_id > CW1200_MAX_STA_IN_AP_MODE)
+		return;
+
+	pr_debug("%s for LinkId: %d. STAs asleep: %.8X\n",
+		 ps ? "Stop" : "Start",
+		 link_id, priv->sta_asleep_mask);
+
+	__cw1200_sta_notify(priv->hw, priv->vif,
+		ps ? STA_NOTIFY_SLEEP : STA_NOTIFY_AWAKE, link_id);
+}
+
+static int cw1200_set_tim_impl(struct cw1200_common *priv, bool aid0_bit_set)
+{
+	struct sk_buff *skb;
+	struct wsm_update_ie update_ie = {
+		.what = WSM_UPDATE_IE_BEACON,
+		.count = 1,
+	};
+	u16 tim_offset, tim_length;
+
+	pr_debug("[AP] %s mcast: %s.\n",
+		__func__, aid0_bit_set ? "ena" : "dis");
+
+	skb = ieee80211_beacon_get_tim(priv->hw, priv->vif,
+			&tim_offset, &tim_length);
+	if (!skb) {
+		if (!__cw1200_flush(priv, true))
+			wsm_unlock_tx(priv);
+		return -ENOENT;
+	}
+
+	if (tim_offset && tim_length >= 6) {
+		/* Ignore DTIM count from mac80211:
+		 * firmware handles DTIM internally. */
+		skb->data[tim_offset + 2] = 0;
+
+		/* Set/reset aid0 bit */
+		if (aid0_bit_set)
+			skb->data[tim_offset + 4] |= 1;
+		else
+			skb->data[tim_offset + 4] &= ~1;
+	}
+
+	update_ie.ies = &skb->data[tim_offset];
+	update_ie.length = tim_length;
+	WARN_ON(wsm_update_ie(priv, &update_ie));
+
+	dev_kfree_skb(skb);
+
+	return 0;
+}
+
+void cw1200_set_tim_work(struct work_struct *work)
+{
+	struct cw1200_common *priv =
+		container_of(work, struct cw1200_common, set_tim_work);
+	(void)cw1200_set_tim_impl(priv, priv->aid0_bit_set);
+}
+
+int cw1200_set_tim(struct ieee80211_hw *dev, struct ieee80211_sta *sta,
+		   bool set)
+{
+	struct cw1200_common *priv = dev->priv;
+	queue_work(priv->workqueue, &priv->set_tim_work);
+	return 0;
+}
+
+void cw1200_set_cts_work(struct work_struct *work)
+{
+	struct cw1200_common *priv =
+		container_of(work, struct cw1200_common, set_cts_work);
+
+	u8 erp_ie[3] = {WLAN_EID_ERP_INFO, 0x1, 0};
+	struct wsm_update_ie update_ie = {
+		.what = WSM_UPDATE_IE_BEACON,
+		.count = 1,
+		.ies = erp_ie,
+		.length = 3,
+	};
+	u32 erp_info;
+	__le32 use_cts_prot;
+	mutex_lock(&priv->conf_mutex);
+	erp_info = priv->erp_info;
+	mutex_unlock(&priv->conf_mutex);
+	use_cts_prot =
+		erp_info & WLAN_ERP_USE_PROTECTION ?
+		__cpu_to_le32(1) : 0;
+
+	erp_ie[ERP_INFO_BYTE_OFFSET] = erp_info;
+
+	pr_debug("[STA] ERP information 0x%x\n", erp_info);
+
+	WARN_ON(wsm_write_mib(priv, WSM_MIB_ID_NON_ERP_PROTECTION,
+				&use_cts_prot, sizeof(use_cts_prot)));
+	WARN_ON(wsm_update_ie(priv, &update_ie));
+
+	return;
+}
+
+static int cw1200_set_btcoexinfo(struct cw1200_common *priv)
+{
+	struct wsm_override_internal_txrate arg;
+	int ret = 0;
+
+	if (priv->mode == NL80211_IFTYPE_STATION) {
+		/* Plumb PSPOLL and NULL template */
+		WARN_ON(cw1200_upload_pspoll(priv));
+		WARN_ON(cw1200_upload_null(priv));
+		WARN_ON(cw1200_upload_qosnull(priv));
+	} else {
+		return 0;
+	}
+
+	memset(&arg, 0, sizeof(struct wsm_override_internal_txrate));
+
+	if (!priv->vif->p2p) {
+		/* STATION mode */
+		if (priv->bss_params.operationalRateSet & ~0xF) {
+			pr_debug("[STA] STA has ERP rates\n");
+			/* G or BG mode */
+			arg.internalTxRate = (__ffs(
+			priv->bss_params.operationalRateSet & ~0xF));
+		} else {
+			pr_debug("[STA] STA has non ERP rates\n");
+			/* B only mode */
+			arg.internalTxRate = (__ffs(
+			priv->association_mode.basicRateSet));
+		}
+		arg.nonErpInternalTxRate = (__ffs(
+			priv->association_mode.basicRateSet));
+	} else {
+		/* P2P mode */
+		arg.internalTxRate = (__ffs(
+			priv->bss_params.operationalRateSet & ~0xF));
+		arg.nonErpInternalTxRate = (__ffs(
+			priv->bss_params.operationalRateSet & ~0xF));
+	}
+
+	pr_debug("[STA] BTCOEX_INFO MODE %d, internalTxRate : %x, nonErpInternalTxRate: %x\n",
+		priv->mode,
+		arg.internalTxRate,
+		arg.nonErpInternalTxRate);
+
+	ret = WARN_ON(wsm_write_mib(priv, WSM_MIB_ID_OVERRIDE_INTERNAL_TX_RATE,
+		&arg, sizeof(arg)));
+
+	return ret;
+}
+
+void cw1200_bss_info_changed(struct ieee80211_hw *dev,
+			     struct ieee80211_vif *vif,
+			     struct ieee80211_bss_conf *info,
+			     u32 changed)
+{
+	struct cw1200_common *priv = dev->priv;
+
+	mutex_lock(&priv->conf_mutex);
+
+	if (changed & BSS_CHANGED_ARP_FILTER) {
+		struct wsm_arp_ipv4_filter filter = {0};
+		int i;
+
+		pr_debug("[STA] BSS_CHANGED_ARP_FILTER enabled: %d, cnt: %d\n",
+				     info->arp_filter_enabled,
+				     info->arp_addr_cnt);
+
+		if (info->arp_filter_enabled)
+			filter.enable = __cpu_to_le32(1);
+
+		/* Currently only one IP address is supported by firmware.
+		 * In case of more IPs arp filtering will be disabled. */
+		if (info->arp_addr_cnt > 0 &&
+		    info->arp_addr_cnt <= WSM_MAX_ARP_IP_ADDRTABLE_ENTRIES) {
+			for (i = 0; i < info->arp_addr_cnt; i++) {
+				filter.ipv4Address[i] = info->arp_addr_list[i];
+				pr_debug("[STA] addr[%d]: 0x%X\n",
+					  i, filter.ipv4Address[i]);
+			}
+		} else
+			filter.enable = 0;
+
+		pr_debug("[STA] arp ip filter enable: %d\n",
+			  __le32_to_cpu(filter.enable));
+
+		if (wsm_set_arp_ipv4_filter(priv, &filter))
+			WARN_ON(1);
+	}
+
+
+	if (changed &
+	    (BSS_CHANGED_BEACON |
+	     BSS_CHANGED_IBSS)) {
+		pr_debug("BSS_CHANGED_BEACON\n");
+		WARN_ON(cw1200_update_beaconing(priv));
+		WARN_ON(cw1200_upload_beacon(priv));
+	}
+
+	if (changed & BSS_CHANGED_BEACON_ENABLED) {
+		pr_debug("BSS_CHANGED_BEACON_ENABLED\n");
+
+		if (priv->enable_beacon != info->enable_beacon) {
+			WARN_ON(cw1200_enable_beaconing(priv,
+							info->enable_beacon));
+			priv->enable_beacon = info->enable_beacon;
+		}
+	}
+
+	if (changed & BSS_CHANGED_BEACON_INT) {
+		pr_debug("CHANGED_BEACON_INT\n");
+		/* Restart AP only when connected */
+		if (priv->join_status == CW1200_JOIN_STATUS_AP || info->ibss_joined)
+			WARN_ON(cw1200_update_beaconing(priv));
+	}
+
+	/* assoc/disassoc, or maybe AID changed */
+	if (changed & BSS_CHANGED_ASSOC) {
+		wsm_lock_tx(priv);
+		priv->wep_default_key_id = -1;
+		wsm_unlock_tx(priv);
+
+		if (info->assoc && !info->ibss_joined)
+			priv->cqm_beacon_loss_count = 20;
+	}
+
+	if (changed &
+	    (BSS_CHANGED_ASSOC |
+	     BSS_CHANGED_BSSID |
+	     BSS_CHANGED_IBSS |
+	     BSS_CHANGED_BASIC_RATES |
+	     BSS_CHANGED_ERP_PREAMBLE |
+	     BSS_CHANGED_HT |
+	     BSS_CHANGED_ERP_SLOT)) {
+		pr_debug("BSS_CHANGED_ASSOC.\n");
+		if (info->assoc) {
+			int i, join_tmo = 10 * CW1200_JOIN_TIMEOUT / HZ + 1;
+			/* "Associated but not joined" sounds like a nonsense,
+			 * but might happen. It is a quite seldom corner case,
+			 * so it is implemented as simple as possible,
+			 * efficiency has no priority here :) */
+			for (i = 0; i < join_tmo && priv->join_status ==
+					CW1200_JOIN_STATUS_JOINING; ++i) {
+				mutex_unlock(&priv->conf_mutex);
+				/* 100 ms busy wait is not so bad approach
+				 * as it looks like: firmware joins
+				 * on beacons. And this is a slowpath. */
+				msleep(100);
+				mutex_lock(&priv->conf_mutex);
+			}
+
+			if (priv->join_status < CW1200_JOIN_STATUS_PRE_STA) {
+				ieee80211_connection_loss(vif);
+				mutex_unlock(&priv->conf_mutex);
+				return;
+			} else if (priv->join_status == CW1200_JOIN_STATUS_PRE_STA) {
+				/* Check for a quite unlikely race: if timeout
+				 * work has been already scheduled, but not yet
+				 * executed.*/
+				if (!cancel_delayed_work_sync(&priv->join_timeout)) {
+					ieee80211_connection_loss(vif);
+					mutex_unlock(&priv->conf_mutex);
+					return;
+				}
+				priv->join_status = CW1200_JOIN_STATUS_STA;
+			}
+		}
+		if (info->assoc || info->ibss_joined) {
+			struct ieee80211_sta *sta = NULL;
+			if (info->dtim_period)
+				priv->join_dtim_period = info->dtim_period;
+			priv->beacon_int = info->beacon_int;
+
+			rcu_read_lock();
+
+			if (info->bssid && !info->ibss_joined)
+				sta = ieee80211_find_sta(vif, info->bssid);
+			if (sta) {
+				priv->ht_info.ht_cap = sta->ht_cap;
+				priv->bss_params.operationalRateSet =
+					__cpu_to_le32(
+					cw1200_rate_mask_to_wsm(priv,
+					sta->supp_rates[priv->channel->band]));
+				priv->ht_info.channel_type = dev->conf.channel_type;
+				priv->ht_info.operation_mode = info->ht_operation_mode;
+			} else {
+				memset(&priv->ht_info, 0,
+						sizeof(priv->ht_info));
+				priv->bss_params.operationalRateSet = -1;
+			}
+			rcu_read_unlock();
+
+			if (sta) {
+				__le32 val = 0;
+				if (priv->ht_info.operation_mode &
+				IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT) {
+					pr_debug("[STA] Non-GF STA present\n");
+					/* Non Green field capable STA */
+					val = __cpu_to_le32(WSM_NON_GREENFIELD_STA_PRESENT);
+				}
+				WARN_ON(wsm_write_mib(priv,
+					WSM_MID_ID_SET_HT_PROTECTION,
+					&val, sizeof(val)));
+			}
+
+			priv->association_mode.greenfieldMode =
+				cw1200_ht_greenfield(&priv->ht_info);
+			priv->association_mode.flags =
+				WSM_ASSOCIATION_MODE_SNOOP_ASSOC_FRAMES |
+				WSM_ASSOCIATION_MODE_USE_PREAMBLE_TYPE |
+				WSM_ASSOCIATION_MODE_USE_HT_MODE |
+				WSM_ASSOCIATION_MODE_USE_BASIC_RATE_SET |
+				WSM_ASSOCIATION_MODE_USE_MPDU_START_SPACING;
+			priv->association_mode.preambleType =
+				info->use_short_preamble ?
+				WSM_JOIN_PREAMBLE_SHORT :
+				WSM_JOIN_PREAMBLE_LONG;
+			priv->association_mode.basicRateSet = __cpu_to_le32(
+				cw1200_rate_mask_to_wsm(priv,
+				info->basic_rates));
+			priv->association_mode.mpduStartSpacing =
+				cw1200_ht_ampdu_density(&priv->ht_info);
+
+			priv->delayed_link_loss = 0;
+			spin_lock(&priv->bss_loss_lock);
+			priv->bss_loss_status = CW1200_BSS_LOSS_NONE;
+			spin_unlock(&priv->bss_loss_lock);
+
+			priv->delayed_link_loss = 0;
+			spin_lock(&priv->bss_loss_lock);
+			priv->bss_loss_status = CW1200_BSS_LOSS_NONE;
+			priv->bss_loss_checking = 0;
+			spin_unlock(&priv->bss_loss_lock);
+			cancel_delayed_work_sync(&priv->bss_loss_work);
+			cancel_delayed_work_sync(&priv->connection_loss_work);
+			cancel_work_sync(&priv->unjoin_work);
+
+			priv->bss_params.beaconLostCount = priv->cqm_beacon_loss_count;
+
+			priv->bss_params.aid = info->aid;
+
+			if (priv->join_dtim_period < 1)
+				priv->join_dtim_period = 1;
+
+			pr_debug("[STA] DTIM %d, interval: %d\n",
+				priv->join_dtim_period, priv->beacon_int);
+			pr_debug("[STA] Preamble: %d, " \
+				"Greenfield: %d, Aid: %d, " \
+				"Rates: 0x%.8X, Basic: 0x%.8X\n",
+				priv->association_mode.preambleType,
+				priv->association_mode.greenfieldMode,
+				priv->bss_params.aid,
+				priv->bss_params.operationalRateSet,
+				priv->association_mode.basicRateSet);
+			WARN_ON(wsm_set_association_mode(priv,
+				&priv->association_mode));
+			WARN_ON(wsm_keep_alive_period(priv, 30 /* sec */));
+			WARN_ON(wsm_set_bss_params(priv, &priv->bss_params));
+			priv->setbssparams_done = true;
+			WARN_ON(wsm_set_beacon_wakeup_period(priv,
+				    priv->beacon_int * priv->join_dtim_period >
+				    MAX_BEACON_SKIP_TIME_MS ? 1 :
+				    priv->join_dtim_period, 0));
+
+			cw1200_set_pm(priv, &priv->powersave_mode);
+			if (priv->vif->p2p) {
+				pr_debug("[STA] Setting p2p powersave configuration.\n");
+				WARN_ON(wsm_set_p2p_ps_modeinfo(priv,
+					&priv->p2p_ps_modeinfo));
+			}
+
+			if (priv->is_BT_Present)
+				WARN_ON(cw1200_set_btcoexinfo(priv));
+		} else {
+			memset(&priv->association_mode, 0,
+				sizeof(priv->association_mode));
+			memset(&priv->bss_params, 0, sizeof(priv->bss_params));
+		}
+	}
+
+	if (changed & (BSS_CHANGED_ASSOC | BSS_CHANGED_ERP_CTS_PROT)) {
+		u32 prev_erp_info = priv->erp_info;
+
+		if (info->use_cts_prot)
+			priv->erp_info |= WLAN_ERP_USE_PROTECTION;
+		else if (!(prev_erp_info & WLAN_ERP_NON_ERP_PRESENT))
+			priv->erp_info &= ~WLAN_ERP_USE_PROTECTION;
+
+		if (prev_erp_info != priv->erp_info)
+			queue_work(priv->workqueue, &priv->set_cts_work);
+	}
+
+	if (changed & (BSS_CHANGED_ASSOC | BSS_CHANGED_ERP_SLOT)) {
+		__le32 slot_time = info->use_short_slot ?
+			__cpu_to_le32(9) : __cpu_to_le32(20);
+		pr_debug("[STA] Slot time :%d us.\n",
+			__le32_to_cpu(slot_time));
+		WARN_ON(wsm_write_mib(priv, WSM_MIB_ID_DOT11_SLOT_TIME,
+			&slot_time, sizeof(slot_time)));
+	}
+	if (changed & (BSS_CHANGED_ASSOC | BSS_CHANGED_CQM)) {
+		struct wsm_rcpi_rssi_threshold threshold = {
+			.rollingAverageCount = 8,
+		};
+
+		pr_debug("[CQM] RSSI threshold subscribe: %d +- %d\n",
+			info->cqm_rssi_thold, info->cqm_rssi_hyst);
+		priv->cqm_rssi_thold = info->cqm_rssi_thold;
+		priv->cqm_rssi_hyst = info->cqm_rssi_hyst;
+
+		if (info->cqm_rssi_thold || info->cqm_rssi_hyst) {
+			/* RSSI subscription enabled */
+			/* TODO: It's not a correct way of setting threshold.
+			 * Upper and lower must be set equal here and adjusted
+			 * in callback. However current implementation is much
+			 * more relaible and stable. */
+
+			/* RSSI: signed Q8.0, RCPI: unsigned Q7.1
+			 * RSSI = RCPI / 2 - 110 */
+			if (priv->cqm_use_rssi) {
+				threshold.upperThreshold =
+					info->cqm_rssi_thold + info->cqm_rssi_hyst;
+				threshold.lowerThreshold =
+					info->cqm_rssi_thold;
+				threshold.rssiRcpiMode |= WSM_RCPI_RSSI_USE_RSSI;
+			} else {
+				threshold.upperThreshold = (info->cqm_rssi_thold + info->cqm_rssi_hyst + 110) * 2;
+				threshold.lowerThreshold = (info->cqm_rssi_thold + 110) * 2;
+			}
+			threshold.rssiRcpiMode |= WSM_RCPI_RSSI_THRESHOLD_ENABLE;
+		} else {
+			/* There is a bug in FW, see sta.c. We have to enable
+			 * dummy subscription to get correct RSSI values. */
+			threshold.rssiRcpiMode |=
+				WSM_RCPI_RSSI_THRESHOLD_ENABLE |
+				WSM_RCPI_RSSI_DONT_USE_UPPER |
+				WSM_RCPI_RSSI_DONT_USE_LOWER;
+			if (priv->cqm_use_rssi)
+				threshold.rssiRcpiMode |= WSM_RCPI_RSSI_USE_RSSI;
+		}
+		WARN_ON(wsm_set_rcpi_rssi_threshold(priv, &threshold));
+	}
+	mutex_unlock(&priv->conf_mutex);
+}
+
+void cw1200_multicast_start_work(struct work_struct *work)
+{
+	struct cw1200_common *priv =
+		container_of(work, struct cw1200_common, multicast_start_work);
+	long tmo = priv->join_dtim_period *
+			(priv->beacon_int + 20) * HZ / 1024;
+
+	cancel_work_sync(&priv->multicast_stop_work);
+
+	if (!priv->aid0_bit_set) {
+		wsm_lock_tx(priv);
+		cw1200_set_tim_impl(priv, true);
+		priv->aid0_bit_set = true;
+		mod_timer(&priv->mcast_timeout, jiffies + tmo);
+		wsm_unlock_tx(priv);
+	}
+}
+
+void cw1200_multicast_stop_work(struct work_struct *work)
+{
+	struct cw1200_common *priv =
+		container_of(work, struct cw1200_common, multicast_stop_work);
+
+	if (priv->aid0_bit_set) {
+		del_timer_sync(&priv->mcast_timeout);
+		wsm_lock_tx(priv);
+		priv->aid0_bit_set = false;
+		cw1200_set_tim_impl(priv, false);
+		wsm_unlock_tx(priv);
+	}
+}
+
+void cw1200_mcast_timeout(unsigned long arg)
+{
+	struct cw1200_common *priv =
+		(struct cw1200_common *)arg;
+
+	wiphy_warn(priv->hw->wiphy,
+		"Multicast delivery timeout.\n");
+	spin_lock_bh(&priv->ps_state_lock);
+	priv->tx_multicast = priv->aid0_bit_set &&
+			priv->buffered_multicasts;
+	if (priv->tx_multicast)
+		cw1200_bh_wakeup(priv);
+	spin_unlock_bh(&priv->ps_state_lock);
+}
+
+int cw1200_ampdu_action(struct ieee80211_hw *hw,
+			struct ieee80211_vif *vif,
+			enum ieee80211_ampdu_mlme_action action,
+			struct ieee80211_sta *sta, u16 tid, u16 *ssn,
+			u8 buf_size)
+{
+	/* Aggregation is implemented fully in firmware,
+	 * including block ack negotiation. Do not allow
+	 * mac80211 stack to do anything: it interferes with
+	 * the firmware. */
+
+	/* Note that we still need this function stubbed. */
+	return -ENOTSUPP;
+}
+
+/* ******************************************************************** */
+/* WSM callback								*/
+void cw1200_suspend_resume(struct cw1200_common *priv,
+			  struct wsm_suspend_resume *arg)
+{
+	pr_debug("[AP] %s: %s\n",
+			arg->stop ? "stop" : "start",
+			arg->multicast ? "broadcast" : "unicast");
+
+	if (arg->multicast) {
+		bool cancel_tmo = false;
+		spin_lock_bh(&priv->ps_state_lock);
+		if (arg->stop) {
+			priv->tx_multicast = false;
+		} else {
+			/* Firmware sends this indication every DTIM if there
+			 * is a STA in powersave connected. There is no reason
+			 * to suspend, following wakeup will consume much more
+			 * power than it could be saved. */
+			cw1200_pm_stay_awake(&priv->pm_state,
+					priv->join_dtim_period *
+					(priv->beacon_int + 20) * HZ / 1024);
+			priv->tx_multicast = priv->aid0_bit_set &&
+					priv->buffered_multicasts;
+			if (priv->tx_multicast) {
+				cancel_tmo = true;
+				cw1200_bh_wakeup(priv);
+			}
+		}
+		spin_unlock_bh(&priv->ps_state_lock);
+		if (cancel_tmo)
+			del_timer_sync(&priv->mcast_timeout);
+	} else {
+		spin_lock_bh(&priv->ps_state_lock);
+		cw1200_ps_notify(priv, arg->link_id, arg->stop);
+		spin_unlock_bh(&priv->ps_state_lock);
+		if (!arg->stop)
+			cw1200_bh_wakeup(priv);
+	}
+	return;
+}
+
+/* ******************************************************************** */
+/* AP privates								*/
+
+static int cw1200_upload_beacon(struct cw1200_common *priv)
+{
+	int ret = 0;
+	struct wsm_template_frame frame = {
+		.frame_type = WSM_FRAME_TYPE_BEACON,
+	};
+	struct ieee80211_mgmt *mgmt;
+	u8 *erp_inf, *ies;
+	u32 ies_len;
+
+	if (priv->vif->p2p)
+		frame.rate = WSM_TRANSMIT_RATE_6;
+
+	frame.skb = ieee80211_beacon_get(priv->hw, priv->vif);
+	if (WARN_ON(!frame.skb))
+		return -ENOMEM;
+
+	mgmt = (void *)frame.skb->data;
+	ies = mgmt->u.beacon.variable;
+	ies_len = frame.skb->len - (u32)(ies - (u8 *)mgmt);
+	erp_inf = (u8 *)cfg80211_find_ie(WLAN_EID_ERP_INFO, ies, ies_len);
+	if (erp_inf) {
+		if (erp_inf[ERP_INFO_BYTE_OFFSET]
+				& WLAN_ERP_BARKER_PREAMBLE)
+			priv->erp_info |= WLAN_ERP_BARKER_PREAMBLE;
+		else
+			priv->erp_info &= ~WLAN_ERP_BARKER_PREAMBLE;
+
+		if (erp_inf[ERP_INFO_BYTE_OFFSET]
+				& WLAN_ERP_NON_ERP_PRESENT) {
+			priv->erp_info |= WLAN_ERP_USE_PROTECTION;
+			priv->erp_info |= WLAN_ERP_NON_ERP_PRESENT;
+		} else {
+			priv->erp_info &= ~WLAN_ERP_USE_PROTECTION;
+			priv->erp_info &= ~WLAN_ERP_NON_ERP_PRESENT;
+		}
+	}
+
+	ret = wsm_set_template_frame(priv, &frame);
+	if (!ret) {
+		/* TODO: Distill probe resp; remove TIM
+		 * and other beacon-specific IEs */
+		*(__le16 *)frame.skb->data =
+			__cpu_to_le16(IEEE80211_FTYPE_MGMT |
+				      IEEE80211_STYPE_PROBE_RESP);
+		frame.frame_type = WSM_FRAME_TYPE_PROBE_RESPONSE;
+		if (priv->vif->p2p) {
+			ret = wsm_set_probe_responder(priv, true);
+		} else {
+			ret = wsm_set_template_frame(priv, &frame);
+			WARN_ON(wsm_set_probe_responder(priv, false));
+		}
+	}
+	dev_kfree_skb(frame.skb);
+
+	return ret;
+}
+
+static int cw1200_upload_pspoll(struct cw1200_common *priv)
+{
+	int ret = 0;
+	struct wsm_template_frame frame = {
+		.frame_type = WSM_FRAME_TYPE_PS_POLL,
+		.rate = 0xFF,
+	};
+
+
+	frame.skb = ieee80211_pspoll_get(priv->hw, priv->vif);
+	if (WARN_ON(!frame.skb))
+		return -ENOMEM;
+
+	ret = wsm_set_template_frame(priv, &frame);
+
+	dev_kfree_skb(frame.skb);
+
+	return ret;
+}
+
+static int cw1200_upload_null(struct cw1200_common *priv)
+{
+	int ret = 0;
+	struct wsm_template_frame frame = {
+		.frame_type = WSM_FRAME_TYPE_NULL,
+		.rate = 0xFF,
+	};
+
+	frame.skb = ieee80211_nullfunc_get(priv->hw, priv->vif);
+	if (WARN_ON(!frame.skb))
+		return -ENOMEM;
+
+	ret = wsm_set_template_frame(priv, &frame);
+
+	dev_kfree_skb(frame.skb);
+
+	return ret;
+}
+
+static int cw1200_upload_qosnull(struct cw1200_common *priv)
+{
+	int ret = 0;
+#if 0  /* XXX this needs to be implemented.. */
+	struct wsm_template_frame frame = {
+		.frame_type = WSM_FRAME_TYPE_QOS_NULL,
+		.rate = 0xFF,
+	};
+
+	frame.skb = ieee80211_qosnullfunc_get(priv->hw, priv->vif);
+	if (WARN_ON(!frame.skb))
+		return -ENOMEM;
+
+	ret = wsm_set_template_frame(priv, &frame);
+
+	dev_kfree_skb(frame.skb);
+#endif
+	return ret;
+}
+
+static int cw1200_enable_beaconing(struct cw1200_common *priv,
+				   bool enable)
+{
+	struct wsm_beacon_transmit transmit = {
+		.enableBeaconing = enable,
+	};
+
+	return wsm_beacon_transmit(priv, &transmit);
+}
+
+static int cw1200_start_ap(struct cw1200_common *priv)
+{
+	int ret;
+	struct ieee80211_bss_conf *conf = &priv->vif->bss_conf;
+	struct wsm_start start = {
+		.mode = priv->vif->p2p ?
+				WSM_START_MODE_P2P_GO : WSM_START_MODE_AP,
+		.band = (priv->channel->band == IEEE80211_BAND_5GHZ) ?
+				WSM_PHY_BAND_5G : WSM_PHY_BAND_2_4G,
+		.channelNumber = priv->channel->hw_value,
+		.beaconInterval = conf->beacon_int,
+		.DTIMPeriod = conf->dtim_period,
+		.preambleType = conf->use_short_preamble ?
+				WSM_JOIN_PREAMBLE_SHORT :
+				WSM_JOIN_PREAMBLE_LONG,
+		.probeDelay = 100,
+		.basicRateSet = cw1200_rate_mask_to_wsm(priv,
+				conf->basic_rates),
+	};
+	struct wsm_operational_mode mode = {
+		.power_mode = cw1200_power_mode,
+		.disableMoreFlagUsage = true,
+	};
+
+	memset(start.ssid, 0, sizeof(start.ssid));
+	if (!conf->hidden_ssid) {
+		start.ssidLength = conf->ssid_len;
+		memcpy(start.ssid, conf->ssid, start.ssidLength);
+	}
+
+	priv->beacon_int = conf->beacon_int;
+	priv->join_dtim_period = conf->dtim_period;
+
+	memset(&priv->link_id_db, 0, sizeof(priv->link_id_db));
+
+	pr_debug("[AP] ch: %d(%d), bcn: %d(%d), brt: 0x%.8X, ssid: %.*s.\n",
+		start.channelNumber, start.band,
+		start.beaconInterval, start.DTIMPeriod,
+		start.basicRateSet,
+		start.ssidLength, start.ssid);
+	ret = WARN_ON(wsm_start(priv, &start));
+	if (!ret)
+		ret = WARN_ON(cw1200_upload_keys(priv));
+	if (!ret && priv->vif->p2p) {
+		pr_debug("[AP] Setting p2p powersave configuration.\n");
+		WARN_ON(wsm_set_p2p_ps_modeinfo(priv,
+			&priv->p2p_ps_modeinfo));
+	}
+	if (!ret) {
+		WARN_ON(wsm_set_block_ack_policy(priv, 0, 0));
+		priv->join_status = CW1200_JOIN_STATUS_AP;
+		cw1200_update_filtering(priv);
+	}
+	WARN_ON(wsm_set_operational_mode(priv, &mode));
+	return ret;
+}
+
+static int cw1200_update_beaconing(struct cw1200_common *priv)
+{
+	struct ieee80211_bss_conf *conf = &priv->vif->bss_conf;
+	struct wsm_reset reset = {
+		.link_id = 0,
+		.reset_statistics = true,
+	};
+
+	if (priv->mode == NL80211_IFTYPE_AP) {
+		/* TODO: check if changed channel, band */
+		if (priv->join_status != CW1200_JOIN_STATUS_AP ||
+		    priv->beacon_int != conf->beacon_int) {
+			pr_debug("ap restarting\n");
+			wsm_lock_tx(priv);
+			if (priv->join_status != CW1200_JOIN_STATUS_PASSIVE)
+				WARN_ON(wsm_reset(priv, &reset));
+			priv->join_status = CW1200_JOIN_STATUS_PASSIVE;
+			WARN_ON(cw1200_start_ap(priv));
+			wsm_unlock_tx(priv);
+		} else
+			pr_debug("ap started join_status: %d\n",
+				  priv->join_status);
+	}
+	return 0;
+}
+
diff --git a/drivers/net/wireless/cw1200/sta.h b/drivers/net/wireless/cw1200/sta.h
new file mode 100644
index 0000000..02b2696
--- /dev/null
+++ b/drivers/net/wireless/cw1200/sta.h
@@ -0,0 +1,122 @@
+/*
+ * Mac80211 STA interface for ST-Ericsson CW1200 mac80211 drivers
+ *
+ * Copyright (c) 2010, ST-Ericsson
+ * Author: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef STA_H_INCLUDED
+#define STA_H_INCLUDED
+
+/* ******************************************************************** */
+/* mac80211 API								*/
+
+int cw1200_start(struct ieee80211_hw *dev);
+void cw1200_stop(struct ieee80211_hw *dev);
+int cw1200_add_interface(struct ieee80211_hw *dev,
+			 struct ieee80211_vif *vif);
+void cw1200_remove_interface(struct ieee80211_hw *dev,
+			     struct ieee80211_vif *vif);
+int cw1200_change_interface(struct ieee80211_hw *dev,
+			    struct ieee80211_vif *vif,
+			    enum nl80211_iftype new_type,
+			    bool p2p);
+int cw1200_config(struct ieee80211_hw *dev, u32 changed);
+void cw1200_configure_filter(struct ieee80211_hw *dev,
+			     unsigned int changed_flags,
+			     unsigned int *total_flags,
+			     u64 multicast);
+int cw1200_conf_tx(struct ieee80211_hw *dev, struct ieee80211_vif *vif,
+		   u16 queue, const struct ieee80211_tx_queue_params *params);
+int cw1200_get_stats(struct ieee80211_hw *dev,
+		     struct ieee80211_low_level_stats *stats);
+/* Not more a part of interface?
+int cw1200_get_tx_stats(struct ieee80211_hw *dev,
+			struct ieee80211_tx_queue_stats *stats);
+*/
+int cw1200_set_key(struct ieee80211_hw *dev, enum set_key_cmd cmd,
+		   struct ieee80211_vif *vif, struct ieee80211_sta *sta,
+		   struct ieee80211_key_conf *key);
+
+int cw1200_set_rts_threshold(struct ieee80211_hw *hw, u32 value);
+
+void cw1200_flush(struct ieee80211_hw *hw, bool drop);
+
+u64 cw1200_prepare_multicast(struct ieee80211_hw *hw,
+			     struct netdev_hw_addr_list *mc_list);
+
+int cw1200_set_pm(struct cw1200_common *priv, const struct wsm_set_pm *arg);
+
+/* ******************************************************************** */
+/* WSM callbacks							*/
+
+/* void cw1200_set_pm_complete_cb(struct cw1200_common *priv,
+	struct wsm_set_pm_complete *arg); */
+void cw1200_channel_switch_cb(struct cw1200_common *priv);
+void cw1200_join_complete_cb(struct cw1200_common *priv,
+				struct wsm_join_complete *arg);
+
+/* ******************************************************************** */
+/* WSM events								*/
+
+void cw1200_free_event_queue(struct cw1200_common *priv);
+void cw1200_event_handler(struct work_struct *work);
+void cw1200_bss_loss_work(struct work_struct *work);
+void cw1200_connection_loss_work(struct work_struct *work);
+void cw1200_keep_alive_work(struct work_struct *work);
+void cw1200_tx_failure_work(struct work_struct *work);
+
+/* ******************************************************************** */
+/* Internal API								*/
+
+int cw1200_setup_mac(struct cw1200_common *priv);
+void cw1200_join_work(struct work_struct *work);
+void cw1200_join_timeout(struct work_struct *work);
+void cw1200_unjoin_work(struct work_struct *work);
+void cw1200_offchannel_work(struct work_struct *work);
+void cw1200_join_complete_work(struct work_struct *work);
+void cw1200_wep_key_work(struct work_struct *work);
+void cw1200_update_listening(struct cw1200_common *priv, bool enabled);
+void cw1200_update_filtering(struct cw1200_common *priv);
+void cw1200_update_filtering_work(struct work_struct *work);
+void cw1200_set_beacon_wakeup_period_work(struct work_struct *work);
+int cw1200_enable_listening(struct cw1200_common *priv);
+int cw1200_disable_listening(struct cw1200_common *priv);
+int cw1200_set_uapsd_param(struct cw1200_common *priv,
+				const struct wsm_edca_params *arg);
+void cw1200_ba_work(struct work_struct *work);
+void cw1200_ba_timer(unsigned long arg);
+
+/* AP stuffs */
+int cw1200_set_tim(struct ieee80211_hw *dev, struct ieee80211_sta *sta,
+		   bool set);
+int cw1200_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		   struct ieee80211_sta *sta);
+int cw1200_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		      struct ieee80211_sta *sta);
+void cw1200_sta_notify(struct ieee80211_hw *dev, struct ieee80211_vif *vif,
+		       enum sta_notify_cmd notify_cmd,
+		       struct ieee80211_sta *sta);
+void cw1200_bss_info_changed(struct ieee80211_hw *dev,
+			     struct ieee80211_vif *vif,
+			     struct ieee80211_bss_conf *info,
+			     u32 changed);
+int cw1200_ampdu_action(struct ieee80211_hw *hw,
+			struct ieee80211_vif *vif,
+			enum ieee80211_ampdu_mlme_action action,
+			struct ieee80211_sta *sta, u16 tid, u16 *ssn,
+			u8 buf_size);
+
+void cw1200_suspend_resume(struct cw1200_common *priv,
+			  struct wsm_suspend_resume *arg);
+void cw1200_set_tim_work(struct work_struct *work);
+void cw1200_set_cts_work(struct work_struct *work);
+void cw1200_multicast_start_work(struct work_struct *work);
+void cw1200_multicast_stop_work(struct work_struct *work);
+void cw1200_mcast_timeout(unsigned long arg);
+
+#endif
-- 
1.8.1.2

