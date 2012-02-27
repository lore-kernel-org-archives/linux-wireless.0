Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37872 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab2B0PmF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 10:42:05 -0500
Subject: Re: mac80211 queue handling in multi-channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Dave Taht <dave.taht@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Eliad Peller <eliad@wizery.com>, Jouni Malinen <j@w1.fi>
In-Reply-To: <CAA93jw4X-8x=V6WZstAwM8GyicN_ds8WHv8uYz4zF8d-KdNTsg@mail.gmail.com> (sfid-20120227_161059_020700_D617FF5D)
References: <1330343374.3483.46.camel@jlt3.sipsolutions.net>
	 <CAA93jw4X-8x=V6WZstAwM8GyicN_ds8WHv8uYz4zF8d-KdNTsg@mail.gmail.com>
	 (sfid-20120227_161059_020700_D617FF5D)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Feb 2012 16:42:02 +0100
Message-ID: <1330357322.3483.53.camel@jlt3.sipsolutions.net> (sfid-20120227_164208_681111_190C8E48)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-02-27 at 16:10 +0100, Dave Taht wrote:
> On Mon, Feb 27, 2012 at 12:49 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> 
> > As a consequence, I'm thinking that we should redesign the mac80211 /
> > driver queue API to mirror more closely the kind of queues hardware
> > really has.
> 
> I'd like the driver queues to mirror more closely the kinds of
> connections the hardware really has. I realize that this is more of an
> AP orientation than a wireless client orientation, but with wildly
> different rates between connected devices bad things happen.

This isn't possible -- having 4 netdev queues per remote station is,
simply put, insane. We've discussed this before on this list and Eric
had a few suggestions, but I have no time to work on them. Essentially
though it boils down to solving the problem at a higher layer by
differentiating traffic to different stations.

> Secondly, my take on 802.11e QoS and wireless-n aggregation is that
> aggregation wins nearly every time; all
> 802.11e does is bloat up the buffers.

That statement doesn't really make sense to me -- QoS (on the air) and
aggregation are two unrelated things?

> > Thus when e.g. in our driver the BE queue for the second VIF is full, we
> > stop all traffic across all VIFs. When both VIFs are on the same
> > channel, this isn't really a problem. However, when they are on
> > different channels, there could be vastly different performance
> > characteristics on those two channels due to interference etc.
> 
> And even more differences based on the destination's characteristics.

I do understand that this is true, but we don't have the ability to
solve this problem at the netdev queue level.

johannes

