Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:4550 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752967Ab0ETBMS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 21:12:18 -0400
Received: from vs3003.wh2.ocn.ne.jp (125.206.180.231)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0150227936
	for <linux-wireless@vger.kernel.org>; Thu, 20 May 2010 10:12:17 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [ath5k-devel] [PATCH v2 13/20] cfg80211: Add nl80211 antenna configuration
Date: Thu, 20 May 2010 10:12:11 +0900
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
References: <20100519012528.22206.77550.stgit@tt-desk> <201005200935.40377.br1@einfach.org> <20100520005143.GB10702@tux>
In-Reply-To: <20100520005143.GB10702@tux>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201005201012.12045.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 20 May 2010 09:51:43 Luis R. Rodriguez wrote:
> On Wed, May 19, 2010 at 05:35:40PM -0700, Bruno Randolf wrote:
> > On Thursday 20 May 2010 02:07:25 you wrote:
> > > On Tue, May 18, 2010 at 6:31 PM, Bruno Randolf <br1@einfach.org> wrote:
> > > > + * @NL80211_ATTR_ANTENNA_TX: Bitmap of antennas to use for
> > > > transmitting. + * @NL80211_ATTR_ANTENNA_RX: Bitmap of antennas to
> > > > use for receiving.
> > > 
> > > This gets the job done, but that's it. The API defined allows for a
> > > hugely loose implementation on each driver.
> > 
> > i tried to define it like this, in the commit log:
> >     The antenna configuration is defined as a bitmap of allowed antennas.
> >     This bitmap is 8 bit at the moment, each bit representing one
> >     antenna. If multiple antennas are selected, the driver may use
> >     diversity for receive and transmit.
> > 
> > is this not precise enough?
> 
> No, the commit log is just a placeholder of information, if you want to
> define API you do it through the kdoc so you can slap people when then
> submit patches that do not follow it. The kdoc above allows the flexibility
> you were looking for but that I do not think we should have since it will
> confuse the users who want to tune antenna settings on different drivers.

you are talking about the place where to put the definition, not about the 
definition itself. i agree, the definition should be in the kdoc, and i'll 
update the patch. what's wrong with the definition itself?

> I'd much prefer to see a consistant API for antenna settings so that if
> they know how to do it with ath5k, then they know how to do it for b43,
> or whatever.

that's what i'm trying to achieve...

> > i am mostly concerned with what i believe is the
> > most common usecase (selecting one fixed antenna, or antenna diversity).
> 
> In that case, then I recommend to restrict your patch to that case, and
> forget about a bitmask. Since lagcy just has antenna A, B, or auto, how
> about defining an API for just that?
>
> > i'd say this is 99% of all use cases.
> 
> For now, yes. I'm thinking about 802.11n though and for that we can
> just wait, and use some other API once someone with more time wants
> to iron it out.

yes, i'm trying to find an API for 'legacy' (as you call it).
 
> > but this API would also allow us to define
> > more advanved things like 'transmit on antenna 1, receive on antenna 2".
> 
> Sure.
> 
> > i know that there are possibly more crazy (and very rare) configurations,
> > like use several panel antennas + omni, which can't be configured with
> > this API,
> 
> How about we ignore those then on this API.

thats what i do. ;)
 
> > but it's hard to find a common API for all possibilities, and i think it
> > would be possible to extend the API later on for such cases.
> 
> Understood, how about just defining something very basic and simple
> for legacy based operation mode?

i think my implementation is quite basic and simple ;)
 
> > > And yet for another driver it could be something completely different
> > > in usersepace.
> > 
> > what do you think that could be, realistically, given the above
> > definition?
> 
> Well, anything that has to do with tx / rx antennas.

that's not very clear. can you give me an example?
 
> > > I think it would be better for us to define a static
> > > API for all legacy cards and another for 802.11n cards, or unify them
> > > but to be very specific about the API for antenna settings/chainmask
> > > settings.
> > 
> > sure. any suggestions?
> 
> Sure how about FIXED_A, FIXED_B, DIVERSITY ?

that's very ath5k centric.

what if there is a 'legacy' hardware with 3 or more antennas?
what if we want to configure RX on antenna 1, TX on antenna 2?
what if we want to use RX diversity but always TX on a fixed antenna?

these are possible and useful configurations, which are not supported right 
now by ath5k but it's easy to add them.

i don't see how "my" API is too complicated, and i think it allows for a clear 
configuration of these cases as well.

your criticism seems to be based on the fact that it's not clear how to handle 
802.11n chainmask + antenna configuration, but this is not what my patch is 
concerned about. let's go step by step...

bruno
