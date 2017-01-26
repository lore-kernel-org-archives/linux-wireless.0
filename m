Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50440 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752054AbdAZOt1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Jan 2017 09:49:27 -0500
Message-ID: <1485442164.14760.11.camel@sipsolutions.net> (sfid-20170126_154931_327944_C21434CB)
Subject: Re: IPv6-UDP 0x0000 checksum
From: Johannes Berg <johannes@sipsolutions.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 26 Jan 2017 15:49:24 +0100
In-Reply-To: <1485441942.5145.131.camel@edumazet-glaptop3.roam.corp.google.com> (sfid-20170126_154545_190303_B1FB80BF)
References: <1485437276.14760.3.camel@sipsolutions.net>
         <1485438299.5145.117.camel@edumazet-glaptop3.roam.corp.google.com>
         (sfid-20170126_144502_343976_16232A6D) <1485438546.14760.7.camel@sipsolutions.net>
         <1485441942.5145.131.camel@edumazet-glaptop3.roam.corp.google.com>
         (sfid-20170126_154545_190303_B1FB80BF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-01-26 at 06:45 -0800, Eric Dumazet wrote:
> On Thu, 2017-01-26 at 14:49 +0100, Johannes Berg wrote:
> 
> > Oops, sorry - receive. We can only indicate "CHECKSUM_UNNECESSARY",
> > nothing more advanced right now, but right now we'd indicate that
> > if
> > the packet had 0x0000 in the checksum field, but should've had
> > 0xffff.
> > 
> > On TX I believe we actually do in HW exactly what your patch just
> > did.
> 
> Can you describe the visible effects of this problem ?
> 
> Is that because of a conversion we might do later to
> CHECKSUM_COMPLETE ?

Unfortunately, I haven't been able to actually test this yet. I also
didn't find the code that would drop frames with CSUM 0 either, so I'm
thinking - for now - that if all the csum handling is skipped, dropping
0 csum frames would also be, and then we'd accept a frame we should
actually have dropped.

I'll go test this I guess :)

Any pointers to where 0 csum frames are dropped?

johannes
