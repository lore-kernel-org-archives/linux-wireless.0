Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47432 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751230AbcJEIOR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 04:14:17 -0400
Message-ID: <1475655244.4994.17.camel@sipsolutions.net> (sfid-20161005_101422_714234_30FC7F6E)
Subject: Re: [PATCHv3] wireless: check A-MSDU inner frame source address on
 AP interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: "M. Braun" <michael-dev@fami-braun.de>
Cc: kvalo@codeaurora.org, akarwar@marvell.com, nishants@marvell.com,
        Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
        linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de
Date: Wed, 05 Oct 2016 10:14:04 +0200
In-Reply-To: <3948ce82-05d8-5c77-0ef1-04045555f48e@fami-braun.de>
References: <1475075672-30549-1-git-send-email-michael-dev@fami-braun.de>
         <1475229714.17481.18.camel@sipsolutions.net>
         <f9d33317-f23f-9d5e-8e9e-1e63eff1882a@fem.tu-ilmenau.de>
         <1475569759.5324.22.camel@sipsolutions.net>
         <1475570219.5324.28.camel@sipsolutions.net>
         <3948ce82-05d8-5c77-0ef1-04045555f48e@fami-braun.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-10-04 at 23:12 +0200, M. Braun wrote:
> > 
> > Obviously, now that I think about it, your patch also would break
> > client mode since it would refuse to accept any A-MSDU with SA !=
> > TA, which is highly unlikely in most cases, since traffic doesn't
> > usually originate from the AP.
> 
> I still don't think my patch would break anything here, as it does
> only filter on AP/AP_VLAN interfaces so stations are not affected at
> all.

Yes, that's true.

> I agree that asking for more cases to be filtered seems natural. But
> is fixing all possible A-MSDU address mismatch problems required to
> fix the one I currently care about most?

Maybe not. But we're changing the API here, and doing that just a
single time would be easier, I think.

> > We verify today that only multicast frames can be encrypted with
> > the GTK, but that applies to the outer header, so we're susceptible
> > to a variant of the hole-196 attack, afaict?
> 
> That exploited that an unicast arp reply can be injected using GTK,
> thus bypassing AP filtering, right?

No, more generally, that exploits that you often can send unicast L3
(e.g. IP) frames in multicast L2 frames, so that even checking that GTK
is used only for multicast L2 frames.

This case is different, not really quite a variant thereof maybe.

But you could possibly send a unicast inner-L2 frame in a multicast
outer-L2 frame, so we should discard multicast A-MSDUs I guess? But
that actually seems like a separate problem.

> To counter, it would suffice to required multicast A-MSDU frames to
> only carry multicast (inner) MSDUs?

Or that, but I don't even think that multicast A-MSDU is allowed, see
9.11.

> I don't see how this could be inversed, that is an attack exploiting
> multicast encrypted with PTK.

Yeah, you're right, anyone who is in possession of a PTK better also be
able to send multicast frames *anyway* somehow.

> > Overall, it seems to me we should do the following:
> 
> I'm wondering if all this filtering is actually required or if it
> filters out more than required?

It seems it should be required?

> >  * pass DA == RA for client mode (not when 4-addr)
> 
> If this implies that encapsulating multicast as unicast A-MSDU is not
> permitted, then why? This would break multicast to unicast using A-
> MSDU frames, which currently works with most clients for me.

But arguably it shouldn't work unless DMS was negotiated? However, I
also don't see an attack vector right now, since, as I wrote above,
peers in possession of a PTK should have a way to send multicast frames
anyway.


> >  * pass both on TDLS links
> 
> I don't know why TDLS links should carry multicast at all, so this
> seems reasonable to me.

Yeah, they can't really carry multicast traffic.

> >  * pass both for IBSS mode (I think)
> 
> Why is multicast to unicast not permitted within IBSS?

Well, you're thinking of this only from a multicast angle and I was
thinking only from a "fake DA/SA" angle.

Combining the two, I suppose we could accept a multicast DA even when a
DA match was requested.

Obviously, when no DA match is requested, like in the AP (or VLAN)
case, this question is irrelevant. When a DA match *is* requested, i.e.
cases where we have real multicast over the air (client/IBSS/TDLS),
arguably inner multicast should *not* be accepted by spec, since the
multicast DA cannot map to a unicast RA.

I'll send out a patch or two to fix the most glaring issues here, and
we can continue discussing the inner-L2 filtering.

johannes
