Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f51.google.com ([209.85.214.51]:52217 "EHLO
	mail-bw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab1BUXcM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 18:32:12 -0500
Received: by bwz10 with SMTP id 10so2645194bwz.10
        for <linux-wireless@vger.kernel.org>; Mon, 21 Feb 2011 15:32:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110221184716.GD9650@tuxdriver.com>
References: <1297907356-3214-1-git-send-email-linville@tuxdriver.com>
	<1298064074-8108-1-git-send-email-linville@tuxdriver.com>
	<AANLkTikJeN=CG20PAj-n1ZoaiJLbsiG=jfZnbu4Or3KS@mail.gmail.com>
	<20110221184716.GD9650@tuxdriver.com>
Date: Mon, 21 Feb 2011 15:26:32 -0800
Message-ID: <AANLkTi=LnpFLzKbtaPxSjg9TRU_pY2oRi6tsFg5GkaGK@mail.gmail.com>
Subject: Re: [RFC v2] mac80211: implement eBDP algorithm to fight bufferbloat
From: Nathaniel Smith <njs@pobox.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bloat-devel@lists.bufferbloat.net,
	johannes@sipsolutions.net, nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 21, 2011 at 10:47 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Fri, Feb 18, 2011 at 07:44:30PM -0800, Nathaniel Smith wrote:
>> On Fri, Feb 18, 2011 at 1:21 PM, John W. Linville
>> <linville@tuxdriver.com> wrote:
>> > +       /* grab timestamp info for buffer control estimates */
>> > +       tserv = ktime_sub(ktime_get(), skb->tstamp);
>> [...]
>> > +               ewma_add(&sta->sdata->qdata[q].tserv_ns_avg,
>> > +                        ktime_to_ns(tserv));
>>
>> I think you're still measuring how long it takes one packet to get
>> from the end of the queue to the beginning, rather than measuring how
>> long it takes each packet to go out?
>
> Yes, I am measuring how long the driver+device takes to release each
> skb back to me (using that as a proxy for how long it takes to get
> the fragment to the next hop).  Actually, FWIW I'm only measuring
> that time for those skb's that result in a tx status report.
>
> I tried to see how your measurement would be useful, but I just don't
> see how the number of frames ahead of me in the queue is relevant to
> the measured link latency?  I mean, I realize that having more packets
> ahead of me in the queue is likely to increase the latency for this
> frame, but I don't understand why I should use that information to
> discount the measured latency...?

It depends on which latency you want to measure. The way that I
reasoned was, suppose that at some given time, the card is able to
transmit 1 fragment every T nanoseconds. Then it can transmit n
fragments in n*T nanoseconds, so if we want the queue depth to be 2
ms, then we have
  n * T = 2 * NSEC_PER_MSEC
  n = 2 * NSEC_PER_MSEC / T

Which is the calculation that you're doing:

+                       sta->sdata->qdata[q].max_enqueued =
+                               max_t(int, 2, 2 * NSEC_PER_MSEC / tserv_ns_avg);

But for this calculation to make sense, we need T to be the time it
takes the card to transmit 1 fragment. In your patch, you're not
measuring that. You're measuring the total time between when a packet
is enqueued and when it is transmitted; if there were K packets in the
queue ahead of it, then this is the time to send *all* of them --
you're measuring (K+1)*T. That's why in my patch, I recorded the
current size of the queue when each packet is enqueued, so I could
compute T = total_time / (K+1).

Under saturation conditions, K+1 will always equal max_enqueued, so I
guess in your algorithm, at the steady state we have

  max_enqueued = K+1 = 2 * NSEC_PER_MSEC / ((K+1) * T)
  (K+1)^2 = 2 * NSEC_PER_MSEC / T
  K+1 = sqrt(2 * NSEC_PER_MSEC / T)

So I think under saturation, you converge to setting the queue to the
square root of the appropriate size?

-- Nathaniel
