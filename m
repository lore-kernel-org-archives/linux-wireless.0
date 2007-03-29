Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:43866 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752366AbXC1SPl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 14:15:41 -0400
Subject: Re: [patch 3/5] A-MSDU Rx aggregation support
From: mohamed <mabbas@linux.intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <20070326163609.d9169d7b.randy.dunlap@oracle.com>
References: <1174909200.1364.56.camel@dell-4965.jf.intel.com>
	 <20070326163609.d9169d7b.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Wed, 28 Mar 2007 23:16:18 -0700
Message-Id: <1175148978.4237.11.camel@dell-4965.jf.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-03-26 at 16:36 -0700, Randy Dunlap wrote:
> On Mon, 26 Mar 2007 04:40:00 -0700 mohamed wrote:
> 
> > Add A-MSDU Rx aggregation support.
> > 
> > To support IEEE 802.11n, we need to be able to process A-MSDU frames. 
> > The present of the HT control field indicates it is A-MSDU frame. 
> > This patch adds support to discover and process A-MSDU frames.
> > 
> > Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>
> > 
> > diff -Nupr wireless-dev/net/mac80211/ieee80211.c
> > wireless-dev-new/net/mac80211/ieee80211.c
> > --- wireless-dev/net/mac80211/ieee80211.c	2007-03-27 00:36:24.000000000
> > -0700
> > +++ wireless-dev-new/net/mac80211/ieee80211.c	2007-03-27
> > 01:54:48.000000000 -0700
> > @@ -2446,6 +2446,143 @@ static inline int ieee80211_bssid_match(
> >  }
> >  
> >  
> > +inline static unsigned int calc_pad_len(unsigned int len) 
> > +{ 
> > +	return (4 - len % 4) % 4; 
> 
> Oops, line ends with a space.  Please, no lines that end with
> space or tab.
I will clean all style issues. 
> 
> Is gcc doing shifts for these % operations?  Hope so.
> 
> > +}
> > +
> > +inline static int is_agg_frame(struct sk_buff *skb, u16 fc)
> > +{
> > +	u8 *p = skb->data + ieee80211_get_hdrlen(fc) - 2;
> > +
> > +	if (!(fc & IEEE80211_STYPE_QOS_DATA));
> 
> line ends with ';' ???
> 
> > +		return 0;
> > +
> > +	if (*p & QOS_CONTROL_A_MSDU_PRESENT)
> > +		return 1;
> > +	else
> 
> 'else' not needed (just a style thing)
> 
> > +		return 0;
> > +}
> > +
> > +static ieee80211_txrx_result
> > +ieee80211_rx_h_data_agg(struct ieee80211_txrx_data *rx)
> > +{
> > +	struct net_device *dev = rx->dev;
> > +	struct ieee80211_local *local = rx->local;
> > +	u16 fc, hdrlen, ethertype;
> > +	u8 *payload;
> > +	struct sk_buff *skb = rx->skb, *skb2, *frame;
> > +	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> > +	const struct ethhdr* eth;
> > +
> > +	fc = rx->fc;
> > +	if (unlikely((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA))
> > +		return TXRX_CONTINUE;
> > +
> > +	if (unlikely(!WLAN_FC_DATA_PRESENT(fc)))
> > +		return TXRX_DROP;
> > +
> > +	if (!is_agg_frame(skb, fc))
> > +		return TXRX_CONTINUE;
> > +
> > +	hdrlen = ieee80211_get_hdrlen(fc);
> > +
> > +	payload = skb->data + hdrlen;
> > +
> > +	if (unlikely(skb->len - hdrlen < 8)) {
> > +		if (net_ratelimit()) {
> > +			printk(KERN_DEBUG "%s: RX too short data frame "
> > +				"payload\n", dev->name);
> > +		}
> > +		return TXRX_DROP;
> > +	}
> > +
> > +	ethertype = (payload[6] << 8) | payload[7];
> > +
> > +	if (likely((memcmp(payload, rfc1042_header, 6) == 0 &&
> > +		ethertype != ETH_P_AARP && ethertype != ETH_P_IPX) ||
> > +		memcmp(payload, bridge_tunnel_header, 6) == 0)) {
> > +		/* remove RFC1042 or Bridge-Tunnel encapsulation and
> > +		* replace EtherType */	
> > +		skb_pull(skb, hdrlen + 6);
> > +	} else {
> > +		skb_pull(skb, hdrlen);
> > +	}
> 
> No braces on single-statement "blocks".  (happens elsewhere also)
> 
> > +
> > +	eth = (struct ethhdr*)skb->data;
> > +
> > +	while ((u8*)eth < skb->data + skb->len) {
> > +        	unsigned int eth_len = sizeof(struct ethhdr) + 
> > +						ntohs(eth->h_proto);
> > +        
> > +		frame = dev_alloc_skb(3000);
> 
> Why 3000?  can it be a well-defined #define??
3000 just a safe number I picked up. I will change to 
dev_alloc_skb(local->hw.extra_tx_headroom + eth_len);
Are any more space needed?

> 
> > +
> > +		if (frame == NULL) 
> > +			return TXRX_DROP;
> > +
> > +		frame->mac.raw = frame->data;
> > +		memcpy(skb_put(frame, eth_len), (u8*)eth, eth_len);
> > +
> > +		frame->dev = dev;
> > +
> > +		skb2 = NULL;
> > +
> > +		sdata->stats.rx_packets++;
> > +		sdata->stats.rx_bytes += frame->len;
> > +
> > +		if (local->bridge_packets && 
> > +		    (sdata->type == IEEE80211_IF_TYPE_AP ||
> > +		     sdata->type == IEEE80211_IF_TYPE_VLAN) && 
> > +                    rx->u.rx.ra_match) {
> > +			if (is_multicast_ether_addr(frame->data)) {
> > +				/* send multicast frames both to higher layers
> > +				* in local net stack and back to the wireless 
> > +				* media */
> > +				skb2 = skb_copy(frame, GFP_ATOMIC);
> > +				if (!skb2)
> > +					printk(KERN_DEBUG "%s: failed to clone "
> > +					"multicast frame\n", dev->name);
> 
> more indentation on last part.
> 
> > +			} else {
> > +				struct sta_info *dsta;
> > +				dsta = sta_info_get(local, frame->data);
> > +				if (dsta && !dsta->dev) {
> > +					printk(KERN_DEBUG "Station with null "
> > +					"dev structure!\n");
> 
> Indentation.  no braces.
> 
> > +                        	} else if (dsta && dsta->dev == dev) {
> > +                                	/* Destination station is associated 
> > +					* to this AP, so send the frame
> > +					* directly to it and do not pass 
> > +					* the frame to local net stack.
> > +					*/
> > +					skb2 = skb;
> > +					skb = NULL;
> > +				}
> > +				if (dsta)
> > +					sta_info_put(dsta);
> > +			}
> > +		}
> > +		if (frame) {
> > +			/* deliver to local stack */
> > +			frame->protocol = eth_type_trans(frame, dev);
> > +			memset(frame->cb, 0, sizeof(frame->cb));
> > +			netif_rx(frame);
> > +		}
> > +
> > +		if (skb2) {
> > +			/* send to wireless media */
> > +			skb2->protocol = __constant_htons(ETH_P_802_3);
> > +			skb2->mac.raw = skb2->nh.raw = skb2->data;
> > +			dev_queue_xmit(skb2);
> > +		}
> > +
> > +		eth = (struct ethhdr*)((u8*)eth + eth_len 
> > +					+ calc_pad_len(eth_len));
> > +	}
> > +
> > +	dev_kfree_skb(skb);
> > +        return TXRX_QUEUED;
> 
> Inconsisten indentation above.  'return' line is using spaces
> instead of a tab.
> 
> > +}
> > +
> >  static ieee80211_txrx_result
> >  ieee80211_rx_h_data(struct ieee80211_txrx_data *rx)
> >  {
> 
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
