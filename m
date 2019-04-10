Return-Path: <SRS0=qAu2=SM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66FDCC10F11
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 07:35:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AFCE2064A
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 07:35:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728634AbfDJHf3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Apr 2019 03:35:29 -0400
Received: from nbd.name ([46.4.11.11]:55552 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727546AbfDJHf3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Apr 2019 03:35:29 -0400
Received: from p548c87d0.dip0.t-ipconnect.de ([84.140.135.208] helo=bertha.fritz.box)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1hE7lV-00082V-83; Wed, 10 Apr 2019 09:35:25 +0200
From:   John Crispin <john@phrozen.org>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Srini Kode <skode@qti.qualcomm.com>,
        Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>,
        John Crispin <john@phrozen.org>
Subject: [RFC V4 1/2] mac80211: add hw 80211 encapsulation offloading support
Date:   Wed, 10 Apr 2019 09:35:13 +0200
Message-Id: <20190410073514.12794-2-john@phrozen.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190410073514.12794-1-john@phrozen.org>
References: <20190410073514.12794-1-john@phrozen.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>

This patch adds a new transmit path for hardware that supports 802.11
encapsulation offloading. In those cases 802.3a frames get passed
directly to the driver allowing to hardware to handle the encapsulation.

Certain features wont work and the patch masks these out.
* monitor interfaces are not supported if any of the vif is in encap mode.
* amsdu/non-linear frames wont work in encap offloading mode.
* TKIP countermeasures cannot be triggered and hence those keys are not
  accepted.

The patch defines a secondary netdev_ops struct that the device is assigned
to the device if 802.11 encap support is available and enabled. The driver
needs to enable the support on a per vif basis if it finds that all
pre-reqs are meet.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Signed-off-by: John Crispin <john@phrozen.org>
---
 include/net/mac80211.h     |  25 ++++++
 net/mac80211/cfg.c         |   3 +
 net/mac80211/debugfs.c     |   1 +
 net/mac80211/ieee80211_i.h |  10 +++
 net/mac80211/iface.c       |  72 +++++++++++++++++
 net/mac80211/key.c         |   7 ++
 net/mac80211/main.c        |  10 ++-
 net/mac80211/status.c      |  79 +++++++++++++++++++
 net/mac80211/tx.c          | 189 +++++++++++++++++++++++++++++++++++++++++++--
 9 files changed, 387 insertions(+), 9 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index ac2ed8ec662b..b9e77e295361 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -816,6 +816,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTRL_RATE_INJECT		= BIT(2),
 	IEEE80211_TX_CTRL_AMSDU			= BIT(3),
 	IEEE80211_TX_CTRL_FAST_XMIT		= BIT(4),
+	IEEE80211_TX_CTRL_HW_80211_ENCAP	= BIT(5),
 };
 
 /*
@@ -2243,6 +2244,9 @@ struct ieee80211_txq {
  * @IEEE80211_HW_SUPPORTS_ONLY_HE_MULTI_BSSID: Hardware supports multi BSSID
  *	only for HE APs. Applies if @IEEE80211_HW_SUPPORTS_MULTI_BSSID is set.
  *
+ * @IEEE80211_HW_SUPPORTS_80211_ENCAP: Hardware/driver supports 802.11
+ *	encap for data frames.
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -2294,6 +2298,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_TX_STATUS_NO_AMPDU_LEN,
 	IEEE80211_HW_SUPPORTS_MULTI_BSSID,
 	IEEE80211_HW_SUPPORTS_ONLY_HE_MULTI_BSSID,
+	IEEE80211_HW_SUPPORTS_80211_ENCAP,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
@@ -4587,6 +4592,25 @@ void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
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
+			       struct ieee80211_vif *vif,
+			       struct sk_buff *skb);
+
+/**
  * ieee80211_report_low_ack - report non-responding station
  *
  * When operating in AP-mode, call this function to report a non-responding
@@ -6359,4 +6383,5 @@ void ieee80211_nan_func_match(struct ieee80211_vif *vif,
 			      struct cfg80211_nan_match_params *match,
 			      gfp_t gfp);
 
+int ieee80211_set_hw_80211_encap(struct ieee80211_vif *vif, bool enable);
 #endif /* MAC80211_H */
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 0a1f6e0a0548..029fb4a672de 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2379,6 +2379,9 @@ static int ieee80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	if (changed & WIPHY_PARAM_FRAG_THRESHOLD) {
 		ieee80211_check_fast_xmit_all(local);
 
+		if (ieee80211_is_hw_80211_encap(local))
+			return -EINVAL;
+
 		err = drv_set_frag_threshold(local, wiphy->frag_threshold);
 
 		if (err) {
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 2d43bc127043..a4df6bca192f 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -221,6 +221,7 @@ static const char *hw_flag_names[] = {
 	FLAG(TX_STATUS_NO_AMPDU_LEN),
 	FLAG(SUPPORTS_MULTI_BSSID),
 	FLAG(SUPPORTS_ONLY_HE_MULTI_BSSID),
+	FLAG(SUPPORTS_80211_ENCAP),
 #undef FLAG
 };
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5d837d10fef7..f14da8d7a21b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -987,6 +987,8 @@ struct ieee80211_sub_if_data {
 	} debugfs;
 #endif
 
+	bool hw_80211_encap;
+
 	/* must be last, dynamically sized area in this! */
 	struct ieee80211_vif vif;
 };
@@ -1733,6 +1735,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		     struct vif_params *params);
 int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
 			     enum nl80211_iftype type);
