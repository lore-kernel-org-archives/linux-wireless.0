Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:46174 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755696AbZFHPVO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 11:21:14 -0400
From: Michael Buesch <mb@bu3sch.de>
To: gregor kowski <gregor.kowski@gmail.com>
Subject: Re: [PATCH] b43 add harware tkip
Date: Mon, 8 Jun 2009 17:20:59 +0200
Cc: linux-wireless@vger.kernel.org
References: <83a869cd0906071450h24ed4119s44d00db0d97d59e2@mail.gmail.com>
In-Reply-To: <83a869cd0906071450h24ed4119s44d00db0d97d59e2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200906081720.59594.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Well, first thing is that I do think there is a reason Broadcom removed hw TKIP
support from their drivers. ;)

But well, let's look at the patch.

> +	/* FIXME this is the wrong offset : it goes in tkip rx phase1 shm */
> +#if 0
>  	b43_write_probe_resp_plcp(dev, 0x31A, size, &b43_b_ratetable[0]);
>  	b43_write_probe_resp_plcp(dev, 0x32C, size, &b43_b_ratetable[1]);
>  	b43_write_probe_resp_plcp(dev, 0x33E, size, &b43_b_ratetable[2]);
>  	b43_write_probe_resp_plcp(dev, 0x350, size, &b43_b_ratetable[3]);
> +#endif

This looks interesting. Care to find out the correct offsets and submit
this fix as a separate patch?

> +	if (algorithm == B43_SEC_ALGO_TKIP) {
> +		/*
> +		 * We should provide an initial iv32, phase1key pair.
> +		 * We could start with iv32=0 and compute the corresponding
> +		 * phase1key, but this mean calling ieee80211_get_tkip_key
> +		 * with a fake skb (or export other tkip function).
> +		 * Because we are lazy we hope iv32 won't start with
> +		 * 0xffff and let's b43_mac_update_tkip_key provide a
> +		 * correct pair.
> +		 */
> +		rx_tkip_phase1_write(dev, index, 0xffff, (u16*)buf);
> +	} else /* clear it */
> +		rx_tkip_phase1_write(dev, index, 0, (u16*)buf);

Why do you write phase1, if TKIP is not used?

> +	/* FIXME : for b43_new_kidx_api, there can be 54 key
> +	 * instead of 50 in RCMTA and TKIPTSCTTAK.
> +	 */

I don't understand this comment.

> -		if (algorithm == B43_SEC_ALGO_TKIP) {
> -			/* FIXME: No TKIP hardware encryption for now. */
> +		if (algorithm == B43_SEC_ALGO_TKIP &&
> +				(!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE) ||
> +				   key->flags & IEEE80211_KEY_FLAG_WMM_STA )) {
> +			/* We support only one rx queue (no QOS) and pairwise key */

This comment doesn't really make sense to me, too.
What does QoS have to do with the RX queue?


Next time please inline the patch ;)

-- 
Greetings, Michael.
