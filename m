Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53728 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934995AbcLOGA7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Dec 2016 01:00:59 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [RFC 2/3] mac80211: Implement data xmit for 802.11 encap offload
Date: Thu, 15 Dec 2016 11:30:07 +0530
Message-ID: <1481781608-5181-3-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20161215_070115_734096_6ACB30B5)
In-Reply-To: <1481781608-5181-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1481781608-5181-1-git-send-email-vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver (or hw) supporting 802.11 encapsulation offload
for data frames can make use of this new xmit path.

This patch defines new ndo_ops, all these callbacks are same as
ieee80211_dataif_ops other than ndo_start_xmit() which does
minimal processing leaving 802.11 encap related to driver.
This patch makes netdev_ops registration dynamic based on the
interface type, at any time the netdev_ops of netdev will be
assigned to either the ndo_ops defined to do 802.11 encap or
the ones defined for 802.11 encap offload. There is a new hw
config notification, IEEE80211_CONF_CHANGE_80211_HDR_OFFL, to make
the driver aware of any configuration change in 802.11 encap/decap
offload.

There is a field, no_80211_encap, added to ieee80211_tx_info:control
to mark if the 802.11 encapsulation is offloaded to driver.
There is also a new callback for tx completion status indication
to handle data frames using 802.11 encap offload. Currently ath10k
fw is capable of doing 802.11 encapsulation/decapsulationi offload.
With the corresponding driver changes, using 802.11 encap/decap offload
might improve performance.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 include/net/mac80211.h     |  33 ++++++-
 net/mac80211/cfg.c         |   8 ++
 net/mac80211/ieee80211_i.h |  12 +++
 net/mac80211/iface.c       | 147 +++++++++++++++++++++++++++++
 net/mac80211/key.c         |  16 +++-
 net/mac80211/main.c        |   3 +
 net/mac80211/status.c      |  83 ++++++++++++++++-
 net/mac80211/tx.c          | 225 ++++++++++++++++++++++++++++++++++++++++++++-
 8 files changed, 519 insertions(+), 8 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 1e3c8b5..225abaa 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -910,7 +910,12 @@ struct ieee80211_tx_info {
 			};
 			struct ieee80211_key_conf *hw_key;
 			u32 flags;
