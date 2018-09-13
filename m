Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54374 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727413AbeIMRd2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Sep 2018 13:33:28 -0400
Date: Thu, 13 Sep 2018 14:24:12 +0200
From: Michal Kubecek <mkubecek@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] netlink: add ethernet address policy types
Message-ID: <20180913122412.GI29691@unicorn.suse.cz> (sfid-20180913_142420_464777_1070648F)
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

Right, that sounds better. I'm afraid anything too tricky would
inevitably trick people into using it in an unexpected way and ending up
with very confusing error messages.

Michal Kubecek
