Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:34776 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbZK0LIk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2009 06:08:40 -0500
Received: by bwz27 with SMTP id 27so1086927bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 27 Nov 2009 03:08:45 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 06/12] wl1251: fix payload alignment
References: <20091126150141.917.35278.stgit@tikku>
	<20091126150904.917.8182.stgit@tikku> <877htd9v5a.fsf@purkki.valot.fi>
	<1259259183.24540.0.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 27 Nov 2009 13:08:43 +0200
In-Reply-To: <1259259183.24540.0.camel@johannes.local> (Johannes Berg's message of "Thu\, 26 Nov 2009 19\:13\:03 +0100")
Message-ID: <873a409qdg.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2009-11-26 at 17:13 +0200, Kalle Valo wrote:
>> Kalle Valo <kalle.valo@iki.fi> writes:
>> 
>> > mac80211 complained that in some cases IP payload was not aligned, this
>> > happens if the 802.11 header is not aligned with four. In that case we have
>> > to move entire packet to make the payload properly aligned.
>
> Eh, turn off the debugging option ...

Sure. But isn't this warning going to create false alarms for others?

>> > +	if (ieee80211_hdrlen(*fc) & 0x3) {
>> > +		from = skb->data;
>> > +		to = skb_push(skb, 2);
>> > +		memmove(to, from, skb->len);
>> > +		fc = (u16 *) skb->data;
>> > +	}
>> 
>> I would like to get comments about this. Is memmove() the right way to
>> do this?
>
> mac80211 takes care of this for you, after warning :)

Damn, I missed that :)

> The point of the warning is to make developers aware that alignment by
> firmware will be better. If you can't put the packet into the right
> place directly from the device, don't bother, the memmove is done by
> mac80211.

Ok, I have totally misunderstood the warning then. What's the proper
way to fix this? I'll try to improve the comments in mac80211 to make
this more clear.

At least in wl1251 we have to transfer the frame to an address aligned
with four, otherwise DMA won't work. So the only solution I can think
of is that firmware adds two bytes of padding before the frame in case
of unaligned payload. Is there any other way?

-- 
Kalle Valo