+bool ieee80211_is_hw_80211_encap(struct ieee80211_local *local);
 void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata);
 void ieee80211_remove_interfaces(struct ieee80211_local *local);
 u32 ieee80211_idle_off(struct ieee80211_local *local);
@@ -1760,6 +1763,8 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 					 struct net_device *dev);
 netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 				       struct net_device *dev);
+netdev_tx_t ieee80211_subif_start_xmit_8023(struct sk_buff *skb,
+					    struct net_device *dev);
 void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 				  struct net_device *dev,
 				  u32 info_flags);
@@ -1935,6 +1940,11 @@ void __ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
 				 struct sk_buff *skb, int tid,
 				 enum nl80211_band band, u32 txdata_flags);
 
+/* sta_out needs to be checked for ERR_PTR() before using */
+int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
+			    struct sk_buff *skb,
+			    struct sta_info **sta_out);
+
 static inline void
 ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
 			  struct sk_buff *skb, int tid,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 4a6ff1482a9f..aa8f967f2b27 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1177,6 +1177,77 @@ static const struct net_device_ops ieee80211_dataif_ops = {
 	.ndo_get_stats64	= ieee80211_get_stats64,
 };
 
+static const struct net_device_ops ieee80211_dataif_8023_ops = {
+	.ndo_open		= ieee80211_open,
+	.ndo_stop		= ieee80211_stop,
+	.ndo_uninit		= ieee80211_uninit,
+	.ndo_start_xmit		= ieee80211_subif_start_xmit_8023,
+	.ndo_set_rx_mode	= ieee80211_set_multicast_list,
+	.ndo_set_mac_address	= ieee80211_change_mac,
+	.ndo_select_queue	= ieee80211_netdev_select_queue,
+	.ndo_get_stats64	= ieee80211_get_stats64,
+};
+
+int ieee80211_set_hw_80211_encap(struct ieee80211_vif *vif, bool enable)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct ieee80211_local *local = sdata->local;
+
+	if (enable == sdata->hw_80211_encap)
+		return enable;
+
+	if (!sdata->dev)
+		return 0;
+
+	if (!ieee80211_hw_check(&local->hw, SUPPORTS_80211_ENCAP))
+		enable = 0;
+
+	switch (vif->type) {
+	case NL80211_IFTYPE_STATION:
+		if (sdata->u.mgd.use_4addr)
+			enable = 0;
+		break;
+	case NL80211_IFTYPE_AP_VLAN:
+		if (sdata->wdev.use_4addr)
+			enable = 0;
+		break;
+	default:
+		break;
+	}
+
+	if (!ieee80211_hw_check(&local->hw, SUPPORTS_TX_FRAG) &&
+	    (local->hw.wiphy->frag_threshold != (u32)-1))
+		enable = 0;
+
+	if (enable) {
+		sdata->dev->netdev_ops = &ieee80211_dataif_8023_ops;
+		sdata->hw_80211_encap = true;
+	} else {
+		sdata->dev->netdev_ops = &ieee80211_dataif_ops;
+		sdata->hw_80211_encap = false;
+	}
+
+	return enable;
+}
+EXPORT_SYMBOL(ieee80211_set_hw_80211_encap);
+
+bool ieee80211_is_hw_80211_encap(struct ieee80211_local *local)
+{
+	struct ieee80211_sub_if_data *sdata;
+	bool offloaded = false;
+
+	mutex_lock(&local->iflist_mtx);
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (sdata->hw_80211_encap) {
+			offloaded = true;
+			break;
+		}
+	}
+	mutex_unlock(&local->iflist_mtx);
+
+	return offloaded;
+}
+
 static u16 ieee80211_monitor_select_queue(struct net_device *dev,
 					  struct sk_buff *skb,
 					  struct net_device *sb_dev,
@@ -1409,6 +1480,7 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	sdata->vif.bss_conf.idle = true;
 
 	sdata->noack_map = 0;
+	sdata->hw_80211_encap = false;
 
 	/* only monitor/p2p-device differ */
 	if (sdata->dev) {
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 4700718e010f..b43888556901 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -171,6 +171,10 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 			goto out_unsupported;
 	}
 
+	/* TKIP countermeasures wont work on encap offload mode */
+	if (key->conf.cipher == WLAN_CIPHER_SUITE_TKIP)
+		ieee80211_set_hw_80211_encap(&sdata->vif, 0);
+
 	ret = drv_set_key(key->local, SET_KEY, sdata,
 			  sta ? &sta->sta : NULL, &key->conf);
 
@@ -197,6 +201,9 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 			  key->conf.keyidx,
 			  sta ? sta->sta.addr : bcast_addr, ret);
 
