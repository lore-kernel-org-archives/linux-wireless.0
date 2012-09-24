Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36116 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab2IXKrn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2012 06:47:43 -0400
Message-ID: <1348483695.10257.8.camel@jlt4.sipsolutions.net> (sfid-20120924_124746_857292_8EB6AC39)
Subject: Re: [RFC v3] cfg80211: VHT regulatory
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Mahesh Palivela <maheshp@posedge.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Date: Mon, 24 Sep 2012 12:48:15 +0200
In-Reply-To: <CAB=NE6VMOvftuxi1zu3=4q-BJgM9rJHY86W-6+MAHmtY=V=6xA@mail.gmail.com> (sfid-20120917_205647_434531_133C844B)
References: <504DBBAC.7040300@posedge.com>
	 <CAB=NE6UfQdM6HrVGw3Dn-NBxQupwA3kJD27kv3c9DjLY8DVm1Q@mail.gmail.com>
	 <5052E852.8030804@posedge.com>
	 <1347896071.4975.14.camel@jlt4.sipsolutions.net>
	 <CAB=NE6VMOvftuxi1zu3=4q-BJgM9rJHY86W-6+MAHmtY=V=6xA@mail.gmail.com>
	 (sfid-20120917_205647_434531_133C844B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-09-17 at 11:56 -0700, Luis R. Rodriguez wrote:

> > I'm not convinced :-)
> >
> > Today, we have people who want to use wifi on other parts of the
> > spectrum, like somewhere in the 800 MHz range for example. If that gets
> > properly integrated into drivers (rather than pretending it's actually
> > 2.4 GHz) then you may want to do something different here, and those
> > channels would never actually have IEEE defined 80 MHz rules.
> 
> So we'd have HT20 and HT40 only for 800 MHz?

Why would we want to restrict bandwidth use to the band we're operating
in at all? Fundamentally, the question, in terms of regulatory, is:

 "Can I use a XY MHz around XYZ MHz?"

It isn't really "Can I use VHT 80 on channel 6".

> > Also, those definitions are arbitrary for interoperability and don't
> > reflect regulatory rules.
> 
> It seems easier to implement supporting checking for a static set of
> VHT arrangements rather than figuring out all theoretically possible
> arrangements given that most other arrangements would be unused /
> unimplemented / not-supported.

I think it's only superficially easier since we define regulatory rules
in terms of spectrum usage, and not in terms of IEEE channels.

> > Yes, it may be easier today to just pretend
> > that regulatory rules only matter for IEEE defined operation, but I'm
> > not convinced that we really should have definitions here in the
> > regulatory database that really only cover specific IEEE 802.11
> > channels.
> 
> Agreed, but what I am proposing doesn't necessarily push us to push
> anything IEEE specific into the wireless regulatory database, but it
> does however push us to implement IEEE specific use cases on cfg80211.

Well, since the regulatory framework is now part of cfg80211 the line is
a bit blurred here, but I don't see why a regulatory check should be
restricted to 802.11 channels either, even if it uses the 802.11 defines
to do the check? On the contrary, I think that if we frame the question
above in terms of 802.11 when asking the regulatory framework, then
we'll most likely end up with a regulatory framework that is 802.11
specific.

johannes

