Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41246 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbeINAwR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Sep 2018 20:52:17 -0400
Date: Thu, 13 Sep 2018 16:41:16 -0300
From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michal Kubecek <mkubecek@suse.cz>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] netlink: add ethernet address policy types
Message-ID: <20180913194116.GG4590@localhost.localdomain> (sfid-20180913_214126_535477_5C4ADE9D)
References: <20180913084603.7979-1-johannes@sipsolutions.net>
 <20180913084603.7979-2-johannes@sipsolutions.net>
 <20180913115849.GF29691@unicorn.suse.cz>
 <1536840173.4160.4.camel@sipsolutions.net>
 <20180913121227.GH29691@unicorn.suse.cz>
 <1536840966.4160.6.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1536840966.4160.6.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 13, 2018 at 02:16:06PM +0200, Johannes Berg wrote:
> On Thu, 2018-09-13 at 14:12 +0200, Michal Kubecek wrote:
> > On Thu, Sep 13, 2018 at 02:02:53PM +0200, Johannes Berg wrote:
> > > On Thu, 2018-09-13 at 13:58 +0200, Michal Kubecek wrote:
> > > 
> > > > The code looks correct to me but I have some doubts. Having a special
> > > > policy for MAC addresses may lead to adding one for IPv4 address (maybe
> > > > not, we can use NLA_U32 for them), IPv6 addresses and other data types
> > > > with fixed length. Wouldn't it be more helpful to add a variant of
> > > > NLA_BINARY (NLA_BINARY_EXACT?) which would fail/warn if attribute length
> > > > isn't equal to .len?
> > > 
> > > Yeah, I guess we could do that, and then
> > > 
> > > #define NLA_ETH_ADDR .len = ETH_ALEN, .type = NLA_BINARY_EXACT
> > > #define NLA_IP6_ADDR .len = 16, .type = NLA_BINARY_EXACT
> > > 
> > > or so?
> > 
> > Maybe rather
> > 
> >   #define NLA_ETH_ADDR NLA_BINARY_EXACT, .len = ETH_ALEN
> >   #define NLA_IP6_ADDR NLA_BINARY_EXACT, .len = sizeof(struct in6_addr)
> > 
> > so that one could write
> > 
> >   { .type = NLA_ETH_ADDR }
> 
> Yeah, that's possible. I considered it for a second, but it was slightly
> too magical for my taste :-)
> 
> Better pick a different "namespace", perhaps NLA_POLICY_ETH_ADDR or so?

What about
#define NLA_FIELD_ETH_ADDR  { .type = NLA_BINARY_EXACT, .len = ETH_ALEN }

Or even
#define NLA_FIELD_BINARY_EXACT(_len)	{ .type = NLA_BINARY_EXACT, .len = (_len) }
#define NLA_FIELD_ETH_ADDR		NLA_FIELD_BINARY_EXACT(ETH_ALEN)

So that one would just:
   [MYADDR] = NLA_FIELD_ETH_ADDR,

and if we change how we parse/validate it, users should be good
already.

  Marcelo
