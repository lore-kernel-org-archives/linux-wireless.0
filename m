Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:50368 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbYJUQjF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 12:39:05 -0400
Subject: Re: New Regulatory Domain Api.
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Zhu Yi <yi.zhu@intel.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Tomas Winkler <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1224572722.27899.87.camel@johannes.berg>
References: <20081015112517.GF6509@tesla>
	 <1224484685.18024.5.camel@johannes.berg>
	 <43e72e890810192346q5e0eadbcm26febe45392a2172@mail.gmail.com>
	 <1224485431.18024.12.camel@johannes.berg>
	 <43e72e890810192359g2bc75316v49377ddc9eded934@mail.gmail.com>
	 <1224487340.24677.192.camel@debian.sh.intel.com>
	 <1224520999.9386.72.camel@californication>
	 <1224552899.24677.245.camel@debian.sh.intel.com>
	 <43e72e890810201842o44db616ekd8d5bc66cd1006f@mail.gmail.com>
	 <1224554323.24677.248.camel@debian.sh.intel.com>
	 <43e72e890810201937l3be24156t2172590138fda132@mail.gmail.com>
	 (sfid-20081021_043804_334625_50CEDAE0)  <1224572722.27899.87.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 18:39:56 +0200
Message-Id: <1224607196.9386.91.camel@californication> (sfid-20081021_183911_132098_FCD82486)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> >  There are many
> > design flaws with this; an obvious problem to this is what is a band?
> > In my patch I took the liberty to define that a frequency is part of a
> > band if a rule was present within 2 GHz of itself. This works but it
> > is trying to make a definition out of something that doesn't exist --
> > its trying to solve the wrong problem. Since regulatory database is in
> > KHz it is designed to allow us to grow regardless of band notions or
> > associations. In the regulatory database we allow for 2 GHz, 5 GHz,
> > etc KH  definitions for any country and this was designed to account
> > for misinformation on drivers to help the user be more compliant. By
> > changing the design to what you are suggesting you'd have to add a
> > dummy rule for every frequency "band" if you really want to disable
> > all other bands.
> 
> Yes, this is a problem, but then again it's fairly well-defined which is
> 2.4 and which is 5 GHz band, and it probably doesn't matter much at this
> point. cfg80211 _has_ a notion of bands.
> 
> If we really wanted to have band-specific hints to let a driver say
> "nay, sorry, I know nothing about 5 GHz" then we can I think do this,
> subject to a few constraints:
>  * first hint that contains a band wins this band
>  * without any other information, a band that we know nothing about is
>    disabled (just like the default state would be when we know nothing
>    at all)
> 
> This ought to be possible, maybe by simply moving from
> 
> regulatory_hint(alpha2, structure)
> 
> to
> regulatory_hint(alpha2)
> 
> regulatory_struct_hint(structure, bandflags)
> 
> where bandflags can be BIT(IEEE80211_BAND_2GHZ) or
> BIT(IEEE80211_BAND_5GHZ). It would be fairly easy to keep track of that
> information and build a common struct. No need to even bother looking at
> the frequencies, when you have a 2GHZ hint and get a 5GHZ one you simply
> add all the rules from the new hint. Yes, that could be abused to add
> more 2GHz rules, but we can "police" that code. And it can only be
> abused once because when the bit is already set we ignore the hint
> anyway.

I was more thinking about

	regulatory_band_hint(band, structure)

and then you have to call it twice if you have 2.4 GHz and 5 GHz support
with your hardware. But your solution also works.

> > The proper solution is to either add 5 GHz regulatory rules to your
> > regulatory_hint() 
> 
> I strongly disagree with that. It's not correct in any way.

Yeah. A driver for 2.4 GHz hardware should not even think about any
other channels :)

Regards

Marcel


