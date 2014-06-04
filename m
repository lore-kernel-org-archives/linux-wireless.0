Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34366 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbaFDLrP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 07:47:15 -0400
Message-ID: <1401882426.6079.20.camel@jlt4.sipsolutions.net> (sfid-20140604_134720_023496_0464939C)
Subject: Re: [RFC] cfg80211/mac80211: Add support for Proxy ARP
From: Johannes Berg <johannes@sipsolutions.net>
To: "Park, Kyeyoon" <kyeyoonp@qca.qualcomm.com>
Cc: "Malinen, Jouni" <jouni@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 04 Jun 2014 13:47:06 +0200
In-Reply-To: <E3DE377D7E4999489B304A8FF33FC0D103A211A7@nasanexd01g.na.qualcomm.com>
References: <1400180784-26008-1-git-send-email-kyeyoonp@qca.qualcomm.com>
	 <1400231795.4112.21.camel@jlt4.sipsolutions.net>
	 <E3DE377D7E4999489B304A8FF33FC0D103A211A7@nasanexd01g.na.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-05-16 at 22:49 +0000, Park, Kyeyoon wrote:

> > All code paths within the REQUEST return 1 - is that intentional? It seems
> > to me that there might be a requirement to actually pass the frame if you
> > don't know a response? OTOH, maybe you don't actually need this since
> > you don't necessarily want the stations communicating anyway (at least
> > in a HS2 scenario)
> 
> It is intentional for this particular case. There would be a case for
> static IP, IPv4 DAD (RFC 5227), where a defense ARP Announcement packet
> from the bridge would not only invalidate the table we built in the AP,
> but also would inform the STA that there is an entity out there with
> the same IP address. In this case, the "ARP REQUEST" frame would be
> allowed through. Note: NOT implemented yet. This would be part 2.
> 
> The STAs not being able to communicate with each other, at least not
> directly without the consent of an overseeing entity connected to the
> bridge, is for the other feature in HS2, L2TIF (L2 Traffic Inspection
> and Filtering). Coming to an e-mail inbox near you, hopefully in the
> near future.

Right, but it seems to me that these two features aren't necessarily
dependent on each other - iow it seems that there might be a use case
for doing proxy ARP while not doing filtering?

OTOH, if the filtering is required for HS2, then maybe we don't have to
worry about this part, and then we can implement it elsewhere fairly
easily?

> > > +       } else if (arp->ar_op == htons(ARPOP_REPLY)) {
> > > +               if (is_multicast_ether_addr(eh->h_dest))
> > > +                       return 1;
> > 
> > is also implementing something else - not this particular feature, no?
> 
> Right. This is suppressing the G.ARP Reply within the BSS.

Yeah, again more related to the filtering though, not plain proxy ARP.

> Honestly, I have no problem doing this elsewhere as long as:
> 1) We can add an AP context to ip/eb/nftables in a clean way. Maybe get
> the hostapd involved somehow? Get it to inform the MAC addresses of
> the STAs to ip/eb/nftables? A specific detail would be helpful for
> me in doing the implementation. Greatly appreciated in advance.

It seems to me that ebtables should be able to filter on the ports
already, so I'm not really sure what you mean by this.

The real issue is the internal forwarding. Is that even necessary? Maybe
instead the bridge could forward back to the same port in some cases,
and you could just disable the internal forwarding in mac80211 entirely?

Beyond that, even the "only reply when you have a response" part could
be done using the nftables framework, it has quick hash/tree data
structures that say the DHCP server could manage (somehow.)

I feel that this is more of a system integration issue. We may not have
the full capabilities to allow such integration, but I also think
implementing it all in the stack is the wrong approach.


> 2) The performance hit from such method would be comparable to that
> of the proposed method. I feel that the current implementation's
> performance hit should be minimal to the wireless stack.

Until proven otherwise, I don't see any performance issues :-)
Or let me put it this way - until we can actually see that there's no
way to make the other solution perform well enough (which I highly
doubt, with BPF JIT being available etc.!) I don't think it makes sense
to think about performance much.

johannes