-			/* 4 bytes free */
+			/* XXX: This frame is not encaptulated with 802.11
+			 * header. Should this be added to %IEEE80211_TX_CTRL_*
+			 * flags?.
+			 */
+			bool no_80211_encap;
+			/* 3 bytes free */
 		} control;
 		struct {
 			u64 cookie;
@@ -1269,6 +1274,8 @@ enum ieee80211_conf_flags {
  * @IEEE80211_CONF_CHANGE_SMPS: Spatial multiplexing powersave mode changed
  *	Note that this is only valid if channel contexts are not used,
  *	otherwise each channel context has the number of chains listed.
+ * @IEEE80211_CONF_CHANGE_80211_HDR_OFFL: Offload configuration
+ *	implementing 802.11 encap/decap for data frames changed.
  */
 enum ieee80211_conf_changed {
 	IEEE80211_CONF_CHANGE_SMPS		= BIT(1),
@@ -1279,6 +1286,7 @@ enum ieee80211_conf_changed {
 	IEEE80211_CONF_CHANGE_CHANNEL		= BIT(6),
 	IEEE80211_CONF_CHANGE_RETRY_LIMITS	= BIT(7),
 	IEEE80211_CONF_CHANGE_IDLE		= BIT(8),
+	IEEE80211_CONF_CHANGE_80211_HDR_OFFL	= BIT(9),
 };
 
 /**
@@ -1333,6 +1341,9 @@ enum ieee80211_smps_mode {
  *	configured for an HT channel.
  *	Note that this is only valid if channel contexts are not used,
  *	otherwise each channel context has the number of chains listed.
+ *
+ * @encap_decap_80211_offloaded: Whether 802.11 header encap/decap offload
+ *	is enabled
  */
 struct ieee80211_conf {
 	u32 flags;
@@ -1346,6 +1357,7 @@ struct ieee80211_conf {
 	struct cfg80211_chan_def chandef;
 	bool radar_enabled;
 	enum ieee80211_smps_mode smps_mode;
+	bool encap_decap_80211_offloaded;
 };
 
 /**
@@ -4178,6 +4190,25 @@ void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
 				 struct sk_buff *skb);
 
 /**
+ * ieee80211_tx_status_8023 - transmit status callback for 802.3 frame format
+ *
+ * Call this function for all transmitted data frames after their transmit
+ * completion. This callback should only be called for data frames which
+ * are are using driver's (or hardware's) offload capability of encap/decap
+ * 802.11 frames.
+ *
+ * This function may not be called in IRQ context. Calls to this function
+ * for a single hardware must be synchronized against each other.
+ *
+ * @hw: the hardware the frame was transmitted by
+ * @vif: the interface for which the frame was transmitted
+ * @skb: the frame that was transmitted, owned by mac80211 after this call
+ */
+void ieee80211_tx_status_8023(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif,
+			      struct sk_buff *skb);
+
+/**
  * ieee80211_report_low_ack - report non-responding station
  *
  * When operating in AP-mode, call this function to report a non-responding
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 47e99ab8..0e53873 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -107,6 +107,10 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
 		}
 	}
 
+	ieee80211_if_check_80211_hdr_offl(sdata,
+					  params ? params->use_4addr : false,
+					  true);
+
 	return 0;
 }
 
@@ -2116,6 +2120,10 @@ static int ieee80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	if (changed & WIPHY_PARAM_FRAG_THRESHOLD) {
 		ieee80211_check_fast_xmit_all(local);
 
+		if (!local->ops->set_frag_threshold &&
+		    local->data_80211_hdr_offloaded)
+			return -EINVAL;
+
 		err = drv_set_frag_threshold(local, wiphy->frag_threshold);
 
 		if (err) {
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f56d342..8d6abad 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1373,6 +1373,8 @@ struct ieee80211_local {
 	/* TDLS channel switch */
 	struct work_struct tdls_chsw_work;
 	struct sk_buff_head skb_queue_tdls_chsw;
+
+	bool data_80211_hdr_offloaded;
 };
 
 static inline struct ieee80211_sub_if_data *
@@ -1641,6 +1643,10 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		     struct vif_params *params);
 int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
 			     enum nl80211_iftype type);
+void ieee80211_if_check_80211_hdr_offl(struct ieee80211_sub_if_data *sdata,
+				       bool use_4addr, bool add);
+void ieee80211_if_config_80211_hdr_offl(struct ieee80211_local *local,
+					bool enable_80211_hdr_offload);
 void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata);
 void ieee80211_remove_interfaces(struct ieee80211_local *local);
 u32 ieee80211_idle_off(struct ieee80211_local *local);
@@ -1668,6 +1674,8 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 					 struct net_device *dev);
 netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 				       struct net_device *dev);
+netdev_tx_t ieee80211_subif_8023_start_xmit(struct sk_buff *skb,
+					    struct net_device *dev);
 void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 				  struct net_device *dev,
 				  u32 info_flags);
@@ -1822,6 +1830,10 @@ void __ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
 				 struct sk_buff *skb, int tid,
 				 enum nl80211_band band);
 
+int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
+			    struct sk_buff *skb,
+			    struct sta_info **sta_out);
+
 static inline void
 ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
 			  struct sk_buff *skb, int tid,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index b123a9e..d5f6649 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -698,6 +698,11 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 		rcu_assign_pointer(local->p2p_sdata, sdata);
 	}
 
