Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38351 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab1I2OHH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 10:07:07 -0400
Message-Id: <20110929140502.540015200@sipsolutions.net> (sfid-20110929_160712_004098_D406F205)
Date: Thu, 29 Sep 2011 16:04:39 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 14/16] mac80211: allow out-of-band EOSP notification
References: <20110929140425.390322480@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

iwlwifi has a separate EOSP notification from
the device, and to make use of that properly
it needs to be passed to mac80211. To be able
to mix with tx_status_irqsafe and rx_irqsafe
it also needs to be an "_irqsafe" version in
the sense that it goes through the tasklet,
the actual flag clearing would be IRQ-safe
but doing it directly would cause reordering
issues.

This is needed in the case of a P2P GO going
into an absence period without transmitting
any frames that should be driver-released as
in this case there's no other way to inform
mac80211 that the service period ended. Note
that for drivers that don't use the _irqsafe
functions another version of this function
will be required.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h      |   24 ++++++++++++++++++++++--
 net/mac80211/driver-trace.h |   22 ++++++++++++++++++++++
 net/mac80211/ieee80211_i.h  |    5 +++++
 net/mac80211/main.c         |   14 ++++++++++++++
 net/mac80211/sta_info.c     |   25 +++++++++++++++++++++++++
 5 files changed, 88 insertions(+), 2 deletions(-)

--- a/net/mac80211/sta_info.c	2011-09-29 16:03:31.000000000 +0200
+++ b/net/mac80211/sta_info.c	2011-09-29 16:03:33.000000000 +0200
@@ -1478,6 +1478,31 @@ void ieee80211_sta_block_awake(struct ie
 }
 EXPORT_SYMBOL(ieee80211_sta_block_awake);
 
