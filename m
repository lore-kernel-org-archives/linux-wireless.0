Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:62080 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbYI2SeB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 14:34:01 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 29 Sep 2008 11:34:01 -0700
Date: Mon, 29 Sep 2008 11:33:50 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Marcel Holtmann <holtmann@linux.intel.com>
CC: Dan Williams <dcbw@redhat.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	<Jouni.Malinen@atheros.com>
Subject: Re: Getting country alpha2 on network manager and using it for crda
Message-ID: <20080929183350.GC6203@tesla> (sfid-20080929_203406_932210_FCBF10AD)
References: <43e72e890809260024ob134358me80ae1c169e4da8e@mail.gmail.com> <1222440218.19895.19.camel@localhost.localdomain> <1222584975.9600.2.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1222584975.9600.2.camel@californication>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 27, 2008 at 11:56:15PM -0700, Marcel Holtmann wrote:
> Hi Dan,
> 
> > > So since this may not happen for a while I figure I can give a shot.
> > > But I'm curious where we should get our country alpha2 from? Does LSB
> > > define a country has to be somewhere? Maybe the locale? Timezone?
> > > Anyway, in the end the user should be able to change the country too.
> > >
> > > I'm thinking to start by just letting the user pick a country for now.
> > > We can figure out where the hell it gets the country by default later
> > > but if you have ideas that'd be great. It seems reasonable to ask for
> > > this upon installation time (?)
> >
> > My suggestion: use the current timezone as a fallback unless the user
> > has specified the locale somewhere.  That can obviously be done in NM or
> > lower, ideally we delegate this sort of thing to the supplicant and just
> > pass the alpha2 when NM adds the interface to the supplicant.  The
> > addInterface() call args are just a dict, so it would be trivial to add
> > another item in that dict for country code.  Since the country code is
> > global to the machine it's probably something we should just store in
> > the system settings service, and it's also something that probably
> > requires privileges to change.
> 
> I would prefer if wpa_supplicant gets a global method for setting the
> alpha2 value. It should be dynamic and for me wpa_supplicant is the
> right place to handle this value.

Since it seems nm uses wpa_supplicant for most work then it seems
reasonable to stuff it in there for now, if possible, and if agreeable
by Jouni.

> The question on how we set this value is a little bit more trickier.

Well setting should be an option from NM or any system preference
option on a system which lets you update your country.

> What we do need is a Location Manager that can use multiple source to
> get our current location (WiFi, GSM/UMTS, GPS etc.).

I suppose we don't have anything like this yet so this seems to be
a new goal. I'll go poke lsb-discuss mailing list. For now I think its
as easy as deciding on flatfile where an alpha2 can be put. Later on
we can worry about all the ways this can be updated.

  Luis