+	if (local->open_count == 0 && local->data_80211_hdr_offloaded) {
+		local->hw.conf.encap_decap_80211_offloaded = true;
+		hw_reconf_flags |= IEEE80211_CONF_CHANGE_80211_HDR_OFFL;
+	}
+
 	/*
 	 * set_multicast_list will be invoked by the networking core
 	 * which will check whether any increments here were done in
@@ -1148,6 +1153,18 @@ static const struct net_device_ops ieee80211_dataif_ops = {
 	.ndo_get_stats64	= ieee80211_get_stats64,
 };
 
+static const struct net_device_ops ieee80211_dataif_8023_ops = {
+	.ndo_open		= ieee80211_open,
+	.ndo_stop		= ieee80211_stop,
+	.ndo_uninit		= ieee80211_uninit,
+	.ndo_start_xmit		= ieee80211_subif_8023_start_xmit,
+	.ndo_set_rx_mode	= ieee80211_set_multicast_list,
+	.ndo_change_mtu		= ieee80211_change_mtu,
+	.ndo_set_mac_address	= ieee80211_change_mac,
+	.ndo_select_queue	= ieee80211_netdev_select_queue,
+	.ndo_get_stats64	= ieee80211_get_stats64,
+};
+
 static u16 ieee80211_monitor_select_queue(struct net_device *dev,
 					  struct sk_buff *skb,
 					  void *accel_priv,
@@ -1703,6 +1720,132 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 	mutex_unlock(&local->iflist_mtx);
 }
 
+void ieee80211_if_config_80211_hdr_offl(struct ieee80211_local *local,
+					bool enable_80211_hdr_offl)
+{
+	struct ieee80211_sub_if_data *sdata;
+	unsigned long flags;
+	int n_acs = IEEE80211_NUM_ACS;
+	int ac;
+
+	ASSERT_RTNL();
+
+	if (!ieee80211_hw_check(&local->hw, SUPPORTS_80211_ENCAP_DECAP) ||
+	    !(ieee80211_hw_check(&local->hw, HAS_RATE_CONTROL)))
+		return;
+
+	if (local->hw.wiphy->frag_threshold != (u32)-1 &&
+	    !local->ops->set_frag_threshold)
+		return;
+
+	mutex_lock(&local->iflist_mtx);
+
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (!sdata->dev)
+			continue;
+
+		netif_tx_stop_all_queues(sdata->dev);
+
+		if (enable_80211_hdr_offl)
+			sdata->dev->netdev_ops = &ieee80211_dataif_8023_ops;
+		else
+			sdata->dev->netdev_ops = &ieee80211_dataif_ops;
+	}
+
+	mutex_unlock(&local->iflist_mtx);
+
+	local->data_80211_hdr_offloaded = enable_80211_hdr_offl;
+
+	if (local->started) {
+		if (enable_80211_hdr_offl)
+			local->hw.conf.encap_decap_80211_offloaded = true;
+		else
+			local->hw.conf.encap_decap_80211_offloaded = false;
+		ieee80211_hw_config(local,
+				    IEEE80211_CONF_CHANGE_80211_HDR_OFFL);
+	}
+
+	mutex_lock(&local->iflist_mtx);
+
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (!sdata->dev)
+			continue;
+
+		if (local->hw.queues < IEEE80211_NUM_ACS)
+			n_acs = 1;
+
+		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
+		if (sdata->vif.cab_queue == IEEE80211_INVAL_HW_QUEUE ||
+		    (local->queue_stop_reasons[sdata->vif.cab_queue] == 0 &&
+		     skb_queue_empty(&local->pending[sdata->vif.cab_queue]))) {
+			for (ac = 0; ac < n_acs; ac++) {
+				int ac_queue = sdata->vif.hw_queue[ac];
+
+				if (local->queue_stop_reasons[ac_queue] == 0 &&
+				    skb_queue_empty(&local->pending[ac_queue]))
+					netif_start_subqueue(sdata->dev, ac);
+			}
+		}
+		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+	}
+
+	mutex_unlock(&local->iflist_mtx);
+}
+
+void ieee80211_if_check_80211_hdr_offl(struct ieee80211_sub_if_data *sdata,
+				       bool use_4addr, bool add)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_sub_if_data *iface;
+	bool supported = false;
+	bool switch_to_80211 = false;
+	int iface_num = 0;
+	int ret;
+
+	ASSERT_RTNL();
+
+	/* TODO: Extend this function to switch data tx/rx mode upon
+	 * deletion of an interface.
+	 */
+	if (!add)
+		return;
+
+	if (!ieee80211_hw_check(&local->hw, SUPPORTS_80211_ENCAP_DECAP) ||
+	    !(ieee80211_hw_check(&local->hw, HAS_RATE_CONTROL)))
+		return;
+
+	if (local->hw.wiphy->frag_threshold != (u32)-1 &&
+	    !local->ops->set_frag_threshold)
+		return;
+
+	ret = drv_get_vif_80211_hdr_offload(local, sdata, use_4addr,
+					    &supported);
+	if (ret)
+		return;
+
+	mutex_lock(&local->iflist_mtx);
+	list_for_each_entry(iface, &local->interfaces, list) {
+		iface_num++;
+	}
+	mutex_unlock(&local->iflist_mtx);
+
+	if (WARN_ON(iface_num == 0))
+		return;
+
+	switch_to_80211 = local->data_80211_hdr_offloaded && !supported;
+
+	if (switch_to_80211) {
+		ieee80211_if_config_80211_hdr_offl(local, false);
+		return;
+	}
+
+	if (!supported || !sdata->dev)
+		return;
+
+	sdata->dev->netdev_ops = &ieee80211_dataif_8023_ops;
+	local->data_80211_hdr_offloaded = true;
+}
+
 int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		     unsigned char name_assign_type,
 		     struct wireless_dev **new_wdev, enum nl80211_iftype type,
