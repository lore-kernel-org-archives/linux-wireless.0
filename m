Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33122 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751225AbcLGGPI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 01:15:08 -0500
Message-ID: <1481091301.4092.5.camel@sipsolutions.net> (sfid-20161207_071511_159183_3DA83861)
Subject: Re: [PATCH][RFC] cfg80211: NL80211_ATTR_SOCKET_OWNER support for
 CMD_CONNECT
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
Date: Wed, 07 Dec 2016 07:15:01 +0100
In-Reply-To: <584730D7.2020708@gmail.com> (sfid-20161206_224249_092743_E8D41EDB)
References: <20161202205611.14141-1-andrew.zaborowski@intel.com>
         <1480945883.31788.3.camel@sipsolutions.net> <58457FEA.4030305@gmail.com>
         <1480949899.31788.34.camel@sipsolutions.net> <5845824B.4090304@gmail.com>
         <1480950886.31788.44.camel@sipsolutions.net> <584588A2.9090006@gmail.com>
         <1481008560.6610.3.camel@sipsolutions.net> <584730D7.2020708@gmail.com>
         (sfid-20161206_224249_092743_E8D41EDB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I'm afraid to consider what you're like when you _are_ 'super'
> against something :)

Why, that's easy, there wouldn't be a long discussion like that ;-)

> So here's a quick test, with the client triggering authenticate, then
> crashing:

> < Request: Authenticate (0x25) len 52
> [ack]                  362.339712

> [...]

>  > Event: Del Station (0x14) len
> 1144                         367.442024

> Pay attention to the time stamps.  The del station event comes in 5 
> seconds or so after our client has aborted.  So for 5 seconds we have
> an unmanaged link to some AP.

No, this is the part you didn't understand. Simply authenticating
doesn't actually create anything like a "link" to the AP. The only
reason we keep the station entry around for a few seconds is that it
*probably* will be used next to associate. But if you don't do that, or
authenticate to some other AP, or do whatever else - nothing stops you
from doing that. There's no connection, nothing really stays active
except for this 5 second grace period to associate.

So even if you crash here like in the example, there's nothing to clean
up, a subsequent authentication attempt to the same or another AP will
go through anyway.

Therefore, there's nothing to "own" with an authentication attempt,
since it doesn't actually keep any (permanent) state in the kernel, and
keeping the station entry around is just an optimisation.

I don't think it's worth trying to clean that up.

Also, consider that authentication doesn't block anything, so another
socket might immediately do another authentication/association, and you
don't want to kill that even when the first one dies. Corner case,
sure, but at least with association the second one would get "-EBUSY"
or so, whereas authentication keeps no state in the kernel.

johannes
