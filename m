Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18138 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbbDTTxp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2015 15:53:45 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/3] mac80211: notify the driver upon BAR Rx
Date: Mon, 20 Apr 2015 22:53:37 +0300
Message-Id: <1429559618-23056-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150420_215350_054172_0D5B7B50)
In-Reply-To: <1429559618-23056-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1429559618-23056-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we receive a BAR, this typically means that our peer
doesn't hear our Block-Acks or that we can't hear its
frames. Either way, it is a good indication that the link
is in a bad condition. This is why it can serve as a probe
to the driver.
Use the event_callback callback for this.
Since more events with the same data will be added in the
feature, the structure that describes the data attached to
the event is called in a generic name: ieee80211_ba_event.

This also means that from now on, the event_callback can't
sleep.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h | 20 ++++++++++++++++++--
 net/mac80211/rx.c      |  8 ++++++++
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 38a5fd7..e682927 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -337,10 +337,12 @@ enum ieee80211_bss_change {
  * enum ieee80211_event_type - event to be notified to the low level driver
  * @RSSI_EVENT: AP's rssi crossed the a threshold set by the driver.
  * @MLME_EVENT: event related to MLME
+ * @BAR_RX_EVENT: a BAR was received
  */
 enum ieee80211_event_type {
 	RSSI_EVENT,
 	MLME_EVENT,
+	BAR_RX_EVENT,
 };
 
 /**
@@ -400,17 +402,31 @@ struct ieee80211_mlme_event {
 };
 
 /**
+ * struct ieee80211_ba_event - data attached for BlockAck related events
+ * @sta: pointer to the &ieee80211_sta to which this event relates
+ * @tid: the tid
+ * @ssn: the starting sequence number
+ */
+struct ieee80211_ba_event {
+	struct ieee80211_sta *sta;
+	u16 tid;
+	u16 ssn;
+};
+
+/**
  * struct ieee80211_event - event to be sent to the driver
  * @type: The event itself. See &enum ieee80211_event_type.
  * @rssi: relevant if &type is %RSSI_EVENT
  * @mlme: relevant if &type is %AUTH_EVENT
- * @u:    union holding the above two fields
+ * @ba: relevant if &type is %BAR_RX_EVENT
+ * @u:union holding the fields above
  */
 struct ieee80211_event {
 	enum ieee80211_event_type type;
 	union {
 		struct ieee80211_rssi_event rssi;
 		struct ieee80211_mlme_event mlme;
+		struct ieee80211_ba_event ba;
 	} u;
 };
 
@@ -3002,7 +3018,7 @@ enum ieee80211_reconfig_type {
  *	The callback can sleep.
  * @event_callback: Notify driver about any event in mac80211. See
  *	&enum ieee80211_event_type for the different types.
- *	The callback can sleep.
+ *	The callback must be atomic.
  *
  * @release_buffered_frames: Release buffered frames according to the given
  *	parameters. In the case where the driver buffers some frames for
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index bc59c8a..b01468f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2443,6 +2443,9 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_data *rx, struct sk_buff_head *frames)
 		struct {
 			__le16 control, start_seq_num;
 		} __packed bar_data;
+		struct ieee80211_event event = {
+			.type = BAR_RX_EVENT,
+		};
 
 		if (!rx->sta)
 			return RX_DROP_MONITOR;
@@ -2458,6 +2461,9 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_data *rx, struct sk_buff_head *frames)
 			return RX_DROP_MONITOR;
 
 		start_seq_num = le16_to_cpu(bar_data.start_seq_num) >> 4;
+		event.u.ba.tid = tid;
+		event.u.ba.ssn = start_seq_num;
+		event.u.ba.sta = &rx->sta->sta;
 
 		/* reset session timer */
 		if (tid_agg_rx->timeout)
@@ -2470,6 +2476,8 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_data *rx, struct sk_buff_head *frames)
 						 start_seq_num, frames);
 		spin_unlock(&tid_agg_rx->reorder_lock);
 
+		drv_event_callback(rx->local, rx->sdata, &event);
+
 		kfree_skb(skb);
 		return RX_QUEUED;
 	}
-- 
2.1.0

