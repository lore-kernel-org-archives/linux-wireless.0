Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52438 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726919AbeIMRVl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Sep 2018 13:21:41 -0400
Date: Thu, 13 Sep 2018 14:12:28 +0200
From: Michal Kubecek <mkubecek@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] netlink: add ethernet address policy types
Message-ID: <20180913121227.GH29691@unicorn.suse.cz> (sfid-20180913_141235_466431_2E510F27)
References: <20180913084603.7979-1-johannes@sipsolutions.net>
 <20180913084603.7979-2-johannes@sipsolutions.net>
 <20180913115849.GF29691@unicorn.suse.cz>
 <1536840173.4160.4.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1536840173.4160.4.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 13, 2018 at 02:02:53PM +0200, Johannes Berg wrote:
> On Thu, 2018-09-13 at 13:58 +0200, Michal Kubecek wrote:
> 
> > The code looks correct to me but I have some doubts. Having a special
> > policy for MAC addresses may lead to adding one for IPv4 address (maybe
> > not, we can use NLA_U32 for them), IPv6 addresses and other data types
> > with fixed length. Wouldn't it be more helpful to add a variant of
> > NLA_BINARY (NLA_BINARY_EXACT?) which would fail/warn if attribute length
> > isn't equal to .len?
> 
> Yeah, I guess we could do that, and then
> 
> #define NLA_ETH_ADDR .len = ETH_ALEN, .type = NLA_BINARY_EXACT
> #define NLA_IP6_ADDR .len = 16, .type = NLA_BINARY_EXACT
> 
> or so?

Maybe rather

  #define NLA_ETH_ADDR NLA_BINARY_EXACT, .len = ETH_ALEN
  #define NLA_IP6_ADDR NLA_BINARY_EXACT, .len = sizeof(struct in6_addr)

so that one could write

  { .type = NLA_ETH_ADDR }

as with other types.

Michal Kubecek
