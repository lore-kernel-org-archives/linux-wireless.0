Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:33540 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278Ab0ETAvq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 20:51:46 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 19 May 2010 17:51:46 -0700
Date: Wed, 19 May 2010 17:51:43 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bruno Randolf <br1@einfach.org>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [ath5k-devel] [PATCH v2 13/20] cfg80211: Add nl80211 antenna
 configuration
Message-ID: <20100520005143.GB10702@tux>
References: <20100519012528.22206.77550.stgit@tt-desk>
 <20100519013147.22206.71360.stgit@tt-desk>
 <AANLkTikgyTZptw5CGu8MFinkqlXeqEJMJixdckb89aFc@mail.gmail.com>
 <201005200935.40377.br1@einfach.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <201005200935.40377.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 19, 2010 at 05:35:40PM -0700, Bruno Randolf wrote:
> On Thursday 20 May 2010 02:07:25 you wrote:
> > On Tue, May 18, 2010 at 6:31 PM, Bruno Randolf <br1@einfach.org> wrote:
> > > + * @NL80211_ATTR_ANTENNA_TX: Bitmap of antennas to use for transmitting.
> > > + * @NL80211_ATTR_ANTENNA_RX: Bitmap of antennas to use for receiving.
> >
> > This gets the job done, but that's it. The API defined allows for a
> > hugely loose implementation on each driver.
> 
> i tried to define it like this, in the commit log:
> 
>     The antenna configuration is defined as a bitmap of allowed antennas. This
>     bitmap is 8 bit at the moment, each bit representing one antenna. If   
>     multiple antennas are selected, the driver may use diversity for receive
>     and transmit.
> 
> is this not precise enough?

No, the commit log is just a placeholder of information, if you want to
define API you do it through the kdoc so you can slap people when then
submit patches that do not follow it. The kdoc above allows the flexibility
you were looking for but that I do not think we should have since it will
confuse the users who want to tune antenna settings on different drivers.

I'd much prefer to see a consistant API for antenna settings so that if
they know how to do it with ath5k, then they know how to do it for b43,
or whatever.

> i am mostly concerned with what i believe is the 
> most common usecase (selecting one fixed antenna, or antenna diversity).

In that case, then I recommend to restrict your patch to that case, and
forget about a bitmask. Since lagcy just has antenna A, B, or auto, how
about defining an API for just that?

> i'd say this is 99% of all use cases.

For now, yes. I'm thinking about 802.11n though and for that we can
just wait, and use some other API once someone with more time wants
to iron it out.

> but this API would also allow us to define 
> more advanved things like 'transmit on antenna 1, receive on antenna 2". 

Sure.

> i know that there are possibly more crazy (and very rare) configurations, like 
> use several panel antennas + omni, which can't be configured with this API, 

How about we ignore those then on this API.

> but it's hard to find a common API for all possibilities, and i think it would 
> be possible to extend the API later on for such cases.

Understood, how about just defining something very basic and simple
for legacy based operation mode?

> > And yet for another driver it could be something completely different
> > in usersepace. 
> 
> what do you think that could be, realistically, given the above definition?

Well, anything that has to do with tx / rx antennas.

> > I think it would be better for us to define a static
> > API for all legacy cards and another for 802.11n cards, or unify them
> > but to be very specific about the API for antenna settings/chainmask
> > settings.
> 
> sure. any suggestions?

Sure how about FIXED_A, FIXED_B, DIVERSITY ?

  Luis
