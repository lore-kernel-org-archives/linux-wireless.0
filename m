Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51852 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933573AbdDGT3Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Apr 2017 15:29:25 -0400
Message-ID: <1491593357.5800.13.camel@sipsolutions.net> (sfid-20170407_213040_912655_2AFCEA8B)
Subject: Re: [RFC 0/3] netlink: extended error reporting
From: Johannes Berg <johannes@sipsolutions.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Date: Fri, 07 Apr 2017 21:29:17 +0200
In-Reply-To: <20170407192134.GA23205@salvia>
References: <20170407182620.6438-1-johannes@sipsolutions.net>
         <20170407.115315.23470877439489670.davem@davemloft.net>
         <1491591552.5800.1.camel@sipsolutions.net> <20170407190601.GA22991@salvia>
         <1491592185.5800.7.camel@sipsolutions.net> <20170407192134.GA23205@salvia>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-04-07 at 21:21 +0200, Pablo Neira Ayuso wrote:
> 
> For my usecases in netfilter, the attributes and an specific error
> code should be enough to figure out what is wrong. Will not need
> strings.

Fair enough.

> BTW, we may not have an offset, eg. EINVAL because of missing
> attribute. Given we have different requirements, I would leave it to
> each subsystem to decide what netlink error attributes are specified.
> 
> > (It's ultimately always going to be optional since we'll continue
> > returning errors without *any* extended error information - likely
> > indefinitely - but if we have a wrong attribute, should we always
> > have
> > an offset? Would be nice, but could be difficult in practice)
> > 
> > > We can probably use struct nla_policy to place the extended error
> > > code or the string (as we discussed I don't need string errors,
> > > but
> > > I'm fine if other people find it useful).
> > 
> > I don't think for the error strings really would be useful for
> > nla_parse() or a policy - we can return something generic like
> > "malformed attribute" there as a string, and hopefully point to the
> > attribute/offset from there generically. I just really want to see
> > how
> > to actually do that.
> 
> I think the most flexible way is to pass the container error
> structure to nla_parse() so it sets this for you. This would also
> save tons of "malformed attribute" strings.

Yes, for sure. The thing is we'll probalby have to pass down the
request skb *and* the error struct so that we can get the offset, and
this seems like the generic thing that we really should try to get the
most information generated.

johannes
