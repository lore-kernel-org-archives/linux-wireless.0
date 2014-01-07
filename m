Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:47395 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaAGQ3p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 11:29:45 -0500
Message-ID: <1389112179.4645.37.camel@jlt4.sipsolutions.net> (sfid-20140107_172948_790625_24C9DE23)
Subject: Re: [RFC] cfg80211: Advertise maximum associated STAs in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 07 Jan 2014 17:29:39 +0100
In-Reply-To: <20140107161241.GA9092@w1.fi>
References: <20140106081151.GA1613@w1.fi>
	 <1389110063.4645.21.camel@jlt4.sipsolutions.net>
	 <20140107161241.GA9092@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-01-07 at 18:12 +0200, Jouni Malinen wrote:
> On Tue, Jan 07, 2014 at 04:54:23PM +0100, Johannes Berg wrote:
> > In theory, I think this is fine. In practice, I'm not sure it really
> > covers things too well, and some drivers like iwlwifi might end up not
> > being able to set it. The reason is that we have a limit of ~16 stations
> > internally, but some may be used for BSS/P2P-client interfaces and some
> > are used internally. In addition, when TDLS will be added, concurrency
> > might mean that we'd have to set this to a very low number although it
> > is likely that you'd never have P2P-GO, BSS clientand TDLS all together.
> 
> I think both cases of limiting associated stations will need to be
> supported. It can be useful for user space to be aware of some limits
> and there are cases where at least 1 vs. 2 vs. 16 vs. 128 can be easily
> indicated even if some of the values are not accurate (e.g., that 16 may
> actually mean 10 in some cases, etc.).

Is such a limit advertised anywhere? I can't think of a reason why a
static limit would be superior to a dynamic one? Maybe if we'd want to
restrict it to 8 to have enough station entries for the other use cases,
but then we could do that in the code as well?

Anyway, I'm not really objecting much to this, I'm just not convinced
it's sufficient, and if we need a more dynamic mechanism anyway I'm not
sure it really buys us much.


> >     nl80211/mac80211: support full station state in AP mode

> I'm trying to remember why this did not get used, but cannot really
> remember..

Laziness on my part. I had originally started working on this, based on
some patch from TI/wizery (but which was broken in a few scenarios) and
then eventually ran out of time to follow through.

> It would sound useful to support this regardless of the
> question of how maximum supported association state count is handled.

Indeed.

> While these do have some use cases in common, not all cases can be
> addressed with this, or well, cannot be addressed cleanly. I would hate
> to have make wpa_supplicant add a dummy station entry into the driver
> just to figure out whether one more station can be added..

Why dummy? Are there cases where it needs to know whether one can be
added without actually doing so? And if so, would a "heuristic" like the
count really help much?

> There are use cases where an AP advertises in Beacon/Probe Response
> frames information about how preferable it is for stations to try to
> associate with it. I'd expect this area to get used more in the future,
> but even now, there is an example that I can give of a deployed
> functionality. 

Ah, ok.

> P2P has a P2P Group Limit field which the GO uses to
> advertise in Beacon/Probe Response frames to indicate that no more P2P
> Clients can join the group. wpa_supplicant supports this functionality,
> but currently, requires user (or well, whoever is building the system)
> to configure the maximum limit. This is an extra complexity that could
> be easily avoided for cases where the driver were able to advertise the
> maximum number of associated stations.

Right, indeed. That does indicate a need for such a limit. I wonder if a
more dynamic approach (such as an event saying 'I just ran out of
space') would be preferable? But it'd obviously be far more complex, so
may not be worth it.

johannes

