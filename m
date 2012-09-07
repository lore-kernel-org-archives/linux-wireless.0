Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53225 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab2IGPK7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 11:10:59 -0400
Message-ID: <1347030695.4256.25.camel@jlt4.sipsolutions.net> (sfid-20120907_171102_860785_84D7C58C)
Subject: Re: [PATCH 1/2] mac80211: validate skb->dev in the tx status path
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 07 Sep 2012 17:11:35 +0200
In-Reply-To: <1347029656-41430-1-git-send-email-nbd@openwrt.org>
References: <1347029656-41430-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-09-07 at 16:54 +0200, Felix Fietkau wrote:

> +		if (!skb->dev) {
>  			p2p_sdata = rcu_dereference(local->p2p_sdata);
>  			if (p2p_sdata) {
> -				cfg80211_mgmt_tx_status(
> -					&p2p_sdata->wdev, cookie, skb->data,
> -					skb->len, acked, GFP_ATOMIC);
> +				skb->dev = p2p_sdata->dev;
> +				found = true;

What's the point of this? p2p_sdata->dev will be NULL, just like
skb->dev already is?

>  			}
> -			rcu_read_unlock();
>  		}
> +
> +		if (!found)
> +			skb->dev = NULL;
> +		else if (ieee80211_is_nullfunc(hdr->frame_control) ||
> +			 ieee80211_is_qos_nullfunc(hdr->frame_control)) {
> +			cfg80211_probe_status(skb->dev, hdr->addr1,
> +					      cookie, acked, GFP_ATOMIC);
> +		} else {
> +			cfg80211_mgmt_tx_status(
> +				skb->dev->ieee80211_ptr, cookie, skb->data,
> +				skb->len, acked, GFP_ATOMIC);

And therefore this will crash.

johannes

