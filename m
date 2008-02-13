Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:11143 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758216AbYBMXbZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2008 18:31:25 -0500
Received: by wa-out-1112.google.com with SMTP id v27so299775wah.23
        for <linux-wireless@vger.kernel.org>; Wed, 13 Feb 2008 15:31:24 -0800 (PST)
Message-ID: <1ba2fa240802131531u46634558o46d4ff4f8b8c3d4a@mail.gmail.com> (sfid-20080213_233130_074343_CB154D32)
Date: Thu, 14 Feb 2008 01:31:23 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: mac80211: net_sched vs. HT
Cc: "Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1202889691.8931.25.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1202489552.24811.10.camel@johannes.berg>
	 <1ba2fa240802100830t772b245fgf9e54ae058b384fa@mail.gmail.com>
	 <1202889691.8931.25.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 13, 2008 10:01 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> > I don't really follow your question. The dummy functions in wme.h for
> > wme were there before we added only ht functions.
>
> Yes I know.
>
> > WME i.e. QoS is not defined when NET_SCHED is not defined. This is
> > more for code completeness then for anything else, in fact with do not
> > compile mac80211 without NET_SCHED support
> > Valid QoS STA  is when there is  QoS association and support 4 AC, etc
>
> Yes but we still fill in WMM information elements and announce QoS
> support w/o NET_SCHED which seems to be wrong, especially with HT.
> That's what I was trying to get at. Should that be dependent on
> NET_SCHED? I think it should so that we don't announce QoS/HT support
> when we don't have QoS in the kernel.

There is no use of QoS and HT without NET_SCHD so we should not
announce support for HT or QoS in that configuration but I'm not sure
if it's worth the effort to compile mac80211 without NET_SCHED.

>
> > AMPDU queues and also 4 AC queues are after all funneled to 4 AC lower
> > level queues we called them TX FIFOS, which are configured according
> > QoS parameters (not upper queues, but that's transparent). The major
> > purpose of AMPDU queue is handling reordering not AC.
>
> Right, that's what I thought. I guess the decision on how many frames to
> aggregate in a single AMPDU is made by firmware then? Doesn't really
> matter anyway.

The number or aggregated frames in AMPDU is determined by handshake
maximum is 64
IIRC but also dynamically but how many frames fits into TXOP and this
is also function of how fast are packets brought the HW

> In any case, I think this confirms my idea of splitting up the "queues"
> hardware specific value into "queues" and "ampdu_queues" where "queues"
> are the number of FIFOs with QoS parameters and "ampdu_queues" are the
> number of helper DMA queues for ampdu support.

That would fit perfectly

Broadcom doesn't seem to
> use extra DMA queues for this, the aggregation decisions are (afaik
> since the hw has no extra queues I can find) all made in the driver. I
> suppose b43 will then have to fake a reasonable number of "ampdu_queues"
> and handle it in the driver.

Not sure how retransmission is handled. Where a  packet sits when it
fails transmission in the single aggregation... that would be a major
concern.

> > In general for example in AP mode you would need to handle <number of
> > associated station>x<#TID=8> AMPDU queues which can come to a horrible
> > number.
> > The limited number of queues is acceptable again due to fact that
> > medium is shared and you cannot really utilize too many BA ssessions
> > at the same time. Some policy of eviction based on link quality is
> > required and still not implemented.
>
> Expected traffic too, I would think, no? If the traffic from/to a
> specific station drops below a threshold I would expect to tear down the
> BA session.

That's what we would do part of rate scaling... currently only the
establishment is done not tear down.

Hope we soon free our schedule to push this little.
Thanks
Tomas
