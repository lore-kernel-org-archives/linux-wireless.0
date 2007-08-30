Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757512AbXH3QXI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 12:23:08 -0400
Subject: Re: mac80211, iwlwifi and packet injection
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andy Green <andy@warmcat.com>, ian <ischram@telenet.be>,
	Robert =?ISO-8859-1?Q?F=FChricht?=
	<the_master_of_disaster@gmx.at>, linux-wireless@vger.kernel.org
In-Reply-To: <1188485483.3978.25.camel@johannes.berg>
References: <20070829161655.7f68542c@doppelhertz>
	 <46D5B8B9.8000803@telenet.be>  <46D5CE9B.8080401@warmcat.com>
	 <1188481073.27590.11.camel@xo-3E-67-34.localdomain>
	 <46D6D18F.2080108@warmcat.com> <1188483950.3978.15.camel@johannes.berg>
	 <46D6D759.2050600@warmcat.com>  <1188485483.3978.25.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 30 Aug 2007 12:16:57 -0400
Message-Id: <1188490617.28908.5.camel@xo-3E-67-34.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-08-30 at 16:51 +0200, Johannes Berg wrote:
> On Thu, 2007-08-30 at 15:42 +0100, Andy Green wrote:
> 
> > Well if for whatever reason you can spawn multiple logical network
> > interfaces in the stack, as you can, NM should generically be aware that
> > aliases exist it seems to me.
> 
> It could be aware of that, but I don't think it helps.
> 
> > If a device can handle two associations simultaneously (with two
> > radios?), which I take the "multiple STA" to mean, maybe it should
> > present as two wiphys and NM can take the hint from that?
> 
> No, no can do. You must be on the same channel etc. so it really is just
> a single wiphy, but the card can allow multiple associations. It's not
> possible with any drivers right now but I'm fairly sure we can add
> support for that to b43 (if only with some microcode changes)

So that's a b*tch and a half to deal with, when there are multiple
devices that actually share certain properties (like frequency).  That's
what's happening with libertas for OLPC, and it's not easy to coordinate
between the devices because there's no standard way for each device to
say "I share X, Y, and Z with device A".  It would be quite a bit easier
if NM could figure out exactly what attributes would be shared.

For libertas, everything is shared except for SSID, mode, bitrate, and
possibly encryption settings.  Frequency is shared, yet they are two
completely separate WEXT interfaces.  Not fun.

> I think that NM should probably just ignore non-STA mode interfaces
> completely.

Right; can somebody attach an 'lshal' run that shows at least one
STA-mode interface and one non-STA-mode interface?  Send it to me
privately since I want the whole thing, not just the bits for the
net.interface object only.

I don't plan on making NM talk to hostapd to do master mode on an
interface for a really, really long time, if ever.  That's better left
to other tools.  As long as a STA interface _is_ a STA interface (and
doesn't have other properties like "monitor"/"raw") then this will work
fine.

Dan


