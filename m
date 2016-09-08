Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53866 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754584AbcIHUSl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Sep 2016 16:18:41 -0400
Subject: Re: [RFC] mac80211: Dynamically set CoDel parameters per station.
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
References: <20160908195915.31478-1-toke@toke.dk>
Cc: Michal Kazior <michal.kazior@tieto.com>, Dave Taht <dave@taht.net>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <2663e4fb-bcdf-a872-f5ab-fac3bb5344c1@nbd.name> (sfid-20160908_221844_510410_D2E3E542)
Date: Thu, 8 Sep 2016 22:18:37 +0200
MIME-Version: 1.0
In-Reply-To: <20160908195915.31478-1-toke@toke.dk>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-09-08 21:59, Toke Høiland-Jørgensen wrote:
> CoDel can be too aggressive if a station sends at a very low rate. This
> gets worse the more stations are present, as each station gets more
> bursty the longer the round-robin scheduling between stations takes.
> 
> This is an attempt to dynamically adjust CoDel parameters per station.
> It takes a rather simple approach and uses a simple binary designation
> of a station as 'slow' if it has expected throughput less than eight
> Mbps (i.e. the lowest couple of rates). In this case, CoDel is set to be
> more lenient by adjusting its target to 50 ms and interval to 300 ms.
> There's a built-in hysteresis so a station cannot flip between slow and
> fast more than once every two seconds.
> 
> In this version the check is performed every time a packet is enqueued
> to the intermediate queues; and the overhead of doing this is alleviated
> a bit by caching the result and by the above-mentioned hysteresis. It
> can probably be smarter about both when and how to do the scaling, but
> this seems to alleviate some of the starvation I've seen with very slow
> stations.
Since this is not dealing properly with firmware rate control anyway,
I'd suggest calling the update from rate_control_set_rates in order to
avoid putting more stuff into the tx hot path.

You could add a separate code path to allow firmware rate control
devices to provide a hint at a convenient point in time.

- Felix
