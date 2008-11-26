Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:50732 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbYKZStL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 13:49:11 -0500
To: "Stefan Steuerwald" <salsasepp@googlemail.com>
Subject: Re: p54: AP mode: no data frame despite traffic indication set in TIM (resend)
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
From: Christian Lamparter <chunkeey@web.de>
Date: Wed, 26 Nov 2008 19:49:08 +0100
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_koZLJsq/5fq0h16"
Message-Id: <200811261949.08180.chunkeey@web.de> (sfid-20081126_194916_051729_2E32835C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_koZLJsq/5fq0h16
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 26 November 2008 14:38:59 Stefan Steuerwald wrote:
> However, after some time, the kernel oopses. Console output below.
> I watched this several times, and it always happens after seeing these
> last two lines in syslog:348 :
>   Nov 26 14:16:32 alix kernel: STA 00:22:41:91:8e:96 aid 1: PS buffer
> (entries before 0)
>   Nov 26 14:16:32 alix kernel: STA 00:22:41:91:8e:96 aid 1: PS buffer
> (entries before 1)
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000038
> IP: [<d08260fa>] p54_assign_address+0x67/0x14b [p54common]
> 
> Pid: 0, comm: swapper Not tainted (2.6.28-rc6-wl #16)
> EIP: 0060:[<d08260fa>] EFLAGS: 00010002 CPU: 0
> EIP is at p54_assign_address+0x67/0x14b [p54common]
> EAX: cf98b178 EBX: cf86ee40 ECX: 00000000 EDX: 00000000
> ESI: 000000f8 EDI: 00000000 EBP: 0002027c ESP: c03f9c4c
> Process swapper (pid: 0, ti=c03f8000 task=c03c4380 task.ti=c03f8000)
> Call Trace:
>  [<d0826fd7>] p54_tx+0x416/0x482 [p54common]
>  [<c02fb7c2>] __ieee80211_tx+0x35/0xf8
>[...]
> Code: [...] <8b> ...
> EIP: [<d08260fa>] p54_assign_address+0x67/0x14b [p54common] SS:ESP 0068:c03f9c4c
> Kernel panic - not syncing: Fatal exception in interrupt
> 
can you please send me all binary p54 modules?

Regards
	Chr

BTW: I don't know if the first email got stuck somewhere, 
so I just add an another respin of sta-flags...
It could help (as in: don't crash so often) in your case. 
Or, maybe changing the beacon interval could help as well?!

--Boundary-00=_koZLJsq/5fq0h16
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="p54-sta-flags-v3.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="p54-sta-flags-v3.diff"

diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-11-24 13:07:09.053832187 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-11-26 15:50:51.679448926 +0100
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
@@ -967,40 +968,51 @@ free:
 }
 EXPORT_SYMBOL_GPL(p54_read_eeprom);
 
-static int p54_set_tim(struct ieee80211_hw *dev, struct ieee80211_sta *sta,
-		bool set)
+static int p54_sta_unlock(struct ieee80211_hw *dev, u8 *addr)
 {
 	struct p54_common *priv = dev->priv;
 	struct sk_buff *skb;
-	struct p54_tim *tim;
+	struct p54_sta_unlock *sta;
 
 	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET,
-		      sizeof(struct p54_hdr) + sizeof(*tim),
-		      P54_CONTROL_TYPE_TIM, GFP_KERNEL);
+		sizeof(struct p54_hdr) + sizeof(*sta),
+		P54_CONTROL_TYPE_PSM_STA_UNLOCK, GFP_ATOMIC);
 	if (!skb)
 		return -ENOMEM;
 
-	tim = (struct p54_tim *) skb_put(skb, sizeof(*tim));
-	tim->count = 1;
-	tim->entry[0] = cpu_to_le16(set ? (sta->aid | 0x8000) : sta->aid);
+	sta = (struct p54_sta_unlock *)skb_put(skb, sizeof(*sta));
+	memcpy(sta->addr, addr, ETH_ALEN);
 	priv->tx(dev, skb, 1);
 	return 0;
 }
 
-static int p54_sta_unlock(struct ieee80211_hw *dev, u8 *addr)
+static int p54_set_tim(struct ieee80211_hw *dev, struct ieee80211_sta *sta,
+		bool set)
 {
 	struct p54_common *priv = dev->priv;
 	struct sk_buff *skb;
-	struct p54_sta_unlock *sta;
+	struct p54_tim *tim;
+	int ret;
+
+	if (!set) {
+		/*
+		 * when we clear the tim, we should also remove the
+		 * station from the firmware's powersave filter list
+		 */
+		ret = p54_sta_unlock(dev, sta->addr);
+		if (ret)
+			return ret;
+	}
 
 	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET,
-		sizeof(struct p54_hdr) + sizeof(*sta),
-		P54_CONTROL_TYPE_PSM_STA_UNLOCK, GFP_ATOMIC);
+		      sizeof(struct p54_hdr) + sizeof(*tim),
+		      P54_CONTROL_TYPE_TIM, GFP_KERNEL);
 	if (!skb)
 		return -ENOMEM;
 
-	sta = (struct p54_sta_unlock *)skb_put(skb, sizeof(*sta));
-	memcpy(sta->addr, addr, ETH_ALEN);
+	tim = (struct p54_tim *) skb_put(skb, sizeof(*tim));
+	tim->count = 1;
+	tim->entry[0] = cpu_to_le16(set ? (sta->aid | 0x8000) : sta->aid);
 	priv->tx(dev, skb, 1);
 	return 0;
 }
@@ -1067,9 +1079,11 @@ static int p54_tx_fill(struct ieee80211_
 			*queue = 3;
 			return 0;
 		}
-		if (info->control.sta)
+		if (info->control.sta) {
+			if (info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT)
+				*flags |= P54_HDR_FLAG_DATA_OUT_NOCANCEL;
 			*aid = info->control.sta->aid;
-		else
+		} else
 			*flags = P54_HDR_FLAG_DATA_OUT_NOCANCEL;
 	}
 	return ret;
@@ -1083,7 +1097,7 @@ static int p54_tx(struct ieee80211_hw *d
 	struct p54_hdr *hdr;
 	struct p54_tx_data *txhdr;
 	size_t padding, len, tim_len = 0;
-	int i, j, ridx;
+	int i, j, ridx, ret;
 	u16 hdr_flags = 0, aid = 0;
 	u8 rate, queue;
 	u8 cts_rate = 0x20;
@@ -1093,30 +1107,18 @@ static int p54_tx(struct ieee80211_hw *d
 
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
 

--Boundary-00=_koZLJsq/5fq0h16--
