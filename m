Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56529 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757301AbaGWLrX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2014 07:47:23 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 2/2] mac80211: implement TX TSPEC support
Date: Wed, 23 Jul 2014 13:47:06 +0200
Message-Id: <1406116026-27514-3-git-send-email-johannes@sipsolutions.net> (sfid-20140723_134726_946066_DCC5C6B0)
In-Reply-To: <1406116026-27514-1-git-send-email-johannes@sipsolutions.net>
References: <1406116026-27514-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If drivers want to support TX TS support, they can implement the
two new add_tx_ts/del_tx_ts callbacks. The code will then allow
transmission on ACs that have mandatory admission control, the
device should implement time accounting and also downgrading if
the admitted time isn't sufficient.

Change-Id: I081b82873f9ac16c40143f254b932e456a3f1a6e
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h    | 10 ++++++
 net/mac80211/cfg.c        | 77 +++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h | 26 ++++++++++++++++
 net/mac80211/sta_info.h   |  9 ++++++
 net/mac80211/trace.h      | 58 +++++++++++++++++++++++++++++++++++
 net/mac80211/wme.c        | 24 ++++++++++-----
 6 files changed, 196 insertions(+), 8 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index db283fbf4492..e4399f57f6bd 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2845,6 +2845,11 @@ enum ieee80211_roc_type {
  * @get_expected_throughput: extract the expected throughput towards the
  *	specified station. The returned value is expressed in Kbps. It returns 0
  *	if the RC algorithm does not have proper data to provide.
+ *
+ * @add_tx_ts: validate or add a TX TS, see &struct cfg80211_ops documentation.
+ *	Note that the device/driver must implement accounting of admitted time
+ *	and the downgrading when running out of admitted time.
+ * @del_tx_ts: remove an existing TX TS
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3047,6 +3052,11 @@ struct ieee80211_ops {
 	int (*join_ibss)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 	void (*leave_ibss)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
 	u32 (*get_expected_throughput)(struct ieee80211_sta *sta);
+
+	int (*add_tx_ts)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			 struct ieee80211_sta *sta, u8 ac, u16 admitted_time);
+	void (*del_tx_ts)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			  struct ieee80211_sta *sta, u8 ac);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9058e25030e7..85e64625aaf2 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -19,6 +19,7 @@
 #include "cfg.h"
 #include "rate.h"
 #include "mesh.h"
+#include "wme.h"
 
 static struct wireless_dev *ieee80211_add_iface(struct wiphy *wiphy,
 						const char *name,
@@ -3548,6 +3549,80 @@ static int ieee80211_set_ap_chanwidth(struct wiphy *wiphy,
 	return ret;
 }
 
+static int ieee80211_add_tx_ts(struct wiphy *wiphy, struct net_device *dev,
+			       u8 tsid, const u8 *peer, u8 up,
+			       u16 admitted_time)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
+	int ac = ieee802_1d_to_ac[up];
+	int err;
+
+	if (sdata->vif.type != NL80211_IFTYPE_STATION)
+		return -EOPNOTSUPP;
+
+	if (!(sdata->wmm_acm & BIT(up)))
+		return -EINVAL;
+
+	mutex_lock(&local->sta_mtx);
+	sta = sta_info_get(sdata, peer);
+	if (!sta) {
+		err = -ENOENT;
+		goto out;
+	}
+
+	if (sta->tx_tspec[ac].admitted_time) {
+		err = -EBUSY;
+		goto out;
+	}
+
+	err = drv_add_tx_ts(local, sdata, &sta->sta, ac, admitted_time);
+	if (!err && admitted_time) {
+		sta->tx_tspec[ac].admitted_time = admitted_time;
+		sta->tx_tspec[ac].tsid = tsid;
+	}
+ out:
+	mutex_unlock(&local->sta_mtx);
+	return err;
+}
+
+static int ieee80211_del_tx_ts(struct wiphy *wiphy, struct net_device *dev,
+			       u8 tsid, const u8 *peer)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
+	int ac, err;
+
+	mutex_lock(&local->sta_mtx);
+	sta = sta_info_get(sdata, peer);
+	if (!sta) {
+		err = -ENOENT;
+		goto out;
+	}
+
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+		/* skip unused entries */
+		if (!sta->tx_tspec[ac].admitted_time)
+			continue;
+
+		if (sta->tx_tspec[ac].tsid != tsid)
+			continue;
+
+		drv_del_tx_ts(local, sdata, &sta->sta, ac);
+		memset(&sta->tx_tspec[ac], 0, sizeof(sta->tx_tspec[ac]));
+		err = 0;
+		goto out;
+	}
+
+	err = -ENOENT;
+
+ out:
+	mutex_unlock(&local->sta_mtx);
+	return err;
+}
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -3624,4 +3699,6 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.channel_switch = ieee80211_channel_switch,
 	.set_qos_map = ieee80211_set_qos_map,
 	.set_ap_chanwidth = ieee80211_set_ap_chanwidth,
+	.add_tx_ts = ieee80211_add_tx_ts,
+	.del_tx_ts = ieee80211_del_tx_ts,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index ffd124bd2c20..9010f8bccdff 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1252,4 +1252,30 @@ static inline u32 drv_get_expected_throughput(struct ieee80211_local *local,
 	return ret;
 }
 
