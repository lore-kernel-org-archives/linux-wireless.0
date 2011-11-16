Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52397 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab1KPPC7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 10:02:59 -0500
Subject: [PATCH v2 4/4] mac80211: transmit fragment list to drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo Van Doorn <ivdoorn@gmail.com>
In-Reply-To: <20111116142911.501655161@sipsolutions.net> (sfid-20111116_152957_439907_F94BE74E)
References: <20111116142854.518391560@sipsolutions.net>
	 <20111116142911.501655161@sipsolutions.net>
	 (sfid-20111116_152957_439907_F94BE74E)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Nov 2011 16:02:47 +0100
Message-ID: <1321455767.4502.9.camel@jlt3.sipsolutions.net> (sfid-20111116_160302_082735_F67A8496)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Drivers can usually handle fragmented packets
much easier when they get the entire list of
fragments at once. The only thing they need to
do is keep enough space on the queues for up
to ten fragments of a single MSDU.

This allows them to implement this with a new
operation tx_frags.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v2: don't modify all drivers, thanks Ivo.

 include/net/mac80211.h    |   22 ++++++++--
 net/mac80211/driver-ops.h |    8 +++
 net/mac80211/main.c       |    2 
 net/mac80211/tx.c         |   94 +++++++++++++++++++++++++++++-----------------
 4 files changed, 86 insertions(+), 40 deletions(-)

