Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:40298 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbaKSLrm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 06:47:42 -0500
Received: by mail-wi0-f176.google.com with SMTP id ex7so5024111wid.15
        for <linux-wireless@vger.kernel.org>; Wed, 19 Nov 2014 03:47:41 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Liad Kaufman <liad.kaufman@intel.com>
Subject: [PATCH v2 16/16] mac80211: synchronously reserve TID per station
Date: Wed, 19 Nov 2014 13:47:38 +0200
Message-Id: <1416397658-21356-1-git-send-email-arik@wizery.com> (sfid-20141119_124746_489564_A19E81AF)
In-Reply-To: <1415551822-20121-16-git-send-email-arik@wizery.com>
References: <1415551822-20121-16-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

In TDLS (e.g., TDLS off-channel) there is a requirement for
some drivers to supply an unused TID between the AP and the
device to the FW, to allow sending PTI requests and to allow
the FW to aggregate on a specific TID for better throughput.

To ensure that the allocated TID is indeed unused, this patch
introduces an API for blocking the driver from TXing on that
TID.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
v2: fix smatch warning

 include/net/mac80211.h     | 37 +++++++++++++++++++
 net/mac80211/agg-tx.c      |  7 ++++
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/sta_info.c    |  3 ++
 net/mac80211/sta_info.h    |  6 +++
 net/mac80211/tx.c          | 91 ++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/wme.c         | 39 ++++++++++++++++++++
 7 files changed, 184 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 56b7e21..59166a1 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -5071,6 +5071,43 @@ void ieee80211_tdls_oper_request(struct ieee80211_vif *vif, const u8 *peer,
 				 u16 reason_code, gfp_t gfp);
 
 /**
+ * ieee80211_reserve_tid - request to reserve a specific TID
+ *
+ * There is sometimes a need (such as in TDLS) for blocking the driver from
+ * using a specific TID so that the FW can use it for certain operations such
+ * as sending PTI requests. To make sure that the driver doesn't use that TID,
+ * this function must be called as it flushes out packets on this TID and marks
+ * it as blocked, so that any transmit for the station on this TID will be
+ * redirected to the alternative TID in the same AC.
+ *
+ * Note that this function blocks and may call back into the driver, so it
+ * should be called without driver locks held. Also note this function should
+ * only be called from the driver's @sta_state callback.
+ *
+ * @sta: the station to reserve the TID for
+ * @tid: the TID to reserve
+ *
+ * Returns: 0 on success, else on failure
+ */
+int ieee80211_reserve_tid(struct ieee80211_sta *sta, u8 tid);
+
+/**
+ * ieee80211_unreserve_tid - request to unreserve a specific TID
+ *
+ * Once there is no longer any need for reserving a certain TID, this function
+ * should be called, and no longer will packets have their TID modified for
+ * preventing use of this TID in the driver.
+ *
+ * Note that this function blocks and acquires a lock, so it should be called
+ * without driver locks held. Also note this function should only be called
+ * from the driver's @sta_state callback.
+ *
+ * @sta: the station
+ * @tid: the TID to unreserve
+ */
+void ieee80211_unreserve_tid(struct ieee80211_sta *sta, u8 tid);
+
+/**
  * ieee80211_ie_split - split an IE buffer according to ordering
  *
  * @ies: the IE buffer
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 9242c60..a360c15 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -509,6 +509,10 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 	struct tid_ampdu_tx *tid_tx;
 	int ret = 0;
 
+	if (WARN(sta->reserved_tid == tid,
+		 "Requested to start BA session on reserved tid=%d", tid))
+		return -EINVAL;
+
 	trace_api_start_tx_ba_session(pubsta, tid);
 
 	if (WARN_ON_ONCE(!local->ops->ampdu_action))
@@ -765,6 +769,9 @@ int ieee80211_stop_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid)
 		goto unlock;
 	}
 
+	WARN(sta->reserved_tid == tid,
+	     "Requested to stop BA session on reserved tid=%d", tid);
+
 	if (test_bit(HT_AGG_STATE_STOPPING, &tid_tx->state)) {
 		/* already in progress stopping it */
 		ret = 0;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a30d408..34168c2 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1011,6 +1011,7 @@ enum queue_stop_reason {
 	IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL,
 	IEEE80211_QUEUE_STOP_REASON_FLUSH,
 	IEEE80211_QUEUE_STOP_REASON_TDLS_TEARDOWN,
+	IEEE80211_QUEUE_STOP_REASON_RESERVE_TID,
 
 	IEEE80211_QUEUE_STOP_REASONS,
 };
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 86ca627..a42f5b2 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -351,6 +351,9 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 
 	sta->sta_state = IEEE80211_STA_NONE;
 
+	/* Mark TID as unreserved */
+	sta->reserved_tid = IEEE80211_TID_UNRESERVED;
+
 	ktime_get_ts(&uptime);
 	sta->last_connected = uptime.tv_sec;
 	ewma_init(&sta->avg_signal, 1024, 8);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 00f56eb..4f052bb 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -254,6 +254,9 @@ struct ieee80211_tx_latency_stat {
 	u32 bin_count;
 };
 
