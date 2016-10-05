Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49223 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751233AbcJEO7Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 10:59:24 -0400
Message-ID: <1475679558.5257.7.camel@sipsolutions.net> (sfid-20161005_165927_834066_3A467B5D)
Subject: Re: [PATCHv4] mac80211: check A-MSDU inner frame source address on
 AP interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Braun <michael-dev@fami-braun.de>
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de,
        kvalo@codeaurora.org, akarwar@marvell.com, nishants@marvell.com,
        Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com
Date: Wed, 05 Oct 2016 16:59:18 +0200
In-Reply-To: <1475661751-26262-1-git-send-email-michael-dev@fami-braun.de>
References: <1475661751-26262-1-git-send-email-michael-dev@fami-braun.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-10-05 at 12:02 +0200, Michael Braun wrote:
> When using WPA security, the station and thus the required key is
> identified by its mac address when packets are received. So a
> station usually cannot spoof its source mac address.
> 
> But when a station sends an A-MSDU frame, port control and crypto
> is done using the outer mac address, while the packets delivered
> and forwarded use the inner mac address.
> This might affect ARP/IP filtering on the AccessPoint.
> 
> IEEE 802.11-2012 mandates that the outer source mac address should
> match the inner source address (section 8.3.2.2). For the destination
> mac address, matching is not required, as a wifi client may send all
> its traffic to the AP in order to have it forwarded.
> 
> Signed-off-by: Michael Braun <michael-dev@fami-braun.de>

So as you can see by my own version of this patch, I'm not super happy
with the way you did things here :)

Obviously, the commit log is now pretty much wrong here in your patch,
since you do much more than that now and don't focus on the SA only.


> @@ -1436,7 +1436,8 @@ static void
> iwl_mvm_report_wakeup_reasons(struct iwl_mvm *mvm,
>  
>  			memcpy(skb_put(pkt, pktsize), pktdata,
> pktsize);
>  
> -			if (ieee80211_data_to_8023(pkt, vif->addr,
> vif->type))
> +			if (ieee80211_data_to_8023(pkt, NULL, vif-
> >addr,
> +						   vif->type))
>  				goto report;

I did something similar in the first patch I sent, but without changing
the drivers (by using a static inline and a new function name)

>  void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct
> sk_buff_head *list,
> -			      const u8 *addr, enum nl80211_iftype
> iftype,
> +			      const u8 *addr,
> +			      enum nl80211_iftype iftype,
>  			      const unsigned int extra_headroom,
> -			      bool has_80211_header);
> +			      const u8 *ta, const u8 *ra, bool
> is_4addr,
> +			      bool is_tdls_data);

Instead of adding 4 new arguments, (ta, ra, is_4addr, is_tdls_data), I
opted to just add two (check_da and check_sa) and make those NULL when
no checks are desired.

I *think* that works equivalently, but it'd be great if you could take
a look.

I had also removed the has_80211_header argument in patch 2, so we
don't clutter this thing as much.

> -	if (is_multicast_ether_addr(hdr->addr1) &&
> -	    ((rx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
> -	      rx->sdata->u.vlan.sta) ||
> -	     (rx->sdata->vif.type == NL80211_IFTYPE_STATION &&
> -	      rx->sdata->u.mgd.use_4addr)))
> +	is_4addr = ((rx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN
> &&
> +		     rx->sdata->u.vlan.sta) ||
> +		    (rx->sdata->vif.type == NL80211_IFTYPE_STATION
> &&
> +		     rx->sdata->u.mgd.use_4addr));
> +	if (is_multicast_ether_addr(hdr->addr1) && is_4addr)
>  		return RX_DROP_UNUSABLE;

This also conflicts with the earlier patch I sent to just always drop
when it's multicast.

>  	skb->dev = dev;
>  	__skb_queue_head_init(&frame_list);
>  
> +	if (ieee80211_data_to_8023(skb, &eth_80211, dev->dev_addr,
> +				   rx->sdata->vif.type) < 0)
> +		return RX_DROP_UNUSABLE;
> +
> +	is_tdls_data = !ieee80211_has_tods(fc) &&
> !ieee80211_has_fromds(fc);
>  	ieee80211_amsdu_to_8023s(skb, &frame_list, dev->dev_addr,
>  				 rx->sdata->vif.type,
> -				 rx->local->hw.extra_tx_headroom,
> true);
> +				 rx->local->hw.extra_tx_headroom,
> +				 eth_80211.h_source,
> +				 eth_80211.h_dest, is_4addr,
> is_tdls_data);

Because you're passing eth_80211.h_* unconditionally, you need those
extra arguments, but I don't see why my approach wouldn't work.

> +	/* limit inner src/dst checks depending on iftype */
> +	switch (iftype) {
> +	case NL80211_IFTYPE_AP:
> +	case NL80211_IFTYPE_AP_VLAN:
> +		if (is_4addr)
> +			ta = NULL;
> +		ra = NULL;
> +		break;
> +	case NL80211_IFTYPE_ADHOC:
> +		break;
> +	case NL80211_IFTYPE_STATION:
> +		if (is_4addr || !is_tdls_data)
> +			ta = NULL;
> +		if (is_4addr)
> +			ra = NULL;
> +		break;
> +	default:
> +		ta = NULL;
> +		ra = NULL;
>  	}

I have this in mac80211, which imho makes it easier.

I had half in mind to actually pass something like "expected frame
type", which wouldn't just be iftype, but be more like "AP, CLIENT,
TDLS, MESH, IBSS, ...", but it ultimately seemed too complex.

johannes
