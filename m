Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:47268 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab3ALOG2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jan 2013 09:06:28 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH 04/15] cw1200: v3: power management
Date: Sat, 12 Jan 2013 09:06:04 -0500
Message-Id: <1357999575-12838-5-git-send-email-pizza@shaftnet.org> (sfid-20130112_150632_287061_3D4C4797)
In-Reply-To: <1357999575-12838-1-git-send-email-pizza@shaftnet.org>
References: <1357999575-12838-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/staging/cw1200/pm.c | 385 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/staging/cw1200/pm.h |  46 ++++++
 2 files changed, 431 insertions(+)
 create mode 100644 drivers/staging/cw1200/pm.c
 create mode 100644 drivers/staging/cw1200/pm.h

diff --git a/drivers/staging/cw1200/pm.c b/drivers/staging/cw1200/pm.c
new file mode 100644
index 0000000..0a3fdfa
--- /dev/null
+++ b/drivers/staging/cw1200/pm.c
@@ -0,0 +1,385 @@
+/*
+ * Mac80211 power management API for ST-Ericsson CW1200 drivers
+ *
+ * Copyright (c) 2011, ST-Ericsson
+ * Author: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/if_ether.h>
+#include "cw1200.h"
+#include "pm.h"
+#include "sta.h"
+#include "bh.h"
+#include "sbus.h"
+
+#define CW1200_BEACON_SKIPPING_MULTIPLIER 3
+
+struct cw1200_udp_port_filter {
+	struct wsm_udp_port_filter_hdr hdr;
+	/* Up to 4 filters are allowed. */
+	struct wsm_udp_port_filter filters[WSM_MAX_FILTER_ELEMENTS];
+} __packed;
+
+struct cw1200_ether_type_filter {
+	struct wsm_ether_type_filter_hdr hdr;
+	/* Up to 4 filters are allowed. */
+	struct wsm_ether_type_filter filters[WSM_MAX_FILTER_ELEMENTS];
+} __packed;
+
+static struct cw1200_udp_port_filter cw1200_udp_port_filter_on = {
+	.hdr.nrFilters = 2,
+	.filters = {
+		[0] = {
+			.filterAction = WSM_FILTER_ACTION_FILTER_OUT,
+			.portType = WSM_FILTER_PORT_TYPE_DST,
+			.udpPort = __cpu_to_le16(67), /* DHCP Bootps */
+		},
+		[1] = {
+			.filterAction = WSM_FILTER_ACTION_FILTER_OUT,
+			.portType = WSM_FILTER_PORT_TYPE_DST,
+			.udpPort = __cpu_to_le16(68), /* DHCP Bootpc */
+		},
+	}
+};
+
+static struct wsm_udp_port_filter_hdr cw1200_udp_port_filter_off = {
+	.nrFilters = 0,
+};
+
+#ifndef ETH_P_WAPI
+#define ETH_P_WAPI     0x88B4
+#endif
+
+static struct cw1200_ether_type_filter cw1200_ether_type_filter_on = {
+	.hdr.nrFilters = 4,
+	.filters = {
+		[0] = {
+			.filterAction = WSM_FILTER_ACTION_FILTER_IN,
+			.etherType = __cpu_to_le16(ETH_P_IP),
+		},
+		[1] = {
+			.filterAction = WSM_FILTER_ACTION_FILTER_IN,
+			.etherType = __cpu_to_le16(ETH_P_PAE),
+		},
+		[2] = {
+			.filterAction = WSM_FILTER_ACTION_FILTER_IN,
+			.etherType = __cpu_to_le16(ETH_P_WAPI),
+		},
+		[3] = {
+			.filterAction = WSM_FILTER_ACTION_FILTER_IN,
+			.etherType = __cpu_to_le16(ETH_P_ARP),
+		},
+	},
+};
+
+static struct wsm_ether_type_filter_hdr cw1200_ether_type_filter_off = {
+	.nrFilters = 0,
+};
+
+/* private */
+struct cw1200_suspend_state {
+	unsigned long bss_loss_tmo;
+	unsigned long connection_loss_tmo;
+	unsigned long join_tmo;
+	unsigned long direct_probe;
+	unsigned long link_id_gc;
+	bool beacon_skipping;
+	u8 prev_ps_mode;
+};
+
+static void cw1200_pm_stay_awake_tmo(unsigned long arg)
+{
+	/* XXX what's the point of this ? */
+}
+
+int cw1200_pm_init(struct cw1200_pm_state *pm,
+		   struct cw1200_common *priv)
+{
+	spin_lock_init(&pm->lock);
+
+	init_timer(&pm->stay_awake);
+	pm->stay_awake.data = (unsigned long)pm;
+	pm->stay_awake.function = cw1200_pm_stay_awake_tmo;
+
+	return 0;
+}
+
+void cw1200_pm_deinit(struct cw1200_pm_state *pm)
+{
+	del_timer_sync(&pm->stay_awake);
+}
+
+void cw1200_pm_stay_awake(struct cw1200_pm_state *pm,
+			  unsigned long tmo)
+{
+	long cur_tmo;
+	spin_lock_bh(&pm->lock);
+	cur_tmo = pm->stay_awake.expires - jiffies;
+	if (!timer_pending(&pm->stay_awake) ||
+			cur_tmo < (long)tmo)
+		mod_timer(&pm->stay_awake, jiffies + tmo);
+	spin_unlock_bh(&pm->lock);
+}
+
+static long cw1200_suspend_work(struct delayed_work *work)
+{
+	int ret = cancel_delayed_work(work);
+	long tmo;
+	if (ret > 0) {
+		/* Timer is pending */
+		tmo = work->timer.expires - jiffies;
+		if (tmo < 0)
+			tmo = 0;
+	} else {
+		tmo = -1;
+	}
+	return tmo;
+}
+
+static int cw1200_resume_work(struct cw1200_common *priv,
+			       struct delayed_work *work,
+			       unsigned long tmo)
+{
+	if ((long)tmo < 0)
+		return 1;
+
+	return queue_delayed_work(priv->workqueue, work, tmo);
+}
+
+int cw1200_can_suspend(struct cw1200_common *priv)
+{
+	if (atomic_read(&priv->bh_rx)) {
+		wiphy_dbg(priv->hw->wiphy, "%s: Suspend interrupted.\n",
+			  __func__);
+		return 0;
+	}
+	return 1;
+}
+EXPORT_SYMBOL_GPL(cw1200_can_suspend);
+
+int cw1200_wow_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
+{
+	struct cw1200_common *priv = hw->priv;
+	struct cw1200_pm_state *pm_state = &priv->pm_state;
+	struct cw1200_suspend_state *state;
+	int ret;
+
+	spin_lock_bh(&pm_state->lock);
+	ret = timer_pending(&pm_state->stay_awake);
+	spin_unlock_bh(&pm_state->lock);
+	if (ret)
+		return -EAGAIN;
+
+	/* Do not suspend when datapath is not idle */
+	if (priv->tx_queue_stats.num_queued)
+		return -EBUSY;
+
+	/* Make sure there is no configuration requests in progress. */
+	if (!mutex_trylock(&priv->conf_mutex))
+		return -EBUSY;
+
+	/* Ensure pending operations are done.
+	 * Note also that wow_suspend must return in ~2.5sec, before
+	 * watchdog is triggered. */
+	if (priv->channel_switch_in_progress)
+		goto revert1;
+
+	/* Do not suspend when join work is scheduled */
+	if (work_pending(&priv->join_work))
+		goto revert1;
+
+	/* Do not suspend when scanning */
+	if (down_trylock(&priv->scan.lock))
+		goto revert1;
+
+	/* Lock TX. */
+	wsm_lock_tx_async(priv);
+
+	/* Wait to avoid possible race with bh code.
+	 * But do not wait too long... */
+	if (wait_event_timeout(priv->bh_evt_wq,
+			!priv->hw_bufs_used, HZ / 10) <= 0)
+		goto revert2;
+
+	/* Set UDP filter */
+	wsm_set_udp_port_filter(priv, &cw1200_udp_port_filter_on.hdr);
+
+	/* Set ethernet frame type filter */
+	wsm_set_ether_type_filter(priv, &cw1200_ether_type_filter_on.hdr);
+
+	/* Allocate state */
+	state = kzalloc(sizeof(struct cw1200_suspend_state), GFP_KERNEL);
+	if (!state)
+		goto revert3;
+
+	/* Change to legacy PS while going to suspend */
+	if (!priv->vif->p2p &&
+	    priv->join_status == CW1200_JOIN_STATUS_STA &&
+	    priv->powersave_mode.pmMode != WSM_PSM_PS) {
+		state->prev_ps_mode = priv->powersave_mode.pmMode;
+		priv->powersave_mode.pmMode = WSM_PSM_PS;
+		cw1200_set_pm(priv, &priv->powersave_mode);
+		if (wait_event_interruptible_timeout(priv->ps_mode_switch_done,
+						     !priv->ps_mode_switch_in_progress, 1*HZ) <= 0) {
+			goto revert3;
+		}
+	}
+
+	/* Store delayed work states. */
+	state->bss_loss_tmo =
+		cw1200_suspend_work(&priv->bss_loss_work);
+	state->connection_loss_tmo =
+		cw1200_suspend_work(&priv->connection_loss_work);
+	state->join_tmo =
+		cw1200_suspend_work(&priv->join_timeout);
+	state->direct_probe =
+		cw1200_suspend_work(&priv->scan.probe_work);
+	state->link_id_gc =
+		cw1200_suspend_work(&priv->link_id_gc_work);
+
+	cancel_delayed_work_sync(&priv->clear_recent_scan_work);
+	atomic_set(&priv->recent_scan, 0);
+
+	/* Enable beacon skipping */
+	if (priv->join_status == CW1200_JOIN_STATUS_STA
+			&& priv->join_dtim_period
+			&& !priv->has_multicast_subscription) {
+		state->beacon_skipping = true;
+		wsm_set_beacon_wakeup_period(priv,
+				priv->join_dtim_period,
+				CW1200_BEACON_SKIPPING_MULTIPLIER *
+				 priv->join_dtim_period);
+	}
+
+	/* Stop serving thread */
+	if (cw1200_bh_suspend(priv))
+		goto revert4;
+
+	ret = timer_pending(&priv->mcast_timeout);
+	if (ret)
+		goto revert5;
+
+	/* Cancel block ack stat timer */
+	del_timer_sync(&priv->ba_timer);
+
+	/* Store suspend state */
+	pm_state->suspend_state = state;
+
+	/* Enable IRQ wake */
+	ret = priv->sbus_ops->power_mgmt(priv->sbus_priv, true);
+	if (ret) {
+		wiphy_err(priv->hw->wiphy,
+			"%s: PM request failed: %d. WoW is disabled.\n",
+			__func__, ret);
+		cw1200_wow_resume(hw);
+		return -EBUSY;
+	}
+
+	/* Force resume if event is coming from the device. */
+	if (atomic_read(&priv->bh_rx)) {
+		cw1200_wow_resume(hw);
+		return -EAGAIN;
+	}
+
+	return 0;
+
+revert5:
+	WARN_ON(cw1200_bh_resume(priv));
+revert4:
+	cw1200_resume_work(priv, &priv->bss_loss_work,
+			state->bss_loss_tmo);
+	cw1200_resume_work(priv, &priv->connection_loss_work,
+			state->connection_loss_tmo);
+	cw1200_resume_work(priv, &priv->join_timeout,
+			state->join_tmo);
+	cw1200_resume_work(priv, &priv->scan.probe_work,
+			state->direct_probe);
+	cw1200_resume_work(priv, &priv->link_id_gc_work,
+			state->link_id_gc);
+	kfree(state);
+revert3:
+	wsm_set_udp_port_filter(priv, &cw1200_udp_port_filter_off);
+	wsm_set_ether_type_filter(priv, &cw1200_ether_type_filter_off);
+revert2:
+	wsm_unlock_tx(priv);
+	up(&priv->scan.lock);
+revert1:
+	mutex_unlock(&priv->conf_mutex);
+	return -EBUSY;
+}
+
+int cw1200_wow_resume(struct ieee80211_hw *hw)
+{
+	struct cw1200_common *priv = hw->priv;
+	struct cw1200_pm_state *pm_state = &priv->pm_state;
+	struct cw1200_suspend_state *state;
+
+	state = pm_state->suspend_state;
+	pm_state->suspend_state = NULL;
+
+	/* Disable IRQ wake */
+	priv->sbus_ops->power_mgmt(priv->sbus_priv, false);
+
+	/* Scan.lock must be released before BH is resumed other way
+	 * in case when BSS_LOST command arrived the processing of the
+	 * command will be delayed. */
+	up(&priv->scan.lock);
+
+	/* Resume BH thread */
+	WARN_ON(cw1200_bh_resume(priv));
+
+	/* Restores previous PS mode */
+	if (!priv->vif->p2p && priv->join_status == CW1200_JOIN_STATUS_STA) {
+		priv->powersave_mode.pmMode = state->prev_ps_mode;
+		cw1200_set_pm(priv, &priv->powersave_mode);
+	}
+
+	if (state->beacon_skipping) {
+		wsm_set_beacon_wakeup_period(priv, priv->beacon_int *
+				priv->join_dtim_period >
+				MAX_BEACON_SKIP_TIME_MS ? 1 :
+				priv->join_dtim_period, 0);
+		state->beacon_skipping = false;
+	}
+
+	/* Resume delayed work */
+	cw1200_resume_work(priv, &priv->bss_loss_work,
+			state->bss_loss_tmo);
+	cw1200_resume_work(priv, &priv->connection_loss_work,
+			state->connection_loss_tmo);
+	cw1200_resume_work(priv, &priv->join_timeout,
+			state->join_tmo);
+	cw1200_resume_work(priv, &priv->scan.probe_work,
+			state->direct_probe);
+	cw1200_resume_work(priv, &priv->link_id_gc_work,
+			state->link_id_gc);
+
+	/* Restart block ack stat */
+	spin_lock_bh(&priv->ba_lock);
+	if (priv->ba_cnt)
+		mod_timer(&priv->ba_timer,
+			jiffies + CW1200_BLOCK_ACK_INTERVAL);
+	spin_unlock_bh(&priv->ba_lock);
+
+	/* Remove UDP port filter */
+	wsm_set_udp_port_filter(priv, &cw1200_udp_port_filter_off);
+
+	/* Remove ethernet frame type filter */
+	wsm_set_ether_type_filter(priv, &cw1200_ether_type_filter_off);
+
+	/* Unlock datapath */
+	wsm_unlock_tx(priv);
+
+	/* Unlock configuration mutex */
+	mutex_unlock(&priv->conf_mutex);
+
+	/* Free memory */
+	kfree(state);
+
+	return 0;
+}
diff --git a/drivers/staging/cw1200/pm.h b/drivers/staging/cw1200/pm.h
new file mode 100644
index 0000000..6865449
--- /dev/null
+++ b/drivers/staging/cw1200/pm.h
@@ -0,0 +1,46 @@
+/*
+ * Mac80211 power management interface for ST-Ericsson CW1200 mac80211 drivers
+ *
+ * Copyright (c) 2011, ST-Ericsson
+ * Author: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef PM_H_INCLUDED
+#define PM_H_INCLUDED
+
+/* ******************************************************************** */
+/* mac80211 API								*/
+
+#ifdef CONFIG_CW1200_PM
+
+/* extern */  struct cw1200_common;
+/* private */ struct cw1200_suspend_state;
+
+struct cw1200_pm_state {
+	struct cw1200_suspend_state *suspend_state;
+	struct timer_list stay_awake;
+	struct platform_device *pm_dev;
+	spinlock_t lock;
+};
+
+int cw1200_pm_init(struct cw1200_pm_state *pm,
+		    struct cw1200_common *priv);
+void cw1200_pm_deinit(struct cw1200_pm_state *pm);
+void cw1200_pm_stay_awake(struct cw1200_pm_state *pm,
+			  unsigned long tmo);
+int cw1200_wow_suspend(struct ieee80211_hw *hw,
+		       struct cfg80211_wowlan *wowlan);
+int cw1200_wow_resume(struct ieee80211_hw *hw);
+int cw1200_can_suspend(struct cw1200_common *priv);
+#else
+static inline int cw1200_can_suspend(struct cw1200_common *priv)
+{
+	return 1;
+}
+#endif /* CONFIG_CW1200_PM */
+
+#endif
-- 
1.7.11.7

