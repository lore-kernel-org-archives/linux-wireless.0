Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47861 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751237AbcI0IBN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Sep 2016 04:01:13 -0400
Message-ID: <1474963267.5141.11.camel@sipsolutions.net> (sfid-20160927_100118_476172_A31D1DFF)
Subject: Re: [PATCHv2] mac80211: check A-MSDU inner frame source address on
 AP interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Braun <michael-dev@fami-braun.de>
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de,
        Amitkumar Karwar <akarwar@marvell.com>,
        Avinash Patil <patila@marvell.com>
Date: Tue, 27 Sep 2016 10:01:07 +0200
In-Reply-To: <1474802886-27220-1-git-send-email-michael-dev@fami-braun.de> (sfid-20160925_132809_451078_E31A6EC3)
References: <1474802886-27220-1-git-send-email-michael-dev@fami-braun.de>
         (sfid-20160925_132809_451078_E31A6EC3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Huh. I know this bug, I thought we fixed it a long time ago. Oops.


> -	struct ethhdr eth;
> +	struct ethhdr eth, eth_80211;
>  	bool reuse_frag = skb->head_frag && !skb_has_frag_list(skb);
>  	bool reuse_skb = false;
>  	bool last = false;
>  
>  	if (has_80211_header) {
> -		err = __ieee80211_data_to_8023(skb, &eth, addr,
> iftype);
> +		err = __ieee80211_data_to_8023(skb, &eth_80211,
> addr, iftype);
>  		if (err)
>  			goto out;
>  	}

This leaves "eth_80211" uninitialized if has_80211_header is false.

> @@ -768,6 +768,13 @@ void ieee80211_amsdu_to_8023s(struct sk_buff
> *skb, struct sk_buff_head *list,
>  		subframe_len = sizeof(struct ethhdr) + len;
>  		padding = (4 - subframe_len) & 0x3;
>  
> +		if (unlikely(has_80211_header &&
> +			     (iftype == NL80211_IFTYPE_AP ||
> +			      iftype == NL80211_IFTYPE_AP_VLAN) &&
> +			     !ether_addr_equal(eth_80211.h_source,
> eth.h_source)
> +		   ))
> +			goto purge;

And this then compares against uninitialized data, so this won't work.

I'd suggest removing the "has_80211_header" argument entirely, and
replacing it with a "const u8 *sa" argument, but that complicates
mac80211 significantly since all the checks
in __ieee80211_data_to_8023() would have to be replicated.

Maybe we can still do this, and say that it must be NULL when an 802.11
header is present, and be the SA when not. However, mwifiex doesn't
seem to be able to easily provide the SA (at least I don't see it,
perhaps it can), so that we'd have to allow some kind of ERR_PTR() or
something for that special case ... Actually it'd be better to just fix
mwifiex though :)

The staging driver using this (rtl8712) can easily provide the SA,
afaict.

johannes
