Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:40193 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760943AbYF3Pob (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 11:44:31 -0400
Date: Mon, 30 Jun 2008 12:44:26 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johan Adolfsson <Johan.Adolfsson@axis.com>,
	linux-wireless@vger.kernel.org, 'Dan Williams' <dcbw@redhat.com>
Subject: Re: [PATCH] Add module parameter to override regioncode on libertas
Message-ID: <20080630154425.GB22984@khazad-dum.debian.net> (sfid-20080630_174456_154018_00E00346)
References: <1214580776.10355.16.camel@localhost.localdomain> <054201c8da7b$b12677e0$0137550a@se.axis.com> <20080630140330.GB6864@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080630140330.GB6864@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 30 Jun 2008, John W. Linville wrote:
> On Mon, Jun 30, 2008 at 08:36:56AM +0200, Johan Adolfsson wrote:
> > Resending to linux-wireless after positive feedback on libertas-dev.
> > 
> > Attached is a patch against the 2.6.25 driver that adds a 
> > module parameter called "regioncode" to set the region code
> > in the libertas driver.
> > 
> > Hope the format is ok.
> > Signed-off-by: Johan.Adolfsson@axis.com
> 
> Anyone want to offer an opinion on how this (overriding the region
> code from the hardware) differs in effect from the patch that disabled
> all regulatory controls on mac80211 devices?
> 
> >From what I understand about regulatory practices, it seems
> irresponsible to allow a regulatory setting embedded in a device's
> ROM to be so easily overridden?

IMO, it is actually the right thing to do.  We should just plain ignore
EEPROM regulatory domain information (not antenna gain and other data, just
the "where in the world the card is" data) in the general case, except maybe
if you want to use as a last resort default.

Let me explain my reasoning through an example:  I live in Brazil.  It is
extremely common to get crippled wireless devices here, because we get
paired up with the USA and rest of the North, Central and South Americas by
some very big vendors in one big regulatory domain.  That's annoying, and I
have been left without connectivity more than once when I was in a hotzone
operating in channel 13 (which has *exactly* the same restrictions for usage
as those for channels 1-12 in Brazil), but my card thought channel 13 was
illegal to operate at.

Now I get my trusty laptop with the EEPROM-based regdomain driver, and
travel to somewhere where the channel overlap with the Americas regdomain
the vendor used is such that the card can actually operate outside of the
requirements for the local government.   If I am lucky, it just won't allow
me to talk to everyone like what happens in Brazil.  If I am not, I could be
breaking the law.

Where, in the entire scenario above, was the regulatory information in the
EEPROM useful to me?  NEVER.  It was a hindrance in every step.

We live in a small world.  Regulatory information in EEPROMs is something
that just plain doesn't work well in the general case for any mobile
hardware that you're going to travel with.  Heck, in most cases it doesn't
work that well even if you are NOT going to travel with, given the corners
the vendors cut out of their regulatory domain tables...

The whole idea of EEPROM-based selection of a regulatory domains is a failed
concept.  It cannot be fixed, so let's get rid of it.  We can do better.  

I'd rather I could tell the system "I am in country foo", and it would apply
all the regulatory information for country foo correctly.  That's the way to
go, since the system can't find out where it is automatically (but userspace
could, actually, if given a sophisticated world map and (GPS or something
else) geo-location feed).

And, if we have devices that are exceptions (and I bet we do) and must be
always locked to some specific regulatory domain, we deal with it on the
drivers of these devices, instead of causing issues for everyone else.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
