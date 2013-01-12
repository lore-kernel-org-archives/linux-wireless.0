Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:40971 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab3ALOGe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jan 2013 09:06:34 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH 06/15] cw1200: v3: mini-ap support code
Date: Sat, 12 Jan 2013 09:06:06 -0500
Message-Id: <1357999575-12838-7-git-send-email-pizza@shaftnet.org> (sfid-20130112_150638_014162_C285544E)
In-Reply-To: <1357999575-12838-1-git-send-email-pizza@shaftnet.org>
References: <1357999575-12838-1-git-send-email-pizza@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/staging/cw1200/ap.c | 1104 +++++++++++++++++++++++++++++++++++++++++++
 drivers/staging/cw1200/ap.h |   46 ++
 2 files changed, 1150 insertions(+)
 create mode 100644 drivers/staging/cw1200/ap.c
 create mode 100644 drivers/staging/cw1200/ap.h

diff --git a/drivers/staging/cw1200/ap.c b/drivers/staging/cw1200/ap.c
new file mode 100644
index 0000000..bf87f0f
--- /dev/null
+++ b/drivers/staging/cw1200/ap.c
@@ -0,0 +1,1104 @@
+/*
+ * mac80211 STA and AP API for mac80211 ST-Ericsson CW1200 drivers
+ *
+ * Copyright (c) 2010, ST-Ericsson
+ * Author: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "cw1200.h"
+#include "sta.h"
+#include "ap.h"
+#include "bh.h"
+
+#define CW1200_LINK_ID_GC_TIMEOUT ((unsigned long)(10 * HZ))
+
+#ifndef ERP_INFO_BYTE_OFFSET
+#define ERP_INFO_BYTE_OFFSET 2
+#endif
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
+				BUG_ON(!priv->channel);
+				priv->ht_info.ht_cap = sta->ht_cap;
+				priv->bss_params.operationalRateSet =
+					__cpu_to_le32(
+					cw1200_rate_mask_to_wsm(priv,
+					sta->supp_rates[priv->channel->band]));
+				priv->ht_info.channel_type =
+						info->channel_type;
+				priv->ht_info.operation_mode =
+						info->ht_operation_mode;
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
+			if (priv->mode == NL80211_IFTYPE_STATION)
+				WARN_ON(cw1200_upload_qosnull(priv));
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
+	/* XXX
+	   IEEE80211_AMPDU_TX_STOP removes TID from priv->tid_mask?
+	   IEEE80211_AMPDU_TX_START adds TID to priv->mask?
+	*/
+
+	/* Note that we still need this function stubbed to prevent a warning. */
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
+#ifdef CONFIG_CW1200_PM
+			cw1200_pm_stay_awake(&priv->pm_state,
+					priv->join_dtim_period *
+					(priv->beacon_int + 20) * HZ / 1024);
+#endif
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
+	const u8 *ssidie;
+	struct sk_buff *skb;
+	int offset;
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
+	/* Get SSID */
+	skb = ieee80211_beacon_get(priv->hw, priv->vif);
+	if (WARN_ON(!skb))
+		return -ENOMEM;
+
+	offset = offsetof(struct ieee80211_mgmt, u.beacon.variable);
+	ssidie = cfg80211_find_ie(WLAN_EID_SSID, skb->data + offset,
+				  skb->len - offset);
+
+	if (ssidie) {
+		start.ssidLength = ssidie[1];
+		memcpy(start.ssid, ssidie + 2, start.ssidLength);
+	} else {
+		start.ssidLength = 0;
+		memset(start.ssid, 0, sizeof(start.ssid));
+	}
+
+	dev_kfree_skb(skb);
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
+		WARN_ON(wsm_set_block_ack_policy(priv,
+			0, 0));
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
+int cw1200_find_link_id(struct cw1200_common *priv, const u8 *mac)
+{
+	int i, ret = 0;
+	spin_lock_bh(&priv->ps_state_lock);
+	for (i = 0; i < CW1200_MAX_STA_IN_AP_MODE; ++i) {
+		if (!memcmp(mac, priv->link_id_db[i].mac, ETH_ALEN) &&
+				priv->link_id_db[i].status) {
+			priv->link_id_db[i].timestamp = jiffies;
+			ret = i + 1;
+			break;
+		}
+	}
+	spin_unlock_bh(&priv->ps_state_lock);
+	return ret;
+}
+
+int cw1200_alloc_link_id(struct cw1200_common *priv, const u8 *mac)
+{
+	int i, ret = 0;
+	unsigned long max_inactivity = 0;
+	unsigned long now = jiffies;
+
+	spin_lock_bh(&priv->ps_state_lock);
+	for (i = 0; i < CW1200_MAX_STA_IN_AP_MODE; ++i) {
+		if (!priv->link_id_db[i].status) {
+			ret = i + 1;
+			break;
+		} else if (priv->link_id_db[i].status != CW1200_LINK_HARD &&
+			!priv->tx_queue_stats.link_map_cache[i + 1]) {
+
+			unsigned long inactivity =
+					now - priv->link_id_db[i].timestamp;
+			if (inactivity < max_inactivity)
+				continue;
+			max_inactivity = inactivity;
+			ret = i + 1;
+		}
+	}
+	if (ret) {
+		struct cw1200_link_entry *entry = &priv->link_id_db[ret - 1];
+		pr_debug("[AP] STA added, link_id: %d\n",
+			ret);
+		entry->status = CW1200_LINK_RESERVE;
+		memcpy(&entry->mac, mac, ETH_ALEN);
+		memset(&entry->buffered, 0, CW1200_MAX_TID);
+		skb_queue_head_init(&entry->rx_queue);
+		wsm_lock_tx_async(priv);
+		if (queue_work(priv->workqueue, &priv->link_id_work) <= 0)
+			wsm_unlock_tx(priv);
+	} else {
+		wiphy_info(priv->hw->wiphy,
+			"[AP] Early: no more link IDs available.\n");
+	}
+
+	spin_unlock_bh(&priv->ps_state_lock);
+	return ret;
+}
+
+void cw1200_link_id_work(struct work_struct *work)
+{
+	struct cw1200_common *priv =
+		container_of(work, struct cw1200_common, link_id_work);
+	wsm_flush_tx(priv);
+	cw1200_link_id_gc_work(&priv->link_id_gc_work.work);
+	wsm_unlock_tx(priv);
+}
+
+void cw1200_link_id_gc_work(struct work_struct *work)
+{
+	struct cw1200_common *priv =
+		container_of(work, struct cw1200_common, link_id_gc_work.work);
+	struct wsm_reset reset = {
+		.reset_statistics = false,
+	};
+	struct wsm_map_link map_link = {
+		.link_id = 0,
+	};
+	unsigned long now = jiffies;
+	unsigned long next_gc = -1;
+	long ttl;
+	bool need_reset;
+	u32 mask;
+	int i;
+
+	if (priv->join_status != CW1200_JOIN_STATUS_AP)
+		return;
+
+	wsm_lock_tx(priv);
+	spin_lock_bh(&priv->ps_state_lock);
+	for (i = 0; i < CW1200_MAX_STA_IN_AP_MODE; ++i) {
+		need_reset = false;
+		mask = BIT(i + 1);
+		if (priv->link_id_db[i].status == CW1200_LINK_RESERVE ||
+			(priv->link_id_db[i].status == CW1200_LINK_HARD &&
+			 !(priv->link_id_map & mask))) {
+			if (priv->link_id_map & mask) {
+				priv->sta_asleep_mask &= ~mask;
+				priv->pspoll_mask &= ~mask;
+				need_reset = true;
+			}
+			priv->link_id_map |= mask;
+			if (priv->link_id_db[i].status != CW1200_LINK_HARD)
+				priv->link_id_db[i].status = CW1200_LINK_SOFT;
+			memcpy(map_link.mac_addr, priv->link_id_db[i].mac,
+					ETH_ALEN);
+			spin_unlock_bh(&priv->ps_state_lock);
+			if (need_reset) {
+				reset.link_id = i + 1;
+				WARN_ON(wsm_reset(priv, &reset));
+			}
+			map_link.link_id = i + 1;
+			WARN_ON(wsm_map_link(priv, &map_link));
+			next_gc = min(next_gc, CW1200_LINK_ID_GC_TIMEOUT);
+			spin_lock_bh(&priv->ps_state_lock);
+		} else if (priv->link_id_db[i].status == CW1200_LINK_SOFT) {
+			ttl = priv->link_id_db[i].timestamp - now +
+					CW1200_LINK_ID_GC_TIMEOUT;
+			if (ttl <= 0) {
+				need_reset = true;
+				priv->link_id_db[i].status = CW1200_LINK_OFF;
+				priv->link_id_map &= ~mask;
+				priv->sta_asleep_mask &= ~mask;
+				priv->pspoll_mask &= ~mask;
+				memset(map_link.mac_addr, 0, ETH_ALEN);
+				spin_unlock_bh(&priv->ps_state_lock);
+				reset.link_id = i + 1;
+				WARN_ON(wsm_reset(priv, &reset));
+				spin_lock_bh(&priv->ps_state_lock);
+			} else {
+				next_gc = min_t(unsigned long, next_gc, ttl);
+			}
+		} else if (priv->link_id_db[i].status == CW1200_LINK_RESET ||
+				priv->link_id_db[i].status ==
+				CW1200_LINK_RESET_REMAP) {
+			int status = priv->link_id_db[i].status;
+			priv->link_id_db[i].status =
+					priv->link_id_db[i].prev_status;
+			priv->link_id_db[i].timestamp = now;
+			reset.link_id = i + 1;
+			spin_unlock_bh(&priv->ps_state_lock);
+			WARN_ON(wsm_reset(priv, &reset));
+			if (status == CW1200_LINK_RESET_REMAP) {
+				memcpy(map_link.mac_addr,
+						priv->link_id_db[i].mac,
+						ETH_ALEN);
+				map_link.link_id = i + 1;
+				WARN_ON(wsm_map_link(priv, &map_link));
+				next_gc = min(next_gc,
+						CW1200_LINK_ID_GC_TIMEOUT);
+			}
+			spin_lock_bh(&priv->ps_state_lock);
+		}
+		if (need_reset) {
+			skb_queue_purge(&priv->link_id_db[i].rx_queue);
+			pr_debug("[AP] STA removed, link_id: %d\n",
+					reset.link_id);
+		}
+	}
+	spin_unlock_bh(&priv->ps_state_lock);
+	if (next_gc != -1)
+		queue_delayed_work(priv->workqueue,
+				&priv->link_id_gc_work, next_gc);
+	wsm_unlock_tx(priv);
+}
diff --git a/drivers/staging/cw1200/ap.h b/drivers/staging/cw1200/ap.h
new file mode 100644
index 0000000..2175a82
--- /dev/null
+++ b/drivers/staging/cw1200/ap.h
@@ -0,0 +1,46 @@
+/*
+ * mac80211 STA and AP API for mac80211 ST-Ericsson CW1200 drivers
+ *
+ * Copyright (c) 2010, ST-Ericsson
+ * Author: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef AP_H_INCLUDED
+#define AP_H_INCLUDED
+
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
+int cw1200_find_link_id(struct cw1200_common *priv, const u8 *mac);
+int cw1200_alloc_link_id(struct cw1200_common *priv, const u8 *mac);
+void cw1200_link_id_work(struct work_struct *work);
+void cw1200_link_id_gc_work(struct work_struct *work);
+
+#endif
-- 
1.7.11.7

