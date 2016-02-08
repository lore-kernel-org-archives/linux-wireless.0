Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:55183 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbcBHLXq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2016 06:23:46 -0500
Subject: Re: [RFC v4] mac80211: add A-MSDU tx support
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
References: <1454920723-48071-1-git-send-email-nbd@openwrt.org>
 <CANUX_P2qQmCPvFV4SqWxGQb_JzVqQ+_nT6LFtcYb37s5KfEfdw@mail.gmail.com>
 <CABPxzY+dgMWDeQ=_c0xyFq0g7HcP459b5Ypy3OoUwjDi+eooMA@mail.gmail.com>
 <56B87625.6040206@openwrt.org>
 <CABPxzY+ub1Qtwawzge2XCo67OPba1Rgd6HZTm6bhjzfOuNtFEw@mail.gmail.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <56B87ABA.5000307@openwrt.org> (sfid-20160208_122349_625832_DC6D20DB)
Date: Mon, 8 Feb 2016 12:23:38 +0100
MIME-Version: 1.0
In-Reply-To: <CABPxzY+ub1Qtwawzge2XCo67OPba1Rgd6HZTm6bhjzfOuNtFEw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-02-08 12:06, Krishna Chaitanya wrote:
> On Mon, Feb 8, 2016 at 4:34 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>> On 2016-02-08 10:54, Krishna Chaitanya wrote:
>>> On Mon, Feb 8, 2016 at 2:56 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>>> On Mon, Feb 8, 2016 at 10:38 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>>>>> Requires software tx queueing support. frag_list support (for zero-copy)
>>>>> is optional.
>>>>>
>>>>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>>>>> ---
>>>>
>>>>
>>>> Ok - looks fine, but... and here comes the hard stuff.
>>>> The frame size in the PLCP is limited in a way that you can't - from a
>>>> spec POV - enable A-MSDU for low rates. Of course, you don't want to
>>>> do that for low rates at all regardless of the spec.
>>>> Since you build the A-MSDU in the mac80211 Tx queue which is not aware
>>>> of the link quality, how do we prevent A-MSDU if the rate is low /
>>>> dropping.
>>>> I'd even argue that when the rates get lower, you'll  have more
>>>> packets piling up in the software queue and ... even more chance to
>>>> get A-MSDU in the exact case where you really want to avoid it?
>>>
>>> Similar to triggering AMPDU setup, we should put this control
>>> in RC (minstrel) to start/stop AMSDU based on link quality/if the rates
>>> drop below a pre-defined MCS (or) only for best-throughput rates.
>> I think starting/stopping A-MSDU based on the rate is a bad idea.
>> Even with low rates, using A-MSDU can be a good thing (especially for
>> TCP ACKs), it just needs different size limits.
> 
> By low rates, i was referring to bad channel conditions (more
> retries/crc errors)
> so using AMSDU might trigger more TCP level retries and for case
> of TCP ACK's its still worse in that it triggers TCP data retires from the
> peer.
Based on the research and data from the Bufferbloat project, I'd say
that in this case the latency due to queue buildup is a lot more harmful
than lost packets.
With unmanaged queues, the latency will cause unnecessary
retransmissions anyway.
With managed queues, packet drops start increasing with latency until
TCP starts behaving properly.
In both cases you have extra TCP retransmissions...

With bad conditions you also get a strong increase in per-TXOP latency.
With A-MSDU you need fewer TXOPs for the same amount of data in the queue.

- Felix
