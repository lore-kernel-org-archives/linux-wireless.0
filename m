Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.229]:33956 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026AbYAHPoK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2008 10:44:10 -0500
Received: by nz-out-0506.google.com with SMTP id s18so1843499nze.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jan 2008 07:44:09 -0800 (PST)
Message-ID: <1ba2fa240801080744u5a076202n91f11b0de87384f8@mail.gmail.com> (sfid-20080108_154414_787777_04C5AE13)
Date: Tue, 8 Jan 2008 17:44:08 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: Warning emited by 2.6.24-rc6-git5
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	chris2553@googlemail.com, linux-wireless@vger.kernel.org
In-Reply-To: <200801022012.52287.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200712290942.37396.chris2553@googlemail.com>
	 <200712291614.55732.IvDoorn@gmail.com>
	 <1199261473.4172.58.camel@johannes.berg>
	 <200801022012.52287.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 2, 2008 9:12 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> Hi,
>
> > Happy New Year!
>
> You too. :)
>
> > I was out since Saturday just before you sent your
> > message, sorry for the late reply.
> >
> > >     header_size = ieee80211_get_hdrlen_from_skb(entry->skb);
> > >     if (header_size % 4 == 2) {
> > >             /*
> > >              * Move entire frame 2 bytes to the front.
> > >              */
> > >             skb_push(entry->skb, 2);
> > >             memmove(entry->skb->data, entry->skb->data + 2,
> > >                     entry->skb->len - 2);
> > >     }
> >
> > That doesn't really look right, I'd think the skb will be two bytes too
> > long after this.

> For PCI drivers I could indeed optimize the code by making the memcpy
> perform the operation on the 4 byte aligned code. But for this I need
> to check what is better, RX directly into a skbuff and use memmove
> or RX into DMA and use memcpy to a skbuff.
> But for USB this is not possible, since it directly performs the RX into
> the skbuff already, so I either have to change that or perform memmove anyway.
>
> > If you absolutely can't get the hardware to do it and would otherwise do
> > DMA right into the skb we should try to evaluate the performance hit on
> > platforms where unaligned access *is* possible to be able to balance it
> > against the performance hit caused by the memmove(). Ultimately, though,
> > I value correctness on all platforms over performance on some, hence the
> > warning when unaligned packets are handed up to mac80211.
>
> Overall correctness sounds as the best solution to me too.

I see it now happening in iw4965
I didn't test the copy solution yet but in 11n rates I see as a show
stopper. All 11n packets are QoS packets.
I haven't encounter a problems in net stack yet so I think this
solution is a bit drastic.

Thanks
Tomas

Tomas


> Ivo
