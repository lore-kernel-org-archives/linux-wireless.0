Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49413 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932123AbaJVHkB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 03:40:01 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: add WMM admission control support
Date: Wed, 22 Oct 2014 09:39:55 +0200
Message-Id: <1413963595-22349-1-git-send-email-johannes@sipsolutions.net> (sfid-20141022_094008_952134_35DE7A9C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Use the currently existing APIs between mac80211 and the low
level driver to implement WMM admission control.

The low level driver needs to report the media time used by
each transmitted packet in ieee80211_tx_status. Based on that
information, mac80211 will modify the QoS parameters of the
admission controlled Access Category when the limit is
reached. Once the original QoS parameters can be restored,
mac80211 will do so.

One issue with this approach is that management frames will
also erroneously be downgraded, but the upside is that the
implementation is simple. In the future, it can be extended
to driver- or device-based implementations that are better.

Change-Id: I72590d91825401455362b8ccf74fb85cc77a78e8
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-on: https://gerrit.rds.intel.com/45190
Tested-by: IWL Jenkins
---
 include/net/mac80211.h     |   3 +-
 net/mac80211/agg-tx.c      |   5 --
 net/mac80211/cfg.c         |  73 +++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |  38 +++++++++++-
 net/mac80211/mlme.c        | 142 +++++++++++++++++++++++++++++++++++++++++++--
 net/mac80211/status.c      |   3 +-
 net/mac80211/wme.c         |  29 ++++++---
 net/mac80211/wme.h         |   2 -
 8 files changed, 272 insertions(+), 23 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9bb2fc73aeaa..9dc5e7606322 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -739,7 +739,8 @@ struct ieee80211_tx_info {
 			u8 ampdu_ack_len;
 			u8 ampdu_len;
 			u8 antenna;
-			void *status_driver_data[21 / sizeof(void *)];
+			u16 tx_time;
+			void *status_driver_data[19 / sizeof(void *)];
 		} status;
 		struct {
 			struct ieee80211_tx_rate driver_rates[
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index d6986f3aa5c4..9242c60048cf 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -149,11 +149,6 @@ void ieee80211_assign_tid_tx(struct sta_info *sta, int tid,
 	rcu_assign_pointer(sta->ampdu_mlme.tid_tx[tid], tid_tx);
 }
 
-static inline int ieee80211_ac_from_tid(int tid)
-{
-	return ieee802_1d_to_ac[tid & 7];
-}
-
 /*
  * When multiple aggregation sessions on multiple stations
  * are being created/destroyed simultaneously, we need to
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 64deb9aa0f81..d6b01ad2f7d7 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -20,6 +20,7 @@
 #include "cfg.h"
 #include "rate.h"
 #include "mesh.h"
+#include "wme.h"
 
 static struct wireless_dev *ieee80211_add_iface(struct wiphy *wiphy,
 						const char *name,
@@ -3585,6 +3586,76 @@ static int ieee80211_set_ap_chanwidth(struct wiphy *wiphy,
 	return ret;
 }
 
+static int ieee80211_add_tx_ts(struct wiphy *wiphy, struct net_device *dev,
+			       u8 tsid, const u8 *peer, u8 up,
+			       u16 admitted_time)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	int ac = ieee802_1d_to_ac[up];
+
+	if (sdata->vif.type != NL80211_IFTYPE_STATION)
+		return -EOPNOTSUPP;
+
+	if (!(sdata->wmm_acm & BIT(up)))
+		return -EINVAL;
+
+	if (ifmgd->tx_tspec[ac].admitted_time)
+		return -EBUSY;
+
+	if (admitted_time) {
+		ifmgd->tx_tspec[ac].admitted_time = 32 * admitted_time;
+		ifmgd->tx_tspec[ac].tsid = tsid;
+		ifmgd->tx_tspec[ac].up = up;
+	}
+
+	return 0;
+}
+
+static int ieee80211_del_tx_ts(struct wiphy *wiphy, struct net_device *dev,
+			       u8 tsid, const u8 *peer)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	int ac;
+
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+		struct ieee80211_sta_tx_tspec *tx_tspec = &ifmgd->tx_tspec[ac];
+
+		/* skip unused entries */
+		if (!tx_tspec->admitted_time)
+			continue;
+
+		if (tx_tspec->tsid != tsid)
+			continue;
+
+		/* due to this new packets will be reassigned to non-ACM ACs */
+		tx_tspec->up = -1;
+
+		/* Make sure that all packets have been sent to avoid to
+		 * restore the QoS params on packets that are still on the
+		 * queues.
+		 */
+		synchronize_net();
+		ieee80211_flush_queues(local, sdata);
+
+		/* restore the normal QoS parameters
+		 * (unconditionally to avoid races)
+		 */
+		tx_tspec->action = TX_TSPEC_ACTION_STOP_DOWNGRADE;
+		tx_tspec->downgraded = false;
+		ieee80211_sta_handle_tspec_ac_params(sdata);
+
+		/* finally clear all the data */
+		memset(tx_tspec, 0, sizeof(*tx_tspec));
+
+		return 0;
+	}
+
+	return -ENOENT;
+}
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -3663,4 +3734,6 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.channel_switch = ieee80211_channel_switch,
 	.set_qos_map = ieee80211_set_qos_map,
 	.set_ap_chanwidth = ieee80211_set_ap_chanwidth,
+	.add_tx_ts = ieee80211_add_tx_ts,
+	.del_tx_ts = ieee80211_del_tx_ts,
 };
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 78d6121eb372..60063be057d0 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -399,6 +399,24 @@ struct ieee80211_mgd_assoc_data {
 	u8 ie[];
 };
 
