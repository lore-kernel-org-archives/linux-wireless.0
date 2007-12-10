Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:64442 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbXLJQKH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 11:10:07 -0500
Received: by wa-out-1112.google.com with SMTP id v27so3427679wah
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2007 08:10:06 -0800 (PST)
Message-ID: <1ba2fa240712100810s1216bee4v8142fb9a279feedf@mail.gmail.com> (sfid-20071210_161012_262781_5D37E96A)
Date: Mon, 10 Dec 2007 18:10:06 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: coding style lesson: iwlwifi vs. endianness
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Dan Williams" <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu Yi" <yi.zhu@intel.com>,
	"Reinette Chatre" <reinette.chatre@intel.com>
In-Reply-To: <1197299937.6035.81.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1196189059.6058.95.camel@johannes.berg>
	 <1ba2fa240711281020n6052980cl610f6c790788d2da@mail.gmail.com>
	 <1196286192.4967.29.camel@localhost.localdomain>
	 <20071129005810.GA6161@tuxdriver.com>
	 <1ba2fa240711291502k65cefd5au60f2c22d6f436c82@mail.gmail.com>
	 <1197286949.6035.49.camel@johannes.berg>
	 <1ba2fa240712100618g35a8e13ve143f8687f1b531a@mail.gmail.com>
	 <1197299937.6035.81.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > I'm not buying this logical boundary definition if you don't do clean
> > cut you still have to be endian aware across the whole code so what's
> > a difference.
>
> No, you only have to be endian aware when you do a load from a structure
> you *know* was/is DMAed from/to the card. That's a world of a
> difference.

I'm not only loading the structure I'm using it all over the code. I
don't have clean cut. You can blame me for that but that's another
discussion.

> >  b = le_to_cpu(a)
> >  b != FLAG
> >  a = cpu_to_le(b)
> >  is probably longer then
> >  a |= FL:AG_LE;
> >  n matter what.
>
> Obviously, with a flag this is true. But if you see my example below
> then you'll realise that most of the time you don't just do a single
> flag in a but multiple multi-bit values.
>

We are going around the same issue all gain. I already agreed that
your approach will be correct if we had more code of your example type
then setting bits. But we are mostly setting bits.

> Not considering single bits, you will have fewer swap operations as I've
> shown in my example code. And you're only hiding the fact that you have
> many more logical swap operations, most of which are of course constant,
> when you do consider single bits.
>

Again we have mostly bit setting.


> There's nothing you can fix here. It's not an exemption of your
> approach, it's a logical consequence of your approach. Making exemptions
> for things like this in your approach will imho most likely make the
> code even worse. But I'm interested to see how you want to "fix" this
> without going to CPU-defined constants instead of LE-defined constants.

_POS are (shift constants) are native defined.

> And once you start *mixing* the two approaches things will *really* be
> confusing, so you really do need to write it the way I wrote (almost
> quoted but simplified).

Yes,  something like that.
>

This is really arguing about taste and feel. I don't find it more
confusing then any mixture of native and some-endian platform. I don't
know how to measure it but I didn't see any endianity bug for more
then 6 months  so I guess my approach is working.

In addition it all may change as we cleanup the code.
Tomas
