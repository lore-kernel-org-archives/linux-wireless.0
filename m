Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60024 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728196AbeIMAf0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Sep 2018 20:35:26 -0400
Date: Wed, 12 Sep 2018 21:29:26 +0200
From: Michal Kubecek <mkubecek@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC v2 1/2] netlink: add NLA_REJECT policy type
Message-ID: <20180912192925.GD29691@unicorn.suse.cz> (sfid-20180912_212940_689076_6BA1DCA9)
References: <20180912083610.20857-1-johannes@sipsolutions.net>
 <20180912.111555.1317690378514849083.davem@davemloft.net>
 <1536777285.3678.28.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1536777285.3678.28.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 12, 2018 at 08:34:45PM +0200, Johannes Berg wrote:
> It wouldn't be hard to reject attributes that are higher than maxtype -
> we already pass that to nla_parse() wherever we call it, but we'd have
> to find a way to make it optional I guess, for compatibility reasons.
> Perhaps with a warning, like attribute validation. For genetlink, a flag
> in the family (something like "strict attribute validation") would be
> easy, but for "netlink proper" we have a lot of nlmsg_parse() calls to
> patch, and/or replace by nlmsg_parse_strict().
> 
> I guess we should
> 
> 1) implement nlmsg_parse_strict() for those new things that want it
>    strictly - greenfield type stuff that doesn't need to work with
>    existing applications
> 
> 2) add a warning to nlmsg_parse() when a too high attribute is
>    encountered
> 
> 3) eventually replace nlmsg_parse() calls by nlmsg_parse_strict() and
>    see what breaks? :-) We won't be able to rely on that any time soon
>    though (unless userspace first checks with a guaranteed rejected
>    attribute, e.g. one that has NLA_REJECT, perhaps the u64 pad
>    attributes could be marked such since the kernel can't assume
>    alignment anyway)

I'm not so sure we (eventually) want to reject unknown attributes
everywhere. I don't have any concrete example in mind but I think there
will be use cases where we want to ignore unrecognized attributes
(probably per parse call). But it makes sense to require caller to
explicitely declare this is the case.

> While we're talking about wishlist, I'm also toying with the idea of
> having some sort of generic mechanism to convert netlink attributes
> to/from structs, for internal kernel representation; so far though I
> haven't been able to come up with anything useful.

I was also thinking about something like this. One motivation was to
design extensible version of ethtool_ops, the other was allowing complex
data types (structures, arrays) for ethtool tunables. But I have nothing
more than a vague idea so far.

Michal Kubecek
