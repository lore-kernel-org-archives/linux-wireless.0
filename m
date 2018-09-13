Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:44428 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726797AbeIMRzs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Sep 2018 13:55:48 -0400
Message-ID: <1536842777.4160.9.camel@sipsolutions.net> (sfid-20180913_144637_094524_83D6223A)
Subject: Re: [PATCH 2/2] netlink: add ethernet address policy types
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kubecek <mkubecek@suse.cz>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Thu, 13 Sep 2018 14:46:17 +0200
In-Reply-To: <20180913122412.GI29691@unicorn.suse.cz>
References: <20180913084603.7979-1-johannes@sipsolutions.net>
         <20180913084603.7979-2-johannes@sipsolutions.net>
         <20180913115849.GF29691@unicorn.suse.cz>
         <1536840173.4160.4.camel@sipsolutions.net>
         <20180913121227.GH29691@unicorn.suse.cz>
         <1536840966.4160.6.camel@sipsolutions.net>
         <20180913122412.GI29691@unicorn.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-09-13 at 14:24 +0200, Michal Kubecek wrote:
> On Thu, Sep 13, 2018 at 02:16:06PM +0200, Johannes Berg wrote:
> > On Thu, 2018-09-13 at 14:12 +0200, Michal Kubecek wrote:
> > > On Thu, Sep 13, 2018 at 02:02:53PM +0200, Johannes Berg wrote:
> > > > On Thu, 2018-09-13 at 13:58 +0200, Michal Kubecek wrote:
> > > > 
> > > > > The code looks correct to me but I have some doubts. Having a special
> > > > > policy for MAC addresses may lead to adding one for IPv4 address (maybe
> > > > > not, we can use NLA_U32 for them), IPv6 addresses and other data types
> > > > > with fixed length. Wouldn't it be more helpful to add a variant of
> > > > > NLA_BINARY (NLA_BINARY_EXACT?) which would fail/warn if attribute length
> > > > > isn't equal to .len?
> > > > 
> > > > Yeah, I guess we could do that, and then
> > > > 
> > > > #define NLA_ETH_ADDR .len = ETH_ALEN, .type = NLA_BINARY_EXACT
> > > > #define NLA_IP6_ADDR .len = 16, .type = NLA_BINARY_EXACT
> > > > 
> > > > or so?
> > > 
> > > Maybe rather
> > > 
> > >   #define NLA_ETH_ADDR NLA_BINARY_EXACT, .len = ETH_ALEN
> > >   #define NLA_IP6_ADDR NLA_BINARY_EXACT, .len = sizeof(struct in6_addr)
> > > 
> > > so that one could write
> > > 
> > >   { .type = NLA_ETH_ADDR }
> > 
> > Yeah, that's possible. I considered it for a second, but it was slightly
> > too magical for my taste :-)
> > 
> > Better pick a different "namespace", perhaps NLA_POLICY_ETH_ADDR or so?
> 
> Right, that sounds better. I'm afraid anything too tricky would
> inevitably trick people into using it in an unexpected way and ending up
> with very confusing error messages.

Right.

Then again though, we already have NLA_MSECS which is basically
equivalent to NLA_U64 afaict, so why not have more types?

It doesn't really cost us that much, just a few bytes in the validation?

Also, with .type = NLA_ETH_ADDR_COMPAT we could get a warning, which is
not true for just checking .len.

OTOH, you could argue that adding two types for ethernet addresses, two
for IPv6 addresses, and possibly more quickly adds up to make that "just
a few bytes" matter ...

johannes
