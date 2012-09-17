Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36810 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472Ab2IQPd4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2012 11:33:56 -0400
Message-ID: <1347896071.4975.14.camel@jlt4.sipsolutions.net> (sfid-20120917_173400_320284_5D6DBD97)
Subject: Re: [RFC v3] cfg80211: VHT regulatory
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Date: Mon, 17 Sep 2012 17:34:31 +0200
In-Reply-To: <5052E852.8030804@posedge.com>
References: <504DBBAC.7040300@posedge.com>
	 <CAB=NE6UfQdM6HrVGw3Dn-NBxQupwA3kJD27kv3c9DjLY8DVm1Q@mail.gmail.com>
	 <5052E852.8030804@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-09-14 at 13:48 +0530, Mahesh Palivela wrote:

> > Although VHT complicates the regulatory checks, to the extent you
> > check for valid 20 MHz IEEE channels in between a VHT wide channel,
> > the IEEE spec actually only allows in practice certain VHT
> > arrangements. I've asked for shiny diagrams that have this laid out
> > clearly and simple but unfortunately we do not have one, but such
> > simple static arrangements are apparently specified on the spec, its
> > not clear to me where exactly though... Technically then if we wanted
> > to keep a static cached early check of allowed channels maps for VHT
> > we should be able to have a bitmap representation of the allowed IEEE
> > VHT channel configurations and upon initialization / regulatory change
> > update this bitmap to determine if we're allowed to use the new
> > arrangement. The approach you use is also fine and while it does allow
> > for flexibility to do add more technologies one should consider the
> > penalty incurred at doing these computations at run time. The run time
> > impact is no issue if its done just once but consider changing
> > channels and how often we can do this. Consider a device now with one
> > radio but two virtual devices and each one doing their own set of
> > scans and two different types of HT / VHT configurations. This means
> > the code you just wrote will become a real hot path -- used for
> > anything  that has to do with any channel change. The purpose of the
> > flags are to remove that run time penalty, so if we can take into
> > consideration more the nature of how we VHT channels are allowed and
> > how IEEE decided to simplify the arrangements for VHT then likely
> > keeping flags may make sense then. That is, not all VHT arrangements
> > are possible, only a subset, and it seems fairly trivial and
> > reasonable to me to do this upon regulatory change only once rather
> > than at every channel change.
> >
> > And as for the question: "What about the future? Will we see 320 MHz
> > wide channels in 2020? :)"
> >
> > I'm told through a shiny crystal ball: let's not expect 320 MHz channels.
> >
> > So I'd rather keep this simple and also due to the fact that VHT
> > channels are static just try to use a bitmap for them and check for it
> > at regulatory change.
> >
> 
> I agree Luis. Limiting the flags to a subset is fine with me. Hope no 
> more disagreements.

I'm not convinced :-)

Today, we have people who want to use wifi on other parts of the
spectrum, like somewhere in the 800 MHz range for example. If that gets
properly integrated into drivers (rather than pretending it's actually
2.4 GHz) then you may want to do something different here, and those
channels would never actually have IEEE defined 80 MHz rules.

Also, those definitions are arbitrary for interoperability and don't
reflect regulatory rules. Yes, it may be easier today to just pretend
that regulatory rules only matter for IEEE defined operation, but I'm
not convinced that we really should have definitions here in the
regulatory database that really only cover specific IEEE 802.11
channels. The regulatory database was designed to be at least a bit more
generic and in fact we always treated it as max bandwidth etc.

I think just using the 802.11 rules here would be artificially limiting
the expressiveness of the regulatory database.

johannes

