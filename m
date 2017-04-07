Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51606 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752848AbdDGS7T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Apr 2017 14:59:19 -0400
Message-ID: <1491591552.5800.1.camel@sipsolutions.net> (sfid-20170407_210014_303370_B7C7E457)
Subject: Re: [RFC 0/3] netlink: extended error reporting
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org
Date: Fri, 07 Apr 2017 20:59:12 +0200
In-Reply-To: <20170407.115315.23470877439489670.davem@davemloft.net>
References: <20170407182620.6438-1-johannes@sipsolutions.net>
         <20170407.115315.23470877439489670.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-04-07 at 11:53 -0700, David Miller wrote:

> > Alexander Shishkin had a nice way of reporting static extended
> > error data, but that isn't really suitable for reporting the
> > offset or even reporting the broken attribute from nla_parse().
> > 
> > Speaking of nla_parse(), that'll be somewhat complicated to do
> > since we'll have to track the offsets of where we're parsing,
> > but it might be possible since the nlattrs are just pointers
> > into the message, so (optionally?) passing the skb as well can
> > allow us to fill the offset information.
> 
> I like it, nice work.

I don't like it all that much ;-)

Alexander Shishkin's patch
https://patchwork.kernel.org/patch/7162421/

was nice in a way because you could get away without passing the error
structure down all the time, but like I said it doesn't deal with
dynamic errors (even the offset/attr from nla_parse) and if it's not
done *everywhere* it risks leaking those exterr numbers (-1024..-4095)
to userspace through syscalls if it's used in a non-netlink path for
some reason (e.g. a single driver call being called through both
netlink and ioctl, and trying to return an extended error)

> I know people want dynamically generated strings and stuff, and we
> can get there, but I prefer that the first thing we commit is super
> simple.
> 
> Someone gave me a hard time about the fact that we've been talking
> about this idea for years but nothing ever happens.
> 
> I'm tempted to apply this as-is just to show that person that things
> do in fact happen.... eventually :-)

Heh. I think I really want to solve - at least partially - nla_parse()
to see that it can be done this way. It'd be nice to even transform all
the callers (I generated half of these patches with spatch anyway) to
have at least that.

johannes
