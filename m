Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49017 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437AbbDMLRa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2015 07:17:30 -0400
Message-ID: <1428923833.2355.14.camel@sipsolutions.net> (sfid-20150413_131735_280755_88CC3287)
Subject: Re: [PATCH 3/4] ipv4: add option to drop gratuitous ARP packets
From: Johannes Berg <johannes@sipsolutions.net>
To: Julian Anastasov <ja@ssi.bg>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	matti.gottlieb@intel.com
Date: Mon, 13 Apr 2015 13:17:13 +0200
In-Reply-To: <alpine.LFD.2.11.1504111340170.2449@ja.home.ssi.bg>
References: <1428652454-1224-1-git-send-email-johannes@sipsolutions.net>
	 <1428652454-1224-3-git-send-email-johannes@sipsolutions.net>
	 <alpine.LFD.2.11.1504111340170.2449@ja.home.ssi.bg>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-04-11 at 13:59 +0300, Julian Anastasov wrote:
> > + /*
> > +  *	For some 802.11 wireless deployments (and possibly other networks),
> > +  *	there will be an ARP proxy and gratuitous ARP frames are attacks
> > +  *	and thus should not be accepted.
> > +  */
> > +	if (IN_DEV_CONF_GET(in_dev, DROP_GRATUITOUS_ARP) && sip == tip)
> > +		goto out;
> 
> 	Does it happen for any pkt_type? 

Yes, it's supposed to.

> IN_DEV_ARP_ACCEPT
> is not ON by default, so new entries are not created but

Correct, this protects against "gratuitous updates" in a way.

> update can happen at any time, even with simple request like
> who-has OURIP tell PROXYIP and sha=hacker_mac sent by
> attackers. Is that the only gap that needs to be protected
> with this patch?

Realistically, I'd expect networks that deploy this to implement other
things that prevent clients from messing up the network. I'd expect, for
example, that ARP packets are simple dropped in the AP bridge if it
implements proxy service and wants to control the network tightly.

It can still be desirable to not let gratuitous ARP packets update the
cache entry though. IPv6 for example automatically marks such updated
entries stale, IIRC, so there I had even bigger issues with testing and
I need to check if I even need the 4th patch in this series.

However, there's also a compliance test here that requires this
behaviour, and checks specifically that a gratuitous ARP doesn't update
an existing cache entry.

> 	May be only arptable_filter can help here to
> protect ARP?

That could be possible, I'll check.

Thanks!

johannes


