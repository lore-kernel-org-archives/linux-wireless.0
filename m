Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55781 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab1BYOg7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 09:36:59 -0500
Subject: [PATCH] mac80211: support direct offchannel TX offload
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Feb 2011 15:36:57 +0100
Message-ID: <1298644617.4329.15.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For devices supported by iwlwifi sometimes
off-channel transmissions need to be handled
by the device completely. To support this
mac80211 needs to pass the frame directly
to the driver and not through the TX path
as the driver needs the frame and channel
information at the same time.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h      |   10 ++++++++++
 net/mac80211/cfg.c          |   39 +++++++++++++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h   |   31 +++++++++++++++++++++++++++++++
 net/mac80211/driver-trace.h |   33 +++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h  |    1 +
 net/mac80211/status.c       |    4 ++++
 6 files changed, 118 insertions(+)

--- wireless-testing.orig/include/net/mac80211.h	2011-02-24 12:49:42.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2011-02-24 12:49:44.000000000 +0100
@@ -1799,6 +1799,11 @@ enum ieee80211_ampdu_mlme_action {
  *	ieee80211_remain_on_channel_expired(). This callback may sleep.
  * @cancel_remain_on_channel: Requests that an ongoing off-channel period is
  *	aborted before it expires. This callback may sleep.
+ * @offchannel_tx: Transmit frame on another channel, wait for a response
+ *	and return. Reliable TX status must be reported for the frame. If the
+ *	return value is 1, then the @remain_on_channel will be used with a
+ *	regular transmission (if supported.)
+ * @offchannel_tx_cancel_wait: cancel wait associated with offchannel TX
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
@@ -1878,6 +1883,11 @@ struct ieee80211_ops {
 				 enum nl80211_channel_type channel_type,
 				 int duration);
 	int (*cancel_remain_on_channel)(struct ieee80211_hw *hw);
+	int (*offchannel_tx)(struct ieee80211_hw *hw, struct sk_buff *skb,
+			     struct ieee80211_channel *chan,
+			     enum nl80211_channel_type channel_type,
+			     unsigned int wait);
+	int (*offchannel_tx_cancel_wait)(struct ieee80211_hw *hw);
 };
 
 /**
--- wireless-testing.orig/net/mac80211/cfg.c	2011-02-24 12:49:34.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2011-02-24 12:49:44.000000000 +0100
@@ -1800,6 +1800,33 @@ static int ieee80211_mgmt_tx(struct wiph
 
 	*cookie = (unsigned long) skb;
 
+	if (is_offchan && local->ops->offchannel_tx) {
+		int ret;
+
+		IEEE80211_SKB_CB(skb)->band = chan->band;
+
+		mutex_lock(&local->mtx);
+
+		if (local->hw_offchan_tx_cookie) {
+			mutex_unlock(&local->mtx);
+			return -EBUSY;
+		}
+
+		/* TODO: bitrate control, TX processing? */
+		ret = drv_offchannel_tx(local, skb, chan, channel_type, wait);
+
+		if (ret == 0)
+			local->hw_offchan_tx_cookie = *cookie;
+		mutex_unlock(&local->mtx);
+
+		/*
+		 * Allow driver to return 1 to indicate it wants to have the
+		 * frame transmitted with a remain_on_channel + regular TX.
+		 */
+		if (ret != 1)
+			return ret;
+	}
+
 	if (is_offchan && local->ops->remain_on_channel) {
 		unsigned int duration;
 		int ret;
@@ -1886,6 +1913,18 @@ static int ieee80211_mgmt_tx_cancel_wait
 
 	mutex_lock(&local->mtx);
 
+	if (local->ops->offchannel_tx_cancel_wait &&
+	    local->hw_offchan_tx_cookie == cookie) {
+		ret = drv_offchannel_tx_cancel_wait(local);
+
+		if (!ret)
+			local->hw_offchan_tx_cookie = 0;
+
+		mutex_unlock(&local->mtx);
+
+		return ret;
+	}
+
 	if (local->ops->cancel_remain_on_channel) {
 		cookie ^= 2;
 		ret = ieee80211_cancel_remain_on_channel_hw(local, cookie);
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2011-02-24 12:49:34.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2011-02-24 12:49:44.000000000 +0100
@@ -957,6 +957,7 @@ struct ieee80211_local {
 	unsigned int hw_roc_duration;
 	u32 hw_roc_cookie;
 	bool hw_roc_for_tx;
+	unsigned long hw_offchan_tx_cookie;
 
 	/* dummy netdev for use w/ NAPI */
 	struct net_device napi_dev;
--- wireless-testing.orig/net/mac80211/driver-ops.h	2011-02-24 12:49:42.000000000 +0100
+++ wireless-testing/net/mac80211/driver-ops.h	2011-02-24 12:49:44.000000000 +0100
@@ -495,4 +495,35 @@ static inline int drv_cancel_remain_on_c
 	return ret;
 }
 
+static inline int drv_offchannel_tx(struct ieee80211_local *local,
+				    struct sk_buff *skb,
+				    struct ieee80211_channel *chan,
+				    enum nl80211_channel_type channel_type,
+				    unsigned int wait)
+{
+	int ret;
+
+	might_sleep();
+
+	trace_drv_offchannel_tx(local, skb, chan, channel_type, wait);
+	ret = local->ops->offchannel_tx(&local->hw, skb, chan,
+					channel_type, wait);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
+static inline int drv_offchannel_tx_cancel_wait(struct ieee80211_local *local)
+{
+	int ret;
+
+	might_sleep();
+
+	trace_drv_offchannel_tx_cancel_wait(local);
+	ret = local->ops->offchannel_tx_cancel_wait(&local->hw);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
--- wireless-testing.orig/net/mac80211/driver-trace.h	2011-02-24 12:49:34.000000000 +0100
+++ wireless-testing/net/mac80211/driver-trace.h	2011-02-24 12:49:44.000000000 +0100
@@ -884,6 +884,39 @@ DEFINE_EVENT(local_only_evt, drv_cancel_
 	TP_ARGS(local)
 );
 
+TRACE_EVENT(drv_offchannel_tx,
+	TP_PROTO(struct ieee80211_local *local, struct sk_buff *skb,
+		 struct ieee80211_channel *chan,
+		 enum nl80211_channel_type channel_type,
+		 unsigned int wait),
+
+	TP_ARGS(local, skb, chan, channel_type, wait),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(int, center_freq)
+		__field(int, channel_type)
+		__field(unsigned int, wait)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->center_freq = chan->center_freq;
+		__entry->channel_type = channel_type;
+		__entry->wait = wait;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " freq:%dMHz, wait:%dms",
+		LOCAL_PR_ARG, __entry->center_freq, __entry->wait
+	)
+);
+
+DEFINE_EVENT(local_only_evt, drv_offchannel_tx_cancel_wait,
+	TP_PROTO(struct ieee80211_local *local),
+	TP_ARGS(local)
+);
+
 /*
  * Tracing for API calls that drivers call.
  */
--- wireless-testing.orig/net/mac80211/status.c	2011-02-24 12:49:34.000000000 +0100
+++ wireless-testing/net/mac80211/status.c	2011-02-24 12:49:44.000000000 +0100
@@ -341,6 +341,10 @@ void ieee80211_tx_status(struct ieee8021
 			cookie = local->hw_roc_cookie ^ 2;
 			local->hw_roc_skb_for_status = NULL;
 		}
+
+		if (cookie == local->hw_offchan_tx_cookie)
+			local->hw_offchan_tx_cookie = 0;
+
 		cfg80211_mgmt_tx_status(
 			skb->dev, cookie, skb->data, skb->len,
 			!!(info->flags & IEEE80211_TX_STAT_ACK), GFP_ATOMIC);