+struct ieee80211_sta_tx_tspec {
+	/* timestamp of the first packet in the time slice */
+	unsigned long time_slice_start;
+
+	u32 admitted_time; /* in usecs, unlike over the air */
+	u8 tsid;
+	s8 up; /* signed to be able to invalidate with -1 during teardown */
+
+	/* consumed TX time in microseconds in the time slice */
+	u32 consumed_tx_time;
+	enum {
+		TX_TSPEC_ACTION_NONE = 0,
+		TX_TSPEC_ACTION_DOWNGRADE,
+		TX_TSPEC_ACTION_STOP_DOWNGRADE,
+	} action;
+	bool downgraded;
+};
+
 struct ieee80211_if_managed {
 	struct timer_list timer;
 	struct timer_list conn_mon_timer;
@@ -509,6 +527,16 @@ struct ieee80211_if_managed {
 
 	u8 tdls_peer[ETH_ALEN] __aligned(2);
 	struct delayed_work tdls_peer_del_work;
+
+	/* WMM-AC TSPEC support */
+	struct ieee80211_sta_tx_tspec tx_tspec[IEEE80211_NUM_ACS];
+	/* Use a separate work struct so that we can do something here
+	 * while the sdata->work is flushing the queues, for example.
+	 * otherwise, in scenarios where we hardly get any traffic out
+	 * on the BE queue, but there's a lot of VO traffic, we might
+	 * get stuck in a downgraded situation and flush takes forever.
+	 */
+	struct delayed_work tx_tspec_wk;
 };
 
 struct ieee80211_if_ibss {
@@ -1459,6 +1487,7 @@ void ieee80211_mgd_conn_tx_status(struct ieee80211_sub_if_data *sdata,
 				  __le16 fc, bool acked);
 void ieee80211_mgd_quiesce(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata);
+void ieee80211_sta_handle_tspec_ac_params(struct ieee80211_sub_if_data *sdata);
 
 /* IBSS code */
 void ieee80211_ibss_notify_scan_completed(struct ieee80211_local *local);
@@ -1763,6 +1792,13 @@ static inline bool ieee80211_rx_reorder_ready(struct sk_buff_head *frames)
 	return true;
 }
 
+extern const int ieee802_1d_to_ac[8];
+
+static inline int ieee80211_ac_from_tid(int tid)
+{
+	return ieee802_1d_to_ac[tid & 7];
+}
+
 void ieee80211_dynamic_ps_enable_work(struct work_struct *work);
 void ieee80211_dynamic_ps_disable_work(struct work_struct *work);
 void ieee80211_dynamic_ps_timer(unsigned long data);
@@ -1772,7 +1808,7 @@ void ieee80211_send_nullfunc(struct ieee80211_local *local,
 void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
 			     struct ieee80211_hdr *hdr);
 void ieee80211_sta_tx_notify(struct ieee80211_sub_if_data *sdata,
-			     struct ieee80211_hdr *hdr, bool ack);
+			     struct ieee80211_hdr *hdr, bool ack, u16 tx_time);
 
 void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
 				     unsigned long queues,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index fb6561509caf..4d9b4d165ce8 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1606,6 +1606,95 @@ void ieee80211_dfs_cac_timer_work(struct work_struct *work)
 	mutex_unlock(&sdata->local->mtx);
 }
 
