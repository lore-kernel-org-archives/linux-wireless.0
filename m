Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:58889 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbYK1UJa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2008 15:09:30 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [RFC] mac80211 & p54: add sta_notify_ps callback
Date: Fri, 28 Nov 2008 21:09:35 +0100
Cc: Stefan Steuerwald <salsasepp@googlemail.com>,
	linux-wireless@vger.kernel.org
References: <200811242124.16358.chunkeey@web.de> <200811271542.23390.chunkeey@web.de> <1227801591.3852.0.camel@johannes.berg>
In-Reply-To: <1227801591.3852.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200811282109.35857.chunkeey@web.de> (sfid-20081128_210947_031197_DF35797D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ahh... I knew it! 

Alright, I looks like I have to change the mac80211 stack for this.
What I need is a callback form ap_sta_ps_end & (ap_sta_ps_start).

It's because (p54_)set_tim - and therefore p54_sta_unlock as well - won't
be executed if the station changes its power state very quickly/or if no package comes in
So we have no change to notify the firmware about the stations new power state
and then the firmware won't let us send anything to the station.  

here is my proposal for mac80211:
---
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 6a1d4ea..341ddb1 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -779,6 +779,20 @@ enum sta_notify_cmd {
 };
 
 /**
+ * enum sta_notify_ps_cmd - sta powersave notify command
+ *
+ * Used with the sta_notify_ps() callback in &struct ieee80211_ops to
+ * notify the driver if a station made a power state transition.
+ *
+ * @STA_WILL_SLEEP: the station will sleep
+ * @STA_WOKE_UP: the sleeping station woke up
+ */
+enum sta_notify_ps_cmd {
+	STA_WILL_SLEEP,
+	STA_WOKE_UP,
+};
+
+/**
  * enum ieee80211_tkip_key_type - get tkip key
  *
  * Used by drivers which need to get a tkip key for skb. Some drivers need a
@@ -1248,6 +1262,9 @@ enum ieee80211_ampdu_mlme_action {
  * @sta_notify: Notifies low level driver about addition or removal
  *	of associated station or AP.
  *
+ * @sta_notify_ps: Notifies low level driver about the power state transition
+ *	of a associated station.
+ *
  * @conf_tx: Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
  *	bursting) for a hardware TX queue.
  *
@@ -1314,6 +1331,8 @@ struct ieee80211_ops {
 	int (*set_frag_threshold)(struct ieee80211_hw *hw, u32 value);
 	void (*sta_notify)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			enum sta_notify_cmd, struct ieee80211_sta *sta);
+	void (*sta_notify_ps)(struct ieee80211_hw *hw,
+			enum sta_notify_ps_cmd, struct ieee80211_sta *sta);
 	int (*conf_tx)(struct ieee80211_hw *hw, u16 queue,
 		       const struct ieee80211_tx_queue_params *params);
 	int (*get_tx_stats)(struct ieee80211_hw *hw,
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5a1a60f..3bf056e 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -654,10 +654,14 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 static void ap_sta_ps_start(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_local *local = sdata->local;
 	DECLARE_MAC_BUF(mac);
 
 	atomic_inc(&sdata->bss->num_sta_ps);
 	set_and_clear_sta_flags(sta, WLAN_STA_PS, WLAN_STA_PSPOLL);
+	if (local->ops->sta_notify_ps)
+		local->ops->sta_notify_ps(local_to_hw(local), STA_WILL_SLEEP,
+					  &sta->sta);
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	printk(KERN_DEBUG "%s: STA %s aid %d enters power save mode\n",
 	       sdata->dev->name, print_mac(mac, sta->sta.addr), sta->sta.aid);
@@ -675,6 +679,9 @@ static int ap_sta_ps_end(struct sta_info *sta)
 	atomic_dec(&sdata->bss->num_sta_ps);
 
 	clear_sta_flags(sta, WLAN_STA_PS | WLAN_STA_PSPOLL);
+	if (local->ops->sta_notify_ps)
+		local->ops->sta_notify_ps(local_to_hw(local), STA_WOKE_UP,
+					  &sta->sta);
 
 	if (!skb_queue_empty(&sta->ps_tx_buf))
 		sta_info_clear_tim_bit(sta);
---
and here is p54 new code:
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-11-28 20:18:53.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-11-28 20:40:02.000000000 +0100
@@ -653,6 +653,10 @@ static void p54_rx_frame_sent(struct iee
 		__skb_unlink(entry, &priv->tx_queue);
 		spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
 
+		entry_hdr = (struct p54_hdr *) entry->data;
+		entry_data = (struct p54_tx_data *) entry_hdr->data;
+		priv->tx_stats[entry_data->hw_queue].len--;
+
 		if (unlikely(entry == priv->cached_beacon)) {
 			kfree_skb(entry);
 			priv->cached_beacon = NULL;
@@ -669,8 +673,6 @@ static void p54_rx_frame_sent(struct iee
 		BUILD_BUG_ON(offsetof(struct ieee80211_tx_info,
 				      status.ampdu_ack_len) != 23);
 
-		entry_hdr = (struct p54_hdr *) entry->data;
-		entry_data = (struct p54_tx_data *) entry_hdr->data;
 		if (entry_hdr->flags & cpu_to_le16(P54_HDR_FLAG_DATA_ALIGN))
 			pad = entry_data->align[0];
 
@@ -688,7 +690,6 @@ static void p54_rx_frame_sent(struct iee
 			}
 		}
 
-		priv->tx_stats[entry_data->hw_queue].len--;
 		if (!(info->flags & IEEE80211_TX_CTL_NO_ACK) &&
 		     (!payload->status))
 			info->flags |= IEEE80211_TX_STAT_ACK;
@@ -1005,6 +1006,38 @@ static int p54_sta_unlock(struct ieee802
 	return 0;
 }
 
+static void p54_sta_notify_ps(struct ieee80211_hw *dev,
+			      enum sta_notify_ps_cmd notify_cmd,
+			      struct ieee80211_sta *sta)
+{
+	switch (notify_cmd) {
+	case STA_WOKE_UP:
+		p54_sta_unlock(dev, sta->addr);
+		break;
+	default:
+		break;
+	}
+}
+
+static void p54_sta_notify(struct ieee80211_hw *dev, struct ieee80211_vif *vif,
+			      enum sta_notify_cmd notify_cmd,
+			      struct ieee80211_sta *sta)
+{
+	switch (notify_cmd) {
+	case STA_NOTIFY_ADD:
+	case STA_NOTIFY_REMOVE:
+		/*
+		 * Notify the firmware that we don't want or we don't
+		 * need to buffer frames for this station anymore.
+		 */
+
+		p54_sta_unlock(dev, sta->addr);
+		break;
+	default:
+		break;
+	}
+}
+
 static int p54_tx_cancel(struct ieee80211_hw *dev, struct sk_buff *entry)
 {
 	struct p54_common *priv = dev->priv;
@@ -1070,7 +1103,7 @@ static int p54_tx_fill(struct ieee80211_
 		if (info->control.sta)
 			*aid = info->control.sta->aid;
 		else
-			*flags = P54_HDR_FLAG_DATA_OUT_NOCANCEL;
+			*flags |= P54_HDR_FLAG_DATA_OUT_NOCANCEL;
 	}
 	return ret;
 }