+static inline int drv_add_tx_ts(struct ieee80211_local *local,
+				struct ieee80211_sub_if_data *sdata,
+				struct ieee80211_sta *sta,
+				u8 ac, u16 admitted_time)
+{
+	int ret = -EOPNOTSUPP;
+
+	trace_drv_add_tx_ts(local, sdata, sta, ac, admitted_time);
+	if (local->ops->add_tx_ts)
+		ret = local->ops->add_tx_ts(&local->hw, &sdata->vif,
+					    sta, ac, admitted_time);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
+static inline void drv_del_tx_ts(struct ieee80211_local *local,
+				 struct ieee80211_sub_if_data *sdata,
+				 struct ieee80211_sta *sta, u8 ac)
+{
+	trace_drv_del_tx_ts(local, sdata, sta, ac);
+	if (local->ops->del_tx_ts)
+		local->ops->del_tx_ts(&local->hw, &sdata->vif, sta, ac);
+	trace_drv_return_void(local);
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index bb0a02ce7d9b..06467e1cbc00 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -272,6 +272,11 @@ struct ieee80211_tx_latency_stat {
 	u32 bin_count;
 };
 
+struct ieee80211_sta_tx_tspec {
+	u8 tsid;
+	u8 admitted_time;
+};
+
 /**
  * struct sta_info - STA information
  *
@@ -360,6 +365,7 @@ struct ieee80211_tx_latency_stat {
  * @known_smps_mode: the smps_mode the client thinks we are in. Relevant for
  *	AP only.
  * @cipher_scheme: optional cipher scheme for this station
+ * @tx_tspec: active TX TS (for admission control) information
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -395,6 +401,9 @@ struct sta_info {
 	struct sk_buff_head tx_filtered[IEEE80211_NUM_ACS];
 	unsigned long driver_buffered_tids;
 
+	/* read-only for TX path, RTNL protection for config changes */
+	struct ieee80211_sta_tx_tspec tx_tspec[IEEE80211_NUM_ACS];
+
 	/* Updated from RX path only, no locking requirements */
 	unsigned long rx_packets;
 	u64 rx_bytes;
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 5668ef8093a2..e5315f3af30a 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1623,6 +1623,64 @@ TRACE_EVENT(drv_get_expected_throughput,
 	)
 );
 
+TRACE_EVENT(drv_add_tx_ts,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_sta *sta,
+		 u8 ac, u16 admitted_time),
+
+	TP_ARGS(local, sdata, sta, ac, admitted_time),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		STA_ENTRY
+		__field(u8, ac)
+		__field(u16, admitted_time)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		STA_ASSIGN;
+		__entry->ac = ac;
+		__entry->admitted_time = admitted_time;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT ", " VIF_PR_FMT ", " STA_PR_FMT ", ac:%d, time:%d",
+		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG,
+		__entry->ac, __entry->admitted_time
+	)
+);
+
+TRACE_EVENT(drv_del_tx_ts,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_sta *sta, u8 ac),
+
+	TP_ARGS(local, sdata, sta, ac),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		STA_ENTRY
+		__field(u8, ac)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		STA_ASSIGN;
+		__entry->ac = ac;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT ", " VIF_PR_FMT ", " STA_PR_FMT ", ac:%d",
+		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, __entry->ac
+	)
+);
+
 /*
  * Tracing for API calls that drivers call.
  */
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 7963d9ce171f..2a159534b435 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -53,10 +53,15 @@ static int wme_downgrade_ac(struct sk_buff *skb)
 }
 
 static u16 ieee80211_downgrade_queue(struct ieee80211_sub_if_data *sdata,
-				     struct sk_buff *skb)
+				     struct sta_info *sta, struct sk_buff *skb)
 {
 	/* in case we are a client verify acm is not set for this ac */
 	while (unlikely(sdata->wmm_acm & BIT(skb->priority))) {
+		int ac = ieee802_1d_to_ac[skb->priority];
+
+		if (sta && sta->tx_tspec[ac].admitted_time)
+			return ac;
+
 		if (wme_downgrade_ac(skb)) {
 			/*
 			 * This should not really happen. The AP has marked all
@@ -95,7 +100,7 @@ u16 ieee80211_select_queue_80211(struct ieee80211_sub_if_data *sdata,
 	p = ieee80211_get_qos_ctl(hdr);
 	skb->priority = *p & IEEE80211_QOS_CTL_TAG1D_MASK;
 
-	return ieee80211_downgrade_queue(sdata, skb);
+	return ieee80211_downgrade_queue(sdata, NULL, skb);
 }
 
 /* Indicate which queue to use. */
@@ -107,6 +112,7 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 	const u8 *ra = NULL;
 	bool qos = false;
 	struct mac80211_qos_map *qos_map;
+	u16 ret;
 
 	if (local->hw.queues < IEEE80211_NUM_ACS || skb->len < 6) {
 		skb->priority = 0; /* required for correct WPA/11i MIC */
@@ -147,27 +153,29 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 		if (sta)
 			qos = test_sta_flag(sta, WLAN_STA_WME);
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
-- 
2.0.0

