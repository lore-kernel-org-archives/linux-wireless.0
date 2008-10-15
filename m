Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:60349 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbYJORZk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 13:25:40 -0400
Subject: Re: New Regulatory Domain Api.
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Zhu Yi <yi.zhu@intel.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1224086374.735.4.camel@johannes.berg>
References: <B27EBC40D200ED48A3F4CC2EBEABAE0B16C892F2@orsmsx501.amr.corp.intel.com>
	 <20081009154547.GB13349@tesla>
	 <1223608949.2510.1061.camel@debian.sh.intel.com>
	 <43e72e890810100949i78c1d813x1b66c6bc0239ef28@mail.gmail.com>
	 <1223967581.2570.144.camel@debian.sh.intel.com>
	 <43e72e890810140004k6bfa72edsf39acbafcf317fa6@mail.gmail.com>
	 <1223969808.2570.153.camel@debian.sh.intel.com>
	 <43e72e890810140204ne135e72kefe379dd3d26f7bc@mail.gmail.com>
	 <20081014203510.GD3349@tuxdriver.com>
	 <1224018957.3027.9.camel@johannes.berg>
	 <20081014211912.GF3349@tuxdriver.com>
	 <1224019662.3027.13.camel@johannes.berg>
	 <1224085609.4764.18.camel@californication>
	 <1224086374.735.4.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 15 Oct 2008 19:26:17 +0200
Message-Id: <1224091577.28173.9.camel@californication> (sfid-20081015_192545_378456_8970C042)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > > The only reasonable solution I can come up with is have it make separate
> > > hints for 2.4 and 5 GHz and then a single-band card won't say anything
> > > about 5 GHz so the dual-band gets to set that part. But OTOH I don't see
> > > a reasonable use-case for this whole thing so far---we really only added
> > > this after discussions with Marcel at OLS so embedded systems can
> > > function w/o crda, but who would build an embedded system with two
> > > different cards like that?
> > 
> > and we need to keep it this way. For example the first card can be a
> > dual-band card, but the EEPROM value restricts it one band. That might
> > be by choice. 
> 
> Interesting point. I didn't think that was possible.

the question is if that makes sense. Currently the dual-band cards are
more expensive than single-band cards, but I expect that to change and
we only see dual-band cards in the future. However then is the question
why not support both bands. So it is possible, but I think an unlikely
case at the moment.

There is a difference in the hardware capabilities and the EEPROM
settings for regulatory enforcement.

> > Then attaching a second card, we can't just extend it and
> > let this card go ahead and use the second band.
> 
> True. Well, not entirely true, because the first card would
>  (1) register its eeprom channels as the regulatory domain for one band
>  (2) register only the eeprom channels as the per-hw channels
> 
> so when the second card adds the regulatory domain for the second band
> the first card still cannot use the extra channels because it doesn't
> have those registered in its wiphy.
> 
> However, this really gets complicated. Do we need to go there?

I can see it useful when companies actually start building products with
two or more cards in the system and have different cards for different
tasks in it. So if you stick one card for one band and another one for
the other band in there, then it would make sense to do a per-band
regulatory hinting.

Not sure if this really ever ends up in a product. However I can see the
case where you have a laptop with a BG-card and then attach an A-card to
it do access an A-network and then it doesn't work. It would be nice to
just have this working. Currently this would not work.

Also the case when we unplug the first card, does the regulatory hint
gets reset and the next card could bring in a new one? I can see use
cases where you don't wanna use the built-in card, because it is just
too limited.

Regards

Marcel


