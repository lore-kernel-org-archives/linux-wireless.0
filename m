Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57067 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab1BWWak (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 17:30:40 -0500
Date: Wed, 23 Feb 2011 17:28:43 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Nathaniel Smith <njs@pobox.com>
Cc: linux-wireless@vger.kernel.org, bloat-devel@lists.bufferbloat.net,
	johannes@sipsolutions.net, nbd@openwrt.org
Subject: Re: [RFC v2] mac80211: implement eBDP algorithm to fight bufferbloat
Message-ID: <20110223222842.GA20039@tuxdriver.com>
References: <1297907356-3214-1-git-send-email-linville@tuxdriver.com>
 <1298064074-8108-1-git-send-email-linville@tuxdriver.com>
 <AANLkTikJeN=CG20PAj-n1ZoaiJLbsiG=jfZnbu4Or3KS@mail.gmail.com>
 <20110221184716.GD9650@tuxdriver.com>
 <AANLkTi=LnpFLzKbtaPxSjg9TRU_pY2oRi6tsFg5GkaGK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AANLkTi=LnpFLzKbtaPxSjg9TRU_pY2oRi6tsFg5GkaGK@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 21, 2011 at 03:26:32PM -0800, Nathaniel Smith wrote:
> On Mon, Feb 21, 2011 at 10:47 AM, John W. Linville
> <linville@tuxdriver.com> wrote:

> > I tried to see how your measurement would be useful, but I just don't
> > see how the number of frames ahead of me in the queue is relevant to
> > the measured link latency?  I mean, I realize that having more packets
> > ahead of me in the queue is likely to increase the latency for this
> > frame, but I don't understand why I should use that information to
> > discount the measured latency...?
> 
> It depends on which latency you want to measure. The way that I
> reasoned was, suppose that at some given time, the card is able to
> transmit 1 fragment every T nanoseconds. Then it can transmit n
> fragments in n*T nanoseconds, so if we want the queue depth to be 2
> ms, then we have
>   n * T = 2 * NSEC_PER_MSEC
>   n = 2 * NSEC_PER_MSEC / T
> 
> Which is the calculation that you're doing:
> 
> +                       sta->sdata->qdata[q].max_enqueued =
> +                               max_t(int, 2, 2 * NSEC_PER_MSEC / tserv_ns_avg);
> 
> But for this calculation to make sense, we need T to be the time it
> takes the card to transmit 1 fragment. In your patch, you're not
> measuring that. You're measuring the total time between when a packet
> is enqueued and when it is transmitted; if there were K packets in the
> queue ahead of it, then this is the time to send *all* of them --
> you're measuring (K+1)*T. That's why in my patch, I recorded the
> current size of the queue when each packet is enqueued, so I could
> compute T = total_time / (K+1).

Thanks for the math!  I think I see what you are saying now.  Since the
measured time is being used to determine the queue size, we need to
factor-in the length of the queue that resulted in that measurment.

Unfortunately, I'm not sure how to apply this with the technique I
am using for the timing measurements. :-(  I'll have to think about
this some more...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