+	if (sdata->hw_80211_encap)
+		return -EINVAL;
+
  out_unsupported:
 	switch (key->conf.cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 800e67615e2a..a49bcec3891e 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1000,9 +1000,13 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		hw->wiphy->software_iftypes |= BIT(NL80211_IFTYPE_AP_VLAN);
 	}
 
-	/* mac80211 always supports monitor */
-	hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_MONITOR);
-	hw->wiphy->software_iftypes |= BIT(NL80211_IFTYPE_MONITOR);
+	if (ieee80211_hw_check(hw, SUPPORTS_80211_ENCAP)) {
+		/* mac80211 always supports monitor unless we do 802.11
+		 * encapsulation offloading.
+		 */
+		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_MONITOR);
+		hw->wiphy->software_iftypes |= BIT(NL80211_IFTYPE_MONITOR);
+	}
 
 	/* mac80211 doesn't support more than one IBSS interface right now */
 	for (i = 0; i < hw->wiphy->n_iface_combinations; i++) {
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 5b9952b1caf3..8feafaab88a4 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -1019,6 +1019,85 @@ void ieee80211_tx_rate_update(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_tx_rate_update);
 
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
+	if (WARN_ON(!ieee80211_hw_check(hw, SUPPORTS_80211_ENCAP)))
+		goto skip_stats_update;
+
+	sdata = vif_to_sdata(vif);
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
index 8a49a74c0a37..fbd4b5267e04 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1253,7 +1253,8 @@ static struct txq_info *ieee80211_get_txq(struct ieee80211_local *local,
 	    (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE))
 		return NULL;
 
-	if (unlikely(!ieee80211_is_data_present(hdr->frame_control))) {
+	if (!(info->control.flags & IEEE80211_TX_CTRL_HW_80211_ENCAP) &&
+	    unlikely(!ieee80211_is_data_present(hdr->frame_control))) {
 		if ((!ieee80211_is_mgmt(hdr->frame_control) ||
 		     ieee80211_is_bufferable_mmpdu(hdr->frame_control) ||
 		     vif->type == NL80211_IFTYPE_STATION) &&
@@ -2357,9 +2358,9 @@ static inline bool ieee80211_is_tdls_setup(struct sk_buff *skb)
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
 
@@ -2855,7 +2856,9 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	__le16 fc;
 
-	if (!ieee80211_hw_check(&local->hw, SUPPORT_FAST_XMIT))
+	/* check for driver support and ieee80211 encap offload */
+	if (!ieee80211_hw_check(&local->hw, SUPPORT_FAST_XMIT) ||
+	    sdata->hw_80211_encap)
 		return;
 
 	/* Locking here protects both the pointer itself, and against concurrent
@@ -3573,6 +3576,9 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 		goto begin;
 	}
 
+	if (info->control.flags & IEEE80211_TX_CTRL_HW_80211_ENCAP)
+		goto encap_out;
+
 	if (test_bit(IEEE80211_TXQ_AMPDU, &txqi->flags))
 		info->flags |= IEEE80211_TX_CTL_AMPDU;
 	else
@@ -3634,8 +3640,8 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 		break;
 	}
 
+encap_out:
 	IEEE80211_SKB_CB(skb)->control.vif = vif;
-
 out:
 	spin_unlock_bh(&fq->lock);
 
@@ -4003,6 +4009,167 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
+static bool ieee80211_tx_8023(struct ieee80211_sub_if_data *sdata,
+			      struct sk_buff *skb, int led_len,
+			      struct sta_info *sta,
+			      bool txpending)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_tx_control control = {};
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_sta *pubsta = NULL;
+	unsigned long flags;
+	int q = info->hw_queue;
+
+	if (ieee80211_queue_skb(local, sdata, sta, skb))
+		return true;
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
+	if (sta && sta->uploaded)
+		pubsta = &sta->sta;
+
+	control.sta = pubsta;
+
+	drv_tx(local, &control, skb);
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
+	unsigned char *ra = NULL;
+
+	if (IS_ERR(sta) || (sta && !sta->uploaded))
+		sta = NULL;
+
+	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
+		tdls_peer = test_sta_flag(sta, WLAN_STA_TDLS_PEER);
+		if (tdls_peer)
+			ra = skb->data;
+		else
+			ra = sdata->u.mgd.bssid;
+	} else {
+		ra = ehdr->h_dest;
+	}
+
+	if (!ra)
+		goto out_free;
+	multicast = is_multicast_ether_addr(ra);
+
+	if (sta)
+		authorized = test_sta_flag(sta, WLAN_STA_AUTHORIZED);
+
+	if (!multicast && !authorized &&
+	    ((ehdr->h_proto != sdata->control_port_protocol) ||
+	     !ether_addr_equal(sdata->vif.addr, ehdr->h_source)))
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
+	info->control.flags |= IEEE80211_TX_CTRL_HW_80211_ENCAP;
+	info->control.vif = &sdata->vif;
+
+	ieee80211_tx_8023(sdata, skb, skb->len, sta, false);
+
+	return;
+
+out_free:
+	kfree_skb(skb);
+}
+
+netdev_tx_t ieee80211_subif_start_xmit_8023(struct sk_buff *skb,
+					    struct net_device *dev)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct sta_info *sta;
+
+	if (WARN_ON(unlikely(!sdata->hw_80211_encap))) {
+		kfree_skb(skb);
+		return NETDEV_TX_OK;
+	}
+
+	if (unlikely(skb->len < ETH_HLEN)) {
+		kfree_skb(skb);
+		return NETDEV_TX_OK;
+	}
+
+	if (WARN_ON(dev->ieee80211_ptr->use_4addr)) {
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
+out_free:
+	kfree_skb(skb);
+out:
+	rcu_read_unlock();
+
+	return NETDEV_TX_OK;
+}
+
 struct sk_buff *
 ieee80211_build_data_template(struct ieee80211_sub_if_data *sdata,
 			      struct sk_buff *skb, u32 info_flags)
@@ -4081,6 +4248,16 @@ static bool ieee80211_tx_pending_skb(struct ieee80211_local *local,
 		}
 		info->band = chanctx_conf->def.chan->band;
 		result = ieee80211_tx(sdata, NULL, skb, true, 0);
+	} else if (info->control.flags & IEEE80211_TX_CTRL_HW_80211_ENCAP) {
+		if (ieee80211_lookup_ra_sta(sdata, skb, &sta)) {
+			dev_kfree_skb(skb);
+			return true;
+		}
+
+		if (IS_ERR(sta) || (sta && !sta->uploaded))
+			sta = NULL;
+
+		result = ieee80211_tx_8023(sdata, skb, skb->len, sta, true);
 	} else {
 		struct sk_buff_head skbs;
 
-- 
2.11.0

