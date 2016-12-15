Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42460 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755222AbcLOJjD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Dec 2016 04:39:03 -0500
Message-ID: <1481794695.31776.7.camel@sipsolutions.net> (sfid-20161215_103927_416250_B34B445C)
Subject: Re: [RFC 3/3] mac80211: Add receive path for ethernet frame format
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 15 Dec 2016 10:38:15 +0100
In-Reply-To: <1481781608-5181-4-git-send-email-vthiagar@qti.qualcomm.com>
References: <1481781608-5181-1-git-send-email-vthiagar@qti.qualcomm.com>
         <1481781608-5181-4-git-send-email-vthiagar@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> This rx path only checks if the driver has advertised
> it's support of 802.11 header encap/decap offload for
> data frames. 

I'm not even sure I see the point in that? Other than that (and the
various other offload requirements), it seems that encap/decap could be
considered orthogonal.

> +	 * Adhoc interface depends on bssid to udpate last_rx.

type - update

> +	if (!(status->flag & RX_FLAG_MCAST)) {
> +		sta->rx_stats.last_rx = jiffies;
> +		sta->rx_stats.last_rate =
> sta_stats_encode_rate(status);
> +	}

You should probably rename that flag to something like
RX_FLAG_80211_MCAST since otherwise it's confusing with the next
multicast ether addr check:

> +	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
> +	    !is_multicast_ether_addr(ehdr->h_dest))
> +		ieee80211_sta_reset_conn_monitor(sdata);

But this could just also use the flag, since in station mode the two
are equivalent, and it'd be easier to figure out if this was "else if
(station mode)"?

> +	memset(&rx, 0, sizeof(rx));

That seems a bit pointless?

> +	rx.skb = skb;
> +	rx.sdata = sdata;
> +	rx.local = local;
> +	rx.sta = sta;
> +
> +	if (vif->type == NL80211_IFTYPE_AP_VLAN && sdata->bss &&
> +	    unlikely(ehdr->h_proto == sdata->control_port_protocol)) 
> {
> +		sdata = container_of(sdata->bss, struct
> ieee80211_sub_if_data,
> +				     u.ap);
> +		dev = sdata->dev;
> +		rx.sdata = sdata;
> +	}
> +
> +	rx.skb->dev = dev;
> +
> +	/* XXX: Since rx.seqno_idx is not available for decap
> offloaded frames
> +	 * rx msdu stats update at the seqno_idx in
> ieee80211_deliver_skb()
> +	 * will always be updated at index 0 and will not be very
> useful.
> +	 */
> +	ieee80211_deliver_skb(&rx);

Yeah, that's not nice - perhaps we can provide the TID out of band? If
not, we'll have to disable those statistics *all the way*, i.e. not
even report them to userspace when filling sinfo.

> +	return;
> +
> +mic_fail:
> +	cfg80211_michael_mic_failure(sdata->dev, sta->addr,
> +				     (status->flag & RX_FLAG_MCAST)
> ?
> +				     NL80211_KEYTYPE_GROUP :
> +				     NL80211_KEYTYPE_PAIRWISE,
> +				     key ? key->conf.keyidx : -1,
> +				     NULL, GFP_ATOMIC);

Do we really want to handle that inline here? The driver probably has a
different check to even set RX_FLAG_MMIC_ERROR, so we could just ask it
to call cfg80211_michael_mic_failure() [or a wrapper to get sdata->dev] 
instead? I guess this works too though, and might be easier to
understand.

johannes
