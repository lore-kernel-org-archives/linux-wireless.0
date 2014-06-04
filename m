Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34680 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876AbaFDNqO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 09:46:14 -0400
Message-ID: <1401889560.6079.26.camel@jlt4.sipsolutions.net> (sfid-20140604_154617_407794_63AB5633)
Subject: Re: [RFC] cfg80211/mac80211: Add support for Proxy ARP
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: "Park, Kyeyoon" <kyeyoonp@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 04 Jun 2014 15:46:00 +0200
In-Reply-To: <20140604134217.GA21759@jouni.qca.qualcomm.com>
References: <1400180784-26008-1-git-send-email-kyeyoonp@qca.qualcomm.com>
	 <1400231795.4112.21.camel@jlt4.sipsolutions.net>
	 <E3DE377D7E4999489B304A8FF33FC0D103A211A7@nasanexd01g.na.qualcomm.com>
	 <1401882426.6079.20.camel@jlt4.sipsolutions.net>
	 <20140604134217.GA21759@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-06-04 at 16:42 +0300, Jouni Malinen wrote:
> On Wed, Jun 04, 2014 at 01:47:06PM +0200, Johannes Berg wrote:
> > It seems to me that ebtables should be able to filter on the ports
> > already, so I'm not really sure what you mean by this.
> > 
> > The real issue is the internal forwarding. Is that even necessary? Maybe
> > instead the bridge could forward back to the same port in some cases,
> > and you could just disable the internal forwarding in mac80211 entirely?
> 
> I'd assume that for most Hotspot 2.0 use cases, internal forwarding
> would be disabled completely, but there may very well be cases where one
> would like to use ProxyARP with forwarding between associated stations.
> Doing that through the bridge code above mac80211 should be fine,
> though, i.e., there is no particular reason why the internal forwarding
> really needs to be internal within mac80211 as long as the
> implementation outside is doable (forward back to same port).

Right - I think currently the forward back to the same port part would
be missing. We should probably have a wider discussion with
bridging/nftables/etc. folks.

> > Beyond that, even the "only reply when you have a response" part could
> > be done using the nftables framework, it has quick hash/tree data
> > structures that say the DHCP server could manage (somehow.)
> 
> Getting DHCP server involved in Proxy ARP management sounds complex and
> quite impractical for many cases. I'd expect Hotspot 2.0 APs to work
> with any deployed DHCP setup and there is not really going to be any
> coordination between the two apart from the AP obviously seeing the DHCP
> messages flowing through it.
> 
> Sure, there could be an interface that allows external control, but I
> think there needs to be capability to learn automatically from ARP (and
> IPv6 neighbor messages) and DHCP frames flowing through the AP.

Oh, sure, I agree - and it doesn't really matter where the learning
comes from. I was just trying to say that the filtering part of "drop
frame only when going to reply" should be entirely doable with something
like nftables' set datastructure (or whatever it's called)

johannes

