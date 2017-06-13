Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52468 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751884AbdFMJPq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 05:15:46 -0400
Message-ID: <1497345344.6068.10.camel@sipsolutions.net> (sfid-20170613_111550_145750_B81E6FA9)
Subject: Re: LINKMODE & OPERSTATE thoughts
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: j@w1.fi
Date: Tue, 13 Jun 2017 11:15:44 +0200
In-Reply-To: <ad95b6e5-9220-3eca-bf93-8ba1d89bde3b@gmail.com> (sfid-20170609_234205_953285_C41D8028)
References: <4982156c-5325-8021-dcd3-f13e02c63c72@candelatech.com>
         <11de85e9-6028-e2f8-376b-3188ff1b95a5@gmail.com>
         <2cfd1160-f9b4-5f04-e20f-8d7f9be54f95@candelatech.com>
         <a0e8bd3f-ac25-9619-3f83-1b1debb36a4f@gmail.com>
         <1496993334.2424.1.camel@sipsolutions.net>
         <08fb9e64-a01e-54ea-7627-a0664d350710@gmail.com>
         <1497038197.12088.4.camel@sipsolutions.net>
         <ad95b6e5-9220-3eca-bf93-8ba1d89bde3b@gmail.com>
         (sfid-20170609_234205_953285_C41D8028)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-06-09 at 16:42 -0500, Denis Kenzior wrote:

> > I'm not convinced that it does have that information in all cases,
> > and I don't see how that causes race conditions or much latency,
> > since for client mode userspace would probably just set that
> > together with the NL80211_STA_FLAG_AUTHORIZED flag?
> 
> Well right there is a race condition.  You have 2 sockets and both 
> conveying the same information?

There's no race because we wait for the nl80211 operation to return
before even starting the rtnetlink operation.

> If we can optimize away an extra kernel trap, isn't that worthwhile 
> thing to do?

In itself, for something as rare as this? I don't really see it that
way.

> The most common case is issuing Dormant + UP after setting keys & 
> issuing the set_station command.  Isn't setting STA_FLAG_AUTHORIZED
> and operstate to IF_OPER_UP in effect equivalent?

Not entirely, since STA_FLAG_AUTHORIZED also applies to stations in
modes other than client mode, i.e. to stations other than the AP. In
almost all of those cases, the interface itself is already ready much
earlier.

> Oh, by the way, some drivers don't implement set_station for normal 
> links (e.g. setting STA_FLAG_AUTHORIZED returns an error), should
> they?

If they support encryption they probably should, but they might hook it
from getting the keys or so?

> The only other cases where we mess with setting linkmode I can think
> of are:
> 
> 1. After connecting to an open network
> 2. After a fast transition
> 
> For 1, it would seem that the kernel can easily infer that the 
> IF_OPER_UP flag should be tweaked.

Userspace should still set the AUTHORIZED flag in this case, just
possibly earlier and obviously without any key negotiation. The same is
true for WEP.

> For 2, this needs to be done after the new TK is installed.  Can we 
> combine these steps somehow?

I'm just not convinced it's worth it.


What I think we *can* do, with new EAPOL-over-nl80211 API, would be to
mandate that drivers supporting that, and when it's used, must only set
the carrier state after the controlled port is opened (AUTHORIZED
flag). That way, wpa_s wouldn't have to play with IF_OPER_DORMANT and
IF_OPER_UP at all.

johannes