+void ieee80211_sta_eosp_irqsafe(struct ieee80211_sta *pubsta)
+{
+	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	struct ieee80211_local *local = sta->local;
+	struct sk_buff *skb;
+	struct skb_eosp_msg_data *data;
+
+	trace_api_eosp(local, pubsta);
+
+	skb = alloc_skb(0, GFP_ATOMIC);
+	if (!skb) {
+		/* too bad ... but race is better than loss */
+		clear_sta_flag(sta, WLAN_STA_SP);
+		return;
+	}
+
+	data = (void *)skb->cb;
+	memcpy(data->sta, pubsta->addr, ETH_ALEN);
+	memcpy(data->iface, sta->sdata->vif.addr, ETH_ALEN);
+	skb->pkt_type = IEEE80211_EOSP_MSG;
+	skb_queue_tail(&local->skb_queue, skb);
+	tasklet_schedule(&local->tasklet);
+}
+EXPORT_SYMBOL(ieee80211_sta_eosp_irqsafe);
+
 void ieee80211_sta_set_buffered(struct ieee80211_sta *pubsta,
 				u8 tid, bool buffered)
 {
--- a/include/net/mac80211.h	2011-09-29 16:03:30.000000000 +0200
+++ b/include/net/mac80211.h	2011-09-29 16:03:33.000000000 +0200
@@ -1971,7 +1971,8 @@ enum ieee80211_frame_release_type {
  *	at least one, however). In this case it is also responsible for
  *	setting the EOSP flag in the QoS header of the frames. Also, when the
  *	service period ends, the driver must set %IEEE80211_TX_STATUS_EOSP
- *	on the last frame in the SP.
+ *	on the last frame in the SP. Alternatively, it may call the function
+ *	ieee80211_sta_eosp_irqsafe() to inform mac80211 of the end of the SP.
  *	This callback must be atomic.
  * @allow_buffered_frames: Prepare device to allow the given number of frames
  *	to go out to the given station. The frames will be sent by mac80211
@@ -1981,7 +1982,8 @@ enum ieee80211_frame_release_type {
  *	frames from multiple TIDs are released and the driver might reorder
  *	them between the TIDs, it must set the %IEEE80211_TX_STATUS_EOSP flag
  *	on the last frame and clear it on all others and also handle the EOSP
- *	bit in the QoS header correctly.
+ *	bit in the QoS header correctly. Alternatively, it can also call the
+ *	ieee80211_sta_eosp_irqsafe() function.
  *	The @tids parameter is a bitmap and tells the driver which TIDs the
  *	frames will be on; it will at most have two bits set.
  *	This callback must be atomic.
@@ -3113,6 +3115,24 @@ void ieee80211_sta_block_awake(struct ie
 			       struct ieee80211_sta *pubsta, bool block);
 
 /**
+ * ieee80211_sta_eosp - notify mac80211 about end of SP
+ * @pubsta: the station
+ *
+ * When a device transmits frames in a way that it can't tell
+ * mac80211 in the TX status about the EOSP, it must clear the
+ * %IEEE80211_TX_STATUS_EOSP bit and call this function instead.
+ * This applies for PS-Poll as well as uAPSD.
+ *
+ * Note that there is no non-_irqsafe version right now as
+ * it wasn't needed, but just like _tx_status() and _rx()
+ * must not be mixed in irqsafe/non-irqsafe versions, this
+ * function must not be mixed with those either. Use the
+ * all irqsafe, or all non-irqsafe, don't mix! If you need
+ * the non-irqsafe version of this, you need to add it.
+ */
+void ieee80211_sta_eosp_irqsafe(struct ieee80211_sta *pubsta);
+
+/**
  * ieee80211_iter_keys - iterate keys programmed into the device
  * @hw: pointer obtained from ieee80211_alloc_hw()
  * @vif: virtual interface to iterate, may be %NULL for all
--- a/net/mac80211/main.c	2011-09-29 16:01:09.000000000 +0200
+++ b/net/mac80211/main.c	2011-09-29 16:03:33.000000000 +0200
@@ -325,6 +325,8 @@ u32 ieee80211_reset_erp_info(struct ieee
 static void ieee80211_tasklet_handler(unsigned long data)
 {
 	struct ieee80211_local *local = (struct ieee80211_local *) data;
+	struct sta_info *sta, *tmp;
+	struct skb_eosp_msg_data *eosp_data;
 	struct sk_buff *skb;
 
 	while ((skb = skb_dequeue(&local->skb_queue)) ||
@@ -340,6 +342,18 @@ static void ieee80211_tasklet_handler(un
 			skb->pkt_type = 0;
 			ieee80211_tx_status(local_to_hw(local), skb);
 			break;
+		case IEEE80211_EOSP_MSG:
+			eosp_data = (void *)skb->cb;
+			for_each_sta_info(local, eosp_data->sta, sta, tmp) {
+				/* skip wrong virtual interface */
+				if (memcmp(eosp_data->iface,
+					   sta->sdata->vif.addr, ETH_ALEN))
+					continue;
+				clear_sta_flag(sta, WLAN_STA_SP);
+				break;
+			}
+			dev_kfree_skb(skb);
+			break;
 		default:
 			WARN(1, "mac80211: Packet is of unknown type %d\n",
 			     skb->pkt_type);
--- a/net/mac80211/ieee80211_i.h	2011-09-29 16:03:20.000000000 +0200
+++ b/net/mac80211/ieee80211_i.h	2011-09-29 16:03:33.000000000 +0200
@@ -664,6 +664,11 @@ enum sdata_queue_type {
 enum {
 	IEEE80211_RX_MSG	= 1,
 	IEEE80211_TX_STATUS_MSG	= 2,
+	IEEE80211_EOSP_MSG	= 3,
+};
+
+struct skb_eosp_msg_data {
+	u8 sta[ETH_ALEN], iface[ETH_ALEN];
 };
 
 enum queue_stop_reason {
--- a/net/mac80211/driver-trace.h	2011-09-29 16:03:31.000000000 +0200
+++ b/net/mac80211/driver-trace.h	2011-09-29 16:03:33.000000000 +0200
@@ -1498,6 +1498,28 @@ TRACE_EVENT(api_enable_rssi_reports,
 	)
 );
 
+TRACE_EVENT(api_eosp,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sta *sta),
+
+	TP_ARGS(local, sta),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		STA_ENTRY
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		STA_ASSIGN;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT STA_PR_FMT,
+		LOCAL_PR_ARG, STA_PR_FMT
+	)
+);
+
 /*
  * Tracing for internal functions
  * (which may also be called in response to driver calls)