+static bool
+__ieee80211_sta_handle_tspec_ac_params(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	bool ret;
+	int ac;
+
+	if (local->hw.queues < IEEE80211_NUM_ACS)
+		return false;
+
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+		struct ieee80211_sta_tx_tspec *tx_tspec = &ifmgd->tx_tspec[ac];
+		int non_acm_ac;
+		unsigned long now = jiffies;
+
+		if (tx_tspec->action == TX_TSPEC_ACTION_NONE &&
+		    tx_tspec->admitted_time &&
+		    time_after(now, tx_tspec->time_slice_start + HZ)) {
+			tx_tspec->consumed_tx_time = 0;
+			tx_tspec->time_slice_start = now;
+
+			if (tx_tspec->downgraded)
+				tx_tspec->action =
+					TX_TSPEC_ACTION_STOP_DOWNGRADE;
+		}
+
+		switch (tx_tspec->action) {
+		case TX_TSPEC_ACTION_STOP_DOWNGRADE:
+			/* take the original parameters */
+			if (drv_conf_tx(local, sdata, ac, &sdata->tx_conf[ac]))
+				sdata_err(sdata,
+					  "failed to set TX queue parameters for queue %d\n",
+					  ac);
+			tx_tspec->action = TX_TSPEC_ACTION_NONE;
+			tx_tspec->downgraded = false;
+			ret = true;
+			break;
+		case TX_TSPEC_ACTION_DOWNGRADE:
+			if (time_after(now, tx_tspec->time_slice_start + HZ)) {
+				tx_tspec->action = TX_TSPEC_ACTION_NONE;
+				ret = true;
+				break;
+			}
+			/* downgrade next lower non-ACM AC */
+			for (non_acm_ac = ac + 1;
+			     non_acm_ac < IEEE80211_NUM_ACS;
+			     non_acm_ac++)
+				if (!(sdata->wmm_acm & BIT(7 - 2 * non_acm_ac)))
+					break;
+			/* The loop will result in using BK even if it requires
+			 * admission control, such configuration makes no sense
+			 * and we have to transmit somehow - the AC selection
+			 * does the same thing.
+			 */
+			if (drv_conf_tx(local, sdata, ac,
+					&sdata->tx_conf[non_acm_ac]))
+				sdata_err(sdata,
+					  "failed to set TX queue parameters for queue %d\n",
+					  ac);
+			tx_tspec->action = TX_TSPEC_ACTION_NONE;
+			ret = true;
+			schedule_delayed_work(&ifmgd->tx_tspec_wk,
+				tx_tspec->time_slice_start + HZ - now + 1);
+			break;
+		case TX_TSPEC_ACTION_NONE:
+			/* nothing now */
+			break;
+		}
+	}
+
+	return ret;
+}
+
+void ieee80211_sta_handle_tspec_ac_params(struct ieee80211_sub_if_data *sdata)
+{
+	if (__ieee80211_sta_handle_tspec_ac_params(sdata))
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_QOS);
+}
+
+static void ieee80211_sta_handle_tspec_ac_params_wk(struct work_struct *work)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	sdata = container_of(work, struct ieee80211_sub_if_data,
+			     u.mgd.tx_tspec_wk.work);
+	ieee80211_sta_handle_tspec_ac_params(sdata);
+}
+
 /* MLME */
 static bool ieee80211_sta_wmm_params(struct ieee80211_local *local,
 				     struct ieee80211_sub_if_data *sdata,
@@ -1690,12 +1779,14 @@ static bool ieee80211_sta_wmm_params(struct ieee80211_local *local,
 		params.uapsd = uapsd;
 
 		mlme_dbg(sdata,
-			 "WMM queue=%d aci=%d acm=%d aifs=%d cWmin=%d cWmax=%d txop=%d uapsd=%d\n",
+			 "WMM queue=%d aci=%d acm=%d aifs=%d cWmin=%d cWmax=%d txop=%d uapsd=%d, downgraded=%d\n",
 			 queue, aci, acm,
 			 params.aifs, params.cw_min, params.cw_max,
-			 params.txop, params.uapsd);
+			 params.txop, params.uapsd,
+			 ifmgd->tx_tspec[queue].downgraded);
 		sdata->tx_conf[queue] = params;
-		if (drv_conf_tx(local, sdata, queue, &params))
+		if (!ifmgd->tx_tspec[queue].downgraded &&
+		    drv_conf_tx(local, sdata, queue, &params))
 			sdata_err(sdata,
 				  "failed to set TX queue parameters for queue %d\n",
 				  queue);
@@ -1958,6 +2049,10 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	}
 	mutex_unlock(&local->mtx);
 
