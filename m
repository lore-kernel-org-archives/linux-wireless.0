Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:35574 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728146AbeIMAoH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Sep 2018 20:44:07 -0400
Message-ID: <1536781073.3678.38.camel@sipsolutions.net> (sfid-20180912_213811_257773_8AC60684)
Subject: Re: [RFC v2 1/2] netlink: add NLA_REJECT policy type
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kubecek <mkubecek@suse.cz>
Cc: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Date: Wed, 12 Sep 2018 21:37:53 +0200
In-Reply-To: <20180912192925.GD29691@unicorn.suse.cz>
References: <20180912083610.20857-1-johannes@sipsolutions.net>
         <20180912.111555.1317690378514849083.davem@davemloft.net>
         <1536777285.3678.28.camel@sipsolutions.net>
         <20180912192925.GD29691@unicorn.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-09-12 at 21:29 +0200, Michal Kubecek wrote:

> > 3) eventually replace nlmsg_parse() calls by nlmsg_parse_strict() and
> >    see what breaks? :-) We won't be able to rely on that any time soon
> >    though (unless userspace first checks with a guaranteed rejected
> >    attribute, e.g. one that has NLA_REJECT, perhaps the u64 pad
> >    attributes could be marked such since the kernel can't assume
> >    alignment anyway)
> 
> I'm not so sure we (eventually) want to reject unknown attributes
> everywhere. I don't have any concrete example in mind but I think there
> will be use cases where we want to ignore unrecognized attributes
> (probably per parse call). But it makes sense to require caller to
> explicitely declare this is the case.

Yeah, I think nla_parse() vs. nla_parse_strict() - along with
remembering in review to say "perhaps you should prefer
nla_parse_strict() for this new thing" might be all we want (or
realistically can do).

> > While we're talking about wishlist, I'm also toying with the idea of
> > having some sort of generic mechanism to convert netlink attributes
> > to/from structs, for internal kernel representation; so far though I
> > haven't been able to come up with anything useful.
> 
> I was also thinking about something like this. One motivation was to
> design extensible version of ethtool_ops, the other was allowing complex
> data types (structures, arrays) for ethtool tunables. But I have nothing
> more than a vague idea so far.

I played with macros a bit, but ultimately that wasn't so readable.
There's no way to do upper-casing in the preprocessor :-) Realistically,
I ended up with something that would require either a lot of boiler-
plate code estill, or perhaps double-including a header file (though I
never really finished the latter thought.)

This is what I toyed with earlier today:
https://p.sipsolutions.net/35e260d7debaa406.txt

johannes
