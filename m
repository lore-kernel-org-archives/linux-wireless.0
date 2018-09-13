Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34480 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726763AbeIMVNg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Sep 2018 17:13:36 -0400
Date: Thu, 13 Sep 2018 18:03:25 +0200
From: Michal Kubecek <mkubecek@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] netlink: add ethernet address policy types
Message-ID: <20180913160325.GJ29691@unicorn.suse.cz> (sfid-20180913_180333_751863_CDF37E0D)
References: <20180913084603.7979-1-johannes@sipsolutions.net>
 <20180913084603.7979-2-johannes@sipsolutions.net>
 <20180913115849.GF29691@unicorn.suse.cz>
 <1536840173.4160.4.camel@sipsolutions.net>
 <20180913121227.GH29691@unicorn.suse.cz>
 <1536840966.4160.6.camel@sipsolutions.net>
 <20180913122412.GI29691@unicorn.suse.cz>
 <1536842777.4160.9.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1536842777.4160.9.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 13, 2018 at 02:46:17PM +0200, Johannes Berg wrote:
> On Thu, 2018-09-13 at 14:24 +0200, Michal Kubecek wrote:
> > On Thu, Sep 13, 2018 at 02:16:06PM +0200, Johannes Berg wrote:
> > > On Thu, 2018-09-13 at 14:12 +0200, Michal Kubecek wrote:
> > > > Maybe rather
> > > > 
> > > >   #define NLA_ETH_ADDR NLA_BINARY_EXACT, .len = ETH_ALEN
> > > >   #define NLA_IP6_ADDR NLA_BINARY_EXACT, .len = sizeof(struct in6_addr)
> > > > 
> > > > so that one could write
> > > > 
> > > >   { .type = NLA_ETH_ADDR }
> > > 
> > > Yeah, that's possible. I considered it for a second, but it was slightly
> > > too magical for my taste :-)
> > > 
> > > Better pick a different "namespace", perhaps NLA_POLICY_ETH_ADDR or so?
> > 
> > Right, that sounds better. I'm afraid anything too tricky would
> > inevitably trick people into using it in an unexpected way and ending up
> > with very confusing error messages.
> 
> Right.
> 
> Then again though, we already have NLA_MSECS which is basically
> equivalent to NLA_U64 afaict, so why not have more types?
> 
> It doesn't really cost us that much, just a few bytes in the validation?

And one more branch in the switch in validate_nla().

I'm not really opposed to having special policy types for MAC/IPv4/IPv6
address, these types are quite common, at least in networking code which
is where netlink is used most oftena. I rather felt that technically the
only difference between MAC and IPv6 address is the size and as we have
.len already, it would be more useful to have generic policy allowing to
also handle other fixes size data types.

On the other hand, if there was a trend of adding special policies for
more "endemic" data types, it might be more appropriate to introduce
a generic policy where validation_data would be a "validator function"
doing specific checks (probably using a union to allow type check of the
callback). But that's not happening (yet).

> Also, with .type = NLA_ETH_ADDR_COMPAT we could get a warning, which is
> not true for just checking .len.

We could have three flavors of NLA_BINARY.

Michal Kubecek