+	/* existing TX TSPEC sessions no longer exist */
+	memset(ifmgd->tx_tspec, 0, sizeof(ifmgd->tx_tspec));
+	cancel_delayed_work_sync(&ifmgd->tx_tspec_wk);
+
 	sdata->encrypt_headroom = IEEE80211_ENCRYPT_HEADROOM;
 }
 
@@ -2010,9 +2105,46 @@ out:
 	mutex_unlock(&local->mtx);
 }
 
+static void ieee80211_sta_tx_wmm_ac_notify(struct ieee80211_sub_if_data *sdata,
+					   struct ieee80211_hdr *hdr,
+					   u16 tx_time)
+{
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	u16 tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
+	int ac = ieee80211_ac_from_tid(tid);
+	struct ieee80211_sta_tx_tspec *tx_tspec = &ifmgd->tx_tspec[ac];
+	unsigned long now = jiffies;
+
+	if (likely(!tx_tspec->admitted_time))
+		return;
+
+	if (time_after(now, tx_tspec->time_slice_start + HZ)) {
+		tx_tspec->consumed_tx_time = 0;
+		tx_tspec->time_slice_start = now;
+
+		if (tx_tspec->downgraded) {
+			tx_tspec->action = TX_TSPEC_ACTION_STOP_DOWNGRADE;
+			schedule_delayed_work(&ifmgd->tx_tspec_wk, 0);
+		}
+	}
+
+	if (tx_tspec->downgraded)
+		return;
+
+	tx_tspec->consumed_tx_time += tx_time;
+
+	if (tx_tspec->consumed_tx_time >= tx_tspec->admitted_time) {
+		tx_tspec->downgraded = true;
+		tx_tspec->action = TX_TSPEC_ACTION_DOWNGRADE;
+		schedule_delayed_work(&ifmgd->tx_tspec_wk, 0);
+	}
+}
+
 void ieee80211_sta_tx_notify(struct ieee80211_sub_if_data *sdata,
-			     struct ieee80211_hdr *hdr, bool ack)
+			     struct ieee80211_hdr *hdr, bool ack, u16 tx_time)
 {
+	ieee80211_sta_tx_wmm_ac_notify(sdata, hdr, tx_time);
+
 	if (!ieee80211_is_data(hdr->frame_control))
 	    return;
 
@@ -3834,6 +3966,8 @@ void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 		    (unsigned long) sdata);
 	setup_timer(&ifmgd->chswitch_timer, ieee80211_chswitch_timer,
 		    (unsigned long) sdata);
