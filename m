Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36465 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbcDFHRC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 03:17:02 -0400
Received: by mail-wm0-f47.google.com with SMTP id v188so12360433wme.1
        for <linux-wireless@vger.kernel.org>; Wed, 06 Apr 2016 00:17:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2233FCEB-7412-4F22-B262-068AFBB2FDCB@gmail.com>
References: <1458898052-20601-1-git-send-email-michal.kazior@tieto.com>
	<1459420104-31554-1-git-send-email-michal.kazior@tieto.com>
	<1459420104-31554-2-git-send-email-michal.kazior@tieto.com>
	<1459864656.18188.60.camel@sipsolutions.net>
	<CA+BoTQmkGhyPGRuT8GJOfdYyGGckZZA0JMZF+G3uk8KGAwLKvg@mail.gmail.com>
	<2233FCEB-7412-4F22-B262-068AFBB2FDCB@gmail.com>
Date: Wed, 6 Apr 2016 09:16:59 +0200
Message-ID: <CA+BoTQmTviPfR-xsKB2gNa_epVJJ1JO4Ke=sKt27Xefn=OAQuw@mail.gmail.com> (sfid-20160406_091711_987525_D0672927)
Subject: Re: [Make-wifi-fast] [PATCHv2 1/2] mac80211: implement fair queuing
 per txq
From: Michal Kazior <michal.kazior@tieto.com>
To: Jonathan Morton <chromatix99@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	make-wifi-fast@lists.bufferbloat.net,
	linux-wireless <linux-wireless@vger.kernel.org>,
	codel@lists.bufferbloat.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 April 2016 at 08:03, Jonathan Morton <chromatix99@gmail.com> wrote:
>
>> On 6 Apr, 2016, at 08:35, Michal Kazior <michal.kazior@tieto.com> wrote:
>>
>> Packets can be destined to different stations/txqs. At enqueue time I
>> do a partial hash of a packet to get an "index" which I then use to
>> address a txq_flow from per-radio list (out of 4096 of them). You can
>> end up with a situtation like this:
>> - packet A hashing to X destined to txq P which is VI
>> - packet B hashing to X destined to txq Q which is BK
>>
>> You can't use the same txq_flow for both A and B because you want to
>> maintain packets per txqs more than you want to maintain them per flow
>> (you don't want to queue BK traffic onto VI or vice versa as an
>> artifact, do you? ;). When a txq_flow doesn't have a txqi it is bound.
>> Later, if a collision happens (i.e. resulting txq_flow has non-NULL
>> txqi) the "embedded" per-txq flow is used:
>>
>>  struct txq_info {
>> -     struct sk_buff_head queue;
>> +     struct txq_flow flow; // <--- this
>>
>> When txq_flow becomes empty its txqi is reset.
>>
>> The embedded flow is otherwise treated like any other flow, i.e. it
>> can be linked to old_flows and new_flows.
>
> This smells like a very fragile and complex solution to the collision problem.  You may want to look at how Cake solves it.
>
> I use a separate pool of flows per traffic class (essentially, VO/VI/BE/BK), and there is also a set-associative hash to take care of the birthday problem.  The latter has an order-of-magnitude effect on the general flow collision rate once you get into the tens of flows, for very little CPU cost.

When a driver asks mac80211 to dequeue given txq it implies a
destination station as well. This is important because 802.11
aggregation can be performed only on groups of packets going to a
single station on a single tid.

Cake - as I understand it - doesn't really *guarantee* maintaining
this. Keep in mind you can run with hundreds of stations connected.

You don't really want to burden drivers with sorting this grouping up
themselves (and hence coerce them into introducing another level of
intermediate queues, bis).

Without the per-txq fallback flow (regardless of using fq_codel-like
scheme or cake-like scheme in mac80211) you'll need to modify
codel_dequeue() itself to compensate and re-queue/skip frames not
belonging to requested txq.

I'm not sure it's worth it for initial fair-queuing implementation.


Michał
