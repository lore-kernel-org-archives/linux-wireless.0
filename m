Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40904 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751732AbeC0IoT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 04:44:19 -0400
From: Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
Subject: [RFC 3/4] mac80211: Apply per-peer NoAck tid bitmap configuration
Date: Tue, 27 Mar 2018 14:12:50 +0530
Message-Id: <1522140171-10926-4-git-send-email-vthiagar@codeaurora.org> (sfid-20180327_104427_610034_DD84A167)
In-Reply-To: <1522140171-10926-1-git-send-email-vthiagar@codeaurora.org>
References: <1522140171-10926-1-git-send-email-vthiagar@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use per-peer noack tid bitmap, if it is configured,
when setting up the qos header. If no per-peer configuration
is set, use the existing nedev wide noack policy configuration.
Also modifies callback set_noack_tid_bitmap() with the provision
to send per-peer NoAck policy configuration to the drivers supporting
the NoAck offload functionality (IEEE80211_HW_SUPPORTS_NOACK_POLICY).

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
---
 include/net/mac80211.h    |  7 +++++--
 net/mac80211/cfg.c        | 42 +++++++++++++++++++++++++++++++++++++-----
 net/mac80211/driver-ops.h |  5 +++--
 net/mac80211/iface.c      |  2 +-
 net/mac80211/sta_info.h   |  3 +++
 net/mac80211/trace.h      |  9 ++++++---
 net/mac80211/tx.c         |  2 +-
 net/mac80211/wme.c        | 34 +++++++++++++++++++++++++++++++++-
 8 files changed, 89 insertions(+), 15 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5a49c90..a5ed552 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3499,7 +3499,9 @@ enum ieee80211_reconfig_type {
  *	ieee80211_nan_func_terminated() with
  *	NL80211_NAN_FUNC_TERM_REASON_USER_REQUEST reason code upon removal.
  *
- * @set_noack_tid_bitmap: Set NoAck policy TID bitmap for a virtual interface.
+ * @set_noack_tid_bitmap: Set NoAck policy TID bitmap. Apply the TID NoAck
+ *	configuration for a particular station when @sta is non-NULL. When @sta
+ *	is NULL, apply TID NoAck configuration at virtual interface level.
  *	Drivers advertising NoAck policy handing support
  *	(%IEEE80211_HW_SUPPORTS_NOACK_POLICY) must implement this callback.
  */
@@ -3785,7 +3787,8 @@ struct ieee80211_ops {
 			    u8 instance_id);
 
 	int (*set_noack_tid_bitmap)(struct ieee80211_hw *hw,
-				    struct ieee80211_vif *vif, u8 noack_map);
+				    struct ieee80211_vif *vif,
+				    struct ieee80211_sta *sta, u8 noack_map);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 621ef38..1efc9cf 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -345,18 +345,50 @@ static int ieee80211_set_noack_map(struct wiphy *wiphy,
 				  u16 noack_map)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct sta_info *sta;
+	int ret;
 