@@ -1083,7 +1116,7 @@ static int p54_tx(struct ieee80211_hw *d
 	struct p54_hdr *hdr;
 	struct p54_tx_data *txhdr;
 	size_t padding, len, tim_len = 0;
-	int i, j, ridx;
+	int i, j, ridx, ret;
 	u16 hdr_flags = 0, aid = 0;
 	u8 rate, queue;
 	u8 cts_rate = 0x20;
@@ -1093,30 +1126,18 @@ static int p54_tx(struct ieee80211_hw *d
 
 	queue = skb_get_queue_mapping(skb);
 
-	if (p54_tx_fill(dev, skb, info, &queue, &tim_len, &hdr_flags, &aid)) {
-		current_queue = &priv->tx_stats[queue];
-		if (unlikely(current_queue->len > current_queue->limit))
-			return NETDEV_TX_BUSY;
-		current_queue->len++;
-		current_queue->count++;
-		if (current_queue->len == current_queue->limit)
-			ieee80211_stop_queue(dev, skb_get_queue_mapping(skb));
-	}
+	ret = p54_tx_fill(dev, skb, info, &queue, &tim_len, &hdr_flags, &aid);
+	current_queue = &priv->tx_stats[queue];
+	if (unlikely((current_queue->len > current_queue->limit) && ret))
+		return NETDEV_TX_BUSY;
+	current_queue->len++;
+	current_queue->count++;
+	if ((current_queue->len == current_queue->limit) && ret)
+		ieee80211_stop_queue(dev, skb_get_queue_mapping(skb));
 
 	padding = (unsigned long)(skb->data - (sizeof(*hdr) + sizeof(*txhdr))) & 3;
 	len = skb->len;
 
-	if (info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT) {
-		if (info->control.sta)
-			if (p54_sta_unlock(dev, info->control.sta->addr)) {
-				if (current_queue) {
-					current_queue->len--;
-					current_queue->count--;
-				}
-				return NETDEV_TX_BUSY;
-			}
-	}
-
 	txhdr = (struct p54_tx_data *) skb_push(skb, sizeof(*txhdr) + padding);
 	hdr = (struct p54_hdr *) skb_push(skb, sizeof(*hdr));
 
@@ -1835,6 +1856,8 @@ static const struct ieee80211_ops p54_op
 	.add_interface		= p54_add_interface,
 	.remove_interface	= p54_remove_interface,
 	.set_tim		= p54_set_tim,
+	.sta_notify_ps		= p54_sta_notify_ps,
+	.sta_notify		= p54_sta_notify,
 	.config			= p54_config,
 	.config_interface	= p54_config_interface,
 	.bss_info_changed	= p54_bss_info_changed,
diff -Nurp a/drivers/net/wireless/p54/p54common.h b/drivers/net/wireless/p54/p54common.h
--- a/drivers/net/wireless/p54/p54common.h	2008-11-28 20:18:53.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.h	2008-11-28 20:27:59.000000000 +0100
@@ -302,7 +302,7 @@ enum p54_frame_sent_status {
 	P54_TX_OK = 0,
 	P54_TX_FAILED,
 	P54_TX_PSM,
-	P54_TX_PSM_CANCELLED
+	P54_TX_PSM_CANCELLED = 4
 };
 
 struct p54_frame_sent {