+	INIT_DELAYED_WORK(&ifmgd->tx_tspec_wk,
+			  ieee80211_sta_handle_tspec_ac_params_wk);
 
 	ifmgd->flags = 0;
 	ifmgd->powersave = sdata->wdev.ps;
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 89290e33dafe..9612d89fad56 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -704,7 +704,8 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 		if ((sta->sdata->vif.type == NL80211_IFTYPE_STATION) &&
 		    (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS))
-			ieee80211_sta_tx_notify(sta->sdata, (void *) skb->data, acked);
+			ieee80211_sta_tx_notify(sta->sdata, (void *) skb->data,
+						acked, info->status.tx_time);
 
 		if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) {
 			if (info->flags & IEEE80211_TX_STAT_ACK) {
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 3b873989992c..d3c5672d775f 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -54,10 +54,18 @@ static int wme_downgrade_ac(struct sk_buff *skb)
 }
 
 static u16 ieee80211_downgrade_queue(struct ieee80211_sub_if_data *sdata,
-				     struct sk_buff *skb)
+				     struct sta_info *sta, struct sk_buff *skb)
 {
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+
 	/* in case we are a client verify acm is not set for this ac */
-	while (unlikely(sdata->wmm_acm & BIT(skb->priority))) {
+	while (sdata->wmm_acm & BIT(skb->priority)) {
+		int ac = ieee802_1d_to_ac[skb->priority];
+
+		if (ifmgd->tx_tspec[ac].admitted_time &&
+		    skb->priority == ifmgd->tx_tspec[ac].up)
+			return ac;
+
 		if (wme_downgrade_ac(skb)) {
 			/*
 			 * This should not really happen. The AP has marked all
@@ -96,7 +104,7 @@ u16 ieee80211_select_queue_80211(struct ieee80211_sub_if_data *sdata,
 	p = ieee80211_get_qos_ctl(hdr);
 	skb->priority = *p & IEEE80211_QOS_CTL_TAG1D_MASK;
 
-	return ieee80211_downgrade_queue(sdata, skb);
+	return ieee80211_downgrade_queue(sdata, NULL, skb);
 }
 
 /* Indicate which queue to use. */
@@ -108,6 +116,7 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 	const u8 *ra = NULL;
 	bool qos = false;
 	struct mac80211_qos_map *qos_map;
+	u16 ret;
 
 	if (local->hw.queues < IEEE80211_NUM_ACS || skb->len < 6) {
 		skb->priority = 0; /* required for correct WPA/11i MIC */
@@ -148,27 +157,29 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 		if (sta)
 			qos = sta->sta.wme;
 	}
-	rcu_read_unlock();
 
 	if (!qos) {
 		skb->priority = 0; /* required for correct WPA/11i MIC */
-		return IEEE80211_AC_BE;
+		ret = IEEE80211_AC_BE;
+		goto out;
 	}
 
 	if (skb->protocol == sdata->control_port_protocol) {
 		skb->priority = 7;
-		return ieee80211_downgrade_queue(sdata, skb);
+		goto downgrade;
 	}
 
 	/* use the data classifier to determine what 802.1d tag the
 	 * data frame has */
-	rcu_read_lock();
 	qos_map = rcu_dereference(sdata->qos_map);
 	skb->priority = cfg80211_classify8021d(skb, qos_map ?
 					       &qos_map->qos_map : NULL);
-	rcu_read_unlock();
 
-	return ieee80211_downgrade_queue(sdata, skb);
+ downgrade:
+	ret = ieee80211_downgrade_queue(sdata, sta, skb);
+ out:
+	rcu_read_unlock();
+	return ret;
 }
 
 /**
diff --git a/net/mac80211/wme.h b/net/mac80211/wme.h
index 7fea4bb8acbc..80151edc5195 100644
--- a/net/mac80211/wme.h
+++ b/net/mac80211/wme.h
@@ -13,8 +13,6 @@
 #include <linux/netdevice.h>
 #include "ieee80211_i.h"
 
-extern const int ieee802_1d_to_ac[8];
-
 u16 ieee80211_select_queue_80211(struct ieee80211_sub_if_data *sdata,
 				 struct sk_buff *skb,
 				 struct ieee80211_hdr *hdr);
-- 
2.1.0

