Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39619 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab1BQE0r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Feb 2011 23:26:47 -0500
Received: by bwz15 with SMTP id 15so1329441bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Feb 2011 20:26:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297907356-3214-1-git-send-email-linville@tuxdriver.com>
References: <1297619803-2832-1-git-send-email-njs@pobox.com>
	<1297907356-3214-1-git-send-email-linville@tuxdriver.com>
Date: Wed, 16 Feb 2011 20:26:44 -0800
Message-ID: <AANLkTimmvCFWU4v1Q2=vV4xa1kOaTcGABLwFcayHxcG9@mail.gmail.com>
Subject: Re: [RFC] mac80211: implement eBDP algorithm to fight bufferbloat
From: Nathaniel Smith <njs@pobox.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	nbd@openwrt.org, bloat-devel@lists.bufferbloat.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 16, 2011 at 5:49 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> I'm sure this isn't ideal.  This should be combined with the ALT
> algorithm to yield the A* algorithm.  There are parameters that
> probably should be tunable (or at least better researched).  This may
> not be ideal for 802.11n -- it may even be detrimental to it.

Excellent!

General thoughts:

I think you're wiping out any interrupt mitigation any drivers are
doing, because they'll never get filled up to even their low water
mark? (http://article.gmane.org/gmane.linux.kernel.wireless.general/64843
has a scheme for adapting the eBDP idea to interrupt mitigation)

It's important to keep in mind the distinction between:
 -- a host's total tx buffer
 -- the individual queues that make up that buffer
In Linux we have two queues in serial, the net subsystem's Qdisc
thing, which feeds the driver's tx queue. It's this distinction that
makes it reasonable to shrink the tx queue down to really tiny sizes
(a few ms), because while a router needs a few hundred milliseconds
(~a RTT) of *total* buffering to absorb bursty packet arrivals, we
want as much of that buffering as possible to be happening in the
Qdisc, where it can have AMQ and QoS and applied.

A* is an algorithm for estimating the right total host buffer size.

(Of course, we might want to just disable the Qdisc buffering and move
everything inside the driver -- Felix Fietkau is considering this[1],
because when aggregating you really want a separate buffer per
destination STA, and there's no easy way to do this with the current
system -- but obviously that raises its own issues...)

[1] https://lists.bufferbloat.net/pipermail/bloat-devel/2011-February/000013.html

> @@ -212,6 +216,11 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
>                if (memcmp(hdr->addr2, sta->sdata->vif.addr, ETH_ALEN))
>                        continue;
>
> +               atomic_dec(&sta->sdata->enqueued);
> +
> +               /* factor current tserv into service time estimate */
> +               ewma_add(&sta->sdata->tserv_ns_avg, ktime_to_ns(tserv));
> +

I think you're calculating the total time that the packet was resident
in the queue, and treating it like the time to service a single
packet. In my patch I also stored the current queue length at the time
the packet was enqueued, and then divided the time delta by the number
of packets that were serviced in that time.

> @@ -1323,6 +1325,20 @@ static int __ieee80211_tx(struct ieee80211_local *local,
>
>                sdata = vif_to_sdata(info->control.vif);
>
> +               /* test for queue admission qualifications */
> +               tserv_ns_avg = ewma_read(&sdata->tserv_ns_avg);
> +               /* constants 2 msec and offset 5 should be tunable? */
> +               max_enqueued = 2 * NSEC_PER_MSEC / tserv_ns_avg + 5;

5 packets worth of fudge factor seems high. I can measure 15-20 ms
single packet service times here just by turning down to 1Mbs on an
uncontended network; the Li et al paper you link has a graph
suggesting that on contented networks, 50-100 ms/packet is not
uncommon. (And even if I don't force my card to 1Mbs, with my patch
I'm still seeing appropriate buffer sizes in the 1-2 packet range.) So
you may be unconditionally adding a few hundred milliseconds of
latency here.

They make a good point that you might want some extra space to absorb
short-term fluctuations in packet service times, but I think it'd make
more sense to do that by clamping the queue length to some minimum
value (2 packets?), and possibly bumping up the magic "2 ms" constant.
Or be even more clever and estimate the standard deviation of the
single packet service times...

(http://en.wikipedia.org/wiki/Algorithms_for_calculating_variance#On-line_algorithm)

> +               if (atomic_read(&sdata->enqueued) > max_enqueued) {
> +                       /* silently drop */
> +                       dev_kfree_skb(skb);
> +                       return IEEE80211_TX_OK;
> +               }

Shouldn't you be stopping the queue, too?

I think by leaving the queue open and discarding everything, you
effectively disable the net layer's Qdisc buffering, which might also
be a factor in your observations of reduced bufferbloat :-).

-- Nathaniel