--- a/include/net/mac80211.h	2011-11-16 15:43:47.000000000 +0100
+++ b/include/net/mac80211.h	2011-11-16 15:54:26.000000000 +0100
@@ -1760,11 +1760,21 @@ enum ieee80211_frame_release_type {
  *	skb contains the buffer starting from the IEEE 802.11 header.
  *	The low-level driver should send the frame out based on
  *	configuration in the TX control data. This handler should,
- *	preferably, never fail and stop queues appropriately, more
- *	importantly, however, it must never fail for A-MPDU-queues.
- *	This function should return NETDEV_TX_OK except in very
- *	limited cases.
- *	Must be implemented and atomic.
+ *	preferably, never fail and stop queues appropriately.
+ *	This must be implemented if @tx_frags is not.
+ *	Must be atomic.
+ *
+ * @tx_frags: Called to transmit multiple fragments of a single MSDU.
+ *	This handler must consume all fragments, sending out some of
+ *	them only is useless and it can't ask for some of them to be
+ *	queued again. If the frame is not fragmented the queue has a
+ *	single SKB only. To avoid issues with the networking stack
+ *	when TX status is reported the frames should be removed from
+ *	the skb queue.
+ *	If this is used, the tx_info @vif and @sta pointers will be
+ *	invalid -- you must not use them in that case.
+ *	This must be implemented if @tx isn't.
+ *	Must be atomic.
  *
  * @start: Called before the first netdevice attached to the hardware
  *	is enabled. This should turn on the hardware and must turn on
@@ -2101,6 +2111,8 @@ enum ieee80211_frame_release_type {
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
+	void (*tx_frags)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			 struct ieee80211_sta *sta, struct sk_buff_head *skbs);
 	int (*start)(struct ieee80211_hw *hw);
 	void (*stop)(struct ieee80211_hw *hw);
 #ifdef CONFIG_PM
--- a/net/mac80211/driver-ops.h	2011-11-16 15:43:47.000000000 +0100
+++ b/net/mac80211/driver-ops.h	2011-11-16 15:49:51.000000000 +0100
@@ -15,6 +15,14 @@ static inline void drv_tx(struct ieee802
 	local->ops->tx(&local->hw, skb);
 }
 
+static inline void drv_tx_frags(struct ieee80211_local *local,
+				struct ieee80211_vif *vif,
+				struct ieee80211_sta *sta,
+				struct sk_buff_head *skbs)
+{
+	local->ops->tx_frags(&local->hw, vif, sta, skbs);
+}
+
 static inline int drv_start(struct ieee80211_local *local)
 {
 	int ret;
--- a/net/mac80211/tx.c	2011-11-16 15:43:47.000000000 +0100
+++ b/net/mac80211/tx.c	2011-11-16 15:50:35.000000000 +0100
@@ -1203,24 +1203,15 @@ ieee80211_tx_prepare(struct ieee80211_su
 	return TX_CONTINUE;
 }
 
-/*
- * Returns false if the frame couldn't be transmitted but was queued instead.
- */
-static bool __ieee80211_tx(struct ieee80211_local *local,
-			   struct sk_buff_head *skbs, int led_len,
-			   struct sta_info *sta, bool txpending)
+static bool ieee80211_tx_frags(struct ieee80211_local *local,
+			       struct ieee80211_vif *vif,
+			       struct ieee80211_sta *sta,
+			       struct sk_buff_head *skbs,
+			       bool txpending)
 {
 	struct sk_buff *skb, *tmp;
 	struct ieee80211_tx_info *info;
-	struct ieee80211_sub_if_data *sdata;
 	unsigned long flags;
-	__le16 fc;
-
-	if (WARN_ON(skb_queue_empty(skbs)))
-		return true;
-
-	skb = skb_peek(skbs);
-	fc = ((struct ieee80211_hdr *)skb->data)->frame_control;
 
 	skb_queue_walk_safe(skbs, skb, tmp) {
 		int q = skb_get_queue_mapping(skb);
@@ -1245,37 +1236,72 @@ static bool __ieee80211_tx(struct ieee80
 		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 
 		info = IEEE80211_SKB_CB(skb);
+		info->control.vif = vif;
+		info->control.sta = sta;
 
-		sdata = vif_to_sdata(info->control.vif);
+		__skb_unlink(skb, skbs);
+		drv_tx(local, skb);
+	}
 
-		switch (sdata->vif.type) {
-		case NL80211_IFTYPE_MONITOR:
-			info->control.vif = NULL;
-			break;
-		case NL80211_IFTYPE_AP_VLAN:
-			info->control.vif = &container_of(sdata->bss,
-				struct ieee80211_sub_if_data, u.ap)->vif;
-			break;
-		default:
-			/* keep */
-			break;
-		}
+	return true;
+}
 
-		if (sta && sta->uploaded)
-			info->control.sta = &sta->sta;
-		else
-			info->control.sta = NULL;
+/*
+ * Returns false if the frame couldn't be transmitted but was queued instead.
+ */
+static bool __ieee80211_tx(struct ieee80211_local *local,
+			   struct sk_buff_head *skbs, int led_len,
+			   struct sta_info *sta, bool txpending)
+{
+	struct ieee80211_tx_info *info;
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_vif *vif;
+	struct ieee80211_sta *pubsta;
+	struct sk_buff *skb;
+	bool result = true;
+	__le16 fc;
 
-		__skb_unlink(skb, skbs);
-		drv_tx(local, skb);
+	if (WARN_ON(skb_queue_empty(skbs)))
+		return true;
+
+	skb = skb_peek(skbs);
+	fc = ((struct ieee80211_hdr *)skb->data)->frame_control;
+	info = IEEE80211_SKB_CB(skb);
+	sdata = vif_to_sdata(info->control.vif);
+	if (sta && !sta->uploaded)
+		sta = NULL;
+
+	if (sta)
+		pubsta = &sta->sta;
+	else
+		pubsta = NULL;
+
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_MONITOR:
+		sdata = NULL;
+		vif = NULL;
+		break;
+	case NL80211_IFTYPE_AP_VLAN:
+		sdata = container_of(sdata->bss,
+				     struct ieee80211_sub_if_data, u.ap);
+		/* fall through */
+	default:
+		vif = &sdata->vif;
+		break;
 	}
 
+	if (local->ops->tx_frags)
+		drv_tx_frags(local, vif, pubsta, skbs);
+	else
+		result = ieee80211_tx_frags(local, vif, pubsta, skbs,
+					    txpending);
+
 	ieee80211_tpt_led_trig_tx(local, fc, led_len);
 	ieee80211_led_tx(local, 1);
 
 	WARN_ON(!skb_queue_empty(skbs));
 
-	return true;
+	return result;
 }
 
 /*
--- a/net/mac80211/main.c	2011-11-15 14:02:07.000000000 +0100
+++ b/net/mac80211/main.c	2011-11-16 15:48:09.000000000 +0100
@@ -609,7 +609,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 
 	local->hw.priv = (char *)local + ALIGN(sizeof(*local), NETDEV_ALIGN);
 
-	BUG_ON(!ops->tx);
+	BUG_ON(!ops->tx && !ops->tx_frags);
 	BUG_ON(!ops->start);
 	BUG_ON(!ops->stop);
 	BUG_ON(!ops->config);


