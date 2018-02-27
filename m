Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:42954 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752532AbeB0K7C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 05:59:02 -0500
Message-ID: <1519729139.4086.9.camel@sipsolutions.net> (sfid-20180227_115906_391202_A666006B)
Subject: Re: [PATCH] mac80211: support A-MSDU in fast-rx
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Date: Tue, 27 Feb 2018 11:58:59 +0100
In-Reply-To: <20180227075219.2049-1-nbd@nbd.name>
References: <20180227075219.2049-1-nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-02-27 at 08:52 +0100, Felix Fietkau wrote:
> 
>  	if (fast_rx->key && !(status->flag & RX_FLAG_IV_STRIPPED)) {
> +		if (status->rx_flags & IEEE80211_RX_AMSDU)
> +			return false;

This seemed really odd to me.

>  		/* GCMP header length is the same */
>  		snap_offs += IEEE80211_CCMP_HDR_LEN;

I understand now though - the problem is that snap_offs isn't used in
__ieee80211_rx_h_amsdu(), and thus we can't do the necessary
adjustments.

I think though that perhaps it'd be better to teach
__ieee80211_rx_h_amsdu() about snap_offs, because assuming in the AMSDU
decap code that snap_offs is more-or-less constant will just make the
dependencies much harder to understand.

Better teach __ieee80211_rx_h_amsdu() about snap_offs, and make the
assumption on the constant in ieee80211_rx_h_amsdu()?


> +	if (status->rx_flags & IEEE80211_RX_AMSDU) {
> +		res = __ieee80211_rx_h_amsdu(rx);
> +		if (res != RX_QUEUED)
> +			goto drop;
> +
> +		return true;
> +	}

Btw, you also don't need the "res" variable, much less at function
scope; this block would do if at all, but also it should probably use
the right enum type or just be removed.

johannes