-	sdata->noack_map = noack_map;
+	if (!peer) {
+		sdata->noack_map = noack_map;
 
-	if (!ieee80211_hw_check(&sdata->local->hw, SUPPORTS_NOACK_POLICY)) {
-		ieee80211_check_fast_xmit_iface(sdata);
-		return 0;
+		if (!ieee80211_hw_check(&sdata->local->hw, SUPPORTS_NOACK_POLICY)) {
+			ieee80211_check_fast_xmit_iface(sdata);
+			return 0;
+		}
+
+		if (!ieee80211_sdata_running(sdata))
+			return 0;
+
+		return drv_set_noack_tid_bitmap(sdata->local, sdata, NULL,
+						noack_map);
 	}
 
+	/* NoAck policy is for a connected client on the dev */
+
 	if (!ieee80211_sdata_running(sdata))
+		return -ENETDOWN;
+
+	mutex_lock(&sdata->local->sta_mtx);
+
+	sta = sta_info_get_bss(sdata, peer);
+	if (!sta) {
+		mutex_unlock(&sdata->local->sta_mtx);
+		return -ENOENT;
+	}
+
+	sta->noack_map = noack_map;
+
+	if (!ieee80211_hw_check(&sdata->local->hw, SUPPORTS_NOACK_POLICY)) {
+		ieee80211_check_fast_xmit(sta);
+		mutex_unlock(&sdata->local->sta_mtx);
 		return 0;
+	}
+
+	ret = drv_set_noack_tid_bitmap(sdata->local, sdata, sta, noack_map);
 
-	return drv_set_noack_tid_bitmap(sdata->local, sdata, noack_map);
+	mutex_unlock(&sdata->local->sta_mtx);
+
+	return ret;
 }
 
 static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index a0a2d3c..8a2154a 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1252,6 +1252,7 @@ static inline void drv_del_nan_func(struct ieee80211_local *local,
 
 static inline int drv_set_noack_tid_bitmap(struct ieee80211_local *local,
 					   struct ieee80211_sub_if_data *sdata,
+					   struct sta_info *sta,
 					   u16 noack_map)
 {
 	int ret;
@@ -1263,9 +1264,9 @@ static inline int drv_set_noack_tid_bitmap(struct ieee80211_local *local,
 	if (!local->ops->set_noack_tid_bitmap)
 		return -EOPNOTSUPP;
 
-	trace_drv_set_noack_tid_bitmap(local, sdata, noack_map);
+	trace_drv_set_noack_tid_bitmap(local, sdata, &sta->sta, noack_map);
 	ret = local->ops->set_noack_tid_bitmap(&local->hw, &sdata->vif,
-					       noack_map);
+					       &sta->sta, noack_map);
 	trace_drv_return_int(local, ret);
 
 	return ret;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 4e120b9..1172bed 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -633,7 +633,7 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 				goto err_del_interface;
 
 			if (sdata->noack_map)
-				drv_set_noack_tid_bitmap(local, sdata,
+				drv_set_noack_tid_bitmap(local, sdata, NULL,
 							 sdata->noack_map);
 		}
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index f64eb86..01bee75 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -581,6 +581,9 @@ struct sta_info {
 
 	struct cfg80211_chan_def tdls_chandef;
 
+	/* TID bitmap for station's NoAck policy */
+	u16 noack_map;
+
 	/* keep last! */
 	struct ieee80211_sta sta;
 };
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 3b55569..84089f7 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1866,25 +1866,28 @@ struct trace_switch_entry {
 TRACE_EVENT(drv_set_noack_tid_bitmap,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_sta *sta,
 		 u16 noack_map),
 
-	TP_ARGS(local, sdata, noack_map),
+	TP_ARGS(local, sdata, sta, noack_map),
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
 		VIF_ENTRY
+		STA_ENTRY
 		__field(u16, noack_map)
 	),
 
 	TP_fast_assign(
 		LOCAL_ASSIGN;
 		VIF_ASSIGN;
+		STA_ASSIGN;
 		__entry->noack_map = noack_map;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT  VIF_PR_FMT
+		LOCAL_PR_FMT  VIF_PR_FMT STA_PR_FMT
 		", noack_map: %u",
-		LOCAL_PR_ARG, VIF_PR_ARG, __entry->noack_map
+		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, __entry->noack_map
 	)
 );
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 27fcef3..5abe73b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2817,7 +2817,7 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 	    test_sta_flag(sta, WLAN_STA_CLEAR_PS_FILT))
 		goto out;
 
-	if (sdata->noack_map &&
+	if ((sdata->noack_map || sta->noack_map) &&
 	    !ieee80211_hw_check(&local->hw, SUPPORTS_NOACK_POLICY))
 		goto out;
 
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 6512a47..645c50b 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -227,6 +227,38 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 }
 
 /**
+ * ieee80211_get_noack_map - Get TID bitmap of NoAck policy. NoAck policy
+ * could be device wide or per-station.
+ *
+ * @sdata: local subif
+ * @mac: MAC address of the receiver
+ */
+u16 ieee80211_get_noack_map(struct ieee80211_sub_if_data *sdata, const u8 *mac)
+{
+	struct sta_info *sta;
+	u16 noack_map = 0;
+
+	/* Retrieve per-station noack_map config for the receiver, if any */
+
+	rcu_read_lock();
+
+	sta = sta_info_get(sdata, mac);
+	if (!sta) {
+		rcu_read_unlock();
+		return noack_map;
+	}
+
+	noack_map = sta->noack_map;
+
+	rcu_read_unlock();
+
+	if (!noack_map)
+		noack_map = sdata->noack_map;
+
+	return noack_map;
+}
+
+/**
  * ieee80211_set_qos_hdr - Fill in the QoS header if there is one.
  *
  * @sdata: local subif
@@ -257,7 +289,7 @@ void ieee80211_set_qos_hdr(struct ieee80211_sub_if_data *sdata,
 
 	if (is_multicast_ether_addr(hdr->addr1) ||
 	    (!ieee80211_hw_check(&sdata->local->hw, SUPPORTS_NOACK_POLICY) &&
-	    sdata->noack_map & BIT(tid))) {
+	    ieee80211_get_noack_map(sdata, hdr->addr1) & BIT(tid))) {
 		flags |= IEEE80211_QOS_CTL_ACK_POLICY_NOACK;
 		info->flags |= IEEE80211_TX_CTL_NO_ACK;
 	}
-- 
1.9.1