@@ -1866,6 +2009,10 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 	list_add_tail_rcu(&sdata->list, &local->interfaces);
 	mutex_unlock(&local->iflist_mtx);
 
+	ieee80211_if_check_80211_hdr_offl(sdata,
+					  params ? params->use_4addr : false,
+					  true);
+
 	if (new_wdev)
 		*new_wdev = &sdata->wdev;
 
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index edd6f29..efcb1c4 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -208,13 +208,25 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 	case WLAN_CIPHER_SUITE_GCMP_256:
 		/* all of these we can do in software - if driver can */
 		if (ret == 1)
-			return 0;
+			goto check_8023_txrx;
 		if (ieee80211_hw_check(&key->local->hw, SW_CRYPTO_CONTROL))
 			return -EINVAL;
-		return 0;
+		goto check_8023_txrx;
 	default:
 		return -EINVAL;
 	}
+
+check_8023_txrx:
+	/* When sw crypto is enabled make sure data tx/rx happens
+	 * in 802.11 format.
+	 */
+	if (key->local->data_80211_hdr_offloaded) {
+		rtnl_lock();
+		ieee80211_if_config_80211_hdr_offl(key->local, false);
+		rtnl_unlock();
+	}
+
+	return 0;
 }
 
 static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 2095d7c..a1dc809 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -164,6 +164,9 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 
 	might_sleep();
 
+	if (!ieee80211_hw_check(&local->hw, SUPPORTS_80211_ENCAP_DECAP))
+		changed &= ~IEEE80211_CONF_CHANGE_80211_HDR_OFFL;
+
 	if (!local->use_chanctx)
 		changed |= ieee80211_hw_conf_chan(local);
 	else
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index c6d5c72..804fd53 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -506,12 +506,14 @@ static void ieee80211_report_used_skb(struct ieee80211_local *local,
 				      struct sk_buff *skb, bool dropped)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_hdr *hdr = (void *)skb->data;
+	struct ieee80211_hdr *hdr;
 	bool acked = info->flags & IEEE80211_TX_STAT_ACK;
 
 	if (dropped)
 		acked = false;
 
+	hdr = (void *)skb->data;
+
 	if (info->flags & IEEE80211_TX_INTFL_MLME_CONN_TX) {
 		struct ieee80211_sub_if_data *sdata;
 
@@ -945,6 +947,85 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 }
 EXPORT_SYMBOL(ieee80211_tx_status);
 
