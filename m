Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40048 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752581AbdCNO1K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Mar 2017 10:27:10 -0400
Message-ID: <1489501627.10872.15.camel@sipsolutions.net> (sfid-20170314_152717_323599_E85816F7)
Subject: Re: [PATCH] mac80211: Allow multiple listeners for management
 frames.
From: Johannes Berg <johannes@sipsolutions.net>
To: Sven Eckelmann <sven.eckelmann@openmesh.com>
Cc: Simon Wunderlich <simon.wunderlich@openmesh.com>,
        linux-wireless@vger.kernel.org,
        Benjamin Berg <benjamin@sipsolutions.net>
Date: Tue, 14 Mar 2017 15:27:07 +0100
In-Reply-To: <2459952.Zo1p5FTnYy@bentobox> (sfid-20170314_152123_171005_9062AC0F)
References: <20170310093454.27664-1-sven.eckelmann@openmesh.com>
         <3029516.gVNlmVZjU3@prime> <1489500792.10872.13.camel@sipsolutions.net>
         <2459952.Zo1p5FTnYy@bentobox> (sfid-20170314_152123_171005_9062AC0F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-03-14 at 15:21 +0100, Sven Eckelmann wrote:
> On Dienstag, 14. März 2017 15:13:12 CET Johannes Berg wrote:
> > > The idea was to grab probe requests from userspace with a program
> > > running next to hostapd.
> > 
> > I guess there are some efficiency problems with that right now, but
> > a
> > monitor mode interface should work just as well. Perhaps we can
> > allow
> > attaching a BPF program to a monitor mode interface, and run that
> > without cloning the SKB etc.?
> 
> This has also other problems. For example the ath10k fw will crash a
> lot when a monitor interface is active.

That's not an argument I can accept - the driver shouldn't even have to
*care* if one is active or not, especially not if you set the flags to
none. I'm not even sure we tell the driver about it in that case, but
it definitely sounds like something that should be fixed in the driver.

> I think that we saw also some
> performance regressions caused by the ath9k filtering behavior when a
> monitor mode interface is active (without actually listening on it).

Ditto, the filtering can be fixed by passing "flags none" with iw (or
directly when creating with nl80211). The driver should be fixed to not
care about the interface at all in that case.

Regardless though, there *will* be some performance impact of this.
Hence my suggestion to add a BPF filter not to the socket, but to the
monitor interface itself.

Now I'm also wondering if we could implement cooked monitor that way,
might cut down some special code that we only keep for backwards
compatibility ...

Either way, due to the action frame issue I don't really want to apply
this patch. With probe requests it's a bit borderline, if you promise
to never send anything it would probably be OK, but it's still rather
strange to use this for monitor purposes.

johannes
