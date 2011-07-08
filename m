Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2126 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753777Ab1GHQUk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2011 12:20:40 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 14/21] mac80211: add driver RSSI threshold events
Date: Fri,  8 Jul 2011 08:46:22 -0700
Message-Id: <1310139989-27661-15-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110708_182108_655020_E3784387)
In-Reply-To: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

mac80211 maintains a running average of the RSSI when a STA
is associated to an AP. Report threshold events to any driver
that has registered callbacks for getting RSSI measurements.

Implement callbacks in mac80211 so that driver can set thresholds.
Add callbacks in mac80211 which is invoked when an RSSI threshold
event occurs.

mac80211: add tracing to rssi_reports api and remove extraneous fn argument
mac80211: scale up rssi thresholds from driver by 16 before storing

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 include/net/mac80211.h      |   20 ++++++++++++++++++
 net/mac80211/driver-ops.h   |    8 +++++++
 net/mac80211/driver-trace.h |   46 +++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h  |    8 +++++++
 net/mac80211/mlme.c         |   23 +++++++++++++++++++++
 net/mac80211/util.c         |   40 +++++++++++++++++++++++++++++++++++++
 6 files changed, 145 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2474019..19c1b10 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -193,6 +193,17 @@ enum ieee80211_bss_change {
 #define IEEE80211_BSS_ARP_ADDR_LIST_LEN 4
 
 /**
+ * enum ieee80211_rssi_event - RSSI threshold event
+ * An indicator for when RSSI goes below/above a certain threshold.
+ * @RSSI_EVENT_HIGH: AP's rssi crossed the high threshold set by the driver.
+ * @RSSI_EVENT_LOW: AP's rssi crossed the low threshold set by the driver.
+ */
+enum ieee80211_rssi_event {
+	RSSI_EVENT_HIGH,
+	RSSI_EVENT_LOW,
+};
+
+/**
  * struct ieee80211_bss_conf - holds the BSS's changing parameters
  *
  * This structure keeps information about a BSS (and an association
@@ -1881,6 +1892,8 @@ enum ieee80211_ampdu_mlme_action {
  * @set_bitrate_mask: Set a mask of rates to be used for rate control selection
  *	when transmitting a frame. Currently only legacy rates are handled.
  *	The callback can sleep.
+ * @rssi_callback: Notify driver when the average RSSI goes above/below
+ *	thresholds that were registered previously. The callback can sleep.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
@@ -1989,6 +2002,8 @@ struct ieee80211_ops {
 	bool (*tx_frames_pending)(struct ieee80211_hw *hw);
 	int (*set_bitrate_mask)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 				const struct cfg80211_bitrate_mask *mask);
+	void (*rssi_callback)(struct ieee80211_hw *hw,
+			      enum ieee80211_rssi_event rssi_event);
 };
 
 /**
@@ -3240,4 +3255,9 @@ ieee80211_vif_type_p2p(struct ieee80211_vif *vif)
 	return ieee80211_iftype_p2p(vif->type, vif->p2p);
 }
 
+void ieee80211_enable_rssi_reports(struct ieee80211_vif *vif,
+				   int rssi_min_thold,
+				   int rssi_max_thold);
+
+void ieee80211_disable_rssi_reports(struct ieee80211_vif *vif);
 #endif /* MAC80211_H */
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index edd2dd7..b2d6bba 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -657,4 +657,12 @@ static inline void drv_set_rekey_data(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline void drv_rssi_callback(struct ieee80211_local *local,
+				     const enum ieee80211_rssi_event event)
+{
+	trace_drv_rssi_callback(local, event);
+	if (local->ops->rssi_callback)
+		local->ops->rssi_callback(&local->hw, event);
+	trace_drv_return_void(local);
+}
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 31a9dfa..4470f6e 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -1052,6 +1052,28 @@ TRACE_EVENT(drv_set_rekey_data,
 		  LOCAL_PR_ARG, VIF_PR_ARG)
 );
 
+TRACE_EVENT(drv_rssi_callback,
+	TP_PROTO(struct ieee80211_local *local,
+		 enum ieee80211_rssi_event rssi_event),
+
+	TP_ARGS(local, rssi_event),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(u32, rssi_event)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->rssi_event = rssi_event;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " rssi_event:%d",
+		LOCAL_PR_ARG, __entry->rssi_event
+	)
+);
+
 /*
  * Tracing for API calls that drivers call.
  */
@@ -1342,6 +1364,30 @@ TRACE_EVENT(api_gtk_rekey_notify,
 	TP_printk(VIF_PR_FMT, VIF_PR_ARG)
 );
 
