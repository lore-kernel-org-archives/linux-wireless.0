Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:37250 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbYKZArk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 19:47:40 -0500
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 25 Nov 2008 16:47:40 -0800
Date: Tue, 25 Nov 2008 16:47:38 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Richard Farina <sidhayn@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Michael Green <Michael.Green@Atheros.com>
Subject: Re: wireless-regdb: update regulatory rules for US 2.3-2.4GHz and
	5.65-5.925GHz
Message-ID: <20081126004738.GO5950@tesla> (sfid-20081126_014744_886240_5F8FD195)
References: <492B2E07.9050105@gmail.com> <20081124230427.GM6245@tesla> <492B3643.4070904@gmail.com> <43e72e890811241530t44245e4ar3fd5797afcc451c0@mail.gmail.com> <492B57E8.2010101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <492B57E8.2010101@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 24, 2008 at 05:42:00PM -0800, Richard Farina wrote:
> Luis R. Rodriguez wrote:
> > On Mon, Nov 24, 2008 at 3:18 PM, Richard Farina <sidhayn@gmail.com> wrote:
> >
> >> Luis R. Rodriguez wrote:
> >>
> >>> On Mon, Nov 24, 2008 at 02:43:19PM -0800, Richard Farina wrote:
> >>>
> >>>
> >>>> The above frequencies are allowed by FCC part 97 to amateur radio
> >>>> operator as primary use, this doesn't even cover the secondary and
> >>>> tertiary uses, just where amateurs are primary.
> >>>>
> >>>>
> >>> NACK -- For the US we use the wireless regulatory database for Part 15
> >>> rules with 802.11 in mind.
> >>>
> >>>
> >>>
> >> Not only do I understand your reasoning, but I also agree.  Please do
> >> consider the following (from that same email):
> >>
> >
> > Thanks :)
> >
> >
> >> This also introduces a new issue in crda of setting not only power limits
> >> but power limits based on modulation.  It is permitted to use DSSS up to 100
> >> watts, however, OFDM is permitted up to 1500 watts.
> >>
> >> Would it be an unreasonable request to have crda support modulation
> >> restrictions and power limit based on modulation restrictions?
> >>
> >
> > This is odd, first time I hear about such a thing. Do you have a
> > pointer to Part 15 rules which clarifies this?
> >
> >
> Again, I'm only familiar with FCC regulations but I don't believe this
> is required for Part 15.

CRDA only speaks Part 15 rules for FCC as its only used for
802.11 right now. Feel free to expand it to use other stuff
but we also need to ensure it keeps working as it was and
there will also need to be a good use case for it to be merged.

> The IEEE802.11 rules do allow for some odd
> stuff but the really odd stuff tends to be handled in hardware.  For
> instance, we can only use OFDM on the 5GHz bands, no DSSS is permitted.

DSSS is used for 802.11b and pre 802.11b only, covered under
IEEE-802.11-2007 section 15 and are for rates 1Mbit/s and 2Mbit/s.

> The hardware handles this for us I think, that or somewhere deep dark
> and scary that I've never seen in the driver.

Since this is 802.11{FOO} related we need not care about it as yes, it
is hardware specific.

> Additionally .11a
> provides three different transmit power levels based on the frequency
> band you are in (and the use case).

CRDA is band agnostic on purpose -- originally I started with UNII band
notion stuff but that got pretty silly quickly. Johannes also knocked
some good sense into me.

What we have now allows us human creatures to assign name values to
whatever bands we want at any point in time and not worry about
what name they fall under, and it still works. This makes it more
FCC agnostic, which became a very important requirement. So please
consider *all* regulatory agencies when thinking about the overall
design of CRDA.

> What I would need this additional
> feature for is licensed use 

User your own custom database and CRDA! That's one of the reasons
why it was ISC licensed. Go do what you like with your own db (including
using sharks with lasers on their head).

> but I'm sure that somewhere in the world,
> someone has a unlicensed limitation such that would make this relevant.

When you do find concrete evidence, instead of speculating, please do
submit a patch and document your findings.

> I suppose we can all wait around until I can successfully google such a
> case or someone with relevant first hand experience comes along, but
> frankly, if it isn't that painful to do it would allow the licensed
> users a much greater flexibility to use the hardware without
> accidentally breaking the law.

CRDA allows for custom solutions, if you know what you are doing
and have a license for it, go wild.

> Please consider it a request without
> official requirement, if someone is bored, great, otherwise I'll either
> learn to code better or find someone who is bored :-)

Please only bother with sending patches which work for unlicensed
communication devices usage only.

  Luis
