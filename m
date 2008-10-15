Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:46925 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbYJOSZZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 14:25:25 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Oct 2008 11:25:25 -0700
Date: Wed, 15 Oct 2008 04:25:17 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Marcel Holtmann <holtmann@linux.intel.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Zhu Yi <yi.zhu@intel.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: New Regulatory Domain Api.
Message-ID: <20081015112517.GF6509@tesla> (sfid-20081015_202530_041275_7F8BADB6)
References: <43e72e890810140204ne135e72kefe379dd3d26f7bc@mail.gmail.com> <20081014203510.GD3349@tuxdriver.com> <1224018957.3027.9.camel@johannes.berg> <20081014211912.GF3349@tuxdriver.com> <1224019662.3027.13.camel@johannes.berg> <1224085609.4764.18.camel@californication> <1224086374.735.4.camel@johannes.berg> <1224091577.28173.9.camel@californication> <43e72e890810151039s34ad8d79nd2744847dd254b4e@mail.gmail.com> <1224092868.28173.21.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1224092868.28173.21.camel@californication>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 15, 2008 at 10:47:48AM -0700, Marcel Holtmann wrote:
> Hi Luis,
> 
> > > I can see it useful when companies actually start building products with
> > > two or more cards in the system and have different cards for different
> > > tasks in it. So if you stick one card for one band and another one for
> > > the other band in there, then it would make sense to do a per-band
> > > regulatory hinting.
> >
> > Sure, but custom solutions can require custom regulatory dbs and
> > people can do any crazy thing they want here, just as when they need
> > custom regulatory domains not allowed by the FCC in the USA for
> > example. Remember that by default the design is trying to cover the
> > usual scenario of users with 1 wireless card or 2 with one built in.
> > We decided on our discussions to respect the built-in card first. For
> > more cards we can take the intersection if we want to keep being more
> > restrictive. Its what makes sense if you think about it.
> 
> I must admit that I never thought about the implications of multiple
> bands with multiple hardware. I am not against keeping it simple and
> forcing to have userspace in place to change it. However we do wanna
> have support for old laptops that are currently working fine with no
> extra userspace, but newer kernels where they just add the second card
> to access an A-network. Also remember that internal cards can't really
> be disabled most of the times.

So you mean you worry about cases where people are using kernels >=
2.6.28 without crda and iw? If so then they can use for 2.6.28 the
OLD_REGULATORY but the idea is for sure to push crda and iw for
distributions definitley as of 2.6.29 for when OLD_REGULATORY is
scheduled for removal.

The problem here is not this though the problem here is the case
where people are using 2.6.28 without no iw or crda *and* have more
than two cards :)

> > > Not sure if this really ever ends up in a product. However I can see the
> > > case where you have a laptop with a BG-card and then attach an A-card to
> > > it do access an A-network and then it doesn't work. It would be nice to
> > > just have this working. Currently this would not work.
> >
> > Yes it does, it just doesn't work for your hardware as Intel put into
> > regulatory hardware capability and these are two *very* different
> > things. That is the problem.
> >
> > My suggestion is to add a default minimal 5 GHz regulatory domain
> > definition to your driver on single band cards to deal with this. When
> > a dual band card is present then all of the full card's capabilities
> > will be used.
> 
> That would be one option, but it sounds really strange to me that a
> BG-card has to "think" about A-bands.

Don't think about it that way -- instead think of it this way: Intel
EEPROM is used for capability stuff but its now also being used for
regulatory and that is what is limitting you. So you *can* think about
5 GHz band for a single 2.4 GHz band card, its just that your regulatory
stuff right now is focused more on capabilities and not real regulatory.

> Let not try to put this down into the drivers if we can solve this
> nicely with a per-band regulatory hints inside the core.

Good point. This is reasonable as well, perhaps if the regulatory hint
has no 5 Ghz band channels it should not imply policy on it at all?
Should be simple enough to fix too I think instead of having two
regulatory_hint() calls per band.

> > > Also the case when we unplug the first card, does the regulatory hint
> > > gets reset and the next card could bring in a new one? I can see use
> > > cases where you don't wanna use the built-in card, because it is just
> > > too limited.
> >
> > For now nl80211 supports changing regulatory domains.
> 
> Please keep in mind the case where we do have a new kernel with old
> userspace or an userspace without CRDA.

Sure, what do you think of the above?

  Luis
