Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:34980 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727651AbeILXkn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Sep 2018 19:40:43 -0400
Message-ID: <1536777285.3678.28.camel@sipsolutions.net> (sfid-20180912_203504_951247_25759FD4)
Subject: Re: [RFC v2 1/2] netlink: add NLA_REJECT policy type
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        mkubecek@suse.cz
Date: Wed, 12 Sep 2018 20:34:45 +0200
In-Reply-To: <20180912.111555.1317690378514849083.davem@davemloft.net>
References: <20180912083610.20857-1-johannes@sipsolutions.net>
         <20180912.111555.1317690378514849083.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-09-12 at 11:15 -0700, David Miller wrote:

> This looks great, no objections to this idea or the facility.

Great. I'll post this (with the fixups) for real tomorrow then, I guess.
A bit too late for me to do now.

> It does, however, remind me about about the classic problem of how bad
> we are at feature support detection because unrecognized attributes are
> ignored.
> 
> I do really hope we can fully solve that problem some day.

Yes.

There may be two or more levels to this.

It wouldn't be hard to reject attributes that are higher than maxtype -
we already pass that to nla_parse() wherever we call it, but we'd have
to find a way to make it optional I guess, for compatibility reasons.
Perhaps with a warning, like attribute validation. For genetlink, a flag
in the family (something like "strict attribute validation") would be
easy, but for "netlink proper" we have a lot of nlmsg_parse() calls to
patch, and/or replace by nlmsg_parse_strict().

I guess we should

1) implement nlmsg_parse_strict() for those new things that want it
   strictly - greenfield type stuff that doesn't need to work with
   existing applications

2) add a warning to nlmsg_parse() when a too high attribute is
   encountered

3) eventually replace nlmsg_parse() calls by nlmsg_parse_strict() and
   see what breaks? :-) We won't be able to rely on that any time soon
   though (unless userspace first checks with a guaranteed rejected
   attribute, e.g. one that has NLA_REJECT, perhaps the u64 pad
   attributes could be marked such since the kernel can't assume
   alignment anyway)

Perhaps we also have too many calls to nlmsg_parse() without a policy,
but that's orthogonal to this check.


On a second level though, with complex things like nl80211 it's often
not clear at all which attributes are used with which commands. Some
attributes (like NL80211_ATTR_IFINDEX) are (almost) universal, but there
are others that aren't. Perhaps this isn't all that important, since if
you try to trigger scanning and at the same time tell the kernel about a
key index, that clearly makes no sense at all. OTOH, we have no good way
of discovering what attribute is used where - we (try to) document this
well in the nl80211.h kernel-doc, but that isn't always complete.

So more introspection (of sorts) could be useful.


While we're talking about wishlist, I'm also toying with the idea of
having some sort of generic mechanism to convert netlink attributes
to/from structs, for internal kernel representation; so far though I
haven't been able to come up with anything useful.

johannes
