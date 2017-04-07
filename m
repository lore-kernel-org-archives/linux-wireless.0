Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:60830 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932813AbdDGTzN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Apr 2017 15:55:13 -0400
Date: Fri, 07 Apr 2017 12:55:11 -0700 (PDT)
Message-Id: <20170407.125511.1233528940652477012.davem@davemloft.net> (sfid-20170407_215517_102726_7FD140C4)
To: johannes@sipsolutions.net
Cc: pablo@netfilter.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, jiri@resnulli.us
Subject: Re: [RFC 0/3] netlink: extended error reporting
From: David Miller <davem@davemloft.net>
In-Reply-To: <1491594406.5800.18.camel@sipsolutions.net>
References: <20170407193550.GA23424@salvia>
        <20170407.124327.626442219286333933.davem@davemloft.net>
        <1491594406.5800.18.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 07 Apr 2017 21:46:46 +0200

> On Fri, 2017-04-07 at 12:43 -0700, David Miller wrote:
>> I suspect that someone will eventually give us a hard time about the
>> strings wrt. internationalization. :-) It's solvable at least
>> partially in userspace I suppose.
> 
> I tend to think of the strings more of a debugging aid, but that's a
> good point.
> 
> Perhaps we should have a macro that has the strings - similar to the
> inline function I put into netlink - but if we make that a macro we can
> put the strings into a separate section to be able to find them more
> easily for later translation, and optionally even omit them entirely
> (to satisfy the kernel tinification folks)?

One idea.  We use the macro thing to generate a "netlink.pot" file and
then some userland tree can contain the latest netlink.pot and the
translations.

I'm suggesting it this way because whilst putting the netlink.pot file
in the kernel tree is probably OK, putting all the translation there
might not be.