+void ieee80211_tx_status_8023(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif,
+			      struct sk_buff *skb)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct sta_info *sta;
+	int retry_count;
+	int rates_idx;
+	bool acked;
+
+	if (WARN_ON(!ieee80211_hw_check(hw, SUPPORTS_80211_ENCAP_DECAP)))
+		goto skip_stats_update;
+
+	sdata = vif_to_sdata(info->control.vif);
+
+	acked = !!(info->flags & IEEE80211_TX_STAT_ACK);
+	rates_idx = ieee80211_tx_get_rates(hw, info, &retry_count);
+
+	rcu_read_lock();
+
+	if (ieee80211_lookup_ra_sta(sdata, skb, &sta)) {
+		rcu_read_unlock();
+		goto counters_update;
+	}
+
+	if (!sta || IS_ERR(sta)) {
+		rcu_read_unlock();
+		goto counters_update;
+	}
+
+	if (!acked)
+		sta->status_stats.retry_failed++;
+
+	if (rates_idx != -1)
+		sta->tx_stats.last_rate = info->status.rates[rates_idx];
+
+	sta->status_stats.retry_count += retry_count;
+
+	if (ieee80211_hw_check(hw, REPORTS_TX_ACK_STATUS)) {
+		if (acked && vif->type == NL80211_IFTYPE_STATION)
+			ieee80211_sta_reset_conn_monitor(sdata);
+
+		sta->status_stats.last_ack = jiffies;
+		if (info->flags & IEEE80211_TX_STAT_ACK) {
+			if (sta->status_stats.lost_packets)
+				sta->status_stats.lost_packets = 0;
+
+			if (test_sta_flag(sta, WLAN_STA_TDLS_PEER_AUTH))
+				sta->status_stats.last_tdls_pkt_time = jiffies;
+		} else {
+			ieee80211_lost_packet(sta, info);
+		}
+	}
+
+	rcu_read_unlock();
+
+counters_update:
+	ieee80211_led_tx(local);
+
+	if (!(info->flags & IEEE80211_TX_STAT_ACK) &&
+	    !(info->flags & IEEE80211_TX_STAT_NOACK_TRANSMITTED))
+		goto skip_stats_update;
+
+	I802_DEBUG_INC(local->dot11TransmittedFrameCount);
+	if (is_multicast_ether_addr(skb->data))
+		I802_DEBUG_INC(local->dot11MulticastTransmittedFrameCount);
+	if (retry_count > 0)
+		I802_DEBUG_INC(local->dot11RetryCount);
+	if (retry_count > 1)
+		I802_DEBUG_INC(local->dot11MultipleRetryCount);
+
+skip_stats_update:
+	ieee80211_report_used_skb(local, skb, false);
+	dev_kfree_skb(skb);
+}
+EXPORT_SYMBOL(ieee80211_tx_status_8023);
+
 void ieee80211_report_low_ack(struct ieee80211_sta *pubsta, u32 num_packets)
 {
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 91461c4..d73cf79 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1485,6 +1485,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	struct sk_buff *skb = NULL;
 	struct fq *fq = &local->fq;
 	struct fq_tin *tin = &txqi->tin;
+	struct ieee80211_tx_info *info;
 
 	spin_lock_bh(&fq->lock);
 
@@ -1497,11 +1498,15 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 
 	ieee80211_set_skb_vif(skb, txqi);
 
+	info = IEEE80211_SKB_CB(skb);
+
+	if (info->control.no_80211_encap)
+		goto out;
+
 	hdr = (struct ieee80211_hdr *)skb->data;
 	if (txq->sta && ieee80211_is_data_qos(hdr->frame_control)) {
 		struct sta_info *sta = container_of(txq->sta, struct sta_info,
 						    sta);
-		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
 		hdr->seq_ctrl = ieee80211_tx_next_seq(sta, txq->tid);
 		if (test_bit(IEEE80211_TXQ_AMPDU, &txqi->flags))
@@ -2226,9 +2231,9 @@ static inline bool ieee80211_is_tdls_setup(struct sk_buff *skb)
 	       skb->data[14] == WLAN_TDLS_SNAP_RFTYPE;
 }
 
-static int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
-				   struct sk_buff *skb,
-				   struct sta_info **sta_out)
+int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
+			    struct sk_buff *skb,
+			    struct sta_info **sta_out)
 {
 	struct sta_info *sta;
 
@@ -3433,6 +3438,208 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
+static bool ieee80211_tx_8023(struct ieee80211_local *local,
+			      struct sk_buff *skb, int led_len,
+			      struct sta_info *sta,
+			      bool txpending)
+{
+	struct ieee80211_tx_control control = {};
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_vif *vif = info->control.vif;
+	struct ieee80211_sta *pubsta = NULL;
+	struct ieee80211_txq *txq = NULL;
+	struct fq *fq = &local->fq;
+	unsigned long flags;
+	int q = info->hw_queue;
+
+	if (sta)
+		pubsta = &sta->sta;
+
+	if (pubsta) {
+		u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
+
+		txq = pubsta->txq[tid];
+	} else if (vif) {
+		txq = vif->txq;
+	}
+
+	if (txq) {
+		struct txq_info *txqi = to_txq_info(txq);
+
+		info->control.vif = vif;
+
+		spin_lock_bh(&fq->lock);
+		ieee80211_txq_enqueue(local, txqi, skb);
+		spin_unlock_bh(&fq->lock);
+
+		drv_wake_tx_queue(local, txqi);
+
+		return true;
+	}
+
+	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
+
+	if (local->queue_stop_reasons[q] ||
+	    (!txpending && !skb_queue_empty(&local->pending[q]))) {
+		if (txpending)
+			skb_queue_head(&local->pending[q], skb);
+		else
+			skb_queue_tail(&local->pending[q], skb);
+
+		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+
+		return false;
+	}
+
+	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+
+	control.sta = pubsta;
+
+	drv_tx(local, &control, skb);
+
+	/* TODO: Update throughput led trigger with the number of tx bytes */
+
+	return true;
+}
+
+static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
+				struct net_device *dev, struct sta_info *sta,
+				struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ethhdr *ehdr = (struct ethhdr *)skb->data;
+	struct ieee80211_local *local = sdata->local;
+	bool authorized = false;
+	bool multicast;
+	bool tdls_peer;
+	u8 ra_addr[ETH_ALEN] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
+
+	if (IS_ERR(sta) || (sta && !sta->uploaded))
+		sta = NULL;
+
+	/* XXX: Add a generic helper for this */
+	if (sdata->vif.type == NL80211_IFTYPE_AP ||
+	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
+	    sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		ether_addr_copy(ra_addr, ehdr->h_dest);
+
+	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
+		tdls_peer = test_sta_flag(sta, WLAN_STA_TDLS_PEER);
+		if (tdls_peer)
+			memcpy(ra_addr, skb->data, ETH_ALEN);
+		else
+			memcpy(ra_addr, sdata->u.mgd.bssid, ETH_ALEN);
+	}
+
+	if (is_zero_ether_addr(ra_addr))
+		goto out_free;
+
+	multicast = is_multicast_ether_addr(ra_addr);
+
+	if (sta)
+		authorized = test_sta_flag(sta, WLAN_STA_AUTHORIZED);
+
+	/* XXX: Should we add new txrx stats for 802.3 to update stats
+	 * like if the frame is dropped due to unathourized port,
+	 * just like the ones available in tx_handlers?.
+	 */
+
+	if (!multicast && !authorized &&
+	    ((ehdr->h_proto != sdata->control_port_protocol) ||
+	    !ether_addr_equal(sdata->vif.addr, ehdr->h_source)))
+		goto out_free;
+
+	if (multicast && sdata->vif.type == NL80211_IFTYPE_AP &&
+	    !atomic_read(&sdata->u.ap.num_mcast_sta))
+		goto out_free;
+
+	if (unlikely(test_bit(SCAN_SW_SCANNING, &local->scanning)) &&
+	    test_bit(SDATA_STATE_OFFCHANNEL, &sdata->state))
+		goto out_free;
+
+	/* TODO: Handle frames requiring wifi tx status to be notified */
+	if (skb->sk && skb_shinfo(skb)->tx_flags & SKBTX_WIFI_STATUS)
+		goto out_free;
+
+	memset(info, 0, sizeof(*info));
+
+	if (unlikely(sdata->control_port_protocol == ehdr->h_proto)) {
+		if (sdata->control_port_no_encrypt)
+			info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
+		info->control.flags |= IEEE80211_TX_CTRL_PORT_CTRL_PROTO;
+	}
+
+	if (multicast)
+		info->flags |= IEEE80211_TX_CTL_NO_ACK;
+
+	info->hw_queue = sdata->vif.hw_queue[skb_get_queue_mapping(skb)];
+
+	ieee80211_tx_stats(dev, skb->len);
+
+	if (sta) {
+		sta->tx_stats.bytes[skb_get_queue_mapping(skb)] += skb->len;
+		sta->tx_stats.packets[skb_get_queue_mapping(skb)]++;
+	}
+
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+		sdata = container_of(sdata->bss,
+				     struct ieee80211_sub_if_data, u.ap);
+
+	info->control.no_80211_encap = true;
+
+	info->control.vif = &sdata->vif;
+
+	ieee80211_tx_8023(local, skb, skb->len, sta, false);
+
+	return;
+
+out_free:
+	kfree_skb(skb);
+}
+
+netdev_tx_t ieee80211_subif_8023_start_xmit(struct sk_buff *skb,
+					    struct net_device *dev)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
+
+	if (WARN_ON(unlikely(!local->data_80211_hdr_offloaded))) {
+		kfree_skb(skb);
+		return NETDEV_TX_OK;
+	}
+
+	if (unlikely(skb->len < ETH_HLEN)) {
+		kfree_skb(skb);
+		return NETDEV_TX_OK;
+	}
+
+	/* TODO: Extend it for Adhoc interface type */
+	if (WARN_ON(dev->ieee80211_ptr->use_4addr ||
+		    (sdata->vif.type != NL80211_IFTYPE_STATION &&
+		     sdata->vif.type != NL80211_IFTYPE_AP &&
+		     sdata->vif.type != NL80211_IFTYPE_AP_VLAN))) {
+		kfree_skb(skb);
+		return NETDEV_TX_OK;
+	}
+
+	rcu_read_lock();
+
+	if (ieee80211_lookup_ra_sta(sdata, skb, &sta))
+		goto out_free;
+
+	ieee80211_8023_xmit(sdata, dev, sta, skb);
+
+	goto out;
+
+ out_free:
+	kfree_skb(skb);
+ out:
+	rcu_read_unlock();
+
+	return NETDEV_TX_OK;
+}
+
 struct sk_buff *
 ieee80211_build_data_template(struct ieee80211_sub_if_data *sdata,
 			      struct sk_buff *skb, u32 info_flags)
@@ -3511,6 +3718,16 @@ static bool ieee80211_tx_pending_skb(struct ieee80211_local *local,
 		}
 		info->band = chanctx_conf->def.chan->band;
 		result = ieee80211_tx(sdata, NULL, skb, true);
+	} else if (info->control.no_80211_encap) {
+		if (ieee80211_lookup_ra_sta(sdata, skb, &sta)) {
+			dev_kfree_skb(skb);
+			return true;
+		}
+
+		if (IS_ERR(sta) || (sta && !sta->uploaded))
+			sta = NULL;
+
+		result = ieee80211_tx_8023(local, skb, skb->len, sta, true);
 	} else {
 		struct sk_buff_head skbs;
 
-- 
1.9.1