+TRACE_EVENT(api_enable_rssi_reports,
+	TP_PROTO(struct ieee80211_sub_if_data *sdata,
+		 int rssi_min_thold, int rssi_max_thold),
+
+	TP_ARGS(sdata, rssi_min_thold, rssi_max_thold),
+
+	TP_STRUCT__entry(
+		VIF_ENTRY
+		__field(int, rssi_min_thold)
+		__field(int, rssi_max_thold)
+	),
+
+	TP_fast_assign(
+		VIF_ASSIGN;
+		__entry->rssi_min_thold = rssi_min_thold;
+		__entry->rssi_max_thold = rssi_max_thold;
+	),
+
+	TP_printk(
+		VIF_PR_FMT " rssi_min_thold =%d, rssi_max_thold = %d",
+		VIF_PR_ARG, __entry->rssi_min_thold, __entry->rssi_max_thold
+	)
+);
+
 /*
  * Tracing for internal functions
  * (which may also be called in response to driver calls)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4f2e424..f67fa4d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -417,6 +417,14 @@ struct ieee80211_if_managed {
 	 * generated for the current association.
 	 */
 	int last_cqm_event_signal;
+
+	/*
+	 * State variables for keeping track of RSSI of the AP currently
+	 * connected to and informing driver when RSSI has gone
+	 * below/above a certain threshold.
+	 */
+	int rssi_min_thold, rssi_max_thold;
+	int last_ave_beacon_signal;
 };
 
 struct ieee80211_if_ibss {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 182cda6..f546fc8 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1763,6 +1763,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		ifmgd->ave_beacon_signal = rx_status->signal * 16;
 		ifmgd->last_cqm_event_signal = 0;
 		ifmgd->count_beacon_signal = 1;
+		ifmgd->last_ave_beacon_signal = 0;
 	} else {
 		ifmgd->ave_beacon_signal =
 			(IEEE80211_SIGNAL_AVE_WEIGHT * rx_status->signal * 16 +
@@ -1770,6 +1771,28 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 			 ifmgd->ave_beacon_signal) / 16;
 		ifmgd->count_beacon_signal++;
 	}
+
+	if (ifmgd->rssi_min_thold != ifmgd->rssi_max_thold &&
+	    ifmgd->count_beacon_signal >= IEEE80211_SIGNAL_AVE_MIN_COUNT) {
+		int sig = ifmgd->ave_beacon_signal;
+		int last_sig = ifmgd->last_ave_beacon_signal;
+
+		/*
+		 * if signal crosses either of the boundaries, invoke callback
+		 * with appropriate parameters
+		 */
+		if (sig > ifmgd->rssi_max_thold &&
+		    (last_sig <= ifmgd->rssi_min_thold || last_sig == 0)) {
+			ifmgd->last_ave_beacon_signal = sig;
+			drv_rssi_callback(local, RSSI_EVENT_HIGH);
+		} else if (sig < ifmgd->rssi_min_thold &&
+			   (last_sig >= ifmgd->rssi_max_thold ||
+			   last_sig == 0)) {
+			ifmgd->last_ave_beacon_signal = sig;
+			drv_rssi_callback(local, RSSI_EVENT_LOW);
+		}
+	}
+
 	if (bss_conf->cqm_rssi_thold &&
 	    ifmgd->count_beacon_signal >= IEEE80211_SIGNAL_AVE_MIN_COUNT &&
 	    !(local->hw.flags & IEEE80211_HW_SUPPORTS_CQM_RSSI)) {
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 652e569..1901320 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1450,3 +1450,43 @@ size_t ieee80211_ie_split_vendor(const u8 *ies, size_t ielen, size_t offset)
 
 	return pos;
 }
+
+static void _ieee80211_enable_rssi_reports(struct ieee80211_sub_if_data *sdata,
+					    int rssi_min_thold,
+					    int rssi_max_thold)
+{
+	trace_api_enable_rssi_reports(sdata, rssi_min_thold, rssi_max_thold);
+
+	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_STATION))
+		return;
+
+	/*
+	 * Scale up threshold values before storing it, as the RSSI averaging
+	 * algorithm uses a scaled up value as well. Change this scaling
+	 * factor if the RSSI averaging algorithm changes.
+	 */
+	sdata->u.mgd.rssi_min_thold = rssi_min_thold*16;
+	sdata->u.mgd.rssi_max_thold = rssi_max_thold*16;
+}
+
+void ieee80211_enable_rssi_reports(struct ieee80211_vif *vif,
+				    int rssi_min_thold,
+				    int rssi_max_thold)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+
+	WARN_ON(rssi_min_thold == rssi_max_thold ||
+		rssi_min_thold > rssi_max_thold);
+
+	_ieee80211_enable_rssi_reports(sdata, rssi_min_thold,
+				       rssi_max_thold);
+}
+EXPORT_SYMBOL(ieee80211_enable_rssi_reports);
+
+void ieee80211_disable_rssi_reports(struct ieee80211_vif *vif)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+
+	_ieee80211_enable_rssi_reports(sdata, 0, 0);
+}
+EXPORT_SYMBOL(ieee80211_disable_rssi_reports);
-- 
1.7.0.4

