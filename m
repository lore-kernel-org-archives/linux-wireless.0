Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:36050 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbYK1UnX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2008 15:43:23 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211 & p54: add sta_notify_ps callback
Date: Fri, 28 Nov 2008 21:43:01 +0100
Cc: Stefan Steuerwald <salsasepp@googlemail.com>,
	linux-wireless@vger.kernel.org
References: <200811242124.16358.chunkeey@web.de> <1227801591.3852.0.camel@johannes.berg> <200811282109.35857.chunkeey@web.de>
In-Reply-To: <200811282109.35857.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200811282143.01847.chunkeey@web.de> (sfid-20081128_214327_994308_8296BD2D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 28 November 2008 21:09:35 Christian Lamparter wrote:
> Ahh... I knew it! 
> 
> Alright, I looks like I have to change the mac80211 stack for this.
> What I need is a callback form ap_sta_ps_end & (ap_sta_ps_start).
> 
> It's because (p54_)set_tim - and therefore p54_sta_unlock as well - won't
> be executed if the station changes its power state very quickly/or if no package comes in
> So we have no change to notify the firmware about the stations new power state
> and then the firmware won't let us send anything to the station.  
> 
> here is my proposal for mac80211:
> ---
Updates:
	- integrate sta_notify_ps into sta_notify.
	- added trivial switch cases for mac80211_hwsim.c (or else gcc complains)
And BTW: can someone please check the spelling?
---
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index f43da1c..e2c50ed 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -524,6 +524,10 @@ static void mac80211_hwsim_sta_notify(struct ieee80211_hw *hw,
 	case STA_NOTIFY_REMOVE:
 		hwsim_clear_sta_magic(sta);
 		break;
+	case STA_NOTIFY_AWAKE:
+	case STA_NOTIFY_SLEEP:
+		/* TODO: make good use of these callbacks */
+		break;
 	}
 }
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 6a1d4ea..7bd8edc 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -768,14 +768,18 @@ struct ieee80211_sta {
 /**
  * enum sta_notify_cmd - sta notify command
  *
- * Used with the sta_notify() callback in &struct ieee80211_ops, this
- * indicates addition and removal of a station to station table.
+ * Used with the sta_notify() callback in &struct ieee80211_ops.
+ * this command indicates addition and removal of a station to
+ * station table, or if a station made a power state transition.
  *
  * @STA_NOTIFY_ADD: a station was added to the station table
  * @STA_NOTIFY_REMOVE: a station being removed from the station table
+ * @STA_NOTIFY_SLEEP: a station is now sleeping
+ * @STA_NOTIFY_AWAKE: a sleeping station woke up
  */
 enum sta_notify_cmd {
-	STA_NOTIFY_ADD, STA_NOTIFY_REMOVE
+	STA_NOTIFY_ADD, STA_NOTIFY_REMOVE,
+	STA_NOTIFY_SLEEP, STA_NOTIFY_AWAKE,
 };
 
 /**
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5a1a60f..2d311a1 100644
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
+	if (local->ops->sta_notify)
+		local->ops->sta_notify(local_to_hw(local), &sdata->vif,
+				       STA_NOTIFY_SLEEP, &sta->sta);
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	printk(KERN_DEBUG "%s: STA %s aid %d enters power save mode\n",
 	       sdata->dev->name, print_mac(mac, sta->sta.addr), sta->sta.aid);
@@ -675,6 +679,9 @@ static int ap_sta_ps_end(struct sta_info *sta)
 	atomic_dec(&sdata->bss->num_sta_ps);
 
 	clear_sta_flags(sta, WLAN_STA_PS | WLAN_STA_PSPOLL);
+	if (local->ops->sta_notify)
+		local->ops->sta_notify(local_to_hw(local), &sdata->vif,
+				       STA_NOTIFY_AWAKE, &sta->sta);
 
 	if (!skb_queue_empty(&sta->ps_tx_buf))
 		sta_info_clear_tim_bit(sta);
---

p54 updates:
	- update to new api
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-11-28 20:18:53.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-11-28 21:37:45.000000000 +0100
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
@@ -1005,6 +1006,26 @@ static int p54_sta_unlock(struct ieee802
 	return 0;
 }
 
+static void p54_sta_notify(struct ieee80211_hw *dev, struct ieee80211_vif *vif,
+			      enum sta_notify_cmd notify_cmd,
+			      struct ieee80211_sta *sta)
+{
+	switch (notify_cmd) {
+	case STA_NOTIFY_ADD:
+	case STA_NOTIFY_REMOVE:
+	case STA_NOTIFY_AWAKE:
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
@@ -1070,7 +1091,7 @@ static int p54_tx_fill(struct ieee80211_
 		if (info->control.sta)
 			*aid = info->control.sta->aid;
 		else
-			*flags = P54_HDR_FLAG_DATA_OUT_NOCANCEL;
+			*flags |= P54_HDR_FLAG_DATA_OUT_NOCANCEL;
 	}
 	return ret;
 }
@@ -1083,7 +1104,7 @@ static int p54_tx(struct ieee80211_hw *d
 	struct p54_hdr *hdr;
 	struct p54_tx_data *txhdr;
 	size_t padding, len, tim_len = 0;
-	int i, j, ridx;
+	int i, j, ridx, ret;
 	u16 hdr_flags = 0, aid = 0;
 	u8 rate, queue;
 	u8 cts_rate = 0x20;
@@ -1093,30 +1114,18 @@ static int p54_tx(struct ieee80211_hw *d
 
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
 
@@ -1835,6 +1844,7 @@ static const struct ieee80211_ops p54_op
 	.add_interface		= p54_add_interface,
 	.remove_interface	= p54_remove_interface,
 	.set_tim		= p54_set_tim,
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