+/* Value to indicate no TID reservation */
+#define IEEE80211_TID_UNRESERVED	0xff
+
 /**
  * struct sta_info - STA information
  *
@@ -342,6 +345,7 @@ struct ieee80211_tx_latency_stat {
  *	AP only.
  * @cipher_scheme: optional cipher scheme for this station
  * @last_tdls_pkt_time: holds the time in jiffies of last TDLS pkt ACKed
+ * @reserved_tid: reserved TID (if any, otherwise IEEE80211_TID_UNRESERVED)
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -459,6 +463,8 @@ struct sta_info {
 	/* TDLS timeout data */
 	unsigned long last_tdls_pkt_time;
 
+	u8 reserved_tid;
+
 	/* keep last! */
 	struct ieee80211_sta sta;
 };
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 54007ce..34c9ea9 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3107,6 +3107,97 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_get_buffered_bc);
 
+int ieee80211_reserve_tid(struct ieee80211_sta *pubsta, u8 tid)
+{
+	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_local *local = sdata->local;
+	int ret;
+	u32 queues;
+
+	lockdep_assert_held(&local->sta_mtx);
+
+	/* only some cases are supported right now */
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_AP_VLAN:
+		break;
+	default:
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	if (WARN_ON(tid >= IEEE80211_NUM_UPS))
+		return -EINVAL;
+
+	if (sta->reserved_tid == tid) {
+		ret = 0;
+		goto out;
+	}
+
+	if (sta->reserved_tid != IEEE80211_TID_UNRESERVED) {
+		sdata_err(sdata, "TID reservation already active\n");
+		ret = -EALREADY;
+		goto out;
+	}
+
+	ieee80211_stop_vif_queues(sdata->local, sdata,
+				  IEEE80211_QUEUE_STOP_REASON_RESERVE_TID);
+
+	synchronize_net();
+
+	/* Tear down BA sessions so we stop aggregating on this TID */
+	if (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION) {
+		set_sta_flag(sta, WLAN_STA_BLOCK_BA);
+		__ieee80211_stop_tx_ba_session(sta, tid,
+					       AGG_STOP_LOCAL_REQUEST);
+	}
+
+	queues = BIT(sdata->vif.hw_queue[ieee802_1d_to_ac[tid]]);
+	__ieee80211_flush_queues(local, sdata, queues);
+
+	sta->reserved_tid = tid;
+
+	ieee80211_wake_vif_queues(local, sdata,
+				  IEEE80211_QUEUE_STOP_REASON_RESERVE_TID);
+
+	if (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION)
+		clear_sta_flag(sta, WLAN_STA_BLOCK_BA);
+
+	ret = 0;
+ out:
+	return ret;
+}
+EXPORT_SYMBOL(ieee80211_reserve_tid);
+
+void ieee80211_unreserve_tid(struct ieee80211_sta *pubsta, u8 tid)
+{
+	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+
+	lockdep_assert_held(&sdata->local->sta_mtx);
+
+	/* only some cases are supported right now */
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_AP_VLAN:
+		break;
+	default:
+		WARN_ON(1);
+		return;
+	}
+
+	if (tid != sta->reserved_tid) {
+		sdata_err(sdata, "TID to unreserve (%d) isn't reserved\n", tid);
+		return;
+	}
+
+	sta->reserved_tid = IEEE80211_TID_UNRESERVED;
+}
+EXPORT_SYMBOL(ieee80211_unreserve_tid);
+
 void __ieee80211_tx_skb_tid_band(struct ieee80211_sub_if_data *sdata,
 				 struct sk_buff *skb, int tid,
 				 enum ieee80211_band band)
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index fdf52db..9eb0aee 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -53,6 +53,36 @@ static int wme_downgrade_ac(struct sk_buff *skb)
 	}
 }
 
+/**
+ * ieee80211_fix_reserved_tid - return the TID to use if this one is reserved
+ * @tid: the assumed-reserved TID
+ *
+ * Returns: the alternative TID to use, or 0 on error
+ */
+static inline u8 ieee80211_fix_reserved_tid(u8 tid)
+{
+	switch (tid) {
+	case 0:
+		return 3;
+	case 1:
+		return 2;
+	case 2:
+		return 1;
+	case 3:
+		return 0;
+	case 4:
+		return 5;
+	case 5:
+		return 4;
+	case 6:
+		return 7;
+	case 7:
+		return 6;
+	}
+
+	return 0;
+}
+
 static u16 ieee80211_downgrade_queue(struct ieee80211_sub_if_data *sdata,
 				     struct sta_info *sta, struct sk_buff *skb)
 {
@@ -77,6 +107,10 @@ static u16 ieee80211_downgrade_queue(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
+	/* Check to see if this is a reserved TID */
+	if (sta && sta->reserved_tid == skb->priority)
+		skb->priority = ieee80211_fix_reserved_tid(skb->priority);
+
 	/* look up which queue to use for frames with this 1d tag */
 	return ieee802_1d_to_ac[skb->priority];
 }
@@ -143,6 +177,11 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 		break;
 #endif
 	case NL80211_IFTYPE_STATION:
+		/* might be a TDLS station */
+		sta = sta_info_get(sdata, skb->data);
+		if (sta)
+			qos = sta->sta.wme;
+
 		ra = sdata->u.mgd.bssid;
 		break;
 	case NL80211_IFTYPE_ADHOC:
-- 
1.9.1

