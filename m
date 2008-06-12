Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:62540 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbYFLOR1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 10:17:27 -0400
Received: from mail.atheros.com ([192.168.11.2])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 12 Jun 2008 07:17:27 -0700
Date: Thu, 12 Jun 2008 07:17:21 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [RFC] First CRDA integration work
Message-ID: <20080612141721.GC28315@tesla> (sfid-20080612_161731_054955_88815679)
References: <20080611040402.GE17936@ruslug.rutgers.edu> <1213260106.19369.15.camel@johannes.berg> <20080612131154.GA28315@tesla> <1213276778.3936.10.camel@johannes.berg> <20080612134615.GB28315@tesla> <1213279069.3936.19.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1213279069.3936.19.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 12, 2008 at 06:57:49AM -0700, Johannes Berg wrote:
> 
> > > Well I think that some userspace programs like network manager want to
> > > get a notification when for whatever reason the regdomain changes, and
> > > they want to be able to query which one is currently set, and things
> > > should be changeable. So you need at least three messages, NEW, GET,
> > > SET, no?
> > 
> > Then I see us requiring:
> > 
> > SET and GET, but not NEW. If only need to "set" "one" regulatory domain,
> > not create one and then set one. What do you think?
> 
> Which message are you going to use to notify userspace that it changed?
> I'd say "NEW".

Oh well I hand't thought about that yet. OK.

> > > > This is in case we wanted to support letting userspace query the kernel
> > > > what alpha2 it has set. I'm OK with not supporting this though but it
> > > > seemed it may have come in handy, hopefully not for abuse for other
> > > > things.
> > > 
> > > Yeah true, we may want to be able to force a certain regdomain.
> > 
> > Huh? I was talking about querying from userspace to the kernel for the
> > currently set alpha2, in case userspace may want to know what the kernel
> > last used to ask CRDA for a regdomain.
> > 
> > How did this change to being able to fore a certain regdomain?
> 
> Never mind.
> 
> > Anyway, the only valid case where I see us needing to set a regdomain
> > manaullay is if an access point doesn't have an 802.11d country
> > information element. Which BTW -- soon we'll have to decide how we want
> > to implement, as we could either respect the IE with the channels passed
> > or just ask CRDA for the alpha2 given.
> 
> Yeah, I dunno, either option seems possible. Maybe both?

Just so you know, considerations against trusting APs are some APs
may have outdated reg information. But then again some APs may also have
very custom and specific regdomains -- think military, etc. So yeah
perhaps both would be good and have this be configurable.

> That is, ask
> the crda and then restrict to what the AP said 

Not sure I follow. The way I was thinking of it is this:

When you receive an 802.11d country IE from an AP, you eithere say:

"Sir, yes Sir!" -- and build a regdom based on that.

Or:

"Eh, you look old, what do you know!" -- and use only the alpha2 from the
IE, then ask CRDA for the reg info for this country and get that into
the kernel.

Another consideration is -- what is following the specification? I
realize we don't have to follow the specification down to every word but
I do think following the country IE and respecting it might have been
the whole point.

> (since that'll only be
> useful anyway) but then.. Hmm could get into trouble that way if AP is
> then on an unsupported channel ;)

Sure can run into trouble -- if the EEPROM says you don't have that channel
we should respect it, technically. So the 802.11d will only be useful to
also build the regdomain.

Of course, some drivers may choose to just use the CRDA info to build
their channels dynamically. They can take their pick, but vendors want
to trust their EEPROM as that is what is supported.

  Luis
