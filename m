Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52148 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933777AbdDGTqx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Apr 2017 15:46:53 -0400
Message-ID: <1491594406.5800.18.camel@sipsolutions.net> (sfid-20170407_214852_332376_240F8F28)
Subject: Re: [RFC 0/3] netlink: extended error reporting
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>, pablo@netfilter.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        jiri@resnulli.us
Date: Fri, 07 Apr 2017 21:46:46 +0200
In-Reply-To: <20170407.124327.626442219286333933.davem@davemloft.net>
References: <1491591552.5800.1.camel@sipsolutions.net>
         <20170407.122053.201153373954521345.davem@davemloft.net>
         <20170407193550.GA23424@salvia>
         <20170407.124327.626442219286333933.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-04-07 at 12:43 -0700, David Miller wrote:
> 
> I have no strong opinions about string length.
> 
> In my opinion, I would like to believe that if someone tried to get a
> networking patch applied that emitted a rediculously long string then
> we would give them feedback about how that is not acceptable.  Right?

Agree with this, I don't really see much point in adding an extra
warning. There's an implicit (multi-KB though) limit as well in the
message size ;-)

> I suspect that someone will eventually give us a hard time about the
> strings wrt. internationalization. :-) It's solvable at least
> partially in userspace I suppose.

I tend to think of the strings more of a debugging aid, but that's a
good point.

Perhaps we should have a macro that has the strings - similar to the
inline function I put into netlink - but if we make that a macro we can
put the strings into a separate section to be able to find them more
easily for later translation, and optionally even omit them entirely
(to satisfy the kernel tinification folks)?

johannes
