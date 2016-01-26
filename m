Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39784 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965242AbcAZNsj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 08:48:39 -0500
Message-ID: <1453816116.2759.64.camel@sipsolutions.net> (sfid-20160126_144842_052941_2EAB74AB)
Subject: Re: [RFC/RFT v4 2/2] mac80211: add NEED_ALIGNED4_SKBS hw flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 26 Jan 2016 14:48:36 +0100
In-Reply-To: <1453368625-3615-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20160121_103042_364939_C8B32286)
References: <1453368625-3615-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1453368625-3615-2-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20160121_103042_364939_C8B32286)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-01-21 at 10:30 +0100, Janusz Dziedzic wrote:
> 
> +static inline unsigned int
> +__ieee80211_hdrlen(struct ieee80211_hw *hw, __le16 fc) {

coding style - should have that brace on the next line

perhaps this really ought to be called

ieee80211_padded_hdrlen() or so instead of just the __.


> +	unsigned int hdrlen;
> +
> +	hdrlen = ieee80211_hdrlen(fc);
> +	if (ieee80211_hw_check(hw, NEEDS_ALIGNED4_SKBS))
> +		hdrlen += hdrlen & 3;

This needs a a comment, it only works because the hdrlen is guaranteed
to be a multiple of 2 already. Perhaps it should be & 2 ;-)

> -	u8 hdr[30 + 2 + IEEE80211_FAST_XMIT_MAX_IV +
> -	       sizeof(rfc1042_header)];
> +	u8 hdr[round_up(30 + 2 + IEEE80211_FAST_XMIT_MAX_IV +
> +			sizeof(rfc1042_header), 4)];

I'm still not sure this is right, given the position of the padding. It
probably works since MAX_IV and sizeof() are divisible by 4, but
shouldn't it really be

round_up(30 + 2, 4) + MAX_IV + sizeof()?

> +	/* Remove padding if was added */
> +	if (ieee80211_hw_check(&local->hw, NEEDS_ALIGNED4_SKBS)) {
> +		hdrlen = ieee80211_hdrlen(hdr->frame_control);
> +		padsize = hdrlen & 3;

same as above

> +	/* Check if HW require skb to be aligned */
> +	if (ieee80211_hw_check(&sdata->local->hw,
> NEEDS_ALIGNED4_SKBS))
> +		padsize = hdrlen & 3;
> 

ditto

Perhaps also extract this if (...) padsize=... into a helper? Although
then the "hdrlen += 0" would remain for !ALIGNED4 drivers.

> +	if (padsize)
> +		skb_push(skb, padsize);

You should initialize the memory, imho, just in case it goes out
anywhere by accident.
 
> +	/* Check if aligned skb required */
> +	if (ieee80211_hw_check(&local->hw, NEEDS_ALIGNED4_SKBS))
> +		build.hdr_len += build.hdr_len & 3;

As above.

You also need to clarify - IIRC the PN/IV fields are considered part of
the MAC header even if we don't really take them into account in
hdrlen(), so you should clearly document that the padding is before
those.

johannes
