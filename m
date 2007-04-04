Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:44183 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992443AbXDCWgX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2007 18:36:23 -0400
Message-ID: <46137FF2.6020203@linux.intel.com>
Date: Wed, 04 Apr 2007 03:37:38 -0700
From: mabbas <mabbas@linux.intel.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Johannes Berg <johannes@sipsolutions.net>, linville@tuxdriver.com,
	mabbas@linux.intel.com
Subject: Re: [patch 3/5] A-MSDU Rx aggregation support
References: <1174909200.1364.56.camel@dell-4965.jf.intel.com> <1175111599.5151.123.camel@johannes.berg>
In-Reply-To: <1175111599.5151.123.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

modified patch at the end
Johannes Berg wrote:
> On Mon, 2007-03-26 at 04:40 -0700, mohamed wrote:
>
> Scratch my previous comments. Sorry about that, I should've looked
> better.
>
>   
>> +inline static int is_agg_frame(struct sk_buff *skb, u16 fc)
>> +{
>> +       u8 *p = skb->data + ieee80211_get_hdrlen(fc) - 2;
>>     
>
> See below, but isn't this broken if somebody includes an HT field?
>
>   
>> +       if (!(fc & IEEE80211_STYPE_QOS_DATA));
>> +               return 0;
>> +
>> +       if (*p & QOS_CONTROL_A_MSDU_PRESENT)
>> +               return 1;
>> +       else
>> +               return 0;
>> +}
>>     
>
>   
> +	payload = skb->data + hdrlen;
>   
>
> Ok so payload now points to the subframes.
>
>   
>> +	if (unlikely(skb->len - hdrlen < 8)) {
>> +		if (net_ratelimit()) {
>> +			printk(KERN_DEBUG "%s: RX too short data frame "
>> +				"payload\n", dev->name);
>>     
>
> Nit: this should increase the counter we have for too short frames
> somewhere.
>
>   
>> +		}
>> +		return TXRX_DROP;
>> +	}
>> +
>> +	ethertype = (payload[6] << 8) | payload[7];
>>     
>
> Is that really correct?
>
>   
>> +	if (likely((memcmp(payload, rfc1042_header, 6) == 0 &&
>> +		ethertype != ETH_P_AARP && ethertype != ETH_P_IPX) ||
>> +		memcmp(payload, bridge_tunnel_header, 6) == 0)) {
>> +		/* remove RFC1042 or Bridge-Tunnel encapsulation and
>> +		* replace EtherType */	
>> +		skb_pull(skb, hdrlen + 6);
>> +	} else {
>> +		skb_pull(skb, hdrlen);
>> +	}
>> +
>> +	eth = (struct ethhdr*)skb->data;
>>     
>
> So that now points to the first actual subframe ethhdr. I misread that
> in my first comment. Why do you actually skb_pull on this skb? It would
> probably be more efficient to just assign "eth" in the different cases
> since that needs no memory write (eth will probably be kept in a
> register). And you throw it away anyway...
>
>   
>> +	while ((u8*)eth < skb->data + skb->len) {
>>     
>
> And that compares the pointer, not the value at it as I thought. Sorry.
>
>   
>> +        	unsigned int eth_len = sizeof(struct ethhdr) + 
>> +						ntohs(eth->h_proto);
>>     
>
> rename to subframe_len maybe?
>
>   
>> +		frame = dev_alloc_skb(3000);
>> +
>> +		if (frame == NULL) 
>> +			return TXRX_DROP;
>> +
>> +		frame->mac.raw = frame->data;
>> +		memcpy(skb_put(frame, eth_len), (u8*)eth, eth_len);
>>     
>
> Nope, not nice to do this. You really need to check if eth_len doesn't
> exceed the original skb's length or people can crash this by sending you
> short frames with bogus huge eth len embedded in it. And if you move the
> check up a bit then you can reuse "skb" for the last subframe in the
> case where people don't send us garbage:
>
> 	int remaining = subframe_len - ((u8*)eth - skb->data);
> 	if (remaining < 0)
> 		/* idiots. should blacklist their mac address */
> 		return TXRX_DROP;
> 	if (remaining < 4 /* padding */) {
> 		frame = skb;
> 		skb = NULL;
> 		skb_pull(blabla)
> 	} else {
> 		frame = dev_alloc_skb(...)
> 		if (!frame)
> 			return TXRX_DROP;
> 	}
>
> or something like that.
>
> Don't you also need to set ((ethhdr*)frame->data)->h_proto to something
> other than the length? Not exactly sure though, it seems eth_type_trans
> can handle that and I don't have the 802.3 specs handy.
>
>   
>> +		frame->dev = dev;
>>     
>
> I think it'd be good to move that closer to the netif_rx.
>
>   
>> +					* directly to it and do not pass 
>> +					* the frame to local net stack.
>> +					*/
>> +					skb2 = skb;
>> +					skb = NULL;
>>     
>
> I'm pretty sure you mean frame here instead of skb in both cases and
> this is a copy/paste error from the other data rx handler.
>
>   
>> +				}
>> +				if (dsta)
>> +					sta_info_put(dsta);
>> +			}
>> +		}
>> +		if (frame) {
>> +			/* deliver to local stack */
>> +			frame->protocol = eth_type_trans(frame, dev);
>> +			memset(frame->cb, 0, sizeof(frame->cb));
>>     
>
> That memset is useless on a newly allocated frame.
>
>   
>
>
> johannes
>   
Add A-MSDU Rx aggregation support.

To support IEEE 802.11n, we need to be able to process A-MSDU frames.
The present of the HT control field indicates it is A-MSDU frame.
This patch adds support to discover and process A-MSDU frames.

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 3bf0be4..31cf5b8 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -2460,6 +2460,139 @@ static inline int ieee80211_bssid_match(
 }
 
 
+inline static unsigned int calc_pad_len(unsigned int len)
+{
+	return ((4 - len) & 0x3);
+}
+
+static ieee80211_txrx_result
+ieee80211_rx_h_data_agg(struct ieee80211_txrx_data *rx)
+{
+	struct net_device *dev = rx->dev;
+	struct ieee80211_local *local = rx->local;
+	u16 fc, hdrlen, ethertype;
+	u8 *payload;
+	struct sk_buff *skb = rx->skb, *skb2, *frame;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	const struct ethhdr* eth;
+	int remaining;
+
+	fc = rx->fc;
+	if (unlikely((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA))
+		return TXRX_CONTINUE;
+
+	if (unlikely(!WLAN_FC_DATA_PRESENT(fc)))
+		return TXRX_DROP;
+
+	if (!rx->u.rx.is_agg_frame)
+		return TXRX_CONTINUE;
+
+	hdrlen = ieee80211_get_hdrlen(fc);
+
+	payload = skb->data + hdrlen;
+
+	if (unlikely((skb->len - hdrlen) < 8)) {
+		if (net_ratelimit())
+			printk(KERN_DEBUG "%s: RX too short data frame "
+			       "payload\n", dev->name);
+		return TXRX_DROP;
+	}
+
+	ethertype = (payload[6] << 8) | payload[7];
+
+	if (likely((compare_ether_addr(payload, rfc1042_header) == 0 &&
+		    ethertype != ETH_P_AARP && ethertype != ETH_P_IPX) ||
+	    	   compare_ether_addr(payload, bridge_tunnel_header) == 0)) {
+		/* remove RFC1042 or Bridge-Tunnel encapsulation and
+		* replace EtherType */	
+		eth = (struct ethhdr*) (skb->data + hdrlen + 6);
+		remaining = skb->len - (hdrlen + 6);
+	} else {
+		eth = (struct ethhdr*) (skb->data + hdrlen);
+		remaining = skb->len - hdrlen;
+	}
+
+	while ((u8*)eth < skb->data + skb->len) {
+		u8 padding;
+        	unsigned int subframe_len = sizeof(struct ethhdr) +
+						   ntohs(eth->h_proto);
+
+		padding = calc_pad_len(subframe_len);
+		/* the last MSDU has no padding */
+		if (subframe_len > remaining)
+			return TXRX_DROP;
+
+		frame = dev_alloc_skb(local->hw.extra_tx_headroom + 
+				      subframe_len);
+
+		if (frame == NULL) 
+			return TXRX_DROP;
+
+		memcpy(skb_put(frame, subframe_len), (u8*)eth, subframe_len);
+		frame->mac.raw = frame->data;
+		skb2 = NULL;
+
+		sdata->stats.rx_packets++;
+		sdata->stats.rx_bytes += frame->len;
+
+		if (local->bridge_packets && 
+		    (sdata->type == IEEE80211_IF_TYPE_AP ||
+		     sdata->type == IEEE80211_IF_TYPE_VLAN) && 
+		     rx->u.rx.ra_match) {
+			if (is_multicast_ether_addr(frame->data)) {
+				/* send multicast frames both to higher layers
+				* in local net stack and back to the wireless 
+				* media */
+				skb2 = skb_copy(frame, GFP_ATOMIC);
+				if (!skb2)
+					printk(KERN_DEBUG "%s: failed to clone"
+					       " multicast frame\n", dev->name);
+			} else {
+				struct sta_info *dsta;
+
+				dsta = sta_info_get(local, frame->data);
+				if (dsta && !dsta->dev) 
+					printk(KERN_DEBUG "Station with null "
+					       "dev structure!\n");
+				else if (dsta && dsta->dev == dev) {
+                                	/* Destination station is associated 
+					* to this AP, so send the frame
+					* directly to it and do not pass 
+					* the frame to local net stack.
+					*/
+					skb2 = frame;
+					frame = NULL;
+				}
+				if (dsta)
+					sta_info_put(dsta);
+			}
+		}
+		if (frame) {
+			/* deliver to local stack */
+			frame->protocol = eth_type_trans(frame, dev);
+			frame->priority = skb->priority;
+			frame->dev = dev;
+			netif_rx(frame);
+		}
+
+		if (skb2) {
+			/* send to wireless media */
+			skb2->protocol = __constant_htons(ETH_P_802_3);
+			skb2->mac.raw = skb2->nh.raw = skb2->data;
+			skb2->priority = skb->priority;
+			skb2->dev = dev;
+			dev_queue_xmit(skb2);
+		}
+
+		eth = (struct ethhdr*)((u8*)eth + subframe_len + padding);
+
+		remaining -= (subframe_len + padding);
+	}
+
+	dev_kfree_skb(skb);
+	return TXRX_QUEUED;
+}
+
 static ieee80211_txrx_result
 ieee80211_rx_h_data(struct ieee80211_txrx_data *rx)
 {
@@ -4389,6 +4522,7 @@ static ieee80211_rx_handler ieee80211_rx
 	ieee80211_rx_h_remove_qos_control,
 	ieee80211_rx_h_802_1x_pae,
 	ieee80211_rx_h_drop_unencrypted,
+	ieee80211_rx_h_data_agg,
 	ieee80211_rx_h_data,
 	ieee80211_rx_h_mgmt,
 	NULL
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index dd1d031..1cf8e82 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -142,10 +142,12 @@ struct ieee80211_txrx_data {
 			int sent_ps_buffered;
 			int queue;
 			int load;
+			u16 qos_control;
 			unsigned int in_scan:1;
 			/* frame is destined to interface currently processed
 			 * (including multicast frames) */
 			unsigned int ra_match:1;
+			unsigned int is_agg_frame:1;
 		} rx;
 	} u;
 #ifdef CONFIG_HOSTAPD_WPA_TESTING
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index d57be24..63b503c 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -31,12 +31,18 @@ ieee80211_rx_h_parse_qos(struct ieee8021
 {
 	u8 *data = rx->skb->data;
 	int tid;
+	unsigned int is_agg_frame = 0;
 
 	/* does the frame have a qos control field? */
 	if (WLAN_FC_IS_QOS_DATA(rx->fc)) {
 		u8 *qc = data + ieee80211_get_hdrlen(rx->fc) - QOS_CONTROL_LEN;
+		
 		/* frame has qos control */
-		tid = qc[0] & QOS_CONTROL_TID_MASK;
+		rx->u.rx.qos_control = le16_to_cpu(*((__le16*)qc));
+		tid = rx->u.rx.qos_control & QOS_CONTROL_TID_MASK;
+		if (rx->u.rx.qos_control & 
+		    IEEE80211_QOS_CONTROL_A_MSDU_PRESENT)
+			is_agg_frame = 1;
 	} else {
 		if (unlikely((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT)) {
 			/* Separate TID for management frames */
@@ -45,6 +51,7 @@ ieee80211_rx_h_parse_qos(struct ieee8021
 			/* no qos control present */
 			tid = 0; /* 802.1d - Best Effort */
 		}
+		rx->u.rx.qos_control = 0;
 	}
 #ifdef CONFIG_MAC80211_DEBUG_COUNTERS
 	I802_DEBUG_INC(rx->local->wme_rx_queue[tid]);
@@ -54,6 +61,7 @@ #ifdef CONFIG_MAC80211_DEBUG_COUNTERS
 #endif /* CONFIG_MAC80211_DEBUG_COUNTERS */
 
 	rx->u.rx.queue = tid;
+	rx->u.rx.is_agg_frame = is_agg_frame;
 	/* Set skb->priority to 1d tag if highest order bit of TID is not set.
 	 * For now, set skb->priority to 0 for other cases. */
 	rx->skb->priority = (tid > 7) ? 0 : tid;
