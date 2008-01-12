Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.185]:41651 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbYALMo4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jan 2008 07:44:56 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1214036rvb.1
        for <linux-wireless@vger.kernel.org>; Sat, 12 Jan 2008 04:44:55 -0800 (PST)
Message-ID: <c85cb4470801120444h6599196cpd08e7aacbb86578e@mail.gmail.com> (sfid-20080112_124507_047251_62C37D8C)
Date: Sat, 12 Jan 2008 14:44:55 +0200
From: "Ron Rindjunsky" <rindjon@googlemail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: A-MSDU reception vs. IP alignment
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1200013940.3861.142.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1200013940.3861.142.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

agree, this fix will put the payload as 4 aligned in A-MSDU,
yet i also saw your thread with netdev, so i'll examine the issue once more

> Hi Ron,
>
> Even when we align the packet as indicated in the patch I just sent, we
> can still copy the payload of an A-MSDU packet to a badly aligned place.
>
> Could you maybe look into fixing that? Basically, I think all we need is
> change
>
>                        skb_reserve(frame, local->hw.extra_tx_headroom +
>                                    sizeof(struct ethhdr));
>
> to something like
>
>                resv = ETH_HLEN + extra_tx_headroom;
>                if (resv % 4 != 2)
>                        resv += 2 + (resv % 2);
>                skb_reserve(frame, resv);
>
> (allocating an appropriately sized skb of course)
>
> On the other hand, I also wrote in a note with that warn-on patch that
> we can probably save the copying completely by simply doing a clone and
> adjusting the length/offset properly. We already make a copy of the
> frame in ieee80211_deliver_skb() when we pass it back for sending to the
> wireless medium so that should be safe. And it'd be much more efficient
> than copying all frames. I'd appreciate if you could look into it.
>
> Thanks,
> johannes
>
>
