Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:58194 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbeHWKZc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 06:25:32 -0400
Message-ID: <1535007433.9999.2.camel@sipsolutions.net> (sfid-20180823_085748_831005_F5A31D75)
Subject: Re: FTM/measurement APIs
From: Johannes Berg <johannes@sipsolutions.net>
To: Lior David <liord@codeaurora.org>, linux-wireless@vger.kernel.org
Date: Thu, 23 Aug 2018 08:57:13 +0200
In-Reply-To: <eea4129b-b994-ff31-2397-a1630b8a8e9a@codeaurora.org>
References: <1534766611.6287.20.camel@sipsolutions.net>
         <eea4129b-b994-ff31-2397-a1630b8a8e9a@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Lior,

> Yes AOA (angle of arrival) is based on CIR(channel impulse response) or CFR
> (channel frequency response). Our 11ad chip can do CIR but most other chips do
> CFR (I think). AOA finds azimuth and elevation from CIR by running some
> algorithm in user space and using a database. Not sure how easy it is to offload
> to FW. Anyhow I suggest calling the measurement CIR or CFR and not mentioning
> AOA, since the CIR/CFR can be useful for other stuff.

Right.

> > The other option is to restrict this new API to doing "peer-related"
> > measurements, and build the list like this:
> > 
> > Peer-Measurement(
> >   - [timeout]
> >   - [MAC randomization]
> >   - global FTM options
> >     - ...
> >   - global angle options
> >     - ...
> >   - peers
> >     0: - MAC address
> >        - channel
> >        - FTM
> >          - ... [FTM settings]
> >        - Angle
> >          - ... [Angle settings]
> >     1: - MAC address
> >        - channel
> >        - ...
> > )
> > 
> > This is less generic, since it's restricted to a list of MAC/channel
> > pairs as the list of targets, and you can't add any other non-target
> > measurements to do simultaneously, at least not directly in this
> > structure. We could possibly still add it, but it would be more complex.
> > 
> > (And maybe the global options aren't really needed, for FTM the only one
> > I can think of is "request associated AP TSF" but that could be a per-
> > peer setting too.)
> > 
> > 
> > In a way, I prefer the second option. It's far simpler to start out
> > with, technically could be extended to non-peer measurements (though not
> > as cleanly perhaps), and matches the various location use cases far
> > better.
> > 
> 
> I also prefer the second option. It is both simpler and allows the driver to
> better organize the measurements (for example, in our implementation we always
> do CIR at the beginning or end of FTM burst).

I don't think it matters much to the driver - to organize them in a
certain way, it could walk both lists first and build a combined list.

However, come to think of it, it's also more obvious in this (second)
way that this will actually happen, i.e. that the measurements are more
or less simultaneous. If you organize it like the first way, you could
argue more that you just requested two measurements, nothing about their
relative time, whereas here you're at least requesting two measurements
for each peer.

> We had some "exotic" measurements that we wanted to support but none are
> critical as far as I remember...

If you remember any, let me know, but I guess it doesn't matter all that
much for this discussion if we already agree :)

> I can provide more detailed comments when you send actual nl80211 API (I think I
> gave most comments to Luca but can find them again).

I think what Luca gave me was your comments, but I'll double-check.

johannes
