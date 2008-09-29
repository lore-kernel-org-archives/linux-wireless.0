Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058AbYI2UkM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 16:40:12 -0400
Subject: Re: Getting country alpha2 on network manager and using it for crda
From: Dan Williams <dcbw@redhat.com>
To: "Luis R. Rodriguez" <lrodriguez@Atheros.com>
Cc: Marcel Holtmann <holtmann@linux.intel.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni.Malinen@Atheros.com
In-Reply-To: <20080929183350.GC6203@tesla>
References: <43e72e890809260024ob134358me80ae1c169e4da8e@mail.gmail.com>
	 <1222440218.19895.19.camel@localhost.localdomain>
	 <1222584975.9600.2.camel@californication>  <20080929183350.GC6203@tesla>
Content-Type: text/plain
Date: Mon, 29 Sep 2008 16:39:36 -0400
Message-Id: <1222720776.27930.35.camel@localhost.localdomain> (sfid-20080929_224028_416370_9F772E20)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-09-29 at 11:33 -0700, Luis R. Rodriguez wrote:
> On Sat, Sep 27, 2008 at 11:56:15PM -0700, Marcel Holtmann wrote:
> > Hi Dan,
> > 
> > > > So since this may not happen for a while I figure I can give a shot.
> > > > But I'm curious where we should get our country alpha2 from? Does LSB
> > > > define a country has to be somewhere? Maybe the locale? Timezone?
> > > > Anyway, in the end the user should be able to change the country too.
> > > >
> > > > I'm thinking to start by just letting the user pick a country for now.
> > > > We can figure out where the hell it gets the country by default later
> > > > but if you have ideas that'd be great. It seems reasonable to ask for
> > > > this upon installation time (?)
> > >
> > > My suggestion: use the current timezone as a fallback unless the user
> > > has specified the locale somewhere.  That can obviously be done in NM or
> > > lower, ideally we delegate this sort of thing to the supplicant and just
> > > pass the alpha2 when NM adds the interface to the supplicant.  The
> > > addInterface() call args are just a dict, so it would be trivial to add
> > > another item in that dict for country code.  Since the country code is
> > > global to the machine it's probably something we should just store in
> > > the system settings service, and it's also something that probably
> > > requires privileges to change.
> > 
> > I would prefer if wpa_supplicant gets a global method for setting the
> > alpha2 value. It should be dynamic and for me wpa_supplicant is the
> > right place to handle this value.
> 
> Since it seems nm uses wpa_supplicant for most work then it seems
> reasonable to stuff it in there for now, if possible, and if agreeable
> by Jouni.

Yeah, I'd rather do it through the supplicant too.  So Marcel's
suggestion is the way to go, and NM will then just figure out what the
alpha2 ought to be, and set that alpha2 via the supplicant's D-Bus
method.

> > The question on how we set this value is a little bit more trickier.
> 
> Well setting should be an option from NM or any system preference
> option on a system which lets you update your country.

I'd expect it's both: NM can certainly store a user-specified value
somewhere, and if that's absent make one up from other system
information.

> > What we do need is a Location Manager that can use multiple source to
> > get our current location (WiFi, GSM/UMTS, GPS etc.).
> 
> I suppose we don't have anything like this yet so this seems to be
> a new goal. I'll go poke lsb-discuss mailing list. For now I think its
> as easy as deciding on flatfile where an alpha2 can be put. Later on
> we can worry about all the ways this can be updated.

I hesitate to try and specify an LSB-standard file anywhere for this,
not sure we need that.  NM might want to store this value
per-connection, or might want to store the value system-wide, or
whatever.  I don't really see the value in standardizing the location of
alpha2 config.

Dan


