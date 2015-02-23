Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35216 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbbBWVwn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 16:52:43 -0500
Message-ID: <1424728360.1899.3.camel@sipsolutions.net> (sfid-20150223_225246_802504_8A0F3B9D)
Subject: Re: [RFC] mac80211: use rhashtable for station table
From: Johannes Berg <johannes@sipsolutions.net>
To: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>
Date: Mon, 23 Feb 2015 22:52:40 +0100
In-Reply-To: <CAHNKnsR0j1u6Eu2e19pzcu2Rw7nZ6D6BKV-cRg9KTwoKO74fdQ@mail.gmail.com> (sfid-20150223_222714_678902_C1EA88E2)
References: <1423864049-8961-1-git-send-email-johannes@sipsolutions.net>
	 <CAHNKnsSm1GOUMONPB4oB1tJ-OeWOG1XOhw=HEY8LPXhDEHEjbg@mail.gmail.com>
	 <1424709235.3075.22.camel@sipsolutions.net>
	 <CAHNKnsR0j1u6Eu2e19pzcu2Rw7nZ6D6BKV-cRg9KTwoKO74fdQ@mail.gmail.com>
	 (sfid-20150223_222714_678902_C1EA88E2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-02-24 at 00:26 +0300, Sergey Ryazanov wrote:

> > Well - not sure what you're trying to say? First you're saying jhash()
> > was clearly better and then you're saying I shouldn't use it? ;-)
> >
> In first case, I mean the jhash _algorithm_, which has a better
> distribution, in second case I mean the _generic_ jhash() _function_
> and express my doubts about its performance. See below.

Ah.

> I agree that hashing all octets is not a drawback. But the jhash()
> function is tailored to the input data of variable length, while we
> have a vector of fixed length and appropriate functions. Could we do
> the hashing in following way:
> 
> u32 sta_info_hash(void *addr, u32 len, u32 seed)
> {
>   u32 *k = addr + 2;
>   return jhash_1word(*k, seed);
> }

This would work, but without the LA bit obviously.

> or even (to account LA bit):
> 
> u32 sta_info_hash(void *addr, u32 len, u32 seed)
> {
>   u32 *k = addr;
>   return jhash_2words(k[0], k[1], seed);
> }

This won't exactly work as there's no known padding there so that k[1]
accesses invalid data, but I get the point. It should then be 

> This could save a couple of CPU circles and a couple of bytes in the
> output image :)

I don't think it would save bytes? The jhash function is common after
all. Ah, but it's an inline, so it would be generated here.

We also can't rely on 4-byte alignment though, so perhaps we should do
something like

u32 sta_info_hash(void *addr, u32 len, u32 seed)
{
	u16 *a = addr;

	return jhash_3words(a[0], a[1], a[2], seed);
}

instead? Not sure what effect that has on jhash though if we don't have
anything in the high 16 bits.

johannes

